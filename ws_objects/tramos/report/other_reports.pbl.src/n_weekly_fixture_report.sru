$PBExportHeader$n_weekly_fixture_report.sru
forward
global type n_weekly_fixture_report from nonvisualobject
end type
end forward

global type n_weekly_fixture_report from nonvisualobject
end type
global n_weekly_fixture_report n_weekly_fixture_report

type variables
Datastore ids_report_data
Decimal {0} id_pool_id
end variables

forward prototypes
public function integer of_check_pool (integer ai_vessel)
public subroutine of_save (unsignedlong aul_link_id)
public subroutine of_report_fixture (integer ai_vessel, unsignedlong aul_link_id, integer ai_type)
public function integer of_tc (unsignedlong aul_link_id)
public function integer of_calc (unsignedlong aul_link_id)
private function decimal of_getbudgetcomm (long al_vesselnr)
private function decimal of_getidlebunkerconsumption (ref datastore ads_calc)
private subroutine documentation ()
end prototypes

public function integer of_check_pool (integer ai_vessel);  
// If the vessel is not in a pool, there are no possible link for fixture data  
SELECT DISTINCT NTC_POOL_VESSELS.POOL_ID  
INTO :id_pool_id  
FROM NTC_POOL_VESSELS  
WHERE NTC_POOL_VESSELS.VESSEL_NR = :ai_vessel   ;
Commit;

IF NOT(id_pool_id > 0) THEN 
	Return 0
ELSE
	Return 1
END IF
end function

public subroutine of_save (unsignedlong aul_link_id);// There can only be one new and one cancelled row in table

OpenwithParm(w_weekly_report_data,aul_link_id)

end subroutine

public subroutine of_report_fixture (integer ai_vessel, unsignedlong aul_link_id, integer ai_type);Integer li_result

// Check if the vessel is registered in the pool system table
IF of_check_pool(ai_vessel) = 0 THEN
	MessageBox("Warning","The Vessel are not registered in a Pool. No data saved !")
	Return
END IF

ids_report_data = CREATE datastore
ids_report_data.DataObject = "d_weekly_report_data"
ids_report_data.SetTransObject(SQLCA)

IF ai_type = 0 THEN
	li_result = of_tc(aul_link_id)
ELSE
	li_result = of_calc(aul_link_id)
END IF

IF li_result = 1 THEN of_save(aul_link_id)

Destroy ids_report_data
	
IF li_result = -1 THEN MessageBox("Error","Error saving data. No data saved !")
		
end subroutine

public function integer of_tc (unsignedlong aul_link_id);
Datastore lds_tc
Integer li_tc_rows, li_row, li_vessel
Datetime ldt_start, ldt_end
Long ll_timediff
Decimal {4} ld_days, ld_tcmonth, ld_tcmonthindex100

lds_tc = CREATE datastore
lds_tc.DataObject = "d_tc_weekly_report_data"
lds_tc.SetTransObject(SQLCA)
li_tc_rows = lds_tc.Retrieve(aul_link_id)

IF NOT(li_tc_rows > 0) THEN Return -1

li_vessel = lds_tc.GetItemNumber(1,"ntc_tc_contract_vessel_nr")

// Calculate days
ldt_start = lds_tc.GetItemDatetime(1,"ntc_tc_period_periode_start")
ldt_end = lds_tc.GetItemDatetime(li_tc_rows,"ntc_tc_period_periode_end")
ll_timediff = timedifference(ldt_start,ldt_end)
ld_days = (ll_timediff/(1440))

// Get TC Month
ld_tcmonth = lds_tc.GetItemNumber(1,"tcmonth")
ld_tcmonthindex100 = f_calculate_index100(ld_tcmonth, li_vessel)

// Insert data
li_row = ids_report_data.InsertRow(0)
ids_report_data.SetItem(li_row,"cp_text",lds_tc.GetItemString(1,"ntc_tc_contract_tc_hire_cp_text"))
ids_report_data.SetItem(li_row,"chart_nr",lds_tc.GetItemNumber(1,"ntc_tc_contract_chart_nr"))
ids_report_data.SetItem(li_row,"link_id",aul_link_id)
ids_report_data.SetItem(li_row,"link_to_calculation",0) // TC
ids_report_data.SetItem(li_row,"status",1) //New
ids_report_data.SetItem(li_row,"reported_date",Today())
ids_report_data.SetItem(li_row,"pool_id",id_pool_id)
ids_report_data.SetItem(li_row,"vessel_nr",li_vessel)
ids_report_data.SetItem(li_row,"days_iwd",ld_days)
ids_report_data.SetItem(li_row,"tc_month_iwd",ld_tcmonth)
ids_report_data.SetItem(li_row,"tc_month_index100_iwd",ld_tcmonthindex100)

