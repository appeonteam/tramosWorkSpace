$PBExportHeader$w_audit_export.srw
$PBExportComments$Export af estimater + actuals til Grothen & Perregaard (Revision)
forward
global type w_audit_export from window
end type
type st_1 from statictext within w_audit_export
end type
type em_year from editmask within w_audit_export
end type
type cb_close from commandbutton within w_audit_export
end type
type cb_saveas from commandbutton within w_audit_export
end type
type cb_print from commandbutton within w_audit_export
end type
type dw_export_report from datawindow within w_audit_export
end type
type dw_vas_report from datawindow within w_audit_export
end type
type cb_create from commandbutton within w_audit_export
end type
type dw_select from datawindow within w_audit_export
end type
type st_2 from statictext within w_audit_export
end type
end forward

global type w_audit_export from window
integer width = 4114
integer height = 2576
boolean titlebar = true
string title = "Audit Export"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_1 st_1
em_year em_year
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
dw_export_report dw_export_report
dw_vas_report dw_vas_report
cb_create cb_create
dw_select dw_select
st_2 st_2
end type
global w_audit_export w_audit_export

type variables

end variables

forward prototypes
public function integer wf_est_itinerary (double ad_calc_id)
public function string wf_act_itinerary (integer ai_vessel, string as_voyage)
public subroutine documentation ()
end prototypes

public function integer wf_est_itinerary (double ad_calc_id);datastore 	lds_data
long 			ll_no_of_rows, ll_teller
string		ls_ballast_port_from, ls_ballast_port_to
string		ls_chart_header, ls_port_header
string		ls_ball_viapoint1, ls_ball_viapoint2, ls_ball_viapoint3  
/* Set Estimated Itinerary */

SELECT CAL_CALC_BALLAST_FROM, CAL_CALC_BALLAST_TO
INTO :ls_ballast_port_from, :ls_ballast_port_to
FROM CAL_CALC
WHERE CAL_CALC_ID = :ad_calc_id;
COMMIT;
lds_data = create datastore
lds_data.dataobject = "d_vas_report_chart"
lds_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_data.retrieve(ad_calc_id)
FOR ll_teller = 1 TO ll_no_of_rows
	ls_chart_header += lds_data.GetItemString(ll_teller,"chart_chart_n_1") + " / "
Next	
DESTROY lds_data
dw_vas_report.SetItem(1,"charterers",ls_chart_header)
ls_chart_header = ""

lds_data = CREATE datastore
lds_data.DataObject = "d_fix_est_port_codes_header"
lds_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_data.Retrieve(ad_calc_id)
COMMIT;
SELECT CAL_BALL_VIA_POINT_1, CAL_BALL_VIA_POINT_2, CAL_BALL_VIA_POINT_3  
	INTO :ls_ball_viapoint1, :ls_ball_viapoint2, :ls_ball_viapoint3  
	FROM CAL_BALL  
	WHERE CAL_CALC_ID = :ad_calc_id   
	ORDER BY CAL_BALL_ID ASC  ;
COMMIT;
lds_data.InsertRow(1)
ll_no_of_rows += 1
lds_data.SetItem(1,"cal_caio_cal_caio_via_point_1", ls_ball_viapoint1)
lds_data.SetItem(1,"cal_caio_cal_caio_via_point_2", ls_ball_viapoint2)
lds_data.SetItem(1,"cal_caio_cal_caio_via_point_3", ls_ball_viapoint3)
FOR ll_teller = 1 TO ll_no_of_rows
	if isnull(ls_ballast_port_from) and ll_teller = 1 then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_from) and ll_teller = 1 then
		ls_port_header += "(" + ls_ballast_port_from + ") "
	end if
	ls_port_header += lds_data.GetItemString(ll_teller,"port_string") + "  "
	if isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
		ls_port_header += "(" + ls_ballast_port_to + ")"
	end if
NEXT
DESTROY lds_data
dw_vas_report.SetItem(1,"est_itinerary",ls_port_header)
ls_port_header = ""

return 1
end function

public function string wf_act_itinerary (integer ai_vessel, string as_voyage);datastore 	lds_data
long 			ll_no_of_rows, ll_teller
string		ls_route

/* Set Actual Itinerary */

lds_data = create datastore
lds_data.dataobject = "d_audit_export_act_itinerary"
lds_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_data.retrieve(ai_vessel, as_voyage)
FOR ll_teller = 1 TO ll_no_of_rows
	ls_route += lds_data.GetItemString(ll_teller,"port_code") + " "
Next	
DESTROY lds_data

return ls_route
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
   	01/09/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_audit_export.create
this.st_1=create st_1
this.em_year=create em_year
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.dw_export_report=create dw_export_report
this.dw_vas_report=create dw_vas_report
this.cb_create=create cb_create
this.dw_select=create dw_select
this.st_2=create st_2
this.Control[]={this.st_1,&
this.em_year,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.dw_export_report,&
this.dw_vas_report,&
this.cb_create,&
this.dw_select,&
this.st_2}
end on

