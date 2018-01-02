﻿$PBExportHeader$u_calculation.sru
$PBExportComments$This object contains all calculation functions
forward
global type u_calculation from u_calc_base_sqlca
end type
type uo_calc_compact from u_atobviac_calc_compact within u_calculation
end type
type dw_shared_terms from u_datawindow_sqlca within u_calculation
end type
type uo_calc_summary from u_calc_summary within u_calculation
end type
type uo_calc_wizard from u_calc_wizard within u_calculation
end type
type uo_calc_result from u_calc_result within u_calculation
end type
type uo_calc_itinerary from u_calc_itinerary within u_calculation
end type
type uo_calc_cargos from u_calc_cargos within u_calculation
end type
end forward

global type u_calculation from u_calc_base_sqlca
integer width = 4603
integer height = 2404
event ue_shared_retrieve pbm_custom20
event ue_calc_changed pbm_custom21
event ue_show_cargo_row pbm_custom22
event ue_page_changed pbm_custom23
event ue_cargo_row_changed pbm_custom24
event ue_load_speedlist pbm_custom25
event ue_port_changed pbm_custom26
event ue_right_click ( string as_object )
uo_calc_compact uo_calc_compact
dw_shared_terms dw_shared_terms
uo_calc_summary uo_calc_summary
uo_calc_wizard uo_calc_wizard
uo_calc_result uo_calc_result
uo_calc_itinerary uo_calc_itinerary
uo_calc_cargos uo_calc_cargos
end type
global u_calculation u_calculation

type variables
Private long il_calc_id
Public Boolean ib_modified, ib_calculated
Private Int ii_current_page, ii_winmode=3
private long il_winx, il_winy
Private Boolean ib_wizard, ib_loading
Boolean ib_show_messages = true // Show any trivial messageboxes
String is_message // Silent result string
Public s_revers_sens istr_revers_sens
Public Boolean ib_no_WS_reload, ib_no_vesseldata_reload
n_checkdata inv_opdata
long il_pcnr

CONSTANT STRING is_DOFIXTURE = "DO_FIXTURE"

end variables

forward prototypes
public subroutine uf_retrieve (long al_calc_id)
public subroutine uf_insert ()
public function string uf_get_calculation_title ()
public function integer uf_get_current_page ()
public subroutine uf_get_vessel (ref long al_vessel_type_id, ref long al_vessel_id, ref long al_clarkson_id)
public function string uf_get_vessel_name ()
public subroutine uf_select_cargo (integer ai_cargo_row)
public subroutine uf_set_status (integer ai_cargo_no, integer ai_status)
public function long uf_get_cerp_id (integer ai_cargo_no)
public function string uf_get_description (integer ai_cargo_no)
public subroutine uf_set_description (integer ai_cargo_no, string as_description)
public function datetime uf_get_starting_date ()
public subroutine uf_set_starting_date (datetime adt_starting_date)
public function integer uf_get_status (integer ai_cargo_no)
public function integer uf_get_cargo ()
public function string uf_get_cargo_description (integer ai_cargo_no)
public subroutine uf_print ()
public subroutine uf_update (integer ai_cargo_no)
public function boolean uf_fixture (ref boolean ab_cargos[])
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine uf_load_speedlist ()
public subroutine uf_create_progress (string as_title, ref s_calculation_parm astr_parm)
public subroutine uf_reload_speedlist ()
public function long uf_get_calc_id ()
public function boolean uf_get_ballast_voyage ()
public subroutine uf_set_ballast_voyage (boolean ab_value)
public function boolean uf_load_wizard (string as_name)
public function boolean uf_get_wizard ()
public function integer uf_get_no_cargos ()
public function string uf_get_loadport_name (ref s_port_parm astr_port_parm)
public function string uf_get_dischport_name (ref s_port_parm astr_port_parm)
public function boolean uf_set_wizard (boolean ab_value)
public function integer uf_get_rate_type (integer ai_cargo_no)
public function integer uf_deactivate ()
public function long uf_get_fix_id ()
public function boolean uf_calculate_with_parm (ref s_calculation_parm astr_parm)
public subroutine uf_set_cerp_id (integer ai_cargo_no, long al_cerp_id)
public function long uf_get_cargo_id ()
public function boolean uf_unlock ()
public subroutine uf_insert_new_id (ref double d_caio_id_old[], ref double d_caio_id_new[])
public function string uf_get_lport_name_purpose (s_port_parm astr_port_parm)
public function string uf_get_dport_name_purpose (s_port_parm astr_port_parm)
public function integer uf_get_first_loadport ()
public function integer uf_get_no_dischports (integer ai_cargo_no)
public function integer uf_get_no_loadports (integer ai_cargo_no)
private function integer uf_get_revers_freight (integer ai_cargo_no)
public function integer uf_get_reversible (long al_cargo_no)
public function boolean uf_save (boolean ab_showprogress)
public function boolean uf_calculate ()
public subroutine uf_delete ()
public function boolean uf_process (ref s_calculation_parm astr_parm, boolean ab_setresult)
public subroutine uf_select_page (integer ai_pageno)
public subroutine uf_set_vessel (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id)
public subroutine uf_print_preview ()
public function boolean uf_sensitivity (integer ai_function_code, integer ai_cargo_no[], ref s_calc_sensitivity astr_calc_sensitivity, character ac_load_disch, integer ai_port_no, ref s_calculation_parm astr_calc_parm)
public function integer uf_cpact_set_win_mode (integer ai_winmode)
public function integer uf_cpact_get_win_mode ()
public function integer uf_retrieve_route (long al_calc_id)
public function boolean uf_saveas (string as_description, integer ai_calctype, boolean ab_showprogress)
private subroutine documentation ()
public function n_checkdata of_getcheckdata ()
public function integer of_setcheckdata ()
public function long of_getcheckvesselnr ()
public function string of_getcheckvoyagenr ()
public function long of_getestcalcid ()
public function integer of_setcheckstatusid (integer ai_newstatus)
public function long of_get_profit_center ()
public subroutine of_set_profit_center (long al_vessel_id, long al_clarkson_id)
end prototypes

event ue_shared_retrieve;call super::ue_shared_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-9-96

 Description : Creates link between shared datawindows, and calls 
					DW_SHARED_TERMS.RETRIEVE
					
 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

DatawindowChild dwc_tmp
Boolean lb_result

// Share all nessesary datawindow. 

// The following lines shares the port code drop-down lists with the
// ports list in the w_share
uo_calc_summary.dw_calc_summary.GetChild("cal_calc_ballast_from",dwc_tmp)
if uf_sharechild("dw_calc_port_dddw", dwc_tmp) <> 1 Then MessageBox("x", "x")

uo_calc_summary.dw_calc_summary.GetChild("cal_calc_ballast_to",dwc_tmp)
uf_sharechild("dw_calc_port_dddw", dwc_tmp)

uo_calc_cargos.dw_loadports.GetChild("port_code",dwc_tmp)
uf_sharechild("dw_calc_port_dddw", dwc_tmp)

uo_calc_cargos.dw_dischports.GetChild("port_code",dwc_tmp)
uf_sharechild("dw_calc_port_dddw", dwc_tmp)

// The following lines shares the RATE-list with the DW_SHARED_TERMS (hidden)
// datawindow.
uo_calc_cargos.dw_loadports.GetChild("cal_raty_id",dwc_tmp) 
lb_result = dw_shared_terms.ShareData(dwc_tmp) <> 1
if lb_result  Then MessageBox("Error", "Error sharing loadports raty")

uo_calc_cargos.dw_dischports.GetChild("cal_raty_id",dwc_tmp)
lb_result = dw_shared_terms.ShareData(dwc_tmp) <> 1
if lb_result  Then MessageBox("Error", "Error sharing dischports raty")

// The following lines shares the DW_CARGO_SUMMARY on the cargo page 
// with the DW_CALC_SUMMARY_LIST on the summary page
lb_result = uo_calc_cargos.dw_cargo_summary.ShareData(uo_calc_summary.dw_calc_summary_list) <> 1
if lb_result Then MessageBox("Error", "Error sharing cargo til summary list")

// The following lines shares the DW_CALC_RESULT on the result page
// with the DW_CALC_SUMMARY on the summary page.
lb_result = uo_calc_summary.dw_calc_summary.ShareData(uo_calc_result.dw_calc_result)<>1
If lb_result Then MessageBox("Error", "Error sharing result to result object")

// Retrieve data in the DW_SHARED_TERMS hidden datawindow
dw_shared_terms.Retrieve()

COMMIT USING SQLCA;


end event

event ue_show_cargo_row;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the cargo # given in the WordParm of the Message Object

 Arguments : None (message object is implicit)

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uf_select_cargo(Message.WordParm)


end event

event ue_load_speedlist;call super::ue_load_speedlist;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles requests for loading the speedlist, by calling
 					UF_LOAD_SPEEDLIST.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uf_load_speedlist()
end event

event ue_port_changed;call super::ue_port_changed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 3-3-97

 Description : This event gets called, whenever ports are changed, that is, when a 
 					port is added, deleted or changed to another port. This event calls 
					itinerary.uf_clear_cache

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

uo_calc_itinerary.uf_clear_cache(true)


end event

event ue_right_click(string as_object);// do nothing
end event

