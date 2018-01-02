$PBExportHeader$u_transaction_hire_pay_coda.sru
$PBExportComments$TC Hire Payables
forward
global type u_transaction_hire_pay_coda from u_transaction_hire
end type
end forward

global type u_transaction_hire_pay_coda from u_transaction_hire
end type
global u_transaction_hire_pay_coda u_transaction_hire_pay_coda

type variables
long				il_bpost_row
decimal {6}		id_exrate_TC_to_DKK, id_exrate_TC_to_USD
string				is_tc_currency
datetime			idt_payment_start, idt_payment_end
decimal{0}		id_hire_less_offservice_local   /* Used to calculate Broker Commission */
decimal{4}		id_hire_days_less_offservice   /* Used to calculate Broker Commission */
boolean			ib_CODA_settled_before = false  /* Used to control if hire posted to CODA */
string				is_profitcenter_CODA_EL4, is_profitcenter_CMS_EL4, is_profitcenterCompanyCode
long				il_post_default_company
					
n_ds ids_apost_array[], ids_bpost_array[]					
end variables

forward prototypes
private function integer of_default_bpost ()
private function integer of_setexrate ()
public function integer of_contractexp_bpost ()
public function integer of_tccommission ()
public function integer of_offservice_bpost ()
private function integer of_hire_bpost ()
public function integer of_fill_transaction ()
public function integer of_hiredbypool ()
public function integer of_nonportexp_bpost ()
public function integer of_commissionhire_bpost ()
public function integer of_sharemember ()
public function integer of_estocexp_bpost ()
public function integer of_revert_est_oc_expense (long al_est_oc_id)
public function integer of_offservice_contractexp_bpost (long al_offserviceid)
public function integer of_nonportexp_tccommission (long al_expense_id, decimal ad_amount)
public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate)
protected function boolean of_isleapyear (date ad_source)
protected function integer of_lastdayofmonth (date ad_source)
public function integer of_nonportexp_commission_bpost (long al_expense_id, decimal ad_amount, datetime adt_activity_period, string as_typedescription)
public subroutine documentation ()
private function integer of_createbpost (string as_companycode)
public function integer of_save ()
private function integer of_extrapostprofitcentercompanycode (datetime adt_start, datetime adt_end)
private function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate, boolean ab_extrapost)
public function integer of_bunker_bpost ()
end prototypes

private function integer of_default_bpost ();/********************************************************************
   of_default_bpost
   <DESC>	Creates an extra b-post based on which company to post in, and set the default values 	</DESC>
   <RETURN>	Integer:
            <LI> 1, X ok
            <LI> -1, X failed	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS></ARGS>
   <USAGE>	</USAGE>
********************************************************************/
/* Insert new B-post */
if il_post_default_company = 1 then
	il_bpost_row = of_createBpost(ids_default_values.getItemString(1, "cmpcode"))
else
	il_bpost_row = of_createBpost( is_codacompanycode )
end if

