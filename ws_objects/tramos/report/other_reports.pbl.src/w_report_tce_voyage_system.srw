$PBExportHeader$w_report_tce_voyage_system.srw
$PBExportComments$TCE Voyage System - (menu: report.tce voyage system)
forward
global type w_report_tce_voyage_system from window
end type
type st_4 from statictext within w_report_tce_voyage_system
end type
type st_3 from statictext within w_report_tce_voyage_system
end type
type dw_idle from datawindow within w_report_tce_voyage_system
end type
type dw_offhire from datawindow within w_report_tce_voyage_system
end type
type cb_close from commandbutton within w_report_tce_voyage_system
end type
type cb_saveas from commandbutton within w_report_tce_voyage_system
end type
type cb_print from commandbutton within w_report_tce_voyage_system
end type
type dw_tce_report from datawindow within w_report_tce_voyage_system
end type
type dw_vas_report from datawindow within w_report_tce_voyage_system
end type
type cb_create from commandbutton within w_report_tce_voyage_system
end type
type dw_select from datawindow within w_report_tce_voyage_system
end type
type st_2 from statictext within w_report_tce_voyage_system
end type
type st_1 from statictext within w_report_tce_voyage_system
end type
type dw_enddate from datawindow within w_report_tce_voyage_system
end type
type dw_startdate from datawindow within w_report_tce_voyage_system
end type
type rb_pool from radiobutton within w_report_tce_voyage_system
end type
type rb_profitcenter from radiobutton within w_report_tce_voyage_system
end type
type gb_1 from groupbox within w_report_tce_voyage_system
end type
end forward

global type w_report_tce_voyage_system from window
integer width = 3918
integer height = 2508
boolean titlebar = true
string title = "TCE Voyage System"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_4 st_4
st_3 st_3
dw_idle dw_idle
dw_offhire dw_offhire
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
dw_tce_report dw_tce_report
dw_vas_report dw_vas_report
cb_create cb_create
dw_select dw_select
st_2 st_2
st_1 st_1
dw_enddate dw_enddate
dw_startdate dw_startdate
rb_pool rb_pool
rb_profitcenter rb_profitcenter
gb_1 gb_1
end type
global w_report_tce_voyage_system w_report_tce_voyage_system

type variables

end variables

forward prototypes
public subroutine uf_insert_extra_days (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_report, datetime adt_start, datetime adt_end, datetime adt_voyage_start, datetime adt_voyage_end, string as_vessel_name)
public subroutine uf_get_idle_days (integer ai_vessel_nr, ref datawindow adt_idle_days, datetime adt_start, datetime adt_end, string as_vessel_ref_nr)
public subroutine uf_get_offhire_days (integer ai_vessel_nr, ref datawindow adt_offhire_days, datetime adt_start, datetime adt_end, string as_vessel_ref_nr)
end prototypes

public subroutine uf_insert_extra_days (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_report, datetime adt_start, datetime adt_end, datetime adt_voyage_start, datetime adt_voyage_end, string as_vessel_name);long ll_tce_row, ll_rowcount, ll_found, ll_rows
decimal ld_sum_offhire, ld_sum_idle, ld_sum_revenu, ld_days, ld_report_days, ld_remaining_report_days
datetime ldt_voyage_end, ldt_today

DataStore lds_extra_voyage_vessel
lds_extra_voyage_vessel = Create datastore

lds_extra_voyage_vessel.dataObject = "d_tce_vessel_voyage_extra"
lds_extra_voyage_vessel.setTransObject(SQLCA)

DataStore lds_offhire_vessel
lds_offhire_vessel = Create datastore

lds_offhire_vessel.dataObject = "d_tce_vessel_voyage_extra_offhire"
lds_offhire_vessel.setTransObject(SQLCA)

lds_extra_voyage_vessel.retrieve(ai_vessel_nr)

