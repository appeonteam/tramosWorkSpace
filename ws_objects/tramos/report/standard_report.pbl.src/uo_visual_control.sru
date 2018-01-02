$PBExportHeader$uo_visual_control.sru
$PBExportComments$Used for the control of the visual aspects of w_reports_gv and to hold the code that generate the reports.
forward
global type uo_visual_control from nonvisualobject
end type
end forward

global type uo_visual_control from nonvisualobject
end type
global uo_visual_control uo_visual_control

type variables
Private String is_report_name
Public str_sql istr_sql
Private Boolean ib_pc = false
Private Boolean ib_profit_center = False
Private Boolean ib_vessel_grp = False
Private Boolean ib_grade_grp = False
Private Boolean ib_vessel = False
Private Boolean ib_charter = False
Private Boolean ib_charter_grp = False
Private Boolean ib_broker = False
Private Boolean ib_country = False
Private Boolean ib_port = False
Private Boolean ib_purpose = False
Private Boolean ib_year = False
Private Boolean ib_year_start = False
Private Boolean ib_year_end = False
Private Datastore ids_off
Private Integer ii_sheet_count = 0
end variables

forward prototypes
public function double of_calc_hours (datetime adt_start, datetime adt_end)
public function integer of_rap_vessel_rate_grade_temp ()
public function datetime of_commenced_date (long al_vessel_nr, string as_voyage_nr, long al_voyage_type)
public function double of_off_hire_exp (long al_row)
public function integer of_rap_a_f_voyages ()
public function integer of_rap_disbursement (string as_type)
public function integer of_rap_employment ()
public function integer of_rap_fleettracking (string as_type)
public function integer of_rap_idle_days ()
public function integer of_rap_listings ()
public function integer of_rap_port_rate_grade_temp ()
public function integer of_rap_top_broker ()
public function integer of_rap_vessel_port_visits ()
public function integer of_rap_tdf ()
public function integer of_new_dhm (ref integer ai_day, ref integer ai_hour, ref integer ai_min, decimal ad_factor)
public function integer of_rap_broker_dem_stat ()
public function integer of_rap_comissions ()
public function integer of_change_sql (ref datastore ads_sql)
public subroutine of_reset ()
public function integer of_rap_coa_liftings_cvs ()
public function integer of_get_sql_data ()
public function integer of_rap_chart_country ()
public function integer of_rap_chart_dem_stat ()
public function integer of_rap_top_charterer ()
public function integer of_rap_tc_hire ()
public function decimal of_tc_freight (long al_vessel, string as_year, long al_charter)
public function integer of_rap_country_port_visits ()
public function integer of_create_report ()
public function integer of_adjust_dhm (ref integer ai_day, ref integer ai_hour, ref integer ai_min)
public function integer of_window_control (string as_report_name)
public function integer of_rap_country_port_visits_tcout ()
private subroutine of_remove_duplicate (datastore ds_tmp)
public function decimal of_demurrage2 (long al_vessel, string as_voyage)
public function decimal of_demurrage (long al_vessel, string as_voyage, long al_charter)
public function decimal of_freight2 (long al_vessel, string as_voyage)
public function decimal of_freight (long al_vessel, string as_voyage, long al_charter)
public function decimal of_misc_inc (long al_vessel, string as_voyage)
public function decimal of_totalexpenses (long al_vessel, string as_voyage)
private function string of_getvoyagenumbersfortc (integer ai_vesselnr, integer ai_chartnr, string as_year[], integer ai_bybroker)
public subroutine documentation ()
end prototypes

public function double of_calc_hours (datetime adt_start, datetime adt_end);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
13-07-2000	TAU			
*************************************************************************************/
Double ldb_ret
Date ld_start, ld_end
Time ti_start, ti_end, ti_tmp = 00:00:00
	

ti_start = Time(adt_start)
If ti_start > 00:00:00 Then
	ld_start = RelativeDate(Date(adt_start),1)
Else
	ld_start = Date(adt_start)
End if

ti_end = Time(adt_end)
ld_end = Date(adt_end)

ldb_ret = DaysAfter(ld_start,ld_end) * 24
ldb_ret += ((86400 - SecondsAfter(ti_tmp,ti_start)) + SecondsAfter(ti_tmp,ti_end)) / 3600

return ldb_ret
end function

public function integer of_rap_vessel_rate_grade_temp ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-08-2000	TAU			Create sql for "Vessel Rate/grade/temp".
*************************************************************************************/
Long ll_ret
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
ds_tmp.DataObject = "d_vessel_rate_grade_temp"
// If more than 75 vessels then use this trick to avoid errors
If istr_sql.ib_vessel Then
	of_change_sql(ds_tmp)
End if
ds_tmp.SetTransObject(SQLCA)
ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[])

If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function datetime of_commenced_date (long al_vessel_nr, string as_voyage_nr, long al_voyage_type);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
03-08-2000  1.0	TAU	Initial version. 

!!!!!!! 04/02-09 finction not in use any more !!!!!!!!!!!!!!!!!

************************************************************************************/
DateTime ldt_commenced_date, ldt_departure, ldt_tchire_cp_date, ldt_port_arr_date, &
			ldt_dummy
string ls_last_voyage_nr = "Dummy"
Integer li_number_of_rows
SetNull(ldt_dummy)
datastore lds_voyage_numbers


CHOOSE CASE al_voyage_type
	CASE 1,3,4,5,6

		SELECT DISTINCT min(POC.PORT_ARR_DT)
				INTO 	:ldt_departure
				FROM 	POC,     PORTS  
				WHERE (POC.PORT_CODE = PORTS.PORT_CODE) 
				  AND ( POC.VESSEL_NR = :al_vessel_nr) 
				  AND ( POC.VOYAGE_NR = :as_voyage_nr)  
				  AND ( POC.PORT_ARR_DT <> NULL );

		If sqlca.sqlcode=0 Then
			lds_voyage_numbers = Create datastore
			lds_voyage_numbers.dataobject = "d_commenced_date"
			lds_voyage_numbers.settransobject(sqlca)
													
			li_number_of_rows = lds_voyage_numbers.retrieve(ldt_departure,al_vessel_nr)
			
			If li_number_of_rows = 0 Then
				ldt_commenced_date = ldt_departure
			Elseif li_number_of_rows > 0 Then
				ls_last_voyage_nr = lds_voyage_numbers.getitemstring(1,1)
				
				SELECT DISTINCT MAX(POC.PORT_DEPT_DT)  
				INTO :ldt_departure
				FROM POC,PORTS  
				WHERE ( POC.PORT_CODE = PORTS.PORT_CODE )
				  AND ( POC.VESSEL_NR = :al_vessel_nr) 
				  AND (POC.VOYAGE_NR  = :ls_last_voyage_nr ) 
				  AND (POC.PORT_DEPT_DT <> null )  ;
				 
			End if
			
			If sqlca.sqlcode = 0 Then
				ldt_commenced_date = ldt_departure
			Else
				COMMIT;
				destroy(lds_voyage_numbers)
				RETURN ldt_dummy
			End if
		Else
			COMMIT;
			Destroy(lds_voyage_numbers)
			RETURN ldt_dummy
		End if
		
	CASE 2
		
		SELECT MIN(PORT_ARR_DT)
			INTO :ldt_port_arr_date
			FROM POC
			WHERE (POC.VESSEL_NR = :al_vessel_nr)
			  AND (POC.VOYAGE_NR = :as_voyage_nr);

		If SQLCA.SQLCode <> 0 Then 
			Commit;
			Return ldt_dummy
		End if

		SELECT TCHIRES.TCHIRE_CP_DATE
			INTO :ldt_tchire_cp_date
			FROM TCHIRERATES, TCHIRES
			WHERE (TCHIRES.VESSEL_NR = :al_vessel_nr)
			  AND (TCHIRERATES.TC_PERIOD_START <= :ldt_port_arr_date)
			  AND (TCHIRERATES.TC_PERIOD_END >= :ldt_port_arr_date)
			  AND (TCHIRES.TCHIRE_IN = 0 )
			  AND (TCHIRES.TCHIRE_CP_DATE = TCHIRERATES.TCHIRE_CP_DATE)
			  AND (TCHIRES.VESSEL_NR = TCHIRERATES.VESSEL_NR ) ;
			  
		If SQLCA.SQLCode <> 0 Then 
			Commit;
			Return ldt_dummy
		End if
		
		SELECT min(TCHIRERATES.TC_PERIOD_START)  
		INTO :ldt_commenced_date 
		FROM TCHIRERATES  
		WHERE ( TCHIRERATES.VESSEL_NR = :al_vessel_nr) AND  
				( TCHIRERATES.TCHIRE_CP_DATE = :ldt_tchire_cp_date )   ;
		
		IF IsNull(ldt_commenced_date) THEN 
			COMMIT;
			RETURN ldt_dummy
		ELSE
			IF mid(string(year(date(ldt_commenced_date))),3,2) <> mid(as_voyage_nr,1,2) THEN
				IF integer(mid(as_voyage_nr,1,2)) < 50 THEN
					ldt_commenced_date = datetime(date("20" + mid(as_voyage_nr,1,2) +"/01/01"))
				ELSE
					ldt_commenced_date = datetime(date("19" + mid(as_voyage_nr,1,2) +"/01/01"))
				END IF
			END IF
		END IF
END CHOOSE

COMMIT;
destroy(lds_voyage_numbers)

Return ldt_commenced_date
end function

public function double of_off_hire_exp (long al_row);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
14-07-2000	TAU			
*************************************************************************************/
Double ldb_bun, ldb_gas, ldb_diesel, ldb_exp, ldb_bunton, ldb_gaston, ldb_dieselton

ldb_bun = ids_off.GetItemDecimal(al_row,"tchireoffhires_bunker_price")
If IsNull(ldb_bun) Then ldb_bun = 0
ldb_gas = ids_off.GetItemDecimal(al_row,"tchireoffhires_gas_price")
If IsNull(ldb_gas) Then ldb_gas = 0
ldb_diesel = ids_off.GetItemDecimal(al_row,"tchireoffhires_diesel_price")
If IsNull(ldb_diesel) Then ldb_diesel = 0
ldb_bunton = ids_off.GetItemDecimal(al_row,"tchireoffhires_bunker_ton")
If IsNull(ldb_bunton) Then ldb_bunton = 0
ldb_gaston = ids_off.GetItemDecimal(al_row,"gas_ton_1")
If IsNull(ldb_gaston) Then ldb_gaston = 0
ldb_dieselton = ids_off.GetItemDecimal(al_row,"tchireoffhires_diesel_ton")
If IsNull(ldb_dieselton) Then ldb_dieselton = 0

return (ldb_bun * ldb_bunton + ldb_gas * ldb_gaston + ldb_diesel * ldb_dieselton)
end function

public function integer of_rap_a_f_voyages ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
03-08-2000  1.0	TAU	Used in report "Active/Finished voyages".
************************************************************************************/
Long ll_rows, ll_count, ll_vessel_nr, ll_ret, ll_voyage_type
String ls_voyage_nr, ls_sql
DateTime ldt_commenced_date
Blob blb_data

str_parm lstr_parm
DataStore ds_tmp

ds_tmp = Create datastore
ds_tmp.DataObject = "d_a_f_voyages"
ds_tmp.SetTransObject(SQLCA)
// If more than 75 vessels then use this trick to avoid errors
If istr_sql.ib_vessel Then
	of_change_sql(ds_tmp)
End if
ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[])
If ll_ret = -1 Then Return -1


// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

Return 1
end function

public function integer of_rap_disbursement (string as_type);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
04-08-2000	TAU			Create the reports for Vesse and Port Finished Disbursements.
*************************************************************************************/
Long ll_ret
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If as_type = "Vessel" Then
	If UpperBound(istr_sql.port[]) > 0 Then
		ds_tmp.DataObject = "d_vessel_disbursements"
		ds_tmp.SetTransObject(SQLCA)
		// If more than 75 vessels then use this trick to avoid errors
		If istr_sql.ib_vessel Then
			of_change_sql(ds_tmp)
		End if
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port[])
	ELse
		ds_tmp.DataObject = "d_vessel_disbursements_mm"
		ds_tmp.SetTransObject(SQLCA)
		// If more than 75 vessels then use this trick to avoid errors
		If istr_sql.ib_vessel Then
			of_change_sql(ds_tmp)
		End if
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port_max,istr_sql.port_min)
	End if		
Elseif as_type = "Port" Then
	If UpperBound(istr_sql.port[]) > 0 Then
		ds_tmp.DataObject = "d_port_disbursements"
		ds_tmp.SetTransObject(SQLCA)
		// If more than 75 vessels then use this trick to avoid errors
		If istr_sql.ib_vessel Then
			of_change_sql(ds_tmp)
		End if
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port[])
	ELse
		ds_tmp.DataObject = "d_port_disbursements_mm"
		ds_tmp.SetTransObject(SQLCA)
		// If more than 75 vessels then use this trick to avoid errors
		If istr_sql.ib_vessel Then
			of_change_sql(ds_tmp)
		End if
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port_max,istr_sql.port_min)
	End if
End if	

If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_employment ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
17-07-2000	TAU			Create sql for Empoyment.
*************************************************************************************/
Long ll_rows, ll_count, ll_vessel_nr, ll_ret, ll_test, ll_c
String ls_voyage_nr, ls_grade
Double ldb_ret_1, ldb_ret_2, ldb_ret_3, ldb_ret_4, ldb_ret_5
Blob blb_data

DataStore ds_tmp, ds_bol
str_parm lstr_parm

ds_bol = Create datastore
ds_tmp = Create datastore

