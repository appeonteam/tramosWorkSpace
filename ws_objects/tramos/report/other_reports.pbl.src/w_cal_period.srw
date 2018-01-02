$PBExportHeader$w_cal_period.srw
forward
global type w_cal_period from window
end type
type st_gradename from statictext within w_cal_period
end type
type st_gradegroup from statictext within w_cal_period
end type
type cb_select_grade_name from commandbutton within w_cal_period
end type
type cb_select_grade_group from commandbutton within w_cal_period
end type
type dw_enddate from datawindow within w_cal_period
end type
type dw_startdate from datawindow within w_cal_period
end type
type st_2 from statictext within w_cal_period
end type
type st_1 from statictext within w_cal_period
end type
type cb_close from commandbutton within w_cal_period
end type
type cb_print from commandbutton within w_cal_period
end type
type cb_retrieve from commandbutton within w_cal_period
end type
type cb_saveas from commandbutton within w_cal_period
end type
type dw_profit_center from datawindow within w_cal_period
end type
type st_7 from statictext within w_cal_period
end type
type dw_cal_period_raw from datawindow within w_cal_period
end type
type dw_cal_period from datawindow within w_cal_period
end type
type gb_1 from groupbox within w_cal_period
end type
type gb_2 from groupbox within w_cal_period
end type
end forward

global type w_cal_period from window
integer width = 4201
integer height = 2280
boolean titlebar = true
string title = "Vegoil Compensation"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_gradename st_gradename
st_gradegroup st_gradegroup
cb_select_grade_name cb_select_grade_name
cb_select_grade_group cb_select_grade_group
dw_enddate dw_enddate
dw_startdate dw_startdate
st_2 st_2
st_1 st_1
cb_close cb_close
cb_print cb_print
cb_retrieve cb_retrieve
cb_saveas cb_saveas
dw_profit_center dw_profit_center
st_7 st_7
dw_cal_period_raw dw_cal_period_raw
dw_cal_period dw_cal_period
gb_1 gb_1
gb_2 gb_2
end type
global w_cal_period w_cal_period

type variables
integer ii_profitcenter[]
string is_gradename[]
end variables

forward prototypes
private subroutine of_insertrow (integer li_i, datetime ldt_startdate, datetime ldt_enddate, decimal ld_off_hire, decimal ld_sum_laden, integer li_rownumber)
private subroutine of_update_offhire_sum (integer li_i, integer li_rownumber, decimal ld_off_hire, datetime ldt_offstart, datetime ldt_offend)
end prototypes

private subroutine of_insertrow (integer li_i, datetime ldt_startdate, datetime ldt_enddate, decimal ld_off_hire, decimal ld_sum_laden, integer li_rownumber);dw_cal_period.setItem(li_rownumber, "vessel_nr", dw_cal_period_raw.getItemString(li_i, "vessels_vessel_ref_nr"))
dw_cal_period.setItem(li_rownumber, "vessel_name", dw_cal_period_raw.getItemString(li_i, "vessels_vessel_name"))
dw_cal_period.setItem(li_rownumber, "voyage_nr", dw_cal_period_raw.getItemString(li_i, "voyages_voyage_nr"))
dw_cal_period.setItem(li_rownumber, "start_date", ldt_startdate)
dw_cal_period.setItem(li_rownumber, "end_date", ldt_enddate)
dw_cal_period.setItem(li_rownumber, "grade_name",  dw_cal_period_raw.getItemString(li_i, "cd_grade_name"))
dw_cal_period.setItem(li_rownumber, "off_hire",  ld_off_hire)
dw_cal_period.setItem(li_rownumber, "sum_of_laden_days", ld_sum_laden)
end subroutine

private subroutine of_update_offhire_sum (integer li_i, integer li_rownumber, decimal ld_off_hire, datetime ldt_offstart, datetime ldt_offend);if f_datetime2long(ldt_offstart) <>  f_datetime2long(dw_cal_period_raw.getitemdatetime(li_i - 1, "off_services_off_start")) and f_datetime2long(ldt_offend) <>  f_datetime2long(dw_cal_period_raw.getitemdatetime(li_i - 1, "off_services_off_end")) then
	dw_cal_period.setItem(li_rownumber, "off_hire", dw_cal_period.getitemnumber(li_rownumber, "off_hire") + ld_off_hire)
	dw_cal_period.setItem(li_rownumber, "sum_of_laden_days", dw_cal_period.getitemnumber(li_rownumber, "sum_of_laden_days") - ld_off_hire)	
end if
end subroutine

