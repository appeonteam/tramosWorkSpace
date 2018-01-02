$PBExportHeader$u_transaction_hire_rec_coda.sru
$PBExportComments$TC Hire Receivables
forward
global type u_transaction_hire_rec_coda from u_transaction_hire
end type
end forward

global type u_transaction_hire_rec_coda from u_transaction_hire
end type
global u_transaction_hire_rec_coda u_transaction_hire_rec_coda

type variables
long				il_bpost_row
decimal {6}		id_exrate_TC_to_DKK, id_exrate_TC_to_USD
string				is_tc_currency
datetime			idt_payment_start, idt_payment_end
decimal{0}		id_hire_less_offservice_local   /* Used to calculate Broker Commission */
decimal{4}		id_hire_days_less_offservice	  /* Used to calculate Broker Commission */	
boolean			ib_CODA_settled_before = false  /* Used to control if hire posted to CODA */	
n_ds				ids_OPSAtransfer
string	 			is_voyage_number[]				//holds the voyagenumber to use for a certain year
boolean			ib_voyage_number_verified[]	//holds a status if voyagenumber is verified or not


string         is_titles[]
powerobject    ipo_messages[]
string         is_messages[]
long           il_callstacktop = 0

end variables

forward prototypes
private function integer of_setexrate ()
public function integer of_contractexp_bpost ()
public function integer of_tccommission ()
private function integer of_hire_bpost ()
public function integer of_offservice_bpost ()
public function integer of_getvoyagenr (datetime adt_start, ref string as_voyagenr)
public function integer of_nonportexp_bpost ()
public function integer of_commissionhire_bpost ()
public function integer of_fill_transaction ()
private function integer of_default_bpost ()
public function integer of_estocexp_bpost ()
public function integer of_revert_est_oc_expense (long al_est_oc_id)
public function integer of_offservice_contractexp_bpost (long al_offserviceid)
public function integer of_nonportexp_tccommission (long al_expense_id, decimal ad_exp_amount)
private function integer of_opsatransfer (long al_brow, ref boolean ab_opsareplaced)
public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate)
protected function boolean of_isleapyear (date ad_source)
protected function integer of_lastdayofmonth (date ad_source)
public function integer of_nonportexp_commission_bpost (long al_expense_id, decimal ad_exp_amount, datetime adt_activity_period, boolean ab_expensetypeopsasetup, string as_typedescription)
public subroutine documentation ()
public function integer of_settle_ntc_commission (long al_paymentid)
public function integer of_bunker_bpost ()
public function integer of_portexp_bpost ()
public function long of_beginfunction ()
public function long of_endfunction (long al_exitcode)
public subroutine of_messagebox (string as_title, string as_message)
public function integer of_generate_transaction (s_transaction_input astr_trans_input)
end prototypes

private function integer of_setexrate ();decimal {6}		ld_exrate_DKK_to_USD

/* set currency Code */
is_tc_currency = istr_trans_input.settle_tc_payment.getItemString(1, "curr_code")

/* get exrate from TC currency to DKK */
SELECT EX1.EXRATE_DKK  
	INTO :id_exrate_tc_to_DKK  
	FROM NTC_EXCHANGE_RATE EX1  
	WHERE ( EX1.CURR_CODE = :is_tc_currency ) AND  
			( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
										FROM NTC_EXCHANGE_RATE EX2 
										WHERE EX2.CURR_CODE = :is_tc_currency ) );
IF isNull(id_exrate_tc_to_DKK) OR id_exrate_tc_to_DKK = 0 THEN
	of_messagebox("Error", "Cant get Exchange Rate for TC Currency. Object: u_transaction_hire_rec_coda, function: of_setExrate()")
	Return -1
END IF

/* get and set exchange rate from TC currency to USD */
if is_tc_currency = "USD" then
	id_exrate_TC_to_USD = 100
else
	SELECT EX1.EXRATE_DKK  
		INTO :ld_exrate_DKK_to_USD  
		FROM NTC_EXCHANGE_RATE EX1  
		WHERE ( EX1.CURR_CODE = "USD" ) AND  
				( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
											FROM NTC_EXCHANGE_RATE EX2 
											WHERE EX2.CURR_CODE = "USD" ) );
	IF isNull(ld_exrate_DKK_to_USD) OR ld_exrate_DKK_to_USD = 0 THEN
		of_messagebox("Error", "Cant get Exchange Rate for USD. Object: Object: u_transaction_hire_rec_coda, function: of_setExrate()")
		Return -1 
	END IF
	id_exrate_TC_to_USD = ( id_exrate_TC_to_DKK / ld_exrate_DKK_to_USD ) * 100
end if

return 1

 
end function

public function integer of_contractexp_bpost ();decimal {0}		ld_expense_local, ld_expense_DKK, ld_expense_USD
n_ds				lds_contract_exp
long				ll_rows, ll_row
string				ls_el3, ls_el4
string 			ls_voyage_nr
boolean 			lb_notusedhere = false
decimal			ld_null;setNull(ld_null)

lds_contract_exp = create n_ds
lds_contract_exp.dataObject = "d_payment_settle_contract_expenses"
lds_contract_exp.setTransObject(SQLCA)
ll_rows = lds_contract_exp.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

for ll_row = 1 to ll_rows
	ld_expense_local	= lds_contract_exp.getItemDecimal(ll_row, "expense") * 100    /* eliminate the decimals */
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "income") = 0 then /* TC IN */
		if ld_expense_local >= 0 then /* TC IN and Income */
			ls_el3 = lds_contract_exp.getItemString(ll_row, "coda_el3_tcin_income")
			ls_el4 = lds_contract_exp.getItemString(ll_row, "coda_el4_tcin_income")
		else  /* TC IN and Expense */
			ls_el3 = lds_contract_exp.getItemString(ll_row, "coda_el3_tcin_expense")
			ls_el4 = lds_contract_exp.getItemString(ll_row, "coda_el4_tcin_expense")
		end if
	else /* TC OUT */
		if ld_expense_local >= 0 then /* TC OUT and Income */
			ls_el3 = lds_contract_exp.getItemString(ll_row, "coda_el3_tcout_income")
			ls_el4 = lds_contract_exp.getItemString(ll_row, "coda_el4_tcout_income")
		else  /* TC OUT and Expense */
			ls_el3 = lds_contract_exp.getItemString(ll_row, "coda_el3_tcout_expense")
			ls_el4 = lds_contract_exp.getItemString(ll_row, "coda_el4_tcout_expense")
		end if
	end if		
		
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* if OPSA setup look if there are any account numbers that shall be replaced */
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
		if of_OPSAtransfer(il_bpost_row, lb_notusedhere) = -1 then
			of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
			Return(-1)
		end if
	end if

	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF

	/* Set field no. 29 (DebitCredit) */
	IF ld_expense_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Contract Expenses") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
//	if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
//		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
//		Return(-1)
//	END IF
	
		/* Set expense as transferred to CODA and Update */
	lds_contract_exp.setItem(ll_row, "trans_to_CODA", 1)
	if lds_contract_exp.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table. Object: u_transaction_hire_rec_coda, function: of_contractexp_bpost")
		Return(-1)
	end if		
next

destroy lds_contract_exp
return(1)
end function

public function integer of_tccommission ();/* This function Broker TC Commission */
decimal {2}		ld_amount, ld_original_amount
decimal {2}		ld_comm_pct_or_day     /* Percent or daily rate */
mt_n_datastore				lds_broker
mt_n_datastore				lds_tccomm
long				ll_rows, ll_row, ll_newrow
integer			li_broker_nr, li_count
string			ls_find 
long 				ll_found, ll_no_of_comm
string 			ls_voyage_nr
long 				ll_paymentID
datetime			ldt_settledate

/* First check if there is any amount to calculate commission from */
if (id_hire_less_offservice_local = 0 or Isnull(id_hire_less_offservice_local)) and &
	(id_hire_days_less_offservice = 0 or Isnull(id_hire_days_less_offservice)) then
	return 1
end if

lds_tccomm = create mt_n_datastore
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create mt_n_datastore
lds_broker.dataObject = "d_payment_settle_tc_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"))
ll_paymentID = istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")

if of_settle_ntc_commission(ll_paymentid) = -1 then return -1

CHOOSE CASE ib_CODA_settled_before
	CASE false
		/* This is the first time this payment is settled */
		IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
			Return(-1)
		END IF

		for ll_row = 1 to ll_rows
			ld_comm_pct_or_day= lds_broker.getItemDecimal(ll_row, "comm")
			li_broker_nr		= lds_broker.getItemDecimal(ll_row, "broker_nr")
			/* 	find out if there is a commission already settled (can happen when payment un-settled with settled TC commission
				if so there is not created a new commission - just continue */
			SELECT SUM(ISNULL(AMOUNT,0))
				INTO :ld_original_amount
				FROM NTC_COMMISSION 
				WHERE PAYMENT_ID = :ll_paymentID 
				AND BROKER_NR = :li_broker_nr
				AND INV_NR <> "paid via hire";
						
			if lds_broker.getItemNumber(ll_row, "amount_per_day_or_percent")= 0 then
				ld_amount = id_hire_less_offservice_local * ld_comm_pct_or_day / 10000  /* fordi beløb i ører */
			else
				ld_amount = id_hire_days_less_offservice * ld_comm_pct_or_day 
			end if				
			
			if ld_original_amount <> 0 then
				if (ld_amount - ld_original_amount) = 0 then 
					continue  // commission found, but amount the same
