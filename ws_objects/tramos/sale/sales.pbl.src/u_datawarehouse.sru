$PBExportHeader$u_datawarehouse.sru
$PBExportComments$This userobject has all the functions required to recreate the data in the datawarehouse.
forward
global type u_datawarehouse from nonvisualobject
end type
end forward

global type u_datawarehouse from nonvisualobject
end type
global u_datawarehouse u_datawarehouse

type variables
str_progress parm
datawindow idw
end variables

forward prototypes
private function string uf_recreate_cp_data (integer il_count_total, integer il_count_so_far)
private function string uf_recreate_datawarehouse ()
private function string uf_recreate_tc_out_data (integer il_count_total, integer il_count_so_far)
private function string uf_recreate_vessel_voyage_data (integer il_count_total, integer il_count_so_far)
public subroutine uf_tc_hire (long ll_vessel_nr, datetime ldt_cp_date)
public function string uf_update_datawarehouse (ref datawindow adw)
end prototypes

private function string uf_recreate_cp_data (integer il_count_total, integer il_count_so_far);///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : n/a
//  
// Object     : uf_recreate_cp_data
//  
// Event	 : call
//
// Scope     : private
//
// ************************************************************************************
//
// Author    : Peter Bendix-Toft
//   
// Date       : 15-08-96
//
// Description : This function creates all the new datawarehouse rows
//			for all cps that are of status "estimated"
//
// Arguments : none
//
// Returns   : String : 	NULL if function performed OK     OR
//				Message of what failed 
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//15-08-96 		3.0			PBT		SYSTEM 3
//05-12-96			3.0			MI			Added C/P summs from calculation (kept then 333 for search purpose)
//09-12-97			5.0			JEH		Changed so funktion writes error to log and does not
//												stop, unless system error is incurred.
//10-12-97			5.0			JEH		Inserted COMMIT Using Sqlca efter Select statements
//************************************************************************************/
///* Local Variables */
string ls_return_string, ls_chart_sn, ls_charterer_group, ls_voyage_nr
//transaction temp_tran
//long  ll_cal_cerp_id, ll_dw_serial,ll_row 
//int li_contract_type, li_vessel_nr, li_no_voyages_est, li_no_voyages_act, li_off_days_est, li_off_days_act
//int li_idle_days_est, li_idle_days_act, li_grossdays_est, li_grossdays_act, li_pc_nr
//datetime ldt_cp_date
//decimal ld_freight,ld_freight_act, ld_freight_adv_act,ld_addr_comm
//decimal ld_bunkers_est, ld_bunkers_act, ld_port_est, ld_port_act, ld_misc_est, ld_misc_act
//decimal ld_off_hire_est, ld_off_hire_act, ld_no_ton_est, ld_no_ton_act, ld_gross_hire_est, ld_gross_hire_act
//decimal ld_demurrage_est, ld_demurrage_act, ld_despatch_est, ld_despatch_act, ld_commission_est, ld_commission_act
//uo_addr_comm u_addr_comm
//
///* Set return string null */
//setnull(ls_return_string)
// ll_dw_serial = il_count_so_far
//
///* Create and connect transaction object */
//temp_tran = create transaction
//uo_global.defaulttransactionobject(temp_tran)
//connect using temp_tran;
////temp_tran.autocommit = TRUE
//
///* Create cursor over all cp's that are estimated and test for error and return error if sql failed */
//DECLARE cp_cursor CURSOR FOR  
//SELECT DISTINCT CAL_CERP.CAL_CERP_ID  , CAL_CERP.CAL_CERP_DATE
//FROM CAL_CERP,   CAL_CARG  
//WHERE 	( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
//         	(  CAL_CARG.CAL_CARG_STATUS = 6  ) AND
//					CAL_CERP.CAL_CERP_ID > 1  using temp_tran;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error with transaction object, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database cp_cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* Open cursor and test for error and return error if sql failed */
//open cp_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error with transaction object, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open cp_cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* fetch the first cp */
//fetch cp_cursor into :ll_cal_cerp_id,:ldt_cp_date;
///* While there are cps do... */
//DO WHILE temp_tran.sqlcode = 0
//	/* Set dw serial for cp */
//	ll_dw_serial++
////	if mod(ll_dw_serial,5) = 0 then
//		w_progress_no_cancel.wf_progress(ll_dw_serial/il_count_total,"Creating Data Warehouse for CP's")
////	end if
//
//	/* Set contract Type for cp */
//	SELECT CAL_CERP_CONTRACT_TYPE
//	INTO :li_contract_type
//	FROM CAL_CERP
//	WHERE CAL_CERP_ID = :ll_cal_cerp_id;
//	COMMIT Using Sqlca;
//
//	/* Set cal cerp id */
//	// This is in the cursor 
//
//	/* Set Charterer ShortName for cp */
//	SELECT CHART.CHART_SN  
//    	INTO :ls_chart_sn  
//    	FROM CAL_CERP,            CHART  
//   	WHERE 	( CHART.CHART_NR = CAL_CERP.CHART_NR ) and  
//         		( ( CAL_CERP.CAL_CERP_ID = :ll_cal_cerp_id ) )   ;
//		COMMIT Using Sqlca;
//
//	/* Set Charterer Group for cp */	
//	SELECT CCS_CHGP.CCS_CHGP_NAME  
//    	INTO :ls_charterer_group  
//    	FROM CAL_CERP,    CCS_CHGP,   CHART  
//	WHERE 	( CCS_CHGP.CCS_CHGP_PK = CHART.CCS_CHGP_PK ) and  
//         		( CHART.CHART_NR = CAL_CERP.CHART_NR ) and  
//         		( ( CAL_CERP.CAL_CERP_ID = :ll_cal_cerp_id ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ls_charterer_group) or ls_charterer_group = "" then ls_charterer_group = "No Group Given"
//
//	/* Set cp date for cp */
//	// This is in the cursor
//
//	/* Set Vessel Nr for cp */
//	setnull(li_vessel_nr)
//
//	/* Set Voyage_nr for cp */
//	setnull(ls_voyage_nr)
//
//	/* Set Est Number of Voyages for cp */
//  	SELECT count(distinct CAL_CARG.CAL_CALC_ID)  
//    	INTO :li_no_voyages_est  
//    	FROM CAL_CARG,            CAL_CERP  
//   	WHERE 	( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
//         		( ( CAL_CERP.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//         		( CAL_CARG.CAL_CARG_STATUS = 6 ) )   ;
//	COMMIT Using Sqlca;
//
//	/* Set Act Number of Voyages for cp */
//	// This result could be wrong if two vessels have the same cp on the same voyage number
//	// I could not get the SQL to distinct on two result sets, namely ves & voy
//	SELECT count(distinct VOYAGES.VOYAGE_NR)  
//	INTO :li_no_voyages_act  
//    	FROM CAL_CARG, CAL_CERP, VOYAGES  
//	WHERE 	( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
//         		( CAL_CARG.CAL_CALC_ID = VOYAGES.CAL_CALC_ID ) and  
//         		( ( CAL_CERP.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//         		( CAL_CARG.CAL_CARG_STATUS = 6 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(li_no_voyages_act) then li_no_voyages_act = 0
//
//	/* Set Number of Tonns Est for cp */
//	
//	SELECT SUM(CAL_CARG_TOTAL_UNITS)
//	INTO :ld_no_ton_est
//	FROM CAL_CARG
//	WHERE (CAL_CERP_ID = :ll_cal_cerp_id) AND
//		(CAL_CARG_STATUS = 6);
//	COMMIT Using Sqlca;
//	If IsNull(ld_no_ton_est) Then ld_no_ton_est = 0	
//
//	/* Set Number of Tonns Act for cp */	
//  	SELECT SUM(BOL.BOL_QUANTITY)  
//    	INTO :ld_no_ton_act  
//    	FROM BOL
//   	WHERE ( ( CAL_CERP_ID = :ll_cal_cerp_id) AND  
//         		( L_D = 1 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_no_ton_act) then ld_no_ton_act = 0
//
//	/* Set Gross Hire Est for cp */
//	
//	SELECT SUM(CAL_CARG_TOTAL_GROSS_FREIGHT)
//	INTO :ld_gross_hire_est
//	FROM CAL_CARG
//	WHERE (CAL_CERP_ID = :ll_cal_cerp_id) AND
//		(CAL_CARG_STATUS = 6);
//	COMMIT Using Sqlca;
//	If IsNull(ld_gross_hire_est) Then ld_gross_hire_est = 0
//
//	/* Set Gross Hire Act for cp */
//
//	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//    	INTO :ld_freight_act
//    	FROM CLAIMS,FREIGHT_CLAIMS F  
//	WHERE 	( CLAIMS.CHART_NR = F.CHART_NR ) and  
//         		( CLAIMS.VESSEL_NR = F.VESSEL_NR ) and  
//         		( CLAIMS.VOYAGE_NR =F.VOYAGE_NR ) and  
//         		( CLAIMS.CLAIM_NR = F.CLAIM_NR ) and  
//         		( ( F.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//			(CLAIMS.CLAIM_TYPE = "FRT" ) AND
//         		( CLAIMS.CLAIM_AMOUNT_USD > 0 ) )   ;
//	COMMIT Using Sqlca;
//	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//    	INTO :ld_freight_adv_act
//    	FROM CLAIMS,FREIGHT_ADVANCED F  
//	WHERE 	( CLAIMS.CHART_NR = F.CHART_NR ) and  
//         		( CLAIMS.VESSEL_NR = F.VESSEL_NR ) and  
//         		( CLAIMS.VOYAGE_NR =F.VOYAGE_NR ) and  
//         		( CLAIMS.CLAIM_NR = F.CLAIM_NR ) and  
//         		( ( F.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//			(F.AFC_NR = 1 ) AND
//			(CLAIMS.CLAIM_TYPE = "FRT" ) AND
//         		( CLAIMS.CLAIM_AMOUNT_USD > 0 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_freight_act) then ld_freight_act = 0
//	if isnull(ld_freight_adv_act) then ld_freight_adv_act = 0
//	ld_freight = ld_freight_adv_act + ld_freight_act
//	u_addr_comm = create uo_addr_comm
//	ld_addr_comm = u_addr_comm.uf_get_adr_comm(ll_cal_cerp_id,0,"0")
//	if ld_addr_comm < 0 then
//		ls_return_string = "Function Getting Adress Commision failed! Therefor calculation of Gross Hire Actual and Comission Actual is not correct for 'calc cerp id'/cp date/adress commision: "+String(ll_cal_cerp_id)+"/"+string(ldt_cp_date)+"/"+string(ld_addr_comm)
//		/* If error found in function, write error to log*/
//		If Isvalid(w_warehouse_errors) THEN
//			ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with CP")
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,ls_return_string)
//		end if
//	end if
//	ld_gross_hire_act = ld_freight + ld_addr_comm
//	destroy u_addr_comm
//
//	/* Set Demurage Est for cp */
//	
//	SELECT SUM(CAL_CARG_TOTAL_DEMURRAGE)
//	INTO :ld_demurrage_est
//	FROM CAL_CARG
//	WHERE (CAL_CERP_ID = :ll_cal_cerp_id) AND
//		(CAL_CARG_STATUS = 6);
//	COMMIT Using Sqlca;
//	If IsNull(ld_demurrage_est) Then ld_demurrage_est = 0		
//
//	/* Set Demurage Act for cp */
//	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//    	INTO :ld_demurrage_act
//    	FROM DEM_DES_CLAIMS,   CLAIMS  
//	WHERE 	( CLAIMS.CHART_NR = DEM_DES_CLAIMS.CHART_NR ) and  
//         		( CLAIMS.VESSEL_NR = DEM_DES_CLAIMS.VESSEL_NR ) and  
//         		( CLAIMS.VOYAGE_NR = DEM_DES_CLAIMS.VOYAGE_NR ) and  
//         		( CLAIMS.CLAIM_NR = DEM_DES_CLAIMS.CLAIM_NR ) and  
//         		( ( DEM_DES_CLAIMS.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//			(CLAIMS.CLAIM_TYPE = "DEM" ) AND
//         		( CLAIMS.CLAIM_AMOUNT_USD > 0 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_demurrage_act) then ld_demurrage_act = 0
//
//	/* Set Despatch Est for cp */
//	
//	SELECT SUM(CAL_CARG_TOTAL_DESPATCH)
//	INTO :ld_despatch_est
//	FROM CAL_CARG
//	WHERE (CAL_CERP_ID = :ll_cal_cerp_id) AND
//		(CAL_CARG_STATUS = 6);
//	COMMIT Using Sqlca;
//	If IsNull(ld_despatch_est) Then ld_despatch_est = 0
//
//	/* Set Despatch Act for cp */
//	SELECT PC_NR
//	INTO :li_pc_nr
//	FROM VESSELS
//	WHERE VESSEL_NR = :li_vessel_nr;
//	COMMIT Using Sqlca;
//	if li_pc_nr = 3 or li_pc_nr = 5 then
//		SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//	    	INTO :ld_despatch_act
//	    	FROM DEM_DES_CLAIMS,   CLAIMS  
//		WHERE 	( CLAIMS.CHART_NR = DEM_DES_CLAIMS.CHART_NR ) and  
//	         		( CLAIMS.VESSEL_NR = DEM_DES_CLAIMS.VESSEL_NR ) and  
//	         		( CLAIMS.VOYAGE_NR = DEM_DES_CLAIMS.VOYAGE_NR ) and  
//	         		( CLAIMS.CLAIM_NR = DEM_DES_CLAIMS.CLAIM_NR ) and  
//	         		( ( DEM_DES_CLAIMS.CAL_CERP_ID = :ll_cal_cerp_id ) AND  
//				(CLAIMS.CLAIM_TYPE = "DEM" ) AND
//	         		( CLAIMS.CLAIM_AMOUNT_USD < 0 ) )   ;
//		COMMIT Using Sqlca;
//	else
//		ld_despatch_act = 0
//	end if
//	if isnull(ld_despatch_act) then ld_despatch_act = 0
//	
//
//	/* Set Commission Est for cp */
//	
//	SELECT SUM(CAL_CARG_TOTAL_COMMISSION)
//	INTO :ld_commission_est
//	FROM CAL_CARG
//	WHERE (CAL_CERP_ID = :ll_cal_cerp_id) AND
//		(CAL_CARG_STATUS = 6);
//	COMMIT Using Sqlca;
//	If IsNull(ld_commission_est) Then ld_commission_est = 0 
//
//	/* Set Commisssion Act for cp */
//  	SELECT sum(COMMISSIONS.COMM_AMOUNT)  
//    	INTO :ld_commission_act
//    	FROM COMMISSIONS, VOYAGES, CAL_CALC, CAL_CARG, CAL_CERP  
//	WHERE 	( COMMISSIONS.VESSEL_NR = VOYAGES.VESSEL_NR ) and  
//         		( COMMISSIONS.VOYAGE_NR = VOYAGES.VOYAGE_NR ) and  
//         		( CAL_CALC.CAL_CALC_ID = VOYAGES.CAL_CALC_ID ) and  
//        		( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
//         		( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
//         		( ( CAL_CERP.CAL_CERP_ID = :ll_cal_cerp_id ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_commission_act) then ld_commission_act = 0
//	ld_commission_act += ld_addr_comm
//
//	/* Set Bunkers Est for cp */
//	 ld_bunkers_est = 0	
//
//	/* Set Bunkers Act for cp */
//	ld_bunkers_act = 0
//
//	/* Set Port Est for cp */
//	ld_port_est = 0
//
//	/* Set Port Act for cp */
//	ld_port_act = 0
//
//	/* Set Misc Est for cp */
//	ld_misc_est = 0
//
//	/* Set Misc Act for cp */
//	ld_misc_act = 0
//
//	/* Set Off Hire Est for cp */
//	 ld_off_hire_est = 0
//
//	/* Set Off Hire Act for cp */
//	ld_off_hire_act = 0
//
//	/* Set Off Days Est for cp */
//	li_off_days_est = 0
//
//	/* Set Off Days Act for cp */
//	li_off_days_act = 0
//
//	/* Set Idle Days Est for cp */
//	li_idle_days_est = 0
//
//	/* Set Idle Days Act for cp */
//	li_idle_days_act = 0
//
//	/* Set Grossdays Est for cp */
//	li_grossdays_est = 0
//
//	/* Set Grossdays Act for cp */
//	li_grossdays_act = 0
//
//	/* Insert new row into datawarehouser and test for error and return error if sql failed */
//	INSERT INTO CCS_DATAWAREHOUSE(DW_SERIAL,CONTRACT_TYPE,CAL_CERP_ID,CHARTERER_SHORTNAME, 
//				CHARTERER_GROUP,CP_DATE,VESSEL_NR,VOYAGE_NR,NO_VOYAGES_EST,NO_VOYAGES_ACT,
//				NO_TON_EST, NO_TON_ACT, GROSS_HIRE_EST, GROSS_HIRE_ACT, DEMURRAGE_EST,
//				DEMURRAGE_ACT, DESPATCH_EST, DESPATCH_ACT, COMISSION_EST, COMISSION_ACT,
//				BUNKERS_EST, BUNKERS_ACT, PORT_EST, PORT_ACT, MISC_EST, MISC_ACT, OFF_HIRE_EST,
//				OFF_HIRE_ACT, OFF_DAYS_EST, OFF_DAYS_ACT, IDLE_DAYS_EST, IDLE_DAYS_ACT,
//				GROSSDAYS_EST, GROSSDAYS_ACT)	
//	VALUES(:ll_dw_serial,:li_contract_type,:ll_cal_cerp_id,:ls_chart_sn,:ls_charterer_group,:ldt_cp_date,:li_vessel_nr,
//			:ls_voyage_nr,:li_no_voyages_est,:li_no_voyages_act, :ld_no_ton_est, :ld_no_ton_act, :ld_gross_hire_est,
//			:ld_gross_hire_act, :ld_demurrage_est, :ld_demurrage_act, :ld_despatch_est, :ld_despatch_act,
//			:ld_commission_est, :ld_commission_act, :ld_bunkers_est, :ld_bunkers_act, :ld_port_est, :ld_port_act,
//			:ld_misc_est, :ld_misc_act, :ld_off_hire_est, :ld_off_hire_act, :li_off_days_est, :li_off_days_act,
//			:li_idle_days_est, :li_idle_days_act, :li_grossdays_est, :li_grossdays_act );
//	if sqlca.SQLCode = -1 then
//		ls_return_string = sqlca.SQLErrText
//		/* Disconnect and destroy temp transaction object */
//		disconnect using temp_tran;
//		destroy temp_tran
//		/* If error inserting into datawarehouse, write error to log and return */
//		If Isvalid(w_warehouse_errors) THEN
//			ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with CP stopped")
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Insert into datawarehouse failed and returned message: "+ls_return_string)
//		end if
//		return ls_return_string
//	end if
//	commit;
//	/* Fetch next cp id */
//	fetch cp_cursor into :ll_cal_cerp_id,:ldt_cp_date;
//LOOP
///* Close cursor and test for error and return error if sql failed */
//close cp_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error closing cursor, write error to log and return */
//		If Isvalid(w_warehouse_errors) THEN
//			ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with CP stopped")
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Close cp_cursor failed and returned message: "+ls_return_string)
//		end if
//	return ls_return_string
//end if
//
///* Disconnect and destroy temp transaction object */
//commit using temp_tran;
//disconnect using temp_tran;
//destroy temp_tran
///* Return string */
return ls_return_string
end function

