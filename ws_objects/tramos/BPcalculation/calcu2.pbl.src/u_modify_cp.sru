$PBExportHeader$u_modify_cp.sru
$PBExportComments$This object controlls all the changes that has to be done when the user changes the CP
forward
global type u_modify_cp from mt_n_nonvisualobject
end type
end forward

global type u_modify_cp from mt_n_nonvisualobject
end type
global u_modify_cp u_modify_cp

type variables
string 	is_message = ""
long		il_cpid
integer	ii_cpModifyLevel
boolean 	ib_recalc_acomm, ib_brokermodified

mt_n_datastore	ids_voyages, ids_calculations


end variables

forward prototypes
private function integer of_setbasecpmodifylevel (ref datawindow adw_cpdata)
private function integer of_changecharterer (integer ai_vessel, string as_voyage, long al_oldcharterer, long al_newcharterer)
private function integer of_recalcopsadrcomm (integer ai_vessel, string as_voyage, long al_chart)
private function boolean of_settlebalanceok (integer ai_vessel, string as_voyage, long al_chart, long al_broker)
private function integer of_addbroker (integer ai_vessel, string as_voyage, long al_chart, long al_broker)
private function integer of_getclaimamount (integer ai_vessel, string as_voyage, long al_chart, long al_claimnr, string as_claimtype, ref decimal ad_amount)
public function integer of_recalccalculations (long al_calcid)
private subroutine documentation ()
public function integer _getopencalcs (ref w_atobviac_calc_calculation aw_opencalcs[], long al_calc_id)
private function integer of_recalcbrokercomm (integer ai_vessel, string as_voyage, long al_chart, ref u_datawindow_sqlca adw_broker)
private function integer of_calcclaimcommission (integer ai_vessel, string as_voyage, long al_chart, u_datawindow_sqlca adw_broker, decimal ad_commpct)
private function integer _modifyoperations (ref u_datawindow_sqlca adw_broker, ref u_datawindow_sqlca adw_cpdata, ref w_atobviac_calc_calculation aw_opencalcs[], ref string as_message, ref s_vessel_voyage_chart_claim astr_openedclaim, ref s_vessel_voyage_chart_claim astr_openedactiontransaction, ref s_vessel_voyage_chart_claim astr_openedlaytime)
private function integer of_changeclaim (integer ai_vessel, string as_voyage, ref datawindow adw_cpdata, ref s_vessel_voyage_chart_claim astr_openedclaim, ref s_vessel_voyage_chart_claim astr_openedactiontransaction, ref s_vessel_voyage_chart_claim astr_openedlaytime)
private function integer _validatecp (ref u_datawindow_sqlca adw_brokerdata, u_datagrid adw_charerter, ref u_datawindow_sqlca adw_cpdata, ref long al_cpno)
public function integer of_updatecp (ref u_datawindow_sqlca adw_brokerdata, u_datagrid adw_charerter, ref u_datawindow_sqlca adw_cpdata, ref long al_cpno, string as_userprompt)
public function integer of_checksettlement (long as_cerpid, ref string as_msg)
end prototypes

private function integer of_setbasecpmodifylevel (ref datawindow adw_cpdata);/*	This function checks for which level of update to do on Base CP (not Broker Comm). 
	There are three levels of updates and an option for recalc:
	
		1 - Only CP  (City, Contract type)
		2 - CP and Claims (Office, Description, Date, Timebar, Noticebar, Addr.comm) with an option on comm.percentage ib_recalc
		3 - CP, Cargo and Claims (Charterer)
		4 - Only Broker
		
*/
ii_cpmodifylevel = 0   //nothing to modify

if adw_cpdata.getItemStatus(1, "chart_nr", Primary!) = dataModified! then 
	ii_cpmodifylevel = 3
	goto checkrecalc
end if	

