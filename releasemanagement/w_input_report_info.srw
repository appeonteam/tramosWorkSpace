HA$PBExportHeader$w_input_report_info.srw
forward
global type w_input_report_info from window
end type
type em_1 from editmask within w_input_report_info
end type
type cb_ok from commandbutton within w_input_report_info
end type
type st_3 from statictext within w_input_report_info
end type
type st_2 from statictext within w_input_report_info
end type
type st_1 from statictext within w_input_report_info
end type
type sle_1 from singlelineedit within w_input_report_info
end type
end forward

global type w_input_report_info from window
integer width = 1129
integer height = 568
boolean titlebar = true
string title = "Input Reprot Info"
windowtype windowtype = response!
string icon = "AppIcon!"
boolean center = true
em_1 em_1
cb_ok cb_ok
st_3 st_3
st_2 st_2
st_1 st_1
sle_1 sle_1
end type
global w_input_report_info w_input_report_info

on w_input_report_info.create
this.em_1=create em_1
this.cb_ok=create cb_ok
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.Control[]={this.em_1,&
this.cb_ok,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_1}
end on

on w_input_report_info.destroy
destroy(this.em_1)
destroy(this.cb_ok)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
end on

event open;sle_1.text = message.stringparm
em_1.setfocus()
end event

type em_1 from editmask within w_input_report_info
integer x = 421
integer y = 128
integer width = 457
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 31775128
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

event getfocus;this.post selecttext(1, len(this.text))
end event

type cb_ok from commandbutton within w_input_report_info
integer x = 421
integer y = 352
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
end type

event clicked;string ls_parm

if long(em_1.text) > 0 then
	ls_parm = em_1.text
else
	messagebox("Error", "CR Number can not be null")
	em_1.setfocus()
	return
end if

if len(trim(sle_1.text)) > 0 then
	ls_parm += '||' + sle_1.text
else
	messagebox("Error", "Release Version can not be empty")
	sle_1.setfocus()
	return
end if

closewithreturn(parent, ls_parm)
end event

type st_3 from statictext within w_input_report_info
integer x = 37
integer y = 32
integer width = 1010
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "Please input CR Number and Release Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_input_report_info
integer x = 41
integer y = 236
integer width = 357
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "Release Version"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_input_report_info
integer x = 55
integer y = 140
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "CR Number"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_input_report_info
integer x = 421
integer y = 224
integer width = 457
integer height = 72
integer taborder = 20
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

event getfocus;this.post selecttext(1, len(this.text))
end event

