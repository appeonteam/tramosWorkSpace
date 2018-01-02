$PBExportHeader$u_vas_fix_calc_est_data.sru
$PBExportComments$Uo used for retrieving, and calculating Fix, calc, and est. VAS columns.
forward
global type u_vas_fix_calc_est_data from u_vas_key_data
end type
end forward

global type u_vas_fix_calc_est_data from u_vas_key_data
end type
global u_vas_fix_calc_est_data u_vas_fix_calc_est_data

type variables
Decimal {2} id_other_frt_adr_com
end variables

forward prototypes
public subroutine of_other_frt_adr_com (integer ad_calc_id)
public function decimal of_frt_adr_com (decimal ad_calc_id)
public function decimal of_dem_adr_com (decimal ad_total_adr_com, decimal ad_frt_adr_com, decimal ad_calc_id)
public function integer of_start_calc ()
public function integer of_start_calc_loadload (long al_calcid, ref datawindow adw_loadvas)
public subroutine documentation ()
end prototypes

public subroutine of_other_frt_adr_com (integer ad_calc_id);Datastore lds_calc_misc_claim_frttype_adr_comm, lds_calc_hea_dev_adr_comm
Decimal {2} ld_misc_adr_commission, ld_hea_dev_adr_commission
Long ll_rows_1, ll_rows_2


// Adr. misc claims type frt
lds_calc_misc_claim_frttype_adr_comm = CREATE datastore
lds_calc_misc_claim_frttype_adr_comm.dataobject = "d_calc_misc_claim_frttype_adr_comm"

lds_calc_misc_claim_frttype_adr_comm.SetTransObject(SQLCA)
ll_rows_1 = lds_calc_misc_claim_frttype_adr_comm.Retrieve(ad_calc_id)

IF ll_rows_1 > 0 THEN
	ld_misc_adr_commission = lds_calc_misc_claim_frttype_adr_comm.GetItemDecimal(1,"sum_adr_com")
END IF

// Adr. hea and dev claims
lds_calc_hea_dev_adr_comm = CREATE datastore
lds_calc_hea_dev_adr_comm.dataobject = "d_calc_hea_dev_adr_comm"

lds_calc_hea_dev_adr_comm.SetTransObject(SQLCA)
ll_rows_2 = lds_calc_hea_dev_adr_comm.Retrieve(ad_calc_id)

IF ll_rows_2 > 0 THEN
	ld_hea_dev_adr_commission = lds_calc_hea_dev_adr_comm.GetItemDecimal(1,"sum_adr_com")
END IF

destroy lds_calc_misc_claim_frttype_adr_comm 
destroy lds_calc_hea_dev_adr_comm

id_other_frt_adr_com = ld_misc_adr_commission + ld_hea_dev_adr_commission

Return


end subroutine

public function decimal of_frt_adr_com (decimal ad_calc_id);
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
 Object  : u_vas_fix_calc_est_data
 Event	:  
 Scope   : local
************************************************************************************
 Author  : Teit Aunt 
 Date    : 4-5-98
 Description : Calculate the total frt address commission on a calculation for use in the
 					super VAS. This function only works on cargoes with a CP attached
					to it.
 Arguments   : Calculation ID
 Returns     : Decimal address commission
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
4-5-98	1.0		TA		Initial version
************************************************************************************/

// Variables
Decimal ld_adr_comm, ld_rate, ld_lumpsum, ld_ws_rate, ld_ws_flatrate, ld_total_units &
			,ld_min_1, ld_min_2, ld_over_1, ld_over_2, ld_adr_comm_pct, ld_add_lumpsum &
			,ld_gross_freight, ld_unitprice, ld_calc_id, ld_cerp_id, ld_cerp_id_two  &
			,ld_revers_units
Integer li_type, li_adr_comm_on_add_lumpsum, li_no_cargo, li_count, li_revers_freight &
			,li_done, li_count_two, li_add_lump
String ls_calc_id
long	ll_cargoid[]
Datastore lds_cargo, lds_add_lumpsums

