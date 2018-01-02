$PBExportHeader$u_transaction_output.sru
$PBExportComments$Object for administration of transactions, and generating file and prints
forward
global type u_transaction_output from nonvisualobject
end type
end forward

global type u_transaction_output from nonvisualobject
end type
global u_transaction_output u_transaction_output

type variables
datastore ids_a_transactions
datastore ids_b_transactions
datastore ids_print_trans_report
datastore ids_allowed_vessels   // list of vessels user can create transctions for
datastore ids_retrans
double id_debit_sum, id_credit_sum
boolean ib_retrans = False
private string is_sql
integer ii_count_cms = 0
integer ii_count_coda = 0
// Next variable used to control print of d_settled_disb_report
// equal to F07_DOCNUM
string is_tx_number

end variables

forward prototypes
public subroutine uf_destroy_datastore ()
public function integer uf_insert_filedata (string as_filename)
public function integer of_print_trans_report ()
public function long of_create_retrans_datastore ()
public subroutine of_insert_or (ref string as_where)
public subroutine of_insert_and (ref string as_where)
public subroutine of_set_docnum (string as_type, integer ai_counter)
public subroutine uf_retrieve_b (double ad_trans_key)
public subroutine uf_set_filter (string as_type)
public subroutine uf_create_datastore ()
public function long of_retrieve_a ()
public function string of_getsql ()
public function integer of_setsql (string as_sqlstring)
public subroutine uf_prepare_transactions ()
public function double of_getmaxtransactionnumber (string as_type)
end prototypes

public subroutine uf_destroy_datastore ();/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Destroying the datastores.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
************************************************************************************/
DESTROY ids_a_transactions
DESTROY ids_b_transactions


end subroutine

public function integer uf_insert_filedata (string as_filename);/***********************************************************************************
Creator:	Teit Aunt
Date:		11-05-1999
Purpose:	Insert the file name, date and user into the datawindow and update the 
			database.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
11-05-99		1.0		ta			Initial version
02-06-99		1.1		ta			Expand with retransmission functionality
************************************************************************************/
integer li_return, li_row_no, li_count, li_update, li_retrans_rows
string ls_user_id, ls_filename
datetime ldt_date
double ldb_trans_key
long ll_ret

// Get data for insertion
//if IsValid(uo_global) then
	ls_user_id = sqlca.userid
//	ls_user_id = ""
//else
//	ls_user_id = ""
//end if



li_row_no = ids_a_transactions.RowCount()

If ib_retrans Then
	// Create retrans datastore
	ll_ret = of_create_retrans_datastore()
	
	// Copy the retransmitted rows to the retrans log
	FOR li_count = 1 TO li_row_no
		ls_user_id = ids_a_transactions.GetItemString(li_count,"file_user")
		If IsNull(ls_user_id) Then ls_user_id = ""
		ldt_date = ids_a_transactions.GetItemDateTime(li_count,"file_date")
		If IsNull(ldt_date) Then ldt_date = DateTime(Today())
		ls_filename = ids_a_transactions.GetItemString(li_count,"file_name")
		If IsNull(ls_filename) Then ls_filename = ""
		ldb_trans_key = ids_a_transactions.GetItemNumber(li_count,"trans_key")
		If IsNull(ldb_trans_key) Then ldb_trans_key = 0
		
		li_retrans_rows = ids_retrans.InsertRow(0)
		ids_retrans.SetItem(li_retrans_rows,"hist_date",ldt_date)
		ids_retrans.SetItem(li_retrans_rows,"hist_user",ls_user_id)
		ids_retrans.SetItem(li_retrans_rows,"hist_description",ls_filename)
		ids_retrans.SetItem(li_retrans_rows,"trans_key",ldb_trans_key)
	NEXT

	// Update the retrans datastore
	If ids_retrans.Update(true,false) = 1 Then
		COMMIT;
	Else
		ROLLBACK;
		MessageBox("Error","It was not possible to save retransmitted transactions to the history log. ")
		Return(-1)
	End if
	
	// Destroy the retrans datastore
	DESTROY ids_retrans
	
End if

FOR li_count = 1 TO li_row_no
	ids_a_transactions.SetItem(li_count,"file_date",Today())
	ids_a_transactions.SetItem(li_count,"file_user",ls_user_id)
	ids_a_transactions.SetItem(li_count,"file_name",as_filename)
NEXT

