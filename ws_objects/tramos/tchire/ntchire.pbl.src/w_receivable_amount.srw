$PBExportHeader$w_receivable_amount.srw
$PBExportComments$Receive Hire. Window for choosing how a payment should be settled.
forward
global type w_receivable_amount from mt_w_response
end type
type cb_post from commandbutton within w_receivable_amount
end type
type cb_transfer from commandbutton within w_receivable_amount
end type
type dw_date from datawindow within w_receivable_amount
end type
type st_3 from statictext within w_receivable_amount
end type
type cb_cancel from commandbutton within w_receivable_amount
end type
type st_2 from statictext within w_receivable_amount
end type
type cb_ok from commandbutton within w_receivable_amount
end type
type st_pay_amount from statictext within w_receivable_amount
end type
type st_1 from statictext within w_receivable_amount
end type
type sle_receive_amount from singlelineedit within w_receivable_amount
end type
end forward

global type w_receivable_amount from mt_w_response
integer width = 1545
integer height = 396
string title = "Settle Receivable"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
cb_post cb_post
cb_transfer cb_transfer
dw_date dw_date
st_3 st_3
cb_cancel cb_cancel
st_2 st_2
cb_ok cb_ok
st_pay_amount st_pay_amount
st_1 st_1
sle_receive_amount sle_receive_amount
end type
global w_receivable_amount w_receivable_amount

type variables
s_settle_payment	istr_parm
integer				ii_close_window
end variables

forward prototypes
private function integer wf_validatereceivedate ()
public subroutine documentation ()
end prototypes

private function integer wf_validatereceivedate ();datetime ldt_dueDate
integer li_response, li_daysBetween

istr_parm.receive_date = datetime(dw_date.getItemDate(1, "date_value"))

if isNull(istr_parm.receive_date) then
	Messagebox("Datetime warning", "Receive Date is not valid. Please re-enter.")
	dw_date.POST setfocus()
	Return -1
end if

SELECT NTC_PAYMENT.EST_DUE_DATE  
	INTO :ldt_dueDate  
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID = : istr_parm.payment_id ;
if sqlca.sqlcode <> 0 then
	MessageBox("Select Error", "Error selecting estimated due date from database. (wf_validateReceiveDate())")
	return -1
end if

li_daysBetween = abs(f_timedifference(ldt_dueDate, istr_parm.receive_date)/1440)

if li_daysBetween >= 30 then
	open(w_receivable_warming_message)
end if

if li_daysBetween >= 5 then
	li_response = Messagebox("Datetime warning", "Datetime received differs from estimated due date with more than 5 days - do you want to proceed ?",&
						Exclamation!, YesNo!, 1)
	if li_response = 1 then
		Return 1
	else
		dw_date.POST setfocus()
		Return -1
	end if
end if

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_receivable_amount
	
	<OBJECT>	</OBJECT>
   	<DESC>
	
	</DESC>
   	<USAGE>

	</USAGE>
   	<ALSO>

	</ALSO>
    	Date   		Ref    	Author   		Comments
  00/00/00 		??? 		      		      First Version
  02/02/12		M5-4	      JMC112		   GUI Changes
  01/04/15     CR2897      KSH092         Remove Transfer button
********************************************************************/
end subroutine

on w_receivable_amount.create
int iCurrent
call super::create
this.cb_post=create cb_post
this.cb_transfer=create cb_transfer
this.dw_date=create dw_date
this.st_3=create st_3
this.cb_cancel=create cb_cancel
this.st_2=create st_2
this.cb_ok=create cb_ok
this.st_pay_amount=create st_pay_amount
this.st_1=create st_1
this.sle_receive_amount=create sle_receive_amount
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_post
this.Control[iCurrent+2]=this.cb_transfer
this.Control[iCurrent+3]=this.dw_date
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.st_pay_amount
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_receive_amount
end on

