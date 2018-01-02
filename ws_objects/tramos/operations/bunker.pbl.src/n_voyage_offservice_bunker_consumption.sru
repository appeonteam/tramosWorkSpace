$PBExportHeader$n_voyage_offservice_bunker_consumption.sru
$PBExportComments$Calculate off service bunker values for a given voyage.
forward
global type n_voyage_offservice_bunker_consumption from nonvisualobject
end type
end forward

global type n_voyage_offservice_bunker_consumption from nonvisualobject
end type
global n_voyage_offservice_bunker_consumption n_voyage_offservice_bunker_consumption

type variables

// shows offservices 
datastore					ids_bunker_used

// shows BP_Details for vessel, voyage on a specific date 
n_ds_lifted_bunker			ids_bunker_lifted

private integer				ii_vessel
private string				is_voyage, is_bunkertype
private datetime			idt_poc_arrival
integer 					ii_scenario 

end variables

forward prototypes
private function integer of_initialize ()
public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_total_price, ref decimal ad_total_ton)
public function integer of_find_match (string as_bunkertype, integer ai_vessel, string as_voyage, datetime adt_offstart, datetime adt_offend, decimal ad_stockstart)
private function integer of_forward_lifted ()
public function integer of_showcalculation (long al_ops_offserviceid, ref datawindow adw_show)
public function integer of_identify_poc (ref datetime adt_offstart, ref datetime adt_offend, ref decimal ad_stockstart, ref integer ai_scenario)
private function integer of_setloadreduction (ref decimal ad_stock_start_qty, ref decimal ad_departure_fuel_qty, ref decimal ad_fuel_used_qty, ref decimal ad_arrival_fuel_qty)
public function integer of_price_proposal (string as_bunkertype, integer ai_vessel, string as_voyage, datetime adt_offservice_start, decimal ad_stock_start, decimal ad_fuel_used, ref decimal ad_priceperton, datetime adt_offservice_end)
public function integer of_loadbunkervalues (long al_ops_offserviceid, ref decimal ad_hfo, ref decimal ad_do, ref decimal ad_go, ref decimal ad_lshfo)
private subroutine of_messagebox (string as_title, string as_message)
public subroutine documentation ()
end prototypes

private function integer of_initialize ();/* 
	This function 
	* sets the datastores according to which bunker type to calculate. 
	* validates the instance variables that the datastores rely upon. 
	* retrieves the ids_bunker_used bunkers datastore
*/



// based upon the bunker type, set Used and Lifted datastores
choose case upper(is_bunkertype)
	case "HFO"
		ids_bunker_used.dataObject = "d_sq_tb_offservice_used_hfo"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_hfo"
	case "DO"
		ids_bunker_used.dataObject = "d_sq_tb_offservice_used_do"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_do"
	case "GO"
		ids_bunker_used.dataObject = "d_sq_tb_offservice_used_go"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_go"
	case "LSHFO"
		ids_bunker_used.dataObject = "d_sq_tb_offservice_used_lshfo"
		ids_bunker_lifted.dataObject = "d_sq_tb_lifted_lshfo"
	case else
		of_Messagebox( &
			this.classname()+".of_initialize()", &
			"Invalid is_bunkertype specified: "+ is_bunkertype &
			);
		return -1 
end choose		

ids_bunker_used.setTransObject( sqlca )
ids_bunker_lifted.setTransObject( sqlca )


// validate vessel number 
if isNull(ii_vessel) then
	of_MessageBox("Missing Parameter", &
		"Off Service can't be calculated as vessel number is not given!~r~n~r~n" &
		+ "(Object: n_voyage_offservice_bunker_consumption.of_initialize())" & 
		)
	return -1
end if

// validate voyage string identifier 
if isNull(is_voyage) then
	of_MessageBox("Missing Parameter", & 
		"Off Service can't be calculated as voyage number is not given!~r~n~r~n" &
		+ "Object: n_voyage_offservice_bunker_consumption.of_initialize())" &
		)
	return -1
end if

// retrieve bunkers used for this (vessel, voyage) pair 
if ids_bunker_used.retrieve(ii_vessel, is_voyage) = -1 then
	
	// tell user 
	of_MessageBox("Retrieve Error", &
		"Retrieval of Off Services for given vessel voyage failed!~r~n~r~n" &
		+ "Object: n_voyage_offservice_bunker_consumption.of_initialize())" & 
		)
		
	// flush our transaction clean 
	commit;				
	
	// report an error to caller 
	return -1
	
end if

// flush our transaction cache 
commit;

return 1



end function

public function integer of_calculate (string as_bunkertype, integer ai_vessel, string as_voyage, ref decimal ad_total_price, ref decimal ad_total_ton);/***********************************************************************************************
	Object function of_calculate() calculates the price for bunker used during the period 
	when the vessel is in off-service. The calculation is split into several steps:
	1) Initialize which bunker type to calculate.
	2) Retrieve all offservices for given voyage, where given bunker type is used
	3) Determine which port of call the calculation should be based on
		a) Find the POC based on off-service start, and stock value on start 
		b) If no stock start given, then the calculation shall be based on the oldest part of 
		   bunker onboard at voyage start.
***********************************************************************************************/
long ll_bpn

long 		ll_liftrows
long 		ll_liftrow
datetime	ldt_offservice_start
datetime	ldt_offservice_end
decimal{4}	ld_stock_start_qty
decimal{4}	ld_price
decimal{4}	ld_bunker_used_fuel_qty
decimal{4}	ld_departure_fuel
decimal{4}	ld_arrival_fuel
decimal{4}	ld_lifted_calcsum 
boolean		lb_used_negative
integer		li_scenario

/* Set instance variables for further use by other funcs and events */
is_bunkertype 	= as_bunkertype
ii_vessel			= ai_vessel
is_voyage		= as_voyage

/* Initialize the datastores and retrieve off-services */
if (of_initialize() = -1) then											
	of_MessageBox("Initialization Failed", 									&
		"An error occured when trying to initialize datastores!~r~n~r~n" + 	&
		"(Object: n_voyage_offservice_bunker_consumption.of_calculate())" 	&
		)	
	return -1
end if

// initialize summaries for use within loop 
decimal{4}	ld_total_price
ld_total_price = 0

// initialize our total of all the rows' amount used 
decimal{4}	ld_bunker_used_fuel_qty_total
ld_bunker_used_fuel_qty_total = 0

// how many bunkers do we need to account for? 
long 		ll_bunker_used_rows
ll_bunker_used_rows = ids_bunker_used.rowcount()

/* Run through all off-services with bunker consumption, if any, and calculate price */

