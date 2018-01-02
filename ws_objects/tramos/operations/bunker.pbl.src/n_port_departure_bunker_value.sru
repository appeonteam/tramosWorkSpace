$PBExportHeader$n_port_departure_bunker_value.sru
$PBExportComments$Calculate bunker values when vessel depart from a given portcall.
forward
global type n_port_departure_bunker_value from mt_n_nonvisualobject
end type
end forward

global type n_port_departure_bunker_value from mt_n_nonvisualobject
end type
global n_port_departure_bunker_value n_port_departure_bunker_value

type variables
n_ds_lifted_bunker		ids_bunker_lifted
private integer				ii_vessel, ii_pcn
private string				is_voyage, is_bunkertype, is_portcode
private datetime			idt_poc_arrival
private	integer			_ii_reporttype = 1
constant integer ii_STANDARD = 1
constant integer ii_VESSELSTOCK = 2
end variables

forward prototypes
private function integer of_initialize ()
public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, ref decimal ad_arrivalvalue)
private function integer of_getportdeparturestock (ref decimal ad_departstock)
public function integer of_getdetailbunkerid (ref datastore ads_stock)
private subroutine of_messagebox (string as_title, string as_message)
public function integer of_setreporttype (integer ai_reporttype)
public function integer of_getreporttype ()
public subroutine documentation ()
end prototypes

private function integer of_initialize ();/* This function sets the datastores according to which bunker type to calculate 
	
	Function also changes the SQL to not retrieving bunker purchases for current portcall*/
string ls_sql

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
					+ "(Object: n_port_departure_bunker_valueof_initialize())")
	return -1
end if
if isNull(is_voyage) then
	of_MessageBox("Missing Parameter", "Bunker Consumption can't be calculated as voyage number is not given!~r~n~r~n" &
					+ "(Object: n_port_departure_bunker_valueof_initialize())")
	return -1
end if

return 1
end function

public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, ref decimal ad_arrivalvalue);/* This function calculates the price for bunker on board at arrival at given port 
	The calculation is splitted into several steps
	
	1) Initialize which bunker type to calculate, if "ALL" walk throught the types one by one
	2) get departure stock, lifted bunker value
	3) find out from which port of call the calculation should be based on */
long 			ll_liftrows, ll_liftrow, ll_bunker_counter
decimal{4}	ld_bunker_on_board, ld_price
string			ls_bunkertypes[4] = {"HFO", "DO", "GO", "LSHFO"}  //Used when type is all, and we have to do all types

/* Get port arrival date for this port	 */
SELECT PORT_ARR_DT
	INTO :idt_poc_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn;
IF sqlca.sqlcode <> 0 then
	of_MessageBox("Select Error", "No Arrival Date found for selected vessel/voyage/port! (V"+string(ai_vessel)+"/T"+as_voyage+"/P"+as_portcode+"/pcn#"+string(ai_pcn)+")~r~n~r~n" &
					+ "(Object: n_port_departure_bunker_value.of_calculate())")
	commit;				
	return -1
end if	
commit;

/* Set instance variables for further use */
ii_vessel			= ai_vessel
is_voyage		= as_voyage
is_portcode		= as_portcode
ii_pcn				= ai_pcn

if upper(as_bunkertype) = "ALL" then
	for ll_bunker_counter = 1 to 4
		is_bunkertype = ls_bunkertypes[ ll_bunker_counter ]
		/* Initialize datastores and retrieve off-services */
		if of_initialize( ) = -1 then
			of_MessageBox("Initialization Failed", "An error occured when trying to initialize datastores!~r~n~r~n" &
							+ "(Object: n_port_departure_bunker_value.of_calculate())")
			return -1
		end if
		
		if of_getportdeparturestock( ld_bunker_on_board) = -1 then
			return -1
		end if
		if ld_bunker_on_board = 0 then continue			// nothing to calculate goto next type
		
		/* Set value for how many bunker purchases to load in order to calculate price */
		ids_bunker_lifted.id_stop_load = ld_bunker_on_board
		ll_liftrows = ids_bunker_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival)
		commit;
		/* calculate value */
		ld_price = 0
		for ll_liftrow = 1 to ll_liftrows
			if ld_bunker_on_board > ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") then
				ld_price +=  ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
				ld_bunker_on_board -= ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
			else
				ld_price += ld_bunker_on_board * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
				exit
			end if
		next
		if not isNull(ld_price) then 
			ad_arrivalvalue += ld_price
		end if
	next
