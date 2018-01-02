$PBExportHeader$n_adjustgenerator.sru
$PBExportComments$Object containing business logic for the usd amount modifications that are run periodically from the server on a schedule.
forward
global type n_adjustgenerator from mt_n_nonvisualobject
end type
end forward

global type n_adjustgenerator from mt_n_nonvisualobject
end type
global n_adjustgenerator n_adjustgenerator

type variables
private boolean 						_ib_debug=false
private n_claimcurrencyadjust 		_inv_adjust

end variables

forward prototypes
public subroutine documentation ()
public function integer of_setdebugmode (boolean ab_debug)
public function integer of_main ()
private function integer _doclaims ()
private function integer _docommissions ()
private function boolean _getdebugmode ()
private function integer _doaddresscoms ()
private function integer _dotranscations (string as_type)
public function integer _dospecialclaimtranscation (string as_type)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_claimcurrencycalc
	
   	<OBJECT> 
		Server based process to regenerate USD outstanding amounts
	</OBJECT>
   	<DESC>   
		TODO	
	</DESC>
   	<USAGE>
		run inside this application. 
	</USAGE>
   	<ALSO>   
		uses the Maersk Tankers framework (located in mt_base_components/mt_constants/mt_services)
		also uses n_currencycalc object.
	</ALSO>
	
    Date   Ref    Author        Comments
  14/02/11 CR2294      AGL     First Version
  13/06/13 CR2472 LGX001		Adjust the USD Addr. Comm = SUM(USD receivables ) *addr. Comm % + outstanding USD claim amount * addr. Comm %
  18/09/15 CR3778 CCY018		Uses the last exchange rate to calculate USD amount.
  17/06/16 CR4307 SSX014      Exclude the claims with Set Ex Rate is used
********************************************************************/

end subroutine

public function integer of_setdebugmode (boolean ab_debug);_ib_debug = ab_debug
return c#return.Success
end function

public function integer of_main ();/********************************************************************
of_main()

   <DESC>   Adjust all USD amounts found and set with todays exchange rate. </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS></ARGS>
   <USAGE>Designed as a server application</USAGE>
********************************************************************/

// generate transcations (must be before generated claims)
_dotranscations("FRT")
_dotranscations("NOFRT")

// generate claims
_doclaims( )

//generate commission
_docommissions( )

//generate special claims
_dospecialclaimtranscation("CLAIM")

//generate special claim transcations
_dospecialclaimtranscation("TRANSCATION")

//finished
_addmessage( this.classdefinition, "of_main()", "Completed update of all currencies", "user info")

return c#return.Success
end function

private function integer _doclaims ();/********************************************************************
   _doclaims( )
	
   <DESC>   Focused on processing the claim adjustments</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  called from of_main() function.</USAGE>
	<HISTORY>
	29/07/16    CR4307      SSX014      Exclude the transactions with Set Ex Rate is used
	</HISTORY>
********************************************************************/

