$PBExportHeader$n_monthly_payment_delivery_time.sru
$PBExportComments$Monthly Payments delivery time = payday at delivery time
forward
global type n_monthly_payment_delivery_time from n_tc_payment
end type
end forward

global type n_monthly_payment_delivery_time from n_tc_payment
end type
global n_monthly_payment_delivery_time n_monthly_payment_delivery_time

forward prototypes
protected function integer of_createpaymentdates ()
end prototypes

protected function integer of_createpaymentdates ();integer 	li_day, li_month, li_year
datetime ldt_duedate,ldt_additional_duedate
boolean 	lb_first_payment = True
long		ll_rowno = 0
long 		ll_progress_end
long 		ll_modify_counter 
long 		ll_teller,ll_count
time 		lt_delivery
integer  li_additional_days,li_row = 0


ll_modify_counter = 	ids_payments.rowCount()
ldt_duedate = 			idt_delivery
lt_delivery = 			time(idt_delivery)
ll_progress_end = 	f_datetime2long(idt_redelivery)

SELECT isnull(NTC_TC_CONTRACT.PAYMENT_DUE_DAYS,0)  
INTO :li_additional_days  
FROM NTC_TC_CONTRACT  
WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractid ;
if isnull(li_additional_days) then li_additional_days = 0

do while ldt_duedate < idt_redelivery
	if isValid(iw_progress) then
		iw_progress.wf_progress(f_datetime2long(ldt_duedate)/ll_progress_end, "Creating payment due dates...")
	end if
	/* create payment */
	ldt_additional_duedate = datetime(relativeDate(date(ldt_duedate), li_additional_days))
	if li_row = 0 then
		if ll_modify_counter > 0 then
			ll_count = of_selectcount( ldt_additional_duedate, il_contractid)
		else
			ll_count = of_selectcount( ldt_duedate, il_contractid)
		end if
	else
		ll_count = of_selectcount( ldt_additional_duedate, il_contractid)
	end if
	
	if ll_count < 1 then
		ll_rowno ++
		if ll_rowno > ll_modify_counter then
			ll_rowno = ids_payments.InsertRow(0)
			ids_payments.setItem(ll_rowno, "payment_status", 1)  /* 1 = new */
		end if
		ids_payments.setItem(ll_rowno, "contract_id", il_contractID)
		if ib_income then
			ids_payments.setItem(ll_rowno, "income", 1)
		else
			ids_payments.setItem(ll_rowno, "income", 0)
		end if		
		
		ids_payments.setItem(ll_rowno, "est_due_date", ldt_duedate)
		ids_payments.setItem(ll_rowno, "adr_comm", 0)
		ids_payments.setItem(ll_rowno, "broker_commission", 0)
   end if
	li_day = ii_payday
	li_month = month(date(ldt_duedate))
	li_year = year(date(ldt_duedate))
	/* Used the first time if payday not exists in delivery month */
	if lb_first_payment and ii_payday > of_lastDayOfMonth(date(ldt_duedate)) then
		do until date(li_year, li_month, li_day) <> date(1900,01,01) /* returnvalue when wrong arg */
				li_day --
		loop
		lb_first_payment = False
	end if
	if datetime(date(li_year, li_month, li_day), lt_delivery) > ldt_duedate then
		ldt_duedate = 	datetime(date(li_year, li_month, li_day), lt_delivery)
	else
		if li_month = month(date(ldt_duedate)) then li_month ++
		if li_month = 13 then
			li_month = 1
			li_year ++
		end if
		choose case li_month
			case 2
//				if li_day > 28 then
				if ii_payday > 28 then
					if of_isleapyear(date(li_year, li_month, 10 )) then
						li_day = 29
					else
						li_day = 28
					end if
				end if
			case 4,6,9,11
//				if li_day > 30 then
				if ii_payday > 30 then
					li_day = 30
				end if
			case 1,3,5,7,8,10,12
				if ii_payday = 31 then
					li_day = 31
				end if
		end choose
	end if
	ldt_duedate = datetime(date(li_year, li_month, li_day), lt_delivery)
	li_row ++
loop

/* if modify an less payments - cleanup */
if ll_rowno < ll_modify_counter then
	for ll_teller = ll_modify_counter to ll_rowno +1 step -1 
		ids_payments.deleteRow(ll_teller)
	next
end if

/* if rows deleted we have to check if there are any port expenses, 
	non-port expenses or off-services connected to those payments.
	if yes, they have to be moved to the last new payment */
if ids_payments.deletedCount() > 0 then
	if of_moveDeletedLinks() = -1 then
		rollback;
		return -1
	end if
end if

/* update datastore and if OK COMMIT all changes done in LUW */
if ids_payments.Update() = 1 then
	COMMIT; 
else
	ROLLBACK;
	MessageBox("Update Error", "Failure updating NTC_PAYMENT from of_createMonthlyPayments()~n~r" +&
					"Object: n_tc_payment, function: of_createMonthlyPayments()")
	
end if

return 1

end function

on n_monthly_payment_delivery_time.create
call super::create
end on

on n_monthly_payment_delivery_time.destroy
call super::destroy
end on