on w_audit_export.destroy
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.dw_export_report)
destroy(this.dw_vas_report)
destroy(this.cb_create)
destroy(this.dw_select)
destroy(this.st_2)
end on

event open;this.move(0,0)

dw_select.dataobject = "d_profit_center"
dw_select.setTransObject(SQLCA)
dw_select.retrieve( uo_global.is_userid )


end event

type st_1 from statictext within w_audit_export
integer x = 306
integer y = 4
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profitcenter:"
boolean focusrectangle = false
end type

type em_year from editmask within w_audit_export
integer x = 1399
integer y = 224
integer width = 165
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16776960
string text = "2004"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_close from commandbutton within w_audit_export
integer x = 1883
integer y = 384
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

type cb_saveas from commandbutton within w_audit_export
integer x = 1883
integer y = 264
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_export_report.saveas()
end event

type cb_print from commandbutton within w_audit_export
integer x = 1883
integer y = 152
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_export_report.print()
end event

type dw_export_report from datawindow within w_audit_export
integer x = 55
integer y = 528
integer width = 4023
integer height = 1936
integer taborder = 80
string title = "none"
string dataobject = "d_audit_export_result"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vas_report from datawindow within w_audit_export
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

type cb_create from commandbutton within w_audit_export
integer x = 1883
integer y = 32
integer width = 343
integer height = 100
integer taborder = 40
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
integer						li_vessels[]
str_progress 				lstr_parm
string						ls_year
datetime						ldt_start
decimal {8}					ld_pool_pct

/* First find out if the are any selected profit center */
li_selected = li_empty
for ll_counter = 1 to dw_select.rowCount()
	if dw_select.isSelected(ll_counter) then
		li_selected[upperBound(li_selected)+1]=dw_select.getItemNumber(ll_counter, "pc_nr")
	end if
next
if upperBound(li_selected) = 0 then
	MessageBox("Information", "Please select Profitcenter or Pool")
	return
end if

/* Validate year */
ls_year = mid(em_year.text,3,2)

/* Get voyages */
lds_working = create n_ds
lds_working.dataObject = "d_audit_export_vessel_voyage"
lds_working.setTransObject(SQLCA)
if lds_working.retrieve(ls_year, li_selected) = 0 then
	MessageBox("Information", "No voyages found")
	return
end if

//f_datastore_spy(lds_working);return 

ll_voyages = lds_working.rowCount()

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Calculating voyages..."
openwithparm(w_progress, lstr_parm, "w_progress_no_cancel")

/* loop through all voyages */
ll_voyages = lds_working.rowCount()
lu_vas_control = CREATE u_vas_control

dw_export_report.reset()

