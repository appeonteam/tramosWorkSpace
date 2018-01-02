$PBExportHeader$u_check_functions.sru
$PBExportComments$User object containing all the base functions for the check module.
forward
global type u_check_functions from nonvisualobject
end type
end forward

global type u_check_functions from nonvisualobject
end type
global u_check_functions u_check_functions

forward prototypes
public function integer uf_check_tc_out_voyage (integer ai_vessel_nr, string as_voyage_nr)
public function boolean uf_does_vessel_have_tc_owner (integer ai_vessel_nr)
public function string uf_check_finished_voyages_commission (ref integer ai_vessel_nr, ref string as_voyage_nr)
public function boolean uf_check_purpose_delivery (ref integer ai_vessel_nr, ref string as_voyage_nr)
public function boolean uf_check_misc_income (integer ai_vessel_nr, string as_voyage_nr)
public subroutine uf_get_tcvessels (ref st_voyages astr_voyages)
public function string uf_check_dem_claims (integer ai_vessel_nr, string as_voyage_nr)
public function integer uf_check_purpose_offservice (integer ai_vessel_nr, string as_voyage_nr)
public function integer uf_check_purpose_idle (integer ai_vessel_nr, string as_voyage_nr)
public function integer uf_is_poc_in_tcperiod (integer ai_vessel_nr, datetime adt_arrival, datetime adt_departure)
public function integer uf_is_tcvoyage (integer ai_vessel_nr, string as_voyage_nr)
public function string uf_check_new_rate (integer ai_vessel_nr, datetime adt_start, datetime adt_end)
public function integer uf_check_finished_voyages_claims (integer ai_vessel_nr, string as_voyage_nr)
public function decimal uf_calculate_calc_heating (long al_carg_id)
public function string uf_check_tcperiods (integer ai_vessel_nr)
public function long uf_calculate_time_used (long al_rate, long al_units, long al_term)
public function string uf_check_tc_currency (integer ai_vessel_nr)
public subroutine uf_get_all_finished_voyages (ref st_voyages astr_voyages, string as_year, integer ai_pcnr)
public subroutine uf_get_all_tc_voyages (ref st_voyages astr_voyages, string as_year, integer ia_pcnr)
public subroutine uf_get_all_voyages (ref st_voyages astr_voyages, string as_year, integer ai_pcnr)
public function decimal uf_calculate_calc_deviation (long al_carg_id)
public function string uf_check_estimated_claims (integer ai_vessel_nr, string as_voyage_nr)
public function integer uf_check_bunker (integer ai_vessel, datetime adt_departure)
public function integer uf_check_poc_arr_dates (long al_vessel, long al_year, ref string as_message)
public function integer uf_check_poc_arr_dates (long al_vessel, datetime adt_startdate, datetime adt_enddate, ref string as_message)
public function boolean uf_is_first_poc (integer ai_vessel_nr, datetime adt_arrival, string as_voyage)
public function boolean uf_check_bunker (integer ai_vessel_nr, string as_voyage_nr, ref string as_message)
public function integer of_check_portbunker (ref mt_u_datawindow adw_poc, ref string as_setcol, ref string as_message)
public function integer of_check_portbunker (ref mt_u_datawindow adw_poc, string as_bunker_type, decimal ad_arr_bunker, decimal ad_dept_bunker, string as_pre_voyage, string as_pre_port, string as_next_voyage, string as_next_port, ref string as_setcol, ref string as_message)
public function integer of_check_idledays (long al_vesselnr, string as_voyagenr)
public function integer of_check_idledays (long al_vesselnr, string as_voyagenr, uo_datawindow adw_idledays, integer ai_flag)
public function integer of_check_idledaysoverlap (long al_vesselnr, uo_datawindow adw_idledays)
public function integer of_check_idledaysperiod (long al_vesselnr, string as_voyagenr, uo_datawindow adw_idledays, integer ai_flag)
public function string of_get_portname (string as_portcode)
end prototypes

