$PBExportHeader$w_dupvessel.srw
forward
global type w_dupvessel from window
end type
type cb_close from commandbutton within w_dupvessel
end type
type st_1 from statictext within w_dupvessel
end type
type dw_dupvsl from datawindow within w_dupvessel
end type
type gb_1 from groupbox within w_dupvessel
end type
end forward

global type w_dupvessel from window
integer width = 1737
integer height = 1540
boolean titlebar = true
string title = "Tramos Duplicate Vessels"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
st_1 st_1
dw_dupvsl dw_dupvsl
gb_1 gb_1
end type
global w_dupvessel w_dupvessel

on w_dupvessel.create
this.cb_close=create cb_close
this.st_1=create st_1
this.dw_dupvsl=create dw_dupvsl
this.gb_1=create gb_1
this.Control[]={this.cb_close,&
this.st_1,&
this.dw_dupvsl,&
this.gb_1}
end on

on w_dupvessel.destroy
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.dw_dupvsl)
destroy(this.gb_1)
end on

event open;
//messagebox("",dw_DupVsl.modify("Datawindow.Print.Preview='No'"))

dw_DupVsl.SetTransObject(SQLCA)

dw_DupVsl.Retrieve()
end event

type cb_close from commandbutton within w_dupvessel
integer x = 677
integer y = 1344
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
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

type st_1 from statictext within w_dupvessel
integer x = 73
integer y = 64
integer width = 1573
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This is a list of active vessels in Tramos sharing the same IMO number. Such vessels may cause errors in reports for VIMS Mobile."
boolean focusrectangle = false
end type

type dw_dupvsl from datawindow within w_dupvessel
integer x = 73
integer y = 192
integer width = 1573
integer height = 1088
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_dupvessels"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_dupvessel
integer x = 37
integer y = 32
integer width = 1646
integer height = 1280
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

