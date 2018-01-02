$PBExportHeader$u_vas_claims.sru
$PBExportComments$Uo used for VAS grossfrt, dem/des, and broker comm actual, and est/act.
forward
global type u_vas_claims from u_vas_key_data
end type
end forward

global type u_vas_claims from u_vas_key_data
end type
global u_vas_claims u_vas_claims

type variables
s_vessel_voyage_list istr_vv_list
//Decimal {4} id_frt, id_frt_other, id_dem_des_actual
//Decimal {4} id_dem_des_est_act = 0, id_frt_received
//Decimal {4} id_frt_other_received
Double id_frt, id_frt_other, id_dem_des_actual
Double id_dem_des_est_act = 0, id_frt_received
Double id_frt_other_received
Datetime idt_tchire_cp_date

end variables

forward prototypes
public function decimal of_get_days_between (datetime adt_start, datetime adt_end)
public function integer of_frt ()
public function integer of_get_dem ()
public function integer of_start_claims ()
public function boolean of_all_dem_forw_dt ()
public function integer of_frt_other ()
public function integer of_misc_claims ()
public subroutine documentation ()
end prototypes

public function decimal of_get_days_between (datetime adt_start, datetime adt_end);
decimal ld_minutes

ld_minutes = (daysafter(date(adt_start),date(adt_end)) * 24 * 60)
ld_minutes = ld_minutes -       (hour( time(adt_start)) * 60) - minute(time(adt_start)) - (second(time(adt_start))/60)
ld_minutes = ld_minutes +       (hour( time(adt_end)) * 60) + minute(time(adt_end)) + (second(time(adt_end))/60)

return ld_minutes / 60 / 24
end function

public function integer of_frt ();Datastore lds_frt
Integer li_rows

// Get frt claims in a datastore
lds_frt = CREATE datastore
lds_frt.DataObject = "d_frt" 
lds_frt.SetTransObject(SQLCA)
li_rows = lds_frt.Retrieve(istr_vv_list.vessel_nr, istr_vv_list.voyage_nr)

IF NOT(li_rows > 0) THEN 
	DESTROY lds_frt ;
	Return 1
END IF

id_frt = lds_frt.GetItemDecimal(1,"sum_amount")
id_frt_received = lds_frt.GetItemDecimal(1,"sum_received")

If IsNull(id_frt) THEN id_frt = 0
If IsNull(id_frt_received) THEN id_frt_received = 0

DESTROY lds_frt ;

Return 1
end function

public function integer of_get_dem ();Integer li_pc_nr
Long ll_stop_amount, ll_rows, ll_counter, ll_chart_nr, ll_claim_nr
Datastore lds_dem
//Decimal {4} ld_transactions, ld_r_transactions, ld_c_transactions
Double ld_transactions, ld_r_transactions, ld_c_transactions

