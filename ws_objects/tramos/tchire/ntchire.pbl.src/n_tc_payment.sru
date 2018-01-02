$PBExportHeader$n_tc_payment.sru
$PBExportComments$Payment ancester
forward
global type n_tc_payment from nonvisualobject
end type
end forward

shared variables

end variables

global type n_tc_payment from nonvisualobject
end type
global n_tc_payment n_tc_payment

type variables
protected long 						il_contractID
protected n_ds 						ids_payments
protected n_ds 						ids_payment_details
protected w_progress_no_cancel	iw_progress
protected decimal{6}					id_payment_exrate
protected datetime					idt_delivery, idt_redelivery
protected boolean						ib_income
protected integer						ii_payday, ii_interval
protected time							it_paytime

end variables

forward prototypes
protected function integer of_destroydatastores ()
protected function long of_retrievepayments (integer ai_status)
protected function integer of_setrates (ref datastore ads_period_rates)
protected function boolean of_isperiodefullmonth (datetime adt_start, datetime adt_end)
public function integer of_ispaymentfinal (integer al_payment_id, integer al_contract_id)
protected subroutine of_calcpaymentmonthlyrate ()
protected subroutine of_setpaymentexrate ()
protected function integer of_movedeletedlinks ()
protected subroutine of_setestimatedduedate ()
protected function integer of_createPaymentdates ()
protected function integer of_calcoffservicedailyrate ()
protected subroutine of_calcpaymentbalance ()
public function integer of_recalcpaymentbalance (long al_contractid)
public function integer of_createpayments (long al_contractid)
protected subroutine of_calccontractexpenses ()
protected function integer of_redeliverymoved ()
public function long of_getnextunpaid (long al_contract_id, long al_payment_id)
public function long of_getfirstpartpaid (long al_contract_id)
public function long of_getlastunpaid (long al_contract_id)
public function long of_getpreviousunpaid (long al_contract_id, long al_payment_id)
public function long of_getnextpartpaid (long al_contract_id, long al_payment_id)
public function long of_getpreviouspartpaid (long al_contract_id, long al_payment_id)
public function long of_getfirstunpaid (long al_contract_id)
public subroutine of_modifypayments (long al_contractid)
protected function integer of_calcoffservicemonthlyrate ()
protected subroutine of_calcpaymentdailyrate ()
protected function integer of_createdatastores ()
protected subroutine of_calccommission ()
public subroutine of_offservicemodified (long al_contractid, long al_paymentid[])
public function integer of_calcoffservicedependentcontractexp (decimal ad_rate, boolean ab_monthly, datetime adt_start, datetime adt_end, ref decimal ad_amount)
public function integer of_dependentcontractexpensesmodified (long al_contractid, long al_ops_off_service_id)
public function integer of_deliverybunkermodified (long ai_bpdetailid, decimal ad_bunkervalue, ref long ad_affected_paymentid[2])
public subroutine documentation ()
private function integer _revert_transaction (long al_paymentid)
public function long of_get_firstnewordraft (long al_contract_id)
public function boolean of_isleapyear (date ad_source)
public function integer of_lastdayofmonth (date ad_source)
public function integer of_selectcount (datetime adt_due_date, long al_contract_id)
public function long of_getlastunpaid (long al_contract_id, long al_payment_id)
end prototypes

protected function integer of_destroydatastores ();destroy ids_payments
destroy ids_payment_details

return 1
end function

protected function long of_retrievepayments (integer ai_status);/* retrieves payments for a given contract and with status greater than argument (ai_status)

*/

return ids_payments.retrieve(il_contractID, ai_status)
end function

protected function integer of_setrates (ref datastore ads_period_rates);/*
Description: 	Cleans the period rates data store for succesive periods with same rate. 
*/

long ll_counter

ads_period_rates.dataObject = "d_period_rates"
ads_period_rates.setTransObject(SQLCA)
  
ads_period_rates.retrieve(il_contractid)

FOR ll_counter = ads_period_rates.rowcount() to 2 step -1
	if ads_period_rates.getitemdecimal(ll_counter, "rate") = &
				ads_period_rates.getitemdecimal(ll_counter - 1, "rate") then
		ads_period_rates.setitem(ll_counter - 1, "periode_end", ads_period_rates.getitemdatetime( ll_counter, "periode_end"))
		ads_period_rates.deleterow(ll_counter)
	end if
NEXT

return 1
end function

protected function boolean of_isperiodefullmonth (datetime adt_start, datetime adt_end);/* This function checks if a periode is a full month or not 

	returns a boolean True  =  full month
							False =  not full month
*/

integer li_Dstart, li_Dend   	/* day */
integer li_Mstart, li_Mend		/* month */
integer li_Ystart, li_Yend		/* year */

/* Check time */
if time(adt_start) <> time(adt_end) then 
	return false
end if

/* Check day */
li_Dstart = day(date(adt_start))
li_Dend	= day(date(adt_end))

if 	(li_Dstart = of_lastDayofMonth(date(adt_start)) and li_Dend > li_Dstart) &
	or (li_Dend = of_lastDayofMonth(date(adt_end)) and li_Dstart > li_Dend) &
	or (li_Dstart = of_lastDayofMonth(date(adt_start)) and li_Dend = of_lastDayofMonth(date(adt_end))) then
	li_Dstart = 40	/* test purpose */
	li_Dend = 40 
end if


if li_Dstart <> li_Dend then
	return False
end if

/* Check year and month */

li_Ystart 	= year(date(adt_start))
li_Yend 		= year(date(adt_end))
li_Mstart 	= month(date(adt_start))
li_Mend	 	= month(date(adt_end))

if (li_Yend > li_Ystart) and (li_Mend = 1) then
	li_Yend --
	li_Mend = 13
end if

if (li_Ystart <> li_Yend) or (li_Mstart + 1 <> li_Mend) then
	return false
end if

/* everything went OK - difference exactly one month */
return True
end function

public function integer of_ispaymentfinal (integer al_payment_id, integer al_contract_id);/*
Desc.:		This function checks if the Payment ID argument is the final payment for the contract. 
				This is used when generating hire statement - the last payment is the final hire
				statement which includes history.
Arguments:	al_payment_id
				al_contract_id
Returns: 	1 if al_payment_id is the final payment for the contract
				0 if al_payment_id is NOT the final payment for the contract
				-1 if no payments are received for the contract ID (will not occur under normal circumstances)
*/

/*retrieve the payments for the contract with status <7 (i.e. ALL payments) sorted by date*/
IF ids_payments.retrieve(al_contract_id, 7) < 1 THEN //no payments for the contract
	Messagebox("Operation not possible", "The contract does not have any payments!", StopSign!)
	return - 1
END IF

IF ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id") = al_payment_id THEN 
	RETURN 1
ELSE
	RETURN 0
END IF
end function

protected subroutine of_calcpaymentmonthlyrate ();/* This function calculates payment details when rate is defined as monthly */

mt_n_datastore 	lds_rates,lds_payment_all
long 			ll_payIdx, ll_rateIdx, ll_detailIdx, ll_payments, ll_details, ll_rates
datetime 	ldt_payStart, ldt_payEnd
datetime		ldt_rateStart, ldt_rateEnd
datetime 	ldt_detailStart, ldt_detailEnd
datetime 	ldt_extraDate /* used when payment covers month shift */
long 			ll_paymentID,ll_count,ll_payment_status, ll_paymentstatus_next, ll_paymentid_next
string 		ls_filter
decimal{4}	ld_days, ld_rate

lds_rates = create mt_n_datastore
of_setRates(lds_rates)
lds_payment_all = create mt_n_datastore
lds_payment_all.dataobject = 'd_sq_tb_table_ntc_payment_all'
lds_payment_all.settransobject(sqlca)
lds_payment_all.retrieve(il_contractid)
ll_payments = lds_payment_all.rowCount()



for ll_payIdx = 1 to ll_payments
	/* Progress bar update */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_payIdx/ll_payments, "Calculating payment amounts...")
	end if

	ll_paymentID = lds_payment_all.getItemNumber(ll_payIdx, "payment_id")
	/* first delete all payment details */
	ll_payment_status = lds_payment_all.getItemNumber(ll_payIdx, "payment_status")
	if ll_payment_status < 3 then
		ll_details = ids_payment_details.retrieve(ll_paymentID)
		for ll_detailIdx = 1 to ll_details
			ids_payment_details.deleteRow(ll_detailIdx)
		next
	end if
	/* Get dates for filter and filter so Rates only have relevant records left */
	if ll_payment_status > 2 then
		SELECT MIN(PERIODE_START)
		INTO :ldt_payStart
		FROM NTC_PAYMENT_DETAIL
		WHERE PAYMENT_ID = :ll_paymentID;
	else
		ldt_payStart = lds_payment_all.getItemDatetime(ll_payIdx, "est_due_date")
	end if
	
	if ll_payIdx < ll_payments then
		
		if ll_payment_status > 2 then
			SELECT MAX(PERIODE_END)
			INTO :ldt_payEnd
			FROM NTC_PAYMENT_DETAIL
			WHERE PAYMENT_ID = :ll_paymentID;
		else
			ll_paymentstatus_next = lds_payment_all.getItemNumber(ll_payIdx + 1, "payment_status")
			if ll_paymentstatus_next < 3 then
				ldt_payEnd = lds_payment_all.getItemDatetime(ll_payIdx + 1, "est_due_date")
			else
				ll_paymentid_next = lds_payment_all.getItemNumber(ll_payIdx + 1, "payment_id")
				SELECT MIN(PERIODE_START)
				INTO :ldt_payEnd
				FROM NTC_PAYMENT_DETAIL
				WHERE PAYMENT_ID = :ll_paymentid_next;
			end if
		end if
	else
		ls_filter = ""
		lds_rates.setFilter(ls_filter)
		lds_rates.Filter()
		lds_rates.Sort()
		ldt_payEnd = lds_rates.getItemDatetime(lds_rates.RowCount(), "periode_end")
	end if
	ls_filter = "datetime('" + string(ldt_payStart, "yyyy-mmm-dd hh:mm") + "') < periode_end and " &
					+ "datetime('" + string(ldt_payEnd, "yyyy-mmm-dd hh:mm") + "') > periode_start"
	lds_rates.setFilter(ls_filter)
	lds_rates.Filter()
	lds_rates.Sort()

