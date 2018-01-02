$PBExportHeader$n_approve_vesselmsg.sru
forward
global type n_approve_vesselmsg from mt_n_baseservice
end type
end forward

global type n_approve_vesselmsg from mt_n_baseservice
end type
global n_approve_vesselmsg n_approve_vesselmsg

type variables
n_validate_poc inv_validate_poc			//Validation
n_approve_cargo inv_approve_cargo		//Approve cargo
n_approve_heating inv_approve_heating	//Approve heating
n_autoschedule inv_autoschedule			//Auto schedule

mt_n_datastore 		ids_poc, ids_poc_est 		//Act. POC and Est. POC
mt_n_datastore			ids_claim, ids_heating_price	//Heating claim and price
mt_n_datastore			ids_proceed						//Proceed
mt_n_datefunctions	inv_date_utility				//Datetime util, it's a auto instanticated component
mt_n_stringfunctions	inv_stringfunctions        //String utils
mt_n_datastore			ids_vessel_bunker				//For update bunker stock

string	is_message_type
string	is_reporttype
integer	ii_sendmail_status

constant string	is_FORMAT_DATE_TIME = "dd-mm-yyyy hh:mm" //Date time format
constant string	is_DELIVERY = "DEL", is_REDELIVERY = "RED"

constant string is_POC_DATE_BEFORE = "There is already other port of call(s) registered at a time later than ${DATE} before this port."
constant string is_POC_DATE_AFTER = "There is already other port of call(s) registered at a time earlier than ${DATE} after this port."
constant string is_MOVE_ESTPOC_TO_ACTPOC = "Cannot move Port ${PORT_CODE} from Estimated to Actual when there is one or more Estimated POC before this."
constant string is_CREATE_ACTPOC = "Cannot create a new Actual POC for Port(${PORT_CODE}) because there is at least one Estimated POC before this."
constant string is_CREATE_ESTPOC = "Cannot create a new Estimated POC for Port(${PORT_CODE}) because there is at least one Actual POC after this."
constant string is_CREATE_ESTPOC_NEXT = "Cannot create a new Estimated POC for Next Port(${PORT_CODE}) because there is at least one Actual POC after this."
constant string is_EXIST_ACTPOC = "The actual POC already exists."
constant string is_EXIST_ACTPOC_NEXT = "The next port is registered as an Actual POC."
constant string is_EXIST_IN_PROCEEDING = "The port(${PORT_CODE}) does not exist in Proceeding."
constant string is_EXIST_IN_PROCEEDING_NEXT = "The next port(${PORT_CODE}) does not exist in Proceeding."
constant string is_ROB_ARRIVAL_PREVIOUS_DEPARTURE = "The arrival bunker value is greater than the departure bunker value of the previous port."
constant string is_ROB_DEPARTURE_ARRIVAL = "The departure bunker value is equal or greater than the arrival bunker value plus lifted bunker value."
constant string is_ROB_DEPARTURE_NEXT_ARRIVAL = "The departure bunker value is less than the arrival bunker value of the next port."
constant string is_APPROVE_NEXT_PORT = "Next port information is not approved."
constant string is_BERTHING_AFTER_ARRIVAL = "Berthing date must be after the arrival date."
constant string is_DEPARTURE_AFTER_ARRIVAL = "Departure date must be after the arrival date."
constant string is_DEPARTURE_AFTER_BERTHING = "Departure date must be after the berthing date."
constant string is_CONSUMPTION = "Bunker validation error: The bunker consumption is greater than the bunker on board."
constant string is_VALIDATE_BUNKER = "The departure bunker value is greater than the arrival bunker value plus lifted bunker value."
constant string is_VOYAGE_HEATING = "Heating claim cannot be created automatically because the voyage is not allocated to a calculation."
constant string is_CHARTERER_HEATING = "Heating claim cannot be created automatically because the voyage has more than one charterer. Please create manually in Claims."
constant string is_ACTUAL_POC = "The port is not registered as an Actual POC."
constant string is_PURPOSE_LOADING = "The port is not a Loading port in the calculation."
constant string is_PURPOSE_DISCHARGING = "The port is not a Discharging port in the calculation."
constant string is_CARGO = "No cargo has been registered for Voyage(${VOYAGE_NR}) in TRAMOS."
constant string is_NEXT_PORT_IS_EMPTY = "Next port does not exist."
constant string is_EXISTS_POC = "The POC for port(${PORT_CODE}) does not exist."
constant string is_NEXT_PORT_ARRISNULL = "The Arrival Date is empty for next port(${PORT_CODE})."
end variables

forward prototypes
public function integer of_approve_arrival (ref mt_u_datawindow adw_msps_arrival)
public function integer of_approve_position (ref mt_u_datawindow adw_msps_noon)
public function integer of_set_status (integer ai_status, string as_reason, ref mt_u_datawindow adw_msps_message)
public function integer of_get_poc_key (ref s_poc astr_poc, mt_u_datawindow adw_msps_message)
public function integer of_set_tug (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure)
public function integer of_set_slop (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message)
public function integer of_set_sludge (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message)
public function integer of_set_tank (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message)
public function integer of_set_draft (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure)
public function integer of_check_tc_contract (mt_u_datawindow adw_msps_message)
public function integer of_get_purpose_from_calculation (ref s_poc astr_poc)
public subroutine documentation ()
public function integer of_set_proceeding_vp (s_poc astr_poc)
public function integer of_get_purpose_from_calculation (ref s_poc astr_poc, integer ai_load_or_discharge)
public function integer of_check_position (s_poc astr_poc, datetime adt_arrival, ref mt_u_datawindow adw_msps_noon)
public function integer of_check_departure (integer ai_load_or_discharge, s_poc astr_poc, ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure)
public function integer of_set_docs (ref mt_n_datastore ads_poc, mt_u_datawindow adw_msps_departure)
public function integer of_approve_departure (ref mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_cargo)
public function integer of_check_proceeding_vp (ref s_poc astr_poc)
public function integer of_approve_estpoc_to_actpoc (ref mt_u_datawindow adw_msps_message)
public function integer of_set_message_type (string as_message_type)
public function integer of_initialize_variable ()
public function integer of_approve_heating (ref mt_u_datawindow adw_msps_heating, mt_u_datawindow adw_msps_heating_sum)
public function integer of_check_next_port (ref mt_u_datawindow adw_msps_message, s_poc astr_poc)
public function integer of_check_previous_estpoc (s_poc astr_poc)
public function integer of_get_next_poc_key (s_poc astr_poc_current, ref s_poc astr_poc_next)
public function integer of_setpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc)
public function integer of_check_estpoc_to_actpoc (s_poc astr_poc, datetime adt_arrival, ref mt_u_datawindow adw_msps_message)
public function integer of_check_common (ref mt_u_datawindow adw_msps_message, s_poc astr_poc, datetime adt_date)
public function integer of_setnextpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc)
public function integer of_update_message_poc (mt_u_datawindow adw_msps_message)
public function integer of_autoschedule (ref mt_n_datastore ads_poc, ref s_poc astr_poc, datetime adt_cur_etd, long al_seconds)
public function integer of_get_autoschedule_seconds (ref mt_n_datastore ads_poc, ref long al_seconds, ref datetime adt_cur_etd)
public function integer of_set_poc (mt_n_datastore ads_poc)
public function integer of_check_charterer (ref s_poc astr_poc)
public function integer of_get_next_poc_key (mt_n_datastore ads_poc, ref s_poc astr_poc)
public function integer of_checkpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc, ref datetime adt_arrival, datetime adt_berthing, datetime adt_departure, boolean ab_port_next)
public function integer of_checkpocdatetimes (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, boolean ab_port_next)
public function integer of_check_previous_poc_bunker (s_poc_bunker astr_poc_bunker)
public function integer of_check_current_poc_bunker (s_poc_bunker astr_poc_bunker)
public function integer of_check_poc_bunker (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, s_poc astr_poc, ref s_poc_bunker astr_poc_bunker)
public function integer of_get_current_poc_bunker (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, ref s_poc_bunker astr_poc_bunker)
public function integer of_get_next_poc_bunker (s_poc astr_poc, ref s_poc_bunker astr_poc_bunker)
public function integer of_check_next_poc_bunker (s_poc_bunker astr_poc_bunker)
public function integer of_set_poc_bunker (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc, s_poc astr_poc)
public function integer of_get_previous_poc_bunker (s_poc astr_poc, ref s_poc_bunker astr_poc_bunker)
public function integer _refresh_task_list (mt_n_datastore ads_poc, mt_n_datastore ads_poc_est)
public function integer of_create_actpoc (s_poc astr_poc, ref mt_n_datastore ads_act)
public function integer of_create_estpoc (s_poc astr_poc, ref mt_n_datastore ads_est)
public function integer of_get_previous_port (ref s_poc astr_poc)
public function integer of_check_arrival (mt_u_datawindow adw_msps_arrival, ref s_poc astr_poc, datetime adt_arrival)
public function integer of_get_next_estpoc (s_poc astr_poc, ref s_autoschedule astr_autoschedule)
public function integer of_est_to_act ()
public function integer of_isactualpocfollowingthis (s_poc astr_poc)
public function integer of_connecttccontract (mt_u_datawindow adw_msps_message)
public function integer of_set_rob_latest (mt_u_datawindow adw_msps_noon)
end prototypes

public function integer of_approve_arrival (ref mt_u_datawindow adw_msps_arrival);/********************************************************************
   of_approve_arrival
   <DESC>	Approve arrival message to TRAMOS assembly process	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_arrival: Arrival message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17-02-2012 CR20         JMY014             First Version
   	08/08/2013 CR3238       LHG008             Check/link TC contract for DEL and RED ports
   </HISTORY>
********************************************************************/

datetime ldt_arrival, ldt_departure
datetime ldt_cur_etd   					//Keep the modification of ETD datetime in the tow varibles
long		ll_seconds
integer	li_return
s_poc 	lstr_poc

of_initialize_variable()

//Get the approval key from report datawindow
of_get_poc_key(lstr_poc, adw_msps_arrival)

//Get the arrival datetime.
ldt_arrival = adw_msps_arrival.getitemdatetime(1, "arrival_date")

//After all checking processes succeeded, updated the necessary fields.
li_return = of_check_arrival(adw_msps_arrival, lstr_poc, ldt_arrival)
if li_return = c#return.NoAction then
	of_initialize_variable()
	return li_return
