$PBExportHeader$n_opsa_calculation.sru
$PBExportComments$Calculations related to TC Contract OPSA setup (hire, off service.
forward
global type n_opsa_calculation from nonvisualobject
end type
end forward

shared variables

end variables

global type n_opsa_calculation from nonvisualobject
end type
global n_opsa_calculation n_opsa_calculation

type variables
n_ds		ids_rates
n_ds		ids_offservice_details
end variables

forward prototypes
protected function boolean of_isperiodefullmonth (datetime adt_start, datetime adt_end)
protected function integer of_lastdayofmonth (date ad_source)
protected function boolean of_isleapyear (date ad_source)
protected subroutine of_calccommission ()
public function integer of_setrates (long al_contractid)
public function integer of_calcamountdailyrate (datetime adt_start, datetime adt_end, ref decimal ad_amount, integer ai_calctype)
public function integer of_calcamountmonthlyrate (datetime adt_start, datetime adt_end, ref decimal ad_amount, integer ai_calctype)
public function integer of_post_opsa_offservice (s_transaction_input astr_trans_input)
public function integer of_setoffservicedetail (long al_detailid)
end prototypes

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

protected subroutine of_calccommission ();///* This function calculates both address commission and broker commission
//	Broker commission is only calculated if commission is marked as set off-in hire 
//*/
//
//long			ll_rows, ll_rowno
//decimal{2}	ld_adr_pct, ld_broker_pct, ld_broker_per_day
//decimal{2}	ld_adr_comm, ld_broker_comm
//decimal{2}	ld_hire, ld_offservice
//decimal{4}	ld_hire_days, ld_offservice_days
//datetime		ldt_start, ldt_end
//long 			ll_paymentID
//
//ll_rows = ids_payments.rowCount()
//if ll_rows < 1 then return
//
//SELECT isnull(NTC_TC_CONTRACT.ADR_COMM,0)  
//	INTO :ld_adr_pct  
//	FROM NTC_TC_CONTRACT  
//	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractid ;
//	
//SELECT isnull(sum(NTC_CONT_BROKER_COMM.BROKER_COMM),0)  
//	INTO :ld_broker_pct  
//	FROM NTC_CONT_BROKER_COMM  
//	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contractID ) AND  
//			( NTC_CONT_BROKER_COMM.COMM_SET_OFF = 1 ) AND
//			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 0);
//
//SELECT isnull(sum(NTC_CONT_BROKER_COMM.BROKER_COMM),0)  
//	INTO :ld_broker_per_day  
//	FROM NTC_CONT_BROKER_COMM  
//	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contractID ) AND  
//			( NTC_CONT_BROKER_COMM.COMM_SET_OFF = 1 ) AND
//			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 1);
//
//for ll_rowno = 1 to ll_rows
//	/* Progress bar */
//	if isValid(iw_progress) then
//		iw_progress.wf_progress(ll_rowno/ll_rows, "Calculating Address and Broker Commission...")
//	end if
//
//	ll_paymentID = ids_payments.getItemNumber(ll_rowno, "payment_id")
//	
//	SELECT isNull(sum(NTC_PAYMENT_DETAIL.QUANTITY * NTC_PAYMENT_DETAIL.RATE),0),
//			min(NTC_PAYMENT_DETAIL.PERIODE_START),
//			max(NTC_PAYMENT_DETAIL.PERIODE_END)
//		INTO :ld_hire,
//			:ldt_start,
//			:ldt_end
//		FROM NTC_PAYMENT_DETAIL  
//		WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID = :ll_paymentID   ;
//		
//	SELECT isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS * NTC_OFF_SERVICE_DETAIL.RATE),0),
//			isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS),0)
//		INTO :ld_offservice,
//			:ld_offservice_days
//		FROM NTC_OFF_SERVICE, NTC_OFF_SERVICE_DETAIL  
//		WHERE ( NTC_OFF_SERVICE_DETAIL.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID ) and  
//				(( NTC_OFF_SERVICE.PAYMENT_ID = :ll_paymentID ));
//
//	ld_hire_days = timedifference(ldt_start, ldt_end)/1440
//	ld_adr_comm 	= ((ld_hire - ld_offservice) / 100) * ld_adr_pct
//	ld_broker_comm = (((ld_hire - ld_offservice) / 100) * ld_broker_pct) &
//						+ ((ld_hire_days - ld_offservice_days) * ld_broker_per_day)
//		
//	ids_payments.setItem(ll_rowno, "adr_comm", ld_adr_comm)
//	ids_payments.setItem(ll_rowno, "broker_commission", ld_broker_comm)
//	ids_payments.setItem(ll_rowno, "adr_comm_pct", ld_adr_pct)
//	ids_payments.setItem(ll_rowno, "broker_commission_pct", ld_broker_pct)
//	ids_payments.setItem(ll_rowno, "broker_commission_per_day", ld_broker_per_day)	
//	
//next
//if ids_payments.Update() = 1 then
//	COMMIT; 
//else
//	MessageBox("Update Error", "Failure updating NTC_PAYMENT from of_calcComission(), Object: n_tc_payment")
//	ROLLBACK;
//end if
//
//return
//	
end subroutine

public function integer of_setrates (long al_contractid);/*
Description: 	Retrieves and Cleans the period rates data store for succesive periods with same rate. 
*/

long ll_counter

ids_rates.reset( )
ids_rates.dataObject = "d_opsa_rate_periods"
ids_rates.setTransObject(SQLCA)
  
ids_rates.retrieve(al_contractID)

FOR ll_counter = ids_rates.rowcount() to 2 step -1
	if ids_rates.getitemdecimal(ll_counter, "bareboat_hire") = ids_rates.getitemdecimal(ll_counter - 1, "bareboat_hire") &
	and ids_rates.getitemdecimal(ll_counter, "savedrc") = ids_rates.getitemdecimal(ll_counter - 1, "savedrc") then
		ids_rates.setitem(ll_counter - 1, "period_end", ids_rates.getitemdatetime( ll_counter, "period_end"))
		ids_rates.deleterow(ll_counter)
	end if
NEXT

return 1
end function

public function integer of_calcamountdailyrate (datetime adt_start, datetime adt_end, ref decimal ad_amount, integer ai_calctype);/* This function calculates payment details when rate is defined as daily 

	calctype indicates which rate to use as same calculation is used for 
	hire, off service bareboat hire and off service save drc hire        */

long 			ll_rateIdx, ll_rates
datetime		ldt_rateStart, ldt_rateEnd
datetime 	ldt_detailStart, ldt_detailEnd
string 		ls_filter
decimal{4}	ld_days, ld_rate
string			ls_ratetype

/* set which rate to use in calculation */
choose case ai_calctype
	case 1	/* Hire Calculation Total Rate ( bareboat + save DRC) */
		ls_ratetype = "totalrate"
	case 2	/* Off Service Calculation Bareboat Rate  */
		ls_ratetype = "bareboat_hire"
	case 3	/* Off Service Calculation save DRC Rate  */
		ls_ratetype = "savedrc"
	case else
		MessageBox("Error", "No rate type given. Contact System Administrator~n~r" +&
						"Object: n_opsa_calculation, function: of_calcAmountDailyRate()")
		rollBack;
		return -1
end choose	
		
/* Get dates for filter and filter so Rates only have relevant records left */
ls_filter = "datetime('" + string(adt_start , "yyyy-mmm-dd hh:mm") + "') < period_end and " &
				+ "datetime('" + string(adt_end, "yyyy-mmm-dd hh:mm") + "') > period_start"
ids_rates.setFilter(ls_filter)
ids_rates.Filter()
ids_rates.Sort()

ad_amount = 0

/* set payment details */
choose case ids_rates.rowCount()
	case 0  /* no rates periode matching payment periode - impossible scenario */
		MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
						"Object: n_opsa_calculation, function: of_calcAmountDailyRate()")
		rollBack;
		return -1
	case 1  /* only one rate periode matching payment periode */
			ld_days = (f_datetime2long(adt_end) - f_datetime2long(adt_start)) / 86400
			ld_rate = ids_rates.getItemNumber(1, ls_ratetype) 
			ad_amount += (ld_days * ld_rate)
	case else /* payment covers several rate periods */
		ll_rates = ids_rates.Rowcount()
		for ll_rateIdx = 1 to ll_rates
			/* Set start of detail */
			if ll_rateIdx = 1 then     
				ldt_detailStart = adt_start
			else
				ldt_detailStart = ids_rates.getItemDatetime(ll_rateIdx, "period_start")
			end if
			/* Set end of detail */
			if ll_rateIdx = ll_rates then   
				ldt_detailEnd =adt_end
			else
				ldt_detailEnd = ids_rates.getItemDatetime(ll_rateIdx, "period_end")
			end if
			ld_days = (f_datetime2long(ldt_detailEnd) - f_datetime2long(ldt_detailStart)) / 86400
			ld_rate = ids_rates.getItemNumber(ll_rateIdx, ls_ratetype)
			ad_amount += (ld_days * ld_rate)
		next					
