$PBExportHeader$u_atobviac_calc_summary.sru
$PBExportComments$summary subobject - used by u_calculation
forward
global type u_atobviac_calc_summary from u_atobviac_calc_base_sqlca
end type
type st_1 from statictext within u_atobviac_calc_summary
end type
type cb_stock_value from commandbutton within u_atobviac_calc_summary
end type
type cb_refresh_bunker from commandbutton within u_atobviac_calc_summary
end type
type dw_calc_summary from u_datawindow_sqlca within u_atobviac_calc_summary
end type
type dw_calc_ballast from u_datawindow_sqlca within u_atobviac_calc_summary
end type
type dw_calc_summary_list from u_datawindow_sqlca within u_atobviac_calc_summary
end type
type gb_1 from mt_u_groupbox within u_atobviac_calc_summary
end type
end forward

global type u_atobviac_calc_summary from u_atobviac_calc_base_sqlca
integer width = 4603
integer height = 2404
long backcolor = 32304364
st_1 st_1
cb_stock_value cb_stock_value
cb_refresh_bunker cb_refresh_bunker
dw_calc_summary dw_calc_summary
dw_calc_ballast dw_calc_ballast
dw_calc_summary_list dw_calc_summary_list
gb_1 gb_1
end type
global u_atobviac_calc_summary u_atobviac_calc_summary

type variables
Private u_dddw_search iuo_dddw_search_from
Private u_dddw_search iuo_dddw_search_to
Private Long il_estimated_calc_id
Public s_revers_sens istr_revers_sens
n_datagrid inv_grid
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
public subroutine of_get_bunkerstock ()
private subroutine documentation ()
end prototypes

public subroutine uf_retrieve (long al_calcid);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-8-96

 Description : Retrieves calculation with al_calcid

 Arguments : calculation id as long

 Returns   : None  

*************************************************************************************
Development Log 
DATE           CR-Ref      NAME        DESCRIPTION
--------       -------     -----       -------------------------------------
21/01/15       CR3921      LHG008      Fix the bug when colunm locked but the backcolor is not changed
************************************************************************************/

Integer 	li_status, li_locked
string 	ls_portcode
// Retrieve data into the summary datawindow, select first row, and set focus
// on it.

dw_calc_summary.Retrieve(al_calcid)
COMMIT;

dw_calc_summary_list.SelectRow(1,True)
dw_calc_summary_list.SetFocus()

dw_calc_ballast.Retrieve(al_calcid)
COMMIT;

// Validate that the ballast codes in the CAL_BALL table are the same as the 
// CAL_CALC table. The reason for this is, that the CAL_BALL table was introduced
// later in the development phase, and to maintain compability, both fields are
// updated (although the ballast-port in the CAL_CALC should be deleted at some time).

ls_portcode = dw_calc_summary.GetItemString(1,"cal_calc_ballast_from")
if ls_portcode = "<none>" or ls_portcode = "(none)"then 
	// work around when switch to PB 11.1 (7/2-08)
else
	If dw_calc_ballast.GetItemString(1,"port_code")<>ls_portcode Then
			MessageBox("System error", "Ballast codes are different~r~n~r~n "+ &
				dw_calc_summary.GetItemString(1,"cal_calc_ballast_from")+" "+&
				dw_calc_ballast.GetItemString(1,"port_code"))
	End if
End if

ls_portcode = dw_calc_summary.GetItemString(1,"cal_calc_ballast_to")
if ls_portcode = "<none>" or ls_portcode = "(none)"then 
	// work around when switch to PB 11.1 (7/2-08)
else	
	If dw_calc_ballast.GetItemString(2,"port_code")<>ls_portcode Then
			MessageBox("System error", "Ballast codes are different~r~n~r~n "+ &
				dw_calc_summary.GetItemString(1,"cal_calc_ballast_to")+" "+&
				dw_calc_ballast.GetItemString(2,"port_code"))
	End if
end if

