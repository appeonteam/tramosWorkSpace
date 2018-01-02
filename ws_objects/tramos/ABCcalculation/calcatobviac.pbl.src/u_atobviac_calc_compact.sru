$PBExportHeader$u_atobviac_calc_compact.sru
forward
global type u_atobviac_calc_compact from u_atobviac_calc_base_sqlca
end type
type dw_addbuncons from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_calc_port_expenses from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_dischports from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_loadports from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_calc_ballast from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_sidepanel from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_cargo_summary from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_calc_summary from u_datawindow_sqlca within u_atobviac_calc_compact
end type
type dw_voyage_alert from u_popupdw within u_atobviac_calc_compact
end type
end forward

global type u_atobviac_calc_compact from u_atobviac_calc_base_sqlca
integer width = 4603
integer height = 2936
long backcolor = 32304364
event ue_rightclick ( string as_object )
dw_addbuncons dw_addbuncons
dw_calc_port_expenses dw_calc_port_expenses
dw_dischports dw_dischports
dw_loadports dw_loadports
dw_calc_ballast dw_calc_ballast
dw_sidepanel dw_sidepanel
dw_cargo_summary dw_cargo_summary
dw_calc_summary dw_calc_summary
dw_voyage_alert dw_voyage_alert
end type
global u_atobviac_calc_compact u_atobviac_calc_compact

type variables
Private u_dddw_search iuo_dddw_search_from
Private u_dddw_search iuo_dddw_search_to
Private Integer il_itinerary_max
Private Long il_estimated_calc_id
private integer ii_current_cargo
private boolean ib_tooltip=false
Public s_revers_sens istr_revers_sens
Private Integer ii_reversible_cp[]    // array of rev. demurrage status. Maps to cargono.
Private Integer ii_no_cargos  // No. of cargoes on calculation
Private u_dddw_search iuo_dddw_search_load // search object for loadports
Private u_dddw_search iuo_dddw_search_disch  // search object for dischports

mt_n_dddw_searchasyoutype inv_dddw_search

n_messagebox inv_msgbox

constant string COLUMN_DESPATCH_DEM_CURR = "cal_caio_despatch_dem_curr"
constant string COLUMN_DEMURRAGE_DEM_CURR = "cal_caio_demurrage_dem_curr"
constant string COLUMN_DESPATCH_USD = "cal_caio_despatch"
constant string COLUMN_DEMURRAGE_USD = "cal_caio_demurrage"
constant string COLUMN_DEM_EXRATE_USD  = "cal_carg_cal_carg_dem_exrate_usd"
constant string COLUMN_DESPATCH_LOCAL_CURR = "cal_caio_despatch_local_curr"
constant string COLUMN_DEMURRAGE_LOCAL_CURR = "cal_caio_demurrage_local_curr"
constant string MESSAGE_CP_LAYTIME = 'The total C/P Laytime entries have changed after selecting an interim port. Verify the total C/P Laytime, and adjust if necessary.'
end variables

forward prototypes
public subroutine uf_retrieve (long al_calcid)
private subroutine uf_cargo_dblclicked (integer ai_cargo_row)
public subroutine uf_set_vessel (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id)
public subroutine uf_get_vessel (ref long al_vessel_type_id, ref long al_vessel_id, ref long al_clarkson_id)
public function string uf_get_vessel_name ()
public function integer uf_get_current_cargo ()
public subroutine uf_select_cargo (integer ai_cargo)
public subroutine uf_mark_new ()
public subroutine uf_set_status (integer ai_status)
public function integer uf_get_status ()
public function string uf_get_description ()
public subroutine uf_set_description (string as_description)
public function datetime uf_get_starting_date ()
public subroutine uf_set_starting_date (datetime adt_starting_date)
public subroutine uf_set_fixture_id (long al_fix_id)
private subroutine uf_cargo_row_changed (integer ai_cargo_row)
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public function boolean uf_process (ref s_calculation_parm astr_parm)
public function long uf_insert ()
public subroutine uf_set_firstlast_port (string as_start_port, string as_end_port)
public function long uf_get_fixture_id ()
public function boolean uf_save (long al_estimated_calc_id)
public function integer uf_deactivate ()
public function boolean uf_get_ballast_voyage ()
public subroutine uf_set_ballast_voyage (boolean ab_value)
public function long uf_total_distance ()
public subroutine uf_port_changed ()
public subroutine uf_update_locked (integer ai_value)
public subroutine uf_unlock ()
public function long uf_get_calc_id ()
public subroutine uf_activate ()
public subroutine documentation ()
public subroutine uf_insert_port_row (ref u_datawindow_sqlca adw_port)
public function integer uf_get_cargoxxx ()
public function boolean uf_delete_misc_exp (long al_caio_id)
public subroutine uf_insert_port ()
public function integer of_getdatawindowfocus (ref u_datawindow_sqlca adw, ref string as_name)
public subroutine uf_check_cqd (u_datawindow_sqlca adw_datawindow)
public function string uf_loaddisch_itemchanged (ref u_datawindow_sqlca adw_datawindow, ref u_dddw_search luo_dddw_search)
public subroutine of_init_data ()
private function integer _getsettledclaimcounts (ref integer ai_settledfreight, ref integer ai_settledother)
public subroutine _settcestatus ()
public function boolean of_change_tce ()
protected subroutine of_show_voyage_alert (string as_port_code, integer ai_xpos, integer ai_ypos)
public function integer of_restore_data (ref u_datawindow_sqlca adw_datawindow, integer row)
public function boolean of_isallowed_interim (datawindow adw_cargo, long al_row, string as_data, string as_purpose_code)
public function integer of_check_interimport_change (datawindow ad_datawindow, long al_row, string as_data)
end prototypes

event ue_rightclick(string as_object);parent.dynamic event ue_rightclick(as_object )
end event

public subroutine uf_retrieve (long al_calcid);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-8-96

 Description : Retrieves calculation with al_calcid

 Arguments : calculation id as long

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

iuo_calc_nvo.iuo_calc_cargos.uf_retrieve( al_calcid, dw_calc_summary)

end subroutine