end choose

return 1
end function

public function integer of_calcamountmonthlyrate (datetime adt_start, datetime adt_end, ref decimal ad_amount, integer ai_calctype);/* This function calculates bareboat hire when rate is defined as monthly */

long 			ll_rateIdx, ll_rates
datetime		ldt_rateStart, ldt_rateEnd
datetime 	ldt_detailStart, ldt_detailEnd
datetime 	ldt_extraDate /* used when payment covers month shift */
string 		ls_filter
decimal{4}	ld_days, ld_rate
string			ls_ratetype

/* set which rate to use in calculation */
choose case ai_calctype
	case 1	/* Hire Calculation Total Rate ( bareboat + save DRC) */
		ls_ratetype = "totalrate"
	case 2	/* Off Service Calculation Bareboat Rate  */
		ls_ratetype = "bareboat_hire"
	case 3	/* Off Service Calculation save DRC Rate  */
		ls_ratetype = "savedrc"
	case else
		MessageBox("Error", "No rate type given. Contact System Administrator~n~r" +&
						"Object: n_opsa_calculation, function: of_calcAmountDailyRate()")
		rollBack;
		return -1
end choose	

ad_amount = 0

/* Get dates for filter and filter so Rates only have relevant records left */
ls_filter = "datetime('" + string(adt_start, "yyyy-mmm-dd hh:mm") + "') < period_end and " &
				+ "datetime('" + string(adt_end, "yyyy-mmm-dd hh:mm") + "') > period_start"
