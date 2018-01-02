$PBExportHeader$n_estallocated_bak.sru
forward
global type n_estallocated_bak from n_estimate
end type
end forward

global type n_estallocated_bak from n_estimate
end type
global n_estallocated_bak n_estallocated_bak

type variables

end variables

forward prototypes
public function long of_getcalcidbystatus (long ai_estcalcid, integer ai_calcstatus)
public function integer of_writeoutdebug ()
public function integer of_loadresult ()
public function integer of_load (ref n_autoschedule anv_autosched)
public function integer of_loadabc (long al_portrow, n_autoschedule anv_autosched, mt_n_datastore ads_calcports, ref decimal ad_result)
public function integer of_loaddtmarrival (long al_portrow, datetime adtm_actportarr, ref datetime adtm_lastknown, ref datetime adtm_arrival)
public subroutine documentation ()
public function long of_getcalculateddata (ref long al_calcid, ref datetime adtm_fixturedate)
public function long of_getestimateddata (long al_calcid, ref datetime adtm_fixturedate)
end prototypes

public function long of_getcalcidbystatus (long ai_estcalcid, integer ai_calcstatus);/* from the voyage table we have the estimated calc id, get the requested calc_id */
/* TODO - not used here due to late modification - this function should be moved to a more general common object so it can be reused elsewhere */

long ll_request

if ai_calcstatus=6 then return ai_estcalcid

SELECT 
	CAL_CALC_ID
INTO 
	:ll_request
FROM 
	CAL_CALC
WHERE 
	CAL_CALC_FIX_ID = 
		(
		SELECT 
			CAL_CALC_FIX_ID 
		FROM 
			CAL_CALC 
		WHERE 
			CAL_CALC_ID=:ai_estcalcid) 
	AND CAL_CALC_STATUS = :ai_calcstatus
USING sqlca;	

return ll_request
end function

public function integer of_writeoutdebug ();long ll_row

