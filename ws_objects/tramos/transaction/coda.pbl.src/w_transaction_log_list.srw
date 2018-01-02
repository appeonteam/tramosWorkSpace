$PBExportHeader$w_transaction_log_list.srw
$PBExportComments$Window for administering the transaction log and MQSeries file generation.
forward
global type w_transaction_log_list from window
end type
type cb_ackcreditnotes from commandbutton within w_transaction_log_list
end type
type cbx_bunkersell from checkbox within w_transaction_log_list
end type
type cbx_bunkerbuy from checkbox within w_transaction_log_list
end type
type cbx_voyage_estimates from checkbox within w_transaction_log_list
end type
type sle_invoiceno from singlelineedit within w_transaction_log_list
end type
type st_invoiceno from statictext within w_transaction_log_list
end type
type gb_activated from groupbox within w_transaction_log_list
end type
type gb_deactivated from groupbox within w_transaction_log_list
end type
type cb_saveas from commandbutton within w_transaction_log_list
end type
type cbx_claims_commission_coda from checkbox within w_transaction_log_list
end type
type cbx_tc_commission_coda from checkbox within w_transaction_log_list
end type
type cbx_last3years from checkbox within w_transaction_log_list
end type
type cbx_bunkerlp from checkbox within w_transaction_log_list
end type
type cbx_bunkerbs from checkbox within w_transaction_log_list
end type
type cbx_tccmsrec from checkbox within w_transaction_log_list
end type
type cbx_tccmspay from checkbox within w_transaction_log_list
end type
type cbx_tccodarec from checkbox within w_transaction_log_list
end type
type cbx_tccodapay from checkbox within w_transaction_log_list
end type
type cb_print from commandbutton within w_transaction_log_list
end type
type dw_file_date_from from datawindow within w_transaction_log_list
end type
type dw_file_date_to from datawindow within w_transaction_log_list
end type
type rb_transfered from radiobutton within w_transaction_log_list
end type
type rb_disabled from radiobutton within w_transaction_log_list
end type
type cb_reset_filters from commandbutton within w_transaction_log_list
end type
type cb_sort from commandbutton within w_transaction_log_list
end type
type sle_voyage_no from singlelineedit within w_transaction_log_list
end type
type sle_log_by from singlelineedit within w_transaction_log_list
end type
type sle_vessel_no from singlelineedit within w_transaction_log_list
end type
type sle_file_name from singlelineedit within w_transaction_log_list
end type
type st_9 from statictext within w_transaction_log_list
end type
type st_8 from statictext within w_transaction_log_list
end type
type st_7 from statictext within w_transaction_log_list
end type
type st_6 from statictext within w_transaction_log_list
end type
type sle_docno_to from singlelineedit within w_transaction_log_list
end type
type sle_docno_from from singlelineedit within w_transaction_log_list
end type
type st_5 from statictext within w_transaction_log_list
end type
type st_4 from statictext within w_transaction_log_list
end type
type st_doc_num from statictext within w_transaction_log_list
end type
type st_2 from statictext within w_transaction_log_list
end type
type st_1 from statictext within w_transaction_log_list
end type
type rb_new from radiobutton within w_transaction_log_list
end type
type rb_status_all from radiobutton within w_transaction_log_list
end type
type cb_retransmit_log from commandbutton within w_transaction_log_list
end type
type cb_retransmit from commandbutton within w_transaction_log_list
end type
type cb_print_trans_report from commandbutton within w_transaction_log_list
end type
type cb_disable_reason from commandbutton within w_transaction_log_list
end type
type cb_update from commandbutton within w_transaction_log_list
end type
type cbx_variations from checkbox within w_transaction_log_list
end type
type cbx_batch_commission from checkbox within w_transaction_log_list
end type
type cbx_disb_expenses from checkbox within w_transaction_log_list
end type
type cbx_bunker_consumption from checkbox within w_transaction_log_list
end type
type cbx_agent_payment from checkbox within w_transaction_log_list
end type
type cbx_tc_commission from checkbox within w_transaction_log_list
end type
type cbx_claims_commission from checkbox within w_transaction_log_list
end type
type cbx_claims from checkbox within w_transaction_log_list
end type
type cbx_all from checkbox within w_transaction_log_list
end type
type cb_retrieve_transactions from commandbutton within w_transaction_log_list
end type
type cb_close from commandbutton within w_transaction_log_list
end type
type cb_generate_file from commandbutton within w_transaction_log_list
end type
type cb_open_transaction from commandbutton within w_transaction_log_list
end type
type gb_other from groupbox within w_transaction_log_list
end type
type gb_dates_numbers from groupbox within w_transaction_log_list
end type
type gb_status from groupbox within w_transaction_log_list
end type
type gb_1 from groupbox within w_transaction_log_list
end type
type dw_trans_date_from from datawindow within w_transaction_log_list
end type
type dw_trans_date_to from datawindow within w_transaction_log_list
end type
type dw_transaction_log_list from datawindow within w_transaction_log_list
end type
type cbx_axclaims from checkbox within w_transaction_log_list
end type
end forward

global type w_transaction_log_list from window
integer x = 91
integer y = 368
integer width = 4640
integer height = 2564
boolean titlebar = true
string title = "Transaction Log"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 81324524
cb_ackcreditnotes cb_ackcreditnotes
cbx_bunkersell cbx_bunkersell
cbx_bunkerbuy cbx_bunkerbuy
cbx_voyage_estimates cbx_voyage_estimates
sle_invoiceno sle_invoiceno
st_invoiceno st_invoiceno
gb_activated gb_activated
gb_deactivated gb_deactivated
cb_saveas cb_saveas
cbx_claims_commission_coda cbx_claims_commission_coda
cbx_tc_commission_coda cbx_tc_commission_coda
cbx_last3years cbx_last3years
cbx_bunkerlp cbx_bunkerlp
cbx_bunkerbs cbx_bunkerbs
cbx_tccmsrec cbx_tccmsrec
cbx_tccmspay cbx_tccmspay
cbx_tccodarec cbx_tccodarec
cbx_tccodapay cbx_tccodapay
cb_print cb_print
dw_file_date_from dw_file_date_from
dw_file_date_to dw_file_date_to
rb_transfered rb_transfered
rb_disabled rb_disabled
cb_reset_filters cb_reset_filters
cb_sort cb_sort
sle_voyage_no sle_voyage_no
sle_log_by sle_log_by
sle_vessel_no sle_vessel_no
sle_file_name sle_file_name
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
sle_docno_to sle_docno_to
sle_docno_from sle_docno_from
st_5 st_5
st_4 st_4
st_doc_num st_doc_num
st_2 st_2
st_1 st_1
rb_new rb_new
rb_status_all rb_status_all
cb_retransmit_log cb_retransmit_log
cb_retransmit cb_retransmit
cb_print_trans_report cb_print_trans_report
cb_disable_reason cb_disable_reason
cb_update cb_update
cbx_variations cbx_variations
cbx_batch_commission cbx_batch_commission
cbx_disb_expenses cbx_disb_expenses
cbx_bunker_consumption cbx_bunker_consumption
cbx_agent_payment cbx_agent_payment
cbx_tc_commission cbx_tc_commission
cbx_claims_commission cbx_claims_commission
cbx_claims cbx_claims
cbx_all cbx_all
cb_retrieve_transactions cb_retrieve_transactions
cb_close cb_close
cb_generate_file cb_generate_file
cb_open_transaction cb_open_transaction
gb_other gb_other
gb_dates_numbers gb_dates_numbers
gb_status gb_status
gb_1 gb_1
dw_trans_date_from dw_trans_date_from
dw_trans_date_to dw_trans_date_to
dw_transaction_log_list dw_transaction_log_list
cbx_axclaims cbx_axclaims
end type
global w_transaction_log_list w_transaction_log_list