ids_rates.setFilter(ls_filter)
ids_rates.Filter()
ids_rates.Sort()
/* set payment details */
choose case ids_rates.rowCount()
	case 0  /* no rates periode matching payment periode - impossible scenario */
		MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
									"Object: n_opsa_calculation, function: of_calcAmountMonthlyRate()")
		rollBack;
		return -1 
	case 1  /* only one rate periode matching payment periode */
		if not of_isPeriodeFullMonth(adt_start, adt_end) then
			/* if  not full month then calculation is partial */
			if month(date(adt_start)) <> &
									month(date(f_long2datetime(f_datetime2long(adt_end) - 1))) then
				ldt_extraDate = datetime(date(Year(date(adt_end)), month(date(adt_end)), 01))					
				ld_days = (f_datetime2long(ldt_extraDate) - f_datetime2long(adt_start)) / 86400
				/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
					before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
				ld_rate = ids_rates.getItemNumber(1, ls_ratetype ) / &
								of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_extraDate) - 1)))
				ad_amount += (ld_days * ld_rate)
				adt_start = ldt_extraDate
			end if
			ld_days = (f_datetime2long(adt_end) - f_datetime2long(adt_start)) / 86400
			/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
				before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
			ld_rate = ids_rates.getItemNumber(1, ls_ratetype) / &
							of_lastDayofMonth(date(f_long2datetime(f_datetime2long(adt_end) - 1)))
			ad_amount += (ld_days * ld_rate)
		else  
			/* full month  - no special needs */ 
			ad_amount = ids_rates.getItemNumber(1, ls_ratetype)
		end if
	case else /* period covers several rate periods */
		ll_rates = ids_rates.Rowcount()
		for ll_rateIdx = 1 to ll_rates
			/* Set start of detail */
			if ll_rateIdx = 1 then     
				ldt_detailStart = adt_start
			else
				ldt_detailStart = ids_rates.getItemDatetime(ll_rateIdx, "period_start")
			end if
			/* Set end of detail */
			if ll_rateIdx = ll_rates then   
				ldt_detailEnd = adt_end
			else
				ldt_detailEnd = ids_rates.getItemDatetime(ll_rateIdx, "period_end")
			end if
			
			if month(date(ldt_detailStart)) <> &
									month(date(f_long2datetime(f_datetime2long(ldt_detailEnd) - 1))) then
				/* if period covers month shift  - one extra payment detail*/
				ldt_extraDate = datetime(date(Year(date(ldt_detailEnd)), month(date(ldt_detailEnd)), 01))					
				ld_days = (f_datetime2long(ldt_extraDate) - f_datetime2long(ldt_detailStart)) / 86400
				/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
					before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
				ld_rate = ids_rates.getItemNumber(ll_rateIdx, ls_ratetype) / &
								of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_extraDate) - 1)))
				ad_amount += (ld_days * ld_rate)
				ldt_detailStart = ldt_extraDate
			end if
			ld_days = (f_datetime2long(ldt_detailEnd) - f_datetime2long(ldt_detailStart)) / 86400
			/* To avoid problems with payments ending 01-mm-yy 00:00 one secound is subtracted
				before # of days in month is called (01-01-01 00:00 -> 31-12-00 23:59) */
			ld_rate = ids_rates.getItemNumber(ll_rateIdx, ls_ratetype) / &
							of_lastDayofMonth(date(f_long2datetime(f_datetime2long(ldt_detailEnd)-1)))
			ad_amount += (ld_days * ld_rate)
		next					
