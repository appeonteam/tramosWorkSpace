$PBExportHeader$u_atobviac_loadload_calculation.sru
forward
global type u_atobviac_loadload_calculation from nonvisualobject
end type
end forward

global type u_atobviac_loadload_calculation from nonvisualobject
end type
global u_atobviac_loadload_calculation u_atobviac_loadload_calculation

type variables
long			il_calc_id, il_estimated_calc_id, il_loadload_calc_id, il_fix_id
integer		ii_status
n_ds			ids_source_calc, ids_source_carg, ids_source_caio, ids_source_pexp, ids_source_hedv, ids_source_clmi, ids_source_ball, ids_source_route, ids_source_add_lump
n_ds			ids_target_calc, ids_target_carg, ids_target_caio, ids_target_pexp, ids_target_hedv, ids_target_clmi, ids_target_ball, ids_target_route, ids_target_add_lump

end variables

forward prototypes
private function integer of_setballastport ()
private function integer of_recalculate ()
public function integer of_calculation_modified (long al_calc_id, integer ai_status)
private function boolean of_loadload_exists ()
public function integer of_create_new_loadload (long al_calc_id, integer ai_status)
private function integer of_create ()
private function integer of_update ()
public function integer of_addtargetrows ()
public function boolean of_autocreate_loadload_onfixture ()
private function integer of_create_source_datastores ()
private function integer of_create_target_datastores ()
private function integer of_retrieve_source ()
private function integer of_retrieve_target ()
private function integer of_set_estimated_calcid ()
public function integer of_fixture (long al_calc_id, integer ai_status)
public subroutine documentation ()
end prototypes

private function integer of_setballastport ();/* This function 
	- removes the ballast from port	
	- finds the first load port and sets the ballast to port equal to this port 
	- if there are bunkering ports before first load port, they will be removed, and estimated hours moved to first cargo bunkering hours */

long 		ll_rows, ll_row, ll_found
string		ls_portcode
string		ls_null; setNull(ls_null)
decimal	ld_null;setNull(ld_null)
decimal	ld_bunkering_sum = 0, ld_bunkering_estimate, ld_bunkering_cargo
decimal	ld_idle_sum = 0, ld_idle_estimate, ld_idle_cargo
decimal	ld_other_sum = 0, ld_other_estimate, ld_other_cargo
long		ll_carg_id[], ll_cal_caioID

if ids_target_ball.rowcount( ) <> 2 then
	messagebox("Ballast Port Error", "There are not enough ballast ports on calculation")
	return -1
end if

/* sort ballast ports to be sure that ballast from if the first row */
ids_target_ball.setSort("cal_ball_id")
ids_target_ball.Sort()

/* remove ballast from port if any */ 
if ids_target_ball.getItemString(1, "port_code") <> space(10) then			// 10 spaces equal to (none)
	ids_target_ball.setItem(1, "port_code", space(10))   
	ids_target_ball.setItem(1, "cal_ball_via_point_1", ls_null)  
	ids_target_ball.setItem(1, "cal_ball_via_point_2", ls_null)  
	ids_target_ball.setItem(1, "cal_ball_via_point_3", ls_null)  
	ids_target_ball.setItem(1, "cal_ball_via_expenses_1", ld_null)  
	ids_target_ball.setItem(1, "cal_ball_via_expenses_2", ld_null)  
	ids_target_ball.setItem(1, "cal_ball_via_expenses_3", ld_null)  
	ids_target_ball.setItem(1, "cal_ball_distance_to_next", 1)  
	ids_target_ball.setItem(1, "cal_ball_days_at_sea", ld_null)  
	ids_target_ball.setItem(1, "cal_ball_leg_speed", ld_null)  
	ids_target_ball.setItem(1, "cal_ball_total_port_expenses", ld_null)  
	
	ids_target_calc.setitem(1, "cal_calc_ballast_from", space(10))
end if	

/* Prepare find first load port */
ids_target_carg.setFilter("")
ids_target_carg.Filter()
ids_target_route.sort()

ll_rows = ids_target_carg.rowcount( )
for ll_row = 1 to ll_rows
	ll_carg_id[ll_row] = ids_target_carg.getitemnumber(ll_row, "cal_carg_id")
next
ids_target_caio.retrieve( ll_carg_id )
commit;

/* find first load port */
ll_rows = ids_target_route.rowCount( )
for ll_row = 1 to ll_rows
	ls_portcode = ids_target_route.getitemstring(ll_row, "port_code")
	ll_found = ids_target_caio.find("port_code='"+string(ls_portcode)+"'",1,9999)
	if ll_found > 0 then
		choose case ids_target_caio.getitemstring(ll_found, "purpose_code") 
			case  "L", "L/D"
				exit
		end choose
	end if
next

/* set ballast to port */
if ll_found > 0 then
	ids_target_ball.setitem(2, "port_code",ls_portcode)
	ids_target_calc.setitem(1, "cal_calc_ballast_to",ls_portcode) 
end if

/*  Find out if there is any port before first loadport and delete them. 
	If bunkering port before first load port, estimated bunkering days 
	will be transferred to cargo bunkering days  */
