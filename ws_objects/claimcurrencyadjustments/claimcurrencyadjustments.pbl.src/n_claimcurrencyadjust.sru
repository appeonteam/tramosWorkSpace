$PBExportHeader$n_claimcurrencyadjust.sru
$PBExportComments$General functions/tools for currency related actions.  Used throughout Tramos
forward
global type n_claimcurrencyadjust from mt_n_nonvisualobject
end type
end forward

global type n_claimcurrencyadjust from mt_n_nonvisualobject autoinstantiate
end type

type variables
private string _is_currcode = "", _is_voyage_nr
private boolean _ib_amendedcurr = false
private decimal {6}  _id_fixedexrate = 0
private boolean _ib_get_dem_balance = false
private decimal {2} id_claim_percentage_local = 0

//private integer _ii_vessel_nr, _ii_cerp_nr, _ii_chart_nr, _ii_fixexrate = 0

end variables

forward prototypes
public subroutine documentation ()
public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd)
public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message)
public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, date adate_rate, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message)
public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, date adate_rate, decimal ad_amount_local, ref decimal ad_amount_usd)
public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd)
public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_currcode, boolean ab_outstanding, boolean ab_overridelocal)
public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, boolean ab_overridelocal)
public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_currcode)
public function integer of_setcurrcode (string as_currcode)
private function string _getcurrcode (string as_currcode)
public function integer of_getnonfreightamounts (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, ref decimal ad_amount_local, ref decimal ad_amount_usd, decimal ad_transamount_local, decimal ad_transamount_usd, ref string as_message, boolean ab_outstanding)
public function decimal of_getfixedrate ()
public function integer of_setfixedrate (decimal ad_fixedexchangerate)
public subroutine of_set_dembalance_flag (boolean ab_dembalance_flag)
public function integer of_getsetexrate (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, ref decimal ad_exrate)
public function integer of_getamountusd (string as_claim_type, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message)
public function integer of_getamountusd (string as_claim_type, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd)
public function boolean uf_vesselvoyage_to_calc (integer ai_vessel_nr, string as_voyage_nr, ref long al_calc_id)
public function boolean uf_cargo_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_cargo_base_data astr_cargo_base_data)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_claimcurrencyadjust
	
   	<OBJECT> 
		Claims - standard functions concerned with adjustments on USD amounts
	</OBJECT>
   	<DESC>   
		TODO	
	</DESC>
   	<USAGE>
		
	</USAGE>
   	<ALSO>   
		common - n_exchangerate
	</ALSO>
	
    Date   		Ref    			Author        Comments
  24/02/11 	CR2294     	AGL     		First Version.  Renamed. 
  10/03/11 	CR2294		AGL			Added fixed rate functionality.
  29/10/12	CR2949		LGX001		Add dem percentage function when to get dem balance
  29/11/16  CR4509      SSX014      Change the USD claim amount formula for non-FRT claims as defined in CR3778
                                    USD claim amount = Local claim amount * Exchange rate
********************************************************************/

end subroutine

public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd);string ls_dummy
return of_getamountusd(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, today(), ad_amount_local, ad_amount_usd,ls_dummy)

end function

public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message);/********************************************************************
   of_getamountusd( /*string as_currcode*/, /*decimal ad_amount*/, /*ref decimal ad_amount_usd*/, /*ref string as_message */)
   <DESC>   Gets the latest usd amount available.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

return of_getamountusd(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, today(), ad_amount_local, ad_amount_usd, as_message)

end function

public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, date adate_rate, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message);/********************************************************************
   of_getamountusd( /*string as_currcode*/, /*decimal ad_amount*/, /*ref decimal ad_amount_usd*/, /*ref string as_message */)
   <DESC>   Public function that obtains the usd amount looking up the currency exchange rate of the date that is passed.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

decimal {6} ld_rate
n_exchangerate		lnv_exrate

if ad_amount_local = 0 then return c#return.NoAction

