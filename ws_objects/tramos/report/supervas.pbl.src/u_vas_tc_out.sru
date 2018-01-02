$PBExportHeader$u_vas_tc_out.sru
forward
global type u_vas_tc_out from u_vas_key_data
end type
end forward

global type u_vas_tc_out from u_vas_key_data
end type
global u_vas_tc_out u_vas_tc_out

type variables
s_vessel_voyage_list istr_vv_list
s_payment_share istr_payment_share
LONG id_contract[]
Decimal {4} id_hire_fix, id_hire_est, id_hire_act, id_broker_comm_fix
Decimal {4} id_off_s_days_fix, id_other_days_fix, id_bunker_lp_fix, id_off_s_bunker_fix, id_misc_fix
Decimal {4} id_broker_comm_act, id_broker_comm_est_temp, id_broker_comm_est, id_broker_comm_est_act
Decimal {4} id_misc_act, id_misc_est, id_misc_est_act
Decimal {4} id_misc_claim_act, id_misc_claim_est, id_misc_claim_est_act
Decimal {4} id_contract_act, id_contract_est, id_contract_est_act
Decimal {4} id_port_exp_act, id_port_exp_est = 0, id_port_exp_est_act
Decimal {4} id_non_port_exp_est, id_non_port_exp_act, id_non_port_exp_est_act
Decimal {4} id_non_port_exp_sum_est, id_non_port_exp_sum_act, id_non_port_exp_sum_est_act
Decimal {4} id_non_port_inc_sum_est, id_non_port_inc_sum_act, id_non_port_inc_sum_est_act
Decimal {4} id_off_s_est, id_off_s_est_act, id_off_s_act
Decimal {4} id_off_s_days_est, id_off_s_days_est_act, id_off_s_days_act
Decimal {4} id_other_days_est, id_other_days_act, id_other_days_est_act
Decimal {4} id_disb_est = 0, id_disb_act, id_disb_est_act, id_disb_income_est_act, id_disb_income_act
Decimal {4} id_bunker_lp_est = 0, id_bunker_lp_act, id_bunker_lp_est_act
Decimal {4} id_off_s_bunker_est = 0, id_off_s_bunker_act, id_off_s_bunker_est_act
Integer ii_voyage_year, ii_not_finished, ii_upper, ii_vas_year
String is_new_voyage_nr
Datetime idt_voyage_start, idt_voyage_end

end variables

forward prototypes
public subroutine of_contract_exp ()
public subroutine of_fixtured ()
public subroutine of_port_exp ()
public subroutine of_non_port_exp ()
public subroutine of_disb_exp ()
public subroutine of_misc ()
public subroutine of_other_days ()
public subroutine of_bunker_loss_profit ()
public subroutine of_off_service_days ()
public function integer of_start_tc ()
public function integer of_tc_hire ()
public subroutine of_broker_comm ()
public subroutine of_off_service ()
private subroutine of_early_startdate (ref datetime adt_earlystart, ref datetime adt_earlyend)
private subroutine of_off_service_bunker ()
private subroutine of_misc_claims ()
private subroutine of_set_misc_details ()
public subroutine documentation ()
end prototypes

public subroutine of_contract_exp ();Decimal {4} ld_contract_est, ld_contract_act, ld_deductions, ld_contexpDailyRate, ld_act_registred_days
Integer li_counter
mt_n_datastore lds_deductions   //deductions of offservice dependent contract expenses

// Loop through the payments that relates to this TC Out voyage  (year) and
// Get the share of Contract exp. Share can be <> 1 for first and last payment if
// a part of the payment covers part of previous or next year. istr_payment_share is prepared
// in of_tc_hire.

FOR li_counter = 1 TO ii_upper
	// Est and Est/Act are the same as the amount really is est/act. Some payments are status 
	// 5 = paid (actual) and others are only future calculated contract exp. = estimated.
	SELECT IsNull(SUM(NTC_PAY_CONTRACT_EXP.AMOUNT),0)  
		INTO :ld_contract_est  
		FROM NTC_PAY_CONTRACT_EXP 
		WHERE NTC_PAY_CONTRACT_EXP.PAYMENT_ID = :istr_payment_share.paymentid[li_counter]   ;
	Commit;

	SELECT isnull(sum(NTC_OFS_DEPENDENT_CONTRACT_EXP.DEDUCTABLE_AMOUNT),0)  
	INTO :ld_deductions
	FROM NTC_OFS_DEPENDENT_CONTRACT_EXP,   
		NTC_OFF_SERVICE
	WHERE NTC_OFS_DEPENDENT_CONTRACT_EXP.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID  
	AND NTC_OFF_SERVICE.PAYMENT_ID = :istr_payment_share.paymentid[li_counter]   ;
	COMMIT;
	
	ld_contract_est -= ld_deductions
	ld_contract_est = (ld_contract_est * istr_payment_share.share[li_counter])
	// Convert to USD
	id_contract_est = id_contract_est + ( ld_contract_est * istr_payment_share.exrateusd[li_counter] ) / 100
	id_contract_est_act = id_contract_est
	
	//Get actual
	SELECT IsNull(SUM(NTC_PAY_CONTRACT_EXP.AMOUNT),0)  
		INTO :ld_contract_act  
		FROM NTC_PAY_CONTRACT_EXP, NTC_PAYMENT 
		WHERE NTC_PAY_CONTRACT_EXP.PAYMENT_ID = :istr_payment_share.paymentid[li_counter] 
		AND NTC_PAYMENT.PAYMENT_ID = NTC_PAY_CONTRACT_EXP.PAYMENT_ID 
		AND NTC_PAYMENT.TRANS_TO_CODA = 1 ;
	Commit;
	ld_contract_act = (ld_contract_act * istr_payment_share.share[li_counter])
	// Convert to USD
	id_contract_act = id_contract_act + ( ld_contract_act * istr_payment_share.exrateusd[li_counter] ) / 100
NEXT

