$PBExportHeader$n_esttcout_bak.sru
$PBExportComments$TC-OUT estimatations
forward
global type n_esttcout_bak from n_estimate
end type
end forward

global type n_esttcout_bak from n_estimate
end type
global n_esttcout_bak n_esttcout_bak

type variables
constant string is_EXCEPTIONPREFIX="EXC"
s_tcoutestimate 	istr_tcout
s_axestimatesvars	istr_app
s_tcouterrors		istr_errors[]

end variables

forward prototypes
public function integer of_writeoutdebug ()
public function integer of_initapp (s_axestimatesvars astr_app)
public function integer of_init (ref s_tcoutestimate astr_est)
public function boolean of_is_valid_voyagenr (string as_voyagenr)
private function integer _add_to_past_voyages (string as_voyagenr)
private function integer _set_hire (ref s_tcoutperiod astr_hire, integer ai_monthlyrate)
public function integer of_do_transaction ()
public function s_tcoutestimate of_create_tcout_contract (string as_key, integer ai_vesselnr, string as_typecode, datetime adtm_cerpstart, long al_contractid, integer ai_monthlyrate, datetime adtm_start, string as_chartnomaccnr, string as_tcownernomaccnr, string as_currcode, integer ai_bareboat, integer ai_inpool, integer ai_localtime, decimal ad_addrcomm)
private function integer _remove_addrcomm (ref decimal ad_amount, decimal ad_addrcomm_pc)
private function decimal _get_contract_expense (s_tcoutsub astr_exp, s_tcoutperiod astr_hire)
private function integer _set_broker_commissions (ref s_tcoutestimate astr_est)
private function integer _set_contract_expense_rates (ref s_tcoutestimate astr_est)
public function decimal of_get_amount_sum (s_tcoutperiod astr_periods[])
public function decimal of_get_amount_sum (s_tcoutperiod astr_periods[], string as_type)
public function decimal of_get_days_sum (s_tcoutperiod astr_periods[], string as_type)
public function datetime of_get_voyage_start (s_tcoutperiod astr_periods[])
public function datetime of_get_voyage_end (s_tcoutperiod astr_periods[])
public function string of_get_voyage_number (s_tcoutperiod astr_periods[])
public subroutine documentation ()
public function integer of_append_tcout_period (ref s_tcoutestimate astr_est, datetime adtm_start, datetime adtm_end, long al_id, decimal ad_rate, decimal ad_offhire_days, decimal ad_estoffhire_days, string as_voyagenr)
private function decimal _get_est_broker_commission (s_tcoutsub astr_broker, s_tcoutperiod astr_hire)
private function decimal _get_act_broker_commission (long al_contractid, integer ai_voyageyear)
public function decimal of_get_broker_comm (s_tcoutestimate astr_est)
public function string of_validate_voyage_number (integer ai_vesselnr, string as_voyagenr, datetime adtm_periodstart)
public function datetime of_get_tcenddate (integer ai_year, long al_contract_id)
public function integer of_get_tcisnotfinished (integer ai_year, long al_contract_id)
public function datetime of_get_tcstartdate (integer ai_year, long al_contract_id)
public function string of_get_tcdisb_act_est_flag (integer ai_vessel_nr, long al_contract_id, string as_voyage_nr, integer ai_year, datetime adt_start_date, datetime adt_end_date, integer ai_isnofinished)
public function string of_get_tcnon_port_act_est_flag (long al_contract_id, datetime adt_start_date, datetime adt_end_date, integer ai_year, integer ai_isnofinished)
public function decimal of_get_tcdisb_amount (integer ai_vessel_nr, long al_contract_id, s_tcoutperiod astr_period, datetime adt_voyage_start, datetime adt_voyage_end, string as_act_est)
private function integer _set_est_inc_exp (s_tcoutestimate astr_tcout, ref s_tcoutperiod astr_hire)
public function decimal of_get_bunker_loss_profit (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start_date, datetime adt_end_date)
public function decimal of_get_tcnon_port_amount (long al_contract_id, s_tcoutperiod astr_period, string as_act_est, datetime adt_start_date)
public function datetime of_get_firstarrival (s_tcoutestimate astr_tcoutestimate)
end prototypes

public function integer of_writeoutdebug ();string ls_message=""
integer li_periodindex