public subroutine uf_retrieve (long al_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves calculation given in AL_CALC_ID. If AL_CALC_ID is zero,
 					a new calculation is created

 Arguments : AL_CALC_ID as long

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

this.uf_redraw_off()
il_calc_id = al_calc_id

// Set the loading flag to true (remember to set it to false later). This flags signals
// that a loading is taking place, and that UE_CHILD_MODIFIED, UE_PORT_CHANGED etc. 
// events shouldn't be carried out, because several of them will be fired during
// the load.
ib_loading = true
ib_modified = false

// If IL_CALC_ID is zero, then insert a new calculation in U_CALC_SUMMARY and 
// a new cargo in U_CALC_CARGOS.
If il_calc_id = 0 Then
	uo_calc_summary.uf_insert()
	uo_calc_cargos.uf_insert_cargo(true)
Else
	// It's wasen't a new calculation, so we are going the retrieve the calculation.
	// If the current calculation is a ballast voyage, the reset back to "normal"
	// calculations before retieving data.
	if uo_calc_cargos.ib_ballastvoyage Then

		uo_calc_cargos.uf_reset_voyagetype()
		uo_calc_cargos.dw_cargo_summary.ShareData(uo_calc_summary.dw_calc_summary_list)  
	End if

	// Retrieve the calculation in the U_CALC_SUMMARY module
	uo_calc_summary.uf_Retrieve(il_calc_id)

	// If it's a estimated calculation (status = 5) then create the links
	// between the estimated and calculated calculation
	If uf_get_status(0) = 5 Then
		If not iuo_calc_nvo.uf_create_calc_est_links(il_calc_id) Then &
			MessageBox("System error", "Unable to match calculated and estimated calculations, problably due to database failure.~r~n~r~nPlease contact TRAMOS-support")
	End if

	// If we just retrieved a ballast voyage, then update the U_CALC_CARGOS
	// to work as a ballast window
	If uf_get_ballast_voyage() Then uo_calc_cargos.uf_set_ballast_voyage(True)

	// ..and retrieve the cargos in the U_CALC_CARGOS object
	uo_calc_cargos.uf_Retrieve(il_calc_id, uo_calc_summary.dw_calc_summary)
End if

COMMIT USING SQLCA;

// Set current page to 1, trigger a UE_PAGE_CHANGED event to tell the rest
// of the calculation system that the page (might) have changed, and 
// activate the summary page.
ii_current_page = 1
TriggerEvent("ue_page_changed",ii_current_page,0)
uo_calc_summary.uf_activate()

// If we're using a Wizard, then setFocus to the dw_wizard.
If ib_wizard Then uo_calc_wizard.dw_wizard.SetFocus()

// Set calculated to true (ok, it's not always true, but it works most of the time),
// modified to false, and clear the Itinerary cache (just incase there's data in it).
ib_calculated = true
ib_modified = false

uo_calc_itinerary.uf_clear_cache(true)

// and we're done
this.uf_redraw_on()

// Set IB_LOADING to false so that UE_CHILD_MODIFIED, UE_PORT_CHANGED events
// again will be processed. 
ib_loading = false


end subroutine

public subroutine uf_insert ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls on to either uf_insert_cargo (if we're in page 1) 
 					or uf_insert_port (if we're on page 3)

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
long							ll_retval
string						ls_dwname
u_datawindow_sqlca		ldw

// Pass the insert on to currently active page object
CHOOSE CASE ii_current_page
	CASE 1
		IF uo_global.ii_access_level = -1 THEN 
			MessageBox("Infomation","As an external user you do not have access to this functionality.")
		ELSE
			uo_calc_summary.uf_select_cargo(uo_calc_cargos.uf_insert_cargo(true))
		END IF
	CASE 3,5
		
		if ii_current_page = 3 then
			ll_retval = uo_calc_cargos.of_getdatawindowfocus( ldw, ls_dwname)
		else
			ll_retval = uo_calc_compact.of_getdatawindowfocus( ldw, ls_dwname)
		end if	
		
		if ll_retval = c#return.Success then
			CHOOSE CASE ls_dwname
				CASE "dw_dischports", "dw_loadports"
					uo_calc_cargos.of_insertport(ldw)
				CASE "dw_calc_lumpsum"
					uo_calc_cargos.of_insertlumpsum(ldw)
			END CHOOSE	
		end if	

END CHOOSE

end subroutine

public function string uf_get_calculation_title ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the calcule description.
 					
 Arguments : None

 Returns   : Description as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If uo_calc_summary.dw_calc_summary.RowCount()>0 Then
	Return(uo_calc_summary.dw_calc_summary.GetItemString(1,"cal_calc_description"))
Else
	Return("")
End if

end function

public function integer uf_get_current_page ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the current page number

 Arguments : None

 Returns   : Page number as Integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(ii_current_page)
end function

public subroutine uf_get_vessel (ref long al_vessel_type_id, ref long al_vessel_id, ref long al_clarkson_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the VESSEL_ID in either al_vessel_type_id, al_vessel_id 
 					or al_clarkson_id, depending on VESSEL type in use.

 Arguments : al_vessel_type_id, al_vessel_id, al_clarkson_id as REF LONG

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calc_summary.uf_get_vessel(al_vessel_type_id,al_vessel_id,al_clarkson_id)
end subroutine

public function string uf_get_vessel_name ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the name of the selected VESSEL

 Arguments : None

 Returns   : Vesselname as string  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_summary.uf_get_vessel_name())
end function

public subroutine uf_select_cargo (integer ai_cargo_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the cargo given in AI_CARGO_ROW and shows the
 					CARGO PAGE, or -1 to syncronize current cargo (and show the cargo window)
					with the cargo on the summary window. Using zero and there after the 
					wanted cargo will allways trigger the cargo changed events.					

 Arguments : AI_CARGO_ROW as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


this.uf_redraw_off()

// If the itinerary is the current page, then deactivate it, to ensure that
// modifications is moved to the cargo window
If ii_current_page = 2 Then
	uo_calc_itinerary.uf_deactivate()
End if

// If AI_CARGO_ROW is -1 then refresh to current cargo
If ai_cargo_row = -1 Then ai_cargo_row = uo_calc_summary.dw_calc_summary_list.GetRow()

// Select the cargo in both the U_CALC_CARGOS and the U_CALC_SUMMARY (cargo list)
uo_calc_cargos.uf_select_cargo(ai_cargo_row)
uo_calc_summary.uf_select_cargo(ai_cargo_row)

// and select the cargo page
This.uf_select_page(3)
this.uf_redraw_on()

	
	
end subroutine

public subroutine uf_set_status (integer ai_cargo_no, integer ai_status);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 29-7-96

 Description : Sets the status for cargo given in AI_CARGO_NO. Specifiy 0 (zero) 
 					as AI_CARGO_NO, to change the status for the whole calcule.

 Arguments : AI_CARGO_NO as Long, AI_STATUS as Integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----         --------------------
  
************************************************************************************/

Long ll_rows, ll_count

If ai_cargo_no = 0 Then
	// No cargo was specified, change the status for the calculation itself,
	// and all cargos.
	uo_calc_summary.uf_Set_Status(ai_status)

	ll_rows = uo_calc_summary.dw_calc_summary_list.RowCount()
	
	For ll_Count = 1 To ll_rows 
		uo_calc_cargos.uf_set_status(ll_count,ai_status)
	Next
Else
	// Cargo # was given, change the status for that cargo, and update the status
	// for the calculation if the new status is heigher than the current, so the
	// calculation status always reflects the highest cargo status
	uo_calc_cargos.uf_set_status(ai_cargo_no, ai_status)

	If ai_status>uo_calc_summary.uf_get_status() Then
		uo_calc_summary.uf_set_status(ai_status)
	End if
End if
end subroutine

public function long uf_get_cerp_id (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Returns cerp id for ai_cargo_no (or 0 for current)

					See u_calc_cargos.uf_get_cerp_id for further description

 Arguments : ai_cargo_no as integer

 Returns   : Cerp_id as Long

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_cerp_id(ai_cargo_no))
end function

public function string uf_get_description (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Returns the description depending on ai_cargo_no:
 
 					ai_cargo_no:
					0 :	Returns the description for the calculation
					>0:	Returns the description for the cargo specified in ai_cargo_no
					
 Arguments : cargo_no

 Returns   : description as string

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

CHOOSE CASE ai_cargo_no 
	CASE 0
		Return(uo_calc_summary.uf_get_description())
	CASE IS > 0
		Return(uo_calc_cargos.dw_cargo_summary.getItemString(ai_cargo_no, "cal_carg_description"))
END CHOOSE
end function

public subroutine uf_set_description (integer ai_cargo_no, string as_description);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Sets description the for the calculation (if AI_CARGO_NO = 0)
					Can be expanded to set the description for the cargo given
					in AI_CARGO_NO, but this is not implemented in the current version

 Arguments : AI_CARGO_NO as integer, AS_DESCRIPTION as string

 Returns   : None

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

CHOOSE CASE ai_cargo_no 
	CASE 0
		uo_calc_summary.uf_set_description(as_description)
END CHOOSE
end subroutine

public function datetime uf_get_starting_date ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the starting date for the calculation

 Arguments : None

 Returns   : Starting date as DateTime  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_summary.uf_get_starting_date())

end function

public subroutine uf_set_starting_date (datetime adt_starting_date);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the starting date given in ADT_STARTING_DATE.

 Arguments : ADT_STARTING_DATE as datetime

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calc_summary.uf_set_starting_date(adt_starting_date)
end subroutine

public function integer uf_get_status (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Returns status for (ai_cargo_nr = 0) the calculation or 
 					for cargo (ai_cargo_nr > 0)

 Arguments : ai_cargo_no as integer

 Returns   : Status as integer

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

If ai_cargo_no = 0 Then
	Return(uo_calc_summary.uf_get_status())
Else
	Return(uo_calc_cargos.uf_get_status(ai_cargo_no))
End if
end function

public function integer uf_get_cargo ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the cargo number.
 					
 Arguments : None

 Returns   : Number as integer

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Returns current cargo

Return(uo_calc_cargos.uf_get_cargo())
end function

public function string uf_get_cargo_description (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the cargo description.
 					
 Arguments : None

 Returns   : Description as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
Return(uo_calc_cargos.uf_get_cargo_description(ai_cargo_no))

end function

public subroutine uf_print ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Passed the calculation datawindows on the the w_calc_invisible_print
 					window, that takes care of the printout

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_print lstr_calc_print

lstr_calc_print.dw_calc = uo_calc_summary.dw_calc_summary
lstr_calc_print.dw_cargos = uo_calc_cargos.dw_cargo_summary

// Ask Itinerary to retrieve it's data, since data might not be there
// otherwise
uo_calc_itinerary.dw_calc_itinerary.uf_redraw_off()
uo_calc_itinerary.uf_retrieve()
lstr_calc_print.dw_calc_itinerary = uo_calc_itinerary.dw_calc_itinerary
uo_calc_itinerary.dw_calc_itinerary.uf_redraw_on()

// And open the print window
OpenWithParm(w_calc_invisible_print,lstr_calc_print)
end subroutine

public subroutine uf_update (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls on to U_CALC_CARGOS.UF_UPDATE to update CP links, reversible
 					information etc. Reacts on cargo # given in AI_CARGO_NO

 Arguments : AI_CARGO_NO as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calc_cargos.uf_update(ai_cargo_no)
end subroutine

public function boolean uf_fixture (ref boolean ab_cargos[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 8-7-96

 Description : Fixtures one or more cargoes. Se uf_process for further details.

 If the uf_process call succedes, this function saves the current calculation as the
 fixture, calculated and estimated calculations, and copies the consumption for
 the selected vessel to the CCON table

 Arguments : ab_cargos[], a list of boolean, where each entry determines if the
 				 cargo is to be fixed.
				  
				 E.g.;
				 ab_cargos[1] = False
				 ab_cargos[2] = True
				 ab_cargos[3] = True
				 
				 Means that only cargo 2 + 3 is to be fixtured.
 
 Returns   : True if ok

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
15/03/16       CR4114           SSX014    Remove Yield() to avoid crashing
************************************************************************************/

s_calculation_parm 	lstr_parm
boolean 					lb_result
long 						ll_vessel_nr, ll_fixture_calc_id, ll_tmp
integer 					li_cons_type, li_count, li_status
double 					ld_cons_fo, ld_cons_do, ld_cons_mgo, ld_cons_speed
long 						ll_fix_id, ll_return
n_get_maxvalue 		lnv_get_maxvalue

// Set default return value to false
lb_result = false

// Set redraw off, and create the the progress bar.
uf_redraw_off()
uf_create_progress("Fixing", lstr_parm)

// Call uf_process for fixture (i_function_code = 3), and include the fixturelist,
// which is a list of the cargoes that is to be fixed
lstr_parm.i_function_code = 3
lstr_parm.fixturelist = ab_cargos

If Not uf_process(lstr_parm, true) Then
	MessageBox("Fixture error","Error generating fixture:~r~n~r~n" + lstr_parm.result.s_errortext, StopSign!)
	Goto Stop
End if

// Process went well, so the calculation is ready to be saved. 
// 
// The FIXTURE_ID is investigated to check if the calculation has been fixtured
// before. The FIXTURE_ID will be zero for calculation that have not been 
// fixtured before.

ll_fix_id = uo_calc_summary.uf_get_fixture_id()
If ll_fix_id <> 0 Then
	// This calculation has been fixtured before, get it's status, since only
	// calculated calculations (status = 5) is allowed to be fixed on additional
	// ports.
	
	li_status = uf_get_status(0)

	If li_status = 5 Then 
		// It's an calculated calculation. 
		lstr_parm.w_progress.wf_progress(0.85,"Saving calculated")
	
		// Loop through the AB_CARGOS array and set the status to CALCULATED
		// on all cargos that are about to be fixtured.
		For li_count = 1 To uf_get_no_cargos()
			If ab_cargos[li_count] Then uf_set_status(li_count,5)
		Next
		
		// And save the calculation. The save process will automaticly handle to
		// calculated -> estimated copy.
		If not uf_save(false) Then
			MessageBox("Error", "Error saving calculated", StopSign!)
			Goto Stop
		End if
	Else
		// It's was an Fixtured or estimated calculation (FIXTURE_ID = 4 or 6),
		// which is not allowed to have additional fixes.
		MessageBox("Error", "It's not possible to fixture fixtured and estimated calculations", StopSign!)
		Goto Stop
	End if

Else
	// This calculation has not been fixtured before. Generate a new unique fixture 
	// ID for this calculation.
	lnv_get_maxvalue = create n_get_maxvalue
	ll_return = lnv_get_maxvalue.of_get_maxvalue(is_DOFIXTURE)
	destroy lnv_get_maxvalue
	
	if ll_return = c#return.Failure then
		_addmessage(this.classdefinition, "Error", "Cannot get the maximum value of Fixed ID in calculcation!", "", true)
		goto stop
	else
		ll_fix_id = ll_return
	end if

	// and set the (FIXTURE_ID +1) in the CAL_CALC table.
	uo_calc_summary.uf_set_fixture_id(ll_fix_id)

	lstr_parm.w_progress.wf_progress(0.7,"Saving fixture")

	// Loop through the AB_CARGOS array and set the status to FIXTURED 
	// on all cargos that are about to be fixtured.
	For li_count = 1 To uf_get_no_cargos()
		If ab_cargos[li_count] Then uf_set_status(li_count,4)
	Next

	// Update the local modified & calculated flags
	ib_modified = false
	ib_calculated = true

	// And save the calculation
	If not uf_save(false) Then
		MessageBox("Error", "Error saving fixture", StopSign!)
		Goto Stop
	End if

	// Now it's time to save the initial calculated calculation
	// Loop through the AB_CARGOS array and set the status to CALCULATED
	// on all cargos that are about to be fixtured.
	ll_fixture_calc_id = il_calc_id
	lstr_parm.w_progress.wf_progress(0.85,"Saving calculated")

	For li_count = 1 To uf_get_no_cargos()
		If ab_cargos[li_count] Then uf_set_status(li_count,5)
	Next

	ib_modified = false
	ib_calculated = true

	// and call UF_SAVEAS to have the calculation to be saved as a NEW
	// calculation.
	If not uf_saveas("",-1,false) Then
		MessageBox("Error", "Error saving calculated", StopSign!)
		Goto Stop
	End if

	// Now it's time to save the initial estimated calculation
	// Loop through the AB_CARGOS array and set the status to ESTIMATED
	// on all cargos that are about to be fixtured.
	lstr_parm.w_progress.wf_progress(0.95,"Saving estimated")

	For li_count = 1 To uf_get_no_cargos()
		If ab_cargos[li_count] Then uf_set_status(li_count,6)
	Next

	ib_modified = false
	ib_calculated = true

	// and call UF_SAVEAS to have the calculation to be saved as a NEW
	// calculation.
	If not uf_saveas("",-1,false) Then
		MessageBox("Error", "Error saving estimated", StopSign!)
		Goto Stop
	End if
End if

// Set modified to false and calculated to true
lb_result = true
ib_modified = false
ib_calculated = true

Stop:

// Close the progress
// and return the result.
Close(lstr_parm.w_progress)
uf_redraw_on()

Return(lb_result)
end function

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw off for this and all subojects

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


super::uf_redraw_off()
uo_calc_cargos.uf_redraw_off()
uo_calc_itinerary.uf_redraw_off()
uo_calc_summary.uf_redraw_off()
end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw on for this and all subojects

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uo_calc_summary.uf_redraw_on()
uo_calc_itinerary.uf_redraw_on()
uo_calc_cargos.uf_redraw_on()
super::uf_redraw_on()
end subroutine

public subroutine uf_load_speedlist ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 11-8-96

 Description : Retrieves speedlist if nessary. Returns without doing anything if
 					speedlist is already loaded.

 Arguments : none

 Returns   : none

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
11-8-96         3.0                     MI              Initial version  
************************************************************************************/

Long ll_vessel_type_id, ll_vessel_id, ll_clarkson_id, ll_count
String ls_tmp
s_speed lstr_speed

// Check if speedlist is already loaded, and exit if true
If UpperBound(iuo_calc_nvo.istr_speedlist[])>0 Then Return 

// Get VESSEL ID (either APM, VESSEL_TYPE og CLARKSON) and use it
// for retrieving the CAL_CONS entries for that vessel into the
// ISTR_SPEEDLIST array in the IUO_CALC_NVO object.
uf_get_vessel(ll_vessel_type_id,ll_vessel_id,ll_clarkson_id)

DECLARE speedcursor CURSOR FOR  
SELECT CAL_CONS_TYPE,  
	CAL_CONS_SPEED,   
	CAL_CONS_FO,   
	CAL_CONS_DO,   
	CAL_CONS_MGO   
FROM CAL_CONS  
WHERE (CAL_VEST_TYPE_ID = :ll_vessel_type_ID AND  
 VESSEL_NR = :ll_vessel_id AND  
 CAL_CLRK_ID = :ll_clarkson_id) ;   

OPEN speedcursor;

ll_count = 1
DO WHILE SQLCA.SQLCode =  0

	FETCH speedcursor 
	INTO :iuo_calc_nvo.istr_speedlist[ll_count].i_type,
		:iuo_calc_nvo.istr_speedlist[ll_count].d_speed,
		:iuo_calc_nvo.istr_speedlist[ll_count].d_fo,
		:iuo_calc_nvo.istr_speedlist[ll_count].d_do,
		:iuo_calc_nvo.istr_speedlist[ll_count].d_mgo;

	If SQLCA.SQLCode = 0 Then
		CHOOSE CASE iuo_calc_nvo.istr_speedlist[ll_count].i_type
			CASE 1
				ls_tmp = "Ballasted"
			CASE 2
				ls_tmp = "Loaded"
			CASE 3
				ls_tmp = "At Sea"
			CASE 4
				ls_tmp = "At port"
			CASE 5
				ls_tmp = "At port w/ gear"
		END CHOOSE      

		// Set the name of the speedtype, and round the speed to
		// 4 decimals to prevent the 13.99999999995 display
		iuo_calc_nvo.istr_speedlist[ll_count].s_name = ls_tmp 
		Round(iuo_calc_nvo.istr_speedlist[ll_count].d_speed,4)
		ll_count ++
	End if                  
LOOP

CLOSE speedcursor;
COMMIT;

// Clear the LAST entry in the ISTR_SPEEDLIST, since this one contains
// the last FETCH value (which is NULL).
iuo_calc_nvo.istr_speedlist[ll_count] = lstr_speed
	
end subroutine

public subroutine uf_create_progress (string as_title, ref s_calculation_parm astr_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Creates a progressbar with the title as_title, and stores the 
 					window reference in ASTR_PARM

 Arguments : as_title as string, astr_parm as s_calculation_parm

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------

************************************************************************************/

str_progress lstr_progress

lstr_progress.Title = as_title
lstr_progress.b_show_time = true
lstr_progress.b_show_ms = true
lstr_progress.b_no_auto_yield = true
openwithparm(astr_parm.w_progress,lstr_progress)

end subroutine

public subroutine uf_reload_speedlist ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Reloads the speedlist, by clearing the current speedlist
 					and calling uf_load_speedlist

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_speed lstr_speedlist[]
iuo_calc_nvo.istr_speedlist = lstr_speedlist // Clear speedlist

uf_load_speedlist()
end subroutine

public function long uf_get_calc_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the calculation ID

 Arguments : None

 Returns   : Calculation ID as Long

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_summary.uf_get_calc_id())
end function

public function boolean uf_get_ballast_voyage ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Returns status for ballast_voyage (0=normal voyage, 1 = ballast_voyage)

 Arguments : none

 Returns   : Integer

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

Return(uo_calc_summary.uf_get_ballast_voyage())

end function

public subroutine uf_set_ballast_voyage (boolean ab_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Sets ballast voyage status depending on AB_VALUE:
 					false = set to normal voyage
					true  = set to ballast voyage

 Arguments : AB_VALUE as boolean

 Returns   : None

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

// Ask user if he/she really wants to do this, if the user is going from normal
// calculation to ballast calculation
If ab_value Then
	If MessageBox("Warning", "Selecting ballast voyage will delete all load/discharge data~r~n~r~nContinue ?", Exclamation!, YesNo!)<>1 Then Return
End if

// Set the voyage type by calling UF_SET_BALLAST_VOYAGE in U_CALC_SUMMARY and U_CALC_CARGOS
uo_calc_summary.uf_set_ballast_voyage(ab_value)
uo_calc_cargos.uf_set_ballast_voyage(ab_value)
end subroutine

public function boolean uf_load_wizard (string as_name);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Loads the Wizard specified in as_name argument.

 Arguments : as_name as string

 Returns   : True if OK.  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If uo_calc_wizard.uf_load_wizard(as_name) Then
	// If we can load the Wizard, then make the cargos, itinerary and summary pages
	// invisible and set the IB_WIZARD flag to true
	
	uo_calc_cargos.visible = false
	uo_calc_itinerary.visible = false
	uo_calc_summary.visible = false
	ib_wizard = true
End if

Return(ib_wizard)

end function

public function boolean uf_get_wizard ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns true if the Wizard is currently in use.

 Arguments : True

 Returns   : True if Wizard is in use  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(ib_wizard)
end function

public function integer uf_get_no_cargos ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the number of cargoes on the calculation

 Arguments : None

 Returns   : No. of cargoes as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_no_cargos())

end function

public function string uf_get_loadport_name (ref s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit Aunt
   
 Date       : 1997

 Description : Returns portname for cargo and port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_loadport_name(astr_port_parm))
end function

public function string uf_get_dischport_name (ref s_port_parm astr_port_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit Aunt
   
 Date       : 1997

 Description : Returns portname for cargo and port specified in astr_port_parm

 Arguments : astr_port_parm

 Returns   : Portname

************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_dischport_name(astr_port_parm))
end function

public function boolean uf_set_wizard (boolean ab_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Exits wizard mode if AB_VALUE is false

 Arguments : AB_VALUE as boolean

 Returns   : True if Wizard mode was exited

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/
Boolean lb_result

lb_result = false

// Check that AB_VALUE is false, and the Wizard is already active (IB_WIZARD = TRUE)
If (ab_value=false) And (ib_wizard) Then
	uf_redraw_off()

	// Deactivate the wizard to move data to the calculation and cargo screens,
	// and make the U_CALC_CARGOS, U_CALC_ITINERARY and U_CALC_SUMMARY pages
	// visible. Finally select page 1 (summary)

	If uo_calc_wizard.uf_deactivate()=1 Then
		uo_calc_cargos.visible = true
		uo_calc_itinerary.visible = true
		uo_calc_summary.visible = true
		ib_wizard = false

		uf_select_page(1)
		lb_result = true
	end if
	
	uf_redraw_on()
End if

Return(lb_result)
end function

public function integer uf_get_rate_type (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the RATE_TYPE for specified cargo (AI_CARGO_NO)

 Arguments : AI_CARGO_NO as integer

 Returns   : RATE_TYPE as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_rate_type(ai_cargo_no))
end function

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the uf_deactivate, by deactivating the current page.

 Arguments : None

 Returns   : True if ok (page could be deactivated)  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Default result to true, later set it to the deactivate result from the page
Integer li_result
li_result = 1

If ib_wizard Then
	// Page 1,2 and 3 (normally summary, itinerary and cargo pages) all refers to 
	// the main Wizard page when running the Wizard.
	CHOOSE CASE ii_current_page
		CASE 1,2,3
			li_result = uo_calc_wizard.uf_deactivate()
		CASE 4
			li_result = uo_calc_result.uf_deactivate()
	END CHOOSE
Else    
	CHOOSE CASE ii_current_page
		CASE 1
			li_result = uo_calc_summary.uf_deactivate()
		CASE 2
			li_result = uo_calc_itinerary.uf_deactivate()
		CASE 3
			li_result = uo_calc_cargos.uf_deactivate()      
		CASE 4
			li_result = uo_calc_result.uf_deactivate()
	END CHOOSE
End if

Return li_result

end function

public function long uf_get_fix_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the FIXTURE_ID for the current calculation

 Arguments : None

 Returns   : FIXTURE_ID as Long  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


// Returns fixture ID

Return(uo_calc_summary.dw_calc_summary.GetItemNumber(1,"cal_calc_fix_id"))
end function

public function boolean uf_calculate_with_parm (ref s_calculation_parm astr_parm); /************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 8-7-96

 Description : Calculates the calculation. Same as UF_CALCULATE, but by calling this
 					function you can pass (and receive) the ASTR_PARM array by yourself.
 
 					Se uf_process for further description

 Arguments : Astr_parm as REF

 Returns   : True if OK  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
15/03/16      CR4114    SSX014   Remove Yield() to avoid crashing
************************************************************************************/

Boolean lb_result

// Create a progressbar and store the reference to it in ASTR_PARM
uf_create_progress("Calculating", astr_parm)

// Do pre-calculation and check by calling uf_process 
this.uf_redraw_off()

lb_result = uf_process(astr_parm, true) 
astr_parm.w_progress.wf_progress(0.9,"Updating...")

// Close the progress bar
Close(astr_parm.w_progress)

this.uf_redraw_on()

// Show error if returned by the calculation, and we're not doing a
// "silent" (=no messages) calculation
If Not lb_result Then
	If not astr_parm.b_silent_calculation Then &
	MessageBox("Calculate error", "The calculation could not be completed: ~r~n~r~n"+astr_parm.result.s_errortext, StopSign!)
End if

// The w_calc_explanation windows was for internal used, and is not enabled
// in the user-version. Anyway, this code shows the explanation window if it's
// enabled.
If (astr_parm.s_explanation<>"") And (not astr_parm.b_silent_calculation) Then
	OpenWithParm(w_calc_explanation, astr_parm.s_explanation)
End if

Return(lb_result)
end function

public subroutine uf_set_cerp_id (integer ai_cargo_no, long al_cerp_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the C/P ID given in AL_CERP_ID to the cargo given in 
 					AI_CARGO_NO

 Arguments : ai_cargo_no as integer, al_cerp_id as long

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calc_cargos.uf_set_cerp_id(ai_cargo_no,al_cerp_id)
end subroutine

public function long uf_get_cargo_id ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the cargo ID for current cargo.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_cargo_id())
end function

public function boolean uf_unlock ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-5-97

 Description : Unlocks the calculation (if locked due to locking from 
 					proceeding/POC/Cargo)

					This function should only be available to administrators

 Arguments : None

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
5-5-97		4.05			MI		Initial version  
************************************************************************************/

// Unlock the summary, cargo and itinerary pages
uo_calc_cargos.uf_unlock()
uo_calc_summary.uf_unlock()
uo_calc_itinerary.uf_unlock()

Return true
end function

public subroutine uf_insert_new_id (ref double d_caio_id_old[], ref double d_caio_id_new[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit Aunt (i think)
   
 Date       : 1997

 Description : Used to give the port expensesw the new calculation id when the Save as
 					functionality is used on a calculation.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
1-5-97	1.0		TA		Initial version
************************************************************************************/
// Variable declaration
double ld_max
long ll_count

ld_max = UpperBound(d_caio_id_old[])
ll_count = 1

// Arrays start at 0 so add 1 to the counter
DO  WHILE ll_count < ld_max + 1
	INSERT CAL_PEXP
	SELECT
		:d_caio_id_new[ll_count] as CAL_CAIO_ID,
		CAL_PEXP_AMOUNT,
		CAL_PEXP_DESCRIPTION,
		CAL_PEXP_ORDER
	FROM CAL_PEXP
	WHERE CAL_CAIO_ID = :d_caio_id_old[ll_count];
	COMMIT;
	ll_count ++
LOOP
end subroutine

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

Return(uo_calc_cargos.uf_get_lport_name_purpose(astr_port_parm))
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


Return(uo_calc_cargos.uf_get_dport_name_purpose(astr_port_parm))
end function

public function integer uf_get_first_loadport ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the first loadport from the Calculation

 Arguments : None

 Returns   : First loadport as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Return(uo_calc_cargos.uf_get_first_loadport())
end function

public function integer uf_get_no_dischports (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the number of dischports for specified cargo (AI_CARGO_NO)

 Arguments : AI_CARGO_NO as integer

 Returns   : No. of dischports as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_no_dischports(ai_cargo_no))
end function

public function integer uf_get_no_loadports (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the number of loadports for specified cargo (AI_CARGO_NO)

 Arguments : AI_CARGO_NO as integer

 Returns   : No. of loadports as integer  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(uo_calc_cargos.uf_get_no_loadports(ai_cargo_no))
end function

private function integer uf_get_revers_freight (integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the reversible freight for specified cargo (AI_CARGO_NO)

					NOTE: This function has been marked PRIVATE and can probably
					be deleted, since it's not referenced anywhere

 Arguments : AI_CARGO_NO as integer

 Returns   : Reversible freight as integer

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

int li_tmp
li_tmp = uo_calc_cargos.uf_get_revers_freight(ai_cargo_no)
return(li_tmp)
end function

public function integer uf_get_reversible (long al_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the reversible status for cargo # given in al_cargo_no

 Arguments : al_cargo_no 

 Returns   : Reversible status

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

integer li_int
li_int = uo_calc_cargos.uf_get_reversible(al_cargo_no)
Return(li_int)
end function

public function boolean uf_save (boolean ab_showprogress);/************************************************************************************

 Author    : MIS
   
 Date       : 1996

 Description : Saves the calculation, by calling all uf_save in subobjects in 
 					U_CALC_SUMMARY and U_CALC_CARGO subobjects. 

 Arguments : AB_SHOWPROGESS should be true if the progress bar is to be updated

 Returns   : True if OK

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_result
lb_result = false
s_calculation_parm lstr_parm
Integer li_page
Long ll_fix_id, ll_estimated_calc_id
Long ll_current_cargo
String ls_firstport, ls_lastport

// Check if this calculation is calculated. If not, then force a re-calculation if
// type is estimated or calculated (UF_GET_STATUS>4), otherwise ask for user if
// he/she wants to recalc the calculation before save
If not ib_calculated Then

// CHANGE REQUEST 672 implemented 10. august 2005
//	If uf_get_status(0)>4 Then
//		// It's an estimated or calculated so force calculation
		If not uf_calculate() Then Return(false)
//	Else
//		// Ask user if the calculation should be recalculated.
//		If MessageBox("Notice", "This calculation have not been calculated, do you wish to calculate before saving", Question!, YesNo!, 1) = 1 Then
//			If not uf_calculate() Then Return(false)
//		End if
//	End if
End if

// Check that distance is above zero for estimated and calculated calculations, since it
// most probably is due to some kind or error
If (uf_get_status(0)>=4) And (uo_calc_summary.uf_total_distance()=0) Then
	If MessageBox("Warning", "Total distance is calculated to zero.~r~n~r~nThis might invalid, do you wish to continue ?~r~n~r~n", Exclamation!, YesNo!) <> 1 Then Return(false)
End if

// Ok, start the saving process. Set the pointer and turn redraw off.
This.Pointer="Hourglass!"
uf_redraw_off()

// Remember current page and cargo
li_page = ii_current_page
ll_current_cargo = uf_get_cargo()

// and start the saving process: Setup the LSTR_PARM (S_CALCULATION_PARM) structure,
// create the progress window and call UF_PROCESS to validate data for saving.
lstr_parm.i_function_code = 1
If ab_showprogress Then uf_create_progress("Saving", lstr_parm)
lb_result = uf_process(lstr_parm, false) 

// Goto stop if any errors
If not lb_result Then Goto Stop

// Get the first and last port and insert the values into the U_CALC_SUMMARY. These
// fields will appear on the calculation manager as first and last ports.
If uo_calc_summary.uf_get_ballast_voyage() = True Then
	ls_firstport = uo_calc_summary.dw_calc_summary.GetItemString(1,"cal_calc_ballast_from")
	ls_lastport = uo_calc_summary.dw_calc_summary.GetItemString(1,"cal_calc_ballast_to")
Else
	// The cargo window is not active on a ballast voyage calculation.
	uo_calc_cargos.uf_get_firstlast_port(ls_firstport, ls_lastport)
End if

uo_calc_summary.uf_set_firstlast_port(ls_firstport, ls_lastport)

If ab_showprogress Then lstr_parm.w_progress.wf_progress(0.7, "Saving calculation..")

// If this is a calculated calculation (status = 5), then 
// we also needs to update the corrosponding estimated calculation.
If uf_get_status(0)=5 Then
	// Get the FIXTURE_ID, and use it to retrive the CALC_ID for the
	// estimated calculation.
	
	ll_fix_id = uo_calc_summary.uf_get_fixture_id()

	If ll_fix_id > 0 Then
		SELECT CAL_CALC_ID
		INTO :ll_estimated_calc_id
		FROM CAL_CALC
		WHERE (CAL_CALC_FIX_ID = :ll_fix_id AND
				CAL_CALC_STATUS = 6);
	End if

	If IsNull(ll_estimated_calc_id) Then ll_estimated_calc_id = 0
End if

// Call UF_SAVE in the U_CALC_SUMMARY object, passing the LL_ESTIMATED_CALC_ID
// LL_ESTIMATED_CALC_ID will be 0 for other than calculated calculations.
if uo_calc_summary.uf_save(ll_estimated_calc_id) Then
 
 	// Get the CALC_ID, which is needed to tie the new cargos together
	// with this calculation (which is a calculated calc.) - validate that it ain't zero.
	il_calc_id = uo_calc_summary.uf_get_calc_id()

	If il_calc_id = 0 Then
		// There's really nothing to do, if it's zero....
		MessageBox("System error", "illegal calculation ID, please contact the system supervisor", StopSign!)
		uf_select_page(1)
		lb_result = false
	Else
		If ab_showprogress Then lstr_parm.w_progress.wf_progress(0.8, "Saving cargos..")

		// Save the cargos with the IL_CALC_ID and ESTIMATED_CALC_ID. If it 
		// goes OK, then reset update flags, and re-retrieve the calculation,
		// to ensure all fields looks the way it's stored in the database.
		If uo_calc_cargos.uf_save(il_calc_id,false,ll_estimated_calc_id) Then

			COMMIT USING SQLCA;

			ib_modified = false
			uf_resetflags()
			lb_result = True

			If ab_showprogress Then lstr_parm.w_progress.wf_progress(1, "Updating..")

			// retrieve the data back from the database
			uf_retrieve(il_calc_id)

			// and select the cargo and page we had before. Calling UF_SELECT_CARGO
			// with zero as the parameter, will make the calculation system "forget"
			// which cargo is the currently active. This is needed to update 
			// everthing as we want it to be updated now (UF_SELECT_CARGO will not
			// do anything if we ask it to shift from cargo #1 to cargo #1).
			uf_select_cargo(0)  
			uf_select_cargo(ll_current_cargo)

			uf_select_page(li_page)
		Else
			// Save failed, now try to restore the original ID's
			uo_calc_cargos.uf_restore_id()
			
			// And select the cargo page since the fault probably was connected
			// to this page
			uf_select_page(3)
			lb_result = false
		End if
	End if
Else
	// Select the cargo page since the fault probably was connected to this page
	uf_select_page(1)
	lb_result = false
End if

// ROLLBACK if save failed
If not lb_result then 
	ROLLBACK USING SQLCA;
	Goto Stop
End if

// COMMIT if save succeced
lb_result = true
COMMIT USING SQLCA;

Stop:

// If one of the UF_PROCESS or UF_SAVE or other routines exited with an error,
// there might not be an active cargo (ii_current_cargo = -1), to avoid showing
// all cargos (and ports) mixed together on the same screen, select cargo 1,
// if none is selected.
If uf_get_cargo()<1 Then uf_select_cargo(1)

// Close the progress window,
If ab_showprogress Then Close(lstr_parm.w_progress)

// Show what errors there might have been (if any)
If not lb_result Then
	MessageBox("Save error", "Error saving calculation: ~r~n~r~n" + lstr_parm.result.s_errortext, StopSign!)
End if

// Cleanup and exit!
This.Pointer="Arrow!"
uf_redraw_on()
Return(lb_result)
end function

public function boolean uf_calculate (); /************************************************************************************
 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
 Date       : 8-7-96
 Description : Main entry point for starting a calculation.
 
 					See UF_CALCULATE_WITH_PARM for further description.
					 
 Arguments : none

 Returns   : True if ok  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

s_calculation_parm lstr_parm

lstr_parm.i_function_code = 2

Return(uf_calculate_with_parm(lstr_parm))


end function

public subroutine uf_delete ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : uf_delete calls either uf_delete_cargo (if we're on page 1) or
 					uf_delete (if we're on page 2) or uf_delete_port (if we're on page 3).

					NOTICE: Use this function with case, since it automaticaly deletes
					the ACTIVE VISUAL, eg. if the focus is on a viapoint in the 
					itinerary window, then this function will delete that viapoint. 

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long li_cargo_no
String ls_tmp
long ll_retval
string ls_dwname
u_datawindow_sqlca	ldw

// Call uf_delete_xxxx on appropriate sub-object, except for U_CALC_SUMMARY (page 1),
// which has explicit handling here:
CHOOSE CASE ii_current_page
	CASE 1
		If uf_get_no_cargos() = 1 Then
			MessageBox("Error", "You cannot delete the last cargo", StopSign!)
		ELSE	
			// Check the status of the cargo that is about to be deleted. Cargos
			// with a status of fixture (4) or above, must not be deleted. Otherwise
			// display a messagebox requesting the user to acknowledge the deletion.
		
			li_cargo_no = uo_calc_summary.dw_calc_summary_list.GetRow()
			ls_tmp = uf_get_description(li_cargo_no)
			
			If uf_get_status(li_cargo_no)>=4 Then
				MessageBox("Error", "You cannot delete an fixtured cargo")
				Return
			End if

			If MessageBox("Warning", "You are about to delete cargo "+ls_tmp+" ~r~n~r~nContinue ?", Exclamation!, YesNo!, 2) = 1 Then
				// Delete the cargo, set current cargo to the prior cargo, and
				// trigger an UE_CHILDMODIFIED and UE_PORT_CHANGED event
				
				uo_calc_cargos.uf_delete_cargo(li_cargo_no)
				If li_cargo_no > 1 Then li_cargo_no --
				uo_calc_cargos.uf_select_cargo(li_cargo_no)
				
				TriggerEvent("ue_childmodified")
				TriggerEvent("ue_port_changed")
			End if
		End if
	CASE 2
		uo_calc_itinerary.uf_delete()
	CASE 3,5
		if ii_current_page = 3 then
			ll_retval = uo_calc_cargos.of_getdatawindowfocus( ldw, ls_dwname)
		else
			ll_retval = uo_calc_compact.of_getdatawindowfocus( ldw, ls_dwname)
		end if	
		
		if ll_retval = c#return.Success then
			CHOOSE CASE ls_dwname
				CASE "dw_dischports", "dw_loadports"
					uo_calc_cargos.of_deleteport(ldw)
				CASE "dw_calc_lumpsum"
					uo_calc_cargos.of_deletelumpsum(ldw)
			END CHOOSE	
		end if	
END CHOOSE

end subroutine

public function boolean uf_process (ref s_calculation_parm astr_parm, boolean ab_setresult);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1-8-96

 Description : The uf_process is used upon saving, calculation and fixturing. 
 The reason for using the same function for all those tasks, is that they are 
 closely related; What's required upon save, is also requiered during calculation and 
 fixture, and what's required during fixture, is also required during calculation.
 It is also used for validation prior to the sensitivity analysis.

 In generel, uf_process is fired as a 3/4-step phase:

	Phase 1: uf_process for uo_calc_summary (validation and dataprocessing for general 
				calculation stuff).
	Phase 2: uf_process for uo_calc_cargos (as for summary).
	Phase 3: uf_process for uo_calc_itinerary (as for summary).
	Phase 4 (Calculation and fixture only): u_nvo_calculation for doing the calculation.

 Each phase stores data to s_calculation_parm structure; eg. the uo_calc_summary phase 
 stores information about the vessel, uf_calc_cargos stores information about each 
 cargo (and ports), uf_calc_itinerary stores information about the distances etc. etc.
 See the individual objects for details.

 Upon completion of phase 1-3, this structure contains all data needed for the final 
 calculation, which is done by the u_nvo_calculation object.

 If youre whant to find where a particular information is stored, look in the function
 uf_process for that dataset, e.g. u_calc_cargos uf_process.
 
 The arguments is ASTR_PARM which is used to transfer all calculation data around,
 and AB_SETRESULT should be true if the result should be stored back to the
 calculation.

 Function codes: 1 for save, 2 for calculate and 3 for fixture.
 
 Arguments : astr_parm as s_calculation_parm, ab_setresult as Boolean

 Returns   : True if ok  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
  
************************************************************************************/

Boolean lb_result, lb_updateprogress
Integer li_count, li_current_cargo
u_nvo_calculator uo_nvo_calculator

// Check to see if we should update the progress bar
lb_updateprogress = IsValid(astr_parm.w_progress)

// Set the pointer to hourglass, turn redraw off and get current cargo
This.Pointer="Hourglass!"
This.uf_redraw_off()
li_current_cargo = uf_get_cargo()

// Set the default result to true
lb_result = true

// Load speedlist if this is a calculation or above (we don't need the
// speedlist just for saving)
If astr_parm.i_function_code > 1 Then uf_load_speedlist()  

// If in Wizard mode, then deactivate it, so that data gets transferred from
// the Wizard to the calculation.
If ib_wizard Then 
	lb_result = uo_calc_wizard.uf_deactivate() = 1 
End if

// Store any other changes there might be (Itinerary could be 
// the only object having data by this time).
uo_calc_itinerary.uf_deactivate() 

// Setup the ASTR_PARM structure with speedlist, ballastvoyage information
// etc. etc.
astr_parm.speedlist = iuo_calc_nvo.istr_speedlist
astr_parm.b_ballastvoyage = uf_get_ballast_voyage()
astr_parm.i_nospeeds = UpperBound(iuo_calc_nvo.istr_speedlist)
If lb_updateprogress Then astr_parm.w_progress.wf_progress(0.15,"Checking calculation")

// Ok, start processing in the UO_CALC_SUMMARY. If there's any errors then
// select this page and exit this process
If lb_result Then
	If not uo_calc_summary.uf_process(astr_parm) Then

		uf_select_page(1)
		lb_result = false
	
	End if
End if

If lb_updateprogress Then astr_parm.w_progress.wf_progress(0.30,"Checking cargos")

// If all is OK, then continue processing in the UO_CALC_CARGOS. 
// If there's any errors then select this page and exit this process
If lb_result Then
	If not uo_calc_cargos.uf_process(astr_parm) Then

		uf_select_page(3)
		lb_result = false

	End if
End if

If lb_updateprogress Then astr_parm.w_progress.wf_progress(0.50,"Checking itinerary")

// If all is OK, then continue processing in the UO_CALC_ITINERARY. 
// If there's any errors then select this page and exit this process
If lb_result Then
	If not  uo_calc_itinerary.uf_process(astr_parm, uo_calc_cargos.dw_loadports, &
								uo_calc_cargos.dw_dischports) Then

		uf_select_page(2)
		lb_result = false

	End if
End if

// If everything is OK (lb_result is true) and I_FUNCTION_CODE > 1 (=calculation
// or fixture) then call the u_nvo_calculator to do the actual calculation
If (astr_parm.i_function_code>1) And (lb_result) Then

	If lb_updateprogress Then astr_parm.w_progress.wf_progress(0.65,"Calculating")
	
	uo_nvo_calculator = CREATE u_nvo_calculator

	// IB_NO_WS_RELOAD is only used during RECALC, where we want to check the
	// calculation without recalculating the WS-route/rate. If the IB_NO_WS_RELOAD
	// is false then recalc the WS route/rate
	If not ib_no_ws_reload Then
		If not uo_nvo_calculator.uf_cal_worldscale_route(astr_parm) Then
			//astr_parm.result.s_errortext = "Unable to calculate WS"
			lb_result = false
		End if	
	End if

	// Ok, Now calculate!
	If lb_result Then lb_result = uo_nvo_calculator.uf_calculate(astr_parm)
	DESTROY uo_nvo_calculator

	If lb_updateprogress Then astr_parm.w_progress.wf_progress(0.70,"Calculating")

	// If calculation went well, and we're supposed to store the results,
	// then do it here. Insert into the result window
	If (lb_result)  And (ab_setresult) Then
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_gross_freight", astr_parm.result.d_gross_freight)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_misc_income", astr_parm.result.d_misc_income)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_commission", astr_parm.result.d_commission)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_adr_commission", astr_parm.result.d_adr_commission)   

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_miles_ballasted", astr_parm.d_miles_ballasted)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_miles_loaded", astr_parm.d_miles_loaded)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_loaded", astr_parm.d_minutes_loaded / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_ballasted", astr_parm.d_minutes_ballasted / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_days_laden", astr_parm.result.d_add_minutes_laden / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_days_ballasted", astr_parm.result.d_add_minutes_ballasted/ 1440)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_loading", astr_parm.result.d_load_minutes / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_discharging", astr_parm.result.d_disch_minutes / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_laytime", astr_parm.result.d_total_laytime/ 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_port", astr_parm.result.d_minutes_in_port/ 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_days_chanal", astr_parm.result.d_minutes_in_canal / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_days", astr_parm.result.d_minutes_total / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_other_days", astr_parm.result.d_add_minutes_other / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_bunkering_days", astr_parm.result.d_add_minutes_bunkering / 1440)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_idle_days", astr_parm.result.d_add_minutes_idle / 1440)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_add_dok_days", astr_parm.result.d_dok_minutes / 1440)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_demurrage", astr_parm.result.d_demurrage / 1440)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_fo_total", astr_parm.result.d_fo_units)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_do_total", astr_parm.result.d_do_units)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_mgo_total", astr_parm.result.d_mgo_units)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_fo_expenses", astr_parm.result.d_fo_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_do_expenses", astr_parm.result.d_do_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_mgo_expenses", astr_parm.result.d_mgo_expenses)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_chanal_expenses",astr_parm.result.d_canal_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_port_expenses",astr_parm.result.d_port_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_misc_expenses",astr_parm.result.d_misc_add_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_expenses", astr_parm.result.d_total_expenses)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_total_costs", astr_parm.result.d_total_costs)

		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_net_day", astr_parm.result.d_net_day)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_gross_day", astr_parm.result.d_gross_day)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_after_drc_oa", astr_parm.result.d_after_drc_oa)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_after_drc_oa_cap", astr_parm.result.d_after_drc_oa_cap)
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_tc_eqv", astr_parm.result.d_tc_eqv)

		// Update data for each cargo (flatrate etc).
		For li_count = 1 to astr_parm.i_no_cargos
			If (astr_parm.cargolist[li_count].i_rate_type = 4 And astr_parm.cargolist[li_count].i_local_flatrate = 0 )Then 
				uo_calc_cargos.dw_cargo_summary.SetItem(li_count, "cal_carg_flatrate", astr_parm.cargolist[li_count].d_flatrate)
			End if

			if IsNull(astr_parm.cargolist[li_count].d_local_gross_freight) Then astr_parm.cargolist[li_count].d_local_gross_freight= 0
			uo_calc_cargos.dw_cargo_summary.SetItem(li_count, "cal_carg_cal_carg_total_gross_freight", astr_parm.cargolist[li_count].d_local_gross_freight)
			If IsNull(astr_parm.cargolist[li_count].d_demurrage) Then astr_parm.cargolist[li_count].d_demurrage=0
			uo_calc_cargos.dw_cargo_summary.SetItem(li_count, "cal_carg_cal_carg_total_demurrage", astr_parm.cargolist[li_count].d_demurrage/1440)
			If IsNull(astr_parm.cargolist[li_count].d_despatch) Then astr_parm.cargolist[li_count].d_despatch=0
			uo_calc_cargos.dw_cargo_summary.SetItem(li_count, "cal_carg_cal_carg_total_despatch", astr_parm.cargolist[li_count].d_despatch/1440)
			uo_calc_cargos.dw_cargo_summary.SetItem(li_count, "cal_carg_cal_carg_total_commission", astr_parm.cargolist[li_count].d_broker_comm + astr_parm.cargolist[li_count].d_adrs_comm)
		Next
	End if
End if

// Turn cursor and redraw back to default
This.Pointer="Arrow!"
This.uf_redraw_on()

// Select result page
If lb_result then
	 uf_select_page(4)
end If

// and select right cargo - we're done
If uo_calc_cargos.ii_current_cargo = -1 Then
	uo_calc_cargos.uf_select_cargo(1)
End if

If (lb_result) And astr_parm.i_function_code >= 2 Then 
	ib_calculated = true
	TriggerEvent("ue_calc_changed")
End if

Return(lb_result)
	

end function

public subroutine uf_select_page (integer ai_pageno);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the page given in AI_PAGENO, where
 					1 = Summary (or Wizard page if in Wizard mode)
					2 = Itinerary (or Wizard page if in Wizard mode)
					3 = Cargo (or Wizard page if in Wizard mode)
					4 = Result
					
 Arguments : AI_PAGENO as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// If new pageno <> currentpage then select new page, by bringing it to top

Integer li_result

If ai_pageno <> ii_current_page Then
	// Turn ANCESTOR redraw off before deactivating the current page
	// (the ANCESTOR is used to prevent screen-flicking
	Super::uf_redraw_off()

	li_result = uf_deactivate()

	if li_result <> 1 Then
		// exit if any errors, but turn redraw on before
		super::uf_redraw_on()
		Return
	End if  

	// Now activate the page given in AI_PAGENO
	If ib_wizard Then
		CHOOSE CASE ai_pageno
			CASE 1,2,3      
				uo_calc_wizard.uf_activate()
			CASE 4
				uo_calc_result.uf_activate()
		END CHOOSE
	Else
		CHOOSE CASE ai_pageno
			CASE 1
				uo_calc_summary.uf_activate()
			CASE 2
				// Always load the speedlist if activating the itinerary page.
				uf_reload_speedlist()
				//uf_load_speedlist()
				uo_calc_itinerary.uf_activate()
			CASE 3
				// Always load the speedlist if activating the Cargo page.
				uf_reload_speedlist()
				//uf_load_speedlist()
				uo_calc_cargos.uf_activate()
			CASE 4
				uo_calc_result.uf_activate()
		END CHOOSE
	End if

	// Set the requested page as the curremt
	ii_current_page = ai_pageno

	// Notify parent that current page is changed
	TriggerEvent("ue_page_changed",ii_current_page,0)

	super::uf_redraw_on()
End if


end subroutine

public subroutine uf_set_vessel (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the vessel given in either 
 					AL_VESSEL_TYPE_ID (for vessel-types)
					AL_VESSEL_ID (for APM vessels)
					AL_CLARKSON_ID (for clarkson vessels)

 Arguments : al_vessel_type_id, al_vessel_id, al_clarkson_id as Long

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Variables
boolean lb_clear_itinerary = True

// Call uf_set_vessel in uo_calc_summary

uo_calc_summary.uf_set_vessel(al_vessel_type_id,al_vessel_id,al_clarkson_id)
uf_reload_speedlist()

// Clear contents of Itinerary window
uo_calc_itinerary.uf_clear_cache(lb_clear_itinerary)

// Update Laden/Ballast speed to match new vessel
uo_calc_cargos.uf_update_speed()

// and update vesseldata if running the Wizard (since it might display some
// vessel-specific data
If ib_wizard Then
	uo_calc_wizard.uf_load_vesseldata()
End if

end subroutine

public subroutine uf_print_preview ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Passed the calculation datawindows on the the w_calc_invisible_print
 					window, that takes care of the printout

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_print lstr_calc_print

lstr_calc_print.dw_calc = uo_calc_summary.dw_calc_summary
lstr_calc_print.dw_cargos = uo_calc_cargos.dw_cargo_summary

// Ask Itinerary to retrieve it's data, since data might not be there
// otherwise
uo_calc_itinerary.dw_calc_itinerary.uf_redraw_off()
uo_calc_itinerary.uf_retrieve()
lstr_calc_print.dw_calc_itinerary = uo_calc_itinerary.dw_calc_itinerary
uo_calc_itinerary.dw_calc_itinerary.uf_redraw_on()

// And open the print window
OpenSheetWithParm(w_calc_preview_print,lstr_calc_print,w_tramos_main)
//OpenWithParm(w_calc_preview_print,lstr_calc_print,w_tramos_main)
end subroutine

public function boolean uf_sensitivity (integer ai_function_code, integer ai_cargo_no[], ref s_calc_sensitivity astr_calc_sensitivity, character ac_load_disch, integer ai_port_no, ref s_calculation_parm astr_calc_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Teit Aunt/Martin Israelsen
   
 Date       : 15-8-96

 Description : Gets the input data from a calculation, inserts the variable data into
 					the calculation and restores the calculation to the original values.

 Arguments : ai_function_code: 0 = Request parameter data (rate, lumpsum etc), 
 										 1 = perfom calculation with data.
				 ai_cargo_no[]: number of cargo to be sentesized.
				 s_calc_sensitivity REF. Data passed and returnd in this structure.
				 astr_calc_sensitivity holds the basic calculation parameters.
				 ac_load_disch indicate wether it is a load or a disch port.
				 ai_port_no holds the number of the port being investigated.
				 astr_calc_parm holds the parameters used in the calculation for the
				 	whole calculation incl. cargoes and ports.

 Returns   : True if calculation ok

*************************************************************************************
Development Log 
DATE       VERSION     NAME   DESCRIPTION
Aug 96		1.0			TA		The basic form
16-5-97		2.0			TA		It now handles more than one cargo
************************************************************************************/

// Declare variables
s_calculation_parm lstr_parm
Double ld_loadrate, ld_dischrate, ld_despatch, ld_fo_price
Double ld_no_load_ports, ld_no_disch_ports, ld_tmp
Double ld_rate[], ld_lumpsum[], ld_worldscale[]
Boolean lb_result, lb_get_data
Double d_null_array[10,7], d_load_original[10,7], d_disch_original[10,7]
int li_tmp, li_max

// Initiate variables 
lb_get_data = true

// Get the variables in the calculation that a sensitivity analysis can be done on
li_max = UpperBound(ai_cargo_no[])
If ai_function_code = 0 Then
	For li_tmp = 1 To  li_max
		
		// Get rate, lumpsum and worldscale
		astr_calc_sensitivity.d_rate[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber &
								(ai_cargo_no[li_tmp],"cal_carg_freight_rate")
		astr_calc_sensitivity.d_lumpsum[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber &
								(ai_cargo_no[li_tmp],"cal_carg_lumpsum")
		astr_calc_sensitivity.d_worldscale[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber &
								(ai_cargo_no[li_tmp],"cal_carg_ws_rate")
		astr_calc_sensitivity.d_fo_price[li_tmp] = uo_calc_summary.dw_calc_summary.GetItemNumber &
								(1,"cal_calc_fo_price")
	
		// Get the quantity of the load ports 
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
	
		ld_no_load_ports = uo_calc_cargos.dw_loadports.RowCount()
		astr_calc_sensitivity.d_load_quantity[]  = d_null_array[]
		For ld_tmp = 1 to ld_no_load_ports
			astr_calc_sensitivity.d_load_quantity[ld_tmp,li_tmp] = &
					uo_calc_cargos.dw_loadports.GetItemNumber(ld_tmp,"cal_caio_number_of_units")
		Next
	
		// Get the quantity of the dish ports
		ld_no_disch_ports = uo_calc_cargos.dw_dischports.RowCount()
		astr_calc_sensitivity.d_disch_quantity[] = d_null_array[]
		For ld_tmp = 1 to ld_no_disch_ports
			astr_calc_sensitivity.d_disch_quantity[ld_tmp,li_tmp] = &
					uo_calc_cargos.dw_dischports.GetItemNumber(ld_tmp,"cal_caio_number_of_units")
		Next
	
		// Get load rate or disch rate from the selected port
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// Get loadport if there is a valid port number
		If  ac_load_disch = "l" And ai_port_no > -1 Then
			// If the calculated rate > 0 then use it
			If uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
											> 0 Then
				astr_calc_sensitivity.d_loadrate[li_tmp] = &
					uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated")
			Else
				// The calculated rate is 0 so use the estimated rate
				astr_calc_sensitivity.d_loadrate[li_tmp] = &
					uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_rate_estimated")
			End If
			// This is a loadport so set the dischrate to 0
			astr_calc_sensitivity.d_dischrate[li_tmp] = 0
			// Get the despatch amount
			astr_calc_sensitivity.d_despatch[li_tmp] = &
					uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_despatch")

		// Get the dischport rate if there is a valid port number
		ElseIf ac_load_disch = "d" And ai_port_no > -1 Then
			// If there is a calculated rate then use it
			If uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
											> 0 Then
				astr_calc_sensitivity.d_dischrate[li_tmp] = &
					uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated")
			Else
				// The calculated rate is 0 so use the estimated rate
				astr_calc_sensitivity.d_dischrate[li_tmp] = &
					uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_rate_estimated")
			End If
			// This is a dischport so set the loadrate to 0
			astr_calc_sensitivity.d_loadrate[li_tmp] = 0
			// Get the despatch amount
			astr_calc_sensitivity.d_despatch[li_tmp] = &
					uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_despatch")
		Else
			// There is no load or disch port
			astr_calc_sensitivity.d_dischrate[li_tmp] = 0
			astr_calc_sensitivity.d_loadrate[li_tmp] = 0
			astr_calc_sensitivity.d_despatch[li_tmp] = 0 
		End If
	Next
	Return(true)
End if

// Save present calculation values and insert the new values 
For li_tmp = 1 To  li_max
	// Validate that the cargoes exist
	If (ai_cargo_no[li_tmp] < 1) or (ai_cargo_no[li_tmp] > uf_get_no_cargos()) Then
		MessageBox("Error", "Cannot calculate sensitivity for cargo #"+String(ai_cargo_no[li_tmp]))
		Return(False)
	End if

	// Save the present rate for the calculation and insert the new one
	If Not IsNull(astr_calc_sensitivity.d_rate[li_tmp]) and &
							(astr_calc_sensitivity.s_variable_name = "Rate") Then							
		ld_rate[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber(ai_cargo_no[li_tmp],&
							"cal_carg_freight_rate")
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_freight_rate", &
							astr_calc_sensitivity.d_rate[li_tmp])      
	End if

	// Save the present lumpsum for the calculation and insert the new one
	If Not IsNull(astr_calc_sensitivity.d_lumpsum[li_tmp]) and &
							(astr_calc_sensitivity.s_variable_name = "Lumpsum") Then
		ld_lumpsum[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber &
							(ai_cargo_no[li_tmp],"cal_carg_lumpsum")
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_lumpsum", &
							astr_calc_sensitivity.d_lumpsum[li_tmp])        
	End if

	// Save the present worldscale rate for the calculation and insert the new one
	If Not isNull(astr_calc_sensitivity.d_worldscale[li_tmp])  and &
									(astr_calc_sensitivity.s_variable_name = "Worldscale") Then
		ld_worldscale[li_tmp] = uo_calc_cargos.dw_cargo_summary.GetItemNumber &
									(ai_cargo_no[li_tmp], "cal_carg_ws_rate")
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_ws_rate", &
									astr_calc_sensitivity.d_worldscale[li_tmp])
	End if

	// Save the present FO price for the calculation and insert the new one
	If Not isNull(astr_calc_sensitivity.d_fo_price[li_tmp])  and &
								(astr_calc_sensitivity.s_variable_name = "Bunker") Then
		ld_fo_price = uo_calc_summary.dw_calc_summary.GetItemNumber(1,"cal_calc_fo_price")
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_fo_price", &
								astr_calc_sensitivity.d_fo_price[li_tmp])
	End if

	// Save the present load quantity for the calculation and insert the new one
	If Not IsNull(astr_calc_sensitivity.d_load_quantity[li_tmp,li_tmp])  And  &
								(astr_calc_sensitivity.s_variable_name = "Quantity") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		ld_no_load_ports = uo_calc_cargos.dw_loadports.RowCount()
		For ld_tmp = 1 to ld_no_load_ports
			// Get original quantity from loadports
			d_load_original[ld_tmp,li_tmp] = uo_calc_cargos.dw_loadports.GetItemNumber &
								(ld_tmp,"cal_caio_number_of_units")
		Next
		For ld_tmp = 1 to ld_no_load_ports
			// Insert new quantity into loadports
			uo_calc_cargos.dw_loadports.SetItem(ld_tmp,"cal_caio_number_of_units", &
								astr_calc_sensitivity.d_load_quantity[ld_tmp,li_tmp])   
		Next
	
		ld_no_disch_ports = uo_calc_cargos.dw_dischports.RowCount()
		For ld_tmp = 1 to ld_no_disch_ports
			// Get original quantity from dischports
			d_disch_original[ld_tmp,li_tmp] = uo_calc_cargos.dw_dischports.GetItemNumber &
								(ld_tmp,"cal_caio_number_of_units")
		Next
		For ld_tmp = 1 to ld_no_disch_ports
			// Insert new quantity into loadports
			uo_calc_cargos.dw_dischports.SetItem(ld_tmp,"cal_caio_number_of_units", &
								astr_calc_sensitivity.d_disch_quantity[ld_tmp,li_tmp]) 
		Next
	End if

	// Save the present load rate for the calculation and insert the new one
	If Not IsNull(astr_calc_sensitivity.d_loadrate[li_tmp]) And &
					(astr_calc_sensitivity.d_loadrate[li_tmp] > 0) And &
					(ai_port_no > 0)  and (astr_calc_sensitivity.s_variable_name = &
					"Loadrate") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// If calculated rate > 0 then use it
		If (uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
					> 0 ) Then
			ld_loadrate=uo_calc_cargos.dw_loadports.GetItemNumber &
					(ai_port_no,"cal_caio_rate_calculated")
			uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_rate_calculated", &
					astr_calc_sensitivity.d_loadrate[1])    
		Else
			// Calculated rate is 0 so use estimated rate
			ld_loadrate=uo_calc_cargos.dw_loadports.GetItemNumber &
					(ai_port_no,"cal_caio_rate_estimated")
			uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_rate_estimated", &
					astr_calc_sensitivity.d_loadrate[1])     
		End If
	End if

	// Save the present disch rate for the calculation and insert the new one
	If Not IsNull(astr_calc_sensitivity.d_dischrate[li_tmp]) And &
					(astr_calc_sensitivity.d_dischrate[li_tmp] > 0) And  &
					(ai_port_no > 0)  and (astr_calc_sensitivity.s_variable_name = &
					"Dischrate") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// If the calculated rate > 0 then use it
		If (uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
					> 0 ) Then
			ld_dischrate=uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no, &
					"cal_caio_rate_calculated")
			uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_rate_calculated", &
					astr_calc_sensitivity.d_dischrate[li_tmp])  
		Else
			// Calculated rate = 0 so use estimated rate
			ld_dischrate=uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no, &
					"cal_caio_rate_estimated")
			uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_rate_estimated", &
					astr_calc_sensitivity.d_dischrate[li_tmp])   
		End If
	End if

	// Save the present despatch amount for the calculation and insert the new one
	// If selected port is a load port then insert into the load port
	If Not IsNull(astr_calc_sensitivity.d_despatch[li_tmp]) And (ac_load_disch = "l") And &
				(ai_port_no > 0)  and (astr_calc_sensitivity.s_variable_name = "Despatch") Then
		// Select the cargo the sensitivity is done on
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// Get present despatch rate
		ld_despatch=uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_despatch")
		// Insert the new despatch amount
		uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_despatch", &
				astr_calc_sensitivity.d_despatch[li_tmp])
	// If selected port is a disch port then insert into the disch port
	ElseIf Not IsNull(astr_calc_sensitivity.d_despatch[li_tmp]) And (ac_load_disch = "d") &
				And (ai_port_no > 0) and (astr_calc_sensitivity.s_variable_name = "Despatch") Then
		// Get the present despatch amount
		ld_despatch=uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_despatch")
		// Insert the new despatch amount
		uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_despatch", &
				astr_calc_sensitivity.d_despatch[1])
	End if
