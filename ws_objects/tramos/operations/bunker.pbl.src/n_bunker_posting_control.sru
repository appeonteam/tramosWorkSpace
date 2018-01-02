$PBExportHeader$n_bunker_posting_control.sru
forward
global type n_bunker_posting_control from nonvisualobject
end type
end forward

global type n_bunker_posting_control from nonvisualobject
end type
global n_bunker_posting_control n_bunker_posting_control

type variables
private datastore ids_voyage_posted

end variables

forward prototypes
public function integer of_offservice_modified (integer ai_vessel, string as_voyage)
public function integer of_finish_voyage (integer ai_vessel, string as_voyage)
private function integer of_calc_and_post_bunker_consumption (integer ai_vessel, string as_voyage)
private function boolean of_apmcph_vessel (integer ai_vessel, string as_voyage)
public function integer of_portofcall_deleted (integer ai_vessel, string as_voyage)
public function integer of_portofcall_departure_modified (integer ai_vessel, string as_voyage)
private function integer of_tchire_buy_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn)
private function integer of_tchire_sell_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn)
public function integer of_bunkerpurchase_modified (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, string as_purpose, ref datastore ads_bunker)
private function integer of_tchire_lossprofit_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn)
public function boolean of_tcin_rate_zero (integer ai_vessel, string as_voyage, ref string as_headowner_snumber)
public subroutine documentation ()
public subroutine of_get_office_fin_emailaddr (long al_vesselnr, string as_voyagenr, ref string as_email[])
end prototypes

public function integer of_offservice_modified (integer ai_vessel, string as_voyage);datetime	ldt_poc_arr_test
string	ls_begin_trans="begin transaction"
string ls_rollback_trans="rollback transaction"
string ls_commit_trans="commit transaction"

if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_offservice_modified()")
	return -1
end if
commit;

/* Check if voyage finished. Only if voyage is finished, the bunker consumption shall be posted */
if ids_voyage_posted.getItemNumber(1, "voyage_finished") = 0 then
	return 1
end if

/* Check if voyage type is TC-OUT - nothing to post */
if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
	return 1
end if

// New for version 12. Create bunker transactions every time the voyage is finished.
// but only if voyage is newer than 1. june 2003
SELECT Min(PORT_ARR_DT)
	INTO :ldt_poc_arr_test
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage  ;
commit;
if ldt_poc_arr_test < Datetime(date("1 June 2003")) then
	return 1
end if

/* Start new transaction to ensure that nothing is accepted unless everything went OK*/
execute immediate :ls_begin_trans;
/* Calculate voyage consumption bunker/offservice and post it to CODA */
if of_calc_and_post_bunker_consumption( ai_vessel,  as_voyage ) = -1 then
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if
execute immediate :ls_commit_trans ;
commit;

return 1
end function

public function integer of_finish_voyage (integer ai_vessel, string as_voyage);datetime	ldt_poc_arr_test
string	ls_begin_trans="begin transaction"
string ls_rollback_trans="rollback transaction"
string ls_commit_trans="commit transaction"

if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_finish_voyage()")
	return -1
end if
commit;

/* Check if voyage is already finished. */
if ids_voyage_posted.getItemNumber(1, "voyage_finished") = 1 then
	MessageBox("Finish Error", "Voyage already finished!.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_finish_voyage()")
	return 1
end if

/* Check if voyage type is TC-OUT */
if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
	MessageBox("Information","This is a TC Out voyage. There will NOT be generated a" &
	 	+"~rbunker transaction for CODA on finish voyage!.~r~n~r~n" & 
		+ "Object: n_bunker_posting_control, Function: of_finish_voyage()")
	ids_voyage_posted.setItem(1, "voyage_finished", 1)
	if ids_voyage_posted.update() <> 1 then
		MessageBox("Error","Error updating voyage table! Finish of voyage not set.~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_finish_voyage()")
		rollback;
		Return -1
	else
		commit;
		return 1
	end if
end if

// New for version 12. Create bunker transactions every time the voyage is finished.
SELECT Min(PORT_ARR_DT)
	INTO :ldt_poc_arr_test
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage  ;
commit;
if ldt_poc_arr_test < Datetime(date("1 June 2003")) then
	MessageBox("Important Message","The voyage has been started before 1. june 2003. " &
		+"~rThere will be no new bunker transaction for CODA this time !. Please do manual transactions." &
		+ "Object: n_bunker_posting_control, Function: of_finish_voyage()")
	return 1
end if

/* Start new transaction to ensure that nothing is accepted unless everything went OK*/
execute immediate :ls_begin_trans;
/* Calculate voyage consumption bunker/offservice and post it to CODA */
if of_calc_and_post_bunker_consumption( ai_vessel,  as_voyage ) = -1 then
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if
execute immediate :ls_commit_trans ;
commit;

if isValid(w_bunker_purchase) then
	w_bunker_purchase.POSTevent("ue_refresh")
end if

return 1
end function

private function integer of_calc_and_post_bunker_consumption (integer ai_vessel, string as_voyage);/* This function calculates bunker consumption for one voyage aswell as
	bunker consumption during off service.
	Checks if bunker has been posted before, and generate transactions
	to CODA for all / difference in what has been posted before.
	As last step posted values are stored in voyage table		*/
u_transaction_bunker							lnv_bunker_trans
n_voyage_bunker_consumption				lnv_bunker
n_voyage_offservice_bunker_consumption	lnv_offservice
s_transaction_input								lstr_transaction_input
mt_n_outgoingmail								lnv_mail
decimal{2}											ld_calc_offservice, ld_offservice_ton
decimal{2}											ld_temp_bunker
decimal{2} ld_hfo_price, ld_do_price, ld_go_price, ld_lshfo_price, ld_offservice
decimal{4} ld_hfo_ton, ld_do_ton, ld_go_ton, ld_lshfo_ton
string		ls_subject, ls_errormessage, ls_vessel_ref_nr, ls_message, ls_receivermail[]
long ll_loop



