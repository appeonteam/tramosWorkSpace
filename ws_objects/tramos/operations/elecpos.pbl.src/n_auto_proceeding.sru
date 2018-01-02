$PBExportHeader$n_auto_proceeding.sru
forward
global type n_auto_proceeding from mt_n_nonvisualobject
end type
type inv_autoschedule from n_autoschedule within n_auto_proceeding
end type
type ids_calc_route from mt_n_datastore within n_auto_proceeding
end type
type ids_calc_itinerary from mt_n_datastore within n_auto_proceeding
end type
end forward

global type n_auto_proceeding from mt_n_nonvisualobject
inv_autoschedule inv_autoschedule
ids_calc_route ids_calc_route
ids_calc_itinerary ids_calc_itinerary
end type
global n_auto_proceeding n_auto_proceeding

type variables
mt_n_datefunctions	inv_date_utility

CONSTANT long il_TIMECHARTEROUT = 2
CONSTANT long il_IDLEVOYAGE = 7

boolean ib_autocreatepoc

CONSTANT integer ii_MANUAL  = 0
CONSTANT integer ii_AUTOCAL = 1

end variables

forward prototypes
private subroutine _add_nonballast_ports (mt_n_datastore ads_ports, string as_purpose)
private function string _getportname (string as_port_code)
private subroutine _get_route (long al_calc_id, long al_vessel_nr, string as_voyage_nr)
private subroutine _add_ballast_ports (mt_n_datastore ads_calc_ballastports)
public function long of_create_estpoc (long al_vessel_nr, string as_voyage_nr, string as_port_code, long al_pcn, long al_num)
public function long _get_calc_id (long al_vessel_nr, string as_voyage_nr)
public function long of_auto_proceeding (long al_vessel_nr, string as_voyage_nr)
public subroutine documentation ()
end prototypes

private subroutine _add_nonballast_ports (mt_n_datastore ads_ports, string as_purpose);/********************************************************************
   _add_nonballast_ports
   <DESC>	add load ports and discharge ports to itinerary	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ads_ports
		as_purpose
   </ARGS>
   <USAGE>	Suggest to use in the _get_route function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
		20/03/2013	 CR2658		  LHG008			Add calc_cons_id
   </HISTORY>
********************************************************************/

long		ll_rownum, ll_count, ll_newrow, ll_sailing_cons_id
string	ls_portcode, ls_portname

ll_count = ads_ports.rowcount()
for ll_rownum = 1 to ll_count
	ls_portcode = ads_ports.getitemstring(ll_rownum, "port_code")
	ls_portname = _getportname(ls_portcode)
	
	ll_newrow = ids_calc_itinerary.insertrow(0)
	
	//itinerary number refers to the sequence number
	ids_calc_itinerary.setitem(ll_newrow, "itinerary", ads_ports.getitemnumber(ll_rownum, "cal_caio_itinerary_number"))
	ids_calc_itinerary.setitem(ll_newrow, "port_code", ls_portcode)
	ids_calc_itinerary.setitem(ll_newrow, "port_n", ls_portname)
	
	if ads_ports.getitemnumber(ll_rownum, "cal_caio_number_of_units") = 0 then
		ids_calc_itinerary.setitem(ll_newrow, "type", ads_ports.getitemstring(ll_rownum, "purpose_code"))
	else
		ids_calc_itinerary.setitem(ll_newrow, "type", as_purpose)
	end if
	
	//speed here refers to the speed of current port to next ports
	ids_calc_itinerary.setitem(ll_newrow, "speed", ads_ports.getitemdecimal(ll_rownum, "cal_caio_leg_speed"))
	ids_calc_itinerary.setitem(ll_newrow, "sailing_cons_id", ads_ports.getitemnumber(ll_rownum, "sailing_cons_id"))
next

end subroutine

private function string _getportname (string as_port_code);/********************************************************************
   _getportname
   <DESC>	get the port name from cache table according to the port code	</DESC>
   <RETURN>	string: port name	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_port_code
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_portname
long		ll_found

if not isnull(as_port_code) and trim(as_port_code) <> "" then
	ll_found = w_share.dw_calc_port_dddw.find("port_code = '" + as_port_code + "'", 1, w_share.dw_calc_port_dddw.rowcount())
	if ll_found > 0 then
		ls_portname = w_share.dw_calc_port_dddw.getitemstring(ll_found, "port_n")
	end if
end if

return ls_portname

end function

private subroutine _get_route (long al_calc_id, long al_vessel_nr, string as_voyage_nr);/********************************************************************
   _get_route
   <DESC>	get the route map of the voyage of the vessel	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_calc_id
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	Suggest to use in the of_auto_proceeding() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
		18/03/2013	 CR2658		  LHG008			Accroding to calc_cons_id get the consumption
		12/08/2013	 CR2790		  WWA048			Get the distance between two ports
		27/11/2013   CR2658UAT	  LHC010			Get the consumption from vessel and shiptype
   </HISTORY>
********************************************************************/

long		ll_row, ll_rownum, ll_newrow, ll_ballastcount, ll_itinerarycount, ll_routecount, ll_conscount, ll_cargo_id[]
long		ll_speedpos, ll_found, ll_via_point, ll_cons_id, ll_port_from, ll_port_to, ll_port_count, ll_distance
dec		ld_speed, ld_cons_hfo
string	ls_port_code, ls_port_name, ls_abc_portcode, ls_preport, ls_curport, ls_purpose, ls_previous_voyage, ls_portlist[]
boolean	lb_existballastfrom
long		ll_begin, ll_end
string	ls_begin, ls_end