end choose

return 1
end function

public function integer of_post_opsa_offservice (s_transaction_input astr_trans_input);u_transaction_opsa_ofs_bareboat_coda		lnv_opsa_bareboat_trans
u_transaction_opsa_ofs_savedrc_coda		lnv_opsa_savedrc_trans
integer												li_bareboat, li_saveDRC
long													ll_contractID, ll_minutes
long													ll_rows, ll_row, ll_found
datetime												ldt_start
decimal {4}											ld_days, ld_bareboat_rate, ld_savedrc_rate

ll_contractID = astr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

/* Check if any period given -  bareboat  */
SELECT COUNT(OPSA_PERIOD_ID)  
	INTO :li_bareboat  
	FROM NTC_OPSA_PERIOD  
	WHERE NTC_OPSA_PERIOD.CONTRACT_ID = :ll_contractID;
if sqlca.sqlcode <> 0 then
	MessageBox("Select error", "Select COUNT(OPSA_PERIOD_ID) from OPSA_PERIOD failed!. Object: u_transaction_hire_rec_coda, function: of_offservice_bpost")
	Return(-1)
END IF
/* Check if there also saveDRC rate is given */
SELECT COUNT(OPSA_SAVE_DRC)  
	INTO :li_saveDRC  
	FROM NTC_OPSA_PERIOD  
	WHERE NTC_OPSA_PERIOD.CONTRACT_ID = :ll_contractID
	AND NTC_OPSA_PERIOD.OPSA_SAVE_DRC IS NOT NULL;