if adw_cpdata.getItemStatus(1, "cal_cerp_cal_cerp_office_nr", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_description", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_date", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_timebar_days", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_noticebar_days", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_add_comm", Primary!) = dataModified! then 
	ii_cpmodifylevel = 2
	goto checkrecalc
end if	

if adw_cpdata.getItemStatus(1, "cal_cerp_city", Primary!) = dataModified! &
or adw_cpdata.getItemStatus(1, "cal_cerp_contract_type", Primary!) = dataModified! then
	ii_cpmodifylevel = 1
	goto checkrecalc
end if	

checkrecalc:
if (ii_cpmodifylevel = 0 or ii_cpmodifylevel = 1) and ib_brokermodified then
	ii_cpmodifylevel = 4
end if

if adw_cpdata.getItemStatus(1, "cal_cerp_add_comm", Primary!) = dataModified! then 
	ib_recalc_acomm = true
end if	

return 1
end function

private function integer of_changecharterer (integer ai_vessel, string as_voyage, long al_oldcharterer, long al_newcharterer);/* This function duplicates all cargo and claim informations, and deletes the old ones */

string	ls_errmsg

/* Update CARGO */
UPDATE CARGO SET CHART_NR = :al_newcharterer WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND CHART_NR = :al_oldcharterer ;
if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE CD SET CHART_NR = :al_newcharterer WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND CHART_NR = :al_oldcharterer ;
if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE BOL SET CHART_NR = :al_newcharterer WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND CHART_NR = :al_oldcharterer ;
if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

/* Update CLAIMS */
INSERT INTO CLAIMS  
	( CHART_NR,   
	VESSEL_NR,   
	VOYAGE_NR,   
	CLAIM_NR,   
	BROKER_NR,   
	CLAIM_TYPE,   
	CURR_CODE,   
	OFFICE_NR,   
	DISCHARGE_DATE,   
	CP_DATE,   
	CP_TEXT,   
	TIMEBAR_DAYS,   
	TIMEBAR_DATE,   
	NOTICE_DATE,   
	NOTICE_DAYS,   
	FORWARDING_DATE,   
	CLAIM_AMOUNT,   
	CLAIM_AMOUNT_USD,   
	LAYCAN_START,   
	LAYCAN_END,   
	BROKER_COM,   
	ADDRESS_COM,   
	EXPECT_RECEIVE_PCT,   
	EXPECT_RECEIVE_DATE,   
	CLAIM_IN_LOG,   
	CP_ID_COMM,   
	CREATED_BY,
	ORIG_CLAIM_AMOUNT_USD,
	CLAIM_SENT,
	BROKER_CONFIRMED,
	CHARTERER_CONFIRMED,
	STATUS,
	STATUS_DATE,
	CLAIM_EMAIL,
	MSPS_TFV,
	CLAIM_COMMENT,
	INVOICE_NR,
	LOCKED,
	POOL_MANAGER_COMMISSION,
	BROKER_COMMISSION,
	AX_INVOICE_TEXT_FLAG,
	AX_INVOICE_TEXT, 
	CLAIM_AMOUNT_AX, 
	ADDRESS_COM_AX, 
	CLAIM_SENT_DATE, 
	BROKER_CONFIRMED_DATE, 
	CHARTERER_CONFIRMED_DATE, 
	CLAIM_PERCENTAGE, 
	SHOW_IN_VAS, 
	CAL_CERP_ID, 
	CHART_NR_PRINTED
	)  
SELECT :al_newcharterer,   
	CLAIMS.VESSEL_NR,   
	CLAIMS.VOYAGE_NR,   
	CLAIMS.CLAIM_NR,   
	CLAIMS.BROKER_NR,   
	CLAIMS.CLAIM_TYPE,   
	CLAIMS.CURR_CODE,   
	CLAIMS.OFFICE_NR,   
	CLAIMS.DISCHARGE_DATE,   
	CLAIMS.CP_DATE,   
	CLAIMS.CP_TEXT,   
	CLAIMS.TIMEBAR_DAYS,   
	CLAIMS.TIMEBAR_DATE,   
	CLAIMS.NOTICE_DATE,   
	CLAIMS.NOTICE_DAYS,   
	CLAIMS.FORWARDING_DATE,   
	CLAIMS.CLAIM_AMOUNT,   
	CLAIMS.CLAIM_AMOUNT_USD,   
	CLAIMS.LAYCAN_START,   
	CLAIMS.LAYCAN_END,   
	CLAIMS.BROKER_COM,   
	CLAIMS.ADDRESS_COM,   
	CLAIMS.EXPECT_RECEIVE_PCT,   
	CLAIMS.EXPECT_RECEIVE_DATE,   
	CLAIMS.CLAIM_IN_LOG,   
	CLAIMS.CP_ID_COMM,   
	CLAIMS.CREATED_BY,
	CLAIMS.ORIG_CLAIM_AMOUNT_USD,
	CLAIMS.CLAIM_SENT,
	CLAIMS.BROKER_CONFIRMED,
	CLAIMS.CHARTERER_CONFIRMED,
	CLAIMS.STATUS,
	CLAIMS.STATUS_DATE,
	CLAIMS.CLAIM_EMAIL,
	CLAIMS.MSPS_TFV,
	CLAIMS.CLAIM_COMMENT,
	INVOICE_NR,
	LOCKED,
	POOL_MANAGER_COMMISSION,
	BROKER_COMMISSION,
	AX_INVOICE_TEXT_FLAG,
	AX_INVOICE_TEXT, 
	CLAIM_AMOUNT_AX, 
	ADDRESS_COM_AX, 
	CLAIM_SENT_DATE, 
	BROKER_CONFIRMED_DATE, 
	CHARTERER_CONFIRMED_DATE, 
	CLAIM_PERCENTAGE, 
	SHOW_IN_VAS, 
	CAL_CERP_ID, 
	CHART_NR_PRINTED
FROM CLAIMS 
WHERE CLAIMS.VESSEL_NR = :ai_vessel   
AND CLAIMS.VOYAGE_NR = :as_voyage
AND CLAIMS.CHART_NR = :al_oldcharterer ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE CLAIM_ACTION SET CHART_NR = :al_newcharterer WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND CHART_NR = :al_oldcharterer ;
if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE CLAIM_TRANSACTION SET CHART_NR = :al_newcharterer WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND CHART_NR = :al_oldcharterer ;
if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

INSERT INTO FREIGHT_CLAIMS  
	( CHART_NR,   
	  VESSEL_NR,   
	  VOYAGE_NR,   
	  CLAIM_NR,   
	  CAL_CERP_ID,   
	  FREIGHT_WS,   
	  FREIGHT_PER_MTS,   
	  FREIGHT_WS_RATE,   
	  FREIGHT_A_COM,   
	  FREIGHT_B_COM,   
	  FREIGHT_MIN_1,   
	  FREIGHT_MIN_2,   
	  FREIGHT_OVERAGE_1,   
	  FREIGHT_OVERAGE_2,   
	  BOL_LOAD_QUANTITY,   
	  LUMPSUM_COMMISSION,  
	  FREIGHT_MAIN_LUMPSUM )  
SELECT :al_newcharterer,   
		FREIGHT_CLAIMS.VESSEL_NR,   
		FREIGHT_CLAIMS.VOYAGE_NR,   
		FREIGHT_CLAIMS.CLAIM_NR,   
		FREIGHT_CLAIMS.CAL_CERP_ID,   
		FREIGHT_CLAIMS.FREIGHT_WS,   
		FREIGHT_CLAIMS.FREIGHT_PER_MTS,   
		FREIGHT_CLAIMS.FREIGHT_WS_RATE,   
		FREIGHT_CLAIMS.FREIGHT_A_COM,   
		FREIGHT_CLAIMS.FREIGHT_B_COM,   
		FREIGHT_CLAIMS.FREIGHT_MIN_1,   
		FREIGHT_CLAIMS.FREIGHT_MIN_2,   
		FREIGHT_CLAIMS.FREIGHT_OVERAGE_1,   
		FREIGHT_CLAIMS.FREIGHT_OVERAGE_2,   
		FREIGHT_CLAIMS.BOL_LOAD_QUANTITY,   
		FREIGHT_CLAIMS.LUMPSUM_COMMISSION,   
		FREIGHT_CLAIMS.FREIGHT_MAIN_LUMPSUM  
 FROM FREIGHT_CLAIMS  
WHERE ( FREIGHT_CLAIMS.VESSEL_NR = :ai_vessel ) AND  
		( FREIGHT_CLAIMS.VOYAGE_NR = :as_voyage ) AND  
		( FREIGHT_CLAIMS.CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE FREIGHT_CLAIM_ADD_LUMPSUMS SET CHART_NR= :al_newcharterer 
WHERE VESSEL_NR = :ai_vessel  AND  
		  VOYAGE_NR = :as_voyage  AND  
		  CHART_NR = :al_oldcharterer;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE FREIGHT_RECEIVED SET CHART_NR= :al_newcharterer 
WHERE VESSEL_NR = :ai_vessel  AND  
		  VOYAGE_NR = :as_voyage  AND  
		  CHART_NR = :al_oldcharterer;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM FREIGHT_CLAIM_ADD_LUMPSUMS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM FREIGHT_CLAIMS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

/* DEMURRAGE claims */
  INSERT INTO DEM_DES_CLAIMS  
         ( CHART_NR,   
           VESSEL_NR,   
           VOYAGE_NR,   
           CLAIM_NR,   
           PORT_CODE,   
           DEM_DES_PURPOSE,   
           CAL_CERP_ID,   
           CAL_CAIO_ID,   
           LOAD_LAYTIME_ALLOWED,   
           DISCH_LAYTIME_ALLOWED,   
           LOAD_DAILY_RATE,   
           DISCH_DAILY_RATE,   
           TERMS_DESC,   
           COM_ON_DEM,   
           BOL_LOAD_QUANTITY,   
           LOAD_HOURLY_RATE,   
           DISCH_HOURLY_RATE,   
           DEM_DES_SETTLED,   
           PRINT_BOL_DATE_TEXT,   
           PRINT_PRODUCT_TEXT )  
     SELECT :al_newcharterer,   
            DEM_DES_CLAIMS.VESSEL_NR,   
            DEM_DES_CLAIMS.VOYAGE_NR,   
            DEM_DES_CLAIMS.CLAIM_NR,   
            DEM_DES_CLAIMS.PORT_CODE,   
            DEM_DES_CLAIMS.DEM_DES_PURPOSE,   
            DEM_DES_CLAIMS.CAL_CERP_ID,   
            DEM_DES_CLAIMS.CAL_CAIO_ID,   
            DEM_DES_CLAIMS.LOAD_LAYTIME_ALLOWED,   
            DEM_DES_CLAIMS.DISCH_LAYTIME_ALLOWED,   
            DEM_DES_CLAIMS.LOAD_DAILY_RATE,   
            DEM_DES_CLAIMS.DISCH_DAILY_RATE,   
            DEM_DES_CLAIMS.TERMS_DESC,   
            DEM_DES_CLAIMS.COM_ON_DEM,   
            DEM_DES_CLAIMS.BOL_LOAD_QUANTITY,   
            DEM_DES_CLAIMS.LOAD_HOURLY_RATE,   
            DEM_DES_CLAIMS.DISCH_HOURLY_RATE,   
            DEM_DES_CLAIMS.DEM_DES_SETTLED,   
            DEM_DES_CLAIMS.PRINT_BOL_DATE_TEXT,   
            DEM_DES_CLAIMS.PRINT_PRODUCT_TEXT  
       FROM DEM_DES_CLAIMS  
      WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :ai_vessel ) AND  
            ( DEM_DES_CLAIMS.VOYAGE_NR = :as_voyage ) AND  
            ( DEM_DES_CLAIMS.CHART_NR = :al_oldcharterer ); 

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE DEM_DES_RATES SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM DEM_DES_CLAIMS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

  INSERT INTO FREIGHT_ADVANCED  
         ( CHART_NR,   
           VESSEL_NR,   
           VOYAGE_NR,   
           CLAIM_NR,   
           AFC_NR,   
           CAL_CERP_ID,   
           CAL_CAIO_ID,   
           AFC_AGENT_NR,   
           AFC_PORT_CODE,   
           AFC_PCN,   
           AFC_LAYOUT,   
           AFC_GRADE_NAME,   
           AFC_BOL_NR,   
           AFC_BOL_QUANTITY,   
           AFC_WS,   
           AFC_PER_MTS,   
           AFC_WS_RATE,   
           AFC_MIN_1,   
           AFC_MIN_2,   
           AFC_OVERAGE_1,   
           AFC_OVERAGE_2,   
           AFC_FREIGHT_NET,   
           AFC_LUMPSUM_COMMISSION,  
           AFC_LUMPSUM_TEXT,   
           AFC_MAIN_LUMPSUM )  
     SELECT :al_newcharterer,   
            FREIGHT_ADVANCED.VESSEL_NR,   
            FREIGHT_ADVANCED.VOYAGE_NR,   
            FREIGHT_ADVANCED.CLAIM_NR,   
            FREIGHT_ADVANCED.AFC_NR,   
            FREIGHT_ADVANCED.CAL_CERP_ID,   
            FREIGHT_ADVANCED.CAL_CAIO_ID,   
            FREIGHT_ADVANCED.AFC_AGENT_NR,   
            FREIGHT_ADVANCED.AFC_PORT_CODE,   
            FREIGHT_ADVANCED.AFC_PCN,   
            FREIGHT_ADVANCED.AFC_LAYOUT,   
            FREIGHT_ADVANCED.AFC_GRADE_NAME,   
            FREIGHT_ADVANCED.AFC_BOL_NR,   
            FREIGHT_ADVANCED.AFC_BOL_QUANTITY,   
            FREIGHT_ADVANCED.AFC_WS,   
            FREIGHT_ADVANCED.AFC_PER_MTS,   
            FREIGHT_ADVANCED.AFC_WS_RATE,   
            FREIGHT_ADVANCED.AFC_MIN_1,   
            FREIGHT_ADVANCED.AFC_MIN_2,   
            FREIGHT_ADVANCED.AFC_OVERAGE_1,   
            FREIGHT_ADVANCED.AFC_OVERAGE_2,   
            FREIGHT_ADVANCED.AFC_FREIGHT_NET,   
           FREIGHT_ADVANCED.AFC_LUMPSUM_COMMISSION,   
            FREIGHT_ADVANCED.AFC_LUMPSUM_TEXT,   
            FREIGHT_ADVANCED.AFC_MAIN_LUMPSUM  
       FROM FREIGHT_ADVANCED  
	WHERE FREIGHT_ADVANCED.VESSEL_NR = :ai_vessel   
      AND FREIGHT_ADVANCED.VOYAGE_NR = :as_voyage   
	AND FREIGHT_ADVANCED.CHART_NR = :al_oldcharterer ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE FREIGHT_ADVANCED_RECIEVED SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer );

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE FREIGHT_ADVANCED_ADD_LUMPSUMS SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer );

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM FREIGHT_ADVANCED_ADD_LUMPSUMS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;				

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM FREIGHT_ADVANCED
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE HEA_DEV_CLAIMS SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer );

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE COMMISSIONS SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

