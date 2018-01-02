$PBExportHeader$n_bunker_purchase.sru
$PBExportComments$This Object holds all functions related to bunker purchase. Insert, modify and delete (no bunker consumption calculations)
forward
global type n_bunker_purchase from nonvisualobject
end type
end forward

global type n_bunker_purchase from nonvisualobject
end type
global n_bunker_purchase n_bunker_purchase

type variables
n_ds		ids_bunker
integer	ii_vessel, ii_pcn
string		is_voyage, is_port, is_purpose
long		il_contractID
boolean	ib_singleVoyage



end variables

forward prototypes
public function integer of_validate ()
public function integer of_createdatastores ()
public subroutine of_destroydatastores ()
public function integer of_sharedatastores (ref datawindow adw_bp_details)
public function integer of_new_order ()
public function integer of_delete_order (long al_row)
public function integer of_update ()
public function integer of_retrieve (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn)
private function integer of_connect_to_tchire ()
public function integer of_checkdeliverybunkermodified (ref long al_affected_paymentid[])
public subroutine documentation ()
end prototypes

public function integer of_validate ();long 			ll_rows, ll_row
boolean		lb_bunker_modified
string			ls_tc_currency
decimal{4}	ld_hfo, ld_do, ld_go, ld_lshfo
decimal{4}	ld_lifted_hfo=0, ld_lifted_do=0, ld_lifted_go=0, ld_lifted_lshfo=0, ld_temp=0
decimal{4}	ld_temp_lifted_hfo=0, ld_temp_lifted_do=0, ld_temp_lifted_go=0, ld_temp_lifted_lshfo=0
decimal{4}	ld_arrival_hfo, ld_arrival_do, ld_arrival_go, ld_arrival_lshfo
string			ls_temp_voyage, ls_temp_portcode, ls_temp_purpose
datetime		ldt_arrival
integer		li_temp_pcn

ids_bunker.Accepttext()

ll_rows = ids_bunker.RowCount()

