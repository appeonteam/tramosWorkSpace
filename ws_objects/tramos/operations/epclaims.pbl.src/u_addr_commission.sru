$PBExportHeader$u_addr_commission.sru
forward
global type u_addr_commission from nonvisualobject
end type
end forward

global type u_addr_commission from nonvisualobject
end type
global u_addr_commission u_addr_commission

type variables
string _is_currcode
end variables

forward prototypes
public function integer of_add_com (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr)
private subroutine documentation ()
public function integer of_setcurrcode (string as_currcode)
end prototypes

public function integer of_add_com (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr);/********************************************************************
   of_add_com
   <DESC>		</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		as_voyage_nr
		al_chart_nr
		al_claim_nr
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		??/??/?? ???           ???      First Version
		29-09-15 CR3778        LHG008   1.Add Transaction C in Actions/Transactions window for FRT claims.
		                                2.Transactions with code A & W in A/T window must not recalculate the Transaction C.
		17/11/17		CR4652		HHX010	Address and broker commission should never be calculated for the bunker parts of a claim.										  
   </HISTORY>
********************************************************************/

decimal {2} ld_adr_comm, ld_claim_amount, ld_adr_amount, ld_write_off, ld_amount_usd, ld_bunker_amount
long 			ll_rows, ll_found, ll_seq
string 		ls_type, ls_curr_code
mt_n_datastore 			lds_adrcomm_trans
n_claimcurrencyadjust	lnv_claimcurrencyadjust
n_get_maxvalue				lnv_get_maxvalue
uo_freight_balance		luo_frt_balance
long ll_cerp_id


SELECT IsNUll(CLAIMS.ADDRESS_COM,0), IsNull(CLAIM_AMOUNT,0), CLAIM_TYPE, CURR_CODE, CAL_CERP_ID
INTO :ld_adr_comm, :ld_claim_amount, :ls_type, :ls_curr_code, :ll_cerp_id
FROM CLAIMS  
WHERE CLAIMS.VESSEL_NR = :ai_vessel_nr AND  
		CLAIMS.VOYAGE_NR = :as_voyage_nr AND  
		CLAIMS.CHART_NR = :al_chart_nr AND  
		CLAIMS.CLAIM_NR = :al_claim_nr;

IF SQLCA.SQLCode < 0 THEN
	Messagebox("Error","Error selecting claim amount and adr. comm. Object/function: u_addr_commission.of_add_com()")
	destroy lds_adrcomm_trans
	return -1
END IF

IF ls_type<> 'FRT' AND ls_type<>'HEA'  AND ls_type<>'DEV' THEN
	SELECT ISNULL(HFO_TON,0)*ISNULL(HFO_PRICE,0) + ISNULL(DO_TON,0)*ISNULL(DO_PRICE,0) + ISNULL(GO_TON,0)*ISNULL(GO_PRICE,0)+ ISNULL(LSHFO_TON,0)*ISNULL(LSHFO_PRICE,0)
	INTO :ld_bunker_amount
	FROM  HEA_DEV_CLAIMS
	WHERE VESSEL_NR =  :ai_vessel_nr  AND VOYAGE_NR = :as_voyage_nr 
		 AND  CHART_NR =  :al_chart_nr  AND CLAIM_NR = :al_claim_nr;
	IF ISNULL(ld_bunker_amount) THEN ld_bunker_amount = 0 
END IF

if _is_currcode <> "" then ls_curr_code = _is_currcode

//Check if there have address commission
lds_adrcomm_trans = create mt_n_datastore
if ls_type = "FRT" then
	lds_adrcomm_trans.dataObject = "d_sq_gr_frt_addrcomm_trans"
else
	lds_adrcomm_trans.dataObject = "d_claim_address_comm_trans"
end if

lds_adrcomm_trans.setTransObject(SQLCA)
ll_rows = lds_adrcomm_trans.retrieve(ai_vessel_nr, as_voyage_nr, al_chart_nr, al_claim_nr)
if ll_rows > 1 then 
	Messagebox("Error","There can't be more than one Adr.Commission record for claim. " &
					+ "Object/function: u_addr_commission.of_add_com()")
	destroy lds_adrcomm_trans
	return -1
end if

IF ls_type = "HEA" or ls_type = "DEV" then
	//If heating or deviation only calculate adr.commission from time, not bunker
	SELECT isnull((HEA_DEV_CLAIMS.HEA_DEV_HOURS*(HEA_DEV_CLAIMS.HEA_DEV_PRICE_PR_DAY/24)),0) as AMOUNT
		INTO :ld_claim_amount  
		FROM HEA_DEV_CLAIMS  
		WHERE HEA_DEV_CLAIMS.VESSEL_NR = :ai_vessel_nr  AND  
				HEA_DEV_CLAIMS.VOYAGE_NR = :as_voyage_nr  AND  
				HEA_DEV_CLAIMS.CHART_NR = :al_chart_nr  AND  
				HEA_DEV_CLAIMS.CLAIM_NR = :al_claim_nr ;
