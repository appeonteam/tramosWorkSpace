$PBExportHeader$n_offservice.sru
$PBExportComments$Business Logig for Off-Service window
forward
global type n_offservice from mt_n_nonvisualobject
end type
end forward

global type n_offservice from mt_n_nonvisualobject
end type
global n_offservice n_offservice

type variables
private:
integer							ii_vessel_nr
s_off_service				 	istr_off_service
s_tc_trans_fuel 				istr_fuel
mt_n_datastore					ids_tc_contracts 
mt_n_datastore					ids_tc_offservice
long 								il_paymentIDArray[]

decimal {2}						ld_hfoPrice, ld_doPrice, ld_goPrice


end variables

forward prototypes
public subroutine of_setVessel (integer ai_vessel)
public function integer of_modifyrow (datawindow adw, long al_row)
public function integer of_insertrow (datawindow adw)
public function integer of_newtctransfer (datawindow adw)
public function integer of_getvasindicator (ref datawindow adw)
public function integer of_fuelprice (datawindow adw)
public function integer of_deletetctransfer (datawindow adw)
public function integer of_deleterow (datawindow adw, long al_row)
public function integer of_update (datawindow adw)
public function integer of_setoperationskey (ref datawindow adw_ops, ref datastore ads_tc)
public function integer of_voyagefinishvalidate (integer ai_vessel_nr, string as_voyage_nr)
private function integer of_validate (datawindow adw)
private subroutine of_setprevioustransfer (ref datawindow adw_offservice)
public subroutine documentation ()
public function integer of_getreadonlystatus (long al_ops_off_service_id)
public function long of_tcin_transfer ()
public function long of_tcout_transfer ()
public function integer of_getpaymentstatusdescription (long al_ops_off_service_id, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id)
public function integer of_getpaymentstatusdescription (datawindow adw, long al_row, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id)
end prototypes

public subroutine of_setVessel (integer ai_vessel);ii_vessel_nr = ai_vessel

Return
end subroutine

public function integer of_modifyrow (datawindow adw, long al_row);integer li_trans_to_coda

/* Set variables */
istr_off_service.ops_off_service_id = adw.getItemNumber(al_row, "ops_off_service_id")
/* Check that offservice not settled while window open */
SELECT MAX(TRANS_TO_CODA)
	INTO :li_trans_to_coda
	FROM NTC_OFF_SERVICE
	WHERE OPS_OFF_SERVICE_ID = :istr_off_service.ops_off_service_id;
if li_trans_to_coda	> 0 then
	adw.setItem(al_row, "trans_to_coda", 1)
//	MessageBox("Information", "Off-Service settled in TC Module while this window open") 
//	return 1
end if
istr_off_service.port_code 		= adw.getItemString(al_row, "port_code")
istr_off_service.vessel_nr 		= adw.getItemNumber(al_row, "vessel_nr")
istr_off_service.voyage_nr 		= adw.getItemString(al_row, "voyage_nr")
istr_off_service.off_start 			= adw.getItemDatetime(al_row, "off_start")
istr_off_service.off_end 			= adw.getItemDatetime(al_row, "off_end")
istr_off_service.days				= adw.getItemNumber(al_row, "off_time_days" )
istr_off_service.hours				= adw.getItemNumber(al_row, "off_time_hours" )
istr_off_service.minutes			= adw.getItemNumber(al_row, "off_time_minutes" )
istr_off_service.fuel_oil			= adw.getItemDecimal(al_row, "off_fuel_oil_used" )
istr_off_service.diesel_oil		= adw.getItemDecimal(al_row, "off_diesel_oil_used" )
istr_off_service.gas_oil			= adw.getItemDecimal(al_row, "off_gas_oil_used" )
istr_off_service.lshfo_oil			= adw.getItemDecimal(al_row, "off_lshfo_oil_used") 
istr_off_service.hfo_start			= adw.getItemDecimal(al_row, "hfo_stock_start") 
istr_off_service.hfo_end			= adw.getItemDecimal(al_row, "hfo_stock_end") 
istr_off_service.do_start			= adw.getItemDecimal(al_row, "do_stock_start") 
istr_off_service.do_end			= adw.getItemDecimal(al_row, "do_stock_end") 
istr_off_service.go_start			= adw.getItemDecimal(al_row, "go_stock_start") 
istr_off_service.go_end			= adw.getItemDecimal(al_row, "go_stock_end") 
istr_off_service.lshfo_start		= adw.getItemDecimal(al_row, "lshfo_stock_start") 
istr_off_service.lshfo_end		= adw.getItemDecimal(al_row, "lshfo_stock_end") 
istr_off_service.description 		= adw.getItemString(al_row, "off_description" )
istr_off_service.comment		= adw.getItemString(al_row, "comments" ) 
istr_off_service.trans_to_tcin	= adw.getItemNumber(al_row, "trans_to_in" ) 
istr_off_service.trans_to_tcout	= adw.getItemNumber(al_row, "trans_to_out" )
istr_off_service.transfer_saved  = 1

if adw.getItemNumber(al_row, "trans_to_coda" ) = 1 then
	istr_off_service.trans_to_coda	= true
else
	istr_off_service.trans_to_coda	= false
end if	

if adw.getItemNumber(al_row, "off_scheduled") = 1 then 
	istr_off_service.scheduled = true
else
	istr_off_service.scheduled = false
end if

/* Call the Off-service edit window */
istr_off_service.businessObject = this
istr_off_service.new_record = false
openwithparm(w_edit_single_offservice, istr_off_service)
istr_off_service = message.powerObjectParm
/* If any data entered fill in. Otherwise return */
if isnull(istr_off_service.port_code) then return 1
/* set vessel_nr, voyage and port_code in new row */
adw.setItem(al_row, "ops_off_service_id", istr_off_service.ops_off_service_id )
adw.setItem(al_row, "port_code", istr_off_service.port_code)
adw.setItem(al_row, "vessel_nr", istr_off_service.vessel_nr)
adw.setItem(al_row, "voyage_nr", istr_off_service.voyage_nr)
adw.setItem(al_row, "off_start", istr_off_service.off_start)
adw.setItem(al_row, "off_end", istr_off_service.off_end)
adw.setItem(al_row, "off_time_days", istr_off_service.days)
adw.setItem(al_row, "off_time_hours", istr_off_service.hours)
adw.setItem(al_row, "off_time_minutes", istr_off_service.minutes)
adw.setItem(al_row, "off_fuel_oil_used", istr_off_service.fuel_oil)
adw.setItem(al_row, "off_diesel_oil_used", istr_off_service.diesel_oil)
adw.setItem(al_row, "off_gas_oil_used", istr_off_service.gas_oil)
adw.setItem(al_row, "off_lshfo_oil_used", istr_off_service.lshfo_oil)
adw.setItem(al_row, "hfo_stock_start", istr_off_service.hfo_start)
adw.setItem(al_row, "hfo_stock_end", istr_off_service.hfo_end)
adw.setItem(al_row, "do_stock_start", istr_off_service.do_start)
adw.setItem(al_row, "do_stock_end", istr_off_service.do_end)
adw.setItem(al_row, "go_stock_start", istr_off_service.go_start)
adw.setItem(al_row, "go_stock_end", istr_off_service.go_end)
adw.setItem(al_row, "lshfo_stock_start", istr_off_service.lshfo_start)
adw.setItem(al_row, "lshfo_stock_end", istr_off_service.lshfo_end)
adw.setItem(al_row, "off_description", istr_off_service.description)
adw.setItem(al_row, "comments", istr_off_service.comment)

if istr_off_service.scheduled = true then
	adw.setItem(al_row, "off_scheduled", 1)
else
	adw.setItem(al_row, "off_scheduled", 0)
end if

/* refresh datawindow */
adw.setRedraw(false)
adw.Retrieve(istr_off_service.vessel_nr)
al_row = adw.find("ops_off_service_id=" + string(istr_off_service.ops_off_service_id), 0, adw.rowCount())
adw.scrolltoRow(al_row)
adw.setFocus()
adw.setRedraw(true)

return 1
end function

public function integer of_insertrow (datawindow adw);Long ll_row