/* set payment details */
	choose case lds_rates.rowCount()
		case 0  /* no rates periode matching payment periode - impossible scenario */
			MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
										"Object: n_tc_payment, function: of_calcPaymentMonthlyRate()")
			rollBack;
			destroy lds_rates
			return 
		case 1  /* only one rate periode matching payment periode */
			if (ll_payIdx = 1 or ll_payIdx = ll_payments) &   
			and not of_isPeriodeFullMonth(ldt_payStart, ldt_payEnd) then
				/* if first or last periode and not full month */
				/* then payment is partial */
				if month(date(ldt_payStart)) <> &
										month(date(f_long2datetime(f_datetime2long(ldt_payEnd) - 1))) then
					/* if payment covers month shift  - one extra payment detail*/
					ldt_extraDate = datetime(date(Year(date(ldt_payEnd)), month(date(ldt_payEnd)), 01))	
					SELECT COUNT(*)
					INTO :ll_count
					FROM NTC_PAYMENT_DETAIL
					WHERE PERIODE_START = :ldt_payStart AND PERIODE_END = :ldt_extraDate AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
					
					if ll_count < 1 then
						ll_detailIdx = ids_payment_details.InsertRow(0)
						ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
						ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_payStart)
						ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_extraDate)
						ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
						ld_days = (f_datetime2long(ldt_extraDate) - f_datetime2long(ldt_payStart)) / 86400
						ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
						/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
							before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
						ld_rate = lds_rates.getItemNumber(1, "rate") / &
										of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_extraDate) - 1)))
						ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
					end if
					ldt_payStart = ldt_extraDate
				end if
				SELECT COUNT(*)
				INTO :ll_count
				FROM NTC_PAYMENT_DETAIL
				WHERE PERIODE_START = :ldt_payStart AND PERIODE_END = :ldt_payEnd AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
				
				if ll_count < 1 then
					ll_detailIdx = ids_payment_details.InsertRow(0)
					ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
					ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_payStart)
					ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_payEnd)
					ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
					ld_days = (f_datetime2long(ldt_payEnd) - f_datetime2long(ldt_payStart)) / 86400
					ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
					/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
						before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
					ld_rate = lds_rates.getItemNumber(1, "rate") / &
									of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_payEnd) - 1)))
					ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
				end if
			else  
				/* full month payment in middel - no special needs */ 
				SELECT COUNT(*)
				INTO :ll_count
				FROM NTC_PAYMENT_DETAIL
				WHERE PERIODE_START = :ldt_payStart AND PERIODE_END = :ldt_payEnd AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
				
				if ll_count < 1 then
					ll_detailIdx = ids_payment_details.InsertRow(0)
					ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
					ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_payStart)
					ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_payEnd)
					ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 1)
					ids_payment_details.setItem( ll_detailIdx, "quantity", 1)
					ids_payment_details.setItem( ll_detailIdx, "rate", lds_rates.getItemNumber(1, "rate"))
				end if
			end if
		case else /* payment covers several rate periods */
			ll_rates = lds_rates.Rowcount()
			for ll_rateIdx = 1 to ll_rates
				/* Set start of detail */
				if ll_rateIdx = 1 then     
					ldt_detailStart = ldt_payStart
				else
					ldt_detailStart = lds_rates.getItemDatetime(ll_rateIdx, "periode_start")
				end if
				/* Set end of detail */
				if ll_rateIdx = ll_rates then   
					ldt_detailEnd = ldt_payEnd
				else
					ldt_detailEnd = lds_rates.getItemDatetime(ll_rateIdx, "periode_end")
				end if
				
				if month(date(ldt_detailStart)) <> &
										month(date(f_long2datetime(f_datetime2long(ldt_detailEnd) - 1))) then
					/* if payment covers month shift  - one extra payment detail*/
					ldt_extraDate = datetime(date(Year(date(ldt_detailEnd)), month(date(ldt_detailEnd)), 01))
					SELECT COUNT(*)
					INTO :ll_count
					FROM NTC_PAYMENT_DETAIL
					WHERE PERIODE_START = :ldt_detailStart AND PERIODE_END = :ldt_extraDate AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
					
					if ll_count < 1 then
						ll_detailIdx = ids_payment_details.InsertRow(0)
						ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
						ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_detailStart)
						ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_extraDate)
						ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
						ld_days = (f_datetime2long(ldt_extraDate) - f_datetime2long(ldt_detailStart)) / 86400
						ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
						/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
							before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
						ld_rate = lds_rates.getItemNumber(ll_rateIdx, "rate") / &
										of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_extraDate) - 1)))
						ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
					end if
					ldt_detailStart = ldt_extraDate
				end if
				SELECT COUNT(*)
				INTO :ll_count
				FROM NTC_PAYMENT_DETAIL
				WHERE PERIODE_START = :ldt_detailStart AND PERIODE_END = :ldt_detailEnd AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
				
				if ll_count < 1 then
					ll_detailIdx = ids_payment_details.InsertRow(0)
					ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
					ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_detailStart)
					ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_detailEnd)
					ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
					ld_days = (f_datetime2long(ldt_detailEnd) - f_datetime2long(ldt_detailStart)) / 86400
					ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
					/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
						before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
					ld_rate = lds_rates.getItemNumber(ll_rateIdx, "rate") / &
									of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_detailEnd)-1)))
					ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
				end if
			next					
	end choose
	if ids_payment_details.update() = 1 then
		commit; 
	else
		MessageBox("Update Error", "Update of payment details went wrong. Object: n_tc_payment, function: of_calcPaymentMonthlyRate()")
		rollBack;
		destroy lds_rates
		return 
	end if
	
next

destroy lds_rates
end subroutine

protected subroutine of_setpaymentexrate ();/* REM 24. june 2003
	this function is not in use any more. The exchange rate is set 
	at settle time

string 			ls_tc_currency
decimal {6}		ld_exrate_tc, ld_exrate_usd

SELECT NTC_TC_CONTRACT.CURR_CODE  
	INTO :ls_tc_currency  
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractid ;

if ls_tc_currency = "USD" then
	id_payment_exrate = 100
else
	SELECT EX1.EXRATE_DKK  
		INTO :ld_exrate_tc  
		FROM NTC_EXCHANGE_RATE EX1  
		WHERE ( EX1.CURR_CODE = :ls_tc_currency ) AND  
				( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
											FROM NTC_EXCHANGE_RATE EX2 
											WHERE EX2.CURR_CODE = :ls_tc_currency ) );
	IF isNull(ld_exrate_tc) OR ld_exrate_tc = 0 THEN
		MessageBox("Error", "Cant get Exchange Rate for TC Currency. Object: n_tc_payment, function: of_setPaymentExrate()")
		Return  
	END IF
	
	SELECT EX1.EXRATE_DKK  
		INTO :ld_exrate_usd  
		FROM NTC_EXCHANGE_RATE EX1  
		WHERE ( EX1.CURR_CODE = "USD" ) AND  
				( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
											FROM NTC_EXCHANGE_RATE EX2 
											WHERE EX2.CURR_CODE = "USD" ) );
	IF isNull(ld_exrate_usd) OR ld_exrate_usd = 0 THEN
		MessageBox("Error", "Cant get Exchange Rate for USD. Object: n_tc_payment, function: of_setPaymentExrate()")
		Return 
	END IF
	id_payment_exrate = ( ld_exrate_usd / ld_exrate_tc ) * 100
	/*Changed by Klaus Mygind April 15th - was ld_exrate_tc/ld_exrate_usd before*/
end if

return

*/ 
end subroutine

protected function integer of_movedeletedlinks ();/********************************************************************
   of_movedeletedlinks( )
   <DESC>   this function moves port expenses,  non-port expenses and off-services connected
	from a deleted payment to the last payment</DESC>
   <RETURN> Integer:
            <LI> 1,  X ok
            <LI> -1,  X failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS></ARGS>
   <USAGE>Used when the period dates change</USAGE>
	
	 <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-03-2015 CR3930      KSH092              revert sent to AX data when delete contract
   </HISTORY>
********************************************************************/
	
	
long 		ll_paymentID
long		ll_del_rows,  ll_del_rowno
long 		ll_last_paymentID
string ls_invoice_nr, ls_finemail
int li_row, li_rc, li_tc_in
n_tc_transaction	lnv_tc_transaction

ll_del_rows = ids_payments.deletedCount()
if ll_del_rows < 1 then return 1  //nothing to move as no rows deleted

if ids_payments.rowcount( ) > 0 then
	ll_last_paymentID = ids_payments.getItemNumber(ids_payments.rowCount(),  "payment_id",  primary!,  false)
