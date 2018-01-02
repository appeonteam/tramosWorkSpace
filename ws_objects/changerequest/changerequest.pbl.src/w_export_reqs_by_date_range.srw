$PBExportHeader$w_export_reqs_by_date_range.srw
forward
global type w_export_reqs_by_date_range from mt_w_sheet
end type
type st_2 from mt_u_statictext within w_export_reqs_by_date_range
end type
type st_1 from mt_u_statictext within w_export_reqs_by_date_range
end type
type dp_to from datepicker within w_export_reqs_by_date_range
end type
type dp_from from datepicker within w_export_reqs_by_date_range
end type
type cb_save from mt_u_commandbutton within w_export_reqs_by_date_range
end type
type dw_output from u_datagrid within w_export_reqs_by_date_range
end type
type st_7 from u_topbar_background within w_export_reqs_by_date_range
end type
end forward

global type w_export_reqs_by_date_range from mt_w_sheet
integer width = 3387
integer height = 2568
string title = "Export By Date Range"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
st_2 st_2
st_1 st_1
dp_to dp_to
dp_from dp_from
cb_save cb_save
dw_output dw_output
st_7 st_7
end type
global w_export_reqs_by_date_range w_export_reqs_by_date_range

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_export_reqs_by_date_range
   <OBJECT>		Export Requests by Date Range	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
	01/09/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_export_reqs_by_date_range.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.dp_to=create dp_to
this.dp_from=create dp_from
this.cb_save=create cb_save
this.dw_output=create dw_output
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dp_to
this.Control[iCurrent+4]=this.dp_from
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.dw_output
this.Control[iCurrent+7]=this.st_7
end on

on w_export_reqs_by_date_range.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.cb_save)
destroy(this.dw_output)
destroy(this.st_7)
end on

event open;call super::open;n_dw_style_service   lnv_style
n_service_manager lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_output, false)

dw_output.settransobject(sqlca)

dw_output.retrieve(date(dp_from.value), date(dp_to.value))

end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_export_reqs_by_date_range
end type

type st_2 from mt_u_statictext within w_export_reqs_by_date_range
integer x = 695
integer y = 56
integer width = 110
long textcolor = 16777215
long backcolor = 553648127
string text = "To"
alignment alignment = right!
end type

type st_1 from mt_u_statictext within w_export_reqs_by_date_range
integer x = 37
integer y = 56
integer width = 238
long textcolor = 16777215
long backcolor = 553648127
string text = "Start Date"
alignment alignment = right!
end type

type dp_to from datepicker within w_export_reqs_by_date_range
integer x = 823
integer y = 40
integer width = 421
integer height = 80
integer taborder = 20
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2014-09-01"), Time("10:48:06.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event closeup;if date(dp_to.value) < date(dp_from.value) then
	dp_to.SetValue(datetime(dp_from.value))
else
	dw_output.retrieve(date(dp_from.value),date(dp_to.value))
end if


end event

event losefocus;if date(dp_to.value) < date(dp_from.value) then
	dp_to.SetValue(datetime(dp_from.value))
else
	dw_output.retrieve(date(dp_from.value),date(dp_to.value))
end if
end event

type dp_from from datepicker within w_export_reqs_by_date_range
integer x = 293
integer y = 40
integer width = 421
integer height = 80
integer taborder = 10
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2014-09-01"), Time("10:48:06.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event closeup;if date(dp_to.value) < date(dp_from.value) then
	dp_from.SetValue(datetime(dp_to.value))
else
	dw_output.retrieve(date(dp_from.value),date(dp_to.value))
end if


end event

event losefocus;if date(dp_to.value) < date(dp_from.value) then
	dp_from.SetValue(datetime(dp_to.value))
else
	dw_output.retrieve(date(dp_from.value),date(dp_to.value))
end if
end event

type cb_save from mt_u_commandbutton within w_export_reqs_by_date_range
integer x = 2999
integer y = 40
integer taborder = 30
string text = "&Save As..."
boolean default = true
end type

event clicked;if dw_output.rowcount() > 0 then
	dw_output.saveas("", excel8!, true)
else
	messagebox("Error", "You have no records to export.  Please select a valid date range")
end if

end event

type dw_output from u_datagrid within w_export_reqs_by_date_range
integer x = 23
integer y = 236
integer width = 3319
integer height = 2220
integer taborder = 50
string dataobject = "d_export_req_date_range"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if row > 0 then
	this.selectrow(0, false ) 
	this.selectrow(row, true ) 
	this.setrow(row)
end if
end event

type st_7 from u_topbar_background within w_export_reqs_by_date_range
integer width = 3383
end type