private subroutine uf_cargo_dblclicked (integer ai_cargo_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles doubleclick on the cargoes, by triggering a 
 					"ue_show_cargo_row" event with the cargo # as argument

 Arguments : ai_cargo_row as integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Parent.TriggerEvent("ue_show_cargo_row",ai_cargo_row,0)


end subroutine

public subroutine uf_set_vessel (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 24-7-96

 Description : Sets a new vessel Id, either as vessel_type, vessel or clarkson. 

 Arguments : al_vessel_type_id as Long
	 			 al_vessel_id as Long
		 		 al_clarkson_id as long

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
************************************************************************************/

// 0 is not allowed as VESSEL ID, so convert 0 to NULL's
If al_vessel_type_id = 0 Then SetNull(al_vessel_type_id)
If al_vessel_id = 0 Then SetNull(al_vessel_id)
If al_clarkson_id = 0 Then SetNull(al_clarkson_id)

// Update the calculation, and call UF_GET_VESSEL_DATA, so that we can
// update the Fuel, Diesel and Marine Gas prices.

Parent.TriggerEvent("ue_childmodified")



end subroutine

public subroutine uf_get_vessel (ref long al_vessel_type_id, ref long al_vessel_id, ref long al_clarkson_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 24-7-96

 Description : Returns the vessel ID in either the AL_VESSEL_TYPE_ID, AL_VESSEL_ID
					or the AL_CLARKSON_ID Long REF arguments. Only one will be specified,
					the others will be null.
					
 Returns   :   See description.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
************************************************************************************/

al_vessel_type_id = dw_calc_summary.GetItemNumber(1,"cal_vest_type_id")
al_vessel_id = dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")
al_clarkson_id = dw_calc_summary.GetItemNumber(1,"cal_clrk_id")

end subroutine

public function string uf_get_vessel_name ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the current selected vessel's name, or ? if none is selected

 Arguments : None

 Returns   : Vessel name as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_vessel_data lstr_calc_vessel_data
Long ll_vest_type_id, ll_vessel_id, ll_clarkson_id

// Pull out the vessel_ID, vessel_type_ID and clarkson_ID, and call
// uf_get_vessel_data with these ID's. uf_get_vessel_data will among other things
// return the vesselname in the istr_calc_vessel_data structure.

ll_vest_type_id = dw_calc_summary.GetItemNumber(1,"cal_vest_type_id")
ll_vessel_id = dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")
ll_clarkson_id = dw_calc_summary.GetItemNumber(1,"cal_clrk_id")

If iuo_calc_nvo.uf_get_vessel_data(ll_vest_type_id, ll_vessel_id, ll_clarkson_id) Then
	Return(iuo_calc_nvo.istr_calc_vessel_data.s_name)
Else
	Return("?")
End if

end function

public function integer uf_get_current_cargo ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the current active cargo #

 Arguments : None

 Returns   : Cargonumber as integer

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

//Return(dw_calc_summary_list.GetRow())
Return(0)
end function

public subroutine uf_select_cargo (integer ai_cargo);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selectes the cargo # given in ai_cargo

 Arguments : ai_cargo as integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
//
//dw_calc_summary_list.SelectRow(0,false)
//dw_calc_summary_list.SetRow(ai_cargo)
//dw_calc_summary_list.SelectRow(ai_cargo,true)


end subroutine

public subroutine uf_mark_new ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Marks the calculation data as new, so upon the next Update call,
 					the calculation will be saved as a new calculation, rather than
					updating the old one.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count
Long ll_tmp
SetNull(ll_tmp)

// Mark summary and ballast as new, and change the created and created by fields
dw_calc_summary.SetItemStatus(1,0, Primary!, NewModified!)

For li_count = 1 To 2 
	dw_calc_ballast.SetItemStatus(li_count, 0, Primary!, NewModified!)
	dw_calc_ballast.SetItem(li_count, "cal_calc_id", ll_tmp)
Next

dw_calc_summary.SetItem(1,"cal_calc_created",DateTime(Today(),Now()))
dw_calc_summary.SetItem(1,"cal_calc_created_by",uo_global.is_userid)


end subroutine

public subroutine uf_set_status (integer ai_status);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the calculation STATUS, and triggers a UE_CHILDMODIFIED event.

 Arguments : ai_status as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


dw_calc_summary.SetItem(1, "cal_calc_status", ai_status)
Parent.TriggerEvent("ue_childmodified")

end subroutine

public function integer uf_get_status ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the status for the calcule

 Arguments : None

 Returns   : The calculation's status as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(dw_calc_summary.GetItemNumber(1, "cal_calc_status"))

end function

public function string uf_get_description ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the description for this calculation

 Arguments : None

 Returns   : Description as string  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(dw_calc_summary.GetItemString(1,"cal_calc_description"))


end function

public subroutine uf_set_description (string as_description);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the CAL_CALC_DESCRIPTION, and triggers a UE_CHILDMODIFIED
 					event

 Arguments : AS_DESCRIPTION as string

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_summary.SetItem(1,"cal_calc_description",as_description)
Parent.TriggerEvent("ue_childmodified")
end subroutine

public function datetime uf_get_starting_date ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns starting date for the calculation

 Arguments : None

 Returns   : Starting date as datetime  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(dw_calc_summary.GetItemDateTime(1,"cal_calc_start_date"))
end function

public subroutine uf_set_starting_date (datetime adt_starting_date);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the starting date for the calculation, and triggers a
 					UE_CHILDMODIFIED event

 Arguments : adt_starting_date as datetime

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_summary.SetItem(1,"cal_calc_start_date",adt_starting_date)
Parent.TriggerEvent("ue_childmodified")
end subroutine

public subroutine uf_set_fixture_id (long al_fix_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the fixture ID for the calculation

 Arguments : al_fix_id as Long

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_summary.SetItem(1, "cal_calc_fix_id", al_fix_id)
end subroutine

private subroutine uf_cargo_row_changed (integer ai_cargo_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles a cargo row changed, by triggering a "ue_cargo_row_changed"
 					event

 Arguments : ai_cargo_row as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Parent.PostEvent("ue_cargo_row_changed",ai_cargo_row,0)

end subroutine

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw off for the summary datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_summary.uf_redraw_off()
//dw_calc_summary_list.uf_redraw_off()
end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw on for the summary datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_summary.uf_redraw_on()
//dw_calc_summary_list.uf_redraw_on()
end subroutine

public function boolean uf_process (ref s_calculation_parm astr_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1-8-96

 Description : This function performs three tasks, depending on [function code].
			Code: 1; validates calculation for save
			Code: 2; (validates) and performs calculation
			Code: 3; validates fixture and perfoms calculation			

 Arguments : Function code as integer

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-8-96		1			MI		Initial version  
************************************************************************************/

Boolean lb_result
Long ll_vest_type_id, ll_vessel_id, ll_clarkson_id
Datetime dt_tmp

// Set the default result to false, it will be set to true in the end
lb_result = false

// Return if accepttext fails.
If dw_calc_summary.Accepttext() <> 1 Then
	astr_parm.result.s_errortext = "Illegal value"
	Return(lb_result)
End if

// Check that we have got a description on the calculation, if not
// exit with an error
If dw_calc_summary.GetItemString(1,"cal_calc_description")="" Then
	astr_parm.result.s_errortext = "The calculation does not have a description"
	Goto Stop
End if

// ******************************************************************
// All checking for save should be performed before this 
// ******************************************************************
If astr_parm.i_function_code = 1 Then Return(True) // Exit if check for save


// Get vessel data for selected vessel, by calling uf_get_vessel_data,
// and store the data to our astr_parm, since it's needed for the 
// for the calculation
ll_vest_type_id = dw_calc_summary.GetItemNumber(1,"cal_vest_type_id")
ll_vessel_id = dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")
ll_clarkson_id = dw_calc_summary.GetItemNumber(1,"cal_clrk_id")

If iuo_calc_nvo.uf_get_vessel_data(ll_vest_type_id, ll_vessel_id, ll_clarkson_id) Then
	astr_parm.d_cap = iuo_calc_nvo.istr_calc_vessel_data.d_cap
	astr_parm.d_drc = iuo_calc_nvo.istr_calc_vessel_data.d_drc
	astr_parm.d_oa = iuo_calc_nvo.istr_calc_vessel_data.d_oa
	astr_parm.d_tc = iuo_calc_nvo.istr_calc_vessel_data.d_tc
	astr_parm.d_deadweight = iuo_calc_nvo.istr_calc_vessel_data.d_sdwt
	astr_parm.i_pc_nr = iuo_calc_nvo.istr_calc_vessel_data.i_pcnr
	astr_parm.d_budget_comm = iuo_calc_nvo.istr_calc_vessel_data.d_budgetcomm
Else
	astr_parm.result.s_errortext = "Vessel not defined"
	Goto Stop
End if

// Store data for revers sensitivity calculation, budget comm, drc, oa and tc hire 
istr_revers_sens.d_budget_comm = astr_parm.d_budget_comm
istr_revers_sens.d_drc = astr_parm.d_drc
istr_revers_sens.d_oa = astr_parm.d_oa
istr_revers_sens.d_tc_hire = astr_parm.d_tc

// If IB_NO_VESSELDATA_RELOAD is true, then override the CAP/DRC/OA and TC values
// with the values already stored in the calculation. This option is used in the
// recalc-window, when It wants to check if a calculation will give the same result
// with the old CAP/DRC/OA and TC values. If IB_NO_VESSELDATA_RELOAD is false, then
// update the fields in the calculation with the new values stored in astr_parm
If iuo_calc_nvo.iuo_calculation.ib_no_vesseldata_reload Then
	astr_parm.d_cap = dw_calc_summary.GetItemNumber(1, "cal_calc_cap")
	astr_parm.d_drc = dw_calc_summary.GetItemNumber(1, "cal_calc_drc")
	astr_parm.d_oa = dw_calc_summary.GetItemNumber(1, "cal_calc_oa")
	astr_parm.d_tc = dw_calc_summary.GetItemNumber(1, "cal_calc_tc")
Else
	dw_calc_summary.SetItem(1, "cal_calc_tc", astr_parm.d_tc)
	dw_calc_summary.SetItem(1, "cal_calc_cap", astr_parm.d_cap)
	dw_calc_summary.SetItem(1, "cal_calc_oa", astr_parm.d_oa)
	dw_calc_summary.SetItem(1, "cal_calc_drc", astr_parm.d_drc)
End if

// Check if APM vessel is defined for fixture (only APM vessels can be used for fixture)
If IsNull(dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")) And astr_parm.i_function_code > 2 Then
	astr_parm.result.s_errortext = "Vessel not defined (type and clarkson is not supported for fixture)"
	Goto Stop
End if

// Get various values from the calculation to the astr_parm structure.
If astr_parm.i_function_code >= 2 Then
//	astr_parm.i_no_cargos = dw_calc_summary_list.RowCount()
	astr_parm.s_ballast_from = dw_calc_summary.GetItemString(1,"cal_calc_ballast_from")
	astr_parm.s_ballast_to = dw_calc_summary.GetItemString(1,"cal_calc_ballast_to")
	astr_parm.d_fo_price = dw_calc_summary.GetItemNumber(1,"cal_calc_fo_price")
	astr_parm.d_do_price = dw_calc_summary.GetItemNumber(1,"cal_calc_do_price")
	astr_parm.d_mgo_price = dw_calc_summary.GetItemNumber(1,"cal_calc_mgo_price")
	astr_parm.d_lsfo_price = dw_calc_summary.GetItemNumber(1,"cal_calc_lsfo_price")
	astr_parm.i_ws_year = dw_calc_summary.GetItemNumber(1, "cal_calc_date_ws_scale")

	// Validate that ballast-ports is given if this is a ballast-voyage
	If astr_parm.b_ballastvoyage Then
		If IsNull(dw_calc_summary.GetItemString(1, "cal_calc_ballast_from")) Then
			astr_parm.result.s_errortext = "No ballast-from port specified"
			Goto Stop
		End if
	
		if IsNull(dw_calc_summary.GetItemString(1, "cal_calc_ballast_to")) Then
			astr_parm.result.s_errortext = "No ballast-to port specified"
			Goto Stop
		End if
	End if
End if

// ******************************************************************
// All checking for calculation should be performed before this 
// ******************************************************************
// Validate data for fixture; starting date should be defined, and
// after 1/1-1995, also ship type is checked (this code can probably be
// removed, since the vessel has been checked already).
If astr_parm.i_function_code = 3 Then 

	dt_tmp = dw_calc_summary.GetItemDateTime(1,"cal_calc_start_date")

	If IsNull(dt_tmp) Then
		astr_parm.result.s_errortext = "No starting date defined for calculation"
		Goto Stop	
	End if

	IF Year(Date(dt_tmp)) < 1995 THEN  
//	If DaysAfter(Date("1-1-1995"), Date(dt_tmp)) < 0 Then
		astr_parm.result.s_errortext = "Invalid starting date defined for calculation"
		Goto Stop
	End if

	// Check vesseltype, can probably be removed.
	If not iuo_calc_nvo.istr_calc_vessel_data.b_apmvessel Then
		astr_parm.result.s_errortext = "Fixtures can only be made on APM vessels"
		Goto Stop
	End if
End if

// We came through!!!! Set result to true
lb_result = true

Stop:

// And return result to calling procedure
Return(lb_result)
	
end function

public function long uf_insert ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MI
   
 Date       : 20-8-96

 Description : Inserts a new row in the summary - the main calculation, and sets up
 					default values etc.
 
 					Warning: only call this procedure once for each calculation,
					since the calculation system is build to only handle one
					calculation row pr. calculation

 Arguments : None

 Returns   : No#. of new row

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
Long ll_row

// Insert a ballast-from and ballast-to port in the CAL_BALL table.
ll_row = dw_calc_ballast.InsertRow(0)
dw_calc_ballast.SetItem(ll_row, "port_code", "") 
dw_calc_ballast.SetItem(ll_row, "cal_ball_distance_to_previous", 1)

ll_row = dw_calc_ballast.InsertRow(0)
dw_calc_ballast.SetItem(ll_row, "port_code", "") 
dw_calc_ballast.SetItem(ll_row, "cal_ball_distance_to_previous", 0)

// Insert the main calculation row
ll_row = dw_calc_summary.InsertRow(0)
dw_calc_summary.ScrollToRow(ll_row)

// Set up the default values
dw_calc_summary.SetItem(1, "cal_calc_status",2)
dw_calc_summary.SetItem(1,"cal_calc_created",DateTime(Today(),Now()))
dw_calc_summary.SetItem(1,"cal_calc_created_by",uo_global.is_userid)
dw_calc_summary.SetItem(1,"cal_calc_expiry_date",DateTime(RelativeDate(Today(),6*30)))
dw_calc_summary.SetItem(1,"cal_calc_description", "New calcule")
dw_calc_summary.SetItem(1,"cal_calc_date_ws_scale", Year(Today()))
dw_calc_summary.SetItem(1, "cal_calc_ballast_voyage", 0)
dw_calc_summary.SetItem(1, "use_atobviac_distance", 1) // default for alle new calculations after tramos version 14.00

// Set focus and field to this datawindow and return the rownumber 
dw_calc_summary.SetFocus()
dw_calc_summary.SetColumn("cal_calc_description")
Return(ll_row)
end function

public subroutine uf_set_firstlast_port (string as_start_port, string as_end_port);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the start and end port in the CAL_CALC table.

 Arguments : as_start_port, as_end_port as string

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Sets start and end port in calc_summary

dw_calc_summary.SetItem(1,"cal_calc_start_port",as_start_port)
dw_calc_summary.SetItem(1,"cal_calc_end_port",as_end_port)

end subroutine

public function long uf_get_fixture_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the fixture ID for this calculation, or 0 if it's not
 					fixtured.

 Arguments : None

 Returns   : Fixture ID as long  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_fix_id

ll_fix_id = dw_calc_summary.GetItemNumber(1, "cal_calc_fix_id") 
If IsNull(ll_fix_id) Then ll_fix_id = 0
Return(ll_fix_id)
end function

public function boolean uf_save (long al_estimated_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 

 Description : Saves the calculation stuff

 Arguments : estimated calc id as long (when saving a calculation)

 Returns   : true if OK  

*************************************************************************************
Development Log 
DATE			VERSION	NAME		DESCRIPTION
--------		-------	-----		-------------------------------------
26-03-13		CR2658	WWG004	Synchronize the TCE/Day and compute_tce. 
************************************************************************************/

Long ll_calc_id
Boolean lb_result

// Update the LAST_EDITED and LAST_EDITED_BY fields
dw_calc_summary.SetItem(1, "cal_calc_last_edited", DateTime(ToDay(),Now()))
dw_calc_summary.SetItem(1,"cal_calc_last_edited_by", uo_global.is_userid)

// and update the datawindow to the database. The AL_ESTIMATED_CALC_ID is
// copied to the IL_ESTIMATED_CALC_ID before, because the SQLPreview event
// (which is getting triggered by update) needs the IL_ESTIMATED_CALC_ID.
il_estimated_calc_id = al_estimated_calc_id
lb_result = dw_calc_summary.update(true, false) = 1

// If this is a new calculation then CAL_CALC_ID will be null, even though
// the record has been saved, because only the database knows the CAL_CALC_ID
// until next retrieve. Since the CAL_CALC_ID is needed by the rest of the
// calculation system, we'll retrieve the CAL_CALC_ID by calling UF_GET_CALC_ID().
// Update the CAL_BALL table with the CAL_CALC_ID, and update the CAL_BALL table
If lb_result Then
	If IsNull(dw_calc_ballast.GetItemNumber(1, "cal_calc_id")) Then
		ll_calc_id = uf_get_calc_id()
		dw_calc_ballast.SetItem(1, "cal_calc_id", ll_calc_id)
		dw_calc_ballast.SetItem(2, "cal_calc_id", ll_calc_id)
	End if

	lb_result = dw_calc_ballast.Update(true, false) = 1
End if			

dw_calc_summary.accepttext()
dw_calc_summary.setitem(1, "tce_day", dw_calc_summary.getitemnumber(1, "compute_tce"))

Return(lb_result)


end function

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 27-9-96

 Description : Deactivates the summary page, by calling accepttext on the summary
 					datawindow

 Arguments : 1 if everything is ok.

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_result

li_result = dw_calc_summary.accepttext()

Return(li_result)
end function

public function boolean uf_get_ballast_voyage ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Author    : MIS
   
 Date       : 7-10-96

 Description : Returns ballast voyage status:
 					(false=normal voyage, true = ballast voyage)

 Arguments : None

 Returns   : Boolean

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
Return(dw_calc_summary.GetItemNumber(1, "cal_calc_ballast_voyage")=1)

end function

public subroutine uf_set_ballast_voyage (boolean ab_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Sets or resets ballast-only field in CAL_CALC. 
 
 					NOTICE: This function can not be called alone, UF_SET_BALLAST_VOYAGE
					in the U_CALC_CARGOS also needs to be callad

 Arguments : ab_value as false (normal voyage) or true (ballast_voyage) 

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
Integer li_tmp

If ab_value Then li_tmp = 1 Else li_tmp = 0
dw_calc_summary.SetItem(1,"cal_calc_ballast_voyage", li_tmp)
end subroutine

public function long uf_total_distance ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 26-2-97

 Description : Returns total calculated distance 

 Arguments : None

 Returns   : Distance as long  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_distance

ll_distance= dw_calc_summary.GetItemNumber(1, "cal_calc_miles_ballasted") + &
	dw_calc_summary.GetItemNumber(1, "cal_calc_miles_loaded")

If IsNull(ll_distance) Then ll_distance = 0

Return (ll_distance)
end function

public subroutine uf_port_changed ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Tells the rest of the calculation system, that one or more ports
 					have changed

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

TriggerEvent("ue_childmodified")
Parent.TriggerEvent("ue_port_changed")
end subroutine

public subroutine uf_update_locked (integer ai_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the locked status for the DW_CALC_SUMMARY, depending on 
 					argument value (AI_VALUE).
					 
					Locked values:
					0 = No fields is locked
					1 = Partially locked - all fields except BALLAST_TO is locked
					2 = Fully locked
					
					The AI_VALUE is overriden for Fixture and Calculated calculations,
					these are always fully locked
					  
 Arguments : AI_VALUE as integer.

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_status, li_locked

li_status = dw_calc_summary.GetItemNumber(1, "cal_calc_status" )
If li_status = 4 or li_status = 6 Then 
	li_locked = 2 
Else 
	li_locked = ai_value
End if

dw_calc_summary.SetItem(1, "locked", li_locked)

end subroutine

public subroutine uf_unlock ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-5-97

 Description : Unlocks the calculation

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
5-5-97		4.05			MI		Initial version  
************************************************************************************/

dw_calc_summary.SetItem(1, "locked", 0)
end subroutine

public function long uf_get_calc_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the calculation ID

 Arguments : None

 Returns   : CALC ID as Long  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Long ll_calc_id
DateTime ld_tmp

// This routine is called upon saving a calculation for the first time. When the
// CAL_CALC table is saved the first time, we don't have the ID for the newly
// created record in the database - only the database has that. But we know the
// LAST_EDITED and LAST_EDITED_BY field values, and uses them to get the
// autoincrement ID number for our CAL_CALC record in the database.

//OLJ 2002-02-12 bug-fix: estimated and calculated calculations are stored with the same last_edited
//date but for some reason the estimated is sometimes stored before calculated calulation in the database
//(chronological order) this is why we have to sort the sql below be CAL_CALC_STATUS. We are then sure
//always to get the calculated calculation.

ld_tmp = dw_calc_summary.GetItemDateTime(1,"cal_calc_last_edited")

SELECT CAL_CALC.CAL_CALC_ID
INTO :ll_calc_id
FROM CAL_CALC
WHERE CAL_CALC.CAL_CALC_LAST_EDITED = :ld_tmp and
	CAL_CALC.CAL_CALC_LAST_EDITED_BY = :uo_global.is_userid
	ORDER BY CAL_CALC_STATUS ASC
USING SQLCA;

Return(ll_calc_id)
end function

public subroutine uf_activate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the activate by setting focus to the summary window,
 					and calling the ancestor

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE        CR-Ref      Author      DESCRIPTION
-----------------------------------------------------------------------------
27/01/15    CR3433      LHG008      Fix the bug for failed to add new load port feature from the compact window
29/01/15    CR3935      LHG008      Pre-select a default consumption type for Idle, Bunkering, Various
************************************************************************************/

dw_sidepanel.settransobject(sqlca)
//dw_sidepanel.insertrow(0)

iuo_calc_nvo.iuo_calc_cargos.uf_activate()

//Handle PB focus issue when all fields in a datawindow is locked
dw_loadports.setcolumn(dw_loadports.getcolumn())

dw_calc_summary.SetFocus()
Super::uf_activate()
end subroutine

public subroutine documentation ();/************************************************************************************

User Object: u_atobviac_calc_compact
====================================

Existing (archive) documentation can be found in the following folders:
	H:\CHGREQ\0051 Calc Comparison\Part02
	H:\TRAMOS.DEV\Documentation\Business Logic\Calculation\Calculation.doc

Notes:

AGL 16-2-10

Copied from user object uo_atobviac_calc_summary.
No additional functions added as these are controlled within the window object.
This is basically a collection of datawindows.  The contents critical in the process of
setting up the calculation.

Page index is 5.  This window should only be shown if status < 3 (1=Template, 2=Working)
	
*************************************************************************************

*************************************************************************************
Development Log 
DATE				VERSION		NAME			DESCRIPTION
--------			-------		-----			-------------------------------------
1.0								AGL			Initial version  
16-2-10							AGL			Added compact comparison functionaility
09-2-11							JSU			Multi Currency calculation
25-03-13			CR2658		WWG004		The TCE/Day can be changed and the Rate will be Recalculated.
26-11-13			CR2658UAT	WWG004		Move of_calc_rate to NVO u_atobviac_calc_rate
12-11-13			CR2658UAT   ZSW001		Fixed system error in calculation
21/01/15			CR3921		LHG008		Fix the bug when colunm locked but the backcolor is not changed
27/01/15			CR3433		LHG008		Fix the bug for failed to add new load port feature from the compact window
29/01/15			CR3935		LHG008		Pre-select a default consumption type for Idle, Bunkering, Various
15/04/15			CR3835		LHG008		Fix the usability issue of data displayed format and data transfer between normal view and compact view when the column loses focus
24/07/15			CR3226		XSZ004		Change label for Bunkers type.
30/10/15			CR3250		CCY018		Add LSFO fuel in calculation module.
30/12/15			CR3381		XSZ004		Remove vessel type message.
17/03/16			CR3146		KSH092		Change function uf_set_vessel, add icon button in dw_calc_summary
20/04/16       CR2428      SSX014      Change demurrage currency
01/07/16			CR4219		LHG008		Accuracy and improvement in DEM and DEV claims handling(CHO).
04/08/16			CR4216		CCY018		Add Additonal Bunker Consumption window
17/01/17			CR4050		LHG008		Change additionals Laden and Ballasted logic
23/03/17			CR4414		CCY018		Add voyage alert
22/08/17			CR4221		HHX010		Add interim port
************************************************************************************/
end subroutine

public subroutine uf_insert_port_row (ref u_datawindow_sqlca adw_port);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1996

 Description : Inserts a new port in the port-datawindow given in adw_port
					 
 Arguments : adw_port as datawindow
 
 Returns   : None

*************************************************************************************/

Long ll_Cargo_id,ll_cargo_row, ll_port_row
Double ld_null		
Integer li_null

// Turn redraw off
adw_port.uf_redraw_off()

// Get current cargo and current cargo ID.
ll_cargo_row = dw_cargo_summary.GetRow()
ll_cargo_id = dw_cargo_summary.GetItemNumber(ll_Cargo_row,"cal_carg_id")

// If the cargo ID is fake (negative) meaning that the cargo hasn't been saved yet,
// then set the cargo ID to MINUS Cargo row number. This will be the reference until
// the calculation is saved.
If (ll_cargo_id = 0) or Isnull(ll_cargo_id) Then ll_cargo_id = -ll_cargo_row

// Insert the new portrow, and scroll to it.
ll_port_row = adw_port.InsertRow(0)
adw_port.ScrollToRow(ll_port_row)

// Update the cargo ID link
adw_port.SetItem(ll_port_row,"cal_carg_id",ll_cargo_id)

// Update itinerary number, portcode, loadterms and set the purpose code to 
// L for loadports and D for dischports
il_itinerary_max ++
adw_port.SetItem(ll_port_row,"cal_caio_itinerary_number", il_itinerary_max)  // Skal rettes til itinerary number
adw_port.SetItem(ll_port_row,"port_code","          ")
adw_port.SetItem(ll_port_row,"cal_caio_load_terms", 0)
If adw_port = dw_loadports then adw_port.SetItem(ll_port_row,"purpose_code","L") else adw_port.SetItem(ll_port_row,"purpose_code","D")

// Find the min CAL_RATY_ID - this is the default Ratetype.
Long ll_tmp

SELECT MIN(CAL_RATY_ID)
INTO :ll_tmp
FROM CAL_RATY;
COMMIT;

adw_port.SetItem(ll_port_row,"cal_raty_id",ll_tmp)


adw_port.SetColumn("port_code")	

adw_port.ScrollToRow(ll_port_row)

// Tell the calculation system, that one or more ports has changed
uf_port_changed()

// and turn redraw back on
adw_port.uf_redraw_on()
end subroutine

public function integer uf_get_cargoxxx ();//Returns current cargo

Return(iuo_calc_nvo.iuo_calc_cargos.ii_current_cargo)
end function

public function boolean uf_delete_misc_exp (long al_caio_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS + TA
   
 Date       : 20/5-97

 Description : Deletes all misc. expenses connected to a given caio_id

 Arguments : al_caio_id as long

 Returns   : true if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count, li_max


// Check that CAIO ID is valid
If IsNull(al_caio_id) Or (al_caio_id) = 0 then Return false

// Set filter on this CAIO_ID on the expenses window, so we only have
// expenses connected to this CAIO
dw_calc_port_expenses.SetFilter("cal_caio_id = "+String(al_caio_id))
dw_calc_port_expenses.Filter()

// Delete all entries in the expenses datawindow
li_max = dw_calc_port_expenses.Rowcount()
For li_count = li_max To 1 Step -1
	Dw_calc_port_expenses.deleteRow(li_count)				
Next

// And set the filter again
dw_calc_port_expenses.SetFilter("")
dw_calc_port_expenses.Filter()

Return true
end function

public subroutine uf_insert_port ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1996

 Description : Inserts a new port into the datawindow (load or disch) that currently
 					has the focus.
					 
 Arguments : None
 
 Returns   : None

*************************************************************************************/

// Set lo_tmp to point to the control that currently has focus
GraphicObject lo_tmp
lo_tmp = GetFocus()

// and call insert for load or dischport, depending which on that got the focus.
If Not isNull(lo_tmp) Then
	If lo_tmp.TypeOf() = DataWindow! Then

		If lo_tmp.ClassName() = "dw_loadports" Then
			uf_insert_port_row(dw_loadports)
		Elseif lo_tmp.Classname() = "dw_dischports" Then
			uf_insert_port_row(dw_dischports)
		End if
	End if
End if
end subroutine

public function integer of_getdatawindowfocus (ref u_datawindow_sqlca adw, ref string as_name);/********************************************************************
   of_getdatawindowfocus()
<DESC>   
	Used to obtain current datawindow that user has access to. 
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	Before calling of_insert..() of_delete..() functions.  A copy of this
	function resides in the u_atobviac_calc_cargo object.
</USAGE>
********************************************************************/


graphicobject lgo_tmp

setnull(adw)
/* validate current object is a datawindow */
lgo_tmp = getfocus()
if not isnull(lgo_tmp) then
	if lgo_tmp.typeof() = DataWindow! then
		adw = lgo_tmp
		as_name = lgo_tmp.classname()
	else
		return c#return.NoAction
	end if
end if

return c#return.Success
end function

public subroutine uf_check_cqd (u_datawindow_sqlca adw_datawindow);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : This function checks if the Ratetype is CQD. If this is the case,
 	it sets calculated rate, despatch and demurrage to 0.

 Arguments : dw_Loadports or dw_dishcports in adw_datawindow

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row
ll_row = adw_datawindow.GetRow()

// Check to see if CQD has been selected. Use lookup rather than the CAL_RATY_ID value,
// since we don't know what ID the CQD entry will have.
If Upper(adw_datawindow.Describe("Evaluate('LookUpDisplay(cal_raty_id) ', " + String(ll_row) + ")")) = "CQD" Then
	
	// Ok, CQD have been selected, clear dependant fields

	adw_datawindow.SetItem(ll_row, "cal_caio_rate_calculated", 0)
	adw_datawindow.SetItem(ll_row, "cal_caio_despatch", 0)
	adw_datawindow.SetItem(ll_row, "cal_caio_demurrage", 0)
end if

end subroutine

public function string uf_loaddisch_itemchanged (ref u_datawindow_sqlca adw_datawindow, ref u_dddw_search luo_dddw_search);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 4-8-96

 Description : This procedure does all processing needed for itemchanged events on
 					Load and disch ports. 
					 
					It checks the columnname for updated datawindow (either load or disch), 
 					and copies modifications to other load/disch datawindows if reversible
      			is on.

					IMPORTANT: This rutine can be optimized, by not calling uf_reversible 
					(which is actually quite slow, because it shifts between all the cargos), 
					but coping data field to other datafields of the same type within the datawindow.

 Arguments : adw_datawindow as current Datawindow, luo_dddw_search as the searchobject
 				 for fields (eg. portslist) that uses the searchobject

 Returns   : The columnname for the changed field.

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
4-8-96               MI       Initial version  
01/07/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO).
************************************************************************************/

Double ld_total_mts, ld_value, ld_tmp
Double ld_demurrage, ld_despatch, ld_unit_expens
String ls_column, ls_tmp
Long ll_row, ll_value, ll_cargo_row, ll_cerp_id, ll_loadterms, ll_raty_id, ll_units
Integer li_count, li_set_field, li_column, li_row, li_caio_count, li_caio_max
Boolean lb_found

SetNull(ll_value)
SetNull(ld_value)

// Get current load/disch row, cargo row, and columnname
ll_row = adw_datawindow.GetRow()
ll_cargo_row = dw_cargo_summary.GetRow()
ls_column =  adw_datawindow.GetColumnName()

// Do specific actions depending on which field has been changed.
CHOOSE CASE ls_column
	CASE "cal_caio_expenses","cal_caio_misc_expenses","cal_caio_load_unit_expenses", "cal_caio_number_of_units"
		// One of the expenses fields has been changed. Calculated the new
		// total port expenses and store the result back to the database
		
		adw_datawindow.SetItem(ll_row, ls_column, Double(adw_datawindow.GetText()))

		If adw_datawindow = dw_loadports Then
			ld_total_mts = adw_datawindow.GetItemNumber(ll_row,"total_units")
			dw_cargo_summary.SetItem(dw_cargo_summary.GetRow(),"cal_carg_cal_carg_total_units",ld_total_mts)
		End if

		// Get quantity in port and multiply with unit expense and add to total expenses
		ll_units = adw_datawindow.GetitemNumber(ll_row,"cal_caio_number_of_units")
		If ll_units < 0 then ll_units = -ll_units
		ld_unit_expens = adw_datawindow.GetitemNumber(ll_row,"cal_caio_load_unit_expenses")
		ld_tmp += ll_units * ld_unit_expens

		ld_tmp = ld_tmp + adw_datawindow.GetItemNumber(ll_row, "cal_caio_expenses")

		adw_datawindow.SetItem(ll_row, "cal_caio_total_port_expenses", ld_tmp)			

		Return(ls_column)
	CASE "cal_raty_id"
		// Rate type has been changed. Post a UE_CHECK_CQD event, it will reset 
		// nessesary fields, if the user selected CQD
		adw_datawindow.PostEvent("ue_check_cqd")
	CASE "port_code"
		// Port has been changed, so we'll reset the viapoints and via expenses
		// for this port, and call on to the search-objects's itemchanged event, that
		// will handle furher processing for this field. 
		SetNull(ls_tmp)

		For li_count = 1 To 3 
			adw_datawindow.SetItem(ll_row, "cal_caio_via_point_"+String(li_count), ls_tmp)
			adw_datawindow.SetItem(ll_row, "cal_caio_via_expenses_"+String(li_count),0)
		Next

		luo_dddw_search.uf_itemchanged()

		// Finally tell the rest of the calculation system, that one of the ports have
		// been changed.
		
		Parent.PostEvent("ue_calc_changed")
		
		uf_port_changed()
	CASE "purpose_code"
		// The purposecode has been changed. Depending on the new status, and the
		// reversible status, we might need to copy information to some of the
		// fields, eg. If the user selected load, and the cargo is reversible, we
		// have to copy the estimated, calculated, despatch, demurrage etc. fields
		// to this port. If someting else than L or D was selected, we'll clear
		// the same fields instead.
		
		// Get the purposecode from the datawindow
		ls_tmp = adw_datawindow.Gettext()

		If (ls_tmp = "L")  Then 
			// Ok, it's a Load. Loop through all cargoes and check if any of the cargoes is
			// reversible with this cargo OR our own cargo, whatever we find first.

			uf_redraw_off()

			// Use the C/P ID as link between reversible cargos within the same CP.
			ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_cargo_row, "cal_carg_cal_cerp_id") 
			// If C/P is given, and the cargo has been set to reversible, then do the loop
			If Not (IsNull(ll_cerp_id)) And (dw_cargo_summary.getItemNumber(ll_cargo_row, "cal_carg_cal_carg_reversible")=1) Then
				
				For li_count = 1 To ii_no_cargos
					If dw_cargo_summary.GetItemNumber(li_count, "cal_carg_cal_cerp_id") = ll_cerp_id Then
						// Ok, this cargo (li_count) is reversible with our cargo. Select the cargo
						// and loop through the ports to find a "Load" port, that is not the same as
						// our own row (we won't get anything out of copying from our own row).
						
						uf_select_cargo(li_count)

						li_caio_max = dw_loadports.RowCount()
						For li_caio_count = 1 To li_caio_max
							If (Not ( (li_count=ll_cargo_row) And (li_caio_count = ll_row) ) ) And (dw_loadports.GetItemString(li_caio_count, "purpose_code")="L") Then
								// Ok, it's not our own row, and it's a "Load", now get the field values,
								// and break the loop
								
								ld_demurrage = dw_loadports.getItemNumber(li_caio_count, "cal_caio_demurrage")
								ld_despatch = dw_loadports.getItemNumber(li_caio_count, "cal_caio_despatch")
								ll_raty_id = dw_loadports.getItemNumber(li_caio_count, "cal_raty_id")
								ll_loadterms = dw_loadports.getItemNumber(li_caio_count, "cal_caio_load_terms")

								lb_found = true											
							End if

							If lb_found Then Exit
						Next
					End if
					
					If lb_found Then Exit
				Next
			End if

			// Loop is done, select our own cargo row
			uf_select_cargo(ll_cargo_row)
			dw_loadports.ScrollToRow(ll_row)

			// and store the reversible-dependant fields we just got from another 
			// cargo or row.
			
			adw_datawindow.SetItem(ll_row, "cal_caio_demurrage", ld_demurrage)
			adw_datawindow.SetItem(ll_row, "cal_caio_despatch", ld_despatch)

			If ll_raty_id <> 0 Then adw_datawindow.SetItem(ll_row, "cal_raty_id", ll_raty_id)
			adw_datawindow.SetItem(ll_row, "cal_caio_load_terms", ll_loadterms)

			uf_redraw_on()
		Elseif (ls_tmp <> "D") Then
			// Ok, it was not a load, and not a disch either. Clear the 
			// reversible-dependant fields to 0, except for Ratetype that
			// should be set to 1.
			adw_datawindow.SetItem(ll_row,"cal_caio_number_of_units",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_demurrage",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_despatch",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_noticetime",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_load_terms",0)
			adw_datawindow.SetItem(ll_row,"cal_raty_id",1)
		End if
		
		adw_datawindow.setitem(ll_row, "cal_caio_rate_estimated", 0)
		adw_datawindow.setitem(ll_row, "cal_caio_rate_calculated", 0)
		
END CHOOSE

// return the columnname
Return(ls_column)

end function

public subroutine of_init_data ();/********************************************************************
   of_init_data
   <OBJECT>	Init the data when the campact window is displayed.</OBJECT>
   <USAGE> When click the "<"	will call this.		</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	21/03/2013	CR2658		WWG004		First Version
	22/08/2017	CR4221		HHX010		Set ii_current_cargo 		
   </HISTORY>
********************************************************************/

dw_calc_summary.setitem(1, "tce_day", dw_calc_summary.getitemnumber(1, "compute_tce"))
ii_current_cargo = uf_get_cargoxxx()
_settcestatus()
end subroutine

private function integer _getsettledclaimcounts (ref integer ai_settledfreight, ref integer ai_settledother);/********************************************************************
   u_atobviac_calc_compact
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	26/03/2013	CR2658		WWG004		Get the settled claims.
   </HISTORY>
********************************************************************/

long				ll_row, ll_claimcount
mt_n_datastore	lds_claimdata

if iuo_calc_nvo.iuo_calculation.of_getestcalcid() = 0 then 
	return 1
else
	lds_claimdata = create mt_n_datastore
	lds_claimdata.dataObject = "d_sq_tb_check_claimbalance"
	lds_claimdata.setTransObject(sqlca)
	
	ll_claimcount = lds_claimdata.retrieve(iuo_calc_nvo.iuo_calculation.of_getcheckvesselnr(), iuo_calc_nvo.iuo_calculation.of_getcheckvoyagenr())
	
	/* check claim amounts */
	for ll_row = 1 to ll_claimcount
		if abs(lds_claimdata.getitemnumber(ll_row, "claim_amount") - lds_claimdata.getItemNumber(ll_row, "transactions")) < 1 then
			if (lds_claimdata.getitemnumber(ll_row, "freight_received") + lds_claimdata.getItemNumber(ll_row, "trans_received")) > 0 then
				if lds_claimdata.getitemstring(ll_row, "claim_type") = "FRT" then
					ai_settledfreight ++
					exit
				else
					ai_settledother ++
					exit
				end if
			end if
		end if
	next	
	destroy lds_claimdata
end if

return c#return.Success
end function

public subroutine _settcestatus ();/********************************************************************
   u_atobviac_calc_compact
   <OBJECT>		Init the TCE/Day field status.	</OBJECT>
   <USAGE>		When user click the '<' will call this. </USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	26/03/2013	CR2658		WWG004		First Version
   	21/01/15		CR3921		LHG008		Fix the bug when colunm locked but the backcolor is not changed
   </HISTORY>
********************************************************************/

integer	li_settledfreight, li_settledother
integer	li_status

IF uo_global.ii_access_level = -1 THEN 
	dw_calc_summary.Object.Datawindow.ReadOnly	= "Yes"
	dw_cargo_summary.Object.Datawindow.ReadOnly	= "Yes"
	dw_loadports.Object.Datawindow.ReadOnly		= "Yes"
	dw_dischports.Object.Datawindow.ReadOnly		= "Yes"
END IF

if dw_calc_summary.rowcount() > 0 then
	li_status = dw_calc_summary.getitemnumber(1, "cal_calc_status")
end if

choose case li_status
	case 4	//Fixtured
		dw_calc_summary.settaborder("tce_day", 0)
		dw_calc_summary.modify("tce_day.background.color = " + string(c#color.MT_FORMDETAIL_BG))
	case 1, 2, 7	//Template, Working, LoadLoad
		dw_calc_summary.settaborder("tce_day", 10)
		dw_calc_summary.modify("tce_day.background.color = " + string(c#color.MT_FORMFILED_BG))
	case 5, 6	//Calculated, Estimated
		if _getsettledclaimcounts(li_settledfreight, li_settledother) = c#return.Success then
			if li_settledfreight + li_settledother > 0 then
				dw_calc_summary.settaborder("tce_day", 0)
				dw_calc_summary.modify("tce_day.background.color = " + string(c#color.MT_FORMDETAIL_BG))
			end if
		end if
end choose

end subroutine

public function boolean of_change_tce ();/********************************************************************
   of_change_tce
   <OBJECT>		Recalc the Rate.	</OBJECT>
   <USAGE>		When changing the TCE/Day, this function will be called.</USAGE>
   <ALSO>		Calculate rate will call of_recalc_rate			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	25/03/2013	CR2658		WWG004		First Version
		26/11/2013	CR2658UAT	WWG004		Move of_calc_rate to NVO
		10/12/2013  CR2658UAT   ZSW001      Fixed system error in calculation
		27/03/2015  CR3935      LHG008      Fixed system error
   </HISTORY>
********************************************************************/

double	ld_tceday, ld_tcemonth, ld_rate, ld_exrate_usd, ld_bunker_esc, ld_tceday_orig
integer	li_ratetype
long		ll_calcid

CONSTANT integer li_LOAD_PARM = 0
CONSTANT integer li_RELVERSECAL = 1

u_atobviac_calculation	luo_calculation
s_calculation_parm		lstr_calc_parm
s_calc_sensitivity		lstr_calc_sensitivity
u_atobviac_calc_rate		luo_calc_rate
powerobject					lop_parent

w_atobviac_calc_calculation	lw_parent

lop_parent = this
do 
	lop_parent = lop_parent.getparent()
loop while lop_parent.typeof() <> window!

if lop_parent.classname() <> "w_atobviac_calc_calculation" then return false

lw_parent = lop_parent

luo_calculation	= lw_parent.uo_calculation

luo_calc_rate = create u_atobviac_calc_rate

dw_calc_summary.accepttext()
luo_calculation.uo_calc_cargos.dw_cargo_summary.accepttext()

dw_loadports.accepttext()
dw_dischports.accepttext()

//Get T/C day and T/C month value
ld_tceday_orig = dw_calc_summary.getitemnumber(1, "compute_tce")
ld_tceday	= dw_calc_summary.getitemnumber(1, "tce_day")
ld_tcemonth	= ld_tceday * c#decimal.AvgMonthDays

//Get parameters for calculation Copy from w_atobviac_calc_sensitivity
if luo_calculation.uf_sensitivity(li_LOAD_PARM, {1}, lstr_calc_sensitivity, '', 0, lstr_calc_parm) = false then return false
if luo_calculation.uf_sensitivity(li_RELVERSECAL, {1}, lstr_calc_sensitivity, '', 0, lstr_calc_parm) = false then return false

if upperbound(lstr_calc_parm.cargolist) = 0 then return false

CHOOSE CASE lstr_calc_parm.cargolist[1].i_rate_type
	CASE 1,2	//Per mt & Per cbm
		setnull(lstr_calc_parm.cargolist[1].d_lumpsum)
		setnull(lstr_calc_parm.cargolist[1].d_wsrate)
		setnull(lstr_calc_parm.cargolist[1].d_flatrate)
	CASE 3	//Lumpsum
		setnull(lstr_calc_parm.cargolist[1].d_wsrate)
		setnull(lstr_calc_parm.cargolist[1].d_flatrate)
		setnull(lstr_calc_parm.cargolist[1].d_unitrate)
	CASE 4	//WS
		setnull(lstr_calc_parm.cargolist[1].d_lumpsum)
		setnull(lstr_calc_parm.cargolist[1].d_unitrate)
END CHOOSE

//Calculate the rate that goes with a specific TC eqv. 
ld_rate = luo_calc_rate.of_calc_rate(lstr_calc_parm, ld_tcemonth, {1})

ld_exrate_usd		= luo_calculation.uo_calc_cargos.dw_cargo_summary.getitemnumber(1, "cal_carg_cal_carg_exrate_usd")
ld_bunker_esc		= luo_calculation.uo_calc_cargos.dw_cargo_summary.getitemnumber(1, "cal_carg_bunker_escalation_local_curr")

//Get rate type
li_ratetype	= dw_cargo_summary.getitemnumber(1, "cal_carg_freight_type")

//Set the new Rate to datawindow.
choose case li_ratetype
	case 1		//Per MT
		dw_cargo_summary.setitem(1, "cal_carg_freight_rate_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_freight_rate_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_freight_rate", ld_rate * ld_exrate_usd / 100)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "bunker_escalation", ld_bunker_esc *  ld_exrate_usd / 100)
	case 2		//Per Cbm	
		dw_cargo_summary.setitem(1, "cal_carg_freight_rate_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_freight_rate_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_freight_rate", ld_rate *  ld_exrate_usd / 100)
	case 3		//Lumpsum
		dw_cargo_summary.setitem(1, "cal_carg_lumpsum_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_lumpsum_local_curr", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_lumpsum", ld_rate * ld_exrate_usd / 100)
	case 4		//WS
		dw_cargo_summary.setitem(1, "cal_carg_ws_rate", ld_rate)
		luo_calculation.uo_calc_cargos.dw_cargo_summary.setitem(1, "cal_carg_ws_rate", ld_rate)
end choose

dw_cargo_summary.accepttext()
luo_calculation.uo_calc_cargos.dw_cargo_summary.accepttext()

if not luo_calculation.uf_calculate() then
	ll_calcid = dw_calc_summary.getitemnumber(1, "cal_calc_id")
	dw_calc_summary.reset()
	luo_calculation.uf_retrieve(ll_calcid)
	dw_calc_summary.setitem(1, "tce_day", ld_tceday_orig)
	return false
else
//	Fill the calculated data.
	of_init_data()
end if

return true
end function

protected subroutine of_show_voyage_alert (string as_port_code, integer ai_xpos, integer ai_ypos);/********************************************************************
   of_show_voyage_alert
   <DESC>	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
		as_port_code
		ai_xpos
		ai_ypos
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowheight, ll_dwheight, ll_maxheight
long ll_xpos, ll_ypos, ll_tabheight, ll_boxh

ll_xpos = dw_sidepanel.x
ll_ypos = ai_ypos

dw_voyage_alert.reset()
if dw_voyage_alert.retrieve(as_port_code) < 1 then 
	dw_voyage_alert.visible = false
	return
end if

ll_dwheight = 84
ll_tabheight = dw_sidepanel.height
for ll_row = 1 to dw_voyage_alert.rowcount()
	ll_rowheight = long(dw_voyage_alert.describe("evaluate('rowheight()', " + string(ll_row) + " )"))
	if ll_dwheight + ll_rowheight < ll_tabheight then
		if ll_row <= 4 then ll_dwheight += ll_rowheight
	end if
	
	if ll_rowheight > ll_maxheight then ll_maxheight = ll_rowheight
next

if ll_maxheight > ll_dwheight then ll_dwheight = ll_maxheight
if ll_dwheight > ll_tabheight then ll_dwheight = ll_tabheight
dw_voyage_alert.height = ll_dwheight

ll_boxh = dw_voyage_alert.height

if ll_ypos + ll_boxh > ll_tabheight then ll_ypos = ll_ypos - ll_boxh
if ll_ypos < 0 then ll_ypos = 0

dw_voyage_alert.x = ll_xpos
dw_voyage_alert.y = ll_ypos
dw_voyage_alert.width = 914
dw_voyage_alert.visible = true

dw_voyage_alert.setfocus()

end subroutine

public function integer of_restore_data (ref u_datawindow_sqlca adw_datawindow, integer row);string ls_find
long ll_find
if adw_datawindow = dw_loadports then
	ls_find = "purpose_code ='L' and cal_caio_interim_port = 0 and getrow()<> " + string(row)
else
	ls_find = "purpose_code ='D' and cal_caio_interim_port = 0 and getrow()<>  " + string(row)
end if

ll_find = adw_datawindow.find(ls_find, 1, adw_datawindow.rowcount())
if ll_find > 0 then 
	adw_datawindow.setitem(row, COLUMN_DESPATCH_DEM_CURR, adw_datawindow.getitemnumber(ll_find, COLUMN_DESPATCH_DEM_CURR))
	adw_datawindow.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, adw_datawindow.getitemnumber(ll_find, COLUMN_DESPATCH_LOCAL_CURR))
	adw_datawindow.setitem(row, COLUMN_DESPATCH_USD, adw_datawindow.getitemnumber(ll_find, COLUMN_DESPATCH_USD))
	
	adw_datawindow.setitem(row, COLUMN_DEMURRAGE_DEM_CURR, adw_datawindow.getitemnumber(ll_find, COLUMN_DEMURRAGE_DEM_CURR))
	adw_datawindow.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, adw_datawindow.getitemnumber(ll_find, COLUMN_DEMURRAGE_LOCAL_CURR))
	adw_datawindow.setitem(row, COLUMN_DEMURRAGE_USD, adw_datawindow.getitemnumber(ll_find, COLUMN_DEMURRAGE_USD))
end if

return 1
end function

public function boolean of_isallowed_interim (datawindow adw_cargo, long al_row, string as_data, string as_purpose_code);
long ll_count, ll_i, ll_rowcount
integer li_calcaio_portcode

if as_data = '0' then return true

ll_rowcount = adw_cargo.rowcount()
if  adw_cargo.rowcount() <=1 then return False
ll_count = 0 
for ll_i = 1 to ll_rowcount 
	if ll_i = al_row then continue
	if adw_cargo.object.purpose_code[ll_i] = as_purpose_code then
		if adw_cargo.object.cal_caio_interim_port[ll_i] = 0 then ll_count ++
	else
		continue
	end if
	if ll_count = 1 then exit
next

if ll_count = 1 then 
	return True
else
	return false
end if
end function

public function integer of_check_interimport_change (datawindow ad_datawindow, long al_row, string as_data);/********************************************************************
  of_check_interimport_change
   <DESC> check laytime where port is a intrim port </DESC>
   <RETURN>		integer:
            <LI> c#return.Success, 1
            <LI> c#return.Failure, -1	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/08/17		CR4221	HHX010	Interim Port
   </HISTORY>
********************************************************************/
long ll_cal_calc_id, ll_chart_nr, ll_count, ll_vessel_nr, ll_i
string ls_voyage_nr, ls_text
string ls_tab[]
integer li_status
mt_n_datastore lds_claims

//if as_data = string(ad_datawindow.getitemnumber(al_row, 'CAL_CAIO_INTERIM_PORT',Primary!, true))  then  return c#return.Success 

//get the current cal_calc_id
ll_cal_calc_id = dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_calc_id")
if isnull(ll_cal_calc_id) then return c#return.Success
ll_chart_nr = dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_cerp_chart_nr")

li_status =iuo_calc_nvo.iuo_calc_summary.uf_get_status( )
if li_status <> 6 then
	SELECT CAL_CALC_ID INTO :ll_cal_calc_id 
	FROM CAL_CALC
	WHERE CAL_CALC_STATUS = 6 
	AND  CAL_CALC_FIX_ID IN ( SELECT CAL_CALC_FIX_ID FROM CAL_CALC WHERE CAL_CALC_ID = :ll_cal_calc_id );
	if isnull(ll_cal_calc_id) then return c#return.Success
end if

select VOYAGE_NR , VESSEL_NR into :ls_voyage_nr , :ll_vessel_nr
from VOYAGES
where CAL_CALC_ID = :ll_cal_calc_id;
if isnull(ls_voyage_nr)  then ls_voyage_nr =''

if trim(ls_voyage_nr) > ''  then
	lds_claims = create mt_n_datastore
	lds_claims.dataobject ='d_sq_gr_check_interimport'
	lds_claims.settransobject(sqlca)
	ll_count = lds_claims.retrieve(ll_vessel_nr, ls_voyage_nr, ll_chart_nr)
	if ll_count >= 1 then
		for ll_i =1 to ll_count
			ls_text ="~r~n" 
			ls_text += lds_claims.object.voyage_nr[ll_i] +" - "
			ls_text += lds_claims.object.claim_type[ll_i] +" - "
			ls_text += string(lds_claims.object.claim_nr[ll_i])
			ls_tab[1] =ls_tab[1] + ls_text
		next 
		
		ls_text = 'The following created Claim(s) might be affected by changing this interim port configuration. The Claim(s) might need to be amended. Please notify the Claims Analyst.~r~n'  + ls_tab[1] + "~r~n~r~nDo you want to continue?"
		if messagebox('Warning', ls_text, Exclamation!, YesNo!, 1) = 2 then
			return c#return.Failure
		end if	
	end if
end if

if isvalid(lds_claims) then destroy lds_claims
return c#return.Success
end function

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes the u_calc_summary window

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION	NAME		DESCRIPTION
--------		-------	-----		-------------------------------------
26-03-13		CR2658	WWG004	The TCE/Day field changed to be editable.  
************************************************************************************/
// Create the drop-down search-as-you-type object to the 
// ballast from and ballast to fields

iuo_dddw_search_load = CREATE u_dddw_search
iuo_dddw_search_load.uf_setup(dw_loadports, "port_code", "port_n",true)
iuo_dddw_search_disch = CREATE u_dddw_search
iuo_dddw_search_disch.uf_setup(dw_dischports, "port_code", "port_n",true)

iuo_dddw_search_from = CREATE u_dddw_search
iuo_dddw_search_from.uf_setup(dw_calc_summary, "cal_calc_ballast_from", "port_n", true)
iuo_dddw_search_to = CREATE u_dddw_search
iuo_dddw_search_to.uf_setup(dw_calc_summary, "cal_calc_ballast_to", "port_n", true)

/* setup datawindow formatter service */
n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_registercolumn( "port_code", true)
lnv_style.of_registercolumn( "cal_caio_number_of_units", true)
lnv_style.of_registercolumn( "cal_caio_load_terms", true)
lnv_style.of_registercolumn( "cal_raty_id", true)
lnv_style.of_dwformformater( dw_dischports )
lnv_style.of_registercolumn( "port_code", true)
lnv_style.of_registercolumn( "cal_caio_number_of_units", true)
lnv_style.of_registercolumn( "cal_caio_load_terms", true)
lnv_style.of_registercolumn( "cal_raty_id", true)
lnv_style.of_dwformformater( dw_loadports )
lnv_style.of_registercolumn( "cal_carg_freight_type", true)
lnv_style.of_registercolumn( "cal_carg_lumpsum", true)
lnv_style.of_registercolumn( "cal_carg_ws_rate", true)
lnv_style.of_registercolumn( "cal_carg_freight_rate", true)
lnv_style.of_registercolumn( "cal_carg_flatrate", true)
lnv_style.of_registercolumn( "cal_carg_cal_carg_curr_code", true)
lnv_style.of_registercolumn( "cal_carg_cal_carg_exrate_usd", true)
lnv_style.of_registercolumn( "cal_carg_freight_rate_local_curr", true)
lnv_style.of_registercolumn( "cal_carg_lumpsum_local_curr", true)
lnv_style.of_dwformformater( dw_cargo_summary )
lnv_style.of_dwformformater( dw_calc_summary )

end event

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Destroys the u_calc_summary window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Destroy the search-as-you-type objects for the ballast-from and ballast-to fields

DESTROY iuo_dddw_search_from
DESTROY iuo_dddw_search_to

DESTROY iuo_dddw_search_load
DESTROY iuo_dddw_search_disch
end event

on u_atobviac_calc_compact.create
int iCurrent
call super::create
this.dw_addbuncons=create dw_addbuncons
this.dw_calc_port_expenses=create dw_calc_port_expenses
this.dw_dischports=create dw_dischports
this.dw_loadports=create dw_loadports
this.dw_calc_ballast=create dw_calc_ballast
this.dw_sidepanel=create dw_sidepanel
this.dw_cargo_summary=create dw_cargo_summary
this.dw_calc_summary=create dw_calc_summary
this.dw_voyage_alert=create dw_voyage_alert
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_addbuncons
this.Control[iCurrent+2]=this.dw_calc_port_expenses
this.Control[iCurrent+3]=this.dw_dischports
this.Control[iCurrent+4]=this.dw_loadports
this.Control[iCurrent+5]=this.dw_calc_ballast
this.Control[iCurrent+6]=this.dw_sidepanel
this.Control[iCurrent+7]=this.dw_cargo_summary
this.Control[iCurrent+8]=this.dw_calc_summary
this.Control[iCurrent+9]=this.dw_voyage_alert
end on

on u_atobviac_calc_compact.destroy
call super::destroy
destroy(this.dw_addbuncons)
destroy(this.dw_calc_port_expenses)
destroy(this.dw_dischports)
destroy(this.dw_loadports)
destroy(this.dw_calc_ballast)
destroy(this.dw_sidepanel)
destroy(this.dw_cargo_summary)
destroy(this.dw_calc_summary)
destroy(this.dw_voyage_alert)
end on

event rbuttondown;call super::rbuttondown;parent.dynamic event ue_rightclick("uo_atobviac_compact")

	
end event

type dw_addbuncons from u_datawindow_sqlca within u_atobviac_calc_compact
boolean visible = false
integer x = 1170
integer y = 1024
integer width = 183
integer height = 144
integer taborder = 60
string dataobject = "d_sq_gr_cal_addbuncons"
end type

type dw_calc_port_expenses from u_datawindow_sqlca within u_atobviac_calc_compact
boolean visible = false
integer x = 955
integer y = 764
integer width = 933
integer height = 176
integer taborder = 50
string dataobject = "d_calc_port_expenses"
end type

event sqlpreview;call super::sqlpreview;//uf_change_sql(4,dw_calc_port_expenses,sqlsyntax)
end event

type dw_dischports from u_datawindow_sqlca within u_atobviac_calc_compact
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
integer x = 133
integer y = 1760
integer width = 763
integer height = 520
integer taborder = 60
string dragicon = "AppIcon!"
string dataobject = "d_ex_tb_calc_cpact_cargo_out"
boolean vscrollbar = true
boolean border = false
boolean ib_autoaccept = true
end type

event ue_keydown;call super::ue_keydown;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Move cursor to loadports if the current row is the uppermost one

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
If KeyDown(KeyUpArrow!) And This.GetRow() = 1 Then
	dw_loadports.SetFocus()
	dw_loadports.SetColumn(dw_dischports.GetColumnName())
End if
end event

event ue_check_cqd;call super::ue_check_cqd;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls uf_check_cqd to see if cqd has been choosen in the rate terms
				  window

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
uf_check_cqd(dw_dischports)
end event

event clicked;call super::clicked;/****************************************************************************
Author		: MI
Date			: May 1997
Description	: If the button on the window is clicked the misc. port expenses
				  window is opened.

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-5-97	1.0		TA		Initial version
****************************************************************************/

// Set local variables
String ls_object, ls_row_no
long ll_found, ll_row_no, ll_position_no, ll_current_cargo
s_misc_expenses ls_misc_expenses

// Get the object at the point clicked
ls_object = dw_dischports.GetObjectAtPointer()

// Find the button and the row clicked
ll_found = Pos(ls_object,"obj_button")
ll_position_no = Pos(ls_object,"~t")
ls_row_no = Trim(Mid(ls_object, ll_position_no + 1))
ll_row_no = long(ls_row_no)

// Find current cargo and copy the misc. port expens window
ll_current_cargo = uf_get_cargoxxx()
ls_misc_expenses.dw_port_expenses = dw_calc_port_expenses



// Correct object found
If ll_found > 0 Then
	ls_misc_expenses.d_caio_id = dw_dischports.GetItemNumber(ll_row_no,"cal_caio_id")
	ls_misc_expenses.d_edit_locked = dw_dischports.GetItemNumber(ll_row_no,"edit_locked")
	
	// Open misc expenses window
	If Not IsNull(ls_misc_expenses.d_caio_id) Then
		OpenWithParm(w_calc_misc_expenses,ls_misc_expenses)
		ls_misc_expenses = Message.PowerObjectParm
		
		// Update the total misc. expenses field
		If ls_misc_expenses.d_total_misc_expenses >= 0 Then
			dw_dischports.SetItem(ll_row_no,"cal_caio_misc_expenses",ls_misc_expenses.d_total_misc_expenses)
		End if
		
		// Notify the calculation that a change has occured
		If ls_misc_expenses.b_modified Then
			iuo_calc_nvo.iuo_calc_cargos.TriggerEvent("ue_childmodified")
		End if	
	Else
		// A port has to be saved before the misc. expenses window can be opened
		MessageBox("Information","It is only possible to open the Port expenses window in a saved calculation")
	End if
End if
	



end event

event constructor;call super::constructor;This.SetRowFocusIndicator(FocusRect!)
/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
end if
end event

event editchanged;call super::editchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls iuo_dddw_search_disch.uf_editchanged() which handels all
				  changes to the port selection

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
iuo_dddw_search_disch.uf_editchanged()
end event

event itemchanged;call super::itemchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Set the number of units to negative in the units field

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE        CR-Ref      Author      DESCRIPTION
-----------------------------------------------------------------------------
27/01/15    CR3433      LHG008      Fix the bug for failed to add new load port feature from the compact window
29/01/15    CR3935      LHG008      Pre-select a default consumption type for Idle, Bunkering, Various
20/11/17	   CR4221	  HHX010		 Add a warning message
****************************************************************************/

Double ld_tmp
long ll_return

If  uf_loaddisch_itemchanged(dw_dischports, iuo_dddw_search_disch) = "cal_caio_number_of_units" Then
	// Set automatic minus in dischunits, if not supplied by user

	ld_tmp = Double(This.GetText())
	If ld_tmp > 0 Then 
		This.SetItem(This.GetRow(), "cal_caio_number_of_units", - ld_tmp)
		Return 2
	End if
End if

if row > 0 then
	choose case dwo.name
		case "port_code"
			ll_return = iuo_calc_nvo.iuo_calc_cargos.dw_dischports.event itemchanged(row, dwo, data)
			
			if ll_return = 2 then
				this.post setcolumn(string(dwo.name))
			end if
			
			return ll_return
		case 'cal_caio_interim_port' 
   			if of_isallowed_interim(this, row, data, "D") = false then return 2 	
			if of_check_interimport_change(this, row, data) = C#Return.Failure then return 2	
			if data='1' then
				if this.object.cal_caio_rate_estimated[row] > 0 then 
					inv_msgbox.of_messagebox(inv_msgbox.is_TYPE_WARNING, MESSAGE_CP_LAYTIME, this)
				end if
				setitem(row, "cal_caio_total_port_expenses", this.object.cal_caio_total_port_expenses[row] - this.object.cal_caio_expenses[row])
				setitem(row, "cal_caio_expenses", 0)
				setitem(row, "cal_caio_rate_estimated", 0)
				setitem(row, "cal_caio_rate_calculated", 0)
				setitem(row, COLUMN_DESPATCH_DEM_CURR, 0)
				setitem(row, COLUMN_DEMURRAGE_DEM_CURR, 0)
				setitem(row, COLUMN_DESPATCH_USD, 0)
				setitem(row, COLUMN_DESPATCH_LOCAL_CURR, 0)
				setitem(row, COLUMN_DEMURRAGE_USD, 0)
				setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, 0)
			else
				of_restore_data(dw_dischports, row)
			end if	
		case else
			//do nothing
	end choose
end if

end event

event sqlpreview;call super::sqlpreview;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls uf_sql_change to change the sql string for update.

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
//uf_change_sql(3,dw_dischports,sqlsyntax)
end event

event rbuttondown;call super::rbuttondown;// parent.event ue_rightclick(this.classname( ))

integer li_x, li_y
string ls_port_code

if isnull(row) or row < 1 then return

if dwo.name = "p_voyagealert" then
	ls_port_code = this.getitemstring(row, "port_code")
	if isnull(ls_port_code) then ls_port_code = ""
	if trim(ls_port_code, true) = "" then return
	
	li_x = PixelsToUnits(xpos, XPixelsToUnits!) + this.x
	li_y = PixelsToUnits(ypos, YPixelsToUnits!) + this.y
	
	of_show_voyage_alert(ls_port_code, li_x, li_y)
end if
end event

type dw_loadports from u_datawindow_sqlca within u_atobviac_calc_compact
event ue_recalc_exp pbm_custom68
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
integer x = 133
integer y = 1252
integer width = 763
integer height = 508
integer taborder = 40
string dataobject = "d_ex_tb_calc_cpact_cargo_in"
boolean vscrollbar = true
boolean border = false
boolean ib_autoaccept = true
end type

event ue_keydown;call super::ue_keydown;/****************************************************************************
Author		: MI
Date			: August 1996
Description	: Investigate up and down arrow. Coordinate jumping between loadports
				  and cargo summary on arrow up, or load ports and dischports on 
				  arrow down.

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------

****************************************************************************/
If KeyDown(KeyUpArrow!) Then
	If This.GetRow()=1 Then 
		dw_cargo_summary.SetFocus()
		dw_cargo_summary.SetColumn("cal_carg_description")
	End if
Elseif KeyDown(KeyDownArrow!) Then
	If This.GetRow() = This.RowCount() Then
		dw_dischports.SetFocus()
		If dw_dischports.GetItemNumber(1, "cal_caio_number_of_units") = 0 Then
			dw_dischports.SetColumn("port_code") 
		Else
			dw_dischports.SetColumn(dw_loadports.GetColumnName())
		End if
	End if
End if
end event

event ue_check_cqd;call super::ue_check_cqd;/****************************************************************************
Author		: MI
Date			: August 1996
Description	: Calls uf_check_cqd to see if cqd has been selected in rate terms.

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
uf_check_cqd(dw_loadports)
end event

event clicked;call super::clicked;/****************************************************************************
Author		: MI
Date			: May 1997
Description	: If the button on the window is clicked the misc. port expenses
				  window is opened.

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-5-97	1.0		TA		Initial version
****************************************************************************/

// Set local variables
String ls_object, ls_row_no
long ll_found, ll_row_no, ll_position_no, ll_current_cargo
s_misc_expenses ls_misc_expenses



// Get the clicked object at the end of the pointer
ls_object = dw_loadports.GetObjectAtPointer()

// Determin what object has been clicked and what row it is
ll_found = Pos(ls_object,"obj_button")
ll_position_no = Pos(ls_object,"~t")
ls_row_no = Trim(Mid(ls_object, ll_position_no + 1))
ll_row_no = long(ls_row_no)

// Get current cargo and insert the port expenses window into structure
ll_current_cargo = uf_get_cargoxxx()
ls_misc_expenses.dw_port_expenses = dw_calc_port_expenses

// The right object was clicked so
If ll_found > 0 Then
	ls_misc_expenses.d_caio_id = dw_loadports.GetItemNumber(ll_row_no,"cal_caio_id")
	ls_misc_expenses.d_edit_locked = dw_loadports.GetItemNumber(ll_row_no,"edit_locked")

	// Open misc expenses window
	If Not IsNull(ls_misc_expenses.d_caio_id) Then
		OpenWithParm(w_calc_misc_expenses,ls_misc_expenses)
		ls_misc_expenses = Message.PowerObjectParm

		// Update total misc. expenses on the port
		If ls_misc_expenses.d_total_misc_expenses >= 0 Then
			dw_loadports.SetItem(ll_row_no,"cal_caio_misc_expenses",ls_misc_expenses.d_total_misc_expenses)
		End if
		
		// Notify the calculation that a change has occured
		If ls_misc_expenses.b_modified Then
			iuo_calc_nvo.iuo_calc_cargos.TriggerEvent("ue_childmodified")
		End if
	Else
		// A port expens can't be attached to a port that hasen't been saved
		MessageBox("Information","It is only possible to open the Port expenses window in a saved port")
	End if
End if


end event

event constructor;call super::constructor;/****************************************************************************
Author		: MI
Date			: August 1996
Description	: Identifies the current row in the window with a dotted rectangle

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
This.SetRowFocusIndicator(FocusRect!)

/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
end if
end event

event editchanged;call super::editchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Handles changes to the dddw for ports. 

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
iuo_dddw_search_load.uf_editchanged()

end event

event itemchanged;call super::itemchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls to uf_loaddisch_itemchanged which handles all changes to
				  the port row

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE        CR-Ref      Author      DESCRIPTION
-----------------------------------------------------------------------------
27/01/15    CR3433      LHG008      Fix the bug for failed to add new load port feature from the compact window
29/01/15    CR3935      LHG008      Pre-select a default consumption type for Idle, Bunkering, Various
20/11/17	   CR4221	  HHX010	 	 Add a warning message
****************************************************************************/

long		ll_return

if row > 0 then
	choose case dwo.name
		case "port_code", "cal_caio_number_of_units" 
			ll_return = iuo_calc_nvo.iuo_calc_cargos.dw_loadports.event itemchanged(row, dwo, data)
			
			if ll_return = 2 then
				this.post setcolumn(string(dwo.name))
			end if
			
			return ll_return
		case 'cal_caio_interim_port' 
   			if of_isallowed_interim(this, row, data, "L") = false then return 2 
			if of_check_interimport_change(this, row, data) = C#Return.Failure then return 2	
			 if data='1' then
				if this.object.cal_caio_rate_estimated[row] > 0 then 
					inv_msgbox.of_messagebox(inv_msgbox.is_TYPE_WARNING, MESSAGE_CP_LAYTIME, this)
				end if
				this.post setitem(row, "cal_caio_expenses", 0)
				this.post setitem(row, "cal_caio_rate_estimated", 0)
				this.post setitem(row, "cal_caio_rate_calculated", 0)
				this.post setitem(row, COLUMN_DESPATCH_DEM_CURR, 0)
				this.post setitem(row, COLUMN_DEMURRAGE_DEM_CURR, 0)
				this.post setitem(row, COLUMN_DESPATCH_USD, 0)
				this.post setitem(row, COLUMN_DEMURRAGE_USD, 0)
				this.post setitem(row, COLUMN_DESPATCH_LOCAL_CURR, 0)
				this.post setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, 0)
				this.setitem(row, "cal_caio_total_port_expenses", this.object.cal_caio_total_port_expenses[row] - this.object.cal_caio_expenses[row])
			else
				of_restore_data(dw_loadports, row)
			end if	
		case else
			//do nothing
	end choose
end if

uf_loaddisch_itemchanged(dw_loadports, iuo_dddw_search_load)

end event

event itemerror;call super::itemerror;return 1
end event

event sqlpreview;call super::sqlpreview;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls uf_change_sql to get the sql string modified for the save
				  operation

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
//uf_change_sql(2,dw_loadports,sqlsyntax)



end event

event rbuttondown;call super::rbuttondown;// parent.event ue_rightclick("dw_loadports")

integer li_x, li_y
string ls_port_code

if isnull(row) or row < 1 then return

if dwo.name = "p_voyagealert" then
	ls_port_code = this.getitemstring(row, "port_code")
	if isnull(ls_port_code) then ls_port_code = ""
	if trim(ls_port_code, true) = "" then return
	
	li_x = PixelsToUnits(xpos, XPixelsToUnits!) + this.x
	li_y = PixelsToUnits(ypos, YPixelsToUnits!) + this.y
	
	of_show_voyage_alert(ls_port_code, li_x, li_y)
end if
end event

type dw_calc_ballast from u_datawindow_sqlca within u_atobviac_calc_compact
boolean visible = false
integer x = 914
integer y = 360
integer width = 1947
integer height = 288
integer taborder = 70
string dataobject = "d_atobviac_calc_ballast"
end type

event sqlpreview;call super::sqlpreview;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
 Object     : u_calc_summary
 Event	 : dw_calc_ballast.sqlpreview
 Scope     : 
 ************************************************************************************
 Author    : MIS
 Date       : 3-6-97
 Description : Replicates changes in calculated to estimated calculations
 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
String ls_sql
u_sql_util uo_sql_util
Long ll_ball_id, ll_estimated_ball_id 
long ll_fromid, ll_toid

If il_estimated_calc_id > 0 Then
	ls_sql = LeftTrim(SQLsyntax)
	If Left(ls_sql,6)="UPDATE" Then
		ll_fromid 	= this.getItemNumber(1, "cal_ball_id")
		ll_toid		= this.getItemNumber(2, "cal_ball_id")
		
		uo_sql_util = CREATE u_sql_util
		ll_ball_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_BALL_ID"))
		if ll_fromid = ll_ball_id then
			SELECT CAL_BALL_ID INTO :ll_estimated_ball_id FROM CAL_BALL WHERE CAL_CALC_ID = :il_estimated_calc_id ORDER BY CAL_BALL_ID ASC;
		else
			SELECT CAL_BALL_ID INTO :ll_estimated_ball_id FROM CAL_BALL WHERE CAL_CALC_ID = :il_estimated_calc_id ORDER BY CAL_BALL_ID DESC;
		end if			
		uo_sql_util.uf_modify_where(ls_sql, "CAL_BALL_ID", "(CAL_BALL_ID = "+String(ll_ball_id)+" OR CAL_BALL_ID = "+String(ll_estimated_ball_id)+")")							
		
		This.SetSQLPreview(ls_sql)
		Destroy uo_sql_util
	End if
End if
end event

type dw_sidepanel from u_datawindow_sqlca within u_atobviac_calc_compact
integer x = 9
integer width = 110
integer height = 2320
boolean bringtotop = true
string dataobject = "d_ex_tb_calc_cpact_sidepanel"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;parent.event ue_rightclick(this.classname( ))

end event

type dw_cargo_summary from u_datawindow_sqlca within u_atobviac_calc_compact
integer x = 146
integer y = 692
integer width = 681
integer height = 560
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ex_tb_calc_cpact_cargo_summary"
boolean border = false
boolean ib_autochildmodified = false
boolean ib_autoaccept = true
end type

event rbuttondown;call super::rbuttondown;// parent.event ue_rightclick(this.classname( ))


end event

event itemchanged;call super::itemchanged;choose case dwo.name
	case "cal_carg_cal_carg_idle_days", "cal_carg_cal_carg_add_days_laden", "cal_carg_cal_carg_add_days_ballast"
		return iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary.event itemchanged(row, dwo, data)
	case else
		//
end choose

/* use the same validation function used against the cargo summary in the main u_atobviac_calc_cargos */
return iuo_calc_nvo.iuo_calc_cargos.of_validatecargosummary( dw_cargo_summary, dwo, row, data)

end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_cargo_summary)
end event

event doubleclicked;call super::doubleclicked;s_calc_addbuncons lstr_calc_addbuncons
long ll_vessel_type, ll_vessel_id, ll_clarkson_id, ll_cargo_id, ll_calc_id
integer li_locked
dec{3} ld_org_hsfo, ld_org_hsgo, ld_org_lsgo, ld_org_lsfo, ld_cur_hsfo, ld_cur_hsgo, ld_cur_lsgo, ld_cur_lsfo

if row < 1  then return

if dwo.name = 'cal_carg_add_fo' or dwo.name = 'cal_carg_add_do' or dwo.name = 'cal_carg_add_mgo' or dwo.name = 'cal_carg_add_lsfo' then
	iuo_calc_nvo.iuo_calc_summary.uf_get_vessel(ll_vessel_type, ll_vessel_id, ll_clarkson_id)
	
	if isnull(ll_vessel_id) or ll_vessel_id = 0 then return
	
	ll_calc_id = this.getitemnumber(row, "cal_calc_id")
	ll_cargo_id = this.getitemnumber(row,"cal_carg_id")
	If (ll_cargo_id = 0) or Isnull(ll_cargo_id) Then ll_cargo_id = -row
	li_locked = this.getitemnumber( row, "locked")
	if isnull(li_locked) then li_locked = 0
	
	lstr_calc_addbuncons.al_vessel_nr = ll_vessel_id
	lstr_calc_addbuncons.al_calc_id = ll_calc_id
	lstr_calc_addbuncons.al_carg_id = ll_cargo_id
	lstr_calc_addbuncons.adw_addbuncons = dw_addbuncons
	lstr_calc_addbuncons.ai_locked = li_locked
	
	OpenWithParm(w_calc_addbuncons, lstr_calc_addbuncons)
	
	if dw_addbuncons.rowcount( ) > 0 then
		ld_cur_hsfo = dw_addbuncons.getitemnumber(1, "total_hsfo")
		ld_cur_hsgo = dw_addbuncons.getitemnumber(1, "total_hsgo")
		ld_cur_lsgo = dw_addbuncons.getitemnumber(1, "total_lsgo")
		ld_cur_lsfo = dw_addbuncons.getitemnumber(1, "total_lsfo")
	end if
	
	if isnull(ld_cur_hsfo) then ld_cur_hsfo = 0
	if isnull(ld_cur_hsgo) then ld_cur_hsgo = 0
	if isnull(ld_cur_lsgo) then ld_cur_lsgo = 0
	if isnull(ld_cur_lsfo) then ld_cur_lsfo = 0
	
	ld_org_hsfo = this.getitemnumber(row, "cal_carg_add_fo")
	ld_org_hsgo = this.getitemnumber(row, "cal_carg_add_mgo")
	ld_org_lsgo = this.getitemnumber(row, "cal_carg_add_do")
	ld_org_lsfo = this.getitemnumber(row, "cal_carg_add_lsfo")
	
	if ld_cur_hsfo <> ld_org_hsfo then this.setitem(row, "cal_carg_add_fo", ld_cur_hsfo)
	if ld_cur_hsgo <> ld_org_hsgo then this.setitem(row, "cal_carg_add_mgo", ld_cur_hsgo)
	if ld_cur_lsgo <> ld_org_lsgo then this.setitem(row, "cal_carg_add_do", ld_cur_lsgo)
	if ld_cur_lsfo <> ld_org_lsfo then this.setitem(row, "cal_carg_add_lsfo", ld_cur_lsfo)
	
	if dw_addbuncons.modifiedcount() + dw_addbuncons.deletedcount() > 0 &
	or ld_cur_hsfo <> ld_org_hsfo or ld_cur_hsgo <> ld_org_hsgo &
	or ld_cur_lsgo <> ld_org_lsgo or ld_cur_lsfo <> ld_org_lsfo then
		parent.triggerevent("ue_childmodified")
	end if

end if
end event

type dw_calc_summary from u_datawindow_sqlca within u_atobviac_calc_compact
event ue_keydown pbm_dwnkey
integer x = 128
integer y = 4
integer width = 782
integer height = 684
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_ex_tb_calc_cpact_main_summary"
boolean border = false
boolean livescroll = false
boolean ib_autoaccept = true
end type

event ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Jumps from the summary datawindow to the cargo list, when focus
 					is on the expiry date field and the user presses keydown or
					tab.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If (This.GetColumnName() = "cal_calc_expiry_date") And &
	(KeyDown(KeyDownArrow!) or KeyDown(KeyTab!)) Then
//	dw_calc_summary_list.SetFocus()
//	dw_calc_summary_list.uf_select_row(1)
End if
end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles itemchanged events for the summary window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
22/03/13		CR2658	WWG004	The TCE/Day field change to editable.
************************************************************************************/

Integer	li_count, li_cargocount
Long 		ll_row, ll_found
String	ls_tmp

SetNull(ls_tmp)

// Check if it's the ballast from or ballast to ports. In that case, we call on 
// to the search-objects' uf_itemchanged.
CHOOSE CASE This.GetColumnName() 
	CASE "cal_calc_ballast_from"
		iuo_dddw_search_from.uf_itemchanged()
		ll_row = 1

	CASE "cal_calc_ballast_to"
		iuo_dddw_search_to.uf_itemchanged()
		ll_row = 2
		
	CASE "tce_day"
		li_cargocount = dw_cargo_summary.rowcount()
		inv_dddw_search.event mt_editchanged(row, dwo, data, dw_calc_summary)
		if not of_change_tce() then return 2
END CHOOSE

// Also, the ballast port might have changed. Update this to the CAL_BALL table,
// so that the ballast fields in both the calculation and the ballast table are
// in sync. It's not very smart with both fields, but it has been done this way
// to maintain compatability.
If ll_row <> 0 Then
	/* check if selected port is inactive */
	ll_found = w_share.dw_calc_port_dddw.find("port_code='"+data+"'", 1, 99999)
	if ll_found > 0 then
		if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "port_active") = 0 then
			Messagebox("Port code selection", "The selected portcode '"+data+"' is inactive. Please select another port.")
			if ll_row = 1 then
				this.POST setcolumn( "cal_calc_ballast_from" )
			else
				this.POST setcolumn( "cal_calc_ballast_to" )
			end if
			Return 2
		end if
	end if

	// This is a workaround when switching to PB 11.1 Something strange happend to ballast port when <none> selected
	if this.getText() = "<none>" or this.getText() = "(none)" then
		dw_calc_ballast.SetItem(ll_row,"port_code", space(10) )
	else
		dw_calc_ballast.SetItem(ll_row,"port_code", This.GetText())
	end if
	// end workaround
	// dw_calc_ballast.SetItem(ll_row,"port_code", This.GetText())
	uf_port_changed()

	For li_count = 1 To 3 
		dw_calc_ballast.SetItem(ll_row, "cal_ball_via_point_"+String(li_count), ls_tmp)
		dw_calc_ballast.SetItem(ll_row, "cal_ball_via_expenses_"+String(li_count), 0)
	Next
End if		
end event

event sqlpreview;call super::sqlpreview;String ls_sql
u_sql_util uo_sql_util
Long ll_calc_id 

// Check if IL_ESTIMATED_CALC_ID > 0. If so, we're in the process of saving an
// calculated calculation, and needs also to update the estimated calculation.
// Since a calculated calculation never needs to be INSERTED or DELETED, but
// only UPDATED. Therefore we search the SQL statement for an UPDATE, if found
// we modify the SQL statement's where clause, so I'll say WHERE (calculated ID)
// OR (estimated ID), and pass the new SQL statement back to Powerbuilder

If il_estimated_calc_id > 0 Then
	uo_sql_util = CREATE u_sql_util
/* Below modified when converting to PB 10 from PB 7 */
//	ls_sql = LeftTrim(This.GetSQLPreview())
	ls_sql = LeftTrim(SQLsyntax)

	If Left(ls_sql,6)="UPDATE" Then
		ll_calc_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_CALC_ID"))

		uo_sql_util.uf_modify_where(ls_sql, "CAL_CALC_ID", & 
		"(CAL_CALC_ID = "+String(ll_calc_id)+" OR CAL_CALC_ID = "+String(il_estimated_calc_id)+")")							
		
		This.SetSQLPreview(ls_sql)
	End if
End if
end event

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Passed editchanged events on to the ballastport search objects

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
22/03/13		CR2658	WWG004	The TCE/Day field change to editable.
************************************************************************************/

iuo_dddw_search_from.uf_editchanged()
iuo_dddw_search_to.uf_editchanged()



end event

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

event rbuttondown;call super::rbuttondown;// parent.event ue_rightclick(this.classname( ))
end event

event getfocus;call super::getfocus;this.post selecttext(1, -1)
end event

event clicked;call super::clicked;long ll_vessel_type_id, ll_vessel_id, ll_clarkson_id
pointer lp_oldpointer

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

choose case dwo.name
	case 'p_use'

		if this.rowcount() < 1 then return
		if this.GetItemNumber(1, "Locked") > 0 then 
			this.enabled = False
			return
		end if
		lp_oldpointer = setpointer(HourGlass!)
		uf_get_vessel ( ll_vessel_type_id, ll_vessel_id, ll_clarkson_id )
		uf_set_vessel ( ll_vessel_type_id, ll_vessel_id, ll_clarkson_id )
		
		ll_vessel_id = this.getitemdecimal(1,'cal_calc_vessel_id')
		iuo_calc_nvo.of_get_bunkerstockprice( ll_vessel_id)
		
		if  iuo_calc_nvo.istr_calc_bunkerstockprice.d_fo_price > 0 then
			this.SetItem(1,"cal_calc_fo_price",iuo_calc_nvo.istr_calc_bunkerstockprice.d_fo_price)
		else
			if isnull(this.getitemdecimal(1,'cal_calc_fo_price')) then
				this.SetItem(1,"cal_calc_fo_price",0)
			end if
		end if
		
		if iuo_calc_nvo.istr_calc_bunkerstockprice.d_do_price > 0 then
			this.SetItem(1,"cal_calc_do_price", iuo_calc_nvo.istr_calc_bunkerstockprice.d_do_price)
		else
			if isnull(this.getitemdecimal(1,'cal_calc_do_price')) then
				this.SetItem(1,"cal_calc_do_price",0)
			end if
		end if
		
		if iuo_calc_nvo.istr_calc_bunkerstockprice.d_mgo_price > 0 then
			this.SetItem(1,"cal_calc_mgo_price", iuo_calc_nvo.istr_calc_bunkerstockprice.d_mgo_price)	
		else
			if isnull(this.getitemdecimal(1,'cal_calc_mgo_price')) then
				this.SetItem(1,"cal_calc_mgo_price",0)
			end if
		end if
		
		if iuo_calc_nvo.istr_calc_bunkerstockprice.d_lsfo_price > 0 then
			this.SetItem(1,"cal_calc_lsfo_price",iuo_calc_nvo.istr_calc_bunkerstockprice.d_lsfo_price)
		else
			if isnull(this.getitemdecimal(1,'cal_calc_lsfo_price')) then
				this.SetItem(1,"cal_calc_lsfo_price",0)
			end if
		end if
		setpointer(lp_oldpointer)
end choose
end event

type dw_voyage_alert from u_popupdw within u_atobviac_calc_compact
integer x = 1097
integer y = 1332
integer width = 914
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sq_ff_voyage_alert_compact"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
boolean ib_autoclose = false
end type

event clicked;this.visible = false	
end event

event constructor;call super::constructor;this.settransobject(sqlca)
end event

