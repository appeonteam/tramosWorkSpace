$PBExportHeader$u_check_tc.sru
$PBExportComments$Used for checking TC contract (In and Out) against POC
forward
global type u_check_tc from nonvisualobject
end type
end forward

global type u_check_tc from nonvisualobject
end type
global u_check_tc u_check_tc

forward prototypes
public function integer of_prepare_d_check_tc_poc (ref datastore ads_check_tc_poc, integer ai_vessel)
public function integer of_check_tc_poc (integer ai_vessel, string as_voyage, datetime adt_date, string as_purpose, ref decimal ad_contractid, ref string as_charter_owner_acc)
end prototypes

public function integer of_prepare_d_check_tc_poc (ref datastore ads_check_tc_poc, integer ai_vessel);
Integer li_rows, li_counter
Decimal {0} ld_contract
Datetime ldt_date

li_rows = ads_check_tc_poc.Retrieve(ai_vessel)

// if contract is UTC, then change the delivery / redelivery  date to local time taken form POC if any
FOR li_counter = 1 TO li_rows
	if ads_check_tc_poc.GetItemNumber(li_counter,"local_time") = 0 then
		ld_contract = ads_check_tc_poc.GetItemNumber(li_counter,"ntc_tc_contract_contract_id")
		/* Delivery */
		SELECT  PORT_ARR_DT
			INTO :ldt_date
			FROM POC
			WHERE CONTRACT_ID = :ld_contract
			AND PURPOSE_CODE = "DEL";
		if sqlca.sqlcode = 0 then
			ads_check_tc_poc.setItem(li_counter, "delivery", ldt_date)
		end if
		commit;
		/* Re-delivery */
		SELECT  PORT_DEPT_DT
			INTO :ldt_date
			FROM POC
			WHERE CONTRACT_ID = :ld_contract
			AND PURPOSE_CODE = "RED";
		if sqlca.sqlcode = 0 then
			ads_check_tc_poc.setItem(li_counter, "tcend", ldt_date)
		end if
		commit;
	end if
NEXT

Return li_rows
end function

public function integer of_check_tc_poc (integer ai_vessel, string as_voyage, datetime adt_date, string as_purpose, ref decimal ad_contractid, ref string as_charter_owner_acc);/* This function checks POC an arr./dept. date and purpose for a vessel/voyage in regards to TC IN/OUT contracts

Return codes:

0  = OK   : The arr/Dpt. date has no TC and the voyage is not a TC OUT
1  = OK   : The arr/Dpt. date is in a TC IN and the voyage is NOT TC OUT
2  = OK   : The arr/Dpt. date is in a TC OUT and the voyage is a TC OUT
-1 = Error: The arr/Dpt. date has no TC OUT and the voyage is a TC OUT
-2 = Error: The arr/Dpt. date is in a TC IN and the voyage is a TC OUT
-3 = Error: The arr/Dpt. date has a TC OUT but the voyageis not a TC OUT

These checks only if first check is 0,1,2
-4 = Error: No TC and this purpose is DEL or RED
-5 = Error:	There are a POC previous to this one in same contract and this purpose is DEL
-6 = Error: There are no POC previous to this one in same contract and this purpose is NOT DEL
-7 = Error: There are a POC previous to this one in same contract and previous is RED => Finish
-8 = Error: There a POC previous to this but it has no TC Contract (Can only be for old POCs)
-9 = Error: The POC is outside TC Contracts but there exists POC for same voyage inside a TC IN contract,
				or the there exists POC for same voyage before a TC IN Contract where this POC is after the
				TC IN. This is checked if code is 0 or 1. 
-10 = Error: This is a TC IN, where there exists POC on same voyage before delivery.
-11 = Error: This TC Out voyage has POCs on another Contract
				
-15 = Error: The TC Contract is NOT fixtured, so the voyage is illegal. No VAS possible etc.

-20 = Error: There are mischmatch between the IN/Out on TC Contract and the expected IN/OUT
				 in the call from w_bunker_details (update on lifted).
-99 = Error: Check failed

Leith 19/5-03
*/

Datastore lds_check_tc_poc
Integer li_rows, li_result, li_found = 0 , li_tc_in, li_voyage_type, li_pcn, li_illegal
Decimal {0} ld_prev_contract
Datetime ldt_max_arr_dt, ldt_actual_arr_dt
String ls_purpose, ls_charter_acc, ls_owner_acc, ls_port