public function integer uf_check_tc_out_voyage (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_tc_out_voyage
 
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 06-08-97

 Description 	:  A voyage marked as a tc-out voyage will be checked as follows:
						- is the ship a tc-out vessel
						- if it is a tc-out vessel then check if it is time charted in the period where 
						the voyage is.
			

 Arguments 		:	vessel nr
						voyage nr
						
 Returns   		: returns an integer		-1	The vessel is not a tc-out vessel.
							 						0	It is a tc-out vessel but not in that period.
							 						1	It is a tc-out vessel in that period.
													99	An error occured while retrieving.

 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-08-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction 	sqlfrt
integer 			li_count
datetime 		ldt_arrival_date, ldt_departure_date
long				ll_contractID

/* Create transactionobject */
uo_global.defaulttransactionobject(sqlfrt)
connect using sqlfrt;

/* Check if the given vessel is a tcout vessel */
/* Check if the vessel i located in the tchire-table and if it is a tc-out vessel */
//SELECT distinct(TCHIRES.VESSEL_NR)
//INTO :li_tchire
//FROM TCHIRES
//WHERE TCHIRES.VESSEL_NR = :ai_vessel_nr and TCHIRES.TCHIRE_IN = 0 
//using sqlfrt;
SELECT count(*)
	INTO :ll_contractID
	FROM NTC_TC_CONTRACT
	WHERE VESSEL_NR = :ai_vessel_nr and TC_HIRE_IN = 0 
	using sqlfrt;

COMMIT;

if sqlfrt.sqlcode = 0  then
	/* if it is a tc out skib then check the period, which means that we finds the first port arrival */
	/* date and the last departure date in the POC-table.  */
	SELECT min( POC.PORT_ARR_DT),
			max(POC.PORT_DEPT_DT)
	INTO :ldt_arrival_date, :ldt_departure_date
	FROM POC
	WHERE POC.VESSEL_NR = :ai_vessel_nr AND
			POC.VOYAGE_NR = :as_voyage_nr using sqlca;
	COMMIT;	
	
	if isnull(ldt_arrival_date) and isnull(ldt_departure_date) then
		/* In this case there is no reason for further check */
		disconnect using sqlfrt;
		destroy sqlfrt;			
		return 1	
	else
		/*  Finds the dates for delivery and redelivery, which is tc_period_start and tc_period_end */
		/* in the tchirerates table */
//		SELECT distinct(TCHIRERATES.VESSEL_NR)
//		INTO :li_vessel_nr
//		FROM TCHIRERATES
//		WHERE TCHIRERATES.VESSEL_NR = :ai_vessel_nr AND
//			TCHIRERATES.TC_PERIOD_START <= :ldt_arrival_date USING SQLCA; 
//		commit;			
		SELECT TOP 1 CONTRACT_ID
			INTO :ll_contractID
			FROM NTC_TC_CONTRACT
			WHERE VESSEL_NR = :ai_vessel_nr AND
				DELIVERY <= :ldt_arrival_date AND
				TC_HIRE_IN = 0
			ORDER BY DELIVERY DESC
			USING SQLCA; 
			commit;			
		if not isnull(ll_contractID) and not isnull(ldt_departure_date) then
//			SELECT distinct(TCHIRERATES.VESSEL_NR)
//			INTO :li_vessel_nr
//			FROM TCHIRERATES
//			WHERE TCHIRERATES.VESSEL_NR = :ai_vessel_nr AND
//				TCHIRERATES.TC_PERIOD_END >= :ldt_departure_date USING SQLFRT; 
//			commit;
			SELECT count(*)
			INTO :li_count
			FROM NTC_TC_PERIOD
			WHERE CONTRACT_ID = :ll_contractID AND
				PERIODE_END >= :ldt_departure_date USING SQLFRT; 
			commit;
			if li_count > 0 then
				disconnect using sqlfrt;
				destroy sqlfrt;	
				return 1		
			else	
				disconnect using sqlfrt;
				destroy sqlfrt;	
				return 0
			end if	
		elseif sqlca.sqlcode =0 and isnull(ldt_departure_date) then 
			disconnect using sqlfrt;
			destroy sqlfrt;	
			return 1
		else
			disconnect using sqlfrt;
			destroy sqlfrt;	
			return 0
		end if
	end if	
elseif sqlfrt.sqlcode = 100 then
	/* In this case it´s not a tc-out vessel and there´s no need for further checks */
	disconnect using sqlfrt;
	destroy sqlfrt;	
	return -1
else
	/* An error occured while retrieving the database */
	disconnect using sqlfrt;
	destroy sqlfrt;	
	return 99
end if

return 0
end function

public function boolean uf_does_vessel_have_tc_owner (integer ai_vessel_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		: 
  
 Object     	: uf_does_vessel_have_tc_owner
  
 Scope     		: 

 ************************************************************************************

 Author    		: Bettina Olsen
   
 Date       	: 20-08-97

 Description 	: this function finds out if a veesel has a tc-owner or not

 Arguments 		: vessel number

 Returns   		: true if tc-owner, false if not

 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-97			5.00			BO				First Release
************************************************************************************/
/* Local variables */
int li_tc_owner

/* Get tc_owner of vessel */
SELECT isnull(VESSELS.TCOWNER_NR,-1)
INTO :li_tc_owner
FROM VESSELS  
WHERE VESSELS.VESSEL_NR = :ai_vessel_nr   ;
commit;

/* Return boolean */
if li_tc_owner < 0 then
	return false
else
	return true
end if

end function

public function string uf_check_finished_voyages_commission (ref integer ai_vessel_nr, ref string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: 	uf_check finished_voyages_commissions
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	28-11-97

 Description 	: 	This function checks all finished voyages. All the commissions,
 						tc-commissions and disb_expenses´s in_log fields are checked. The 
						only valid value for this field is 1.
						 
						Agent payments with a print_payment_date is checked. The only valid 
						value for payment_in_log is 1 when the print_payment_date is set. 

 Arguments 		: 	vessel_nr
 						voyage_nr

 Returns   		: 	string

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-11-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
transaction		newtransobject
integer			li_number_of_rows, li_in_log 
string			ls_return_value
datetime			ldt_set_off_date


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;


/* Count not valid rows from COMMISSIONS */ 
SELECT count ( DISTINCT COMMISSIONS.CLAIM_NR)
INTO :li_number_of_rows
 FROM COMMISSIONS  
 WHERE	 COMMISSIONS.VESSEL_NR =:ai_vessel_nr AND
			COMMISSIONS.VOYAGE_NR =:as_voyage_nr AND
			COMMISSIONS.COMM_IN_LOG <> 1  using newtransobject; 
commit;


/* Check the result of the sql */
if newtransobject.sqlcode = -1 then
	ls_return_value = "Error"
elseif newtransobject.sqlcode = 0 then
	if li_number_of_rows > 0 then
		ls_return_value = "COMM_IN_LOG IS NOT VALID IN COMMISSIONS,~r~n  "
	else
		ls_return_value = ""
	end if
end if


/* Select not valid rows from DISB_EXPENSES */
SELECT count (*)
INTO :li_number_of_rows
 FROM DISB_EXPENSES  
 WHERE	 DISB_EXPENSES.VESSEL_NR =:ai_vessel_nr AND
			DISB_EXPENSES.VOYAGE_NR =:as_voyage_nr AND
			DISB_EXPENSES.EXPENSE_IN_LOG <> 1  using newtransobject; 
commit;


/* Check the result of the sql */
if newtransobject.sqlcode = -1 then
	ls_return_value = "2 Error"
elseif newtransobject.sqlcode = 0 then
	if li_number_of_rows > 0 then
		ls_return_value += "EXPENSE_IN_LOG IS NOT VALID IN DISB_EXPENSES, ~r~n "
	else
		ls_return_value += ""
	end if
end if

/* Select not valid rows from TCCOMMISSIONS */
SELECT TCCOMMISSION.TCCOMM_SET_OFF_DT, TCCOMMISSION.TCCOMM_IN_LOG
INTO:ldt_set_off_date, :li_in_log
FROM TCCOMMISSION
WHERE TCCOMMISSION.VESSEL_NR =:ai_vessel_nr AND
		TCCOMM_SET_OFF_DT IS NOT NULL AND
		TCCOMMISSION.TCCOMM_IN_LOG <> 1 USING newtransobject;
commit;		
		
/* Check result from the sql */
IF newtransobject.sqlcode = -1 then
	ls_return_value += "3 Error"
elseif newtransobject.sqlcode = 0 then
	ls_return_value += "CHECK TCCOMM_IN_LOG, THE SET OFF DATE IS:  "+string(ldt_set_off_date)+"! ~r~n"
end if


/* Select not valid rows from DISB_PAYMENTS */
SELECT count ( DISTINCT DISB_PAYMENTS.VESSEL_NR)
 INTO :li_number_of_rows
 FROM DISB_PAYMENTS
 WHERE	DISB_PAYMENTS.VESSEL_NR =:ai_vessel_nr AND
			DISB_PAYMENTS.VOYAGE_NR =:as_voyage_nr AND
			DISB_PAYMENTS.PAYMENT_IN_LOG <> 1 AND
			DISB_PAYMENTS.PAYMENT_DATE IS NOT NULL USING newtransobject; 
commit;			
			
			if newtransobject.sqlcode = 0 then
				if li_number_of_rows > 0 then
					ls_return_value += "CHECK AGENT PAYMENT! "
				else
					ls_return_value += ""
				end if
			end if


/* Disconnect and destroy objects */
disconnect using newtransobject;
destroy newtransobject;


/* Return the result string */
return ls_return_value
end function

public function boolean uf_check_purpose_delivery (ref integer ai_vessel_nr, ref string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_purpose_delivery
  
 Event	 		: 

 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	18-08-97

 Description 	:  This function checks if the first port on a tc-voyage(tc-in and tc-out)
						has a delivery as purpose.

 Arguments 		:	vessel number
 						voyage number

 Returns   		:	boolean			- true 	ok
											- false	the purpose is not DEL (delivery) 

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-08-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
string 		ls_purpose

SELECT	POC.PURPOSE_CODE
		INTO :ls_purpose
		FROM POC
		WHERE POC.VESSEL_NR = :ai_vessel_nr  AND
    					POC.PORT_ARR_DT = (SELECT MIN(POC.PORT_ARR_DT)
									FROM	POC
									WHERE POC.VESSEL_NR = :ai_vessel_nr);	
									
if sqlca.sqlcode = 0 then
	commit;
	if ls_purpose = "DEL" then
		return true
	else
		return false
	end if
else
	rollback;
	return false
end if	
	
end function

public function boolean uf_check_misc_income (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_misc_income

 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	13-08-97

 Description 	:  Check if a voyage marked as finished in the Port-of-call-window,
						has any amounts in miscellanous income in some cargoes. If it has 
						then send an indikation because this is not legal. When you finish a
						voyage miscellanous got to be zero.

 Arguments 		:	vessel_nr
 						voyage_nr

 Returns   		: returns a boolean		
 							- true if ok
							- false if the misc income > 0
 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
13-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
decimal 	ld_misc_income
long 	ll_result
transaction	sqlfrt

ll_result = 0

/* Create transactionobject */
uo_global.defaulttransactionobject(sqlfrt)
connect using sqlfrt;


/* Declare cursor */
 DECLARE cargo_cursor CURSOR FOR  
  SELECT CAL_CARG.CAL_CARG_MISC_INCOME  
    FROM VOYAGES,   
         CAL_CARG  
   WHERE ( VOYAGES.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         ( ( VOYAGES.VESSEL_NR = :ai_vessel_nr ) AND  
         ( VOYAGES.VOYAGE_NR = :as_voyage_nr ) ) using sqlfrt;

/* Open cursor */
OPEN cargo_cursor;
 
/* Fetch */
FETCH  cargo_cursor INTO :ld_misc_income;


/* Check if there´s miscellanous income fields containing amounts */
Do while sqlfrt.sqlcode = 0 
	 if ld_misc_income <> 0 then
		ll_result++
	end if
	FETCH  cargo_cursor into :ld_misc_income;	
loop	


/* Close and destroy objects */
CLOSE cargo_cursor;
disconnect using sqlfrt;
destroy(sqlfrt)


/* Return result */
if ll_result > 0 then 
	return false
else
	return true
end if


end function

public subroutine uf_get_tcvessels (ref st_voyages astr_voyages);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_get_tcvessels

  ***********************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 11-08-97

 Description 	: This function finds all tc-vessels.
			
 Arguments 		: Structure

 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
11-08-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
st_voyages 	lst_voyage
long			ll_calc_id, i=0
integer 		li_vessel_nr


/* Get all tc vessels */
DECLARE tc_cursor CURSOR FOR
SELECT DISTINCT(TCHIRES.VESSEL_NR)
FROM TCHIRES
WHERE TCHIRES.TCHIRE_IN=0
ORDER BY TCHIRES.VESSEL_NR;

/* Open cursor */
OPEN tc_cursor;

/* Fetch */
FETCH tc_cursor INTO :li_vessel_nr;


DO WHILE  SQLCA.SQLCODE = 0
	i++
	astr_voyages.vessel_nr[i] 	= li_vessel_nr
	FETCH tc_cursor INTO :li_vessel_nr;
LOOP

/* Close cursor */
CLOSE tc_cursor;
end subroutine

public function string uf_check_dem_claims (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_check_dem_claims
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	02-12-97

 Description 	: 	Checks if the voyage has a forwarding date. After that there´s a check 
 						which checks if the total days used on L,D,L/D is larger than the time 
						registred  in calculation.
						 

 Arguments 		: 	vessel_nr
 						voyage_nr

 Returns   		:  string

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
transaction		newtransobject
integer			li_number_of_rows, li_in_log
long				ll_poc_hours, ll_calc_hours, ll_calc_rate, ll_est_rate, ll_calc_id
long				ll_units, ll_terms, ll_rate
string			ls_return_value
long				ll_minutes
Double 			ld_calc_time,ld_poc_hours, ld_calc_hours
u_calc_laytime uo_calc_laytime

/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;


/* Check if there´s forwarding date containing null */
SELECT COUNT(CLAIMS.VESSEL_NR)
INTO :li_number_of_rows
FROM CLAIMS
WHERE CLAIMS.VESSEL_NR = :ai_vessel_nr AND
		CLAIMS.VOYAGE_NR = :as_voyage_nr AND
		CLAIMS.CLAIM_TYPE = "DEM" AND
		CLAIMS.FORWARDING_DATE IS NULL using newtransobject;
commit;


if newtransobject.sqlcode = -1 then
	ls_return_value = "Error while retrieving database ~r~n "
elseif newtransobject.sqlcode = 0 then
	if li_number_of_rows > 0 then
		ls_return_value = "Forwarding date is missing.~r~n" 
	end if
end if 

/* Next step is to find out if the hours used on L,D,L/D registred in the Port of Call */
/* window is larger than the hours registred in the calculated or estimated field in */
/* the calculation */


/* Get the hours registred in POC */
SELECT ISNULL(SUM(DATEDIFF(MINUTE,POC.PORT_ARR_DT,POC.PORT_DEPT_DT)),0)
INTO :ll_minutes
FROM POC
WHERE POC.VESSEL_NR = :ai_vessel_nr AND
		POC.VOYAGE_NR = :as_voyage_nr AND
		POC.PORT_ARR_DT <> NULL AND
		POC.PORT_DEPT_DT <> NULL AND
		POC.PURPOSE_CODE IN ("L","D","L/D") using newtransobject;
commit;

if newtransobject.sqlcode = -1 then
	ls_return_value += "Error while retrieving database.~r~n" 
else
	// Get calcule ID for this voyage/vessel
	SELECT CAL_CALC.CAL_CALC_ID
	INTO :ll_calc_id
	FROM VOYAGES, CAL_CALC
	WHERE VOYAGES.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND 
		VOYAGES.VESSEL_NR = :ai_vessel_nr AND
		VOYAGES.VOYAGE_NR = :as_voyage_nr AND
		CAL_CALC.CAL_CALC_STATUS = 6
	USING newtransobject;


		ld_poc_hours = ll_minutes/60
	/* Get the hours registred in Calculation Module */

	COMMIT;

	uo_calc_laytime = CREATE u_calc_laytime

	uo_calc_laytime.uf_load_calc(ll_calc_id, newtransobject)
	uo_calc_laytime.uf_calculate_laytime(0)

	ld_calc_time = uo_calc_laytime.istr_calc_data.d_load_minutes + &
		uo_calc_laytime.istr_calc_data.d_load_minutes_gear + &
		uo_calc_laytime.istr_calc_data.d_disch_minutes + &
		uo_calc_laytime.istr_calc_data.d_disch_minutes_gear

	DESTROY uo_calc_laytime
	
	ld_calc_hours = ld_calc_time/60

	If ld_poc_hours > ld_calc_hours Then
		ls_return_value += "Time registred on loading, discharging and load/disch in ~r~n port of call don´t match registration in calculation.~r~n"
	end if


//
//
//
//	ll_poc_hours = ll_minutes/60
//
//
//	/* Get the hours registred in Calculation Module */
//	DECLARE calcaio_cursor CURSOR FOR
//	SELECT isnull(CAL_CAIO.CAL_CAIO_RATE_CALCULATED,0), isnull(CAL_CAIO.CAL_CAIO_RATE_ESTIMATED,0),
//			isnull(CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS,0), CAL_CAIO.CAL_CAIO_LOAD_TERMS
//	FROM VOYAGES, CAL_CALC, CAL_CARG, CAL_CAIO
//	WHERE VOYAGES.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND
//			CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND
//			CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID AND
//			VOYAGES.VESSEL_NR = :ai_vessel_nr AND
//			VOYAGES.VOYAGE_NR = :as_voyage_nr AND
//			CAL_CALC.CAL_CALC_STATUS = 6 using newtransobject;
//
//	/* Open cursor */
//	OPEN calcaio_cursor;
//
//	/* Fetch */
//	Fetch calcaio_cursor INTO	:ll_calc_rate, :ll_est_rate, :ll_units, :ll_terms;
//
//
//
//	Do while newtransobject.sqlcode = 0
//	
//		if ll_calc_rate > 0 then
//			ll_rate = ll_calc_rate
//		else
//			ll_rate = ll_est_rate
//		end if
//		
//		
//		if ll_terms = 0 then
//			ll_calc_hours += ll_rate
//		else
//			ll_calc_hours += uf_calculate_time_used(ll_rate, ll_units, ll_terms)
//		end if
//		
//		
//		Fetch calcaio_cursor INTO	:ll_calc_rate, :ll_est_rate, :ll_units, :ll_terms;
//	
//	Loop
//
//
//	if newtransobject.sqlcode = -1 then
//		ls_return_value +="Error while retrieving database.~r~n"
//	elseif ll_poc_hours > ll_calc_hours then
//		ls_return_value += "Time used on L,D,L/D differs between Port of Call and Calculation.~r~n"
//	else
//		ls_return_value += ""
//	end if
//
end if
	

	
	/* Close and destroy objects */
//	CLOSE calcaio_cursor;
	disconnect using newtransobject;
	destroy(newtransobject)

	

/* Return result */
return ls_return_value
end function

public function integer uf_check_purpose_offservice (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_check_purpose_offservice
 
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	01-12-97

 Description 	: 	This function search for information registred in Port of Call
 						about a voyage Off service days (purpose REP or DOK).
						If ther´s registred something about Off Service days in Port of Call
						it´s got to be registred in the Off Service Module too. 

 Arguments 		: 	vessel nr
 						voyage nr

 Returns   		: integer
									- 99 an error occurred while retrieving
									-  0 registration ok
									-  1 registration in Offservice module is missing

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
transaction		newtransobject
integer			li_number_of_rows, li_in_log, li_return_value 


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;


/* Count rows in the port of call table */
SELECT count (*)
INTO :li_number_of_rows
 FROM POC  
 WHERE	POC.VESSEL_NR =:ai_vessel_nr AND
			POC.VOYAGE_NR =:as_voyage_nr AND
			(POC.PURPOSE_CODE = "REP" OR 
			POC.PURPOSE_CODE = "DOK") using newtransobject; 
commit;


/* Check result of sql */
if newtransobject.sqlcode = -1 then
	li_return_value = 99
elseif newtransobject.sqlcode = 0 then
	if li_number_of_rows > 0 then
		
		SELECT count (*)
		INTO :li_number_of_rows
 		FROM OFF_SERVICES  
 		WHERE	OFF_SERVICES.VESSEL_NR =:ai_vessel_nr AND
			OFF_SERVICES.VOYAGE_NR =:as_voyage_nr  using newtransobject; 
		commit;
		
		if newtransobject.sqlcode = -1 then
			li_return_value = 99
		elseif newtransobject.sqlcode = 0 then
			if li_number_of_rows > 0 then
				li_return_value = 0
			else
				li_return_value = 1
			end if
		end if
	else
		li_return_value = 0
	end if

end if


/* Disconnect and destroy object */
disconnect using newtransobject;
destroy newtransobject;


/* Return result */
return li_return_value
end function

public function integer uf_check_purpose_idle (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_check_purpose_idle
 
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	01-12-97

 Description 	: 	This function search for information registred in Port of Call
 						about a voyages idle days. If ther´s registred something about
						idle days in Port of Call it´s got to be registred in the Idle
						Days Module too. 

 Arguments 		: 	vessel nr
 						voyage nr

 Returns   		: 	integer
 									- 99 an error occured
										1 registration in the Idle Days Module is missing.
										0 registration ok	
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
transaction		newtransobject
integer			li_number_of_rows, li_in_log, li_return_value 


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;

/* Select rows */
SELECT count ( *)
INTO :li_number_of_rows
 FROM POC  
 WHERE	POC.VESSEL_NR = :ai_vessel_nr AND
			POC.VOYAGE_NR =:as_voyage_nr AND
			POC.PURPOSE_CODE = "WD"  using newtransobject; 
commit;

/* Check the result */
if newtransobject.sqlcode = -1 then
	li_return_value = 99
elseif newtransobject.sqlcode = 0 then
	if li_number_of_rows > 0 then
		
		SELECT count ( *)
		INTO :li_number_of_rows
 		FROM IDLE_DAYS  
 		WHERE	IDLE_DAYS.VESSEL_NR = :ai_vessel_nr AND
			IDLE_DAYS.VOYAGE_NR =:as_voyage_nr  using newtransobject; 
		commit;
		
		if newtransobject.sqlcode = -1 then
			li_return_value = 99
		elseif newtransobject.sqlcode = 0 then
			if li_number_of_rows > 0 then
				li_return_value = 0
			else
				li_return_value = 1
			end if
		end if
	else
		li_return_value = 0
	end if

end if

/* Disconnect and destroy object */
Disconnect using newtransobject;
Destroy newtransobject;

/* Return result */
return li_return_value
end function

public function integer uf_is_poc_in_tcperiod (integer ai_vessel_nr, datetime adt_arrival, datetime adt_departure);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_is_poc_in_tcperiod

 Event	 		: 

 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 06-08-97

 Description 	:  A voyage marked as a tc-out voyage will be checked as follows:
						- is the ship a tc-out vessel
						- if it is a tc-out vessel then check if it is time charted in the period where 
						the voyage is.
			

 Arguments 		:	vessel nr
 						arrival date
						departure date

 Returns   		: returns an integer		-1	The vessel is not a tc-out vessel.
							 						0	It is a tc-out vessel but not in that period.
							 						1	It is a tc-out vessel in that period.
													99	An error occured while retrieving.

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-08-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction 	sqlfrt
integer 			li_tchire, li_vessel_nr

/* Create transactionobject */
uo_global.defaulttransactionobject(sqlfrt)
connect using sqlfrt;


/* Check if the given vessel is a tcout vessel */
/* Check if the vessel i located in the tchire-table and if it is a tc-out vessel */



SELECT distinct(TCHIRES.VESSEL_NR)
INTO :li_tchire
FROM TCHIRES
WHERE TCHIRES.VESSEL_NR = :ai_vessel_nr and TCHIRES.TCHIRE_IN = 0 
using sqlfrt;

COMMIT;


if sqlfrt.sqlcode = 0  then
 	
	
	/* if it is a tc out skib then check the period, which means that we finds the first port arrival */
	/* date and the last departure date in the POC-table.  */
	
	
				SELECT distinct(TCHIRERATES.VESSEL_NR)
				INTO :li_vessel_nr
				FROM TCHIRERATES
				WHERE TCHIRERATES.VESSEL_NR = :ai_vessel_nr AND
					TCHIRERATES.TC_PERIOD_START <= :adt_arrival USING SQLCA; 
							
				if sqlca.sqlcode = 0 and not isnull(adt_departure) then
				
					SELECT distinct(TCHIRERATES.VESSEL_NR)
					INTO :li_vessel_nr
					FROM TCHIRERATES
					WHERE TCHIRERATES.VESSEL_NR = :ai_vessel_nr AND
						TCHIRERATES.TC_PERIOD_END >= :adt_departure USING SQLCA; 
					
					if sqlca.sqlcode = 0 then
						disconnect using sqlfrt;
						destroy sqlfrt;	
						return 1		
					else	
				
						disconnect using sqlfrt;
						destroy sqlfrt;	
						return 0
					end if	

				elseif sqlca.sqlcode = 0 and isnull(adt_departure)  then

					disconnect using sqlfrt;
					destroy sqlfrt;	
					return 1
					
				else
					
					disconnect using sqlfrt;
					destroy sqlfrt;	
					return 0
					
				end if
				

elseif sqlfrt.sqlcode = 100 then
		/* In this case it´s not a tc-out vessel and there´s no need for further checks */
		disconnect using sqlfrt;
		destroy sqlfrt;	
		return -1
else
	/* An error occured while retrieving the database */

	disconnect using sqlfrt;
	destroy sqlfrt;	
	return 99
end if
	

return 0
end function

public function integer uf_is_tcvoyage (integer ai_vessel_nr, string as_voyage_nr);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_is_tcvoyage

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	:  18-12-97

 Description 	:  Checks if the voyage is marked as a tcvoyage.(Voyage-type = 2)

 Arguments 		: 	vessel_nr
 						voyage_nr

 Returns   		: returns an integer			0 it is not a tc-voyage
 														1 it is a tc-voyage
  
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction		newtrans
integer			li_type


/* Create transactionobject */
uo_global.defaulttransactionobject(newtrans)
connect using newtrans;

/* Get the voyage type on the current voyage */
SELECT VOYAGES.VOYAGE_TYPE
INTO :li_type
FROM VOYAGES
WHERE VOYAGES.VESSEL_NR = :ai_vessel_nr AND
		VOYAGES.VOYAGE_NR = :as_voyage_nr using newtrans;


if newtrans.sqlcode = 0 then
	if li_type = 2 then
		disconnect using newtrans;
		destroy newtrans;
		return 1
	else
		disconnect using newtrans;
		destroy newtrans;
		return 0
	end if
end if

/* Disconnect and destroy object */
Disconnect using newtrans;
Destroy newtrans;
	
return 0
end function

public function string uf_check_new_rate (integer ai_vessel_nr, datetime adt_start, datetime adt_end);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_new_rate
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	10-12-97

 Description 	: 	
 
 Arguments 		: 	vessel number
 						start date
						end date
 
 Returns   		: 	string

 *************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction		newtransobject
datetime			ld_period_start,ld_period_end
datastore 		ds_periods
integer			li_row, li_number_of_rows
string			ls_result


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;

/* Create datastore */
ds_periods = create datastore
ds_periods.dataobject = 'd_tcperiods'
ds_periods.settransobject(sqlca)
ds_periods.retrieve(ai_vessel_nr)

/* Insert the start and end date received as arguments to this function */
li_row = ds_periods.insertrow(0)
ds_periods.setitem(li_row,1,adt_start)
ds_periods.setitem(li_row,2,adt_end)

/* Find out how many rows are represented in the datastore */
li_number_of_rows = ds_periods.rowcount()

/* Start check */
if li_number_of_rows > 1 then
	FOR li_row = 2 to li_number_of_rows
		IF (ds_periods.getitemdatetime(li_row -1,1) < ds_periods.getitemdatetime(li_row,1)) and &
			(ds_periods.getitemdatetime(li_row ,1) >= ds_periods.getItemdatetime(li_row -1,2)) then 
		
			ls_result =""
		else
			ls_result  = "Fail in registration of tc-periods! ~r~n" 
			for li_row = 1 to li_number_of_rows
				ls_result  += 	"Tc period start: "+string(ds_periods.getitemdatetime(li_row,1))+&
									"      Tc period end: "+string(ds_periods.getitemdatetime(li_row,2))+"~r~n"
			next			
			destroy(ds_periods)
			return ls_result
		end if						
	NEXT
end if

/* Destroy datastore */
destroy(ds_periods)
return ""
end function

public function integer uf_check_finished_voyages_claims (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_check finished_voyages_claims
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	28-11-97

 Description 	: 

 Arguments 		: 	vessel_nr
 						voyage_nr

 Returns   		: - 1 an error occured
 						 0 the voyage is ok
						 1 claim_in_log value is not valid
 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-11-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare variables */
transaction		sqlclaim
integer			li_number_of_claims, li_return_value



/* Create transactionobject */
uo_global.defaulttransactionobject(sqlclaim)
connect using sqlclaim;

/* Find claims where claim in log is 0 and null and the date is set */
SELECT count ( DISTINCT CLAIMS.CLAIM_NR)
INTO :li_number_of_claims
 FROM CLAIMS  
 WHERE	CLAIMS.VESSEL_NR =:ai_vessel_nr AND
			CLAIMS.VOYAGE_NR =:as_voyage_nr AND
			(CLAIMS.CLAIM_IN_LOG = 0 OR CLAIMS.CLAIM_IN_LOG IS NULL) AND
			CLAIMS.EXPECT_RECEIVE_DATE IS NOT NULL using sqlclaim; 
commit;



if sqlclaim.sqlcode = -1 then
	li_return_value = -1

elseif sqlclaim.sqlcode = 0 then
	if li_number_of_claims > 0 then
		li_return_value = 1
	else
		li_return_value = 0
	end if
end if

/* Disconnect and destroy */
disconnect using sqlclaim;
destroy sqlclaim;

/* Return result */
return li_return_value
end function

public function decimal uf_calculate_calc_heating (long al_carg_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_calculate_calc_heating
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	December 97

 Description 	: 	Calculates the price used on heating in the calculation.

 Arguments 		: 	the cargo id
 				
 Returns   		:  Returns the amount

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
dec 97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
decimal 	ld_hfo_ton, ld_hfo_price, ld_do_ton, ld_do_price, ld_go_ton, ld_go_price, ld_lshfo_ton, ld_lshfo_price
decimal  ld_amount

	/* Selects the nescessary fields from the CAL_HEDV table */
	SELECT  	isnull(CAL_HEDV.CAL_HEDV_HFO_TON,0), isnull(CAL_HEDV.CAL_HEDV_HFO_PRICE,0),isnull(CAL_HEDV.CAL_HEDV_DO_TON,0),
				isnull(CAL_HEDV.CAL_HEDV_DO_PRICE,0),isnull(CAL_HEDV.CAL_HEDV_GO_TON,0),isnull(CAL_HEDV.CAL_HEDV_GO_PRICE,0),
				isnull(CAL_HEDV.CAL_HEDV_LSHFO_TON,0),isnull(CAL_HEDV.CAL_HEDV_LSHFO_PRICE,0)
	INTO 		:ld_hfo_ton, :ld_hfo_price, :ld_do_ton, :ld_do_price, :ld_go_ton, :ld_go_price, :ld_lshfo_ton, :ld_lshfo_price  
	FROM 		CAL_HEDV
	WHERE		CAL_HEDV.CAL_CARG_ID = :al_carg_id AND CAL_HEDV.CLAIM_TYPE= 'HEA';
	commit;
	
	/* Calculate the total amount */
	ld_amount = (ld_hfo_ton * ld_hfo_price) + (ld_do_ton * ld_do_price) + (ld_go_ton * ld_go_price) + (ld_lshfo_ton * ld_lshfo_price)

/* Returns the amount */
return ld_amount
end function

public function string uf_check_tcperiods (integer ai_vessel_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_tcperiods
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 10-12-97

 Description 	: 	This functions check for overlapping tc-periods. If there´s registred
 						overlapping periods a warning is returned.
 
 Arguments 		: 	vessel number
 						

 Returns   		: 	string

 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction		newtransobject
datastore 		ds_periods
integer			li_row, li_number_of_rows
string			ls_result


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;

/* create datastore */
ds_periods = create datastore
ds_periods.dataobject = 'd_tcperiods'
ds_periods.settransobject(sqlca)
ds_periods.retrieve(ai_vessel_nr)

li_number_of_rows = ds_periods.rowcount()
if li_number_of_rows > 1 then
	FOR li_row = 2 to li_number_of_rows
		IF (ds_periods.getitemdatetime(li_row -1,1) < ds_periods.getitemdatetime(li_row,1)) and &
			(ds_periods.getitemdatetime(li_row ,1) >= ds_periods.getItemdatetime(li_row -1,2)) then 
		
			ls_result =""
		else
			ls_result  = "Fail in registration of tc-periods! ~r~n" 
			for li_row = 1 to li_number_of_rows
				ls_result  += 	"Tc period start: "+string(ds_periods.getitemdatetime(li_row,1))+&
									"      Tc period end: "+string(ds_periods.getitemdatetime(li_row,2))+"~r~n"
			next			
			destroy(ds_periods)
			return ls_result
		end if						
	NEXT
end if

/* Destroy datastore */
destroy(ds_periods)

return ""
end function

public function long uf_calculate_time_used (long al_rate, long al_units, long al_term);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_calculate_time_used
  
 Event	 		: 

 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 04-12-97

 Description 	: 	This function is called from another function uf_check_dem_claims. It 
 						calculates the time spent on L,D,L/D

 Arguments 		: 	rate
						units
 						term
 
 Returns   		: the time used in hours

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
04-12-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
integer ll_return_value

if al_units = 0 OR al_rate = 0 then
	return al_units
end if

CHOOSE CASE al_term
	CASE 1,2,3
		
		ll_return_value = al_units/al_rate
		
	CASE 4
		
		ll_return_value = al_units/24
		
	CASE 5,6,7
		
		ll_return_value = al_units/al_rate/24
		
END CHOOSE




return ll_return_value
end function

public function string uf_check_tc_currency (integer ai_vessel_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window     	:
  
 Object     	: uf_check_tc_currency
  
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	16-01-98

 Description 	: 	Check a vessel´s tchires. If there are more tchires in the same period, 
 						then check if they have the same currency. If they don´t have the same
						 currency, then inform the the calling funktion about the error.

 Arguments 		: 	the vessel_id

 Returns   		: 	returns string

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-01-98			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
transaction		newtransobject
datetime			ld_cp_date
integer			li_row, li_number_of_rows, li_number_of_currencies, i, li_array_size
string			ls_result, ls_currency, ls_message
s_tc_currency  lst_currency[]

/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;

/* Check if there´s registred different currencies */
SELECT count(distinct(TCHIRES.CURR_CODE) )
INTO :li_number_of_currencies
FROM TCHIRERATES,   
         TCHIRES  
WHERE ( TCHIRES.VESSEL_NR = TCHIRERATES.VESSEL_NR ) and  
      ( TCHIRES.TCHIRE_CP_DATE = TCHIRERATES.TCHIRE_CP_DATE ) and  
      ( TCHIRES.VESSEL_NR = :ai_vessel_nr ) using newtransobject;    

/* If nothing was found */
if newtransobject.sqlcode = 100 then
	disconnect using newtransobject;
	destroy newtransobject;
	return ""
/* If there´s only one currency then there´s no need for further check */ 
elseif newtransobject.sqlcode = 0 and li_number_of_currencies = 1 then
	disconnect using newtransobject;
	destroy newtransobject;
	return ""

else
	/* If there´re more than one currency registred, the check begins, because we want to */
	/* found out if the currency are the same for overlapping tc-in and tc-out periods */
	
	DECLARE cp_cursor CURSOR FOR
	SELECT TCHIRES.TCHIRE_CP_DATE, TCHIRES.CURR_CODE
	FROM TCHIRES
	WHERE TCHIRES.VESSEL_NR= :ai_vessel_nr 
	ORDER BY TCHIRES.TCHIRE_CP_DATE using newtransobject;

	OPEN cp_cursor;
	
	FETCH cp_cursor INTO :ld_cp_date,:ls_currency;
	
	i=0
	
	Do while newtransobject.sqlcode = 0 
		i++
		lst_currency[i].currency = ls_currency
		lst_currency[i].cp_date  = ld_cp_date
		FETCH cp_cursor INTO :ld_cp_date,:ls_currency;
	loop
		
	CLOSE cp_cursor;
	
	
	/* Get the needed information about the periods and the currency */
	li_array_size = upperbound(lst_currency)
	for i = 1 to li_array_size 
		SELECT MIN(TC_PERIOD_START),
				MAX(TC_PERIOD_END)
		INTO :lst_currency[i].tc_period_start, :lst_currency[i].tc_period_end
		FROM TCHIRERATES 
		WHERE VESSEL_NR = :ai_vessel_nr AND 
				TCHIRE_CP_DATE = :lst_currency[i].cp_date using newtransobject;
			
	next		
	
	if newtransobject.sqlcode = 0 then
		
		/* Check the results you got from the cursor */
		for i = 2 to li_array_size
			
			if lst_currency[i].tc_period_start < lst_currency[i -1].tc_period_end then
				if lst_currency[i].currency <> lst_currency[i -1].currency then
					ls_message += "Cp-date "+string(lst_currency[i -1].cp_date)+" Start "+string(lst_currency[i -1].tc_period_start)+" End "+string(lst_currency[i -1].tc_period_end)+" Currency "+lst_currency[i -1].currency+"~r~n"
					ls_message += "Cp-date "+string(lst_currency[i].cp_date)+" Start "+string(lst_currency[i].tc_period_start)+" End "+string(lst_currency[i].tc_period_end)+" Currency "+lst_currency[i].currency+"~r~n"
				end if	
			end if
			
		next
	else 
		ls_message = ""
	end if
	
	/* Destroy and close */
	disconnect using newtransobject;
	destroy newtransobject;
	
	/* Return result */
	return ls_message


end if
end function

public subroutine uf_get_all_finished_voyages (ref st_voyages astr_voyages, string as_year, integer ai_pcnr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_get_all_finished_voyages

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 13-08-97

 Description 	: 	This function finds all finished voyages(voyage_finished = 1) 
 						in the database. The result will only be finished voyages with a
						cal_calc_id > 1.			 
			
 Arguments 		:	structure

 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
11-08-97			1.0			BO				Initial version  
23-03-98			1.1			BO				The query is now only for a specified year.
05-04-01			1.2			TAU			The query was modified to take a profit center
													as a retrieval argument.
08-08-08			16.03			RMO			Added vessel reference number													
************************************************************************************/
/* Declare variables */
long			ll_calc_id, i=0
string 		ls_voyage_nr, ls_vessel_ref_nr
integer 		li_vessel_nr, li_voyage_type


/* Get all voyages and their voyage type and calc id */
DECLARE voyage_cursor CURSOR FOR
SELECT VOYAGES.VESSEL_NR,
			VOYAGES.VOYAGE_NR,
			VOYAGES.CAL_CALC_ID,
			VOYAGES.VOYAGE_TYPE,
			VESSELS.VESSEL_REF_NR
FROM VOYAGES,
		VESSELS
WHERE VOYAGES.VESSEL_NR = VESSELS.VESSEL_NR AND
		VESSELS.PC_NR = :ai_pcnr AND
		VOYAGES.VOYAGE_FINISHED = 1 AND
	 	VOYAGES.CAL_CALC_ID > 1 AND
		(SUBSTRING(VOYAGES.VOYAGE_NR,1,2) = SUBSTRING(:as_year,3,2));

/* Open cursor */
OPEN voyage_cursor;

/* Fetch cursor */
FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr ;

DO WHILE  SQLCA.SQLCODE = 0
	i++
	astr_voyages.vessel_nr[i] 	= li_vessel_nr
	astr_voyages.voyage_nr[i] 	= ls_voyage_nr
	astr_voyages.calc_id[i]		= ll_calc_id
	astr_voyages.voyage_type[i]=li_voyage_type
	astr_voyages.vessel_ref_nr[i] 	= ls_vessel_ref_nr
	
	FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr;
LOOP

/* Close cursor */
CLOSE voyage_cursor;
end subroutine

public subroutine uf_get_all_tc_voyages (ref st_voyages astr_voyages, string as_year, integer ia_pcnr);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Object     	: uf_get_all_voyages
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 11-08-97
 Description 	: Finds all tc-voyages for a given year.
 Arguments 		: Structure
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
11-08-97			1.0			BO				Initial version  
23-03-98			1.1			BO				The query is now only for a specified year.
08-08-08			16.03			RMO			Added vessel reference number
************************************************************************************/
/* Declare variables */
long			ll_calc_id, i=0
string 		ls_voyage_nr, ls_vessel_ref_nr
integer 		li_vessel_nr, li_voyage_type

/* Get all voyages and their voyage type and calc id */
DECLARE voyage_cursor CURSOR FOR
SELECT VOYAGES.VESSEL_NR,
		VOYAGES.VOYAGE_NR,
		VOYAGES.CAL_CALC_ID,
		VOYAGES.VOYAGE_TYPE,
		VESSELS.VESSEL_REF_NR
FROM VOYAGES,
		VESSELS
WHERE VOYAGES.VESSEL_NR = VESSELS.VESSEL_NR AND
		VESSELS.PC_NR = :ia_pcnr AND
		VOYAGES.VOYAGE_TYPE = 2 AND
		(SUBSTRING(VOYAGES.VOYAGE_NR,1,2) = SUBSTRING(:as_year,3,2))
ORDER BY VOYAGES.VESSEL_NR, VOYAGES.VOYAGE_NR;

/* Open cursor */
OPEN voyage_cursor;

/* Fetch cursor */
FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr;


DO WHILE  SQLCA.SQLCODE = 0
	i++
	astr_voyages.vessel_nr[i] 	= li_vessel_nr
	astr_voyages.voyage_nr[i] 	= ls_voyage_nr
	astr_voyages.calc_id[i]		= ll_calc_id
	astr_voyages.voyage_type[i]	= li_voyage_type
	astr_voyages.vessel_ref_nr[i] 	= ls_vessel_ref_nr
	
	FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr;
LOOP

/* Close cursor */
CLOSE voyage_cursor;
end subroutine

public subroutine uf_get_all_voyages (ref st_voyages astr_voyages, string as_year, integer ai_pcnr);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Object     	: uf_get_all_voyages
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 11-08-97
 Description 	: This functions finds all voyages containing a calc_id > 1 for a 
 						specified year.
 Arguments 		: structure
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
11-08-97			1.0			BO				Initial version  
23-03-98			1.0			BO				The query is now only for a specified year.
08-08-08			16.03			RMO			Added vessel reference number
************************************************************************************/
/* Declare variables */
long			ll_calc_id, i=0
string 		ls_voyage_nr, ls_vessel_ref_nr
integer 		li_vessel_nr, li_voyage_type


/* Get all voyages and their voyage type and calc id */
DECLARE voyage_cursor CURSOR FOR
SELECT VOYAGES.VESSEL_NR,
		VOYAGES.VOYAGE_NR,
		VOYAGES.CAL_CALC_ID,
		VOYAGES.VOYAGE_TYPE,
		VESSELS.VESSEL_REF_NR
FROM VOYAGES,
		VESSELS
WHERE VOYAGES.VESSEL_NR = VESSELS.VESSEL_NR AND
		VESSELS.PC_NR = :ai_pcnr AND
		(VOYAGES.CAL_CALC_ID > 1 or VOYAGES.VOYAGE_TYPE = 3) AND
		(SUBSTRING(VOYAGES.VOYAGE_NR,1,2) = SUBSTRING(:as_year,3,2))
ORDER BY VOYAGES.VESSEL_NR, VOYAGES.VOYAGE_NR;

/* Open cursor */
OPEN voyage_cursor;

/* Fetch */
FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr;


DO WHILE  SQLCA.SQLCODE = 0
	i++
	astr_voyages.vessel_nr[i] 	= li_vessel_nr
	astr_voyages.voyage_nr[i] 	= ls_voyage_nr
	astr_voyages.calc_id[i]		= ll_calc_id
	astr_voyages.voyage_type[i]	= li_voyage_type
	astr_voyages.vessel_ref_nr[i]	= ls_vessel_ref_nr
	FETCH voyage_cursor INTO :li_vessel_nr, :ls_voyage_nr, :ll_calc_id, :li_voyage_type, :ls_vessel_ref_nr;
LOOP

/* Close cursor */
CLOSE voyage_cursor;
end subroutine

public function decimal uf_calculate_calc_deviation (long al_carg_id);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Object     	: uf_calculate_calc_deviation
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 	December 97
 Description 	:  Calculates the price used on deviation in the calculation.
 Arguments 		: 	the cargo id
 Returns   		:  returns the amount
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
dec 97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
decimal 	ld_hfo_ton, ld_hfo_price, ld_do_ton, ld_do_price, ld_go_ton, ld_go_price, ld_lshfo_ton, ld_lshfo_price
decimal  ld_amount, ld_time_amount, ld_hours, ld_price

	/* Select the nescessary fields from the CAL_HEDV table */
	SELECT  	isnull(CAL_HEDV.CAL_HEDV_HFO_TON,0),isnull(CAL_HEDV.CAL_HEDV_HFO_PRICE,0),isnull(CAL_HEDV.CAL_HEDV_DO_TON,0),
				isnull(CAL_HEDV.CAL_HEDV_DO_PRICE,0),isnull(CAL_HEDV.CAL_HEDV_GO_TON,0),isnull(CAL_HEDV.CAL_HEDV_GO_PRICE,0),
				isnull(CAL_HEDV.CAL_HEDV_LSHFO_TON,0),isnull(CAL_HEDV.CAL_HEDV_LSHFO_PRICE,0),
				isnull(CAL_HEDV_HEA_DEV_HOURS,0),isnull(CAL_HEDV_HEA_DEV_PRICE_PR_DAY,0)
	INTO 		:ld_hfo_ton, :ld_hfo_price, :ld_do_ton, :ld_do_price, :ld_go_ton, :ld_go_price, :ld_lshfo_ton, :ld_lshfo_price, :ld_hours, :ld_price 
	FROM 		CAL_HEDV
	WHERE		CAL_HEDV.CAL_CARG_ID = :al_carg_id AND CAL_HEDV.CLAIM_TYPE= 'DEV';
	commit;
	
	
	/* Calculate the price for extra time used */
	if ld_hours=0 AND ld_price=0 then 
		ld_time_amount = 0
	else
		ld_time_amount = (ld_hours/24) * ld_price
	end if
	
	/* Calculate the total amount */
	ld_amount = (ld_hfo_ton * ld_hfo_price) + (ld_do_ton * ld_do_price) + (ld_go_ton * ld_go_price)+(ld_lshfo_ton * ld_lshfo_price)+ ld_time_amount



return ld_amount
end function

public function string uf_check_estimated_claims (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		:
  
 Object     	: uf_check_estimated_claims
 
 Scope     		: 

 ************************************************************************************

 Author    		:  Bettina Olsen
   
 Date       	: 	05-12-97

 Description 	: 	This function checks if the claim-amounts written in the
 						calculation are the same as the claim-amounts written in
						the claim-window in Operations. If they´re not a message 
						is returned to the calling function.

 Arguments 		: 	vessel number
 						voyage number

 Returns   		: 	string

 *************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
05-12-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
long 				ll_chart_nr,ll_carg_id, ll_previous_chart_nr
transaction 	newtransobject
decimal{2}		ld_calc_hea_amount, ld_calc_dev_amount, ld_calc_misc_amount
decimal{2}		ld_claim_hea_amount, ld_claim_dev_amount, ld_claim_misc_amount, ld_amount
string			ls_return_string


/* Create transactionobject */
uo_global.defaulttransactionobject(newtransobject)
connect using newtransobject;


/* Declare cursor to find the charterers and cargo ids on this voyage */
DECLARE chart_cursor CURSOR FOR
SELECT isnull(CAL_CERP.CHART_NR,0),isnull(CAL_CARG.CAL_CARG_ID,0)
FROM VOYAGES, CAL_CALC, CAL_CARG, CAL_CERP
WHERE VOYAGES.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND
		CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
		CAL_CARG.CAL_CERP_ID = CAL_CERP.CAL_CERP_ID AND
		CAL_CALC.CAL_CALC_STATUS = 6 AND
		VOYAGES.VESSEL_NR = :ai_vessel_nr AND
		VOYAGES.VOYAGE_NR = :as_voyage_nr using newtransobject;
		
/* Open cursor */
OPEN chart_cursor;

/* Fetch */
ll_previous_chart_nr = 0
FETCH chart_cursor INTO :ll_chart_nr, :ll_carg_id;


/* Save the charterer numbers in an array */ 
DO WHILE newtransobject.sqlcode =0
	
	
	ld_calc_hea_amount += uf_calculate_calc_heating(ll_carg_id)
	
	ld_calc_dev_amount += uf_calculate_calc_deviation(ll_carg_id)
	
	/* Get miscellanous claim amount from calculation */
	SELECT isnull(SUM(CAL_CLMI.CAL_CLMI_AMOUNT),0)
	INTO :ld_amount
	FROM CAL_CLMI
	WHERE CAL_CLMI.CAL_CARG_ID = :ll_carg_id using SQLCA;
	commit;
	ld_calc_misc_amount += ld_amount
	
	if sqlca.sqlcode = 0 and ll_previous_chart_nr <> ll_chart_nr then
		/* Get heating claim amount from claims module */
		SELECT ISNULL(SUM(CLAIMS.CLAIM_AMOUNT_USD),0)
		INTO :ld_amount
		FROM CLAIMS
		WHERE CLAIMS.VESSEL_NR = :ai_vessel_nr AND
				CLAIMS.VOYAGE_NR = :as_voyage_nr AND
				CLAIMS.CHART_NR = :ll_chart_nr AND
				CLAIMS.CLAIM_TYPE = "HEA" using SQLCA;
		commit;
		ld_claim_hea_amount += ld_amount
		
		if sqlca.sqlcode = 0 then
			/* Get deviation claim amount from claims module */
			SELECT ISNULL(SUM(CLAIMS.CLAIM_AMOUNT_USD),0)
			INTO :ld_amount
			FROM CLAIMS
			WHERE CLAIMS.VESSEL_NR = :ai_vessel_nr AND
					CLAIMS.VOYAGE_NR = :as_voyage_nr AND
					CLAIMS.CHART_NR = :ll_chart_nr AND
					CLAIMS.CLAIM_TYPE = "DEV" using SQLCA;
			commit;
			
			ld_claim_dev_amount += ld_amount
			
			if sqlca.sqlcode = 0 then
			/* Get miscellanous claim amount from claims module */
				SELECT ISNULL(SUM(CLAIMS.CLAIM_AMOUNT_USD),0)
				INTO : ld_amount
				FROM CLAIMS
				WHERE CLAIMS.VESSEL_NR = :ai_vessel_nr AND
						CLAIMS.VOYAGE_NR = :as_voyage_nr AND
						CLAIMS.CHART_NR = :ll_chart_nr AND
						CLAIMS.CLAIM_TYPE  NOT IN ('DEM','HEA','DEV','FRT') using SQLCA ;
				commit;	
				ld_claim_misc_amount += ld_amount
		end if	
		end if
	end if	
	
	/* Fetch the next row */
	ll_previous_chart_nr = ll_chart_nr
	FETCH chart_cursor INTO :ll_chart_nr, :ll_carg_id;

LOOP

/* If an error occurred while retrieving the database */
if sqlca.sqlcode = -1 then
	ls_return_string += "Error while retrieving"
/* if the return string is null */
elseif isnull(ls_return_string) then
	ls_return_string =""
/* if there´s mismatch between the claim amounts */
elseif ld_calc_hea_amount <> ld_claim_hea_amount OR &
	ld_calc_dev_amount <> ld_claim_dev_amount OR & 
	ld_calc_misc_amount <> ld_claim_misc_amount then
	ls_return_string += "Mismatch between claim amount in calculation and operation."& 
							+ "~r~n  Heating claim in calculation: " + string(ld_calc_hea_amount)& 
							+ "~r~n Heating claim in claims module: " + string(ld_claim_hea_amount)& 
							+ "~r~n Deviation claim in calculation: " + string(ld_calc_dev_amount)& 
							+ "~r~n Deviation claim in claims module: " + string(ld_claim_dev_amount)& 
							+ "~r~n Miscellanous claim in calculation: " + string(ld_calc_misc_amount)& 
							+ "~r~n Miscellanous claim in claims module: " + string(ld_claim_misc_amount)& 
							+ "~r~n"
end if

/* Close and destroy objects */
CLOSE chart_cursor;
disconnect using newtransobject;
destroy(newtransobject)

/* Return string*/
return ls_return_string
end function

public function integer uf_check_bunker (integer ai_vessel, datetime adt_departure);decimal {4}		ld_hfo, ld_do, ld_go, ld_lshfo 
 integer			li_voyage_type
 
 SELECT TOP 1 isNull(DEPT_HFO,0), isNull(DEPT_DO,0), isNull(DEPT_GO,0), isNull(DEPT_LSHFO,0), VOYAGES.VOYAGE_TYPE
 	INTO :ld_hfo, :ld_do, :ld_go, :ld_lshfo, :li_voyage_type
	FROM POC,   
		PROCEED,   
		VOYAGES  
	WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR  and  
		PROCEED.VOYAGE_NR = POC.VOYAGE_NR  and  
		PROCEED.PORT_CODE = POC.PORT_CODE  and  
		PROCEED.PCN = POC.PCN  and  
		VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR  and  
		VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR  and  
		POC.PORT_ARR_DT <  :adt_departure and
		POC.VESSEL_NR = :ai_vessel 
	ORDER BY POC.PORT_ARR_DT DESC  ;
	
return 1

end function

public function integer uf_check_poc_arr_dates (long al_vessel, long al_year, ref string as_message);//*************************************************************************************
// This function sets the start and the enddate and passes the function call to overloaded 
//*************************************************************************************
//Development Log 
//DATE				VERSION 		NAME			DESCRIPTION
//-------- 			------- 			----- 			-------------------------------------
//10-01-98			1.0				BO				Initial version  
//05-09-08			16.04				RMO003		ChangeRequest #1333
//************************************************************************************/

datetime ldt_startdate, ldt_enddate

ldt_startdate 	= datetime(date(al_year, 1,1),time(0,0,0))
ldt_enddate 		= datetime(date(al_year+1,1,1),time(0,0,0))

return uf_check_poc_arr_dates( al_vessel, ldt_startdate, ldt_enddate, as_message )
//return uf_check_poc_arr_dates( 890, ldt_startdate, ldt_enddate, as_message )
end function

public function integer uf_check_poc_arr_dates (long al_vessel, datetime adt_startdate, datetime adt_enddate, ref string as_message);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		:
 Object     		: uf_check_poc_arr_dates
 Scope     		: 
 ************************************************************************************
Author    		:  Bettina Olsen
 Date       		: 	19-08-97
 Description 		:	If a port has another port code than the prior port and the port
						has an earlier arrival date than the prior ports departure date, this 
						function gives a warning.
 Arguments 		: 	vessel_nr
 						voyage_nr
 Returns   		: returns a string
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 			------- 			----- 		-------------------------------------
10-01-98			1.0				BO				Initial version  
05-09-08			16.04				RMO003		ChangeRequest #1333
18-03-10			21.11				RMO003		ChangeRequest #1972

************************************************************************************/
/* Declare local variables */
n_ds			lds_portOfCall
string			ls_cr="~r", ls_nl="~n"	
long			ll_number_of_portcalls, ll_row
integer		li_return

lds_portOfCall = create n_ds
lds_portOfCall.dataObject = "d_sq_tb_yearly_voyages_vessel"
lds_portOfCall.setTransObject(sqlca)
lds_portOfCall.retrieve(al_vessel, adt_startdate, adt_enddate)

/* Find out how many port of calls there are in the period */
ll_number_of_portcalls = lds_portOfCall.rowCount()

for ll_row = 2 to ll_number_of_portcalls
	/* Check if port departure date previous is higher than current port arrival date */ 
	if lds_portOfCall.getItemdatetime(ll_row -1, "port_dept_dt") > 	lds_portOfCall.getItemdatetime(ll_row, "port_arr_dt") then
		if lds_portOfCall.getItemdatetime(ll_row -1, "port_arr_dt") = lds_portOfCall.getItemdatetime(ll_row, "port_arr_dt") &
		and lds_portOfCall.getItemString(ll_row -1, "purpose_code") = "DEL" &
		and lds_portOfCall.getItemString(ll_row, "purpose_code") = "DEL" then
			//OK - delivery for both TC-iin and TC-OUT contract at the same time
		elseif lds_portOfCall.getItemdatetime(ll_row -1, "port_arr_dt") = lds_portOfCall.getItemdatetime(ll_row, "port_arr_dt") &
		and lds_portOfCall.getItemString(ll_row -1, "purpose_code") = "RED" &
		and lds_portOfCall.getItemString(ll_row, "purpose_code") = "RED" then
			//OK - re-delivery for both TC-iin and TC-OUT contract at the same time
		else
			as_message += "There is a mismatch in arrival and departure dates for following portcalls:"+ls_cr+ls_nl &
							+ "Voyage: "+lds_portOfCall.getItemString(ll_row -1, "voyage_nr")  &
							+ " Port: "+ lds_portOfCall.getItemString(ll_row -1, "port_code") &
							+ " Arrival: "+string(lds_portOfCall.getItemDatetime(ll_row -1, "port_arr_dt"), "dd/mm-yy hh:mm") &
							+ " Departure: "+string(lds_portOfCall.getItemDatetime(ll_row -1, "port_dept_dt"), "dd/mm-yy hh:mm") +ls_cr+ls_nl &
							+ " and "+ls_cr+ls_nl & 
							+ "Voyage: "+lds_portOfCall.getItemString(ll_row, "voyage_nr")  &
							+ " Port: "+ lds_portOfCall.getItemString(ll_row, "port_code") &
							+ " Arrival: "+string(lds_portOfCall.getItemDatetime(ll_row, "port_arr_dt"), "dd/mm-yy hh:mm") &
							+ " Departure: "+string(lds_portOfCall.getItemDatetime(ll_row, "port_dept_dt"), "dd/mm-yy hh:mm") +ls_cr+ls_nl+ls_cr+ls_nl 
			li_return = -1
		end if
	end if
	/* Check if port arrival date previous is higher than current port arrival date */ 
	if lds_portOfCall.getItemdatetime(ll_row -1, "port_arr_dt") > 	lds_portOfCall.getItemdatetime(ll_row, "port_arr_dt") then
		as_message += "There is a mismatch in previous/current arrival dates for following portcalls:"+ls_cr+ls_nl &
						+ "Voyage: "+lds_portOfCall.getItemString(ll_row -1, "voyage_nr")  &
						+ " Port: "+ lds_portOfCall.getItemString(ll_row -1, "port_code") &
						+ " Arrival: "+string(lds_portOfCall.getItemDatetime(ll_row -1, "port_arr_dt"), "dd/mm-yy hh:mm") &
						+ " Departure: "+string(lds_portOfCall.getItemDatetime(ll_row -1, "port_dept_dt"), "dd/mm-yy hh:mm") +ls_cr+ls_nl &
						+ " and "+ls_cr+ls_nl & 
						+ "Voyage: "+lds_portOfCall.getItemString(ll_row, "voyage_nr")  &
						+ " Port: "+ lds_portOfCall.getItemString(ll_row, "port_code") &
						+ " Arrival: "+string(lds_portOfCall.getItemDatetime(ll_row, "port_arr_dt"), "dd/mm-yy hh:mm") &
						+ " Departure: "+string(lds_portOfCall.getItemDatetime(ll_row, "port_dept_dt"), "dd/mm-yy hh:mm") +ls_cr+ls_nl+ls_cr+ls_nl 
		li_return = -1
	end if
next

destroy lds_portOfCall
return li_return


end function

public function boolean uf_is_first_poc (integer ai_vessel_nr, datetime adt_arrival, string as_voyage);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window     	:
 Object     	: uf_is_first_poc
 Scope     		: 
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 	16-12-97
 Description 	: 	Finds out if a port of call is the first port of call for a 
 						specific vessel.
 Arguments 		: 	vessel nr
 Returns   		: boolean
 						true - first port
						false - not first port
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 			------- 			----- 			-------------------------------------
16-12-97			1.0				BO				Initial version  
09/09-08			16.04				RMO			Change Requset #1334 
************************************************************************************/
/* Declare variables */
integer 	li_number_of_rows
string		ls_found_voyage

/* Count port of calls for the vessel */
SELECT COUNT(POC.PCN)
	INTO :li_number_of_rows
	FROM POC
	WHERE POC.VESSEL_NR = :ai_vessel_nr
	and POC.PORT_ARR_DT < :adt_arrival ;
commit;

if li_number_of_rows > 0 then
	/* This is not the first POC for this vessel */
	return false
else
	/* It could be the first portcall, if the vessel is delivered on a TC-IN contract
		and then goes directly on TC-OUT, there will be two portcalls with the same
		dates, and therefore we need to find out if there are more than one portcall with this date */
	SELECT COUNT(POC.PCN)
		INTO :li_number_of_rows
		FROM POC
		WHERE POC.VESSEL_NR = :ai_vessel_nr
		and POC.PORT_ARR_DT = :adt_arrival
		and POC.VOYAGE_NR <> :as_voyage;
		commit;
	choose case li_number_of_rows
		case 0     // this is the first port
			return true
		case 1	// this is an update to first port or create of a new port with same arrival date
			SELECT POC.VOYAGE_NR
				INTO :ls_found_voyage
				FROM POC
				WHERE POC.VESSEL_NR = :ai_vessel_nr
				and POC.PORT_ARR_DT = :adt_arrival
				and POC.VOYAGE_NR <> :as_voyage;
			commit;						
			
			if len(trim(as_voyage)) = len(trim(ls_found_voyage)) then
				MessageBox("Validation Error", "You can't have a more than one portcall with the same arrival dates on same voyage type")
				return true
			elseif len(trim(as_voyage)) = 5  then
				/* der are two rows, and this one is the first */
				return true
			else
				return false
			end if
		case else
			MessageBox("Validation Error", "There can't be more than 2 portcalls with the same arrival date")
			return true
	end choose	
end if
end function

public function boolean uf_check_bunker (integer ai_vessel_nr, string as_voyage_nr, ref string as_message);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		:
 Object     		: uf_check_bunker
 Scope     		: 
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 	19-08-97
 Description 	: 	Check if the registration of bunker (gas, diesel, fuel, lshfo) is logic,
 						this means that we check if a vessel has more bunker loaded when it
						arrives to a port than it had when if left the last port.
 Arguments 		: 	vessel_nr
 						voyage_nr
 Returns   		: 	Returns a boolean
 											- false if the registered bunker is not logic.
											- true if the data is ok.
*************************************************************************************
Development Log 
DATE				VERSION 	NAME		DESCRIPTION
-------- 			------- 		----- 		-------------------------------------
19-08-97			1.0			BO			Initial version  
19-06-98			1.1			BO			Changed now to contain one more check. The rule
												says that the departure bunker can not be greater
												than arrival + lifted.
09-01-07			14.22			REM		arrival, lifted and departure variable types changed from double to decimal {4}	
19-08-09			20.01			RMO003	Added the parameter as_message to give the ports where the problem is
												(see CR#1348)
************************************************************************************/
/* Declare local variables */
decimal {4} 		ld_arrival_fuel, ld_departure_fuel, ld_arrival_diesel, ld_departure_diesel, ld_arrival_gas, ld_departure_gas, ld_arrival_lshfo, ld_departure_lshfo 
decimal {4}		ld_lifted_fuel, ld_lifted_diesel, ld_lifted_gas, ld_last_hfo , ld_last_do , ld_last_go, ld_lifted_lshfo, ld_last_lshfofo, ld_last_lshfo
integer 		i, li_number_of_poc, li_pcn
string ls_last_voyage, ls_portcode
st_bunker	bunker
transaction 	sqlfrt

/* Create transaction object */
uo_global.defaulttransactionobject(sqlfrt)
connect using sqlfrt;


/* Declare cursor */
DECLARE bunker_cursor CURSOR FOR 
SELECT isnull( POC.ARR_HFO,0),
	isnull(POC.DEPT_HFO,0),
	isnull(POC.ARR_DO,0),
	isnull(POC.DEPT_DO,0),
	isnull(POC.ARR_GO,0),
	isnull(POC.DEPT_GO,0),
	isnull( POC.ARR_LSHFO,0),
	isnull(POC.DEPT_LSHFO,0),
	isnull(POC.LIFT_HFO,0),
	isnull(POC.LIFT_DO,0),
	isnull(POC.LIFT_GO,0),
	isnull(POC.LIFT_LSHFO,0),
	POC.PORT_CODE,
	POC.PCN
FROM  POC 
WHERE POC.VESSEL_NR = :ai_vessel_nr 
AND POC.VOYAGE_NR = :as_voyage_nr 
ORDER BY POC.PORT_ARR_DT ASC, POC.ARR_HFO DESC using sqlfrt;

/* Open cursor */
OPEN bunker_cursor;

/* Fetch */
FETCH bunker_cursor into :ld_arrival_fuel, :ld_departure_fuel, :ld_arrival_diesel, :ld_departure_diesel, :ld_arrival_gas, :ld_departure_gas, :ld_arrival_lshfo, :ld_departure_lshfo, :ld_lifted_fuel, :ld_lifted_diesel, :ld_lifted_gas, :ld_lifted_lshfo, :ls_portcode, :li_pcn;

DO WHILE sqlfrt.sqlcode = 0
	i++		
	bunker.arrival_fuel[i]			= ld_arrival_fuel
	bunker.departure_fuel[i]	 	= ld_departure_fuel
	bunker.arrival_diesel[i] 		= ld_arrival_diesel
	bunker.departure_diesel[i] 	= ld_departure_diesel
	bunker.arrival_gas[i] 			= ld_arrival_gas
	bunker.departure_gas[i] 	= ld_departure_gas
	bunker.arrival_lshfo[i] 		= ld_arrival_lshfo
	bunker.departure_lshfo[i] 	= ld_departure_lshfo
	bunker.lifted_fuel[i]			= ld_lifted_fuel
	bunker.lifted_diesel[i]			= ld_lifted_diesel
	bunker.lifted_gas[i]			= ld_lifted_gas
	bunker.lifted_lshfo[i]			= ld_lifted_lshfo
	bunker.port_code[i]			= ls_portcode
	bunker.pcn[i]					= li_pcn
	
	FETCH bunker_cursor into :ld_arrival_fuel, :ld_departure_fuel, :ld_arrival_diesel, :ld_departure_diesel, :ld_arrival_gas, :ld_departure_gas, :ld_arrival_lshfo, :ld_departure_lshfo, :ld_lifted_fuel, :ld_lifted_diesel, :ld_lifted_gas, :ld_lifted_lshfo, :ls_portcode, :li_pcn;
LOOP

/* Finds out how many port of calls there are on the voyage */
li_number_of_poc = upperbound(bunker.arrival_fuel)

if li_number_of_poc = 0 then return true

/* Make check */
for i = 2 to li_number_of_poc
	if 	bunker.departure_fuel[i - 1]	< 	bunker.arrival_fuel[i] or &
		bunker.departure_diesel[i - 1] <	bunker.arrival_diesel[i] or &
		bunker.departure_gas[i - 1] 	<	bunker.arrival_gas[i] or &
		bunker.departure_lshfo[i - 1] 	<	bunker.arrival_lshfo[i] then
		CLOSE bunker_cursor;
		disconnect using sqlfrt;
		destroy sqlfrt;
		as_message = "Arrival bunker in port '"+bunker.port_code[i]+"' is higher than the departure from previous port '"+bunker.port_code[i -1]+"'."
		return false
	end if
next

/* New check */
for i = 1 to li_number_of_poc
	if ((bunker.arrival_fuel[i] + bunker.lifted_fuel[i]) < bunker.departure_fuel[i]) or &
		((bunker.arrival_diesel[i] + bunker.lifted_diesel[i]) < bunker.departure_diesel[i]) or &
		((bunker.arrival_gas[i] + bunker.lifted_gas[i]) < bunker.departure_gas[i]) or &
		((bunker.arrival_lshfo[i] + bunker.lifted_lshfo[i]) < bunker.departure_lshfo[i]) then
		CLOSE bunker_cursor;
		disconnect using sqlfrt;
		destroy sqlfrt;
		as_message = "Arrival + Lifted bunker in port '"+bunker.port_code[i]+"' is lower than the departure."
		return false
	end if
next

/* Close and destroy objects */
CLOSE bunker_cursor;
disconnect using sqlfrt;
destroy sqlfrt;

// Make check against last departure on previous voyage
SELECT MAX(VOYAGE_NR)
INTO :ls_last_voyage
FROM VOYAGES
WHERE VOYAGES.VESSEL_NR = :ai_vessel_nr 
	AND VOYAGES.VOYAGE_NR < :as_voyage_nr;


IF LEN(ls_last_voyage) > 0 THEN
	SELECT isnull(POC.DEPT_HFO,0), isnull(POC.DEPT_DO,0), isnull(POC.DEPT_GO,0), isnull(POC.DEPT_LSHFO,0)
	INTO :ld_last_hfo , :ld_last_do , :ld_last_go, :ld_last_lshfo
	FROM POC
	WHERE POC.VESSEL_NR = :ai_vessel_nr AND
			POC.VOYAGE_NR = :ls_last_voyage  AND
		   POC.PORT_ARR_DT = (SELECT MAX(POC.PORT_ARR_DT)
								   FROM POC
								   WHERE POC.VESSEL_NR = :ai_vessel_nr AND
								         POC.VOYAGE_NR = :ls_last_voyage) ;						
	IF ld_last_hfo < bunker.arrival_fuel[1] OR ld_last_do <  bunker.arrival_diesel[1]  &
	OR ld_last_go	< bunker.arrival_gas[1] OR ld_last_lshfo <  bunker.arrival_lshfo[1] THEN 
		as_message = "Arrival bunker in port '"+bunker.port_code[1]+"' is higher than last departure previous voyage."
		Return FALSE						
	END IF
								
END IF

return true
end function

public function integer of_check_portbunker (ref mt_u_datawindow adw_poc, ref string as_setcol, ref string as_message);/********************************************************************
   of_check_portbunker
   <DESC> check bunker data when updatting act poc in w_port_of_call	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		as_setcol
		as_message
   </ARGS>
   <USAGE> 	Called in w_port_of_call.cb_updateact.clicked()	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/09/2013 CR2516       LGX001        First Version
   </HISTORY>
********************************************************************/
integer 			li_vesselnr
string 			ls_pre_voyage, ls_next_voyage, ls_pre_port, ls_next_port, ls_portcode, ls_voyagenr
datetime 		ldt_arrival_date
decimal {4} 	ld_arr_hfo, ld_arr_do, ld_arr_go, ld_arr_lshfo
decimal {4} 	ld_dept_hfo, ld_dept_do, ld_dept_go, ld_dept_lshfo

if adw_poc.rowcount() < 1 then return c#return.Success

li_vesselnr = adw_poc.getitemnumber(1, "vessel_nr")
ls_voyagenr = adw_poc.getitemstring(1, "voyage_nr")
ls_portcode = adw_poc.getitemstring(1, "port_code")
ldt_arrival_date = adw_poc.getitemdatetime(1, "PORT_ARR_DT", primary!, true)

//Get previous port bunker data 
SELECT isnull(POC.DEPT_HFO,0),
	isnull(POC.DEPT_DO,0),
	isnull(POC.DEPT_GO,0),
	isnull(POC.DEPT_LSHFO,0),
	POC.VOYAGE_NR,
	POC.PORT_CODE	
INTO :ld_dept_hfo, 
	  :ld_dept_do, 
	  :ld_dept_go, 
	  :ld_dept_lshfo,
	  :ls_pre_voyage,
	  :ls_pre_port
FROM  POC 
WHERE POC.VESSEL_NR = :li_vesselnr 
AND POC.VOYAGE_NR   <= :ls_voyagenr
AND POC.PORT_ARR_DT = (SELECT MAX(POC.PORT_ARR_DT)
								FROM POC
								WHERE POC.VESSEL_NR = :li_vesselnr AND
								      POC.VOYAGE_NR <= :ls_voyagenr AND
										DATEDIFF(Second, POC.PORT_ARR_DT, :ldt_arrival_date) > 0);
if sqlca.sqlcode < 0 then
	as_message = "Select bunker data error: " + sqlca.sqlerrtext
	return c#return.Failure
end if

//Get next port bunker data 
SELECT isnull( POC.ARR_HFO,0),
	isnull(POC.ARR_DO,0),
	isnull(POC.ARR_GO,0),
	isnull(POC.ARR_LSHFO,0),
	POC.VOYAGE_NR,
	POC.PORT_CODE
INTO :ld_arr_hfo, 
	  :ld_arr_do, 
	  :ld_arr_go, 
	  :ld_arr_lshfo, 
	  :ls_next_voyage,
	  :ls_next_port	  
FROM  POC 
WHERE POC.VESSEL_NR = :li_vesselnr 
AND POC.VOYAGE_NR  >= :ls_voyagenr
AND POC.PORT_ARR_DT = (SELECT MIN(POC.PORT_ARR_DT)
								FROM POC
								WHERE POC.VESSEL_NR = :li_vesselnr AND
								      POC.VOYAGE_NR >= :ls_voyagenr AND
										DATEDIFF(Second, POC.PORT_ARR_DT, :ldt_arrival_date) < 0);
if sqlca.sqlcode < 0 then
	as_message = "Select bunker data error: " + sqlca.sqlerrtext
	return c#return.Failure
end if

if of_check_portbunker(adw_poc, "HFO", ld_arr_hfo, ld_dept_hfo, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port, as_setcol, as_message) = c#return.Failure then return c#return.Failure
if of_check_portbunker(adw_poc, "DO",  ld_arr_do,  ld_dept_do, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port,  as_setcol, as_message) = c#return.Failure then return c#return.Failure
if of_check_portbunker(adw_poc, "GO", 	ld_arr_go, 	ld_dept_go, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port,  as_setcol, as_message) = c#return.Failure then return c#return.Failure
if of_check_portbunker(adw_poc, "LSHFO", ld_arr_lshfo, ld_dept_lshfo, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port, as_setcol, as_message) = c#return.Failure then return c#return.Failure

return c#return.Success


end function

public function integer of_check_portbunker (ref mt_u_datawindow adw_poc, string as_bunker_type, decimal ad_arr_bunker, decimal ad_dept_bunker, string as_pre_voyage, string as_pre_port, string as_next_voyage, string as_next_port, ref string as_setcol, ref string as_message);/********************************************************************
   of_check_portbunker
   <DESC>check bunker data when updatting act poc in w_port_of_call	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		as_bunker_type
		ad_arr_bunker
		ad_dept_bunker
		as_pre_voyage
		as_pre_port
		as_next_voyage
		as_next_port
		as_setcol
		as_message
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/09/2013 CR2516        LGX001        First Version
	06/02/2015	CR3752		CCY018		  Add a period(.) at the end of the sentence
   </HISTORY>
********************************************************************/

decimal {4}		ld_curr_arrival, ld_curr_departure, ld_curr_lifted
decimal {4}		ld_org_departure
integer 			li_vesselnr
string ls_arr_col, ls_dept_col, ls_lift_col, ls_portcode, ls_voyagenr

if adw_poc.rowcount() < 1 then return c#return.Success

ls_portcode = adw_poc.getitemstring(1, "port_code")

ls_arr_col  = "ARR_"  + as_bunker_type
ls_lift_col = "LIFT_" + as_bunker_type
ls_dept_col = "DEPT_" + as_bunker_type

ls_voyagenr       = adw_poc.getitemstring(1, "voyage_nr")
ls_portcode			= adw_poc.getitemstring(1, "port_code")

ld_curr_arrival   = adw_poc.getitemdecimal(1, ls_arr_col)
ld_curr_lifted		= adw_poc.getitemdecimal(1, ls_lift_col)
ld_curr_departure	= adw_poc.getitemdecimal(1, ls_dept_col)

if isnull(ld_curr_arrival)   then ld_curr_arrival = 0
if isnull(ld_curr_lifted)    then ld_curr_lifted = 0
if isnull(ld_curr_departure) then ld_curr_departure = 0

ld_org_departure = adw_poc.getitemdecimal(1, ls_dept_col, primary!, true)
if isnull(ld_org_departure) then ld_org_departure = 0
if (ld_curr_arrival + ld_curr_lifted) < ld_curr_departure then
	as_setcol = ls_arr_col
	if ld_curr_departure <> ld_org_departure then
		as_setcol = ls_dept_col
	end if 	
	 as_message = "Arrival + Lifted bunker in port '" + ls_portcode + "' is lower than the departure."
	 return c#return.Failure
end if

// Previous port departure bunker data 
if (len(as_pre_voyage) > 0) and (ad_dept_bunker < ld_curr_arrival) then
	as_setcol = ls_arr_col
	if as_pre_voyage = ls_voyagenr then
		as_message = "Arrival bunker in port '" + ls_portcode + "' is higher than the departure from previous port '" + as_pre_port + "'."
	else
		as_message = "Arrival bunker in port '" + ls_portcode + "' is higher than last departure from previous voyage."
	end if
	
	return c#return.Failure
	
// Next port arrival bunker data 	
elseif (len(as_next_voyage) > 0 )and (ad_arr_bunker > ld_curr_departure) then
	as_setcol = ls_dept_col
	if as_next_voyage = ls_voyagenr then
		as_message = "Departure bunker in port '" + ls_portcode + "' is higher than the arrival from next port '" + as_next_port + "'."
	else
		as_message = "Departure bunker in port '" + ls_portcode + "' is higher than first arrival from next voyage."
	end if
	
	return c#return.Failure
end if	

return c#return.Success
end function

public function integer of_check_idledays (long al_vesselnr, string as_voyagenr);uo_datawindow ldw_idledays

setnull(ldw_idledays)

return of_check_idledays(al_vesselnr, as_voyagenr, ldw_idledays, 0)
end function

public function integer of_check_idledays (long al_vesselnr, string as_voyagenr, uo_datawindow adw_idledays, integer ai_flag);/********************************************************************
   of_check_idledays
   <DESC> Check Idle Days period.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vesselnr
		as_voyagenr
		adw_idledays
		ai_flag:0 Validate idle days period when finish voyage from poc window.
			     1 Validate idle days period when update idle days from idle days window.
   </ARGS>
   <USAGE> 	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/03/16		CR3099		XSZ004		First Version
   </HISTORY>
********************************************************************/

integer li_ret = c#return.success

if ai_flag = 1 then
	li_ret = of_check_idledaysoverlap(al_vesselnr, adw_idledays)
end if

if li_ret = c#return.success then
	li_ret = of_check_idledaysperiod(al_vesselnr, as_voyagenr, adw_idledays, ai_flag)
end if

return li_ret

end function

public function integer of_check_idledaysoverlap (long al_vesselnr, uo_datawindow adw_idledays);/********************************************************************
   of_checkidledaysoverlap
   <DESC> Check Idle Days period.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vesselnr
		adw_idledays
   </ARGS>
   <USAGE> 	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/03/16		CR3099		XSZ004		First Version
   </HISTORY>
********************************************************************/

long     ll_findrow, ll_errorrow, ll_rowcount
integer  li_ret = c#return.success
string   ls_findcondition, ls_error, ls_msg, ls_column, ls_currvoyagenr ,ls_prevoyagenr, ls_portname, ls_portcode, ls_space
datetime ldt_idlestart, ldt_idleend, ldt_voyagestart, ldt_voyageend
boolean  lb_idlestart_overlap, lb_idleend_overlap, lb_idledays_overlap, lb_differentvoy

mt_n_datastore lds_idledays
n_voyage lnv_voyage

lnv_voyage = create n_voyage

ll_rowcount = adw_idledays.rowcount()
	
do 	
	ll_findrow = adw_idledays.find("isRowNew() or isRowModified()", ll_findrow + 1, ll_rowcount + 1)
	
	if ll_findrow > 0 then
		
		ls_currvoyagenr = adw_idledays.getitemstring(ll_findrow, "voyage_nr")
		
		if ls_currvoyagenr <> ls_prevoyagenr then		
			lb_differentvoy  = true
			ls_prevoyagenr = ls_currvoyagenr
			lnv_voyage.of_get_pocvoyagestartend(al_vesselnr, ls_prevoyagenr, ldt_voyagestart, ldt_voyageend)
			
			if len(ls_prevoyagenr) < 7 then
				ls_space = "         "
			else
				ls_space = "             "
			end if
		end if	
		
		ldt_idlestart = adw_idledays.getitemdatetime(ll_findrow, "idle_start")
		ldt_idleend   = adw_idledays.getitemdatetime(ll_findrow, "idle_end")
		ls_portcode   = adw_idledays.getitemstring(ll_findrow, "port_code")
		ls_portname   = of_get_portname(ls_portcode)
		
		ls_findcondition     = "idle_start <= datetime('" + string(ldt_idlestart) + "')" + " and datetime('" + string(ldt_idlestart) + "') < idle_end and getrow() <> " + string(ll_findrow)
		lb_idlestart_overlap = (adw_idledays.find(ls_findcondition, 1, ll_rowcount) > 0)
		
		ls_findcondition   =  "idle_start < datetime('" + string(ldt_idleend) + "')" + " and datetime('" + string(ldt_idleend) + "') <= idle_end and getrow() <> " + string(ll_findrow)
		lb_idleend_overlap = (adw_idledays.find(ls_findcondition, 1, ll_rowcount) > 0)
		
		ls_findcondition = "(idle_start > datetime('" + string(ldt_idlestart) + "')" + " and datetime('" + string(ldt_idleend) + "') > idle_end) and getrow() <> " + string(ll_findrow)
		lb_idledays_overlap = (adw_idledays.find(ls_findcondition, 1, ll_rowcount) > 0)
		
		if lb_idlestart_overlap or lb_idleend_overlap or lb_idledays_overlap then
			
			ls_msg = "~nPort " + ls_portcode + " (" + ls_portname + ")~nIdle days " + ls_space + &
				      string(ldt_idlestart, "dd-mm-yy hh:mm") + " - " + string(ldt_idleend, "dd-mm-yy hh:mm") + "~n"
				
			if lb_differentvoy then
				ls_msg = "~nVoyage " + ls_prevoyagenr + " " + string(ldt_voyagestart, "dd-mm-yy hh:mm") + " - " + string(ldt_voyageend, "dd-mm-yy hh:mm") + "~n" + ls_msg
				lb_differentvoy = false	
			end if
			
			ls_error += ls_msg
			
			if ll_errorrow < 1 then 
			
				ll_errorrow = ll_findrow
				
				if lb_idlestart_overlap or lb_idledays_overlap then
					ls_column = "idle_start"
				else
					ls_column = "idle_end"
				end if			
			end if
		end if	
	end if	
loop while ll_findrow > 0

if ls_error <> "" then
	ls_error = "You have entered an idle period that overlaps with other idle period(s). You need to correct it.~n" + ls_error
	messagebox("Idle period overlapped", ls_error, stopsign!)
		
	adw_idledays.setfocus()
	adw_idledays.setcolumn(ls_column)
	adw_idledays.scrolltorow(ll_errorrow)
	adw_idledays.selectrow(0, false)
	adw_idledays.selectrow(ll_errorrow, true)
	
	li_ret = c#return.failure
end if

destroy lnv_voyage

return li_ret

end function

public function integer of_check_idledaysperiod (long al_vesselnr, string as_voyagenr, uo_datawindow adw_idledays, integer ai_flag);/********************************************************************
   of_check_idledaysperiod
   <DESC> Check Idle Days period.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vesselnr
		as_voyagenr
		adw_idledays
		ai_flag:0 Validate idle days period when finish voyage.
			     1 Validate idle days period when update idle days.
   </ARGS>
   <USAGE> 	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/03/16		CR3099		XSZ004		First Version
   </HISTORY>
********************************************************************/

long     ll_findrow, ll_errorrow, ll_row, ll_rowcount
integer  li_voyage_finished, li_ret = c#return.success
string   ls_findcondition, ls_errormsg, ls_msg, ls_warnmsg, ls_column, ls_currvoyagenr, ls_prevoyagenr, ls_portcode, ls_portname, ls_space
datetime ldt_idlestart, ldt_idleend, ldt_voyagestart, ldt_voyageend
boolean  lb_idlestart_outside, lb_idleend_outside, lb_differentvoy

mt_n_datastore lds_idledays
n_voyage lnv_voyage

lnv_voyage = create n_voyage

if ai_flag = 1 then //Validate idle days period when update idle days from idle days window.
	
	ll_rowcount = adw_idledays.rowcount()
	
	do 	
		ll_findrow = adw_idledays.find("isRowNew() or isRowModified()", ll_findrow + 1, ll_rowcount + 1)
		
		if ll_findrow > 0 then
			
			ls_currvoyagenr = adw_idledays.getitemstring(ll_findrow, "voyage_nr")
			
			if ls_currvoyagenr <> ls_prevoyagenr then
				
				lb_differentvoy  = true
				ls_prevoyagenr = ls_currvoyagenr
				
				SELECT VOYAGE_FINISHED INTO :li_voyage_finished FROM VOYAGES WHERE VESSEL_NR = :al_vesselnr AND VOYAGE_NR = :ls_prevoyagenr;
				
				lnv_voyage.of_get_pocvoyagestartend(al_vesselnr, ls_prevoyagenr, ldt_voyagestart, ldt_voyageend)
				
				if len(ls_prevoyagenr) < 7 then
					ls_space = "         "
				else
					ls_space = "             "
				end if
			end if	
		
			if not isnull(ldt_voyageend) then
				
				ldt_idlestart = adw_idledays.getitemdatetime(ll_findrow, "idle_start")
				ldt_idleend   = adw_idledays.getitemdatetime(ll_findrow, "idle_end")
				ls_portcode   = adw_idledays.getitemstring(ll_findrow, "port_code")
				ls_portname   = of_get_portname(ls_portcode)
				
				lb_idlestart_outside = not (ldt_idlestart >= ldt_voyagestart and ldt_idlestart <= ldt_voyageend)
				lb_idleend_outside   = not (ldt_idleend >= ldt_voyagestart and ldt_idleend <= ldt_voyageend)
				
				if lb_idlestart_outside or lb_idleend_outside then
					
					ls_msg = "~nPort " + ls_portcode + " (" + ls_portname + ")~nIdle days " + ls_space + &
								string(ldt_idlestart, "dd-mm-yy hh:mm") + " - " + string(ldt_idleend, "dd-mm-yy hh:mm") + "~n"
					
					if lb_differentvoy then
						ls_msg = "~nVoyage " + ls_prevoyagenr + " " + string(ldt_voyagestart, "dd-mm-yy hh:mm") + " - " + string(ldt_voyageend, "dd-mm-yy hh:mm") + "~n" + ls_msg
						lb_differentvoy = false
					end if
					
					if li_voyage_finished = 1 then
						
						if ll_errorrow < 1 then 
						
							ll_errorrow = ll_findrow
							
							if lb_idlestart_outside then
								ls_column = "idle_start"
							else
								ls_column = "idle_end"
							end if			
						end if
						
						ls_errormsg += ls_msg
					else
						ls_warnmsg += ls_msg
					end if
				end if	
			end if		
		end if	
	loop while ll_findrow > 0
	
else//Validate idle days period when finish voyage from poc window.

	lds_idledays = create mt_n_datastore
	lds_idledays.dataobject = "d_sq_gr_idledaysoutsidevoy"
	lds_idledays.settransobject(sqlca)
	
	lnv_voyage.of_get_pocvoyagestartend(al_vesselnr, as_voyagenr, ldt_voyagestart, ldt_voyageend)
	
	lds_idledays.retrieve(al_vesselnr, as_voyagenr, ldt_voyagestart, ldt_voyageend)
	
	ll_rowcount = lds_idledays.rowcount()
	
	if len(as_voyagenr) < 7 then
		ls_space = "         "
	else
		ls_space = "             "
	end if
	
	for ll_row = 1 to ll_rowcount
		ldt_idlestart = lds_idledays.getitemdatetime(ll_row, "idle_start")
		ldt_idleend   = lds_idledays.getitemdatetime(ll_row, "idle_end")
		ls_portcode   = lds_idledays.getitemstring(ll_row, "port_code")
		ls_portname   = of_get_portname(ls_portcode)
		
		ls_errormsg += "~nPort " + ls_portcode + " (" + ls_portname + ")~nIdle days " + ls_space + &
							string(ldt_idlestart, "dd-mm-yy hh:mm") + " - " + string(ldt_idleend, "dd-mm-yy hh:mm") + "~n"				
	next
	
	if ls_errormsg <> "" then
		ls_errormsg = "Voyage " + as_voyagenr + " " + string(ldt_voyagestart, "dd-mm-yy hh:mm") + " - " + string(ldt_voyageend, "dd-mm-yy hh:mm") + "~n" + ls_errormsg
	end if
	
	destroy lds_idledays
end if
	
if ls_errormsg <> "" then
	if ai_flag = 1 then
		ls_errormsg = "You have entered an idle period that is not within the voyage start and end dates. This might result in wrong VAS results. You need to correct the idle period.~n" + ls_errormsg
	
		adw_idledays.setfocus()
		adw_idledays.setcolumn(ls_column)
		adw_idledays.scrolltorow(ll_errorrow)
		adw_idledays.selectrow(0, false)
		adw_idledays.selectrow(ll_errorrow, true)
	else
		ls_errormsg = "There is an idle period that is not within the voyage start and end dates. This might result in wrong VAS results. You need to correct the idle period before you can finish the voyage. ~n~n" + ls_errormsg
	end if
	
	messagebox("Idle days outside voyage period", ls_errormsg, stopsign!)
	
	li_ret = c#return.failure
	
elseif ls_warnmsg <> "" then
	ls_warnmsg = "You have entered an idle period that is not within the voyage start and end dates. This might result in wrong VAS results. ~n" + ls_warnmsg
	messagebox("Idle days outside voyage period", ls_warnmsg, exclamation!)
	li_ret = c#return.success
end if

destroy lnv_voyage

return li_ret

end function

public function string of_get_portname (string as_portcode);/********************************************************************
   of_get_portname
   <DESC> Get port name.</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_portcode
   </ARGS>
   <USAGE> 	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/03/16		CR3099		XSZ004		First Version
   </HISTORY>
********************************************************************/

String ls_portname

select PORT_N INTO :ls_portname FROM PORTS WHERE PORT_CODE = :as_portcode;

return ls_portname
end function

on u_check_functions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_check_functions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

