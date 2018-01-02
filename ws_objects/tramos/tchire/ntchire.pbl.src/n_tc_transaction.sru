$PBExportHeader$n_tc_transaction.sru
forward
global type n_tc_transaction from mt_n_nonvisualobject
end type
end forward

global type n_tc_transaction from mt_n_nonvisualobject
end type
global n_tc_transaction n_tc_transaction

type variables

end variables

forward prototypes
public function integer of_credit_note (long al_payment_id, string as_invoice_nr)
public function integer of_send_data (s_transaction_input astr_transaction_input)
public subroutine documentation ()
public function integer of_send_errorcreditnote_email (ref n_ds adw_apost, long al_apost_row, ref string as_finemail)
public function integer of_credit_note (long al_payment_id, string as_invoice_nr, ref string as_finemail)
end prototypes

public function integer of_credit_note (long al_payment_id, string as_invoice_nr);/********************************************************************
of_credit_note
   <DESC> Creates Credit note by reversing previous transaction </DESC>
   <RETURN> 
		c#return.success: Success
		c#return.failed: Error
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		al_payment_id: NTC_PAYMENT.PAYMENT_ID (link to TRANS_LOG_MAIN_A.PAYMENT_ID)
		as_invoice_nr: AX invoice number
   </ARGS>
   <USAGE>Still can be used from external calls.  Now it is overriden to support the retrieval of the email address
	</USAGE>
********************************************************************/
string ls_dummy=""
return of_credit_note( al_payment_id, as_invoice_nr, ls_dummy)



end function

public function integer of_send_data (s_transaction_input astr_transaction_input);/********************************************************************
   of_send_data
   <DESC> send data to create CODA transaction  </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>   this would be called from w_print_tc </USAGE>
   <HISTORY>
		Date       CR-Ref       Author             Comments
		20/12/2011 M5-4         LGX001        First Version
		17/10/2012 2771			LGX001     	  The credit not should be created if astr_transaction_input.ax_invoice_nr is not null when
														  operator sends invoice data to AX (CR2771 Part2)		  
   </HISTORY>
********************************************************************/

long	ll_payment_status
integer 								li_rc = 0
long ll_payment_id
string ls_ax_invoice_nr, ls_finemail=""

u_transaction_hire_rec_coda	lnv_CODARECtransaction


ll_payment_id = astr_transaction_input.settle_tc_payment.getitemnumber(1, 'payment_id')
ls_ax_invoice_nr = astr_transaction_input.ax_invoice_nr