// for each offservice, pay for each bunker 
long 		ll_bunker_used_row
for ll_bunker_used_row = 1 to ll_bunker_used_rows
	
	// grab some values from this row
	ldt_offservice_start	= ids_bunker_used.getItemDatetime(ll_bunker_used_row, "start_date") // nn
	ldt_offservice_end		= ids_bunker_used.getItemDatetime(ll_bunker_used_row, "end_date")// nn
	
	// get stock start, valdate against null usage 
	ld_stock_start_qty 			= ids_bunker_used.getItemDecimal(ll_bunker_used_row, "stock_start") // nullable 
	if (IsNull(ld_stock_start_qty)) then 
		ld_stock_start_qty = 0
	end if 
	
	// get fuel used, valdate against null usage 
	ld_bunker_used_fuel_qty 				= ids_bunker_used.getItemDecimal(ll_bunker_used_row, "fuel_used") // is nullable 
	if (IsNull(ld_bunker_used_fuel_qty)) then 
		ld_bunker_used_fuel_qty = 0
	end if 

	// increment the total amount of fuel used by the amount used by the amount in this row 
	ld_bunker_used_fuel_qty_total += ld_bunker_used_fuel_qty
	
	// if the amount of used bunker for this row is a negative value 
	if (ld_bunker_used_fuel_qty < 0) then 
		
		// This can occur if the operators purposely put negative values into the system in order 
		// to compensate or correct other payments that they cannot change. 
		
		// use its absolute value from here on out
		ld_bunker_used_fuel_qty = abs(ld_bunker_used_fuel_qty)
		
		// remember that we used a negative value here, for later use
		lb_used_negative = true
		
	else
		
		// this row did not use a negative value 
		lb_used_negative = false
		
	end if
	
	/* Identify the POC, and the arrival date (idt_poc_arrival) 
	from which we will start our calculations. was it a successful attempt?  
	*/
	int iIDPOCsuccess 
	iIDPOCsuccess = of_identify_poc( ldt_offservice_start ,ldt_offservice_end, ld_stock_start_qty, li_scenario ) 
	if (iIDPOCsuccess = -1) then
		of_MessageBox("Identify POC", &
			"An error occured when trying to identify Port of Call!~r~n~r~n" + &
			"(Object: n_voyage_offservice_bunker_consumption.of_calculate())" &
			)
		return -1
	end if
	
	// Now that the POC has been identified, we have to scan through the recent bunker purchases 
	// to determine how much we have to reduce the load by, to calculate the amount of fuel on 
	// the vessel, because the bunker purchase details do not show exactly when the fuel was 
	// acquired, just when the purchase was confirmed. 

	/*	Find out how many bunker purchases to load, in order to calculate the price for 
	all the fuel that was used, determine success. 
	*/
	int iSetLoadReductionSuccess 
	iSetLoadReductionSuccess = of_setloadreduction( ld_stock_start_qty, ld_departure_fuel, ld_bunker_used_fuel_qty, ld_arrival_fuel ) 
	// ld_arrival_fuel is an output value of of_setloadreduction()
	if (iSetLoadReductionSuccess = -1) then
		of_MessageBox("Load Error", &
			"An error occured when trying to reduce load!~r~n~r~n" + &
			"(Object: n_voyage_offservice_bunker_consumption.of_calculate())" &
			)
		return -1
	end if

	// VALIDATE date of arrival before usage 
	datetime ldt_null // do not initialize, used for testing 
	if (idt_poc_arrival = ldt_null) then 
		of_messagebox( &
			this.classname()+".of_calculate()", &
			"Uninitialized idt_poc_arrival. Aborting. " &
			)
		return -1 
	end if 
	
	// retrieve data for bunkers lifted, validate successful retrieval
	ll_liftrows = ids_bunker_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival)
	choose case (ll_liftrows)
		case -1
			of_MessageBox("n_voyage_offservice_bunker_consumption.of_calculate())", &
				"Error -1 after ids_bunker_lifted.retrieve(). Aborting. " &
				)
			return -1
		case else 
	end choose
	
	commit;

	/* reduce departure / lifted dependent on scenario 
		Function also finds out which scenario of match we are in:
		0	= no match found. use oldest part of bunker on voyage
		1	= stock match on leg with bunker load in port before leg
		2 	= stock match on leg with no bunker load in port before leg
		3	= stock match in port. match before bunker load (Off Service stock start < port arrival bunker) 
		4	= stock match in port. match after bunker load (Off Service stock start >= port arrival bunker)
		5	= stock match in port. no bunker load
	*/
	
	decimal{4}	ld_reduce_qty
	choose case li_scenario
		
		case 0	//no match found. use oldest part of bunker on voyage
			// no reduction - there shall only be one purchase in datastore
			if ll_liftrows > 1 then
				ids_bunker_lifted.rowsdiscard(1, ll_liftrows - 1, primary!)				
				ll_liftrows = 1
			end if
			ids_bunker_lifted.setItem(1, "lifted", 100000)
						
		case 1	//stock match on leg with bunker load in port before leg
			ld_departure_fuel = ld_stock_start_qty
			
		case 2	//stock match on leg with no bunker load in port before leg
			// compute the amount to reduce 
			ld_reduce_qty 		= ld_departure_fuel - ld_stock_start_qty
			
			// decrement the last known POC fuel level by the amount that was used. 
			ld_departure_fuel 	-= ld_reduce_qty
			
		case 3	//stock match in port. match before bunker load
			// compute the amount of fuel used 
			ld_reduce_qty 		= ld_stock_start_qty - ld_arrival_fuel
			
			// set the amount lifted to this amount that was consumed 
			ids_bunker_lifted.setItem(1, "lifted", ld_reduce_qty )
			
			// assume the departure fuel level is the same as the amount at the start of voyage 
			ld_departure_fuel 	= ld_stock_start_qty
			
		case 4	//stock match in port. match after bunker load
			ld_departure_fuel 	= ld_stock_start_qty
			
		case 5	//stock match in port. no bunker load
			// no reduction	
			ld_departure_fuel = ld_stock_start_qty
			
	end choose		

//	// provide opportunity for debugging 
//	if (gb_developer) then
//		// DebugBreak()
//		f_datastore_spy(ids_bunker_lifted)
//		f_datastore_spy(ids_bunker_used)
//	end if 

	/* reduce rows for value on board */
	for ll_liftrow = 1 to ll_liftrows

		// how many tons were lifted here
		decimal ld_tons_lifted 
		ld_tons_lifted = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") 
		
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
		// reset to zero if null 
		if (IsNull(ld_tons_lifted)) then 
			ld_tons_lifted = 0.0; 
		end if 

		// if the amount lifted was less than the amount of departure fuel 
		if (ld_tons_lifted <= ld_departure_fuel) then
			
			// decrement the amount of departure fuel by the amount lifted. 
			ld_departure_fuel -= ld_tons_lifted
			
		else
			// if this row is the last row 
			if (ll_liftrow = ll_liftrows) then //last row
			
				if ii_scenario <> 0 then
					// set the amount lifted equal to the departure fuel left 
					ids_bunker_lifted.setItem(ll_liftrow, "lifted", ld_departure_fuel)
				end if
				
				// for debugging purposes, which BPN are we looking at? this is not used in any computations 
				ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
			else
				// what is the number value? 
				decimal ld_num_tons_lifted 
				ld_num_tons_lifted = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted")
				
				if (IsNull(ld_num_tons_lifted)) then 
					ld_num_tons_lifted = 0.0; 
				end if 

				decimal ld_temp 
				ld_temp=ld_num_tons_lifted - ld_departure_fuel
				
				// set the amount lifted equal to the difference 
				ids_bunker_lifted.setItem(ll_liftrow, "lifted", ld_temp)
				
			end if
			
			// escape out of loop 
			exit
			
		end if
	next 	

	/* 
	HER ER DER INDSAT KODE DER SÅFREMT DER ER ANVENDT MERE VED OFF-SERVICE END DER 
	BAGUD KAN BEREGNES, SÅ SKAL DER BEREGNES FREMADRETTET - RETRIEVE INDTIL DÆKNING 
	*/
	// for each of the lifted bunkers 
	for ll_liftrow = 1 to ll_liftrows
		
		// retrieve the row value into a local variable 
		decimal ld_amt_lifted 
		ld_amt_lifted = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
		if (IsNull(ld_num_tons_lifted)) then 
			ld_num_tons_lifted = 0.0; 
		end if 
				
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
		// increment the calculated sum of lifted bunker amounts by the amount in this row 
		ld_lifted_calcsum += ld_amt_lifted 
		
	next 	

	 // if the amount used was not zero 
	 // and the amount used was greater than then currently calculated sum of lifted bunker 
	 // and that lifted total is also not zero 
	if (									& 
		(ld_bunker_used_fuel_qty <> 0)  					&
		and (ld_lifted_calcsum <> 0) 		& 
		and (ld_bunker_used_fuel_qty > ld_lifted_calcsum) 	& 
		)  then

		// the amount of fuel used was more than the amount lifted, we have to "run forward" ?? 
		//of_messagebox("", "used greater than lifted - we have to run forward ~n~r~n~rV"+string(ai_vessel)+"T"+as_voyage)
		of_forward_lifted()
		
	end if
	
	/** IMPLEMENT HERTIL ******************************************************/	
	
	/* calculate value */
	
	// how many rows of lifted bunker do we have to process? 
	ll_liftrows = ids_bunker_lifted.rowCount()
	
	// init our cumulative price 
	ld_price = 0
	
	// go backwards through the rows, 
	// stilltodo: assume the rows are sorted properly ??? 
	for ll_liftrow = ll_liftrows to 1 step -1
		
		// get the amount lifted 
		decimal{4} ld_rev_amt_lifted
		ld_rev_amt_lifted = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
		
		// if value is null then reset to zero 
		if (IsNull(ld_rev_amt_lifted)) then
			ld_rev_amt_lifted = 0 
		end if 

		// how much did this cost? 
		decimal{4}  ld_lifted_price 
		ld_lifted_price = ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
		
		// if value is null then reset to zero 
		if (IsNull(ld_lifted_price)) then
			ld_lifted_price = 0 
		end if 
		
		// if the amount used was greater than the amount lifted
		if (ld_bunker_used_fuel_qty > ld_rev_amt_lifted) then
			
			// increment the total price so far by the amount lifted x the price lifted
			ld_price 	+= (ld_rev_amt_lifted * ld_lifted_price)
			
			// decrement the amount used by the amount lifted
			ld_bunker_used_fuel_qty 	-= ld_rev_amt_lifted
			
		else
			
			// increment the price by the amount left to be used times the price at that amount 
			ld_price 	+= (ld_bunker_used_fuel_qty * ld_lifted_price)
			
			// escape from out loop 
			exit
			
		end if
	next

	// if a negative price was used
	if lb_used_negative then
		ld_price *= -1
	end if
	
	// increment the total price by the price for this row 
	ld_total_price += ld_price
	
	// for this row, set the bunker used calculated price to this value we just calculated. 
	ids_bunker_used.setItem(ll_bunker_used_row, "calc_price", ld_price)
	