private function string uf_recreate_datawarehouse ();///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : n/a
//  
// Object     : uf_recreate_datawarehouse
//  
// Event	 : call
//
// Scope     : private
//
// ************************************************************************************
//
// Author    : Peter Bendix-Toft
//   
// Date       : 15-08-96
//
// Description : This function deletes all rows in the datawarehouse table
//
// Arguments : none
//
// Returns   : String : 	NULL if function performed OK     OR
//				Message of what failed 
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//15-08-96 		3.0			PBT		SYSTEM 3
//************************************************************************************/
///* Local Variables */
string ls_return_string
//
///* Set return string null */
//setnull(ls_return_string)
//
///* Delete all row from datawarehouse */
//delete from CCS_DATAWAREHOUSE;
//
///* Test sqlcode and return error if fail */
//if sqlca.SQLCode = -1 then
//	rollback;
//	return sqlca.SQLErrText
//end if
//
///* Commit the transaction */
//commit;
//
///* Test sqlcode and return error if fail */
//if sqlca.SQLCode = -1 then
//	return sqlca.SQLErrText
//end if
//
/* Return string */
return ls_return_string








end function

private function string uf_recreate_tc_out_data (integer il_count_total, integer il_count_so_far);///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : n/a
//  
// Object     : uf_recreate_tc_out_data
//  
// Event	 : call
//
// Scope     : private
//
// ************************************************************************************
//
// Author    : Peter Bendix-Toft
//   
// Date       : 15-08-96
//
// Description : This function creates all the new datawarehouse rows
//			for all TC Out's
//
// Arguments : none
//
// Returns   : String : 	NULL if function performed OK     OR
//				Message of what failed 
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE				VERSION 		NAME		DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//18-09-96 		3.0			PBT		SYSTEM 3
//10-12-97			5.0			JEH		Changed so funktion writes error to log and does not
//												stop, unless system error is incurred.
//10-12-97			5.0			JEH		Inserted COMMIT Using Sqlca efter Select statements
//************************************************************************************/
///* Local Variables */
//uo_addr_comm u_addr_comm
string ls_return_string
//, ls_chart_sn, ls_charterer_group, ls_voyage_nr, ls_current_voyage_nr, ls_last_voyage_nr
//transaction temp_tran
//long  ll_cal_cerp_id, ll_dw_serial, ll_chart_nr,ll_row
//int li_contract_type, li_vessel_nr, li_no_voyages_est, li_no_voyages_act
//dec{2} ld_idle_days_est, ld_idle_days_act, ld_grossdays_est, ld_grossdays_act, ld_off_days_est, ld_off_days_act
//dec{2} ld_temp_off_days_act, ld_temp_grossdays_act
//datetime ldt_cp_date, ldt_delivery, ldt_redelivery
//decimal ld_dummy[3], ld_hfo, ld_do, ld_go
//decimal ld_bunkers_est, ld_bunkers_act, ld_port_est, ld_port_act, ld_misc_est, ld_misc_act
//decimal ld_off_hire_est, ld_off_hire_act, ld_no_ton_est, ld_no_ton_act, ld_gross_hire_est, ld_gross_hire_act
//decimal ld_demurrage_est, ld_demurrage_act, ld_despatch_est, ld_despatch_act, ld_commission_est, ld_commission_act
//decimal ld_temp_misc_act , ld_temp_off_hire_act
//boolean lb_bare_boat
//u_superimpose_tc_hire uo_superimpose_tc_hire
//
///* Set return string null */
//setnull(ls_return_string)
//ll_dw_serial = il_count_so_far
//
///* Create and connect transaction object */
//temp_tran = create transaction
//uo_global.defaulttransactionobject(temp_tran)
//connect using temp_tran;
//
///* Create cursor over all cp's that are estimated and test for error and return error if sql failed */
//DECLARE tc_out_cursor CURSOR FOR
//SELECT DISTINCT T.DELIVERY_DATE , T.VESSEL_NR,T.CHART_NR,T.TCHIRE_CP_DATE,T.BARE_BOAT
//FROM TCHIRES T, TCHIRERATES TR
//WHERE	T.VESSEL_NR = TR.VESSEL_NR AND
//		T.TCHIRE_CP_DATE = TR.TCHIRE_CP_DATE  and
//		T.TCHIRE_IN = 0  using temp_tran;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with TC Out Stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database tc out cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* Open cursor and test for error and return error if sql failed */
//open tc_out_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with TC Out Stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open tc out cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* fetch the first cp */
//fetch tc_out_cursor into :ldt_delivery, :li_vessel_nr,:ll_chart_nr, :ldt_cp_date,:lb_bare_boat;
///* While there are vessel/voyages do... */
//DO WHILE temp_tran.sqlcode = 0
//	/* Get redelivery date */
//	SELECT max(TR.TC_PERIOD_END)
//	INTO  :ldt_redelivery
//	FROM TCHIRES T, TCHIRERATES TR
//	WHERE	T.VESSEL_NR = TR.VESSEL_NR AND
//			T.TCHIRE_CP_DATE = TR.TCHIRE_CP_DATE and
//			T.TCHIRE_IN = 0 AND
//			T.VESSEL_NR = :li_vessel_nr and
//			T.TCHIRE_CP_DATE = :ldt_cp_date;
//	COMMIT Using Sqlca;
//
//	/* Set dw serial for cp */
//	ll_dw_serial++
////	if mod(ll_dw_serial,5) = 0 then
//		w_progress_no_cancel.wf_progress(ll_dw_serial/il_count_total,"Creating Data Warehouse for TC-Out")
////	end if
//
//	/* Set contract Type for cp */
//	if lb_bare_boat then
//		li_contract_type = 6
//	else
//		li_contract_type = 5
//	end if
//
//	/* Set cal cerp id */
//	setnull(ll_cal_cerp_id)	
//
//	/* Set Charterer ShortName for cp */
//	SELECT CHART_SN
//	INTO :ls_chart_sn  
//	FROM CHART
//	WHERE	CHART_NR = :ll_chart_nr;
//	COMMIT Using Sqlca;
//	if isnull(ls_chart_sn) then ls_chart_sn = ""
//
//	/* Set Charterer Group for cp */	
//	SELECT CCS_CHGP.CCS_CHGP_NAME  
//    	INTO :ls_charterer_group  
//    	FROM  CCS_CHGP,   CHART  
//	WHERE 	( CCS_CHGP.CCS_CHGP_PK = CHART.CCS_CHGP_PK );
//	COMMIT Using Sqlca;
//	if isnull(ls_charterer_group) or ls_charterer_group = "" then ls_charterer_group = "No Group Given"
//
//	/* Set cp date for cp */
//	// Set in Cursor
//
//	/* Set Vessel Nr for cp */
//	// Set in Cursor
//
//	/* Set Voyage_nr for cp */
//	setnull(ls_voyage_nr)
//
//	/* Set Est Number of Voyages for cp */
//	li_no_voyages_est  = 0
//
//	/* Set Act Number of Voyages for cp */
//	li_no_voyages_act  = 0
//
//	/* Set Number of Tonns Est for cp */
//	ld_no_ton_est = 0
//
//	/* Set Number of Tonns Act for cp */	
//	ld_no_ton_act  = 0
//
//	/* Set Gross Hire Est for tc */
//	ld_gross_hire_est = 0
//
//	/* Set Gross Hire Act for tc */
//	uo_superimpose_tc_hire = CREATE u_superimpose_tc_hire 
//
//	If not uo_superimpose_tc_hire.uf_freight(1,4, li_vessel_nr, ls_voyage_nr, ld_gross_hire_act) Then
//		ld_gross_hire_act = 0
//	End 	if
//
//	DESTROY uo_superimpose_tc_hire
//	
//	/* Set Demurage Est for cp */
//	ld_demurrage_est = 0
//
//	/* Set Demurrage Act for cp */
//	ld_demurrage_act = 0
//
//	/* Set Despatch Est for cp */
//	ld_despatch_est = 0
//
//	/* Set Despatch Act for cp */
//	ld_despatch_act = 0
//
//	/* Set Commission Est for cp */
//	ld_commission_est = 0
//
//	/* Set Commisssion Act for cp */
//	SELECT ISNULL(SUM(TCCOMMISSION.TCCOMM_AMOUNT),0)  
//	INTO :ld_commission_act
//    	FROM TCCOMMISSION  
//   	WHERE ( TCCOMMISSION.VESSEL_NR = :li_vessel_nr ) AND  
//         ( TCCOMMISSION.TCHIRE_CP_DATE = :ldt_cp_date);
//	COMMIT Using Sqlca;
//	
//	/* Set Bunkers Est for cp */
//	ld_bunkers_est = 0
//
//	/* Set Bunkers Act for cp */
//	ld_bunkers_act = 0
//
//	/* Set Port Est for cp */
//	ld_port_est = 0
//
//	/* Set Port Act for TC-Out */
//	ld_port_act = 0
//
//	/* Set Misc Est for TC-Out */
//	ld_misc_est = 0
//
//	/* Set Misc Act for TC-Out */
//	ld_misc_act = 0
//	ls_last_voyage_nr =" " 
//	sqlca.sqlcode = 0
//	DO WHILE sqlca.sqlcode <> 100
//			ld_temp_misc_act = 0
//			SELECT DISTINCT VOYAGE_NR
//			INTO :ls_current_voyage_nr
//			FROM POC
//			WHERE	VESSEL_NR = :li_vessel_nr AND
//					PORT_ARR_DT > :ldt_delivery and
//					PORT_ARR_DT < :ldt_redelivery and
//					VOYAGE_NR > :ls_last_voyage_nr
//			ORDER BY VOYAGE_NR ASC;
//			if sqlca.sqlcode <> 100  then
//				if not isnull(ls_current_voyage_nr) and ls_current_voyage_nr <> ls_last_voyage_nr then
//					SELECT  sum(DE.EXP_AMOUNT_USD)
//					INTO :ld_temp_misc_act
//					FROM 	DISB_EXPENSES DE
//				   	WHERE 	( DE.VESSEL_NR = :li_vessel_nr ) and  
//							( DE.VOYAGE_NR = :ls_current_voyage_nr ) AND  
//							(DE.VOUCHER_NR in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,23,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49)  ) ;
//					if not isnull(ld_temp_misc_act) then ld_misc_act += ld_temp_misc_act
//					ls_last_voyage_nr = ls_current_voyage_nr
//				end if
//			end if	
//	LOOP
//	COMMIT Using Sqlca;
//	if isnull(ld_misc_act) then ld_misc_act = 0
//
//	/* Set Off Hire Est for tc-out */
//	 ld_off_hire_est = 0
//
//	/* Set Off Hire Act for tc-out */
//	ld_off_hire_act = 0
//	if not lb_bare_boat then
//		ls_last_voyage_nr =" " 
//		sqlca.sqlcode = 0
//		DO WHILE sqlca.sqlcode <> 100
//				ld_temp_off_hire_act = 0
//				SELECT DISTINCT VOYAGE_NR
//				INTO :ls_current_voyage_nr
//				FROM POC
//				WHERE	VESSEL_NR = :li_vessel_nr AND
//						PORT_ARR_DT > :ldt_delivery and
//						PORT_ARR_DT < :ldt_redelivery and
//						VOYAGE_NR > :ls_last_voyage_nr
//				ORDER BY VOYAGE_NR ASC;
//				if sqlca.sqlcode <> 100 then
//					if not isnull(ls_current_voyage_nr) and ls_current_voyage_nr <> ls_last_voyage_nr then
//						ld_hfo = 0
//						ld_do = 0
//						ld_go = 0
//						SELECT sum(OFF_FUEL_OIL_USED),sum(OFF_DIESEL_OIL_USED),sum(OFF_GAS_OIL_USED)
//						INTO :ld_hfo, :ld_do, :ld_go
//						FROM OFF_SERVICES
//						WHERE 	(VESSEL_NR = :li_vessel_nr AND
//								VOYAGE_NR = :ls_current_voyage_nr );
//						if isnull(ld_hfo) then ld_hfo = 0
//						if isnull(ld_do) then ld_do = 0
//						if isnull(ld_go) then ld_go = 0
//						ld_dummy[1] = ld_hfo
//						ld_dummy[2] = ld_do
//						ld_dummy[3] = ld_go
//						ld_hfo = 0
//						ld_do = 0
//						ld_go = 0
//						SELECT sum(FUEL_OIL_USED),sum(DIESEL_OIL_USED),sum(GAS_OIL_USED)
//						INTO :ld_hfo, :ld_do, :ld_go
//						FROM IDLE_DAYS
//						WHERE 	(VESSEL_NR = :li_vessel_nr AND
//								VOYAGE_NR = :ls_current_voyage_nr );
//						if isnull(ld_hfo) then ld_hfo = 0
//						if isnull(ld_do) then ld_do = 0
//						if isnull(ld_go) then ld_go = 0
//						ld_dummy[1] += ld_hfo
//						ld_dummy[2] += ld_do
//						ld_dummy[3] += ld_go
//						ld_temp_off_hire_act  = f_calc_fuel_cost_for_voyage(li_vessel_nr,ld_dummy[],ls_current_voyage_nr)
//						if not isnull(ld_temp_off_hire_act) then ld_off_hire_act += ld_temp_off_hire_act
//						ls_last_voyage_nr = ls_current_voyage_nr
//					end if
//				end if	
//		LOOP
//		COMMIT Using Sqlca;
//		if isnull(ld_off_hire_act) then ld_off_hire_act = 0
//	end if
//
//	/* Set Off Days Est for cp */
//	ld_off_days_est = 0
//
//	/* Set Off Days Act for TC */
//	uo_superimpose_tc_hire = CREATE u_superimpose_tc_hire 
//
//	If not uo_superimpose_tc_hire.uf_freight(4,4, li_vessel_nr, ls_voyage_nr, ld_off_days_act) Then
//		ld_off_days_act = 0
//	End 	if
//
//	DESTROY uo_superimpose_tc_hire 
//		
//	/* Set Idle Days Est for cp */
//	ld_idle_days_est = 0
//
//	/* Set Idle Days Act for cp */
//	ld_idle_days_act = 0
//
//	/* Set Grossdays Est for cp */
//	ld_grossdays_est = 0
//
//	/* Set Grossdays Act for cp */
//	SELECT Datediff(Minute, Min(P.PORT_ARR_DT), max(P.PORT_DEPT_DT)) 
//	INTO :ld_grossdays_act
//	FROM POC P
//	WHERE P.VESSEL_NR = :li_vessel_nr AND
//		P.VOYAGE_NR = :ls_voyage_nr;
//	COMMIT Using Sqlca;
//
//	// Same calculation as vessel/voyage
//	if isnull(ld_grossdays_act) then 
//		ld_grossdays_act = 0
//	else
//		ld_grossdays_act =  truncate((ld_grossdays_act/60),0) + (mod(ld_grossdays_act,60)/100)
//	end if
//	
//	/* Insert new row into datawarehouser and test for error and return error if sql failed */
//	INSERT INTO CCS_DATAWAREHOUSE(DW_SERIAL,CONTRACT_TYPE,CAL_CERP_ID,CHARTERER_SHORTNAME, 
//				CHARTERER_GROUP,CP_DATE,VESSEL_NR,VOYAGE_NR,NO_VOYAGES_EST,NO_VOYAGES_ACT,
//				NO_TON_EST, NO_TON_ACT, GROSS_HIRE_EST, GROSS_HIRE_ACT, DEMURRAGE_EST,
//				DEMURRAGE_ACT, DESPATCH_EST, DESPATCH_ACT, COMISSION_EST, COMISSION_ACT,
//				BUNKERS_EST, BUNKERS_ACT, PORT_EST, PORT_ACT, MISC_EST, MISC_ACT, OFF_HIRE_EST,
//				OFF_HIRE_ACT, OFF_DAYS_EST, OFF_DAYS_ACT, IDLE_DAYS_EST, IDLE_DAYS_ACT,
//				GROSSDAYS_EST, GROSSDAYS_ACT)	
//	VALUES(:ll_dw_serial,:li_contract_type,:ll_cal_cerp_id,:ls_chart_sn,:ls_charterer_group,:ldt_cp_date,:li_vessel_nr,
//			:ls_voyage_nr,:li_no_voyages_est,:li_no_voyages_act, :ld_no_ton_est, :ld_no_ton_act, :ld_gross_hire_est,
//			:ld_gross_hire_act, :ld_demurrage_est, :ld_demurrage_act, :ld_despatch_est, :ld_despatch_act,
//			:ld_commission_est, :ld_commission_act, :ld_bunkers_est, :ld_bunkers_act, :ld_port_est, :ld_port_act,
//			:ld_misc_est, :ld_misc_act, :ld_off_hire_est, :ld_off_hire_act, :ld_off_days_est, :ld_off_days_act,
//			:ld_idle_days_est, :ld_idle_days_act, :ld_grossdays_est, :ld_grossdays_act );
//	if sqlca.SQLCode = -1 then
//		ls_return_string = sqlca.SQLErrText
//		/* Disconnect and destroy temp transaction object */
//		disconnect using temp_tran;
//		destroy temp_tran
//		/* If error inserting into datawarehouse, write error to log and return */
//		If Isvalid(w_warehouse_errors) THEN
//			ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with TC Out stopped")
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Insert into datawarehouse failed and returned message: "+ls_return_string)
//		end if
//		return ls_return_string
//	end if
//	commit;
//	/* Fetch next cp id */
//	fetch tc_out_cursor into :ldt_delivery, :li_vessel_nr,:ll_chart_nr, :ldt_cp_date, :lb_bare_boat;
//LOOP
///* Close cursor and test for error and return error if sql failed */
//close tc_out_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with TC Out stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Close tc out cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* Disconnect and destroy temp transaction object */
//commit using temp_tran;
//disconnect using temp_tran;
//destroy temp_tran;
/* Return string */
return ls_return_string
end function