If UpperBound(istr_sql.vessel[]) > 0 Then
	ds_tmp.DataObject = "d_employment"
	ds_tmp.SetTransObject(SQLCA)
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[])
Else
	ds_tmp.DataObject = "d_employment_vmm"
	ds_tmp.SetTransObject(SQLCA)
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.years[])
End if

// Loop through ds and get:
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ldb_ret_1 = 0
	ldb_ret_2 = 0
	ldb_ret_3 = 0
	ldb_ret_4 = 0
	ldb_ret_5 = 0
	ll_vessel_nr = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_grade = ds_tmp.GetItemString(ll_count,"bol_grade_name")
	ls_voyage_nr = ds_tmp.GetItemString(ll_count,"bol_voyage_nr")
	
	// Demurrage amount for vessel/voyage/grade combination
	ds_bol.DataObject = "d_bol_dem"
	ds_bol.SetTransObject(SQLCA)
	ds_bol.Retrieve(ll_vessel_nr,ls_grade,ls_voyage_nr)
	ldb_ret_1 = ds_bol.GetItemNumber(1,"demurrage")
	
	ds_bol.DataObject = "d_bol_dem_trans"
	ds_bol.SetTransObject(SQLCA)
   ds_bol.Retrieve(ll_vessel_nr,ls_grade,ls_voyage_nr)
	ldb_ret_2 = ds_bol.GetItemNumber(1,"demurrage_trans")
	
	ds_tmp.SetItem(ll_count,"demurrage",ldb_ret_1 - ldb_ret_2)
	
	// Freight amount for vessel/voyage/freight combination
	ds_bol.DataObject = "d_bol_frt"
	ds_bol.SetTransObject(SQLCA)
	ll_ret = ds_bol.Retrieve(ll_vessel_nr,ls_grade,ls_voyage_nr)
	If ll_ret > 0 Then
		For ll_c = 1 to ll_ret
			ldb_ret_3 += ds_bol.GetItemNumber(1,"frt")
			ldb_ret_4 += ds_bol.GetItemNumber(1,"freight")
		Next
	End if
	
	ds_bol.DataObject = "d_bol_frt_trans"
	ds_bol.SetTransObject(SQLCA)
	ds_bol.Retrieve(ll_vessel_nr,ls_grade,ls_voyage_nr)
	ldb_ret_5 = ds_bol.GetItemNumber(1,"frt_trans")
	
	ds_tmp.SetItem(ll_count,"freight",ldb_ret_3 + ldb_ret_4 - ldb_ret_5)
		
	// Quantity for vessel/voyage/freight combination
	ds_bol.DataObject = "d_bol_quantity"
	ds_bol.SetTransObject(SQLCA)
	ds_bol.Retrieve(ll_vessel_nr,ls_grade,ls_voyage_nr)
	ldb_ret_2 = ds_bol.GetItemNumber(1,"quantity")
	
	ds_tmp.SetItem(ll_count,"quantity",ldb_ret_2)
	
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp
Destroy ds_bol

return 1

end function

public function integer of_rap_fleettracking (string as_type);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
08-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret, ll_claim_nr, ll_test_afc, &
		ll_lumpsum, ll_afc_rows, ll_nr, ll_chart_nr2, ll_vessel_nr2, ll_claim_nr2
String ls_voyage_nr, ls_type, ls_grade_name, ls_voyage_nr2
Decimal ld_ws, ld_rate_mts, ld_ws_rate, ld_lumpsum, ld_rate, ld_quantity
Blob blb_data
Boolean lb_set = false, lb_afc = false

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If as_type = "Vessel" Then
	ds_tmp.DataObject = "d_vessel_fleettracking"
Elseif as_type = "Grade" Then
	ds_tmp.DataObject = "d_grade_fleettracking"
End if	

ds_tmp.SetTransObject(SQLCA)

// If more than 75 vessels then use this trick to avoid errors
If istr_sql.ib_vessel Then
	of_change_sql(ds_tmp)
End if
ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.gradegrp[])
If ll_ret = -1 Then Return -1

// Loop through ds and get:
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	// Investigate if claim is an AFC claim
	ll_vessel_nr = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage_nr = ds_tmp.GetItemString(ll_count,"claims_voyage_nr")
	ll_chart_nr = ds_tmp.GetItemNumber(ll_count,"chart_chart_nr")
	ll_claim_nr = ds_tmp.GetItemNumber(ll_count,"claims_claim_nr")

	SELECT VESSEL_NR
	INTO :ll_test_afc
	FROM FREIGHT_ADVANCED
	WHERE VESSEL_NR = :ll_vessel_nr AND 
			VOYAGE_NR = :ls_voyage_nr AND 
			CHART_NR = :ll_chart_nr AND 
			CLAIM_NR = :ll_claim_nr AND 
			AFC_NR = 1;

		If SQLCA.SQLCode = 0 Then 
			If ll_vessel_nr2 <> ll_vessel_nr or ls_voyage_nr2 <> ls_voyage_nr or &
							ll_chart_nr2 <> ll_chart_nr or ll_claim_nr2 <> ll_claim_nr Then
				ll_vessel_nr2 = ll_vessel_nr
				ls_voyage_nr2 = ls_voyage_nr
				ll_chart_nr2 = ll_chart_nr
				ll_claim_nr2 = ll_claim_nr
				ds_tmp.SetItem(ll_count,"claims_voyage_nr",ls_voyage_nr + " AFC")
				lb_afc = true
			End if
		End if
		COMMIT;
		
	If lb_afc = false Then
		// It is not an AFC claim. Get data to work on
		ld_ws = ds_tmp.GetItemNumber(ll_count,"ws")
		ld_rate_mts = ds_tmp.GetItemNumber(ll_count,"rate")
		ld_ws_rate = ds_tmp.GetItemNumber(ll_count,"ws_rate")
		ld_lumpsum = ds_tmp.GetItemNumber(ll_count,"lumpsum")
		
		If ld_ws > 0 And ld_rate_mts <= 0 And ld_lumpsum <= 0 then 
			ls_type = "WS"
			ld_rate = ld_ws * ld_ws_rate
			lb_set = true
		End if
			
		If ld_ws <= 0 And ld_rate_mts > 0 And ld_lumpsum <= 0 Then
			ls_type = "Rate"
			ld_rate = ld_rate_mts
			lb_set = true
		End if
		
		If ld_ws <= 0 And ld_rate_mts <= 0 And ld_lumpsum > 0 Then
			ls_type = "Lump"
			ld_rate = ld_lumpsum
			lb_set = true
		End if
		
		If lb_set = true Then
			ds_tmp.SetItem(ll_count,"rate_type",ls_type)
			ds_tmp.SetItem(ll_count,"composit_rate",ld_rate)
			lb_set = false
		Else
			ds_tmp.SetItem(ll_count,"rate_type","Non")
			ds_tmp.SetItem(ll_count,"composit_rate",0.00)
			lb_set = false
		End if
		
	Else
		// It is an AFC claim!!
		DataStore ds_afc
		ds_afc = Create datastore
		ds_afc.DataObject = "d_afc_freight_claim"
		ds_afc.SetTransObject(SQLCA)
		ll_afc_rows = ds_afc.Retrieve(ll_vessel_nr,ls_voyage_nr,ll_chart_nr,ll_claim_nr)

		// Add new rows -1 to outer FOR loop
		ll_rows = ll_rows + ll_afc_rows - 1

		For ll_nr = 1 To ll_afc_rows
			ld_ws = ds_afc.GetItemNumber(ll_nr,"afc_ws")
			ld_rate_mts = ds_afc.GetItemNumber(ll_nr,"afc_per_mts")
			ld_ws_rate = ds_afc.GetItemNumber(ll_nr,"afc_ws_rate")
			ld_lumpsum = ds_afc.GetItemNumber(ll_nr,"afc_main_lumpsum")
			ld_quantity = ds_afc.GetItemNumber(ll_nr,"afc_bol_quantity")
			
			ls_grade_name = ds_afc.GetItemString(ll_nr,"afc_grade_name")
			If ls_grade_name = "" or IsNull(ls_grade_name) Then ls_grade_name = "No grade"
		
			If ld_ws > 0 And ld_rate_mts <= 0 And ld_lumpsum <= 0 then 
				ls_type = "WS"
				ld_rate = ld_ws * ld_ws_rate
				lb_set = true
			End if
				
			If ld_ws <= 0 And ld_rate_mts > 0 And ld_lumpsum <= 0 Then
				ls_type = "Rate"
				ld_rate = ld_rate_mts
				lb_set = true
			End if
			
			If ld_ws <= 0 And ld_rate_mts <= 0 And ld_lumpsum > 0 Then
				ls_type = "Lump"
				ld_rate = ld_lumpsum
				lb_set = true
			End if
			
			If ll_nr > 1 Then 
				ds_tmp.RowsCopy(ll_count,ll_count,Primary!,ds_tmp,ll_count + 1,Primary!)
				ll_count++
			End if
				
			ds_tmp.SetItem(ll_count,"quantity",ld_quantity)
			ds_tmp.SetItem(ll_count,"bol_grade_name",ls_grade_name)

			If lb_set = true Then
				ds_tmp.SetItem(ll_count,"rate_type",ls_type)
				ds_tmp.SetItem(ll_count,"composit_rate",ld_rate)
				lb_set = false
			Else
				ds_tmp.SetItem(ll_count,"rate_type","Non")
				ds_tmp.SetItem(ll_count,"composit_rate",0.00)
				lb_set = false
			End if
				
		Next
		Destroy ds_afc
		lb_afc = False
	End if
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)

/* WORKAROUND !!!!!!!!!!!!!!!!!  */
////ds_tmp.print()
//f_datastore_spy(ds_tmp)
//destroy ds_tmp
//return 1
/* END WORKAROUND !!!!!!!!!!!!! */

If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

Return 1
end function

public function integer of_rap_idle_days ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
11-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_rows, ll_count, ll_ret, ll_vessel_nr, ll_previous_vessel_nr=0
//Integer li_day, li_hour, li_min
decimal{4}	ld_days, ld_offservice_days
DateTime ldt_tmp
Boolean lb_recalc = False
DateTime ldt_old_start, ldt_old_end
Decimal ld_tmp1, ld_tmp2, ld_factor
Blob blb_data
string ls_voyage_nr, ls_previous_voyage_nr=""

str_parm lstr_parm
DataStore ds_tmp

ds_tmp = Create datastore
If UpperBound(istr_sql.vessel[]) > 0 Then
	ds_tmp.DataObject = "d_idle_days"
	ds_tmp.SetTransObject(SQLCA)
	ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.year_start,istr_sql.year_end)
Else
	ds_tmp.DataObject = "d_idle_days_vmm"
	ds_tmp.SetTransObject(SQLCA)
	ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.year_start,istr_sql.year_end)
End if
If ll_rows = -1 Then Return -1

// Loop through ds and:
For ll_count = 1 To ll_rows
	// Create the correct date intervals
	ldt_old_start = ds_tmp.GetItemDateTime(ll_count,"idle_days_idle_start")
	ldt_old_end = ds_tmp.GetItemDateTime(ll_count,"idle_days_idle_end")
	
	If Date(ldt_old_start) < istr_sql.year_start Then
		ds_tmp.SetItem(ll_count,"idle_days_idle_start",DateTime(istr_sql.year_start))
		lb_recalc = True
	End if

	If Date(ldt_old_end) > istr_sql.year_end Then
		ds_tmp.SetItem(ll_count,"idle_days_idle_end",DateTime(istr_sql.year_end))
		lb_recalc = True
	End if

	If lb_recalc Then
		ld_tmp1 = of_calc_hours(ds_tmp.GetItemDateTime(ll_count,"idle_days_idle_start"), &
							ds_tmp.GetItemDateTime(ll_count,"idle_days_idle_end")) 
		ld_tmp2 = of_calc_hours(ldt_old_start,ldt_old_end)
		ld_factor = ld_tmp1/ld_tmp2
		
		If ld_factor > 0 And ld_factor <1 And Not IsNull(ld_factor) Then
			ld_days = ds_tmp.GetItemNumber(ll_count,"idle_days")
//			li_hour = ds_tmp.GetItemNumber(ll_count,"idle_days_idle_time_hours")
//			li_min = ds_tmp.GetItemNumber(ll_count,"idle_days_idle_time_minutes")
//			of_new_dhm(li_day,li_hour,li_min,ld_factor)
			ld_days = ld_days + ld_factor
			ds_tmp.SetItem(ll_count,"idle_days",ld_days)
//			ds_tmp.SetItem(ll_count,"idle_days_idle_time_hours",li_hour)
//			ds_tmp.SetItem(ll_count,"idle_days_idle_time_minutes",li_min)
		End if
		lb_recalc = False
	End if
Next

// Fill in computed fields

For ll_count = 1 To ll_rows
	ll_vessel_nr = ds_tmp.getItemNumber(ll_count, "vessels_vessel_nr")
