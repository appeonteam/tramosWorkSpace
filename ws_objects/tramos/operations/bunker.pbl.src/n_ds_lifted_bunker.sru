$PBExportHeader$n_ds_lifted_bunker.sru
$PBExportComments$Datastore with functionality to reduce number of rows retrieved based on quantity
forward
global type n_ds_lifted_bunker from datastore
end type
end forward

global type n_ds_lifted_bunker from datastore
end type
global n_ds_lifted_bunker n_ds_lifted_bunker

type variables
decimal {4}		id_stop_load
end variables

event retrieverow;call super::retrieverow;
/* 
Controls how many rows to retrieve 
	0  Continue processing
	1  Stop the retrieval					
*/


// if at least one row was retrieved 
if row > 0 then
	
	// grab a column value retrieved, so that we can review 
	// the value while we are in the debugger. 
	decimal ld_lifted_raw 
	ld_lifted_raw = this.getItemDecimal(row, "lifted")
	
	// prevent going NULL in later computations 
	if IsNULL(ld_lifted_raw) then 
		ld_lifted_raw=0.0
	end if 
	
	// decrement the stop load value by the amount lifted for this row 
	id_stop_load -= ld_lifted_raw 
	
	// if the stop load is less than or equal to zero 
	if id_stop_load <= 0 then
		// 1== stop the retrieval  
		return 1
	end if
	
end if

//otherwise return continue processing rows 
return 0


end event

on n_ds_lifted_bunker.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ds_lifted_bunker.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

