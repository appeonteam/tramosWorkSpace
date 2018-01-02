$PBExportHeader$w_tasknotify.srw
forward
global type w_tasknotify from window
end type
type cb_close from commandbutton within w_tasknotify
end type
type dw_old from datawindow within w_tasknotify
end type
type st_1 from statictext within w_tasknotify
end type
end forward

global type w_tasknotify from window
boolean visible = false
integer width = 3168
integer height = 1416
boolean titlebar = true
string title = "Pending Tasks"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
dw_old dw_old
st_1 st_1
end type
global w_tasknotify w_tasknotify

on w_tasknotify.create
this.cb_close=create cb_close
this.dw_old=create dw_old
this.st_1=create st_1
this.Control[]={this.cb_close,&
this.dw_old,&
this.st_1}
end on

on w_tasknotify.destroy
destroy(this.cb_close)
destroy(this.dw_old)
destroy(this.st_1)
end on

event open;
dw_Old.SetTransObject(SQLCA)
dw_Old.Retrieve( )

If Message.StringParm= "Auto" then
	If dw_Old.Rowcount( ) = 0 then Post Close(This) Else This.Visible = True
Else
	This.Visible=True
End If
end event

type cb_close from commandbutton within w_tasknotify
integer x = 1390
integer y = 1200
integer width = 402
integer height = 112
integer taborder = 20
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

type dw_old from datawindow within w_tasknotify
integer x = 37
integer y = 112
integer width = 3090
integer height = 1072
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_oldtasks"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_tasknotify
integer x = 37
integer y = 32
integer width = 2395
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The following tasks are more than 10 days in the past and are not marked as completed:"
boolean focusrectangle = false
end type

