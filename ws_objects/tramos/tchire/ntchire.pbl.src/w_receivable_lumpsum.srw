$PBExportHeader$w_receivable_lumpsum.srw
$PBExportComments$Receive Lumpsum Hire on first tatement. Window for choosing how a payment should be settled.
forward
global type w_receivable_lumpsum from mt_w_response
end type
type dw_date from datawindow within w_receivable_lumpsum
end type
type st_3 from statictext within w_receivable_lumpsum
end type
type cb_cancel from commandbutton within w_receivable_lumpsum
end type
type sle_receive_amount from singlelineedit within w_receivable_lumpsum
end type
type st_2 from statictext within w_receivable_lumpsum
end type
type cb_settle from commandbutton within w_receivable_lumpsum
end type
type st_pay_amount from statictext within w_receivable_lumpsum
end type
type st_1 from statictext within w_receivable_lumpsum
end type
end forward

global type w_receivable_lumpsum from mt_w_response
integer width = 978
integer height = 548
string title = "Settle Receivable..."
long backcolor = 32304364
dw_date dw_date
st_3 st_3
cb_cancel cb_cancel
sle_receive_amount sle_receive_amount
st_2 st_2
cb_settle cb_settle
st_pay_amount st_pay_amount
st_1 st_1
end type
global w_receivable_lumpsum w_receivable_lumpsum

type variables
s_settle_payment	istr_parm
integer				ii_close_window
end variables

forward prototypes
private function integer wf_validatereceivedate ()
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

on w_receivable_lumpsum.create
int iCurrent
call super::create
this.dw_date=create dw_date
this.st_3=create st_3
this.cb_cancel=create cb_cancel
this.sle_receive_amount=create sle_receive_amount
this.st_2=create st_2
this.cb_settle=create cb_settle
this.st_pay_amount=create st_pay_amount
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.sle_receive_amount
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_settle
this.Control[iCurrent+7]=this.st_pay_amount
this.Control[iCurrent+8]=this.st_1
end on

on w_receivable_lumpsum.destroy
call super::destroy
destroy(this.dw_date)
destroy(this.st_3)
destroy(this.cb_cancel)
destroy(this.sle_receive_amount)
destroy(this.st_2)
destroy(this.cb_settle)
destroy(this.st_pay_amount)
destroy(this.st_1)
end on

event open;long			ll_min_payment, ll_last_paymentID
integer		li_status, li_income, li_no_of_payments, li_no_of_received

istr_parm = message.powerObjectParm

//f_center_window(this)
this.move(w_tramos_main.x +1000, w_tramos_main.y +1000)

ii_close_window = -1   /* this to control close of window by alt+f4 */
st_pay_amount.text = string(istr_parm.settle_amount, "#,##0.00")
sle_receive_amount.text = string(istr_parm.receive_amount, "#,##0.00")
dw_date.insertRow(0)
dw_date.setItem(1, "date_value", istr_parm.receive_date)

sle_receive_amount.Post setFocus()






end event

event closequery;if ii_close_window = -1 then
	return 1
else 
	return 0
end if
end event

type dw_date from datawindow within w_receivable_lumpsum
integer x = 530
integer y = 212
integer width = 421
integer height = 80
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_receivable_lumpsum
integer x = 37
integer y = 224
integer width = 384
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
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_receivable_lumpsum
integer x = 608
integer y = 348
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
setnull(istr_parm.receive_amount)
setnull(ii_close_window)
closewithreturn(parent, istr_parm)
end event

type sle_receive_amount from singlelineedit within w_receivable_lumpsum
integer x = 530
integer y = 120
integer width = 421
integer height = 68
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 31775128
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_receivable_lumpsum
integer x = 37
integer y = 128
integer width = 494
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
boolean focusrectangle = false
end type

type cb_settle from commandbutton within w_receivable_lumpsum
integer x = 256
integer y = 348
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Con&firm"
end type

event clicked;integer	li_rc
string	ls_message

dw_date.Accepttext()

istr_parm.receive_amount = dec(sle_receive_amount.text)

if istr_parm.receive_amount = 0 or isnull(istr_parm.receive_amount) or istr_parm.receive_amount < 0 then
	MessageBox("Validation Error", "A Lumpsum Receivable can't be NULL. Please enter correct amount")
	sle_receive_amount.post setFocus()
	return
end if

if wf_validateReceiveDate() = -1 then return


ls_message = "Settle Receivable equal to  : "+string(istr_parm.receive_amount,"#,##0.00") +&
	  "~n~r~n~rReceive date equal to       : "+string(istr_parm.receive_date,"dd. mmm yyyy") 
li_rc = MessageBox("Settle amount", ls_message,Question!, YesNo!,2)
	
if li_rc = 1 then
	/* settle amount */
	ii_close_window = 1  /* OK to close the window */
	closewithreturn(parent, istr_parm)
else
	sle_receive_amount.post setFocus()
end if	


end event

type st_pay_amount from statictext within w_receivable_lumpsum
integer x = 530
integer y = 32
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 700
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

type st_1 from statictext within w_receivable_lumpsum
integer x = 37
integer y = 32
integer width = 421
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
boolean focusrectangle = false
end type