If ids_a_transactions.Update(true,false) = 1 THEN
	If ids_b_transactions.Update(true,false) = 1 THEN
		COMMIT;
		Return(1)
	Else
		MessageBox("Error", "It was not possible to insert file data into the Transaction Log window")
		ROLLBACK;
		Return(-1)
	End if	
Else
	ROLLBACK;
	Return(-1)
End if
	

end function

public function integer of_print_trans_report ();/***********************************************************************************
Creator:	Kim F. Nielsen
Date:		27-05-1999
Purpose:	Prints the Transaction report
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
27-05-99		1.0		KFN		Initial version
************************************************************************************/
Integer li_row, li_rows, li_key
long ll_return
 
//Initiate datastore for transaction report with composite report "d_trans_report"
ids_print_trans_report = CREATE datastore
ids_print_trans_report.Dataobject = 'd_comp_trans_report'
ids_print_trans_report.SetTransObject(SQLCA)

li_rows = ids_a_transactions.rowcount()

//Step through ids_a_transactions and print all of them
FOR li_row = 1 to li_rows
	li_key = ids_a_transactions.GetItemNumber(li_row, "trans_key") 
	//Retrieve and print datastore
	ll_return = ids_print_trans_report.retrieve(li_key)

	IF ids_print_trans_report.print(TRUE) <> 1 THEN
		messagebox("info", "A fail occoured while trying to print the Transaction Report for Transaction key " &
						+string(li_key)+ " ~n Transaction Report is NOT printed. ~n Print job canceled")
		RETURN 0
	END IF
NEXT

DESTROY ids_print_trans_report
messagebox("info", "Transaction Report is succesfully generated and printed")
Return 1
end function

public function long of_create_retrans_datastore ();/***********************************************************************************
Creator:	Teit Aunt
Date:		02-06-1999
Purpose:	Create the retrans datastore
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
02-06-99		1.0		ta			Initial version
************************************************************************************/

// Create retrans datastore
ids_retrans = CREATE datastore

ids_retrans.Dataobject = 'd_retrans_log'
ids_retrans.SetTransObject(SQLCA)
Return(ids_retrans.Retrieve())


end function

public subroutine of_insert_or (ref string as_where);/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Inserts an OR in the end of the where string that the function is called with.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
08-06-99		1.0		ta			Initial version.
************************************************************************************/

as_where += ' OR '
end subroutine

public subroutine of_insert_and (ref string as_where);/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Inserts an AND in the end of the where string that the function is called with.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
08-06-99		1.0		ta			Initial version.
************************************************************************************/

as_where += ' AND '
end subroutine

public subroutine of_set_docnum (string as_type, integer ai_counter);/***********************************************************************************
Creator:	Teit Aunt
Date:		09-06-1999
Purpose:	Set the Docnum field to enabled or disabled depending on the type choosen in
			the type filter on the Transaction Log window.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
08-06-99		1.0		ta			Initial version
************************************************************************************/

// If a cms type is unselected add -1 and if a cms type is selected add 1 to the cms counter
If as_type = "CMS" Then ii_count_cms = ii_count_cms + ai_counter

// If a coda type is unselected add -1 and if a coda type is selected add 1 to the coda counter
If as_type = "CODA" Then ii_count_coda = ii_count_coda + ai_counter

// If all is selected set both counters to 4 and if unselected to 0
If as_type = "All" And ai_counter = 1 Then 
	ii_count_cms = 4
	ii_count_coda = 4
Elseif as_type = "All" And ai_counter = -1 Then 
	ii_count_cms = 0
	ii_count_coda = 0
End if

// Set the docnum fields according to the counters
If ii_count_cms = 0 And ii_count_coda > 0 Then
	w_transaction_log_list.st_doc_num.Text = "Doc.Num(CODA):"
	w_transaction_log_list.sle_docno_from.Enabled = True
	w_transaction_log_list.sle_docno_to.Enabled = True
Elseif ii_count_cms > 0 And ii_count_coda = 0 Then
	w_transaction_log_list.st_doc_num.Text = "Doc.Num(CMS):"
	w_transaction_log_list.sle_docno_from.Enabled = True
	w_transaction_log_list.sle_docno_to.Enabled = True
Elseif (ii_count_cms = 0 And ii_count_coda = 0) Or (ii_count_cms > 0 And ii_count_coda > 0) Then
	w_transaction_log_list.st_doc_num.Text = "Doc. Number:"
	w_transaction_log_list.sle_docno_from.Text = ""
	w_transaction_log_list.sle_docno_from.Enabled = False
	w_transaction_log_list.sle_docno_to.Text = ""
	w_transaction_log_list.sle_docno_to.Enabled = False