type variables
u_transaction_output iuo_transaction_output
Boolean ib_release
Boolean ib_generateAllowed


end variables

forward prototypes
public subroutine wf_reset_filters ()
public subroutine wf_set_type_filter (boolean ab_onoff)
public subroutine documentation ()
end prototypes

public subroutine wf_reset_filters ();/***********************************************************************************
Creator:	Teit Aunt
Date:		10-06-1999
Purpose:	Reset all filters to the default values.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
10-06-99		1.0		ta			Initial version.
************************************************************************************/
long ll_row

// Delete contents of all fields
sle_docno_from.Text = ""
sle_docno_to.Text = ""

ll_row = dw_file_date_from.GetRow()
dw_file_date_from.SetText("00-00-0000")
dw_file_date_from.AcceptText()
dw_file_date_from.Modify("DataWindow.Color = 12632256")
dw_file_date_from.Enabled = False

ll_row = dw_file_date_to.GetRow()
dw_file_date_to.SetText("00-00-0000")
dw_file_date_to.AcceptText()
dw_file_date_to.Modify("DataWindow.Color = 12632256")
dw_file_date_to.Enabled = False

ll_row = dw_trans_date_from.GetRow()
dw_trans_date_from.SetText("00-00-0000")
dw_trans_date_from.AcceptText()

ll_row = dw_trans_date_to.GetRow()
dw_trans_date_to.SetText("00-00-0000")
dw_trans_date_to.AcceptText()

sle_file_name.Text = ""
sle_log_by.Text = ""
sle_vessel_no.Text = ""
sle_voyage_no.Text = ""
sle_invoiceno.text = ""		//CRM5-3 Added by ZSW001 on 07/01/2012

// Disable docnum, file by and file name fields
sle_docno_from.Enabled = False
sle_docno_to.Enabled = False
sle_file_name.Enabled = False
sle_log_by.Enabled = False

// Set radio buttons
rb_status_all.Checked = True

// Set checkboxes
cbx_last3years.Checked = True

// Blank type fields
wf_set_type_filter(False)
end subroutine

public subroutine wf_set_type_filter (boolean ab_onoff);/***********************************************************************************
Creator:	Teit Aunt
Date:		10-06-1999
Purpose:	Set the type filter on the window.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
10-06-99		1.0		ta			Initial version.
************************************************************************************/

If ab_onoff Then
	cbx_claims.Checked = True
	cbx_variations.Checked = True
	cbx_claims_commission.Checked = True
	cbx_batch_commission.Checked = True
	cbx_bunker_consumption.Checked = True
	cbx_tc_commission.Checked = True
	cbx_disb_expenses.Checked = True
	cbx_agent_payment.Checked = True
	cbx_tccmspay.Checked = True
	cbx_tccmsrec.Checked = True
	cbx_tccodapay.Checked = True
	cbx_tccodarec.Checked = True
	cbx_bunkerbs.Checked = True
	cbx_bunkerlp.Checked = True
	cbx_claims_commission_coda.Checked = True
	cbx_tc_commission_coda.Checked = True
	cbx_axclaims.checked = true		//M5-5 Added by ZSW001 on 10/01/2012
	cbx_voyage_estimates.checked = true   //M5-8 Added by LGX001 on 05/03/2012.
	
	//M5-10 added by WWG004 on 28/03/2012
	cbx_bunkerbuy.checked = true
	cbx_bunkersell.checked = true
Elseif Not(ab_onoff) Then
	cbx_all.Checked = False
	cbx_claims.Checked = False
	cbx_variations.Checked = False
	cbx_claims_commission.Checked = False
	cbx_batch_commission.Checked = False
	cbx_bunker_consumption.Checked = False
	cbx_tc_commission.Checked = False
	cbx_disb_expenses.Checked = False
	cbx_agent_payment.Checked = False
	cbx_tccmspay.Checked = False
	cbx_tccmsrec.Checked = False
	cbx_tccodapay.Checked = False
	cbx_tccodarec.Checked = False
	cbx_bunkerbs.Checked = False
	cbx_bunkerlp.Checked = False
	cbx_claims_commission_coda.Checked = False
	cbx_tc_commission_coda.Checked = False
	cbx_axclaims.checked = false		//M5-5 Added by ZSW001 on 10/01/2012
	cbx_voyage_estimates.checked = false //M5-8 Added by LGX001 on 05/03/2012.
	
	//M5-10 added by WWG004 on 28/03/2012
	cbx_bunkerbuy.checked = false
	cbx_bunkersell.checked = false
End if

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_transaction_log_list
   <OBJECT> Process to view outstanding transactions.  If user has exclusive access 
	they may also prepare files to be sent to Coda/CMS.
	Server process wmqtransactionlog controls the processing of the files.
	This data in the datawindow is based on the users business unit.  This is located
	with linking to vessels finance responsible.  See business logic function.
	
	</OBJECT>
   <DESC>   Finance process</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   u_transaction_output, application wmqtransactionlog.</ALSO>
    Date   Ref    Author      Comments
  10/01/10 ?      AGL027     	Split of process so server controls file generation and
 sending/directing these files to external systems (CMS/Corda)
  29/07/10 ?      AGL027		validation on when generating transactions was using radio button
 status.  This causes a problem if user retreived data using a previous filter.  Now disables
 'generate' button until data is retrieved and radio is New. When radio is changed button us disabled.
   31/03/11	2357	JMC112	Add button "Save as" and show company code in the list
********************************************************************/

end subroutine