if as_currcode = "USD" then 
	ad_amount_usd=ad_amount_local
else
	
	if as_claim_type = "SPEC" then
		ld_rate = lnv_exrate.of_getexchangerate( as_currcode, "USD", adate_rate)
	else
		setnull(ld_rate)
		of_getsetexrate(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, ld_rate)
		
		if isnull(ld_rate) then
			ld_rate = lnv_exrate.of_getexchangerate( as_currcode, "USD", adate_rate)
		end if
	end if
	
	if ld_rate < 0 then
		as_message = as_currcode + "->USD:" + string(round(ld_rate,4))
		return c#return.Failure
	else
		as_message = as_currcode + "->USD:" + string(round(ld_rate,4))
		ad_amount_usd = ad_amount_local * (ld_rate/100)
	end if
	
end if

return c#return.Success
end function

public function integer of_getamountusd (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, date adate_rate, decimal ad_amount_local, ref decimal ad_amount_usd);/********************************************************************
   of_getamountusd( /*string as_currcode*/, /*decimal ad_amount*/, /*ref decimal ad_amount_usd*/, /*ref string as_message */)
   <DESC>   Gets the closest usd amount to the date passed in.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
string ls_dummy
return of_getamountusd( ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, adate_rate, ad_amount_local, ad_amount_usd, ls_dummy)

end function

public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd);/********************************************************************

of_getclaimamounts( /*integer ai_vessel_nr*/, /*string as_voyage_nr*/, /*integer ai_chart_nr*/, /*integer ai_claim_nr*/, /*ref decimal ad_amount_local*/, /*ref decimal ad_amount_usd */)

   <DESC>Retreives the local amount and calculates the USD</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>
	ai_vessel_nr:		Vessel number
	as_voyage_nr:		Voyage number
	ai_chart_nr:			Charterer number
	ai_claim_nr:			Clam number
	ad_amount_local:	placeholder for localclaim amount
	ad_amount_usd:	placeholder for usd claim amount
	</ARGS>
   <USAGE>This is the simplest form of the function.  Used on most occasions, it obtains the local amount and calculates the 
	USD amount using the reference values passed in.  Ignores any value passed inside ad_amount_local.  </USAGE>
********************************************************************/
string ls_currcode

return of_getclaimamounts( ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, ad_amount_local, ad_amount_usd, ls_currcode, false, true )
end function

public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_currcode, boolean ab_outstanding, boolean ab_overridelocal); /********************************************************************

of_getclaimamounts( /*integer ai_vessel_nr*/, /*string as_voyage_nr*/, /*integer ai_chart_nr*/, /*integer ai_claim_nr*/, /*ref decimal ad_amount_local*/, /*ref decimal ad_amount_usd*/, /*ref string as_currcode*/, /*boolean ab_outstanding */, /*boolean ab_overridelocal */)

   <DESC>Retreives the local amount and calculates the USD</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>
	ai_vessel_nr:		Vessel number
	as_voyage_nr:		Voyage number
	ai_chart_nr:			Charterer number
	ai_claim_nr:			Clam number
	ad_amount_local:	placeholder for localclaim amount
	ad_amount_usd:	placeholder for usd claim amount
	as_currcode:		variable to hold currency code text
	ab_outstanding:	switch, if true we obtain only the outstanding 
							otherwise we get the total claim amount
	</ARGS>
   <USAGE>This is where the main code resides and all options are available.</USAGE>
********************************************************************/

long					ll_row, ll_rowcount
integer				li_retval
string				ls_message, ls_claimtype
long              ll_cerp_id

