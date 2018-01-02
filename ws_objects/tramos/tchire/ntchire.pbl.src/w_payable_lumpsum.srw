$PBExportHeader$w_payable_lumpsum.srw
$PBExportComments$Pay/Receive Hire. Window for entering amount when paying/receiving lumpsum in advance
forward
global type w_payable_lumpsum from mt_w_response
end type
type cb_cancel from commandbutton within w_payable_lumpsum
end type
type sle_settle_amount from singlelineedit within w_payable_lumpsum
end type
type st_2 from statictext within w_payable_lumpsum
end type
type cb_settle from commandbutton within w_payable_lumpsum
end type
type st_pay_amount from statictext within w_payable_lumpsum
end type
type st_1 from statictext within w_payable_lumpsum
end type
end forward

global type w_payable_lumpsum from mt_w_response
integer width = 960
integer height = 452
string title = "Settle Payment..."
long backcolor = 32304364
cb_cancel cb_cancel
sle_settle_amount sle_settle_amount
st_2 st_2
cb_settle cb_settle
st_pay_amount st_pay_amount
st_1 st_1
end type
global w_payable_lumpsum w_payable_lumpsum

type variables
decimal		id_pay_amount, id_settle_amount
end variables

on w_payable_lumpsum.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.sle_settle_amount=create sle_settle_amount
this.st_2=create st_2
this.cb_settle=create cb_settle
this.st_pay_amount=create st_pay_amount
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.sle_settle_amount
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_settle
this.Control[iCurrent+5]=this.st_pay_amount
this.Control[iCurrent+6]=this.st_1
end on

on w_payable_lumpsum.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.sle_settle_amount)
destroy(this.st_2)
destroy(this.cb_settle)
destroy(this.st_pay_amount)
destroy(this.st_1)
end on

event open;id_pay_amount = message.doubleParm

//f_center_window(this)
this.move(w_tramos_main.x +1000, w_tramos_main.y +1000)

id_settle_amount = -1   /* this to control close of window by alt+f4 */
st_pay_amount.text = string(id_pay_amount, "#,##0.00")
sle_settle_amount.text = string(id_pay_amount, "#,##0.00")
sle_settle_amount.POST setFocus()



end event

event closequery;if id_settle_amount = -1 then
	return 1
else 
	return 0
end if
end event

type cb_cancel from commandbutton within w_payable_lumpsum
integer x = 585
integer y = 252
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean default = true
end type

event clicked;setnull(id_settle_amount)
closewithreturn(parent, id_settle_amount)
end event

type sle_settle_amount from singlelineedit within w_payable_lumpsum
integer x = 517
integer y = 124
integer width = 407
integer height = 68
integer taborder = 70
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

type st_2 from statictext within w_payable_lumpsum
integer x = 27
integer y = 132
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
boolean focusrectangle = false
end type

type cb_settle from commandbutton within w_payable_lumpsum
integer x = 224
integer y = 252
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Co&nfirm"
end type

event clicked;integer	li_rc

id_settle_amount = dec(sle_settle_amount.text)

if id_settle_amount = 0 or isnull(id_settle_amount) or id_settle_amount < 0 then
	MessageBox("Validation Error", "Please enter a valid amount")
	sle_settle_amount.post setFocus()
	return
end if

li_rc = MessageBox("Settle amount", "Settle amount equal to: "+string(id_settle_amount,"#,##0.00"),Question!, YesNo!,2)

if li_rc = 1 then
	/* settle amount */
	closewithreturn(parent, id_settle_amount)
end if
end event

type st_pay_amount from statictext within w_payable_lumpsum
integer x = 526
integer y = 40
integer width = 407
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

type st_1 from statictext within w_payable_lumpsum
integer x = 27
integer y = 40
integer width = 485
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Full payment amount"
boolean focusrectangle = false
end type

