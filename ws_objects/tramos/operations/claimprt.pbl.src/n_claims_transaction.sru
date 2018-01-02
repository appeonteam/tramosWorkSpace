$PBExportHeader$n_claims_transaction.sru
forward
global type n_claims_transaction from mt_n_nonvisualobject
end type
end forward

global type n_claims_transaction from mt_n_nonvisualobject
end type
global n_claims_transaction n_claims_transaction

type variables
s_transaction_input istr_transaction_input
end variables

forward prototypes
public function integer of_send_data (s_transaction_input astr_transaction_input, ref mt_u_datawindow adw_claim_sent)
public function integer of_credit_note (long al_payment_id, string as_invoice_nr)
public subroutine documentation ()
public function long of_send_errorcreditnote_email (ref mt_n_datastore ads_apost, long al_apost_row, ref string as_finemail)
public function integer of_credit_note (long al_payment_id, string as_invoice_nr, ref string as_finemail)
end prototypes

public function integer of_send_data (s_transaction_input astr_transaction_input, ref mt_u_datawindow adw_claim_sent);/********************************************************************
of_send_data
   <DESC> Creates claim transaction </DESC>
   <RETURN> 
		c#return.success: Success
		c#return.failed: Error
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		s_transaction_input: structure used in transactions module. It should contain the
									following information:
				- vessel_no, voyage_no, claim_no, charter_no
				- currency_code
				- payment_id (= CLAIMS.CLAIM_ID)
				- payment_end (discharge date)
				- payment_amount (total claim amount)
				- amount_local (gross amount)
				- comm_amount (address commission amount)
				- broker_id_array, broker_amount_array (list of deductable brokers)
				
		adw_claim_sent: datawindow for save send amount and adjustment reason.
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/
integer	li_locked, li_trans_ok
dec {2}	ld_amount_local
string 	ls_finemail=""

u_transaction_claim	lnv_transaction_claim

CONSTANT string ls_ERRMSG = "Send data to AX failed, because invoice is locked."

istr_transaction_input = astr_transaction_input

//Real time check: Check if invoice is locked
SELECT LOCKED
  INTO :li_locked
  FROM CLAIMS
 WHERE CLAIM_ID = :astr_transaction_input.payment_id
 USING SQLCA;

if li_locked = 1 then
	messagebox("Error", ls_ERRMSG)
	return c#return.Failure
end if

//Lock invoice, so nobody else tries to print during the process
UPDATE CLAIMS 
   SET LOCKED = 1
 WHERE CLAIM_ID = :astr_transaction_input.payment_id AND
       LOCKED = 0
 USING SQLCA;

if sqlca.sqlnrows = 0 then
	ROLLBACK;
	messagebox("Error", ls_ERRMSG)
	return c#return.Failure
end if

COMMIT USING SQLCA;

if astr_transaction_input.ax_invoice_nr <>"" then
	
	if of_credit_note(astr_transaction_input.payment_id, astr_transaction_input.ax_invoice_nr, ls_finemail ) =  c#return.Failure then 
		 
		UPDATE CLAIMS 
		SET LOCKED = 0
		WHERE CLAIM_ID =  :astr_transaction_input.payment_id
		USING SQLCA ;
		COMMIT USING SQLCA;
		
		if ls_finemail="" then ls_finemail = "unknown"
		messagebox("Error","The invoice data has not been sent to AX, because the credit note creation failed." + c#string.cr + c#string.cr +"A notification email has been sent to " +  ls_finemail + "." + c#string.cr + "Please contact Finance for further assistance.")
		
		return c#return.Failure
	end if

else
	//in case credit note is not created, make sure claim does not have any transactions to reverse in trans_log_main_a
	
	UPDATE TRANS_LOG_MAIN_A
	SET PAYMENT_ID = NULL
	WHERE TRANS_TYPE = "Claims" 
		AND PAYMENT_ID= :astr_transaction_input.payment_id
	USING SQLCA ;
	COMMIT USING SQLCA;
		
end if

astr_transaction_input.ax_invoice_nr = ""

//Create invoice transaction
lnv_transaction_claim = CREATE u_transaction_claim

li_trans_ok = lnv_transaction_claim.of_generate_transaction(astr_transaction_input)

If li_trans_ok  <> 1 THEN
	
	ROLLBACK USING SQLCA;
	Destroy lnv_transaction_claim
	
	UPDATE CLAIMS 
	SET LOCKED = 0
	WHERE CLAIM_ID =  :astr_transaction_input.payment_id
	USING SQLCA ;
	COMMIT USING SQLCA;

	messagebox("Error", "Send data to AX failed, because Transaction creation failed.")
	
	return c#return.Failure
End if

if isvalid(adw_claim_sent) then
	//Save send amount, adjustment reason...
	if adw_claim_sent.update(true, false) <> 1 then
		rollback;
		messagebox("Error", "The invoice data has not been sent to AX, because error occurs when update datawindow dw_claim_sent.")
		return c#return.Failure
	end if
end if

ld_amount_local = astr_transaction_input.amount_local

UPDATE CLAIMS
   SET INVOICE_NR = "",
	   CLAIM_AMOUNT_AX = :ld_amount_local, 
	   ADDRESS_COM_AX = ADDRESS_COM,
	   DUE_DATE =  :astr_transaction_input.payment_end
 WHERE CLAIM_ID = :astr_transaction_input.payment_id
 USING SQLCA ;

//Commit all transactions
COMMIT ;
if isvalid(adw_claim_sent) then adw_claim_sent.resetupdate()

//M5-2 Modified by LGX001 on 01/02/2012. 
messagebox("Print Invoice", "Invoice data sent to Finance system successfully.")
	
Destroy lnv_transaction_claim

return c#return.Success
end function

public function integer of_credit_note (long al_payment_id, string as_invoice_nr);/********************************************************************
of_credit_note
   <DESC> Creates Credit note by reversing previous transaction </DESC>
   <RETURN> 
		c#return.success: Success
		c#return.failed: Error
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		al_payment_id: CLAIMS.CLAIM_ID (link to TRANS_LOG_MAIN_A.PAYMENT_ID)
		as_invoice_nr: AX invoice number
   </ARGS>
   <USAGE>	
	Still used in external calls.  Now it is overriden to support the retrieval of the email address
	</USAGE>
********************************************************************/