private function string uf_recreate_vessel_voyage_data (integer il_count_total, integer il_count_so_far);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : uf_recreate_vessel_voyage_data
  
 Event	 : call

 Scope     : private

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 15-08-96

 Description : This function creates all the new datawarehouse rows
			for all vessel_voyages

 Arguments : none

 Returns   : String : 	NULL if function performed OK     OR
				Message of what failed 

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE				VERSION 		NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-09-96 		3.0			PBT		SYSTEM 3
06-11-96			3.0			RM			/* Set Grossdays Est for vessel/voyage */
												SELECT (C.CAL_CALC_TOTAL_DAYS/24)
												ændret til 
												SELECT (C.CAL_CALC_TOTAL_DAYS)
06-11-96			3.0			RM			/* Set Off Days Act for vessel/voyage */
												SELECT (sum(OFF_TIME_DAYS*24) + (sum(OFF_TIME_HOURS))) + (sum(OFF_TIME_MINUTES)/100)
												ændret til
												SELECT (sum(OFF_TIME_DAYS*24) + (sum(OFF_TIME_HOURS))) + (sum(OFF_TIME_MINUTES)/60)
06-11-96			3.0			RM			/* Set Idle Days Act for vessel/voyage */
												SELECT (sum(IDLE_TIME_DAYS*24) + (sum(IDLE_TIME_HOURS))) + (sum(IDLE_TIME_MINUTES)/100)
												ændret til
												SELECT (sum(IDLE_TIME_DAYS*24) + (sum(IDLE_TIME_HOURS))) + (sum(IDLE_TIME_MINUTES)/60)