elseif li_return = c#return.Success then
	//Update ROB bunker to Act. POC
	if of_set_poc_bunker(adw_msps_arrival, ids_poc, lstr_poc) = c#return.Failure then
		of_initialize_variable()		
		return of_update_message_poc(adw_msps_arrival)
	end if	
	//Sludge
	of_set_sludge(ids_poc, adw_msps_arrival)
	//Slop
	of_set_slop(ids_poc, adw_msps_arrival)
	//Deck tank: Exclude the noon and heating report
	of_set_tank(ids_poc, adw_msps_arrival)
	of_set_status(c#msps.ii_APPROVED, "", adw_msps_arrival)
else
	of_set_status(c#msps.ii_FAILED, "", adw_msps_arrival)
	of_initialize_variable()
	return of_update_message_poc(adw_msps_arrival)
end if

//Get the interval according to the datetime modification on current Act. POC before updating process for auto schedule
of_get_autoschedule_seconds(ids_poc, ll_seconds, ldt_cur_etd)

//Update message status to be approved, estimate POC and actual POC
if of_update_message_poc(adw_msps_arrival) = c#return.Success then
	//Auto schedule process before updating the current port Est. POC to TRAMOS
	if uo_global.ib_pocautoschedule and ids_poc.rowcount() = 1 then
		if of_isactualpocfollowingthis(lstr_poc) = c#return.Failure then of_autoschedule(ids_poc, lstr_poc, ldt_cur_etd, ll_seconds)
	end if
else
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_approve_position (ref mt_u_datawindow adw_msps_noon);/********************************************************************
   of_approve_position
   <DESC>	Approve noon message to TRAMOS assembly process	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_noon
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21-02-2012 CR20         JMY014             First Version
		06-08-2013 CR3238			LHC010				 Modify the process for the noon(port) message.
   </HISTORY>
********************************************************************/

datetime ldt_arrival, ldt_eta_next_port, ldt_departure
datetime ldt_cur_etd
long		ll_seconds
s_poc	lstr_poc
mt_n_datastore lds_tmp

of_initialize_variable()

is_reporttype = lower(trim(adw_msps_noon.getitemstring(1, "report_type")))

//Get the approval key from report datawindow
ldt_arrival = adw_msps_noon.getitemdatetime(1, "arrival_date")
of_get_poc_key(lstr_poc, adw_msps_noon)

choose case is_reporttype
	case "sea"
		//After all checking processes succeeded, updated the necessary fields.
		if of_check_position(lstr_poc, ldt_arrival, adw_msps_noon) = c#return.Success then 
			//Check and set the arrival/berthing/departure datetime to Est. POC.
			if of_setpocdatetimes(adw_msps_noon, ids_poc_est) = c#return.Failure then
				of_initialize_variable()
				of_update_message_poc(adw_msps_noon)
				return c#return.Failure
			else
				//Get the interval according to the datetime modification on current Act. POC before updating process for auto schedule
				of_get_autoschedule_seconds(ids_poc_est, ll_seconds, ldt_cur_etd)				
			end if
			//Sluge(Fresh water only)
			of_set_sludge(ids_poc_est, adw_msps_noon)
			//Slop
			of_set_slop(ids_poc_est, adw_msps_noon)
			of_set_status(c#msps.ii_APPROVED, "", adw_msps_noon)
		else
			of_initialize_variable()
		end if
		of_set_rob_latest(adw_msps_noon)
	case "port"
		//when not exists Est. or Act. POC then failure.		
		if inv_validate_poc.of_exists_actpoc(lstr_poc, ids_poc) = c#return.Success then
			lds_tmp = ids_poc
			//When current port, update arrival/berthing/departure datetime to Est. POC		
		elseif inv_validate_poc.of_exists_estpoc(lstr_poc, ids_poc_est) = c#return.Success then
			lds_tmp = ids_poc_est
		else
			//when not exists Est. or Act. POC then failure.
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_EXISTS_POC, "${PORT_CODE}", lstr_poc.port_code), adw_msps_noon)

			of_initialize_variable()
			
			return of_update_message_poc(adw_msps_noon)			
		end if

		//Vertical checking POC: there should not be a POC datetime later than current Act. POC arrival datetime
		ldt_departure = adw_msps_noon.getitemdatetime(1, "departure_date")
		if inv_validate_poc.of_check_date_after(lstr_poc, ldt_departure) = c#return.Failure then
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_AFTER, "${DATE}", string(ldt_departure, is_FORMAT_DATE_TIME)), adw_msps_noon)
			return c#return.Failure
		end if		
		
		//Check and set the arrival/berthing/departure datetime to Est. POC.
		if of_setpocdatetimes(adw_msps_noon, lds_tmp) = c#return.Failure then
			of_initialize_variable()
			of_update_message_poc(adw_msps_noon)
			return c#return.Failure
		end if
		
		//Sluge(Fresh water only)
		of_set_sludge(lds_tmp, adw_msps_noon)
			
		//Slop
		of_set_slop(lds_tmp, adw_msps_noon)
		of_set_status(c#msps.ii_APPROVED, "", adw_msps_noon)
			
		//After succeeding, check and update next port.
		if of_update_message_poc(adw_msps_noon) = c#return.Success then
			ids_poc_est.reset()
			//Check the next port for transfering process
			if of_check_next_port(adw_msps_noon, lstr_poc) = c#return.Failure then
				ids_poc_est.reset()
				of_set_status(c#msps.ii_APPROVED, is_APPROVE_NEXT_PORT, adw_msps_noon)
			//Auto schedule process
			else
				of_set_rob_latest(adw_msps_noon)
				lstr_poc.voyage_nr = lds_tmp.getitemstring(1, "voyage_nr")
				lstr_poc.port_code = lds_tmp.getitemstring(1, "port_code")
				lstr_poc.pcn = lds_tmp.getitemnumber(1, "pcn")
				//Get the interval according to the datetime modification on next Act. POC before updating process for auto schedule
				of_get_autoschedule_seconds(lds_tmp, ll_seconds, ldt_cur_etd)
			end if
		else
			return c#return.Failure
		end if
end choose

//Update message, Est. POC and Act. POC
if of_update_message_poc(adw_msps_noon) = c#return.Success then
	//Auto schedule process before updating the current port Est. POC to TRAMOS
	if uo_global.ib_pocautoschedule and ids_poc_est.rowcount() = 1 then
		if of_isactualpocfollowingthis(lstr_poc) = c#return.Failure then of_autoschedule(ids_poc_est, lstr_poc, ldt_cur_etd, ll_seconds)
	end if
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_set_status (integer ai_status, string as_reason, ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_set_status
   <DESC>	Set approving status to messsage and sending mail status and 
				set transfering from vessel label to Est. POC and Act. POC
				1. Appending to the end of historical reason	
				2. Set sending mail status.
				3. Set transfering from vessel label to Est. POC and Act. POC
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_reason: Failed reason text
		adw_msps_message: Approval message report datawindow
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	21-02-2012 CR20         JMY014        First Version
		26-07-2013 CR3238			LHC010		  Reset proceed VP show
		08/04/2014 CR3599       LHG008        Local time issue
   </HISTORY>
********************************************************************/
string ls_reason
integer li_msgstatus

li_msgstatus = adw_msps_message.getitemnumber(1, "msg_status")

if adw_msps_message.setitem(1, "msg_status", ai_status) = -1 then return c#return.Failure

//Set transfering from vessel flag to Est. POC and Act. POC
if ai_status = c#msps.ii_APPROVED then
	if ids_poc.rowcount() = 1 then of_set_poc(ids_poc)
	if ids_poc_est.rowcount() = 1 then of_set_poc(ids_poc_est)
end if

//Set sending mail status to message
if as_reason <> "" then ii_sendmail_status = c#msps.ii_SENDMAIL

ls_reason = adw_msps_message.getitemstring(1, "rejection_reason")
if li_msgstatus = c#msps.ii_FAILED or li_msgstatus = c#msps.ii_APPROVED then
	//Reset proceed VP show
	if li_msgstatus = c#msps.ii_FAILED then ids_proceed.reset()
	if as_reason <> "" then
		if pos(ls_reason, as_reason) <= 0 then adw_msps_message.setitem(1, "rejection_reason", ls_reason + "~r~n" + as_reason)
	else
		adw_msps_message.setitem(1, "rejection_reason", ls_reason)
	end if
else
	adw_msps_message.setitem(1, "rejection_reason", as_reason)
end if

adw_msps_message.setitem(1, "approve_by", uo_global.is_userid)
adw_msps_message.setitem(1, "approve_date", datetime(today(), now()))
adw_msps_message.setitem(1, "server_approve_date", f_getdbserverdatetime())

return  c#return.Success
end function

public function integer of_get_poc_key (ref s_poc astr_poc, mt_u_datawindow adw_msps_message);/********************************************************************
   of_get_poc_key
   <DESC>	Get POC key info to a data structure from message datawindow	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC data structure
		adw_msps_message: Message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	20-02-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/

astr_poc.vessel_nr = adw_msps_message.getitemnumber(1, "vessel_nr")
if astr_poc.vessel_nr = -1 then return c#return.Failure
astr_poc.voyage_nr = adw_msps_message.getitemstring(1, "voyage_no")
if astr_poc.voyage_nr = "" then return c#return.Failure
astr_poc.port_code = adw_msps_message.getitemstring(1, "port_code")
if astr_poc.port_code = "" then return c#return.Failure
astr_poc.pcn = adw_msps_message.getitemnumber(1, "pcn")

return c#return.Success
end function

public function integer of_set_tug (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure);/********************************************************************
   of_set_tug
   <DESC>	Set tug data to POC from departure message	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: POC datastore
		adw_msps_departure: Departure datawindow
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if ads_poc.rowcount() = 1 then
	ads_poc.setitem(1, "tugs_in", adw_msps_departure.getitemnumber(1, "arrival_number_used"))
	ads_poc.setitem(1, "tugs_shifting", adw_msps_departure.getitemnumber(1, "shifting_number_used"))
	ads_poc.setitem(1, "tugs_out", adw_msps_departure.getitemnumber(1, "departure_number_used"))
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_set_slop (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_set_slop
   <DESC>	Set slop to POC from message report	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc:POC datastore
		adw_msps_message: Message report
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
ads_poc.setitem(1, "tank_name", adw_msps_message.getitemstring(1, "stock_dirty_water_tank_name"))
ads_poc.setitem(1, "slop", adw_msps_message.getitemnumber(1, "compute_dirty_water"))
ads_poc.setitem(1, "oil", adw_msps_message.getitemnumber(1, "stock_dirty_water_quantity_oily"))

return c#return.Success
end function

public function integer of_set_sludge (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_set_sludge
   <DESC>	Set sludge data to POC from message report	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: POC
		adw_msps_message: Message
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

if ads_poc.setitem(1, "fresh_water", adw_msps_message.getitemnumber(1, "stock_fresh_water_quantity")) = -1 then return c#return.Failure

return c#return.Success
end function

public function integer of_set_tank (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_set_tank
   <DESC>	Approve tank data to TRAMOS	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: POC datastore
		adw_msps_message: Message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if	ads_poc.setitem(1, "dt_t_1", adw_msps_message.getitemstring(1, "deck_tank_1_grade")) = -1 then return c#return.Failure
if	ads_poc.setitem(1, "dt_v_1", adw_msps_message.getitemnumber(1, "deck_tank_1_quantity")) = -1 then return c#return.Failure
if	ads_poc.setitem(1, "dt_t_2", adw_msps_message.getitemstring(1, "deck_tank_2_grade")) = -1 then return c#return.Failure
if	ads_poc.setitem(1, "dt_v_2", adw_msps_message.getitemnumber(1, "deck_tank_2_quantity")) = -1 then return c#return.Failure
if	ads_poc.setitem(1, "tank_name", adw_msps_message.getitemstring(1, "stock_dirty_water_tank_name")) = -1 then return c#return.Failure
return c#return.Success
end function

public function integer of_set_draft (ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure);/********************************************************************
   of_set_draft
   <DESC>	Set draft to POC from message	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: POC
		adw_msps_departure: Message
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if ads_poc.setitem(1, "arr_for_draft", adw_msps_departure.getitemnumber(1, "draught_arrival_fwd")) = -1 then return c#return.Failure
if ads_poc.setitem(1, "arr_aft_draft", adw_msps_departure.getitemnumber(1, "draught_arrival_aft")) = -1 then return c#return.Failure
if ads_poc.setitem(1, "dept_for_draft", adw_msps_departure.getitemnumber(1, "draught_departure_aft")) = -1 then return c#return.Failure
if ads_poc.setitem(1, "dept_aft_draft", adw_msps_departure.getitemnumber(1, "draught_departure_fwd")) = -1 then return c#return.Failure
return c#return.Success
end function

public function integer of_check_tc_contract (mt_u_datawindow adw_msps_message);/********************************************************************
   of_check_tc_contract
   <DESC>	Check the contract. If the POC already linked to an existent TC contract, then check ATA/ETD, 
			else call function of_connecttccontract() try to link to an existent TC contract.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: MSPS message datawindow
   </ARGS>
   <USAGE>
			 Dependent MSPS messages
			 Arrival/Canal/FWO/Drift
 
          Called from of_check_arrival()/of_check_estpoc_to_actpoc()
	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		05/03/2012	CR20		JMY014	First Version
		08/08/2013	CR3238	LHG008	Check/link TC contract for DEL and RED ports
		17/10/2013  CR3340	LHG008	Modify message
   </HISTORY>
********************************************************************/

long		ll_contractid
integer	li_return
string	ls_purpose
datetime	ldt_arrival_departure, ldt_contract_arrival_departure

ll_contractid	= ids_poc.getitemnumber(1,"contract_id")
ls_purpose = ids_poc.getitemstring(1, "purpose_code")

//If the purpose is not DEL/RED, return Success and continue process.
if ls_purpose <> is_DELIVERY and ls_purpose <> is_REDELIVERY then return c#return.Success

//Try to link a TC contract if it didn't link to a TC contract
if isnull(ll_contractid) then
	li_return = of_connecttccontract(adw_msps_message)
	if li_return <> c#return.Success then //NoAction/Failure
		return li_return
	end if
end if

if ls_purpose = is_DELIVERY then		/* For delivery, check arrival date */
	ldt_arrival_departure = adw_msps_message.getitemdatetime(1, "arrival_date")
	ldt_contract_arrival_departure = ids_poc.getitemdatetime(1, "port_arr_dt")
	if ldt_arrival_departure <> ldt_contract_arrival_departure then
		of_set_status(c#msps.ii_FAILED, "This is a DEL port of call, ATA doesn't match with the delivery date in the TC contract.", adw_msps_message)
		return c#return.Failure
	end if
else  /* For re-delivery, check departure date */
	ldt_arrival_departure = adw_msps_message.getitemdatetime(1, "departure_date")
	ldt_contract_arrival_departure = ids_poc.getitemdatetime(1, "port_dept_dt")
	if ldt_arrival_departure <> ldt_contract_arrival_departure then
		of_set_status(c#msps.ii_FAILED, "This is a RED port of call, ETD does not match the last period end date in the TC contract.", adw_msps_message)
		return c#return.Failure
	end if
end if

return c#return.Success
end function

public function integer of_get_purpose_from_calculation (ref s_poc astr_poc);/********************************************************************
   of_get_purpose_from_calculation
   <DESC>Get purpose from calculation for allocated voyage	
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	05-03-2012 CR20         JMY014        First Version
		26-05-2013 CR3238			LHC010		  Fix UAT1 and code review for delivery 1.
   </HISTORY>
********************************************************************/
string ls_purpose_code
long	ll_count, ll_find
mt_n_datastore lds_calcpurpose

//When TC out, the calculation Id equal 1.
if astr_poc.cal_calc_id <= 1 then 
	if len(astr_poc.purpose) <= 0 or isnull(astr_poc.purpose) then astr_poc.purpose = "TFV"
	return c#return.Success
end if

lds_calcpurpose = create mt_n_datastore
lds_calcpurpose.dataobject = "d_sp_gr_get_calcpurpose"
lds_calcpurpose.settrans(sqlca)
ll_count = lds_calcpurpose.retrieve(astr_poc.cal_calc_id)

if ll_count > 0 then 
	ll_find = lds_calcpurpose.find("proceed_portcode = '" + astr_poc.port_code + "' and pcn = " + string(astr_poc.pcn), 1, ll_count)
	if ll_find > 0 then
		ls_purpose_code = lds_calcpurpose.getitemstring(ll_find, "calc_purposecode")
	end if
end if

if ls_purpose_code <> "" then 
	astr_poc.purpose = ls_purpose_code
	return c#return.Success
end if

return c#return.Failure
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Messages approval component	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	05-03-2012 CR20         JMY014        First Version
   	17-06-2013 CR3238       LHC010        Fix bug for UAT2
   	05/08/2013 CR3238       LHG008        Code review
   	26/08/2013 CR3286       LHG008        Add MSPS setup
   	17/10/2013 CR3340			LHG008		  Modify message
   	13/03/2014 CR3340UAT		LHG008		  Change date format in the message box(Remove the second)
   	08/04/2014 CR3599       LHG008		  Local time issue
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_set_proceeding_vp (s_poc astr_poc);/********************************************************************
   of_set_proceeding_vp
   <DESC>	Set proceeding show VP to be enabled.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE>	Keeping commit consistancy in message updating process	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	06-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if ids_proceed.rowcount() = 1 then ids_proceed.setitem(1, "show_vp", astr_poc.show_vp)

return c#return.Success
end function

public function integer of_get_purpose_from_calculation (ref s_poc astr_poc, integer ai_load_or_discharge);/********************************************************************
   of_get_purpose_from_calculation
   <DESC>	Get purpose code from the allocated calculation 	
				If is a TC-OUT, there is no CAL_CALC_ID, so geting purpose failed,
				by default, the purpose would not be changed.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC structure
		as_load_or_discharge:Load or discharge flag
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-02-2012 CR20           JMY014        First Version
   </HISTORY>
********************************************************************/
string ls_purpose_code, ls_purpose

//When TC out, the calculation Id equal 1.
if astr_poc.cal_calc_id <= 1 then 
	if len(astr_poc.purpose) <= 0 or isnull(astr_poc.purpose) then astr_poc.purpose = "TFV"
	return c#return.Success
end if
 
if ai_load_or_discharge = c#msps.ii_DISCHARGE then ls_purpose = "D"
if ai_load_or_discharge = c#msps.ii_LOAD then ls_purpose = "L"

SELECT PURPOSE_CODE
INTO   :ls_purpose_code
FROM   CAL_ROUTE b
WHERE  b.CAL_CALC_ID  = :astr_poc.cal_calc_id
AND    b.PORT_CODE    = :astr_poc.port_code
AND    (b.PURPOSE_CODE = :ls_purpose or b.PURPOSE_CODE = 'L/D');

if sqlca.sqlcode = 0 and sqlca.sqlnrows = 1 then
	if ls_purpose_code = "L/D" then
		astr_poc.purpose = ls_purpose_code
		return c#return.Success
	elseif (ls_purpose = ls_purpose_code and ls_purpose_code = "D") then
		astr_poc.purpose = "D"
		return c#return.Success
	elseif (ls_purpose = ls_purpose_code and ls_purpose_code = "L") then
		astr_poc.purpose = "L"
		return c#return.Success
	end if
end if

return c#return.Failure

end function

public function integer of_check_position (s_poc astr_poc, datetime adt_arrival, ref mt_u_datawindow adw_msps_noon);/********************************************************************
   of_check_position
   <DESC>	Check noon message approval process	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc:POC
		adt_arrival: Arrival date time
		adw_msps_noon: Noon message
   </ARGS>
   <USAGE>	Only create or update the Est. POC	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	06-03-2012 CR20         JMY014        First Version
		06-08-2013 CR3238			LHC010		  Modify the process for the noon(port) message.
   </HISTORY>
********************************************************************/
datetime ldt_departure

//Implement the common check process
if of_check_common(adw_msps_noon, astr_poc, adt_arrival) = c#return.Failure then return c#return.Failure

//Vertical checking POC: there should not be a POC datetime later than current Act. POC arrival datetime
ldt_departure = adw_msps_noon.getitemdatetime(1, "departure_date")
if inv_validate_poc.of_check_date_after(astr_poc, ldt_departure) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_AFTER, "${DATE}", string(ldt_departure, is_FORMAT_DATE_TIME)), adw_msps_noon)
	return c#return.Failure
end if

//There should be no Act. POC.
if inv_validate_poc.of_exists_actpoc(astr_poc) = c#return.Success then
	of_set_status(c#msps.ii_FAILED, is_EXIST_ACTPOC, adw_msps_noon)
	return c#return.Failure
end if

//The Est. POC does not exist
if inv_validate_poc.of_exists_estpoc(astr_poc, ids_poc_est) = c#return.Failure then
	//Check proceeding:exits
	if inv_validate_poc.of_exists_proceeding(astr_poc) = c#return.Success then
		//Check following Act. POC, there should be no following Act. POC for Est. POC creation
		if of_isactualpocfollowingthis(astr_poc) = c#return.Failure then
			//Create Est. POC and set purpose to be TFV
			of_create_estpoc(astr_poc, ids_poc_est)
			astr_poc.purpose = "TFV"

			//Get purpose from calculation if the voyage is allocated 
			if inv_validate_poc.of_is_allocated(astr_poc) = c#return.Success then of_get_purpose_from_calculation(astr_poc)
			
			ids_poc_est.setitem(1, "purpose_code", astr_poc.purpose)

			//Show VP check
			if of_check_proceeding_vp(astr_poc) = c#return.Success then of_set_proceeding_vp(astr_poc)
		else
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_CREATE_ESTPOC, "${PORT_CODE}", astr_poc.port_code), adw_msps_noon)
			return c#return.Failure
		end if
	//Proceeding exists.
	else
		of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_EXIST_IN_PROCEEDING, "${PORT_CODE}", astr_poc.port_code), adw_msps_noon)
		return c#return.Failure
	end if
