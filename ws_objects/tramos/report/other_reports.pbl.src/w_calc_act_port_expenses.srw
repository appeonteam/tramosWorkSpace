$PBExportHeader$w_calc_act_port_expenses.srw
$PBExportComments$Monitor difference between calculated and actual port expenses (Item #423)
forward
global type w_calc_act_port_expenses from window
end type
type st_lines from statictext within w_calc_act_port_expenses
end type
type em_lines from editmask within w_calc_act_port_expenses
end type
type rb_worse from radiobutton within w_calc_act_port_expenses
end type
type rb_best from radiobutton within w_calc_act_port_expenses
end type
type rb_group from radiobutton within w_calc_act_port_expenses
end type
type cbx_showdetail from checkbox within w_calc_act_port_expenses
end type
type dw_profit_center from datawindow within w_calc_act_port_expenses
end type
type st_7 from statictext within w_calc_act_port_expenses
end type
type cb_saveas from commandbutton within w_calc_act_port_expenses
end type
type em_year from editmask within w_calc_act_port_expenses
end type
type cb_retrieve from commandbutton within w_calc_act_port_expenses
end type
type cb_print from commandbutton within w_calc_act_port_expenses
end type
type cb_close from commandbutton within w_calc_act_port_expenses
end type
type st_3 from statictext within w_calc_act_port_expenses
end type
type st_2 from statictext within w_calc_act_port_expenses
end type
type dw_report from datawindow within w_calc_act_port_expenses
end type
type gb_1 from groupbox within w_calc_act_port_expenses
end type
end forward

global type w_calc_act_port_expenses from window
integer width = 3461
integer height = 2668
boolean titlebar = true
string title = "Calculated/Actual Port Expenses"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_lines st_lines
em_lines em_lines
rb_worse rb_worse
rb_best rb_best
rb_group rb_group
cbx_showdetail cbx_showdetail
dw_profit_center dw_profit_center
st_7 st_7
cb_saveas cb_saveas
em_year em_year
cb_retrieve cb_retrieve
cb_print cb_print
cb_close cb_close
st_3 st_3
st_2 st_2
dw_report dw_report
gb_1 gb_1
end type
global w_calc_act_port_expenses w_calc_act_port_expenses

type variables
integer ii_profitcenter
datastore ids_main_report
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
   	01/09/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_calc_act_port_expenses.create
this.st_lines=create st_lines
this.em_lines=create em_lines
this.rb_worse=create rb_worse
this.rb_best=create rb_best
this.rb_group=create rb_group
this.cbx_showdetail=create cbx_showdetail
this.dw_profit_center=create dw_profit_center
this.st_7=create st_7
this.cb_saveas=create cb_saveas
this.em_year=create em_year
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.cb_close=create cb_close
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
this.gb_1=create gb_1
this.Control[]={this.st_lines,&
this.em_lines,&
this.rb_worse,&
this.rb_best,&
this.rb_group,&
this.cbx_showdetail,&
this.dw_profit_center,&
this.st_7,&
this.cb_saveas,&
this.em_year,&
this.cb_retrieve,&
this.cb_print,&
this.cb_close,&
this.st_3,&
this.st_2,&
this.dw_report,&
this.gb_1}
end on

on w_calc_act_port_expenses.destroy
destroy(this.st_lines)
destroy(this.em_lines)
destroy(this.rb_worse)
destroy(this.rb_best)
destroy(this.rb_group)
destroy(this.cbx_showdetail)
destroy(this.dw_profit_center)
destroy(this.st_7)
destroy(this.cb_saveas)
destroy(this.em_year)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;move(0,0)

em_year.text = string(year(today()))

ids_main_report = create datastore
ids_main_report.dataObject = "d_calc_act_port_expenses"
ids_main_report.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)



end event

event close;destroy ids_main_report
end event

type st_lines from statictext within w_calc_act_port_expenses
integer x = 1769
integer y = 656
integer width = 594
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Best/Worse lines to show:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_lines from editmask within w_calc_act_port_expenses
integer x = 2423
integer y = 640
integer width = 151
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "10"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###0"
end type

event modified;integer 	li_lines
string		ls_filter	

if dw_report.dataObject = "d_gr_calc_act_port_expenses" then return
li_lines = integer(em_lines.text)
if li_lines > 0 then
	ls_filter = "getrow() <= "+string(li_lines)
end if
dw_report.setFilter(ls_filter)
dw_report.filter()
end event

type rb_worse from radiobutton within w_calc_act_port_expenses
integer x = 987
integer y = 476
integer width = 896
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Worse (further away from estimated)"
end type

event clicked;cbx_showdetail.enabled= 	false
cbx_showdetail.checked = 	false
st_lines.enabled = 				true
em_lines.enabled = 			true

if ids_main_report.rowCount() > 0 then
	dw_report.setRedraw(false)
	dw_report.sharedataoff()
	dw_report.dataObject = "d_best_worse_calc_act_port_expenses"
	ids_main_report.sort()
	ids_main_report.sharedata(dw_report)
	dw_report.setFilter("")
	dw_report.filter()
	dw_report.setSort("delta_expenses D")
	dw_report.sort()
	em_lines.trigger event modified()
	dw_report.setRedraw(true)
else
	dw_report.dataObject = "d_best_worse_calc_act_port_expenses"
end if
end event

type rb_best from radiobutton within w_calc_act_port_expenses
integer x = 987
integer y = 376
integer width = 658
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Best (closest to estimated)"
end type

event clicked;cbx_showdetail.enabled= 	false
cbx_showdetail.checked = 	false
st_lines.enabled = 				true
em_lines.enabled = 			true