End if


end subroutine

public subroutine uf_retrieve_b (double ad_trans_key);/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Retrieve the B transactions for the datastore
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
06-05-99		1.0		ta			Initial version
************************************************************************************/

ids_b_transactions.Retrieve(ad_trans_key)
end subroutine

public subroutine uf_set_filter (string as_type);/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Creating the filter for the list window to find the transactions that will
			be used for the creation of the CMS file.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
01-06-99		1.1		ta			Retransmitting function created
************************************************************************************/
String ls_filter

// Set the filter acording to the type of transaction
CHOOSE CASE as_type
	CASE "CMS"
		If ib_retrans Then
			ls_filter = "trans_disable = 0 and (Not(IsNull(file_user))) And (trans_type ="+" 'Claims' "+ "or trans_type ="+"'CommClaim'" &
									+ "or trans_type ="+"'CommTC'"+ "or trans_type ="+"'TCCMSPay'"+ "or trans_type ="+"'TCCMSRec'"+ "or trans_type ="+"'DisbPay'"+")"
		Else							
			ls_filter = "trans_disable = 0 and IsNull(file_user) and (trans_type ="+" 'Claims' "+ "or trans_type ="+"'CommClaim'" &
									+ "or trans_type ="+"'CommTC'"+ "or trans_type ="+"'TCCMSPay'"+ "or trans_type ="+"'TCCMSRec'"+ "or trans_type ="+"'DisbPay'"+")"							
		End if
	CASE "CODA"
		If ib_retrans Then
			ls_filter = "trans_disable = 0 and (Not(IsNull(file_user))) and (trans_type ="+" 'Calc' "+ "or trans_type ="+"'CommBatch'" &
									+ "or trans_type ="+"'Bunker'"+ "or trans_type ="+"'BunkerTCBS'" + "or trans_type ="+"'BunkerTCLP'" &
									+ "or trans_type = " + "' BunkerTCB '" + "or trans_type = " + "'BunkerTCS '" &
									+ "or trans_type ="+"'TCCODAPay'" + "or trans_type ="+"'TCCODARec'" + "or trans_type ="+"'DisbExp'"&
									+ "or trans_type ="+"'TCCODAComm'" + "or trans_type ="+"'CommClaimC'" +  ")"
		Else
			ls_filter = "trans_disable = 0 and IsNull(file_user) and (trans_type ="+" 'Calc' "+ "or trans_type ="+"'CommBatch'" &
									+ "or trans_type ="+"'Bunker'"+ "or trans_type ="+"'BunkerTCBS'" + "or trans_type ="+"'BunkerTCLP'" &
									+ "or trans_type = " + "' BunkerTCB '" + "or trans_type = " + "'BunkerTCS '" &
									+ "or trans_type ="+"'TCCODAPay'" + "or trans_type ="+"'TCCODARec'" + "or trans_type ="+"'DisbExp'"&
									+ "or trans_type ="+"'TCCODAComm'" + "or trans_type ="+"'CommClaimC'" +  ")"
		End if
END CHOOSE

// Set filter 
ids_a_transactions.SetFilter(ls_filter)
ids_a_transactions.Filter()

end subroutine

public subroutine uf_create_datastore ();/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Create the datastores.
***********************************************************************************/

// Lav a_transactions datastore 
ids_a_transactions = CREATE datastore
ids_a_transactions.Dataobject = 'd_transaction_log_list'
ids_a_transactions.SetTransObject(SQLCA)

// lav b_transaction datastore
ids_b_transactions = CREATE datastore
ids_b_transactions.Dataobject = 'd_trans_b'
ids_b_transactions.SetTransObject(SQLCA)

ids_allowed_vessels = CREATE datastore
ids_allowed_vessels.Dataobject = 'd_sq_tb_vessel_ref_numbers_by_bu'
ids_allowed_vessels.SetTransObject(SQLCA)

// Share to the datawindows
ids_a_transactions.ShareData(w_transaction_log_list.dw_transaction_log_list)

end subroutine