end if

return c#return.Success

end function

public function integer of_check_departure (integer ai_load_or_discharge, s_poc astr_poc, ref mt_n_datastore ads_poc, ref mt_u_datawindow adw_msps_departure);/********************************************************************
   of_check_departure
   <DESC>	Check load/discharge approval rule	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_
		astr_poc: POC structure
		ads_poc: Actual POC datastore
		adw_msps_departure: Message datawindow
   </ARGS>
   <USAGE>	The departure POC must be a Act. POC	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	28-02-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
datetime ldt_departure

ldt_departure = adw_msps_departure.getitemdatetime(1, "departure_date")

//Implement the common check process
if of_check_common(adw_msps_departure, astr_poc, ldt_departure) = c#return.Failure then return c#return.Failure

//The departure POC must be a Act. POC
if inv_validate_poc.of_exists_actpoc(astr_poc, ads_poc) = c#return.Success then
	astr_poc.purpose = ads_poc.getitemstring(1, "purpose_code")
	//Voyage is not allocated to a calculation
	if inv_validate_poc.of_is_allocated(astr_poc) = c#return.Success then
		//Get the purpoes from calculation
		if of_get_purpose_from_calculation(astr_poc, ai_load_or_discharge) = c#return.Success then
			if astr_poc.purpose <> "TFV" then ads_poc.setitem(1, "purpose_code", astr_poc.purpose)
		else
			if ai_load_or_discharge = c#msps.ii_DISCHARGE then of_set_status(c#msps.ii_FAILED, is_PURPOSE_DISCHARGING, adw_msps_departure)
			if ai_load_or_discharge = c#msps.ii_LOAD then of_set_status(c#msps.ii_FAILED, is_PURPOSE_LOADING, adw_msps_departure)
			return c#return.Failure
		end if
	end if	
else
	of_set_status(c#msps.ii_FAILED, is_ACTUAL_POC, adw_msps_departure)
	return c#return.Failure
end if

//Horizontal check the arrival/berthing/departure datetime.
return of_checkpocdatetimes(adw_msps_departure, ids_poc, false)
end function

public function integer of_set_docs (ref mt_n_datastore ads_poc, mt_u_datawindow adw_msps_departure);/********************************************************************
   of_set_doc
   <DESC>	Set docs to POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc:POC
		adw_msps_departure:Message
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if ads_poc.setitem(1, "lops_issued", adw_msps_departure.getitemnumber(1, "number_of_protests_issued")) = -1 then return c#return.Failure
if ads_poc.setitem(1, "lops_received", adw_msps_departure.getitemnumber(1, "number_of_protests_received")) = -1 then return c#return.Failure
if ads_poc.setitem(1, "nor_tendered", adw_msps_departure.getitemnumber(1, "number_of_nor")) = -1 then return c#return.Failure

return c#return.Success
end function

public function integer of_approve_departure (ref mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_cargo);/********************************************************************
   of_approve_discharge
   <DESC>	Approve load or discharge message to TRAMOS </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, fail </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_departure: departure(load or discharge) message
		adw_cargo: cargo and BOL message
   </ARGS>
   <USAGE> </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/02/2012 CR20         JMY014             First Version
   	05/08/2013 CR3238       LHG008             Code review
   	26/08/2013 CR3286       LHG008             Add MSPS setup
   </HISTORY>
********************************************************************/

long		ll_seconds
datetime	ldt_cur_etd
integer	li_load_or_discharge
s_poc 	lstr_poc

//Reset poc and poc_est datastore
of_initialize_variable()

//Get the approval key from report datawindow
of_get_poc_key(lstr_poc, adw_msps_departure)

//li_load_or_discharge: 1 presents load message, 0 presents discharge message
if is_message_type = c#msps.is_LOAD then
	li_load_or_discharge = c#msps.ii_LOAD
else
	li_load_or_discharge = c#msps.ii_DISCHARGE
end if