if sqlca.sqlcode <> 0 then
	MessageBox("Select error", "Select COUNT(OPSA_SAVE_DRC) from OPSA_PERIOD failed!. Object: n_opsa_calculation, function: of_post_opsa_offservice")
	Return(-1)
END IF

/* Get rates */
if li_bareboat > 0 or li_saveDRC > 0 then
	of_setrates( ll_contractID )
end if

/* Split Off Service period(s) */
if of_setoffservicedetail( astr_trans_input.tc_offservice_id ) = -1 then
	MessageBox("Error", "Select COUNT(OPSA_SAVE_DRC) from OPSA_PERIOD failed!. Object: n_opsa_calculation, function: of_post_opsa_offservice")
	Return(-1)
end if	

/********** Check Bareboat / SaveDRC and post OPSA transactions **********/ 
ll_rows = ids_offservice_details.rowcount( )
for ll_row = 1 to ll_rows
	ldt_start 		= ids_offservice_details.getItemDatetime(ll_row, "start_date")
	ll_minutes 	= ids_offservice_details.getItemNumber(ll_row, "minutes")
	ld_days		= ll_minutes / 1440

	astr_trans_input.opsa_offservice_detail_date = ldt_start
	
	ll_found = ids_rates.find("datetime('" + string(ldt_start, "yyyy-mmm-dd hh:mm") + "') < period_end and " &
						+ "datetime('" + string(ldt_start, "yyyy-mmm-dd hh:mm") + "') >= period_start", 1, 99999)
	if ll_found < 1 then
		MessageBox("Error", "OPSA Rate not found!. Object: n_opsa_calculation, function: of_post_opsa_offservice")
		Return(-1)
	end if
	
	if li_bareboat > 0 then
		if astr_trans_input.settle_tc_payment.getItemNumber(1, "monthly_rate") = 1 then
			ld_bareboat_rate = ids_rates.getItemDecimal(ll_found, "bareboat_hire")/of_lastdayofmonth( date (ldt_start))
		else
			ld_bareboat_rate = ids_rates.getItemDecimal(ll_found, "bareboat_hire")
		end if
		astr_trans_input.opsa_offservice_detail_amount = (ld_days * ld_bareboat_rate) *100   //as transactions are without decimals 
		lnv_opsa_bareboat_trans = create u_transaction_opsa_ofs_bareboat_coda
		if lnv_opsa_bareboat_trans.of_generate_transaction( astr_trans_input ) = -1 then
			MessageBox("OPSA transaction", "Gereration of OPSA Setup OffService bareboat transaction failed!")
			destroy lnv_opsa_bareboat_trans 
			return -1
		end if
		destroy lnv_opsa_bareboat_trans
	end if	
	if li_saveDRC > 0 then
		if astr_trans_input.settle_tc_payment.getItemNumber(1, "monthly_rate") = 1 then
			ld_savedrc_rate = ids_rates.getItemDecimal(ll_found, "savedrc")/of_lastdayofmonth( date (ldt_start))
		else
			ld_savedrc_rate = ids_rates.getItemDecimal(ll_found, "savedrc")
		end if
		astr_trans_input.opsa_offservice_detail_amount = (ld_days * ld_savedrc_rate) *100   //as transactions are without decimals 
		lnv_opsa_savedrc_trans = create u_transaction_opsa_ofs_savedrc_coda
		if lnv_opsa_savedrc_trans.of_generate_transaction( astr_trans_input ) = -1 then
			MessageBox("OPSA transaction", "Gereration of OPSA Setup OffService SaveDRC transaction failed!")
			destroy  lnv_opsa_savedrc_trans 
			return -1
		end if
		destroy  lnv_opsa_savedrc_trans
	end if
next

return 1
end function