// Look if there are any Off-service dependent expenses to deduct CR#1897
lds_deductions = create mt_n_datastore
lds_deductions.dataObject = "d_sq_tb_tcout_vas_act_offservice_dependent_contexp"
lds_deductions.setTransObject(sqlca)
if lds_deductions.retrieve (id_contract, idt_voyage_start, idt_voyage_end) > 0 then
	id_contract_act -= lds_deductions.getItemNumber(1, "amount")
end if
commit;
/* Correct for estimate offservice days higher than actual registred */
/* Get value of actual REGISTRED off-service days.  */
lds_deductions.dataObject = "d_sq_tb_tcout_vas_reg_offservice_days"
lds_deductions.setTransObject(sqlca)
lds_deductions.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
commit;
if lds_deductions.rowCount() > 0 then
	ld_act_registred_days = lds_deductions.getItemNumber(1, "reg_days")
else
	ld_act_registred_days = 0
end if
if id_off_s_days_est_act > ld_act_registred_days then
	lds_deductions.dataObject = "d_sq_tb_tcout_vas_offservice_dependent_contexp_corrections"
	lds_deductions.setTransObject(sqlca)
	if lds_deductions.retrieve (id_contract) > 0 then
		id_contract_est 		-= ((id_off_s_days_est_act - ld_act_registred_days) * lds_deductions.getItemNumber(1, "amount"))
		id_contract_est_act 	-= ((id_off_s_days_est_act - ld_act_registred_days) * lds_deductions.getItemNumber(1, "amount"))
	end if
end if
commit;
destroy lds_deductions

end subroutine

public subroutine of_fixtured ();
//SELECT IsNUll(NTC_TC_CONTRACT.FIX_TCHIRE,0), IsNUll(NTC_TC_CONTRACT.FIX_BROKER_COMM,0),
//IsNUll(NTC_TC_CONTRACT.FIX_MISC,0), IsNUll(NTC_TC_CONTRACT.FIX_OFF_DAYS,0), 
//IsNUll(NTC_TC_CONTRACT.FIX_OTH_DAYS,0)  
//INTO :id_hire_fix, :id_broker_comm_fix, :id_broker_comm_fix, :id_off_s_days_fix, :id_other_days_fix  
//FROM NTC_TC_CONTRACT  
//WHERE NTC_TC_CONTRACT.CONTRACT_ID = :id_contract  ;
//Commit;
end subroutine

public subroutine of_port_exp ();// PORT EXPENSES IS NOT USED IN VAS for TC OUT. THE CODE ALREADY DONE IS SAVED JUST IN CASE.

Integer li_counter
Decimal {4} ld_port_exp_act, ld_exratetc

// These espenses are always forced as Charters Account so they are income for this TC Out
FOR li_counter = 1 TO ii_upper
	SELECT IsNull(SUM(EXP_AMOUNT),0)  
		INTO :ld_port_exp_act  
		FROM NTC_PORT_EXP 
		WHERE PAYMENT_ID = :istr_payment_share.paymentid[li_counter] 
			AND USE_IN_VAS = 1  ;
	Commit;
	ld_port_exp_act *= istr_payment_share.share[li_counter]
	// Convert to TC Contract currency
	SELECT DISTINCT IsNull(NTC_PORT_EXP.EX_RATE_TC,0) 
		INTO :ld_exratetc 
		FROM NTC_PORT_EXP 
		WHERE NTC_PORT_EXP.PAYMENT_ID = :istr_payment_share.paymentid[li_counter]   ;
	Commit;
	ld_port_exp_act = ( ld_port_exp_act * ld_exratetc ) / 100
	// Convert to USD
	id_port_exp_act += ( ld_port_exp_act * istr_payment_share.exrateusd[li_counter] ) / 100
	id_port_exp_est_act = id_port_exp_act
NEXT

end subroutine

public subroutine of_non_port_exp ();Decimal {4} ld_exp, ld_inc
datetime ldt_modified_voyagestart
datastore lds_data
lds_data = create datastore

// Get estimated non port expenses
lds_data.dataObject = "d_sq_tb_tcout_vas_est_income"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, ii_voyage_year, 0)
Commit;
if lds_data.rowCount() > 0 then
	ld_exp = lds_data.getItemNumber(1, "amount")
else
	ld_exp = 0
end if

// Get estimated non port income
//lds_data.dataObject = "d_sq_tb_tcout_vas_est_income"
lds_data.retrieve(id_contract, ii_voyage_year, 1)
Commit;
if lds_data.rowCount() > 0 then
	ld_inc = lds_data.getItemNumber(1, "amount")
else
	ld_inc = 0
end if

id_non_port_exp_est = ld_exp - ld_inc

// Get the share of estimated Non port expenses/income Share can be <> 1 for first and last payment if
// a part of the payment covers part of previous or next year. istr_payment_share is prepared
// in of_tc_hire.
// Convert to USD
// There are no generated payments for estimated expenses/income so therefore we have no ex rate to use.
// We then use the last payments ex rate to USD in order to have an ex rate
id_non_port_exp_est = ( id_non_port_exp_est * istr_payment_share.exrateusd[ii_upper] ) / 100
id_non_port_exp_sum_est = ( ld_exp * istr_payment_share.exrateusd[ii_upper] ) / 100
id_non_port_inc_sum_est = ( ld_inc * istr_payment_share.exrateusd[ii_upper] ) / 100

/* 	As expenses activity periode only has the option of entering month and year, we have to modify the voyage_startdate 
	so that expenses related to f.ex november are included if voyage start 14th november 											*/
ldt_modified_voyagestart = datetime(date(year(date(idt_voyage_start)), month(date(idt_voyage_start)), 1),time(0,0,0,0))

/* Expenses converted to USD */
lds_data.dataObject = "d_sq_tb_tcout_vas_nonport_income"
lds_data.setTransObject(sqlca)
lds_data.retrieve(ldt_modified_voyagestart, idt_voyage_end, 0, id_contract)
Commit;
if lds_data.rowCount() > 0 then
	id_non_port_exp_sum_act = lds_data.getItemNumber(1, "amount")
else
	id_non_port_exp_sum_act = 0
end if
/* Income converted to USD */
//lds_data.dataObject = "d_sq_tb_tcout_vas_nonport_income"
//lds_data.setTransObject(sqlca)
lds_data.retrieve(ldt_modified_voyagestart, idt_voyage_end, 1, id_contract)
Commit;
if lds_data.rowCount() > 0 then
	id_non_port_inc_sum_act = lds_data.getItemNumber(1, "amount")