/* Set field no. 03 (Fiscal Year) */
IF ids_bpost.SetItem(il_bpost_row, "f03_yr", ids_apost.GetItemNumber(1, "f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Fiscal Year) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 04 (Period) */
IF ids_bpost.SetItem(il_bpost_row, "f04_period", ids_apost.GetItemNumber(1, "f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Period) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 12 (Element 2) */
IF ids_bpost.SetItem(il_bpost_row, "f12_el2_b", ids_apost.GetItemString(1, "f12_el2")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 12 (Element 2) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 15 (Element 5) */
IF ids_bpost.SetItem(il_bpost_row, "f15_el5_b", ids_apost.GetItemString(1, "f15_el5")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (NULL) (Element 5) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 16 (Element 6) */
IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", "REV") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 17 (Element 7) */
IF ids_bpost.SetItem(il_bpost_row, "f17_el7_b", "HIRE") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (NULL) (Element 7) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 18 (Element 8) (Always Blank) */
IF ids_bpost.SetItem(il_bpost_row, "f18_el8_b", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 18 (NULL) (Element 8) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 19 (Customer or Supplier) */
IF ids_bpost.SetItem(il_bpost_row, "f19_custsupp", ids_apost.GetItemString(1, "f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 (CustSupp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 27 (linetype) */
IF ids_bpost.SetItem(il_bpost_row, "f27_linetype", ids_default_values.GetItemNumber(1, "linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 27 (Linetype) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
	Return(-1)
END IF

return(1)
end function

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
	of_messagebox("Error", "Cant get Exchange Rate for TC Currency. Object: u_transaction_hire_pay_coda, function: of_setExrate()")
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
		of_messagebox("Error", "Cant get Exchange Rate for USD. Object: Object: u_transaction_hire_pay_coda, function: of_setExrate()")
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

	/* Set expense as transferred to CODA and Update */
	lds_contract_exp.setItem(ll_row, "trans_to_CODA", 1)
	if lds_contract_exp.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	end if		
		
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_expense_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Contract Expenses") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
	if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null ) = -1 then
		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_contractexp_bpost")
		Return(-1)
	END IF
next

return(1)
end function

public function integer of_tccommission ();/* This function is in use again
	changed 17. oktober 2003 ordered by Bo Pedersen */


/* This function is not in use any more
	changed 23. september 2003 ordered by Bo Pedersen */


/* Broker TC Commission */
decimal {2}		ld_amount, ld_original_amount
decimal {2}		ld_comm_pct_or_day
n_ds				lds_broker
n_ds				lds_tccomm
long				ll_rows, ll_row, ll_newrow
integer			li_broker_nr, li_count
string				ls_find 
long 				ll_found, ll_no_of_comm
long				ll_paymentID

/* First check if there is any amount to calculate commission from */
if (id_hire_less_offservice_local = 0 or Isnull(id_hire_less_offservice_local)) and &
	(id_hire_days_less_offservice = 0 or Isnull(id_hire_days_less_offservice)) then
	return 1
end if

lds_tccomm = create n_ds
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create n_ds
lds_broker.dataObject = "d_payment_settle_tc_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"))
ll_paymentID = istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")

CHOOSE CASE ib_CODA_settled_before
	CASE false
		/* This is the first time this payment is settled */
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

			if lds_broker.getItemNumber(ll_row, "amount_per_day_or_percent") = 0 then
				ld_amount = id_hire_less_offservice_local * ld_comm_pct_or_day / 10000  /* fordi beløb i ører */
			else
				ld_amount = id_hire_days_less_offservice * ld_comm_pct_or_day 
			end if				

			if ld_original_amount <> 0 then
				if (ld_amount - ld_original_amount) = 0 then 
					continue  // commission found, but amount the same
				else
					ld_amount -= ld_original_amount  //set commission equal to difference and create new record
				end if
			end if

			/* Create new row and set defaults */
			ll_newrow = lds_tccomm.insertRow(0)
			if ll_newrow < 1 then return -1
			lds_tccomm.setItem(ll_newrow, "payment_id", ll_paymentID)
			lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
			lds_tccomm.setItem(ll_newrow, "inv_nr", "do not settle")
			lds_tccomm.setItem(ll_newrow, "amount", ld_amount)
			lds_tccomm.setItem(ll_newrow, "voyage_nr", "REV")
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
				if lds_broker.getItemNumber(ll_row, "amount_per_day_or_percent") = 0 then
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
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hjire_pay_coda, function: of_tccommission()")
	ROLLBACK;
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1
end function

public function integer of_offservice_bpost ();/* Hvis noget danner denne funktion transactioner for både off-service,
	adressekommission off-service såvel som bunker during off-service
*/
decimal {0}		ld_offservice_local_detail, ld_offservice_DKK_detail, ld_offservice_USD_detail
decimal {0}		ld_bunker_local, ld_bunker_DKK, ld_bunker_USD
decimal {0}		ld_adrcomm
n_ds				lds_offservice, lds_offservice_detail
long				ll_rows, ll_row, ll_detail_rows, ll_detail_row, ll_offserviceID, ll_oldbrow
datetime			ldt_start, ldt_end, ldt_detail_start, ldt_detail_end
decimal{2}		ld_adrcomm_pct
decimal			ld_null;setNull(ld_null)
boolean			lb_tcinPostedDefaultCompanyCode=false

lds_offservice = create n_ds
lds_offservice.dataObject = "d_payment_settle_offservice"
lds_offservice.setTransObject(SQLCA)
ll_rows = lds_offservice.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

lds_offservice_detail = create n_ds
lds_offservice_detail.dataObject = "d_payment_settle_offservice_detail"
lds_offservice_detail.setTransObject(SQLCA)

for ll_row = 1 to ll_rows
	ldt_start 				= lds_offservice.getItemDatetime(ll_row, "start_date")
	ldt_end	 			= lds_offservice.getItemDatetime(ll_row, "end_date")
	ld_bunker_local		= lds_offservice.getItemDecimal(ll_row, "bunker") * 100    /* eliminate the decimals */
	id_hire_days_less_offservice  	-= lds_offservice.getItemDecimal(ll_row, "off_days") /* Used to calc Broker Commission later */
	
	ll_offserviceID		= lds_offservice.getItemNumber(ll_row, "off_service_id")
	ll_detail_rows 		= lds_offservice_detail.retrieve( ll_offserviceID )

	/* Set offservice as transferred to CODA and Update */
	lds_offservice.setItem(ll_row, "trans_to_CODA", 1)
	if lds_offservice.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
		Return(-1)
	end if		

	/* Post Off Service Dependent Contract Expenses if any */
	if of_offservice_contractexp_bpost( ll_offserviceID ) = -1 then return -1
	
	/* Post Off Service details */
	for ll_detail_row = 1 to ll_detail_rows
		ldt_detail_start 						= lds_offservice_detail.getItemDatetime(ll_detail_row, "start_date")
		ldt_detail_end	 					= lds_offservice_detail.getItemDatetime(ll_detail_row, "end_date")
		ld_offservice_local_detail			= lds_offservice_detail.getItemDecimal(ll_detail_row, "offhire") * 100    /* eliminate the decimals */
		id_hire_less_offservice_local 	-= ld_offservice_local_detail   /* Used to calc Broker Commission later */
		
	
		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1
	
		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_detail_start, "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_hire_gl")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_off_service_na")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
	
		/* Set field no. 29 (DebitCredit) */
		IF ld_offservice_local_detail < 0 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_offservice_local_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_offservice_DKK_detail = ld_offservice_local_detail * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_offservice_DKK_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_offservice_USD_detail = ld_offservice_local_detail * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_offservice_USD_detail)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Off-Service") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
	
		/* Periodiser transaction hvis nødvendigt */
		if of_periodiser_bpost(il_bpost_row, ldt_detail_start, ldt_detail_end, ld_null ) = -1 then
			of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
			Return(-1)
		END IF
		
		/* Check if there is adr. commission */
		ld_adrcomm_pct = istr_trans_input.settle_tc_payment.getItemNumber(1, "adr_comm_pct")
		if NOT isNull(ld_adrcomm_pct) AND ld_adrcomm_pct > 0 then 
			/* Create row and set defaults */
			IF of_default_bpost() = -1 then return -1
	
			/* Set field no. 11 (Element 1) */
			IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_detail_start, "YYYYMM")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
	
			END IF
			
			/* Set field no. 13 (Element 3) */
			IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_hire_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 14 (Element 4) */
			IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_off_service_na")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		
			/* Set field no. 29 (DebitCredit) */
			IF ld_offservice_local_detail < 0 THEN
				IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
					of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
					Return(-1)
				END IF
			ELSE
				IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
					of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
					Return(-1)
				END IF
			END IF
			
			/* Set field no. 30 (Valuedoc) */
			ld_adrcomm = ld_offservice_local_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 32 (Valuehome) */
			ld_adrcomm = ld_offservice_DKK_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
			
			/* Set field no. 34 (Valuedual) */
			ld_adrcomm = ld_offservice_USD_detail * ld_adrcomm_pct / 100
			IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_adrcomm)) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
	
			/* Set field no. 41 (Linedescr) */
			IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Adr.Comm.Off-Service") <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
	
			/* Periodiser transaction hvis nødvendigt */
			if of_periodiser_bpost(il_bpost_row, ldt_detail_start, ldt_detail_end, ld_null) = -1 then
				of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		end if
	next
	
	// Bunker during off-hire
	// Tjek først om der er noget

	IF NOT isNull(ld_bunker_local) AND ld_bunker_local <> 0 THEN	
		// find out if profitcenter is marked as "non-MT commercially handled" 
		// and "TC-IN Posted in Default Company Code"
		SELECT P.TC_IN_POST_DEFAULT_COMPANY, CODA_EL4, CMS_EL4
		INTO :lb_tcinPostedDefaultCompanyCode, :is_profitcenter_CODA_EL4, :is_profitcenter_CMS_EL4
		FROM PROFIT_C P, VESSELS V
		WHERE P.PC_NR = V.PC_NR
		AND V.VESSEL_NR = :istr_trans_input.vessel_no; 
		COMMIT;

		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1

		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_start, "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "bunker_a_gl")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "bunker_offservice")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF

		/* Set field no. 29 (DebitCredit) */
		IF ld_bunker_local < 0 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_bunker_local)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_bunker_DKK = ld_bunker_local * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_bunker_DKK)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_bunker_USD = ld_bunker_local * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_bunker_USD)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Bunker Off-Service") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF

	//in case TC IN contract has to be posted in default company code, the bunker during
	//off-services also has to be posted to profit center company code 
	if lb_tcinPostedDefaultCompanyCode then
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "charterer_gl")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_bpost")
			Return(-1)
		END IF
		
		/*
		// AGL - Removed obsolete functionality overridding Element 4
		// Change b-post element 4 to CODA element from Profit Center
		
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", is_Profitcenter_CMS_EL4) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			Return(-1)
		END IF
		*/

		ll_oldbrow = il_bpost_row   // keep old row for later periodisation
		il_bpost_row = of_createBpost ( is_profitcenterCompanyCode )
		
		of_extraPostProfitcenterCompanyCode(ldt_start, ldt_end)
		il_bpost_row = ll_oldbrow //set index back
	end if	

		/* Periodise original b-post if needed */
		if of_periodiser_bpost(il_bpost_row, ldt_start, ldt_end, ld_null) = -1 then
			of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
			Return(-1)
		END IF
	END IF
next

destroy lds_offservice_detail
destroy lds_offservice
return(1)
end function

private function integer of_hire_bpost ();/* Transaction for Hire and Adr. Commission on Hire */

n_ds			lds_hire_detail
long			ll_rows
decimal{0}	ld_hire_local, ld_hire_DKK, ld_hire_USD, ld_adrcomm
decimal{2}	ld_adrcomm_pct
decimal			ld_null;setNull(ld_null)

