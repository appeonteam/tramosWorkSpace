$PBExportHeader$u_atobviac_calc_cargos.sru
$PBExportComments$cargo's subobject - used by u_calculation
forward
global type u_atobviac_calc_cargos from u_atobviac_calc_base_sqlca
end type
type dw_voyage_alert from u_popupdw within u_atobviac_calc_cargos
end type
type dw_addbuncons from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type st_1 from statictext within u_atobviac_calc_cargos
end type
type dw_calc_misc_claim from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type dw_calc_port_expenses from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type dw_calc_hea_dev_claim from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type dw_loadports from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type dw_dischports from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type dw_calc_lumpsum from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type gb_1 from mt_u_groupbox within u_atobviac_calc_cargos
end type
type r_1 from rectangle within u_atobviac_calc_cargos
end type
type st_2 from statictext within u_atobviac_calc_cargos
end type
type dw_cargo_summary from u_datawindow_sqlca within u_atobviac_calc_cargos
end type
type cb_1 from commandbutton within u_atobviac_calc_cargos
end type
end forward

global type u_atobviac_calc_cargos from u_atobviac_calc_base_sqlca
integer width = 4613
integer height = 2436
long backcolor = 32304364
event ue_recalc_exp pbm_custom68
event ue_check_cqd pbm_custom65
dw_voyage_alert dw_voyage_alert
dw_addbuncons dw_addbuncons
st_1 st_1
dw_calc_misc_claim dw_calc_misc_claim
dw_calc_port_expenses dw_calc_port_expenses
dw_calc_hea_dev_claim dw_calc_hea_dev_claim
dw_loadports dw_loadports
dw_dischports dw_dischports
dw_calc_lumpsum dw_calc_lumpsum
gb_1 gb_1
r_1 r_1
st_2 st_2
dw_cargo_summary dw_cargo_summary
cb_1 cb_1
end type
global u_atobviac_calc_cargos u_atobviac_calc_cargos

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
boolean ib_deletelaytime, ib_expenses_interim_warning

// TODO - remove comments
//private long _il_opestcalcid, _il_opvesselnr
//private string	_is_opvoyagenr
n_messagebox inv_msgbox

n_checkdata inv_opdata

n_service_manager inv_serviceMgr
n_dw_style_service   inv_style

n_datagrid inv_grid_loadports
n_datagrid inv_grid_dischports

mt_n_dddw_searchasyoutype inv_dddw_search
mt_n_datastore ids_original_est_caio	//Data for CAL_CAIO_ID matchup between calculated and estimated calculations
mt_n_datastore ids_check_laytime

constant string is_IDEL = "idel"
constant string is_BUNKERING = "bunkering"
constant string is_VARIOUS = "various"

constant string COLUMN_DESPATCH_LOCAL_CURR = "cal_caio_despatch_local_curr"
constant string COLUMN_DEMURRAGE_LOCAL_CURR = "cal_caio_demurrage_local_curr"
constant string COLUMN_DESPATCH_DEM_CURR = "cal_caio_despatch_dem_curr"
constant string COLUMN_DEMURRAGE_DEM_CURR = "cal_caio_demurrage_dem_curr"
constant string COLUMN_DESPATCH_USD = "cal_caio_despatch"
constant string COLUMN_DEMURRAGE_USD = "cal_caio_demurrage"
constant string COLUMN_DEM_EXRATE_USD  = "cal_carg_cal_carg_dem_exrate_usd"
constant string COLUMN_DEM_CURR_CODE = "cal_carg_cal_carg_dem_curr_code"
constant string COLUMN_DEM_EXRATE_DATE = "cal_carg_cal_carg_dem_exrate_date"
constant string COLUMN_LOCAL_CURR_CODE = "cal_carg_cal_carg_curr_code"
constant string COLUMN_LOCAL_EXRATE_USD = "cal_carg_cal_carg_exrate_usd"
constant string COLUMN_LOCAL_EXRATE_DATE = "cal_carg_cal_carg_exrate_date"
constant string CLAIM_TYPE_FREIGHT = "FRT"
constant string CLAIM_TYPE_DEMURRAGE = "DEM"
constant string COLUMN_FIXED_EXRATE_ENABLED = "cal_carg_fixed_exrate_enabled"
constant string MESSAGE_DEMURRAGE_ASSOCIATED = "You cannot change the demurrage currency because there is a demurrage claim associated."
constant string MESSAGE_FREIGHT_ASSOCIATED = "You cannot change the freight currency because there is a freight claim associated."
constant string COLUMN_SET_EX_RATE = "cal_carg_cal_carg_set_ex_rate"
constant string MESSAGE_EXRATE_FREIGHT_ASSOCIATED = "You cannot change the Set Ex Rate option, because there is a freight claim associated."
constant string MESSAGE_EXRATE_DEMURRAGE_ASSOCIATED = "You cannot change the Set Ex Rate option, because there is a demurrage claim associated."
constant long   CLAIMS_NON_USD = 1
constant long   CLAIMS_ANY_CURRENCY = 2
constant string MESSAGE_NONUSD_DEMURRAGE_ASSOCIATED = "You cannot change the freight currency because there is a non-USD demurrage claim associated."
constant long   FREIGHT_TYPE_WS = 4
constant string COLUMN_FREIGHT_TYPE = "cal_carg_freight_type"
constant string MESSAGE_WS_FREIGHT_ASSOCIATED = "You can only change the freight rate to WS, when the Freight currency is USD or there are no Freight claims associated."
constant string MESSAGE_WS_DEMURRAGE_ASSOCIATED = "You can only change the freight rate to WS, when the Demurrage currency is USD or there are no Demurrage claims associated."
constant string MESSAGE_CP_LAYTIME = 'The total C/P Laytime entries have changed after selecting an interim port. Verify the total C/P Laytime, and adjust if necessary.'

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
public subroutine uf_activate ()
public function string uf_loaddisch_itemchanged (ref u_datawindow_sqlca adw_datawindow, ref u_dddw_search luo_dddw_search)
public function boolean uf_update (integer ai_cargo_no)
public subroutine uf_get_firstlast_port (ref string as_firstport, ref string as_lastport)
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
private subroutine uf_set_caio_id (ref u_datawindow_sqlca adw_datawindow, long al_carg_id)
public function boolean uf_save (long al_calc_id, boolean ab_resetflags, long al_estimated_calc_id)
public function boolean uf_get_cargo_locked ()
public subroutine uf_misc_claims (long al_cargo_id)
public subroutine uf_heat_dev (long al_cargo_id, s_calculation_parm astr_calculation_parm, long al_cargo_no)
public function integer uf_get_revers_freight (integer ai_cargo_no)
public function long uf_get_cerp_id (integer ai_cargo_no)
public function integer uf_get_reversible (long al_cargo_no)
public subroutine uf_reversible (integer ai_function_code, ref u_datawindow_sqlca adw_datawindow, integer as_set_field, integer ai_raty_id, double ad_despatch, double ad_demurrage, integer ai_terms)
public function integer uf_get_first_loadport ()
public function string uf_get_lport_name_purpose (s_port_parm astr_port_parm)
public function string uf_get_dport_name_purpose (s_port_parm astr_port_parm)
public subroutine uf_set_no_ports (integer ai_cargo_no, integer ai_no_loadports, integer ai_no_dischports, boolean ab_clear_itinerary)
private subroutine uf_check_cqd (ref u_datawindow_sqlca adw_datawindow)
private function boolean uf_check_load (ref s_calculation_cargo_inout astr_inouts[], ref string as_errortext)
private function boolean uf_delete_misc_exp (long al_caio_id)
public subroutine uf_get_caio_ids (ref double d_list[])
public function integer uf_get_no_dischports (integer ai_cargo_no)
public function integer uf_get_no_loadports (integer ai_cargo_no)
public function boolean uf_process_cargos (ref s_calculation_parm astr_parm, ref u_datawindow_sqlca adw_ports, ref s_calculation_cargo_inout astr_inouts[], ref double ad_expenses, integer ai_cargo_no, integer ai_pcnr)
public function integer uf_accepttext ()
public function integer uf_select_cargo (integer ai_cargo_row)
private subroutine uf_change_sql (integer ai_function_code, ref u_datawindow_sqlca adw_datawindow, ref string as_sql)
public function integer uf_delete_cargo (long al_cargono)
public function integer uf_deactivate ()
private subroutine uf_description_changed ()
public function integer uf_get_cargo ()
public function string uf_get_loadport_name (ref s_port_parm astr_port_parm)
public subroutine of_open_worldscale (u_datawindow_sqlca dwo_load, u_datawindow_sqlca dwo_disch, integer ai_year)
public function boolean uf_process (ref s_calculation_parm astr_parm)
public subroutine uf_update_speed (boolean ab_isvesselchanged)
public subroutine uf_retrieve (long al_calcid, ref u_datawindow_sqlca adw_summary)
private subroutine documentation ()
public subroutine _updatedemusd (decimal ad_exrate)
public function boolean _validatecolumn (string as_columnname, string as_columns[])
private function integer _getsettledclaimcounts (ref integer ai_settledfreight, ref integer ai_settledother)
public function integer of_getdatawindowfocus (ref u_datawindow_sqlca adw, ref string as_name)
public subroutine of_deleteport (u_datawindow_sqlca adw_port)
public subroutine of_deletelumpsum (u_datawindow_sqlca adw)
public subroutine of_insertlumpsum (u_datawindow_sqlca adw)
public subroutine of_insertport (ref u_datawindow_sqlca adw)
public subroutine of_getconsdropdown ()
public function integer of_preselect_contype (integer al_row, string as_purposecode, u_datawindow_sqlca adw, string as_column)
public function integer of_check_constype (string as_msg_title, string as_columnname, u_datawindow_sqlca adw_datawindow)
public function integer of_return_activestatus (string as_columnname, string as_messagecontent, datawindow adw_parent, string as_data)
public function integer of_getconsactive (long al_cons_id, string as_column)
public function integer of_validatecargosummary (u_datawindow_sqlca adw_summ, dwobject adwo, long al_row, string as_data)
public function integer uf_refresh_demurrage_currency (string as_local_curr)
public function integer uf_clearfixedexrate ()
public subroutine of_insertaddbuncons ()
public function integer of_checkaddbuncons ()
private function integer _checkclaimexists (string as_claim_type, integer al_option)
public function integer of_get_voyage_alert_status (string as_port_code)
public subroutine of_show_voyage_alert (string as_port_code, integer ai_xpos, integer ai_ypos)
public subroutine of_set_cargo_alert_status ()
public function boolean of_check_intrimport_laytime ()
public subroutine of_delete_interimport_laytime (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn)
public function boolean of_isallowed_interim (datawindow adw_cargo, readonly long al_row, string as_data, string as_purpose_code)
public function integer of_check_interimport_change (datawindow ad_datawindow, long al_row, string as_data)
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
03/05/16       CR2428   SSX014  Clear the fixed exchange rate flag  
************************************************************************************/

Long ll_rows, ll_count

// Loop through all cargo summary and mark them as new
ll_rows = dw_cargo_summary.RowCount()
For ll_count = 1 To ll_rows
	dw_cargo_summary.SetItemStatus(ll_count, 0, Primary!, NewModified!)
Next

uf_clearfixedexrate()

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

ll_rows = dw_calc_lumpsum.RowCount()
For ll_count = 1 To ll_rows
	dw_calc_lumpsum.SetItemStatus(ll_count, 0, Primary!, NewModified!)
Next	

ll_rows = dw_addbuncons.rowcount()
for ll_count = 1 To ll_rows
	dw_addbuncons.setitemstatus(ll_count, 0, Primary!, NewModified!)
next	
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
DATE      VERSION     NAME     DESCRIPTION
--------  -------     ------   ------------------------------------
14/01/16  CR3248      LHG008	 ECA zone implementation
************************************************************************************/

// Turn redraw off and do accepttext
uf_redraw_off()

dw_loadports.Accepttext()
dw_dischports.Accepttext()
dw_calc_lumpsum.Accepttext()

// Set ai_cargo_no to current cargo if it's zero
If ai_cargo_no = 0 Then ai_cargo_no = dw_cargo_summary.GetRow()

// Update the summary window with the C/P ID, and call uf_update to
// update the cargo with reversible and commission information
dw_cargo_summary.SetItem(ai_cargo_no,"cal_carg_cal_cerp_id",al_cerp_id)
uf_update(ai_cargo_no)

iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.of_datasync("in")

// Tell the calculation system that something important has changed
Parent.PostEvent("ue_childmodified")

// Move current control away from Reversible-checkbox, if this is the 
// current, since protect doesn't work on current column
If dw_cargo_summary.GetColumnName()="cal_carg_cal_carg_reversible" Then &
	dw_cargo_summary.SetColumn("cal_carg_status")  

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
dw_calc_lumpsum.uf_redraw_off()
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
dw_calc_lumpsum.uf_redraw_on()
end subroutine

public subroutine uf_activate ();// Set focus to this and call ancestor

dw_cargo_summary.SetFocus()
Super::uf_activate()

of_getconsdropdown()
of_set_cargo_alert_status( )
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
4-8-96					MI			Initial version  
10-09-13		CR3154	WWA048	Demurrage rate should be changed when purpose is changed to Load or Discharge
20/04/16    CR2428   SSX014   Update demurrage/despatch rate in USD and local currency
28/06/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO).
22/08/17		CR4221	HHX010	Interim Port
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
		uf_port_changed()
	CASE "purpose_code"
		// The purposecode has been changed. Depending on the new status, and the
		// reversible status, we might need to copy information to some of the
		// fields, eg. If the user selected load, and the cargo is reversible, we
		// have to copy the despatch, demurrage etc. fields
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
			adw_datawindow.SetItem(ll_row,COLUMN_DEMURRAGE_LOCAL_CURR,0)
			adw_datawindow.SetItem(ll_row,COLUMN_DESPATCH_LOCAL_CURR,0)
			adw_datawindow.SetItem(ll_row,COLUMN_DEMURRAGE_DEM_CURR,0)
			adw_datawindow.SetItem(ll_row,COLUMN_DESPATCH_DEM_CURR,0)
			adw_datawindow.SetItem(ll_row,"cal_caio_noticetime",0)
			adw_datawindow.SetItem(ll_row,"cal_caio_load_terms",0)
			adw_datawindow.SetItem(ll_row,"cal_raty_id",1)
		End if
		
		adw_datawindow.setitem(ll_row, "cal_caio_rate_estimated", 0)
		adw_datawindow.setitem(ll_row, "cal_caio_rate_calculated", 0)
		
		// Finally tell the rest of the calculation system, that one of the ports purpose have
		// been changed.
		uf_port_changed()
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
		CASE COLUMN_DESPATCH_DEM_CURR
			li_set_field = 4
		CASE "purpose_code", COLUMN_DEMURRAGE_DEM_CURR
			li_set_field = 5			
		CASE "cal_caio_load_terms"
			li_set_field = 6
		CASE "cal_caio_rate_calculated"
			li_set_field = 7
		CASE  'cal_caio_interim_port'	
			li_set_field = 8
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

		If (li_set_field = 2) or (li_set_field=6) Then
			ll_value = Integer(adw_datawindow.GetText())
		elseif li_set_field = 8 then 
		Else
			if ls_column <> "purpose_code" then
				ld_value = Double(adw_datawindow.GetText())
			else
				ld_value = adw_datawindow.GetItemNumber(ll_row, COLUMN_DEMURRAGE_DEM_CURR)
			end if
		end if

		// Call uf_reversible for this datawindow.
		uf_reversible(1, adw_datawindow,  li_set_field, ll_value, ld_value, ld_value, ll_value)
		
		// If the field is despatch or demurrage, we also want to copy it to the
		// dischports (even though the user changed a load field).
		If li_set_field = 4 Or li_set_field = 5 Then
			uf_reversible(1, dw_dischports, li_set_field, ll_value, ld_value, ld_value, ll_value)
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
DATE        VERSION  NAME     DESCRIPTION
--------    -------  ------   -------------------------------------
29/06/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO).  
************************************************************************************/

Long ll_cerp_id
Integer li_cp, li_frt, li_count, li_chart_nr, li_loadport
Double ld_adr_comm, ld_tmp_comm, ld_cargo_temp_comm, ld_cargo_adr_comm
Boolean lb_changed
String ls_description, ls_charterer,ls_message_string
Integer li_current_cargo
Long ll_freight_type, ll_adr_com_lump, ll_count
Double ld_ws_rate, ld_lumpsum, ld_freight_rate, ld_flat_rate, ld_min_1, ld_min_2, ld_over_1, ld_over_2, ld_add_lumpsum, ld_bunker_escalation
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
	uf_reversible(li_cp, dw_loadports, 0, ll_null, ld_null, ld_null, ll_null)

	// Copy despatch and demurrage from first loadport to all dischports.
	li_loadport = uf_get_first_loadport()
	If li_loadport  <> 0 Then
		dw_dischports.SetItem(1, "cal_caio_despatch", dw_loadports.GetItemNumber(li_loadport, "cal_caio_despatch"))
		dw_dischports.SetItem(1, "cal_caio_demurrage", dw_loadports.GetItemNumber(li_loadport, "cal_caio_demurrage"))
		uf_reversible(li_cp, dw_dischports, 0, ll_null, ld_null, ld_null, ll_null)
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
		ld_bunker_escalation = dw_cargo_summary.GetItemNumber(ai_cargo_no, "bunker_escalation")	
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
			dw_cargo_summary.SetItem(ll_count, "bunker_escalation", ld_bunker_escalation) 	
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
		of_insertport(dw_loadports)
		of_insertport(dw_dischports)

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
 
*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
08/12/16    CR4050   LHG008   Change additionals Laden and Ballasted logic
09/02/17    CR4050   LHG008   Fix a system Error(occurred when create calculation with 2 cargos and then delete the first cargo)
************************************************************************************/

decimal ld_ballast_pcnt, ld_laden_pcnt

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
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_add_lsfo",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_temp_comission",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_adr_commision",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_min_1",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_min_2",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_overage_1",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_overage_2",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_local_flatrate",0)
dw_cargo_summary.SetItem(ii_no_cargos,"cal_carg_cal_carg_misc_income",0)

if ii_no_cargos > 1 then
	ld_ballast_pcnt = dw_cargo_summary.getitemnumber(1, "cal_carg_cal_carg_add_days_ballast_pcnt")
	ld_laden_pcnt = dw_cargo_summary.getitemnumber(1, "cal_carg_add_days_laden_pcnt")
end if
dw_cargo_summary.SetItem(ii_no_cargos, "cal_carg_cal_carg_add_days_ballast_pcnt", ld_ballast_pcnt)
dw_cargo_summary.SetItem(ii_no_cargos, "cal_carg_add_days_laden_pcnt", ld_laden_pcnt)

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
	of_insertport( dw_loadports)
	of_insertport( dw_dischports)
End if

of_insertaddbuncons()

// and trigger the ue_childmodified event to tell the rest of the system that the
// calculation has changed.
Parent.TriggerEvent("ue_childmodified")

iuo_calc_nvo.iuo_calc_itinerary.of_datasync("in")

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
DATE     VERSION     NAME       DESCRIPTION
-------- -------     ------     ------------------------------------
28/01/16	CR3248      LHG008     Fix bug for multi-cargos
************************************************************************************/

// Variabel decleration

Integer li_cargo_rows, li_cargo_count, li_count, li_max
Long ll_tmp
String ls_filter

// Do not process ballast voyages, since they don't have any cargo in/outs
If ib_ballastvoyage then return 

// Loop through all cargos, and update the load/dischport ID's to
// with the original ID's
li_cargo_rows = dw_cargo_summary.RowCount()
For li_cargo_count = 1 To li_cargo_rows
	
	li_max = UpperBound(il_new_cargo_id)

	// Set filter on current cargo value
	If li_cargo_count <= li_max Then
		ls_filter = "cal_carg_id = " + String(il_new_cargo_id[li_cargo_count]);

		dw_loadports.SetFilter(ls_filter)
		dw_loadports.Filter()
		dw_dischports.SetFilter(ls_filter)	
		dw_dischports.Filter()
		dw_calc_lumpsum.SetFilter(ls_filter)	
		dw_calc_lumpsum.Filter()
		dw_addbuncons.SetFilter(ls_filter)	
		dw_addbuncons.Filter()
		
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
		
		li_max = dw_addbuncons.rowcount()
		for li_count = 1 To li_max
			dw_addbuncons.setItem(li_count, "cal_carg_id", il_original_ports_id[li_cargo_count])
		next
		
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


/* setup datawindow formatter service */
inv_style.of_dwlistformater(dw_calc_lumpsum,false)
inv_style.of_dwlistformater(dw_loadports,false)
inv_style.of_dwlistformater(dw_dischports,false)
inv_style.of_dwformformater(dw_cargo_summary)




end subroutine

private subroutine uf_set_caio_id (ref u_datawindow_sqlca adw_datawindow, long al_carg_id);/************************************************************************************

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
DATE		   CR-Ref 	 NAME	    DESCRIPTION
-------- 	------    ----- 	 -------------------------------------
06/05/2014	CR3635    LHG008   Itinerary ID issue
22/08/2017	CR4221		HHX010		Check laytime when interim port is changed	
************************************************************************************/

Integer li_deleted, li_cargo_count, li_max, li_tmp, li_del_order, li_settled
Long ll_cargo_rows,  ll_carg_id, ll_del_carg_id, ll_tmp, ll_count, ll_row
Boolean lb_result, lb_fixexrate
Long ll_clear[]
n_claimcurrencyadjust lnv_claimcurrencyadjust
long ll_vessel_nr
string ls_voyage_nr, ls_port_code
int li_pcn

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
	
	ids_original_est_caio.retrieve(al_calc_id, al_estimated_calc_id)
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
			
			if sqlca.sqlcode = 0 then
				DELETE 
				FROM CAL_ADDBUNCONS
				WHERE CAL_CARG_ID = :ll_del_carg_id;
			end if
			if al_estimated_calc_id > 0 and sqlca.sqlcode = 0 then
				DELETE 
				FROM CAL_ADDBUNCONS
				WHERE CAL_CARG_ID = :istr_calc_to_est[li_tmp].l_estimated;
			end if
			
			If SQLCA.SQLCode<>0 Then
				MessageBox("System error", "Error deleting cargo childs code "+String(SQLCA.SQLCode)+" "+SQLCA.SQLErrText)
				Return(False)
			End if
			
			//addbuncons has now been deleted manually from the database. Tell
			// Powerbuilder that it shouldn't try to delete the rows
			for ll_row = dw_addbuncons.deletedcount( ) to 1	step -1
				if ll_del_carg_id = dw_addbuncons.getitemnumber(ll_row, "cal_carg_id", Delete!, true) then 
					dw_addbuncons.rowsdiscard(ll_row, ll_row, Delete!)
				end if
			next
						
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
		uf_set_caio_id(dw_addbuncons, ll_carg_id)
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
		lb_result = dw_addbuncons.update(true, ab_resetflags) = 1
	End if