// Create the datastore 
lds_cargo = Create datastore
lds_cargo.Dataobject = "ds_vas_calc_adr"
lds_cargo.SetTransObject(SQLCA)
li_no_cargo = lds_cargo.Retrieve(ad_calc_id)

IF SQLCA.SqlCode <> 0 Then 
	MessageBox("Error","Retrieve error for calculating calc. frt adr. comm.")
	Destroy lds_cargo;
	Return -1
END IF

IF NOT(li_no_cargo > 0) THEN
	// No frt rows from calc. Should not be possible.
	Destroy lds_cargo;
	Return 0
END IF

// Start the calculation
FOR li_count = 1 TO li_no_cargo 
	
	// Get the data to do the calculation
	ld_adr_comm_pct = lds_cargo.GetItemNumber(li_count,"cal_carg_adr_commision")
	li_done = lds_cargo.GetItemNumber(li_count,"creversible")

	If (ld_adr_comm_pct > 0) AND (li_done = 0) Then
	ld_revers_units = 0
	
		// Investigate whether there are reversible freight
		li_revers_freight = lds_cargo.GetItemNumber(li_count,"cal_cerp_cal_cerp_rev_freight")
		If li_revers_freight = 1 Then
			ld_cerp_id = lds_cargo.GetItemNumber(li_count,"cal_cerp_id")

			// Set cargos with same CP to done, and collect units from cargoes, except
			// the one at the row in the current for loop, because units for this row
			// will be collected and added later.
			For li_count_two = li_count + 1 TO li_no_cargo
				If ld_cerp_id = lds_cargo.GetItemNumber(li_count_two,"cal_cerp_id") Then
					lds_cargo.SetItem(li_count_two,"creversible",1)
					ld_revers_units += lds_cargo.GetItemNumber(li_count_two,"cal_carg_total_units")
				End if
			Next
		End if
		
		// Address commission % > 0 so get data to calculate on
		ld_rate = lds_cargo.GetItemNumber(li_count,"cal_carg_freight_rate") + lds_cargo.GetItemNumber(li_count,"cal_carg_bunker_escalation")
		ld_lumpsum = lds_cargo.GetItemNumber(li_count,"cal_carg_lumpsum")
		ld_ws_rate = lds_cargo.GetItemNumber(li_count,"cal_carg_ws_rate")
		ld_ws_flatrate = lds_cargo.GetItemNumber(li_count,"cal_carg_flatrate")
		ld_total_units = lds_cargo.GetItemNumber(li_count,"cal_carg_total_units")
		ld_total_units += ld_revers_units

		ld_min_1 = lds_cargo.GetItemNumber(li_count,"cal_carg_min_1")
		If IsNull(ld_min_1) Then ld_min_1 = 0

		ld_min_2 = lds_cargo.GetItemNumber(li_count,"cal_carg_min_2")
		If IsNull(ld_min_2) Then ld_min_2 = 0

		ld_over_1 = lds_cargo.GetItemNumber(li_count,"cal_carg_overage_1")
		If IsNull(ld_over_1) Then ld_over_1 = 0
		
		ld_over_2 = lds_cargo.GetItemNumber(li_count,"cal_carg_overage_2")
		If IsNull(ld_over_2) Then ld_over_2 = 0
		
		li_type = lds_cargo.GetItemNumber(li_count,"cal_carg_freight_type")
		
		SetNull(ld_unitprice)
		SetNull(ld_gross_freight)

		// Calculate gross freight
		CHOOSE CASE li_type
			CASE 3
				// The ratetype is Lumpsum
				ld_gross_freight = ld_lumpsum
			CASE 1,2
				// The ratetype is USD/mt
				ld_unitprice = ld_rate
			CASE 4
				// The ratetype is Worldscale
				ld_unitprice = (ld_ws_rate / 100) * ld_ws_flatrate
		END CHOOSE
		
		If Not IsNull(ld_unitprice) Then
			
			// No minimum 1
			If ld_min_1 = 0 Then
				ld_gross_freight = ld_total_units * ld_unitprice
			End if			
	
			// If total unit < mini 1 then dead freight
			If (ld_min_1 > 0) AND (ld_total_units < ld_min_1) then
				ld_gross_freight = ld_min_1 * ld_unitprice
			End if
		
			// 0 < Minimum 1 < total units
			If (ld_min_1 > 0) AND (ld_min_1 <= ld_total_units) Then
				ld_gross_freight = (ld_min_1 * ld_unitprice) + ((ld_total_units - ld_min_1) * &
							(ld_unitprice * (ld_over_1 / 100)))
			End if
	
			// If 0 < minimum 1 < minimum 2 < total units
			If (ld_min_1 > 0) AND (ld_min_1 < ld_min_2) AND (ld_min_2 < ld_total_units) Then
				ld_gross_freight = (ld_min_1 * ld_unitprice) + ((ld_min_2 - ld_min_1) * &
							(ld_unitprice * (ld_over_1 / 100))) + ((ld_total_units - ld_min_2) * &
							(ld_unitprice * (ld_over_2 / 100))) 
			End if
		End if

		ll_cargoid[1] = lds_cargo.getItemNumber(li_count, "cal_carg_id")
		lds_add_lumpsums = create datastore
		lds_add_lumpsums.dataObject="d_calc_lumpsum"
		lds_add_lumpsums.setTransObject( sqlca )
		lds_add_lumpsums.retrieve(ll_cargoid)
		for li_add_lump = 1 to lds_add_lumpsums.rowcount( )
			// Add added lumpsum to gross freight
			if lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_adr_comm")= 1 and not isNull(lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum"))  then
				ld_gross_freight += lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum")
			end if
		next
		
		// Calculate the address commission for the cargo
		ld_adr_comm += ld_gross_freight * (ld_adr_comm_pct / 100)
	End if
