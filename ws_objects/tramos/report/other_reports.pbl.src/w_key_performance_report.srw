$PBExportHeader$w_key_performance_report.srw
forward
global type w_key_performance_report from window
end type
type sle_1 from singlelineedit within w_key_performance_report
end type
type st_1 from statictext within w_key_performance_report
end type
type cb_6 from commandbutton within w_key_performance_report
end type
type dw_web_table from datawindow within w_key_performance_report
end type
type st_report from statictext within w_key_performance_report
end type
type cb_5 from commandbutton within w_key_performance_report
end type
type dw_vas_report from datawindow within w_key_performance_report
end type
type cb_4 from commandbutton within w_key_performance_report
end type
type dw_report from datawindow within w_key_performance_report
end type
type cb_3 from commandbutton within w_key_performance_report
end type
type cb_2 from commandbutton within w_key_performance_report
end type
type cb_1 from commandbutton within w_key_performance_report
end type
type uo_profitcenter from u_drag_drop_boxes within w_key_performance_report
end type
type gb_1 from groupbox within w_key_performance_report
end type
end forward

global type w_key_performance_report from window
integer width = 4635
integer height = 2184
boolean titlebar = true
string title = "Key Performance Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
event ue_postopen ( )
sle_1 sle_1
st_1 st_1
cb_6 cb_6
dw_web_table dw_web_table
st_report st_report
cb_5 cb_5
dw_vas_report dw_vas_report
cb_4 cb_4
dw_report dw_report
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
uo_profitcenter uo_profitcenter
gb_1 gb_1
end type
global w_key_performance_report w_key_performance_report

type variables
Boolean ib_web
String is_year, is_fix_bal, is_fix_load, is_fix_disch 
String is_est_bal, is_est_load, is_est_disch, is_cal_bal, is_cal_load, is_cal_disch
Decimal {0} id_fix_id
Decimal {2} is_demrate, id_days_ballast
string is_chart, is_prev_chart, is_contracttype
datetime idt_arrival, idt_laycan_start, idt_laycan_end
str_progress parm
end variables

forward prototypes
public subroutine wf_get_disch_port (integer ai_vessel, string as_voyage)
public subroutine wf_get_load_port (integer ai_vessel, string as_voyage)
public subroutine wf_get_ballast_port (integer ai_vessel, string as_voyage)
public subroutine wf_copy_row_to_web (integer ai_from_row, integer ai_to_row)
public subroutine wf_copy_row_to_report (integer ai_from_row, integer ai_to_row)
public function integer wf_getreport_data ()
private function integer wf_setothercalcdata (integer ai_vessel, string as_voyage)
private function integer wf_setotheroperationsdata (integer ai_vessel, string as_voyage)
public subroutine documentation ()
end prototypes

event ue_postopen();
uo_profitcenter.dw_left.retrieve( uo_global.is_userid )

dw_report.SetTransObject(SQLCA)
dw_web_table.SetTransObject(SQLCA)

sle_1.text = String(Year(Today()))
sle_1.SetFocus()
end event

public subroutine wf_get_disch_port (integer ai_vessel, string as_voyage);String ls_port_code, ls_port
Datetime ldt_datetime
Integer li_itinery_nr
Double ld_calc_id

// Fix disch port
SELECT MAX(CAL_CAIO_ITINERARY_NUMBER) 
INTO :li_itinery_nr
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 4 AND
		CAL_CAIO.PURPOSE_CODE = "D" ;
Commit;
SELECT IsNull(PORTS.PORT_N, "")
INTO :is_fix_disch  
FROM CAL_CAIO, CAL_CALC, CAL_CARG, PORTS  
WHERE CAL_CAIO.PORT_CODE = PORTS.PORT_CODE
AND CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID 
and CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID 
and CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr 
AND CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id 
AND CAL_CALC.CAL_CALC_STATUS = 4 ;
Commit;
//SELECT CAL_CAIO.PORT_CODE  
//INTO :ls_port_code  
//FROM CAL_CAIO, CAL_CALC, CAL_CARG  
//WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
//		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
//		CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
//		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
//		CAL_CALC.CAL_CALC_STATUS = 4 ;
//Commit;
//SELECT IsNull(PORT_N,"")
//INTO :is_fix_disch
//FROM PORTS
//WHERE PORT_CODE = :ls_port_code;
//Commit;

// Calc disch port
SELECT MAX(CAL_CAIO_ITINERARY_NUMBER) 
INTO :li_itinery_nr
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 5 AND
		CAL_CAIO.PURPOSE_CODE = "D" ;
Commit;
SELECT CAL_CAIO.PORT_CODE  
INTO :ls_port_code  
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
		CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 5 ;
Commit;
SELECT IsNull(PORT_N,"")
INTO :is_cal_disch
FROM PORTS
WHERE PORT_CODE = :ls_port_code;
Commit;

// Est/act load port
SELECT MAX(PORT_ARR_DT)
INTO 	:ldt_datetime
FROM 	POC
WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
	  AND ( POC.VOYAGE_NR = :as_voyage )  
	  AND (PURPOSE_CODE = "D" OR PURPOSE_CODE = "L/D") ;

