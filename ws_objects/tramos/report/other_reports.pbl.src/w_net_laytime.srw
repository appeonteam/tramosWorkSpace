$PBExportHeader$w_net_laytime.srw
$PBExportComments$This report shows net laytime pr. voyage, given profitcenter, charterer, and voyage years
forward
global type w_net_laytime from window
end type
type cbx_port_detail from checkbox within w_net_laytime
end type
type rb_port from radiobutton within w_net_laytime
end type
type rb_charterer from radiobutton within w_net_laytime
end type
type sle_yy from singlelineedit within w_net_laytime
end type
type st_chart from statictext within w_net_laytime
end type
type cb_select_chart from commandbutton within w_net_laytime
end type
type st_3 from statictext within w_net_laytime
end type
type st_2 from statictext within w_net_laytime
end type
type dw_profit_center from datawindow within w_net_laytime
end type
type st_7 from statictext within w_net_laytime
end type
type cb_saveas from commandbutton within w_net_laytime
end type
type cb_retrieve from commandbutton within w_net_laytime
end type
type cb_print from commandbutton within w_net_laytime
end type
type cb_close from commandbutton within w_net_laytime
end type
type dw_report from datawindow within w_net_laytime
end type
type gb_1 from groupbox within w_net_laytime
end type
end forward

global type w_net_laytime from window
integer width = 3287
integer height = 2676
boolean titlebar = true
string title = "Net Laytime/Charterer/Port"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
cbx_port_detail cbx_port_detail
rb_port rb_port
rb_charterer rb_charterer
sle_yy sle_yy
st_chart st_chart
cb_select_chart cb_select_chart
st_3 st_3
st_2 st_2
dw_profit_center dw_profit_center
st_7 st_7
cb_saveas cb_saveas
cb_retrieve cb_retrieve
cb_print cb_print
cb_close cb_close
dw_report dw_report
gb_1 gb_1
end type
global w_net_laytime w_net_laytime

type variables
integer 	ii_profitcenter[] 
long		il_chart
string		is_voyage[]

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781			CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_net_laytime.create
this.cbx_port_detail=create cbx_port_detail
this.rb_port=create rb_port
this.rb_charterer=create rb_charterer
this.sle_yy=create sle_yy
this.st_chart=create st_chart
this.cb_select_chart=create cb_select_chart
this.st_3=create st_3
this.st_2=create st_2
this.dw_profit_center=create dw_profit_center
this.st_7=create st_7
this.cb_saveas=create cb_saveas
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_report=create dw_report
this.gb_1=create gb_1
this.Control[]={this.cbx_port_detail,&
this.rb_port,&
this.rb_charterer,&
this.sle_yy,&
this.st_chart,&
this.cb_select_chart,&
this.st_3,&
this.st_2,&
this.dw_profit_center,&
this.st_7,&
this.cb_saveas,&
this.cb_retrieve,&
this.cb_print,&
this.cb_close,&
this.dw_report,&
this.gb_1}
end on

on w_net_laytime.destroy
destroy(this.cbx_port_detail)
destroy(this.rb_port)
destroy(this.rb_charterer)
destroy(this.sle_yy)
destroy(this.st_chart)
destroy(this.cb_select_chart)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_profit_center)
destroy(this.st_7)
destroy(this.cb_saveas)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;move(0,0)

dw_report.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

sle_yy.text = mid(string(year(today())),3,2)

setNull(il_chart)


end event

type cbx_port_detail from checkbox within w_net_laytime
integer x = 87
integer y = 2256
integer width = 357
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Show details"
end type

event clicked;if this.checked then
	dw_report.Object.DataWindow.Detail.Height='64'
else
	dw_report.Object.DataWindow.Detail.Height='0'
end if	
end event

type rb_port from radiobutton within w_net_laytime
integer x = 50
integer y = 2172
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port"
end type

event clicked;dw_report.dataObject = "d_net_laytime_per_port_report"
dw_report.setTransObject(sqlca)
cbx_port_detail.enabled = true
cb_select_chart.enabled = false
end event

type rb_charterer from radiobutton within w_net_laytime
integer x = 50
integer y = 2092
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charterer"
boolean checked = true
end type

event clicked;dw_report.dataObject = "d_net_laytime_report"
dw_report.setTransObject(sqlca)
cbx_port_detail.enabled = false
cbx_port_detail.checked = false
cb_select_chart.enabled = true
end event

type sle_yy from singlelineedit within w_net_laytime
integer x = 14
integer y = 1280
integer width = 786
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_chart from statictext within w_net_laytime
integer x = 14
integer y = 956
integer width = 782
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_select_chart from commandbutton within w_net_laytime
integer x = 9
integer y = 1052
integer width = 448
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Charterer..."
end type

event clicked;string		ls_chart

ls_chart = f_select_from_list("dw_active_charterer_list", 2, "Short Name", 3, "Long Name", 1, "Select charterer...", false)
IF NOT IsNull(ls_chart) THEN
	il_chart = Long(ls_chart)
	SELECT CHART_N_1
		INTO :st_chart.text
		FROM CHART 
		WHERE CHART_NR = :il_chart;
ELSE
	setNull(il_chart)
	setNull(st_chart.text)
END IF


end event

type st_3 from statictext within w_net_laytime
integer x = 9
integer y = 896
integer width = 311
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charterer:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_net_laytime
integer x = 9
integer y = 1204
integer width = 635
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Year: (yy, yy,...yy)"
boolean focusrectangle = false
end type

type dw_profit_center from datawindow within w_net_laytime
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

type st_7 from statictext within w_net_laytime
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

type cb_saveas from commandbutton within w_net_laytime
integer x = 9
integer y = 1596
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

type cb_retrieve from commandbutton within w_net_laytime
integer x = 9
integer y = 1476
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

event clicked;string	ls_year, is_empty[]

/* validate and retrieve */
if upperbound(ii_profitcenter) < 1 then
	MessageBox("Validation error", "Please select a Profitcenter, and try again.")
	dw_profit_center.POST setFocus()
	return
end if

if len(sle_yy.text) < 2 then
	MessageBox("Validation error", "Please enter Voyage Year, and try again.")
	sle_yy.POST setFocus()
	return
end if

if rb_charterer.checked then 
	if isNull(il_chart)  then
		MessageBox("Validation error", "Please select a Charterer, and try again.")
		cb_select_chart.POST setFocus()
		return
	end if
end if

ls_year = sle_yy.text
is_voyage = is_empty
do while 	len(ls_year) > 0
	is_voyage[upperBound(is_voyage) +1] = trim( f_get_token(ls_year, ","))
loop

/* Retrieve */
if rb_charterer.checked then 
	dw_report.retrieve( ii_profitcenter, il_chart, is_voyage )
else
	dw_report.retrieve( ii_profitcenter, is_voyage )
	if cbx_port_detail.checked then
		dw_report.Object.DataWindow.Detail.Height='64'
	else
		dw_report.Object.DataWindow.Detail.Height='0'
	end if	
end if	
commit;
end event

type cb_print from commandbutton within w_net_laytime
integer x = 9
integer y = 1716
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

type cb_close from commandbutton within w_net_laytime
integer x = 9
integer y = 1836
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

type dw_report from datawindow within w_net_laytime
integer x = 818
integer y = 12
integer width = 2437
integer height = 2564
integer taborder = 80
string title = "none"
string dataobject = "d_net_laytime_report"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_net_laytime
integer x = 9
integer y = 2016
integer width = 475
integer height = 348
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Report..."
end type

