$PBExportHeader$w_key_performance_report_charterer.srw
forward
global type w_key_performance_report_charterer from mt_w_master
end type
type st_1 from statictext within w_key_performance_report_charterer
end type
type st_4 from statictext within w_key_performance_report_charterer
end type
type cbx_selectall from checkbox within w_key_performance_report_charterer
end type
type dw_vessellist from datawindow within w_key_performance_report_charterer
end type
type cbx_onlysummary from checkbox within w_key_performance_report_charterer
end type
type cb_retreive from mt_u_commandbutton within w_key_performance_report_charterer
end type
type cb_print from mt_u_commandbutton within w_key_performance_report_charterer
end type
type cb_saveas from mt_u_commandbutton within w_key_performance_report_charterer
end type
type dw_kpi from mt_u_datawindow within w_key_performance_report_charterer
end type
type dp_from from mt_u_datepicker within w_key_performance_report_charterer
end type
type dp_to from mt_u_datepicker within w_key_performance_report_charterer
end type
type st_from from mt_u_statictext within w_key_performance_report_charterer
end type
type st_to from mt_u_statictext within w_key_performance_report_charterer
end type
type st_report from statictext within w_key_performance_report_charterer
end type
type dw_vas_report from datawindow within w_key_performance_report_charterer
end type
type uo_profitcenter from u_drag_drop_boxes within w_key_performance_report_charterer
end type
type dw_summary from mt_u_datawindow within w_key_performance_report_charterer
end type
type gb_daterange from groupbox within w_key_performance_report_charterer
end type
type r_1 from rectangle within w_key_performance_report_charterer
end type
end forward

global type w_key_performance_report_charterer from mt_w_master
integer width = 4608
integer height = 2568
string title = "KPI - Charterers"
boolean resizable = false
long backcolor = 32304364
boolean center = false
event ue_postopen ( )
st_1 st_1
st_4 st_4
cbx_selectall cbx_selectall
dw_vessellist dw_vessellist
cbx_onlysummary cbx_onlysummary
cb_retreive cb_retreive
cb_print cb_print
cb_saveas cb_saveas
dw_kpi dw_kpi
dp_from dp_from
dp_to dp_to
st_from st_from
st_to st_to
st_report st_report
dw_vas_report dw_vas_report
uo_profitcenter uo_profitcenter
dw_summary dw_summary
gb_daterange gb_daterange
r_1 r_1
end type
global w_key_performance_report_charterer w_key_performance_report_charterer

type variables
Boolean ib_web
String is_year, is_fix_bal, is_fix_load, is_fix_disch, is_profitcenters=""
String is_est_bal, is_est_load, is_est_disch, is_cal_bal, is_cal_load, is_cal_disch
Decimal {0} id_fix_id
Decimal {2} is_demrate, id_days_ballast
string is_chart, is_prev_chart, is_contracttype
datetime idt_arrival, idt_laycan_start, idt_laycan_end
str_progress parm
end variables

forward prototypes
public subroutine documentation ()
private function integer _retrievereport ()
private function integer _getvasdata ()
end prototypes

event ue_postopen();uo_profitcenter.dw_left.retrieve( uo_global.is_userid )
dw_kpi.SetTransObject(SQLCA)

end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_Key_performance_report_charterer

   <OBJECT> Presents user with criteria (profit center and date ranges) facility to retrieve data</OBJECT>
   <DESC>Uses a SQL in dataobject to generate voyage/vessel list conatined in date range and profit center.
	loops through each voyage/vessel to obtain values needed from VAS report.</DESC>
   <USAGE>  Called from m_tramosmain. Used by charterers</USAGE>

    Date   Ref    Author    	Comments
  01/07/10 CR2003 AGL027    	created copy of window from w_key_performance_report
  13/07/10 CR2073 AGL027	 	fixed a few sumamry details			
  04/08/10 CR2074 AGL027	 	included the summary datawindow and added vessel exclusion possibility	
  04/08/10 CR2090 AGL027		added new column, changed expressions and reformatted window to new layout
  12/01/11	CR 2197	JMC112	data object of uo_profitcenter was replaced
  01/09/14	CR3781	CCY018	The window title match with the text of a menu item
********************************************************************/