//Update PAYMENT_ID according to CLAIM_ID
UPDATE TRANS_LOG_MAIN_A
   SET TRANS_LOG_MAIN_A.PAYMENT_ID = CLAIMS_NEW.CLAIM_ID
  FROM CLAIMS AS CLAIMS_OLD, CLAIMS AS CLAIMS_NEW
 WHERE CLAIMS_OLD.VESSEL_NR = CLAIMS_NEW.VESSEL_NR AND
       CLAIMS_OLD.VOYAGE_NR = CLAIMS_NEW.VOYAGE_NR AND
       CLAIMS_OLD.CLAIM_NR  = CLAIMS_NEW.CLAIM_NR  AND
       CLAIMS_OLD.CHART_NR  = :al_oldcharterer AND
       CLAIMS_NEW.CHART_NR  = :al_newcharterer AND
       CLAIMS_OLD.VESSEL_NR = :ai_vessel AND
       CLAIMS_OLD.VOYAGE_NR = :as_voyage AND
       CLAIMS_OLD.CLAIM_ID  = TRANS_LOG_MAIN_A.PAYMENT_ID AND
       TRANS_LOG_MAIN_A.TRANS_TYPE = 'Claims';

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

//Update LINK_ID according to CLAIM_ID
UPDATE TRANS_LOG_MAIN_A
   SET TRANS_LOG_MAIN_A.LINK_ID = CLAIMS_NEW.CLAIM_ID
  FROM CLAIMS AS CLAIMS_OLD, CLAIMS AS CLAIMS_NEW
 WHERE CLAIMS_OLD.VESSEL_NR = CLAIMS_NEW.VESSEL_NR AND
       CLAIMS_OLD.VOYAGE_NR = CLAIMS_NEW.VOYAGE_NR AND
       CLAIMS_OLD.CLAIM_NR  = CLAIMS_NEW.CLAIM_NR  AND
       CLAIMS_OLD.CHART_NR  = :al_oldcharterer AND
       CLAIMS_NEW.CHART_NR  = :al_newcharterer AND
       CLAIMS_OLD.VESSEL_NR = :ai_vessel AND
       CLAIMS_OLD.VOYAGE_NR = :as_voyage AND
       CLAIMS_OLD.CLAIM_ID  = TRANS_LOG_MAIN_A.LINK_ID AND
       TRANS_LOG_MAIN_A.TRANS_TYPE = 'Claims';

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE CLAIM_SENT 
   SET CHART_NR = :al_newcharterer 
 WHERE CHART_NR = :al_oldcharterer
   AND VESSEL_NR = :ai_vessel 
   AND VOYAGE_NR = :as_voyage;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM CLAIMS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

/* laytime statements update */
INSERT INTO LAYTIME_STATEMENTS  
         ( PORT_CODE,   
           VESSEL_NR,   
           VOYAGE_NR,   
           PCN,   
           CHART_NR,   
           LAY_EVENT_T1,   
           LAY_EVENT_D_1,   
           LAY_EVENT_T2,   
           LAY_EVENT_D_2,   
           LAY_EVENT_T3,   
           LAY_EVENT_D_3,   
           LAY_COMMENCED,   
           LAY_COMPLETED,   
           LAY_FINISH,   
           LAY_MINUTES )  
     SELECT LAYTIME_STATEMENTS.PORT_CODE,   
            LAYTIME_STATEMENTS.VESSEL_NR,   
            LAYTIME_STATEMENTS.VOYAGE_NR,   
            LAYTIME_STATEMENTS.PCN,   
            :al_newcharterer,   
            LAYTIME_STATEMENTS.LAY_EVENT_T1,   
            LAYTIME_STATEMENTS.LAY_EVENT_D_1,   
            LAYTIME_STATEMENTS.LAY_EVENT_T2,   
            LAYTIME_STATEMENTS.LAY_EVENT_D_2,   
            LAYTIME_STATEMENTS.LAY_EVENT_T3,   
            LAYTIME_STATEMENTS.LAY_EVENT_D_3,   
            LAYTIME_STATEMENTS.LAY_COMMENCED,   
            LAYTIME_STATEMENTS.LAY_COMPLETED,   
            LAYTIME_STATEMENTS.LAY_FINISH,   
            LAYTIME_STATEMENTS.LAY_MINUTES  
       FROM LAYTIME_STATEMENTS  
      WHERE ( LAYTIME_STATEMENTS.VESSEL_NR = :ai_vessel ) AND  
            ( LAYTIME_STATEMENTS.VOYAGE_NR = :as_voyage ) AND  
            ( LAYTIME_STATEMENTS.CHART_NR = :al_oldcharterer )  ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

 INSERT INTO LAY_DEDUCTIONS  
         ( VESSEL_NR,   
           VOYAGE_NR,   
           PORT_CODE,   
           PCN,   
           CHART_NR,   
           REASON_NR,   
           REASON,   
           GR_DEDUCTIONS,   
           REASON_START,   
           REASON_END,   
           DEDUCTION_PCT,   
           DEDUCTION_MINUTES )  
     SELECT LAY_DEDUCTIONS.VESSEL_NR,   
            LAY_DEDUCTIONS.VOYAGE_NR,   
            LAY_DEDUCTIONS.PORT_CODE,   
            LAY_DEDUCTIONS.PCN,   
            :al_newcharterer,   
            LAY_DEDUCTIONS.REASON_NR,   
            LAY_DEDUCTIONS.REASON,   
            LAY_DEDUCTIONS.GR_DEDUCTIONS,   
            LAY_DEDUCTIONS.REASON_START,   
            LAY_DEDUCTIONS.REASON_END,   
            LAY_DEDUCTIONS.DEDUCTION_PCT,   
            LAY_DEDUCTIONS.DEDUCTION_MINUTES  
       FROM LAY_DEDUCTIONS  
      WHERE (LAY_DEDUCTIONS.VESSEL_NR = :ai_vessel ) AND  
            (LAY_DEDUCTIONS.VOYAGE_NR = :as_voyage ) AND  
            (LAY_DEDUCTIONS.CHART_NR = :al_oldcharterer )  ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

UPDATE GROUP_DEDUCTIONS SET CHART_NR= :al_newcharterer 
WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM LAY_DEDUCTIONS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ; 

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM LAYTIME_STATEMENTS
      WHERE ( VESSEL_NR = :ai_vessel ) AND  
            ( VOYAGE_NR = :as_voyage ) AND  
            ( CHART_NR = :al_oldcharterer ) ; 

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

DELETE FROM CLAIMS 
WHERE CLAIMS.VESSEL_NR = :ai_vessel   
AND CLAIMS.VOYAGE_NR = :as_voyage
AND CLAIMS.CHART_NR = :al_oldcharterer ;

if sqlca.sqlcode < 0 then
	ls_errmsg = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errmsg, stopsign!)
	return c#return.Failure
end if

return 1

end function

private function integer of_recalcopsadrcomm (integer ai_vessel, string as_voyage, long al_chart);u_addr_commission 	lnv_acomm
uo_freight_balance	lnv_frt
n_ds						lds_data
long						ll_rows, ll_row, ll_claimnr
decimal {2}				ld_frtbalance, ld_frtbalance_usd
n_claimcurrencyadjust lnv_claimcurrencyadjust

lds_data = create 		n_ds
lds_data.dataObject = "d_sq_tb_claim_number"
lds_data.setTransObject(sqlca)

ll_rows = lds_data.retrieve( ai_vessel, as_voyage, al_chart)

if ll_rows > 0 then 
	lnv_acomm 	= create u_addr_commission
	lnv_frt		= create uo_freight_balance
end if

for ll_row = 1 to ll_rows
	ll_claimnr =  lds_data.getItemNumber(ll_row, "claim_nr")
	if lds_data.getItemString(ll_row, "claim_type") = "FRT" then
		ld_frtbalance = lnv_frt.uf_calculate_balance( ai_vessel, as_voyage, al_chart, ll_claimnr)
		lnv_claimcurrencyadjust.of_getclaimamounts( ai_vessel, as_voyage, al_chart, ll_claimnr, ld_frtbalance, ld_frtbalance_usd, false)
		update CLAIMS 
			set CLAIM_AMOUNT = :ld_frtbalance,
				CLAIM_AMOUNT_USD = :ld_frtbalance_usd
			WHERE VESSEL_NR = :ai_vessel
			AND VOYAGE_NR = :as_voyage
			AND CHART_NR = :al_chart
			AND CLAIM_NR = :ll_claimnr;
	else
		lnv_acomm.of_add_com( ai_vessel, as_voyage, al_chart,ll_claimnr )
	end if
next

if isValid(lnv_acomm) then destroy lnv_acomm
if isValid(lnv_frt) then destroy lnv_frt
destroy lds_data

return 1
end function

private function boolean of_settlebalanceok (integer ai_vessel, string as_voyage, long al_chart, long al_broker);/* This function checks if it is OK to modify broker informations in CP
	only allowed for settled commissions when balance is 0
	unsettled commissions just change  */

long ll_count