lds_hire_detail = create n_ds
lds_hire_detail.dataObject = "d_payment_settle_hire"
lds_hire_detail.setTransObject(SQLCA)
ll_rows = lds_hire_detail.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))
if ll_rows < 1 then
	of_messagebox("Retrival error", "Can't retrieve any hire detail. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
end if

idt_payment_start = lds_hire_detail.getItemDatetime(1, "periode_start")
idt_payment_end	= lds_hire_detail.getItemDatetime(ll_rows, "periode_end")
/* Check if hire posted to CODA */
if lds_hire_detail.getItemNumber(1, "trans_to_coda") = 1 then  
	ib_CODA_settled_before = true
	id_hire_less_offservice_local = 0
	id_hire_days_less_offservice = 0
	return 1
end if

ld_hire_local						= lds_hire_detail.getItemDecimal(1, "total_hire") * 100    /* eliminate the decimals */
id_hire_less_offservice_local 	= ld_hire_local   /* Off-hire will be subtracted in another function */
id_hire_days_less_offservice	= lds_hire_detail.getItemDecimal(1, "total_days")

/* Create row and set defaults */
IF of_default_bpost() = -1 then return -1

/* Set field no. 11 (Element 1) */
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 13 (Element 3) */
IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_hire_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 14 (Element 4) */
IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_hire_na")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 29 (DebitCredit) */
IF ld_hire_local < 0 THEN
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
		Return(-1)
	END IF
ELSE
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_hire_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
ld_hire_DKK = ld_hire_local * id_exrate_TC_to_DKK / 100
IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_hire_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
ld_hire_USD = ld_hire_local * id_exrate_TC_to_USD / 100
IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_hire_usd)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 41 (Linedescr) */
/* This text must never be changed as it is used to identify the transaction in the log */
IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "T/C Hire") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Periodiser transaction hvis nødvendigt */
if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Check if there is adr. commission */
ld_adrcomm_pct = istr_trans_input.settle_tc_payment.getItemNumber(1, "adr_comm_pct")
if isNull(ld_adrcomm_pct) OR ld_adrcomm_pct = 0 then return 1   /* No Commission to calculate */

/* Generate Address Commission transaction */

/* Create row and set defaults */
IF of_default_bpost() = -1 then return -1

/* Set field no. 11 (Element 1) */
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 13 (Element 3) */
IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "ntc_hire_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 14 (Element 4) */
IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_default_values.GetItemString(1, "ntc_hire_na")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 29 (DebitCredit) */
IF ld_hire_local < 0 THEN
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
		Return(-1)
	END IF
ELSE
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
ld_adrcomm = ld_hire_local * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
ld_adrcomm = ld_hire_DKK * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
ld_adrcomm = ld_hire_USD * ld_adrcomm_pct / 100
IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_adrcomm)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Set field no. 41 (Linedescr) */
/* This text must never be changed as it is used to identify the transaction in the log */
IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Adr.Comm. Hire") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

/* Periodiser transaction hvis nødvendigt */
if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

return(1)
end function

public function integer of_fill_transaction ();decimal {0}		ld_sum_amount_local, ld_sum_amount_DKK, ld_sum_amount_USD
long				ll_row, ll_rows
string 			ls_vessel_ref_nr

/* Set the TC currency and the exchange rates */
IF of_setExrate() = -1 then Return -1

// In order to solve the task that some expenses can generate transactions for 
// more than one company 
ids_apost_array[1].object.data[1,1,1,56] = ids_apost.object.data[1,1,1,56]
ids_apost = ids_apost_array[1]

////// SET KEYS FOR QUERY PURPOSE //////////////////////////////////////////////////////
IF ids_apost.SetItem(1,"trans_type","TCCODAPay") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_hire_pay_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.agent_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_hire_pay_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.pcn) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_hire_pay_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF
////////////////////////////////////////////////////////////////////////////////////////

/* Change Company Code if TC Hire Contract has to be posted on default company code   */
SELECT TC_IN_POST_DEFAULT_COMPANY, CODA_COMPANY_CODE
INTO :il_post_default_company, :is_profitcenterCompanyCode
FROM VESSELS, PROFIT_C
WHERE  VESSELS.PC_NR =  PROFIT_C.PC_NR
	AND VESSELS.VESSEL_NR = :istr_trans_input.vessel_no ;
if il_post_default_company = 1 then
/* Set field no. 2 Company - Profit center*/
	IF ids_apost.SetItem(1,"f02_cmpcode",ids_default_values.getItemString(1, "cmpcode") ) <> 1 THEN
		of_messagebox("Set value error", "Cant set company code for A-post. Object: u_transaction, function: of_default_coda")
		Return(-1)
	END IF
end if

/////// SET STANDARD VALUES ////////////////////////////////////////////////////////////