End if

if lb_result then
	lb_result = of_check_intrimport_laytime()
	if  lb_result  then
		for ll_row = 1 to  ids_check_laytime.rowcount()
			ll_vessel_nr = ids_check_laytime.object.vessel_nr[ll_row]
			ls_voyage_nr = ids_check_laytime.object.voyage_nr[ll_row]
			ls_port_code = ids_check_laytime.object.port_code[ll_row]
			li_pcn = 	ids_check_laytime.object.pcn[ll_row]
			
			of_delete_interimport_laytime(ll_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
		next
	end if
end if

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
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].pool_manager_commission = dw_calc_misc_claim.GetItemNumber(li_tmp,"pool_manager_commission")
		istr_hea_dev_misc_parm.array_misc_claims[li_tmp].broker_commission = dw_calc_misc_claim.GetItemNumber(li_tmp,"broker_commission")
		
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
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].pool_manager_commission = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"pool_manager_commission")
		istr_hea_dev_misc_parm.array_heat_dev[li_tmp].broker_commission = dw_calc_hea_dev_claim.GetItemNumber(li_tmp,"broker_commission")
	
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
istr_hea_dev_misc_parm.d_broker_comm_pct_pool = & 
				astr_calculation_parm.cargolist[al_cargo_no].d_commission_percent_pool

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

public subroutine uf_reversible (integer ai_function_code, ref u_datawindow_sqlca adw_datawindow, integer as_set_field, integer ai_raty_id, double ad_despatch, double ad_demurrage, integer ai_terms);/************************************************************************************

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
		For each field (terms etc): If value is given as parameter
		the this value is copied to all reversible ports, otherwise the value is taken
		from the current row in adw_datawindow. 
		

 Arguments : ai_function_code: 0: Clear values, 1: Set values
			adw_datawindow = datawindow to be processed
			as_set_field: 0 : Set all, 1: locked, 2: set raty, 3: set estimated, 
								4: set despatch, 5: set demurrage
			raty_id value as Integer or NULL to copy first found value
			despatch value as Double or NULL to copy first found value, despatch value is in demurrage currency
			Demurrage value as Double or NULL to copy first found value, demurrage value is in demurrage currency

 Returns   : None

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
20/04/16    CR2428   SSX014   Update demurrage/despatch rate in USD and local currency
28/06/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO).
22/08/17    CR4221	HHX010  Interim Port
************************************************************************************/

// uf_reversible
// Function code: 1: Set, 0: Clear, -1: update
// as_set_field: 0 : Set all, 1: locked, 2: set raty, 3: set estimated, 4: set despatch, 5: set demurrage, 6: terms , 8: Interim Port

Long ll_rowcount, ll_count, ll_cerp_id, ll_cargo_row, ll_dw_row
Integer li_dw_count, li_current_dw, li_count
String ls_tmp
decimal ld_despatch_usd, ld_demurrage_usd, ld_despatch_local, ld_demurrage_local
decimal ld_null

SetNull(ld_null)

// Check if there is anything to do, otherwise exit
If adw_datawindow.Rowcount()=0 Then Return

// Turn redraw of
uf_redraw_off()

ll_dw_row = adw_datawindow.getrow()

If ai_function_code=0 Then
	// Function code was 0, which means that all values should be set to default
	SELECT MIN(CAL_RATY_ID)
	INTO :ai_raty_id
	FROM CAL_RATY;
	
	ad_despatch = 0
	ad_demurrage = 0
	ai_terms = 0