on w_receivable_amount.destroy
call super::destroy
destroy(this.cb_post)
destroy(this.cb_transfer)
destroy(this.dw_date)
destroy(this.st_3)
destroy(this.cb_cancel)
destroy(this.st_2)
destroy(this.cb_ok)
destroy(this.st_pay_amount)
destroy(this.st_1)
destroy(this.sle_receive_amount)
end on

event open;call super::open;long			ll_min_payment, ll_last_paymentID
integer		li_status, li_income, li_no_of_payments, li_no_of_received

istr_parm = message.powerObjectParm

ii_close_window = -1   /* this to control close of window by alt+f4 */
st_pay_amount.text = string(istr_parm.settle_amount, "#,##0.00")
sle_receive_amount.text = string(istr_parm.receive_amount, "#,##0.00")
dw_date.insertRow(0)
dw_date.setItem(1, "date_value", istr_parm.receive_date)

SELECT MAX(PAYMENT_ID) 
INTO :ll_last_paymentID
FROM NTC_PAYMENT 
WHERE CONTRACT_ID = ( SELECT CONTRACT_ID FROM NTC_PAYMENT 
								WHERE PAYMENT_ID = :istr_parm.payment_id) ;  
if isnull(ll_last_paymentID) then 
	MessageBox("Error", "No payment found!")
	cb_ok.enabled = false
	cb_transfer.enabled = false
	ii_close_window = 1   /* this to control close of window by alt+f4 */
	return
end if

/* If payment = last payment for Contract no transfer allowed - nothing to transfer to */
if istr_parm.payment_id = ll_last_paymentID then
	cb_transfer.enabled = false
end if

SELECT count(*)  
	INTO :li_no_of_received  
	FROM NTC_PAYMENT_SETTLED_AMOUNT  
	WHERE NTC_PAYMENT_SETTLED_AMOUNT.PAYMENT_ID = :istr_parm.payment_id   ;

/* If no amounts received not able to post and transfer */
if li_no_of_received < 1 then 
	cb_post.enabled = false 
	cb_transfer.enabled = false
end if

/* If settle amount < 0 
	and payment overdue 
	and not last payment - then transfer of balance to next statement is OK */
if istr_parm.settle_amount < 0 and date(istr_parm.duedate) <= today() and istr_parm.payment_id <> ll_last_paymentID then
	cb_transfer.enabled = true
end if

sle_receive_amount.Post setFocus()

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_receivable_amount
end type

type cb_post from commandbutton within w_receivable_amount
integer x = 832
integer y = 204
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Post"
end type

event clicked;integer li_rc

li_rc = MessageBox("Settle amount", "Generate CODA transactions and set payment status to~r~n 'Part-paid' (balance <> 0) or 'Paid' (balance = 0)",Question!, YesNo!,2)

if li_rc = 1  then 
	istr_parm.transfer = false
	istr_parm.partpaid = false
	istr_parm.postCODA = true
	//istr_parm.receive_date = datetime(dw_date.getItemDate(1, "date_value"))
	if wf_validateReceiveDate() = -1 then return
	ii_close_window = 1  /* OK to close the window */
	istr_parm.li_settle = 1
	closewithreturn(parent, istr_parm)
else
	sle_receive_amount.POST setFocus()
	return
end if
end event

type cb_transfer from commandbutton within w_receivable_amount
boolean visible = false
integer x = 1591
integer y = 256
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transfer"
end type

event clicked;integer li_rc

istr_parm.receive_amount = dec(sle_receive_amount.text)
if istr_parm.receive_amount > istr_parm.settle_amount then
	MessageBox("Transfer Validation", "You can't transfer an amount greater than payment balance")
	sle_receive_amount.POST setFocus()
	return
end if

li_rc = MessageBox("Settle amount", "Transfer amount equal to: "+string(istr_parm.receive_amount,"#,##0.00"),Question!, YesNo!,2)