SELECT count(*)
	INTO :ll_count
	FROM COMMISSIONS
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND CHART_NR = :al_chart
	AND BROKER_NR = :al_broker
	AND COMM_SETTLED = 1;
if ll_count > 0 then
	SELECT SUM(COMM_AMOUNT)
		INTO :ll_count
		FROM COMMISSIONS
		WHERE VESSEL_NR = :ai_vessel
		AND VOYAGE_NR = :as_voyage
		AND CHART_NR = :al_chart
		AND BROKER_NR = :al_broker
		AND COMM_SETTLED = 1;
	if isnull(ll_count) then ll_count = 0
	if ll_count <> 0 then
		MessageBox("Error", "You are not allowed to change/delete Broker if settled commission balance <> 0 (zero)")
		return false
	end if
end if

return true

end function

private function integer of_addbroker (integer ai_vessel, string as_voyage, long al_chart, long al_broker);n_ds						lds_data
long						ll_rows, ll_row, ll_claimnr

lds_data = create 		n_ds
lds_data.dataObject = "d_sq_tb_claim_number"
lds_data.setTransObject(sqlca)
ll_rows = lds_data.retrieve( ai_vessel, as_voyage, al_chart)
for ll_row = 1 to ll_rows
	ll_claimnr = lds_data.getItemNumber(ll_row, "claim_nr")
	INSERT 
		INTO COMMISSIONS
		VALUES (:al_broker,
			:al_chart,
			:ai_vessel,
			:as_voyage,
			:ll_claimnr,
			"DO NOT SETTLE CP",
			0,
			0,
			NULL,
			NULL,
			"Auto",
			2);
next		

destroy lds_data

return 1
end function

private function integer of_getclaimamount (integer ai_vessel, string as_voyage, long al_chart, long al_claimnr, string as_claimtype, ref decimal ad_amount);decimal ld_amount, ld_trans_amount, ld_claim_amount, ld_received_amount, ld_addrcomm, ld_balance, ld_brocomm, ld_add_lumpsum, ld_add_lump_all
datastore lds_add_lumpsums
int li_add_lump, li_adrcomm_add_lumpsum

SELECT IsNull(Sum(C_TRANS_AMOUNT),0)  
INTO :ld_trans_amount  
FROM CLAIM_TRANSACTION  
WHERE VESSEL_NR = :ai_vessel 
	AND VOYAGE_NR = :as_voyage 
	AND CHART_NR = :al_chart 
	AND CLAIM_NR = :al_claimnr 
	AND (C_TRANS_CODE = "A" OR C_TRANS_CODE = "W" )  ;

CHOOSE CASE as_claimtype
	CASE "HEA", "DEV"
		SELECT isnull((HEA_DEV_HOURS*(HEA_DEV_PRICE_PR_DAY/24)),0) as AMOUNT
		INTO :ld_amount  
		FROM HEA_DEV_CLAIMS  
		WHERE VESSEL_NR = :ai_vessel 
			AND VOYAGE_NR = :as_voyage 
			AND CHART_NR = :al_chart 
			AND CLAIM_NR = :al_claimnr; 
		ld_amount -= ld_trans_amount
				
	CASE "DEM" 
		SELECT CLAIM_AMOUNT_USD  
		INTO :ld_amount  
		FROM CLAIMS  
		WHERE VESSEL_NR = :ai_vessel 
			AND VOYAGE_NR = :as_voyage 
			AND CHART_NR = :al_chart 
			AND CLAIM_NR = :al_claimnr ;
		ld_amount -= ld_trans_amount		
	
	CASE "FRT"
		SELECT ABS(CL.CLAIM_AMOUNT_USD  - 
			ISNULL((SELECT SUM(CT.C_TRANS_AMOUNT_USD) 
			FROM CLAIM_TRANSACTION CT 
			WHERE CT.VESSEL_NR = CL.VESSEL_NR
			AND CT.VOYAGE_NR = CL.VOYAGE_NR
			AND CT.CHART_NR = CL.CHART_NR
			AND CT.CLAIM_NR = CL.CLAIM_NR),0))
		INTO :ld_balance
		FROM CLAIMS CL
		WHERE CL.VESSEL_NR = :ai_vessel  AND  
			CL.CHART_NR = :al_chart  AND  
			CL.CLAIM_NR = :al_claimnr AND  
			CL.VOYAGE_NR = :as_voyage AND  
			CL.CLAIM_TYPE = :as_claimtype    ;
		
		if ld_balance < 1 then
			SELECT sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED)
			 INTO :ld_amount
			 FROM FREIGHT_RECEIVED
			WHERE FREIGHT_RECEIVED.VESSEL_NR = :ai_vessel  AND  
					FREIGHT_RECEIVED.CHART_NR = :al_chart  AND  
					FREIGHT_RECEIVED.CLAIM_NR = :al_claimnr AND  
					FREIGHT_RECEIVED.VOYAGE_NR = :as_voyage    ;
			uo_freight_balance lv_freight
			lv_freight = create uo_freight_balance
			lv_freight.uf_calculate_balance( ai_vessel, as_voyage, al_chart, al_claimnr)
			ld_amount += lv_freight.uf_get_addrcomm( )
			destroy lv_freight
		else	
			// Get amount from table: CLAIMS and FREIGHT_RECEIVED
			SELECT isnull(CLAIMS.CLAIM_AMOUNT_USD,0),   
					sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED),
					isnull(CLAIMS.ADDRESS_COM,0),
					isnull(CLAIMS.BROKER_COM,0)
			 INTO :ld_claim_amount,
					:ld_received_amount,
					 :ld_addrcomm,
					 :ld_brocomm
			 FROM CLAIMS,   
					FREIGHT_RECEIVED
			WHERE CLAIMS.CHART_NR *= FREIGHT_RECEIVED.CHART_NR and  
					CLAIMS.VESSEL_NR *= FREIGHT_RECEIVED.VESSEL_NR and  
					CLAIMS.VOYAGE_NR *= FREIGHT_RECEIVED.VOYAGE_NR and  
					CLAIMS.CLAIM_NR *= FREIGHT_RECEIVED.CLAIM_NR and  
					CLAIMS.VESSEL_NR = :ai_vessel  AND  
					CLAIMS.CHART_NR = :al_chart  AND  
					CLAIMS.CLAIM_NR = :al_claimnr AND  
					CLAIMS.VOYAGE_NR = :as_voyage AND  
					CLAIMS.CLAIM_TYPE = :as_claimtype    
			GROUP BY CLAIMS.VESSEL_NR,   
					CLAIMS.VOYAGE_NR,   
					CLAIMS.CHART_NR,   
					CLAIMS.CLAIM_NR   ;
						
			If IsNull(ld_received_amount) Then ld_received_amount = 0
			ld_amount = ld_claim_amount + ld_received_amount
			if ld_addrcomm > 0 then
				lds_add_lumpsums = create datastore
				lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums"
				lds_add_lumpsums.settransobject( SQLCA)
				lds_add_lumpsums.retrieve(ai_vessel,as_voyage,al_chart,al_claimnr)
				for li_add_lump = 1 to lds_add_lumpsums.rowcount()
					li_adrcomm_add_lumpsum = lds_add_lumpsums.getitemnumber( li_add_lump, "adr_comm")
					ld_add_lumpsum = lds_add_lumpsums.getitemdecimal( li_add_lump, "add_lumpsums")
					if ld_add_lumpsum <> 0 then
						if  li_adrcomm_add_lumpsum = 0 then
							ld_add_lump_all += ld_add_lumpsum
						end if
					end if
				next
				ld_amount = (((ld_amount - ld_add_lump_all)/ (100 - ld_addrcomm)) *100) + ld_add_lump_all
			end if
		end if
	CASE "AFC FRT"
		 // Get amount from table: CLAIMS and FREIGHT_ADVANCED_RECIEVED
		SELECT CLAIMS.CLAIM_AMOUNT_USD,   
					SUM(FREIGHT_ADVANCED_RECIEVED.AFC_RECIEVED),
					isnull(CLAIMS.ADDRESS_COM,0)
			 INTO :ld_claim_amount,   
					:ld_received_amount,
					 :ld_addrcomm 
			 FROM CLAIMS,   
					FREIGHT_ADVANCED_RECIEVED  
			WHERE ( CLAIMS.CHART_NR *= FREIGHT_ADVANCED_RECIEVED.CHART_NR ) and 
					( CLAIMS.VESSEL_NR *= FREIGHT_ADVANCED_RECIEVED.VESSEL_NR ) and  
					( CLAIMS.VOYAGE_NR *= FREIGHT_ADVANCED_RECIEVED.VOYAGE_NR ) and   
					( CLAIMS.CLAIM_NR *= FREIGHT_ADVANCED_RECIEVED.CLAIM_NR ) and   
					( ( CLAIMS.VESSEL_NR = :ai_vessel ) AND  
					( CLAIMS.CHART_NR = :al_chart ) AND  
					( CLAIMS.CLAIM_NR = :al_claimnr ) AND  
					( CLAIMS.VOYAGE_NR = :as_voyage ) )   
		GROUP BY CLAIMS.VESSEL_NR,   
					CLAIMS.VOYAGE_NR,   
					CLAIMS.CHART_NR,   
					CLAIMS.CLAIM_NR	;   

			If IsNull(ld_claim_amount) Then ld_claim_amount = 0
			If IsNull(ld_received_amount) Then ld_received_amount = 0
			ld_amount = ld_claim_amount + ld_received_amount	
			if ld_addrcomm > 0 then
				lds_add_lumpsums = create datastore
				lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums_afc_all"
				lds_add_lumpsums.settransobject( SQLCA)
				lds_add_lumpsums.retrieve(ai_vessel,as_voyage,al_chart,al_claimnr)
				for li_add_lump = 1 to lds_add_lumpsums.rowcount()
					li_adrcomm_add_lumpsum = lds_add_lumpsums.getitemnumber( li_add_lump, "adr_comm")
					ld_add_lumpsum = lds_add_lumpsums.getitemdecimal( li_add_lump, "add_lumpsums")
					if ld_add_lumpsum <> 0 then
						if  li_adrcomm_add_lumpsum = 0 then
							ld_add_lump_all += ld_add_lumpsum
						end if
					end if
				next
				ld_amount = (((ld_amount - ld_add_lump_all)/ (100 - ld_addrcomm)) *100) + ld_add_lump_all
			end if
	CASE ELSE //Misc
		// Get amount from table: CLAIMS
		SELECT CLAIM_AMOUNT_USD  
		INTO :ld_amount  
		FROM CLAIMS  
		WHERE VESSEL_NR = :ai_vessel 
			AND VOYAGE_NR = :as_voyage 
			AND CHART_NR = :al_chart 
			AND CLAIM_NR = :al_claimnr ;
		ld_amount -= ld_trans_amount