06-12-96			3.0			MI			Added CALC summs from calculation (kept then 333 for search purpose)

09-12-97			5.0			JEH		Changed so funktion writes error to log and does not
												stop, unless system error is incurred.
10-12-97			5.0			JEH		Inserted COMMIT Using Sqlca efter Select statements
************************************************************************************/


// Everything is disabled in order not to have any links to the old VAS, 
// which is no longer in use. Leith 14/9-98. I reimplemented then watch out for
// date manipulations. The PC format can be YYYY-MM-DD or DD-MM-YY.


/* Local Variables */
//string ls_return_string, ls_sql, ls_chart_sn, ls_charterer_group, ls_voyage_nr
//transaction temp_tran
//uo_addr_comm u_addr_comm
//long  ll_cal_cerp_id, ll_dw_serial, ll_calc_id,ll_row
//int li_contract_type, li_vessel_nr, li_no_voyages_est, li_no_voyages_act, li_pc_nr
//dec{2} ld_idle_days_est, ld_idle_days_act, ld_grossdays_est, ld_grossdays_act, ld_off_days_est, ld_off_days_act
//datetime ldt_cp_date
//decimal ld_dummy[3], ld_hfo, ld_do, ld_go, ld_freight_act, ld_freight, ld_freight_adv_act, ld_addr_comm
//decimal ld_bunkers_est, ld_bunkers_act, ld_port_est, ld_port_act, ld_misc_est, ld_misc_act
//decimal ld_off_hire_est, ld_off_hire_act, ld_no_ton_est, ld_no_ton_act, ld_gross_hire_est, ld_gross_hire_act
//decimal ld_demurrage_est, ld_demurrage_act, ld_despatch_est, ld_despatch_act, ld_commission_est, ld_commission_act
//u_vas lu_vas
//u_vas_functions lu_vas_functions
//
///* Create User Object VAS_FUNCTIONS */
//lu_vas_functions = CREATE u_vas_functions
//
///* Create User Object VAS */
//lu_vas = create u_vas
//
///* Set return string null */
//setnull(ls_return_string)
//ll_dw_serial = il_count_so_far
//
///* Create and connect transaction object */
//temp_tran = create transaction
//uo_global.defaulttransactionobject(temp_tran)
//connect using temp_tran;
//
///* Create cursor over all cp's that are estimated and test for error and return error if sql failed */
//DECLARE ves_voy_cursor CURSOR FOR  
//SELECT DISTINCT VESSEL_NR,VOYAGE_NR
//FROM VOYAGES  
//WHERE	CAL_CALC_ID > 1 AND
//		VOYAGE_TYPE <> 2  using temp_tran ;
//
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* destroy User Object VAS */
//	destroy lu_vas
//	DESTROY lu_vas_functions
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage Stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database ves voy cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* Open cursor and test for error and return error if sql failed */
//open ves_voy_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* destroy User Object VAS */
//	destroy lu_vas
//	DESTROY lu_vas_functions
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open ves voy cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* fetch the first vessel/voyage */
//fetch ves_voy_cursor into :li_vessel_nr,:ls_voyage_nr;
///* While there are vessel/voyages do... */
//DO WHILE temp_tran.sqlcode = 0
//	/* Set dw serial for vessel/voyage */
//	ll_dw_serial++
////	if mod(ll_dw_serial,5) = 0 then
//		w_progress_no_cancel.wf_progress(ll_dw_serial/il_count_total,"Creating Data Warehouse for Vessel/Voyage")
////	end if
//
//	/* Set contract Type for vessel/voyage */
//	setnull(li_contract_type)
//
//	/* Set cal cerp id */
//	setnull(ll_cal_cerp_id)	
//
//	/* Set Charterer ShortName for vessel/voyage */
//	setnull(ls_chart_sn  )
//
//	/* Set Charterer Group for vessel/voyage */	
//	setnull(ls_charterer_group  )
//
//	/* Set cp date for vessel/voyage */
//	setnull(ldt_cp_date)	
//
//	/* Set Vessel Nr for vessel/voyage */
//	// Set in Cursor
//
//	/* Set Voyage_nr for vessel/voyage */
//	// Set in Cursor
//
//	/* Set Est Number of Voyages for vessel/voyage */
//	li_no_voyages_est  = 0
//
//	/* Set Act Number of Voyages for vessel/voyage */
//	li_no_voyages_act  = 0
//
//	/* Set Number of Tonns Est for vessel/voyage */
//	// Get CALC ID
//	SELECT CAL_CALC_ID
//	INTO :ll_calc_id
//	FROM VOYAGES
//	WHERE (VESSEL_NR = :li_vessel_nr) And
//		(VOYAGE_NR = :ls_voyage_nr);
//	COMMIT Using Sqlca;
//
//
//	SELECT SUM(CAL_CARG_TOTAL_UNITS)
//	INTO :ld_no_ton_est
//	FROM CAL_CARG
//	WHERE CAL_CALC_ID = :ll_calc_id;
//	COMMIT Using Sqlca;
//	If IsNull(ld_no_ton_est) Then ld_no_ton_est = 0
//
//	/* Set Number of Tonns Act for vessel/voyage */	
//  	SELECT SUM(BOL.BOL_QUANTITY)  
//    	INTO :ld_no_ton_act  
//    	FROM BOL
//   	WHERE ( ( VESSEL_NR = :li_vessel_nr) AND  
//			( VOYAGE_NR = :ls_voyage_nr ) AND
//         		( L_D = 1 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_no_ton_act) then ld_no_ton_act = 0
//
//	/* Set Gross Hire Est for vessel/voyage */
//	SELECT C.CAL_CALC_GROSS_FREIGHT
//	INTO :ld_gross_hire_est 
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID;
//	COMMIT Using Sqlca;
//	if isnull(ld_gross_hire_est) then ld_gross_hire_est = 0
//
//	/* Set Gross Hire Act for vessel/voyage */
//
//	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//    	INTO :ld_freight_act
//    	FROM CLAIMS,FREIGHT_CLAIMS F  
//	WHERE 	( CLAIMS.CHART_NR = F.CHART_NR ) and  
//         		( CLAIMS.VESSEL_NR = F.VESSEL_NR ) and  
//         		( CLAIMS.VOYAGE_NR =F.VOYAGE_NR ) and  
//         		( CLAIMS.CLAIM_NR = F.CLAIM_NR ) and  
//			((F.VESSEL_NR = :li_vessel_nr ) AND
//			(F.VOYAGE_NR = :ls_voyage_nr ) AND
//			(CLAIMS.CLAIM_TYPE = "FRT" ) AND
//         		( CLAIMS.CLAIM_AMOUNT_USD > 0 ) )   ;
//	COMMIT Using Sqlca;
//	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
//    	INTO :ld_freight_adv_act
//    	FROM CLAIMS,FREIGHT_ADVANCED F  
//	WHERE 	( CLAIMS.CHART_NR = F.CHART_NR ) and  
//         		( CLAIMS.VESSEL_NR = F.VESSEL_NR ) and  
//         		( CLAIMS.VOYAGE_NR =F.VOYAGE_NR ) and  
//         		( CLAIMS.CLAIM_NR = F.CLAIM_NR ) and  
//			((F.VESSEL_NR = :li_vessel_nr ) AND
//			(F.VOYAGE_NR = :ls_voyage_nr ) AND
//			(F.AFC_NR = 1 ) AND
//			(CLAIMS.CLAIM_TYPE = "FRT" ) AND
//         		( CLAIMS.CLAIM_AMOUNT_USD > 0 ) )   ;
//	COMMIT Using Sqlca;
//	if isnull(ld_freight_act) then ld_freight_act = 0
//	if isnull(ld_freight_adv_act) then ld_freight_adv_act = 0
//	ld_freight = ld_freight_adv_act + ld_freight_act
//	u_addr_comm = create uo_addr_comm
//	ld_addr_comm = u_addr_comm.uf_get_adr_comm(0,li_vessel_nr,ls_voyage_nr)
//	if ld_addr_comm < 0 then
//		ls_return_string = "Function Getting Adress Commision failed! Therefor calculation of Gross Hire Actual and Commission Actual not correct for vessel/voyage/address commision "+string(li_vessel_nr)+"/"+ls_voyage_nr+"/"+string(ld_addr_comm)
//		/* If error found in function, write error to log*/
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,ls_return_string)
//	end if
/////* Disconnect and destroy temp transaction object */
////		disconnect using temp_tran;
////		destroy temp_tran
////		destroy u_addr_comm
////		/* destroy User Object VAS */
////		destroy lu_vas
////		DESTROY lu_vas_functions
////		/* Return string */
////		return ls_return_string
//	end if
//	ld_gross_hire_act = ld_freight + ld_addr_comm
//	destroy u_addr_comm
//
//	/* Set Demurage Est for vessel/voyage */
//	SELECT C.CAL_CALC_TOTAL_DEMURRAGE	
//	INTO :ld_demurrage_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID AND
//			C.CAL_CALC_TOTAL_DEMURRAGE > 0 ;
//	COMMIT Using Sqlca;
//	if isnull(ld_demurrage_est) then ld_demurrage_est = 0
//
//	/* Set Demurrage Act for vessel/voyage */
//	SELECT SUM(CLAIM_AMOUNT_USD)
//	INTO :ld_demurrage_act
//	FROM CLAIMS
//	WHERE 	CLAIM_TYPE = "DEM" AND
//			CLAIM_AMOUNT_USD > 0 AND
//			VESSEL_NR = :li_vessel_nr AND
//			VOYAGE_NR = :ls_voyage_nr;
//	COMMIT Using Sqlca;
//	if isnull(ld_demurrage_act) then ld_demurrage_act = 0
//
//	/* Set Despatch Est for vessel/voyage */
//	SELECT C.CAL_CALC_TOTAL_DEMURRAGE	
//	INTO :ld_despatch_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID AND
//			C.CAL_CALC_TOTAL_DEMURRAGE < 0 ;
//	COMMIT Using Sqlca;
//	if isnull(ld_despatch_est) then ld_despatch_est = 0
//
//	/* Set Despatch Act for vessel/voyage */
//	SELECT PC_NR
//	INTO :li_pc_nr
//	FROM VESSELS
//	WHERE VESSEL_NR = :li_vessel_nr;
//	COMMIT Using Sqlca;
//	if li_pc_nr = 3 or li_pc_nr = 5 then
//		SELECT SUM(CLAIM_AMOUNT_USD)
//		INTO :ld_despatch_act	
//		FROM CLAIMS
//		WHERE 	CLAIM_TYPE = "DEM" AND
//				CLAIM_AMOUNT_USD < 0 AND
//				VESSEL_NR = :li_vessel_nr AND
//				VOYAGE_NR = :ls_voyage_nr;
//		COMMIT Using Sqlca;
//	else
//		ld_despatch_act = 0
//	end if
//	if isnull(ld_despatch_act) then ld_despatch_act = 0
//
//	/* Set Commission Est for vessel/voyage */
//	SELECT CAL_CALC_TOTAL_COMMISSION + CAL_CALC_TOTAL_ADR_COMMISSION
//	INTO :ld_commission_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_commission_est) then ld_commission_est = 0
//
//	/* Set Commisssion Act for vessel/voyage */
//  	SELECT sum(COMMISSIONS.COMM_AMOUNT)  
//    	INTO :ld_commission_act
//    	FROM COMMISSIONS
//	WHERE 	( ( VESSEL_NR = :li_vessel_nr ) and
//			( VOYAGE_NR = :ls_voyage_nr ));
//	COMMIT Using Sqlca;
//	if isnull(ld_commission_act) then ld_commission_act = 0
//	ld_commission_act += ld_addr_comm
//
//	/* Set Bunkers Est for vessel/voyage */
//	SELECT C.CAL_CALC_FO_EXPENSES + C.CAL_CALC_DO_EXPENSES + C.CAL_CALC_MGO_EXPENSES
//	INTO :ld_bunkers_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_bunkers_est) then ld_bunkers_est = 0
//
//	/* Set Bunkers Act for vessel/voyage */
//	ld_dummy[1] = lu_vas_functions.uf_get_vv_actual_bunker_mt_fo(li_vessel_nr, ls_voyage_nr)
//	ld_dummy[2] = lu_vas_functions.uf_get_vv_actual_bunker_mt_do(li_vessel_nr, ls_voyage_nr)
//	ld_dummy[3] = lu_vas_functions.uf_get_vv_actual_bunker_mt_go(li_vessel_nr, ls_voyage_nr)
//
//	ld_bunkers_act = f_calc_fuel_cost_for_voyage(li_vessel_nr,ld_dummy[],ls_voyage_nr)
//	If ld_bunkers_act < 0 then
//		if ld_bunkers_act = -1 then
//			ls_return_string = "Bunker function failed! Vessel/Voyage" + string(li_vessel_nr) + "/" + ls_voyage_nr
//			disconnect using temp_tran;
//			destroy temp_tran
//			/* destroy User Object VAS */
//			destroy lu_vas
//			DESTROY lu_vas_functions
//			/* If sql error found in function, write error to log and return*/
//			If Isvalid(w_warehouse_errors) THEN
//				ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//				w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage stopped")
//				w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,ls_return_string)
//			end if
//			return ls_return_string
//		else
//			/* Function returned negative bunkers so write error to log*/
//			ls_return_string = "Bunker function Returned negative Bunkers Actual for Vessel/Voyage" + string(li_vessel_nr) + "/" + ls_voyage_nr
//			If Isvalid(w_warehouse_errors) THEN
//				ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//				w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage")
//				w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,ls_return_string)
//			end if
//		end if
//	end if		
//
//	/* Set Port Est for vessel/voyage */
//	SELECT C.CAL_CALC_PORT_EXPENSES
//	INTO :ld_port_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_port_est) then ld_port_est = 0
//
//	/* Set Port Act for vessel/voyage */
//	ld_port_act = lu_vas.uf_get_vv_actual_port_exp(li_vessel_nr,ls_voyage_nr)
//	if isnull(ld_port_act) then ld_port_act = 0
//
//	/* Set Misc Est for vessel/voyage */
//	SELECT C.CAL_CALC_MISC_EXPENSES
//	INTO :ld_misc_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_misc_est) then ld_misc_est = 0
//
//	/* Set Misc Act for vessel/voyage */
//	ld_misc_act = lu_vas.uf_get_vv_actual_miscl_exp(li_vessel_nr,ls_voyage_nr)
//	if isnull(ld_misc_act) then ld_misc_act = 0
//
//	/* Set Off Hire Est for vessel/voyage */
//	 ld_off_hire_est = 0
//
//	/* Set Off Hire Act for vessel/voyage */
//	ld_hfo = 0
//	ld_do = 0
//	ld_go = 0
//	SELECT sum(OFF_FUEL_OIL_USED),sum(OFF_DIESEL_OIL_USED),sum(OFF_GAS_OIL_USED)
//	INTO :ld_hfo, :ld_do, :ld_go
//	FROM OFF_SERVICES
//	WHERE 	(VESSEL_NR = :li_vessel_nr AND
//			VOYAGE_NR = :ls_voyage_nr );
//	COMMIT Using Sqlca;
//	if isnull(ld_hfo) then ld_hfo = 0
//	if isnull(ld_do) then ld_do = 0
//	if isnull(ld_go) then ld_go = 0
//	ld_dummy[1] = ld_hfo
//	ld_dummy[2] = ld_do
//	ld_dummy[3] = ld_go
//	ld_hfo = 0
//	ld_do = 0
//	ld_go = 0
//	SELECT sum(FUEL_OIL_USED),sum(DIESEL_OIL_USED),sum(GAS_OIL_USED)
//	INTO :ld_hfo, :ld_do, :ld_go
//	FROM IDLE_DAYS
//	WHERE 	(VESSEL_NR = :li_vessel_nr AND
//			VOYAGE_NR = :ls_voyage_nr );
//	COMMIT Using Sqlca;
//	if isnull(ld_hfo) then ld_hfo = 0
//	if isnull(ld_do) then ld_do = 0
//	if isnull(ld_go) then ld_go = 0
//	ld_dummy[1] += ld_hfo
//	ld_dummy[2] += ld_do
//	ld_dummy[3] += ld_go
//	ld_off_hire_act  = f_calc_fuel_cost_for_voyage(li_vessel_nr,ld_dummy[],ls_voyage_nr)
//
//	/* Set Off Days Est for vessel/voyage */
//	ld_off_days_est = 0
//
//	/* Set Off Days Act for vessel/voyage */
//	SELECT (sum(OFF_TIME_DAYS*24) + (sum(OFF_TIME_HOURS))) + (sum(OFF_TIME_MINUTES)/60)
//	INTO :ld_off_days_act
//	FROM OFF_SERVICES
//	WHERE VESSEL_NR = :li_vessel_nr    AND
//			VOYAGE_NR = :ls_voyage_nr ;
//	COMMIT Using Sqlca;
//	if isnull(ld_off_days_act) then ld_off_days_act = 0
//
//	/* Set Idle Days Est for vessel/voyage */
//
//	SELECT SUM(CAL_CARG_IDLE_DAYS)
//	INTO :ld_idle_days_est
//	FROM CAL_CARG
//	WHERE CAL_CALC_ID = :ll_calc_id;
//	COMMIT Using Sqlca;
//	If IsNull(ld_idle_days_est) Then ld_idle_days_est = 0
//
//	/* Set Idle Days Act for vessel/voyage */
//	SELECT (sum(IDLE_TIME_DAYS*24) + (sum(IDLE_TIME_HOURS))) + (sum(IDLE_TIME_MINUTES)/60)
//	INTO :ld_idle_days_act
//	FROM IDLE_DAYS
//	WHERE VESSEL_NR = :li_vessel_nr    AND
//			VOYAGE_NR = :ls_voyage_nr ;
//	COMMIT Using Sqlca;
//	if isnull(ld_idle_days_act) then ld_idle_days_act = 0
//
//	/* Set Grossdays Est for vessel/voyage */
//	SELECT (C.CAL_CALC_TOTAL_DAYS)
//	INTO :ld_grossdays_est
//	FROM VOYAGES V, CAL_CALC C
//	WHERE 	(V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr ) AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_grossdays_est) then ld_grossdays_est = 0
//
//	/* Set Grossdays Act for vessel/voyage */
//	// This is only an asumption until we can get a real field placed somewhere 
//	// where we have a voyage end date.
//	SELECT datediff(minute,min(P.PORT_ARR_DT),max(P.PORT_DEPT_DT))
//	INTO :ld_grossdays_act
//	FROM VOYAGES V,CAL_CALC C, POC P
//	WHERE 	V.VESSEL_NR = P.VESSEL_NR AND
//			V.VOYAGE_NR = P.VOYAGE_NR  AND
//			V.VESSEL_NR = :li_vessel_nr AND
//			V.VOYAGE_NR = :ls_voyage_nr  AND
//			V.CAL_CALC_ID = C.CAL_CALC_ID ;
//	COMMIT Using Sqlca;
//	if isnull(ld_grossdays_act) then 
//		ld_grossdays_act = 0
//	else
//		ld_grossdays_act =  truncate((ld_grossdays_act/60),0) + (mod(ld_grossdays_act,60)/100)
//	end if
//
//	/* Insert new row into datawarehouser and test for error and return error if sql failed */
//	INSERT INTO CCS_DATAWAREHOUSE(DW_SERIAL,CONTRACT_TYPE,CAL_CERP_ID,CHARTERER_SHORTNAME, 
//				CHARTERER_GROUP,CP_DATE,VESSEL_NR,VOYAGE_NR,NO_VOYAGES_EST,NO_VOYAGES_ACT,
//				NO_TON_EST, NO_TON_ACT, GROSS_HIRE_EST, GROSS_HIRE_ACT, DEMURRAGE_EST,
//				DEMURRAGE_ACT, DESPATCH_EST, DESPATCH_ACT, COMISSION_EST, COMISSION_ACT,
//				BUNKERS_EST, BUNKERS_ACT, PORT_EST, PORT_ACT, MISC_EST, MISC_ACT, OFF_HIRE_EST,
//				OFF_HIRE_ACT, OFF_DAYS_EST, OFF_DAYS_ACT, IDLE_DAYS_EST, IDLE_DAYS_ACT,
//				GROSSDAYS_EST, GROSSDAYS_ACT)	
//	VALUES(:ll_dw_serial,:li_contract_type,:ll_cal_cerp_id,:ls_chart_sn,:ls_charterer_group,:ldt_cp_date,:li_vessel_nr,
//			:ls_voyage_nr,:li_no_voyages_est,:li_no_voyages_act, :ld_no_ton_est, :ld_no_ton_act, :ld_gross_hire_est,
//			:ld_gross_hire_act, :ld_demurrage_est, :ld_demurrage_act, :ld_despatch_est, :ld_despatch_act,
//			:ld_commission_est, :ld_commission_act, :ld_bunkers_est, :ld_bunkers_act, :ld_port_est, :ld_port_act,
//			:ld_misc_est, :ld_misc_act, :ld_off_hire_est, :ld_off_hire_act, :ld_off_days_est, :ld_off_days_act,
//			:ld_idle_days_est, :ld_idle_days_act, :ld_grossdays_est, :ld_grossdays_act );
//	if sqlca.SQLCode = -1 then
//		ls_return_string = sqlca.SQLErrText
//		/* Disconnect and destroy temp transaction object */
//		disconnect using temp_tran;
//		destroy temp_tran
//		/* destroy User Object VAS */
//		destroy lu_vas
//		DESTROY lu_vas_functions
//		/* If error inserting into datawarehouse, write error to log and return */
//		If Isvalid(w_warehouse_errors) THEN
//			ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage stopped")
//			w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Insert into datawarehouse failed and returned message: "+ls_return_string)
//		end if
//		return ls_return_string
//	end if
//	commit;
//	/* Fetch next cp id */
//	fetch ves_voy_cursor into :li_vessel_nr,:ls_voyage_nr;
//LOOP
///* Close cursor and test for error and return error if sql failed */
//close ves_voy_cursor;
//if temp_tran.SQLCode = -1 then
//	ls_return_string = temp_tran.SQLErrText
//	/* Disconnect and destroy temp transaction object */
//	disconnect using temp_tran;
//	destroy temp_tran
//	/* destroy User Object VAS */
//	destroy lu_vas
//	DESTROY lu_vas_functions
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse with Vessel Voyage stopped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Close ves voy cursor failed and returned message: "+ls_return_string)
//	end if
//	return ls_return_string
//end if
//
///* Disconnect and destroy temp transaction object */
//commit using temp_tran;
//disconnect using temp_tran;
//destroy temp_tran
//
///* destroy User Object VAS */
//destroy lu_vas
//DESTROY lu_vas_functions

