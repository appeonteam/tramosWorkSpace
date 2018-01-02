$PBExportHeader$w_hire_statement.srw
$PBExportComments$Window for showing Hire Statement
forward
global type w_hire_statement from mt_w_main
end type
type st_information from mt_u_statictext within w_hire_statement
end type
type cb_printer from commandbutton within w_hire_statement
end type
type cb_modify from commandbutton within w_hire_statement
end type
type cb_print from commandbutton within w_hire_statement
end type
type dw_statement from datawindow within w_hire_statement
end type
end forward

global type w_hire_statement from mt_w_main
integer width = 3744
integer height = 2568
string title = "Hire Statement"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
event ue_refresh ( )
st_information st_information
cb_printer cb_printer
cb_modify cb_modify
cb_print cb_print
dw_statement dw_statement
end type
global w_hire_statement w_hire_statement

type variables
long 		il_payment_id_low
long 		il_contract_id
long		il_payment_id, il_changed = 0

s_h_statement	istr_h_statement

/*il_changed is used to register if the payment changes status to Final. If this is the case,
the payment window needs to be updated on close in order to show the new status*/
end variables

forward prototypes
private subroutine wf_calculatebalance ()
public function long wf_getcontractid ()
public subroutine documentation ()
end prototypes

event ue_refresh();/* Refresh hire statement */
dw_statement.retrieve(il_payment_id, il_payment_id_low, il_contract_id)
post wf_calculatebalance( )
end event

private subroutine wf_calculatebalance ();/*
Calculates the Sub Total and Total for the Hire Statement.
Gets the values from the different datawindows in the Hire Statement and sums up to get the 
sub total for Charterer and Owner in order to calculate, who owns money to who...
*/

double				ld_hire, ld_offhire_debit, ld_offhire_kredit, ld_offhire_time_debit, ld_offhire_time_kredit
double				ld_total_debit, ld_total_kredit,ld_period_kredit,ld_period_debit
double 				ld_days, ld_off_days
datawindowchild 	ldwc_working, ldwc_bunker_del, ldwc_bunker_red
datawindowchild	ldwc_port_exp, /*ldwc_non_port_exp,*/ ldwc_est_oc_exp
datawindowchild	ldwc_contract_exp, ldwc_contract_exp_offservice, ldwc_contract, ldwc_history
datawindowchild	ldwc_transfer
long 					ll_hire_rows, ll_row, ll_count

/* set pointer */
setPointer(HourGlass!)

dw_statement.getChild("dw_contract_exp", ldwc_contract_exp)
dw_statement.getChild("dw_contract_exp_offservice", ldwc_contract_exp_offservice)
dw_statement.getChild("dw_bunker_delivery", ldwc_bunker_del)
dw_statement.getChild("dw_bunker_redelivery", ldwc_bunker_red)
dw_statement.getChild("dw_port_exp", ldwc_port_exp)
//dw_statement.getChild("dw_non_port_exp", ldwc_non_port_exp)     not possible to access after nested report
dw_statement.getChild("dw_est_oc_exp", ldwc_est_oc_exp)
dw_statement.getChild("dw_history", ldwc_history)
dw_statement.getChild("dw_transfer", ldwc_transfer)

/*Get sum values from the datawindowchilds to get total amount for Owner and Charterer.
If the datawindows are empty, assign 0 as the value for that datawindow*/

ld_total_debit = 0
ld_total_kredit = 0



// Get values from Hire section

ld_period_debit = double(dw_statement.object.dw_hire_master.object.dw_hire.object.total_period_debit.primary[1])
ld_period_kredit = double(dw_statement.object.dw_hire_master.object.dw_hire.object.total_period_kredit.primary[1])
ld_offhire_debit = double(dw_statement.object.dw_hire_master.object.dw_offhire.object.total_offservice_debit.primary[1])
ld_offhire_kredit = double(dw_statement.object.dw_hire_master.object.dw_offhire.object.total_offservice_kredit.primary[1])

ld_total_debit 	+= ld_period_debit + ld_offhire_debit
ld_total_kredit 	+= ld_period_kredit + ld_offhire_kredit

// Get values from Contract expenses section
IF ldwc_contract_exp.rowcount() > 0 THEN
	ld_total_debit 	+= ldwc_contract_exp.getitemdecimal(1, "total_exp_debit")
	ld_total_kredit 	+= ldwc_contract_exp.getitemdecimal(1, "total_exp_kredit")