mt_n_datastore		lds_claim
	
	lds_claim = create mt_n_datastore
	lds_claim.dataobject="d_sq_tb_cc_singleclaim"
	lds_claim.settransobject( sqlca )
	lds_claim.retrieve(ai_vessel_nr,as_voyage_nr,ai_chart_nr,ai_claim_nr)
	
	if lds_claim.rowcount() = 1 then
		if ab_overridelocal then
			ad_amount_local = lds_claim.getitemdecimal(1, "claimamount_local")
		end if
		ad_amount_usd = lds_claim.getitemdecimal(1, "claimamount_usd")
		id_claim_percentage_local = lds_claim.getitemdecimal(1, "claim_percentage_local")
			
		ls_claimtype = lds_claim.getitemstring(1,"claim_type")
		as_currcode = _getcurrcode(lds_claim.getitemstring(1,"curr_code"))
		ll_cerp_id = lds_claim.getitemnumber(1, "cal_cerp_id")
		
		choose case ls_claimtype
			case "FRT"	
				li_retval = of_getamountusd(ai_vessel_nr, as_voyage_nr, ai_claim_nr, ls_claimtype, ll_cerp_id, as_currcode, ad_amount_local, ad_amount_usd, ls_message)
				if li_retval = c#return.NoAction or li_retval = c#return.Failure then
					ad_amount_usd = 0
				end if
			case else
				li_retval = of_getnonfreightamounts(ai_vessel_nr, as_voyage_nr, ai_claim_nr, ls_claimtype, ll_cerp_id, as_currcode, ad_amount_local, ad_amount_usd,  lds_claim.getitemdecimal(1, "transamount_local"),  lds_claim.getitemdecimal(1, "transamount_usd"), ls_message, ab_outstanding)
		end choose
	end if
	destroy lds_claim

	ad_amount_local = round(ad_amount_local,2)
	ad_amount_usd = round(ad_amount_usd,2)

return li_retval
end function

public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, boolean ab_overridelocal);/********************************************************************

of_getclaimamounts( /*integer ai_vessel_nr*/, /*string as_voyage_nr*/, /*integer ai_chart_nr*/, /*integer ai_claim_nr*/, /*ref decimal ad_amount_local*/, /*ref decimal ad_amount_usd */, /*boolean ab_overridelocal*/ )

   <DESC>Retreives the local amount (optional) and calculates the USD</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>
	ai_vessel_nr:		Vessel number
	as_voyage_nr:		Voyage number
	ai_chart_nr:			Charterer number
	ai_claim_nr:			Clam number
	ad_amount_local:	placeholder for local claim amount
	ad_amount_usd:	placeholder for usd claim amount
	ab_overridelocal:	if process should use local value passed in set to false.
	</ARGS>
   <USAGE>This version of the function is used inside Tramos on most claim windows. (not the Actions/Transactions window)  Here it is 
	possible to pass a new local amount that will not be replaced.  To do this set the value ab_overridelocal equal to false.</USAGE>
********************************************************************/
string ls_currcode
return of_getclaimamounts( ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, ad_amount_local, ad_amount_usd, ls_currcode, false, ab_overridelocal )
end function

public function integer of_getclaimamounts (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, ref decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_currcode);/********************************************************************

of_getclaimamounts( /*integer ai_vessel_nr*/, /*string as_voyage_nr*/, /*integer ai_chart_nr*/, /*integer ai_claim_nr*/, /*ref decimal ad_amount_local*/, /*ref decimal ad_amount_usd*/, /*ref string as_currcode*/)

   <DESC>Retreives the local amount and calculates the USD</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>
	ai_vessel_nr:		Vessel number
	as_voyage_nr:		Voyage number
	ai_chart_nr:			Charterer number
	ai_claim_nr:			Clam number
	ad_amount_local:	placeholder for localclaim amount
	ad_amount_usd:	placeholder for usd claim amount
	as_currcode:		variable to hold currency code text
	</ARGS>
   <USAGE>This override is used by the uo_claimbalace object.  The currency code is used to visually show the 
	local currency in the appropriate label.</USAGE>
********************************************************************/

return of_getclaimamounts( ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, ad_amount_local, ad_amount_usd, as_currcode, true, true)
end function

public function integer of_setcurrcode (string as_currcode);_is_currcode = as_currcode
return c#return.Success

