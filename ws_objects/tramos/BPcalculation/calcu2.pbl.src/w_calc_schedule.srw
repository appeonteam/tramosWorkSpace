$PBExportHeader$w_calc_schedule.srw
$PBExportComments$Scheduler for chartering
forward
global type w_calc_schedule from mt_w_response_calc
end type
type cb_print from commandbutton within w_calc_schedule
end type
type cb_refresh from commandbutton within w_calc_schedule
end type
type st_2 from statictext within w_calc_schedule
end type
type mle_comments from multilineedit within w_calc_schedule
end type
type dw_start from datawindow within w_calc_schedule
end type
type st_1 from statictext within w_calc_schedule
end type
type cb_save from commandbutton within w_calc_schedule
end type
type dw_schedule from datawindow within w_calc_schedule
end type
type st_duration from statictext within w_calc_schedule
end type
end forward

global type w_calc_schedule from mt_w_response_calc
integer width = 3744
integer height = 2160
string title = "Schedule"
long backcolor = 32304364
event ue_refresh pbm_custom41
event ue_retrieve pbm_custom01
cb_print cb_print
cb_refresh cb_refresh
st_2 st_2
mle_comments mle_comments
dw_start dw_start
st_1 st_1
cb_save cb_save
dw_schedule dw_schedule
st_duration st_duration
end type
global w_calc_schedule w_calc_schedule

type variables
s_scheduler_parm istr_parm  /* s_scheduler_parm (long l_calc_id, long l_fix_id, datetime dt_voyage_start) */
boolean ib_modified = FALSE
decimal id_additionals, id_tcmonth, id_index100
integer ii_vessel_nr
string is_calc_desc
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_refresh;/* Kør loop igennem og opdater datoerne udfra
   enten departure-bunker eller arrival load */
	
long ll_rows, ll_x, ll_found
long ll_seconds
datetime ldt_datetime, ldt_laycanstart, ldt_laycanend
decimal ld_laytime, ld_additionals, ld_duration
datastore lds
string ls_search

dw_start.AcceptText()
dw_schedule.AcceptText()

ll_rows = dw_schedule.RowCount()

ldt_datetime = dw_start.getItemDatetime(1, "datetime_value")
IF ll_rows > 0 then dw_schedule.setItem(1, "arrival",ldt_datetime)

FOR ll_x = 1 TO ll_rows
	ld_laytime = dw_schedule.getItemNumber(ll_x, "laytime") + &
					 (dw_schedule.getItemNumber(ll_x, "noticetime") / 24)
	ld_additionals = dw_schedule.getItemNumber(ll_x, "additionals")
		
	/* Set Arrival Date */
	IF ll_x > 1 THEN
		ll_seconds = f_datetime2long(ldt_datetime)
		ll_seconds = ll_seconds + (dw_schedule.getItemNumber(ll_x - 1, "sailing_days") * 60)
		ldt_datetime = f_long2datetime(ll_seconds)
		dw_schedule.setItem(ll_x, "arrival", ldt_datetime)
	END IF

	/* Set Departure Date */
	ll_seconds = f_datetime2long(ldt_datetime)
	ll_seconds = ll_seconds + ((ld_laytime + ld_additionals) * 86400)
	ldt_datetime = f_long2datetime(ll_seconds)
	dw_schedule.setItem(ll_x, "departure", ldt_datetime)
NEXT

/* Check om L havne overholder en evt. laycan */

lds = CREATE datastore
lds.dataObject = "d_schedule_laycan"
lds.setTransObject(sqlca)
ll_rows = lds.retrieve(istr_parm.l_calc_id)

FOR ll_x = 1 TO ll_rows
	ls_search = "portcode = '"+lds.getItemString(ll_x, "port_code") + "'"
	ls_search += " and itinerary = "+string(lds.getItemNumber(ll_x, "itinerary_number"))
	ll_found = dw_schedule.find(ls_search, 1, 999)
	IF ll_found > 0 THEN
		ldt_datetime = dw_schedule.getItemDatetime(ll_found, "arrival")
		ldt_laycanstart = lds.getItemDatetime(ll_x, "start")
		ldt_laycanend = lds.getItemDatetime(ll_x, "end")
		IF ldt_datetime < ldt_laycanstart OR ldt_datetime > ldt_laycanend THEN
			dw_schedule.setItem(ll_found, "laycan", 1)
		ELSE
			dw_schedule.setItem(ll_found, "laycan", 0)
		END IF
	END IF	
NEXT

/* Update Duration and TC/month */

ll_rows = dw_schedule.RowCount()
ld_duration = timedifference (dw_schedule.getItemDateTime(1, "arrival"), &
										dw_schedule.getItemDateTime(ll_rows, "departure"))/ 1440
st_duration.text = "Duration: "+string(ld_duration,"#,##0.00")+ " days" +&
						 "  -  TC/Month: "+string(id_tcmonth,"#,##0") + &
						 " / Index 100: "+string(id_index100,"#,##0") + &
						 " (including " + string(id_additionals,"#,##0.00")+ " additional days)"
