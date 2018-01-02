$PBExportHeader$n_port_arrival_bunker_value.sru
$PBExportComments$Calculate bunker values when vessel arrives at given portcall.
forward
global type n_port_arrival_bunker_value from nonvisualobject
end type
end forward

global type n_port_arrival_bunker_value from nonvisualobject
end type
global n_port_arrival_bunker_value n_port_arrival_bunker_value

type variables
n_ds_lifted_bunker		ids_bunker_lifted
private integer				ii_vessel, ii_pcn
private string				is_voyage, is_bunkertype, is_portcode
private datetime			idt_poc_arrival
end variables

forward prototypes
private function integer of_initialize ()
private function integer of_getportarrivalstock (ref decimal ad_startstock)
public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, ref decimal ad_arrivalvalue)
private subroutine of_messagebox (string as_title, string as_message)
end prototypes

private function integer of_initialize ();/* This function sets the datastores according to which bunker type to calculate 
	
	Function also changes the SQL to not retrieving bunker purchases for current portcall*/
string ls_sql

choose case upper(is_bunkertype)
	case "HFO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_hfo"
		ids_bunker_lifted.setTransObject( sqlca )
			ls_sql = "SELECT BP_DETAILS.LIFTED_HFO as LIFTED, " &   
         		+"isnull(BP_DETAILS.PRICE_HFO,0)  as PRICE, "&
	   		+"BP_DETAILS.BPN as BPN "&
    			+"FROM BP_DETAILS, "&   
         		+"POC "&  
   			+"WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR and "&
          		+"POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR and "&
          		+"POC.PORT_CODE = BP_DETAILS.PORT_CODE and "&
          		+"POC.PCN = BP_DETAILS.PCN  and "&
          		+"BP_DETAILS.VESSEL_NR = :vessel  AND "&
          		+"((POC.PORT_ARR_DT < :arrival_date) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'RED' and char_length(RTRIM(POC.VOYAGE_NR)) = 7) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'DEL' and char_length(RTRIM(POC.VOYAGE_NR)) = 5)) and "&
	    		+"BP_DETAILS.LIFTED_HFO <> 0 "&
			+"ORDER BY POC.PORT_ARR_DT DESC, "& 
         		+"BP_DETAILS.FIFO_SEQUENCE DESC "  
//		ids_bunker_lifted.Modify("DataWindow.Table.Select='"+ ls_sql +"'")
		ids_bunker_lifted.Object.DataWindow.Table.Select=ls_sql
	case "DO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_do"
		ids_bunker_lifted.setTransObject( sqlca )
			ls_sql = "SELECT BP_DETAILS.LIFTED_DO as LIFTED, " &   
         		+"isnull(BP_DETAILS.PRICE_DO,0)  as PRICE, "&
	   		+"BP_DETAILS.BPN as BPN "&
    			+"FROM BP_DETAILS, "&   
         		+"POC "&  
   			+"WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR and "&
          		+"POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR and "&
          		+"POC.PORT_CODE = BP_DETAILS.PORT_CODE and "&
          		+"POC.PCN = BP_DETAILS.PCN  and "&
          		+"BP_DETAILS.VESSEL_NR = :vessel  AND "&
          		+"((POC.PORT_ARR_DT < :arrival_date) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'RED' and char_length(RTRIM(POC.VOYAGE_NR)) = 7) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'DEL' and char_length(RTRIM(POC.VOYAGE_NR)) = 5)) and "&
	    		+"BP_DETAILS.LIFTED_DO <> 0 "&
			+"ORDER BY POC.PORT_ARR_DT DESC, "& 
         		+"BP_DETAILS.FIFO_SEQUENCE DESC "
		ids_bunker_lifted.Object.DataWindow.Table.Select=ls_sql
	case "GO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_go"
		ids_bunker_lifted.setTransObject( sqlca )
			ls_sql = "SELECT BP_DETAILS.LIFTED_GO as LIFTED, " &   
         		+"isnull(BP_DETAILS.PRICE_GO,0)  as PRICE, "&
	   		+"BP_DETAILS.BPN as BPN "&
    			+"FROM BP_DETAILS, "&   
         		+"POC "&  
   			+"WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR and "&
          		+"POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR and "&
          		+"POC.PORT_CODE = BP_DETAILS.PORT_CODE and "&
          		+"POC.PCN = BP_DETAILS.PCN  and "&
          		+"BP_DETAILS.VESSEL_NR = :vessel  AND "&
          		+"((POC.PORT_ARR_DT < :arrival_date) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'RED' and char_length(RTRIM(POC.VOYAGE_NR)) =7) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'DEL' and char_length(RTRIM(POC.VOYAGE_NR)) = 5)) and "&
	    		+"BP_DETAILS.LIFTED_GO <> 0 "&
			+"ORDER BY POC.PORT_ARR_DT DESC, "& 
         		+"BP_DETAILS.FIFO_SEQUENCE DESC "
		ids_bunker_lifted.Object.DataWindow.Table.Select=ls_sql
	case "LSHFO"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_lshfo"
		ids_bunker_lifted.setTransObject( sqlca )
			ls_sql = "SELECT BP_DETAILS.LIFTED_LSHFO as LIFTED, " &   
         		+"isnull(BP_DETAILS.PRICE_LSHFO,0)  as PRICE, "&
	   		+"BP_DETAILS.BPN as BPN "&
    			+"FROM BP_DETAILS, "&   
         		+"POC "&  
   			+"WHERE  POC.VESSEL_NR = BP_DETAILS.VESSEL_NR and "&
          		+"POC.VOYAGE_NR = BP_DETAILS.VOYAGE_NR and "&
          		+"POC.PORT_CODE = BP_DETAILS.PORT_CODE and "&
          		+"POC.PCN = BP_DETAILS.PCN  and "&
          		+"BP_DETAILS.VESSEL_NR = :vessel  AND "&
          		+"((POC.PORT_ARR_DT < :arrival_date) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'RED' and char_length(RTRIM(POC.VOYAGE_NR)) = 7) "&
					 +"OR (POC.PORT_ARR_DT = :arrival_date  and POC.PURPOSE_CODE = 'DEL' and char_length(RTRIM(POC.VOYAGE_NR)) = 5)) and "&
	    		+"BP_DETAILS.LIFTED_LSHFO <> 0 "&
			+"ORDER BY POC.PORT_ARR_DT DESC, "& 
         		+"BP_DETAILS.FIFO_SEQUENCE DESC "
		ids_bunker_lifted.Object.DataWindow.Table.Select=ls_sql
