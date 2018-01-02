$PBExportHeader$u_compute_support.sru
$PBExportComments$Retrives rows from the Datawarehouse and computes support from these.
forward
global type u_compute_support from nonvisualobject
end type
end forward

global type u_compute_support from nonvisualobject
end type
global u_compute_support u_compute_support

forward prototypes
public function string uf_compute_support (string as_contract_type, string as_cerp_id, string as_chart_nr, string as_chgp, string as_cerp_date, string as_vv_nr, string as_formula, string as_act_or_est)
public function string uf_construct_where_clause (string as_select_list, string as_column, character as_pling)
public function string uf_construct_where_clause_vv (string as_select_list, character as_pling)
end prototypes

public function string uf_compute_support (string as_contract_type, string as_cerp_id, string as_chart_nr, string as_chgp, string as_cerp_date, string as_vv_nr, string as_formula, string as_act_or_est);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :
  
 Object     :  User Object Function uf_compute_support
  
 Event	 :

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 12-08-96

 Description : 	Takes 6 selection criterias and makes a dynamic SQL-select i the Datawarehouse according to these.
			For all selected rows the data-columns are summarized into local variables.
			The values of these local sum-variables are substituted into the Support Definition formula-string, and 
			the string with these values are returned to the calling window, which just have to pass the string 
			through an "evaluation"-function, to get the result of dynamical the retrieval and calculation according 
			to the Support Definition.

 Arguments :	as_contract_type	: Contract-type for use in the selection criteria in the DataWarehouse
			as_cerp_id		: Certeparti-Id for use in the selection criteria in the DataWarehouse
			as_chart_nr		: Charterer-number for use in the selection criteria in the DataWarehouse
			as_chgp			: Charterer-group for use in the selection criteria in the DataWarehouse
			as_cerp_date		: Certeparti-Date for use in the selection criteria in the DataWarehouse
			as_vv_nr			: Vessel and Voyage-No for use in the selection criteria in the DataWarehouse
			as_formula		: Definition of how the retrieved information is to be calculated
			as_act_or_est		: Indication - retrieval and calculation of "actual" or "estimated" figures,
							  i.e. figures from TRAMOS or figures from CALCULE

 Returns   :	An expression in a string which can be evaluated i the calling window

 Variables : 	

 Other : 		There are no check for valid syntax, it HAS been done before this !

*************************************************************************************

Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
12-08-96		1.0			KHK		Initial version
************************************************************************************/

//////////////////////////////////////// Local variables
String 	ls_contract_type, ls_cal_cerp_id, ls_charterer_shortname, ls_charterer_group, ls_cerp_date
String	ls_vv_nr, ls_voyage_nr
String	ls_where_clause, ls_formula, ls_sql_statement, ls_formula_with_vars, ls_tmpstr1, ls_tmpstr2
String	ls_tmpstr3, ls_tmpstr4
Long	ll_dw_serial,li_contract_type,ll_cal_cerp_id,ll_vessel_nr,ll_result
Date 	ld_cp_date
Char		lc_ch, lc_pling, lc_no_pling
Integer	li_counter

////////////////////////////////////////// Local variables for use with summarization of columns i Datawarehouse
Long 	ll_no_voyages_est,ll_no_voyages_act,ll_no_ton_est,ll_no_ton_act,ll_gross_hire_est,ll_gross_hire_act,ll_demurrage_est,ll_demurrage_act,ll_despatch_est,ll_despatch_act,ll_comission_est,ll_comission_act,ll_bunkers_est,ll_bunkers_act,ll_port_est,ll_port_act,ll_misc_est,ll_misc_act,ll_off_hire_est,ll_off_hire_act,ll_off_days_est,ll_off_days_act,ll_idle_days_est,ll_idle_days_act,ll_grossdays_est,ll_grossdays_act
Long 	ll_no_voyages_est_sum,ll_no_voyages_act_sum,ll_no_ton_est_sum,ll_no_ton_act_sum,ll_gross_hire_est_sum,ll_gross_hire_act_sum,ll_demurrage_est_sum,ll_demurrage_act_sum,ll_despatch_est_sum,ll_despatch_act_sum,ll_comission_est_sum,ll_comission_act_sum,ll_bunkers_est_sum,ll_bunkers_act_sum,ll_port_est_sum,ll_port_act_sum,ll_misc_est_sum,ll_misc_act_sum,ll_off_hire_est_sum,ll_off_hire_act_sum,ll_off_days_est_sum,ll_off_days_act_sum,ll_idle_days_est_sum,ll_idle_days_act_sum,ll_grossdays_est_sum,ll_grossdays_act_sum