/*

NOTES

The hard work here is inside the dataobjects.  Obtaining the voyage start and end dates is the tough part,

'd_sq_tb_kpi' & 'd_sq_tb_kpi_summary' are SHARED.  in a very simple 2 datawindow setup.  controls are setting the
datawindow to visible/invisible on the checkbox click event.

IMPORTANT: It is important any update to any expressions in one datawindow will have to be made in the other too.  The 'd_sq_tb_kpi_summary'
dataobject has all columns/computed fields as the 'd_sq_tb_kpi' dataobject, they are just hidden/moved.

Suggested improvement would be to store all columns in a datastore and share this with the datawindow containers.


VOYAGE START DATE
This is the last departure date in the previous voyage.  If this happens to be the first voyage of a vessel we take the 
first voyages arrival date instead.

VOYAGE END DATE
This is the last departure date of the current voyage

FIXTURE DAYS, ACTUAL DAYS, IDLE DAYS, FIXTURE PRIOR DRC & ACTUAL PRIOR DRC
These columns are stright from the VAS report.  This is processed in the function: wf_getreport_data()

DAYS LATE
Calculated within the function wf_getreport_data(), uses the global function: f_datetime2long()


Report Detail
============= 
The 'Days Late' column is the difference between 'Laycan End' date and 'NOR' date.  If 'NOR' date is later than 
Laycan End the voyage is considered to be running late.
 
The 'Diff Days' column is the absolute difference
 
The 'Fix-Act % Variance' columnsperpage is calculated as:

abs(( actual_result_prior_drc - fixture_result_prior_drc ) / fixture_result_prior_drc) * 100
 
The 'Diff. TCE' is the absolute value of the difference between actual_result_prior_drc and fixture_result_prior_drc.
 
Setting the report to show just the detail assists the export of the summary totals.
 
 
 
Report Summary - GROUP 1 Charterer
================================== 
{1} 'Fixture Days' Sum of charterers fixture days 
{2} 'Actual Days' Sum of actual days of voyage
{3} 'Diff. Days' Mean Average of Diff. Days 
{4} 'Fixture TCE' sum of ( column {1} * column {3} ) / ( sum of column {1} ) :Weighted Average
{5} 'Actual TCE' sum of ( column {2} * column {4} ) / (sum of column {2} ) :Weighted Average
{6} 'Diff. TCE'  sum of ( column {1} * column {6} ) / (sum of column {1} ) :Weighted Average
{7} 'Fix-Act% Variance' absolute value of ( {6} / {4} ) * 100


NB: Not sure if the previous version of this report w_key_performance_report is still used and if it is by whom.
We need to monitor this other option.

*/

end subroutine

private function integer _retrievereport ();/********************************************************************
	_retrieveReport()
   <DESC>   Validates user criteria and if all is correct, calls the vas updater</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
				<LI> 0, No Action
            <LI> -1, X Failure</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>  </ARGS>
   <USAGE>  When user clicks on command button Retreive.</USAGE>
********************************************************************/

Integer li_rows, li_counter, li_pcnr[], li_return
long ll_rc 
string ls_profitcenters=""
Integer li_excluded_vessels[], li_dummy[]
date ld_start_date, ld_end_date

/* profit center */
li_rows = uo_profitcenter.dw_right.rowcount()
if not(li_rows > 0) then 
	Messagebox("Info","Please select a profit center")
	return c#return.Failure
end if	
For li_counter = 1 to li_rows
	li_pcnr[li_counter] = uo_profitcenter.dw_right.GetItemNumber(li_counter,"pc_nr")
	ls_profitcenters += ", " + uo_profitcenter.dw_right.GetItemString(li_counter,"pc_name")
Next

is_profitcenters = mid(ls_profitcenters,2)

/* validate date ranges */
ld_start_date = date(dp_from.value)
ld_end_date = date(dp_to.value) 

if (ld_end_date < ld_start_date) then
	messagebox ("Date Error", "Your end date comes before your start date. Please enter a new end date", Information!, Ok!)
	return c#return.Failure
end if

cb_retreive.enabled = false
dw_kpi.setredraw(false)

/* build vessel exclusion array */
li_excluded_vessels = li_dummy
li_rows = dw_vessellist.rowCount()
for li_counter = 1 to li_rows
	if dw_vessellist.isSelected(li_counter) then
		li_excluded_vessels[upperBound(li_excluded_vessels) +1]=dw_vessellist.getItemNumber(li_counter, "vessel_nr")
	end if
next
	
if upperbound(li_excluded_vessels)=0 then	li_excluded_vessels[upperBound(li_excluded_vessels) +1]=0
ll_rc = dw_kpi.Retrieve(li_pcnr, datetime(ld_start_date), datetime(ld_end_date),li_excluded_vessels)