string	ls_dummy
return of_credit_note( al_payment_id, as_invoice_nr, ls_dummy)



end function

public subroutine documentation ();/********************************************************************
   n_claims_transactions: Handles creation of transactions related with Claims
   <OBJECT> This object holds functionality concerning Claims transactions (Print invoice in AX)
   </OBJECT>
	<DESC> of_send_data 		- creates claim transaction
				of_credit_note		- creates credit note transaction
	</DESC>
     <USAGE> This object is used from:
	    				- claims print window, when option "Send data to AX" is enabled (of_send_data)
					- claims window when claim is deleted (of_credit_note)
     </USAGE>
     <ALSO>  </ALSO>
    	Date   		Ref    			Author		Comments
  	09/01/12		M5-2			JMC112		Initial Version
	27/03/12		M5-2			JMC112		Add scenario where AX invoice nr is empty and
												payment id in transaction log needs to be clean.
    19/06/12    CR2820      ZSW001      Remove MODIFIED field from CLAIMS table.
	26/10/2012 	2771		LGX001		Change user id and transaction date in credit notes, so user id represents the user id that 
							    		created the credit note and the date represents the date when a credit note was created.
	16/11/2012	3017		LGX001		Send email and store the credit note information when failed credit notes
    26/03/2013  3187      	ZSW001      Invoice transactions are generated duplicate (or even triple), when a user clicks "send invoice data to AX"
	04/04/2013 	3017		AGL027		Modify messagebox text content.  include email address
	15/05/2013	2690		LGX001		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
										2.change "@maersk.com" 			 as C#EMAIL.DOMAIN 
	13/06/2014	CR3700		LHG008		Change function of_send_data() add parameter adw_claim_sent for save send amount and adjustment reason.
	23/03/2016	CR4243		LHC010		Update due date for claims
********************************************************************/