////////////////////////////////////////// Call of uf_construct_where_clause for each user-setup retrieval-argument
lc_pling = "'"
lc_no_pling = ""

ls_contract_type = "(" + uf_construct_where_clause(as_contract_type,"CONTRACT_TYPE",lc_no_pling) + ")"
ls_cal_cerp_id = "(" + uf_construct_where_clause(as_cerp_id,"CAL_CERP_ID",lc_no_pling) + ")"
ls_charterer_shortname = "(" + uf_construct_where_clause(as_chart_nr,"CHARTERER_SHORTNAME",lc_pling) + ")"
ls_charterer_group = "(" + uf_construct_where_clause(as_chgp,"CHARTERER_GROUP",lc_pling) + ")"
ls_cerp_date = "(" + uf_construct_where_clause(as_cerp_date,"CP_DATE",lc_pling) + ")"
ls_vv_nr = "(" + uf_construct_where_clause_vv(as_vv_nr,lc_pling) + ")"	// For the combination of VESSEL and VOYAGE

////////////////////////////////////////// Concat the constructed where-clauses with AND's
IF ls_contract_type <> "()" THEN ls_where_clause = ls_contract_type + " AND "
IF ls_cal_cerp_id <> "()" THEN ls_where_clause = ls_where_clause + ls_cal_cerp_id + " AND "
IF ls_charterer_shortname <> "()" THEN ls_where_clause = ls_where_clause + ls_charterer_shortname + " AND "
IF ls_charterer_group <> "()" THEN ls_where_clause = ls_where_clause + ls_charterer_group + " AND " 
IF ls_cerp_date <> "()" THEN ls_where_clause = ls_where_clause + ls_cerp_date + " AND " 
IF ls_vv_nr <> "()" THEN ls_where_clause = ls_where_clause + ls_vv_nr + " AND " 
ls_where_clause = ls_where_clause + " 1 = 1"	//dummy-statement added to prevent problems with an ending "AND"

////////////////////////////////////////// Construct the SQL-statement with all the where-clauses
IF ls_where_clause > "" THEN
	ls_sql_statement = "SELECT * FROM CCS_DATAWAREHOUSE WHERE " + ls_where_clause
ELSE						
	ls_sql_statement = "SELECT * FROM CCS_DATAWAREHOUSE"
END IF

////////////////////////////////////////// Declare a cursor for which the data-columns of all rows are summarized in local variables.
////////////////////////////////////////// It is because the SQL-statement is dynamical, it is nescesary to use a cursor and a 
////////////////////////////////////////// PREPARE-statement
ls_sql_statement = ls_sql_statement + " for read only"
DECLARE my_cursor DYNAMIC CURSOR FOR SQLSA;
PREPARE SQLSA FROM :ls_sql_statement;
OPEN DYNAMIC my_cursor;

FETCH my_cursor INTO :ll_dw_serial,:li_contract_type,:ll_cal_cerp_id,:ls_charterer_shortname,:ls_charterer_group,:ld_cp_date,:ll_vessel_nr,:ls_voyage_nr,:ll_no_voyages_est_sum,:ll_no_voyages_act_sum,:ll_no_ton_est_sum,:ll_no_ton_act_sum,:ll_gross_hire_est_sum,:ll_gross_hire_act_sum,:ll_demurrage_est_sum,:ll_demurrage_act_sum,:ll_despatch_est_sum,:ll_despatch_act_sum,:ll_comission_est_sum,:ll_comission_act_sum,:ll_bunkers_est_sum,:ll_bunkers_act_sum,:ll_port_est_sum,:ll_port_act_sum,:ll_misc_est_sum,:ll_misc_act_sum,:ll_off_hire_est_sum,:ll_off_hire_act_sum,:ll_off_days_est_sum,:ll_off_days_act_sum,:ll_idle_days_est_sum,:ll_idle_days_act_sum,:ll_grossdays_est_sum,:ll_grossdays_act_sum;

