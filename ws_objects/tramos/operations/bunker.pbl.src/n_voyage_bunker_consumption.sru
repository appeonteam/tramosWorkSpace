$PBExportHeader$n_voyage_bunker_consumption.sru
$PBExportComments$Calculate bunker values for a given voyage.
forward
global type n_voyage_bunker_consumption from nonvisualobject
end type
end forward

global type n_voyage_bunker_consumption from nonvisualobject
end type
global n_voyage_bunker_consumption n_voyage_bunker_consumption

type variables
n_ds_lifted_bunker		ids_bunker_lifted
private integer				ii_vessel
private string				is_voyage, is_bunkertype
private datetime			idt_poc_arrival
end variables

forward prototypes
public function integer of_getconsumptionton (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_ton)
private function integer of_getvoyageendstock (ref decimal ad_endstock)
private function integer of_getvoyageliftedbunker (ref decimal ad_lifted)
private function integer of_getvoyagestartstock (ref decimal ad_startstock)
private function integer of_initialize ()
public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_total_price, ref decimal ad_total_ton)
private function integer of_identify_poc ()
private function string of_getvesselrefnumber (long al_vessel_nr)
private subroutine of_messagebox (string as_title, string as_message)
end prototypes

public function integer of_getconsumptionton (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_ton);/* This function finds the bunker consumption for a given voyage and bunker type 
	
	First find out is start value Stock
	Get sum of all lifted bunker, 
	get last departure value for this voyage
	and calculate consumption
*/	
datetime		ldt_startport, ldt_endport
string 		ls_previous_voyage
decimal {4}	ld_startstock, ld_endstock, ld_lifted, ld_consumption

ii_vessel			= ai_vessel
is_voyage		= as_voyage
is_bunkertype	= as_bunkertype

/* Voyage start stock ton */
if of_getvoyagestartstock( ld_startstock ) =-1 then
	return -1
end if

/* Lifted bunker ton on voyage */
if of_getvoyageliftedbunker( ld_lifted ) =-1 then
	return -1
end if

/* Voyage end stock ton */
if of_getvoyageendstock( ld_endstock ) =-1 then
	return -1
end if

ld_consumption = (ld_startstock + ld_lifted) - ld_endstock
ad_ton = ld_consumption
return 1

end function

private function integer of_getvoyageendstock (ref decimal ad_endstock);/* This function gets voyage end stock value, based on bunker type */
datastore 	lds_data
decimal{4}	ld_stock

/* Departure bunker on previous last depatrure */
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_poc_endstock_current"
lds_data.setTransObject(sqlca)
if lds_data.retrieve(ii_vessel, is_voyage) <> 1 then
	of_MessageBox("Select Failed", "No Departure bunker can be found for current voyage!~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_getVoyageEndStock())")
	rollback;
	destroy lds_data
	return -1
end if
commit;

choose case upper(is_bunkertype)
	case "HFO"
		ld_stock = lds_data.getItemDecimal(1, "dept_hfo")
	case "DO"
		ld_stock = lds_data.getItemDecimal(1, "dept_do")
	case "GO"
		ld_stock = lds_data.getItemDecimal(1, "dept_go")
	case "LSHFO"
		ld_stock = lds_data.getItemDecimal(1, "dept_lshfo")
end choose

if isNull(ld_stock) then
	ld_stock = 0
end if

ad_endstock = ld_stock
destroy lds_data
return 1

end function

private function integer of_getvoyageliftedbunker (ref decimal ad_lifted);/* This function gets bunker lifted on voyage based on bunker type */
datastore 	lds_data
decimal{4}	ld_lifted

lds_data = create datastore
lds_data.dataObject = "d_sq_tb_lifted_current_voyage"
lds_data.setTransObject(sqlca)
if lds_data.retrieve(ii_vessel, is_voyage) <> 1 then
	ld_lifted = 0
else
	choose case upper(is_bunkertype)
		case "HFO"
			ld_lifted = lds_data.getItemDecimal(1, "lifted_hfo")
		case "DO"
			ld_lifted = lds_data.getItemDecimal(1, "lifted_do")
		case "GO"
			ld_lifted = lds_data.getItemDecimal(1, "lifted_go")
		case "LSHFO"
			ld_lifted = lds_data.getItemDecimal(1, "lifted_lshfo")
	end choose
end if
commit;

if isNull(ld_lifted) then
	ld_lifted = 0
end if

ad_lifted = ld_lifted
destroy lds_data
return 1

end function