else
	id_non_port_inc_sum_act = 0
end if

id_non_port_exp_act = id_non_port_exp_sum_act - id_non_port_inc_sum_act

// If not finished id_non_port_exp_est_act must have the largest of exp
IF ii_not_finished > 0 AND id_non_port_exp_sum_est > id_non_port_exp_sum_act THEN
	id_non_port_exp_est_act = id_non_port_exp_sum_est
	id_non_port_exp_sum_est_act = id_non_port_exp_sum_est
ELSE 
	id_non_port_exp_est_act = id_non_port_exp_sum_act
	id_non_port_exp_sum_est_act = id_non_port_exp_sum_act
END IF	

// If not finished id_non_port_exp_est_act must have deducted the largest of inc
// So if exp is less than income then the total exp variable is negative meaning net income
IF ii_not_finished > 0 AND id_non_port_inc_sum_est > id_non_port_inc_sum_act THEN
	id_non_port_exp_est_act -= id_non_port_inc_sum_est
	id_non_port_inc_sum_est_act = id_non_port_inc_sum_est
ELSE 
	id_non_port_exp_est_act -= id_non_port_inc_sum_act
	id_non_port_inc_sum_est_act = id_non_port_inc_sum_act
END IF

destroy lds_data
end subroutine

public subroutine of_disb_exp ();Datastore lds_tc_disb, lds_est_expenses
Integer li_rows, li_tc_in_contract, li_out = 0, li_inout = -1
Decimal ld_port_exp_est
blob lbl_data
datetime ldt_early_startdate, ldt_early_enddate

// We are on a TC OUT Voyage on a TC OUT Contract. Find out if
// there are also a TC IN contract in the voyage period. 
SELECT Count(*)  
	INTO :li_tc_in_contract  
	FROM NTC_TC_CONTRACT, NTC_TC_PERIOD  
	WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID 
		and NTC_TC_CONTRACT.VESSEL_NR = :istr_vv_list.vessel_nr 
		AND NTC_TC_CONTRACT.TC_HIRE_IN = 1 
		AND (NOT (NTC_TC_PERIOD.PERIODE_START < :idt_voyage_start AND NTC_TC_PERIOD.PERIODE_END <= :idt_voyage_start ) 
		AND NOT (NTC_TC_PERIOD.PERIODE_START >= :idt_voyage_end AND NTC_TC_PERIOD.PERIODE_END > :idt_voyage_end));
Commit;

lds_tc_disb = CREATE datastore
lds_tc_disb.DataObject = "d_vas_tc_disb"
lds_tc_disb.SetTransObject(SQLCA)

IF li_tc_in_contract > 0  THEN
	// Get the disb. where the voucher flag is NO for TC IN-OUT. 
	// Dont care about the flag for TC OUT alone because this vessel is both IN and OUT
	li_out = -1
	li_inout = 0
END IF	

/* Check if startdate for "voyage" shall be changed due to voyage start in previous year
ex. voyage 0750 starts 14/12-06 and therefore all expenses related to this part of the
voyge shall be included */
of_early_startdate(ldt_early_startdate, ldt_early_enddate )
if isnull(ldt_early_startdate) and isnull(ldt_early_enddate) then
	li_rows = lds_tc_disb.Retrieve(idt_voyage_start,idt_voyage_end,istr_vv_list.vessel_nr, li_out, li_inout)
elseif isnull(ldt_early_startdate) then
	li_rows = lds_tc_disb.Retrieve(idt_voyage_start, ldt_early_enddate ,istr_vv_list.vessel_nr, li_out, li_inout)
elseif isnull(ldt_early_enddate) then
	li_rows = lds_tc_disb.Retrieve(ldt_early_startdate, idt_voyage_end, istr_vv_list.vessel_nr, li_out, li_inout)
else 
	li_rows = lds_tc_disb.Retrieve(ldt_early_startdate, ldt_early_enddate, istr_vv_list.vessel_nr, li_out, li_inout)
end if

// Now we have the sum of all disb.exp. that are voucher 1-18, 30-39, 45-49 and 98 where the voucher is marked
// as NO or transfer to TC, depending on if it is TC Out only or both TC IN and Out.
IF li_rows > 0 THEN
	id_disb_income_act = lds_tc_disb.GetItemDecimal(1,"sumdisbincome")
	//as you can't extimate this income, the est/act is always the same as act
	id_disb_income_est_act = id_disb_income_act
	id_disb_act = lds_tc_disb.GetItemDecimal(1,"sumdisbexp")
	if isValid(w_super_vas_reports) then
		integer ll
		lds_tc_disb.getFullState(lbl_data)
		w_super_vas_reports.ids_TC_disb_exp.setFullState(lbl_data)
	end if	
ELSE
	id_disb_act = 0
END IF

// Estimated
lds_est_expenses = create datastore
lds_est_expenses.DataObject = "d_sq_tb_tcout_vas_est_expenses"
lds_est_expenses.SetTransObject(SQLCA)
lds_est_expenses.retrieve(id_contract, ii_voyage_year)
Commit;
if lds_est_expenses.rowCount() > 0 then
	ld_port_exp_est = lds_est_expenses.getItemNumber(1, "est_expenses")
else
	ld_port_exp_est = 0
end if

id_disb_est = ld_port_exp_est

IF ii_not_finished > 0 AND ld_port_exp_est > id_disb_act THEN
	id_disb_est_act = ld_port_exp_est
ELSE 
	id_disb_est_act = id_disb_act
END IF	

Destroy lds_tc_disb
destroy lds_est_expenses
end subroutine

public subroutine of_misc ();// Get the elements for Misc.
of_contract_exp()
//of_port_exp() NOT USED IN VAS TC OUT. DEFINITION CHANGED BY MAERSK
of_non_port_exp()
of_off_service()
of_disb_exp()
of_bunker_loss_profit()

of_set_misc_details()


end subroutine

public subroutine of_other_days ();Decimal {2} ld_minutes, ld_total_days