mt_n_datastore		lds_claims
long						ll_row, ll_rowcount, ll_ignoredcounter = 0
integer					li_returnval
decimal {2}				ld_amount_local, ld_amount_usd, ld_previous_usd, ld_addresscom
string					ls_message, ls_claimtype, ls_vesselnr, ls_voyagenr
long						ll_cerp_id
string					ls_voyage_nr, ls_curr_code
integer					li_vessel_nr, li_chart_nr
decimal					ld_setexrate

	lds_claims = create mt_n_datastore
	lds_claims.dataobject="d_sq_tb_cc_claims"
	lds_claims.settransobject( sqlca )
	lds_claims.retrieve( )
	ll_rowcount = lds_claims.rowcount()
	
	_addmessage( this.classdefinition, "_doclaims()", "Processing (" + string(ll_rowcount) + ") claims", "user info")
	
	if ll_rowcount = 0 then return c#return.NoAction
	
	for ll_row = 1 to ll_rowcount
		ld_amount_local = lds_claims.getitemdecimal(ll_row, "claimamount_local")
		ld_amount_usd = lds_claims.getitemdecimal(ll_row, "claimamount_usd")
		ld_previous_usd = ld_amount_usd
	//	if lds_claims.getitemdecimal(ll_row, "transamount_local") <> ld_amount_local then		
			
			ls_vesselnr = string(lds_claims.getitemnumber(ll_row,"vessel_nr"),"0000")
			ls_voyagenr = string(lds_claims.getitemstring(ll_row,"voyage_nr"),"@@@@@-@@")
			ls_claimtype = lds_claims.getitemstring(ll_row,"claim_type")
			
			li_vessel_nr = lds_claims.getitemnumber(ll_row, "vessel_nr")
			li_chart_nr = lds_claims.getitemnumber(ll_row, "chart_nr")
			ls_voyage_nr = lds_claims.getitemstring(ll_row, "voyage_nr")
			ls_curr_code = lds_claims.getitemstring(ll_row, "curr_code")
			ll_cerp_id = lds_claims.getitemnumber(ll_row, "cal_cerp_id")
			
			// Exclude the claims with Set Ex Rate is used
			setnull(ld_setexrate)
			_inv_adjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_setexrate )
			if not isnull(ld_setexrate) then continue
			
			choose case ls_claimtype
				case "FRT"	
					li_returnval = _inv_adjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_amount_local, ld_amount_usd, ls_message )
				case else
					li_returnval = _inv_adjust.of_getnonfreightamounts(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_amount_local, ld_amount_usd, lds_claims.getitemdecimal(ll_row, "transamount_local"),  lds_claims.getitemdecimal(ll_row, "transamount_usd"), ls_message,false)
			end choose
			
			if li_returnval=c#return.Success then
				if _getdebugmode() then
					_addmessage( this.classdefinition, "_doclaims()", "(bypass set data as in debug mode)","user info")
				else
					lds_claims.setitem(ll_row, "claimamount_usd",round(ld_amount_usd,2))
				end if
				_addmessage( this.classdefinition, "_doclaims()", "|" + ls_message + "|" + ls_vesselnr + &
				"/" + ls_voyagenr + "|" + ls_claimtype + "|original usd amount=" + string(round(ld_previous_usd,2)) + & 
				"|adjusted usd amount=" + string(round(ld_amount_usd,2)) + "|", "user info")
			elseif li_returnval=c#return.NoAction then
	
				ll_ignoredcounter ++
				if _getdebugmode() then
					_addmessage( this.classdefinition, "_doclaims()", "|*info!* " + ls_message + "|" + ls_vesselnr + &
					"/" + ls_voyagenr + "|" + ls_claimtype + "|ignored claim|","user info")
				end if
				
			else	
				_addmessage( this.classdefinition, "_doclaims()", "|*error* " + ls_message + "|" + string(lds_claims.getitemnumber(ll_row,"vessel_nr"),"000") + &
				"/" + lds_claims.getitemstring(ll_row,"voyage_nr") + "|type=" + ls_claimtype + "|","user info")
			end if
		
//		end if
		
	next
	
	if ll_ignoredcounter>0 then _addmessage( this.classdefinition, "_doclaims()", "|*info!* update process ignored " + string(ll_ignoredcounter) + " claim(s)|","user info")
	
	if lds_claims.modifiedcount( )>0 then
		if lds_claims.update() = 1 then
			COMMIT;
			return c#return.Success
		else
			_addmessage( this.classdefinition, "_docommissions()", "error, updating changes in commissions table.  rolling back all updates", "Error detail:" + string(sqlca.SQLCode) + " - " + sqlca.SQLerrtext)
			ROLLBACK;
			return c#return.Failure
		end if
	end if
	
	destroy lds_claims
	
return c#return.Success
end function

private function integer _docommissions ();/********************************************************************
   _docommissions( )
	
   <DESC>   Focused on processing the broker/pool commission adjustments</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  called from of_main() function.</USAGE>
	<HISTORY>
	29/07/16    CR4307      SSX014      Exclude the transactions with Set Ex Rate is used
	</HISTORY>
********************************************************************/