if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_calc_and_post_bunker_consumption()")
	return -1
end if
commit;

/* Calculate voyage bunker consumption */
lnv_bunker = create n_voyage_bunker_consumption
lnv_bunker.of_calculate( "HFO", ai_vessel , as_voyage , ld_hfo_price , ld_hfo_ton )
lnv_bunker.of_calculate( "DO", ai_vessel , as_voyage , ld_do_price , ld_do_ton )
lnv_bunker.of_calculate( "GO", ai_vessel , as_voyage , ld_go_price , ld_go_ton )
lnv_bunker.of_calculate( "LSHFO", ai_vessel , as_voyage , ld_lshfo_price , ld_lshfo_ton )
destroy lnv_bunker

/* Calculate voyage offservice bunker consumption */
lnv_offservice = create n_voyage_offservice_bunker_consumption
lnv_offservice.of_calculate(  "HFO", ai_vessel , as_voyage , ld_calc_offservice , ld_offservice_ton )
ld_hfo_price -= ld_calc_offservice
ld_hfo_ton -= ld_offservice_ton
ld_offservice += ld_calc_offservice
lnv_offservice.of_calculate(  "DO", ai_vessel , as_voyage , ld_calc_offservice , ld_offservice_ton )
ld_do_price -= ld_calc_offservice
ld_do_ton -= ld_offservice_ton
ld_offservice += ld_calc_offservice
lnv_offservice.of_calculate(  "GO", ai_vessel , as_voyage , ld_calc_offservice , ld_offservice_ton )
ld_go_price -= ld_calc_offservice
ld_go_ton -= ld_offservice_ton
ld_offservice += ld_calc_offservice
lnv_offservice.of_calculate(  "LSHFO", ai_vessel , as_voyage , ld_calc_offservice , ld_offservice_ton )
ld_lshfo_price -= ld_calc_offservice
ld_lshfo_ton -= ld_offservice_ton
ld_offservice += ld_calc_offservice
destroy lnv_offservice

/* Check what is already posted and update */
ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_hfo")
ids_voyage_posted.setItem(1, "bunker_posted_hfo", ld_hfo_price )     //new value that has been posted
ld_hfo_price -= ld_temp_bunker												//what to post this time

ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_do")
ids_voyage_posted.setItem(1, "bunker_posted_do", ld_do_price )     //new value that has been posted
ld_do_price -= ld_temp_bunker												//what to post this time

ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_go")
ids_voyage_posted.setItem(1, "bunker_posted_go", ld_go_price )     //new value that has been posted
ld_go_price -= ld_temp_bunker												//what to post this time

ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_lshfo")
ids_voyage_posted.setItem(1, "bunker_posted_lshfo", ld_lshfo_price )     //new value that has been posted
ld_lshfo_price -= ld_temp_bunker													//what to post this time

/* Check if off services shall be posted or not */
/* First check if vessel is an APM CPH vessel */
if of_apmcph_vessel(ai_vessel, as_voyage) then 
	ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_offservice")
	ids_voyage_posted.setItem(1, "bunker_posted_offservice", ld_offservice )     //new value that has been posted
	ld_offservice -= ld_temp_bunker														 //what to post this time
	lstr_transaction_input.s_bunker_values.apmvessel_or_tcinzero = true		// = apm vessel
/* then check if vessel on TC-IN zero rate contract */
elseif of_tcin_rate_zero( ai_vessel, as_voyage, lstr_transaction_input.s_bunker_values.headowner_Snumber ) then
	ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_offservice")
	ids_voyage_posted.setItem(1, "bunker_posted_offservice", ld_offservice )     //new value that has been posted
	ld_offservice -= ld_temp_bunker														 //what to post this time
	lstr_transaction_input.s_bunker_values.apmvessel_or_tcinzero = false		// = TC-IN with Rate Zero
else
	
	if ld_offservice <> 0 then
	
		lnv_mail = create mt_n_outgoingmail
	
		SELECT  VESSEL_REF_NR
		INTO  :ls_vessel_ref_nr
		FROM VESSELS WHERE VESSEL_NR = :ai_vessel;
		COMMIT;
		 		
		of_get_office_fin_emailaddr(ai_vessel, as_voyage, ls_receivermail)
		
		ls_subject = "V"+ls_vessel_ref_nr+" T"+as_voyage+" Invoice Bunker during Off Service: Missing B-posts"
		
		ls_message = "Please make bunker during Off hire posting: ~r~n" &
									+ "CR/DB 1201110 and DB/CR 1241165 (check AX for posting) ~r~n~r~n" &
									+ "Vessel = " + ls_vessel_ref_nr + " ~r~n"  & 
									+ "Voyage = " + as_voyage + " ~r~n" &
									+ "Amount = " + string (ld_offservice, "#,##0.00")
	
		if upperbound(ls_receivermail) > 0 then
			
			if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receivermail[1] ,ls_subject , ls_message, ls_errorMessage) = c#return.Success then
				for ll_loop = 2 to upperbound(ls_receivermail)
					 lnv_mail.of_addreceiver(ls_receivermail[ll_loop], ls_errorMessage)
				next							
				if lnv_mail.of_sendmail(ls_errorMessage) = c#return.Failure then
					messagebox("Warning", "Alert email failed. Please send an email to " + ls_receivermail[1] + " ~r~n Message: Off-hire posting failed (CR/DB 1201110 and DB/CR 1241165 (check AX for posting) ) ")
				end if			
			else
				messagebox("Warning", "Email creation failed. Please send an email to " + ls_receivermail[1] + " ~r~n Message: Off-hire posting failed (CR/DB 1201110 and DB/CR 1241165 (check AX for posting) ) ")
			end if
		else
			messagebox("Warning", "Email creation failed. No email address found." +  + " ~r~n Message: Off-hire posting failed (CR/DB 1201110 and DB/CR 1241165 (check AX for posting) ) ")
		end if	
		
		destroy lnv_mail
	
	end if
	
	ld_offservice = 0