istr_off_service.vessel_nr = ii_vessel_nr
// Open window w_select_voyage_and_port_code to let the user choose the voyage and port */
OpenWithParm( w_select_voyage_and_port_code , istr_off_service )
istr_off_service = Message.PowerObjectParm
/* if returned voyage_nr is null quit insert */
IF IsNull( istr_off_service.voyage_nr ) THEN Return -1
adw.selectRow(0,FALSE)
/* Call the Off-service edit window */
istr_off_service.businessObject = this
setNull(istr_off_service.off_start)
setNull(istr_off_service.off_end)
setNull(istr_off_service.days)
setNull(istr_off_service.hours)
setNull(istr_off_service.minutes)
setNull(istr_off_service.fuel_oil)
setNull(istr_off_service.diesel_oil)
setNull(istr_off_service.gas_oil)
setNull(istr_off_service.lshfo_oil)
setNull(istr_off_service.hfo_start)
setNull(istr_off_service.hfo_end)
setNull(istr_off_service.do_start)
setNull(istr_off_service.do_end)
setNull(istr_off_service.go_start)
setNull(istr_off_service.go_end)
setNull(istr_off_service.lshfo_start)
setNull(istr_off_service.lshfo_end)
setNull(istr_off_service.description)
setNull(istr_off_service.comment )
istr_off_service.trans_to_coda  = false
setNull(istr_off_service.trans_to_tcin )
setNull(istr_off_service.trans_to_tcout )
setNull(istr_off_service.ops_off_service_id)
istr_off_service.scheduled = false
istr_off_service.new_record = true
istr_off_service.transfer_saved = 0
openwithparm(w_edit_single_offservice, istr_off_service)
istr_off_service = message.powerObjectParm
/* If any data entered fill in. Otherwise return */
if isnull(istr_off_service.port_code) then return 1
ll_row = adw.InsertRow(0)
/* set vessel_nr, voyage and port_code in new row */
adw.setItem(ll_row, "ops_off_service_id", istr_off_service.ops_off_service_id)
adw.setItem(ll_row, "port_code", istr_off_service.port_code)
adw.setItem(ll_row, "vessel_nr", istr_off_service.vessel_nr)
adw.setItem(ll_row, "voyage_nr", istr_off_service.voyage_nr)
adw.setItem(ll_row, "off_start", istr_off_service.off_start)
adw.setItem(ll_row, "off_end", istr_off_service.off_end)
adw.setItem(ll_row, "off_time_days", istr_off_service.days)
adw.setItem(ll_row, "off_time_hours", istr_off_service.hours)
adw.setItem(ll_row, "off_time_minutes", istr_off_service.minutes)
adw.setItem(ll_row, "off_fuel_oil_used", istr_off_service.fuel_oil)
adw.setItem(ll_row, "off_diesel_oil_used", istr_off_service.diesel_oil)
adw.setItem(ll_row, "off_gas_oil_used", istr_off_service.gas_oil)
adw.setItem(ll_row, "off_lshfo_oil_used", istr_off_service.lshfo_oil)
adw.setItem(ll_row, "hfo_stock_start", istr_off_service.hfo_start)
adw.setItem(ll_row, "hfo_stock_end", istr_off_service.hfo_end)
adw.setItem(ll_row, "do_stock_start", istr_off_service.do_start)
adw.setItem(ll_row, "do_stock_end", istr_off_service.do_end)
adw.setItem(ll_row, "go_stock_start", istr_off_service.go_start)
adw.setItem(ll_row, "go_stock_end", istr_off_service.go_end)
adw.setItem(ll_row, "lshfo_stock_start", istr_off_service.lshfo_start)
adw.setItem(ll_row, "lshfo_stock_end", istr_off_service.lshfo_end)
adw.setItem(ll_row, "off_description", istr_off_service.description)
adw.setItem(ll_row, "comments", istr_off_service.comment )

if istr_off_service.scheduled = true then
	adw.setItem(ll_row, "off_scheduled", 1)
else
	adw.setItem(ll_row, "off_scheduled", 0)
end if
adw.setItem(ll_row, "trans_to_coda", 0)
/* refresh datawindow */
adw.setRedraw(false)
adw.Retrieve(istr_off_service.vessel_nr)
ll_row = adw.find("ops_off_service_id=" + string(istr_off_service.ops_off_service_id), 0, adw.rowCount())
adw.scrolltoRow(ll_row)
adw.setFocus()
adw.SetColumn("off_start")
adw.setRedraw(true)

return 1
end function

public function integer of_newtctransfer (datawindow adw);/*
	Her skal der blot oprettes en record pr. contract og overføres til TC modulet
	gennemløb adw og check om transfer er yes or no- hvis yes transfer
	
	husk ingen update i denne funktion
*/
long 				ll_contracts, ll_row, ll_newRow
n_tc_payment	lnv_payment
long				ll_contract_id
string			ls_tc_currency
decimal {6}		ld_exrate_bunker, ld_exrate_usd, ld_exrate_tc
long           ll_tc_hire_in

ll_contracts = ids_tc_contracts.rowCount()

if ll_contracts < 1 then return 1

lnv_payment = create n_tc_payment
for ll_row = 1 to ll_contracts
	ll_tc_hire_in = ids_tc_contracts.getitemnumber(ll_row, "ntc_tc_contract_tc_hire_in")
	if ids_tc_contracts.getItemNumber(ll_row, "transfer") = 1 then
		ll_newRow = ids_tc_offservice.Insertrow(0)
		ll_contract_id = ids_tc_contracts.getItemNumber(ll_row, "contract_id")
		ids_tc_offservice.setItem(ll_newRow, "payment_id", &
					lnv_payment.of_getFirstUnpaid(ll_contract_id))
		ids_tc_offservice.setItem(ll_newRow, "start_date", adw.getItemDatetime(1, "off_start"))
		ids_tc_offservice.setItem(ll_newRow, "end_date", adw.getItemDatetime(1, "off_end"))
		ids_tc_offservice.setItem(ll_newRow, "hours", &
				adw.getItemNumber(1, "off_time_days")*24 + adw.getItemNumber(1, "off_time_hours"))
		ids_tc_offservice.setItem(ll_newRow, "minutes", adw.getItemNumber(1, "off_time_minutes"))
		
		ids_tc_offservice.setItem(ll_newRow, "hfo_ton", istr_fuel.sd_amount_hfo)
		ids_tc_offservice.setItem(ll_newRow, "do_ton", istr_fuel.sd_amount_do)
		ids_tc_offservice.setItem(ll_newRow, "go_ton", istr_fuel.sd_amount_go)
		ids_tc_offservice.setItem(ll_newRow, "lshfo_ton", istr_fuel.sd_amount_lshfo)
		
		if ll_tc_hire_in = 1 then
			ids_tc_offservice.setItem(ll_newRow, "hfo_price", istr_fuel.sd_price_hfo)
			ids_tc_offservice.setItem(ll_newRow, "do_price", istr_fuel.sd_price_do)
			ids_tc_offservice.setItem(ll_newRow, "go_price", istr_fuel.sd_price_go)
			ids_tc_offservice.setItem(ll_newRow, "lshfo_price", istr_fuel.sd_price_lshfo)
			ids_tc_offservice.setItem(ll_newRow, "hfo_sel", istr_fuel.hfo_sel_in)
			ids_tc_offservice.setItem(ll_newRow, "do_sel", istr_fuel.do_sel_in)
			ids_tc_offservice.setItem(ll_newRow, "go_sel", istr_fuel.go_sel_in)
			ids_tc_offservice.setItem(ll_newRow, "lshfo_sel", istr_fuel.lshfo_sel_in)
		else
			ids_tc_offservice.setItem(ll_newRow, "hfo_price", istr_fuel.sd_price_hfo_out)
			ids_tc_offservice.setItem(ll_newRow, "do_price", istr_fuel.sd_price_do_out)
			ids_tc_offservice.setItem(ll_newRow, "go_price", istr_fuel.sd_price_go_out)
			ids_tc_offservice.setItem(ll_newRow, "lshfo_price", istr_fuel.sd_price_lshfo_out)
			ids_tc_offservice.setItem(ll_newRow, "hfo_sel", istr_fuel.hfo_sel_out)
			ids_tc_offservice.setItem(ll_newRow, "do_sel", istr_fuel.do_sel_out)
			ids_tc_offservice.setItem(ll_newRow, "go_sel", istr_fuel.go_sel_out)
			ids_tc_offservice.setItem(ll_newRow, "lshfo_sel", istr_fuel.lshfo_sel_out)
		end if
		
		ids_tc_offservice.setItem(ll_newRow, "hfo_stock_start", istr_fuel.sd_hfo_start)
		ids_tc_offservice.setItem(ll_newRow, "hfo_stock_end", istr_fuel.sd_hfo_end)
		ids_tc_offservice.setItem(ll_newRow, "do_stock_start", istr_fuel.sd_do_start)
		ids_tc_offservice.setItem(ll_newRow, "do_stock_end", istr_fuel.sd_do_end)
		ids_tc_offservice.setItem(ll_newRow, "go_stock_start", istr_fuel.sd_go_start)
		ids_tc_offservice.setItem(ll_newRow, "go_stock_end", istr_fuel.sd_go_end)
		ids_tc_offservice.setItem(ll_newRow, "lshfo_stock_start", istr_fuel.sd_lshfo_start)
		ids_tc_offservice.setItem(ll_newRow, "lshfo_stock_end", istr_fuel.sd_lshfo_end)
		ids_tc_offservice.setItem(ll_newRow, "use_in_vas", ids_tc_contracts.getItemNumber(ll_row, "use_in_vas")) 

		SELECT NTC_TC_CONTRACT.CURR_CODE  
			INTO :ls_tc_currency  
			FROM NTC_TC_CONTRACT  
			WHERE NTC_TC_CONTRACT.CONTRACT_ID = :ll_contract_id ;
		if ls_tc_currency = "USD" then
			ld_exrate_bunker = 100
		else
			SELECT EX1.EXRATE_DKK  
				INTO :ld_exrate_tc  
				FROM NTC_EXCHANGE_RATE EX1  
				WHERE ( EX1.CURR_CODE = :ls_tc_currency ) AND  
						( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
													FROM NTC_EXCHANGE_RATE EX2 
													WHERE EX2.CURR_CODE = :ls_tc_currency ) );
			IF isNull(ld_exrate_tc) OR ld_exrate_tc = 0 THEN
				MessageBox("Error", "Cant get Exchange Rate for TC Currency. Object: n_offservice, function: of_newTCtransfer")
				DESTROY lnv_payment
				Return -1 
			END IF
			
			SELECT EX1.EXRATE_DKK  
				INTO :ld_exrate_usd  
				FROM NTC_EXCHANGE_RATE EX1  
				WHERE ( EX1.CURR_CODE = "USD" ) AND  
						( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
													FROM NTC_EXCHANGE_RATE EX2 
													WHERE EX2.CURR_CODE = "USD" ) );
			IF isNull(ld_exrate_usd) OR ld_exrate_usd = 0 THEN
				MessageBox("Error", "Cant get Exchange Rate for USD. Object: n_offservice, function: of_newTCtransfer")
				DESTROY lnv_payment
				Return -1
			END IF
			ld_exrate_bunker = ( ld_exrate_usd / ld_exrate_tc ) * 100
		end if
		ids_tc_offservice.setItem(ll_newRow, "exchange_rate_usd", ld_exrate_bunker)
		ids_tc_offservice.setItem(ll_newRow, "ops_off_service_id", adw.getItemNumber(1, "ops_off_service_id"))
	end if
next 

destroy lnv_payment
return 1
end function