next

// set the arument total price to the amount we just calculated through all of the rows 
ad_total_price = ld_total_price

// set the argument total tonnage used tot the amount we just calculated for all these rows 
ad_total_ton = ld_bunker_used_fuel_qty_total

return 1



end function

public function integer of_find_match (string as_bunkertype, integer ai_vessel, string as_voyage, datetime adt_offstart, datetime adt_offend, decimal ad_stockstart);/* 
This function is used to find out if entered stock (in offservice) matches the 
stock values entered in Port of Call.
	
Called from Off Service validation 

Gives a warning to the user if no match 
*/



integer 	li_scenario, li_rc

/* Set instance variables for further use */
is_bunkertype 	= as_bunkertype
ii_vessel			= ai_vessel
is_voyage		= as_voyage

li_rc = of_identify_poc( adt_offstart , adt_offend , ad_stockstart , li_scenario )
/*	Function also finds out which scenario of match we are in:
		0	= no match found. use oldest part of bunker on voyage
		1	= stock match on leg with bunker load in port before leg
		2 	= stock match on leg with no bunker load in port before leg
		3	= stock match in port. match before bunker load (Off Service stock start < port arrival bunker) 
		4	= stock match in port. match after bunker load (Off Service stock start >= port arrival bunker)
		5	= stock match in port. no bunker load
*/

if (li_rc = -1) or (li_scenario = 0) then
	
	choose case as_bunkertype
		case "HFO"
			as_bunkertype = "HSFO"
		case "DO"
			as_bunkertype = "LSGO"
		case "GO"
			as_bunkertype = "HSGO"
		case "LSHFO"
			as_bunkertype = "LSFO"
	end choose
	
	of_MessageBox("Warning", &
		"It is not possible to match entered "+ as_bunkertype + &
		"~r~nstock with stock entered in Port of Call~r~n~r~n" + &
		"Please check if values are entered correct. Otherwise~r~n" + &
		"the price used is the oldest part of stock." &
		)
end if

return 1


end function

private function integer of_forward_lifted ();/* 	
This function will retrieve lifted bunker later on this voyage
this will only happen when the off-service is very long, and the vessel has
used a lot of bunker and therefore has been forced to lift while off-service 
*/



// create a datastore to hold forward lifted rows 
n_ds lds_forward_lifted
lds_forward_lifted = create n_ds

// set the datawindow based upon the type of bunker desired. 
choose case is_bunkertype
	case "HFO"
		lds_forward_lifted.dataObject = "d_sq_tb_bp_forward_lifted_hfo"
	case "DO"
		lds_forward_lifted.dataObject = "d_sq_tb_bp_forward_lifted_do"
	case "GO"
		lds_forward_lifted.dataObject = "d_sq_tb_bp_forward_lifted_go"
	case "LSHFO"
		lds_forward_lifted.dataObject = "d_sq_tb_bp_forward_lifted_lshfo"
end choose
lds_forward_lifted.setTransObject(sqlca)




// retrieve all the data for this vessel, voyage combo, at later than the POC arrival datetimestamp 
long		ll_rows
ll_rows = lds_forward_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival )

// for each bunker retrieved for the vessel on the voyage at that port, 
long		ll_row
for ll_row = 1 to ll_rows
	
	// create a new Lifted row 
	long ll_new_row_num 
	ll_new_row_num = ids_bunker_lifted.insertrow( 1 )
	
	// Copy the values from the the forwarded amount 
	ids_bunker_lifted.setItem(ll_new_row_num, "lifted", lds_forward_lifted.getItemNumber(ll_row, "lifted"))
	ids_bunker_lifted.setItem(ll_new_row_num, "price", 	lds_forward_lifted.getItemNumber(ll_row, "price"))
	ids_bunker_lifted.setItem(ll_new_row_num, "bpn", 	lds_forward_lifted.getItemNumber(ll_row, "bpn"))
	
next

return 1


end function

public function integer of_showcalculation (long al_ops_offserviceid, ref datawindow adw_show);long ll_bpn // debugging use only 

long		ll_row, ll_reportrow, ll_vessel, ll_liftrows, ll_liftrow, ll_bunkerliftID
n_ds		lds_data
decimal		ld_used, ld_startstock, ld_priceperton
decimal{2}	ld_total
string		ls_voyage, ls_portname, ls_vesselname, ls_vessel_ref_nr
datetime	ldt_start, ldt_end, ldt_arrival
decimal		ld_lifted, ld_price
boolean		lb_stop=false

lds_data = create n_ds
lds_data.dataObject = "d_edit_single_offservice"
lds_data.setTransObject(SQLCA)


// retrieve the argument off-service ID row 
ll_row = lds_data.retrieve( al_ops_offserviceid )
commit;

// verify that there is exactly one row 
if (ll_row <> 1) then
	of_MessageBox("Information", &
		"Not able to retrieve OffService or too many OffService Items Retrieved. "+&
		"(Object: n_voyage_offservice_bunker_consumption, Function: of_showcalculation)" &
		)
	return -1
end if

ll_vessel 		= lds_data.getItemNumber(ll_row, "vessel_nr")
ls_voyage 		= lds_data.getItemString(ll_row, "voyage_nr")
ldt_start		= lds_data.getItemDatetime(ll_row, "off_start")
ldt_end			= lds_data.getItemDatetime(ll_row, "off_end")

// get the vessel name and voyage number to display to user 
SELECT VESSEL_NAME, VESSEL_REF_NR 
INTO :ls_vesselname, :ls_vessel_ref_nr 
FROM VESSELS 
WHERE VESSEL_NR = :ll_vessel 
// stilltodo: no error checking? 
COMMIT;

// edit header text to show the display values 
adw_show.Object.t_header2.Text = "Vessel: "+ls_vesselname +" ( "+ls_vessel_ref_nr+" )"
adw_show.Object.t_header3.Text = "Voyage: " + ls_voyage

ll_reportrow = adw_show.insertrow(99999)
adw_show.setItem( &
	ll_reportrow, &
	"textstring", &
	string(ldt_start, "dd. mmmm yyyy hh:mm") + " - " + string(ldt_end, "dd. mmmm yyyy hh:mm") &
	)