mt_n_datastore		lds_calc_cargolist
mt_n_datastore		lds_calc_loadports
mt_n_datastore		lds_calc_dischargeports
mt_n_datastore		lds_calc_ballastports
mt_n_datastore		lds_calc_cons
mt_n_datastore		lds_proceed_voyage

//reset itinerary
ids_calc_itinerary.reset()

//get cargo list
lds_calc_cargolist = create mt_n_datastore
lds_calc_cargolist.dataobject = "d_sq_gr_cargo_list"
lds_calc_cargolist.settransobject(sqlca)
if lds_calc_cargolist.retrieve(al_calc_id) > 0 then
	ll_cargo_id = lds_calc_cargolist.object.cal_carg_id.primary
end if
destroy lds_calc_cargolist

if upperbound(ll_cargo_id) <= 0 then return

//get and add load ports to itinerary
lds_calc_loadports = create mt_n_datastore
lds_calc_loadports.dataobject = "d_calc_cargo_in"
lds_calc_loadports.settransobject(sqlca)
lds_calc_loadports.retrieve(ll_cargo_id)
_add_nonballast_ports(lds_calc_loadports, "L")
destroy lds_calc_loadports

//get and add discharge ports to itinerary
lds_calc_dischargeports = create mt_n_datastore
lds_calc_dischargeports.dataobject = "d_calc_cargo_out"
lds_calc_dischargeports.settransobject(sqlca)
lds_calc_dischargeports.retrieve(ll_cargo_id)
_add_nonballast_ports(lds_calc_dischargeports, "D")
destroy lds_calc_dischargeports

//sort by itinerary
ids_calc_itinerary.setsort("itinerary A")
ids_calc_itinerary.sort()

//get 'ballast from' and 'ballast to' ports
lds_calc_ballastports = create mt_n_datastore
lds_calc_ballastports.dataobject = "d_atobviac_calc_ballast"
lds_calc_ballastports.settransobject(sqlca)
ll_ballastcount = lds_calc_ballastports.retrieve(al_calc_id)
if ll_ballastcount > 0 then
	ls_port_code = lds_calc_ballastports.getitemstring(1, "port_code")
	if not isnull(ls_port_code) and trim(ls_port_code) <> "" then
		lb_existballastfrom = true
	end if
end if

//get route list
ids_calc_route.settransobject(sqlca)
ll_routecount = ids_calc_route.retrieve(al_calc_id)
ll_found = ids_calc_route.find("purpose_code <> 'B'", 1, ll_routecount)		//get first 'non ballast port'
ll_found = ids_calc_route.find("purpose_code = 'B'", 1, ll_found)				//get 'ballast from' port

if not lb_existballastfrom or ll_found <= 0 then
	//get the last port of previous voyage
	SELECT TOP 1 PROCEED.PORT_CODE, PORT_N, VIA_POINT, ABC_PORTCODE
	  INTO :ls_preport, :ls_port_name, :ll_via_point, :ls_abc_portcode
	  FROM PROCEED, PORTS, ATOBVIAC_PORT
	 WHERE PROCEED.PORT_CODE = PORTS.PORT_CODE AND
	       PORTS.ABC_PORTID  = ATOBVIAC_PORT.ABC_PORTID AND
	       VESSEL_NR = :al_vessel_nr AND
			 VOYAGE_NR < :as_voyage_nr
 ORDER BY VOYAGE_NR Desc, PROC_DATE Desc;

	if sqlca.sqlcode = 0 then
		if not lb_existballastfrom then
			if ids_calc_itinerary.rowcount() > 0 then
				ls_port_code = ids_calc_itinerary.getitemstring(1, "port_code")
			end if
			
			if ls_port_code = ls_preport then
				//if the first port of current voyage is same as the last port of previous voyage, then set speed to 0.0
				ld_speed = 0
			else
				//if the first port of current voyage is different from the last port of previous voyage,
				//locate vessels lowest speed for Ballast consumption type and use that in the first port.
				SELECT Min(CAL_CONS_SPEED), Min(CAL_CONS_ID)
				  INTO :ld_speed, :ll_cons_id
				  FROM CAL_CONS
				 WHERE VESSEL_NR = :al_vessel_nr AND CAL_CONS_TYPE = 1 AND ZONE_ID = 1;		//CAL_CONS_TYPE = "Sailing - Ballast" AND ZONE_ID = "Normal"
			end if
			
			if ll_ballastcount <= 0 then
				ll_newrow = lds_calc_ballastports.insertrow(0)
			else
				ll_newrow = 1
			end if
			
			lds_calc_ballastports.setitem(ll_newrow, "port_code", ls_preport)
			lds_calc_ballastports.setitem(ll_newrow, "cal_ball_leg_speed", ld_speed)
			lds_calc_ballastports.setitem(ll_newrow, "cal_cons_id", ll_cons_id)
		end if
		
		if ll_found <= 0 then
			ll_newrow = ids_calc_route.insertrow(1)
			ids_calc_route.setitem(ll_newrow, "port_code", ls_preport)
			ids_calc_route.setitem(ll_newrow, "ports_port_n", ls_port_name)
			ids_calc_route.setitem(ll_newrow, "abc_portcode", ls_abc_portcode)
			ids_calc_route.setitem(ll_newrow, "ports_via_point", ll_via_point)
			ids_calc_route.setitem(ll_newrow, "purpose_code", "B")
			ids_calc_route.setitem(ll_newrow, "cal_cons_id", ll_cons_id)
		end if
	end if