on w_cal_period.create
this.st_gradename=create st_gradename
this.st_gradegroup=create st_gradegroup
this.cb_select_grade_name=create cb_select_grade_name
this.cb_select_grade_group=create cb_select_grade_group
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.st_2=create st_2
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.dw_profit_center=create dw_profit_center
this.st_7=create st_7
this.dw_cal_period_raw=create dw_cal_period_raw
this.dw_cal_period=create dw_cal_period
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_gradename,&
this.st_gradegroup,&
this.cb_select_grade_name,&
this.cb_select_grade_group,&
this.dw_enddate,&
this.dw_startdate,&
this.st_2,&
this.st_1,&
this.cb_close,&
this.cb_print,&
this.cb_retrieve,&
this.cb_saveas,&
this.dw_profit_center,&
this.st_7,&
this.dw_cal_period_raw,&
this.dw_cal_period,&
this.gb_1,&
this.gb_2}
end on

on w_cal_period.destroy
destroy(this.st_gradename)
destroy(this.st_gradegroup)
destroy(this.cb_select_grade_name)
destroy(this.cb_select_grade_group)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.dw_profit_center)
destroy(this.st_7)
destroy(this.dw_cal_period_raw)
destroy(this.dw_cal_period)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;this.move(0,0)
//retrieve data for dw_profit_center
dw_profit_center.settransobject(SQLCA)
dw_profit_center.post retrieve(uo_global.is_userid)
commit;
//set initial date
dw_startdate.insertRow(0)
dw_enddate.insertRow(0)
if month(today()) = 1 then
	dw_startdate.setItem(1, "date_value", date(year(today()) - 1, 12, 1))
else
	dw_startdate.setItem(1, "date_value", date(year(today()), month(today()) - 1, 1))
end if
dw_enddate.setItem(1, "date_value", date(year(today()), month(today()), 1))
end event

type st_gradename from statictext within w_cal_period
integer x = 850
integer y = 352
integer width = 818
integer height = 76
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

type st_gradegroup from statictext within w_cal_period
integer x = 850
integer y = 132
integer width = 818
integer height = 76
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

type cb_select_grade_name from commandbutton within w_cal_period
integer x = 850
integer y = 452
integer width = 539
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Grade Name"
end type

event clicked;string ls_name

ls_name =  f_select_from_list ( "dw_grade_list", 2, "Name", 1, "Group", 2, "Select", true) 

if not isNull(ls_name) then
	st_gradename.text = ls_name
end if


end event

type cb_select_grade_group from commandbutton within w_cal_period
integer x = 850
integer y = 244
integer width = 539
integer height = 68
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Grade Group"
end type

event clicked;string ls_group

ls_group =  f_select_from_list ( "dw_grade_groups", 1, "Group", 1, "", 1, "Select", true ) 

if not isNull(ls_group) then
	st_gradegroup.text = ls_group
end if

end event

type dw_enddate from datawindow within w_cal_period
integer x = 2199
integer y = 224
integer width = 306
integer height = 88
integer taborder = 50
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_startdate from datawindow within w_cal_period
integer x = 2199
integer y = 120
integer width = 306
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cal_period
integer x = 1838
integer y = 248
integer width = 347
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ending time:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cal_period
integer x = 1838
integer y = 124
integer width = 347
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Starting time:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_cal_period
integer x = 2181
integer y = 496
integer width = 343
integer height = 100
integer taborder = 100
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

type cb_print from commandbutton within w_cal_period
integer x = 2181
integer y = 376
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_cal_period.print( )

end event

type cb_retrieve from commandbutton within w_cal_period
integer x = 1787
integer y = 376
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;int li_rownumber_raw, li_rownumber, li_i, li_count, li_j
datetime ldt_startdate, ldt_enddate, ldt_offstart, ldt_offend, ldt_start_date, ldt_end_date
decimal ld_redfactor, ld_off_hire, ld_sum_laden
string ls_vessel_nr, ls_voyage_nr, ls_gradename, ls_gradegroup_s[], ls_gradename_s[]

/*Validate Profitcenter */
if upperBound(ii_profitcenter) = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter")
	dw_profit_center.post setFocus()
	return
end if

/* Validate dates */
dw_startdate.accepttext()
dw_enddate.accepttext()
if isnull(dw_startdate.getItemDate(1, "date_value")) or &
	isNull(dw_enddate.getItemDate(1, "date_value")) then 
	MessageBox("Information", "Please enter both start- and enddate")
	return
end if
if dw_startdate.getItemDate(1, "date_value") >= &
	dw_enddate.getItemDate(1, "date_value") then 
	MessageBox("Information", "Startdate must be before enddate")
	return
end if

ldt_start_date = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end_date = datetime(dw_enddate.getItemDate(1, "date_value"))

/*Validate grade */
if st_gradegroup.text = "" and  st_gradename.text = "" then
	MessageBox("Validation Error", "Please select either a Gradegroup or Groupname")
	return
end if

