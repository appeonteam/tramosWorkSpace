$PBExportHeader$u_vas_file.sru
$PBExportComments$Uo used for VAS file data.
forward
global type u_vas_file from u_vas_key_data
end type
end forward

global type u_vas_file from u_vas_key_data
end type
global u_vas_file u_vas_file

type variables
s_vessel_voyage_list istr_vv_list
end variables

forward prototypes
public function decimal of_get_total_days ()
public function integer of_get_frt_charter (ref long al_charter, ref decimal ad_exrate)
public function integer of_get_days_info (ref datetime adt_voyage_start, ref datetime adt_voyage_end)
public function decimal of_getmisc_exp ()
public function integer of_start_file_act (ref s_vas_file astr_file, integer ai_first_voyage)
public function integer of_start_file (ref s_vas_file astr_file, integer ai_first_voyage)
public function integer of_start_file_control (ref s_vas_file astr_file, integer ai_first_voyage)
public function decimal of_get_profit_margin (integer ai_type)
end prototypes

public function decimal of_get_total_days ();Decimal ld_total_days

IF istr_vv_list.voyage_type <> 2 THEN
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
elseif istr_vv_list.voyage_type = 2 then
	ld_total_days = of_getother_days(4,TRUE) + of_getoff_service_days(4,TRUE)
end if

Return ld_total_days
end function

public function integer of_get_frt_charter (ref long al_charter, ref decimal ad_exrate);Datastore lds_max_frt, lds_max_calc_frt
Long ll_rows, ll_charter_nr, ll_contractID
Datetime ldt_cp_date
u_vas_tc_out luo_vas_tc_out

IF istr_vv_list.voyage_type = 2 THEN
	ll_contractID = of_get_tccontract()
	SELECT NTC_TC_CONTRACT.CHART_NR  
   INTO :ll_charter_nr  
   FROM NTC_TC_CONTRACT  
   WHERE NTC_TC_CONTRACT.CONTRACT_ID = :ll_contractID ;
	IF SQLCA.SQLCode = 0 THEN 
		al_charter = ll_charter_nr
	ELSE
		al_charter = 0
	END IF
	Commit;
	Return 1
END IF

IF of_exists_all_frt() THEN
	lds_max_frt = CREATE Datastore
	lds_max_frt.Dataobject = "d_max_frt"
	lds_max_frt.SetTransObject(SQLCA)
	ll_rows = lds_max_frt.Retrieve(istr_vv_list.vessel_nr, istr_vv_list.voyage_nr)
	
	IF Not(ll_rows > 0) THEN
		Destroy lds_max_frt ;
		al_charter = 0
		ad_exrate = 0
		Return 1
	END IF
	
	al_charter = lds_max_frt.GetItemNumber(1,"claims_chart_nr")
	Destroy lds_max_frt ;
ELSE
	lds_max_calc_frt = CREATE Datastore
	lds_max_calc_frt.Dataobject = "d_max_calc_frt"
	lds_max_calc_frt.SetTransObject(SQLCA)
	ll_rows = lds_max_calc_frt.Retrieve(istr_vv_list.calc_id)
	
	IF Not(ll_rows > 0) THEN
		Destroy lds_max_calc_frt ;
		al_charter = 0
		ad_exrate = 0
		Return 1
	END IF
	
	al_charter = lds_max_calc_frt.GetItemNumber(1,"cal_cerp_chart_nr")
	Destroy lds_max_calc_frt ;
END IF

IF al_charter > 0 THEN
	SELECT MAX(VOYAGE_EX_RATE)
	INTO :ad_exrate  
	FROM DISBURSEMENTS  
	WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr) AND  
         ( VOYAGE_NR = :istr_vv_list.voyage_nr )  ;
	commit;
Else
	al_charter = 0
	ad_exrate = 0
End if

Return 1
end function