NEXT

// Destroy the dataobject
Destroy(lds_cargo)

// Returns
Return(ld_adr_comm)

end function

public function decimal of_dem_adr_com (decimal ad_total_adr_com, decimal ad_frt_adr_com, decimal ad_calc_id);Decimal ld_misc_adr_commission, ld_dem_adr
Long ll_rows

ld_dem_adr = ad_total_adr_com - ad_frt_adr_com - id_other_frt_adr_com 

Return ld_dem_adr
end function

public function integer of_start_calc ();s_vessel_voyage_list lstr_vessel_voyage_list
Decimal {0} ld_calc_id
Double ld_gross_freight, ld_demurrage, ld_broker_commission, ld_port_expenses, ld_canal_expenses, ld_hfo_ton
Double ld_do_ton, ld_go_ton, ld_misc_expenses, ld_misc_income, ld_tc, ld_drc
Double ld_total_days, ld_loading_days, ld_discharge_days, ld_bunkering_days, ld_canal_days   
Double ld_docking_days, ld_loaded_days, ld_laden_days, ld_ballast_days, ld_add_ballast_days, ld_off_service_days  
Double ld_other_days, ld_idle_days, ld_total_adr_comm
Integer li_status, li_status_start = 4, li_index, li_result_type  
Double ld_hfo_expenses, ld_do_expenses, ld_go_expenses, ld_status_calc_id,ld_freight
Double ld_frt_adr, ld_dem_adr
decimal{4} ld_lsfo_ton, ld_lsfo_expenses

of_get_vessel_array(lstr_vessel_voyage_list)

li_result_type = of_get_result_type()
ld_calc_id = lstr_vessel_voyage_list.calc_id
// Calc_memo = 6 OR VAS File = 7. In these cases only estimated has interest.
IF (li_result_type = 6 OR li_result_type = 7) THEN li_status_start = 6 