public function long of_retrieve_a ();/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Retrieve the A transactions for the datastore
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
06-05-99		1.0		ta			Initial version.
17-05-99		1.1		ta			Inserting check for null in the disable value field.
31-05-99		1.0		ta			Initial version of the retrieval argument
07-06-99		1.2		ta			Retrieval arguments and the retrieve command in same 
										function to support multiple retrieval arguments.
************************************************************************************/
Integer li_return, li_bu_by
long ll_rows, ll_count, ll_disable, ll_docno_from, ll_docno_to, ll_row, ll_retrieved_rows
string ls_select, ls_where, ls_file_name, ls_vessel_no, ls_voyage_no, ls_invoice_no, ls_docnum, ls_file_date_from_1, &
			ls_file_date_to, ls_trans_date_from_1, ls_trans_date_to, ls_doc_no_from, ls_doc_no_to, &
			ls_docno_from, ls_docno_to, ls_sql, ls_select_return, ls_file_by, ls_filename, ls_trans_date_from_2, &
			ls_file_date_from_2
date ld_file_date_from_1, ld_file_date_from_2, ld_file_date_to, ld_trans_date_from_1, ld_trans_date_from_2, &
			ld_trans_date_to
boolean lb_file_date_from, lb_file_date_to, lb_trans_date_from, lb_trans_date_to, lb_cms_type, &
			lb_coda_type, lb_docno_from, lb_docno_to, lb_or, lb_where

// Grab the select statement from the Log window datawindow
ls_select = is_sql

// Do accepttext to make sure all data get registered
w_transaction_log_list.dw_transaction_log_list.AcceptText()

// Create the where clause from the filter settings in the log window
ls_where = " "
lb_cms_type = False
lb_coda_type = False
lb_or = False
lb_where = False

// Get the type data 
//M5-3 Begin added by ZSW001 on 07/01/2012
if w_transaction_log_list.cbx_axclaims.checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "Claims" '
	lb_coda_type = true
	lb_or = true
	lb_where = true
	of_insert_or(ls_where)
end if
//M5-3 End added by ZSW001 on 07/01/2012

If w_transaction_log_list.cbx_claims.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "Claims" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if	

If w_transaction_log_list.cbx_variations.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "Calc" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_claims_commission.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "CommClaim" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_batch_commission.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "CommBatch" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_bunker_consumption.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "Bunker" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tc_commission.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "CommTC" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_disb_expenses.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "DisbExp" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_agent_payment.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "DisbPay" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_bunkerbs.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "BunkerTCBS" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

//M5-10 Added by WWG004 on 28/03/2012. Change desc:Add two filter bunker buy/sell.
If w_transaction_log_list.cbx_bunkerbuy.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "BunkerTCB" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_bunkersell.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "BunkerTCS" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if
//M5-10 Added by WWG004 on 28/03/2012 end.

If w_transaction_log_list.cbx_bunkerlp.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "BunkerTCLP" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tc_commission_coda.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "TCCODAComm" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_claims_commission_coda.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "CommClaimC" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tccodapay.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "TCCODAPay" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tccodarec.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "TCCODARec" '
	lb_coda_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tccmspay.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "TCCMSPay" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

If w_transaction_log_list.cbx_tccmsrec.Checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "TCCMSRec" '
	lb_cms_type = True
	lb_or = True
	lb_where = True
	of_insert_or(ls_where)
End if

//M5-8 Added by LGX001 on 07/03/2012.
if w_transaction_log_list.cbx_voyage_estimates.checked then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_TYPE = "Estimates" '
	lb_cms_type = true
	lb_or = true
	lb_where = true
	of_insert_or(ls_where)
end if



// Remove the last OR and insert an AND
If lb_or Then
	ls_where = "( " + ls_where
	ls_where = Left(ls_where,Len(ls_where) - 3)
	ls_where += ') AND '
End if

// The vessel number argument
ls_vessel_no = w_transaction_log_list.sle_vessel_no.Text
//If ls_vessel_no <> " " And IsNumber(ls_vessel_no) Then   /* modified when alphanumeric vessels where introduced */
If ls_vessel_no <> "" and len(ls_vessel_no) = 3 Then
	ls_vessel_no = "V" + upper(ls_vessel_no)
	ls_where += 'TRANS_LOG_MAIN_A.F15_EL5 = "'+ls_vessel_no+'" '
	lb_where = True
	of_insert_and(ls_where)
Elseif Not(ls_vessel_no = "") And Not IsNumber(ls_vessel_no) Then
	MessageBox("Error","The number in the Vessel# field is not correct. Vessel# must be 3 characters long.")