END IF

IF ld_adr_comm > 0 AND (ls_type = "FRT" or ld_claim_amount > 0) THEN
	//Calculate adr.comm and set values
	if ls_type = "FRT" then
		luo_frt_balance = create uo_freight_balance
		luo_frt_balance.uf_calculate_balance(ai_vessel_nr, as_voyage_nr, al_chart_nr, al_claim_nr)
		ld_adr_amount = luo_frt_balance.uf_get_addrcomm()
		destroy luo_frt_balance
	else
		ld_adr_amount = (ld_claim_amount - ld_bunker_amount )* (ld_adr_comm / 100)
	end if
	
	//There is commission
	if ll_rows = 0 then
		lnv_get_maxvalue = create n_get_maxvalue
		if ls_type = "FRT" then
			ll_seq = lnv_get_maxvalue.of_get_maxvalue("FREIGHT_RECEIVED")
		else
			ll_seq = lnv_get_maxvalue.of_get_maxvalue("CLAIM_TRANSACTION")
		end if
		destroy lnv_get_maxvalue
		
		if ll_seq < 0 then
			messagebox("Error", "Error get sequence number. Object/function: u_addr_commission.of_add_com()")
			return -1
		end if
		
		//insert record and set initial values
		ll_rows = lds_adrcomm_trans.insertRow(0)
		lds_adrcomm_trans.setItem(ll_rows, "vessel_nr", ai_vessel_nr)
		lds_adrcomm_trans.setItem(ll_rows, "voyage_nr", as_voyage_nr)
		lds_adrcomm_trans.setItem(ll_rows, "chart_nr", al_chart_nr)
		lds_adrcomm_trans.setItem(ll_rows, "claim_nr", al_claim_nr)
		lds_adrcomm_trans.setItem(ll_rows, "c_trans_val_date", date(string(today())))
		lds_adrcomm_trans.setItem(ll_rows, "c_trans_comment", "Calculated adr.comm.")
		lds_adrcomm_trans.setItem(ll_rows, "c_trans_code", "C")
		lds_adrcomm_trans.setitem(ll_rows, "c_trans_seq", ll_seq)
		lds_adrcomm_trans.setitem(ll_rows, "c_trans_created_by", uo_global.is_userid)
	end if
	
	lnv_claimcurrencyadjust.of_getamountusd(ai_vessel_nr, as_voyage_nr, al_chart_nr, ls_type, ll_cerp_id, ls_curr_code, ld_adr_amount, ld_amount_usd)
	lds_adrcomm_trans.setItem(ll_rows, "c_trans_amount", ld_adr_amount)
	lds_adrcomm_trans.setItem(ll_rows, "c_trans_amount_usd", ld_amount_usd)
ELSE
	//No Commission - delete row if it exists
	if ll_rows = 1 then
		lds_adrcomm_trans.deleterow(ll_rows)
	end if
END IF

if lds_adrcomm_trans.update() <> 1 then
	Messagebox("Error","Error updating Claim Transaction. Object/function: u_addr_commission.of_add_com()")
	destroy lds_adrcomm_trans
	return -1
end if

//Refresh action transaction window if open
IF IsValid(w_actions_transactions) THEN
	w_actions_transactions.PostEvent("ue_refresh")
END IF

destroy lds_adrcomm_trans
return 1
end function

private subroutine documentation ();/********************************************************************
   ObjectName: u_addr_commission
   <OBJECT> 	</OBJECT>
   <USAGE>  	Used to generate the address commission for all claims.	</USAGE>
   <ALSO>   	</ALSO>
<HISTORY> 
   Date	   CR-Ref	  Author	Comments
23-02-11   CR1549     JSU     Address commission is calculated based on the claims' local currency
									   amount, the amount_usd is calculated based on the exrates, currencies
									   in the claims.									  
11-06-14   CR3701     LHG008  Display who creates the transaction.
29-09-15   CR3778     LHG008  1.Add Transaction C in Actions/Transactions window for FRT claims.
                              2.Transactions with code A & W in A/T window must not recalculate the Transaction C.
17/11/17		CR4652		HHX010	Address and broker commission should never be calculated for the bunker parts of a claim.										
</HISTORY>
********************************************************************/
end subroutine

public function integer of_setcurrcode (string as_currcode);_is_currcode = as_currcode
return c#return.Success

end function

on u_addr_commission.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_addr_commission.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