IF SQLCA.SQLCode <> 0 THEN
	Commit;
	SELECT MAX(CAL_CAIO_ITINERARY_NUMBER) 
	INTO :li_itinery_nr
	FROM CAL_CAIO, CAL_CALC, CAL_CARG  
	WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
			( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
			( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
			CAL_CALC.CAL_CALC_STATUS = 6 AND
			CAL_CAIO.PURPOSE_CODE = "D" ;
	Commit;
	SELECT CAL_CAIO.PORT_CODE  
	INTO :ls_port_code  
	FROM CAL_CAIO, CAL_CALC, CAL_CARG  
	WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
			( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
			CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
			( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
			CAL_CALC.CAL_CALC_STATUS = 6 ;
	Commit;
ELSE
	Commit;
	SELECT PORT_CODE
	INTO :ls_port_code
	FROM POC
	WHERE VESSEL_NR = :ai_vessel AND PORT_ARR_DT = :ldt_datetime;
	Commit;
END IF 

SELECT IsNull(PORT_N,"")
INTO :is_est_disch
FROM PORTS
WHERE PORT_CODE = :ls_port_code;
Commit;

Return 

end subroutine

public subroutine wf_get_load_port (integer ai_vessel, string as_voyage);String ls_port_code, ls_port
Datetime ldt_datetime
Integer li_itinery_nr
Double ld_calc_id

// Fix load port
SELECT MIN(CAL_CAIO_ITINERARY_NUMBER) 
INTO :li_itinery_nr
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 4 AND
		CAL_CAIO.PURPOSE_CODE = "L" ;
Commit;
SELECT CAL_CAIO.PORT_CODE, CAL_CAIO.CAL_CAIO_DEMURRAGE  
INTO :ls_port_code, :is_demrate  
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
		CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 4 ;
Commit;
SELECT IsNull(PORT_N,"")
INTO :is_fix_load
FROM PORTS
WHERE PORT_CODE = :ls_port_code;
Commit;

// Calc load port
SELECT MIN(CAL_CAIO_ITINERARY_NUMBER) 
INTO :li_itinery_nr
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 5 AND
		CAL_CAIO.PURPOSE_CODE = "L" ;
Commit;
SELECT CAL_CAIO.PORT_CODE  
INTO :ls_port_code  
FROM CAL_CAIO, CAL_CALC, CAL_CARG  
WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
		CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
		( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
		CAL_CALC.CAL_CALC_STATUS = 5 ;
Commit;
SELECT IsNull(PORT_N,"")
INTO :is_cal_load
FROM PORTS
WHERE PORT_CODE = :ls_port_code;
Commit;

// Est/act load port
SELECT MIN(PORT_ARR_DT)
INTO 	:ldt_datetime
FROM 	POC
WHERE ( POC.VESSEL_NR = :ai_vessel  ) 
	  AND ( POC.VOYAGE_NR = :as_voyage )  
	  AND (PURPOSE_CODE = "L" OR PURPOSE_CODE = "L/D") ;

IF SQLCA.SQLCode <> 0 THEN
	Commit;
	SELECT MIN(CAL_CAIO_ITINERARY_NUMBER) 
	INTO :li_itinery_nr
	FROM CAL_CAIO, CAL_CALC, CAL_CARG  
	WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
			( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
			( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
			CAL_CALC.CAL_CALC_STATUS = 6 AND
			CAL_CAIO.PURPOSE_CODE = "L" ;
	Commit;
	SELECT CAL_CAIO.PORT_CODE  
	INTO :ls_port_code  
	FROM CAL_CAIO, CAL_CALC, CAL_CARG  
	WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
			( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and
			CAL_CAIO_ITINERARY_NUMBER = :li_itinery_nr AND
			( CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id ) AND 
			CAL_CALC.CAL_CALC_STATUS = 6 ;
	Commit;
ELSE
	Commit;
	SELECT PORT_CODE
	INTO :ls_port_code
	FROM POC
	WHERE VESSEL_NR = :ai_vessel AND PORT_ARR_DT = :ldt_datetime;
	Commit;
END IF 

SELECT IsNull(PORT_N,"")
INTO :is_est_load
FROM PORTS
WHERE PORT_CODE = :ls_port_code;
Commit;

Return 
end subroutine

public subroutine wf_get_ballast_port (integer ai_vessel, string as_voyage);String  ls_portcode

// Fix ballast port
setnull(is_fix_bal)
SELECT P.PORT_N
INTO :is_fix_bal
FROM CAL_CALC C, PORTS P
WHERE C.CAL_CALC_BALLAST_FROM = P.PORT_CODE
AND C.CAL_CALC_FIX_ID = :id_fix_id 
AND C.CAL_CALC_STATUS = 4;


		
// Calc ballast port
setnull(is_cal_bal)
SELECT P.PORT_N
INTO :is_cal_bal
FROM CAL_CALC C, PORTS P
WHERE C.CAL_CALC_BALLAST_FROM = P.PORT_CODE
AND C.CAL_CALC_FIX_ID = :id_fix_id 
AND C.CAL_CALC_STATUS = 5;



// Est/ACT ballast port

setnull(ls_portcode)

SELECT TOP 1 POC.PORT_CODE 
INTO :ls_portcode
FROM (
        SELECT PROCEED.VESSEL_NR, PROCEED.VOYAGE_NR, PROCEED.PORT_CODE, PROCEED.PCN, PROCEED.PORT_ORDER, VOYAGES.FULL_VOYAGE_NR
        FROM PROCEED, VOYAGES
        WHERE PROCEED.VESSEL_NR = VOYAGES.VESSEL_NR AND PROCEED.VOYAGE_NR = VOYAGES.VOYAGE_NR 
		   AND PROCEED.VESSEL_NR = :ai_vessel AND PROCEED.CANCEL = 0 AND (PROCEED.PCN >= 0 OR (PROCEED.PCN < 1 AND PROCEED.SHOW_VP = 1)) 
            AND (VOYAGES.FULL_VOYAGE_NR <  (CASE WHEN LEFT(:as_voyage,2) > '80' THEN '19' ELSE '20' END ) + :as_voyage )  
) P LEFT OUTER JOIN (   SELECT VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN
                        FROM POC
                        WHERE VESSEL_NR = :ai_vessel
                        UNION ALL
                        SELECT VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN
                        FROM POC_EST    
                        WHERE VESSEL_NR = :ai_vessel
                    ) POC ON P.VESSEL_NR = POC.VESSEL_NR AND P.VOYAGE_NR = POC.VOYAGE_NR AND P.PORT_CODE = POC.PORT_CODE AND P.PCN = POC.PCN
ORDER BY    P.FULL_VOYAGE_NR DESC,P.PORT_ORDER DESC;


IF isnull(ls_portcode) THEN	
// Est ballast port
	SELECT CAL_CALC_BALLAST_FROM
	INTO :ls_portcode
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :id_fix_id AND CAL_CALC_STATUS = 6;
		
	if isnull(ls_portcode) or trim(ls_portcode) = '' then
		SELECT CAL_CALC_BALLAST_FROM
		INTO :ls_portcode
		FROM CAL_CALC
		WHERE CAL_CALC_FIX_ID = :id_fix_id AND CAL_CALC_STATUS = 4;//Fix calculation
	end if
end if

if isnull(ls_portcode) or trim(ls_portcode) = '' then
	setnull(is_est_bal)
else
	SELECT PORT_N
	INTO :is_est_bal
	FROM PORTS
	WHERE PORT_CODE = :ls_portcode;
end if

Return
end subroutine

public subroutine wf_copy_row_to_web (integer ai_from_row, integer ai_to_row);
dw_web_table.SetItem(ai_to_row,1,dw_report.GetItemString(ai_from_row,"compute_3"))
dw_web_table.SetItem(ai_to_row,2,dw_report.GetItemString(ai_from_row,"compute_1"))
dw_web_table.SetItem(ai_to_row,3,dw_report.GetItemString(ai_from_row,"compute_2"))
dw_web_table.SetItem(ai_to_row,4,dw_report.GetItemDatetime(ai_from_row,"compute_5"))
dw_web_table.SetItem(ai_to_row,5,dw_report.GetItemString(ai_from_row,"compute_6"))
dw_web_table.SetItem(ai_to_row,6,dw_report.GetItemString(ai_from_row,"compute_7"))
dw_web_table.SetItem(ai_to_row,7,dw_report.GetItemString(ai_from_row,"compute_8"))
dw_web_table.SetItem(ai_to_row,8,dw_report.GetItemString(ai_from_row,"compute_9"))
dw_web_table.SetItem(ai_to_row,9,dw_report.GetItemString(ai_from_row,"compute_10"))
dw_web_table.SetItem(ai_to_row,10,dw_report.GetItemString(ai_from_row,"compute_11"))
dw_web_table.SetItem(ai_to_row,11,dw_report.GetItemString(ai_from_row,"compute_12"))
dw_web_table.SetItem(ai_to_row,12,dw_report.GetItemString(ai_from_row,"compute_13"))
dw_web_table.SetItem(ai_to_row,13,dw_report.GetItemString(ai_from_row,"compute_14"))
dw_web_table.SetItem(ai_to_row,14,dw_report.GetItemDecimal(ai_from_row,"compute_15"))
dw_web_table.SetItem(ai_to_row,15,dw_report.GetItemDecimal(ai_from_row,"compute_16"))
dw_web_table.SetItem(ai_to_row,16,dw_report.GetItemDecimal(ai_from_row,"compute_17"))
dw_web_table.SetItem(ai_to_row,17,dw_report.GetItemDecimal(ai_from_row,"compute_18"))
dw_web_table.SetItem(ai_to_row,18,dw_report.GetItemDecimal(ai_from_row,"compute_19"))
dw_web_table.SetItem(ai_to_row,19,dw_report.GetItemDecimal(ai_from_row,"compute_20"))
dw_web_table.SetItem(ai_to_row,20,dw_report.GetItemDecimal(ai_from_row,"compute_4"))
dw_web_table.SetItem(ai_to_row,21,dw_report.GetItemDecimal(ai_from_row,"compute_21"))
dw_web_table.SetItem(ai_to_row,22,dw_report.GetItemDecimal(ai_from_row,"compute_22"))
dw_web_table.SetItem(ai_to_row,23,dw_report.GetItemDecimal(ai_from_row,"compute_23"))
dw_web_table.SetItem(ai_to_row,24,dw_report.GetItemDecimal(ai_from_row,"compute_24"))
dw_web_table.SetItem(ai_to_row,25,dw_report.GetItemDecimal(ai_from_row,"compute_25"))
dw_web_table.SetItem(ai_to_row,26,dw_report.GetItemDecimal(ai_from_row,"compute_26"))
dw_web_table.SetItem(ai_to_row,27,dw_report.GetItemDecimal(ai_from_row,"compute_27"))
dw_web_table.SetItem(ai_to_row,28,dw_report.GetItemDecimal(ai_from_row,"compute_28"))
dw_web_table.SetItem(ai_to_row,29,dw_report.GetItemDecimal(ai_from_row,"compute_29"))
dw_web_table.SetItem(ai_to_row,30,dw_report.GetItemDecimal(ai_from_row,"compute_30"))
dw_web_table.SetItem(ai_to_row,31,dw_report.GetItemDecimal(ai_from_row,"compute_31"))
dw_web_table.SetItem(ai_to_row,32,dw_report.GetItemDecimal(ai_from_row,"voyages_vessel_nr"))
dw_web_table.SetItem(ai_to_row,33,dw_report.GetItemString(ai_from_row,"compute_33"))
dw_web_table.SetItem(ai_to_row,34,dw_report.GetItemString(ai_from_row,"chart_name"))
dw_web_table.SetItem(ai_to_row,35,dw_report.GetItemString(ai_from_row,"contract_type"))
dw_web_table.SetItem(ai_to_row,36,dw_report.GetItemDatetime(ai_from_row,"arrival_first_loadport"))
dw_web_table.SetItem(ai_to_row,37,dw_report.GetItemDatetime(ai_from_row,"laycan_start"))
dw_web_table.SetItem(ai_to_row,38,dw_report.GetItemDatetime(ai_from_row,"laycan_end"))
dw_web_table.SetItem(ai_to_row,39,dw_report.GetItemString(ai_from_row,"chart_prev_voyage"))
dw_web_table.SetItem(ai_to_row,40,dw_report.GetItemNumber(ai_from_row,"days_from_last_disch_port"))
dw_web_table.SetItem(ai_to_row,41,dw_report.GetItemString(ai_from_row,"vessel_ref_nr"))


end subroutine

public subroutine wf_copy_row_to_report (integer ai_from_row, integer ai_to_row);
dw_report.SetItem(ai_to_row,"cal_calc_cal_calc_created_by",dw_web_table.GetItemString(ai_from_row,1))
dw_report.SetItem(ai_to_row,"vessels_vessel_name",dw_web_table.GetItemString(ai_from_row,2))
dw_report.SetItem(ai_to_row,"voyages_voyage_nr",dw_web_table.GetItemString(ai_from_row,3))
dw_report.SetItem(ai_to_row,"cal_cerp_cal_cerp_date",dw_web_table.GetItemDatetime(ai_from_row,4))
dw_report.SetItem(ai_to_row,"fix_bal",dw_web_table.GetItemString(ai_from_row,5))
dw_report.SetItem(ai_to_row,"fix_load",dw_web_table.GetItemString(ai_from_row,6))
dw_report.SetItem(ai_to_row,"fix_disch",dw_web_table.GetItemString(ai_from_row,7))
dw_report.SetItem(ai_to_row,"cal_bal",dw_web_table.GetItemString(ai_from_row,8))
dw_report.SetItem(ai_to_row,"cal_load",dw_web_table.GetItemString(ai_from_row,9))
dw_report.SetItem(ai_to_row,"cal_disch",dw_web_table.GetItemString(ai_from_row,10))
dw_report.SetItem(ai_to_row,"estact_bal",dw_web_table.GetItemString(ai_from_row,11))
dw_report.SetItem(ai_to_row,"estact_load",dw_web_table.GetItemString(ai_from_row,12))
dw_report.SetItem(ai_to_row,"estact_disch",dw_web_table.GetItemString(ai_from_row,13))
dw_report.SetItem(ai_to_row,"fix_days",dw_web_table.GetItemDecimal(ai_from_row,14))
dw_report.SetItem(ai_to_row,"fix_net_day",dw_web_table.GetItemDecimal(ai_from_row,15))
dw_report.SetItem(ai_to_row,"calc_days",dw_web_table.GetItemDecimal(ai_from_row,16))
dw_report.SetItem(ai_to_row,"calc_net_day",dw_web_table.GetItemDecimal(ai_from_row,17))
dw_report.SetItem(ai_to_row,"estact_days",dw_web_table.GetItemDecimal(ai_from_row,18))
dw_report.SetItem(ai_to_row,"estact_usdday",dw_web_table.GetItemDecimal(ai_from_row,19))
dw_report.SetItem(ai_to_row,"fix_port_expenses",dw_web_table.GetItemDecimal(ai_from_row,20))
dw_report.SetItem(ai_to_row,"calc_port_expenses",dw_web_table.GetItemDecimal(ai_from_row,21))
dw_report.SetItem(ai_to_row,"estact_portexp",dw_web_table.GetItemDecimal(ai_from_row,22))
dw_report.SetItem(ai_to_row,"usd_pr_bunker_ton",dw_web_table.GetItemDecimal(ai_from_row,23))
dw_report.SetItem(ai_to_row,"estact_bunker",dw_web_table.GetItemDecimal(ai_from_row,24))
dw_report.SetItem(ai_to_row,"loading_days",dw_web_table.GetItemDecimal(ai_from_row,25))
dw_report.SetItem(ai_to_row,"estact_loaddays",dw_web_table.GetItemDecimal(ai_from_row,26))
dw_report.SetItem(ai_to_row,"dicharging_days",dw_web_table.GetItemDecimal(ai_from_row,27))
dw_report.SetItem(ai_to_row,"estact_dischdays",dw_web_table.GetItemDecimal(ai_from_row,28))
dw_report.SetItem(ai_to_row,"demurrage",dw_web_table.GetItemDecimal(ai_from_row,29))
dw_report.SetItem(ai_to_row,"estact_demurrage",dw_web_table.GetItemDecimal(ai_from_row,30))
dw_report.SetItem(ai_to_row,"fix_demrate",dw_web_table.GetItemDecimal(ai_from_row,31))
dw_report.SetItem(ai_to_row,"voyages_vessel_nr",dw_web_table.GetItemDecimal(ai_from_row,32))
dw_report.SetItem(ai_to_row,"voyage_start",dw_web_table.GetItemString(ai_from_row,33))
dw_report.SetItem(ai_to_row,"chart_name",dw_web_table.GetItemString(ai_from_row,34))
dw_report.SetItem(ai_to_row,"contract_type",dw_web_table.GetItemString(ai_from_row,35))
dw_report.SetItem(ai_to_row,"arrival_first_loadport",dw_web_table.GetItemDatetime(ai_from_row,36))
dw_report.SetItem(ai_to_row,"laycan_start",dw_web_table.GetItemDatetime(ai_from_row,37))
dw_report.SetItem(ai_to_row,"laycan_end",dw_web_table.GetItemDatetime(ai_from_row,38))
dw_report.SetItem(ai_to_row,"chart_prev_voyage",dw_web_table.GetItemString(ai_from_row,39))
dw_report.SetItem(ai_to_row,"days_from_last_disch_port",dw_web_table.GetItemNumber(ai_from_row,40))
dw_report.SetItem(ai_to_row,"vessel_ref_nr",dw_web_table.GetItemString(ai_from_row,41))
dw_report.SetItem(ai_to_row,"cal_calc_cal_calc_fix_id",ai_to_row)

end subroutine

public function integer wf_getreport_data ();/* Declare local variables */
u_vas_control lu_vas_control
Decimal {0} ld_old_fix_id
Decimal {2} ld_bunker, ld_load_disch
Boolean lb_stopped
long ll_count, ll_number_of_voyages
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer li_key[], li_return, li_pre_vessel, li_cur_vessel
string ls_pre_voyage, ls_cur_voyage
	
/* Create user objects */
lu_vas_control = create u_vas_control

ll_number_of_voyages = dw_report.RowCount()

////////////////////////////
// Set Local Variables //
////////////////////////////
parm.title = "Generating Key Performance Report"
parm.cancel_window = w_key_performance_report
parm.cancel_event = "clicked"
OpenWithParm(w_progress, parm)

li_pre_vessel = 0
ls_pre_voyage = ""

// Loop through voyages and build data for report
// dw_vas_log is used as a dummy parameter for lu_vas_control
for ll_count = 1 to ll_number_of_voyages 
	yield()
	IF NOT(IsValid(w_progress)) THEN
		dw_report.Reset()
		st_report.text = ""
		lb_stopped = TRUE
		EXIT
	END IF	
		
	w_progress.wf_progress(ll_count/ll_number_of_voyages,"Generating Key Performance Report")
	// There are 3 rows for each vessel/voyage. Only get data one time for each vessel/voyage.
	id_fix_id = dw_report.GetItemDecimal(ll_count,"cal_calc_cal_calc_fix_id")
	IF NOT(dw_report.GetItemNumber(ll_count,"voyages_vessel_nr") > 0) THEN CONTINUE
	
	li_cur_vessel = dw_report.getitemnumber(ll_count, "voyages_vessel_nr")
	ls_cur_voyage = dw_report.getitemstring( ll_count, "voyages_voyage_nr")
//	ld_old_fix_id = id_fix_id

	// Get VAS data
	lstr_vessel_voyage_list[1].vessel_nr = dw_report.GetItemNumber(ll_count,"voyages_vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = dw_report.GetItemString(ll_count,"voyages_voyage_nr")
	li_return = lu_vas_control.of_master_control( 1,li_key[], lstr_vessel_voyage_list[], Integer(Right(sle_1.text,2)), dw_vas_report)
	
	// If VAS failed go to next voyage
	IF li_return = -1 THEN
		dw_report.SetItem(ll_count,"fix_bal","Missing data")
		CONTINUE
	END IF	
	
	// Insert VAS data into report
	dw_report.SetItem(ll_count,"voyage_start",String(lu_vas_control.of_getcommenced_date(),"dd/mm/yy"))
	
	if li_pre_vessel <> li_cur_vessel or ls_pre_voyage <> ls_cur_voyage then
		dw_report.SetItem(ll_count,"estact_days",dw_vas_report.GetItemDecimal(1,"est_act_days_total"))
		dw_report.SetItem(ll_count,"estact_usdday",dw_vas_report.GetItemDecimal(1,"est_act_result_before_drc_tc_pr_day"))
		dw_report.SetItem(ll_count,"fix_net_day",dw_vas_report.GetItemDecimal(1,"fixture_result_before_drc_tc_pr_day"))
		dw_report.SetItem(ll_count,"calc_net_day",dw_vas_report.GetItemDecimal(1,"calc_result_before_drc_tc_pr_day"))
		dw_report.SetItem(ll_count,"estact_portexp",ABS(dw_vas_report.GetItemDecimal(1,"est_act_port_exp")))
		
		ld_bunker = dw_vas_report.GetItemDecimal(1,"est_act_bunkers_fuel") + &
						dw_vas_report.GetItemDecimal(1,"est_act_bunkers_diesel") + &
						dw_vas_report.GetItemDecimal(1,"est_act_bunkers_gas") + &
						dw_vas_report.GetItemDecimal(1,"est_act_bunkers_lshfo")
		IF ld_bunker > 0 THEN
			dw_report.SetItem(ll_count,"estact_bunker", &
							 (dw_vas_report.GetItemDecimal(1,"est_act_bunker_fuel_exp") &
							+ dw_vas_report.GetItemDecimal(1,"est_act_bunker_diesel_exp")  &
							+ dw_vas_report.GetItemDecimal(1,"est_act_bunker_gas_exp") &
							+ dw_vas_report.GetItemDecimal(1,"est_act_bunker_lshfo_exp"))/ &
							 (ld_bunker))
		ELSE
			dw_report.SetItem(ll_count,"estact_bunker", 0)
		END IF
		
		// Add half of load dish to Load and half to Disch
		ld_load_disch = dw_vas_report.GetItemDecimal(1,"est_act_days_load_and_disch") * 0.5
		dw_report.SetItem(ll_count,"estact_loaddays",dw_vas_report.GetItemDecimal(1,"est_act_days_loading") + ld_load_disch)
		dw_report.SetItem(ll_count,"estact_dischdays",dw_vas_report.GetItemDecimal(1,"est_act_days_discharge") + ld_load_disch)
		dw_report.SetItem(ll_count,"estact_demurrage",dw_vas_report.GetItemDecimal(1,"est_act_dem_des"))
	end if
	
	// Ballast ports
	wf_get_ballast_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
	dw_report.SetItem(ll_count,"fix_bal",is_fix_bal)
	dw_report.SetItem(ll_count,"estact_bal",is_est_bal)
	dw_report.SetItem(ll_count,"cal_bal",is_cal_bal)
	
	// Load ports
	wf_get_load_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
	dw_report.SetItem(ll_count,"fix_load",is_fix_load)
	dw_report.SetItem(ll_count,"estact_load",is_est_load)
	dw_report.SetItem(ll_count,"cal_load",is_cal_load)
	// Set fix Demurrage rate from first load port on first cargo.
	// Value was set by wf_get_load_ports
	dw_report.SetItem(ll_count,"fix_demrate",is_demrate)
	
	// Disch ports
	wf_get_disch_port(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
	dw_report.SetItem(ll_count,"fix_disch",is_fix_disch)
	dw_report.SetItem(ll_count,"estact_disch",is_est_disch)
	dw_report.SetItem(ll_count,"cal_disch",is_cal_disch)
	
	// Set Other Calc data
	wf_setothercalcdata(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
	dw_report.SetItem(ll_count,"chart_name",is_chart)
	dw_report.SetItem(ll_count,"contract_type",is_contracttype)
	dw_report.SetItem(ll_count,"laycan_start",idt_laycan_start)
	dw_report.SetItem(ll_count,"laycan_end",idt_laycan_end)

	// Set Other Operations data
	wf_setotheroperationsdata(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr)
	dw_report.SetItem(ll_count,"arrival_first_loadport",idt_arrival )
	dw_report.SetItem(ll_count,"chart_prev_voyage",is_prev_chart)
	dw_report.SetItem(ll_count,"days_from_last_disch_port",id_days_ballast )
	
	// Clear voyage data
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].voyage_nr = ""
	
	li_pre_vessel = li_cur_vessel
	ls_pre_voyage = ls_cur_voyage	
next

IF IsValid(w_progress) THEN Close(w_progress)
Destroy lu_vas_control

IF lb_stopped THEN Return -1
Return 1
end function

private function integer wf_setothercalcdata (integer ai_vessel, string as_voyage);  SELECT top 1 CHART.CHART_N_1,   
		case CAL_CERP.CAL_CERP_CONTRACT_TYPE
			when 1 then "SPOT"
			when 2 then "COA Fixed rate"
			when 3 then "CVS Fixed rate"
			when 4 then "All"
			when 5 then "T/C Out"
			when 6 then "B/B Out"
			when 7 then "COA Market rate"
			when 8 then "CVS Market rate"
			else "N/A" end   
    INTO :is_chart,   
         :is_contracttype    
    FROM CAL_CALC,   
         CAL_CARG,   
         CAL_CERP,   
         CHART  
   WHERE CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID and  
         CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  and  
         CHART.CHART_NR = CAL_CERP.CHART_NR  and  
         CAL_CALC.CAL_CALC_VESSEL_ID = :ai_vessel  AND  
         CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id  AND  
         CAL_CALC.CAL_CALC_STATUS = 6 
ORDER BY CAL_CARG.CAL_CARG_TOTAL_UNITS DESC  ;
commit;

SELECT top 1 CAL_CARG.CAL_CARG_LAYCAN_START,   
         CAL_CARG.CAL_CARG_LAYCAN_END  
    INTO :idt_laycan_start ,   
         :idt_laycan_end  
    FROM CAL_CALC,   
         CAL_CARG,   
         CAL_CERP,   
         CHART  
   WHERE CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID and  
         CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  and  
         CHART.CHART_NR = CAL_CERP.CHART_NR  and  
         CAL_CALC.CAL_CALC_VESSEL_ID = :ai_vessel  AND  
         CAL_CALC.CAL_CALC_FIX_ID = :id_fix_id  AND  
         CAL_CALC.CAL_CALC_STATUS = 4 
ORDER BY CAL_CARG.CAL_CARG_TOTAL_UNITS DESC  ;
commit;

return 1
end function

private function integer wf_setotheroperationsdata (integer ai_vessel, string as_voyage);datetime		ldt_prev_departure
string			ls_prev_voyage
long 			ll_prev_calcid
boolean		lb_noload

SELECT TOP 1 PORT_ARR_DT 
	INTO :idt_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
		AND VOYAGE_NR = :as_voyage
		AND PURPOSE_CODE IN ("L", "L/D")
	ORDER BY PORT_ARR_DT ASC;
if sqlca.sqlcode = 100 then lb_noload = true              //no loadport registred
COMMIT;

SELECT TOP 1 PORT_DEPT_DT, VOYAGE_NR 
	INTO :ldt_prev_departure, :ls_prev_voyage
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
		AND VOYAGE_NR < :as_voyage
		AND PURPOSE_CODE IN ("D", "L/D")
	ORDER BY PORT_ARR_DT DESC;
COMMIT;

if isNull(ls_prev_voyage ) or ls_prev_voyage = "" then
	id_days_ballast = 0
	is_prev_chart = "No previous voyage..."
else
	if lb_noload then 
		setNull(id_days_ballast)
	else
		id_days_ballast = (f_datetime2long(idt_arrival) - f_datetime2long(ldt_prev_departure))/86400
	end if
	
	SELECT CAL_CALC_ID 
		INTO :ll_prev_calcid
		FROM VOYAGES
		WHERE VESSEL_NR = :ai_vessel
		AND VOYAGE_NR = :ls_prev_voyage;
	COMMIT;	
	SELECT top 1 CHART.CHART_N_1   
		INTO :is_prev_chart   
		FROM CAL_CARG,   
			CAL_CERP,   
			CHART  
		WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID  and  
			CHART.CHART_NR = CAL_CERP.CHART_NR  and  
			CAL_CARG.CAL_CALC_ID = :ll_prev_calcid
		ORDER BY CAL_CARG.CAL_CARG_TOTAL_UNITS DESC  ;
	COMMIT;
end if

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_key_performance_report	
   <OBJECT> 
	</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
    Date   Ref    Author        	Comments
  12/01/11	CR 2197	JMC	data object of uo_profitcenter was replaced
  01/09/14	CR3781	CCY018	The window title match with the text of a menu item.
  11/06/15	CR3989	CCY018	Fixed a bug.
  16/11/15	CR3250	CCY018	Add LSFO fuel in calculation module.
  22/01/16	CR4261	KSH092  fix a bug in function wf_get_ballast_port
********************************************************************/
end subroutine

on w_key_performance_report.create
this.sle_1=create sle_1
this.st_1=create st_1
this.cb_6=create cb_6
this.dw_web_table=create dw_web_table
this.st_report=create st_report
this.cb_5=create cb_5
this.dw_vas_report=create dw_vas_report
this.cb_4=create cb_4
this.dw_report=create dw_report
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_profitcenter=create uo_profitcenter
this.gb_1=create gb_1
this.Control[]={this.sle_1,&
this.st_1,&
this.cb_6,&
this.dw_web_table,&
this.st_report,&
this.cb_5,&
this.dw_vas_report,&
this.cb_4,&
this.dw_report,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.uo_profitcenter,&
this.gb_1}
end on

on w_key_performance_report.destroy
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.cb_6)
destroy(this.dw_web_table)
destroy(this.st_report)
destroy(this.cb_5)
destroy(this.dw_vas_report)
destroy(this.cb_4)
destroy(this.dw_report)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_profitcenter)
destroy(this.gb_1)
end on

event open;this.move(10,300)

postevent( "ue_postopen")


end event

type sle_1 from singlelineedit within w_key_performance_report
integer x = 224
integer y = 192
integer width = 197
integer height = 88
integer taborder = 20
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

type st_1 from statictext within w_key_performance_report
integer x = 27
integer y = 200
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

type cb_6 from commandbutton within w_key_performance_report
integer x = 224
integer y = 1400
integer width = 709
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save as"
end type

event clicked;Long ll_counter, ll_rows, ll_row
String ls_creator

ll_rows = dw_report.RowCount()

If NOT(ll_rows > 0) THEN 
	MessageBox("Information","There are no data to save ! Get old or create new data first.")
	Return
END IF	

dw_web_table.Reset()		
		
FOR ll_counter = 1 TO ll_rows
	ls_creator = dw_report.GetItemString(ll_counter,"compute_3")
	IF IsNull(ls_creator) OR NOT(LEN(ls_creator) > 0) THEN CONTINUE  
	ll_row = dw_web_table.InsertRow(0)
	wf_copy_row_to_web(ll_counter,ll_row)
NEXT

dw_web_table.SaveAs()
end event

type dw_web_table from datawindow within w_key_performance_report
boolean visible = false
integer x = 27
integer y = 1844
integer width = 146
integer height = 112
integer taborder = 20
string title = "none"
string dataobject = "d_web_pool_key_performance"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_report from statictext within w_key_performance_report
integer x = 32
integer y = 20
integer width = 1129
integer height = 76
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

type cb_5 from commandbutton within w_key_performance_report
boolean visible = false
integer x = 224
integer y = 1832
integer width = 709
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get old Report from Web table"
end type

event clicked;Long ll_row, ll_rows, ll_counter

IF NOT(Integer(sle_1.text) > 2000 AND Integer(sle_1.text) < 2099) THEN 
	MessageBox("Error","Please enter a valid year between 2000-2099.")
	Return
END IF

st_report.text = "Getting data. Please wait"
st_report.TextColor = RGB(255,0,0)


dw_web_table.Retrieve(right(sle_1.text,2))

dw_report.Reset()

ll_rows = dw_web_table.RowCount()


FOR ll_counter = 1 TO ll_rows
	ll_row = dw_report.InsertRow(0)
	wf_copy_row_to_report(ll_counter,ll_row)
NEXT	

ib_web = FALSE
st_report.TextColor = RGB(0,0,255)
st_report.text = "Old Report " + sle_1.text + " from web"
Beep(2)
	

end event

type dw_vas_report from datawindow within w_key_performance_report
boolean visible = false
integer x = 27
integer y = 1996
integer width = 142
integer height = 104
integer taborder = 20
string title = "none"
string dataobject = "d_vas_report_a4"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_key_performance_report
integer x = 224
integer y = 1184
integer width = 709
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create new &Report"
boolean default = true
end type

event clicked;Integer li_rows, li_counter, li_pcnr[], li_return
long ll_rc

IF NOT(Integer(sle_1.text) >= 2000 AND Integer(sle_1.text) < 2099) THEN 
	MessageBox("Error","Please enter a valid year between 2000-2099.")
	Return
END IF

w_key_performance_report.SetRedraw(FALSE)

li_rows = uo_profitcenter.dw_right.rowcount()
If NOT(li_rows > 0) THEN Return
For li_counter = 1 to li_rows
	li_pcnr[li_counter] = uo_profitcenter.dw_right.GetItemNumber(li_counter,"pc_nr")
Next
ll_rc = dw_report.Retrieve(li_pcnr, Right(sle_1.text,2))

is_year = sle_1.text
li_return = wf_getreport_data()

w_key_performance_report.SetRedraw(TRUE)

IF li_return = 1 THEN
	ib_web = TRUE
	st_report.text = "New Report created"
END IF

end event

type dw_report from datawindow within w_key_performance_report
integer x = 1170
integer y = 20
integer width = 3424
integer height = 2048
integer taborder = 10
string title = "none"
string dataobject = "d_pool_keyperf_pc_union"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_key_performance_report
boolean visible = false
integer x = 210
integer y = 1964
integer width = 709
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update Web table"
end type

event clicked;Long ll_counter, ll_rows, ll_row
String ls_creator

IF NOT(ib_web) THEN
	MessageBox("Information","You have no new generated data for update of WEB.")
	Return
END IF

IF MessageBox("Warning","All data in WEB table for year "+ is_year + " will be deleted and ~r~n " + &
			"substituted with these present data ! Continue ?",Exclamation!,YesNo!,2) = 1 THEN
	
	dw_web_table.Reset()
			
	DELETE FROM POOL_KEY_PERFORMANCE
	WHERE SUBSTRING(VOYAGE,1,2) = Substring(:is_year,3,2) ;
	Commit;
	IF SQLCA.SQLCode = 0 THEN
		ll_rows = dw_report.RowCount()
		
		FOR ll_counter = 1 TO ll_rows
			ls_creator = dw_report.GetItemString(ll_counter,"compute_3")
			IF IsNull(ls_creator) OR NOT(LEN(ls_creator) > 0) THEN CONTINUE  
			ll_row = dw_web_table.InsertRow(0)
			wf_copy_row_to_web(ll_counter,ll_row)
		NEXT
		
		IF dw_web_table.Update() = 1 THEN
			Commit;
		ELSE
			Rollback;
			MessageBox("Error","Update of WEB table failed. Old data still valid")
		END IF
	ELSE
		Rollback;
		MessageBox("ERROR","Delete of WEB table failed. Old data still valid.")
		Return
	END IF	
	ib_web = FALSE
END IF

end event

type cb_2 from commandbutton within w_key_performance_report
integer x = 224
integer y = 1292
integer width = 709
integer height = 100
integer taborder = 20
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

type cb_1 from commandbutton within w_key_performance_report
integer x = 224
integer y = 1508
integer width = 709
integer height = 100
integer taborder = 10
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

type uo_profitcenter from u_drag_drop_boxes within w_key_performance_report
integer x = 14
integer y = 316
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

type gb_1 from groupbox within w_key_performance_report
integer x = 5
integer y = 104
integer width = 1161
integer height = 964
integer taborder = 80
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

