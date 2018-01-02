$PBExportHeader$w_report_tce_result.srw
$PBExportComments$TCE Report - (menu: report.tce report)
forward
global type w_report_tce_result from window
end type
type cb_close from commandbutton within w_report_tce_result
end type
type cb_saveas from commandbutton within w_report_tce_result
end type
type cb_print from commandbutton within w_report_tce_result
end type
type dw_tce_report from datawindow within w_report_tce_result
end type
type dw_vas_report from datawindow within w_report_tce_result
end type
type cb_create from commandbutton within w_report_tce_result
end type
type dw_select from datawindow within w_report_tce_result
end type
type st_2 from statictext within w_report_tce_result
end type
type st_1 from statictext within w_report_tce_result
end type
type dw_enddate from datawindow within w_report_tce_result
end type
type dw_startdate from datawindow within w_report_tce_result
end type
type rb_pool from radiobutton within w_report_tce_result
end type
type rb_profitcenter from radiobutton within w_report_tce_result
end type
type gb_1 from groupbox within w_report_tce_result
end type
end forward

global type w_report_tce_result from window
integer width = 4009
integer height = 2548
boolean titlebar = true
string title = "TCE Result"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
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
global w_report_tce_result w_report_tce_result

type variables

end variables

forward prototypes
public function decimal uf_get_offhire_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
public function decimal uf_get_idle_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
public subroutine uf_insert_extra_days (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_report, datetime adt_start, datetime adt_end, datetime adt_voyage_start, datetime adt_voyage_end, string as_vessel_name, boolean ab_pool, string as_vessel_ref_nr)
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

public subroutine uf_insert_extra_days (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_report, datetime adt_start, datetime adt_end, datetime adt_voyage_start, datetime adt_voyage_end, string as_vessel_name, boolean ab_pool, string as_vessel_ref_nr);long ll_tce_row, ll_rowcount, ll_found, ll_rows
decimal ld_sum_offhire, ld_sum_idle, ld_sum_revenu, ld_days, ld_report_days, ld_remaining_report_days
datetime ldt_voyage_end, ldt_today
DataStore lds_pool_start_end

DataStore lds_extra_voyage_vessel
lds_extra_voyage_vessel = Create datastore

lds_extra_voyage_vessel.dataObject = "d_tce_vessel_voyage_extra"
lds_extra_voyage_vessel.setTransObject(SQLCA)

DataStore lds_offhire_vessel
lds_offhire_vessel = Create datastore

lds_offhire_vessel.dataObject = "d_tce_vessel_voyage_extra_offhire"
lds_offhire_vessel.setTransObject(SQLCA)

lds_extra_voyage_vessel.retrieve(ai_vessel_nr)


lds_pool_start_end = Create datastore

lds_pool_start_end.dataObject = "d_tce_pool_vessels_start_end"
lds_pool_start_end.setTransObject(SQLCA)
IF ab_pool = TRUE THEN
	lds_pool_start_end.retrieve(ai_vessel_nr)
END IF

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
	adw_report.setItem(ll_tce_row, "vessel_nr", as_vessel_ref_nr)
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

