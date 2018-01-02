$PBExportHeader$n_estimate.sru
forward
global type n_estimate from mt_n_nonvisualobject
end type
end forward

global type n_estimate from mt_n_nonvisualobject
end type
global n_estimate n_estimate

type variables
decimal {4} id_avgspeed, id_avgcons, id_bunkerprice
integer ii_selectedfuel = 0
string is_fueltypes[] = {"fo", "mgo"}
string is_generated[] = {"/dist:", "/portarrdtm:", "/expenses:"}
string is_generatedresult[] = {"","",""}
s_voyageestimate 	istr_voy 
string is_pastvoyages[] /* used by only tc-out estimates */
integer ii_vesselnr = 0
constant integer ii_DIST = 1
constant integer ii_PORTARRDTM = 2
constant integer ii_PORTEXPENSE = 3

constant integer ii_DISTERR = 1
constant integer ii_SPEEDERR = 2
constant integer ii_CONSERR = 4
constant integer ii_BUNKERR = 8
constant integer ii_TRANSERR = 16


end variables

forward prototypes
public function boolean of_samevessel (integer ai_newvesselnr)
public function datetime of_adjustdatetime (datetime adtm_original, long al_seconds)
public function integer of_writeoutdebug ()
public function integer of_setavgofconsumption (mt_n_datastore ads_cons)
public function integer of_setavgofspeed (mt_n_datastore ads_cons)
public function integer of_getavgofspeed ()
public function integer of_getavgofconsumption ()
public function long of_getnbrofports ()
public function decimal of_getsumofdistance ()
public function string of_getgenerationdetail ()
public function integer of_initds (ref mt_n_datastore ads, string as_do)
public function integer of_initds (ref mt_n_datastore ads, string as_do, long al_arg)
public function integer of_initds (ref mt_n_datastore ads, string as_do, integer ai_arg, string as_arg)
public function integer of_init (ref s_voyageestimate astr_voy)
public function integer of_load (ref n_autoschedule anv_autosched)
public subroutine documentation ()
public function integer of_initvesseldata (ref string as_returntext)
public function integer of_initvesseldata (integer ai_vesselnr)
public function integer of_getexrate (string as_currcode)
end prototypes

public function boolean of_samevessel (integer ai_newvesselnr);if ai_newvesselnr = ii_vesselnr then
	return true
else
	return false
end if
end function

public function datetime of_adjustdatetime (datetime adtm_original, long al_seconds);datetime ldtm_returnval
mt_n_datefunctions	lnv_dateutils

if al_seconds > 0 then
	ldtm_returnval = lnv_dateutils.of_relativedatetime(adtm_original,al_seconds)
end if
return ldtm_returnval
end function