/* Calculate and display HFO */

// grab HFO used
ld_used	= lds_data.getItemDecimal(ll_row, "off_fuel_oil_used")

// if this is a legal value
if ((not isnull(ld_used)) and (ld_used <> 0)) then
	
	// how much did we start with? 
	ld_startstock	= lds_data.getItemDecimal(ll_row, "hfo_stock_start")

	// compute the price of HFO used during that period 
	of_price_proposal( "HFO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	
	// the total is the amount used time the price per ton
	ld_total = ld_used * ld_priceperton
	
	// add a row to the bottom 
	ll_reportrow = adw_show.insertrow(99999)
	
	// set the HFO tonnage used for this row 
	adw_show.setItem(ll_reportrow, "textstring", "   HSFO used = "+string (ld_used, "#,##0.0000")+ " ton")
	
	// set the value of this tonnage 
	adw_show.setItem(ll_reportrow, "number", ld_total )
	
	// initialize a loop termination condition
	lb_stop = false
	
	// for each lifted bunker, in reverse order 
	// stilltodo: verify sorted order 
	for ll_liftrow = ids_bunker_lifted.rowcount() to 1 step -1
		
		// get the PK to that purchase 
		ll_bunkerliftID = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn")
		
		// how much did we lift at that purchase? 
		ld_lifted = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted")
		
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
		// get the price of the oldest stock still in 
		SELECT BP_DETAILS.PRICE_HFO, PORTS.PORT_N, POC.PORT_ARR_DT  
		INTO :ld_price, :ls_portname, :ldt_arrival  
		FROM BP_DETAILS, PORTS, POC  
		WHERE  BP_DETAILS.PORT_CODE = PORTS.PORT_CODE and  
				 BP_DETAILS.VESSEL_NR = POC.VESSEL_NR and  
				 BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR and  
				 BP_DETAILS.PORT_CODE = POC.PORT_CODE and  
				 BP_DETAILS.PCN = POC.PCN and  
				 BP_DETAILS.BPN = :ll_bunkerliftID  ;
		commit;		 
		
		// add a new row to show to the user 
		ll_reportrow = adw_show.insertrow(99999)
		
		// if we lifted more than we used
		if (ld_lifted >= ld_used) then
			
			// for the purposes of this row, the amount we used IS the amount we lifted, when calculating costs for this row. 
			ld_lifted = ld_used
			
			// remember to stop now, as we have accounted for all the fuel that was used. 
			lb_stop = true
			
		else
			
			// decrement the amount we used by the amount we lifted. 
			ld_used -= ld_lifted
			
		end if
		
		// display the results to the user
		adw_show.setItem(ll_reportrow, "textstring", "      "+string(ld_lifted,"#,##0.0000")+" ton @ "+string(ld_price, "#,##0.0000")+ " $  Loaded in "+ls_portname +" arr. "+string(ldt_arrival, "dd. mmmm yy" ))
		
		// if we have accounted for all our fuel, then exit the loop 
		if lb_stop then exit 	
		
	next
	// all lifted bunkers are accounted for 
	
end if



/* DO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_diesel_oil_used")
if (not isnull(ld_used)) and (ld_used <> 0) then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "do_stock_start")
	of_price_proposal( "DO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ll_reportrow = adw_show.insertrow(99999)
	adw_show.setItem(ll_reportrow, "textstring", "   LSGO used = "+string (ld_used, "#,##0.0000")+ " ton")
	adw_show.setItem(ll_reportrow, "number", ld_total )
	lb_stop = false
	for ll_liftrow = ids_bunker_lifted.rowcount() to 1 step -1
		ll_bunkerliftID = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn")
		
		ld_lifted = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted")
		
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
		SELECT BP_DETAILS.PRICE_DO, PORTS.PORT_N, POC.PORT_ARR_DT  
			INTO :ld_price, :ls_portname, :ldt_arrival  
			FROM BP_DETAILS, PORTS, POC  
			WHERE  BP_DETAILS.PORT_CODE = PORTS.PORT_CODE and  
				 BP_DETAILS.VESSEL_NR = POC.VESSEL_NR and  
				 BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR and  
				 BP_DETAILS.PORT_CODE = POC.PORT_CODE and  
				 BP_DETAILS.PCN = POC.PCN and  
				 BP_DETAILS.BPN = :ll_bunkerliftID  ;
		commit;		 
		ll_reportrow = adw_show.insertrow(99999)
		if ld_lifted >= ld_used then
			ld_lifted = ld_used
			lb_stop = true
		else
			ld_used -= ld_lifted
		end if
		adw_show.setItem(ll_reportrow, "textstring", "      "+string(ld_lifted,"#,##0.0000")+" ton á "+string(ld_price, "#,##0.0000")+ " $  Loaded in "+ls_portname +" arr. "+string(ldt_arrival, "dd. mmmm yy" ))
		if lb_stop then exit 		
	next
end if

/* GO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_gas_oil_used")
if not isnull(ld_used) and ld_used <> 0 then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "go_stock_start")
	of_price_proposal( "GO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ll_reportrow = adw_show.insertrow(99999)
	adw_show.setItem(ll_reportrow, "textstring", "   HSGO used = "+string (ld_used, "#,##0.0000")+ " ton")
	adw_show.setItem(ll_reportrow, "number", ld_total )
	lb_stop = false
	for ll_liftrow = ids_bunker_lifted.rowcount() to 1 step -1
		
		ll_bunkerliftID = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn")
		ld_lifted = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted")
		
		SELECT BP_DETAILS.PRICE_GO, PORTS.PORT_N, POC.PORT_ARR_DT  
			INTO :ld_price, :ls_portname, :ldt_arrival  
			FROM BP_DETAILS, PORTS, POC  
			WHERE  BP_DETAILS.PORT_CODE = PORTS.PORT_CODE and  
				 BP_DETAILS.VESSEL_NR = POC.VESSEL_NR and  
				 BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR and  
				 BP_DETAILS.PORT_CODE = POC.PORT_CODE and  
				 BP_DETAILS.PCN = POC.PCN and  
				 BP_DETAILS.BPN = :ll_bunkerliftID  ;
		commit;		 
		ll_reportrow = adw_show.insertrow(99999)
		if (ld_lifted >= ld_used) then
			ld_lifted = ld_used
			lb_stop = true
		else
			ld_used -= ld_lifted
		end if
		adw_show.setItem(ll_reportrow, "textstring", "      "+string(ld_lifted,"#,##0.0000")+" ton á "+string(ld_price, "#,##0.0000")+ " $  Loaded in "+ls_portname +" arr. "+string(ldt_arrival, "dd. mmmm yy" ))
		if lb_stop then exit 		
	next
end if

/* LSHFO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_lshfo_oil_used")
if (not isnull(ld_used)) and (ld_used <> 0) then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "lshfo_stock_start")
	of_price_proposal( "LSHFO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ll_reportrow = adw_show.insertrow(99999)
	adw_show.setItem(ll_reportrow, "textstring", "   LSFO used = "+string (ld_used, "#,##0.0000")+ " ton")
	adw_show.setItem(ll_reportrow, "number", ld_total )
	lb_stop = false
	for ll_liftrow = ids_bunker_lifted.rowcount() to 1 step -1
		ll_bunkerliftID = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn")
		ld_lifted = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted")
		SELECT BP_DETAILS.PRICE_LSHFO, PORTS.PORT_N, POC.PORT_ARR_DT  
			INTO :ld_price, :ls_portname, :ldt_arrival  
			FROM BP_DETAILS, PORTS, POC  
			WHERE  BP_DETAILS.PORT_CODE = PORTS.PORT_CODE and  
				 BP_DETAILS.VESSEL_NR = POC.VESSEL_NR and  
				 BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR and  
				 BP_DETAILS.PORT_CODE = POC.PORT_CODE and  
				 BP_DETAILS.PCN = POC.PCN and  
				 BP_DETAILS.BPN = :ll_bunkerliftID  ;
		commit;		 
		ll_reportrow = adw_show.insertrow(99999)
		if ld_lifted >= ld_used then
			ld_lifted = ld_used
			lb_stop = true
		else
			ld_used -= ld_lifted
		end if
		adw_show.setItem(ll_reportrow, "textstring", "      "+string(ld_lifted,"#,##0.0000")+" ton á "+string(ld_price, "#,##0.0000")+ " $  Loaded in "+ls_portname +" arr. "+string(ldt_arrival, "dd. mmmm yy" ))
		if lb_stop then exit 		
	next
end if

destroy lds_data

return 1
end function

public function integer of_identify_poc (ref datetime adt_offstart, ref datetime adt_offend, ref decimal ad_stockstart, ref integer ai_scenario);/* 
script:  
	of_identify_poc()
purpose: 
	Identify the POC from which to start calculating cost of bunker.

	If stock start value is given, 
	then we start calculating from where the value matches the first time in POC.
	
	If stock not given, 
	then the calculation is based on the oldest part of the bunker, when the voyage started. 
	
	Function determines which scenario of match we are in:
		0	= no match found. use oldest part of bunker on voyage
		1	= stock match on leg with bunker load in port before leg
		2 	= stock match on leg with no bunker load in port before leg
		3	= stock match in port. match before bunker load (Off Service stock start < port arrival bunker) 
		4	= stock match in port. match after bunker load (Off Service stock start >= port arrival bunker)
		5	= stock match in port. no bunker load
		
WHERE: 		    
		1	= stock match on leg with bunker load in port before leg
		    // some non-zero amount of fuel was lifted 
		    // and departure stock >= stock start
		    // and arrival stock < stock start
		    // and arrival date after offservice start
		    
		2 = stock match on leg with no bunker load in port before leg
		    // amount of fuel lifted was zero
		    // and departure stock >= stock start
		    // and arrival stock < stock start
		    // and arrival date after offservice start
		    
		3	= stock match in port. match before bunker load (Off Service stock start < port arrival bunker) 
		    // amount of fuel lifted in port is NOT zero, 
		    // and stock start between max in port and min in port, 
		    // and exactly one row in d_sp_tb_offservice_bunker_match, 
		    // and stock start <= lds_data.arrival_stock
		
		4	= stock match in port. match after bunker load (Off Service stock start >= port arrival bunker)
		    // amount of fuel lifted in port is NOT zero, 
		    // and stock start between max in port and min in port, 
		    // and exactly one row in d_sp_tb_offservice_bunker_match, 
		    // and stock start > arrival stock
		
		5	= stock match in port. no bunker load
		    // amount of fuel lifted in port is zero, 
		    // and stock start between max in port and min in port, 
		    // and exactly one row in d_sp_tb_offservice_bunker_match
		
		0	= no match found. use oldest part of bunker on voyage
		    // profile does not match scenarios 1,2,3,4, or 5

*/

datastore lds_data
long ll_row
long ll_rows


// calculated min. and max. stock values when in port
decimal ld_min_stock_in_port
decimal ld_max_stock_in_port  

boolean lb_stockmatch
if ((ad_stockstart = 0) or isNull(ad_stockstart)) then
	lb_stockmatch = false
else

	/* workaround PB bugfix for when retrieving from temp table via stored procedure*/
	
	// how many bunker rows for this type of fuel? 
	
	// create transaction and connect to database 
	transaction	mytrans
	mytrans 			= create transaction
	mytrans.DBMS 		= SQLCA.DBMS
	mytrans.Database 	= SQLCA.Database
	mytrans.LogPAss 	= SQLCA.LogPass
	mytrans.ServerName	= SQLCA.ServerName
	mytrans.LogId		= SQLCA.LogId
	mytrans.AutoCommit	= true
	mytrans.DBParm		= SQLCA.DBParm
	connect using mytrans;

	// set up our datastore 
	lds_data = create datastore
	
	// the data source is a stored procedure that returns a distinct set of rows 
	// for bunkers that might possibly match the offservice period we are considering. 
	lds_data.dataObject = "d_sp_tb_offservice_bunker_match"
	
	// associate the datastore with the transaction 
	lds_data.setTransObject(mytrans)
	
	// retrieve the info for the fuel types we are interested in. (run the stored procedure) 
	choose case is_bunkertype
		case "HFO"
			ll_rows = lds_data.retrieve(ii_vessel, "HFO",	adt_offstart, adt_offend)
		case "DO"
			ll_rows = lds_data.retrieve(ii_vessel, "DO",	adt_offstart, adt_offend)
		case "GO"
			ll_rows = lds_data.retrieve(ii_vessel, "GO",	adt_offstart, adt_offend)
		case "LSHFO"
			ll_rows = lds_data.retrieve(ii_vessel, "LSHFO",	adt_offstart, adt_offend)
	end choose
	
	// validate proper retrieve operation
	choose case ll_rows 
		case -1 
			of_MessageBox( &
				"n_voyage_offservice_bunker_consumption::of_identify_poc()", &
				"Error after lds_data.retrieve() for bunker type '"+is_bunkertype+"'. Aborting. " & 
				);
			destroy lds_data
			return -1
	end choose
	
//	if (gb_developer) then
//		f_datastore_spy(lds_data)
//	end if 
	
	// this statement is a workaround, because there is a bug in PB when retrieving 
	// from temp table in stored procedure
	ll_rows = lds_data.rowCount()  
	
	commit using mytrans;
	disconnect using mytrans;
	destroy mytrans;
	// this transaction object is still closed, but the data remains in the datawindow for our use 
	
	// if no rows, or an error 
	if ll_rows < 1 then
		
		/* No port of call matching */
		lb_stockmatch = false
		
	/* Is there exactly One port of call matching */
	elseif ll_rows = 1 then 
		
		// minimum stock in port = arrival - (arrival + lifted - departure) som nedre grænse
		decimal ld_mre_arrival_stock 
		ld_mre_arrival_stock = lds_data.getItemDecimal(1, "arrival_stock") 
		if IsNull(ld_mre_arrival_stock) then 
			ld_mre_arrival_stock= 0.0
		end if
		
		decimal ld_mre_lifted_stock
		ld_mre_lifted_stock=lds_data.getItemDecimal(1, "lifted") 
		if IsNull(ld_mre_lifted_stock) then 
			ld_mre_lifted_stock= 0.0
		end if
		
		decimal ld_mre_dept_stock 
		ld_mre_dept_stock = lds_data.getItemDecimal(1, "departure_stock") 
		if IsNull(ld_mre_dept_stock ) then 
			ld_mre_dept_stock = 0.0
		end if
		
		// compute the minimum stock the vessel could have had while in port 
		ld_min_stock_in_port = &
			ld_mre_arrival_stock &		
			- ( &
				ld_mre_arrival_stock &
				+ ld_mre_lifted_stock &
				- ld_mre_dept_stock &
			)
			
	    // make sure low limit is not breached. 
		if (ld_min_stock_in_port < 0) then 
			ld_min_stock_in_port = 0
		end if
		
		// maximum stock in port = arrival + lifted
		ld_max_stock_in_port = ld_mre_arrival_stock + ld_mre_lifted_stock 
 
 		// if the stock start was between our allowable limits 
		if (ad_stockstart >= ld_min_stock_in_port) and (ad_stockstart <= ld_max_stock_in_port) then
			
			idt_poc_arrival = lds_data.getItemDatetime(1, "port_arr_dt")
			lb_stockmatch = true
			
			/* Find scenario */
			if (0 = ld_mre_lifted_stock) then
				ai_scenario = 5  	/* stock match in port. no bunker load */
				
			elseif (ad_stockstart <= ld_mre_arrival_stock) then
				ai_scenario = 3 	/* stock match in port. match before bunker load */
				
			else // DID lift some bunker, and stock start > arrival stock
				ai_scenario = 4 	/* stock match in port. match after bunker load */
				
			end if
		else
			lb_stockmatch = false
		end if
		
	/* otherwise there is more than one row matching */
	else
		// loop through all the rows but the last 
		for ll_row = 1 to ll_rows -1
			
			// get the arrival stock amount
			decimal ld_2_arrival_stock 
			ld_2_arrival_stock = lds_data.getItemDecimal(ll_row, "arrival_stock") 
			
			// get the lifted stock amount 
			decimal ld_2_lifted 
			ld_2_lifted = lds_data.getItemDecimal(ll_row, "lifted")

			// get the departure stock amount 
			decimal ld_2_departure_stock 
			ld_2_departure_stock = lds_data.getItemDecimal(ll_row, "departure_stock")
			
			// minimum stock in port = arrival - (arrival + lifted - departure) som nedre grænse
			ld_min_stock_in_port = &
				ld_2_arrival_stock &
				- (	&
					ld_2_arrival_stock &
					+ ld_2_lifted  &
					- ld_2_departure_stock  & 
					)
					// stilltodo: here we add the arrival stock and then delete it again.... why? 
				
			// if the minimum stock in port is less than zero 
			if (ld_min_stock_in_port < 0) then 
				// make it zero 
				ld_min_stock_in_port = 0
			end if
			
			// maximum stock in port = arrival + lifted
			ld_max_stock_in_port = &
				ld_2_arrival_stock  &
				+ ld_2_lifted 
				
			// stilltodo: we should compensate for a maximum value also. What if 
			// maximum capacity was 100, but we calculate 120? 
			
			// get the port departure date 
			DateTime ldt_dept_date 
			ldt_dept_date = lds_data.getItemDatetime(ll_row, "port_dept_dt") 
			
			// get the departure stock 
			decimal ld_stockstart 
			ld_stockstart = lds_data.getItemDecimal(ll_row, "departure_stock") 

			// get the arrival stock at the next port 
			decimal ld_arrival_stock_next 
			ld_arrival_stock_next = lds_data.getItemDecimal(ll_row +1, "arrival_stock") 

			// get the arrival date at the next port 
			DateTime ldt_port_arr_dt_next 
			ldt_port_arr_dt_next = lds_data.getItemDatetime(ll_row +1, "port_arr_dt") 
			
			// if the OS_start.stock is more than minimum held in port
			// and the OS_Start.sotkc is less than the maximum held in port
			// and the POC.dept_dt is after OS_Start.date
			if (										&
				(ad_stockstart >= ld_min_stock_in_port) &
				and (ad_stockstart <= ld_max_stock_in_port) &
				and (ldt_dept_date > adt_offstart) &
				) then
				
				// then we have a match 
				lb_stockmatch = true

				// Match in port
				idt_poc_arrival = lds_data.getItemDatetime(ll_row, "port_arr_dt")
				
				decimal  ld_arrival_stock 
				ld_arrival_stock = lds_data.getItemDecimal(ll_row, "arrival_stock")
				if IsNull(ld_arrival_stock) then 
					ld_arrival_stock = 0
				end if 

				decimal  ld_lifted 
				ld_lifted=lds_data.getItemDecimal(ll_row, "lifted")
				if IsNull(ld_lifted) then 
					ld_lifted= 0
				end if 
				
				/* Find scenario */
				if (ld_lifted = 0) then
					ai_scenario = 5  	/* stock match in port. no bunker load */
					
				elseif (ad_stockstart <= ld_arrival_stock) then
					ai_scenario = 3 	/* stock match in port. match before bunker load */
					
				else
					ai_scenario = 4 	/* stock match in port. match after bunker load */
					
				end if

				exit    // match found ~ end loop
				
			// if stock amount is more than the OS.stock.start amount
			// and the next POC arrival stock amount is less than the OS.stock.start amount
			// and the next POC arrival date occurred after the OS.start.date
			elseif ( 							&
				(ld_stockstart 				>= ad_stockstart) & 
				and (ld_arrival_stock_next 	<  ad_stockstart)  &
				and (ldt_port_arr_dt_next 	>  adt_offstart) &
				) then
				
				// we have a match 
				lb_stockmatch = true
				
				// Match at sea
				idt_poc_arrival = lds_data.getItemDatetime(ll_row, "port_arr_dt")
				
				decimal ld_lifted_2 
				ld_lifted_2=lds_data.getItemDecimal(ll_row, "lifted") 
				if IsNull(ld_lifted_2) then 
					ld_lifted_2= 0
				end if 
				
				/* Find scenario */
				if (ld_lifted_2 = 0) then
					ai_scenario = 2  	/*  stock match on leg with no bunker load in port before leg */
				else
					ai_scenario = 1		/*	stock match on leg with bunker load in port before leg */
				end if
						
				exit
			else
				lb_stockmatch = false
			end if
		next
	end if
	destroy lds_data
end if

// if unable to find a match
if NOT lb_stockmatch then
	
	/* no match found. */ 
	ai_scenario = 0 	
	
	/* use oldest part of bunker on voyage */
	SELECT MAX(PORT_ARR_DT)
		INTO :idt_poc_arrival
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR+"00" < :is_voyage
		;
	if isNull(idt_poc_arrival) then
		SELECT MIN(PORT_ARR_DT)
		INTO :idt_poc_arrival
		FROM POC
		WHERE VESSEL_NR = :ii_vessel
		AND VOYAGE_NR = :is_voyage
		;
		if sqlca.sqlcode <> 0 then
			of_MessageBox("Select Error", 	"No POC found for selected vessel/voyage!~r~n~r~n" &
				+ "(Object: n_voyage_offservice_bunker_consumption.of_identify_poc())" )
			commit;				
			return -1
		end if	
	end if
end if

commit;

// remember this value so other routines can reference it without having to recalculate it 
ii_scenario = ai_scenario

return 1



end function

private function integer of_setloadreduction (ref decimal ad_stock_start_qty, ref decimal ad_departure_fuel_qty, ref decimal ad_fuel_used_qty, ref decimal ad_arrival_fuel_qty);/**************************************************************************
function: 	of_setloadreduction()
	
purpose: 	Set the value that reduces how many bunker purchases to load in order to calculate price 
	if stockstart is given then start from departure fuel for matching POC plus fuel used on offservice
	otherwise
	get the voyage consumption and 
	
parameters: 
	ad_stock_start_qty: input only
	ad_departure_fuel_qty:	input/output 
	ad_fuel_used_qty:	input only 
	ad_arrival_fuel_qty:	output only
**************************************************************************/

string lt_msgbox_title 
lt_msgbox_title = this.classname()+".of_setloadreduction()"

decimal{4} ld_departure_fuel_qty

// Get the amount of fuel, arriving and departing, for this POC, based upon the bunker type 
choose case upper(is_bunkertype)
	case "HFO"
		SELECT ARR_HFO, DEPT_HFO
			INTO :ad_arrival_fuel_qty, :ld_departure_fuel_qty
			FROM POC
			WHERE VESSEL_NR = :ii_vessel
			AND PORT_ARR_DT = :idt_poc_arrival
			;
	case "DO"
		SELECT ARR_DO, DEPT_DO
			INTO :ad_arrival_fuel_qty, :ld_departure_fuel_qty
			FROM POC
			WHERE VESSEL_NR = :ii_vessel
			AND PORT_ARR_DT = :idt_poc_arrival
			;
	case "GO"
		SELECT ARR_GO, DEPT_GO
			INTO :ad_arrival_fuel_qty, :ld_departure_fuel_qty
			FROM POC
			WHERE VESSEL_NR = :ii_vessel
			AND PORT_ARR_DT = :idt_poc_arrival
			;
	case "LSHFO"
		SELECT ARR_LSHFO, DEPT_LSHFO
			INTO :ad_arrival_fuel_qty, :ld_departure_fuel_qty
			FROM POC
			WHERE VESSEL_NR = :ii_vessel
			AND PORT_ARR_DT = :idt_poc_arrival
			;
end choose

// check for errors in embedded SQL
choose case SQLCA.SQLCode
	case 0		// success
	case 100	// not found 
		of_Messagebox( &
			lt_msgbox_title, &
			"No result returned from database")
	case -1		// error 
//		// per Regin, ignore this message, we only need the values 
// 		// from the "first" row that are retrieved, although these 
//		// queries do not specify an ORDER BY clause. 
//		of_Messagebox( &
//			lt_msgbox_title, &
//			"Error returned from database: VESSEL_NR="+string(ii_vessel) + "; POC ARRIVAL ="+string(idt_poc_arrival)+"; "+ string(SQLCA.SQLErrText), &
//			stopsign!, &
//			ok! &
//			)
	case else
		of_Messagebox( &
			lt_msgbox_title, &
			"Unknown SQLCA.SQLCode returned from database: "+string(SQLCA.SQLErrText))
end choose		
commit;

// VALIDATE THE VALUES, PURGE NULLS
if IsNull(ad_arrival_fuel_qty) then 
	of_Messagebox( &
		lt_msgbox_title, &
		"ad_arrival_fuel_qty value is NULL, setting to zero. ")
	ad_arrival_fuel_qty = 0
end if 
if IsNull(ld_departure_fuel_qty) then 
	of_Messagebox( &
		lt_msgbox_title, &
		"ld_departure_fuel_qty value is NULL, setting to zero. ")
	ld_departure_fuel_qty = 0
end if 

// pass fuel back to argument 
ad_departure_fuel_qty =  ld_departure_fuel_qty

/* reduce departure / lifted dependent on scenario */
//ids_bunker_lifted.id_stop_load = ad_departure_fuel_qty
decimal ld_temp_stop_load_amt
choose case ii_scenario
		
	case 0	//no match found. use oldest part of bunker on voyage
		// no reduction
		ld_temp_stop_load_amt = ad_departure_fuel_qty //oldest part of the bunker when voyage start
	case 1	//stock match on leg with bunker load in port before leg
		ld_temp_stop_load_amt= ad_stock_start_qty // start stock for offservice 

	case 2	//stock match on leg with no bunker load in port before leg
//		ld_temp_stop_load_amt= ad_departure_fuel_qty + ad_fuel_used_qty
//		changed 15/07-09 Change Request #1651
		ld_temp_stop_load_amt= ad_stock_start_qty // start stock for offservice 

	case 3	//stock match in port. match before bunker load
		ld_temp_stop_load_amt= ad_departure_fuel_qty + ad_fuel_used_qty

	case 4	//stock match in port. match after bunker load
		ld_temp_stop_load_amt= ad_departure_fuel_qty + ad_fuel_used_qty

	case 5	//stock match in port. no bunker load
		ld_temp_stop_load_amt= ad_stock_start_qty   // start stock for offservice
end choose		

ids_bunker_lifted.id_stop_load = ld_temp_stop_load_amt

return 1



end function

public function integer of_price_proposal (string as_bunkertype, integer ai_vessel, string as_voyage, datetime adt_offservice_start, decimal ad_stock_start, decimal ad_fuel_used, ref decimal ad_priceperton, datetime adt_offservice_end);/* 
	This function calculates a price prososal for bunker used when vessel if off-service 
	The calculation is splitted into several steps
	
	1) Initialize which bunker type to calculate
	2) find out from which port of call the calculation should be based on
		a) find POC based on off-service start and stock value on start 
		b) if no stock start given, then the calculation shall be based on the oldest part of 
		   bunker onboard at voyage start 
*/
			  
			  
long ll_bpn // debugging use only 

long 		ll_liftrows, ll_liftrow
datetime	ldt_arrival
decimal{4}	ld_price, ld_calc_used, ld_departure_fuel, ld_arrival_fuel, ld_reduce_qty, ld_lifted_calcsum
boolean		lb_used_negative
integer		li_scenario

/* Set instance variables for further use */
is_bunkertype 	= as_bunkertype
ii_vessel			= ai_vessel
is_voyage		= as_voyage
ld_calc_used	= ad_fuel_used

/* Initialize datastores and retrieve off-services */
if (of_initialize() = -1) then
	of_MessageBox( &
		"Initialization Failed", & 
		"An error occured when trying to initialize datastores!~r~n~r~n" &
		+ "(Object: n_voyage_offservice_bunker_consumption.of_price_proposal())" & 
		)
	return -1
end if

/* calculate price */
if (ad_fuel_used < 0) then
	ld_calc_used = abs( ad_fuel_used )
	lb_used_negative = true
else
	lb_used_negative = false
end if

/* Identify from which POC to start calculation from */
if of_identify_poc( adt_offservice_start, adt_offservice_end, ad_stock_start, li_scenario ) = -1 then
	of_MessageBox( &
		"Identify POC", &
		"An error occured when trying to identify Port of Call!~r~n~r~n" &
		+ "(Object: n_voyage_offservice_bunker_consumption.of_price_proposal())" &
		)
	return -1
end if
	
/* Find out how many bunker purchases to load in order to calculate price */
if of_setloadreduction( ad_stock_start, ld_departure_fuel, ad_fuel_used, ld_arrival_fuel ) = -1 then
	of_MessageBox( &
		"Load Error", &
		"An error occured when trying to reduce load!~r~n~r~n" &
		+ "(Object: n_voyage_offservice_bunker_consumption.of_price_proposal())" &
		)
	return -1
end if

// get the number of rows that were retrieved 
ll_liftrows = ids_bunker_lifted.retrieve(ii_vessel, is_voyage, idt_poc_arrival)

// debugging step: we need to see the BPN's for these rows while debugging 
long ll_this_row 
for ll_this_row = 1 to ll_liftrows 
	// for debugging purposes, which BPN are we looking at? this is not used in any computations 
	ll_bpn = ids_bunker_lifted.getItemNumber(ll_this_row, "bpn") 
next
			
commit;

/* reduce departure / lifted dependent on scenario */
choose case li_scenario
		
	case 0	//no match found. use oldest part of bunker on voyage
		// no reduction
		if ll_liftrows > 1 then
			ids_bunker_lifted.rowsdiscard(1, ll_liftrows - 1, primary!)				
			ll_liftrows = 1
		end if
		ids_bunker_lifted.setItem(1, "lifted", 100000)
		
	case 1	//stock match on leg with bunker load in port before leg
		ld_departure_fuel = ad_stock_start
		
	case 2	//stock match on leg with no bunker load in port before leg
		ld_reduce_qty = ld_departure_fuel - ad_stock_start
		ld_departure_fuel -= ld_reduce_qty
		
	case 3	//stock match in port. match before bunker load
		ld_reduce_qty = ad_stock_start - ld_arrival_fuel
		ids_bunker_lifted.setItem(1, "lifted", ld_reduce_qty )
		ld_departure_fuel = ad_stock_start
		
	case 4	//stock match in port. match after bunker load
		ld_departure_fuel = ad_stock_start
		
	case 5	//stock match in port. no bunker load
		// no reduction		
		ld_departure_fuel = ad_stock_start
		
end choose		

/* reduce rows for value on board */
for ll_liftrow = 1 to ll_liftrows
	
	// grab how much was lifted 
	decimal ld_lifted_3 
	ld_lifted_3 = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted") 

			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
	// if the amount lifted is less than the departure fuel on board
	if (ld_lifted_3 <= ld_departure_fuel) then
		
		// decrement from the departure fuel level, the amount we lifted  
		ld_departure_fuel -= ld_lifted_3 
		
	else
		// if we are considering the last row 
		if (ll_liftrow = ll_liftrows) then //last row 
		
			if ii_scenario <> 0 then
				// set the amount we lifted for this row, to the calculated departure fuel amount 
				ids_bunker_lifted.setItem(ll_liftrow, "lifted", ld_departure_fuel)
			end if
			
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
		else
			decimal ld_temp_lifted_2 
			ld_temp_lifted_2 = ids_bunker_lifted.getItemNumber(ll_liftrow, "lifted") 
			
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
			decimal ld_lift_calc_3 
			ld_lift_calc_3 =  ld_temp_lifted_2 - ld_departure_fuel
			
			// set the amount we lifted for this row, to the amount lifted minus the departure fuel level 
			ids_bunker_lifted.setItem(ll_liftrow, "lifted", ld_lift_calc_3)
			
		end if	
		
		exit // for next loop 
		
	end if
	
next 	

/* If long off-service, and used more than on board at beginning, then load forward */
for ll_liftrow = 1 to ll_liftrows
	
	decimal ld_lifted_4 
	ld_lifted_4 = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
	
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
	ld_lifted_calcsum += ld_lifted_4 
	
next 	

if ( &
	(ld_calc_used <> 0) & 
	and (ld_lifted_calcsum <> 0) &
	and (ld_calc_used > ld_lifted_calcsum) & 
	) then
	
	//of_messagebox("", "used greater than lifted - we have to run forward ~n~r~n~rV"+string(ai_vessel)+"T"+as_voyage)
	of_forward_lifted( )
	
end if

/* calculate value */
ll_liftrows = ids_bunker_lifted.rowCount()
ld_price = 0

// step backwards through the rows 
for ll_liftrow = ll_liftrows to 1 step -1 
	
	// how much was lifted for this row? 
	decimal ld_lifted_amt
	ld_lifted_amt = ids_bunker_lifted.getItemDecimal(ll_liftrow, "lifted")
	if IsNull(ld_lifted_amt) then
		ld_lifted_amt=0.0
	end if 
	
			// for debugging purposes, which BPN are we looking at? this is not used in any computations 
			ll_bpn = ids_bunker_lifted.getItemNumber(ll_liftrow, "bpn") 
			
	// what is the price for this row? 
	decimal ld_lifted_price 
	ld_lifted_price = ids_bunker_lifted.getItemDecimal(ll_liftrow, "price")
	if IsNull(ld_lifted_price) then
		ld_lifted_price=0.0
	end if 
	
	// did we use more than this last lift allowed? 
	if (ld_calc_used > ld_lifted_amt) then
		// then allow for more bunker lifts

		// compute the cost of this load == tons * price/ton 
		decimal ld_price_this_load 
		ld_price_this_load = ld_lifted_amt * ld_lifted_price 
		
		// add the price of this load to our cumulative cost; 
		// this is needed for consumption across multiple bunker loads
		ld_price +=  ld_price_this_load 
		
		// account for the amount of fuel remaining that we still need to pay for
		ld_calc_used -= ld_lifted_amt
		
	else
		// what is the cost of this fuel consumption from this load? 
		decimal ld_price_this_load2 
		ld_price_this_load2  = ld_calc_used * ld_lifted_price 
		
		// total up the price for this last bunker load 
		ld_price += ld_price_this_load2 
		
		// no need to compute from further bunker loads 
		exit
	end if
next

if lb_used_negative then
	ld_price *= -1
end if

// compute the average price per ton, across all prices for all loads that comprise the final price. 
ad_priceperton = ld_price / ad_fuel_used

return 1



end function

public function integer of_loadbunkervalues (long al_ops_offserviceid, ref decimal ad_hfo, ref decimal ad_do, ref decimal ad_go, ref decimal ad_lshfo);/********************************************************************
   of_showcalculation( /*long al_ops_offserviceid*/, /*ref datawindow adw_show*/, /*long al_currentrow */)
   
	<DESC>Override of original.  This function loads bunker prices into datawindow passed as a parameter</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   al_ops_offserviceid: record number to identity off service
            adw_show: 				reference to datawindow that will be updated
				al_currentrow: 		row in datawindow to udpate.</ARGS>
   <USAGE>  Column names in passed datawindow must consist of: 
					"hfo_price", "do_price", "go_price", "lshfo_price" </USAGE>
