$PBExportHeader$w_payable_partpaid.srw
$PBExportComments$Pay Hire. Window for choosing how a payment should be settled.
forward
global type w_payable_partpaid from mt_w_response
end type
type st_4 from statictext within w_payable_partpaid
end type
type st_3 from statictext within w_payable_partpaid
end type
type dw_date from datawindow within w_payable_partpaid
end type
type cb_transfer from commandbutton within w_payable_partpaid
end type
type cb_cancel from commandbutton within w_payable_partpaid
end type
type st_2 from statictext within w_payable_partpaid
end type
type cb_partpay from commandbutton within w_payable_partpaid
end type
type cb_yes from commandbutton within w_payable_partpaid
end type
type st_pay_amount from statictext within w_payable_partpaid
end type
type st_1 from statictext within w_payable_partpaid
end type
type sle_settle_amount from singlelineedit within w_payable_partpaid
end type
type cb_settle from commandbutton within w_payable_partpaid
end type
type cb_post from commandbutton within w_payable_partpaid
end type
end forward

global type w_payable_partpaid from mt_w_response
integer width = 1545
integer height = 528
string title = "Settle Payment"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
st_4 st_4
st_3 st_3
dw_date dw_date
cb_transfer cb_transfer
cb_cancel cb_cancel
st_2 st_2
cb_partpay cb_partpay
cb_yes cb_yes
st_pay_amount st_pay_amount
st_1 st_1
sle_settle_amount sle_settle_amount
cb_settle cb_settle
cb_post cb_post
end type
global w_payable_partpaid w_payable_partpaid

type variables
s_settle_payment	istr_parm

decimal				id_settle_amount
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
   ObjectName: w_payable_partpaid
	
	<OBJECT>	</OBJECT>
   	<DESC>
	
	</DESC>
   	<USAGE>

	</USAGE>
   	<ALSO>

	</ALSO>
    	Date   		Ref    	Author   		Comments
  00/00/00 		??? 		      		First Version
  02/02/12		M5-4	JMC112		GUI Changes
********************************************************************/
end subroutine

on w_payable_partpaid.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_3=create st_3
this.dw_date=create dw_date
this.cb_transfer=create cb_transfer
this.cb_cancel=create cb_cancel
this.st_2=create st_2
this.cb_partpay=create cb_partpay
this.cb_yes=create cb_yes
this.st_pay_amount=create st_pay_amount
this.st_1=create st_1
this.sle_settle_amount=create sle_settle_amount
this.cb_settle=create cb_settle
this.cb_post=create cb_post
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.dw_date
this.Control[iCurrent+4]=this.cb_transfer
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_partpay
this.Control[iCurrent+8]=this.cb_yes
this.Control[iCurrent+9]=this.st_pay_amount
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_settle_amount
this.Control[iCurrent+12]=this.cb_settle
this.Control[iCurrent+13]=this.cb_post
end on

on w_payable_partpaid.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_date)
destroy(this.cb_transfer)
destroy(this.cb_cancel)
destroy(this.st_2)
destroy(this.cb_partpay)
destroy(this.cb_yes)
destroy(this.st_pay_amount)
destroy(this.st_1)
destroy(this.sle_settle_amount)
destroy(this.cb_settle)
destroy(this.cb_post)
end on

event open;call super::open;long			ll_min_payment, ll_max_payment
integer		li_status, li_no_of_payments

istr_parm = message.powerObjectParm

//f_center_window(this)
this.move(w_tramos_main.x +1000, w_tramos_main.y +1000)

id_settle_amount = -1   /* this to control close of window by alt+f4 */
st_pay_amount.text = string(istr_parm.settle_amount, "#,##0.00")
sle_settle_amount.text = string(istr_parm.settle_amount, "#,##0.00")

/* Find out if this is the first payment, where transfer is possible */
SELECT MIN(PAYMENT_ID), MAX(PAYMENT_ID)
	INTO :ll_min_payment, :ll_max_payment
	FROM NTC_PAYMENT 
	WHERE CONTRACT_ID = ( SELECT CONTRACT_ID FROM NTC_PAYMENT 
									WHERE PAYMENT_ID = :istr_parm.payment_id) ;  

if isnull(ll_min_payment) or isnull(ll_max_payment) then 
	MessageBox("Error", "No payment found!")
	cb_yes.enabled = false
	cb_transfer.enabled = false
	cb_partpay.enabled = false
	id_settle_amount = 0   /* this to control close of window by alt+f4 */
	return
end if

SELECT NTC_PAYMENT.PAYMENT_STATUS  
	INTO :li_status  
	FROM NTC_PAYMENT  
	WHERE NTC_PAYMENT.PAYMENT_ID = :istr_parm.payment_id ;

SELECT COUNT(*) 
	INTO :li_no_of_payments
	FROM NTC_PAYMENT_SETTLED_AMOUNT
	WHERE PAYMENT_ID = :istr_parm.payment_id ;

if li_status < 5 and li_no_of_payments > 0 then
	cb_transfer.enabled = true
end if

if istr_parm.payment_id = ll_max_payment then
	cb_post.enabled = true
	cb_transfer.enabled = false
end if

/* If settle amount < 0 
	and payment overdue 
	and not last payment - then transfer of balance to next statement is OK */