ll_rowcount = lds_extra_voyage_vessel.RowCount()
ll_found = lds_extra_voyage_vessel.find("voyages_voyage_nr='"+as_voyage_nr+"'",1,ll_rowcount)
IF ll_found < ll_rowcount AND ll_found > 0 THEN
	as_voyage_nr = lds_extra_voyage_vessel.getItemString(ll_found + 1, "voyages_voyage_nr")
	IF lds_extra_voyage_vessel.getItemNumber(ll_found + 1, "voyages_voyage_finished") = 0 AND IsNull(lds_extra_voyage_vessel.getItemNumber(ll_found + 1, "voyages_cal_calc_id")) AND lds_extra_voyage_vessel.getItemNumber(ll_found + 1, "voyages_voyage_type")=1 THEN
		lds_offhire_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)
		IF lds_offhire_vessel.Rowcount() > 0 THEN
			ld_sum_offhire = lds_offhire_vessel.GetItemNumber(1,"sum_all")
		ELSE
			ld_sum_offhire = 0
		END IF

		DataStore lds_idle_vessel
		lds_idle_vessel = Create datastore

		lds_idle_vessel.dataObject = "d_tce_vessel_voyage_extra_idle"
		lds_idle_vessel.setTransObject(SQLCA)
		lds_idle_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)

		IF lds_idle_vessel.Rowcount() > 0 THEN
			ld_sum_idle = lds_idle_vessel.GetItemNumber(1,"sum_all")
		ELSE
			ld_sum_idle = 0
		END IF
		ldt_voyage_end = lds_extra_voyage_vessel.getItemDateTime(ll_found + 1, "voyages_est_voyage_end")
	   IF adt_voyage_start > adt_end THEN
			ld_sum_revenu = 0
		ELSE
			IF Not IsNull(ldt_voyage_end) THEN
				IF ldt_voyage_end > adt_end THEN
					ld_sum_revenu = (f_timedifference(adt_voyage_start,adt_end)/1440) - ld_sum_idle - ld_sum_offhire
				ELSE
					ld_sum_revenu = (f_timedifference(adt_voyage_start,ldt_voyage_end)/1440) - ld_sum_idle - ld_sum_offhire
				END IF
			ELSE
				ld_sum_revenu = 0
			END IF
		END IF
	ll_tce_row = adw_report.InsertRow(0)
	adw_report.setItem(ll_tce_row, "vessel_nr", ai_vessel_nr)
	adw_report.setItem(ll_tce_row, "vessel_name", as_vessel_name)
	adw_report.setItem(ll_tce_row, "voyage_nr", as_voyage_nr)
	adw_report.setItem(ll_tce_row, "startdate", adt_voyage_start)			
	adw_report.setItem(ll_tce_row, "enddate", adt_voyage_end)			
	adw_report.setItem(ll_tce_row, "report_start", adt_start)			
	adw_report.setItem(ll_tce_row, "report_end", adt_end)			
	adw_report.setItem(ll_tce_row, "result", 0)			
	adw_report.setItem(ll_tce_row, "revenue_days", ld_sum_revenu)
	adw_report.setItem(ll_tce_row, "revenue_days_ny", ld_sum_revenu)			

	adw_report.setItem(ll_tce_row, "idle_days",ld_sum_idle)			
	adw_report.setItem(ll_tce_row, "offhire_days",ld_sum_offhire)			
	END IF
ELSE
	
END IF

ll_rows = adw_report.rowcount()