Destroy lds_tc

Return 1
end function

public function integer of_calc (unsignedlong aul_link_id);Datastore lds_calc, lds_ports
Integer li_port_rows,li_calc_rows, li_counter, li_found, li_row
String ls_purpose, ls_port, ls_load, ls_disch, ls_find
Decimal {0} ld_carg_id, ld_old_carg_id
decimal {2} ld_tceqv_exclidle, ld_budgetComm, ld_idle_bunker_consumption

lds_calc = CREATE datastore
lds_calc.DataObject = "d_calc_weekly_report_data"
lds_calc.SetTransObject(SQLCA)
li_calc_rows = lds_calc.Retrieve(aul_link_id)

// Get the load and dish ports
lds_ports = CREATE datastore
lds_ports.DataObject = "d_calc_weekly_report_ports_data"
lds_ports.SetTransObject(SQLCA)
li_port_rows = lds_ports.Retrieve(aul_link_id)

IF li_port_rows > 0 THEN
	FOR li_counter = 1 TO li_port_rows
		ld_carg_id = lds_ports.GetItemNumber(li_counter,"cal_carg_cal_carg_id")
		IF ld_old_carg_id <> ld_carg_id AND li_counter > 1 THEN
			ls_find = "cal_carg_cal_carg_id =" + String(ld_old_carg_id)
			li_found = lds_calc.Find(ls_find,1,li_calc_rows)
			IF li_found > 0 THEN
				ls_load = Left(ls_load,Len(ls_load) - 1)
				ls_disch = Left(ls_disch,Len(ls_disch) - 1)
				lds_calc.SetItem(li_found,"loadports",ls_load)
				lds_calc.SetItem(li_found,"dischports",ls_disch)
			END IF	
			ls_load = ""
			ls_disch = ""
		END IF	
		ls_purpose = lds_ports.GetItemString(li_counter,"cal_caio_purpose_code")
		ls_port = lds_ports.GetItemString(li_counter,"ports_port_n")
		IF ls_purpose = "L" THEN
			ls_load += ls_port + ","
		ELSE
			ls_disch += ls_port + ","
		END IF
		ld_old_carg_id = ld_carg_id
	NEXT	
	
	ls_find = "cal_carg_cal_carg_id =" + String(ld_old_carg_id)
	li_found = lds_calc.Find(ls_find,1,li_calc_rows)
	IF li_found > 0 THEN
		ls_load = Left(ls_load,Len(ls_load) - 1)
		ls_disch = Left(ls_disch,Len(ls_disch) - 1)
		lds_calc.SetItem(li_found,"loadports",ls_load)
		lds_calc.SetItem(li_found,"dischports",ls_disch)
	END IF
END IF

// Calculate TC Eqv excluding idle days
ld_budgetComm = of_getbudgetcomm( lds_calc.GetItemNumber(1,"cal_calc_cal_calc_vessel_id"))
ld_idle_bunker_consumption = of_getidlebunkerconsumption( lds_calc ) 
//TC Eqv result per day excl idle
ld_tceqv_exclidle = (lds_calc.getItemNumber(1, "netresult") + ld_idle_bunker_consumption) / lds_calc.getItemNumber(1, "daysexidle")
//TC Eqv result per month excl idle
ld_tceqv_exclidle *= 30.416
// add budget commission
ld_tceqv_exclidle /= (1 - ld_budgetComm/100)