//	ls_voyage_nr = ds_tmp.getItemString(ll_count, "idle_days_voyage_nr")
	if ll_previous_vessel_nr = ll_vessel_nr then
		//same vessel voyage .... do nothing to avoid duplicates
	else
		SELECT SUM(DATEDIFF(MI,INCL_START, INCL_END)*REDUCTION_FACTOR)
		INTO :ld_offservice_days
		FROM (SELECT ((OFF_TIME_DAYS*1440+OFF_TIME_HOURS*60+OFF_TIME_MINUTES)) / (DATEDIFF(mi,OFF_START, OFF_END)*1.0) AS REDUCTION_FACTOR,
				CASE WHEN OFF_START < :istr_sql.year_start THEN :istr_sql.year_start ELSE OFF_START END AS INCL_START,
				CASE WHEN OFF_END > :istr_sql.year_end THEN :istr_sql.year_end ELSE OFF_END END AS INCL_END
			FROM OFF_SERVICES
			WHERE VESSEL_NR = :ll_vessel_nr
			AND OFF_START <> OFF_END
			AND ((OFF_START <= :istr_sql.year_start AND OFF_END > :istr_sql.year_start AND OFF_END < :istr_sql.year_end)
			OR (OFF_START <= :istr_sql.year_start AND OFF_END >= :istr_sql.year_end)
			OR (OFF_START >= :istr_sql.year_start AND OFF_END <= :istr_sql.year_end)
			OR (OFF_START >= :istr_sql.year_start AND OFF_START < :istr_sql.year_end AND OFF_END >= :istr_sql.year_end))) TEMPTABLE ;	
		if isNull(ld_offservice_days) then ld_offservice_days = 0
		ld_offservice_days /= 1440
		ds_tmp.setItem(ll_count, "offservice_days", ld_offservice_days)
	end if
	ll_previous_vessel_nr = ll_vessel_nr
//	ls_previous_voyage_nr = ls_voyage_nr
//	li_day = ds_tmp.GetItemNumber(ll_count,"day_s")
//	li_hour = ds_tmp.GetItemNumber(ll_count,"hour_s")
//	li_min = ds_tmp.GetItemNumber(ll_count,"min_s")
//	of_adjust_dhm(li_day, li_hour, li_min)
//	ds_tmp.SetItem(ll_count,"sum_day",li_day)
//	ds_tmp.SetItem(ll_count,"sum_hour",li_hour)
//	ds_tmp.SetItem(ll_count,"sum_min",li_min)
Next

ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

Return 1

end function

public function integer of_rap_listings ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
10-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_ret, ll_rows, ll_count, ll_type
Decimal ld_quantity, ld_load, ld_dish
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_liftings"
		ds_tmp.SetTransObject(SQLCA)
		ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_liftings_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	End if
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_liftings_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_liftings_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_rows = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	End if
End if

If ll_rows = -1 Then Return -1

For ll_count = 1 To ll_rows
	ll_type = ds_tmp.GetItemNumber(ll_count,"bol_l_d")
	ld_quantity = ds_tmp.GetItemDecimal(ll_count,"bol_bol_quantity")
	If ll_type = 0 Then ds_tmp.SetItem(ll_count,"quantity_l",ld_quantity)
	If ll_type = 1 Then ds_tmp.SetItem(ll_count,"quantity_d",ld_quantity)
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

Return 1
end function

public function integer of_rap_port_rate_grade_temp ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-08-2000	TAU			Create sql for "Port Rate/grade/temp".
*************************************************************************************/
Long ll_ret
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.port[]) > 0 Then
	ds_tmp.DataObject = "d_port_rate_grade_temp"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port[],istr_sql.country[],istr_sql.purpose[])
Else	
	ds_tmp.DataObject = "d_port_rate_grade_temp_mm"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.port_max,istr_sql.port_min,istr_sql.country[],istr_sql.purpose[])
End if

If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_top_broker ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
21-08-2000  1.0	TAU	Used to create report "Top Broker".
************************************************************************************/
Long ll_ret, ll_Count, ll_Vessel_NR, ll_Broker_NR
String ls_Voyage_NR
Blob blb_data

str_parm lstr_parm

//DataStore ds_tmp
n_ds ds_tmp
//ds_tmp = Create datastore
ds_tmp = Create n_ds
If UpperBound(istr_sql.vessel[]) > 0 Then
	ds_tmp.DataObject = "d_top_broker"
	ds_tmp.SetTransObject(SQLCA)
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[])
Else
	ds_tmp.DataObject = "d_top_broker_vmm"
	ds_tmp.SetTransObject(SQLCA)
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.years[])
End if
If ll_ret = -1 Then Return -1

// Count thru rows
//For ll_count = 1 To ll_ret
//	ll_vessel_nr = ds_tmp.GetItemNumber(ll_Count,"vessels_vessel_nr")
//	ls_voyage_nr = ds_tmp.GetItemString(ll_Count,"voyages_voyage_nr")
//	ll_Broker_nr = ds_tmp.GetItemNumber(ll_Count,"brokers_broker_nr")	
//	If Upper(ls_Voyage_Nr) = "TC-OUT" then ds_tmp.SetItem(ll_Count,"voyages_voyage_nr", "TC-OUT: " + of_GetVoyageNumbersForTC(ll_vessel_nr, ll_Broker_nr, istr_sql.years, 1))
//Next

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

Return 1
end function

public function integer of_rap_vessel_port_visits ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-08-2000	TAU			Create sql for Vessel Ports Visits
*************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret
String ls_voyage_nr
Decimal ld_total_comm, ld_comm
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
ds_tmp.DataObject = "d_vessel_port_visits"
ds_tmp.SetTransObject(SQLCA)
// If more than 75 vessels then use this trick to avoid errors
If istr_sql.ib_vessel Then
	of_change_sql(ds_tmp)
End if
ll_ret= ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[])
If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_tdf ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
29-06-2000	TAU			Create sql for tdf
07-07-2000	TAU			Modified to only handle report creation, not the retrieval arg.
17-07-2000	TAU			Fjernelse af commission fra beregningen og dataobjectet.
*************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret, ll_freight, ll_demurrage, &
		ll_vessel, ll_vessel_prv, ll_null
String ls_voyage_nr, ls_voyage, ls_voyage_prv, ls_chart, ls_chart_prv
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_tdf"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_tdf_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	End if	
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_tdf_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_tdf_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	End if	
End if
If ll_ret = -1 Then Return -1

// Loop through ds and get:
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ll_vessel_nr = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage_nr = ds_tmp.GetItemString(ll_count,"voyages_voyage_nr")
	ll_chart_nr = ds_tmp.GetItemNumber(ll_count,"chart_chart_nr")
	
	// Demurrage amount for vessel/voyage/charterer combination
	ll_demurrage = of_demurrage(ll_vessel_nr, ls_voyage_nr, ll_chart_nr)
	ds_tmp.SetItem(ll_count,"demurrage",ll_demurrage)
	
	// Freight amount for vessel/voyage/charterer combination
	ll_freight = of_freight(ll_vessel_nr, ls_voyage_nr, ll_chart_nr)
	ds_tmp.SetItem(ll_count,"freight",ll_freight)	
	
	ds_tmp.SetItem(ll_count,"total",ll_demurrage + ll_freight)
Next

ll_vessel_prv = 0
ls_voyage_prv = "00"
ls_chart_prv = "xyz"
SetNull(ll_null)

For ll_count = 1 To ll_rows
	// Get vessel, voyage and charter and delete claim amount, transactions and outstanding for all
	// but the first row for each combination.
	ll_vessel = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage = ds_tmp.GetItemString(ll_count,"voyages_voyage_nr")
	ls_chart = ds_tmp.GetItemString(ll_count,"chart_chart_n_1")
	
	If (ll_vessel = ll_vessel_prv) And (ls_voyage = ls_voyage_prv) And (ls_chart = ls_chart_prv) Then
		ds_tmp.SetItem(ll_count,"demurrage",ll_null)
		ds_tmp.SetItem(ll_count,"freight",ll_null)
		ds_tmp.SetItem(ll_count,"total",ll_null)
	Else
		ll_vessel_prv = ll_vessel
		ls_voyage_prv = ls_voyage
		ls_chart_prv = ls_chart
	End if
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_new_dhm (ref integer ai_day, ref integer ai_hour, ref integer ai_min, decimal ad_factor);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
14-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Decimal ld_day, ld_hour, ld_min
Integer li_day, li_hour, li_min, li_tmp

// Calculate days from factor
ld_day = ai_day * ad_factor
li_day = Int(ld_day)
ld_day = ld_day - li_day
If ld_day > 0.5 Then li_day = li_day + 1

// Calculate hours from days
ld_hour = ld_day/(1/24)
li_hour = Int(ld_hour)
ld_hour = ld_hour - li_hour
If ld_hour > 0.5 Then li_hour = li_hour + 1

// Calculate minutes from days
ld_min = ld_hour/(1/60)
li_min = Int(ld_min)
ld_min = ld_min - li_min
If ld_min > 0.5 Then li_min = li_min + 1

// Calculate hours from factor
ld_hour = ai_hour * ad_factor
li_tmp = Int(ld_hour)
ld_hour = ld_hour - li_tmp
If ld_hour > 0.5 Then 
	li_hour += li_tmp + 1
Else
	li_hour += li_tmp
End if

// Calculate minutes from hours
ld_min = ld_hour/(1/60)
li_min += Int(ld_min)

// Calculate minutes from factor
ld_min = ai_min * ad_factor
li_min += Int(ld_min)

of_adjust_dhm(li_day, li_hour, li_min)

ai_day = li_day
ai_hour = li_hour
ai_min = li_min

Return 1
end function

public function integer of_rap_broker_dem_stat ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-05-2001	TAU			Initial version
12-06-2001	TAU			New version based on modifications of the charterer demurrage 
								statistics report.
*************************************************************************************/
Long ll_rows, ll_count, ll_ret, ll_days, ll_vessel, ll_vessel_prv, ll_null, ll_i, ll_upper, &
		ll_new, ll_claim_nr, ll_chart_nr
Decimal {2} ld_claim, ld_transaction, ld_balance, ld_no_c_trans, ld_cl, ld_tr, ld_recieved, ld_x
String ls_voyage, ls_voyage_prv, ls_broker, ls_chart_prv, ls_chargp_name, ls_broker_names[], ls_null[], &
		ls_transactions, ls_code
Blob blb_data
Decimal ld_tc
Boolean lb_stop, lb_same
w_print_preview wx1, wx2, wx3, wx4

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		If UpperBound(istr_sql.brokers[]) > 0 Then
			ds_tmp.DataObject = "d_broker_dem_stat"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
															istr_sql.charterer[],istr_sql.years[],istr_sql.brokers[])
		Else
			ds_tmp.DataObject = "d_broker_dem_stat_bmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
															istr_sql.charterer[],istr_sql.years[],istr_sql.broker_min, &
															istr_sql.broker_max)
		End if			
	Else
		If UpperBound(istr_sql.brokers[]) > 0 Then
			ds_tmp.DataObject = "d_broker_dem_stat_vmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
															istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[], &
															istr_sql.brokers[])
		Else
			ds_tmp.DataObject = "d_broker_dem_stat_vmm_bmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
															istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[], &
															istr_sql.broker_min,istr_sql.broker_max)
		End if
	End if	
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		If UpperBound(istr_sql.brokers[]) > 0 Then
			ds_tmp.DataObject = "d_broker_dem_stat_mm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
															istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[], &
															istr_sql.brokers[])
		Else
			ds_tmp.DataObject = "d_broker_dem_stat_mm_bmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
															istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[], &
															istr_sql.broker_min,istr_sql.broker_max)
		End if
	Else
		If UpperBound(istr_sql.brokers[]) > 0 Then
			ds_tmp.DataObject = "d_broker_dem_stat_mm_vmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
															istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max, &
															istr_sql.years[],istr_sql.brokers[])
		Else
			ds_tmp.DataObject = "d_broker_dem_stat_mm_vmm_bmm"
			ds_tmp.SetTransObject(SQLCA)
			ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
															istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max, &
															istr_sql.years[],istr_sql.broker_min,istr_sql.broker_max)
		End if
	End if	
End if
If ll_ret = -1 Then 
	MessageBox("Information","It was not possible to create the report with the specified data. ~r~n " +&
					"Reduce the number of data and try again!",StopSign!,OK!)
	Return 1
End if