end choose		

if isNull(ii_vessel) then
	of_MessageBox("Missing Parameter", "Bunker Consumption can't be calculated as vessel number is not given!~r~n~r~n" &
					+ "(Object: n_port_arrival_bunker_valueof_initialize())")
	return -1
end if
if isNull(is_voyage) then
	of_MessageBox("Missing Parameter", "Bunker Consumption can't be calculated as voyage number is not given!~r~n~r~n" &
					+ "(Object: n_port_arrival_bunker_valueof_initialize())")
	return -1
end if

return 1
end function

private function integer of_getportarrivalstock (ref decimal ad_startstock);/* This function gets port arrival start stock value, based on bunker type */
datastore 	lds_data
decimal{4}	ld_stock_current

/* Arrival bunker on given portcall */
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_startstock_given_poc"
lds_data.setTransObject(sqlca)
if lds_data.retrieve(ii_vessel, is_voyage, is_portcode, ii_pcn ) <> 1 then
	of_MessageBox("Select Failed", "No Arrival bunker can be found for this vessel/voyage/port!~r~n~r~n" &
					+ "(Object: n_port_arrival_bunker_value.of_getVoyageStartStock())")
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

ad_startstock = ld_stock_current

destroy lds_data
return 1
end function

public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, ref decimal ad_arrivalvalue);/* This function calculates the price for bunker on board at arrival at given port 
	The calculation is splitted into several steps
	
	1) Initialize which bunker type to calculate, if all walk throught the types one by one
	2) get arrival stock, lifted bunker value
	3) find out from which port of call the calculation should be based on
		always the last one */
long 			ll_liftrows, ll_liftrow, ll_bunker_counter
decimal{4}	ld_bunker_on_board, ld_price
string			ls_bunkertypes[4] = {"HFO", "DO", "GO", "LSHFO"}  //Used when type is all, and we have to do all types

/* Get port arrival date for this voyage	 */
SELECT PORT_ARR_DT
	INTO :idt_poc_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn;
IF sqlca.sqlcode <> 0 then
	of_MessageBox("Select Error", "No POC found for selected vessel/voyage! (V"+string(ai_vessel)+"/T"+as_voyage+"/P"+as_portcode+"/pcn#"+string(ai_pcn)+")~r~n~r~n" &
					+ "(Object: n_port_arrival_bunker_value.of_calculate())")
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
		/* Initialize datastores and retrieve  */
		if of_initialize( ) = -1 then
			of_MessageBox("Initialization Failed", "An error occured when trying to initialize datastores!~r~n~r~n" &
							+ "(Object: n_port_arrival_bunker_value.of_calculate())")
			return -1
		end if
		
		if of_getportarrivalstock( ld_bunker_on_board) = -1 then
			return -1
		end if
		if ld_bunker_on_board = 0 then continue 	// nothing to calculate goto next type
		
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
	/* Initialize datastores and retrieve  */
	is_bunkertype = as_bunkertype
	if of_initialize( ) = -1 then
		of_MessageBox("Initialization Failed", "An error occured when trying to initialize datastores!~r~n~r~n" &
						+ "(Object: n_port_arrival_bunker_value.of_calculate())")
		return -1
	end if
	
	if of_getportarrivalstock( ld_bunker_on_board) = -1 then
		return -1
	end if
	
	if ld_bunker_on_board = 0 then		// if nothing to calculate return
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

private subroutine of_messagebox (string as_title, string as_message);/* If the capture window is open, store the messages there, otherwise show the messsagebox */
if isValid(w_messagebox_capture) then
	w_messagebox_capture.wf_addmessage(as_title, as_message)
else
	messageBox(as_title, as_message)
end if

end subroutine

on n_port_arrival_bunker_value.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_port_arrival_bunker_value.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_bunker_lifted = create n_ds_lifted_bunker
end event

event destructor;destroy ids_bunker_lifted
end event