if istr_app.b_client = false then
	_addmessage( this.classdefinition, "of_writeoutdebug()", "TC-OUT calculation results", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "-----------------------------------", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "period count        :" + string(upperbound(istr_tcout.str_hire),"000"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "contract ID         :" + string(istr_tcout.l_contractid), "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "voyage number       :" + of_get_voyage_number(istr_tcout.str_hire), "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "voyage start        :" + string(of_get_voyage_start(istr_tcout.str_hire),"dd/mm/yyyy hh:mm"), "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "voyage end          :" + string(of_get_voyage_end(istr_tcout.str_hire),"dd/mm/yyyy hh:mm"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "charterer nom acc nr:" + istr_tcout.s_chartnomaccnr, "")			
	_addmessage( this.classdefinition, "of_writeoutdebug()", "tc owner nom acc nr :" + istr_tcout.s_tcownernomaccnr, "")				
	_addmessage( this.classdefinition, "of_writeoutdebug()", "bareboat            :" + string(istr_tcout.i_bareboat), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "in pool             :" + string(istr_tcout.i_inpool), "")			
	_addmessage( this.classdefinition, "of_writeoutdebug()", "misc expenses       :" + string(of_get_amount_sum(istr_tcout.str_hire,"miscexpenses"),"###,###,##0.00"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "misc income         :" + string(of_get_amount_sum(istr_tcout.str_hire,"miscincome"),"###,###,##0.00"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "Local Time/UTC      :" + string(istr_tcout.i_localtime), "")			
	_addmessage( this.classdefinition, "of_writeoutdebug()", "currency code/exrate:" + istr_tcout.s_currcode + " rate=" + string(istr_tcout.d_exchangerate,"###,##0.0000" ), "")				
	_addmessage( this.classdefinition, "of_writeoutdebug()", "total contract exp. :" + string(of_get_amount_sum(istr_tcout.str_hire,"contractexpense"),"###,###,##0.00"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "est broker comm     :" + string(of_get_amount_sum(istr_tcout.str_hire,"brokercomm"),"###,###,##0.00"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "act broker comm     :" + string(istr_tcout.d_actbrokercomm_amount,"###,###,##0.00"), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "off service days    :" + string(of_get_days_sum(istr_tcout.str_hire, "offdays"),"###,##0.00" ), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "freight days        :" + string(of_get_days_sum(istr_tcout.str_hire, "voyagedays"),"###,##0.00" ), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "===================================", "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "total frgt+ off days:" + string(of_get_days_sum(istr_tcout.str_hire, "totaldays"),"###,##0.00" ), "")		
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "off service amount  :" + string(of_get_amount_sum(istr_tcout.str_hire, "offhire"),"###,##0.00" ), "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "freight amount      :" + string(of_get_amount_sum(istr_tcout.str_hire,"freight"),"###,###,##0.00"), "")			
	_addmessage( this.classdefinition, "of_writeoutdebug()", "total freight+off   :" + string(of_get_amount_sum(istr_tcout.str_hire),"###,###,##0.00"), "")			
	_addmessage( this.classdefinition, "of_writeoutdebug()", "===================================", "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")	
	/* periodizer */
	for li_periodindex = 1 to upperbound(istr_tcout.str_hire)
		ls_message+= 	"<<Periodizer (" + string(li_periodindex) + ", " + string(istr_tcout.str_hire[li_periodindex].dtm_start,"dd/mm/yy hh:mm") + &
							" to " + string(istr_tcout.str_hire[li_periodindex].dtm_end,"dd/mm/yy hh:mm") +  "): " + istr_tcout.str_hire[li_periodindex].s_voyagenr + &
							" = " + string(istr_tcout.str_hire[li_periodindex].d_amount,"###,###,##0.00") + ">>"
	next	
	
	_addmessage( this.classdefinition, "of_writeoutdebug()", ls_message, "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")	
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")	
end if
return c#return.Success
end function

public function integer of_initapp (s_axestimatesvars astr_app);/********************************************************************
of_initapp()
	
<DESC>   
	called only once from n_axestimationcontrol to load the application 
	structure s_acestimatevars	into object.
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_app : s_acestimatevars
</ARGS>
<USAGE>
	
</USAGE>
********************************************************************/

istr_app = astr_app
return c#return.Success
end function

public function integer of_init (ref s_tcoutestimate astr_est);/********************************************************************
   of_init
	
<DESC>   
	for each estimate structure that is completed, this loads the 
	it from the control object	into an instance variable inside 
	this object.
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_est:  Newly prepared estimate structure 
</ARGS>
<USAGE>
	must be called if running directly from the n_axestimatecontrol object
</USAGE>
********************************************************************/

istr_tcout = astr_est
return c#return.Success
end function

public function boolean of_is_valid_voyagenr (string as_voyagenr);/********************************************************************
   of_is_valid_voyagenr( /*string as_voyagenr */)
	
<DESC>   
	standard function to validate if voyage number is within constraints
	this is dependent on loaded data logic from the of_validate_voyage_number()
	function.
</DESC>
<RETURN>
	Boolean:
		<LI> true, Success
		<LI> false, Failure
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_voyagenr: 	
</ARGS>
<USAGE>
	

</USAGE>
********************************************************************/

if left(as_voyagenr,3) <> is_EXCEPTIONPREFIX then
	return TRUE
end if
return FALSE
end function

private function integer _add_to_past_voyages (string as_voyagenr);/********************************************************************
   _add_to_past_voyages

<DESC>   
	Controls past voyages used for this vessel.  Resolves issue where a
	vessel maybe on 2 TC Out contracts in 1 year
</DESC>
<RETURN>
	Integer:
		<LI> 0, not found
		<LI> 1, found
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_voyagenr: Current Voyage Number
</ARGS>
<USAGE>
	build a list of voyages a tc-out vessel may be on in one year
</USAGE>
********************************************************************/

integer li_voyageindex, li_found = -1

if left(as_voyagenr,len(is_exceptionprefix)) = is_exceptionprefix then return c#return.NoAction

for li_voyageindex = 1 to upperbound(is_pastvoyages)
		if is_pastvoyages[li_voyageindex] = as_voyagenr then
			li_found = 1
		end if
next	
if (li_found = -1) then
	is_pastvoyages[upperbound(is_pastvoyages)+1] = as_voyagenr
end if	

return li_found
end function

private function integer _set_hire (ref s_tcoutperiod astr_hire, integer ai_monthlyrate);/********************************************************************
  _set_hire()
  
<DESC>   
	function to calculate hire period total amount.  It takes into account if rate type is daily or monthly
	and also deducts estimated off service days from actual days included in period.
	when rate type is monthy the first days found at start of contract are the ones deducted.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	astr_hire : structure used to keep the period data regarding the hire
	ai_monthlyrate: either 0=daily, 1=monthly
</ARGS>
<USAGE>
	Loads the main detail for the period structure
	
	called once for each period inside a contract from of_append_tcout_period()
</USAGE>
********************************************************************/

integer					li_startmonth, li_endmonth, li_monthindex, li_realmonthindex
decimal{8}				ld_rateperday, ld_expecteddaysinmonth, ld_actualdaysinmonth, ld_offdaysremainder

datetime					ldtm_tempstart, ldtm_tempend
mt_n_datefunctions	lnv_datefunc

ld_offdaysremainder = astr_hire.d_offhire_days

astr_hire.d_offhire_amount = 0.0

if ai_monthlyrate = 1 then
	
	/* build monthly calc */
	li_startmonth = month(date(astr_hire.dtm_start))
	li_endmonth = month(date(astr_hire.dtm_end))
	if li_startmonth > li_endmonth then 
		li_endmonth += 12
	end if	
	
	/* loop through new months that a period may contain */
	for li_monthindex = li_startmonth to li_endmonth
		ld_expecteddaysinmonth = dec(lnv_datefunc.of_lastdayofmonth( date("1/" + string(mod(li_monthindex,12)) + "/" + string(year(date(astr_hire.dtm_start))))))
		if (li_monthindex = li_startmonth or li_monthindex = li_endmonth) or ld_offdaysremainder > 0.0 then

			ld_rateperday = astr_hire.d_rate / ld_expecteddaysinmonth
			if li_monthindex = li_startmonth then
				ldtm_tempstart = astr_hire.dtm_start	
			else
				/* has to be the final month in the period */
				if mod(li_monthindex,12) <> 0 then
					li_realmonthindex = mod(li_monthindex,12)
				else
					li_realmonthindex = 12
				end if
				ldtm_tempstart = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_end))))
			end if	
			
			if li_monthindex = li_endmonth then	/* this can also be applied if TC starts/finishes in same month */	
				ldtm_tempend = astr_hire.dtm_end
			else
				/* can only be the first month in the period */
				if mod(li_monthindex+1,12) <> 0 then
					li_realmonthindex = mod(li_monthindex+1,12)
				else
					li_realmonthindex = 12
				end if
				if li_realmonthindex<li_monthindex+1 then
					ldtm_tempend = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_end))))								
				else
					ldtm_tempend = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_start))))													
				end if	
			end if	
			ld_actualdaysinmonth = lnv_datefunc.of_getdaysbetween( ldtm_tempstart, ldtm_tempend )
			
			/* add possibility to remove estoffdays */
			if ld_offdaysremainder > 0.0 then
				if ld_offdaysremainder < ld_actualdaysinmonth then
					astr_hire.d_offhire_amount += (ld_offdaysremainder * ld_rateperday)
					ld_actualdaysinmonth -= ld_offdaysremainder
					ld_offdaysremainder = 0.0
				else
					astr_hire.d_offhire_amount += (ld_actualdaysinmonth * ld_rateperday)
					ld_offdaysremainder -= ld_actualdaysinmonth
					ld_actualdaysinmonth = 0
				end if
			end if
			
			if ld_actualdaysinmonth>0 then
				astr_hire.d_amount += ld_actualdaysinmonth * ld_rateperday
			end if
			astr_hire.d_days += ld_actualdaysinmonth
			
		else
			astr_hire.d_amount += astr_hire.d_rate
			astr_hire.d_days += ld_expecteddaysinmonth
		end if
	next
else
	astr_hire.d_days = (f_datetime2long(astr_hire.dtm_end) - f_datetime2long(astr_hire.dtm_start)) / 86400
	/* next subtract estoffdays */
	astr_hire.d_days -= ld_offdaysremainder
	if astr_hire.d_days > 0 then
		astr_hire.d_amount = astr_hire.d_days * astr_hire.d_rate 
		astr_hire.d_offhire_amount = ld_offdaysremainder * astr_hire.d_rate
	end if
	ld_offdaysremainder = 0.0
end if

/* validate any issues regarding the estimated off service days calculation */
if astr_hire.d_days<0 or ld_offdaysremainder>0 then
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_do_transaction ();/********************************************************************
of_do_transaction()
	
<DESC>   
	each time structure is completed	generate the tc-out estimate transaction.
	also calls function to output detail to text log file
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	n/a 
</ARGS>
<USAGE>
	using instance structure of tc_out estimate pass to transaction
	process
</USAGE>
********************************************************************/