//if invoice number is null, set payment_id to null
if isnull(ls_ax_invoice_nr) or trim(ls_ax_invoice_nr) = "" then
	UPDATE TRANS_LOG_MAIN_A
	SET PAYMENT_ID = NULL
	WHERE PAYMENT_ID = :ll_payment_id and
		   TRANS_TYPE like "TCCODA%";
	if sqlca.sqlcode < 0 then
		ROLLBACK;
		messageBox("DB Error", "SqlCode   = "+string(sqlca.SQLCode) + &
							  "~n~rSql DB Code = "+string(sqlca.SQLDBCode) + &
							  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
		
		return c#return.Failure
	end if
//revert transacton	
elseif of_credit_note(ll_payment_id, trim(ls_ax_invoice_nr), ls_finemail) = c#return.Failure then
	rollback;
	if ls_finemail="" then ls_finemail = "unknown"
	messagebox("Error","The invoice data has not been sent to AX, because the credit note creation failed." + c#string.cr + c#string.cr +"A notification email has been sent to " +  ls_finemail + "." + c#string.cr + "Please contact Finance for further assistance.")
	return c#return.Failure	
end if

astr_transaction_input.ax_invoice_nr = ""

//Real time check payment status
SELECT PAYMENT_STATUS
INTO: ll_payment_status
FROM NTC_PAYMENT
WHERE PAYMENT_ID = :ll_payment_id
      AND INCOME = 1  // TC OUT
USING SQLCA ;


if isnull(ll_payment_status) then ll_payment_status = 0
// payment status: New(1) / Draft(2)
if ll_payment_status = 1 or ll_payment_status = 2 then
	/* Generate CODA Transaction */
	lnv_CODARECtransaction = create u_transaction_hire_rec_coda
	li_rc = lnv_CODARECtransaction.of_generate_transaction(astr_transaction_input)
	destroy lnv_CODARECtransaction
	
	if li_rc = -1 then return c#return.Failure
	return c#return.Success	
else
	messagebox("Error","Falied to send data to AX, only payment with New or Draft status can be proceeded." )
	return c#return.Failure
end if



end function

public subroutine documentation (); /********************************************************************
   documentation
   <DESC> of_send_data : create TC out transaction
	       of_credit_not: creates credit note transaction 
	</DESC>
   <USAGE>	this object is used from w_print_support_document.print 	</USAGE>
   <HISTORY>
		Date       CR-Ref       Author             Comments
		10/01/2012 M5-4         LGX001        First Version
		14/09/2012 2771			ZSW001		  Change user id and transaction date in credit notes, so user id represents the user id that 
														  created the credit note and the date represents the date when a credit note was created.
		17/10/2012 3017			LGX001		  The credit not should be created if astr_transaction_input.ax_invoice_nr is not null when
														  operator sends invoice data to AX (CR2771 Part2)
		29/10/2012 2771			LGX001		  Change F05_AUTH_USER / F09_DOCDATE in credit notes, so user id represents the user id that 
														  created the credit note and the date represents the date when a credit note was created.
		16/11/2012 3017			LGX001		Send email and store the credit note information when failed credit notes
		04/04/2013 3017			AGL027		Modify messagebox text content.  include email address
		14/05/2013 2690			LGX001		Change the hardcode of  "tramosMT@maersk.com" to C#EMAIL.TRAMOSSUPPORT 
		09/04/2015 3930         KSH092      Change Revert T/C Hire when set draft
   </HISTORY>
********************************************************************/


end subroutine

public function integer of_send_errorcreditnote_email (ref n_ds adw_apost, long al_apost_row, ref string as_finemail);/********************************************************************
   of_send_creaditnote_errormail
   <DESC>	Description	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		aw_apost
		al_apost_row
   </ARGS>
   <USAGE>	Record and send Email when  failed credit note </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16/11/2012 CR3017       LGX001        First Version
   </HISTORY>
********************************************************************/

string	ls_mail_subject, ls_mail_message, ls_errormessage
string	ls_vessel_ref, ls_voyage_nr, ls_profitcentername, ls_officename, ls_transtype
string   ls_invoicenr, ls_docnum, ls_filename, ls_companycode, ls_claimnumber
long		ll_paymentid
datetime ldt_transdate, ldt_today

mt_n_outgoingmail 	lnv_mail

ll_paymentid = adw_apost.getitemnumber(al_apost_row, "payment_id")

// get office / vessel ref / pc name   
SELECT OFFICES.OFFICE_NAME, OFFICES.EMAIL_ADR_FINANCE, VESSELS.VESSEL_REF_NR, PROFIT_C.PC_NAME 
INTO :ls_officename, :as_finemail, :ls_vessel_ref, :ls_profitcentername  
FROM  NTC_TC_CONTRACT LEFT OUTER JOIN  OFFICES ON OFFICES.OFFICE_NR = NTC_TC_CONTRACT.OFFICE_NR, 
		VESSELS 			 LEFT OUTER JOIN PROFIT_C ON VESSELS.PC_NR = PROFIT_C.PC_NR 
WHERE  NTC_TC_CONTRACT.VESSEL_NR = VESSELS.VESSEL_NR AND		 
       CONTRACT_ID = (SELECT CONTRACT_ID FROM NTC_PAYMENT WHERE PAYMENT_ID = :ll_paymentid)
USING SQLCA;

// get invoice no / doc number / file name / trans date / company code / trans type
ls_invoicenr   = adw_apost.getitemstring(al_apost_row, "ax_invoice_nr") 
ls_docnum      = adw_apost.getitemstring(al_apost_row, "f07_docnum")
ls_filename    = adw_apost.getitemstring(al_apost_row, "file_name")
ldt_transdate  = adw_apost.getitemdatetime(al_apost_row, "trans_date")
ls_companycode = adw_apost.getitemstring(al_apost_row, "f02_cmpcode")
ls_transtype   = adw_apost.getitemstring(al_apost_row, "trans_type")

if isnull(ls_profitcentername) then ls_profitcentername = ""
if isnull(ls_officename) then ls_officename = "" 
if isnull(ls_vessel_ref) then ls_vessel_ref = ""
if isnull(ls_invoicenr) then ls_invoicenr = ""
if isnull(ls_docnum) then ls_docnum = ""
if isnull(ls_filename) then ls_filename = ""
if isnull(ls_companycode) then ls_companycode = ""
if isnull(ls_transtype) then ls_transtype = ""
if isnull(ldt_transdate) then ldt_transdate = datetime(date("1900-01-01"))

ldt_today = datetime(today(), now())
ls_claimnumber = ""
ls_voyage_nr = ""

//Save failed data before send email
INSERT INTO FAILED_CREDIT_NOTES(
				PC_NAME, COMPANY_CODE, OFFICE_NAME, VESSEL_REF_NR, VOYAGE_NR, CLAIM_TYPE, CLAIM_NUMBER, 
            AX_INVOICE_NR, DOC_NUMBER, TRANS_DATE, FILE_NAME, CREATED_BY, CREATED_DATE)
VALUES(:ls_profitcentername, :ls_companycode, :ls_officename, :ls_vessel_ref, :ls_voyage_nr, :ls_transtype, :ls_claimnumber, 
		 :ls_invoicenr, :ls_docnum, :ldt_transdate, :ls_filename, :uo_global.is_userid, :ldt_today);

ls_mail_message += "- Profit Center:" + ls_profitcentername + " Company Code:" + ls_companycode + '~r~n'
ls_mail_message += "- Office Name:" + ls_officename + '~r~n'
ls_mail_message += "- Vessl Ref No: Name:" + ls_vessel_ref + " Voyage No:" + ls_voyage_nr + '~r~n'
ls_mail_message += "- Claim Type:" + ls_transtype + " Claim Number:" + ls_claimnumber + '~r~n'
ls_mail_message += "- AX Invoice No:" + ls_invoicenr + " Doc Number:"+ ls_docnum + '~r~n'
ls_mail_message += "- Transaction Date:" + string(ldt_transdate) + "File Name:" + ls_filename

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
		al_payment_id: NTC_PAYMENT.PAYMENT_ID (link to TRANS_LOG_MAIN_A.PAYMENT_ID)
		as_invoice_nr: AX invoice number
   </ARGS>
   <USAGE> called from of_send_data()  </USAGE>
********************************************************************/
string ls_criteria
string ls_null; setNull(ls_null)
string ls_doccode_cms_pay, ls_doccode_cms_pay_cr, ls_doccode_cms_rec, ls_doccode_cms_rec_cr

long	ll_no_of_arows, ll_no_of_brows, ll_arow, ll_brow, ll_new_apost
long 	ll_null; setNull(ll_null)

double 		ld_transkey, ld_new_transkey
decimal{0}	ld_local, ld_DKK, ld_USD
datetime		ldt_null; setNull(ldt_null)

n_ds	lds_apost, lds_bpost

ls_criteria = "TCCODA%"


/* Get doccode for CMS transactions so that they can be converted */
SELECT DOCCODE_CMS_PAYMENTS,   
		DOCCODE_CMS_PAYMENTS_CR,   
		DOCCODE_CMS_RECEIVABLES,   
		DOCCODE_CMS_RECEIVABLES_CR  
INTO :ls_doccode_cms_pay,   
     :ls_doccode_cms_pay_cr,   
		:ls_doccode_cms_rec,   
		:ls_doccode_cms_rec_cr  
FROM DEFAULT_TRANS_VALUES  ;

/* Change transactions sent to CODA - Revert them */
lds_apost = CREATE n_ds
lds_apost.dataObject = "d_coda_revert_hire_apost"
lds_apost.setTransObject(SQLCA)

lds_bpost = CREATE n_ds
lds_bpost.dataObject = "d_coda_revert_hire_bpost"
lds_bpost.setTransObject(SQLCA)

ll_no_of_arows = lds_apost.retrieve(al_payment_id, ls_criteria )  
if ll_no_of_arows > 0 then
	for ll_arow = 1 to ll_no_of_arows
		ld_local = 0
		ld_DKK = 0
		ld_USD = 0
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
				/* If CMS thansaction month and day if CODA only month */
				if lds_bpost.getItemNumber(ll_brow, "f04_period") > 12 then
					lds_bpost.setItem(ll_brow, "f04_period", integer(String(Today(),"MM") + String(Today(),"DD")))
				else
					lds_bpost.setItem(ll_brow, "f04_period", month(Today()))
				end if					
				lds_bpost.setItem(ll_brow, "f08_doclinenum_b", ll_brow +1)
				if lds_bpost.getItemNumber(ll_brow, "f29_debitcredit") = 160 then
					ld_local += lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					ld_DKK 	+= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					ld_USD	+= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				else
					ld_local -= lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					ld_DKK 	-= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					ld_USD	-= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				end if
			next
			
			lds_apost.setItem(ll_arow, "payment_id", ll_null)  /* must be cleared before copy */
			ll_new_apost = lds_apost.InsertRow(0)
			lds_apost.rowsCopy(ll_arow, ll_arow, primary!, lds_apost, ll_new_apost, primary!)
			lds_apost.deleterow(ll_new_apost + 1)
			lds_apost.setItem(ll_new_apost, "f41_linedesr", "Revert T/C Hire")
			lds_apost.setItem(ll_new_apost, "trans_key", ll_null)
			
			/*CR2771: Change user id and transaction date in credit notes, so user id represents the user id that 
			          created the credit note and the date represents the date when a credit note was created.*/
			lds_apost.setitem(ll_new_apost, "trans_date", datetime(today(), now()))
			lds_apost.setitem(ll_new_apost, "f09_docdate", datetime(today(), now()))
			lds_apost.setitem(ll_new_apost, "trans_user", uo_global.is_userid)
			lds_apost.setitem(ll_new_apost, "f05_auth_user", uo_global.is_userid)
						
			if lds_apost.getItemString(ll_new_apost, "f06_doccode") = ls_doccode_cms_pay then
				lds_apost.setItem(ll_new_apost, "f06_doccode", ls_doccode_cms_pay_cr)
			end if
			if lds_apost.getItemString(ll_new_apost, "f06_doccode") = ls_doccode_cms_rec then
				lds_apost.setItem(ll_new_apost, "f06_doccode", ls_doccode_cms_rec_cr)
			end if			
			lds_apost.setItem(ll_new_apost, "f03_yr", year(today()))
			lds_apost.setItem(ll_new_apost, "f20_invoicenr", as_invoice_nr)
			/* If CMS thansaction month and day if CODA only month */
			if lds_apost.getItemNumber(ll_new_apost, "f04_period") > 12 then
				lds_apost.setItem(ll_new_apost, "f04_period", integer(String(Today(),"MM") + String(Today(),"DD")))
			else
				lds_apost.setItem(ll_new_apost, "f04_period", month(Today()))
			end if					
			lds_apost.setItem(ll_new_apost, "f07_docnum", ls_null)
			lds_apost.setItem(ll_new_apost, "file_date", ldt_null)
			lds_apost.setItem(ll_new_apost, "file_user", ls_null)
			lds_apost.setItem(ll_new_apost, "file_name", ls_null)
			if ld_local >= 0 then
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 161)
			else
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 160)
			end if
			lds_apost.setItem(ll_new_apost, "f30_valuedoc", abs(ld_local))
			lds_apost.setItem(ll_new_apost, "f32_valuehome", abs(ld_DKK))
			lds_apost.setItem(ll_new_apost, "f34_vatamo_or_valdual", abs(ld_USD))
			if lds_apost.Update(true, false) <> 1 then 
				ROLLBACK USING SQLCA;
				lds_apost.setItem(ll_arow, "payment_id", al_payment_id) 
				of_send_errorcreditnote_email(lds_apost, ll_arow, as_finemail)
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
				lds_apost.setItem(ll_arow, "payment_id", al_payment_id)
				of_send_errorcreditnote_email(lds_apost, ll_arow, as_finemail)
				COMMIT USING SQLCA;
				destroy lds_apost
				destroy lds_bpost
				return  c#return.Failure				
			end if
		end if	
	next
end if

return c#return.Success



end function

on n_tc_transaction.create
call super::create
end on

on n_tc_transaction.destroy
call super::destroy
end on