End if

// The voyage number argument
ls_voyage_no = w_transaction_log_list.sle_voyage_no.Text
If ls_voyage_no <> " " And IsNumber(ls_voyage_no) Then
	ls_voyage_no = "T" + ls_voyage_no
	ls_where += 'TRANS_LOG_MAIN_A.F16_EL6 = "'+ls_voyage_no+'" '
	lb_where = True
	of_insert_and(ls_where)
Elseif Not(ls_voyage_no = "") And Not IsNumber(ls_voyage_no) Then
	MessageBox("Error","The number in the Voyage No. field is not a number. Use only numbers.")
End if

//M5-3 Begin added by ZSW001 on 07/01/2012
ls_invoice_no = w_transaction_log_list.sle_invoiceno.text
if trim(ls_invoice_no) <> "" then
	ls_where += 'TRANS_LOG_MAIN_A.AX_INVOICE_NR = "' + ls_invoice_no + '" '
	lb_where = true
	of_insert_and(ls_where)
end if
//M5-3 End added by ZSW001 on 07/01/2012

// The file date argument
w_transaction_log_list.dw_file_date_from.AcceptText()
ll_row = w_transaction_log_list.dw_file_date_from.GetRow()
ls_file_date_from_1 = String(w_transaction_log_list.dw_file_date_from.GetItemDate(ll_row,"date_value"))

w_transaction_log_list.dw_file_date_to.AcceptText()
ll_row = w_transaction_log_list.dw_file_date_to.GetRow()
ls_file_date_to = String(w_transaction_log_list.dw_file_date_to.GetItemDate(ll_row,"date_value"))
lb_file_date_from = False
lb_file_date_to = False

// Validate file dates
If ls_file_date_from_1 <> "" And IsDate(ls_file_date_from_1) Then
	ld_file_date_from_1 = Date(ls_file_date_from_1)
	ls_file_date_from_1 = String(ld_file_date_from_1,"yyyy-mm-dd")
	ls_file_date_from_2 = String(RelativeDate(ld_file_date_from_1,1),"yyyy-mm-dd")
	lb_file_date_from = True
Elseif Not IsDate(ls_file_date_from_1) And Not(ls_file_date_from_1 = "") Then
	MessageBox("Error","The date in File From Date is not a valid date")
End if

If ls_file_date_to <> "" And IsDate(ls_file_date_to) Then
	ld_file_date_to = Date(ls_file_date_to)
	ls_file_date_to = String(ld_file_date_to,"yyyy-mm-dd")
	lb_file_date_to = True
Elseif Not IsDate(ls_file_date_to) And Not(ls_file_date_to = "") Then
	MessageBox("Error","The date in File To Date is not a valid date")
End if

// Insert file date in the where-clause
If lb_file_date_from And Not(lb_file_date_to) Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_DATE >= "'+ls_file_date_from_1+'" '
	of_insert_and(ls_where)
	ls_where += 'TRANS_LOG_MAIN_A.FILE_DATE <= "'+ls_file_date_from_2+'" '
	lb_where = True
	of_insert_and(ls_where)
Elseif lb_file_date_from And lb_file_date_to Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_DATE >= "'+ls_file_date_from_1+'" '
	of_insert_and(ls_where)
	ls_where += 'TRANS_LOG_MAIN_A.FILE_DATE <= "'+ls_file_date_to+'" '
	of_insert_and(ls_where)
	lb_where = True
Elseif Not(lb_file_date_from) And lb_file_date_to Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_DATE <= "'+ls_file_date_to+'" '
	lb_where = True
	of_insert_and(ls_where)	
End if

// The trans date argument
w_transaction_log_list.dw_trans_date_from.AcceptText()
ll_row = w_transaction_log_list.dw_trans_date_from.GetRow()
ls_trans_date_from_1 = String(w_transaction_log_list.dw_trans_date_from.GetItemDate(ll_row,"date_value"))

w_transaction_log_list.dw_trans_date_to.AcceptText()
ll_row = w_transaction_log_list.dw_trans_date_to.GetRow()
ls_trans_date_to = String(w_transaction_log_list.dw_trans_date_to.GetItemDate(ll_row,"date_value"))
lb_trans_date_from = False
lb_trans_date_to = False