else
	SELECT MAX(PAYMENT_ID)
		INTO :ll_last_paymentID
		FROM NTC_PAYMENT
		WHERE CONTRACT_ID = :il_contractid;
	if sqlca.sqlcode <> 0 then
		MessageBox("Select Error",  "Error selecting payment ID! (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if
end if

lnv_tc_transaction = create n_tc_transaction
SELECT TC_HIRE_IN
INTO   :li_tc_in
FROM NTC_TC_CONTRACT
WHERE CONTRACT_ID = :il_contractid;

for ll_del_rowno = 1 to ll_del_rows
	ll_paymentID = ids_payments.getItemNumber(ll_del_rowno,  "payment_id",  delete!,  false)
	ls_invoice_nr = ids_payments.getitemstring(ll_del_rowno, 'invoice_nr', delete!, false)
	if li_tc_in = 0  then//TC out
		if isnull(ls_invoice_nr) or trim(ls_invoice_nr) = "" then
			UPDATE TRANS_LOG_MAIN_A
			SET PAYMENT_ID = NULL
			WHERE PAYMENT_ID = :ll_paymentid and
					TRANS_TYPE like "TCCODA%";
			if sqlca.sqlcode < 0 then
				ROLLBACK;
				messageBox("DB Error",  "SqlCode   = "+string(sqlca.SQLCode) + &
									  "~n~rSql DB Code = "+string(sqlca.SQLDBCode) + &
									  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
				
				return c#return.Failure
			end if
		else
			li_rc = lnv_tc_transaction.of_credit_note(ll_paymentid, ls_invoice_nr, ls_finemail)
			if li_rc = c#return.Failure then
				rollback;
				if ls_finemail="" then ls_finemail = "unknown"
				messagebox("Error", "The invoice data has not been sent to AX,  because the credit note creation failed." + c#string.cr + c#string.cr +"A notification email has been sent to " +  ls_finemail + "." + c#string.cr + "Please contact Finance for further assistance.")
				return c#return.Failure
			end if
		end if
	end if
	
	UPDATE NTC_PORT_EXP  
		SET PAYMENT_ID = :ll_last_paymentID  
		WHERE PAYMENT_ID = :ll_paymentID;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Update Error",  "Error updating NTC_PORT_EXP. (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if

	UPDATE NTC_NON_PORT_EXP  
		SET PAYMENT_ID = :ll_last_paymentID  
		WHERE PAYMENT_ID = :ll_paymentID;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Update Error",  "Error updating NTC_NON_PORT_EXP. (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if

	UPDATE NTC_OFF_SERVICE  
		SET PAYMENT_ID = :ll_last_paymentID  
		WHERE PAYMENT_ID = :ll_paymentID;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Update Error",  "Error updating NTC_OFF_SERVICE. (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if

	UPDATE NTC_EST_OC_EXP  
		SET PAYMENT_ID = :ll_last_paymentID  
		WHERE PAYMENT_ID = :ll_paymentID;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Update Error",  "Error updating NTC_EST_OC_EXP. (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if


	UPDATE BP_DETAILS  
		SET PAYMENT_ID = :ll_last_paymentID  
		WHERE PAYMENT_ID = :ll_paymentID;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("Update Error",  "Error updating BP_DETAIL. (n_tc_payment.ofmovedeletedlinks()")
		return -1
	end if





next
destroy lnv_tc_transaction
return 1
end function

protected subroutine of_setestimatedduedate ();/* If due days (+/-) is entered then add number of days to estimated due date
	otherwise just return */

integer	li_additional_days	
long		ll_rows, ll_rowno
datetime	ldt_duedate
	
ll_rows = ids_payments.rowCount()
if ll_rows < 1 then return

SELECT isnull(NTC_TC_CONTRACT.PAYMENT_DUE_DAYS,0)  
	INTO :li_additional_days  
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractid ;
	
if li_additional_days = 0 then return

for ll_rowno = 1 to ll_rows
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_rowno/ll_rows, "Move estimated due date...")
	end if
	
	ldt_duedate = ids_payments.getItemDatetime(ll_rowno, "est_due_date")
	ldt_duedate = datetime(relativeDate(date(ldt_duedate), li_additional_days))
	ids_payments.setItem(ll_rowno, "est_due_date", ldt_duedate)
	
next

if ids_payments.Update() = 1 then
	COMMIT; 
else
	MessageBox("Update Error", "Failure updating NTC_PAYMENT from of_calcComission(), Object: n_tc_payment")
	ROLLBACK;
end if

return
	
end subroutine

protected function integer of_createPaymentdates ();return 1
end function

protected function integer of_calcoffservicedailyrate ();/* Calculates Off-service details when rate is monthly */

long			ll_rows, ll_rowno, ll_modify_counter, ll_detail_row, ll_idx
n_ds			lds_offservice
n_ds			lds_offservice_detail
datastore	lds_rates
datetime		ldt_start, ldt_end
long 			ll_offservice_minutes
decimal{4}	ld_daily_rate
decimal{4}	ld_days
string 		ls_filter
long 			ll_offservice_id

lds_offservice = create n_ds
lds_offservice.dataObject = "d_list_unsettled_offservice"
lds_offservice.setTransObject(SQLCA)
ll_rows = lds_offservice.retrieve(il_contractid)

lds_offservice_detail = create n_ds
lds_offservice_detail.dataObject = "d_table_off_service_detail"
lds_offservice_detail.setTransObject(SQLCA)

lds_rates = create datastore
of_setRates(lds_rates)

for ll_rowno = 1 to ll_rows
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_rowno/ll_rows, "Calculating Off-service details...")
	end if
	
	/* Get offservice values (keys,dates and minutes) */
	ll_offservice_id 		= lds_offservice.getItemNumber(ll_rowno, "off_service_id")
	ldt_start 				= lds_offservice.getItemDatetime(ll_rowno, "start_date")
	ldt_end 					= lds_offservice.getItemDatetime(ll_rowno, "end_date")
	ll_offservice_minutes= lds_offservice.getItemNumber(ll_rowno, "off_minutes")
	
	/* get offservice details */
 	ll_modify_counter = lds_offservice_detail.retrieve(ll_offservice_id)
	ll_detail_row = 0

	/* Hent rater */
	ls_filter = "datetime('" + string(ldt_start, "yyyy-mmm-dd hh:mm") + "') < periode_end and " &
					+ "datetime('" + string(ldt_end, "yyyy-mmm-dd hh:mm") + "') > periode_start"
	lds_rates.setFilter(ls_filter)
	lds_rates.Filter()
		
	/* set payment details */
	choose case lds_rates.rowCount()
		case 1  /* only one rate periode matching payment periode */
			ld_daily_rate = lds_rates.getItemNumber(1, "rate") 
		case else  /* no rates periode matching payment periode - impossible scenario */
			MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
										"Object: n_tc_payment, function: of_calcOffserviceMonthly()")
			destroy lds_offservice
			destroy lds_offservice_detail
			destroy lds_rates
			return -1										
	end choose
	
	/* Beregn + indsæt */
	ld_days = ll_offservice_minutes / 1440  
	/* fill in details   modify or insertrow */
	if ll_modify_counter > ll_detail_row then
		ll_detail_row ++
	else
		ll_detail_row = lds_offservice_detail.insertRow(0)
	end if
	lds_offservice_detail.setItem(ll_detail_row, "off_service_id", ll_offservice_id)
	lds_offservice_detail.setItem(ll_detail_row, "start_date", ldt_start)
	lds_offservice_detail.setItem(ll_detail_row, "end_date", ldt_end)
	lds_offservice_detail.setItem(ll_detail_row, "days", ld_days)
	lds_offservice_detail.setItem(ll_detail_row, "rate", ld_daily_rate)
			
	/* Cleanup if less rows now */
	if ll_detail_row < ll_modify_counter then
		for ll_idx = ll_modify_counter to ll_detail_row +1 step -1
			lds_offservice_detail.deleteRow(ll_idx)
		next
	end if
	
	if lds_offservice_detail.update() = 1 then
		commit;
	else
		MessageBox("Update Error", "Failure updating NTC_OFF_SERVICE_DETAIL. Object: n_tc_payment, function: of_calcOffserviceMonthly()")
	end if
next

destroy lds_offservice
destroy lds_offservice_detail
destroy lds_rates

return 1
end function

protected subroutine of_calcpaymentbalance ();/* This function calculates the payment balance through a stored procedure
	'sp_paymentBalance'. The procedure updates the PAYMENT_BALANCE field 
	in the NTC_PAYMENT table.
	
	The reason for storing the balance is performance */
	
datastore 	lds
long			ll_rows, ll_rowno

ll_rows = ids_payments.rowCount()
if ll_rows < 1 then return

lds = CREATE datastore
lds.DataObject = "d_sp_paymentBalance"
lds.settransobject( sqlca )

for ll_rowno = 1 to ll_rows
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_rowno/ll_rows, "Calculating Payment Balance...")
	end if

	lds.retrieve( ids_payments.getItemNumber(ll_rowno, "payment_id"))
	commit;
next

destroy lds

return  
end subroutine

public function integer of_recalcpaymentbalance (long al_contractid);/* This function recalculates all Payment Balances with status new and draft.
	All other payment balances are updated when settling process is executed*/

str_progress 	lstr_parm	

il_contractID = al_contractID

if isValid(ids_payments) then ids_payments.reset()
if isValid(ids_payment_details) then ids_payment_details.reset()

 /* All payments of status: New and Draft */
if of_retrievePayments(3) < 1 then
	/* no payments to modify */
	/* We are on last payment - final hire */
	/* Set datastore to retrieve only last row */
	ids_payments.dataObject = "d_last_payment"
	ids_payments.setTransObject(SQLCA)
	if ids_payments.retrieve(il_contractID) <> 1 then
		return -1
	end if
end if

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Create/modify payments"
openwithparm(iw_progress, lstr_parm, "w_progress_no_cancel")

/* calculate Payment Balance */ 
of_calcPaymentBalance() 
commit;

/* Closes progress window */
if isValid(iw_progress) then close(iw_progress)

return 1
end function

public function integer of_createpayments (long al_contractid);boolean			lb_monthlyRate
str_progress 	lstr_parm	

il_contractID = al_contractID

if isValid(ids_payments) then ids_payments.reset()
if isValid(ids_payment_details) then ids_payment_details.reset()
 
SELECT CASE NTC_TC_CONTRACT.TC_HIRE_IN WHEN 1 THEN 0 ELSE 1 END,
		  NTC_TC_CONTRACT.DELIVERY,   
         NTC_TC_CONTRACT.PAYMENT,    /* Same field twice as differ */
         NTC_TC_CONTRACT.PAYMENT,    /* in value according to payment type */
         NTC_TC_CONTRACT.MONTHLY_RATE,
         (SELECT max(NTC_TC_PERIOD.PERIODE_END) 
			FROM NTC_TC_PERIOD 
			WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID )  
    INTO :ib_income,
	 		:idt_delivery,   
         :ii_payday,   
         :ii_interval,
			:lb_monthlyRate,
         :idt_redelivery  
    FROM NTC_TC_CONTRACT  
	 WHERE NTC_TC_CONTRACT.CONTRACT_ID = :al_contractid;

if SQLCA.SQLCode = -1 then
	MessageBox("Select Error", "Error selecting from NTC_PERIOD in of_createPayments()~n~r" +&
										"Object: n_tc_payment, function: of_createPayments()")
	rollback;
else
	commit;    
end if

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Create/modify payments"
openwithparm(iw_progress, lstr_parm, "w_progress_no_cancel")

/* Create payments and payment details */
//if lb_interval then
//	of_createIntervalPayments(ldt_delivery, ldt_redelivery, li_payday, not lb_hire_in)
//	of_calcPaymentDailyRate()
//else
//	of_createMonthlyPayments(ldt_delivery, ldt_redelivery, li_payday, not lb_hire_in)
//	if lb_monthlyRate then
//		of_calcPaymentMonthlyRate()
//	else
//		of_calcPaymentDailyRate()
//	end if
//end if

/* Create payments and payment details */
of_createPaymentDates()
if lb_monthlyRate then
	of_calcPaymentMonthlyRate()
else
	of_calcPaymentDailyRate()
end if

/* Create payments contract expenses */
of_calcContractExpenses()

/* No calculation of Off-service as there can't be records before contract */

/* calculate commissions */ 
of_calcCommission() 

/* Change the estimated due date to reflect due days (+/-) */
of_setEstimatedDueDate()

/* calculate Payment Balance */ 
of_calcPaymentBalance() 
commit;

/* Closes progress window */
if isValid(iw_progress) then close(iw_progress)

return 1
end function

protected subroutine of_calccontractexpenses ();/* Calculates contract expenses for each payment in the datastore */

n_ds			lds_cont_exp					/* Contract Expenses */
n_ds			lds_payment_cont_exp			/* Payment Contract Expenses */
long 			ll_payments, ll_expenses
long			ll_payIdx, ll_expIdx
datetime		ldt_payStart, ldt_payEnd, ldt_extraDate, ldt_calcStart, ldt_calcEnd
decimal {4} ld_quantity
decimal {4}	ld_daily_rate
decimal {2}	ld_exp_amount
long 			ll_paymentID
long 			ll_rowno
integer		li_payment_type

lds_cont_exp = create n_ds
lds_cont_exp.dataObject = "d_tc_contract_expenses"
lds_cont_exp.setTransObject(SQLCA)
ll_expenses = lds_cont_exp.retrieve(il_contractID)

if ll_expenses = 0 then   /* nothing to do */ 
	destroy lds_cont_exp
	return
end if

lds_payment_cont_exp = create n_ds
lds_payment_cont_exp.dataObject = "d_table_ntc_pay_contract_exp"
lds_payment_cont_exp.setTransObject(SQLCA)

ll_payments = ids_payments.rowCount()

for ll_payIdx = 1 to ll_payments
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_payIdx/ll_payments, "Calculating Contract expenses...")
	end if
	ll_paymentID = ids_payments.getItemNumber(ll_payIdx, "payment_id")
	SELECT MIN(PERIODE_START), MAX(PERIODE_END), SUM(QUANTITY)
	  INTO :ldt_payStart, :ldt_payEnd, :ld_quantity
	  FROM NTC_PAYMENT_DETAIL
	  WHERE PAYMENT_ID = :ll_paymentID;
	for ll_expIdx = 1 to ll_expenses
		ldt_calcStart 	= ldt_payStart
		ldt_calcEnd 		= ldt_payEnd
		ll_rowno = lds_payment_cont_exp.insertRow(0)
		lds_payment_cont_exp.setItem(ll_rowno, "payment_id", ll_paymentID)
		lds_payment_cont_exp.setItem(ll_rowno, "exp_type_id", &
													lds_cont_exp.getItemNumber(ll_expIdx, "exp_type_id"))
		if of_isPeriodeFullMonth(ldt_calcStart, ldt_calcEnd) then
			if lds_cont_exp.getItemNumber(ll_expIdx, "expense_monthly") = 1 then
				/* Payment: full month - Expense: monthly */
				lds_payment_cont_exp.setItem(ll_rowno, "amount", &
												lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount"))
			else
				/* Payment: full month Expense: daily */
				ld_daily_rate = lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount")
				ld_quantity = (f_datetime2long(ldt_calcEnd) - f_datetime2long(ldt_calcStart)) / 86400 
				ld_exp_amount = ld_quantity * ld_daily_rate
				lds_payment_cont_exp.setItem(ll_rowno, "amount", ld_exp_amount )
			end if
		else  /* Expense is NOT for a full month */
			if lds_cont_exp.getItemNumber(ll_expIdx, "expense_monthly") = 1 then
				SELECT PAYMENT_TYPE INTO :li_payment_type FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :il_contractID;
				if li_payment_type = 3 then
					/* Payment: half month Expense: monthly */
					if ll_paymentID = of_getLastunpaid( il_contractID ) then 
						/* Last payment not necessarily half month  payment */
						ld_daily_rate = lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount") / of_lastdayofmonth( date(ldt_calcStart))
						ld_quantity = (f_datetime2long(ldt_calcEnd) - f_datetime2long(ldt_calcStart)) / 86400 
						ld_exp_amount = ld_quantity * ld_daily_rate
						lds_payment_cont_exp.setItem(ll_rowno, "amount", ld_exp_amount )
					else
						lds_payment_cont_exp.setItem(ll_rowno, "amount", &
													lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount")/2)
					end if 
				else	
					/* Payment: part of month Expense: monthly */
					ld_exp_amount = 0 
					if month(date(ldt_calcStart)) <> &
											month(date(f_long2datetime(f_datetime2long(ldt_calcEnd) - 1))) then
						/* if payment covers month shift - calculation must be splitted */
						ldt_extraDate = datetime(date(Year(date(ldt_calcEnd)), month(date(ldt_calcEnd)), 01))					
						ld_quantity = (f_datetime2long(ldt_extraDate) - f_datetime2long(ldt_calcStart)) / 86400
						/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
							before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
						ld_daily_rate = lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount") / &
										of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_extraDate) - 1)))
						ld_exp_amount += ld_quantity * ld_daily_rate
						ldt_calcStart = ldt_extraDate
					end if
					ld_quantity = (f_datetime2long(ldt_calcEnd) - f_datetime2long(ldt_calcStart)) / 86400
					/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
						before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
					ld_daily_rate = lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount") / &
												of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_calcEnd) - 1)))
					ld_exp_amount += ld_quantity * ld_daily_rate
					lds_payment_cont_exp.setItem(ll_rowno, "amount", ld_exp_amount )
				end if
			else
				/* Payment: part of month Expense: daily */
				ld_daily_rate = lds_cont_exp.getItemNumber(ll_expIdx, "expense_amount")
				ld_exp_amount = ld_quantity * ld_daily_rate
				lds_payment_cont_exp.setItem(ll_rowno, "amount", ld_exp_amount )
			end if
		end if
	next
next

if lds_payment_cont_exp.update() = 1 then
	commit; 
else
	MessageBox("Update Error", "Update of payment contract expenses went wrong in function: of_calcContractExpenses ()~n~r" +&
					"Object: n_tc_payment, function: of_calcContractExpenses()")
	rollBack;
	destroy lds_cont_exp
	destroy lds_payment_cont_exp
	return 
end if

destroy lds_cont_exp
destroy lds_payment_cont_exp

return



end subroutine

protected function integer of_redeliverymoved ();/* This function checks if redelivery date is moved backwards into a payment that is 
	already settled or redelivery moved forward with last payment settled.
	
	 
	  1) Move all port-expenses, non-port expenses, off-services, bunker on DEL/RED 
	     and actual payments to new or draft payment

	  2) Find TC Commissions belonging to same payments. If settled move to current
	     payment, if not delete.
		  
	Return value: 1 OK
					 -1 Error
	*/
datetime		ldt_newRedelivery, ldt_oldRedelivery
datetime		ldt_newDelivery, ldt_oldDelivery
boolean		lb_dateModified = false
long			ll_paymentID,ll_reallocate_paymentid
integer		li_paymentStatus, li_payment_locked, li_tc_in,li_portexp,li_nonportexp,li_bpdetail,li_offhire,li_settle_comm,li_transfer
string		ls_invoice_nr,ls_sql

/* Get redelivery dates */
SELECT MIN(NTCP.PERIODE_START), MAX(NTCP.PERIODE_END) 
	 INTO :ldt_newDelivery, :ldt_newRedelivery
    FROM NTC_TC_PERIOD NTCP  
	 WHERE NTCP.CONTRACT_ID = :il_contractid;
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "Error while selecting new redelivery. (n_tc_payment.of_redeliverymoved())"+&  
				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
	return -1
end if