Else
	// Function case was 1, which means that we want to set a value. Find first port
	// (either load or disch, depending on adw_datawindow), that will be used as value
	// if the set_field value is null
	If adw_datawindow = dw_loadports Then
		li_count = uf_get_first_loadport()
		if li_count = 0 then
			uf_redraw_on()
			return
		end if
		ai_raty_id = adw_datawindow.GetItemNumber(li_count,"cal_raty_id")
		ad_despatch = adw_datawindow.GetItemNumber(li_count, COLUMN_DESPATCH_DEM_CURR) 
		ad_demurrage = adw_datawindow.GetItemNumber(li_count, COLUMN_DEMURRAGE_DEM_CURR) 
		ai_terms = adw_datawindow.GetItemNumber(li_count, "cal_caio_load_terms")
	Else
		li_count = uf_get_first_loadport()
		if li_count > 0 then
			ad_despatch = dw_loadports.GetItemNumber(li_count, COLUMN_DESPATCH_DEM_CURR) 
			ad_demurrage = dw_loadports.GetItemNumber(li_count, COLUMN_DEMURRAGE_DEM_CURR) 
		end if
		ai_raty_id = adw_datawindow.GetItemNumber(ll_dw_row, "cal_raty_id")
		ai_terms = adw_datawindow.GetItemNumber(ll_dw_row, "cal_caio_load_terms")
	End if
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

			If (ls_tmp = "L" or ls_tmp = "D")  Then
				If (as_set_field=0) or (as_set_field=2) Then adw_datawindow.SetItem(ll_count, "cal_raty_id", ai_raty_id)
				
				If ((as_set_field=0 or as_set_field=4 or ( as_set_field = 8 and ll_count <> ll_dw_row)) and adw_datawindow.object.cal_caio_interim_port[ll_count] = 0)  &
					  or ( as_set_field = 8 and ll_count = ll_dw_row and adw_datawindow.gettext() = '0') Then
					ld_despatch_usd = ad_despatch * dw_cargo_summary.getitemdecimal(ii_current_cargo,COLUMN_DEM_EXRATE_USD) / 100.0
					adw_datawindow.SetItem(ll_count, COLUMN_DESPATCH_USD, ld_despatch_usd)
					adw_datawindow.SetItem(ll_count, COLUMN_DESPATCH_DEM_CURR, ad_despatch)
					if dw_cargo_summary.getitemstring(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
						dw_cargo_summary.getitemstring(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
						adw_datawindow.SetItem(ll_count, COLUMN_DESPATCH_LOCAL_CURR, ad_despatch)
					else
						if dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD) <> 0 then
							ld_despatch_local = (ad_despatch * dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_DEM_EXRATE_USD)) / &
								dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
							adw_datawindow.SetItem(ll_count, COLUMN_DESPATCH_LOCAL_CURR, ld_despatch_local)
						else
							adw_datawindow.SetItem(ll_count, COLUMN_DESPATCH_LOCAL_CURR, ld_null)
						end if
					end if
				end if
					
				If ((as_set_field=0 or as_set_field=5 or ( as_set_field = 8 and ll_count <> ll_dw_row)) and adw_datawindow.object.cal_caio_interim_port[ll_count] = 0)  &
					  or ( as_set_field = 8 and ll_count = ll_dw_row and adw_datawindow.gettext() = '0') Then
					ld_demurrage_usd = ad_demurrage * dw_cargo_summary.getitemdecimal(ii_current_cargo,COLUMN_DEM_EXRATE_USD) / 100.0
					adw_datawindow.SetItem(ll_count, COLUMN_DEMURRAGE_USD, ld_demurrage_usd)
					adw_datawindow.SetItem(ll_count, COLUMN_DEMURRAGE_DEM_CURR, ad_demurrage)
					if dw_cargo_summary.getitemstring(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
						dw_cargo_summary.getitemstring(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
						adw_datawindow.SetItem(ll_count, COLUMN_DEMURRAGE_LOCAL_CURR, ad_demurrage)
					else
						if dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD) <> 0 then
							ld_demurrage_local = (ad_demurrage * dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_DEM_EXRATE_USD)) / &
								dw_cargo_summary.getitemdecimal(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
							adw_datawindow.SetItem(ll_count, COLUMN_DEMURRAGE_LOCAL_CURR, ld_demurrage_local)
						else
							adw_datawindow.SetItem(ll_count, COLUMN_DEMURRAGE_LOCAL_CURR, ld_null)
						end if
					end if
				end if
				
				If (as_set_field=0) or (as_set_field=6) Then adw_datawindow.SetItem(ll_count, "cal_caio_load_terms", ai_terms)	
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
30-08-17    CR4221	HHX010  Interim Port
************************************************************************************/

Integer li_count, li_max

li_count = 1

// Find first loadport row
li_max = dw_loadports.RowCount()

Do While li_count <= li_max
	If dw_loadports.GetItemString(li_count, "purpose_code") = "L" and dw_loadports.object.cal_caio_interim_port[li_count] = 0 Then Return li_count
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

private subroutine uf_check_cqd (ref u_datawindow_sqlca adw_datawindow);/************************************************************************************

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
	adw_datawindow.SetItem(ll_row, COLUMN_DESPATCH_LOCAL_CURR, 0)
	adw_datawindow.SetItem(ll_row, COLUMN_DEMURRAGE_LOCAL_CURR, 0)
	adw_datawindow.SetItem(ll_row, COLUMN_DESPATCH_DEM_CURR, 0)
	adw_datawindow.SetItem(ll_row, COLUMN_DEMURRAGE_DEM_CURR, 0)
	adw_datawindow.SetItem(ll_row, COLUMN_DESPATCH_USD, 0)
	adw_datawindow.SetItem(ll_row, COLUMN_DEMURRAGE_USD, 0)
end if

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

public function boolean uf_process_cargos (ref s_calculation_parm astr_parm, ref u_datawindow_sqlca adw_ports, ref s_calculation_cargo_inout astr_inouts[], ref double ad_expenses, integer ai_cargo_no, integer ai_pcnr);/************************************************************************************

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
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
11-3-97		4.04			MI		Added CQD check  
12-03-13		CR2658	WWG004	Remove At EU Port and add at port consumption.
26/07/13		CR2476	LHG008	"Do Fixture" validation to accept Demurrage = 0
28/06/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
22/08/17		CR4221	HHX010	Interim Port
20/11/17		CR4221	HHX010	Change message text
************************************************************************************/
// Variable declaration

Boolean	lb_result
Long		ll_count, ll_rows, ll_normal_loadports_count
Integer	li_inout_count, li_mtdh, li_contypeid
String	ls_port, ls_text
double	ld_tmp, ld_unit_expens, ld_expenses_interim


lb_result = false

// Append to current inout array
li_inout_count = UpperBound(astr_inouts) + 1  

// Loop through all in or outports, depending on datawindow, and validate/calculate
// whatever's needed:

ll_rows = adw_ports.RowCount()

for ll_count = 1 to ll_rows 
	if ((adw_ports.GetItemString(ll_count, "purpose_code") = "L" and adw_ports = dw_loadports) or (adw_ports.GetItemString(ll_count, "purpose_code") = "D" and adw_ports = dw_dischports)) and adw_ports.GetItemnumber(ll_count, "cal_caio_interim_port") = 0 then 
		ll_normal_loadports_count = 1 
		exit
	end if	
next
if ll_normal_loadports_count = 0 then
	astr_parm.result.s_errortext = "You have only used interim port(s) in this calculation. Create at least one L and/or D port that are not interim ports to continue."
	adw_ports.SetColumn("purpose_code")
	Goto Stop
end if

	 
For ll_count = 1 To ll_rows
	// Check that there are no loadports with 0 in # of units
	if adw_ports = dw_loadports then
		if adw_ports.GetItemNumber(ll_count, "cal_caio_number_of_units") = 0 and &
			adw_ports.GetItemString(ll_count, "purpose_code") = "L" then
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
	
	//Validate contype
	li_contypeid = adw_ports.getitemnumber(ll_count, "port_cons_id")
	if isnull(string(li_contypeid)) or string(li_contypeid) = '' then
		astr_parm.result.s_errortext = "Contype must be selected"
		lb_result = false
	end if
	// If we were just checking for save, then continue now
	// ********************************************************************
	// ALL CODE THAT IS TO BE PROCESSED FOR SAVING, MUST BE ABOVE THIS LINE
	// ********************************************************************
	If astr_parm.i_function_code=1 Then Continue 

	// Check if portcode is dummy (""), which isn't allowed for calculation
	ls_Port = Trim(adw_ports.GetItemString(ll_count, "port_code"))
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
	astr_inouts[li_inout_count].d_calculated	= adw_ports.GetItemNumber(ll_count, "cal_caio_rate_calculated")
	astr_inouts[li_inout_count].d_despatch		= adw_ports.GetItemNumber(ll_count, "cal_caio_despatch_dem_curr") * dw_cargo_summary.getitemdecimal(ii_current_cargo, "cal_carg_cal_carg_dem_exrate_usd") / 100
	astr_inouts[li_inout_count].d_demurrage	= adw_ports.GetItemNumber(ll_count, "cal_caio_demurrage_dem_curr") * dw_cargo_summary.getitemdecimal(ii_current_cargo, "cal_carg_cal_carg_dem_exrate_usd") / 100

	// Add expenses found in the load or discharge port
	ad_expenses += adw_ports.GetItemnumber(ll_count, "cal_caio_expenses")
	if adw_ports.object.cal_caio_interim_port[ll_count] = 1 then
		ld_expenses_interim += adw_ports.GetItemnumber(ll_count, "cal_caio_expenses")
	end if

	ld_unit_expens = adw_ports.GetItemNumber(ll_count, "cal_caio_load_unit_expenses")
	ld_tmp = ld_unit_expens * Abs(adw_ports.GetItemNumber(ll_count, "cal_caio_number_of_units"))
	ld_tmp = ld_tmp + adw_ports.GetItemNumber(ll_count, "cal_caio_misc_expenses")

	astr_parm.cargolist[ai_cargo_no].d_add_expenses += ld_tmp

	astr_parm.result.d_port_expenses 					+=	adw_ports.GetItemnumber(ll_count, "cal_caio_expenses")
	astr_inouts[li_inout_count].l_terms_id 			=	adw_ports.GetItemNumber(ll_count, "cal_raty_id")
	astr_inouts[li_inout_count].l_type 					=	adw_ports.GetItemNumber(ll_count, "cal_caio_load_terms")
	astr_inouts[li_inout_count].i_itinerary_number 	=	adw_ports.GetItemNumber(ll_count, "cal_caio_itinerary_number")
	astr_inouts[li_inout_count].s_port 					=	adw_ports.GetItemString(ll_count, "port_code")
	astr_inouts[li_inout_count].s_purpose 				=	adw_ports.GetItemString(ll_count, "purpose_code")
	astr_inouts[li_inout_count].l_port_cons_id		= 	adw_ports.getitemnumber(ll_count, "port_cons_id")
	astr_inouts[li_inout_count].l_sailing_cons_id	= 	adw_ports.getitemnumber(ll_count, "sailing_cons_id")
	astr_inouts[li_inout_count].d_notice_time			=	adw_ports.getitemnumber(ll_count, "cal_caio_noticetime")
	astr_inouts[li_inout_count].l_cal_caio_interim_port = adw_ports.getitemnumber(ll_count, "cal_caio_interim_port")
	
	//Notice column has been open up for all purposes
	If adw_ports = dw_loadports then
		if astr_inouts[li_inout_count].s_purpose = "L" then astr_parm.d_noticetime_loadports += astr_inouts[li_inout_count].d_notice_time * 60
		if astr_inouts[li_inout_count].s_purpose = "CHO" then astr_parm.d_noticetime_choports += astr_inouts[li_inout_count].d_notice_time * 60
	Else
		astr_parm.d_noticetime_dischports += astr_inouts[li_inout_count].d_notice_time * 60
	End If
	
	// Get the rate terms out from the CAL_RATY table. Remember that the MDTH field
	// has a wrong name, and is used to store the Rate type.
	SELECT CAL_RATY_MTDH
	INTO :li_mtdh
	FROM CAL_RATY
	WHERE CAL_RATY_ID = :astr_inouts[li_inout_count].l_terms_id;

	// If ratetype is CQD, then reset despatch, demurrage and calculated to 0.
	If li_mtdh = 4 Then 
		astr_inouts[li_inout_count].d_despatch = 0
		astr_inouts[li_inout_count].d_demurrage = 0
		astr_inouts[li_inout_count].d_calculated = 0
	End if 
	
	// If fixturing and (# of units > 0) and (not CQD) then check that a demurrage rate
	// is given-
	If (astr_parm.i_function_code > 2) And (astr_inouts[li_inout_count].d_units <> 0) And (li_mtdh <> 4) Then
		If  (astr_parm.fixturelist[ai_cargo_no])  Then
			If isnull(astr_inouts[li_inout_count].d_demurrage) Then
				astr_parm.result.s_errortext = "Demurrage not given for port " + iuo_calc_nvo.uf_portcode_to_name(ls_port)
				adw_ports.SetColumn(COLUMN_DEMURRAGE_DEM_CURR)
				Goto Stop
			End if		
		End if
	End if

	li_inout_count ++
Next

if ld_expenses_interim > 0 and ib_expenses_interim_warning = true and not isvalid(w_calc_recalc) then 
	ls_text = "Port expenses have been defined for interim ports. Normally all port expenses on interim ports are for Charterers' account.~r~n~r~nDo you want to continue?"
	if messagebox('Warning', ls_text, Exclamation!, YesNo!, 2) = 2 then
		astr_parm.b_silent_calculation = true
		Goto Stop
	end if
	ib_expenses_interim_warning = false 
end if


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
If li_result = 1 Then li_result = dw_calc_lumpsum.Accepttext()
if li_result = 1 then li_result = dw_addbuncons.accepttext( )
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
DATE		   VERSION 	   NAME	      DESCRIPTION
-------- 	------- 		----- 		-------------------------------------
14/02/2014  CR2658UAT   LHG008      Filter ConsType dropdown.
************************************************************************************/

// Variable declaration
String ls_tmp
Integer li_old_cargo, li_count, li_max, li_carg_status, li_calc_status, li_lock_value, li_locked_count, li_total_count, li_calc_lump
Long ll_cargo_id
Integer li_tmp
string ls_null

SetNull(ls_null)

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
		dw_addbuncons.setfilter("")
		dw_addbuncons.filter()
		
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
		dw_addbuncons.setfilter(ls_tmp)
		dw_addbuncons.filter()
		
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
	
		// Tell the rest of the calculation system, that something has changed.
		Parent.PostEvent("ue_cargo_row_changed",ai_cargo_row,0)

		// Reposition window back to normal
	//	dw_cargo_summary.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_loadports.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_dischports.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
		dw_calc_lumpsum.modify("datawindow.verticalscrollposition=1 datawindow.horizontalscrollposition=1")
	End if
	
	//Filter ConsType dropdown.
	dw_loadports.event ue_filterconsdddw(dw_loadports.getrow(), false)
	dw_dischports.event ue_filterconsdddw(dw_dischports.getrow(), false)
	
	//set voyage alert status
	of_set_cargo_alert_status()
	
	uf_redraw_on()
End if

// ENd of job, return old cargo number as result.
If li_old_cargo = 0 Then li_old_cargo = dw_cargo_summary.GetRow()

if ii_current_cargo > 0 then
	uf_refresh_demurrage_currency(ls_null)
end if

Return(li_old_cargo)
end function

private subroutine uf_change_sql (integer ai_function_code, ref u_datawindow_sqlca adw_datawindow, ref string as_sql);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1997

 Description : Changes SQL insert, update and delete statements to update the calculated and
 					estimated calculations on the same time.

 Arguments : ai_function_code: Integer, identifies which datawindow thats about to 
 	be updated:
 	1 = cargo summery, 2 = loadports, 3 = dischports, 4 = dw_misc_expenses,
	5 = dw_calc_hea_dev_claims, 6 = dw_calc_misc_claims 7 = dw_calc_lumpsum
	8 = dw_addbuncons
 										
	adw_datawindow : datawindow that is being updated
	as_sql			: SQL-string containing the update
										 
 Returns   : None

*************************************************************************************
Development Log 
DATE     	CR-Ref 	 NAME	  	 DESCRIPTION
-------- 	------    ------ 	 -------------------------------------
06/05/14 	CR3635    LHG008 	 Itinerary ID issue
12/05/14 	CR3634    LHG008 	 Partial commit issue
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

String ls_sql, ls_tmp, ls_sql_code, ls_cal_description
long ll_max, ll_count, ll_est_lump_id, ll_lump_id, ll_order, ll_rowcount, ll_find
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
		
	Elseif (ai_function_code = 2) Or (ai_function_code =3) or (ai_function_code = 5) or (ai_function_code = 6) or (ai_function_code = 7) or (ai_function_code = 8) Then
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
				ll_max = UpperBound(istr_calc_to_est)
				For ll_count = 1 To ll_max 
					If istr_calc_to_est[ll_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[ll_count].l_estimated
						Exit
					End if
				Next
			
				If ll_est_carg_id <> 0 Then 
					// The estimated ID was found, now change the SQL statement to
					// be where "(CALC_ID) OR (ESTIMATED ID)"
					if ai_function_code = 2 or ai_function_code = 3 then
						ll_rowcount = ids_original_est_caio.rowcount()
						if ll_rowcount > 0 then
							ll_caio_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_CAIO_ID"))
							ll_find = ids_original_est_caio.find("cal_caio_id = " + string(ll_caio_id), 1, ll_rowcount)
							if ll_find > 0 then
								ll_est_caio_id = ids_original_est_caio.getitemnumber(ll_find, 'est_caio_id')
							end if
						end if
						
						if ll_est_caio_id > 0 then
							uo_sql_util.uf_modify_where(ls_sql, "CAL_CAIO_ID", & 
							"(CAL_CAIO_ID = "+String(ll_caio_id)+" OR CAL_CAIO_ID = "+String(ll_est_caio_id)+")")
						end if
					else
						uo_sql_util.uf_modify_where(ls_sql, "CAL_CARG_ID", & 
						"(CAL_CARG_ID = "+String(ll_carg_id)+" OR CAL_CARG_ID = "+String(ll_est_carg_id)+")")	
					end if
					
					ll_lump_id = Long(uo_sql_util.uf_get_where(ls_sql, "CAL_LUMP_ID"))	
					SELECT CAL_LUMP_ORDER
					INTO :ll_order
					FROM CAL_LUMP
					WHERE CAL_LUMP_ID = :ll_lump_id;
					
					SELECT CAL_LUMP_ID
					INTO :ll_est_lump_id
					FROM CAL_LUMP
					WHERE CAL_CARG_ID = :ll_est_carg_id AND CAL_LUMP_ORDER = :ll_order;
					
					if ll_est_lump_id <> 0 then
						uo_sql_util.uf_modify_where(ls_sql, "CAL_LUMP_ID", & 
						"(CAL_LUMP_ID = "+String(ll_lump_id)+" OR CAL_LUMP_ID = "+String(ll_est_lump_id)+")")			
					end if

				Else	
					// Error - ID was not found, this is probably due to a programming (logic)
					// error or error in the database fields. Show list of connected ID's since
					// this might help the developer finding the bug.
					
					ls_tmp = "Unable to generate estimated copy ("+String(ai_function_code)+")~r~n~r~ncarg_id is "+String(ll_carg_id)+"~r~n~r~n"
					For ll_count = 1 To ll_max 
						ls_tmp += "cal: "+String(istr_calc_to_est[ll_count].l_calculated)+" est: "+String(istr_calc_to_est[ll_count].l_estimated)
					Next

					MessageBox("System error", ls_tmp)
				End if

				// Remove the CAL_CAIO_ID, CAL_HEDV_ID or CAL_CLMI_ID depending on which
				// datawindow we're working on
				CHOOSE CASE ai_function_code
					CASE 2,3
						uo_sql_util.uf_remove_where(ls_sql, "CAL_CARG_ID")
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
				ll_max = UpperBound(istr_calc_to_est)
				For ll_count = 1 To ll_max 
					If istr_calc_to_est[ll_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[ll_count].l_estimated
						Exit
					End if
				Next

				If ll_est_carg_id > 0 Then
					// Copy the current SQL statement to ls_tmp, and modify the ls_tmp to 
					// point to the estimated CARG_ID
					
					if ai_function_code = 8 then
						ls_cal_description = trim(uo_sql_util.uf_get_insert(ls_sql, "CAL_DESCRIPTION"))
						if left(ls_cal_description, 1) = "'" or left(ls_cal_description, 1) = '"' then
							ls_cal_description = mid(ls_cal_description, 2, len(ls_cal_description) - 1)
						end if
						if right(ls_cal_description, 1) = "'" or right(ls_cal_description, 1) = '"' then
							ls_cal_description = mid(ls_cal_description, 1, len(ls_cal_description) - 1)
						end if
						
						SELECT COUNT(1) INTO :ll_count
						FROM CAL_ADDBUNCONS
						WHERE CAL_CARG_ID = :ll_est_carg_id
						AND CAL_DESCRIPTION = :ls_cal_description;
					end if
					
					if ai_function_code <> 8 or (ai_function_code = 8 and ll_count = 0) then 
						ls_tmp = ls_sql
						uo_sql_util.uf_modify_insert(ls_tmp, "CAL_CARG_ID", String(ll_est_carg_id))
	
						// Fire the new SQL statement immediately. The original SQL statement will
						// be processed later on without modifications.
						EXECUTE IMMEDIATE :ls_tmp USING SQLCA;
	
						// Handle SQL errors if any
						If SQLCA.SQLCode <> 0 Then MessageBox("System error", "Error during estimated insert ("+String(ai_function_code)+") ~r~n~r~nSQL:" + String(SQLCA.SQLCode)+ " " +SQLCA.SQLErrText)
					end if
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
				ll_max = UpperBound(istr_calc_to_est)
				For ll_count = 1 To ll_max 
					If istr_calc_to_est[ll_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[ll_count].l_estimated

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
				ll_max = UpperBound(istr_calc_to_est)
				For ll_count = 1 To ll_max 
					If istr_calc_to_est[ll_count].l_calculated = ll_carg_id Then
						ll_est_carg_id = istr_calc_to_est[ll_count].l_estimated
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

public function integer uf_delete_cargo (long al_cargono);/************************************************************************************

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
11/02/14	CR2658UAT	LHG008					Correct Maximum itinerary number  
21/12/15	CR3248      LHG008					ECA zone implementation
08/02/17	CR4050		LHG008					Change additionals Laden and Ballasted logic
************************************************************************************/

Integer li_max, li_count
Long ll_rowcount, ll_count, ll_ID
decimal ld_ball_pct, ld_laden_pct
string ls_message
boolean lb_reset_pct

if al_cargono = 1 then
	ld_ball_pct = dw_cargo_summary.getitemnumber(1, "cal_carg_cal_carg_add_days_ballast_pcnt")
	ld_laden_pct = dw_cargo_summary.getitemnumber(1, "cal_carg_add_days_laden_pcnt")
	if ld_ball_pct <> 0 or ld_laden_pct <> 0 then
		lb_reset_pct = true
		ls_message += "~r~nAny existing Laden/Ballasted percentage will also be deleted."
	end if
end if

ls_message = "You are about to delete the cargo " + iuo_calc_nvo.iuo_calculation.uf_get_description(al_cargono) + "." + ls_message &
			  + "~r~n~r~nDo you want to continue?"

If messagebox("Delete Cargo", ls_message, Exclamation!, YesNo!, 2) = 2 Then return c#return.NoAction

// Set redraw off, and select al_cargono 
uf_redraw_off()
uf_select_cargo(al_cargono)

if lb_reset_pct then
	ii_no_cargos = dw_cargo_summary.rowcount()
	for ll_count = 2 to ii_no_cargos
		if ld_ball_pct <> 0 then dw_cargo_summary.setitem(ll_count, "cal_carg_cal_carg_add_days_ballast_pcnt", 0)
		if ld_laden_pct <> 0 then dw_cargo_summary.setitem(ll_count, "cal_carg_add_days_laden_pcnt", 0)
	next
end if

// Delete all misc expenses on loadports, and delete all loadports
ll_rowcount = dw_loadports.RowCount()
For ll_count = ll_rowcount To 1 Step -1
	uf_delete_misc_exp( dw_loadports.GetItemNumber(ll_count,"cal_caio_id"))
	iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.of_datasync('delete', dw_loadports.getrowidfromrow(ll_count), dw_loadports.getitemstring(ll_count, "purpose_code"))
	dw_loadports.DeleteRow(ll_count)
Next

il_itinerary_max = il_itinerary_max - ll_rowcount

// Delete all misc expenses on dischports, and delete all dischports
ll_rowcount = dw_dischports.RowCount()
For ll_count = ll_rowcount To 1 Step -1
	uf_delete_misc_exp(dw_dischports.GetItemNumber(ll_count,"cal_caio_id"))
	iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.of_datasync('delete', dw_dischports.getrowidfromrow(ll_count), dw_dischports.getitemstring(ll_count, "purpose_code"))
	dw_dischports.DeleteRow(ll_count)
Next

il_itinerary_max = il_itinerary_max - ll_rowcount

// Delete all addtional lumpsums
ll_rowcount = dw_calc_lumpsum.RowCount()
For ll_count = ll_rowcount To 1 Step -1
	dw_calc_lumpsum.DeleteRow(ll_count)
Next

// Delete all addtional bunker consumptions
ll_rowcount = dw_addbuncons.rowcount()
dw_addbuncons.rowsmove( 1, ll_rowcount, primary!, dw_addbuncons, 1, delete!)

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

// Do the same for addbuncons
li_max = dw_addbuncons.rowcount()
For li_count = 1 To li_max
	ll_ID = dw_addbuncons.getitemnumber(li_count, "cal_carg_id")
	If (ll_ID < 0) And (Abs(ll_ID) > al_cargono)  then dw_addbuncons.setitem(li_count, "cal_carg_id", ll_ID + 1)
Next

// If cargono > # of cargoes then set cargono to # of cargoes
If al_cargono>ii_no_cargos Then al_cargono=ii_no_cargos

// Update the itinerary
iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_update_itinerary_order()

// And select cargo
uf_select_cargo(al_cargono)

// We're done
uf_redraw_on()

return c#return.Success
end function

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
iuo_calc_nvo.iuo_calc_itinerary.of_datasync("in")
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

public subroutine of_open_worldscale (u_datawindow_sqlca dwo_load, u_datawindow_sqlca dwo_disch, integer ai_year);u_jump_worldscale luo_jump_worldscale
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

public function boolean uf_process (ref s_calculation_parm astr_parm);/********************************************************************
	uf_process
	<DESC>
		This function performs three tasks, depending on [function code].
		Code: 1;validates cargos for save.
		Code: 2;validates and performs calculation.
		Code: 3;validates fixture and perfoms calculation.
	</DESC>
	<RETURN>	True if ok	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		astr_parm	s_calculation_parm
	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date      	CR-Ref		Author		Comments
		01/08/1996	1     		MI    		First Version.
		18/11/1996	1     		MI    		Added check for grade during fixture.
		28/03/2013	CR2658		WWG004		Save the laden and ballast consumption to struct.
		02/12/2013	CR2658UAT	WWG004		If there is only a contype, auto selected it.
		07/08/2014	CR3528		XSZ004		Validation constype for idle,bunker and various.
		29/01/2015  CR3935      LHG008      Pre-select a default consumption type for Idle, Bunkering, Various
		02/09/2015  CR4048      KSH092		popup message when Idle\Bunkering\Various consumption is inactive
		04/08/2016  CR4216	   CCY018		popup message when Additonal Bunker Consumption is inactive
		08/12/2016  CR4050      LHG008      Change additionals Laden and Ballasted logic
		22/09/2017	CR4221		HHX010		Check Interim Port 
	</HISTORY>
********************************************************************/

long     ll_cargo_rows, ll_cargo_count, ll_ratetype, ll_cons_id, ll_null
Long     ll_vessel_type, ll_vessel_id, ll_clarkson_id, ll_cargo_id, ll_caio_id, ll_row, ll_idle_consid, ll_bunker_consid, ll_various_consid
long     ll_portrows, ll_portrow, ll_lumpsums, ll_lumpsum, ll_load_consid, ll_dis_consid, ll_laden_consid, ll_ballast_consid
Integer  li_pcnr, li_exp_max, li_exp_count, li_add_lumpsum, li_locked, li_consactive
Boolean  lb_result, lb_active
Double   ld_totalunits, ld_add_expenses, ld_tmp, ld_misc_exp
datetime ldt_laycan_start, ldt_laycan_end
string   ls_portcode, ls_purpose, ls_error, ls_focus_column, ls_portname
dec{3} ld_add_hsfo, ld_add_hsgo, ld_add_lsgo, ld_add_lsfo

datawindowchild ldwc_child

setnull(ll_null)
ib_expenses_interim_warning = true
// Default errortext - this one is not to be used, but should be overwritted later on
astr_parm.result.s_errortext = "Cargo calculation"

// Check that we can do an accepttext on all datawindows
If dw_cargo_summary.Accepttext() + dw_loadports.Accepttext() + dw_dischports.Accepttext() <> 3 Then
	astr_parm.result.s_errortext = "Illegal value"
	Return(false)
End if

lb_result = iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.of_firstlast_interim(astr_parm)
if not lb_result then Goto Stop

// Get number of cargorows to ll_cargo_rows
ll_cargo_rows = dw_cargo_summary.RowCount()

// If this is a fixture, then first check that at least one cargo has been
// selected for fixture, and that a APM vessel has been choosen for vessel.
If astr_parm.i_function_code = 3 Then 
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
	
	if dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_fixed_exrate_enabled") = 1 then
		if isnull(dw_cargo_summary.GetItemdecimal(ll_cargo_count, "cal_carg_fixed_exrate")) then
			messagebox("Validation Error", "Please input the fixed exchange rate.")
			Goto Stop
		elseif dw_cargo_summary.GetItemdecimal(ll_cargo_count, "cal_carg_fixed_exrate") <= 0 then
			messagebox("Validation Error","The fixed exchange rate must be above 0.")
			Goto Stop
		end if
		
		if isnull(dw_cargo_summary.GetItemstring(ll_cargo_count, "cal_carg_claim_Curr")) then
			messagebox("Validation Error","Please choose the claim currency.")
			Goto Stop
		end if
	end if
	
	//Validate constype of idle,bunkering and various
	li_locked = dw_cargo_summary.getitemnumber(ll_cargo_count, "locked")
	
	if (astr_parm.i_function_code = 1 or astr_parm.i_function_code = 2 or astr_parm.i_function_code = 3) and not isvalid(w_calc_recalc) and &
		 (li_locked <> 1 or isnull(li_locked)) and not isvalid(w_calc_cp_data) then
		 
		ll_idle_consid = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_idle_cons_id")
		if dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_idle_days") <> 0 then
			if isnull(ll_idle_consid) or ll_idle_consid = 0 then
				if of_preselect_contype(ll_cargo_count, is_IDEL, dw_cargo_summary, "cal_carg_idle_cons_id") <> c#return.Success then
					ls_error        = "ConsType for Days Idle must be selected"
					ls_focus_column = "cal_carg_idle_cons_id"
					goto stop
				end if
			else
				if astr_parm.i_function_code >= 2  then
					li_consactive = of_getconsactive(ll_idle_consid,'Idle')
					if li_consactive = 0 then
						ls_error = "You have used an inactive consumption value in Cargo - Additionals Idle. Select an active value to continue."
						dw_cargo_summary.setfocus()
						dw_cargo_summary.setcolumn("cal_carg_idle_cons_id")
						goto stop
					end if
				end if
				
			end if
		end if
		
      ll_bunker_consid = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_bunker_cons_id")
		if dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_bunkering_days") <> 0 then
			if isnull(ll_bunker_consid) or ll_bunker_consid = 0 then
				if of_preselect_contype(ll_cargo_count, is_BUNKERING, dw_cargo_summary, "cal_carg_bunker_cons_id") <> c#return.Success then
					ls_error        = "ConsType for Days Bunkering must be selected"
					ls_focus_column = "cal_carg_bunker_cons_id"
					goto stop
				end if
			else
				if astr_parm.i_function_code >= 2  then
					li_consactive = of_getconsactive(ll_bunker_consid,'Bunkering')
					if li_consactive = 0 then
						ls_error = "You have used an inactive consumption value in Cargo - Additionals Bunkering. Select an active value to continue."
						dw_cargo_summary.setfocus()
						dw_cargo_summary.setcolumn("cal_carg_bunker_cons_id")
						goto stop
					end if
				end if
			end if
		end if
		
		ll_various_consid = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_various_cons_id")
		if dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_days_other") <> 0 then
			if isnull(ll_various_consid) or ll_various_consid = 0 then	
				if of_preselect_contype(ll_cargo_count, is_VARIOUS, dw_cargo_summary, "cal_carg_various_cons_id") <> c#return.Success then
					ls_error        = "ConsType for Days Various must be selected"
					ls_focus_column = "cal_carg_various_cons_id"
					goto stop
				end if
			else
				if astr_parm.i_function_code >= 2  then
					li_consactive = of_getconsactive(ll_various_consid,'Various')
					if li_consactive = 0 then
						ls_error = "You have used an inactive consumption value in Cargo - Additionals Various. Select an active value to continue."
						dw_cargo_summary.setfocus()
						dw_cargo_summary.setcolumn("cal_carg_various_cons_id")
						goto stop
					end if
				end if
			end if
		end if

	end if
	
	//Save the laden and ballast consumption id to struct.
	ll_laden_consid = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_laden_cons_id")
	if not isnull(ll_laden_consid) and astr_parm.i_function_code >= 2 then
		li_consactive = of_getconsactive(ll_laden_consid,'Laden')
		if li_consactive = 0 then
			ls_error = "You have used an inactive consumption value in Cargo - Additionals Laden. Select an active value to continue."
			dw_cargo_summary.setfocus()
			dw_cargo_summary.setcolumn("cal_carg_laden_cons_id")
			goto stop
		end if
	end if
	
	ll_ballast_consid = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_ballast_cons_id")
	if not isnull(ll_ballast_consid) and astr_parm.i_function_code >= 2  then
		li_consactive = of_getconsactive(ll_ballast_consid,'Ballast')
		if li_consactive = 0 then
			ls_error = "You have used an inactive consumption value in Cargo - Additionals Ballasted. Select an active value to continue."
			dw_cargo_summary.setfocus()
			dw_cargo_summary.setcolumn("cal_carg_ballast_cons_id")
			goto stop
		end if
	end if
	
	if astr_parm.i_function_code >= 2 and not isvalid(w_calc_recalc) and not isvalid(w_calc_cp_data) then
		if of_checkaddbuncons() = c#return.Failure then
			ls_error = "You have used an inactive activity in Cargo – Additionals bunker consumption. Delete bunker consumption from the activity to continue."
			dw_cargo_summary.setfocus()
			goto stop
		end if
	end if

	// The following section is only valid for non-ballast voyages, since
	// it check the # of ports, quantity, etc. etc.
	If not ib_ballastvoyage Then
		
		// Check that we have at least one load + one dischport
		If  (dw_loadports.RowCount() = 0) Or (dw_dischports.RowCount() = 0) Then
			astr_parm.result.s_errortext = "At least 1 load and 1 discharge port has to be defined"
			Goto Stop
		End if
		
		//Check that there are not used inactive ports - reason why here is that old voyages can be saved as new one with 
		// inactive ports - when a new port is added the vaæidation is at the level where it is entered
		/* Load ports */
		ll_portrows = dw_loadports.rowCount()
		for ll_portrow = 1 to ll_portrows
			ls_portcode = dw_loadports.getItemString(ll_portrow, "port_code")
			ls_purpose	= dw_loadports.getItemString(ll_portrow, "purpose_code")
			SELECT PORT_ACTIVE , PORT_N
				INTO :lb_active , :ls_portname
				FROM PORTS
				WHERE PORT_CODE = :ls_portcode;
			if sqlca.sqlcode <> 0 then
				MessageBox("Select Error", "SQL select failed when reading from PORTS. (u_atobviac_calc_cargos.uf_process()")
				dw_loadports.SetFocus()
				goto Stop
			end if
			if not lb_active  and astr_parm.i_function_code >= 2 then 
				astr_parm.result.s_errortext = "You have used an inactive port: "+ls_portname+". Select an active port to continue."
				dw_loadports.post SetFocus()
				dw_loadports.post scrolltorow(ll_portrow)
				dw_loadports.post setcolumn("port_code")
				goto Stop
			end if
			
			//Auto select contype if user not select
			ll_load_consid = dw_loadports.getitemnumber(ll_portrow, "port_cons_id_all") 
			if isnull(ll_load_consid) or ll_load_consid = 0 then
				of_preselect_contype(ll_portrow, ls_purpose, dw_loadports, "port_cons_id_all")
			else
				if astr_parm.i_function_code >= 2  then
					li_consactive = of_getconsactive(ll_load_consid,'Load')
					if li_consactive = 0 then
						ls_error = 'You have used an inactive consumption value in Cargo - Port '+ls_portname+' ('+ls_purpose +'). Select an active value to continue.'
						dw_loadports.setfocus()
						dw_loadports.scrolltorow(ll_portrow)
						dw_loadports.setcolumn("port_cons_id_all")
						goto stop
					end if
				end if
			end if
		next
		
		/* Discharge port */
		ll_portrows = dw_dischports.rowCount()
		dw_dischports.getchild("port_cons_id", ldwc_child)
		for ll_portrow = 1 to ll_portrows
			ls_portcode = dw_dischports.getItemString(ll_portrow, "port_code")
			SELECT PORT_ACTIVE , PORT_N
				INTO :lb_active , :ls_portname
				FROM PORTS
				WHERE PORT_CODE = :ls_portcode;
			if sqlca.sqlcode <> 0 then
				MessageBox("Select Error", "SQL select failed when readimg from PORTS. (u_atobviac_calc_cargos.uf_process()")
				dw_dischports.SetFocus()
				goto Stop
			end if
			if not lb_active and  astr_parm.i_function_code >= 2 then 
				astr_parm.result.s_errortext = "You have used an inactive port: "+ls_portname+". Select an active port to continue."
				dw_dischports.post SetFocus()
				dw_dischports.post scrolltorow(ll_portrow)
				dw_dischports.post setcolumn("port_code")
				goto Stop
			end if	
			
			//Auto select contype if user not select
			ll_dis_consid = dw_dischports.getitemnumber(ll_portrow, "port_cons_id")
			if isnull(ll_dis_consid) or ll_dis_consid = 0 then
				of_preselect_contype(ll_portrow, "D", dw_dischports, "port_cons_id")
			else
				if astr_parm.i_function_code >= 2  then
					li_consactive = of_getconsactive(ll_dis_consid,'Dischports')
					if li_consactive = 0 then
						ls_error = 'You have used an inactive consumption value in Cargo - Port '+ls_portname+' (D). Select an active value to continue.'
						dw_dischports.setfocus()
						dw_dischports.scrolltorow(ll_portrow)
						dw_dischports.setcolumn("port_cons_id")
						goto stop
					end if
				end if
			end if
		next
		
		// Check total for load units.
		ld_totalunits = dw_loadports.GetItemNumber(1, "total_units")
		If ld_totalunits <= 0 Then
			astr_parm.result.s_errortext = "Error in quantity for loadports (must be above zero)"
			dw_loadports.SetColumn("cal_caio_number_of_units")
			dw_loadports.SetFocus()
			Goto Stop
		End if

		// Check total for disch units.
		If dw_dischports.GetItemNumber(1, "total_units") >= 0 Then
			astr_parm.result.s_errortext = "Error in quantity for dischports (must be below zero)"
			dw_dischports.SetColumn("cal_caio_number_of_units")
			dw_dischports.SetFocus()
			Goto Stop
		End iF

		// Check load and dischport datawindows.
		If not uf_process_cargos(astr_parm, dw_loadports, astr_parm.cargolist[ll_cargo_count].str_inouts, astr_parm.cargolist[ll_cargo_count].d_expenses,ll_cargo_count, li_pcnr) Then Goto Stop
		If not uf_process_cargos(astr_parm, dw_dischports, astr_parm.cargolist[ll_cargo_count].str_inouts, astr_parm.cargolist[ll_cargo_count].d_expenses,ll_cargo_count, li_pcnr) Then Goto Stop		

		// Calculating heating, deviation and misc. claims
		astr_parm.cargolist[ll_cargo_count].i_carg_id = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_id")
     	astr_parm.cargolist[ll_cargo_count].l_cerp_id = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_cal_cerp_id")
		astr_parm.cargolist[ll_cargo_count].d_commission_percent = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_temp_comission")
		astr_parm.cargolist[ll_cargo_count].d_adr_commission_percent = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_adr_commision")

		SELECT isnull(SUM(CAL_COMM.CAL_COMM_PERCENT), 0)
		INTO :astr_parm.cargolist[ll_cargo_count].d_commission_percent_pool
		FROM CAL_COMM, BROKERS
		WHERE CAL_COMM.BROKER_NR = BROKERS.BROKER_NR
		AND CAL_COMM.CAL_CERP_ID = :astr_parm.cargolist[ll_cargo_count].l_cerp_id
		AND BROKERS.BROKER_POOL_MANAGER = 1
		;
		COMMIT;
		if isnull(astr_parm.cargolist[ll_cargo_count].d_commission_percent_pool) then astr_parm.cargolist[ll_cargo_count].d_commission_percent_pool = 0
			
		// Insert into structure that u_heat_dev_misc is called with
		ll_cargo_id = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_id")
		uf_heat_dev(ll_cargo_id, astr_parm, ll_cargo_count)
		uf_misc_claims(ll_cargo_id)

		// Call calculation module for calculation' claims
		u_heat_dev_misc uo_heat_dev_misc
		uo_heat_dev_misc = Create u_heat_dev_misc
		uo_heat_dev_misc.uf_calculate(istr_hea_dev_misc_parm)
		Destroy uo_heat_dev_misc

		// Insert result of misc claims calculation in gross freight, misc. income, broker and address commission 
		// in the cargo structure for each cargo
		astr_parm.cargolist[ll_cargo_count].d_claims_adrs_comm		+= istr_hea_dev_misc_parm.d_addrs_comm_amount
		astr_parm.cargolist[ll_cargo_count].d_claims_broker_comm		+= istr_hea_dev_misc_parm.d_broker_comm_amount
		astr_parm.cargolist[ll_cargo_count].d_claims_gross_freight	+= istr_hea_dev_misc_parm.d_gross_freight_amount
		astr_parm.cargolist[ll_cargo_count].d_claims_misc_income		+= istr_hea_dev_misc_parm.d_misc_income_amount
		
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

	// OK, it was not only a save, so this is either a "calculation" process, or a fixture process. 
	If not ib_ballastvoyage Then
		// Check that load quantity = disch quantity
		if ld_totalunits <> - dw_dischports.GetItemNumber(1, "total_units") Then
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
	dw_cargo_summary.SetItem(ll_cargo_count, "cal_carg_cal_carg_total_units", ld_totalunits)
	astr_parm.cargolist[ll_cargo_count].d_totalunits = ld_totalunits

	// Get freighttype - and rate from the cargo, and validate it. Validation depends
	// on the freighttype. Eg. Lumpsum must not be 0 (but could be negative!), Unitrate
	// must not be below 0 and worldscale rate must not be 0.
	If not ib_ballastvoyage Then
		ll_ratetype = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_freight_type")
		astr_parm.cargolist[ll_cargo_count].i_rate_type = ll_ratetype
		CHOOSE CASE ll_ratetype 
			CASE 1  // $ pr. mt
				astr_parm.cargolist[ll_cargo_count].d_unitrate = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_freight_rate") + dw_cargo_summary.GetItemNumber(ll_cargo_count,"bunker_escalation")					
				If astr_parm.cargolist[ll_cargo_count].d_unitrate < 0 Then
					ls_error = "No freightrate specified"
					ls_focus_column = "cal_carg_freight_rate"
					Goto Stop	
				End if	
			CASE 2  // $ pr. cbm
				astr_parm.cargolist[ll_cargo_count].d_unitrate = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_freight_rate") 					
				If astr_parm.cargolist[ll_cargo_count].d_unitrate < 0 Then
					ls_error = "No freightrate specified"
					ls_focus_column = "cal_carg_freight_rate"
					Goto Stop	
				End if	
			CASE 3 // Lumpsum
				astr_parm.cargolist[ll_cargo_count].d_lumpsum =  dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_lumpsum")
				If astr_parm.cargolist[ll_cargo_count].d_lumpsum=0 Then
					ls_error = "No lumpsum specified"
					ls_focus_column = "cal_carg_lumpsum"
					Goto Stop	
				End if	
			CASE 4 // Worldscale
				astr_parm.cargolist[ll_cargo_count].d_wsrate = dw_cargo_summary.GetItemNumber(ll_cargo_count,"cal_carg_ws_rate")
				If astr_parm.cargolist[ll_cargo_count].d_wsrate=0 Then
					ls_error = "No worldscale rate specified"
					ls_focus_column = "cal_carg_ws_rate"
					Goto Stop	
				End if	

		END CHOOSE 			
	End if

	// Copy misc. data to the astr_parm array
	for li_add_lumpsum = 1 to dw_calc_lumpsum.rowcount()
		astr_parm.cargolist[ll_cargo_count].d_add_lumpsum[li_add_lumpsum] = dw_calc_lumpsum.getitemdecimal( li_add_lumpsum, "cal_lump_add_lumpsum_local_curr")*dw_cargo_summary.getitemdecimal( ii_current_cargo, "cal_carg_cal_carg_exrate_usd")/100
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
	
	If astr_parm.cargolist[ll_cargo_count].d_min_1 = 0 And astr_parm.cargolist[ll_cargo_count].i_overage_1 > 0 Then
		MessageBox("Calculation warning", "Invalid min/overage combination~r~n (min 1 = 0 and overage 1 is > 0)~r~n~r~nSetting overage 1 to 0")
		astr_parm.cargolist[ll_cargo_count].i_overage_1 = 0 
		dw_cargo_summary.SetItem(ll_Cargo_count, "cal_carg_overage_1", 0)			 	
	End if

	If astr_parm.cargolist[ll_cargo_count].d_min_2 = 0 And astr_parm.cargolist[ll_cargo_count].i_overage_2 > 0 Then
			MessageBox("Calculation warning", "Invalid min/overage combination~r~n(min 2 = 0 and overage 2 is > 0)~r~n~r~nSetting overage 2 to 0")
			astr_parm.cargolist[ll_cargo_count].i_overage_2 = 0 
			dw_cargo_summary.SetItem(ll_Cargo_count, "cal_carg_overage_2", 0)			 	
	End if

	// Copy more data to the astr_parm array
	astr_parm.cargolist[ll_cargo_count].i_local_flatrate = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_local_flatrate")
	astr_parm.cargolist[ll_cargo_count].d_flatrate = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_flatrate")
	astr_parm.cargolist[ll_cargo_count].d_add_income = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_cal_carg_misc_income")
	
	/* Added days idle,various and bunkering */
	astr_parm.cargolist[ll_cargo_count].d_add_days_idle = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_idle_days")
	astr_parm.cargolist[ll_cargo_count].d_add_days_bunkering =  dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_carg_bunkering_days") 
	
	astr_parm.cargolist[ll_cargo_count].l_idle_cons_id    = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_idle_cons_id")
	astr_parm.cargolist[ll_cargo_count].l_bunker_cons_id  = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_bunker_cons_id")
	astr_parm.cargolist[ll_cargo_count].l_various_cons_id = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_various_cons_id")
	
	//calculation add bunker consumptions
	ld_add_hsfo = 0
	ld_add_hsgo = 0
	ld_add_lsgo = 0
	ld_add_lsfo = 0
	if dw_addbuncons.rowcount( ) > 0 then
		ld_add_hsfo = dw_addbuncons.getitemnumber(1, "total_hsfo")
		ld_add_hsgo = dw_addbuncons.getitemnumber(1, "total_hsgo")
		ld_add_lsgo = dw_addbuncons.getitemnumber(1, "total_lsgo")
		ld_add_lsfo = dw_addbuncons.getitemnumber(1, "total_lsfo")
	end if
	
	dw_cargo_summary.setitem(ll_cargo_count, "cal_carg_add_fo", ld_add_hsfo)
	dw_cargo_summary.setitem(ll_cargo_count, "cal_carg_add_do", ld_add_lsgo)
	dw_cargo_summary.setitem(ll_cargo_count, "cal_carg_add_mgo", ld_add_hsgo)
	dw_cargo_summary.setitem(ll_cargo_count, "cal_carg_add_lsfo", ld_add_lsfo)
	
	/* Added days in port with port consumption */
	astr_parm.cargolist[ll_cargo_count].d_add_days = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_days_other")
	astr_parm.cargolist[ll_cargo_count].d_add_fo = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_fo")
	astr_parm.cargolist[ll_cargo_count].d_add_do = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_do")
	astr_parm.cargolist[ll_cargo_count].d_add_mgo = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_mgo")
	astr_parm.cargolist[ll_cargo_count].d_add_lsfo = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_lsfo")
	astr_parm.cargolist[ll_cargo_count].d_add_expenses += dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_add_expenses")

	If IsNull(astr_parm.cargolist[ll_cargo_count].d_expenses) Then astr_parm.cargolist[ll_cargo_count].d_expenses = 0
	
	// Get reversible flags from C/P (if CP is defined). If no C/P is defined, and
	// we're doing a fixture on this cargo, then produce an error to the user.
	astr_parm.cargolist[ll_cargo_count].l_cerp_id = dw_cargo_summary.GetItemNumber(ll_cargo_count, "cal_carg_cal_cerp_id")
	If astr_parm.cargolist[ll_cargo_count].l_cerp_id > 0 Then

		SELECT CAL_CERP_REV_DEM, CAL_CERP_REV_FREIGHT
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
	ldt_laycan_start = dw_cargo_summary.GetItemDateTime(ll_cargo_count, "cal_carg_cal_carg_laycan_start")
	If Isnull(ldt_laycan_start) Then 
		astr_parm.result.s_errortext = "There has to be a Laycan Start date!"
		Goto Stop
	End If

	ldt_laycan_end = dw_cargo_summary.GetItemDateTime(ll_cargo_count, "cal_carg_cal_carg_laycan_end")
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

		dw_cargo_summary.SetItem(ll_cargo_count, "cal_carg_add_expenses", 0)
	End if
Next

	
//Set additional ballast/laden speed
uf_update_speed(false)

// Additional ballast and laden
for ll_cargo_count = 1 to ll_cargo_rows
	ll_laden_consid = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_laden_cons_id")
	ll_ballast_consid = dw_cargo_summary.GetItemNumber(ll_Cargo_count, "cal_carg_ballast_cons_id")
	
	astr_parm.cargolist[ll_cargo_count].l_laden_cons_id	= ll_laden_consid
	astr_parm.cargolist[ll_cargo_count].l_ballast_cons_id	= ll_ballast_consid
	
	if astr_parm.i_function_code <> 1 then
		if ll_cargo_count = 1 then
			/* Added days ballasted percent */
			astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt = dw_cargo_summary.getitemnumber(ll_cargo_count, "cal_carg_cal_carg_add_days_ballast_pcnt")
			if isnull(astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt) then	astr_parm.cargolist[ll_cargo_count].i_add_days_ballasted_pcnt = 0
			
			/* Added days laden percent */
			astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt = dw_cargo_summary.getitemnumber(ll_cargo_count, "cal_carg_add_days_laden_pcnt")
			if isnull(astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt) then astr_parm.cargolist[ll_cargo_count].i_add_days_laden_pcnt = 0
		end if
		
		/* Added days ballasted with ballast consumption in % and speed */
		astr_parm.cargolist[ll_cargo_count].d_add_days_ballasted = dw_cargo_summary.getitemnumber(ll_cargo_count, "cal_carg_cal_carg_add_days_ballast")
		astr_parm.cargolist[ll_cargo_count].d_add_days_ballasted *= (1 + astr_parm.cargolist[1].i_add_days_ballasted_pcnt / 100)
		
		astr_parm.cargolist[ll_cargo_count].d_add_days_ballasted_speed = dw_cargo_summary.getitemnumber(ll_cargo_count, "ballast_speed")
		
		/* Added days laden with laden consumption in % and speed*/
		astr_parm.cargolist[ll_cargo_count].d_add_days_sea = dw_cargo_summary.getitemnumber(ll_cargo_count, "cal_carg_cal_carg_add_days_laden")
		astr_parm.cargolist[ll_cargo_count].d_add_days_sea *= (1 + astr_parm.cargolist[1].i_add_days_laden_pcnt / 100)
		
		astr_parm.cargolist[ll_cargo_count].d_add_days_laden_speed = dw_cargo_summary.getitemnumber(ll_cargo_count, "laden_speed")
	end if
next


lb_result = true

// Ok, everything went well, show a last warning-dialog to the user.
If astr_parm.i_function_code=3 Then 
	lb_result = MessageBox("Warning", "Perform fixture ?", Exclamation!, YesNo!, 2) = 1
	If not lb_result then astr_parm.result.s_errortext = "Fixture was aborted!"
End if

Stop:

if ls_error <> "" then
	astr_parm.result.s_errortext = ls_error
//	dw_cargo_summary.setfocus()
//	dw_cargo_summary.setcolumn(ls_focus_column)
end if

// If anything went wrong, then add information about cargo # to the error message
If Not lb_result Then
	if ll_cargo_count = 0 then 
		astr_parm.result.s_errortext = astr_parm.result.s_errortext
	else
		astr_parm.result.s_errortext = "Cargo no. " + String(ll_cargo_count)+ "~r~n~r~n" + astr_parm.result.s_errortext
	end if
End if
Return(lb_result)
end function

public subroutine uf_update_speed (boolean ab_isvesselchanged);/********************************************************************
   uf_update_speed
   <DESC>	If the user changes the ship or Laden/Ballasted days selctected with no Speed. Then 
				Get/Set the new speed for laden and ballasted if days entered	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
				ab_isvesselchanged
   </ARGS>
   <USAGE>	uf_process(); uo_calculation.uf_set_vessel()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/12/16 CR4050        LHG008   Change additionals Laden and Ballasted logic
   </HISTORY>
********************************************************************/

long ll_conscount, ll_cargo_rows, ll_cargo_count, ll_saliling_type
long ll_cons_id, ll_cons_type, ll_zone_id, ll_find
string ls_days_column, ls_consid_column, ls_speed_column, ls_findexpr
integer li_speedtype
decimal ld_speed, ld_add_days, ld_null
boolean lb_zoneignored

setnull(ld_null)
ll_conscount = iuo_calc_nvo.ids_cal_cons.rowcount()
ll_cargo_rows = dw_cargo_summary.RowCount()

//Laden speed
for ll_cargo_count = 1 to ll_cargo_rows
	for ll_saliling_type = 1 to 2 // Laden/Ballasted
		if ll_saliling_type = 1 then
			// Ballasted
			li_speedtype = c#consumptiontype.il_SAILING_BALLAST
			ls_days_column = "cal_carg_cal_carg_add_days_ballast"
			ls_consid_column = "cal_carg_ballast_cons_id"
			ls_speed_column = "ballast_speed"
		else
			// Laden
			li_speedtype = c#consumptiontype.il_SAILING_LADEN
			ls_days_column = "cal_carg_cal_carg_add_days_laden"
			ls_consid_column = "cal_carg_laden_cons_id"
			ls_speed_column = "laden_speed"
		end if
		
		ld_add_days = dw_cargo_summary.getitemnumber(ll_cargo_count, ls_days_column)
		ll_cons_id = dw_cargo_summary.getitemnumber(ll_cargo_count, ls_consid_column)
		
		//Refresh the speed when changing vessel
		if ab_isvesselchanged then
			if not isnull(ll_cons_id) then
				ls_findexpr = "cal_cons_id = " + string(ll_cons_id)
				ll_find = iuo_calc_nvo.ids_cal_cons.find(ls_findexpr, 1, ll_conscount)
				if ll_find <= 0 then
					//If the vessel changed we need find the same speed
					SELECT CAL_CONS_TYPE, ZONE_ID, CAST(ISNULL(CAL_CONS_SPEED, 0) as decimal(7, 2)) 
					  INTO :ll_cons_type, :ll_zone_id, :ld_speed 
					  FROM CAL_CONS 
					  WHERE CAL_CONS_ID = :ll_cons_id;
					
					ls_findexpr = "cal_cons_type = " + string(ll_cons_type) + " and zone_id = " + string(ll_zone_id) &
									+ " and cal_cons_speed = " + string(ld_speed) + " and cal_cons_active = 1"
									
					ll_find = iuo_calc_nvo.ids_cal_cons.find(ls_findexpr, 1, ll_conscount)
					if ll_find <= 0 then
						setnull(ll_cons_id)
						dw_cargo_summary.setitem(ll_cargo_count, ls_speed_column, ld_null)
					else
						ll_cons_id = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_find, "cal_cons_id")
					end if
					dw_cargo_summary.setitem(ll_cargo_count, ls_consid_column, ll_cons_id)
					
				end if
			end if
			
			continue
		end if
		
		if not isnull(ld_add_days) and ld_add_days <> 0 and isnull(ll_cons_id) then
			if uo_global.ib_usedefaultspeed then
				ld_speed = uo_global.id_calcdefaultspeed
			elseif uo_global.ib_full_speed then
				ld_speed = 99999.99
			else
				ld_speed = -99999.99
			end if
			
			ll_cons_id = iuo_calc_nvo.iuo_calc_itinerary.of_getappropriatespeed(iuo_calc_nvo.ids_cal_cons, li_speedtype, false, ld_speed, lb_zoneignored)
			
			if isnull(ll_cons_id) or ll_cons_id <= 0 then
				// No ballasted/loaded consumption defined for this vessel
				continue
			end if
			
			dw_cargo_summary.setitem(ll_cargo_count, ls_consid_column, ll_cons_id)
			dw_cargo_summary.setitem(ll_cargo_count, ls_speed_column, ld_speed)
		end if
	next
next

return
end subroutine

public subroutine uf_retrieve (long al_calcid, ref u_datawindow_sqlca adw_summary);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieved the given calculation (that is, cargoes on that calcid)

 Arguments : al_calcid, adw_summary (the calculation-summary-list datawindow)

 Returns   : None  

*************************************************************************************
Development Log 
DATE        VERSION  NAME     DESCRIPTION
--------    -------  ------   -------------------------------------
29/06/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO).  
************************************************************************************/

// Variable declaration

Long ll_count, ll_cerp_id
Long ls_cargo_id[]
Integer li_cp, li_frt
Double ld_null
Long  ll_max
Integer li_chart_nr
String ls_tmp, ls_chart
/* advanced portvalidator variables */
integer li_action =0
integer li_output=3
n_portvalidator lnv_validator
	

SetNull(ld_null)

// Remove all filter
uf_select_cargo(-1)

// Retrieve all cargos for this calculation
ii_no_cargos = dw_cargo_summary.Retrieve(al_calcid) 

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

of_getconsdropdown()

// Retrieve data to Hidden data window for port expenses, hea/dev & misc. claims 
// and retrieve ports 
dw_calc_port_expenses.retrieve(al_calcid)
dw_calc_hea_dev_claim.retrieve(al_calcid)
dw_calc_misc_claim.retrieve(al_calcid)

dw_loadports.retrieve(ls_cargo_id)
dw_dischports.retrieve(ls_cargo_id)

dw_calc_lumpsum.settransobject(sqlca)
dw_calc_lumpsum.retrieve(ls_cargo_id)

dw_addbuncons.retrieve(al_calcid)

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

/* advanced port validator */
lnv_validator = create n_portvalidator

if iuo_calc_nvo.iuo_calculation.ib_show_messages = false then
	li_output=0
end if

lnv_validator.of_registeractivedw(dw_loadports)
lnv_validator.of_registeractivedw(dw_dischports)

if lnv_validator.of_start( "CALCCARGO", adw_summary, iuo_calc_nvo.iuo_calculation.of_getcheckdata() , li_output, false, li_action ) = c#return.Failure then
	if li_action = 1 then
		dw_cargo_summary.setitem(1, "locked",1)
	elseif li_action = 2 then
	end if	
end if

ib_vessellocked = iuo_calc_nvo.iuo_calculation.of_getcheckstatusid() >= 4 
destroy lnv_validator

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
		dw_loadports.SetItem(ll_count_to,COLUMN_DEMURRAGE_LOCAL_CURR,0)
		dw_loadports.SetItem(ll_count_to,COLUMN_DESPATCH_LOCAL_CURR,0)
		dw_loadports.SetItem(ll_count_to,COLUMN_DEMURRAGE_DEM_CURR,0)
		dw_loadports.SetItem(ll_count_to,COLUMN_DESPATCH_DEM_CURR,0)
		dw_loadports.SetItem(ll_count_to,COLUMN_DEMURRAGE_USD,0)
		dw_loadports.SetItem(ll_count_to,COLUMN_DESPATCH_USD,0)
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
		uf_reversible(1, dw_loadports, 0, li_dummy, ld_dummy, ld_dummy, li_dummy)
		uf_reversible(1, dw_dischports, 0, li_dummy, ld_dummy, ld_dummy, li_dummy)
	End if
next

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

		iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.SetItem(ll_count, "compute_0046", ls_tmp)
		// Line below is obsolete and should be deleted
		ls_chart = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary_list.GetItemstring(ll_count,"compute_0046")
	End if
Next

// Reset updates (otherwise the calc. would have status as changed)
dw_cargo_summary.ResetUpdate()
dw_loadports.Resetupdate()
dw_dischports.Resetupdate()
dw_calc_lumpsum.Resetupdate( )

ii_current_cargo = 0

// And tell the rest of the calculation system, that the calculation has changed
uf_port_changed()

// Select cargo 1, and we're done
uf_select_cargo(1)

if dw_cargo_summary.getitemnumber( 1, "locked") = 0 then
	dw_cargo_summary.SetFocus()
end if






end subroutine

private subroutine documentation ();/********************************************************************
	ObjectName: cargo object
	<OBJECT> Object Description </OBJECT>
	<USAGE>  Object Usage	</USAGE>
	<ALSO>   Other Objects	</ALSO>
	<HISTORY> 
	  Date			CR-Ref   	Author	Comments
	  05/08/10		?     		JSU042	Start logging
	  05/08/10		CR1017    	JSU042	Made multi calculation lumpsums
	  07/01/11   	CR2242    	JSU042	via points in the cargo are not locked
	  09/02/11  	CR1549   	JSU042	Multi currency calculation
	  28/11/11		D-CALC		AGL027	Added to MT framework and fixed minor issues.  Also using portvalidator inside check module.
	  19/06/12		CR#2831		AGL027	Removed obsolete code
	  13/03/13		CR2658		WWG004	Remove the EU Port and the it affect consumption.
	  26/07/13		CR2476		LHG008	"Do Fixture" validation to accept Demurrage = 0
	  10-09-13		CR3154		WWA048	Demurrage rate should be changed when purpose is changed to Load or Discharge
	  18-11-13		CR2658UAT	WWG004	Add At Port General to the contype list when purpose code is L or D.
	  28-11-13		CR2658UAT	ZSW001	Add a new function of_getconsdropdown()
	  23-01-14		CR2658UAT	WWG004	Add new function of_preselect_contype()
	  11-02-14		CR2658UAT	LHG008	Correct Maximum itinerary number
	  06/05/14		CR3635      LHG008	Itinerary ID issue
	  12/05/14		CR3634      LHG008	Partial commit issue
	  05/06/2014 	CR3562     	KSH092	Only Consumption Types with Zone="Normal" are possible to be pre-selected for ConsType column
	  05/06/2014 	CR3625     	KSH092	"At Port - Heating" ConstType must be listed in the dropdown list
	  05/06/2014 	CR3640     	KSH092	"At port - Heating" should be displayed in the "Consumption Type" dropdown list no
	            	         	      	matter the "Purpose" selected.
	  05/06/14		CR3634UAT   LHG008	Change for improvement in user experience
	  07/08/14  	CR3528		XSZ004	Validation constype for idle,bunker and various.
	  02/09/14  	CR3512		XSZ004	Fix the bug for multi error messagebox popup when changing vessel
	  13/10/14		CR3528 		XSZ004	Set constype to empty when changing days idle,days bunkering and days various to 0
	  29/10/14		CR3528UAT	XSZ004	Remove some columns for idle,bunkering and various constype dropdown list
	  26/12/14		CR3433 		LHG008	Fix the bug for failed to add new load port feature from the compact window
	  29/01/15		CR3935 		LHG008	Pre-select a default consumption type when you input additional days in Idle/Bunkering/Various Days field
	  15/04/15		CR3835 		LHG008	Fix the usability issue of data displayed format and data transfer between normal view and compact view when the column loses focus
	  30/09/15		CR4048      KSH092	Add active status to consumption dropdown list
	  29/10/15		CR3250		CCY018	Add LSFO fuel in calculation module.
	  21/12/15		CR3248		LHG008	ECA zone implementation
	  22/03/16		CR4157		LHG008	Default Speed extended(Remove the "ask for speed when calculating" feature)
	  20/04/16     CR2428      SSX014   Change demurrage currency
	  28/04/16		CR4309		KSH092   When exists inactive consumption ,the calcultion is can saveas
	  28/06/16		CR4219		LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
	  04/08/16		CR4216		CCY018	Add Additonal Bunker Consumption window
	  09/14/16     CR4226      SSX014   Fixed some loose end for CR2428
	  29/09/16		CR4516		CCY018	Fixed a bug
	  08/12/16		CR4050		LHG008	Change additionals Laden and Ballasted logic
	  23/03/17		CR4414		CCY018	Add voyage alert
	  22/08/17		CR4221		HHX010	Add interim port
	</HISTORY>    
********************************************************************/
end subroutine

public subroutine _updatedemusd (decimal ad_exrate);/********************************************************************
   _updatedemusd
   <DESC>	Description	</DESC>
   <RETURN>	None </RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		ad_exrate: the demurrage currency exchange rate
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		20/04/16 CR2428        SSX014   Update demurrage/despatch rate in USD and local currency
   </HISTORY>
********************************************************************/

integer li_port
string ls_local_curr_code, ls_dem_curr_code
decimal ld_despatch_usd, ld_demurrage_usd, ld_desptch_dem, ld_demurrage_dem
decimal ld_local_exrate, ld_null

ls_local_curr_code = dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE)
ls_dem_curr_code = dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_DEM_CURR_CODE)
ld_local_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
SetNull(ld_null)