end if

_add_ballast_ports(lds_calc_ballastports)		//add 'ballast from' and add 'ballast to' ports
destroy lds_calc_ballastports

//get previous voyage number
SELECT MAX(VOYAGE_NR)
  INTO :ls_previous_voyage
  FROM PROCEED
 WHERE VESSEL_NR = :al_vessel_nr AND
       VOYAGE_NR < :as_voyage_nr;

//get all 'ABC_PORTCODE' of the previous voyage
if not isnull(ls_previous_voyage) then
	lds_proceed_voyage = create mt_n_datastore
	lds_proceed_voyage.dataobject = "d_sq_gr_proceed_voyage"
	lds_proceed_voyage.settransobject(sqlca)
	if lds_proceed_voyage.retrieve(al_vessel_nr, ls_previous_voyage) > 0 then
		ls_portlist = lds_proceed_voyage.object.abc_portcode.primary
	end if
	destroy lds_proceed_voyage
end if

//set the ballast port to the last position in array
ll_routecount = ids_calc_route.rowcount()
if ll_routecount > 0 then
	ls_preport = ""
	if upperbound(ls_portlist) > 0 then
		ls_preport = ls_portlist[upperbound(ls_portlist)]
	end if
	
	ls_curport = ids_calc_route.getitemstring(1, "abc_portcode")
	if ls_preport <> ls_curport then
		ls_portlist[upperbound(ls_portlist) + 1] = ls_curport
	end if
end if

//calculate the distance between previous port to current port.
for ll_row = 2 to ll_routecount
	ls_curport = ids_calc_route.getitemstring(ll_row, "abc_portcode")
	if isnull(ls_curport) then ls_curport = ""
	
	if ls_curport <> "" then
		setnull(ll_distance)
		ll_port_from = upperbound(ls_portlist)
		ls_preport = ls_portlist[ll_port_from]
		
		ll_distance = inv_autoschedule.of_get_atobviacdistance(ls_preport, ls_curport)
		
		if isnull(ll_distance) then
			ll_begin = ids_calc_route.find("ports_via_point = 0", ll_row - 1, 1)
			ll_end = ids_calc_route.find("ports_via_point = 0", ll_row, ll_routecount)
			
			if ll_begin > 0 and ll_end > 0 then
				ls_begin = ids_calc_route.getitemstring(ll_begin, "abc_portcode")
				ls_end = ids_calc_route.getitemstring(ll_end, "abc_portcode")
				
				ll_distance = gnv_atobviac.of_getporttoportdistance(ls_portlist[upperbound(ls_portlist)], ls_curport, ls_begin, ls_end)
			end if
		end if
		
		do while isnull(ll_distance)
			if ll_port_from <= 0 then exit
			ls_preport = ls_portlist[ll_port_from]
			ll_port_from --
			
			ll_distance = inv_autoschedule.of_get_atobviacdistance(ls_preport, ls_curport)
		loop 
		
		ids_calc_route.setitem(ll_row, "distance", ll_distance)	
		ls_portlist[upperbound(ls_portlist) + 1] = ls_curport
	end if
next

lds_calc_cons = create mt_n_datastore
lds_calc_cons.dataobject = "d_dddw_proceeding_vesselspeed"
lds_calc_cons.settransobject(sqlca)
ll_conscount = lds_calc_cons.retrieve(al_vessel_nr)

ll_port_from = 1
ll_itinerarycount = ids_calc_itinerary.rowcount()
for ll_row = 2 to ll_itinerarycount
	ls_port_code = ids_calc_itinerary.getitemstring(ll_row, "port_code")
	ls_purpose   = ids_calc_itinerary.describe("evaluate('type', " + string(ll_row - 1) + ")")
	ld_speed     = dec(ids_calc_itinerary.describe("evaluate('speed', " + string(ll_row - 1) + ")"))
	ll_cons_id   = ids_calc_itinerary.getitemnumber(ll_row - 1, "sailing_cons_id")
	ld_cons_hfo  = 0.00
	
	ll_speedpos = lds_calc_cons.find("cal_cons_id = " + string(ll_cons_id), 1, ll_conscount)
	if ll_speedpos > 0 then ld_cons_hfo = lds_calc_cons.getitemdecimal(ll_speedpos, "cal_cons_fo")

	ll_port_to = ids_calc_route.find("port_code = '" + ls_port_code + "'", ll_port_from, ll_routecount)
	if ll_port_to <= 0 then exit
	
	for ll_rownum = ll_port_from + 1 to ll_port_to
		ids_calc_route.setitem(ll_rownum, "speed", ld_speed)
		ids_calc_route.setitem(ll_rownum, "consumption", ld_cons_hfo)
		ids_calc_route.setitem(ll_rownum, "cal_cons_id", ll_cons_id)
	next
	
	ll_port_from = ll_port_to
next

destroy lds_calc_cons

end subroutine

private subroutine _add_ballast_ports (mt_n_datastore ads_calc_ballastports);/********************************************************************
   _add_ballast_ports
   <DESC>	add ballast ports to itinerary	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ads_calc_ballastports
   </ARGS>
   <USAGE>	Suggest to use in the _get_route function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
		20/03/2013	 CR2658		  LHG008			Add calc_cons_id
   </HISTORY>
********************************************************************/