end subroutine

public function long of_send_errorcreditnote_email (ref mt_n_datastore ads_apost, long al_apost_row, ref string as_finemail);/********************************************************************
   of_send_creaditnote_errormail
   <DESC> Send email and store the credit note information when failed credit notes	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		aw_apost
		al_apost_row
   </ARGS>
   <USAGE> Send email and store the credit note information when failed credit notes</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16/11/2012 CR3017       LGX001        First Version
   </HISTORY>
********************************************************************/

string	ls_mail_subject, ls_mail_message, ls_errormessage
string	ls_vessel_ref, ls_voyage_nr, ls_profitcentername, ls_officename, ls_claimtype
string   ls_invoicenr, ls_docnum, ls_filename, ls_companycode, ls_claimnumber
datetime ldt_transdate, ldt_today

mt_n_outgoingmail 	lnv_mail

//get vessel name /pc name  	 
SELECT VESSELS.VESSEL_REF_NR, PROFIT_C.PC_NAME INTO :ls_vessel_ref, :ls_profitcentername 
FROM VESSELS LEFT OUTER JOIN PROFIT_C ON VESSELS.PC_NR = PROFIT_C.PC_NR 
WHERE VESSELS.VESSEL_NR = :istr_transaction_input.vessel_no  USING SQLCA ;

//get office / claim type  
SELECT CLAIMS.CLAIM_TYPE, OFFICES.OFFICE_NAME, OFFICES.EMAIL_ADR_FINANCE INTO :ls_claimtype, :ls_officename, :as_finemail 
FROM CLAIMS, OFFICES  
WHERE CLAIMS.OFFICE_NR = OFFICES.OFFICE_NR 
AND VESSEL_NR = :istr_transaction_input.vessel_no 
AND VOYAGE_NR = :istr_transaction_input.voyage_no
AND CHART_NR  = :istr_transaction_input.charter_no
AND CLAIM_NR  = :istr_transaction_input.claim_no 
USING SQLCA;

//get invoice no / doc number / file name / trans date / company code 
ls_invoicenr   = ads_apost.getitemstring(al_apost_row, "f20_invoicenr") 
ls_docnum      = ads_apost.getitemstring(al_apost_row, "f07_docnum")
ls_filename    = ads_apost.getitemstring(al_apost_row, "file_name")
ldt_transdate  = ads_apost.getitemdatetime(al_apost_row, "trans_date")
ls_companycode = ads_apost.getitemstring(al_apost_row, "f02_cmpcode")

ls_voyage_nr = istr_transaction_input.voyage_no
ls_claimnumber = string(istr_transaction_input.claim_no) + " " + ls_claimtype 
ldt_today = datetime(today(), now())

if isnull(ls_profitcentername) then ls_profitcentername = ""
if isnull(ls_officename) then ls_officename = "" 
if isnull(ls_vessel_ref) then ls_vessel_ref = ""
if isnull(ls_invoicenr) then ls_invoicenr = ""
if isnull(ls_docnum) then ls_docnum = ""
if isnull(ls_filename) then ls_filename = ""
if isnull(ls_companycode) then ls_companycode = ""
if isnull(ldt_transdate) then ldt_transdate = datetime(date("1900-01-01"))

//Save failed data before send email
INSERT INTO FAILED_CREDIT_NOTES(
				PC_NAME, COMPANY_CODE, OFFICE_NAME, VESSEL_REF_NR, VOYAGE_NR, CLAIM_TYPE, CLAIM_NUMBER, 
            AX_INVOICE_NR, DOC_NUMBER, TRANS_DATE, FILE_NAME, CREATED_BY, CREATED_DATE)