//Check departure approval rule
if of_check_departure(li_load_or_discharge, lstr_poc, ids_poc, adw_msps_departure) = c#return.Success then
	//Check and set the arrival/berthing/departure datetime to Act. POC.
	if of_setpocdatetimes(adw_msps_departure, ids_poc) = c#return.Failure then
		ids_poc.reset()
		of_update_message_poc(adw_msps_departure)
		return c#return.Failure
	end if

	//Update ROB bunker to Act. POC
	if of_set_poc_bunker(adw_msps_departure, ids_poc, lstr_poc) = c#return.Failure then
		ids_poc.reset()
		of_update_message_poc(adw_msps_departure)
		return c#return.Failure
	end if
	//Tug
	of_set_tug(ids_poc, adw_msps_departure)
	//Slop
	of_set_slop(ids_poc, adw_msps_departure)
	//Fresh water
	of_set_sludge(ids_poc, adw_msps_departure)
	//Draft
	of_set_draft(ids_poc, adw_msps_departure)
	//Docs
	of_set_docs(ids_poc, adw_msps_departure)
	//Tank
	of_set_tank(ids_poc, adw_msps_departure)
	of_set_status(c#msps.ii_APPROVED, "", adw_msps_departure)
else
	of_set_status(c#msps.ii_FAILED, "", adw_msps_departure)
	ids_poc.reset()
	return of_update_message_poc(adw_msps_departure)
end if

//Get the interval according to the datetime modification on current Act. POC before updating process for auto schedule
of_get_autoschedule_seconds(ids_poc, ll_seconds, ldt_cur_etd)

//After update the appvoving process, do auto schedule and cargo approving proecess
if of_update_message_poc(adw_msps_departure) = c#return.Success then
	//Auto schedule process before updating the current port Act. POC to TRAMOS
	if uo_global.ib_pocautoschedule and ids_poc.rowcount() = 1 then
		if of_isactualpocfollowingthis(lstr_poc) = c#return.Failure then of_autoschedule(ids_poc, lstr_poc, ldt_cur_etd, ll_seconds)
	end if
	
	if (is_message_type = c#msps.is_LOAD and uo_global.ib_msps_loadcargo) &
		or (is_message_type = c#msps.is_DISCHARGE and uo_global.ib_msps_dischargecargo) then
		//Cargo approving process
		inv_approve_cargo.of_approve_cargo(adw_msps_departure, adw_cargo, li_load_or_discharge)
		ii_sendmail_status = inv_approve_cargo.ii_sendmail_status
	end if
else
	return c#return.Failure
end if

return c#return.Success 
end function

public function integer of_check_proceeding_vp (ref s_poc astr_poc);/********************************************************************
   of_check_proceeding_vp
   <DESC>	Check if the current port is VP port, and get the value from DB	
				When the viapoint exists, return success for updating show VP
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
				<LI> c#noaction, if the show vp is checked, no need update proceeding
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC structure
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	29-02-2012 CR20         JMY014        First Version
		20-08-2013 CR3238			LHC010		  Fix bug when show vp is null
   </HISTORY>
********************************************************************/
long ll_rowcount, ll_show_vp

ll_rowcount = ids_proceed.retrieve(astr_poc.vessel_nr, astr_poc.voyage_nr, astr_poc.port_code, astr_poc.pcn)

if ll_rowcount = 1 then
	ll_show_vp = ids_proceed.getitemnumber(1, "show_vp")
	if isnull(ll_show_vp) or ll_show_vp = 0 then 
		astr_poc.show_vp = 1
		return c#return.success
	else
		return  c#return.NoAction
	end if
else
	return c#return.failure
end if



end function

public function integer of_approve_estpoc_to_actpoc (ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_approve_canal
   <DESC>	Approve message to TRAMOS assembly process	
				1. The current port Est. POC exist, move it to be Act. POC
				2. Update current port Act. POC only.
				3. Check the next port Est. POC, and update estimated time to it only.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: Canal and FWO message datawindow
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/02/2012 CR20         JMY014             First Version
   	05/08/2013 CR3238       LHG008             1. Code review. 2. check/link TC contract for DEL and RED ports
   </HISTORY>
********************************************************************/

datetime ldt_arrival, ldt_departure, ldt_eta_next_port
datetime ldt_cur_etd, ldt_cur_etd_next_port 					//Keep the modification of ETD datetime in the tow varibles
long		ll_seconds, ll_seconds_next_port
integer	li_return
s_poc		lstr_poc, lstr_poc_next_port
s_autoschedule lstr_autoschedule

if is_message_type = c#msps.is_CANAL then
	lstr_poc.purpose = "CAN"
elseif is_message_type = c#msps.is_FWODRIFT then
	lstr_poc.purpose = "FWO"
else
	return c#return.Failure
end if

//Get the approval key from report datawindow
of_get_poc_key(lstr_poc, adw_msps_message)

//Get the arrival datetime.
ldt_arrival = adw_msps_message.getitemdatetime(1, "arrival_date")

//After all checking processes succeeded, updated the necessary fields.
li_return = of_check_estpoc_to_actpoc(lstr_poc, ldt_arrival, adw_msps_message)
if li_return = c#return.NoAction then
	of_initialize_variable()
	return li_return
elseif li_return = c#return.Success then
	//Update ROB bunker to Act. POC
	if of_set_poc_bunker(adw_msps_message, ids_poc, lstr_poc) = c#return.Failure then
		of_initialize_variable()
		//Updated the failure message only
		of_update_message_poc(adw_msps_message)
		return c#return.Failure
	end if
	//Sludge(Fresh water)
	of_set_sludge(ids_poc, adw_msps_message)
	//Slop
	of_set_slop(ids_poc, adw_msps_message)
	//Deck tank
	of_set_tank(ids_poc, adw_msps_message)
	//Update message, Est. POC and Act. POC
	of_set_status(c#msps.ii_APPROVED, "", adw_msps_message)
	//Get the interval according to the datetime modification on current Act. POC before updating process for auto schedule
	of_get_autoschedule_seconds(ids_poc, ll_seconds, ldt_cur_etd)
	//Update current Act. POC first, then check and update next port Est. POC
	if of_update_message_poc(adw_msps_message) = c#return.Success then
		//Check the next port for transfering process
		ids_poc_est.reset()
		if of_check_next_port(adw_msps_message, lstr_poc) = c#return.Failure then
			of_set_status(c#msps.ii_APPROVED, is_APPROVE_NEXT_PORT, adw_msps_message)
			return c#return.Failure
		end if
		//Get next Est. POC key
		of_get_next_poc_key(ids_poc_est, lstr_poc_next_port)
		//Get the interval according to the datetime modification on next Act. POC before updating process for auto schedule
		of_get_autoschedule_seconds(ids_poc_est, ll_seconds_next_port, ldt_cur_etd_next_port)
		//Only update the Est. POC of the next port
		if of_update_message_poc(adw_msps_message) = c#return.Success then
			//Autoschedule switch
			if uo_global.ib_pocautoschedule and ids_poc_est.rowcount() = 1 then
				//Auto schedule process before updating the next port Est. POC to TRAMOS
				 of_autoschedule(ids_poc_est, lstr_poc_next_port, ldt_cur_etd_next_port, ll_seconds_next_port)
			end if
		else
			//Auto schedule process before updating the current port Est. POC to TRAMOS
			if uo_global.ib_pocautoschedule and (of_isactualpocfollowingthis(lstr_poc) = c#return.Failure) and ids_poc.rowcount() = 1 then of_autoschedule(ids_poc, lstr_poc, ldt_cur_etd, ll_seconds)
		end if
	else
		return c#return.Failure
	end if
else
	//Only updated the failed message
	of_initialize_variable()
	of_update_message_poc(adw_msps_message)
	return c#return.Failure
end if

//Update message status to be approved, Est. POC and Act. POC
return c#return.Success
end function

public function integer of_set_message_type (string as_message_type);/********************************************************************
   of_set_message_type
   <DESC>	Set message type from outside of this component	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_message_type
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
this.is_message_type = as_message_type

return c#return.Success
end function

public function integer of_initialize_variable ();/********************************************************************
   of_initialization
   <DESC>	Initial the parameters and functions	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
//Act. POC or Est. POC
ids_poc.reset()
ids_poc_est.reset()

return c#return.Success
end function

public function integer of_approve_heating (ref mt_u_datawindow adw_msps_heating, mt_u_datawindow adw_msps_heating_sum);/********************************************************************
   of_approve_heating
   <DESC>	Approve heating message to TRAMOS assembly process	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_heating: Heating report datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21-02-2012 CR20         JMY014             First Version
   	24-03-2012 CR20			RJH022             add code for creating heating
   	31-03-2012 CR20			JMY014             Message value changed to constant variable
   	30-05-2013 CR3238			LHC010             map cargo heating hours from last updated heating message to claims window along with consumption
   </HISTORY>
********************************************************************/

long ll_claim_count, ll_row
s_poc lstr_poc
s_consumption lstr_consumption

of_initialize_variable()
//Get the approval heating consumption from report datawindow
lstr_consumption.dma = adw_msps_heating_sum.getitemdecimal(1, "compute_dma01")
lstr_consumption.go = adw_msps_heating_sum.getitemdecimal(1, "compute_go")
lstr_consumption.hfo = adw_msps_heating_sum.getitemdecimal(1, "compute_hfo")
lstr_consumption.lshfo = adw_msps_heating_sum.getitemdecimal(1, "compute_lshfo")
lstr_consumption.hours = adw_msps_heating_sum.getitemdecimal(1, "compute_hours")

//Get the approval key from report datawindow
of_get_poc_key(lstr_poc, adw_msps_heating)

//If proceeding is not allocated to a calculation, approval failed
if inv_validate_poc.of_is_allocated(lstr_poc) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, is_VOYAGE_HEATING, adw_msps_heating)
	of_update_message_poc(adw_msps_heating) 
	return c#return.Failure
end if

//Validate consumption
if inv_approve_heating.of_validate_heating_consumption(lstr_poc, lstr_consumption) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, is_CONSUMPTION, adw_msps_heating)
	of_update_message_poc(adw_msps_heating) 
	return c#return.Failure
end if

//If more than one charterer, achive message
if of_check_charterer(lstr_poc) = c#return.Failure then
	of_set_status(c#msps.ii_ARCHIVE, is_CHARTERER_HEATING, adw_msps_heating)
	of_update_message_poc(adw_msps_heating) 
	setnull(ii_sendmail_status)
	return c#return.Failure
else
	//if msps heating claims exist, update the heating claims
	if inv_approve_heating.of_exists_heatingclaims(lstr_poc) = c#return.Success then
		ll_claim_count = ids_claim.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.chart_nr, lstr_poc.claim_nr)
		ll_row = ids_heating_price.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.chart_nr, lstr_poc.claim_nr)
	else//if msps heating claims does not exist, add a new heating claim
		ll_claim_count = ids_claim.insertrow(0)
		ll_row = ids_heating_price.insertrow(0)
	end if
	//Consumption
	if inv_approve_heating.of_get_consumption(lstr_consumption, lstr_poc) = c#return.Failure then 
		of_set_status(c#msps.ii_FAILED, "", adw_msps_heating)
		of_update_message_poc(adw_msps_heating) 
		return c#return.Failure
	else
		inv_approve_heating.of_set_consumption(ll_row, lstr_poc, lstr_consumption, ids_heating_price)
	end if
	//Heating
	if inv_approve_heating.of_set_heating_claims(adw_msps_heating, ll_claim_count, lstr_poc, lstr_consumption, ids_claim, ids_heating_price) = c#return.Failure then
		of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_CARGO, "${VOYAGE_NR}", lstr_poc.voyage_nr), adw_msps_heating)
		of_update_message_poc(adw_msps_heating) 
		return  c#return.Failure  
	end if
end if


of_set_status(c#msps.ii_APPROVED, "", adw_msps_heating)
of_update_message_poc(adw_msps_heating) 

ids_claim.accepttext()
ids_heating_price.accepttext()
adw_msps_heating.accepttext()

if adw_msps_heating.update() = 1 then
	if ids_claim.update() = 1 then
		if ids_heating_price.update() = 1 then
			commit using sqlca;
			return c#return.Success
		else
			rollback using sqlca;
			return  c#return.Failure 
		end if
	else
		rollback using sqlca;
		return  c#return.Failure  
	end if
else
	rollback using sqlca;
	return  c#return.Failure  
end if



end function

public function integer of_check_next_port (ref mt_u_datawindow adw_msps_message, s_poc astr_poc);/********************************************************************
   of_check_next_port
   <DESC>	Check next port on canal/fwo/position and update estimated date to Est. POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		adt_eta
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	13-03-2012 CR20         JMY014        First Version
		26-07-2013 CR3238			LHC010		  Fix if the next port is empty then return failure
   </HISTORY>
********************************************************************/
s_poc 	lstr_poc_next_port
datetime ldt_eta_next_port

//Get next port code from message
lstr_poc_next_port.port_code = adw_msps_message.getitemstring(1, "next_port_code")

//Validate the next port
if isnull(lstr_poc_next_port.port_code) or len(lstr_poc_next_port.port_code) <= 0 then
	of_set_status(c#msps.ii_APPROVED, is_NEXT_PORT_IS_EMPTY, adw_msps_message)
	return c#return.Failure	
end if

//Get next port key
if of_get_next_poc_key(astr_poc, lstr_poc_next_port) = c#return.Failure then
	of_set_status(c#msps.ii_APPROVED, inv_stringfunctions.of_replace(is_EXIST_IN_PROCEEDING_NEXT, "${PORT_CODE}", lstr_poc_next_port.port_code), adw_msps_message)
	return c#return.Failure
end if

if is_message_type = c#msps.is_NOON then
	ldt_eta_next_port = adw_msps_message.getitemdatetime(1, "arrival_date")
else
	ldt_eta_next_port = adw_msps_message.getitemdatetime(1, "eta_next_port_date_lt")
end if

if isnull(ldt_eta_next_port) then 
	of_set_status(c#msps.ii_APPROVED, inv_stringfunctions.of_replace(is_NEXT_PORT_ARRISNULL, "${PORT_CODE}", lstr_poc_next_port.port_code), adw_msps_message)
	return c#return.Failure
end if	

//Implement the common check process for estimated arrival datetime of next port
if of_check_common(adw_msps_message, lstr_poc_next_port, ldt_eta_next_port) = c#return.Failure then return c#return.Failure

//If the next port Est. POC does not exist, create a new next Est. POC
if inv_validate_poc.of_exists_estpoc(lstr_poc_next_port, ids_poc_est) = c#return.Failure then
	//The Act. POC should not be exist.
	if inv_validate_poc.of_exists_actpoc(lstr_poc_next_port) = c#return.Failure then
		//Check the proceeding existance for the creation of next Est. POC
		if inv_validate_poc.of_exists_proceeding(lstr_poc_next_port) = c#return.Success then
			//Check if the following Act. POC exists after the next port
			if of_isactualpocfollowingthis(lstr_poc_next_port) = c#return.Success then
				of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_CREATE_ESTPOC_NEXT, "${PORT_CODE}", lstr_poc_next_port.port_code), adw_msps_message)	
				return c#return.Failure
			end if
			//Create the next port Est. POC
			of_create_estpoc(lstr_poc_next_port, ids_poc_est)
			
			lstr_poc_next_port.purpose = "TFV"
			//Get purpose from calculation if the voyage is allocated
			if inv_validate_poc.of_is_allocated(lstr_poc_next_port) = c#return.Success then 
				if of_get_purpose_from_calculation(lstr_poc_next_port) = c#return.Success then ids_poc_est.setitem(1, "purpose_code", lstr_poc_next_port.purpose)
			end if
		else
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_EXIST_IN_PROCEEDING_NEXT, "${PORT_CODE}", lstr_poc_next_port.port_code), adw_msps_message)	
			return c#return.Failure
		end if
	else
		of_set_status(c#msps.ii_FAILED, is_EXIST_ACTPOC_NEXT, adw_msps_message)	
		return c#return.Failure
	end if
	//Show VP check
	if of_check_proceeding_vp(lstr_poc_next_port) = c#return.Success then of_set_proceeding_vp(lstr_poc_next_port)
end if

//The next port Est. POC exists, check and set arrival/berthing/departure date time to Est. POC
if of_setnextpocdatetimes(adw_msps_message, ids_poc_est) = c#return.Failure then return c#return.Failure

//Set created by and TFV label
of_set_poc(ids_poc_est)

return c#return.Success
end function

public function integer of_check_previous_estpoc (s_poc astr_poc);/********************************************************************
   of_check_previous_estpoc
   <DESC>	Check there is one or more Est. POC before the current Act. POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: There is Est. POC before the current Est. POC
            <LI> c#return.Failure, There is no Est. POC before the current Est. POC	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc:POC important keys
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	29-02-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
long		ll_count
datetime ldt_proc_date

//Initialize the variables to be null
setnull(ll_count)
setnull(ldt_proc_date)

// Get PROC_DATE from PROCEED
SELECT PROC_DATE
INTO :ldt_proc_date
FROM PROCEED
WHERE (PROCEED.VESSEL_NR = :astr_poc.vessel_nr)
AND (PROCEED.PORT_CODE = :astr_poc.port_code)
AND (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr)
AND (PROCEED.PCN = :astr_poc.pcn);

//Get previous Est. POCs count.
if not isnull(ldt_proc_date) then
	SELECT count(PROCEED.VESSEL_NR)
	INTO   :ll_count
	FROM   POC_EST, PROCEED
	WHERE  PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
			 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
			 PROCEED.PCN = POC_EST.PCN AND
			 PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
			((SUBSTRING(PROCEED.VOYAGE_NR, 1, 2) < '90' AND PROCEED.VOYAGE_NR < :astr_poc.voyage_nr)
			OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE < :ldt_proc_date)); 
	if isnull(ll_count) then return c#return.Failure
else 
	return c#return.Success
end if
//Previous POCs are all Act. POCs
if ll_count = 0 then
	return c#return.Failure
else
	return c#return.Success
end if
end function

public function integer of_get_next_poc_key (s_poc astr_poc_current, ref s_poc astr_poc_next);/********************************************************************
   of_get_next_poc_key
   <DESC>	Get next port POC key by current port	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc_current
		astr_poc_next
   </ARGS>
   <USAGE>	Two scenarios:
			1. The next port voyage is the same as the current port voyage
			2. The next port voyage is not as same as the current port voyage
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-03-2012 CR20         LHC010             First Version
		28-03-2012 CR20			JMY014				 Changed the function name
		10-05-2012 CR20 			LHC010				 fix if next port is VP port and already show then return failure
   </HISTORY>
********************************************************************/

datetime ldt_procdate
string	ls_portcode
integer 	li_pcn, li_return, li_show_vp
long		ll_row, ll_rowcount
mt_n_datastore lds_nextport

SELECT PROC_DATE
  INTO :ldt_procdate
  FROM PROCEED
 WHERE VESSEL_NR = :astr_poc_current.vessel_nr 
   AND VOYAGE_NR = :astr_poc_current.voyage_nr
	AND PORT_CODE = :astr_poc_current.port_code 
	AND PCN = :astr_poc_current.pcn
 USING SQLCA;
                
if not (SQLCA.SQLCode = 0 and SQLCA.sqlnrows = 1) then return c#return.Failure

lds_nextport = create mt_n_datastore
lds_nextport.dataobject = "d_sq_gr_proceeding_nextport"
lds_nextport.settransobject(sqlca)

ll_rowcount = lds_nextport.retrieve(astr_poc_current.vessel_nr, astr_poc_current.voyage_nr, ldt_procdate)

if ll_rowcount <= 0 then li_return = c#return.Failure

for ll_row = 1 to ll_rowcount
	ls_portcode = lds_nextport.getitemstring(ll_row, "port_code")
	li_pcn      = lds_nextport.getitemnumber(ll_row, "pcn")
	li_show_vp	= lds_nextport.getitemnumber(ll_row, "show_vp")
	/*
	If the next port code in proceeding does not match with the next port from message, 
	and the next port in proceeding is not VP port, next port approval failed.
	*/
	if (li_pcn > 0 and ls_portcode <> astr_poc_next.port_code) or (li_show_vp = 1 and ls_portcode <> astr_poc_next.port_code) then
		li_return = c#return.Failure
		exit
	end if
	
	if ls_portcode = astr_poc_next.port_code then
		astr_poc_next.vessel_nr = astr_poc_current.vessel_nr
		astr_poc_next.voyage_nr = lds_nextport.getitemstring(ll_row, "voyage_nr")
		astr_poc_next.port_code = ls_portcode
		astr_poc_next.pcn       = li_pcn
		astr_poc_next.show_vp   = lds_nextport.getitemnumber(ll_row, "show_vp")
		li_return = c#return.Success
		exit
	end if
next

Destroy lds_nextport     

return li_return
end function

public function integer of_setpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc);/********************************************************************
   of_setpocdatetimes
   <DESC>	Set arrival/berthing/departure date time to POC	
				Get the arrival/berthing/departure datetime 
				from message datawindow out of this function
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_port_flag: Current port or next port flag:
						  1. Current port
						  2. Next port
		adw_msps_message: Message datawindow
		ads_poc: Act. or Est. POC datastore
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-02-2012 20           JMY014        First Version
		06-08-2013 CR3238			LHC010		  Modify the process for the noon(port) message.
   </HISTORY>
********************************************************************/

datetime ldt_arrival, ldt_berthing, ldt_departure

//Get the date values from message
ldt_arrival = adw_msps_message.getitemdatetime(1, "arrival_date")
ldt_berthing = adw_msps_message.getitemdatetime(1, "berth_date")
ldt_departure = adw_msps_message.getitemdatetime(1, "departure_date")

//Set the date values into POC
choose case is_message_type
	case c#msps.is_ARRIVAL, c#msps.is_NOON
		if is_reporttype <> "port" then 
			ads_poc.setitem(1, "port_arr_dt", ldt_arrival)
			ads_poc.setitem(1, "auto_arr_status", 0)
		end if
		ads_poc.setitem(1, "port_berthing_time", ldt_berthing)
		ads_poc.setitem(1, "auto_ber_status", 0)
		ads_poc.setitem(1, "port_dept_dt", ldt_departure)
		ads_poc.setitem(1, "auto_dept_status", 0)
	case c#msps.is_CANAL, c#msps.is_FWODRIFT
		ads_poc.setitem(1, "port_arr_dt", ldt_arrival)
		ads_poc.setitem(1, "auto_arr_status", 0)
		ads_poc.setitem(1, "port_dept_dt", ldt_departure)
		ads_poc.setitem(1, "auto_dept_status", 0)
	case c#msps.is_LOAD, c#msps.is_DISCHARGE
		ads_poc.setitem(1, "port_dept_dt", ldt_departure)
		ads_poc.setitem(1, "auto_dept_status", 0)
end choose

if of_checkpocdatetimes(adw_msps_message, ads_poc, false) = c#return.Failure then
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_check_estpoc_to_actpoc (s_poc astr_poc, datetime adt_arrival, ref mt_u_datawindow adw_msps_message);/********************************************************************
   of_check_estpoc_to_actpoc
   <DESC>	Check approval rule process,	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc:POC
		adt_arrival:Arrival date time
		adw_msps_message: Canal/FWO_DRIFT message
   </ARGS>
   <USAGE>
	The POC must be a Act. POC
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	05-03-2012 CR20         JMY014        First Version
   	08/08/2013 CR3238       LHG008        Check/link TC contract for DEL and RED ports
   </HISTORY>
********************************************************************/

datetime ldt_departure
integer	li_return

//Implement the common check process
if of_check_common(adw_msps_message, astr_poc, adt_arrival) = c#return.Failure then return c#return.Failure

//Vertical checking POC: there should not be a POC datetime later than current Act. POC arrival datetime
ldt_departure = adw_msps_message.getitemdatetime(1, "departure_date")
if inv_validate_poc.of_check_date_after(astr_poc, ldt_departure) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_AFTER, "${DATE}", string(ldt_departure, is_FORMAT_DATE_TIME)), adw_msps_message)
	return c#return.Failure
end if

//Check previous POCs should be all Act. POCs
if of_check_previous_estpoc(astr_poc) = c#return.Success then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_MOVE_ESTPOC_TO_ACTPOC, "${PORT_CODE}", astr_poc.port_code), adw_msps_message)
	return c#return.Failure
end if

//The Est. datetime exists, move it to be Act. POC
if inv_validate_poc.of_exists_estpoc(astr_poc, ids_poc_est) = c#return.Success then
	//Move Est. POC to be Act. POC
	of_est_to_act()
else
	//The Act. POC does not exists
	if inv_validate_poc.of_exists_actpoc(astr_poc, ids_poc) = c#return.Failure then
		//Check proceeding:exits
		if inv_validate_poc.of_exists_proceeding(astr_poc) = c#return.Success then
			of_create_actpoc(astr_poc, ids_poc)
			//Show VP check
			if of_check_proceeding_vp(astr_poc) = c#return.Success then of_set_proceeding_vp(astr_poc)
		//Proceeding exists.
		else
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_EXIST_IN_PROCEEDING, "${PORT_CODE}", astr_poc.port_code), adw_msps_message)
			return c#return.Failure
		end if
	end if