end event

event ue_retrieve;/* s_scheduler_parm ~ istr_parm
		long l_calc_id 
		long l_fix_id 
		datetime dt_voyage_start) */

decimal ld_additional_days, ld_totballast_days, ld_chanal_days, ld_sailing_days
decimal ld_laytime, ld_calculated, ld_estimated, ld_quantity
long ll_dw_rows, ll_x, ll_found, ll_ds_rows
datastore lds
string ls_search, ls_comments

/* To avoid problems updating voyage date for an open calculation */
SELECT CAL_CALC_START_DATE, SCHEDULER_COMMENTS, CAL_CALC_TC_EQV, 
		 CAL_CALC_VESSEL_ID, CAL_CALC_DESCRIPTION  
	INTO :istr_parm.dt_voyage_start, :ls_comments, :id_tcmonth, 
		  :ii_vessel_nr, :is_calc_desc
	FROM CAL_CALC 
	WHERE CAL_CALC_ID = :istr_parm.l_calc_id ;

dw_start.InsertRow(0)
if isnull(istr_parm.dt_voyage_start) then
	dw_start.setItem(1,"datetime_value", today())
else
	dw_start.setItem(1,"datetime_value", istr_parm.dt_voyage_start)
end if	
dw_start.ResetUpdate()

ll_dw_rows = dw_schedule.retrieve(istr_parm.l_calc_id)

mle_comments.text = ls_comments

/* Set additionals for each Cargo */
lds = CREATE datastore
lds.dataObject = "d_schedule_laycan"
lds.setTransObject(sqlca)
ll_ds_rows = lds.retrieve(istr_parm.l_calc_id)

FOR ll_x = 1 TO ll_ds_rows
	ls_search = "portcode = '"+lds.getItemString(ll_x, "port_code") + "'"
	ls_search += " and itinerary = "+string(lds.getItemNumber(ll_x, "itinerary_number"))
	ll_found = dw_schedule.find(ls_search, 1, 999)
	IF ll_found > 0 THEN
		ld_additional_days = lds.getItemNumber(ll_x, "additionals")
		dw_schedule.setItem(ll_found, "additionals", ld_additional_days)
	END IF	
NEXT


FOR ll_x = 1 TO ll_dw_rows
/* Sailing days = sailing days + canal days */
	ld_sailing_days = dw_schedule.getItemNumber(ll_x, "sailing_days") + (dw_schedule.getItemNumber(ll_x, "canal_days") * 1440)
	dw_schedule.setItem(ll_x, "sailing_days", ld_sailing_days)

/* Claculation of Laytime */
	ld_estimated = dw_schedule.getItemNumber(ll_x, "estimated")
	ld_calculated = dw_schedule.getItemNumber(ll_x, "calculated")
//	ld_notice = dw_schedule.getItemNumber(ll_x, "noticetime")
	ld_quantity = dw_schedule.getItemNumber(ll_x, "quantity")
	IF ld_quantity < 0 THEN ld_quantity *= -1
	IF ld_calculated <> 0 THEN         /* This is done so that all laytime calculations */
		ld_estimated = ld_calculated	  /* later in the script is based on the variable  */
	END IF									  /* ld_estimated                                  */
	
	CHOOSE CASE dw_schedule.getItemString(ll_x, "purpose") 
		CASE "Ballast" /* Ballast */
			ld_laytime = 0
		CASE "Loading", "Discharging", "Load & Disch."  /* Load, Discharge or Both */
			CHOOSE CASE dw_schedule.getItemNumber(ll_x, "term")
				CASE 0  /* Hours */	
					ld_laytime = (ld_estimated) / 24
				CASE 1, 2, 3  /* quantity pr. hour (MT/H, CBM/H, CBF/H) */
					ld_laytime = ((ld_quantity / ld_estimated)) / 24
				CASE 4  /* Days */
					ld_laytime = ld_estimated  
				CASE 5, 6, 7  /* quantity pr. day (MT/D, CBM/D, CBF/D) */
					ld_laytime = (ld_quantity / ld_estimated)
			END CHOOSE
		CASE ELSE
			ld_laytime = (ld_estimated) / 24
	END CHOOSE	
	dw_schedule.SetItem(ll_x, "laytime", ld_laytime)
Next

/* Calculate Index 100 and set initial additionals */
id_index100 = f_calculate_index100( id_tcmonth, ii_vessel_nr)
id_additionals = dw_schedule.getItemNumber(1, "compute_4")

this.TriggerEvent("ue_refresh")
end event

public subroutine documentation ();/********************************************************************
   w_calc_schedule
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

event open;/* s_scheduler_parm ~ istr_parm
		long l_calc_id 
		long l_fix_id 
		datetime dt_voyage_start) */
		
istr_parm = message.PowerObjectParm

dw_schedule.setTransObject(SQLCA)
this.postEvent("ue_retrieve")


n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_schedule,true)
end event

