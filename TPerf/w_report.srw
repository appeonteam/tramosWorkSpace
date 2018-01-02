HA$PBExportHeader$w_report.srw
forward
global type w_report from window
end type
type cb_close from commandbutton within w_report
end type
type cb_export from commandbutton within w_report
end type
type cb_print from commandbutton within w_report
end type
type dw_rep from datawindow within w_report
end type
end forward

global type w_report from window
integer width = 3872
integer height = 2404
boolean titlebar = true
string title = "T-Perf Report"
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
cb_export cb_export
cb_print cb_print
dw_rep dw_rep
end type
global w_report w_report

on w_report.create
this.cb_close=create cb_close
this.cb_export=create cb_export
this.cb_print=create cb_print
this.dw_rep=create dw_rep
this.Control[]={this.cb_close,&
this.cb_export,&
this.cb_print,&
this.dw_rep}
end on

on w_report.destroy
destroy(this.cb_close)
destroy(this.cb_export)
destroy(this.cb_print)
destroy(this.dw_rep)
end on

event resize;
dw_Rep.Width = newwidth - dw_Rep.x * 2
dw_Rep.Height = newheight - cb_Close.Height - dw_Rep.x * 2

cb_Print.Y = dw_Rep.Height + dw_Rep.y
cb_Export.Y = cb_Print.Y

cb_Close.X = newwidth - cb_Close.Width - dw_Rep.x
cb_Close.Y = cb_Print.Y
end event

type cb_close from commandbutton within w_report
integer x = 3017
integer y = 1760
integer width = 402
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type cb_export from commandbutton within w_report
integer x = 421
integer y = 1760
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export..."
end type

event clicked;
dw_Rep.Saveas( )
end event

type cb_print from commandbutton within w_report
integer x = 18
integer y = 1760
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print..."
end type

event clicked;
dw_Rep.Print(False, True)
end event

type dw_rep from datawindow within w_report
integer x = 18
integer y = 16
integer width = 3401
integer height = 1744
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

