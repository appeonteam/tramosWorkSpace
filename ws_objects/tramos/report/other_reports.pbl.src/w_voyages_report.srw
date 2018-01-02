$PBExportHeader$w_voyages_report.srw
$PBExportComments$Standard report window used to display: "Unfinished Voyages Report" and "Time Consumed to Finished a Voyage"
forward
global type w_voyages_report from mt_w_sheet
end type
type cb_clear from commandbutton within w_voyages_report
end type
type cb_select from commandbutton within w_voyages_report
end type
type st_2 from statictext within w_voyages_report
end type
type dw_profit_center from datawindow within w_voyages_report
end type
type st_number_of_items from statictext within w_voyages_report
end type
type sle_year from singlelineedit within w_voyages_report
end type
type dw_voyages from datawindow within w_voyages_report
end type
type st_1 from statictext within w_voyages_report
end type
type cb_close from commandbutton within w_voyages_report
end type
type cb_saveas from commandbutton within w_voyages_report
end type
type cb_print from commandbutton within w_voyages_report
end type
type cb_create from commandbutton within w_voyages_report
end type
type gb_1 from groupbox within w_voyages_report
end type
end forward

global type w_voyages_report from mt_w_sheet
integer width = 4599
integer height = 2744
cb_clear cb_clear
cb_select cb_select
st_2 st_2
dw_profit_center dw_profit_center
st_number_of_items st_number_of_items
sle_year sle_year
dw_voyages dw_voyages
st_1 st_1
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
cb_create cb_create
gb_1 gb_1
end type
global w_voyages_report w_voyages_report

type variables
integer ii_profitcenter[]
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
   	25/08/14 CR3708            CCY018       corrected ancestor and modified event ue_getwidowname
   </HISTORY>
********************************************************************/
end subroutine

on w_voyages_report.create
int iCurrent
call super::create
this.cb_clear=create cb_clear
this.cb_select=create cb_select
this.st_2=create st_2
this.dw_profit_center=create dw_profit_center
this.st_number_of_items=create st_number_of_items
this.sle_year=create sle_year
this.dw_voyages=create dw_voyages
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_create=create cb_create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_profit_center
this.Control[iCurrent+5]=this.st_number_of_items
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.dw_voyages
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_close
this.Control[iCurrent+10]=this.cb_saveas
this.Control[iCurrent+11]=this.cb_print
this.Control[iCurrent+12]=this.cb_create
this.Control[iCurrent+13]=this.gb_1
end on

on w_voyages_report.destroy
call super::destroy
destroy(this.cb_clear)
destroy(this.cb_select)
destroy(this.st_2)
destroy(this.dw_profit_center)
destroy(this.st_number_of_items)
destroy(this.sle_year)
destroy(this.dw_voyages)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_create)
destroy(this.gb_1)
end on

event open;call super::open;string ls_parm
ls_parm = message.StringParm

if mid(ls_parm,1,3)="UNF" then
	dw_voyages.dataobject = "d_unfinished_voyages"
elseif mid(ls_parm,1,3)="TIM" then
	dw_voyages.dataobject = "d_time_consumed_to_close_a_voyage"
else
	return 
end if

this.title = mid(ls_parm,5)

dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

end event

event ue_getwindowname;call super::ue_getwindowname;if dw_voyages.dataobject = "d_unfinished_voyages" then
	as_windowname = this.classname( ) + "_unf"
elseif dw_voyages.dataobject = "d_time_consumed_to_close_a_voyage" then
	as_windowname = this.classname( ) + "_tim"
else
	as_windowname = this.classname( )
end if
end event

type cb_clear from commandbutton within w_voyages_report
integer x = 379
integer y = 804
integer width = 329
integer height = 80
integer taborder = 103
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;integer	li_row
integer li_empty[]

for li_row = 1 to dw_profit_center.rowcount( )
	dw_profit_center.selectrow(li_row,false)
next

ii_profitcenter = li_empty
	
end event

type cb_select from commandbutton within w_voyages_report
integer x = 41
integer y = 804
integer width = 329
integer height = 80
integer taborder = 102
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;integer	li_row
integer li_empty[]

ii_profitcenter = li_empty

for li_row = 1 to dw_profit_center.rowcount( )
	dw_profit_center.selectrow(li_row,true)
	ii_profitcenter[li_row] = dw_profit_center.getItemNumber(li_row, "pc_nr")
next
	
end event

type st_2 from statictext within w_voyages_report
integer x = 41
integer y = 112
integer width = 425
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit Center:"
boolean focusrectangle = false
end type

type dw_profit_center from datawindow within w_voyages_report
integer x = 41
integer y = 172
integer width = 667
integer height = 624
integer taborder = 100
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

type st_number_of_items from statictext within w_voyages_report
integer x = 782
integer y = 2540
integer width = 878
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_voyages_report
integer x = 485
integer y = 992
integer width = 174
integer height = 80
integer taborder = 104
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_voyages from datawindow within w_voyages_report
integer x = 777
integer y = 32
integer width = 3753
integer height = 2492
integer taborder = 120
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_voyages_report
integer x = 59
integer y = 1000
integer width = 425
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Year (yy):"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_voyages_report
integer x = 41
integer y = 1560
integer width = 343
integer height = 100
integer taborder = 108
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

type cb_saveas from commandbutton within w_voyages_report
integer x = 41
integer y = 1436
integer width = 343
integer height = 100
integer taborder = 107
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_voyages.saveas()
end event

type cb_print from commandbutton within w_voyages_report
integer x = 41
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 106
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_voyages.print()
end event

type cb_create from commandbutton within w_voyages_report
integer x = 41
integer y = 1188
integer width = 343
integer height = 100
integer taborder = 105
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Create..."
end type

event clicked;
if sle_year.text = "" or len(sle_year.text )<>2 then
	MessageBox("Error","Voyage Year Invalid!")
	return 
end if
if upperBound(ii_profitcenter) = 0 then
	MessageBox("Error","Please select a Profit Center!")
	return 
end if

dw_voyages.setTransObject(SQLCA)

if dw_voyages.retrieve(sle_year.text, ii_profitcenter) = 0 then
	MessageBox("Information", "No voyages found")
	return
end if

st_number_of_items.text = string(dw_voyages.rowcount()) + " items"
end event

type gb_1 from groupbox within w_voyages_report
integer x = 18
integer y = 28
integer width = 731
integer height = 1092
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter Options"
end type

