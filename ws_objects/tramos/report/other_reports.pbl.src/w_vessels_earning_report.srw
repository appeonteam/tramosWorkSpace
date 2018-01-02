$PBExportHeader$w_vessels_earning_report.srw
forward
global type w_vessels_earning_report from window
end type
type hpb_1 from hprogressbar within w_vessels_earning_report
end type
type cb_excel from commandbutton within w_vessels_earning_report
end type
type st_report from statictext within w_vessels_earning_report
end type
type cb_5 from commandbutton within w_vessels_earning_report
end type
type dw_vas_log from datawindow within w_vessels_earning_report
end type
type st_1 from statictext within w_vessels_earning_report
end type
type sle_1 from singlelineedit within w_vessels_earning_report
end type
type cb_4 from commandbutton within w_vessels_earning_report
end type
type dw_report from datawindow within w_vessels_earning_report
end type
type cb_3 from commandbutton within w_vessels_earning_report
end type
type cb_2 from commandbutton within w_vessels_earning_report
end type
type cb_1 from commandbutton within w_vessels_earning_report
end type
type uo_profitcenter from u_drag_drop_boxes within w_vessels_earning_report
end type
type gb_1 from groupbox within w_vessels_earning_report
end type
end forward

global type w_vessels_earning_report from window
integer width = 4539
integer height = 2632
boolean titlebar = true
string title = "Vessel Earning Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
event ue_postopen ( )
hpb_1 hpb_1
cb_excel cb_excel
st_report st_report
cb_5 cb_5
dw_vas_log dw_vas_log
st_1 st_1
sle_1 sle_1
cb_4 cb_4
dw_report dw_report
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
uo_profitcenter uo_profitcenter
gb_1 gb_1
end type
global w_vessels_earning_report w_vessels_earning_report

type variables
Boolean ib_web
String is_year
str_progress parm
end variables

forward prototypes
public function string wf_get_disch_port (integer ai_vessel, string as_voyage, integer ai_voyage_type)
public function string wf_get_ballast_port (integer ai_vessel, string as_voyage)
public function integer wf_getreport_data ()
public function string wf_get_load_port (integer ai_vessel, string as_voyage, integer ai_voyage_type, ref string as_load_portcode)
public function string wf_get_load_area (string as_load_portcode)
public subroutine documentation ()
end prototypes

event ue_postopen();Integer li_select_array[], li_counts, li_counter, li_pc_nr, li_pc_old

li_counts = uo_profitcenter.dw_left.retrieve( uo_global.is_userid )

FOR li_counter = 1 TO li_counts
	li_select_array[li_counter] = uo_profitcenter.dw_left.getItemNumber(li_counter, "pc_nr")
NEXT

dw_report.SetTransObject(SQLCA)

sle_1.text = String(Year(Today()))
sle_1.SetFocus()
end event

public function string wf_get_disch_port (integer ai_vessel, string as_voyage, integer ai_voyage_type);String ls_port_code, ls_port
Datetime ldt_datetime
Double ld_calc_id
Integer li_itinery_nr

IF ai_voyage_type = 2 THEN
	SELECT MAX(PORT_ARR_DT)
	INTO 	:ldt_datetime
	FROM 	POC, VOYAGES
	WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
	  AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR
	  AND VOYAGES.VESSEL_NR = POC.VESSEL_NR
	  AND VOYAGES.VOYAGE_TYPE = 2
	  AND SUBSTRING(POC.VOYAGE_NR,1,5) = SUBSTRING(:as_voyage,1,5)
	  AND PURPOSE_CODE = "RED";
	  IF SQLCA.SQLCode = 0 THEN
		Commit;
		SELECT PORT_CODE
		INTO :ls_port_code
		FROM POC
		WHERE VESSEL_NR = :ai_vessel AND PORT_ARR_DT = :ldt_datetime;
		Commit;
			
		SELECT PORT_N
		INTO :ls_port
		FROM PORTS
		WHERE PORT_CODE = :ls_port_code;
		Commit;
	ELSE
		Commit;
		Return ""	
	END IF 