for li_port = 1 to dw_loadports.rowcount()
	ld_desptch_dem = dw_loadports.getitemnumber(li_port, COLUMN_DESPATCH_DEM_CURR)
	if ld_desptch_dem <> 0 then
		ld_despatch_usd = ld_desptch_dem * ad_exrate / 100
		dw_loadports.setitem(li_port, COLUMN_DESPATCH_USD,  ld_despatch_usd)
		if ls_local_curr_code = ls_dem_curr_code then
			dw_loadports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_desptch_dem )
		else
			if ld_local_exrate <> 0 then
				dw_loadports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_despatch_usd / (ld_local_exrate / 100.0) )
			else
				dw_loadports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_null)
			end if
		end if
	end if
	
	ld_demurrage_dem = dw_loadports.getitemnumber(li_port, COLUMN_DEMURRAGE_DEM_CURR)
	if ld_demurrage_dem <> 0 then
		ld_demurrage_usd = ld_demurrage_dem * ad_exrate / 100
		dw_loadports.setitem(li_port, COLUMN_DEMURRAGE_USD,  ld_demurrage_usd)
		if ls_local_curr_code = ls_dem_curr_code then
			dw_loadports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_demurrage_dem )
		else
			if ld_local_exrate <> 0 then
				dw_loadports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_demurrage_usd / (ld_local_exrate / 100.0) )
			else
				dw_loadports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_null)
			end if
		end if
	end if
