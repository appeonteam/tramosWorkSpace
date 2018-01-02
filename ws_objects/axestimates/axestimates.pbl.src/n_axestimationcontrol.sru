$PBExportHeader$n_axestimationcontrol.sru
$PBExportComments$logic controlling access to estimation(s)
forward
global type n_axestimationcontrol from mt_n_nonvisualobject
end type
end forward

global type n_axestimationcontrol from mt_n_nonvisualobject
end type
global n_axestimationcontrol n_axestimationcontrol

type variables
mt_n_datastore ids_voyagelist, ids_tcoutlist
boolean ib_excludefinished = false
boolean ib_use_actual_offservice=true /* not used */
constant integer ii_DISTERR = 1
constant integer ii_SPEEDERR = 2
constant integer ii_CONSERR = 4
constant integer ii_BUNKERR = 8
constant integer ii_TRANSERR = 16

end variables

forward prototypes
public function integer of_setexcludefinished (boolean ab_excluded)
public function boolean of_getexcludefinished ()
public function string of_getstatuscode (integer ai_voyagestatus)
public function long of_loadvoyage (integer ai_vesselnr, string as_voyagenr)
public function long of_loadvoyages (datetime adtm_startperiod, datetime adtm_endperiod)
public function string of_gettypecode (mt_n_datastore ads_voytype, integer ai_voyagetype)
public function integer of_start (ref s_axestimatesvars astr_app)
public function integer of_addlog (string as_message, string as_callingfunction, boolean ab_client)
public function long of_loadvoyages (string as_yy)
public function integer of_do_voyage_estimates (ref s_axestimatesvars astr_app)
public function integer of_do_tcout_estimates (ref s_axestimatesvars astr_app)
public subroutine documentation ()
public function long of_loadtcouts (integer ai_vesselnr, string as_voyagenr)
public function long of_loadtcouts (datetime adtm_start)
public function long of_loadtcouts (datetime adtm_start, datetime adtm_end)
end prototypes

public function integer of_setexcludefinished (boolean ab_excluded);ib_excludefinished = ab_excluded
return c#return.Success
end function

public function boolean of_getexcludefinished ();return ib_excludefinished
end function

public function string of_getstatuscode (integer ai_voyagestatus);string ls_statuscode

CHOOSE CASE ai_voyagestatus
	CASE 1	/* Finished */
		ls_statuscode='F'
	CASE ELSE	/* Active */
		ls_statuscode='A'
END CHOOSE
return ls_statuscode
end function

