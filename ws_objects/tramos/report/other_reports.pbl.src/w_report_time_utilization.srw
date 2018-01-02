$PBExportHeader$w_report_time_utilization.srw
$PBExportComments$TCE Report - (menu: report.tce report)
forward
global type w_report_time_utilization from window
end type
type em_year from editmask within w_report_time_utilization
end type
type cb_close from commandbutton within w_report_time_utilization
end type
type cb_saveas from commandbutton within w_report_time_utilization
end type
type cb_print from commandbutton within w_report_time_utilization
end type
type dw_tce_report from datawindow within w_report_time_utilization
end type
type dw_vas_report from datawindow within w_report_time_utilization
end type
type cb_create from commandbutton within w_report_time_utilization
end type
type dw_select from datawindow within w_report_time_utilization
end type
type st_1 from statictext within w_report_time_utilization
end type
type rb_pool from radiobutton within w_report_time_utilization
end type
type rb_profitcenter from radiobutton within w_report_time_utilization
end type
type gb_1 from groupbox within w_report_time_utilization
end type
end forward

global type w_report_time_utilization from window
integer width = 3909
integer height = 2544
boolean titlebar = true
string title = "Time Utilisation/Grade"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
em_year em_year
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
dw_tce_report dw_tce_report
dw_vas_report dw_vas_report
cb_create cb_create
dw_select dw_select
st_1 st_1
rb_pool rb_pool
rb_profitcenter rb_profitcenter
gb_1 gb_1
end type
global w_report_time_utilization w_report_time_utilization

type variables

end variables

forward prototypes
public function decimal uf_get_offhire_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
public function decimal uf_get_idle_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
public subroutine documentation ()
end prototypes

public function decimal uf_get_offhire_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end);Decimal ld_offhire_days

DataStore lds_offhire_vessel
lds_offhire_vessel = Create datastore

lds_offhire_vessel.dataObject = "d_tce_vessel_voyage_extra_offhire"
lds_offhire_vessel.setTransObject(SQLCA)
lds_offhire_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)

IF lds_offhire_vessel.Rowcount() > 0 THEN
	ld_offhire_days = lds_offhire_vessel.GetItemNumber(1,"sum_all")
ELSE
	ld_offhire_days = 0
END IF

return ld_offhire_days
end function

public function decimal uf_get_idle_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end);Decimal ld_idle_days

DataStore lds_idle_vessel
lds_idle_vessel = Create datastore

lds_idle_vessel.dataObject = "d_tce_vessel_voyage_extra_idle"
lds_idle_vessel.setTransObject(SQLCA)
lds_idle_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)

IF lds_idle_vessel.Rowcount() > 0 THEN
	ld_idle_days = lds_idle_vessel.GetItemNumber(1,"sum_all")
ELSE
	ld_idle_days = 0
END IF

return ld_idle_days
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

on w_report_time_utilization.create
this.em_year=create em_year
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.dw_tce_report=create dw_tce_report
this.dw_vas_report=create dw_vas_report
this.cb_create=create cb_create
this.dw_select=create dw_select
this.st_1=create st_1
this.rb_pool=create rb_pool
this.rb_profitcenter=create rb_profitcenter
this.gb_1=create gb_1
this.Control[]={this.em_year,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.dw_tce_report,&
this.dw_vas_report,&
this.cb_create,&
this.dw_select,&
this.st_1,&
this.rb_pool,&
this.rb_profitcenter,&
this.gb_1}
end on

on w_report_time_utilization.destroy
destroy(this.em_year)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.dw_tce_report)
destroy(this.dw_vas_report)
destroy(this.cb_create)
destroy(this.dw_select)
destroy(this.st_1)
destroy(this.rb_pool)
destroy(this.rb_profitcenter)
destroy(this.gb_1)
end on

event open;this.move(0,0)

rb_profitcenter.checked = true
dw_select.setTransObject(SQLCA)
dw_select.retrieve(uo_global.is_userid)

//dw_startdate.insertRow(0)
//dw_enddate.insertRow(0)

end event

type em_year from editmask within w_report_time_utilization
integer x = 1449
integer y = 148
integer width = 101
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16776960
string text = "00"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yy"
end type

type cb_close from commandbutton within w_report_time_utilization
integer x = 1883
integer y = 384
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

type cb_saveas from commandbutton within w_report_time_utilization
integer x = 1883
integer y = 264
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_tce_report.saveas()
end event

type cb_print from commandbutton within w_report_time_utilization
integer x = 1883
integer y = 152
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_tce_report.print()
end event