if li_rc = 1  then 
	istr_parm.transfer = true
	istr_parm.partpaid = false
	istr_parm.postCODA = false
	//istr_parm.receive_date = datetime(dw_date.getItemDate(1, "date_value"))
	if wf_validateReceiveDate() = -1 then return
	ii_close_window = 1  /* OK to close the window */
	istr_parm.li_settle = 1 
	closewithreturn(parent, istr_parm)
else
	sle_receive_amount.POST setFocus()
	return
end if

end event

type dw_date from datawindow within w_receivable_amount
integer x = 1211
integer y = 112
integer width = 306
integer height = 72
integer taborder = 20
string title = "none"
string dataobject = "d_ex_ff_date"
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_receivable_amount
integer x = 878
integer y = 120
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Receive date"
alignment alignment = right!
boolean focusrectangle = false
boolean disabledlook = true
end type

type cb_cancel from commandbutton within w_receivable_amount
integer x = 1179
integer y = 204
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
boolean default = true
end type

event clicked;setnull(istr_parm.settle_amount)
setnull(ii_close_window)
closewithreturn(parent, istr_parm)
end event

type st_2 from statictext within w_receivable_amount
integer y = 120
integer width = 498
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Please enter amount"
alignment alignment = right!
boolean focusrectangle = false
boolean disabledlook = true
end type

type cb_ok from commandbutton within w_receivable_amount
integer x = 485
integer y = 204
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;integer	li_rc
string	ls_message

dw_date.Accepttext()

istr_parm.receive_amount = dec(sle_receive_amount.text)
//istr_parm.receive_date = datetime(dw_date.getItemDate(1, "date_value"))
if wf_validateReceiveDate() = -1 then return

/* Some simple validations */
if isnull(istr_parm.receive_amount) then
	MessageBox("Validation Error", "A Part Payment can't be NULL. Please enter correct amount")
	sle_receive_amount.post setFocus()
	return
end if

/* If equal amounts always settle */
if istr_parm.receive_amount = istr_parm.settle_amount then
	ls_message = "Settle Payment equal to: "+string(istr_parm.receive_amount,"#,##0.00") +&
		  "~n~r~n~rReceive date equal to  : "+string(istr_parm.receive_date,"dd. mmm yyyy")
	istr_parm.transfer = false
	istr_parm.partpaid = false
	istr_parm.postCODA = false
	li_rc = MessageBox("Settle amount", ls_message,Question!, YesNo!,2)
//elseif istr_parm.receive_amount < istr_parm.settle_amount then
else
	ls_message = "Settle Part Payment equal to: "+string(istr_parm.receive_amount,"#,##0.00") +&
		  "~n~r~n~rReceive date equal to       : "+string(istr_parm.receive_date,"dd. mmm yyyy") +&
		  "~n~r~n~rIf Received Amount > Payment Balance Posting to CODA is generated" 
	istr_parm.transfer = false
	istr_parm.partpaid = true
	if istr_parm.receive_amount > istr_parm.settle_amount then
		istr_parm.postCODA = true
	else
		istr_parm.postCODA = false
	end if		
	li_rc = MessageBox("Settle amount", ls_message,Question!, YesNo!,2)
end if
	
if li_rc = 1 then
	/* settle amount */
	ii_close_window = 1  /* OK to close the window */
	istr_parm.li_settle = 1
	closewithreturn(parent, istr_parm)
else
	sle_receive_amount.post setFocus()
end if	

end event

type st_pay_amount from statictext within w_receivable_amount
integer x = 512
integer y = 32
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_receivable_amount
integer x = 23
integer y = 32
integer width = 475
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Payment amount"
alignment alignment = right!
boolean focusrectangle = false
boolean disabledlook = true
end type

type sle_receive_amount from singlelineedit within w_receivable_amount
integer x = 512
integer y = 112
integer width = 379
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 31775128
borderstyle borderstyle = stylelowered!
end type