// Loop through ds and do..........
ll_vessel_prv = 0
ls_voyage_prv = "00"
ls_chart_prv = "xyz"
datetime ldt_null
SetNull(ll_null)
SetNull(ldt_null)
ls_broker_names[] = ls_null[]
lb_same = False

ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ld_claim = ds_tmp.GetItemNumber(ll_count,"claim_amount")
	ld_transaction = ds_tmp.GetItemNumber(ll_count,"transactions")
	ld_no_c_trans = ds_tmp.GetItemNumber(ll_count,"no_c_trans")
	ld_recieved = ds_tmp.GetItemNumber(ll_count,"claim_recieved")
	
	If Not IsNull(ld_claim) Then
		ld_balance = ld_claim - ld_transaction
		If ld_balance <= 0 Then
			ds_tmp.SetItem(ll_count,"balance",ld_transaction)
			// Outstanding must be a regular field as the column must be editable, i.e. not a computed field
			ds_tmp.SetItem(ll_count,"outstanding",0)
			// If any recieved amount then use youngest recieved date as settlement date, else
			// If no recieved amount then use youngest write off or adjustment date as settlement date
			If ds_tmp.GetItemNumber(ll_count,"recieved") = 0 Then
				ds_tmp.SetItem(ll_count,"settlement_date",ds_tmp.GetItemDatetime(ll_count,"settlement_date_aw"))
			End if
		Elseif ld_balance > 0 Then
			ds_tmp.SetItem(ll_count,"balance",ld_no_c_trans)
			ds_tmp.SetItem(ll_count,"outstanding",ld_claim - ld_no_c_trans )
			// Used to give the field background colour if there is outstanding claims
			ds_tmp.SetItem(ll_count,"colour_change",1)
			// If any outstanding amount then no settlement date!
			ds_tmp.SetItem(ll_count,"settlement_date",ldt_null)
		End if
	End if
	
	// Find the number of outstanding days. If no outstanding then between forwarding and settle date, else today
	If ds_tmp.GetItemNumber(ll_count,"outstanding") > 0 Then
		ll_days = DaysAfter(Date(ds_tmp.GetItemDatetime(ll_count,"claims_forwarding_date")),Today())
	Else
		ll_days = DaysAfter(Date(ds_tmp.GetItemDatetime(ll_count,"claims_forwarding_date")),&
																Date(ds_tmp.GetItemDatetime(ll_count,"settlement_date")))
	End if
	ds_tmp.SetItem(ll_count,"outstanding_days",ll_days)

	// Move comment text and code into other fields to avoid length restrictions
	ds_tmp.SetItem(ll_count,"comments",ds_tmp.GetItemString(ll_count,"claim_action_c_action_comment"))
	ds_tmp.SetItem(ll_count,"codes",ds_tmp.GetItemString(ll_count,"claim_action_c_action_tx_nr"))
	
	// Set claim recieved % according to the rules below
	If ds_tmp.GetItemNumber(ll_count,"recieved") > 0 Then
		If ld_no_c_trans <= 0 Then
			ds_tmp.SetItem(ll_count,"claim_recieved_pct",0)
		Else
			ds_tmp.SetItem(ll_count,"claim_recieved_pct",(ld_recieved / ld_claim) * 100)
		End if
	Else
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",0)
	End if

	// Set counting used to calculate the results, only for claims with a settlement date
	If IsNull(ds_tmp.GetItemDateTime(ll_count,"settlement_date")) Then
		ds_tmp.SetItem(ll_count,"counting",0)
	Else
		ds_tmp.SetItem(ll_count,"counting",1)
	End if


	// If there is no outstanding demurrage the line most be modified as follows
	If ld_claim < 0 Then
		ds_tmp.SetItem(ll_count,"claim_amount",ll_null)
		ds_tmp.SetItem(ll_count,"outstanding",ll_null)
		ds_tmp.SetItem(ll_count,"nill_outstanding","Nil")
		ds_tmp.SetItem(ll_count,"balance",ll_null)
		ds_tmp.SetItem(ll_count,"no_outstanding_days","N/a")
		ds_tmp.SetItem(ll_count,"counting",0)
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",ll_null)
	End if

	// Get vessel, voyage and charter and delete all but the comment fields for all
	// but the first row for each combination.
	ll_vessel = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage = ds_tmp.GetItemString(ll_count,"claims_voyage_nr")
	ls_broker = ds_tmp.GetItemString(ll_count,"broker_name")

	If (ll_vessel = ll_vessel_prv) And (ls_voyage = ls_voyage_prv) Then
		ds_tmp.SetItem(ll_count,"vessels_vessel_name","")
		ds_tmp.SetItem(ll_count,"claims_voyage_nr","")
		ds_tmp.SetItem(ll_count,"vessels_vessel_nr",ll_null)
		ds_tmp.SetItem(ll_count,"chart_chart_n_1","")
		ds_tmp.SetItem(ll_count,"claims_cp_date",ldt_null)
		ds_tmp.SetItem(ll_count,"claims_forwarding_date",ldt_null)
		ds_tmp.SetItem(ll_count,"settlement_date",ldt_null)
		ds_tmp.SetItem(ll_count,"outstanding_days",ll_null)
		ds_tmp.SetItem(ll_count,"claim_amount",ll_null)
		ds_tmp.SetItem(ll_count,"outstanding",ll_null)
		ds_tmp.SetItem(ll_count,"balance",ll_null)
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",ll_null)
		ds_tmp.SetItem(ll_count,"counting",0)
	Else
		ll_vessel_prv = ll_vessel
		ls_voyage_prv = ls_voyage
	End if

	// Used in headline 2 (for brokers!)
	ll_upper = UpperBound(ls_broker_names[])
	If ll_upper = 0 Then
		ls_broker_names[1] = ls_broker
	Else
		For ll_i = 1 To ll_upper
			If ls_broker_names[ll_i] = ls_broker Then 
				lb_same = True
			End if
		Next
		If Not lb_same Then 
			ls_broker_names[ll_upper + 1] = ls_broker
		End if
		lb_same = False
	End if

Next

If UpperBound(ls_broker_names[]) = 0 Then
	ls_broker_names[1] = ls_broker
end if
	
// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw. The window must be opened as
// a sheet to enable many open windows at the same time
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	If UpperBound(istr_sql.brokers[]) > 0 Then 
		ll_count = UpperBound(istr_sql.brokers[])
	Elseif istr_sql.broker_max > 0 Then
		ll_count = istr_sql.broker_max
	End if
	If ll_count > 1 Then
		lstr_parm.parameters = "More than one Broker selected - Broker Demurrage Statistics"
	Else
		lstr_parm.parameters = ls_broker_names[1] + " - Broker Demurrage Statistics"
	End if

	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	
	If ii_sheet_count = 0 Then
		OpenSheetWithParm(wx1,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count = 1 Then
		OpenSheetWithParm(wx2,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count = 2 Then
		OpenSheetWithParm(wx3,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count >= 3 Then
		OpenSheetWithParm(wx4,lstr_parm,w_tramos_main,0,Original!)
		
	End if	
	ii_sheet_count++
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_comissions ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
14-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_ret
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.brokers[]) > 0 Then
	ds_tmp.DataObject = "d_commissions_x"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.brokers[])
Else
	ds_tmp.DataObject = "d_commissions_mm"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.broker_min,istr_sql.broker_max)
End if
If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp


Return 1
end function

public function integer of_change_sql (ref datastore ads_sql);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
31-08-2000  1.0	TAU	Initial version. Change the sql to be all vessels.
************************************************************************************/
String ls_replace, ls_sql, ls_new, ls_ret

// Use modify as SetSQLSelect() dosn't work when theres arguments on the dataobject
ls_sql = ads_sql.Object.DataWindow.Table.Select
ls_replace = "( VESSELS.VESSEL_NR in ( :vessel_nr ) ) AND"
ls_new = Replace(ls_sql,Pos(ls_sql,ls_replace),Len(ls_replace),"")
if ads_sql.dataObject = "d_commissions_mm" or ads_sql.dataObject = "d_commissions_x" then
	/* run changes twice as the sql-statement is a union */
	ls_sql = ls_new
	ls_new = Replace(ls_sql,Pos(ls_sql,ls_replace),Len(ls_replace),"")
end if
ls_sql = "DataWindow.Table.Select='" +ls_new+ "' "
ls_ret = ads_sql.Modify(ls_sql)
If ls_ret = "" Then 
	Return 1
Else
	Return -1
End if
end function

public subroutine of_reset ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
20-06-2000	TAU			
*************************************************************************************/
// uo_'s
w_reports_gv.uo_broker.ib_enabled = false
w_reports_gv.uo_broker.TriggerEvent("ue_childmodified")
w_reports_gv.uo_broker.ii_left_total = 0

w_reports_gv.uo_charterer.ib_enabled = false
w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")
w_reports_gv.uo_charterer.ii_left_total = 0

w_reports_gv.uo_charterer_grp.ib_enabled = false
w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
w_reports_gv.uo_charterer_grp.ii_left_total = 0

w_reports_gv.uo_country.ib_enabled = false
w_reports_gv.uo_country.visible = true
w_reports_gv.uo_country.TriggerEvent("ue_childmodified")
w_reports_gv.uo_country.ii_left_total = 0

w_reports_gv.uo_country_charterer.ib_enabled = false
w_reports_gv.uo_country_charterer.Visible = False
w_reports_gv.uo_country_charterer.TriggerEvent("ue_childmodified")
w_reports_gv.uo_country_charterer.ii_left_total = 0

w_reports_gv.uo_grade_grp.ib_enabled = false
w_reports_gv.uo_grade_grp.TriggerEvent("ue_childmodified")
w_reports_gv.uo_grade_grp.ii_left_total = 0

w_reports_gv.uo_port.ib_enabled = false
w_reports_gv.uo_port.TriggerEvent("ue_childmodified")
w_reports_gv.uo_port.ii_left_total = 0

w_reports_gv.uo_profit_center.ib_enabled = false
w_reports_gv.uo_profit_center.TriggerEvent("ue_childmodified")
w_reports_gv.uo_profit_center.ii_left_total = 0

w_reports_gv.uo_purpose.ib_enabled = false
w_reports_gv.uo_purpose.TriggerEvent("ue_childmodified")
w_reports_gv.uo_purpose.ii_left_total = 0

w_reports_gv.uo_vessel.ib_enabled = false
w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
w_reports_gv.uo_vessel.ii_left_total = 0

w_reports_gv.uo_shiptype.ib_enabled = false
w_reports_gv.uo_shiptype.TriggerEvent("ue_childmodified")
w_reports_gv.uo_shiptype.ii_left_total = 0

// Year
w_reports_gv.sle_start_year.SelectText(1, Len(w_reports_gv.sle_start_year.Text))
w_reports_gv.sle_start_year.ReplaceText("")
w_reports_gv.sle_start_year.Enabled = False
w_reports_gv.st_year_start.Text = "Year (yy)"
//w_reports_gv.sle_end_year.Enabled = False
w_reports_gv.sle_end_year.Visible = False
w_reports_gv.st_year_end.Visible = False

// Explanation
w_reports_gv.st_exp.Text = ""

// Buttons
w_reports_gv.cb_create_report.Enabled = False
w_reports_gv.cb_reset.Enabled = False









end subroutine

public function integer of_rap_coa_liftings_cvs ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
10-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret, ll_claim_nr, ll_test_afc, &
		ll_lumpsum, ll_afc_rows, ll_nr, ll_chart_nr2, ll_vessel_nr2, ll_claim_nr2
String ls_voyage_nr, ls_type, ls_grade_name, ls_voyage_nr2
Decimal ld_quantity
Blob blb_data
Boolean lb_afc = false

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_coa_cvs"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_coa_cvs_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	End if
ELse
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_coa_cvs_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_coa_cvs_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	End if
End if

If ll_ret = -1 Then Return -1

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp





Return 1
end function

public function integer of_get_sql_data ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
19-06-2000	TAU			A function will return 0 or all to indicate that all possible
								objects should be used, i.e. all profit centers or all vessels.
07-07-2000	TAU			Rewrite inserts retrieval arguments directly into an array in
								instance structure str_sql.
18-08-2000	TAU			Total rewrite because of new userinterface with dragdrop boxes.
*************************************************************************************/
Long ll_rows, ll_count, ll_ret = 1, ll_null[]
String ls_text, ls_tmp, ls_err
Datastore ds_tmp
str_sql lstr_sql

istr_sql = lstr_sql
SetPointer(HourGlass!)
ls_err = "There was an error in the criteria. No argument was choosen in "
istr_sql.parameters = "Report name = " +is_report_name+ ". Parameters are: "

// Broker ****************************************************************************
If w_reports_gv.uo_broker.ib_enabled Then
	SetNull(istr_sql.broker_min)
	SetNull(istr_sql.broker_max)
	istr_sql.brokers[] = ll_null[]
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_broker.dw_right.RowCount()
	If ll_rows = 0 Then
		// No rows
		ls_err += "Broker, "
		ll_ret = -1
		
	Elseif ll_rows < 75 Then
		// Fewer than 75 rows
		istr_sql.parameters += "Brokers, "
		For ll_count = 1 to ll_rows
			istr_sql.brokers[ll_count] = w_reports_gv.uo_broker.dw_right.GetItemNumber(ll_count,"broker_nr")
		Next
	
	Elseif ll_rows >= 75 And ll_rows < w_reports_gv.uo_broker.ii_left_total Then
		// More than 75 rows but not all rows
		MessageBox("Warning","To many Brokers choosen. You can either reduse the number to < 75 or choose all possilble Brokers",StopSign!,OK!)
	Else
		// All rows
		istr_sql.broker_min = 0
		istr_sql.broker_max = 9999
		istr_sql.parameters += "Broker = All, "
	
	End if
End if
	
// Charterer *************************************************************************
If w_reports_gv.uo_charterer.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_charterer.dw_right.RowCount()
	If ll_rows = 0 Then
		// No rows
		ls_err += "Charterer, "
		ll_ret = -1

	Elseif ll_rows < 75 Then
		// Fewer than 75 rows
		istr_sql.parameters += "Charterers, "
		For ll_count = 1 to ll_rows
			istr_sql.charterer[ll_count] = w_reports_gv.uo_charterer.dw_right.GetItemNumber(ll_count,"chart_nr")
		Next
	
	Elseif ll_rows >= 75 And ll_rows < w_reports_gv.uo_charterer.ii_left_total Then
		// More than 75 rows but not all rows
		MessageBox("Warning","To many charterers choosen. You can either reduse the number to < 75 or choose all possilble charterers",StopSign!,OK!)
	Else
		// All rows
		istr_sql.chart_min = 0
		istr_sql.chart_max = 9999
		istr_sql.parameters += "Charterer = All, "
	
	End if
End if

// Port ******************************************************************************
If w_reports_gv.uo_port.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_port.dw_right.RowCount()
	If ll_rows = 0 Then
		// No rows
		ls_err += "Port, "
		ll_ret = -1

	Elseif ll_rows < 75 Then
		// Fewer than 75 rows
		istr_sql.parameters += "Ports = "
		For ll_count = 1 to ll_rows
			istr_sql.port[ll_count] = w_reports_gv.uo_port.dw_right.GetItemstring(ll_count,"port_code")
		Next
	
	Elseif ll_rows >= 75 And ll_rows < w_reports_gv.uo_port.ii_left_total Then
		// More than 75 rows but not all rows
		MessageBox("Warning","To many ports choosen. You can either reduse the number to < 75 or choose all possilble ports",StopSign!,OK!)
	Else
		// All rows
		istr_sql.port_min = "0"
		istr_sql.port_max = "ZZZZZZZZZZZZZZZ"
		istr_sql.parameters += "Port = all, "
	
	End if
End if