ELSE	
	SELECT CAL_CALC_ID
	INTO 	:ld_calc_id
	FROM 	VOYAGES
	WHERE ( VESSEL_NR = :ai_vessel  ) 
	  AND ( VOYAGE_NR = :as_voyage ) ;
	Commit;
	SELECT MAX(CAL_CAIO_ITINERARY_NUMBER) 
   INTO :li_itinery_nr
   FROM CAL_CAIO,   
        CAL_CALC,   
        CAL_CARG  
   WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
         ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
         ( CAL_CALC.CAL_CALC_ID = :ld_calc_id ) AND   
         (CAL_CAIO.PURPOSE_CODE = "D" OR  
         CAL_CAIO.PURPOSE_CODE = "L/D");
	IF SQLCA.SQLCode = 0 THEN
		Commit;
		SELECT CAL_CAIO.PORT_CODE  
		INTO :ls_port_code  
		FROM CAL_CAIO,   
			  CAL_CALC,   
			  CAL_CARG  
		WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
				( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
				CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
				( CAL_CALC.CAL_CALC_ID = :ld_calc_id ) AND  
				(CAL_CAIO.PURPOSE_CODE = "D" OR  
				CAL_CAIO.PURPOSE_CODE = "L/D" );
		IF SQLCA.SQLCode = 0 THEN
			SELECT PORT_N
			INTO :ls_port
			FROM PORTS
			WHERE PORT_CODE = :ls_port_code;
			Commit;
		ELSE
			Commit;
			Return ""	
		END IF 
	ELSE
		Commit;
		Return ""
	END IF			
END IF

Return ls_port
end function

public function string wf_get_ballast_port (integer ai_vessel, string as_voyage);Datetime ldt_datetime, ldt_datetime_prev, ldt_dummy
String ls_last_voyage_nr, ls_port, ls_port_code

SELECT DISTINCT min(POC.PORT_ARR_DT)
INTO 	:ldt_datetime
FROM 	POC 
WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
  AND ( POC.VOYAGE_NR = :as_voyage )  
  AND ( POC.PORT_ARR_DT <> NULL );

if sqlca.sqlcode = 0 then
	commit;
	SELECT MAX(PORT_ARR_DT)
	INTO :ldt_datetime_prev
   FROM POC 
   WHERE ( POC.PORT_ARR_DT < :ldt_datetime) and
         ( POC.VESSEL_NR = :ai_vessel ) ;

	if SQLCA.SQLCode = 0 then
		Commit;
		SELECT POC.PORT_CODE  
		INTO :ls_port_code
		FROM POC 
		WHERE ( POC.PORT_ARR_DT = :ldt_datetime_prev )
		  AND ( POC.VESSEL_NR = :ai_vessel  );
	else	  
		Commit;
		SELECT POC.PORT_CODE  
		INTO :ls_port_code
		FROM POC 
		WHERE ( POC.PORT_ARR_DT = :ldt_datetime )
		  AND ( POC.VESSEL_NR = :ai_vessel  ); 
	END IF
	
	IF SQLCA.SQLCOde = 0 THEN
		Commit;
		SELECT PORT_N
		INTO :ls_port
		FROM PORTS
		WHERE PORT_CODE = :ls_port_code;
		Commit;
	ELSE
		Commit;
	   Return ""
	END IF	
else
	Commit;
	Return ""	
end if

Return ls_port
end function

public function integer wf_getreport_data ();/* Declare local variables */
u_vas_control lu_vas_control
String ls_charter, ls_port, ls_dummy, ls_grade_group, ls_contract_type, ls_load_portcode, ls_area, ls_voyage_nr
Boolean lb_new_vessel = TRUE
long ll_count,ll_number_of_voyages
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer li_key[], li_vessel_index = 1, li_previous_vessel, li_voyage_index = 1, li_tc_arr_result, li_vessel_nr, li_i
Integer li_previous_voyage_type, li_this_voyage_type, li_total_days, li_sqlcode, li_claimnr, li_tc_payments_overdue
Decimal {2} ld_total_days, ld_daysyeartodate, ld_usdyeartodate, ld_usdprday, ld_result, ld_frt
Double ld_original_claim, ld_transactions
Decimal {0} ld_contract_id
u_check_tc luo_check_tc
	
/* Create user objects */
lu_vas_control = create u_vas_control
luo_check_tc = create u_check_tc

ll_number_of_voyages = dw_report.RowCount()

setPointer( hourglass!)

// Loop through voyages and build data for report
// dw_vas_log is used as a dummy parameter for lu_vas_control
hpb_1.maxposition = ll_number_of_voyages
hpb_1.position = 1

if ll_number_of_voyages = 0 then
	messagebox("Information","There is no data on the selected report!")
	return 1
end if
for ll_count = 1 to ll_number_of_voyages
	lstr_vessel_voyage_list[1].vessel_nr = dw_report.GetItemNumber(ll_count,"voyages_vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = dw_report.GetItemString(ll_count,"voyages_voyage_nr")
	li_this_voyage_type = dw_report.GetItemNumber(ll_count,"voyages_voyage_type")
	lu_vas_control.of_master_control( 7,li_key[], lstr_vessel_voyage_list[], Integer(Right(sle_1.text,2)), dw_vas_log)
	IF (lstr_vessel_voyage_list[1].vessel_nr <> li_previous_vessel) AND ll_count <> 1 THEN
		li_vessel_index ++
		li_voyage_index = 1
		lb_new_vessel = TRUE
	ELSE
		lb_new_vessel = FALSE
	END IF
	dw_report.SetItem(ll_count,"startdate",w_generate_supervasfile.istr_vas_file.startdate)
	dw_report.SetItem(ll_count,"enddate",w_generate_supervasfile.istr_vas_file.enddate)
	// If there is a previous voyage on same vessel, and the voyage type is TC Out and
	// previous and this voyage type are not equal, we must use another logic for start and end date
	IF NOT(lb_new_vessel) AND ll_count > 1 THEN
		li_previous_voyage_type = dw_report.GetItemNumber(ll_count - 1,"voyages_voyage_type")
		IF li_this_voyage_type <> li_previous_voyage_type THEN
			IF li_this_voyage_type = 2 THEN
				//Handle start and end date when TC Out follows a normal voyage.	
				// In this case the previous voyage enddate must be changed to be 
				// the day before this TC Out voyage start date
				IF RelativeDate(Date(w_generate_supervasfile.istr_vas_file.startdate), -1) > Date(dw_report.GetItemDatetime(ll_count - 1,"enddate")) THEN
					dw_report.SetItem(ll_count - 1,"enddate", RelativeDate(date(w_generate_supervasfile.istr_vas_file.startdate), -1))
				END IF
			ELSEIF li_previous_voyage_type = 2 THEN
				//Handle start and end date when a normal voyage follows a TC Out voyage.
				// In this case the single voyage start date must be one day after the previous 
				// TC Out voyage departure date for the RED purpose port in POC IF ANY.
				// In no RED, then the startdate must be one day after redelivery for the contract
				// This rule is used when determing the TC end date.
				dw_report.SetItem(ll_count,"startdate", RelativeDate(date(dw_report.GetItemDatetime(ll_count - 1,"enddate")), 1))	
			END IF
		END IF
		IF dw_report.GetItemdatetime(ll_count,"enddate") < dw_report.GetItemdatetime(ll_count,"startdate") THEN
				dw_report.SetItem(ll_count,"enddate", RelativeDate(date(dw_report.GetItemDatetime(ll_count,"enddate")), 1))
		END IF			
	END IF
 
	ld_total_days = w_generate_supervasfile.istr_vas_file.totaldays
	dw_report.SetItem(ll_count,"days",w_generate_supervasfile.istr_vas_file.totaldays)
	IF NOT(lb_new_vessel) THEN
		ld_daysyeartodate += ld_total_days
		dw_report.SetItem(ll_count,"daysyear", ld_daysyeartodate)
	ELSE
		ld_daysyeartodate = ld_total_days
		dw_report.SetItem(ll_count,"daysyear", ld_daysyeartodate)
	END IF
	
	dw_report.SetItem(ll_count,"offdays", w_generate_supervasfile.istr_vas_file.offdays)
	SELECT CHART.CHART_N_1  
   INTO :ls_charter  
   FROM CHART  
   WHERE CHART.CHART_NR = :w_generate_supervasfile.istr_vas_file.charter;
	Commit;
	dw_report.SetItem(ll_count,"charterer", ls_charter)
	ld_result = w_generate_supervasfile.istr_vas_file.result
	IF ld_total_days > 0 THEN
		dw_report.SetItem(ll_count,"usdprday", ld_result/(ld_total_days))
	END IF
	
	IF NOT(lb_new_vessel) THEN
		ld_usdyeartodate += ld_result
	ELSE
		ld_usdyeartodate = ld_result
	END IF
	
	if ld_daysyeartodate = 0 then
		// Change Request #1506 - Agreed with Jacob Tørring that we set days = 1 so to aviod error message divide by zero
		// this scenario typically comes when there is no calculation allocated to a voyage 
		ld_daysyeartodate = 1
	end if
	
	IF ld_usdyeartodate > 0 THEN
		dw_report.SetItem(ll_count,"usdyear", ld_usdyeartodate/ld_daysyeartodate)
	ELSE
		dw_report.SetItem(ll_count,"usdyear", 0)
	END IF
	
	
	IF li_this_voyage_type <> 2 THEN
		SELECT CLAIMS.CLAIM_AMOUNT_USD  
		INTO :ld_frt  
		FROM CLAIMS  
		WHERE CLAIMS.CHART_NR = :w_generate_supervasfile.istr_vas_file.charter AND VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr AND
				VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr AND CLAIM_TYPE = "FRT" ;
		li_sqlcode = SQLCA.SQLCode		
		Commit;
		
		IF li_sqlcode = 100 THEN
			dw_report.SetItem(ll_count,"frtpaid","NA")
		ELSEIF ld_frt = 0 THEN
			dw_report.SetItem(ll_count,"frtpaid","X")
		END IF
		
		SELECT IsNull(CLAIM_AMOUNT_USD,0), CLAIM_NR
		INTO :ld_original_claim, :li_claimnr
		FROM CLAIMS
		WHERE CLAIMS.CHART_NR = :w_generate_supervasfile.istr_vas_file.charter AND VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr AND
				VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr AND CLAIM_TYPE = "DEM" ;		
		li_sqlcode = SQLCA.SQLCode			
		COMMIT;
		
		SELECT IsNull(SUM( C_TRANS_AMOUNT_USD ),0)
		INTO :ld_transactions
		FROM CLAIM_TRANSACTION
		WHERE CHART_NR = :w_generate_supervasfile.istr_vas_file.charter AND VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr AND
				VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr AND CLAIM_NR = :li_claimnr ;	
		COMMIT USING SQLCA;
		IF li_sqlcode = 100 THEN
			dw_report.SetItem(ll_count,"dempaid","NA")
		ELSEIF (ld_original_claim - ld_transactions <= 0) THEN
			dw_report.SetItem(ll_count,"dempaid","X")
		END IF
		// Ballast port is commenced port
		ls_port = wf_get_ballast_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
		IF ls_port <> "" THEN
			dw_report.SetItem(ll_count,"ballastport",ls_port)
		END IF
		// Load port
		ls_port = wf_get_load_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,1, ls_load_portcode)
		IF ls_port <> "" THEN
			dw_report.SetItem(ll_count,"loadport",ls_port)
			// Load Area
			ls_area = wf_get_load_area(ls_load_portcode)
			IF ls_area <> "" THEN
				dw_report.SetItem(ll_count,"load_area",ls_area)
			END IF
		END IF
		// Disch port
		ls_port = wf_get_disch_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,1)
		IF ls_port <> "" THEN
			dw_report.SetItem(ll_count,"dischargeport",ls_port)
		END IF
	ELSE
		// Add text to voyage number in order not to get update problems if single voy and TCO 
		// are the same (I.e. 0251 voyage type 1 and 025101 voayge type 2)
		dw_report.SetItem(ll_count,"voyages_voyage_nr",dw_report.GetItemString(ll_count,"voyages_voyage_nr") + "TCO")
		
		dw_report.SetItem(ll_count,"ballastport","[ DEL+RED => ]")
		// Load port
		ls_port = wf_get_load_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,2, ls_load_portcode)
		IF ls_port <> "" THEN
			dw_report.SetItem(ll_count,"loadport",ls_port)
			// Load Area
			ls_area = wf_get_load_area(ls_load_portcode)
			IF ls_area <> "" THEN
				dw_report.SetItem(ll_count,"load_area",ls_area)
			END IF
		END IF
		// Disch port
		ls_port = wf_get_disch_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,2)
		IF ls_port <> "" THEN
			dw_report.SetItem(ll_count,"dischargeport",ls_port)
		END IF
		// Check if no est_due_date overdue then set "X"
		luo_check_tc.of_check_tc_poc(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr,dw_report.GetItemDatetime(ll_count,"startdate"),"",ld_contract_id,ls_dummy)
		IF ld_contract_id > 0 THEN
		  	SELECT count(* )  
				INTO :li_tc_payments_overdue  
				FROM NTC_PAYMENT  
				WHERE ( NTC_PAYMENT.CONTRACT_ID = :ld_contract_id ) AND  
						( NTC_PAYMENT.EST_DUE_DATE < getdate( ) ) AND  
						( NTC_PAYMENT.PAYMENT_STATUS <> 5 ) ;
			Commit;
			IF NOT(li_tc_payments_overdue > 0) THEN
				dw_report.SetItem(ll_count,"frtpaid","X")
			END IF	
		END IF
	END IF	
	/* Set Grade Group */
	if li_this_voyage_type = 1 then
		SELECT GRADE_GROUP 
			INTO :ls_grade_group
			FROM BOL 
			WHERE VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr	
			AND VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr
			AND L_D = 1
			GROUP BY GRADE_GROUP
			ORDER BY SUM(BOL_QUANTITY) DESC;
	else
		ls_grade_group = "UnKnown"
	end if
	dw_report.SetItem(ll_count,"grade_group",ls_grade_group )
	/* Get Contract type */
	if li_this_voyage_type = 1 then
		SELECT CASE CAL_CERP.CAL_CERP_CONTRACT_TYPE 
				WHEN 1 THEN "SPOT" 
				WHEN 2 THEN "COA Fixed rate" 
				WHEN 3 THEN "CVS Fixed rate" 
				WHEN 4 THEN "All" 
				WHEN 5 THEN "T/C Out" 
				WHEN 6 THEN "B/B Out" 
				WHEN 7 THEN "COA Market rate" 
				WHEN 8 THEN "CVS Market rate" 
				ELSE "UnKnown" END  
			INTO :ls_contract_type
			FROM CAL_CARG,   
				CAL_CERP,   
				VOYAGES  
			WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  
			AND  CAL_CARG.CAL_CALC_ID = VOYAGES.CAL_CALC_ID 
			AND VOYAGES.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr	
			AND VOYAGES.VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr
			GROUP BY CAL_CERP.CAL_CERP_CONTRACT_TYPE, CAL_CARG.CAL_CARG_ID
			ORDER BY SUM(CAL_CARG_TOTAL_GROSS_FREIGHT) DESC  ;
	elseif	 li_this_voyage_type = 2 then
		ls_contract_type = "T/C Out"
	else
		ls_contract_type = "UnKnown"
	end if
	dw_report.SetItem(ll_count,"contract_type",ls_contract_type )
	
	//set broker
	IF li_this_voyage_type <> 2 THEN
		ls_voyage_nr = dw_report.GetItemString(ll_count,"voyages_voyage_nr")
		li_vessel_nr = dw_report.GetItemNumber(ll_count,"voyages_vessel_nr")
		Datastore lds_brokers
		lds_brokers = Create Datastore
		lds_brokers.Dataobject = "d_report_vessel_earnings_brokers"
		lds_brokers.SetTransobject( SQLCA)
		lds_brokers.retrieve(li_vessel_nr, ls_voyage_nr)
		for li_i = 1 to lds_brokers.rowcount( )
			if dw_report.getitemstring( ll_count, "broker") = "" then
				dw_report.SetItem(ll_count,"broker",lds_brokers.getitemstring(li_i, "broker_name"))
			else
				dw_report.SetItem(ll_count,"broker",dw_report.getitemstring( ll_count, "broker") + ", " + lds_brokers.getitemstring(li_i, "broker_name"))
			end if
		next
	END IF
	
	li_voyage_index ++
	li_previous_vessel = lstr_vessel_voyage_list[1].vessel_nr
	
	// Clear voyage data
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].voyage_nr = ""
	SetNull(w_generate_supervasfile.istr_vas_file.startdate)
	SetNull(w_generate_supervasfile.istr_vas_file.enddate) 
	w_generate_supervasfile.istr_vas_file.offdays = 0
	w_generate_supervasfile.istr_vas_file.charter = 0
	w_generate_supervasfile.istr_vas_file.result = 0
	w_generate_supervasfile.istr_vas_file.bunkerexp = 0
	w_generate_supervasfile.istr_vas_file.miscexp = 0
	w_generate_supervasfile.istr_vas_file.exrate = 0
	
	hpb_1.position = ll_count
