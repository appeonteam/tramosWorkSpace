$PBExportHeader$w_hfo_bunker_purchase.srw
forward
global type w_hfo_bunker_purchase from window
end type
type st_2 from statictext within w_hfo_bunker_purchase
end type
type st_1 from statictext within w_hfo_bunker_purchase
end type
type dw_enddate from datawindow within w_hfo_bunker_purchase
end type
type dw_startdate from datawindow within w_hfo_bunker_purchase
end type
type dw_profit_center from datawindow within w_hfo_bunker_purchase
end type
type st_7 from statictext within w_hfo_bunker_purchase
end type
type cb_saveas from commandbutton within w_hfo_bunker_purchase
end type
type cb_retrieve from commandbutton within w_hfo_bunker_purchase
end type
type cb_print from commandbutton within w_hfo_bunker_purchase
end type
type cb_close from commandbutton within w_hfo_bunker_purchase
end type
type dw_report from datawindow within w_hfo_bunker_purchase
end type
end forward

global type w_hfo_bunker_purchase from window
integer width = 4306
integer height = 2684
boolean titlebar = true
string title = "HSFO and LSFO Bunker Purchases"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_2 st_2
st_1 st_1
dw_enddate dw_enddate
dw_startdate dw_startdate
dw_profit_center dw_profit_center
st_7 st_7
cb_saveas cb_saveas
cb_retrieve cb_retrieve
cb_print cb_print
cb_close cb_close
dw_report dw_report
end type
global w_hfo_bunker_purchase w_hfo_bunker_purchase

type variables
integer ii_profitcenter[] 

end variables

on w_hfo_bunker_purchase.create
this.st_2=create st_2
this.st_1=create st_1
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.dw_profit_center=create dw_profit_center
this.st_7=create st_7
this.cb_saveas=create cb_saveas
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_report=create dw_report
this.Control[]={this.st_2,&
this.st_1,&
this.dw_enddate,&
this.dw_startdate,&
this.dw_profit_center,&
this.st_7,&
this.cb_saveas,&
this.cb_retrieve,&
this.cb_print,&
this.cb_close,&
this.dw_report}
end on

on w_hfo_bunker_purchase.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.dw_profit_center)
destroy(this.st_7)
destroy(this.cb_saveas)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_report)
end on

event open;move(0,0)

dw_report.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

dw_startdate.insertRow(0)
dw_startdate.setItem(1, "datetime_value", datetime(date(year(today()),01,01)))

dw_enddate.insertRow(0)
dw_enddate.setItem(1, "datetime_value", datetime(date(year(today()) +1,01,01)))



end event

type st_2 from statictext within w_hfo_bunker_purchase
integer x = 9
integer y = 1080
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enddate:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_hfo_bunker_purchase
integer x = 9
integer y = 876
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Startdate:"
boolean focusrectangle = false
end type

type dw_enddate from datawindow within w_hfo_bunker_purchase
integer x = 9
integer y = 1148
integer width = 402
integer height = 96
integer taborder = 30
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_startdate from datawindow within w_hfo_bunker_purchase
integer x = 9
integer y = 944
integer width = 402
integer height = 96
integer taborder = 20
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_profit_center from datawindow within w_hfo_bunker_purchase
integer x = 9
integer y = 64
integer width = 699
integer height = 776
integer taborder = 10
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_empty[]
integer li_x, li_count

if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	ii_profitcenter = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			ii_profitcenter[li_count] = this.getItemNumber(li_x, "pc_nr")
		end if
	next
end if


end event

type st_7 from statictext within w_hfo_bunker_purchase
integer x = 9
integer width = 599
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Profit Center(s):"
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_hfo_bunker_purchase
integer x = 32
integer y = 1416
integer width = 343
integer height = 100
integer taborder = 50
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

type cb_retrieve from commandbutton within w_hfo_bunker_purchase
integer x = 32
integer y = 1296
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;/* validate and retrieve */

/* Startdate */
dw_startdate.accepttext()
if isNull(dw_startdate.getItemDatetime(1, "datetime_value")) then
	MessageBox("Validation Error", "Please enter Startdate")
	dw_startdate.post setFocus()
	return
end if

/* Enddate */
dw_enddate.accepttext()
if isNull(dw_enddate.getItemDatetime(1, "datetime_value")) then
	MessageBox("Validation Error", "Please enter Startdate")
	dw_enddate.post setFocus()
	return
end if

/* Retrieve */
dw_report.retrieve( ii_profitcenter, dw_startdate.getItemDatetime(1, "datetime_value"), dw_enddate.getItemDatetime(1, "datetime_value"))
commit;
end event

type cb_print from commandbutton within w_hfo_bunker_purchase
integer x = 32
integer y = 1536
integer width = 343
integer height = 100
integer taborder = 60
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

type cb_close from commandbutton within w_hfo_bunker_purchase
integer x = 32
integer y = 1656
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

type dw_report from datawindow within w_hfo_bunker_purchase
integer x = 818
integer y = 12
integer width = 3461
integer height = 2564
integer taborder = 80
string title = "none"
string dataobject = "d_hfo_bunker_purchase"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