ll_rows = ids_target_caio.rowCount( )
ids_target_caio.setSort("cal_caio_itinerary_number A")
ids_target_caio.Sort()

for ll_row = 1 to ll_rows
	choose case ids_target_caio.getitemstring(ll_row, "purpose_code") 
		case  "L", "L/D"
			exit
		case "BUN", "WD"
			if ids_target_caio.getitemstring(ll_row, "purpose_code") = "BUN" then
				ld_bunkering_estimate = ids_target_caio.getitemnumber(ll_row, "cal_caio_rate_estimated")     /* estimate in hours */
				if isnull(ld_bunkering_estimate) then ld_bunkering_estimate = 0
				ld_bunkering_estimate = ld_bunkering_estimate / 24		/* convert to days */
				ld_bunkering_sum += ld_bunkering_estimate 
			else // WD
				ld_idle_estimate = ids_target_caio.getitemnumber(ll_row, "cal_caio_rate_estimated")     /* estimate in hours */
				if isnull(ld_idle_estimate) then ld_idle_estimate = 0
				ld_idle_estimate = ld_idle_estimate / 24		/* convert to days */
				ld_idle_sum += ld_idle_estimate 
			end if
			ll_cal_caioID = ids_target_caio.getItemNumber(ll_row, "cal_caio_id")
			if not isnull(ll_cal_caioID) then
				DELETE FROM CAL_PEXP WHERE CAL_CAIO_ID = :ll_cal_caioID;
			end if
			ids_target_caio.deleterow(ll_row)
			ll_rows = ids_target_caio.rowcount()
			ll_row --
		case else
			ld_other_estimate = ids_target_caio.getitemnumber(ll_row, "cal_caio_rate_estimated")     /* estimate in hours */
			if isnull(ld_other_estimate) then ld_other_estimate = 0
			ld_other_estimate = ld_other_estimate / 24		/* convert to days */
			ld_other_sum += ld_other_estimate 
			ll_cal_caioID = ids_target_caio.getItemNumber(ll_row, "cal_caio_id")
			if not isnull(ll_cal_caioID) then
				DELETE FROM CAL_PEXP WHERE CAL_CAIO_ID = :ll_cal_caioID;
			end if
			ids_target_caio.deleterow(ll_row)
			ll_rows = ids_target_caio.rowcount()
			ll_row --
	end choose
next

/* Set variables back to calculation */
ld_bunkering_cargo = ids_target_carg.getitemnumber(1, "cal_carg_bunkering_days")
if isnull(ld_bunkering_cargo) then ld_bunkering_cargo = 0
ld_bunkering_cargo += ld_bunkering_sum
ids_target_carg.setitem(1, "cal_carg_bunkering_days", ld_bunkering_cargo)

ld_idle_cargo = ids_target_carg.getitemnumber(1, "cal_carg_idle_days")
if isnull(ld_idle_cargo) then ld_idle_cargo = 0
ld_idle_cargo += ld_idle_sum
ids_target_carg.setitem(1, "cal_carg_idle_days", ld_idle_cargo)

ld_other_cargo = ids_target_carg.getitemnumber(1, "cal_carg_add_days_other")
if isnull(ld_other_cargo) then ld_other_cargo = 0
ld_other_cargo += ld_other_sum
ids_target_carg.setitem(1, "cal_carg_add_days_other", ld_other_cargo)

/* Set itinerary numbers */
ll_rows = ids_target_caio.rowcount()
for ll_row = 1 to ll_rows
	ids_target_caio.setItem(ll_row, "cal_caio_itinerary_number", ll_row)
next	

ids_target_caio.setSort("")
ids_target_caio.Sort()

/* Update */
if ids_target_calc.update() = 1 then
	if ids_target_ball.update() = 1 then
		if ids_target_carg.update() = 1 then
			if ids_target_caio.update() = 1 then
				commit;
			else
				rollback;
				MessageBox("Select Error", "Unable to save Cargo in/out ports (CAIO). Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_setballastport()")
				return -1
			end if
		else
			rollback;
			MessageBox("Select Error", "Unable to save Cargo. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_setballastport()")
			return -1
		end if
	else
		rollback;
		MessageBox("Select Error", "Unable to save Ballast Port. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_setballastport()")
		return -1
	end if
else
	rollback;
	MessageBox("Select Error", "Unable to save Calculation Ballast Port. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_setballastport()")
	return -1
end if

return 1
end function

private function integer of_recalculate ();/* Recalculate the LoadLoad calculation after ballast ports changed */

// Variable declaration
//u_atobviac_calculation	lnv_calc
s_calculation_parm lstr_parm

//lnv_calc = create u_atobviac_calculation
open(w_loadload_recalc_window)

// Set the calculation object not to show messages, WS reload and VESSEL data reload
// according to the CBX_NO_RELOAD checkbox
w_loadload_recalc_window.uo_recalc.ib_show_messages = false
w_loadload_recalc_window.uo_recalc.ib_no_ws_reload = false
w_loadload_recalc_window.uo_recalc.ib_no_vesseldata_reload = false

