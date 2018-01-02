$PBExportHeader$w_print_tc.srw
forward
global type w_print_tc from mt_w_response
end type
type cb_close from commandbutton within w_print_tc
end type
type cb_print from commandbutton within w_print_tc
end type
type cbx_send_to_ax from checkbox within w_print_tc
end type
type cbx_print_doc from checkbox within w_print_tc
end type
type dw_paymentcurr from u_datawindow_sqlca within w_print_tc
end type
end forward

global type w_print_tc from mt_w_response
integer width = 1737
integer height = 508
string title = "Print Supporting Documents"
boolean ib_setdefaultbackgroundcolor = true
cb_close cb_close
cb_print cb_print
cbx_send_to_ax cbx_send_to_ax
cbx_print_doc cbx_print_doc
dw_paymentcurr dw_paymentcurr
end type
global w_print_tc w_print_tc

type variables
s_h_statement 	istr_h_statement
end variables

forward prototypes
public subroutine documentation ()
public function long wf_send_data_to_ax ()
public function integer wf_update_payments_status (long al_payment_status_new, boolean ab_printdate)
public function long wf_get_payment_status (ref long al_payment_status, ref string as_invoice_nr, ref boolean ab_tc_out, ref boolean ab_locked)
public function integer wf_enable_paymentcurr ()
public subroutine wf_disable_print ()
public function decimal wf_get_rst_exrate (string as_payment_curr, date adate_exrate_date)
end prototypes

public subroutine documentation ();/********************************************************************
	w_print_tc
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
		Date			CR-Ref		Author 		Comments
   	30/12/2011 	M5-4			LGX001		First Version
		27/03/2012 	M5-10 		LGX001		add LOCKED STATUS after send data to AX
		30/10/2012 	CR2771		LGX001		lstr_transValues.doc_date should be have time(today(), now()) 	
     	11/08/2014	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		 22/06/2016	 CR3316		KSH092		With History hirestatements the cbx_send_to_ax button disabled and not editable,
		                                                      Print button should be disabled if both options are unselected
		08/10/2016	CR2212   	LHG008		Sanctions restrictions
	</HISTORY>
********************************************************************/

end subroutine

public function long wf_send_data_to_ax ();/******************************************************************************
   wf_send_data_to_ax
   <DESC> to create tc out coda transaction </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>   </USAGE>
   <HISTORY>
   	Date       CR-Ref			Author             Comments
   	20/12/2011 M5-4 			LGX001			First Version
		27/03/2012 M5-10        LGX001        add LOCKED STATUS after send data to AX
		30/10/2012 CR2771       LGX001		lstr_transValues.doc_date should be have time(today(), now()) 
		08/10/2016 CR2212       LHG008		Sanctions restrictions
   </HISTORY>
***********************************************************************************/
integer 								li_rc = 0
string                        ls_invoice_nr, ls_mysql
date									ldate_exrate_date
s_transaction_input				lstr_transValues
n_tc_transaction	lnv_tc_transaction
n_ds		lds_data

SELECT INVOICE_NR INTO: ls_invoice_nr FROM NTC_PAYMENT WHERE PAYMENT_ID = :istr_h_statement.payment_id;

/* Make sure that payment balance is updated */
ls_mySQL = "sp_paymentBalance " + string(istr_h_statement.payment_id)
EXECUTE IMMEDIATE :ls_mySQL;
commit;  

lds_data = CREATE n_ds
lds_data.DataObject="d_settle_one_tc_payment"
lds_data.setTransObject(SQLCA)
lds_data.retrieve(istr_h_statement.payment_id)

lstr_transValues.vessel_no = lds_data.getItemNumber(1, "vessel_nr")
lstr_transValues.coda_or_cms = true   /* = CODA */
lstr_transValues.settle_tc_payment = lds_data
lstr_transValues.doc_date = datetime(today(), now())
if not (isnull(ls_invoice_nr) or trim(ls_invoice_nr) = '') then
	lstr_transValues.ax_invoice_nr = trim(ls_invoice_nr)
end if