integer 								li_transactionstatus
u_transaction_estimate_tcout 	lnv_trans
long ll_errorindex


if of_get_voyage_number(istr_tcout.str_hire)="" then
	ll_errorindex = upperbound(istr_errors) + 1
	istr_errors[ll_errorindex].s_voyagenr = "empty"
	istr_errors[ll_errorindex].s_vesselrefnr = left(istr_tcout.s_key,3)
	istr_errors[ll_errorindex].l_contractnr = istr_tcout.l_contractid
	istr_errors[ll_errorindex].s_notes = "Estimate could not assign a voyage to the contract."
elseif this.of_get_amount_sum(istr_tcout.str_hire)=0.0 then
	ll_errorindex = upperbound(istr_errors) + 1
	istr_errors[ll_errorindex].s_voyagenr = of_get_voyage_number(istr_tcout.str_hire)
	istr_errors[ll_errorindex].s_vesselrefnr = left(istr_tcout.s_key,3)
	istr_errors[ll_errorindex].l_contractnr = istr_tcout.l_contractid
	istr_errors[ll_errorindex].s_notes = "No transaction generated for this estimate because freight amount is zero."
end if	

/* now generate transaction - do this inside n_esttcout object */
lnv_trans = create u_transaction_estimate_tcout
li_transactionstatus = lnv_trans.of_generate_transaction(istr_tcout)
destroy lnv_trans

of_writeoutdebug()

return li_transactionstatus
end function

public function s_tcoutestimate of_create_tcout_contract (string as_key, integer ai_vesselnr, string as_typecode, datetime adtm_cerpstart, long al_contractid, integer ai_monthlyrate, datetime adtm_start, string as_chartnomaccnr, string as_tcownernomaccnr, string as_currcode, integer ai_bareboat, integer ai_inpool, integer ai_localtime, decimal ad_addrcomm);
/********************************************************************
of_create_tcout_contract()
	
<DESC>   
	for each contract required this function clears the tc-out structure	
	and loads from parameters passed in		
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_key					: 	consists of vessel nr, voyage nr and contract
	ai_vesselnr				:	vessel number
	as_typecode				:	always 'T' for tc-out contract
	adtm_cerpstart			:	C/P start date
	al_contractid			:	TC contract id
	ai_monthlyrate			:	1=monthly rate, 0=daily rate
	adtm_start				:	Voyage start date (voyage end date is calculated on period level)
	as_chartnomaccnr		:	charterer on contract's nom account number
	as_tcownernomaccnr	:	tc owner on contract's nom account number
	as_currcode				:	currency code (most likely USD)
	ai_bareboat				:	1 = bare boat
	ai_inpool				:	1 = in pool
	ai_localtime			:	1 = local time, 0=UTC
</ARGS>
<USAGE>
	Called each time a new contract number is found.
</USAGE>
********************************************************************/

s_tcoutestimate lstr_tc

	lstr_tc.s_key = as_key
	lstr_tc.i_vesselnr = ai_vesselnr
	lstr_tc.s_typecode  = as_typecode
	lstr_tc.dtm_cerpstart  = adtm_cerpstart
	lstr_tc.l_contractid = al_contractid
	lstr_tc.i_monthlyrate = ai_monthlyrate
	lstr_tc.dtm_start = adtm_start
	lstr_tc.s_chartnomaccnr = as_chartnomaccnr
	lstr_tc.s_tcownernomaccnr = as_tcownernomaccnr
	lstr_tc.s_currcode = as_currcode
	lstr_tc.i_bareboat = ai_bareboat
	lstr_tc.i_inpool = ai_inpool
	lstr_tc.i_localtime = ai_localtime
	lstr_tc.s_activityperiod = istr_app.s_periodref
	lstr_tc.d_addresscomm = ad_addrcomm
	_set_contract_expense_rates(lstr_tc)
	_set_broker_commissions(lstr_tc)
	

return lstr_tc
end function

private function integer _remove_addrcomm (ref decimal ad_amount, decimal ad_addrcomm_pc);/********************************************************************
   _remove_addrcomm( /*ref decimal ad_amount*/, /*decimal ad_addrcomm_pc */)
	
<DESC>   
	obtains the address commission amount and subtracts from amount	
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	private
</ACCESS>
<ARGS>   
	ad_amount: 			<reference> value modified
	ad_addrcomm_pc:	<value> address commission pecentage
</ARGS>
<USAGE>
	normally called after hire has been loaded
	
	called once for each period inside a contract from of_append_tcout_period()
</USAGE>
********************************************************************/


decimal {8} ld_addrcomm

ld_addrcomm = (ad_amount/100) * ad_addrcomm_pc
ad_amount -= ld_addrcomm

return c#return.Success

end function

private function decimal _get_contract_expense (s_tcoutsub astr_exp, s_tcoutperiod astr_hire);/********************************************************************
   _get_contract_expense( /*s_tcoutsub astr_exp*/, /*s_tcoutperiod astr_hire */)
	
<DESC>   
	using contract expenses structure obtain expense amount for this period
</DESC>
<RETURN>
	Decimal:
		<LI> total contract expense amount for selected period
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	astr_exp: selected expense in structure
	astr_hire: current hire detail.
</ARGS>
<USAGE>
	Similar to the _get_hire() function, 2 options on calculating the 
	amount.  Either daily rate or monthly.  Monthly rate is more complex
	
	must be called before broker commission calculation for each existing 
	period from of_append_tcout_period().
</USAGE>
********************************************************************/


decimal{4} 				ld_offdaysremainder, ld_expecteddaysinmonth, ld_rateperday, ld_retval, ld_actualdaysinmonth, li_realmonthindex
integer					li_startmonth, li_endmonth, li_monthindex
datetime					ldtm_tempstart, ldtm_tempend
mt_n_datefunctions	lnv_datefunc

ld_retval = 0.0
ld_offdaysremainder = 0.0
if astr_exp.i_offservice=1 then ld_offdaysremainder = astr_hire.d_offhire_days


if astr_exp.i_ratetype = 0 then
	/* daily */
	if astr_hire.d_days - ld_offdaysremainder > 0.0 then
		ld_retval = astr_exp.d_amount * (astr_hire.d_days - ld_offdaysremainder)
	end if
else	
	/* monthly */
	li_startmonth = month(date(astr_hire.dtm_start))
	li_endmonth = month(date(astr_hire.dtm_end))
	if li_startmonth > li_endmonth then 
		li_endmonth += 12
	end if	

	for li_monthindex = li_startmonth to li_endmonth
		ld_expecteddaysinmonth = dec(lnv_datefunc.of_lastdayofmonth( date("1/" + string(mod(li_monthindex,12)) + "/" + string(year(date(astr_hire.dtm_start))))))
		if li_monthindex = li_startmonth or li_monthindex = li_endmonth then
			ld_rateperday = astr_exp.d_amount / ld_expecteddaysinmonth
			
			if li_monthindex = li_startmonth then
				ldtm_tempstart = astr_hire.dtm_start	
			else
				
				if mod(li_monthindex,12) <> 0 then
					li_realmonthindex = mod(li_monthindex,12)
				else
					li_realmonthindex = 12
				end if
				
				/* has to be the last month */
				ldtm_tempstart = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_end))))
			end if	
			
			if li_monthindex = li_endmonth then	/* this can also be applied if TC starts/finishes in same month */	
				ldtm_tempend = astr_hire.dtm_end
			else
				/* can only be the first month */
				if mod(li_monthindex+1,12) <> 0 then
					li_realmonthindex = mod(li_monthindex+1,12)
				else
					li_realmonthindex = 12
				end if
				
				if li_realmonthindex<li_monthindex+1 then
					ldtm_tempend = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_end))))								
				else
					ldtm_tempend = datetime("1/" + string(li_realmonthindex)+"/"+string(year(date(astr_hire.dtm_start))))													
				end if	
			end if	
			ld_actualdaysinmonth = lnv_datefunc.of_getdaysbetween( ldtm_tempstart, ldtm_tempend )
			
			if ld_offdaysremainder > 0.0 then
				if ld_offdaysremainder < ld_actualdaysinmonth then
					ld_actualdaysinmonth -= ld_offdaysremainder
					ld_offdaysremainder = 0.0
				else
					ld_offdaysremainder -= ld_actualdaysinmonth
					ld_actualdaysinmonth = 0.0
				end if
			end if
			
			if ld_actualdaysinmonth>0 then
				ld_retval += (ld_actualdaysinmonth * ld_rateperday)
			end if
			
		else
			ld_retval += astr_exp.d_amount
		end if
	next