/* obtain data from VAS report */
li_return = _getVASdata()

dw_kpi.setredraw(true)
cb_retreive.enabled = true

if li_return > 0 then
	st_report.text = "New Report created"
	return c#return.Success
elseif li_return = 0 THEN
	st_report.text = "No voyage records"
	return c#return.NoAction
else
	st_report.text = "Error"
	return c#return.Failure
end if
end function

private function integer _getvasdata ();/********************************************************************
   _getVASdata()
   <DESC>   This function runs through the rows in the datawindow and locates the
	VAS detail it needs to populate required columns</DESC>
   <RETURN> Integer:
            <LI> >0, X Number of rows updated
            <LI> -1, X Failure</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  When user clicks the retreive button</USAGE>
********************************************************************/


/* Declare local variables */
u_vas_control lu_vas_control
Decimal {4} ld_days_late
Boolean lb_stopped
long ll_count, ll_number_of_voyages, ll_vessel_nr, ll_minutes, ll_days, ll_hours
long ll_act_drc, ll_fix_drc
string ls_voyage_nr,	ls_diff_text, ls_daterange
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer li_key[], li_return
	
/* create user object */
lu_vas_control = create u_vas_control
ll_number_of_voyages = dw_kpi.RowCount()

/* set local variables */
parm.title = "Generating Key Performance Report"
parm.cancel_window = w_key_performance_report
parm.cancel_event = "clicked"
parm.b_show_time = true
OpenWithParm(w_progress, parm)
ls_daterange = "Voyages between " + dp_from.text + " and " + dp_to.text
dw_kpi.modify( "t_profitcenters.Text='" + is_profitcenters +"'" )
dw_kpi.modify( "t_voyagedaterange.Text='" + ls_daterange +"'" )
dw_summary.modify( "t_profitcenters.Text='" + is_profitcenters +"'" )
dw_summary.modify( "t_voyagedaterange.Text='" + ls_daterange +"'" )

/* Loop through voyages and build data for report dw_vas_log is used as a dummy parameter for lu_vas_control */
for ll_count = 1 to ll_number_of_voyages 
	yield()
	IF NOT(IsValid(w_progress)) THEN
		dw_kpi.Reset()
		st_report.text = ""
		lb_stopped = TRUE
		EXIT
	END IF	
		
	w_progress.wf_progress(ll_count/ll_number_of_voyages,"Generating Key Performance Report")
	/* There are 3 rows for each vessel/voyage. Only get data one time for each vessel/voyage. */
	ll_vessel_nr = dw_kpi.GetItemNumber(ll_count,"vessel_nr")
	ls_voyage_nr = dw_kpi.GetItemString(ll_count,"voyage_nr")
	if not(ll_vessel_nr) > 0 then CONTINUE
	if len(ls_voyage_nr) > 5 then CONTINUE

	/* obtain the VAS data */
	lstr_vessel_voyage_list[1].vessel_nr = ll_vessel_nr
	lstr_vessel_voyage_list[1].voyage_nr = ls_voyage_nr
	li_return = lu_vas_control.of_master_control( 1,li_key[], lstr_vessel_voyage_list[], 0, dw_vas_report)
	
	/* If VAS failed go to next voyage */
	if li_return = -1 then
		dw_kpi.SetItem(ll_count,"vas_status","Missing data")
		CONTINUE
	end if

	/* load values required from VAS into KPI datawindow */
	dw_kpi.SetItem(ll_count,"act_result_prior_drc",dw_vas_report.GetItemDecimal(1,"est_act_result_before_drc_tc_pr_day"))
	dw_kpi.SetItem(ll_count,"fix_result_prior_drc",dw_vas_report.GetItemDecimal(1,"fixture_result_before_drc_tc_pr_day"))
	dw_kpi.SetItem(ll_count,"act_total_days",dw_vas_report.GetItemDecimal(1,"est_act_days_total"))
	dw_kpi.SetItem(ll_count,"fix_total_days",dw_vas_report.GetItemDecimal(1,"fixture_days_total"))
	dw_kpi.SetItem(ll_count,"idle_days",dw_vas_report.GetItemDecimal(1,"est_act_days_idle"))
	
	/* calculate days late */
	if isnull(dw_kpi.getitemdatetime(ll_count,"nor"))	or isnull(dw_kpi.getitemdatetime(ll_count,"laycan_end")) then
		ld_days_late = 0.0	
	else
		ld_days_late = (f_datetime2long(dw_kpi.getitemdatetime(ll_count,"nor")) - f_datetime2long(dw_kpi.getitemdatetime(ll_count,"laycan_end")))/86400
	end if	
	if ld_days_late > 0.0 then
		dw_kpi.SetItem(ll_count,"laycan_end_nor_datetime_diff",ld_days_late)
	end if
		
	/* clear voyage data */
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].voyage_nr = ""
	