public function integer of_getvasindicator (ref datawindow adw);/*
	Denne funktion checker om off-service tidligere er overført til TC og 
	henter USE_IN_VAS indicatoren. Dette for denne ikke skal blive overskrevet
	såfremt den har været ændret.
	
	*/

long			ll_ops_offservice_id
long			ll_rows, ll_rowno, ll_found
n_ds			lds_VASIndicator

/* if no contracts, no reason to check anything */
if ids_tc_contracts.rowCount() < 1 then return 1

lds_VASIndicator = create n_ds
lds_VASIndicator.dataObject = "d_get_offservice_vas_indicator"
lds_VASIndicator.setTransObject(SQLCA)

ll_ops_offservice_id = adw.getItemNumber(1, "ops_off_service_id")
ll_rows = lds_VASIndicator.retrieve(ll_ops_offservice_id )
/* if no previous transfer, keep default values */
if ll_rows < 1 then
	destroy lds_VASIndicator
	return 1
end if

for ll_rowno = 1 to ll_rows
	ll_found = ids_tc_contracts.find("contract_id="+string(lds_VASIndicator.getItemNumber(ll_rowno, "contract_id")),1,ids_tc_contracts.rowcount())
	if ll_found > 0 then
		ids_tc_contracts.setItem(ll_found, "use_in_vas", lds_VASIndicator.getItemNumber(ll_rowno, "use_in_vas"))
	end if
next

destroy lds_VASIndicator
return 1
end function

public function integer of_fuelprice (datawindow adw);decimal {4}		ld_temp_var
decimal {4}		ld_hfo_price, ld_do_price, ld_go_price, ld_lshfo_price
long				ll_ops_offservice_id
integer        li_hfo_sel_in = 0, li_go_sel_in = 0, li_do_sel_in = 0, li_lshfo_sel_in = 0
decimal {4}		ld_hfo_price_out = 0, ld_do_price_out = 0, ld_go_price_out = 0, ld_lshfo_price_out = 0
integer        li_hfo_sel_out = 0, li_go_sel_out = 0, li_do_sel_out = 0, li_lshfo_sel_out = 0
boolean        lb_has_in, lb_has_out

/* Set Parameter structure to fuel window for T/C Hire transfer */
/* Set tc boolean as in or out */
/* Get Heavy Fuel Oil amount */
//ls_portcode 	= adw.getItemString(1, "port_code")
//li_vessel_nr 	= adw.getItemNumber(1, "vessel_nr")
//ls_voyage_nr 	= adw.getItemString(1, "voyage_nr")
//ldt_off_start 	= adw.getItemDatetime(1, "off_start", Primary!, true)
ll_ops_offservice_id = adw.getItemNumber(1, "ops_off_service_id")

SELECT isnull(NTC_OFF_SERVICE.HFO_PRICE,0), isnull(NTC_OFF_SERVICE.DO_PRICE,0),
	isnull(NTC_OFF_SERVICE.GO_PRICE,0), isnull(NTC_OFF_SERVICE.LSHFO_PRICE,0),
	isnull(NTC_OFF_SERVICE.HFO_SEL,0), isnull(NTC_OFF_SERVICE.DO_SEL,0),
	isnull(NTC_OFF_SERVICE.GO_SEL,0), isnull(NTC_OFF_SERVICE.LSHFO_SEL,0)
	INTO :ld_hfo_price, :ld_do_price, :ld_go_price, :ld_lshfo_price,
		:li_hfo_sel_in, :li_do_sel_in, :li_go_sel_in, :li_lshfo_sel_in
FROM NTC_OFF_SERVICE
INNER JOIN NTC_PAYMENT ON NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID
INNER JOIN NTC_TC_CONTRACT ON NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
WHERE OPS_OFF_SERVICE_ID = :ll_ops_offservice_id AND NTC_TC_CONTRACT.TC_HIRE_IN = 1; 

if SQLCA.sqlcode = -1 then return -1
lb_has_in = (SQLCA.sqlcode = 0)

SELECT isnull(NTC_OFF_SERVICE.HFO_PRICE,0), isnull(NTC_OFF_SERVICE.DO_PRICE,0),
	isnull(NTC_OFF_SERVICE.GO_PRICE,0), isnull(NTC_OFF_SERVICE.LSHFO_PRICE,0),
	isnull(NTC_OFF_SERVICE.HFO_SEL,0), isnull(NTC_OFF_SERVICE.DO_SEL,0),
	isnull(NTC_OFF_SERVICE.GO_SEL,0), isnull(NTC_OFF_SERVICE.LSHFO_SEL,0)
	INTO :ld_hfo_price_out, :ld_do_price_out, :ld_go_price_out, :ld_lshfo_price_out,
		:li_hfo_sel_out, :li_do_sel_out, :li_go_sel_out, :li_lshfo_sel_out
FROM NTC_OFF_SERVICE
INNER JOIN NTC_PAYMENT ON NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID
INNER JOIN NTC_TC_CONTRACT ON NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
WHERE OPS_OFF_SERVICE_ID = :ll_ops_offservice_id AND NTC_TC_CONTRACT.TC_HIRE_IN = 0;

if SQLCA.sqlcode = -1 then return -1
lb_has_out = (SQLCA.sqlcode = 0)

ld_temp_var = adw.getitemnumber(1, "off_fuel_oil_used") 
if ( ld_temp_var <> 0 ) and ( not isnull(ld_temp_var ) ) then
	istr_fuel.sb_hfo = true
	istr_fuel.sd_amount_hfo = ld_temp_var
	istr_fuel.sd_price_hfo = ld_hfo_price
	istr_fuel.sd_hfo_start = adw.getitemnumber(1, "hfo_stock_start") 
	istr_fuel.sd_hfo_end = adw.getitemnumber(1, "hfo_stock_end") 
	
	istr_fuel.hfo_sel_in = li_hfo_sel_in
	istr_fuel.hfo_sel_out = li_hfo_sel_out
	istr_fuel.sd_price_hfo_out = ld_hfo_price_out
else
	istr_fuel.sb_hfo = false
	istr_fuel.sd_amount_hfo = 0
	istr_fuel.sd_price_hfo = 0

	istr_fuel.hfo_sel_in = 0
	istr_fuel.hfo_sel_out = 0
	istr_fuel.sd_price_hfo_out = 0
end if
/* Get Diesel Oil amount */
ld_temp_var = adw.getitemnumber(1 ,"off_diesel_oil_used") 
if ( ld_temp_var <> 0 ) and ( not isnull(ld_temp_var )  ) then
	istr_fuel.sb_do = true
	istr_fuel.sd_amount_do = ld_temp_var
	istr_fuel.sd_price_do = ld_do_price
	istr_fuel.sd_do_start = adw.getitemnumber(1, "do_stock_start") 
	istr_fuel.sd_do_end = adw.getitemnumber(1, "do_stock_end") 
	
	istr_fuel.do_sel_in = li_do_sel_in
	istr_fuel.do_sel_out = li_do_sel_out
	istr_fuel.sd_price_do_out = ld_do_price_out
else
	istr_fuel.sb_do = false
	istr_fuel.sd_amount_do = 0
	istr_fuel.sd_price_do = 0

	istr_fuel.do_sel_in = 0
	istr_fuel.do_sel_out = 0
	istr_fuel.sd_price_do_out = 0
end if
/* Get Gas Oil amount */
ld_temp_var = adw.getitemnumber(1 ,"off_gas_oil_used") 
if ( ld_temp_var <> 0 ) and ( not isnull(ld_temp_var ) ) then
	istr_fuel.sb_go = true
	istr_fuel.sd_amount_go = ld_temp_var
	istr_fuel.sd_price_go = ld_go_price
	istr_fuel.sd_go_start = adw.getitemnumber(1, "go_stock_start") 
	istr_fuel.sd_go_end = adw.getitemnumber(1, "go_stock_end") 
	
	istr_fuel.go_sel_in = li_go_sel_in
	istr_fuel.go_sel_out = li_go_sel_out
	istr_fuel.sd_price_go_out = ld_go_price_out
else
	istr_fuel.sb_go = false
	istr_fuel.sd_amount_go = 0
	istr_fuel.sd_price_go = 0

	istr_fuel.go_sel_in = 0
	istr_fuel.go_sel_out = 0
	istr_fuel.sd_price_go_out = 0
end if
/* Get Low Sulfur Heavy Fuel Oil amount */
ld_temp_var = adw.getitemnumber(1 ,"off_lshfo_oil_used") 
if ( ld_temp_var <> 0 ) and ( not isnull(ld_temp_var ) ) then
	istr_fuel.sb_lshfo = true
	istr_fuel.sd_amount_lshfo = ld_temp_var
	istr_fuel.sd_price_lshfo = ld_lshfo_price
	istr_fuel.sd_lshfo_start = adw.getitemnumber(1, "lshfo_stock_start") 
	istr_fuel.sd_lshfo_end = adw.getitemnumber(1, "lshfo_stock_end") 
	
	istr_fuel.lshfo_sel_in = li_lshfo_sel_in
	istr_fuel.lshfo_sel_out = li_lshfo_sel_out
	istr_fuel.sd_price_lshfo_out = ld_lshfo_price_out
else
	istr_fuel.sb_lshfo = false
	istr_fuel.sd_amount_lshfo = 0
	istr_fuel.sd_price_lshfo = 0
	
	istr_fuel.lshfo_sel_in = 0
	istr_fuel.lshfo_sel_out = 0
	istr_fuel.sd_price_lshfo_out = 0
end if
/* Set structure vessel_nr and startdate */
istr_fuel.si_vessel_nr = ii_vessel_nr
istr_fuel.ss_voyage_nr = adw.getItemString(1, "voyage_nr")
istr_fuel.sdt_offservice_start = adw.getItemDatetime(1, "off_start", Primary!, true)
istr_fuel.sdt_offservice_end = adw.getItemDatetime(1, "off_end", Primary!, true)
/* Open window w_offservice_tc_fuel_trans with structure parameter */
//openwithparm(w_offservice_tc_fuel_trans , istr_fuel )
/* Get the returned structure and place in local instance structure */
//istr_fuel = message.powerobjectparm
/* If the user cancelled then ... */
//if istr_fuel.sd_price_hfo = -1 then 
//	return -1
//end if