IF ll_rows > 0 then
	ld_days = adw_report.GetItemNumber(ll_rows,"total_days") + adw_report.GetItemNumber(ll_rows,"total_idle_days") + adw_report.GetItemNumber(ll_rows,"total_offhire_days")
	ld_report_days = timedifference( adt_start, adt_end  ) / 1440 
	ldt_today = datetime(Today())
	
	IF ldt_today < adt_start THEN
		ldt_today = adt_start
	END IF
	
	IF ldt_today > adt_end THEN
		ldt_today = adt_end
	END IF
	
	ld_remaining_report_days = timedifference(ldt_today,adt_end) / 1440
	IF ai_vessel_nr = 921 THEN
		ll_rows = ll_rows
	END IF
	IF ld_remaining_report_days <= ld_report_days - ld_days THEN
		ll_tce_row = adw_report.InsertRow(0)
		adw_report.setItem(ll_tce_row, "vessel_nr", ai_vessel_nr)
		adw_report.setItem(ll_tce_row, "vessel_name", as_vessel_name)
		adw_report.setItem(ll_tce_row, "voyage_nr", as_voyage_nr)
		adw_report.setItem(ll_tce_row, "startdate", adt_voyage_start)			
		adw_report.setItem(ll_tce_row, "enddate", adt_voyage_end)			
		adw_report.setItem(ll_tce_row, "report_start", adt_start)			
		adw_report.setItem(ll_tce_row, "report_end", adt_end)			
		adw_report.setItem(ll_tce_row, "result", 0)			
		adw_report.setItem(ll_tce_row, "revenue_days", 0)
		adw_report.setItem(ll_tce_row, "revenue_days_ny", 0)	
		adw_report.setItem(ll_tce_row, "idle_days",(ld_report_days - ld_days) - ld_remaining_report_days)			
		adw_report.setItem(ll_tce_row, "offhire_days",0)			
	END IF
END IF

destroy lds_extra_voyage_vessel
destroy lds_offhire_vessel 
destroy lds_idle_vessel 
end subroutine

public subroutine uf_get_idle_days (integer ai_vessel_nr, ref datawindow adt_idle_days, datetime adt_start, datetime adt_end, string as_vessel_ref_nr);LONG ll_counter_idle, ll_row
DataStore lds_idle_vessel
lds_idle_vessel = Create datastore

lds_idle_vessel.dataObject = "d_tce_vessel_voyage_extra_idle"
lds_idle_vessel.setTransObject(SQLCA)
lds_idle_vessel.Retrieve(ai_vessel_nr,"%", adt_start, adt_end)

IF lds_idle_vessel.Rowcount() > 0 THEN
			FOR ll_counter_idle = 1 TO lds_idle_vessel.RowCount()
				ll_row = adt_idle_days.InsertRow(0)
				adt_idle_days.setItem(ll_row, "vessel_nr", as_vessel_ref_nr)
				adt_idle_days.setItem(ll_row, "vessel_name", lds_idle_vessel.GetItemString(ll_counter_idle, "vessels_vessel_name"))
				adt_idle_days.setItem(ll_row, "startdate", string(lds_idle_vessel.GetItemDateTime(ll_counter_idle, "idle_start"),"DD MMMM YYYY HH:MM:SS"))
				adt_idle_days.setItem(ll_row, "enddate", string(lds_idle_vessel.GetItemDateTime(ll_counter_idle, "idle_end"),"DD MMMM YYYY HH:MM:SS"))
				adt_idle_days.setItem(ll_row, "port", lds_idle_vessel.GetItemString(ll_counter_idle, "ports_port_n"))
				//adt_idle_days.setItem(ll_tce_row, "remarks", lds_idle_vesselGetItemString(ll_counter_offhire, "off_services_off_description"))
			NEXT
END IF

DESTROY lds_idle_vessel

end subroutine

public subroutine uf_get_offhire_days (integer ai_vessel_nr, ref datawindow adt_offhire_days, datetime adt_start, datetime adt_end, string as_vessel_ref_nr);LONG ll_counter_offhire, ll_row
DataStore lds_offhire_vessel
lds_offhire_vessel = Create datastore

lds_offhire_vessel.dataObject = "d_tce_vessel_voyage_extra_offhire"
lds_offhire_vessel.setTransObject(SQLCA)
lds_offhire_vessel.Retrieve(ai_vessel_nr,"%", adt_start, adt_end)