********************************************************************/


long ll_bpn // debugging use only 

long		ll_row, ll_reportrow, ll_vessel, ll_liftrows, ll_liftrow, ll_bunkerliftID
n_ds		lds_data
decimal		ld_used, ld_startstock, ld_priceperton
decimal{2}	ld_total
string		ls_voyage
datetime	ldt_start, ldt_end, ldt_arrival
decimal		ld_lifted, ld_price
boolean		lb_stop=false

lds_data = create n_ds
lds_data.dataObject = "d_edit_single_offservice"
lds_data.setTransObject(SQLCA)

// retrieve the argument off-service ID row 
ll_row = lds_data.retrieve( al_ops_offserviceid )
commit;

// verify that there is exactly one row 
if (ll_row <> 1) then
	of_MessageBox("Information", &
		"Not able to retrieve OffService or too many OffService Items Retrieved. "+&
		"(Object: n_voyage_offservice_bunker_consumption, Function: of_showcalculation)" &
		)
	return -1
end if

ll_vessel 		= lds_data.getItemNumber(ll_row, "vessel_nr")
ls_voyage 		= lds_data.getItemString(ll_row, "voyage_nr")
ldt_start		= lds_data.getItemDatetime(ll_row, "off_start")
ldt_end			= lds_data.getItemDatetime(ll_row, "off_end")