end function

private function string _getcurrcode (string as_currcode);/********************************************************************
_getcurrcode( /*string as_currcode */)

   <DESC>   returns the currency code if it has been set already, otherwise the value passed in.  </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS>   as_currcode: Description
</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
string ls_retval

if as_currcode <> _is_currcode  and _is_currcode<>"" then
	_ib_amendedcurr = true
else
	_ib_amendedcurr = false
end if

if _is_currcode <> "" then
	ls_retval = _is_currcode
	return ls_retval
else
	return  as_currcode
end if

end function

public function integer of_getnonfreightamounts (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, ref decimal ad_amount_local, ref decimal ad_amount_usd, decimal ad_transamount_local, decimal ad_transamount_usd, ref string as_message, boolean ab_outstanding);string ls_currcode
integer li_retval = c#return.Success
decimal ld_amount_local_untouched

ld_amount_local_untouched = ad_amount_local
if _ib_get_dem_balance then 
	if ad_amount_local >= 0 or (id_claim_percentage_local) = 0 then
		ad_amount_local = ad_amount_local - ad_transamount_local
	else
		ad_amount_local = id_claim_percentage_local - ad_transamount_local
	end if
else
	ad_amount_local = ad_amount_local - ad_transamount_local
end if

if ad_amount_local = 0 then 
	ad_amount_usd = 0
	as_message = ""
else
	if of_getamountusd(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, ad_amount_local, ad_amount_usd, as_message) < 0 then return c#return.Failure
end if

if _ib_amendedcurr then
	if of_getamountusd(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, ad_transamount_local, ad_transamount_usd, as_message) < 0 then return c#return.Failure
end if

if ab_outstanding then
	return c#return.Success
end if

if of_getamountusd(ai_vessel, as_voyage_nr, ai_chart_nr, as_claim_type, al_cerp_id, as_currcode, ld_amount_local_untouched, ad_amount_usd, as_message) < 0 then return c#return.Failure

if ad_transamount_local <> 0 and ad_transamount_local = ad_transamount_usd then
	/* ignore this claim */
	return c#return.NoAction
end if

return c#return.Success
end function

public function decimal of_getfixedrate ();return _id_fixedexrate


end function

public function integer of_setfixedrate (decimal ad_fixedexchangerate);_id_fixedexrate = ad_fixedexchangerate
return c#return.Success
end function

public subroutine of_set_dembalance_flag (boolean ab_dembalance_flag);_ib_get_dem_balance = ab_dembalance_flag
end subroutine

public function integer of_getsetexrate (integer ai_vessel, string as_voyage_nr, integer ai_chart_nr, string as_claim_type, long al_cerp_id, string as_currcode, ref decimal ad_exrate);/********************************************************************
   <DESC>   Gets the exchange rate in the calculation.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

decimal {6} ld_rate
s_cargo_base_data lstr_cargo_base_data

setnull(ld_rate)
if this.uf_cargo_base_data(ai_vessel, as_voyage_nr, ai_chart_nr, al_cerp_id, lstr_cargo_base_data) then
	if lstr_cargo_base_data.set_ex_rate then
		if as_claim_type = "DEM" then
			if lstr_cargo_base_data.dem_curr_code = as_currcode and as_currcode <> 'USD' then
				ld_rate = lstr_cargo_base_data.dem_exrate
			end if
		else
			if lstr_cargo_base_data.frt_curr_code = as_currcode and as_currcode <> 'USD' then
				ld_rate = lstr_cargo_base_data.frt_exrate
			end if
		end if
	end if
else
	return c#return.Failure
end if

// output
ad_exrate = ld_rate

return c#return.Success

end function

public function integer of_getamountusd (string as_claim_type, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd, ref string as_message);/********************************************************************
   of_getamountusd( /*string as_currcode*/, /*decimal ad_amount*/, /*ref decimal ad_amount_usd*/, /*ref string as_message */)
   <DESC>   Gets the latest usd amount available.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