//Get fixtured=4, caculated=5 and estimated=6
FOR li_status = li_status_start TO 6

	SELECT TOP 1 CAL_CALC_ID,
			IsNull(CAL_CALC.CAL_CALC_TOTAL_ADR_COMMISSION, 0),
			IsNull(CAL_CALC.CAL_CALC_GROSS_FREIGHT, 0),   
			IsNull(CAL_CALC.CAL_CALC_TOTAL_DEMURRAGE, 0),   
			IsNull(CAL_CALC.CAL_CALC_TOTAL_COMMISSION, 0),   
			IsNull(CAL_CALC.CAL_CALC_PORT_EXPENSES, 0),   
			IsNull(CAL_CALC.CAL_CALC_CHANAL_EXPENSES, 0),   
			IsNull(CAL_CALC.CAL_CALC_FO_EXPENSES, 0),   
			IsNull(CAL_CALC.CAL_CALC_DO_EXPENSES, 0),   
			IsNull(CAL_CALC.CAL_CALC_MGO_EXPENSES, 0),  
			isnull(CAL_CALC.CAL_CALC_LSFO_EXPENSES, 0),
			IsNull(CAL_CALC.CAL_CALC_MISC_EXPENSES, 0),   
			IsNull(CAL_CALC.CAL_CALC_MISC_INCOME, 0),   
			IsNull(CAL_CALC.CAL_CALC_TC, 0),   
			IsNull(CAL_CALC.CAL_CALC_DRC, 0),   
			IsNull(CAL_CALC.CAL_CALC_TOTAL_DAYS, 0),   
			IsNull(CAL_CALC.CAL_CALC_DAYS_LOADING, 0),   
			IsNull(CAL_CALC.CAL_CALC_DAYS_DISCHARGING, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_BUNKERING_DAYS, 0),   
			IsNull(CAL_CALC.CAL_CALC_DAYS_CHANAL, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_DOK_DAYS, 0),   
			IsNull(CAL_CALC.CAL_CALC_DAYS_LOADED, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_DAYS_LADEN, 0),   
			IsNull(CAL_CALC.CAL_CALC_DAYS_BALLASTED, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_DAYS_BALLASTED, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_OTHER_DAYS, 0),   
			IsNull(CAL_CALC.CAL_CALC_ADD_IDLE_DAYS, 0),   
			IsNull(CAL_CALC.CAL_CALC_FO_TOTAL, 0),   
			IsNull(CAL_CALC.CAL_CALC_DO_TOTAL, 0),   
			IsNull(CAL_CALC.CAL_CALC_MGO_TOTAL, 0),
			isnull(CAL_CALC.CAL_CALC_LSFO_TOTAL, 0)
	 INTO :ld_status_calc_id,
			:ld_total_adr_comm,
			:ld_gross_freight,   
			:ld_demurrage,   
			:ld_broker_commission,   
			:ld_port_expenses,   
			:ld_canal_expenses,   
			:ld_hfo_expenses,   
			:ld_do_expenses,   
			:ld_go_expenses,
			:ld_lsfo_expenses,
			:ld_misc_expenses,   
			:ld_misc_income,   
			:ld_tc,   
			:ld_drc,   
			:ld_total_days,   
			:ld_loading_days,   
			:ld_discharge_days,   
			:ld_bunkering_days,   
			:ld_canal_days,   
			:ld_docking_days,   
			:ld_loaded_days,   
			:ld_laden_days,   
			:ld_ballast_days,   
			:ld_add_ballast_days,   
			:ld_other_days,   
			:ld_idle_days,   
			:ld_hfo_ton,   
			:ld_do_ton,   
			:ld_go_ton,
			:ld_lsfo_ton
	FROM   CAL_CALC  
	WHERE  CAL_CALC.CAL_CALC_STATUS = :li_status AND 
	       CAL_CALC.CAL_CALC_VESSEL_ID = :lstr_vessel_voyage_list.vessel_nr AND
			 CAL_CALC.CAL_CALC_FIX_ID =  (SELECT CAL_CALC_FIX_ID FROM CAL_CALC 
													WHERE CAL_CALC_ID = :ld_calc_id) ;
	IF SQLCA.SQLCode <> 0 THEN