if istr_parm.settle_amount < 0 and date(istr_parm.duedate) <= today() and istr_parm.payment_id <> ll_max_payment then
	cb_transfer.enabled = true
end if

dw_date.insertRow(0)
dw_date.setItem(1, "date_value", today())
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_payable_partpaid
end type

type st_4 from statictext within w_payable_partpaid
boolean visible = false
integer x = 37
integer y = 232
integer width = 1243
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "If Payment Amount < 0 (zero) then enter a receive date."
boolean focusrectangle = false
end type

type st_3 from statictext within w_payable_partpaid
boolean visible = false
integer x = 910
integer y = 132
integer width = 302
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

type dw_date from datawindow within w_payable_partpaid
boolean visible = false
integer x = 1207
integer y = 124
integer width = 306
integer height = 72
integer taborder = 70
string title = "none"
string dataobject = "d_ex_ff_date"
boolean border = false
boolean livescroll = true
end type

type cb_transfer from commandbutton within w_payable_partpaid
boolean visible = false
integer x = 1646
integer y = 144
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Transfer"
end type

event clicked;istr_parm.transfer = true

cb_yes.enabled = false
cb_partpay.enabled = false

cb_settle.event clicked()

end event

type cb_cancel from commandbutton within w_payable_partpaid
integer x = 1175
integer y = 332
integer width = 343
integer height = 100
integer taborder = 10
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
setnull(id_settle_amount)
closewithreturn(parent, istr_parm)
end event

type st_2 from statictext within w_payable_partpaid
boolean visible = false
integer x = 37
integer y = 132
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
string text = "Please enter amount"
boolean focusrectangle = false
end type

type cb_partpay from commandbutton within w_payable_partpaid
integer x = 480
integer y = 332
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Part-Pay"
end type

event clicked;//parent.height = 650

st_2.visible = true
st_3.visible = true
st_4.visible = true
sle_settle_amount.visible = true
dw_date.visible = true
cb_settle.visible = true
cb_post.visible = false
cb_partpay.enabled = false

sle_settle_amount.enabled = true
sle_settle_amount.post setfocus()
cb_yes.enabled = false
cb_transfer.enabled = false
cb_settle.enabled = true
cb_settle.default = true

istr_parm.partpaid = true
end event

type cb_yes from commandbutton within w_payable_partpaid
integer x = 133
integer y = 332
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Yes"
end type

event clicked;cb_settle.event clicked()
end event

type st_pay_amount from statictext within w_payable_partpaid
integer x = 859
integer y = 32
integer width = 402
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

type st_1 from statictext within w_payable_partpaid
integer x = 37
integer y = 32
integer width = 841
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Would you like to settle full payment"
boolean focusrectangle = false
end type

type sle_settle_amount from singlelineedit within w_payable_partpaid
boolean visible = false
integer x = 503
integer y = 124
integer width = 379
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 31775128
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_settle from commandbutton within w_payable_partpaid
boolean visible = false
integer x = 827
integer y = 332
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "S&ettle"
end type

event clicked;integer	li_rc
string	ls_message

/* if transfer return to nvo */
if istr_parm.transfer then closewithreturn(parent, istr_parm)

id_settle_amount = dec(sle_settle_amount.text)

//if id_settle_amount = 0 or isnull(id_settle_amount) then
if isnull(id_settle_amount) then
	MessageBox("Validation Error", "Please enter a valid amount")
	sle_settle_amount.post setFocus()
	return
end if

if id_settle_amount >=0 then    //positive values
	if id_settle_amount > istr_parm.settle_amount then
		MessageBox("Validation Error", "Part payment can't be greater that payment balance.")
		sle_settle_amount.post setFocus()
		return
	end if
else									  //negative values			
	if id_settle_amount < istr_parm.settle_amount then
		MessageBox("Validation Error", "Part payment can't be greater that payment balance.")
		sle_settle_amount.post setFocus()
		return
	end if
end if

//if id_settle_amount < 0 then 
	dw_date.accepttext()
	if wf_validateReceiveDate() = -1 then 
		istr_parm.transfer = false
		istr_parm.partpaid = false
		istr_parm.postcoda = false
		setNull(istr_parm.settle_amount)
		istr_parm.li_settle = 0
		closewithreturn(parent, istr_parm) 
		return
	end if
//end if

if istr_parm.transfer then
	ls_message = "Transfer amount equal to: "+string(id_settle_amount,"#,##0.00") 
else
	ls_message = "Settle amount equal to: "+string(id_settle_amount,"#,##0.00") 
end if

li_rc = MessageBox("Settle amount", ls_message,Question!, YesNo!,2)

if li_rc = 1 then
	/* settle amount */
	istr_parm.settle_amount = id_settle_amount
	istr_parm.li_settle = 1
	closewithreturn(parent, istr_parm)
else
	istr_parm.transfer = false
	istr_parm.partpaid = false
	istr_parm.postcoda = false
	setNull(istr_parm.settle_amount)
	istr_parm.li_settle = 0
	closewithreturn(parent, istr_parm) 
end if
end event

type cb_post from commandbutton within w_payable_partpaid
integer x = 827
integer y = 332
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "P&ost"
boolean default = true
end type

event clicked;istr_parm.postCODA = true
cb_settle.event clicked()

end event

