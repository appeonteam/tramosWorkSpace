$PBExportHeader$n_tc_settle_payment.sru
$PBExportComments$This object is used to control the workflow around settlement of payments
forward
global type n_tc_settle_payment from mt_n_nonvisualobject
end type
end forward

global type n_tc_settle_payment from mt_n_nonvisualobject
end type
global n_tc_settle_payment n_tc_settle_payment

type variables
n_ds		ids_data
long 		il_paymentid

integer ii_SETDRAFT = 1 //set draft
integer ii_UNSETTLE = 2 //unsettle 
end variables

forward prototypes
private function integer of_codareceivabletransaction (datetime adt_receive_date)
private function integer of_settlecreditpayable ()
public function integer of_lumpsumpayment (long al_paymentid)
private function integer of_settlepayable ()
public function integer of_settletransferextra (decimal ad_amount)
private function integer of_settlereceivable (ref s_settle_payment astr_parm)
private function integer of_settlecreditreceivable (ref s_settle_payment astr_parm)
private subroutine of_setpaymentexrate ()
public function integer of_settlepayment (long al_paymentid)
private function boolean of_anycodaitems (long al_paymentid)
private function integer of_cmsreceivabletransaction (decimal ad_settle_amount, datetime adt_receive_date)
private function integer of_settletransfer (decimal ad_transfer_amount)
public function integer of_checkopsasetup (long al_paymentid)
private function integer of_codapaymenttransaction ()
private function integer of_cmspaymenttransaction (decimal ad_settle_amount, datetime adt_receive_date)
public subroutine documentation ()
public function integer of_lumpsumreceivable (long al_paymentid)
public function integer of_unsettlepayment (long al_paymentid, integer ai_flag)
public function integer of_unsettlepayment_final (long al_paymentid, integer ai_flag)
end prototypes

private function integer of_codareceivabletransaction (datetime adt_receive_date);/* Generate CODA transaction  
	return codes  -1 an error
						1 OK
*/

integer 								li_rc = 0
s_transaction_input				lstr_transValues
u_transaction_hire_rec_coda	lnv_CODAtransaction


lstr_transValues.vessel_no = ids_data.getItemNumber(1, "vessel_nr")
lstr_transValues.coda_or_cms = true   /* = CODA */
lstr_transValues.settle_tc_payment = ids_data
lstr_transValues.doc_date = adt_receive_date

lnv_CODAtransaction = create u_transaction_hire_rec_coda
li_rc = lnv_CODAtransaction.of_generate_transaction(lstr_transValues)
destroy lnv_CODAtransaction



/* OK but settle canceled */
if li_rc = -1 then return -1

return 1
end function

private function integer of_settlecreditpayable ();/* ****************************************************** */
/* THIS IS A FULL SETTLEMENT WHERE BOTH CMS               */
/* AND CODA TRANSACTIONS ARE GENERATED							 */
/* ONLY DIFFERENCE IS THAT IT IS REVERSED	!!!!!!!!!!		 */
/* ****************************************************** */
s_settle_payment	lstr_parm
integer 				li_rc

/* !!! This function is not in use anymore ref. to change request #1082 */
messageBox("Warning", "This function is not in use any more. Please contact system admin~r~n~r~nn_tc_settle_payment.of_settleCreditPayable()")

lstr_parm.payment_id = il_paymentid
lstr_parm.settle_amount = ids_data.getItemDecimal(1, "payment_balance")
lstr_parm.transfer = false
lstr_parm.partpaid = false
lstr_parm.receive_date = datetime(today())
	
li_rc = MessageBox("Settle amount", "Settle Payment equal to: "+string(lstr_parm.settle_amount,"#,##0.00"),Question!, YesNo!,2)

if li_rc = 2 then return 0

/* Ready to settle amount */
/* set payment status to "Paid" (5) */
ids_data.setItem(1, "payment_status", 5)
/* set transfer to CODA = true */
ids_data.setItem(1, "trans_to_coda", 1)
/* set exchange rate first time a part-payment is payed */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if
/* Generate CODA Receivable Transaction */
if of_CODApaymentTransaction() = -1 then return -1
/* Generate CMS Payment Transaction */
return of_CMSreceivableTransaction(lstr_parm.settle_amount * -1, lstr_parm.receive_date) 

end function

public function integer of_lumpsumpayment (long al_paymentid);/* Settle lumpsum payment */
/* return codes  -1 an error
						0 OK but settle canceled
						1 OK
*/

integer 								li_rc = 0
decimal{2}							ld_settle_amount	
n_ds									lds_settled
string									ls_mySQL
datetime								ldt_null; setNull(ldt_null)  //date not used when lumpsum

il_paymentid = al_paymentid

if ids_data.retrieve(il_paymentid) <> 1 then 
	MessageBox("Retrieval Error", "Could not retrieve payment Object: n_tc_settle_payment, function: of_settlePAyment()")
	return -1
end if