return 1
end function

public function integer of_deletetctransfer (datawindow adw);/*
	Her skal alle tidligere overførsler for denne off-service først slettes
	
	Delete from NTC_........ WHERE nøglerne fra operationen 
	
	HUSK at dato off_start = getItemDatetime(1, "off_start", primary!, true) den originale værdi posten var gemt med
	
	*/

long			ll_rows, ll_rowno
long 			ll_tc_offservice_id, ll_ops_offservice_id

ll_ops_offservice_id = adw.getItemNumber(1, "ops_off_service_id")

ll_rows = ids_tc_offservice.retrieve(ll_ops_offservice_id)

if ll_rows < 1 then return 1

/* delete all rows */
for ll_rowno = 1 to ll_rows
	/* delete TC Off Service detail and Off Service Dependant Contract Expenses (is any)  */
	ll_tc_offservice_id = ids_tc_offservice.getItemNumber(1, "off_service_id")
	il_paymentIDArray[upperBound(il_paymentIDArray)+1]= ids_tc_offservice.getItemNumber(1, "payment_id")
	DELETE FROM NTC_OFF_SERVICE_DETAIL WHERE OFF_SERVICE_ID = :ll_tc_offservice_id;
	DELETE FROM NTC_OFS_DEPENDENT_CONTRACT_EXP WHERE OFF_SERVICE_ID = :ll_tc_offservice_id;
	/* delete TC OffS. */
	ids_tc_offservice.deleteRow(1)
next

if ids_tc_offservice.update() <> 1 then
	MessageBox("Update Error", "Not able to update NTC_OFF_SERVICE. Object: n_offservice, function: of_deleteTCtransfer()")
	Return -1
end if

return 1
end function

public function integer of_deleterow (datawindow adw, long al_row);integer			li_vessel, li_trans_to_coda
datetime			ldt_start, ldt_end
long				ll_rows, ll_rowno
long 				ll_tc_offservice_id, ll_ops_offservice_id
long 				ll_contracts
long 				ll_nullArray[]
n_tc_payment	lnv_payment  
n_bunker_posting_control  lnv_bunkerControl

ll_ops_offservice_id = adw.getItemNumber(al_row, "ops_off_service_id")
/* Check that offservice not settled while window open */
SELECT MAX(TRANS_TO_CODA)
	INTO :li_trans_to_coda
	FROM NTC_OFF_SERVICE
	WHERE OPS_OFF_SERVICE_ID = :istr_off_service.ops_off_service_id;
if li_trans_to_coda	> 0 then
	adw.setItem(al_row, "trans_to_coda", 1)
	MessageBox("Information", "Off-Hire settled in TC Module while this window open") 
	return 1
end if

li_vessel 	= adw.getItemNumber(al_row, "vessel_nr")
ldt_start 	= adw.getItemDatetime(al_row, "off_start")

ll_rows = ids_tc_offservice.retrieve(ll_ops_offservice_id)
il_paymentIDArray = ll_nullArray

/* delete all rows */
for ll_rowno = 1 to ll_rows
	/* delete TC Off Service detail and Off Service Dependant Contract Expenses (is any)  */
	ll_tc_offservice_id = ids_tc_offservice.getItemNumber(1, "off_service_id")
	il_paymentIDArray[upperBound(il_paymentIDArray)+1]= ids_tc_offservice.getItemNumber(1, "payment_id")
	DELETE FROM NTC_OFF_SERVICE_DETAIL WHERE OFF_SERVICE_ID = :ll_tc_offservice_id;
	DELETE FROM NTC_OFS_DEPENDENT_CONTRACT_EXP WHERE OFF_SERVICE_ID = :ll_tc_offservice_id;
	ids_tc_offservice.deleteRow(1)
next

if ids_tc_offservice.update() = 1 then
	DELETE FROM OFF_SERVICES
		WHERE OPS_OFF_SERVICE_ID = :ll_ops_offservice_id;
	IF SQLCA.SQLCode = 0 then
		commit;
	else
		rollback;
		MessageBox("Delete error", "Not possible to delete this row. Object: n_offservice, function: of_deleteRow()")
		return -1
	end if
else 
	rollback;
	MessageBox("Delete error", "Not possible to delete TC Off-Hires. Object: n_offservice, function: of_deleteRow()")
	return -1
end if

/* find out if this off-service is copied to TC Hire Module */
/* find out if there are tc contracts covering the same periode */
/* first check if vessel has any TC contract. li_contracts > 0 means Yes */
//if not isnull(adw.getItemNumber(al_row, "ntc_ops_off_service_id")) then
//if istr_off_service.trans_to_tcin >0 or istr_off_service.trans_to_tcout >0 then
	ldt_end 	= adw.getItemDatetime(al_row, "off_end")
	ll_contracts = ids_tc_contracts.retrieve(li_vessel, ldt_start, ldt_end)
	if ll_contracts > 0 then
		lnv_payment = create n_tc_payment
		for ll_rowno = 1 to ll_contracts
			 lnv_payment.of_offServiceModified(ids_tc_contracts.getItemNumber(ll_rowno, "contract_id"), il_paymentIDArray)		
		next
		destroy lnv_payment
	end if
//end if

if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if

/* Check if any bunker values in deleted row If yes voyage consumption must be posted */
if ( NOT isNull(adw.getItemNumber(al_row, "hfo_stock_start")) and adw.getItemNumber(al_row, "hfo_stock_start") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "hfo_stock_end")) and adw.getItemNumber(al_row, "hfo_stock_end") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "off_fuel_oil_used")) and adw.getItemNumber(al_row, "off_fuel_oil_used") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "do_stock_start")) and adw.getItemNumber(al_row, "do_stock_start") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "do_stock_end")) and adw.getItemNumber(al_row, "do_stock_end") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "off_diesel_oil_used")) and adw.getItemNumber(al_row, "off_diesel_oil_used") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "go_stock_start")) and adw.getItemNumber(al_row, "go_stock_start") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "go_stock_end")) and adw.getItemNumber(al_row, "go_stock_end") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "off_gas_oil_used")) and adw.getItemNumber(al_row, "off_gas_oil_used") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "lshfo_stock_start")) and adw.getItemNumber(al_row, "lshfo_stock_start") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "lshfo_stock_end")) and adw.getItemNumber(al_row, "lshfo_stock_end") <> 0) &
or ( NOT isNull(adw.getItemNumber(al_row, "off_lshfo_oil_used")) and adw.getItemNumber(al_row, "off_lshfo_oil_used") <> 0) then
	/* If any bunker figures modified then post bunker */
	lnv_bunkerControl = create n_bunker_posting_control 
	lnv_bunkerControl.of_offservice_modified( adw.getItemNumber(al_row, "vessel_nr"), adw.getItemString(al_row, "voyage_nr"))
	destroy lnv_bunkerControl
end if

adw.deleteRow(al_row)

return 1
end function

public function integer of_update (datawindow adw);string				ls_portcode, ls_voyagenr
datetime			ldt_start
long 				ll_contracts, ll_teller, ll_rows
long 				ll_nullArray[]
long 				ll_ops_offservice_id
boolean			lb_transfer = false, lb_bunker_modified = false
n_tc_payment	lnv_payment
n_bunker_posting_control lnv_bunkerControl

if adw.rowCount() < 1 then return 1  /* nothing to update */

ids_tc_offservice.reset()
il_paymentIDArray = ll_nullArray

/* Validate entered record */
if of_validate(adw) = -1 then return -1

/* Check if bunker values are modified. If yes voyage consumption must be posted */
if adw.getItemStatus(1, "hfo_stock_start", primary!) = datamodified! &
or adw.getItemStatus(1, "hfo_stock_end", primary!) = datamodified! &
or adw.getItemStatus(1, "off_fuel_oil_used", primary!) = datamodified! &
or adw.getItemStatus(1, "do_stock_start", primary!) = datamodified! &
or adw.getItemStatus(1, "do_stock_end", primary!) = datamodified! &
or adw.getItemStatus(1, "off_diesel_oil_used", primary!) = datamodified! &
or adw.getItemStatus(1, "go_stock_start", primary!) = datamodified! &
or adw.getItemStatus(1, "go_stock_end", primary!) = datamodified! &
or adw.getItemStatus(1, "off_gas_oil_used", primary!) = datamodified! &
or adw.getItemStatus(1, "lshfo_stock_start", primary!) = datamodified! &
or adw.getItemStatus(1, "lshfo_stock_end", primary!) = datamodified! &
or adw.getItemStatus(1, "off_lshfo_oil_used", primary!) = datamodified! then
	lb_bunker_modified = true
end if

/* Check if there are any TC-Contracts to transfer to */
ll_contracts = ids_tc_contracts.rowCount()
if ll_contracts > 0 then
   	/* Show window where user can decide which contract to transfer to */
	of_getVASindicator(adw)
	/* Sets the transfer values for the TC contracts */
	of_setPreviousTransfer( adw )
	
	istr_fuel.ids_tc_contracts = ids_tc_contracts
	if ids_tc_contracts.getItemNumber(1, "ntc_tc_contract_tc_hire_in") = 1 &
		and ll_contracts = 1 then
		istr_fuel.sb_tc_in = true
	else
		istr_fuel.sb_tc_in = false
	end if
	
	if of_tcin_transfer() > 0 then
		istr_fuel.tcin_transfer = 1
	else
		istr_fuel.tcin_transfer = 0
	end if

	if of_tcout_transfer() > 0 then
		istr_fuel.tcout_transfer = 1
	else
		istr_fuel.tcout_transfer = 0
	end if
	
	istr_fuel.transfer_saved = istr_off_service.transfer_saved
	if of_fuelprice(adw) = -1 then return -1
	
	istr_fuel.si_returncode = -1
	openwithparm(w_show_TCContractMatch, istr_fuel)
	istr_fuel = message.powerobjectparm
	if istr_fuel.si_returncode = -1 then
		return -1
	end if

	/* Find out if there are anything to transfer */
	for ll_teller = 1 to ll_contracts
		if ids_tc_contracts.getItemNumber(ll_teller, "transfer") = 1 then
			lb_transfer = true
			exit
		end if
	next
	/* if transfer, get fuel prices */
	/* if only one contract to transfer to an it is TC-IN Calculate FIFO price */
	if lb_transfer then
		/* If transfer, always delete old items as yes/no for transfer can be changed */
		of_deleteTCtransfer(adw)
		of_newTCtransfer(adw)
	else
		of_deleteTCtransfer(adw)
	end if