// Set the locked value in the summary datawindow, depending on the
// CAL_CALC_STATUS. If status is 4 or 6 (fixture or calculated) then
// set focus to the "locked" column, since all other fields are locked
// (and powerbuilder doesn't handle when all fields in a datawindow
// is locked), and enable the vertical scrollbar.
li_status = dw_calc_summary.GetItemNumber(1, "cal_calc_status" )

If (li_status >= 4) Then 
	If (li_status =4) or (li_status =6) Then li_locked = 2 
Else 
	li_locked = 0
End if

// Set the locked status in the datawindow
dw_calc_summary.SetItem(1, "locked", li_locked)
if li_locked > 0 then
	this.cb_refresh_bunker.enabled = false
else
	this.cb_refresh_bunker.enabled = true
end if

//Handle PB focus issue when all fields in a datawindow is locked
dw_calc_summary.SetColumn(dw_calc_summary.getcolumn())
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
19/01/16		CR3381		CCY018		Remove Ship type and Competitor.
14/03/16     CR3146       KSH092		Bunker Price from Bunker stock
************************************************************************************/


// 0 is not allowed as VESSEL ID, so convert 0 to NULL's
If al_vessel_type_id = 0 Then SetNull(al_vessel_type_id)
If al_vessel_id = 0 Then SetNull(al_vessel_id)
If al_clarkson_id = 0 Then SetNull(al_clarkson_id)

// Update the calculation, and call UF_GET_VESSEL_DATA, so that we can
// update the Fuel, Diesel and Marine Gas prices.
dw_calc_summary.SetItem(1,"cal_calc_vessel_id",al_vessel_id)



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
19/01/16		CR3381		CCY018		Remove Ship type and Competitor.
---------------------------------------------------------
************************************************************************************/

long ll_null

setnull(ll_null)
al_vessel_type_id = ll_null
al_vessel_id = dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")
al_clarkson_id = ll_null

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


Return(dw_calc_summary_list.GetRow())
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

dw_calc_summary_list.SelectRow(0,false)
dw_calc_summary_list.SetRow(ai_cargo)
dw_calc_summary_list.SelectRow(ai_cargo,true)


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
dw_calc_summary_list.uf_redraw_off()
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
dw_calc_summary_list.uf_redraw_on()
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
	astr_parm.i_no_cargos = dw_calc_summary_list.RowCount()
	astr_parm.s_ballast_from = dw_calc_summary.GetItemString(1,"cal_calc_ballast_from")
	astr_parm.s_ballast_to = dw_calc_summary.GetItemString(1,"cal_calc_ballast_to")
	astr_parm.d_fo_price = dw_calc_summary.GetItemNumber(1,"cal_calc_fo_price")
	astr_parm.d_do_price = dw_calc_summary.GetItemNumber(1,"cal_calc_do_price")
	astr_parm.d_mgo_price = dw_calc_summary.GetItemNumber(1,"cal_calc_mgo_price")
	astr_parm.d_lsfo_price  = dw_calc_summary.GetItemNumber(1,"cal_calc_lsfo_price")
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
16/03/2016 CR3146    When new Calculation set bunker price is 0
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
dw_calc_summary.SetItem(1,"cal_calc_fo_price",0)
dw_calc_summary.SetItem(1,"cal_calc_do_price",0)
dw_calc_summary.SetItem(1,"cal_calc_mgo_price",0)
dw_calc_summary.SetItem(1,"cal_calc_lsfo_price",0)

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
DATE     VERSION     NAME       DESCRIPTION
-------- -------     ------     ------------------------------------
28/01/16	CR3248      LHG008     Fix bug
************************************************************************************/

Long ll_calc_id
Boolean lb_result

// Update the LAST_EDITED and LAST_EDITED_BY fields
dw_calc_summary.SetItem(1, "cal_calc_last_edited",DateTime(ToDay(),Now()))
dw_calc_summary.SetItem(1,"cal_calc_last_edited_by",uo_global.is_userid)

// and update the datawindow to the database. The AL_ESTIMATED_CALC_ID is
// copied to the IL_ESTIMATED_CALC_ID before, because the SQLPreview event
// (which is getting triggered by update) needs the IL_ESTIMATED_CALC_ID.
il_estimated_calc_id = al_estimated_calc_id
lb_result = dw_calc_summary.update(true,false) = 1