// Validate trans dates
If ls_trans_date_from_1 <> "" And IsDate(ls_trans_date_from_1) Then
	ld_trans_date_from_1 = Date(ls_trans_date_from_1)
	ls_trans_date_from_1 = String(ld_trans_date_from_1,"yyyy-mm-dd")
	ls_trans_date_from_2 = String(RelativeDate(ld_trans_date_from_1,1),"yyyy-mm-dd")
	lb_trans_date_from = True
Elseif Not IsDate(ls_trans_date_from_1) And Not(ls_trans_date_from_1 = "") Then
	MessageBox("Error","The date in Trans From Date is not a valid date")
End if

If ls_trans_date_to <> "" And IsDate(ls_trans_date_to) Then
	ld_trans_date_to = Date(ls_trans_date_to)
	ls_trans_date_to = String(ld_trans_date_to,"yyyy-mm-dd")
	lb_trans_date_to = True
Elseif Not IsDate(ls_trans_date_to) And Not(ls_trans_date_to = "") Then
	MessageBox("Error","The date in Trans To Date is not a valid date")
End if

// Insert trans date in the where-clause
If lb_trans_date_from And Not(lb_trans_date_to) Then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DATE >= "'+ls_trans_date_from_1+'" '
	of_insert_and(ls_where)
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DATE <= "'+ls_trans_date_from_2+'" '
	lb_where = True
	of_insert_and(ls_where)
Elseif lb_trans_date_from And lb_trans_date_to Then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DATE >= "'+ls_trans_date_from_1+'" '
	of_insert_and(ls_where)
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DATE <= "'+ls_trans_date_to+'" '
	lb_where = True
	of_insert_and(ls_where)
Elseif Not(lb_trans_date_from) And lb_trans_date_to Then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DATE <= "'+ls_trans_date_to+'" '
	lb_where = True
	of_insert_and(ls_where)	
End if

// The Doc num argument
ls_docno_from = w_transaction_log_list.sle_docno_from.Text
ls_docno_to = w_transaction_log_list.sle_docno_to.Text
lb_docno_from = False
lb_docno_to = False

// Validate docno from
If Not IsNumber(ls_docno_from) And ls_docno_from <> "" Then 
	MessageBox("Error","The number in the Doc No From field is not a valid number. Use only numbers.")
Elseif IsNumber(ls_docno_from) And ls_docno_from <> "" Then
	If (ii_count_cms > 0) And (ii_count_coda = 0) Then
		ll_docno_from = long(ls_docno_from)
		ls_docno_from = string(ll_docno_from,"00000000")
		ls_docno_from = "TY" + ls_docno_from //TY = CMS
		lb_docno_from = True
	Elseif (ii_count_cms = 0) And (ii_count_coda > 0) Then
		ll_docno_from = long(ls_docno_from)
		ls_docno_from = string(ll_docno_from,"0000000000")
		ls_docno_from = "TX" + ls_docno_from //TX = CODA
		lb_docno_from = True
	End if
End if

// Validate docno to
If Not IsNumber(ls_docno_to) And ls_docno_to <> "" Then 
	MessageBox("Error","The number in the Doc No To field is not a valid number. Use only numbers.")
Elseif IsNumber(ls_docno_to) And ls_docno_to <> "" Then 
	If (ii_count_cms > 0) And (ii_count_coda = 0) Then
		ll_docno_to = long(ls_docno_to)
		ls_docno_to = string(ll_docno_to,"00000000")
		ls_docno_to = "TY" + ls_docno_to
		lb_docno_to = True
	Elseif (ii_count_cms = 0) And (ii_count_coda > 0) Then
		ll_docno_to = long(ls_docno_to)
		ls_docno_to = string(ll_docno_to,"0000000000")
		ls_docno_to = "TX" + ls_docno_from 
		lb_docno_to = True
	End if
End if

// If type is only CMS or CODA create clause for docnum
If (lb_cms_type And Not(lb_coda_type)) Or (Not(lb_cms_type) And lb_coda_type) Then
	If lb_docno_from And Not(lb_docno_to) Then
		ls_where += 'TRANS_LOG_MAIN_A.F07_DOCNUM = "'+ls_docno_from+'" '
		lb_where = True
		of_insert_and(ls_where)
	Elseif lb_docno_from And lb_docno_to Then
		ls_where += 'TRANS_LOG_MAIN_A.F07_DOCNUM >= "'+ls_docno_from+'" '
		of_insert_and(ls_where)
		ls_where += 'TRANS_LOG_MAIN_A.F07_DOCNUM <= "'+ls_docno_to+'" '
		of_insert_and(ls_where)
		lb_where = True
	Elseif Not(lb_docno_from) And lb_docno_to Then
		ls_where += 'TRANS_LOG_MAIN_A.F07_DOCNUM >= "'+ls_docno_to+'" '
		of_insert_and(ls_where)
		lb_where = True
	End if