lds_check_tc_poc = CREATE Datastore
lds_check_tc_poc.DataObject = "d_check_tc_poc"
lds_check_tc_poc.SetTransObject(SQLCA)

//f_datastore_spy(lds_check_tc_poc)

li_rows = of_prepare_d_check_tc_poc(lds_check_tc_poc,ai_vessel)

//f_datastore_spy(lds_check_tc_poc)

IF li_rows > 0 THEN 
	// Now find the TC contract where the POC arr. date fits in between, if any
	// The dw is sorted on delivery DESC, which means we will find the lattest first
	IF as_purpose = "DEL" AND NOT(as_charter_owner_acc) = "DEPT" THEN
		li_found = lds_check_tc_poc.Find("delivery = datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "')",1,li_rows)
	ELSE	
		li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') <= tcend",1,li_rows)
	END IF
	
	IF li_found > 0 THEN 
		li_tc_in = lds_check_tc_poc.GetItemNumber(li_found,"tc_hire_in")
		ad_contractid = lds_check_tc_poc.GetItemNumber(li_found,"ntc_tc_contract_contract_id")
		
		SELECT CHART.NOM_ACC_NR, TCOWNERS.NOM_ACC_NR  
			INTO :ls_charter_acc, :ls_owner_acc  
			FROM CHART, NTC_TC_CONTRACT, TCOWNERS  
			WHERE ( NTC_TC_CONTRACT.CHART_NR *= CHART.CHART_NR) and  
				( TCOWNERS.TCOWNER_NR =* NTC_TC_CONTRACT.TCOWNER_NR) and  
				( NTC_TC_CONTRACT.CONTRACT_ID = :ad_contractid  )   ;
		Commit;
		
		IF li_tc_in = 0 AND as_charter_owner_acc = "OUT" THEN
			as_charter_owner_acc = ls_charter_acc
		ELSEIF li_tc_in = 1 AND as_charter_owner_acc = "IN" THEN
			as_charter_owner_acc = ls_owner_acc
		ELSEIF as_charter_owner_acc <> "" THEN
			li_result = -20
		END IF
	END IF
END IF

// Now check if the situation is legal
SELECT VOYAGE_TYPE
	INTO :li_voyage_type
	FROM VOYAGES
	WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage;
Commit;

IF li_found = 0 THEN
	// If no fit then the voyage must not be TC OUT
	IF li_voyage_type = 2 THEN
		li_result = -1
	ELSE
		li_result = 0
	END IF
ELSEIF li_tc_in = 0 THEN // TC OUT
	// IF TC OUT then the fit must be in a TC OUT contract
	IF NOT(li_voyage_type = 2) THEN 
		li_result = -3
		IF li_found+1 <= li_rows THEN
			//***********************************************************************
			// This code is added by REM 18. august 2003 to avoid failure 
			// when you have a TC-in and TC-out contract starting at the same time
			//***********************************************************************
			IF as_purpose = "DEL" AND NOT(as_charter_owner_acc) = "DEPT" THEN
				li_found = lds_check_tc_poc.Find("delivery = datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "')",li_found+1,li_rows)
			ELSE	
				li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') <= tcend",li_found+1,li_rows)
			END IF
			
			IF li_found > 0 THEN 
				li_tc_in = lds_check_tc_poc.GetItemNumber(li_found,"tc_hire_in")
				ad_contractid = lds_check_tc_poc.GetItemNumber(li_found,"ntc_tc_contract_contract_id")
				SELECT CHART.NOM_ACC_NR, TCOWNERS.NOM_ACC_NR  
					INTO :ls_charter_acc, :ls_owner_acc  
					FROM CHART, NTC_TC_CONTRACT, TCOWNERS  
					WHERE ( NTC_TC_CONTRACT.CHART_NR *= CHART.CHART_NR) and  
						( TCOWNERS.TCOWNER_NR =* NTC_TC_CONTRACT.TCOWNER_NR) and  
						( ( NTC_TC_CONTRACT.CONTRACT_ID = :ad_contractid ) )   ;
				Commit;
				IF li_tc_in = 0 AND as_charter_owner_acc = "OUT" THEN
					as_charter_owner_acc = ls_charter_acc
				ELSEIF li_tc_in = 1 AND as_charter_owner_acc = "IN" THEN
					as_charter_owner_acc = ls_owner_acc
				ELSEIF as_charter_owner_acc <> "" THEN
					li_result = -20
				END IF
				li_result = 1
			END IF
		END IF	
		//****** END extra check ************************************************
	ELSE
		li_result = 2
	END IF	
ELSE // TC IN
	// IF TC IN then the fit must be in a TC IN contract
	IF li_voyage_type = 2 THEN 
		li_result = -2
		IF li_found+1 <= li_rows THEN
			//***********************************************************************
			// This code is added by REM 14. august 2003 to avoid failure 
			// when you have a TC-in and TC-out contract starting at the same time
			//***********************************************************************
			
			IF as_purpose = "DEL" AND NOT(as_charter_owner_acc) = "DEPT" THEN
				li_found = lds_check_tc_poc.Find("delivery = datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "')",li_found+1,li_rows)
				ELSE	
				li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(adt_date, "yyyy-mmm-dd hh:mm") + "') <= tcend",li_found+1,li_rows)
			END IF
			
			IF li_found > 0 THEN 
				li_tc_in = lds_check_tc_poc.GetItemNumber(li_found,"tc_hire_in")
				ad_contractid = lds_check_tc_poc.GetItemNumber(li_found,"ntc_tc_contract_contract_id")
				SELECT CHART.NOM_ACC_NR, TCOWNERS.NOM_ACC_NR  
					INTO :ls_charter_acc, :ls_owner_acc  
					FROM CHART, NTC_TC_CONTRACT, TCOWNERS  
					WHERE ( NTC_TC_CONTRACT.CHART_NR *= CHART.CHART_NR) and  
						( TCOWNERS.TCOWNER_NR =* NTC_TC_CONTRACT.TCOWNER_NR) and  
						( ( NTC_TC_CONTRACT.CONTRACT_ID = :ad_contractid ) )   ;
				Commit;
				IF li_tc_in = 0 AND as_charter_owner_acc = "OUT" THEN
					as_charter_owner_acc = ls_charter_acc
				ELSEIF li_tc_in = 1 AND as_charter_owner_acc = "IN" THEN
					as_charter_owner_acc = ls_owner_acc
				ELSEIF as_charter_owner_acc <> "" THEN
					li_result = -20
				END IF
				li_result = 2
			END IF
		END IF
		//****** END extra check ************************************************
	ELSE
		li_result = 1
	END IF	
END IF

IF li_result >= 0 AND as_charter_owner_acc <> "DEPT" AND as_purpose <> "" THEN
	//Check purpose if adt_date is arr. date. NOT dept.
	IF (as_purpose = "DEL" OR as_purpose = "RED") and li_result = 0 THEN
		li_result = -4
	ELSEIF li_result > 0 THEN // There is a legal TC
		// Check if the TC Contract is fixtured
		IF NOT(Len(lds_check_tc_poc.GetItemString(li_found,"fixture_user_id")) > 0) OR &
			IsNull(lds_check_tc_poc.GetItemString(li_found,"fixture_user_id")) THEN
			Destroy lds_check_tc_poc
			Return -15
		END IF
		// Get the previous POC
		IF IsValid(w_port_of_call) THEN
			// Get the original arr. dt. value for this POC 
			ls_port = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemString(1,"port_code")	
			li_pcn = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemNumber(1,"pcn")	
			SELECT Distinct PORT_ARR_DT
				INTO :ldt_actual_arr_dt
				FROM POC
				WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :as_voyage AND
						PORT_CODE = :ls_port AND PCN = :li_pcn;
			IF SQLCA.SQLCode <> 0 THEN ldt_actual_arr_dt = adt_date
			Commit;
		ELSE
			ldt_actual_arr_dt = adt_date
		END IF
		IF li_voyage_type <> 2 THEN
			SELECT MAX(PORT_ARR_DT)
				INTO :ldt_max_arr_dt
				FROM POC, VOYAGES
				WHERE POC.VESSEL_NR = :ai_vessel AND PORT_ARR_DT < :ldt_actual_arr_dt AND
						VOYAGES.VOYAGE_NR = POC.VOYAGE_NR AND VOYAGES.VESSEL_NR = POC.VESSEL_NR AND
						VOYAGES.VOYAGE_TYPE <> 2;
			Commit;
		ELSE
			SELECT MAX(PORT_ARR_DT)
				INTO :ldt_max_arr_dt
				FROM POC, VOYAGES
				WHERE POC.VESSEL_NR = :ai_vessel AND PORT_ARR_DT < :ldt_actual_arr_dt AND
						VOYAGES.VOYAGE_NR = POC.VOYAGE_NR AND VOYAGES.VESSEL_NR = POC.VESSEL_NR AND
						VOYAGES.VOYAGE_TYPE = 2;
			Commit;
		END IF
		SELECT DISTINCT PURPOSE_CODE
			INTO :ls_purpose
			FROM POC
			WHERE VESSEL_NR = :ai_vessel AND PORT_ARR_DT = :ldt_max_arr_dt;
		Commit;
		// Is there a previous POC
		IF ldt_max_arr_dt < adt_date /*OR IsNULL(ldt_max_arr_dt)*/ THEN
//			// Check which TC contract it relates to
//			li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') <= tcend",1,li_rows)
			//************************************************************************************
			// This code overwrites the code above. Added by REM 19. august 2003 to avoid failure 
			// when you have a TC-in and TC-out contract starting at the same time
			//************************************************************************************
			string ls_check_voyagetype
			if li_voyage_type = 2 then
				ls_check_voyagetype = "0"
			else
				ls_check_voyagetype = "1"
			end if
			// first check if there is a contract of same type
			li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') <= tcend and tc_hire_in = "+ls_check_voyagetype,1,li_rows)
			if li_found < 1 then
				// Check which TC contract it relates to
				li_found = lds_check_tc_poc.Find("delivery <= datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') AND datetime('" + String(ldt_max_arr_dt, "yyyy-mmm-dd hh:mm") + "') <= tcend",1,li_rows)
			end if
			//****** END extra check *************************************************************
			IF NOT(li_found > 0) THEN 
				// If no previous contract, then the previous POC is on a single voyage not on TC => 
				// So purpose must be DEL
				IF as_purpose <> "DEL" THEN
					Return -6
				END IF
			ELSE		
			ld_prev_contract = lds_check_tc_poc.GetItemNumber(li_found,"ntc_tc_contract_contract_id")
			// Check combinations
				IF ad_contractid = ld_prev_contract and as_purpose = "DEL" THEN
					li_result = -5
				ELSEIF ad_contractid <> ld_prev_contract AND as_purpose <> "DEL" THEN
					li_result = -6		
				ELSEIF ad_contractid = ld_prev_contract AND ls_purpose = "RED" THEN
					li_result = -7
				END IF
			END IF	
		ELSEIF as_purpose <> "DEL" THEN	// There are no previous POC
				li_result = -6
		END IF
	END IF
END IF
/* This is to avoid problems when vessel on TC in and there are several continues contracts */
if li_result = -6 then
	if li_found > 0 then
		if lds_check_tc_poc.getItemNumber(li_found, "same_hire") = 0 then
			li_result = 1
		end if
	end if
end if

IF li_result = 0 THEN
	// Test if there are a previous POC on same voyage belonging to a TC contract,
	// Which means that this POC must be inside that contract, which it is not.
	// Or if there are a TC IN Contract between this POC and a previous POC on same voyage. 
	SELECT COUNT(NTC_TC_CONTRACT.CONTRACT_ID)  
		INTO :li_illegal
		FROM NTC_TC_PERIOD, POC, NTC_TC_CONTRACT  
		WHERE ( NTC_TC_CONTRACT.CONTRACT_ID = NTC_TC_PERIOD.CONTRACT_ID ) and  
				( NTC_TC_CONTRACT.VESSEL_NR = POC.VESSEL_NR ) and  
				((NTC_TC_PERIOD.PERIODE_START <= POC.PORT_ARR_DT AND  
				NTC_TC_PERIOD.PERIODE_END >= POC.PORT_ARR_DT) OR  
				(NTC_TC_PERIOD.PERIODE_START <= POC.PORT_DEPT_DT AND  
				NTC_TC_PERIOD.PERIODE_END >= POC.PORT_DEPT_DT) OR
				(POC.PORT_ARR_DT < NTC_TC_PERIOD.PERIODE_START)) AND  
				POC.PORT_ARR_DT < :ldt_actual_arr_dt AND  
				POC.VESSEL_NR = :ai_vessel AND  
				SUBSTRING(POC.VOYAGE_NR,1,5) = SUBSTRING(:as_voyage,1,5)   ;
	Commit;
	IF li_illegal > 0 THEN
		li_result = -9
	END IF
END IF	
	
Destroy lds_check_tc_poc;

Return li_result
end function

on u_check_tc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_check_tc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

