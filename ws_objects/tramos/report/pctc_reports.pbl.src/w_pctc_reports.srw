$PBExportHeader$w_pctc_reports.srw
$PBExportComments$PCTC vessels /Car carriers - reports window
forward
global type w_pctc_reports from window
end type
type st_3 from statictext within w_pctc_reports
end type
type st_2 from statictext within w_pctc_reports
end type
type st_1 from statictext within w_pctc_reports
end type
type dw_enddate from datawindow within w_pctc_reports
end type
type dw_startdate from datawindow within w_pctc_reports
end type
type rb_single_port_grade_visits from radiobutton within w_pctc_reports
end type
type cb_select_grade from commandbutton within w_pctc_reports
end type
type st_gradename from statictext within w_pctc_reports
end type
type st_gradegroup from statictext within w_pctc_reports
end type
type st_portcode from statictext within w_pctc_reports
end type
type cb_select_port from commandbutton within w_pctc_reports
end type
type st_portname from statictext within w_pctc_reports
end type
type cbx_hide_port from checkbox within w_pctc_reports
end type
type cbx_hide_vessel from checkbox within w_pctc_reports
end type
type rb_grade_port_visits from radiobutton within w_pctc_reports
end type
type rb_single_port_visits from radiobutton within w_pctc_reports
end type
type rb_filter_both from radiobutton within w_pctc_reports
end type
type rb_filter_discharge from radiobutton within w_pctc_reports
end type
type rb_filter_load from radiobutton within w_pctc_reports
end type
type cb_deselect_all from commandbutton within w_pctc_reports
end type
type cb_select_all from commandbutton within w_pctc_reports
end type
type cb_close from commandbutton within w_pctc_reports
end type
type cb_saveas from commandbutton within w_pctc_reports
end type
type cb_print from commandbutton within w_pctc_reports
end type
type cb_retrieve from commandbutton within w_pctc_reports
end type
type rb_country_port_visits from radiobutton within w_pctc_reports
end type
type rb_vessel_port_visits from radiobutton within w_pctc_reports
end type
type dw_report from datawindow within w_pctc_reports
end type
type dw_vessel_list from datawindow within w_pctc_reports
end type
type gb_1 from groupbox within w_pctc_reports
end type
type gb_2 from groupbox within w_pctc_reports
end type
type gb_3 from groupbox within w_pctc_reports
end type
end forward

global type w_pctc_reports from window
integer width = 4603
integer height = 2552
boolean titlebar = true
string title = "PCTC Reports"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_3 st_3
st_2 st_2
st_1 st_1
dw_enddate dw_enddate
dw_startdate dw_startdate
rb_single_port_grade_visits rb_single_port_grade_visits
cb_select_grade cb_select_grade
st_gradename st_gradename
st_gradegroup st_gradegroup
st_portcode st_portcode
cb_select_port cb_select_port
st_portname st_portname
cbx_hide_port cbx_hide_port
cbx_hide_vessel cbx_hide_vessel
rb_grade_port_visits rb_grade_port_visits
rb_single_port_visits rb_single_port_visits
rb_filter_both rb_filter_both
rb_filter_discharge rb_filter_discharge
rb_filter_load rb_filter_load
cb_deselect_all cb_deselect_all
cb_select_all cb_select_all
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
rb_country_port_visits rb_country_port_visits
rb_vessel_port_visits rb_vessel_port_visits
dw_report dw_report
dw_vessel_list dw_vessel_list
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pctc_reports w_pctc_reports

type variables
integer ii_vesselno[], ii_empty[]
end variables

forward prototypes
public subroutine wf_purposefilter ()
public function long wf_retrieve ()
end prototypes

public subroutine wf_purposefilter ();if rb_filter_load.checked then
	dw_report.setFilter("bol_l_d=1")
elseif rb_filter_discharge.checked then
	dw_report.setFilter("bol_l_d=0")
else
	dw_report.setFilter("")
end if
dw_report.Filter()
dw_report.sort()
dw_report.groupCalc()
end subroutine

public function long wf_retrieve ();long ll_rows, ll_calls
datastore lds_data
datetime ldt_start, ldt_end