VALUES(:ls_profitcentername, :ls_companycode, :ls_officename, :ls_vessel_ref, :ls_voyage_nr, :ls_Claimtype, :ls_claimnumber, 
		 :ls_invoicenr, :ls_docnum, :ldt_transdate, :ls_filename, :uo_global.is_userid, :ldt_today);

ls_mail_message += "- Profit Center:"+ ls_profitcentername + " Company Code:" + ls_companycode + '~r~n'
ls_mail_message += "- Office Name:" + ls_officename + '~r~n'
ls_mail_message += "- Vessl Ref No: Name:" + ls_vessel_ref + " Voyage No:" + ls_voyage_nr + '~r~n'
ls_mail_message += "- Claim Type:" + ls_Claimtype + " Claim Number:" + ls_claimnumber + '~r~n'
ls_mail_message += "- AX Invoice No:" + ls_invoicenr + " Doc Number:"+ ls_docnum + '~r~n'
ls_mail_message += "- Transaction Date:" + string(ldt_transdate) + "File Name:" + ls_filename

//get subject
ls_mail_subject = "Failed Credit Notes (Vessel: " + ls_vessel_ref + ", Voyage: " + ls_voyage_nr + " date: " + string(ldt_today) + ")" 

if isnull(as_finemail) then as_finemail = ""
as_finemail = trim(as_finemail)
if as_finemail <> "" then
	lnv_mail = create mt_n_outgoingmail
	if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, as_finemail, ls_mail_subject, ls_mail_message, ls_errormessage) = -1 then	
		destroy lnv_mail
		ROLLBACK;
		return c#return.failure
	end if
	if lnv_mail.of_sendmail(ls_errormessage) = -1 then
		destroy lnv_mail
		ROLLBACK;
		return c#return.failure
	end if
	destroy lnv_mail
end if

return c#return.success

end function

public function integer of_credit_note (long al_payment_id, string as_invoice_nr, ref string as_finemail);/********************************************************************
of_credit_note
   <DESC> Creates Credit note by reversing previous transaction </DESC>
   <RETURN> 
		c#return.success: Success
		c#return.failed: Error
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		al_payment_id: CLAIMS.CLAIM_ID (link to TRANS_LOG_MAIN_A.PAYMENT_ID)
		as_invoice_nr: AX invoice number
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

string	ls_criteria; setNull(ls_criteria)
string	ls_null; setNull(ls_null)

long	ll_no_of_arows, ll_no_of_brows, ll_arow, ll_brow, ll_new_apost
long 	ll_null; setNull(ll_null)

double 		ld_transkey, ld_new_transkey
decimal{0}	ld_local, ld_DKK, ld_USD
datetime		ldt_null; setNull(ldt_null)
long ll_paymentid_error

mt_n_datastore	lds_apost, lds_bpost

ls_criteria = "Claims"

/* Change transactions sent to CODA - Revert them */
lds_apost = CREATE mt_n_datastore
lds_apost.dataObject = "d_coda_revert_hire_apost"
lds_apost.setTransObject(SQLCA)

lds_bpost = CREATE mt_n_datastore
lds_bpost.dataObject = "d_coda_revert_hire_bpost"
lds_bpost.setTransObject(SQLCA)

ll_no_of_arows = lds_apost.retrieve(al_payment_id, ls_criteria )  