on w_transaction_log_list.create
this.cb_ackcreditnotes=create cb_ackcreditnotes
this.cbx_bunkersell=create cbx_bunkersell
this.cbx_bunkerbuy=create cbx_bunkerbuy
this.cbx_voyage_estimates=create cbx_voyage_estimates
this.sle_invoiceno=create sle_invoiceno
this.st_invoiceno=create st_invoiceno
this.gb_activated=create gb_activated
this.gb_deactivated=create gb_deactivated
this.cb_saveas=create cb_saveas
this.cbx_claims_commission_coda=create cbx_claims_commission_coda
this.cbx_tc_commission_coda=create cbx_tc_commission_coda
this.cbx_last3years=create cbx_last3years
this.cbx_bunkerlp=create cbx_bunkerlp
this.cbx_bunkerbs=create cbx_bunkerbs
this.cbx_tccmsrec=create cbx_tccmsrec
this.cbx_tccmspay=create cbx_tccmspay
this.cbx_tccodarec=create cbx_tccodarec
this.cbx_tccodapay=create cbx_tccodapay
this.cb_print=create cb_print
this.dw_file_date_from=create dw_file_date_from
this.dw_file_date_to=create dw_file_date_to
this.rb_transfered=create rb_transfered
this.rb_disabled=create rb_disabled
this.cb_reset_filters=create cb_reset_filters
this.cb_sort=create cb_sort
this.sle_voyage_no=create sle_voyage_no
this.sle_log_by=create sle_log_by
this.sle_vessel_no=create sle_vessel_no
this.sle_file_name=create sle_file_name
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.sle_docno_to=create sle_docno_to
this.sle_docno_from=create sle_docno_from
this.st_5=create st_5
this.st_4=create st_4
this.st_doc_num=create st_doc_num
this.st_2=create st_2
this.st_1=create st_1
this.rb_new=create rb_new
this.rb_status_all=create rb_status_all
this.cb_retransmit_log=create cb_retransmit_log
this.cb_retransmit=create cb_retransmit
this.cb_print_trans_report=create cb_print_trans_report
this.cb_disable_reason=create cb_disable_reason
this.cb_update=create cb_update
this.cbx_variations=create cbx_variations
this.cbx_batch_commission=create cbx_batch_commission
this.cbx_disb_expenses=create cbx_disb_expenses
this.cbx_bunker_consumption=create cbx_bunker_consumption
this.cbx_agent_payment=create cbx_agent_payment
this.cbx_tc_commission=create cbx_tc_commission
this.cbx_claims_commission=create cbx_claims_commission
this.cbx_claims=create cbx_claims
this.cbx_all=create cbx_all
this.cb_retrieve_transactions=create cb_retrieve_transactions
this.cb_close=create cb_close
this.cb_generate_file=create cb_generate_file
this.cb_open_transaction=create cb_open_transaction
this.gb_other=create gb_other
this.gb_dates_numbers=create gb_dates_numbers
this.gb_status=create gb_status
this.gb_1=create gb_1
this.dw_trans_date_from=create dw_trans_date_from
this.dw_trans_date_to=create dw_trans_date_to
this.dw_transaction_log_list=create dw_transaction_log_list
this.cbx_axclaims=create cbx_axclaims
this.Control[]={this.cb_ackcreditnotes,&
this.cbx_bunkersell,&
this.cbx_bunkerbuy,&
this.cbx_voyage_estimates,&
this.sle_invoiceno,&
this.st_invoiceno,&
this.gb_activated,&
this.gb_deactivated,&
this.cb_saveas,&
this.cbx_claims_commission_coda,&
this.cbx_tc_commission_coda,&
this.cbx_last3years,&
this.cbx_bunkerlp,&
this.cbx_bunkerbs,&
this.cbx_tccmsrec,&
this.cbx_tccmspay,&
this.cbx_tccodarec,&
this.cbx_tccodapay,&
this.cb_print,&
this.dw_file_date_from,&
this.dw_file_date_to,&
this.rb_transfered,&
this.rb_disabled,&
this.cb_reset_filters,&
this.cb_sort,&
this.sle_voyage_no,&
this.sle_log_by,&
this.sle_vessel_no,&
this.sle_file_name,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.sle_docno_to,&
this.sle_docno_from,&
this.st_5,&
this.st_4,&
this.st_doc_num,&
this.st_2,&
this.st_1,&
this.rb_new,&
this.rb_status_all,&
this.cb_retransmit_log,&
this.cb_retransmit,&
this.cb_print_trans_report,&
this.cb_disable_reason,&
this.cb_update,&
this.cbx_variations,&
this.cbx_batch_commission,&
this.cbx_disb_expenses,&
this.cbx_bunker_consumption,&
this.cbx_agent_payment,&
this.cbx_tc_commission,&
this.cbx_claims_commission,&
this.cbx_claims,&
this.cbx_all,&
this.cb_retrieve_transactions,&
this.cb_close,&
this.cb_generate_file,&
this.cb_open_transaction,&
this.gb_other,&
this.gb_dates_numbers,&
this.gb_status,&
this.gb_1,&
this.dw_trans_date_from,&
this.dw_trans_date_to,&
this.dw_transaction_log_list,&
this.cbx_axclaims}
end on

on w_transaction_log_list.destroy
destroy(this.cb_ackcreditnotes)
destroy(this.cbx_bunkersell)
destroy(this.cbx_bunkerbuy)
destroy(this.cbx_voyage_estimates)
destroy(this.sle_invoiceno)
destroy(this.st_invoiceno)
destroy(this.gb_activated)
destroy(this.gb_deactivated)
destroy(this.cb_saveas)
destroy(this.cbx_claims_commission_coda)
destroy(this.cbx_tc_commission_coda)
destroy(this.cbx_last3years)
destroy(this.cbx_bunkerlp)
destroy(this.cbx_bunkerbs)
destroy(this.cbx_tccmsrec)
destroy(this.cbx_tccmspay)
destroy(this.cbx_tccodarec)
destroy(this.cbx_tccodapay)
destroy(this.cb_print)
destroy(this.dw_file_date_from)
destroy(this.dw_file_date_to)
destroy(this.rb_transfered)
destroy(this.rb_disabled)
destroy(this.cb_reset_filters)
destroy(this.cb_sort)
destroy(this.sle_voyage_no)
destroy(this.sle_log_by)
destroy(this.sle_vessel_no)
destroy(this.sle_file_name)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_docno_to)
destroy(this.sle_docno_from)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_doc_num)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_new)
destroy(this.rb_status_all)
destroy(this.cb_retransmit_log)
destroy(this.cb_retransmit)
destroy(this.cb_print_trans_report)
destroy(this.cb_disable_reason)
destroy(this.cb_update)
destroy(this.cbx_variations)
destroy(this.cbx_batch_commission)
destroy(this.cbx_disb_expenses)
destroy(this.cbx_bunker_consumption)
destroy(this.cbx_agent_payment)
destroy(this.cbx_tc_commission)
destroy(this.cbx_claims_commission)
destroy(this.cbx_claims)
destroy(this.cbx_all)
destroy(this.cb_retrieve_transactions)
destroy(this.cb_close)
destroy(this.cb_generate_file)
destroy(this.cb_open_transaction)
destroy(this.gb_other)
destroy(this.gb_dates_numbers)
destroy(this.gb_status)
destroy(this.gb_1)
destroy(this.dw_trans_date_from)
destroy(this.dw_trans_date_to)
destroy(this.dw_transaction_log_list)
destroy(this.cbx_axclaims)
end on