IF lds_offhire_vessel.Rowcount() > 0 THEN
	FOR ll_counter_offhire = 1 TO lds_offhire_vessel.RowCount()
				ll_row = adt_offhire_days.InsertRow(0)
				adt_offhire_days.setItem(ll_row, "vessel_nr", as_vessel_ref_nr)
				adt_offhire_days.setItem(ll_row, "vessel_name", lds_offhire_vessel.GetItemString(ll_counter_offhire, "vessels_vessel_name"))
				adt_offhire_days.setItem(ll_row, "startdate", string(lds_offhire_vessel.GetItemDateTime(ll_counter_offhire, "off_start"),"DD MMMM YYYY HH:MM:SS"))
				adt_offhire_days.setItem(ll_row, "enddate", string(lds_offhire_vessel.GetItemDateTime(ll_counter_offhire, "off_end"),"DD MMMM YYYY HH:MM:SS"))
				adt_offhire_days.setItem(ll_row, "port", lds_offhire_vessel.GetItemString(ll_counter_offhire, "ports_port_n"))
				adt_offhire_days.setItem(ll_row, "remarks", lds_offhire_vessel.GetItemString(ll_counter_offhire, "off_services_off_description"))
			NEXT
END IF

DESTROY lds_offhire_vessel
end subroutine

on w_report_tce_voyage_system.create
this.st_4=create st_4
this.st_3=create st_3
this.dw_idle=create dw_idle
this.dw_offhire=create dw_offhire
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.dw_tce_report=create dw_tce_report
this.dw_vas_report=create dw_vas_report
this.cb_create=create cb_create
this.dw_select=create dw_select
this.st_2=create st_2
this.st_1=create st_1
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.rb_pool=create rb_pool
this.rb_profitcenter=create rb_profitcenter
this.gb_1=create gb_1
this.Control[]={this.st_4,&
this.st_3,&
this.dw_idle,&
this.dw_offhire,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.dw_tce_report,&
this.dw_vas_report,&
this.cb_create,&
this.dw_select,&
this.st_2,&
this.st_1,&
this.dw_enddate,&
this.dw_startdate,&
this.rb_pool,&
this.rb_profitcenter,&
this.gb_1}
end on

on w_report_tce_voyage_system.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_idle)
destroy(this.dw_offhire)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.dw_tce_report)
destroy(this.dw_vas_report)
destroy(this.cb_create)
destroy(this.dw_select)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.rb_pool)
destroy(this.rb_profitcenter)
destroy(this.gb_1)
end on

event open;this.move(0,0)

rb_profitcenter.checked = true
dw_select.setTransObject(SQLCA)
dw_select.retrieve(uo_global.is_userid)

dw_startdate.insertRow(0)
dw_enddate.insertRow(0)

end event

type st_4 from statictext within w_report_tce_voyage_system
integer x = 73
integer y = 1828
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Idle details"
boolean focusrectangle = false
end type

type st_3 from statictext within w_report_tce_voyage_system
integer x = 69
integer y = 1276
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Offhire details"
boolean focusrectangle = false
end type

type dw_idle from datawindow within w_report_tce_voyage_system
integer x = 69
integer y = 1900
integer width = 3808
integer height = 500
integer taborder = 110
string title = "none"
string dataobject = "d_tce_voyage_system_idle_offhire"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_offhire from datawindow within w_report_tce_voyage_system
integer x = 59
integer y = 1360
integer width = 3813
integer height = 428
integer taborder = 100
string title = "none"
string dataobject = "d_tce_voyage_system_idle_offhire"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_report_tce_voyage_system
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

type cb_saveas from commandbutton within w_report_tce_voyage_system
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

event clicked;string ls_docname, ls_named
integer li_value
li_value = GetFileSaveName("Select File", ls_docname, ls_named, "DOC", "CSV Files (*.CSV),*.CSV")

IF li_value = 1 THEN		
	dw_tce_report.saveas(ls_docname, CSV!, FALSE)
	dw_idle.saveas(replace(ls_docname, len(ls_docname)-3, 0,"idle"), CSV!, FALSE)
	dw_offhire.saveas(replace(ls_docname, len(ls_docname)-3,0,"offhire"), CSV!, FALSE)
END IF
end event

type cb_print from commandbutton within w_report_tce_voyage_system
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

type dw_tce_report from datawindow within w_report_tce_voyage_system
integer x = 55
integer y = 528
integer width = 3822
integer height = 712
integer taborder = 90
string title = "none"
string dataobject = "d_tce_voyage_system"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vas_report from datawindow within w_report_tce_voyage_system
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