end if


return ld_retval
end function

private function integer _set_broker_commissions (ref s_tcoutestimate astr_est);/********************************************************************
  _set_broker_commissions( /*ref s_tcoutestimate astr_est */)
	
<DESC>   
	loads the broker commissions sub structure if any exist
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	astr_est: full estimated structure
</ARGS>
<USAGE>
	loads the structure that then is used throughout process to locate
	broker details when needed

	called one time per contract from function of_create_tcout_contract()

</USAGE>
********************************************************************/


mt_n_datastore		lds_brokercomm
long ll_row, ll_index

/* obtain broker rates */
lds_brokercomm = create mt_n_datastore
lds_brokercomm.dataobject = "d_sq_gr_tcoutbrokercomm"
lds_brokercomm.settransobject( SQLCA )

if lds_brokercomm.retrieve(astr_est.l_contractid)>0 then
	/* identify if income or expense */
	ll_index=0
	for ll_row = 1 to lds_brokercomm.rowcount()
		if lds_brokercomm.getitemdecimal(ll_row,"amount") > 0.0 then
			ll_index ++
			astr_est.str_brokercomm[ll_index].d_amount = lds_brokercomm.getitemdecimal(ll_row,"amount")
			astr_est.str_brokercomm[ll_index].i_ratetype = lds_brokercomm.getitemnumber(ll_row,"amount_per_day_or_percent")
			astr_est.str_brokercomm[ll_index].i_flag = lds_brokercomm.getitemnumber(ll_row,"primary_broker")
			astr_est.str_brokercomm[ll_index].l_id = lds_brokercomm.getitemnumber(ll_row,"id")
		end if
	next	
end if

destroy lds_brokercomm

return c#return.Success
end function

private function integer _set_contract_expense_rates (ref s_tcoutestimate astr_est);/********************************************************************
  _set_contract_expense_rates( /*ref s_tcoutestimate astr_est */)
	
<DESC>   
	loads the contract expenses sub structure if any exist
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	astr_est: full estimated structure
</ARGS>
<USAGE>
	loads the structure that then is used throughout process to locate
	contract expenses when needed
	
	called one time per contract from function of_create_tcout_contract()
</USAGE>
********************************************************************/

mt_n_datastore		lds_contractexp
long ll_row

/* obtain contract expense rates */
lds_contractexp = create mt_n_datastore
lds_contractexp.dataobject = "d_sq_gr_tcoutcontractexp"
lds_contractexp.settransobject( SQLCA )

if lds_contractexp.retrieve(astr_est.l_contractid)>0 then
	/* identify if income or expense */
	for ll_row = 1 to lds_contractexp.rowcount()
		astr_est.str_contractexp[ll_row].d_amount = lds_contractexp.getitemdecimal(ll_row,"amount")
		astr_est.str_contractexp[ll_row].i_ratetype = lds_contractexp.getitemnumber(ll_row,"monthly")
		astr_est.str_contractexp[ll_row].i_offservice = lds_contractexp.getitemnumber(ll_row,"tc_off_service_dependent")
	next	
end if

destroy lds_contractexp

return c#return.Success
end function

public function decimal of_get_amount_sum (s_tcoutperiod astr_periods[]);return of_get_amount_sum(astr_periods, "totalfreight")

end function

public function decimal of_get_amount_sum (s_tcoutperiod astr_periods[], string as_type);/********************************************************************
   of_get_amount_sum( /*s_tcoutperiod astr_periods[]*/, /*string as_type */)
	
<DESC>   
	for all valid voyages in loaded hire periods, total up the requested amount
</DESC>
<RETURN>
	Decimal:
		<LI> the total amount
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_periods: 	array of all periods
	as_type: 		amount type we want to get the total of.
						<"freight", "totalfreight", "contractexpense", "miscincome",
						"miscexpenses", "brokercomm", "offhire">
</ARGS>
<USAGE>
	this is overloaded.  default as_type is "totalfreight"
</USAGE>
********************************************************************/


integer li_periodindex
decimal{8} ld_returnamount = 0.0

for li_periodindex = 1 to upperbound(astr_periods)
	if of_is_valid_voyagenr(astr_periods[li_periodindex].s_voyagenr) then
		choose case lower(as_type)
			case "freight" /* not including estimated off-service days */	
				ld_returnamount += astr_periods[li_periodindex].d_amount
			case "totalfreight"
				/* default type */
				ld_returnamount += (astr_periods[li_periodindex].d_amount + astr_periods[li_periodindex].d_offhire_amount)
			case "contractexpense"
				ld_returnamount += astr_periods[li_periodindex].d_contractexp_amount
			case "miscincome"
				ld_returnamount += astr_periods[li_periodindex].d_miscinc_amount	
			case "miscexpenses"
				ld_returnamount += astr_periods[li_periodindex].d_miscexp_amount
			case "brokercomm"
				ld_returnamount += astr_periods[li_periodindex].d_estbrokercomm_amount
			case "offhire"
				ld_returnamount += astr_periods[li_periodindex].d_offhire_amount
		end choose		

	end if
next	
	
return ld_returnamount
end function

public function decimal of_get_days_sum (s_tcoutperiod astr_periods[], string as_type);integer li_periodindex
decimal{8} ld_returndays = 0.0

for li_periodindex = 1 to upperbound(astr_periods)
	if of_is_valid_voyagenr(astr_periods[li_periodindex].s_voyagenr) then
		choose case as_type
			case "totaldays"		
				ld_returndays += astr_periods[li_periodindex].d_days + astr_periods[li_periodindex].d_offhire_days
			case "voyagedays"	
				ld_returndays += astr_periods[li_periodindex].d_days
			case "offdays"	
				ld_returndays += astr_periods[li_periodindex].d_offhire_days
		end choose
	end if
next 	

return ld_returndays
end function

public function datetime of_get_voyage_start (s_tcoutperiod astr_periods[]);/********************************************************************
   of_get_voyage_end( /*s_tcoutperiod astr_periods[] */)
	
<DESC>   
	obtains the first valid voyage start date it can find
</DESC>
<RETURN>
	DateTime:
		<LI> voyage start date found. If non located, returns 01/01/01 00:00
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_periods: complete hire period structure array
</ARGS>
<USAGE>
	Called from the transaction object.
</USAGE>
********************************************************************/


integer li_periodindex
datetime ldtm_voyagestart

for li_periodindex = 1 to upperbound(astr_periods)
	if of_is_valid_voyagenr(astr_periods[li_periodindex].s_voyagenr) then
		return astr_periods[li_periodindex].dtm_start
	end if
next 	

return ldtm_voyagestart
end function

public function datetime of_get_voyage_end (s_tcoutperiod astr_periods[]);/********************************************************************
   of_get_voyage_end( /*s_tcoutperiod astr_periods[] */)
	
<DESC>   
	obtains the last valid voyage end date it can find
