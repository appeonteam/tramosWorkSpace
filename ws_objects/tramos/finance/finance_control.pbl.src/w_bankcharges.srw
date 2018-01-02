$PBExportHeader$w_bankcharges.srw
forward
global type w_bankcharges from window
end type
type cb_close from commandbutton within w_bankcharges
end type
type cb_saveas from commandbutton within w_bankcharges
end type
type cb_print from commandbutton within w_bankcharges
end type
type st_2 from statictext within w_bankcharges
end type
type st_1 from statictext within w_bankcharges
end type
type dw_end from datawindow within w_bankcharges
end type
type dw_start from datawindow within w_bankcharges
end type
type cb_refresh from commandbutton within w_bankcharges
end type
type dw_report from datawindow within w_bankcharges
end type
type gb_1 from groupbox within w_bankcharges
end type
end forward

global type w_bankcharges from window
integer width = 1957
integer height = 2656
boolean titlebar = true
string title = "Bank Charges"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
st_2 st_2
st_1 st_1
dw_end dw_end
dw_start dw_start
cb_refresh cb_refresh
dw_report dw_report
gb_1 gb_1
end type
global w_bankcharges w_bankcharges

on w_bankcharges.create
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.st_2=create st_2
this.st_1=create st_1
this.dw_end=create dw_end
this.dw_start=create dw_start
this.cb_refresh=create cb_refresh
this.dw_report=create dw_report
this.gb_1=create gb_1
this.Control[]={this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.st_2,&
this.st_1,&
this.dw_end,&
this.dw_start,&
this.cb_refresh,&
this.dw_report,&
this.gb_1}
end on

on w_bankcharges.destroy
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_end)
destroy(this.dw_start)
destroy(this.cb_refresh)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;this.move(0,0)
dw_start.insertrow(0)
dw_start.setItem(1, "datetime_value", datetime(date(year(today()), 1,1), time(0,0,0)))
dw_end.insertrow(0)
dw_end.setItem(1, "datetime_value", datetime(date(year(today()) +1, 1,1), time(0,0,0)))

dw_report.setTransObject(sqlca)
dw_report.post retrieve(dw_start.getItemDatetime(1, "datetime_value"), dw_end.getItemDatetime(1, "datetime_value"), uo_global.is_userid )
end event

type cb_close from commandbutton within w_bankcharges
integer x = 1349
integer y = 304
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_saveas from commandbutton within w_bankcharges
integer x = 1349
integer y = 180
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_report.saveas()
end event

type cb_print from commandbutton within w_bankcharges
integer x = 1349
integer y = 56
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_report.print()
end event

type st_2 from statictext within w_bankcharges
integer x = 91
integer y = 264
integer width = 169
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "End:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_bankcharges
integer x = 91
integer y = 144
integer width = 169
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start:"
boolean focusrectangle = false
end type

type dw_end from datawindow within w_bankcharges
integer x = 297
integer y = 248
integer width = 393
integer height = 88
integer taborder = 20
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_start from datawindow within w_bankcharges
integer x = 297
integer y = 128
integer width = 393
integer height = 88
integer taborder = 10
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_refresh from commandbutton within w_bankcharges
integer x = 768
integer y = 240
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refresh"
boolean default = true
end type

event clicked;dw_start.accepttext()
dw_end.accepttext()
dw_report.post retrieve(dw_start.getItemDatetime(1, "datetime_value"), dw_end.getItemDatetime(1, "datetime_value"), uo_global.is_userid )
end event

type dw_report from datawindow within w_bankcharges
integer x = 37
integer y = 452
integer width = 1833
integer height = 2060
integer taborder = 40
string title = "none"
string dataobject = "d_sq_gp_bankcharges"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_bankcharges
integer x = 32
integer y = 24
integer width = 1147
integer height = 380
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Criteria"
end type