end if

/* Check if anything to post at all, and just return if nothing  */
if ld_hfo_price <> 0 or ld_do_price <> 0 or ld_go_price <> 0 or ld_lshfo_price <> 0 or ld_offservice <> 0 then 
	lstr_transaction_input.vessel_no = ai_vessel
	lstr_transaction_input.voyage_no = Left(as_voyage,5)
	lstr_transaction_input.full_voyage_no = as_voyage
	lstr_transaction_input.coda_or_cms = TRUE
	lstr_transaction_input.s_bunker_values.hfo_amount = ld_hfo_price
	lstr_transaction_input.s_bunker_values.hfo_ton = ld_hfo_ton
	lstr_transaction_input.s_bunker_values.do_amount = ld_do_price
	lstr_transaction_input.s_bunker_values.do_ton = ld_do_ton
	lstr_transaction_input.s_bunker_values.go_amount = ld_go_price
	lstr_transaction_input.s_bunker_values.go_ton = ld_go_ton
	lstr_transaction_input.s_bunker_values.lshfo_amount = ld_lshfo_price
	lstr_transaction_input.s_bunker_values.lshfo_ton = ld_lshfo_ton
	lstr_transaction_input.s_bunker_values.offservice_amount = ld_offservice
	
	lnv_bunker_trans = CREATE u_transaction_bunker
	IF lnv_bunker_trans.of_generate_transaction(lstr_transaction_input) <> 1 THEN
		MessageBox("Error","Error in generation of bunker transaction for CODA. ~r" &
						+ "Finished of voyage not set.~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_calc_and_post_bunker_consumption()")
		Destroy lnv_bunker_trans ;
		Return -1
	END IF
end if

ids_voyage_posted.setItem(1, "voyage_finished", 1)
if ids_voyage_posted.update() <> 1 then
	MessageBox("Error","Error updating voyage table! Finish of voyage not set.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_calc_and_post_bunker_consumption()")
	rollback;
	destroy lnv_bunker_trans ;
	Return -1
end if
commit;

Destroy lnv_bunker_trans;
return 1
end function

private function boolean of_apmcph_vessel (integer ai_vessel, string as_voyage);/* This function returns if vessel is an APM Copenhagen Owned vessel when this voyage is performed

	If a vessel is a copenhagen owned vessel is checked by investigating if first port arrival date
	is inside a TC-IN contract or not. TC in contract = not APM CPH, NO TC in contract = APM CPH 
	
	Return TRUE if vessel is APM Copenhagen Owned  */
datetime		ldt_min_arrival
long			ll_counter

/* First find min. port arrival date for voyage */
SELECT min(PORT_ARR_DT)
	INTO :ldt_min_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage;
if sqlca.sqlcode <> 0 then
	commit;
	MessageBox("Information", "No port arrival date found for this voyage. Off Service bunker will not be posted to CODA~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_apmcph_vessel()")
	Return false
end if
commit;

/* Find out if there is a TC IN Contract covering arrival date. If not vessel is an APM CPH owned vessel */
SELECT count(*)  
	INTO :ll_counter
	FROM NTC_TC_CONTRACT,   
		NTC_TC_PERIOD  
	WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID  
	AND NTC_TC_PERIOD.PERIODE_START <= :ldt_min_arrival 
	AND NTC_TC_PERIOD.PERIODE_END > :ldt_min_arrival
	AND NTC_TC_CONTRACT.VESSEL_NR = :ai_vessel
	AND NTC_TC_CONTRACT.TC_HIRE_IN = 1 ;
commit;

if ll_counter > 0 then 
	return false
else
	return true
end if


end function

public function integer of_portofcall_deleted (integer ai_vessel, string as_voyage);/* This function will post changes in bunker consumption for next voyage if it is finished
	This is implemented because of the possibility of this voyage influenting on next
	voyage bunker consumption.
	Only valid if it is the last portcall that is deleted = start stock for next voyage */
datastore	lds_later_voyages
string			ls_begin_trans="begin transaction"
string	 		ls_rollback_trans="rollback transaction"
string 		ls_commit_trans="commit transaction"

lds_later_voyages = create datastore
lds_later_voyages.dataObject = "d_sq_tb_later_voyages"
lds_later_voyages.setTransObject(sqlca)

if lds_later_voyages.retrieve(ai_vessel, as_voyage) < 1 then
	/* No voyages later than this one that could have a change in bunker consumption */ 
	commit;
	destroy lds_later_voyages
	return 1
end if
commit;

/* Check if voyage is finished or not. */
if lds_later_voyages.getItemNumber(1, "voyage_finished") = 0 then
	/* No posting for this voyage as it is not finished */
	destroy lds_later_voyages
	return 1
end if

/* Check if voyage type is TC-OUT */
if lds_later_voyages.getItemNumber(1, "voyage_type") = 2 then
	/* No posting for TC-OUT voyages */
	destroy lds_later_voyages
	return 1
end if


/* Start new transaction to ensure that nothing is accepted unless everything went OK*/
execute immediate :ls_begin_trans;
/* Calculate voyage consumption bunker/offservice and post it to CODA !!!BUT FOR NEXT VOYAGE!!! */
if of_calc_and_post_bunker_consumption( ai_vessel,  lds_later_voyages.getItemString(1, "voyage_nr"))= -1 then
	execute immediate :ls_rollback_trans;
	rollback;
	destroy lds_later_voyages
	return -1
end if
execute immediate :ls_commit_trans ;
commit;
destroy lds_later_voyages

if isValid(w_bunker_purchase) then
	w_bunker_purchase.POSTevent("ue_refresh")
end if

return 1
end function

public function integer of_portofcall_departure_modified (integer ai_vessel, string as_voyage);/* This function will post changes in bunker consumption for next voyage if it is finished
	This is implemented because of the possibility of this voyage influenting on next
	voyage bunker consumption.
	Only valid if it is the last portcall that is event departure start stock for next voyage */
