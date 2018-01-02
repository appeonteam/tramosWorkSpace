$PBExportHeader$n_manual_tc_commission.sru
forward
global type n_manual_tc_commission from nonvisualobject
end type
end forward

global type n_manual_tc_commission from nonvisualobject
end type
global n_manual_tc_commission n_manual_tc_commission

type variables
s_manual_create_tccommission	istr_parm
end variables

forward prototypes
public function decimal of_calcbrokercommission (long al_paymentid, long al_broker_nr)
public function string of_getvoyagenumber (long al_paymentid)
public function long of_createcommission (long al_broker_nr)
end prototypes

public function decimal of_calcbrokercommission (long al_paymentid, long al_broker_nr);/* This function calculates broker commission amount for a given payment/broker
*/

long			ll_rows, ll_rowno
long			ll_contractID
decimal{2}	ld_broker_pct, ld_broker_per_day
decimal{2}	ld_broker_comm
decimal{2}	ld_hire, ld_offservice
decimal{4}	ld_hire_days, ld_offservice_days
datetime		ldt_start, ldt_end
	
SELECT CONTRACT_ID 
	INTO :ll_contractID
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID = :al_paymentID;
	
SELECT isnull(NTC_CONT_BROKER_COMM.BROKER_COMM,0)  
	INTO :ld_broker_pct  
	FROM NTC_CONT_BROKER_COMM  
	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :ll_contractID ) AND
			( NTC_CONT_BROKER_COMM.BROKER_NR = :al_broker_nr ) AND 
			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 0);

SELECT isnull(NTC_CONT_BROKER_COMM.BROKER_COMM,0)  
	INTO :ld_broker_per_day  
	FROM NTC_CONT_BROKER_COMM  
	WHERE ( NTC_CONT_BROKER_COMM.CONTRACT_ID = :ll_contractID ) AND  
			( NTC_CONT_BROKER_COMM.BROKER_NR = :al_broker_nr ) AND 
			( NTC_CONT_BROKER_COMM.AMOUNT_PER_DAY_OR_PERCENT = 1);

SELECT isNull(sum(NTC_PAYMENT_DETAIL.QUANTITY * NTC_PAYMENT_DETAIL.RATE),0),
		min(NTC_PAYMENT_DETAIL.PERIODE_START),
		max(NTC_PAYMENT_DETAIL.PERIODE_END)
	INTO :ld_hire,
		:ldt_start,
		:ldt_end
	FROM NTC_PAYMENT_DETAIL  
	WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID = :al_paymentID   ;
	
SELECT isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS * NTC_OFF_SERVICE_DETAIL.RATE),0),
		isNull(sum(NTC_OFF_SERVICE_DETAIL.DAYS),0)
	INTO :ld_offservice,
		:ld_offservice_days
	FROM NTC_OFF_SERVICE, NTC_OFF_SERVICE_DETAIL  
	WHERE ( NTC_OFF_SERVICE_DETAIL.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID ) and  
			(( NTC_OFF_SERVICE.PAYMENT_ID = :al_paymentID ));

ld_hire_days = timedifference(ldt_start, ldt_end)/1440
ld_broker_comm = (((ld_hire - ld_offservice) / 100) * ld_broker_pct) &
					+ ((ld_hire_days - ld_offservice_days) * ld_broker_per_day)
	

return ld_broker_comm

end function

public function string of_getvoyagenumber (long al_paymentid);datetime ldt_est_duedate
string	ls_voyage

SELECT NTC_PAYMENT.EST_DUE_DATE  
	INTO :ldt_est_duedate  
	FROM NTC_PAYMENT  
	WHERE NTC_PAYMENT.PAYMENT_ID = :al_paymentID  ;

ls_voyage = ""
SELECT isnull(NTC_TC_PERIOD.TCOUT_VOYAGE_NR,"")  
	INTO :ls_voyage  
	FROM NTC_TC_PERIOD  
	WHERE NTC_TC_PERIOD.PERIODE_START <= :ldt_est_duedate
	AND NTC_TC_PERIOD.PERIODE_END > :ldt_est_duedate
	AND NTC_TC_PERIOD.CONTRACT_ID = :istr_parm.al_contractID ;

return ls_voyage
end function

public function long of_createcommission (long al_broker_nr);long 			ll_commID, ll_row
n_ds			lds_data
decimal {2}	ld_amount
string		ls_voyage

istr_parm.al_broker_nr = al_broker_nr

openwithparm(w_manual_create_tccommission, istr_parm)
istr_parm = message.powerObjectParm

if isNull(istr_parm.al_paymentID) then return -1

/* Hvis TC-in med markering for set-off skal der blot komme 
	en messagebox at man skal huske at gøre tingene manuelt   */	
if istr_parm.ai_tchire_in = 1 and istr_parm.ai_setoff = 1 then
	MessageBox("Information", "This combination TC-in and Set-off must be done manually to make sure CODA is updated correct")
	return -1
end if

/* calculate commission amount */
ld_amount = of_calcBrokerCommission( istr_parm.al_paymentID, istr_parm.al_broker_nr)

lds_data = create n_ds
lds_data.dataObject = "d_table_ntc_commission"
lds_data.setTransObject(SQLCA)
ll_row = lds_data.insertRow(0)
if ll_row < 1 then 
	destroy lds_data
	return -1
end if

if istr_parm.ai_tchire_in = 1 then
	ls_voyage = "REV"
else
	ls_voyage = of_getVoyageNumber(istr_parm.al_paymentID)	
end if

lds_data.setItem(ll_row, "payment_id", istr_parm.al_paymentID)
lds_data.setItem(ll_row, "broker_nr", al_broker_nr)
lds_data.setItem(ll_row, "amount", ld_amount)
lds_data.setItem(ll_row, "voyage_nr", ls_voyage)

if istr_parm.ai_setoff = 0 then
	lds_data.setItem(ll_row, "inv_nr", "do not settle")
else
	lds_data.setItem(ll_row, "inv_nr", "paid via hire")
	lds_data.setItem(ll_row, "comm_settle_date", istr_parm.adt_payment_settle)
	MessageBox("Information", "Please remember to make sure CODA is updated correct. This combination TC-out and Set-off must manually be added to hire statement ")
end if	

if lds_data.update() = 1 then
	commit;
else
	rollback;
	destroy lds_data
	return -1
end if

ll_commID = lds_data.getItemNumber(ll_row, "ntc_comm_id")

destroy lds_data
return ll_commID
end function

on n_manual_tc_commission.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_manual_tc_commission.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