mt_n_datastore		lds_commissions
long						ll_row, ll_rowcount
integer					li_returnval
decimal {2}				ld_amount_local, ld_amount_usd, ld_previous_usd	
string					ls_message, ls_claimtype, ls_vesselnr, ls_voyagenr
integer					li_vessel_nr
string					ls_voyage_nr // unformatted
integer					li_chart_nr
string					ls_curr_code
long						ll_cerp_id
decimal					ld_setexrate

	lds_commissions = create mt_n_datastore
	lds_commissions.dataobject="d_sq_tb_cc_commissions"
	lds_commissions.settransobject( sqlca )
	lds_commissions.retrieve( )
	ll_rowcount = lds_commissions.rowcount()
	
	_addmessage( this.classdefinition, "_docommissions()", "Processing (" + string(ll_rowcount) + ") commissions", "user info")
	
	if ll_rowcount = 0 then return c#return.NoAction
	
	for ll_row = 1 to ll_rowcount
		ld_amount_local = lds_commissions.getitemdecimal(ll_row, "commamount_local")
		ld_amount_usd = lds_commissions.getitemdecimal(ll_row, "commamount_usd")
		ld_previous_usd = ld_amount_usd
		ls_vesselnr = string(lds_commissions.getitemnumber(ll_row,"vessel_nr"),"0000")
		ls_voyagenr = string(lds_commissions.getitemstring(ll_row,"voyage_nr"),"@@@@@-@@")
		ls_claimtype = lds_commissions.getitemstring(ll_row,"claim_type")
		li_vessel_nr = lds_commissions.getitemnumber(ll_row, "vessel_nr")
		ls_voyage_nr = lds_commissions.getitemstring(ll_row, "voyage_nr")
		li_chart_nr = lds_commissions.getitemnumber(ll_row, "chart_nr")
		ls_curr_code = lds_commissions.getitemstring(ll_row, "curr_code")
		ll_cerp_id = lds_commissions.getitemnumber(ll_row, "cal_cerp_id")
		
		// Exclude the commissions with Set Ex Rate is used
		setnull(ld_setexrate)
		_inv_adjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_setexrate)
		if not isnull(ld_setexrate) then 
			continue
		end if
		
		li_returnval = _inv_adjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_amount_local, ld_amount_usd, ls_message)
		
		if li_returnval=c#return.Success then
			if _getdebugmode() then
				_addmessage( this.classdefinition, "_docommissions()", "(bypass set data as in debug mode)","user info")
			else
				lds_commissions.setitem(ll_row, "commamount_usd",ld_amount_usd)
			end if
			_addmessage( this.classdefinition, "_docommissions()", "|" + ls_message + "|" + ls_vesselnr + &
			"/" + ls_voyagenr  + "|" + ls_claimtype + "|original usd amount=" + string(ld_previous_usd) + & 
			"|adjusted usd amount=" + string(ld_amount_usd) + "|", "user info")
		else
			_addmessage( this.classdefinition, "_docommissions()", "|*error* " + ls_message + "|" + ls_vesselnr + &
			"/" + ls_voyagenr  + "|" + ls_claimtype + "|","user info")
		end if	
		
	next
	
	if lds_commissions.modifiedcount( )>0 then
		if lds_commissions.update( ) = 1 then
			COMMIT;
			return(c#return.Success)
		else
			_addmessage( this.classdefinition, "_docommissions()", "error, updating changes in commissions table.  rolling back all updates. Error detail:" + string(sqlca.SQLCode) + " - " + sqlca.SQLerrtext, "")
			ROLLBACK;
			return c#return.Failure
		end if
	end if
	
	destroy lds_commissions
	
return c#return.Success
end function

private function boolean _getdebugmode ();return _ib_debug
end function

private function integer _doaddresscoms ();/********************************************************************
   _docommissions( )
	
   <DESC>   Focused on processing the broker/pool commission adjustments</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  called from of_main() function.</USAGE>
********************************************************************/

mt_n_datastore		lds_addresscoms
long					ll_row, ll_rowcount
decimal {4}			ld_amount_usd, ld_previous_usd, ld_trans_amt_usd, ld_claim_amt_usd, ld_trans_rec_amt_usd, ld_outstanding_amt
string				ls_message, ls_claimtype, ls_voyagenr, ls_vesselnr
decimal {2} 		ld_addr_com_pct

lds_addresscoms = create mt_n_datastore
lds_addresscoms.dataobject = "d_sq_tb_cc_addresscoms"
lds_addresscoms.settransobject( sqlca )
lds_addresscoms.retrieve( )
ll_rowcount = lds_addresscoms.rowcount()

_addmessage( this.classdefinition, "_doaddresscoms()", "Processing (" + string(ll_rowcount) + ") address commissions", "user info")

if ll_rowcount = 0 then return c#return.NoAction

for ll_row = 1 to ll_rowcount
	ls_vesselnr = string(lds_addresscoms.getitemnumber(ll_row,"vessel_nr"),"0000")
	ls_voyagenr = string(lds_addresscoms.getitemstring(ll_row,"voyage_nr"),"@@@@@-@@")
	ls_claimtype = lds_addresscoms.getitemstring(ll_row, "claim_type")
		
	ld_previous_usd  = lds_addresscoms.getitemdecimal(ll_row, "commamount_usd")
	ld_trans_amt_usd = lds_addresscoms.getitemdecimal(ll_row, "trans_amt_usd")
	ld_claim_amt_usd = lds_addresscoms.getitemdecimal(ll_row, "claim_amount_usd")
	ld_addr_com_pct  = lds_addresscoms.getitemdecimal(ll_row, "address_com")
	ld_trans_rec_amt_usd = lds_addresscoms.getitemdecimal(ll_row, "trans_rec_amt_usd")
	
	if isnull(ld_trans_amt_usd) then ld_trans_amt_usd = 0
	if isnull(ld_trans_rec_amt_usd) then ld_trans_rec_amt_usd = 0 
	
	//CR2472:Adjust the USD Addr. Comm = SUM(USD receivables ) *addr. Comm % + outstanding USD claim amount * addr. Comm %
	ld_outstanding_amt = ld_claim_amt_usd - ld_trans_amt_usd
	if ld_outstanding_amt < 0 then ld_outstanding_amt = 0
	ld_amount_usd = (ld_trans_rec_amt_usd * ld_addr_com_pct / 100) + ld_outstanding_amt * ld_addr_com_pct / 100
		
	if _getdebugmode() then
		_addmessage( this.classdefinition, "_doaddresscoms()", "(bypass set data as in debug mode)","user info")
	else
		lds_addresscoms.setitem(ll_row, "commamount_usd",round(ld_amount_usd,2))
	end if
	
	_addmessage( this.classdefinition, "_doaddresscoms()", "|" + ls_message + "|" + ls_vesselnr + &
			"/" + ls_voyagenr  + "|" + ls_claimtype + "|original usd amount=" + string(round(ld_previous_usd,2)) + & 
			"|adjusted usd amount=" + string(round(ld_amount_usd,2)) + "|", "user info")
			
next

if lds_addresscoms.modifiedcount( ) > 0 then
	
	if lds_addresscoms.update() = 1 then
		COMMIT;
		return(c#return.Success)
	else
		_addmessage( this.classdefinition, "_doaddresscoms()", "error, updating changes in commissions table.  rolling back all updates", "Error detail:" + string(sqlca.SQLCode) + " - " + sqlca.SQLerrtext)
		ROLLBACK;
		return c#return.Failure
	end if
	
end if

destroy lds_addresscoms

return c#return.Success
end function

private function integer _dotranscations (string as_type);/********************************************************************
   _dotranscations
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_type
   </ARGS>
   <USAGE>	called from of_main() function.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18/09/15		CR3778		CCY018		First Version.
		29/07/16    CR4307      SSX014      Exclude the transactions with Set Ex Rate is used
   </HISTORY>
********************************************************************/

mt_n_datastore		lds_transction
long						ll_row, ll_rowcount, ll_ignoredcounter = 0
integer					li_returnval, li_sqlcode
decimal {2}				ld_amount_local, ld_amount_usd, ld_previous_usd
string 					ls_message, ls_claimtype, ls_vesselnr, ls_curr_code,  ls_voyagenr, ls_sqlerrtext
integer					li_vessel_nr
string					ls_voyage_nr // unformatted
integer					li_chart_nr
long						ll_cerp_id
decimal					ld_setexrate
string               ls_transcode

lds_transction = create mt_n_datastore
if as_type = 'FRT' then
	lds_transction.dataobject = "d_sq_tb_cc_frttranscation"
else
	lds_transction.dataobject = "d_sq_tb_cc_nofrttranscation"
end if

lds_transction.settransobject( sqlca )
lds_transction.retrieve( )
ll_rowcount = lds_transction.rowcount()

_addmessage( this.classdefinition, "_dotranscations()", "Processing (" + string(ll_rowcount) + ")" + as_type + " transcations", "user info")

if ll_rowcount = 0 then return c#return.NoAction

for ll_row = 1 to ll_rowcount
	ld_amount_local = lds_transction.getitemdecimal(ll_row, "amount_local")
	ld_amount_usd = lds_transction.getitemdecimal(ll_row, "amount_usd")
	ld_previous_usd = ld_amount_usd
		
	ls_vesselnr = string(lds_transction.getitemnumber(ll_row, "vessel_nr"), "0000")
	ls_voyagenr = string(lds_transction.getitemstring(ll_row, "voyage_nr"), "@@@@@-@@")
	ls_claimtype = lds_transction.getitemstring(ll_row, "claim_type")
	ls_curr_code = lds_transction.getitemstring(ll_row, "curr_code")
	li_vessel_nr = lds_transction.getitemnumber(ll_row, "vessel_nr")
	ls_voyage_nr = lds_transction.getitemstring(ll_row, "voyage_nr")
	li_chart_nr = lds_transction.getitemnumber(ll_row, "chart_nr")
	ll_cerp_id = lds_transction.getitemnumber(ll_row, "cal_cerp_id")
	ls_transcode = lds_transction.getitemstring(ll_row, "transcode")
	
	// Exclude the transactions with Set Ex Rate is used
	if ls_transcode = 'R' or ls_transcode = 'C' then
		setnull(ld_setexrate)
		_inv_adjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claimtype, ll_cerp_id, ls_curr_code, ld_setexrate )
		if not isnull(ld_setexrate) then
			continue
		else
			li_returnval = _inv_adjust.of_getamountusd(ls_claimtype, ls_curr_code, ld_amount_local, ld_amount_usd )
		end if
	else
		li_returnval = _inv_adjust.of_getamountusd(ls_claimtype, ls_curr_code, ld_amount_local, ld_amount_usd )
	end if
		
	if li_returnval=c#return.Success then
		if _getdebugmode() then
			_addmessage( this.classdefinition, "_dotranscations()", "(bypass set data as in debug mode)","user info")
		else
			lds_transction.setitem(ll_row, "amount_usd", round(ld_amount_usd, 2))
		end if
		_addmessage( this.classdefinition, "_dotranscations()", "|" + ls_message + "|" + ls_vesselnr + &
		"/" + ls_voyagenr + "|" + ls_claimtype + "|original usd amount=" + string(round(ld_previous_usd, 2)) + & 
		"|adjusted usd amount=" + string(round(ld_amount_usd, 2)) + "|", "user info")
	elseif li_returnval=c#return.NoAction then
		ll_ignoredcounter ++
		if _getdebugmode() then
			_addmessage( this.classdefinition, "_dotranscations()", "|*info!* " + ls_message + "|" + ls_vesselnr + &
			"/" + ls_voyagenr + "|" + ls_claimtype + "|ignored transcations|", "user info")
		end if		
	else	
		_addmessage( this.classdefinition, "_dotranscations()", "|*error* " + ls_message + "|" + ls_vesselnr + &
		"/" + ls_voyagenr + "|type=" + ls_claimtype + "|", "user info")
	end if

next

if ll_ignoredcounter > 0 then _addmessage( this.classdefinition, "_dotranscations()", "|*info!* update process ignored " + string(ll_ignoredcounter) + " transcation(s)|", "user info")

if lds_transction.modifiedcount( ) > 0 then
	if lds_transction.update() = 1 then
		commit;
		return c#return.Success
	else
		li_sqlcode = sqlca.sqlcode
		ls_sqlerrtext = sqlca.sqlerrtext
		rollback;
		_addmessage( this.classdefinition, "_dotranscations()", "error, updating changes in transcation table.  rolling back all updates", "Error detail:" + string(li_sqlcode) + " - " + ls_sqlerrtext)
		return c#return.Failure
	end if
end if

destroy lds_transction

return c#return.Success
end function

public function integer _dospecialclaimtranscation (string as_type);/********************************************************************
   _dotranscations
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_type
   </ARGS>
   <USAGE>	called from of_main() function.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/06/16		CR4034		CCY018		First Version.
   </HISTORY>
********************************************************************/

mt_n_datastore		lds_transction
long						ll_row, ll_rowcount, ll_ignoredcounter = 0
integer					li_returnval, li_sqlcode
decimal {2}				ld_amount_local, ld_amount_usd, ld_previous_usd
string						ls_message, ls_claimtype, ls_vesselnr, ls_curr_code,  ls_voyagenr, ls_sqlerrtext

lds_transction = create mt_n_datastore
if as_type = 'CLAIM' then
	lds_transction.dataobject = "d_sq_tb_cc_specialclaims"
elseif as_type = 'TRANSCATION' then
	lds_transction.dataobject = "d_sq_tb_cc_specialclaimtranscations"
end if

lds_transction.settransobject( sqlca )
lds_transction.retrieve( )
ll_rowcount = lds_transction.rowcount()

_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "Processing (" + string(ll_rowcount) + ") special " + lower(as_type) + "(s)", "user info")

