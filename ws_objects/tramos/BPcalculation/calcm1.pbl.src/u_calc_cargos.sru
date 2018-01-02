$PBExportHeader$u_calc_cargos.sru
$PBExportComments$cargo's subobject - used by u_calculation
forward
global type u_calc_cargos from u_calc_base_sqlca
end type
type st_2 from statictext within u_calc_cargos
end type
type dw_calc_lumpsum from u_datawindow_sqlca within u_calc_cargos
end type
type st_1 from statictext within u_calc_cargos
end type
type dw_calc_misc_claim from u_datawindow_sqlca within u_calc_cargos
end type
type dw_calc_port_expenses from u_datawindow_sqlca within u_calc_cargos
end type
type dw_calc_hea_dev_claim from u_datawindow_sqlca within u_calc_cargos
end type
type dw_loadports from u_datawindow_sqlca within u_calc_cargos
end type
type dw_dischports from u_datawindow_sqlca within u_calc_cargos
end type
type dw_cargo_summary from u_datawindow_sqlca within u_calc_cargos
end type
type gb_1 from mt_u_groupbox within u_calc_cargos
end type
type r_1 from rectangle within u_calc_cargos
end type
type cb_1 from commandbutton within u_calc_cargos
end type
end forward

global type u_calc_cargos from u_calc_base_sqlca
integer width = 4603
integer height = 2404
event ue_recalc_exp pbm_custom68
event ue_check_cqd pbm_custom65
st_2 st_2
dw_calc_lumpsum dw_calc_lumpsum
st_1 st_1
dw_calc_misc_claim dw_calc_misc_claim
dw_calc_port_expenses dw_calc_port_expenses
dw_calc_hea_dev_claim dw_calc_hea_dev_claim
dw_loadports dw_loadports
dw_dischports dw_dischports
dw_cargo_summary dw_cargo_summary
gb_1 gb_1
r_1 r_1
cb_1 cb_1
end type
global u_calc_cargos u_calc_cargos

type variables
Private Integer il_itinerary_max    // Maximum itinerary number
Private Integer ii_reversible_freight[] // array of rev.  freight status.  Maps to cargono.
Private Integer ii_reversible_cp[]    // array of rev. demurrage status. Maps to cargono.
Private Integer ii_no_cargos  // No. of cargoes on calculation
Integer ii_current_cargo = 0  // current (active) cargo
Private String is_searchtext  // last searchtext in the search-as-you-type object
Private u_dddw_search iuo_dddw_search_load // search object for loadports
Private u_dddw_search iuo_dddw_search_disch  // search object for dischports
Long il_estimated_calc_id  // Estimated calc id id (only during save)
Private s_calculated_to_estimated istr_calc_to_est[] // Array for linking estimated and calculated calculations
Boolean ib_ballastvoyage // True is current voyage is a ballast voyage
Public s_revers_sens istr_revers_sens  // Sensitivity array
Boolean ib_vessellocked  // True if vessel is locked and cannot be modified
Private Long il_new_cargo_id[], il_original_cargo_id[], il_original_ports_id[] // Data for restoring links during save-failure
Public s_hea_dev_misc_parm istr_hea_dev_misc_parm // Parameters for hea/dev calculation
n_service_manager inv_serviceMgr
n_dw_style_service   inv_style
n_datagrid inv_grid_loadports
n_datagrid inv_grid_dischports
end variables

forward prototypes
public subroutine uf_mark_new ()
public subroutine uf_set_status (integer ai_cargo_no, integer ai_status)
public subroutine uf_set_cerp_id (integer ai_cargo_no, long al_cerp_id)
public function integer uf_get_status (integer ai_cargo_no)
public function integer uf_get_no_cargos ()
public function string uf_get_cargo_description (integer ai_cargo_no)
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine uf_delete_port ()
public subroutine uf_activate ()
public function string uf_loaddisch_itemchanged (ref datawindow adw_datawindow, ref u_dddw_search luo_dddw_search)
public function boolean uf_update (integer ai_cargo_no)
public subroutine uf_get_firstlast_port (ref string as_firstport, ref string as_lastport)
public subroutine uf_retrieve (long al_calcid, ref datawindow adw_summary)
public subroutine uf_set_ballast_voyage (boolean ab_value)
public function string uf_get_dischport_name (ref s_port_parm astr_port_parm)
public function long uf_insert_cargo (boolean ab_insertports)
public function integer uf_get_rate_type (integer ai_cargo_no)
public subroutine uf_restore_id ()
public subroutine uf_port_changed ()
public subroutine uf_reset_voyagetype ()
public function long uf_get_cargo_id ()
public subroutine uf_set_no_cargos (integer ai_no_cargos)
public subroutine uf_unlock ()
private subroutine uf_set_caio_id (ref datawindow adw_datawindow, long al_carg_id)
public function boolean uf_save (long al_calc_id, boolean ab_resetflags, long al_estimated_calc_id)
public function boolean uf_get_cargo_locked ()
public subroutine uf_misc_claims (long al_cargo_id)
public subroutine uf_heat_dev (long al_cargo_id, s_calculation_parm astr_calculation_parm, long al_cargo_no)
public function integer uf_get_revers_freight (integer ai_cargo_no)
public function long uf_get_cerp_id (integer ai_cargo_no)
public function integer uf_get_reversible (long al_cargo_no)
public subroutine uf_reversible (integer ai_function_code, ref datawindow adw_datawindow, integer as_set_field, integer ai_raty_id, double ad_rate_estimated, double ad_despatch, double ad_demurrage, integer ai_terms, double ad_rate_calculated)
public function integer uf_get_first_loadport ()
public function string uf_get_lport_name_purpose (s_port_parm astr_port_parm)
public function string uf_get_dport_name_purpose (s_port_parm astr_port_parm)
public subroutine uf_set_no_ports (integer ai_cargo_no, integer ai_no_loadports, integer ai_no_dischports, boolean ab_clear_itinerary)
private subroutine uf_check_cqd (ref datawindow adw_datawindow)
private subroutine uf_check_editlocked (long al_calc_id, ref datawindow adw_summary)
private function boolean uf_check_load (ref s_calculation_cargo_inout astr_inouts[], ref string as_errortext)
private function boolean uf_delete_misc_exp (long al_caio_id)
public subroutine uf_get_caio_ids (ref double d_list[])
public function integer uf_get_no_dischports (integer ai_cargo_no)
public function integer uf_get_no_loadports (integer ai_cargo_no)
public function boolean uf_process_cargos (ref s_calculation_parm astr_parm, ref datawindow adw_ports, ref s_calculation_cargo_inout astr_inouts[], ref double ad_expenses, integer ai_cargo_no, integer ai_pcnr)
public function integer uf_accepttext ()
public function integer uf_select_cargo (integer ai_cargo_row)
private subroutine uf_change_sql (integer ai_function_code, ref datawindow adw_datawindow, ref string as_sql)
public subroutine uf_delete_cargo (long al_cargono)
public function integer uf_deactivate ()
private subroutine uf_description_changed ()
public function integer uf_get_cargo ()
public function string uf_get_loadport_name (ref s_port_parm astr_port_parm)
public subroutine of_open_worldscale (datawindow dwo_load, datawindow dwo_disch, integer ai_year)
public function boolean uf_process (ref s_calculation_parm astr_parm)
public subroutine uf_update_speed ()
public subroutine of_lock_port (ref datawindow adw, long al_cal_caio_id, integer ai_status)
private subroutine documentation ()
private function integer _checksettlement ()
private function integer _getsettledclaimcounts (ref integer ai_settledfreight, ref integer ai_settledother)
public function integer of_getdatawindowfocus (ref u_datawindow_sqlca adw, ref string as_name)
public subroutine of_deletelumpsum (u_datawindow_sqlca adw)
public subroutine of_deleteport (u_datawindow_sqlca adw_port)
public subroutine of_insertlumpsum (u_datawindow_sqlca adw)
public subroutine of_insertport (ref u_datawindow_sqlca adw)
end prototypes

public subroutine uf_mark_new ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Mark all datawindows as NewModified! (for use with save as etc)

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_rows, ll_count

// Loop through all cargo summary and mark them as new
ll_rows = dw_cargo_summary.RowCount()
For ll_count = 1 To ll_rows
	dw_cargo_summary.SetItemStatus(ll_count, 0, Primary!, NewModified!)
Next

// and loop through all cargo in/outs and mark them as new
uf_select_cargo(-1)

ll_rows = dw_loadports.RowCount()
For ll_count = 1 To ll_rows 
	dw_loadports.SetItemStatus(ll_count, 0, Primary!, NewModified!)
Next

ll_rows = dw_dischports.RowCount()
For ll_count = 1 To ll_rows
	dw_dischports.SetItemStatus(ll_count, 0, Primary!, NewModified!)
Next	


end subroutine

public subroutine uf_set_status (integer ai_cargo_no, integer ai_status);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the status (ai_status) for cargo given in ai_cargo_no
 
 Arguments : ai_cargo_no as Integer, ai_status as Integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Sets the status for a cargo {ai_cargo} to {ai_status}
dw_cargo_summary.SetItem(ai_cargo_no, "cal_carg_status", ai_status)

// Tell the rest of the calculation system that something has changed.
Parent.TriggerEvent("ue_childmodified")
end subroutine