// Vessel ****************************************************************************
If w_reports_gv.uo_vessel.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_vessel.dw_right.RowCount()
	If ll_rows = 0 Then
		// No rows
		ls_err += "Vessel, "
		ll_ret = -1

	Elseif ll_rows < 75 Then
		// Fewer than 75 rows
		istr_sql.parameters += "Vessels, "
		For ll_count = 1 to ll_rows
			istr_sql.vessel[ll_count] = w_reports_gv.uo_vessel.dw_right.GetItemNumber(ll_count,"vessel_nr")
		Next
	
	Elseif ll_rows >= 75 And ll_rows < w_reports_gv.uo_charterer.ii_left_total Then
		// More than 75 rows but not all rows
		istr_sql.ib_vessel = True
		MessageBox("Warning","To many vessels choosen. You can either reduse the number to < 75 or choose all possilble vessls",StopSign!,OK!)

	Else
		istr_sql.ib_vessel = True
		istr_sql.vessel_min = 0
		istr_sql.vessel_max = 9999
		istr_sql.parameters += "Vessel = All, "

	End if
End if

// Charterer group *******************************************************************
If w_reports_gv.uo_charterer_grp.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_charterer_grp.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Charterer groups, "
		For ll_count = 1 to ll_rows
			istr_sql.chartgrp[ll_count] = w_reports_gv.uo_charterer_grp.dw_right.GetItemNumber(ll_count,"ccs_chgp_pk")
		Next
	Else
		ls_err += "Charterer group, "
		ll_ret = -1
	End if
End if

// Profit center *********************************************************************
If w_reports_gv.uo_profit_center.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_profit_center.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Profit centers, "
		For ll_count = 1 to ll_rows
			istr_sql.pc[ll_count] = w_reports_gv.uo_profit_center.dw_right.GetItemNumber(ll_count,"pc_nr")
		Next
	Else
		ls_err += "Profit center, "
		ll_ret = -1
	End if
End if

// Shiptype **********************************************************************
If w_reports_gv.uo_shiptype.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_shiptype.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Shiptypes, "
		For ll_count = 1 to ll_rows
			istr_sql.vesselgrp[ll_count] = w_reports_gv.uo_shiptype.dw_right.GetItemNumber(ll_count,"cal_vest_type_id")
		Next
	Else
		ls_err += "Vessel group, "
		ll_ret = -1
	End if
End if

// Grade group ***********************************************************************
If w_reports_gv.uo_grade_grp.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_grade_grp.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Grade groups, "
		For ll_count = 1 to ll_rows
			istr_sql.gradegrp[ll_count] = w_reports_gv.uo_grade_grp.dw_right.GetItemString(ll_count,"grade_group")
		Next
	Else
		ls_err += "Grade group, "
		ll_ret = -1
	End if
End if

// Purpose ***************************************************************************
If w_reports_gv.uo_purpose.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_purpose.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Purposes, "
		For ll_count = 1 to ll_rows
			istr_sql.purpose[ll_count] = w_reports_gv.uo_purpose.dw_right.GetItemString(ll_count,"purpose_code")
		Next
	Else
		ls_err += "Purpose, "
		ll_ret = -1
	End if
End if

// Country ***************************************************************************
If w_reports_gv.uo_country.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_country.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Countries = "
		For ll_count = 1 to ll_rows
			istr_sql.country[ll_count] = w_reports_gv.uo_country.dw_right.GetItemNumber(ll_count,"ports_country_id")
		Next
	Else
		ls_err += "Country, "
		ll_ret = -1
	End if
End if

// Country (charterer) ***************************************************************
If w_reports_gv.uo_country_charterer.ib_enabled Then
	// Investigate the number of rows
	ll_rows = w_reports_gv.uo_country_charterer.dw_right.RowCount()
	If ll_rows > 0 Then
		istr_sql.parameters += "Countries (chart) = "
		For ll_count = 1 to ll_rows
			istr_sql.country_chart[ll_count] = w_reports_gv.uo_country_charterer.dw_right.GetItemString(ll_count,"chart_c")
		Next
	Else
		ls_err += "Country (chart), "
		ll_ret = -1
	End if
End if

// Year ******************************************************************************
If (w_reports_gv.sle_start_year.enabled or w_reports_gv.sle_start_year_date.enabled)  And Not(w_reports_gv.sle_end_year.visible) Then
	if  w_reports_gv.sle_start_year.enabled = True then
		ls_text = w_reports_gv.sle_start_year.Text
	else
		w_reports_gv.sle_start_year_date.accepttext()
		ls_text = string(w_reports_gv.sle_start_year_date.getitemdate(1,"date_value"))
	end if

	ll_count = 0
	istr_sql.parameters += "Year = "
	
	DO
		ls_tmp = f_Get_Token(ls_text,",")
		ll_count ++
		istr_sql.years[ll_count] = trim(ls_tmp)
		istr_sql.parameters += String(istr_sql.years[ll_count]) +", "
	
		If len(istr_sql.years[ll_count]) <> 2 Then
			ls_err += "Start year, "
			ll_ret = -1
		End if
		
	LOOP UNTIL ls_text = ""
End if

If (w_reports_gv.sle_start_year.enabled or w_reports_gv.sle_start_year_date.enabled) and w_reports_gv.sle_end_year.visible Then
	if  w_reports_gv.sle_start_year.enabled = True then
		ls_tmp = w_reports_gv.sle_start_year.Text
	else
		w_reports_gv.sle_start_year_date.accepttext()
		ls_tmp = string(w_reports_gv.sle_start_year_date.getitemdate(1,"date_value"))
	end if
	istr_sql.year_start = Date(trim(ls_tmp))
	istr_sql.parameters += "Start year = " +String(istr_sql.year_start) +", "

	If Not IsDate(ls_tmp) Then
		ls_err += "Start year, "
		ll_ret = -1
	End if
	
	w_reports_gv.sle_end_year.accepttext()
	ls_tmp = string(w_reports_gv.sle_end_year.GetItemDate(1, "date_value"))

	istr_sql.year_end = Date(trim(ls_tmp))
	istr_sql.parameters += "End year = "+ String(istr_sql.year_end) +", "

	If Not IsDate(ls_tmp) Then
		ls_err += "End year"
		ll_ret = -1
	End if
		
End if

If ll_ret = -1 Then
	MessageBox("Error",ls_err,StopSign!,OK!)
End if

Return ll_ret

end function

public function integer of_rap_chart_country ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
10-07-2000	TAU			Create sql for Charterer home country support
*************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret
String ls_voyage_nr
Decimal ld_total_comm, ld_comm
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_charter_country"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.country_chart[],istr_sql.chartgrp[],istr_sql.charterer[])
	ELse
		ds_tmp.DataObject = "d_charter_country_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.years[],istr_sql.country_chart[],istr_sql.chartgrp[],istr_sql.charterer[])
	End if
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_charter_country_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.years[],istr_sql.country_chart[],istr_sql.chartgrp[],istr_sql.chart_max,istr_sql.chart_min)
	Else
		ds_tmp.DataObject = "d_charter_country_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.years[],istr_sql.country_chart[],istr_sql.chartgrp[],istr_sql.chart_max,istr_sql.chart_min)
	End if
End if
If ll_ret = -1 Then Return -1

// Loop through ds and get:
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ll_vessel_nr = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage_nr = ds_tmp.GetItemString(ll_count,"voyages_voyage_nr")
	ll_chart_nr = ds_tmp.GetItemNumber(ll_count,"chart_chart_nr")
	
	// Demurrage amount for vessel/voyage/charterer combination
	ds_tmp.SetItem(ll_count,"demurrage",of_demurrage(ll_vessel_nr, ls_voyage_nr, ll_chart_nr))
	
	// Freight amount for vessel/voyage/charterer combination
	ds_tmp.SetItem(ll_count,"freight",of_freight(ll_vessel_nr, ls_voyage_nr, ll_chart_nr))	
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_chart_dem_stat ();	/*************************************************************************************
DATE			INITIALS		DESCRIPTION
25-04-2001	TAU			Initial version
*************************************************************************************/
Long ll_rows, ll_count, ll_ret, ll_days, ll_vessel, ll_vessel_prv, ll_null, ll_i, ll_upper, &
		ll_new, ll_claim_nr, ll_chart_nr
Decimal {2} ld_claim, ld_transaction, ld_balance, ld_no_c_trans, ld_cl, ld_tr, ld_recieved, ld_x
String ls_voyage, ls_voyage_prv, ls_chart, ls_chart_prv, ls_chargp_name, ls_chart_names[], ls_null[], &
		ls_transactions, ls_code
Blob blb_data
Decimal ld_tc
Boolean lb_stop, lb_same
w_print_preview wx1, wx2, wx3, wx4


str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_chart_dem_stat"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
														istr_sql.charterer[],istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_chart_dem_stat_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
														istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	End if	
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_chart_dem_stat_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[], &
														istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_chart_dem_stat_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max, &
														istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	End if	
End if
If ll_ret = -1 Then 
	MessageBox("Information","It was not possible to create the report with the specified data. ~r~n " +&
					"Please reduce the number of data and try again!",StopSign!,OK!)
	Return 1
End if

// Loop through ds and do..........
ll_vessel_prv = 0
ls_voyage_prv = "00"
ls_chart_prv = "xyz"
datetime ldt_null
SetNull(ll_null)
SetNull(ldt_null)
ls_chart_names[] = ls_null[]
lb_same = False

ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ld_claim = ds_tmp.GetItemNumber(ll_count,"claim_amount")
	ld_transaction = ds_tmp.GetItemNumber(ll_count,"transactions")
	ld_no_c_trans = ds_tmp.GetItemNumber(ll_count,"no_c_trans")
	ld_recieved = ds_tmp.GetItemNumber(ll_count,"claim_recieved")
	
	If Not IsNull(ld_claim) Then
		ld_balance = ld_claim - ld_transaction
		If ld_balance <= 0 Then
			ds_tmp.SetItem(ll_count,"balance",ld_transaction)
			// Outstanding must be a regular field as the column must be editable, i.e. not a computed field
			ds_tmp.SetItem(ll_count,"outstanding",0)
			// If any recieved amount then use youngest recieved date as settlement date, else
			// If no recieved amount then use youngest write off or adjustment date as settlement date
			If ds_tmp.GetItemNumber(ll_count,"recieved") = 0 Then
				ds_tmp.SetItem(ll_count,"settlement_date",ds_tmp.GetItemDatetime(ll_count,"settlement_date_aw"))
			End if
		Elseif ld_balance > 0 Then
			ds_tmp.SetItem(ll_count,"balance",ld_no_c_trans)
			ds_tmp.SetItem(ll_count,"outstanding",ld_claim - ld_no_c_trans )
			// Used to give the field background colour if there is outstanding claims
			ds_tmp.SetItem(ll_count,"colour_change",1)
			// If any outstanding amount then no settlement date!
			ds_tmp.SetItem(ll_count,"settlement_date",ldt_null)
		End if
	End if

	// Find the number of outstanding days. If no outstanding then between forwarding and settle date, else today
	If ds_tmp.GetItemNumber(ll_count,"outstanding") > 0 Then
		ll_days = DaysAfter(Date(ds_tmp.GetItemDatetime(ll_count,"claims_forwarding_date")),Today())
	Else
		ll_days = DaysAfter(Date(ds_tmp.GetItemDatetime(ll_count,"claims_forwarding_date")),&
																Date(ds_tmp.GetItemDatetime(ll_count,"settlement_date")))
	End if
	ds_tmp.SetItem(ll_count,"outstanding_days",ll_days)

	// Move comment text and code into other fields to avoid length restrictions
	ds_tmp.SetItem(ll_count,"comments",ds_tmp.GetItemString(ll_count,"claim_action_c_action_comment"))
	ds_tmp.SetItem(ll_count,"codes",ds_tmp.GetItemString(ll_count,"claim_action_c_action_tx_nr"))
	
	// Set claim recieved % according to the rules below
	If ds_tmp.GetItemNumber(ll_count,"recieved") > 0 Then
		If ld_no_c_trans <= 0 Then
			ds_tmp.SetItem(ll_count,"claim_recieved_pct",0)
		Else
			ds_tmp.SetItem(ll_count,"claim_recieved_pct",(ld_recieved / ld_claim) * 100)
		End if
	Else
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",0)
	End if

	// Set counting used to calculate the results, only for claims with a settlement date
	If IsNull(ds_tmp.GetItemDateTime(ll_count,"settlement_date")) Then
		ds_tmp.SetItem(ll_count,"counting",0)
	Else
		ds_tmp.SetItem(ll_count,"counting",1)
	End if


	// If there is no outstanding demurrage the line most be modified as follows
	If ld_claim < 0 Then
		ds_tmp.SetItem(ll_count,"claim_amount",ll_null)
		ds_tmp.SetItem(ll_count,"outstanding",ll_null)
		ds_tmp.SetItem(ll_count,"nill_outstanding","Nil")
		ds_tmp.SetItem(ll_count,"balance",ll_null)
		ds_tmp.SetItem(ll_count,"no_outstanding_days","N/a")
		ds_tmp.SetItem(ll_count,"counting",0)
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",ll_null)
	End if

	// Get vessel, voyage and charter and delete all but the comment fields for all
	// but the first row for each combination.
	ll_vessel = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage = ds_tmp.GetItemString(ll_count,"claims_voyage_nr")
	ls_chart = ds_tmp.GetItemString(ll_count,"chart_chart_n_1")

	If (ll_vessel = ll_vessel_prv) And (ls_voyage = ls_voyage_prv) Then
		ds_tmp.SetItem(ll_count,"vessels_vessel_name","")
		ds_tmp.SetItem(ll_count,"claims_voyage_nr","")
		ds_tmp.SetItem(ll_count,"vessels_vessel_nr",ll_null)
		ds_tmp.SetItem(ll_count,"broker_name","")
		ds_tmp.SetItem(ll_count,"claims_cp_date",ldt_null)
		ds_tmp.SetItem(ll_count,"claims_forwarding_date",ldt_null)
		ds_tmp.SetItem(ll_count,"settlement_date",ldt_null)
		ds_tmp.SetItem(ll_count,"outstanding_days",ll_null)
		ds_tmp.SetItem(ll_count,"claim_amount",ll_null)
		ds_tmp.SetItem(ll_count,"outstanding",ll_null)
		ds_tmp.SetItem(ll_count,"balance",ll_null)
		ds_tmp.SetItem(ll_count,"claim_recieved_pct",ll_null)
		ds_tmp.SetItem(ll_count,"counting",0)
	Else
		ll_vessel_prv = ll_vessel
		ls_voyage_prv = ls_voyage
	End if

	// Used in headline 2
	ll_upper = UpperBound(ls_chart_names[])
	If ll_upper = 0 Then
		ls_chart_names[1] = ls_chart
	Else
		For ll_i = 1 To ll_upper
			If ls_chart_names[ll_i] = ls_chart Then 
				lb_same = True
			End if
		Next
		If Not lb_same Then 
			ls_chart_names[ll_upper + 1] = ls_chart
		End if
		lb_same = False
	End if