datastore	lds_later_voyages
string			ls_begin_trans="begin transaction"
string	 		ls_rollback_trans="rollback transaction"
string 		ls_commit_trans="commit transaction"

lds_later_voyages = create datastore
lds_later_voyages.dataObject = "d_sq_tb_later_voyages"
lds_later_voyages.setTransObject(sqlca)

if lds_later_voyages.retrieve(ai_vessel, as_voyage) < 1 then
	/* No voyages later than this one that could have a change in bunker consumption */ 
	commit;
	destroy lds_later_voyages
	return 1
end if
commit;

/* Check if voyage is finished or not. */
if lds_later_voyages.getItemNumber(1, "voyage_finished") = 0 then
	/* No posting for this voyage as it is not finished */
	destroy lds_later_voyages
	return 1
end if

/* Check if voyage type is TC-OUT */
if lds_later_voyages.getItemNumber(1, "voyage_type") = 2 then
	/* No posting for TC-OUT voyages */
	destroy lds_later_voyages
	return 1
end if

/* Start new transaction to ensure that nothing is accepted unless everything went OK*/
execute immediate :ls_begin_trans;
/* Calculate voyage consumption bunker/offservice and post it to CODA !!!BUT FOR NEXT VOYAGE!!! */
if of_calc_and_post_bunker_consumption( ai_vessel,  lds_later_voyages.getItemString(1, "voyage_nr"))= -1 then
	execute immediate :ls_rollback_trans;
	rollback;
	destroy lds_later_voyages
	return -1
end if
execute immediate :ls_commit_trans ;
commit;

destroy lds_later_voyages
return 1
end function

private function integer of_tchire_buy_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn);/* This function calculates the price for the bunker bought at this port.
	Function is only called if following combination is valid for port
			- TC-OUT and REDELIVERY
			- TC-IN and event DELIVERY
	and therefore it is not necessary to check it here again 
	
	REMEMBER THAT THIS FUNCTION ALWAYS WILL BE INSIDE ANOTHER DB TRANSACTION
	*/
s_transaction_input	lstr_transaction_input
u_transaction_bunker_tc_buy_sell	lnv_bunker_trans
decimal{2}	ld_temp_bunker

if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_buy_bunker()")
	return -1
end if
commit;

/* Check voyage type and retrieve values */
if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
	/* TC-OUT buy from Charterer */
	/* Get sum of bought bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0),
			 sum(BP_DETAILS.LIFTED_HFO) + sum(BP_DETAILS.LIFTED_DO) + sum(BP_DETAILS.LIFTED_GO) + sum(BP_DETAILS.LIFTED_LSHFO)
		INTO :lstr_transaction_input.amount_usd, :lstr_transaction_input.bunker_ton
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 0 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2  ;
	commit;	
else
	/* TC-IN buy from Headowner */
	/* Get sum of bought bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0),
			 sum(BP_DETAILS.LIFTED_HFO) + sum(BP_DETAILS.LIFTED_DO) + sum(BP_DETAILS.LIFTED_GO) + sum(BP_DETAILS.LIFTED_LSHFO)
		INTO :lstr_transaction_input.amount_usd, :lstr_transaction_input.bunker_ton
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 0 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0  ;
	commit;	
end if

/* Check what is already posted and update */
ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_buy")
ids_voyage_posted.setItem(1, "bunker_posted_buy", lstr_transaction_input.amount_usd )     //new value that has been posted
lstr_transaction_input.amount_usd -= ld_temp_bunker													//what to post this time
lstr_transaction_input.control_no = "Buy"

/* Check if anything to post at all, and just return if nothing  */
if  lstr_transaction_input.amount_usd <> 0 then 
	lstr_transaction_input.vessel_no = ai_vessel
	lstr_transaction_input.voyage_no = Left(as_voyage,5)
	lstr_transaction_input.coda_or_cms = TRUE
	
	lnv_bunker_trans = CREATE u_transaction_bunker_tc_buy_sell
	IF lnv_bunker_trans.of_generate_transaction(lstr_transaction_input) <> 1 THEN
		MessageBox("Error","Error in generation of bunker transaction for bought bunker to CODA.~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_tchire_buy_bunker()")
		Destroy lnv_bunker_trans ;
		Return -1
	END IF
end if
Destroy lnv_bunker_trans;

if ids_voyage_posted.update() <> 1 then
	MessageBox("Error","Error updating voyage table! Bunker bought not set.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_buy_bunker()")
	rollback;
	Return -1
end if

commit;
return 1
end function

private function integer of_tchire_sell_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn);/* This function calculates the price for the bunker sold at this port.
	Function is only called if following combination is valid for port
			- TC-OUT and DELIVERY
			- TC-IN and REDELIVERY
	and therefore it is not necessary to check it here again 
	
	REMEMBER THAT THIS FUNCTION ALWAYS WILL BE INSIDE ANOTHER DB TRANSACTION
	*/
s_transaction_input	lstr_transaction_input
u_transaction_bunker_tc_buy_sell	lnv_bunker_trans
decimal{2}	ld_temp_bunker

if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_sell_bunker()")
	return -1
end if
commit;

/* Check voyage type and retrieve values */
if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
	/* TC-OUT sell to Charterer */
	/* Get sum of sold bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0),
			 sum(BP_DETAILS.LIFTED_HFO) + sum(BP_DETAILS.LIFTED_DO) + sum(BP_DETAILS.LIFTED_GO) + sum(BP_DETAILS.LIFTED_LSHFO)
		INTO :lstr_transaction_input.amount_usd, :lstr_transaction_input.bunker_ton
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2;
	commit;	
else
	/* TC-IN sell to Headowner */
	/* Get sum of sold bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0),
			 sum(BP_DETAILS.LIFTED_HFO) + sum(BP_DETAILS.LIFTED_DO) + sum(BP_DETAILS.LIFTED_GO) + sum(BP_DETAILS.LIFTED_LSHFO)
		INTO :lstr_transaction_input.amount_usd, :lstr_transaction_input.bunker_ton
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0  ;
	commit;	
end if

/* Check what is already posted and update */
ld_temp_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_sell")
ids_voyage_posted.setItem(1, "bunker_posted_sell", lstr_transaction_input.amount_usd )     //new value that has been posted
lstr_transaction_input.amount_usd -= ld_temp_bunker					   							  //what to post this time
lstr_transaction_input.control_no = "Sell"