integer li_vessel_nr
string  ls_voyage_nr
integer li_chart_nr
long    ll_cerp_id
setnull(li_vessel_nr)
setnull(ls_voyage_nr)
setnull(li_chart_nr)
setnull(ll_cerp_id)
return of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, as_claim_type, ll_cerp_id, as_currcode, today(), ad_amount_local, ad_amount_usd, as_message)

end function

public function integer of_getamountusd (string as_claim_type, string as_currcode, decimal ad_amount_local, ref decimal ad_amount_usd);/********************************************************************
   of_getamountusd( /*string as_currcode*/, /*decimal ad_amount*/, /*ref decimal ad_amount_usd*/, /*ref string as_message */)
   <DESC>   Gets the latest usd amount available.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
integer li_vessel_nr
string  ls_voyage_nr
integer li_chart_nr
long    ll_cerp_id
string ls_message

setnull(li_vessel_nr)
setnull(ls_voyage_nr)
setnull(li_chart_nr)
setnull(ll_cerp_id)
return of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, as_claim_type, ll_cerp_id, as_currcode, today(), ad_amount_local, ad_amount_usd, ls_message)

end function

public function boolean uf_vesselvoyage_to_calc (integer ai_vessel_nr, string as_voyage_nr, ref long al_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Finds the corrosponding calc id from vessel/voyage

 Arguments : AI_VESSEL_NR as Integer, AS_VOYAGE_NR as String, AL_CALC_ID as Long REF

 Returns   : True if calc found, otherwise false

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


SELECT CAL_CALC_ID	
INTO :al_calc_id
FROM VOYAGES
WHERE VESSEL_NR = :ai_vessel_nr AND
	VOYAGE_NR = :as_voyage_nr
USING SQLCA;
COMMIT;

Return(al_calc_id <> 0)

end function

public function boolean uf_cargo_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_cargo_base_data astr_cargo_base_data);Long ll_calc_id
Integer ll_set_ex_rate = 0

// Try to find to CALC_ID from AI_VESSEL_NR and AS_VOYAGE_NR. UF_VESSELVOYAGE_TO_CALC
// will return true and the CALC_ID in LL_CALC_ID
If uf_vesselvoyage_to_calc(ai_vessel_nr, as_voyage_nr, ll_calc_id) Then

	// Calculation was found. Retrieve the laycan start and end dates
	SELECT DISTINCT CAL_CARG_LAYCAN_START,
	       CAL_CARG_LAYCAN_END,
	       CAL_CARG_CURR_CODE,
	       FIXED_EXRATE_ENABLED,
	       FIXED_EXRATE,
	       CLAIM_CURR,
			 CAL_CARG_DEM_CURR_CODE,
			 CAL_CARG_SET_EX_RATE,
			 CAL_CARG_DEM_EXRATE_USD,
			 CAL_CARG_EXRATE_USD
	  INTO :astr_cargo_base_data.laycan_start,
	       :astr_cargo_base_data.laycan_end,
	       :astr_cargo_base_data.frt_curr_code,
	       :astr_cargo_base_data.fixed_exrate_enabled,
	       :astr_cargo_base_data.fixed_exrate,
	       :astr_cargo_base_data.claim_curr,
			 :astr_cargo_base_data.dem_curr_code,
			 :ll_set_ex_rate,
			 :astr_cargo_base_data.dem_exrate,
			 :astr_cargo_base_data.frt_exrate
	  FROM CAL_CARG
	 WHERE CAL_CERP_ID = :al_cerp_id AND CAL_CALC_ID = :ll_calc_id
	 ORDER BY CAL_CARG_LAYCAN_START ASC
	 USING SQLCA;
	 astr_cargo_base_data.set_ex_rate = (ll_set_ex_rate<>0)

	 return true
End If

return false


end function

on n_claimcurrencyadjust.create
call super::create
end on

on n_claimcurrencyadjust.destroy
call super::destroy
end on