//					ld_amount = ld_original_amount
				else
					ld_amount -= ld_original_amount  //set commission equal to difference and create new record
				end if
			end if
			/* Create new row and set defaults */
			ll_newrow = lds_tccomm.insertRow(0)
			if ll_newrow < 1 then return -1
			lds_tccomm.setItem(ll_newrow, "payment_id", ll_paymentID )
			lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
			lds_tccomm.setItem(ll_newrow, "inv_nr", "do not settle")
			lds_tccomm.setItem(ll_newrow, "amount", ld_amount)
			lds_tccomm.setItem(ll_newrow, "voyage_nr", ls_voyage_nr)
		next
	CASE true
		/* The payment has been settled before and we have to correct broker commission
			and we have to update the commission amount if it is not already settled */
		ll_no_of_comm = lds_tccomm.retrieve(ll_paymentID)
		if ll_no_of_comm < 1 then return 1  /* Nothing to update */
		for ll_row = 1 to ll_rows
			ld_comm_pct_or_day= lds_broker.getItemDecimal(ll_row, "comm")
			li_broker_nr		= lds_broker.getItemDecimal(ll_row, "broker_nr")

			ls_find = "payment_id=" + string(ll_paymentID) +&
						 " and broker_nr=" + string(li_broker_nr) + "and isNull(comm_settle_date)"
			ll_found = lds_tccomm.find(ls_find, 1, ll_no_of_comm)
			if ll_found > 0 then
				ld_original_amount = lds_tccomm.getItemDecimal(ll_found, "amount")
				if lds_broker.getItemDecimal(ll_row, "amount_per_day_or_percent") = 0 then
					ld_amount = id_hire_less_offservice_local * ld_comm_pct_or_day / 10000  /* fordi beløb i ører */
				else
					ld_amount = id_hire_days_less_offservice * ld_comm_pct_or_day
				end if					
				ld_original_amount += ld_amount
				lds_tccomm.setItem(ll_found, "amount", ld_original_amount)
			end if	
		next
END CHOOSE

/* Update uden commit */
if lds_tccomm.Update() <> 1 then 
	ROLLBACK;
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hire_rec_coda, function: of_tccommission()")
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1
end function

private function integer of_hire_bpost ();/* Transaction for Hire and Adr. Commission on Hire */

mt_n_datastore			lds_hire_detail
long			ll_rows, ll_localtime
decimal{0}	ld_hire_local, ld_hire_DKK, ld_hire_USD, ld_adrcomm
decimal{2}	ld_adrcomm_pct
string			ls_voyage_nr, ls_localtime, ls_tchire
boolean 		lb_notusedhere = false
decimal		ld_null;setNull(ld_null)

lds_hire_detail = create mt_n_datastore
lds_hire_detail.dataObject = "d_payment_settle_hire"
lds_hire_detail.setTransObject(SQLCA)
ll_rows = lds_hire_detail.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))
if ll_rows < 1 then
	of_messagebox("Retrival error", "Can't retrieve any hire detail. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
end if

idt_payment_start = lds_hire_detail.getItemDatetime(1, "periode_start")
idt_payment_end	= lds_hire_detail.getItemDatetime(ll_rows, "periode_end")
/* Check if Hire already posted in CODA */
if lds_hire_detail.getItemNumber(1, "trans_to_coda") = 1 then  
	ib_CODA_settled_before = true
	id_hire_less_offservice_local = 0
	id_hire_days_less_offservice = 0
	return 1
end if

ld_hire_local						= lds_hire_detail.getItemDecimal(1, "total_hire") * 100    /* eliminate the decimals */
id_hire_less_offservice_local 	= ld_hire_local   /* Off-hire will be subtracted in another function */
id_hire_days_less_offservice	= lds_hire_detail.getItemDecimal(1, "total_days")

/********** Check if contract has OPSA Setup and Bareboat hire registred **********/ 
integer 	li_count
long		ll_contractID
u_transaction_opsa_hire_bareboat_coda		lnv_opsa_bareboat_trans
u_transaction_opsa_hire_savedrc_coda			lnv_opsa_savedrc_trans

ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

SELECT LOCAL_TIME
INTO :ll_localtime
FROM NTC_TC_CONTRACT
WHERE CONTRACT_ID = :ll_contractID;
if ll_localtime = 1 then
	ls_localtime = 'LT'
elseif ll_localtime = 0 then
	ls_localtime = 'UTC'
end if

if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then    
	
	SELECT COUNT(OPSA_PERIOD_ID)  
		INTO :li_count  
		FROM NTC_OPSA_PERIOD  
		WHERE NTC_OPSA_PERIOD.CONTRACT_ID = :ll_contractID;
	if sqlca.sqlcode <> 0 then
		of_messagebox("Select error", "Select from OPSA_PERIOD_ID failed!. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
		
	if li_count > 0 then
		lnv_opsa_bareboat_trans = create u_transaction_opsa_hire_bareboat_coda
		if lnv_opsa_bareboat_trans.of_generate_transaction( istr_trans_input ) = -1 then
			of_messagebox("OPSA transaction", "Gereration of OPSA Setup Bareboat hire transaction failed!")
			destroy lnv_opsa_bareboat_trans 
			return -1
		end if
		destroy lnv_opsa_bareboat_trans 
		/* Check if there also saveDRC rate is given */
		SELECT COUNT(OPSA_SAVE_DRC)  
			INTO :li_count  
			FROM NTC_OPSA_PERIOD  
			WHERE NTC_OPSA_PERIOD.CONTRACT_ID = :ll_contractID
			AND NTC_OPSA_PERIOD.OPSA_SAVE_DRC IS NOT NULL;
		if sqlca.sqlcode <> 0 then
			of_messagebox("Select error", "Select COUNT(OPSA_SAVE_DRC) from OPSA_PERIOD failed!. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
			Return(-1)
		END IF
		if li_count > 0 then
			lnv_opsa_savedrc_trans = create u_transaction_opsa_hire_savedrc_coda
			if lnv_opsa_savedrc_trans.of_generate_transaction( istr_trans_input ) = -1 then
				of_messagebox("OPSA transaction", "Gereration of OPSA Setup SaveDRC hire transaction failed!")
				destroy  lnv_opsa_savedrc_trans 
				return -1
			end if
			destroy  lnv_opsa_savedrc_trans
		end if
	end if
end if
/********** END OPSA Setup  **********/ 
	
/* Create row and set defaults */
IF of_default_bpost() = -1 then return -1

/* Set field no. 11 (Element 1) */
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 13 (Element 3) */
IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_off_service_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 14 (Element 4) */
IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_hire_out_na")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* if OPSA setup look if there are any account numbers that shall be replaced */
if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
	if of_OPSAtransfer(il_bpost_row, lb_notusedhere ) = -1 then
		of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	end if
end if
	
/* Set field no. 16 (Element 6) */
IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
	Return(-1)
END IF
IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 29 (DebitCredit) */
IF ld_hire_local < 0 THEN
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
ELSE
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_hire_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
ld_hire_DKK = ld_hire_local * id_exrate_TC_to_DKK / 100
IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_hire_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
ld_hire_USD = ld_hire_local * id_exrate_TC_to_USD / 100
IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_hire_usd)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 41 (Linedescr) */
/* This text must never be changed as it is used to identify the transaction in the log */
ls_tchire = "T/C Hire From " + string(idt_payment_start,'DD-MM-YY HH:MM') + ' To ' + string(idt_payment_end, 'DD-MM-YY HH:MM') + ' '+ ls_localtime
//IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "T/C Hire") <> 1 THEN
IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ls_tchire) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Periodiser transaction hvis nødvendigt */
//if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
//	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
//	Return(-1)
//END IF

/* Check if there is adr. commission */
ld_adrcomm_pct = istr_trans_input.settle_tc_payment.getItemNumber(1, "adr_comm_pct")
if isNull(ld_adrcomm_pct) OR ld_adrcomm_pct = 0 then return 1   /* No Commission to calculate */

/* Generate Address Commission transaction */

/* Create row and set defaults */
IF of_default_bpost() = -1 then return -1

/* Set field no. 11 (Element 1) */
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 13 (Element 3) */
IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_off_service_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 14 (Element 4) */
IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_hire_out_na")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* if OPSA setup look if there are any account numbers that shall be replaced */
if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
	if of_OPSAtransfer(il_bpost_row, lb_notusedhere ) = -1 then
		of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	end if
end if

/* Set field no. 16 (Element 6) */
IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
	Return(-1)
END IF
IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 29 (DebitCredit) */
IF ld_hire_local < 0 THEN
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
ELSE
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
ld_adrcomm = ld_hire_local * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
ld_adrcomm = ld_hire_DKK * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
ld_adrcomm = ld_hire_USD * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 41 (Linedescr) */
/* This text must never be changed as it is used to identify the transaction in the log */
IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Adr.Comm. Hire") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Periodiser transaction hvis nødvendigt */
//if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
//	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
//	Return(-1)
//END IF

return(1)
end function

public function integer of_offservice_bpost ();/* Hvis noget danner denne funktion transactioner for både off-service,
	adressekommission off-service såvel som bunker during off-service
*/
decimal {0}				ld_offservice_local_detail, ld_offservice_DKK_detail, ld_offservice_USD_detail
decimal {0}				ld_bunker_local, ld_bunker_DKK, ld_bunker_USD
decimal {0}				ld_adrcomm
mt_n_datastore						lds_offservice, lds_offservice_detail
long						ll_rows, ll_row, ll_detail_rows, ll_detail_row, ll_offserviceID
datetime					ldt_start, ldt_end, ldt_detail_start, ldt_detail_end
decimal{2}				ld_adrcomm_pct
string						ls_voyage_nr
boolean					lb_notusedhere, lb_apmcph_vessel
long						ll_contractID
n_opsa_calculation	lnv_opsa_calc
decimal 					ld_null;setNull(ld_null)
n_vessel					lnv_vessel

lds_offservice = create mt_n_datastore
lds_offservice.dataObject = "d_payment_settle_offservice"
lds_offservice.setTransObject(SQLCA)
ll_rows = lds_offservice.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

lds_offservice_detail = create mt_n_datastore
lds_offservice_detail.dataObject = "d_payment_settle_offservice_detail"
lds_offservice_detail.setTransObject(SQLCA)

for ll_row = 1 to ll_rows
	ldt_start 				= lds_offservice.getItemDatetime(ll_row, "start_date")
	ldt_end	 			= lds_offservice.getItemDatetime(ll_row, "end_date")
	ld_bunker_local	= lds_offservice.getItemDecimal(ll_row, "bunker") * 100    /* eliminate the decimals */
	id_hire_days_less_offservice  	-= lds_offservice.getItemDecimal(ll_row, "off_days") /* Used to calc Broker Commission later */
	
	ll_offserviceID		= lds_offservice.getItemNumber(ll_row, "off_service_id")
	ll_detail_rows 		= lds_offservice_detail.retrieve( ll_offserviceID )

	/**********  OPSA OffService transactions **********/ 
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then    
		istr_trans_input.tc_offservice_id = ll_offserviceID
		lnv_opsa_calc = create n_opsa_calculation
		if lnv_opsa_calc.of_post_opsa_offservice( istr_trans_input ) = -1 then
			of_messagebox("Transaction Error", "Generation of OPSA setup transaction failed. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			destroy lnv_opsa_calc
			return -1
		end if
		destroy lnv_opsa_calc
	end if
	/********** END OPSA Setup  **********/ 

	/* Post Off Service Dependent Contract Expenses if any */
	if of_offservice_contractexp_bpost( ll_offserviceID ) = -1 then return -1
	
	/* Post Off Service details */
	for ll_detail_row = 1 to ll_detail_rows
		ldt_detail_start 					= lds_offservice_detail.getItemDatetime(ll_detail_row, "start_date")
		ldt_detail_end	 					= lds_offservice_detail.getItemDatetime(ll_detail_row, "end_date")
		ld_offservice_local_detail		= lds_offservice_detail.getItemDecimal(ll_detail_row, "offhire") * 100    /* eliminate the decimals */
		id_hire_less_offservice_local 	-= ld_offservice_local_detail   /* Used to calc Broker Commission later */
		
		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1
	
		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_detail_start, "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_off_service_gl")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_out_off_service_na")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
	
		/* if OPSA setup look if there are any account numbers that shall be replaced */
		if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
			if of_OPSAtransfer(il_bpost_row, lb_notusedhere) = -1 then
				of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			end if
		end if

		/* Set field no. 16 (Element 6) */
		IF of_getVoyagenr(ldt_detail_start, ls_voyage_nr) <> 1 THEN
			Return(-1)
		END IF
		IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 29 (DebitCredit) */
		IF ld_offservice_local_detail < 0 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_offservice_local_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_offservice_DKK_detail = ld_offservice_local_detail * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_offservice_DKK_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_offservice_USD_detail = ld_offservice_local_detail * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_offservice_USD_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Off-Service") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
	
		/* Periodiser transaction hvis nødvendigt */
//		if of_periodiser_bpost(il_bpost_row, ldt_detail_start, ldt_detail_end, ld_null ) = -1 then
//			of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
//			Return(-1)
//		END IF
		
		/* Check if there is adr. commission */
		ld_adrcomm_pct = istr_trans_input.settle_tc_payment.getItemNumber(1, "adr_comm_pct")
		if NOT isNull(ld_adrcomm_pct) AND ld_adrcomm_pct > 0 then 
			/* Create row and set defaults */
			IF of_default_bpost() = -1 then return -1
	
			/* Set field no. 11 (Element 1) */
			IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_detail_start, "YYYYMM")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
	
			END IF
			
			/* Set field no. 13 (Element 3) */
			IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_off_service_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 14 (Element 4) */
			IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_out_off_service_na")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF

			/* if OPSA setup look if there are any account numbers that shall be replaced */
			if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
				if of_OPSAtransfer(il_bpost_row, lb_notusedhere) = -1 then
					of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
					Return(-1)
				end if
			end if
		
			/* Set field no. 16 (Element 6) */
			IF of_getVoyagenr(ldt_detail_start, ls_voyage_nr) <> 1 THEN
				Return(-1)
			END IF
			IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 29 (DebitCredit) */
			IF ld_offservice_local_detail < 0 THEN
				IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
					of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
					Return(-1)
				END IF
			ELSE
				IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
					of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
					Return(-1)
				END IF
			END IF
			
			/* Set field no. 30 (Valuedoc) */
			ld_adrcomm = ld_offservice_local_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 32 (Valuehome) */
			ld_adrcomm = ld_offservice_DKK_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 34 (Valuedual) */
			ld_adrcomm = ld_offservice_USD_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
	
			/* Set field no. 41 (Linedescr) */
			IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Adr.Comm.Off-Service") <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
	
			/* Periodiser transaction hvis nødvendigt */
