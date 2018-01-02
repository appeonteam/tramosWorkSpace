$PBExportHeader$u_transaction.sru
$PBExportComments$Main object for generating cms and coda transactions.
forward
global type u_transaction from mt_n_nonvisualobject
end type
end forward

global type u_transaction from mt_n_nonvisualobject
end type
global u_transaction u_transaction

type prototypes

end prototypes

type variables
n_ds ids_apost, ids_bpost
n_ds ids_default_values   
s_transaction_input istr_trans_input
string	is_codacompanycode
date	idt_serverdate
end variables

forward prototypes
public function integer of_default_coda ()
public function integer of_default_values ()
public function integer of_fill_transaction ()
public function integer of_generate_transaction (s_transaction_input astr_trans_input)
public function integer of_save ()
public function integer of_default_cms ()
public subroutine documentation ()
public subroutine of_messagebox (string as_title, string as_message)
end prototypes

public function integer of_default_coda ();integer	li_period
string		ls_century, ls_yr, ls_tmp
string	 ls_applicationname
ulong	lul_handle, lul_length=255


/* Set field no. 2 Company - Profit center*/
IF ids_apost.SetItem(1,"f02_cmpcode",is_codacompanycode) <> 1 THEN
	of_messagebox("Set value error", "Cant set company code for A-post. Object: u_transaction, function: of_default_coda")
	Return(-1)
END IF

/* Set field no. 1  Linkcode  */
IF ids_apost.SetItem(1,"f01_linkcode", ids_default_values.GetItemString(1,"lincode_coda")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 01 (Linkcode) for A-post. Object: u_transaction, function: of_default_coda")
	Return(-1)
END IF

/* Set field no. 3  Accounting Year  */
IF ids_apost.SetItem(1,"f03_yr", Year(idt_serverdate)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Accounting year) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 4 Accounting period  */
IF ids_apost.SetItem(1,"f04_period", Integer(String(idt_serverdate,"MM"))) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Accounting period) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 5 AuthUser (taken from Windows-NT) */
handle(getapplication())
 lul_handle = handle( getapplication() )
 ls_applicationname =space(lul_length) 
 GetModuleFilename( lul_handle, ls_applicationname, lul_length )
 //if the transaction is running from a server application
 //check if it is Pool Commission or Accrual postings and set userid = "NOL001" (Nicolas Olivares)
 if right(ls_applicationname,25) ="poolcommissionposting.exe" & 
 or right(ls_applicationname,21) ="accrualsgenerator.exe" then
	ls_tmp = "NOL001"
else
	ls_tmp = uo_global.is_userid  
end if

IF ids_apost.SetItem(1,"f05_auth_user",ls_tmp ) <> 1 THEN
	of_messagebox("Set value error", "Cant set AuthUser for A-post. Object: u_transaction, function: of_default_CODA")
	Return(-1)
END IF