IF SQLCA.SQLCode = 0 THEN

	DO WHILE SQLCA.SQLCode = 0
		ll_no_voyages_est_sum = ll_no_voyages_est_sum + ll_no_voyages_est
		ll_no_voyages_act_sum = ll_no_voyages_act_sum + ll_no_voyages_act
		ll_no_ton_est_sum = ll_no_ton_est_sum + ll_no_ton_est
		ll_no_ton_act_sum = ll_no_ton_act_sum + ll_no_ton_act
		ll_gross_hire_est_sum = ll_gross_hire_est_sum + ll_gross_hire_est
		ll_gross_hire_act_sum = ll_gross_hire_act_sum + ll_gross_hire_act
		ll_demurrage_est_sum = ll_demurrage_est_sum + ll_demurrage_est
		ll_demurrage_act_sum = ll_demurrage_act_sum + ll_demurrage_act
		ll_despatch_est_sum = ll_despatch_est_sum + ll_despatch_est 
		ll_despatch_act_sum = ll_despatch_act_sum + ll_despatch_act
		ll_comission_est_sum = ll_comission_est_sum + ll_comission_est 
		ll_comission_act_sum = ll_comission_act_sum + ll_comission_act 
		ll_bunkers_est_sum = ll_bunkers_est_sum + ll_bunkers_est
		ll_bunkers_act_sum = ll_bunkers_act_sum + ll_bunkers_act 
		ll_port_est_sum = ll_port_est_sum + ll_port_est
		ll_port_act_sum = ll_port_act_sum + ll_port_act 
		ll_misc_est_sum = ll_misc_est_sum + ll_misc_est
		ll_misc_act_sum = ll_misc_act_sum + ll_misc_act 
		ll_off_hire_est_sum = ll_off_hire_est_sum + ll_off_hire_est
		ll_off_hire_act_sum = ll_off_hire_act_sum + ll_off_hire_act
		ll_off_days_est_sum = ll_off_days_est_sum + ll_off_days_est
		ll_off_days_act_sum = ll_off_days_act_sum + ll_off_days_act 
		ll_idle_days_est_sum = ll_idle_days_est_sum + ll_idle_days_est 
		ll_idle_days_act_sum = ll_idle_days_act_sum + ll_idle_days_act 
		ll_grossdays_est_sum = ll_grossdays_est_sum + ll_grossdays_est
		ll_grossdays_act_sum = ll_grossdays_act_sum + ll_grossdays_act 

		FETCH my_cursor INTO :ll_dw_serial,:li_contract_type,:ll_cal_cerp_id,:ls_charterer_shortname,:ls_charterer_group,:ld_cp_date,:ll_vessel_nr,:ls_voyage_nr,:ll_no_voyages_est,:ll_no_voyages_act,:ll_no_ton_est,:ll_no_ton_act,:ll_gross_hire_est,:ll_gross_hire_act,:ll_demurrage_est,:ll_demurrage_act,:ll_despatch_est,:ll_despatch_act,:ll_comission_est,:ll_comission_act,:ll_bunkers_est,:ll_bunkers_act,:ll_port_est,:ll_port_act,:ll_misc_est,:ll_misc_act,:ll_off_hire_est,:ll_off_hire_act,:ll_off_days_est,:ll_off_days_act,:ll_idle_days_est,:ll_idle_days_act,:ll_grossdays_est,:ll_grossdays_act;
	LOOP
END IF
CLOSE my_cursor;