public function integer of_get_days_info (ref datetime adt_voyage_start, ref datetime adt_voyage_end);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uf_get_f_days_info
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    :Bettina Olsen
   
 Date       : 16-06-97

 Description : this function finds the information about startdate, enddate and total 
 					days for a given voyage to the Vas file.

 Arguments : vessel number and voyage number

 Returns   : total days

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-06-97		5.00			BO		First Release
16-04-01		5.10			TAU	Modified to set consequtive start and end days.
************************************************************************************/
/*Declare local variables */
long ll_days
datetime ldt_voyage_end, ldt_max_poc_arr_date, ldt_max_poc_dept_date  
int li_voyage_type, li_finished
Time lt_hours
string ls_voyage
decimal ld_total_days

li_voyage_type = istr_vv_list.voyage_type

/* Finds start date */
adt_voyage_start = of_getcommenced_date()
//ad_voyage_start=date(ldt_voyage_start)

choose case li_voyage_type
	case 1,3,4,5,6
		SELECT max(POC.PORT_ARR_DT), max(POC.PORT_DEPT_DT)  
		INTO :ldt_max_poc_arr_date, :ldt_max_poc_dept_date  
		FROM POC  
		WHERE 	( POC.VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
				( POC.VOYAGE_NR = :istr_vv_list.voyage_nr )   ;
 		commit;
		if ldt_max_poc_arr_date > ldt_max_poc_dept_date   then
			ldt_voyage_end = ldt_max_poc_arr_date
		else
			ldt_voyage_end = ldt_max_poc_dept_date
		end if
	case 2
		ldt_voyage_end = of_tc_get_tc_end_date("actual")
end choose

/* End date */
adt_voyage_end = ldt_voyage_end
//ad_voyage_end = Date(ldt_voyage_end)

/* Find out how many days voyage took */
ll_days =daysafter(date(adt_voyage_start),date(adt_voyage_end))

// Inserted by Faisal 180602, for the last voyage we need a date

  SELECT MAX(VOYAGES.VOYAGE_NR)
    INTO :ls_voyage
    FROM VOYAGES  
   WHERE VOYAGES.VESSEL_NR = :istr_vv_list.vessel_nr and 
			Substring(VOYAGES.VOYAGE_NR,1,5) = Substring(:istr_vv_list.voyage_nr,1,5) and
			(VOYAGES.CAL_CALC_ID > 1 OR VOYAGES.VOYAGE_TYPE = 2) ;
	Commit;	
		
  SELECT VOYAGES.VOYAGE_FINISHED
    INTO :li_finished  
    FROM VOYAGES  
   WHERE ( VOYAGES.VESSEL_NR = :istr_vv_list.vessel_nr ) and 
				(VOYAGES.VOYAGE_NR = :ls_voyage);				
	Commit;
	
	if (li_finished <> 1 and li_voyage_type <> 2) then
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
		adt_voyage_end = datetime(RelativeDate(Date(adt_voyage_start),ld_total_days))
// Removed 22 may 2007 - requested by management reporting 		
//	elseif li_finished <> 1 and li_voyage_type = 2 then
//		ld_total_days = of_getother_days(4,TRUE) + of_getoff_service_days(4,TRUE)
//		adt_voyage_end = datetime(RelativeDate(Date(adt_voyage_start),ld_total_days))
	end if
	

/* Return string */
return ll_days
end function

public function decimal of_getmisc_exp ();
Double ld_exp

ld_exp = of_getmisc_expenses(4,TRUE)
ld_exp += of_getport_expenses(4,TRUE)
ld_exp += of_getbroker_commission(4,TRUE)

Return ld_exp
end function

public function integer of_start_file_act (ref s_vas_file astr_file, integer ai_first_voyage);Long ll_days, ll_charter
Decimal {2} ld_total_days, ld_exrate
Decimal {4} ld_off_days
Decimal {0} ld_profit, ld_bunker_exp, ld_misc_exp, ld_income, ld_commission, ld_portexp, ld_gross_income, ld_freight, ld_demurrage, ld_tchire
Datetime ldt_start_date, ldt_end_date
Date ld_start_date, ld_end_date

of_get_vessel_array(istr_vv_list)

// Get data for vas file
ll_days = of_get_days_info(ldt_start_date,ldt_end_date)
ld_total_days = of_get_total_days()
ld_off_days = of_getoff_service_days(5,TRUE)
of_get_frt_charter(ll_charter, ld_exrate)

ld_bunker_exp = Round(of_getbunker_expenses(5,TRUE),0)

ld_misc_exp = Round(of_getmisc_expenses(5,TRUE),0)
ld_commission = round(of_getbroker_commission(5,true),0)
ld_portexp = round(of_getport_expenses(5,true),0)
IF istr_vv_list.voyage_type = 2 THEN
	ld_misc_exp = of_getmisc_expenses(5,TRUE)
	ld_exrate = 0
	ld_portexp = 0
END IF	
// Added by Faisal 130602
// (Demurrage is 0 if tc out)
ld_gross_income = round(of_getgross_freight(5, true),0) + round(of_getdemurrage(5, true),0)

// ld_income used as misc_expenses in vas file 3

IF istr_vv_list.voyage_type = 2 THEN
	ld_income = round(of_getmisc_expenses(5,true),0)
//	ld_income = ld_gross_income - of_get_tc_out_off_service_est_act()
ELSE
	ld_income = round(of_getmisc_expenses(5,true),0)
END IF

IF istr_vv_list.voyage_type = 2 THEN
	ld_profit = ld_gross_income - ld_commission - ld_misc_exp - ld_bunker_exp
ELSE
	ld_profit = Round(of_get_profit_margin(5),0)
END IF

/******************************************************/
IF istr_vv_list.voyage_type = 2 THEN
	ld_freight = 0
	ld_demurrage = 0
	ld_tchire = round(of_getgross_freight(5, true),0)+round(of_getdemurrage(5, true),0) 
ELSE
	ld_freight = round(of_getgross_freight(5, true),0)
	ld_demurrage = round(of_getdemurrage(5, true),0) 
	ld_tchire = 0
END IF


/*****************************************************************************************************
New date rules:
		-The number of days calculated from the difference between the end date and the commenced date
		 for a vessel on single voyages for a whole year must equal the number of days in that year.
		-Off days will not be be subtracted from the end date, but will be implicitly included in the 
		 interval shown.
		-A day will not be added to the the start date for the first voyage.
      -If the time in the commenced date for a voyage is equal to or larger than 00:00 and smaller 
		 than 12:00, the commenced date will be set to the date of the same day. If the time in the
		 commenced date for a voyage is equal to or larger than 12:00 and smaller than 00:00 (24:00),
		 the commenced date will be set to the date of the next day.
		-If the time in the end date for a voyage is equal to or larger than 00:00 and smaller than 
		 12:00, the end date will be set to the date of the previous day. If the time in the end date
		 for a voyage is equal to or larger than 12:00 and smaller than 00:00 (24:00), the end date 
		 will be set to the date of the same day.
*****************************************************************************************************/

// Commenced date
If time(ldt_start_date) < time("12:00:00") Then
	ld_start_date = Date(ldt_start_date)
Else
	ld_start_date = RelativeDate(Date(ldt_start_date),1)
End if

// End date
If time(ldt_end_date) < time("12:00:00") AND ld_start_date <= RelativeDate(date(ldt_end_date),-1) Then
	ld_end_date = RelativeDate(date(ldt_end_date),-1)
Else
	ld_end_date = Date(ldt_end_date)
End if
//Messagebox("","Commenced date: "+string(ldt_start_date)+"~r~n"+" End date: "+string(ldt_end_date)&
//				+"~r~n"+"Commenced date: "+string(ld_start_date)+"~r~n"+" End date: "+string(ld_end_date))

// Insert vas file data in reference variable structure
astr_file.startdate = ld_start_date
astr_file.enddate = ld_end_date
astr_file.offdays += ld_off_days
astr_file.charter = ll_charter
astr_file.result += ld_profit
astr_file.bunkerexp += ld_bunker_exp
astr_file.miscexp += ld_misc_exp
astr_file.exrate = ld_exrate
astr_file.income = ld_income
astr_file.commission = ld_commission
astr_file.portexp = ld_portexp
astr_file.grossincome = ld_gross_income
astr_file.totaldays = ld_total_days
astr_file.demurrage = ld_demurrage
astr_file.freight = ld_freight
astr_file.tchire = ld_tchire


Return 1
end function

public function integer of_start_file (ref s_vas_file astr_file, integer ai_first_voyage);Long ll_days, ll_charter
Decimal {2} ld_total_days, ld_exrate
Decimal {4} ld_off_days
Decimal {0} ld_profit, ld_bunker_exp, ld_misc_exp, ld_income, ld_commission, ld_portexp, ld_gross_income, ld_freight, ld_demurrage, ld_tchire
Datetime ldt_start_date, ldt_end_date
Date ld_start_date, ld_end_date

of_get_vessel_array(istr_vv_list)

// Get data for vas file
ll_days = of_get_days_info(ldt_start_date,ldt_end_date)
ld_total_days = of_get_total_days()
ld_off_days = of_getoff_service_days(4,TRUE)
of_get_frt_charter(ll_charter, ld_exrate)

ld_bunker_exp = Round(of_getbunker_expenses(4,TRUE),0)

ld_misc_exp = Round(of_getmisc_exp(),0)

ld_commission = round(of_getbroker_commission(4,true),0)
ld_portexp = round(of_getport_expenses(4,true),0)
IF istr_vv_list.voyage_type = 2 THEN
	ld_misc_exp = of_getmisc_expenses(4,TRUE)
	ld_exrate = 0
	ld_portexp = 0
END IF	
// Added by Faisal 130602
// (Demurrage is 0 if tc out)
ld_gross_income = round(of_getgross_freight(4, true),0) + round(of_getdemurrage(4, true),0)

// ld_income used as misc_expenses in vas_file2

IF istr_vv_list.voyage_type = 2 THEN
	ld_income = round(of_getmisc_expenses(4,true),0)
//	ld_income = ld_gross_income - of_get_tc_out_off_service_est_act()
ELSE
	ld_income = round(of_getmisc_expenses(4,true),0)
END IF

IF istr_vv_list.voyage_type = 2 THEN
	ld_profit = ld_gross_income - ld_commission - ld_misc_exp - ld_bunker_exp
ELSE
	ld_profit = Round(of_get_profit_margin(4),0)
END IF

/******************************************************/
IF istr_vv_list.voyage_type = 2 THEN
	ld_freight = 0
	ld_demurrage = 0
	ld_tchire = round(of_getgross_freight(4, true),0)+round(of_getdemurrage(4, true),0) 
ELSE
	ld_freight = round(of_getgross_freight(4, true),0)
	ld_demurrage = round(of_getdemurrage(4, true),0) 
	ld_tchire = 0
END IF


/*****************************************************************************************************
New date rules:
		-The number of days calculated from the difference between the end date and the commenced date
		 for a vessel on single voyages for a whole year must equal the number of days in that year.
		-Off days will not be be subtracted from the end date, but will be implicitly included in the 
		 interval shown.
		-A day will not be added to the the start date for the first voyage.
      -If the time in the commenced date for a voyage is equal to or larger than 00:00 and smaller 
		 than 12:00, the commenced date will be set to the date of the same day. If the time in the
		 commenced date for a voyage is equal to or larger than 12:00 and smaller than 00:00 (24:00),
		 the commenced date will be set to the date of the next day.
		-If the time in the end date for a voyage is equal to or larger than 00:00 and smaller than 
		 12:00, the end date will be set to the date of the previous day. If the time in the end date
		 for a voyage is equal to or larger than 12:00 and smaller than 00:00 (24:00), the end date 
		 will be set to the date of the same day.
*****************************************************************************************************/

// Commenced date
If time(ldt_start_date) < time("12:00:00") Then
	ld_start_date = Date(ldt_start_date)
Else
	ld_start_date = RelativeDate(Date(ldt_start_date),1)
End if

//messagebox("", "Enddate time="+string(time(ldt_end_date))+"~n~r" +&
//					"< 12:00:00="+string(time("12:00:00"))+"~n~r" +&
//					"Startdate="+string(ld_start_date)+"~n~r" +&
//					"Relative>="+string(RelativeDate(date(ldt_end_date),-1)))

// End date
If time(ldt_end_date) < time("12:00:00") AND ld_start_date <= RelativeDate(date(ldt_end_date),-1) Then
	ld_end_date = RelativeDate(date(ldt_end_date),-1)
Else
	ld_end_date = Date(ldt_end_date)
End if
//Messagebox("","Commenced date: "+string(ldt_start_date)+"~r~n"+" End date: "+string(ldt_end_date)&
//				+"~r~n"+"Commenced date: "+string(ld_start_date)+"~r~n"+" End date: "+string(ld_end_date))

// Insert vas file data in reference variable structure
astr_file.startdate = ld_start_date
astr_file.enddate = ld_end_date
astr_file.offdays += ld_off_days
astr_file.charter = ll_charter
astr_file.result += ld_profit
astr_file.bunkerexp += ld_bunker_exp
astr_file.miscexp += ld_misc_exp
astr_file.exrate = ld_exrate
astr_file.income = ld_income
astr_file.commission = ld_commission
astr_file.portexp = ld_portexp
astr_file.grossincome = ld_gross_income
astr_file.totaldays = ld_total_days
astr_file.demurrage = ld_demurrage
astr_file.freight = ld_freight
astr_file.tchire = ld_tchire


Return 1
end function

public function integer of_start_file_control (ref s_vas_file astr_file, integer ai_first_voyage);Decimal {0} ld_bunker_exp, ld_misc_exp, ld_commission, ld_portexp, ld_freight, ld_demurrage

/* Freight */
if round(of_getgross_freight(4, true),0) <> round(of_getgross_freight(5,true),0) then
	ld_freight = round(of_getgross_freight(4,true),0) - round(of_getgross_freight(5,true),0)
else
	ld_freight = 0
end if

/* Demurrage */
if round(of_getdemurrage(4, true),0) <> round(of_getdemurrage(5,true),0) then
	ld_demurrage = round(of_getdemurrage(4,true),0) - round(of_getdemurrage(5,true),0)
else
	ld_demurrage = 0
end if

/* Commission */
if round(of_getbroker_commission(4,true),0) <> round(of_getbroker_commission(5,true),0) then
	ld_commission = round(of_getbroker_commission(4,true),0) - round(of_getbroker_commission(5,true),0)
else
	ld_commission = 0
end if

/* Port Expenses */
if round(of_getport_expenses(4,true),0) <> round(of_getport_expenses(5,true),0) then
	ld_portexp = round(of_getport_expenses(4,true),0) - round(of_getport_expenses(5,true),0)
else
	ld_portexp = 0
end if

/* Bunker Expenses */
if round(of_getbunker_expenses(4,true),0) <> round(of_getbunker_expenses(5,true),0) then
	ld_bunker_exp = Round(of_getbunker_expenses(4,TRUE),0) - round(of_getbunker_expenses(5,true),0)
else
	ld_bunker_exp = 0
end if

/* Misc. Expenses */
if round(of_getmisc_expenses(4,true),0) <> round(of_getmisc_expenses(5,true),0) then
	ld_misc_exp = of_getmisc_expenses(4,TRUE) - round(of_getmisc_expenses(5,true),0)
else
	ld_misc_exp = 0
end if

astr_file.freight 	= ld_freight
astr_file.demurrage 	= ld_demurrage
astr_file.commission = ld_commission
astr_file.portexp 	= ld_portexp
astr_file.bunkerexp 	= ld_bunker_exp
astr_file.miscexp 	= ld_misc_exp

Return 1
end function

public function decimal of_get_profit_margin (integer ai_type);//Decimal {2} ld_result_before_drc
Double ld_result_before_drc

ld_result_before_drc = of_getgross_freight(ai_type,TRUE)

ld_result_before_drc += of_getdemurrage(ai_type,TRUE)

ld_result_before_drc -= of_getbroker_commission(ai_type,TRUE)

ld_result_before_drc -= of_getport_expenses(ai_type,TRUE)

ld_result_before_drc -= of_getbunker_expenses(ai_type,TRUE)

ld_result_before_drc -= of_getmisc_expenses(ai_type,TRUE)

Return ld_result_before_drc

end function

on u_vas_file.create
call super::create
end on

on u_vas_file.destroy
call super::destroy
end on