if dw_paymentcurr.visible then
	lstr_transvalues.s_sanction_currency = dw_paymentcurr.getitemstring(1, "payment_curr")
	lstr_transvalues.d_exrate_from_invoice = dw_paymentcurr.getitemdecimal(1, "exrate_invoice")
	
	lstr_transvalues.s_sanction_line_1 = "Exchange rate " + string(lstr_transvalues.d_exrate_from_invoice, "0.000000")
	ldate_exrate_date = dw_paymentcurr.getitemdate(1, "exrate_date")
	if not isnull(ldate_exrate_date) then
		lstr_transvalues.s_sanction_line_1 += " (" + string(ldate_exrate_date, "d mmm yyyy") + ")"
	end if
end if

// receiveable Transaction
lnv_tc_transaction = create n_tc_transaction
li_rc = lnv_tc_transaction.of_send_data(lstr_transValues)
destroy lnv_tc_transaction

if li_rc = -1 then return c#return.Failure

// set lock status / trans to coda
update NTC_PAYMENT
SET  TRANS_TO_CODA = 1,
     LOCKED = 1	 
WHERE PAYMENT_ID = :istr_h_statement.payment_id;
if SQLCA.SQLCODE <> 0 then
	rollback;
	messagebox('Error', "Failed to update payment data")
   return c#return.Failure
end if

return c#return.Success
end function

public function integer wf_update_payments_status (long al_payment_status_new, boolean ab_printdate);/********************************************************************
   wf_update_reflesh_payments
   <DESC> to set the payment status / printed date if needed </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/2011 M5-4         LGX001        First Version
   </HISTORY>
********************************************************************/
datetime ldt_printdate = datetime(string(today()))
if ab_printdate then
	UPDATE NTC_PAYMENT  
	SET PAYMENT_STATUS = :al_payment_status_new,
		 PRINT_DATE = :ldt_printdate	
	WHERE NTC_PAYMENT.PAYMENT_ID = :istr_h_statement.payment_id;
else
	UPDATE NTC_PAYMENT  
	SET PAYMENT_STATUS = :al_payment_status_new
	WHERE NTC_PAYMENT.PAYMENT_ID = :istr_h_statement.payment_id;
end if
if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("Update error", "Error updating payment status when printing")
	return c#return.Failure
end if

if isvalid(w_tc_payments) then
	w_tc_payments.cb_refresh.post event clicked()
end if

return c#return.Success
end function

public function long wf_get_payment_status (ref long al_payment_status, ref string as_invoice_nr, ref boolean ab_tc_out, ref boolean ab_locked);/********************************************************************
   wf_get_payment_status
   <DESC> to get the payment status and else information  </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Use this function to get Payment status information </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/2011 M5-4         LGX001        First Version
   </HISTORY>
********************************************************************/
long ll_income, ll_locked

ab_tc_out = false
ab_locked = false

SELECT NTC_PAYMENT.PAYMENT_STATUS, NTC_PAYMENT.INVOICE_NR, NTC_PAYMENT.INCOME, NTC_PAYMENT.LOCKED
INTO :al_payment_status, :as_invoice_nr, :ll_income, :ll_locked
FROM NTC_PAYMENT  
WHERE NTC_PAYMENT.PAYMENT_ID = :istr_h_statement.payment_id ;
if sqlca.sqlcode = 0 then 
	if ll_income = 1 then ab_tc_out = true
	if ll_locked = 1 then ab_locked = true
	return c#return.Success
else
	messagebox("Select error", "Error selecting Payment ID when printing")
	return c#return.Failure
end if
 
 
end function

