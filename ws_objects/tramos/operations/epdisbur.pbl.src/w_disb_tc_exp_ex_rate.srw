$PBExportHeader$w_disb_tc_exp_ex_rate.srw
$PBExportComments$This window lets the user enter the exchange rate from disbursements to TC-Hire if there is one.
forward
global type w_disb_tc_exp_ex_rate from mt_w_response
end type
type em_rate from editmask within w_disb_tc_exp_ex_rate
end type
type st_7 from statictext within w_disb_tc_exp_ex_rate
end type
type st_5 from statictext within w_disb_tc_exp_ex_rate
end type
type cb_2 from commandbutton within w_disb_tc_exp_ex_rate
end type
type cb_1 from commandbutton within w_disb_tc_exp_ex_rate
end type
type st_tc_1 from statictext within w_disb_tc_exp_ex_rate
end type
type st_disb_1 from statictext within w_disb_tc_exp_ex_rate
end type
type st_tc from statictext within w_disb_tc_exp_ex_rate
end type
type st_disb from statictext within w_disb_tc_exp_ex_rate
end type
type st_4 from statictext within w_disb_tc_exp_ex_rate
end type
type st_3 from statictext within w_disb_tc_exp_ex_rate
end type
type st_2 from statictext within w_disb_tc_exp_ex_rate
end type
type st_1 from statictext within w_disb_tc_exp_ex_rate
end type
end forward

global type w_disb_tc_exp_ex_rate from mt_w_response
integer x = 672
integer y = 264
integer width = 1111
integer height = 776
string title = "Exchange Rate"
boolean controlmenu = false
long backcolor = 81324524
em_rate em_rate
st_7 st_7
st_5 st_5
cb_2 cb_2
cb_1 cb_1
st_tc_1 st_tc_1
st_disb_1 st_disb_1
st_tc st_tc
st_disb st_disb
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_disb_tc_exp_ex_rate w_disb_tc_exp_ex_rate

type variables
s_disbursement lstr_disb
end variables

event open;lstr_disb = Message.PowerObjectParm

Move(200,200)
st_disb.text = lstr_disb.expense_currency
st_tc.text = lstr_disb.tc_currency
st_disb_1.text = lstr_disb.expense_currency
st_tc_1.text = lstr_disb.tc_currency

end event

on w_disb_tc_exp_ex_rate.create
int iCurrent
call super::create
this.em_rate=create em_rate
this.st_7=create st_7
this.st_5=create st_5
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_tc_1=create st_tc_1
this.st_disb_1=create st_disb_1
this.st_tc=create st_tc
this.st_disb=create st_disb
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_rate
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_tc_1
this.Control[iCurrent+7]=this.st_disb_1
this.Control[iCurrent+8]=this.st_tc
this.Control[iCurrent+9]=this.st_disb
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_1
end on

on w_disb_tc_exp_ex_rate.destroy
call super::destroy
destroy(this.em_rate)
destroy(this.st_7)
destroy(this.st_5)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_tc_1)
destroy(this.st_disb_1)
destroy(this.st_tc)
destroy(this.st_disb)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

type em_rate from editmask within w_disb_tc_exp_ex_rate
integer x = 347
integer y = 432
integer width = 375
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.00"
end type

type st_7 from statictext within w_disb_tc_exp_ex_rate
integer x = 969
integer y = 160
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "."
boolean focusrectangle = false
end type

type st_5 from statictext within w_disb_tc_exp_ex_rate
integer x = 640
integer y = 352
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "in 100~'s."
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_disb_tc_exp_ex_rate
integer x = 603
integer y = 544
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;CloseWithReturn(w_disb_tc_exp_ex_rate,0)
Return
end event

type cb_1 from commandbutton within w_disb_tc_exp_ex_rate
integer x = 256
integer y = 544
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;Double ld_rate

ld_rate = double(em_rate.text)

IF isnull(ld_rate) or (ld_rate = 0) THEN
	MessageBox("Error","Value is not valid")
	em_rate.SetFocus()
	Return
END IF
CloseWithReturn(w_disb_tc_exp_ex_rate,ld_rate)
Return
end event

type st_tc_1 from statictext within w_disb_tc_exp_ex_rate
integer x = 457
integer y = 352
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type st_disb_1 from statictext within w_disb_tc_exp_ex_rate
integer x = 110
integer y = 352
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_tc from statictext within w_disb_tc_exp_ex_rate
integer x = 823
integer y = 160
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type st_disb from statictext within w_disb_tc_exp_ex_rate
integer x = 823
integer y = 80
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type st_4 from statictext within w_disb_tc_exp_ex_rate
integer x = 384
integer y = 352
integer width = 128
integer height = 64
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "to"
boolean focusrectangle = false
end type

type st_3 from statictext within w_disb_tc_exp_ex_rate
integer x = 73
integer y = 256
integer width = 773
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Please enter the rate from"
boolean focusrectangle = false
end type

type st_2 from statictext within w_disb_tc_exp_ex_rate
integer x = 73
integer y = 160
integer width = 759
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "while TC Hire currency is"
boolean focusrectangle = false
end type

type st_1 from statictext within w_disb_tc_exp_ex_rate
integer x = 73
integer y = 80
integer width = 814
integer height = 64
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Disbursement currency is"
boolean focusrectangle = false
end type