END IF

// Get values from Contract expenses - Corrections due to Off Service section
IF ldwc_contract_exp_offservice.rowcount() > 0 THEN
	ld_total_debit 	+= ldwc_contract_exp_offservice.getitemdecimal(1, "total_exp_debit")
	ld_total_kredit 	+= ldwc_contract_exp_offservice.getitemdecimal(1, "total_exp_kredit")
END IF

// Get values from Bunker section
IF ldwc_bunker_del.rowcount() > 0 THEN
	ld_total_debit += ldwc_bunker_del.getitemdecimal(1, "sum_bunker_delivery")
END IF
IF ldwc_bunker_red.rowcount() > 0 THEN
	ld_total_kredit += ldwc_bunker_red.getitemdecimal(1, "sum_bunker_redelivery")
END IF

// Get values from Port expenses section
IF ldwc_port_exp.rowcount() > 0 THEN
	ld_total_debit  += ldwc_port_exp.getitemdecimal(1, "total_exp_debit")
	ld_total_kredit += ldwc_port_exp.getitemdecimal(1, "total_exp_kredit")
END IF

// Get values from non-Port expenses section
//IF ldwc_non_port_exp.rowcount() > 0 THEN
//	ld_total_debit += ldwc_non_port_exp.getitemdecimal(1, "total_exp_debit")
//	ld_total_kredit += ldwc_non_port_exp.getitemdecimal(1, "total_exp_kredit")
//END IF

SELECT COUNT(*)
	INTO :ll_count
	FROM NTC_NON_PORT_EXP, NTC_PAYMENT, NTC_TC_CONTRACT
   	WHERE NTC_NON_PORT_EXP.PAYMENT_ID = NTC_PAYMENT.PAYMENT_ID
	AND NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
	AND (( NTC_NON_PORT_EXP.PAYMENT_ID = :il_payment_id )
      OR ( NTC_PAYMENT.CONTRACT_ID = :il_contract_id 
		AND NTC_NON_PORT_EXP.PAYMENT_ID >= :il_payment_id_low 
		AND NTC_NON_PORT_EXP.PAYMENT_ID <= :il_payment_id )) ;
COMMIT;	

if ll_count > 0 then
	ld_total_debit += double(dw_statement.Object.dw_non_port_exp.object.total_exp_debit[1])
	ld_total_kredit += double(dw_statement.Object.dw_non_port_exp.object.total_exp_kredit[1])
END IF	

// Get values from Estimated Owner/Charterer expenses section
IF ldwc_est_oc_exp.rowcount() > 0 THEN
	ld_total_debit += ldwc_est_oc_exp.getitemdecimal(1, "total_exp_debit")
	ld_total_kredit += ldwc_est_oc_exp.getitemdecimal(1, "total_exp_kredit")
END IF

// Get values from Paid section
IF ldwc_history.rowcount() > 0 THEN
	ld_total_kredit += ldwc_history.getitemdecimal(1, "history_kredit")
END IF

// Transfers
IF ldwc_transfer.rowcount() > 0 THEN
	if ldwc_transfer.getitemdecimal(1, "transfer_from_previous") = 0 and &
	   ldwc_transfer.getitemdecimal(1, "transfer_to_next") = 0 then
			/* No transfer amounts - ignore section in report */
			ldwc_transfer.deleteRow(1)
	else
			ld_total_debit += ldwc_transfer.getitemdecimal(1, "transfer_from_previous")
			ld_total_kredit += ldwc_transfer.getitemdecimal(1, "transfer_to_next")
	end if
END IF

/* Make change to totals. */
dw_statement.getChild("dw_totals", ldwc_working)
ldwc_working.insertRow(0)

dw_statement.Object.dw_totals.object.debit.Text=string(ld_total_debit,"#,##0.00")
dw_statement.object.dw_totals.object.kredit.text=string(ld_total_kredit, "#,##0.00")
dw_statement.object.dw_totals.object.currency.text= ldwc_contract.getitemstring(1,"ntc_tc_contract_curr_code")

IF ld_total_debit > ld_total_kredit THEN
	dw_statement.object.dw_totals.object.total_debit.text = string((ld_total_debit - ld_total_kredit), "#,##0.00")