//			if of_periodiser_bpost(il_bpost_row, ldt_detail_start, ldt_detail_end, ld_null) = -1 then
//				of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
//				Return(-1)
//			END IF
		end if
	next
	
	// Bunker during off-hire
	// Tjek først om der er noget

	IF NOT isNull(ld_bunker_local) AND ld_bunker_local <> 0 THEN	
		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1

		/* Check if vessel is an APM Copenhagen vessel */
		lnv_vessel = create n_vessel
		lb_apmcph_vessel = lnv_vessel.of_apmcph_vessel( istr_trans_input.vessel_no, ldt_start )
		destroy lnv_vessel
		
		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_start, "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		if lb_apmcph_vessel then
			IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "bunker_b_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		else
			IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "bunker_a_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		end if
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "bunker_offservice")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
		END IF
		
		/* if OPSA setup look if there are any account numbers that shall be replaced */
		if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
			if of_OPSAtransfer(il_bpost_row, lb_notusedhere) = -1 then
				of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			end if
		end if

		/* Set field no. 16 (Element 6) */
		IF of_getVoyagenr(ldt_start, ls_voyage_nr) <> 1 THEN
			Return(-1)
		END IF
		IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 29 (DebitCredit) */
		IF ld_bunker_local < 0 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_bunker_local)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_bunker_DKK = ld_bunker_local * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_bunker_DKK)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_bunker_USD = ld_bunker_local * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_bunker_USD)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Bunker Off-Service") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		END IF

		/* Periodiser transaction hvis nødvendigt */
//		if of_periodiser_bpost(il_bpost_row, ldt_start, ldt_end, ld_null) = -1 then
//			of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
//			Return(-1)
//		END IF
	END IF
	
		/* Set offservice as transferred to CODA and Update */
	lds_offservice.setItem(ll_row, "trans_to_CODA", 1)
	if lds_offservice.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
		Return(-1)
	end if		
next

destroy lds_offservice_detail
destroy lds_offservice
return(1)
end function

public function integer of_getvoyagenr (datetime adt_start, ref string as_voyagenr);long 	ll_yy, ll_voyageNumberExists
long	ll_contractID

ll_yy = year(date(adt_start)) - 1999
ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

if upperbound(is_voyage_number) < ll_yy then 
	SELECT NTC_TC_PERIOD.TCOUT_VOYAGE_NR  
		INTO :is_voyage_number[ll_yy]  
		FROM NTC_TC_PERIOD  
		WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID AND
				NTC_TC_PERIOD.PERIODE_START <= :adt_start AND  
				NTC_TC_PERIOD.PERIODE_END > :adt_start  ;
	ib_voyage_number_verified[ll_yy] = FALSE
else
	if is_voyage_number[ll_yy] = "" then
		SELECT NTC_TC_PERIOD.TCOUT_VOYAGE_NR  
			INTO :is_voyage_number[ll_yy]  
			FROM NTC_TC_PERIOD  
			WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID AND
					NTC_TC_PERIOD.PERIODE_START <= :adt_start AND  
					NTC_TC_PERIOD.PERIODE_END > :adt_start  ;
		ib_voyage_number_verified[ll_yy] = FALSE
	end if
end if
if isNULL(is_voyage_number[ll_yy]) or is_voyage_number[ll_yy]= "" then
	OpenWithParm(w_enter_coda_voyagenr, ll_yy)
	is_voyage_number[ll_yy] = Message.StringParm
	ib_voyage_number_verified[ll_yy] = FALSE
	IF is_voyage_number[ll_yy] = "0" THEN Return -2
end if

/* Check if  vouagenumber exists in POC CR #2047 */
if ib_voyage_number_verified[ll_yy] = FALSE then
	SELECT count(*)
	INTO :ll_voyageNumberExists
	FROM VOYAGES
	WHERE VESSEL_NR = :istr_trans_input.vessel_no
	AND VOYAGE_NR like :is_voyage_number[ll_yy]+"%"
	AND VOYAGE_TYPE = 2;
	if ll_voyageNumberExists > 0 then
		ib_voyage_number_verified[ll_yy] = TRUE
	else
		of_messagebox("Validation Error", "The Voyage Number Entered in either TC Period or while Settling,~r~nis not matching any TC-Out Voyage Number in Operations.~r~n~r~nPlease enter a correct Voyage Number, and try to settle again.") 
		return -1
	end if
end if

as_voyagenr = is_voyage_number[ll_yy]
return 1
end function

public function integer of_nonportexp_bpost ();/********************************************************************
   of_nonportexp_bpost
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		29/04/15 CR3896        SSX014   Remove the validation that TC Period voyage number
    	                                and non-post expense activity period number must match
   </HISTORY>
********************************************************************/