SELECT  MIN(NPD.PERIODE_START), MAX(NPD.PERIODE_END)   
	 INTO :ldt_oldDelivery, :ldt_oldRedelivery
    FROM NTC_PAYMENT_DETAIL NPD  
	 WHERE NPD.PAYMENT_ID IN (SELECT PAYMENT_ID 
	 										FROM NTC_PAYMENT 
											WHERE CONTRACT_ID = :il_contractid);
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "Error while selecting old redelivery. (n_tc_payment.of_redeliverymoved())"+&  
				"~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				"~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				"~n~rSql ErrText = "+string(sqlca.SQLErrText))
	return -1
end if

/* It delivery date is changed, nothing is settled, and we
can run normal process */
if ldt_newDelivery <> ldt_oldDelivery then return 1

/* First find out if redelivery date is changed or not */
/* If not changed nothing happens */
if ldt_newRedelivery = ldt_oldRedelivery then return 1

IF ldt_newRedelivery < ldt_oldRedelivery then
	/* Redelivery moved backwards. Get covering payment */
		SELECT MAX(P.PAYMENT_ID)
		INTO :ll_paymentID
		FROM NTC_PAYMENT_DETAIL NPD, NTC_PAYMENT P, NTC_TC_CONTRACT M  
		WHERE M.CONTRACT_ID = P.CONTRACT_ID 
		AND NPD.PAYMENT_ID = P.PAYMENT_ID
		AND NPD.PERIODE_START < :ldt_newRedelivery  
		AND NPD.PERIODE_END >= :ldt_newRedelivery
		AND NPD.PAYMENT_ID IN (SELECT PAYMENT_ID 
											FROM NTC_PAYMENT 
											WHERE CONTRACT_ID = :il_contractID);
		
	if sqlca.SQLCode <> 0 then 
		MessageBox("DB Error", "Error while selecting paymentID, SQL 1. (n_tc_payment.of_redeliverymoved())"+&  
				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
		return -1
	end if
	
   SELECT  P.PAYMENT_STATUS, P.LOCKED, P.INVOICE_NR, M.TC_HIRE_IN   
	INTO  :li_paymentStatus, :li_payment_locked, :ls_invoice_nr, :li_tc_in
	FROM NTC_PAYMENT P, NTC_TC_CONTRACT M  
	WHERE M.CONTRACT_ID = P.CONTRACT_ID AND P.PAYMENT_ID = :LL_PAYMENTID ;
  
else
  return c#return.success

 //	/* Redelivery moved forward. Get last payment */
//	SELECT NTC_PAYMENT.PAYMENT_ID, NTC_PAYMENT.PAYMENT_STATUS, NTC_PAYMENT.LOCKED, NTC_PAYMENT.INVOICE_NR, M.TC_HIRE_IN     
//		INTO :ll_paymentID, :li_paymentStatus, :li_payment_locked, :ls_invoice_nr, :li_tc_in
//		FROM NTC_PAYMENT, NTC_TC_CONTRACT M   
//		WHERE  M.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID 
//		AND NTC_PAYMENT.PAYMENT_ID = ( SELECT MAX(NP2.PAYMENT_ID) 
//														FROM NTC_PAYMENT NP2 
//														WHERE NP2.CONTRACT_ID = :il_contractID ) ;
//	if sqlca.SQLCode <> 0 then 
//		MessageBox("DB Error", "Error while selecting paymentID, SQL 2. (n_tc_payment.of_redeliverymoved())"+&  
//				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
//				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
//				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
//		return -1
//	end if
end if

if trim(ls_invoice_nr) = "" then setnull(ls_invoice_nr)


CHOOSE CASE li_paymentStatus
	CASE 1, 2
		/* Payment Status = "New" or "Draft"  */
		ll_reallocate_paymentid = ll_paymentid
	CASE 3,4,5
		/* Payment Status = "Final"/"part paid"/"paid"*/
		SELECT TOP 1 PAYMENT_ID
		INTO :ll_reallocate_paymentid
		FROM NTC_PAYMENT
		WHERE PAYMENT_STATUS < 3 AND PAYMENT_ID < :LL_PAYMENTID AND CONTRACT_ID = :il_contractID
		ORDER BY EST_DUE_DATE DESC ;
END CHOOSE
		
// PORT EXP
SELECT COUNT(*)
INTO :LI_PORTEXP
FROM NTC_PORT_EXP,NTC_PAYMENT
WHERE NTC_PORT_EXP.PAYMENT_ID > :LL_PAYMENTID AND NTC_PAYMENT.PAYMENT_ID = NTC_PORT_EXP.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :il_contractID;
// NON PORT EXP
SELECT COUNT(*)
INTO :LI_NONPORTeXP
FROM NTC_NON_PORT_EXP,NTC_PAYMENT
WHERE NTC_NON_PORT_EXP.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = NTC_NON_PORT_EXP.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :il_contractID;
//BP 
SELECT COUNT(*)
INTO :LI_bpdetail
FROM BP_DETAILS,NTC_PAYMENT
WHERE BP_DETAILS.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :il_contractID;
//OFF HIRE
SELECT COUNT(*)
INTO :LI_offhire
FROM NTC_OFF_SERVICE,NTC_PAYMENT
WHERE NTC_OFF_SERVICE.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :il_contractID;
//TC Commission
SELECT COUNT(*)
INTO :LI_SETTLE_COMM
FROM NTC_COMMISSION, NTC_PAYMENT  
WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID
AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
AND NTC_PAYMENT.CONTRACT_ID = :il_contractID 
AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL;

if li_portexp > 0  or li_nonportexp > 0 or li_bpdetail > 0 or li_offhire > 0 or li_settle_comm > 0  then
	if isnull(ll_reallocate_paymentid) or ll_reallocate_paymentid = 0 then
		return c#return.Failure
	else
		//REALLOCATE PORT EXP
		UPDATE NTC_PORT_EXP
		SET PAYMENT_ID = :ll_reallocate_paymentid,
			 TRANS_TO_CODA = 0
		FROM NTC_NON_PORT_EXP, NTC_PAYMENT  
		WHERE NTC_PAYMENT.PAYMENT_ID = NTC_PORT_EXP.PAYMENT_ID
		AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
		AND NTC_PAYMENT.CONTRACT_ID = :il_contractID ;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while updating port expenses, SQL 8. (n_tc_payment.of_redeliverymoved())"+&  
						  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
						  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
						  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return c#return.Failure
		end if
		//REALLOCATE NON PORT EXP
		UPDATE NTC_NON_PORT_EXP  
		SET NTC_NON_PORT_EXP.PAYMENT_ID = :ll_reallocate_paymentid,
		NTC_NON_PORT_EXP.TRANS_TO_CODA = 0
		FROM NTC_NON_PORT_EXP, NTC_PAYMENT  
		WHERE NTC_PAYMENT.PAYMENT_ID = NTC_NON_PORT_EXP.PAYMENT_ID
		AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
		AND NTC_PAYMENT.CONTRACT_ID = :il_contractID ;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while updating NON port expenses, SQL 9. (n_tc_payment.of_redeliverymoved())"+&  
						  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
										  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
										  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return c#return.Failure
		end if
		
		//REALLOCATE OFF-HIRE
		
		UPDATE NTC_OFF_SERVICE
		SET NTC_OFF_SERVICE.PAYMENT_ID = :ll_reallocate_paymentid,
		NTC_OFF_SERVICE.TRANS_TO_CODA = 0
		FROM NTC_NON_PORT_EXP, NTC_PAYMENT  
		WHERE NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID
		AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
		AND NTC_PAYMENT.CONTRACT_ID = :il_contractID ;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while updating TC Off Services, SQL 11. (n_tc_payment.of_redeliverymoved())"+&  
						  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
						  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
						  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return c#return.Failure
		end if
		
		//REALLOCATE BUNKER
		UPDATE BP_DETAILS
		SET PAYMENT_ID = :ll_reallocate_paymentid  
		FROM BP_DETAILS, NTC_PAYMENT  
		WHERE NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID
		AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
		AND NTC_PAYMENT.CONTRACT_ID = :il_contractID ;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while updating BP Details, SQL 13. (n_tc_payment.of_redeliverymoved())"+&  
						  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
						  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
						  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return c#return.Failure
		end if
		
		//REALLOCATE TC COMMISSION
		UPDATE NTC_COMMISSION
			SET PAYMENT_ID = :ll_reallocate_paymentid  
			FROM NTC_COMMISSION, NTC_PAYMENT  
			WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID
			AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
			AND NTC_PAYMENT.CONTRACT_ID = :il_contractID 
			AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while updating TC Commissions, SQL 4. (n_tc_payment.of_redeliverymoved())"+&  
				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return -1
		end if
		
		//DELETE NOT SETTLE TC COMMISSION
		DELETE NTC_COMMISSION
			FROM NTC_COMMISSION, NTC_PAYMENT  
			WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID
			AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
			AND NTC_PAYMENT.CONTRACT_ID = :il_contractID 
			AND NTC_COMMISSION.COMM_SETTLE_DATE IS NULL;
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while deleting TC Commissions, SQL 5. (n_tc_payment.of_redeliverymoved())"+&  
				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return -1
		end if

		DELETE NTC_COMMISSION
			FROM NTC_COMMISSION, NTC_PAYMENT  
			WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID
			AND NTC_PAYMENT.PAYMENT_ID >= :ll_paymentID 
			AND NTC_PAYMENT.CONTRACT_ID = :il_contractID 
			AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL
			AND NTC_COMMISSION.INV_NR = "paid via hire";
		if sqlca.SQLCode <> 0 then 
			MessageBox("DB Error", "Error while deleting TC Commissions, SQL 6. (n_tc_payment.of_redeliverymoved())"+&  
				  "~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
				  "~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
				  "~n~rSql ErrText = "+string(sqlca.SQLErrText))
			return -1
		end if
		
					
		commit;	
		
		ls_sql = "sp_paymentBalance " + string(ll_reallocate_paymentid)
						
		EXECUTE IMMEDIATE :ls_sql;
		/* Refresh contract window if open */
		if isValid(w_tc_contract) then
			w_tc_contract.PostEvent("ue_refresh")
		end if

	end if
else
	return c#return.success
		
end if
	
		
		
//		
		/* Change transactions sent to CODA - Revert them */
		
	
	
	




return c#return.success
end function

public function long of_getnextunpaid (long al_contract_id, long al_payment_id);/*
Desc.:		This function gets the next un-paid Payment ID for the argument passed. This is used 
				when a user wants to	move a Port Expense, a Non-Port Expense or an Off-Service to the
				next payment.

Arguments:	al_payment_id
				al_contract_id
Returns: 	The next Payment ID for the Contract (i.e. the Payment ID for the first coming payment)
					OR
				-1 if the Payment ID passed is already the last un-paid payment for the contract
					OR
				-1 if the Payment ID passed do not have status New of Draft
*/
LONG 		ll_rows, ll_row, ll_count
STRING	ls_find

ll_rows = ids_payments.retrieve(al_contract_id, 3) /*retrieves the payments for the contract with 
																	status <3 (i.e. new or draft) sorted by date*/
if ll_rows = 0 then
	Messagebox("Operation not possible", "The requested operation is not possible. ~r~n"+&
					"All payments for this contract are settled.", Exclamation!)
	Return -1
end if

ls_find = "payment_id = " + string(al_payment_id)
ll_row = ids_payments.find(ls_find, 1, ll_rows)

choose case ll_row
	case 0 //Current payment don't have status < 3. Return 1st payment_id
		Return ids_payments.getitemnumber(1, "payment_id")
	case ll_rows //last row - no later payments exists for the contract
		SELECT COUNT(*)
		INTO :ll_count
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID > :al_payment_id AND CONTRACT_ID = :al_contract_id;
		if ll_count > 0 then
			MessageBox("Validation","You cannot move the selected item to Next hire statement, because there are no other hire statements in status New or Draft.~n~r~n~r"&
						+"Contact Finance to unsettle and Operations to set the hire statement to Draft.", Information!)
		else
			MessageBox("Validation","You cannot move the selected item to Next hire statement, because you have already selected the Last hire statement.")
		end if
			
							
		Return -1
	case else //get (and return) the payment ID for the next row
		ll_row ++
		Return ids_payments.getitemnumber(ll_row, "payment_id")
end choose
end function

public function long of_getfirstpartpaid (long al_contract_id);/*
Desc.:		This function gets the first part-paid payment Payment ID for the argument passed (Contract ID). 
				This is used to attach disbursement expenses to a TC Contract.
Arguments:	al_contract_id
Returns: 	the first part-paid Payment ID fro the contract
					OR
				The first final Payment ID for the Contract
					OR
				The first un-settled Payment ID for the Contract
					OR
				the last payment's ID (final hire already settled ones)
					IF ERROR
				show message and return -1	
*/


if ids_payments.retrieve(al_contract_id, 5) > 0 THEN 
	/* retrieves the payments for the contract with 
	   status < 5 (i.e. new, draft, final or part-paid 
		sorted by date  */
	return ids_payments.getitemnumber(1,"payment_id")
elseif ids_payments.retrieve(al_contract_id, 6) > 0 THEN
	/* retrieves all payments for the contract with 
	   status < 6 (i.e. new, draft, final, part-paid, paid (incl. settled)) 
		sorted by date */
	return ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id")
ELSE //no un-paid payments exist for the contract
	Messagebox("Operation not possible", "The contract does not have any payments at all!", StopSign!)
	return -1
END IF

end function

public function long of_getlastunpaid (long al_contract_id);/*
Desc.:		This function gets the last un-settled Payment ID for the argument passed (Contract ID). 
				This is used to moved attached expenses from a TC Contract to the last payment.
Arguments:	al_contract_id
Returns: 	The last un-settled Payment ID for the Contract
					OR
				the last payment's ID (final hire already settled ones)
					IF ERROR
				show message and return -1	
*/

if ids_payments.retrieve(al_contract_id, 3) > 0 THEN 
	/* retrieves the payments for the contract with 
	   status < 3 (i.e. new or draft (=not settled)) 
		sorted by date */
	return ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id")
elseif ids_payments.retrieve(al_contract_id, 6) > 0 THEN
	/* retrieves all payments for the contract with 
	   status < 6 (i.e. new, draft, final, part-paid, paid (incl. settled)) 
		sorted by date */
		
	return ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id")
ELSE //no un-paid payments exist for the contract
	Messagebox("Operation not possible", "The contract does not have any payments not settled!", StopSign!)
	return - 1
END IF


end function

public function long of_getpreviousunpaid (long al_contract_id, long al_payment_id);/*
Desc.:		This function gets the previous un-paid Payment ID for the argument passed. This is used 
				when a user wants to	move a Port Expense, a Non-Port Expense or an Off-Service to the
				previous payment.

Arguments:	al_payment_id
				al_contract_id
Returns: 	The previous Payment ID for the Contract (i.e. the Payment ID for the first coming payment)
					OR
				-1 if the Payment ID passed is already the first un-paid payment for the contract
*/
LONG 		ll_rows, ll_row, ll_count
STRING	ls_find

ll_rows = ids_payments.retrieve(al_contract_id, 3) /*retrieves the payments for the contract with 
																	status <3 (i.e. new or draft) sorted by date*/
ls_find = "payment_id = " + string(al_payment_id)
ll_row = ids_payments.find(ls_find, 1, ll_rows)
choose case ll_row
	case 0 //contract ID not found - should NOT happen...
		Messagebox("System error", "Operation failed. ~r~nPlease try again or contact System "+&
						"Administrator if the problem recurs", Exclamation!)
	case 1 //first row - no previous payments exists for the contract
		SELECT COUNT(*)
		INTO :ll_count
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID < :al_payment_id AND CONTRACT_ID = :al_contract_id;
		if ll_count > 0 then
			MessageBox("Validation","You cannot move the selected item to Previous hire statement, because there are no other hire statements in status New or Draft.~n~r~n~r"&
								+"Contact Finance to unsettle and Operations to set the hire statement to Draft.", Information!)
		else
			MessageBox("Validation","You cannot move the selected item to Previous hire statement, because you have already selected the First hire statement.")
		end if
		Return -1
	case else //get (and return) the payment ID for the next row
		ll_row --
		Return ids_payments.getitemnumber(ll_row, "payment_id")
end choose
end function

public function long of_getnextpartpaid (long al_contract_id, long al_payment_id);/*
Desc.:		This function gets the next part-paid or "lower" Payment ID for the argument passed. This is used 
				when a user wants to	move a Port Expense to the next payment.

Arguments:	al_payment_id
				al_contract_id
Returns: 	The next Payment ID for the Contract (i.e. the Payment ID for the first coming payment)
					OR
				-1 if the Payment ID passed is already the last un-paid payment for the contract
					OR
				-1 if the Payment ID passed do not have status New of Draft
*/
LONG 		ll_rows, ll_row
STRING	ls_find

ll_rows = ids_payments.retrieve(al_contract_id, 5) /*retrieves the payments for the contract with 
																	status <5 (i.e. new, draft, final or part-paid) sorted by date*/
if ll_rows = 0 then
	Messagebox("Operation not possible", "The requested operation is not possible. ~r~n"+&
					"All payments for this contract are settled.", Exclamation!)
	Return -1
end if

ls_find = "payment_id = " + string(al_payment_id)
ll_row = ids_payments.find(ls_find, 1, ll_rows)

choose case ll_row
	case 0 //Current payment don't have status < 5. Return 1st payment_id
		Return ids_payments.getitemnumber(1, "payment_id")
	case ll_rows //last row - no later payments exists for the contract
		Messagebox("Operation not possible", "The requested operation is not possible. ~r~n"+&
						"The entry is attached to the last payment not settled for this contract already!", StopSign!)
		Return -1
	case else //get (and return) the payment ID for the next row
		ll_row ++
		Return ids_payments.getitemnumber(ll_row, "payment_id")
end choose
end function

public function long of_getpreviouspartpaid (long al_contract_id, long al_payment_id);/*
Desc.:		This function gets the previous part-paid Payment ID for the argument passed. This is used 
				when a user wants to	move a Port Expense, a Non-Port Expense or an Off-Service to the
				previous payment.

Arguments:	al_payment_id
				al_contract_id
Returns: 	The previous Payment ID for the Contract (i.e. the Payment ID for the first coming payment)
					OR
				-1 if the Payment ID passed is already the first un-paid payment for the contract
*/
LONG 		ll_rows, ll_row
STRING	ls_find

ll_rows = ids_payments.retrieve(al_contract_id, 5) /*retrieves the payments for the contract with 
																	status < 5 (i.e. new, draft, final or part-paid) sorted by date*/
ls_find = "payment_id = " + string(al_payment_id)
ll_row = ids_payments.find(ls_find, 1, ll_rows)
choose case ll_row
	case 0 //contract ID not found - should NOT happen...
		Messagebox("System error", "Operation failed. ~r~nPlease try again or contact System "+&
						"Administrator if the problem recurs", Exclamation!)
		Return -1
	case 1 //first row - no previous payments exists for the contract
		Messagebox("Operation not possible", "The requested operation is not possible. ~r~n"+&
						"The entry is attached to the first payment not settled for this contract already!", StopSign!)
		Return -1
	case else //get (and return) the payment ID for the next row
		ll_row --
		Return ids_payments.getitemnumber(ll_row, "payment_id")
end choose
end function

public function long of_getfirstunpaid (long al_contract_id);/*
Desc.:		This function gets the first unsettled Payment ID for the argument passed (Contract ID). 
				This is used to attach disbursement expenses to a TC Contract.
Arguments:	al_contract_id
Returns: 	The first un-settled Payment ID for the Contract
					OR
				the last payment's ID (final hire already settled ones)
					IF ERROR
				show message and return -1	
*/


if ids_payments.retrieve(al_contract_id, 3) > 0 THEN 
	/* retrieves the payments for the contract with 
	   status < 3 (i.e. new or draft 
		sorted by date  */
	return ids_payments.getitemnumber(1,"payment_id")
elseif ids_payments.retrieve(al_contract_id, 6) > 0 THEN
	/* retrieves all payments for the contract with 
	   status < 6 (i.e. new, draft, final, part-paid, paid (incl. settled)) 
		sorted by date */
	return ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id")
ELSE //no un-paid payments exist for the contract
	Messagebox("Operation not possible", "The contract does not have any payments at all!", StopSign!)
	return -1
END IF

end function

public subroutine of_modifypayments (long al_contractid);boolean			lb_monthlyRate
str_progress 	lstr_parm
datetime			ldt_duedate, ldt_deleteFromDate
long 				ll_settled_payments, ll_payment_id, ll_payment_due_days=0

il_contractID = al_contractID

if isValid(ids_payments) then ids_payments.reset()
if isValid(ids_payment_details) then ids_payment_details.reset()

if of_redeliveryMoved() = -1 then 
	MessageBox("Error", "Something went wrong when trying to move redelivery date.~n~rPlease contact System Administrator")
	rollback;
	return
end if
ids_payments.dataObject = "d_table_ntc_payment"
ids_payments.setTransObject(SQLCA)
/* All payments of status: New and Draft */
if of_retrievePayments(3) < 1 then
//	/* no payments to modify */
//	/* We are on last payment - final hire */
//	/* Call of_recalcBalance for only recalculating balances */
//	of_recalcPaymentBalance(il_contractID) 
////	return
end if
//
//ldt_duedate = ids_payments.getItemDatetime(1, "est_due_date")
if ids_payments.rowcount( ) > 0 then
	ll_payment_id = ids_payments.getItemNumber(1, "payment_id")
	SELECT MIN(PERIODE_START)
		INTO :ldt_duedate
		FROM NTC_PAYMENT_DETAIL  
		WHERE PAYMENT_ID = :ll_payment_id; 
else
	SELECT MAX(EST_DUE_DATE)
	INTO :LDT_DUEDATE
	FROM NTC_PAYMENT_DETAIL,NTC_PAYMENT
	WHERE NTC_PAYMENT.CONTRACT_ID = :il_contractID AND NTC_PAYMENT.PAYMENT_ID = NTC_PAYMENT_DETAIL.PAYMENT_ID;
end if

/* Delete Payment Contract Expenses */
DELETE 
	FROM NTC_PAY_CONTRACT_EXP  
  	WHERE PAYMENT_ID IN (SELECT PAYMENT_ID 
								FROM NTC_PAYMENT
								WHERE ( NTC_PAYMENT.CONTRACT_ID = :il_contractID ) 
								AND  ( NTC_PAYMENT.PAYMENT_ID >= :ll_payment_id )
								AND  (NTC_PAYMENT.PAYMENT_STATUS < 3)) ;  

/* Delete Payment Detail */
DELETE 
	FROM NTC_PAYMENT_DETAIL  
  	WHERE PAYMENT_ID IN (SELECT PAYMENT_ID 
								FROM NTC_PAYMENT
								WHERE ( NTC_PAYMENT.CONTRACT_ID = :il_contractID ) 
								AND  ( NTC_PAYMENT.PAYMENT_ID >= :ll_payment_id )
								AND  (NTC_PAYMENT.PAYMENT_STATUS < 3)) ;  


SELECT CASE NTC_TC_CONTRACT.TC_HIRE_IN WHEN 1 THEN 0 ELSE 1 END,
			NTC_TC_CONTRACT.DELIVERY,
         NTC_TC_CONTRACT.PAYMENT,   
         NTC_TC_CONTRACT.PAYMENT,
         NTC_TC_CONTRACT.MONTHLY_RATE,
         (SELECT max(NTC_TC_PERIOD.PERIODE_END) 
			FROM NTC_TC_PERIOD 
			WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID )  
    INTO :ib_income,
	 		:idt_delivery,
         :ii_payday,   
         :ii_interval,
			:lb_monthlyRate,
         :idt_redelivery  
    FROM NTC_TC_CONTRACT  
	 WHERE NTC_TC_CONTRACT.CONTRACT_ID = :al_contractid;

if SQLCA.SQLCode = -1 then
	MessageBox("Select Error", "Error selecting from NTC_PERIOD in Object: n_tc_payment, function: of_createPayments()")
	rollback;
else
	commit;   
end if

/* If no settled payments it is OK to change delivery date */
SELECT count(*) INTO :ll_settled_payments
	FROM NTC_PAYMENT 
	WHERE CONTRACT_ID = :il_contractID
	AND PAYMENT_STATUS > 2 ;
if ll_settled_payments = 0  then
	ldt_duedate = idt_delivery
end if

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Create/modify payments"
openwithparm(iw_progress, lstr_parm, "w_progress_no_cancel")

/* Create payments and payment details */
//if lb_interval then
//	of_createIntervalPayments(ldt_duedate, ldt_redelivery, li_payday, not lb_hire_in)
//	of_calcPaymentDailyRate()
//else
//	of_createMonthlyPayments(ldt_duedate, ldt_redelivery, li_payday, not lb_hire_in)
//	if lb_monthlyRate then
//		of_calcPaymentMonthlyRate()
//	else
//		of_calcPaymentDailyRate()
//	end if
//end if

/* Create payments and payment details */
idt_delivery = ldt_duedate
of_createPaymentDates()
if lb_monthlyRate then
	of_calcPaymentMonthlyRate()
else
	of_calcPaymentDailyRate()
end if

/* Create payments contract expenses */
of_calcContractExpenses()

/* Calculate off-services details */
if lb_monthlyRate then
	of_calcOffserviceMonthlyRate()
else
	of_calcOffserviceDailyRate()
end if	
	
/*	calculate commissions */
of_calcCommission()

/* Change the estimated due date to reflect due days (+/-) */
of_setEstimatedDueDate()

/* calculate Payment Balance */ 
of_calcPaymentBalance() 
commit;

/* Closes progress window */
if isValid(iw_progress) then close(iw_progress)

return
end subroutine

protected function integer of_calcoffservicemonthlyrate ();/* Calculates Off-service details when rate is monthly */

long			ll_rows, ll_rowno, ll_modify_counter, ll_detail_row, ll_idx
n_ds			lds_offservice
n_ds			lds_offservice_detail
datastore	lds_rates
datetime		ldt_start, ldt_end, ldt_calc
integer		li_mm, li_yy
double 		ll_delta_minutes, ll_detail_minutes, ll_offservice_minutes
decimal{4}	ld_rate, ld_daily_rate
decimal{4}	ld_days
string 		ls_filter
long 			ll_offservice_id

lds_offservice = create n_ds
lds_offservice.dataObject = "d_list_unsettled_offservice"
lds_offservice.setTransObject(SQLCA)
ll_rows = lds_offservice.retrieve(il_contractid)

lds_offservice_detail = create n_ds
lds_offservice_detail.dataObject = "d_table_off_service_detail"
lds_offservice_detail.setTransObject(SQLCA)

lds_rates = create datastore
of_setRates(lds_rates)

for ll_rowno = 1 to ll_rows
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_rowno/ll_rows, "Calculating Off-service details...")
	end if
	
	/* Get offservice values (keys,dates and minutes) */
	ll_offservice_id 		= lds_offservice.getItemNumber(ll_rowno, "off_service_id")
	ldt_start 				= lds_offservice.getItemDatetime(ll_rowno, "start_date")
	ldt_end 					= lds_offservice.getItemDatetime(ll_rowno, "end_date")
	ll_offservice_minutes= lds_offservice.getItemNumber(ll_rowno, "off_minutes")
	ll_delta_minutes		= (f_datetime2long(ldt_end) - f_datetime2long(ldt_start)) / 60
	
	/* get offservice details */
 	ll_modify_counter = lds_offservice_detail.retrieve(ll_offservice_id)
	ll_detail_row = 0

	/* Hent rater */
	ls_filter = "datetime('" + string(ldt_start, "yyyy-mmm-dd hh:mm") + "') < periode_end and " &
					+ "datetime('" + string(ldt_end, "yyyy-mmm-dd hh:mm") + "') > periode_start"
	lds_rates.setFilter(ls_filter)
	lds_rates.Filter()
		
	/* set payment details */
	choose case lds_rates.rowCount()
		case 1  /* only one rate periode matching payment periode */
			ld_rate = lds_rates.getItemNumber(1, "rate") 
		case else  /* no rates periode matching payment periode - impossible scenario */
			MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
										"Object: n_tc_payment, function: of_calcOffserviceMonthly()")
			destroy lds_offservice
			destroy lds_offservice_detail
			destroy lds_rates
			return -1										
	end choose
	
	DO WHILE ldt_start < ldt_end
		if month(date(ldt_start)) = month(date(f_long2datetime(f_datetime2long(ldt_end) - 1))) then	
			ldt_calc = ldt_end
		else
			li_mm = month(date(ldt_start)) +1
			li_yy = year(date(ldt_start))
			if li_mm = 13 then
				li_mm = 1
				li_yy ++
			end if
			ldt_calc = datetime(date(li_yy, li_mm, 1))
		end if
		if ldt_calc > ldt_end then
			ldt_calc = ldt_end
		end if
		/* Beregn + indsæt */
		ld_daily_rate 		= ld_rate /	of_lastDayofMonth(date(ldt_start))
		ll_detail_minutes = (f_datetime2long(ldt_calc) - f_datetime2long(ldt_start)) / 60
		ld_days = ((ll_detail_minutes * ll_offservice_minutes) / ll_delta_minutes) / 1440  
		/* fill in details   modify or insertrow */
		if ll_modify_counter > ll_detail_row then
			ll_detail_row ++
		else
			ll_detail_row = lds_offservice_detail.insertRow(0)
		end if
		lds_offservice_detail.setItem(ll_detail_row, "off_service_id", ll_offservice_id)
		lds_offservice_detail.setItem(ll_detail_row, "start_date", ldt_start)
		lds_offservice_detail.setItem(ll_detail_row, "end_date", ldt_calc)
		lds_offservice_detail.setItem(ll_detail_row, "days", ld_days)
		lds_offservice_detail.setItem(ll_detail_row, "rate", ld_daily_rate)
				
		ldt_start = ldt_calc
	LOOP
	/* Cleanup if less rows now */
	if ll_detail_row < ll_modify_counter then
		for ll_idx = ll_modify_counter to ll_detail_row +1 step -1
			lds_offservice_detail.deleteRow(ll_idx)
		next
	end if
	
	if lds_offservice_detail.update() = 1 then
		commit;
	else
		rollback;
		MessageBox("Update Error", "Failure updating NTC_OFF_SERVICE_DETAIL. Object: n_tc_payment, function: of_calcOffserviceMonthly()")
		destroy lds_offservice
		destroy lds_offservice_detail
		destroy lds_rates
		return -1
	end if