public subroutine uf_set_cerp_id (integer ai_cargo_no, long al_cerp_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the C/P id al_cerp_id for cargo given in ai_cargo_no (or 0
 					for current cargo)

 Arguments : ai_cargo_no as integer, al_cerp_id as Long

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Turn redraw off and do accepttext
uf_redraw_off()

dw_loadports.Accepttext()
dw_dischports.Accepttext()

// Set ai_cargo_no to current cargo if it's zero
If ai_cargo_no = 0 Then ai_cargo_no = dw_cargo_summary.GetRow()

// Update the summary window with the C/P ID, and call uf_update to
// update the cargo with reversible and commission information
dw_cargo_summary.SetItem(ai_cargo_no,"cal_carg_cal_cerp_id",al_cerp_id)
uf_update(ai_cargo_no)

// Tell the calculation system that something important has changed
Parent.PostEvent("ue_childmodified")

// Move current control away from Reversible-checkbox, if this is the 
// current, since protect doesn't work on current column
If dw_cargo_summary.GetColumnName()="cal_carg_cal_carg_reversible" Then dw_cargo_summary.SetColumn("cal_carg_status")

// and turn redraw back on.
uf_redraw_on()


end subroutine

public function integer uf_get_status (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the status for cargo given in ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : Cargostatus

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

Return(dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_status"))
end function

public function integer uf_get_no_cargos ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns number of cargos on calcuation

 Arguments : None

 Returns   : Long

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Return(ii_no_cargos)
end function

public function string uf_get_cargo_description (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the description for cargo ai_cargo_no

 Arguments : ai_cargo_no as Long

 Returns   : Description as string 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Check for valid cargo no, and return description if cargono is valid
If (ai_cargo_no>0) And (ai_cargo_no <= ii_no_cargos) Then
	Return(dw_cargo_summary.GetItemString(ai_cargo_no, "cal_carg_description"))
Else
	Return("")
End if
end function

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw off for all datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_cargo_summary.uf_redraw_off()
dw_dischports.uf_redraw_off()
dw_loadports.uf_redraw_off()
end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw on for all datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_cargo_summary.uf_redraw_on()
dw_dischports.uf_redraw_on()
dw_loadports.uf_redraw_on()
end subroutine

public subroutine uf_delete_port ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 

 Description : Deletes current (focused) port in either load or disch dw's

 Arguments : None

 Returns	  : None
 
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

GraphicObject lo_tmp
DataWindow ldw_port
Long ll_row
Integer li_locked
integer li_sign

SetNull(ldw_port)

// Get focus for the active control
lo_tmp = GetFocus()

// Check that active contol is a datawindow, and either dw_loadports or dw_dischports.
// Return if this is not the case. Store the actual datawindow to temporary variable ldw_port
If Not isNull(lo_tmp) Then
	If lo_tmp.TypeOf() = DataWindow! Then
		If lo_tmp.ClassName() = "dw_loadports" Then
			ldw_port = dw_loadports
		Elseif lo_tmp.Classname() = "dw_dischports" Then
			ldw_port = dw_dischports
		Elseif lo_tmp.Classname() = "dw_calc_lumpsum" Then
			of_deletelumpsum( dw_calc_lumpsum)
			return
		Else
			Return
		End if
	ELSE
		Return
	End if
End if

// Get current row that we are about to delete
ll_row = ldw_port.GetRow()

// Check if ll_row = 0 or if the port is locked. 
// (If ll_row = 0 then the rows will be locked due to a PB4 error)
If (ll_row = 0) Then li_locked = 1 Else li_locked = ldw_port.GetItemNumber(ll_row, "edit_locked")

// Drop deletion if the port is locked
If li_locked <> 0 Then
	MessageBox("Information", "You cannot delete a locked port", StopSign!)
	Return
End if

// Ask user to acknowledge the deletion
li_sign = MessageBox("Warning","You are about to delete a port. Continue?",Stopsign!,YesNoCancel!,2)
CHOOSE CASE li_sign
	CASE 1
		// Check that this in not the only port (a calculation must have atleast 1 load
		// and 1 dischports).
		If Not IsNull(ldw_port) Then
			If ldw_port.RowCount() = 1 Then
				MessageBox("Error","You cannot delete the last port", StopSign!)
				Return
			End if
			
			// Ok, we can now delete the port.
			ll_row = ldw_port.GetRow()
			If ll_row > 0 Then
				// First delete all misc. expenses on this port !
	
				uf_delete_misc_exp( ldw_port.GetItemNumber(ll_row,"cal_caio_id") )

				// Then delete the port row, and set rowfocus to the prior row, if 
				// rowno > 1.
				ldw_port.DeleteRow(ll_row)
				If ll_row > 1 Then ll_row --
				ldw_port.SetRow(ll_row)
				
				// Tell the calculation system that the ports have changed
				uf_port_changed()

				// and update the itinerary
				iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_update_itinerary_order()
			End if
		End if
	CASE 2
		Return
	Case 3
		Return
END CHOOSE


end subroutine

public subroutine uf_activate ();// Set focus to this and call ancestor

dw_cargo_summary.SetFocus()
Super::uf_activate()
end subroutine

public function string uf_loaddisch_itemchanged (ref datawindow adw_datawindow, ref u_dddw_search luo_dddw_search);/************************************************************************************

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
4-8-96					MI		Initial version  

************************************************************************************/

Double ld_total_mts, ld_value, ld_tmp, ld_estimated, ld_calculated
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

								ld_estimated = dw_loadports.getItemNumber(li_caio_count, "cal_caio_rate_estimated")
								ld_calculated = dw_loadports.getItemNumber(li_caio_count, "cal_caio_rate_calculated")
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
			adw_datawindow.SetItem(ll_row, "cal_caio_rate_estimated", ld_estimated)
			adw_datawindow.SetItem(ll_row, "cal_caio_rate_calculated", ld_calculated)
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
			adw_datawindow.SetItem(ll_row,"cal_caio_rate_estimated",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_rate_calculated",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_demurrage",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_despatch",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_noticetime",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_load_terms",0)
			adw_datawindow.SetItem(ll_row,"cal_raty_id",1)
		End if

END CHOOSE

// The following code updates changes in the reversible-dependant fields:
// Eg, if the demurrage has been changed, we need to copy it to all other
// port row and cargos that is reversible with this one.
// First, check if it's reversible
If (ll_row > 0) And &
   (dw_cargo_summary.GetItemNumber(ll_cargo_row,"cal_carg_cal_carg_reversible")=1 Or ii_reversible_cp[ll_cargo_row] = 1) Then

	// Get modified data according to columnname, we only want to check
	// the reversible-dependant fields.
	CHOOSE CASE ls_column
		CASE "cal_raty_id"
			li_set_field = 2
		CASE  "cal_caio_rate_estimated"
			li_set_field = 3	
		CASE "cal_caio_despatch"
			li_set_field = 4
		CASE "cal_caio_demurrage"
			li_set_field = 5			
		CASE "cal_caio_load_terms"
			li_set_field = 6
		CASE "cal_caio_rate_calculated"
			li_set_field = 7
	END CHOOSE

	// Get the Purpose code for this row.
	ls_tmp = adw_datawindow.GetItemString(ll_row, "purpose_code")

	// If it's a reversible-dependant field (li_set_field<>0), and purpose is 
	// Load or Disch, then continue the processing
	If (li_set_field <> 0)  And ((ls_tmp = "L") or (ls_tmp = "D")) Then
		uf_redraw_off()

		// Setup datafields, so we can let the uf_reversible procedure do all
		// the hard work.
		li_column = adw_datawindow.GetColumn()
		li_row = adw_datawindow.GetRow()

		If (li_set_field = 2) or (li_set_field=6) Then ll_value = Integer(adw_datawindow.GetText()) Else ld_value = Double(adw_datawindow.GetText())
		
		// Call uf_reversible for this datawindow.
		uf_reversible(1, adw_datawindow,  li_set_field, ll_value, ld_value, ld_value, ld_value, ll_value, ld_value)
		
		// If the field is despatch or demurrage, we also want to copy it to the
		// dischports (even though the user changed a load field).
		If li_set_field = 4 Or li_set_field = 5 Then
			uf_reversible(1, dw_dischports, li_set_field, ll_value, ld_value, ld_value, ld_value, ll_value, ld_value)
		End if 

		// Set focus back to our original (modified) row and column
		adw_datawindow.SetRow(li_row)
		adw_datawindow.SetColumn(li_column) // Set column, since uf_reversible will trash it

		// and turn redraw back on.
		uf_redraw_on()
	End if

End if

// return the columnname
Return(ls_column)

end function

public function boolean uf_update (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 

 Description : Updates/checks/maintains links when using reversible. This function is
 			called upon calculation-load and change of CP.

 Arguments : ai_cargo_no as integer - if zero current cargo is processed

 Returns   : True is status was changed.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_cerp_id
Integer li_cp, li_frt, li_count, li_chart_nr, li_loadport
Double ld_adr_comm, ld_tmp_comm, ld_cargo_temp_comm, ld_cargo_adr_comm
Boolean lb_changed
String ls_description, ls_charterer,ls_message_string
Integer li_current_cargo
Long ll_freight_type, ll_adr_com_lump, ll_count
Double ld_ws_rate, ld_lumpsum, ld_freight_rate, ld_flat_rate, ld_min_1, ld_min_2, ld_over_1, ld_over_2, ld_add_lumpsum
Long ll_null
Double ld_null

SetNull(ll_null)
SetNull(ld_null)

uf_redraw_off()

// If ai_cargo_no not given, set current cargo
If ai_cargo_no = 0 Then ai_cargo_no = dw_cargo_summary.GetRow()
If ai_cargo_no = 0 Then ai_cargo_no = ii_current_cargo 

// Get C/P ID for this cargo
ll_cerp_id = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_cal_cerp_id")

If ll_cerp_id > 0 Then

	// Get reversible information, description, charter and sum
	// of commissions from CAL_CERP table

	SELECT CAL_CERP_REV_DEM,
		CAL_CERP_REV_FREIGHT,
		CAL_CERP_DESCRIPTION,
		CHART_NR
	INTO :li_cp,
		:li_frt,
		:ls_description,
		:li_chart_nr
	FROM CAL_CERP
	WHERE CAL_CERP_ID = :ll_cerp_id;
	COMMIT;

	SELECT CAL_CERP_ADD_COMM
	INTO :ld_adr_comm
	FROM CAL_CERP
	WHERE CAL_CERP_ID = :ll_cerp_id;
	COMMIT;

	SELECT SUM(CAL_COMM_PERCENT)
	INTO :ld_tmp_comm
	FROM CAL_COMM
	WHERE CAL_CERP_ID = :ll_cerp_id;
	COMMIT;

	SELECT CHART.CHART_SN
	INTO :ls_charterer
	FROM CHART
	WHERE CHART_NR = :li_chart_nr;
	COMMIT;
Else
	// No CP was defined, so set commission to 0
	li_cp = 0
	li_frt = 0

	SetNull(ld_tmp_comm)
	SetNull(ld_adr_comm)
End if

// Update the cargo with CP information (reversibe, charter and description)
dw_cargo_summary.SetItem(ai_cargo_no,"compute_0046", ls_charterer)
dw_cargo_summary.SetItem(ai_cargo_no, "cal_cerp_cal_cerp_description", ls_description)
dw_cargo_summary.SetItem(ai_cargo_no, "cal_carg_cal_carg_reversible", li_cp)

// Since the CP might have changed, we need to loop through all other cargos on
// our calculation and update them if they uses the same CP.
For li_count = 1 To ii_no_cargos

	If dw_cargo_summary.GetItemNumber(li_count, "cal_carg_cal_cerp_id") = ll_cerp_id Then
		// If same CP-id, then this cargo should be reversible with ours.

		If (li_count<>ai_cargo_no) then 
			ii_reversible_cp[li_count] = li_cp
			ii_reversible_freight[li_count] = li_frt
		End if
		
		// Calculate and Display warning if commission is different between the calculation
		// and the CP
		ld_cargo_temp_comm = dw_cargo_summary.GetItemNumber(li_count,"cal_carg_temp_comission")
		ld_cargo_adr_comm = dw_cargo_summary.GetItemNumber(li_count,"cal_carg_adr_commision")
		ls_message_string = ""

		If Round(ld_cargo_adr_comm,3) <> Round(ld_adr_comm,3) Then
			ls_message_string = "The address commission on the cargo is: "+string(Round(ld_cargo_adr_comm,3)) +" ~r~n" &
							+ "and on the C/P  is: " +string(Round(ld_adr_comm,3)) +"~r~n"
		End if
		If Round(ld_cargo_temp_comm,3) <> Round(ld_tmp_comm,3) Then
			ls_message_string += "The broker commission on the cargo is: "+string(Round(ld_cargo_temp_comm,3))+"~r~n" &
								+" and on the C/P it is: " +String(Round(ld_tmp_comm,3))
		End if

		If ls_message_string <> "" Then
			If not iuo_calc_nvo.iuo_calculation.ib_show_messages Then
				iuo_calc_nvo.iuo_calculation.is_message += ls_message_string +"~r~n~r~n"
			Else
				MessageBox("Information",ls_message_string)
			End if
		End If

		// Update the cargo with the calculated commission.
		If not isNull(ld_tmp_comm) Then dw_cargo_summary.SetItem(li_count, "cal_carg_temp_comission", Round(ld_tmp_comm,3))
		If not isnull(ld_adr_comm) Then dw_cargo_summary.SetItem(li_count, "cal_carg_adr_commision", Round(ld_adr_comm,3))
	End if
Next 

// Check if the Demurrage/Despatch setting has changed. Update our own cargo
// fields by coping or clearing.
If li_cp <> ii_reversible_cp[ai_cargo_no] Then

	ii_reversible_cp[ai_cargo_no] = li_cp
	
	li_current_cargo = uf_select_cargo(ai_cargo_no)

	// Call uf_reversible (which will take care of copying/clearing).
	uf_reversible(li_cp, dw_loadports, 0, ll_null, ld_null, ld_null, ld_null, ll_null, ld_null)

	// Copy despatch and demurrage from first loadport to all dischports.
	li_loadport = uf_get_first_loadport()
	If li_loadport  <> 0 Then
		dw_dischports.SetItem(1, "cal_caio_despatch", dw_loadports.GetItemNumber(li_loadport, "cal_caio_despatch"))
		dw_dischports.SetItem(1, "cal_caio_demurrage", dw_loadports.GetItemNumber(li_loadport, "cal_caio_demurrage"))
		uf_reversible(li_cp, dw_dischports, 0, ll_null, ld_null, ld_null, ld_null, ll_null, ld_null)
	End if

	uf_select_cargo(li_current_cargo)
	
	// Mark this as changed
	lb_changed = true
End if

// Check and update reversible frieght
If li_frt <> ii_reversible_freight[ai_cargo_no] Then

	// Reversible freight = 1 Then copy all freight-dependant fields from this
	// cargo to all other cargoes that uses the same CP. First copy out the data
	If li_frt = 1 Then
		ll_freight_type = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_freight_type")
		ld_ws_rate = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_ws_rate")
		ld_lumpsum = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_lumpsum")
		ld_freight_rate = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_freight_rate") 	
		ld_flat_rate = dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_flatrate")
		ld_min_1 = dw_cargo_summary.GetItemNumber(ai_cargo_no,"cal_carg_min_1")
		ld_min_2 =  dw_cargo_summary.GetItemNumber(ai_cargo_no,"cal_carg_min_2")
		ld_over_1 = dw_cargo_summary.GetItemNumber(ai_cargo_no,"cal_carg_overage_1")        
		ld_over_2 = dw_cargo_summary.GetItemNumber(ai_cargo_no,"cal_carg_overage_2")        		
	End if

	// and insert it into the cargoes.
	For ll_count = 1 To ii_no_cargos
		If ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_count, "cal_carg_cal_cerp_id") Then
			dw_cargo_summary.SetItem(ll_count, "cal_carg_freight_type", ll_freight_type)
			dw_cargo_summary.SetItem(ll_count, "cal_carg_ws_rate", ld_ws_rate)
			dw_cargo_summary.SetItem(ll_count, "cal_carg_lumpsum", ld_lumpsum)
			dw_cargo_summary.SetItem(ll_count, "cal_carg_freight_rate", ld_freight_rate) 	
			dw_cargo_summary.SetItem(ll_count, "cal_carg_flatrate", ld_flat_rate)
			dw_cargo_summary.SetItem(ll_count,"cal_carg_min_1", ld_min_1)
			dw_cargo_summary.SetItem(ll_count,"cal_carg_min_2", ld_min_2)
			dw_cargo_summary.SetItem(ll_count,"cal_carg_overage_1", ld_over_1)        
			dw_cargo_summary.SetItem(ll_count,"cal_carg_overage_2", ld_over_2)        	
			ii_reversible_freight[ll_count] = li_frt
		End if
	Next

	// Mark this cargo as changed.
	lb_changed = true
End if

// Clean up and exit.
uf_redraw_on()
Return(lb_changed)

end function

public subroutine uf_get_firstlast_port (ref string as_firstport, ref string as_lastport);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns first and last port used on voyage. 

 Arguments : as_firstport, as_lastport as ref string

 Returns   : None

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If ib_ballastvoyage Then
	// If ballast voyage then return ballast from and ballast to
	as_firstport = dw_cargo_summary.GetItemString(1,"cal_calc_ballast_from")
	as_lastport = dw_cargo_summary.GetItemString(1,"cal_calc_ballast_to")
Else
	// Otherwise find first and last port, by selecting all cargos, and sort
	// the dw_loadports/dw_dischports according to itinerary number. We can
	// then pull out the first and last port codes. 
	
	This.uf_redraw_off()
	uf_select_cargo(-1)

	dw_loadports.	SetSort("cal_caio_itinerary_number A")
	dw_loadports.Sort()
	as_firstport =dw_loadports.GetItemString(1,"port_code")

	dw_dischports.SetSort("cal_caio_itinerary_number D")
	dw_dischports.Sort()
	as_lastport = dw_dischports.GetItemString(1,"port_code")

	This.uf_redraw_on()
End if


end subroutine

public subroutine uf_retrieve (long al_calcid, ref datawindow adw_summary);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieved the given calculation (that is, cargoes on that calcid)

 Arguments : al_calcid, adw_summary (the calculation-summary-list datawindow)

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration

Long ll_count, ll_cerp_id
Long ls_cargo_id[]
Integer li_cp, li_frt
Double ld_null
Long  ll_max
Integer li_chart_nr
String ls_tmp, ls_chart

SetNull(ld_null)

// Remove all filter
uf_select_cargo(-1)

// Retrieve all cargos for this calculation
ii_no_cargos = dw_cargo_summary.Retrieve(al_calcid) 
COMMIT;

// Loop through # of cargoes, and check the itinerary order. A little processing
// is also done to check againts null-values
For ll_count = 1 To  ii_no_cargos
	If dw_cargo_summary.getItemNumber(ll_count, "cal_carg_cal_carg_order") <> ll_count Then &
		dw_cargo_summary.SetItem(ll_count,"cal_carg_cal_carg_order",ll_count)

	ls_cargo_id[ll_count] = dw_cargo_summary.GetItemNumber(ll_count,"cal_carg_id")	
	ii_reversible_cp[ll_count]	= 0
	ii_reversible_freight[ll_count] = 0
	
	if IsNull(dw_cargo_summary.GetItemNumber(ll_count,"cal_carg_local_flatrate")) Then &
		dw_cargo_summary.SetItem(ll_count,"cal_carg_local_flatrate",0)
	if IsNull(dw_cargo_summary.GetItemNumber(ll_count,"cal_carg_cal_carg_misc_income")) Then &
		dw_cargo_summary.SetItem(ll_count,"cal_carg_cal_carg_misc_income",0)
Next

// Retrieve data to Hidden data window for port expenses, hea/dev & misc. claims 
// and retrieve ports 
dw_calc_port_expenses.Retrieve(al_calcid)
COMMIT;

dw_calc_hea_dev_claim.Retrieve(al_calcid)
COMMIT;

dw_calc_misc_claim.Retrieve(al_calcid)
COMMIT;

dw_loadports.Retrieve(ls_cargo_id)
COMMIT;

dw_dischports.Retrieve(ls_cargo_id)
COMMIT;

dw_calc_lumpsum.settransobject( SQLCA )
dw_calc_lumpsum.Retrieve(ls_cargo_id)
COMMIT;

// Reset filter on load & dischports, so that all of them are shown
dw_loadports.SetFilter("")
dw_loadports.Filter()
dw_dischports.SetFilter("")
dw_dischports.Filter()
dw_calc_lumpsum.SetFilter("")
dw_calc_lumpsum.Filter()

// Update sort order for load & dischports
dw_loadports.SetSort("cal_caio_itinerary_number A")
dw_loadports.Sort()
dw_dischports.SetSort("cal_caio_itinerary_number A")
dw_dischports.Sort()

ii_current_cargo = -1

// Check and update locked-flags
uf_check_editlocked(al_calcid, adw_summary)

// Find highest itinerary number, and store in il_itinerary_max
Long ll_tmp, ll_count_to, ll_no_units, ll_count_three

ll_tmp = dw_loadports.RowCount()
If ll_tmp > 0 Then
	il_itinerary_max = dw_loadports.GetItemNumber(ll_tmp,"cal_caio_itinerary_number")
End if

// Validate in/out ports, and update if reading an old calculation (eg. 
// number of (units > 0) but no purpose_code given.
FOR ll_count_to = 1 TO ll_tmp
	
	ll_no_units = dw_loadports.GetItemNumber(ll_count_to,"cal_caio_number_of_units") 
	
	If ll_no_units > 0 and IsNull(dw_loadports.GetItemString(ll_count_to,"purpose_code")) Then
		 dw_loadports.SetItem(ll_count_to,"purpose_code","L") 
	Elseif ll_no_units = 0 and IsNull(dw_loadports.GetItemString(ll_count_to,"purpose_code")) Then
        	dw_loadports.SetItem(ll_count_to,"purpose_code","BUN") 
			dw_loadports.SetItem(ll_count_to,"cal_caio_rate_calculated",0)
			dw_loadports.SetItem(ll_count_to,"cal_caio_demurrage",0)
			dw_loadports.SetItem(ll_count_to,"cal_caio_despatch",0)
			dw_loadports.SetItem(ll_count_to,"cal_caio_noticetime",0)
		End If
NEXT

// Find highest itinerary number for dischports, and update il_itinerary_max
// if number is higher than current il_itinerary_max
ll_tmp = dw_dischports.RowCount()
ll_count_three = ll_tmp
If ll_tmp > 0 Then
	ll_tmp = dw_dischports.GetItemNumber(ll_tmp,"cal_caio_itinerary_number")
	If ll_tmp > il_itinerary_max Then il_itinerary_max = ll_tmp
End if	

// Loop through all dischports, and verify settings
FOR ll_count_to = 1 TO ll_count_three
	ll_no_units = dw_dischports.GetItemNumber(ll_count_to,"cal_caio_number_of_units")
	If IsNull(dw_dischports.GetItemString(ll_count_to,"purpose_code")) Then
		 dw_dischports.SetItem(ll_count_to,"purpose_code","D") 
	End If
NEXT

// Loop through all cargos, and update the reversible status, by looking
// at the linked CP (if any) and copy that information to the cargo
For ll_count = 1 To  ii_no_cargos

	// Get CP id
	ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_count, "cal_carg_cal_cerp_id")

	// And select reversible demurrage and reversible freight information
	If ll_cerp_id > 0 Then
		SELECT CAL_CERP_REV_DEM,
			CAL_CERP_REV_FREIGHT
		INTO :li_cp,
			:li_frt
		FROM CAL_CERP
		WHERE CAL_CERP_ID = :ll_cerp_id;
		COMMIT;
	End if

	// If reversible demurrage or freight then update calculation.
	If (li_cp = 1 or li_frt = 1) Then
		uf_update(ll_count)
	Elseif dw_cargo_summary.GetItemNumber(ll_count, "cal_carg_cal_carg_reversible") = 1 Then
		uf_select_cargo(ll_count)

Integer li_dummy
Double ld_dummy
SetNull(li_dummy)
SetNull(ld_dummy)

		// And copy information between cargoes.
		uf_reversible(1, dw_loadports, 0, li_dummy, ld_dummy, ld_dummy, ld_dummy, li_dummy, ld_dummy)
		uf_reversible(1, dw_dischports, 0, li_dummy, ld_dummy, ld_dummy, ld_dummy, li_dummy, ld_dummy)
	End if
next

COMMIT USING SQLCA;

// Get charteres name into compute field. This is done because a table join like this one
// isn't allowed in Sybase
ll_max = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.RowCount()
For ll_count = 1 To ll_max 
	li_chart_nr = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.GetItemNumber(ll_count, "cal_cerp_chart_nr")
	If Not(isnull(li_chart_nr)) Then

		SELECT CHART.CHART_SN
		INTO :ls_tmp
		FROM CHART
		WHERE (CHART_NR = :li_chart_nr);
		COMMIT;

		iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.SetItem(ll_count, "compute_0046", ls_tmp)
		// Line below is obsolete and should be deleted
		ls_chart = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.GetItemstring(ll_count,"compute_0046")
	End if
Next


// Reset updates (otherwise the calc. would have status as changed)
dw_cargo_summary.ResetUpdate()
dw_loadports.Resetupdate()
dw_dischports.Resetupdate()

ii_current_cargo = 0

// And tell the rest of the calculation system, that the calculation has changed
uf_port_changed()

// Select cargo 1, and we're done
uf_select_cargo(1)
dw_cargo_summary.SetFocus()

end subroutine

public subroutine uf_set_ballast_voyage (boolean ab_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Set ballast_voyage state, true removes all data, so that only one 
 					cargo w/ no ports exists

 Arguments : as_value, false = normal voyage, true = ballast voyage

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_max, li_count
Boolean lb_insertrow

// Turn redraw off, and set instance variable IB_BALLASTVOYAGE to 
// argument value
This.uf_redraw_off()
ib_ballastvoyage = ab_value

// Mark that we need to insert a new row, if rowcount is > 0
lb_insertrow = dw_cargo_summary.RowCount()>0

CHOOSE CASE ab_value
	CASE false 
		// ab_value is false, meaning that the current cargo should be converted
		// to a normal calculation. Insert a loadport and a dischport, set them
		// both visible and change the dataobject for the cargo summary vindow
		// to the cargo summary window.
		of_insertport( dw_loadports)
		of_insertport( dw_dischports)

		dw_loadports.visible=true
		dw_dischports.visible=true

		dw_cargo_summary.DataObject = "d_calc_cargo_summary"

	CASE true 
		// ab_value is true, meaning that the current cargo should be converted
		// to a ballast calculation. Remove all load and dischports, and delete
		// cargoes, so we only have one cargo left. Finally hide the load and
		// dischports windows and change the dataobject for the cargo_summary
		// to be the ballasted datawindow.

		This.uf_select_cargo(-1)
		
		li_max = dw_loadports.Rowcount()
		For li_count = li_max To 1 Step -1
			dw_loadports.DeleteRow(li_count)
		Next

		li_max = dw_dischports.RowCount()
		For li_count = li_max To 1 Step -1
			dw_dischports.DeleteRow(li_count)
		Next

		li_max = dw_cargo_summary.RowCount()
		For li_count = li_max To 2 Step -1
			dw_cargo_summary.DeleteRow(li_count)
		Next

		dw_loadports.visible=false
		dw_dischports.visible=false
		
		dw_cargo_summary.DataObject = "d_calc_cargo_summary_ballasted"
END CHOOSE

// Setup the transactionobject (needed everytime then dataobject changes)
dw_cargo_summary.SetTransObject(SQLCA)
// and insert a cargo is flag is set.
If lb_insertrow Then Uf_Insert_cargo(false)

This.uf_redraw_on()

end subroutine

public function string uf_get_dischport_name (ref s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1997

 Description : Returns portname for cargo and port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


string ls_name, ls_port_code

uf_select_cargo(astr_port_parm.i_cargo_number)

ls_port_code = string(dw_dischports.GetItemString(astr_port_parm.i_port_no,"port_code"))

SELECT PORT_N
INTO :ls_name
FROM PORTS
WHERE PORT_CODE = :ls_port_code ;
COMMIT;

return(ls_name)
end function

public function long uf_insert_cargo (boolean ab_insertports);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1996

 Description : Inserts a new cargo + 1 loadport + 1 dischport (ports are optional) 
 					into the calculation
 
 Arguments : ab_insertports if load and dischports should be inserted
 
 Returns   : The rownumber for the new cargo

*************************************************************************************/

// Insert cargo row in calcuation
ii_no_cargos = dw_cargo_summary.InsertRow(0)
dw_cargo_summary.ScrollToRow(ii_no_cargos)

// Set reversible status to not reversible (freight and demurrage)
ii_reversible_cp[ii_no_cargos] = 0
ii_reversible_freight[ii_no_cargos] = 0

// Set cargofields to default values
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_status",2)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_order", ii_no_cargos)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_description","<New cargo "+String(ii_no_cargos)+">")
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_freight_type",1)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_add_days_laden",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_add_days_ballast",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_days_other",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_idle_days",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_bunkering_days",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_add_days_type",1)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_expenses",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_fo",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_do",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_mgo",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_temp_comission",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_adr_commision",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_min_1",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_min_2",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_overage_1",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_overage_2",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_add_days_ballast_pcnt",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_days_laden_pcnt",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_local_flatrate",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_misc_income",0)

// Set default demurrage reversible to false if profitcenter is 3 or 5, otherwise set
// default reversible to true
Integer li_profit_center
li_profit_center = uo_global.get_profitcenter_no( )
If (li_profit_center = 3 Or li_profit_center = 5) Then
	dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_reversible",0)
Else
	dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_reversible",1)
End If

// Insert the ports, if ab_insertports is true
If ab_insertports Then
	of_insertport(dw_loadports)
	of_insertport(dw_dischports)
End if

// and trigger the ue_childmodified event to tell the rest of the system that the
// calculation has changed.
Parent.TriggerEvent("ue_childmodified")

// Return the new rownumber
Return(ii_no_cargos)
		


end function

public function integer uf_get_rate_type (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the ratetype for cargo no. given in ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : Ratetype as integer

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

If (ai_cargo_no>0) And (ai_cargo_no <= ii_no_cargos) Then
	Return(dw_cargo_summary.GetItemNumber(ai_cargo_no, "cal_carg_freight_type"))
Else
	Return(0)
End if

end function

public subroutine uf_restore_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 9-1-97

 Description : Restores ID for cargo in/out's, upon save failures. 
	*** This procedure Should only be called from u_calculation.uf_save. ***

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variabel decleration

Integer li_cargo_rows, li_cargo_count, li_count, li_max
Long ll_tmp
String ls_filter

// Do not process ballast voyages, since they don't have any cargo in/outs
If ib_ballastvoyage then return 

li_max = UpperBound(il_new_cargo_id)

// Loop through all cargos, and update the load/dischport ID's to
// with the original ID's
li_cargo_rows = dw_cargo_summary.RowCount()
For li_cargo_count = 1 To li_cargo_rows

	// Set filter on current cargo value

	If li_cargo_count <= li_max Then
		ls_filter = "cal_carg_id = " + String(il_new_cargo_id[li_cargo_count]);

		dw_loadports.SetFilter(ls_filter)
		dw_loadports.Filter()
		dw_dischports.SetFilter(ls_filter)	
		dw_dischports.Filter()
		dw_calc_lumpsum.SetFilter(ls_filter)	
		dw_calc_lumpsum.Filter()

		// Modify load & Disch to old values
	
		li_max = dw_loadports.RowCount()	
		For li_count = 1 To li_max
			dw_loadports.SetItem(li_count, "cal_carg_id", il_original_ports_id[li_cargo_count])
		Next

		li_max = dw_dischports.RowCount()
		For li_count = 1 To li_max
			dw_dischports.SetItem(li_count, "cal_carg_id", il_original_ports_id[li_cargo_count])
		Next
		
		li_max = dw_calc_lumpsum.RowCount()
		For li_count = 1 To li_max
			dw_calc_lumpsum.SetItem(li_count, "cal_carg_id", il_original_ports_id[li_cargo_count])
		Next

		// And update cargo_summary value
		ll_tmp = il_original_cargo_id[li_cargo_count]
		If ll_tmp < 0 Then SetNull(ll_tmp)
		dw_cargo_summary.SetItem(li_cargo_count, "cal_carg_id", ll_tmp)
	End if
Next

end subroutine

public subroutine uf_port_changed ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Will notify the rest of the calculation system than a port has
 					been changed. This is needed to update cargo selection list-boxes,
					itinerary etc. etc

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


TriggerEvent("ue_childmodified")
Parent.TriggerEvent("ue_port_changed")
end subroutine

public subroutine uf_reset_voyagetype ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Resets the voyage type to normal datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_cargo_summary.DataObject = "d_calc_cargo_summary"
dw_cargo_summary.SetTransObject(SQLCA)
ib_ballastvoyage = false


end subroutine

public function long uf_get_cargo_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the cargo id for the current cargo

 Arguments : None

 Returns   : Cargo id, or 0 if no cargo is the current  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If ii_current_cargo > 0 Then
	Return(dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_carg_id"))
Else
	Return(0)
End if


end function

public subroutine uf_set_no_cargos (integer ai_no_cargos);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the number of cargos as given in ai_no_cargos, by either creating
 					or deleting cargos. This procedure is called by the Wizard to set the
					number of cargoes in the calculation.

 Arguments : ai_no_cargos as integer, 

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Do While ai_no_cargos <> ii_no_cargos
	If ai_no_cargos > ii_no_cargos Then uf_insert_cargo(true) Else	uf_delete_cargo(ii_no_cargos)
Loop
end subroutine

public subroutine uf_unlock ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-5-97

 Description : Unlocks the whole calculated calculation, by setting the locked values
 					to 0.

 Arguments : none

 Returns   : none

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
5-5-97		4.05			MI		Initial version  
************************************************************************************/

Integer li_current_cargo, li_max, li_count

uf_redraw_off()

// Enable all cargos
li_current_cargo = uf_select_cargo(-1)

// Loop through the loadports, dischports and cargo summary and set 
// the locked value to 0.
li_max = dw_loadports.RowCount()
For li_count = 1 To li_max 
	dw_loadports.SetItem(li_count, "edit_locked", 0)
Next

li_max = dw_dischports.RowCount()
For li_count = 1 To li_max 
	dw_dischports.SetItem(li_count, "edit_locked", 0)
Next

li_max = dw_cargo_summary.RowCount()
For li_count = 1 to li_max
	dw_cargo_summary.SetItem(li_count, "locked", 0)
Next

li_max = dw_calc_lumpsum.RowCount()
For li_count = 1 to li_max
	dw_calc_lumpsum.SetItem(li_count, "locked", 0)
Next

// Reselect the old cargo
uf_select_cargo(li_current_cargo)
uf_redraw_on()
end subroutine

private subroutine uf_set_caio_id (ref datawindow adw_datawindow, long al_carg_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates load/disch port datawindows with al_carg_id

 Arguments : adw_datawindow as datawindow, al_carg_id as Long

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Long ll_rows, ll_count, ll_tmp

ll_rows = adw_datawindow.RowCount()
For ll_count = 1 To ll_rows 
	ll_tmp = adw_datawindow.GetItemNumber(ll_count, "cal_carg_id")
	If IsNull(ll_tmp) Or (ll_tmp<>al_carg_id) Then 	adw_datawindow.SetItem(ll_count,"cal_carg_id",al_carg_id)
Next
end subroutine

public function boolean uf_save (long al_calc_id, boolean ab_resetflags, long al_estimated_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-8-96

 Description : Saves cargos and cargo in-outs, given the current CALC_ID in 
 					AL_CALC_ID. If the updatedate flags should be reset after update,
					AB_RESETFLAGS should be true (default is false). 
					
					When updating a CALCULATED calculation AL_ESTIMATED_CALC_ID must
					contain the ID for the corrosponding ESTIMATED calucation.

 Arguments : AL_CALC_ID as long , AB_RESETFLAGS as boolean, 
 				 AL_ESTIMATED_CALC_ID as long

 Returns   : True if ok.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_deleted, li_cargo_count, li_max, li_tmp, li_del_order, li_settled
Long ll_cargo_rows,  ll_carg_id, ll_del_carg_id, ll_tmp, ll_count
Boolean lb_result
Long ll_clear[]

dw_calc_lumpsum.modifiedcount( )

// Store estimated AL_ESTIMATED_CALC_ID in IL_ESTIMATED_CALC_ID. The reason for this 
// is that during the execution of this code datawindow.update is being called, which
// calls on to the uf_sqlpreview function, that needs the il_estimated_calc_id.

il_estimated_calc_id = al_estimated_calc_id

// Check that we have at least one cargo.
ll_cargo_rows = dw_cargo_summary.RowCount()
If ll_cargo_rows < 1 Then
	MessageBox("Error", "You need to create at least one cargo before you can save", StopSign!)
	Return(False)
End if

// Update the CAL_CALC_ID in all cargo rows
For li_cargo_count = 1 To ll_cargo_rows 
	ll_tmp = dw_cargo_summary.GetItemNumber(li_cargo_count, "cal_calc_id")
	If IsNull(ll_tmp) Or ll_tmp <> al_calc_id Then dw_cargo_summary.SetItem(li_cargo_count,"cal_calc_id",al_calc_id)
Next 

// If AL_ESTIMATED_CALC_ID <> 0, then we're currently saving an calculated and
// we need also to update the estimated calculation (AL_ESTIMATED_CALC_ID contains
// the ID of the estimated calculation). 
//
// To "link" the estimated and calculated calculations together, we build an
// array of the estimated and calculated CARGO_ID's

If al_estimated_calc_id<>0 Then

	// Build the list of estimated and calculated ID's. We link the estimated
	// and calculated together by using the CAL_CALC_ID and the cargo order.

	For ll_count = 1 To ll_cargo_rows 
		istr_calc_to_est[ll_count].l_calculated = dw_cargo_summary.GetItemNumber(ll_count, "cal_carg_id")

		SELECT CAL_CARG_ID
		INTO :istr_calc_to_est[ll_count].l_estimated  
		FROM CAL_CARG
		WHERE (CAL_CALC_ID = :al_estimated_calc_id AND
			CAL_CARG_ORDER = :ll_count);
	Next
End if

// Update any connected misc. expenses. Since misc. exp only can be connected 
// to a SAVED port, this little thing should work... ahem
lb_result = dw_calc_port_expenses.Update(true, ab_resetflags) =  1 

li_deleted = dw_cargo_summary.DeletedCount()
If (lb_result) and (li_deleted > 0) Then

	// Delete Problem fix 
	// When deleting a cargo from the calculation, the update order has to be reversed, because we'll
	// otherwise will get an "dependent parent" upon updating. Now, If there's also one or more  new cargo's
	// it wont work, because each required the reversed update-order.
	//	
	// Insert: Update Cargos, then cargo inouts
	// Delete: Update cargo inouts, then cargos.
	// 
	// To solve this problem, we use the Martini Smart Deletion (TM) (C) algorithm; If theres something to
	// Delete, then deleted the depending cargo inout's first, and remove them from the Delete buffer
	// so that PB dosn't try to delete them.
	//
	// In case the load/disch update fails, we have a problem, since we won't be able to restore the 
	// rows from in the datawindow (so by next save, it will go wrong). This can only happen, if
	// we'll get an Database error during the update, but since all field are checked before saveing,
	// we might never get a problem with that.

	// Loop through all deleted cargoes.
	For li_cargo_count = 1 To li_deleted
		
		// Get CAL_CARG_ID and CAL_CARG_ORDER from the deleted cargo
		ll_del_carg_id = dw_cargo_summary.GetItemNumber(li_cargo_count, "cal_carg_id", Delete!, True)
		li_del_order = dw_cargo_summary.GetItemNumber(li_cargo_count, "cal_carg_cal_carg_order", Delete!, True)

		If ll_del_carg_id > 0 Then
			// An deleted cargo was found. Add deleted CARG_ID to the
			// ISTR_CALC_TO_EST table
			li_tmp = UpperBound(istr_calc_to_est) + 1
			istr_calc_to_est[li_tmp].l_calculated = ll_del_carg_id

			// and find the corrosponding estimated ID and put it in the
			// ISTR_CALC_TO_EST array to.
			SELECT CAL_CARG_ID
			INTO :istr_calc_to_est[li_tmp].l_estimated  
			FROM CAL_CARG
			WHERE (CAL_CALC_ID = :al_estimated_calc_id AND
				CAL_CARG_ORDER = :li_del_order);

			// Ok, our ISTR_CALC_TO_EST array has been updated, now delete
			// calculated CAIO's directly on the server.
			DELETE
			FROM CAL_CAIO
			WHERE CAL_CARG_ID = :ll_del_carg_id;
			
			// If this is the calculated, then delete childs for estimated
			// using the values from ISTR_CALC_TO_EST
			If (al_estimated_calc_id>0) And (SQLCA.SQLCode=0) Then
				DELETE
				FROM CAL_CAIO
				WHERE CAL_CARG_ID = :istr_calc_to_est[li_tmp].l_estimated;
			End if
			
			//delete calulation lumpsums
			If SQLCA.SQLCode=0 Then
				DELETE
				FROM CAL_LUMP
				WHERE CAL_CARG_ID = :ll_del_carg_id;
			end if		
			If (al_estimated_calc_id>0) And (SQLCA.SQLCode=0) Then
				DELETE
				FROM CAL_LUMP
				WHERE CAL_CARG_ID = :istr_calc_to_est[li_tmp].l_estimated;
			End if
				
			If SQLCA.SQLCode<>0 Then
				MessageBox("System error", "Error deleting cargo childs code "+String(SQLCA.SQLCode)+" "+SQLCA.SQLErrText)
				Return(False)
			End if
		End if
	Next 

	// Ok, Load/disch ports has now been deleted manually from the database. Tell
	// Powerbuilder that it shouldn't try to delete the rows, by discharding the
	// rows from the deleted buffer.

	uf_select_cargo(-1)

	li_deleted = dw_loadports.DeletedCount()
	If li_deleted > 0 Then dw_loadports.RowsDiscard(1, li_deleted, Delete!)

	li_deleted = dw_dischports.DeletedCount()
	If li_deleted > 0 Then dw_dischports.RowsDiscard(1, li_deleted, Delete!)
	
	li_deleted = dw_calc_lumpsum.DeletedCount()
	If li_deleted > 0 Then dw_calc_lumpsum.RowsDiscard(1, li_deleted, Delete!)

	uf_select_cargo(1)
End if

// Clear lists of original ID's. These lists is updated with ID's BEFORE
// the calculation is saved, and is used to restore ID's if anything happens
// during the save process.
il_new_cargo_id = ll_clear 
il_original_cargo_id = ll_clear
il_original_ports_id = ll_clear

// Update the summary, hea/dev and misc claims.
If lb_result then lb_result =  dw_cargo_summary.Update(true,ab_resetflags)=1
If lb_result then lb_result = dw_calc_hea_dev_claim.Update(true, ab_resetflags) = 1
If lb_result then lb_result = dw_calc_misc_claim.Update(true, ab_resetflags) = 1

If lb_result Then 
	// It's time to save the cargo in/out (ports). Loop through all cargoes
	// and update the ISTR_CALC_TO_EST table, for new modifications that might
	// have been made to the CAL_CARG_ID. Finally update the CAIO's to point 
	// to the correct CAL_CARG_ID

	For li_cargo_count = 1 To ll_cargo_rows 

		// Select the CARG_ID from the CARG_TABEL. This ID will now have
		// a valid value.

		SELECT CAL_CARG.CAL_CARG_ID
		INTO :ll_carg_id
		FROM CAL_CARG
		WHERE CAL_CARG.CAL_CALC_ID = :al_calc_id and
			CAL_CARG.CAL_CARG_ORDER = :li_cargo_count
		USING SQLCA;

		// Store ID's for recovery 
		il_original_cargo_id[li_cargo_count] = dw_cargo_summary.GetItemNumber(li_cargo_count, "cal_carg_id")
		il_new_cargo_id[li_cargo_count] = ll_carg_id

		If il_estimated_calc_id>0 Then
			// Se if this cargo exists in the istr_calc_to_est table
			
			li_max = UpperBound(istr_calc_to_est)
			For li_tmp = 1 To li_max
				If istr_calc_to_est[li_tmp].l_calculated = ll_carg_id Then
					li_tmp = 0 
					Exit
				End if
			Next
			
			If li_tmp <> 0 Then
				// It wasnt in the table, get estimated ID into calc_to_est table

				li_max ++
				istr_calc_to_est[li_max].l_calculated = ll_carg_id
	
				SELECT CAL_CARG.CAL_CARG_ID
				INTO :istr_calc_to_est[li_max].l_estimated
				FROM CAL_CARG
				WHERE CAL_CARG.CAL_CALC_ID = :il_estimated_calc_id and
				CAL_CARG.CAL_CARG_ORDER = :li_cargo_count
				USING SQLCA;
			End if
		End if

		// Select current cargo
		uf_select_cargo(li_cargo_count)
		
		// Store original cargo id for recovery
		If not ib_ballastvoyage Then
			il_original_ports_id[li_cargo_count] = dw_loadports.GetItemNumber(1, "cal_carg_id")
		End if

		// And make the CAIO's point to this cargo.
		uf_set_caio_id(dw_loadports,ll_carg_id)
		uf_set_caio_id(dw_dischports,ll_carg_id)
		uf_set_caio_id(dw_calc_lumpsum,ll_carg_id)
	Next

	// Finally, we update the load and dischports table.
	lb_result = dw_loadports.update(true,ab_resetflags) = 1
	If lb_result Then 
		lb_result = dw_dischports.update(true,ab_resetflags) = 1			
	End if
	If lb_result Then 
		lb_result = dw_calc_lumpsum.update(true,ab_resetflags) = 1			
	End if
	If lb_result Then
//		lb_result = dw_port_exp_all.Update(true,ab_resetflags) = 1
	End if
End if

// Clear the ISTR_CALC_TO_EST array and il_estimated_calc_id
s_calculated_to_estimated lstr_tmp[]
istr_calc_to_est = lstr_tmp  
il_estimated_calc_id = 0

// Return result
Return(lb_result)
	

end function

public function boolean uf_get_cargo_locked ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns true if current cargo is locked

 Arguments : None

 Returns   : Boolean

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return dw_cargo_summary.GetItemNumber(ii_current_cargo, "locked") > 0

end function

public subroutine uf_misc_claims (long al_cargo_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit Aunt
   
 Date       : 1997

 Description : ?

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Integer li_max, li_tmp, li_gross_frt
s_misc_claims null_array[]
istr_hea_dev_misc_parm.array_misc_claims[] = null_array[]

li_max = dw_calc_misc_claim.RowCount()
For li_tmp = 1 to li_max
	If al_cargo_id =  dw_calc_misc_claim.GetItemNumber(li_tmp,"cal_carg_id") Then
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].s_claim_type = dw_calc_misc_claim.GetItemString(li_tmp,"claim_type")
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].d_claim_amount = dw_calc_misc_claim.GetItemNumber(li_tmp,"cal_clmi_amount")
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].i_addrs_comm_claim = dw_calc_misc_claim.GetItemNumber(li_tmp,"cal_clmi_address_commision")
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].i_broker_comm_claim = dw_calc_misc_claim.GetItemNumber(li_tmp,"cal_clmi_broker_commission")
	
		SELECT CLAIM_TYPES.CLAIM_GROSS_FRT
		INTO :li_gross_frt
		FROM CLAIM_TYPES
		WHERE CLAIM_TYPES.CLAIM_TYPE  = :istr_hea_dev_misc_parm.array_misc_claims[li_tmp].s_claim_type ;
		COMMIT;
	
		// Determin wheter the result is added to gross freight or misc. income
		If li_gross_frt = 1 Then
			istr_hea_dev_misc_parm.array_misc_claims[li_tmp].i_gross_freight_yes = 1
		Else
			istr_hea_dev_misc_parm.array_misc_claims[li_tmp].i_gross_freight_yes = 0
		End if
	End if
Next
	
	
end subroutine

public subroutine uf_heat_dev (long al_cargo_id, s_calculation_parm astr_calculation_parm, long al_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1997

 Description : Copies Heating/Deviation information for the cargo given in
 					al_cargo_id, and cargo given in al_cargo_no. Stores information
 					to the istr_hea_dev_misc_parm array
 
 Arguments : al_cargo_id as Long, astr_calculation_parm as s_calculation_parm and
 				 al_cargo_no as Long

 Returns   : None

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

Integer li_max, li_tmp, li_gross_frt
s_heat_dev null_array[]
istr_hea_dev_misc_parm.array_heat_dev[] = null_array[]

li_max = dw_calc_hea_dev_claim.RowCount()
For li_tmp = 1 to li_max
	If al_cargo_id =  dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_carg_id") Then
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].s_claim_type = dw_calc_hea_dev_claim.GetItemString(li_tmp,"claim_type")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hfo_ton = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_hfo_ton")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hfo_price = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_hfo_price")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_do_ton = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_do_ton")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_do_price = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_do_price")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_go_ton = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_go_ton")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_go_price = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_go_price")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_lshfo_ton = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_lshfo_ton")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_lshfo_price = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_lshfo_price")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_hea_dev_hours = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_hea_dev_hours")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hea_dev_price_day = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_hea_dev_price_pr_day")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_addrs_comm_bunker = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_adr_comm_bunker")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_broker_comm_bunker = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_broker_comm_bunker")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_addrs_comm_hours = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_adr_comm_hours")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_broker_comm_hours = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"cal_hedv_broker_comm_hours")
	
		// Find out if heating, deviation and bunker is added to gross freight
		SELECT CLAIM_TYPES.CLAIM_GROSS_FRT
		INTO :li_gross_frt
		FROM CLAIM_TYPES
		WHERE CLAIM_TYPES.CLAIM_TYPE  = :istr_hea_dev_misc_parm.array_heat_dev[li_tmp].s_claim_type ;
		COMMIT;
	
		// Determin wheter the result is added to gross freight or misc. income
		If li_gross_frt = 1 Then
			istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_gross_freight_yes = 1
		Else
			istr_hea_dev_misc_parm.array_heat_dev[li_tmp].i_gross_freight_yes = 0
		End if
	End if