event open;/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Create the user object that holds the logic.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
06-05-99		1.0		ta			Initial version
19-04-01		2.0		TAU		Move the locking of transfer to this open event. First
										to open the window will get the rights to create a file.
************************************************************************************/
// Declare local variables
Integer li_count

Integer li_lock, li_cms_return, li_coda_return, li_return
String ls_user, ls_generation_message, ls_groupname
Datetime ld_start
Long ll_row_num
integer li_bu
datawindowchild ldwc



w_transaction_log_list.Move(0,0)

// Create the user object
iuo_transaction_output = create u_transaction_output

// Insert a row in filter datawindows
dw_file_date_from.InsertRow(0)
dw_file_date_to.InsertRow(0)
dw_trans_date_from.InsertRow(0)
dw_trans_date_to.InsertRow(0)

ls_user = uo_global.getuserid()
ld_start = datetime(today(),now())
ib_release = false // Normal user must not reset the file generation in progress flag => false

// if User is not from finance or administrator, disable all buttons but retrieve
IF uo_global.ii_access_level <> 3 THEN 
	if  uo_global.ii_user_profile <> 3 then   
		dw_transaction_log_list.Object.DataWindow.ReadOnly="Yes"
		cb_generate_file.Visible = false
		cb_retransmit.Visible = false
		cb_update.Visible = false
		return
	end if
END IF

// If there is no row in the table that indicate whether a file is being generated
// insert row with key (date)
SELECT COUNT(PROGRESS_START)
INTO	 :li_count
FROM 	 ELECTRONIC_IN_PROGRESS;
Commit;

If li_count = 0 then
	INSERT INTO ELECTRONIC_IN_PROGRESS(PROGRESS_START,PROGRESS_USER,PROGRESS_LOCK) VALUES(GETDATE(),:ls_user,0);
	If sqlca.sqlcode <> 0 then
		messagebox("Error","Could not insert a new row in electronic_in_progress table.",Stopsign!,OK!)
		RollBack;
		Return
	Else
		Commit;
	End if
End if


// Check if someone else is generating the files right now
SELECT PROGRESS_START,PROGRESS_LOCK
INTO :ld_start, :li_lock
FROM ELECTRONIC_IN_PROGRESS;
COMMIT;

If IsNull(li_lock) Then li_lock = 0

// If no User has the privilege of being able to generate a file give it to the current User
If li_lock = 0 then
	ib_release = true

	UPDATE ELECTRONIC_IN_PROGRESS
		SET PROGRESS_USER = :ls_user , PROGRESS_LOCK = 1, PROGRESS_START = :ld_start
	 WHERE PROGRESS_LOCK = 0 OR PROGRESS_LOCK IS NULL;

	If sqlca.sqlcode <> 0 then
		This.Title += " - it was not possible to lock the electronic transfer privilege. File generation is not possible."
		RollBack;
	Else
		Commit;
		// Enable locked functionality on the window
		ib_generateAllowed = true
		cb_retransmit.Enabled = True
		cb_update.Enabled = True
		dw_transaction_log_list.SetTabOrder(5,10)
		This.Title += " - file transfer is on. You have the file generation privilege."
	End if
Else
	SELECT PROGRESS_USER
	INTO :ls_user
	FROM ELECTRONIC_IN_PROGRESS;
	COMMIT;
	If ls_user = "" Or IsNull(ls_user) Then ls_user = "No user id"
	This.Title += " - file transfer is on. The user '" +ls_user+ "' has the file generation privilege."
End if	

end event

event close;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-04-2001
Purpose:	Set the lock on file generation to off (0) if the user who log's off has had
			the privilege of generating files.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-04-01		1.0		TAU		Initial version
************************************************************************************/
// Declare local variables
String ls_user

If ib_release then
	// Set the Electronic transfer to open again
	ls_user = ""
		
	UPDATE ELECTRONIC_IN_PROGRESS
		SET PROGRESS_USER = :ls_user , PROGRESS_LOCK = 0;
	
	If sqlca.sqlcode <> 0 then
		messagebox("Error", "It was not possible to unlock the electronic transfer for other users. The transfer is blocked.",Information!,OK!)
		RollBack;
	Else
		Commit;
	End if
End if
end event

type cb_ackcreditnotes from commandbutton within w_transaction_log_list
integer x = 3566
integer y = 1536
integer width = 507
integer height = 84
integer taborder = 360
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Ack. Credit Notes"
end type

event clicked;OpenWithParm(w_acknowledgment, "")

end event

type cbx_bunkersell from checkbox within w_transaction_log_list
integer x = 2395
integer y = 1768
integer width = 558
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker Sell"
boolean lefttext = true
end type

type cbx_bunkerbuy from checkbox within w_transaction_log_list
integer x = 2395
integer y = 1700
integer width = 558
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker Buy"
boolean lefttext = true
end type

type cbx_voyage_estimates from checkbox within w_transaction_log_list
integer x = 1810
integer y = 1768
integer width = 521
integer height = 76
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Voyage Estimates"
boolean lefttext = true
end type

event clicked;cb_retrieve_transactions.enabled = true

if this.checked = true then
	iuo_transaction_output.of_set_docnum("CODA",1)
else
	iuo_transaction_output.of_set_docnum("CODA", -1)
end if
end event

type sle_invoiceno from singlelineedit within w_transaction_log_list
integer x = 2967
integer y = 2340
integer width = 475
integer height = 80
integer taborder = 310
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_invoiceno from statictext within w_transaction_log_list
integer x = 2491
integer y = 2340
integer width = 448
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "AX Invoice No.     :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_activated from groupbox within w_transaction_log_list
integer x = 1774
integer y = 1504
integer width = 1737
integer height = 368
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Activated"
end type

type gb_deactivated from groupbox within w_transaction_log_list
integer x = 55
integer y = 1504
integer width = 1682
integer height = 432
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Deactivated"
end type

