$PBExportHeader$u_vas_bunker.sru
$PBExportComments$Uo used for VAS bunker exp, Mt, and $ actual, and est/act.
forward
global type u_vas_bunker from u_vas_key_data
end type
end forward

global type u_vas_bunker from u_vas_key_data
end type
global u_vas_bunker u_vas_bunker

type variables
s_vessel_voyage_list is_vv_list
//decimal {3} id_hfo_units, id_do_units, id_go_units
//decimal {3} id_hfo_off_units, id_do_off_units, id_go_off_units
//decimal {3} id_hfo_idle_units, id_do_idle_units, id_go_idle_units
//decimal {3} id_hfo_cost, id_do_cost,id_go_cost
double id_hfo_units, id_do_units, id_go_units, id_lshfo_units
double id_hfo_off_units, id_do_off_units, id_go_off_units, id_lshfo_off_units
double id_hfo_idle_units, id_do_idle_units, id_go_idle_units, id_lshfo_idle_units
double id_hfo_cost, id_do_cost,id_go_cost,id_lshfo_cost
end variables

forward prototypes
public function integer of_start_bunker ()
end prototypes

public function integer of_start_bunker ();n_voyage_bunker_consumption	lnv_bunker
n_voyage_offservice_bunker_consumption	lnv_offservice
Decimal {4} ld_bunker_cost[4], ld_bunker_ton[4]
Decimal {4} ld_off_cost[4], ld_off_ton[4]
Integer li_index

/* Set values to 0 (zero) */
for li_index = 1 to 4
	ld_bunker_cost[li_index]	= 0
	ld_bunker_ton[li_index]	= 0
	ld_off_cost[li_index]		= 0
	ld_off_ton[li_index]		= 0
next	

of_get_vessel_array(is_vv_list)

IF is_vv_list.voyage_finished = 1 THEN // If not finished then act = 0
	// Get bunker units and price
	lnv_bunker = create n_voyage_bunker_consumption
	lnv_bunker.of_calculate( "HFO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_bunker_cost[1], ld_bunker_ton[1])
	lnv_bunker.of_calculate( "DO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_bunker_cost[2],  ld_bunker_ton[2])
	lnv_bunker.of_calculate( "GO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_bunker_cost[3],  ld_bunker_ton[3])
	lnv_bunker.of_calculate( "LSHFO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_bunker_cost[4],  ld_bunker_ton[4])
	destroy lnv_bunker

	// Get bunker Off Service units and price
	lnv_offservice = create n_voyage_offservice_bunker_consumption
	lnv_offservice.of_calculate( "HFO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_off_cost[1], ld_off_ton[1])
	lnv_offservice.of_calculate( "DO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_off_cost[2],  ld_off_ton[2])
	lnv_offservice.of_calculate( "GO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_off_cost[3],  ld_off_ton[3])
	lnv_offservice.of_calculate( "LSHFO", is_vv_list.vessel_nr, is_vv_list.voyage_nr , ld_off_cost[4],  ld_off_ton[4])
	destroy lnv_offservice

	// Set results actual only if finished
	of_setbunker_expenses(5,ld_bunker_cost[1] + ld_bunker_cost[2] + ld_bunker_cost[3] + ld_bunker_cost[4] &
									   - ld_off_cost[1] - ld_off_cost[2] - ld_off_cost[3] - ld_off_cost[4]) 
	of_setHFO_ton(5, ld_bunker_ton[1] - ld_off_ton[1])
	of_setDO_ton(5, ld_bunker_ton[2] - ld_off_ton[2])
	of_setGO_ton(5, ld_bunker_ton[3] - ld_off_ton[3])
	of_setLSHFO_ton(5, ld_bunker_ton[4] - ld_off_ton[4])
	of_setHFO_expenses(5, ld_bunker_cost[1] - ld_off_cost[1])
	of_setDO_expenses(5, ld_bunker_cost[2] - ld_off_cost[2])
	of_setGO_expenses(5, ld_bunker_cost[3] - ld_off_cost[3])
	of_setLSHFO_expenses(5, ld_bunker_cost[4] - ld_off_cost[4])
END IF

// Set results est/act
IF (is_vv_list.voyage_finished = 1)  THEN
	li_index = 5 
ELSE
	li_index = 3
END IF

of_setbunker_expenses(4,of_getbunker_expenses(li_index,TRUE)) 
of_setHFO_ton(4,of_GetHFO_ton(li_index,TRUE))
of_setDO_ton(4,of_GetDO_ton(li_index,TRUE))
of_setGO_ton(4,of_GetGO_ton(li_index,TRUE))
of_setLSHFO_ton(4,of_GetLSHFO_ton(li_index,TRUE))
of_setHFO_expenses(4,of_GetHFO_expenses(li_index,TRUE))
of_setDO_expenses(4,of_GetDO_expenses(li_index,TRUE))
of_setGO_expenses(4,of_GetGO_expenses(li_index,TRUE))
of_setLSHFO_expenses(4,of_GetLSHFO_expenses(li_index,TRUE))

Return 1
end function

on u_vas_bunker.create
call super::create
end on

on u_vas_bunker.destroy
call super::destroy
end on