Next

// Do the calculation and get the new result
uf_load_speedlist()

lstr_parm.i_function_code = 2

// Validate that the calculation can be done
If Not uf_process(lstr_parm, false) Then
	MessageBox("Calculate error", "The calculation could not be completed: ~r~n~r~n"+lstr_parm.result.s_errortext, StopSign!)
	lb_result = false
Else
	// Get the results 
	lb_result = true        

	astr_calc_sensitivity.d_day_gross = lstr_parm.result.d_gross_day
	astr_calc_sensitivity.d_day_net = lstr_parm.result.d_net_day
	astr_calc_sensitivity.d_tc = lstr_parm.result.d_tc_eqv
	astr_calc_parm = lstr_parm
	
	// Get demurrage and despatch on the cargo
	For li_tmp = 1 To  li_max
		astr_calc_sensitivity.d_cargo_demurrage = lstr_parm.cargolist[ai_cargo_no[li_tmp]].d_demurrage
		astr_calc_sensitivity.d_cargo_despatch = lstr_parm.cargolist[ai_cargo_no[li_tmp]].d_despatch
	Next
End if

// Set original values back in calculation
For li_tmp = 1 To  li_max
	// Insert the original rate
	If Not IsNull(astr_calc_sensitivity.d_rate[li_tmp])  and &
					(astr_calc_sensitivity.s_variable_name = "Rate") Then
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_freight_rate", &
					ld_rate[li_tmp])   
	End if

	// Insert the original lumpsum
	If Not IsNull(astr_calc_sensitivity.d_lumpsum[li_tmp])  and &
					(astr_calc_sensitivity.s_variable_name = "Lumpsum") Then
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_lumpsum", &
					ld_lumpsum[li_tmp])
	End if

	// Insert the original worldscale rate
	If Not isNull(astr_calc_sensitivity.d_worldscale[li_tmp])  and &
					(astr_calc_sensitivity.s_variable_name = "Worldscale") Then
		uo_calc_cargos.dw_cargo_summary.SetItem(ai_cargo_no[li_tmp],"cal_carg_ws_rate", &
					ld_worldscale[li_tmp])
	End if

	// Insert the original FO price
	If Not IsNull(astr_calc_sensitivity.d_fo_price[li_tmp])  and &
					(astr_calc_sensitivity.s_variable_name = "Bunker") Then
		uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_fo_price", ld_fo_price)
	End if

	// Insert the original quantity into the loadports
	If Not IsNull(astr_calc_sensitivity.d_load_quantity[li_tmp,li_tmp]) and &
					(astr_calc_sensitivity.s_variable_name = "Quantity")  Then
		// Select the cargo
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		ld_no_load_ports = uo_calc_cargos.dw_loadports.RowCount()
		// Insert the original value into the loadport
		For ld_tmp = 1 to ld_no_load_ports
			uo_calc_cargos.dw_loadports.SetItem(ld_tmp,"cal_caio_number_of_units", &
					d_load_original[ld_tmp,li_tmp]) 
		Next
		ld_no_disch_ports = uo_calc_cargos.dw_dischports.RowCount()
		// Inser the original value into the dischport
		For ld_tmp = 1 to ld_no_disch_ports
			uo_calc_cargos.dw_dischports.SetItem(ld_tmp,"cal_caio_number_of_units", &
					d_disch_original[ld_tmp,li_tmp])       
		Next
	End if

	// Insert the original load rate
	If Not isNull(astr_calc_sensitivity.d_loadrate[li_tmp]) And &
					(astr_calc_sensitivity.d_loadrate[li_tmp] > 0)  and &
					(astr_calc_sensitivity.s_variable_name = "Loadrate") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// If the calculated rate > 0 then insert the original value into the loadport
		If (uo_calc_cargos.dw_loadports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
					> 0 ) Then
			uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_rate_calculated", &
					ld_loadrate)
		Else
			// The calculated rate is 0 so insert the estimated load rate
			uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_rate_estimated", ld_loadrate)
		End If
	End if

	// Insert the original disch rate
	If Not isNull(astr_calc_sensitivity.d_dischrate[li_tmp]) And &
					(astr_calc_sensitivity.d_dischrate[li_tmp] > 0)  and &
					(astr_calc_sensitivity.s_variable_name = "Dischrate") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		// If the calculated rate > 0 then insert the original value into the disch port
		If ( uo_calc_cargos.dw_dischports.GetItemNumber(ai_port_no,"cal_caio_rate_calculated") &
					> 0 ) Then
			uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_rate_calculated", ld_dischrate)
		Else
			// The calculated rate = 0 so insert the estimated estimated disch rate
			uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_rate_estimated", ld_dischrate)
		End If
	End if

	// Insert the original despatch amount
	// If its a loadport insert here else
	If Not IsNull(astr_calc_sensitivity.d_despatch[li_tmp]) And (ac_load_disch = "l")  and &
				(astr_calc_sensitivity.s_variable_name = "Despatch") Then
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		uo_calc_cargos.dw_loadports.SetItem(ai_port_no,"cal_caio_despatch", ld_despatch)
	Else    
		// Insert into a dischport
		uo_calc_cargos.uf_select_cargo(ai_cargo_no[li_tmp])
		uo_calc_cargos.dw_dischports.SetItem(ai_port_no,"cal_caio_despatch", ld_despatch)
	End if