ldt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end = datetime(dw_enddate.getItemDate(1, "date_value"))


if rb_single_port_visits.checked then
	ll_rows = dw_report.retrieve(ii_vesselno, ldt_start, ldt_end, st_portcode.text)
	lds_data = create datastore
	lds_data.dataObject = "d_number_of_unique_poc"
	lds_data.setTransObject(SQLCA)
	lds_data.retrieve(ii_vesselno, ldt_start, ldt_end, st_portcode.text)
	ll_calls = lds_data.getItemNumber(1, "no_of_calls")
	dw_report.Object.t_calls.text = string(ll_calls, "#,##0")+ " Unique calls to this port"
	destroy lds_data
elseif rb_grade_port_visits.checked then
	ll_rows = dw_report.retrieve(ii_vesselno, ldt_start, ldt_end, st_gradename.text)
elseif rb_single_port_grade_visits.checked then
	if len(st_portcode.text) = 0 or len(st_gradename.text) = 0 then return 0
	ll_rows = dw_report.retrieve(ii_vesselno, ldt_start, ldt_end, st_portcode.text, st_gradename.text)
else
	ll_rows = dw_report.retrieve(ii_vesselno, ldt_start, ldt_end)
end if		

return ll_rows
end function

on w_pctc_reports.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.rb_single_port_grade_visits=create rb_single_port_grade_visits
this.cb_select_grade=create cb_select_grade
this.st_gradename=create st_gradename
this.st_gradegroup=create st_gradegroup
this.st_portcode=create st_portcode
this.cb_select_port=create cb_select_port
this.st_portname=create st_portname
this.cbx_hide_port=create cbx_hide_port
this.cbx_hide_vessel=create cbx_hide_vessel
this.rb_grade_port_visits=create rb_grade_port_visits
this.rb_single_port_visits=create rb_single_port_visits
this.rb_filter_both=create rb_filter_both
this.rb_filter_discharge=create rb_filter_discharge
this.rb_filter_load=create rb_filter_load
this.cb_deselect_all=create cb_deselect_all
this.cb_select_all=create cb_select_all
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.rb_country_port_visits=create rb_country_port_visits
this.rb_vessel_port_visits=create rb_vessel_port_visits
this.dw_report=create dw_report
this.dw_vessel_list=create dw_vessel_list
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.dw_enddate,&
this.dw_startdate,&
this.rb_single_port_grade_visits,&
this.cb_select_grade,&
this.st_gradename,&
this.st_gradegroup,&
this.st_portcode,&
this.cb_select_port,&
this.st_portname,&
this.cbx_hide_port,&
this.cbx_hide_vessel,&
this.rb_grade_port_visits,&
this.rb_single_port_visits,&
this.rb_filter_both,&
this.rb_filter_discharge,&
this.rb_filter_load,&
this.cb_deselect_all,&
this.cb_select_all,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.cb_retrieve,&
this.rb_country_port_visits,&
this.rb_vessel_port_visits,&
this.dw_report,&
this.dw_vessel_list,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_pctc_reports.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.rb_single_port_grade_visits)
destroy(this.cb_select_grade)
destroy(this.st_gradename)
destroy(this.st_gradegroup)
destroy(this.st_portcode)
destroy(this.cb_select_port)
destroy(this.st_portname)
destroy(this.cbx_hide_port)
destroy(this.cbx_hide_vessel)
destroy(this.rb_grade_port_visits)
destroy(this.rb_single_port_visits)
destroy(this.rb_filter_both)
destroy(this.rb_filter_discharge)
destroy(this.rb_filter_load)
destroy(this.cb_deselect_all)
destroy(this.cb_select_all)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.rb_country_port_visits)
destroy(this.rb_vessel_port_visits)
destroy(this.dw_report)
destroy(this.dw_vessel_list)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;move(0,0)
dw_vessel_list.setTransObject(SQLCA)
dw_report.setTransObject(SQLCA)
dw_vessel_list.POST retrieve(uo_global.is_userid )
dw_startdate.insertRow(0)
dw_startdate.setItem(1, "date_value", date(year(today()),1,1))
dw_enddate.insertRow(0)
dw_enddate.setItem(1, "date_value", date(year(today())+1,1,1))