/* Set field no. 6  DocCode  */
IF ids_apost.SetItem(1, "f06_doccode", ids_default_values.GetItemString(1, "doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 9 DocDate */
IF ids_apost.SetItem(1, "f09_docdate", datetime(today(), now())) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 09 (Docdate) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 11  Activity Periode  */
IF ids_apost.SetItem(1, "f11_el1", string(istr_trans_input.settle_tc_payment.getItemDatetime(1, "est_due_date"), "yyyymm")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 13  General Ledger Account  */
IF ids_apost.SetItem(1, "f13_el3", ids_default_values.GetItemString(1, "agent_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Own) (Element 3) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 14  Nominal Account  */
IF ids_apost.SetItem(1, "f14_el4", ids_default_values.GetItemString(1, "prefix_supplier_foreign") + istr_trans_input.settle_tc_payment.getItemString(1, "tcowners_nom_acc_nr") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Foreign) (Element 4) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 15  Vessel, Department or Agent  */
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	//COMMIT; no commit as part of LUW
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_expenses, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16  Voyage */
IF ids_apost.SetItem(1, "f16_el6", "REV") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 17  PortCode (always blank)  */
IF ids_apost.SetItem(1, "f17_el7", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 19  Supplier identification (always blank)  */
IF ids_apost.SetItem(1, "f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 20  (always blank)  */
IF ids_apost.SetItem(1, "f20_invoicenr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 20 (Invoice No.) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher no. (always blank) */
IF ids_apost.SetItem(1, "f21_vouchernr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 21 (Voucher No.) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control no. (always blank) */
IF ids_apost.SetItem(1, "f22_controlnr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 23  APM Supplier - same as nominal account (always blank)   */
IF ids_apost.SetItem(1, "f23_paytype_or_sup", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 23 (APM Supplier) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/*Set field no.25 Element F25_PAYMETHOD_OR_DATEOFISSUE*/ 
IF ids_apost.SetItem(1,"f25_paymethod_or_dateofissue", string( istr_trans_input.settle_tc_payment.getItemDatetime(1, "tc_hire_cp_date"),"dd-mm-yyyy" )) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.25 for A-post. Object: u_transaction_hire_rec_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 28  Currency Code  */
IF ids_apost.SetItem(1, "f28_curdoc", is_tc_currency) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 41  Linedescr  */
IF ids_apost.SetItem(1, "f41_linedesr", "TC Hire Payable") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field PaymentID */
istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")
IF ids_apost.SetItem(1, "payment_id", istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field Payment_ID for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/**************************************************************************************/
/* GENERER ALLE B-POSTERINGERNE OG OPSUMMER HVAD DER SÅ SKAL STÅ I A-POST             */
/**************************************************************************************/

///* Kald B-post for Hire */
IF of_hire_bpost() = -1 THEN Return(-1)
IF of_offservice_bpost() = -1 THEN Return(-1)
IF of_nonportexp_bpost() = -1 THEN Return(-1)
IF of_contractexp_bpost() = -1 THEN Return(-1)

//Create Broker Commission expenses transaction.
IF of_commissionhire_bpost() = -1 THEN Return(-1)

/* Kald funktion for Share Members der fordeler alt som har GL kontonummer "010" eller "020" */
IF of_shareMember() = -1 then Return -1

//Create estimate owner/charterer transaction log.
IF of_estocexp_bpost() = -1 THEN Return(-1)

//Create TC Commission transaction
IF of_TCCommission() = -1 THEN Return(-1)

/* Kald funktion der skifter voyagenummer ud fra "REV" til "Txx500" såfremt Hired by Pool */
if of_hiredByPool() = -1 then return -1

If of_bunker_bpost() = -1 then return -1

/* Set field no. 08 DocLineNumber for all B-posts */
ll_rows = ids_bpost.rowCount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		IF ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row +1) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_hire_pay_coda, function: of_fill_bpost")
			Return(-1)
		end if
		IF ids_bpost.getItemNumber(ll_row, "f29_debitcredit") = 161 then
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
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_apost.SetItem(1, "f30_valuedoc", abs(ld_sum_amount_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_apost.SetItem(1, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
IF ids_apost.SetItem(1, "f32_valuehome", abs(ld_sum_amount_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", abs(ld_sum_amount_USD)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

Return(1)
end function

public function integer of_hiredbypool ();/* This function find out if vessel is Hired by a Pool or in Pure Management. 
	If so voyage number in A- and all B-posts will be changed like below:
	- Hired by Pool 			from "REV" to "Tyy500" (voyages before 2011 Tyy050) 
	- Pure Management 	from "REV" to "Tyy499" (voyages before 2011 Tyy049)
	where yy = activity year from element 1 */

long 		ll_rows, ll_row
string 	ls_voyage
integer	li_hiredbypool, li_pureManagement
long 		ll_paymentID

ll_paymentID 			= istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")
li_hiredbypool			= istr_trans_input.settle_tc_payment.getItemNumber(1, "hired_by_pool")
li_pureManagement	= istr_trans_input.settle_tc_payment.getItemNumber(1, "pure_management")

/* IF not hired by pool or pure management then return */
if li_hiredbypool = 0 and li_pureManagement = 0 then return 1

/* Change voyage numbers */
/* Set field no. 16  Voyage in A-post */
if li_hiredbypool = 1 then
	if integer(mid(ids_apost.getItemString(1, "f11_el1"),1,4)) < 2011 then
		ls_voyage = "T" + mid(ids_apost.getItemString(1, "f11_el1"),3,2) + "050"
	else
		ls_voyage = "T" + mid(ids_apost.getItemString(1, "f11_el1"),3,2) + "500"
	end if
elseif li_pureManagement = 1 then
	if integer(mid(ids_apost.getItemString(1, "f11_el1"),1,4)) < 2011 then
		ls_voyage = "T" + mid(ids_apost.getItemString(1, "f11_el1"),3,2) + "049"
	else
		ls_voyage = "T" + mid(ids_apost.getItemString(1, "f11_el1"),3,2) + "499"
 end if
else
	return 1
end if
	
IF ids_apost.SetItem(1, "f16_el6", ls_voyage) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_hire_pay_coda, function: of_hirebypool")
	Return(-1)
END IF

/* Set field no. 17  PortCode in A-post to "TCI" */
IF ids_apost.SetItem(1, "f17_el7", "TCI") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_hire_pay_coda, function: of_hirebypool")
	Return(-1)
END IF

/* Set field no. 16  Voyage and field no. 17 PortCode(always "TCI" for all B-posts */
ll_rows = ids_bpost.rowCount()
for ll_row = 1 to ll_rows
	if li_hiredbypool = 1 then
		if integer(mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),1,4)) < 2011 then
			ls_voyage = "T" + mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),3,2) + "050"
		else
			ls_voyage = "T" + mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),3,2) + "500"
		end if
	elseif li_pureManagement = 1 then
		if integer(mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),1,4)) < 2011 then
			ls_voyage = "T" + mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),3,2) + "049"  
		else
			ls_voyage = "T" + mid(ids_bpost.getItemString(ll_row, "f11_el1_b"),3,2) + "499" 
		end if
	end if

	IF ids_bpost.SetItem(ll_row, "f16_el6_b", ls_voyage) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for B-post. Object: u_transaction_hire_pay_coda, function: of_hirebypool")
		Return(-1)
	END IF
	IF ids_bpost.SetItem(ll_row, "f17_el7_b", "TCI") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for B-post. Object: u_transaction_hire_pay_coda, function: of_hirebypool")
		Return(-1)
	END IF

next

return 1
end function

public function integer of_nonportexp_bpost ();decimal {0}		ld_expense_local, ld_expense_DKK, ld_expense_USD, ld_adrcomm_local, ld_adrcomm_DKK, ld_adrcomm_USD
n_ds				lds_nonport
long				ll_rows, ll_row, ll_expenseID
string				ls_el3, ls_el4, ls_typeDescription
integer			li_income
decimal {2}		ld_adrcomm_pct
datetime			ldt_activity_period

lds_nonport = create n_ds
lds_nonport.dataObject = "d_payment_settle_nonport_expenses"
lds_nonport.setTransObject(SQLCA)
ll_rows = lds_nonport.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))

for ll_row = 1 to ll_rows
	ld_expense_local	= lds_nonport.getItemDecimal(ll_row, "expense") * 100    /* eliminate the decimals */
	li_income			= lds_nonport.getItemNumber(ll_row, "income") 
	ld_adrcomm_pct	= lds_nonport.getItemDecimal(ll_row, "address_commission_pct")
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
	
	/* Set expense as transferred to CODA and Update */
	lds_nonport.setItem(ll_row, "trans_to_CODA", 1)
	if lds_nonport.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if		
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	ldt_activity_period = lds_nonport.getItemDatetime(ll_row, "activity_period")
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_activity_period , "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF li_income = 1 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "NON-"+ls_typeDescription ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	END IF

	/* Check if there is adr. commission */
	if isNull(ld_adrcomm_pct)  then ld_adrcomm_pct = 0
	if ld_adrcomm_pct > 0  then 
		/* Generate Address Commission transaction */
		/* Create row and set defaults */
		IF of_default_bpost() = -1 then return -1
	
		/* Set field no. 11 (Element 1) */
		IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(lds_nonport.getItemDatetime(ll_row, "activity_period"), "YYYYMM")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 13 (Element 3) */
		IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 14 (Element 4) */
		IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 29 (DebitCredit) */
		IF li_income = 1 THEN
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
				Return(-1)
			END IF
		ELSE
			IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
				of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
				Return(-1)
			END IF
		END IF
		
		/* Set field no. 30 (Valuedoc) */
		ld_adrcomm_local = abs(ld_expense_local) * ld_adrcomm_pct / 100
		IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", ld_adrcomm_local ) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 32 (Valuehome) */
		ld_adrcomm_DKK = ld_adrcomm_local * id_exrate_TC_to_DKK / 100
		IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", ld_adrcomm_DKK) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 34 (Valuedual) */
		ld_adrcomm_USD = ld_adrcomm_local * id_exrate_TC_to_USD / 100
		IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", ld_adrcomm_USD) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
		
		/* Set field no. 41 (Linedescr) */
		IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "NON-"+ls_typeDescription+" Adr.Comm") <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
			Return(-1)
		END IF
	end if
	
	/* Broker commission set-off in hire */
	if of_nonportexp_commission_bpost( ll_expenseID, ld_expense_local, ldt_activity_period, ls_typeDescription ) <> 1 then
		of_messagebox("Set value error", "Generation of b-post for commission set-off failed. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if

	/* Broker commission on non-port Expenses */
	if of_nonportexp_tccommission( ll_expenseID, ld_expense_local ) <> 1 then
		of_messagebox("Set value error", "Generation of TC commission failed. Object: u_transaction_hire_pay_coda, function: of_nonportexp_bpost")
		Return(-1)
	end if
next

return(1)
end function

public function integer of_commissionhire_bpost ();/* Broker Commission set off in hire */
decimal {0}		ld_amount_local, ld_amount_DKK, ld_amount_USD
decimal {2}		ld_comm_pct_or_day
n_ds				lds_broker
long				ll_rows, ll_row
string				ls_el4, ls_owner_prefix
decimal			ld_null;setNull(ld_null)

/* First check if there is any amount to calculate commission from */
if (id_hire_less_offservice_local = 0 or Isnull(id_hire_less_offservice_local)) and &
	(id_hire_days_less_offservice = 0 or Isnull(id_hire_days_less_offservice)) then
	return 1
end if

lds_broker = create n_ds
lds_broker.dataObject = "d_payment_settle_comm_setoff"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"))
ls_owner_prefix = ids_default_values.GetItemString(1, "prefix_supplier_foreign")


for ll_row = 1 to ll_rows
	ld_comm_pct_or_day= lds_broker.getItemDecimal(ll_row, "comm")
	ls_el4 				= lds_broker.getItemString(ll_row, "nom_acc_nr")
	if lds_broker.getItemNumber(ll_row, "amount_per_day_or_percent") = 0 then
		ld_amount_local 	= id_hire_less_offservice_local * ld_comm_pct_or_day / 100
	else
		ld_amount_local 	= id_hire_days_less_offservice * ld_comm_pct_or_day * 100
	end if
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "agent_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_owner_prefix+ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_amount_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_amount_DKK = ld_amount_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_amount_USD = ld_amount_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_usd)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Comm.Set-off in Hire") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
	if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end, ld_null) = -1 then
		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
next

destroy lds_broker
return 1
end function

public function integer of_sharemember ();/********************************************************************
   of_sharemember
   <DESC> Create a TC Hire payment that with share member transaction.</DESC>
   <RETURN>	integer: 1 Success
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> 
		If the settle payment's share members is more then 0, tramos will accord
		this to get the different values from default trans.
	</USAGE>
   <HISTORY>
	   Date				CR-Ref		Author		Comments
		17/09/2012		CR2785		WWG004		Change the F14 field from the new field in the default.
		06/12/2012		3068		WWG004		Change TC-Hire share member's account in B-Post.
   </HISTORY>
********************************************************************/

decimal {0}	ld_amount_local = 0, ld_amount_DKK = 0, ld_amount_USD = 0							/* Used for calc */
decimal {0}	ld_sum_amount_local = 0, ld_sum_amount_DKK = 0, ld_sum_amount_USD = 0			/* Sum of calc   */
decimal {0}	ld_total_amount_local = 0, ld_total_amount_DKK = 0, ld_total_amount_USD = 0	/* Original value to split */
decimal {8}	ld_share_pct
n_ds			lds_member
long			ll_members, ll_trans, ll_member_row, ll_tran_row
string		ls_trans_type, ls_e13_acc, ls_e14_acc
integer		li_apm_company

lds_member = create n_ds
lds_member.dataObject = "d_payment_settle_share_member"
lds_member.setTransObject(SQLCA)
ll_members = lds_member.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"))

//If no Members registred, nothing to share 
if ll_members < 1 then 
	destroy lds_member
	return 1
end if

//If Pure Management, registration of Share Members is only for info. 
if istr_trans_input.settle_tc_payment.getItemNumber(1, "pure_management") = 1 then
	destroy lds_member
	return 1
end if

//There are members, get number of B-posts to check
ll_trans = ids_bpost.rowCount()
if ll_trans < 1 then
	//Nothing to share as there are no B-posts. Typically last payment that gets a balance via port expenses (disbursements)
	destroy lds_member
	return 1
end if

ls_e13_acc	= ids_default_values.GetItemString(1, "agent_gl")
ls_e14_acc	= ids_default_values.GetItemString(1, "ntc_share_member_acc")

for ll_tran_row = 1 to ll_trans
	//Get the trans type
	ls_trans_type = lower(trim(ids_bpost.getitemstring(ll_tran_row, "f41_linedesr")))

	ld_sum_amount_local		= 0
	ld_sum_amount_DKK 		= 0
	ld_sum_amount_USD 		= 0
	ld_total_amount_local	= ids_bpost.getItemNumber(ll_tran_row, "f30_valuedoc")
	ld_total_amount_DKK		= ids_bpost.getItemNumber(ll_tran_row, "f32_valuehome")
	ld_total_amount_USD		= ids_bpost.getItemNumber(ll_tran_row, "f34_vatamo_or_valdual")
	
	for ll_member_row = 1 to ll_members
		ld_share_pct	= lds_member.getItemDecimal(ll_member_row, "percent_share")
		li_apm_company	= lds_member.getItemNumber(ll_member_row, "apm_company")		
				
		//If last row in Share Members update original b-post with rest
		if ll_member_row = ll_members then CONTINUE

		// Calculate share values
		ld_amount_local		=  ld_total_amount_local * ld_share_pct / 100
		ld_sum_amount_local	+= ld_amount_local
		ld_amount_DKK			=  ld_total_amount_DKK * ld_share_pct / 100
		ld_sum_amount_DKK		+= ld_amount_DKK
		ld_amount_USD			=  ld_total_amount_USD * ld_share_pct / 100
		ld_sum_amount_USD		+= ld_amount_USD

		//Create new record and copy values from original row
		IF of_default_bpost() = -1 then return -1
		
		ids_bpost.SetItem(il_bpost_row, "f11_el1_b", ids_bpost.getItemString(ll_tran_row, "f11_el1_b"))
		
		/* set expected values */
		
		/* if a selected b-post override with share member detail */
		if li_apm_company = 0 and (ls_trans_type="t/c hire" or ls_trans_type="off-service" or ls_trans_type="contract expenses" or ls_trans_type="comm.set-off in hire" or ls_trans_type="contract exp. off service" or left(ls_trans_type, 4) = "non-") then 
		
		
			ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_e13_acc) 
			ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_e14_acc)
		else
			ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_bpost.getItemString(ll_tran_row, "f13_el3_b")) 
			ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_bpost.getItemString(ll_tran_row, "f14_el4_b"))		
		end if
				
		ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_bpost.getItemNumber(ll_tran_row, "f29_debitcredit"))
		ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ids_bpost.getItemString(ll_tran_row, "f41_linedesr"))

		//Set amount
		ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local))
		ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK))
		ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))
	next //ll_member_row
	//Update the original account

	/* if a selected b-post override with share member detail */
	if li_apm_company = 0 and (ls_trans_type="t/c hire" or ls_trans_type="off-service" or ls_trans_type="contract expenses" or ls_trans_type="comm.set-off in hire" or ls_trans_type="contract exp. off service" or left(ls_trans_type, 4) = "non-") then 
		ids_bpost.SetItem(ll_tran_row, "f13_el3_b", ls_e13_acc) 
		ids_bpost.SetItem(ll_tran_row, "f14_el4_b", ls_e14_acc)
	else

		ids_bpost.SetItem(ll_tran_row, "f13_el3_b", ids_bpost.getItemString(ll_tran_row, "f13_el3_b")) 
		ids_bpost.SetItem(ll_tran_row, "f14_el4_b", ids_bpost.getItemString(ll_tran_row, "f14_el4_b"))		
	end if

	//Calculate rest amount to update original record with
	ld_amount_local = ld_total_amount_local - ld_sum_amount_local
	ld_amount_DKK	 = ld_total_amount_DKK - ld_sum_amount_DKK
	ld_amount_USD	 = ld_total_amount_USD - ld_sum_amount_USD
	
	ids_bpost.SetItem(ll_tran_row, "f30_valuedoc", abs(ld_amount_local))
	ids_bpost.SetItem(ll_tran_row, "f32_valuehome", abs(ld_amount_DKK))
	ids_bpost.SetItem(ll_tran_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))