Next

Return(lb_result)
end function

public function integer uf_cpact_set_win_mode (integer ai_winmode);return 1
end function

public function integer uf_cpact_get_win_mode ();return 1
end function

public function integer uf_retrieve_route (long al_calc_id);return 1
end function

public function boolean uf_saveas (string as_description, integer ai_calctype, boolean ab_showprogress);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin "Far" Israelsen
   
 Date       : 8-7-96

 Description : Saves the calculations as a new calculation, eventually with a new
 					description and status, as given in AS_DESCRIPTION and AI_CALCTYPE.

 Arguments : AS_DESCRIPTION as string, leave as blank for no change
				 AI_CALCTYPE as integer, new status. 
				 				 Set below zero to maintain current status
				 AB_SHOWPROGESS as boolean, set to true to get a progress window

 Returns   : True if ok!

*************************************************************************************
Development Log 
DATE      VERSION    NAME    DESCRIPTION
--------  -------  	-----   -------------------------------------
8-7-96          1    MI      Initial version
1-5-97			 2		TA		  Handles the misc. port expenses
************************************************************************************/

Long ll_current_cargo, ll_count, ll_max
Boolean lb_result, lb_modified, lb_calculated
s_calc_caio_ids ls_calc_caio_ids
double d_caio_id_old[],d_caio_id_new[], d_list[]
double ld_calc_id