// Move data from lds_calc to ids_report_data
FOR li_counter = 1 TO li_calc_rows
	li_row = ids_report_data.InsertRow(0)
	////////////////////////////////////////////////////////////////////////////////////
	ids_report_data.SetItem(li_row,"cp_text",lds_calc.GetItemstring(li_counter,"cal_cerp_cal_cerp_description"))
	ids_report_data.SetItem(li_row,"chart_nr",lds_calc.GetItemNumber(li_counter,"cal_cerp_chart_nr"))
	ids_report_data.SetItem(li_row,"quantity",lds_calc.GetItemDecimal(li_counter,"cal_carg_cal_carg_total_units"))
	ids_report_data.SetItem(li_row,"freight_rate",lds_calc.GetItemDecimal(li_counter,"cal_carg_cal_carg_freight_rate"))
	ids_report_data.SetItem(li_row,"load_ports",lds_calc.GetItemString(li_counter,"loadports"))
	ids_report_data.SetItem(li_row,"discharge_ports",lds_calc.GetItemString(li_counter,"dischports"))
	ids_report_data.SetItem(li_row,"link_id",aul_link_id)
	ids_report_data.SetItem(li_row,"link_to_calculation",1) // Calculation
	ids_report_data.SetItem(li_row,"status",1) //New
	ids_report_data.SetItem(li_row,"reported_date",Today())
	ids_report_data.SetItem(li_row,"pool_id",id_pool_id)
	ids_report_data.SetItem(li_row,"vessel_nr",lds_calc.GetItemNumber(li_counter,"cal_calc_cal_calc_vessel_id"))
	IF li_counter = 1 THEN
		ids_report_data.SetItem(li_row,"days_ewd",lds_calc.GetItemDecimal(li_counter,"daysexidle"))
		ids_report_data.SetItem(li_row,"tc_month_ewd",ld_tceqv_exclidle )
		ids_report_data.SetItem(li_row,"days_iwd",lds_calc.GetItemDecimal(li_counter,"cal_calc_cal_calc_total_days"))
		ids_report_data.SetItem(li_row,"tc_month_iwd",lds_calc.GetItemDecimal(li_counter,"cal_calc_cal_calc_tc_eqv"))
		ids_report_data.SetItem(li_row,"tc_month_index100_iwd",lds_calc.GetItemDecimal(li_counter,"TCIndex100"))
	END IF	
	////////////////////////////////////////////////////////////////////////////////////
NEXT

Destroy lds_ports
Destroy lds_calc

Return 1
end function

private function decimal of_getbudgetcomm (long al_vesselnr);/************************************************************************************
Get budget commissions
************************************************************************************/
decimal	ld_budgetComm
long		ll_vessel_type

SELECT BUDGET_COMM
	INTO :ld_budgetcomm
	FROM VESSELS
	WHERE VESSEL_NR = :al_vesselnr;

If IsNull(ld_budgetcomm) Then 
	SELECT CAL_VEST_TYPE_ID 
		INTO :ll_vessel_type
		FROM VESSELS
		WHERE VESSEL_NR = :al_vesselnr;
		
	SELECT CAL_VEST_BUDGET_COMM
		INTO :ld_budgetcomm
		FROM CAL_VEST
		WHERE CAL_VEST_TYPE_ID = :ll_vessel_type;
End if

If IsNull(ld_budgetComm ) Then ld_budgetComm = 0

// Return the result
Return(ld_budgetComm)
end function

private function decimal of_getidlebunkerconsumption (ref datastore ads_calc);decimal {4}	ld_consHFO, ld_consDO, ld_consGO, ld_idle_days
decimal {2} ld_idle_consumption 
long			ll_vessel_nr

//chek first if there are any idle days
ld_idle_days = ads_calc.getItemNumber(1, "cal_calc_cal_calc_total_days") - ads_calc.getItemNumber(1, "daysexidle")

if ld_idle_days = 0 then return 0

// select consumption per type 4 (at port)
ll_vessel_nr = ads_calc.getItemNumber(1, "cal_calc_cal_calc_vessel_id")
  SELECT CAL_CONS_FO, CAL_CONS_DO, CAL_CONS_MGO  
    INTO :ld_consHFO, :ld_consDO, :ld_consGO  
    FROM CAL_CONS  
   WHERE VESSEL_NR = :ll_vessel_nr AND  
         CAL_CONS_TYPE = 4 ;

ld_idle_consumption = 0 
if ld_consHFO <> 0 then ld_idle_consumption += ld_consHFO * ads_calc.getItemNumber(1, "cal_calc_hfo_price") 
if ld_consDO <> 0 then ld_idle_consumption += ld_consDO * ads_calc.getItemNumber(1, "cal_calc_do_price") 
if ld_consGO <> 0 then ld_idle_consumption += ld_consGO * ads_calc.getItemNumber(1, "cal_calc_go_price") 
ld_idle_consumption *= ld_idle_days

return ld_idle_consumption
end function

private subroutine documentation ();/********************************************************************
	n_weekly_fixture_report: Move data to weekly fixture report
		
	<OBJECT> 
	This object is called from Calculation and TC Hire when a the user
	selects to send the 'fixture' to weekly fixturing report system.
	
	All values are copied 'AS-IS' from the result window with the 
	exception of TC Month excluding idle days. This figure is calculated 
	as below:
	
	tcday = (netresult + bunker consumption during idle) / (total days - idle days)
	
	tcmonth = (tcday * 30.416) / (1 - budget commission)
	
	</OBJECT>
	
	<USAGE></USAGE>
	
	Date   		Ref		Author				Comments
	10/08/20					Leith Noval			First Version
	07/12/07		#845		Regin Mortensen	Modified calculation of TC Month
														excluding idle days 
********************************************************************/
end subroutine

on n_weekly_fixture_report.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_weekly_fixture_report.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

