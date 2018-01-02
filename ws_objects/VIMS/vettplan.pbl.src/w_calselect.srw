$PBExportHeader$w_calselect.srw
forward
global type w_calselect from window
end type
type cb_ok from commandbutton within w_calselect
end type
type cb_cancel from commandbutton within w_calselect
end type
type st_1 from statictext within w_calselect
end type
type mc_cal from monthcalendar within w_calselect
end type
end forward

global type w_calselect from window
integer width = 2542
integer height = 2036
boolean titlebar = true
string title = "Calender Select"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
mc_cal mc_cal
end type
global w_calselect w_calselect

on w_calselect.create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.mc_cal=create mc_cal
this.Control[]={this.cb_ok,&
this.cb_cancel,&
this.st_1,&
this.mc_cal}
end on

on w_calselect.destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.mc_cal)
end on

event open;Date ld_From, ld_To


ld_From = Date(Left(g_Obj.ObjString, 10))
ld_To = Date(Right(g_Obj.ObjString, 10))

If ld_From > ld_To then ld_To = ld_From

mc_cal.SetSelectedRange( ld_From, ld_To)
end event

type cb_ok from commandbutton within w_calselect
integer x = 512
integer y = 1840
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;Date ld_From, ld_To

mc_cal.getselectedrange( ld_From, ld_To)

g_obj.ObjString = String(ld_From, "yyyy-mm-dd") + String(ld_To, "yyyy-mm-dd")

Close(Parent)
end event

type cb_cancel from commandbutton within w_calselect
integer x = 1573
integer y = 1840
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_obj.Objstring = ""

Close(Parent)

end event

type st_1 from statictext within w_calselect
integer x = 18
integer y = 16
integer width = 1371
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Drag and select the range of dates (max 90 days):"
boolean focusrectangle = false
end type

type mc_cal from monthcalendar within w_calselect
integer x = 18
integer y = 96
integer width = 2487
integer height = 1712
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long titletextcolor = 8388608
long trailingtextcolor = 134217745
long backcolor = 12639424
long monthbackcolor = 12639424
long titlebackcolor = 8421376
integer maxselectcount = 90
integer scrollrate = 1
boolean border = true
borderstyle borderstyle = stylelowered!
end type