decimal {0}		ld_expense_local, ld_expense_DKK, ld_expense_USD, ld_adrcomm_local,  ld_adrcomm_DKK,  ld_adrcomm_USD
mt_n_datastore				lds_nonport
long				ll_rows, ll_row, ll_expenseID
string				ls_el3, ls_el4, ls_typeDescription
integer			li_income
string				ls_voyage_nr
datetime			ldt_activity_period
decimal {2}		ld_adrcomm_pct
boolean			lb_OPSAelements_replaced = false
boolean			lb_expenseTypeOPSAsetup
s_enter_nonportexp_voyagenr_parm	lstr_nonportexp_voyage

lds_nonport = create mt_n_datastore
lds_nonport.dataObject = "d_payment_settle_nonport_expenses"
lds_nonport.setTransObject(SQLCA)
ll_rows = lds_nonport.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

for ll_row = 1 to ll_rows
	ld_expense_local	= lds_nonport.getItemDecimal(ll_row, "expense") * 100    /* eliminate the decimals */
	li_income			= lds_nonport.getItemNumber(ll_row, "income") 
	ld_adrcomm_pct	= lds_nonport.getItemNumber(ll_row, "address_commission_pct")
	ll_expenseID		= lds_nonport.getItemNumber(ll_row, "non_port_id")
	ls_typeDescription = lds_nonport.getItemString(ll_row, "type_desc")
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "income") = 0 then /* TC IN */
		if li_income = 1 then /* TC IN and Income */
			ls_el3 = lds_nonport.getItemString(ll_row, "coda_el3_tcin_income")
			ls_el4 = lds_nonport.getItemString(ll_row, "coda_el4_tcin_income")
		else  /* TC IN and Expense */
			ls_el3 = lds_nonport.getItemString(ll_row, "coda_el3_tcin_expense")
			ls_el4 = lds_nonport.getItemString(ll_row, "coda_el4_tcin_expense")
		end if
	else /* TC OUT */
		if li_income = 1 then /* TC OUT and Income */
			ls_el3 = lds_nonport.getItemString(ll_row, "coda_el3_tcout_income")
			ls_el4 = lds_nonport.getItemString(ll_row, "coda_el4_tcout_income")
		else  /* TC OUT and Expense */
			ls_el3 = lds_nonport.getItemString(ll_row, "coda_el3_tcout_expense")
			ls_el4 = lds_nonport.getItemString(ll_row, "coda_el4_tcout_expense")
		end if
	end if		
	if lds_nonport.getItemNumber(ll_row, "opsa_setup") = 1 then
		lb_expenseTypeOPSAsetup = true
	else
		lb_expenseTypeOPSAsetup = false
	end if
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	// if activity period and voyagenr for tc-period don't match get voyagenr for activity period
	ldt_activity_period = lds_nonport.getItemDatetime(ll_row, "activity_period")
	
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_activity_period, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF

	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF

	/* If both contract and expense have OPSA setup marked then */
	/* if OPSA setup look if there are any account numbers that shall be replaced */
	lb_OPSAelements_replaced=false
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 and lb_expenseTypeOPSAsetup then 
		if of_OPSAtransfer(il_bpost_row, lb_OPSAelements_replaced ) = -1 then
			of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		end if
	end if

	/* Set field no. 29 (DebitCredit) */
	IF li_income = 1 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "NON-"+ls_typeDescription ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Check if there is adr. commission */
	if isNull(ld_adrcomm_pct)  then ld_adrcomm_pct = 0
	if ld_adrcomm_pct > 0  then 
		/* Generate Address Commission transaction */
		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1
	
		/* Set field no. 16 (Element 6) */
		IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	
		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_activity_period, "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF

		/* If both contract and expense have OPSA setup marked then */
		/* if OPSA setup look if there are any account numbers that shall be replaced */
		if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 and lb_expenseTypeOPSAsetup then 
			if of_OPSAtransfer(il_bpost_row, lb_OPSAelements_replaced ) = -1 then
				of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
				Return(-1)
			end if
		end if
		
		/* Set field no. 29 (DebitCredit) */
		IF li_income = 1 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		ld_adrcomm_local = abs(ld_expense_local) * ld_adrcomm_pct/100
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", ld_adrcomm_local) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_adrcomm_DKK = ld_adrcomm_local * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", ld_adrcomm_DKK) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_adrcomm_USD = ld_adrcomm_local * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", ld_adrcomm_USD) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "NON-"+ls_typeDescription+" Adr.Comm.") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	end if
	
	/* Broker commission set-off in hire */
	if of_nonportexp_commission_bpost( ll_expenseID, ld_expense_local, ldt_activity_period, lb_expenseTypeOPSAsetup, ls_typeDescription ) <> 1 then
		of_messagebox("Set value error", "Generation of b-post for commission set-off failed. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if

	/* Broker commission on non-port Expenses */
	if of_nonportexp_tccommission( ll_expenseID, ld_expense_local ) <> 1 then
		of_messagebox("Set value error", "Generation of TC commission failed. Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if
	
		/* Set expense as transferred to CODA and Update */
	lds_nonport.setItem(ll_row, "trans_to_CODA", 1)
	if lds_nonport.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table Object: u_transaction_hire_rec_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if		
next

destroy lds_nonport
return(1)
end function

public function integer of_commissionhire_bpost ();/* This function posts Broker Commission set off in hire and creates items in TC Commissions */
decimal {0}		ld_amount_local, ld_amount_DKK, ld_amount_USD
decimal {2}		ld_comm_pct_or_day    /* Precent or daily rate */
n_ds				lds_broker, lds_tccomm
long				ll_rows, ll_row, ll_newrow
string				ls_owner_prefix
integer			li_broker_nr
string				ls_voyage_nr
boolean			lb_OPSAelements_replaced = false
decimal			ld_null;setNull(ld_null)

/* First check if there is any amount to calculate commission from */
if (id_hire_less_offservice_local = 0 or Isnull(id_hire_less_offservice_local)) and &
	(id_hire_days_less_offservice = 0 or Isnull(id_hire_days_less_offservice)) then
	return 1
end if

lds_tccomm = create n_ds
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create n_ds
lds_broker.dataObject = "d_payment_settle_comm_setoff"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"))
ls_owner_prefix = ids_default_values.GetItemString(1, "prefix_supplier_foreign")

/********** Check if contract has OPSA Setup and Broker Commission registred **********/ 
decimal{2}	ld_opsa_comm_pct, ld_opsa_comm_amount
long			ll_contractID
u_transaction_opsa_brokercomm_coda		lnv_opsa_trans

if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then    
	ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

	SELECT ISNULL(SUM(OPSA_BROKER_COMM),0)  
		INTO :ld_opsa_comm_pct  
		FROM NTC_OPSA_POSTING_ELEMENT  
		WHERE CONTRACT_ID = :ll_contractID
		AND OPSA_TYPE = 3
		AND OPSA_A_OR_B_POST = "A";
	if sqlca.sqlcode <> 0 then
		of_messagebox("Select error", "Select from NTC_OPSA_POSTING_ELEMENT failed!. Object: u_transaction_hire_rec_coda, function: of_hire_bpost")
		Return(-1)
	END IF
		
	if ld_opsa_comm_pct > 0 then
		ld_opsa_comm_amount = id_hire_less_offservice_local * ld_opsa_comm_pct / 100
		istr_trans_input.opsa_broker_comm = ld_opsa_comm_amount
		lnv_opsa_trans = create u_transaction_opsa_brokercomm_coda
		if lnv_opsa_trans.of_generate_transaction( istr_trans_input ) = -1 then
			of_messagebox("OPSA transaction", "Gereration of OPSA Setup broker commission transaction failed!")
			destroy lnv_opsa_trans 
			return -1
		end if
		destroy lnv_opsa_trans 
	end if
end if
/********** END OPSA Setup  **********/ 

for ll_row = 1 to ll_rows
	li_broker_nr		= lds_broker.getItemDecimal(ll_row, "broker_nr")
	ld_comm_pct_or_day= lds_broker.getItemDecimal(ll_row, "comm")
	if lds_broker.getItemNumber(ll_row, "amount_per_day_or_percent") = 0 then
		ld_amount_local 	= id_hire_less_offservice_local * ld_comm_pct_or_day / 100
	else
		ld_amount_local 	= id_hire_days_less_offservice * ld_comm_pct_or_day * 100
	end if		
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "commission_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "commission_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF

	/* if OPSA setup look if there are any account numbers that shall be replaced */
	lb_OPSAelements_replaced = false
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
		if of_OPSAtransfer(il_bpost_row, lb_OPSAelements_replaced) = -1 then
			of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
			Return(-1)
		end if
	end if

	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_amount_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_amount_DKK = ld_amount_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_amount_USD = ld_amount_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_usd)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Comm.Set-off in Hire") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
//	if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
//		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_commissionhire_bpost")
//		Return(-1)
//	END IF
////////////////////////////////////////////////////////////////////////////////////
	if lb_OPSAelements_replaced = false then
		/* Create records in TC Commissions. This row will not be created if OPSA setup and Elements replaced */
		/* Create new row and set defaults */
		ll_newrow = lds_tccomm.insertRow(0)
		if ll_newrow < 1 then return -1
		lds_tccomm.setItem(ll_newrow, "payment_id", istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))
		lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
		/* This text "paid via hire" must not be changed as it is used to identify record 
			in n_tc_payment:of:redeliveryMoved() */
		lds_tccomm.setItem(ll_newrow, "inv_nr", "paid via hire") /* !!!!!! */
		lds_tccomm.setItem(ll_newrow, "amount", ld_amount_local / 100)
		lds_tccomm.setItem(ll_newrow, "comm_settle_date", today())
		lds_tccomm.setItem(ll_newrow, "voyage_nr", ls_voyage_nr)
	end if