if ids_main_report.rowCount() > 0 then
	dw_report.setRedraw(false)
	dw_report.sharedataoff()
	dw_report.dataObject = "d_best_worse_calc_act_port_expenses"
	ids_main_report.sort()
	ids_main_report.sharedata(dw_report)
	dw_report.setFilter("")
	dw_report.filter()
	dw_report.setSort("delta_expenses A")
	dw_report.sort()
	em_lines.trigger event modified()
	dw_report.setRedraw(true)
else
	dw_report.dataObject = "d_best_worse_calc_act_port_expenses"
end if
end event

type rb_group from radiobutton within w_calc_act_port_expenses
integer x = 987
integer y = 276
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
string text = "Grouped"
boolean checked = true
end type

event clicked;cbx_showdetail.enabled= 	true
cbx_showdetail.checked = 	false
st_lines.enabled = 				false
em_lines.enabled = 			false

if ids_main_report.rowCount() > 0 then
	dw_report.setRedraw(false)
	dw_report.sharedataoff()
	dw_report.dataObject = "d_gr_calc_act_port_expenses"
	ids_main_report.setSort("month A")
	ids_main_report.sort()
	ids_main_report.sharedata(dw_report)
	dw_report.setFilter("")
	dw_report.filter()
	dw_report.sort()
	dw_report.groupCalc()
	dw_report.setRedraw(true)
else
	dw_report.dataObject = "d_gr_calc_act_port_expenses"
end if
end event

type cbx_showdetail from checkbox within w_calc_act_port_expenses
integer x = 887
integer y = 648
integer width = 357
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show details"
end type

event clicked;if dw_report.dataObject = "d_gr_calc_act_port_expenses" then
	if this.checked then
		dw_report.object.datawindow.detail.height = 68
//		dw_report.vscrollbar=false
//		dw_report.vscrollbar=true
	else
		dw_report.object.datawindow.detail.height = 0
	end if	
end if
end event

type dw_profit_center from datawindow within w_calc_act_port_expenses
integer x = 9
integer y = 64
integer width = 699
integer height = 680
integer taborder = 10
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row > 0) then
	this.selectrow(0,false)
	this.selectrow(row,true)
	ii_profitcenter = this.getItemNumber(row, "pc_nr")
	ids_main_report.reset()
end if


end event

type st_7 from statictext within w_calc_act_port_expenses
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

type cb_saveas from commandbutton within w_calc_act_port_expenses
integer x = 2848
integer y = 340
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

type em_year from editmask within w_calc_act_port_expenses
integer x = 1394
integer y = 64
integer width = 183
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
double increment = 1
string minmax = "1995~~2020"
end type

event modified;ids_main_report.reset()
end event

type cb_retrieve from commandbutton within w_calc_act_port_expenses
integer x = 2848
integer y = 220
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;string		ls_year

/* validate and retrieve */
/* Profitcenter */
if isNull(ii_profitcenter) or ii_profitcenter = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter")
	dw_profit_center.post setFocus()
	return
end if

/* Year */
if isNull(em_year.text) then
	MessageBox("Validation Error", "Please enter a Year")
	em_year.post setFocus()
	return
end if
ls_year = mid(em_year.text,3,2)

dw_report.sharedataoff()
ids_main_report.setSort("")
setpointer( hourglass! ) 
ids_main_report.retrieve(ls_year,  ii_profitcenter)
commit;
setpointer(arrow!)

if rb_group .checked then
	rb_group.post event clicked()
elseif rb_best.checked then
	rb_best.post event clicked()
else 
	rb_worse.post event clicked()
end if	

end event

type cb_print from commandbutton within w_calc_act_port_expenses
integer x = 2848
integer y = 460
integer width = 343
integer height = 100
integer taborder = 70
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

type cb_close from commandbutton within w_calc_act_port_expenses
integer x = 2848
integer y = 580
integer width = 343
integer height = 100
integer taborder = 80
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

type st_3 from statictext within w_calc_act_port_expenses
integer x = 1591
integer y = 72
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(yyyy)"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_calc_act_port_expenses
integer x = 782
integer y = 76
integer width = 585
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage year selection:"
boolean focusrectangle = false
end type

type dw_report from datawindow within w_calc_act_port_expenses
integer x = 14
integer y = 784
integer width = 3415
integer height = 1792
integer taborder = 100
string title = "none"
string dataobject = "d_gr_calc_act_port_expenses"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort

If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
	SelectRow(0,false)
	SetRow(row)
	SelectRow(row,True)
End if

if dwo.type = "text" then
	ls_sort = dwo.Tag

	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
	
end if
end event

event doubleclicked;//
// Removed when vessel nr changed to vessel ref nr
//
//integer 	li_vessel
//string 	ls_voyage
//u_jump_finance_control luo_jump_fin
//
//if row < 1 then return
//
//li_vessel = this.getItemNumber(row, "vessel_nr")
//if dw_report.dataObject = "d_apm_pool_comm_control_tccomm"  &
//or dw_report.dataObject = "d_apm_pool_comm_control_tc_percent" then
//	ls_voyage = ""
//else
//	ls_voyage = this.getItemString(row, "voyage_nr")
//end if
//luo_jump_fin = CREATE u_jump_finance_control
//luo_jump_fin.of_open_control(li_vessel, ls_voyage)
//DESTROY luo_jump_fin
end event

type gb_1 from groupbox within w_calc_act_port_expenses
integer x = 887
integer y = 200
integer width = 1687
integer height = 388
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Report"
end type

