$PBExportHeader$w_weekly_report.srw
forward
global type w_weekly_report from window
end type
type st_year from statictext within w_weekly_report
end type
type rb_ytd from radiobutton within w_weekly_report
end type
type rb_weeks from radiobutton within w_weekly_report
end type
type cb_5 from commandbutton within w_weekly_report
end type
type cb_4 from commandbutton within w_weekly_report
end type
type st_status from statictext within w_weekly_report
end type
type dw_weekly_report from datawindow within w_weekly_report
end type
type st_2 from statictext within w_weekly_report
end type
type st_1 from statictext within w_weekly_report
end type
type dw_weeks from datawindow within w_weekly_report
end type
type dw_pools from datawindow within w_weekly_report
end type
type cb_3 from commandbutton within w_weekly_report
end type
type cb_2 from commandbutton within w_weekly_report
end type
type cb_1 from commandbutton within w_weekly_report
end type
type gb_1 from groupbox within w_weekly_report
end type
end forward

global type w_weekly_report from window
integer width = 4498
integer height = 2192
boolean titlebar = true
string title = "Weekly Fixture Report (Gas)"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_year st_year
rb_ytd rb_ytd
rb_weeks rb_weeks
cb_5 cb_5
cb_4 cb_4
st_status st_status
dw_weekly_report dw_weekly_report
st_2 st_2
st_1 st_1
dw_weeks dw_weeks
dw_pools dw_pools
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_weekly_report w_weekly_report

type variables
Double id_pool_id
Integer il_weeks_row
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781			CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;this.move(0,0)
dw_weeks.SetTransObject(SQLCA)
dw_weekly_report.SetTransObject(SQLCA)
dw_pools.SetTransObject(SQLCA)
dw_pools.Retrieve( uo_global.is_userid )
end event

on w_weekly_report.create
this.st_year=create st_year
this.rb_ytd=create rb_ytd
this.rb_weeks=create rb_weeks
this.cb_5=create cb_5
this.cb_4=create cb_4
this.st_status=create st_status
this.dw_weekly_report=create dw_weekly_report
this.st_2=create st_2
this.st_1=create st_1
this.dw_weeks=create dw_weeks
this.dw_pools=create dw_pools
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.st_year,&
this.rb_ytd,&
this.rb_weeks,&
this.cb_5,&
this.cb_4,&
this.st_status,&
this.dw_weekly_report,&
this.st_2,&
this.st_1,&
this.dw_weeks,&
this.dw_pools,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_weekly_report.destroy
destroy(this.st_year)
destroy(this.rb_ytd)
destroy(this.rb_weeks)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.st_status)
destroy(this.dw_weekly_report)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_weeks)
destroy(this.dw_pools)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type st_year from statictext within w_weekly_report
integer x = 2318
integer y = 344
integer width = 197
integer height = 56
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type rb_ytd from radiobutton within w_weekly_report
integer x = 1906
integer y = 344
integer width = 407
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Year to date"
end type

event clicked;Integer li_counter

dw_weeks.SelectRow(0,FALSE)
dw_weekly_report.Reset()
st_year.text = ""
il_weeks_row = 0
	
end event

type rb_weeks from radiobutton within w_weekly_report
integer x = 1906
integer y = 244
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Week"
boolean checked = true
end type

event clicked;dw_weekly_report.Reset()
dw_weeks.Retrieve(id_pool_id)
il_weeks_row = 0
st_year.text = ""

end event

type cb_5 from commandbutton within w_weekly_report
integer x = 2665
integer y = 196
integer width = 384
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create &Report"
end type

event clicked;Integer li_year, li_week1, li_week2 = 52

IF il_weeks_row > 0 THEN
	li_year = dw_weeks.GetItemNumber(il_weeks_row,"report_year")
	li_week1 = dw_weeks.GetItemNumber(il_weeks_row,"report_week")
	IF rb_weeks.checked THEN 
		li_week2 = li_week1
	ELSE
		li_week1 = 0
	END IF	
	dw_weekly_report.Retrieve(id_pool_id, li_year, li_week1, li_week2)
ELSE
	MessageBox("Information","No Week/Year are selected for the Report !")
END IF	
end event

type cb_4 from commandbutton within w_weekly_report
integer x = 3913
integer y = 196
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Admin. data"
end type

event clicked;Open(w_weekly_report_admin)
end event

type st_status from statictext within w_weekly_report
integer x = 2665
integer y = 356
integer width = 503
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_weekly_report from datawindow within w_weekly_report
integer x = 1737
integer y = 496
integer width = 2706
integer height = 1588
integer taborder = 30
string title = "none"
string dataobject = "d_weekly_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;st_status.text = "Report Ready"
end event

type st_2 from statictext within w_weekly_report
integer x = 1280
integer y = 40
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Report Week :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_weekly_report
integer x = 59
integer y = 44
integer width = 357
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select a Pool :"
boolean focusrectangle = false
end type

type dw_weeks from datawindow within w_weekly_report
integer x = 1294
integer y = 128
integer width = 402
integer height = 1956
integer taborder = 20
string title = "none"
string dataobject = "d_weekly_report_weeks"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_year, li_week

IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
	st_status.text = ""
	il_weeks_row = row
	IF rb_ytd.Checked THEN 
		st_year.text = String(this.GetItemNumber(row,"report_year"))
	ELSE
		st_year.text = ""
	END IF	
ELSE
	SelectRow(0,FALSE)
	dw_weekly_report.Reset()
	st_status.text = ""
	st_year.text = ""
	il_weeks_row = 0
END IF
end event

type dw_pools from datawindow within w_weekly_report
integer x = 55
integer y = 128
integer width = 1166
integer height = 1956
integer taborder = 10
string title = "none"
string dataobject = "d_tc_pool_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_counter, li_rows

IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
	st_status.text = ""
	dw_weekly_report.Reset()
	id_pool_id = this.GetItemNumber(row,"pool_id")
	li_rows = dw_weeks.Retrieve(id_pool_id)
	il_weeks_row = 0
	st_year.text = ""
END IF
end event

type cb_3 from commandbutton within w_weekly_report
integer x = 3314
integer y = 348
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&SaveAs"
end type

event clicked;
IF dw_weeks.GetRow() > 0 THEN dw_weekly_report.SaveAs()
end event

type cb_2 from commandbutton within w_weekly_report
integer x = 3314
integer y = 196
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;IF dw_weeks.GetRow() > 0 THEN dw_weekly_report.Print()
end event

type cb_1 from commandbutton within w_weekly_report
integer x = 3913
integer y = 340
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;Close(parent)
end event

type gb_1 from groupbox within w_weekly_report
integer x = 1792
integer y = 160
integer width = 745
integer height = 304
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Week or Year to date"
end type