next

for li_port = 1 to dw_dischports.rowcount()
	ld_desptch_dem = dw_dischports.getitemnumber(li_port, COLUMN_DESPATCH_DEM_CURR)
	if ld_desptch_dem <> 0 then
		ld_despatch_usd = ld_desptch_dem * ad_exrate / 100
		dw_dischports.setitem(li_port, COLUMN_DESPATCH_USD,  ld_despatch_usd)
		if ls_local_curr_code = ls_dem_curr_code then
			dw_dischports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_desptch_dem )
		else
			if ld_local_exrate <> 0 then
				dw_dischports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_despatch_usd / (ld_local_exrate / 100.0) )
			else
				dw_dischports.setitem(li_port, COLUMN_DESPATCH_LOCAL_CURR, ld_null)
			end if
		end if
	end if
	
	ld_demurrage_dem = dw_dischports.getitemnumber(li_port, COLUMN_DEMURRAGE_DEM_CURR)
	if ld_demurrage_dem <> 0 then
		ld_demurrage_usd = ld_demurrage_dem * ad_exrate / 100
		dw_dischports.setitem(li_port, COLUMN_DEMURRAGE_USD,  ld_demurrage_usd)
		if ls_local_curr_code = ls_dem_curr_code then
			dw_dischports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_demurrage_dem )
		else
			if ld_local_exrate <> 0 then
				dw_dischports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_demurrage_usd / (ld_local_exrate / 100.0) )
			else
				dw_dischports.setitem(li_port, COLUMN_DEMURRAGE_LOCAL_CURR, ld_null)
			end if
		end if
	end if
next

end subroutine

public function boolean _validatecolumn (string as_columnname, string as_columns[]);long ll_row

for ll_row=1 to upperbound(as_columns)
	if as_columnname = as_columns[ll_row] then
		return true
	end if
next	

return false
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
long					ll_cal_calc_id, ll_cal_fix_id, ll_calestid 
integer				li_cal_calc_status, li_comm_settled, li_settled=0
mt_n_datastore 	lds_claimdata
long					ll_row

if iuo_calc_nvo.iuo_calculation.of_getestcalcid()  = 0 then 
	return 1
else
	// of_getvoyagedata(ll_calestid,ll_vessel,ls_voyage)
	lds_claimdata = create mt_n_datastore
	lds_claimdata.dataObject = "d_sq_tb_check_claimbalance"
	lds_claimdata.setTransObject(sqlca)
	
	/* check claim amounts */
	for ll_row = 1 to lds_claimdata.retrieve( iuo_calc_nvo.iuo_calculation.of_getcheckvesselnr() , iuo_calc_nvo.iuo_calculation.of_getcheckvoyagenr())
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
	Public
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
  Date		CR-Ref	  	Author	 				Comments
  ??/??/??	?	        	Martin Israelsen   	Initial version
  20/09-11	D-CALC    	AGL027   				Refactored
  11/02/14	CR2658UAT	LHG008					Correct Maximum itinerary number
  12/05/14	CR3634      LHG008					Partial commit issue
  05/06/14	CR3634UAT   LHG008					Change for improvement in user experience
  21/12/15	CR3248      LHG008					ECA zone implementation
</HISTORY>
*********************************************************************/

long ll_row, ll_count, ll_caio_id
integer li_locked

if not isvalid(adw_port) or isnull(adw_port) then return

ll_row = adw_port.getrow()
if ll_row < 1 then return

/* Check if ll_row = 0 or if the port is locked.  (If ll_row = 0 then the rows will be locked due to a PB4 error) */
if (ll_row = 0) then li_locked = 1 else li_locked = adw_port.getitemnumber(ll_row, "edit_locked")

/* Drop deletion if the port is locked */
if li_locked <> 0 Then
	messageBox("Information", "You cannot delete a locked port.", StopSign!)
	return
end if

/* Check that this in not the only port (a calculation must have atleast 1 load and 1 dischports). */
if adw_port.rowcount() = 1 Then
	messageBox("Error","You cannot delete the last port.", StopSign!)
	return
end if

//Check if there is a cargo created for this port
if isvalid(inv_opdata) then
	if inv_opdata.ii_calcstatus > 4 then
		ll_caio_id = adw_port.getitemnumber(ll_row, "cal_caio_id")
	
		SELECT COUNT(*) INTO :ll_count FROM CD WHERE CAL_CAIO_ID = (
				 SELECT MIN(CAL_CAIO_ID)
					FROM CAL_CAIO, CAL_CARG
				  WHERE CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID
					 AND CAL_CARG.CAL_CALC_ID = :inv_opdata.il_estcalcid
					 AND CAL_CAIO_ITINERARY_NUMBER = (
						  SELECT CAL_CAIO_ITINERARY_NUMBER
							 FROM CAL_CAIO
							WHERE CAL_CAIO_ID = :ll_caio_id));
		
		if ll_count > 0 then
			messagebox("Error", "You cannot delete the port, because there is a cargo created for this port.", StopSign!)
			return
		end if
	end if
end if

if messagebox("Warning","You are about to delete a port. Continue?",Stopsign!,YesNoCancel!,2) = 1 then
	/* Now delete the port. */
	/* First delete all misc. expenses on this port ! */
	uf_delete_misc_exp( adw_port.GetItemNumber(ll_row,"cal_caio_id") )
	
	//Delete itinerary before delete port
	iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.of_datasync('delete', adw_port.getrowidfromrow(ll_row), adw_port.getitemstring(ll_row, "purpose_code"))
	
	adw_port.deleterow(ll_row)
	if ll_row > 1 then ll_row --
	adw_port.setrow(ll_row)
	
	/* Tell the calculation system that the ports have changed and update the itinerary */
	uf_port_changed()
	iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_update_itinerary_order()
	il_itinerary_max --
else
	return
end if
end subroutine

public subroutine of_deletelumpsum (u_datawindow_sqlca adw);/********************************************************************
   FunctionNam: of_deletelumpsum
   <DESC>	The functionh is used to delete an addtional lumpsum. The addtional lumpsums 
					can not be deleted when the freight claim is settled. Users need to contact finance
					department.
  </DESC>
   <RETURN>	None   	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>		Integer: al_row	     </ARGS>
   <USAGE>	Calling from u_atobviac_calculation.uf_delete( ) </USAGE>
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
  23/01-14	CR2658UAT	WWG004					Insert row auto pre-select the lowerest ID contype
  29/01/15	CR3935		LHG008					Pre-select a default consumption type for Idle, Bunkering, Various
  29/06/16	CR4219		LHG008					Accuracy and improvement in DEM and DEV claims handling(CHO).
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
If adw.classname() = 'dw_loadports' then
	dw_loadports.SetItem(ll_port_row,"purpose_code","L")
	dw_loadports.event rowfocuschanged(ll_port_row)
	of_preselect_contype(ll_port_row, "L", dw_loadports, "port_cons_id_all")
else
	dw_dischports.SetItem(ll_port_row, "purpose_code", "D")
	of_preselect_contype(ll_port_row, "D", dw_dischports, "port_cons_id")
end if

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
	uf_reversible(1, adw, 0, li_null, ld_null, ld_null, li_null)
	adw.SetColumn("port_code")	
End If

adw.ScrollToRow(ll_port_row)

// Tell the calculation system, that one or more ports has changed
uf_port_changed()

// and turn redraw back on
adw.uf_redraw_on()
end subroutine

public subroutine of_getconsdropdown ();/********************************************************************
   of_getconsdropdown
   <DESC>	Get the drop down list data	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		28/11/2013		CR2658		ZSW001		First Version
		05/06/2014		CR3625		KSH092		At Port - Heating ConstType must be listed in the dropdown list
		07/08/2014		CR3528		XSZ004		Init consumption type for "Days idle","Days bunkering" or "Days various" 
   </HISTORY>
********************************************************************/

iuo_calc_nvo.of_getconsdropdown(dw_cargo_summary, "cal_carg_idle_cons_id", "3,4,6,7,8", true,true,dw_cargo_summary.getrow())
iuo_calc_nvo.of_getconsdropdown(dw_cargo_summary, "cal_carg_bunker_cons_id", "3,4,6,7,8", true,true,dw_cargo_summary.getrow())
iuo_calc_nvo.of_getconsdropdown(dw_cargo_summary, "cal_carg_various_cons_id", "1,2,3,4,6,7,8,9,10", true,true,dw_cargo_summary.getrow())

iuo_calc_nvo.of_getconsdropdown(dw_cargo_summary, "cal_carg_laden_cons_id", "2", true,true,dw_cargo_summary.getrow()) // Sailing - Laden
iuo_calc_nvo.of_getconsdropdown(dw_cargo_summary, "cal_carg_ballast_cons_id", "1", true,true,dw_cargo_summary.getrow()) // Sailing - Ballast
iuo_calc_nvo.of_getconsdropdown(dw_loadports, "port_cons_id", '3,4,7,8', true,false,dw_loadports.getrow())
dw_loadports.event ue_filterconsdddw(dw_loadports.getrow(), true)
iuo_calc_nvo.of_getconsdropdown(dw_dischports, "port_cons_id_all", '4,6,8', true,false,dw_dischports.getrow())
dw_dischports.event ue_filterconsdddw(dw_dischports.getrow(), true)


end subroutine

public function integer of_preselect_contype (integer al_row, string as_purposecode, u_datawindow_sqlca adw, string as_column);/********************************************************************
   of_preselect_contype
   <DESC>	Auto select the loweret ID contype	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.NoAction: 0, noaction	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		as_purposecode
		adw
		as_column
   </ARGS>
   <USAGE>	Insert port or change purpose.	</USAGE>
   <HISTORY>
   	Date      CR-Ref               Author   Comments
   	23/01/14  CR2658V27043UAT      WWG004   First Version
   	05/06/14  CR3625,CR3562,CR3640 KSH092
   	29/01/15  CR3935               LHG008   Pre-select a default consumption type for Idle, Bunkering, Various
   </HISTORY>
********************************************************************/

//At Port-General 4     At Port-Load 3     At Port-Discharge 6
//At Port-Idle    7     At Port-Heating 8

integer	li_return
long		ll_found, ll_null
string	ls_orig_filter, ls_filter, ls_findexpr, ls_defaultzone

datawindowchild ldwc_child

setnull(ll_null)

adw.setitem(al_row, as_column, ll_null)
if adw.getchild(as_column, ldwc_child) = 1 then
	
	ls_orig_filter = ldwc_child.describe("datawindow.table.filter")
	
	choose case as_purposecode
		case 'L'
			ls_filter = "cal_cons_type in (3,4,8)"
		case 'D'
			ls_filter = "cal_cons_type in (4,6,8)"
		case 'WD'
			ls_filter = "cal_cons_type in (4,7,8)"
		case is_IDEL
			ls_filter = "cal_cons_type in (4,7)"
		case is_BUNKERING, is_VARIOUS
			ls_filter =  "cal_cons_type in (4)"
		case else
			ls_filter = "cal_cons_type in (4,8)"
	end choose
	ls_filter = ls_filter +  " and cal_cons_active = 1 "
	ldwc_child.setfilter(ls_filter)
	ldwc_child.filter()
	
	//Auto pre-select the first contype
	if ldwc_child.rowcount() = 1 then	//Only one contype in dropdownlist
		if ldwc_child.GetitemNumber(1,'zone_id') = uo_global.ii_default_cons_zone and ldwc_child.getitemnumber(1,'cal_cons_active') = 1 then
		   adw.setitem(al_row, as_column, ldwc_child.getitemnumber(1, "cal_cons_id"))
			li_return = c#return.Success
		end if
	else	//More then one contypes in dropdownlist.
		choose case as_purposecode
			case 'L'
				ls_findexpr = "cal_cons_type = 3"
			case 'D'
				ls_findexpr = "cal_cons_type = 6"
			case 'WD', is_IDEL
				ls_findexpr = "cal_cons_type = 7"
			case is_BUNKERING, is_VARIOUS
				ls_findexpr = "cal_cons_type = 4"
			case else
				ls_findexpr = "cal_cons_type = 4"
		end choose
		
		
		ls_defaultzone = "zone_id = " + string(uo_global.ii_default_cons_zone)
		ls_defaultzone = ls_defaultzone + " and cal_cons_active = 1 "
		
		ll_found = ldwc_child.find(ls_findexpr + " and " + ls_defaultzone, 1, ldwc_child.rowcount())
		if ll_found <= 0 then
			ls_findexpr = "cal_cons_type = 4"
			ll_found = ldwc_child.find(ls_findexpr + " and " + ls_defaultzone, 1, ldwc_child.rowcount())
		end if
		
		if ll_found > 0 then
			adw.setitem(al_row, as_column, ldwc_child.getitemnumber(ll_found, "cal_cons_id"))
			li_return = c#return.Success
		end if
	end if
	
	if len(ls_orig_filter) > 1 and as_purposecode = is_IDEL or as_purposecode = is_BUNKERING or as_purposecode = is_VARIOUS then
		ldwc_child.setfilter(ls_orig_filter)
		ldwc_child.filter()
	end if
end if

return li_return
end function

public function integer of_check_constype (string as_msg_title, string as_columnname, u_datawindow_sqlca adw_datawindow);/********************************************************************
	of_check_constype
	<DESC> </DESC>
	<RETURN>	
		integer:
		<LI> c#return.Success, ok
		<LI> c#return.Failure, failed	
	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		as_message_title string
		as_columnname    string
		adw_datawindow	  u_datawindow_sqlca
	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		02/09/14		CR3512		XSZ004		First version
	</HISTORY>
********************************************************************/

string ls_msg_content
datawindowchild ldwc_child

ls_msg_content = "Tramos cannot find the consumption type you want. Please update the " + &
                 "Speed & Consumption master data in the Vessels system table."

if adw_datawindow.getchild(as_columnname, ldwc_child) = 1 then
	if ldwc_child.rowcount() = 0 then
		messagebox(as_msg_title, ls_msg_content)
		return c#return.failure
	end if
end if

return c#return.success
end function

public function integer of_return_activestatus (string as_columnname, string as_messagecontent, datawindow adw_parent, string as_data);/********************************************************************
   of_return_activestatus()
   <DESC>	When update attachment,insert change history	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	dw_cargo_summary.itemchanged();dw_loadports.itemchanged();dw_dischports.itemchanged() <USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		01/09/15	CR4048       KSH092   First Version
   </HISTORY>
********************************************************************/
datawindowchild ldwc_dddw
long ll_row, ll_active

adw_parent.getchild(as_columnname,ldwc_dddw)
ll_row = ldwc_dddw.find("cal_cons_id = " + as_data, 1, ldwc_dddw.rowcount())
if ll_row > 0 then
	ll_active = ldwc_dddw.getitemnumber(ll_row,'cal_cons_active')
	if ll_active = 1 then
		return C#Return.Success
	else
		if as_messagecontent = 'speed' then
			messagebox('Validation','Selected speed is marked as Inactive. Please select another speed.')

		else
			messagebox('Validation','Selected consumption is marked as Inactive. Please select another consumption.')
		end if
		Return C#return.Failure
	end if
else
	return C#Return.Failure
end if

return C#return.Success
end function

public function integer of_getconsactive (long al_cons_id, string as_column);/********************************************************************
   of_getconsactive()
   <DESC>		</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	uf_process() <USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		01/09/15	CR4048       KSH092   First Version
   </HISTORY>
********************************************************************/

Integer li_consactive

SELECT CAL_CONS_ACTIVE
INTO :li_consactive
FROM CAL_CONS
WHERE CAL_CONS_ID = :al_cons_id;

if li_consactive = 0 then
	
	return 0
	
end if

return 1
end function

public function integer of_validatecargosummary (u_datawindow_sqlca adw_summ, dwobject adwo, long al_row, string as_data);/************************************************************************************
 Author    : MI
   
 Date       : August 1996

 Description : Handles changes in columns description, reversible freight, freight type
 					and reversible freight. 					

 Arguments : None

 Returns   : None
*************************************************************************************
Development Log 
DATE		 VERSION 	NAME			DESCRIPTION
15/02/11  CR1549     JSU042	    multi currencies 
29/01/15  CR3935     LHG008	    Pre-select a default consumption type when you input additional days in Idle/Bunkering/Various Days field
12/04/16  CR2428     SSX014       When user changes “Freight Curr” and “Ex Rate to USD” (amount and/or date), the same changes should be applied to the demurrage side when possible.
03/06/16  CR4307     SSX014       To support currency hedge
02/09/16  CR4382     SSX014       Fix some possible loose ends
************************************************************************************/

// Set local variables
long ll_tmp, ll_cerp_id,  ll_count, ll_dummy, ll_value, ll_cargo_row
integer li_settledfreight=0, li_settledother=0
integer li_dummy, li_messagebox, li_first_load, li_settled, li_colindex, li_cargo
decimal ld_dummy, ld_value
decimal 	ld_exrate
date ldt_exrate_date, ldt_null
boolean lb_fixexrate
n_exchangerate lnv_exchangerate
string ls_column, ls_local_curr_code, ls_dem_curr_code, ls_value, ls_coltype
long ll_fixed_exrate_enabled = 0
long ll_freight_type

/* these arrays are used to assist condition selection */
string ls_check_rateclaims[] = { "cal_carg_cal_carg_curr_code", &
									"cal_carg_cal_carg_exrate_usd", &
									"cal_carg_cal_carg_exrate_date", & 
									"cal_carg_freight_type", &
									"cal_carg_lumpsum_local_curr", &
									"cal_carg_bunker_escalation_local_curr", &
									"cal_carg_freight_rate_local_curr" }

string ls_check_claims[] = {"cal_carg_freight_type", &
									"cal_carg_ws_rate", &
									"cal_carg_local_flatrate", &
									"cal_carg_flatrate", &
									"cal_carg_lumpsum_local_curr", &
									"cal_carg_freight_rate_local_curr", & 
									"cal_carg_bunker_escalation_local_curr" }