////////////////////////////////////////// The sum's of the data-columns from the above selection, is now stored i local variables, with
//////////////////////////////////////////  which the numbers i the Support Definition Formula are substituted (ex. "3" which in a formula
////////////////////////////////////////// means "gross_hire" is substituted with the value of the variable "ll_gross_hire_act_sum" 
////////////////////////////////////////// or "ll_gross_hire_est_sum" dependent on the  indicator "as_est_or_act" which indicates 
////////////////////////////////////////// whelter there will be substituted with figures from TRAMOS  (as_est_or_act = "actual") 
////////////////////////////////////////// or CALCULE (as_est_or_act = "estimated")
ls_tmpstr2 = ""
ls_tmpstr3 = ""
ls_tmpstr4 = ""
ls_tmpstr1 = as_formula

IF LEN(ls_tmpstr1) > 0 THEN			// The string is NOT empty

	ls_tmpstr1 = ls_tmpstr1 + "@"		// The formula string into a working variable and a stop-sign added

	FOR li_counter=1 to LEN(ls_tmpstr1)				// For all characters in the string DO
		lc_ch = UPPER(MID(ls_tmpstr1,li_counter,1))		// Fetch the characters i the string one by one

		IF POS("+-*/()@",lc_ch) > 0 THEN				// If a delimiter/operator is met the value of ls_tmpstr2
												// contains a number-reference to one of the local
												// sum-variables, and the value of this variable can
												// be appended to the resultstring.
			IF lc_ch = "@" THEN lc_ch = ""
			CHOOSE CASE ls_tmpstr2
			CASE "1"
				IF as_act_or_est = "ACTUAL" THEN								// If the indicator as_act_or_est
					ls_tmpstr3 = ls_tmpstr3 + String(ll_no_voyages_act_sum) + lc_ch	// is "ACTUAL" then the substitution
				ELSE	//as_act_or_est = "ESTIMATED"							// is made with sum-varables which
					ls_tmpstr3 = ls_tmpstr3 + String(ll_no_voyages_est_sum) + lc_ch	// contains data from TRAMOS,
																			// otherwise with sum-variables which
																			// contains data from CALCULE.
				END IF
			CASE "2"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_no_ton_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_no_ton_est_sum) + lc_ch
				END IF
			CASE "3"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_gross_hire_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_gross_hire_est_sum) + lc_ch
				END IF
			CASE "4"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_demurrage_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_demurrage_est_sum) + lc_ch
				END IF
			CASE "5"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_despatch_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_despatch_est_sum) + lc_ch
				END IF
			CASE "6"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_comission_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_comission_est_sum) + lc_ch
				END IF
			CASE "7"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_bunkers_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_bunkers_est_sum) + lc_ch
				END IF
			CASE "8"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_port_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_port_est_sum) + lc_ch
				END IF
			CASE "9"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_misc_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_misc_est_sum) + lc_ch
				END IF
			CASE "10"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_off_hire_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_off_hire_est_sum) + lc_ch
				END IF
			CASE "11"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_off_days_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_off_days_est_sum) + lc_ch
				END IF
			CASE "12"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_idle_days_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_idle_days_est_sum) + lc_ch
				END IF
			CASE "13"
				IF as_act_or_est = "ACTUAL" THEN
					ls_tmpstr3 = ls_tmpstr3 + String(ll_grossdays_act_sum) + lc_ch
				ELSE	//as_act_or_est = "ESTIMATED"
					ls_tmpstr3 = ls_tmpstr3 + String(ll_grossdays_est_sum) + lc_ch
				END IF
			CASE "14"		//for as_act_or_est = "ESTIMATED" and "ACTUAL"
				ls_tmpstr3 = ls_tmpstr3 + "30.416" + lc_ch
			CASE "15"		//for as_act_or_est = "ESTIMATED" and "ACTUAL"
				ls_tmpstr3 = ls_tmpstr3 + "365" + lc_ch
			CASE ELSE			
				IF lc_ch <> "@" THEN
					ls_tmpstr3 = ls_tmpstr3 + lc_ch 
				END IF
			END CHOOSE
			ls_tmpstr2 = ""
		ELSE 
			ls_tmpstr2 = ls_tmpstr2 + lc_ch
		END IF
	NEXT