next

destroy lds_offservice
destroy lds_offservice_detail
destroy lds_rates

return 1
end function

protected subroutine of_calcpaymentdailyrate ();/* This function calculates payment details when rate is defined as daily */

mt_n_datastore 	lds_rates,lds_payment_all
long 			ll_payIdx, ll_rateIdx, ll_detailIdx, ll_payments, ll_details, ll_rates
datetime 	ldt_payStart, ldt_payEnd
datetime		ldt_rateStart, ldt_rateEnd
datetime 	ldt_detailStart, ldt_detailEnd
long 			ll_paymentID,ll_count,ll_payment_status, ll_paymentstatus_next, ll_paymentid_next
string 		ls_filter
decimal{4}	ld_days, ld_rate

lds_rates = create mt_n_datastore
of_setRates(lds_rates)
lds_payment_all = create mt_n_datastore
lds_payment_all.dataobject = 'd_sq_tb_table_ntc_payment_all'
lds_payment_all.settransobject(sqlca)
lds_payment_all.retrieve(il_contractid)

ll_payments = lds_payment_all.rowCount()

for ll_payIdx = 1 to ll_payments
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_payIdx/ll_payments, "Calculating payment amounts...")
	end if
	ll_paymentID = lds_payment_all.getItemNumber(ll_payIdx, "payment_id")
	/* first delete all payment details */
	ll_payment_status = lds_payment_all.getItemNumber(ll_payIdx, "payment_status")
	if ll_payment_status < 3 then
		ll_details = ids_payment_details.retrieve(ll_paymentID)
		for ll_detailIdx = 1 to ll_details
			ids_payment_details.deleteRow(ll_detailIdx)
		next
	end if
	/* Get dates for filter and filter so Rates only have relevant records left */
	if ll_payment_status > 2 then
		SELECT MIN(PERIODE_START)
		INTO :ldt_payStart
		FROM NTC_PAYMENT_DETAIL
		WHERE PAYMENT_ID = :ll_paymentID;
	else
		ldt_payStart = lds_payment_all.getItemDatetime(ll_payIdx, "est_due_date")
	end if
	
	if ll_payIdx < ll_payments then
		
		if ll_payment_status > 2 then
			SELECT MAX(PERIODE_END)
			INTO :ldt_payEnd
			FROM NTC_PAYMENT_DETAIL
			WHERE PAYMENT_ID = :ll_paymentID;
		else
			ll_paymentstatus_next = lds_payment_all.getItemNumber(ll_payIdx + 1, "payment_status")
			if ll_paymentstatus_next < 3 then
				ldt_payEnd = lds_payment_all.getItemDatetime(ll_payIdx + 1, "est_due_date")
			else
				ll_paymentid_next = lds_payment_all.getItemNumber(ll_payIdx + 1, "payment_id")
				SELECT MIN(PERIODE_START)
				INTO :ldt_payEnd
				FROM NTC_PAYMENT_DETAIL
				WHERE PAYMENT_ID = :ll_paymentid_next;
			end if
		end if
		
	else
		ls_filter = ""
		lds_rates.setFilter(ls_filter)
		lds_rates.Filter()
		lds_rates.Sort()
		ldt_payEnd = lds_rates.getItemDatetime(lds_rates.RowCount(), "periode_end")
	end if
	ls_filter = "datetime('" + string(ldt_payStart, "yyyy-mmm-dd hh:mm") + "') < periode_end and " &
					+ "datetime('" + string(ldt_payEnd, "yyyy-mmm-dd hh:mm") + "') > periode_start"
	lds_rates.setFilter(ls_filter)
	lds_rates.Filter()
	lds_rates.Sort()