string	ls_portcode, ls_portname
long		ll_rownum, ll_count, ll_newrow

ll_count = ads_calc_ballastports.rowcount()
if ll_count <= 0 then return

if ll_count > 2 then ll_count = 2

//Insert the 'ballast from' to the first position and insert the 'ballast to' to the last position
for ll_rownum = 1 to ll_count
	ls_portcode = ads_calc_ballastports.getitemstring(ll_rownum, "port_code")
	ls_portname = _getportname(ls_portcode)
	if isnull(ls_portname) or trim(ls_portname) = "" then continue
	
	if ll_rownum = 1 then
		ll_newrow = ids_calc_itinerary.insertrow(1)
	else
		ll_newrow = ids_calc_itinerary.insertrow(0)
	end if
	
	ids_calc_itinerary.setitem(ll_newrow, "itinerary", ll_newrow)
	ids_calc_itinerary.setitem(ll_newrow, "port_code", ls_portcode)
	ids_calc_itinerary.setitem(ll_newrow, "port_n", ls_portname)
	ids_calc_itinerary.setitem(ll_newrow, "type", "B")
	ids_calc_itinerary.setitem(ll_newrow, "speed", ads_calc_ballastports.getitemdecimal(ll_rownum, "cal_ball_leg_speed"))
	ids_calc_itinerary.setitem(ll_newrow, "sailing_cons_id", ads_calc_ballastports.getitemnumber(ll_rownum, "cal_cons_id"))
next

end subroutine