public function integer wf_enable_paymentcurr ();/********************************************************************
   wf_enable_paymentcurr
   <DESC>	Check the claim whether is sanction	or not, if sanction then set the dw to visible, else invisible	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction: 0, NoAction
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	call by window open event	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		08/10/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_deverrmsg, ls_restrict_curr, ls_default_curr, ls_null
decimal	ld_exrate
date		ldate_exrate_date
long		ll_payment_id
integer	li_is_history
datawindowchild ldwc_child

if istr_h_statement.payment_id = istr_h_statement.payment_id_low then
	li_is_history = 0
else
	li_is_history = 1
end if

DECLARE SP_GET_RST_DEF_CURR_TCOUT PROCEDURE FOR
	SP_GET_RST_DEF_CURR_TCOUT	@contract_id = :istr_h_statement.contract_id,
										@paymentid = :istr_h_statement.payment_id,
										@is_history = :li_is_history,
										@restrict_curr = :ls_restrict_curr output,
										@default_curr = :ls_default_curr output,
										@last_rst_payment =:istr_h_statement.l_last_rst_payment output
	USING SQLCA;

EXECUTE SP_GET_RST_DEF_CURR_TCOUT;

if sqlca.sqlcode = -1 then
	ls_deverrmsg = sqlca.sqlerrtext
	CLOSE SP_GET_RST_DEF_CURR_TCOUT;
	_addmessage(this.classdefinition, "wf_enable_paymentcurr()", "Failed to get restriction info.", ls_deverrmsg)
	
	return c#return.Failure
end if

FETCH SP_GET_RST_DEF_CURR_TCOUT INTO :ls_restrict_curr, :ls_default_curr, :istr_h_statement.l_last_rst_payment;

if sqlca.sqlcode = -1 then
	ls_deverrmsg = sqlca.sqlerrtext
	CLOSE SP_GET_RST_DEF_CURR_TCOUT;
	_addmessage(this.classdefinition, "wf_enable_paymentcurr()", "Failed to get restriction info.", ls_deverrmsg)
	
	return c#return.Failure
end if

CLOSE SP_GET_RST_DEF_CURR_TCOUT;

if len(ls_restrict_curr) > 0 then
	dw_paymentcurr.settransobject(sqlca)
	if li_is_history = 1 then
		ll_payment_id = istr_h_statement.l_last_rst_payment
	else
		ll_payment_id = istr_h_statement.payment_id
	end if
	
	if dw_paymentcurr.retrieve(ll_payment_id) <= 0 then return c#return.NoAction
	
	//If printing hire statements with history, do not show the dw
	if li_is_history = 1 then return c#return.Success
	
	dw_paymentcurr.getchild("payment_curr", ldwc_child)
	ldwc_child.setfilter("curr_code not in(" + ls_restrict_curr + ")")
	ldwc_child.filter()
	
	setnull(ldate_exrate_date)
	dw_paymentcurr.setitem(1, "exrate_date", ldate_exrate_date)
	
	setnull(ls_null)
	dw_paymentcurr.setitem(1, "payment_curr", ls_null)
	
	if ls_default_curr = '' then setnull(ls_default_curr)
	if isnull(ls_default_curr) then
		setnull(ld_exrate)
		dw_paymentcurr.setitem(1, "payment_curr", ls_default_curr)
		dw_paymentcurr.setitem(1, "exrate_invoice", ld_exrate)
	else
		dw_paymentcurr.settext(ls_default_curr)
		dw_paymentcurr.setcolumn("payment_curr")
	end if
	
	dw_paymentcurr.setitem(1, "restrict_curr", ls_restrict_curr)
	dw_paymentcurr.setitem(1, "rst_default_curr", ls_default_curr)
	
	istr_h_statement.s_restrict_curr_list = ls_restrict_curr
	istr_h_statement.s_default_curr = ls_default_curr
	
	dw_paymentcurr.modify("exrate_invoice_t.text = 'Ex Rate from " + istr_h_statement.s_tccurrcode + "'")
	dw_paymentcurr.visible = true
	
	return c#return.Success
end if

return c#return.NoAction
end function

public subroutine wf_disable_print ();/********************************************************************
   wf_disable_print
   <DESC>	Eenabled or disable print button	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/10/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string ls_default_curr
decimal ld_exrate
boolean lb_disable_print

if cbx_print_doc.checked = false and cbx_send_to_ax.checked = false then
	lb_disable_print = true
else
	lb_disable_print = false
end if

if not lb_disable_print and dw_paymentcurr.visible then
	ls_default_curr = dw_paymentcurr.getitemstring(1, "payment_curr")
	ld_exrate = dw_paymentcurr.getitemdecimal(1, "exrate_invoice")
	if isnull(ls_default_curr) or ls_default_curr = '' or isnull(ld_exrate) or ld_exrate = 0 then lb_disable_print = true
end if

cb_print.enabled = not lb_disable_print
end subroutine

public function decimal wf_get_rst_exrate (string as_payment_curr, date adate_exrate_date);/********************************************************************
   wf_get_rst_exrate
   <DESC>	Calculate exchange rate between invoice currency and payment currency	</DESC>
   <RETURN>	decimal:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_payment_curr
		adate_exrate_date
   </ARGS>
   <USAGE>	dw_paymentcurr.itemchanged()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		08/10/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_METHOD_NAME = "wf_get_rst_exrate()"
decimal	ld_payment_exrate, ld_invoice_exrate, ld_exrate
n_claimcurrencyadjust	lnv_curradjust
s_cargo_base_data			lstr_cargo_data
n_exchangerate				lnv_exrate

if istr_h_statement.s_tccurrcode = as_payment_curr then return 100.00

ld_invoice_exrate = lnv_exrate.of_getexchangerate(istr_h_statement.s_tccurrcode, "USD", adate_exrate_date, false)
if ld_invoice_exrate > 0 then
	ld_payment_exrate = lnv_exrate.of_getexchangerate(as_payment_curr, "USD", adate_exrate_date, false)
end if

if ld_invoice_exrate > 0 and ld_payment_exrate > 0 then
	ld_exrate = ld_invoice_exrate / ld_payment_exrate  * 100
else
	ld_invoice_exrate = lnv_exrate.of_getexchangerate(istr_h_statement.s_tccurrcode, "DKK", adate_exrate_date, false)
	if ld_invoice_exrate > 0 then
		ld_payment_exrate = lnv_exrate.of_getexchangerate(as_payment_curr, "DKK", adate_exrate_date, false)
		if ld_payment_exrate > 0 then
			ld_exrate =  ld_invoice_exrate / ld_payment_exrate  * 100
		end if
	end if
end if

if isnull(ld_exrate) or ld_exrate <= 0 then
	ld_exrate = 0
end if

return ld_exrate
end function

on w_print_tc.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_print=create cb_print
this.cbx_send_to_ax=create cbx_send_to_ax
this.cbx_print_doc=create cbx_print_doc
this.dw_paymentcurr=create dw_paymentcurr
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cbx_send_to_ax
this.Control[iCurrent+4]=this.cbx_print_doc
this.Control[iCurrent+5]=this.dw_paymentcurr
end on

on w_print_tc.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.cbx_send_to_ax)
destroy(this.cbx_print_doc)
destroy(this.dw_paymentcurr)
end on

event open;call super::open;long ll_payment_status
boolean lb_tc_out, lb_locked_status
string ls_invoice_nr
n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

istr_h_statement = message.powerobjectparm

if this.wf_get_payment_status(ll_payment_status, ls_invoice_nr, lb_tc_out, lb_locked_status) = c#return.Failure then 
	close(this)
	return
end if

/* tc out and unlocked and payment_status : New(1) / Draft(2) */
if lb_tc_out = true and lb_locked_status = false and (ll_payment_status = 1 or ll_payment_status = 2) then
	if istr_h_statement.payment_id = istr_h_statement.payment_id_low then
		cbx_send_to_ax.enabled = true
	end if