// Actual dem
SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)  
INTO :id_dem_des_actual  
FROM CLAIMS,   CLAIM_TRANSACTION  
WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
			( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
			( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
			( ( CLAIMS.VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
			( CLAIMS.VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
			( CLAIMS.CLAIM_TYPE = "DEM" ) AND  
			( CLAIM_TRANSACTION.C_TRANS_CODE = "R" ) )   ;
commit;

// Est/Act dem
IF NOT(of_all_dem_forw_dt()) THEN
	id_dem_des_est_act = of_getdemurrage(3,TRUE)
ELSE
	// Set stop amount for bulk (despatch) or tank (NO despatch).		
	SELECT VESSELS.PC_NR  
	INTO :li_pc_nr  
	FROM VESSELS  
	WHERE VESSELS.VESSEL_NR = :istr_vv_list.vessel_nr   ;
	commit;
	
	IF li_pc_nr = 3 OR li_pc_nr = 5 THEN
		ll_stop_amount = - 2000000000
	ELSE
		ll_stop_amount = 0
	END IF
	
	lds_dem = CREATE datastore
	lds_dem.DataObject = "d_dem" 
	lds_dem.SetTransObject(SQLCA)
	ll_rows = lds_dem.Retrieve(istr_vv_list.vessel_nr, istr_vv_list.voyage_nr,ll_stop_amount)
	
	
	IF ll_rows > 0 THEN
		FOR ll_counter = 1 TO ll_rows
			ll_chart_nr = lds_dem.GetItemNumber(ll_counter,"chart_nr")
			ll_claim_nr = lds_dem.GetItemNumber(ll_counter,"claim_nr")
			/* use local amount to help generate the balance */
			SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT)  ,0)
			INTO :ld_transactions
			FROM CLAIM_TRANSACTION
			WHERE	( CLAIM_TRANSACTION.VESSEL_NR = :istr_vv_list.vessel_nr ) and  
					( CLAIM_TRANSACTION.VOYAGE_NR = :istr_vv_list.voyage_nr ) and  
					( CLAIM_TRANSACTION.CHART_NR = :ll_chart_nr ) and  
					( CLAIM_TRANSACTION.CLAIM_NR = :ll_claim_nr );
			commit;
			SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  ,0)
			INTO :ld_r_transactions
			FROM CLAIM_TRANSACTION
			WHERE	( CLAIM_TRANSACTION.VESSEL_NR = :istr_vv_list.vessel_nr ) and  
					( CLAIM_TRANSACTION.VOYAGE_NR = :istr_vv_list.voyage_nr ) and  
					( CLAIM_TRANSACTION.CHART_NR = :ll_chart_nr ) and  
					( CLAIM_TRANSACTION.CLAIM_NR = :ll_claim_nr ) And
					( CLAIM_TRANSACTION.C_TRANS_CODE = "R" );
			commit;
			SELECT isnull(sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  ,0)
			INTO :ld_c_transactions
			FROM CLAIM_TRANSACTION
			WHERE	( CLAIM_TRANSACTION.VESSEL_NR = :istr_vv_list.vessel_nr ) and  
					( CLAIM_TRANSACTION.VOYAGE_NR = :istr_vv_list.voyage_nr ) and  
					( CLAIM_TRANSACTION.CHART_NR = :ll_chart_nr ) and  
					( CLAIM_TRANSACTION.CLAIM_NR = :ll_claim_nr ) And
					( CLAIM_TRANSACTION.C_TRANS_CODE = "C" );
			commit;
			lds_dem.SetItem(ll_counter,"transactions",ld_transactions)
			lds_dem.SetItem(ll_counter,"received",ld_r_transactions)
			lds_dem.SetItem(ll_counter,"address",ld_c_transactions)
		NEXT
		
		id_dem_des_est_act = lds_dem.GetItemDecimal(1,"sum_amount")
	END IF
END IF

DESTROY lds_dem ;

Return 1
end function

public function integer of_start_claims ();//Decimal {2} ld_broker_comm, ld_tc_out_frt, ld_act_frt, ld_act_frt_received
Double ld_full_broker_comm_operations, ld_settled_broker_comm
double  ld_tc_out_frt, ld_act_frt, ld_act_frt_received
Boolean lb_exists_frt

of_get_vessel_array ( istr_vv_list )

///////////////////// GROSS FRT Section ///////////////////////////////////
//Set actual frt
of_frt()
of_frt_other()
ld_act_frt_received = id_frt_received + id_frt_other_received
ld_act_frt = id_frt + id_frt_other
of_setgross_freight(5,ld_act_frt_received)

//Check if all charters (CP) has FRT in operations, then take actual, else est.

lb_exists_frt = of_exists_all_frt()
IF lb_exists_frt THEN
	of_setgross_freight(4,ld_act_frt)
ELSE
	of_setgross_freight(4,of_getgross_freight(3,TRUE))
END IF

///////////////////// Demurrage/Despatch Section ///////////////////////////
of_get_dem()
of_misc_claims( )      //add misc. claims and bunker profit to demurrage
//Set actual dem
of_setdemurrage(5,id_dem_des_actual)
//Set est/act dem
of_setdemurrage(4,id_dem_des_est_act)

////////////////////// Broker Comm. Section  ///////////////////////////////
/* Select calculated broker commission from operations */
SELECT isnull(sum(COMM_AMOUNT),0)  
INTO :ld_full_broker_comm_operations  
FROM COMMISSIONS  
WHERE 	COMMISSIONS.VESSEL_NR = :istr_vv_list.vessel_nr  
AND  COMMISSIONS.VOYAGE_NR = :istr_vv_list.voyage_nr    ;
commit;
//Set est/act broker comm.
IF lb_exists_frt THEN
	of_setbroker_commission(4,ld_full_broker_comm_operations )
ELSE
	of_setbroker_commission(4,of_getbroker_commission(3,TRUE))
END IF

//Set actual broker comm.
SELECT SUM(ROUND (CO.COMM_AMOUNT, 2)) 
INTO :ld_settled_broker_comm  
FROM CLAIMS CL, 
	COMMISSIONS CO,
	BROKERS BR
WHERE CL.VESSEL_NR = CO.VESSEL_NR
AND CL.VOYAGE_NR = CO.VOYAGE_NR
AND CL.CHART_NR = CO.CHART_NR
AND CL.CLAIM_NR = CO.CLAIM_NR
AND CO.BROKER_NR = BR.BROKER_NR
AND ((CO.COMM_SETTLED = 1)
OR (BR.BROKER_POOL_MANAGER = 1
	AND ABS(CL.CLAIM_AMOUNT_USD  - ISNULL((SELECT SUM(CT.C_TRANS_AMOUNT_USD) FROM CLAIM_TRANSACTION CT WHERE CT.VESSEL_NR = CL.VESSEL_NR
													AND CT.VOYAGE_NR = CL.VOYAGE_NR
													AND CT.CHART_NR = CL.CHART_NR
													AND CT.CLAIM_NR = CL.CLAIM_NR),0)) < 1 ))
AND CL.VESSEL_NR =  :istr_vv_list.vessel_nr  
AND CL.VOYAGE_NR = :istr_vv_list.voyage_nr;
commit;

if isnull(ld_settled_broker_comm) then ld_settled_broker_comm = 0

of_setbroker_commission(5,ld_settled_broker_comm)

Return 1
end function

public function boolean of_all_dem_forw_dt ();long ll_count_dem
decimal ld_claimamt

SELECT count(CLAIMS.CHART_NR  )
INTO :ll_count_dem  
FROM CLAIMS  
WHERE ( CLAIMS.VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
      ( CLAIMS.VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
      ( CLAIMS.CLAIM_TYPE = 'DEM' );
		
if ll_count_dem = 0 then 
	return false
end if

SELECT count(CLAIMS.CHART_NR), sum(CLAIM_AMOUNT)
INTO :istr_vv_list.demunforwarded, :ld_claimamt
FROM CLAIMS  
WHERE ( CLAIMS.VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
      ( CLAIMS.VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
      ( CLAIMS.FORWARDING_DATE Is null ) AND  
      ( CLAIMS.CLAIM_TYPE = 'DEM' );

if ll_count_dem = istr_vv_list.demunforwarded then
	if ld_claimamt<=0 then
		istr_vv_list.demunforwarded = 0
	end if	
	return false
else
	return true
end if

end function

public function integer of_frt_other ();Datastore lds_frt_other
Integer li_charter, li_claim, li_rows, li_counter
double ld_trans_r_amount, ld_trans_amount

// Get frt claims in a datastore
lds_frt_other = CREATE datastore
lds_frt_other.DataObject = "d_frt_other" 
lds_frt_other.SetTransObject(SQLCA)
li_rows = lds_frt_other.Retrieve(istr_vv_list.vessel_nr, istr_vv_list.voyage_nr)

IF NOT(li_rows > 0) THEN 
	DESTROY lds_frt_other ;
	Return 1
END IF

// Get and set received and transactions for each frt claim
FOR li_counter = 1 TO li_rows
	li_charter = lds_frt_other.GetItemNumber(li_counter,"chart_nr")
	li_claim = lds_frt_other.GetItemNumber(li_counter,"claim_nr")
	SELECT IsNull(Sum(C_TRANS_AMOUNT_USD),0)  
   INTO :ld_trans_r_amount  
   FROM CLAIM_TRANSACTION  
   WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr  ) AND  
         ( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
         ( CHART_NR = :li_charter ) AND  
         ( CLAIM_NR = :li_claim ) AND  
         ( C_TRANS_CODE = 'R' )   ;
	Commit;		  
	SELECT IsNull(Sum(C_TRANS_AMOUNT_USD),0)  
   INTO :ld_trans_amount  
   FROM CLAIM_TRANSACTION  
   WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr  ) AND  
         ( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
         ( CHART_NR = :li_charter ) AND  
         ( CLAIM_NR = :li_claim )   ;
	Commit;		  
	lds_frt_other.SetItem(li_counter,"received",ld_trans_r_amount)
	lds_frt_other.SetItem(li_counter,"transactions",ld_trans_amount)
NEXT

id_frt_other = lds_frt_other.GetItemDecimal(1,"sum_amount")
id_frt_other_received = lds_frt_other.GetItemDecimal(1,"sum_other_received")


If IsNull(id_frt_other) THEN id_frt_other = 0
If IsNull(id_frt_other_received) THEN id_frt_other_received = 0


DESTROY lds_frt_other ;

Return 1
end function

public function integer of_misc_claims ();Datastore lds_misc_claims
Long ll_act_misc_claims_rows, ll_counter
long ll_est_counter, ll_rest_counter, ll_newrow
double ld_trans_r_amount, ld_trans_amount
Decimal ld_est_claim_amount_sum, ld_est_misc_claim, ld_bunker_profit, ld_misc_income
Integer li_charter, li_claim, li_pcn, li_disb_finish, li_disb_count
Boolean lb_match
String ls_port_code, ls_port, ls_previous_port
Datetime ldt_disb_finish_dt  
Decimal ld_exp

lds_misc_claims = CREATE Datastore
lds_misc_claims.dataobject = "d_misc_claims"
lds_misc_claims.SetTransObject(SQLCA)
ll_act_misc_claims_rows = lds_misc_claims.Retrieve(istr_vv_list.vessel_nr,istr_vv_list.voyage_nr)

////////// Misc Claims + Bunker Profit + dirbursements marked as income /////////////

// Get and set received and transactions for each actual misc claim
IF ll_act_misc_claims_rows > 0 THEN
	FOR ll_counter = 1 TO ll_act_misc_claims_rows
		li_charter = lds_misc_claims.GetItemNumber(ll_counter,"chart_nr")
		li_claim = lds_misc_claims.GetItemNumber(ll_counter,"claim_nr")
		SELECT IsNull(Sum(C_TRANS_AMOUNT_USD),0)  
		INTO :ld_trans_r_amount  
		FROM CLAIM_TRANSACTION  
		WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr  ) AND  
				( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
				( CHART_NR = :li_charter ) AND  
				( CLAIM_NR = :li_claim ) AND  
				( C_TRANS_CODE = 'R' )   ;
		Commit;		  
		SELECT IsNull(Sum(C_TRANS_AMOUNT_USD),0)  
		INTO :ld_trans_amount  
		FROM CLAIM_TRANSACTION  
		WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr  ) AND  
				( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
				( CHART_NR = :li_charter ) AND  
				( CLAIM_NR = :li_claim ) AND  
				( C_TRANS_CODE IN ('A', 'W', 'B' ) )   ;
		Commit;		  
		lds_misc_claims.SetItem(ll_counter,"received",ld_trans_r_amount)
		lds_misc_claims.SetItem(ll_counter,"transactions",ld_trans_amount)
	NEXT
END IF

// Get est misc claims
SELECT IsNull(SUM(CAL_CLMI.CAL_CLMI_AMOUNT),0)  
INTO :ld_est_claim_amount_sum  
FROM CAL_CLMI, CAL_CARG, CLAIM_TYPES , CAL_CALC 
WHERE ( CAL_CALC.CAL_CALC_ID = :istr_vv_list.calc_id ) and  
		( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID) AND
		( CAL_CARG.CAL_CARG_ID = CAL_CLMI.CAL_CARG_ID ) and 
      	( CLAIM_TYPES.CLAIM_TYPE = CAL_CLMI.CLAIM_TYPE ) and  
		( CLAIM_TYPES.CLAIM_VAS = 1 ) AND 
		( CLAIM_TYPES.CLAIM_GROSS_FRT = 0 ) ;
COMMIT;

SELECT isnull(SUM(CAL_CARG.CAL_CARG_MISC_INCOME),0)  
INTO :ld_est_misc_claim  
FROM CAL_CARG
WHERE CAL_CARG.CAL_CALC_ID = :istr_vv_list.calc_id ;
commit;	

//id_est_misc_claims = ld_est_claim_amount_sum + ld_est_misc_claim
IF ll_act_misc_claims_rows > 0 THEN
	id_dem_des_actual += lds_misc_claims.GetItemDecimal(1,"sum_received")
	id_dem_des_est_act += lds_misc_claims.GetItemDecimal(1,"sum_amount")
END IF

/* Bunker Loss / Profit only add Profit if value > 0 */
SELECT sum(BUNKER_POSTED_LOSSPROFIT) 
	INTO :ld_bunker_profit  
	FROM VOYAGES  
	WHERE  VOYAGES.VESSEL_NR = :istr_vv_list.vessel_nr  AND  
		VOYAGES.VOYAGE_NR = :istr_vv_list.voyage_nr   ;
commit;
if isNull(ld_bunker_profit) then ld_bunker_profit = 0
if ld_bunker_profit > 0 then 
	ld_bunker_profit = abs(ld_bunker_profit)
else
	ld_bunker_profit = 0   //will in this case be added to misc.expenses as expense
end if

id_dem_des_actual += ld_bunker_profit

// No est so est_act = act
id_dem_des_est_act += ld_bunker_profit

DESTROY lds_misc_claims ;

//misc. income
SELECT ISNULL(sum(DE.EXP_AMOUNT_USD),0)
 	INTO :ld_misc_income
	FROM DISB_EXPENSES DE, VOUCHERS V
	WHERE  DE.VOUCHER_NR = V.VOUCHER_NR and
		DE.VESSEL_NR = :istr_vv_list.vessel_nr and  
		DE.VOYAGE_NR = :istr_vv_list.voyage_nr and  
		V.VAS_REPORT = 1 and
		V.VOUCHER_SHOW_AS_INCOME = 1;   
commit;
if isNull(ld_misc_income) then ld_misc_income = 0
//as disbursements are registered as expenses, income will be registred as negative amounts
//and needs to be multiplied by -1
ld_misc_income = ld_misc_income *-1

id_dem_des_actual += ld_misc_income

// No est so est_act added the actual part
id_dem_des_est_act += ld_misc_income






Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_vas_claims
   <OBJECT> Handles all VAS claim matters </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
    Date   		Ref    Author        Comments
	07/07-11	  	2490	RMO			Disbursements/vouchers marked as "Show as income in VAS"
											added to event demurrage/misc. income
	19/08/11		2489	AGL			Store result from of_all_dem_forw_dt() to use for accruals summary
											amount of demurrage claims that have not been forwarded in a voyage
	24/08/11		2552	AGL/JSU		figures not showing when multi dem claims on voyage and 1 claim
											may not have a forwarding date.  Amendments inside of_all_dem_forw_dt( ).
	25/08/11		2489	AGL			Only report demurrage claims not forwarded when claim amount > 0		
	12/09/11		2574	AGL			Use local amount inside of_get_dem() to assist with balance calc inside dataobject.
********************************************************************/

end subroutine

on u_vas_claims.create
call super::create
end on

on u_vas_claims.destroy
call super::destroy
end on