end if

if len(astr_poc.purpose) > 0 then ids_poc.setitem(1, "purpose_code", astr_poc.purpose)

//Check/link TC contract
li_return = of_check_tc_contract(adw_msps_message)
if li_return = c#return.Success then
	//Check and set the arrival/departure datetime to Act. POC, the failed reason has been implemented in this function
	return of_setpocdatetimes(adw_msps_message, ids_poc)
else // NoAction/Failure
	return li_return
end if
end function

public function integer of_check_common (ref mt_u_datawindow adw_msps_message, s_poc astr_poc, datetime adt_date);/********************************************************************
   of_check_common
   <DESC>	Common check procss intergration function	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message	:Message
		astr_poc		:POC
		adt_date		:Arrival/Berthing/Departure datetime
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	11-04-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/

//Vertical checking POC: there should not be a datetime larger than current Act. POC arrival datetime
if inv_validate_poc.of_check_date_before(astr_poc, adt_date) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_BEFORE, "${DATE}", string(adt_date, is_FORMAT_DATE_TIME)), adw_msps_message)
	return c#return.Failure
end if

//Vertical checking POC: there should not be a POC datetime later than current Act. POC arrival datetime
if inv_validate_poc.of_check_date_after(astr_poc, adt_date) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_AFTER, "${DATE}", string(adt_date, is_FORMAT_DATE_TIME)), adw_msps_message)
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_setnextpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc);/********************************************************************
   of_setnextpocdatetimes
   <DESC>	Set arrival/berthing/departure date time to POC	
				Get the arrival/berthing/departure datetime 
				from message datawindow out of this function
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_port_flag: Current port or next port flag:
						  1. Current port
						  2. Next port
		adw_msps_message: Message datawindow
		ads_poc: Act. or Est. POC datastore
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-02-2012 20           JMY014        First Version
		07-08-2013 CR3238			LHC010		  Modify the process for the noon(port) message.
   </HISTORY>
********************************************************************/
datetime ldt_arrival

choose case is_message_type
	case  c#msps.is_NOON
		ldt_arrival = adw_msps_message.getitemdatetime(1, "arrival_date")
	case c#msps.is_CANAL, c#msps.is_FWODRIFT
		ldt_arrival = adw_msps_message.getitemdatetime(1, "eta_next_port_date_lt")
end choose

ads_poc.setitem(1, "port_arr_dt", ldt_arrival)
ads_poc.setitem(1, "auto_arr_status", 0)