/* Moved to of_start_tc() by REM 17/12-03*/
//// Get the first startdate for period in this voyage year
//SELECT MIN(NTC_TC_PERIOD.PERIODE_START)  
//INTO :idt_voyage_start  
//FROM NTC_TC_PERIOD  
//WHERE NTC_TC_PERIOD.CONTRACT_ID = :id_contract AND  
//      DatePart(Year,NTC_TC_PERIOD.PERIODE_START) = :ii_voyage_year ;
//Commit;
//
//// Get the last enddate for period in this voyage year
//SELECT MAX(NTC_TC_PERIOD.PERIODE_END)  
//INTO :idt_voyage_end
//FROM NTC_TC_PERIOD  
//WHERE NTC_TC_PERIOD.CONTRACT_ID = :id_contract AND  
//      DatePart(Year,NTC_TC_PERIOD.PERIODE_START) = :ii_voyage_year ;
//Commit;

// Calc. the total voyage days. Call global function which returns diff. in minutes
ld_minutes = timedifference(idt_voyage_start,idt_voyage_end)
ld_total_days = ld_minutes/(60 * 24)

id_other_days_est = ld_total_days - id_off_s_days_est
id_other_days_act = ld_total_days - id_off_s_days_act
id_other_days_est_act = ld_total_days - id_off_s_days_est_act
end subroutine

public subroutine of_bunker_loss_profit ();SELECT isnull(sum(BUNKER_POSTED_LOSSPROFIT) ,0) 
	INTO :id_bunker_lp_act  
	FROM VOYAGES  
	WHERE  VOYAGES.VESSEL_NR = :istr_vv_list.vessel_nr  AND  
		substring(VOYAGES.VOYAGE_NR,1,5) = :istr_vv_list.voyage_nr   ;
commit;		


// No est so est_act = act
id_bunker_lp_est_act = id_bunker_lp_act





end subroutine

public subroutine of_off_service_days ();Decimal {4} ld_act_registred_days
datastore lds_data
lds_data = create datastore

ld_act_registred_days = ld_act_registred_days

// Get the value of estimated Off. S. days
lds_data.dataObject = "d_sq_tb_tcout_vas_est_offservice_days"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, ii_voyage_year)
commit;
if lds_data.rowCount() > 0 then
	id_off_s_days_est = lds_data.getItemNumber(1, "est_days")
else
	id_off_s_days_est = 0
end if

/* Get value of actual REGISTRED off-service days. If they are greater than estimated
	use REGISTRED as estimated */
lds_data.dataObject = "d_sq_tb_tcout_vas_reg_offservice_days"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
commit;
if lds_data.rowCount() > 0 then
	ld_act_registred_days = lds_data.getItemNumber(1, "reg_days")
else
	ld_act_registred_days = 0
end if

if ld_act_registred_days > id_off_s_days_est then
	id_off_s_days_est = ld_act_registred_days
end if

/* Get value of actual off-service days that are settled = ACTUAL */
lds_data.dataObject = "d_sq_tb_tcout_vas_act_offservice_days"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
commit;
if lds_data.rowCount() > 0 then
	id_off_s_days_act = lds_data.getItemNumber(1, "act_days")
else
	id_off_s_days_act = 0
end if

// Set est act.
id_off_s_days_est_act = id_off_s_days_act
IF ii_not_finished > 0 AND id_off_s_days_est > id_off_s_days_act THEN
	id_off_s_days_est_act = id_off_s_days_est
END IF	

destroy lds_data 
end subroutine

public function integer of_start_tc ();// DO NOT change the order of function calls !!!!!
String 		ls_old_voyage_nr
datastore	lds_data
lds_data = create datastore

of_get_vessel_array ( istr_vv_list )

is_new_voyage_nr = istr_vv_list.voyage_nr

// This code is (also) dealing with TC Out voyages where voyage number has been modified to next year
// ie. voyage 035001 changed to 045001
SELECT DISTINCT OLD_VOYAGE_NR
INTO :ls_old_voyage_nr
FROM VOYAGES
WHERE VESSEL_NR = :istr_vv_list.vessel_nr AND Substring(VOYAGE_NR,1,5) = :istr_vv_list.voyage_nr
ORDER BY VOYAGE_NR;
Commit;
// If this voyage has been changed and the vas year is regarding the old voyage nr then use this nr.
IF len(ls_old_voyage_nr) > 0 AND Integer("20" + String(of_get_vas_year(),"00")) <> Integer( "20" + Left(istr_vv_list.voyage_nr,2)) THEN
	istr_vv_list.voyage_nr = ls_old_voyage_nr
	of_set_current_tco_voyage_nr(ls_old_voyage_nr)
END IF

of_setcommenced_date( )
id_contract[1] = of_get_TCcontract()

IF id_contract[1] = -1 THEN 
	destroy lds_data
	Return -1
ELSEIF id_contract[1] = 0 THEN
	destroy lds_data
	Return 0
END IF

ii_voyage_year = Integer( "20" + Left(istr_vv_list.voyage_nr,2))

// Get the first startdate for period in this voyage year
lds_data.dataObject = "d_sq_tb_tcout_vas_periodstart"
lds_data.setTransObject(SQLCA)
lds_data.retrieve(id_contract, ii_voyage_year)
Commit;
idt_voyage_start = lds_data.getItemDatetime(1, "period_start")
of_modify_commenced_date( idt_voyage_start )

// Get the last enddate for period in this voyage year
lds_data.dataObject = "d_sq_tb_tcout_vas_periodend"
lds_data.setTransObject(SQLCA)
lds_data.retrieve(id_contract, ii_voyage_year)
Commit;
idt_voyage_end = lds_data.getItemDatetime(1, "period_end")


// Find out if all voyage year periods are finished
lds_data.dataObject = "d_sq_tb_tcout_vas_count_periods"
lds_data.setTransObject(SQLCA)
lds_data.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
Commit;
ii_not_finished = lds_data.getItemNumber(1, "counter")

//Getfixtured figures
// Fields removed as VAS data has no meaning for a contract, as a contract can cover several years
// and TC IN has no figures from TC contract. Changed/removed according to agreement.
//of_fixtured()

