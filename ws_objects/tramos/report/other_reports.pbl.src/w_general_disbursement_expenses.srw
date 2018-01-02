$PBExportHeader$w_general_disbursement_expenses.srw
forward
global type w_general_disbursement_expenses from window
end type
type st_7 from statictext within w_general_disbursement_expenses
end type
type dw_profit_center from datawindow within w_general_disbursement_expenses
end type
type st_1 from statictext within w_general_disbursement_expenses
end type
type dw_date from datawindow within w_general_disbursement_expenses
end type
type cb_selectvouchers from commandbutton within w_general_disbursement_expenses
end type
type cb_print from commandbutton within w_general_disbursement_expenses
end type
type cb_retrieve from commandbutton within w_general_disbursement_expenses
end type
type cb_saveas from commandbutton within w_general_disbursement_expenses
end type
type cb_close from commandbutton within w_general_disbursement_expenses
end type
type dw_report from datawindow within w_general_disbursement_expenses
end type
type gb_1 from groupbox within w_general_disbursement_expenses
end type
end forward

global type w_general_disbursement_expenses from window
integer width = 4603
integer height = 2628
boolean titlebar = true
string title = "Disbursement Expenses (General)"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_7 st_7
dw_profit_center dw_profit_center
st_1 st_1
dw_date dw_date
cb_selectvouchers cb_selectvouchers
cb_print cb_print
cb_retrieve cb_retrieve
cb_saveas cb_saveas
cb_close cb_close
dw_report dw_report
gb_1 gb_1
end type
global w_general_disbursement_expenses w_general_disbursement_expenses

type variables
n_vouchers_parm_container inv_parm
integer	ii_profitcenter[]


end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    Author        Comments
  01/01/96 	      	???     		First Version
  04/04/08   1193  JSU042       Can't use button <update voyage> on report "Bunker Postcontrol"
  01/09/14	CR3781	CCY018	The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_general_disbursement_expenses.create
this.st_7=create st_7
this.dw_profit_center=create dw_profit_center
this.st_1=create st_1
this.dw_date=create dw_date
this.cb_selectvouchers=create cb_selectvouchers
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.cb_close=create cb_close
this.dw_report=create dw_report
this.gb_1=create gb_1
this.Control[]={this.st_7,&
this.dw_profit_center,&
this.st_1,&
this.dw_date,&
this.cb_selectvouchers,&
this.cb_print,&
this.cb_retrieve,&
this.cb_saveas,&
this.cb_close,&
this.dw_report,&
this.gb_1}
end on

on w_general_disbursement_expenses.destroy
destroy(this.st_7)
destroy(this.dw_profit_center)
destroy(this.st_1)
destroy(this.dw_date)
destroy(this.cb_selectvouchers)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.cb_close)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;this.move(0,0)
dw_report.setTransObject(sqlca)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.post retrieve(uo_global.is_userid)

dw_date.insertrow(0)
dw_date.setItem(1, "date_value", date(year(today()) -1,1,1))

inv_parm = create n_vouchers_parm_container



end event

type st_7 from statictext within w_general_disbursement_expenses
integer x = 3872
integer y = 88
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

type dw_profit_center from datawindow within w_general_disbursement_expenses
integer x = 3872
integer y = 152
integer width = 677
integer height = 776
integer taborder = 30
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

type st_1 from statictext within w_general_disbursement_expenses
integer x = 3877
integer y = 1108
integer width = 585
integer height = 116
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Arrival/Departure date greater than: "
boolean focusrectangle = false
end type

type dw_date from datawindow within w_general_disbursement_expenses
integer x = 3877
integer y = 1260
integer width = 306
integer height = 100
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_selectvouchers from commandbutton within w_general_disbursement_expenses
integer x = 3877
integer y = 976
integer width = 448
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select Vouchers"
end type

event clicked;openwithparm(w_select_vouchers, inv_parm )

inv_parm	 = message.powerobjectparm

dw_report.reset()

end event

type cb_print from commandbutton within w_general_disbursement_expenses
integer x = 4041
integer y = 1724
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

type cb_retrieve from commandbutton within w_general_disbursement_expenses
integer x = 4041
integer y = 1452
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;if upperbound(inv_parm.ii_vouchers) < 1 then
	MessageBox("Retrieval Error", "In order to retrieve expenses please select vouchers first")
	return
end if
	
setPointer(HourGlass!)
dw_date.accepttext()
dw_report.retrieve( inv_parm.ii_vouchers, datetime(dw_date.getitemdate(1, "date_value" ), time(0,0,0)), ii_profitcenter )
setPointer(Arrow!)
end event

type cb_saveas from commandbutton within w_general_disbursement_expenses
integer x = 4041
integer y = 1588
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

type cb_close from commandbutton within w_general_disbursement_expenses
integer x = 4041
integer y = 2424
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

type dw_report from datawindow within w_general_disbursement_expenses
integer x = 5
integer y = 12
integer width = 3831
integer height = 2512
integer taborder = 40
string title = "none"
string dataobject = "d_sq_gp_general_disbursement_expenses"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectRow(0, false)
if currentrow > 0 then
	this.selectRow(currentrow, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
	
end event

type gb_1 from groupbox within w_general_disbursement_expenses
integer x = 3854
integer y = 8
integer width = 713
integer height = 1388
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crirteria"
end type