// Usual stuff, turn redraw off, set the pointer
This.uf_redraw_off()
This.Pointer="Hourglass!"

// Set the local modified and calculated flags to the global flags
lb_modified = ib_modified
lb_calculated = ib_calculated

// Set new status if defined
If ai_calctype>0 Then This.uf_set_status(0, ai_calctype)
// Set new description if defined
If as_description<>"" Then This.uf_set_description(0, as_description)

// Get the current cargo #, and deactivate the U_CALC_ITINERARY, so that
// any changed data will be moved to the U_CALC_CARGOS window.
ll_current_cargo = uo_calc_summary.uf_get_current_cargo()
uo_calc_itinerary.uf_deactivate()

// Get old port id's for use in copying misc. expenses on ports
uo_calc_cargos.uf_get_caio_ids(d_list[])
ll_max = UpperBound(d_list[])
For ll_count = 1 To ll_max
	d_caio_id_old[ll_count] = d_list[ll_count]
Next

// Mark all sub-objects (summary and cargo) datawindows as new, so that
// the datawindow contents will be saved to a new calculation rather than
// the existing.
uo_calc_summary.uf_mark_new()
uo_calc_cargos.uf_mark_new()

// select current cargo and save. Force the IB_CALCULATED flag to true,
// to avoid the "This calculation has not been calculated" dialog before
// saving the calculation (we don't care if the save as calculation is
// saved or not).
uo_calc_summary.uf_select_cargo(ll_current_cargo)
uo_calc_cargos.uf_select_cargo(ll_current_cargo)