public function integer of_setoffservicedetail (long al_detailid);/*
Description: 	Retrieves all Offservices and if not splitted into months, split them. 
*/
long 			ll_row, ll_rows, ll_newrow
datetime		ldt_start, ldt_end, ldt_calc
decimal 		ld_factor
integer		li_mm, li_yy
long			ll_minutes
string			ls_filter

ids_offservice_details .reset( )
ids_offservice_details.dataObject = "d_payment_settle_offservice_detail_opsa"
ids_offservice_details.setTransObject(SQLCA)
  
ll_rows = ids_offservice_details.retrieve(al_detailID)

if ll_rows < 1 then return 1

ld_factor = ids_offservice_details.getItemDecimal(1, "reduce_increase")

/* Split periods into months if period larger than month  - as OPSA must be periodised right */
for ll_row = 1 to ll_rows
	ldt_start = ids_offservice_details.getitemDatetime(ll_row, "start_date")
	ldt_end = ids_offservice_details.getitemDatetime(ll_row, "end_date")
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
		ll_newrow = ids_offservice_details.insertRow(0)
		ids_offservice_details.setItem(ll_newrow, "start_date", ldt_start)
		ids_offservice_details.setItem(ll_newrow, "end_date", ldt_calc)
		ll_minutes = round((((f_datetime2long(ldt_calc)/60) - (f_datetime2long(ldt_start)/60))*ld_factor),0)
		ids_offservice_details.setItem(ll_newrow, "minutes", ll_minutes)
				
		ldt_start = ldt_calc
	LOOP
	ids_offservice_details.deleteRow(ll_row)
next
ids_offservice_details.setSort("start_date A")
ids_offservice_details.sort()

ids_offservice_details.setSort("")

/* Split Offservices according to OPSA rate periods */
ll_rows = ids_offservice_details.rowCount()
for ll_row = 1 to ll_rows
	ldt_start = ids_offservice_details.getitemDatetime(ll_row, "start_date")
	ldt_end = ids_offservice_details.getitemDatetime(ll_row, "end_date")

	/* Get dates for filter and filter so Rates only have relevant records left */
	ls_filter = "datetime('" + string(ldt_start, "yyyy-mmm-dd hh:mm") + "') < period_end and " &
					+ "datetime('" + string(ldt_end, "yyyy-mmm-dd hh:mm") + "') > period_start"
	ids_rates.setFilter(ls_filter)
	ids_rates.Filter()
	ids_rates.Sort()
	choose case ids_rates.rowCount()
		case 0  /* no rates periode matching payment periode - impossible scenario */
			MessageBox("Error", "You have a big problem. No rate periode found. Contact System Administrator~n~r" +&
										"Object: n_opsa_calculation, function: of_setOffServiceDetail()")
			return -1 
		case 1  
			// OK
		case else /* period covers several rate periods */
			ldt_calc = ids_rates.getItemDatetime(1, "period_end")
			ids_offservice_details.setItem(ll_row, "end_date", ldt_calc)
			ll_minutes = round((((f_datetime2long(ldt_calc)/60) - (f_datetime2long(ldt_start)/60))*ld_factor),0)
			ids_offservice_details.setItem(ll_row, "minutes", ll_minutes)

			ll_newrow = ids_offservice_details.insertRow(0)
			ids_offservice_details.setItem(ll_newrow, "start_date", ldt_calc)
			ids_offservice_details.setItem(ll_newrow, "end_date", ldt_end)
			ll_minutes = round((((f_datetime2long(ldt_end)/60) - (f_datetime2long(ldt_calc)/60))*ld_factor),0)
			ids_offservice_details.setItem(ll_newrow, "minutes", ll_minutes)
	end choose
next
ids_offservice_details.setSort("start_date A")
ids_offservice_details.sort()

ids_rates.setFilter("")
ids_rates.Filter()
ids_rates.Sort()

return 1
end function

on n_opsa_calculation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_opsa_calculation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_rates = create n_ds
ids_offservice_details = create n_ds

end event

event destructor;destroy ids_rates
destroy ids_offservice_details
end event