next //ll_tran_row

destroy lds_member
return 1

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
			of_messagebox("Update Error", "Can't create reverse expense: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
			Return(-1)
		end if		
	end if
	
	/* Set expense as transferred to CODA and Update */
	lds_estocexp.setItem(ll_row, "trans_to_CODA", 1)
	if lds_estocexp.Update() <> 1 then
		rollback;
		of_messagebox("Update Error", "Can't update expense table Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	end if		
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ids_apost.getItemString(1, "f11_el1") ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b",  ids_default_values.GetItemString(1, "charterer_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_apost.getItemString(1, "f14_el4")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) 
		Income and Owner Expense 		= credit (160)
		Income and Charterer Expense  = credit (160)
		Expense and Owner Expense		= debit (161)
		Expense and Charterer Expense = debit (161)     */
	
	IF li_income = 1 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 17 (Element 7) */
	IF	ids_bpost.SetItem(il_bpost_row, "f17_el7_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Element 7) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF

	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Est. O/C Expenses") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_estocexp_bpost")
		Return(-1)
	END IF

next

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
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_pay_coda.of_revert_est_oc_expense)")
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
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_pay_coda.of_revert_est_oc_expense)")
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
	of_messagebox("Select error", "Select from NTC_EST_OC_EXP failed! (u_transaction_hire_pay_coda.of_revert_est_oc_expense)")
	return -1