/* Return string */
//return ls_return_string

return ""
end function

public subroutine uf_tc_hire (long ll_vessel_nr, datetime ldt_cp_date);//// ********************************************************************
//// 					GENERATE PAYMENT PERIODS USING PAYMENT DAY(S)
//// ********************************************************************
//
//long ll_row
//INT firstday, secondday, no_of_periods
//Boolean rateperday
//DATETIME firstday_time, secondday_time
//DECIMAL{2} tc_rate_per_day, tc_rate_per_day_org
//SetNull(secondday)
//
///* Daily rate or monthly rate ? */
//SELECT RATEPERDAY INTO :rateperday
//	FROM TCHIRERATES
//	WHERE VESSEL_NR = :ll_vessel_nr AND TCHIRE_CP_DATE = :ldt_cp_date;
//
//SELECT PAYMENT_FIRSTDAY, PAYMENT_SECONDDAY, FIRSTDAY_TIME, SECONDDAY_TIME
//	INTO :firstday, :secondday, :firstday_time, :secondday_time
//	FROM TCHIRES
//	WHERE VESSEL_NR = :ll_vessel_nr AND TCHIRE_CP_DATE = :ldt_cp_date;
//COMMIT;
//
//IF IsNull(firstday) OR IsNull(firstday_time) THEN
//	ll_row = idw.InsertRow(0)
//	idw.SetItem(ll_row,1,"T/C Hire")
//	idw.SetItem(ll_row,2,"Payment day or time invalid! - The first payment day or time is invalid. Please check the first payment day and time and re-try the operation.")
////	Messagebox("Payment day or time invalid!", "The first payment day or time is invalid.~r~rPlease check the first payment day and time and re-try the operation.", StopSign!, OK!)
//END IF
//
///* For each month in hire statement period, i.e. startdate to enddate */
///* Find payment dates and build CHARTERS_PAYMENT structure. */
//
///* If two payment days then double number of payment periods */
//INT i, j, aar, maaned, prevday, reset_count
//STRING firstdate, seconddate
//Datetime Startdate, Enddate
//S_HIRE_STATEMENT charters_payment[]
//BOOLEAN found
//
//SELECT DELIVERY_DATE
//	INTO :startdate
//	FROM TCHIRES
//	WHERE VESSEL_NR = :ll_vessel_nr AND TCHIRE_CP_DATE = :ldt_cp_date;
//SELECT MAX(TC_PERIOD_END)  
//	INTO :enddate
//   	FROM TCHIRERATES
//	WHERE VESSEL_NR = :ll_vessel_nr AND TCHIRE_CP_DATE = :ldt_cp_date;
//COMMIT;
//
//i=2
//j=0
//aar = Year(Date(startdate))
//maaned = Month(Date(startdate))
//
///* Initialize array */
//FOR reset_count = 1 TO 50
//	SetNull(charters_payment[reset_count].payment_date)
//	charters_payment[reset_count].amount = 0
//NEXT
//
//charters_payment[1].payment_date = startdate
//charters_payment[1].amount = 0
//
//DO
//	IF firstday <= 28 THEN
//		firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday) 
//	ELSE
//		found = FALSE
//		prevday = 0		
//		DO
//			firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday - prevday) 
//			IF IsDate(firstdate) THEN
//				found = TRUE
//			ELSE
//				prevday += 1
//			END IF		
//		LOOP UNTIL found
//	END IF
//
//	/* Create and verify first payment dates */
//	IF IsDate(firstdate) THEN
//		IF DaysAfter(Date(startdate), Date(firstdate)) > 0 AND &
//			NOT DaysAfter(Date(enddate), Date(firstdate)) > 0 THEN
//			charters_payment[i].payment_date =  DateTime(Date(firstdate), Time(firstday_time))
//			charters_payment[i].amount = 0
//			i += 1
//		END IF
//	END IF
//
//	/* Create and verify second payment dates if valid */
//	IF NOT IsNull(secondday) THEN
//		IF secondday <= 28 THEN
//			seconddate = String(aar)+"/"+String(maaned)+"/"+String(secondday)
//		ELSE
//			found = FALSE
//			prevday = 0		
//			DO
//			seconddate = String(aar)+"/"+String(maaned)+"/"+String(secondday - prevday)
//				IF IsDate(seconddate) THEN
//					found = TRUE
//				ELSE
//					prevday += 1
//				END IF		
//			LOOP UNTIL found
//		END IF
//
//		IF IsDate(seconddate) THEN
//			IF DaysAfter(Date(seconddate), Date(enddate)) > 0 AND &
//				DaysAfter(Date(startdate), Date(seconddate)) > 0 THEN
//				charters_payment[i].payment_date = DateTime(Date(seconddate), Time(secondday_time))
//				charters_payment[i].amount = 0
//				i += 1
//			END IF
//		END IF
//	END IF
//
//	j += 1
//	IF Mod(Month(Date(startdate)) + j, 13) = 0 THEN
//		aar += 1
//		maaned = 1
//	ELSE
//		maaned += 1
//	END IF
//LOOP UNTIL Date(firstdate) > Date(enddate)
//
//no_of_periods = i - 1
//
///* Set amounts for payment periods, i.e. rate * #days */
//FOR i = 1 TO no_of_periods
//	IF i = 1 AND no_of_periods > 1 THEN
//		charters_payment[i].amount = &
//			round(timedifference(startdate, charters_payment[i+1].payment_date)/1440 * &
//			avg_hire(startdate, charters_payment[i+1].payment_date, ll_vessel_nr, ldt_cp_date) ,2)
//	ELSEIF i = no_of_periods THEN
//		charters_payment[i].amount = &
//			round(timedifference(charters_payment[i].payment_date, enddate)/1440 * &
//			avg_hire(charters_payment[i].payment_date, enddate, ll_vessel_nr, ldt_cp_date),2)
//	ELSE
//		charters_payment[i].amount = &
//			round(timedifference(charters_payment[i].payment_date, &
//				charters_payment[i+1].payment_date)/1440 * &
//			avg_hire(charters_payment[i].payment_date, &
//						charters_payment[i+1].payment_date, ll_vessel_nr, ldt_cp_date) ,2)
//	END IF
//NEXT
//
//DATETIME	tc_periode_start, tc_periode_end, ldt_tmp
//INT 		tc_offhire_allowance
//tc_rate_per_day_org = 0
//Decimal{4} tc_days, mellem, charter
//
//DECLARE tchire_periods CURSOR FOR  
//	SELECT TC_RATE_PER_DAY,   
//	TC_PERIOD_START, TC_PERIOD_END, OFFHIRE_ALLOWANCE
//	FROM TCHIRERATES 
//	WHERE VESSEL_NR = :ll_vessel_nr AND TCHIRE_CP_DATE = :ldt_cp_date;
//
//OPEN tchire_periods;
//
//FETCH tchire_periods
//	INTO 	:tc_rate_per_day,
//			:tc_periode_start,
//			:tc_periode_end,
//			:tc_offhire_allowance;
//
//DO WHILE SQLCA.SQLCode = 0 
//	/* If last period with specified interval */
//
//	IF NOT DaysAfter(Date(enddate), Date(tc_periode_end)) < 0 THEN
//		ldt_tmp = enddate
//	ELSE
//		ldt_tmp = tc_periode_end
//	End if
//
//	IF rateperday THEN
//		tc_days = round((timedifference ( tc_periode_start, ldt_tmp ))/1440,4)
//
//		mellem = round(tc_days * tc_rate_per_day,2)
//		charter += mellem
//
////		ls_tmp = string(tc_days,"#0.####")+" Days at "+Trim(currency_code)+" "+ &
////				string(tc_rate_per_day,"#,##0.00")+"/Day"
//
//		// WriteData(ls_tmp, "Hire Period:", "",  mellem, no, "~t"+string(mellem,"#,##0.00") )
//	else
////		months_and_days(tc_periode_start, ldt_tmp, monthanddays[])
//			
//		FOR i = 1 TO 3 
//			IF NOT tc_rate_per_day_org = 0 THEN
//				tc_rate_per_day = tc_rate_per_day_org
//			END IF
//
////			IF NOT IsNull(monthanddays[i].count) AND NOT monthanddays[i].count = 0 THEN
////				IF monthanddays[i].dayormonth = TRUE THEN /* Use day rates */
////					IF i = 1 THEN /* First month */
////						tc_rate_per_day_org = tc_rate_per_day
////						nodaysinmonth = daysinmonth(date(tc_periode_start))
////
////					ELSEIF i = 2 AND IsNull(monthanddays[3].count) OR i = 3 THEN /* Last month */
////						tc_rate_per_day_org = tc_rate_per_day
////						nodaysinmonth = daysinmonth(date(pd_enddate))
////
////					END IF
////				END IF
////
////				IF monthanddays[i].dayormonth = TRUE THEN /* Daily rates */
////					mellem = round(monthanddays[i].count * tc_rate_per_day / nodaysinmonth,2)
////				ELSE
////					mellem = round(monthanddays[i].count * tc_rate_per_day,2)
////				END IF	
////	
////				charter += mellem
////
////				If monthanddays[i].dayormonth = TRUE Then
////		                	ls_add1 = " Days at "
////					ls_add2 = "/"+String(nodaysinmonth)+"/Day"	
////				Else
////				 	ls_add1 = " Months at "
////					ls_add2 = " per calender month"
////				End if		
////
////				ls_tmp = string(monthanddays[i].count,"#0.####") + ls_add1 + & 
////						Trim(currency_code)+" "+ &
////						string(tc_rate_per_day,"#,##0.00")+ ls_add2
////
////				WriteData(ls_tmp,"Hire Period:", "", mellem, no, "~t" + String(mellem,"#,##0.00") )
//
////			END IF
//		NEXT
//	END IF
//
//	IF NOT DaysAfter(Date(enddate), Date(tc_periode_end)) < 0 THEN
//
////		WriteDate(enddate)
//
//		SQLCA.SQLCode = -1
//		CONTINUE
//	ELSE
////		Writedate(tc_periode_end)
//	End if
//
//	FETCH tchire_periods
//		INTO 	:tc_rate_per_day,
//				:tc_periode_start,
//				:tc_periode_end,
//				:tc_offhire_allowance;
//
//	tc_rate_per_day_org = 0 
//LOOP
//
//CLOSE tchire_periods;
//
end subroutine