END CHOOSE

IF isnull(ld_amount) OR ld_amount = 0 THEN 
	ad_amount = 0
	Return -1
end if

ad_amount  = ld_amount
return 1
end function

public function integer of_recalccalculations (long al_calcid);/* Recalculate the calculations  connected to the CP that was modified
	(uses LoadLoad calculation functionality */

// Variable declaration
//u_atobviac_calculation	lnv_calc
s_calculation_parm lstr_parm

//lnv_calc = create u_atobviac_calculation
open(w_loadload_recalc_window)

// Set the calculation object not to show messages, WS reload and VESSEL data reload
// according to the CBX_NO_RELOAD checkbox
w_loadload_recalc_window.uo_recalc.ib_show_messages = false
w_loadload_recalc_window.uo_recalc.ib_no_ws_reload = false
w_loadload_recalc_window.uo_recalc.ib_no_vesseldata_reload = false

// Retrieve the calculation into the calculation object
w_loadload_recalc_window.uo_recalc.uf_retrieve(al_calcid)

// Get the calculation status into the local LI_STATUS variable
//li_status = uo_calculation.uf_get_status(0)

// Load the speedlist 
w_loadload_recalc_window.uo_recalc.uf_reload_speedlist()

lstr_parm.b_silent_calculation = true
lstr_parm.i_function_code = 2

// do the calculation
w_loadload_recalc_window.uo_recalc.uf_reload_speedlist()
w_loadload_recalc_window.uo_recalc.TriggerEvent("ue_port_changed")
//w_loadload_recalc_window.uo_recalc.uf_calculate_with_parm(lstr_parm) 
w_loadload_recalc_window.uo_recalc.uf_calculate() 
w_loadload_recalc_window.uo_recalc.uf_calculate() 

//save the data
w_loadload_recalc_window.uo_recalc.uf_save(true)

close(w_loadload_recalc_window)

return 1
end function

private subroutine documentation ();
/********************************************************************
   ObjectName: u_modify_cp
	
   <OBJECT> 	
	Object Description	
	
	updating CP data
	----------------
	of_updatecp()
		+	calls private function _modifyoperations()
		|	+	open window w_calc_per_cp (popup detailing amendments.  user can confirm here) 			
		|	+	calls private function _getopencalcs()
		+	calls private function _validatecp()
	
	</OBJECT>
   <USAGE>  	Called when user updates CP data	</USAGE>
   <ALSO>   	w_calc_per_cp, w_loadload_recalc_window, w_atobviac_calc_calculation	</ALSO>
<HISTORY> 
   Date			CR-Ref	Author	 	Comments
   21-09-10		CR1017   JSU042   	modify the calculation for broker commissions
   01-11-10		CR2171   AGL027  		added NotModified! status when checking if 
												we need to open w_calc_per_cp inside of_modifyoperations()
	25/11/10		CR2204	AGL027		fixed bug where broker comm 	chnaged no update/info window appearing	inside of_modifyoperations()
	26/11/10		CR2204	AGL027		failed test.  changed logic
	29/11/10		CR2205	JSU042		get claim amount failed due to non existing window
	01/01/11		CR2273  	JSU042      use u_auto_commission.of_generate to calculate broker commissions,
												to make sure it is the same function call when changing CP and updating Claims.
	24/02/12    CR1549   JSU042     	Multi currency - remove CLAIM_EX_RATE in CLAIMS table, therefor remove the referecen here
												today's exchange rate will be used to calculate the USD amount.
												(only related with change charterer function)
	28/09/11		CR2500	AGL027		fix issue where CP commissions are not updated correctly.  Rearranged processing order
	14/12/11		D-CALC	AGL027		Provided addional functionality to control processing of current open calculation
	02/04/12		D-CALC	AGL027		Added logic to control update of open claim window if needed.
	15/06/12		CR2825	AGL027		Included additional AX 'support' columns when changing charterer. Also update of any related transaction.
	13/09/12		CR2912	LHC010		Fix charterer changed in the C/P, top right part data of actions/transactions windows wiped clean.
	31/10/12		CR2912	LHC010		Added logic to control update of open actions/transactions window if needed.
	28/11/12		CR2828	LGX001		The claim broker percent and commission should be updated when changing a broker commission or brokek in a CP
	20/12/12		CR3083	LGX001		Refresh the w_laytime if needed
   18/01/13    CR3113   ZSW001      Add Verification for SQL statement
   25/01/13    CR2877   WWA048      Add validation for Broker Commision
	28/03/13    CR3196   ZSW001      The charterer was changed and a new invoice was sent, without that AX was 'told' to cancel the old invoice
	11/06/13    CR2877   ZSW001      1. Copy data for new fields to claims when creating a new claims; 2. Remove the validation for 'Claim Type'.
	19/08/13		CR2950	WWA048		Move the validation of claim balance from CP window to Affected Calculations window,
												disable 'Yes' button when there is a claim settled.
	20/06/14    CR3700   LHG008	   Update CLAIM_SENT.CHART_NR when changing charterer.
	16/07/14    CR3519   KSH092      not popup "Affected Calculations" window when C/P isn't attached CALC
  	25/07/14  	CR3709   AZX004      Add validation C/P.
  	26/03/15  	CR3904   LHG008      Broker and Broker Commission fields must be updated automatically
	20/06/16		CR3893	XSZ004		Fix a bug.  
</HISTORY>    
********************************************************************/

end subroutine

public function integer _getopencalcs (ref w_atobviac_calc_calculation aw_opencalcs[], long al_calc_id);/********************************************************************
   _getopencalcs( /*ref w_atobviac_calc_calculation aw_opencalcs[]*/, /*long al_calc_id */ )
	
<DESC>   
	loops through open calculation windows.  If calculation id matches that which is passed in
	append to array structure. This structure is passed back to the CP window and used to force a retrieve.  
</DESC>

<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	aw_opencalcs[] : array of windows class w_atobviac_calc_calculation
	al_calc_id		: the current calculation id in the CP listing 