/* set payment details */
	choose case lds_rates.rowCount()
		case 0  /* no rates periode matching payment periode - impossible scenario */
			MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
							"Object: n_tc_payment, function: of_calcPaymentDailyRate()")
			rollBack;
			destroy lds_rates
			return 
		case 1  /* only one rate periode matching payment periode */
				SELECT COUNT(*)
				INTO :ll_count
				FROM NTC_PAYMENT_DETAIL
				WHERE PERIODE_START = :ldt_payStart AND PERIODE_END = :ldt_payEnd AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
				
				if ll_count < 1 then
					ll_detailIdx = ids_payment_details.InsertRow(0)
					ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
					ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_payStart)
					ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_payEnd)
					ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
					ld_days = (f_datetime2long(ldt_payEnd) - f_datetime2long(ldt_payStart)) / 86400
					ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
					ld_rate = lds_rates.getItemNumber(1, "rate") 
					ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
				end if
		case else /* payment covers several rate periods */
			ll_rates = lds_rates.Rowcount()
			for ll_rateIdx = 1 to ll_rates
				/* Set start of detail */
				if ll_rateIdx = 1 then     
					ldt_detailStart = ldt_payStart
				else
					ldt_detailStart = lds_rates.getItemDatetime(ll_rateIdx, "periode_start")
				end if
				/* Set end of detail */
				if ll_rateIdx = ll_rates then   
					ldt_detailEnd = ldt_payEnd
				else
					ldt_detailEnd = lds_rates.getItemDatetime(ll_rateIdx, "periode_end")
				end if
				SELECT COUNT(*)
				INTO :ll_count
				FROM NTC_PAYMENT_DETAIL
				WHERE PERIODE_START = :ldt_detailStart AND PERIODE_END = :ldt_detailEnd AND PAYMENT_ID IN (SELECT PAYMENT_ID FROM NTC_PAYMENT WHERE CONTRACT_ID = :il_contractID);
				
				if ll_count < 1 then
					ll_detailIdx = ids_payment_details.InsertRow(0)
					ids_payment_details.setItem( ll_detailIdx, "payment_id", ll_paymentID)
					ids_payment_details.setItem( ll_detailIdx, "periode_start", ldt_detailStart)
					ids_payment_details.setItem( ll_detailIdx, "periode_end", ldt_detailEnd)
					ids_payment_details.setItem( ll_detailIdx, "monthly_rate", 0)
					ld_days = (f_datetime2long(ldt_detailEnd) - f_datetime2long(ldt_detailStart)) / 86400
					ids_payment_details.setItem( ll_detailIdx, "quantity", ld_days)
					ld_rate = lds_rates.getItemNumber(ll_rateIdx, "rate")
					ids_payment_details.setItem( ll_detailIdx, "rate", ld_rate)
				end if
			next					
	end choose
	if ids_payment_details.update() = 1 then
		commit; 
	else
		MessageBox("Update Error", "Update of payment details went wrong in function: of_calcPaymentDailyRate()~n~r" +&
							"Object: n_tc_payment, function: of_calcPaymentDailyRate()")
		rollBack;
		destroy lds_rates
		return 
	end if

next

destroy lds_rates
destroy lds_payment_all
end subroutine

protected function integer of_createdatastores ();ids_payments = CREATE n_ds
ids_payments.dataObject = "d_table_ntc_payment"
ids_payments.setTransObject(SQLCA)

ids_payment_details = CREATE n_ds
ids_payment_details.dataObject = "d_table_ntc_payment_detail"
ids_payment_details.setTransObject(SQLCA)

return 1
end function

protected subroutine of_calccommission ();/* This function calculates both address commission and broker commission
	Broker commission is only calculated if commission is marked as set off-in hire 
*/

long			ll_rows, ll_rowno
decimal{2}	ld_adr_pct, ld_broker_pct, ld_broker_per_day
decimal{2}	ld_adr_comm, ld_broker_comm
decimal{2}	ld_hire, ld_offservice
decimal{4}	ld_hire_days, ld_offservice_days
datetime		ldt_start, ldt_end
long 			ll_paymentID

ll_rows = ids_payments.rowCount()
if ll_rows < 1 then return

SELECT isnull(NTC_TC_CONTRACT.ADR_COMM,0)  
	INTO :ld_adr_pct  
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractid ;
	
SELECT isnull(sum(NTC_CONT_BROKER_COMM.BROKER_COMM),0)  
	INTO :ld_broker_pct  
	FROM NTC_CONT_BROKER_COMM  
	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contractID ) AND  
			( NTC_CONT_BROKER_COMM.COMM_SET_OFF = 1 ) AND
			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 0);