// Gross Freight and preperation of som other functions data
of_tc_hire()
of_setgross_freight(1,id_hire_fix)
// Use Calculated for Estimated figures, which must be shown on TC OUT VAS reports
of_setgross_freight(2,id_hire_est)
of_setgross_freight(4,id_hire_est) // est is equal to est/act
of_setgross_freight(5,id_hire_act)

// Off Service days
of_off_service_days()
of_setoff_service_days (1,id_off_s_days_fix) 
of_setoff_service_days (2,id_off_s_days_est) 
of_setoff_service_days (4,id_off_s_days_est_act) 
of_setoff_service_days (5,id_off_s_days_act) 

// Other days
of_other_days()
of_setother_days (1,id_other_days_fix) 
of_setother_days (2,id_other_days_est) 
of_setother_days (4,id_other_days_est_act) 
of_setother_days (5,id_other_days_act)

// Miscellaneous
//Misc. Claims (added CR#1439)
of_misc_claims( )
of_misc()

// Broker Commission
of_broker_comm()
of_setbroker_commission(1,id_broker_comm_fix)
of_setbroker_commission(2,id_broker_comm_est)
of_setbroker_commission(4,id_broker_comm_est_act)
of_setbroker_commission(5,id_broker_comm_act)

// Off service bunker
of_off_service_bunker()
of_setbunker_expenses(1,id_off_s_bunker_fix)
of_setbunker_expenses(2,id_off_s_bunker_est)
of_setbunker_expenses(4,id_off_s_bunker_est_act)
of_setbunker_expenses(5,id_off_s_bunker_act)

destroy lds_data
Return 1
end function

public function integer of_tc_hire ();Decimal {4} ld_tchire_est, ld_tchire_act, ld_days, ld_calc_days, ld_tchire_est_netto
Decimal {4} ld_exrate_usd, ld_exrate_tc, ld_current_exrateUsd, ld_payment_id_old, ld_payment_id 
Datetime ldt_start, ldt_end
Integer li_rows, li_counter, li_payment_counter = 1
String ls_tc_currency
Datastore lds_vas_tc_payments

lds_vas_tc_payments = CREATE datastore
lds_vas_tc_payments.Dataobject = "d_vas_tc_payments" 
lds_vas_tc_payments.SetTransObject(SQLCA)
li_rows = lds_vas_tc_payments.Retrieve(id_contract,ii_voyage_year)

IF NOT(li_rows > 0) THEN
	Destroy lds_vas_tc_payments;
	Return 1
END IF

// Get exrate from TC Contract to USD
SELECT NTC_TC_CONTRACT.CURR_CODE  
INTO :ls_tc_currency  
FROM NTC_TC_CONTRACT  
WHERE NTC_TC_CONTRACT.CONTRACT_ID = :id_contract[1]   ;
Commit;

if ls_tc_currency = "USD" then
	ld_current_exrateUsd = 100
else
	SELECT EX1.EXRATE_DKK  
	INTO :ld_exrate_tc  
	FROM NTC_EXCHANGE_RATE EX1  
	WHERE ( EX1.CURR_CODE = :ls_tc_currency ) AND  
			( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
										FROM NTC_EXCHANGE_RATE EX2 
										WHERE EX2.CURR_CODE = :ls_tc_currency ) );
	Commit;	
	SELECT EX1.EXRATE_DKK  
	INTO :ld_exrate_usd  
	FROM NTC_EXCHANGE_RATE EX1  
	WHERE ( EX1.CURR_CODE = "USD" ) AND  
			( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
										FROM NTC_EXCHANGE_RATE EX2 
										WHERE EX2.CURR_CODE = "USD" ) );
										Commit;
	IF isNull(ld_exrate_tc) OR ld_exrate_tc = 0 OR isNull(ld_exrate_usd) OR ld_exrate_usd = 0 THEN
		ld_current_exrateUsd = 0
	ELSE
		ld_current_exrateUsd = (  ld_exrate_tc/ld_exrate_usd ) * 100
	END IF
end if