</DESC>
<RETURN>
	DateTime:
		<LI> voyage end date found. If non located, returns 01/01/01 00:00
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_periods: complete hire period structure array
</ARGS>
<USAGE>
	Called from the transaction object.
</USAGE>
********************************************************************/

integer li_periodindex
datetime ldtm_voyageend

for li_periodindex = upperbound(astr_periods) to 1 step -1 
	 if of_is_valid_voyagenr(astr_periods[li_periodindex].s_voyagenr) then
		return astr_periods[li_periodindex].dtm_end
	end if
next 	

return ldtm_voyageend
end function

public function string of_get_voyage_number (s_tcoutperiod astr_periods[]);/********************************************************************
   of_get_voyage_number( /*s_tcoutperiod astr_periods[] */)
	
<DESC>   
	obtains the first valid voyage number it can find
</DESC>
<RETURN>
	String:
		<LI> voyage number found. If non located, returns ""
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_periods: complete hire period structure array
</ARGS>
<USAGE>
	Called from the transaction object.
</USAGE>
********************************************************************/


integer li_periodindex

for li_periodindex = 1 to upperbound(astr_periods)
	if of_is_valid_voyagenr(astr_periods[li_periodindex].s_voyagenr) then
		return astr_periods[li_periodindex].s_voyagenr
	end if
next 	

return ""

end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_esttcout
	
	<OBJECT>
		Ancestor object is n_estimate, this object has been built after
		voyage estimates.  
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
   <USAGE>
		Used to generate TC-OUT estimations for period year
	</USAGE>
  	<ALSO>
		
	s_tcoutestimate
	
		str_hire []
			
		str_contractexp []
		
		str_brokercomm []
		
	
	
	</ALSO>
   Date   		Ref    				Author   	Comments
  	21/11/12 	CR2775      		AGL027		First Version
	21/02/13		CR2775				AGL027		Fix issue with selecting Voyages.   
	24/07/15		CR3705				CCY018		same logic as it is for miscellaneous expenses in VAS.
	19/10/15		CR3972				AGL027		historic bug found while testing CR3972
	10/11/15		CR3972				CCY018		Fixed a historic bug.
	03-08-2017	CR4629				XSZ004		Add first load port arrival date to AX voyage estimates
********************************************************************/
end subroutine

public function integer of_append_tcout_period (ref s_tcoutestimate astr_est, datetime adtm_start, datetime adtm_end, long al_id, decimal ad_rate, decimal ad_offhire_days, decimal ad_estoffhire_days, string as_voyagenr);/********************************************************************
of_append_tcout_period()
	
<DESC>   
	creates new element in hire period sub-array & calculates hire amount
	copies detail into miscexpenses & miscincome sub-arrays and processes them
</DESC>
<RETURN>
	Long:
		<LI> 1 - Success
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_est	:	complete estimate structure
	adtm_start		:	periode start date
	adtm_end			:	periode end date
	al_id				:	period id
	ad_rate			:	period rate
	ad_estoffdays	:	estimated off service days
	as_voyagenr		:	voyage number
</ARGS>
<USAGE>
	Called on every row
</USAGE>
********************************************************************/


s_tcoutperiod	lstr_period
string ls_voyagenr=""
integer li_index

long ll_periodindex

	/* append to hire structure for this period */
	lstr_period.dtm_start = adtm_start
	lstr_period.dtm_end = adtm_end
	lstr_period.l_periodid = al_id
	lstr_period.d_rate =  ad_rate
	lstr_period.d_offhire_days = ad_offhire_days
	lstr_period.d_estoffhire_days = ad_estoffhire_days
	lstr_period.s_voyagenr =  as_voyagenr
	lstr_period.d_offhire_amount = 0.0

	ll_periodindex = upperbound(astr_est.str_hire) + 1
	astr_est.str_hire[ll_periodindex] = lstr_period



	/* load amounts for hire & misc inc/exp */
	_set_hire(astr_est.str_hire[ll_periodindex], astr_est.i_monthlyrate)
	
	/* subtract address comm from freight amount */
	_remove_addrcomm(astr_est.str_hire[ll_periodindex].d_amount, astr_est.d_addresscomm)
	/* subtract address comm from off service amount */
	_remove_addrcomm(astr_est.str_hire[ll_periodindex].d_offhire_amount, astr_est.d_addresscomm)
	
	_set_est_inc_exp(astr_est, astr_est.str_hire[ll_periodindex])
	
	if of_is_valid_voyagenr(as_voyagenr) then
		/* load sum of the contract expenses */
		for li_index = 1 to upperbound(astr_est.str_contractexp)		
			astr_est.str_hire[ll_periodindex].d_contractexp_amount += _get_contract_expense(astr_est.str_contractexp[li_index], astr_est.str_hire[ll_periodindex])	
		next
		/* load also sum of the estimated broker commissions for each period */		
		for li_index = 1 to upperbound(astr_est.str_brokercomm)		
			astr_est.str_hire[ll_periodindex].d_estbrokercomm_amount += _get_est_broker_commission(astr_est.str_brokercomm[li_index], astr_est.str_hire[ll_periodindex])	
		next
		/* obtain actual borker commission amount for contracts year */
		astr_est.d_actbrokercomm_amount =  _get_act_broker_commission(astr_est.l_contractid, astr_est.i_yyyy)
	end if	

return c#return.Success
end function

private function decimal _get_est_broker_commission (s_tcoutsub astr_broker, s_tcoutperiod astr_hire);/********************************************************************
  _get_broker_commission( /*s_tcoutsub astr_broker*/, /*s_tcoutperiod astr_hire */)
	
<DESC>   
	astr_hire.d_days + astr_hire.d_estoffdays = total days
	astr_hire.d_amount + astr_hire.d_estoffhire_amount = total hire amount
</DESC>
<RETURN>
	Decimal:
		<LI> Broker commission value
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	astr_broker	- selected element with broker detail
	astr_hire	- hire structure
</ARGS>
<USAGE>
	Broker Commission is calculated on hire amount already calculated (excluding off service amounts)
	It is calculated & stored inside each period structure
	
	Called once for each period inside a contract from of_append_tcout_period()
	
	It includes deduction of income (misc income and contract expenses amounts)
</USAGE>
********************************************************************/

decimal{8} 				ld_retval, ld_hirenetto, ld_incomenetto

ld_retval = 0.0
ld_hirenetto = astr_hire.d_amount 
ld_incomenetto = astr_hire.d_contractexp_amount + astr_hire.d_miscinc_amount	

ld_retval = (ld_hirenetto - ld_incomenetto) * (astr_broker.d_amount/100)


return ld_retval
end function

private function decimal _get_act_broker_commission (long al_contractid, integer ai_voyageyear);/********************************************************************
   _get_act_broker_commission
	
<DESC>   
	use stored procedure to obtain actual broker commission in local currency
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	al_contractid: contract id to identify commission
	as_voyagenr: used to identify voyage number on commission
</ARGS>
<USAGE>
	

</USAGE>
********************************************************************/
decimal {2} ld_returnvalue

SELECT dbo.FN_GET_BROKER_COMM_ACT_ON_TC_OUT(:al_contractid, 2012, 0)
INTO :ld_returnvalue 
FROM SYSTEM_OPTION
USING sqlca;

return ld_returnvalue
end function

public function decimal of_get_broker_comm (s_tcoutestimate astr_est);decimal{2} ld_returnvalue, ld_est


ld_est = of_get_amount_sum(istr_tcout.str_hire,"brokercomm")
ld_returnvalue = astr_est.d_actbrokercomm_amount

if ld_est>ld_returnvalue then
	ld_returnvalue = ld_est
end if

return ld_returnvalue
end function