string ls_check_exrate[] = {"cal_carg_cal_carg_curr_code", &
									"cal_carg_cal_carg_exrate_usd", & 
									"cal_carg_cal_carg_exrate_date", &
									"cal_carg_fixed_exrate_enabled", &
									"cal_carg_fixed_exrate", &
									"cal_carg_claim_curr" }
								
string ls_stop_editswithfreightclaims[] = {"cal_carg_cal_carg_curr_code",	&			
									"cal_carg_fixed_exrate_enabled", &
									"cal_carg_claim_curr", &
									COLUMN_SET_EX_RATE}

string ls_stop_editswithdemurrageclaims[] = {COLUMN_DEM_CURR_CODE,	&			
									"cal_carg_fixed_exrate_enabled", &
									"cal_carg_claim_curr", &
									COLUMN_SET_EX_RATE}

constant string ls_METHOD_NAME = "of_validatecargosummary()"

if isvalid(adwo) and not isnull(adwo) then
	ls_column = adwo.name
else
	ls_column = adw_summ.getcolumnname()
end if

ls_coltype = upper(left(adw_summ.describe(ls_column + ".coltype"),3))
ll_fixed_exrate_enabled = adw_summ.getitemnumber(al_row, COLUMN_FIXED_EXRATE_ENABLED)

if _validatecolumn(ls_column,ls_check_claims) then
	if _getsettledclaimcounts( li_settledfreight, li_settledother ) = c#return.Success then

		if li_settledfreight + li_settledother > 0 then
		
			_addmessage( this.classdefinition, ls_METHOD_NAME, "Validation Error!~r~n~r~nIt is not possible to change the rate, because there is at least  a settled claim against this calculation.~r~n~r~n" + &   
			string(li_settledfreight) + " Freight claim(s), " + string(li_settledother) + " other claim(s).~r~n~r~n" + & 
			+ "Please contact Finance department in order to modify the rate.~r~n~r~nSetting value back to original amount!", "User Message")

			if ls_coltype="DEC" then
				adw_summ.setitem(al_row, ls_column, adw_summ.getitemdecimal(al_row, ls_column, primary!, true) )
			else	
				adw_summ.setitem(al_row, ls_column, adw_summ.getitemnumber(al_row, ls_column, primary!, true) )	
			end if
			
			adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
			return 2
			
		end if
	end if
end if

/* not allow to change currency code/(un)fix exchange rate/change the claim currency code when there exists freight claims */
if _validatecolumn(ls_column,ls_stop_editswithfreightclaims) then
	if _checkclaimexists(CLAIM_TYPE_FREIGHT, CLAIMS_ANY_CURRENCY) = c#return.Failure then
		if ls_column = COLUMN_SET_EX_RATE then
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_EXRATE_FREIGHT_ASSOCIATED, "User Message")
		else
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_FREIGHT_ASSOCIATED, "User Message")
		end if
		adw_summ.setitem(al_row, ls_column, adw_summ.getitemstring(al_row, ls_column, primary!, true))
		adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
		return 2
	end if
	if ll_fixed_exrate_enabled = 1 then
		if _checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_ANY_CURRENCY) = c#return.Failure then
			if ls_column = COLUMN_SET_EX_RATE then
				_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_EXRATE_DEMURRAGE_ASSOCIATED, "User Message")
			else
				_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_DEMURRAGE_ASSOCIATED, "User Message")
			end if
			adw_summ.setitem(al_row, ls_column, adw_summ.getitemstring(al_row, ls_column, primary!, true))
			adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
			return 2
		end if
	end if
end if

/* not allow to change currency code/(un)fix exchange rate/change the claim currency code when there exists demurrage claims */
if _validatecolumn(ls_column,ls_stop_editswithdemurrageclaims) then
	if _checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_ANY_CURRENCY) = c#return.Failure then
		if ls_column = COLUMN_SET_EX_RATE then
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_EXRATE_DEMURRAGE_ASSOCIATED, "User Message")
		else
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_DEMURRAGE_ASSOCIATED, "User Message")
		end if
		adw_summ.setitem(al_row, ls_column, adw_summ.getitemstring(al_row, ls_column, primary!, true))
		adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
		return 2
	end if
end if

// This is a loose end
// DEM currency should always follow FRT currency, if possible
if ls_column = COLUMN_LOCAL_CURR_CODE then
	if _checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_NON_USD) = c#return.Failure then
		_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_NONUSD_DEMURRAGE_ASSOCIATED, "User Message")
		adw_summ.setitem(al_row, ls_column, adw_summ.getitemstring(al_row, ls_column, primary!, true))
		adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
		return 2
	end if
end if

// Freight and Demurrage currencies should only be allowed to be changed if there are no claims associated.
if ls_column = COLUMN_FREIGHT_TYPE then
	if long (as_data) = FREIGHT_TYPE_WS then
		if _checkclaimexists(CLAIM_TYPE_FREIGHT, CLAIMS_NON_USD) = c#return.Failure then
			ll_freight_type = adw_summ.getitemnumber(al_row, ls_column, primary!, true)
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_WS_FREIGHT_ASSOCIATED, "User Message")
			adw_summ.setitem(al_row, ls_column, ll_freight_type)
			adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
			return 2
		end if
		if _checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_NON_USD) = c#return.Failure then
			ll_freight_type = adw_summ.getitemnumber(al_row, ls_column, primary!, true)
			_addmessage( this.classdefinition, ls_METHOD_NAME, MESSAGE_WS_DEMURRAGE_ASSOCIATED, "User Message")
			adw_summ.setitem(al_row, ls_column, ll_freight_type)
			adw_summ.setitemstatus(al_row, ls_column, Primary!, NotModified!)
			return 2
		end if
	end if
end if

adw_summ.accepttext()

if IsValid(adwo) and not IsNull(adwo) then
	if adwo.name = COLUMN_LOCAL_CURR_CODE then 
		ls_local_curr_code = as_data
	else
		ls_local_curr_code = adw_summ.getItemString(al_row, COLUMN_LOCAL_CURR_CODE)
	end if
	
	if adwo.name = COLUMN_DEM_CURR_CODE then
		ls_dem_curr_code = as_data
	else
		ls_dem_curr_code = adw_summ.getItemString(al_row, COLUMN_DEM_CURR_CODE)
	end if
end if

/* main business logic */
setnull(ld_value)
setnull(ll_value)
setnull(ldt_null)

CHOOSE CASE ls_column
	CASE "cal_carg_fixed_exrate_enabled"
		if as_data = "1" then
			adw_summ.SetItem(al_row, "cal_carg_fixed_exrate",ld_value)
			adw_summ.SetItem(al_row, "cal_carg_claim_curr",ls_value)
		end if
	
	CASE COLUMN_LOCAL_CURR_CODE
		if isnull(adw_summ.getitemdate(al_row,COLUMN_LOCAL_EXRATE_DATE)) then 
			adw_summ.setitem(al_row,COLUMN_LOCAL_EXRATE_DATE,today())
		end if
		ld_exrate = lnv_exchangerate.of_getexchangerate(ls_local_curr_code, "USD", date(adw_summ.getitemdate(al_row, COLUMN_LOCAL_EXRATE_DATE))) 
		if ld_exrate > 0 then 
			adw_summ.SetItem(al_row, COLUMN_LOCAL_EXRATE_USD,ld_exrate)
		else 
			_addmessage( this.classdefinition, ls_METHOD_NAME, "Validation Error, Exchange rate was not found for the given date, please try again.", "User Message")						
			return 0
		end if
		
		// When user changes “Freight Curr” and “Ex Rate to USD” (amount and/or date), 
		// the same changes should be applied to the demurrage side when possible.
		if not (_checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_ANY_CURRENCY) = c#return.Failure) then
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_DATE, adw_summ.getitemdate(al_row, COLUMN_LOCAL_EXRATE_DATE))
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, adw_summ.getitemnumber(al_row, COLUMN_LOCAL_EXRATE_USD))
			adw_summ.SetItem(al_row, COLUMN_DEM_CURR_CODE, as_data)
			ls_dem_curr_code = as_data
		end if
		
		_updatedemusd(adw_summ.getitemnumber(al_row, COLUMN_DEM_EXRATE_USD))
		
		uf_refresh_demurrage_currency(as_data)
		
		// Clear the Set Ex Rate flag if both currency codes are USD
		if ls_local_curr_code = 'USD' and ls_dem_curr_code = 'USD' then
			adw_summ.SetItem(al_row, COLUMN_SET_EX_RATE, 0)
		end if
	CASE COLUMN_DEM_CURR_CODE
		if ls_local_curr_code = ls_dem_curr_code and ls_dem_curr_code <> 'USD' then
			ld_exrate = adw_summ.getitemnumber(al_row, COLUMN_LOCAL_EXRATE_USD)
			adw_summ.setitem(al_row, COLUMN_DEM_EXRATE_DATE, adw_summ.getitemdate(al_row, COLUMN_LOCAL_EXRATE_DATE))
		else
			if isnull(adw_summ.getitemdate(al_row, COLUMN_DEM_EXRATE_DATE)) then 
				adw_summ.setitem(al_row, COLUMN_DEM_EXRATE_DATE, today())
			end if
			ld_exrate = lnv_exchangerate.of_getexchangerate(ls_dem_curr_code, "USD", date(adw_summ.getitemdate(al_row, COLUMN_DEM_EXRATE_DATE)))
		end if
		if ld_exrate > 0 then 
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, ld_exrate)
		else 
			_addmessage( this.classdefinition, ls_METHOD_NAME, "Validation Error, Exchange rate was not found for the given date, please try again.", "User Message")						
			return 0
		end if
		
		_updatedemusd(ld_exrate)
		
		// Clear the Set Ex Rate flag if both currency codes are USD
		if ls_local_curr_code = 'USD' and ls_dem_curr_code = 'USD' then
			adw_summ.SetItem(al_row, COLUMN_SET_EX_RATE, 0)
		end if
	CASE COLUMN_LOCAL_EXRATE_USD
		adw_summ.setitem(al_row, COLUMN_LOCAL_EXRATE_DATE,  ldt_null)
		
		// When user changes “Freight Curr” and “Ex Rate to USD” (amount and/or date), 
		// the same changes should be applied to the demurrage side when possible.
		if adw_summ.getitemstring(al_row, COLUMN_LOCAL_CURR_CODE) = adw_summ.getitemstring(al_row, COLUMN_DEM_CURR_CODE) then
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_DATE, adw_summ.getitemdate(al_row, COLUMN_LOCAL_EXRATE_DATE))
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, dec(as_data))
		end if
		
		_updatedemusd(adw_summ.getitemnumber(al_row, COLUMN_DEM_EXRATE_USD))
		
	CASE COLUMN_DEM_EXRATE_USD
		adw_summ.setitem(al_row, COLUMN_DEM_EXRATE_DATE,  ldt_null)
		
		_updatedemusd(dec(as_data))

   CASE COLUMN_LOCAL_EXRATE_DATE
		if not (isnull(as_data) or len(as_data) = 0) then
			ldt_exrate_date = date(as_data)
			ld_exrate = lnv_exchangerate.of_getexchangerate(ls_local_curr_code, "USD", ldt_exrate_date) 
			if ld_exrate > 0 then 
				adw_summ.SetItem(al_row, COLUMN_LOCAL_EXRATE_USD, ld_exrate)
			else 
				messagebox("Validation Error","Exchange rate is not found for the given date, please try again.")
				return 0
			end if
		else
			messagebox("Validation Error","Date input is wrong, please try again.")
			return 0
		end if
      
		// When user changes “Freight Curr” and “Ex Rate to USD” (amount and/or date), 
		// the same changes should be applied to the demurrage side when possible.
		if adw_summ.getitemstring(al_row, COLUMN_LOCAL_CURR_CODE) = adw_summ.getitemstring(al_row, COLUMN_DEM_CURR_CODE) then
			if not (_checkclaimexists(CLAIM_TYPE_DEMURRAGE, CLAIMS_ANY_CURRENCY) = c#return.Failure) then		
				adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_DATE, ldt_exrate_date)
				adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, adw_summ.getitemnumber(al_row, COLUMN_LOCAL_EXRATE_USD))
			end if
		end if
		
		_updatedemusd(adw_summ.getitemnumber(al_row, COLUMN_DEM_EXRATE_USD))
		
	CASE COLUMN_DEM_EXRATE_DATE
		if not (isnull(as_data) or len(as_data) = 0) then 
			ldt_exrate_date = date(as_data)
			ld_exrate = lnv_exchangerate.of_getexchangerate(ls_dem_curr_code, "USD", ldt_exrate_date) 
			if ld_exrate > 0 then
				adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, ld_exrate)
			else
				messagebox("Validation Error","Exchange rate is not found for the given date, please try again.")
				return 0
			end if
		else
			messagebox("Validation Error","Date input is wrong, please try again.")
			return 0
		end if
		
		_updatedemusd(ld_exrate)
		
	CASE "cal_carg_description"
		// Cargo description has been changed, update system
		uf_description_changed()
		
	CASE "cal_carg_freight_type"
		// Freight type has been changed, now clear overage 1+2 and min 1+2
		adw_summ.SetItem(al_row, "cal_carg_overage_1",0)
		adw_summ.SetItem(al_row, "cal_carg_overage_2",0)
		adw_summ.SetItem(al_row, "cal_carg_min_1",0)
		adw_summ.SetItem(al_row, "cal_carg_min_2",0)
		
		//WS rate is always in USD
		if adw_summ.getitemnumber(al_row,"cal_carg_freight_type") = 4 then
			adw_summ.SetItem(al_row, "cal_carg_cal_carg_curr_code","USD")
			adw_summ.SetItem(al_row, "cal_carg_cal_carg_exrate_usd",100)
			adw_summ.setitem(al_row, "cal_carg_cal_carg_exrate_date",  ldt_null)	
			
			adw_summ.SetItem(al_row, COLUMN_DEM_CURR_CODE, "USD")
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_USD, 100)
			adw_summ.SetItem(al_row, COLUMN_DEM_EXRATE_DATE, ldt_null)
			
			// Clear the Set Ex Rate flag
			adw_summ.SetItem(al_row, COLUMN_SET_EX_RATE, 0)
		end if
		
	CASE "cal_carg_cal_carg_reversible"
		/* not refactored */
		// Reversible demurrage has been set on or off. Do the accepttext on load & dischports.
		dw_loadports.accepttext()
		dw_dischports.accepttext()
		ll_tmp = integer(adw_summ.gettext())
		if ll_tmp = 1 Then
			// Reversible demurrage has been choosen. Copy contents to load and and discports
			// from first loadport
			If MessageBox("Warning", "Setting reversible will copy the contents of all load" + &
				" and discharge ports~r~n~r~nContinue ?", Exclamation!, YesNo!) <> 1 & 
				Then ll_tmp = -1
		else 
			// Reversible demurrage has been unselected. Clear content of load and dischports
			li_messagebox = MessageBox("Information", "Contents of load and discharports" + &
				" will be cleared~r~n~r~nContinue ?", Exclamation!, YesNo!,2)
			// User choose no to proceed so return
			if li_messagebox = 2 Then
				ll_cargo_row = dw_cargo_summary.Getrow()
				dw_cargo_summary.SetItem(ll_cargo_row,"cal_carg_cal_carg_reversible",1)
				return 2
			end if
		end if

		// Copy cargo between load and dischports
		if ll_tmp <> -1 Then 	
			// ll_tmp = 1 = Copy, 2 = Clear
			// Copy all information from first loadport to all loadports / clear if ll_tmp = 2
			
			uf_reversible(ll_tmp, dw_loadports, 0, li_dummy, ld_dummy, ld_dummy, li_dummy)
			if ll_tmp = 1 then
				// Copy information from first loadport to first dischport
				li_first_load = uf_get_first_loadport()
				dw_dischports.SetItem(1, COLUMN_DESPATCH_LOCAL_CURR, dw_loadports.GetItemNumber(li_first_load, COLUMN_DESPATCH_LOCAL_CURR))
				dw_dischports.SetItem(1, COLUMN_DEMURRAGE_LOCAL_CURR, dw_loadports.GetItemNumber(li_first_load, COLUMN_DEMURRAGE_LOCAL_CURR))
				dw_dischports.SetItem(1, COLUMN_DESPATCH_DEM_CURR, dw_loadports.GetItemNumber(li_first_load, COLUMN_DESPATCH_DEM_CURR))
				dw_dischports.SetItem(1, COLUMN_DEMURRAGE_DEM_CURR, dw_loadports.GetItemNumber(li_first_load, COLUMN_DEMURRAGE_DEM_CURR))
			end if

			// Same for dischports
			uf_reversible(ll_tmp, dw_dischports, 0, li_dummy, ld_dummy, ld_dummy, li_dummy)
		end if
		if ll_tmp = -1 then return 2
		
	CASE ELSE
		
		/* not fully refactored */
		if ii_reversible_freight[al_row] = 1 then
			/* If this is a reversible freight cargo, and one of the freight fields have been changed, then copy information to all other reversible freights. */

			CHOOSE CASE ls_coltype
				CASE "INT"
					ll_value = long(adw_summ.GetText())
				CASE "DEC"
					ld_value = dec(adw_summ.GetText())
				CASE ELSE
					// Do Nothing
			END CHOOSE

			if not(isnull(ll_value)) or not(isnull(ld_value)) Then
				ll_cerp_id = dw_cargo_summary.GetItemNumber(al_row, "cal_carg_cal_cerp_id")
				dw_cargo_summary.uf_redraw_off()
				/* insert into the same column on cargoes with identical CP id */
				for ll_count = 1 To ii_no_cargos
					if ll_cerp_id = dw_cargo_summary.getitemnumber(ll_count, "cal_carg_cal_cerp_id") then
						if isnull(ll_value) then
							dw_cargo_summary.SetItem(ll_count, ls_column, ld_value)
						else
							dw_cargo_summary.SetItem(ll_count, ls_column, ll_value)
						end if
					end if
				next
				dw_cargo_summary.uf_redraw_on()
			end if			
		end if
		
END CHOOSE

/* recalculate freight rate in USD when rates/currency code related fields have been changed */
if _validatecolumn(ls_column,ls_check_rateclaims) then
	CHOOSE CASE adw_summ.getitemnumber(al_row,"cal_carg_freight_type")
		CASE 1  //mt
			adw_summ.setitem(al_row, "cal_carg_freight_rate", adw_summ.getitemdecimal(al_row, "cal_carg_freight_rate_local_curr") * adw_summ.GetItemNumber(al_row, "cal_carg_cal_carg_exrate_usd") / 100 )
			adw_summ.setitem(al_row, "bunker_escalation", adw_summ.getitemdecimal(al_row, "cal_carg_bunker_escalation_local_curr") *  adw_summ.GetItemNumber(al_row, "cal_carg_cal_carg_exrate_usd") / 100 )
		CASE 2 //cbm
			adw_summ.setitem(al_row, "cal_carg_freight_rate", adw_summ.getitemdecimal(al_row, "cal_carg_freight_rate_local_curr") *  adw_summ.GetItemNumber(al_row, "cal_carg_cal_carg_exrate_usd") / 100 )
		CASE 3 //lumpsum
			adw_summ.setitem(al_row, "cal_carg_lumpsum", adw_summ.getitemdecimal(al_row, "cal_carg_lumpsum_local_curr") * adw_summ.GetItemNumber(al_row, "cal_carg_cal_carg_exrate_usd") / 100 )
	END CHOOSE
end if		

if _validatecolumn(ls_column,ls_check_exrate) or _validatecolumn(ls_column,ls_check_claims) then
	adw_summ.SetItemStatus(al_row, ls_column,  Primary!, DataModified!)
end if

/* as we have on-the-fly validation the update flags do not adjust until we get here */
parent.TriggerEvent("ue_childmodified")

return 0
end function

public function integer uf_refresh_demurrage_currency (string as_local_curr);datawindowchild ldwc_dem
string ls_dem_curr[]

if IsNull(as_local_curr) then
	as_local_curr = dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE)
end if

ls_dem_curr[1] = as_local_curr
ls_dem_curr[2] = "USD"

if dw_cargo_summary.GetChild(COLUMN_DEM_CURR_CODE, ldwc_dem) = 1 then
	ldwc_dem.SetTransObject(SQLCA)
	ldwc_dem.Retrieve(ls_dem_curr)
	return 1
end if

return -1

end function

public function integer uf_clearfixedexrate ();/********************************************************************
   uf_clearfixedexrate
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/05/16 CR2428        SSX014   First Version
   </HISTORY>
********************************************************************/

Long ll_rows, ll_count

// Loop through all cargo summary and clear the flag
ll_rows = dw_cargo_summary.RowCount()
For ll_count = 1 To ll_rows
	dw_cargo_summary.SetItem(ll_count, COLUMN_FIXED_EXRATE_ENABLED, 0)
Next

return 1

end function

public subroutine of_insertaddbuncons ();/********************************************************************
   of_insertaddbuncons
   <DESC> insert default addbuncons when new a cargo	</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Called by uf_insert_cargo	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12/07/16		CR4216          CCY018        First Version
	29/09/16		CR4516		   CCY018		Fixed a bug
	30/09/16		CR4515			XSZ004		Bunker value display empty when bunker value is null.
   </HISTORY>
********************************************************************/

long ll_vessel_type, ll_vessel_id, ll_clarkson_id, ll_cargo_id
long ll_row, ll_rowscount, ll_newrow, ll_cargo_row
integer li_default, li_order
decimal ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo
string ls_cal_description
mt_n_datastore lds_active

iuo_calc_nvo.iuo_calc_summary.uf_get_vessel(ll_vessel_type, ll_vessel_id, ll_clarkson_id)

if isnull(ll_vessel_id) or ll_vessel_id < 1 then return

lds_active = create mt_n_datastore
lds_active.dataobject = 'd_sq_gr_cal_addbuncons_active'
lds_active.settransobject( sqlca)
ll_rowscount = lds_active.retrieve(ll_vessel_id )

ll_cargo_row = dw_cargo_summary.getrow()
ll_cargo_id = dw_cargo_summary.getitemnumber(ll_cargo_row,"cal_carg_id")

If (ll_cargo_id = 0) or isnull(ll_cargo_id) then ll_cargo_id = -ll_cargo_row