if super::of_writeoutdebug() <> c#return.NoAction then
	
	if istr_voy.s_typecode<>"T" then /* not TC-OUT */
		_addmessage( this.classdefinition, "of_writeoutdebug()", "calculation results", "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "-----------------------------------", "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "gross freight          :" + string(istr_voy.d_grossfreight,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "misc. income           :" + string(istr_voy.d_miscincome,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "misc. expenses         :" + string(istr_voy.d_miscexpenses,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "total commission       :" + string(istr_voy.d_totalcommission,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "total addr. comm.      :" + string(istr_voy.d_totaladdrcomm,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "total bunker           :" + string(istr_voy.d_totalbunker,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "demurrage              :" + string(istr_voy.d_demurrage,"###,###,##0.00"), "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "___________________________________", "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "port data", "")
		_addmessage( this.classdefinition, "of_writeoutdebug()", "-----------------------------------", "")
		
		for ll_row = 1 to upperbound(istr_voy.str_portcalls)
			_addmessage(this.classdefinition, "of_writeoutdebug()", "(" + string(ll_row,"00") + ") port=" + istr_voy.str_portcalls[ll_row].s_portcode + &
				" est.arrdtm=" + string(istr_voy.str_portcalls[ll_row].dtm_portarrival,"dd/mm/yy hh:mm") + &
				" est.distance=" + string(istr_voy.str_portcalls[ll_row].d_atobviacdistance ,"###,###,##0.00") + &
				" est.expenses=" + string(istr_voy.str_portcalls[ll_row].d_expenses ,"###,###,##0.00") + &
				" <<" + istr_voy.str_portcalls[ll_row].s_source + ">>", "")
		next
	
	end if
end if
return c#return.Success
end function

public function integer of_loadresult ();mt_n_datastore lds_voyresult

lds_voyresult = create mt_n_datastore
lds_voyresult.dataobject = "d_sp_gr_voyageestoract"
lds_voyresult.settrans(sqlca)

lds_voyresult.retrieve(istr_voy.l_calcid, istr_voy.i_vesselnr, istr_voy.s_voyagenr)

if lds_voyresult.rowcount() <> 1 then
	_addmessage( this.classdefinition, "n_estallocated.of_load()", "error, cannot locate estimated or actual result", "")
	destroy lds_voyresult
	return c#return.Failure
end if
		
istr_voy.d_grossfreight 	= lds_voyresult.getitemnumber( 1, "freight")
istr_voy.d_demurrage 		= lds_voyresult.getitemnumber( 1, "demurrage")
istr_voy.d_miscincome 		= lds_voyresult.getitemnumber( 1, "misc_income")
istr_voy.d_miscexpenses 	= lds_voyresult.getitemnumber( 1, "misc_exp")
istr_voy.d_totalcommission = lds_voyresult.getitemnumber( 1, "broker_comm")
istr_voy.d_totalbunker 		= lds_voyresult.getitemnumber( 1, "bunker_exp")

destroy lds_voyresult
return c#return.Success
end function

public function integer of_load (ref n_autoschedule anv_autosched);/********************************************************************
   of_load()
	
<DESC>   
	Process that inserts data from various sources and constucts data 
	structures
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	anv_autosched: Passed as a param to maintain instance instead of regenerating each time
</ARGS>
<USAGE>
	Called from the n_axestimation family of objects.  Process relies on supporting functions found
	within this object or its ancestor.
</USAGE>
<HISTORY>
	Date      		CR-Ref		Author		Comments
	03-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
</HISTORY>
********************************************************************/

boolean lb_hasproceeding, lb_hasactual
datetime	ldtm_actportarr, ldtm_lastknown
decimal {4} ld_portexpenses
string  ls_procport, ls_calcport, ls_purpose 
long ll_portrow, ll_rowcount

mt_n_datastore lds_calcports

if istr_voy.l_calcid=1 and istr_voy.s_typecode="T" then
	/* a Time Charter Out */
	if not (istr_voy.b_client) then /* AX Estimate server application */
		_addmessage( this.classdefinition, "n_estallocated.of_load()", "TC-Out - ignore", "")
	end if
	return c#return.NoAction
end if	

/* transform estimated calcid to the calculated version */
of_getestimateddata(istr_voy.l_calcid, istr_voy.dtm_fixturedate)

/* get actual/estimated data */
if of_loadresult()=c#return.failure then return c#return.failure

//port expenses and misc expenses for route, proceeding/act poc, calculation cargo
lds_calcports = create mt_n_datastore
lds_calcports.dataobject = "d_sp_gr_portandmisc_exp"
lds_calcports.settrans(sqlca)
ll_rowcount = lds_calcports.retrieve(istr_voy.l_calcid)

/* main port builder */
lb_hasproceeding = true
lb_hasactual = false

setnull(ldtm_lastknown)

for ll_portrow = 1 to ll_rowcount
	ls_procport = lds_calcports.getitemstring( ll_portrow, "proceed_port_code")
	
	/* simple level validation to check if we have actual poc data */
	if not isnull(ls_procport) then
		ldtm_actportarr = lds_calcports.getitemdatetime( ll_portrow, "port_arr_dt")
		if not isnull(ldtm_actportarr) then
			ldtm_lastknown = ldtm_actportarr
			lb_hasactual= true
		else
			lb_hasactual= false
		end if
	else
		lb_hasproceeding = false
		setnull(ldtm_actportarr)
	end if
	
	if isnull(ldtm_lastknown) then
		ldtm_lastknown = istr_voy.dtm_start
		is_generatedresult[ii_PORTARRDTM] = "VOY"
	else
		if isnull(ldtm_actportarr) then
			is_generatedresult[ii_PORTARRDTM] = "CALC"
		else	
			is_generatedresult[ii_PORTARRDTM] = "ACT"
		end if
	end if	
	
	ls_calcport = lds_calcports.getitemstring(ll_portrow,"port_code")
	
	if lb_hasproceeding and ls_calcport = ls_procport then	
		/* load general port code data */
		istr_voy.str_portcalls[ll_portrow].s_portcode = ls_procport
		istr_voy.str_portcalls[ll_portrow].i_pcn = lds_calcports.getitemnumber(ll_portrow,"pcn")
		istr_voy.str_portcalls[ll_portrow].d_atobviacdistance = lds_calcports.getitemdecimal(ll_portrow,"atobviac_distance")	
		is_generatedresult[ii_DIST] = "PROC"
		if isnull(istr_voy.str_portcalls[ll_portrow].d_atobviacdistance) then
			istr_voy.str_portcalls[ll_portrow].d_atobviacdistance = -1
		end if	
		istr_voy.str_portcalls[ll_portrow].dtm_portarrival = ldtm_lastknown	
	else
		/* we must get the data from the calculation and also calculate the running distances/arrival times manually */		
		istr_voy.str_portcalls[ll_portrow].s_portcode = ls_calcport
		istr_voy.str_portcalls[ll_portrow].d_atobviacdistance = -1
		is_generatedresult[ii_PORTARRDTM] = "AUTO"
		lb_hasproceeding = false
	end if
	
	/*get the actual/estimated port expense from procedure, 
	  get the estimated if the proceeding port not match with calculation itinary, which has been included in the procedure*/
	istr_voy.str_portcalls[ll_portrow].d_expenses = lds_calcports.getitemnumber( ll_portrow, "port_exp")
	
	of_loadabc(ll_portrow, anv_autosched, lds_calcports, istr_voy.str_portcalls[ll_portrow].d_atobviacdistance)
	of_loaddtmarrival(ll_portrow, ldtm_actportarr, ldtm_lastknown, istr_voy.str_portcalls[ll_portrow].dtm_portarrival)
	istr_voy.str_portcalls[ll_portrow].s_source = of_getgenerationdetail() 
	
	ls_purpose =  lds_calcports.getitemstring( ll_portrow, "purpose_code")
	
	if ( ls_purpose = "L" or ls_purpose = "L/D") and isnull(istr_voy.dt_firstload) then
		istr_voy.dt_firstload = ldtm_lastknown
	end if
next

/* provide data with more accorate voyage end date */
if not(lb_hasproceeding) or not(lb_hasactual) then
	if ldtm_lastknown > istr_voy.dtm_end then
		istr_voy.dtm_end = ldtm_lastknown
	end if
end if

destroy lds_calcports

return c#return.Success
end function

public function integer of_loadabc (long al_portrow, n_autoschedule anv_autosched, mt_n_datastore ads_calcports, ref decimal ad_result);/* 
obtain distance from atobviac engine if we do not have a distance due to either proceeding not having
one or there being no proceeding data for following ports 
*/
string ls_fromport, ls_toport

if ad_result = -1 then
	if al_portrow > 1 then
		if not isvalid(anv_autosched) then
			anv_autosched = create n_autoschedule
		end if	
		ls_fromport = ads_calcports.getitemstring(al_portrow - 1,"abc_portcode")
		ls_toport = ads_calcports.getitemstring(al_portrow, "abc_portcode")

		/* required due to possibility that a port can not be found. */
		TRY
			ad_result = anv_autosched.of_get_atobviacdistance(ls_fromport, ls_toport)
			
			if isnull(ad_result) or ad_result = 0 then
				ad_result = ads_calcports.getitemdecimal(al_portrow, "atobviac_distance")
			end if
		CATCH ( Throwable ex )
			_addmessage( this.classdefinition, "of_loadabc()", "error can not load distance value, missing distance between port " + ls_fromport + " and " + ls_toport, "")
		FINALLY
			/* no action  here */
		END TRY 
		
		is_generatedresult[ii_DIST] = "ABC"
	else
		ad_result = 0
		is_generatedresult[ii_DIST] = "0"
	end if
else
	return c#return.NoAction
end if	

return c#return.Success
end function

public function integer of_loaddtmarrival (long al_portrow, datetime adtm_actportarr, ref datetime adtm_lastknown, ref datetime adtm_arrival);long ll_journeyseconds
	
if of_getavgofspeed( ) <> 0 then
	if istr_voy.str_portcalls[al_portrow].d_atobviacdistance > 0 and isnull(adtm_actportarr) then
		ll_journeyseconds = long((istr_voy.str_portcalls[al_portrow].d_atobviacdistance / of_getavgofspeed() ) * 3600)
		adtm_lastknown = of_adjustdatetime(adtm_lastknown, ll_journeyseconds)
	end if
	adtm_arrival = adtm_lastknown
end if	
return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_estallocated
	
	<OBJECT>
		Child object of n_estimate, this object contains specific business logic to
		generate estimation data for allocated voyages
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
   <USAGE>
		when contract type of a voyage not equal to -1 the axestimation process uses this logic
	</USAGE>
   <ALSO>
		otherobjs
	</ALSO>
   	Date   		Ref    				Author   		Comments
  	07/03/12 	FINANCE08      	AGL027		First Version
	29/03/12		FINANCE08			AGL027		created new function of_getcalculateddata() to include fixture date
	18/09/12		CR2908 				LHC010		add function of_getestimateddata, transform the data from calculated to estimated
															modified function of_loadresult, get estimated data from VAS
	12/10/12		CR2914				LHC010		Modified function of_loadresult, get the data of actual or estimated from procedure
															Obsolete CR2908 get estimated data from VAS
															Modified function of_load, obsolete the get estimated from calculation
															(deleted function of_loadexpenses), get the actual or estimated port expense from procedure
	24/09/13		CR2790				WWA048		Get the distance between two ports.
	03-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
********************************************************************/
end subroutine

public function long of_getcalculateddata (ref long al_calcid, ref datetime adtm_fixturedate);/* from the voyage table we have the estimated calc id, get the requested calculation calc_id */
/* replace passed calcid with calculated version of it, also aquire start date */

long ll_request
integer li_calculatedstatus = 5 

SELECT 
	CAL_CALC_ID, CAL_CALC_START_DATE
INTO 
	:al_calcid, :adtm_fixturedate
FROM 
	CAL_CALC
WHERE 
	CAL_CALC_FIX_ID = 
		(
		SELECT 
			CAL_CALC_FIX_ID 
		FROM 
			CAL_CALC 
		WHERE 
			CAL_CALC_ID=:al_calcid) 
	AND CAL_CALC_STATUS = :li_calculatedstatus
USING sqlca;	

return c#return.Success
end function

public function long of_getestimateddata (long al_calcid, ref datetime adtm_fixturedate);/* from the voyage table we have the estimated calc id, get the start date */

SELECT CAL_CALC_START_DATE
INTO 
	:adtm_fixturedate
FROM 
	CAL_CALC
WHERE CAL_CALC_ID=:al_calcid
USING sqlca;	

return c#return.Success
end function

on n_estallocated_bak.create
call super::create
end on

on n_estallocated_bak.destroy
call super::destroy
end on