type cb_create from commandbutton within w_report_tce_voyage_system
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
n_ds							lds_working, lds_charterer, lds_grade, lds_port_rotation
long 							ll_counter, ll_voyages, ll_tce_row, ll_start_pos, ll_counter_charterer, ll_counter_grade, ll_counter_port_rotation, ll_counter_offhire, ll_counter_idle
Integer 						li_year, li_key[], li_control_return
s_vessel_voyage_list 	lstr_vessel_voyage_list[]
u_vas_control 				lu_vas_control
integer						li_empty[]
integer						li_selected[]
integer						li_vessels[]
datetime						ldt_start, ldt_end, ldt_next_open
str_progress 				lstr_parm
string						ls_hline2, ls_next_open
decimal {2}					ld_revenue_days, ld_idle_days, ld_offhire_days
integer						li_current_vessel
string						ls_voyage_nr_tmp, ls_voyage_nr_tmp2, ls_vessel_name_tmp, ls_charterers, ls_grade, ls_port_rotation, ls_port_rotation_tmp
integer						li_vessel_nr_tmp, li_vessel_nr_tmp2
datetime						ldt_voyage_start, ldt_voyage_end
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

/* Retrieve vessels and assign to array for input to getting vessel and voyages */
ldt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end = datetime(dw_enddate.getItemDate(1, "date_value"))


lds_working = create n_ds
if rb_profitcenter.checked then
	lds_working.dataObject = "d_tce_pc_vessels"
else
	lds_working.dataObject = "d_tce_pool_vessels"
end if
lds_working.setTransObject(SQLCA)

if rb_profitcenter.checked then
	if lds_working.retrieve(li_selected) = 0 then
		MessageBox("Information", "No vessels attached to Profitcenter")
		return
	end if
else
	if lds_working.retrieve(li_selected, ldt_start, ldt_end) = 0 then
		MessageBox("Information", "No vessels attached to Pool")
		return
	end if
end if

for ll_counter = 1 to lds_working.rowCount()
	li_vessels[upperBound(li_vessels)+1]=lds_working.getItemNumber(ll_counter, "vessel_nr")
next

/* Get voyages */
lds_working.dataObject = "d_tce_vessel_voyage"
lds_working.setTransObject(SQLCA)
if lds_working.retrieve(ldt_start, ldt_end, li_vessels) = 0 then
	MessageBox("Information", "No voyages found")
	return
end if

ll_voyages = lds_working.rowCount()

/* gennemløb alle rejser for at sætte startdato */
datetime  ldt_null; setNull(ldt_null)
for ll_counter = 1 to ll_voyages
	if ll_counter = 1 then
		lds_working.setItem(1, "start", ldt_null)
		continue
	else
		if lds_working.getItemNumber(ll_counter, "vessel_nr") = &
			lds_working.getItemNumber(ll_counter - 1, "vessel_nr") then
			lds_working.setItem(ll_counter, "start", lds_working.getItemDatetime(ll_counter - 1, "dept_dt"))
		else
			lds_working.setItem(ll_counter, "start", ldt_null)
		end if
	end if
next	
//f_datastore_spy(lds_working)

lds_working.sort()
lds_working.setFilter("start <= enddate or isnull(start)")
lds_working.filter()

ll_voyages = lds_working.rowCount()
/* SLUT gennemgang */

/* If the vessel has a voyage then remove the EXTRA voyage */

for ll_counter = ll_voyages to 1 STEP -1
	IF lds_working.getItemString(ll_counter, "voyage_nr") = "EXTRA" AND ll_counter > 1 THEN
			lds_working.deleterow(ll_counter)
	ELSE

	IF lds_working.getItemNumber(ll_counter, "test_duplicate") = 1 THEN
		lds_working.deleterow(ll_counter)
	END IF
	
	END IF
next	

lds_charterer = create n_ds
lds_charterer.dataObject = "d_tce_vessel_voyage_charterer"
lds_charterer.setTransObject(SQLCA)

lds_grade = create n_ds
lds_grade.dataObject = "d_tce_vessel_voyage_grade"
lds_grade.setTransObject(SQLCA)