// Retrieve the calculation into the calculation object
w_loadload_recalc_window.uo_recalc.uf_retrieve(ids_target_calc.getItemNumber(1,"cal_calc_id" ))

// Get the calculation status into the local LI_STATUS variable
//li_status = uo_calculation.uf_get_status(0)

// Load the speedlist 
w_loadload_recalc_window.uo_recalc.uf_reload_speedlist()

lstr_parm.b_silent_calculation = true
lstr_parm.i_function_code = 2

// do the calculation
w_loadload_recalc_window.uo_recalc.uf_reload_speedlist()
w_loadload_recalc_window.uo_recalc.TriggerEvent("ue_port_changed")
//w_loadload_recalc_window.uo_recalc.uf_calculate_with_parm(lstr_parm) 
w_loadload_recalc_window.uo_recalc.uf_calculate() 
w_loadload_recalc_window.uo_recalc.uf_calculate() 

//save the data
w_loadload_recalc_window.uo_recalc.uf_save(true)

close(w_loadload_recalc_window)

return 1
end function

public function integer of_calculation_modified (long al_calc_id, integer ai_status);/* tjek om der skal oprettes en LoadLoad calcule og opret den ved at kalde create */

il_calc_id = al_calc_id
ii_status = ai_status

/* First check if there already is a LoadLoad calculation*/

//if ai_status = 5 and not of_loadload_exists( ) then
//if ai_status = 6 and not of_loadload_exists( ) then
//	if of_autocreate_loadload_onfixture( ) then
//		of_create( )
//	end if
////elseif ai_status = 6 and not of_loadload_exists( ) then
////	if of_autocreate_loadload_onfixture( ) then
////		of_create( )
////	end if
//elseif of_loadload_exists() then
//	of_update( )
//end if	

if of_loadload_exists() then of_update( )	

return 1
end function

private function boolean of_loadload_exists ();/* Check if loadload calculation exists */

if not isNull(il_loadload_calc_id) then return true

if isNull(il_fix_id) then
	SELECT CAL_CALC_FIX_ID
		INTO :il_fix_id
		FROM CAL_CALC
		WHERE CAL_CALC_ID = :il_calc_id;
	if SQLCA.sqlcode <> 0 then
		MessageBox("Select Error", "Unable to read calculation fixture id. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_loadload_exists()")
		commit;
		return false
	end if
end if
commit;

SELECT CAL_CALC_ID
	INTO :il_loadload_calc_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :il_fix_id
	AND CAL_CALC_STATUS = 7;
if SQLCA.sqlcode <> 0 then 
	commit;
	return false
end if
commit;	

return true

end function

public function integer of_create_new_loadload (long al_calc_id, integer ai_status);/* Checks if there is already a LoadLoad calculation. if NOT create one 
	
	Returns:		 1 = OK
					 0 = ignore (there is already one)
					-1 = an error occured
*/					

il_calc_id = al_calc_id
ii_status = ii_status

if of_loadload_exists( ) then return 0

of_create( )
of_setballastport( )
of_recalculate( )

return 1
end function

private function integer of_create ();/* this function creates a new loadload calculation by copying the estimated calculation */
long 	ll_null;setNull(ll_null)
long	ll_cargo_row
long	ll_caio_row
long	ll_row
long   ll_add_lump_row

of_set_estimated_calcid( )

of_create_source_datastores( )
of_create_target_datastores( )

of_retrieve_source( )

/* Copy Calculation */ 
if ids_source_calc.RowCount() > 0 then 
	ids_target_calc.reset()
	ids_source_calc.RowsCopy( 1, 1, Primary!, ids_target_calc, 1, Primary!)
	ids_target_calc.setItem(1, "cal_calc_id", ll_null)
	ids_target_calc.setItem(1, "cal_calc_status", 7 )	  /* 7 = Loadload */
	ids_target_calc.setItem(1, "cal_calc_created", datetime(today(), now()) )	
	ids_target_calc.setItem(1, "cal_calc_created_by", uo_global.is_userid )	
	ids_target_calc.setItem(1, "cal_calc_last_edited", datetime(today(), now()) )	
	ids_target_calc.setItem(1, "cal_calc_last_edited_by", uo_global.is_userid )	