next

/* Update uden commit */
if lds_tccomm.Update() <> 1 then 
	ROLLBACK;
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hire_rec_coda, function: of_tccommission()")
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1


end function

public function integer of_fill_transaction ();decimal {0}		ld_sum_amount_local, ld_sum_amount_DKK, ld_sum_amount_USD
long				ll_row, ll_rows
string 			ls_vessel_ref_nr

/* Set the TC currency and the exchange rates */
IF of_setExrate() = -1 then Return -1

////// SET KEYS FOR QUERY PURPOSE //////////////////////////////////////////////////////
IF ids_apost.SetItem(1,"trans_type","TCCODARec") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_hire_rec_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.agent_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_hire_rec_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.pcn) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_hire_rec_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF
////////////////////////////////////////////////////////////////////////////////////////

/////// SET STANDARD VALUES ////////////////////////////////////////////////////////////

/* Set field no. 6  DocCode  */
IF ids_apost.SetItem(1, "f06_doccode", ids_default_values.GetItemString(1, "doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 9 DocDate */
IF ids_apost.SetItem(1, "f09_docdate", istr_trans_input.doc_date) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 09 (Docdate) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 10 SANCTION_LINE_1
IF ids_apost.SetItem(1, "f10_destination", istr_trans_input.s_sanction_line_1) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_LINE_1 for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 11  Activity Periode  */
IF ids_apost.SetItem(1, "f11_el1", string(istr_trans_input.doc_date, "yyyymm")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 13  General Ledger Account  */
IF ids_apost.SetItem(1, "f13_el3", ids_default_values.GetItemString(1, "agent_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Own) (Element 3) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 14  Nominal Account  */
IF ids_apost.SetItem(1, "f14_el4", ids_default_values.GetItemString(1, "prefix_supplier_foreign") + istr_trans_input.settle_tc_payment.getItemString(1, "chart_nom_acc_nr") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Foreign) (Element 4) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 15  Vessel, Department or Agent  */
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	//COMMIT;   no commit as part of LUW
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_expenses, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16  Voyage (Blank)*/
IF ids_apost.SetItem(1, "f16_el6", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 17  PortCode (always blank)  */
IF ids_apost.SetItem(1, "f17_el7", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 19  Supplier identification (always blank)  */
IF ids_apost.SetItem(1, "f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 20  (always blank)  */
IF ids_apost.SetItem(1, "f20_invoicenr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 20 (Invoice No.) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher no. (always blank) */
IF ids_apost.SetItem(1, "f21_vouchernr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 21 (Voucher No.) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control no. (always blank) */
IF ids_apost.SetItem(1, "f22_controlnr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 23  APM Supplier - same as nominal account (always blank)   */
IF ids_apost.SetItem(1, "f23_paytype_or_sup", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 23 (APM Supplier) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/*Set field no.25 Element F25_PAYMETHOD_OR_DATEOFISSUE*/ 
IF ids_apost.SetItem(1,"f25_paymethod_or_dateofissue", string( istr_trans_input.settle_tc_payment.getItemDatetime(1, "tc_hire_cp_date"),"dd-mm-yyyy" )) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.25 for A-post. Object: u_transaction_hire_rec_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/*Set field f26_orderno*/
if ids_apost.setitem(1,'f26_orderno',istr_trans_input.settle_tc_payment.getitemstring(1,'ntc_payment_ax_invoice_text')) <> 1 then
	of_messagebox("Set value error", "Cant set Field f26_orderno for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
end if

/* Set field no. 28  Currency Code  */
IF ids_apost.SetItem(1, "f28_curdoc", is_tc_currency) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 41  Linedescr  */
IF ids_apost.SetItem(1, "f41_linedesr", "TC Hire Receivable") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.43 Payment date */ 
IF ids_apost.SetItem(1,"f43_due_or_payment_date", istr_trans_input.settle_tc_payment.getItemDatetime(1, "est_due_date")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 43 for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field PaymentID */
istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")
IF ids_apost.SetItem(1, "payment_id", istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field Payment_ID for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/**************************************************************************************/
/* GENERER ALLE B-POSTERINGERNE OG OPSUMMER HVAD DER SÅ SKAL STÅ I A-POST             */
/**************************************************************************************/

/* Check if contract has OPSA Setup and retrieve OPSA transfer account numbers */ 
if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
	if ids_OPSAtransfer.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")) = -1 then
		of_messagebox("Retrieve error", "Can't retrieve OPSA transfer account numbers. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
		Return(-1)
	end if
end if
		
///* Kald B-post for Hire */
IF of_hire_bpost() = -1 THEN Return(-1)
IF of_offservice_bpost() = -1 THEN Return(-1)
IF of_nonportexp_bpost() = -1 THEN Return(-1)
IF of_estocexp_bpost() = -1 THEN Return(-1)
IF of_contractexp_bpost() = -1 THEN Return(-1)
IF of_commissionhire_bpost() = -1 THEN Return(-1)
IF of_TCCommission() = -1 THEN Return(-1)
IF of_bunker_bpost() = -1 THEN Return(-1)
IF of_portexp_bpost() = -1 THEN Return(-1)

/* Set field no. 08 DocLineNumber for all B-posts */
ll_rows = ids_bpost.rowCount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		IF ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row +1) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_hire_rec_coda, function: of_fill_bpost")
			Return(-1)
		end if
		IF ids_bpost.getItemNumber(ll_row, "f29_debitcredit") = 160 then
			ld_sum_amount_local += ids_bpost.getItemDecimal(ll_row, "f30_valuedoc")
			ld_sum_amount_DKK += ids_bpost.getItemDecimal(ll_row, "f32_valuehome")
			ld_sum_amount_USD += ids_bpost.getItemDecimal(ll_row, "f34_vatamo_or_valdual")
		ELSE
			ld_sum_amount_local -= ids_bpost.getItemDecimal(ll_row, "f30_valuedoc")
			ld_sum_amount_DKK -= ids_bpost.getItemDecimal(ll_row, "f32_valuehome")
			ld_sum_amount_USD -= ids_bpost.getItemDecimal(ll_row, "f34_vatamo_or_valdual")
		END IF
	next
end if

/* Set field no. 29 (DebitCredit) */
IF ld_sum_amount_local < 0 THEN
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_apost.SetItem(1, "f30_valuedoc", abs(ld_sum_amount_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 18 SANCTION_LINE_2
istr_trans_input.s_sanction_line_2 = istr_trans_input.s_sanction_currency + " " &
				+ string(abs(ld_sum_amount_local / 100) * istr_trans_input.d_exrate_from_invoice / 100 , "#,##0.00")
IF ids_apost.SetItem(1, "f18_el8", istr_trans_input.s_sanction_line_2) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_LINE_2 for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_apost.SetItem(1, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
IF ids_apost.SetItem(1, "f32_valuehome", abs(ld_sum_amount_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", abs(ld_sum_amount_USD)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for A-post. Object: u_transaction_hire_rec_coda, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 42 SANCTION_CURRENCY
IF ids_apost.SetItem(1, "f42_location", istr_trans_input.s_sanction_currency) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_CURRENCY for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

Return(1)
end function

private function integer of_default_bpost ();/* Insert new B-post */
il_bpost_row = ids_bpost.InsertRow(0)

/* Set field no. 03 (Fiscal Year) */
IF ids_bpost.SetItem(il_bpost_row, "f03_yr", ids_apost.GetItemNumber(1, "f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Fiscal Year) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 04 (Period) */
IF ids_bpost.SetItem(il_bpost_row, "f04_period", ids_apost.GetItemNumber(1, "f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Period) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 12 (Element 2) */
IF ids_bpost.SetItem(il_bpost_row, "f12_el2_b", ids_apost.GetItemString(1, "f12_el2")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 12 (Element 2) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 15 (Element 5) */
IF ids_bpost.SetItem(il_bpost_row, "f15_el5_b", ids_apost.GetItemString(1, "f15_el5")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (NULL) (Element 5) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 17 (Element 7) (Always Blank) */
IF ids_bpost.SetItem(il_bpost_row, "f17_el7_b", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (NULL) (Element 7) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 18 (Element 8) (Always Blank) */
IF ids_bpost.SetItem(il_bpost_row, "f18_el8_b", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 18 (NULL) (Element 8) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 19 (Customer or Supplier) */
IF ids_bpost.SetItem(il_bpost_row, "f19_custsupp", ids_apost.GetItemString(1, "f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 (CustSupp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 27 (linetype) */
IF ids_bpost.SetItem(il_bpost_row, "f27_linetype", ids_default_values.GetItemNumber(1, "linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 27 (Linetype) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
	Return(-1)
END IF

return(1)
end function

public function integer of_estocexp_bpost ();decimal {0}		ld_expense_local, ld_expense_DKK, ld_expense_USD
n_ds				lds_estocexp
long				ll_rows, ll_row, ll_reverse_est_oc_id
integer			li_income

lds_estocexp = create n_ds
lds_estocexp.dataObject = "d_payment_settle_estimated_oc_expenses"
lds_estocexp.setTransObject(SQLCA)
ll_rows = lds_estocexp.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

for ll_row = 1 to ll_rows
	ld_expense_local		= lds_estocexp.getItemDecimal(ll_row, "expense") * 100    /* eliminate the decimals */
	li_income				= lds_estocexp.getItemNumber(ll_row, "income") 
	ll_reverse_est_oc_id	= lds_estocexp.getItemNumber(ll_row, "reverse_est_oc_id") 
	
	/* If expense do not have reverse ID, then it is a primary expense. If so the function checkes if there already exists 
		an reverse expense, and if not there is created one (create can only be valid for expenses created on last payment */ 
	if isNull(ll_reverse_est_oc_id) then 
		if of_revert_est_oc_expense( lds_estocexp.getItemNumber(ll_row, "est_oc_id")) = -1 then
			rollback;
			of_messagebox("Update Error", "Can't create reverse expense: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
			Return(-1)
		end if		
	end if
	
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ids_apost.getItemString(1, "f11_el1") ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b",  ids_default_values.GetItemString(1, "charterer_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_apost.getItemString(1, "f14_el4")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) 
		Income and Owner Expense 		= credit (160)
		Income and Charterer Expense  = credit (160)
		Expense and Owner Expense		= debit (161)
		Expense and Charterer Expense = debit (161)     */
	
	IF li_income = 1 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Est. O/C Expenses") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set expense as transferred to CODA and Update */
	lds_estocexp.setItem(ll_row, "trans_to_CODA", 1)
	if lds_estocexp.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table Object: u_transaction_hire_rec_coda, function: of_estocexp_bpost")
		Return(-1)
	end if		
	
next

destroy lds_estocexp
return(1)
end function

public function integer of_revert_est_oc_expense (long al_est_oc_id);/* This function is to check and create reverse Estimated Owner/Charterer Expense
	if the expense settled do not have a reverse expense.
	This can only be valid if the expense is created on last payment */

integer	li_counter
long		ll_paymentID
decimal	ld_amount, ld_exrate
integer	li_income, li_owner_expense
string		ls_comment, ls_curr_code

SELECT count(*)
	INTO :li_counter
	FROM NTC_EST_OC_EXP
	WHERE REVERSE_EST_OC_ID = :al_est_oc_id;
if sqlca.SQLCode <> 0 then
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_rec_coda.of_revert_est_oc_expense)")
	return -1
end if

if li_counter > 0 then return 1  // There already exists a reverse expense return

/* Create reverse expense from original */
SELECT PAYMENT_ID,
	CURR_CODE,
	INCOME,
	OWNER_EXP,
	COMMENT,
	AMOUNT,
	EX_RATE_TC
INTO :ll_paymentID,
	:ls_curr_code,
	:li_income,
	:li_owner_expense,
	:ls_comment,
	:ld_amount,
	:ld_exrate
FROM NTC_EST_OC_EXP
WHERE EST_OC_ID = :al_est_oc_id ;
if sqlca.SQLCode <> 0 then
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_rec_coda.of_revert_est_oc_expense)")
	return -1
end if

if li_income = 0 then
	li_income = 1
else
	li_income = 0
end if

INSERT INTO NTC_EST_OC_EXP  
	( PAYMENT_ID,   
	REVERSE_EST_OC_ID,   
	CURR_CODE,   
	INCOME,   
	OWNER_EXP,   
	COMMENT,   
	AMOUNT,   
	EX_RATE_TC,   
	TRANS_TO_CODA )  
VALUES ( :ll_paymentID ,   
	:al_est_oc_id,
	:ls_curr_code,   
	:li_income,   
	:li_owner_expense,   
	:ls_comment,   
	:ld_amount,   
	:ld_exrate,   
	0 )  ;

if sqlca.SQLCode <> 0 then
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_rec_coda.of_revert_est_oc_expense)")
	return -1
end if

return 1
end function

public function integer of_offservice_contractexp_bpost (long al_offserviceid);decimal {0}		ld_expense_local, ld_expense_DKK, ld_expense_USD
mt_n_datastore				lds_offservice_contract_exp
long				ll_rows, ll_row, ll_contractID, ll_exptypeID, ll_paymentID
string				ls_el3, ls_el4
string 			ls_voyage_nr
datetime			ldt_offservice_start, ldt_offservice_end 
boolean			lb_notusedhere = false
decimal			ld_rate, ld_contract_exp
boolean			lb_monthly_rate

lds_offservice_contract_exp = create mt_n_datastore
lds_offservice_contract_exp.dataObject = "d_payment_settle_offservice_contract_exp"
lds_offservice_contract_exp.setTransObject(SQLCA)
ll_rows = lds_offservice_contract_exp.retrieve(al_offserviceID )

ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

for ll_row = 1 to ll_rows
	ll_exptypeID 			= lds_offservice_contract_exp.getItemNumber(ll_row, "exp_type_id")
	ll_paymentID			= lds_offservice_contract_exp.getItemNumber(ll_row, "payment_id")
	ldt_offservice_start 	= lds_offservice_contract_exp.getItemDatetime(ll_row, "start_date")
	ldt_offservice_end 	= lds_offservice_contract_exp.getItemDatetime(ll_row, "end_date")
	ld_expense_local		= lds_offservice_contract_exp.getItemDecimal(ll_row, "deductable_amount") * 100    /* eliminate the decimals */

	/* Get contract expense amount as it is used to control posting elements */
	SELECT AMOUNT INTO :ld_contract_exp FROM NTC_PAY_CONTRACT_EXP WHERE PAYMENT_ID = :ll_paymentID AND EXP_TYPE_ID = :ll_exptypeID;
	if sqlca.sqlcode <> 0 then
		of_messagebox("Select error", "Select of contract expense amount failed. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	end if
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "income") = 0 then /* TC IN */
		if ld_contract_exp >= 0 then /* TC IN and Income */
			ls_el3 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el3_tcin_income")
			ls_el4 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el4_tcin_income")
		else  /* TC IN and Expense */
			ls_el3 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el3_tcin_expense")
			ls_el4 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el4_tcin_expense")
		end if
	else /* TC OUT */
		if ld_contract_exp >= 0 then /* TC OUT and Income */
			ls_el3 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el3_tcout_income")
			ls_el4 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el4_tcout_income")
		else  /* TC OUT and Expense */
			ls_el3 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el3_tcout_expense")
			ls_el4 = lds_offservice_contract_exp.getItemString(ll_row, "coda_el4_tcout_expense")
		end if
	end if		
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_offservice_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF

	/* if OPSA setup look if there are any account numbers that shall be replaced */
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 then 
		if of_OPSAtransfer(il_bpost_row, lb_notusedhere) = -1 then
			of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
			Return(-1)
		end if
	end if
	
	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(ldt_offservice_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF

	/* Calculate amount */
	SELECT AMOUNT, MONTHLY
		INTO :ld_rate, :lb_monthly_rate
		FROM NTC_CONTRACT_EXPENSE
		WHERE CONTRACT_ID = :ll_contractID
		AND EXP_TYPE_ID = :ll_exptypeID
		AND TC_OFF_SERVICE_DEPENDENT = 1;
	if isNull(ld_rate) then
		of_messagebox("Select Error", "Error selecting contract expense rate. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	end if		
	ld_rate = ld_rate *100   //fjern decimaler idet bogføres uden decimal

	/* Set field no. 29 (DebitCredit) */
	IF ld_expense_local >= 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Contract Exp. Off Service") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
	if NOT lb_monthly_rate then
		setNull(ld_rate)
	end if		
//	if of_periodiser_bpost(il_bpost_row, ldt_offservice_start, ldt_offservice_end, abs(ld_rate)) = -1 then
//		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_rec_coda, function: of_offservice_contractexp_bpost")
//		Return(-1)
//	END IF
next

return(1)
end function

public function integer of_nonportexp_tccommission (long al_expense_id, decimal ad_exp_amount);/* This functionNon Port Expenses Broker TC Commission */
decimal {2}		ld_amount
decimal {2}		ld_comm_pct
mt_n_datastore				lds_broker, lds_tccomm
long				ll_rows, ll_row, ll_newrow
integer			li_broker_nr
string 			ls_voyage_nr

lds_tccomm = create mt_n_datastore
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create mt_n_datastore
lds_broker.dataObject = "d_payment_settle_nonportexp_tc_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(al_expense_id )

/* Get voyage_nr */
IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
	Return(-1)
END IF

for ll_row = 1 to ll_rows
	ld_comm_pct	= lds_broker.getItemDecimal(ll_row, "broker_comm")
	li_broker_nr		= lds_broker.getItemNumber(ll_row, "broker_nr")
	ld_amount 		= ad_exp_amount * ld_comm_pct / 100
	
	/* Create new row and set defaults */
	ll_newrow = lds_tccomm.insertRow(0)
	if ll_newrow < 1 then return -1
	lds_tccomm.setItem(ll_newrow, "non_port_id", al_expense_id )
	lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
	lds_tccomm.setItem(ll_newrow, "inv_nr", "do not settle")
	lds_tccomm.setItem(ll_newrow, "amount", ld_amount / 100 )
	lds_tccomm.setItem(ll_newrow, "voyage_nr", ls_voyage_nr)
next

/* Update uden commit */
if lds_tccomm.Update() <> 1 then 
	ROLLBACK;
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hire_rec_coda, function: of_nonportexp_tccommission()")
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1
end function

private function integer of_opsatransfer (long al_brow, ref boolean ab_opsareplaced);/* If the TC Contract is a TC-OUT contract with OPSA setup, this function look for 
	a match of element 3 & 4. If found they are replaced by OPSA elements
	
	returns also a status if they where found or not. this status is used to control
	if there shall be created items in TC Commission or not */

long 	ll_orows, ll_found
string	ls_searchString

ll_orows = ids_OPSAtransfer.rowCount()
/* just return if no rows in transfer */
if ll_orows < 1 then 
	return 1
end if

/* Run through all b-posts and find out if there are any accounts numbers that need to be replaced */
ls_searchString = "from_coda_el3='"+ids_bpost.getItemString(al_brow, "f13_el3_b") &
					+"' and from_coda_el4='"+ids_bpost.getItemString(al_brow, "f14_el4_b")+"'"
ll_found = ids_OPSAtransfer.find(ls_searchString, 1, ll_orows )
if ll_found > 0 then
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(al_brow, "f13_el3_b", ids_OPSAtransfer.GetItemString(ll_found, "to_coda_el3")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_OPSAtransfer")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(al_brow, "f14_el4_b", ids_OPSAtransfer.GetItemString(ll_found, "to_coda_el4")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_OPSAtransfer")
		Return(-1)
	END IF
	ab_OPSAreplaced = true
end if	

return 1
end function

public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate);/*  ad_monthly rate is used to avoid problems with periodising amounts when monthly rate
	( 28, 29, 30 or 31 days in a month) if ad_monthly = NULL ignore it and make simple split  */

decimal {4}		ld_total_days, ld_delta_days
decimal {0}		ld_amount_local=0, ld_amount_DKK=0, ld_amount_USD=0							/* Used for calc */
decimal {0}		ld_sum_amount_local=0, ld_sum_amount_DKK=0, ld_sum_amount_USD=0			/* Sum of calc   */
decimal {0}		ld_total_amount_local=0, ld_total_amount_DKK=0, ld_total_amount_USD=0	/* Original value to split */
datetime			ldt_calc_start, ldt_calc_end 		
integer			li_month, li_year
string				ls_voyage_nr

if month(date(adt_start)) = month(date(adt_end)) then return 1

ld_total_amount_local 	= ids_bpost.getItemNumber(al_row, "f30_valuedoc")
ld_total_amount_DKK 		= ids_bpost.getItemNumber(al_row, "f32_valuehome")
ld_total_amount_USD 		= ids_bpost.getItemNumber(al_row, "f34_vatamo_or_valdual")

ld_total_days = (f_datetime2long(adt_end) - f_datetime2long(adt_start))/86400

ldt_calc_start = adt_start
do while month(date(ldt_calc_start)) <> month(date(f_long2datetime(f_datetime2long(adt_end)-1)))
	li_month = month(date(ldt_calc_start)) +1
	li_year  = year(date(ldt_calc_start))
	if li_month = 13 then
		li_month = 1
		li_year ++
	end if
	
	ldt_calc_end = datetime(date(li_year, li_month, 1))
	ld_delta_days = (f_datetime2long(ldt_calc_end) - f_datetime2long(ldt_calc_start))/86400
	/* Calculate periode values */
	if isNull(ad_monthlyrate) then
		ld_amount_local = (ld_total_amount_local / ld_total_days ) * ld_delta_days
	else
		ld_amount_local = (ad_monthlyrate / of_lastdayofmonth(date(ldt_calc_start))) * ld_delta_days
	end if
	ld_sum_amount_local += ld_amount_local
	ld_amount_DKK = ld_amount_local * id_exrate_TC_to_DKK / 100
	ld_sum_amount_DKK += ld_amount_DKK
	ld_amount_USD = ld_amount_local * id_exrate_TC_to_USD / 100
	ld_sum_amount_USD += ld_amount_USD
	/* Create new record and copy values from original row */
	IF of_default_bpost() = -1 then return -1
	ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_bpost.getItemString(al_row, "f13_el3_b")) 
	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_bpost.getItemString(al_row, "f14_el4_b"))
	ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_bpost.getItemNumber(al_row, "f29_debitcredit"))
	ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ids_bpost.getItemString(al_row, "f41_linedesr"))
	/* Set aktivitetsperiode inden skift  og beløb */
	ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))
	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(ldt_calc_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_periodiser_bpost")
		Return(-1)
	END IF
	ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local))
	ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK))
	ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))
	
	ldt_calc_start = ldt_calc_end
loop	
/* Calculate rest amount to update original record with */
ld_amount_local = ld_total_amount_local - ld_sum_amount_local
ld_amount_DKK = ld_total_amount_DKK - ld_sum_amount_DKK
ld_amount_USD = ld_total_amount_USD - ld_sum_amount_USD
ids_bpost.SetItem(al_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))
/* Set field no. 16 (Element 6) */
IF of_getVoyagenr(ldt_calc_start, ls_voyage_nr) <> 1 THEN
	Return(-1)
END IF
IF ids_bpost.SetItem(al_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_periodiser_bpost")
	Return(-1)
END IF
ids_bpost.SetItem(al_row, "f30_valuedoc", abs(ld_amount_local))
ids_bpost.SetItem(al_row, "f32_valuehome", abs(ld_amount_DKK))
ids_bpost.SetItem(al_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))

return 1

end function

protected function boolean of_isleapyear (date ad_source);int li_year
boolean lb_null
SetNull(lb_null)

//Check parameters
If IsNull(ad_source) Then
	Return lb_null
End If

//Get the year using the string function instead of Year()
li_year = year(ad_source)

If (Mod(li_year,4) = 0 And Mod(li_year,100) <> 0) Or Mod(li_year,400) = 0 Then
	Return True
End If

Return False


end function

protected function integer of_lastdayofmonth (date ad_source);//////////////////////////////////////////////////////////////////////////////
//	Function:  		of_LastDayOfMonth
//
//	Access:  		public
//
//	Arguments: 
//	ad_source 		Date to test.
//
//	Returns:  		Integer
//						The last day # of the month passed.
//						
//	Description:  	Given a date, will determine the last day of the month.
//
//////////////////////////////////////////////////////////////////////////////

integer li_year, li_month, li_day
integer li_daysinmonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

li_year = Year(ad_source)
li_month = Month(ad_source)

If li_month = 2 and of_isleapyear(date(li_year, 01, 01)) Then
	li_day = 29
Else
	li_day = li_daysinmonth[li_month]
end If

Return (li_day)

end function

public function integer of_nonportexp_commission_bpost (long al_expense_id, decimal ad_exp_amount, datetime adt_activity_period, boolean ab_expensetypeopsasetup, string as_typedescription);/* This function posts Non Port Broker Commission set off in hire and creates items in TC Commissions */
decimal {0}		ld_amount_local, ld_amount_DKK, ld_amount_USD
decimal {2}		ld_comm_pct
mt_n_datastore				lds_broker, lds_tccomm
long				ll_rows, ll_row, ll_newrow
string				ls_owner_prefix
integer			li_broker_nr
string				ls_voyage_nr
boolean			lb_OPSAelements_replaced = false

lds_tccomm = create mt_n_datastore
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create mt_n_datastore
lds_broker.dataObject = "d_payment_settle_nonportexp_setoff_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(al_expense_id )
ls_owner_prefix = ids_default_values.GetItemString(1, "prefix_supplier_foreign")

for ll_row = 1 to ll_rows
	li_broker_nr			= lds_broker.getItemNumber(ll_row, "broker_nr")
	ld_comm_pct		= lds_broker.getItemDecimal(ll_row, "broker_comm")
	ld_amount_local 	= ad_exp_amount * ld_comm_pct / 100
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(adt_activity_period , "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "commission_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "commission_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF

	/* If both contract and expense have OPSA setup marked then */
	/* if OPSA setup look if there are any account numbers that shall be replaced */
	lb_OPSAelements_replaced = false
	if istr_trans_input.settle_tc_payment.getItemNumber(1, "opsa_setup") = 1 and ab_expenseTypeOPSAsetup then 
		if of_OPSAtransfer(il_bpost_row, lb_OPSAelements_replaced ) = -1 then
			of_messagebox("Set value error", "Cant replace CODA element 3 & 4 when OPSA setup. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
			Return(-1)
		end if
	end if

	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_amount_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_amount_DKK = ld_amount_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_amount_USD = ld_amount_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_usd)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Non-Port Exp. Comm.Set-off in Hire") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_nonportexp_commission_bpost")
		Return(-1)
	END IF
	
////////////////////////////////////////////////////////////////////////////////////
	/* Create records in TC Commissions */
	/* Create new row and set defaults */
	if lb_OPSAelements_replaced = false then
		ll_newrow = lds_tccomm.insertRow(0)
		if ll_newrow < 1 then return -1
		lds_tccomm.setItem(ll_newrow, "non_port_id", al_expense_id )
		lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
		/* This text "paid via hire" must not be changed as it is used to identify record 
			in n_tc_payment:of:redeliveryMoved() */
		lds_tccomm.setItem(ll_newrow, "inv_nr", "paid via hire") /* !!!!!! */
		lds_tccomm.setItem(ll_newrow, "amount", ld_amount_local / 100)
		lds_tccomm.setItem(ll_newrow, "comm_settle_date", today())
		lds_tccomm.setItem(ll_newrow, "voyage_nr", ls_voyage_nr)
	end if
next

/* Update uden commit */
if lds_tccomm.Update() <> 1 then 
	ROLLBACK;
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hjire_rec_coda, function: of_nonportexp_commission_bpost()")
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1


end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_hire_rec_coda
   <OBJECT> Post of TC hire receivables  - CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    Author        Comments
  00/00/07 		?     Name Here     First Version
  14/02/2011	2277	JMC				f03 and f04 fields are defined in default_coda function
  18/04/2012   2753  JMC				add f43_due_or_payment_date - due date
  19/04/2012	2758	JMC				changed nominal account for bunker off-service
  10/07/2012	2850	JMC				B-post "Bunker Off-Service" - voyage number is displayed for apmcph vessels
  25/10/2012	2779	WWG004			Change TC-Commision list has all the transaction log.
  12/11/2012	2780	LHC010			Add function of_bunker_bpost on bunker delivery or redelivery
  01/04/2015   2898  KSH092         Add function of_portexp_bpost on port expenses
  26/05/2015   3926  SSX014         Only popup a message box for one time
  20/07/2015   4107  LHG008         Fix bug for amount(f30_valuedoc) in B-post
  13/06/2016   3378  KSH092		   Remove Function of_periodiser_bpost and T/C Hire b-post add period start ,period end
  08/10/2016	2212  LHG008		   Sanctions restrictions
********************************************************************/
end subroutine

public function integer of_settle_ntc_commission (long al_paymentid);/* Delete TC Commissions settled by hire */
DELETE 
	FROM NTC_COMMISSION
	WHERE  NTC_COMMISSION.PAYMENT_ID = :al_paymentID 
	AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL
	AND NTC_COMMISSION.INV_NR = "paid via hire";
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "SqlCode         = "+string(sqlca.SQLCode)+&
								  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
								  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
	rollback;
	return -1
end if

/* Delete TC Commissions not settled yet */
DELETE
	FROM NTC_COMMISSION 
	WHERE NTC_COMMISSION.PAYMENT_ID = :al_paymentID 
	AND NTC_COMMISSION.COMM_SETTLE_DATE IS NULL;
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "SqlCode         = "+string(sqlca.SQLCode)+&
								  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
								  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
	rollback;
	return -1
end if

/* NON PORT EXPENSES TC COMMISSION */
/* Delete non port expenses TC Commissions settled by hire */
DELETE NTC_COMMISSION  
	FROM NTC_COMMISSION, NTC_NON_PORT_EXP  
	WHERE NTC_NON_PORT_EXP.NON_PORT_ID = NTC_COMMISSION.NON_PORT_ID 
	AND NTC_NON_PORT_EXP.PAYMENT_ID = :al_paymentID 
	AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL
	AND NTC_COMMISSION.INV_NR = "paid via hire";
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "SqlCode         = "+string(sqlca.SQLCode)+&
								  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
								  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
	rollback;
	return -1
end if

/* Delete Non Port Expenses TC Commissions not settled yet */
DELETE NTC_COMMISSION  
	FROM NTC_COMMISSION, NTC_NON_PORT_EXP  
	WHERE NTC_NON_PORT_EXP.NON_PORT_ID = NTC_COMMISSION.NON_PORT_ID 
	AND NTC_NON_PORT_EXP.PAYMENT_ID = :al_paymentID 
	AND NTC_COMMISSION.COMM_SETTLE_DATE IS NULL;
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "SqlCode         = "+string(sqlca.SQLCode)+&
								  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
								  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
	rollback;
	return -1
end if

return 1
end function

public function integer of_bunker_bpost ();/********************************************************************
   of_bunker_bpost
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
		This function is to generate a new Bpost to AX when user prints statement and 'send to AX' is checked.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	12-11-2012 2780         LHC010        First Version
   	20/07/15   CR4107       LHG008        Fix bug for amount(f30_valuedoc)
   </HISTORY>
********************************************************************/

long		ll_row, ll_rows
integer	li_buy_sell, li_f29_debitcredit, li_null
string	ls_element14, ls_element11, ls_linedesr, ls_voyage_nr
decimal	ld_no_decimal
n_ds		lds_bunker

lds_bunker = create n_ds
lds_bunker.dataObject = "d_sq_gr_tchire_bunker"
lds_bunker.setTransObject(SQLCA)
ll_rows = lds_bunker.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

ls_element14 = ids_default_values.GetItemString(1,"ntc_bunker_unsettled")

if isnull(ls_element14) then
	MessageBox("Retrieval Error", "Not able to retrieve Bunker Unsettled nominal account number.~r~n~r~n" &
					+ "Object: u_transaction_hire_rec_coda, Function: of_bunker_bpost")
	return (-1)
end if

/* get field no. 9 DocDate */
ls_element11 = string(istr_trans_input.doc_date, "YYYYMM")

setnull(li_null)

For ll_row = ll_rows to 1 step -1
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1
	
	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ls_element11) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF	
	
	/* Set field no.14 Element 4*/			
	IF ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_element14) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	li_buy_sell = lds_bunker.getitemnumber(ll_row, "buy_sell")
	
	if li_buy_sell = 1 then
		li_f29_debitcredit = ids_default_values.GetItemNumber(1, "debitcredit_credit")
		ls_linedesr = "Bunker on delivery"
	else
		li_f29_debitcredit = ids_default_values.GetItemNumber(1, "debitcredit_debit")
		ls_linedesr = "Bunker on redelivery"
	end if
	
	/* Set field no. 29 (DebitCredit) */
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", li_f29_debitcredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
	
	ld_no_decimal = 100 * Round(abs(lds_bunker.getitemdecimal(ll_row, "amount_local")), 2)	

	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
	
	/* Set field no.31 Valuedoc dp*/
	IF ids_bpost.SetItem(il_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	/* Set field no. 33 (Valuehome_dp) */
	IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", li_null) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 35 (Valuedual_dp) */
	IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", li_null) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_hire_rec_coda, function: of_default_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ls_linedesr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
Next

return 1
end function

public function integer of_portexp_bpost ();/********************************************************************
   of_portexp_bpost
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
		This function is to generate a new Bpost to AX when user prints statement and 'send to AX' is checked.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31-03-2015 CR2898       KSH092      First Version
   </HISTORY>
********************************************************************/

long		ll_row, ll_rows
integer li_oa_ca
decimal	ld_portexp_amount
string ls_element11,ls_nomaccnr,ls_voyage_nr
mt_n_datastore		lds_port_exp

lds_port_exp = create mt_n_datastore
lds_port_exp.dataObject = "d_sq_tb_payment_settle_port_expenses"
lds_port_exp.setTransObject(SQLCA)
ll_rows = lds_port_exp.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

/* Set field no. 23(F23 Paytype Or Sup)*///F23_PAYTYPE_OR_SUP,trans_log_main_a_f23_paytype_or_sup

For ll_row = 1 to ll_rows
   
   ld_portexp_amount = lds_port_exp.getitemdecimal(ll_row,'port_expense_amount') * 100
	li_oa_ca = lds_port_exp.getitemnumber(ll_row,'exp_for_oa')

	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ids_apost.getItemString(1, "f11_el1") ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b",  ids_default_values.GetItemString(1, "charterer_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.getItemString(1, "ntc_port_expenses")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		Return(-1)
	END IF
	
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) 
		If Port Expense Account = C/A(0), then (if amount >= 0 use credit 160 else use debit 161) . 
      If Port Expense Account = O/A(1), then (if amount >= 0 use debit 161 else use credit 160).
     */
	
	IF li_oa_ca = 0 THEN
		if ld_portexp_amount >= 0 then//160
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
				Return(-1)
			END IF
		else//161
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
				Return(-1)
			END IF
		end if
	ELSE
		if ld_portexp_amount >= 0  then//161
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
				Return(-1)
			END IF
		else//160
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
				Return(-1)
			END IF
		end if
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_portexp_amount)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Port Expenses") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	END IF
	
	/* Set expense as transferred to CODA and Update */
	lds_port_exp.setItem(ll_row, "trans_to_coda", 1)
	if lds_port_exp.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update port expense table Object: u_transaction_hire_rec_coda, function: of_portexp_bpost")
		Return(-1)
	end if		
Next



destroy lds_port_exp
return 1
end function

public function long of_beginfunction ();il_callstacktop ++
return il_callstacktop
end function

public function long of_endfunction (long al_exitcode);/********************************************************************
   of_endfunction
   <DESC>	Popup a message box to show all the collected messages	</DESC>
   <RETURN>	long:
            <LI> al_exitcode
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_exitcode
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/05/15 CR3926        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_upper, ll_i
string ls_empty[]
powerobject lpo_empty[]
	
il_callstacktop --
ll_upper = upperbound(is_messages[])
if il_callstacktop = 0 and ll_upper > 0 then
	// popup a message box
	for ll_i = ll_upper to 2 step -1
		_addMessage(ipo_messages[ll_i] , is_titles[ll_i], is_messages[ll_i], "", false)
	next
	_addMessage(ipo_messages[ll_i] , is_titles[ll_i], is_messages[ll_i], "", true)
	
	ipo_messages[] = lpo_empty[]
	is_titles[] = ls_empty[]
	is_messages[] = ls_empty[]
end if

return al_exitcode
end function

public subroutine of_messagebox (string as_title, string as_message);/********************************************************************
   of_messagebox
   <DESC>	Prevent popuping multiple message boxes	</DESC>
   <RETURN>	(None):
            <LI> none
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_title
		as_message
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/05/15 CR3926        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_upper

if il_callstacktop = 0 then
	super::of_messagebox(as_title, as_message)
else
	ll_upper = upperbound(is_titles[]) + 1
	is_titles[ll_upper] = as_title
	ipo_messages[ll_upper] = this.classdefinition
	is_messages[ll_upper] = as_message
end if

end subroutine

public function integer of_generate_transaction (s_transaction_input astr_trans_input);/********************************************************************
   of_generate_transaction
   <DESC>	Don't popup message boxes for multiple times	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_trans_input
   </ARGS>
   <USAGE>	This function will be integrated to the error service	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		26/05/15 CR3896        SSX014   First Version
   </HISTORY>
********************************************************************/

of_beginfunction()
return of_endfunction(super::of_generate_transaction(astr_trans_input))
end function

on u_transaction_hire_rec_coda.create
call super::create
end on

on u_transaction_hire_rec_coda.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_OPSAtransfer = CREATE n_ds
ids_OPSAtransfer.dataObject = "d_opsa_transfer_posting"
ids_OPSAtransfer.setTransObject(sqlca)



end event

event destructor;call super::destructor;destroy ids_OPSAtransfer

end event