End if

// The status argument. If all has been checked nothing is done
If w_transaction_log_list.rb_new.Checked = True Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_NAME = NULL '
	of_insert_and(ls_where)
	lb_where = True
Elseif w_transaction_log_list.rb_transfered.Checked = True Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_NAME <> "" '
	of_insert_and(ls_where)
	lb_where = True
Elseif w_transaction_log_list.rb_disabled.Checked = True Then
	ls_where += 'TRANS_LOG_MAIN_A.TRANS_DISABLE = 1 '
	of_insert_and(ls_where)
	lb_where = True
End if

// The File name argument
ls_file_name = w_transaction_log_list.sle_file_name.Text
If ls_file_name <> "" Then
	ls_where += 'UPPER(TRANS_LOG_MAIN_A.FILE_NAME) = "'+ls_file_name+'" '
	of_insert_and(ls_where)
	lb_where = True
End if

// The File user argument
ls_file_by = w_transaction_log_list.sle_log_by.Text
If ls_file_by <> "" Then
	ls_where += 'TRANS_LOG_MAIN_A.FILE_USER = "'+ls_file_by+'" '
	of_insert_and(ls_where)
	lb_where = True
End if


// Last 3 years filter

If w_transaction_log_list.cbx_last3years.checked then
	ls_where += '(datediff(day,FILE_DATE,getdate()) <= 730 or FILE_DATE is null)'
	of_insert_and(ls_where)
	lb_where = True	
end if

// Remove the last AND and insert a WHERE in the begining of the clause
If lb_where Then
	ls_where = " WHERE " + ls_where
	ls_where = Left(ls_where, Len(ls_where) - 4)
	ls_where = ls_where + " "
End if
 
// Retrieve the data
ls_sql = ls_select + ls_where
ls_select_return = ids_a_transactions.Modify("Datawindow.Table.Select = ' "+ls_sql+" ' ")

If ls_select_return = "" Then
	ll_retrieved_rows = ids_a_transactions.Retrieve()
	Commit;
End if

// Make sure that there are no null values in the transaction disable field
ll_rows = ids_a_transactions.RowCount()

For ll_count = 1 To ll_rows
	ll_disable = ids_a_transactions.GetItemNumber(ll_count,"trans_disable")
	If IsNull(ll_disable) Then 
		ll_disable = 0
		ids_a_transactions.SetItem(ll_count,"trans_disable",ll_disable)
	End if
Next

return ll_retrieved_rows
end function

public function string of_getsql ();return is_sql
end function

public function integer of_setsql (string as_sqlstring);is_sql = as_sqlstring
return 1
end function

public subroutine uf_prepare_transactions ();/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Calls u_transaction_output to generate files for CMS and CODA
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
22-06-99		1.1		KFN		Check if transfer is off 
30-06-99		1.2		KFN		Implementation of Automatic file transfer to MQSeries
23-04-01		2.0		TAU		The investigation of whether it is possible to generate
										a file is moved to the open event of the w-transaction_window.
04-01-10		21.6		AGL		stuff..						
************************************************************************************/

// Declare local variables
Integer li_cms_return, li_coda_return, li_return
String ls_user, ls_generation_message
Long ll_row_num, ll_rows, ll_total_ready=0
datetime ldt_today
double ld_maxCMStrans_nr, ld_maxCODAtrans_nr


// loop through datastore and change 3 cols filename=READY, now and the username. Replace the call in this funct.
ls_user = uo_global.getuserid()
ldt_today = datetime(today())

ll_rows = ids_a_transactions.rowcount( )
ids_allowed_vessels.retrieve( ls_user )

/* Get the maximum transactions numbers from the Transaction log */
ld_maxCMStrans_nr = of_getMaxTransactionNumber( "CMS" ) 
ld_maxCODAtrans_nr = of_getMaxTransactionNumber( "CODA" ) 