Next
	
// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw. The window must be opened as
// a sheet to enable many open windows at the same time
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	ll_count = UpperBound(istr_sql.chartgrp[])
	If ll_count > 1 Then
		lstr_parm.parameters = "More than one Charterer Group selected - Charterer Demurrage Statistics"
	Else
		SELECT CCS_CHGP_NAME
		INTO :ls_chargp_name
		FROM CCS_CHGP
		WHERE CCS_CHGP_PK = :istr_sql.chartgrp[1];
		COMMIT;
		lstr_parm.parameters = ls_chargp_name + " - Charterer Demurrage Statistics"
	End if

	ll_upper = UpperBound(ls_chart_names[])
	For ll_i = 1 To ll_upper
		lstr_parm.charterer_names += ls_chart_names[ll_i] + ", "
	Next
	lstr_parm.charterer_names = Left(lstr_parm.charterer_names,Len(lstr_parm.charterer_names) - 2)

	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	
	If ii_sheet_count = 0 Then
		OpenSheetWithParm(wx1,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count = 1 Then
		OpenSheetWithParm(wx2,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count = 2 Then
		OpenSheetWithParm(wx3,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count = 3 Then
		OpenSheetWithParm(wx4,lstr_parm,w_tramos_main,0,Original!)
	Elseif ii_sheet_count > 3 Then
		
	End if	
	ii_sheet_count++
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_top_charterer ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
15-08-2000	TAU			Initial version
*************************************************************************************/
Long ll_rows, ll_count, ll_chart_nr, ll_vessel_nr, ll_ret
String ls_voyage_nr
Decimal ld_total_comm, ld_comm
Blob blb_data
int li_rownumber

str_parm lstr_parm

DataStore ds_tmp 
//n_preview_ds ds_tmp
ds_tmp = Create datastore
//ds_tmp = Create n_preview_ds
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_top_charterer"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	Else
		ds_tmp.DataObject = "d_top_charterer_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min, istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.years[])
	End if
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_top_charterer_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	ELse
		ds_tmp.DataObject = "d_top_charterer_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min, istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.years[])
	End if
End if
If ll_ret = -1 Then Return -1

// Loop through ds and get:
ll_rows = ds_tmp.RowCount()

For ll_count = 1 To ll_rows
	ll_vessel_nr = ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr")
	ls_voyage_nr = ds_tmp.GetItemString(ll_count,"voyages_voyage_nr")
	ll_chart_nr = ds_tmp.GetItemNumber(ll_count,"chart_chart_nr")
	
	choose case ls_voyage_nr
		case "TC-OUT"
			// TC Freight amount for vessel/charterer/year combination
			ds_tmp.SetItem(ll_count,"tc_freight",of_tc_freight(ll_vessel_nr, istr_sql.years[1], ll_chart_nr))		
			ds_tmp.SetItem(ll_count,"voyages_voyage_nr", "TC-OUT: " + of_GetVoyageNumbersForTC(ll_vessel_nr, ll_chart_nr, istr_sql.years,0))
		case else
		// Demurrage amount for vessel/voyage/charterer combination
		ds_tmp.SetItem(ll_count,"demurrage",of_demurrage(ll_vessel_nr, ls_voyage_nr, ll_chart_nr))
		
		// Freight amount for vessel/voyage/charterer combination
		ds_tmp.SetItem(ll_count,"freight",of_freight(ll_vessel_nr, ls_voyage_nr, ll_chart_nr))	
	end choose
	
	if ll_count = 1 then
		ll_vessel_nr = 0
		ls_voyage_nr = ""
		ll_chart_nr = 0
	else 
		ll_vessel_nr = ds_tmp.GetItemNumber(ll_count - 1,"vessels_vessel_nr")
		ls_voyage_nr = ds_tmp.GetItemString(ll_count - 1,"voyages_voyage_nr")
		ll_chart_nr = ds_tmp.GetItemNumber(ll_count - 1,"chart_chart_nr")
	end if
	
	if ds_tmp.GetItemNumber(ll_count,"vessels_vessel_nr") = ll_vessel_nr and ds_tmp.getItemString(ll_count, "voyages_voyage_nr") = ls_voyage_nr and ds_tmp.GetItemNumber(ll_count,"chart_chart_nr") = ll_chart_nr then //update grade_group when different gradegroup
		ds_tmp.setItem(ll_count - 1, "cd_grade_group", ds_tmp.getItemString(ll_count - 1, "cd_grade_group") + ", " + ds_tmp.getItemString(ll_count, "cd_grade_group"))	
		ds_tmp.deleterow(ll_count)
		ll_rows --
		ll_count --
	end if
Next

// Fill in computed fields
ds_tmp.setSort("profit_c_pc_name,  ccs_chgp_ccs_chgp_name, chart_chart_nr ")
ds_tmp.sort()
ds_tmp.GroupCalc()

ds_tmp.setSort("profit_c_pc_name, charterer_sum_total ds")
ds_tmp.sort()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

public function integer of_rap_tc_hire ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
12-07-2000	TAU			Create sql for TC Hire
*************************************************************************************/
Long ll_rows, ll_count, ll_ret, ll_vesselnr, ll_c, ll_tmp, ll_rows2
Double ldb_rate, ldb_days, ldb_rate_dm, ldb_ret, ldb_corr, ldb_hours, ldb_exp, ldb_off_time &
			,ldb_corr_fact, ldb_total_exp, ldb_total_offhire
DateTime ldt_cpdate, ldt_start, ldt_end
Blob blb_data

str_parm lstr_parm
DataStore ds_tmp

/* Set endDate to include entered date (add one day) */
istr_sql.year_end = RelativeDate(istr_sql.year_end, 1)

ids_off = Create datastore
ids_off.DataObject = "d_tc_off_hire"
ids_off.SetTransObject(SQLCA)

ds_tmp = Create datastore
If UpperBound(istr_sql.charterer[]) > 0 Then
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_tc_hire"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.year_start,istr_sql.year_end)
	Else
		ds_tmp.DataObject = "d_tc_hire_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.charterer[],istr_sql.year_start,istr_sql.year_end)
	End if
Else
	If UpperBound(istr_sql.vessel[]) > 0 Then
		ds_tmp.DataObject = "d_tc_hire_mm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[],istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.year_start,istr_sql.year_end)
	Else
		ds_tmp.DataObject = "d_tc_hire_mm_vmm"
		ds_tmp.SetTransObject(SQLCA)
		ll_ret = ds_tmp.Retrieve(istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel_min,istr_sql.vessel_max,istr_sql.chartgrp[],istr_sql.chart_min,istr_sql.chart_max,istr_sql.year_start,istr_sql.year_end)
	End if
End if
If ll_ret = -1 Then Return -1

//// Loop through ds and get:
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	if ds_tmp.getItemDatetime(ll_count, "ntc_payment_detail_periode_start") < datetime(istr_sql.year_start) then
		ds_tmp.setItem(ll_count, "ntc_payment_detail_periode_start", datetime(istr_sql.year_start))
	end if
	if ds_tmp.getItemDatetime(ll_count, "ntc_payment_detail_periode_end") > datetime(istr_sql.year_end) then
		ds_tmp.setItem(ll_count, "ntc_payment_detail_periode_end", datetime(istr_sql.year_end))
	end if
Next

// Fill in computed fields
ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp
Destroy ids_off

return 1

end function

public function decimal of_tc_freight (long al_vessel, string as_year, long al_charter);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
15-01-2004	TAU			
*************************************************************************************/
Long ll_ret
DateTime ldt_periodstart, ldt_periodend
decimal ld_tcfreight

Datastore lds_data

//ldt_periodstart = datetime(date("1 january 20" + as_year))
//ldt_periodend = datetime(date("31 december 20" + as_year))
ldt_periodstart = datetime(date(2000+integer(as_year), 1,1))
ldt_periodend = datetime(date(2000+integer(as_year), 12,31),time(23,59,59))

lds_data = create datastore

lds_data.dataobject = "d_top_charterer_tc_freight"

lds_data.settransobject(SQLCA)
ll_ret = lds_data.Retrieve(al_vessel, al_charter, ldt_periodstart, ldt_periodend)

//f_datastore_spy(lds_data)

if ll_ret < 1 then
	destroy lds_data 
	return 0
else
	ld_tcfreight = lds_data.GetItemDecimal(1,"total_tc_freight")
	destroy lds_data 
	return ld_tcfreight
end if


end function

public function integer of_rap_country_port_visits ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-08-2000	TAU			Create sql for Country Port Visits
*************************************************************************************/
Long ll_ret, ll_rows, ll_count, ll_rows2, ll_row, ll_count2, ll_vessel_nr

String ls_voyage_nr, ls_port_code, ls_gradename
String ls_voyage_nr_prev, ls_chart
Long 	ll_vessel_nr_prev
Decimal ld_quant_by_port, ld_quant_by_voyage
Decimal ld_demurrage, ld_freight,ld_misc_inc
Decimal ld_demurrage_tmp, ld_freight_tmp, ld_misc_inc_tmp, ld_total_expenses_tmp
Decimal ld_gross_inc, ld_total_expenses, ld_net_inc
Blob blb_data

str_parm lstr_parm

DataStore ds_tmp, ds_tmp4, ds_grade, ds_chart
ds_tmp = Create datastore

ds_tmp4 = Create datastore
ds_tmp4.DataObject = "d_bol_country_port_visits"
ds_tmp4.SetTransObject(SQLCA)

ds_grade = Create datastore
ds_grade.DataObject = "d_country_port_visits_gradename"
ds_grade.SetTransObject(SQLCA)

ds_chart= Create datastore
ds_chart.DataObject = "d_charter_country_port_visits"
ds_chart.SetTransObject(SQLCA)


If UpperBound(istr_sql.port[]) > 0 Then
	ds_tmp.DataObject = "d_country_port_visits"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.years[],istr_sql.port[],istr_sql.country[],istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[])
Else	
	ds_tmp.DataObject = "d_country_port_visits_mm"
	ds_tmp.SetTransObject(SQLCA)
// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.years[],istr_sql.port_max,istr_sql.port_min,istr_sql.country[],istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[])
End if

If ll_ret = -1 Then Return -1

ds_tmp.setsort( "vessels_vessel_ref_nr, voyages_voyage_nr")
ds_tmp.sort()

//// Loop through ds and get Demurrage and Freight for each Vessel, Voyage and Port :
ll_rows = ds_tmp.RowCount()
For ll_count = 1 To ll_rows
	ld_demurrage = 0
	ld_freight = 0
	ld_misc_inc=0
	ld_total_expenses=0
	ls_gradename = ""
	
	ll_vessel_nr = ds_tmp.getItemNumber(ll_count, "vessels_vessel_nr")
	ls_voyage_nr = ds_tmp.getItemString(ll_count, "voyages_voyage_nr")
	ls_port_code = ds_tmp.getItemString(ll_count, "ports_port_code")
	
	ld_quant_by_port = ds_tmp.getItemnumber(ll_count, "quantity_by_port")
	ld_quant_by_voyage = ds_tmp.getItemnumber(ll_count, "quantity_by_voyage")
	
	// Get gradename
	ll_ret = ds_grade.Retrieve(ll_vessel_nr, ls_voyage_nr, ls_port_code)
	If ll_ret = -1 Then Return -1
	
	ll_rows2 = ds_grade.RowCount()
	For ll_count2 = 1 To ll_rows2
		if ll_count2 = 1 then
			ls_gradename = ds_grade.getItemString(ll_count2, "grade_name")
		else
			ls_gradename += ", "+ds_grade.getItemString(ll_count2, "grade_name")
		end if
	Next
	// END Get grade
	
	//Charterer
	ll_ret = ds_chart.Retrieve(ll_vessel_nr, ls_voyage_nr, ls_port_code)
	If ll_ret = -1 Then Return -1
	ll_rows2 = ds_chart.RowCount()
	For ll_count2 = 1 To ll_rows2
		if ll_count2 = 1 then
			ls_chart = ds_chart.getItemString(ll_count2, "chart_chart_n_1")
		else
			ls_chart += ", "+ds_chart.getItemString(ll_count2, "chart_chart_n_1")
		end if
	Next
	// END Get charterer
	
	
	if ll_vessel_nr <> ll_vessel_nr_prev or ls_voyage_nr <> ls_voyage_nr_prev then
		ld_demurrage_tmp=0
		ld_freight_tmp=0
		ld_misc_inc_tmp=0
		ld_total_expenses_tmp=0
		
		ld_demurrage_tmp = of_demurrage2(ll_vessel_nr,ls_voyage_nr)
		ld_freight_tmp = of_freight2(ll_vessel_nr,ls_voyage_nr)		
		ld_misc_inc_tmp = of_misc_inc(ll_vessel_nr,ls_voyage_nr)	
		ld_total_expenses_tmp = of_totalexpenses(ll_vessel_nr,ls_voyage_nr)
 	 	ll_vessel_nr_prev =ll_vessel_nr
		ls_voyage_nr_prev=ls_voyage_nr
		
	end if
		
	if ld_quant_by_voyage<>0 then
	    ld_demurrage = (ld_demurrage_tmp / ld_quant_by_voyage)*ld_quant_by_port
		
		ld_freight = (ld_freight_tmp/ld_quant_by_voyage)*ld_quant_by_port
		
		ld_misc_inc = (ld_misc_inc_tmp/ld_quant_by_voyage)*ld_quant_by_port
		
		ld_total_expenses = (ld_total_expenses_tmp/ld_quant_by_voyage)*ld_quant_by_port
	//else
	//	messagebox("test", "vessel=" + string(ll_vessel_nr_prev) + "  voyage = " + ls_voyage_nr_prev + " frieght= "  + string(ld_freight_tmp) + "  demurrage=" + string(ld_demurrage_tmp) + "  misc=" + string(ld_misc_inc_tmp) + " total exp=" + string(ld_total_expenses_tmp) )
	end if
	
	ds_tmp.setItem(ll_count, "grade", ls_gradename)	
	ds_tmp.setitem(ll_count, "charterer", ls_chart)
	ds_tmp.setItem(ll_count, "demurrage", ld_demurrage)
	ds_tmp.setItem(ll_count, "freight", ld_freight)	
	ds_tmp.setItem(ll_count, "miscellaneous", ld_misc_inc)	

	ld_gross_inc = ld_demurrage + ld_freight + ld_misc_inc
	ds_tmp.setItem(ll_count, "gross_income", ld_gross_inc)	

	ds_tmp.setItem(ll_count, "total_expenses", ld_total_expenses)	

	ld_net_inc = ld_gross_inc - ld_total_expenses
	ds_tmp.setItem(ll_count, "net_income", ld_net_inc)	

Next

//ds_tmp.setsort( "COUNTRY.COUNTRY_NAME, PORTS.PORT_N, VESSELS.VESSEL_REF_NR, VOYAGES.VOYAGE_NR")
ds_tmp.setsort( "country_country_name, ports_port_n, vessels_vessel_ref_nr, voyages_voyage_nr")
ds_tmp.sort()
ds_tmp.GroupCalc()

// Fill in computed fields
//ds_tmp.GroupCalc()

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp
Destroy ds_tmp4
destroy ds_grade
Destroy ds_chart

return 1

end function

public function integer of_create_report ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
26-06-2000	TAU			
*************************************************************************************/
Long ll_ret

CHOOSE CASE is_report_name
	CASE "Top Charterer"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_top_charterer ()
		End if
	CASE "Top Broker"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_top_broker ()
		End if
	CASE "Vessel Fleettracking","Grade Fleettracking"
		If of_get_sql_data() = 1 Then
			If is_report_name = "Vessel Fleettracking" Then
				ll_ret = of_rap_fleettracking("Vessel")
			Elseif is_report_name = "Grade Fleettracking" Then
				ll_ret = of_rap_fleettracking("Grade")
			End if
		End if
	CASE "Total Freight/Demurrage"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_tdf()
		End if
	CASE "COA Liftings/CVS"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_coa_liftings_cvs()
		End if
	CASE "Liftings"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_listings ()
		End if
	CASE "Commissions"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_comissions ()
		End if
	CASE "Vessel Port Visits"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_vessel_port_visits()
		End if
	CASE "Country Port Visits"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_country_port_visits()
		End if
	CASE "Country Port Visits TC-out"
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_country_port_visits_tcout()
		End if
	CASE "Port Rate/Grade/Temp"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_port_rate_grade_temp()
		End if

	CASE "Vessel Rate/Grade/Temp"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_vessel_rate_grade_temp()
		End if

	CASE "Active/Finished Voyages"
		
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_a_f_voyages()
		End if
		
	CASE "Vessel Disbursement","Port Disbursement"
		
		If of_get_sql_data() = 1 Then
			If is_report_name = "Vessel Disbursement" Then
				ll_ret = of_rap_disbursement("Vessel")
			Else
				ll_ret = of_rap_disbursement("Port")
			End if
		End if
		
	CASE "Employment"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_employment ()
		End if
		
	CASE "Charteres Home Country Support"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_chart_country ()
		End if
		
	CASE "TC Hire"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_tc_hire ()
		End if

	CASE "Idle Days"

		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_idle_days ()
		End if
		
	CASE "Charterer Demurrage Statistics"
		
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_chart_dem_stat ()
		End if
		
	CASE "Broker Demurrage Statistics"
		
		If of_get_sql_data() = 1 Then
			ll_ret = of_rap_broker_dem_stat ()
		End if

	CASE ELSE
		
END CHOOSE

If ll_ret = -1 Then
	MessageBox("Error","It was not possible to generate the "+is_report_name+ " report",StopSign!,OK!)
	Return -1
End if

return 1
end function

public function integer of_adjust_dhm (ref integer ai_day, ref integer ai_hour, ref integer ai_min);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
14-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Integer li_tmp

// If more than 60 minutes convert to hours
If ai_min >= 60 Then
	li_tmp = Int(ai_min/60)
	ai_hour += li_tmp
	ai_min = ai_min - li_tmp * 60
End if

// If more than 24 hours convert to days
If ai_hour >= 24 Then
	li_tmp = Int(ai_hour/24)
	ai_day += li_tmp
	ai_hour = ai_hour - li_tmp * 24
End if

Return 1
end function

public function integer of_window_control (string as_report_name);/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Long ll_ret
String ls_title, ls_help_text

is_report_name = as_report_name

// Create object that holds all help text's.
uo_help luo_help
luo_help = Create uo_help

// Used in all reports
w_reports_gv.uo_profit_center.ib_enabled = True
w_reports_gv.uo_profit_center.TriggerEvent("ue_childmodified")
w_reports_gv.uo_profit_center.TriggerEvent("ue_retrieve")
w_reports_gv.uo_shiptype.ib_enabled = True
w_reports_gv.uo_shiptype.TriggerEvent("ue_childmodified")

ls_title = "Create Standard Report - "

w_reports_gv.sle_start_year.Visible = True
w_reports_gv.sle_start_year.enabled = true 
w_reports_gv.sle_start_year_date.Visible = False
w_reports_gv.sle_start_year_date.enabled = false

CHOOSE CASE as_report_name
		
	CASE "Top Charterer"
		ls_title += "Top Charterer"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "Top Broker"
		ls_title += "Top Broker"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")

	CASE "Vessel Fleettracking","Grade Fleettracking"
		If as_report_name = "Vessel Fleettracking" Then
			ls_title += "Vessel Fleettracking"
		Elseif as_report_name = "Grade Fleettracking" Then
			ls_title += "Grade Fleettracking"
		End if
		
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_grade_grp.ib_enabled = True
		w_reports_gv.uo_grade_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_grade_grp.TriggerEvent("ue_retrieve")

	CASE "Total Freight/Demurrage"
		ls_title += "Total Freight/Demurrage"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "COA Liftings/CVS"
		ls_title += "COA Liftings/CVS"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "Liftings"
		ls_title += "Liftings"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "Commissions"
		ls_title += "Commissions"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_broker.ib_enabled = True
		w_reports_gv.uo_broker.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_broker.TriggerEvent("ue_retrieve")

	CASE "Vessel Port Visits"
		ls_title += "Vessel Port Visits"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")

	CASE "Country Port Visits"
		ls_title += "Country Port Visits"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.ib_enabled = True
		w_reports_gv.uo_country.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_port.ib_enabled = True
		w_reports_gv.uo_port.TriggerEvent("ue_childmodified")

	CASE "Country Port Visits TC-out"
		ls_title += "Country Port Visits TC-out"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.ib_enabled = True
		w_reports_gv.uo_country.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_port.ib_enabled = True
		w_reports_gv.uo_port.TriggerEvent("ue_childmodified")

CASE "Port Rate/Grade/Temp"
		ls_title += "Port Rate/Grade/Temp"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.ib_enabled = True
		w_reports_gv.uo_country.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_port.ib_enabled = True
		w_reports_gv.uo_port.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_purpose.ib_enabled = True
		w_reports_gv.uo_purpose.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_purpose.TriggerEvent("ue_retrieve")

	CASE "Vessel Rate/Grade/Temp"
		ls_title += "Vessel Rate/Grade/Temp"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")

	CASE "Active/Finished Voyages"
		ls_title += "Active/Finished Voyages"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")

	CASE "Vessel Disbursement", "Port Disbursement"
		If as_report_name = "Port Disbursement" Then
			ls_title += "Port Disbursement"
		Elseif as_report_name = "Vessel Disbursement" Then
			ls_title += "Vessel Disbursement"
		End if
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_port.ib_enabled = True
		w_reports_gv.uo_port.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_port.TriggerEvent("ue_retrieve")

	CASE "Employment"
		ls_title += "Employment"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")

	CASE "Charteres Home Country Support"
		// Must change dddw for country as charterer country does not come from the country table.
		w_reports_gv.uo_country.Visible = False
		w_reports_gv.uo_country_charterer.Visible = True
		w_reports_gv.uo_country_charterer.ib_enabled = True
		w_reports_gv.uo_country_charterer.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_country_charterer.TriggerEvent("ue_retrieve")

		ls_title += "Charteres Home Country Support"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "TC Hire"
		ls_title += "TC Hire"
		ls_help_text = luo_help.of_help_text(as_report_name)
		
		w_reports_gv.sle_start_year.Enabled = False
		w_reports_gv.sle_start_year.visible = False
		w_reports_gv.sle_start_year_date.Enabled = True
		w_reports_gv.sle_start_year_date.visible = True
		
		w_reports_gv.st_year_start.Text = "Start date (dd-mm-yy)"
		w_reports_gv.st_year_end.Text = "End date (dd-mm-yy)"
		//w_reports_gv.sle_end_year.Enabled = True
		w_reports_gv.sle_end_year.visible = True
		w_reports_gv.st_year_end.visible = True
		
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")

	CASE "Idle Days"
		ls_title += "Idle Days"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.sle_start_year.Enabled = False
		w_reports_gv.sle_start_year.visible = False
		w_reports_gv.sle_start_year_date.Enabled = True
		w_reports_gv.sle_start_year_date.visible = True 
		
		w_reports_gv.st_year_start.Text = "Start date (dd-mm-yy)"
		w_reports_gv.st_year_end.Text = "End date (dd-mm-yy)"
		//w_reports_gv.sle_end_year.Enabled = True
		w_reports_gv.sle_end_year.visible = True
		w_reports_gv.st_year_end.visible = True
		
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		
	CASE "Charterer Demurrage Statistics"
		ls_title += "Charterer Demurrage Statistics"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")
		
	CASE "Broker Demurrage Statistics"
		ls_title += "Broker Demurrage Statistics"
		ls_help_text = luo_help.of_help_text(as_report_name)
		w_reports_gv.uo_vessel.ib_enabled = True
		w_reports_gv.uo_vessel.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.ib_enabled = True
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_charterer_grp.TriggerEvent("ue_retrieve")
		w_reports_gv.uo_charterer.ib_enabled = True
		w_reports_gv.uo_charterer.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_broker.ib_enabled = True
		w_reports_gv.uo_broker.TriggerEvent("ue_childmodified")
		w_reports_gv.uo_broker.TriggerEvent("ue_retrieve")

	CASE ELSE
		Return 1		
END CHOOSE

Open(w_reports_gv)

w_reports_gv.st_exp.Text = ls_help_text
//w_reports_gv.Title = ls_title
w_reports_gv.Title = "Standard Reports"
w_reports_gv.cb_create_report.Enabled = True
w_reports_gv.cb_reset.Enabled = True

Destroy luo_help

Return 1
end function

public function integer of_rap_country_port_visits_tcout ();/*************************************************************************************
DATE			INITIALS		DESCRIPTION
01-08-2000	TAU			Create sql for Country Port Visits
*************************************************************************************/
Long ll_ret, ll_rows, ll_count, ll_rows2, ll_row, ll_count2, ll_vessel_nr, ll_chart_nr
Blob blb_data
decimal dl_quantity

str_parm lstr_parm

DataStore ds_tmp
ds_tmp = Create datastore

If UpperBound(istr_sql.port[]) > 0 Then
	ds_tmp.DataObject = "d_country_port_visits_tcout"
	ds_tmp.SetTransObject(SQLCA)
	// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.years[],istr_sql.port[],istr_sql.country[],istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[])
	//remove duplicated rows
	of_remove_duplicate(ds_tmp)
Else	
	ds_tmp.DataObject = "d_country_port_visits_mm_tcout"
	ds_tmp.SetTransObject(SQLCA)
// If more than 75 vessels then use this trick to avoid errors
	If istr_sql.ib_vessel Then
		of_change_sql(ds_tmp)
	End if
	ll_ret = ds_tmp.Retrieve(istr_sql.years[],istr_sql.port_max,istr_sql.port_min,istr_sql.country[],istr_sql.pc[],istr_sql.vesselgrp[],istr_sql.vessel[])
	//remove duplicated rows
	of_remove_duplicate(ds_tmp)
End if

If ll_ret = -1 Then Return -1

// Open preview window and insert text string in dw.
ll_ret = ds_tmp.GetFullState(blb_data)
If ll_ret > -1 Then
	lstr_parm.parameters = istr_sql.parameters
	lstr_parm.blb_data = blb_data
	lstr_parm.report_name = is_report_name
	OpenWithParm(w_print_preview, lstr_parm)
Else
	MessageBox("Error","It was not possible to open the print preview window")
	Return -1
End if

// Clean up
Destroy ds_tmp

return 1

end function

private subroutine of_remove_duplicate (datastore ds_tmp);Long li_rownumber, li_i
string ls_vessel_nr, ls_voyage_nr, ls_gradename, ls_gradename_s[]

li_i = 1
li_rownumber =  ds_tmp.rowcount( );

//run through the datawindow and remove duplicate
for li_i = 1 to li_rownumber
	if  ds_tmp.getItemString(li_i, "vessels_vessel_ref_nr") = ls_vessel_nr and  &
		ds_tmp.getItemString(li_i, "voyages_voyage_nr") = ls_voyage_nr  then
			if Pos(ls_gradename, ds_tmp.getItemString(li_i, "bol_grade_name")) = 0 then
				ds_tmp.setItem(li_i - 1, "bol_grade_name", ds_tmp.getItemString(li_i -1 , "bol_grade_name") + ", " + ds_tmp.getItemString(li_i, "bol_grade_name"))	
			end if
			ds_tmp.setItem(li_i - 1, "bol_bol_quantity", ds_tmp.getitemdecimal(li_i -1 , "bol_bol_quantity") + ds_tmp.getitemdecimal(li_i, "bol_bol_quantity"))	
			ds_tmp.deleterow(li_i)
			li_rownumber = li_rownumber - 1
			li_i = li_i - 1
	end if
	//set the comparable parameters
	ls_vessel_nr = ds_tmp.getItemString(li_i, "vessels_vessel_ref_nr")
	ls_voyage_nr = ds_tmp.getItemString(li_i, "voyages_voyage_nr")
	ls_gradename = ds_tmp.getItemString(li_i, "bol_grade_name")
next






end subroutine

public function decimal of_demurrage2 (long al_vessel, string as_voyage);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
21-10-2009	JMC			
*************************************************************************************/
Double ldc_dem, ld_dem_des_actual, ld_dem_des_wa

SELECT isnull(sum(CLAIMS.CLAIM_AMOUNT_USD),0)  
INTO :ld_dem_des_actual
FROM CLAIMS
WHERE 	(CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CLAIM_TYPE = "DEM" ) ;
commit;

SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :ld_dem_des_wa
FROM CLAIMS,   CLAIM_TRANSACTION  
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
			( (CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CLAIM_TYPE = "DEM" ) AND  
			( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  OR CLAIM_TRANSACTION.C_TRANS_CODE = "W" OR CLAIM_TRANSACTION.C_TRANS_CODE = "C"))  ;
commit;

return (ld_dem_des_actual - ld_dem_des_wa)

end function

public function decimal of_demurrage (long al_vessel, string as_voyage, long al_charter);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
03-07-2000	TAU			
*************************************************************************************/
Double ldc_dem, ld_dem_des_actual, ld_dem_des_wa

SELECT isnull(sum(CLAIMS.CLAIM_AMOUNT_USD),0)  
INTO :ld_dem_des_actual
FROM CLAIMS
WHERE 	(CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CHART_NR = :al_charter ) AND
			( CLAIMS.CLAIM_TYPE = "DEM" ) AND
			( CLAIMS.CLAIM_AMOUNT_USD > 0 );
commit;
//Messagebox("Actual",string(ld_dem_des_actual))
SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :ld_dem_des_wa
FROM CLAIMS,   CLAIM_TRANSACTION  
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
			( (CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CHART_NR = :al_charter ) AND
			( CLAIMS.CLAIM_TYPE = "DEM" ) AND  
			( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  OR CLAIM_TRANSACTION.C_TRANS_CODE = "W" ))  ;
commit;

return (ld_dem_des_actual - ld_dem_des_wa)

end function

public function decimal of_freight2 (long al_vessel, string as_voyage);/*************************************************************************************
DATE			INITIALS		DESCRIPTION Returns the freight amount 
03-07-2000	TAU				=freight claims + miscellaneous freight claims + freight received - (adjustments, write-off and miscellanous address comissions transactions)
29-09-15   CR3778     LHG008  Add Transaction C in Actions/Transactions window for FRT claims.
*************************************************************************************/
Double ld_freight, ld_freight_recieved, ld_adv_freight_recieved, ld_transactions

SELECT isnull(sum(CLAIMS.CLAIM_AMOUNT_USD),0)  
INTO :ld_freight  
FROM CLAIMS, CLAIM_TYPES
WHERE 	(CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE) AND
			(CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND 
			( ( CLAIMS.CLAIM_TYPE = "FRT" ) OR 
				(CLAIM_TYPES.CLAIM_VAS=1 AND
					CLAIM_TYPES.CLAIM_GROSS_FRT = 1 AND
					CLAIMS.CLAIM_TYPE not in  ("FRT","DEM") ))  ;

SELECT isnull(sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED),0)  
INTO :ld_freight_recieved
FROM FREIGHT_RECEIVED  
WHERE ( FREIGHT_RECEIVED.VESSEL_NR = :al_vessel ) AND  
		( FREIGHT_RECEIVED.VOYAGE_NR = :as_voyage )  AND
		( FREIGHT_RECEIVED.TRANS_CODE <> 'C');

SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :ld_transactions
FROM CLAIMS,   CLAIM_TRANSACTION,  CLAIM_TYPES    
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and
			(CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE)  and
		     (CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
	      ( (  CLAIMS.CLAIM_TYPE = "FRT"  AND   ( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  OR CLAIM_TRANSACTION.C_TRANS_CODE = "W" ) )
			OR
			(   CLAIMS.CLAIM_TYPE not in ("FRT", "DEM")  AND  
			      ( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  OR CLAIM_TRANSACTION.C_TRANS_CODE = "W" OR CLAIM_TRANSACTION.C_TRANS_CODE = "C" ) 
				 and CLAIM_TYPES.CLAIM_VAS=1 AND CLAIM_TYPES.CLAIM_GROSS_FRT = 1) );

Return(ld_freight + ld_freight_recieved  - ld_transactions )


end function

public function decimal of_freight (long al_vessel, string as_voyage, long al_charter);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
03-07-2000	TAU			
29-09-15   CR3778     LHG008  Add Transaction C in Actions/Transactions window for FRT claims.
*************************************************************************************/
Double ld_freight, ld_freight_recieved, ld_adv_freight_recieved, ld_transactions

SELECT isnull(sum(CLAIMS.CLAIM_AMOUNT_USD),0)  
INTO :ld_freight  
FROM CLAIMS
WHERE 	(CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CHART_NR = :al_charter ) AND
			( CLAIMS.CLAIM_TYPE = "FRT" )  ;

SELECT isnull(sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED),0)  
INTO :ld_freight_recieved
FROM FREIGHT_RECEIVED  
WHERE ( FREIGHT_RECEIVED.VESSEL_NR = :al_vessel ) AND  
		( FREIGHT_RECEIVED.VOYAGE_NR = :as_voyage ) AND 
		( FREIGHT_RECEIVED.CHART_NR = :al_charter ) AND
		( FREIGHT_RECEIVED.TRANS_CODE <> 'C');

SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :ld_transactions
FROM CLAIMS,   CLAIM_TRANSACTION  
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
			( (CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CHART_NR = :al_charter ) AND
			( CLAIMS.CLAIM_TYPE = "FRT" ) AND  
			( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  AND CLAIM_TRANSACTION.C_TRANS_CODE = "W" ))  ;

//Return(ld_freight + ld_freight_recieved + ld_adv_freight_recieved - ld_transactions)
Return(ld_freight + ld_freight_recieved - ld_transactions)


end function

public function decimal of_misc_inc (long al_vessel, string as_voyage);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
15-10-2009	JMC			
*************************************************************************************/
Double ld_misc, ld_transactions,ld_profit

SELECT isnull(sum(CLAIMS.CLAIM_AMOUNT_USD),0)  
INTO :ld_misc  
FROM CLAIMS, CLAIM_TYPES
WHERE 	(CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE) AND
			CLAIM_TYPES.CLAIM_VAS=1 AND
			CLAIM_TYPES.CLAIM_GROSS_FRT = 0 AND
			(CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CLAIM_TYPE not in  ("FRT","DEM") )  ;
commit;

SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :ld_transactions
FROM CLAIMS,   CLAIM_TRANSACTION, CLAIM_TYPES  
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
			(CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE) AND
			CLAIM_TYPES.CLAIM_VAS=1 AND
			CLAIM_TYPES.CLAIM_GROSS_FRT = 0 AND
			( (CLAIMS.VESSEL_NR = :al_vessel ) AND  
			( CLAIMS.VOYAGE_NR = :as_voyage ) AND  
			( CLAIMS.CLAIM_TYPE not in ("FRT", "DEM") ) AND  
			( CLAIM_TRANSACTION.C_TRANS_CODE = "A"  OR CLAIM_TRANSACTION.C_TRANS_CODE = "W" OR CLAIM_TRANSACTION.C_TRANS_CODE = "C" ))  ;
commit;

SELECT  ISNULL(VOYAGES.BUNKER_POSTED_LOSSPROFIT,0)
INTO :ld_profit
FROM VOYAGES 
WHERE VOYAGES.VESSEL_NR= :al_vessel AND
			VOYAGES.VOYAGE_NR= :as_voyage AND
			VOYAGES.BUNKER_POSTED_LOSSPROFIT>0;
COMMIT;


Return(ld_misc - ld_transactions + ld_profit)
end function

public function decimal of_totalexpenses (long al_vessel, string as_voyage);/*************************************************************************************
DATE			INITIALS		DESCRIPTION
21-10-2009	JMC			
*************************************************************************************/

Double ld_total_expenses, ld_port_misc_expenses, ld_bunker, ld_comm,ld_bunker_lost


	//port and miscellaneous expenses (disbursements)
	SELECT isnull(SUM(DISB_EXPENSES.EXP_AMOUNT_USD) ,0)
	INTO	:ld_port_misc_expenses
	FROM DISB_EXPENSES, VOUCHERS
	WHERE DISB_EXPENSES.VOUCHER_NR = VOUCHERS.VOUCHER_NR AND
		VOUCHERS.VAS_REPORT=1 AND
		DISB_EXPENSES.VESSEL_NR=:al_vessel AND
		DISB_EXPENSES.VOYAGE_NR=:as_voyage ;
							
	//Bunker expenses (voyage level)
	SELECT isnull(sum(VOYAGES.BUNKER_POSTED_HFO + VOYAGES.BUNKER_POSTED_DO + VOYAGES.BUNKER_POSTED_GO + VOYAGES.BUNKER_POSTED_LSHFO ),0)  
	INTO :ld_bunker  
	FROM VOYAGES	
	WHERE 	(VOYAGES.VESSEL_NR = :al_vessel ) AND  
			( VOYAGES.VOYAGE_NR = :as_voyage ) AND  
			( VOYAGES.VOYAGE_TYPE<>2);
	commit;

	//Broker Commission (commissions)
	SELECT isnull(sum(COMMISSIONS.COMM_AMOUNT),0)  
	INTO :ld_comm
	FROM COMMISSIONS
	WHERE 	(COMMISSIONS.VESSEL_NR = :al_vessel ) AND  
			( COMMISSIONS.VOYAGE_NR = :as_voyage )  ;
	commit;

	//lost
	SELECT ISNULL(VOYAGES.BUNKER_POSTED_LOSSPROFIT,0)
	INTO :ld_bunker_lost
	FROM VOYAGES 
	WHERE VOYAGES.VESSEL_NR= :al_vessel AND
				VOYAGES.VOYAGE_NR= :as_voyage AND
				VOYAGES.BUNKER_POSTED_LOSSPROFIT<0;
	COMMIT;

	ld_total_expenses = ld_port_misc_expenses + ld_bunker + ld_comm +ld_bunker_lost


return ld_total_expenses
end function

private function string of_getvoyagenumbersfortc (integer ai_vesselnr, integer ai_chartnr, string as_year[], integer ai_bybroker);
Datastore lds_Voy
Integer li_Rows, li_Count
String ls_Voy = ""

lds_Voy = Create Datastore
lds_Voy.DataObject = "d_sq_tb_tcout_voyagenumbers"
lds_Voy.SetTransObject(SQLCA)
li_Rows = lds_Voy.Retrieve(as_Year, ai_ChartNr, ai_VesselNr, ai_ByBroker)

Commit;

If li_Rows < 0 then Return "Err"
If li_Rows = 0 then Return "NA"

For li_Count = 1 to li_Rows
	ls_Voy += lds_Voy.GetItemString(li_Count, "tcout_voyage_nr") + ";"
Next

Return ls_Voy
end function

public subroutine documentation ();/***********************************************************************************
documentation
<DESC>		Description	</DESC>
<RETURN>	(None):
	<LI> c#return.Success: 1, ok
	<LI> c#return.Failure: -1, failed	</RETURN>
<ACCESS> public </ACCESS>
<ARGS>
</ARGS>
<USAGE>	How to use this function	</USAGE>
<HISTORY>
	Date 	 		CR-Ref		Author	Comments
	17/09/2014	CR3781		CCY018	The window title match with the text of a menu item.
	23/11/2014 	CR3420 	 	AZX004	Modify to avoid array bound fault and some desc\no report etc.
	29/09/2015  CR3778      LHG008   Add Transaction C in Actions/Transactions window for FRT claims.
</HISTORY>
***********************************************************************************/

end subroutine

on uo_visual_control.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_visual_control.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