for ll_row = 1 to ll_rowscount
	ls_cal_description = lds_active.getitemstring(ll_row, "cal_description")
	ld_hsfo = lds_active.getitemnumber(ll_row , "hsfo_value")
	ld_hsgo = lds_active.getitemnumber(ll_row , "hsgo_value")
	ld_lsgo = lds_active.getitemnumber(ll_row , "lsgo_value")
	ld_lsfo = lds_active.getitemnumber(ll_row , "lsfo_value")
	li_default = lds_active.getitemnumber(ll_row , "default_value")
	li_order = lds_active.getitemnumber(ll_row , "cal_order")
	
	ll_newrow = dw_addbuncons.insertrow(0)
	dw_addbuncons.setitem(ll_newrow, "cal_description", ls_cal_description)
	dw_addbuncons.setitem(ll_newrow, "cal_carg_id", ll_cargo_id)
	dw_addbuncons.setitem(ll_newrow, "cal_order", li_order)
	dw_addbuncons.setitem(ll_newrow, "cal_active", 1)
	dw_addbuncons.setitemstatus(ll_newrow, "cal_order", primary!, NotModified!)
	dw_addbuncons.setitemstatus(ll_newrow, "cal_active", primary!, NotModified!)
	
	if li_default = 1 then
		dw_addbuncons.setitem(ll_newrow, "hsfo_value", ld_hsfo)
		dw_addbuncons.setitem(ll_newrow, "hsgo_value", ld_hsgo)
		dw_addbuncons.setitem(ll_newrow, "lsgo_value", ld_lsgo)
		dw_addbuncons.setitem(ll_newrow, "lsfo_value", ld_lsfo)
	end if
next

dw_addbuncons.sort( )

if dw_addbuncons.rowcount( ) > 0 then
	if ll_cargo_row > 0 then
		dw_cargo_summary.setitem(ll_cargo_row, "cal_carg_add_fo", dw_addbuncons.getitemnumber(1, "total_hsfo"))
		dw_cargo_summary.setitem(ll_cargo_row, "cal_carg_add_do", dw_addbuncons.getitemnumber(1, "total_lsgo"))
		dw_cargo_summary.setitem(ll_cargo_row, "cal_carg_add_mgo", dw_addbuncons.getitemnumber(1, "total_hsgo"))
		dw_cargo_summary.setitem(ll_cargo_row, "cal_carg_add_lsfo", dw_addbuncons.getitemnumber(1, "total_lsfo"))
	end if
end if

destroy lds_active
end subroutine

public function integer of_checkaddbuncons ();/********************************************************************
   of_checkaddbuncons
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, 1 ok
            <LI> c#return.Failure, -1 failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/07/16		CR4216         CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_vessel_type, ll_vessel_id, ll_clarkson_id
long ll_row, ll_rowcount, ll_findrow
dec{3} ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo
string ls_cal_description
mt_n_datastore lds_active

iuo_calc_nvo.iuo_calc_summary.uf_get_vessel(ll_vessel_type, ll_vessel_id, ll_clarkson_id)
lds_active = create mt_n_datastore
lds_active.dataobject = 'd_sq_gr_cal_addbuncons_active'
lds_active.settransobject( sqlca)
ll_rowcount = lds_active.retrieve(ll_vessel_id)

for ll_row = 1 to dw_addbuncons.rowcount( )
	ls_cal_description = dw_addbuncons.getitemstring(ll_row, "cal_description")
	ld_hsfo = dw_addbuncons.getitemnumber(ll_row, "hsfo_value")
	ld_hsgo = dw_addbuncons.getitemnumber(ll_row, "hsgo_value")
	ld_lsgo = dw_addbuncons.getitemnumber(ll_row, "lsgo_value")
	ld_lsfo = dw_addbuncons.getitemnumber(ll_row, "lsfo_value")
	if isnull(ld_hsfo) then ld_hsfo = 0
	if isnull(ld_hsgo) then ld_hsgo = 0
	if isnull(ld_lsgo) then ld_lsgo = 0
	if isnull(ld_lsfo) then ld_lsfo = 0

	ll_findrow = lds_active.find("cal_description = '" + ls_cal_description + "'", 1, ll_rowcount)
	if ll_findrow = 0 and (ld_hsfo <> 0 or ld_hsgo <> 0 or ld_lsgo <> 0 or ld_lsfo <> 0) then 	
		destroy lds_active
		return c#return.Failure
	end if
next

destroy lds_active

return c#return.Success
end function

private function integer _checkclaimexists (string as_claim_type, integer al_option);/********************************************************************
   FunctionName: _checkfrtdemexists
   <DESC>	This function checks if there are any frt/dem Claims connected to Calculation
				If so the user is not allowed to change the currency code. 
  </DESC>
   <RETURN>	Integer:
					c#return.NoAction: no claims 
					c#return.Failure :there is frt or dem claims connected
  </RETURN>
  <ACCESS> Private	</ACCESS>
   <ARGS>	None	</ARGS>
   <USAGE>	Calling from 
				dw_cargo_summary.itemchanged()
    </USAGE>
12/04/2016   CR2428  SSX014  Check if the specific claim exists
********************************************************************/
long		ll_cal_calc_id, ll_cal_fix_id, ll_cal_est_id, ll_voyrows, ll_voyrow, ll_claimrows, ll_claimrow, ll_vessel, ll_chart_nr 
integer	li_cal_calc_status, li_exist
n_ds		lds_voyages
string	ls_voyage

//get the current cal_calc_id
ll_cal_calc_id = dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_calc_id")
ll_chart_nr = dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_cerp_chart_nr")

//see the calculation type
SELECT CAL_CALC_STATUS
INTO :li_cal_calc_status
FROM CAL_CALC
WHERE CAL_CALC_ID = :ll_cal_calc_id;
 
//get estimated calculation id
IF li_cal_calc_status = 5 THEN//not estimated
	SELECT CAL_CALC_FIX_ID
	INTO :ll_cal_fix_id
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_cal_calc_id;

	SELECT CAL_CALC_ID
	INTO :ll_cal_est_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_cal_fix_id
	AND CAL_CALC_STATUS = 6;

ELSE//estimated
	ll_cal_est_id = ll_cal_calc_id
END IF

if isnull(ll_cal_est_id) then return c#return.NoAction

//get voyage number
lds_voyages = create n_ds
lds_voyages.dataObject = "d_sq_tb_voyages_by_calc"
lds_voyages.setTransObject(SQLCA)
lds_voyages.retrieve(ll_cal_est_id)
ll_voyrows = lds_voyages.rowCount()

//check frt/dem claims connected
if ll_voyrows > 0 then
	for ll_voyrow = 1 to ll_voyrows
		ll_vessel = lds_voyages.getItemNumber(ll_voyrow, "vessel_nr")
		ls_voyage = lds_voyages.getItemString(ll_voyrow, "voyage_nr")
		IF al_option = CLAIMS_ANY_CURRENCY then
			SELECT COUNT(*)
			INTO :li_exist
			FROM CLAIMS
			WHERE (CLAIM_TYPE = :as_claim_type)
			AND VESSEL_NR = :ll_vessel
			AND VOYAGE_NR = :ls_voyage
			AND CHART_NR = :ll_chart_nr;
		ELSEIF al_option = CLAIMS_NON_USD THEN
			SELECT COUNT(*)
			INTO :li_exist
			FROM CLAIMS
			WHERE (CLAIM_TYPE = :as_claim_type)
			AND VESSEL_NR = :ll_vessel
			AND VOYAGE_NR = :ls_voyage
			AND CHART_NR = :ll_chart_nr
			AND CURR_CODE <> 'USD';
		END IF
		if li_exist > 0 then
			return c#return.Failure
		end if
	next	
end if

destroy lds_voyages
return c#return.NoAction


end function

public function integer of_get_voyage_alert_status (string as_port_code);/********************************************************************
   of_get_voyage_alert_status
   <DESC>	</DESC>
   <RETURN>	integer
          </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_port_code
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_count

if isnull(as_port_code) or trim(as_port_code, true) = "" then return 0

SELECT COUNT(1) INTO :ll_count
FROM PORTS, VOYAGE_ALERTS
WHERE (PORTS.PORT_CODE = VOYAGE_ALERTS.PORT_CODE OR PORTS.COUNTRY_ID = VOYAGE_ALERTS.COUNTRY_ID)
AND PORTS.PORT_CODE = :as_port_code;

if ll_count > 0 then 
	return 1
else
	return 0
end if



end function

public subroutine of_show_voyage_alert (string as_port_code, integer ai_xpos, integer ai_ypos);/********************************************************************
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
long ll_xpos, ll_ypos, ll_tabheight, ll_tabwidth, ll_boxw, ll_boxh

ll_xpos = ai_xpos
ll_ypos = ai_ypos

dw_voyage_alert.reset()
if dw_voyage_alert.retrieve(as_port_code) < 1 then
	dw_voyage_alert.visible = false
	return
end if

ll_dwheight = 84
ll_tabheight = this.height - 160
ll_tabwidth = this.width

//set dw height
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

ll_boxw = dw_voyage_alert.width
ll_boxh = dw_voyage_alert.height

ll_xpos = ll_xpos - 200
if ll_xpos < 0 then ll_xpos = 0
if ll_xpos + ll_boxw > ll_tabwidth then ll_xpos = ll_tabwidth - ll_boxw
if ll_ypos + ll_boxh > ll_tabheight then ll_ypos = ll_ypos - ll_boxh
if ll_ypos < 0 then ll_ypos = 0

dw_voyage_alert.x = ll_xpos
dw_voyage_alert.y = ll_ypos
dw_voyage_alert.width = 2322
dw_voyage_alert.visible = true

dw_voyage_alert.setfocus()

end subroutine

public subroutine of_set_cargo_alert_status ();/********************************************************************
   of_set_cargo_alert_status
   <DESC>		</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_alert
long ll_row
string ls_port_code

for ll_row = 1 to dw_loadports.rowcount()
	ls_port_code = dw_loadports.getitemstring(ll_row, "port_code")
	li_alert = of_get_voyage_alert_status(ls_port_code)
	
	dw_loadports.setitem(ll_row, "voyage_alert", li_alert)
	dw_loadports.setitemstatus(ll_row, "voyage_alert", primary!, notmodified!)
next

for ll_row = 1 to dw_dischports.rowcount()
	ls_port_code = dw_dischports.getitemstring(ll_row, "port_code")
	li_alert = of_get_voyage_alert_status(ls_port_code)
	
	dw_dischports.setitem(ll_row, "voyage_alert", li_alert)
	dw_dischports.setitemstatus(ll_row, "voyage_alert", primary!, notmodified!)
next
end subroutine

public function boolean of_check_intrimport_laytime ();/********************************************************************
  of_check_intrimport_laytime
   <DESC>	check laytime where port is a intrim port 	</DESC>
   <RETURN>	boolean </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	call by uf_process()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/08/17		CR4221	HHX010	Interim Port
		20/11/17		CR4221	HHX010	Change the message text
   </HISTORY>
********************************************************************/
long ll_cal_calc_id, ll_rowcount, li_return, li_status
string ls_errtext, ls_text

ls_text =  'Confirm Interim Port selection'
ls_errtext ="You have marked a port as interim port. The entered C/P Laytime and Act Laytime will be lost and broker commission will be recalculated. Please notify the Demurrage Analyst.~r~n~r~nDo you want to continue?"
ib_deletelaytime = true

//get the current cal_calc_id
ll_cal_calc_id = dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_calc_id")

li_status =iuo_calc_nvo.iuo_calc_summary.uf_get_status( )
if li_status <> 6 then
	SELECT CAL_CALC_ID INTO :ll_cal_calc_id 
	FROM CAL_CALC
	WHERE CAL_CALC_STATUS = 6 
	AND  CAL_CALC_FIX_ID IN ( SELECT CAL_CALC_FIX_ID FROM CAL_CALC WHERE CAL_CALC_ID = :ll_cal_calc_id );
	if isnull(ll_cal_calc_id) then return ib_deletelaytime
end if

ids_check_laytime.retrieve(ll_cal_calc_id)

ll_rowcount = ids_check_laytime.rowcount()

if ll_rowcount > 0 then	
	li_return = messagebox(ls_text, ls_errtext, Exclamation!, YesNo!, 2)
	if li_return = 1 then 
		ib_deletelaytime = true
	else
		ib_deletelaytime = false
	end if	
end if

return ib_deletelaytime
end function

public subroutine of_delete_interimport_laytime (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn);/********************************************************************
   of_delete_interimport_laytime
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		al_vessel_nr,
		as_voyage_nr,
		as_port_code,
		ai_pcn
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/08/17 CR4221          HHX010        First Version
   </HISTORY>
********************************************************************/
long ll_i
integer li_chart_nr, li_claim_nr
n_calc_demurrage lnv_calc_demurrage
mt_n_datastore lds_temp

lds_temp = create mt_n_datastore
lds_temp.dataobject = 'd_sq_gr_laytime_statements'
lds_temp.settransobject(sqlca)
lds_temp.retrieve(al_vessel_nr,as_voyage_nr,as_port_code,ai_pcn)
 
/* Group deduction */
DELETE FROM GROUP_DEDUCTIONS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
/* Laytime deduction */
DELETE FROM LAY_DEDUCTIONS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
/* Laytime Statements */
DELETE FROM LAYTIME_STATEMENTS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
 
for ll_i = 1 to lds_temp.rowcount()
	li_chart_nr = lds_temp.object.chart_nr[ll_i]
	SELECT CLAIM_NR  INTO :li_claim_nr 
	FROM DEM_DES_CLAIMS 
	WHERE VESSEL_NR = :al_vessel_nr  AND 
			 VOYAGE_NR = :as_voyage_nr AND 
			 CHART_NR = :li_chart_nr; 	 
	lnv_calc_demurrage.of_recalc_demurrage(al_vessel_nr, as_voyage_nr, as_port_code, li_chart_nr, li_claim_nr)  
next

destroy lds_temp  
end subroutine

public function boolean of_isallowed_interim (datawindow adw_cargo, readonly long al_row, string as_data, string as_purpose_code);long ll_count, ll_i, ll_rowcount
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
		20/11/17		CR4221	HHX010	Change message text
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

event destructor;call super::destructor;// Destructor event, destroys the search objects

DESTROY iuo_dddw_search_load
DESTROY iuo_dddw_search_disch
DESTROY ids_original_est_caio
DESTROY ids_check_laytime

end event

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
DATE		   CR-Ref 	 NAME	    DESCRIPTION
-------- 	------    ----- 	 -------------------------------------
06/05/2014	CR3635    LHG008   Itinerary ID issue
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

ids_original_est_caio = create mt_n_datastore
ids_original_est_caio.dataobject = 'd_sq_gr_original_est_caio'
ids_original_est_caio.settransobject(sqlca)

ids_check_laytime = create mt_n_datastore
ids_check_laytime.dataobject = 'd_sq_gr_interimport_laytime'
ids_check_laytime.settransobject(sqlca)
end event

on u_atobviac_calc_cargos.create
int iCurrent
call super::create
this.dw_voyage_alert=create dw_voyage_alert
this.dw_addbuncons=create dw_addbuncons
this.st_1=create st_1
this.dw_calc_misc_claim=create dw_calc_misc_claim
this.dw_calc_port_expenses=create dw_calc_port_expenses
this.dw_calc_hea_dev_claim=create dw_calc_hea_dev_claim
this.dw_loadports=create dw_loadports
this.dw_dischports=create dw_dischports
this.dw_calc_lumpsum=create dw_calc_lumpsum
this.gb_1=create gb_1
this.r_1=create r_1
this.st_2=create st_2
this.dw_cargo_summary=create dw_cargo_summary
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_voyage_alert
this.Control[iCurrent+2]=this.dw_addbuncons
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_calc_misc_claim
this.Control[iCurrent+5]=this.dw_calc_port_expenses
this.Control[iCurrent+6]=this.dw_calc_hea_dev_claim
this.Control[iCurrent+7]=this.dw_loadports
this.Control[iCurrent+8]=this.dw_dischports
this.Control[iCurrent+9]=this.dw_calc_lumpsum
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.r_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.dw_cargo_summary
this.Control[iCurrent+14]=this.cb_1
end on

on u_atobviac_calc_cargos.destroy
call super::destroy
destroy(this.dw_voyage_alert)
destroy(this.dw_addbuncons)
destroy(this.st_1)
destroy(this.dw_calc_misc_claim)
destroy(this.dw_calc_port_expenses)
destroy(this.dw_calc_hea_dev_claim)
destroy(this.dw_loadports)
destroy(this.dw_dischports)
destroy(this.dw_calc_lumpsum)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.st_2)
destroy(this.dw_cargo_summary)
destroy(this.cb_1)
end on

type dw_voyage_alert from u_popupdw within u_atobviac_calc_cargos
integer x = 1061
integer y = 1324
integer width = 2322
integer taborder = 50
string dataobject = "d_sq_ff_voyage_alert_calc"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
boolean ib_autoclose = false
end type

event clicked;this.visible = false
end event

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type dw_addbuncons from u_datawindow_sqlca within u_atobviac_calc_cargos
boolean visible = false
integer x = 2917
integer y = 2052
integer width = 183
integer height = 144
integer taborder = 60
string dataobject = "d_sq_gr_cal_addbuncons"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(8, dw_addbuncons, sqlsyntax)
end event

type st_1 from statictext within u_atobviac_calc_cargos
integer x = 3721
integer y = 472
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Charterer"
boolean focusrectangle = false
end type

type dw_calc_misc_claim from u_datawindow_sqlca within u_atobviac_calc_cargos
boolean visible = false
integer x = 594
integer y = 1760
string dataobject = "d_calc_misc_claim"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(6,dw_calc_misc_claim,sqlsyntax)
end event

type dw_calc_port_expenses from u_datawindow_sqlca within u_atobviac_calc_cargos
boolean visible = false
integer x = 3758
integer y = 2052
integer width = 183
integer height = 144
string dataobject = "d_calc_port_expenses"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(4,dw_calc_port_expenses,sqlsyntax)
end event

type dw_calc_hea_dev_claim from u_datawindow_sqlca within u_atobviac_calc_cargos
boolean visible = false
integer x = 96
integer y = 1756
string dataobject = "d_calc_hea_dev_claim"
end type

event sqlpreview;call super::sqlpreview;uf_change_sql(5,dw_calc_hea_dev_claim,sqlsyntax)
end event

type dw_loadports from u_datawindow_sqlca within u_atobviac_calc_cargos
event ue_recalc_exp pbm_custom68
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
event ue_lbuttondown pbm_lbuttondown
event ue_filterconsdddw ( long al_currentrow,  boolean ab_reset )
integer x = 59
integer y = 1068
integer width = 4453
integer height = 488
integer taborder = 40
string dataobject = "d_calc_cargo_in"
boolean vscrollbar = true
boolean border = false
boolean ib_editmaskselect = true
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

event ue_lbuttondown;if inv_grid_loadports.of_stop_column_resize(flags, xpos, ypos) = c#return.Success then
 inv_grid_loadports.of_setcolumnorder()	
 message.processed = TRUE
 return 1
end if
end event

event ue_filterconsdddw(long al_currentrow, boolean ab_reset);/********************************************************************
   ue_filterconsdddw
   <DESC>	Description	</DESC>
   <RETURN>	
		long:
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_currentrow:
		ab_reset:
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		04-10-2013	CR2658	LHG008	First Version
   </HISTORY>
********************************************************************/

string ls_purpose_code, ls_typelist

if al_currentrow <= 0 or isnull(al_currentrow) then return

ls_purpose_code = this.getitemstring(al_currentrow, "purpose_code")
choose case ls_purpose_code
	case "L"
		ls_typelist = "3,4,8"  //At Port - Load
	case "D"
		ls_typelist = "6,4,8"  //At Port - Discharge
	case "WD"
		ls_typelist = "7,8,4"  //At Port - Idle, Heating
	case else
		ls_typelist = "4,8"  //At Port - General
end choose
iuo_calc_nvo.of_getconsdropdown(this, "port_cons_id_all", ls_typelist, ab_reset,true,al_currentrow)
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
DATE			VERSION				NAME		DESCRIPTION
11-11-2013	CR2658UAT			WWG004	When reversible, contype reversible
23-01-2014	CR2658V27043UAT	WWG004	When reversible, contype not reversible.
14/01/16  	CR3248         	LHG008	ECA zone implementation
20/04/16    CR2428            SSX014   Update demurrage/despatch rate in USD and local currency
22/08/17		CR4221			HHX010   Interim port
20/11/17		CR4221			HHX010	 Add a warning message
****************************************************************************/

long		ll_found, ll_contypeid, ll_return
string	ls_portcode, ls_purpose
decimal  ld_null, ld_amount_usd, ld_local_exrate, ld_dem_exrate
integer li_voyage_alert

SetNull(ld_null)
if dwo.name='cal_caio_interim_port' then
   if of_isallowed_interim(this, row, data, "L") = false then return 2 
   if of_check_interimport_change(this, row, data) = C#Return.Failure then return 2	
end if

if dwo.name = "port_cons_id_all" then
	ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'consumption', this, data)
	if ll_return = C#Return.Failure then
		this.Post setcolumn("port_cons_id_all")
		return 2
	end if