next

Destroy lu_vas_control
Destroy luo_check_tc

Return 1
end function

public function string wf_get_load_port (integer ai_vessel, string as_voyage, integer ai_voyage_type, ref string as_load_portcode);String ls_port_code, ls_port
Datetime ldt_datetime
Integer li_itinery_nr
Double ld_calc_id

IF ai_voyage_type = 2 THEN
	SELECT MAX(PORT_ARR_DT)
	INTO 	:ldt_datetime
	FROM 	POC, VOYAGES
	WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
	  AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR
	  AND VOYAGES.VESSEL_NR = POC.VESSEL_NR
	  AND VOYAGES.VOYAGE_TYPE = 2
	  AND SUBSTRING(POC.VOYAGE_NR,1,5) <= SUBSTRING(:as_voyage,1,5)
	  AND PURPOSE_CODE = "DEL" ;
ELSE	
	SELECT MIN(PORT_ARR_DT)
	INTO 	:ldt_datetime
	FROM 	POC
	WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
	  AND ( POC.VOYAGE_NR = :as_voyage )  
	  AND (PURPOSE_CODE = "L" OR PURPOSE_CODE = "L/D") ;
	IF SQLCA.SQLCode <> 0 THEN
		Commit;
		SELECT CAL_CALC_ID
		INTO 	:ld_calc_id
		FROM 	VOYAGES
		WHERE ( VESSEL_NR = :ai_vessel  ) 
		  AND ( VOYAGE_NR = :as_voyage ) ;
		Commit;
		SELECT MIN(CAL_CAIO_ITINERARY_NUMBER) 
		INTO :li_itinery_nr
		FROM CAL_CAIO,   
			  CAL_CALC,   
			  CAL_CARG  
		WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
				( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
				( CAL_CALC.CAL_CALC_ID = :ld_calc_id ) AND   
				(CAL_CAIO.PURPOSE_CODE = "L" OR  
				CAL_CAIO.PURPOSE_CODE = "L/D");
		IF SQLCA.SQLCode = 0 THEN
			Commit;
			SELECT CAL_CAIO.PORT_CODE  
			INTO :ls_port_code  
			FROM CAL_CAIO,   
				  CAL_CALC,   
				  CAL_CARG  
			WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
					( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
					CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
					( CAL_CALC.CAL_CALC_ID = :ld_calc_id ) AND  
					(CAL_CAIO.PURPOSE_CODE = "L" OR  
					CAL_CAIO.PURPOSE_CODE = "L/D" );
			IF SQLCA.SQLCode = 0 THEN
				SELECT PORT_N
				INTO :ls_port
				FROM PORTS
				WHERE PORT_CODE = :ls_port_code;
				Commit;
				Return ls_port
			ELSE
				Commit;
				Return ""	
			END IF 
		ELSE
			Commit;
			Return ""
		END IF			 
	END IF	  
END IF

IF SQLCA.SQLCode = 0 THEN
	Commit;
	SELECT PORT_CODE
	INTO :ls_port_code
	FROM POC
	WHERE VESSEL_NR = :ai_vessel AND PORT_ARR_DT = :ldt_datetime;
	Commit;
		
	SELECT PORT_N
	INTO :ls_port
	FROM PORTS
	WHERE PORT_CODE = :ls_port_code;
	Commit;
ELSE
   Commit;
	as_load_portcode = ""
	Return ""	
END IF 

as_load_portcode = ls_port_code
Return ls_port
end function

public function string wf_get_load_area (string as_load_portcode);string 	ls_area

SELECT TOP 1 AREA.AREA_NAME  
	INTO :ls_area
	FROM AREA,   
		AREA_PORTS  
	WHERE AREA.AREA_PK = AREA_PORTS.AREA_PK 
	AND AREA_PORTS.PORT_CODE = :as_load_portcode
	AND AREA_PORTS.PRIMARY_AREA = 1;
if sqlca.sqlcode <> 0 then
	commit;
	return ""
end if

commit;
return ls_area
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_vessels_earning_report
   <OBJECT> 
	</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
    Date   Ref    Author        	Comments
  12/01/11	CR 2197	JMC	data object of uo_profitcenter was replaced
  01/09/14	CR3781	CCY018		The window title match with the text of a menu item
********************************************************************/
end subroutine

on w_vessels_earning_report.create
this.hpb_1=create hpb_1
this.cb_excel=create cb_excel
this.st_report=create st_report
this.cb_5=create cb_5
this.dw_vas_log=create dw_vas_log
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_4=create cb_4
this.dw_report=create dw_report
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_profitcenter=create uo_profitcenter
this.gb_1=create gb_1
this.Control[]={this.hpb_1,&
this.cb_excel,&
this.st_report,&
this.cb_5,&
this.dw_vas_log,&
this.st_1,&
this.sle_1,&
this.cb_4,&
this.dw_report,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.uo_profitcenter,&
this.gb_1}
end on

on w_vessels_earning_report.destroy
destroy(this.hpb_1)
destroy(this.cb_excel)
destroy(this.st_report)
destroy(this.cb_5)
destroy(this.dw_vas_log)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_4)
destroy(this.dw_report)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_profitcenter)
destroy(this.gb_1)
end on