ELSEIF ld_total_debit < ld_total_kredit THEN
	dw_statement.object.dw_totals.object.total_kredit.text = string((ld_total_kredit - ld_total_debit), "#,##0.00")
	
ELSE
	dw_statement.object.dw_totals.object.total_debit.text = "-"
	dw_statement.object.dw_totals.object.total_kredit.text = "-" 
END IF

/* set pointer */
setPointer(Arrow!)

end subroutine

public function long wf_getcontractid ();/* Returns the TC Contract ID related to the statement shown */
return il_contract_id
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_hire_statement
   <OBJECT> Print Hire statement	</OBJECT>
   <USAGE>	
	</USAGE>
   <ALSO>		</ALSO>
<HISTORY> 
   Date		CR-Ref	 Author	Comments
  	??/??/??							First Version
	27/04/11	CR2375	JMC		Vat_nr from profit center
	04/08/11 CR2485	LHC010  If tc contract currency is different than the bank acount currency,
										display warning information
	19/10/11 CR2485	AGL027	last minute amendments to release regarding exception.
	31/12/14 CR3829   KSH092   Modify broker comm/Address comm display
	08/10/16 CR2212   LHG008   Sanctions restrictions
</HISTORY>    
********************************************************************/


end subroutine

event open;call super::open;integer			li_tc_hire_in, li_statictextheight=60
string 			ls_logo_text, ls_tccurrcode, ls_bankcurrcode, ls_user, ls_invoice_nr, ls_invoicetext
LONG		 		ll_pc_nr, ll_pcnr_template, ll_payment_status

this.move(0,0)

istr_h_statement	= Message.PowerObjectParm
il_payment_id 		= istr_h_statement.payment_id
il_contract_id		= istr_h_statement.contract_id
il_payment_id_low = istr_h_statement.payment_id_low
ll_pc_nr				= istr_h_statement.pc_nr

SELECT AX_INVOICE_TEXT
INTO :ls_invoicetext
FROM NTC_PAYMENT
WHERE PAYMENT_ID = :il_payment_id;

If uo_global.gs_paper_size = "A4" Then
	if il_payment_id_low <> il_payment_id then
		dw_statement.DataObject = "d_h_hire_statement_history_a4"
	else
		if isnull(ls_invoicetext) or trim(ls_invoicetext) = '' then
			dw_statement.DataObject = "d_h_hire_statement_notext_a4"
		else
			dw_statement.DataObject = "d_h_hire_statement_a4"
		end if
	end if
Else
	if il_payment_id_low <> il_payment_id then
		dw_statement.DataObject = "d_h_hire_statement_history_letter"
	else
		if isnull(ls_invoicetext) or trim(ls_invoicetext) = '' then
			dw_statement.DataObject = "d_h_hire_statement_notext_letter"
		else
			dw_statement.DataObject = "d_h_hire_statement_letter"	
		end if
	end if
	
End If

dw_statement.setTransObject(sqlca)
dw_statement.retrieve(il_payment_id, il_payment_id_low, il_contract_id)

/*Begin modified by LHC010 on 04-08-2011*/
/* find out which logo/company to use. */
SELECT NTC_TC_CONTRACT.TC_HIRE_IN, 
		 NTC_TC_CONTRACT.CURR_CODE,
		 BANK_ACCOUNTS.CURR_CODE,
		 NTC_TC_CONTRACT.PC_NR
  INTO :li_tc_hire_in, :ls_tccurrcode, :ls_bankcurrcode, :ll_pcnr_template
  FROM NTC_TC_CONTRACT 
		 LEFT OUTER JOIN BANK_ACCOUNTS ON NTC_TC_CONTRACT.BANK_ACCOUNT_ID = BANK_ACCOUNTS.BANK_ACCOUNT_ID, 
		 VESSELS
 WHERE NTC_TC_CONTRACT.VESSEL_NR = VESSELS.VESSEL_NR
	AND NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id ;
If sqlca.SQLCode <> 0 then
	MessageBox("Error", "There is a problem reading from database.")
	return
End If

istr_h_statement.s_tccurrcode = ls_tccurrcode

//M5-4 added by WWG004 on 04/01/2012. Change desc: get user's full name.
SELECT FIRST_NAME + ' ' + LAST_NAME INTO :ls_user 
FROM USERS WHERE USERID = :uo_global.is_userid;

if isnull(ll_pcnr_template) then ll_pcnr_template = ll_pc_nr