/* Calculate and display HFO */

// grab HFO used
ld_used	= lds_data.getItemDecimal(ll_row, "off_fuel_oil_used")
// if this is a legal value
if ((not isnull(ld_used)) and (ld_used <> 0)) then
	// how much did we start with? 
	ld_startstock	= lds_data.getItemDecimal(ll_row, "hfo_stock_start")
	// compute the price of HFO used during that period 
	of_price_proposal( "HFO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	// the total is the amount used time the price per ton
	ld_total = ld_used * ld_priceperton
	ad_hfo=ld_total
else
	ad_hfo=0
end if

/* DO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_diesel_oil_used")
if (not isnull(ld_used)) and (ld_used <> 0) then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "do_stock_start")
	of_price_proposal( "DO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ad_do=ld_total
else
	ad_do=0
end if

/* GO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_gas_oil_used")
if not isnull(ld_used) and ld_used <> 0 then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "go_stock_start")
	of_price_proposal( "GO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ad_go=ld_total
else
	ad_go=0
end if

/* LSHFO */
ld_used	= lds_data.getItemDecimal(ll_row, "off_lshfo_oil_used")
if (not isnull(ld_used)) and (ld_used <> 0) then
	ld_startstock	= lds_data.getItemDecimal(ll_row, "lshfo_stock_start")
	of_price_proposal( "LSHFO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
	ld_total = ld_used * ld_priceperton
	ad_lshfo=ld_total
else
	ad_lshfo=0
end if

destroy lds_data
return 1
end function

private subroutine of_messagebox (string as_title, string as_message);/* If the capture window is open, store the messages there, otherwise show the messsagebox */
if isValid(w_messagebox_capture) then
	w_messagebox_capture.wf_addmessage(as_title, as_message)
else
	messageBox(as_title, as_message)
end if

end subroutine

public subroutine documentation ();/********************************************************************
   n_voyage_offservice_bunker_consumption
   <OBJECT>		Calculate off service bunker consumption	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		02/08/2013		CR2913		ZSW001		First Version
		27/02/2014		CR2913		ZSW001		No match found. Use oldest part of bunker on voyage
		14/07/15  		CR3226		XSZ004		Change label for Bunkers Type.
   </HISTORY>
********************************************************************/

end subroutine

on n_voyage_offservice_bunker_consumption.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_voyage_offservice_bunker_consumption.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
// create the datastore which will hold the values for the bunkers that are used 
ids_bunker_used = create datastore

// create the datastore which will hold the values for bunkers lifted 
ids_bunker_lifted = create n_ds_lifted_bunker


end event

event destructor;destroy (ids_bunker_used)
destroy (ids_bunker_lifted)

end event