public function long of_loadvoyage (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   of_loadvoyage
<DESC>   
	Get voyage data and store in instance datastore
</DESC>
<RETURN>
	Long:
		<LI> number of rows retrieved (always 1 in this child object)
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ai_vesselnr
	as_voyagenr
</ARGS>
<USAGE>

TODO: create stored procedure SP_GETVOYAGEDATA which will load a single row using
parameters passed into this function.  It must include voyage_nr, vessel_nr, startdate, enddate, voyage type, estcalcid.

</USAGE>
********************************************************************/ 

long ll_rows

ids_voyagelist.dataobject="d_sp_ff_voyagedata"
ids_voyagelist.settrans(SQLCA)
ll_rows = ids_voyagelist.retrieve(ai_vesselnr, as_voyagenr)

return ll_rows
end function

public function long of_loadvoyages (datetime adtm_startperiod, datetime adtm_endperiod);/********************************************************************
   of_loadvoyages
<DESC>   
	Get voyage data for all voyages falling inside period start end dates and store in instance datastore
</DESC>
<RETURN>
	Long:
		<LI> number of rows retreived
		<LI> -1, failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	adtm_startperiod
	adtm_endperiod
</ARGS>k
<USAGE>

TODO: create stored procedure SP_GETVOYAGELIST_BYDATE which will load rows using
parameters passed into this function.  
Output must include following columns: voyage_nr, vessel_nr, startdate, enddate, voyage type, estcalcid.

</USAGE>
********************************************************************/
long ll_rows

ids_voyagelist.dataobject="d_sp_gr_voyagelistbydaterange"
ids_voyagelist.settrans(SQLCA)
ll_rows = ids_voyagelist.retrieve(adtm_startperiod, adtm_endperiod)
/* requirement is to include finished voyages from server process */
of_setexcludefinished(false)
if ll_rows>0 and of_getexcludefinished() then
	ids_voyagelist.setfilter("finished=0")
	ids_voyagelist.filter()
	ll_rows=ids_voyagelist.rowcount()
end if

return ll_rows
end function

public function string of_gettypecode (mt_n_datastore ads_voytype, integer ai_voyagetype);string ls_typecode
long ll_found

ll_found = ads_voytype.find("id=" + string(ai_voyagetype),1,999)
if ll_found>0 then
	return ads_voytype.getitemstring(ll_found,"ax_code")
else
	return "-1"
end if
end function

public function integer of_start (ref s_axestimatesvars astr_app);/********************************************************************
   of_start()
	
<DESC>   
	Main function that controls type of estimates that are processed
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
	ast_app: Application level variables
</ARGS>
<USAGE>
	s_estimatetype currently may include "all", "voyage" or "tcout"
	additionally in future "tcin" may be included.
	Simplified selection that can be adapted later.
</USAGE>
********************************************************************/

integer li_retval


if astr_app.s_estimatetype = "voyage" or astr_app.s_estimatetype = "all" then
	li_retval = of_do_voyage_estimates(astr_app)
end if
if astr_app.s_estimatetype = "tcout" or astr_app.s_estimatetype = "all" then
	li_retval = of_do_tcout_estimates(astr_app)
end if

return c#return.Success
end function

public function integer of_addlog (string as_message, string as_callingfunction, boolean ab_client);//of_addlog("","of_start", astr_app.b_client)
if ab_client = false then /* from the Server application */
	_addmessage( this.classdefinition, as_callingfunction, as_message , "")
	return c#return.Success
else /* from Tramos */
	return c#return.NoAction
end if	


end function

public function long of_loadvoyages (string as_yy);/********************************************************************
   of_loadvoyages
<DESC>   
	Get voyage data for all voyages prefixed with year requested
</DESC>
<RETURN>
	Long:
		<LI> number of rows retreived
		<LI> -1, failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_yy : 2 digit year, ie '12'
</ARGS>
<USAGE>

TODO: create stored procedure SP_GETVOYAGELIST_BYDATE which will load rows using
parameters passed into this function.  
Output must include following columns: voyage_nr, vessel_nr, startdate, enddate, voyage type, estcalcid.

</USAGE>
********************************************************************/
long ll_rows

ids_voyagelist.dataobject="d_sp_gr_voyagelistbyvoyageyear"
ids_voyagelist.settrans(SQLCA)
ll_rows = ids_voyagelist.retrieve(as_yy)

return ll_rows
end function

public function integer of_do_voyage_estimates (ref s_axestimatesvars astr_app);/********************************************************************
   of_do_voyage_estimates()
	
<DESC>   
	Main function that controls looping through all voyages retreived
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
	ast_app: Application level variables
</ARGS>
<USAGE>
	2 controlling objects 'allocated' and 'unallocated'.  Limitation in design is that the validation of
	previous vessel has to be carried out in each object to construct vessel detail.  It is therefore 
	possible that each vessel may be called upon maximum 2 times to load vessel specific detail for both
	objects.
	We do not use shared variables as this works fine without.
</USAGE>
<HISTORY>
	Date      		CR-Ref		Author		Comments
	03-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
</HISTORY>
********************************************************************/

long     ll_row, ll_rows, ll_test
integer  li_success = 0, li_transactionstatus
long     ll_counters[] = {0,0,0,0,0}	/* used to keep record of total transactions and their status' */
datetime ldt_poc_firstload, ldt_calc_firstload

mt_n_datastore	        lds_voytype							/* voyage type configuration for AX */

n_estallocated         lnv_alloc							/* allocated voyage specific business logic for estimated generation */
n_estunallocated       lnv_unalloc							/* unallocated voyage specific business logic for estimated generation */
n_autoschedule         lnv_autosched 						/* attempt to speed up access to atobviac engine */
u_transaction_estimate lnv_trans							/* estimated transaction processing */

s_transaction_input lstr_defaulttransaction			/* dummy structure in this case */
s_voyageestimate    lstr_est, lstr_defaultest		/* main estimation data held within these structures */

constant integer ii_STANDARDMODE = 1
constant integer ii_VOYYEARMODE = 2
constant long    ll_VOYCOUNT = 1, ll_ALLOCATED = 2, ll_UNALLOCATED = 3, ll_ALLOCATEDERROR = 4, ll_UNALLOCATEDERROR = 5

/* retrieve data */
if astr_app.b_client then
	/* called by Tramos (client) */
	ll_counters[ll_VOYCOUNT] = of_loadvoyage(astr_app.i_clientvesselnr, astr_app.s_clientvoyagenr)	
else
	/* called by axestimates (server) */
	if astr_app.i_servermode = ii_STANDARDMODE then
		/* standard process run on a set period */
		ll_counters[ll_VOYCOUNT] = of_loadvoyages(astr_app.dtm_serverperiodfrom, astr_app.dtm_serverperiodto)
	elseif astr_app.i_servermode = ii_VOYYEARMODE then
		ll_counters[ll_VOYCOUNT] = of_loadvoyages(astr_app.s_voyageyear)
	end if	
end if

// TODO: reuse Appeon dataobject when it becomes available
lds_voytype = create mt_n_datastore
lds_voytype.dataobject = "d_sp_gr_voyagetype"
lds_voytype.settransobject( SQLCA )
lds_voytype.retrieve()

lnv_alloc = create n_estallocated
lnv_unalloc = create n_estunallocated
lnv_autosched = create n_autoschedule 

/* only override client's default atobviac table if running from server */
if astr_app.b_client = false then
	lnv_autosched.of_init(astr_app.s_abctablepath)
end if

/* load default estimated structure (same for all estimate transactions that may be generated on this instance) */
lstr_defaultest.s_activityperiod = astr_app.s_periodref
lstr_defaultest.i_yyyy           = integer(mid(astr_app.s_periodref,1,4))
lstr_defaultest.i_period         = integer(mid(astr_app.s_periodref,5,2))
lstr_defaultest.b_client         = astr_app.b_client
lstr_defaultest.b_allocated      = false

/* for each vessel/voyage attempt to generate an estimated transaction */
for ll_row = 1 to ll_counters[ll_VOYCOUNT]
	
	lstr_est                = lstr_defaultest
	lstr_est.i_contracttype = ids_voyagelist.getitemnumber(ll_row,"contract_type")
	lstr_est.i_vesselnr     = ids_voyagelist.getitemnumber(ll_row,"vessel_nr")
	lstr_est.s_vesselrefnr  = ids_voyagelist.getitemstring(ll_row,"vessel_ref_nr")
	lstr_est.s_voyagenr     = ids_voyagelist.getitemstring(ll_row,"voyage_nr")
	lstr_est.s_typecode     = of_gettypecode(lds_voytype,ids_voyagelist.getitemnumber(ll_row,"voyage_type"))
	lstr_est.s_statuscode   = of_getstatuscode(ids_voyagelist.getitemnumber(ll_row,"finished"))
	lstr_est.dtm_start      = ids_voyagelist.getitemdatetime(ll_row,"voyage_start")
	lstr_est.dtm_end        = ids_voyagelist.getitemdatetime(ll_row,"voyage_end")	
	lstr_est.dtm_cerpstart  = ids_voyagelist.getitemdatetime(ll_row,"cerp_start")
	lstr_est.l_calcid       = ids_voyagelist.getitemnumber(ll_row,"calc_id")
	ldt_poc_firstload       = ids_voyagelist.getitemdatetime(ll_row, "poc_firstload")
	ldt_calc_firstload      = ids_voyagelist.getitemdatetime(ll_row, "calc_firstload")
	
	setnull(lstr_est.dt_firstload)
	
	if lstr_est.i_contracttype>0 then 
		lstr_est.b_allocated = true
	end if	

	of_addlog("","of_start", astr_app.b_client)
	of_addlog("#####      " + string(ll_row) + "/" + string(ll_counters[ll_VOYCOUNT]) + " - processing vessel=" + ids_voyagelist.getitemstring(ll_row,"vessel_ref_nr") + " voyage=" + ids_voyagelist.getitemstring(ll_row,"voyage_nr") + "      #####","of_start", astr_app.b_client)
	
	if lstr_est.b_allocated then
		
		ll_counters[ll_ALLOCATED]++
		
		of_addlog("ALLOCATED","of_start", astr_app.b_client)
		of_addlog("","of_start", astr_app.b_client)
		
		lnv_alloc.of_init(lstr_est)
		
		if not (lnv_alloc.of_samevessel(lstr_est.i_vesselnr)) then
			li_success = lnv_alloc.of_initvesseldata(astr_app.s_returnmessage)
			if not(astr_app.b_client) and not isnull(astr_app.s_returnmessage) then 
				_addmessage( this.classdefinition, "of_start()", astr_app.s_returnmessage, "")
			end if	
		end if
		
		if li_success<>c#return.Failure then
			
			lnv_alloc.of_load(lnv_autosched)
			
			lstr_est = lnv_alloc.istr_voy
			
			if not isnull(ldt_poc_firstload) then
				lstr_est.dt_firstload = ldt_poc_firstload
			elseif lstr_est.dt_firstload < ldt_calc_firstload then
				lstr_est.dt_firstload = ldt_calc_firstload
			end if
			
			lnv_alloc.of_writeoutdebug()
		else
			ll_counters[ll_ALLOCATEDERROR]++
		end if
	else
		
		ll_counters[ll_UNALLOCATED]++		
		
		/* need to get the distance from the calc and work out estimated bunker */
		of_addlog("UNALLOCATED","of_start", astr_app.b_client)
		of_addlog("","of_start", astr_app.b_client)
		
		lnv_unalloc.of_init(lstr_est)
		
		if not (lnv_unalloc.of_samevessel(lstr_est.i_vesselnr)) then
			
			li_success = lnv_unalloc.of_initvesseldata(astr_app.s_returnmessage)
			
			if not(astr_app.b_client) and not isnull(astr_app.s_returnmessage) then 
				_addmessage( this.classdefinition, "of_start()", astr_app.s_returnmessage, "")
			end if	
		end if	
		
		if li_success<>c#return.Failure then
			
			lnv_unalloc.of_load(lnv_autosched)
			lnv_unalloc.of_writeoutdebug()
			
			lstr_est = lnv_unalloc.istr_voy
			
			if lnv_unalloc.of_getfinalbunkervalue()<0 then
				ll_counters[ll_UNALLOCATEDERROR]++
			end if
		else
			ll_counters[ll_UNALLOCATEDERROR]++
		end if
	end if	
	
	/* now generate transaction */
	lnv_trans = create u_transaction_estimate
	li_transactionstatus = lnv_trans.of_generate_transaction(lstr_defaulttransaction, lstr_est)
	
	destroy lnv_trans
	
	/* TODO: write to status report */
	garbagecollect()
next	

of_addlog("----------------","of_start", astr_app.b_client)
of_addlog("Summary              ","of_start", astr_app.b_client)
of_addlog("","of_start", astr_app.b_client)
of_addlog("SUM OF VOYAGES       :" + string(ll_counters[ll_VOYCOUNT]),"of_start", astr_app.b_client)
of_addlog("ALLOCATED            :" + string(ll_counters[ll_ALLOCATED]),"of_start", astr_app.b_client)
of_addlog("ALLOCATED ERRRORS    :" + string(ll_counters[ll_ALLOCATEDERROR]),"of_start", astr_app.b_client)
of_addlog("UNALLOCATED          :" + string(ll_counters[ll_UNALLOCATED]),"of_start", astr_app.b_client)
of_addlog("UNALLOCATED ERRRORS  :" + string(ll_counters[ll_UNALLOCATEDERROR]),"of_start", astr_app.b_client)
of_addlog("----------------","of_start", astr_app.b_client)

/* TODO seperate the errors from the TC-OUT voyages */


/* business logic to be processed if we are running from Tramos */
if astr_app.b_client then
	
	if li_transactionstatus=c#return.Failure then
		return c#return.Failure
	elseif li_transactionstatus=c#return.NoAction then
		return c#return.NoAction
	else	
		if astr_app.s_infomessage<>"" then
			_addmessage( this.classdefinition, "of_do_voyage_estimates()", astr_app.s_infomessage, "total=" + string(ll_counters[ll_VOYCOUNT]) + ", allocated=" + string(ll_counters[ll_ALLOCATEDERROR]) + "/" + string(ll_counters[ll_ALLOCATED]) + &
			", unallocated=" + string(ll_counters[ll_UNALLOCATEDERROR]) + "/" + string(ll_counters[ll_UNALLOCATED]))
		end if
	end if
end if	

if isvalid(lnv_autosched) then
	destroy lnv_autosched 
end if

destroy lds_voytype
destroy lnv_unalloc
destroy lnv_alloc
	
return c#return.Success
end function

public function integer of_do_tcout_estimates (ref s_axestimatesvars astr_app);/********************************************************************
   of_do_tcout_estimates()
	
<DESC>   
	Main function that controls looping through all TC-OUT periods retreived
	
	WIP - must update transaction object and structure may still change
	
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
	ast_app: Application level variables
</ARGS>
<USAGE>

</USAGE>
<HISTORY>
	Date      		CR-Ref		Author		Comments
	10-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
</HISTORY>
********************************************************************/



long 							ll_row,ll_periodindex,ll_errorindex
long 							ll_counters[] = {0,0}	/* used to keep record of total transactions and their status' */
integer						li_success,li_transactionstatus, li_vesselnr
decimal {8}					ld_offdays
datetime 					ldtm_startdate, ldtm_enddate
string 						ls_voyagenr, ls_key="", ls_nextyear
s_tcoutestimate			lstr_tcoutest, lstr_defaulttcoutest		/* tc-out estimation data held within these structures */
n_esttcout 					lnv_tcout
mt_n_outgoingmail	lnv_mail
string ls_mailto, ls_receiver, ls_subject, is_emailtext, ls_errormessage, ls_tempdir
constant string 			ls_newline = "~r~n"


constant long 	ll_PERIODCOUNT = 1
constant long ll_CONTRACTCOUNT = 2


lnv_tcout = create n_esttcout

lstr_defaulttcoutest.s_activityperiod = astr_app.s_periodref
lstr_defaulttcoutest.i_yyyy = integer(mid(astr_app.s_periodref,1,4))
lstr_defaulttcoutest.i_period = integer(mid(astr_app.s_periodref,5,2))
lstr_defaulttcoutest.b_client = astr_app.b_client
ldtm_startdate = datetime("1/1/" + mid(astr_app.s_periodref,1,4))

/* retrieve data */
if astr_app.b_client then
	/* called by Tramos (client) */
	ll_counters[ll_PERIODCOUNT] = of_loadtcouts(astr_app.i_clientvesselnr, astr_app.s_clientvoyagenr)	
else
	/* called by axestimates (server) */
	if astr_app.s_voyageyear="" or isnull(astr_app.s_voyageyear) then
		/* standard process */
		ll_counters[ll_PERIODCOUNT] = of_loadtcouts(ldtm_startdate)
	else	
		/* we may need to exacute process for a different year to the current */
		ls_nextyear = string(lstr_defaulttcoutest.i_yyyy + 1)	
		ldtm_enddate = datetime("1/1/" + ls_nextyear + " 00:00")
		ll_counters[ll_PERIODCOUNT] = of_loadtcouts(ldtm_startdate, ldtm_enddate)
	end if
end if

lnv_tcout.of_initapp(astr_app)

for ll_row = 1 to ll_counters[ll_PERIODCOUNT]

	ls_voyagenr = lnv_tcout.of_validate_voyage_number(ids_tcoutlist.getitemnumber(ll_row,"vessel_nr"),ids_tcoutlist.getitemstring(ll_row,"voyagenr"), ids_tcoutlist.getitemdatetime(ll_row,"periode_start"))
	li_vesselnr = ids_tcoutlist.getitemnumber(ll_row,"vessel_nr")

	if isnull(ids_tcoutlist.getitemstring(ll_row,"voyagenr")) then
		ls_key = ids_tcoutlist.getitemstring(ll_row,"vessel_ref_nr") + "00000" + string(ids_tcoutlist.getitemnumber(ll_row,"contract_id"),"00000000")	
	else	
		ls_key = ids_tcoutlist.getitemstring(ll_row,"vessel_ref_nr") + ids_tcoutlist.getitemstring(ll_row,"voyagenr") + string(ids_tcoutlist.getitemnumber(ll_row,"contract_id"),"00000000")	
	end if
	
	if ls_key <> lstr_tcoutest.s_key then
		if lstr_tcoutest.s_key <> '' then  // not the first
			of_addlog("CREATING TRANSACTION POST", "of_start", astr_app.b_client)
			
			lstr_tcoutest.dt_firstarrival = lnv_tcout.of_get_firstarrival(lstr_tcoutest)
			
			lnv_tcout.of_init(lstr_tcoutest)
			/* for TC-OUT of_load includes creation of transaction */
			lnv_tcout.of_do_transaction()
		end if	
		/* a new contract */
		
		ll_counters[ll_CONTRACTCOUNT]++
		
		lstr_tcoutest = lnv_tcout.of_create_tcout_contract(ls_key,	&	
						li_vesselnr, &
						"T", &
						ids_tcoutlist.getitemdatetime(ll_row,"tc_hire_cp_date"), &
						ids_tcoutlist.getitemnumber(ll_row,"contract_id"), &
						ids_tcoutlist.getitemnumber(ll_row,"monthly_rate"), &
						ids_tcoutlist.getitemdatetime(ll_row,"periode_start"), &
						ids_tcoutlist.getitemstring(ll_row,"chart_nomaccnr"), &
						ids_tcoutlist.getitemstring(ll_row,"tcowner_nomaccnr"), &
						ids_tcoutlist.getitemstring(ll_row,"curr_code"), &
						ids_tcoutlist.getitemnumber(ll_row,"bareboat"),	&					
						ids_tcoutlist.getitemnumber(ll_row,"in_pool"), &								
						ids_tcoutlist.getitemnumber(ll_row,"local_time"), &
						ids_tcoutlist.getitemdecimal(ll_row,"addresscomm"))
		
		lstr_tcoutest.d_exchangerate = lnv_tcout.of_getexrate(lstr_tcoutest.s_currcode)
		/* USD amount = {local_amount} * (lstr_tcoutest.d_exchangerate) */
	
		if not (lnv_tcout.of_samevessel(li_vesselnr)) then
			lnv_tcout.of_initvesseldata(li_vesselnr)
		end if
		
	else
		of_addlog("MATCHED KEY", "of_start", astr_app.b_client)				
	end if
	
	/* locate the voyage end */
	lstr_tcoutest.dtm_end = ids_tcoutlist.getitemdatetime(ll_row,"periode_end")

	/* append to hire structure for this period */
	lnv_tcout.of_append_tcout_period(lstr_tcoutest, &	
				ids_tcoutlist.getitemdatetime(ll_row,"periode_start"), &
				ids_tcoutlist.getitemdatetime(ll_row,"periode_end"), &
				ids_tcoutlist.getitemnumber(ll_row,"tc_periode_id"), &
				ids_tcoutlist.getitemnumber(ll_row,"period_rate"), &
				ids_tcoutlist.getitemnumber(ll_row,"offhire_days"), &
				ids_tcoutlist.getitemnumber(ll_row,"estoffhire_days"), &
				ls_voyagenr)

	of_addlog("#####      " + string(ll_row) + "/" + string(ll_counters[ll_PERIODCOUNT]) + " - processing KEY=" + ls_key + "      #####","of_start", astr_app.b_client)
next

/* process the last transaction */
if ll_counters[ll_PERIODCOUNT] > 0 then 
	of_addlog("CREATING TRANSACTION POST", "of_start", astr_app.b_client)
	
	lstr_tcoutest.dt_firstarrival = lnv_tcout.of_get_firstarrival(lstr_tcoutest)
	
	lnv_tcout.of_init(lstr_tcoutest)
	lnv_tcout.of_do_transaction()
end if

of_addlog("----------------","of_start", astr_app.b_client)
of_addlog("Summary              ","of_start", astr_app.b_client)
of_addlog("","of_start", astr_app.b_client)
of_addlog("SUM OF PERIODS       :" + string(ll_counters[ll_PERIODCOUNT]),"of_start", astr_app.b_client)
of_addlog("SUM OF CONTRACTS     :" + string(ll_counters[ll_CONTRACTCOUNT]),"of_start", astr_app.b_client)
of_addlog("SUM OF ERRORS        :" + string(upperbound(lnv_tcout.istr_errors)),"of_start", astr_app.b_client)
of_addlog("----------------","of_start", astr_app.b_client)

/* business logic to be processed if we are running from Tramos */
if astr_app.b_client then
	if li_transactionstatus=c#return.Failure then
		return c#return.Failure
	elseif li_transactionstatus=c#return.NoAction then
		return c#return.NoAction
	else	
		if astr_app.s_infomessage<>"" then
			_addmessage( this.classdefinition, "of_do_tcout_estimates()", astr_app.s_infomessage, "")
		end if
	end if
else
	
	if upperbound(lnv_tcout.istr_errors)>0 then
		/* mail an error report to designated mailto */
		lnv_mail = create mt_n_outgoingmail
		ls_mailto = left(astr_app.s_emailto,6)
		ls_receiver = ls_mailto + C#EMAIL.DOMAIN
		ls_subject = "TC-OUT estimates error notification"
		is_emailtext = "There has been an error.  Please check the following issues identified by the AXEstimates application." + ls_newline + ls_newline
		ls_errormessage = ""
		
		for ll_errorindex = 1 to upperbound(lnv_tcout.istr_errors)
			is_emailtext+= ls_newline + "TC-OUT error (" + string(ll_errorindex) + "/" + string(upperbound(lnv_tcout.istr_errors)) + ")" + ls_newline
			is_emailtext+="vessel number		:" + lnv_tcout.istr_errors[ll_errorindex].s_vesselrefnr + ls_newline
			is_emailtext+="voyage number	:" + lnv_tcout.istr_errors[ll_errorindex].s_voyagenr + ls_newline
			is_emailtext+="contract id		:" + string(lnv_tcout.istr_errors[ll_errorindex].l_contractnr) + ls_newline
			is_emailtext+="notes			:" + lnv_tcout.istr_errors[ll_errorindex].s_notes + ls_newline
		next 	
		
		if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receiver, ls_subject, is_emailtext, ls_errormessage) = -1 then
			of_addlog("error calling of_createmail() function. error report not sent to " + ls_mailto,"n_axestimationcontrol.of_do_tcout_estimates()", astr_app.b_client)
			destroy lnv_mail
			return c#return.failure
		else
			if lnv_mail.of_setcreator( ls_mailto, ls_errorMessage) = -1 then
				of_addlog("error calling of_setcreator() function. error report not sent to " + ls_mailto,"n_axestimationcontrol.of_do_tcout_estimates()", astr_app.b_client)
				destroy lnv_mail
				return c#return.failure
			end if
			
			if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
				of_addlog("error calling of_sendmail() function. error report not sent to " + ls_mailto,"n_axestimationcontrol.of_do_tcout_estimates()", astr_app.b_client)
				destroy lnv_mail
				return c#return.failure
			else
				of_addlog("email report sent to " + ls_mailto,"n_axestimationcontrol.of_do_tcout_estimates()", astr_app.b_client)
			end if
		end if	
		lnv_mail.of_reset()
		destroy lnv_mail		
			
	end if
	