/* Set field no. 12  Element 2  */
IF ids_apost.SetItem(1,"f12_el2", ids_default_values.GetItemString(1,"el2_coda_a")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 12 (Element 2) for A-post. Object: u_transaction, function: of_default_coda")
	Return(-1)
END IF

Return(1)
end function

public function integer of_default_values ();/* Set key values for query purpose */
IF ids_apost.SetItem(1,"trans_date",Today()) <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction date for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"trans_user", uo_global.Getuserid()) <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction user for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 8 Docline number (always 1 for A-post) */
IF ids_apost.SetItem(1,"f08_doclinenum", 1) <> 1 THEN
	of_messagebox("Set value error", "Cant set Docline number for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 10 Destination (always blank) */
IF ids_apost.SetItem(1,"f10_destination", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Destination for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 18 Voyageperiodisation (always blank) */
IF ids_apost.SetItem(1,"f18_el8", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Element 8 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 24  (always blank) */
IF ids_apost.SetItem(1,"f24_bank_or_moneyord", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 24 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 25  (always blank) */
IF ids_apost.SetItem(1,"f25_paymethod_or_dateofissue", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 25 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 26  (always blank) */
IF ids_apost.SetItem(1,"f26_orderno", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 26 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 27  Linetype) */
IF ids_apost.SetItem(1,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_summary_apost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 27 (Linetype) for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 31  (always 2) */
IF ids_apost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 42  (always blank) */
IF ids_apost.SetItem(1,"f42_location", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 42 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

/* Set field no. 44  (always blank) */
IF ids_apost.SetItem(1,"f44_edittick", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 44 for A-post. Object: u_transaction, function: of_default_values")
	Return(-1)
END IF

Return(1)
end function

public function integer of_fill_transaction ();/* Default return value to ensure that code is entered in inherited objects */
of_messagebox("Warning", "Remember to code of_fill_transactions for each type")
Return(1)
end function

public function integer of_generate_transaction (s_transaction_input astr_trans_input);/********************************************************************
   of_generate_transaction
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_trans_input
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		29/04/15 CR3896        SSX014   Rollback transaction properly
   </HISTORY>
********************************************************************/

Integer li_return, li_flagposttransaction

/* Set input parameters accessible for all functions within object */
istr_trans_input = astr_trans_input

SELECT PROFIT_C.POST_TRANSACTION, PROFIT_C.CODA_COMPANY_CODE, getdate()
INTO :li_flagposttransaction, :is_codacompanycode, :idt_serverdate
FROM VESSELS, PROFIT_C
WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND
	VESSEL_NR = :istr_trans_input.vessel_no;

if li_flagposttransaction=0  then
	of_messagebox("Transaction Generation","This expense will be not posted in CODA! (Posting was disabled for this profit center!)")
  Return(1)
end if

/* Insert a new line in A-post datawindow */
IF ids_apost.InsertRow(0) = -1 THEN
	of_messagebox("Generate transaction error","Unable to insert row in A-post datawindow. Object: u_transaction, Function: of_generate_transaction")
	Return(-1)
END IF

/* Default values for all transactions */
IF of_default_values() <> 1 THEN
	of_messagebox("Generate transaction error","Unable to fill default values. Object: u_transaction, Function: of_generate_transaction")
	Return(-1)
END IF

/* Default values for CODA or CMS transactions */
IF istr_trans_input.coda_or_cms = TRUE THEN
	IF of_default_CODA() <> 1 THEN
		of_messagebox("Generate transaction error","Unable to fill CODA default values. Object: u_transaction, Function: of_generate_transaction")
		Return(-1)
	END IF
ELSE
	IF of_default_CMS() <> 1 THEN
		of_messagebox("Generate transaction error","Unable to fill CMS default values. Object: u_transaction, Function: of_generate_transaction")
		Return(-1)
	END IF
END IF

/* Write this function for each object of type u_transactions */
li_return = of_fill_transaction()
IF li_return <> 1 AND li_return <> 10 THEN
	rollback;
	Return(-1)
ELSEIF li_return = 10 THEN
	// Return 10 means that it is a Bunker transaction on a re-finished voyage
	//with no change so no transaction => stop before save and return OK
	Return 1
END IF

/* Save transactions */
IF of_save() <> 1 THEN
	rollback;
	of_messagebox("Generate transaction error","Unable to save transactions. Object: u_transaction, Function: of_generate_transaction")
	Return(-1)
END IF

Return(1)
end function

public function integer of_save ();/********************************************************************
   of_save
   <DESC>	Save the data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		29/04/15 CR3896        SSX014   Rollback transaction before displaying a message box
   </HISTORY>
********************************************************************/

/* Saves the transactions (datastores) in transaction log */
long ll_transkey, ll_rows, ll_rowno

IF ids_apost.RowCount() = 1 THEN
	IF ids_bpost.RowCount() > 0 THEN
		/* Save apost and fill transkey in bpost and save bpost */
		IF ids_apost.Update() = 1 THEN
			ll_transkey = ids_apost.GetItemNumber(1,"trans_key")
			IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
				ROLLBACK;
				of_messagebox("Generate transaction error", "No value found for transaction key")
				Return(-1)
			ELSE
				ll_rows = ids_bpost.RowCount()
				FOR ll_rowno = 1 TO ll_rows
					ids_bpost.SetItem(ll_rowno, "trans_key", ll_transkey)
				NEXT
				ids_bpost.AcceptText()
				IF ids_bpost.Update() = 1 THEN
					COMMIT;
					Return(1)
				ELSE
					ROLLBACK;
					of_messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
					Return(-1)
				END IF
			END IF
		ELSE
			ROLLBACK;
			of_messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
			Return(-1)
		END IF
	ELSE
		of_messagebox("Generate transaction error", "No rows found in B-post")
		Return(-1)
	END IF
ELSE
	of_messagebox("Generate transaction error", "Non or to many rows found in A-post")
	Return(-1)
END IF

end function

public function integer of_default_cms ();String ls_century, ls_yr, ls_tmp
String ls_vessel_ref_nr   /* used to store alphanumeric vessel number */
Integer li_period
string	 ls_applicationname
ulong	lul_handle, lul_length=255

/* Set field no. 2 Company */
IF ids_apost.SetItem(1,"f02_cmpcode", ids_default_values.GetItemString(1,"cmpcode")) <> 1 THEN
	of_messagebox("Set value error", "Cant set company code for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 1  Linkcode  */
IF ids_apost.SetItem(1,"f01_linkcode", ids_default_values.GetItemString(1,"lincode_cms")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 01 (Linkcode) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 3  Accounting Year  */
IF ids_apost.SetItem(1,"f03_yr", Year(idt_serverdate)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Accounting year) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 4 Accounting period  */
IF ids_apost.SetItem(1,"f04_period", integer(string(idt_serverdate, "mmdd"))) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Accounting period) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 5 Auth user */
/* auth user changed to be userid of the logged in user CR#2097 */
//IF ids_apost.SetItem(1,"f05_auth_user", ids_default_values.GetItemString(1,"default_signer")) <> 1 THEN

handle(getapplication())
 lul_handle = handle( getapplication() )
 ls_applicationname =space(lul_length) 
 GetModuleFilename( lul_handle, ls_applicationname, lul_length )
 if right(ls_applicationname,25) ="poolcommissionposting.exe" then
	ls_tmp = "NOL001"
else
	ls_tmp = uo_global.is_userid  
end if
 
IF ids_apost.SetItem(1,"f05_auth_user", ls_tmp ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Auth user for A-post. Object: u_transaction_payment, &
									function: of_fill_transaction")
	Return(-1)
END IF 

/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_cms_payments")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 12  Element 2 (Cost/Profitcenter)  */
integer li_pc_nr
string ls_el2
u_profitcenter luo_profitcenter

SELECT PC_NR 
	INTO :li_pc_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	//COMMIT; no commit as part of LUW
ELSE
	of_messagebox("Retrieval error", "ProfitCenter for vessel not found. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

luo_profitcenter = CREATE u_profitcenter
luo_profitcenter.of_getProfitCenter(li_pc_nr)
ls_el2 = luo_profitcenter.of_getDepartmentCode()
DESTROY luo_profitcenter
IF ids_apost.SetItem(1,"f12_el2", ls_el2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 12 (Element 2) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 15  Vessel ID */
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	//COMMIT; no commit as part of LUW
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (vessel ID) for A-post. Object: u_transaction, function: of_default_CMS")
	Return(-1)
END IF
//IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + string(istr_trans_input.vessel_no,"000")) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Field 15 (vessel ID) for A-post. Object: u_transaction, function: of_default_CMS")
//	Return(-1)
//END IF

/* Set field no. 16  Voyage ID */
IF ids_apost.SetItem(1,"f16_el6", ids_default_values.GetItemString(1,"prefix_voyage") + LEFT(istr_trans_input.voyage_no,5)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (voyage ID) for A-post. Object: u_transaction, function: of_default_CMS")
	Return(-1)
END IF

/* Set field no. 21  (always blank) */
IF ids_apost.SetItem(1,"f21_vouchernr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 21 for A-post. Object: u_transaction, function: of_default_CMS")
	Return(-1)
END IF

/* Set field no. 22  (always blank) */
IF ids_apost.SetItem(1,"f22_controlnr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 22 for A-post. Object: u_transaction, function: of_default_CMS")
	Return(-1)
END IF

Return(1)
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction
   <OBJECT> Main transaction object</OBJECT>
   <DESC>   Used to set default transaction criteria and to
	prepare the transaction records in the appropriate post</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author		Comments
  00/00/07 ?      ???     		First Version
  24/08/10 	2097  RMO     	Tramos should be interfaced to CMS to respective user id not TANKDI		
  24/01/11	2264	JMC		Company code in CODA transactions defined by profit center
  14/02/11	2277	JMC		Get server date time. Fields f03 and f04 are calculated based on server date time. CMS+CODA
  25/03/11	2277	JMC		User id is fixed when application runs from the server (Pool Commission posting)
  02/05/11	2381	RMO		User id is fixed when application runs from the server (Accrual posting)
  03/04/15  3896  SSX      Fix that credit note is not generated when deleting hire statements that sent invoice data to AX previously
********************************************************************/

end subroutine

public subroutine of_messagebox (string as_title, string as_message);_addmessage( this.classdefinition ,as_title, as_message, "")
end subroutine

on u_transaction.create
call super::create
end on

on u_transaction.destroy
call super::destroy
end on

event constructor;ids_apost = CREATE n_ds
ids_bpost = CREATE n_ds
ids_default_values = CREATE n_ds

ids_apost.DataObject = "d_trans_log_main_a"
ids_bpost.DataObject = "d_trans_log_b"
ids_default_values.DataObject = "d_default_values_maintenance"

ids_apost.SetTransObject(SQLCA)
ids_bpost.SetTransObject(SQLCA)
ids_default_values.SetTransObject(SQLCA)

IF ids_default_values.Retrieve() <> 1 THEN
	of_messagebox("Retrieval error", "No default values for transactions found. Object: u_transactions, Event: constructor.")
	Return
END IF


end event

event destructor;DESTROY ids_apost
DESTROY ids_bpost
DESTROY ids_default_values
end event