END IF

Return ls_tmpstr3		// Returns the constructed "expression"

end function

public function string uf_construct_where_clause (string as_select_list, string as_column, character as_pling);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :
  
 Object     :  User Object Function uf_construct_where_clause
  
 Event	 :

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 12-08-96

 Description : 	Takes a string of values and intervals and construct a Where-clause of
			this, to use with a SELECT-statement.
				ex: The string "1,2,3,4-5,6" will result in a Where-clause for the column "TEST"
				like this: "TEST=1 OR TEST=2 OR TEST=3 OR (TEST>=4 AND TEST <=5) OR TEST=6"

 Arguments :	as_select_list	: The string from which the Where-clause will be constructed
			as_column	: The column-name for use in the constructed Where-clause

 Returns   :	A Where-clause for use in a SQL-statement

 Variables : 	

 Other : 		There are no check for alid syntax, it HAS been done before this !

*************************************************************************************

Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
12-08-96		1.0			KHK		Initial version
************************************************************************************/

CHAR lc_ch
STRING ls_tmpstr1, ls_tmpstr2, ls_resultstr
INTEGER li_counter
BOOLEAN lb_interval

ls_resultstr = ""
ls_tmpstr2 = ""
lb_interval = FALSE

IF LEN(as_select_list) > 0 THEN			// The string is NOT empty

	ls_tmpstr1 = as_select_list + "@"		// The string to be checked in a working variable and add a stop-sign

	FOR li_counter=1 to LEN(ls_tmpstr1)				// For all characters in the string DO
		lc_ch = UPPER(MID(ls_tmpstr1,li_counter,1))		// Fetch the characters i the string one by one
		IF lc_ch = "," THEN							// Delimiter - finish interval, or just a simple criteria

			IF ISDATE(ls_tmpstr2) THEN
				ls_tmpstr2 = STRING(DATE(ls_tmpstr2),"mm/dd/yy")
			END IF

	        	IF lb_interval THEN
	        		ls_resultstr = ls_resultstr + as_column + " <= " + as_pling + ls_tmpstr2 + as_pling + ") OR "
			ELSE
	        		ls_resultstr = ls_resultstr + as_column + " = " + as_pling + ls_tmpstr2 + as_pling + " OR "
			END IF
			ls_tmpstr2 = ""
			lb_interval = FALSE
		ELSEIF lc_ch = "-" THEN						// Delimiter - the string in ls_tmpstr2 is the first part af
												// an interval, set the indicator lb_interval = True, and go
												// for the rest of the interval

			IF ISDATE(ls_tmpstr2) THEN
				ls_tmpstr2 = STRING(DATE(ls_tmpstr2),"mm/dd/yy")
			END IF

		        ls_resultstr = ls_resultstr + "(" + as_column + " >= " + as_pling + ls_tmpstr2 + as_pling + " AND "
			ls_tmpstr2 = ""
			lb_interval = TRUE
		ELSEIF lc_ch = "@" THEN					// Stop-sign, reading has reached end. Add the finish interval
												// or a simple selection criteria
			IF ISDATE(ls_tmpstr2) THEN
				ls_tmpstr2 = STRING(DATE(ls_tmpstr2),"mm/dd/yy")
			END IF

		        IF lb_interval THEN
	         		ls_resultstr = ls_resultstr + as_column + " <= " + as_pling + ls_tmpstr2 + as_pling + ")"
			ELSE
			        ls_resultstr = ls_resultstr + as_column + " = " + as_pling + ls_tmpstr2 + as_pling 
			END IF
		ELSE
			ls_tmpstr2 = ls_tmpstr2 + lc_ch			// If not delimiter or stop-sign, just add the character to
												// the workin string ls_tmpstr2, which will be evaluated
												// when a delimiter og a stop-sign is mat later on
		END IF
	NEXT
END IF

Return ls_resultstr			// Returns the constructed Where-clause
end function

