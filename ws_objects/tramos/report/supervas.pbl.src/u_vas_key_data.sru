$PBExportHeader$u_vas_key_data.sru
$PBExportComments$Uo from which all VAS uo is inhereted. Contains shared variables, and all initial/standard functions.
forward
global type u_vas_key_data from mt_n_nonvisualobject
end type
end forward

shared variables
s_vas_data sstr_vas_accumulated_data[5]
s_vas_data sstr_vas_data[5]
datastore sds_vessel_voyage_list
datastore sds_calcmemo_port_exp
String ss_income_details, ss_expense_details, ss_current_old_tco_voyage // Used for TC Out
Decimal {2} sd_misc_exp_est_act, sd_misc_inc_est_act,sd_misc_exp_act, sd_misc_inc_act // Used for TC Out
Decimal {2} sd_off_service_est_act
boolean sb_port_match = FALSE
boolean sb_tcin_or_apm = FALSE //0=APM 1=TCin
datetime sdt_commenced_date, sdt_tc_period_end_date, sdt_voyage_enddate
long sl_current_index = 0, sl_nr_of_voyages = 0
long sl_tc_contractID
integer si_vas_year, si_result_type // 1 = Vessel Voyage
                                  // 2 = Vessel
                                  // 3 = Vessel Group
                                  // 4 = Profit Center
                                  // 5 = Department
                                  // 6 = Calculation Memo or variations CODA
                                  // 7 = VAS-file 
                                  // 8 = Bunker Transaction CODA
											
                                  


end variables

global type u_vas_key_data from mt_n_nonvisualobject
end type
global u_vas_key_data u_vas_key_data

type variables
constant integer ii_IDLEDAYS = 7
end variables