public function string uf_update_datawarehouse (ref datawindow adw);///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : n/a
//  
// Object     : uf_update_datawarehouse
//  
// Event	 : call_of_function
//
// Scope     : public
//
// ************************************************************************************
//
// Author    : Peter Bendix-Toft
//   
// Date       : 15-08-96
//
// Description : This function recreates the ccs_datawarehopuse table with new data
//
// Arguments : reference to datawindow for errors
//
// Returns   : String : 	NULL if Function performs OK      OR
//				message of error
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//15-08-96 		3.0			PBT		System 3
//09-12-97			5.0			JEH		Changed so funktion writes error to log and does not
//												stop, unless system error is incurred.
//************************************************************************************/
///* Local variables */
//string ls_return_string, ls_count_dummy_1
//long ll_count_total, ll_count_cp, ll_count_vv, ll_count_tc,ll_count_dummy_1,ll_count_dummy_2,ll_row
//datetime ldt_count_dummy_1, ldt_count_dummy_3
//parm.title = "Updating Sales Data WareHouse!"
//parm.cancel_window = w_main
//parm.cancel_event = "none"
//
///* Set datawindow for errors */
//idw = adw
//
///* Open Progress Window */
//OpenWithParm(w_progress_no_cancel, parm)
//w_progress_no_cancel.Move(0,0)
//w_progress_no_cancel.wf_progress(1/100,"Removing all Current Data from Warehouse")
//
///* Set return string to null */
//setnull(ls_return_string)
//
///* Delete all rows in the current datawarehouse table */
//ls_return_string = uf_recreate_datawarehouse()
//if not isnull(ls_return_string) then
//	/* If delete of old data warehouse not possible write error to log */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Function recreate datawarehouse failed and returned message: "+ls_return_string)
//	end if
//	/* and stop all futher processing in this funktion */
//	return ls_return_string
//end if
//
///* Find out how many rows are to be inserted and set progress window */
//ll_count_total = 0
///* for cp */
//w_progress_no_cancel.wf_progress(1/100,"Pre-Reading CP's")
//transaction count_tran
//
//count_tran = create transaction
//uo_global.defaulttransactionobject(count_tran)
//connect using count_tran;
//
//DECLARE cp_cursor CURSOR FOR  
//SELECT DISTINCT CAL_CERP.CAL_CERP_ID  , CAL_CERP.CAL_CERP_DATE
//FROM CAL_CERP,   CAL_CARG  
//WHERE 	( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  
//         	( ( CAL_CARG.CAL_CARG_STATUS = 6 ) )  using count_tran ;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with transaction object, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database cp_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
//
///* Open cursor and test for error and return error if sql failed */
//open cp_cursor;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open cp_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
//ll_count_cp = 0
///* fetch the first cp */
//fetch cp_cursor into :ll_count_dummy_1,:ldt_count_dummy_1;
///* While there are cps do... */
//DO WHILE count_tran.sqlcode = 0
//	/* Set dw serial for cp */
//	ll_count_cp++
//	fetch cp_cursor into :ll_count_dummy_1,:ldt_count_dummy_1;
//LOOP
//close cp_cursor;
//ll_count_total=ll_count_total + ll_count_cp
//
///* for vessel/voyage */
//w_progress_no_cancel.wf_progress(1/100,"Pre-Reading Vessel/Voyage's")
//DECLARE vv_cursor CURSOR FOR  
//SELECT DISTINCT VESSEL_NR,VOYAGE_NR
//FROM VOYAGES  
//WHERE	CAL_CALC_ID > 1  AND
// 		VOYAGE_TYPE <> 2 using count_tran ;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database vv_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
///* Open cursor and test for error and return error if sql failed */
//open vv_cursor;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open vv_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
//ll_count_vv = 0
///* fetch the first vessel/voyage */
//fetch vv_cursor into :ll_count_dummy_1,:ls_count_dummy_1;
///* While there are vessel/voyages do... */
//DO WHILE count_tran.sqlcode = 0
//	/* Set dw serial for cp */
//	ll_count_vv++
//	fetch vv_cursor into :ll_count_dummy_1,:ls_count_dummy_1;
//LOOP
//close vv_cursor;
//ll_count_total=ll_count_total + ll_count_vv
///* for tc-out */
//w_progress_no_cancel.wf_progress(1/100,"Pre-Reading TC-Out's")
//DECLARE tc_cursor CURSOR FOR  
//SELECT DISTINCT T.DELIVERY_DATE , T.VESSEL_NR,T.CHART_NR,T.TCHIRE_CP_DATE
//FROM TCHIRES T, TCHIRERATES TR
//WHERE	T.VESSEL_NR = TR.VESSEL_NR AND
//		T.TCHIRE_CP_DATE = TR.TCHIRE_CP_DATE  and
//		T.TCHIRE_IN =  0  using count_tran;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Database tc_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
///* Open cursor and test for error and return error if sql failed */
//open tc_cursor;
//if count_tran.SQLCode = -1 then
//	ls_return_string = count_tran.SQLErrText
//	/* Disconnect and destroy count transaction object */
//	disconnect using count_tran;
//	destroy count_tran
//	/* If error with cursor, write error to log and return */
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse Stoped")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Open cp_cursor failed and returned message: "+ls_return_string)
//	end if
//	close(w_progress_no_cancel)
//	return ls_return_string
//end if
//ll_count_tc = 0
///* fetch the first tc */
//fetch tc_cursor into :ldt_count_dummy_1,  :ll_count_dummy_1,:ll_count_dummy_2,:ldt_count_dummy_3;
///* While there are cps do... */
//DO WHILE count_tran.sqlcode = 0
//	/* Set dw serial for tc */
//	ll_count_tc++
//	fetch tc_cursor into :ldt_count_dummy_1, :ll_count_dummy_1,:ll_count_dummy_2,:ldt_count_dummy_3;
//LOOP
//ll_count_total=ll_count_total + ll_count_tc
//commit using count_tran;
//close tc_cursor;
//disconnect using count_tran;
//destroy count_tran
//
//
///* Insert all cp's from calculations that are estimates */
//ls_return_string = uf_recreate_cp_data(ll_count_total,0)
//if not isnull(ls_return_string) then
//	/* If error found in function, write error to log*/
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Function Recreate cp data found errors and returned message: "+ls_return_string)
//	end if
////	close(w_progress_no_cancel)
////	return ls_return_string
//end if
//
///* Insert all vessel + voyage combinations from calculation module that are estimates */
//ls_return_string = uf_recreate_vessel_voyage_data(ll_count_total,ll_count_cp)
//if not isnull(ls_return_string) then 
//	/* If error found in function, write error to log*/
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Function Recreate vessel voyage data found errors and returned message: "+ls_return_string)
//	end if
////	close(w_progress_no_cancel)
////	return ls_return_string
//end if
//
///* Insert all T/C-Hire Out's */
//ls_return_string = uf_recreate_tc_out_data(ll_count_total,ll_count_cp + ll_count_vv)
//if not isnull(ls_return_string) then
//	/* If error found in function, write error to log*/
//	If Isvalid(w_warehouse_errors) THEN
//		ll_row = w_warehouse_errors.dw_warehouse_errors.InsertRow(0)
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
//		w_warehouse_errors.dw_warehouse_errors.SetItem(ll_row,2,"Function Recreate tc out data found errors and returned message: "+ls_return_string)
//	end if
////	close(w_progress_no_cancel)
////	return ls_return_string
//end if
//
///* Return string */
//close(w_progress_no_cancel)
//return ls_return_string
return ""
end function

on u_datawarehouse.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_datawarehouse.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