ib_modified = lb_modified
ib_calculated = true
lb_result = This.uf_save(ab_showprogress)

// Get new port id's for use in copying misc. expenses on ports
If lb_result then
	uo_calc_cargos.uf_get_caio_ids(d_list[])
	For ll_count = 1 To ll_max
		d_caio_id_new[ll_count] = d_list[ll_count]
	Next
End if

// Copy misc. port expenses
If lb_result then
	uf_insert_new_id(d_caio_id_old[],d_caio_id_new[])
End if

// Re-retrieve the calculation so all fields are updates
ld_calc_id = Uf_get_calc_id()
uo_calc_cargos.dw_calc_port_expenses.Retrieve(ld_calc_id)

// Set the calculated status to what it was before, since it
// was set to true before the saving process
ib_calculated = lb_calculated 

// Clean up and return
This.uf_redraw_on()
This.Pointer="Arrow!"

Return(lb_result)
end function

private subroutine documentation ();/********************************************************************
   ObjectName: cargo object
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY> 
   Date	   CR-Ref	Author	 Comments
  09/02/11	CR1549	JSU042    BP calculations are in read only since multi currency calculation
  25/10/12	CR2797	LGX001	 it will always have only one record in flatrate table for a specific year.
  04/02/13  CR2877	WWA048	 Add function to get profit center.
  11/03/13  CR3160	WWA048	 Generate a new unique fixture
  04/04/16	CR4258	AGL027	 Remove insert into CAL_CCON table inside uf_fixture(). this is now unnecessary. 
  										 (even though this code is never called as we do not allow fixture on non atobviac calc)
</HISTORY>    
********************************************************************/

