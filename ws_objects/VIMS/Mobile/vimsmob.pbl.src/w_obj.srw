$PBExportHeader$w_obj.srw
forward
global type w_obj from window
end type
type cb_close from commandbutton within w_obj
end type
type dw_obj from datawindow within w_obj
end type
type gb_1 from groupbox within w_obj
end type
end forward

global type w_obj from window
integer width = 2455
integer height = 1556
boolean titlebar = true
string title = "Inspection Model Details"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
dw_obj dw_obj
gb_1 gb_1
end type
global w_obj w_obj

on w_obj.create
this.cb_close=create cb_close
this.dw_obj=create dw_obj
this.gb_1=create gb_1
this.Control[]={this.cb_close,&
this.dw_obj,&
this.gb_1}
end on

on w_obj.destroy
destroy(this.cb_close)
destroy(this.dw_obj)
destroy(this.gb_1)
end on

event open;
f_Write2Log("w_Obj Open")

dw_obj.SetTransObject(SQLCA)
dw_obj.Retrieve(g_Obj.Paramlong)
end event

type cb_close from commandbutton within w_obj
integer x = 951
integer y = 1328
integer width = 494
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
f_Write2Log("w_Obj Close")
Close(Parent)
end event

type dw_obj from datawindow within w_obj
integer x = 91
integer y = 128
integer width = 2304
integer height = 1152
integer taborder = 10
string title = "none"
string dataobject = "d_sq_ff_obj"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_obj
integer x = 18
integer y = 16
integer width = 2395
integer height = 1280
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Model Object Details"
end type