if ll_rowcount = 0 then return c#return.NoAction

for ll_row = 1 to ll_rowcount
	ld_amount_local = lds_transction.getitemdecimal(ll_row, "amount")
	ld_amount_usd = lds_transction.getitemdecimal(ll_row, "amount_usd")
	ld_previous_usd = ld_amount_usd
		
	ls_vesselnr = string(lds_transction.getitemnumber(ll_row, "vessel_nr"), "0000")
	ls_voyagenr = string(lds_transction.getitemstring(ll_row, "voyage_nr"), "@@@@@-@@")
	ls_claimtype = "SPEC"
	ls_curr_code = lds_transction.getitemstring(ll_row, "curr_code")

	li_returnval = _inv_adjust.of_getamountusd(ls_claimtype, ls_curr_code, ld_amount_local, ld_amount_usd, ls_message )
	
	if li_returnval=c#return.Success then
		if _getdebugmode() then
			_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "(bypass set data as in debug mode)","user info")
		else
			lds_transction.setitem(ll_row, "amount_usd", round(ld_amount_usd, 2))
		end if
		_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "|" + ls_message + "|" + ls_vesselnr + &
		"/" + ls_voyagenr + "|" + ls_claimtype + "|original usd amount=" + string(round(ld_previous_usd, 2)) + & 
		"|adjusted usd amount=" + string(round(ld_amount_usd, 2)) + "|", "user info")
	elseif li_returnval=c#return.NoAction then
		ll_ignoredcounter ++
		if _getdebugmode() then
			_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "|*info!* " + ls_message + "|" + ls_vesselnr + &
			"/" + ls_voyagenr + "|" + ls_claimtype + "|ignored special " + lower(as_type) + "|", "user info")
		end if		
	else	
		_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "|*error* " + ls_message + "|" + ls_vesselnr + &
		"/" + ls_voyagenr + "|type=" + ls_claimtype + "|", "user info")
	end if

next

if ll_ignoredcounter > 0 then _addmessage( this.classdefinition, "_dospecialclaimtranscation()", "|*info!* update process ignored " + string(ll_ignoredcounter) + "special " + lower(as_type) + "(s)|", "user info")

if lds_transction.modifiedcount( ) > 0 then
	if lds_transction.update() = 1 then
		commit;
		return c#return.Success
	else
		li_sqlcode = sqlca.sqlcode
		ls_sqlerrtext = sqlca.sqlerrtext
		rollback;
		_addmessage( this.classdefinition, "_dospecialclaimtranscation()", "error, updating changes in special " + lower(as_type) + " table.  rolling back all updates", "Error detail:" + string(li_sqlcode) + " - " + ls_sqlerrtext)
		return c#return.Failure
	end if
end if

destroy lds_transction

return c#return.Success
end function

on n_adjustgenerator.create
call super::create
end on

on n_adjustgenerator.destroy
call super::destroy
end on