//				MessageBox("Error","Select in u_fix_calc_est failed")
		Return -1
	END IF	

	// Now calculate freight, dem, misc claims less adr. comm, and calculate other data
	
	// Call function for calculating adr. com on frt and dem. Gross Frt and Dem
	// must be less adr. comm.
	
	ld_frt_adr = of_frt_adr_com(ld_status_calc_id)
	
	// Call of_other before of_dem_adr_com !!!!!!
	of_other_frt_adr_com(ld_status_calc_id)
	
	ld_dem_adr = of_dem_adr_com(ld_total_adr_comm,ld_frt_adr,ld_status_calc_id)
	
	//Gross frt. is incl. dem and adr. comm for frt and claims of type grossfrt
	ld_freight = ld_gross_freight - ld_demurrage - ld_frt_adr - id_other_frt_adr_com
	ld_demurrage = ld_demurrage - ld_dem_adr
	/* cr#2579 workaround until calculation module has been cleaned up.  expected Jan 2012 */
	if ld_demurrage<0 then ld_demurrage = 0
		
	
	li_index = li_status - 3 
	of_setgross_freight (li_index, ld_freight)  
	of_setdemurrage (li_index, ld_demurrage + ld_misc_income )			
//	of_setdemurrage (li_index, ld_demurrage )			
	of_setbroker_commission (li_index, ld_broker_commission)
	of_setport_expenses (li_index, ld_port_expenses + ld_canal_expenses)
	of_setbunker_expenses (li_index, ld_HFO_expenses + ld_DO_expenses + ld_GO_expenses + ld_lsfo_expenses)
	of_setmisc_expenses (li_index, ld_misc_expenses )  
//	of_setmisc_expenses (li_index, ld_misc_expenses - ld_misc_income)  
	of_setdrc (li_index, (ld_drc * ld_total_days) + (ld_tc * ld_total_days))
	of_setloading_days (li_index, ld_loading_days)
	of_setdischarge_days (li_index, ld_discharge_days)
	of_setload_discharge_days (li_index, 0)  //Always zero in calculation
	of_setbunkering_days (li_index, ld_bunkering_days)
	of_setcanal_days (li_index, ld_canal_days)
	of_setdocking_days (li_index, ld_docking_days)
	of_setloaded_days (li_index, ld_loaded_days + ld_laden_days)
	of_setballast_days (li_index, ld_ballast_days + ld_add_ballast_days)
	of_setother_days (li_index, ld_other_days - ld_docking_days) //Docking included in other
	of_setidle_days (li_index, ld_idle_days)
	of_setoff_service_days (li_index, 0)  //Always zero in calculation
	of_setHFO_ton (li_index, ld_HFO_ton)
	of_setHFO_expenses (li_index, ld_HFO_expenses)
	of_setDO_ton (li_index, ld_DO_ton)
	of_setDO_expenses (li_index, ld_DO_expenses)
	of_setGO_ton (li_index, ld_GO_ton)
	of_setGO_expenses (li_index, ld_GO_expenses)
	of_setLSHFO_ton (li_index, ld_lsfo_ton)
	of_setLSHFO_expenses (li_index, ld_lsfo_expenses)
NEXT

Return 1
end function

public function integer of_start_calc_loadload (long al_calcid, ref datawindow adw_loadvas);Double ld_total_adr_comm, ld_misc_expenses, ld_misc_income
Double ld_gross_freight, ld_demurrage, ld_broker_commission, ld_port_expenses, ld_canal_expenses
Double ld_hfo_expenses, ld_do_expenses, ld_go_expenses, ld_tc, ld_drc
Double ld_total_days, ld_loading_days, ld_discharge_days, ld_bunkering_days, ld_canal_days   
Double ld_docking_days, ld_loaded_days, ld_laden_days, ld_ballast_days, ld_add_ballast_days
Double ld_other_days, ld_idle_days 
Double ld_frt_adr, ld_dem_adr, ld_freight
Double ld_hfo_ton, ld_do_ton, ld_go_ton
decimal ld_lsfo_expenses, ld_lsfo_ton