end subroutine

public function n_checkdata of_getcheckdata ();return inv_opdata
end function

public function integer of_setcheckdata ();return c#return.Success
end function

public function long of_getcheckvesselnr ();return 0
end function

public function string of_getcheckvoyagenr ();return ""
end function

public function long of_getestcalcid ();return 0
end function

public function integer of_setcheckstatusid (integer ai_newstatus);return c#return.Noaction
end function

public function long of_get_profit_center ();/********************************************************************
   of_get_profit_center
   <DESC>	Get Vessel's Profit Center </DESC>
   <RETURN>	long:
            Vessel's Profit Center	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	04/02/2013 CR2877       WWA048        First Version
   </HISTORY>
********************************************************************/

return il_pcnr
end function

public subroutine of_set_profit_center (long al_vessel_id, long al_clarkson_id);/********************************************************************
   of_set_profit_center
   <DESC>	Get vessel's profit center	</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_id
		al_clarkson_id
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	04/02/2013 CR2877       WWA048        First Version
   </HISTORY>
********************************************************************/

long li_profit_center

if al_vessel_id <> 0 then
	SELECT PC_NR
	  INTO :li_profit_center
	  FROM VESSELS
	 WHERE VESSEL_NR = :al_vessel_id;
elseif al_clarkson_id <> 0 then
	SELECT PC_NR
	  INTO :li_profit_center
	  FROM CAL_CLAR
	 WHERE CAL_CLRK_ID = :al_clarkson_id;