if of_checkpocdatetimes(adw_msps_message, ads_poc, true) = c#return.Failure then
	//Caution: Current port approval process succeeded, but next port approval process failed.
	of_set_status(c#msps.ii_FAILED, is_APPROVE_NEXT_PORT, adw_msps_message)
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_update_message_poc (mt_u_datawindow adw_msps_message);/********************************************************************
   of_update_message_poc
   <DESC>	Update message and POC	
				After transfering MSPS data to TRAMOS, execute updating action
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: Message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-02-2012 20           JMY014        First Version
		10-05-2012 20 				LHC010		  Refresh task list
   </HISTORY>
********************************************************************/

if adw_msps_message.update() <> 1 then
	rollback using sqlca;
	return c#return.Failure
else
	//Refresh task list
	if _refresh_task_list(ids_poc, ids_poc_est) = c#return.Failure then
		rollback using sqlca;
		return c#return.Failure
	end if

	if ids_poc.update() <> 1 then 
		rollback using sqlca;
		return c#return.Failure
	else
		if ids_poc_est.update() <> 1 then 
			rollback using sqlca;
			return c#return.Failure
		else
			if ids_vessel_bunker.update() <> 1 then 
				rollback using sqlca;
				return c#return.Failure
			end if
		end if
	end if
	if ids_proceed.update() <> 1 then
		rollback using sqlca;
		return c#return.Failure
	end if
end if
commit using sqlca;

return c#return.Success
end function

public function integer of_autoschedule (ref mt_n_datastore ads_poc, ref s_poc astr_poc, datetime adt_cur_etd, long al_seconds);/********************************************************************
   of_autoschedule
   <DESC>	Do autoschedule process after setup the Est. POC or Act. POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	ads_poc: Est. POC or Act. POC
	adt_cur_etd:
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26-03-2012 CR20         JMY014             First Version
   </HISTORY>
********************************************************************/

datetime			ldt_cur_dept
long				ll_return 
s_autoschedule lstr_autoschedule

lstr_autoschedule.seconds_after = al_seconds

//Change the departure datetime of Est. POC or Act. POC
ldt_cur_dept = ads_poc.getitemdatetime(1, "port_dept_dt")

ads_poc.retrieve(astr_poc.vessel_nr, astr_poc.voyage_nr, astr_poc.port_code, astr_poc.pcn)

if isnull(ldt_cur_dept) or ldt_cur_dept <> adt_cur_etd then
	ads_poc.setitem(1, "port_dept_dt", adt_cur_etd)
	ads_poc.setitem(1, "auto_dept_status", 1)
end if

if of_get_next_estpoc(astr_poc, lstr_autoschedule) = c#return.Success then
	if lstr_autoschedule.seconds_after <> 0 then
		//Autoschedule process
		if not inv_autoschedule.of_autoschedule_poc(lstr_autoschedule) then 
			rollback;
			return  c#return.Failure
		end if
		
	else
		return c#return.Failure
	end if
end if
if ads_poc.update() <> 1 then
	rollback;
	return  c#return.Failure
end if

commit;

return c#return.Success
end function

public function integer of_get_autoschedule_seconds (ref mt_n_datastore ads_poc, ref long al_seconds, ref datetime adt_cur_etd);/********************************************************************
   of_autoschedule_before
   <DESC>	Get the Est. POC departure datetime interval from modification	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: Est. POC or Act. POC
		al_seconds: Seconds interval
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	26-03-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
datetime ldt_ori_etd
long		ll_return

if not uo_global.ib_pocautoschedule then return c#return.NoAction

//Initialize the current departure date to be null
setnull(adt_cur_etd)

ll_return = inv_autoschedule.of_get_departuredate(ads_poc, ldt_ori_etd, adt_cur_etd, al_seconds)

if ll_return < 0 then return c#return.Failure

if isnull(ldt_ori_etd) or isnull(adt_cur_etd) then return c#return.Failure

return c#return.Success
end function

public function integer of_set_poc (mt_n_datastore ads_poc);/********************************************************************
   of_set_poc
   <DESC>	Set default data to POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: POC
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20-04-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if ads_poc.rowcount() = 1 then
	ads_poc.setitem(1, "msps_tfv", 1)
	ads_poc.setitem(1, "autoschedule_status", 0)
	ads_poc.setitem(1, "dates_updated_by", uo_global.is_userid)
	ads_poc.setitem(1, "local_dates_updated", now())
end if
return c#return.Success
end function

public function integer of_check_charterer (ref s_poc astr_poc);/********************************************************************
   of_check_charterer
   <DESC>	Check single charterer for approval	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-02-2012 	CR20        JMY014             First Version
		24-03-2012	CR20			RJH022             Modify 
   </HISTORY>
********************************************************************/

SElECT C.CHART_NR
INTO	 :astr_poc.chart_nr
FROM   CAL_CALC A, CAL_CARG B, CAL_CERP C, VOYAGES D
WHERE  D.VOYAGE_NR = :astr_poc.voyage_nr And
       D.VESSEL_NR = :astr_poc.vessel_nr And
		 A.CAL_CALC_ID = B.CAL_CALC_ID And
		 B.CAL_CERP_ID = C.CAL_CERP_ID And
		 A.CAL_CALC_ID= D.CAL_CALC_ID
USING  sqlca;

if sqlca.sqlcode <> 0 or isnull(astr_poc.chart_nr) then return c#return.Failure

return c#return.Success
end function

public function integer of_get_next_poc_key (mt_n_datastore ads_poc, ref s_poc astr_poc);/********************************************************************
   of_get_next_poc_key
   <DESC>	Get next port primary key from Est. POC or Act. POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc: Est. POC or Act. POC
		astr_poc: Primary key structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	27-03-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
if ads_poc.rowcount() = 1 then
	astr_poc.vessel_nr = ads_poc.getitemnumber(1, "vessel_nr")
	astr_poc.voyage_nr = ads_poc.getitemstring(1, "voyage_nr")
	astr_poc.port_code = ads_poc.getitemstring(1, "port_code")
	astr_poc.pcn = ads_poc.getitemnumber(1, "pcn")
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_checkpocdatetimes (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc, ref datetime adt_arrival, datetime adt_berthing, datetime adt_departure, boolean ab_port_next);/********************************************************************
   of_checkpocdatetimes
   <DESC> Horizontal check the arrival/berthing/departure datetime is legal or illegal	
			If check failed, failed the current message directly
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_arrival: Arrival datetime
		adt_berthing: Berthing datetime
		adt_departure: Departure datetime
		ab_port_next: Next port flag
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	07-03-2012 CR20         JMY014        First Version
		
   </HISTORY>
********************************************************************/

datetime ldt_message_departure

if is_message_type = c#msps.is_NOON and ab_port_next then
	setnull(ldt_message_departure)
	if uo_global.ib_pocautoschedule then setnull(adt_departure)
	setnull(adt_berthing)
elseif (is_message_type = c#msps.is_CANAL or is_message_type = c#msps.is_FWODRIFT) and ab_port_next then
	setnull(ldt_message_departure)
else
	ldt_message_departure = adw_msps_message.getitemdatetime(1, "departure_date")
end if

if not isnull(adt_berthing) and adt_berthing <= adt_arrival then
	if uo_global.ib_pocautoschedule then
		//Berthing date time is not legal, clear the berthing date time
		setnull(adt_berthing)
		ads_poc.setitem(1, "port_berthing_time", adt_berthing)
	else
		of_set_status(c#msps.ii_FAILED, is_BERTHING_AFTER_ARRIVAL, adw_msps_message)	
		return c#return.Failure
	end if
end if

//The departure datetime on message after arrival datetime, it is illegal.
if not isnull(ldt_message_departure) then
	if ldt_message_departure <= adt_arrival then
		of_set_status(c#msps.ii_FAILED, is_DEPARTURE_AFTER_ARRIVAL, adw_msps_message)
		return c#return.failure
	end if
end if

if not isnull(adt_departure) then
	 if adt_departure <= adt_arrival  then
		//Departure date time is not legal, allow updating departure, auto schedule process could correct the departure value
		if not uo_global.ib_pocautoschedule then
			of_set_status(c#msps.ii_FAILED, is_DEPARTURE_AFTER_ARRIVAL, adw_msps_message)	
		   return c#return.failure
		end if
	 elseif adt_departure <= adt_berthing then
		if  not uo_global.ib_pocautoschedule then
			of_set_status(c#msps.ii_FAILED, is_DEPARTURE_AFTER_BERTHING, adw_msps_message)
			return c#return.failure
		else
			//Berthing date time is not legal, clear the berthing date time
			setnull(adt_berthing)
			ads_poc.setitem(1, "port_berthing_time", adt_berthing)
		end if
	 end if
end if

return c#return.Success
end function

public function integer of_checkpocdatetimes (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, boolean ab_port_next);/********************************************************************
   of_checkpocdatetimes
   <DESC>	Horizontal check the arrival/berthing/departure datetime of POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: Message datawindow
		ads_poc: POC datastore
		ab_port_next: Next port flag
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	09-04-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
datetime ldt_arrival, ldt_berthing, ldt_departure

ldt_arrival = ads_poc.getitemdatetime(1, "port_arr_dt")
ldt_berthing = ads_poc.getitemdatetime(1, "port_berthing_time")
ldt_departure = ads_poc.getitemdatetime(1, "port_dept_dt")

return of_checkpocdatetimes(adw_msps_message, ads_poc, ldt_arrival, ldt_berthing, ldt_departure, ab_port_next)
end function

public function integer of_check_previous_poc_bunker (s_poc_bunker astr_poc_bunker);/********************************************************************
   of_check_previous_poc_bunker
   <DESC>	Compare the arrival bunker of current port with the departure bunker of previous port.
				The departure bunker of previous port should be higher than the arrival bunker of current port.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc_bunker: bunker data structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	08-05-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/

//At least one kind of current port arrival bunker quantity should not be higher than the previous port departure bunker quantity
if (astr_poc_bunker.adc_hfo_arrival > astr_poc_bunker.adc_hfo_departure_previous or + &
    astr_poc_bunker.adc_do_arrival > astr_poc_bunker.adc_do_departure_previous or + &
	 astr_poc_bunker.adc_go_arrival > astr_poc_bunker.adc_go_departure_previous or + &
	 astr_poc_bunker.adc_lshfo_arrival > astr_poc_bunker.adc_lshfo_departure_previous) then return c#return.Failure

return c#return.Success
end function

public function integer of_check_current_poc_bunker (s_poc_bunker astr_poc_bunker);/********************************************************************
   of_check_current_poc_bunker
   <DESC>	Compare the arrival bunker with the departure bunker  of current port.
				The departure bunker should be higher than the arrival bunker.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc_bunker: bunker data structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	08-05-2012 CR20         JMY014        First Version
		03-09-2013 CR3238			LHC010		  Fix the bunker validation for arrival message
   </HISTORY>
********************************************************************/

//At least one kind of arrival bunker quantity should not be higher than the departure bunker quantity from current POC

if is_message_type = c#msps.is_ARRIVAL then
	if (astr_poc_bunker.adc_hfo_arrival < astr_poc_bunker.adc_hfo_departure or + &
		 astr_poc_bunker.adc_do_arrival < astr_poc_bunker.adc_do_departure or + &
		 astr_poc_bunker.adc_go_arrival < astr_poc_bunker.adc_go_departure or + &
		 astr_poc_bunker.adc_lshfo_arrival < astr_poc_bunker.adc_lshfo_departure) then return c#return.Failure
else
	if (astr_poc_bunker.adc_hfo_sum < astr_poc_bunker.adc_hfo_departure or + &
		 astr_poc_bunker.adc_do_sum < astr_poc_bunker.adc_do_departure or + &
		 astr_poc_bunker.adc_go_sum < astr_poc_bunker.adc_go_departure or + &
		 astr_poc_bunker.adc_lshfo_sum < astr_poc_bunker.adc_lshfo_departure) then return c#return.Failure
end if

return c#return.Success
end function

public function integer of_check_poc_bunker (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, s_poc astr_poc, ref s_poc_bunker astr_poc_bunker);/********************************************************************
   of_check_poc_bunker
   <DESC>	Check POC bunker is legal or illegal.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: message
		ads_poc: current port POC
		astr_poc: current port datastructure
		astr_poc_bunker: previous port and current port bunker data structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	07-05-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
//Get previous port departure bunker data
if of_get_previous_poc_bunker(astr_poc, astr_poc_bunker) = c#return.Failure then return c#return.Failure
//Get current port bunker data: arrival bunker and departure bunker data
if of_get_current_poc_bunker(adw_msps_message, ads_poc, astr_poc_bunker) = c#return.Failure then return c#return.Failure
//Get next port arrival bunker data
if of_get_next_poc_bunker(astr_poc, astr_poc_bunker) = c#return.Failure  then return c#return.Failure 

//Compare the current port arrival bunker with the previous port departure bunker
if of_check_previous_poc_bunker(astr_poc_bunker) = c#return.Failure then 
	of_set_status(c#msps.ii_FAILED, is_ROB_ARRIVAL_PREVIOUS_DEPARTURE, adw_msps_message)
	return c#return.Failure
end if
//Compare the current port arrival bunker with the departure bunker
if of_check_current_poc_bunker(astr_poc_bunker) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, is_ROB_DEPARTURE_ARRIVAL, adw_msps_message)
	return c#return.Failure
end if
//Compare current port departure bunker with the next port arrival bunker 
if astr_poc_bunker.ab_next_port_exist then
	if of_check_next_poc_bunker(astr_poc_bunker) = c#return.Failure then
		of_set_status(c#msps.ii_FAILED, is_ROB_DEPARTURE_NEXT_ARRIVAL, adw_msps_message)
		return c#return.Failure
	end if
end if
return c#return.Success
end function

public function integer of_get_current_poc_bunker (mt_u_datawindow adw_msps_message, mt_n_datastore ads_poc, ref s_poc_bunker astr_poc_bunker);/********************************************************************
   of_get_poc_bunker
   <DESC>	Get POC bunker from  message	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message
		astr_poc_bunker
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	07-05-2012 CR20         JMY014        First Version
		24-05-2013 CR3238			LHC010		  Fix Departure bunkers for DMA01 not mapped from message to poc
   </HISTORY>
********************************************************************/
decimal{4}	ldc_hfo_buy, ldc_do_buy, ldc_go_buy, ldc_lshfo_buy			//Buy
decimal{4}	ldc_hfo_sell, ldc_do_sell, ldc_go_sell, ldc_lshfo_sell	//Sell

//Get current Act. POC arrival bunker
astr_poc_bunker.adc_hfo_arrival   = adw_msps_message.getitemnumber(1, "rob_hs_hfo_quantity")
astr_poc_bunker.adc_do_arrival    = adw_msps_message.getitemnumber(1, "rob_ls_mdo_quantity")
astr_poc_bunker.adc_go_arrival    = adw_msps_message.getitemnumber(1, "rob_hs_mdo_quantity")
astr_poc_bunker.adc_lshfo_arrival = adw_msps_message.getitemnumber(1, "rob_ls_hfo_quantity")
if isnull(astr_poc_bunker.adc_hfo_arrival) then astr_poc_bunker.adc_hfo_arrival = 0
if isnull(astr_poc_bunker.adc_do_arrival) then astr_poc_bunker.adc_do_arrival = 0
if isnull(astr_poc_bunker.adc_go_arrival) then astr_poc_bunker.adc_go_arrival = 0
if isnull(astr_poc_bunker.adc_lshfo_arrival) then astr_poc_bunker.adc_lshfo_arrival = 0

//Get departure bunker from POC for arrival message approval validation
if is_message_type = c#msps.is_ARRIVAL then
	if ads_poc.rowcount () <> 1 then return c#return.Failure
	astr_poc_bunker.adc_hfo_departure = ads_poc.getitemnumber(1, "dept_hfo")
	astr_poc_bunker.adc_do_departure = ads_poc.getitemnumber(1, "dept_do")
	astr_poc_bunker.adc_go_departure = ads_poc.getitemnumber(1, "dept_go")
	astr_poc_bunker.adc_lshfo_departure = ads_poc.getitemnumber(1, "dept_lshfo")
	if isnull(astr_poc_bunker.adc_hfo_departure) then astr_poc_bunker.adc_hfo_departure = 0
	if isnull(astr_poc_bunker.adc_do_departure) then astr_poc_bunker.adc_do_departure = 0
	if isnull(astr_poc_bunker.adc_do_departure) then astr_poc_bunker.adc_do_departure = 0
	if isnull(astr_poc_bunker.adc_lshfo_departure) then astr_poc_bunker.adc_lshfo_departure = 0
end if

//Get departure bunker from message except for arrival message
if is_message_type <> c#msps.is_ARRIVAL then
	astr_poc_bunker.adc_hfo_departure   = adw_msps_message.getitemnumber(1, "rob_last_line_hs_hfo_quantity")
	astr_poc_bunker.adc_do_departure    = adw_msps_message.getitemnumber(1, "rob_last_line_ls_mdo_quantity")
	astr_poc_bunker.adc_go_departure    = adw_msps_message.getitemnumber(1, "rob_last_line_hs_mdo_quantity")
	astr_poc_bunker.adc_lshfo_departure = adw_msps_message.getitemnumber(1, "rob_last_line_ls_hfo_quantity")
	if isnull(astr_poc_bunker.adc_hfo_departure) then astr_poc_bunker.adc_hfo_departure = 0
	if isnull(astr_poc_bunker.adc_do_departure) then astr_poc_bunker.adc_do_departure = 0
	if isnull(astr_poc_bunker.adc_go_departure) then astr_poc_bunker.adc_go_departure = 0
	if isnull(astr_poc_bunker.adc_lshfo_departure) then astr_poc_bunker.adc_lshfo_departure = 0
	//Buy
	ldc_hfo_buy    = adw_msps_message.getitemnumber(1, "loaded_hs_hfo")
	ldc_do_buy     = adw_msps_message.getitemnumber(1, "loaded_ls_mdo")
	ldc_go_buy     = adw_msps_message.getitemnumber(1, "loaded_hs_mdo")
	ldc_lshfo_buy  = adw_msps_message.getitemnumber(1, "loaded_ls_hfo")
	//Sell
	ldc_hfo_sell   = adw_msps_message.getitemnumber(1, "discharge_hs_hfo")
	ldc_do_sell    = adw_msps_message.getitemnumber(1, "discharge_ls_mdo")
	ldc_go_sell    = adw_msps_message.getitemnumber(1, "discharge_hs_mdo")
	ldc_lshfo_sell = adw_msps_message.getitemnumber(1, "discharge_ls_hfo")
	
	//sum = arrival + buy - sell 
	astr_poc_bunker.adc_hfo_sum   = astr_poc_bunker.adc_hfo_arrival + ldc_hfo_buy - ldc_hfo_sell
	astr_poc_bunker.adc_do_sum    = astr_poc_bunker.adc_do_arrival + ldc_do_buy - ldc_do_sell
	astr_poc_bunker.adc_go_sum    = astr_poc_bunker.adc_go_arrival + ldc_go_buy - ldc_go_sell
	astr_poc_bunker.adc_lshfo_sum = astr_poc_bunker.adc_lshfo_arrival + ldc_lshfo_buy - ldc_lshfo_sell
	if isnull(astr_poc_bunker.adc_hfo_sum) then astr_poc_bunker.adc_hfo_sum = 0
	if isnull(astr_poc_bunker.adc_do_sum) then astr_poc_bunker.adc_do_sum = 0
	if isnull(astr_poc_bunker.adc_go_sum) then astr_poc_bunker.adc_go_sum = 0
	if isnull(astr_poc_bunker.adc_lshfo_sum) then astr_poc_bunker.adc_lshfo_sum = 0
end if

return c#return.Success
end function

public function integer of_get_next_poc_bunker (s_poc astr_poc, ref s_poc_bunker astr_poc_bunker);/********************************************************************
   of_get_next_poc_bunker
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	08-05-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
datetime ldt_proc_date
decimal{4} ldt_hfo_arrival, ldt_do_arrival, ldt_go_arrival, ldt_lshfo_arrival

// Get PROC_DATE from PROCEED
SELECT PROC_DATE
INTO   :ldt_proc_date
FROM   PROCEED
WHERE  (PROCEED.VESSEL_NR = :astr_poc.vessel_nr)
AND    (PROCEED.PORT_CODE = :astr_poc.port_code)
AND    (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr)
AND    (PROCEED.PCN = :astr_poc.pcn);

//Get next Act. POC according to current POC key.
if not isnull(ldt_proc_date) then
	SELECT TOP 1 POC.ARR_HFO, POC.ARR_DO, POC.ARR_GO, POC.ARR_LSHFO
	INTO   :ldt_hfo_arrival, :ldt_do_arrival, :ldt_go_arrival, :ldt_lshfo_arrival
	FROM   POC, PROCEED
	WHERE  PROCEED.VESSEL_NR = POC.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
			 PROCEED.PORT_CODE = POC.PORT_CODE AND
			 PROCEED.PCN = POC.PCN AND
			 PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
			((SUBSTRING(PROCEED.VOYAGE_NR, 1, 2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
			OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date)); 
	if sqlca.sqlcode = 0 and sqlca.sqlnrows = 1 then
		astr_poc_bunker.adc_hfo_arrival_next = ldt_hfo_arrival
		astr_poc_bunker.adc_do_arrival_next = ldt_do_arrival
		astr_poc_bunker.adc_go_arrival_next = ldt_go_arrival
		astr_poc_bunker.adc_lshfo_arrival_next = ldt_lshfo_arrival
		astr_poc_bunker.ab_next_port_exist = true
	end if
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_check_next_poc_bunker (s_poc_bunker astr_poc_bunker);/********************************************************************
   of_check_next_poc_bunker
   <DESC>	Compare the departure bunker of current port with the arrival bunker of next port.
				The departure bunker of current port should be higher than the arrival bunker of next port.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc_bunker: bunker data structure
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	08-05-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/
//At least one kind of current port departure bunker quantity should not be higher than the next port arrival bunker quantity
if (astr_poc_bunker.adc_hfo_departure < astr_poc_bunker.adc_hfo_arrival_next or + &
    astr_poc_bunker.adc_do_departure < astr_poc_bunker.adc_do_arrival_next or + &
	 astr_poc_bunker.adc_go_departure < astr_poc_bunker.adc_go_arrival_next or + &
	 astr_poc_bunker.adc_lshfo_departure < astr_poc_bunker.adc_lshfo_arrival_next) then return c#return.Failure

return c#return.Success
end function

public function integer of_set_poc_bunker (mt_u_datawindow adw_msps_message, ref mt_n_datastore ads_poc, s_poc astr_poc);/********************************************************************
   of_set_poc_bunker
   <DESC>	After validation of bunker successfully, set ROB bunker to Act. POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_message: Message datawindow
		as_dataobject: Message dataobject
		ads_poc: POC datastore
   </ARGS>
   <USAGE>	Exclude the noon and heating report	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-02-2012 20           JMY014        First Version dept_hfo
   </HISTORY>
********************************************************************/
s_poc_bunker lstr_poc_bunker   	//Bunker data structure

//Bunker validation: vertiacal check on the previous port and the next port, horizontal check on current port
if of_check_poc_bunker(adw_msps_message, ads_poc, astr_poc, lstr_poc_bunker) = c#return.Success then
	//Set current port arrival bunker to Act. POC
	ads_poc.setitem(1, "arr_hfo", lstr_poc_bunker.adc_hfo_arrival)
	ads_poc.setitem(1, "arr_do", lstr_poc_bunker.adc_do_arrival)
	ads_poc.setitem(1, "arr_go", lstr_poc_bunker.adc_go_arrival)
	ads_poc.setitem(1, "arr_lshfo", lstr_poc_bunker.adc_lshfo_arrival)
	//Set current departure bunker to Act. POC
	if is_message_type <> c#msps.is_ARRIVAL then
		ads_poc.setitem(1, "dept_hfo", lstr_poc_bunker.adc_hfo_departure)
		ads_poc.setitem(1, "dept_do", lstr_poc_bunker.adc_do_departure)
		ads_poc.setitem(1, "dept_go", lstr_poc_bunker.adc_go_departure)
		ads_poc.setitem(1, "dept_lshfo", lstr_poc_bunker.adc_lshfo_departure)
	end if
else
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_get_previous_poc_bunker (s_poc astr_poc, ref s_poc_bunker astr_poc_bunker);/********************************************************************
   of_get_previous_poc_bunker
   <DESC>	Get previous POC bunker	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc_bunker:
		astr_poc: Current POC structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-05-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
decimal{4} 	ldc_hfo, ldc_do, ldc_go, ldc_lshfo

//Get previous POC data structure
if of_get_previous_port(astr_poc) = c#return.Success then
	if astr_poc.port_code <> "" then
		SELECT isnull(DEPT_HFO, 0), isnull(DEPT_DO, 0), isnull(DEPT_GO, 0), isnull(DEPT_LSHFO, 0)
		INTO   :ldc_hfo, :ldc_do, :ldc_go, :ldc_lshfo
		FROM   POC
		WHERE  VESSEL_NR = :astr_poc.vessel_nr
		AND 	 VOYAGE_NR = :astr_poc.voyage_nr
		AND 	 PORT_CODE = :astr_poc.port_code
		AND 	 PCN		  = :astr_poc.pcn;
		
		// Set previous POC bunker to structure
		if sqlca.sqlcode = 0 and sqlca.sqlnrows = 1 then
			astr_poc_bunker.adc_hfo_departure_previous   = ldc_hfo
			astr_poc_bunker.adc_do_departure_previous    = ldc_do
			astr_poc_bunker.adc_go_departure_previous    = ldc_go
			astr_poc_bunker.adc_lshfo_departure_previous = ldc_lshfo
		end if
	end if
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer _refresh_task_list (mt_n_datastore ads_poc, mt_n_datastore ads_poc_est);/********************************************************************
_refresh_task_list
   <DESC>Refresh task list for a specific port of call </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Public 	</ACCESS>
   <ARGS>	ads_poc
				ads_poc_est
	</ARGS>
   <USAGE> Refresh task list when POC purpose changes</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10-05-2012 ?            LHC010        First Version
   </HISTORY>
********************************************************************/

long 		ll_vesselnr
string	ls_voyagenr, ls_portcode, ls_purpose
integer	li_pcn, li_pc_nr
mt_n_datastore lds_temp

dwItemStatus ldws_status, ldws_purpose_status

if ads_poc.rowcount() = 1 then 
	ldws_status 			= ads_poc.getitemstatus(1, 0, Primary!)
	ldws_purpose_status 	= ads_poc.getitemstatus(1, "purpose_code", Primary!)
	if ldws_status = NewModified! or ldws_purpose_status = Datamodified! then	lds_temp = ads_poc
end if

if ads_poc_est.rowcount() = 1 then 
	ldws_status 			= ads_poc_est.getitemstatus(1, 0, Primary!)
	ldws_purpose_status 	= ads_poc_est.getitemstatus(1, "purpose_code", Primary!)
	if ldws_status = NewModified! or ldws_purpose_status = Datamodified! then	lds_temp = ads_poc_est
end if

if not isvalid(lds_temp) then return c#return.Success

ls_purpose  		= lds_temp.getitemstring(1, "purpose_code")

if ldws_status = NewModified! or ldws_purpose_status = Datamodified! then 
	ll_vesselnr 		= lds_temp.getitemnumber(1, "vessel_nr")
	ls_voyagenr 		= lds_temp.getitemstring(1, "voyage_nr")
	ls_portcode 		= lds_temp.getitemstring(1, "port_code")
	li_pcn 				= lds_temp.getitemnumber(1, "pcn")
	
	SELECT PC_NR into: li_pc_nr from VESSELS WHERE VESSEL_NR = :ll_vesselnr;
	
	if sqlca.sqlcode = -1 then
		return c#return.failure
	end if
	
	if ldws_purpose_status = Datamodified! then
		//Delete tasks not done
		DELETE 
		FROM POC_TASK_LIST
		WHERE VESSEL_NR = :ll_vesselnr
			AND VOYAGE_NR = :ls_voyagenr
			AND PORT_CODE = :ls_portcode
			AND PCN = :li_pcn
			AND TASK_NA <> 1 AND TASK_DONE <> 1;
	
		if sqlca.sqlcode = -1 then
			return c#return.failure
		end if
	end if	
	
	INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
		(SELECT :ll_vesselnr,  :ls_voyagenr, :ls_portcode, :li_pcn,
			POC_TASKS_CONFIG_PC.TASK_ID,
			POC_TASKS_CONFIG_PC.TASK_SORT
		FROM POC_TASKS_CONFIG_PC
		WHERE  POC_TASKS_CONFIG_PC.PURPOSE_CODE = :ls_purpose
			AND POC_TASKS_CONFIG_PC.PC_NR = :li_pc_nr 
			AND POC_TASKS_CONFIG_PC.TASK_ID NOT IN 
					(SELECT POC_TASK_LIST.TASK_ID 
						FROM POC_TASK_LIST
						WHERE POC_TASK_LIST.VESSEL_NR = :ll_vesselnr
								AND POC_TASK_LIST.VOYAGE_NR = :ls_voyagenr
								AND POC_TASK_LIST.PORT_CODE = :ls_portcode
								AND POC_TASK_LIST.PCN = :li_pcn)
			);

	if sqlca.sqlcode = -1 then
		return c#return.failure
	end if
end if

return c#return.success
end function

public function integer of_create_actpoc (s_poc astr_poc, ref mt_n_datastore ads_act);/********************************************************************
of_create_actpoc
<DESC> Create actual poc </DESC>
<RETURN>	integer:
			<LI> c#return.Success, ok
			<LI> c#return.Failure, failed	</RETURN>
<ACCESS> public</ACCESS>
<ARGS>
	astr_poc
	ads_act
</ARGS>
<USAGE></USAGE>
<HISTORY>
	Date       CR-Ref       	Author        Comments
	2012-02-24 CR20            RJH022        First Version
</HISTORY>
********************************************************************/
long ll_row
 
ll_row = ads_act.insertrow(0)

if isnull(astr_poc.purpose) or len(astr_poc.purpose) <= 0 then astr_poc.purpose = "TFV"

ads_act.setitem(ll_row, "purpose_code", astr_poc.purpose)
ads_act.setitem(ll_row, "voyage_nr", astr_poc.voyage_nr)
ads_act.setitem(ll_row, "vessel_nr", astr_poc.vessel_nr)
ads_act.setitem(ll_row, "port_code", astr_poc.port_code)
ads_act.setitem(ll_row, "pcn", astr_poc.pcn)
ads_act.setitem(ll_row, "port_arr_dt", astr_poc.arrival_date)

ads_act.setitem(ll_row, "lt_to_utc_difference", 0)
ads_act.setitem(ll_row, "disch", 1)
return c#return.Success
end function

public function integer of_create_estpoc (s_poc astr_poc, ref mt_n_datastore ads_est); /********************************************************************
   of_create_estpoc
   <DESC> Create estimate poc </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
		ads_est
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author        Comments
   	2012-02-24 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_row
 
ll_row = ads_est.insertrow(0)

ads_est.setitem(ll_row, "purpose_code", "TFV")
ads_est.setitem(ll_row, "voyage_nr", astr_poc.voyage_nr)
ads_est.setitem(ll_row, "vessel_nr", astr_poc.vessel_nr)
ads_est.setitem(ll_row, "port_code", astr_poc.port_code)
ads_est.setitem(ll_row, "pcn", astr_poc.pcn)
ads_est.setitem(ll_row, "port_arr_dt", astr_poc.arrival_date)
 
return c#return.Success 
 
end function

public function integer of_get_previous_port (ref s_poc astr_poc);/********************************************************************
   of_get_preport
   <DESC>Get the previous port primary keys refer to  the current port primary keys.
			When the previous port exists, the structure data was replaced by previous port primary keys.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: current port primary keys structure
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-15 20            RJH022        First Version
		2012-05-08 20				JMY014			Comments added, and fixed a bug: deal with the first time vessel voyage.
   </HISTORY>
********************************************************************/
string ls_port, ls_voyagenr
int li_pcn
datetime ldt_proc_date

//Get the proceeding date of current port
SELECT PROC_DATE
  INTO :ldt_proc_date
  FROM PROCEED
 WHERE (PROCEED.VESSEL_NR = :astr_poc.vessel_nr)
   AND (PROCEED.PORT_CODE = :astr_poc.port_code)
   AND (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr)
   AND (PROCEED.PCN = :astr_poc.pcn);

//Get the previous port primary keys.
SELECT TOP 1 POC.VOYAGE_NR, POC.PORT_CODE, POC.PCN 
  INTO  :ls_voyagenr, :ls_port,  :li_pcn
  FROM   POC, PROCEED
 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
		 PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		 PROCEED.PORT_CODE = POC.PORT_CODE AND
		 PROCEED.PCN = POC.PCN AND
		 PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
		 SUBSTRING(PROCEED.VOYAGE_NR, 1, 2) < '90' AND 
		 (PROCEED.VOYAGE_NR < :astr_poc.voyage_nr OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE < :ldt_proc_date))
ORDER BY POC.VOYAGE_NR DESC, PROCEED.PROC_DATE DESC;

//Replace the port structure data
if sqlca.sqlcode = 0 then
	astr_poc.port_code = ls_port
	astr_poc.pcn = li_pcn
	astr_poc.voyage_nr = ls_voyagenr
	return c#return.Success
//There is no previous port if the first time vessel voyage
elseif sqlca.sqlcode = 100 then
	astr_poc.port_code = ""
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_check_arrival (mt_u_datawindow adw_msps_arrival, ref s_poc astr_poc, datetime adt_arrival);/********************************************************************
   of_check_arrival
   <DESC>	Check vessel POC/Proceeding for approval	
				There are 3 datetimes option for Act. POC
	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC key structure
		adt_arrival: Arrival date time of message report
		adw_msps_arrival: Message report datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21-02-2012 CR20         JMY014             First Version
   	08/08/2013 CR3238       LHG008             Check/link TC contract for DEL and RED ports
   </HISTORY>
********************************************************************/

datetime ldt_departure
integer	li_return

//Implement the common check process
if of_check_common(adw_msps_arrival, astr_poc, adt_arrival) = c#return.Failure then return c#return.Failure

//Vertical checking POC: there should not be a POC datetime later than current Act. POC arrival datetime
ldt_departure = adw_msps_arrival.getitemdatetime(1, "departure_date")
if inv_validate_poc.of_check_date_after(astr_poc, ldt_departure) = c#return.Failure then
	of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_POC_DATE_AFTER, "${DATE}", string(ldt_departure, is_FORMAT_DATE_TIME)), adw_msps_arrival)
	return c#return.Failure
end if

//The estimated datetime exists move them(ETA/ETB/ETD) to actual POC
if inv_validate_poc.of_exists_estpoc(astr_poc, ids_poc_est) = c#return.Success then
	//Check previous POCs are all actual POCs, not exist estimated poc before current poc
	if of_check_previous_estpoc(astr_poc) = c#return.Failure then
		//Set Est. POC to be Act. POC
		of_est_to_act()		
	else
		of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_MOVE_ESTPOC_TO_ACTPOC, "${PORT_CODE}", astr_poc.port_code), adw_msps_arrival)
		return c#return.Failure
	end if
else
	//The Act. POC does not exists, create a Act.
	if inv_validate_poc.of_exists_actpoc(astr_poc, ids_poc) = c#return.Failure then
		//Check proceeding:exists
		if inv_validate_poc.of_exists_proceeding(astr_poc) = c#return.Success then
			//Check previous POCs are all actual POCs
			if of_check_previous_estpoc(astr_poc) = c#return.Failure then					
				of_create_actpoc(astr_poc, ids_poc) //Create Act.
				
				if of_check_proceeding_vp(astr_poc) = c#return.Success then of_set_proceeding_vp(astr_poc) //Show VP check
			else
				of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_CREATE_ACTPOC, "${PORT_CODE}", astr_poc.port_code), adw_msps_arrival)
				return c#return.Failure
			end if
		//Proceeding exists.
		else
			of_set_status(c#msps.ii_FAILED, inv_stringfunctions.of_replace(is_EXIST_IN_PROCEEDING, "${PORT_CODE}", astr_poc.port_code), adw_msps_arrival)
			return c#return.Failure
		end if
	end if
end if

//Check the voyage allocation, for purpose setup
if inv_validate_poc.of_is_allocated(astr_poc) = c#return.Success then
	astr_poc.purpose = ids_poc.getitemstring(1, "purpose_code")
	//Get purpose from calculation through allocation of voyage's calculation, update the Act. POC purpose
	if of_get_purpose_from_calculation(astr_poc) = c#return.Success and ids_poc.getitemstring(1, "purpose_code") = "TFV" then 
		//The purpose code has been covered ty the calculation cargo input/output purpose
		ids_poc.setitem(1, "purpose_code", astr_poc.purpose)
	end if
end if

//Check/link TC contract
li_return = of_check_tc_contract(adw_msps_arrival)
if li_return = c#return.Success then
	//Check and set the arrival/departure datetime to Act. POC, the failed reason has been implemented in this function
	return of_setpocdatetimes(adw_msps_arrival, ids_poc)
else // NoAction/Failure
	return li_return
end if
end function

public function integer of_get_next_estpoc (s_poc astr_poc, ref s_autoschedule astr_autoschedule);/********************************************************************
   of_get_next_estpoc
   <DESC>	Get the next Est. POC by current Est. POC or Act. POC structure	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: Current Est. POC or Act. POC structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	26-03-2012 CR20         JMY014        First Version
   </HISTORY>
********************************************************************/

datetime ldt_proc_date
long		ll_vessel_nr
string	ls_voyage_nr, ls_port_code
integer	li_pcn

// Get PROC_DATE from PROCEED
SELECT PROC_DATE
INTO   :ldt_proc_date
FROM   PROCEED
WHERE  (PROCEED.VESSEL_NR = :astr_poc.vessel_nr)
AND    (PROCEED.PORT_CODE = :astr_poc.port_code)
AND    (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr)
AND    (PROCEED.PCN = :astr_poc.pcn);

//Get next Est. POC according to current Est. POC.
if not isnull(ldt_proc_date) then
	SELECT TOP 1 PROCEED.VESSEL_NR, PROCEED.VOYAGE_NR, POC_EST.PORT_CODE, POC_EST.PCN
	INTO   :ll_vessel_nr, :ls_voyage_nr, :ls_port_code, :li_pcn
	FROM   POC_EST, PROCEED
	WHERE  PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
			 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
			 PROCEED.PCN = POC_EST.PCN AND
			 PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
			((SUBSTRING(PROCEED.VOYAGE_NR, 1, 2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
			OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date))
	ORDER BY PROCEED.VOYAGE_NR, PROCEED.PROC_DATE; 
			
	if sqlca.sqlcode = 0 and sqlca.sqlnrows = 1 then
			astr_autoschedule.vessel_nr = ll_vessel_nr
			astr_autoschedule.voyage_nr = ls_voyage_nr
			astr_autoschedule.port_code = ls_port_code
			astr_autoschedule.pcn       = li_pcn
			astr_autoschedule.year      = left(astr_poc.voyage_nr, 2)
	else
		return c#return.Failure
	end if
else 
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_est_to_act (); /********************************************************************
   of_est_to_act
   <DESC>Move esitmate poc to actual poc</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author        Comments
   	2012-02-24 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_count

ll_count = ids_poc_est.rowcount()
if ll_count = 0 then return c#return.Failure

ll_row = ids_poc.insertrow(0)
ids_poc.object.data[ll_row, 1, ll_row, 22] = ids_poc_est.object.data[1, 1, ll_count, 22]
ids_poc_est.deleterow(ll_count)

return c#return.Success
end function

public function integer of_isactualpocfollowingthis (s_poc astr_poc);/********************************************************************
   of_isactualpocfollowingthis
   <DESC>	Check there is Act. POC after the current Est. POC or Act. POC.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc:POC important keys
   </ARGS>
   <USAGE>	PROC_DATE is a order usage column.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
long		ll_count
datetime ldt_proc_date

//Initialize the variables to be null
setnull(ll_count)
setnull(ldt_proc_date)

// Get PROC_DATE from PROCEED table
SELECT PROC_DATE
INTO   :ldt_proc_date
FROM   PROCEED
WHERE  (PROCEED.VESSEL_NR = :astr_poc.vessel_nr)
AND    (PROCEED.PORT_CODE = :astr_poc.port_code)
AND    (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr)
AND    (PROCEED.PCN       = :astr_poc.pcn);

//Get following Act. POCs count.
if not isnull(ldt_proc_date) then
	SELECT count(PROCEED.VESSEL_NR)
	INTO   :ll_count
	FROM   POC, PROCEED
	WHERE  PROCEED.VESSEL_NR = POC.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
			 PROCEED.PORT_CODE = POC.PORT_CODE AND
			 PROCEED.PCN       = POC.PCN AND
			 PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
			 ((SUBSTRING(PROCEED.VOYAGE_NR, 1, 2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
			 OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date)); 
	if isnull(ll_count) then ll_count = 0
else 
	return c#return.Failure
end if

//There is Act. POCs after the current Est. POC or Act. POC
if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_connecttccontract (mt_u_datawindow adw_msps_message);/********************************************************************
   of_connecttccontract
   <DESC>	For Arrival/Departure(Canal, FWO/Drift) Messages, if Purpose = DEL/RED then try to link to TC contract	</DESC>
   <RETURN>	integer:
            <LI> c#return.NoAction
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	adw_msps_message: MSPS message datawindow   </ARGS>
   <USAGE>
          Dependent MSPS messages
			 Arrival/Canal/FWO/Drift
 
          Called from of_check_tc_contract()
	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		08/08/2013	CR3238	LHG008	First Version
   </HISTORY>
********************************************************************/

integer 					li_vessel_nr, li_tcowner
long 						ll_contractid
string 					ls_voyage_nr, ls_purpose
datetime					ldt_contract_arrival_departure, ldt_calculated_arrival_departure
boolean					lb_contract_localtime
s_select_tc_contract	lstr_parm

li_vessel_nr 	= ids_poc.getitemnumber(1, "vessel_nr")
ls_purpose 	 	= ids_poc.getitemstring(1, "purpose_code")
ls_voyage_nr 	= ids_poc.getitemstring(1, "voyage_nr")

/* Check if this voyage/portcall shall be connected to a TC Contract or not */
SELECT TCOWNER_NR INTO :li_tcowner FROM VESSELS WHERE VESSEL_NR = :li_vessel_nr;
SELECT VOYAGE_TYPE INTO :lstr_parm.tc_hire_in FROM VOYAGES WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
if lstr_parm.tc_hire_in = 2 then
	lstr_parm.tc_hire_in = 0
else
	lstr_parm.tc_hire_in = 1
end if

/* Delivery on a single voyage where there is no TC-owner registred is equal to delivery of new vessel from yard for "internal use" 
		and shall not be connected to a TC-Contract */
if (lstr_parm.tc_hire_in = 1 and not isnull(li_tcowner)) or (lstr_parm.tc_hire_in = 0) then
	lstr_parm.vessel_nr = li_vessel_nr
	lstr_parm.purpose = ls_purpose
	if lstr_parm.purpose = is_DELIVERY then
		lstr_parm.arrival = true
	else
		lstr_parm.arrival = false
	end if
	
	setnull(lstr_parm.arrival_departure)
	
	openwithparm(w_confirm_arrival_departure, lstr_parm)
	lstr_parm = message.powerobjectparm
	if isnull(lstr_parm.arrival_departure) then
		messagebox("Input Missing", "Please enter Arrival or Departure date.")
		return c#return.NoAction
	end if
	if isnull(lstr_parm.lt_to_utc_difference) then
		messagebox("Input Missing", "Please enter time difference between LT and UTC.")
		return c#return.NoAction
	end if
	
	openwithparm(w_select_tc_contract, lstr_parm)
	ll_contractid = message.doubleparm
	if isnull(ll_contractid) or ll_contractid = 0 then
		messagebox("Input Missing", "It is not possible to Approve Message, because TC contract not found.")
		return c#return.NoAction
	else
		if ls_purpose = is_DELIVERY then		/* Delivery update arrival date */
			SELECT DELIVERY, LOCAL_TIME INTO :ldt_contract_arrival_departure, :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractid;
			if lb_contract_localtime then
				ldt_calculated_arrival_departure = lstr_parm.arrival_departure
			else
				ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(lstr_parm.arrival_departure) + (lstr_parm.lt_to_utc_difference * 3600))
			end if
			if ldt_calculated_arrival_departure <> ldt_contract_arrival_departure then
				of_set_status(c#msps.ii_FAILED, "The Approval fails because ATA does not match the delivery date of the TC contract.", adw_msps_message)
				return c#return.Failure
			else
				ids_poc.setItem(1, "contract_id", ll_contractid)
				ids_poc.setItem(1, "port_arr_dt", lstr_parm.arrival_departure)
				ids_poc.setItem(1, "lt_to_utc_difference", lstr_parm.lt_to_utc_difference)
			end if
		else   /* Re-delivery update departure date */
			SELECT max(PERIODE_END) INTO :ldt_contract_arrival_departure FROM NTC_TC_PERIOD WHERE CONTRACT_ID = :ll_contractid;
			SELECT LOCAL_TIME INTO :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractid;
			if lb_contract_localtime then
				ldt_calculated_arrival_departure = lstr_parm.arrival_departure
			else
				ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(lstr_parm.arrival_departure) + (lstr_parm.lt_to_utc_difference * 3600))
			end if
			if ldt_calculated_arrival_departure <> ldt_contract_arrival_departure then
				of_set_status(c#msps.ii_FAILED, "The Approval fails because ETD does not match the last period end date of the TC contract.", adw_msps_message)
				return c#return.Failure
			else
				ids_poc.setItem(1, "contract_id", ll_contractid)
				ids_poc.setItem(1, "port_dept_dt", lstr_parm.arrival_departure)
				ids_poc.setItem(1, "lt_to_utc_difference", lstr_parm.lt_to_utc_difference)
			end if
		end if
		
	end if
end if

return c#return.Success
end function

public function integer of_set_rob_latest (mt_u_datawindow adw_msps_noon);/********************************************************************
   of_set_rob_latest
   <DESC>Set ROB latest bunker to POC Estimate and vessel bunker stock</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_noon
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	23-10-2013 CR3340       LHC010        Set ROB latest bunker to POC Estimate and vessel bunker stock
   </HISTORY>
********************************************************************/

datetime ldt_rob_date, ldt_stock_lastupdated
decimal ld_rob_hs_hfo, ld_rob_ls_mdo, ld_rob_hs_mdo, ld_rob_ls_hfo

if ids_poc_est.rowcount( ) <> 1 then return c#return.Failure

ldt_rob_date = adw_msps_noon.getitemdatetime(1, "rob_latest_date_lt")
ld_rob_hs_hfo = adw_msps_noon.getitemdecimal(1, "rob_latest_hs_hfo")
ld_rob_ls_mdo = adw_msps_noon.getitemdecimal(1, "rob_latest_ls_mdo")
ld_rob_hs_mdo = adw_msps_noon.getitemdecimal(1, "rob_latest_hs_mdo")
ld_rob_ls_hfo = adw_msps_noon.getitemdecimal(1, "rob_latest_ls_hfo")

//Set ROB latest bunker to POC Estimate
ids_poc_est.setitem(1, "rob_latest_date", ldt_rob_date)
ids_poc_est.setitem(1, "rob_hfo", ld_rob_hs_hfo)
ids_poc_est.setitem(1, "rob_do", ld_rob_ls_mdo)
ids_poc_est.setitem(1, "rob_go", ld_rob_hs_mdo)
ids_poc_est.setitem(1, "rob_lshfo", ld_rob_ls_hfo)

//Vessel bunker stock
if ids_vessel_bunker.retrieve(adw_msps_noon.getitemnumber(1, "vessel_nr")) > 0 then
	ldt_stock_lastupdated = ids_vessel_bunker.getitemdatetime(1, "stock_lastupdated")
	
	if isnull(ldt_stock_lastupdated) or ldt_rob_date >= ldt_stock_lastupdated then
		ids_vessel_bunker.setitem(1, "stock_lastupdated", ldt_rob_date)
		ids_vessel_bunker.setitem(1, "stock_hfo", ld_rob_hs_hfo)
		ids_vessel_bunker.setitem(1, "stock_do", ld_rob_ls_mdo)
		ids_vessel_bunker.setitem(1, "stock_go", ld_rob_hs_mdo)
		ids_vessel_bunker.setitem(1, "stock_lshfo", ld_rob_ls_hfo)
	end if
end if

return c#return.Success
end function

on n_approve_vesselmsg.create
call super::create
end on

on n_approve_vesselmsg.destroy
call super::destroy
end on

event constructor;call super::constructor;inv_approve_cargo   = create n_approve_cargo
inv_approve_heating = create n_approve_heating
inv_autoschedule    = create n_autoschedule

//Initial Act. POC 
ids_poc = create mt_n_datastore
ids_poc.dataobject = "d_sq_gr_act_poc_detail"
ids_poc.settransobject(sqlca)

//Initial Est. POC
ids_poc_est = create mt_n_datastore
ids_poc_est.dataobject = "d_sq_gr_est_poc_detail"
ids_poc_est.settransobject(sqlca)

//Initial PROCEED
ids_proceed = create mt_n_datastore
ids_proceed.dataobject = "d_sq_gr_proceed_detail"
ids_proceed.settransobject(sqlca)

//Initial heating claim and price datastore
ids_claim = create mt_n_datastore
ids_claim.dataobject = 'd_sq_ff_claim_base'
ids_claim.settransobject(sqlca)

ids_heating_price = create mt_n_datastore
ids_heating_price.dataobject = 'd_sq_ff_hea_dev_claim'
ids_heating_price.settransobject(sqlca)

//Initial vessel bunker stock
ids_vessel_bunker = create mt_n_datastore
ids_vessel_bunker.dataobject = "d_sq_ff_vessel_detail"
ids_vessel_bunker.settransobject(sqlca)
end event

event destructor;call super::destructor;destroy inv_approve_heating
destroy inv_autoschedule
destroy ids_poc
destroy ids_poc_est
destroy ids_proceed
destroy ids_claim
destroy ids_heating_price
destroy ids_vessel_bunker
end event