end event

type st_3 from statictext within w_pctc_reports
integer x = 2080
integer y = 108
integer width = 114
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "End:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pctc_reports
integer x = 1637
integer y = 108
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pctc_reports
integer x = 1641
integer y = 24
integer width = 613
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Period: (>= start and < end)"
boolean focusrectangle = false
end type

type dw_enddate from datawindow within w_pctc_reports
integer x = 2194
integer y = 92
integer width = 297
integer height = 88
integer taborder = 50
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;accepttext()

if dw_startdate.getItemDate(1, "date_value") >= dw_enddate.getItemDate(1, "date_value") then
	MessageBox("Validation Error", "Startdate must be less than enddate!")
	return
end if

if upperbound(ii_vesselno) > 0 then 
	wf_retrieve()
else 
	dw_report.reset()
end if

end event

event losefocus;this.triggerEvent(Itemchanged!)
end event

type dw_startdate from datawindow within w_pctc_reports
integer x = 1765
integer y = 92
integer width = 297
integer height = 88
integer taborder = 40
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;accepttext()

if dw_startdate.getItemDate(1, "date_value") >= dw_enddate.getItemDate(1, "date_value") then
	MessageBox("Validation Error", "Startdate must be less than enddate!")
	return
end if

if upperbound(ii_vesselno) > 0 then 
	wf_retrieve()
else 
	dw_report.reset()
end if

end event

event losefocus;this.triggerEvent(Itemchanged!)
end event

type rb_single_port_grade_visits from radiobutton within w_pctc_reports
integer x = 2633
integer y = 324
integer width = 617
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Single Port/Grade Visits"
end type

event clicked;dw_report.dataObject = "d_pctc_single_port_and_grade_visits"
dw_report.setTransObject(SQLCA)

cbx_hide_port.enabled = false
cbx_hide_vessel.enabled = true
cbx_hide_vessel.checked = false
cb_select_port.enabled = true
cb_select_grade.enabled = true
rb_filter_load.enabled = false
rb_filter_discharge.enabled = false
rb_filter_both.enabled = false
rb_filter_both.Event Clicked()
rb_filter_both.checked = true

if upperbound(ii_vesselno) > 0 then 
	if len(st_portcode.text) = 0 and len(st_gradename.text) = 0 then 
		cb_select_port.Event Clicked()
		cb_select_grade.Event Clicked()
	elseif len(st_portcode.text) = 0 then
		cb_select_port.Event Clicked()
	elseif len(st_gradename.text) = 0 then 
		cb_select_grade.Event Clicked()
	else
		POST wf_retrieve()
		POST wf_purposeFilter()
	end if
else 
	dw_report.reset()
end if


end event

type cb_select_grade from commandbutton within w_pctc_reports
integer x = 3342
integer y = 428
integer width = 343
integer height = 68
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select Grade"
end type

event clicked;string ls_group, ls_name

ls_name =  f_select_from_list ( "dw_grade_list", 2, "Name", 1, "Group", 2, "Select", false ) 

if not isNull(ls_name) then
	SELECT GRADE_GROUP
		INTO :ls_group
		FROM GRADES
		WHERE GRADE_NAME = :ls_name;
	st_gradename.text = ls_name
	st_gradegroup.text = ls_group
	POST wf_retrieve()
	POST wf_purposeFilter()
end if

end event

type st_gradename from statictext within w_pctc_reports
integer x = 3342
integer y = 340
integer width = 750
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

type st_gradegroup from statictext within w_pctc_reports
integer x = 3342
integer y = 256
integer width = 745
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

type st_portcode from statictext within w_pctc_reports
integer x = 3337
integer y = 60
integer width = 146
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

type cb_select_port from commandbutton within w_pctc_reports
integer x = 3337
integer y = 148
integer width = 343
integer height = 68
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select Port"
end type

event clicked;string ls_portcode, ls_portname

ls_portcode =  f_select_from_list ( "dw_ports_list", 2, "Name", 1, "Code", 1, "Select", false ) 