end if

lnv_style.of_dwformformater(dw_paymentcurr)
wf_enable_paymentcurr()

wf_disable_print()
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_tc
end type

type cb_close from commandbutton within w_print_tc
integer x = 1353
integer y = 304
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_print from commandbutton within w_print_tc
integer x = 987
integer y = 304
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
boolean default = true
end type

event clicked;long ll_rc, ll_payment_status_old
decimal ld_exrate, ld_payment_amount
string ls_defaultPrinter, ls_PDFprinter, ls_tittle_text
string ls_sanction_line1, ls_sanction_curr, ls_amount
string ls_invoice_nr
date ldate_exrate_date
boolean lb_tc_out, lb_locked_status
pointer old_pointer
datawindowchild ldwc_child

if isvalid(w_hire_statement) = false then
	messagebox("Error", "Invalid Operation!")
	return 
end if
/* no selected then return */
if cbx_print_doc.checked = false and cbx_send_to_ax.checked = false then return

if wf_get_payment_status(ll_payment_status_old, ls_invoice_nr, lb_tc_out, lb_locked_status) = c#return.Failure then return

old_pointer = SetPointer(HourGlass!)

//send data to ax
if cbx_send_to_ax.checked then 	
	/* create receiced transaction */ 
	if wf_send_data_to_ax() =  c#return.Success then
		/* update payment status Final(3) and printed date if needed */
		if wf_update_payments_status(3, true) =  c#return.Success then 
			if isValid(w_tc_payments) then w_tc_payments.cb_refresh.post event Clicked()
		end if
		
		if cbx_send_to_ax.checked and dw_paymentcurr.visible then
			if dw_paymentcurr.update() = 1 then
				update NTC_TC_CONTRACT
					set LAST_RESTRICTED_PAYMENT = :istr_h_statement.payment_id,
						 RESTRICT_CURR = :istr_h_statement.s_restrict_curr_list,
						 RST_DEFAULT_CURR = :istr_h_statement.s_default_curr
				 where CONTRACT_ID = :istr_h_statement.contract_id
				   and isnull(LAST_RESTRICTED_PAYMENT, 0) < :istr_h_statement.payment_id;
					
				if sqlca.sqlcode <> 0 then
					ROLLBACK;
					messagebox("Error", "Falied to update sanction info.", StopSign!)
				else
					COMMIT;
					/* show confirmation message */
					messagebox("Print Invoice", "Invoice data sent to Finance system successfully.")
				end if
			else
				ROLLBACK;
				messagebox("Error", "Falied to update sanction info.", StopSign!)
			end if
		else
			COMMIT;
			/* show confirmation message */
			messagebox("Print Invoice", "Invoice data sent to Finance system successfully.")
		end if
	end if