SELECT  IsNull(CAL_CALC.CAL_CALC_TOTAL_ADR_COMMISSION, 0),
		IsNull(CAL_CALC.CAL_CALC_GROSS_FREIGHT, 0),   
		IsNull(CAL_CALC.CAL_CALC_TOTAL_DEMURRAGE, 0),   
		IsNull(CAL_CALC.CAL_CALC_TOTAL_COMMISSION, 0),   
		IsNull(CAL_CALC.CAL_CALC_PORT_EXPENSES, 0),   
		IsNull(CAL_CALC.CAL_CALC_CHANAL_EXPENSES, 0),   
		IsNull(CAL_CALC.CAL_CALC_FO_EXPENSES, 0),   
		IsNull(CAL_CALC.CAL_CALC_DO_EXPENSES, 0),   
		IsNull(CAL_CALC.CAL_CALC_MGO_EXPENSES, 0), 
		isnull(CAL_CALC.CAL_CALC_LSFO_EXPENSES, 0),
		IsNull(CAL_CALC.CAL_CALC_MISC_EXPENSES, 0),   
		IsNull(CAL_CALC.CAL_CALC_MISC_INCOME, 0),   
		IsNull(CAL_CALC.CAL_CALC_TC, 0),   
		IsNull(CAL_CALC.CAL_CALC_DRC, 0),   
		IsNull(CAL_CALC.CAL_CALC_TOTAL_DAYS, 0),   
		IsNull(CAL_CALC.CAL_CALC_DAYS_LOADING, 0),   
		IsNull(CAL_CALC.CAL_CALC_DAYS_DISCHARGING, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_BUNKERING_DAYS, 0),   
		IsNull(CAL_CALC.CAL_CALC_DAYS_CHANAL, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_DOK_DAYS, 0),   
		IsNull(CAL_CALC.CAL_CALC_DAYS_LOADED, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_DAYS_LADEN, 0),   
		IsNull(CAL_CALC.CAL_CALC_DAYS_BALLASTED, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_DAYS_BALLASTED, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_OTHER_DAYS, 0),   
		IsNull(CAL_CALC.CAL_CALC_ADD_IDLE_DAYS, 0),   
		IsNull(CAL_CALC.CAL_CALC_FO_TOTAL, 0),   
		IsNull(CAL_CALC.CAL_CALC_DO_TOTAL, 0),   
		IsNull(CAL_CALC.CAL_CALC_MGO_TOTAL, 0),
		isnull(CAL_CALC.CAL_CALC_LSFO_TOTAL, 0)
 INTO :ld_total_adr_comm,
		:ld_gross_freight,   
		:ld_demurrage,   
		:ld_broker_commission,   
		:ld_port_expenses,   
		:ld_canal_expenses,   
		:ld_hfo_expenses,   
		:ld_do_expenses,   
		:ld_go_expenses,   
		:ld_lsfo_expenses,
		:ld_misc_expenses,   
		:ld_misc_income,   
		:ld_tc,   
		:ld_drc,   
		:ld_total_days,   
		:ld_loading_days,   
		:ld_discharge_days,   
		:ld_bunkering_days,   
		:ld_canal_days,   
		:ld_docking_days,   
		:ld_loaded_days,   
		:ld_laden_days,   
		:ld_ballast_days,   
		:ld_add_ballast_days,   
		:ld_other_days,   
		:ld_idle_days,   
		:ld_hfo_ton,   
		:ld_do_ton,   
		:ld_go_ton,
		:ld_lsfo_ton
FROM   CAL_CALC  
WHERE  CAL_CALC.CAL_CALC_ID = :al_calcid ;
IF SQLCA.SQLCode <> 0 THEN
//				MessageBox("Error","Select in load failed")
	Return -1
END IF	
Commit;
// Now calculate freight, dem, misc claims less adr. comm, and calculate other data