public function string of_validate_voyage_number (integer ai_vesselnr, string as_voyagenr, datetime adtm_periodstart);/********************************************************************
   of_validate_voyage_number
	
<DESC>   
	validate voyage number passed and return voyage number we want to send onto AX
</DESC>
<RETURN>
	String:
		<LI> 				voyage number
		<LI> "EXC01" 	no voyage number found in normal link between contract period and POC and no detail of voyage on period
		<LI> "EXC02" 	can not locate voyage number in current estimate period
		<LI> "EXC03" 	can not locate voyage number in current tc-out period
		<LI> "EXC04" 	missing exception
		<LI> "EXC05" 	voyage found sits in following year. 
		<LI> "EXC06" 	a previous voyage exists, but no voyage number found for this contract
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	ai_vesselnr			: vessel number
	as_voyagenr			: voyage number from datastore
	adtm_periodstart	: used to event construct period year value
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

integer li_estperiodyear, li_voyageyear, li_tcperiodyear
string ls_estperiodyear, ls_voyagenr, ls_tcperiodyear, ls_previousvoyage
integer li_test, li_voyageindex

ls_estperiodyear = right(left(istr_app.s_periodref,4),2)
ls_tcperiodyear =  right(left(string(year(date(adtm_periodstart))),4),2)

li_estperiodyear = integer(ls_estperiodyear)
li_tcperiodyear = integer(ls_tcperiodyear)
li_voyageyear = integer(left(as_voyagenr,2))


if as_voyagenr='' or isnull(as_voyagenr) then
	/* no voyage number so we need to send 00000 back */

	if upperbound(is_pastvoyages) > 0 then
		
		ls_previousvoyage = is_pastvoyages[upperbound(is_pastvoyages)]
				
		SELECT top 1 VOYAGE_NR 
		INTO :ls_voyagenr
		FROM PROCEED 
		WHERE VESSEL_NR = :ai_vesselnr AND LEFT(VOYAGE_NR,5) > :ls_previousvoyage AND LEN(LTRIM(RTRIM(VOYAGE_NR)))>5 AND LEFT(LTRIM(VOYAGE_NR),2)=:ls_tcperiodyear
		ORDER BY PROC_DATE ASC;
		
		if ls_voyagenr='' or isnull(ls_voyagenr) then
			return is_EXCEPTIONPREFIX + "06"			
		else
			_add_to_past_voyages(as_voyagenr)
			return left(trim(ls_voyagenr),5)
		end if
	else
		
		
		if datetime(date("01/01/"+ls_tcperiodyear)) = adtm_periodstart then
			SELECT top 1 VOYAGE_NR 
			INTO :ls_voyagenr
			FROM PROCEED 
			WHERE VESSEL_NR = :ai_vesselnr AND LEN(LTRIM(RTRIM(VOYAGE_NR)))>5 AND LEFT(LTRIM(VOYAGE_NR),2)=:ls_tcperiodyear
			ORDER BY PROC_DATE ASC;
		end if	
		
		if ls_voyagenr='' or isnull(ls_voyagenr) then
			return is_EXCEPTIONPREFIX + "01"			
		else
			_add_to_past_voyages(as_voyagenr)
			return left(trim(ls_voyagenr),5)
		end if
	
	end if
else	
	ls_estperiodyear = right(left(istr_app.s_periodref,4),2)
	
	if istr_app.b_client and (ls_estperiodyear = "" or isnull(ls_estperiodyear)) then
		ls_estperiodyear = left(as_voyagenr, 2)
	end if
	
	ls_tcperiodyear =  right(left(string(year(date(adtm_periodstart))),4),2)

	li_estperiodyear = integer(ls_estperiodyear)
	li_tcperiodyear = integer(ls_tcperiodyear)
	li_voyageyear = integer(left(as_voyagenr,2))
	
	if li_estperiodyear = li_tcperiodyear and li_estperiodyear = li_voyageyear then
		_add_to_past_voyages(as_voyagenr)
		return as_voyagenr
	else	
		
		if li_tcperiodyear >= li_estperiodyear then
								
			/* check if voyage exists in proceeding*/
			setnull(ls_voyagenr)	
			SELECT top 1 VOYAGE_NR 
			INTO :ls_voyagenr
			FROM PROCEED 
			WHERE VESSEL_NR = :ai_vesselnr AND LEFT(LTRIM(VOYAGE_NR),2)=:ls_tcperiodyear AND LEN(RTRIM(VOYAGE_NR))>5
			ORDER BY PROC_DATE ASC;
				
		elseif li_estperiodyear > li_voyageyear then
			return is_EXCEPTIONPREFIX + "05"
		else
			return is_EXCEPTIONPREFIX + "03"
		end if
		
		if ls_voyagenr='' or isnull(ls_voyagenr) then
			return is_EXCEPTIONPREFIX + "02"
		else
			_add_to_past_voyages(left(trim(ls_voyagenr),5))
			return left(trim(ls_voyagenr),5)
		end if	
	
	end if	
	
end if

return is_EXCEPTIONPREFIX + "04"
end function