else
	li_profit_center = uo_global.get_profitcenter_no()
end if

il_pcnr = li_profit_center

end subroutine

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 17-07-96

 Description : Main calculation VO/NVO object.

 This object is the calculation visual object, which also works as a non-visual 
 object, whenever needed. The u_calculation object consists of three sub-objects, 
 which on the same time is visual "pages" 

 UO_CALC_SUMMARY: Contains main-calculation information and a list of all cargos.
 UO_CALC_ITINERARY: Contains the itinerary list with all ports
 UO_CALC_CARGOS: Contains information about each cargo, and all its ports.

The datawindows are shared among all three objects, except for itinerary 
(explained later). Ports and terms is also shared from this object.

General description.

The object contains all calculation information in memory until it's save or 
discharded. Since powerbuilder ain't built for this kind of thing (the datastore 
is from version 5), a couple of tricks has been done to make things work.

First of all the uo_calc_summary contains a summary (detail) and summary_list. 
The summary (detail) refers to the CAL_CALC table, and nothings special about that. 

The summary_list window is shared with cargo_summary from the uo_calc_cargo. 
This enables concurrently update, whenever the users edits data. In uo_calc_cargo, 
the datawindow is controlled by a scrolltorow, so when a users selects a cargo in 
the list window, the appropriate cargo-detail is showed in the uo_calc_cargo.
	
The cargo in/out list is a bit more tricky, since we need all in/out's for all 
cargos on the same time. This is done by filtering, so that only cargo in/out's 
that belongs to a selected cargo are shown.

Example:
	User open calcule 1
		Retrieve all cargos with CALC_ID = 1
		Retrieve all in/outs that below to the list of cargo's just retrieved

	User select cargo 2
		Cargo.ScrollToRow(WHERE ID = 2)
		Filter all cargo's with CARG_ID = (ID of cargo 2)
	
IMPORTANT:
During creation, neither CALC_ID or CARG_ID is known. Therefore we need some 
other kind of reference between the cargo's and cargo in-out's. The key in this 
process is the cargo row-number. The rownumber won't change before retrieval, 
and at that time an ID has been created

Psedo:
	User create new Cargo
		Create new ports with ID = minus cargo row ID
	User selects cargo
		Filter all cargo's with CARG_ID = minus cargo row ID
		
Upon saving and retrieval, the cargo row ID can and will be wrong. So the row id 
is saved together with the cargo. After saving, well retreive the cargo's again, 
and updates the cargo-in-out's:
		
FOR COUNT = 1 TO MAX
	REALID = Cargo.ID
	FOR ALL CARGO-IN-OUT WITH ID = Cargo.ROWID 
		CARGO-IN-OUT.ID = REALID
	NEXT
NEXT

That's all there is to it, now let's get to work.

Arguments : None

Returns   : None  

*************************************************************************************
Development Log 
DATE            VERSION         NAME    DESCRIPTION
--------                -------                 -----           -------------------------------------
1.0                                             MI              Initial version  
30-7-96                                                 Got save as to work                                     
************************************************************************************/

// Create the IUO_CALC_NVO utility object, and copy the links to all
// other objects into the IUO_CALC_NVO.
iuo_calc_nvo = CREATE u_calcutil_nvo
iuo_calc_nvo.iuo_calc_cargos = uo_calc_cargos
iuo_calc_nvo.iuo_calc_summary = uo_calc_summary
iuo_calc_nvo.iuo_calc_itinerary = uo_calc_itinerary
iuo_calc_nvo.iuo_calculation = this
uo_calc_summary.iuo_calc_nvo = iuo_calc_nvo
uo_calc_itinerary.iuo_calc_nvo = iuo_calc_nvo
uo_calc_cargos.iuo_calc_nvo = iuo_calc_nvo
uo_calc_wizard.iuo_calc_nvo = iuo_calc_nvo

// Post a retrieve event for the shared datawindows
PostEvent("ue_Shared_retrieve")


end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles UE_CHILDMODIFIED events sent from this and child-objects.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_notify

// Skip messages sent during the loading-phase
If ib_loading then return 

// Filter, so we only trigger the UE_CALC_CHANGED event if IB_CALCULATED is True
// or IB_MODIFIED is false. 
If ib_calculated = true Then
	ib_calculated = false
	lb_notify = true
End if

If ib_modified = false Then
	ib_modified = true
	lb_notify = true
End if

If (lb_notify) Then TriggerEvent("ue_calc_changed")

end event

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Destroys the IUO_CALC_NVO object

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


DESTROY iuo_calc_nvo
end event

on u_calculation.create
int iCurrent
call super::create
this.uo_calc_compact=create uo_calc_compact
this.dw_shared_terms=create dw_shared_terms
this.uo_calc_summary=create uo_calc_summary
this.uo_calc_wizard=create uo_calc_wizard
this.uo_calc_result=create uo_calc_result
this.uo_calc_itinerary=create uo_calc_itinerary
this.uo_calc_cargos=create uo_calc_cargos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_calc_compact
this.Control[iCurrent+2]=this.dw_shared_terms
this.Control[iCurrent+3]=this.uo_calc_summary
this.Control[iCurrent+4]=this.uo_calc_wizard
this.Control[iCurrent+5]=this.uo_calc_result
this.Control[iCurrent+6]=this.uo_calc_itinerary
this.Control[iCurrent+7]=this.uo_calc_cargos
end on

on u_calculation.destroy
call super::destroy
destroy(this.uo_calc_compact)
destroy(this.dw_shared_terms)
destroy(this.uo_calc_summary)
destroy(this.uo_calc_wizard)
destroy(this.uo_calc_result)
destroy(this.uo_calc_itinerary)
destroy(this.uo_calc_cargos)
end on

type uo_calc_compact from u_atobviac_calc_compact within u_calculation
integer taborder = 10
boolean enabled = false
end type

on uo_calc_compact.destroy
call u_atobviac_calc_compact::destroy
end on

type dw_shared_terms from u_datawindow_sqlca within u_calculation
boolean visible = false
integer x = 2359
integer y = 64
integer width = 146
integer height = 112
integer taborder = 60
string dataobject = "d_calc_terms_dddw"
end type

type uo_calc_summary from u_calc_summary within u_calculation
integer taborder = 50
end type

on uo_calc_summary.destroy
call u_calc_summary::destroy
end on

type uo_calc_wizard from u_calc_wizard within u_calculation
integer taborder = 40
end type

on uo_calc_wizard.destroy
call u_calc_wizard::destroy
end on

type uo_calc_result from u_calc_result within u_calculation
integer taborder = 30
end type

on uo_calc_result.destroy
call u_calc_result::destroy
end on

type uo_calc_itinerary from u_calc_itinerary within u_calculation
integer taborder = 10
end type

on uo_calc_itinerary.destroy
call u_calc_itinerary::destroy
end on

type uo_calc_cargos from u_calc_cargos within u_calculation
integer taborder = 20
boolean bringtotop = true
end type

on uo_calc_cargos.destroy
call u_calc_cargos::destroy
end on