public function long of_create_estpoc (long al_vessel_nr, string as_voyage_nr, string as_port_code, long al_pcn, long al_num);/********************************************************************
   of_create_estpoc
   <DESC>	auto create estimate port and auto schedule	</DESC>
   <RETURN>	long: the number of the estimate port of auto creation	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr: vessel number
		as_voyage_nr: voyage number
		as_port_code: port code
		al_pcn:       pcn
		al_num:       the number of the estimate ports
		              zero indicates that all the remaining estimate ports will be created
   </ARGS>
   <USAGE>	Suggest to use in the of_auto_proceeding() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_pcnc_count, ll_route_count, ll_row, ll_route_found, ll_portstay, ll_calc_id
long		ll_pcn, ll_return, ll_start, ll_end, ll_found, ll_steamingtime, ll_seconds
long		ll_voyagebegin, ll_pocpos, ll_voyageend, ll_newrow
decimal	ld_portstay
string	ls_find, ls_purpose_code, ls_port_code, ls_port_name, ls_error, ls_shiptype
datetime	ldt_ori_eta, ldt_cal_eta, ldt_cal_etd, ldt_pre_etd, ldt_oir_pre_etd, ldt_cur_pre_etd

constant string ls_FAILEDINFOHEAD = "Failed to create Estimated POC"

s_autoschedule		lstr_autoschedule

mt_n_datastore		lds_est_poc
mt_n_datastore		lds_proc_pcnc
mt_n_datastore		lds_calc_route

if not ib_autocreatepoc then return 0

//get the calculation id
ll_calc_id = _get_calc_id(al_vessel_nr, as_voyage_nr)
if ll_calc_id <= 0 then return c#return.Failure

//get the port of call list
lds_proc_pcnc = create mt_n_datastore
lds_proc_pcnc.dataobject = "d_sp_tb_proceed_poc_list"
lds_proc_pcnc.settrans(sqlca)
ll_pcnc_count = lds_proc_pcnc.retrieve(al_vessel_nr, "", 1)

//get the start row and end row of the voyage
ls_find = "vessel_nr = " + string(al_vessel_nr) + " and voyage_nr = '" + as_voyage_nr + "' "
ll_voyagebegin = lds_proc_pcnc.find(ls_find, 1, ll_pcnc_count)
ll_voyageend   = lds_proc_pcnc.find(ls_find, ll_pcnc_count, 1)

ls_find += " and port_code = '" + as_port_code + "' and pcn = " + string(al_pcn)
ll_pocpos = lds_proc_pcnc.find(ls_find, ll_voyagebegin, ll_voyageend)
if ll_pocpos <= 0 then ll_pocpos = ll_voyageend

ll_found = lds_proc_pcnc.find("(isnull(est_port_arr_dt)) and (not isnull(port_arr_dt))", ll_pocpos, ll_pcnc_count)
if ll_found > 0 then
	messagebox("Information", ls_FAILEDINFOHEAD + ", because there is at least one Actual POC after this proceeding.")
	destroy lds_proc_pcnc
	return c#return.Failure
end if

//get the start row and the end row of those un-created ports for this voyage.
if al_num <= 0 then
	ll_found = lds_proc_pcnc.find("not isnull(port_arr_dt)", ll_pocpos, ll_voyagebegin)
	if ll_found <= 0 then ll_found = ll_voyagebegin	
	ll_end = ll_voyageend
else
	ll_found = ll_pocpos
	if ll_pocpos + al_num - 1 > ll_voyageend then
		ll_end = ll_voyageend
	else
		ll_end = ll_pocpos + al_num - 1
	end if
end if

ll_start = lds_proc_pcnc.find("isnull(port_arr_dt) and isnull(est_port_arr_dt)", ll_found, ll_end)
if ll_start <= 0 or ll_end <= 0 then
	destroy lds_proc_pcnc
	return c#return.NoAction
end if

//get the calculation route data
lds_calc_route = create mt_n_datastore
lds_calc_route.dataobject = "d_sq_gr_route"
lds_calc_route.settransobject(sqlca)
ll_route_count = lds_calc_route.retrieve(ll_calc_id)
ll_route_found = lds_calc_route.find("purpose_code <> 'B'", 1, ll_route_count) - 1

//initialize estimate ports
lds_est_poc = create mt_n_datastore
lds_est_poc.dataobject = "d_sq_gr_poc_est"
lds_est_poc.settransobject(sqlca)

//compare the proceeding and the calculation route, insert or update the estimate ports
for ll_row = ll_voyagebegin to ll_voyageend
	ls_port_code = lds_proc_pcnc.getitemstring(ll_row, "port_code")
	ls_port_name = _getportname(ls_port_code)
	ll_route_found = lds_calc_route.find("port_code = '" + ls_port_code + "'", ll_route_found + 1, ll_route_count + 1)
	if ll_route_found <= 0 then
		messagebox("Information", ls_FAILEDINFOHEAD + ", as the proceeding doesn't match with calculation data.")
		exit
	end if
	
	if ll_start <= ll_row and ll_row <= ll_end then
		ls_purpose_code = lds_proc_pcnc.getitemstring(ll_row, "est_purpose_code")
		if isnull(ls_purpose_code) or trim(ls_purpose_code) = "" then
			ls_purpose_code = lds_calc_route.getitemstring(ll_route_found, "purpose_code")
		end if
		if isnull(ls_purpose_code) or trim(ls_purpose_code) = "" then
			messagebox("Information", ls_FAILEDINFOHEAD + ", as the Purpose code of '" + string(ls_port_name) + "' cannot be empty.")
			exit
		end if
		
		SELECT CAL_VEST_PORTSTAY.PORT_STAY,
				 CAL_VEST.CAL_VEST_TYPE_NAME
		  INTO :ld_portstay,
				 :ls_shiptype
		  FROM VESSELS,
				 CAL_VEST,
				 CAL_VEST_PORTSTAY
		 WHERE VESSELS.CAL_VEST_TYPE_ID = CAL_VEST.CAL_VEST_TYPE_ID AND
				 CAL_VEST.CAL_VEST_TYPE_ID = CAL_VEST_PORTSTAY.CAL_VEST_TYPE_ID AND
				 VESSELS.VESSEL_NR = :al_vessel_nr AND
				 CAL_VEST_PORTSTAY.PURPOSE_CODE = :ls_purpose_code;
		
		ll_portstay = ld_portstay * 60 * 60		//Convert hours to seconds
		if isnull(ll_portstay) or ll_portstay <= 0 then
			messagebox("Information", ls_FAILEDINFOHEAD + ", please update the port stay duration for the purpose '" + ls_purpose_code + &
			                      "' in System Tables > General > Ship Type for '" + ls_shiptype + &
										 "'. ~r~n~r~n'Port stay' duration should be greater than 0.~r~n~r~n" + &
										 "Once the port stay data has been updated you can at any time select " + &
										 "'Voyage Options...', 'Update Ports' to generate the required estimated port calls.")
			exit
		end if
		
		ldt_pre_etd = lds_proc_pcnc.getitemdatetime(ll_row, "previous_etd")
		if isnull(ldt_pre_etd) then
			messagebox("Information", ls_FAILEDINFOHEAD + ", as the Departure date of Port " + ls_port_name + "'s previous port is null.")
			exit
		end if
		
		ll_steamingtime = lds_proc_pcnc.getitemnumber(ll_row, "steamingtime") * 60 * 60		//Convert hours to seconds
		if isnull(ll_steamingtime) then
			messagebox("Information", ls_FAILEDINFOHEAD + ", as the steaming time of '" + ls_port_name + "' port cannot be null.")
			exit
		end if
		
		ldt_cal_eta = inv_date_utility.of_relativedatetime(ldt_pre_etd, ll_steamingtime)
		ldt_cal_etd = inv_date_utility.of_relativedatetime(ldt_cal_eta, ll_portstay)
		if ll_row < ll_pcnc_count then
			lds_proc_pcnc.setitem(ll_row + 1, "previous_etd", ldt_cal_etd)
		end if
		
		ll_pcn = lds_proc_pcnc.getitemnumber(ll_row, "pcn")
		
		//insert a new estimate port
		ll_newrow = lds_est_poc.insertrow(0)
		lds_est_poc.setitem(ll_newrow, "vessel_nr", al_vessel_nr)
		lds_est_poc.setitem(ll_newrow, "voyage_nr", as_voyage_nr)
		lds_est_poc.setitem(ll_newrow, "port_code", ls_port_code)
		lds_est_poc.setitem(ll_newrow, "pcn", ll_pcn)
		lds_est_poc.setitem(ll_newrow, "purpose_code", ls_purpose_code)
		
		if isnull(lds_proc_pcnc.getitemdatetime(ll_row, "est_port_arr_dt")) then
			//update task list when insert a new POC
			DELETE FROM POC_TASK_LIST
			      WHERE VESSEL_NR = :al_vessel_nr AND
					      VOYAGE_NR = :as_voyage_nr AND
							PORT_CODE = :ls_port_code AND
							PCN = :ll_pcn AND TASK_NA <> 1 AND TASK_DONE <> 1;
			if sqlca.sqlcode = -1 then
				ls_error = sqlca.sqlerrtext
				ROLLBACK;
				messagebox("Error", "Error in updating task list.~r~n~r~n" + ls_error, stopsign!)
				exit
			end if
			
			INSERT INTO POC_TASK_LIST(VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
			(
				SELECT VESSEL_NR, 
				       :as_voyage_nr, 
						 :ls_port_code, 
						 :ll_pcn, 
						 TASK_ID, 
						 TASK_SORT
				  FROM VESSELS, POC_TASKS_CONFIG_PC
				 WHERE VESSELS.VESSEL_NR = :al_vessel_nr AND
				       VESSELS.PC_NR = POC_TASKS_CONFIG_PC.PC_NR AND
				       PURPOSE_CODE = :ls_purpose_code AND
						 TASK_ID NOT IN (SELECT TASK_ID
						                   FROM POC_TASK_LIST
												WHERE VESSEL_NR = :al_vessel_nr AND
												      VOYAGE_NR = :as_voyage_nr AND
														PORT_CODE = :ls_port_code AND
														PCN = :ll_pcn
						                 )
			);
			if sqlca.sqlcode = -1 then
				ls_error = sqlca.sqlerrtext
				ROLLBACK;
				messagebox("Error", "Error in updating task list.~r~n~r~n" + ls_error, stopsign!)
				exit
			end if
		else
			//if this estimate port exists, update it
			lds_est_poc.setitemstatus(ll_newrow, 0, primary!, datamodified!)
		end if
		
		//reset the arrival date and the departure date
		lds_est_poc.setitem(ll_newrow, "port_arr_dt", ldt_cal_eta)
		lds_est_poc.setitem(ll_newrow, "auto_arr_status", ii_AUTOCAL)
		
		lds_est_poc.setitem(ll_newrow, "port_dept_dt", ldt_cal_etd)
		lds_est_poc.setitem(ll_newrow, "auto_dept_status", ii_AUTOCAL)
		
		lds_est_poc.setitem(ll_newrow, "autoschedule_status", 1)
		lds_est_poc.setitem(ll_newrow, "dates_updated_by", uo_global.is_userid)
		lds_est_poc.setitem(ll_newrow, "local_dates_updated", now())
	end if
next

//mismatch between proceeding and calculation data
if ll_row <= ll_voyageend then
	destroy lds_proc_pcnc
	destroy lds_calc_route
	destroy lds_est_poc
	return c#return.Failure
end if

//update estimate port of call and start to auto schedule
if lds_est_poc.rowcount() > 0 then
	if lds_est_poc.update() = 1 then
		ll_return = c#return.Success
		ll_found = lds_proc_pcnc.find("not isnull(est_port_arr_dt)", ll_end + 1, ll_pcnc_count + 1)
		if ll_found > 0 then
			ldt_oir_pre_etd = lds_proc_pcnc.getitemdatetime(ll_end + 1, "previous_etd", primary!, true)
			ldt_cur_pre_etd = lds_proc_pcnc.getitemdatetime(ll_end + 1, "previous_etd", primary!, false)
			ll_seconds = inv_date_utility.of_secondsafter(ldt_oir_pre_etd, ldt_cur_pre_etd)
			
			ldt_pre_etd = lds_proc_pcnc.getitemdatetime(ll_found, "previous_etd", primary!, true)
			ll_steamingtime = lds_proc_pcnc.getitemnumber(ll_found, "steamingtime") * 60 * 60		//Convert hours to seconds
			if not isnull(ll_steamingtime) then
				ldt_ori_eta = lds_proc_pcnc.getitemdatetime(ll_found, "est_port_arr_dt")
				if ldt_ori_eta < ldt_cur_pre_etd then		//reset the arrival date of the next estimate port
					ldt_cal_eta = inv_date_utility.of_relativedatetime(ldt_pre_etd, ll_steamingtime + ll_seconds)
					ll_seconds = inv_date_utility.of_secondsafter(ldt_ori_eta, ldt_cal_eta)
				end if
				
				//start auto schedule process
				if ll_seconds <> 0 then
					lstr_autoschedule.vessel_nr     = al_vessel_nr
					lstr_autoschedule.voyage_nr     = lds_proc_pcnc.getitemstring(ll_found, "voyage_nr")
					lstr_autoschedule.port_code     = lds_proc_pcnc.getitemstring(ll_found, "port_code")
					lstr_autoschedule.pcn           = lds_proc_pcnc.getitemnumber(ll_found, "pcn")
					lstr_autoschedule.year          = ""
					lstr_autoschedule.seconds_after = ll_seconds
					if not inv_autoschedule.of_autoschedule_poc(lstr_autoschedule) then
						ll_return = c#return.Failure
						ls_error  = sqlca.sqlerrtext
						ROLLBACK;
					end if
				end if
			else
				ll_return = c#return.Failure
				ROLLBACK;
			end if
		end if
	else
		ll_return = c#return.Failure
		ls_error  = sqlca.sqlerrtext
		ROLLBACK;
	end if
end if

if ll_return = c#return.Success then
	COMMIT;
	ll_return = lds_est_poc.rowcount()
elseif ll_return = c#return.Failure then
	messagebox("Error", ls_FAILEDINFOHEAD + ". ~r~n~r~n" + ls_error, stopsign!)
end if

destroy lds_proc_pcnc
destroy lds_calc_route
destroy lds_est_poc

return ll_return

end function

public function long _get_calc_id (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   _get_calc_id
   <DESC>	Get the calculation id of the voyage	</DESC>
   <RETURN>	long:
            <LI> calculation id, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	Suggest to use in of_auto_proceeding() function and 
	         of_create_estpoc() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_voyage_type, ll_calc_id

//get voyage's type and the calculation id
SELECT VOYAGE_TYPE,
       CAL_CALC_ID
  INTO :ll_voyage_type,
       :ll_calc_id
  FROM VOYAGES
 WHERE VESSEL_NR = :al_vessel_nr AND
       VOYAGE_NR = :as_voyage_nr;

//cannot be Time Charter Out or Idle Voyages
if ll_voyage_type = il_TIMECHARTEROUT or ll_voyage_type = il_IDLEVOYAGE then return c#return.Failure
if isnull(ll_calc_id) or ll_calc_id <= 1 then return c#return.Failure

return ll_calc_id

end function

public function long of_auto_proceeding (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   of_auto_proceeding
   <DESC>	auto create proceeding and estimate ports	</DESC>
   <RETURN>	long: the number of the auto create proceeding	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
		20/03/2013	 CR2658		  LHG008			Add calc_cons_id
		26/03/2013	 CR3049		  LHC010			Insert via point port and do auto schedule
   </HISTORY>
********************************************************************/