forward prototypes
public subroutine of_init_vessel_array ()
public subroutine of_set_current_index (long al_index_nr)
public subroutine of_destroy_vessel_array ()
public subroutine of_reset_accumulated_array ()
public subroutine of_set_tcin_or_apm ()
public function boolean of_get_tcin_or_apm ()
public subroutine of_set_port_match ()
public subroutine of_setgross_freight (integer ai_column, decimal ad_gross_freight)
public subroutine of_setdemurrage (integer ai_column, decimal ad_demurrage)
public function decimal of_getdemurrage (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setbroker_commission (integer ai_column, decimal ad_broker_commission)
public function decimal of_getbroker_commission (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setport_expenses (integer ai_column, decimal ad_port_expenses)
public function decimal of_getport_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setmisc_expenses (integer ai_column, decimal ad_misc_expenses)
public function decimal of_getmisc_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setdrc (integer ai_column, decimal ad_drc)
public function decimal of_getdrc (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setloading_days (integer ai_column, decimal ad_loading_days)
public function decimal of_getloading_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setdischarge_days (integer ai_column, decimal ad_discharge_days)
public function decimal of_getdischarge_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setload_discharge_days (integer ai_column, decimal ad_load_discharge_days)
public function decimal of_getload_discharge_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setbunkering_days (integer ai_column, decimal ad_bunkering_days)
public function decimal of_getbunkering_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setcanal_days (integer ai_column, decimal ad_canal_days)
public function decimal of_getcanal_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setdocking_days (integer ai_column, decimal ad_docking_days)
public function decimal of_getdocking_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setloaded_days (integer ai_column, decimal ad_loaded_days)
public function decimal of_getloaded_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setballast_days (integer ai_column, decimal ad_ballast_days)
public function decimal of_getballast_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setidle_days (integer ai_column, decimal ad_idle_days)
public function decimal of_getidle_days (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setoff_service_days (integer ai_column, decimal ad_off_service_days)
public subroutine of_setHFO_ton (integer ai_column, decimal ad_HFO_ton)
public function decimal of_getHFO_ton (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setHFO_expenses (integer ai_column, decimal ad_HFO_expenses)
public function decimal of_getHFO_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setDO_ton (integer ai_column, decimal ad_DO_ton)
public function decimal of_getDO_ton (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setDO_expenses (integer ai_column, decimal ad_DO_expenses)
public function decimal of_getDO_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setGO_ton (integer ai_column, decimal ad_GO_ton)
public function decimal of_getGO_ton (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setGO_expenses (integer ai_column, decimal ad_GO_expenses)
public function decimal of_getGO_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_get_vessel_array (ref s_vessel_voyage_list astr_vessel_voyage_list)
public function integer of_get_result_type ()
public function long of_get_nr_of_voyages ()
public function decimal of_getgross_freight (integer ai_column, boolean ab_vv_or_accumulated)
public function integer of_getcurrent_vessel_nr ()
public function string of_getcurrent_vessel_name ()
public function string of_getcurrent_vessel_group_name ()
public function string of_getcurrent_profit_center_name ()
public function string of_getcurrent_voyage_nr ()
public function decimal of_getcurrent_calc_id ()
public function integer of_getcurrent_voyage_finished ()
public function integer of_getcurrent_voyage_type ()
public function integer of_getcurrent_tcowner ()
public function string of_getcurrent_voyage_type_letter ()
public function decimal of_getbunker_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public subroutine of_setbunker_expenses (integer ai_column, decimal ad_bunker_expenses)
public function integer of_init_calcmemo_port_exp (datastore ads_port_exp)
public function decimal of_get_days_between (datetime adt_start, datetime adt_end)
public subroutine of_setcm_report_data (ref datawindow adw)
public function boolean of_get_port_match ()
public subroutine of_reset_vas_data ()
public function decimal of_get_tc_out_off_service_est_act ()
public function integer of_get_vas_year ()
public subroutine of_set_current_tco_voyage_nr (string as_voyage)
public subroutine of_setcm_tc_report_data (datawindow adw)
public function boolean of_exists_all_frt ()
public function datetime of_tc_get_tc_end_date (string as_type)
public function datetime of_getcurrent_startdate ()
public function integer of_fill_vessel_array (integer ai_result_type, decimal ad_keys[], s_vessel_voyage_list astr_vessel_voyage[], integer ai_year_yy)
public function decimal of_getoff_service_days (integer ai_column, boolean ab_vv_or_accumulated)
public function datetime of_getcommenced_date ()
public subroutine of_setother_days (integer ai_column, decimal ad_other_days)
public function decimal of_getother_days (integer ai_column, boolean ab_vv_or_accumulated)
public function datetime of_getcurrent_enddate ()
public function integer of_setvoyage_enddate ()
public function integer of_setcommenced_date ()
public subroutine of_setreport_data (ref datawindow adw)
public subroutine of_accumulate_vas_data ()
public subroutine of_setreport_header_data (integer ai_result_type, ref datawindow adw)
public subroutine of_setreport_header_route (ref datawindow adw)
public subroutine of_setreport_header_atobviac_route (ref datawindow adw)
public subroutine of_setlshfo_ton (integer ai_column, decimal ad_lshfo_ton)
public subroutine of_setlshfo_expenses (integer ai_column, decimal ad_lshfo_expenses)
public function decimal of_getlshfo_ton (integer ai_column, boolean ab_vv_or_accumulated)
public function decimal of_getlshfo_expenses (integer ai_column, boolean ab_vv_or_accumulated)
public function long of_get_tccontract ()
public function string of_getcurrent_vessel_ref_nr ()
protected subroutine of_modify_commenced_date (datetime adt_commenced_date)
public subroutine documentation ()
public subroutine of_setaccruals_reportdata (ref datawindow adw, s_vessel_voyage_list ast_vesseldata)
public subroutine of_set_misc_details_var (string as_income_details, string as_expense_details, decimal ad_misc_exp_est_act, decimal ad_misc_inc_est_act, decimal ad_misc_exp_act, decimal ad_misc_inc_act, decimal ad_off_service_est_act)
public subroutine of_setaccruals_tc_reportdata (ref datawindow adw, s_vessel_voyage_list ast_vesseldata)
end prototypes

public subroutine of_init_vessel_array ();sds_vessel_voyage_list = CREATE datastore
sds_vessel_voyage_list.DataObject = "d_vessel_voyage_list" 
return
end subroutine

public subroutine of_set_current_index (long al_index_nr);sl_current_index = al_index_nr
Return
end subroutine

public subroutine of_destroy_vessel_array ();DESTROY sds_vessel_voyage_list
Return
end subroutine

public subroutine of_reset_accumulated_array ();integer li_x

for li_x = 1 to 5
	sstr_vas_accumulated_data[li_x].Gross_freight = 0
	sstr_vas_accumulated_data[li_x].Demurrage = 0
	sstr_vas_accumulated_data[li_x].broker_commission = 0
	sstr_vas_accumulated_data[li_x].Port_expenses = 0
	sstr_vas_accumulated_data[li_x].Bunker_expenses = 0
	sstr_vas_accumulated_data[li_x].Misc_expenses = 0
	sstr_vas_accumulated_data[li_x].drc = 0
	sstr_vas_accumulated_data[li_x].loading_days = 0
	sstr_vas_accumulated_data[li_x].discharge_days = 0
	sstr_vas_accumulated_data[li_x].load_discharge_days = 0
	sstr_vas_accumulated_data[li_x].bunkering_days = 0
	sstr_vas_accumulated_data[li_x].canal_days = 0
	sstr_vas_accumulated_data[li_x].docking_days = 0
	sstr_vas_accumulated_data[li_x].loaded_days = 0
	sstr_vas_accumulated_data[li_x].ballast_days = 0
	sstr_vas_accumulated_data[li_x].other_days = 0
	sstr_vas_accumulated_data[li_x].idle_days = 0
	sstr_vas_accumulated_data[li_x].off_service_days = 0
	sstr_vas_accumulated_data[li_x].HFO_ton = 0
	sstr_vas_accumulated_data[li_x].HFO_expenses = 0
	sstr_vas_accumulated_data[li_x].DO_ton = 0
	sstr_vas_accumulated_data[li_x].DO_expenses = 0
	sstr_vas_accumulated_data[li_x].GO_ton = 0
	sstr_vas_accumulated_data[li_x].GO_expenses = 0
	sstr_vas_accumulated_data[li_x].LSHFO_ton = 0
	sstr_vas_accumulated_data[li_x].LSHFO_expenses = 0
next

Return
end subroutine

public subroutine of_set_tcin_or_apm ();IF of_GetCurrent_tcowner() > 0 THEN
	sb_tcin_or_apm = TRUE
ELSE
	sb_tcin_or_apm = FALSE
END IF

return
end subroutine

public function boolean of_get_tcin_or_apm ();Return sb_tcin_or_apm
end function

public subroutine of_set_port_match ();/********************************************************************
   of_set_port_match( )
<DESC>   
	Tests to see if the port/purpose matches so we get the correct port expenses later
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	n/a
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

s_vessel_voyage_list lstr_list
string ls_result
n_portvalidator lnv_validator
u_tramos_nvo 				uo_tram  /* support for BP calc */

// Check if there is match between itinerary and proceed. If yes then 
// set sb_port_match = TRUE, else if no match (or error) then sb_port_match = FALSE
// If voyage type = T/C Out, match = FALSE (no calculation data)

of_get_vessel_array(lstr_list)

if lstr_list.voyage_type = 2 then
	sb_port_match = false
else
	if f_AtoBviaC_used (lstr_list.vessel_nr,lstr_list.voyage_nr) then
		/* advanced port validator */			
		lnv_validator = create n_portvalidator
		if lnv_validator.of_start( "REPORTVAS", lstr_list.vessel_nr, lstr_list.voyage_nr, 2) = c#return.Failure then
			sb_port_match = false
		else
			sb_port_match = true
		end if
		destroy lnv_validator
	else
		uo_tram = CREATE u_tramos_nvo
		ls_result = uo_tram.uf_check_proceed_itenerary(lstr_list.vessel_nr,lstr_list.voyage_nr,FALSE)
		if ls_result = "-1" or ls_result = "0" then
			sb_port_match = false
		else
			sb_port_match = true
		end if
		destroy uo_tram
	end if
end if	
return

end subroutine

public subroutine of_setgross_freight (integer ai_column, decimal ad_gross_freight);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetGross_Freight
//
//	Purpose:		This function sets the Gross Freight in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_gross_freight  Gross Freight Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].Gross_Freight = ad_gross_freight
Return
end subroutine

public subroutine of_setdemurrage (integer ai_column, decimal ad_demurrage);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDemurrage
//
//	Purpose:		This function sets the Demurrage in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_demurrage  Demurrage Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].demurrage = ad_demurrage
Return
end subroutine

public function decimal of_getdemurrage (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDemurrage
//
//	Purpose:		Returns the Demurrage amount either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Demurrage
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].Demurrage
ELSE
	Return sstr_vas_accumulated_data[ai_column].Demurrage
END IF
end function

public subroutine of_setbroker_commission (integer ai_column, decimal ad_broker_commission);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetBroker_Commission
//
//	Purpose:		This function sets the Broker Commission in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_broker_commission  Broker Commission Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].broker_commission = ad_broker_commission
Return
end subroutine

public function decimal of_getbroker_commission (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetBroker_Commission
//
//	Purpose:		Returns the Broker Commission either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Broker Commission
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].Broker_Commission
ELSE
	Return sstr_vas_accumulated_data[ai_column].Broker_Commission
END IF
end function

public subroutine of_setport_expenses (integer ai_column, decimal ad_port_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetPort_Expenses
//
//	Purpose:		This function sets the Port Expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_port_expenses  Port Expenses Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].port_expenses = ad_port_expenses
Return
end subroutine

public function decimal of_getport_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetPort_Expenses
//
//	Purpose:		Returns the Port Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Port Expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].port_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].port_expenses
END IF
end function

public subroutine of_setmisc_expenses (integer ai_column, decimal ad_misc_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetMisc_expenses
//
//	Purpose:		This function sets the Misc. expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_misc_expenses  Misc. expenses Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].misc_expenses = ad_misc_expenses
Return
end subroutine

public function decimal of_getmisc_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetMisc_expenses
//
//	Purpose:		Returns the Misc. Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Misc. Expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].misc_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].misc_expenses
END IF
end function

public subroutine of_setdrc (integer ai_column, decimal ad_drc);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDRC
//
//	Purpose:		This function sets the Daily Running Cost in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_drc  Daily Running Cost Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].drc = ad_drc
Return
end subroutine

public function decimal of_getdrc (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDRC
//
//	Purpose:		Returns the Daily Running Cost either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Daily Running Cost
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].drc
ELSE
	Return sstr_vas_accumulated_data[ai_column].drc
END IF
end function

public subroutine of_setloading_days (integer ai_column, decimal ad_loading_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetLoading_Days
//
//	Purpose:		This function sets the Loading Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_loading_days  Loading Days
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].loading_days = ad_loading_days
Return
end subroutine

public function decimal of_getloading_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetLoading_Days
//
//	Purpose:		Returns the Loading Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Loading Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].loading_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].loading_days
END IF
end function

public subroutine of_setdischarge_days (integer ai_column, decimal ad_discharge_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDischarge_Days
//
//	Purpose:		This function sets the Discharge Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_discharge_days  Discharge Days
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].discharge_days = ad_discharge_days
Return
end subroutine

public function decimal of_getdischarge_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDischarge_Days
//
//	Purpose:		Returns the Discharge Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Discharge Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].discharge_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].discharge_days
END IF
end function

public subroutine of_setload_discharge_days (integer ai_column, decimal ad_load_discharge_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetLoad_Discharge_Days
//
//	Purpose:		This function sets the Load/Discharge Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_load_discharge_days  Number of days
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].load_discharge_days = ad_load_discharge_days
Return
end subroutine

public function decimal of_getload_discharge_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetLoad_Discharge_Days
//
//	Purpose:		Returns the Load_Discharge Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Load_Discharge Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].load_discharge_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].load_discharge_days
END IF
end function

public subroutine of_setbunkering_days (integer ai_column, decimal ad_bunkering_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetBunkering_Days
//
//	Purpose:		This function sets the Bunkering Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_bunkering_days  Number of days bunkering
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].bunkering_days = ad_bunkering_days
Return
end subroutine

public function decimal of_getbunkering_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetBunkering_Days
//
//	Purpose:		Returns the Bunkering Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Bunkering Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].bunkering_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].bunkering_days
END IF
end function

public subroutine of_setcanal_days (integer ai_column, decimal ad_canal_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetCanal_Days
//
//	Purpose:		This function sets the Canal days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_canal_days  Number of days in canal
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].canal_days = ad_canal_days
Return
end subroutine

public function decimal of_getcanal_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetCanal_Days
//
//	Purpose:		Returns the Canal Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Canal Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].canal_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].canal_days
END IF
end function

public subroutine of_setdocking_days (integer ai_column, decimal ad_docking_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDocking_Days
//
//	Purpose:		This function sets the Docking Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_docking_days  Number of days in dock
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].docking_days = ad_docking_days
Return
end subroutine

public function decimal of_getdocking_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDocking_Days
//
//	Purpose:		Returns the Docking Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Docking Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].docking_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].docking_days
END IF
end function

public subroutine of_setloaded_days (integer ai_column, decimal ad_loaded_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetLoaded_Days
//
//	Purpose:		This function sets the Loaded Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_loaded_days  Number of days loaded
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].loaded_days = ad_loaded_days
Return
end subroutine

public function decimal of_getloaded_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetLoaded_Days
//
//	Purpose:		Returns the Loaded Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Loaded Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].loaded_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].loaded_days
END IF
end function

public subroutine of_setballast_days (integer ai_column, decimal ad_ballast_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetBallast_Days
//
//	Purpose:		This function sets the Ballast Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_ballast_days  Number of days ballasted
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].ballast_days = ad_ballast_days
Return
end subroutine

public function decimal of_getballast_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetBallast_Days
//
//	Purpose:		Returns the Ballast Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Ballast Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].ballast_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].ballast_days
END IF
end function

public subroutine of_setidle_days (integer ai_column, decimal ad_idle_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetIdle_Days
//
//	Purpose:		This function sets the Idle Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_idle_days  Number of idle days
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].idle_days = ad_idle_days
Return
end subroutine

public function decimal of_getidle_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetIdle_Days
//
//	Purpose:		Returns the Idle Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Idle Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].idle_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].idle_days
END IF
end function

public subroutine of_setoff_service_days (integer ai_column, decimal ad_off_service_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetOff_Service_Days
//
//	Purpose:		This function sets the Off Service Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_off_service_days  Number of Off Service Days
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].off_service_days = ad_off_service_days
Return
end subroutine

public subroutine of_setHFO_ton (integer ai_column, decimal ad_HFO_ton);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetHFO_ton
//
//	Purpose:		This function sets the Heavy Fuel Oil Ton in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_HFO_ton  Number of ton Heavy Fuel Oil used
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].HFO_ton = ad_HFO_ton
Return
end subroutine

public function decimal of_getHFO_ton (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetHFO_ton
//
//	Purpose:		Returns the HFO ton either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, HFO ton
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].HFO_ton
ELSE
	Return sstr_vas_accumulated_data[ai_column].HFO_ton
END IF
end function

public subroutine of_setHFO_expenses (integer ai_column, decimal ad_HFO_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetHFO_expenses
//
//	Purpose:		This function sets the Heavy Fuel Oil Expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_HFO_expenses Heavy Fuel Oil used in USD
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].HFO_expenses = ad_HFO_expenses
Return
end subroutine

public function decimal of_getHFO_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetHFO_Expenses
//
//	Purpose:		Returns the HFO Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, HFO Expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].HFO_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].HFO_expenses
END IF
end function

public subroutine of_setDO_ton (integer ai_column, decimal ad_DO_ton);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDO_ton
//
//	Purpose:		This function sets the Diesel Oil Ton in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_DO_ton  Number of ton Diesel Oil used
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].DO_ton = ad_DO_ton
Return
end subroutine

public function decimal of_getDO_ton (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDO_ton
//
//	Purpose:		Returns the Diesel Oil ton either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, DO ton
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].DO_ton
ELSE
	Return sstr_vas_accumulated_data[ai_column].DO_ton
END IF
end function

public subroutine of_setDO_expenses (integer ai_column, decimal ad_DO_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetDO_expenses
//
//	Purpose:		This function sets the Diesel Oil Expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_DO_expenses Diesel Oil used in USD
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].DO_expenses = ad_DO_expenses
Return
end subroutine

public function decimal of_getDO_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetDO_expenses
//
//	Purpose:		Returns the Diesel Oil Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, DO expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].DO_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].DO_expenses
END IF
end function

public subroutine of_setGO_ton (integer ai_column, decimal ad_GO_ton);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetGO_ton
//
//	Purpose:		This function sets the Gas Oil Ton in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_GO_ton  Number of ton Gas Oil used
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].GO_ton = ad_GO_ton
Return
end subroutine

public function decimal of_getGO_ton (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetGO_ton
//
//	Purpose:		Returns the Gas Oil ton either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, GO ton
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].GO_ton
ELSE
	Return sstr_vas_accumulated_data[ai_column].GO_ton
END IF
end function

public subroutine of_setGO_expenses (integer ai_column, decimal ad_GO_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetGO_expenses
//
//	Purpose:		This function sets the Gas Oil Expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_GO_expenses Gas Oil used in USD
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].GO_expenses = ad_GO_expenses
Return
end subroutine

public function decimal of_getGO_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetGO_Expenses
//
//	Purpose:		Returns the Gas Oil Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, GO expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].GO_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].GO_expenses
END IF
end function

public subroutine of_get_vessel_array (ref s_vessel_voyage_list astr_vessel_voyage_list);  
astr_vessel_voyage_list.vessel_nr = &
 		sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Vessel_nr")

astr_vessel_voyage_list.voyage_type = &
 		sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Voyage_type")

astr_vessel_voyage_list.voyage_nr = &
		sds_vessel_voyage_list.GetItemString(sl_current_index,"Voyage_nr")

astr_vessel_voyage_list.calc_id = &
 		sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Calc_id")

astr_vessel_voyage_list.voyage_finished = &
	 sds_vessel_voyage_list.GetItemnumber(sl_current_index,"voyage_finished")

astr_vessel_voyage_list.tcowner_nr = &
	 sds_vessel_voyage_list.GetItemnumber(sl_current_index,"tcowner_nr")

astr_vessel_voyage_list.period_startdate = &
	 sds_vessel_voyage_list.GetItemdatetime(sl_current_index,"period_startdate")

astr_vessel_voyage_list.period_enddate = &
	 sds_vessel_voyage_list.GetItemdatetime(sl_current_index,"period_enddate")

astr_vessel_voyage_list.demunforwarded = &
	 sds_vessel_voyage_list.GetItemnumber(sl_current_index,"demunforwarded")

Return
end subroutine

public function integer of_get_result_type ();Return si_result_type
end function

public function long of_get_nr_of_voyages ();///////////////////////////////////////////////////////////////////
//
//	Function:	of_get_nr_of_voyages
//
//	Purpose:		Returns the number of voyages to calculate
//
//	Scope:		public
//
//	Arguments:	none
//
//	Returns:		long, number of voyages
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

Return sl_nr_of_voyages
end function

public function decimal of_getgross_freight (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetGross_Freight
//
//	Purpose:		Returns the Gross Freight either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Gross Freight
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].Gross_Freight
ELSE
	Return sstr_vas_accumulated_data[ai_column].Gross_Freight
END IF
end function

public function integer of_getcurrent_vessel_nr ();Return sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Vessel_nr")
end function

public function string of_getcurrent_vessel_name ();integer li_vessel_nr
string ls_vessel_name

li_vessel_nr = sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Vessel_nr")

SELECT VESSELS.VESSEL_NAME  
	INTO :ls_vessel_name  
   FROM VESSELS  
   WHERE VESSELS.VESSEL_NR = :li_vessel_nr   ;
	
COMMIT;

Return ls_vessel_name

end function

public function string of_getcurrent_vessel_group_name ();integer li_vessel_nr
string ls_shiptype_name

li_vessel_nr = sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Vessel_nr")

SELECT CAL_VEST.CAL_VEST_TYPE_NAME  
	INTO :ls_shiptype_name  
   FROM CAL_VEST,    VESSELS  
   WHERE CAL_VEST.CAL_VEST_TYPE_ID = VESSELS.CAL_VEST_TYPE_ID 
   AND 	VESSELS.VESSEL_NR = :li_vessel_nr   ;
	
COMMIT;

Return ls_shiptype_name
end function

public function string of_getcurrent_profit_center_name ();integer li_vessel_nr
string ls_profit_center_name

li_vessel_nr = sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Vessel_nr")

SELECT PROFIT_C.PC_NAME  
	INTO :ls_profit_center_name  
   FROM PROFIT_C,    VESSELS  
   WHERE ( PROFIT_C.PC_NR = VESSELS.PC_NR and
			VESSELS.VESSEL_NR = :li_vessel_nr)   ;
	
COMMIT;

Return ls_profit_center_name
end function

public function string of_getcurrent_voyage_nr ();Return sds_vessel_voyage_list.GetItemString(sl_current_index,"Voyage_nr")

end function

public function decimal of_getcurrent_calc_id ();Return sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Calc_id")
end function

public function integer of_getcurrent_voyage_finished ();Return sds_vessel_voyage_list.GetItemNumber(sl_current_index,"voyage_finished")
end function

public function integer of_getcurrent_voyage_type ();Return sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Voyage_type")
end function

public function integer of_getcurrent_tcowner ();Return sds_vessel_voyage_list.GetItemNumber(sl_current_index,"tcowner_nr")
end function

public function string of_getcurrent_voyage_type_letter ();CHOOSE CASE sds_vessel_voyage_list.GetItemNumber(sl_current_index,"Voyage_type")
	CASE 1
		Return "S"
	CASE 2
		Return "T"
	CASE 3
		Return "P"
	CASE 4
		Return "O"
	CASE 5
		Return "II"
	CASE 6
		Return "L"
	CASE 7
		Return "I"
END CHOOSE
end function

public function decimal of_getbunker_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetBunker_expenses
//
//	Purpose:		Returns the Bunker Expenses either for a single Vessel Voyage
//					or from accumulated data structure.
//					Bunker Expenses is less Idle units and Off Service units
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Bunker. Expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].bunker_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].bunker_expenses
END IF
end function

public subroutine of_setbunker_expenses (integer ai_column, decimal ad_bunker_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetBunker_expenses
//
//	Purpose:		This function sets the Bunker expenses in a shared structure
//					for a Single Vessel Voyage
//					Bunker Expenses is less Idle Units and Off Service Units
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_misc_expenses  Misc. expenses Amount
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 16/04-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].bunker_expenses = ad_bunker_expenses
Return
end subroutine

public function integer of_init_calcmemo_port_exp (datastore ads_port_exp);
sds_calcmemo_port_exp = CREATE Datastore
sds_calcmemo_port_exp.DataObject = ads_port_exp.DataObject
sds_calcmemo_port_exp.Object.Data = ads_port_exp.Object.Data

Return 1

end function

public function decimal of_get_days_between (datetime adt_start, datetime adt_end);decimal ld_minutes

ld_minutes = (daysafter(date(adt_start),date(adt_end)) * 24 * 60)
ld_minutes = ld_minutes -       (hour( time(adt_start)) * 60) - minute(time(adt_start)) - (second(time(adt_start))/60)
ld_minutes = ld_minutes +       (hour( time(adt_end)) * 60) + minute(time(adt_end)) + (second(time(adt_end))/60)

return ld_minutes / 60 / 24
end function

public subroutine of_setcm_report_data (ref datawindow adw);String ls_result
long ll_counter, ll_no_of_ports

/* Freight */
ls_result = string( round (of_GetGross_Freight( 4, TRUE ) ,0 ))
adw.Object.est_act_freight.Expression = ls_result 
ls_result = string( round (of_GetGross_Freight( 5, TRUE ) ,0 ))
adw.Object.act_freight.Expression = ls_result 

/* Demurrage / Despatch */
ls_result = string( round (of_GetDemurrage( 4, TRUE ) ,0 ))
adw.Object.est_act_dem_des.Expression = ls_result 
ls_result = string( round (of_GetDemurrage( 5, TRUE ) ,0 ))
adw.Object.act_dem_des.Expression = ls_result 

/* Broker Commission */
ls_result = string( round (of_GetBroker_Commission( 4, TRUE ) ,0 ))
adw.Object.est_act_broker_comm.Expression = ls_result 
ls_result = string( round (of_GetBroker_Commission( 5, TRUE ) ,0 ))
adw.Object.act_broker_comm.Expression = ls_result 

/* Port Expenses for each port */
IF of_Get_Port_Match() THEN
	ll_no_of_ports = sds_calcmemo_port_exp.RowCount()
	FOR ll_counter = 1 TO ll_no_of_ports
		adw.InsertRow(0)
		adw.SetItem(ll_counter,"port_exp","PORT EXP")
		adw.SetItem(ll_counter,"port_name", &
						sds_calcmemo_port_exp.GetItemString(ll_counter,"proceed_port_code"))
		adw.SetItem(ll_counter,"purpose_code", &
						sds_calcmemo_port_exp.GetItemString(ll_counter,"purpose_code"))
		adw.SetItem(ll_counter,"est_act_port_exp", &
						sds_calcmemo_port_exp.GetItemDecimal(ll_counter,"amount"))
		adw.SetItem(ll_counter,"act_port_exp", &
						sds_calcmemo_port_exp.GetItemDecimal(ll_counter,"amount_usd"))
	NEXT
ELSE
	adw.InsertRow(0)
	adw.SetItem(1,"port_exp","PORT EXP")
	IF of_GetCurrent_voyage_type() = 2 THEN
		adw.SetItem(1,"port_name", " ")
	ELSE	
		adw.SetItem(1,"port_name", "no match")
	END IF
	adw.SetItem(1,"est_act_port_exp", of_GetPort_expenses(4,TRUE))
	adw.SetItem(1,"act_port_exp", of_GetPort_expenses(5,TRUE))
END IF	

/* Bunker Expenses */
ls_result = string( round (of_GetBunker_Expenses( 4, TRUE ) ,0 ))
adw.Object.est_act_bunker_exp.Expression = ls_result 
ls_result = string( round (of_GetBunker_Expenses( 5, TRUE ) ,0 ))
adw.Object.act_bunker_exp.Expression = ls_result 

/* Miscellanous Expenses */
ls_result = string( round (of_GetMisc_Expenses( 4, TRUE ) ,0 ))
adw.Object.est_act_misc_exp.Expression = ls_result 
ls_result = string( round (of_GetMisc_Expenses( 5, TRUE ) ,0 ))
adw.Object.act_misc_exp.Expression = ls_result 

DESTROY sds_calcmemo_port_exp
Return
end subroutine

public function boolean of_get_port_match ();Return sb_port_match
end function

public subroutine of_reset_vas_data ();integer li_x

for li_x = 1 to 5
	sstr_vas_data[li_x].Gross_freight = 0
	sstr_vas_data[li_x].Demurrage = 0
	sstr_vas_data[li_x].broker_commission = 0
	sstr_vas_data[li_x].Port_expenses = 0
	sstr_vas_data[li_x].Bunker_expenses = 0
	sstr_vas_data[li_x].Misc_expenses = 0
	sstr_vas_data[li_x].drc = 0
	sstr_vas_data[li_x].loading_days = 0
	sstr_vas_data[li_x].discharge_days = 0
	sstr_vas_data[li_x].load_discharge_days = 0
	sstr_vas_data[li_x].bunkering_days = 0
	sstr_vas_data[li_x].canal_days = 0
	sstr_vas_data[li_x].docking_days = 0
	sstr_vas_data[li_x].loaded_days = 0
	sstr_vas_data[li_x].ballast_days = 0
	sstr_vas_data[li_x].other_days = 0
	sstr_vas_data[li_x].idle_days = 0
	sstr_vas_data[li_x].off_service_days = 0
	sstr_vas_data[li_x].HFO_ton = 0
	sstr_vas_data[li_x].HFO_expenses = 0
	sstr_vas_data[li_x].DO_ton = 0
	sstr_vas_data[li_x].DO_expenses = 0
	sstr_vas_data[li_x].GO_ton = 0
	sstr_vas_data[li_x].GO_expenses = 0
	sstr_vas_data[li_x].LSHFO_ton = 0
	sstr_vas_data[li_x].LSHFO_expenses = 0
next

// Reset TC OUT variables
ss_income_details = ""
ss_expense_details = ""
sd_misc_exp_est_act = 0
sd_misc_inc_est_act = 0
sd_misc_exp_act = 0
sd_misc_inc_act = 0
sd_off_service_est_act = 0
Return
end subroutine

public function decimal of_get_tc_out_off_service_est_act ();Return sd_off_service_est_act
end function

public function integer of_get_vas_year ();Return si_vas_year
end function

public subroutine of_set_current_tco_voyage_nr (string as_voyage);ss_current_old_tco_voyage = as_voyage
end subroutine

public subroutine of_setcm_tc_report_data (datawindow adw);String ls_result

adw.InsertRow(0)

/* Freight */
ls_result = string( round (of_GetGross_Freight( 4, TRUE ) ,0 ))
adw.Object.est_act_freight.Expression = ls_result 
ls_result = string( round (of_GetGross_Freight( 5, TRUE ) ,0 ))
adw.Object.act_freight.Expression = ls_result 

/* Miscellanous Income */
adw.object.demlabel.text = "MISC. INCOME:"
ls_result = string( round (of_getdemurrage( 4, TRUE ) ,0 ))
adw.Object.est_act_dem_des.Expression = ls_result 
ls_result = string( round (of_getdemurrage( 5, TRUE ) ,0 ))
adw.Object.act_dem_des.Expression = ls_result 

/* Broker Commission */
ls_result = string( round (of_GetBroker_Commission( 4, TRUE ) ,0 ))
adw.Object.est_act_broker_comm.Expression = ls_result 
ls_result = string( round (of_GetBroker_Commission( 5, TRUE ) ,0 ))
adw.Object.act_broker_comm.Expression = ls_result 

/* Bunker Expenses */
adw.object.bunkerlabel.text = "BUNKER (Off Service):"
ls_result = string( round (of_getbunker_expenses( 4, TRUE ) ,0 ))
adw.Object.est_act_bunker_exp.Expression = ls_result 
ls_result = string( round (of_getbunker_expenses( 5, TRUE ) ,0 ))
adw.Object.act_bunker_exp.Expression = ls_result 

/* Miscellanous Expenses */
adw.object.misclabel.text = "MISC. EXPENSES:"
ls_result = string( round (of_getmisc_expenses( 4, TRUE ) ,0 ))
adw.Object.est_act_misc_exp.Expression = ls_result 
ls_result = string( round (of_getmisc_expenses( 5, TRUE ) ,0 ))
adw.Object.act_misc_exp.Expression = ls_result 

/* Extended Calc Memo - Estimated column */
if adw.dataObject = "d_vas_calc_memo_extended" then
	/* Freight */
	ls_result = string( round (of_GetGross_Freight( 2, TRUE ) ,0 ))
	adw.Object.est_freight.Expression = ls_result 
	
	/* Miscellanous Income */
	ls_result = string( round (of_getdemurrage( 2, TRUE ) ,0 ))
	adw.Object.est_dem_des.Expression = ls_result 
	
	/* Broker Commission */
	ls_result = string( round (of_GetBroker_Commission( 2, TRUE ) ,0 ))
	adw.Object.est_broker_comm.Expression = ls_result 
	
	/* Bunker Expenses */
	ls_result = string( round (of_getbunker_expenses( 2, TRUE ) ,0 ))
	adw.Object.est_bunker_exp.Expression = ls_result 
	
	/* Miscellanous Expenses */
	ls_result = string( round (of_getmisc_expenses( 2, TRUE ) ,0 ))
	adw.Object.est_misc_exp.Expression = ls_result 
end if

Return
end subroutine

public function boolean of_exists_all_frt ();long ll_chart_nr,ll_claim_nr
boolean lb_found = TRUE
long ll_rows,ll_counter
Datastore lds_cp_charters
String ls_voyage_nr
Integer li_vessel_nr

lds_cp_charters = CREATE datastore
lds_cp_charters.DataObject = "d_cp_charters" 
lds_cp_charters.SetTransObject(SQLCA)
ll_rows = lds_cp_charters.Retrieve(of_GetCurrent_calc_id())
li_vessel_nr = of_GetCurrent_Vessel_nr()
ls_voyage_nr = of_GetCurrent_Voyage_nr()

// IF there is no CP in datastore, there has been an error. Then take from actual
If NOT(ll_rows > 0) THEN 
	DESTROY lds_cp_charters ;
	Return TRUE
END IF

// IF a CP charter has no FRT in operations, then return false.
FOR ll_counter = 1 TO ll_rows
	ll_chart_nr = lds_cp_charters.GetItemNumber(ll_counter,"chart_nr")
	SELECT CLAIMS.CLAIM_NR  
   INTO :ll_claim_nr  
   FROM CLAIMS  
   WHERE ( CLAIMS.VESSEL_NR = :li_vessel_nr ) AND  
         ( CLAIMS.VOYAGE_NR = :ls_voyage_nr ) AND  
         ( CLAIMS.CHART_NR = :ll_chart_nr ) AND  
         ( CLAIMS.CLAIM_TYPE = 'FRT' )   ;
	
	if sqlca.sqlcode <> 0 then 
		lb_found = FALSE
		exit
	end if	
	commit;
NEXT

DESTROY lds_cp_charters ;

return lb_found

end function

public function datetime of_tc_get_tc_end_date (string as_type);/* Local Vars */
datetime ldt_end_date, ldt_2nd_end_date, ldt_RED_dpt_dt, ldt_end_start
datetime ldt_tchire_cp_date, ldt_voyage_start, ldt_first_commenced_date, ldt_last_completed_date
string 	ls_year, ls_voyage_nr, ls_voyage_year
decimal 	ld_days_to_end_of_year, ld_days_to_completion, ld_calculated_days
Integer 	li_vessel_nr, li_voyage_year
long 		ll_chartID, ll_contractID
datetime ldt_redelivery, ldt_cpdate

ls_voyage_nr = of_getcurrent_voyage_nr()

li_vessel_nr = of_getcurrent_vessel_nr()

IF si_vas_year < 10 THEN 
	ls_voyage_year = "0" + String(si_vas_year)
else
	ls_voyage_year = String(si_vas_year)
end if
		
li_voyage_year = Integer("20" + ls_voyage_year)

/* This SECTION looks for a contract with same charterer, cpdate as the first one, 
	and that starts exactly the same time as the first one ends = extention to first contract 
	Only valid for TC-OUT contracts */

SELECT CHART_NR, TC_HIRE_CP_DATE
	INTO :ll_chartID, :ldt_cpdate
	FROM NTC_TC_CONTRACT
	WHERE CONTRACT_ID = :sl_tc_contractid;
COMMIT;

SELECT MAX(PERIODE_END)
	INTO :ldt_redelivery
	FROM NTC_TC_PERIOD
	WHERE CONTRACT_ID = :sl_tc_contractid;
COMMIT;

SELECT CONTRACT_ID 
	INTO :ll_contractID
	FROM NTC_TC_CONTRACT
	WHERE VESSEL_NR = :li_vessel_nr 
	AND TC_HIRE_IN = 0
	AND CHART_NR = :ll_chartID
	AND TC_HIRE_CP_DATE = :ldt_cpdate
	AND DELIVERY = :ldt_redelivery;
COMMIT;

// Get last periode for this year (Not end date as it can be next year xxxx 1/1 00:00
SELECT Max(NTC_TC_PERIOD.PERIODE_START)
INTO :ldt_end_start  
FROM NTC_TC_PERIOD  
WHERE ( NTC_TC_PERIOD.CONTRACT_ID = :sl_tc_contractid ) AND  
      (DatePart(Year,NTC_TC_PERIOD.PERIODE_START) = :li_voyage_year )   ;
Commit;

SELECT NTC_TC_PERIOD.PERIODE_END  
INTO :ldt_end_date  
FROM NTC_TC_PERIOD  
WHERE NTC_TC_PERIOD.PERIODE_START = :ldt_end_start AND
		NTC_TC_PERIOD.CONTRACT_ID = :sl_tc_contractid ;
Commit;

/* if there are several contracts get a new enddate from 2nd contract */
if NOT isNull(ll_contractID) and ll_contractID > 0 then
	SELECT max(NTC_TC_PERIOD.PERIODE_END)  
	INTO :ldt_2nd_end_date  
	FROM NTC_TC_PERIOD  
	WHERE (DatePart(Year,NTC_TC_PERIOD.PERIODE_START) = :li_voyage_year )  AND
			NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID ;
	Commit;
	if not isNull(ldt_2nd_end_date) then
		ldt_end_date = ldt_2nd_end_date
	end if
end if

sdt_tc_period_end_date = ldt_end_date

SELECT Max(POC.PORT_DEPT_DT)  
INTO :ldt_RED_dpt_dt  
FROM POC  
WHERE ( POC.VESSEL_NR = :li_vessel_nr ) AND  
      ( SUBSTRING(POC.VOYAGE_NR,1,5) = :ls_voyage_nr ) AND  
      ( POC.PURPOSE_CODE = "RED" )   ;
Commit;

IF IsDate(String(Date(ldt_RED_dpt_dt))) THEN ldt_end_date = ldt_RED_dpt_dt 

//Destroy luo_vas_tc_out;
return ldt_end_date

end function

public function datetime of_getcurrent_startdate ();return sdt_commenced_date
end function

public function integer of_fill_vessel_array (integer ai_result_type, decimal ad_keys[], s_vessel_voyage_list astr_vessel_voyage[], integer ai_year_yy);datastore lds_vessel_voyage
string ls_year, ls_voyage_nr, ls_vessel_ref_nr
long ll_teller, ll_upper, ll_vessel_nr, ll_rows_retrieved
integer li_voyage_type, li_voyage_finished, li_tcowner_nr
decimal {0} ld_calc_id

si_result_type = ai_result_type
lds_vessel_voyage = CREATE datastore
ls_year = string(ai_year_yy,"00")
si_vas_year = ai_year_yy
ll_upper = UpperBound(astr_vessel_voyage[])
sl_nr_of_voyages = ll_upper

CHOOSE CASE ai_result_type
	CASE 1, 10, 6, 7, 8, 11
		sds_vessel_voyage_list.object.data = astr_vessel_voyage[]
		FOR ll_teller = 1 TO ll_upper
			SELECT VOYAGES.VOYAGE_TYPE,	VOYAGES.CAL_CALC_ID, 
						VOYAGES.VOYAGE_FINISHED, VESSELS.TCOWNER_NR, VESSELS.VESSEL_REF_NR  
    			INTO :li_voyage_type, :ld_calc_id,
				 	  :li_voyage_finished, :li_tcowner_nr, :ls_vessel_ref_nr  
    			FROM VOYAGES, VESSELS  
   			WHERE ( VOYAGES.VESSEL_NR = :astr_vessel_voyage[ll_teller].vessel_nr ) AND  
         			( substring(VOYAGES.VOYAGE_NR,1,5) = :astr_vessel_voyage[ll_teller].voyage_nr ) AND
						( VOYAGES.VESSEL_NR = VESSELS.VESSEL_NR );
			IF SQLCA.SQLCode = 100 THEN
				MessageBox("Error - retrieving data","Error retrieving data from Voyages in function: of_fill_vessel_array")
				DESTROY lds_vessel_voyage
				return -1
			ELSE
				COMMIT;
			END IF
			sds_vessel_voyage_list.SetItem(ll_teller,"voyage_type",li_voyage_type)
			sds_vessel_voyage_list.SetItem(ll_teller,"calc_id",ld_calc_id)
			sds_vessel_voyage_list.SetItem(ll_teller,"voyage_finished",li_voyage_finished)
			sds_vessel_voyage_list.SetItem(ll_teller,"tcowner_nr",li_tcowner_nr)
			sds_vessel_voyage_list.SetItem(ll_teller,"vessel_ref_nr",ls_vessel_ref_nr)			
			astr_vessel_voyage[ll_teller].vessel_ref_nr = ls_vessel_ref_nr
		NEXT
	CASE 2
		lds_vessel_voyage.dataobject = "d_vessel_array_vas_report"
		lds_vessel_voyage.SetTransObject(SQLCA)
		ll_rows_retrieved = lds_vessel_voyage.Retrieve(ad_keys[], ls_year)
		IF ll_rows_retrieved > 0 THEN
			sds_vessel_voyage_list.object.data[1,1,ll_rows_retrieved,7] = lds_vessel_voyage.object.data[1,1,ll_rows_retrieved,7]
			sl_nr_of_voyages = sds_vessel_voyage_list.RowCount()
		END IF
	CASE 3
		lds_vessel_voyage.dataobject = "d_shiptype_array_vas_report"
		lds_vessel_voyage.SetTransObject(SQLCA)
		/* After implementation of CR #1227 we also need profitcenter, as same shiptypes can be 
		    used by many profitcenters */
		if isValid(w_super_vas_reports.uo_profit_centers.dw_right) then
			long ll_pcNr[]	 
			ll_upper = w_super_vas_reports.uo_profit_centers.dw_right.rowCount()
			for ll_teller = 1 to ll_upper
				ll_pcNr[ll_teller] = w_super_vas_reports.uo_profit_centers.dw_right.getItemNumber(ll_teller, "pc_nr")
			next
			ll_rows_retrieved = lds_vessel_voyage.Retrieve(ll_pcNr, ad_keys[], ls_year)
		else
			ll_rows_retrieved = 0
		end if
		IF ll_rows_retrieved > 0 THEN
			sds_vessel_voyage_list.object.data[1,1,ll_rows_retrieved,7] = lds_vessel_voyage.object.data[1,1,ll_rows_retrieved,7]
			sl_nr_of_voyages = sds_vessel_voyage_list.RowCount()
		END IF
	CASE 4
		lds_vessel_voyage.dataobject = "d_profitcenter_array_vas_report"
		lds_vessel_voyage.SetTransObject(SQLCA)
		ll_rows_retrieved = lds_vessel_voyage.Retrieve(ad_keys[], ls_year)
		IF ll_rows_retrieved > 0 THEN
			sds_vessel_voyage_list.object.data[1,1,ll_rows_retrieved,7] = lds_vessel_voyage.object.data[1,1,ll_rows_retrieved,7]
			sl_nr_of_voyages = sds_vessel_voyage_list.RowCount()
		END IF
	CASE 5
		lds_vessel_voyage.dataobject = "d_department_array_vas_report"
		lds_vessel_voyage.SetTransObject(SQLCA)
		ll_rows_retrieved = lds_vessel_voyage.Retrieve(ls_year)
		IF ll_rows_retrieved > 0 THEN
			sds_vessel_voyage_list.object.data[1,1,ll_rows_retrieved,7] = lds_vessel_voyage.object.data[1,1,ll_rows_retrieved,7]
			sl_nr_of_voyages = sds_vessel_voyage_list.RowCount()
		END IF
	CASE ELSE
		MessageBox("ERROR","Function of_fill_vessel_array failed! - Report Result Type unknown")
		DESTROY lds_vessel_voyage
		return -1
END CHOOSE

DESTROY lds_vessel_voyage
/* Set voyage finished for T/C Out voyages to true if alle voyages finished */
ll_upper = sds_vessel_voyage_list.Rowcount()
FOR ll_teller = 1 TO ll_upper
	li_voyage_type = sds_vessel_voyage_list.GetItemNumber(ll_teller,"voyage_type")
	IF li_voyage_type = 2 THEN
		ll_vessel_nr = sds_vessel_voyage_list.GetItemNumber(ll_teller,"vessel_nr")
		ls_voyage_nr = sds_vessel_voyage_list.GetItemString(ll_teller,"voyage_nr")
		
		// If VAS year are diff. from voyage nr. then th evoyage has been changed. Use old voy nr. here.
		IF Right(String(of_get_vas_year(),"00"),2) <> Left(ls_voyage_nr,2) THEN
			SELECT OLD_VOYAGE_NR
			INTO :ls_voyage_nr
			FROM VOYAGES
			WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
			Commit;
		END IF
		
		/* Check if there is a T/C periode created. If Not delete row */
		of_set_current_index(ll_teller)
		IF of_SetCommenced_date() = -1 THEN
			sds_vessel_voyage_list.DeleteRow(ll_teller)
			ll_teller --
			ll_upper --
			sl_nr_of_voyages --
		ELSE
			SELECT COUNT(VOYAGE_FINISHED)
				INTO :li_voyage_finished
				FROM VOYAGES
				WHERE VESSEL_NR = :ll_vessel_nr
			 	  AND SUBSTRING(VOYAGE_NR,1,5) = :ls_voyage_nr
				  AND VOYAGE_FINISHED = 0 ;
			COMMIT;
			IF li_voyage_finished > 0 THEN
				sds_vessel_voyage_list.SetItem(ll_teller,"voyage_finished",0)
			ELSE
				sds_vessel_voyage_list.SetItem(ll_teller,"voyage_finished",1)
			END IF
		END IF
	END IF
NEXT

Return 1
end function

public function decimal of_getoff_service_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetOff_Service_Days
//
//	Purpose:		Returns the Off Service Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Off Service Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].off_service_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].off_service_days
END IF
end function

public function datetime of_getcommenced_date ();return sdt_commenced_date
end function

public subroutine of_setother_days (integer ai_column, decimal ad_other_days);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetOther_Days
//
//	Purpose:		This function sets the Other Days in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_other_days  Number of days used on other purposes
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].other_days = ad_other_days
Return
end subroutine

public function decimal of_getother_days (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetOther_Days
//
//	Purpose:		Returns the Other Days either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, Other Days
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 25/03-98		1.0	REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].other_days
ELSE
	Return sstr_vas_accumulated_data[ai_column].other_days
END IF
end function

public function datetime of_getcurrent_enddate ();
return sdt_voyage_enddate
end function

public function integer of_setvoyage_enddate ();integer li_vessel_nr, li_finished
date ld_lastdayinmonth
datetime ldt_voyage_enddate, ldt_arrival_date, ldt_departure_date, ldt_dummy, ldt_est_voyage_enddate
decimal {4} ld_total_days, ld_delta_days
string ls_voyage_nr
mt_n_datefunctions lnv_datefunc


li_vessel_nr = of_GetCurrent_Vessel_Nr()
ls_voyage_nr = of_GetCurrent_Voyage_Nr()

CHOOSE CASE of_GetCurrent_Voyage_Type()
	CASE 2 /* T/C Out voyages */
		
		ldt_voyage_enddate = of_tc_get_tc_end_date("actual")
		IF ldt_voyage_enddate = ldt_dummy THEN 
				ldt_voyage_enddate = sdt_tc_period_end_date
		END IF

	CASE 7 /* Idle Days Voyage */
		
		SELECT MAX(POC_EST.PORT_ARR_DT)
    		INTO :ldt_arrival_date
    		FROM POC_EST  
 		 	WHERE ( POC_EST.VESSEL_NR = :li_vessel_nr ) 
			  AND ( POC_EST.VOYAGE_NR  = :ls_voyage_nr ) ;
		COMMIT;
		
		/* if voyage commenced is later than the date today use the commenced date to assist calculation of the end date..*/
		if today() < date(sdt_commenced_date) then
			ld_lastdayinmonth = date(string(lnv_datefunc.of_lastdayofmonth(date(sdt_commenced_date))) + "/" + string(month(date(sdt_commenced_date))) + "/" + string(year(date(sdt_commenced_date))))
		else	
			ld_lastdayinmonth = date(string(lnv_datefunc.of_lastdayofmonth(Today())) + "/" + string(month(Today())) + "/" + string(year(Today())))
		end if
		
		if isnull(ldt_arrival_date) then
			// set voyage enddate to last day in current month  ie 01/10/2011 00:00
			ldt_voyage_enddate =  datetime(relativedate(ld_lastdayinmonth,1))
		else
			if DaysAfter( today(),Date(ldt_arrival_date)) >= 0 then
				// set voyage enddate to last day in current month
				ldt_voyage_enddate =  datetime(relativedate(ld_lastdayinmonth,1))
			else
				ldt_voyage_enddate = ldt_arrival_date
			end if
		end if
		
	CASE ELSE /* All other voyage types */
		/* Find largest date of arrival and departure */
		
		
		SELECT MAX(POC_EST.PORT_ARR_DT), MAX(POC_EST.PORT_DEPT_DT)  
    		INTO :ldt_arrival_date, :ldt_departure_date
    		FROM POC_EST  
 		 	WHERE ( POC_EST.VESSEL_NR = :li_vessel_nr ) 
			  AND ( POC_EST.VOYAGE_NR  = :ls_voyage_nr ) ;
		COMMIT;
		if isnull(ldt_arrival_date) then
			SELECT MAX(POC.PORT_ARR_DT)  
				INTO :ldt_arrival_date
				FROM POC  
				WHERE ( POC.VESSEL_NR = :li_vessel_nr ) 
				  AND ( POC.VOYAGE_NR  = :ls_voyage_nr ) ;
			COMMIT;
		end if
		if isnull(ldt_departure_date) then
			SELECT MAX(POC.PORT_DEPT_DT)  
				INTO :ldt_departure_date
				FROM POC  
				WHERE ( POC.VESSEL_NR = :li_vessel_nr ) 
				  AND ( POC.VOYAGE_NR  = :ls_voyage_nr ) ;
			COMMIT;
		end if	
		IF ldt_arrival_date > ldt_departure_date THEN
			ldt_voyage_enddate = ldt_arrival_date
		ELSE
			ldt_voyage_enddate = ldt_departure_date
		END IF
		
	 	SELECT VOYAGES.VOYAGE_FINISHED
    	INTO :li_finished  
    	FROM VOYAGES  
   	WHERE ( VOYAGES.VESSEL_NR = :li_vessel_nr ) and 
				(VOYAGES.VOYAGE_NR = :ls_voyage_nr);				
		Commit;

		if li_finished <> 1 then
			ld_total_days = of_getloading_days(4,TRUE)
			ld_total_days += of_getdischarge_days(4,TRUE)
			ld_total_days += of_getload_discharge_days(4,TRUE)
			ld_total_days += of_getbunkering_days(4,TRUE)
			ld_total_days += of_getcanal_days(4,TRUE)
			ld_total_days += of_getdocking_days(4,TRUE)
			ld_total_days += of_getloaded_days(4,TRUE)
			ld_total_days += of_getballast_days(4,TRUE)
			ld_total_days += of_getother_days(4,TRUE)
			ld_total_days += of_getidle_days(4,TRUE)
			/* REM 29/12-2003 - added off-service days */
			ld_total_days += of_getoff_service_days(4, TRUE)
//			ldt_voyage_enddate = datetime(RelativeDate(Date(of_getcommenced_date()),ld_total_days))
//			changed by REM 24/11-2003 + corrected for secounds
			ldt_voyage_enddate = f_long2datetime(round((f_datetime2long(of_getcommenced_date())+(ld_total_days * 86400))/60,0)*60)
			/* REM 20/01-2004 - added code to look at new field estimated voyage end */
			SELECT EST_VOYAGE_END 
				INTO :ldt_est_voyage_enddate			
				FROM VOYAGES
				WHERE VESSEL_NR = :li_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr;
			COMMIT;
			if NOT IsNUll(ldt_est_voyage_enddate) then
				if ldt_voyage_enddate <> ldt_est_voyage_enddate then
					ld_delta_days = (f_datetime2long(ldt_est_voyage_enddate) - f_datetime2long(ldt_voyage_enddate)) / 86400 
					of_setother_days(4, of_getother_days(4,true) + ld_delta_days)
//					sstr_vas_accumulated_data[4].other_days = sstr_vas_accumulated_data[4].other_days + ld_delta_days					
					ldt_voyage_enddate = ldt_est_voyage_enddate
				end if
			end if	
			
	end if
				
END CHOOSE

sdt_voyage_enddate = ldt_voyage_enddate
return 1
end function

public function integer of_setcommenced_date ();///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetCommenced_Date
//
//	Purpose:		This function gets the dept date from the
//					last port on the previous voyage. If no previous voyage
//					arrival date from first port on this voyage.
//					If T/C out voyage type min. commenced date i rate periode
//					where periode covers first ports arrival date.
//					(if no periode 1/1-voyage_nr year)
//
//	Scope:		public
//
//	Arguments:	none
//
//	Returns:		integer, status
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 26/03-98		1.0	REM	Create function
// 02/07-98		1.0	BHO	Change the function to handle new voyage numbers.
// 03/02-10     21.08  RMO003 difference between lt and utc can be decimal number #1504							
///////////////////////////////////////////////////////////////////

string ls_last_voyage_nr = "Dummy"
datetime ldt_departure, ldt_tchire_cp_date, ldt_port_arr_date, ldt_testdate
Integer li_vessel_nr, li_rows, li_found = 0, li_voyage_year, li_counter, li_redelivery
String ls_voyage_nr, ls_voyage_year
Decimal {0} ld_contract
decimal	ld_calc_days, ld_voyage_days
decimal {1}	ld_lt_to_utc_difference
boolean	lb_local_time = true

li_vessel_nr = of_GetCurrent_Vessel_Nr()
ls_voyage_nr = of_GetCurrent_Voyage_Nr()

CHOOSE CASE of_GetCurrent_Voyage_Type()
	CASE 1,3,4,5,6,7

		SELECT DISTINCT min(POC.PORT_ARR_DT)
			INTO 	:ldt_departure
			FROM 	POC  
			WHERE ( POC.VESSEL_NR = :li_vessel_nr  ) 
			  AND ( POC.VOYAGE_NR = :ls_voyage_nr )  
			  AND ( POC.PORT_ARR_DT <> NULL );
	/* This was inserted by Regin Mortensen 27/12-03 to handle voyage startdate when 
	the only information registred in operation is proceeding or estimated POC(POC_EST) */			  

		/* If No ACTUAL POC try ESTIMATED */
		if isNull(ldt_departure) then
			SELECT DISTINCT min(POC_EST.PORT_ARR_DT)
				INTO 	:ldt_departure
				FROM 	POC_EST 
				WHERE ( POC_EST.VESSEL_NR = :li_vessel_nr  ) 
				  AND ( POC_EST.VOYAGE_NR = :ls_voyage_nr )  
				  AND ( POC_EST.PORT_ARR_DT <> NULL );
		end if
		
		/* IF No ESTIMATED POC find latest Actual and add calculated days */ 
		if isNull(ldt_departure) then
			string ls_test_voyage, ls_current_voyage
			ld_calc_days = 0
			ls_test_voyage = ls_voyage_nr
			do while isnull(ldt_departure)
				SELECT max(VOYAGES.VOYAGE_NR)  
					INTO :ls_current_voyage   
					FROM VOYAGES  
					WHERE ( VOYAGES.VESSEL_NR = :li_vessel_nr ) AND  
							( VOYAGES.VOYAGE_NR < :ls_test_voyage ) AND  
							( substring(VOYAGES.VOYAGE_NR,1,1) <> "9" )   ; /* to avoid old voyages */
				if isNull(ls_current_voyage) then
					ldt_departure = datetime(today())
					SELECT isnull(CAL_CALC.CAL_CALC_TOTAL_DAYS,0)  
					  	INTO :ld_voyage_days  
    					FROM CAL_CALC,	VOYAGES  
   					WHERE ( VOYAGES.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
         					( ( VOYAGES.VESSEL_NR = :li_vessel_nr ) AND  
         					( VOYAGES.VOYAGE_NR = :ls_current_voyage ) )   ;

					ld_calc_days += ld_voyage_days 
				else
					SELECT MAX(POC_EST.PORT_DEPT_DT)
						INTO 	:ldt_departure
						FROM 	POC_EST  
						WHERE ( POC_EST.VESSEL_NR = :li_vessel_nr  ) 
							AND ( POC_EST.VOYAGE_NR = :ls_current_voyage )  
							AND ( POC_EST.PORT_ARR_DT <> NULL );
					if isnull(ldt_departure) then 
						SELECT MAX(POC.PORT_DEPT_DT)
							INTO 	:ldt_departure
							FROM 	POC  
							WHERE ( POC.VESSEL_NR = :li_vessel_nr  ) 
								AND ( POC.VOYAGE_NR = :ls_current_voyage )  
								AND ( POC.PORT_ARR_DT <> NULL );
					end if
				end if
				ls_test_voyage = ls_current_voyage
			loop
			sdt_commenced_date = f_long2datetime(f_datetime2long(ldt_departure) + (ld_calc_days * 86400))
/* **************** End inserted 27/12-03 *********************/		
//		if sqlca.sqlcode=0 then
		else 
			integer li_number_of_rows
			datastore lds_voyage_numbers
			lds_voyage_numbers = create datastore
			lds_voyage_numbers.dataobject = "d_commenced_date"
			lds_voyage_numbers.settransobject(sqlca)
													
			li_number_of_rows=lds_voyage_numbers.retrieve(ldt_departure,li_vessel_nr)
			
			if li_number_of_rows = 0 then
							sdt_commenced_date = ldt_departure
			elseif li_number_of_rows > 0 then
				ls_last_voyage_nr=lds_voyage_numbers.getitemstring(1,1)
				//messagebox("TEST AF COMMENCED PORT", ls_last_voyage_nr)
					setNull(ldt_departure)
					SELECT VOYAGES.EST_VOYAGE_END  
    				INTO :ldt_departure  
    				FROM VOYAGES  
   				WHERE (VOYAGES.VESSEL_NR = :li_vessel_nr ) AND  
         			( VOYAGES.VOYAGE_NR = :ls_last_voyage_nr ) AND  
         			( VOYAGES.VOYAGE_FINISHED = 0 )   ;

					if isNull(ldt_departure) then  
						SELECT DISTINCT MAX(POC_EST.PORT_DEPT_DT)  
						INTO :ldt_departure
						FROM POC_EST 
						WHERE ( POC_EST.VESSEL_NR = :li_vessel_nr  ) 
						  AND (POC_EST.VOYAGE_NR  = :ls_last_voyage_nr ) 
						  AND (POC_EST.PORT_DEPT_DT <> null )  ;
					end if
					if isNull(ldt_departure) then  
						SELECT DISTINCT MAX(POC.PORT_DEPT_DT)  
						INTO :ldt_departure
						FROM POC  
						WHERE ( POC.VESSEL_NR = :li_vessel_nr  ) 
						  AND (POC.VOYAGE_NR  = :ls_last_voyage_nr ) 
						  AND (POC.PORT_DEPT_DT <> null )  ;
					end if
			END IF
			
			if sqlca.sqlcode=0 then
				sdt_commenced_date = ldt_departure
			else
				COMMIT;
				destroy(lds_voyage_numbers)
				RETURN -1
			end if
		end if
	CASE 2
		SELECT TOP 1 CONTRACT_ID, PORT_ARR_DT, LT_TO_UTC_DIFFERENCE 
			INTO :ld_contract, :ldt_port_arr_date, :ld_lt_to_utc_difference
			FROM POC
			WHERE (POC.VESSEL_NR = :li_vessel_nr)
			AND (SUBSTRING(POC.VOYAGE_NR,1,5) <= :ls_voyage_nr)
			AND (CHAR_LENGTH(POC.VOYAGE_NR) = 7)
			AND PURPOSE_CODE = "DEL"
			ORDER BY PORT_ARR_DT DESC, VOYAGE_NR DESC;

		IF SQLCA.SQLCode <> 0 THEN 
			COMMIT;
			RETURN -1
		END IF

		IF isNull(ld_contract) then
			commit;
			return -1
		end if

		IF isNull(ldt_port_arr_date) then
			commit;
			return -1
		end if

		IF si_vas_year < 10 THEN 
			ls_voyage_year = "0" + String(si_vas_year)
		else
			ls_voyage_year = string(si_vas_year)
		end if
		li_voyage_year = Integer("20" + ls_voyage_year) //Integer("20" + Left(ls_voyage_nr,2))
		
		/*  extra check if contract actually belongs to the voyage year, if not
			there is no delivery POC for this contract, and we can find contract id by year,
			but only if there is no redelivery for current contract in POC
			(implementation of change request # 966 */
			
		SELECT COUNT(*)
			INTO :li_redelivery
			FROM POC
			WHERE CONTRACT_ID = :ld_contract
			AND PURPOSE_CODE = "RED";
		commit;

		SELECT dateadd(mi, -1, MAX(NTC_TC_PERIOD.PERIODE_END)  )
			INTO :ldt_testdate 
			FROM NTC_TC_PERIOD  
			WHERE NTC_TC_PERIOD.CONTRACT_ID = :ld_contract ;
		commit;
		IF (year(date(ldt_testdate)) < li_voyage_year) and (li_redelivery < 1) then
			SELECT TOP 1 TP.CONTRACT_ID, TP.PERIODE_START 
				INTO :ld_contract, :ldt_port_arr_date
				FROM NTC_TC_PERIOD TP, NTC_TC_CONTRACT TC
				WHERE  TP.CONTRACT_ID = TC.CONTRACT_ID
				AND TC.VESSEL_NR = :li_vessel_nr
				AND TC.TC_HIRE_IN = 0
				AND datepart(yy, TP.PERIODE_START) = :li_voyage_year
				ORDER BY PERIODE_START DESC;
			commit;
			
			IF isNull(ld_contract) then
				commit;
				return -1
			end if
	
			IF isNull(ldt_port_arr_date) then
				commit;
				return -1
			end if
		end if
		/* End ChangeRequest #966 */
		
		SELECT LOCAL_TIME  INTO :lb_local_time FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ld_contract  ;
		if not lb_local_time then
			ldt_port_arr_date = f_long2datetime(f_datetime2long(ldt_port_arr_date ) + (ld_lt_to_utc_difference * 3600))
		end if
		
		SELECT COUNT(*)
		INTO :li_counter
		FROM NTC_TC_PERIOD
		WHERE PERIODE_START <= :ldt_port_arr_date
		AND PERIODE_END >= :ldt_port_arr_date
		AND CONTRACT_ID = :ld_contract;
		
		IF SQLCA.SQLCode <> 0 THEN 
			COMMIT;
			RETURN -1
		END IF
		
		IF li_counter < 1 then
			commit;
			return -1
		end if
				
		SELECT MIN(NTC_TC_PERIOD.PERIODE_START)  
			INTO :sdt_commenced_date 
			FROM NTC_TC_PERIOD  
			WHERE ( NTC_TC_PERIOD.CONTRACT_ID = :ld_contract ) AND  
					( Datepart(Year,NTC_TC_PERIOD.PERIODE_START) = :li_voyage_year ) ;

		IF IsNull(sdt_commenced_date) THEN 
			COMMIT;
			RETURN -1
		END IF
		
		/* Everything went OK set contract id*/
		sl_tc_contractid = ld_contract
END CHOOSE

COMMIT;
destroy(lds_voyage_numbers)
RETURN 1
end function

public subroutine of_setreport_data (ref datawindow adw);string ls_fce 
integer li_index

if adw.rowcount() = 0 then adw.InsertRow(0)

/* Set Fixture and calculated Fields */
FOR li_index = 1 to 5
	IF li_index = 1 THEN
		ls_fce = "fixture"
	ELSEIF li_index=2 THEN
		ls_fce= "calc"
	ELSEIF li_index=3 THEN
		ls_fce= "est"
	ELSEIF li_index=4 THEN
		ls_fce="est_act"
//	ELSEIF li_index=3 THEN
//		li_index=4           //estimated not on report
//		ls_fce="est_act"
	ELSEIF li_index=5 THEN
		ls_fce="act"
	END IF
	
	/* Profit section */
	adw.setitem(1,ls_fce+"_freight",of_getgross_freight( li_index, FALSE )) 
	adw.setitem(1,ls_fce+"_dem_des",of_getdemurrage( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_broker_comm",0 - of_getbroker_commission( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_port_exp",0 - of_getport_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunk_exp",0 - of_getbunker_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_misc_exp",0 - of_getmisc_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_drc_tc",0 - of_getdrc( li_index, FALSE ))
	/* Days section */
	adw.setitem(1,ls_fce+"_days_loading",of_getloading_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_discharge",of_getdischarge_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_load_and_disch",of_getload_discharge_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_bunkering",of_getbunkering_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_canal",of_getcanal_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_dry_dock",of_getdocking_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_loaded",of_getloaded_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_ballast",of_getballast_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_other",of_getother_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_idle",of_getidle_days( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_days_off_service",of_getoff_service_days( li_index, FALSE ))
	/* Set Bunkers Section */
	adw.setitem(1,ls_fce+"_bunkers_fuel",of_gethfo_ton( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunkers_diesel",of_getdo_ton( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunkers_gas",of_getgo_ton( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunkers_lshfo",of_getlshfo_ton( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunker_fuel_exp",of_gethfo_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunker_diesel_exp",of_getdo_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunker_gas_exp",of_getgo_expenses( li_index, FALSE ))
	adw.setitem(1,ls_fce+"_bunker_lshfo_exp",of_getlshfo_expenses( li_index, FALSE ))
NEXT
Return
end subroutine

public subroutine of_accumulate_vas_data ();integer li_x

for li_x = 1 to 5
	sstr_vas_accumulated_data[li_x].Gross_freight += sstr_vas_data[li_x].Gross_freight
	sstr_vas_accumulated_data[li_x].Demurrage += sstr_vas_data[li_x].Demurrage
	sstr_vas_accumulated_data[li_x].broker_commission += sstr_vas_data[li_x].broker_commission
	sstr_vas_accumulated_data[li_x].Port_expenses += sstr_vas_data[li_x].Port_expenses
	sstr_vas_accumulated_data[li_x].Bunker_expenses += sstr_vas_data[li_x].Bunker_expenses
	sstr_vas_accumulated_data[li_x].Misc_expenses += sstr_vas_data[li_x].Misc_expenses
	sstr_vas_accumulated_data[li_x].drc += sstr_vas_data[li_x].drc
	sstr_vas_accumulated_data[li_x].loading_days += sstr_vas_data[li_x].loading_days
	sstr_vas_accumulated_data[li_x].discharge_days += sstr_vas_data[li_x].discharge_days
	sstr_vas_accumulated_data[li_x].load_discharge_days += sstr_vas_data[li_x].load_discharge_days
	sstr_vas_accumulated_data[li_x].bunkering_days += sstr_vas_data[li_x].bunkering_days
	sstr_vas_accumulated_data[li_x].canal_days += sstr_vas_data[li_x].canal_days
	sstr_vas_accumulated_data[li_x].docking_days += sstr_vas_data[li_x].docking_days
	sstr_vas_accumulated_data[li_x].loaded_days += sstr_vas_data[li_x].loaded_days
	sstr_vas_accumulated_data[li_x].ballast_days += sstr_vas_data[li_x].ballast_days
	sstr_vas_accumulated_data[li_x].other_days += sstr_vas_data[li_x].other_days
	sstr_vas_accumulated_data[li_x].idle_days += sstr_vas_data[li_x].idle_days
	sstr_vas_accumulated_data[li_x].off_service_days += sstr_vas_data[li_x].off_service_days
	sstr_vas_accumulated_data[li_x].HFO_ton += sstr_vas_data[li_x].HFO_ton
	sstr_vas_accumulated_data[li_x].HFO_expenses += sstr_vas_data[li_x].HFO_expenses
	sstr_vas_accumulated_data[li_x].DO_ton += sstr_vas_data[li_x].DO_ton
	sstr_vas_accumulated_data[li_x].DO_expenses += sstr_vas_data[li_x].DO_expenses
	sstr_vas_accumulated_data[li_x].GO_ton += sstr_vas_data[li_x].GO_ton
	sstr_vas_accumulated_data[li_x].GO_expenses += sstr_vas_data[li_x].GO_expenses
	sstr_vas_accumulated_data[li_x].LSHFO_ton += sstr_vas_data[li_x].LSHFO_ton
	sstr_vas_accumulated_data[li_x].LSHFO_expenses += sstr_vas_data[li_x].LSHFO_expenses
next

Return
end subroutine

public subroutine of_setreport_header_data (integer ai_result_type, ref datawindow adw);Long ll_no_of_voyages, ll_no_of_vessel_groups, ll_no_of_profitcenters, ll_teller
Long ll_no_of_charterers, ll_calc_id, ll_fix_id
Long ll_no_of_rows
String ls_finished, ls_port_header, ls_chart_header, ls_operator, ls_fix_office
String ls_profitcenter_header, ls_vessel_group_header, ls_vessel_header, ls_voyage_header
String ls_charterers_header, ls_brokers_header, ls_chart_sn, ls_broker_sn, ls_voyage_nr, ls_fixing_charterer, ls_contract_type
Integer li_vessel_nr, li_previous_vessel_nr, li_profitcenter_nr
Integer li_chart_nr, li_broker_nr
datastore lds_chart_data
Datastore lds_header_data
datetime ldt_laycanStart, ldt_laycanEnd

if adw.rowcount() = 0 then adw.InsertRow(0)

// This codeline is to avoid ref. to w_super_vas_report when VAS is used from
// w_key_performance_report.wf_get_report_data.
If ai_result_type = 1 then
	if isvalid(w_super_vas_reports) or IsValid(w_vas_report_office_or_operator) or IsValid(w_super_vas_reports_periodresults)  THEN 
		/* nothing */
	else
		ai_result_type = 0
	end if
end if

CHOOSE CASE ai_result_type
	CASE 1    // Vessel Voyage report
		li_vessel_nr = of_getCurrent_vessel_nr()
		ls_voyage_nr = of_getCurrent_voyage_nr()
		adw.SetItem(1,"voyage_startdate",sdt_commenced_date)
		adw.setItem(1,"voyage_enddate", of_GetCurrent_EndDate())
		adw.SetItem(1,"report_level","Voyage Analysis")
		if isvalid(w_vas_report_office_or_operator) then &
			adw.SetItem(1,"text_year","For Year " + w_vas_report_office_or_operator.sle_year.text)
		if isvalid(w_super_vas_reports) then &
			adw.SetItem(1,"text_year","For Year " + w_super_vas_reports.sle_year.text)
		adw.SetItem(1,"profit_center",of_GetCurrent_Profit_Center_Name())
		adw.SetItem(1,"vessel_group",of_GetCurrent_Vessel_Group_Name())
		adw.SetItem(1,"vessel", "(" + of_GetCurrent_Vessel_ref_nr() + ") " + &
										 of_GetCurrent_Vessel_Name())
		// If TC Out then Calculated column is used for Estimated and must be visible on report
		IF of_GetCurrent_Voyage_Type() = 2 THEN 
			adw.Object.t_50.text = "Estimated"
			adw.Object.t_49.text = "on-hire TC days"
			adw.Object.officelabel.text = ""
			adw.Object.operatorlabel.text = ""
			adw.Object.fixedbylabel.text = ""
			adw.Object.contractlabel.text = ""
			adw.Object.t_8.visible = false
			adw.Object.t_7.visible = false
			adw.object.fixture_itinerary.visible = false
			adw.object.est_itinerary.visible = false
			adw.Object.Laycan.visible = False
			adw.Object.t_laycan.visible = False
//			adw.Object.t_12.text = "Bunker Exp. (Off.S)"
		ELSEIF of_GetCurrent_Voyage_Type() = ii_IDLEDAYS THEN 
			adw.Object.officelabel.text = ""
			adw.Object.operatorlabel.text = ""
			adw.Object.fixedbylabel.text = ""
			adw.Object.contractlabel.text = ""
			adw.Object.charterlabel.text = ""
			adw.Object.t_8.visible = false
			adw.Object.t_7.visible = false
			adw.Object.fixture_itinerary.visible = False
			adw.Object.est_itinerary.visible = False
			adw.Object.Laycan.visible = False
			adw.Object.t_laycan.visible = False			
		ELSE	
			adw.Object.t_50.text = "Calculated"
			adw.Object.t_49.text = "Other"
			adw.Object.officelabel.text = "Office:"
			adw.Object.operatorlabel.text = "Operator:"
			adw.Object.fixedbylabel.text = "Fixed by:"
			adw.Object.contractlabel.text = "Contract type:"
			adw.Object.t_8.visible = true
			adw.Object.t_7.visible = true
			adw.object.fixture_itinerary.visible = true
			adw.object.est_itinerary.visible = true
			adw.Object.Laycan.visible = True
			adw.Object.t_laycan.visible = True
		END IF	
		/* Set voyage Finished indicator and letter */
		IF of_GetCurrent_Voyage_Finished() = 1 THEN
			adw.SetItem(1,"finished",1)
			ls_finished = "F"
		ELSE
			adw.SetItem(1,"finished",0)
			ls_finished = "A"
		END IF
		
		IF of_GetCurrent_Voyage_Type() = 2 AND Len(ss_current_old_tco_voyage) > 0 THEN 
			adw.SetItem(1,"voyage","{" + Left(ss_current_old_tco_voyage,5) + " [" + of_GetCurrent_Voyage_Type_Letter() + &
										"][" + ls_finished + "] [" + string(sdt_commenced_date,"dd-mmm-yy") + &
										" - " + string(of_GetCurrent_EndDate(),"dd-mmm-yy") + "]}")
		ELSE	
			 adw.SetItem(1,"voyage","{" + of_GetCurrent_Voyage_Nr() + " [" + of_GetCurrent_Voyage_Type_Letter() + &
										"][" + ls_finished + "] [" + string(sdt_commenced_date,"dd-mmm-yy") + &
										" - " + string(of_GetCurrent_EndDate(),"dd-mmm-yy") + "]}")
		END IF	

		/* Set Estimated Itinerary */
		ll_calc_id = of_GetCurrent_calc_id()
		/* Inserted FR 06-06-02, Check for ballast port */
		// If statement on voy.type by Leith 10/6-03. Charterers is set by u_vas_tc_out
		IF of_GetCurrent_Voyage_Type() <> 2 THEN 
			lds_chart_data = create datastore
			lds_chart_data.dataobject = "d_vas_report_chart"
			lds_chart_data.SetTransObject(SQLCA)
			ll_no_of_rows = lds_chart_data.retrieve(ll_calc_id)
			FOR ll_teller = 1 TO ll_no_of_rows
				 ls_chart_header += lds_chart_data.GetItemString(ll_teller,"chart_chart_n_1") + "~n~r"
			Next	
			DESTROY lds_chart_data
			adw.SetItem(1,"charterers",ls_chart_header)
			adw.Object.charterlabel.visible = TRUE
		ELSE
			adw.SetItem(1,"income_details",ss_income_details)
			adw.SetItem(1,"expense_details",ss_expense_details)
			adw.Object.charterlabel.visible = FALSE
			adw.Object.bunkerexplabel.text="Bunker during Off Service"
		END IF		
		/* END FR 06-06-02 */
		if f_AtoBviaC_used(li_vessel_nr, ls_voyage_nr) then
			of_setReport_header_atobviac_route( adw )
		else
			of_setReport_header_route( adw )
		end if

		// REM 26-04-04 tilføj office + operator på vas report 
		IF of_GetCurrent_Voyage_Type() <> 2 THEN
			setNull(ls_operator)
			SELECT max(CLAIMS.CREATED_BY)  
    			INTO :ls_operator  
			 	FROM CLAIMS  
				WHERE CLAIMS.VESSEL_NR = :li_vessel_nr AND  
						CLAIMS.VOYAGE_NR = :ls_voyage_nr AND  
						CLAIMS.CLAIM_TYPE = "FRT"   
				COMMIT;
			adw.SetItem(1, "operator", ls_operator)
			setNull(ls_fix_office)
			SELECT MAX(OFFICES.OFFICE_NAME)  
				INTO :ls_fix_office  
				FROM CAL_CARG, CAL_CERP, OFFICES  
				WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  and  
						CAL_CERP.CAL_CERP_OFFICE_NR = OFFICES.OFFICE_NR  and  
						CAL_CARG.CAL_CALC_ID = :ll_calc_id    
				COMMIT;
			adw.SetItem(1, "office", ls_fix_office)

			SELECT USERS.FIRST_NAME + " " + USERS.LAST_NAME
					INTO :ls_fixing_charterer
					FROM CAL_CALC, USERS
					WHERE CAL_CALC.CAL_CALC_LAST_EDITED_BY = USERS.USERID
					AND CAL_CALC_STATUS = 4
					AND CAL_CALC_FIX_ID = (SELECT CAL_CALC_FIX_ID FROM CAL_CALC WHERE CAL_CALC.CAL_CALC_ID = :ll_calc_id );
					COMMIT;
			adw.SetItem(1, "fixed_by", ls_fixing_charterer)
						
			SELECT DISTINCT CASE CAL_CERP.CAL_CERP_CONTRACT_TYPE 
				WHEN 1 THEN "SPOT" 
				WHEN 2 THEN "COA Fixed rate" 
				WHEN 3 THEN "CVS Fixed rate" 
				WHEN 4 THEN "All" 
				WHEN 5 THEN "T/C Out" 
				WHEN 6 THEN "B/B Out" 
				WHEN 7 THEN "COA Market rate" 
				WHEN 8 THEN "CVS Market rate" 
				ELSE "UnKnown" END,
				CAL_CARG.CAL_CARG_LAYCAN_START,
				CAL_CARG.CAL_CARG_LAYCAN_END
			INTO :ls_contract_type,
				 :ldt_laycanStart, 
				 :ldt_laycanEnd
			FROM CAL_CARG,   
				CAL_CERP
			WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  
			AND CAL_CARG.CAL_CALC_ID = :ll_calc_id 
			ORDER BY CAL_CARG.CAL_CARG_LAYCAN_START	;
			adw.SetItem(1, "contract_type", ls_contract_type)
			adw.SetItem(1, "laycan", "["+string(ldt_laycanStart, "dd-mmm-yy hh:mm")+" - "+string(ldt_laycanEnd, "dd-mmm-yy hh:mm")+"]")
		end if		
	CASE 2   // Vessel report
		adw.SetItem(1,"report_level","Vessel Analysis")
		adw.SetItem(1,"text_year","For Year " + w_super_vas_reports.sle_year.text)
		adw.SetItem(1,"profit_center",of_GetCurrent_Profit_Center_Name())
		adw.SetItem(1,"vessel_group",of_GetCurrent_Vessel_Group_Name())
		adw.SetItem(1,"vessel", "(" + of_GetCurrent_Vessel_ref_nr() + ") " + &
										 of_GetCurrent_Vessel_Name())

		ll_no_of_voyages = of_Get_Nr_Of_Voyages()
		/* Set voyage Finished indicator */
		/* If all voyages finished then TRUE */
		IF ll_no_of_voyages = sds_vessel_voyage_list.GetItemNumber(1,"sum_finished") THEN
			adw.SetItem(1,"finished",1)
		ELSE
			adw.SetItem(1,"finished",0)
		END IF

		/* Build string of Voyages for header */
		FOR ll_teller = 1 TO ll_no_of_voyages
			of_Set_Current_Index(ll_teller)
			/* Set voyage Finished letter */
			IF of_GetCurrent_Voyage_Finished() = 1 THEN
				ls_finished = "F"
			ELSE
				ls_finished = "A"
			END IF
			
			/* Set Current Commenced Date */
			of_SetCommenced_Date()
			of_setvoyage_enddate()

			ls_voyage_header += "{" + of_GetCurrent_Voyage_Nr() + " [" + &
										of_GetCurrent_Voyage_Type_Letter() + &
										"][" + ls_finished + "] [" + &
										string(sdt_commenced_date,"dd-mmm-yy") + &
										" - " + string(of_GetCurrent_EndDate(),"dd-mmm-yy") + "]} "

		NEXT			
		adw.SetItem(1,"voyage",ls_voyage_header)
		
	CASE 3   // Vessel Group report
		adw.SetItem(1,"report_level","Vessel Group Analysis")
		adw.SetItem(1,"text_year","For Year " + w_super_vas_reports.sle_year.text)
		adw.SetItem(1,"profit_center",of_GetCurrent_Profit_Center_Name())
		adw.SetItem(1,"vessel_group",of_GetCurrent_Vessel_Group_Name())

		ll_no_of_voyages = of_Get_Nr_Of_Voyages()
		/* Set voyage Finished indicator */
		/* If all voyages finished then TRUE */
		IF ll_no_of_voyages = sds_vessel_voyage_list.GetItemNumber(1,"sum_finished") THEN
			adw.SetItem(1,"finished",1)
		ELSE
			adw.SetItem(1,"finished",0)
		END IF

		/* Build string of Vessels for header */
		li_previous_vessel_nr = -1
		FOR ll_teller = 1 TO ll_no_of_voyages
			of_Set_Current_Index(ll_teller)
			IF li_previous_vessel_nr <> of_GetCurrent_Vessel_nr() THEN
				li_previous_vessel_nr = of_GetCurrent_Vessel_nr()
				ls_vessel_header += "{(" + of_getcurrent_vessel_ref_nr( ) + ") " + &
												 of_GetCurrent_Vessel_Name() + "} "
			END IF
		NEXT			
		adw.SetItem(1,"vessel",ls_vessel_header)

	CASE 4   // Profit Center report
		adw.SetItem(1,"report_level","Profit Center Analysis")
		adw.SetItem(1,"text_year","For Year " + w_super_vas_reports.sle_year.text)
		adw.SetItem(1,"profit_center",of_GetCurrent_Profit_Center_Name())

		ll_no_of_voyages = of_Get_Nr_Of_Voyages()
		/* Set voyage Finished indicator */
		/* If all voyages finished then TRUE */
		IF ll_no_of_voyages = sds_vessel_voyage_list.GetItemNumber(1,"sum_finished") THEN
			adw.SetItem(1,"finished",1)
		ELSE
			adw.SetItem(1,"finished",0)
		END IF

		/* Build string of Vessel Groups for header */
		
		/* Find profitcenter for first vessel, all will be in same profitcenter */
		li_vessel_nr = of_GetCurrent_Vessel_Nr()
		SELECT PC_NR
			INTO :li_profitcenter_nr
			FROM VESSELS
			WHERE VESSEL_NR = : li_vessel_nr ;
		COMMIT;
		
		lds_header_data = CREATE datastore
		lds_header_data.DataObject = "d_vas_shiptypes_in_profitcenter"
		lds_header_data.SetTransObject(SQLCA)
		ll_no_of_vessel_groups = lds_header_data.Retrieve(li_profitcenter_nr)
		FOR ll_teller = 1 TO ll_no_of_vessel_groups
			ls_vessel_group_header += "{(" +&
											string(lds_header_data.GetItemNumber(ll_teller,"cal_vest_type_id")) +&
											") " + lds_header_data.GetItemString(ll_teller,"cal_vest_type_name") +&
											"} "
		NEXT			
		DESTROY lds_header_data
		adw.SetItem(1,"vessel_group", ls_vessel_group_header)

	CASE 5   // Department report
		adw.SetItem(1,"report_level","Department Analysis")
		adw.SetItem(1,"text_year","For Year " + w_super_vas_reports.sle_year.text)

		ll_no_of_voyages = of_Get_Nr_Of_Voyages()
		/* Set voyage Finished indicator */
		/* If all voyages finished then TRUE */
		IF ll_no_of_voyages = sds_vessel_voyage_list.GetItemNumber(1,"sum_finished") THEN
			adw.SetItem(1,"finished",1)
		ELSE
			adw.SetItem(1,"finished",0)
		END IF

		/* Build string of Profitcenters for header */
		
		lds_header_data = CREATE datastore
		lds_header_data.DataObject = "d_vas_profitcenters"
		lds_header_data.SetTransObject(SQLCA)
		ll_no_of_profitcenters = lds_header_data.Retrieve()
		FOR ll_teller = 1 TO ll_no_of_profitcenters
			ls_profitcenter_header += "{(" +&
											string(lds_header_data.GetItemNumber(ll_teller,"pc_nr")) +&
											") " + lds_header_data.GetItemString(ll_teller,"pc_name") +&
											"} "
		NEXT			
		DESTROY lds_header_data
		adw.SetItem(1,"profit_center", ls_profitcenter_header)

	CASE 6, 11   // Calculation Memo report & Accruals report
		/* Voyage type */
		CHOOSE CASE of_GetCurrent_Voyage_Type()
			CASE 1
				adw.Object.voyage_type.text = "Single Voyage"
			CASE 2
				adw.Object.voyage_type.text = "Time Charter Out"
			CASE 3
				adw.Object.voyage_type.text = "Position Voyage"
			CASE 4
				adw.Object.voyage_type.text = "Offservice / dock"
			CASE 5
				adw.Object.voyage_type.text = "Idle Days"
			CASE 6
				adw.Object.voyage_type.text = "Laid Up"
		END CHOOSE
		/* Vessel Name and Voyage Number*/
		adw.Object.vessel.text = of_GetCurrent_vessel_ref_nr() + " " + &
										 of_GetCurrent_vessel_name()
										 
		IF of_GetCurrent_Voyage_Type() = 2 AND Len(ss_current_old_tco_voyage) > 0 THEN
			adw.Object.voyage_nr.text = Left(ss_current_old_tco_voyage,5)
		ELSE
			adw.Object.voyage_nr.text = of_GetCurrent_voyage_nr()
		END IF	
		
		/* Accrual specific header detail */
		if ai_result_type = 11 then
			if of_GetCurrent_Voyage_Type() = 2 then
				adw.Modify("demlabel.Text='MISC. INCOME:'")
			else
				adw.Modify("demlabel.Text='DEM/MISC. INCOME:'")
			end if
		end if
		
		/* Brokers and Charterers */
		IF of_exists_all_frt() THEN   /* All actual freight Claims created */
			lds_header_data = CREATE datastore
			lds_header_data.DataObject = "d_max_frt"
			lds_header_data.SetTransObject(SQLCA)
			ll_no_of_charterers = lds_header_data.Retrieve(of_GetCurrent_vessel_nr(), &
																		  of_GetCurrent_voyage_nr())
			COMMIT;
			FOR ll_teller = 1 TO ll_no_of_charterers
				/* Charterer */
				li_chart_nr = lds_header_data.GetItemNumber(ll_teller,"claims_chart_nr")
				SELECT CHART_SN
					INTO :ls_chart_sn
					FROM CHART
					WHERE CHART_NR = :li_chart_nr ;
				COMMIT;
				ls_charterers_header += ls_chart_sn + ", " 
				/* Broker */
				li_broker_nr = lds_header_data.GetItemNumber(ll_teller,"claims_broker_nr")
				SELECT BROKER_SN
					INTO :ls_broker_sn
					FROM BROKERS
					WHERE BROKER_NR = :li_broker_nr ;
				COMMIT;
				ls_brokers_header += ls_broker_sn + ", " 
			NEXT			
			DESTROY lds_header_data
		ELSE
			lds_header_data = CREATE datastore
			lds_header_data.DataObject = "d_max_calc_frt"
			lds_header_data.SetTransObject(SQLCA)
			ll_no_of_charterers = lds_header_data.Retrieve(of_GetCurrent_calc_id())
			COMMIT;
			FOR ll_teller = 1 TO ll_no_of_charterers
				/* Charterer */
				li_chart_nr = lds_header_data.GetItemNumber(ll_teller,"cal_cerp_chart_nr")
				SELECT CHART_SN
					INTO :ls_chart_sn
					FROM CHART
					WHERE CHART_NR = :li_chart_nr ;
				COMMIT;
				ls_charterers_header += ls_chart_sn + ", " 
				/* NO Broker */
			NEXT			
			ls_brokers_header = " "
			DESTROY lds_header_data
		END IF
		// If statement on voy.type by Leith 10/6-03. 
		IF of_GetCurrent_Voyage_Type() <> 2 THEN 
			adw.Object.charterers.text = ls_charterers_header
		END IF
		adw.Object.brokers.text = ls_brokers_header

	CASE 7   // VAS File no datavindow
		// <statementblock>
	CASE 10    // TCE report only start and end 
		// never called with type 10 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
		adw.SetItem(1,"voyage_startdate",sdt_commenced_date)
		adw.setItem(1,"voyage_enddate", of_GetCurrent_EndDate())

END CHOOSE

Return
end subroutine

public subroutine of_setreport_header_route (ref datawindow adw);datastore lds_header_data
long ll_no_of_rows, ll_calc_id, ll_teller, ll_fix_id
string ls_ballast_port_from, ls_ballast_port_to, ls_port_header
string ls_ball_viapoint1, ls_ball_viapoint2, ls_ball_viapoint3	

ll_calc_id = of_getCurrent_calc_id( )

lds_header_data = CREATE datastore
lds_header_data.DataObject = "d_fix_est_port_codes_header"
lds_header_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_header_data.Retrieve(ll_calc_id)
COMMIT;
SELECT CAL_CALC_BALLAST_FROM, CAL_CALC_BALLAST_TO
INTO :ls_ballast_port_from, :ls_ballast_port_to
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_calc_id;
COMMIT;

SELECT CAL_BALL_VIA_POINT_1, CAL_BALL_VIA_POINT_2, CAL_BALL_VIA_POINT_3  
	INTO :ls_ball_viapoint1, :ls_ball_viapoint2, :ls_ball_viapoint3  
	FROM CAL_BALL  
	WHERE CAL_CALC_ID = :ll_calc_id   
	ORDER BY CAL_BALL_ID ASC  ;
COMMIT;
lds_header_data.InsertRow(1)
ll_no_of_rows += 1
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_1", ls_ball_viapoint1)
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_2", ls_ball_viapoint2)
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_3", ls_ball_viapoint3)
FOR ll_teller = 1 TO ll_no_of_rows
	/* FR 06-06-02 */
	if isnull(ls_ballast_port_from) and ll_teller = 1 then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_from) and ll_teller = 1 then
		ls_port_header += "(" + ls_ballast_port_from + ") "
	end if
	/* END FR 06-06-02 */
	ls_port_header += lds_header_data.GetItemString(ll_teller,"port_string") + "  "
	/* FR 06-06-02 */
	if isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
		ls_port_header += "(" + ls_ballast_port_to + ")"
	end if
	/* END FR 06-06-02 */
NEXT
DESTROY lds_header_data
adw.SetItem(1,"est_itinerary",ls_port_header)
ls_port_header = ""

/* Set Fixture Itinerary */
SELECT CAL_CALC_FIX_ID
	INTO :ll_fix_id
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_calc_id ;
COMMIT;
SELECT CAL_CALC_ID
	INTO :ll_calc_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fix_id 
	  AND CAL_CALC_STATUS = 4;
COMMIT;

/* Inserted FR 06-06-02, Check for ballast port */
SELECT CAL_CALC_BALLAST_FROM, CAL_CALC_BALLAST_TO
INTO :ls_ballast_port_from, :ls_ballast_port_to
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_calc_id;
COMMIT;
/* END FR 06-06-02 */

lds_header_data = CREATE datastore
lds_header_data.DataObject = "d_fix_est_port_codes_header"
lds_header_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_header_data.Retrieve(ll_calc_id)
COMMIT;
SELECT CAL_BALL_VIA_POINT_1, CAL_BALL_VIA_POINT_2, CAL_BALL_VIA_POINT_3  
	INTO :ls_ball_viapoint1, :ls_ball_viapoint2, :ls_ball_viapoint3  
	FROM CAL_BALL  
	WHERE CAL_CALC_ID = :ll_calc_id   
	ORDER BY CAL_BALL_ID ASC  ;
COMMIT;
lds_header_data.InsertRow(1)
ll_no_of_rows += 1
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_1", ls_ball_viapoint1)
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_2", ls_ball_viapoint2)
lds_header_data.SetItem(1,"cal_caio_cal_caio_via_point_3", ls_ball_viapoint3)
FOR ll_teller = 1 TO ll_no_of_rows
	/* FR 06-06-02 */
	if isnull(ls_ballast_port_from) and ll_teller = 1 then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_from) and ll_teller = 1 then
		ls_port_header += "(" + ls_ballast_port_from + ") "
	end if
	/* END FR 06-06-02 */
	ls_port_header += lds_header_data.GetItemString(ll_teller,"port_string") + "  "
	/* FR 06-06-02 */
	if isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
			ls_port_header += "() "
	elseif not isnull(ls_ballast_port_to) and ll_teller = ll_no_of_rows then
		ls_port_header += "(" + ls_ballast_port_to + ")"
	end if
	/* END FR 06-06-02 */
//			ls_port_header += lds_header_data.GetItemString(ll_teller,"port_string") + "  "
NEXT
DESTROY lds_header_data
adw.SetItem(1,"fixture_itinerary", ls_port_header)

end subroutine

public subroutine of_setreport_header_atobviac_route (ref datawindow adw);datastore lds_header_data
long ll_no_of_rows, ll_calc_id, ll_teller, ll_fix_id
string ls_ballast_port_from, ls_ballast_port_to, ls_port_header
string ls_ball_viapoint1, ls_ball_viapoint2, ls_ball_viapoint3	

ll_calc_id = of_getCurrent_calc_id( )

lds_header_data = CREATE datastore
lds_header_data.DataObject = "d_sq_tb_route_match"
lds_header_data.SetTransObject(SQLCA)
ll_no_of_rows = lds_header_data.Retrieve(ll_calc_id)
COMMIT;
SELECT CAL_CALC_BALLAST_FROM, CAL_CALC_BALLAST_TO
INTO :ls_ballast_port_from, :ls_ballast_port_to
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_calc_id;
COMMIT;

FOR ll_teller = 1 TO ll_no_of_rows
	choose case ll_teller
		case 1
			if isnull(ls_ballast_port_from) or ls_ballast_port_from = "" or ls_ballast_port_from = "<none>" or ls_ballast_port_from = "(none)" then
				ls_port_header += "() " + lds_header_data.GetItemString(ll_teller,"port_code") + "  "
			else
				ls_port_header += "(" + lds_header_data.GetItemString(ll_teller,"port_code") + ") "
			end if
		case ll_no_of_rows
			if isnull(ls_ballast_port_to) or ls_ballast_port_to = "" or ls_ballast_port_to = "<none>" or ls_ballast_port_to = "(none)"then
					ls_port_header += lds_header_data.GetItemString(ll_teller,"port_code") + " ()"
			else
				ls_port_header += "(" + lds_header_data.GetItemString(ll_teller,"port_code") + ")"
			end if
		case else
			ls_port_header += lds_header_data.GetItemString(ll_teller,"port_code") + "  "
	end choose
NEXT
adw.SetItem(1,"est_itinerary",ls_port_header)
ls_port_header = ""

/* Set Fixture Itinerary */
SELECT CAL_CALC_FIX_ID
	INTO :ll_fix_id
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_calc_id ;
COMMIT;
SELECT CAL_CALC_ID
	INTO :ll_calc_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fix_id 
	  AND CAL_CALC_STATUS = 4;
COMMIT;

SELECT CAL_CALC_BALLAST_FROM, CAL_CALC_BALLAST_TO
INTO :ls_ballast_port_from, :ls_ballast_port_to
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_calc_id;
COMMIT;

ll_no_of_rows = lds_header_data.Retrieve(ll_calc_id)
COMMIT;
FOR ll_teller = 1 TO ll_no_of_rows
	choose case ll_teller
		case 1
			if isnull(ls_ballast_port_from)  or ls_ballast_port_from = "" then
				ls_port_header += "() " + lds_header_data.GetItemString(ll_teller,"port_code") + "  "
			else
				ls_port_header += "(" + lds_header_data.GetItemString(ll_teller,"port_code") + ") "
			end if
		case ll_no_of_rows
			if isnull(ls_ballast_port_to) or ls_ballast_port_to = "" then
					ls_port_header += lds_header_data.GetItemString(ll_teller,"port_code") + " ()"
			else
				ls_port_header += "(" + lds_header_data.GetItemString(ll_teller,"port_code") + ")"
			end if
		case else
			ls_port_header += lds_header_data.GetItemString(ll_teller,"port_code") + "  "
	end choose
NEXT
DESTROY lds_header_data
adw.SetItem(1,"fixture_itinerary", ls_port_header)

end subroutine

public subroutine of_setlshfo_ton (integer ai_column, decimal ad_lshfo_ton);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetLSHFO_ton
//
//	Purpose:		This function sets the Low Sulphur Heavy Fuel Oil Ton in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_LSHFO_ton  Number of ton LSHFO Oil used
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 18/04-06		14.13		REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].LSHFO_ton = ad_LSHFO_ton
Return
end subroutine

public subroutine of_setlshfo_expenses (integer ai_column, decimal ad_lshfo_expenses);///////////////////////////////////////////////////////////////////
//
//	Function:	of_SetLSHFO_expenses
//
//	Purpose:		This function sets the Low Sulphur Heavy Fuel Oil Expenses in a shared structure
//					for a Single Vessel Voyage
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ad_LSHFO_expenses Low Sulphur Heavy Fuel Oil used in USD
//
//	Returns:		none
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date		Version	Name	Description
// 18/04-06		14.13		REM	Function created
//
///////////////////////////////////////////////////////////////////

sstr_vas_data[ai_column].LSHFO_expenses = ad_LSHFO_expenses
Return
end subroutine

public function decimal of_getlshfo_ton (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetLSHFO_ton
//
//	Purpose:		Returns the LSHFO ton either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, LSHFO ton
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date			Version	Name	Description
// 18/04-06		14.13		REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].LSHFO_ton
ELSE
	Return sstr_vas_accumulated_data[ai_column].LSHFO_ton
END IF
end function

public function decimal of_getlshfo_expenses (integer ai_column, boolean ab_vv_or_accumulated);///////////////////////////////////////////////////////////////////
//
//	Function:	of_GetLSHFO_Expenses
//
//	Purpose:		Returns the LSHFO Expenses either for a single Vessel Voyage
//					or from accumulated data structure 
//
//	Scope:		public
//
//	Arguments:	ai_column 1=fixture, 2=calculated, 3=estimated, 4=est/act and 5=actual
//					ab_vv_or_accumulated TRUE=Voyage and FALSE=accumulated
//
//	Returns:		decimal, LSHFO Expenses
//
///////////////////////////////////////////////////////////////////
//	Development log
//
//	Date			Version	Name	Description
// 18/04-06		14.13		REM	Function created
//
///////////////////////////////////////////////////////////////////

IF ab_vv_or_accumulated THEN
	Return sstr_vas_data[ai_column].LSHFO_expenses
ELSE
	Return sstr_vas_accumulated_data[ai_column].LSHFO_expenses
END IF
end function

public function long of_get_tccontract ();/* Returns contract ID set in of_set_commenced date */
if isNull(sl_tc_contractid) then
	return -1
else
	Return sl_tc_contractID
end if
end function

public function string of_getcurrent_vessel_ref_nr ();Return sds_vessel_voyage_list.GetItemString(sl_current_index,"vessel_ref_nr")
end function

protected subroutine of_modify_commenced_date (datetime adt_commenced_date);/* Used in 'u_vas_tc_out' when Voyage startdate has to be modified */

sdt_commenced_date = adt_commenced_date

return
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_vas_key_data
   <OBJECT> Ancestor non visual object for VAS processing </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
    Date   Ref    Author        Comments
  	17/01/11 ?     AGL     	Moved to MT framework
  	02/02/11 ?		AGL		Added ACCRUAL functionality  	
  									Rebuild of functions: of_set_tc_variations_coda(), of_setaccruals_reportdata()
  									Amend function of_setreport_header_data() to include reference to new VAS result type 11
	16/03/11	?		AGL		Fixed initial minor errors in date range and header detail.
	18/03/11	?		AGL		If actual last port date is greater than today, handle this with using the last day of that month instead of todays month.
	03/05/11	?		AGL		Accruals: Changed date difference decimal from 2 dp to 4 dp.
	23/06/11 2405	AGL/RMO	TC-Out Accrual fix.  Also minor other changes concerned with accruals to allow other amendments to work.
	19/08/11 2489  AGL		Small amendment inside of_setaccruals_reportdata() to store demunforwarded and voyage_finished data for accruals
	12/09/11 2581  AGL		Small amendment inside of_setaccruals_reportdata() to apply 2dp's to periodised port expenses.
	19/06/12 2831	AGL		Remove obsolete code for portvalidator
	26/11/12 3032	RJH022   When press preview for following report(Department Profit, Profit Center Profit, Shiptype Profit, Vessel Profit),
	                        Tramos will crash with error message.
	18/12/12 2515	ZSW001   Port codes are not displayed after a VAS report from an idle voyage.
	27/12/12 2515	ZSW001   Header text "Ports Fixture:" and "Ports Estimated:" are not displayed after a VAS report from a TC-OUT voyage.
********************************************************************/

end subroutine

public subroutine of_setaccruals_reportdata (ref datawindow adw, s_vessel_voyage_list ast_vesseldata);/********************************************************************
  of_setaccruals_reportdata( /*ref datawindow adw*/, /*s_vessel_voyage_list ast_vesseldata */)
  
   <DESC>load data into Accruals report.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: datawindow of report that will be modified
            ast_vesseldata: data structure of vessel data</ARGS>
   <USAGE>Used when result type is set to 11(ACCRUALS)</USAGE>
********************************************************************/

datetime ldt_startvoyage, ldt_endvoyage
date	ld_temp
decimal {4} ld_amount, ld_vesseldaysinperiod
String ls_result
long ll_counter, ll_no_of_ports
decimal {4} ld_voyagedays, ld_ignoreddays, ld_remainingdays=0

/* partial calculation is used only to provide prorated amount on Est/Act. */
ldt_startvoyage = this.of_getcommenced_date( )
ldt_endvoyage = this.of_getcurrent_enddate( )
ld_voyagedays = this.of_get_days_between( ldt_startvoyage, ldt_endvoyage )		

/* calculate any ignored days */
ld_ignoreddays = 0 
if ldt_startvoyage<ast_vesseldata.period_startdate then
	ld_ignoreddays += this.of_get_days_between( ldt_startvoyage, ast_vesseldata.period_startdate)		
end if	
if ldt_endvoyage>ast_vesseldata.period_enddate then
	ld_ignoreddays += this.of_get_days_between( ast_vesseldata.period_enddate, ldt_endvoyage )				
else
	ld_remainingdays = this.of_get_days_between(ldt_endvoyage, ast_vesseldata.period_enddate )				
end if	

/* set titles - header detail specific to data obtained here */
ld_temp = relativedate(date(ast_vesseldata.period_enddate), -1)
adw.Modify("report_def.Text='{Period Closing: " + string(ld_temp,"YYYY-MM") + "} [Voyage start:" + string(ldt_startvoyage,"dd/mm-yy hh:mm") + &
	" end:" + string(ldt_endvoyage,"dd/mm-yy hh:mm") + "] " + &
	"[Duration:" + string(ld_voyagedays) + " days] " + &
	"[Period:" + string(ld_voyagedays - ld_ignoreddays) + " days]'")
adw.Modify("t_ignoreddays.Text='" + string(ld_ignoreddays) + "'")
adw.Modify("t_remainingdays.Text='" + string(ld_remainingdays) + "'")

adw.Modify("t_durationdays.Text='" + string(ld_voyagedays) + "'")
adw.Modify("t_perioddays.Text='" + string(ld_voyagedays - ld_ignoreddays) + "'")
ld_vesseldaysinperiod = this.of_get_days_between( of_getcurrent_startdate( ), ast_vesseldata.period_enddate )
adw.Modify("t_vesseldaysinperiod.Text='" + string(ld_vesseldaysinperiod) + "'")

adw.object.bunklabel.text = "BUNKER EXP:"
adw.object.portlabel.visible = 1
adw.object.datawindow.detail.height = 92



/* Freight */
ls_result = string( round (of_GetGross_Freight( 4, TRUE ) ,0 ))
adw.Modify("est_act_freight.Expression='" + ls_result + "'")
ls_result = string( round (of_GetGross_Freight( 5, TRUE ) ,0 ))
adw.Modify("act_freight.Expression='" + ls_result + "'")
/* Freight Prorated */
ld_amount =of_GetGross_Freight( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_freight.Expression='" + string(round(ld_amount,0)) + "'")

/* Demurrage / Despatch */
ls_result = string( round (of_GetDemurrage( 4, TRUE ) ,0 ))
adw.Modify("est_act_dem_des.Expression='" + ls_result + "'")
ls_result = string( round (of_GetDemurrage( 5, TRUE ) ,0 ))
adw.Modify("act_dem_des.Expression='" + ls_result + "'")
/* Demurrage Prorated */
ld_amount =of_GetDemurrage( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_dem_des.Expression='" + string(round(ld_amount,0)) + "'")

/* Broker Commission */
ls_result = string( round (of_GetBroker_Commission( 4, TRUE ) ,0 ))
adw.Modify("est_act_broker_comm.Expression='" + ls_result + "'")
ls_result = string( round (of_GetBroker_Commission( 5, TRUE ) ,0 ))
adw.Modify("act_broker_comm.Expression='" + ls_result + "'")
/* Broker Commission Prorated */
ld_amount =of_GetBroker_Commission( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_broker_comm.Expression='" + string(round(ld_amount,0)) + "'")

/* Port Expenses for each port */
IF of_Get_Port_Match() THEN
	ll_no_of_ports = sds_calcmemo_port_exp.RowCount()
	FOR ll_counter = 1 TO ll_no_of_ports
		adw.InsertRow(0)
		adw.SetItem(ll_counter,"port_exp","PORT EXP")
		adw.SetItem(ll_counter,"port_name", &
						sds_calcmemo_port_exp.GetItemString(ll_counter,"proceed_port_code"))
		adw.SetItem(ll_counter,"purpose_code", &
						sds_calcmemo_port_exp.GetItemString(ll_counter,"purpose_code"))
		adw.SetItem(ll_counter,"est_act_port_exp", &
						sds_calcmemo_port_exp.GetItemDecimal(ll_counter,"amount"))
	
		/* get est/act port expense */
		ld_amount = sds_calcmemo_port_exp.GetItemDecimal(ll_counter,"amount")
		if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
		adw.SetItem(ll_counter,"period_est_act_port_exp", round(ld_amount,0))
		adw.SetItem(ll_counter,"act_port_exp", &
						sds_calcmemo_port_exp.GetItemDecimal(ll_counter,"amount_usd"))
	NEXT
	adw.Modify("portdetail.Expression='1'")	
ELSE
	adw.InsertRow(0)
	adw.SetItem(1,"port_exp","PORT EXP")
	IF of_GetCurrent_voyage_type() = 2 THEN
		adw.SetItem(1,"port_name", " ")
		adw.Modify("portdetail.Expression='0'")			
	ELSE
		adw.SetItem(1,"port_name", "no match")
		adw.Modify("portdetail.Expression='-1'")	
	END IF
	adw.SetItem(1,"est_act_port_exp", of_GetPort_expenses(4,TRUE))
	adw.SetItem(1,"act_port_exp", of_GetPort_expenses(5,TRUE))
END IF	

/* Bunker Expenses */
ls_result = string( round (of_GetBunker_Expenses( 4, TRUE ) ,0 ))
adw.Modify("est_act_bunker_exp.Expression='" + ls_result + "'")
ls_result = string( round (of_GetBunker_Expenses( 5, TRUE ) ,0 ))
adw.Modify("act_bunker_exp.Expression='" + ls_result + "'")
/* Bunker Expenses Prorated */
ld_amount =of_GetBunker_Expenses( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  round ((ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays),0)
adw.Modify("period_est_act_bunker_exp.Expression='" + string(round(ld_amount,0)) + "'")

/* Miscellanous Expenses */
ls_result = string( round (of_GetMisc_Expenses( 4, TRUE ) ,0 ))
adw.Modify("est_act_misc_exp.Expression='" + ls_result + "'")
ls_result = string( round (of_GetMisc_Expenses( 5, TRUE ) ,0 ))
adw.Modify("act_misc_exp.Expression='" + ls_result + "'")
/* Miscellanous Prorated */
ld_amount =of_GetMisc_Expenses( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  round ((ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays),0)
adw.Modify("period_est_act_misc_exp.Expression='" + string(round(ld_amount,0)) + "'")

DESTROY sds_calcmemo_port_exp
Return
end subroutine

public subroutine of_set_misc_details_var (string as_income_details, string as_expense_details, decimal ad_misc_exp_est_act, decimal ad_misc_inc_est_act, decimal ad_misc_exp_act, decimal ad_misc_inc_act, decimal ad_off_service_est_act);
ss_income_details = as_income_details
ss_expense_details = as_expense_details

sd_misc_exp_est_act = ad_misc_exp_est_act
sd_misc_inc_est_act = ad_misc_inc_est_act * -1
sd_misc_exp_act = ad_misc_exp_act
sd_misc_inc_act = ad_misc_inc_act * -1
sd_off_service_est_act = ad_off_service_est_act

end subroutine

public subroutine of_setaccruals_tc_reportdata (ref datawindow adw, s_vessel_voyage_list ast_vesseldata);/********************************************************************
  of_setaccruals_reportdata( /*ref datawindow adw*/, /*s_vessel_voyage_list ast_vesseldata */)
  
   <DESC>load data into Accruals report.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: datawindow of report that will be modified
            ast_vesseldata: data structure of vessel data</ARGS>
   <USAGE>Used when result type is set to 11(ACCRUALS)</USAGE>
********************************************************************/

datetime ldt_startvoyage, ldt_endvoyage
date	ld_temp
decimal {4} ld_amount, ld_vesseldaysinperiod
String ls_result
long ll_counter, ll_no_of_ports
decimal {4} ld_voyagedays, ld_ignoreddays, ld_remainingdays=0

/* partial calculation is used only to provide prorated amount on Est/Act. */
ldt_startvoyage = this.of_getcommenced_date( )
ldt_endvoyage = this.of_getcurrent_enddate( )
ld_voyagedays = this.of_get_days_between( ldt_startvoyage, ldt_endvoyage )		

/* calculate any ignored days */
ld_ignoreddays = 0 
if ldt_startvoyage<ast_vesseldata.period_startdate then
	ld_ignoreddays += this.of_get_days_between( ldt_startvoyage, ast_vesseldata.period_startdate)		
end if	
if ldt_endvoyage>ast_vesseldata.period_enddate then
	ld_ignoreddays += this.of_get_days_between( ast_vesseldata.period_enddate, ldt_endvoyage )				
else
	ld_remainingdays = this.of_get_days_between(ldt_endvoyage, ast_vesseldata.period_enddate )				
end if	

/* set titles - header detail specific to data obtained here */
/* set titles */
adw.Modify("report_def.Text='{Period: " + string(ast_vesseldata.period_enddate,"MM/YYYY") + "} [Voyage start:" + string(ldt_startvoyage,"dd/mm-yy hh:mm") + &
" end:" + string(ldt_endvoyage,"dd/mm-yy hh:mm") + "] " + &
"[Duration:" + string(ld_voyagedays) + " days] " + &
"[Period:" + string(ld_voyagedays - ld_ignoreddays) + " days]'")
adw.Modify("t_ignoreddays.Text='" + string(ld_ignoreddays) + "'")
adw.Modify("t_remainingdays.Text='" + string(ld_remainingdays) + "'")

adw.Modify("t_demunforwarded.Text='" + string(ast_vesseldata.demunforwarded) + "'")
adw.Modify("t_voyagefinished.Text='" + string(ast_vesseldata.voyage_finished) + "'")

adw.Modify("t_durationdays.Text='" + string(ld_voyagedays) + "'")
adw.Modify("t_perioddays.Text='" + string(ld_voyagedays - ld_ignoreddays) + "'")
ld_vesseldaysinperiod = this.of_get_days_between( of_getcurrent_startdate( ), ast_vesseldata.period_enddate )
adw.Modify("t_vesseldaysinperiod.Text='" + string(ld_vesseldaysinperiod) + "'")

adw.object.bunklabel.text = "BUNKER (Off Service):"
adw.object.portlabel.visible = 0
adw.object.datawindow.detail.height = 0

/* Freight */
ls_result = string( round (of_GetGross_Freight( 4, TRUE ) ,0 ))
adw.Modify("est_act_freight.Expression='" + ls_result + "'")
ls_result = string( round (of_GetGross_Freight( 5, TRUE ) ,0 ))
adw.Modify("act_freight.Expression='" + ls_result + "'")
/* Freight Prorated */
ld_amount =of_GetGross_Freight( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_freight.Expression='" + string(round(ld_amount,0)) + "'")

/* Demurrage / Despatch */
ls_result = string( round (of_GetDemurrage( 4, TRUE ) ,0 ))
adw.Modify("est_act_dem_des.Expression='" + ls_result + "'")
ls_result = string( round (of_GetDemurrage( 5, TRUE ) ,0 ))
adw.Modify("act_dem_des.Expression='" + ls_result + "'")
/* Demurrage Prorated */
ld_amount =of_GetDemurrage( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_dem_des.Expression='" + string(round(ld_amount,0)) + "'")

/* Broker Commission */
ls_result = string( round (of_GetBroker_Commission( 4, TRUE ) ,0 ))
adw.Modify("est_act_broker_comm.Expression='" + ls_result + "'")
ls_result = string( round (of_GetBroker_Commission( 5, TRUE ) ,0 ))
adw.Modify("act_broker_comm.Expression='" + ls_result + "'")
/* Broker Commission Prorated */
ld_amount =of_GetBroker_Commission( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  (ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays)
adw.Modify("period_est_act_broker_comm.Expression='" + string(round(ld_amount,0)) + "'")

/* Bunker Expenses */
ls_result = string( round (of_GetBunker_Expenses( 4, TRUE ) ,0 ))
adw.Modify("est_act_bunker_exp.Expression='" + ls_result + "'")
ls_result = string( round (of_GetBunker_Expenses( 5, TRUE ) ,0 ))
adw.Modify("act_bunker_exp.Expression='" + ls_result + "'")
/* Bunker Expenses Prorated */
ld_amount =of_GetBunker_Expenses( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  round ((ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays),0)
adw.Modify("period_est_act_bunker_exp.Expression='" + string(round(ld_amount,0)) + "'")

/* Miscellanous Expenses */
ls_result = string( round (of_GetMisc_Expenses( 4, TRUE ) ,0 ))
adw.Modify("est_act_misc_exp.Expression='" + ls_result + "'")
ls_result = string( round (of_GetMisc_Expenses( 5, TRUE ) ,0 ))
adw.Modify("act_misc_exp.Expression='" + ls_result + "'")

/* Miscellanous Prorated */
ld_amount =of_GetMisc_Expenses( 4, TRUE )
if ld_ignoreddays>0 and ld_voyagedays<>0 then ld_amount =  round ((ld_amount / ld_voyagedays) * (ld_voyagedays - ld_ignoreddays),0)
adw.Modify("period_est_act_misc_exp.Expression='" + string(round(ld_amount,0)) + "'")

DESTROY sds_calcmemo_port_exp
Return
end subroutine

on u_vas_key_data.create
call super::create
end on

on u_vas_key_data.destroy
call super::destroy
end on