if not isNull(ls_portcode) then
	SELECT PORT_N
		INTO :ls_portname
		FROM PORTS
		WHERE PORT_CODE = :ls_portcode;
	st_portname.text = ls_portname
	st_portcode.text = ls_portcode
	POST wf_retrieve()
	POST wf_purposeFilter()
end if


end event

type st_portname from statictext within w_pctc_reports
integer x = 3488
integer y = 60
integer width = 603
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_hide_port from checkbox within w_pctc_reports
integer x = 2633
integer y = 456
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
boolean enabled = false
string text = "Hide Port"
end type

event clicked;if this.checked then
	dw_report.modify("DataWindow.Header.2.Height='0'")
//	dw_report.Object.DataWindow.Header.2.Height='0'
else
	dw_report.modify("DataWindow.Header.2.Height='64'")
//	dw_report.Object.DataWindow.Header.2.Height='64'
end if	
end event

type cbx_hide_vessel from checkbox within w_pctc_reports
integer x = 2633
integer y = 528
integer width = 567
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
string text = "Hide Vessel/Voyage"
end type

event clicked;if this.checked then
	dw_report.Object.DataWindow.Detail.Height='0'
else
	dw_report.Object.DataWindow.Detail.Height='64'
end if	
end event

type rb_grade_port_visits from radiobutton within w_pctc_reports
integer x = 2633
integer y = 264
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grade Port Visits"
end type

event clicked;dw_report.dataObject = "d_pctc_grade_port_visits"
dw_report.setTransObject(SQLCA)

cbx_hide_port.enabled = false
cbx_hide_vessel.enabled = true
cbx_hide_vessel.checked = false
cb_select_port.enabled = false
cb_select_grade.enabled = true
rb_filter_load.enabled = true
rb_filter_discharge.enabled = true
rb_filter_both.enabled = true

if upperbound(ii_vesselno) > 0 then 
	if len(st_gradename.text) = 0 then 
		cb_select_grade.Event Clicked()
	else
		POST wf_retrieve()
		POST wf_purposeFilter()
	end if
else 
	dw_report.reset()
end if

end event

type rb_single_port_visits from radiobutton within w_pctc_reports
integer x = 2633
integer y = 204
integer width = 471
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Single Port Visits"
end type

event clicked;dw_report.dataObject = "d_pctc_single_port_visits"
dw_report.setTransObject(SQLCA)

cbx_hide_port.enabled = false
cbx_hide_vessel.enabled = true
cbx_hide_vessel.checked = false
cb_select_port.enabled = true
cb_select_grade.enabled = false
rb_filter_load.enabled = false
rb_filter_discharge.enabled = false
rb_filter_both.enabled = false
rb_filter_both.Event Clicked()
rb_filter_both.checked = true

if upperbound(ii_vesselno) > 0 then 
	if len(st_portcode.text) = 0 then 
		cb_select_port.Event Clicked()
	else
		POST wf_retrieve()
		POST wf_purposeFilter()
	end if
else 
	dw_report.reset()
end if


end event

type rb_filter_both from radiobutton within w_pctc_reports
integer x = 1751
integer y = 436
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
string text = "Both"
boolean checked = true
end type

event clicked;wf_purposeFilter()
end event

type rb_filter_discharge from radiobutton within w_pctc_reports
integer x = 1751
integer y = 364
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
string text = "Discharge"
end type

event clicked;wf_purposeFilter()
end event

type rb_filter_load from radiobutton within w_pctc_reports
integer x = 1751
integer y = 292
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
string text = "Load"
end type

event clicked;wf_purposeFilter()
end event

type cb_deselect_all from commandbutton within w_pctc_reports
integer x = 439
integer y = 544
integer width = 338
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Deselect All"
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset vessel array
ii_vesselno = ii_empty

dw_vessel_list.selectrow(0, false)

dw_report.reset()

end event

type cb_select_all from commandbutton within w_pctc_reports
integer x = 27
integer y = 544
integer width = 338
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset vessel array
ii_vesselno = ii_empty

dw_vessel_list.selectrow(0, true)