event open;
this.move(0,0)

postevent( "ue_postopen")


end event

type hpb_1 from hprogressbar within w_vessels_earning_report
integer x = 1175
integer y = 2440
integer width = 3337
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_excel from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 1764
integer width = 709
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save as"
end type

event clicked;dw_report.SaveAs()
end event

type st_report from statictext within w_vessels_earning_report
integer x = 32
integer y = 84
integer width = 1129
integer height = 108
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 1524
integer width = 709
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Get old Report from Web table"
end type

event clicked;Datastore lds_web

IF NOT(Integer(sle_1.text) > 2000 AND Integer(sle_1.text) < 2099) THEN 
	MessageBox("Error","Please enter a valid year between 2000-2099.")
	Return
END IF

lds_web = Create datastore
lds_web.Dataobject = "d_web_pool_vessel_earnings"
lds_web.SetTransObject(SQLCA)
lds_web.Retrieve(right(sle_1.text,2))

dw_report.Reset()

lds_web.RowsCopy(1,lds_web.RowCount(),Primary!,dw_report,1,Primary!)

Destroy lds_web;

ib_web = FALSE
st_report.text = "Old Report " + sle_1.text + " from web"
	

end event

type dw_vas_log from datawindow within w_vessels_earning_report
boolean visible = false
integer x = 27
integer y = 1996
integer width = 142
integer height = 104
integer taborder = 50
string title = "none"
string dataobject = "d_vas_log"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_vessels_earning_report
integer x = 32
integer y = 288
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year :"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_vessels_earning_report
integer x = 229
integer y = 280
integer width = 197
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 1404
integer width = 709
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create new &Report"
boolean default = true
end type