end if	
if ids_target_calc.update() <> 1 then
	rollback;
	MessageBox("Update Error", "Unable to update calculation. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
	return -1
end if

/* Copy Cargo and Childs */ 
if ids_source_carg.rowCount() > 0 then
	for ll_cargo_row = 1 to ids_source_carg.rowCount()
		ids_target_carg.reset()
		ids_source_carg.RowsCopy( ll_cargo_row, ll_cargo_row, Primary!, ids_target_carg, 1, Primary!)
		ids_target_carg.setItem(1, "cal_carg_id", ll_null)
		ids_target_carg.setItem(1, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
		ids_target_carg.setItem(1, "cal_carg_status", 7 )	  /* 7 = Loadload */

		if ids_target_carg.update() <> 1 then
			rollback;
			MessageBox("Update Error", "Unable to update cargo. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
			return -1
		end if
		
		/* Copy additional lumpsums */	
		ids_source_add_lump.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_add_lump.Filter()		
		if ids_source_add_lump.rowCount() > 0 then
			for ll_add_lump_row = 1 to ids_source_add_lump.rowCount()
				ids_target_add_lump.reset( )
				ids_source_add_lump.RowsCopy( ll_add_lump_row, ll_add_lump_row, Primary!, ids_target_add_lump, 1, Primary!)
				ids_target_add_lump.setItem(1, "cal_lump_id", ll_null)
				ids_target_add_lump.setItem(1, "cal_carg_id", ids_target_carg.getItemNumber(1, "cal_carg_id"))
				if ids_target_add_lump.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update addtional lumpsums. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
					return -1
				end if
			next
		end if
		
		/* Copy CAIO (cargo ports) */	
		ids_source_caio.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_caio.Filter()
		if ids_source_caio.rowCount() > 0 then
			for ll_caio_row = 1 to ids_source_caio.rowCount()
				ids_target_caio.reset()
				ids_source_caio.RowsCopy( ll_caio_row, ll_caio_row, Primary!, ids_target_caio, 1, Primary!)
				ids_target_caio.setItem(1, "cal_caio_id", ll_null)
				ids_target_caio.setItem(1, "cal_carg_id", ids_target_carg.getItemNumber(1, "cal_carg_id"))
				if ids_target_caio.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update CAIO. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
					return -1
				end if
				/* Copy PEXP (Port Expenses) */
				ids_source_pexp.setFilter("cal_caio_id="+string(ids_source_caio.getItemNumber(ll_caio_row, "cal_caio_id")))
				ids_source_pexp.Filter()
				if ids_source_pexp.rowCount() > 0 then
					for ll_row = 1 to ids_source_pexp.rowCount()
						ids_target_pexp.reset()
						ids_source_pexp.RowsCopy( ll_row, ll_row, Primary!, ids_target_pexp, 1, Primary!)
						ids_target_pexp.setItem(1, "cal_pexp_id", ll_null)
						ids_target_pexp.setItem(1, "cal_caio_id", ids_target_caio.getItemNumber(1, "cal_caio_id"))
			
						if ids_target_pexp.update() <> 1 then
							rollback;
							MessageBox("Update Error", "Unable to update PEXP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
							return -1
						end if
					next	
				end if
			next	
		end if

		/* Copy HEDV (Heating Deviation) */
		ids_source_hedv.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_hedv.Filter()
		if ids_source_hedv.rowCount() > 0 then
			for ll_row = 1 to ids_source_hedv.rowCount()
				ids_target_hedv.reset()
				ids_source_hedv.RowsCopy( ll_row, ll_row, Primary!, ids_target_hedv, 1, Primary!)
				ids_target_hedv.setItem(1, "cal_hedv_id", ll_null)
				ids_target_hedv.setItem(1, "cal_carg_id", ids_target_carg.getItemNumber(1, "cal_carg_id"))
				if ids_target_hedv.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update HEDV. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
					return -1
				end if
			next	
		end if

		/* Copy CLMI (Claims) */
		ids_source_clmi.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_clmi.Filter()
		if ids_source_clmi.rowCount() > 0 then
			for ll_row = 1 to ids_source_clmi.rowCount()
				ids_target_clmi.reset()
				ids_source_clmi.RowsCopy( ll_row, ll_row, Primary!, ids_target_clmi, 1, Primary!)
				ids_target_clmi.setItem(1, "cal_clmi_id", ll_null)
				ids_target_clmi.setItem(1, "cal_carg_id", ids_target_carg.getItemNumber(1, "cal_carg_id"))
				if ids_target_clmi.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update CLMI. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
					return -1
				end if
			next	
		end if
	next 
end if

/* Update Ballast */
if ids_source_ball.rowCount() > 0 then
	ids_target_ball.reset()
	for ll_row = 1 to ids_source_ball.rowCount()
		ids_source_ball.RowsCopy( ll_row, ll_row, Primary!, ids_target_ball, 1, Primary!)
		ids_target_ball.setItem(1, "cal_ball_id", ll_null)
		ids_target_ball.setItem(1, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
	next	
	if ids_target_ball.update() <> 1 then
		rollback;
		MessageBox("Update Error", "Unable to update Ballast Ports. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
		return -1
	end if
end if

/* Update Route */
if ids_source_route.rowCount() > 0 then
	ids_target_route.reset()
	for ll_row = 1 to ids_source_route.rowCount()
		ids_source_route.RowsCopy( ll_row, ll_row, Primary!, ids_target_route, 1, Primary!)
		ids_target_route.setItem(1, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
	next	

	if ids_target_route.update() <> 1 then
		rollback;
		MessageBox("Update Error", "Unable to update Calculation Route. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_create()")
		return -1
	end if
end if

commit;
return 1
end function

private function integer of_update ();/* this function updates the loadload calculation if it is already there */
long 	ll_null;setNull(ll_null)
long	ll_cargo_row
long	ll_caio_row, ll_add_lump_row
long	ll_row, ll_rows
/* Variables to compare old/new route */
string 		ls_portcode[], ls_last_CAIOport
decimal {2} ld_portexpenses[]

of_set_estimated_calcid( )

of_create_source_datastores( )
of_create_target_datastores( )

of_retrieve_source( )
of_retrieve_target( )

/* Modify Calculation  */ 
ids_target_calc.object.data[1,1,1,3] = ids_source_calc.object.data[1,1,1,3]					//ignore calc ID
ids_target_calc.object.data[1,5,1,75] = ids_source_calc.object.data[1,5,1,75]
ids_target_calc.setItem(1, "cal_calc_status", 7 )	  /* 7 = Loadload */
if ids_target_calc.update() <> 1 then
	rollback;
	MessageBox("Update Error", "Unable to update calculation. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
	return -1
end if

/* For all below targets we ensure that there is at least the same number of rows - no delete is taging place */
of_addtargetrows( )

/* Modify Cargo and Childs */ 
if ids_source_carg.rowCount() > 0 then
	for ll_cargo_row = 1 to ids_source_carg.rowCount()
		ids_target_carg.object.data[ ll_cargo_row, 2, ll_cargo_row,50] = ids_source_carg.object.data[ ll_cargo_row, 2, ll_cargo_row,50]
		ids_target_carg.setItem(ll_cargo_row, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
		ids_target_carg.setItem(ll_cargo_row, "cal_carg_status", 7 )	  /* 7 = Loadload */
		if ids_target_carg.update() <> 1 then
			rollback;
			MessageBox("Update Error", "Unable to update cargo. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
			return -1
		end if
		
		/* Copy addtional lumpsums */	
		ids_source_add_lump.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_add_lump.Filter()
		ids_target_add_lump.setFilter("cal_carg_id="+string(ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_target_add_lump.Filter()
		if ids_source_add_lump.rowCount() > 0 then
			for ll_add_lump_row = 1 to ids_source_add_lump.rowCount()
				ids_target_add_lump.object.data[ll_add_lump_row, 1, ll_add_lump_row, 5] = ids_source_add_lump.object.data[ ll_add_lump_row, 1, ll_add_lump_row, 5]
				ids_target_add_lump.setItem(ll_add_lump_row, "cal_carg_id", ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id"))
				if ids_target_add_lump.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update addtional lumpsums. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
					return -1
				end if		
			next
		end if
		
		/* Copy CAIO (cargo ports) */	
		ids_source_caio.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_caio.Filter()
		ids_target_caio.setFilter("cal_carg_id="+string(ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_target_caio.Filter()
		if ids_source_caio.rowCount() > 0 then
			for ll_caio_row = 1 to ids_source_caio.rowCount()
				ids_target_caio.object.data[ll_caio_row, 2, ll_caio_row, 32] = ids_source_caio.object.data[ ll_caio_row, 2, ll_caio_row, 32]
				ids_target_caio.setItem(ll_caio_row, "cal_carg_id", ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id"))
				if ids_target_caio.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update CAIO. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
					return -1
				end if
				/* Copy PEXP (Port Expenses) */
				ids_source_pexp.setFilter("cal_caio_id="+string(ids_source_caio.getItemNumber(ll_caio_row, "cal_caio_id")))
				ids_source_pexp.Filter()
				ids_target_pexp.setFilter("cal_caio_id="+string(ids_target_caio.getItemNumber(ll_caio_row, "cal_caio_id")))
				ids_target_pexp.Filter()
				if ids_source_pexp.rowCount() > 0 then
					for ll_row = 1 to ids_source_pexp.rowCount()
						ids_target_pexp.object.data[ ll_row,2, ll_row, 5] = ids_source_pexp.object.data[ ll_row,2, ll_row, 5]
						ids_target_pexp.setItem(ll_row, "cal_caio_id", ids_target_caio.getItemNumber(ll_caio_row, "cal_caio_id"))
						if ids_target_pexp.update() <> 1 then
							rollback;
							MessageBox("Update Error", "Unable to update PEXP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
							return -1
						end if
					next	
				end if
			next	
		end if
				
		/* Copy HEDV (Heating Deviation) */
		ids_source_hedv.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_hedv.Filter()
		ids_target_hedv.setFilter("cal_carg_id="+string(ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_target_hedv.Filter()
		if ids_source_hedv.rowCount() > 0 then
			for ll_row = 1 to ids_source_hedv.rowCount()
				ids_target_hedv.object.data[ ll_row, 1, ll_row, 10] = ids_source_hedv.object.data[ ll_row, 1, ll_row,10]
				ids_target_hedv.object.data[ ll_row, 12, ll_row, 18] = ids_source_hedv.object.data[ ll_row, 12, ll_row, 18]
				ids_target_hedv.setItem(ll_row, "cal_carg_id", ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id"))
				if ids_target_hedv.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update HEDV. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
					return -1
				end if
			next	
		end if

		/* Copy CLMI (Claims) */
		ids_source_clmi.setFilter("cal_carg_id="+string(ids_source_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_source_clmi.Filter()
		ids_target_clmi.setFilter("cal_carg_id="+string(ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id")))
		ids_target_clmi.Filter()
		if ids_source_clmi.rowCount() > 0 then
			for ll_row = 1 to ids_source_clmi.rowCount()
				ids_target_clmi.object.data[ ll_row, 2, ll_row,7] = ids_source_clmi.object.data[ ll_row, 2, ll_row,7]
				ids_target_clmi.setItem(ll_row, "cal_carg_id", ids_target_carg.getItemNumber(ll_cargo_row, "cal_carg_id"))
				if ids_target_clmi.update() <> 1 then
					rollback;
					MessageBox("Update Error", "Unable to update CLMI. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
					return -1
				end if
			next	
		end if
	next 
end if

/* Update Ballast */
if ids_source_ball.rowCount() > 0 then
	for ll_row = 1 to ids_source_ball.rowCount()
		ids_target_ball.object.data[ ll_row, 2, ll_row, 13] = ids_source_ball.object.data[ ll_row, 2, ll_row, 13]
		ids_target_ball.setItem(ll_row, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
	next	
	if ids_target_ball.update() <> 1 then
		rollback;
		MessageBox("Update Error", "Unable to update Ballast Ports. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
		return -1
	end if
end if

/* Get old route into memory variables, so that they can be compared with new route
	Run through route / old route from last port to last CAIO port to */
ids_source_caio.setFilter("")
ids_source_caio.Filter()
ids_target_caio.setFilter("")
ids_target_caio.Filter()
ids_target_caio.setSort(" cal_caio_itinerary_number A")
ids_target_caio.Sort()
ls_last_CAIOport = ids_target_caio.getItemString(ids_target_caio.rowCount(), "port_code")
ids_source_caio.setSort(" cal_caio_itinerary_number A")
ids_source_caio.Sort()
if ls_last_CAIOport = ids_source_caio.getItemString(ids_source_caio.rowCount(), "port_code") then
	/* save old route from last CAIO port to ballast to port (save portcode and expenses 
		will be used to update expenses in new route if same leg */
	ll_rows = ids_target_route.rowCount()
	for ll_row = ll_rows to 1 step -1
		if ls_last_CAIOport = ids_target_route.getItemString(ll_row, "port_code") then EXIT  /* Last CAIO port reached */
		ls_portcode[upperbound(ls_portcode)+1] = ids_target_route.getItemString(ll_row, "port_code")
		ld_portexpenses[upperbound(ld_portexpenses) +1] = ids_target_route.getItemNumber(ll_row, "rp_expenses")
	next	
end if

/* Update Route */
if ids_source_route.rowCount() > 0 then
	for ll_row = 1 to ids_source_route.rowCount()
		ids_target_route.object.data[ll_row, 1, ll_row,1] = ids_source_route.object.data[ll_row, 1, ll_row,1]
		ids_target_route.object.data[ll_row, 3, ll_row,5] = ids_source_route.object.data[ll_row, 3, ll_row,5]
		ids_target_route.setItem(ll_row, "cal_calc_id", ids_target_calc.getItemNumber(1, "cal_calc_id"))
	next	
	
	if ids_target_route.update() <> 1 then
		rollback;
		MessageBox("Update Error", "Unable to update Calculation Route. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_update()")
		return -1
	end if
end if

of_setballastport( )

/*  Modify route expenses from last CAIO port to ballast to  */
ll_rows = upperbound(ls_portcode)
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		if ls_portcode[ll_row] <> ids_target_route.getItemString(ids_target_route.rowcount() - (ll_row -1), "port_code") then EXIT
		ids_target_route.setItem(ids_target_route.rowcount() - (ll_row -1), "rp_expenses", ld_portexpenses[ll_row])
	next
end if

of_recalculate( )

commit;
return 1
end function

public function integer of_addtargetrows ();/* For all below targets we ensure that there is at least same number of rows - no delete is taging place */
long	ll_rows, ll_row

if ids_source_carg.rowcount() > ids_target_carg.rowcount( ) then
	for ll_row = ids_target_carg.rowcount( ) +1 to ids_source_carg.rowcount()
		ids_target_carg.insertRow(0)
	next
end if

if ids_source_caio.rowcount() > ids_target_caio.rowcount( ) then
	for ll_row = ids_target_caio.rowcount( ) +1 to ids_source_caio.rowcount()
		ids_target_caio.insertRow(0)
	next
end if

if ids_source_add_lump.rowcount() > ids_target_add_lump.rowcount( ) then
	for ll_row = ids_target_add_lump.rowcount( ) +1 to ids_source_add_lump.rowcount()
		ids_target_add_lump.insertRow(0)
	next
end if

if ids_source_pexp.rowcount() > ids_target_pexp.rowcount( ) then
	for ll_row = ids_target_pexp.rowcount( ) +1 to ids_source_pexp.rowcount()
		ids_target_pexp.insertRow(0)
	next
end if

if ids_source_hedv.rowcount() > ids_target_hedv.rowcount( ) then
	for ll_row = ids_target_hedv.rowcount( ) +1 to ids_source_hedv.rowcount()
		ids_target_hedv.insertRow(0)
	next
end if

if ids_source_clmi.rowcount() > ids_target_clmi.rowcount( ) then
	for ll_row = ids_target_clmi.rowcount( ) +1 to ids_source_clmi.rowcount()
		ids_target_clmi.insertRow(0)
	next
end if

if ids_source_ball.rowcount() > ids_target_ball.rowcount( ) then
	for ll_row = ids_target_ball.rowcount( ) +1 to ids_source_ball.rowcount()
		ids_target_ball.insertRow(0)
	next
end if

//ids_source_route Not sure yet how to implement this 

return 1
end function

public function boolean of_autocreate_loadload_onfixture ();/* Checks if ther shall be created a LoadLoad or not.  */
integer li_vessel, li_true

if isNull(il_calc_id) or il_calc_id = 0 then return false

SELECT CAL_CALC.CAL_CALC_VESSEL_ID  
	INTO :li_vessel  
	FROM CAL_CALC  
	WHERE CAL_CALC.CAL_CALC_ID = :il_calc_id   ;
COMMIT;

SELECT PROFIT_C.LOADLOAD_CALCULATION  
	INTO :li_true  
	FROM PROFIT_C,   
		VESSELS  
	WHERE VESSELS.PC_NR = PROFIT_C.PC_NR and  
		VESSELS.VESSEL_NR = :li_vessel  ;
commit;

if li_true = 1 then
	return true
else
	return false
end if
end function

private function integer of_create_source_datastores ();ids_source_calc 	= create n_ds
ids_source_calc.dataObject = "d_sq_tb_loadload_calc"
ids_source_calc.setTransObject(SQLCA)

ids_source_carg	= create n_ds
ids_source_carg.dataObject = "d_sq_tb_loadload_carg"
ids_source_carg.setTransObject(SQLCA)

ids_source_caio	= create n_ds
ids_source_caio.dataObject = "d_sq_tb_loadload_caio"
ids_source_caio.setTransObject(SQLCA)

ids_source_pexp	= create n_ds
ids_source_pexp.dataObject = "d_sq_tb_loadload_pexp"
ids_source_pexp.setTransObject(SQLCA)

ids_source_hedv	= create n_ds
ids_source_hedv.dataObject = "d_sq_tb_loadload_hedv"
ids_source_hedv.setTransObject(SQLCA)

ids_source_clmi	= create n_ds
ids_source_clmi.dataObject = "d_sq_tb_loadload_clmi"
ids_source_clmi.setTransObject(SQLCA)

ids_source_ball	= create n_ds
ids_source_ball.dataObject = "d_sq_tb_loadload_ball"
ids_source_ball.setTransObject(SQLCA)

ids_source_route= create n_ds
ids_source_route.dataObject = "d_sq_tb_loadload_route"
ids_source_route.setTransObject(SQLCA)

ids_source_add_lump= create n_ds
ids_source_add_lump.dataObject = "d_sq_tb_loadload_add_lumps"
ids_source_add_lump.setTransObject(SQLCA)

return 1
end function

private function integer of_create_target_datastores ();ids_target_calc 	= create n_ds
ids_target_calc.dataObject = "d_sq_tb_loadload_calc"
ids_target_calc.setTransObject(SQLCA)

ids_target_carg	= create n_ds
ids_target_carg.dataObject = "d_sq_tb_loadload_carg"
ids_target_carg.setTransObject(SQLCA)

ids_target_caio	= create n_ds
ids_target_caio.dataObject = "d_sq_tb_loadload_caio"
ids_target_caio.setTransObject(SQLCA)

ids_target_pexp	= create n_ds
ids_target_pexp.dataObject = "d_sq_tb_loadload_pexp"
ids_target_pexp.setTransObject(SQLCA)

ids_target_hedv	= create n_ds
ids_target_hedv.dataObject = "d_sq_tb_loadload_hedv"
ids_target_hedv.setTransObject(SQLCA)

ids_target_clmi	= create n_ds
ids_target_clmi.dataObject = "d_sq_tb_loadload_clmi"
ids_target_clmi.setTransObject(SQLCA)

ids_target_ball	= create n_ds
ids_target_ball.dataObject = "d_sq_tb_loadload_ball"
ids_target_ball.setTransObject(SQLCA)

ids_target_route= create n_ds
ids_target_route.dataObject = "d_sq_tb_loadload_route"
ids_target_route.setTransObject(SQLCA)

ids_target_add_lump= create n_ds
ids_target_add_lump.dataObject = "d_sq_tb_loadload_add_lumps"
ids_target_add_lump.setTransObject(SQLCA)

return 1
end function

private function integer of_retrieve_source ();long 		ll_rows, ll_row
long 		ll_carg_id[], ll_caio_id[], ll_lump_id[]

/* Calculation */
ll_rows = ids_source_calc.retrieve(il_estimated_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CALC. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* Cargo */
ll_rows = ids_source_carg.retrieve(il_estimated_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CARG. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

for ll_row = 1 to ll_rows
	ll_carg_id[ll_row] = ids_source_carg.getItemNumber(ll_row, "cal_carg_id")
next

/* additonal lumpsums */
ll_rows = ids_source_add_lump.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_LUMP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* CAIO - ports */
ll_rows = ids_source_caio.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CAIO. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

for ll_row = 1 to ll_rows
	ll_caio_id[ll_row] = ids_source_caio.getItemNumber(ll_row, "cal_caio_id")
next

/* PEXP - port expenses */
ll_rows = ids_source_pexp.retrieve( ll_caio_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_PEXP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* HEDV - heating / deviation */
ll_rows = ids_source_hedv.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_HEDV. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* CLMI - Claims */
ll_rows = ids_source_clmi.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CLMI. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* Ballast ports */
ll_rows = ids_source_ball.retrieve(il_estimated_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_BALL. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

/* Route */
ll_rows = ids_source_route.retrieve(il_estimated_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_ROUTE. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_source()")
	return -1
end if

return 1
end function

private function integer of_retrieve_target ();long 		ll_rows, ll_row
long 		ll_carg_id[], ll_caio_id[]

/* Calculation */
ll_rows = ids_target_calc.retrieve(il_loadload_calc_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CALC. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* Cargo */
ll_rows = ids_target_carg.retrieve(il_loadload_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CARG. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

for ll_row = 1 to ll_rows
	ll_carg_id[ll_row] = ids_target_carg.getItemNumber(ll_row, "cal_carg_id")
next

/* addtional lumpsums */
ll_rows = ids_target_add_lump.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_LUMP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* CAIO - ports */
ll_rows = ids_target_caio.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CAIO. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

for ll_row = 1 to ll_rows
	ll_caio_id[ll_row] = ids_target_caio.getItemNumber(ll_row, "cal_caio_id")
next

/* PEXP - port expenses */
ll_rows = ids_target_pexp.retrieve( ll_caio_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_PEXP. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* HEDV - heating / deviation */
ll_rows = ids_target_hedv.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_HEDV. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* CLMI - Claims */
ll_rows = ids_target_clmi.retrieve( ll_carg_id )
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_CLMI. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* Ballast ports */
ll_rows = ids_target_ball.retrieve(il_loadload_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_BALL. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

/* Route */
ll_rows = ids_target_route.retrieve(il_loadload_calc_id)
commit;
if ll_rows = -1 then
	MessageBox("Retrieval Error", "Unable to retrieve source CAL_ROUTE. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_retrieve_target()")
	return -1
end if

return 1
end function

private function integer of_set_estimated_calcid ();/* Checks if estimated id already set. if NOT set it */

if not isNull(il_estimated_calc_id) then return 1

SELECT CAL_CALC_ID
	INTO :il_estimated_calc_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :il_fix_id
	AND CAL_CALC_STATUS = 6;
if SQLCA.sqlcode <> 0 then
	//MessageBox("Select Error", "Unable to read estimated calculation id. Please contact system administrator~n~r~n~rObject: u_atobviac_loadload_calculation, Function: of_set_estimated_calcid()")
	commit;
	return 1
end if

commit;
return 1
end function

public function integer of_fixture (long al_calc_id, integer ai_status);/* tjek om der skal oprettes en LoadLoad calcule og opret den ved at kalde create */

il_calc_id = al_calc_id
ii_status = ai_status

if of_autocreate_loadload_onfixture( ) then
	of_create_new_loadload( il_calc_id, ii_status )
end if	

return 1
end function

public subroutine documentation ();/********************************************************************
   u_atobviac_loadload_calculation
   <OBJECT></OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	11/11/15 	CR3250            CCY018        Add LSFO fuel in calculation module.
   </HISTORY>
********************************************************************/
end subroutine

on u_atobviac_loadload_calculation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_atobviac_loadload_calculation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;setNull(il_calc_id)
setNull(il_estimated_calc_id)
setNull(il_loadload_calc_id)
setNull(il_fix_id)
end event

event destructor;if isValid(ids_source_calc) then destroy ids_source_calc
if isValid(ids_source_carg) then destroy ids_source_carg
if isValid(ids_source_caio) then destroy ids_source_caio
if isValid(ids_source_pexp) then destroy ids_source_pexp
if isValid(ids_source_hedv) then destroy ids_source_hedv
if isValid(ids_source_clmi) then destroy ids_source_clmi
if isValid(ids_source_ball) then destroy ids_source_ball
if isValid(ids_source_route) then destroy ids_source_route
if isValid(ids_source_add_lump) then destroy ids_source_add_lump
if isValid(ids_target_calc) then destroy ids_target_calc
if isValid(ids_target_carg) then destroy ids_target_carg
if isValid(ids_target_caio) then destroy ids_target_caio
if isValid(ids_target_pexp) then destroy ids_target_pexp
if isValid(ids_target_hedv) then destroy ids_target_hedv
if isValid(ids_target_clmi) then destroy ids_target_clmi
if isValid(ids_target_ball) then destroy ids_target_ball
if isValid(ids_target_route) then destroy ids_target_route
if isValid(ids_target_add_lump) then destroy ids_target_add_lump


end event