private function integer of_getvoyagestartstock (ref decimal ad_startstock);/* This function gets voyage start stock value, based on bunker type */
datastore 	lds_data
decimal{4}	ld_stock_current, ld_stock_previous
long			ll_rows

/* Departure bunker on previous last depatrure */
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_poc_startstock_previous"
lds_data.setTransObject(sqlca)
if lds_data.retrieve(ii_vessel, is_voyage) = -1 then
	of_MessageBox("Select Failed", "No Departure bunker can be found for previous voyage!~r~n" &
					+ "Vessel# " + of_getVesselRefNumber(ii_vessel) + " voyage# " +is_voyage +"~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_getVoyageStartStock())")
	rollback;
	destroy lds_data
	return -1
end if
commit;

ll_rows = lds_data.rowCount()
if ll_rows > 0 then
	choose case upper(is_bunkertype)
		case "HFO"
			ld_stock_previous = lds_data.getItemDecimal(1, "dept_hfo")
		case "DO"
			ld_stock_previous = lds_data.getItemDecimal(1, "dept_do")
		case "GO"
			ld_stock_previous = lds_data.getItemDecimal(1, "dept_go")
		case "LSHFO"
			ld_stock_previous = lds_data.getItemDecimal(1, "dept_lshfo")
	end choose
	
	if isNull(ld_stock_previous ) then
		ld_stock_previous = 0
	end if
else
	setNull(ld_stock_previous)    //no previous voyage. This is the first one.
end if

/* Arrival bunker on first portcall */
lds_data.dataObject = "d_sq_tb_poc_startstock_current"
lds_data.setTransObject(sqlca)
if lds_data.retrieve(ii_vessel, is_voyage) <> 1 then
	of_MessageBox("Select Failed", "No Arrival bunker can be found for this voyage!~r~n" &
					+ "Vessel# " + of_getVesselRefNumber(ii_vessel) + " voyage# " +is_voyage +"~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_getVoyageStartStock())")
	rollback;
	destroy lds_data
	return -1
end if
commit;

choose case upper(is_bunkertype)
	case "HFO"
		ld_stock_current = lds_data.getItemDecimal(1, "arr_hfo")
	case "DO"
		ld_stock_current = lds_data.getItemDecimal(1, "arr_do")
	case "GO"
		ld_stock_current = lds_data.getItemDecimal(1, "arr_go")
	case "LSHFO"
		ld_stock_current = lds_data.getItemDecimal(1, "arr_lshfo")
end choose

if isNull(ld_stock_current ) then
	ld_stock_current = 0
end if

if not isnull(ld_stock_previous) and ld_stock_current > ld_stock_previous then
	if isValid(w_tramos_main) then
		if isValid(w_generate_supervasfile_control) then
			w_generate_supervasfile_control.dw_message.insertRow(1)
			w_generate_supervasfile_control.dw_message.setItem(1, "message", &
						"Bunker registration mismatch. Not able to calculate bunker, current voyage higher value then previous~r~n" &
						+ "Vessel# " + of_getVesselRefNumber(ii_vessel) + " voyage# " +is_voyage +"~r~n~r~n" &
						+ "(Object: n_voyage_bunker_consumption.of_getVoyageStartStock())")
			
		else	
			of_MessageBox("Bunker Error", "Bunker registration mismatch. Not able to calculate bunker, current voyage higher value then previous~r~n" &
						+ "Vessel# " + of_getVesselRefNumber(ii_vessel) + " voyage# " +is_voyage +"~r~n~r~n" &
						+ "(Object: n_voyage_bunker_consumption.of_getVoyageStartStock())")
		end if
	end if
end if

if not isnull(ld_stock_previous) and ld_stock_previous > 0 then 
	ad_startstock = ld_stock_previous
else
	ad_startstock = ld_stock_current
end if

destroy lds_data
return 1
end function

private function integer of_initialize ();/* This function sets the datastores according to which bunker type to calculate */
choose case upper(is_bunkertype)
	case "HFO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_hfo"
		ids_bunker_lifted.setTransObject( sqlca )
	case "DO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_do"
		ids_bunker_lifted.setTransObject( sqlca )
	case "GO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_go"
		ids_bunker_lifted.setTransObject( sqlca )
	case "LSHFO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_lshfo"
		ids_bunker_lifted.setTransObject( sqlca )
end choose		

if isNull(ii_vessel) then
	of_MessageBox("Missing Parameter", "Bunker Consumption can't be calculated as vessel number is not given!~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_initialize())")
	return -1