else
	/* Initialize datastores and retrieve off-services */
	is_bunkertype = as_bunkertype
	if of_initialize( ) = -1 then
		of_MessageBox("Initialization Failed", "An error occured when trying to initialize datastores!~r~n~r~n" &
						+ "(Object: n_port_departure_bunker_value.of_calculate())")
		return -1
	end if
	
	if of_getportdeparturestock( ld_bunker_on_board) = -1 then
		return -1
	end if
	if ld_bunker_on_board = 0 then   // if nothing to calculate return
		ad_arrivalvalue = 0
		return 1
	end if
	
	/* Set value for how many bunker purchases to load in order to calculate price */
	ids_bunker_lifted.id_stop_load = ld_bunker_on_board
	ll_liftrows = ids_bunker_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival)
	commit;
	/* calculate value */
	ll_liftrows = ids_bunker_lifted.rowCount()
	ld_price = 0
	for ll_liftrow = 1 to ll_liftrows
		if ld_bunker_on_board > ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") then
			ld_price +=  ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
			ld_bunker_on_board -= ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
		else
			ld_price += ld_bunker_on_board * ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
			exit
		end if
	next
	ad_arrivalvalue = ld_price
end if

return 1
end function

private function integer of_getportdeparturestock (ref decimal ad_departstock);/* This function gets port arrival start stock value, based on bunker type */
mt_n_datastore 	lds_data
decimal{4}	ld_stock_current
string ls_columnprefix = "dept_"

/* Departure bunker on given portcall */

lds_data = create mt_n_datastore

if of_getreporttype( ) = ii_STANDARD then
	lds_data.dataobject = "d_sq_tb_endstock_given_poc"
	lds_data.setTransObject(sqlca)
	if lds_data.retrieve(ii_vessel, is_voyage, is_portcode, ii_pcn ) <> 1 then
		of_MessageBox("Select Failed", "No Departure bunker can be found for this voyage/port!~r~n~r~n" &
						+ "(Object: n_port_departure_bunker_value.of_getportdeparturestock())")
		rollback;
		destroy lds_data
		return -1
	end if
	
elseif of_getreporttype( ) = ii_VESSELSTOCK then
	lds_data.dataObject = "d_sq_tb_endstock_given_vessel"
	ls_columnprefix = "stock_"
	lds_data.setTransObject(sqlca)
	if lds_data.retrieve(ii_vessel) <> 1 then
		of_MessageBox("Select Failed", "No bunker stock can be found for this vessel!~r~n~r~n" &
						+ "(Object: n_port_departure_bunker_value.of_getportdeparturestock())")
		rollback;
		destroy lds_data
		return -1
	end if
	
end if	

commit;

choose case upper(is_bunkertype)
	case "HFO"
		ld_stock_current = lds_data.getItemDecimal(1, ls_columnprefix + "hfo")
	case "DO"
		ld_stock_current = lds_data.getItemDecimal(1, ls_columnprefix + "do")
	case "GO"
		ld_stock_current = lds_data.getItemDecimal(1, ls_columnprefix + "go")
	case "LSHFO"
		ld_stock_current = lds_data.getItemDecimal(1, ls_columnprefix + "lshfo")
end choose

if isNull(ld_stock_current ) then
	ld_stock_current = 0
end if

ad_departstock = ld_stock_current

destroy lds_data
return 1
end function

public function integer of_getdetailbunkerid (ref datastore ads_stock);ads_stock = ids_bunker_lifted

return 1
end function

private subroutine of_messagebox (string as_title, string as_message);/* If the capture window is open, store the messages there, otherwise show the messsagebox */
if isValid(w_messagebox_capture) then
	w_messagebox_capture.wf_addmessage(as_title, as_message)
else
	messageBox(as_title, as_message)
end if

end subroutine

public function integer of_setreporttype (integer ai_reporttype);_ii_reporttype = ai_reporttype
return c#return.Success
end function

public function integer of_getreporttype ();return _ii_reporttype
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_port_departure_bunker_value
	
	<OBJECT>
		assists calculation of bunker stock amounts
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
  	<USAGE>
		w_bunker_rpt_base and its ancestors
	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		24/05/12 	cr#2777 	AGL				ACE#68 updated object for bunker stock PoC report update.
********************************************************************/



end subroutine

on n_port_departure_bunker_value.create
call super::create
end on

on n_port_departure_bunker_value.destroy
call super::destroy
end on

event constructor;ids_bunker_lifted = create n_ds_lifted_bunker
end event

event destructor;destroy ids_bunker_lifted
end event

