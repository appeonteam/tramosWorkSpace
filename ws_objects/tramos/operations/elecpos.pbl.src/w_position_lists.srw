$PBExportHeader$w_position_lists.srw
forward
global type w_position_lists from window
end type
type cbx_include_non_apm from checkbox within w_position_lists
end type
type cb_saveas from commandbutton within w_position_lists
end type
type cb_print from commandbutton within w_position_lists
end type
type st_1 from statictext within w_position_lists
end type
type dw_startdate from datawindow within w_position_lists
end type
type st_2 from statictext within w_position_lists
end type
type dw_profit_center from datawindow within w_position_lists
end type
type dw_report from datawindow within w_position_lists
end type
type cb_close from commandbutton within w_position_lists
end type
end forward

global type w_position_lists from window
integer width = 3593
integer height = 2640
boolean titlebar = true
string title = "Position Lists"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
cbx_include_non_apm cbx_include_non_apm
cb_saveas cb_saveas
cb_print cb_print
st_1 st_1
dw_startdate dw_startdate
st_2 st_2
dw_profit_center dw_profit_center
dw_report dw_report
cb_close cb_close
end type
global w_position_lists w_position_lists

type variables
integer	ii_profitcenter[]
end variables

forward prototypes
private function long of_retrieve ()
public subroutine documentation ()
end prototypes

private function long of_retrieve ();long ll_rows
datetime ldt_start

if upperbound(ii_profitcenter) < 1 then return 0

ldt_start = dw_startdate.getItemDatetime(1, "datetime_value")
if cbx_include_non_apm.checked then
	ll_rows = dw_report.retrieve(ldt_start, ii_profitcenter, 0)
	dw_report.object.footer_text.text="Port Calls >= "+string(ldt_start, "dd/mm-yy hh:mm") 
else
	ll_rows = dw_report.retrieve(ldt_start, ii_profitcenter, 1)
	dw_report.object.footer_text.text="Port Calls >= "+string(ldt_start, "dd/mm-yy hh:mm") +" (APM vessels only)"
end if

dw_report.POST setFocus()

return ll_rows
end function

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

on w_position_lists.create
this.cbx_include_non_apm=create cbx_include_non_apm
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.st_1=create st_1
this.dw_startdate=create dw_startdate
this.st_2=create st_2
this.dw_profit_center=create dw_profit_center
this.dw_report=create dw_report
this.cb_close=create cb_close
this.Control[]={this.cbx_include_non_apm,&
this.cb_saveas,&
this.cb_print,&
this.st_1,&
this.dw_startdate,&
this.st_2,&
this.dw_profit_center,&
this.dw_report,&
this.cb_close}
end on

on w_position_lists.destroy
destroy(this.cbx_include_non_apm)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.st_1)
destroy(this.dw_startdate)
destroy(this.st_2)
destroy(this.dw_profit_center)
destroy(this.dw_report)
destroy(this.cb_close)
end on

event open;move(0,0)

dw_startdate.insertrow(0)
dw_startdate.setItem(1, "datetime_value", today())
dw_profit_center.SetTransObject(SQLCA)
dw_report.setTransObject(SQLCA)
dw_profit_center.POST retrieve( uo_global.is_userid )
dw_profit_center.setrowfocusindicator(FOCUSRECT!)
dw_profit_center.POST setFocus()

if uo_global.ii_access_level = -2 then
	post close(this)
end if
	
	
end event

type cbx_include_non_apm from checkbox within w_position_lists
integer x = 2811
integer y = 400
integer width = 686
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include Non-APM Vessels"
end type

event clicked;post of_retrieve( )
end event

type cb_saveas from commandbutton within w_position_lists
integer x = 1810
integer y = 208
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_report.saveas()
end event

type cb_print from commandbutton within w_position_lists
integer x = 1810
integer y = 64
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_report.print()
end event

type st_1 from statictext within w_position_lists
integer x = 901
integer y = 92
integer width = 297
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start Date"
boolean focusrectangle = false
end type

type dw_startdate from datawindow within w_position_lists
integer x = 1225
integer y = 80
integer width = 389
integer height = 92
integer taborder = 20
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;this.accepttext( )
post of_retrieve( )
end event

type st_2 from statictext within w_position_lists
integer x = 55
integer y = 20
integer width = 635
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit Center Selection"
boolean focusrectangle = false
end type

type dw_profit_center from datawindow within w_position_lists
integer x = 46
integer y = 72
integer width = 699
integer height = 408
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
	post of_retrieve()
end if


end event

type dw_report from datawindow within w_position_lists
integer x = 46
integer y = 520
integer width = 3456
integer height = 1972
integer taborder = 60
string title = "none"
string dataobject = "d_sq_tb_position_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_position_lists
integer x = 1810
integer y = 352
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

