$PBExportHeader$w_hist.srw
forward
global type w_hist from window
end type
type cb_Print from commandbutton within w_hist
end type
type cb_close from commandbutton within w_hist
end type
type dw_hist from datawindow within w_hist
end type
end forward

global type w_hist from window
integer width = 3698
integer height = 2204
boolean titlebar = true
string title = "Inspection History"
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_Print cb_Print
cb_close cb_close
dw_hist dw_hist
end type
global w_hist w_hist

on w_hist.create
this.cb_Print=create cb_Print
this.cb_close=create cb_close
this.dw_hist=create dw_hist
this.Control[]={this.cb_Print,&
this.cb_close,&
this.dw_hist}
end on

on w_hist.destroy
destroy(this.cb_Print)
destroy(this.cb_close)
destroy(this.dw_hist)
end on

event open;
dw_hist.SetTransObject(SQLCA)

dw_hist.Retrieve( g_obj.inspid )
end event

type cb_Print from commandbutton within w_hist
integer x = 805
integer y = 2000
integer width = 677
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;

dw_Hist.Print(True, True)
end event

type cb_close from commandbutton within w_hist
integer x = 2194
integer y = 2000
integer width = 677
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type dw_hist from datawindow within w_hist
integer x = 37
integer y = 32
integer width = 3621
integer height = 1936
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_insphist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