//Display warning information
if not isnull(ls_bankcurrcode) and ls_tccurrcode <> ls_bankcurrcode then
	st_information.text = 'TC contract currency (' + ls_tccurrcode + ') is different than the bank acount currency (' + ls_bankcurrcode + '), please correct in TC contract.'
	st_information.visible = true
end if
/*End modified by LHC010 on 04-08-2011*/

dw_statement.object.t_ref.text  = "Ref : " + ls_user
dw_statement.object.t_date.text = "Date: " + String(Today(), "dd-mm-yy")
if li_tc_hire_in = 0 then
	//M5-4 added by LGX001 on 04/01/2012. Change desc: get AX invoice no.
	SELECT INVOICE_NR, PAYMENT_STATUS INTO :ls_invoice_nr, :ll_payment_status
	FROM NTC_PAYMENT WHERE PAYMENT_ID = :istr_h_statement.payment_id;
	if isnull(ls_invoice_nr) then ls_invoice_nr = ""
	if ll_payment_status = 1 or ll_payment_status = 2 then
		dw_statement.object.t_title.text = "T/C HIRE STATEMENT, INVOICE NO. DRAFT"
	elseif ll_payment_status = 4 or ll_payment_status = 5 then
		dw_statement.object.t_title.text = "T/C HIRE STATEMENT, INVOICE NO. "+ ls_invoice_nr
	elseif ll_payment_status = 3 and trim(ls_invoice_nr) = "" then
		dw_statement.object.t_title.text = "T/C HIRE STATEMENT, INVOICE NO. DRAFT"
	else
		dw_statement.object.t_title.text = "T/C HIRE STATEMENT, INVOICE NO. "+ ls_invoice_nr
	end if	
end if


Post wf_calculatebalance( )
end event

on w_hire_statement.create
int iCurrent
call super::create
this.st_information=create st_information
this.cb_printer=create cb_printer
this.cb_modify=create cb_modify
this.cb_print=create cb_print
this.dw_statement=create dw_statement
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_information
this.Control[iCurrent+2]=this.cb_printer
this.Control[iCurrent+3]=this.cb_modify
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.dw_statement
end on

on w_hire_statement.destroy
call super::destroy
destroy(this.st_information)
destroy(this.cb_printer)
destroy(this.cb_modify)
destroy(this.cb_print)
destroy(this.dw_statement)
end on

event close;call super::close;/*If the payment has been changed to Final, the payment window will be updated to 
reflect the status change.
ib_changed = 0 : No change
ib_changed = 1 : Payment Status has been changed
*/
if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if
if isValid(w_tc_contract) then
	w_tc_contract.PostEvent("ue_refresh")
end if

close(this)
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_hire_statement
end type

type st_information from mt_u_statictext within w_hire_statement
boolean visible = false
integer x = 55
integer y = 2808
integer width = 3730
long textcolor = 255
string text = ""
end type

type cb_printer from commandbutton within w_hire_statement
integer x = 2683
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "P&rinter"
end type

event clicked;printSetup()
end event

type cb_modify from commandbutton within w_hire_statement
integer x = 3387
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Modify"
end type

event clicked;s_payment_expenses	lstr_payment_expenses

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

lstr_payment_expenses.payment_id = il_payment_id
lstr_payment_expenses.contract_id = il_contract_id
OpenWithParm(w_payment_expenses, lstr_payment_expenses)
dw_statement.retrieve(il_payment_id, il_payment_id_low, il_contract_id)
post wf_calculateBalance() /*Calculates sub total and total*/
dw_statement.post setFocus()
end event

type cb_print from commandbutton within w_hire_statement
integer x = 3035
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
boolean default = true
end type

event clicked;string	ls_fix_userid

/* Check if contract fixtured. If not return */
SELECT isnull(NTC_TC_CONTRACT.FIXTURE_USER_ID, "0")  
   INTO :ls_fix_userid  
   FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id;

if ls_fix_userid = "0" then
	MessageBox("Print Error", "You can't print a statement on a contract that is not fixtured!")
	return
end if

//M5-4 added by LGX001 on 04/01/2012.
openwithparm(w_print_tc, istr_h_statement)
end event

type dw_statement from datawindow within w_hire_statement
integer x = 18
integer y = 16
integer width = 3712
integer height = 2336
integer taborder = 10
string title = "none"
string dataobject = "d_h_hire_statement_a4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