type cb_saveas from commandbutton within w_transaction_log_list
integer x = 4082
integer y = 1428
integer width = 507
integer height = 84
integer taborder = 370
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save as..."
end type

event clicked;
dw_transaction_log_list.SaveAs("",Excel5!,True)



end event

type cbx_claims_commission_coda from checkbox within w_transaction_log_list
integer x = 1810
integer y = 1632
integer width = 521
integer height = 76
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Claims Commission"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_tc_commission_coda from checkbox within w_transaction_log_list
integer x = 3017
integer y = 1700
integer width = 448
integer height = 76
integer taborder = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Commission"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_last3years from checkbox within w_transaction_log_list
integer x = 1390
integer y = 2348
integer width = 873
integer height = 64
integer taborder = 280
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Show transactions from last 2 years:"
boolean checked = true
boolean lefttext = true
end type

type cbx_bunkerlp from checkbox within w_transaction_log_list
integer x = 2395
integer y = 1632
integer width = 558
integer height = 76
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker Loss/Profit"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_bunkerbs from checkbox within w_transaction_log_list
integer x = 96
integer y = 1836
integer width = 763
integer height = 76
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker Buy/Sell"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_tccmsrec from checkbox within w_transaction_log_list
integer x = 933
integer y = 1768
integer width = 763
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Receive             (CMS)"
boolean lefttext = true
end type

event clicked;cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_tccmspay from checkbox within w_transaction_log_list
integer x = 933
integer y = 1700
integer width = 763
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Payment           (CMS)"
boolean lefttext = true
end type

event clicked;cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_tccodarec from checkbox within w_transaction_log_list
integer x = 3017
integer y = 1632
integer width = 448
integer height = 76
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Receive"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_tccodapay from checkbox within w_transaction_log_list
integer x = 3017
integer y = 1564
integer width = 448
integer height = 76
integer taborder = 180
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Payment"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cb_print from commandbutton within w_transaction_log_list
integer x = 4082
integer y = 1752
integer width = 507
integer height = 84
integer taborder = 400
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Pri&nt"
end type

event clicked;long 		 ll_row
string	 ls_tx_number
datastore lds_settled_disb_report

ll_row = dw_transaction_log_list.getSelectedRow(0)

if ll_row < 1 then return

ls_tx_number = dw_transaction_log_list.getItemString(ll_row, "f07_docnum")

// Print settlement report for Disbursement Expenses
lds_settled_disb_report = CREATE datastore
lds_settled_disb_report.DataObject = "d_settled_disb_report"
lds_settled_disb_report.SetTransObject(SQLCA)
lds_settled_disb_report.Retrieve(ls_tx_number, ls_tx_number)
lds_settled_disb_report.Print()
DESTROY lds_settled_disb_report

end event

type dw_file_date_from from datawindow within w_transaction_log_list
integer x = 832
integer y = 2132
integer width = 379
integer height = 80
integer taborder = 220
boolean enabled = false
string dataobject = "d_gray_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_file_date_to from datawindow within w_transaction_log_list
integer x = 832
integer y = 2236
integer width = 379
integer height = 80
integer taborder = 230
boolean enabled = false
string dataobject = "d_gray_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_transfered from radiobutton within w_transaction_log_list
event clicked pbm_bnclicked
integer x = 105
integer y = 2160
integer width = 366
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Transfered   "
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the File By and File name fields.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
09-06-99		1.0		ta			Initial version
************************************************************************************/
string ls_color

sle_file_name.Enabled = True
sle_log_by.Enabled = True

cb_generate_file.Enabled = False

dw_file_date_from.Enabled = True
dw_file_date_from.Modify("DataWindow.Color = 16777215")

dw_file_date_to.Enabled = True
dw_file_date_to.Modify("DataWindow.Color = 16777215")

end event

type rb_disabled from radiobutton within w_transaction_log_list
integer x = 105
integer y = 2304
integer width = 366
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Disabled      "
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Disables and blanks the File By and File name fields.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
09-06-99		1.0		ta			Initial version
************************************************************************************/

long ll_row

sle_file_name.Text = ""
sle_file_name.Enabled = False

sle_log_by.Text = ""
sle_log_by.Enabled = False

cb_generate_file.Enabled = False

ll_row = dw_file_date_from.GetRow()
dw_file_date_from.SetText("00-00-0000")
dw_file_date_from.AcceptText()
dw_file_date_from.Modify("DataWindow.Color = 12632256")
dw_file_date_from.Enabled = False

ll_row = dw_file_date_to.GetRow()
dw_file_date_to.SetText("00-00-0000")
dw_file_date_to.AcceptText()
dw_file_date_to.Modify("DataWindow.Color = 12632256")
dw_file_date_to.Enabled = False

end event

type cb_reset_filters from commandbutton within w_transaction_log_list
integer x = 4082
integer y = 1644
integer width = 507
integer height = 84
integer taborder = 390
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset &Filters"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		10-06-1999
Purpose:	Reset all filters to the default values.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
10-06-99		1.0		ta			Initial version.
************************************************************************************/

wf_reset_filters()

end event

type cb_sort from commandbutton within w_transaction_log_list
integer x = 3566
integer y = 1428
integer width = 507
integer height = 84
integer taborder = 350
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Sort"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		10-06-1999
Purpose:	Sort the contents of the data window with criteria specified by the user.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
10-06-99		1.0		ta			Initial version.
************************************************************************************/
string ls_null

SetNull(ls_null)

dw_transaction_log_list.SetSort("file_date D")

dw_transaction_log_list.Sort()
end event

type sle_voyage_no from singlelineedit within w_transaction_log_list
integer x = 3863
integer y = 2236
integer width = 475
integer height = 80
integer taborder = 330
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_log_by from singlelineedit within w_transaction_log_list
integer x = 3863
integer y = 2132
integer width = 475
integer height = 80
integer taborder = 320
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_vessel_no from singlelineedit within w_transaction_log_list
integer x = 2967
integer y = 2236
integer width = 475
integer height = 80
integer taborder = 300
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_file_name from singlelineedit within w_transaction_log_list
integer x = 2967
integer y = 2132
integer width = 475
integer height = 80
integer taborder = 290
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;/***********************************************************************************
Creator:	Teit Aunt
Date:		30-06-1999
Purpose:	Set the content of the field in uppercase
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
30-06-99		1.0		ta			Initial version
************************************************************************************/
string ls_name

ls_name = sle_file_name.Text
sle_file_name.Text = Upper(ls_name)
end event

type st_9 from statictext within w_transaction_log_list
integer x = 3525
integer y = 2236
integer width = 366
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Voyage No.   :"
boolean focusrectangle = false
end type

