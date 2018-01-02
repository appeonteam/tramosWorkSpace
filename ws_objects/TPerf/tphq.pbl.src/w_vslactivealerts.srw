$PBExportHeader$w_vslactivealerts.srw
forward
global type w_vslactivealerts from window
end type
type cb_print from commandbutton within w_vslactivealerts
end type
type cb_close from commandbutton within w_vslactivealerts
end type
type dw_report from datawindow within w_vslactivealerts
end type
end forward

global type w_vslactivealerts from window
integer width = 3776
integer height = 2292
boolean titlebar = true
string title = "Vessel Active Alerts"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Information!"
boolean center = true
cb_print cb_print
cb_close cb_close
dw_report dw_report
end type
global w_vslactivealerts w_vslactivealerts

on w_vslactivealerts.create
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_report=create dw_report
this.Control[]={this.cb_print,&
this.cb_close,&
this.dw_report}
end on

on w_vslactivealerts.destroy
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_report)
end on

event open;
// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_report.object.p_handy.Visible = 1
	dw_report.object.p_maersk.Visible = 0
	dw_report.object.t_company.Text = "Handytankers"
End If

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(g_parameters.VesselID)


end event

event resize;Integer li_tmpx

dw_report.width = newwidth - dw_report.x * 2
dw_report.height = newheight - dw_report.y * 3 - cb_close.height

li_tmpx = (newwidth  - (cb_Print.width * 2)) / 3
if li_tmpx < 0 then li_tmpx = 0
cb_Print.x = li_tmpx
cb_Print.y = newheight - dw_report.y - cb_Print.height

li_tmpx = cb_print.width + li_tmpx * 2
If li_tmpx < cb_Print.x + cb_Print.width then li_tmpx = cb_print.x + cb_print.width

cb_close.x = li_tmpx

cb_close.y = cb_Print.y


end event

type cb_print from commandbutton within w_vslactivealerts
integer x = 640
integer y = 2048
integer width = 603
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;
dw_report.Print(true, true)
end event

type cb_close from commandbutton within w_vslactivealerts
integer x = 1920
integer y = 2048
integer width = 603
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

close(parent)


end event

type dw_report from datawindow within w_vslactivealerts
integer x = 18
integer y = 16
integer width = 3694
integer height = 1984
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vslactivealerts"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