Next

// The following data is used to calculate heating, devation and misc claims, but are
// only loaded here
istr_hea_dev_misc_parm.d_addrs_comm_pct = & 
				astr_calculation_parm.cargolist[al_cargo_no].d_adr_commission_percent
istr_hea_dev_misc_parm.d_broker_comm_pct = & 
				astr_calculation_parm.cargolist[al_cargo_no].d_commission_percent

// Initialice the result fields to zero
istr_hea_dev_misc_parm.d_gross_freight_amount = 0
istr_hea_dev_misc_parm.d_misc_income_amount = 0
istr_hea_dev_misc_parm.d_addrs_comm_amount = 0
istr_hea_dev_misc_parm.d_broker_comm_amount = 0

end subroutine

public function integer uf_get_revers_freight (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the reversible freight value for cargo given in ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : 0 = not reversible, other values indicates reversible freight

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

Return (ii_reversible_freight[ai_cargo_no])

end function

public function long uf_get_cerp_id (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the C/P ID for cargo ai_cargo_no. Set ai_cargo_no to 0 to
 	get the C/P id for the C/P connected to the current cargo

 Arguments : ai_cargo_no as Long

 Returns   : C/P id as long

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If ai_cargo_no = 0 Then ai_cargo_no = dw_cargo_summary.GetRow()
Return(dw_cargo_summary.GetItemNumber(ai_cargo_no,"cal_carg_cal_cerp_id"))
end function

public function integer uf_get_reversible (long al_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the reversible demurrage value for cargo given in ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : 0 = not reversible, 1 = reversible

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

Return (dw_cargo_summary.GetItemNumber(al_cargo_no,"cal_carg_cal_carg_reversible"))

end function

public subroutine uf_reversible (integer ai_function_code, ref datawindow adw_datawindow, integer as_set_field, integer ai_raty_id, double ad_rate_estimated, double ad_despatch, double ad_demurrage, integer ai_terms, double ad_rate_calculated);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_calc_cargos

 Function : uf_reversible
  
 Event	 : 

 Scope     : Object global

 ************************************************************************************

 Author    : MIS
   
 Date       : 22-8-96

 Description : This procedure updates all reversible-demurrage information. uf_reversible
 		can work in one of two modes (depending on ai_function_code). If ai_function_code is
		0, all reversible-fields will be reset to default values. This is used, whenever 
		the reversibleflag goes from reversible to non-reversible. For ai_function_code 1,
		values are copied to or between all reversible fields on cargoes with the same CP. 
		ai_set_field designates which field(s) to set, and ai/ad (field) arguments can be 
		used to set a field value. 
		
		Example (function_code = 0):
		All fields are cleared.
		
		Example (function code = 1):
		For each field (estimated, calculated, terms etc): If value is given as parameter
		the this value is copied to all reversible ports, otherwise the value is taken
		from the current row in adw_datawindow. 
		

 Arguments : ai_function_code: 0: Clear values, 1: Set values
			adw_datawindow = datawindow to be processed
			as_set_field: 0 : Set all, 1: locked, 2: set raty, 3: set estimated, 
								4: set despatch, 5: set demurrage
			raty_id value as Integer or NULL to copy first found value
			estimated value as Double or NULL to copy first found value
			despatch value as Double or NULL to copy first found value
			Demurrage value as Double or NULL to copy first found value
			Calculated value as Double or NULL to copy first found value

 Returns   : None

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


// uf_reversible
// Function code: 1: Set, 0: Clear, -1: update
// as_set_field: 0 : Set all, 1: locked, 2: set raty, 3: set estimated, 4: set despatch, 5: set demurrage, 6: terms

Long ll_rowcount, ll_count, ll_cerp_id, ll_cargo_row
Integer li_dw_count, li_current_dw, li_count
String ls_tmp

// Check if there is anything to do, otherwise exit
If adw_datawindow.Rowcount()=0 Then Return

// Turn redraw of
uf_redraw_off()

If ai_function_code=0 Then
	// Function code was 0, which means that all values should be set to default
	SELECT MIN(CAL_RATY_ID)
	INTO :ai_raty_id
	FROM CAL_RATY;
	COMMIT;

	ad_rate_estimated = 0
	ad_rate_calculated = 0
	ad_despatch = 0
	ad_demurrage = 0
	ai_terms = 0
Else
	// Function case was 1, which means that we want to set a value. Find first port
	// (either load or disch, depending on adw_datawindow), that will be used as value
	// if the set_field value is null
	If adw_datawindow = dw_loadports Then
		li_count = uf_get_first_loadport()
		If li_count = 0 Then return // Unable to find values for loadports
	Else
		li_count = 1
	End if

	// Update set_field values that are null from the datawindow
	If IsNull(ai_raty_id) Then ai_raty_id = adw_datawindow.GetItemNumber(li_count,"cal_raty_id")
	If IsNull(ad_rate_estimated) Then ad_rate_estimated = adw_datawindow.GetItemNumber(li_count,"cal_caio_rate_estimated")
	If IsNull(ad_rate_calculated) Then ad_rate_calculated = adw_datawindow.GetItemNumber(li_count, "cal_caio_rate_calculated")
	If IsNull(ad_despatch) Then ad_despatch = adw_datawindow.GetItemNumber(li_count,"cal_caio_despatch")
	If IsNull(ad_demurrage) Then ad_demurrage = adw_datawindow.GetItemNumber(li_count,"cal_caio_demurrage")
	If IsNull(ai_terms) Then ai_terms = adw_datawindow.GetItemNumber(li_count, "cal_caio_load_terms")
End if


// Get current row, due to some kind of PB4 bug (the locked row problem), we might get
// 0 back. In that case we just set it to 1.
ll_cargo_row =  dw_cargo_summary.GetRow()
If ll_cargo_row = 0 Then ll_cargo_row = 1

// Get the CP ID and current row in the datawindow
ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_cargo_row, "cal_carg_cal_cerp_id")
li_current_dw = ll_cargo_row

// Loop through all cargoes. If CP ID on a cargo equals and it is reversible with our
// (original) cargo, then we can copy the information.
For li_dw_count = 1 To ii_no_cargos 
	If (ll_cerp_id = dw_cargo_summary.GetItemNumber(li_dw_count, "cal_carg_cal_cerp_id")  & 
	And (ai_function_code = ii_reversible_cp[li_dw_count] )) Or (li_dw_count = li_current_dw) Then 

		// Check for change back

		// Select this cargo for modifications
		uf_select_cargo(li_dw_count)

		// Update reversible on datawindow, if the cp is reversible
		If ii_reversible_cp[li_dw_count] = 1 Then dw_cargo_summary.SetItem(li_dw_count, "cal_carg_cal_carg_reversible", 1)
	
		// Go through all ports on the datawindow, and update the fields, depending on the set_field
		// value. This happens only for "L" and "D" purpose type.
		ll_RowCount = adw_datawindow.RowCount()
		For ll_count = 1 To ll_rowcount
			If (as_set_field=0) or (as_set_field=1) Then adw_datawindow.SetItem(ll_count, "locked", ai_function_code)	

			ls_tmp = adw_datawindow.GetItemString(ll_count, "purpose_code")

			If ls_tmp = "L" or ls_tmp = "D" Then
				If (as_set_field=0) or (as_set_field=2) Then adw_datawindow.SetItem(ll_count, "cal_raty_id", ai_raty_id)
				If (as_set_field=0) or (as_set_field=3) Then adw_datawindow.SetItem(ll_count, "cal_caio_rate_estimated", ad_rate_estimated)
				If (as_set_field=0) or (as_set_field=4) Then adw_datawindow.SetItem(ll_count, "cal_caio_despatch", ad_despatch)
				If (as_set_field=0) or (as_set_field=5) Then adw_datawindow.SetItem(ll_count, "cal_caio_demurrage", ad_demurrage)
				If (as_set_field=0) or (as_set_field=6) Then adw_datawindow.SetItem(ll_count, "cal_caio_load_terms", ai_terms)	
				If (as_set_field=0) or (as_set_field=7) Then adw_datawindow.SetItem(ll_count, "cal_caio_rate_calculated", ad_rate_calculated)
			End if
		Next
	End if
Next

// Change back to current cargo
uf_select_cargo(li_current_dw)

// And turn redraw back on
uf_redraw_on()



end subroutine

public function integer uf_get_first_loadport ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 4-6-97

 Description : Returns the first loadport for current cargo, where purpose is L (loading)

 Arguments : None

 Returns   : First loadport row no or 0 if no loadports

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count, li_max

li_count = 1

// Find first loadport row
li_max = dw_loadports.RowCount()

Do While li_count <= li_max
	If dw_loadports.GetItemString(li_count, "purpose_code") = "L" Then Return li_count
	li_count ++
Loop

Return 0


end function

public function string uf_get_lport_name_purpose (s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1997

 Description : Returns portname, purpose and purposecode for cargo and 
 					port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

string ls_name, ls_port_code, ls_purpose, ls_name_purpose

uf_select_cargo(astr_port_parm.i_cargo_number)

ls_port_code = string(dw_loadports.GetItemString(astr_port_parm.i_port_no,"port_code"))
ls_purpose = dw_loadports.GetItemString(astr_port_parm.i_port_no, "purpose_code")
ls_purpose = "&&" + ls_purpose

SELECT PORT_N
INTO :ls_name
FROM PORTS
WHERE PORT_CODE = :ls_port_code ;
COMMIT;

ls_name_purpose = ls_name + ls_purpose
return(ls_name_purpose)
end function

public function string uf_get_dport_name_purpose (s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1997

 Description : Returns portname, purpose and purposecode for cargo and 
 					port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


string ls_name, ls_port_code, ls_purpose, ls_name_purpose

uf_select_cargo(astr_port_parm.i_cargo_number)

ls_port_code = string(dw_dischports.GetItemString(astr_port_parm.i_port_no,"port_code"))
ls_purpose = dw_dischports.GetItemString(astr_port_parm.i_port_no, "purpose_code")
ls_purpose = "&&" + ls_purpose

SELECT PORT_N
INTO :ls_name
FROM PORTS
WHERE PORT_CODE = :ls_port_code ;
COMMIT;

ls_name_purpose = ls_name + ls_purpose
return(ls_name_purpose)
end function

public subroutine uf_set_no_ports (integer ai_cargo_no, integer ai_no_loadports, integer ai_no_dischports, boolean ab_clear_itinerary);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the number of load and dischports as give in arguments, for
 					cargo ai_cargo_no. Specify true for the ab_clear_itinerary if the
					itinerary should be reset (regarding viapoints and expenses)
 					
 Arguments : ai_cargo_no as Integer, ai_no_loadports as Integer,
 				 ai_no_dischports as Integer, ab_clear_itinerary as boolean.

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_ports, li_count, li_count_via
String ls_null

Setnull(ls_null)

// Select given cargo
uf_select_cargo(ai_cargo_no)

// Add or delete ports, so we have (argument) ports
li_ports = dw_loadports.RowCount()
Do While li_ports <> ai_no_loadports
	If li_ports < ai_no_loadports Then 
		of_insertport(dw_loadports)
		li_ports ++
	Else 
		dw_loadports.DeleteRow(li_ports)
		li_ports --
	End if
Loop

// And clear itinerary is requested
If ab_clear_itinerary Then
	For li_count = 1 To li_ports 
		For li_count_via = 1 To 3 
			dw_loadports.SetItem(li_count, "cal_caio_via_point_"+String(li_count_via), ls_null)
			dw_loadports.SetItem(li_count, "cal_caio_via_expenses_"+String(li_count_via), 0)
		Next			
	Next
End if

// Do the same stuff for dischports
li_ports = dw_dischports.RowCount()
Do While li_ports <> ai_no_dischports
	If li_ports < ai_no_dischports Then 
		of_insertport(dw_dischports)
		li_ports ++
	Else 
		dw_dischports.DeleteRow(li_ports)
		li_ports --
	End if
Loop

// and again we clear the itinerary
If ab_clear_itinerary Then
	For li_count = 1 To li_ports 
		For li_count_via = 1 To 3 
			dw_dischports.SetItem(li_count, "cal_caio_via_point_"+String(li_count_via), ls_null)
			dw_dischports.SetItem(li_count, "cal_caio_via_expenses_"+String(li_count_via), 0)
		Next			
	Next
End if

end subroutine

private subroutine uf_check_cqd (ref datawindow adw_datawindow);/************************************************************************************

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

private subroutine uf_check_editlocked (long al_calc_id, ref datawindow adw_summary);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-10-96

 Description : Checks if the ports are used in tramos. Used ports are locked in calculated calculations, and
			unlocked in estimated (and vice-versa). Fixture calculations are allways locked

 Arguments : al_calc_id as Long, adw_summary as datawindow

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DataWindow dw_ports
u_tramos_nvo uo_tramos_nvo
s_get_cargo_status lstr_status[]
String ls_tmp
Integer li_loadmax, li_dischmax, li_count, li_lock, li_index, li_port_index, li_status, li_viacount, li_max
Integer li_load_index, li_disch_index, li_tmp
Long ll_fix_id
Boolean lb_lock_ballast


// Get the status for the calculate
li_status = adw_summary.GetItemNumber(1,"cal_calc_status") 

// Set vessel locked to true if status is fixture, calculated or estimated
ib_vessellocked = li_status >= 4

If li_status >= 4 Then
	// We only need processing if status is fixture or higher
	
	If (li_status = 5) Then
		// This is a estimated calculation. Now get the fixture ID for the CALCULATED
		// calculation from the CAL_CALC table (the CALCULATED will have same fixture
		// ID, but status 6 instead of status 5).
		ll_fix_id = adw_summary.GetItemNumber(1,"cal_calc_fix_id")
	
		SELECT CAL_CALC_ID
		INTO :al_calc_id
		FROM CAL_CALC
		WHERE (CAL_CALC_FIX_ID = :ll_fix_id AND
				CAL_CALC_STATUS = 6);
		COMMIT;
	End if

	// Get the total number of loadports and dischports.
	li_loadmax = dw_loadports.RowCount()
	li_dischmax = dw_dischports.RowCount()
	li_max = li_loadmax + li_dischmax

	// Create the u_tramos_nvo object, this is used the get the locked status later
	uo_tramos_nvo = CREATE u_tramos_nvo

	// Now we need to build the lstr_status array. This array contains all viapoints
	// and ports, and is passed to the u_tramos_nvo, that will find out which ports
	// is locked.
	
	// First, add viapoints from the first ballast port to first port
	For li_viacount = 1 To 3 
		ls_tmp = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast.GetItemString(1, "cal_ball_via_point_"+String(li_viacount))
		If Not IsNull(ls_tmp) Then
			// add this viapoint if it's not null
			
			li_index ++
			lstr_status[li_index].port_code = uo_tramos_nvo.uf_get_disb_portcode(ls_tmp)
			lstr_status[li_index].viapoint = true
		Else
			Exit
		End if
	Next

	// Loop through the number of load + dischports (li_max) and insert the
	// load and dischports into the lstr_status array in the itinerary order.
	// LI_LOAD_INDEX and li_DISCH_INDEX are pointers to current load & disch port
	// in the datawindows. LI_INDEX points to current lstr_status array.
	li_load_index = 1
	li_disch_index = 1

	For li_count = 1 To li_max
		li_index ++

		// Find out if the next port is a load or dischport by checking:
		// If theres more loadports (li_load_index > li_loadmax)
		// If theres more dischports (li_disch_index > li_dischmax - this shouldn't happen!)
		// and the itinerary order.
		
		If li_load_index > li_loadmax Then
			lstr_status[li_index]. load = false
		Elseif li_disch_index > li_dischmax Then
			lstr_status[li_index]. load = true
		Elseif dw_loadports.GetItemNumber(li_load_index, "cal_caio_itinerary_number") < &
				dw_dischports.GetItemNumber(li_disch_index, "cal_caio_itinerary_number") Then
			lstr_status[li_index].load = true
		Else
			lstr_status[li_index]. load = false
		End if

		// set dw_ports to point to the selected load or dischport, and increment index
		// values
		If lstr_status[li_index].load Then
			dw_ports = dw_loadports
			li_port_index = li_load_index
			li_load_index ++
		Else
			dw_ports = dw_dischports
			li_port_index = li_disch_index
			li_disch_index ++
		End if

		// Update the lstr_status array with portname and original rownumber for this port.
		// the rownumber is used to store lock information back to the datawindow later.
		lstr_status[li_index].port_code = dw_ports.getItemString(li_port_index,"port_code")
		lstr_status[li_index].cargo_row_no = li_port_index
			
		// Insert any viapoints for this port into the array as well.
		For li_viacount = 1 To 3 
			ls_tmp = dw_ports.GetItemString(li_port_index, "cal_caio_via_point_"+String(li_viacount))
			If Not IsNull(ls_tmp) Then
				li_index ++
				lstr_status[li_index].port_code = uo_tramos_nvo.uf_get_disb_portcode(ls_tmp)
				lstr_status[li_index].viapoint = true
			Else
				Exit
			End if
		Next
	Next

	// Ok, the lstr_status array is build, now call the u_tramos_nvo to
	// get locked information.
	ls_tmp = uo_tramos_nvo.uf_get_port_status(al_calc_id, lstr_status)

	// Rule #1: If first port is locked, then lock the ballast port to.
	If lstr_status[1].locked Then lb_lock_ballast = true

	// Rule #2: Check if there was an error returned by u_tramos_nvo
	If ls_tmp <> "" Then
		// Show only messages if ib_show_warning is true, otherwise store it.
		If iuo_calc_nvo.iuo_calculation.ib_show_messages Then
			MessageBox("Warning", ls_tmp, Exclamation!)
		Else
			iuo_calc_nvo.iuo_calculation.is_message += ls_tmp + "~r~n~r~n"
		End if
	End if			

	// We're done with the u_tramos_nvo object, and it can be destroyed
	DESTROY uo_tramos_nvo

	// Check if calculation status is 4 (fixture). If this is the case, then
	// lock all ports.
	If li_status = 4 Then
		li_max = Upperbound(lstr_status)
		For li_count = 1 To li_max 
			lstr_status[li_count].locked = true
		Next
	End if

	// Now update the locked status in the load and dischport datawindows, by looping
	// through the lstr_status array and store the locked value to the datawindow. The
	// locked value (li_lock) can be either 0 (not locked), 1 (port is locked) or 
	// 2 (all fields locked). 
	
	li_max = UpperBound(lstr_status)
	li_index = 1
	
	// Default lock status to 2 (all locked) if this is not a estimated calculation.
	// The li_lock value is determined for each port on the estimated calculation.
	If li_status < 6 Then li_lock = 2 

	DO WHILE li_index <= li_max

		// Skip over viapoints, since these are locked whenever the next port in the
		// itinerary list is locked
		Do While (lstr_status[li_index].viapoint) And (li_index < li_max) 
			li_index ++
		Loop

		If li_index <= li_max Then

			// Save the original proceeding locked status
			If lstr_status[li_index].locked then li_tmp = 1 Else li_tmp = 0
			If lstr_status[li_index].load Then
				dw_loadports.SetItem(lstr_status[li_index].cargo_row_no, "proceed_locked", li_tmp)
			Else
				dw_dischports.SetItem(lstr_status[li_index].cargo_row_no, "proceed_locked", li_tmp)
			End if
			
			// If this is an estimated calculation, then reverse the lock value
			// (since we want the locked entries on the calculated calculation
			// to be unlocked in the estimated calculation).
			If li_status = 6 Then 
				lstr_status[li_index].locked = not lstr_status[li_index].locked
				If lstr_status[li_index].locked then li_lock = 2 Else li_lock = 1
			End if

			// If locked (or if it's an estimated calculation) then update the locked
			// field in the datawindow, and set the ib_vessellocked flag to true
			If (lstr_status[li_index].locked) or (li_status = 6)  Then 
				If lstr_status[li_index].load Then
					dw_loadports.SetItem(lstr_status[li_index].cargo_row_no, "edit_locked", li_lock)
				Else
					dw_dischports.SetItem(lstr_status[li_index].cargo_row_no, "edit_locked", li_lock)
				End if
		
				ib_vessellocked = true
			End if
		End if

		li_index ++
	Loop

End if

// If the ballast is locked, then check if we need to lock the whole summary window.
If lb_lock_ballast Then li_tmp = 1 Else li_tmp = 0

// Check the current lock status of the summary window, before updating it !
If li_tmp > iuo_calc_nvo.iuo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1, "locked") Then
	iuo_calc_nvo.iuo_calculation.uo_calc_summary.dw_calc_summary.SetItem(1, "locked", li_tmp)
End if
end subroutine

private function boolean uf_check_load (ref s_calculation_cargo_inout astr_inouts[], ref string as_errortext);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIO
   
 Date       :  20-8-96

 Description : Validates that the load gets to zero, and never becomes negative. Also sorts the in/outs in
			correct itinerary order

 Arguments : astr_inouts[] as ref, as_errortext as ref.

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Double ld_load
Integer li_count, li_count1, li_count2, li_max
s_calculation_cargo_inout lstr_inout

// Sort the port array to the correct itinerary order, using good old
// bubble sort (but this is not a problem, since we usually only have
// a few entries).
li_max = UpperBound(astr_inouts)

For li_count1 = 1 To li_max -1 
	For li_count2 = li_count1 + 1 To li_max

		If astr_inouts[li_count1].i_itinerary_number > astr_inouts[li_count2].i_itinerary_number Then
			// These two needs entries to be swapped

			lstr_inout = astr_inouts[li_count1]
			astr_inouts[li_count1] = astr_inouts[li_count2]
			astr_inouts[li_count2] = lstr_inout
		End if
	Next			
next

// Now the astr_inouts is sorted to correct itinerary order. Loop through the list
// and check that the accumulated quantity doesn't drop below zero.
For li_count = 1 To li_max
	ld_load += astr_inouts[li_count].d_units

	If ld_load <0 Then
		as_errortext = "Load below zero during voyage"
		Return(false)
	End if
Next

// Finally check that all quantity has been discharged.
If ld_load > 0 Then as_errortext = "Not all cargo discharged in last port"
Return(ld_load = 0)
end function

private function boolean uf_delete_misc_exp (long al_caio_id);/************************************************************************************

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

public subroutine uf_get_caio_ids (ref double d_list[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Unknown
   
 Date       : 1997

 Description : Returns a list of all CAIO_IDS connected to the calculation

 Arguments : d_list[] as ref

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


double ld_rowcount, ld_count
long li_index,li_old_cargo


// Select all cargoes
li_old_cargo = uf_select_cargo(-1)

// Loop through the loadports and dischports, and get the CAIO_ID for each entry to
// the d_list array
li_index = 0
ld_rowcount = dw_loadports.RowCount()
For ld_count = 1 To ld_rowcount 
	li_index ++
	d_list[li_index] = dw_loadports.GetItemNumber(ld_count,"cal_caio_id")
Next 
ld_rowcount = dw_dischports.RowCount()
For ld_count = 1 To ld_rowcount
	li_index ++
	d_list[li_index] = dw_dischports.GetItemNumber(ld_count,"cal_caio_id")
Next	

// Restore back to the old cargo
uf_select_cargo(li_old_cargo)	


end subroutine

public function integer uf_get_no_dischports (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1996

 Description : Returns the number of dischports on cargo ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : No. of dischports

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

integer li_no_rows

uf_redraw_off()
uf_select_cargo(ai_cargo_no)
uf_redraw_on()

li_no_rows = dw_dischports.RowCount()

return(li_no_rows)
end function

public function integer uf_get_no_loadports (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the number of dischports on cargo ai_cargo_no
 
 Arguments : ai_cargo_no as integer

 Returns   : No. of dischports

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

integer li_no_rows

uf_select_cargo(ai_cargo_no)

li_no_rows = dw_loadports.RowCount()

return(li_no_rows)

end function

public function boolean uf_process_cargos (ref s_calculation_parm astr_parm, ref datawindow adw_ports, ref s_calculation_cargo_inout astr_inouts[], ref double ad_expenses, integer ai_cargo_no, integer ai_pcnr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 11-03-97

 Description : Save/Calculate/Fixture validation and calculation for cargos.
 					Calculation data is passed in astr_parm and astr_inouts (astr_inouts
					for easier/quicker access, since this data also exists in astr_parm),
					the datawindow (which can be load- or disch ports), cargo number and
					PC number. Expenses calculated in the module, is added to the ad_expenses
					variable.

 Arguments : astr_parm as calculation parm REF, 
 				 adw_ports as datawindows REF
				 astr_inouts[] as s_calculation_cargo_inout REF,
				 ad_expenses as double REF,
				 ai_cargo_no as Integer,
				 ai_pcnr as Integer

 Returns   : True if cargo is processed ok.

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
11-3-97		4.04			MI		Added CQD check  
************************************************************************************/

// Variable declaration

Boolean lb_result
Long ll_count, ll_rows
Integer li_inout_count, li_mtdh
String ls_port
double ld_tmp, ld_unit_expens
lb_result = false

// Append to current inout array
li_inout_count = UpperBound(astr_inouts) +1  

// Loop through all in or outports, depending on datawindow, and validate/calculate
// whatever's needed:
ll_rows = adw_ports.RowCount()
For ll_count = 1 To ll_rows
	// Check that there are no loadports with 0 in # of units
	if adw_ports = dw_loadports then
		if adw_ports.GetItemNumber(ll_count,"cal_caio_number_of_units") = 0 and &
			adw_ports.GetItemString(ll_count,"purpose_code") = "L" then
			astr_parm.result.s_errortext = "Quantity can't be 0 (zero) for Load ports"
			adw_ports.SetColumn("cal_caio_number_of_units")
			Goto Stop
		end if
	end if
	
	// Copy # of units, and validate that # of unit's ain't 0 for dischports.
	astr_inouts[li_inout_count].d_units = adw_ports.GetItemNumber(ll_count, "cal_caio_number_of_units")
	If (astr_inouts[li_inout_count].d_units = 0) And (adw_ports = dw_dischports) Then
		astr_parm.result.s_errortext = "Error in quantity"
		adw_ports.SetColumn("cal_caio_number_of_units")
		Goto Stop
	End if

	// If we were just checking for save, then continue now
	// ********************************************************************
	// ALL CODE THAT IS TO BE PROCESSED FOR SAVING, MUST BE ABOVE THIS LINE
	// ********************************************************************
	If astr_parm.i_function_code=1 Then Continue 

	// Check if portcode is dummy (""), which isn't allowed for calculation
	ls_Port = Trim(adw_ports.GetItemString(ll_count,"port_code"))
	If ls_port = "" Then
		astr_parm.result.s_errortext = "Dummy-port cannot be used in calculation and fixture"
		adw_ports.SetColumn("port_code")
		Goto Stop
	End if

	// Copy estimated value to astr_inouts and validate it
	astr_inouts[li_inout_count].d_estimated = adw_ports.GetItemNumber(ll_count, "cal_caio_rate_estimated") 
	If astr_inouts[li_inout_count].d_estimated < 0 Then
		astr_parm.result.s_errortext = "Estimated rate not given for port " + ls_port
		adw_ports.SetColumn("cal_caio_rate_estimated")
		Goto Stop
	End if

	// Copy other values to astr_inouts
	astr_inouts[li_inout_count].d_calculated = adw_ports.GetItemNumber(ll_count, "cal_caio_rate_calculated")
	astr_inouts[li_inout_count].d_despatch = adw_ports.GetItemNumber(ll_count, "cal_caio_despatch")
	astr_inouts[li_inout_count].d_demurrage = adw_ports.GetItemNumber(ll_count, "cal_caio_demurrage")
	astr_inouts[li_inout_count].i_gear = adw_ports.GetItemNumber(ll_count, "cal_caio_gear")

	// Add expenses found in the load or discharge port
	ad_expenses += adw_ports.GetItemnumber(ll_count, "cal_caio_expenses")

	ld_unit_expens = adw_ports.GetItemNumber(ll_count, "cal_caio_load_unit_expenses")
	ld_tmp = ld_unit_expens * Abs(adw_ports.GetItemNumber(ll_count, "cal_caio_number_of_units"))
	ld_tmp = ld_tmp + adw_ports.GetItemNumber(ll_count, "cal_caio_misc_expenses")

	astr_parm.cargolist[ai_cargo_no].d_add_expenses += ld_tmp

	astr_parm.result.d_port_expenses += adw_ports.GetItemnumber(ll_count, "cal_caio_expenses")
	astr_inouts[li_inout_count].l_terms_id = adw_ports.GetItemNumber(ll_count, "cal_raty_id")
	astr_inouts[li_inout_count].l_type = adw_ports.GetItemNumber(ll_count, "cal_caio_load_terms")
	astr_inouts[li_inout_count].i_itinerary_number = adw_ports.GetItemNumber(ll_count, "cal_caio_itinerary_number")
	astr_inouts[li_inout_count].s_port = adw_ports.GetItemString(ll_count, "port_code")
	astr_inouts[li_inout_count].s_purpose = adw_ports.GetItemString(ll_count, "purpose_code")

	If adw_ports = dw_loadports then
		astr_parm.d_noticetime_loadports += (adw_ports.GetItemNumber(ll_count, "cal_caio_noticetime") * 60)
	Else
		astr_parm.d_noticetime_dischports += (adw_ports.GetItemNumber(ll_count, "cal_caio_noticetime") * 60)
	End If

	// Get the rate terms out from the CAL_RATY table. Remember that the MDTH field
	// has a wrong name, and is used to store the Rate type.
	SELECT CAL_RATY_MTDH
	INTO :li_mtdh
	FROM CAL_RATY
	WHERE CAL_RATY_ID = :astr_inouts[li_inout_count].l_terms_id
	COMMIT;

	// If ratetype is CQD, then reset despatch, demurrage and calculated to 0.
	If li_mtdh = 4 Then 
		astr_inouts[li_inout_count].d_despatch = 0
		astr_inouts[li_inout_count].d_demurrage = 0
		astr_inouts[li_inout_count].d_calculated = 0
	End if 
	
	// If fixturing and (# of units > 0) and (not CQD) then check that a demurrage rate
	// is given-
	If (astr_parm.i_function_code>2) And (astr_inouts[li_inout_count].d_units<>0) And (li_mtdh<>4) Then
		If  (astr_parm.fixturelist[ai_cargo_no])  Then
			If astr_inouts[li_inout_count].d_demurrage=0 Then
				astr_parm.result.s_errortext = "Demurrage not given for port "+ iuo_calc_nvo.uf_portcode_to_name(ls_port)
				adw_ports.SetColumn("cal_caio_demurrage")
				Goto Stop
			End if		
		End if
	End if

	li_inout_count ++
Next

lb_result = true

Stop:

// If something went wrong, then set focus to the datawindow we we're getting
// data from
If not lb_result Then  
	adw_ports.SetFocus()
	adw_ports.SetRow(ll_count)
End if

Return(lb_result)


end function

public function integer uf_accepttext ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-9-96

 Description : Returns status for accepttext, 1 = OK. <>1 equals error

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Integer li_result

li_result = dw_cargo_summary.Accepttext()
If li_result = 1 Then li_result = dw_loadports.Accepttext()
If li_result = 1 Then li_result = dw_dischports.Accepttext()

Return(li_result)
end function

public function integer uf_select_cargo (integer ai_cargo_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1/8-96

 Description : Displays the selected cargo in the cargo page, -1 selects all cargos
					Selecting -1 as is only valid for internal calculation use, and should
					always be set to above zero for user display.

 Arguments : cargo row number

 Returns   : old cargo row number

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
String ls_tmp
Integer li_old_cargo, li_count, li_max, li_carg_status, li_calc_status, li_lock_value, li_locked_count, li_total_count, li_calc_lump
Long ll_cargo_id
Integer li_tmp

// Remember old cargo number
li_old_cargo = ii_current_cargo

// Switch to new cargo number, if it's different than the current and
// different from 0 (it's not allowed to select cargo 0)
If (ai_cargo_row <> ii_current_cargo) and (ai_cargo_row <> 0)  Then
	uf_redraw_off()
	This.uf_accepttext()

	// Remember new cargo number as current cargo number. This have to be
	// done at this time, since functions called later on, might end up calling
	// this function again, resulting in a recursive never-ending loop.
	ii_current_cargo = ai_cargo_row
		
	If ai_cargo_row = -1 Then
		// If requested cargo # is -1, we remove the filters, so all cargos will
		// be visible. 
	
		dw_loadports.SetFilter("")
		dw_loadports.Filter()
		dw_dischports.SetFilter("")
		dw_dischports.Filter()
		dw_calc_lumpsum.SetFilter("")	
		dw_calc_lumpsum.Filter()	
		
	Elseif ai_cargo_row > 0 Then
		// Remove the locked status before selecting the new cargo number. This is
		// due to PB "feature" (yeah right), that disables the possibility to scroll
		// to an all-locked row. 
		li_tmp = dw_cargo_summary.GetItemNumber(ai_cargo_row, "locked")
		dw_cargo_summary.SetItem(ai_cargo_row, "locked", 0)	
		dw_cargo_summary.ScrollToRow(ai_cargo_row) 

		// Set the locked value back.
		dw_cargo_summary.SetItem(ai_cargo_row, "locked", li_tmp)	


		// If we didn't select the row we wanted, something must be wrong. Display
		// a Errorbox.
		If dw_cargo_summary.GetRow()<> ai_cargo_row Then &
			MessageBox("Error", "Select fejl: "+String(ai_cargo_row)+" "+String(dw_cargo_summary.GetRow())+" "+String(dw_cargo_summary.RowCount()))

		// Get CARGO_ID. If its 0 or NULL (meaning a create but not yet saved cargo)
		// we'll use the negative rownumber as link-ID.
		ll_cargo_id = dw_cargo_summary.GetItemNumber(ai_cargo_row,"cal_carg_id")
		If (ll_cargo_id = 0) or Isnull(ll_cargo_id) Then ll_cargo_id = -ai_cargo_row

		// Setup a loadport/dischport filter using the CARGO_ID
		ls_tmp = "cal_carg_id = "+ String(ll_cargo_id) 

		dw_loadports.SetFilter(ls_tmp)
		dw_loadports.Filter()
		dw_dischports.SetFilter(ls_tmp)
		dw_dischports.Filter()
		dw_calc_lumpsum.SetFilter(ls_tmp)	
		dw_calc_lumpsum.Filter()
		
		If (dw_cargo_summary.GetItemNumber(ai_cargo_row, "locked")=-1)  And (dw_loadports.rowcount()>0) Then
			// If locked is -1 then we need to initilize the lock values (locked will only
			// be -1 for uninitialized rows). Get the cargo and calculation status, and
			// update locked status according to this. This locked value determines if the
			// whole cargo should be locked or not.
			//
			// li_lock_value 1 = Locked, all fields should be grayes
			// li_lock_value 0 = Open, fields should be white or lightblue
						
			li_carg_status = dw_cargo_summary.GetItemNumber(ai_cargo_row, "cal_carg_status")
			li_calc_status = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary.GetItemNumber(1, "cal_calc_status") 
			li_lock_value = 0 
	
			If li_calc_status=4 Then
				// If it's a fixture, then everything should be locked.
				
				li_lock_value = 1
			Elseif li_calc_status > 4 Then 
				// It's an estimated or calculated. Count all locked ports, if
				// this count equals total count of ports, then we need to lock
				// the cargo as well.
		
				li_locked_count = 0		
				li_total_count = 0
		
				li_max = dw_loadports.RowCount()
				li_total_count += li_max
				For li_count = 1 To li_max 
					If dw_loadports.GetItemNumber(li_count, "edit_locked") = 2 Then li_locked_count ++
				Next
	
				li_max = dw_dischports.rowCount()
				li_total_count += li_max
				For li_count = 1 To li_max
					If dw_dischports.GetItemNumber(li_count, "edit_locked") = 2 Then li_locked_count ++
				Next
	
				If li_locked_count = li_total_count Then
					li_lock_value = 1
				Elseif li_locked_count = 0 Then
					li_lock_value = 0
				Else
					// Some of the ports - but not all was locked. Lock calculated 
					// calculations, but not the estimated.
					If li_calc_status = 6 Then li_lock_value =1 Else li_lock_value = 0
				End if				
			End if
		
			// Set the locked value to the cargo datawindow
			dw_cargo_summary.SetItem(ai_cargo_row, "locked", li_lock_value)

			// And move focus to either description (if not locked) or the locked
			// field itself (if locked). This is due to the famous "PB feature". PB
			// has a real hard time locked ALL fields in a datawindow, so we need to
			// move focus to a non-locked fiels.
			If li_lock_value = 0 Then 	ls_tmp = "cal_carg_description" Else ls_tmp = "locked"
			dw_cargo_summary.SetColumn(ls_tmp)
		End if
		
		for li_calc_lump = 1 to dw_calc_lumpsum.rowcount( ) 
			if dw_calc_lumpsum.getitemnumber( li_calc_lump,"cal_carg_id") = ll_cargo_id then
				dw_calc_lumpsum.setitem( li_calc_lump,"locked",dw_cargo_summary.GetItemNumber(ai_cargo_row, "locked"))	
			end if
		next
		//dw_calc_lumpsum.resetupdate( )
	
		// Tell the rest of the calculation system, that something has changed.
		Parent.PostEvent("ue_cargo_row_changed",ai_cargo_row,0)

		// Reposition window back to normal
	//	dw_cargo_summary.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_loadports.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_dischports.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_calc_lumpsum.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
	End if
	
	uf_redraw_on()
End if

// ENd of job, return old cargo number as result.
If li_old_cargo = 0 Then li_old_cargo = dw_cargo_summary.GetRow()

Return(li_old_cargo)
end function

private subroutine uf_change_sql (integer ai_function_code, ref datawindow adw_datawindow, ref string as_sql);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1997

 Description : Changes SQL insert, update and delete statements to update the calculated and
 					estimated calculations on the same time.

 Arguments : ai_function_code: Integer, identifies which datawindow thats about to 
 	be updated:
 	1 = cargo summery, 2 = loadports, 3 = dischports, 4 = dw_misc_expenses,
	5 = dw_calc_hea_dev_claims, 6 = dw_calc_misc_claims 
 										
	adw_datawindow : datawindow that is being updated
	as_sql			: SQL-string containing the update
										 
 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
//
// This is how it works.
//
// Upon changes in the calculated calculation, the estimated needs to be updated with the
// same changes. Now, this could be done using ordinary slave-code, but it would be huge,
// and very hard to maintain. Instead this function "uf_change_sql" was made. It's
// called with the original SQL statement, and returns a modified SQL statement, that
// is sent to the database
//
// Example
// 1) User edits data and saves:
// 2) dw_xx.Update(xxx)
// 3) dw_xx.SQLPreview event
// 4) dw.xx.SQLPreview event calls uf_change_SQL()
// 5) Modified SQL is returned from uf_change_SQL()
// 6) dw.xx.SQLPewview event is passing the SQL statement to the database driver
// 7) end of update
//
// Uf_change_SQL description: First of all, the il_estimated_calc_id is checked. If it
// contains a valid value, then we're currently updating a CALCULATED calculation (the
// il_estimated_calc_id is set outside this function). 
//
// Next, the SQL statement is checked for type. UPDATE and DELETE is being handled the
// same way, while INSERTS is handled in another way. Finally then SQL statement is
// modified so the SQL will update estimated as well as the original calculated
//
// Example: Typically a UPDATE statement can look like this:
//
// UPATE CAL_CARG 
// SET CAL_CARG_ADD_EXP = 666
// WHERE CAL_CALC_ID = 123 
// AND CAL_CARG_ID = 456
// AND CAL_CARG_ORDER = 1
//
// This statement changes the ADD_EXP field in the database. Now, by removing the
// CAL_CARG_ID, and changing the CAL_CALC_ID to point to both the calculated and 
// estimated calculations, the update will occur to both:
//
// UPDATE CAL_CARG
// SET CAL_CARG_ADD_EXP = 666
// WHERE (CAL_CALC_ID = 123) OR (CAL_CALC_ID = 124)
// AND CAL_CARG_ORDER = 1
//
// The reason why this works is due to the CAL_CARG_ORDER field, which contains a number
// that links data between the calculated and estimated calculations. This number will
// allways be equal in the two calculations, and the same number cannot (may not!) exist
// several times within one calculation.
//
// Note that the ORDER field is needed in all tables that is updated this way, eg. the
// CAIO, CLAIMS and Expenses also have a ORDER number
//
// INSERTS is handles in a slightly different way. They might not, for example, 
// have an CAL_CARG_ID (because this value first is assigned during the Insert). Instead
// a INSERT will trigger an immediate update to the database, containing the values and 
// modified where nessesary.
// 
// Example:
//
// INSERT INTO CAL_CARG
// VALUES xx.xx.xx.xx
// WHERE CAL_CALC_ID = 666 (calculated CAL_CALC_ID)
//
// uf_change_SQL will fire this statement directly to the database:
//
// INSERT INTO CAL_CARG
// VALUES xx.xx.xx.xx
// WHERE CAL_CALC_ID = 667 (estimated CAL_CALC_ID)
// 
// The original SQL statement is not touched in this case, and will be executed by 
// the usual update rutines.
//
// Updating tables "owned" by the CAL_CARG (CAL_CAIO etc) is the same thing, 
// but using other fields. CAL_CALC_ID is thrown away, and instead the CAL_CARG_ID
// is modified to point to both the calculated and estimated calculations.
//
//	istr_calc_to_est is an structure array, containing the references between calculated
// and estimated calculation CAL_CARG_ID's
//
// example:
// istr_calc_to_est[1].l_calculated   is the ID for cargo #1 on current calculation, while
// istr_calc_to_est[1].l_estimated    points to the same cargo (#1) on the estimated calculation
//
// The System-Error messageboxes dosen't have a good text - but nobody understands them
// after all :-)
//

String ls_sql, ls_tmp, ls_sql_code
Integer li_max, li_count
Long ll_carg_id, ll_est_carg_id, ll_calc_id, ll_caio_id, ll_est_caio_id, ll_order_id, ll_pexp_id, ll_est_pexp_id
u_sql_util uo_sql_util

// Check first if this is calculated calcule. The il_estimated_calc_id will contain
// a value above 0 on calculated calculations
If (il_estimated_calc_id > 0) Then
	
	// Create a u_sql_util object. This object contains functionality to modify
	// SQL select statements
	uo_sql_util = CREATE u_sql_util

	// Remove leading spaces from the SQL string
	ls_sql = LeftTrim(as_sql)
	// and put the SQL command into the ls_sql_code variable
	ls_sql_code = Left(ls_sql, 6)

	// Perform different processing, depending on which datawindow that is 
	// being updated (ai_function_code contains the value for datawindow
	// that is being updated).
	If (ai_function_code = 1) Then 
		// Code for the dw_cargo_summary datawindow

		CHOOSE CASE ls_sql_code
			CASE "UPDATE", "DELETE"
				// Get the calculation ID from the SQL statement
				ll_calc_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_CALC_ID"))

				// And change the SQL statement to be where "(CALC_ID) OR (ESTIMATED ID)"
				uo_sql_util.uf_modify_where(ls_sql, "CAL_CALC_ID", & 
				"(CAL_CALC_ID = "+String(ll_calc_id)+" OR CAL_CALC_ID = "+String(il_estimated_calc_id)+")")							
		
				// Remove the cal_carg_id from the where statement
				uo_sql_util.uf_remove_where(ls_sql, "CAL_CARG_ID")		
			CASE "INSERT"
				// Copy the current SQL statement to ls_tmp, and modify the ls_tmp to 
				// point to the estimated calc_id
				ls_tmp = ls_sql
				uo_sql_util.uf_modify_insert(ls_tmp, "CAL_CALC_ID", String(il_estimated_calc_id))

				// Fire the new SQL statement immediately. The original SQL statement will
				// be processed later on without modifications.
				EXECUTE IMMEDIATE :ls_tmp USING SQLCA;

				// And check for SQL errors
				If SQLCA.SQLCode <> 0 Then MessageBox("System error", "Error during estimated carg insert. ~r~n~r~nSQL:" + String(SQLCA.SQLCode)+ " " +SQLCA.SQLErrText)
		END CHOOSE					
		
	Elseif (ai_function_code = 2) Or (ai_function_code =3) or (ai_function_code = 5) or (ai_function_code = 6) Then
		// Code for the dw_loadports, dw_dischports, dw_calc_hea_dev_claims and 
		// dw_calc_misc_claims datawindows. All these datawindows are hooked up the
		// cal_carg table, so they can all be processed in the same way.
				
		CHOOSE CASE ls_sql_code
			CASE "UPDATE", "DELETE"
				// Get the calculation ID from the SQL statement
				ll_carg_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_CARG_ID"))			

				// Search through the istr_calc_to_est array, and find the estimated ID
				// that corrosponds to our calculated ID. Store the estimated ID to
				// ll_est_carg_id
				li_max = UpperBound(istr_calc_to_est)
				For li_count = 1 To li_max 
					If istr_calc_to_est[li_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[li_count].l_estimated
						Exit
					End if
				Next
			
				If ll_est_carg_id <> 0 Then 
					// The estimated ID was found, now change the SQL statement to
					// be where "(CALC_ID) OR (ESTIMATED ID)"

					uo_sql_util.uf_modify_where(ls_sql, "CAL_CARG_ID", & 
					"(CAL_CARG_ID = "+String(ll_carg_id)+" OR CAL_CARG_ID = "+String(ll_est_carg_id)+")")							
				Else	
					// Error - ID was not found, this is probably due to a programming (logic)
					// error or error in the database fields. Show list of connected ID's since
					// this might help the developer finding the bug.
					
					ls_tmp = "Unable to generate estimated copy ("+String(ai_function_code)+")~r~n~r~ncarg_id is "+String(ll_carg_id)+"~r~n~r~n"
					For li_count = 1 To li_max 
						ls_tmp += "cal: "+String(istr_calc_to_est[li_count].l_calculated)+" est: "+String(istr_calc_to_est[li_count].l_estimated)
					Next

					MessageBox("System error", ls_tmp)
				End if

				// Remove the CAL_CAIO_ID, CAL_HEDV_ID or CAL_CLMI_ID depending on which
				// datawindow we're working on
				CHOOSE CASE ai_function_code
					CASE 2,3
						uo_sql_util.uf_remove_where(ls_sql, "CAL_CAIO_ID")
					CASE 5
						uo_sql_util.uf_remove_where(ls_sql, "CAL_HEDV_ID")
					CASE 6
						uo_sql_util.uf_remove_where(ls_sql, "CAL_CLMI_ID")
				END CHOOSE

			CASE "INSERT"
				// Get the calculation ID from the SQL statement
				ll_carg_id = Long(uo_sql_util.uf_get_insert(ls_sql, "CAL_CARG_ID"))

				// Search through the istr_calc_to_est array, and find the estimated ID
				// that corrosponds to our calculated ID. Store the estimated ID to
				// ll_est_carg_id
				li_max = UpperBound(istr_calc_to_est)
				For li_count = 1 To li_max 
					If istr_calc_to_est[li_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[li_count].l_estimated
						Exit
					End if
				Next

				If ll_est_carg_id > 0 Then
					// Copy the current SQL statement to ls_tmp, and modify the ls_tmp to 
					// point to the estimated CARG_ID
					ls_tmp = ls_sql
					uo_sql_util.uf_modify_insert(ls_tmp, "CAL_CARG_ID", String(ll_est_carg_id))

					// Fire the new SQL statement immediately. The original SQL statement will
					// be processed later on without modifications.
					EXECUTE IMMEDIATE :ls_tmp USING SQLCA;

					// Handle SQL errors if any
					If SQLCA.SQLCode <> 0 Then MessageBox("System error", "Error during estimated insert ("+String(ai_function_code)+") ~r~n~r~nSQL:" + String(SQLCA.SQLCode)+ " " +SQLCA.SQLErrText)
				Else
					// Error - estimated ID was not found, this is probably due to a 
					// programming (logic) error or error in the database fields. 
					
					MessageBox("System error", "Unable to generate estimated copy (CAIO INSERT EST=0, FUNCTION="+String(ai_function_code)+")")
				End if			
								
		END CHOOSE
	Elseif (ai_function_code = 4) Then  
		// Code for the dw_misc_exp datawindow. 
		// 
		// Unlike the dw_loadports, dw_dischports etc., this table is not hooked to
		// the CAL_CARG table, but instead it's commented to the CAL_CAIO table. This
		// makes the code a bit larger, although the procedure is more or less like 
		// the same as for the other datawindows, because we have to go back to the
		// CAL_CARG table to find the estimated ID, and the go forward with this ID
		// to find the estimated misc. exp. row.
		
		CHOOSE CASE ls_sql_code
			CASE "UPDATE", "DELETE"
				// Get the CAIO_ID and PEXP_ID from the SQL statement
				ll_caio_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_CAIO_ID"))			
				ll_pexp_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_PEXP_ID"))			
				
				// Find the calculated CALC_ID that belongs to this misc expense.
				SELECT CAL_CARG_ID 
				INTO :ll_carg_id
				FROM CAL_CAIO
				WHERE CAL_CAIO_ID = :ll_caio_id;

				// Now loop through the istr_calc_to_est array and find the 
				// corrosponding estimated ID. 
				li_max = UpperBound(istr_calc_to_est)
				For li_count = 1 To li_max 
					If istr_calc_to_est[li_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[li_count].l_estimated

						// Now we got the estimated ID, use this and the 
						// CAL_CAIO_ITINERARY_NUMBER to get the CAL_CAIO_ID
						// for the estimated Cargo In/Out
						SELECT CAL_CAIO_ID 
						INTO :ll_est_caio_id
						FROM CAL_CAIO
						WHERE CAL_CARG_ID = :ll_est_carg_id AND
							CAL_CAIO_ITINERARY_NUMBER = 
						(SELECT CAL_CAIO_ITINERARY_NUMBER
						FROM CAL_CAIO
						WHERE CAL_CAIO_ID = :ll_caio_id);
		
						Exit
					End if
				Next

				// Finally find the estimated CAL_PEXP_ID, by using the CAL_CAIO_ID
				// and the CAL_PEXP_ORDER. 
				ll_order_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_PEXP_ORDER"))					

				SELECT CAL_PEXP_ID
				INTO :ll_est_pexp_id
				FROM CAL_PEXP
				WHERE (CAL_CAIO_ID = :ll_est_caio_id AND
					CAL_PEXP_ORDER = :ll_order_id);

				If (ll_est_pexp_id <> 0)  Then 
					// Estimated ID found, now modify the SQL statement to point to both the
					// calculated and estimated ID's.

					uo_sql_util.uf_modify_where(ls_sql, "CAL_PEXP_ID", & 
					"(CAL_PEXP_ID = "+String(ll_pexp_id)+" OR CAL_PEXP_ID = "+String(ll_est_pexp_id)+")")							
					
					// and remove the CAL_CAIO_ID 
					uo_sql_util.uf_remove_where(ls_sql, "CAL_CAIO_ID")
				Else	
					// Some kind of error happend, so we don't have an CAL_PEXP_ID. 
					ls_tmp = "Unable to generate estimated pexp copy (PEXP UPDATE)~r~n~r~ncarg_id is "+String(ll_pexp_id)+"~r~n~r~n"
					MessageBox("System error", ls_tmp)
				End if

			CASE "INSERT"
				// Get the CAIO_ID and PEXP_ID from the SQL statement
				ll_caio_id = Long(uo_sql_util.uf_get_insert(ls_sql, "CAL_CAIO_ID"))			
				
				// Find the calculated CALC_ID that belongs to this misc expense.
				SELECT CAL_CARG_ID 
				INTO :ll_carg_id
				FROM CAL_CAIO
				WHERE CAL_CAIO_ID = :ll_caio_id;

				// Search through the istr_calc_to_est array, and find the estimated ID
				// that corrosponds to our calculated ID. Store the estimated ID to
				// ll_est_carg_id
				li_max = UpperBound(istr_calc_to_est)
				For li_count = 1 To li_max 
					If istr_calc_to_est[li_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[li_count].l_estimated
						Exit
					End if
				Next

				If ll_est_carg_id > 0 Then
					// Now we got the estimated ID, use this and the 
					// CAL_CAIO_ITINERARY_NUMBER to get the CAL_CAIO_ID
					// for the estimated Cargo In/Out
					SELECT CAL_CAIO_ID 
					INTO :ll_est_caio_id
					FROM CAL_CAIO
					WHERE CAL_CARG_ID = :ll_est_carg_id AND
						CAL_CAIO_ITINERARY_NUMBER = 
					(SELECT CAL_CAIO_ITINERARY_NUMBER
					FROM CAL_CAIO
					WHERE CAL_CAIO_ID = :ll_caio_id);

					// Copy the current SQL statement to ls_tmp, and modify the ls_tmp to 
					// point to the estimated CAIO_ID
					ls_tmp = ls_sql
					uo_sql_util.uf_modify_insert(ls_tmp, "CAL_CAIO_ID", String(ll_est_caio_id))

					// Fire the new SQL statement immediately. The original SQL statement will
					// be processed later on without modifications.
					EXECUTE IMMEDIATE :ls_tmp USING SQLCA;

					// and handle the SQL errors if any
					If SQLCA.SQLCode <> 0 Then MessageBox("System error", "Error during estimated caio-exp insert. ~r~n~r~nSQL:" + String(SQLCA.SQLCode)+ " " +SQLCA.SQLErrText)
				Else
					// The estimated ID = 0 , so we can't find the calculated ID

					MessageBox("System error", "Unable to generate estimated caio_exp copy (CAIO EST=0)")
				End if			
						
		END CHOOSE
	End if

	// all done, now destroy the uo_sql_util object
	DESTROY uo_sql_util
	
	// And set the modified SQL statement back to the datawindow
	adw_datawindow.SetSqlPreview(ls_sql)
End if
end subroutine

public subroutine uf_delete_cargo (long al_cargono);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 15-9-96

 Description : Deletes cargo al_cargono

 Arguments : al_cargono as long

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_max, li_count
Long ll_rowcount, ll_count, ll_ID

// Set redraw off, and select al_cargono 
uf_redraw_off()
uf_select_cargo(al_cargono)

// Delete all misc expenses on loadports, and delete all loadports
ll_rowcount = dw_loadports.RowCount()
For ll_count = ll_rowcount To 1 Step -1
	uf_delete_misc_exp( dw_loadports.GetItemNumber(ll_count,"cal_caio_id"))
	dw_loadports.DeleteRow(ll_count)
Next

// Delete all misc expenses on dischports, and delete all dischports
ll_rowcount = dw_dischports.RowCount()
For ll_count = ll_rowcount To 1 Step -1
	uf_delete_misc_exp(dw_dischports.GetItemNumber(ll_count,"cal_caio_id"))
	dw_dischports.DeleteRow(ll_count)
Next

// Delete the summary for this cargo (this is the CAL_CARG)
dw_cargo_summary.DeleteRow(al_cargono)

// Fixup the cal_carg_order so they reflect the changes, and "holes" is removed.
ii_no_cargos = dw_cargo_summary.RowCount()
For ll_count = 1 To ii_no_cargos
	If dw_cargo_summary.getItemNumber(ll_count, "cal_carg_cal_carg_order") <> ll_count Then &
		dw_cargo_summary.SetItem(ll_count,"cal_carg_cal_carg_order",ll_count)
Next

// Fixup created but not yet saved cargos. Explanation: Newly created cargos,
// that haven't been saved yet, will have their -rownumber as their "fake" ID, Eg. 
// cargo number 2 will have -2 as the ID. Deleting a cargo might or might not
// change the numbers of the cargoes, so we need to restore the correct links here.

// Select all cargoes
uf_select_cargo(-1)

// Loop through all loadports. If the ID is fake (its minus) and above the cargo we
// just deleted, then set their rownumber to the new rownumber
li_max = dw_loadports.Rowcount()
For li_count = 1 To li_max
	ll_ID = dw_loadports.GetItemNumber(li_count, "cal_carg_id")

	If (ll_ID < 0) And (Abs(ll_ID)>al_cargono) then dw_loadports.SetItem(li_count, "cal_carg_id", ll_ID + 1)
Next

// Do the same for dischports
li_max = dw_dischports.Rowcount()
For li_count = 1 To li_max
	ll_ID = dw_dischports.GetItemNumber(li_count, "cal_carg_id")
	If (ll_ID < 0) And (Abs(ll_ID)>al_cargono)  then dw_dischports.SetItem(li_count, "cal_carg_id", ll_ID + 1)
Next

// Do the same for lumpsums
li_max = dw_calc_lumpsum.Rowcount()
For li_count = 1 To li_max
	ll_ID = dw_calc_lumpsum.GetItemNumber(li_count, "cal_carg_id")
	If (ll_ID < 0) And (Abs(ll_ID)>al_cargono)  then dw_calc_lumpsum.SetItem(li_count, "cal_carg_id", ll_ID + 1)
Next

// If cargono > # of cargoes then set cargono to # of cargoes
If al_cargono>ii_no_cargos Then al_cargono=ii_no_cargos

// Update the itinerary
iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_update_itinerary_order()

// And select cargo
uf_select_cargo(al_cargono)

// We're done
uf_redraw_on()
end subroutine

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 27-9-96

 Description : Deactivates current object 

 Arguments : None

 Returns   : None

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_result

li_result = This.uf_accepttext()
if li_result <> 1 Then Return(li_result) // Signal error

Return(li_result)
end function

private subroutine uf_description_changed ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Tells the calculation system that the description has been changed

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Post a ue_calculation_changed event to our parent.
Parent.PostEvent("ue_calc_changed")

end subroutine

public function integer uf_get_cargo ();//Returns current cargo

Return(ii_current_cargo)
end function

public function string uf_get_loadport_name (ref s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit
   
 Date       : 1997

 Description : Returns portname for cargo and port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

string ls_name, ls_port_code

uf_select_cargo(astr_port_parm.i_cargo_number)

ls_port_code = string(dw_loadports.GetItemString(astr_port_parm.i_port_no,"port_code"))

SELECT PORT_N
INTO :ls_name
FROM PORTS
WHERE PORT_CODE = :ls_port_code ;

return(ls_name)
end function

public subroutine of_open_worldscale (datawindow dwo_load, datawindow dwo_disch, integer ai_year);u_jump_worldscale luo_jump_worldscale
string ls_port_code_start, ls_port_code_end

luo_jump_worldscale = create u_jump_worldscale

if (dwo_load.rowcount() > 1 or dwo_disch.rowcount() > 1) then
	setnull(ls_port_code_start)
	setnull(ls_port_code_end)
else
	ls_port_code_start = dwo_load.getitemstring(1, "port_code")
	ls_port_code_end = dwo_disch.getitemstring(1, "port_code")
end if

luo_jump_worldscale.of_open_worldscale(ls_port_code_start, ls_port_code_end, ai_year)

DESTROY luo_jump_worldscale
end subroutine

public function boolean uf_process (ref s_calculation_parm astr_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1-8-96

 Description : This function performs three tasks, depending on [function code].
			Code: 1; validates cargos for save
			Code: 2; (validates) and performs calculation
			Code: 3; validates fixture and perfoms calculation			

 Arguments : Function code as integer

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-8-96		1			MI		Initial version  
18-11-96		1			MI		Added check for grade during fixture
************************************************************************************/

// Variable declaration

Long ll_cargo_rows, ll_cargo_count, ll_ratetype
Long ll_vessel_type, ll_vessel_id, ll_clarkson_id, ll_cargo_id, ll_caio_id, ll_row
Integer li_pcnr, li_exp_max, li_exp_count, li_add_lumpsum, ll_lumpsums, ll_lumpsum
Boolean lb_result
Double ld_totalunits, ld_add_expenses, ld_tmp, ld_misc_exp
Double ld_laden_speed, ld_ballast_speed
s_calc_result lstr_calc_result
datetime ldt_laycan_start, ldt_laycan_end

// Default errortext - this one is not to be used, but should be 
// overwritted later on
astr_parm.result.s_errortext = "Cargo calculation"

// Check that we can do an accepttext on all datawindows
If dw_cargo_summary.Accepttext() + dw_loadports.Accepttext() +dw_dischports.Accepttext() <> 3 Then
	astr_parm.result.s_errortext = "Illegal value"
	Return(false)
End if

// Get number of cargorows to ll_cargo_rows
ll_cargo_rows = dw_cargo_summary.RowCount()

// If this is a fixture, then first check that at least one cargo has been
// selected for fixture, and that a APM vessel has been choosen for vessel.
If astr_parm.i_function_code=3 Then 
	lb_result = false
	
	// Check that atleast one cargo has been selecte for fixture
	For ll_cargo_count = 1 To ll_cargo_rows
		If astr_parm.fixturelist[ll_cargo_count] Then lb_result = true
	Next

	If not lb_result Then
		astr_parm.result.s_errortext = "No cargo selected for fixture"
		Goto Stop
	End if

	// Check that a APM vessel has been selected
	iuo_calc_nvo.iuo_calc_summary.uf_get_vessel(ll_vessel_type, ll_vessel_id, ll_clarkson_id)	
	If IsNull(ll_vessel_id) Or (ll_vessel_id = 0) Then
		astr_parm.result.s_errortext = "Fixtures can only be made on vessels from the vessels table"
		lb_result = false
		Goto Stop
	End if

	// Get profit center number
	SELECT PC_NR  
	INTO :li_pcnr
	FROM VESSELS
	WHERE VESSEL_NR = :ll_vessel_id;
	COMMIT;
End if

lb_result = false

// Now loop through all cargos and do the processing on each. 
For ll_cargo_count = 1 To ll_cargo_rows

	// Cargo check
	uf_select_cargo(ll_cargo_count)

	/** Following added by REM 16/10-2002 as speed is given for additional ballast and load **/
	/* Validate additional days Ballasted*/
	IF (NOT dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_ballast")=0 OR &
	    NOT dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_cal_carg_add_days_ballast_pcnt")=0) AND &
		 Isnull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed")) then
		 	uf_update_speed()
			 //astr_parm.result.s_errortext = "Please select a speed for Additional Days Ballast"
			//Goto Stop
	END IF
	
	/* Validate additional days Laden*/
	IF (NOT dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_laden")=0 OR &
	    NOT dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_add_days_laden_pcnt")=0) AND &
		 Isnull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed")) then
		 	uf_update_speed()
		 	//astr_parm.result.s_errortext = "Please select a speed for Additional Days Laden"
			//Goto Stop
	END IF
	/** End of addition made by REM 16/10-2002 ***********************************************/

	// The following section is only valid for non-ballast voyages, since
	// it check the # of ports, quantity, etc. etc.
	If not ib_ballastvoyage Then
		
		// Check that we have at least one load + one dischport
		If  (dw_loadports.RowCount()=0) Or (dw_dischports.RowCount()=0) Then
			astr_parm.result.s_errortext = "At least 1 load and 1discharge port has to be defined"
			Goto Stop
		End if

		// Check total for load units.
		ld_totalunits = dw_loadports.GetItemNumber(1,"total_units")
		If ld_totalunits <= 0 Then
			astr_parm.result.s_errortext = "Error in quantity for loadports (must be above zero)"
			dw_loadports.SetColumn("cal_caio_number_of_units")
			dw_loadports.SetFocus()
			Goto Stop
		End if

		// Check total for disch units.
		If dw_dischports.GetItemNumber(1,"total_units") >= 0 Then
			astr_parm.result.s_errortext = "Error in quantity for dischports (must be below zero)"
			dw_dischports.SetColumn("cal_caio_number_of_units")
			dw_dischports.SetFocus()
			Goto Stop
		End if

		// Check load and dischport datawindows.
		If not uf_process_cargos(astr_parm, dw_loadports, astr_parm.cargolist[ll_cargo_count].str_inouts, astr_parm.cargolist[ll_cargo_count].d_expenses,ll_cargo_count, li_pcnr) Then Goto Stop
		If not uf_process_cargos(astr_parm, dw_dischports, astr_parm.cargolist[ll_cargo_count].str_inouts, astr_parm.cargolist[ll_cargo_count].d_expenses,ll_cargo_count, li_pcnr) Then Goto Stop

		// Calculating heating, deviation and misc. claims
		astr_parm.cargolist[ll_cargo_count].i_carg_id = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_id")
		astr_parm.cargolist[ll_cargo_count].d_commission_percent = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_temp_comission")
		astr_parm.cargolist[ll_cargo_count].d_adr_commission_percent = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_adr_commision")

		// Insert into structure that u_heat_dev_misc is called with
		ll_cargo_id = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_id")
		uf_heat_dev(ll_cargo_id, astr_parm,ll_cargo_count)
		uf_misc_claims(ll_cargo_id)

		// Call calculation module for calculation' claims
		u_heat_dev_misc uo_heat_dev_misc
		uo_heat_dev_misc = Create u_heat_dev_misc
		uo_heat_dev_misc.uf_calculate(istr_hea_dev_misc_parm)
		Destroy uo_heat_dev_misc

		// Insert result of misc claims calculation in gross freight, misc. income, broker and address commission 
		// in the cargo structure for each cargo
		astr_parm.cargolist[ll_cargo_count].d_claims_adrs_comm += istr_hea_dev_misc_parm.d_addrs_comm_amount
		//astr_parm.cargolist[ll_cargo_count].d_claims_broker_comm += istr_hea_dev_misc_parm.d_broker_comm_amount
		astr_parm.cargolist[ll_cargo_count].d_claims_gross_freight += istr_hea_dev_misc_parm.d_gross_freight_amount
		astr_parm.cargolist[ll_cargo_count].d_claims_misc_income += istr_hea_dev_misc_parm.d_misc_income_amount
		
		/* calculation lumpsum */
		dw_calc_lumpsum.accepttext( )
		ll_lumpsums = dw_calc_lumpsum.rowCount()
		for ll_lumpsum = 1 to ll_lumpsums
			if ll_lumpsums=1 and isnull(dw_calc_lumpsum.getitemdecimal(1, "cal_lump_add_lumpsum"))  then
				dw_calc_lumpsum.deleterow(ll_lumpsum)
			else
				if isnull(dw_calc_lumpsum.getitemdecimal(ll_lumpsum, "cal_lump_add_lumpsum")) then
					astr_parm.result.s_errortext = "Please input the amount for the additional lumpsum."
					dw_calc_lumpsum.SetFocus()
					dw_calc_lumpsum.scrolltorow(ll_lumpsum)
					goto Stop
				end if
			end if
		next
	End if
		
	// If we were just checking for save, then continue now
	// ********************************************************************
	// ALL CODE THAT IS TO BE PROCESSED FOR SAVING, MUST BE ABOVE THIS LINE
	// ********************************************************************
	If astr_parm.i_function_code = 1 Then Continue 


	// OK, it was not only a save, so this is either a "calculation" process,
	// or a fixture process. 
	If not ib_ballastvoyage Then
		// Check that load quantity = disch quantity
		if ld_totalunits <> - dw_dischports.GetItemNumber(1,"total_units") Then
			astr_parm.result.s_errortext = "Cargo load total differs from disch total"
			Goto Stop
		End if 

		// And check the itinerary for each cargo
		If Not uf_check_load(astr_parm.cargolist[ll_cargo_count].str_inouts, astr_parm.result.s_errortext) then Goto Stop
	Else
		// This is a ballast voyage, set total units to 0
		ld_totalunits = 0
	End if

	// Update datawindows & astr_parm
	dw_cargo_summary.SetItem(ll_cargo_count,"cal_carg_cal_carg_total_units", ld_totalunits)
	astr_parm.cargolist[ll_cargo_count].d_totalunits = ld_totalunits

	// Get freighttype - and rate from the cargo, and validate it. Validation depends
	// on the freighttype. Eg. Lumpsum must not be 0 (but could be negative!), Unitrate
	// must not be below 0 and worldscale rate must not be 0.
	If not ib_ballastvoyage Then
		ll_ratetype =  dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_freight_type")
		astr_parm.cargolist[ll_cargo_count].i_rate_type = ll_ratetype
		CHOOSE CASE ll_ratetype 
			CASE 1,2  // $ pr. unit
				astr_parm.cargolist[ll_cargo_count].d_unitrate = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_freight_rate") 					
				If astr_parm.cargolist[ll_cargo_count].d_unitrate<0 Then
					astr_parm.result.s_errortext = "No freightrate specified"
					dw_cargo_summary.SetFocus()
					dw_cargo_summary.SetColumn("cal_carg_freight_rate")
					Goto Stop	
				End if	
			CASE 3 // Lumpsum
				astr_parm.cargolist[ll_cargo_count].d_lumpsum =  dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_lumpsum")
				If astr_parm.cargolist[ll_cargo_count].d_lumpsum=0 Then
					astr_parm.result.s_errortext = "No lumpsum specified"
					dw_cargo_summary.SetFocus()
					dw_cargo_summary.SetColumn("cal_carg_lumpsum")
					Goto Stop	
				End if	
			CASE 4 // Worldscale
				astr_parm.cargolist[ll_cargo_count].d_wsrate = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_ws_rate")
				If astr_parm.cargolist[ll_cargo_count].d_wsrate=0 Then
					astr_parm.result.s_errortext = "No worldscale rate specified"
					dw_cargo_summary.SetFocus()
					dw_cargo_summary.SetColumn("cal_carg_ws_rate")
					Goto Stop	
				End if	

		END CHOOSE 			
	End if

	// Copy misc. data to the astr_parm array
	for li_add_lumpsum = 1 to dw_calc_lumpsum.rowcount()
		astr_parm.cargolist[ll_cargo_count].d_add_lumpsum[li_add_lumpsum] = dw_calc_lumpsum.getitemdecimal( li_add_lumpsum, "cal_lump_add_lumpsum")
		astr_parm.cargolist[ll_cargo_count].i_adr_commission_on_lumpsum[li_add_lumpsum] = dw_calc_lumpsum.getitemdecimal( li_add_lumpsum, "cal_lump_adr_comm")
		astr_parm.cargolist[ll_cargo_count].i_bro_commission_on_lumpsum[li_add_lumpsum] = dw_calc_lumpsum.getitemdecimal( li_add_lumpsum, "cal_lump_bro_comm")
	next
	astr_parm.cargolist[ll_cargo_count].i_reversible = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_reversible")
	astr_parm.cargolist[ll_cargo_count].d_min_1 = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_min_1")
	astr_parm.cargolist[ll_cargo_count].d_min_2 = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_min_2")
	astr_parm.cargolist[ll_cargo_count].i_overage_1 = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_overage_1")
	astr_parm.cargolist[ll_cargo_count].i_overage_2 = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_overage_2")

	// Validate correct combination of min and overage.
	If IsNull(astr_parm.cargolist[ll_cargo_count].d_min_2) Then astr_parm.cargolist[ll_cargo_count].d_min_2 = 0
	If IsNull(astr_parm.cargolist[ll_cargo_count].d_min_1) Then astr_parm.cargolist[ll_cargo_count].d_min_1 = 0

	If astr_parm.cargolist[ll_cargo_count].d_min_1 = 0 And astr_parm.cargolist[ll_cargo_count].i_overage_1> 0 Then
			MessageBox("Calculation warning", "Invalid min/overage combination~r~n (min 1 = 0 and overage 1 is > 0)~r~n~r~nSetting overage 1 to 0")
			astr_parm.cargolist[ll_cargo_count].i_overage_1 =  0 
			dw_cargo_summary.SetItem(ll_Cargo_count, "cal_carg_overage_1",0)			 	
	End if

	If astr_parm.cargolist[ll_cargo_count].d_min_2 = 0 And astr_parm.cargolist[ll_cargo_count].i_overage_2> 0 Then
			MessageBox("Calculation warning", "Invalid min/overage combination~r~n(min 2 = 0 and overage 2 is > 0)~r~n~r~nSetting overage 2 to 0")
			astr_parm.cargolist[ll_cargo_count].i_overage_2 =  0 
			dw_cargo_summary.SetItem(ll_Cargo_count, "cal_carg_overage_2",0)			 	
	End if

	// Copy more data to the astr_parm array
	astr_parm.cargolist[ll_cargo_count].i_local_flatrate = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_local_flatrate")
	astr_parm.cargolist[ll_cargo_count].d_flatrate = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_flatrate")
	astr_parm.cargolist[ll_cargo_count].d_add_income = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_cal_carg_misc_income")

	/* Added days ballasted with ballast consumption and speed */
	astr_parm.cargolist[ll_cargo_count].d_add_days_ballasted = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_ballast")
	astr_parm.cargolist[ll_cargo_count].d_add_days_ballasted_speed = dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed")

	/* Added days ballasted percent */
	astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_cal_carg_add_days_ballast_pcnt")
	If IsNull(astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt) Then
		astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt = 0
	End If

	/* Added days laden with laden consumption and speed*/
	astr_parm.cargolist[ll_cargo_count].d_add_days_sea = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_laden")
	astr_parm.cargolist[ll_cargo_count].d_add_days_laden_speed = dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed")

	/* Added days laden percent */
	astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_add_days_laden_pcnt")
	If IsNull(astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt) Then
		astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt = 0
	End If

	/* Added days idle and bunkering */
	astr_parm.cargolist[ll_cargo_count].d_add_days_idle = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_cal_carg_idle_days")
	astr_parm.cargolist[ll_cargo_count].d_add_days_bunkering =  dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_cal_carg_bunkering_days")

	/* Added days in port with port consumption */
	astr_parm.cargolist[ll_cargo_count].d_add_days = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_days_other") 

	astr_parm.cargolist[ll_cargo_count].d_add_fo = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_fo")
	astr_parm.cargolist[ll_cargo_count].d_add_do = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_do")
	astr_parm.cargolist[ll_cargo_count].d_add_mgo = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_mgo")
	astr_parm.cargolist[ll_cargo_count].d_add_expenses += dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_expenses")
	If IsNull(astr_parm.cargolist[ll_cargo_count].d_expenses) Then astr_parm.cargolist[ll_cargo_count].d_expenses = 0
	
	// Get reversible flags from C/P (if CP is defined). If no C/P is defined, and
	// we're doing a fixture on this cargo, then produce an error to the user.
	astr_parm.cargolist[ll_cargo_count].l_cerp_id = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_cerp_id")
	If astr_parm.cargolist[ll_cargo_count].l_cerp_id > 0 Then

		SELECT CAL_CERP_REV_DEM,
			CAL_CERP_REV_FREIGHT
		INTO :astr_parm.cargolist[ll_cargo_count].i_reversible_cp,
			:astr_parm.cargolist[ll_cargo_count].i_reversible_freight
		FROM CAL_CERP
		WHERE CAL_CERP_ID = :astr_parm.cargolist[ll_cargo_count].l_cerp_id ;
		COMMIT;
	Else
		// Check that C/P is choosen if this cargo is being fixtured.
		If (astr_parm.i_function_code = 3) Then
			If (astr_parm.fixturelist[ll_cargo_count]) Then		
				astr_parm.result.s_errortext = "No C/P defined"
				Goto Stop
			End if
		End if 
	End if		

	// If we were just checking for calculation, then continue now
	// *************************************************************************
	// ALL CODE THAT IS TO BE PROCESSED FOR CALCULATION, MUST BE ABOVE THIS LINE
	// *************************************************************************
	If (astr_parm.i_function_code <= 2)  Then Continue
		
	// Check if this cargo is to be fixtured at all, if not we continue
	If not (astr_parm.fixturelist[ll_cargo_count]) Then Continue 

	// Validate laycan start and end dates
	ldt_laycan_start = dw_cargo_summary.GetItemDateTime(ll_cargo_count,"cal_carg_cal_carg_laycan_start")
	If Isnull(ldt_laycan_start) Then 
		astr_parm.result.s_errortext = "There has to be a Laycan Start date!"
		Goto Stop
	End If

	ldt_laycan_end = dw_cargo_summary.GetItemDateTime(ll_cargo_count,"cal_carg_cal_carg_laycan_end")
	If Isnull(ldt_laycan_end) Then 
		astr_parm.result.s_errortext = "There has to be a Laycan End date!"
		Goto Stop
	End If

	//  Move the amount in additional expenses into misc. expenses on the first load port
	ld_add_expenses = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_add_expenses")
	ll_caio_id = dw_loadports.GetItemNumber(1, "cal_caio_id")

	If (ld_add_expenses <> 0) Then
		// Due to and old def, it's not possible to move the expenses to the first
		// loadport, before the calculation has been saved. This is because we need
		// the CAL_CAIO ID's before we can save. Check that these ID's is valid,
		// otherwise break with and errormessage.
		If  (ll_caio_id =  0 Or IsNull(ll_caio_id)) Then
			astr_parm.result.s_errortext = "Unable to move expenses to loadport since the cargo isn't saved.~r~n~r~nSave the calculation before proceeding."
			Goto Stop
		End if

		// This code copies the additional expenses to the dw_calc_port_expenses (PEXP)
		// datawindow, and updates the MISC_EXPENSES field with the sum.
		If ld_add_expenses > 0 Then
			dw_calc_port_expenses.SetFilter("cal_caio_id = " + String(ll_caio_id))
			dw_calc_port_expenses.Filter()
	
			ll_row = dw_calc_port_expenses.InsertRow(0)
				
			dw_calc_port_expenses.SetItem(ll_row, "cal_caio_id", ll_caio_id)
			dw_calc_port_expenses.SetItem(ll_row, "cal_pexp_amount", ld_add_expenses)
			dw_calc_port_expenses.SetItem(ll_row, "cal_pexp_description", "Total misc. expenses")
			dw_calc_port_expenses.SetItem(ll_row, "cal_pexp_cal_pexp_order", ll_row)

			dw_calc_port_expenses.Filter()

			li_exp_max =  dw_calc_port_expenses.RowCount()
			ld_misc_exp = 0

			FOR li_exp_count = 1 TO li_exp_max
				ld_tmp = dw_calc_port_expenses.GetItemNumber(li_exp_count, "cal_pexp_amount")
				If Not IsNull(ld_tmp) Then ld_misc_exp += ld_tmp
			Next

			dw_loadports.SetItem(1, "cal_caio_misc_expenses", ld_misc_exp)
		End if

		dw_cargo_summary.SetItem(ll_cargo_count,"cal_carg_add_expenses",0)
	End if
Next

/** Following added by REM 16/10-2002 as speed is given for additional ballast and load **/
/* Check that the speeds for additionals are the same for all cargoes */
setNull(ld_ballast_speed)
setNull(ld_laden_speed)
FOR ll_cargo_count = 1 to ll_cargo_rows
	IF NOT isNull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed")) and &
		isNull(ld_ballast_speed) then
			ld_ballast_speed = dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed")
	END IF
	IF NOT isNull(ld_ballast_speed) and &
		NOT IsNull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed")) THEN
			IF dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed") <> ld_ballast_speed THEN
				astr_parm.result.s_errortext = "Please select same speed for Additional Days Ballast on all cargoes"
				Goto Stop
			END IF
	END IF

	IF NOT isNull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed")) and &
		isNull(ld_laden_speed) then
			ld_laden_speed = dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed")
	END IF
	IF NOT isNull(ld_laden_speed) and &
		NOT IsNull(dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed")) THEN
			IF dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed") <> ld_laden_speed THEN
				astr_parm.result.s_errortext = "Please select same speed for Additional Days Laden on all cargoes"
				Goto Stop
			END IF
	END IF
NEXT
/* End of additions made by REM 16/10-2002 ************************************************  */

lb_result = true

// Ok, everything went well, show a last warning-dialog to the user.
If astr_parm.i_function_code=3 Then 
	lb_result =  MessageBox("Warning", "Perform fixture ?", Exclamation!, YesNo!,2) = 1
	If not lb_result then astr_parm.result.s_errortext = "Fixture was aborted!"
End if

Stop:

// If anything went wrong, then add information about cargo # to the error message
If Not lb_result Then astr_parm.result.s_errortext = "Cargo no. " + String(ll_cargo_count)+ "~r~n~r~n" + astr_parm.result.s_errortext
Return(lb_result)
end function

public subroutine uf_update_speed ();// If the user changes the ship or Laden/Ballasted days selctected with no Speed. Then 
// Get/Set the new speed for laden and ballasted if days entered
Long ll_cargo_rows, ll_cargo_count
Integer li_speed_max, li_speed_count, li_speedtype, li_speedrow, li_max
Double ld_speed, ld_alt_speed

// Get number of cargorows to ll_cargo_rows
ll_cargo_rows = dw_cargo_summary.RowCount()
//Laden speed
For ll_cargo_count = 1 To ll_cargo_rows
IF (NOT dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_laden")=0 OR &
	    NOT dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_add_days_laden_pcnt")=0) THEN
	
	//if uo_global.ib_full_speed then   /* Find highest speed */
		li_speed_max = UpperBound(iuo_calc_nvo.istr_speedlist)

		ld_speed = Round(dw_cargo_summary.GetItemNumber(ll_cargo_count, "laden_speed"),4)
		li_speedtype = 2
		li_speedrow = 0
		if uo_global.ib_full_speed then 
			ld_alt_speed = 0
		else
			ld_alt_speed = 9999
		end if

		For li_speed_count = 1 To li_speed_max

		// We only want to check li_speedtype entries, so continue if something else
			If (iuo_calc_nvo.istr_speedlist[li_speed_count].i_type <> li_speedtype) Then Continue

		// Find selected speed and exit if found
			If (Round(iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed,4) = ld_speed) And &
		   (not ld_speed=0) Then
				li_speedrow = li_speed_count
				Exit
			End if

		// or otherwise select highest or lowest speed
			if uo_global.ib_full_speed then   /* Find highest speed */
				If iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed > ld_alt_speed Then
					li_speedrow = -li_speed_count
					ld_alt_speed = iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed
				End if
			else   /* Find slowest speed */
				If iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed < ld_alt_speed Then
					li_speedrow = -li_speed_count
					ld_alt_speed = iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed
				End if
			end if
		Next

	// If we didn't find the precise speed, then use the next-best, and update
	// the datawindow with the new speed.
		If li_speedrow < 0 Then
			li_speedrow = Abs(li_speedrow)
			ld_speed = iuo_calc_nvo.istr_speedlist[li_speedrow].d_speed
			dw_cargo_summary.SetItem(ll_cargo_count, "laden_speed", ld_speed)
		ELSE
			dw_cargo_summary.SetItem(ll_cargo_count, "laden_speed", ld_speed)
		END IF
END IF

//Ballasted speed

IF (NOT dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_add_days_ballast")=0 OR &
	    NOT dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_cal_carg_add_days_ballast_pcnt")=0)  then
	//if uo_global.ib_full_speed then   /* Find highest speed */
		li_speed_max = UpperBound(iuo_calc_nvo.istr_speedlist)

		ld_speed = Round(dw_cargo_summary.GetItemNumber(ll_cargo_count, "ballast_speed"),4)
		li_speedtype = 1
		li_speedrow = 0
		if uo_global.ib_full_speed then 
			ld_alt_speed = 0
		else
			ld_alt_speed = 9999
		end if

		For li_speed_count = 1 To li_speed_max

		// We only want to check li_speedtype entries, so continue if something else
			If (iuo_calc_nvo.istr_speedlist[li_speed_count].i_type <> li_speedtype) Then Continue

		// Find selected speed and exit if found
			If (Round(iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed,4) = ld_speed) And &
		   (not ld_speed=0) Then
				li_speedrow = li_speed_count
				Exit
			End if

		// or otherwise select highest or lowest speed
			if uo_global.ib_full_speed then   /* Find highest speed */
				If iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed > ld_alt_speed Then
					li_speedrow = -li_speed_count
					ld_alt_speed = iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed
				End if
			else   /* Find slowest speed */
				If iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed < ld_alt_speed Then
					li_speedrow = -li_speed_count
					ld_alt_speed = iuo_calc_nvo.istr_speedlist[li_speed_count].d_speed
				End if
			end if
		Next

	// If we didn't find the precise speed, then use the next-best, and update
	// the datawindow with the new speed.
		If li_speedrow < 0 Then
			li_speedrow = Abs(li_speedrow)
			ld_speed = iuo_calc_nvo.istr_speedlist[li_speedrow].d_speed
			dw_cargo_summary.SetItem(ll_cargo_count, "ballast_speed", ld_speed)
		ELSE
			dw_cargo_summary.SetItem(ll_cargo_count, "ballast_speed", ld_speed)
		END IF
END IF
Next
end subroutine

public subroutine of_lock_port (ref datawindow adw, long al_cal_caio_id, integer ai_status);long ll_found
ll_found = adw.find("cal_caio_id="+string(al_cal_caio_id),1,999)
if ll_found > 0 then 
	adw.SetItem(ll_found, "proceed_locked", 1)
	if (ai_status = 6 ) then
		adw.SetItem(ll_found, "edit_locked", 1)
	else
		adw.SetItem(ll_found, "edit_locked", 2)
	end if						
end if
end subroutine

private subroutine documentation ();/********************************************************************
   ObjectName: cargo object
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY> 
   Date	   CR-Ref	 Author	 Comments
  05/08/10	?	   	 JSU042	 Start logging
  05/08/10	CR1017	 JSU042	 Made multi calculation lumpsums
  09/02/11  CR1549	 JSU042	 BP calculations are in read only since multi currency calculation
  23/03/16  CR4157	 LHG008	 Default Speed extended(Remove the "ask for speed when calculating" feature)
</HISTORY>    
********************************************************************/
end subroutine

private function integer _checksettlement ();/********************************************************************
   FunctionName: of_checksettlement
   <DESC>	This function checks if there are any Claims connected to Calculation
				that has the balance of 0 (Zero) and where there is a receivable registred. 
				If so the user is not allowed to change any addtional lumpsums. 
				Will have a message saying that he/she has to contact Finance department 
				in order to modify the additional lumpsums. They have to delete the receivables.
  </DESC>
   <RETURN>	Integer:
					1: nothing is settled
					-1: freight claim is settled
					-2: other claims are settled
					-3: broker commission is settled
  </RETURN>
********************************************************************/
long		ll_cal_calc_id, ll_cal_fix_id, ll_cal_est_id 
integer	li_cal_calc_status, li_comm_settled
n_ds		lds_data, lds_voyages
long	ll_voyrows, ll_voyrow, ll_claimrows, ll_claimrow
long 	ll_vessel
string	ls_voyage

//get the current cal_calc_id
ll_cal_calc_id = dw_cargo_summary.GetItemNumber(1, "cal_calc_id")

//see the calculation type
SELECT CAL_CALC_STATUS
INTO :li_cal_calc_status
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_cal_calc_id
COMMIT;

//get estimated calculation id
IF li_cal_calc_status = 5 THEN//not estimated
	SELECT CAL_CALC_FIX_ID
	INTO :ll_cal_fix_id
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_cal_calc_id
	COMMIT;
	SELECT CAL_CALC_ID
	INTO :ll_cal_est_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_cal_fix_id
	AND CAL_CALC_STATUS = 6
	COMMIT;
ELSE//estimated
	ll_cal_est_id = ll_cal_calc_id
END IF

if isnull(ll_cal_est_id) then return 1

//get voyage number
lds_voyages = create n_ds
lds_voyages.dataObject = "d_sq_tb_voyages_by_calc"
lds_voyages.setTransObject(SQLCA)
lds_voyages.retrieve(ll_cal_est_id)
ll_voyrows = lds_voyages.rowCount()

lds_data = create n_ds
lds_data.dataObject = "d_sq_tb_check_claimbalance"
lds_data.setTransObject(sqlca)

//check settlement
if ll_voyrows > 0 then
	for ll_voyrow = 1 to ll_voyrows
		ll_vessel = lds_voyages.getItemNumber(ll_voyrow, "vessel_nr")
		ls_voyage = lds_voyages.getItemString(ll_voyrow, "voyage_nr")
		ll_claimrows = lds_data.retrieve( ll_vessel, ls_voyage )	
		for ll_claimrow = 1 to ll_claimrows
//			//check broker commission
//			SELECT COMM_SETTLED
//			INTO :li_comm_settled
//			FROM COMMISSIONS
//			WHERE VESSEL_NR = :ll_vessel
//			AND VOYAGE_NR = :ls_voyage;
//			COMMIT;
//			if sqlca.sqlcode = 0 and li_comm_settled = 1 then
//				destroy lds_data
//				destroy lds_voyages
//				return -3			
//			end if
			//check freight claim
			if abs(lds_data.getitemNumber(ll_claimrow, "claim_amount") - lds_data.getItemNumber(ll_claimrow, "transactions")) < 1 then
				if (lds_data.getitemNumber(ll_claimrow, "freight_received") + lds_data.getItemNumber(ll_claimrow, "trans_received")) > 0 then
					if lds_data.getitemString(ll_claimrow, "claim_type") = "FRT" then
						destroy lds_data
						destroy lds_voyages
						return -1
					else
						destroy lds_data
						destroy lds_voyages
						return -2
					end if
				end if
			end if
		next	
	next	
end if

destroy lds_data
destroy lds_voyages
return 1
end function

private function integer _getsettledclaimcounts (ref integer ai_settledfreight, ref integer ai_settledother);/********************************************************************
   FunctionName: _checksettlement
   <DESC>	This function checks if there are any Claims connected to Calculation
				that has the balance of 0. 
				If so the user is not allowed to change any addtional lumpsums. 
				Will have a message saying that he/she has to contact Finance department.
  </DESC>
   <RETURN>	Integer:
					1: nothing is settled 
					-1: freight claim is settled
					-2: other claims are settled
  </RETURN>
  <ACCESS> Private	</ACCESS>
   <ARGS>	None	</ARGS>
   <USAGE>	Calling from uf_delete_add_lump( )
				uf_insert_add_lump( )
				dw_calc_lumpsum.itemchanged()	
				dw_cargo_summary.itemchanged()
    </USAGE>
********************************************************************/
long		ll_cal_calc_id, ll_cal_fix_id, ll_cal_est_id 
integer	li_cal_calc_status, li_comm_settled, li_settled=0
mt_n_datastore lds_claimdata
long	ll_row
long 	ll_vessel
string	ls_voyage

ll_cal_calc_id = dw_cargo_summary.GetItemNumber(1, "cal_calc_id")
li_cal_calc_status = iuo_calc_nvo.iuo_calculation.uf_get_status(0) 
 
//get estimated calculation id
if li_cal_calc_status <= 5 then 
	ll_cal_fix_id = iuo_calc_nvo.iuo_calculation.uf_get_fix_id( )
	SELECT 
		CAL_CALC_ID
	INTO 
		:ll_cal_est_id
	FROM 
		CAL_CALC
	WHERE 
		CAL_CALC_FIX_ID = :ll_cal_fix_id AND 
		CAL_CALC_STATUS = 6
	USING sqlca;
	
	if sqlca.sqlcode = 100 then
		/* not found */
		return c#return.NoAction
	elseif sqlca.sqlcode>0 then
		_addmessage( this.classdefinition, "_checksettlement()", "Technical Error with the Database", "can not get voyage/vessel data" + sqlca.sqlerrtext)
		return c#return.Failure
	end if	
	
else 
	ll_cal_est_id = ll_cal_calc_id
end if

if isnull(ll_cal_est_id) then 
	return 1
else
	SELECT 
		VOYAGES.VESSEL_NR,
		VOYAGES.VOYAGE_NR   
	INTO 
		:ll_vessel, :ls_voyage
	FROM 
		VOYAGES  
	WHERE 
		VOYAGES.CAL_CALC_ID = :ll_cal_est_id
	USING sqlca;
	
	if sqlca.sqlcode = 100 then
		/* not found */
		return c#return.NoAction
	elseif sqlca.sqlcode>0 then
		_addmessage( this.classdefinition, "_checksettlement()", "Technical Error with the Database", "can not get voyage/vessel data" + sqlca.sqlerrtext)
		return c#return.Failure
	end if	
	
	lds_claimdata = create mt_n_datastore
	lds_claimdata.dataObject = "d_sq_tb_check_claimbalance"
	lds_claimdata.setTransObject(sqlca)
	
	/* check claim amounts */
	for ll_row = 1 to lds_claimdata.retrieve( ll_vessel, ls_voyage )
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
	Public/Protected/Private
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	Before calling of_insert..() of_delete..() functions.  A copy of this
	function resides in the u_atobviac_calc_compact object.
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

public subroutine of_deletelumpsum (u_datawindow_sqlca adw);/********************************************************************
   FunctionNam: of_deletelumpsum
   <DESC>	The functionh is used to delete an addtional lumpsum. The addtional lumpsums 
					can not be deleted when the freight claim is settled. Users need to contact finance
					department.
  </DESC>
   <RETURN>	None   	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>		Integer: al_row	     </ARGS>
   <USAGE>	Calling from uf_delete_port( ) </USAGE>
********************************************************************/
integer li_row, li_locked, li_settled
long ll_currentrow
integer li_settledfreight=0, li_settledother=0

li_row = adw.getrow()

if adw.rowcount( ) <= 0 then 
	MessageBox("Information", "There is no addtional lumpsum left.", StopSign!)
	return
end if

li_locked = adw.getitemnumber(li_row, "locked")

// Drop deletion if it is locked
if li_locked <> 0 Then
	MessageBox("Information", "You cannot delete a locked addtional lumpsum.", StopSign!)
	return
end if

//check if the freight claim is already settled
_getsettledclaimcounts( li_settledfreight, li_settledother )

//check if the freight claim is already settled
if li_settledfreight > 0 then
	_addmessage( this.classdefinition, "of_deletelumpsum()", "Information.  You can not delete the additional lumpsums, because the freight claim is already settled. Please contact Finance department in order to modify the additional lumpsums.", "user Information warning")
	return
end if

if messagebox("Warning","You are about to delete an additional lumpsum. Continue?",Stopsign!,YesNoCancel!,2) = 1 then
	if not isnull(dw_calc_lumpsum) then
		if li_row > 0 then
			adw.deleteRow(li_row)
			if li_row > 1 then li_row --
			adw.setrow(li_row)
			triggerevent("ue_childmodified")
		end if
	end if
end if

return
end subroutine

public subroutine of_deleteport (u_datawindow_sqlca adw_port);/********************************************************************
   of_deleteport()
	
<DESC>   
	Arthur Andersen PowerBuilder Development
	 
	Deletes data from supporting datawindows on the cargo object within the
 	calculation. This is the current (focused) port in load or disch dw's
	 
	This function is used by both this object and the compact.
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
	adw <u_datawindow_sqlca> : either the load or discharge port datawindow   
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
<HISTORY> 
  Date		CR-Ref	  Author	 				Comments
  ??/??/??	?	        Martin Israelsen   Initial version
  20/09-11	barca     AGL027   				Refactored
</HISTORY>
  
*********************************************************************/

long ll_row
integer li_locked

ll_row = adw_port.getrow()

/* Check if ll_row = 0 or if the port is locked.  (If ll_row = 0 then the rows will be locked due to a PB4 error) */
if (ll_row = 0) then li_locked = 1 else li_locked = adw_port.getitemnumber(ll_row, "edit_locked")

/* Drop deletion if the port is locked */
if li_locked <> 0 Then
	messageBox("Information", "You cannot delete a locked port", StopSign!)
	return
end if

if messagebox("Warning","You are about to delete a port. Continue?",Stopsign!,YesNoCancel!,2) = 1 then
	/* Check that this in not the only port (a calculation must have atleast 1 load and 1 dischports). */
	if not isnull(adw_port) Then
		if adw_port.rowcount() = 1 Then
			messageBox("Error","You cannot delete the last port", StopSign!)
			return
		end if
		/* Now delete the port. */
		if ll_row > 0 then
			/* First delete all misc. expenses on this port ! */
			uf_delete_misc_exp( adw_port.GetItemNumber(ll_row,"cal_caio_id") )
			adw_port.deleterow(ll_row)
			if ll_row > 1 then ll_row --
			adw_port.setrow(ll_row)
			/* Tell the calculation system that the ports have changed and update the itinerary */
			uf_port_changed()
			iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_update_itinerary_order()
		end if
	end if
else
	return
end if
end subroutine

public subroutine of_insertlumpsum (u_datawindow_sqlca adw);/********************************************************************
   of_insertlumpsum()
<DESC>   
	inserts a lumpsum row into the datawindow
</DESC>
<RETURN>
	n/a
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	adw <u_datawindow_sqlca> : either the load or discharge port datawindow   
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

Integer	li_row, li_order
integer li_settledfreight=0,li_settledother=0
Long ll_Cargo_id, ll_cargo_row

//check if the freight claim is already settled
_getsettledclaimcounts( li_settledfreight, li_settledother )

if li_settledfreight > 0 then
	_addmessage( this.classdefinition, "of_insertlumpsum()", "Information.  You can not add the additional lumpsums, because the freight claim is already settled. Please contact Finance department in order to modify the additional lumpsums.", "user Information warning")
	return
end if

// Turn redraw off
adw.setredraw( false)

// Get current cargo and current cargo ID.
ll_cargo_row = dw_cargo_summary.getrow()
ll_cargo_id = dw_cargo_summary.getitemnumber(ll_cargo_row,"cal_carg_id")

// If the cargo ID is fake (negative) meaning that the cargo hasn't been saved yet,
// then set the cargo ID to MINUS Cargo row number. This will be the reference until
// the calculation is saved.
If (ll_cargo_id = 0) or Isnull(ll_cargo_id) Then ll_cargo_id = -ll_cargo_row

// Insert the new row, and scroll to it.
li_row = dw_calc_lumpsum.InsertRow(0)
adw.setfocus( )
adw.scrolltorow( li_row)
adw.setitem(li_row, "cal_carg_id", ll_cargo_id)

SELECT ISNULL(MAX(CAL_LUMP_ORDER),1) + :li_row
INTO :li_order
FROM CAL_LUMP
WHERE CAL_CARG_ID = :ll_cargo_id
USING sqlca;
	
if sqlca.sqlcode = 100 then
	/* not found */
elseif sqlca.sqlcode > 0 then
	_addmessage( this.classdefinition, "of_insertlumpsum()", "Technical Error with the Database", "Can not get the next id for lumpsum. " + sqlca.sqlerrtext)
end if

adw.setitem(li_row, "cal_lump_order", li_order)

// Turn redraw on
adw.setredraw( true)

end subroutine

public subroutine of_insertport (ref u_datawindow_sqlca adw);/********************************************************************
   of_insertport
	
<DESC>   
	 Arthur Andersen PowerBuilder Development
	 
	 This function is used by both this object and the compact.
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
	adw <u_datawindow_sqlca> : either the load or discharge port datawindow   
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
<HISTORY> 
  Date		CR-Ref	  	Author	 				Comments
  ??/??/??	?	        	Martin Israelsen   	Initial version
  20/09-11	D-CALC    	AGL027   				Refactored
</HISTORY>
********************************************************************/


Long ll_Cargo_id,ll_cargo_row, ll_port_row
Double ld_null		
Integer li_null

// Turn redraw off
adw.uf_redraw_off()

// Get current cargo and current cargo ID.
ll_cargo_row = dw_cargo_summary.getrow()
ll_cargo_id = dw_cargo_summary.getitemnumber(ll_cargo_row,"cal_carg_id")

// If the cargo ID is fake (negative) meaning that the cargo hasn't been saved yet,
// then set the cargo ID to MINUS Cargo row number. This will be the reference until
// the calculation is saved.
If (ll_cargo_id = 0) or Isnull(ll_cargo_id) Then ll_cargo_id = -ll_cargo_row

// Insert the new portrow, and scroll to it.
ll_port_row = adw.InsertRow(0)
adw.ScrollToRow(ll_port_row)

// Update the cargo ID link
adw.SetItem(ll_port_row,"cal_carg_id",ll_cargo_id)

// Update itinerary number, portcode, loadterms and set the purpose code to 
// L for loadports and D for dischports
il_itinerary_max ++
adw.SetItem(ll_port_row,"cal_caio_itinerary_number", il_itinerary_max)  // Skal rettes til itinerary number
adw.SetItem(ll_port_row,"port_code","          ")
adw.SetItem(ll_port_row,"cal_caio_load_terms", 0)
If adw = dw_loadports then adw.SetItem(ll_port_row,"purpose_code","L") else adw.SetItem(ll_port_row,"purpose_code","D")

// Find the min CAL_RATY_ID - this is the default Ratetype.
Long ll_tmp

SELECT MIN(CAL_RATY_ID)
INTO :ll_tmp
FROM CAL_RATY
USING sqlca;
	
if sqlca.sqlcode = 100 then
	/* not found */
elseif sqlca.sqlcode > 0 then
	_addmessage( this.classdefinition, "of_insertport()", "Technical Error with the Database", "Can not get the default rate type from the database. " + sqlca.sqlerrtext)
end if

adw.SetItem(ll_port_row,"cal_raty_id",ll_tmp)

// Update reversible fields, if this cargo is reversible. 
If dw_cargo_summary.GetItemNumber(ll_cargo_row,"cal_carg_cal_carg_reversible")=1 Or &
	ii_reversible_cp[ll_cargo_row]=1 Then
	SetNull(ld_null)
	SetNull(li_null)
	// uf_reversible will do the copying from the other port-rows to this portrow.
	uf_reversible(1, adw, 0, li_null, ld_null, ld_null, ld_null, li_null, ld_null)
	adw.SetColumn("port_code")	
End If

adw.ScrollToRow(ll_port_row)

// Tell the calculation system, that one or more ports has changed
uf_port_changed()

// and turn redraw back on
adw.uf_redraw_on()
end subroutine

on destructor;call u_calc_base_sqlca::destructor;// Destructor event, destroys the search objects

DESTROY iuo_dddw_search_load
DESTROY iuo_dddw_search_disch



end on

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_calc_cargos
  
  Event	 :  Constructor

 Scope     : 

 ************************************************************************************

 Author    : MIS
   
 Date       : 1-9-96

 Description : Creates search-objects

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

iuo_dddw_search_load = CREATE u_dddw_search
iuo_dddw_search_load.uf_setup(dw_loadports, "port_code", "port_n",true)
iuo_dddw_search_disch = CREATE u_dddw_search
iuo_dddw_search_disch.uf_setup(dw_dischports, "port_code", "port_n",true)


inv_serviceMgr.of_loadservice( inv_style, "n_dw_style_service")

/* setup datawindow formatter service */
inv_style.of_dwlistformater(dw_calc_lumpsum,false)
inv_style.of_dwlistformater(dw_loadports,false)
inv_style.of_dwlistformater(dw_dischports,false)
inv_style.of_dwformformater(dw_cargo_summary)

/* set the datawindow readonly, since it is the old calculation with BP Distance Table */
dw_cargo_summary.Modify("DataWindow.ReadOnly=Yes")
dw_calc_lumpsum.Modify("DataWindow.ReadOnly=Yes")
dw_loadports.Modify("DataWindow.ReadOnly=Yes")
dw_dischports.Modify("DataWindow.ReadOnly=Yes")
end event

on u_calc_cargos.create
int iCurrent
call super::create
this.st_2=create st_2
this.dw_calc_lumpsum=create dw_calc_lumpsum
this.st_1=create st_1
this.dw_calc_misc_claim=create dw_calc_misc_claim
this.dw_calc_port_expenses=create dw_calc_port_expenses
this.dw_calc_hea_dev_claim=create dw_calc_hea_dev_claim
this.dw_loadports=create dw_loadports
this.dw_dischports=create dw_dischports
this.dw_cargo_summary=create dw_cargo_summary
this.gb_1=create gb_1
this.r_1=create r_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.dw_calc_lumpsum
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_calc_misc_claim
this.Control[iCurrent+5]=this.dw_calc_port_expenses
this.Control[iCurrent+6]=this.dw_calc_hea_dev_claim
this.Control[iCurrent+7]=this.dw_loadports
this.Control[iCurrent+8]=this.dw_dischports
this.Control[iCurrent+9]=this.dw_cargo_summary
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.r_1
this.Control[iCurrent+12]=this.cb_1
end on

on u_calc_cargos.destroy
call super::destroy
destroy(this.st_2)
destroy(this.dw_calc_lumpsum)
destroy(this.st_1)
destroy(this.dw_calc_misc_claim)
destroy(this.dw_calc_port_expenses)
destroy(this.dw_calc_hea_dev_claim)
destroy(this.dw_loadports)
destroy(this.dw_dischports)
destroy(this.dw_cargo_summary)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.cb_1)
end on

type st_2 from statictext within u_calc_cargos
integer x = 2597
integer y = 572
integer width = 699
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Additional Lumpsums (frt)"
boolean focusrectangle = false
end type

type dw_calc_lumpsum from u_datawindow_sqlca within u_calc_cargos
event ue_keydown pbm_dwnkey
integer x = 2601
integer y = 632
integer width = 1943
integer height = 276
integer taborder = 30
string dataobject = "d_calc_lumpsum"
boolean border = false
end type

event constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

event sqlpreview;/****************************************************************************
Development Log 
DATE	         	VERSION 	NAME      	DESCRIPTION
2010, JUL, 14   INITIAL       JSU042        Calls uf_change_sql to get the sql string modified for the save operation
****************************************************************************/

uf_change_sql(7,dw_calc_lumpsum,sqlsyntax)
end event

type st_1 from statictext within u_calc_cargos
integer x = 3726
integer y = 456
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Charterer:"
boolean focusrectangle = false
end type

type dw_calc_misc_claim from u_datawindow_sqlca within u_calc_cargos
boolean visible = false
integer x = 539
integer y = 2040
string dataobject = "d_calc_misc_claim"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(6,dw_calc_misc_claim,sqlsyntax)
end event

type dw_calc_port_expenses from u_datawindow_sqlca within u_calc_cargos
boolean visible = false
integer x = 1042
integer y = 2048
integer width = 183
integer height = 144
string dataobject = "d_calc_port_expenses"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(4,dw_calc_port_expenses,sqlsyntax)
end event

type dw_calc_hea_dev_claim from u_datawindow_sqlca within u_calc_cargos
boolean visible = false
integer x = 55
integer y = 2040
string dataobject = "d_calc_hea_dev_claim"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(5,dw_calc_hea_dev_claim,sqlsyntax)
end event

type dw_loadports from u_datawindow_sqlca within u_calc_cargos
event ue_recalc_exp pbm_custom68
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
integer x = 23
integer y = 1008
integer width = 4544
integer height = 488
integer taborder = 20
string dataobject = "d_calc_cargo_in"
boolean hscrollbar = true
boolean vscrollbar = true
boolean ib_editmaskselect = true
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

event itemchanged;call super::itemchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Calls to uf_loaddisch_itemchanged which handles all changes to
				  the port row

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
if row > 0 then
	CHOOSE CASE dwo.name
		CASE "port_code"
			IF (len(data) <> 3) then
				Messagebox("Port code selection", "For loadport please select a portcode with length 3 characters")
				Return 2
			end if	
		case "cal_caio_number_of_units" 
			if dec(data) < 1 then
				MessageBox("Validation Error", "Quantity can't be 0 (zero) for Load ports")
				Return 1
			end if
	end choose
end if

uf_loaddisch_itemchanged(dw_loadports, iuo_dddw_search_load)

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
ll_current_cargo = uf_get_cargo()
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
uf_change_sql(2,dw_loadports,sqlsyntax)



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

event itemerror;call super::itemerror;return 1
end event

type dw_dischports from u_datawindow_sqlca within u_calc_cargos
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
integer x = 23
integer y = 1508
integer width = 4544
integer height = 488
integer taborder = 30
string dataobject = "d_calc_cargo_out"
boolean hscrollbar = true
boolean vscrollbar = true
boolean ib_editmaskselect = true
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
ll_current_cargo = uf_get_cargo()
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
uf_change_sql(3,dw_dischports,sqlsyntax)
end event

event itemchanged;call super::itemchanged;/****************************************************************************
Author		: MI
Date			: 1996
Description	: Set the number of units to negative in the units field

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
****************************************************************************/
Double ld_tmp

If  uf_loaddisch_itemchanged(dw_dischports, iuo_dddw_search_disch) = "cal_caio_number_of_units" Then
	// Set automatic minus in dischunits, if not supplied by user

	ld_tmp = Double(This.GetText())
	If ld_tmp > 0 Then 
		This.SetItem(This.GetRow(), "cal_caio_number_of_units", - ld_tmp)
		Return 2
	End if
End if

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "port_code"
			IF (len(data) <> 3) then
				Messagebox("Port code selection", "For discharge port please select a portcode with length 3 characters")
				Return 2
			end if	
	end choose
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

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
end if
end event

type dw_cargo_summary from u_datawindow_sqlca within u_calc_cargos
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 32
integer width = 4544
integer height = 956
integer taborder = 10
string dataobject = "d_calc_cargo_summary"
boolean livescroll = false
end type

event sqlpreview;call super::sqlpreview;/****************************************************************************
Author		: MI
Date			: August 1996
Description	: Calls uf_change_sql to get the sql string changed

Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------

****************************************************************************/
uf_change_sql(1,dw_cargo_summary,sqlsyntax)


end event

event rowfocuschanged;call super::rowfocuschanged;/****************************************************************************
Author		: TA
Date			: August 1996
Description	: Calls uf_select_cargo with the selected rownumber

Arguments	: currentrow is the selected rownumber
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------

****************************************************************************/
Long ll_row

ll_row = This.GetRow()
If ll_row > 0 Then uf_select_cargo(ll_row)

end event

event itemfocuschanged;call super::itemfocuschanged;DataWindowChild dwc_tmp
Integer li_speed_type
Long ll_speed_row, ll_speed_max, ll_speed_count
string ls_column

ls_column = This.GetColumnName()
CHOOSE CASE ls_column
	CASE "laden_speed"
		this.GetChild("laden_speed", dwc_tmp)
		dwc_tmp.Reset()
		ll_speed_max = UpperBound(iuo_calc_nvo.istr_speedlist[])
		For ll_speed_count = 1 To ll_speed_max
			
			If iuo_calc_nvo.istr_speedlist[ll_speed_count].i_type = 2 Then // Laden
				ll_speed_row = dwc_tmp.InsertRow(0)
				dwc_tmp.SetItem(ll_speed_row, "speed", iuo_calc_nvo.istr_speedlist[ll_speed_count].d_speed)
				dwc_tmp.SetItem(ll_speed_row, "name", iuo_calc_nvo.istr_speedlist[ll_speed_count].s_name)
			End if			
		Next
	CASE "ballast_speed"
		this.GetChild("ballast_speed", dwc_tmp)
		dwc_tmp.Reset()
		ll_speed_max = UpperBound(iuo_calc_nvo.istr_speedlist[])
		For ll_speed_count = 1 To ll_speed_max
			
			If iuo_calc_nvo.istr_speedlist[ll_speed_count].i_type = 1 Then // Ballast
				ll_speed_row = dwc_tmp.InsertRow(0)
				dwc_tmp.SetItem(ll_speed_row, "speed", iuo_calc_nvo.istr_speedlist[ll_speed_count].d_speed)
				dwc_tmp.SetItem(ll_speed_row, "name", iuo_calc_nvo.istr_speedlist[ll_speed_count].s_name)
			End if			
		Next
END CHOOSE


end event

event doubleclicked;call super::doubleclicked;string ls_column

if (row > 0) then

	if (Pixelstounits(xpos,XPixelsToUnits!) > 2377 and Pixelstounits(xpos,XPixelsToUnits!) < 2706 ) & 
		and (Pixelstounits(ypos,YPixelsToUnits!) > 120 and Pixelstounits(ypos,YPixelsToUnits!) < 172) then
			if (this.getitemnumber(row, "cal_carg_local_flatrate") <> 1) then
				of_open_worldscale(dw_loadports, dw_dischports, year(today()))
			end if
	end if


//ls_column = this.getcolumnname()
//CHOOSE CASE ls_column
//	CASE "cal_carg_flatrate"
//		if (this.getitemnumber(row, "cal_carg_local_flatrate") <> 1) then
//			of_open_worldscale(dw_loadports, dw_dischports, 2002)
//		end if
//END CHOOSE

	
	
end if
end event

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

event itemchanged;call super::itemchanged;/************************************************************************************
 Author    : MI
   
 Date       : August 1996

 Description : Handles changes in columns description, reversible freight, freight type
 					and reversible freight. 					

 Arguments : None

 Returns   : None
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Set local variables
String ls_column
Long ll_tmp, ll_row, ll_cerp_id,  ll_count, ll_value, ll_cargo_row
Integer li_dummy, li_messagebox, li_first_load
Double ld_dummy, ld_value

SetNull(ll_value)
SetNull(ld_value)

ll_row = This.GetRow()
ls_column = This.GetColumnName()
CHOOSE CASE ls_column
	CASE "cal_carg_description"
		// Cargo description has been changed, update system
		
		uf_description_changed()
		
	CASE "cal_carg_freight_type"
		// Freight type has been changed, now clear overage 1+2 and min 1+2
		
		This.SetItem(ll_row, "cal_carg_overage_1",0)
		This.SetItem(ll_row, "cal_carg_overage_2",0)
		This.SetItem(ll_row, "cal_carg_min_1",0)
		This.SetItem(ll_row, "cal_carg_min_2",0)

	CASE "cal_carg_cal_carg_reversible"
		// Reversible demurrage has been set on or off. Do the accepttext on load & dischports.
		dw_loadports.accepttext()
		dw_dischports.accepttext()

		ll_tmp = Integer(this.GetText())

		If ll_tmp = 1 Then
			// Reversible demurrage has been choosen. Copy contents to load and and discports
			// from first loadport
			If MessageBox("Warning", "Setting reversible will copy the contents of all load" + &
				" and discharge ports~r~n~r~nContinue ?", Exclamation!, YesNo!) <> 1 & 
				Then ll_tmp = -1
		Else 
			// Reversible demurrage has been unselected. Clear content of load and dischports
			li_messagebox = MessageBox("Information", "Contents of load and discharports" + &
				" will be cleared~r~n~r~nContinue ?", Exclamation!, YesNo!,2)
			// User choose no to proceed so return
			If li_messagebox = 2 Then
				ll_cargo_row = dw_cargo_summary.Getrow()
				dw_cargo_summary.SetItem(ll_cargo_row,"cal_carg_cal_carg_reversible",1)
				RETURN 2
			End if
		End if

		SetNull(li_dummy)
		SetNull(ld_dummy)

		// Copy cargo between load and dischports
		If ll_tmp <> -1 Then 	
			// ll_tmp = 1 = Copy, 2 = Clear
			// Copy all information from first loadport to all loadports / clear if ll_tmp = 2
			
			uf_reversible(ll_tmp, dw_loadports, 0, li_dummy, ld_dummy, ld_dummy, ld_dummy, li_dummy, ld_dummy)

			If ll_tmp = 1 Then
				// Copy information from first loadport to first dischport
				li_first_load = uf_get_first_loadport()
				dw_dischports.SetItem(1, "cal_caio_despatch", dw_loadports.GetItemNumber(li_first_load, "cal_caio_despatch"))
				dw_dischports.SetItem(1, "cal_caio_demurrage", dw_loadports.GetItemNumber(li_first_load, "cal_caio_demurrage"))
			End if

			// Same for dischports
			uf_reversible(ll_tmp, dw_dischports, 0, li_dummy, ld_dummy, ld_dummy, ld_dummy, li_dummy, ld_dummy)
		End if

		If ll_tmp = -1 Then Return 2
	CASE ELSE
		If ii_reversible_freight[ll_row] = 1 Then
			// If this is a reversible freight cargo, and one of the freight fields have
			// been changed, then copy information to all other reversible freights.

			// Get changed value from column
			CHOOSE CASE ls_column
				CASE "cal_carg_freight_type"
					ll_value = Integer(This.GetText())
				CASE "cal_carg_ws_rate", "cal_carg_lumpsum", "cal_carg_freight_rate", "cal_carg_flatrate", &
					"cal_carg_min_1", "cal_carg_min_2", "cal_carg_overage_1", "cal_carg_overage_2", &
					"cal_carg_local_flatrate"
					ld_value = Double(this.GetText())
			END CHOOSE

			// If value isen't null then
			If not(isnull(ll_value)) or not(isnull(ld_value)) Then
				ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_row, "cal_carg_cal_cerp_id")
				dw_cargo_summary.uf_redraw_off()

				// Insert into the same column on cargoes with identical CP id
				For ll_count = 1 To ii_no_cargos
					If ll_cerp_id = dw_cargo_summary.GetItemNumber(ll_count, "cal_carg_cal_cerp_id") Then
						If IsNull(ll_value) Then
							dw_cargo_summary.SetItem(ll_count, ls_column, ld_value)
						Else
							dw_cargo_summary.SetItem(ll_count, ls_column, ll_value)
						End if
					End if
				Next

				dw_cargo_summary.uf_redraw_on()
			End if			
		End if
END CHOOSE


end event

type gb_1 from mt_u_groupbox within u_calc_cargos
boolean visible = false
integer x = 1664
integer y = 2040
integer taborder = 40
end type

type r_1 from rectangle within u_calc_cargos
boolean visible = false
integer linethickness = 4
long fillcolor = 16777215
integer x = 1362
integer y = 2068
integer width = 229
integer height = 200
end type

type cb_1 from commandbutton within u_calc_cargos
integer x = 3959
integer y = 444
integer width = 567
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Outstanding Frt/Dem/TC"
end type

event clicked;s_list lstr_parametre

lstr_parametre.list_window = "dw_charterer_list"
lstr_parametre.edit_window = "w_outstanding_frtdem"
SetNull(lstr_parametre.edit_datawindow)
lstr_parametre.column[0] = "chart_nr"
lstr_parametre.column[1] = "chart_sn"
lstr_parametre.column[2] = "chart_n_1"
lstr_parametre.column_name[1] = "short name"
lstr_parametre.column_name[2] = "full name"
lstr_parametre.window_title = "Charterers"
//w_list w_mylist

OpenSheetWithParm(w_outstanding_frtdem, lstr_parametre, w_tramos_main, 7, Original!)

end event