SELECT isnull(sum(NTC_CONT_BROKER_COMM.BROKER_COMM),0)  
	INTO :ld_broker_per_day  
	FROM NTC_CONT_BROKER_COMM  
	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contractID ) AND  
			( NTC_CONT_BROKER_COMM.COMM_SET_OFF = 1 ) AND
			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 1);

for ll_rowno = 1 to ll_rows
	/* Progress bar */
	if isValid(iw_progress) then
		iw_progress.wf_progress(ll_rowno/ll_rows, "Calculating Address and Broker Commission...")
	end if

	ll_paymentID = ids_payments.getItemNumber(ll_rowno, "payment_id")
	
	SELECT isNull(sum(NTC_PAYMENT_DETAIL.QUANTITY * NTC_PAYMENT_DETAIL.RATE),0),
			min(NTC_PAYMENT_DETAIL.PERIODE_START),
			max(NTC_PAYMENT_DETAIL.PERIODE_END)
		INTO :ld_hire,
			:ldt_start,
			:ldt_end
		FROM NTC_PAYMENT_DETAIL  
		WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID = :ll_paymentID   ;
		
	SELECT isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS * NTC_OFF_SERVICE_DETAIL.RATE),0),
			isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS),0)
		INTO :ld_offservice,
			:ld_offservice_days
		FROM NTC_OFF_SERVICE, NTC_OFF_SERVICE_DETAIL  
		WHERE ( NTC_OFF_SERVICE_DETAIL.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID ) and  
				(( NTC_OFF_SERVICE.PAYMENT_ID = :ll_paymentID ));

	ld_hire_days = timedifference(ldt_start, ldt_end)/1440
	if isnull(ld_hire_days) then ld_hire_days = 0
	ld_adr_comm 	= ((ld_hire - ld_offservice) / 100) * ld_adr_pct
	ld_broker_comm = (((ld_hire - ld_offservice) / 100) * ld_broker_pct) &
						+ ((ld_hire_days - ld_offservice_days) * ld_broker_per_day)
	if isnull(ld_broker_comm) then ld_broker_comm = 0
	ids_payments.setItem(ll_rowno, "adr_comm", ld_adr_comm)
	ids_payments.setItem(ll_rowno, "broker_commission", ld_broker_comm)
	ids_payments.setItem(ll_rowno, "adr_comm_pct", ld_adr_pct)
	ids_payments.setItem(ll_rowno, "broker_commission_pct", ld_broker_pct)
	ids_payments.setItem(ll_rowno, "broker_commission_per_day", ld_broker_per_day)	
	
next
if ids_payments.Update() = 1 then
	COMMIT; 
else
	MessageBox("Update Error", "Failure updating NTC_PAYMENT from of_calcComission(), Object: n_tc_payment")
	ROLLBACK;
end if

return
	
end subroutine

public subroutine of_offservicemodified (long al_contractid, long al_paymentid[]);/* This function is called from Operations Off Services
	when off-service modified 
	If one ore more payment IDs also are given as parameter
	only the given paymentIDs are recalculated. 
	Otherwise all paymentIDs are recalculated.
*/

boolean			lb_monthlyRate
str_progress 	lstr_parm

il_contractID = al_contractID

if UpperBound(al_paymentid[]) < 1 then
	return
end if
if isValid(ids_payments) then ids_payments.reset()

ids_payments.dataObject = "d_offservice_payment"
ids_payments.setTransObject(SQLCA)

if ids_payments.retrieve(il_contractID, al_paymentID) < 1 then
	return
end if

SELECT  MONTHLY_RATE
    INTO :lb_monthlyRate  
    FROM NTC_TC_CONTRACT  
	 WHERE CONTRACT_ID = :al_contractid;

if SQLCA.SQLCode = -1 then
	rollback;
	MessageBox("Select Error", "Error selecting from NTC_CONTRACT in Object: n_tc_payment, function: of_offservicemodified()")
else
	commit;   
end if

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Create/modify payments"
openwithparm(iw_progress, lstr_parm, "w_progress_no_cancel")

/* Calculate off-services details */
if lb_monthlyRate then
	of_calcOffserviceMonthlyRate()
else
	of_calcOffserviceDailyRate()
end if	

/*	calculate commissions */ 
of_calcCommission()

/* calculate Payment Balance */ 
of_calcPaymentBalance() 
commit;

/* Closes progress window */
if isValid(iw_progress) then close(iw_progress)

return
end subroutine

public function integer of_calcoffservicedependentcontractexp (decimal ad_rate, boolean ab_monthly, datetime adt_start, datetime adt_end, ref decimal ad_amount);/* Calculates off service dependent contract expenses based on
		rate
		daily or monthly rate
		startdate (Off Service)
		end date (Off Service)
	and returns the result to calling function as a reference varaible
	
	If an error occures the function returns -1*/

long			ll_payIdx, ll_expIdx
datetime		ldt_startDate, ldt_CalcDate
decimal {2}	ld_expense
decimal {4} ld_days
integer		li_mm, li_yy


/* Daily Rate */
if NOT ab_monthly then    
	ld_days = (f_datetime2long(adt_End) - f_datetime2long(adt_Start)) / 86400
	ld_expense = ld_days * ad_rate
	ad_amount = ld_expense
	return 1
end if

/* Monthly Rate */
ldt_startDate = adt_start
li_mm 	= month(date(ldt_startDate)) +1
li_yy		= year(date(ldt_startDAte))
if li_mm > 12 then
	li_mm = 1
	li_yy ++
end if
ldt_CalcDate = datetime(date(li_yy, li_mm, 1), time(0,0,0))
ad_amount = 0

do while ldt_CalcDate < adt_end
	ld_days = (f_datetime2long(ldt_calcDate) - f_datetime2long(ldt_startDate)) / 86400
	ld_expense = ld_days * (ad_rate / of_lastdayofmonth( date(ldt_startDate )))
	ad_amount += ld_expense

	ldt_startDate = ldt_calcDate
	li_mm 	= month(date(ldt_startDate)) +1
	li_yy		= year(date(ldt_startDate))
	if li_mm > 12 then
		li_mm = 1
		li_yy ++
	end if
	ldt_CalcDate = datetime(date(li_yy, li_mm, 1), time(0,0,0))
loop

ld_days = (f_datetime2long(adt_end) - f_datetime2long(ldt_startDate)) / 86400
ld_expense = ld_days * (ad_rate / of_lastdayofmonth( date(ldt_startDate )))
ad_amount += ld_expense

return 1



end function

public function integer of_dependentcontractexpensesmodified (long al_contractid, long al_ops_off_service_id);/* This function recalculates Off Service dependent Contract Expenses.

	If al_ops_off_service_id = NULL then 
		the function is called from modifying the contract
		retrieve all off services that are not already transferred to event coda
		delete any items in dependant off service table and recreate them
	else 
		called from Off Service
		retrieve only off services relevant
		create new items as they are deleted when modify of off service
		
	First see if there at all are any contract expenses that are dependant
	if not just delete 
*/

n_ds 			lds_contractExpenses									/* Contract expenses set-off in hire - argument = contract_id */
n_ds			lds_offServices											/* Off Services - argument = ops_off_service_id */ 
n_ds			lds_offServiceDependentContractExpenses		/* */
long 			ll_erows, ll_erow, ll_ofrows, ll_ofrow, ll_dependrow
datetime 	ldt_start, ldt_end
long 			ll_offServiceID, ll_expTypeID, ll_offservice_minutes, ll_total_minutes
decimal{2}	ld_rate, ld_amount
boolean 		lb_monthly

lds_contractexpenses = create n_ds
lds_contractExpenses.dataObject = "d_tc_dependent_contract_expenses"
lds_contractexpenses.setTransObject (sqlca)

lds_offServiceDependentContractExpenses = create n_ds
lds_offServiceDependentContractExpenses.dataObject = "d_table_ntc_offservice_dependent_exp"
lds_offServiceDependentContractExpenses.setTransObject(sqlca)

lds_offServices = create n_ds

if not isNull(al_ops_off_service_id) then    
	/* Called from operations - Off Service */
	lds_offServices.dataObject = "d_tc_offservice_by_opsid"
	lds_offServices.setTransObject(sqlca)

	ll_erows = lds_contractExpenses.retrieve(al_contractid)
	//if ll_erows < 1 then goto cleanup
	
	ll_ofrows = lds_offServices.retrieve(al_ops_off_service_id, al_contractid)
	//if ll_ofrows < 1 then goto cleanup
	
	for ll_erow = 1 to ll_erows
		ll_expTypeID = lds_contractExpenses.getItemNumber(ll_erow, "exp_type_id")
		ld_rate = lds_contractExpenses.getItemDecimal(ll_erow, "expense_amount")
		if lds_contractExpenses.getItemNumber(ll_erow, "expense_monthly") = 1 then
			lb_monthly = true
		else
			lb_monthly = false
		end if
		for ll_ofrow = 1 to ll_ofrows
			ll_offServiceID = lds_offServices.getItemNumber(ll_ofrow, "off_service_id")
			ldt_start = lds_offServices.getItemDatetime(ll_ofrow, "start_date")
			ldt_end = lds_offServices.getItemDatetime(ll_ofrow, "end_date")
			ll_offservice_minutes = (lds_offServices.getItemNumber(ll_ofrow, "hours")*60) + lds_offServices.getItemNumber(ll_ofrow, "minutes")
			if of_calcoffservicedependentcontractexp( ld_rate, lb_monthly, ldt_start, ldt_end, ld_amount) = -1 then
				MessageBox("Calculation Error", "Calculation of Off Service Dependent Contract Expenses when wrong")
				goto cleanup
			end if
			/* reduce amount if minutes not equal total periode */
			 ll_total_minutes = (f_datetime2long(ldt_end) - f_datetime2long(ldt_start))/60
			if ll_total_minutes <> ll_offservice_minutes then
				ld_amount =( ld_amount / ll_total_minutes) * ll_offservice_minutes
			end if
			ll_dependrow = lds_offServiceDependentContractExpenses.insertRow(0)
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "exp_type_id", ll_expTypeID)
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "off_service_id", ll_offServiceID )
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "deductable_amount", ld_amount )
		next
	next
else
	/* Called from TC Contract  */
	lds_offServices.dataObject = "d_tc_offservice_by_contract"
	lds_offServices.setTransObject(sqlca)

	/* 	first of all se if there already is expenses, if so delete them first
		this is to easyer handle all kind of changes to TC Contract Contract Expenses */
	ll_erows = lds_offServiceDependentContractExpenses.retrieve(al_contractID)
	for ll_erow = 1 to ll_erows
		lds_offServiceDependentContractExpenses.deleteRow(1)
	next
	
	/* Now start to create/recreate the Off Service Dependent Contract Expenses */
	ll_erows = lds_contractExpenses.retrieve(al_contractID)
	//if ll_erows < 1 then goto cleanup
	
	ll_ofrows = lds_offServices.retrieve(al_contractID)
	//if ll_ofrows < 1 then goto cleanup
	
	for ll_erow = 1 to ll_erows
		ll_expTypeID = lds_contractExpenses.getItemNumber(ll_erow, "exp_type_id")
		ld_rate = lds_contractExpenses.getItemDecimal(ll_erow, "expense_amount")
		if lds_contractExpenses.getItemNumber(ll_erow, "expense_monthly") = 1 then
			lb_monthly = true
		else
			lb_monthly = false
		end if
		for ll_ofrow = 1 to ll_ofrows
			ll_offServiceID = lds_offServices.getItemNumber(ll_ofrow, "off_service_id")
			ldt_start = lds_offServices.getItemDatetime(ll_ofrow, "start_date")
			ldt_end = lds_offServices.getItemDatetime(ll_ofrow, "end_date")
			ll_offservice_minutes = (lds_offServices.getItemNumber(ll_ofrow, "hours")*60) + lds_offServices.getItemNumber(ll_ofrow, "minutes")
			if of_calcoffservicedependentcontractexp( ld_rate, lb_monthly, ldt_start, ldt_end, ld_amount) = -1 then
				MessageBox("Calculation Error", "Calculation of Off Service Dependent Contract Expenses when wrong")
				goto cleanup
			end if
			/* reduce amount if minutes not equal total periode */
			 ll_total_minutes = (f_datetime2long(ldt_end) - f_datetime2long(ldt_start))/60
			if ll_total_minutes <> ll_offservice_minutes then
				ld_amount =( ld_amount / ll_total_minutes) * ll_offservice_minutes
			end if
			ll_dependrow = lds_offServiceDependentContractExpenses.insertRow(0)
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "exp_type_id", ll_expTypeID)
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "off_service_id", ll_offServiceID )
			lds_offServiceDependentContractExpenses.setItem(ll_dependrow, "deductable_amount", ld_amount )
		next
	next
end if
	

if lds_offServiceDependentContractExpenses.Update() <> 1 then
	rollback;
	MessageBox("Update Error", "Update of Off Service Dependent Contract Expenses when wrong")
end if
	