if ll_no_of_arows > 0 then
	for ll_arow = 1 to ll_no_of_arows
		ld_transkey = lds_apost.getItemNumber(ll_arow, "trans_key")
		ll_no_of_brows = lds_bpost.retrieve(ld_transkey)
		if ll_no_of_brows > 0 then
			/* run create through B-posts copy and modify them */
			lds_bpost.rowsCopy(1, ll_no_of_brows, primary!, lds_bpost, 1, primary!)
			for ll_brow = 1 to ll_no_of_brows
				if lds_bpost.getItemNumber(ll_brow, "f29_debitcredit") = 160 then
					lds_bpost.setItem(ll_brow, "f29_debitcredit", 161)
				else
					lds_bpost.setItem(ll_brow, "f29_debitcredit", 160)
				end if						
				lds_bpost.setItem(ll_brow, "f03_yr", year(today()))
				lds_bpost.setItem(ll_brow, "f04_period", month(Today()))
				lds_bpost.setItem(ll_brow, "f08_doclinenum_b", ll_brow +1)
				
				if lds_bpost.getItemNumber(ll_brow, "f29_debitcredit") = 160 then
					ld_local += lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					//ld_DKK 	+= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					//ld_USD	+= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				else
					ld_local -= lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					//ld_DKK 	-= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					//ld_USD	-= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				end if
			next
			
			lds_apost.setItem(ll_arow, "payment_id", ll_null) 
			
			 ll_new_apost = lds_apost.InsertRow(0) 
			 lds_apost.rowsCopy(ll_arow, ll_arow, primary!, lds_apost, ll_new_apost, primary!)
			 lds_apost.deleterow(ll_new_apost + 1)

			lds_apost.setItem(ll_new_apost, "trans_key", ll_null)
			lds_apost.setItem(ll_new_apost, "f41_linedesr", "ClaimsCreditNote")

			lds_apost.setItem(ll_new_apost, "f20_invoicenr", as_invoice_nr)
			lds_apost.setItem(ll_new_apost, "f03_yr", year(today()))
			lds_apost.setItem(ll_new_apost, "f04_period", month(Today()))
			lds_apost.setItem(ll_new_apost, "f07_docnum", ls_null)
			lds_apost.setItem(ll_new_apost, "file_date", ldt_null)
			lds_apost.setItem(ll_new_apost, "file_user", ls_null)
			lds_apost.setItem(ll_new_apost, "file_name", ls_null)
			
			/*CR2771: Change user id and transaction date in credit notes, so user id represents the user id that 
			          created the credit note and the date represents the date when a credit note was created.*/
			lds_apost.setitem(ll_new_apost, "trans_date", datetime(today(), now()))
			lds_apost.setitem(ll_new_apost, "f09_docdate", datetime(today(), now()))
			lds_apost.setitem(ll_new_apost, "trans_user", uo_global.is_userid)
			lds_apost.setitem(ll_new_apost, "f05_auth_user", uo_global.is_userid)
			
			if ld_local >= 0 then
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 161)
			else
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 160)
			end if
			
			//lds_apost.setItem(ll_new_apost, "f30_valuedoc", abs(ld_local))
			// lds_apost.setItem(ll_new_apost, "f32_valuehome", abs(ld_DKK))
			// lds_apost.setItem(ll_new_apost, "f34_vatamo_or_valdual", abs(ld_USD))

			if lds_apost.Update(true, false) <> 1 then 
				ROLLBACK USING SQLCA;				
				of_send_errorcreditnote_email(lds_apost, ll_arow,as_finemail)
				COMMIT USING SQLCA;
				destroy lds_apost
				destroy lds_bpost
				return  c#return.Failure
			end if
			ld_new_transkey = lds_apost.getItemNumber(ll_new_apost, "trans_key")
			for ll_brow = 1 to ll_no_of_brows
				lds_bpost.setItem(ll_brow, "trans_key", ld_new_transkey)
			next
			if lds_bpost.Update(true, false) = 1 then
				lds_apost.resetUpdate()
				lds_bpost.resetUpdate()
			else
				ROLLBACK USING SQLCA;
				of_send_errorcreditnote_email(lds_apost, ll_arow, as_finemail)
				COMMIT USING SQLCA;
				destroy lds_apost
				destroy lds_bpost
				return  c#return.Failure
			end if
		end if	
	next
end if	

//commit;
return c#return.Success



end function

on n_claims_transaction.create
call super::create
end on

on n_claims_transaction.destroy
call super::destroy
end on