next

if IsValid(w_progress) then close(w_progress)
destroy lu_vas_control

if lb_stopped then return c#return.NoAction
return ll_number_of_voyages
end function

on w_key_performance_report_charterer.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_4=create st_4
this.cbx_selectall=create cbx_selectall
this.dw_vessellist=create dw_vessellist
this.cbx_onlysummary=create cbx_onlysummary
this.cb_retreive=create cb_retreive
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.dw_kpi=create dw_kpi
this.dp_from=create dp_from
this.dp_to=create dp_to
this.st_from=create st_from
this.st_to=create st_to
this.st_report=create st_report
this.dw_vas_report=create dw_vas_report
this.uo_profitcenter=create uo_profitcenter
this.dw_summary=create dw_summary
this.gb_daterange=create gb_daterange
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.cbx_selectall
this.Control[iCurrent+4]=this.dw_vessellist
this.Control[iCurrent+5]=this.cbx_onlysummary
this.Control[iCurrent+6]=this.cb_retreive
this.Control[iCurrent+7]=this.cb_print
this.Control[iCurrent+8]=this.cb_saveas
this.Control[iCurrent+9]=this.dw_kpi
this.Control[iCurrent+10]=this.dp_from
this.Control[iCurrent+11]=this.dp_to
this.Control[iCurrent+12]=this.st_from
this.Control[iCurrent+13]=this.st_to
this.Control[iCurrent+14]=this.st_report
this.Control[iCurrent+15]=this.dw_vas_report
this.Control[iCurrent+16]=this.uo_profitcenter
this.Control[iCurrent+17]=this.dw_summary
this.Control[iCurrent+18]=this.gb_daterange
this.Control[iCurrent+19]=this.r_1
end on

on w_key_performance_report_charterer.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_4)
destroy(this.cbx_selectall)
destroy(this.dw_vessellist)
destroy(this.cbx_onlysummary)
destroy(this.cb_retreive)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.dw_kpi)
destroy(this.dp_from)
destroy(this.dp_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.st_report)
destroy(this.dw_vas_report)
destroy(this.uo_profitcenter)
destroy(this.dw_summary)
destroy(this.gb_daterange)
destroy(this.r_1)
end on

event open;this.move(0,0)

/* both datawindow containers share data buffer */
dw_kpi.sharedata(dw_summary)
dw_vessellist.setTransObject(SQLCA)
postevent( "ue_postopen")
/* set profit center control to fit our format */
uo_profitcenter.gb_1.visible = false
uo_profitcenter.uf_set_height( 45 )


end event

type st_1 from statictext within w_key_performance_report_charterer
integer x = 59
integer y = 24
integer width = 837
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select Profit Centers to include"
boolean focusrectangle = false
end type

type st_4 from statictext within w_key_performance_report_charterer
integer x = 1225
integer y = 24
integer width = 635
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select vessel to exclude"
boolean focusrectangle = false
end type

type cbx_selectall from checkbox within w_key_performance_report_charterer
integer x = 1989
integer y = 12
integer width = 370
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;if this.checked then
	dw_vessellist.selectRow(0, TRUE)
	this.text = "Deselect all"
	this.textcolor = rgb(255,255,255)

else
	dw_vessellist.selectRow(0, FALSE)
	this.text = "Select all"
	this.textcolor = rgb(255,255,255)
end if
end event

type dw_vessellist from datawindow within w_key_performance_report_charterer
integer x = 1225
integer y = 96
integer width = 1111
integer height = 360
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_vessel_given_profitcenter"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if
end event

type cbx_onlysummary from checkbox within w_key_performance_report_charterer
integer x = 41
integer y = 2340
integer width = 590
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
string text = "show only summary"
end type

event clicked;dw_kpi.visible = not(this.checked)
dw_summary.visible = this.checked
end event

