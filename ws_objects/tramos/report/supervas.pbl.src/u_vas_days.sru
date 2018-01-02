$PBExportHeader$u_vas_days.sru
$PBExportComments$Uo used for VAS days actual, and est/act.
forward
global type u_vas_days from u_vas_key_data
end type
end forward

global type u_vas_days from u_vas_key_data
end type
global u_vas_days u_vas_days

type variables
Datastore ids_days_poc, ids_days_offs, ids_days_idle
Long il_rows_in_ds_poc, il_tc_off_service_minutes
s_vessel_voyage_list is_vv_list
Datetime idt_tchire_cp_date
end variables

forward prototypes
public function integer of_decide_est_act (string as_purpose)
public subroutine of_set_days_final_data ()
public function decimal of_compare_est_act (decimal al_est, decimal al_act)
public function integer of_start_days ()
public subroutine of_set_offs_idle (integer as_offs_or_idle, ref datastore ads_offs_idle)
end prototypes

public function integer of_decide_est_act (string as_purpose);
// This function investigates if it is possible according to definitions, to
// use actual days, for Load,loading,ballast and Bunkering. If yes return TRUE.

String ls_port
String ls_1, ls_2, ls_voyage_nr
Decimal ld_calc_id
Integer li_i_nr = 0, li_revers, li_p_nr = 0, li_arr_nr, li_dept_nr, li_vessel_nr
DateTime ldt_dept
Datastore lds_count_calc_ports

ls_voyage_nr =  is_vv_list.voyage_nr
li_vessel_nr =  is_vv_list.vessel_nr

// If TC OUT (voyagetype 2, then there is no calcule data to test)
IF is_vv_list.voyage_type = 2 THEN Return 1

//Set ls_1 and ls_2 for dynamic WHERE clauses.
IF as_purpose = "LOADING" THEN
	ls_1 = "L"
	ls_2 = "L/D"
ELSEIF as_purpose = "LOADED" THEN
	ls_1 = "D"
	ls_2 = "L/D"
ELSE
	ls_1 = "BUN"
	ls_2 = "BUN"
END IF

//Get calc_id for selects
SELECT CAL_CALC_ID  
INTO :ld_calc_id  
FROM VOYAGES  
WHERE ( VESSEL_NR = :is_vv_list.vessel_nr) AND  
      ( VOYAGE_NR = :ls_voyage_nr )   ;
Commit;