// If this is a new calculation then CAL_CALC_ID will be null, even though
// the record has been saved, because only the database knows the CAL_CALC_ID
// until next retrieve. Since the CAL_CALC_ID is needed by the rest of the
// calculation system, we'll retrieve the CAL_CALC_ID by calling UF_GET_CALC_ID().
// Update the CAL_BALL table with the CAL_CALC_ID, and update the CAL_BALL table
If lb_result Then
	ll_calc_id = uf_get_calc_id()
	If IsNull(dw_calc_ballast.GetItemNumber(1,"cal_calc_id")) or dw_calc_ballast.GetItemNumber(1,"cal_calc_id") <> ll_calc_id Then
		dw_calc_ballast.SetItem(1, "cal_calc_id", ll_calc_id)
		dw_calc_ballast.SetItem(2, "cal_calc_id", ll_calc_id)
	End if

	lb_result = dw_calc_ballast.Update(true,false) = 1
End if			

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
this.cb_refresh_bunker.enabled = true
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


dw_calc_summary.SetFocus()
Super::uf_activate()
end subroutine

public subroutine of_get_bunkerstock ();/********************************************************************
   of_get_bunkerstock
   <OBJECT>		Open current buker stock</OBJECT>
   <USAGE>		When click or double click button to get the bunker stock	</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date				CR-Ref			Author		Comments
   	29/11/2013		CR2658UAT		WWG004		First Version
   </HISTORY>
********************************************************************/

s_port_departure_values_parameter lstr_parm

long	ll_type, ll_clarkson, ll_vessel

/* find last actual port of call for this vessel where there is registred bunker on departure */
uf_get_vessel( ll_type, ll_vessel, ll_clarkson )
if isNull(ll_vessel) or ll_vessel = 0 then
	MessageBox("Information", "No vessel connected to this calculation. Please select a vessel and try again.")
	return
end if

SELECT TOP 1 POC.VESSEL_NR,
		 POC.VOYAGE_NR,
		 POC.PORT_CODE,
		 POC.PCN
 INTO :lstr_parm.vessel,
		:lstr_parm.voyage,
		:lstr_parm.portcode,
		:lstr_parm.pcn
 FROM POC
WHERE POC.VESSEL_NR = :ll_vessel
  AND (ISNULL(POC.DEPT_HFO, 0) > 0 OR ISNULL(POC.DEPT_DO, 0) > 0 OR ISNULL(POC.DEPT_GO, 0) > 0 OR ISNULL(POC.DEPT_LSHFO, 0) > 0)
ORDER BY POC.PORT_ARR_DT DESC ;

OpensheetWithParm(w_bunker_departure_values, lstr_parm,w_tramos_main )

end subroutine

private subroutine documentation ();/********************************************************************
   u_atobviac_calc_summary
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		29/10/15		CR3250		CCY018		Add LSFO fuel in calculation module.
		30/12/15		CR3381		XSZ004		Remove vessel type message.
		19/01/16		CR3381		CCY018		Remove Ship type and Competitor.
		28/01/16		CR3248		LHG008		ECA zone implementation.
		17/03/16     CR3146       KSH092		When New calculation set summary bunker price is 0, change button Use and View
   </HISTORY>
********************************************************************/
end subroutine

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes the u_calc_summary window

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Create the drop-down search-as-you-type object to the 
// ballast from and ballast to fields

iuo_dddw_search_from = CREATE u_dddw_search
iuo_dddw_search_from.uf_setup(dw_calc_summary, "cal_calc_ballast_from", "port_n", true)
iuo_dddw_search_to = CREATE u_dddw_search
iuo_dddw_search_to.uf_setup(dw_calc_summary, "cal_calc_ballast_to", "port_n", true)


n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc_summary_list,false)
lnv_style.of_dwformformater(dw_calc_summary)

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
end event