</ARGS>
<USAGE>
	designed for a single purpose concerning update of opened calculation. 
	(related to error in cr#2500).
	Dependency on windows being child of mdi frame 'w_tramos_main' due to depth
	of response windows used.
/USAGE>
********************************************************************/

w_atobviac_calc_calculation   lw_calc
window			lw_parent, lw_sheet, lw_currentsheet
boolean 			lb_valid , lb_firstsheet = true 
integer 			li_retval = c#return.NoAction
integer			li_counter, li_userresp
string 			ls_unsavedmessage


	/* obtain mdi frame window.  from this object as this window is a popup, it is the grandparent. */
	lw_parent = w_tramos_main
	lw_sheet = lw_parent.getfirstsheet()
	lb_valid = isvalid(lw_sheet)
	do while lb_Valid
		if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
			if lb_firstsheet then
				lw_calc = lw_parent.getfirstsheet()
			else	
				lw_calc = lw_parent.getnextsheet(lw_currentsheet)	
			end if
			if al_calc_id = lw_calc.il_calc_id then
				/* if the current calculation has been modified notify user their changes will be lost*/
				if lw_calc.uo_calculation.ib_modified then
					ls_unsavedmessage = "This calculation is open and it contains unsaved modifications.  If you continue saving your CP updates you will lose all your unsaved changes within the calculation.  Do you want to continue?"
					li_userresp = messagebox(lw_calc.title,ls_unsavedmessage, StopSign!, YesNo!)
					if li_userresp<>1 then
						return c#return.Failure
					else
						/* remove the modified part of this calculation */
						lw_calc.uo_calculation.ib_modified = false
						lw_calc.wf_updatetitle( )
					end if
				end if	
				aw_opencalcs[upperbound(aw_opencalcs) + 1] = lw_calc
				return c#return.Success
			end if	
		end if
		lw_currentsheet = lw_sheet
		lw_sheet = lw_parent.getnextsheet(lw_currentsheet)	
		lb_Valid = isvalid (lw_sheet)
		lb_firstsheet = false
	loop
	
return li_retval
end function

private function integer of_recalcbrokercomm (integer ai_vessel, string as_voyage, long al_chart, ref u_datawindow_sqlca adw_broker);long		ll_rows, ll_row
long		ll_broker, ll_old_broker
long		ll_count
decimal	ld_brokerComm


/* First check if there are deleted brokers */
ll_rows = adw_broker.deletedcount()

for ll_row = 1 to ll_rows
	
	ll_broker = adw_broker.getItemNumber(ll_row, "cal_comm_broker_nr", delete!, false)
	
	if of_settleBalanceOK( ai_vessel , as_voyage, al_chart, ll_broker) then
		DELETE 
			FROM COMMISSIONS
			WHERE VESSEL_NR = :ai_vessel
			AND VOYAGE_NR = :as_voyage
			AND CHART_NR = :al_chart
			AND BROKER_NR = :ll_broker
			AND COMM_SETTLED = 0;
	else
		return -1
	end if
next

/* Now run through the rest, and see if anything changed */
if adw_broker.modifiedcount() > 0 then

	ll_rows = adw_broker.rowcount()
	
	for ll_row = 1 to ll_rows
	
		if adw_broker.getItemStatus(ll_row, "cal_comm_broker_nr", primary!) = dataModified! then   
			
			ll_old_broker = adw_broker.getItemNumber(ll_row, "cal_comm_broker_nr", primary!, true)
			ll_broker     = adw_broker.getItemNumber(ll_row, "cal_comm_broker_nr", primary!, false)
			
			if of_settleBalanceOK( ai_vessel , as_voyage, al_chart, ll_old_broker) then
				UPDATE COMMISSIONS 
				   SET BROKER_NR = :ll_broker
			    WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage
					AND CHART_NR = :al_chart AND BROKER_NR = :ll_old_broker
					AND COMM_SETTLED = 0;
			else
				return -1
			end if
		end if			
	next

	of_calcClaimCommission(ai_vessel, as_voyage, al_chart, adw_broker, ld_brokerComm )
end if

return 1
end function

private function integer of_calcclaimcommission (integer ai_vessel, string as_voyage, long al_chart, u_datawindow_sqlca adw_broker, decimal ad_commpct);n_ds						lds_data
long						ll_rows, ll_row, ll_claimnr
string					ls_claimtype	
uo_auto_commission	lu_auto_commission
double 					ld_commpct

ld_commpct = double(ad_commpct)

lds_data = create 		n_ds
lds_data.dataObject = "d_sq_tb_claim_number"
lds_data.setTransObject(sqlca)
ll_rows = lds_data.retrieve( ai_vessel, as_voyage, al_chart)

for ll_row = 1 to ll_rows
	ll_claimnr 	= lds_data.getItemNumber(ll_row, "claim_nr")
	ls_claimtype	= lds_data.getItemString(ll_row, "claim_type")
	lu_auto_commission.of_generate(ai_vessel, as_voyage, al_chart, integer(ll_claimnr), ls_claimtype, "NEW", ld_commpct, adw_broker)	
next		
destroy lds_data

return 1
end function

private function integer _modifyoperations (ref u_datawindow_sqlca adw_broker, ref u_datawindow_sqlca adw_cpdata, ref w_atobviac_calc_calculation aw_opencalcs[], ref string as_message, ref s_vessel_voyage_chart_claim astr_openedclaim, ref s_vessel_voyage_chart_claim astr_openedactiontransaction, ref s_vessel_voyage_chart_claim astr_openedlaytime);/********************************************************************
   _modifyoperations()
   <DESC>
		This function control the modifications that has to be done in the Operations module if any.
		It calls alot of subfunctions that controls all modifications.	
	</DESC>
   <RETURN>	Integer:
		<LI> -1 : Failure
		<LI>  0 : No Action
		<LI>  1 : Success
		<LI>  3 : User cancels action
	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		adw_broker: broker datawindow reference
		adw_cpdata: CP datawindow reference
		aw_opencalcs[]: array of all open windows that are linked to the current CP
		as_message: not really in full usage.
		astr_openedclaim
		astr_openedactiontransaction
		astr_openedlaytime
   </ARGS>
   <USAGE>	Private, only called from function of_updatecp() inside this object.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First Version
		26/03/15 CR3904        LHG008   Broker and Broker Commission fields must be updated automatically
   </HISTORY>
********************************************************************/

long		ll_rc,ll_count
long		ll_voyages, ll_calculations, ll_row
long		ll_calcid	
decimal	ld_sumbrokerpct, ld_adrcommpct
boolean	lb_recalc_bcomm = false, lb_unsavedcalc = false
string 	ls_unsavedmessage
integer	li_userresp, li_retcode
constant integer	li_MSGBOXCANCEL=3, li_MSGBOXNO=2, li_MSGBOXYES=1
dwitemstatus lstatus_cpdata

lstatus_cpdata = adw_cpdata.getitemstatus( 1, 0, primary!)

/* This is a new CP and nothing extraoridinary needs to happen! */
if lstatus_cpdata = new! or lstatus_cpdata = newModified! then
	return c#return.Success
end if

ib_brokermodified = (adw_broker.modifiedcount() + adw_broker.deletedcount()) > 0

if lstatus_cpdata = notmodified! and ib_brokermodified = false then
	return c#return.success
end if

il_cpid = adw_cpdata.getItemNumber(1, "cal_cerp_id")
//when cp not attached calc,then not open window (w_calc_per_cp)
 SELECT COUNT(*) 
 INTO   :LL_COUNT
 FROM   CAL_CALC,   
        CAL_CARG,   
        VESSELS  
 WHERE ( CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID ) and  
       ( VESSELS.VESSEL_NR = CAL_CALC.CAL_CALC_VESSEL_ID ) and  
       ( ( CAL_CARG.CAL_CERP_ID = :IL_CPID ) );
if ll_count > 0 then
   openwithparm( w_calc_per_cp, il_cpid )
	li_retcode = message.doubleparm
else
	li_retcode = C#return.Success
end if

/* Handle the user cancelling the update */
if li_retcode = c#return.NoAction then return li_MSGBOXCANCEL  

li_retcode = of_setbasecpmodifylevel( adw_cpdata )
if  li_retcode = c#return.NoAction  then
	return c#return.NoAction 
elseif li_retcode = c#return.Failure then
	return c#return.Failure
end if

ll_voyages = ids_voyages.retrieve( il_cpid )

/* check if w_claim is open and obtain values of currently selected claim */
if isvalid(w_claims) then
	w_claims.wf_getkeydata(astr_openedclaim)
end if

/* check if w_actions_transactions is open and obtain values of currently selected claim */
if isvalid(w_actions_transactions) then
	w_actions_transactions.wf_getkeydata(astr_openedactiontransaction)
end if

if isvalid(w_laytime) then
	w_laytime.wf_getkeydata(astr_openedlaytime)
end if

/* Modify CP and Claims */
choose case ii_cpmodifylevel
	case 1
		// there is only changed city and/or contract type. Updated via CP-datawindow
	case 2, 4
		// base claim information, shall also be updated
		for ll_row = 1 to ll_voyages
			of_changeclaim( ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
										ids_voyages.getItemString(ll_row, "voyage_nr"), &
										adw_cpdata, astr_openedclaim, astr_openedactiontransaction, astr_openedlaytime)
			if ib_recalc_acomm then
				of_recalcopsadrcomm(ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
										ids_voyages.getItemString(ll_row, "voyage_nr"), &
										adw_cpdata.getItemNumber(1, "chart_nr"))
			end if
		next
	case 3
		for ll_row = 1 to ll_voyages
			if of_changecharterer( ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
										ids_voyages.getItemString(ll_row, "voyage_nr"), &
										adw_cpdata.getItemNumber(1, "chart_nr",primary!,true), & 
										adw_cpdata.getItemNumber(1, "chart_nr",primary!,false)) = c#return.Failure then
				as_message = "Failed to change charterer!"
				return c#return.Failure
			end if
			of_changeclaim( ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
										ids_voyages.getItemString(ll_row, "voyage_nr"), &
										adw_cpdata,astr_openedclaim, astr_openedactiontransaction, astr_openedlaytime)
			if ib_recalc_acomm then 
				of_recalcopsadrcomm(ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
										ids_voyages.getItemString(ll_row, "voyage_nr"), &
										adw_cpdata.getItemNumber(1, "chart_nr"))
			end if
		next
end choose		

/* Modify Broker Commissions */
for ll_row = 1 to ll_voyages
	if of_recalcBrokerComm (ids_voyages.getItemNumber(ll_row, "vessel_nr"), &
							ids_voyages.getItemString(ll_row, "voyage_nr"), &
							adw_cpdata.getItemNumber(1, "chart_nr"), &
							adw_broker ) = -1 then
		as_message	 = "Modifications of Broker Commission failed!"
		return c#return.Failure
	end if
next

/* Recalculate and modify calculations ( only calculated ) */
//first find out if sum of broker commission is different from "old"
ld_sumbrokerpct = adw_broker.getItemNumber(1, "total_comm")
ld_adrcommpct = adw_cpdata.getItemNumber(1, "cal_cerp_add_comm")
ll_calculations = ids_calculations.retrieve( il_cpid )


/* we have to loop through the calculations assigned to CP twice.  reason for this being the second loop
calls on the calculation module itself and updates/saves them one at a time.  If the user
than wishes to cancel process we might ahve already modified some calculations already. */

for ll_row = 1 to ll_calculations
	if ld_sumbrokerpct <> ids_calculations.getItemNumber(ll_row, "cal_carg_temp_comission") then
		ids_calculations.setItem(ll_row, "cal_carg_temp_comission", ld_sumbrokerpct )
		lb_recalc_bcomm = true
	end if
	if ib_recalc_acomm then
		ids_calculations.setItem(ll_row, "cal_carg_adr_commision", ld_adrcommpct )
	end if
	if ib_recalc_acomm or lb_recalc_bcomm then
		if ids_calculations.update() = 1 then
			ll_calcid = ids_calculations.getItemNumber(ll_row, "cal_calc_id")
			if _getopencalcs(aw_opencalcs, ll_calcid)=c#return.Failure then
				return c#return.NoAction
			end if	
		else
			as_message = "Failed to update broker or address commission in cargo table"
			return c#return.Failure	
		end if	
	end if	
next	

/* 
so same loop again.  if process arrives here we know either:

- 	there are no updates inside all
- 	the commissions in the CP have not been modified anyway
- 	calculations are indeed open, commissions have been changed but the user has authorised TRAMOS 
	to update all 
*/
for ll_row = 1 to ll_calculations
	if ld_sumbrokerpct <> ids_calculations.getItemNumber(ll_row, "cal_carg_temp_comission") then
		lb_recalc_bcomm = true
	end if
	if ib_recalc_acomm or lb_recalc_bcomm then
		ll_calcid = ids_calculations.getItemNumber(ll_row, "cal_calc_id")
		of_recalccalculations( ll_calcid )
	end if	
next

as_message	 = is_message
return 1
end function

private function integer of_changeclaim (integer ai_vessel, string as_voyage, ref datawindow adw_cpdata, ref s_vessel_voyage_chart_claim astr_openedclaim, ref s_vessel_voyage_chart_claim astr_openedactiontransaction, ref s_vessel_voyage_chart_claim astr_openedlaytime);/********************************************************************
   of_changeclaim
   <DESC>	update claim base data and find opened windows	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ai_vessel
		as_voyage
		adw_cpdata
		astr_openedclaim
		astr_openedactiontransaction
		astr_openedlaytime
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First Version
		26/03/15 CR3904        LHG008   Broker and Broker Commission fields must be updated automatically
   </HISTORY>
********************************************************************/

long		ll_chartnr, ll_office, ll_timebar, ll_noticebar
string		ls_cptext
datetime	ldt_cpdata
decimal	ld_adr_comm

ll_chartnr = adw_cpdata.getItemNumber(1, "chart_nr")

if ii_cpmodifylevel = 4 then
	//Only broker modified. In function _validatecp(), broker and broker commission fields will be update automatically,
	//so we need refresh opened windows.
else
	ll_office		= adw_cpdata.getItemNumber(1, "cal_cerp_cal_cerp_office_nr")
	ls_cptext		= adw_cpdata.getItemString(1, "cal_cerp_description")
	ldt_cpdata		= adw_cpdata.getItemDatetime(1, "cal_cerp_date")	
	ll_timebar		= adw_cpdata.getItemNumber(1, "cal_cerp_timebar_days")
	ll_noticebar	= adw_cpdata.getItemNumber(1, "cal_cerp_noticebar_days")
	ld_adr_comm		= adw_cpdata.getItemNumber(1, "cal_cerp_add_comm")
	
	UPDATE CLAIMS  
		SET OFFICE_NR = :ll_office ,   
			CP_TEXT = :ls_cptext ,   
			CP_DATE = :ldt_cpdata ,   
			TIMEBAR_DAYS = :ll_timebar ,   
			NOTICE_DAYS = :ll_noticebar ,   
			TIMEBAR_DATE = dateadd(dd, :ll_timebar, DISCHARGE_DATE) ,   
			NOTICE_DATE = dateadd(dd, :ll_noticebar, DISCHARGE_DATE),
			ADDRESS_COM = :ld_adr_comm
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND CHART_NR = :ll_chartnr ;
end if

/* controls if the claim window is open */
if ai_vessel = astr_openedclaim.vessel_nr and (astr_openedclaim.status="OPEN" or astr_openedclaim.status="VESSEL")  then
	astr_openedclaim.status = "VESSEL"
	if as_voyage = astr_openedclaim.voyage_nr and ll_chartnr <> astr_openedclaim.chart_nr then
		astr_openedclaim.status = "RELOAD"
		astr_openedclaim.chart_nr = ll_chartnr
	elseif as_voyage <> astr_openedclaim.voyage_nr then
		astr_openedclaim.status = "NOACTION"
	end if
end if

/* controls if the actions/transactions window is open */
if ai_vessel = astr_openedactiontransaction.vessel_nr and (astr_openedactiontransaction.status="OPEN" or astr_openedactiontransaction.status="VESSEL")  then
	astr_openedactiontransaction.status = "VESSEL"
	if as_voyage = astr_openedactiontransaction.voyage_nr and ll_chartnr <> astr_openedactiontransaction.chart_nr then
		astr_openedactiontransaction.status = "RELOAD"
		astr_openedactiontransaction.chart_nr = ll_chartnr
	elseif as_voyage <> astr_openedactiontransaction.voyage_nr then
		astr_openedactiontransaction.status = "NOACTION"
	end if
end if

// controls if laytime window is open 
if ai_vessel = astr_openedlaytime.vessel_nr and (astr_openedlaytime.status="OPEN" or astr_openedlaytime.status="VESSEL")  then
	astr_openedlaytime.status = "VESSEL"
	if as_voyage = astr_openedlaytime.voyage_nr and ll_chartnr <> astr_openedlaytime.chart_nr then
		astr_openedlaytime.status = "RELOAD"
		astr_openedlaytime.chart_nr = ll_chartnr
	elseif as_voyage <> astr_openedlaytime.voyage_nr then
		astr_openedlaytime.status = "NOACTION"
	end if
end if

return 1
end function

private function integer _validatecp (ref u_datawindow_sqlca adw_brokerdata, u_datagrid adw_charerter, ref u_datawindow_sqlca adw_cpdata, ref long al_cpno);/********************************************************************
   of_validatecp
   <DESC>	Validate cp data </DESC>
   <RETURN>	integer:
            <LI> c#return.Success
            <LI> c#return.Failure </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		31/07/96		?     		Teit Aunt	?
		07/08/96		1.1   		TA       	Correcting erors
		01/08/96		1.1   		TA       	description not null
		31/07/96		1.0   		TA       	Initial version
		28/09/11		-     		AGL       	Moved to object from window, created new function with refactored
								                  code.  modification due to database locks in claims. cr#2502
		25/01/13		1.1   		WWA048    	Add validation for Broker Commision
		26/03/15		CR3904		LHG008    	Broker and Broker Commission fields must be updated automatically
		20/06/16		CR3893		XSZ004		First version
   </HISTORY>
********************************************************************/

// Cp id is taken from adw_cpdata and inserted into broker

long     ll_cal_cerp_id, ll_rows, ll_count, ll_chart_nr, li_noticebar_days, li_timebar_days
integer  li_retval, li_broker
datetime ldt_cerp_date
string   ls_description
decimal  ld_comm_percent

If adw_cpdata.Update(true, false) = 1 Then
	
	ll_cal_cerp_id = adw_cpdata.GetItemNumber(1,"cal_cerp_id")
	
	If IsNull(ll_cal_cerp_id) Or (ll_cal_cerp_id =0)  Then

		// Find just opdaterede CP-ID (this code will propably never be executed)
		ldt_cerp_date     = adw_cpdata.GetItemDateTime(1,"cal_cerp_date")
		li_noticebar_days = adw_cpdata.GetItemNumber(1,"cal_cerp_noticebar_days")
		li_timebar_days   = adw_cpdata.GetItemNumber(1,"cal_cerp_timebar_days")
		ls_description    = adw_cpdata.GetItemString(1,"cal_cerp_description")

		SELECT CAL_CERP_ID
		  INTO :ll_cal_cerp_id
		  FROM CAL_CERP
		 WHERE CAL_CERP_DATE = :ldt_cerp_date AND
		       CAL_CERP_NOTICEBAR_DAYS = :li_noticebar_days AND
		       CAL_CERP_TIMEBAR_DAYS = :li_timebar_days AND
		       CAL_CERP_DESCRIPTION = :ls_description
		ORDER BY CAL_CERP_ID DESC;
	End if 

	// Updating the tables
	If ll_cal_cerp_id > 0 Then
		
		ll_rows = adw_brokerdata.RowCount()
		For ll_count = 1 To ll_rows 
			adw_brokerdata.SetItem(ll_count,"cal_cerp_id", ll_cal_cerp_id)
		Next
		
		ll_rows = adw_charerter.rowcount()
		for ll_count = 1 to ll_rows
			
			ll_chart_nr = adw_charerter.getitemnumber(ll_count, "chart_nr")
			if not isnull(ll_chart_nr) then
				adw_charerter.setitem(ll_count, "cal_cerp_id", ll_cal_cerp_id)
			end if
		next

		If adw_brokerdata.Update(true, false) = 1 and adw_charerter.update(true, false) = 1 Then
			
			li_retval = c#return.Success
			
			if ib_brokermodified then
				setnull(li_broker)
				setnull(ld_comm_percent)
				
				SELECT TOP 1 CAL_COMM.BROKER_NR, CAL_COMM.CAL_COMM_PERCENT
				  INTO :li_broker, :ld_comm_percent
				  FROM CAL_COMM, BROKERS
				 WHERE CAL_CERP_ID = :ll_cal_cerp_id AND BROKERS.BROKER_NR = CAL_COMM.BROKER_NR
				   AND BROKERS.BROKER_POOL_MANAGER <> 1 AND CAL_COMM.CAL_COMM_PERCENT > 0
				 USING SQLCA;
				
				if sqlca.sqlcode >= 0 then
					UPDATE CLAIMS
					   SET BROKER_NR = :li_broker,
					       BROKER_COM = :ld_comm_percent
					 WHERE CAL_CERP_ID = :al_cpno;
				end if
				
				if sqlca.sqlcode < 0 then
					ROLLBACK;
					MessageBox("Error", "Update broker/broker commission failed!")
					li_retval = c#return.Failure
				end if
			end if
			
			al_cpno = ll_cal_cerp_id
		Else
			ROLLBACK;
			MessageBox("Error","Did not save !")
			li_retval = c#return.Failure
		End if
	End if
Else
	ROLLBACK;
End if

return(li_retval)
end function

public function integer of_updatecp (ref u_datawindow_sqlca adw_brokerdata, u_datagrid adw_charerter, ref u_datawindow_sqlca adw_cpdata, ref long al_cpno, string as_userprompt);/********************************************************************
   of_updatecp( /*ref u_datawindow_sqlca adw_brokerdata*/, /*ref u_datawindow_sqlca adw_cpdata*/, /*ref long al_cpno*/, /*string as_userprompt */)