long		ll_calc_id, ll_row, ll_proceed_count, ll_routecount, ll_via_point, ll_new_estcount
long		ll_found, ll_newrow, ll_pcn, ll_count, ll_viapcn, ll_start, ll_return, ll_new_proceedcount
long		ll_proceed_row, ll_cal_cons_id, ll_listcount, ll_foundlist
string	ls_purpose, ls_port_code, ls_error, ls_proceed_portcode, ls_year
datetime	ldt_proc_date, ldt_tempdate = datetime(date("2049-01-01"),time("00:00:00"))

mt_n_datastore		lds_proceeding, lds_list
n_voyage				lnv_voyage
n_autoschedule lnv_autoschedule

//get calculation id
ll_calc_id = _get_calc_id(al_vessel_nr, as_voyage_nr)
if ll_calc_id <= 0 then return c#return.Failure

//validate the port between the proceeding and calculation route
lnv_voyage = create n_voyage
ll_return = lnv_voyage.of_check_proceed_itenerary(al_vessel_nr, as_voyage_nr)
destroy lnv_voyage
if ll_return <= 0 then return c#return.Failure

_get_route(ll_calc_id, al_vessel_nr, as_voyage_nr)

lds_list = create mt_n_datastore
lds_list.dataobject = "dw_proceeding_list"
lds_list.settransobject(sqlca)
ll_listcount = lds_list.retrieve(al_vessel_nr, right(string(today(),'yyyy'), 2))