type dw_tce_report from datawindow within w_report_time_utilization
integer x = 55
integer y = 528
integer width = 3822
integer height = 1908
integer taborder = 90
string title = "none"
string dataobject = "d_report_time_utilization"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vas_report from datawindow within w_report_time_utilization
boolean visible = false
integer x = 2318
integer y = 44
integer width = 370
integer height = 408
string title = "none"
string dataobject = "d_vas_report_a4"
boolean resizable = true
boolean livescroll = true
end type

type cb_create from commandbutton within w_report_time_utilization
integer x = 1883
integer y = 32
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Create..."
end type

event clicked;/* Declare local Variables */
n_ds							lds_working, lds_working_grade
long 							ll_counter, ll_counter2, ll_voyages, ll_tce_row, ll_counter_grade
Integer 						li_year, li_key[], li_control_return
s_vessel_voyage_list 	lstr_vessel_voyage_list[]
u_vas_control 				lu_vas_control
integer						li_empty[]
integer						li_selected[]
integer						li_vessels[]
datetime						ldt_start, ldt_end, ldt_next_open
str_progress 				lstr_parm
string						ls_hline2, ls_next_open
decimal {2}					ld_revenue_days, ld_idle_days, ld_offhire_days, ld_voyage_days
integer						li_current_vessel
string						ls_grade
decimal						ld_contract_procent, ld_contract_freight, ld_total_freight
datetime						ldt_voyage_rev_start, ldt_voyage_rev_end

/* First find out if the are any selected pool or profit center */
li_selected = li_empty
for ll_counter = 1 to dw_select.rowCount()
	if dw_select.isSelected(ll_counter) then
		li_selected[upperBound(li_selected)+1]=dw_select.getItemNumber(ll_counter, "pc_nr")
		if len(ls_hline2) = 0 then
			ls_hline2 = dw_select.getItemString(ll_counter, "pc_name")
		else
			ls_hline2 += ", "+dw_select.getItemString(ll_counter, "pc_name")
		end if
	end if
next
if upperBound(li_selected) = 0 then
	MessageBox("Information", "Please select Profitcenter or Pool")
	return
end if

/* Validate dates */

if isnull(em_year) then 
	MessageBox("Information", "Please enter a year for the report")
	return
end if

/* Retrieve vessels and assign to array for input to getting vessel and voyages */
lds_working = create n_ds

lds_working_grade = create n_ds
lds_working_grade.dataObject = "d_tce_vessel_voyage_grade"
lds_working_grade.setTransObject(SQLCA)

if rb_profitcenter.checked then
	lds_working.dataObject = "d_tce_pc_vessels"
else
	lds_working.dataObject = "d_tce_pool_vessels"
end if
lds_working.setTransObject(SQLCA)
if lds_working.retrieve(li_selected) = 0 then
	MessageBox("Information", "No vessels attached to Pool/Profitcenter")
	return
end if
for ll_counter = 1 to lds_working.rowCount()
	li_vessels[upperBound(li_vessels)+1]=lds_working.getItemNumber(ll_counter, "vessel_nr")
next

/* Get voyages */

lds_working.dataObject = "d_time_utilization_vessel_voyage"
lds_working.setTransObject(SQLCA)

if lds_working.retrieve(string(em_year.text), li_vessels) = 0 then
	MessageBox("Information", "No voyages found")
	return
end if

ll_voyages = lds_working.rowCount()

// f_datastore_spy(lds_working)

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Calculating voyages..."
openwithparm(w_progress, lstr_parm, "w_progress_no_cancel")

/* loop through all voyages */
ll_voyages = lds_working.rowCount()
lu_vas_control = CREATE u_vas_control

/* Set Header text line 2 */
dw_tce_report.reset()
if dw_select.dataObject = "d_tce_pool" then
	ls_hline2 = "Pool: "+ls_hline2
else
	ls_hline2 = "Profitcenter: "+ls_hline2
end if
dw_tce_report.Object.t_header_line2.Text = ls_hline2

dw_tce_report.sharedata(dw_tce_report)