type st_8 from statictext within w_transaction_log_list
integer x = 3525
integer y = 2132
integer width = 320
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "File By           :"
boolean focusrectangle = false
end type

type st_7 from statictext within w_transaction_log_list
integer x = 2606
integer y = 2236
integer width = 334
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Vessel No.     :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_transaction_log_list
integer x = 2610
integer y = 2132
integer width = 329
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "File Name      :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_docno_to from singlelineedit within w_transaction_log_list
integer x = 1810
integer y = 2236
integer width = 448
integer height = 80
integer taborder = 270
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_docno_from from singlelineedit within w_transaction_log_list
integer x = 1810
integer y = 2132
integer width = 448
integer height = 80
integer taborder = 260
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_transaction_log_list
integer x = 613
integer y = 2240
integer width = 192
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "To        :"
boolean focusrectangle = false
end type

type st_4 from statictext within w_transaction_log_list
integer x = 617
integer y = 2136
integer width = 215
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "From    :"
boolean focusrectangle = false
end type

type st_doc_num from statictext within w_transaction_log_list
integer x = 1815
integer y = 2064
integer width = 443
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Doc Number:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_transaction_log_list
integer x = 1326
integer y = 2064
integer width = 334
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Trans Date:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_transaction_log_list
integer x = 841
integer y = 2064
integer width = 347
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "File Date:"
boolean focusrectangle = false
end type

type rb_new from radiobutton within w_transaction_log_list
integer x = 105
integer y = 2232
integer width = 366
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "New             "
boolean checked = true
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Disables and blanks the File By and File name fields.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
09-06-99		1.0		ta			Initial version
************************************************************************************/

long ll_row

sle_file_name.Text = ""
sle_file_name.Enabled = False

sle_log_by.Text = ""
sle_log_by.Enabled = False

ll_row = dw_file_date_from.GetRow()
dw_file_date_from.SetText("00-00-0000")
dw_file_date_from.AcceptText()
dw_file_date_from.Modify("DataWindow.Color = 12632256")
dw_file_date_from.Enabled = False

ll_row = dw_file_date_to.GetRow()
dw_file_date_to.SetText("00-00-0000")
dw_file_date_to.AcceptText()
dw_file_date_to.Modify("DataWindow.Color = 12632256")
dw_file_date_to.Enabled = False


end event

type rb_status_all from radiobutton within w_transaction_log_list
integer x = 105
integer y = 2088
integer width = 366
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "All                 "
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Disables and blanks the File By and File name fields.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
09-06-99		1.0		ta			Initial version
************************************************************************************/

long ll_row

sle_file_name.Text = ""
sle_file_name.Enabled = False

sle_log_by.Text = ""
sle_log_by.Enabled = False

cb_generate_file.Enabled = False

ll_row = dw_file_date_from.GetRow()
dw_file_date_from.SetText("00-00-0000")
dw_file_date_from.AcceptText()
dw_file_date_from.Modify("DataWindow.Color = 12632256")
dw_file_date_from.Enabled = False

ll_row = dw_file_date_to.GetRow()
dw_file_date_to.SetText("00-00-0000")
dw_file_date_to.AcceptText()
dw_file_date_to.Modify("DataWindow.Color = 12632256")
dw_file_date_to.Enabled = False

end event

type cb_retransmit_log from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1328
integer width = 507
integer height = 84
integer taborder = 450
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open Retransmit &Log"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		02-06-1999
Purpose:	Opens the retransmitted log window. Each of the transactions that was retransmitted
			was copied to this log when the retransmition operation was succesfull.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
02-06-99		1.0		ta			Initial version
10-06-99		1.1		ta			The retrans window is opened with the row selected that 
										corresponds to the selected row in the log window.
************************************************************************************/
string ls_disable_reason
long ll_rownum
double ldb_key_no
s_retrans_log_argument ls_retrans_log_argument

// Create arguments for opening the retrans window
iuo_transaction_output.of_create_retrans_datastore()
ls_retrans_log_argument.lds_retrans = iuo_transaction_output.ids_retrans

ll_rownum = dw_transaction_log_list.GetRow()

If ll_rownum > 0 Then 
	ldb_key_no = dw_transaction_log_list.GetItemNumber(ll_rownum,"trans_key")
Else
	ldb_key_no = 0
End if

ls_retrans_log_argument.ldb_key_no = ldb_key_no

// Open retransmission log window
OpenWithParm(w_retransmission_log,ls_retrans_log_argument)

end event

type cb_retransmit from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1104
integer width = 507
integer height = 84
integer taborder = 430
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Retransmit"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		02-06-1999
Purpose:	Retransmit the rows shown in the Transaction log datawindow if they have been
			transmitted before, i.e. they have a user id.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
02-06-99		1.0		ta			Initial version
************************************************************************************/

/* According to change request #917 */
messageBox("Information", "This button has been disabled. For further information see Change Request #917.")
this.enabled = false
return


long 	ll_row, ll_rows
string	ls_filename
date	ldt_null;setNull(ldt_null)

/* Check if a line is selected, and if it is transferred already */  
ll_row = dw_transaction_log_list.getselectedrow(0)
if ll_row < 1 then
	MessageBox("Select Row", "Please select a row/file to retransmit.")
	return
end if

/* Check if row has a filename = transferred before */
ls_filename = dw_transaction_log_list.getItemString(ll_row, "file_name")
if isNull(ls_filename) or len(ls_filename) < 2 then
	MessageBox("Select Row", "The selected row is not transferred before, and can therefore not be retransmitted.")
	return
end if

// Set the criteria to retrieve
cbx_all.triggerEvent( clicked! )
cbx_all.checked = true
rb_transfered.triggerEvent( clicked! )
sle_file_name.text = upper( ls_filename )

dw_file_date_from.setItem(1, "date_value", ldt_null)
dw_file_date_to.setItem(1, "date_value", ldt_null)
dw_trans_date_from.setItem(1, "date_value", ldt_null)
dw_trans_date_to.setItem(1, "date_value", ldt_null)
sle_docno_from.text= ""
sle_docno_to.text= ""
sle_vessel_no.text= ""
sle_log_by.text= ""
sle_voyage_no.text= ""
sle_invoiceno.text = ""		//CRM5-3 Added by ZSW001 on 07/01/2012

cb_retrieve_transactions.triggerevent( Clicked! )

// Set the retrans flag to true
iuo_transaction_output.ib_retrans = True

// Start the file generation
cb_generate_file.TriggerEvent(Clicked!)

// Set the retrans flag to false
iuo_transaction_output.ib_retrans = False
sle_file_name.text = ""
end event