<DESC>   
	Public function concerned with modifying CP and controlling the impact elsewhere.
</DESC>
<RETURN>
	Integer:
		<LI> -1, Failed
		<LI>  0, NoAction
		<LI>  1, Success
		<LI>  3, User cancel 
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	adw_brokerdata	:	reference to broker datawindow
	adw_cpdata		:	datawindow of cp data
	al_cpno			: 	the current CP id
	as_userprompt	: 	string for prompt.  If null ignore this additonal check.
</ARGS>
<USAGE>
	Called from w_calc_cp_data window.  
	1. user clicks the update button - called from click event and if update successful again when
	the window closes itself from the closequery event.
	2. when user closes the window manually a single call from closequery event is sent.
</USAGE>
********************************************************************/

string		ls_error_string
long 			ll_openindex
boolean 		ib_showmessages
integer 		li_modified, li_validated, li_retval=1, li_currentpage
w_atobviac_calc_calculation  lw_opencalcs[]
constant integer	li_MSGBOXCANCEL=3, li_MSGBOXNO=2, li_MSGBOXYES=1
s_vessel_voyage_chart_claim	lstr_openedclaim, lstr_openedactiontransaction, lstr_openedlaytime

if uo_global.ii_access_level <> -1 then
	/* default is yes, but if call from closequery we prompt the user */
	if adw_cpdata.modifiedcount() + adw_cpdata.deletedcount() + &
	   adw_brokerdata.modifiedcount() + adw_brokerdata.deletedcount() + &
		adw_charerter.modifiedcount() + adw_charerter.deletedcount() > 0 then
		
		if as_userprompt<>"" then
			li_retval = MessageBox("Warning", "Current data is unsaved, save before close ?", StopSign!, YesNoCancel!)
		end if	
		
		if li_retval = li_MSGBOXYES then
			/* the following function may return numeric between -1 and 3 */
			li_modified = this._modifyoperations(adw_brokerdata, adw_cpdata, lw_opencalcs, ls_error_string, lstr_openedclaim, lstr_openedactiontransaction, lstr_openedlaytime) 
			if li_modified = c#return.NoAction then
				ROLLBACK;
				li_retval = c#return.NoAction
			elseif li_modified = li_MSGBOXCANCEL then
				ROLLBACK;
				li_retval = li_MSGBOXCANCEL
			elseif li_modified = c#return.Failure then 	
				messageBox("Error", ls_error_string)
				ROLLBACK;
				li_retval = c#return.Failure
			else
				li_validated = this._validatecp(adw_brokerdata, adw_charerter, adw_cpdata, al_cpno)
				if li_validated=c#return.Success then
					COMMIT;
					adw_cpdata.resetupdate()
					adw_brokerdata.resetupdate()
					adw_charerter.resetupdate()	
			
					/* loop through open calcules re-retrieving and saving with new values */
					for ll_openindex = 1 to upperbound(lw_opencalcs)
						lw_opencalcs[ll_openindex].uf_redraw_off( )
						ib_showmessages = lw_opencalcs[ll_openindex].uo_calculation.ib_show_messages
						lw_opencalcs[ll_openindex].uo_calculation.ib_show_messages = false
						li_currentpage = lw_opencalcs[ll_openindex].uo_calculation.uf_get_current_page( )
						lw_opencalcs[ll_openindex].event ue_retrieve(0,0)
						lw_opencalcs[ll_openindex].uo_calculation.uf_calculate( )
						lw_opencalcs[ll_openindex].uo_calculation.uf_save(false)
						lw_opencalcs[ll_openindex].uo_calculation.uf_select_page(li_currentpage)
						lw_opencalcs[ll_openindex].uo_calculation.ib_show_messages = ib_showmessages 
						lw_opencalcs[ll_openindex].uf_redraw_on( )
					next
					
					/* 
					test if we need to refresh the opened claim window or not
					*/
					if lstr_openedclaim.status = "RELOAD" or lstr_openedclaim.status = "VESSEL" then
						w_claims.event ue_reload(lstr_openedclaim)
					end if

					/* 
					test if we need to refresh the opened claim window or not
					*/
					if lstr_openedactiontransaction.status = "RELOAD" or lstr_openedactiontransaction.status = "VESSEL" then
						w_actions_transactions.event ue_reload(lstr_openedactiontransaction)
					end if
					
					// Refresh w_laytime if needed
					if lstr_openedlaytime.status = "RELOAD" or lstr_openedlaytime.status = "VESSEL" then
						w_laytime.event ue_reload(lstr_openedlaytime)
					end if
									
					li_retval = c#return.Success
				else
					rollback;
					li_retval = c#return.NoAction
				end if
			end if	
		elseif li_retval = li_MSGBOXNO then
			li_retval = 0
		end if
	else
		li_retval = c#return.NoAction
	end if	