event clicked;Integer li_rows, li_counter,li_pcnr[], li_return

IF NOT(Integer(sle_1.text) > 2000 AND Integer(sle_1.text) < 2099) THEN 
	MessageBox("Error","Please enter a valid year between 2000-2099.")
	Return
END IF

st_report.text = ""

li_rows = uo_profitcenter.dw_right.rowcount()
If NOT(li_rows > 0) THEN Return
For li_counter = 1 to li_rows
	li_pcnr[li_counter] = uo_profitcenter.dw_right.GetItemNumber(li_counter,"pc_nr")
Next
dw_report.Retrieve(li_pcnr, Right(sle_1.text,2))

Opensheet(w_generate_supervasfile, w_tramos_main, 0, original!)
w_generate_supervasfile.controlmenu = false
w_generate_supervasfile.visible = false
w_generate_supervasfile.enabled = false
w_generate_supervasfile.windowstate = minimized!
parent.SetRedraw(TRUE)

setPointer(hourglass!)

is_year = sle_1.text

li_return = wf_getreport_data()

Close(w_generate_supervasfile)
dw_report.SetRedraw(TRUE)
setPointer(arrow!)

IF li_return = 1 THEN
	ib_web = TRUE
	st_report.text = "New Report created"
END IF

end event

type dw_report from datawindow within w_vessels_earning_report
integer x = 1175
integer y = 20
integer width = 3337
integer height = 2372
integer taborder = 20
string title = "none"
string dataobject = "d_report_vessel_earnings"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 1884
integer width = 709
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Update Web table"
end type