/* Check account numbers */
if ids_data.getItemNumber(1, "income") = 0 then  
	if isNull(ids_data.getItemString(1, "tcowners_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "tcowners_nom_acc_nr")) <> 5 then
		MessageBox("Error", "TC Owner Nominal Account number not correct. Please correct and try again")
		return -1
	end if
else
	if isNull(ids_data.getItemString(1, "chart_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "chart_nom_acc_nr")) <> 5 then
		MessageBox("Error", "Charterer Nominal Account number not correct. Please correct and try again")
		return -1
	end if
end if
	
openwithparm(w_payable_lumpsum, ids_data.getItemDecimal(1, "payment_balance"))
ld_settle_amount = message.doubleParm

if isNull(ld_settle_amount) then 
	return 0
end if

/* set exchange rate first time a lumpsum is payed */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if


/* Generate CMS Transaction */
if of_CMSpaymentTransaction(ld_settle_amount, ldt_null) = -1 then return -1 

if ids_data.update() = 1 then
	commit;
	/* Update payment balance - Current  */
	ls_mySQL = "sp_paymentBalance " + string(ids_data.getItemNumber(1, "payment_id"))
	EXECUTE IMMEDIATE :ls_mySQL;
	if SQLCA.SQLCode = 0 then
		commit;
	else
		rollback;
		MessageBox("Update Error", "Update of paymentbalance went wrong. Please contact system administrator. Function: n_tc_payment.of_lumpsumpayment()")
		return -1
	end if
else
	rollback;
	MessageBox("Update Error", "Update of payment went wrong. Please contact system administrator. Function: n_tc_payment.of_lumpsumpayment()")
	return -1
end if

return 1
end function

private function integer of_settlepayable ();/* return codes  -1 an error
						0 OK but settle canceled
						1 OK
*/

s_settle_payment	lstr_parm

lstr_parm.payment_id 	= il_paymentid
lstr_parm.settle_amount	= ids_data.getItemDecimal(1, "payment_balance")
lstr_parm.transfer 		= false
lstr_parm.partpaid 		= false
lstr_parm.postCODA 		= false
lstr_parm.duedate			= ids_data.getItemDatetime(1, "est_due_date")

openwithparm(w_payable_partpaid, lstr_parm)
lstr_parm = message.powerObjectParm

if not isvalid(lstr_parm) then
	return 0
else
	if lstr_parm.li_settle = 0  or isnull(lstr_parm.li_settle) then /* settle cancel */
		return 0
	end if
end if


if lstr_parm.transfer then
	/* Generate CODA Transaction */
	if of_CODApaymentTransaction() = -1 then return -1
	/* set payment status to "Paid" (5) */
	ids_data.setItem(1, "payment_status", 5)
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	return of_settleTransfer(ids_data.getItemDecimal(1, "payment_balance"))
end if	

if lstr_parm.partpaid then
	/* set payment status to "Part-Paid" (4). But only if not already set to Paid */
	if ids_data.getItemNumber(1, "payment_status") < 5 then
		ids_data.setItem(1, "payment_status", 4)
	end if
	/* set exchange rate first time a part-payment is payed */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
	/* Generate CMS Transaction */
	return of_CMSpaymentTransaction(lstr_parm.settle_amount, lstr_parm.receive_date ) 
end if

if lstr_parm.postCODA then
	/* set payment status to "Part-Paid" (4). But only if not already set to Paid */
	if ids_data.getItemNumber(1, "payment_status") < 5 then
		ids_data.setItem(1, "payment_status", 4)
	end if
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	return of_CODApaymentTransaction()
end if	

/* ****************************************************** */
/* OTHERWISE IT IS A FULL SETTLEMENT WHERE BOTH CMS       */
/* AND CODA TRANSACTIONS ARE GENERATED							 */
/* ****************************************************** */

/* set payment status to "Paid" (5) */
ids_data.setItem(1, "payment_status", 5)
/* set transfer to CODA = true */
ids_data.setItem(1, "trans_to_coda", 1)
/* set exchange rate first time a part-payment is payed */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if
/* Generate CODA Transaction */
if of_CODApaymentTransaction() = -1 then return -1
/* Generate CMS Transaction */
return of_CMSpaymentTransaction(lstr_parm.settle_amount, lstr_parm.receive_date ) 

end function

public function integer of_settletransferextra (decimal ad_amount);/* This function is for transfer of the balance to next statement if
	received amount is greater than balance 
*/

decimal{2}		ld_transfer_amount
string 			ls_mySQL
n_tc_payment	lnv_payment
long				ll_next_payment
string 			ls_comment

lnv_payment = create n_tc_payment
ll_next_payment = lnv_payment.of_getNextUnpaid(ids_data.getItemNumber(1, "contract_id"), ids_data.getItemNumber(1, "payment_id"))
destroy lNV_payment

/* Check if last payment, if so no transfer necessary */
if (ll_next_payment = -1) or &
	(ids_data.getItemNumber(1, "payment_id") = ll_next_payment) then return 1

ld_transfer_amount = ids_data.getItemDecimal(1, "transfer_to_next")
if isNull(ld_transfer_amount) then ld_transfer_amount = 0
ld_transfer_amount += ad_amount
ids_data.setItem(1, "transfer_to_next", ld_transfer_amount)

openwithparm(w_enter_transfer_comment, ids_data.getItemString(1, "transfer_comment_next" ))
ls_comment = message.StringParm
/* if NULL the user has pressed cancel, and the process will stop */
if isNull(ls_comment) then return 0

ids_data.setItem(1, "transfer_comment_next", ls_comment )

UPDATE NTC_PAYMENT
	SET TRANSFER_FROM_PREVIOUS = :ld_transfer_amount,
		 TRANSFER_COMMENT_PREVIOUS = :ls_comment
	WHERE PAYMENT_ID = :ll_next_payment ;

/* Update payment balance -  Next */
ls_mySQL = "sp_paymentBalance " + string(ll_next_payment)
EXECUTE IMMEDIATE :ls_mySQL;

return 1
end function

private function integer of_settlereceivable (ref s_settle_payment astr_parm);/* return codes  -1 an error
						0 OK but settle canceled
						1 OK
*/

integer 				li_rc

if astr_parm.li_settle = 0  or isnull(astr_parm.li_settle) then /* settle cancel */
	return 0
end if

/* Transfer the balance to next payment and mark current as 'Paid' */
if astr_parm.transfer then
	    
	/* set payment status to "Paid" (5) */
	ids_data.setItem(1, "payment_status", 5)
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	/* set exchange rate if not already set */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
	return of_settleTransfer(astr_parm.receive_amount )
end if	

/* When received amount is less than expected CMS Transaction and status PartPaid */
/* When received amount is greater than expected both CMS and CODA transactions and status PartPaid */
if astr_parm.partpaid then
		
	if astr_parm.postCODA then

		
		/* set transfer to CODA = true */
		ids_data.setItem(1, "trans_to_coda", 1)
		/* set exchange rate if not already set */
	end if		
	/* set payment status to "Part-Paid" (4). But only if not already set to Paid */
	if ids_data.getItemNumber(1, "payment_status") < 5 then
		ids_data.setItem(1, "payment_status", 4)
	end if
	/* set exchange rate first time a part-payment is payed */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
		
	/* Generate CMS Transaction */
   return of_CMSreceivableTransaction(astr_parm.receive_amount, astr_parm.receive_date)
    
	
end if

/* It is possible to post CODA transactions without receiving money at the same time (restriction there shall be at least one receivable already) */
if astr_parm.postCODA then
	
	/* set payment status to "Paid" (5) */
	ids_data.setItem(1, "payment_status", 5)
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	/* set exchange rate if not already set */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
	return 1
end if	

/* ****************************************************** */
/* OTHERWISE IT IS A FULL SETTLEMENT WHERE BOTH CMS       */
/* AND CODA TRANSACTIONS ARE GENERATED							 */
/* ****************************************************** */                               

ids_data.setItem(1, "payment_status", 5)
/* set transfer to CODA = true */
ids_data.setItem(1, "trans_to_coda", 1)
/* set exchange rate if not already set */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if
 
/* Generate CMS Transaction */
li_rc = of_CMSreceivableTransaction(astr_parm.receive_amount, astr_parm.receive_date)
if li_rc = -1 then return -1


/* Check if received > balance and transfer the amount */
if (astr_parm.receive_amount > astr_parm.settle_amount) then
	return of_settleTransferExtra(astr_parm.settle_amount - astr_parm.receive_amount )
else 
	return 1
end if
end function

private function integer of_settlecreditreceivable (ref s_settle_payment astr_parm);/* ****************************************************** */
/* THIS IS A FULL SETTLEMENT WHERE BOTH CMS               */
/* AND CODA TRANSACTIONS ARE GENERATED							 */
/* ONLY DIFFERENCE IS THAT IT IS REVERSED	!!!!!!!!!!		 */
/* ****************************************************** */
integer				li_rc
datetime				ldt_null; setNull(ldt_null)

/* !!! This function is not in use anymore ref. to change request #1082 */
messageBox("Warning", "This function is not in use any more. Please contact system admin~r~n~r~nn_tc_settle_payment.of_settleCreditReceivable()")

if isNull(astr_parm.settle_amount) then /* settle cancel */
	return 0
end if

/* Transfer the balance to next payment and nmark current as 'Paid' */
if astr_parm.transfer then
	/* Generate CODA Transaction */
	if of_anyCodaItems(il_paymentid) then 
		li_rc = of_CODAReceivableTransaction(astr_parm.receive_date)
		if li_rc = -1 then return -1
	end if
	/* set payment status to "Paid" (5) */
	ids_data.setItem(1, "payment_status", 5)
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	/* set exchange rate if not already set */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
	return of_settleTransfer(astr_parm.settle_amount)
end if	

/* It is possible to post CODA transactions without receiving money at the same time (restriction there shall be at least one receivable already) */
if astr_parm.postCODA then
	/* Generate CODA Transaction */
	if of_anyCodaItems(il_paymentid) then 
		li_rc = of_CODAReceivableTransaction(astr_parm.receive_date)
		if li_rc = -1 then return -1
	end if
	/* set payment status to "Paid" (5) */
	ids_data.setItem(1, "payment_status", 5)
	/* set transfer to CODA = true */
	ids_data.setItem(1, "trans_to_coda", 1)
	/* set exchange rate if not already set */
	if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
		of_setPaymentExrate()
	end if
	return 1
end if	
/* Ready to settle amount */
/* Generate CODA Receivable Transaction */
if of_anyCodaItems(il_paymentid) then 
	li_rc = of_CODAreceivableTransaction(astr_parm.receive_date)
	if li_rc = -1 then return -1
end if
/* set payment status to "Paid" (5) */
ids_data.setItem(1, "payment_status", 5)
/* set transfer to CODA = true */
ids_data.setItem(1, "trans_to_coda", 1)
/* set exchange rate first time a part-payment is payed */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if
/* Generate CMS Payment Transaction */
return of_CMSpaymentTransaction(astr_parm.receive_amount * -1, ldt_null) 

end function

private subroutine of_setpaymentexrate ();string 			ls_tc_currency
decimal {6}		ld_exrate_tc, ld_exrate_usd
decimal			ld_payment_exrate
long 				ll_contractid

SELECT NTC_TC_CONTRACT.CURR_CODE  
	INTO :ls_tc_currency  
   FROM NTC_PAYMENT,   
         NTC_TC_CONTRACT  
   WHERE ( NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID ) and  
         ( ( NTC_PAYMENT.PAYMENT_ID = :il_paymentid ) )   ;

if ls_tc_currency = "USD" then
	ld_payment_exrate = 100
	ids_data.setItem(1, "ex_rate_usd", ld_payment_exrate)
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
	ld_payment_exrate = ( ld_exrate_tc / ld_exrate_usd ) * 100
	ids_data.setItem(1, "ex_rate_usd", ld_payment_exrate)
end if

return

 
end subroutine

public function integer of_settlepayment (long al_paymentid);/* find out if payable or receivable, and call proper function */

integer 				li_rc = 0
long					ll_min_paymentID
string					ls_mySQL,ls_sqlerrtext
decimal				ld_balance

s_settle_payment 	lstr_parm

il_paymentid = al_paymentid

/* Make sure that payment balance is updated */
ls_mySQL = "sp_paymentBalance " + string(il_paymentid)
EXECUTE IMMEDIATE :ls_mySQL;
commit;  

if ids_data.retrieve(il_paymentid) <> 1 then 
	MessageBox("Retrrieval Error", "Could not retrieve payment Object: n_tc_settle_payment, function: of_settlePAyment()")
	return -1
end if

/* Check if OPSA periods are set and if they match Contract */
if of_checkopsasetup( il_paymentid) = -1 then return -1

commit;  //Also ensures that a new DB transaction is started

/* Check account numbers */
if ids_data.getItemNumber(1, "income") = 0 then  
	if isNull(ids_data.getItemString(1, "tcowners_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "tcowners_nom_acc_nr")) <> 5 then
		MessageBox("Error", "TC Owner Nominal Account number not correct. Please correct and try again")
		return -1
	end if
else
	if isNull(ids_data.getItemString(1, "chart_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "chart_nom_acc_nr")) <> 5 then
		MessageBox("Error", "Charterer Nominal Account number not correct. Please correct and try again")
		return -1
	end if
end if

/* Not possible to settle a payment of status="Paid"(5) and amount 0 */
if ids_data.getItemDecimal(1, "payment_balance") = 0 and &
	ids_data.getItemDecimal(1, "payment_status") > 4 then 
		MessageBox("Information", "Payment already settled!")
		return 1
end if

/* find out if payment or receivable */
if ids_data.getItemNumber(1, "income") = 1 then  
	/* TC-out */
	lstr_parm.payment_id 		= il_paymentid
	lstr_parm.settle_amount 	= ids_data.getItemDecimal(1, "payment_balance")
	lstr_parm.transfer 			= false
	lstr_parm.partpaid 			= false
	lstr_parm.postCODA 			= false
	lstr_parm.receive_amount 	= lstr_parm.settle_amount 
	lstr_parm.receive_date 		= datetime(today())
	lstr_parm.duedate				= ids_data.getItemDatetime(1, "est_due_date")
	
	openwithparm(w_receivable_amount, lstr_parm)
	
	lstr_parm = message.powerObjectParm
   
//	if lstr_parm.receive_amount >= 0 then
	if isvalid(lstr_parm) then
		li_rc = of_settleReceivable(lstr_parm)
	else
		li_rc = 0
	end if
//	else
//		li_rc = of_settleCreditReceivable(lstr_parm)
//	end if
else
	/* TC in */
	if ids_data.getItemDecimal(1, "payment_balance") >= 0 then
		li_rc = of_settlePayable()
	else
		/* According to Change Request #1082 then it shall always be possible to transfer*/
		
//		/* If balance is negative and payment is first then possible to transfer to next */
//		/* Find out if this is the first payment, where transfer is possible */
//		SELECT MIN(PAYMENT_ID) 
//		INTO :ll_min_paymentID
//		FROM NTC_PAYMENT 
//		WHERE CONTRACT_ID = ( SELECT CONTRACT_ID FROM NTC_PAYMENT 
//									WHERE PAYMENT_ID = :il_paymentID) ;  
//		if il_paymentID = ll_min_paymentID then
			li_rc = of_settlePayable()
//		else	
//			li_rc = of_settleCreditPayable()
//		end if
	end if
end if	

/* error */
if li_rc = -1 then
	rollback;
	MessageBox("Settle Error", "Something went wrong in the settling process. object: n_tc_settle_payment, function: of_settlePayment")
	return -1
end if

/* OK but settle canceled */
if li_rc = 0 then 
	rollback;
	return 1
end if	

/* Everything OK - ready for update */
/* set exchange rate first time a payment is settled */
if ids_data.getItemNumber(1, "payment_status") = 3 and &
	isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  /* Final = 3 */
	of_setPaymentExrate()
end if

/*  Update datastore */
if ids_data.update() <> 1 then
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("Update Error", "Update of payment went wrong. Please contact system administrator. Function: n_tc_payment.of_settle_payment()~n~r~n~rSQLErrText="+ls_sqlerrtext)
	return -1
end if
	
/* Update payment balance - Current  */
ls_mySQL = "sp_paymentBalance " + + string(il_paymentid)
EXECUTE IMMEDIATE :ls_mySQL;
if SQLCA.SQLCode <> 0 then
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("Update Error", "Update of paymentbalance went wrong. Please contact system administrator. Function: n_tc_payment.of_settle_payment()~n~r~n~rSQLErrText="+ls_sqlerrtext)
	return -1
end if

/* 	If payment status > 4 then find out if there is a balance caused by
	estimated Owner/Charterer expenses. If so set status = 4 (Part-paid) */
if ids_data.getItemNumber(1, "payment_status") > 4 then
	SELECT PAYMENT_BALANCE
		INTO :ld_balance
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID = :il_paymentid;
	if SQLCA.SQLCode <> 0 then
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("Select Error", "Selecting paymentbalance went wrong. Please contact system administrator. Function: n_tc_payment.of_settle_payment()~n~r~n~rSQLErrText="+ls_sqlerrtext)
		return -1
	end if
	
	if ld_balance <> 0 then
		UPDATE NTC_PAYMENT
			SET PAYMENT_STATUS = 4
			WHERE PAYMENT_ID = :il_paymentid;
		if SQLCA.SQLCode <> 0 then
			ls_sqlerrtext = string(sqlca.SQLErrText)
			rollback;
			MessageBox("Update Error", "Update payment status went wrong. Please contact system administrator. Function: n_tc_payment.of_settle_payment()~n~r~n~rSQLErrText="+ls_sqlerrtext)
			return -1
		end if
	end if
end if

commit;
	
return 1


end function

private function boolean of_anycodaitems (long al_paymentid);/* This function checks if there are any items that not already are posted
	to CODA
*/
integer li_count

//if ids_data.getItemNumber(1, "payment_status") < 5 then return true
if ids_data.getItemNumber(1, "trans_to_coda") = 0 then return true

SELECT COUNT(*) 
	INTO :li_count
	FROM NTC_OFF_SERVICE
	WHERE PAYMENT_ID = :al_paymentid
	AND TRANS_TO_CODA = 0;

IF li_count > 0 then return true

SELECT COUNT(*) 
	INTO :li_count
	FROM NTC_PAY_CONTRACT_EXP
	WHERE PAYMENT_ID = :al_paymentid
	AND TRANS_TO_CODA = 0;

IF li_count > 0 then return true

SELECT COUNT(*) 
	INTO :li_count
	FROM NTC_NON_PORT_EXP
	WHERE PAYMENT_ID = :al_paymentid
	AND TRANS_TO_CODA = 0;

IF li_count > 0 then return true

SELECT COUNT(*) 
	INTO :li_count
	FROM NTC_EST_OC_EXP
	WHERE PAYMENT_ID = :al_paymentid
	AND TRANS_TO_CODA = 0;

IF li_count > 0 then return true

return false
end function

private function integer of_cmsreceivabletransaction (decimal ad_settle_amount, datetime adt_receive_date);/* Generate CMS transaction  
	return codes  -1 an error
						1 OK
*/

integer 								li_rc = 0
s_transaction_input				lstr_transValues
//u_transaction_hire_rec_cms		lnv_CMStransaction
n_ds									lds_settled
string								ls_mySQL

// if ad_settle_amount = 0 ignore generation of CMS transaction (CMS can't handle zero payments/receivables
// just set settle date and return 1 as everything OK
if ad_settle_amount = 0 then
	if isNull(ids_data.getItemDatetime(1, "settle_date")) then  
		ids_data.setItem(1, "settle_date", adt_receive_date)
	end if
	return 1
end if

// start generating CMS transaction
lstr_transValues.vessel_no = ids_data.getItemNumber(1, "vessel_nr")
lstr_transValues.coda_or_cms = false   /* = CMS */
lstr_transValues.settle_tc_payment = ids_data
lstr_transValues.tc_payment_amount = ad_settle_amount
lstr_transValues.doc_date = adt_receive_date


/* M5-4 Modified by LGX001 on 18/01/2012. 
lnv_CMStransaction = create u_transaction_hire_rec_cms
li_rc = lnv_CMStransaction.of_generate_transaction(lstr_transValues)
destroy lnv_CMStransaction
*/

/* OK but settle canceled */
if li_rc = -1 then return -1

/* Everything OK - ready for update */
/* create settled amount record */
lds_settled = CREATE n_ds
lds_settled.dataObject = "d_table_ntc_payment_settled_amount"
lds_settled.setTransObject(SQLCA)
lds_settled.InsertRow(0)
lds_settled.setItem(1, "payment_id", ids_data.getItemNumber(1, "payment_id"))
lds_settled.setItem(1, "settle_date", adt_receive_date)
if ids_data.getItemNumber(1, "income") = 1 then
	lds_settled.setItem(1, "settle_amount", ad_settle_amount)
else
	lds_settled.setItem(1, "settle_amount", ad_settle_amount * -1)
end if	

/* set payment settle date */
if isNull(ids_data.getItemDatetime(1, "settle_date")) then  
	ids_data.setItem(1, "settle_date", adt_receive_date)
end if

/* Update */
if lds_settled.update() <> 1 then
	rollback;
	MessageBox("Update error", "Update of NTC_PAYMENT_SETTLED_AMOUNT rate went wrong. Objecj: n_tc_settle_payment. Function: of_CMSReceivableTransaction()")
	destroy lds_settled
	return -1
else
	destroy lds_settled
	return 1
end if


end function

private function integer of_settletransfer (decimal ad_transfer_amount);decimal{2}		ld_transfer_amount
string 			ls_mySQL
n_tc_payment	lnv_payment
long				ll_next_payment
string 			ls_comment

/* Add previous transfered amounts to current, as there is only one amount on statement */
ld_transfer_amount = ids_data.getItemDecimal(1, "transfer_to_next") 
if isNull(ld_transfer_amount) then ld_transfer_amount = 0
ld_transfer_amount += ad_transfer_amount
openwithparm(w_enter_transfer_comment, ids_data.getItemString(1, "transfer_comment_next" ))
ls_comment = message.StringParm
/* if NULL the user has pressed cancel, and the process will stop */
if isNull(ls_comment) then return 0

ids_data.setItem(1, "transfer_comment_next", ls_comment )
ids_data.setItem(1, "transfer_to_next", ld_transfer_amount)

lnv_payment = create n_tc_payment
ll_next_payment = lnv_payment.of_getNextUnpaid(ids_data.getItemNumber(1, "contract_id"), ids_data.getItemNumber(1, "payment_id"))
destroy lNV_payment

/* If last payment - should not be possible. Button disabled when last */
if (ll_next_payment = -1) or &
	(ids_data.getItemNumber(1, "payment_id") = ll_next_payment) then return 1
	
UPDATE NTC_PAYMENT
	SET TRANSFER_FROM_PREVIOUS = :ld_transfer_amount,
		 TRANSFER_COMMENT_PREVIOUS = :ls_comment
	WHERE PAYMENT_ID = :ll_next_payment ;

IF SQLCA.SQLCode <> 0 then
	rollback;
	MessageBox("Update error", "Update of NTC_PAYMENT_SETTLED_AMOUNT rate went wrong. Objecj: n_tc_settle_payment. Function: of_settleTransfer()")
	return -1
end if

/* set payment settle date */
if isNull(ids_data.getItemDatetime(1, "settle_date")) then  
	ids_data.setItem(1, "settle_date", today())
end if

/* Update payment balance -  Next */
ls_mySQL = "sp_paymentBalance " + string(ll_next_payment)
EXECUTE IMMEDIATE :ls_mySQL;

IF SQLCA.SQLCode <> 0 then
	rollback;
	MessageBox("Update error", "Update of NTC_PAYMENT_SETTLED_AMOUNT rate went wrong. Objecj: n_tc_settle_payment. Function: of_settleTransfer()")
	return -1
else
	return 1
end if

end function

public function integer of_checkopsasetup (long al_paymentid);/* 	If TC OUT Contract, this function Checkes if there is a OPSA setup.
	If so check if there is a OPSA Period Setup. If OPSA periode don't
	match Contract period setup is not allowed	*/

integer 		li_tc_hire_in, li_OPSAsetup, li_count
long			ll_contractID
datetime		ldt_contractStart, ldt_contractEnd, ldt_opsaStart, ldt_opsaEnd

SELECT C.CONTRACT_ID, C.TC_HIRE_IN, C.OPSA_SETUP
	INTO :ll_contractID, :li_tc_hire_in, :li_OPSAsetup
	FROM NTC_TC_CONTRACT C, NTC_PAYMENT P
	WHERE C.CONTRACT_ID = P.CONTRACT_ID
	AND P.PAYMENT_ID = :al_paymentID;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Failed to retrieve Contract~n~r~n~rSQLErrText = "+sqlca.sqlerrtext)
	return -1
end if
	
if li_tc_hire_in = 1 then return 1

if li_OPSAsetup = 0 then return 1

SELECT COUNT(*)
	INTO :li_count
	FROM NTC_OPSA_PERIOD
	WHERE CONTRACT_ID = :ll_contractID;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Failed to count OPSA periods~n~r~n~rSQLErrText = "+sqlca.sqlerrtext)
	return -1
end if

if li_count = 0 then return 1

/* There are OPSA periods, check that they are equal to TC periods */
/* Get TC Periods */
SELECT min(PERIODE_START),   
		max(PERIODE_END)
	INTO :ldt_contractStart,   
		:ldt_contractEnd  
	FROM NTC_TC_PERIOD  
	WHERE CONTRACT_ID = :ll_contractID  ;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Failed to retrieve Contract Start/End~n~r~n~rSQLErrText = "+sqlca.sqlerrtext)
	return -1
end if

/* Get OPSA Periods */
SELECT min(OPSA_PERIOD_START),   
		max(OPSA_PERIOD_END)
	INTO :ldt_opsaStart,   
		:ldt_opsaEnd  
	FROM NTC_OPSA_PERIOD  
	WHERE CONTRACT_ID = :ll_contractID  ;
if SQLCA.SQLCode <> 0 then
	MessageBox("Select Error", "Failed to retrieve OPSA Start/End~n~r~n~rSQLErrText = "+sqlca.sqlerrtext)
	return -1
end if

if ldt_opsaStart <> ldt_contractStart then
	MessageBox("Validation Error", "OPSA period startdate must be the same as TC Contract delivery")
	return -1
end if

if ldt_opsaEnd <> ldt_contractEnd then
	MessageBox("Validation Error", "OPSA period enddate must be the same as TC Contract re-delivery")
	return -1
end if

return 1
end function

private function integer of_codapaymenttransaction ();/* Generate CODA transaction  
	return codes  -1 an error
						1 OK

*/

integer 								li_rc = 0
s_transaction_input				lstr_transValues
u_transaction_hire_pay_coda	lnv_CODAtransaction


lstr_transValues.vessel_no = ids_data.getItemNumber(1, "vessel_nr")
lstr_transValues.coda_or_cms = true   /* = CODA */
lstr_transValues.settle_tc_payment = ids_data

lnv_CODAtransaction = create u_transaction_hire_pay_coda
li_rc = lnv_CODAtransaction.of_generate_transaction(lstr_transValues)
destroy lnv_CODAtransaction



/* OK but settle canceled */
if li_rc = -1 then return -1

return 1
end function

private function integer of_cmspaymenttransaction (decimal ad_settle_amount, datetime adt_receive_date);/* Generate CMS transaction  
	return codes  -1 an error
						1 OK

	Parameter adt_receive_date is only relevant when payment negative and therefore is 
	event converted to receivable */

integer 								li_rc = 0
s_transaction_input				lstr_transValues
//u_transaction_hire_pay_cms		lnv_CMStransaction
n_ds									lds_settled
string								ls_mySQL

// if ad_settle_amount = 0 ignore generation of CMS transaction (CMS can't handle zero payments/receivables)
// just set settle date and return 1 as everything OK
if ad_settle_amount = 0 then
	if isNull(ids_data.getItemDatetime(1, "settle_date")) then  
		ids_data.setItem(1, "settle_date", today())
	end if
	return 1
end if

// start generating CMS transaction
lstr_transValues.vessel_no = ids_data.getItemNumber(1, "vessel_nr")
lstr_transValues.coda_or_cms = false   /* = CMS */
lstr_transValues.settle_tc_payment = ids_data
lstr_transValues.tc_payment_amount = ad_settle_amount
lstr_transValues.doc_date = adt_receive_date


//JMC: disable
//lnv_CMStransaction = create u_transaction_hire_pay_cms
//li_rc = lnv_CMStransaction.of_generate_transaction(lstr_transValues)
//destroy lnv_CMStransaction



/* OK but settle canceled */
if li_rc = -1 then return -1

/* Everything OK - ready for update */
/* create settled amount record */
lds_settled = CREATE n_ds
lds_settled.dataObject = "d_table_ntc_payment_settled_amount"
lds_settled.setTransObject(SQLCA)
lds_settled.InsertRow(0)
lds_settled.setItem(1, "payment_id", ids_data.getItemNumber(1, "payment_id"))
lds_settled.setItem(1, "settle_date", today())
if ids_data.getItemNumber(1, "income") = 0 then
	lds_settled.setItem(1, "settle_amount", ad_settle_amount)
else
	lds_settled.setItem(1, "settle_amount", ad_settle_amount * -1)
end if	

/* set payment settle date */
if isNull(ids_data.getItemDatetime(1, "settle_date")) then  
	ids_data.setItem(1, "settle_date", today())
end if

/* Update */
if lds_settled.update() <> 1 then
	rollback;
	MessageBox("Update error", "Update of NTC_PAYMENT_SETTLED_AMOUNT rate went wrong. Objecj: n_tc_settle_payment. Function: of_CMSPaymentTransaction()")
	destroy lds_settled
	return -1
else
	destroy lds_settled
	return 1
end if

//if ids_data.update(true, false) = 1 then
//	if lds_settled.update(true, false) = 1 then
//		ids_data.resetUpdate()
//		lds_settled.resetUpdate()
//		/* Update payment balance */
//		ls_mySQL = "sp_paymentBalance " + string(ids_data.getItemNumber(1, "payment_id"))
//		EXECUTE IMMEDIATE :ls_mySQL;
//		commit;
//	else
//		rollback;
//		MessageBox("Update error", "Update of payment exchange rate went wrong. Objecj: n_tc_settle_payment. Function: of_CMSPaymentTransaction()")
//		destroy lds_settled
//		return -1
//	end if
//else
//	rollback;
//	MessageBox("Update error", "Update of NTC_PAYMENT_SETTLED_AMOUNT rate went wrong. Objecj: n_tc_settle_payment. Function: of_CMSPaymentTransaction()")
//	destroy lds_settled
//	return -1
//end if
//
//destroy lds_settled
//return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    	 Author        Comments
  02/09-08 	1272      RMO003     Changed of_unsettlepayment changed to handle and error
  											in Estimated Owners/Charterers Expenses
  06/01-12  M5-4      LGX001     Removed the fuction of Creation / change transaction
  											when TC out settle or unsettle payments  
  30/01-12	2421		JMC112	Disable CMS transaction
  19/06-12  2815     LGX001   Delete settle recordor when unsetlle payment
  27/06-12	2833	JMC112	Do not delete commissions when unsettling a TC-out payment
  10/07-12	2873	JMC112	When unsettling TC-in, the TRANS_TO_CODA flag needs to be set to 0
  11/07-12	2875	JMC112	When set to draft not settled TC-out commissions should be deleted
  19/10-12  3017  LGX001   Reverse transaction is only created for TC-in voyage
  16/04-15  2897  KSH092   Change settle or unsettle order for TC-Out voyage   
********************************************************************/

end subroutine

public function integer of_lumpsumreceivable (long al_paymentid);/* Settle lumpsum receivable */
/* return codes  -1 an error
						0 OK but settle canceled
						1 OK
*/

integer 								li_rc = 0
string									ls_mySQL
s_settle_payment					lstr_parm

il_paymentid = al_paymentid

if ids_data.retrieve(il_paymentid) <> 1 then 
	MessageBox("Retrieval Error", "Could not retrieve payment Object: n_tc_settle_payment, function: of_settlePAyment()")
	return -1
end if

/* Check account numbers */
if ids_data.getItemNumber(1, "income") = 0 then  
	if isNull(ids_data.getItemString(1, "tcowners_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "tcowners_nom_acc_nr")) <> 5 then
		MessageBox("Error", "TC Owner Nominal Account number not correct. Please correct and try again")
		return -1
	end if
else
	if isNull(ids_data.getItemString(1, "chart_nom_acc_nr")) OR &
		len(ids_data.getItemString(1, "chart_nom_acc_nr")) <> 5 then
		MessageBox("Error", "Charterer Nominal Account number not correct. Please correct and try again")
		return -1
	end if
end if

lstr_parm.settle_amount = 	ids_data.getItemDecimal(1, "payment_balance")
lstr_parm.receive_amount = ids_data.getItemDecimal(1, "payment_balance")
lstr_parm.receive_date = datetime(today(), now())
lstr_parm.payment_id = il_paymentid

openwithparm(w_receivable_lumpsum, lstr_parm )
lstr_parm = message.powerObjectParm

if isNull(lstr_parm.receive_amount) then 
	return 0
end if
if isNull(lstr_parm.receive_date) then 
	return 0
end if

/* set exchange rate first time a lumpsum is received */
if isNull(ids_data.getItemDecimal(1, "ex_rate_usd")) then  
	of_setPaymentExrate()
end if


/* Generate CMS Transaction */
if of_CMSreceivableTransaction(lstr_parm.receive_amount, lstr_parm.receive_date) = -1 then return -1 

if ids_data.update() = 1 then
	commit;
	/* Update payment balance - Current  */
	ls_mySQL = "sp_paymentBalance " + string(ids_data.getItemNumber(1, "payment_id"))
	EXECUTE IMMEDIATE :ls_mySQL;
	if SQLCA.SQLCode = 0 then
		commit;
	else
		rollback;
		MessageBox("Update Error", "Update of paymentbalance went wrong. Please contact system administrator. Function: n_tc_payment.of_lumpsumreceivable()")
		return -1
	end if
else
	rollback;
	MessageBox("Update Error", "Update of payment went wrong. Please contact system administrator. Function: n_tc_payment.of_lumpsumreceivable()")
	return -1
end if

return 1
end function

public function integer of_unsettlepayment (long al_paymentid, integer ai_flag);/* This function un-settles a payment "Paid" or "Part Paid" and sets the status to "draft" for tc in, 
	but sets the status to "final" for tc out
	- If status is "Part Paid" or "Paid" the following happens
	  1) Update status for found and subsequent payments to "Draft". Only if payment status > 2 (draft)
	  2) Update transfer_to_next for current payment and subsequent to NULL
	  3) Delete alle TC commissions set-off in hire
	  4) Delete all TC commissions not settled yet
	  5) If TC commissions settled give message to user that they can't be deleted
	  6) Ask user if CODA and CMS or just CODA transactions shall be reverted
	  7) If also CMS all paid/received amounts are deleted
	  8) All CODA and/or CMS transactions reverted
	  9) Delete all Non-port expenses TC commissions set-off in hire
	  10) Delete all Non-port expenses TC commissions not settled yet
	  11) Non-port expenses set to not posted yet
	  12) off-services set to not posted yet
	  13) contract expenses are set to not posted yet
	  14) estimated Owner/Charterer expenses are set to not posted yet
	  14b) if last payment and both the original and the reverted expenses are on the same 
	  		payment then the REVERT estimated Owner/Charterer expenses are deleted
		  
	Return value: 1 OK
					 -1 Error
*/
long			ll_contractID, ll_nextPaymentID
n_ds			lds_apost, lds_bpost
long 			ll_no_of_arows, ll_arow, ll_no_of_brows, ll_brow, ll_new_apost, ll_count
double 		ld_transkey, ld_new_transkey
decimal{0}	ld_local, ld_DKK, ld_USD
long 			ll_null; setNull(ll_null)
string 		ls_null; setNull(ls_null)
datetime		ldt_null; setNull(ldt_null)
string 		ls_mysql,ls_sqlcode,ls_sqldbcode,ls_sqlerrtext,ls_criteria;setNull(ls_criteria)
integer		li_rc, li_tc_in
string		ls_doccode_cms_pay, ls_doccode_cms_pay_cr, ls_doccode_cms_rec, ls_doccode_cms_rec_cr, ls_comment, ls_confirm

/* M5-4 Added by LGX001 on 11/01/2012. */ 
string ls_invoice_nr
n_tc_transaction  lnv_tc_transaction

ls_criteria = "TCCODA%"

if ids_data.retrieve(al_paymentid) <> 1 then 
	MessageBox("Retrrieval Error", "Could not retrieve payment Object: n_tc_settle_payment, function: of_unsettlePayment()")
	rollback;
	return -1
end if
commit;  //Also ensures that a new DB transaction is started

ll_contractID = ids_data.getItemNumber(1, "contract_id")

/* Set item into action log. Who is unsettling this payment */
if ai_flag = ii_UNSETTLE then
	ls_comment = "Payment un-settled. ID="+string(al_paymentid)
else
	ls_comment = "Payment set-draft. ID="+string(al_paymentid)
end if
  INSERT INTO NTC_TC_ACTION_LOG  
         ( USERID,   
           CONTRACT_ID,   
           ACTION_DATE,   
           ACTION_COMMENT )  
  VALUES ( :uo_global.is_userid,
           :ll_contractID,   
           getdate(),   
           :ls_comment)  ;
	
SELECT NTC_PAYMENT.INVOICE_NR, NTC_TC_CONTRACT.TC_HIRE_IN INTO: ls_invoice_nr, :li_tc_in 
FROM NTC_PAYMENT, NTC_TC_CONTRACT
WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID AND NTC_PAYMENT.PAYMENT_ID = :al_paymentID; 

if li_tc_in = 0  then //tc out	
	if ai_flag = ii_SETDRAFT then //set draft
		//Set Payment Status from "final" to "draft" for current payment
		UPDATE NTC_PAYMENT
		SET PAYMENT_STATUS = 2,
    		TRANS_TO_CODA = 0
		WHERE PAYMENT_ID = :al_paymentid
		AND CONTRACT_ID = :ll_contractid;
		if sqlca.SQLCode <> 0 then 
			ls_sqlcode = string(sqlca.SQLCode)
			ls_sqldbcode = string(sqlca.SQLDBCode)
			ls_sqlerrtext = string(sqlca.SQLErrText)
			rollback;
			MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
									  "~n~rSql DB Code = "+ls_sqldbcode+&
									  "~n~rSql ErrText = "+ls_sqlerrtext)
			
			return -1
		end if
	  	//return of_setdraft(al_paymentid, ls_invoice_nr) 		
	elseif ai_flag = ii_UNSETTLE then //unsettle
		UPDATE NTC_PAYMENT
			SET PAYMENT_STATUS = 3
		WHERE PAYMENT_ID = :al_paymentID 
		AND CONTRACT_ID = :ll_contractID;
		if sqlca.SQLCode <> 0 then 
			rollback;
			ls_sqlcode = string(sqlca.SQLCode)
			ls_sqldbcode = string(sqlca.SQLDBCode)
			ls_sqlerrtext = string(sqlca.SQLErrText)
			rollback;
			MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
									  "~n~rSql DB Code = "+ls_sqldbcode+&
									  "~n~rSql ErrText = "+ls_sqlerrtext)
			return -1
		end if
	end if
else //tc in
	//Set Payment Status to "Draft" for current status > 2
	UPDATE NTC_PAYMENT
		SET PAYMENT_STATUS = 2,
			 TRANS_TO_CODA = 0
	WHERE PAYMENT_ID = :al_paymentID
	AND CONTRACT_ID = :ll_contractID
	AND PAYMENT_STATUS > 2;
end if
if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)

	
	return -1
end if

/* Clear amount and comment transferred to next, plus "from previous" from next payment */
// first get next payment id
SELECT MIN(PAYMENT_ID)
	INTO :ll_nextPaymentID
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID > :al_paymentID
	AND CONTRACT_ID = :ll_contractID;
if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	return -1
end if

// Update comment, transferred or not and settle date on current.
// If both CODA & CMS are unsettled settle date is set to NULL

// M5-4  Modified by LGX001 on 11/01/2012. Change desc: only unsellte CODA transaction. 
//       begin 
//if ls_criteria = "TCC%" then

UPDATE NTC_PAYMENT
SET TRANSFER_TO_NEXT = NULL,
	 TRANSFER_COMMENT_NEXT = NULL,
	 SETTLE_DATE = NULL
WHERE PAYMENT_ID = :al_paymentID
AND CONTRACT_ID = :ll_contractID;
/*
else	
	UPDATE NTC_PAYMENT
		SET TRANSFER_TO_NEXT = NULL,
			 TRANSFER_COMMENT_NEXT = NULL,
			 TRANS_TO_CODA = 0
		WHERE PAYMENT_ID = :al_paymentID
		AND CONTRACT_ID = :ll_contractID;
end if  
modified end  */

if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	
	return -1
end if

if not isNull(ll_nextPaymentID) then
	// Update comment on next
	UPDATE NTC_PAYMENT
		SET TRANSFER_FROM_PREVIOUS = NULL,
			 TRANSFER_COMMENT_PREVIOUS = NULL
		WHERE PAYMENT_ID = :ll_nextPaymentID
		AND CONTRACT_ID = :ll_contractID;
	if sqlca.SQLCode <> 0 then
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
	
		return -1
	end if
end if


if li_tc_in = 1 or  (li_tc_in = 0 and ai_flag = ii_SETDRAFT) then
		
	/* Delete TC Commissions settled by hire */
	DELETE 
		FROM NTC_COMMISSION
		WHERE  NTC_COMMISSION.PAYMENT_ID = :al_paymentID 
		AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL
		AND NTC_COMMISSION.INV_NR = "paid via hire";
	if sqlca.SQLCode <> 0 then 
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	/* Delete TC Commissions not settled yet */
	DELETE
		FROM NTC_COMMISSION 
		WHERE NTC_COMMISSION.PAYMENT_ID = :al_paymentID 
		AND NTC_COMMISSION.COMM_SETTLE_DATE IS NULL;
	if sqlca.SQLCode <> 0 then 
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	/* TC Commission updates */
	SELECT COUNT(PAYMENT_ID)
		INTO :ll_count
		FROM NTC_COMMISSION  
		WHERE NTC_COMMISSION.PAYMENT_ID = :al_paymentID 
		AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL;
	if sqlca.SQLCode <> 0 then
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	if ll_count > 0 then	
		if ai_flag = ii_UNSETTLE then
			ls_confirm = "Please be aware of that there exists settled~n~rTC commissions connected to this Payment.~n~rThese commissions will not be deleted, but will~n~rremain connected to the Payment.~n~r~n~rAre you sure you want to proceed un-settle?"
		else
			ls_confirm = "Please be aware of that there exists ~n~rTC commissions connected to this Payment.~n~rThese commissions will not be deleted, but will~n~rremain connected to the Payment.~n~r~n~rAre you sure you want to proceed?"
		end if
		if MessageBox("Commission Information", ls_confirm,Question!,YesNo!,2) = 2 then
			Rollback;
			Return -1
		end if
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
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	/* Delete Non Port Expenses TC Commissions not settled yet */
	DELETE NTC_COMMISSION  
		FROM NTC_COMMISSION, NTC_NON_PORT_EXP  
		WHERE NTC_NON_PORT_EXP.NON_PORT_ID = NTC_COMMISSION.NON_PORT_ID 
		AND NTC_NON_PORT_EXP.PAYMENT_ID = :al_paymentID 
		AND NTC_COMMISSION.COMM_SETTLE_DATE IS NULL;
	if sqlca.SQLCode <> 0 then
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	SELECT count(NTC_NON_PORT_EXP.NON_PORT_ID)
		INTO :ll_count
		FROM NTC_COMMISSION, NTC_NON_PORT_EXP  
		WHERE NTC_NON_PORT_EXP.NON_PORT_ID = NTC_COMMISSION.NON_PORT_ID 
		AND NTC_NON_PORT_EXP.PAYMENT_ID = :al_paymentID 
		AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL;
	if sqlca.SQLCode <> 0 then 
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
	
	if ll_count > 0 then
		if ai_flag = ii_UNSETTLE then
			ls_confirm = "Please be aware of that there exists settled~n~rNon-Port Exoenses TC commissions connected to this Payment.~n~rThese commissions will not be deleted, but will~n~rremain connected to the Payment.~n~r~n~rAre you sure you want to proceed un-settle?"
		else
			ls_confirm = "Please be aware of that there exists ~n~rNon-Port Exoenses TC commissions connected to this Payment.~n~rThese commissions will not be deleted, but will~n~rremain connected to the Payment.~n~r~n~rAre you sure you want to proceed ?"
		end if	
		if MessageBox("Commission Information", ls_confirm, Question!, YesNo!, 2) = 2 then
			Rollback;
			Return -1
		end if
	end if
	

	if li_tc_in = 1 then
		// The reverse transaction is only created for TC-in voyage . 
		lnv_tc_transaction = create n_tc_transaction
		if lnv_tc_transaction.of_credit_note(al_paymentID, ls_invoice_nr) = c#return.Failure then
			rollback;
			destroy lnv_tc_transaction
			return -1
		else
			destroy lnv_tc_transaction
		end if
	end if	
end if



	

/* Set Transferred to CODA = 0 (not transferred) */	

UPDATE NTC_PORT_EXP  
	SET TRANS_TO_CODA = 0  
	WHERE PAYMENT_ID = :al_paymentID  ;
if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	
	return -1
end if

UPDATE NTC_NON_PORT_EXP  
	SET TRANS_TO_CODA = 0  
	WHERE PAYMENT_ID = :al_paymentID  ;
if sqlca.SQLCode <> 0 then
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	return -1
end if

UPDATE NTC_EST_OC_EXP  
	SET TRANS_TO_CODA = 0  
	WHERE PAYMENT_ID = :al_paymentID  ;
if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	
	return -1
end if

if isNull(ll_nextPaymentID) then
	// MUST BE LAST PAYMENT (Reverted Estimated Owners/Charterer Expenses deleted)
	DELETE
		FROM NTC_EST_OC_EXP  
		WHERE PAYMENT_ID = :al_paymentID 
		AND REVERSE_EST_OC_ID IS NOT NULL
		AND REVERSE_EST_OC_ID IN (SELECT EST_OC_ID FROM NTC_EST_OC_EXP WHERE PAYMENT_ID = :al_paymentid) ;
	if sqlca.SQLCode <> 0 then 
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		return -1
	end if
end if

UPDATE NTC_OFF_SERVICE  
	SET TRANS_TO_CODA = 0  
	WHERE PAYMENT_ID = :al_paymentID  ;
if sqlca.SQLCode <> 0 then
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	return -1
end if

UPDATE NTC_PAY_CONTRACT_EXP  
	SET TRANS_TO_CODA = 0  
	WHERE PAYMENT_ID = :al_paymentID  ;
if sqlca.SQLCode <> 0 then 
	ls_sqlcode = string(sqlca.SQLCode)
	ls_sqldbcode = string(sqlca.SQLDBCode)
	ls_sqlerrtext = string(sqlca.SQLErrText)
	rollback;
	MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
							  "~n~rSql DB Code = "+ls_sqldbcode+&
							  "~n~rSql ErrText = "+ls_sqlerrtext)
	
	return -1
end if
if ai_flag = ii_UNSETTLE then
	DELETE 
		FROM NTC_PAYMENT_SETTLED_AMOUNT
		WHERE PAYMENT_ID = :al_paymentID  ;
	if sqlca.SQLCode <> 0 then 
		ls_sqlcode = string(sqlca.SQLCode)
		ls_sqldbcode = string(sqlca.SQLDBCode)
		ls_sqlerrtext = string(sqlca.SQLErrText)
		rollback;
		MessageBox("DB Error", "SqlCode         = "+ls_sqlcode+&
								  "~n~rSql DB Code = "+ls_sqldbcode+&
								  "~n~rSql ErrText = "+ls_sqlerrtext)
		
		return -1
	end if
end if

/* Make sure that payment balance is updated */
ls_mySQL = "sp_paymentBalance " + string(al_paymentid)
EXECUTE IMMEDIATE :ls_mySQL;
if not isNull(ll_nextPaymentID) then
	ls_mySQL = "sp_paymentBalance " + string(ll_nextPaymentID)
	EXECUTE IMMEDIATE :ls_mySQL;
end if

commit;
return 1
end function

public function integer of_unsettlepayment_final (long al_paymentid, integer ai_flag);/********************************************************************
   of_unsettlepayment_final
   <DESC> when unsettling one part-paid or paid payment, the transactions for subsequent final payments need to
			be unsettled one by one
	</DESC>
   <RETURN>	integer:
            
    </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_paymentid
		as_source: 1. UNSETTLE
		           2. SETDRAFT		          
   </ARGS>
   <USAGE> this object would be called from 
	              1.w_tc_payment.unsettle 	
					  2.w_tc_payment.setdraft 
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18/01/2012 M5-4         LGX001			First Version
		19/01/2012 M5-4			CKT012			Restucture the codes 
   </HISTORY>
********************************************************************/
n_ds   lds_final_payment
long  ll_rowcount, ll_row, ll_paymentid

lds_final_payment = CREATE n_ds
lds_final_payment.dataobject="d_sq_gr_final_payment"
lds_final_payment.settransobject(SQLCA)

ll_rowcount = lds_final_payment.retrieve(al_paymentid)
for ll_row = 1 to ll_rowcount
    ll_paymentid = lds_final_payment.getitemnumber(ll_row, "payment_id")
	 if of_unsettlepayment(ll_paymentid, ai_flag) = -1 then  
		rollback;
		destroy lds_final_payment
		return -1
	 end if
next
commit;

destroy lds_final_payment
return 1
end function

on n_tc_settle_payment.create
call super::create
end on

on n_tc_settle_payment.destroy
call super::destroy
end on

event constructor;ids_data = CREATE n_ds
ids_data.DataObject="d_settle_one_tc_payment"
ids_data.setTransObject(SQLCA)
end event

event destructor;destroy ids_data
end event