end if

return 1
end function

public function integer of_offservice_contractexp_bpost (long al_offserviceid);decimal {0}	ld_expense_local, ld_expense_DKK, ld_expense_USD
n_ds			lds_offservice_contract_exp
long			ll_rows, ll_row, ll_contractID, ll_exptypeID, ll_paymentID
string			ls_el3, ls_el4
datetime		ldt_offservice_start, ldt_offservice_end
decimal		ld_rate, ld_contract_exp
boolean		lb_monthly_rate

lds_offservice_contract_exp = create n_ds
lds_offservice_contract_exp.dataObject = "d_payment_settle_offservice_contract_exp"
lds_offservice_contract_exp.setTransObject(SQLCA)
ll_rows = lds_offservice_contract_exp.retrieve(al_offserviceID )

ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

for ll_row = 1 to ll_rows
	ll_exptypeID 			= lds_offservice_contract_exp.getItemNumber(ll_row, "exp_type_id")
	ll_paymentID			= lds_offservice_contract_exp.getItemNumber(ll_row, "payment_id")
	ldt_offservice_start 	=  lds_offservice_contract_exp.getItemDatetime(ll_row, "start_date")
	ldt_offservice_end 	=  lds_offservice_contract_exp.getItemDatetime(ll_row, "end_date")
	ld_expense_local		= lds_offservice_contract_exp.getItemDecimal(ll_row, "deductable_amount") * 100    /* eliminate the decimals */

	/* Get contract expense amount as it is used to control posting elements */
	SELECT AMOUNT INTO :ld_contract_exp FROM NTC_PAY_CONTRACT_EXP WHERE PAYMENT_ID = :ll_paymentID AND EXP_TYPE_ID = :ll_exptypeID;
	if sqlca.sqlcode <> 0 then
		of_messagebox("Select error", "Select of contract expense amount failed. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
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
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
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
		of_messagebox("Select Error", "Error selecting contract expense rate. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	end if		
	ld_rate = ld_rate *100   //fjern decimaler idet bogføres uden decimal
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_expense_local >= 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_expense_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_expense_DKK = ld_expense_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_expense_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_expense_USD = ld_expense_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_expense_USD)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "Contract Exp. Off Service") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
	
	/* Periodiser transaction hvis nødvendigt */
	if NOT lb_monthly_rate then
		setNull(ld_rate)
	end if		
	if of_periodiser_bpost(il_bpost_row, ldt_offservice_start, ldt_offservice_end, abs(ld_rate)) = -1 then
		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_offservice_contractexp_bpost")
		Return(-1)
	END IF
next

return(1)
end function

public function integer of_nonportexp_tccommission (long al_expense_id, decimal ad_amount);/* Non-Port expenses  Broker TC Commission */
decimal {2}		ld_amount
decimal {2}		ld_comm_pct
n_ds				lds_broker, lds_tccomm
long				ll_rows, ll_row, ll_newrow
integer			li_broker_nr

lds_tccomm = create n_ds
lds_tccomm.dataObject = "d_table_ntc_commission"
lds_tccomm.setTransObject(SQLCA)

lds_broker = create n_ds
lds_broker.dataObject = "d_payment_settle_nonportexp_tc_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(al_expense_id)

/* This is the first time this payment is settled */
for ll_row = 1 to ll_rows
	ld_comm_pct	= lds_broker.getItemDecimal(ll_row, "broker_comm")
	li_broker_nr		= lds_broker.getItemDecimal(ll_row, "broker_nr")
	ld_amount = ad_amount * ld_comm_pct / 100

	/* Create new row and set defaults */
	ll_newrow = lds_tccomm.insertRow(0)
	if ll_newrow < 1 then return -1
	lds_tccomm.setItem(ll_newrow, "non_port_id", al_expense_id )
	lds_tccomm.setItem(ll_newrow, "broker_nr", li_broker_nr)
	lds_tccomm.setItem(ll_newrow, "inv_nr", "do not settle")
	lds_tccomm.setItem(ll_newrow, "amount", ld_amount / 100)
	lds_tccomm.setItem(ll_newrow, "voyage_nr", "REV")
next

/* Update uden commit */
if lds_tccomm.Update() <> 1 then 
	of_messagebox("Update Error", "There is a problem updating TC Commissions. Object: u_transaction_hjire_pay_coda, function: of_nonportexp_tccommission()")
	ROLLBACK;
	destroy lds_broker
	destroy lds_tccomm
	return -1
end if

destroy lds_broker
destroy lds_tccomm
return 1
end function

public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate);/*  ad_monthly rate is used to avoid problems with periodising amounts when monthly rate
	( 28, 29, 30 or 31 days in a month) if ad_monthly = NULL ignore it and make simple split  */
decimal {4} 		ld_total_days, ld_delta_days
decimal {0}		ld_amount_local=0, ld_amount_DKK=0, ld_amount_USD=0							/* Used for calc */
decimal {0}		ld_sum_amount_local=0, ld_sum_amount_DKK=0, ld_sum_amount_USD=0			/* Sum of calc   */
decimal {0}		ld_total_amount_local=0, ld_total_amount_DKK=0, ld_total_amount_USD=0	/* Original value to split */
datetime			ldt_calc_start, ldt_calc_end 		
integer			li_month, li_year