li_current_vessel = -1
for ll_counter = 1 to ll_voyages
	lstr_vessel_voyage_list[1].vessel_nr = lds_working.getItemNumber(ll_counter, "vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = lds_working.getItemString(ll_counter, "voyage_nr")
	li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))
	
	/* Progress bar */
	if isValid(w_progress) then
		w_progress.wf_progress(ll_counter/ll_voyages, "Calculating vessel #"+lds_working.getItemString(ll_counter, "vessel_ref_nr")+" voyage #"+lstr_vessel_voyage_list[1].voyage_nr+" ...")
	end if
	dw_vas_report.reset()
	lds_working_grade.reset()

	li_control_return = lu_vas_control.of_master_control( 10, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_report)
	
	if dw_vas_report.RowCount() > 0 then
		lds_working_grade.retrieve(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr)
      ls_grade = ""				
		IF lds_working_grade.Rowcount() >= 1 THEN
		 	FOR ll_counter_grade = 1 TO lds_working_grade.Rowcount()
				IF ll_counter_grade = 1 THEN
					ls_grade = lds_working_grade.getItemString(ll_counter_grade, "grade_name")						
				ELSE
					ls_grade += "/" + lds_working_grade.getItemString(ll_counter_grade, "grade_name")						
				END IF
			NEXT
			ll_tce_row = dw_tce_report.InsertRow(0)
			dw_tce_report.setItem(ll_tce_row, "vessel_nr", lds_working.getItemString(ll_counter, "vessel_ref_nr"))
			dw_tce_report.setItem(ll_tce_row, "vessel_name", lds_working.getItemString(ll_counter, "vessels_vessel_name"))
			dw_tce_report.setItem(ll_tce_row, "voyage_nr", lstr_vessel_voyage_list[1].voyage_nr)
			dw_tce_report.setItem(ll_tce_row, "startdate", dw_vas_report.getItemDatetime(1, "voyage_startdate"))			
			dw_tce_report.setItem(ll_tce_row, "enddate", dw_vas_report.getItemDatetime(1, "voyage_enddate"))			
			dw_tce_report.setItem(ll_tce_row, "result", dw_vas_report.getItemNumber(1, "est_act_result_before_drc_tc"))			
				
			ld_voyage_days = dw_vas_report.getItemNumber(1, "est_act_days_loading") + dw_vas_report.getItemNumber(1, "est_act_days_discharge")
			ld_voyage_days += dw_vas_report.getItemNumber(1, "est_act_days_load_and_disch") + dw_vas_report.getItemNumber(1, "est_act_days_canal")
			ld_voyage_days += dw_vas_report.getItemNumber(1, "est_act_days_loaded")

			dw_tce_report.setItem(ll_tce_row, "ballast_days", dw_vas_report.getItemNumber(1, "est_act_days_ballast"))			
			dw_tce_report.setItem(ll_tce_row, "voyage_days", ld_voyage_days)			
			dw_tce_report.setItem(ll_tce_row, "other_days", dw_vas_report.getItemNumber(1, "est_act_days_other"))			
			dw_tce_report.setItem(ll_tce_row, "bunkering_days", dw_vas_report.getItemNumber(1, "est_act_days_bunkering"))
			dw_tce_report.setItem(ll_tce_row, "freight", dw_vas_report.getItemNumber(1, "est_act_freight"))
			dw_tce_report.setItem(ll_tce_row, "demurrage", dw_vas_report.getItemNumber(1, "est_act_dem_des"))
			dw_tce_report.setItem(ll_tce_row, "broker_commission", dw_vas_report.getItemNumber(1, "est_act_broker_comm"))
			dw_tce_report.setItem(ll_tce_row, "port_expenses", dw_vas_report.getItemNumber(1, "est_act_port_exp"))
			dw_tce_report.setItem(ll_tce_row, "bunker_expenses", dw_vas_report.getItemNumber(1, "est_act_bunk_exp"))
			dw_tce_report.setItem(ll_tce_row, "misc_expenses", dw_vas_report.getItemNumber(1, "est_act_misc_exp"))
			dw_tce_report.setItem(ll_tce_row, "grade", ls_grade)			
			END IF
	end if	
next
dw_tce_report.Sort()
dw_tce_report.GroupCalc()
DESTROY lu_vas_control
DESTROY lds_working_grade
DESTROY lds_working
/* Closes progress window */
if isValid(w_progress) then close(w_progress)


end event

type dw_select from datawindow within w_report_time_utilization
integer x = 521
integer y = 60
integer width = 658
integer height = 372
integer taborder = 20
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if
end event

type st_1 from statictext within w_report_time_utilization
integer x = 1225
integer y = 160
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year:"
boolean focusrectangle = false
end type

type rb_pool from radiobutton within w_report_time_utilization
integer x = 123
integer y = 232
integer width = 178
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pool"
end type

event clicked;dw_select.dataobject = "d_tce_pool"
dw_select.setTransObject(SQLCA)
dw_select.retrieve()
end event

type rb_profitcenter from radiobutton within w_report_time_utilization
integer x = 123
integer y = 160
integer width = 338
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profitcenter"
end type

event clicked;dw_select.dataobject = "d_profit_center"
dw_select.setTransObject(SQLCA)
dw_select.retrieve(uo_global.is_userid)
end event

type gb_1 from groupbox within w_report_time_utilization
integer x = 55
integer y = 8
integer width = 1792
integer height = 468
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selection Criteria..."
end type