public function string uf_construct_where_clause_vv (string as_select_list, character as_pling);//************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  :
//  
// Object     :  User Object Function uf_construct_where_clause_vv
//  
// Event	 :
//
// Scope     : 
//
// ************************************************************************************
//
// Author    : Kim Husson Kasperek
//   
// Date       : 14-08-96
//
// Description : 	Takes a string of values and intervals and construct a Where-clause of
//			this, to use with a SELECT-statement.
//				ex: The string "1,2,3,4-5,6" will result in a Where-clause for the column "TEST"
//				like this: "TEST=1 OR TEST=2 OR TEST=3 OR (TEST>=4 AND TEST <=5) OR TEST=6"
//
// Arguments :	as_select_list	: The string from which the Where-clause will be constructed
//			as_column	: The column-name for use in the constructed Where-clause
//
// Returns   :	A Where-clause for use in a SQL-statement
//
// Variables : 	
//
// Other : 		There are no check for alid syntax, it HAS been done before this !
//
//*************************************************************************************
//
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//14-08-96		1.0			KHK		Initial version
//************************************************************************************/

CHAR lc_ch
STRING ls_tmpstr1, ls_tmpstr2, ls_resultstr
INTEGER li_counter
BOOLEAN lb_interval

ls_resultstr = ""
ls_tmpstr2 = ""
lb_interval = FALSE

IF LEN(as_select_list) > 0 THEN			// The string is NOT empty

	ls_tmpstr1 = as_select_list + "@"		// The string to be checked in a working variable and add a stop-sign

	FOR li_counter=1 to LEN(ls_tmpstr1)				// For all characters in the string DO
		lc_ch = UPPER(MID(ls_tmpstr1,li_counter,1))		// Fetch the characters i the string one by one
		IF lc_ch = "/" THEN
			ls_resultstr = ls_resultstr + "(VESSEL_NR = " + ls_tmpstr2 + " AND "
			ls_tmpstr2 = ""
		ELSEIF lc_ch = "," THEN
	        	IF lb_interval THEN
	        		ls_resultstr = ls_resultstr + "VOYAGE_NR <= " + as_pling + ls_tmpstr2 + as_pling + ")) OR "
			ELSE
	        		ls_resultstr = ls_resultstr + "VOYAGE_NR = " + as_pling + ls_tmpstr2 + as_pling + ") OR "
			END IF
			ls_tmpstr2 = ""
			lb_interval = FALSE
		ELSEIF lc_ch = "-" THEN
		        ls_resultstr = ls_resultstr + "(VOYAGE_NR >= " + as_pling + ls_tmpstr2 + as_pling + " AND "
			ls_tmpstr2 = ""
			lb_interval = TRUE
		ELSEIF lc_ch = "@" THEN
	        	IF lb_interval THEN
	        		ls_resultstr = ls_resultstr + "VOYAGE_NR <= " + as_pling + ls_tmpstr2 + as_pling + "))"
			ELSE
	        		ls_resultstr = ls_resultstr + "VOYAGE_NR = " + as_pling + ls_tmpstr2 + as_pling + ")"
			END IF
		ELSE
			ls_tmpstr2 = ls_tmpstr2 + lc_ch			// If not delimiter or stop-sign, just add the character to
												// the working string ls_tmpstr2, which will be evaluated
												// when a delimiter og a stop-sign is mat later on
		END IF
	NEXT
END IF

Return ls_resultstr

end function

on constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :
  
 Object     :  Non Visual User Object u_compute_support
  
 Event	 :

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 12-08-96

 Description : 	Holds two User Object Functions which is used for retrieving and calculating
			data from the Datawarehouse according to a Support Definition on a Charterer
			or on a Target.

 Arguments :	See the functions

 Returns   :	See the functions

 Variables : 	See the functions

 Other : 		See the functions

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
12-08-96		1.0			KHK		Initial version
************************************************************************************/

end on

on u_compute_support.create
TriggerEvent( this, "constructor" )
end on

on u_compute_support.destroy
TriggerEvent( this, "destructor" )
end on