if month(date(adt_start)) = month(date(adt_end)) then return 1

ld_total_amount_local 	= ids_bpost.getItemNumber(al_row, "f30_valuedoc")
ld_total_amount_DKK 		= ids_bpost.getItemNumber(al_row, "f32_valuehome")
ld_total_amount_USD 	= ids_bpost.getItemNumber(al_row, "f34_vatamo_or_valdual")

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

public function integer of_nonportexp_commission_bpost (long al_expense_id, decimal ad_amount, datetime adt_activity_period, string as_typedescription);/* Non Port Expenses Broker Commission set off in hire */
decimal {0}		ld_amount_local, ld_amount_DKK, ld_amount_USD
decimal {2}		ld_comm_pct
n_ds				lds_broker
long				ll_rows, ll_row
string				ls_el4, ls_owner_prefix

lds_broker = create n_ds
lds_broker.dataObject = "d_payment_settle_nonportexp_setoff_comm"
lds_broker.setTransObject(SQLCA)
ll_rows = lds_broker.retrieve(al_expense_id )
ls_owner_prefix = ids_default_values.GetItemString(1, "prefix_supplier_foreign")

for ll_row = 1 to ll_rows
	ld_comm_pct		= lds_broker.getItemDecimal(ll_row, "broker_comm")
	ls_el4 				= lds_broker.getItemString(ll_row, "nom_acc_nr")
	ld_amount_local 	= ad_amount * ld_comm_pct / 100
	
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1

	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(adt_activity_period , "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "agent_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 14 (Element 4) */
	IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_owner_prefix+ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 29 (DebitCredit) */
	IF ld_amount_local < 0 THEN
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
			Return(-1)
		END IF
	END IF
	
	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 32 (Valuehome) */
	ld_amount_DKK = ld_amount_local * id_exrate_TC_to_DKK / 100
	IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 34 (Valuedual) */
	ld_amount_USD = ld_amount_local * id_exrate_TC_to_USD / 100
	IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_usd)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "NON-"+as_typeDescription+" Comm. set-off in Hire") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_nonportexp_commissionhire_bpost")
		Return(-1)
	END IF
next

destroy lds_broker
return 1
end function

public subroutine documentation ();/********************************************************************************************************
   ObjectName: u_transaction_hire_pay_coda
   <OBJECT> Post of TC hire payments  - CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   otherobjs</ALSO>
		Date   		Ref		Author		Comments
		00/00/07 	?   		Name Here  	First Version
		14/02/2011	2277		JMC			f03 and f04 fields are defined in default_coda function
		14/04/2011	2322		RMO			added switch to default company code in case setting on profitcenter
		16/05/2011	2390		RMO			bunker during off-service are posted on both the profitcenter
													company code, and the default company code (added array 
													of datastores to be able to handle more than one set of 
													transactions, and rewritten the save function)
		27/03/2012	FIN		JMC			Add cp_date in field 25
		19/04/2012	2758		JMC			Changed nominal account for bunker off-service
		17/09/2012	2785		WWG004		Changed the F14 field for the new field TC share member.
		06/12/2012	3068		WWG004		Change TC-Hire share member's account in B-Post.
		12/11/2012	2780		LHC010		Add function of_bunker_bpost on bunker delivery or redelivery
		20/07/2015	4107		LHG008		Fix bug for amount(f30_valuedoc) in B-post
********************************************************************************************************/
end subroutine

private function integer of_createbpost (string as_companycode);/********************************************************************
   of_createBpost
   <DESC>	Creates the proper b-post based on the company code passed	</DESC>
   <RETURN>	Integer:
            <LI> rownumber	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>	as_companycode: Company Code	</ARGS>
   <USAGE>	</USAGE>
********************************************************************/
long ll_index
long ll_rows, ll_row
boolean lb_found = false

ll_rows = upperbound(ids_apost_array)
for ll_row = 1 to ll_rows
	if as_companycode = ids_apost_array[ll_row].getItemString(1, "f02_cmpcode") then 
		lb_found = true
		ll_index = ll_row
		exit
	end if
next
//if not found, create new transaction set
if NOT lb_found then
	ll_index = upperBound(ids_apost_array) +1
	ids_apost_array[ll_index] = create n_ds
	ids_apost_array[ll_index].dataObject = "d_trans_log_main_a"
	ids_apost_array[ll_index].object.data[1,1,1,56] = ids_apost.object.data[1,1,1,56]
	ids_apost_array[ll_index].setItem(1, "f02_cmpcode", as_companyCode)
	ids_bpost_array[ll_index] = create n_ds
	ids_bpost_array[ll_index].dataObject="d_trans_log_b"
	ids_apost_array[ll_index].SetTransObject(SQLCA)
ids_bpost_array[ll_index].SetTransObject(SQLCA)
end if

ids_apost = ids_apost_array[ll_index]
ids_bpost = ids_bpost_array[ll_index]

return ids_bpost.insertRow(0)
end function

public function integer of_save ();/* Saves the transactions (datastores) in transaction log */
long 	ll_transkey, ll_brows, ll_brow
long	ll_datawindows, ll_datawindow
decimal {0} ld_valueDoc, ld_valueHome, ld_valueDual

ll_datawindows = upperBound(ids_apost_array)

// Check and populate A-post amounts
for ll_datawindow = 1 to ll_datawindows
 	if isNull(ids_apost_array[ll_datawindow].getItemDecimal(1, "f30_valuedoc"))  then
		ll_brows = ids_bpost_array[ll_datawindow].RowCount()
		ld_valueDoc = 0
		ld_valueDual = 0
		ld_valueHome = 0
		for ll_brow = 1 to ll_brows
			if ids_bpost_array[ll_datawindow].getItemNumber(ll_brow, "f29_debitcredit") &
			= ids_default_values.getItemNumber(1, "debitcredit_debit") then
				ld_valueDoc += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f30_valuedoc")
				ld_valueHome += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f32_valuehome")
				ld_valueDual += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f34_vatamo_or_valdual")
			else
				ld_valueDoc -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f30_valuedoc")
				ld_valueHome -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f32_valuehome")
				ld_valueDual -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f34_vatamo_or_valdual")
			end if				
		next
		if ld_valueDoc >= 0 then
			// Credit 
			ids_apost_array[ll_datawindow].setItem(1, "f29_debitcredit", ids_default_values.getItemNumber(1, "debitcredit_credit"))
		else
			// Debit
			ids_apost_array[ll_datawindow].setItem(1, "f29_debitcredit", ids_default_values.getItemNumber(1, "debitcredit_debit"))
		end if	
		// Set values
		ids_apost_array[ll_datawindow].setItem(1, "f30_valuedoc", abs(ld_valueDoc) )
		ids_apost_array[ll_datawindow].setItem(1, "f31_valuedoc_dp", 2 )
		ids_apost_array[ll_datawindow].setItem(1, "f32_valuehome", abs(ld_valueHome) )
		ids_apost_array[ll_datawindow].setItem(1, "f33_valuehome_dp", 2 )
		ids_apost_array[ll_datawindow].setItem(1, "f34_vatamo_or_valdual", abs(ld_valueDual) )
		ids_apost_array[ll_datawindow].setItem(1, "f35_vattyp_or_valdual_dp", 2 )
	end if