//set gradegroup and gradename
f_split(ls_gradegroup_s, st_gradegroup.text, ",")
f_split(ls_gradename_s, st_gradename.text, ",")


//retrieve data for dw_cal_period_raw
dw_cal_period_raw.settransobject(SQLCA)
dw_cal_period_raw.retrieve(ldt_start_date, ldt_end_date, ii_profitcenter, ls_gradename_s, ls_gradegroup_s)
commit;

//get row number of dw_cal_period_raw
li_rownumber_raw =  dw_cal_period_raw.rowcount( );

//reset dw_cal_period
dw_cal_period.reset( )

for li_i = 1 to li_rownumber_raw
	//set ldt_offstart and ldt_offend
	ldt_startdate = dw_cal_period_raw.getitemdatetime(li_i, "startdate")
	ldt_enddate = dw_cal_period_raw.getitemdatetime(li_i, "enddate")
	ldt_offstart = dw_cal_period_raw.getitemdatetime(li_i, "off_services_off_start")
	ldt_offend = dw_cal_period_raw.getitemdatetime(li_i, "off_services_off_end")
	if ldt_offstart < ldt_startdate and ldt_offend >= ldt_startdate and ldt_offend <= ldt_enddate  then
		ldt_offstart = ldt_startdate
	elseif ldt_offstart <=ldt_enddate and ldt_offstart >=ldt_startdate and ldt_offend > ldt_enddate then
		ldt_offend = ldt_enddate
	else
		// use orginal off-hire date or no off-hire
	end if
	ld_redfactor = dw_cal_period_raw.getitemdecimal(li_i, "red_factor")
	if ld_redfactor <> 1 then
		ld_off_hire = (f_datetime2long(ldt_offend) - f_datetime2long(ldt_offstart))/86400*ld_redfactor
	else
		ld_off_hire = (f_datetime2long(ldt_offend) - f_datetime2long(ldt_offstart))/86400
	end if
	ld_sum_laden = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400 - ld_off_hire
	
	//set data to dw_cal_period	
	if dw_cal_period_raw.getItemString(li_i, "vessels_vessel_ref_nr") <> ls_vessel_nr then //insert row when different vessel
		li_rownumber = dw_cal_period.insertrow(0)
		of_insertrow(li_i, ldt_startdate, ldt_enddate, ld_off_hire, ld_sum_laden, li_rownumber)
	elseif dw_cal_period_raw.getItemString(li_i, "voyages_voyage_nr") <> ls_voyage_nr then //insert row when different voyage
		li_rownumber = dw_cal_period.insertrow(0)
		of_insertrow(li_i, ldt_startdate, ldt_enddate, ld_off_hire, ld_sum_laden, li_rownumber)
	elseif Match(ls_gradename, dw_cal_period_raw.getItemString(li_i, "cd_grade_name")) then //only update off_hire and sum_laden  
		of_update_offhire_sum( li_i, li_rownumber,  ld_off_hire, ldt_offstart, ldt_offend)
	else //update grad_ename, off_hire, sum_laden when different gradename
		dw_cal_period.setItem(li_rownumber, "grade_name", dw_cal_period.getItemString(li_rownumber, "grade_name") + ", " + dw_cal_period_raw.getItemString(li_i, "cd_grade_name"))	
		of_update_offhire_sum( li_i, li_rownumber,  ld_off_hire, ldt_offstart, ldt_offend)
	end if
	
	//set the comparable parameters
	ls_vessel_nr = dw_cal_period.getItemString(li_rownumber, "vessel_nr")
	ls_voyage_nr = dw_cal_period.getItemString(li_rownumber, "voyage_nr")
	ls_gradename = dw_cal_period.getItemString(li_rownumber, "grade_name")
next














end event

type cb_saveas from commandbutton within w_cal_period
integer x = 1787
integer y = 496
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_cal_period.saveas( )

end event

type dw_profit_center from datawindow within w_cal_period
integer x = 41
integer y = 80
integer width = 699
integer height = 524
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

type st_7 from statictext within w_cal_period
integer x = 41
integer y = 16
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

type dw_cal_period_raw from datawindow within w_cal_period
boolean visible = false
integer x = 2802
integer y = 116
integer width = 946
integer height = 368
integer taborder = 60
string title = "none"
string dataobject = "d_cal_period_raw"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_cal_period from datawindow within w_cal_period
integer x = 37
integer y = 640
integer width = 4133
integer height = 1536
integer taborder = 130
string title = "none"
string dataobject = "d_cal_period"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cal_period
integer x = 1760
integer y = 40
integer width = 786
integer height = 304
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report period:"
end type

type gb_2 from groupbox within w_cal_period
integer x = 795
integer y = 40
integer width = 923
integer height = 556
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select grade:"
end type