lds_port_rotation = create n_ds
lds_port_rotation.dataObject = "d_tce_vessel_voyage_port_rotation"
lds_port_rotation.setTransObject(SQLCA)

//f_datastore_spy(lds_working)
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
dw_idle.reset()
dw_offhire.reset()
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
	li_vessel_nr_tmp = lstr_vessel_voyage_list[1].vessel_nr
	lstr_vessel_voyage_list[1].voyage_nr = lds_working.getItemString(ll_counter, "voyage_nr")
	ls_voyage_nr_tmp = lstr_vessel_voyage_list[1].voyage_nr
	
	/* When the Vessel changes then see if the previous vessel has any extra idle / offhire days */

	IF li_vessel_nr_tmp <> li_vessel_nr_tmp2 AND li_vessel_nr_tmp2 <> 0 THEN
			uf_get_offhire_days(li_vessel_nr_tmp2, dw_offhire, ldt_start, ldt_end, lds_working.getItemString(ll_counter, "vessel_ref_nr"))
			uf_get_idle_days(li_vessel_nr_tmp2, dw_idle, ldt_start, ldt_end, lds_working.getItemString(ll_counter, "vessel_ref_nr"))
	END IF
	
	ls_vessel_name_tmp = lds_working.getItemString(ll_counter, "vessel_name")
	li_vessel_nr_tmp2 = li_vessel_nr_tmp
	ls_voyage_nr_tmp2 = lstr_vessel_voyage_list[1].voyage_nr
	
	li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))

	/* Progress bar */
	if isValid(w_progress) then
		w_progress.wf_progress(ll_counter/ll_voyages, "Calculating vessel #"+lds_working.getItemString(ll_counter, "vessel_ref_nr")+" voyage #"+lstr_vessel_voyage_list[1].voyage_nr+" ...")
	end if
	dw_vas_report.reset()
	
	li_control_return = lu_vas_control.of_master_control( 10, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_report)
	
	if dw_vas_report.RowCount() > 0 then
		if (dw_vas_report.getItemDatetime(1, "voyage_startdate") < ldt_start AND &
			(dw_vas_report.getItemDatetime(1, "voyage_enddate") < ldt_start)) OR &
			(dw_vas_report.getItemDatetime(1, "voyage_startdate") > ldt_end AND &
			(dw_vas_report.getItemDatetime(1, "voyage_enddate") > ldt_end)) then
			// disse rejser skal ikke med
		else
			ll_tce_row = dw_tce_report.InsertRow(0)
			dw_tce_report.setItem(ll_tce_row, "vessel_nr", lds_working.getItemString(ll_counter, "vessel_ref_nr"))
			dw_tce_report.setItem(ll_tce_row, "vessel_name", lds_working.getItemString(ll_counter, "vessel_name"))
			IF lds_working.getItemNumber(ll_counter, "voyages_voyage_type") = 2 THEN
				dw_tce_report.setItem(ll_tce_row, "tc_hire", "TRUE")
			ELSE
				dw_tce_report.setItem(ll_tce_row, "tc_hire", "FALSE")
			END IF
			lds_charterer.retrieve(lds_working.getItemNumber(ll_counter, "voyages_cal_calc_id")) 
			ls_charterers = ""
			FOR ll_counter_charterer = 1 TO lds_charterer.RowCount()
				IF ls_charterers <> "" THEN
					ls_charterers += "/" + lds_charterer.GetItemString(ll_counter_charterer,"chart_chart_n_1")
				ELSE
					ls_charterers = lds_charterer.GetItemString(ll_counter_charterer,"chart_chart_n_1")
				END IF
			NEXT
			lds_charterer.Reset()

			lds_grade.retrieve(li_vessel_nr_tmp, ls_voyage_nr_tmp) 
			ls_grade = ""
			FOR ll_counter_grade = 1 TO lds_grade.RowCount()
				IF ls_grade <> "" THEN
					ls_grade += "/" + lds_grade.GetItemString(ll_counter_grade,"grade_name")
				ELSE
					ls_grade = lds_grade.GetItemString(ll_counter_grade,"grade_name")
				END IF
			NEXT
			lds_grade.Reset()


			lds_port_rotation.retrieve(lds_working.getItemNumber(ll_counter, "voyages_cal_calc_id")) 
			ls_port_rotation = ""
			FOR ll_counter_port_rotation = 1 TO lds_port_rotation.RowCount()
				IF ls_port_rotation <> "" THEN
					IF ls_port_rotation_tmp <> lds_port_rotation.GetItemString(ll_counter_port_rotation,"cal_caio_port_code") THEN
						ls_port_rotation += "/" + lds_port_rotation.GetItemString(ll_counter_port_rotation,"ports_port_n")
						ls_port_rotation_tmp = lds_port_rotation.GetItemString(ll_counter_port_rotation,"cal_caio_port_code")
					END IF
				ELSE
					ls_port_rotation = lds_port_rotation.GetItemString(ll_counter_port_rotation,"ports_port_n")
					ls_port_rotation_tmp = lds_port_rotation.GetItemString(ll_counter_port_rotation,"cal_caio_port_code")
				END IF
			NEXT
			lds_port_rotation.Reset()
				
			dw_tce_report.setItem(ll_tce_row, "voyage_nr", lstr_vessel_voyage_list[1].voyage_nr)
			dw_tce_report.setItem(ll_tce_row, "startdate", string(dw_vas_report.getItemDatetime(1, "voyage_startdate"),"DD MMMM YYYY HH:MM:SS"))			
			dw_tce_report.setItem(ll_tce_row, "enddate", string(dw_vas_report.getItemDatetime(1, "voyage_enddate"),"DD MMMM YYYY HH:MM:SS"))			
			dw_tce_report.setItem(ll_tce_row, "tc_day", round(dw_vas_report.getItemNumber(1, "est_act_result_before_drc_tc_pr_day"),0))			
			dw_tce_report.setItem(ll_tce_row, "charterer", ls_charterers)
			dw_tce_report.setItem(ll_tce_row, "commodity", ls_grade)
			dw_tce_report.setItem(ll_tce_row, "port", ls_port_rotation)
		end if
		
	end if

	IF dw_vas_report.RowCount() > 0 then
		ldt_voyage_end = dw_vas_report.getItemDatetime(1, "voyage_enddate")
	END IF
	
	// If this is the last vessels then see if it has any extra idle/offhire days
	
	IF ll_counter = ll_voyages THEN
		uf_get_offhire_days(li_vessel_nr_tmp2, dw_offhire, ldt_start, ldt_end, lds_working.getItemString(ll_counter, "vessel_ref_nr"))
		uf_get_idle_days(li_vessel_nr_tmp2, dw_idle, ldt_start, ldt_end, lds_working.getItemString(ll_counter, "vessel_ref_nr"))
	END IF	
next
DESTROY lu_vas_control

DESTROY lds_charterer

dw_tce_report.sort()
dw_tce_report.groupcalc()
/* Closes progress window */
if isValid(w_progress) then close(w_progress)


end event

type dw_select from datawindow within w_report_tce_voyage_system
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

type st_2 from statictext within w_report_tce_voyage_system
integer x = 1225
integer y = 260
integer width = 224
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enddate:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_report_tce_voyage_system
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
string text = "Startdate:"
boolean focusrectangle = false
end type

type dw_enddate from datawindow within w_report_tce_voyage_system
integer x = 1467
integer y = 248
integer width = 306
integer height = 88
integer taborder = 40
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_startdate from datawindow within w_report_tce_voyage_system
integer x = 1467
integer y = 144
integer width = 306
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_pool from radiobutton within w_report_tce_voyage_system
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
boolean enabled = false
string text = "Pool"
end type

event clicked;dw_select.dataobject = "d_tce_pool"
dw_select.setTransObject(SQLCA)
dw_select.retrieve()
end event

type rb_profitcenter from radiobutton within w_report_tce_voyage_system
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

type gb_1 from groupbox within w_report_tce_voyage_system
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