/* Check if anything to post at all, and just return if nothing  */
if  lstr_transaction_input.amount_usd <> 0 then 
	lstr_transaction_input.vessel_no = ai_vessel
	lstr_transaction_input.voyage_no = Left(as_voyage,5)
	lstr_transaction_input.coda_or_cms = TRUE
	
	lnv_bunker_trans = CREATE u_transaction_bunker_tc_buy_sell
	IF lnv_bunker_trans.of_generate_transaction(lstr_transaction_input) <> 1 THEN
		MessageBox("Error","Error in generation of bunker transaction for sold bunker to CODA.~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_tchire_sell_bunker()")
		Destroy lnv_bunker_trans ;
		Return -1
	END IF
end if
Destroy lnv_bunker_trans;

if ids_voyage_posted.update() <> 1 then
	MessageBox("Error","Error updating voyage table! Bunker sold not set.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_sell_bunker()")
	rollback;
	Return -1
end if

commit;
return 1
end function

public function integer of_bunkerpurchase_modified (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, string as_purpose, ref datastore ads_bunker);/* This function controls the posting of bunker consumption when an order is modified
	
	1. First check if there shall be posted any bunker at all. If no purpose there can't be loaded anything 
	2. Check om der er nogle rækker i datastore visible or deleted
	3. check om der er ændret noget der har indflydelse på bunker beregning
	4. find out if there is a TC-IN Redelivery later on this voyage - recalc LOSS OR PROFIT
	5. find out if there shall be generated bunkerconsumption transactions for subsequent voyages
	6. find out if any subsequent voyages where bunker is sold TC-OUT DEL / TC-IN RED and therefore 
	    generatetrans of type LOSS OR PROFIT
*/
boolean 		lb_bunkerConsumption=false, lb_buy=false, lb_sell=false //if sell then also loss/profit
long			ll_rows, ll_row, ll_counter
datastore	lds_later_voyages
string			ls_begin_trans="begin transaction"
string	 		ls_rollback_trans="rollback transaction"
string 		ls_commit_trans="commit transaction"
string			ls_lossprofit_portcode, ls_later_voyage
integer		li_lossprofit_pcn

/* Retrieve information about current voyage */
if ids_voyage_posted.retrieve( ai_vessel, as_voyage ) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
	return -1
end if
commit;

/* There can't be loaded bunker when no purpose, and therefore no posting */
if isNull(as_purpose) then
	return 1
end if

/* No rows return */
if ads_bunker.rowcount() + ads_bunker.deletedcount() = 0 then
	return 1
end if

ll_rows = ads_bunker.rowCount()
if ll_row < 1 then
	/* Then there must be a row in deleted*/
	lb_bunkerConsumption = true
	choose case as_purpose 
		case "DEL" 
			if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
				lb_sell 	= true
				lb_buy 	= false
				lb_bunkerConsumption = false
			else
				lb_sell 	= false
				lb_buy 	= true
			end if
		case "RED" 
			if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
				lb_sell 	= false
				lb_buy 	= true
			else
				lb_sell 	= true
				lb_buy 	= false
				lb_bunkerConsumption = false
			end if
		case else
	end choose	
else
	for ll_row = 1 to ll_rows
		if ads_bunker.getItemStatus( ll_row, "price_hfo", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "price_do", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "price_go", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "price_lshfo", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "lifted_hfo", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "lifted_do", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "lifted_go", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "lifted_lshfo", primary!) = dataModified! &
		or ads_bunker.getItemStatus( ll_row, "fifo_sequence", primary!) = dataModified! then
			lb_bunkerConsumption = true
		end if
	next
	choose case as_purpose 
		case "DEL" 
			if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
				lb_sell 	= true
				lb_buy 	= false
				lb_bunkerConsumption = false
			else
				lb_sell 	= false
				lb_buy 	= true
			end if
		case "RED" 
			if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
				lb_sell 	= false
				lb_buy 	= true
			else
				lb_sell 	= true
				lb_buy 	= false
				lb_bunkerConsumption = false
			end if
		case else
	end choose	
end if

/* Start new transaction to ensure that nothing is accepted unless everything went OK*/
execute immediate :ls_begin_trans;

if lb_buy then
	if of_tchire_buy_bunker( ai_vessel,  as_voyage, as_portcode, ai_pcn ) = -1 then
		MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
						+" for bunker bought. No transaction generated for CODA. Please contact~r~n" &
						+ " System Administartor~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
		execute immediate :ls_rollback_trans;
		rollback;
		return -1
	end if
end if

if lb_sell then
	if of_tchire_sell_bunker( ai_vessel,  as_voyage, as_portcode, ai_pcn ) = -1 then
		MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
						+" for bunker sold. No transaction generated for CODA. Please contact~r~n" &
						+ " System Administartor~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
		execute immediate :ls_rollback_trans;
		rollback;
		return -1
	end if

	if of_tchire_lossprofit_bunker( ai_vessel,  as_voyage, as_portcode, ai_pcn ) = -1 then
		MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
						+" for bunker sold - Loss / Profit. No transaction generated for CODA. Please contact~r~n" &
						+ " System Administartor~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
		execute immediate :ls_rollback_trans;
		rollback;
		return -1
	end if
end if	