// Get estimated, and actual
FOR li_counter = 1 TO li_rows
	ldt_start = lds_vas_tc_payments.GetItemDateTime(li_counter,"ntc_payment_detail_periode_start")
	ldt_end = lds_vas_tc_payments.GetItemDateTime(li_counter,"ntc_payment_detail_periode_end")
	ld_days = lds_vas_tc_payments.GetItemDecimal(li_counter,"ntc_payment_detail_quantity")
	ld_tchire_est = lds_vas_tc_payments.GetItemDecimal(li_counter,"tcbrutto_est")
	ld_tchire_act = lds_vas_tc_payments.GetItemDecimal(li_counter,"tcbrutto_act")
	ld_tchire_est_netto = lds_vas_tc_payments.GetItemDecimal(li_counter,"tchirenetto")
	// There can be duplicates of payment id, so only take one occurence of each payment id
	ld_payment_id = lds_vas_tc_payments.GetItemDecimal(li_counter,"ntc_payment_payment_id")
	IF ld_payment_id <> ld_payment_id_old THEN
		istr_payment_share.paymentid[li_payment_counter] = ld_payment_id
		istr_payment_share.exrateusd[li_payment_counter]  = lds_vas_tc_payments.GetItemDecimal(li_counter,"ntc_payment_ex_rate_usd")
		IF IsNull(istr_payment_share.exrateusd[li_payment_counter]) OR istr_payment_share.exrateusd[li_payment_counter] = 0 THEN
			istr_payment_share.exrateusd[li_payment_counter] = ld_current_exrateUsd
		END IF
		li_payment_counter ++
	END IF
	ld_payment_id_old = ld_payment_id
	
	IF Year(Date(ldt_start)) = ii_voyage_year AND Year(Date(ldt_end)) = ii_voyage_year THEN
		// Payment counter is incremented, so take previous
		id_hire_est += (ld_tchire_est * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_hire_act += (ld_tchire_act * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_broker_comm_est_temp += ld_tchire_est_netto
		// Set the share of the payment that must be included in VAS. Will be used by broker comm. calc.
//		istr_payment_share.share[li_counter] = 1
		istr_payment_share.share[li_payment_counter -1] = 1
	ELSEIF Year(Date(ldt_start)) < ii_voyage_year THEN
		// Take he portion of tchire equal to the days in the tc voyage year
		ld_calc_days = (Timedifference(Datetime(Date(String(ii_voyage_year) + "-01-01")), ldt_end ))/(60*24)
		id_hire_est += ((ld_tchire_est * (ld_calc_days/ld_days)) * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_hire_act += ((ld_tchire_act * (ld_calc_days/ld_days)) * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_broker_comm_est_temp += ld_tchire_est_netto * (ld_calc_days/ld_days)
//		istr_payment_share.share[li_counter] = ld_calc_days/ld_days
		istr_payment_share.share[li_payment_counter -1] = ld_calc_days/ld_days
	ELSEIF Year(Date(ldt_end)) > ii_voyage_year THEN
		ld_calc_days = ld_days - (Timedifference(Datetime(Date(String(ii_voyage_year + 1) + "-01-01")), ldt_end ))/(60*24)
		id_hire_est += ((ld_tchire_est * (ld_calc_days/ld_days)) * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_hire_act += ((ld_tchire_act * (ld_calc_days/ld_days)) * istr_payment_share.exrateusd[li_payment_counter - 1]) / 100
		id_broker_comm_est_temp += ld_tchire_est_netto * (ld_calc_days/ld_days)
//		istr_payment_share.share[li_counter] = ld_calc_days/ld_days
		istr_payment_share.share[li_payment_counter -1] = ld_calc_days/ld_days
	END IF	
NEXT
ii_upper = UpperBound(istr_payment_share.paymentid)

Destroy lds_vas_tc_payments;
Return 1
end function

public subroutine of_broker_comm ();Integer 			li_monthly_rate, li_counter
Decimal {4} 		ld_est_off_s, ld_actual_settled_broker_comm, ld_actual_calculated_broker_comm, ld_nonport_broker_comm_act 
Decimal {4} 		ld_total_actual_calculated_broker_comm
Decimal {4}		ld_broker_comm_pct, ld_Off_S_amount_act 
Decimal {4}		ld_comm_per_day, ld_comm_daily_rate
datastore		lds_data
lds_data = create datastore

// id_broker_comm_est_temp is set with hire x rate in of_tc_hire
// Changed 02/02-07 request # 967
//id_broker_comm_est = id_broker_comm_est_temp - id_off_s_est
id_broker_comm_est = id_hire_est - id_off_s_est

//Now calc. estimated broker comm. percent
lds_data.dataObject = "d_sq_tb_tcout_vas_brokercom_pct"
lds_data.setTransObject(SQLCA)
lds_data.retrieve(id_contract, 0, idt_voyage_start, idt_voyage_end  )
Commit;
if lds_data.rowCount() > 0 then
	ld_broker_comm_pct = lds_data.getItemNumber(1, "broker_comm")
else
	ld_broker_comm_pct = 0
end if

id_broker_comm_est =  id_broker_comm_est * (ld_broker_comm_pct/100)

//Now calc. estimated broker comm. per day
//lds_data.dataObject = "d_sq_tb_tcout_vas_brokercom_pct"
//lds_data.setTransObject(SQLCA)
lds_data.retrieve(id_contract, 1, idt_voyage_start, idt_voyage_end  )
Commit;
if lds_data.rowCount() > 0 then
	ld_comm_daily_rate = lds_data.getItemNumber(1, "broker_comm")
else
	ld_comm_daily_rate = 0
end if	
ld_comm_per_day = id_other_days_est  * ld_comm_daily_rate //other days are less off-service
id_broker_comm_est += ld_comm_per_day

// There are no generated payments for estimated off.S. so therefore we have no ex rate to use.
// WE then use the last payments ex rate to USD in order to have an ex rate
ii_upper = UpperBound(istr_payment_share.paymentid)
id_broker_comm_est = ( id_broker_comm_est * istr_payment_share.exrateusd[ii_upper] ) / 100

// Loop through the payments that relates to this TC Out voyage  (year) and
// Get the share of actual broker comm. Share can be <> 1 for first and last payment if
// a part of the payment covers part of previous or next year. istr_payment_share is prepared
// in of_tc_hire.

FOR li_counter = 1 TO ii_upper
	// Get Actual Calculated Broker Commission
	SELECT IsNull(SUM(NTC_COMMISSION.AMOUNT),0)  
		INTO :ld_actual_calculated_broker_comm  
		FROM NTC_COMMISSION  
		WHERE NTC_COMMISSION.PAYMENT_ID = :istr_payment_share.paymentid[li_counter]   ;
	Commit;
	
	// Get Actual Settled Broker Commission
	SELECT IsNull(SUM(NTC_COMMISSION.AMOUNT),0)  
		INTO :ld_actual_settled_broker_comm  
		FROM NTC_COMMISSION, BROKERS, NTC_PAYMENT  
		WHERE NTC_COMMISSION.BROKER_NR = BROKERS.BROKER_NR
		AND NTC_COMMISSION.PAYMENT_ID = NTC_PAYMENT.PAYMENT_ID
		AND NTC_COMMISSION.PAYMENT_ID = :istr_payment_share.paymentid[li_counter] 
		AND ((NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL)
		OR (BROKERS.BROKER_POOL_MANAGER = 1 AND NTC_PAYMENT.SETTLE_DATE IS NOT NULL));
	commit;
	
	// Get broker comm on non port expenses
	SELECT IsNull(SUM(NTC_COMMISSION.AMOUNT),0)  
		INTO :ld_nonport_broker_comm_act  
		FROM NTC_COMMISSION, 
			NTC_NON_PORT_EXP  
		WHERE NTC_COMMISSION.NON_PORT_ID = NTC_NON_PORT_EXP.NON_PORT_ID
		AND NTC_NON_PORT_EXP.PAYMENT_ID = :istr_payment_share.paymentid[li_counter]   ;
	Commit;
	ld_actual_settled_broker_comm 		+= ld_nonport_broker_comm_act
	ld_actual_settled_broker_comm 		= 	ld_actual_settled_broker_comm * istr_payment_share.share[li_counter]
	ld_actual_calculated_broker_comm	+= ld_nonport_broker_comm_act
	ld_actual_calculated_broker_comm 	= 	ld_actual_calculated_broker_comm * istr_payment_share.share[li_counter]
	// Convert to USD
	id_broker_comm_act = id_broker_comm_act + (( 	ld_actual_settled_broker_comm * istr_payment_share.exrateusd[li_counter])  / 100)
	ld_total_actual_calculated_broker_comm = ld_total_actual_calculated_broker_comm + (( 	ld_actual_calculated_broker_comm * istr_payment_share.exrateusd[li_counter])  / 100)
NEXT

if ld_total_actual_calculated_broker_comm > id_broker_comm_est then
	id_broker_comm_est = ld_total_actual_calculated_broker_comm
end if

id_broker_comm_est_act = id_broker_comm_act

IF ii_not_finished > 0 AND id_broker_comm_est > id_broker_comm_act THEN
	id_broker_comm_est_act = id_broker_comm_est
END IF

destroy lds_data 
end subroutine

public subroutine of_off_service ();Decimal {4} ld_est_act_rate
Decimal {4} ld_off_s_amount_act, ld_adr_comm_act_pct, ld_adr_comm_est_pct  
Integer li_counter, li_monthly_rate
datastore	lds_data
lds_data = create datastore

lds_data.dataObject = "d_sq_tb_tcout_vas_avg_offservice_rate"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, ii_voyage_year)
Commit;
if lds_data.rowCount() > 0 then
	ld_est_act_rate = lds_data.getItemNumber(1, "avg_rate")
else
	ld_est_act_rate = 0
end if

// Get the estimated adr.comm pct. This may have been changed but we have no alternative for est.
SELECT IsNull(NTC_TC_CONTRACT.ADR_COMM,0), NTC_TC_CONTRACT.MONTHLY_RATE  
	INTO :ld_adr_comm_est_pct, :li_monthly_rate  
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :id_contract[1] ;
Commit;
// If rate is pr. month then divide by 30,4 (365/12) = average days pr. month
IF li_monthly_rate = 1 THEN ld_est_act_rate = ld_est_act_rate / 30.4 

id_off_s_est = id_off_s_days_est * ld_est_act_rate

id_off_s_est -= (id_off_s_est * (ld_adr_comm_est_pct/100))
// There are no generated payments for estimated off.S. so therefore we have no ex rate to use.
// We then use the last payments ex rate to USD in order to have an ex rate
id_off_s_est = ( id_off_s_est * istr_payment_share.exrateusd[ii_upper] ) / 100


// Actual off service - løsning 17-12-03 Change Item#253
lds_data.dataObject = "d_sq_tb_tcout_vas_act_offservice"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
Commit;
if lds_data.rowCount( ) > 0 then
	id_off_s_act = lds_data.getItemNumber(1, "amount")
else
	id_off_s_act = 0
end if

// Set est act.
id_off_s_est_act = id_off_s_act
IF ii_not_finished > 0 AND id_off_s_est > id_off_s_act THEN
	id_off_s_est_act = id_off_s_est
END IF	
//MessageBox("","Estimated="+string(id_off_s_est)+", est/act="+string(id_off_s_est_act)+", actual="+string(id_off_s_act))

destroy lds_data
end subroutine

private subroutine of_early_startdate (ref datetime adt_earlystart, ref datetime adt_earlyend);/* This function checks if there is any voyage number entered for the period,
and if so checks if this voyage number starts before "voyage_start"

returns NULL if date is not before or no voyagenumber
			"new voyage start" if before voyage_start  */
	
string		ls_voyage

SELECT TCOUT_VOYAGE_NR  
	INTO :ls_voyage  
	FROM NTC_TC_PERIOD  
	WHERE CONTRACT_ID = :id_contract[1] 
	AND PERIODE_START <= :idt_voyage_start 
	AND PERIODE_END > :idt_voyage_start  ;
commit;

SELECT MIN(PORT_ARR_DT)
	INTO :adt_earlyStart
	FROM POC
	WHERE VESSEL_NR = :istr_vv_list.vessel_nr
	AND SUBSTRING(VOYAGE_NR,1,5) = RTRIM(:ls_voyage)  ;
commit;

if not isNull(adt_earlyStart) then
	if adt_earlyStart >= idt_voyage_start then
		setNull(adt_earlyStart)
	end if
end if

SELECT MAX(PORT_DEPT_DT)
	INTO :adt_earlyEnd
	FROM POC
	WHERE VESSEL_NR = :istr_vv_list.vessel_nr
	AND SUBSTRING(VOYAGE_NR,1,5) = RTRIM(:ls_voyage)  ;
commit;

if not isNull(adt_earlyEnd) then
	if adt_earlyEnd > idt_voyage_end then
		setNull(adt_earlyStart)
	end if
end if

return

end subroutine

private subroutine of_off_service_bunker ();datastore lds_data
lds_data = create datastore

// Get the value of Bunker used during off-services
lds_data.dataObject = "d_sq_tb_tcout_vas_estact_bunker_during_offservice"
lds_data.setTransObject(sqlca)
lds_data.retrieve(id_contract, idt_voyage_start, idt_voyage_end )
commit;
if lds_data.rowCount() > 0 then
	id_off_s_bunker_est = lds_data.getItemNumber(1, "estimated")
	id_off_s_bunker_est_act = lds_data.getItemNumber(1, "estimated")
	id_off_s_bunker_act = lds_data.getItemNumber(1, "actual")
else
	id_off_s_bunker_est = 0
	id_off_s_bunker_est_act = 0
	id_off_s_bunker_act = 0
end if

destroy lds_data


end subroutine

private subroutine of_misc_claims ();/* This function gets the Misc. claims on TC out voyages, and adds them to the VAS report
	ChangeRequest #1439 */

datastore lds_data
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_tcout_vas_misc_claims"
lds_data.setTransObject(SQLCA)

/* Sets the demurrage amount as the demurrage and misc. income is in same column */
if lds_data.retrieve(id_contract, istr_vv_list.vessel_nr, Left(istr_vv_list.voyage_nr,2)) > 0 then
	id_misc_claim_est = lds_data.getItemNumber(1, "total_est")
	id_misc_claim_est_act = lds_data.getItemNumber(1, "total_est_act")
	id_misc_claim_act = lds_data.getItemNumber(1, "total_act")
end if

return


end subroutine

private subroutine of_set_misc_details ();/********************************************************************
   of_set_misc_details
   <DESC>	This function sets the TC-OUT VAS report headers, and checks if the misc. item
	is an income or an expense. Income is shown under Demurrage and expenses under
	misc. expenses in VAS report</DESC>
   <RETURN>	(none) </RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>	(none)</ARGS>
   <USAGE>	</USAGE>
********************************************************************/
String ls_income_header, ls_expense_header
Decimal ld_misc_exp_est_act, ld_misc_exp_act,  ld_misc_exp_est, ld_misc_inc_est_act, ld_misc_inc_act, ld_misc_inc_est

// Set the headers for VAS report

//Est Income
ld_misc_inc_est = id_contract_est + id_non_port_inc_sum_est + (id_off_s_est * -1) + id_misc_claim_est 
of_setDemurrage( 2, ld_misc_inc_est )

//Est Expenses
ld_misc_exp_est = id_non_port_exp_sum_est + id_disb_est
of_setmisc_expenses( 2, ld_misc_exp_est )

// Est/Act & Act Income
ls_income_header  = "Misc. Income       EstAct / Actual ~n~r"
ls_income_header += "Contract Exp :   " + String(id_contract_est_act,"#,##0") + " / " + &
												  	String(id_contract_act,"#,##0") + "~n~r"
ld_misc_inc_est_act 	+= id_contract_est_act
ld_misc_inc_act		+= id_contract_act

ls_income_header += "Non-Port Inc :   " + String(id_non_port_inc_sum_est_act,"#,##0") + " / " + & 
													String(id_non_port_inc_sum_act,"#,##0") + "~n~r"
ld_misc_inc_est_act 	+= id_non_port_inc_sum_est_act
ld_misc_inc_act		+= id_non_port_inc_sum_act

// as off-service is a reduction in income, multiply value by -1
ls_income_header += "Off.S.Amount:   " + String(id_off_s_est_act *-1,"#,##0") + " / " + &
													String(id_off_s_act *-1,"#,##0") + "~n~r"
ld_misc_inc_est_act 	-= id_off_s_est_act
ld_misc_inc_act		-= id_off_s_act

// as disbursements are registered as expenses, the income will be negative expense, multiply value by -1
ls_income_header += "Disb.Inc.       :   " + String(id_disb_income_est_act ,"#,##0") + " / " + &
													String(id_disb_income_act ,"#,##0") + "~n~r"
ld_misc_inc_est_act 	+= id_disb_income_est_act 
ld_misc_inc_act		+= id_disb_income_act 

if id_bunker_lp_act >= 0 then
	ls_income_header += "Bunker Profit :   " + String(id_bunker_lp_est_act,"#,##0") + " / " + &
														String(id_bunker_lp_act,"#,##0") + "~n~r"
	ld_misc_inc_est_act 	+= id_bunker_lp_est_act
	ld_misc_inc_act		+= id_bunker_lp_act
else
	ls_income_header += "Bunker Profit :   " + String(0,"#,##0") + " / " + &
														String(0,"#,##0") + "~n~r"
end if

ls_income_header += "Claims :            " + String(id_misc_claim_est_act,"#,##0") + " / " + & 
													String(id_misc_claim_act,"#,##0") + "~n~r"
ld_misc_inc_est_act 	+= id_misc_claim_est_act
ld_misc_inc_act		+= id_misc_claim_act

// Est/Act & Act Expense
ls_expense_header  = "Misc. Expense       EstAct / Actual ~n~r"
ls_expense_header += "Non-Port Exp :   " + String(id_non_port_exp_sum_est_act,"#,##0") + " / " + & 
													String(id_non_port_exp_sum_act,"#,##0") + "~n~r"
ld_misc_exp_est_act 	+= id_non_port_exp_sum_est_act
ld_misc_exp_act		+= id_non_port_exp_sum_act

ls_expense_header += "Disb.Exp.       :   " + String(id_disb_est_act,"#,##0") + " / " + &
													String(id_disb_act,"#,##0") + "~n~r"
ld_misc_exp_est_act 	+= id_disb_est_act
ld_misc_exp_act		+= id_disb_act

if id_bunker_lp_act < 0 then
	//multiply by -1 to add the figure to expenses
	ls_expense_header += "Bunker Loss   :   " + String(id_bunker_lp_est_act *-1 ,"#,##0") + " / " + &
														String(id_bunker_lp_act *-1,"#,##0") + "~n~r"
	ld_misc_exp_est_act 	+= id_bunker_lp_est_act *-1
	ld_misc_exp_act		+= id_bunker_lp_act *-1
else
	ls_expense_header += "Bunker Loss   :   " + String(0,"#,##0") + " / " + &
														String(0,"#,##0") + "~n~r"
end if

// set VAS Misc. Income  (est/act & act)
of_setDemurrage( 4, ld_misc_inc_est_act )
of_setDemurrage( 5, ld_misc_inc_act )
// set VAS Misc. Expense  (est/act & act)
of_setmisc_expenses(4, ld_misc_exp_est_act )
of_setmisc_expenses(5, ld_misc_exp_act )

of_set_misc_details_var(ls_income_header,ls_expense_header, ld_misc_exp_est_act,ld_misc_inc_est_act,ld_misc_exp_act,ld_misc_inc_act,id_off_s_est_act) 

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_vas_tc_out
   <OBJECT> TC Out VAS processing </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
Date			Ref    Author	Comments
07/06/11		2276	RMO		Changes to the way misc. income and expense are shown in VAS.
11/06/11		2490	RMO		Voucher codes marked as income shown under misc income and
									not as negative expense as intil now
25/09/15		4139	AGL		Remove linkage between contracts.
********************************************************************/

end subroutine

on u_vas_tc_out.create
call super::create
end on

on u_vas_tc_out.destroy
call super::destroy
end on