IF ll_rows >= 0 then
	IF ll_rows = 0 THEN
		ld_days = 0
	ELSE	
		IF adw_report.GetItemString(ll_rows,"vessel_nr") <> as_vessel_ref_nr THEN
			ld_days = 0
		ELSE
			ld_days = adw_report.GetItemNumber(ll_rows,"total_days") + adw_report.GetItemNumber(ll_rows,"total_idle_days") + adw_report.GetItemNumber(ll_rows,"total_offhire_days")
		END IF
	END IF
	
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
	
   IF	ab_pool = true THEN
		IF lds_pool_start_end.GetItemDateTime(1,"end_dt") <= adt_end Then
			IF lds_pool_start_end.GetItemDateTime(1,"start_dt") > adt_start THEN
				ld_report_days = timedifference(lds_pool_start_end.GetItemDateTime(1,"start_dt"),lds_pool_start_end.GetItemDateTime(1,"end_dt")) / 1440
			ELSE
				ld_report_days = timedifference(adt_start,lds_pool_start_end.GetItemDateTime(1,"end_dt")) / 1440
			END IF
			
			IF lds_pool_start_end.GetItemDateTime(1,"end_dt") <= ldt_today THEN
				ld_remaining_report_days = 0
			ELSE
				ld_remaining_report_days = timedifference(ldt_today,lds_pool_start_end.GetItemDateTime(1,"end_dt")) / 1440
			END IF
			IF ai_vessel_nr = 808 THEN
			//	Messagebox("hej", "Report Days: " + string(ld_report_days) + " Remaining Days: " + string(ld_remaining_report_days))
			END IF
		END IF
		
		IF lds_pool_start_end.GetItemDateTime(1,"start_dt") >= adt_start Then
			IF lds_pool_start_end.GetItemDateTime(1,"end_dt") < adt_end Then
				ld_report_days = timedifference(lds_pool_start_end.GetItemDateTime(1,"start_dt"),lds_pool_start_end.GetItemDateTime(1,"end_dt")) / 1440
			ELSE
				ld_report_days = timedifference(lds_pool_start_end.GetItemDateTime(1,"start_dt"),adt_end) / 1440
			END IF
			
			IF lds_pool_start_end.GetItemDateTime(1,"start_dt") > ldt_today THEN
				IF lds_pool_start_end.GetItemDateTime(1,"end_dt") < adt_end THEN
					ld_remaining_report_days = timedifference(lds_pool_start_end.GetItemDateTime(1,"start_dt"),lds_pool_start_end.GetItemDateTime(1,"end_dt")) / 1440
				ELSE
					ld_remaining_report_days = timedifference(lds_pool_start_end.GetItemDateTime(1,"start_dt"),adt_end) / 1440
				END IF
			END IF	
		END IF
	END IF
	
	IF ld_remaining_report_days <= ld_report_days - ld_days THEN
		ll_tce_row = adw_report.InsertRow(0)
		adw_report.setItem(ll_tce_row, "vessel_nr", as_vessel_ref_nr)
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
		adw_report.setItem(ll_tce_row, "report_days_start_end",ld_report_days)
	ELSE
		ll_tce_row = adw_report.InsertRow(0)
		adw_report.setItem(ll_tce_row, "vessel_nr", as_vessel_ref_nr)
		adw_report.setItem(ll_tce_row, "vessel_name", as_vessel_name)
		adw_report.setItem(ll_tce_row, "voyage_nr", as_voyage_nr)
		adw_report.setItem(ll_tce_row, "startdate", adt_voyage_start)			
		adw_report.setItem(ll_tce_row, "enddate", adt_voyage_end)			
		adw_report.setItem(ll_tce_row, "report_start", adt_start)			
		adw_report.setItem(ll_tce_row, "report_end", adt_end)			
		adw_report.setItem(ll_tce_row, "result", 0)			
		adw_report.setItem(ll_tce_row, "revenue_days", 0)
		adw_report.setItem(ll_tce_row, "revenue_days_ny", 0)	
		adw_report.setItem(ll_tce_row, "idle_days",0)			
		adw_report.setItem(ll_tce_row, "offhire_days",0)
		adw_report.setItem(ll_tce_row, "report_days_start_end",ld_report_days)
	END IF
END IF

destroy lds_extra_voyage_vessel
destroy lds_offhire_vessel 
destroy lds_idle_vessel 
destroy lds_pool_start_end
end subroutine