for ll_row_num = 1 to ll_rows
	/* this validation will check if the user is allowed to generate 
		transactions for a given vessel
		if Finance superuser/administrator ignore check */
		string ls_find
		ls_find ="v_ref_nr = '"+ids_a_transactions.getItemString(ll_row_num, "F15_EL5")+"'"
	if uo_global.ii_access_level = 1 then   // if user is a normal user we apply test
		if ids_allowed_vessels.find("v_ref_nr = '" &
		+ids_a_transactions.getItemString(ll_row_num, "F15_EL5")+"'",1,9999999) = 0 then	
			continue
		end if
	end if
	
	if ids_a_transactions.getitemnumber( ll_row_num, "trans_disable")=1 then
		ids_a_transactions.setitem( ll_row_num, "file_name", "Locked" )
	else
		ids_a_transactions.setitem( ll_row_num, "file_name", "Ready" )

		/* Set docnumber for CMS or CODA based on the transaction type */
		choose case  ids_a_transactions.getitemString( ll_row_num, "trans_type" )
			/* CMS */ 
			case "Claims", "CommClaim", "CommTC", "TCCMSPay", "TCCMSRec", "DisbPay"
				ld_maxCMStrans_nr ++
				ids_a_transactions.setitem( ll_row_num, "f07_docnum", "TY"+string(ld_maxCMStrans_nr,"00000000"))
			/* CODA */ 
			case "Calc", "CommBatch", "Bunker", "BunkerTCBS", "BunkerTCB", "BunkerTCS", "BunkerTCLP", "TCCODAPay", "TCCODARec", "DisbExp", "TCCODAComm", "CommClaimC"
				ld_maxCODAtrans_nr ++
				ids_a_transactions.setitem( ll_row_num, "f07_docnum", "TX"+string(ld_maxCODAtrans_nr,"0000000000"))
		end choose

	end if
	ids_a_transactions.setitem( ll_row_num, "file_date", ldt_today )
	ids_a_transactions.setitem( ll_row_num, "file_user", ls_user)
	ll_total_ready++
next


if ids_a_transactions.update()=1 then
	commit;
else	
	messagebox("Error","There is a problem")
	rollback;
end if
	
of_retrieve_a()

if ll_total_ready=0 then
	Messagebox("Info","No CMS/CODA transactions prepared.  This may be due to no transactions being available in your business unit.")
else
	// Display message to user of the file generation results
	Messagebox("Info",string(ll_total_ready)+" CMS/CODA transaction(s) prepared for transfer")
end if



end subroutine

public function double of_getmaxtransactionnumber (string as_type);/***********************************************************************************
Creator:	Teit Aunt
Date:		18-05-1999
Purpose:	Find the max value for the F07 field for CODA or CMS
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
18-05-99		1.0		ta			Initial version
************************************************************************************/

String ls_max07

CHOOSE CASE as_type
	CASE "CMS"
		SELECT MAX(substring(F07_DOCNUM,3,8))
		INTO :ls_max07
		FROM TRANS_LOG_MAIN_A
		WHERE (TRANS_TYPE = "Claims" or
				TRANS_TYPE = "CommClaim" or
				TRANS_TYPE = "CommTC" or
				TRANS_TYPE = "TCCMSPay" or
				TRANS_TYPE = "TCCMSRec" or
				TRANS_TYPE = "CommTC" or
				TRANS_TYPE = "DisbPay");
	CASE "CODA"
		SELECT MAX(substring(F07_DOCNUM,3,10))
		INTO :ls_max07
		FROM TRANS_LOG_MAIN_A
		WHERE (TRANS_TYPE = "Variations" or
				TRANS_TYPE = "CommBatch" or
				TRANS_TYPE = "Bunker" or
				TRANS_TYPE = "BunkerTCBS" or
				TRANS_TYPE = "BunkerTCB" or
				TRANS_TYPE = "BunkerTCS" or
				TRANS_TYPE = "BunkerTCLP" or
				TRANS_TYPE = "TCCODAPay" or
				TRANS_TYPE = "TCCODARec" or
				TRANS_TYPE = "BunkerTCLP" or
				TRANS_TYPE = "DisbExp" or
				TRANS_TYPE = "Calc" or
				TRANS_TYPE = "TCCODAComm" or
				TRANS_TYPE = "CommClaimC"	);
		if isnull(ls_max07) then ls_max07 = "0"		
		is_tx_number = "TX" + string(round(Double(ls_max07),0)+1,"0000000000")
END CHOOSE

COMMIT;

// Return result
Return(Double(ls_max07))
end function

on u_transaction_output.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_transaction_output.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