else
	/* delete mulige tidligere transfers */
	of_deleteTCtransfer(adw)
end if

/* If update of datawindow off_services is OK */
if adw.Update(true, false) = 1 then
	/* if anything to transfer, ensure that the right key is in place */
	istr_off_service.ops_off_service_id = adw.getItemNumber(1, "ops_off_service_id")
	if ids_tc_offservice.rowCount() > 0 then
		of_setOperationsKey( adw , ids_tc_offservice )
	end if
	if ids_tc_offservice.Update(true, false) = 1 then
		adw.resetUpdate()
		ids_tc_offservice.resetUpdate()
		Commit;
	else
		Rollback;
		MessageBox("Update Error", "Update of TC Off-Hire(ids_tc_offservice) failed. Object: n_offservice, function: of_update()")
		adw.SetFocus()
		adw.SetColumn("off_start")
		return -1
	end if
else
	Rollback;
	MessageBox("Update Error", "Update of Off-Hire(adw) failed. Object: n_offservice, function: of_update()")
	adw.SetFocus()
	adw.SetColumn("off_start")
	return -1
end if

if ll_contracts > 0 then
	ll_ops_offservice_id = adw.getItemNumber(1, "ops_off_service_id")
	ll_rows = ids_tc_offservice.retrieve(ll_ops_offservice_id )
	if ll_rows > 0 then
		for ll_teller = 1 to ll_rows
			il_paymentIDArray[upperBound(il_paymentIDArray)+1]= ids_tc_offservice.getItemNumber(ll_teller, "payment_id")
		next
	end if
	if upperbound(il_paymentidarray) > 0 then
		lnv_payment = create n_tc_payment
		for ll_teller = 1 to ll_contracts
			 lnv_payment.of_dependentContractExpensesModified(ids_tc_contracts.getItemNumber(ll_teller, "contract_id"), ll_ops_offservice_id )
			 lnv_payment.of_offServiceModified(ids_tc_contracts.getItemNumber(ll_teller, "contract_id"), il_paymentIDArray)	
		next
		destroy lnv_payment
	end if
end if

if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if

/* If any bunker figures modified then post bunker */
lnv_bunkerControl = create n_bunker_posting_control 
lnv_bunkerControl.of_offservice_modified( adw.getItemNumber(1, "vessel_nr"), adw.getItemString(1, "voyage_nr"))
destroy lnv_bunkerControl

return 1

end function

public function integer of_setoperationskey (ref datawindow adw_ops, ref datastore ads_tc);long 	ll_rows, ll_row

ll_rows = ads_tc.rowCount()
for ll_row = 1 to ll_rows
	ads_tc.setItem(ll_row, "ops_off_service_id", adw_ops.getItemNumber(1, "ops_off_service_id"))
next

return 1
end function

public function integer of_voyagefinishvalidate (integer ai_vessel_nr, string as_voyage_nr);/* This function is used when the user is finishing a voyage. At this point the the system
	must validate if all off-hires registred for this voyage are inside the voyage start and 
	end dates */
n_ds				lds_offServices, lds_edit_offservice
long				ll_row, ll_rows, ll_opsID, ll_contractID
datetime 		ldt_start, ldt_end, ldt_voyage_start, ldt_voyage_end 
n_ds 				lds_tc_conflicts
long 				ll_periods, ll_contracts
integer 			li_voyageType
decimal {4}		ld_voyagestart_hfo, ld_voyagestart_do, ld_voyagestart_go, ld_voyagestart_lshfo
decimal {4}		ld_max_hfo, ld_max_do, ld_max_go, ld_max_lshfo
decimal {4}		ld_used_hfo, ld_used_do, ld_used_go, ld_used_lshfo
decimal {4}		ld_offstart_hfo, ld_offstart_do, ld_offstart_go, ld_offstart_lshfo
decimal {4}		ld_consumption_ton, ld_offservice_ton
decimal {2}		ld_consumption_price, ld_offservice_price

n_voyage_offservice_bunker_consumption	lnv_offbunker
n_voyage_bunker_consumption				lnv_bunker

lds_offServices = CREATE n_ds
lds_offServices.dataObject = "d_offservice_within_voyage"
lds_offServices.setTransObject(SQLCA)

lds_edit_offservice = CREATE n_ds
lds_edit_offservice.dataObject = "d_edit_single_offservice"
lds_edit_offservice.setTransObject(SQLCA)

lds_tc_conflicts = CREATE n_ds
lds_tc_conflicts.dataObject = "d_check_conflict_offservice_tc"
lds_tc_conflicts.setTransObject(SQLCA)

ll_rows = lds_offServices.retrieve(ai_vessel_nr, as_voyage_nr)

commit;