end if

commit;

SetPointer(old_pointer)

//print support document
if cbx_print_doc.checked then
	w_hire_statement.setredraw(false)
	
	/* update payment status if needed */
   if not cbx_send_to_ax.checked  then			
		if ll_payment_status_old = 1 then
			 /* New(1) changed to Draft(2) */
			 if wf_update_payments_status(2, false) = c#return.Failure then return
			 if isValid(w_tc_payments) then w_tc_payments.cb_refresh.post event Clicked()
		end if
	end if
	commit;
	
	w_hire_statement.dw_statement.getchild("dw_totals", ldwc_child)
	if dw_paymentcurr.rowcount() = 1 then
		ls_sanction_curr = dw_paymentcurr.getitemstring(1, "payment_curr")
		ld_exrate = dw_paymentcurr.getitemdecimal(1, "exrate_invoice")
		
		ls_sanction_line1 = "Exchange rate " + string(ld_exrate, "0.000000")
		ldate_exrate_date = dw_paymentcurr.getitemdate(1, "exrate_date")
		
		if not isnull(ldate_exrate_date) then
			ls_sanction_line1 += " (" + string(ldate_exrate_date, "d mmm yyyy") + ")"
		end if
		
		ldwc_child.modify("t_sanction_line1.Text='" + ls_sanction_line1 + "'")
		ldwc_child.modify("t_sanction_curr.Text='" + ls_sanction_curr + "'")
		
		ls_amount = ldwc_child.describe("total_debit.text")
		if ls_amount = '-' or ls_amount = '' then
			//ldwc_child.modify("t_sanction_debit.font.underline = '0'")
			ldwc_child.modify("t_sanction_debit.Text='" + ls_amount + "'")
		else
			ld_payment_amount = dec(ls_amount) * ld_exrate / 100
			ldwc_child.modify("t_sanction_debit.Text='" + string(ld_payment_amount, "#,##0.00") + "'")
		end if
		
		ls_amount = ldwc_child.describe("total_kredit.text")
		if ls_amount = '-' or ls_amount = '' then
			//ldwc_child.modify("t_sanction_kredit.font.underline = '0'")
			ldwc_child.modify("t_sanction_kredit.Text='" + ls_amount + "'")
		else
			ld_payment_amount = dec(ls_amount) * ld_exrate / 100
			ldwc_child.modify("t_sanction_kredit.Text='" + string(ld_payment_amount, "#,##0.00") + "'")
		end if
		
		ldwc_child.modify("DataWindow.Header.Height=472")
	end if
	
	//print support document
	ll_rc = messagebox("Generate Hire-Statement...", "Would you like to print the Statement on a printer?~r~n~r~n" +&
					"Yes = Printer~r~nNo  = PDFfile~r~n~r~nIf status is <New> it will be changed " +&
					"to <Draft>", Question!,	YesNoCancel!, 1)								
	
	choose case ll_rc
		case 1 /* Printer */
			
			w_hire_statement.dw_statement.Print()
			
		case 2 /* PDF file */
			/*Get the current printer*/
			ls_defaultPrinter = printGetPrinter()
			ls_PDFprinter = uo_global.is_pdfdriver 
			if  ls_PDFprinter = "None" then
				MessageBox("Error!", "No PDF printer driver found in TRAMOS.INI file. ~r~nPlease try again "+&
								"or contact the System Administrator if the problem recurs.", StopSign!)
				return
			end if
				
			/*Set the default printer to PDF, print, and set the default printer back to the original default*/
			if printSetPrinter(ls_pdfPrinter) = 1 then
				
				w_hire_statement.dw_statement.print(false, false)
				
				printSetPrinter(ls_DefaultPrinter)
			else
				messagebox("Error!", "Error setting printer to PDF. ~r~nPlease try again or contact the "+&
								"System Administrator if the problem recurs.", StopSign!)
			end if		
		case 3
			
	end choose
	
	ldwc_child.modify("DataWindow.Header.Height=284")
	w_hire_statement.setredraw(true)