type cb_retreive from mt_u_commandbutton within w_key_performance_report_charterer
integer x = 3511
integer y = 2360
integer taborder = 50
string text = "Retreive"
end type

event clicked;call super::clicked;_retrievereport()
end event

type cb_print from mt_u_commandbutton within w_key_performance_report_charterer
integer x = 4224
integer y = 2360
integer taborder = 60
string text = "&Print"
end type

event clicked;call super::clicked;if cbx_onlysummary.checked then
	dw_summary.Print(false,true)
else
	dw_kpi.Print(false,true)
end if
end event

type cb_saveas from mt_u_commandbutton within w_key_performance_report_charterer
integer x = 3867
integer y = 2360
integer taborder = 70
string text = "&Save As"
end type

event clicked;call super::clicked;string ls_folder_data, ls_path, ls_file 
integer li_rtn

if cbx_onlysummary.checked then
	
	li_rtn = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "TXT", &
   "All Files (*.*),*.*" , "", &
   32770)

	if li_rtn < 1 then return c#return.Failure

	dw_summary.SaveAsAscii(ls_path,";","")
	
else
	dw_kpi.saveas("", XML!, true)
end if

end event

type dw_kpi from mt_u_datawindow within w_key_performance_report_charterer
integer x = 41
integer y = 528
integer width = 4526
integer height = 1800
integer taborder = 80
string dataobject = "d_sq_tb_kpi"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dp_from from mt_u_datepicker within w_key_performance_report_charterer
integer x = 2674
integer y = 96
integer width = 402
integer height = 96
integer taborder = 100
datetime value = DateTime(Date("2014-09-01"), Time("09:46:17.000000"))
integer calendarfontweight = 400
end type

type dp_to from mt_u_datepicker within w_key_performance_report_charterer
integer x = 2674
integer y = 208
integer width = 402
integer height = 96
integer taborder = 10
datetime value = DateTime(Date("2014-09-01"), Time("09:46:17.000000"))
integer calendarfontweight = 400
end type

type st_from from mt_u_statictext within w_key_performance_report_charterer
integer x = 2501
integer y = 112
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type st_to from mt_u_statictext within w_key_performance_report_charterer
integer x = 2501
integer y = 224
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_report from statictext within w_key_performance_report_charterer
integer x = 658
integer y = 2340
integer width = 2715
integer height = 144
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 22628899
long backcolor = 32304364
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_vas_report from datawindow within w_key_performance_report_charterer
boolean visible = false
integer x = 4155
integer y = 2124
integer width = 315
integer height = 200
integer taborder = 20
string title = "none"
string dataobject = "d_vas_report_a4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_profitcenter from u_drag_drop_boxes within w_key_performance_report_charterer
integer x = 37
integer y = 40
integer width = 1152
integer height = 756
integer taborder = 30
long backcolor = 22628899
end type

event constructor;call super::constructor;this.uf_set_frame_label("Profit Centers")
this.uf_setleft_datawindow("d_profit_center_name")
this.uf_setright_datawindow("d_profit_center_name")
this.uf_set_left_dw_width(90)
this.uf_set_right_dw_width(90)
this.uf_set_height(92)




end event

on uo_profitcenter.destroy
call u_drag_drop_boxes::destroy
end on

event ue_dw_changed;call super::ue_dw_changed;integer li_rows, li_counter, li_pcnr[]
datetime ldt_start, ldt_end

ldt_start=datetime("01/01/1900")
ldt_end=datetime("01/01/2200")

li_rows = uo_profitcenter.dw_right.rowcount()
If NOT(li_rows > 0) THEN 
	dw_vessellist.reset( )
	Return
end if	
For li_counter = 1 to li_rows
	li_pcnr[li_counter] = uo_profitcenter.dw_right.GetItemNumber(li_counter,"pc_nr")
Next

dw_vessellist.retrieve(li_pcnr, ldt_start, ldt_end)

//reset select all
cbx_selectall.text = "Select all"
cbx_selectall.checked = false
end event

type dw_summary from mt_u_datawindow within w_key_performance_report_charterer
boolean visible = false
integer x = 41
integer y = 576
integer width = 3209
integer height = 1728
integer taborder = 90
string dataobject = "d_sq_tb_kpi_summary"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type gb_daterange from groupbox within w_key_performance_report_charterer
integer x = 2455
integer y = 20
integer width = 677
integer height = 336
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Date Range"
end type

type r_1 from rectangle within w_key_performance_report_charterer
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4608
integer height = 508
end type