//get existing proceeding data
lds_proceeding = create mt_n_datastore
lds_proceeding.dataobject = "d_sq_gr_proceed"
lds_proceeding.settransobject(sqlca)
ll_proceed_count = lds_proceeding.retrieve(al_vessel_nr, as_voyage_nr)
if ll_proceed_count > 0 then
	ldt_proc_date = lds_proceeding.getitemdatetime(1, "proc_date")
else
	ldt_proc_date = datetime(today(), now())
end if

SELECT Min(PCN) INTO :ll_viapcn FROM PROCEED WHERE VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND PCN < 1;
if isnull(ll_viapcn) then ll_viapcn = 1

ll_routecount = ids_calc_route.rowcount()
ll_found = ids_calc_route.find("purpose_code <> 'B'", 1, ll_routecount)

if ll_found > 0 then
	ll_start = ll_found
else
	ll_start = 1
end if

if ll_start <= ll_routecount then
	for ll_row = ll_start to ll_routecount
		ls_port_code = ids_calc_route.getitemstring(ll_row, "port_code")
		ll_via_point = ids_calc_route.getitemnumber(ll_row, "ports_via_point")
		ls_purpose   = ids_calc_route.getitemstring(ll_row, "purpose_code")
		
		if ls_purpose <> 'B' then
			if ll_start <= 1 then 
				ll_proceed_row = ll_row
			else
				ll_proceed_row = ll_row - 1
			end if
			
			do
				ldt_proc_date = inv_date_utility.of_relativedatetime(ldt_proc_date, 60)
				ll_foundlist = lds_list.find("proc_date=datetime('" + string(ldt_proc_date)+ "')", 1, ll_listcount)
			loop while ll_foundlist > 0
					
			ls_proceed_portcode = ""
			
			if ll_proceed_row <= lds_proceeding.rowcount() then
				ls_proceed_portcode = lds_proceeding.getitemstring(ll_proceed_row, "port_code")
			end if
			
			if ls_port_code = ls_proceed_portcode then				
				if ldt_proc_date >= lds_proceeding.getitemdatetime(ll_proceed_row, "proc_date") and ll_proceed_row > 1 then
					lds_proceeding.setitem(ll_proceed_row, "proc_date", ldt_proc_date)
				else
					ldt_proc_date = lds_proceeding.getitemdatetime(ll_proceed_row, "proc_date")
				end if
			else			
				//Port(0); Viapoint(1); Canal(2);
				if ll_via_point > 0 then
					ll_viapcn --
					ll_pcn = ll_viapcn
				else
					ll_found = lds_proceeding.find("port_code = '" + ls_port_code + "'", 1, lds_proceeding.rowcount())
					if ll_found > 0 then
						do 
							ll_pcn = lds_proceeding.getitemnumber(ll_found, "pcn")
							ll_found = lds_proceeding.find("port_code = '" + ls_port_code + "' and pcn > " + string(ll_pcn), ll_found + 1, lds_proceeding.rowcount() + 1)
						loop while ll_found > 0
						ll_pcn ++
					else
						ll_pcn = 1
					end if
				end if

				ll_newrow = lds_proceeding.insertrow(ll_proceed_row)
				lds_proceeding.setitem(ll_newrow, "port_code", ls_port_code)
				lds_proceeding.setitem(ll_newrow, "pcn", ll_pcn)
				lds_proceeding.setitem(ll_newrow, "proc_text", ids_calc_route.getitemstring(ll_row, "ports_port_n"))
				lds_proceeding.setitem(ll_newrow, "fwo", 0)
				lds_proceeding.setitem(ll_newrow, "cancel", 0)
				lds_proceeding.setitem(ll_newrow, "vessel_nr", al_vessel_nr)
				lds_proceeding.setitem(ll_newrow, "voyage_nr", as_voyage_nr)
				
				lds_proceeding.setitem(ll_newrow, "cal_cons_id", ids_calc_route.getitemdecimal(ll_row, "cal_cons_id"))
				lds_proceeding.setitem(ll_newrow, "speed", ids_calc_route.getitemdecimal(ll_row, "speed"))
				lds_proceeding.setitem(ll_newrow, "consumption", ids_calc_route.getitemdecimal(ll_row, "consumption"))		
				lds_proceeding.setitem(ll_newrow, "atobviac_distance", ids_calc_route.getitemdecimal(ll_row, "distance"))
				lds_proceeding.setitem(ll_newrow, "created_by", uo_global.is_userid)

				//set input_dt for Viapoint or Canal
				if ll_via_point > 0 then
					lds_proceeding.setitem(ll_newrow, "input_dt", now())
				end if
					
				lds_proceeding.setitem(ll_newrow, "proc_date", ldt_proc_date)
			
				ll_new_proceedcount++
							
				if ldt_tempdate = datetime(date("2049-01-01"),time("00:00:00")) then ldt_tempdate = ldt_proc_date

			end if
		end if
	next