on u_atobviac_calc_summary.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_stock_value=create cb_stock_value
this.cb_refresh_bunker=create cb_refresh_bunker
this.dw_calc_summary=create dw_calc_summary
this.dw_calc_ballast=create dw_calc_ballast
this.dw_calc_summary_list=create dw_calc_summary_list
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_stock_value
this.Control[iCurrent+3]=this.cb_refresh_bunker
this.Control[iCurrent+4]=this.dw_calc_summary
this.Control[iCurrent+5]=this.dw_calc_ballast
this.Control[iCurrent+6]=this.dw_calc_summary_list
this.Control[iCurrent+7]=this.gb_1
end on

on u_atobviac_calc_summary.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_stock_value)
destroy(this.cb_refresh_bunker)
destroy(this.dw_calc_summary)
destroy(this.dw_calc_ballast)
destroy(this.dw_calc_summary_list)
destroy(this.gb_1)
end on

type st_1 from statictext within u_atobviac_calc_summary
integer x = 466
integer y = 464
integer width = 672
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
string text = "Current Bunker ROB"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_stock_value from commandbutton within u_atobviac_calc_summary
integer x = 1147
integer y = 444
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View S&tock"
end type

event clicked;if isValid(w_bunker_departure_values) then post close(w_bunker_departure_values)

post of_get_bunkerstock()
end event

type cb_refresh_bunker from commandbutton within u_atobviac_calc_summary
integer x = 1495
integer y = 444
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Use Prices"
end type

event clicked;long ll_vessel_type_id, ll_vessel_id, ll_clarkson_id
pointer lp_oldpointer

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_calc_summary.GetItemNumber(1, "Locked") > 0 then 
	this.enabled = False
	return
end if
lp_oldpointer = setpointer(HourGlass!)
uf_get_vessel ( ll_vessel_type_id, ll_vessel_id, ll_clarkson_id )
uf_set_vessel ( ll_vessel_type_id, ll_vessel_id, ll_clarkson_id )

ll_vessel_id = dw_calc_summary.getitemdecimal(1,'cal_calc_vessel_id')
iuo_calc_nvo.of_get_bunkerstockprice( ll_vessel_id)

if  iuo_calc_nvo.istr_calc_bunkerstockprice.d_fo_price > 0 then
	dw_calc_summary.SetItem(1,"cal_calc_fo_price",iuo_calc_nvo.istr_calc_bunkerstockprice.d_fo_price)
else
	if isnull(dw_calc_summary.getitemdecimal(1,'cal_calc_fo_price')) then
		dw_calc_summary.SetItem(1,"cal_calc_fo_price",0)
	end if
end if

if iuo_calc_nvo.istr_calc_bunkerstockprice.d_do_price > 0 then
	dw_calc_summary.SetItem(1,"cal_calc_do_price", iuo_calc_nvo.istr_calc_bunkerstockprice.d_do_price)
else
	if isnull(dw_calc_summary.getitemdecimal(1,'cal_calc_do_price')) then
		dw_calc_summary.SetItem(1,"cal_calc_do_price",0)
	end if
end if

if iuo_calc_nvo.istr_calc_bunkerstockprice.d_mgo_price > 0 then
	dw_calc_summary.SetItem(1,"cal_calc_mgo_price", iuo_calc_nvo.istr_calc_bunkerstockprice.d_mgo_price)	
else
	if isnull(dw_calc_summary.getitemdecimal(1,'cal_calc_mgo_price')) then
		dw_calc_summary.SetItem(1,"cal_calc_mgo_price",0)
	end if
end if

if iuo_calc_nvo.istr_calc_bunkerstockprice.d_lsfo_price > 0 then
	dw_calc_summary.SetItem(1,"cal_calc_lsfo_price",iuo_calc_nvo.istr_calc_bunkerstockprice.d_lsfo_price)
else
	if isnull(dw_calc_summary.getitemdecimal(1,'cal_calc_lsfo_price')) then
		dw_calc_summary.SetItem(1,"cal_calc_lsfo_price",0)
	end if
end if

setpointer(lp_oldpointer)

end event