next

// Update All A-posts and B-posts
for ll_datawindow = 1 to ll_datawindows
	IF ids_apost_array[ll_datawindow].RowCount() = 1 THEN
		IF ids_bpost_array[ll_datawindow].RowCount() > 0 THEN
			/* Save apost and fill transkey in bpost and save bpost */
			IF ids_apost_array[ll_datawindow].Update() = 1 THEN
				ll_transkey = ids_apost_array[ll_datawindow].GetItemNumber(1,"trans_key")
				IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
					of_messagebox("Generate transaction error", "No value found for transaction key")
					ROLLBACK;
					Return(-1)
				ELSE
					ll_brows = ids_bpost_array[ll_datawindow].RowCount()
					FOR ll_brow = 1 TO ll_brows
						ids_bpost_array[ll_datawindow].SetItem(ll_brow, "trans_key", ll_transkey)
						ids_bpost_array[ll_datawindow].SetItem( ll_brow, "f08_doclinenum_b", ll_brow +1 )
					NEXT
					ids_bpost_array[ll_datawindow].AcceptText()
					IF ids_bpost_array[ll_datawindow].Update() = 1 THEN
						continue					
					ELSE
						ROLLBACK;
						of_messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
						Return(-1)
					END IF
				END IF
			ELSE
				of_messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
				ROLLBACK;
				Return(-1)
			END IF
		ELSE
			of_messagebox("Generate transaction error", "No rows found in B-post")
			Return(-1)
		END IF
	ELSE
		of_messagebox("Generate transaction error", "Non or too many rows found in A-post")
		Return(-1)
	END IF
next
COMMIT;

return 1

end function

private function integer of_extrapostprofitcentercompanycode (datetime adt_start, datetime adt_end);long ll_index
long ll_datawindows, ll_datawindow
long ll_browarray, ll_brow
boolean lb_found = false
string ls_tcownerAccount
decimal	ld_null;setNull(ld_null)

ll_datawindows = upperbound(ids_apost_array)
for ll_datawindow = 1 to ll_datawindows
	if ids_default_values.getItemString(1, "cmpcode") = ids_apost_array[ll_datawindow].getItemString(1, "f02_cmpcode") then 
		lb_found = true
		ll_index = ll_datawindow
		exit
	end if
next
if NOT lb_found then return c#return.failure

ll_browarray = ids_bpost_array[ll_datawindow].rowCount()
ll_brow = ids_bpost.rowcount( )

ids_bpost.object.data[ll_brow,1,ll_brow, 25] = ids_bpost_array[ll_datawindow].object.data[ll_browarray,1,ll_browarray,25]

ids_apost.setItem(1, "f13_el3", ids_default_values.getItemString(1, "charterer_gl"))
ids_apost.setItem(1, "f14_el4", is_profitcenter_coda_el4 )

ids_bpost.setItem(ll_brow, "f13_el3_b", ids_default_values.getItemString(1, "bunker_a_gl"))
ids_bpost.setItem(ll_brow, "f14_el4_b", ids_default_values.getItemString(1, "bunker_a_acc"))

/* Periodiser transaction hvis nødvendigt */
if of_periodiser_bpost(ll_brow, adt_start, adt_end, ld_null, TRUE) = -1 then
	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_hire_bpost")
	Return(-1)
END IF

ids_apost = ids_apost_array[1]
ids_bpost = ids_bpost_array[1]

return c#return.success
end function

private function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end, decimal ad_monthlyrate, boolean ab_extrapost);/********************************************************************
   of_periodiser_bpost
   <DESC>	Overload of function of_periodiser_bpost, used when extra posting s have to be made
	to profit center company code
	What the function does, is to split the different amounts into the months they belong to, in
	order to get them posted correct.</DESC>
   <RETURN>	Integer:
            <LI>  1, X ok
            <LI> -1, X failed	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>	al_row: current row number
            		adt_start: period start (either the payment period, or if off-service, the off-service period
            		adt_end: period end (either the payment period, or if off-service, the off-service period
				ad_monthlyrate:
				ad_extrapost: if the transaction is the "extra" post to profitcenter company code or not</ARGS>
   <USAGE>	How to use this function	</USAGE>
********************************************************************/
long	ll_rc

if ab_extrapost then
	il_post_default_company = 0
	ll_rc = of_periodiser_bpost( al_row, adt_start, adt_end, ad_monthlyrate )
	il_post_default_company = 1
else
	ll_rc = of_periodiser_bpost( al_row, adt_start, adt_end, ad_monthlyrate )
end if	

return ll_rc
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
		This function is to generate a new Bpost to AX when user settles the payment.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	12-11-2012 2780         LHC010        First Version
   	20/07/15   CR4107       LHG008        Fix bug for amount(f30_valuedoc)
   </HISTORY>
********************************************************************/

long		ll_row, ll_rows
integer	li_buy_sell, li_f29_debitcredit, li_null
string	ls_element14, ls_element11, ls_linedesr
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
ls_element11 = string(today(), "YYYYMM")
setnull(li_null)


For ll_row = 1 to ll_rows
	/* Create row and set defaults */
	IF of_default_bpost() = -1 then return -1
	
	/* Set field no. 11 (Element 1) */
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ls_element11) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	/* Set field no. 13 (Element 3) */
	IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF	
	
	/* Set field no.14 Element 4*/			
	IF ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_element14) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
	
	li_buy_sell = lds_bunker.getitemnumber(ll_row, "buy_sell")
	
	if li_buy_sell = 1 then
		li_f29_debitcredit = ids_default_values.GetItemNumber(1, "debitcredit_credit")
		ls_linedesr = "Bunker on relivery"
	else
		li_f29_debitcredit = ids_default_values.GetItemNumber(1, "debitcredit_debit")
		ls_linedesr = "Bunker on delivery"
	end if
	
	/* Set field no. 29 (DebitCredit) */
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", li_f29_debitcredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
	
	ld_no_decimal = 100 * Round(abs(lds_bunker.getitemdecimal(ll_row, "amount_local")), 2)	

	/* Set field no. 30 (Valuedoc) */
	IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
	
	/* Set field no.31 Valuedoc dp*/
	IF ids_bpost.SetItem(il_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF

	/* Set field no. 33 (Valuehome_dp) */
	IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", li_null) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
		Return(-1)
	END IF
	
	/* Set field no. 35 (Valuedual_dp) */
	IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", li_null) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_hire_pay_coda, function: of_default_bpost")
		Return(-1)
	END IF	
	
	/* Set field no. 41 (Linedescr) */
	/* This text must never be changed as it is used to identify the transaction in the log */
	IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ls_linedesr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_hire_pay_coda, function: of_bunker_bpost")
		Return(-1)
	END IF
Next

return 1
end function

on u_transaction_hire_pay_coda.create
call super::create
end on

on u_transaction_hire_pay_coda.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_apost_array[1] = CREATE n_ds
ids_bpost_array[1] = CREATE n_ds

ids_apost_array[1].DataObject = "d_trans_log_main_a"
ids_bpost_array[1].DataObject = "d_trans_log_b"
ids_apost_array[1].SetTransObject(SQLCA)
ids_bpost_array[1].SetTransObject(SQLCA)
end event

event destructor;call super::destructor;long ll_row

for ll_row = upperbound(ids_apost_array) to 1 step -1
	DESTROY ids_apost_array[ll_row] 
	DESTROY ids_bpost_array[ll_row]
next
end event