type cb_print_trans_report from commandbutton within w_transaction_log_list
event clicked pbm_bnclicked
integer x = 4082
integer y = 1536
integer width = 507
integer height = 84
integer taborder = 380
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Transaction Re&port"
end type

event clicked;/***********************************************************************************
Creator:	Kim F. Nielsen
Date:		27-05-1999
Purpose:	Calls the print transaction report function in user object "u_transaction_output" 
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
27-05-99		1.0		KFN		Initial version
************************************************************************************/

iuo_transaction_output.of_print_trans_report()









end event

type cb_disable_reason from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1440
integer width = 507
integer height = 84
integer taborder = 420
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Disable Reason"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		19-05-1999
Purpose:	Opens the disable reason window with the text from the disable reason field.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
19-05-99		1.0		ta			Initial version
************************************************************************************/
String ls_disable_reason
Long ll_rownum
Integer li_ret

// Get row number
ll_rownum = dw_transaction_log_list.GetRow()

// Get contents of disable reason field
ls_disable_reason = dw_transaction_log_list.GetItemString(ll_rownum,"trans_disable_reason")

// Open disable reason window
OpenWithParm(w_transaction_disable_reason,ls_disable_reason)

// Get new text and insert into datastore
If Message.StringParm <> "NoChange" Then
	dw_transaction_log_list.SetItem(ll_rownum,"trans_disable_reason",Message.StringParm)
End if

Message.StringParm = ""


end event

type cb_update from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1552
integer width = 507
integer height = 84
integer taborder = 460
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		17-05-1999
Purpose:	Save the changes made to the data window (datastore)
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
17-05-99		1.0		ta			Initial version
************************************************************************************/

// If the datastore that owns the data exists then save
If IsValid(iuo_transaction_output.ids_a_transactions) Then
	iuo_transaction_output.ids_a_transactions.AcceptText()
	iuo_transaction_output.ids_a_transactions.Update()
	
	If sqlca.sqlcode <> 0 then
		messagebox("Error", "It was not possible to save the changes made to the data.")
		RollBack;
		Return
	Else
		Commit;
	End if

End if

end event

type cbx_variations from checkbox within w_transaction_log_list
integer x = 96
integer y = 1632
integer width = 763
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Calculation             (CODA)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_batch_commission from checkbox within w_transaction_log_list
integer x = 96
integer y = 1564
integer width = 763
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Batch Commission  (CODA)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_disb_expenses from checkbox within w_transaction_log_list
integer x = 1810
integer y = 1700
integer width = 521
integer height = 76
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Disb. Expenses"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_bunker_consumption from checkbox within w_transaction_log_list
integer x = 2395
integer y = 1564
integer width = 558
integer height = 76
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker Consumption"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CODA",1)
Else
	iuo_transaction_output.of_set_docnum("CODA", -1)
End if
end event

type cbx_agent_payment from checkbox within w_transaction_log_list
integer x = 933
integer y = 1564
integer width = 763
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Disb. Payment        (CMS)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_tc_commission from checkbox within w_transaction_log_list
integer x = 933
integer y = 1632
integer width = 763
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "TC Commission       (CMS)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_claims_commission from checkbox within w_transaction_log_list
integer x = 96
integer y = 1768
integer width = 763
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Claims Commission (CMS)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_claims from checkbox within w_transaction_log_list
integer x = 96
integer y = 1700
integer width = 763
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Claims                    (CMS)"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Enables the Retrieve Transaction button.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
10-06-99		1.1		ta			Enable/disable docnum
************************************************************************************/

cb_retrieve_transactions.Enabled = True

If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("CMS",1)
Else
	iuo_transaction_output.of_set_docnum("CMS", -1)
End if
end event

type cbx_all from checkbox within w_transaction_log_list
integer x = 549
integer y = 1424
integer width = 165
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "All"
boolean lefttext = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		11-05-1999
Purpose:	Sets all the checkboxes as selected.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
11-05-99		1.0		ta			Initial version
02-06-99		1.1		ta			Enable retransmit button.
10-06-99		1.1		ta			Enable/disable docnum and control of type checkboxes
										moved to wf_set_type_filter(boolean)
************************************************************************************/

// Set the type filter as the Type - All button says
If cbx_all.Checked = True Then wf_set_type_filter(True)
If cbx_all.Checked = False Then wf_set_type_filter(False)

// Set the docnum fields
If This.Checked = True Then
	iuo_transaction_output.of_set_docnum("All",1)
Else
	iuo_transaction_output.of_set_docnum("All", -1)
End if
end event

type cb_retrieve_transactions from commandbutton within w_transaction_log_list
event clicked pbm_bnclicked
integer x = 4082
integer y = 1860
integer width = 507
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve &Transaction"
boolean default = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Calls the object u_transactions_output with the array used in the retrieval
			of the transaction list data window. The parameters comes from the user input
			in the checkboxes.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
06-05-99		1.0		ta			Initial version.
31-05-99		1.1		ta			Use a function to get the filter data.
07-06-99		1.2		ta			Retrieval arguments and the retrieve command in same 
										function to support multiple retrieval arguments.
************************************************************************************/

// Create the datastores
iuo_transaction_output.uf_create_datastore()

// Grab the select statement from the Log window datawindow
//iuo_transaction_output.is_sql = iuo_transaction_output.ids_a_transactions.Describe("Datawindow.Table.Select")
iuo_transaction_output.of_setsql(iuo_transaction_output.ids_a_transactions.Describe("Datawindow.Table.Select"))


// Populate the A datastore
iuo_transaction_output.of_retrieve_a()

// Share the data in the datastore with the data window
iuo_transaction_output.ids_a_transactions.ShareData(w_transaction_log_list.dw_transaction_log_list)

// Enable the buttons
cb_print_trans_report.Enabled = True
cb_sort.Enabled = True

if ib_generateAllowed and rb_new.checked then 		
	cb_generate_file.Enabled = True
end if

If uo_global.ii_access_level = 3 Then
	cb_retransmit.Enabled = True
End if

end event

type cb_close from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1664
integer width = 507
integer height = 84
integer taborder = 470
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Close the window w.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
17-05-99		1.0		ta			Inserting a save yes/no dialog.
************************************************************************************/

dw_transaction_log_list.AcceptText()

If  dw_transaction_log_list.ModifiedCount() > 0 Then

	CHOOSE CASE MessageBox("Warning", "Current data is unsaved, save before close?", StopSign!, YesNoCancel!)
		CASE 1
			// Yes, save og luk vindue
			iuo_transaction_output.ids_a_transactions.Update()
			iuo_transaction_output.uf_destroy_datastore()
			DESTROY iuo_transaction_output
			Close(w_transaction_log_list)
		CASE 2
			// No, luk vindue
			iuo_transaction_output.uf_destroy_datastore()
			DESTROY iuo_transaction_output
			Close(w_transaction_log_list)
		CASE 3
			// Cancel, do nothing
	END CHOOSE