else
	messagebox("Infomation","As an external user you do not have access to edit this data.")
	li_retval = c#return.NoAction
end if

return li_retval
end function

public function integer of_checksettlement (long as_cerpid, ref string as_msg);/********************************************************************
   of_checksettlement
   <DESC> This function checks if there are any Claims connected to Calculation/CP 
			 that has the balance of 0 (Zero) and where there is a receivable registred. 
			 If so the user is not allowed to change CP. Will have a message saying that
			 he/she has to contact Finance department in order to modify CP. They have
			 delete the receivables. </DESC>
   <RETURN> integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	19/08/2013 CR2950       WWA048        		Move the validation of claim balance from CP window to Affected Calculations window,
																disable 'Yes' button when there is a claim settled.
   </HISTORY>
********************************************************************/
long		ll_voyrows, ll_voyrow, ll_claimrows, ll_claimrow
long		ll_vessel
string	ls_voyage, ls_ref_nr

mt_n_datastore	lds_data

lds_data = create mt_n_datastore
lds_data.dataObject = "d_sq_tb_check_claimbalance"
lds_data.setTransObject(sqlca)

ll_voyrows = ids_voyages.retrieve(as_cerpid)

if ll_voyrows > 0 then
	for ll_voyrow = 1 to ll_voyrows
		ll_vessel = ids_voyages.getItemNumber(ll_voyrow, "vessel_nr")
		ls_voyage = ids_voyages.getItemString(ll_voyrow, "voyage_nr")
		ls_ref_nr = ids_voyages.getitemstring(ll_voyrow, "vessel_ref_nr")
		ll_claimrows = lds_data.retrieve( ll_vessel, ls_voyage )	
		for ll_claimrow = 1 to ll_claimrows
			if abs(lds_data.getitemNumber(ll_claimrow, "claim_amount") - lds_data.getItemNumber(ll_claimrow, "transactions")) < 1 then
				if (lds_data.getitemNumber(ll_claimrow, "freight_received") + lds_data.getItemNumber(ll_claimrow, "trans_received")) > 0 then
					as_msg = "You can only change a CP with Contract type, C/P text and C/P date where there is already a claim settled. Vessel = "+ls_ref_nr+" Voyage='"+ls_voyage+"'"
					destroy lds_data
					return c#return.Failure
				end if
			end if
		next	
	next	
end if

destroy lds_data
return c#return.Success

end function

on u_modify_cp.create
call super::create
end on

on u_modify_cp.destroy
call super::destroy
end on

event constructor;ids_voyages = create mt_n_datastore
ids_voyages.dataObject = "d_sq_tb_voyages_per_cp"
ids_voyages.setTransObject(SQLCA)

ids_calculations = create mt_n_datastore
ids_calculations.dataObject = "d_sq_tb_calculations_per_cp"
ids_calculations.setTransObject(SQLCA)

end event

event destructor;if isValid(ids_voyages) then
	destroy ids_voyages
end if

if isValid(ids_calculations) then
	destroy ids_calculations
end if
end event