end if

close(parent)




end event

type cbx_send_to_ax from checkbox within w_print_tc
integer x = 37
integer y = 32
integer width = 750
integer height = 56
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Send invoice data to AX"
end type

event clicked;wf_disable_print()
end event

type cbx_print_doc from checkbox within w_print_tc
integer x = 37
integer y = 144
integer width = 841
integer height = 56
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print supporting documents"
boolean checked = true
end type

event clicked;wf_disable_print()
end event

type dw_paymentcurr from u_datawindow_sqlca within w_print_tc
boolean visible = false
integer x = 937
integer y = 32
integer width = 754
integer height = 232
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_ff_paymentcurr_tcout"
boolean border = false
boolean ib_autoaccept = true
end type

event constructor;call super::constructor;dw_paymentcurr.modify("payment_curr.background.mode = '0' payment_curr.color = " + string(c#color.black) + " payment_curr.background.color = " + string(c#color.MT_MAERSK))
dw_paymentcurr.modify("exrate_invoice.background.mode = '0' exrate_invoice.color = " + string(c#color.black) + " exrate_invoice.background.color = " + string(c#color.MT_MAERSK))

end event

event itemchanged;call super::itemchanged;string	ls_payment_curr
decimal	ld_payment_exrate, ld_exrate
date		ldate_exrate_date
n_exchangerate lnv_exrate

if row > 0 and isvalid(dwo) then
	choose case dwo.name
		case "payment_curr", "exrate_date"
			if dwo.name = "payment_curr" then
				ls_payment_curr = data
				
				ldate_exrate_date = this.getitemdate(row, "exrate_date")
				if isnull(ldate_exrate_date) then
					ldate_exrate_date = today()
				end if
			else //dwo.name = "exrate_date"
				ldate_exrate_date = date(data)
				if isnull(ldate_exrate_date) then return 0
				
				ls_payment_curr = this.getitemstring(row, "payment_curr")
			end if
			
			if isnull(ls_payment_curr) or len(trim(ls_payment_curr)) = 0 then return 0
			
			ld_exrate = wf_get_rst_exrate(ls_payment_curr, ldate_exrate_date)
			if ld_exrate > 0 then
				//
			else
				setnull(ld_exrate)
				setnull(ldate_exrate_date)
			end if
			
			this.setitem(row, "exrate_invoice", ld_exrate)
			this.setitem(row, "exrate_date", ldate_exrate_date)
			
		case "exrate_invoice"
			setnull(ldate_exrate_date)
			this.setitem(row, "exrate_date", ldate_exrate_date)
			
	end choose
end if

post wf_disable_print()

return 0
end event