for ll_counter = 1 to ll_voyages
	lstr_vessel_voyage_list[1].vessel_nr = lds_working.getItemNumber(ll_counter, "vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = lds_working.getItemString(ll_counter, "voyage_nr")
	li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))
	
	/* Progress bar */
	if isValid(w_progress) then
		w_progress.wf_progress(ll_counter/ll_voyages, "Calculating vessel #"+lds_working.getItemString(ll_counter, "vessel_ref_nr")+" voyage #"+lstr_vessel_voyage_list[1].voyage_nr+" ...")
	end if
	dw_vas_report.reset()
	
	li_control_return = lu_vas_control.of_master_control( 10, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_report)
	
	if dw_vas_report.RowCount() > 0 then
		ll_tce_row = dw_export_report.InsertRow(0)
		dw_export_report.setItem(ll_tce_row, "vessel_nr", lds_working.getItemString(ll_counter, "vessel_ref_nr"))
		dw_export_report.setItem(ll_tce_row, "vessel_name", lds_working.getItemString(ll_counter, "vessel_name"))
		dw_export_report.setItem(ll_tce_row, "voyage_nr", lstr_vessel_voyage_list[1].voyage_nr)
		dw_export_report.setItem(ll_tce_row, "voyage_type", lds_working.getItemString(ll_counter, "voyage_type"))
		dw_export_report.setItem(ll_tce_row, "voyage_status", lds_working.getItemString(ll_counter, "voyage_finished"))
		dw_export_report.setItem(ll_tce_row, "voyage_start", dw_vas_report.getItemDatetime(1, "voyage_startdate"))			
		dw_export_report.setItem(ll_tce_row, "voyage_end", dw_vas_report.getItemDatetime(1, "voyage_enddate"))			
		dw_export_report.setItem(ll_tce_row, "vas_group", lds_working.getItemString(ll_counter, "vas_group"))
		dw_export_report.setItem(ll_tce_row, "profitcenter", lds_working.getItemString(ll_counter, "pc_name"))

		if lds_working.getItemString(ll_counter, "voyage_type") = "Single" then
			/* single voyage */
			wf_est_itinerary (lds_working.getItemNumber(ll_counter, "cal_calc_id"))
			dw_export_report.setItem(ll_tce_row, "est_port_rotation", dw_vas_report.getItemString(1, "est_itinerary"))			
			dw_export_report.setItem(ll_tce_row, "act_port_rotation", wf_act_itinerary(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr))			
			dw_export_report.setItem(ll_tce_row, "charterer", dw_vas_report.getItemString(1, "charterers"))			
			dw_export_report.setItem(ll_tce_row, "est_freight", dw_vas_report.getItemDecimal(1, "est_freight"))			
			dw_export_report.setItem(ll_tce_row, "act_freight", dw_vas_report.getItemDecimal(1, "act_freight"))			
			dw_export_report.setItem(ll_tce_row, "est_demurrage", dw_vas_report.getItemDecimal(1, "est_dem_des"))			
			dw_export_report.setItem(ll_tce_row, "act_demurrage", dw_vas_report.getItemDecimal(1, "act_dem_des"))			
			dw_export_report.setItem(ll_tce_row, "est_broker_comm", dw_vas_report.getItemDecimal(1, "est_broker_comm"))			
			dw_export_report.setItem(ll_tce_row, "act_broker_comm", dw_vas_report.getItemDecimal(1, "act_broker_comm"))			
			dw_export_report.setItem(ll_tce_row, "est_port_expenses", dw_vas_report.getItemDecimal(1, "est_port_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_port_expenses", dw_vas_report.getItemDecimal(1, "act_port_exp"))			
			dw_export_report.setItem(ll_tce_row, "est_bunker_expenses", dw_vas_report.getItemDecimal(1, "est_bunk_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_bunker_expenses", dw_vas_report.getItemDecimal(1, "act_bunk_exp"))			
			dw_export_report.setItem(ll_tce_row, "est_misc_expenses", dw_vas_report.getItemDecimal(1, "est_misc_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_misc_expenses", dw_vas_report.getItemDecimal(1, "act_misc_exp"))			
			/* find pool pct for APM Company */
			ldt_start = dw_vas_report.getItemDatetime(1, "voyage_startdate")
			setNull(ld_pool_pct)
			SELECT NTC_SHARE_MEMBER.PERCENT_SHARE  
			 INTO :ld_pool_pct  
			 FROM NTC_SHARE_MEMBER,   
					NTC_TC_CONTRACT,   
					NTC_TC_PERIOD  
			WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_SHARE_MEMBER.CONTRACT_ID  and  
					NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID  and  
					NTC_TC_CONTRACT.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr  AND  
					NTC_TC_CONTRACT.TC_HIRE_IN = 1  AND  
					NTC_SHARE_MEMBER.APM_COMPANY = 1  AND
					NTC_TC_PERIOD.PERIODE_START <= :ldt_start  AND  
					NTC_TC_PERIOD.PERIODE_END > :ldt_start   ;
			COMMIT;
			dw_export_report.setItem(ll_tce_row, "pool", ld_pool_pct)			
		else
			/* TC-out voyage */
			dw_export_report.setItem(ll_tce_row, "est_freight", dw_vas_report.getItemDecimal(1, "calc_freight"))			
			dw_export_report.setItem(ll_tce_row, "act_freight", dw_vas_report.getItemDecimal(1, "act_freight"))			
			dw_export_report.setItem(ll_tce_row, "est_demurrage", dw_vas_report.getItemDecimal(1, "calc_dem_des"))			
			dw_export_report.setItem(ll_tce_row, "act_demurrage", dw_vas_report.getItemDecimal(1, "act_dem_des"))			
			dw_export_report.setItem(ll_tce_row, "est_broker_comm", dw_vas_report.getItemDecimal(1, "calc_broker_comm"))			
			dw_export_report.setItem(ll_tce_row, "act_broker_comm", dw_vas_report.getItemDecimal(1, "act_broker_comm"))			
			dw_export_report.setItem(ll_tce_row, "est_port_expenses", dw_vas_report.getItemDecimal(1, "calc_port_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_port_expenses", dw_vas_report.getItemDecimal(1, "act_port_exp"))			
			dw_export_report.setItem(ll_tce_row, "est_bunker_expenses", dw_vas_report.getItemDecimal(1, "calc_bunk_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_bunker_expenses", dw_vas_report.getItemDecimal(1, "act_bunk_exp"))			
			dw_export_report.setItem(ll_tce_row, "est_misc_expenses", dw_vas_report.getItemDecimal(1, "calc_misc_exp"))			
			dw_export_report.setItem(ll_tce_row, "act_misc_expenses", dw_vas_report.getItemDecimal(1, "act_misc_exp"))			
			
		end if
	end if

next
DESTROY lu_vas_control

dw_export_report.sort()
dw_export_report.groupcalc()
/* Closes progress window */
if isValid(w_progress) then close(w_progress)


end event

type dw_select from datawindow within w_audit_export
integer x = 302
integer y = 56
integer width = 658
integer height = 420
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

type st_2 from statictext within w_audit_export
integer x = 1134
integer y = 208
integer width = 210
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Year:"
boolean focusrectangle = false
end type

