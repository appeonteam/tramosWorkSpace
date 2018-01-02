$PBExportHeader$w_vmdblog.srw
forward
global type w_vmdblog from window
end type
type dp_date from datepicker within w_vmdblog
end type
type st_1 from statictext within w_vmdblog
end type
type dw_log from datawindow within w_vmdblog
end type
end forward

global type w_vmdblog from window
integer width = 3456
integer height = 2052
boolean titlebar = true
string title = "VIMS Mobile Database Changes Log"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dp_date dp_date
st_1 st_1
dw_log dw_log
end type
global w_vmdblog w_vmdblog

event open;String ls_Value

// Get last DB issue date from database
If f_Config("DBLI", ls_Value, 0) = 0 then dp_Date.Value = DateTime(ls_Value)

// Retrieve from database
dw_Log.SetTransObject(SQLCA)
dw_Log.Retrieve(dp_Date.Value)
end event

on w_vmdblog.create
this.dp_date=create dp_date
this.st_1=create st_1
this.dw_log=create dw_log
this.Control[]={this.dp_date,&
this.st_1,&
this.dw_log}
end on

on w_vmdblog.destroy
destroy(this.dp_date)
destroy(this.st_1)
destroy(this.dw_log)
end on

type dp_date from datepicker within w_vmdblog
integer x = 841
integer y = 16
integer width = 512
integer height = 96
integer taborder = 10
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2200-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2010-08-23"), Time("12:48:41.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;
dw_Log.Retrieve(this.Value)
end event

type st_1 from statictext within w_vmdblog
integer x = 37
integer y = 32
integer width = 786
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display List of Changes After:"
boolean focusrectangle = false
end type

type dw_log from datawindow within w_vmdblog
integer x = 18
integer y = 160
integer width = 3401
integer height = 1776
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vmdbchange"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