public function datetime of_get_tcenddate (integer ai_year, long al_contract_id);/********************************************************************
   of_get_tcenddate
   <DESC></DESC>
   <RETURN>	datetime</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_year
		al_contract_id
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

datetime ldt_end_date

SELECT MAX(P.PERIODE_END) 
INTO :ldt_end_date
FROM   NTC_TC_PERIOD P, NTC_TC_CONTRACT C, NTC_TC_CONTRACT A
WHERE   P.CONTRACT_ID = C.CONTRACT_ID
AND C.VESSEL_NR = A.VESSEL_NR
AND C.CHART_NR  = A.CHART_NR
AND C.TC_HIRE_CP_DATE = A.TC_HIRE_CP_DATE
AND datepart(year,P.PERIODE_START) =  :ai_year
AND A.CONTRACT_ID = :al_contract_id;

return ldt_end_date
end function

public function integer of_get_tcisnotfinished (integer ai_year, long al_contract_id);/********************************************************************
   of_get_tcisnotfinished
   <DESC></DESC>
   <RETURN>	integer
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_year
		al_contract_id
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

integer li_isnofinished

SELECT (CASE when COUNT(*) = 0 THEN 0 ELSE 1 END) 
INTO :li_isnofinished
FROM   NTC_TC_PERIOD P, NTC_TC_CONTRACT C, NTC_TC_CONTRACT A
WHERE   P.CONTRACT_ID = C.CONTRACT_ID 
AND C.VESSEL_NR = A.VESSEL_NR
AND C.CHART_NR  = A.CHART_NR
AND C.TC_HIRE_CP_DATE = A.TC_HIRE_CP_DATE
AND datepart(year, P.PERIODE_START) =  :ai_year
AND P.FINISHED = 0
AND A.CONTRACT_ID = :al_contract_id;

return li_isnofinished
end function

public function datetime of_get_tcstartdate (integer ai_year, long al_contract_id);/********************************************************************
   of_get_tcstartdate
   <DESC></DESC>
   <RETURN>	datetime
  </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_year
		al_contract_id
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

datetime ldt_start_time

SELECT MIN(P.PERIODE_START) 
INTO :ldt_start_time
FROM   NTC_TC_PERIOD P, NTC_TC_CONTRACT C, NTC_TC_CONTRACT A
WHERE   P.CONTRACT_ID = C.CONTRACT_ID 
AND C.VESSEL_NR = A.VESSEL_NR
AND C.CHART_NR  = A.CHART_NR
AND C.TC_HIRE_CP_DATE = A.TC_HIRE_CP_DATE
AND datepart(year, P.PERIODE_START) = :ai_year
AND A.CONTRACT_ID  = :al_contract_id;

return ldt_start_time
end function

public function string of_get_tcdisb_act_est_flag (integer ai_vessel_nr, long al_contract_id, string as_voyage_nr, integer ai_year, datetime adt_start_date, datetime adt_end_date, integer ai_isnofinished);/********************************************************************
   of_get_tcdisb_act_est_flag
   <DESC>refer to FN_GET_DISB_EST_ACT_ON_TC_OUT</DESC>
   <RETURN>	string</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		al_contract_id
		as_voyage_nr
		ai_year
		adt_start_date
		adt_end_date
		ai_isnofinished
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_disb_est, ld_disb_act
string ls_act = "ACT", ls_est = "EST"

SELECT dbo.FN_GET_DISB_EST_ON_TC_OUT( :al_contract_id, :ai_year)
INTO :ld_disb_est 
FROM SYSTEM_OPTION;

SELECT dbo.FN_GET_DISB_ACT_ON_TC_OUT(:ai_vessel_nr, :al_contract_id, :as_voyage_nr, :adt_start_date, :adt_end_date)
INTO :ld_disb_act
FROM SYSTEM_OPTION;

if ai_isnofinished > 0 and ld_disb_est > ld_disb_act then
	return ls_est
else
	return ls_act
end if

end function

public function string of_get_tcnon_port_act_est_flag (long al_contract_id, datetime adt_start_date, datetime adt_end_date, integer ai_year, integer ai_isnofinished);
/********************************************************************
   of_get_tcnon_port_act_est_flag
   <DESC>refer to FN_GET_NON_PORT_EXP_EST_ACT</DESC>
   <RETURN>	string</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_contract_id
		adt_start_date
		adt_end_date
		ai_year
		ai_isnofinished
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_non_port_exp_est, ld_non_port_exp_act
decimal{6} ld_exchange_rate
string ls_act = "ACT", ls_est = 'EST'

SELECT dbo.FN_GET_EXCHANGE_RATE_FROM_PAYMENT_ON_TC_OUT(:al_contract_id, :ai_year)
INTO :ld_exchange_rate
FROM SYSTEM_OPTION;

if isnull(ld_exchange_rate) then ld_exchange_rate = 0
if ld_exchange_rate = 0 then
	SELECT round(dbo.FN_GET_TCOUT_EXRATE(:al_contract_id), 6)
	INTO :ld_exchange_rate
	FROM SYSTEM_OPTION;
end if

SELECT dbo.FN_GET_NON_PORT_EXP_OR_INC_EST(0 ,:al_contract_id, :ai_year)
INTO :ld_non_port_exp_est
FROM SYSTEM_OPTION;

ld_non_port_exp_est = round(ld_non_port_exp_est * ld_exchange_rate / 100,2)

SELECT dbo.FN_GET_NON_PORT_EXP_OR_INC_ACT(0, :al_contract_id, :adt_start_date, :adt_end_date)
INTO :ld_non_port_exp_act
FROM SYSTEM_OPTION;

if ai_isnofinished > 0 and ld_non_port_exp_est > ld_non_port_exp_act then
	return ls_est
else
	return ls_act
end if

end function

public function decimal of_get_tcdisb_amount (integer ai_vessel_nr, long al_contract_id, s_tcoutperiod astr_period, datetime adt_voyage_start, datetime adt_voyage_end, string as_act_est);/********************************************************************
   of_get_tcdisb_amount
   <DESC>refer to	FN_GET_DISB_ACT_ON_TC_OUT,FN_GET_DISB_EST_ON_TC_OUT</DESC>
   <RETURN>	decimal</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		al_contract_id
		astr_period
		adt_voyage_start
		adt_voyage_end
		as_act_est
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_disb
integer li_out, li_inout, li_counter_tc_in

li_out = 0
li_inout = -1

if as_act_est = "ACT" then
	//Check the existence of TC IN
	SELECT dbo.FN_CHECK_EXISTENCE_OF_TC_IN(:ai_vessel_nr, :adt_voyage_start, :adt_voyage_end)
	into :li_counter_tc_in
	FROM SYSTEM_OPTION;
	
	if li_counter_tc_in > 0 then
		 li_out = -1
		 li_inout = 0    
	end if

	SELECT ROUND(SUM(CASE VOUCHERS.VOUCHER_SHOW_AS_INCOME WHEN 0 THEN DISB_EXPENSES.EXP_AMOUNT_USD ELSE 0 END), 2)   
	INTO :ld_disb
	FROM DISB_EXPENSES,   
              POC,   
              VOUCHERS,   
              VOYAGES,   
              AGENTS,   
              PORTS  
	WHERE (VOUCHERS.VOUCHER_NR = DISB_EXPENSES.VOUCHER_NR ) AND  
        (POC.VESSEL_NR = DISB_EXPENSES.VESSEL_NR ) AND  
        (POC.VOYAGE_NR = DISB_EXPENSES.VOYAGE_NR ) AND  
        (POC.PORT_CODE = DISB_EXPENSES.PORT_CODE ) AND  
        (POC.PCN = DISB_EXPENSES.PCN ) AND  
        (POC.VESSEL_NR = VOYAGES.VESSEL_NR ) AND  
        (POC.VOYAGE_NR = VOYAGES.VOYAGE_NR ) AND  
        (POC.PORT_CODE = PORTS.PORT_CODE ) AND  
        (DISB_EXPENSES.AGENT_NR = AGENTS.AGENT_NR ) AND  
        (POC.PORT_ARR_DT >= :astr_period.dtm_start) AND  
        (POC.PORT_ARR_DT < :astr_period.dtm_end ) AND  
        (POC.VESSEL_NR = :ai_vessel_nr) AND  
        (VOUCHERS.TCOUT_CA_OR_OA = :li_out OR VOUCHERS.TCINOUT_CA_OR_OA = :li_inout) AND  
	    ( VOUCHERS.VAS_REPORT = 1) AND
		( VOYAGES.VOYAGE_TYPE = 2 )
	GROUP BY POC.VESSEL_NR;
else//est
	SELECT ROUND(ISNULL(SUM(NTC_EST_INCOME_EXP.AMOUNT), 0 ), 2)
	INTO :ld_disb
	FROM NTC_TC_PERIOD, NTC_EST_INCOME_EXP  
	WHERE NTC_TC_PERIOD.TC_PERIODE_ID = NTC_EST_INCOME_EXP.TC_PERIODE_ID  
	AND	NTC_TC_PERIOD.CONTRACT_ID = :al_contract_id
	AND	NTC_TC_PERIOD.TC_PERIODE_ID = :astr_period.l_periodid
	AND	NTC_EST_INCOME_EXP.INCOME = 0 
	AND NTC_EST_INCOME_EXP.PORT_EXPENSE = 1;
end if

if isnull(ld_disb) then ld_disb = 0

return ld_disb
end function

private function integer _set_est_inc_exp (s_tcoutestimate astr_tcout, ref s_tcoutperiod astr_hire);mt_n_datastore		lds_estincexp
integer li_year, li_isnofinished
datetime ldt_voyage_start, ldt_voyage_end
string ls_nonport_flag, ls_disb_flag
decimal{2} ld_non_port_exp, ld_disb_exp, ld_bunker_loss, ld_misc_exp_est_act

/* obtain estimated misc. expenses/income */
lds_estincexp = create mt_n_datastore
lds_estincexp.dataobject = "d_tc_periode_est_income_expenses"
lds_estincexp.settransobject( SQLCA )

astr_hire.d_miscinc_amount = 0.0
astr_hire.d_miscexp_amount = 0.0

if lds_estincexp.retrieve(astr_hire.l_periodid)>0 then
	astr_hire.d_miscinc_amount = dec(lds_estincexp.object.sum_inc[1])
end if
destroy lds_estincexp

