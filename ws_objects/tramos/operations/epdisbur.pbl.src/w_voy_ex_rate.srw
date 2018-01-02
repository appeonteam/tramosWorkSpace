$PBExportHeader$w_voy_ex_rate.srw
$PBExportComments$For Global Agent Import file
forward
global type w_voy_ex_rate from mt_w_response
end type
type st_4 from statictext within w_voy_ex_rate
end type
type st_2 from statictext within w_voy_ex_rate
end type
type st_1 from statictext within w_voy_ex_rate
end type
type em_rate from editmask within w_voy_ex_rate
end type
type cb_2 from commandbutton within w_voy_ex_rate
end type
type cb_1 from commandbutton within w_voy_ex_rate
end type
type st_disb_1 from statictext within w_voy_ex_rate
end type
type st_3 from statictext within w_voy_ex_rate
end type
end forward

global type w_voy_ex_rate from mt_w_response
integer x = 672
integer y = 264
integer width = 1271
integer height = 1016
string title = "Voyage Exchange Rate"
boolean controlmenu = false
long backcolor = 81324524
st_4 st_4
st_2 st_2
st_1 st_1
em_rate em_rate
cb_2 cb_2
cb_1 cb_1
st_disb_1 st_disb_1
st_3 st_3
end type
global w_voy_ex_rate w_voy_ex_rate

type variables
s_disbursement lstr_disb
end variables

on w_voy_ex_rate.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.em_rate=create em_rate
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_disb_1=create st_disb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_rate
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_disb_1
this.Control[iCurrent+8]=this.st_3
end on

on w_voy_ex_rate.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_rate)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_disb_1)
destroy(this.st_3)
end on

type st_4 from statictext within w_voy_ex_rate
integer x = 123
integer y = 276
integer width = 992
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Use ~"Batch~" invoice date, ex rate."
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_voy_ex_rate
integer x = 46
integer y = 524
integer width = 1179
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "transactions in this import file (~"Batch~")."
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_voy_ex_rate
integer x = 123
integer y = 432
integer width = 997
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "This voyage ex rate will cover all "
alignment alignment = right!
boolean focusrectangle = false
end type

type em_rate from editmask within w_voy_ex_rate
integer x = 421
integer y = 632
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

type cb_2 from commandbutton within w_voy_ex_rate
integer x = 722
integer y = 780
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

event clicked;
// IF the user does not enter voyage ex rate the hole import process/file is cleared !!!!! 

IF MessageBox("W A R N I N G","If you cancel input of voyage exchange rate, the import of transactions " &
										+ "is cleared !!! Are you sure you want to Cancel ?",Exclamation!,YesNo!) = 1 THEN 
	Close(parent)
ELSE
	Return
END IF

end event

type cb_1 from commandbutton within w_voy_ex_rate
integer x = 247
integer y = 776
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

IF NOT(100 < ld_rate AND ld_rate < 1000) THEN
	MessageBox("Error","Value is not valid. Must be 100 < voyage ex rate < 999.")
	em_rate.SetFocus()
	Return
END IF

CloseWithReturn(parent,ld_rate)

end event

type st_disb_1 from statictext within w_voy_ex_rate
integer x = 187
integer y = 120
integer width = 768
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "rate (USD to DKK) in 100~'s."
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_voy_ex_rate
integer x = 101
integer y = 32
integer width = 1038
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Please enter the voyage exchange"
boolean focusrectangle = false
end type