type dw_calc_summary from u_datawindow_sqlca within u_atobviac_calc_summary
event ue_keydown pbm_dwnkey
integer x = 50
integer y = 60
integer width = 2816
integer height = 604
integer taborder = 10
string dataobject = "d_calc_summary"
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
	dw_calc_summary_list.SetFocus()
	dw_calc_summary_list.uf_select_row(1)
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count
Long ll_row, ll_found
String ls_tmp

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
//	dw_calc_ballast.SetItem(ll_row,"port_code", This.GetText())
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

iuo_dddw_search_from.uf_editchanged()
iuo_dddw_search_to.uf_editchanged()
end event

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

type dw_calc_ballast from u_datawindow_sqlca within u_atobviac_calc_summary
boolean visible = false
integer x = 119
integer y = 1016
integer width = 2560
integer height = 288
integer taborder = 50
string dataobject = "d_atobviac_calc_ballast"
boolean border = false
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

type dw_calc_summary_list from u_datawindow_sqlca within u_atobviac_calc_summary
event ue_keydown pbm_dwnkey
event ue_mousemove pbm_dwnmousemove
event ue_lbuttondown pbm_lbuttondown
integer x = 50
integer y = 668
integer width = 2816
integer height = 768
integer taborder = 40
string dataobject = "d_calc_summary_list"
boolean vscrollbar = true
boolean border = false
boolean ib_autoaccept = true
end type

event ue_keydown;call super::ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set focus to the summarylist.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If (This.GetRow()=1) And (KeyDown(KeyUpArrow!) Or (KeyDown(KeyTab!) And KeyDown(KeyShift!))) Then
	dw_calc_summary.SetFocus()
End if

end event

event ue_mousemove;s_chart_comment_parm		lstr_parm 

If dwo.name = "p_comment" Then
	if not isValid(w_chart_comment_popup) then
		if row > 0 then
	      	lstr_parm.chart_nr = false
			lstr_parm.reciD = this.getItemNumber(row, "cal_carg_cal_calc_id")
			OpenWithParm (w_chart_comment_popup, lstr_parm )
		end if
   end if
End if
return 0
end event

event ue_lbuttondown;if inv_grid.of_stop_column_resize(flags, xpos, ypos) = c#return.Success then
 inv_grid.of_setcolumnorder()	
 message.processed = TRUE
 return 1
end if
end event

event rowfocuschanged;call super::rowfocuschanged;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    	: MIS
 Date       	: 1996
 Description : Handles row focus changed events, by selecting the cargo
 				  highlighted by this row,
 Arguments	: None
 Returns   	: None  
*************************************************************************************
Development Log 
DATE			REF 		NAME		DESCRIPTION
-------- 		-------		----- 		-------------------------------------
20/10-10  	2164		RMO003	Jump to C/P broken
************************************************************************************/
//long ll_row
//
//ll_row = This.GetRow()
//If ll_row > 0 Then &
//	iuo_calc_nvo.iuo_calc_cargos.uf_select_cargo(ll_row)

// CR #2164 - Changed the code from everything commented out to below

if currentrow > 0 then 
	iuo_calc_nvo.iuo_calc_cargos.uf_select_cargo( currentrow )
end if
end event

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Passes clicks on as double-clicks

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If row > 0 Then uf_cargo_dblclicked(row)



end event

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes the dw_calc_summary_list

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Ask u_datawindow_sqlca to work automaticly
ib_auto = true

/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF

inv_grid.of_registerdatawindow( dw_calc_summary_list)

if dw_calc_summary_list.Describe("compute_0046.type")<>"!" then &			
	inv_grid.of_setcolumnresize("compute_0046", false)
if dw_calc_summary_list.Describe("cal_cerp_cal_cerp_date.type")<>"!" then &			
	inv_grid.of_setcolumnresize("cal_cerp_cal_cerp_date", false)



end event

type gb_1 from mt_u_groupbox within u_atobviac_calc_summary
integer x = 18
integer y = 4
integer width = 2880
integer height = 1460
long backcolor = 32304364
string text = ""
end type

