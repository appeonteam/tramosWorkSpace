$PBExportHeader$w_plan.srw
forward
global type w_plan from window
end type
type cb_close from commandbutton within w_plan
end type
type st_1 from statictext within w_plan
end type
end forward

global type w_plan from window
integer width = 2400
integer height = 1448
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
st_1 st_1
end type
global w_plan w_plan

on w_plan.create
this.cb_close=create cb_close
this.st_1=create st_1
this.Control[]={this.cb_close,&
this.st_1}
end on

on w_plan.destroy
destroy(this.cb_close)
destroy(this.st_1)
end on

type cb_close from commandbutton within w_plan
integer x = 933
integer y = 1104
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;

Close(Parent)


end event

type st_1 from statictext within w_plan
integer x = 18
integer y = 16
integer width = 805
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Planning Table:"
boolean focusrectangle = false
end type