// Call function for calculating adr. com on frt and dem. Gross Frt and Dem
// must be less adr. comm.

ld_frt_adr = of_frt_adr_com( al_calcid )

// Call of_other before of_dem_adr_com !!!!!!
of_other_frt_adr_com( al_calcid )

ld_dem_adr = of_dem_adr_com( ld_total_adr_comm,ld_frt_adr, al_calcid )

//Gross frt. is incl. dem and adr. comm for frt and claims of type grossfrt
ld_freight = ld_gross_freight - ld_demurrage - ld_frt_adr - id_other_frt_adr_com
ld_demurrage = ld_demurrage - ld_dem_adr

adw_loadvas.setItem(1, "load_freight", ld_freight)
adw_loadvas.setItem(1, "load_dem_des", ld_demurrage)
adw_loadvas.setItem(1, "load_broker_comm", 0 - ld_broker_commission)
adw_loadvas.setItem(1, "load_port_exp",0 - (ld_port_expenses + ld_canal_expenses))
adw_loadvas.setItem(1, "load_bunk_exp", 0 - (ld_HFO_expenses + ld_DO_expenses + ld_GO_expenses + ld_lsfo_expenses))
adw_loadvas.setItem(1, "load_misc_exp", 0 - (ld_misc_expenses - ld_misc_income))
adw_loadvas.setItem(1, "load_drc_tc", 0 - ((ld_drc * ld_total_days) + (ld_tc * ld_total_days)))
adw_loadvas.setItem(1, "load_days_loading",  ld_loading_days)
adw_loadvas.setItem(1, "load_days_discharge",  ld_discharge_days)
adw_loadvas.setItem(1, "load_days_load_and_disch",  0)  //Always zero in calculation
adw_loadvas.setItem(1, "load_days_bunkering",  ld_bunkering_days)
adw_loadvas.setItem(1, "load_days_canal", ld_canal_days)
adw_loadvas.setItem(1, "load_days_dry_dock",  ld_docking_days)
adw_loadvas.setItem(1, "load_days_loaded", ld_loaded_days + ld_laden_days)
adw_loadvas.setItem(1, "load_days_ballast",  ld_ballast_days + ld_add_ballast_days)
adw_loadvas.setItem(1, "load_days_other",  ld_other_days - ld_docking_days) //Docking included in other
adw_loadvas.setItem(1, "load_days_idle", ld_idle_days)
adw_loadvas.setItem(1, "load_days_off_service",  0)  //Always zero in calculation
adw_loadvas.setItem(1, "load_bunkers_fuel",   ld_HFO_ton)
adw_loadvas.setItem(1, "load_bunker_fuel_exp", ld_HFO_expenses)
adw_loadvas.setItem(1, "load_bunkers_diesel", ld_DO_ton)
adw_loadvas.setItem(1, "load_bunker_diesel_exp",  ld_DO_expenses)
adw_loadvas.setItem(1, "load_bunkers_gas", ld_GO_ton)
adw_loadvas.setItem(1, "load_bunker_gas_exp", ld_GO_expenses)
adw_loadvas.setItem(1, "load_bunkers_lshfo", ld_lsfo_ton) 
adw_loadvas.setItem(1, "load_bunker_lshfo_exp", ld_lsfo_expenses) 

Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_vas_fix_calc_est_data
   <OBJECT> Gets the figures from calculations for VAS processing </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
Date   		Ref    Author        Comments
22/06-11  	2471	RMO			Bunker adjustment added to the rate when calculating freight address commission
12/09-11		2579	AGL			Fix for negative demurrage amounts inside of_start_calc() after address commission has been applied
06/05-13    3236  ZSW001      Fix for VAS report can not be run for Chemtrans Ems/13011
29/10/15		CR3250		CCY018		Add LSFO fuel in calculation module.
********************************************************************/

end subroutine

on u_vas_fix_calc_est_data.create
call super::create
end on

on u_vas_fix_calc_est_data.destroy
call super::destroy
end on