end if
this.accepttext()

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "port_code"
			ll_found = w_share.dw_calc_port_dddw.find("port_code='"+data+"'", 1, 99999)
			/* Check if port is active */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "port_active") = 0 then
					Messagebox("Port code selection", "The selected portcode '"+data+"' is inactive. Please select another port.")
					this.POST setcolumn( "port_code" )
					Return 2
				end if
			end if
			/* Check if portcode OK */
			IF (len(data) <> 3) then
				Messagebox("Port code selection", "For loadport please select a portcode with length 3 characters")
				this.POST setcolumn( "port_code" )
				Return 2
			end if	
			/* Check if purpose is OK  - only if portcode = viapoint or canal */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "via_point") > 0 then
					ls_purpose = this.getItemString(row, "purpose_code")
					if ls_purpose = "L" or ls_purpose = "D" then
						Messagebox("Purpose Code Selection", "Purpose Code Load or Dischage not allowed for RoutingPoint")
						this.POST setcolumn( "port_code" )
						Return 2
					end if
				end if
			end if
			
			//Auto pre-select the consumption type
			ls_purpose	 = this.getItemString(row, "purpose_code")
			ll_contypeid = this.getItemnumber(row, "port_cons_id_all")
			if isnull(ll_contypeid) or string(ll_contypeid) = '' then
				of_preselect_contype(row, ls_purpose, dw_loadports, "port_cons_id_all")
			end if
			
			li_voyage_alert = of_get_voyage_alert_status(data)
			this.setitem(row, "voyage_alert", li_voyage_alert)
			this.setitemstatus(row, "voyage_alert", primary!, notmodified!)
		case "purpose_code"
			ls_portcode = this.getItemString(row, "port_code")
			ll_found = w_share.dw_calc_port_dddw.find("port_code= '" + ls_portcode + "'", 1, 99999)
			/* Check if purpose is OK  - only if portcode = viapoint or canal */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "via_point") > 0 then
					if data = "L" or ls_purpose = "D" then
						Messagebox("Purpose Code Selection", "Purpose Code Load or Dischage not allowed for RoutingPoint")
						this.POST setcolumn( "purpose_code" )
						Return 2
					end if
				end if
			end if
			
			if data <> 'L' then this.setitem(row, "cal_caio_interim_port", 0)
			
			of_preselect_contype(row, data, dw_loadports, "port_cons_id_all")
			
		case "cal_caio_number_of_units" 
			if dec(data) < 1 then
				MessageBox("Validation Error", "Quantity can't be 0 (zero) for Load ports")
				Return 1
			end if
		case COLUMN_DESPATCH_DEM_CURR
			ld_dem_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_DEM_EXRATE_USD)
			ld_amount_usd = dec(data) * ld_dem_exrate / 100
			this.setitem(row, COLUMN_DESPATCH_USD, ld_amount_usd )
			if dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
				dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
				this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, dec(data) )
			else
				ld_local_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
				if ld_local_exrate <> 0 then
					this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, ld_amount_usd / (ld_local_exrate / 100.0))
				else
					this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, ld_null)
				end if
			end if
			this.setcolumn(COLUMN_DESPATCH_USD)

		case COLUMN_DEMURRAGE_DEM_CURR
			ld_dem_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_DEM_EXRATE_USD)
			ld_amount_usd = dec(data) * ld_dem_exrate / 100.0
			this.setitem(row, COLUMN_DEMURRAGE_USD, ld_amount_usd)
			if dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
				dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
				this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, dec(data) )
			else
				ld_local_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
				if ld_local_exrate <> 0 then
					this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, ld_amount_usd / (ld_local_exrate / 100.0)  )
				else
					this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, ld_null)
				end if
			end if
			this.setcolumn(COLUMN_DEMURRAGE_USD)
		case 'cal_caio_interim_port'
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
				this.post setitem(row, COLUMN_DESPATCH_LOCAL_CURR, 0)
				this.post setitem(row, COLUMN_DEMURRAGE_USD, 0)
				this.post setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, 0)
				this.setitem(row, "cal_caio_total_port_expenses", this.object.cal_caio_total_port_expenses[row] - this.object.cal_caio_expenses[row])
			end if	
	end choose
end if

uf_loaddisch_itemchanged(dw_loadports, iuo_dddw_search_load)

iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_clear_cache()
end event

event clicked;call super::clicked;/********************************************************************
	<DESC>
		If the button on the window is clicked the misc. port expenses
		window is opened.
	</DESC>
	<RETURN>	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		01/05/97		?     		MI    		First version.
		02/09/14		CR3512		XSZ004		Fix a historical bug.
	</HISTORY>
********************************************************************/

String ls_object, ls_row_no
long   ll_found, ll_row_no, ll_position_no, ll_current_cargo

s_misc_expenses ls_misc_expenses

if dwo.name = "port_cons_id_all" or dwo.name = "port_cons_id" then
	if of_check_constype("Consumption Type Selection", dwo.name, this) = c#return.failure then
		return
	end if
end if

// Get the clicked object at the end of the pointer
ls_object = dw_loadports.GetObjectAtPointer()

// Determin what object has been clicked and what row it is
ll_found       = Pos(ls_object,"obj_button")
ll_position_no = Pos(ls_object,"~t")
ls_row_no      = Trim(Mid(ls_object, ll_position_no + 1))
ll_row_no      = long(ls_row_no)

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

setrow(row)

trigger event itemfocuschanged(row, dwo) 

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
DATE			VERSION 	NAME		DESCRIPTION
-----------------------------------------------------------------------------
04-09-2013	CR2658	LHG008	Add new filed port_cons_id, port_cons_id_all
****************************************************************************/
datawindowchild ldwc_cal_cons

/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
end if

//disable the resizable possibility for columns with icons
inv_grid_loadports.of_registerdatawindow(dw_loadports)

this.modify("port_cons_id.width = '0~tlong(describe(~"port_cons_id_all.width~"))' port_cons_id.x = '0~tlong(describe(~"port_cons_id_all.x~"))'")
this.modify("datawindow.processing = '0' port_cons_id.visible = '1~tif(currentRow() = getrow(), 0, 1)' datawindow.processing = '1'")

if this.getchild("port_cons_id_all", ldwc_cal_cons) = 1 then
	ldwc_cal_cons.modify("cal_cons_sss.visible = '0' cal_cons_meco.visible = '0' cal_cons_speed.visible = '0'")
end if

end event

event itemerror;call super::itemerror;return 1
end event

event rowfocuschanged;call super::rowfocuschanged;event ue_filterconsdddw(currentrow, false)
end event

event rbuttondown;call super::rbuttondown;integer li_x, li_y
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

type dw_dischports from u_datawindow_sqlca within u_atobviac_calc_cargos
event ue_keydown pbm_dwnkey
event ue_check_cqd pbm_custom69
event ue_lbuttondown pbm_lbuttondown
event ue_filterconsdddw ( long al_currentrow,  boolean ab_reset )
integer x = 59
integer y = 1592
integer width = 4453
integer height = 488
integer taborder = 50
string dataobject = "d_calc_cargo_out"
boolean vscrollbar = true
boolean border = false
boolean ib_editmaskselect = true
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

event ue_lbuttondown;if inv_grid_dischports.of_stop_column_resize(flags, xpos, ypos) = c#return.Success then
 inv_grid_dischports.of_setcolumnorder()	
 message.processed = TRUE
 return 1
end if
end event

event ue_filterconsdddw(long al_currentrow, boolean ab_reset);/********************************************************************
   ue_filterconsdddw
   <DESC>	Description	</DESC>
   <RETURN>	
		long:
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_currentrow:
		ab_reset:
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		26-08-2015	CR4048	KSH092	First Version
   </HISTORY>
********************************************************************/

string ls_purpose_code, ls_typelist, ls_find, ls_filter, ls_orig_filter
dec ldc_cons_id
datawindowchild ldwc_dddw

if al_currentrow <= 0 or isnull(al_currentrow) then return
//
//ls_purpose_code = this.getitemstring(al_currentrow, "purpose_code")
//choose case ls_purpose_code
//	case "L"
//		ls_typelist = "3,4,8"  //At Port - Load
//	case "D"
		ls_typelist = "6,4,8"  //At Port - Discharge
//	case "WD"
//		ls_typelist = "7,8,4"  //At Port - Idle, Heating
//	case else
//		ls_typelist = "4,8"  //At Port - General
//end choose
//
iuo_calc_nvo.of_getconsdropdown(this, "port_cons_id", ls_typelist, ab_reset,true,al_currentrow)

end event

event clicked;call super::clicked;/********************************************************************
	<DESC>
		If the button on the window is clicked the misc. port expenses
		window is opened.
	</DESC>
	<RETURN>	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		01/05/97		?     		MI    		First version
		02/09/14		CR3512		XSZ004		Fix a historical bug
	</HISTORY>
********************************************************************/

String ls_object, ls_row_no
long   ll_found, ll_row_no, ll_position_no, ll_current_cargo

s_misc_expenses ls_misc_expenses

if dwo.name = "port_cons_id" then
	if of_check_constype("Consumption Type Selection", dwo.name, this) = c#return.failure then
		return
	end if
end if

// Get the object at the point clicked
ls_object = dw_dischports.GetObjectAtPointer()

// Find the button and the row clicked
ll_found       = Pos(ls_object,"obj_button")
ll_position_no = Pos(ls_object,"~t")
ls_row_no      = Trim(Mid(ls_object, ll_position_no + 1))
ll_row_no      = long(ls_row_no)

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
DATE			VERSION		NAME		DESCRIPTION
-----------------------------------------------------------------------------
26-11-13		CR2658UAT	WWG004	When reversible, change the first port's contype, 
											the reversible port will all be changed.
14/01/16		CR3248      LHG008	ECA zone implementation
22/08/17		CR4221      HHX010   Interim port
20/11/17		CR4221	   HHX010	 Add a warning message
****************************************************************************/

Double	ld_tmp
long		ll_found, ll_consid, ll_portrow, ll_return, ll_null
string	ls_purpose, ls_portcode
decimal  ld_null, ld_amount_usd, ld_local_exrate, ld_dem_exrate
integer li_voyage_alert

SetNull(ld_null)
setnull(ll_null)

if dwo.name = "port_cons_id" then
	ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'consumption', this, data)
	if ll_return = C#Return.Failure then
		this.Post setcolumn("port_cons_id")
		return 2
	end if
end if

if dwo.name='cal_caio_interim_port' then
   if of_isallowed_interim(this, row, data, "D") = false then return 2 
   if of_check_interimport_change(this, row, data) = C#Return.Failure then return 2	
end if

this.accepttext( )

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
			ll_found = w_share.dw_calc_port_dddw.find("port_code='"+data+"'", 1, 99999)
			/* Check if port is active */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "port_active") = 0 then
					Messagebox("Port code selection", "The selected portcode '"+data+"' is inactive. Please select another port.")
					this.POST setcolumn( "port_code" )
					Return 2
				end if
			end if
			/* Check if portcode OK */
			IF (len(data) <> 3) then
				Messagebox("Port code selection", "For loadport please select a portcode with length 3 characters")
				this.POST setcolumn( "port_code" )
				Return 2
			end if	
			/* Check if purpose is OK  - only if portcode = viapoint or canal */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "via_point") > 0 then
					ls_purpose = this.getItemString(row, "purpose_code")
					if ls_purpose = "L" or ls_purpose = "D" then
						Messagebox("Purpose Code Selection", "Purpose Code Load or Dischage not allowed for RoutingPoint")
						this.POST setcolumn( "port_code" )
						Return 2
					end if
				end if
			end if
			
			//Auto pre-select the consumption type
			ll_consid = this.getItemnumber(row, "port_cons_id")
			if isnull(ll_consid) or string(ll_consid) = '' then
				of_preselect_contype(row, 'D', dw_dischports, "port_cons_id")
			end if
			
			li_voyage_alert = of_get_voyage_alert_status(data)
			this.setitem(row, "voyage_alert", li_voyage_alert)
			this.setitemstatus(row, "voyage_alert", primary!, notmodified!)
		case "purpose_code"
			ls_portcode = this.getItemString(row, "port_code")
			ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_portcode+"'", 1, 99999)
			/* Check if purpose is OK  - only if portcode = viapoint or canal */
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "via_point") > 0 then
					if data = "L" or ls_purpose = "D" then
						Messagebox("Purpose Code Selection", "Purpose Code Load or Dischage not allowed for RoutingPoint")
						this.POST setcolumn( "purpose_code" )
						Return 2
					end if
				end if
			end if
			if data <> 'D' then this.setitem(row, "cal_caio_interim_port", 0)
		case "port_cons_id"
			
	
			ll_found = this.find("reversible = 1", 1, this.rowcount())
			
			if ll_found > 0 then
				ll_consid = this.getitemnumber(row, "port_cons_id")
				if this.rowcount() > 1 then
					for ll_portrow = 2 to this.rowcount()
						this.setitem(ll_portrow, "port_cons_id", ll_consid)
					next
				end if
			end if
			
		case COLUMN_DESPATCH_DEM_CURR
			ld_dem_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_DEM_EXRATE_USD)
			ld_amount_usd = dec(data) * ld_dem_exrate / 100
			this.setitem(row, COLUMN_DESPATCH_USD, ld_amount_usd )
			if dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
				dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
				this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, dec(data) )
			else
				ld_local_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
				if ld_local_exrate <> 0 then
					this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, ld_amount_usd / (ld_local_exrate / 100.0))
				else
					this.setitem(row, COLUMN_DESPATCH_LOCAL_CURR, ld_null)
				end if
			end if
			this.setcolumn(COLUMN_DESPATCH_USD)

		case COLUMN_DEMURRAGE_DEM_CURR
			ld_dem_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_DEM_EXRATE_USD)
			ld_amount_usd = dec(data) * ld_dem_exrate / 100.0
			this.setitem(row, COLUMN_DEMURRAGE_USD, ld_amount_usd)
			if dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_LOCAL_CURR_CODE) = &
				dw_cargo_summary.GetItemString(ii_current_cargo, COLUMN_DEM_CURR_CODE) then
				this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, dec(data) )
			else
				ld_local_exrate = dw_cargo_summary.GetItemNumber(ii_current_cargo, COLUMN_LOCAL_EXRATE_USD)
				if ld_local_exrate <> 0 then
					this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, ld_amount_usd / (ld_local_exrate / 100.0)  )
				else
					this.setitem(row, COLUMN_DEMURRAGE_LOCAL_CURR, ld_null)
				end if
			end if
			this.setcolumn(COLUMN_DEMURRAGE_USD)
		case 'cal_caio_interim_port'
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
			end if	
	end choose
end if


iuo_calc_nvo.iuo_calculation.uo_calc_itinerary.uf_clear_cache()
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

event constructor;call super::constructor;datawindowchild ldwc_cal_cons

/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
end if

//disable the resizable possibility for columns with icons
inv_grid_dischports.of_registerdatawindow(dw_dischports)

this.modify("port_cons_id_all.width = '0~tlong(describe(~"port_cons_id.width~"))' port_cons_id_all.x = '0~tlong(describe(~"port_cons_id.x~"))'")
this.modify("datawindow.processing = '0' port_cons_id_all.visible = '1~tif(currentRow() = getrow(), 0, 1)' datawindow.processing = '1'")

if this.getchild("port_cons_id", ldwc_cal_cons) = 1 then
	ldwc_cal_cons.modify("cal_cons_sss.visible = '0' cal_cons_meco.visible = '0' cal_cons_speed.visible = '0'")
end if
end event

event rowfocuschanged;call super::rowfocuschanged;event ue_filterconsdddw(currentrow, false)
end event

event rbuttondown;call super::rbuttondown;integer li_x, li_y
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

type dw_calc_lumpsum from u_datawindow_sqlca within u_atobviac_calc_cargos
event ue_keydown pbm_dwnkey
integer x = 2601
integer y = 640
integer width = 1906
integer height = 268
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_calc_lumpsum"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean ib_autochildmodified = false
boolean ib_autoaccept = true
end type

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF


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
uf_change_sql(7,dw_calc_lumpsum,sqlsyntax)
end event

event itemchanged;call super::itemchanged;integer li_settledfreight=0, li_settledother=0

//check if the freight claim is already settled
_getsettledclaimcounts( li_settledfreight, li_settledother )

if li_settledfreight > 0 then
	_addmessage( this.classdefinition, "dw_calc_lumpsum.itemchanged()", "Information.  You can not change the additional lumpsums, because the freight claim is already settled. Please contact Finance department in order to modify the additional lumpsums.", "User Information")
	return 2
end if

if row > 0 and  dwo.name ="cal_lump_add_lumpsum_local_curr" then
	dw_calc_lumpsum.setitem(row, "cal_lump_add_lumpsum", double(data) * dw_cargo_summary.GetItemNumber(ii_current_cargo, "cal_carg_cal_carg_exrate_usd") / 100 )
end if

parent.TriggerEvent("ue_childmodified")

end event

event clicked;call super::clicked;if dw_cargo_summary.getitemnumber(dw_cargo_summary.getrow(), "locked") <> 1 or isnull(dw_cargo_summary.getitemnumber(dw_cargo_summary.getrow(), "locked")) then
	if dw_calc_lumpsum.rowcount( ) = 0 then
		of_insertlumpsum(dw_calc_lumpsum)
	end if
end if

end event

type gb_1 from mt_u_groupbox within u_atobviac_calc_cargos
integer x = 37
integer y = 1004
integer width = 4503
integer height = 1112
integer taborder = 60
long backcolor = 32304364
string text = ""
end type

type r_1 from rectangle within u_atobviac_calc_cargos
long linecolor = 12632256
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 32304364
integer x = 18
integer y = 976
integer width = 4544
integer height = 1416
end type

type st_2 from statictext within u_atobviac_calc_cargos
integer x = 2592
integer y = 568
integer width = 699
integer height = 56
boolean bringtotop = true
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

type dw_cargo_summary from u_datawindow_sqlca within u_atobviac_calc_cargos
event ue_keydown pbm_dwnkey
event ue_mousemove pbm_dwnmousemove
integer x = 18
integer y = 24
integer width = 4539
integer height = 1000
integer taborder = 10
string dataobject = "d_calc_cargo_summary"
boolean border = false
boolean livescroll = false
boolean ib_autochildmodified = false
boolean ib_autoaccept = true
end type

event ue_mousemove;s_chart_comment_parm		lstr_parm 

If dwo.name = "p_comment" Then
	if not isValid(w_chart_comment_popup) then
		if row > 0 then
	      	lstr_parm.chart_nr = false
			lstr_parm.reciD = this.getItemNumber(row, "cal_calc_id")
			OpenWithParm (w_chart_comment_popup, lstr_parm )
		end if
   end if
End if
return 0
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
DATE    		VERSION		NAME  		DESCRIPTION
15/02/11		CR1549 		JSU042		multi currencies
13/10/14		CR3528 		XSZ004		Set constype to empty when changing days idle,days bunkering and days various to 0
29/01/15		CR3935		LHG008		Pre-select a default consumption type for Idle, Bunkering, Various
29/11/16		CR4050		LHG008		Change additionals Laden and Ballasted logic
************************************************************************************/

int li_null
long ll_return, ll_row
string ls_dwoname

setnull(li_null)

choose case dwo.name
	case "cal_carg_laden_cons_id"
		ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'speed', this, data)
		if ll_return = C#Return.Failure then
			this.Post setcolumn("cal_carg_laden_cons_id")
			return 2
		end if
		iuo_calc_nvo.of_setconsdata(this, "cal_carg_laden_cons_id", iuo_calc_nvo.is_COL_CAL_CONS_SPEED , "laden_speed")
	case "cal_carg_ballast_cons_id"
		ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'speed', this, data)
		if ll_return = C#Return.Failure then
			this.Post setcolumn("cal_carg_ballast_cons_id")
			return 2
		end if
		iuo_calc_nvo.of_setconsdata(this, "cal_carg_ballast_cons_id", iuo_calc_nvo.is_COL_CAL_CONS_SPEED, "ballast_speed")
	case "cal_carg_cal_carg_add_days_laden"
		if dec(data) = 0 then
			this.setitem(row, "cal_carg_laden_cons_id", li_null)
			this.setitem(row, "laden_speed", li_null)
		end if
	case "cal_carg_cal_carg_add_days_ballast"
		if dec(data) = 0 then
			this.setitem(row, "cal_carg_ballast_cons_id", li_null)
			this.setitem(row, "ballast_speed", li_null)
		end if
	case "cal_carg_add_days_laden_pcnt", "cal_carg_cal_carg_add_days_ballast_pcnt"
		ls_dwoname = dwo.name
		for ll_row = 2 to this.rowcount()
			this.setitem(ll_row, ls_dwoname, dec(data))
		next
		
	case "cal_carg_cal_carg_idle_days" 
		if dec(data) = 0 then
			this.setitem(row, "cal_carg_idle_cons_id", li_null)
		elseif isnull(this.getitemnumber(row, "cal_carg_idle_cons_id")) then
			of_preselect_contype(row, is_IDEL, this, "cal_carg_idle_cons_id")
		end if
	case "cal_carg_cal_carg_bunkering_days"
		if dec(data) = 0 then
			this.setitem(row, "cal_carg_bunker_cons_id", li_null)
		elseif isnull(this.getitemnumber(row, "cal_carg_bunker_cons_id")) then
			of_preselect_contype(row, is_BUNKERING, this, "cal_carg_bunker_cons_id")
		end if
	case "cal_carg_add_days_other"
		if dec(data) = 0 then
			this.setitem(row, "cal_carg_various_cons_id", li_null)
		elseif isnull(this.getitemnumber(row, "cal_carg_various_cons_id")) then
			of_preselect_contype(row, is_VARIOUS, this, "cal_carg_various_cons_id")
		end if
	case "cal_carg_idle_cons_id","cal_carg_bunker_cons_id","cal_carg_various_cons_id"
		ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'consumption', this, data)
		if ll_return = C#Return.Failure then
			ls_dwoname = dwo.name
			this.post setcolumn(ls_dwoname)
			return 2
		end if
	case else
		//
end choose

ll_return = of_validatecargosummary( this, dwo, row, data )
return ll_return

end event

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

event doubleclicked;call super::doubleclicked;string ls_column
s_calc_addbuncons lstr_calc_addbuncons
long ll_vessel_type, ll_vessel_id, ll_clarkson_id, ll_cargo_id, ll_calc_id
integer li_locked
dec{3} ld_org_hsfo, ld_org_hsgo, ld_org_lsgo, ld_org_lsfo, ld_cur_hsfo, ld_cur_hsgo, ld_cur_lsgo, ld_cur_lsfo

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
end if

end event

event constructor;call super::constructor;/* If external user - readOnly */
datawindowchild ldwc_child

IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF

this.getchild("cal_carg_idle_cons_id", ldwc_child)
ldwc_child.modify("cal_cons_speed.visible = 0")
ldwc_child.modify("cal_cons_sss.visible = 0")
ldwc_child.modify("cal_cons_meco.visible = 0")

this.getchild("cal_carg_bunker_cons_id", ldwc_child)
ldwc_child.modify("cal_cons_speed.visible = 0")
ldwc_child.modify("cal_cons_sss.visible = 0")
ldwc_child.modify("cal_cons_meco.visible = 0")
end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_cargo_summary)
end event

event clicked;call super::clicked;string ls_columnname, ls_title

choose case dwo.name
	case "cal_carg_idle_cons_id", "cal_carg_bunker_cons_id", "cal_carg_various_cons_id", "cal_carg_laden_cons_id", "cal_carg_ballast_cons_id" 
		
		ls_columnname = this.getcolumnname()
		
		if ls_columnname = "cal_carg_cal_carg_idle_days" or &
			ls_columnname = "cal_carg_cal_carg_bunkering_days" or & 
			ls_columnname = "cal_carg_add_days_other" then
			ls_title = "Consumption Type Selection"
			this.accepttext()
		elseif ls_columnname = "cal_carg_cal_carg_add_days_laden" or & 
			ls_columnname = "cal_carg_cal_carg_add_days_ballast" then
			ls_title = "Speed selection"
			this.accepttext()
		end if
		
		of_check_constype(ls_title, dwo.name, this)
	case else
		//
end choose
end event

type cb_1 from commandbutton within u_atobviac_calc_cargos
integer x = 3945
integer y = 460
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