//Check reversible before counting ports
SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM  
INTO :li_revers  
FROM CAL_CARG, CAL_CERP, CAL_CALC  
WHERE ( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
      ( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and
		( CAL_CALC.CAL_CALC_ID = :ld_calc_id ) ;
Commit;

//Get last port with purpose as wanted from calling function
SELECT CAL_CAIO.PORT_CODE  
INTO :ls_port 
FROM CAL_CALC, CAL_CARG, CAL_CAIO
WHERE CAL_CALC.CAL_CALC_ID = :ld_calc_id AND 
		CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
		CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID AND
		CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER = 
					( SELECT Max(CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER)
					  FROM CAL_CALC, CAL_CARG, CAL_CAIO
					  WHERE (CAL_CALC.CAL_CALC_ID = :ld_calc_id AND 
								CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
								CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID) AND
							   (CAL_CAIO.PURPOSE_CODE = :ls_1 OR CAL_CAIO.PURPOSE_CODE = :ls_2) ) ;

IF SQLCA.SQLCODE = 100 THEN Return -1
	
Commit;
	
//If not reversible, count each port in itinery as one POC.
//Else count according to rules
IF li_revers = 0 THEN
	SELECT COUNT(*)
	INTO :li_i_nr
	FROM CAL_CALC, CAL_CARG, CAL_CAIO
	WHERE CAL_CALC.CAL_CALC_ID = :ld_calc_id AND 
			CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
			CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID AND
			CAL_CAIO.PORT_CODE = :ls_port AND
			(CAL_CAIO.PURPOSE_CODE = :ls_1 OR CAL_CAIO.PURPOSE_CODE = :ls_2) ;
	Commit;
ELSE 
	lds_count_calc_ports = CREATE Datastore
	lds_count_calc_ports.DataObject = "d_count_calc_ports"
	lds_count_calc_ports.SetTransObject(SQLCA)
	li_i_nr = lds_count_calc_ports.Retrieve(ld_calc_id,ls_port,ls_1)
	IF li_i_nr = -1 THEN 
		return -1
	ELSE
		li_i_nr = lds_count_calc_ports.GetItemNumber(1,"sum_poc")
	END IF
	DESTROY lds_count_calc_ports

END IF

//Get how many arr. dates is filled
SELECT Count(*) 
INTO :li_arr_nr  
FROM POC  
WHERE ( POC.VESSEL_NR = :is_vv_list.vessel_nr ) AND  
   	( POC.VOYAGE_NR = :ls_voyage_nr ) AND  
   	( POC.PORT_CODE = :ls_port ) AND  
 	   ( POC.PURPOSE_CODE = :ls_1 OR POC.PURPOSE_CODE = :ls_2 ) AND 
		( POC.PORT_ARR_DT IS NOT NULL ) ;
Commit;

//Get how many dept. dates is filled
SELECT Count(*) 
INTO :li_dept_nr  
FROM POC  
WHERE ( POC.VESSEL_NR = :is_vv_list.vessel_nr ) AND  
      ( POC.VOYAGE_NR = :ls_voyage_nr ) AND  
      ( POC.PORT_CODE = :ls_port ) AND  
      ( POC.PURPOSE_CODE = :ls_1 OR POC.PURPOSE_CODE = :ls_2 ) AND
		( POC.PORT_DEPT_DT IS NOT NULL ) ;
Commit;

//If arr and dept is equal then OK
//Else only okay if calling function is Est/act LOADED DAYS, and
//last dept. date is not filled
IF li_arr_nr = li_dept_nr THEN
	li_p_nr = li_arr_nr
ELSEIF li_arr_nr > li_dept_nr AND as_purpose = "LOADED" THEN
		SELECT Max(POC.PORT_DEPT_DT)
		INTO :ldt_dept
		FROM POC  
		WHERE  POC.VESSEL_NR = :is_vv_list.vessel_nr  AND  
			 POC.VOYAGE_NR = :ls_voyage_nr  AND  
			 POC.PORT_CODE = :ls_port AND  
			 POC.PURPOSE_CODE = :ls_1 OR POC.PURPOSE_CODE = :ls_2 ;
		Commit;
		IF IsNull(ldt_dept) THEN 
			li_p_nr = li_arr_nr
		ELSE
			Return -1
		END IF
ELSE
	Return -1
END IF

//IF all ports from itinery have poc's then return 1, Else -1
IF li_p_nr = li_i_nr THEN 
	Return 1
ELSE
	Return -1
END IF

end function

public subroutine of_set_days_final_data ();
Datetime ldt_arr_dt, ldt_dept_dt, ldt_first_load_port_arr_dt
Long ll_other_days

// set for normal voyages first actual, then est/act.
IF il_rows_in_ds_poc > 0 THEN
	of_setloading_days (5, ids_days_poc.GetItemNumber(1,"sum_loading"))
	of_setdischarge_days (5, ids_days_poc.GetItemNumber(1,"sum_discharge"))
	of_setload_discharge_days (5, ids_days_poc.GetItemNumber(1,"sum_load_disch"))
	of_setbunkering_days (5, ids_days_poc.GetItemNumber(1,"sum_bunkering"))
	of_setcanal_days (5, ids_days_poc.GetItemNumber(1,"sum_canal_transit"))
	of_setdocking_days (5,ids_days_poc.GetItemNumber(1,"sum_dry_docking"))
	of_setloaded_days (5, ids_days_poc.GetItemNumber(1,"sum_loaded"))
	of_setballast_days (5, ids_days_poc.GetItemNumber(1,"sum_ballast"))
	
//	f_datastore_spy (ids_days_poc)
//	messageBox("Ballast", ids_days_poc.GetItemNumber(1,"sum_ballast"))
	
	of_setother_days (5, ids_days_poc.GetItemNumber(1,"sum_others"))
END IF

of_setdischarge_days(4,of_compare_est_act(of_getdischarge_days(3,TRUE),of_getdischarge_days(5,TRUE)))
of_setload_discharge_days(4,of_compare_est_act(of_getload_discharge_days(3,TRUE),of_getload_discharge_days(5,TRUE)))
of_setcanal_days(4,of_compare_est_act(of_getcanal_days(3,TRUE),of_getcanal_days(5,TRUE)))
of_setdocking_days(4,of_compare_est_act(of_getdocking_days(3,TRUE),of_getdocking_days(5,TRUE)))


IF ((of_get_port_match() AND of_decide_est_act("LOADING") = 1) OR (NOT of_get_port_match() AND is_vv_list.voyage_finished = 1)) AND il_rows_in_ds_poc > 0 THEN
	of_setloading_days (4, ids_days_poc.GetItemNumber(1,"sum_loading"))
ELSE
	of_setloading_days(4,of_compare_est_act(of_getloading_days(3,TRUE),of_getloading_days(5,TRUE)))
END IF

IF (of_get_port_match() AND of_decide_est_act("BUN") = 1 OR (NOT of_get_port_match() AND is_vv_list.voyage_finished = 1) ) AND il_rows_in_ds_poc > 0 THEN
	of_setbunkering_days (4, ids_days_poc.GetItemNumber(1,"sum_bunkering"))
ELSE
	of_setbunkering_days(4,of_compare_est_act(of_getbunkering_days(3,TRUE),of_getbunkering_days(5,TRUE)))
END IF

IF ((of_get_port_match() AND of_decide_est_act("LOADED") = 1) OR (NOT of_get_port_match() AND is_vv_list.voyage_finished = 1) ) AND il_rows_in_ds_poc > 0 THEN
	of_setloaded_days (4, ids_days_poc.GetItemNumber(1,"sum_loaded"))
ELSE
	of_setloaded_days(4,of_compare_est_act(of_getloaded_days(3,TRUE),of_getloaded_days(5,TRUE)))
END IF
	
IF of_get_port_match() THEN
	/* Select the first load port, if any*/
	SELECT isnull(min(PORT_ARR_DT),NULL)
	INTO :ldt_first_load_port_arr_dt
	FROM POC
	WHERE 	(VESSEL_NR = :is_vv_list.vessel_nr ) AND  
				(VOYAGE_NR = :is_vv_list.voyage_nr ) AND
				(PURPOSE_CODE = "L" or
				PURPOSE_CODE = "L/D");
	COMMIT;
	// If no L or L/D then use est, else use act.
	IF IsNull(ldt_first_load_port_arr_dt) OR NOT(il_rows_in_ds_poc > 0) THEN 
		of_setballast_days (4, of_getballast_days(3,TRUE))
	ELSE
		of_setballast_days (4, ids_days_poc.GetItemNumber(1,"sum_ballast"))
	END IF
ELSE
	IF is_vv_list.voyage_finished = 1 AND il_rows_in_ds_poc > 0 THEN
		of_setballast_days (4, ids_days_poc.GetItemNumber(1,"sum_ballast"))
	ELSE
		of_setballast_days(4,of_compare_est_act(of_getballast_days(3,TRUE),of_getballast_days(5,TRUE)))
	END IF
END IF
	
// These figures are calculated the same for TC out, and for other voyage types.

// Est/Act Other days
of_setother_days(4,of_compare_est_act(of_getother_days(3,TRUE),of_getother_days(5,TRUE)))
	
// Actual Off service days
IF  is_vv_list.tcowner_nr > 0 THEN
	of_setoff_service_days (5,Round(il_tc_off_service_minutes/60/24,4)) 
ELSEIF il_rows_in_ds_poc > 0 THEN
	of_setoff_service_days (5,ids_days_poc.GetItemNumber(1,"sum_offservice")) 
END IF
	
// Est/act Off Service days
of_setoff_service_days (4,of_compare_est_act(of_getoff_service_days(3,TRUE),of_getoff_service_days(5,TRUE)))
	
// Actual Idle days
IF il_rows_in_ds_poc > 0 THEN
	of_setidle_days (5, ids_days_poc.GetItemNumber(1,"sum_idledays"))
END IF

// Est/act Idle days
of_setidle_days(4,of_compare_est_act(of_getidle_days(3,TRUE),of_getidle_days(5,TRUE)))



	 
end subroutine

public function decimal of_compare_est_act (decimal al_est, decimal al_act);// This function returns act. if voyage is finished, else it returns the largest.

IF is_vv_list.voyage_finished = 1 THEN
	Return al_act
ELSE
	IF al_act >= al_est THEN
		Return al_act
	ELSE
		Return al_est
	END IF
END IF

end function

public function integer of_start_days ();Long ll_nr_of_poc, ll_counter
Datetime ldt_arr, ldt_dept, ldt_commenced
String ls_purpose
Boolean lb_load_startet = FALSE

of_get_vessel_array ( is_vv_list )

// Get all OFF Services for vessel/voyage in a datastore
ids_days_offs = CREATE datastore
ids_days_offs.DataObject = "d_days_offs" 
ids_days_offs.SetTransObject(SQLCA)
ids_days_offs.Retrieve(is_vv_list.vessel_nr, is_vv_list.voyage_nr)

// Get all Idle days for vessel/voyage in a datastore
ids_days_idle = CREATE datastore
ids_days_idle.DataObject = "d_days_idle" 
ids_days_idle.SetTransObject(SQLCA)
ids_days_idle.Retrieve(is_vv_list.vessel_nr, is_vv_list.voyage_nr)

// Get all POC for vessel/voyage in a datastore
ids_days_poc = CREATE datastore
ids_days_poc.DataObject = "d_days_poc" 
ids_days_poc.SetTransObject(SQLCA)
ll_nr_of_poc = ids_days_poc.Retrieve(is_vv_list.vessel_nr, is_vv_list.voyage_nr)
il_rows_in_ds_poc = ll_nr_of_poc

// IF this is calculation memo, days is not used, so return, or no rows in days.
IF /* NOT(il_rows_in_ds_poc > 0) OR */ of_get_result_type() = 6 THEN
	DESTROY ids_days_offs ;
	DESTROY ids_days_idle ;
	DESTROY ids_days_poc  ;
	RETURN 1 
END IF

IF ll_nr_of_poc > 0 THEN
	// If timegap between poc's then insert row to fill gab 
	// and set Purpose to loaded or ballast.
	IF ll_nr_of_poc > 1 THEN
		FOR ll_counter = 2 TO ll_nr_of_poc
			ldt_arr = ids_days_poc.GetItemDatetime(ll_counter,"port_arr_dt")
			ldt_dept = ids_days_poc.GetItemDatetime((ll_counter - 1),"port_dept_dt")
			ls_purpose = ids_days_poc.GetItemString(ll_counter -1 ,"purpose_code")
			IF ls_purpose = "L" OR ls_purpose = "L/D" THEN lb_load_startet = TRUE
			If ldt_arr > ldt_dept THEN
				ids_days_poc.InsertRow(ll_counter)
				ids_days_poc.SetItem(ll_counter ,"port_arr_dt",ldt_dept)
				ids_days_poc.SetItem(ll_counter ,"port_dept_dt",ldt_arr)
				// IF last discharge is not last POC, then purpose is still set to loaded
				// (in inserted rows after last disharge POC) where it maybe logical 
				// should have been ballast (?)
				IF lb_load_startet THEN
					ids_days_poc.SetItem(ll_counter ,"purpose_code","loaded")
				ELSE
					ids_days_poc.SetItem(ll_counter ,"purpose_code","ballast")
				END IF
				ids_days_poc.SetItem(ll_counter ,"offservice",0)
				ids_days_poc.SetItem(ll_counter ,"idledays",0)
		
				ll_counter++
				ll_nr_of_poc++
				il_rows_in_ds_poc++
			END IF
		NEXT
	END IF
	
	ldt_commenced = of_getcommenced_date()
	
	// Check if this is okay when commenced is from TC ????
	// If commenced date is from previous voyage then insert a row (1) with ballast purpose.
	IF ldt_commenced <> ids_days_poc.GetItemDatetime(1,"port_arr_dt") THEN
		ids_days_poc.InsertRow(1)
		ids_days_poc.SetItem(1,"port_arr_dt",ldt_commenced)
		ids_days_poc.SetItem(1,"port_dept_dt",ids_days_poc.GetItemDatetime(2,"port_arr_dt"))
		ids_days_poc.SetItem(1,"purpose_code","ballast")
		ids_days_poc.SetItem(1 ,"offservice",0)
		ids_days_poc.SetItem(1 ,"idledays",0)
		il_rows_in_ds_poc++
	END IF

	// There is now 3 datastores with POC, Off service and Idle days. Call function
	// for calculating off service and Idle days for each POC, and insert values 
	// in datastore with POC. Use same function, but call twice with different
	// parameter, indicating if it is off S. or Idle we want.
	
	of_set_offs_idle(1,ids_days_offs)
	of_set_offs_idle(2,ids_days_idle)

	IF is_vv_list.tcowner_nr > 0 THEN
		SELECT (isnull(sum(OS.OFF_TIME_DAYS),0)*24*60)+(isnull(sum(OS.OFF_TIME_HOURS),0)*60)+(isnull(sum(OS.OFF_TIME_MINUTES),0))
		INTO :il_tc_off_service_minutes
		FROM OFF_SERVICES OS,    NTC_OFF_SERVICE  TC
		WHERE 	( OS.OPS_OFF_SERVICE_ID = TC.OPS_OFF_SERVICE_ID) and  
					( ( OS.VESSEL_NR = :is_vv_list.vessel_nr )    and
					(OS.VOYAGE_NR = :is_vv_list.voyage_nr));
		commit;
	END IF
END IF

// Now ds_days_poc (and if tc also il_tc_off_service_minutes) has all days (actual) ready.
of_set_days_final_data()

DESTROY ids_days_offs ;
DESTROY ids_days_idle ;
DESTROY ids_days_poc  ;

Return 1
end function

public subroutine of_set_offs_idle (integer as_offs_or_idle, ref datastore ads_offs_idle);Long 		ll_ds_rows,ll_poc_counter,ll_ds_counter, ll_offs_idle_minutes
Long 		ll_offs_idle_minutes_total, ll_calc_minutes
DateTime ldt_arr_dt, ldt_dept_dt, ldt_start_dt, ldt_end_dt, ldt_temp
String 	ls_field
boolean	lb_negative, lb_minutes_negative
decimal	ld_reduction

// This function gets a datastore pointer. Either ids_days_offs,
// ids_days_idle (instance ds). The start/end date fields names 
// are the same in both datastores.

IF as_offs_or_idle = 1 THEN
	ls_field = "offservice"
ELSE
	ls_field = "idledays"
END IF

ll_ds_rows = ads_offs_idle.RowCount()

// Loop through poc, and for each loop through all rows in datastore with offs/idle.
// Sum up the offs/idle minutes and when finished then set sum of minutes in poc datastore
// in the actual row. Then take next poc and do the same, etc until no more poc.
FOR ll_poc_counter = 1 TO il_rows_in_ds_poc
	ldt_arr_dt = ids_days_poc.GetItemDatetime(ll_poc_counter,"port_arr_dt")
	ldt_dept_dt = ids_days_poc.GetItemDateTime(ll_poc_counter,"port_dept_dt")
	ll_offs_idle_minutes_total = 0
	FOR ll_ds_counter = 1 TO ll_ds_rows
		ll_offs_idle_minutes = 0
		ldt_start_dt = ads_offs_idle.GetItemDatetime(ll_ds_counter,"STARTDT")
		ldt_end_dt = ads_offs_idle.GetItemDatetime(ll_ds_counter,"ENDDT")
		if ads_offs_idle.getItemNumber(ll_ds_counter, "minutes") = 0 then continue
		if ads_offs_idle.getItemNumber(ll_ds_counter, "minutes") < 0 then
			lb_minutes_negative = true
		else
			lb_minutes_negative = false
		end if

		ll_calc_minutes = daysafter(date(ldt_end_dt),date(ldt_start_dt)) * 24*60
		ll_calc_minutes += (secondsafter(time(ldt_end_dt),time(ldt_start_dt))/60)
		if ll_calc_minutes = 0 then ll_calc_minutes = 1
		ld_reduction = abs(ads_offs_idle.getItemNumber(ll_ds_counter, "minutes")) / abs(ll_calc_minutes)  

		/* Check om enddate < startdate. Forekommer ved negative offservices 
			Her skal datoerne byttes om og lb_negative sættes til true således 
			at tiden kan trækkes fra i stedet fopr lægegs til.
		*/
		if ldt_end_dt < ldt_start_dt then
			ldt_temp = ldt_start_dt
			ldt_start_dt = ldt_end_dt
			ldt_end_dt = ldt_temp
			lb_negative = true
		else
			if lb_minutes_negative then
				lb_negative = true 
			else
				lb_negative = false
			end if
		end if
		/* If the OffS/idle days start and end are in this period, then ...*/
		IF ldt_arr_dt <= ldt_start_dt AND ldt_dept_dt >= ldt_end_dt THEN
			/* Add time for this OffS/idle days to this period type total */
			if lb_negative then
				ll_offs_idle_minutes = daysafter(date(ldt_end_dt),date(ldt_start_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_end_dt),time(ldt_start_dt))/60)
			else
				ll_offs_idle_minutes = daysafter(date(ldt_start_dt),date(ldt_end_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_start_dt),time(ldt_end_dt))/60)
			end if
		END IF						
		/* if the OffS/idle days start and end completely encapsulate around this period, then ... */
		IF ldt_arr_dt >= ldt_start_dt AND ldt_dept_dt <= ldt_end_dt THEN		
			/* Add complete time for this period to this period type total */
			if lb_negative then
				ll_offs_idle_minutes = daysafter(date(ldt_dept_dt),date(ldt_arr_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_dept_dt),time(ldt_arr_dt))/60)
			else
				ll_offs_idle_minutes = daysafter(date(ldt_arr_dt),date(ldt_dept_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_arr_dt),time(ldt_dept_dt))/60)
			end if
		END IF
		/* If the OffS/idle days starts in this period but ends in the next, then ... */
		IF	ldt_arr_dt <= ldt_start_dt AND ldt_dept_dt >= ldt_start_dt AND ldt_dept_dt <= ldt_end_dt THEN
			/* Add time from OffS/idle days start to period end to this period type total */
			if lb_negative then
				ll_offs_idle_minutes = daysafter(date(ldt_dept_dt),date(ldt_start_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_dept_dt),time(ldt_start_dt))/60)
			else
				ll_offs_idle_minutes = daysafter(date(ldt_start_dt),date(ldt_dept_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_start_dt),time(ldt_dept_dt))/60)
			end if
		END IF
		/* If the OffS/idle days ends in this period but starts in the previous, then ... */		
		IF	ldt_arr_dt >= ldt_start_dt AND ldt_arr_dt <= ldt_end_dt AND ldt_dept_dt >= ldt_end_dt THEN
			/* Add time from this periods start to OffS/idle days end to this period type total */
			if lb_negative then
				ll_offs_idle_minutes = daysafter(date(ldt_end_dt),date(ldt_arr_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_end_dt),time(ldt_arr_dt))/60)
			else
				ll_offs_idle_minutes = daysafter(date(ldt_arr_dt),date(ldt_end_dt)) * 24*60
				ll_offs_idle_minutes += (secondsafter(time(ldt_arr_dt),time(ldt_end_dt))/60)
			end if
		END IF
		ll_offs_idle_minutes = ll_offs_idle_minutes * ld_reduction
		ll_offs_idle_minutes_total += ll_offs_idle_minutes
	NEXT
	// Set total offs/idle in ds poc.
	//IF (NOT ll_offs_idle_minutes_total > 0) THEN ll_offs_idle_minutes_total = 0
	ids_days_poc.SetItem(ll_poc_counter,ls_field,ll_offs_idle_minutes_total)
	//f_datastore_spy(ids_days_poc)
NEXT

end subroutine

on u_vas_days.create
call super::create
end on

on u_vas_days.destroy
call super::destroy
end on