ll_rows = dw_vessel_list.rowcount()

li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_vessel_list.isselected(ll_row)) then
		ii_vesselno[li_index] = dw_vessel_list.getitemnumber(ll_row, "vessel_nr")
		li_index ++
	end if
NEXT

if li_index > 1 then
	wf_retrieve()		
else 
	dw_report.reset()
end if

end event

type cb_close from commandbutton within w_pctc_reports
integer x = 4114
integer y = 468
integer width = 343
integer height = 100
integer taborder = 140
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

type cb_saveas from commandbutton within w_pctc_reports
integer x = 4114
integer y = 320
integer width = 343
integer height = 100
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_report.saveAs()
end event

type cb_print from commandbutton within w_pctc_reports
integer x = 4114
integer y = 172
integer width = 343
integer height = 100
integer taborder = 120
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

type cb_retrieve from commandbutton within w_pctc_reports
integer x = 4114
integer y = 24
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;if upperbound(ii_vesselno) > 0 then 
	wf_retrieve()
else 
	dw_report.reset()
end if

end event

type rb_country_port_visits from radiobutton within w_pctc_reports
integer x = 2633
integer y = 144
integer width = 558
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Country Port Visits"
end type

event clicked;dw_report.dataObject = "d_pctc_country_port_visits"
dw_report.setTransObject(SQLCA)

if upperbound(ii_vesselno) > 0 then 
	POST wf_retrieve()
	POST wf_purposeFilter()
else 
	dw_report.reset()
end if

cbx_hide_port.enabled = true
cbx_hide_vessel.enabled = true
cbx_hide_vessel.checked = false
cb_select_port.enabled = false
cb_select_grade.enabled = false
rb_filter_load.enabled = true
rb_filter_discharge.enabled = true
rb_filter_both.enabled = true
end event

type rb_vessel_port_visits from radiobutton within w_pctc_reports
integer x = 2633
integer y = 84
integer width = 581
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Port Visits"
boolean checked = true
end type

event clicked;dw_report.dataObject = "d_pctc_vessel_port_visits"
dw_report.setTransObject(SQLCA)

if upperbound(ii_vesselno) > 0 then 
	POST wf_retrieve()
	POST wf_purposeFilter()
else 
	dw_report.reset()
end if

cbx_hide_port.enabled = false
cbx_hide_vessel.enabled = false
cbx_hide_vessel.checked = false
cb_select_port.enabled = false
cb_select_grade.enabled = false
rb_filter_load.enabled = true
rb_filter_discharge.enabled = true
rb_filter_both.enabled = true
end event

type dw_report from datawindow within w_pctc_reports
integer x = 14
integer y = 656
integer width = 4439
integer height = 1732
integer taborder = 150
string title = "none"
string dataobject = "d_pctc_vessel_port_visits"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if dwo.type = "text" then
	if dwo.Tag <> "" then
		this.setSort(dwo.Tag)
		this.Sort()
		this.groupcalc()
	end if
end if

end event

type dw_vessel_list from datawindow within w_pctc_reports
integer x = 32
integer y = 24
integer width = 1559
integer height = 504
integer taborder = 10
string title = "none"
string dataobject = "d_pctc_vessel_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset vessel array
ii_vesselno = ii_empty

if (row > 0) then this.selectrow(row, NOT this.isselected(row))

ll_rows = dw_vessel_list.rowcount()

li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_vessel_list.isselected(ll_row)) then
		ii_vesselno[li_index] = dw_vessel_list.getitemnumber(ll_row, "vessel_nr")
		li_index ++
	end if
NEXT

if li_index > 1 then
	wf_retrieve()		
else 
	dw_report.reset()
end if

end event

type gb_1 from groupbox within w_pctc_reports
integer x = 2555
integer y = 24
integer width = 754
integer height = 380
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select report..."
end type

type gb_2 from groupbox within w_pctc_reports
integer x = 1669
integer y = 232
integer width = 462
integer height = 292
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Purpose Filter"
end type

type gb_3 from groupbox within w_pctc_reports
integer x = 2555
integer y = 400
integer width = 754
integer height = 216
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show / Hide"
end type