cleanup:
destroy lds_contractExpenses
destroy lds_offServices
destroy lds_offServiceDependentContractExpenses
return 1
end function

public function integer of_deliverybunkermodified (long ai_bpdetailid, decimal ad_bunkervalue, ref long ad_affected_paymentid[2]);/* This function handles the scenario where there has been settled a bunker on derivery
	on a hire statement, and where the user is modifying the bunker price/quantity afterwords.
	In this case the bunker on delivery is moved to the next unsetled payment, and the already 
	settled bunker on statement is regulated via port expenses as already payed bunker */
n_ds 			lds_portexp
string			ls_mySQL
long			ll_paymentID, ll_newPaymentID, ll_contractID
decimal{6}	ld_exrate
long			ll_row

lds_portexp = CREATE n_ds
lds_portexp.dataobject = "d_table_ntc_port_exp"
lds_portexp.setTransObject(SQLCA)

SELECT PAYMENT_ID, EX_RATE_TO_TC  
   INTO :ll_paymentID, :ld_exrate  
   FROM BP_DETAILS  
   WHERE BP_DETAILS.BPN = :ai_bpDetailID ;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Error selecting from BP_DETAILS. n_tc_payments.of_deliveryBunkerModified()")
	rollBack;
	return -1
end if	
commit;

SELECT CONTRACT_ID
	INTO :ll_contractID
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID = :ll_paymentID ;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Error selecting from NTC_PAYMENT. n_tc_payments.of_deliveryBunkerModified()")
	rollBack;
	return -1
end if	
commit;

ll_newPaymentID = of_getNextUnpaid(ll_contractID, ll_paymentID)	
	
UPDATE BP_DETAILS
	SET PAYMENT_ID = :ll_newPaymentID  
   WHERE BP_DETAILS.BPN = :ai_bpDetailID ;
if SQLCA.SQLCode <> 0 then
	MessageBox("Update Error", "Error updating BP_DETAILS. n_tc_payments.of_deliveryBunkerModified()")
	rollBack;
	return -1
end if	
commit;

ll_row = lds_portexp.InsertRow(0)
lds_portexp.setItem(ll_row, "payment_id", ll_paymentID )
lds_portexp.setItem(ll_row, "curr_code", "USD")
lds_portexp.setItem(ll_row, "exp_desc", "Bunker Lumpsum on Delivery")
lds_portexp.setItem(ll_row, "exp_amount", ad_bunkervalue)
lds_portexp.setItem(ll_row, "ex_rate_tc", ld_exrate)
lds_portexp.setItem(ll_row, "exp_for_oa", 0)
lds_portexp.setItem(ll_row, "use_in_vas", 0)

ll_row = lds_portexp.InsertRow(0)
lds_portexp.setItem(ll_row, "payment_id", ll_newPaymentID )
lds_portexp.setItem(ll_row, "curr_code", "USD")
lds_portexp.setItem(ll_row, "exp_desc", "Bunker Already Paid")
lds_portexp.setItem(ll_row, "exp_amount", ad_bunkervalue)
lds_portexp.setItem(ll_row, "ex_rate_tc", ld_exrate)
lds_portexp.setItem(ll_row, "exp_for_oa", 1)
lds_portexp.setItem(ll_row, "use_in_vas", 0)

if lds_portexp.Update() <> 1 then
	MessageBox("Update Error", "Error updating NTC_PORT_EXP. n_tc_payments.of_deliveryBunkerModified()")
	rollBack;
	return -1
end if	
commit;

/* THis code is a work around as it was not possible to get the stored procudures 
	committed the right way in nested transactions.
	Array is returned and the update is performed elsewhere n_bunker purchase
	of_update*/
ad_affected_paymentid[1]= ll_paymentID
ad_affected_paymentid[2]=ll_newPaymentID
//ls_mySQL = "sp_paymentBalance " + string(ll_paymentID)
//EXECUTE IMMEDIATE :ls_mySQL;
//commit;
//ls_mySQL = "sp_paymentBalance " + string(ll_newPaymentID)
//EXECUTE IMMEDIATE :ls_mySQL;
//commit;

if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if
if isValid(w_tc_contract) then
	w_tc_contract.PostEvent("ue_refresh")
end if

return 1
end function

public subroutine documentation ();/*******************************************************************************************
   ObjectName: n_tc_payment
   <OBJECT> 
		Ancestor object that contains shared functionality in the
		nTC-HIRE module. 
	</OBJECT>
	<DESC>  </DESC>
	<USAGE>Ancester</USAGE>
	<ALSO> 
		children:
		n_interval_payment_delivery_time
		n_half_monthly_payment_delivery_time
		n_monthly_payment_delivery_time
		n_monthly_payment_fixed_time
	</ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		13/07/10		CR2048		AGL   		Included Bunker expense in of_movedeletedlinks().
		16/12/10		CR2211		RMO   		Both delivery and redelivery moved before previous dates.
		09/04/15		CR3584		XSZ004		Get first new/draft payment.
		29/06/15		CR3956      KSH092		Function offservicemodified when upperbound(al_paymentid[]) < 1 then return
		13/06/16     CR4357      KSH092		Fix bug
	</HISTORY>
********************************************************************************************/
end subroutine

private function integer _revert_transaction (long al_paymentid);/********************************************************************
   _revert_transaction
   <DESC> revert transaction  </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> this would be called from of_redeliverymoved </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03/04/2012 M5-4         CKT012             First Version
   </HISTORY>
********************************************************************/

n_ds lds_apost,lds_bpost
long ll_no_of_arows,ll_row,ll_no_of_brows,ll_arow,ll_brow,ll_null,ll_new_apost
string ls_null
datetime ldt_null
double ld_transkey, ld_new_transkey
decimal{0}	ld_local, ld_DKK, ld_USD

//set null
setnull(ll_null)
setnull(ls_null)
setnull(ldt_null)

/* Change transactions sent to CODA - Revert them */
lds_apost = CREATE n_ds
lds_apost.dataObject = "d_coda_revert_hire_apost_redel_moved"
lds_apost.setTransObject(SQLCA)

lds_bpost = CREATE n_ds
lds_bpost.dataObject = "d_coda_revert_hire_bpost_redel_moved"
lds_bpost.setTransObject(SQLCA)

ll_no_of_arows = lds_apost.retrieve(al_paymentID, il_contractID)   
if ll_no_of_arows > 0 then
	for ll_arow = 1 to ll_no_of_arows
		ld_local = 0
		ld_DKK = 0
		ld_USD = 0
		ld_transkey = lds_apost.getItemNumber(ll_arow, "trans_key")
		ll_no_of_brows = lds_bpost.retrieve(ld_transkey)
		if ll_no_of_brows > 0 then
			/* run create through B-posts copy and modify them */
			lds_bpost.rowsCopy(1, ll_no_of_brows, primary!, lds_bpost, 1, primary!)
			for ll_brow = 1 to ll_no_of_brows
				if lds_bpost.getItemNumber(ll_brow, "f29_debitcredit") = 160 then
					lds_bpost.setItem(ll_brow, "f29_debitcredit", 161)
				else
					lds_bpost.setItem(ll_brow, "f29_debitcredit", 160)
				end if
				lds_bpost.setItem(ll_brow, "f03_yr", year(today()))
				lds_bpost.setItem(ll_brow, "f04_period", month(Today()))
				lds_bpost.setItem(ll_brow, "f08_doclinenum_b", ll_brow +1)
				if lds_bpost.getItemNumber(ll_brow, "f29_debitcredit") = 160 then
					ld_local += lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					ld_DKK 	+= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					ld_USD	+= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				else
					ld_local -= lds_bpost.getItemNumber(ll_brow, "f30_valuedoc")
					ld_DKK 	-= lds_bpost.getItemNumber(ll_brow, "f32_valuehome")
					ld_USD	-= lds_bpost.getItemNumber(ll_brow, "f34_vatamo_or_valdual")
				end if
			next
			lds_apost.setItem(ll_arow, "payment_id", ll_null)  /* must be cleared before copy */
			ll_new_apost = lds_apost.InsertRow(0)
			lds_apost.rowsCopy(ll_arow, ll_arow, primary!, lds_apost, ll_new_apost, primary!)
			lds_apost.deleterow(ll_new_apost + 1)
			lds_apost.setItem(ll_new_apost, "f41_linedesr", "Revert T/C Hire")
			lds_apost.setItem(ll_new_apost, "trans_key", ll_null)
			lds_apost.setItem(ll_new_apost, "f07_docnum", ls_null)
			lds_apost.setItem(ll_new_apost, "file_date", ldt_null)
			lds_apost.setItem(ll_new_apost, "file_user", ls_null)
			lds_apost.setItem(ll_new_apost, "file_name", ls_null)
			if ld_local >= 0 then
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 161)
			else
				lds_apost.setItem(ll_new_apost, "f29_debitcredit", 160)
			end if
			lds_apost.setItem(ll_new_apost, "f03_yr", year(today()))
			lds_apost.setItem(ll_new_apost, "f04_period", month(Today()))
			lds_apost.setItem(ll_new_apost, "f30_valuedoc", abs(ld_local))
			lds_apost.setItem(ll_new_apost, "f32_valuehome", abs(ld_DKK))
			lds_apost.setItem(ll_new_apost, "f34_vatamo_or_valdual", abs(ld_USD))
			if lds_apost.Update(true, false) <> 1 then return -1
			ld_new_transkey = lds_apost.getItemNumber(ll_new_apost, "trans_key")
			for ll_brow = 1 to ll_no_of_brows
				lds_bpost.setItem(ll_brow, "trans_key", ld_new_transkey)
			next
			if lds_bpost.Update(true, false) = 1 then
				lds_apost.resetUpdate()
				lds_bpost.resetUpdate()
			else
				destroy lds_bpost
				destroy lds_apost
				return c#return.Failure 
			end if

		end if	
	next
end if

destroy lds_bpost
destroy lds_apost
return c#return.Success
end function

public function long of_get_firstnewordraft (long al_contract_id);/********************************************************************
   of_get_firstnewordraft
   <DESC> Get first new/draft payment. </DESC>
   <RETURN>
		long
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS> al_contract_id </ARGS>
   <USAGE> </USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		09/04/15		CR3854		XSZ004		First Version.
   </HISTORY>
********************************************************************/

long ll_payment_id

if ids_payments.retrieve(al_contract_id, 3) > 0 then 
	ll_payment_id = ids_payments.getitemnumber(1, "payment_id")
else
	ll_payment_id = 0
end if

return ll_payment_id
end function

public function boolean of_isleapyear (date ad_source);int li_year
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

public function integer of_lastdayofmonth (date ad_source);//////////////////////////////////////////////////////////////////////////////
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

public function integer of_selectcount (datetime adt_due_date, long al_contract_id);/********************************************************************
   of_selectcount( /*datetime adt_due_date,integer al_contract_id */)
   <DESC>
	  select count
	</DESC>
   <RETURN>	integer:
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-05-2015 CR3926       KSH092       First Version
		
   </HISTORY>
********************************************************************/

long ll_count

adt_due_date = datetime(date(adt_due_date))
SELECT count(*) 
INTO :ll_count
FROM NTC_PAYMENT
WHERE CONVERT(DATE,EST_DUE_DATE) = :adt_due_date AND CONTRACT_ID = :al_contract_id AND PAYMENT_STATUS > 2;

return ll_count
end function

public function long of_getlastunpaid (long al_contract_id, long al_payment_id);/*
Desc.:		This function gets the last un-settled Payment ID for the argument passed (Contract ID). 
				This is used to moved attached expenses from a TC Contract to the last payment.
Arguments:	al_contract_id
Returns: 	The last un-settled Payment ID for the Contract
           else
				show message and return -1	
*/
long ll_count, ll_row, ll_rows
string ls_find

ll_rows = ids_payments.retrieve(al_contract_id, 3)

ls_find = "payment_id = " + string(al_payment_id)
ll_row = ids_payments.find(ls_find, 1, ll_rows)

choose case ll_row
	case 0 //Current payment don't have status < 3. Return 1st payment_id
		Return ids_payments.getitemnumber(1, "payment_id")
	case ll_rows //last row - no later payments exists for the contract
		
		SELECT COUNT(*)
		INTO :ll_count
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID > :al_payment_id AND CONTRACT_ID = :al_contract_id;
		if ll_count > 0 then
			MessageBox("Validation","You cannot move the selected item to Last hire statement, because there are no other hire statements in status New or Draft.~n~r~n~r"&
						+"Contact Finance to unsettle and Operations to set the hire statement to Draft.", Information!)
		else
			MessageBox("Validation","You cannot move the selected item to Last hire statement, because you have already selected the Last hire statement.")
		end if
			
							
		Return -1
	case else //get (and return) the payment ID for the last row
		
		return ids_payments.getitemnumber(ids_payments.rowcount(),"payment_id")

end choose

end function

on n_tc_payment.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tc_payment.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_createDatastores()
end event

event destructor;of_destroyDatastores()
end event