Else
	iuo_transaction_output.uf_destroy_datastore()
	DESTROY iuo_transaction_output
	Close(w_transaction_log_list)
End if


end event

type cb_generate_file from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1216
integer width = 507
integer height = 84
integer taborder = 410
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Generate"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Calls u_transaction_output to generate files for CMS and CODA
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
************************************************************************************/
string ls_user



if not(rb_new.checked) then
	messagebox("Info", "You can only generate new transactions.  Please change the radio button option.")
	return
end if



// Check if you still are the user assigned the rights to generate transactions
SELECT isnull(PROGRESS_USER, "")
	INTO :ls_user
	FROM ELECTRONIC_IN_PROGRESS;
commit;


if ls_user <> uo_global.is_userid then
	MessageBox("Error", "Another user "+ ls_user + " is assigned the access to generate transactions.")
	return
end if





// ** commented out by AGL 20100104 **
//// Check if the MQSeries client is installed on this machine - if not refuse the generation of the file
//if NOT fileexists(uo_global.gs_mqs_file) then
//	MessageBox("Information", "The IBM MQSeries Client is not properly installed on your machine, ~r~nand therefore you can't generate the files to CODA/CMS~r~n~r~nPlease contact the system administrator to get it installed")
//	return
//end if
// ** commented out by AGL 20100104 **

// Save any changes in the data window
dw_transaction_log_list.AcceptText()
iuo_transaction_output.ids_a_transactions.Update()

// Initialize is_tx_number with NULL value
setNull(iuo_transaction_output.is_tx_number)

// Remove the visual update for the transaction log window
w_transaction_log_list.dw_transaction_log_list.SetRedraw(False)




// ** commented out by AGL 20100104 **
//// Call userobject to generate files
// iuo_transaction_output.uf_generate_files( )
iuo_transaction_output.uf_prepare_transactions( )
// ** commented out by AGL 20100104 **

// Print settlement report for Disbursement Expenses
if not isnull(iuo_transaction_output.is_tx_number) then
	datastore lds_settled_disb_report
	lds_settled_disb_report = CREATE datastore
	lds_settled_disb_report.DataObject = "d_settled_disb_report"
	lds_settled_disb_report.SetTransObject(SQLCA)
	if lds_settled_disb_report.Retrieve(iuo_transaction_output.is_tx_number, "TX9999999999") > 0 then
		lds_settled_disb_report.GroupCalc()
		lds_settled_disb_report.Print()
	end if
	DESTROY lds_settled_disb_report
end if

// Update the contents of the data window
if isValid(w_transaction_log_list.dw_transaction_log_list) then w_transaction_log_list.dw_transaction_log_list.SetRedraw(True)
if isValid(w_transaction_log_list.cb_retrieve_transactions) then w_transaction_log_list.cb_retrieve_transactions.TriggerEvent(Clicked!)

end event

type cb_open_transaction from commandbutton within w_transaction_log_list
boolean visible = false
integer x = 5888
integer y = 1776
integer width = 507
integer height = 84
integer taborder = 440
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Open Transaction"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	Open the tabpages with the details of the A and B posts
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
************************************************************************************/
long ll_row
double ld_key

ll_row = dw_transaction_log_list.GetSelectedRow(0)

IF ll_row > 0 THEN
	ld_key = dw_transaction_log_list.GetItemNumber(ll_row,'trans_key')

	OpenWithParm(w_transaction_detail,ld_key)
ELSE
	MessageBox("Information","No transaction selected.")
END IF
end event

type gb_other from groupbox within w_transaction_log_list
integer x = 2464
integer y = 1980
integer width = 1975
integer height = 464
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Other"
end type

type gb_dates_numbers from groupbox within w_transaction_log_list
integer x = 549
integer y = 1980
integer width = 1829
integer height = 464
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Dates and Numbers"
end type

type gb_status from groupbox within w_transaction_log_list
integer x = 37
integer y = 1980
integer width = 512
integer height = 464
integer taborder = 210
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Status"
end type

type gb_1 from groupbox within w_transaction_log_list
integer x = 18
integer y = 1424
integer width = 3529
integer height = 544
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Transaction types"
end type

type dw_trans_date_from from datawindow within w_transaction_log_list
integer x = 1312
integer y = 2132
integer width = 379
integer height = 80
integer taborder = 240
boolean bringtotop = true
string dataobject = "d_white_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_trans_date_to from datawindow within w_transaction_log_list
integer x = 1312
integer y = 2236
integer width = 379
integer height = 80
integer taborder = 250
boolean bringtotop = true
string dataobject = "d_white_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_transaction_log_list from datawindow within w_transaction_log_list
integer x = 37
integer y = 32
integer width = 4553
integer height = 1376
integer taborder = 340
string title = "Tansaction Log"
string dataobject = "d_transaction_log_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;/***********************************************************************************
Creator:	Teit Aunt
Date:		06-05-1999
Purpose:	Highlights the selected row.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
06-05-99		1.0		ta			Initial version
14-06-99		1.1		ta			If disable reason is checked then enable disable reason
										button.
02-11-05		14.08  rmo										
************************************************************************************/
integer li_checked

if currentrow > 0 then
	SelectRow(0,False)
	SelectRow(currentrow ,True)

	if this.getItemString(currentrow, "trans_type") = "DisbExp" and &
										len(this.getItemString(currentrow, "f07_docnum")) > 1 then
		cb_print.enabled = TRUE
	else
		cb_print.enabled = FALSE
	end if

	li_checked = dw_transaction_log_list.GetItemNumber(currentrow,"trans_disable")
	If li_checked = 1 Then
		cb_disable_reason.Enabled = True
	Else
		cb_disable_reason.Enabled = False
	End if
End if

end event

event doubleclicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		10-05-1999
Purpose:	
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
10-05-99		1.0		ta			Initial version
************************************************************************************/

If row > 0 Then
	cb_open_transaction.TriggerEvent(Clicked!)
End if
end event

event itemchanged;IF dwo.name = "trans_disable" then
	if integer(data) = 0 and this.getItemString(row, "file_name") = "Locked" then return 1
end if
end event

event itemerror;return 1
end event

event clicked;if row > 0 then
	event rowfocuschanged( row )
end if
end event

type cbx_axclaims from checkbox within w_transaction_log_list
integer x = 1810
integer y = 1564
integer width = 521
integer height = 76
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Claims"
boolean lefttext = true
end type