if of_is_valid_voyagenr(astr_hire.s_voyagenr) then
	if left(astr_hire.s_voyagenr, 1) = "9" then
		li_year = 1900 + integer(left(astr_hire.s_voyagenr, 2))
	else
		li_year = 2000 + integer(left(astr_hire.s_voyagenr, 2))
	end if
	
	ldt_voyage_start = of_get_tcstartdate(li_year, astr_tcout.l_contractid)
	ldt_voyage_end = of_get_tcenddate(li_year, astr_tcout.l_contractid)
	li_isnofinished = of_get_tcisnotfinished(li_year, astr_tcout.l_contractid)
	ls_nonport_flag = of_get_tcnon_port_act_est_flag(astr_tcout.l_contractid, ldt_voyage_start, ldt_voyage_end, li_year, li_isnofinished)
	ls_disb_flag = of_get_tcdisb_act_est_flag(astr_tcout.i_vesselnr, astr_tcout.l_contractid, astr_hire.s_voyagenr, li_year, ldt_voyage_start, ldt_voyage_end, li_isnofinished)
	
	ld_non_port_exp = of_get_tcnon_port_amount(astr_tcout.l_contractid, astr_hire, ls_nonport_flag, ldt_voyage_start)
	ld_disb_exp = of_get_tcdisb_amount(astr_tcout.i_vesselnr, astr_tcout.l_contractid, astr_hire, ldt_voyage_start, ldt_voyage_end, ls_disb_flag)
	ld_bunker_loss = of_get_bunker_loss_profit(astr_tcout.i_vesselnr, astr_hire.s_voyagenr, astr_hire.dtm_start, astr_hire.dtm_end)
	
	ld_misc_exp_est_act = ld_non_port_exp + ld_disb_exp
	if ld_bunker_loss < 0 then
		ld_misc_exp_est_act = ld_misc_exp_est_act + abs(ld_bunker_loss)
	end if
	
	astr_hire.d_miscexp_amount = ld_misc_exp_est_act
end if

return c#return.Success
end function

public function decimal of_get_bunker_loss_profit (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start_date, datetime adt_end_date);/********************************************************************
   of_get_bunker_loss_profit
   <DESC></DESC>
   <RETURN>	decimal</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		as_voyage_nr
		adt_start_date
		adt_end_date
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_bunker_loss_exp
datetime ldt_arr_date

SELECT MIN(A.PORT_ARR_DT)
INTO :ldt_arr_date
FROM
(
	SELECT MIN(PORT_ARR_DT) AS PORT_ARR_DT
	FROM POC 
	WHERE VESSEL_NR = :ai_vessel_nr
	AND LEFT(VOYAGE_NR, 5) = :as_voyage_nr
	UNION ALL
	SELECT MIN(PORT_ARR_DT) AS PORT_ARR_DT
	FROM POC_EST
	WHERE VESSEL_NR = :ai_vessel_nr
	AND LEFT(VOYAGE_NR, 5) = :as_voyage_nr
) A
WHERE A.PORT_ARR_DT IS NOT NULL;

if ldt_arr_date >=adt_start_date and adt_start_date <  adt_end_date then
	SELECT dbo.FN_GET_BUNKER_LOSS_PROFIT(:ai_vessel_nr, :as_voyage_nr)
	INTO :ld_bunker_loss_exp
	FROM SYSTEM_OPTION;
end if

if isnull(ld_bunker_loss_exp) then ld_bunker_loss_exp = 0

return ld_bunker_loss_exp
end function

public function decimal of_get_tcnon_port_amount (long al_contract_id, s_tcoutperiod astr_period, string as_act_est, datetime adt_start_date);/********************************************************************
   of_get_tcnon_port_amount
   <DESC>refer to	FN_GET_NON_PORT_EXP_OR_INC_ACT,	FN_GET_NON_PORT_EXP_OR_INC_EST</DESC>
   <RETURN>	decimal</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27/07/15		CR3705		CCY018		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_non_port_exp

if as_act_est = "ACT" then
	SELECT ROUND(ISNULL(SUM((ISNULL(NTC_NON_PORT_EXP.AMOUNT, 0) - ISNULL(NTC_NON_PORT_EXP.ADDRESS_COMMISSION, 0)   * ISNULL(NTC_NON_PORT_EXP.EX_RATE_TC, 100)/100)   * ISNULL(NTC_PAYMENT.EX_RATE_USD,100)/100), 0), 2)
	INTO :ld_non_port_exp
	FROM NTC_NON_PORT_EXP,   
				NTC_PAYMENT,   
				NTC_TC_CONTRACT  
	WHERE ( NTC_PAYMENT.PAYMENT_ID = NTC_NON_PORT_EXP.PAYMENT_ID )   
	 AND ( NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID ) 
	 AND (
	 		 (NTC_NON_PORT_EXP.ACTIVITY_PERIOD >= :astr_period.dtm_start AND  NTC_NON_PORT_EXP.ACTIVITY_PERIOD < :astr_period.dtm_end )   
			 OR (:astr_period.dtm_start = :adt_start_date AND YEAR(NTC_NON_PORT_EXP.ACTIVITY_PERIOD) = YEAR(:adt_start_date) AND MONTH(NTC_NON_PORT_EXP.ACTIVITY_PERIOD) = MONTH(:adt_start_date))
		)
	 AND ( NTC_TC_CONTRACT.CONTRACT_ID = :al_contract_id )   
	 AND ( NTC_NON_PORT_EXP.TRANS_TO_CODA = 1 )   
	 AND ( NTC_NON_PORT_EXP.INCOME = 0 )   
	 AND ( NTC_NON_PORT_EXP.USE_IN_VAS = 1 );     
else //est
	SELECT IsNull(SUM(NTC_EST_INCOME_EXP.AMOUNT), 0 )
	INTO :ld_non_port_exp
	FROM NTC_TC_PERIOD, NTC_EST_INCOME_EXP  
	WHERE NTC_TC_PERIOD.TC_PERIODE_ID = NTC_EST_INCOME_EXP.TC_PERIODE_ID
	AND NTC_TC_PERIOD.CONTRACT_ID = :al_contract_id
	AND NTC_TC_PERIOD.TC_PERIODE_ID = :astr_period.l_periodid
	AND NTC_EST_INCOME_EXP.INCOME = 0 
	AND NTC_EST_INCOME_EXP.PORT_EXPENSE <> 1;
end if
	
if isnull(ld_non_port_exp) then ld_non_port_exp = 0

return ld_non_port_exp
end function

public function datetime of_get_firstarrival (s_tcoutestimate astr_tcoutestimate);/********************************************************************
   of_get_firstarrival
   <DESC>Get first port arrival date.</DESC>
   <RETURN>	datetime </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_tcoutestimate
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date      			CR-Ref		Author		Comments
		02-08-2017			CR4629		XSZ004		First Version	      
   </HISTORY>
********************************************************************/

int      li_vesselnr
string   ls_voyagenr      
datetime ldt_firstarrival

setnull(ldt_firstarrival)

li_vesselnr = astr_tcoutestimate.i_vesselnr
ls_voyagenr = of_get_voyage_number(astr_tcoutestimate.str_hire)

if ls_voyagenr <> "" then
	SELECT min(PORT_ARR_DT) INTO :ldt_firstarrival
	  FROM POC
	 WHERE VESSEL_NR = :li_vesselnr
	   AND LEN(LTRIM(RTRIM(VOYAGE_NR))) > 5
		AND LEFT(LTRIM(VOYAGE_NR), 5) = :ls_voyagenr;
end if

return ldt_firstarrival
end function

on n_esttcout_bak.create
call super::create
end on

on n_esttcout_bak.destroy
call super::destroy
end on