if lb_bunkerConsumption then
	lds_later_voyages = create datastore
	lds_later_voyages.dataObject = "d_sq_tb_later_voyages"
	lds_later_voyages.setTransObject(sqlca)
	
	ll_rows = lds_later_voyages.retrieve(ai_vessel, as_voyage) 
	if  ll_rows < 1 then
		/* No voyages later than this one that could have a change in bunker consumption */ 
		commit;
		destroy lds_later_voyages
		execute immediate :ls_commit_trans;
		commit;
		return 1
	end if
	commit;

	for ll_row = 1 to ll_rows
		/* Check if voyage is finished or not. */
		if lds_later_voyages.getItemNumber(ll_row, "voyage_finished") = 0 and  lds_later_voyages.getItemNumber(ll_row, "voyage_type") <> 2 then
			/* No posting for this voyage as it is not finished unless it is a TC_OUT voyage where there could be loss/profit when selling bunker */
			continue	
		end if
		
		ls_later_voyage = lds_later_voyages.getItemString(ll_row, "voyage_nr")
		
		/* Find out if any subsequent voyages where bunker is sold TC-OUT DEL / TC-IN RED and therefore generatetrans of type LOSS OR PROFIT */
		setNull(ls_lossprofit_portcode)
		 SELECT POC.PORT_CODE, POC.PCN
		 INTO :ls_lossprofit_portcode, :li_lossprofit_pcn
		 FROM BP_DETAILS, POC  
		WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR  
		AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR 
		AND POC.PORT_CODE = BP_DETAILS.PORT_CODE 
		AND POC.PCN = BP_DETAILS.PCN 
		AND BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :ls_later_voyage 
		AND( (BP_DETAILS.BUY_SELL = 1 AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0 AND POC.PURPOSE_CODE = "RED" AND CHAR_LENGTH(RTRIM(BP_DETAILS.VOYAGE_NR))=5)
		OR (BP_DETAILS.BUY_SELL = 1 AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2 AND POC.PURPOSE_CODE = "DEL" AND CHAR_LENGTH(RTRIM(BP_DETAILS.VOYAGE_NR))=7) );
		commit;
		if NOT isNull(ls_lossprofit_portcode) then
			if of_tchire_lossprofit_bunker( ai_vessel,  ls_later_voyage, ls_lossprofit_portcode , li_lossprofit_pcn ) = -1 then
				MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
								+" for bunker sold - Loss / Profit. No transaction generated for CODA. Please contact~r~n" &
								+ " System Administartor~r~n~r~n" &
								+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
				execute immediate :ls_rollback_trans;
				rollback;
				return -1
			end if
		end if		

		/* Check if voyage type is TC-OUT */
		if lds_later_voyages.getItemNumber(ll_row, "voyage_type") = 2 then
			/* No posting for this voyage as it is TC-OUT voyage */
			continue	
		end if
		
		/* Calculate voyage consumption bunker/offservice and post it to CODA */

		if of_calc_and_post_bunker_consumption( ai_vessel, ls_later_voyage ) = -1 then
			MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
							+" for bunker consumption on voyage "+ ls_later_voyage +". No transaction generated for CODA. Please contact~r~n" &
							+ " System Administartor~r~n~r~n" &
							+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
			destroy lds_later_voyages				
			execute immediate :ls_rollback_trans;
			rollback;
			return -1
		end if
	next

	/* 	Find out if there is a TC-IN Redelivery later on this voyage - recalc LOSS OR PROFIT */
	setNull(ls_lossprofit_portcode)
	if as_purpose <> "DEL" and as_purpose <> "RED" then
		 SELECT POC.PORT_CODE, POC.PCN
		 INTO :ls_lossprofit_portcode, :li_lossprofit_pcn
		 FROM BP_DETAILS, POC  
		WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR  
		AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR 
		AND POC.PORT_CODE = BP_DETAILS.PORT_CODE 
		AND POC.PCN = BP_DETAILS.PCN 
		AND BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0 
		AND POC.PURPOSE_CODE = "RED" ;
	end if	
	commit;
	if NOT isNull(ls_lossprofit_portcode) then
		if of_tchire_lossprofit_bunker( ai_vessel,  as_voyage, ls_lossprofit_portcode , li_lossprofit_pcn ) = -1 then
			MessageBox("Transaction Error", "Something went wrong when generating CODA transaction~r~n" &
							+" for bunker sold - Loss / Profit. No transaction generated for CODA. Please contact~r~n" &
							+ " System Administartor~r~n~r~n" &
							+ "Object: n_bunker_posting_control, Function: of_bunkerpurchase_modified()")
			execute immediate :ls_rollback_trans;
			rollback;
			return -1
		end if
	end if		
end if

execute immediate :ls_commit_trans ;
commit;

return 1
end function

private function integer of_tchire_lossprofit_bunker (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn);/*	This function calculates if there are any loss or profit when bunker is sold
	and post it in CODA.
	
	1. calculates the value of the bunker just before selling 
	2. calculates the price for the bunker sold at this port.
	Function is only called if following combination is valid for port
			- TC-OUT and DELIVERY
			- TC-IN and REDELIVERY
	and therefore it is not necessary to check it here again 
	
	REMEMBER THAT THIS FUNCTION ALWAYS WILL BE INSIDE ANOTHER DB TRANSACTION
*/
s_transaction_input						lstr_transaction_input
u_transaction_bunker_tc_loss_prof	lnv_bunker_trans
n_port_arrival_bunker_value			lnv_bunkervalue
decimal{2}									ld_arrival_value, ld_sold, ld_posted_bunker
long											ll_counter

if ids_voyage_posted.retrieve(ai_vessel, as_voyage) <> 1 then
	MessageBox("Retrieval Error", "There was an error when retrieving voyage information.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_lossprofit_bunker()")
	return -1
end if
commit;

/* Get bunker value on arrival */
lnv_bunkervalue = create n_port_arrival_bunker_value			
lnv_bunkervalue.of_calculate( "ALL", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_arrival_value )
destroy lnv_bunkervalue