end if

if ll_new_proceedcount > 0 then lds_proceeding.object.port_order.primary = lds_proceeding.object.compute_portorder.primary

lnv_autoschedule = create n_autoschedule

if ll_new_proceedcount > 0 then
	if lnv_autoschedule.of_checkautoschedule_proceeding(al_vessel_nr, as_voyage_nr, ldt_tempdate) then
		lnv_autoschedule.of_get_proceed_poc(al_vessel_nr, ls_year)
	end if 
end if

if lds_proceeding.update() = 1 then
	COMMIT;
	ll_return = ll_new_proceedcount
	
	lnv_autoschedule.of_distancechanged(al_vessel_nr, as_voyage_nr, ls_year)
	
	//create estimate ports
	ll_proceed_count = lds_proceeding.rowcount()
	if ll_proceed_count > 0 then
		ls_port_code = lds_proceeding.getitemstring(ll_proceed_count, "port_code")
		ll_pcn = lds_proceeding.getitemnumber(ll_proceed_count, "pcn")
		ll_new_estcount = of_create_estpoc(al_vessel_nr, as_voyage_nr, ls_port_code, ll_pcn, 0)
		if ll_new_estcount < 0 then ll_return = c#return.Failure
	end if
else
	ll_return = c#return.Failure
	ls_error  = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", "Failed to create proceeding(s) automatically. ~r~n~r~n" + ls_error, stopsign!)
end if

destroy lds_list
destroy lnv_autoschedule
destroy lds_proceeding

return ll_return

end function

public subroutine documentation ();/********************************************************************
   n_auto_proceeding
   <OBJECT>		auto create proceeding and estimate ports	</OBJECT>
   <USAGE>		Suggest to use in w_proceeding_list window 
	            and w_voyage window			</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
		23/04/2012   CR2413       ZSW001        First Version
		02/11/2012   CR2962       JMY014        Add Instance Variables ib_autocreatepoc 
		24/11/2012   CR2870       ZSW001        Add auto generate status for arrival and departure column
		20/03/2013	 CR2658		  LHG008			 Add calc_cons_id
		23/09/2013	 CR2790		  WWA048			 Get the distance between two ports		
   </HISTORY>
********************************************************************/

end subroutine

on n_auto_proceeding.create
call super::create
this.inv_autoschedule=create inv_autoschedule
this.ids_calc_route=create ids_calc_route
this.ids_calc_itinerary=create ids_calc_itinerary
end on

on n_auto_proceeding.destroy
call super::destroy
destroy(this.inv_autoschedule)
destroy(this.ids_calc_route)
destroy(this.ids_calc_itinerary)
end on

type inv_autoschedule from n_autoschedule within n_auto_proceeding descriptor "pb_nvo" = "true" 
end type

on inv_autoschedule.create
call super::create
end on

on inv_autoschedule.destroy
call super::destroy
end on

type ids_calc_route from mt_n_datastore within n_auto_proceeding descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_route"
end type

on ids_calc_route.create
call super::create
end on

on ids_calc_route.destroy
call super::destroy
end on

type ids_calc_itinerary from mt_n_datastore within n_auto_proceeding descriptor "pb_nvo" = "true" 
string dataobject = "d_atobviac_calc_itinerary"
end type

on ids_calc_itinerary.create
call super::create
end on

on ids_calc_itinerary.destroy
call super::destroy
end on