on w_calc_schedule.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_refresh=create cb_refresh
this.st_2=create st_2
this.mle_comments=create mle_comments
this.dw_start=create dw_start
this.st_1=create st_1
this.cb_save=create cb_save
this.dw_schedule=create dw_schedule
this.st_duration=create st_duration
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_refresh
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.mle_comments
this.Control[iCurrent+5]=this.dw_start
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_save
this.Control[iCurrent+8]=this.dw_schedule
this.Control[iCurrent+9]=this.st_duration
end on

on w_calc_schedule.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_refresh)
destroy(this.st_2)
destroy(this.mle_comments)
destroy(this.dw_start)
destroy(this.st_1)
destroy(this.cb_save)
destroy(this.dw_schedule)
destroy(this.st_duration)
end on

event closequery;integer li_rc

// Accept the last data entered into the datawindow

dw_start.AcceptText()

//Check to see if any data has changed

IF dw_start.DeletedCount()+dw_start.ModifiedCount() > 0  OR ib_modified THEN
		li_rc = MessageBox("Closing", &
		"Update your changes?", Question!, &
		YesNoCancel!, 3)

//User chose to up data and close window
		IF li_rc = 1 THEN
			cb_save.TriggerEvent(clicked!)
			RETURN 0

//User chose to close window without updating
		ELSEIF li_rc = 2 THEN
			RETURN 0

//User canceled
		ELSE
			RETURN 1
		END IF

ELSE
		// No changes to the data, window will just close
		RETURN 0

END IF
end event

type cb_print from commandbutton within w_calc_schedule
integer x = 1070
integer y = 1940
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;datastore lds
string ls_vessel
datawindowchild ldwc1, ldwc2

lds = CREATE datastore

lds.dataObject = "d_print_schedule_composite"

lds.getChild("dw_1", ldwc1)
lds.getchild("dw_2", ldwc2)

dw_schedule.sharedata(ldwc1)

ldwc2.InsertRow(0)

ldwc2.setItem(1, "comments", mle_comments.text)

ldwc1.Modify("duration.text='"+st_duration.text+"'")

/* Set header and footer for main report */
lds.Modify("description.text='"+is_calc_desc+"'")

SELECT VESSEL_NAME INTO :ls_vessel FROM VESSELS WHERE VESSEL_NR = :ii_vessel_nr;
ls_vessel = string(ii_vessel_nr, "000") + " " + ls_vessel
lds.Modify("vessel.text='"+ls_vessel+"'")

lds.Modify ("t_username.text = '" + f_get_username() + "'")

lds.print()

ldwc1.shareDataOff()
end event

type cb_refresh from commandbutton within w_calc_schedule
integer x = 699
integer y = 1940
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;parent.TriggerEvent("ue_refresh")
end event

type st_2 from statictext within w_calc_schedule
integer x = 27
integer y = 1252
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Comments"
boolean focusrectangle = false
end type

type mle_comments from multilineedit within w_calc_schedule
integer x = 23
integer y = 1320
integer width = 3653
integer height = 580
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event modified;ib_modified = TRUE
end event

type dw_start from datawindow within w_calc_schedule
integer x = 302
integer y = 1948
integer width = 370
integer height = 80
integer taborder = 10
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;parent.TriggerEvent("ue_refresh")
end event

type st_1 from statictext within w_calc_schedule
integer x = 9
integer y = 1960
integer width = 265
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Startdate"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_calc_schedule
integer x = 1440
integer y = 1940
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;/* ved save skal voyage start gemmes
	her kan der checkes for om fix_id er med i strukturen
	hvis ja, findes kalkulen i 3 versioner og update kan bruge
	fix_id i where clausen ( alle 3 opdateres på en gang)
	
	hvis nej, opdater kun den ene kalkule med med calc_id som nøgle
*/
datetime ldt
string ls_comments

ldt = dw_start.getItemDatetime(1,"datetime_value")
ls_comments = mle_comments.text

IF NOT isNull(istr_parm.l_fix_id) THEN
	UPDATE CAL_CALC 
		SET CAL_CALC_START_DATE = :ldt, SCHEDULER_COMMENTS = :ls_comments 
		WHERE CAL_CALC_FIX_ID = :istr_parm.l_fix_id ;
ELSE
	UPDATE CAL_CALC 
		SET CAL_CALC_START_DATE = :ldt, SCHEDULER_COMMENTS = :ls_comments 
		WHERE CAL_CALC_ID = :istr_parm.l_calc_id ;
END IF

IF SQLCA.SQLCode <> 0 THEN
	MessageBox("Error", "Error updating Start Date. Please contact system Administrator!")
	RollBack;
ELSE
	COMMIT;
END IF

ib_modified = FALSE
end event

type dw_schedule from datawindow within w_calc_schedule
integer x = 23
integer y = 24
integer width = 3653
integer height = 1212
integer taborder = 20
string title = "none"
string dataobject = "d_calc_schedule"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;parent.TriggerEvent("ue_refresh")
end event

type st_duration from statictext within w_calc_schedule
integer x = 23
integer y = 1252
integer width = 3653
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Duration: xx.xx days"
alignment alignment = center!
boolean focusrectangle = false
end type