event clicked;Datastore lds_web

IF NOT(ib_web) THEN
	MessageBox("Information","You have no new generated data for update of WEB.")
	Return
END IF

IF MessageBox("Warning","All data in WEB table for year "+ is_year + " will be deleted and ~r~n " + &
			"substituted with these present data ! Continue ?",Exclamation!,YesNo!,2) = 1 THEN
			
	DELETE FROM POOL_VESSEL_EARNINGS
	WHERE SUBSTRING(VOYAGE_NR,1,2) = Substring(:is_year,3,2) ;
	Commit;
	IF SQLCA.SQLCode = 0 THEN
		lds_web = Create datastore
		lds_web.Dataobject = "d_web_pool_vessel_earnings"
		lds_web.SetTransObject(SQLCA)
		
		dw_report.RowsCopy(1,dw_report.RowCount(),Primary!,lds_web,1,Primary!)
	
	f_datastore_spy(lds_web)
	
		IF lds_web.Update() = 1 THEN
			Commit;
			Destroy lds_web;
		ELSE
			Rollback;
			MessageBox("ERROR","Update of WEB table failed. Old data still valid.")
			Destroy lds_web;
			Return
		END IF	
	ELSE
		Rollback;
		MessageBox("ERROR","Delete of WEB table failed. Old data still valid.")
		Return
	END IF	
	ib_web = FALSE
END IF

end event

type cb_2 from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 1644
integer width = 709
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_report.Print()
end event

type cb_1 from commandbutton within w_vessels_earning_report
integer x = 238
integer y = 2004
integer width = 709
integer height = 100
integer taborder = 40
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

type uo_profitcenter from u_drag_drop_boxes within w_vessels_earning_report
integer x = 14
integer y = 400
integer taborder = 20
end type

event constructor;call super::constructor;this.uf_set_frame_label("Profit Centers")
this.uf_setleft_datawindow("d_profit_center_name")
this.uf_setright_datawindow("d_profit_center_name")
this.uf_set_left_dw_width(90)
this.uf_set_right_dw_width(90)
this.uf_set_height(92)

end event

on uo_profitcenter.destroy
call u_drag_drop_boxes::destroy
end on

type gb_1 from groupbox within w_vessels_earning_report
integer x = 5
integer y = 196
integer width = 1161
integer height = 972
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter Criteria "
end type