/* Check voyage type and retrieve sold values */
if ids_voyage_posted.getItemNumber(1, "voyage_type") = 2 then
	/* TC-OUT sell to Charterer */
	/* Get sum of sold bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0)
		INTO :ld_sold
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2  ;
	commit;
	/* if sold = 0 check if sold to 0 (zero) or last order deleted */
	if ld_sold = 0 then
		SELECT count(*)
			INTO :ll_counter
			FROM BP_DETAILS  
			WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
			AND BP_DETAILS.VOYAGE_NR = :as_voyage 
			AND BP_DETAILS.PORT_CODE = :as_portcode 
			AND BP_DETAILS.PCN = :ai_pcn 
			AND BP_DETAILS.BUY_SELL = 1 
			AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2  ;
		commit;
	end if
	if ld_sold = 0 and ll_counter = 0 then   /* sell order deleted */
		lstr_transaction_input.amount_usd = 0
	else											/* sold to zero, or normal sell order */
		lstr_transaction_input.amount_usd = abs(ld_sold) - ld_arrival_value
	end if	
else
	/* TC-IN sell to Headowner */
	/* Get sum of sold bunker */
	SELECT ISNULL(sum(round(BP_DETAILS.LIFTED_HFO * isnull(BP_DETAILS.PRICE_HFO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_DO * isnull(BP_DETAILS.PRICE_DO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_GO * isnull(BP_DETAILS.PRICE_GO,0),2))   
			 + sum(round(BP_DETAILS.LIFTED_LSHFO * isnull(BP_DETAILS.PRICE_LSHFO,0),2)),0)
		INTO :ld_sold
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0  ;
	commit;	
	/* if sold = 0 check if sold to 0 (zero) or last order deleted */
	if ld_sold = 0 then
		SELECT count(*)
		INTO :ll_counter
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :ai_vessel 
		AND BP_DETAILS.VOYAGE_NR = :as_voyage 
		AND BP_DETAILS.PORT_CODE = :as_portcode 
		AND BP_DETAILS.PCN = :ai_pcn 
		AND BP_DETAILS.BUY_SELL = 1 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 0  ;
		commit;
	end if
	if ld_sold = 0 and ll_counter = 0 then   /* sell order deleted */
		lstr_transaction_input.amount_usd = 0
	else											/* sold to zero, or normal sell order */
		lstr_transaction_input.amount_usd = abs(ld_sold) - ld_arrival_value
	end if	
end if

/* Check what is already posted and update */
ld_posted_bunker =  ids_voyage_posted.getItemDecimal(1, "bunker_posted_lossprofit")
ids_voyage_posted.setItem(1, "bunker_posted_lossprofit", lstr_transaction_input.amount_usd )     //new value that has been posted
//lstr_transaction_input.amount_usd -= ld_posted_bunker						  							//what to post this time
lstr_transaction_input.previous_amount_usd = ld_posted_bunker			//this is used to revert previous postings

/* Check if anything to post at all, and just return if nothing  */
if  lstr_transaction_input.amount_usd <> 0  or lstr_transaction_input.previous_amount_usd <> 0 then 
	lstr_transaction_input.vessel_no = ai_vessel
	lstr_transaction_input.voyage_no = Left(as_voyage,5)
	lstr_transaction_input.coda_or_cms = TRUE
	
	lnv_bunker_trans = CREATE u_transaction_bunker_tc_loss_prof
	IF lnv_bunker_trans.of_generate_transaction(lstr_transaction_input) <> 1 THEN
		MessageBox("Error","Error in generation of bunker transaction for sold bunker to CODA.~r~n~r~n" &
						+ "Object: n_bunker_posting_control, Function: of_tchire_lossprofit_bunker()")
		Destroy lnv_bunker_trans ;
		Return -1
	END IF
end if
Destroy lnv_bunker_trans;

if ids_voyage_posted.update() <> 1 then
	MessageBox("Error","Error updating voyage table! Bunker loss/profit not set.~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_tchire_lossprofit_bunker()")
	rollback;
	Return -1
end if

commit;
return 1
end function

public function boolean of_tcin_rate_zero (integer ai_vessel, string as_voyage, ref string as_headowner_snumber);/* This function returns if vessel is a TC-IN vessel with rate = 0

	first find first port arrival date, which shall be within a contract
	is inside a TC-IN contract or not. TC in contract = not APM CPH, NO TC in contract = APM CPH 
	
	Return TRUE if vessel is APM Copenhagen Owned  */
datetime		ldt_min_arrival
long			ll_contractID
decimal		ld_rate

/* First find min. port arrival date for voyage */
SELECT min(PORT_ARR_DT)
	INTO :ldt_min_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage;
if sqlca.sqlcode <> 0 then
	commit;
	MessageBox("Information", "No port arrival date found for this voyage. Off Service bunker will not be posted to CODA~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_apmcph_vessel()")
	Return false
end if
commit;

/* Find out if there is a TC IN Contract covering arrival date.and if the rate = 0 */
SELECT NTC_TC_CONTRACT.CONTRACT_ID, TCOWNERS.NOM_ACC_NR  
	INTO :ll_contractID, :as_headowner_snumber
	FROM NTC_TC_CONTRACT,   
		NTC_TC_PERIOD,
		TCOWNERS
	WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID 
	AND TCOWNERS.TCOWNER_NR = NTC_TC_CONTRACT.TCOWNER_NR
	AND NTC_TC_PERIOD.PERIODE_START <= :ldt_min_arrival 
	AND NTC_TC_PERIOD.PERIODE_END > :ldt_min_arrival
	AND NTC_TC_CONTRACT.VESSEL_NR = :ai_vessel
	AND NTC_TC_CONTRACT.TC_HIRE_IN = 1 ;
commit;

if ll_contractID > 0 then
	SELECT sum(RATE)  
		INTO :ld_rate
		FROM 	NTC_TC_PERIOD  
		WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID ; 
	commit;
	if ld_rate = 0 then
		return true
	else
		return false
	end if
else
	return false
end if


end function

public subroutine documentation ();/********************************************************************
  n_bunker_posting_control
	
	<OBJECT>
	
	</OBJECT>
   	<DESC>
		Calculation and posting of Bunker consumption and off-service
	</DESC>
   	<USAGE>
		
	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref   Author   	Comments
	00/00/?? 	??? 	???      	First Version
	03/05/12  	2764	JMC			Added email notification when non-apm vessel with tc-in with rate<>0
	05/11/12		2780	LHC010		Remove the Company NOM_ACC_NR in both functions 'of_tchire_buy_bunker' and 'of_tchire_sell_bunker'
	04/29/13		2921	LGX001		Use the already existing configuration from System Tables > Offices to determine the correct Finance email address.
	15/05/13		2690	LGX001		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
											2.change "@maersk.com" 			 as C#EMAIL.DOMAIN
	10/28/13		2921  LGX001		Changing the order of getting finance email address:
											1. On single, position voyage (i.e. all types with 5-digit voyage numbers, except for Idle voyage) 
											   vessel-voyage > allocated calculation > CP attached to calculation > office.
											2. on TC voyages (ie. 7-digit voyage numbers)
												vessel-voyage > connected TC-out contract (use F2 as user in application) > office.
											3.Only if the above steps fail, the email address of the Finance responsible as per Vessels system table should be used.
	01/23/14		2921UAT LGX001		Deal with the Scenario: If vessel is not APM Copenhagen owned and rate = 0,the finance email address should be same as the above										
	15/04/16		CR4316	AGL027	Obtain email address of finance responsible from database instead of using constant.

********************************************************************/
end subroutine

public subroutine of_get_office_fin_emailaddr (long al_vesselnr, string as_voyagenr, ref string as_email[]);/********************************************************************
   of_get_office_finemail_address
   <DESC> Get office finance email address</DESC>
   <RETURN>	(none):
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vesselnr
		as_voyagenr
		as_finemail_address
   </ARGS>
   <USAGE> search order: 1. On single, position voyage (i.e. all types with 5-digit voyage numbers, except for Idle voyage) 
								   vessel-voyage > allocated calculation > CP attached to calculation > office.
								 2. on TC voyages (ie. 7-digit voyage numbers)
									vessel-voyage > connected TC-out contract (use F2 as user in application) > office.
								 3.Only if the above steps fail, the email address of the Finance responsible as per Vessels system table should be used. 
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/05/2013 CR2921        LGX001        First Version
   </HISTORY>
********************************************************************/

string ls_fin_resp, ls_finemail
long ll_voyagetype, ll_calcid, ll_tcout
datetime ldt_max_arrival_datetime
mt_n_datastore lds_fin_email


SELECT VOYAGE_TYPE, CAL_CALC_ID
INTO :ll_voyagetype, :ll_calcid
FROM VOYAGES
WHERE VESSEL_NR = :al_vesselnr and VOYAGE_NR = :as_voyagenr;

if len(as_voyagenr) = 7 then ll_tcout = 1 else ll_tcout = 0 

//Get email from calculation (not idle voyage)	
if (ll_voyagetype <> 7 and ll_calcid > 1 and ll_tcout = 0 ) then 
	
	lds_fin_email = create mt_n_datastore
	lds_fin_email.dataobject = "d_sq_gr_office_finance_email"
	lds_fin_email.settransobject(sqlca)
	
	if lds_fin_email.retrieve(ll_calcid) > 0 then
		as_email = lds_fin_email.object.offices_email_adr_finance.primary
	end if
	
	destroy lds_fin_email
end if

//Get email from TC
if upperbound(as_email) <= 0 then
	
	SELECT OFFICES.EMAIL_ADR_FINANCE
	INTO :ls_finemail
	FROM NTC_TC_CONTRACT,
	     NTC_TC_PERIOD,
		  OFFICES
	WHERE	NTC_TC_CONTRACT.OFFICE_NR = OFFICES.OFFICE_NR 	
		AND NTC_TC_CONTRACT.VESSEL_NR = :al_vesselnr
		AND NTC_TC_CONTRACT.TC_HIRE_IN <> :ll_tcout
		AND NTC_TC_CONTRACT.CONTRACT_ID = NTC_TC_PERIOD.CONTRACT_ID
		AND (NTC_TC_PERIOD.PERIODE_START <= (SELECT MIN(dateadd(mi, POC1.LT_TO_UTC_DIFFERENCE * 60, POC1.PORT_ARR_DT)) FROM POC POC1 WHERE POC1.VESSEL_NR = :al_vesselnr AND POC1.VOYAGE_NR = :as_voyagenr))   
		AND (NTC_TC_PERIOD.PERIODE_END	>= (SELECT MIN(dateadd(mi, POC2.LT_TO_UTC_DIFFERENCE * 60, POC2.PORT_ARR_DT)) FROM POC POC2 WHERE POC2.VESSEL_NR = :al_vesselnr AND POC2.VOYAGE_NR = :as_voyagenr)) ;   
		
	if sqlca.sqlcode = 0 then
		if isnull(ls_finemail) then ls_finemail = ""
		if trim(ls_finemail) <> "" then as_email[upperbound(as_email) + 1] = trim(ls_finemail)
	end if
end if
// from  Vessel  finance resp 
if upperbound(as_email) <= 0 then
	/* locate the AD email address that is saved in the db using mt_n_activedirectoryfunctions */
	SELECT EMAIL into :ls_finemail FROM VESSELS,USERS where VESSEL_NR=:al_vesselnr and VESSELS.VESSEL_FIN_RESP=USERS.USERID;
	if isnull(ls_finemail) then ls_finemail = ""
	if trim(ls_finemail) <> "" then
		as_email[1] = ls_finemail
	end if
end if
end subroutine

event constructor;ids_voyage_posted = create datastore
ids_voyage_posted.dataObject = "d_sq_tb_bunker_posted_voyage"
ids_voyage_posted.setTransObject(sqlca)

end event

event destructor;destroy ids_voyage_posted

end event

on n_bunker_posting_control.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_bunker_posting_control.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