/* Get voyage type for later validation */
SELECT CASE VOYAGE_TYPE WHEN 2 THEN 0 ELSE 1 END
	INTO :ib_singleVoyage
	FROM VOYAGES
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage;
if sqlca.sqlcode = -1 then
	MessageBox("Validation Error","Not able to select from VOYAGES table~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
	Return -1
end if
	
/* To be 100% sure that the purpose and contract_id are correct, and to check
	if there is a POC, then retrieve them here */
SELECT PURPOSE_CODE, CONTRACT_ID
	INTO :is_purpose, :il_contractid
	FROM POC
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage
	AND PORT_CODE = :is_port
	AND PCN = :ii_pcn;
if sqlca.sqlcode = 100 then
	setNull(is_purpose)
	setNull(il_contractid)
elseif sqlca.sqlcode = -1 then
	MessageBox("Validation Error","Not able to select from POC table~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
	Return -1
end if

/* Nothing to validate, but there could have been deleted an order, why update must be done */
IF ll_rows < 1 THEN 
	/* Before returning check that departure bunker is not higher than arrival */
	SELECT (ISNULL(ARR_HFO,0) - ISNULL(DEPT_HFO,0)),
		(ISNULL(ARR_DO,0) - ISNULL(DEPT_DO,0)),
		(ISNULL(ARR_GO,0) - ISNULL(DEPT_GO,0)),
		(ISNULL(ARR_LSHFO,0) - ISNULL(DEPT_LSHFO,0))
	INTO :ld_hfo, :ld_do, :ld_go, :ld_lshfo
	FROM POC
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage
	AND PORT_CODE = :is_port
	AND PCN = :ii_pcn;
	if sqlca.sqlcode = 100 then
		SELECT (ISNULL(ARR_HFO,0) - ISNULL(DEPT_HFO,0)),
		(ISNULL(ARR_DO,0) - ISNULL(DEPT_DO,0)),
		(ISNULL(ARR_GO,0) - ISNULL(DEPT_GO,0)),
		(ISNULL(ARR_LSHFO,0) - ISNULL(DEPT_LSHFO,0))
		INTO :ld_hfo, :ld_do, :ld_go, :ld_lshfo
		FROM POC_EST
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		AND PORT_CODE = :is_port
		AND PCN = :ii_pcn;
		if sqlca.sqlcode = 100 then
			return 1
		elseif sqlca.sqlcode = -1 then
			MessageBox("Validation Error","Not able to select from Estimated POC table~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			Return -1
		end if
	elseif sqlca.sqlcode = -1 then
		MessageBox("Validation Error","Not able to select from POC table~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
		Return -1
	end if
	if ld_hfo < 0 or ld_do < 0 or ld_go < 0 or ld_lshfo < 0 then
		MessageBox("Validation Error","You can't departure from a Port with~r~n" &
						+ "more bunker than at arrival, without loading anything.~r~n~r~n" &
						+ "Please correct values in Port of Call before deleting this row~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")			
		Return -1
	end if

	Return 1
end if

/* Start real validation when there are rows to validate */
/* Check exchange rate against TC Contract */
choose case is_purpose
	case "DEL", "RED"
		if not isnull(il_contractid) then			
			SELECT NTC_TC_CONTRACT.CURR_CODE  
				INTO :ls_tc_currency  
				FROM NTC_TC_CONTRACT  
				WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contractID;
		else
			ls_tc_currency = "USD"
		end if
end choose

/* Run through all rows */
FOR ll_row= 1 TO ll_rows
	/* Check exchange rate against TC Contract */
	choose case is_purpose
		case "DEL", "RED"
			if ids_bunker.getItemNumber(ll_row, "bp_details_ex_rate_to_tc") = 100 & 
			AND ls_tc_currency <> "USD" AND il_contractid > 0 THEN
				IF MessageBox("Warning","Row " + String(ll_row) + ": Bunker Currency is USD and TC Currency is : " + ls_tc_currency + &
					"and you have entered 100 as ex. rate. Is this correct ?", Question!,YesNo!,2) = 2 THEN
					Return -1
				END IF		
			END IF	
	end choose
	
	/* First check required fields regardless of scenario */
	if isNull(ids_bunker.getItemString(ll_row, "supplier")) or len(ids_bunker.getItemString(ll_row, "supplier"))< 2 then
		Messagebox("Validation Error", "Please enter a Supplier in row #"+string(ll_row)+" before saving order~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if isNull(ids_bunker.getItemdatetime(ll_row, "confirmation_date")) then
		Messagebox("Validation Error", "Please enter a Confirmation Date in row #"+string(ll_row)+" before saving order~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if isNull(ids_bunker.getItemNumber(ll_row, "bp_details_ex_rate_to_tc")) or ids_bunker.getItemNumber(ll_row, "bp_details_ex_rate_to_tc")= 0 then
		Messagebox("Validation Error", "Please enter an Exchange rate  in row #"+string(ll_row)+" before saving order~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if isNull(ids_bunker.GetItemNumber(ll_row,"fifo_sequence"))  then
		MessageBox("Validation Error","Please enter a FIFO sequence number in row #"+string(ll_row)+" before saving order~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		Return -1
	end if		
	
	/* Next if no POC (is_purpose = NULL) there must not be registred lifted bunker */
	if isNull(is_purpose) then
		if  ids_bunker.getItemStatus( ll_row, "lifted_hfo", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_do", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_go", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_lshfo", primary!) = dataModified! then
			Messagebox("Validation Error", "You are not allowed to enter Lifted Quantity in row #"+string(ll_row)+" until an Actual Port of Call is registered.~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
	end if		
	
	/* When an order is entered there must at least be entered one ordered quantity or one
		lifted quantity */
	if (ids_bunker.getItemStatus( ll_row, 0, primary!) = newModified! &
		or ids_bunker.getItemStatus( ll_row, 0, primary!) = new! ) &
	and ids_bunker.getItemStatus( ll_row, "lifted_hfo", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "ordered_hfo", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "lifted_do", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "ordered_do", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "lifted_go", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "ordered_go", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "lifted_lshfo", primary!) = notModified! &
	and ids_bunker.getItemStatus( ll_row, "ordered_lshfo", primary!) = notModified!  then
		Messagebox("Validation Error", "Please enter an Ordered or Lifted Quantity in row #"+string(ll_row)+" before saving order~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	
	/* First check if any fields that can trigger a CODA transaction are modified */	
	if NOT isNull(is_purpose) then
		if ids_bunker.getItemStatus( ll_row, "price_hfo", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "price_do", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "price_go", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "price_lshfo", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_hfo", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_do", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_go", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "lifted_lshfo", primary!) = dataModified! &
		or ids_bunker.getItemStatus( ll_row, "fifo_sequence", primary!) = dataModified! then
			lb_bunker_modified=true
		end if
	end if
	
	choose case is_purpose
		case "DEL"
			if ib_singlevoyage then  // TC-IN Delivery
				if ids_bunker.GetItemDecimal(ll_row, "buy_sell") = 1 then
					Messagebox("Validation Error", "You are not allowed to Sell bunker on TC-IN Delivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
				if ids_bunker.GetItemDecimal(ll_row, "owner_pool_purchase_or_chart") = 2 then
					Messagebox("Validation Error", "You are not allowed to Buy from Charterer on TC-IN Delivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
			else	// TC-OUT Delivery
				if ids_bunker.GetItemDecimal(ll_row, "buy_sell") = 0 then
					Messagebox("Validation Error", "You are not allowed to Buy bunker on TC-OUT Delivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
				if ids_bunker.GetItemDecimal(ll_row, "owner_pool_purchase_or_chart") <> 2 then
					Messagebox("Validation Error", "You are only allowed to Sell to Charterer on TC-OUT Delivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
			end if	
		case "RED"
			if ib_singlevoyage then  // TC-IN Redelivery
				if ids_bunker.GetItemDecimal(ll_row, "buy_sell") = 0 then
					Messagebox("Validation Error", "You are not allowed to Buy bunker on TC-IN Redelivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
				if ids_bunker.GetItemDecimal(ll_row, "owner_pool_purchase_or_chart") <> 0 then
					Messagebox("Validation Error", "You are only allowed to Sell to Owner on TC-IN Redelivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
			else	// TC-OUT Redelivery
				if ids_bunker.GetItemDecimal(ll_row, "buy_sell") = 1 then
					Messagebox("Validation Error", "You are not allowed to Sell bunker on TC-OUT Redelivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
				if ids_bunker.GetItemDecimal(ll_row, "owner_pool_purchase_or_chart") = 0 then
					Messagebox("Validation Error", "You are not allowed to Buy from Owner on TC-OUT Redelivery port~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_validate())")
					return -1
				end if
			end if	
	end choose

	/* Validate that buy/sell and lifted ordered sign is correct */
	IF ids_bunker.GetItemDecimal(ll_row,"buy_sell") = 0 THEN
		// Check that at least one bunker type has data
		IF NOT(ids_bunker.GetItemDecimal(ll_row,"price_hfo") * ids_bunker.GetItemDecimal(ll_row,"ordered_hfo") > 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_do") * ids_bunker.GetItemDecimal(ll_row,"ordered_do") > 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_go") * ids_bunker.GetItemDecimal(ll_row,"ordered_go") > 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_lshfo") * ids_bunker.GetItemDecimal(ll_row,"ordered_lshfo") > 0) THEN
			Messagebox("Validation Error", "Data for at least one of the fuel types must be entered !~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		END IF
		IF ids_bunker.GetItemDecimal(ll_row,"lifted_hfo") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_do") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_go") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_lshfo") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_hfo") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_do") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_go") < 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_lshfo") < 0  THEN
			Messagebox("Validation Error", "Data for ordered and lifted must be >= 0 for Buy ~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		END IF
	ELSE // SELL
		IF NOT(ids_bunker.GetItemDecimal(ll_row,"price_hfo") * ids_bunker.GetItemDecimal(ll_row,"ordered_hfo") < 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_do") * ids_bunker.GetItemDecimal(ll_row,"ordered_do") < 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_go") * ids_bunker.GetItemDecimal(ll_row,"ordered_go") < 0) AND &
			NOT(ids_bunker.GetItemDecimal(ll_row,"price_lshfo") * ids_bunker.GetItemDecimal(ll_row,"ordered_lshfo") < 0) THEN
			Messagebox("Validation Error", "Data for at least one of the fuel types must be entered !~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		END IF
		IF ids_bunker.GetItemDecimal(ll_row,"lifted_hfo") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_do") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_go") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"lifted_lshfo") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_hfo") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_do") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_go") > 0 OR &
			ids_bunker.GetItemDecimal(ll_row,"ordered_lshfo") > 0  THEN
			Messagebox("Validation Error", "Data for ordered and lifted must be <= 0 for Sell !~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		END IF
	END IF
NEXT

/* Validate FIFO sequence */
for ll_row = 1 to ll_rows
	if ids_bunker.find("fifo_sequence="+string(ll_row), 1, ll_rows) < 1 then
		Messagebox("Validation Error", "FIFO sequence not correct. No record with number "+string(ll_row)+". Please correct!~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
next

/* If Sell bunker, check that there are not sold more bunker than on board */
if (ib_singlevoyage and is_purpose = "RED") or (ib_singlevoyage = false and is_purpose = "DEL") then
	SELECT ARR_HFO, ARR_DO, ARR_GO, ARR_LSHFO
		INTO :ld_arrival_hfo, :ld_arrival_do, :ld_arrival_go, :ld_arrival_lshfo
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		AND PORT_CODE = :is_port
		AND PCN = :ii_pcn;

	if isNull(ld_arrival_hfo) then ld_arrival_hfo = 0
	if isNull(ld_arrival_do) then ld_arrival_do = 0
	if isNull(ld_arrival_go) then ld_arrival_go = 0
	if isNull(ld_arrival_lshfo) then ld_arrival_lshfo = 0
	/* get lifted quantities */
	for ll_row = 1 to ll_rows
		ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_hfo")
		if not isNull(ld_temp) then ld_arrival_hfo += ld_temp
		ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_do")
		if not isNull(ld_temp) then ld_arrival_do += ld_temp
		ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_go")
		if not isNull(ld_temp) then ld_arrival_go += ld_temp
		ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_lshfo")
		if not isNull(ld_temp) then ld_arrival_lshfo += ld_temp
	next		
	/* check */
	if ld_lifted_hfo <> ld_arrival_hfo then
		Messagebox("Validation Error", "You have to sell exactly the HSFO quantity that is on board at arrival. Please correct!~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if ld_lifted_do <> ld_arrival_do then
		Messagebox("Validation Error", "You have to sell exactly the LSGO quantity that is on board at arrival. Please correct!~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if ld_lifted_go <> ld_arrival_go then
		Messagebox("Validation Error", "You have to sell exactly the HSGO quantity that is on board at arrival. Please correct!~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
	if ld_lifted_lshfo <> ld_arrival_lshfo then
		Messagebox("Validation Error", "You have to sell exactly the LSFO quantity that is on board at arrival. Please correct!~r~n~r~n" &
					+ "(Object: n_bunker_purchase.of_validate())")
		return -1
	end if
end if

/* If BUY bunker on TC-OUT Redelivery, check then  if next port is TC-OUT Delivery. 
	I so this BUY and next SELL must be equal */
if (ib_singlevoyage = false and is_purpose = "RED") then
	SELECT PORT_ARR_DT
		INTO :ldt_arrival
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		AND PORT_CODE = :is_port
		AND PCN = :ii_pcn;
		
	SELECT TOP 1 VOYAGE_NR, PORT_CODE, PCN, PURPOSE_CODE 
		INTO :ls_temp_voyage, :ls_temp_portcode, :li_temp_pcn, :ls_temp_purpose
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR > :is_voyage
		AND PORT_ARR_DT > :ldt_arrival
		ORDER BY PORT_ARR_DT ASC;

	if ls_temp_purpose = "DEL" then
		ld_temp_lifted_hfo=0; ld_temp_lifted_do=0; ld_temp_lifted_go=0; ld_temp_lifted_lshfo=0
		SELECT SUM(LIFTED_HFO), SUM(LIFTED_DO), SUM(LIFTED_GO), SUM(LIFTED_LSHFO)
			INTO :ld_temp_lifted_hfo, :ld_temp_lifted_do, :ld_temp_lifted_go, :ld_temp_lifted_lshfo
			FROM BP_DETAILS
			WHERE VESSEL_NR = :ii_vessel
			AND VOYAGE_NR = :ls_temp_voyage
			AND PORT_CODE = :ls_temp_portcode
			AND PCN = :li_temp_pcn;
	
		if isNull(ld_temp_lifted_hfo) then ld_temp_lifted_hfo=0
		if isNull(ld_temp_lifted_do) then ld_temp_lifted_do=0
		if isNull(ld_temp_lifted_go) then ld_temp_lifted_go=0
		if isNull(ld_temp_lifted_lshfo) then ld_temp_lifted_lshfo=0
		if ld_temp_lifted_hfo = 0 and ld_temp_lifted_do = 0 &
		and ld_temp_lifted_go = 0 and ld_temp_lifted_lshfo = 0 then
			// nothing lifted on next port
			return 1
		end if
		/* get lifted quantities */
		ld_lifted_hfo=0; ld_lifted_do=0; ld_lifted_go=0; ld_lifted_lshfo=0
		for ll_row = 1 to ll_rows
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_hfo")
			if not isNull(ld_temp) then ld_lifted_hfo += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_do")
			if not isNull(ld_temp) then ld_lifted_do += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_go")
			if not isNull(ld_temp) then ld_lifted_go += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_lshfo")
			if not isNull(ld_temp) then ld_lifted_lshfo += ld_temp
		next		
		/* check */
		if abs(ld_lifted_hfo) <> abs(ld_temp_lifted_hfo) then
			Messagebox("Validation Error", "Next Delivery port has already sold the HSFO bunker. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct next delivery port first!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_do) <> abs(ld_temp_lifted_do) then
			Messagebox("Validation Error", "Next Delivery port has already sold the LSGO bunker. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct next delivery port first!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_go) <> abs(ld_temp_lifted_go) then
			Messagebox("Validation Error", "Next Delivery port has already sold the HSGO bunker. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct next delivery port first!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_lshfo) <> abs(ld_temp_lifted_lshfo) then
			Messagebox("Validation Error", "Next Delivery port has already sold the LSFO bunker. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct next delivery port first!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if


	end if
end if

/* If SELL bunker on TC-OUT Delivery, check then  if previous port is TC-OUT ReDelivery. 
	I so this SELL and previous BUY must be equal */
if (ib_singlevoyage = false and is_purpose = "DEL") then
	SELECT PORT_ARR_DT
		INTO :ldt_arrival
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		AND PORT_CODE = :is_port
		AND PCN = :ii_pcn;
	
	ls_temp_voyage = LEFT(is_voyage,5)
	SELECT TOP 1 POC.VOYAGE_NR, POC.PORT_CODE, POC.PCN, POC.PURPOSE_CODE 
		INTO :ls_temp_voyage, :ls_temp_portcode, :li_temp_pcn, :ls_temp_purpose
		FROM POC, VOYAGES
		WHERE POC.VOYAGE_NR = VOYAGES.VOYAGE_NR
		AND POC.VESSEL_NR = :ii_vessel
		AND SUBSTRING(POC.VOYAGE_NR,1,5) < :ls_temp_voyage
		ORDER BY POC.PORT_ARR_DT DESC,
			CASE VOYAGES.VOYAGE_TYPE WHEN 2 THEN 2 ELSE 1 END,
			SUBSTRING(POC.VOYAGE_NR,1,5) DESC;
	
	if ls_temp_purpose = "RED" then
		ld_temp_lifted_hfo=0; ld_temp_lifted_do=0; ld_temp_lifted_go=0; ld_temp_lifted_lshfo=0
		SELECT SUM(LIFTED_HFO), SUM(LIFTED_DO), SUM(LIFTED_GO), SUM(LIFTED_LSHFO)
			INTO :ld_temp_lifted_hfo, :ld_temp_lifted_do, :ld_temp_lifted_go, :ld_temp_lifted_lshfo
			FROM BP_DETAILS
			WHERE VESSEL_NR = :ii_vessel
			AND VOYAGE_NR = :ls_temp_voyage
			AND PORT_CODE = :ls_temp_portcode
			AND PCN = :li_temp_pcn;
		
		if isNull(ld_temp_lifted_hfo) then ld_temp_lifted_hfo=0
		if isNull(ld_temp_lifted_do) then ld_temp_lifted_do=0
		if isNull(ld_temp_lifted_go) then ld_temp_lifted_go=0
		if isNull(ld_temp_lifted_lshfo) then ld_temp_lifted_lshfo=0
		if ld_temp_lifted_hfo = 0 and ld_temp_lifted_do = 0 &
		and ld_temp_lifted_go = 0 and ld_temp_lifted_lshfo = 0 then
			// nothing lifted on next port
			return 1
		end if
		/* get lifted quantities */
		ld_lifted_hfo=0; ld_lifted_do=0; ld_lifted_go=0; ld_lifted_lshfo=0
		for ll_row = 1 to ll_rows
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_hfo")
			if not isNull(ld_temp) then ld_lifted_hfo += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_do")
			if not isNull(ld_temp) then ld_lifted_do += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_go")
			if not isNull(ld_temp) then ld_lifted_go += ld_temp
			ld_temp = ids_bunker.GetItemDecimal(ll_row,"lifted_lshfo")
			if not isNull(ld_temp) then ld_lifted_lshfo += ld_temp
		next		
		/* check */
		if abs(ld_lifted_hfo) <> abs(ld_temp_lifted_hfo) then
			Messagebox("Validation Error", "Previous Redelivery port has bought HSFO bunker not equal to what you try to sell. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct previous Redelivery port!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_do) <> abs(ld_temp_lifted_do) then
			Messagebox("Validation Error", "Previous Redelivery port has bought LSGO bunker not equal to what you try to sell. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct previous Redelivery port!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_go) <> abs(ld_temp_lifted_go) then
			Messagebox("Validation Error", "Previous Redelivery port has bought HSGO bunker not equal to what you try to sell. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct previous Redelivery port!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
		if abs(ld_lifted_lshfo) <> abs(ld_temp_lifted_lshfo) then
			Messagebox("Validation Error", "Previous Redelivery port has bought LSFO bunker not equal to what you try to sell. As you in this scenario" &
						+" have to buy/sell exactly the same quantity, please correct previous Redelivery port!~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
			return -1
		end if
	end if
end if

/* Everything OK return */
return 1

end function

public function integer of_createdatastores ();long ll_rc

ids_bunker = create n_ds
ids_bunker.dataObject = "d_bp_detail"

ll_rc = ids_bunker.setTransObject(sqlca)
if ll_rc = -1 then
	MessageBox("Set transaction Error", "An error occured when trying to perform setTransObject. (n_bunker_purchase.of_createDatastores()")
	return -1
end if
	
return 1





end function

public subroutine of_destroydatastores ();destroy ids_bunker

end subroutine

public function integer of_sharedatastores (ref datawindow adw_bp_details);long ll_rc

ll_rc = ids_bunker.sharedata( adw_bp_details )

if ll_rc = -1 then
	MessageBox("Data Share Error", "An error occured when trying to share bunker purchase data. (n_bunker_purchase.of_shareDatastores()")
end if
	
return ll_rc

end function

public function integer of_new_order ();long ll_row
boolean	lb_finished

/* First check if voyage finished */
SELECT VOYAGE_FINISHED
	INTO :lb_finished
	FROM VOYAGES
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage;
COMMIT;
if lb_finished then
	MessageBox("Information", "This voyage is finished, and you are not allowed to create new order. ")
	return -1
end if

ll_row = ids_bunker.InsertRow(0)

/* if first row, get purpose code as it controls when lifted can be entered */
if ll_row = 1 then
	SELECT PURPOSE_CODE
		INTO :is_purpose
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		AND PORT_CODE = :is_port
		AND PCN = :ii_pcn;
	if sqlca.sqlcode = 100 then
		setNull(is_purpose)
	elseif sqlca.sqlcode = -1 then
		MessageBox("Validation Error","Not able to select from POC table~r~n~r~n" &
						+ "(Object: n_bunker_purchase.of_validate())")
		rollback;
		Return -1
	end if
end if
COMMIT;

/* set new bunker purchase rows vessel_nr, voyage_nr,
port_code and port call number fields */
ids_bunker.SetItem(ll_row,"vessel_nr",ii_vessel)
ids_bunker.SetItem(ll_row,"voyage_nr",is_voyage)
ids_bunker.SetItem(ll_row,"port_code",is_port)
ids_bunker.SetItem(ll_row,"pcn",ii_pcn)
ids_bunker.SetItem(ll_row,"buy_sell",0)
ids_bunker.SetItem(ll_row,"owner_pool_purchase_or_chart",1)
ids_bunker.SetItem(ll_row,"bp_details_ex_rate_to_tc",100)
ids_bunker.SetItem(ll_row,"supplier","")
ids_bunker.setItem(ll_row, "fifo_sequence", ll_row)
ids_bunker.setItem(ll_row, "purpose_code", is_purpose)

ids_bunker.setColumn("supplier")
return ll_row



end function

public function integer of_delete_order (long al_row);long 		ll_rc, ll_paymentID, ll_status
boolean	lb_finished


/* First check if voyage finished */
SELECT VOYAGE_FINISHED
	INTO :lb_finished
	FROM VOYAGES
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage;
COMMIT;
if lb_finished then
	MessageBox("Information", "This voyage is finished, and you are not allowed to delete an order. ")
	return -1
end if

if al_row < 1 then 
	MessageBox("Selection Error", "Please select a row before trying to delete. (n_bunker_purchase.of_delete_order()")
	return 1
end if
 
ll_paymentID = ids_bunker.getItemNumber(al_row, "payment_id")
if not isnull(ll_paymentID) then
	SELECT PAYMENT_STATUS 
		INTO :ll_status
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID = :ll_paymentID ;
	COMMIT;
	if ll_status > 2 then
		MessageBox("Information", "This order is linked to a TC payment that is settled, and can't be deleted. (n_bunker_purchase.of_delete_order()")
		return -1
	end if
end if

IF MessageBox("Confirm Delete", "Are you sure you want to delete the the order in row # "+ String(al_row)+"?",Exclamation!, YesNo!, 2) = 1 THEN
	ll_rc = ids_bunker.deleterow(al_row)
	if ll_rc = -1 then
		MessageBox("Delete Error", "An error occured when trying delete an order. (n_bunker_purchase.of_delete_order()")
	end if
end if

if of_update() = -1 then
	MessageBox("Update Error", "Update function failed when trying to delete order. (n_bunker_purchase.of_delete_order()")
	return -1
end if

return 1
end function

public function integer of_update ();n_bunker_posting_control	lnv_bunkerControl
string			ls_begin_trans="begin transaction"
string	 		ls_rollback_trans="rollback transaction"
string 		ls_commit_trans="commit transaction"
long			ll_rows, ll_row, ll_paymentID
string			ls_mySQL
long			ll_affected_paymentid[]

if of_validate( ) = -1 then return -1

/* Start transaction control */
execute immediate :ls_begin_trans;

/* This check must always be executed before of_checkdeliverybunkermodified() */
if of_connect_to_tchire( ) = -1 then 
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if

/* This check must always be executed after of_connect_to_tchire() */
if of_checkDeliveryBunkerModified( ll_affected_paymentid ) = -1 then 		
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if

if ids_bunker.update(true, false) <> 1 then
	MessageBox("Update Failed", "The system was unable to save bunker information!~r~n~r~n" &
		+ "Object: n_bunker_purchase, function: of_update()")
	rollback;
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if
commit;

UPDATE POC
	SET POC.LIFT_HFO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_HFO),0) 
						FROM BP_DETAILS 
						WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
						AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
						AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
						AND POC.PCN = BP_DETAILS.PCN) ,
	POC.LIFT_DO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_DO),0)
						FROM BP_DETAILS 
						WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
						AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
						AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
						AND POC.PCN = BP_DETAILS.PCN) ,
	POC.LIFT_GO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_GO),0)
						FROM BP_DETAILS 
						WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
						AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
						AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
						AND POC.PCN = BP_DETAILS.PCN) ,
	POC.LIFT_LSHFO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_LSHFO),0)
						FROM BP_DETAILS 
						WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
						AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
						AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
						AND POC.PCN = BP_DETAILS.PCN) 
	WHERE POC.VESSEL_NR = :ii_vessel
	AND POC.VOYAGE_NR = :is_voyage
	AND POC.PORT_CODE = :is_port
	AND POC.PCN = :ii_pcn;
if sqlca.sqlcode = -1 then
	MessageBox("Update Failed", "The system was unable to save lifted bunker to POC table!~r~n~r~n" &
		+ "Object: n_bunker_purchase, function: of_update()")
	rollback;	
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if
commit;

/* If Redelivery from TC-out the bought bunker quantity MUST be the same as Port departure */
if ib_singlevoyage = false and is_purpose = "RED" then
	UPDATE POC
		SET POC.DEPT_HFO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_HFO),0) 
							FROM BP_DETAILS 
							WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
							AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
							AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
							AND POC.PCN = BP_DETAILS.PCN) ,
		POC.DEPT_DO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_DO),0)
							FROM BP_DETAILS 
							WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
							AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
							AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
							AND POC.PCN = BP_DETAILS.PCN) ,
		POC.DEPT_GO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_GO),0)
							FROM BP_DETAILS 
							WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
							AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
							AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
							AND POC.PCN = BP_DETAILS.PCN) ,
		POC.DEPT_LSHFO = (SELECT ISNULL(SUM(BP_DETAILS.LIFTED_LSHFO),0)
							FROM BP_DETAILS 
							WHERE POC.VESSEL_NR = BP_DETAILS.VESSEL_NR
							AND POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR
							AND POC.PORT_CODE = BP_DETAILS.PORT_CODE
							AND POC.PCN = BP_DETAILS.PCN) 
		WHERE POC.VESSEL_NR = :ii_vessel
		AND POC.VOYAGE_NR = :is_voyage
		AND POC.PORT_CODE = :is_port
		AND POC.PCN = :ii_pcn;
	if sqlca.sqlcode = -1 then
		MessageBox("Update Failed", "The system was unable to save departure bunker to POC table!~r~n~r~n" &
			+ "Object: n_bunker_purchase, function: of_update()")
		rollback;	
		execute immediate :ls_rollback_trans;
		rollback;
		return -1
	end if
	commit;
end if

/* Update TC Payments - Primary Buffer */
ll_rows = ids_bunker.rowCount()
for ll_row = 1 to ll_rows
	if ( is_purpose = "DEL" or is_purpose = "RED") &
	and (ids_bunker.getItemStatus( ll_row, "price_hfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "price_do", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "price_go", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "price_lshfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "lifted_hfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "lifted_do", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "lifted_go", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "lifted_lshfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus( ll_row, "fifo_sequence", primary!) = dataModified!) then
		ll_paymentID = ids_bunker.getItemNumber(ll_row, "payment_id", primary!, false)
		if not isnull(ll_paymentID) then
			/* Bunker modified, update TC-payment balance */
			ls_mySQL = "sp_paymentBalance " + string(ll_paymentID)
			EXECUTE IMMEDIATE :ls_mySQL;
			if sqlca.sqlcode <> 0 then
				MessageBox("SP Execute Error","System failed when trying to update TC Hire Payment Balance~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_connect_to_tchire())")
				rollback;
				return -1
			end if	
			commit;
		end if
	end if
next

/* Update TC Payments - Deleted Buffer */
ll_rows = ids_bunker.deletedcount()
for ll_row = 1 to ll_rows
	if is_purpose = "DEL" or is_purpose = "RED" then
		ll_paymentID = ids_bunker.getItemNumber(ll_row, "payment_id", delete!, false)
		if not isnull(ll_paymentID) then
			/* Bunker modified, update TC-payment balance */
			ls_mySQL = "sp_paymentBalance " + string(ll_paymentID)
			EXECUTE IMMEDIATE :ls_mySQL;
			if sqlca.sqlcode <> 0 then
				MessageBox("SP Execute Error","System failed when trying to update TC Hire Payment Balance~r~n~r~n" &
								+ "(Object: n_bunker_purchase.of_connect_to_tchire())")
				rollback;
				return -1
			end if	
			commit;
		end if
	end if
next

/* End update transaction and start new one  to generate all transactions */
execute immediate :ls_commit_trans;
commit;
execute immediate :ls_begin_trans;

lnv_bunkerControl = create n_bunker_posting_control	
if lnv_bunkerControl.of_bunkerpurchase_modified( ii_vessel, is_voyage, is_port, ii_pcn, is_purpose, ids_bunker ) = -1 then
	destroy lnv_bunkerControl
	execute immediate :ls_rollback_trans;
	rollback;
	return -1
end if

/* if everything went OK commit transaction	*/
execute immediate :ls_commit_trans;
commit;

ids_bunker.resetUpdate( )

/* update affected payment ids*/
for ll_row = 1 to upperbound(ll_affected_paymentid)
	ls_mySQL = "sp_paymentBalance " + string(ll_affected_paymentid[ll_row] )
	EXECUTE IMMEDIATE :ls_mySQL;
	commit;
next

/* update TC payment window */
if isValid(w_tc_payments) then
	w_tc_payments.postevent("ue_refresh")
end if

return 1
end function

public function integer of_retrieve (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn);long ll_rows

ii_vessel 					= ai_vessel
is_voyage 				= as_voyage
is_port 					= as_portcode
ii_pcn 					= ai_pcn

ll_rows = ids_bunker.retrieve(ai_vessel, as_voyage, as_portcode,ai_pcn)
commit;
if ll_rows = -1 then
	MessageBox("Retrieve Error", "An error occured when trying to retrieve bunker purchase data. (n_bunker_purchase.of_retrieve()")
end if
	
return ll_rows
end function

private function integer of_connect_to_tchire ();/* This function checkes if the bunker buy/sell transactions shall be 
	connected to a payment in TC Hire module
	
	First check if there are any connections to do .......
*/
long 				ll_rows, ll_row, ll_paymentID, ll_null; setNull(ll_null)
n_tc_payment	lnv_tc_payment
string				ls_mySQL
boolean			lb_newOrder

/*	if no contract id POC is not connected to a TC Contract */
if isNull(il_contractid) or il_contractid < 1 then return 1

/* 	if purpose is not Delivery or Redelivery, then this is not a Bunker
	purchase that can be connected to a payment */
if is_purpose <> "DEL" and is_purpose <> "RED" then return 1

/* seems to be OK, and link can be done */
/* first get which payment id to connect to */
lnv_tc_payment = create n_tc_payment
if is_purpose = "RED" then
	ll_paymentID = lnv_tc_payment.of_getLastUnpaid( il_contractid )
else
	ll_paymentID = lnv_tc_payment.of_getFirstUnpaid( il_contractid )
end if
 destroy lnv_tc_payment
 
/* Run through all rows */
ll_rows = ids_bunker.rowCount()
for ll_row = 1 to ll_rows
	if isNull(ids_bunker.getItemNumber(ll_row, "bpn")) then
		lb_newOrder = true
	else
		lb_newOrder = false
	end if
	
	/* Ignore changes to payment ID if not new order and delivery
		will be handeled by delivery bunker modified */
	choose case is_purpose
		case "DEL"
			if ib_singlevoyage then //TC-IN Delivery
				if ids_bunker.getItemNumber(ll_row, "buy_sell") = 0 &
				and ids_bunker.getItemNumber(ll_row, "owner_pool_purchase_or_chart")=0 then
					if lb_newOrder then
						ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
					else  //order was initially created on an estimated port of call and could not be assigned a payment id
						if isnull(ids_bunker.getItemNumber(ll_row, "payment_id")) then
							ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
						end if
					end if
				else 
					ids_bunker.setItem(ll_row, "payment_id", ll_null)
				end if
			else  // TC-OUT Delivery
				if ids_bunker.getItemNumber(ll_row, "buy_sell") = 1 &
				and ids_bunker.getItemNumber(ll_row, "owner_pool_purchase_or_chart")=2 then
					if lb_newOrder then
						ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
					else  //order was initially created on an estimated port of call and could not be assigned a payment id
						if isnull(ids_bunker.getItemNumber(ll_row, "payment_id")) then
							ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
						end if
					end if
				else 
					ids_bunker.setItem(ll_row, "payment_id", ll_null)
				end if
			end if		
		case "RED"
			if ib_singlevoyage then //TC-IN Redelivery
				if ids_bunker.getItemNumber(ll_row, "buy_sell") = 1 &
				and ids_bunker.getItemNumber(ll_row, "owner_pool_purchase_or_chart")=0 then
					ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
				else 
					ids_bunker.setItem(ll_row, "payment_id", ll_null)
				end if
			else  // TC-OUT Redelivery
				if ids_bunker.getItemNumber(ll_row, "buy_sell") = 0 &
				and ids_bunker.getItemNumber(ll_row, "owner_pool_purchase_or_chart")=2 then
					ids_bunker.setItem(ll_row, "payment_id", ll_paymentID)
				else 
					ids_bunker.setItem(ll_row, "payment_id", ll_null)
				end if
			end if		
	end choose	
next	

///* Update payment balance in TC Hire */
//ls_mySQL = "sp_paymentBalance " + string(ll_paymentID)
//EXECUTE IMMEDIATE :ls_mySQL;
//if sqlca.sqlcode <> 0 then
//	MessageBox("SP Execute Error","System failed when trying to update TC Hire Payment Balance~r~n~r~n" &
//					+ "(Object: n_bunker_purchase.of_connect_to_tchire())")
//	rollback;
//	return -1
//end if	
//commit;

return 1
end function

public function integer of_checkdeliverybunkermodified (ref long al_affected_paymentid[]);/* This function checkes if the payment which the bunker purchase
	is connected to, is settled (status > 2) 
	
	First check if there are any connections to do .......
*/
long 				ll_rows, ll_row, ll_paymentStatus
long				ll_paymentID, ll_bpn
n_tc_payment	lnv_tc_payment
string				ls_mySQL
decimal{4}		ld_bunkervalue
long				ll_affected_paymentid[2]

/*	if no contract id POC is not connected to a TC Contract */
if isNull(il_contractid) or il_contractid < 1 then return 1

/* 	if purpose is not Delivery, then this is not a Bunker
	purchase ON DELIVERY that can be connected to a payment */
if is_purpose <> "DEL" then return 1

/* Run throught all rows */
ll_rows = ids_bunker.rowCount()
lnv_tc_payment = create  n_tc_payment
for ll_row = 1 to ll_rows
	ll_bpn = ids_bunker.getItemNumber(ll_row, "bpn")
	if isNull(ll_bpn) then
		/* new row. just connect to payment */
		continue
	end if
	
	/* check if field that changes values was modified */ 
	if ids_bunker.getItemStatus(ll_row, "lifted_hfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "price_hfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "lifted_do", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "price_do", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "lifted_go", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "price_go", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "lifted_lshfo", primary!) = dataModified! &
	or ids_bunker.getItemStatus(ll_row, "price_lshfo", primary!) = dataModified! then
		//OK
	else
		continue 
	end if
	
	/* modified row , check if payment settled (status > 2) */
	ll_paymentID = ids_bunker.getItemNumber(ll_row, "payment_id")

	if isNull(ll_paymentID) then continue  // nothing to do
	
	SELECT PAYMENT_STATUS  
		INTO :ll_paymentStatus  
		FROM NTC_PAYMENT  
		WHERE NTC_PAYMENT.PAYMENT_ID = :ll_paymentID   ;
	COMMIT;	
	
	if ll_paymentStatus < 3 then continue  //if status new or draft continue
	
	 SELECT isnull(LIFTED_HFO * PRICE_HFO,0)   
         + isnull(LIFTED_DO * PRICE_DO,0)   
         + isnull(LIFTED_GO * PRICE_GO,0)   
         + isnull(LIFTED_LSHFO * PRICE_LSHFO,0)  
	INTO :ld_bunkervalue
   	FROM BP_DETAILS  
	WHERE BPN = :ll_bpn;
	commit;

	/* The affected payment id is a workaround so that payment balance can be updated
		in of_update */
	setNull(ll_affected_paymentid[1])
	setNull(ll_affected_paymentid[2])
	if lnv_tc_payment.of_deliverybunkermodified( ll_bpn, abs(ld_bunkervalue), ll_affected_paymentid ) = -1 then
		destroy lnv_tc_payment
		return -1	
	end if
	if not isnull(ll_affected_paymentid[1]) then al_affected_paymentid[upperbound(al_affected_paymentid) +1] = ll_affected_paymentid[1]
	if not isnull(ll_affected_paymentid[2]) then al_affected_paymentid[upperbound(al_affected_paymentid) +1] = ll_affected_paymentid[2]
next

destroy lnv_tc_payment
return 1
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN>
    </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		11/12/14		CR3813		CCY018		Check Estimated Bunker on Arrival and Departure in Estimated POC.
		16/07/15		CR3226		XSZ004		Change message for Bunkers Type.
	</HISTORY>
********************************************************************/
end subroutine

on n_bunker_purchase.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_bunker_purchase.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_createDatastores( )
end event

event destructor;of_destroydatastores( )
end event