end if
if isNull(is_voyage) then
	of_MessageBox("Missing Parameter", "Bunker Consumption can't be calculated as voyage number is not given!~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_initialize())")
	return -1
end if

return 1
end function

public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_total_price, ref decimal ad_total_ton);/* This function calculates the price for bunker used when vessel if off-service 
	The calculation is splitted into several steps
	
	1) Initialize which bunker type to calculate
	2) get start, lifted and end bunker values
	3) find out from which port of call the calculation should be based on
		always the last one
*/
long 			ll_liftrows, ll_liftrow
decimal{4}	ld_start, ld_price, ld_lifted, ld_used, ld_rob_atend
boolean		lb_used_negative

/* Set instance variables for further use */
is_bunkertype 	= as_bunkertype
ii_vessel			= ai_vessel
is_voyage		= as_voyage

/* Initialize datastores and retrieve off-services */
if of_initialize( ) = -1 then
	of_MessageBox("Initialization Failed", "An error occured when trying to initialize datastores!~r~n~r~n" &
					+ "(Object: n_voyage_offservice_bunker_consumption.of_calculate())")
	return -1
end if

if of_getvoyagestartstock(ld_start) = -1 then
	return -1
end if
	
if of_getvoyageliftedbunker(ld_lifted) = -1 then
	return -1
end if
if of_getvoyageendstock(ld_rob_atend) = -1 then
	return -1
end if

ld_used = (ld_start + ld_lifted) - ld_rob_atend
ad_total_ton = ld_used								//return value set here as ld_used will be reduced in loop

if ad_total_ton = 0 then	 //if nothing used just return - implemented 27/11-06 (14.16)
	ad_total_price = 0
	return 1
end if

if ld_used < 0 then
	ld_used = abs(ld_used)
	lb_used_negative = true
else
	lb_used_negative = false
end if
/* Identify from which POC to start calculation from */
if of_identify_poc(  ) = -1 then
	of_MessageBox("Identify POC", "An error occured when trying to identify Port of Call!~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_calculate())")
	return -1
end if
		
/* Find out how many bunker purchases to load in order to calculate price, and set load limit */
ids_bunker_lifted.id_stop_load = ld_rob_atend + ld_used

ll_liftrows = ids_bunker_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival)
commit;
/* reduce rows for value on board */
for ll_liftrow = 1 to ll_liftrows
	if ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") <= ld_rob_atend then
		ld_rob_atend -= ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
		ids_bunker_lifted.deleterow( ll_liftrow )
		ll_liftrow --
		ll_liftrows -- 
	else
		ids_bunker_lifted.setItem(ll_liftrow, "lifted", ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") -ld_rob_atend)
		exit
	end if
next 	
/* calculate value */
ll_liftrows = ids_bunker_lifted.rowCount()
ld_price = 0
for ll_liftrow = 1 to ll_liftrows
	if ld_used > ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") then
		ld_price +=  ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
		ld_used -= ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
	else
		ld_price += ld_used * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
		exit
	end if
next

if lb_used_negative then
	ld_price *= -1
end if

ad_total_price = ld_price
return 1
end function

private function integer of_identify_poc ();/* This function identifies which POC to start the calculation from 
	and it is always the last port of call for this voyage	 */
SELECT MAX(PORT_ARR_DT)
	INTO :idt_poc_arrival
	FROM POC
	WHERE VESSEL_NR = :ii_vessel
	AND VOYAGE_NR = :is_voyage;
IF sqlca.sqlcode <> 0 then
	of_MessageBox("Select Error", "No POC found for selected vessel/voyage!~r~n~r~n" &
					+ "(Object: n_voyage_bunker_consumption.of_identify_poc())")
	commit;				
	return -1
end if	

commit;
return 1
end function

private function string of_getvesselrefnumber (long al_vessel_nr);string		ls_vessel_ref

SELECT VESSEL_REF_NR  
	INTO :ls_vessel_ref  
	FROM VESSELS  
	WHERE VESSEL_NR = :al_vessel_nr;

return ls_vessel_ref	
 
end function

private subroutine of_messagebox (string as_title, string as_message);/* If the capture window is open, store the messages there, otherwise show the messsagebox */
if isValid(w_messagebox_capture) then
	w_messagebox_capture.wf_addmessage(as_title, as_message)
else
	messageBox(as_title, as_message)
end if

end subroutine

on n_voyage_bunker_consumption.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_voyage_bunker_consumption.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_bunker_lifted = create n_ds_lifted_bunker
end event

event destructor;destroy ids_bunker_lifted
end event