public function integer of_writeoutdebug ();if istr_voy.b_client=false then /* from server application */
	_addmessage( this.classdefinition, "of_writeoutdebug()", "start/end dates        :" + string(istr_voy.dtm_start,"dd/mm/yyyy hh:mm") + " to " + string(istr_voy.dtm_end,"dd/mm/yyyy hh:mm"), "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "voyage first load      :" + string(istr_voy.dt_firstload, "dd/mm/yyyy hh:mm"), "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "average consumption    :" + string(id_avgcons,"###,###,##0.00"), "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "average speed          :" + string(id_avgspeed,"###,###,##0.00"), "")
	return c#return.Success
else /* from Tramos */
	return c#return.NoAction
end if
end function

public function integer of_setavgofconsumption (mt_n_datastore ads_cons);long ll_fuel, ll_cons
long ll_found=0

for ll_fuel = 1 to upperbound(is_fueltypes)
	for ll_cons = 1 to ads_cons.rowcount()
		if ads_cons.getitemdecimal(ll_cons,"cal_cons_" + is_fueltypes[ll_fuel])>0 then
			id_avgcons += ads_cons.getitemdecimal(ll_cons,"cal_cons_" + is_fueltypes[ll_fuel])
			ll_found ++
		end if
	next	
	if ll_found>0 then
		exit
	end if
next 

if ll_found>0 then
	id_avgcons = id_avgcons / ll_found
else
	istr_voy.i_errorcode+=ii_CONSERR
	ll_fuel = -1
end if

return ll_fuel
end function

public function integer of_setavgofspeed (mt_n_datastore ads_cons);long ll_cons
long ll_found=0

id_avgspeed = 0

for ll_cons = 1 to ads_cons.rowcount()
	if ads_cons.getitemdecimal(ll_cons,"cal_cons_speed")>0 then
		id_avgspeed += ads_cons.getitemdecimal(ll_cons,"cal_cons_speed")			
		ll_found ++
	end if
next	

if ll_found>0 then
	id_avgspeed = id_avgspeed / ll_found
	return c#return.Success
else
	istr_voy.i_errorcode+=ii_SPEEDERR
	return c#return.Failure
end if
end function

public function integer of_getavgofspeed ();return id_avgspeed
end function

public function integer of_getavgofconsumption ();return id_avgcons
end function

public function long of_getnbrofports ();return upperbound(istr_voy.str_portcalls)
end function

public function decimal of_getsumofdistance ();decimal{4}	ld_distance=0.0
long ll_portindex

for ll_portindex = 1 to upperbound(istr_voy.str_portcalls)
	if istr_voy.str_portcalls[ll_portindex].d_atobviacdistance = -1 then
		istr_voy.str_portcalls[ll_portindex].i_errorcode += ii_DISTERR
		_addmessage(this.classdefinition, "of_getsumofdistance()", "missing distance in port:(" + string(ll_portindex) + ") " + istr_voy.str_portcalls[ll_portindex].s_portcode, "")
	else	
		ld_distance += istr_voy.str_portcalls[ll_portindex].d_atobviacdistance
	end if
next

return ld_distance
end function

public function string of_getgenerationdetail ();long ll_index
string ls_retstring=""
for ll_index = 1 to upperbound(is_generated)
	if is_generatedresult[ll_index]<>"" then
		ls_retstring += is_generated[ll_index] + is_generatedresult[ll_index]
	end if
next
return ls_retstring 
end function

public function integer of_initds (ref mt_n_datastore ads, string as_do);ads = create mt_n_datastore
ads.dataobject = as_do
ads.settransobject( SQLCA )
return c#return.Success
end function

public function integer of_initds (ref mt_n_datastore ads, string as_do, long al_arg);of_initds(ads,as_do)
ads.retrieve(al_arg)

return c#return.Success
end function

public function integer of_initds (ref mt_n_datastore ads, string as_do, integer ai_arg, string as_arg);of_initds(ads,as_do)
ads.retrieve(ai_arg, as_arg)
return c#return.Success
end function

public function integer of_init (ref s_voyageestimate astr_voy);istr_voy = astr_voy
return c#return.Success
end function

public function integer of_load (ref n_autoschedule anv_autosched);
/*

include shared business logic between allocated/unallocated objects

*/

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_estimate
	
	<OBJECT>
		Ancestor object for n_estallocated and n_estunallocated.  
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
   <USAGE>
		Contains shared business logic that is used in both child objects
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    				Author   	Comments
  	07/03/12 	FINANCE08      	AGL027		First Version
	28-08-17		CR4629				XSZ004		Fix a bug
********************************************************************/
end subroutine

public function integer of_initvesseldata (ref string as_returntext);integer li_constypes[] = {1}  // ballast consumptions
mt_n_datastore lds_cons, lds_prices

ii_vesselnr = istr_voy.i_vesselnr
as_returntext = ""

/* obtain average speed and consumption */
lds_cons = create mt_n_datastore
lds_cons.dataobject = "d_sq_gr_vesselcons" 
lds_cons.settransobject( SQLCA )
lds_cons.retrieve(istr_voy.i_vesselnr, li_constypes)
if lds_cons.rowcount()>0 then
	of_setavgofspeed(lds_cons)
	ii_selectedfuel = of_setavgofconsumption(lds_cons)
	destroy lds_cons
	/* obtain bunker price */
	lds_prices = create mt_n_datastore
	lds_prices.dataobject = "d_sq_gr_vestbunkerprices" 
	lds_prices.settransobject( SQLCA )
	lds_prices.retrieve(istr_voy.i_vesselnr)
	if ii_selectedfuel>0 then
		id_bunkerprice = lds_prices.getitemdecimal(1,"cal_vest_cal_" + is_fueltypes[ii_selectedfuel] + "_price")
		if isnull(id_bunkerprice) then
			id_bunkerprice=0.0
			as_returntext= "problem, no bunker price found for vessel " + istr_voy.s_vesselrefnr + " with fuel type" + upper(is_fueltypes[ii_selectedfuel])		
			istr_voy.i_errorcode+=ii_BUNKERR
			return c#return.Failure
		end if
	else
		as_returntext= "problem, no consumption found for any fuel type on vessel " + istr_voy.s_vesselrefnr				
	end if	
	destroy lds_prices
	return c#return.Success
else
	destroy lds_cons
	as_returntext= "problem, no consumption data found for vessel " + istr_voy.s_vesselrefnr
	return c#return.Failure	
end if

return c#return.Success
end function

public function integer of_initvesseldata (integer ai_vesselnr);/********************************************************************
of_initvesseldata()
	
<DESC>   
	overrided function 
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
	ai_vesselnr	: <integer> vessel number
</ARGS>
<USAGE>
	used primarily for the tc-out estimations
</USAGE>
********************************************************************/


string ls_empty[]

ii_vesselnr = ai_vesselnr
is_pastvoyages = ls_empty

return c#return.Success
end function

public function integer of_getexrate (string as_currcode);n_exchangerate	lnv_exrate
return (lnv_exrate.of_gettodaysusdrate(as_currcode) / 100)
end function

on n_estimate.create
call super::create
end on

on n_estimate.destroy
call super::destroy
end on