end if	


return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_axestimationcontrol()
	
	<OBJECT>
		Filters which type of estimation is needed and which client is used.
		Obtains data that will then be used to generate requested estimate data.
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
		Date      		CR-Ref		Author		Comments
		00/00/07  		?     		Name Here	First Version
		04/10/12  		CR2775		AGL027		Open up TC-OUT usage	(WIP)
		08/02/16  		CR4298		AGL027		Allow application to use its own path for atobviac tables.
		03-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
********************************************************************/
end subroutine

public function long of_loadtcouts (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   of_loadtcouts()
<DESC>   
	Used from the client application when user can select to generate
	new estimate in finance control panel
</DESC>
<RETURN>
	Integer:
		<LI> rowcount returned from retrieval
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	ai_vesselnr
	as_voyagenr
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

ids_tcoutlist = create mt_n_datastore
ids_tcoutlist.dataobject = "d_sq_ff_tcoutbyvesselvoyage"
ids_tcoutlist.settransobject( SQLCA )

return ids_tcoutlist.retrieve(ai_vesselnr, as_voyagenr)

end function

public function long of_loadtcouts (datetime adtm_start);/********************************************************************
   of_loadtcouts()
<DESC>   
	Used from the server application
</DESC>
<RETURN>
	Integer:
		<LI> rowcount returned from retrieval
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	adtm_from: period date from
	adtm_to: period date to
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

ids_tcoutlist = create mt_n_datastore
ids_tcoutlist.dataobject = "d_sq_gr_tcoutbystartdate"
ids_tcoutlist.settransobject( SQLCA )

return ids_tcoutlist.retrieve(adtm_start)

end function

public function long of_loadtcouts (datetime adtm_start, datetime adtm_end);/********************************************************************
   of_loadtcouts()
<DESC>   
	Used from the server application
</DESC>
<RETURN>
	Integer:
		<LI> rowcount returned from retrieval
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	adtm_from: period date from
	adtm_to: period date to
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

ids_tcoutlist = create mt_n_datastore
ids_tcoutlist.dataobject = "d_sq_gr_tcoutbydaterange"
ids_tcoutlist.settransobject( SQLCA )
return ids_tcoutlist.retrieve(adtm_start, adtm_end)

end function

on n_axestimationcontrol.create
call super::create
end on

on n_axestimationcontrol.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_voyagelist = create mt_n_datastore

end event

event destructor;call super::destructor;destroy ids_voyagelist


end event