SELECT VOYAGE_TYPE
	INTO :li_voyageType
	FROM VOYAGES
	WHERE VESSEL_NR = :ai_vessel_nr
	AND VOYAGE_NR = :as_voyage_nr;
	if isNull(li_voyageType) then
		MessageBox("Validation Error", "Validation failed when retrieving voyage type. (n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
commit;

/* Get max stock values that off_service must not exceed */
SELECT MAX(ARR_HFO + LIFT_HFO),  MAX(ARR_DO + LIFT_DO),  MAX(ARR_GO + LIFT_GO), MAX(ARR_LSHFO + LIFT_LSHFO)  
	INTO :ld_max_hfo, :ld_max_do, :ld_max_go, :ld_max_lshfo
	FROM POC  
	WHERE VESSEL_NR = :ai_vessel_nr
	AND VOYAGE_NR = :as_voyage_nr ;
commit;

SELECT top 1 DEPT_HFO,  DEPT_DO, DEPT_GO, DEPT_LSHFO   
	INTO :ld_voyagestart_hfo, :ld_voyagestart_do, :ld_voyagestart_go, :ld_voyagestart_lshfo
	FROM POC  
	WHERE VESSEL_NR = :ai_vessel_nr
	AND VOYAGE_NR < :as_voyage_nr
	ORDER BY PORT_ARR_DT DESC;
commit;

if ld_voyagestart_hfo > ld_max_hfo then ld_max_hfo = ld_voyagestart_hfo
if ld_voyagestart_do > ld_max_do then ld_max_do = ld_voyagestart_do
if ld_voyagestart_go > ld_max_go then ld_max_go = ld_voyagestart_go
if ld_voyagestart_lshfo > ld_max_lshfo then ld_max_lshfo = ld_voyagestart_lshfo

/* Run throught all offservices and validate */
for ll_row = 1 to ll_rows
	ll_opsID = lds_offServices.getItemNumber(ll_row, "ops_off_service_id")
	if lds_edit_offservice.retrieve(ll_opsID) < 1 then
		MessageBox("Validation Error", "Validation failed when retrieving Off-Hire. (n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
	commit;

	ldt_start 				= lds_edit_offservice.getItemDatetime(1, "off_start")
	ldt_end 				= lds_edit_offservice.getItemDatetime(1, "off_end")
	ld_offstart_hfo 		= lds_edit_offservice.getItemDecimal(1, "hfo_stock_start")
	ld_offstart_do 		= lds_edit_offservice.getItemDecimal(1, "do_stock_start")
	ld_offstart_go 		= lds_edit_offservice.getItemDecimal(1, "go_stock_start")
	ld_offstart_lshfo	= lds_edit_offservice.getItemDecimal(1, "lshfo_stock_start")
	ld_used_hfo			= lds_edit_offservice.getItemDecimal(1, "off_fuel_oil_used")
	if isnull(ld_used_hfo) then ld_used_hfo = 0
	ld_used_do			= lds_edit_offservice.getItemDecimal(1, "off_diesel_oil_used")
	if isnull(ld_used_do) then ld_used_do = 0
	ld_used_go			= lds_edit_offservice.getItemDecimal(1, "off_gas_oil_used")
	if isnull(ld_used_go) then ld_used_go = 0
	ld_used_lshfo		= lds_edit_offservice.getItemDecimal(1, "off_lshfo_oil_used")
	if isnull(ld_used_lshfo) then ld_used_lshfo = 0
	
	if li_voyageType = 2 then
		/* TC OUT Voyage */
		SELECT NTC_TC_CONTRACT.CONTRACT_ID
			INTO :ll_contractID
			FROM NTC_TC_CONTRACT, NTC_TC_PERIOD  
			WHERE  NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID  
			AND (( :ldt_start < NTC_TC_PERIOD.PERIODE_START 
			AND  :ldt_start <= NTC_TC_PERIOD.PERIODE_END 
			AND :ldt_end >= NTC_TC_PERIOD.PERIODE_END) 
			OR ( :ldt_end > NTC_TC_PERIOD.PERIODE_START 
			AND :ldt_end <= NTC_TC_PERIOD.PERIODE_END 
			AND :ldt_start < NTC_TC_PERIOD.PERIODE_START)
			OR ( :ldt_end >= NTC_TC_PERIOD.PERIODE_END 
			AND :ldt_start <= NTC_TC_PERIOD.PERIODE_END)
			OR ( :ldt_start >= NTC_TC_PERIOD.PERIODE_START 
			AND :ldt_end <= NTC_TC_PERIOD.PERIODE_END)) 
			AND  NTC_TC_CONTRACT.VESSEL_NR = :ai_vessel_nr;    
		commit;
		if isNull(ll_contractID) then
			MessageBox("Validation Error", "Can't find TC Contract related to voyage. (n_offservice.of_voyageFinishValidate)")
			destroy lds_offServices
			destroy lds_edit_offservice
			destroy lds_tc_conflicts
			return -1
		end if
		SELECT MIN(PERIODE_START), MAX(PERIODE_END)
			INTO :ldt_voyage_start, :ldt_voyage_end
			FROM NTC_TC_PERIOD
			WHERE CONTRACT_ID = :ll_contractID;
		commit;
		if isNull(ldt_voyage_start) or isNull(ldt_voyage_end) then
			MessageBox("Validation Error", "Can't get TC period start or end. (n_offservice.of_voyageFinishValidate)")
			destroy lds_offServices
			destroy lds_edit_offservice
			destroy lds_tc_conflicts
			return -1
		end if
	else
		/* single voyage - set voyage start */
		SELECT MAX(PORT_DEPT_DT)
			INTO :ldt_voyage_start
			FROM POC
			WHERE VESSEL_NR = :ai_vessel_nr
			AND VOYAGE_NR < :as_voyage_nr;
		commit;
		if isNull(ldt_voyage_start) then
			SELECT MIN(PORT_ARR_DT)
				INTO :ldt_voyage_start
				FROM POC
				WHERE VESSEL_NR = :ai_vessel_nr 
				AND VOYAGE_NR = :as_voyage_nr;
			commit;
		end if
		if isNull(ldt_voyage_start) then
			MessageBox("Validation Error", "Validation failed when setting voyage start date. (n_offservice.of_voyageFinishValidate)")
			destroy lds_offServices
			destroy lds_edit_offservice
			destroy lds_tc_conflicts
			return -1
		end if
		/* single voyage - set voyage end */
		SELECT MAX(PORT_DEPT_DT)
			INTO :ldt_voyage_end
			FROM POC
			WHERE VESSEL_NR = :ai_vessel_nr 
			AND VOYAGE_NR = :as_voyage_nr;
		commit;
		if isNull(ldt_voyage_end) then
			MessageBox("Validation Error", "Validation failed when setting voyage end date. (n_offservice.of_voyageFinishValidate)")
			destroy lds_offServices
			destroy lds_edit_offservice
			destroy lds_tc_conflicts
			return -1
		end if
		/* Check that stock given in off-service is OK */
		if not isnull(ld_offstart_hfo) and ld_used_hfo <> 0 then
			if ld_offstart_hfo > ld_max_hfo then
				MessageBox("Validation Error", "Off-Hire HSFO Stock Start is not inside voyage stock values.(n_offservice.of_voyageFinishValidate)")
					destroy lds_offServices
					destroy lds_edit_offservice
					destroy lds_tc_conflicts
					return -1
			end if
		end if
		if not isnull(ld_offstart_do) and ld_used_do <> 0 then
			if ld_offstart_do > ld_max_do then
				MessageBox("Validation Error", "Off-Hire LSGO Stock Start is not inside voyage stock values.(n_offservice.of_voyageFinishValidate)")
					destroy lds_offServices
					destroy lds_edit_offservice
					destroy lds_tc_conflicts
					return -1
			end if
		end if
		if not isnull(ld_offstart_go) and ld_used_go <> 0 then
			if ld_offstart_go > ld_max_go then
				MessageBox("Validation Error", "Off-Hire HSGO Stock Start is not inside voyage stock values.(n_offservice.of_voyageFinishValidate)")
					destroy lds_offServices
					destroy lds_edit_offservice
					destroy lds_tc_conflicts
					return -1
			end if
		end if
		if not isnull(ld_offstart_lshfo) and ld_used_lshfo <> 0 then
			if ld_offstart_lshfo > ld_max_lshfo then
				MessageBox("Validation Error", "Off-Hire LSFO Stock Start is not inside voyage stock values.(n_offservice.of_voyageFinishValidate)")
					destroy lds_offServices
					destroy lds_edit_offservice
					destroy lds_tc_conflicts
					return -1
			end if
		end if
	end if
	
	if ldt_start < ldt_voyage_start then 
		MessageBox("Validation Error", "Off-Hire start before Voyage/TC Contract start date.(n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
	if ldt_start > ldt_voyage_end then 
		MessageBox("Validation Error", "Off-Hire start after Voyage/TC Contract end date.(n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
	
	if ldt_end < ldt_voyage_start then 
		MessageBox("Validation Error", "Off-Hire end before Voyage/TC Contract start date.(n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
	if ldt_end > ldt_voyage_end then 
		MessageBox("Validation Error", "Off-Hire end after Voyage/TC Contract end date.(n_offservice.of_voyageFinishValidate)")
		destroy lds_offServices
		destroy lds_edit_offservice
		destroy lds_tc_conflicts
		return -1
	end if
	
	/* find out if there are tc contracts covering the same periode */
	/* first check if vessel has any TC contract. li_contracts > 0 means Yes */
	ll_contracts = ids_tc_contracts.retrieve(ii_vessel_nr, ldt_start, ldt_end)
	commit;
	if ll_contracts > 0 then
		ll_periods = lds_tc_conflicts.retrieve(ii_vessel_nr, ldt_start, ldt_end)
		commit;
		if ll_periods > 0 then
			/* Her vises et pænere skærmbillede med dels conflictende contracter */
			openwithparm(w_check_conflict_offservice_tc, lds_tc_conflicts) 
			destroy lds_offServices
			destroy lds_edit_offservice
			destroy lds_tc_conflicts
			return -1
		end if
	end if
next

destroy lds_offServices
destroy lds_edit_offservice
destroy lds_tc_conflicts

// Check if bunker on offservice is higher than voyage consumption - only Single voyages
// CR2516:the validation of voyage cosumption should be bypassed when we do not have off service
if (li_voyageType <> 2) then
	lnv_bunker		= create n_voyage_bunker_consumption				
	lnv_offbunker	= create n_voyage_offservice_bunker_consumption	
	
	lnv_bunker.of_calculate( "HFO", ai_vessel_nr , as_voyage_nr , ld_consumption_price , ld_consumption_ton )	//lnv_offbunker.of_calculate( "HFO", ai_vessel_nr , as_voyage_nr , ld_offservice_price , ld_offservice_ton )
	if ll_rows > 0 then 
		lnv_offbunker.of_calculate( "HFO", ai_vessel_nr , as_voyage_nr , ld_offservice_price , ld_offservice_ton )
		if ld_offservice_ton > ld_consumption_ton then
			Messagebox("Validation Error", "Off-Hire HSFO consumption is higher then Voyage Consumption. (n_offservice.of_voyageFinishValidate)")
			destroy lnv_bunker	
			destroy lnv_offbunker
			return -1
		end if
	elseif ld_consumption_ton < 0 then
			messagebox("Validation Error", "HSFO consumption is less then zero in Voyage Comsumption")
			destroy lnv_bunker	
			destroy lnv_offbunker
			return -1		
	end if
	
	lnv_bunker.of_calculate( "DO", ai_vessel_nr , as_voyage_nr , ld_consumption_price , ld_consumption_ton )
	
	if ll_rows > 0 then
		lnv_offbunker.of_calculate( "DO", ai_vessel_nr , as_voyage_nr , ld_offservice_price , ld_offservice_ton )
		if ld_offservice_ton > ld_consumption_ton then
			messagebox("Validation Error", "Off-Hire LSGO consumption is higher then Voyage Consumption. (n_offservice.of_voyageFinishValidate)")
			destroy lnv_bunker	
			destroy lnv_offbunker
			return -1
		end if
	elseif ld_consumption_ton < 0 then
		messagebox("Validation Error", "LSGO consumption is less then zero in Voyage Comsumption")
		destroy lnv_bunker	
		destroy lnv_offbunker
		return -1
	end if
	
	lnv_bunker.of_calculate( "GO", ai_vessel_nr , as_voyage_nr , ld_consumption_price , ld_consumption_ton )
	if ll_rows > 0 then
		lnv_offbunker.of_calculate( "GO", ai_vessel_nr , as_voyage_nr , ld_offservice_price , ld_offservice_ton )
		if ld_offservice_ton > ld_consumption_ton then
			messagebox("Validation Error", "Off-Hire HSGO consumption is higher then Voyage Consumption. (n_offservice.of_voyageFinishValidate)")
			destroy lnv_bunker	
			destroy lnv_offbunker
			return -1
		end if
	elseif ld_consumption_ton < 0 then
		messagebox("Validation Error", "HSGO consumption is less then zero in Voyage Comsumption")
		destroy lnv_bunker	
		destroy lnv_offbunker
		return -1
	end if
	
	lnv_bunker.of_calculate( "LSHFO", ai_vessel_nr , as_voyage_nr , ld_consumption_price , ld_consumption_ton )
	if ll_rows > 0 then
		lnv_offbunker.of_calculate( "LSHFO", ai_vessel_nr , as_voyage_nr , ld_offservice_price , ld_offservice_ton )
		if ld_offservice_ton > ld_consumption_ton then
			Messagebox("Validation Error", "Off-Hire LSFO consumption is higher then Voyage Consumption. (n_offservice.of_voyageFinishValidate)")
			destroy lnv_bunker	
			destroy lnv_offbunker
			return -1
		end if
	elseif ld_consumption_ton < 0 then
		messagebox("Validation Error", "LSFO consumption is less then zero in Voyage Comsumption")
		destroy lnv_bunker	
		destroy lnv_offbunker
		return -1
	end if
	
	destroy lnv_bunker	
	destroy lnv_offbunker
end if

return 1
end function

private function integer of_validate (datawindow adw);integer	li_contracts, li_vessel, li_voyage_finished=0, li_voyageType
datetime ldt_start, ldt_end, ldt_voyage_start, ldt_voyage_end 
n_ds 		lds_tc_conflicts
long 		ll_periods, ll_contracts, ll_contractID, ll_OPSoffserviceID
string 	ls_voyage
integer	li_counter
n_voyage_offservice_bunker_consumption	lnv_bunkermatch
decimal 	ld_testvalue
decimal{4} ld_sumHFO, ld_sumDO, ld_sumGO, ld_sumLSHFO
decimal{4} ld_thisHFO, ld_thisDO, ld_thisGO, ld_thisLSHFO

/* Validate rows */
lds_tc_conflicts = CREATE n_ds
lds_tc_conflicts.dataObject = "d_check_conflict_offservice_tc"
lds_tc_conflicts.setTransObject(SQLCA)
/* validate dates */
ldt_start = adw.getItemDatetime(1, "off_start")
if isNull(ldt_start) then 
	MessageBox("Validation Error", "Please enter a valid start date")
	adw.POST setColumn("off_start")
	destroy lds_tc_conflicts
	return -1
end if
ldt_end = adw.getItemDatetime(1, "off_end")
if isNull(ldt_end) then 
	MessageBox("Validation Error", "Please enter a valid end date")
	adw.POST setColumn("off_end")
	destroy lds_tc_conflicts
	return -1
end if
if ldt_start >= ldt_end then 
	MessageBox("Validation Error", "Startdate must be less than end date")
	adw.POST setColumn("off_start")
	destroy lds_tc_conflicts
	return -1
end if
/* validate dates against voyage */
li_vessel = adw.getItemNumber(1, "vessel_nr")
ls_voyage = adw.getItemString(1, "voyage_nr")

SELECT VOYAGE_TYPE
	INTO :li_voyageType
	FROM VOYAGES
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR = :ls_voyage;

if li_voyageType = 2 then
	SELECT NTC_TC_CONTRACT.CONTRACT_ID
		INTO :ll_contractID
		FROM NTC_TC_CONTRACT, NTC_TC_PERIOD  
		WHERE  NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID  
		AND (( :ldt_start < NTC_TC_PERIOD.PERIODE_START 
		AND  :ldt_start <= NTC_TC_PERIOD.PERIODE_END 
		AND :ldt_end >= NTC_TC_PERIOD.PERIODE_END) 
		OR ( :ldt_end > NTC_TC_PERIOD.PERIODE_START 
		AND :ldt_end <= NTC_TC_PERIOD.PERIODE_END 
		AND :ldt_start < NTC_TC_PERIOD.PERIODE_START)
		OR ( :ldt_end >= NTC_TC_PERIOD.PERIODE_END 
		AND :ldt_start <= NTC_TC_PERIOD.PERIODE_END)
		OR ( :ldt_start >= NTC_TC_PERIOD.PERIODE_START 
		AND :ldt_end <= NTC_TC_PERIOD.PERIODE_END)) 
		AND  NTC_TC_CONTRACT.VESSEL_NR = :li_vessel;    
	commit;
	if isNull(ll_contractID) then
		MessageBox("Validation Error", "Can't find TC Contract related to voyage. (n_offservice.of_validate)")
		destroy lds_tc_conflicts
		return -1
	end if
	SELECT MIN(PERIODE_START), MAX(PERIODE_END)
		INTO :ldt_voyage_start, :ldt_voyage_end
		FROM NTC_TC_PERIOD
		WHERE CONTRACT_ID = :ll_contractID;
	commit;
	if isNull(ldt_voyage_start) or isNull(ldt_voyage_end) then
		MessageBox("Validation Error", "Can't get TC period start or end. (n_offservice.of_voyageFinishValidate)")
		destroy lds_tc_conflicts
		return -1
	end if
else
	/* Find out if voyage is finished or not */
	SELECT VOYAGE_FINISHED
		INTO :li_voyage_finished
		FROM VOYAGES
		WHERE VESSEL_NR = :li_vessel
		AND VOYAGE_NR = :ls_voyage;
	/* set voyage start */
	SELECT MAX(PORT_DEPT_DT)
		INTO :ldt_voyage_start
		FROM POC
		WHERE VESSEL_NR = :li_vessel 
		AND VOYAGE_NR < :ls_voyage;
	if isNull(ldt_voyage_start) then
		if li_voyage_finished = 1 then
			/* This must be the first voyage, and therefore startdate = first arrival date */
			SELECT MIN(PORT_ARR_DT)
				INTO :ldt_voyage_start
				FROM POC
				WHERE VESSEL_NR = :li_vessel 
				AND VOYAGE_NR = :ls_voyage;
		else		
			ldt_voyage_start = datetime(date(1900, 01, 01))
		end if
	else		
		ldt_voyage_start = datetime(date(1900, 01, 01))
	end if
	/* set voyage end */
	SELECT MIN(PORT_ARR_DT)
		INTO :ldt_voyage_end
		FROM POC
		WHERE VESSEL_NR = :li_vessel 
		AND VOYAGE_NR > :ls_voyage
		AND SUBSTRING(VOYAGE_NR,1,1) <> "9";                        // This to ignore voyagas 90xx - 99xx
	if li_voyage_finished = 1 then
		/* If voyage finished then enddate must be set to last date for voyage */
		SELECT MAX(PORT_DEPT_DT)
			INTO :ldt_voyage_end
			FROM POC
			WHERE VESSEL_NR = :li_vessel 
			AND VOYAGE_NR = :ls_voyage;
	end if		
	if isNull(ldt_voyage_end) then
		ldt_voyage_end = datetime(date(2050, 01, 01))
	end if
end if

if ldt_start < ldt_voyage_start then 
	MessageBox("Validation Error", "Off-Hire start before voyage start date")
	adw.POST setColumn("off_start")
	destroy lds_tc_conflicts
	return -1
end if
if ldt_start > ldt_voyage_end then 
	MessageBox("Validation Error", "Off-Hire start after voyage end date")
	adw.POST setColumn("off_start")
	destroy lds_tc_conflicts
	return -1
end if

if ldt_end < ldt_voyage_start then 
	MessageBox("Validation Error", "Off-Hire end before voyage start date")
	adw.POST setColumn("off_end")
	destroy lds_tc_conflicts
	return -1
end if
if ldt_end > ldt_voyage_end then 
	MessageBox("Validation Error", "Off-Hire end after voyage end date")
	adw.POST setColumn("off_end")
	destroy lds_tc_conflicts
	return -1
end if

/* validate hours & minutes */
if (adw.getItemNumber(1, "off_time_hours") > 23) OR &
	(adw.getItemNumber(1, "off_time_hours") < -23) then
		MessageBox("Validation Error", "Hours can't exceed 23")
		adw.POST setColumn("off_time_hours")
		destroy lds_tc_conflicts
		return -1
end if	

if (adw.getItemNumber(1, "off_time_minutes") > 59) OR &
	(adw.getItemNumber(1, "off_time_minutes") < -59) then
		MessageBox("Validation Error", "Minutes can't exceed 59")
		adw.POST setColumn("off_time_minutes")
		destroy lds_tc_conflicts
		return -1
end if

ll_OPSoffserviceID = adw.getItemNumber(1, "ops_off_service_id")

/* Check if sum of all bunker used on this voyage is negative. Not allowed CR#1353 */
/* First get the usage already registerd */
SELECT isnull(sum(OFF_FUEL_OIL_USED),0),   
	isnull(sum(OFF_DIESEL_OIL_USED),0),   
	isnull(sum(OFF_GAS_OIL_USED),0),   
	isnull(sum(OFF_LSHFO_OIL_USED),0)  
INTO :ld_sumHFO, 
	:ld_sumDO, 
	:ld_sumGO, 
	:ld_sumLSHFO   
FROM OFF_SERVICES  
WHERE VESSEL_NR = :li_vessel  
AND VOYAGE_NR = :ls_voyage
AND OPS_OFF_SERVICE_ID <> :ll_OPSoffserviceID ;

if sqlca.sqlcode <> 0 then 
	ld_sumHFO = 0
	ld_sumDO = 0
	ld_sumGO = 0
	ld_sumLSHFO = 0
end if

ld_thisHFO = adw.getItemNumber(1, "off_fuel_oil_used")
if isnull(ld_thisHFO) then ld_thisHFO = 0
ld_thisDO = adw.getItemNumber(1, "off_diesel_oil_used")
if isnull(ld_thisDO) then ld_thisDO = 0
ld_thisGO = adw.getItemNumber(1, "off_gas_oil_used")
if isnull(ld_thisGO) then ld_thisGO = 0
ld_thisLSHFO = adw.getItemNumber(1, "off_lshfo_oil_used")
if isnull(ld_thisLSHFO) then ld_thisLSHFO = 0

if (ld_sumHFO + ld_thisHFO) < 0 then
	MessageBox("Validation Error", "On this voyage, the total quantity of HSFO used is less than zero. Please correct!")
	adw.POST setColumn("off_fuel_oil_used")
	destroy lds_tc_conflicts
	return -1
end if

if (ld_sumDO + ld_thisDO) < 0 then
	MessageBox("Validation Error", "On this voyage, the total quantity of LSGO used is less than zero. Please correct!")
	adw.POST setColumn("off_diesel_oil_used")
	destroy lds_tc_conflicts
	return -1
end if

if (ld_sumGO + ld_thisGO) < 0 then
	MessageBox("Validation Error", "On this voyage, the total quantity of HSGO used is less than zero. Please correct!")
	adw.POST setColumn("off_gas_oil_used")
	destroy lds_tc_conflicts
	return -1
end if

if (ld_sumLSHFO + ld_thisLSHFO) < 0 then
	MessageBox("Validation Error", "On this voyage, the total quantity of LSFO used is less than zero. Please correct!")
	adw.POST setColumn("off_lshfo_oil_used")
	destroy lds_tc_conflicts
	return -1
end if

/* First check if any conflicts*/
ll_periods = lds_tc_conflicts.retrieve(ii_vessel_nr, ldt_start, ldt_end)
if ll_periods > 0 then
	/* Her vises et pænere skærmbillede med dels conflictende contracter */
	openwithparm(w_check_conflict_offservice_tc, lds_tc_conflicts) 
	destroy lds_tc_conflicts
	return -1
end if

/* Then find out if any contract to transfer to, retrieve for later use */
ll_contracts = ids_tc_contracts.retrieve(ii_vessel_nr, ldt_start, ldt_end)

///* find out if there are tc contracts covering the same periode */
///* first check if vessel has any TC contract. li_contracts > 0 means Yes */
//ll_contracts = ids_tc_contracts.retrieve(ii_vessel_nr, ldt_start, ldt_end)
//if ll_contracts > 0 then
//	ll_periods = lds_tc_conflicts.retrieve(ii_vessel_nr, ldt_start, ldt_end)
//	if ll_periods > 0 then
//		/* Her vises et pænere skærmbillede med dels conflictende contracter */
//		openwithparm(w_check_conflict_offservice_tc, lds_tc_conflicts) 
//		destroy lds_tc_conflicts
//		return -1
//	end if
//end if

/* 	Check if the already is registred an offservice covering the same period or part of it
	this is only a warning */
/* first startdate */
SELECT COUNT(*)
	INTO :li_counter
	FROM OFF_SERVICES
	WHERE OPS_OFF_SERVICE_ID <> :ll_OPSoffserviceID
	AND OFF_START <= :ldt_start
	AND OFF_END > :ldt_start
	AND VESSEL_NR = :li_vessel ;
if li_counter > 0 then
	MessageBox("Warning", "Please be aware of that there already is an Off-Hire entered, covering the same or part of this period")
	return 1
end if

/* first enddate */
SELECT COUNT(*)
	INTO :li_counter
	FROM OFF_SERVICES
	WHERE OPS_OFF_SERVICE_ID <> :ll_OPSoffserviceID
	AND OFF_START < :ldt_end
	AND OFF_END >= :ldt_end
	AND VESSEL_NR = :li_vessel ;
if li_counter > 0 then
	MessageBox("Warning", "Please be aware of that there already is an Off-Hire entered, covering the same or part of this period")
end if

/* As a last check find out is there is match between POC and OffService bunker values entered
	GIVES ONLY WARNING */
lnv_bunkermatch = create n_voyage_offservice_bunker_consumption
/* HFO */
ld_testvalue = adw.getItemDecimal(1, "HFO_stock_start")
if isNull(ld_testvalue) then ld_testvalue = 0
if ld_testvalue > 0  then
	lnv_bunkermatch.of_find_match( "HFO", li_vessel , ls_voyage , ldt_start , ldt_end, ld_testvalue )
end if
/* DO */
ld_testvalue = adw.getItemDecimal(1, "DO_stock_start")
if isNull(ld_testvalue) then ld_testvalue = 0
if ld_testvalue > 0  then
	lnv_bunkermatch.of_find_match( "DO", li_vessel , ls_voyage , ldt_start , ldt_end ,ld_testvalue)
end if
/* GO */
ld_testvalue = adw.getItemDecimal(1, "GO_stock_start")
if isNull(ld_testvalue) then ld_testvalue = 0
if ld_testvalue > 0  then
	lnv_bunkermatch.of_find_match( "GO", li_vessel , ls_voyage , ldt_start , ldt_end , ld_testvalue)
end if
/* LSHFO */
ld_testvalue = adw.getItemDecimal(1, "LSHFO_stock_start")
if isNull(ld_testvalue) then ld_testvalue = 0
if ld_testvalue > 0  then
	lnv_bunkermatch.of_find_match( "LSHFO", li_vessel , ls_voyage , ldt_start , ldt_end , ld_testvalue)
end if
	
destroy lnv_bunkermatch

return 1
end function

private subroutine of_setprevioustransfer (ref datawindow adw_offservice);/* This function sets the yes and no options for transfer to the tc contract.
	If they have NOT been transferred before or it is a new off-service set default to 'Yes'
	Otherwise find the contract id and set the transfer to 'Yes' or 'No'   */
long ll_found
	
if adw_offservice.getItemStatus(1,0,primary!) = newModified! then return //default = yes

/* The off-service is modified, and we can set the transfer options acording to what is stored */
if istr_off_service.trans_to_tcin = 0 then
	ll_found = ids_tc_contracts.find("ntc_tc_contract_tc_hire_in=1",1,9999)
	if ll_found > 0 then ids_tc_contracts.setItem(ll_found, "transfer", 0)
end if

if istr_off_service.trans_to_tcout = 0 then
	ll_found = ids_tc_contracts.find("ntc_tc_contract_tc_hire_in=0",1,9999)
	if ll_found > 0 then ids_tc_contracts.setItem(ll_found, "transfer", 0)
end if
	
end subroutine

public subroutine documentation ();/********************************************************************
   n_offservice: Handles create, modify and delete of offservices, including transfer
	of off-services to TC Hire contracts
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		2003    		      		RMO   		First Version
		16/12/10		2209  		RMO   		Added update of TC payment balance when deleting
														off-services that where transferred
		10/07/13		2516  		LGX001		the validation of checking if Off Service comsumption is higher than voyage cosumption should be bypassed.when we do not have off service 										
		16/07/15		CR3226		XSZ004		Change message for Bunkers Type.
		11/11/2015  CR3133      SSX014      Remember transfer options
		12/09/2015  CR4213
	</HISTORY>
********************************************************************/

end subroutine

public function integer of_getreadonlystatus (long al_ops_off_service_id);string ls_status
long ll_payment_id
datetime ldt_cp_date
datetime ldt_est_due_date
string ls_suggestion
long ll_contract_id
return of_getpaymentstatusdescription(al_ops_off_service_id, ls_status, ll_payment_id, ldt_cp_date, ldt_est_due_date, ls_suggestion, ll_contract_id)

end function

public function long of_tcin_transfer ();long ll_count

ll_count = 0
SELECT COUNT(*) INTO :ll_count
FROM NTC_OFF_SERVICE NOS1, NTC_PAYMENT P1, NTC_TC_CONTRACT C1
WHERE NOS1.PAYMENT_ID = P1.PAYMENT_ID
AND P1.CONTRACT_ID = C1.CONTRACT_ID
AND C1.TC_HIRE_IN = 1
AND NOS1.OPS_OFF_SERVICE_ID = :istr_off_service.ops_off_service_id;

return ll_count

end function

public function long of_tcout_transfer ();long ll_count

ll_count = 0
SELECT COUNT(*) INTO :ll_count
FROM NTC_OFF_SERVICE NOS2, NTC_PAYMENT P2, NTC_TC_CONTRACT C2
WHERE NOS2.PAYMENT_ID = P2.PAYMENT_ID
AND P2.CONTRACT_ID = C2.CONTRACT_ID
AND C2.TC_HIRE_IN = 0
AND NOS2.OPS_OFF_SERVICE_ID = :istr_off_service.ops_off_service_id;

return ll_count

end function

public function integer of_getpaymentstatusdescription (long al_ops_off_service_id, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id);long ll_ops_off_service_id, ll_payment_status, ll_payment_id, ll_tchire_in, ll_contract_id
datetime ldt_cp_date, ldt_est_due_date
integer li_rc

ll_ops_off_service_id = al_ops_off_service_id
SELECT TOP 1 NTC_PAYMENT.PAYMENT_STATUS,
    NTC_PAYMENT.PAYMENT_ID,
    NTC_TC_CONTRACT.TC_HIRE_CP_DATE,
    NTC_PAYMENT.EST_DUE_DATE, NTC_TC_CONTRACT.CONTRACT_ID
	 INTO :ll_payment_status, :ll_payment_id, :ldt_cp_date, :ldt_est_due_date, :ll_contract_id
FROM NTC_OFF_SERVICE
INNER JOIN NTC_PAYMENT ON NTC_OFF_SERVICE.PAYMENT_ID = NTC_PAYMENT.PAYMENT_ID
INNER JOIN NTC_TC_CONTRACT ON NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
WHERE NTC_OFF_SERVICE.OPS_OFF_SERVICE_ID = :ll_ops_off_service_id
	AND NTC_PAYMENT.PAYMENT_STATUS >= 3
ORDER BY NTC_TC_CONTRACT.TC_HIRE_CP_DATE DESC;

if SQLCA.SQLCode = 0 then
	li_rc = 1
else
	li_rc = -1
end if

choose case ll_payment_status
	case 3
		as_status = "Final"
	case 4
		as_status = "Part Paid"
	case 5
		as_status = "Paid"
end choose

as_suggestion = "Contact Operations/Finance to unsettle and set the hire statement to Draft."

al_payment_id = ll_payment_id
adt_cp_date = ldt_cp_date
adt_est_due_date = ldt_est_due_date
al_contract_id = ll_contract_id

return li_rc
end function

public function integer of_getpaymentstatusdescription (datawindow adw, long al_row, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id);long ll_ops_off_service_id
ll_ops_off_service_id = adw.getitemnumber(al_row, "ops_off_service_id")
return of_getpaymentstatusdescription(ll_ops_off_service_id, as_status, al_payment_id, adt_cp_date, adt_est_due_date, as_suggestion, al_contract_id)

end function

on n_offservice.create
call super::create
end on

on n_offservice.destroy
call super::destroy
end on

event constructor;ids_tc_contracts = CREATE mt_n_datastore
ids_tc_contracts.dataObject = "d_find_tc_contract_for_periode"
ids_tc_contracts.setTransObject(SQLCA)

ids_tc_offservice = CREATE mt_n_datastore
ids_tc_offservice.dataObject = "d_table_ntc_off_service"
ids_tc_offservice.setTransObject(SQLCA)



end event

event destructor;destroy		ids_tc_contracts
destroy 		ids_tc_offservice
end event