on w_report_tce_result.create
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
this.Control[]={this.cb_close,&
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

on w_report_tce_result.destroy
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

type cb_close from commandbutton within w_report_tce_result
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

type cb_saveas from commandbutton within w_report_tce_result
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

type cb_print from commandbutton within w_report_tce_result
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

type dw_tce_report from datawindow within w_report_tce_result
integer x = 55
integer y = 528
integer width = 3913
integer height = 1904
integer taborder = 90
string title = "none"
string dataobject = "d_tce_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vas_report from datawindow within w_report_tce_result
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

type cb_create from commandbutton within w_report_tce_result
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
n_ds							lds_working
long 							ll_counter, ll_voyages, ll_tce_row
Integer 						li_year, li_key[], li_control_return
s_vessel_voyage_list 	lstr_vessel_voyage_list[]
u_vas_control 				lu_vas_control
integer						li_empty[]
integer						li_selected[]
boolean						lb_pool
integer						li_vessels[]
datetime						ldt_start, ldt_end, ldt_next_open
str_progress 				lstr_parm
string						ls_hline2, ls_next_open
decimal {2}					ld_revenue_days, ld_idle_days, ld_offhire_days
integer						li_current_vessel
string						ls_voyage_nr_tmp, ls_voyage_nr_tmp2, ls_vessel_name_tmp
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

ldt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end = datetime(dw_enddate.getItemDate(1, "date_value"))



/* Retrieve vessels and assign to array for input to getting vessel and voyages */
lds_working = create n_ds
if rb_profitcenter.checked then
	lds_working.dataObject = "d_tce_pc_vessels"
	lb_pool = false
else
	lds_working.dataObject = "d_tce_pool_vessels"
	lb_pool = true
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

//f_datastore_spy(lds_working);return

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
//f_datastore_spy(lds_working);return

for ll_counter = ll_voyages to 1 STEP -1
	IF lds_working.getItemString(ll_counter, "voyage_nr") = "EXTRA" AND ll_counter > 1 THEN
		IF lds_working.getItemNumber(ll_counter, "vessel_nr") = lds_working.getItemNumber(ll_counter - 1, "vessel_nr") THEN
			lds_working.deleterow(ll_counter)
		END IF
	ELSE
	
	IF lds_working.getItemNumber(ll_counter, "test_duplicate") = 1 THEN
		lds_working.deleterow(ll_counter)
	END IF
	
	END IF
next	

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
	li_vessel_nr_tmp = lstr_vessel_voyage_list[1].vessel_nr
	lstr_vessel_voyage_list[1].voyage_nr = lds_working.getItemString(ll_counter, "voyage_nr")
	ls_voyage_nr_tmp = lstr_vessel_voyage_list[1].voyage_nr
	
	/* When the Vessel changes then see if the previous vessel has any extra idle / offhire days */

	IF li_vessel_nr_tmp <> li_vessel_nr_tmp2 AND li_vessel_nr_tmp2 <> 0 THEN
		uf_insert_extra_days(li_vessel_nr_tmp2,ls_voyage_nr_tmp2,dw_tce_report,ldt_start,ldt_end,ldt_voyage_end,ldt_end,ls_vessel_name_tmp,lb_pool,lds_working.getItemString(ll_counter, "vessel_ref_nr"))
	END IF
	
	ls_vessel_name_tmp = lds_working.getItemString(ll_counter, "vessel_name")
	li_vessel_nr_tmp2 = li_vessel_nr_tmp
	ls_voyage_nr_tmp2 = lstr_vessel_voyage_list[1].voyage_nr
	
	li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))
	
	/* get next open position from vessel table */
	if li_current_vessel <> lstr_vessel_voyage_list[1].vessel_nr then
		li_current_vessel = lstr_vessel_voyage_list[1].vessel_nr
		SELECT EST_NEXT_OPEN, NEXT_OPEN_PORT
			INTO :ldt_next_open, :ls_next_open
			FROM VESSELS
			WHERE VESSEL_NR = :li_current_vessel;
	end if

	/* Progress bar */
	if isValid(w_progress) then
		w_progress.wf_progress(ll_counter/ll_voyages, "Calculating vessel #"+lds_working.getItemString(ll_counter, "vessel_ref_nr")+" voyage #"+lstr_vessel_voyage_list[1].voyage_nr+" ...")
	end if
	dw_vas_report.reset()
	
	// If the vessel has a EXTRA voyage in means there is no voyages for the vessel for the specific periode then insert a row with next open position	and idle/offhire days
	
	IF lds_working.getItemString(ll_counter, "voyage_nr") = "EXTRA" THEN  
			ll_tce_row = dw_tce_report.InsertRow(0)
			dw_tce_report.setItem(ll_tce_row, "vessel_nr", lds_working.getItemString(ll_counter, "vessel_ref_nr"))
			dw_tce_report.setItem(ll_tce_row, "vessel_name", lds_working.getItemString(ll_counter, "vessel_name"))
			dw_tce_report.setItem(ll_tce_row, "report_start", ldt_start)			
			dw_tce_report.setItem(ll_tce_row, "report_end", ldt_end)			
			dw_tce_report.setItem(ll_tce_row, "result", 0)			
			dw_tce_report.setItem(ll_tce_row, "revenue_days", 0)			
			ld_offhire_days = uf_get_offhire_days(lstr_vessel_voyage_list[1].vessel_nr,"%",ldt_start,ldt_end)
			ld_idle_days = uf_get_idle_days(lstr_vessel_voyage_list[1].vessel_nr,"%",ldt_start,ldt_end)
			dw_tce_report.setItem(ll_tce_row, "idle_days", ld_idle_days)			
			dw_tce_report.setItem(ll_tce_row, "offhire_days",ld_offhire_days)			
			dw_tce_report.setItem(ll_tce_row, "revenue_days_ny", 0)			
			dw_tce_report.setItem(ll_tce_row, "next_open", ldt_next_open)			
			dw_tce_report.setItem(ll_tce_row, "port", ls_next_open)
	ELSE
		li_control_return = lu_vas_control.of_master_control( 10, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_report)
	END IF	
	
	if dw_vas_report.RowCount() > 0 then
		if (dw_vas_report.getItemDatetime(1, "voyage_startdate") < ldt_start AND &
			(dw_vas_report.getItemDatetime(1, "voyage_enddate") < ldt_start)) OR &
			(dw_vas_report.getItemDatetime(1, "voyage_startdate") > ldt_end AND &
			(dw_vas_report.getItemDatetime(1, "voyage_enddate") > ldt_end)) then
			// disse rejser skal ikke med
		else
			ll_tce_row = dw_tce_report.InsertRow(0)
			dw_tce_report.setItem(ll_tce_row, "vessel_nr", lstr_vessel_voyage_list[1].vessel_nr)
			dw_tce_report.setItem(ll_tce_row, "vessel_name", lds_working.getItemString(ll_counter, "vessel_name"))
			dw_tce_report.setItem(ll_tce_row, "voyage_nr", lstr_vessel_voyage_list[1].voyage_nr)
			dw_tce_report.setItem(ll_tce_row, "startdate", dw_vas_report.getItemDatetime(1, "voyage_startdate"))			
			dw_tce_report.setItem(ll_tce_row, "enddate", dw_vas_report.getItemDatetime(1, "voyage_enddate"))			
			dw_tce_report.setItem(ll_tce_row, "report_start", ldt_start)			
			dw_tce_report.setItem(ll_tce_row, "report_end", ldt_end)			
			dw_tce_report.setItem(ll_tce_row, "result", dw_vas_report.getItemNumber(1, "est_act_result_before_drc_tc"))			
			
			ld_offhire_days = dw_vas_report.getItemNumber(1, "est_act_days_off_service")
			ld_idle_days = dw_vas_report.getItemNumber(1, "est_act_days_idle")
			ld_revenue_days = dw_vas_report.getItemNumber(1, "est_act_days_total") - ld_idle_days - ld_offhire_days
			
			dw_tce_report.setItem(ll_tce_row, "revenue_days", ld_revenue_days)			
			
			//Get the corect offhire and idle days for the specific period
			
			ld_offhire_days = uf_get_offhire_days(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,ldt_start,ldt_end)
			ld_idle_days = uf_get_idle_days(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,ldt_start,ldt_end)
			
			IF dw_vas_report.getItemDatetime(1, "voyage_enddate") > ldt_end THEN
				ldt_voyage_rev_end = ldt_end
			ELSE
				ldt_voyage_rev_end = dw_vas_report.getItemDatetime(1, "voyage_enddate")
			END IF
			IF dw_vas_report.getItemDatetime(1, "voyage_startdate") < ldt_start THEN
				ldt_voyage_rev_start = ldt_start
			ELSE
				ldt_voyage_rev_start = dw_vas_report.getItemDatetime(1, "voyage_startdate")
			END IF

			ld_revenue_days = (f_timedifference(ldt_voyage_rev_start,ldt_voyage_rev_end)/1440) - ld_idle_days - ld_offhire_days
			
			dw_tce_report.setItem(ll_tce_row, "idle_days", ld_idle_days)			
			dw_tce_report.setItem(ll_tce_row, "offhire_days", ld_offhire_days)			
			dw_tce_report.setItem(ll_tce_row, "revenue_days_ny", ld_revenue_days)			

			dw_tce_report.setItem(ll_tce_row, "next_open", ldt_next_open)			
			dw_tce_report.setItem(ll_tce_row, "port", ls_next_open)
		end if
		
	end if

	IF dw_vas_report.RowCount() > 0 then
		ldt_voyage_end = dw_vas_report.getItemDatetime(1, "voyage_enddate")
	END IF
	
	// If this is the last vessels then see if it has any extra idle/offhire days
	
	IF ll_counter = ll_voyages THEN
		uf_insert_extra_days(li_vessel_nr_tmp2,ls_voyage_nr_tmp2,dw_tce_report,ldt_start,ldt_end,ldt_voyage_end,ldt_end,ls_vessel_name_tmp, lb_pool,lds_working.getItemString(ll_counter, "vessel_ref_nr"))
	END IF	
next
DESTROY lu_vas_control

dw_tce_report.sort()
dw_tce_report.groupcalc()
/* Closes progress window */
if isValid(w_progress) then close(w_progress)


end event

type dw_select from datawindow within w_report_tce_result
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

type st_2 from statictext within w_report_tce_result
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

type st_1 from statictext within w_report_tce_result
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

type dw_enddate from datawindow within w_report_tce_result
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

type dw_startdate from datawindow within w_report_tce_result
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

type rb_pool from radiobutton within w_report_tce_result
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

type rb_profitcenter from radiobutton within w_report_tce_result
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

type gb_1 from groupbox within w_report_tce_result
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

