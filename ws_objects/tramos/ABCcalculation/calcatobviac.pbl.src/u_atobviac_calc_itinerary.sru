$PBExportHeader$u_atobviac_calc_itinerary.sru
$PBExportComments$itinerary's subobject - used by u_calculation. After implementation of AtoBviaC distance table.
forward
global type u_atobviac_calc_itinerary from u_atobviac_calc_base_sqlca
end type
type dw_applyspeed from u_datawindow_sqlca within u_atobviac_calc_itinerary
end type
type tab_itinerary from tab within u_atobviac_calc_itinerary
end type
type tp_itinerary from userobject within tab_itinerary
end type
type dw_voyage_alert from u_popupdw within tp_itinerary
end type
type dw_itinerary_route from u_datawindow_sqlca within tp_itinerary
end type
type dw_itinerary from u_datawindow_dragdrop within tp_itinerary
end type
type tp_itinerary from userobject within tab_itinerary
dw_voyage_alert dw_voyage_alert
dw_itinerary_route dw_itinerary_route
dw_itinerary dw_itinerary
end type
type tp_routecontrol from userobject within tab_itinerary
end type
type uo_enginecontrol from c_engine_controlpanel within tp_routecontrol
end type
type tp_routecontrol from userobject within tab_itinerary
uo_enginecontrol uo_enginecontrol
end type
type tp_map from userobject within tab_itinerary
end type
type uo_map from u_atobviac_map within tp_map
end type
type tp_map from userobject within tab_itinerary
uo_map uo_map
end type
type tab_itinerary from tab within u_atobviac_calc_itinerary
tp_itinerary tp_itinerary
tp_routecontrol tp_routecontrol
tp_map tp_map
end type
type s_charterer_name from structure within u_atobviac_calc_itinerary
end type
type s_cargolist from structure within u_atobviac_calc_itinerary
end type
end forward

type s_charterer_name from structure
    long l_carg_id
    string s_name
    string s_gradename
    string s_gradegroup
end type

type s_cargolist from structure
	long		l_carg_id
	string		s_name
end type

global type u_atobviac_calc_itinerary from u_atobviac_calc_base_sqlca
integer width = 4603
integer height = 2300
long backcolor = 32304364
long tabbackcolor = 32304364
event ue_getvesselpc ( ref long al_pcnr )
dw_applyspeed dw_applyspeed
tab_itinerary tab_itinerary
end type
global u_atobviac_calc_itinerary u_atobviac_calc_itinerary

type variables
public s_port_codes port_code
Private boolean ib_active, ib_unlocked
dw_itinerary dw_itinerary

// Cached data
Private Boolean ib_process_data_cached, ib_display_data_cached
Double id_canal_expenses, id_miles_ballasted, id_miles_loaded
Double id_minutes_ballasted, id_minutes_loaded
Double id_fo_units, id_do_units, id_mgo_units
decimal{4} id_lsfo_units
String is_warning
integer il_draggedto

Boolean ib_reset_itinerary
Private Boolean ib_first_port_is_ballast

long	il_contype_id[]

constant string 	is_LADEN_SPEEDLIST = "2,9,10" //Speed type for the vessel is having cargo during the Sailing(Laden, Idle, Heating)
constant string 	is_BALLAST_SPEEDLIST = "1,9" //Speed type for the vessel is not having cargo during the Sailing(Ballast, Idle)

//port_type 0:PORT, 1:VIA PORT, 2:CANAL, -1:ECA
constant integer  ii_PORT = 0
constant integer  ii_VIA_PORT = 1
constant integer  ii_CANAL = 2
constant integer  ii_ECA = -1

constant string is_CONSDDDWSORTEXPR = "cons_type A, zone_order A, cal_cons_speed A, cal_cons_fo A, cal_cons_do A, cal_cons_mgo A, cal_cons_lsfo A"

constant string is_DEFZONEIGNOREDMSG = "The consumption zones you have selected for part(s) of your route" &
			+ " are not available for the current vessel. Default consumption values based on your Slow/Full speed configuration" &
			+ " in User Options will be used instead."

constant integer ii_APPLYTOALL = 1, ii_APPLYTOBALLAST = 2, ii_APPLYTOLADEN = 3

n_messagebox inv_msgbox

end variables

forward prototypes
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public function integer uf_get_speed (integer ai_type, ref s_speed astr_speed[], double ld_speed)
public subroutine uf_row_set_null (integer ai_row_no)
public subroutine uf_retrieve ()
public function integer uf_deactivate ()
public function boolean uf_point_distance (ref string as_lastpoint, string as_nextpoint, ref integer ai_distance, ref string as_errortext)
public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_text)
public subroutine uf_port_changed ()
public subroutine uf_clear_cache ()
public subroutine uf_unlock ()
public subroutine uf_update_itinerary_order ()
public subroutine uf_delete ()
public subroutine uf_activate ()
public function boolean uf_process (ref s_calculation_parm astr_parm, ref mt_u_datawindow adw_load, ref mt_u_datawindow adw_disch)
public function integer uf_saveroute (long al_calc_id, long al_est_id)
public subroutine of_childmodified ()
private subroutine documentation ()
public subroutine of_refreshspeed ()
public subroutine of_getinactivespeed ()
public subroutine of_retrieve (long al_calcid)
public subroutine of_datasync (string as_type, integer al_rowid, string as_purpose)
public subroutine of_datasync (string as_type)
public function integer of_checkportorder (mt_u_datawindow adw_itinerary, integer ai_from, integer ai_to)
public function integer of_getabcportsequence (u_datawindow_sqlca adw_itinerary, ref string as_abcportsequence[])
public subroutine of_mapitinerary ()
public function boolean of_showcombinedata ()
public subroutine of_setspeedvisible ()
public function boolean of_saveitinerary (long al_calc_id, long al_est_id)
public function integer of_generate_route ()
public function boolean of_checkportdist ()
public subroutine of_setportdist ()
public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_title, string as_text)
private function integer _calcdayscons (long al_row, ref s_calculation_parm astr_parm, ref string as_errmsg)
public subroutine of_clearnonportspeed ()
public function integer of_applyspeed (decimal ad_speed, integer ai_applyto)
public subroutine of_defzoneindicating (boolean ab_isdefzone, integer ai_row)
public function long of_getappropriatespeed (mt_n_datastore ads_cal_cons, integer ai_speedtype, boolean ab_isineca, ref decimal ad_speed, ref boolean ab_zoneignored)
public subroutine of_setdwapplyspeedvisibility ()
public subroutine of_createmap (string as_abcportsequence[])
public function integer of_mergeitinerary (long al_calc_id)
public function integer of_get_voyage_alert_status (string as_port_code)
public subroutine of_show_voyage_alert (string as_port_code, integer xpos, integer ypos)
public function boolean of_firstlast_interim (ref s_calculation_parm astr_parm)
end prototypes

event ue_getvesselpc(ref long al_pcnr);/********************************************************************
   ue_getvesselpc
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		11/04/16		CR3767		XSZ004		First Version
   </HISTORY>
********************************************************************/

parent.dynamic event ue_getvesselpc(al_pcnr)

end event

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : turns redraw off

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// tab_itinerary.tp_itinerary.dw_calc_itinerary.uf_redraw_off()
end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : turns redraw on

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

//tab_itinerary.tp_itinerary.dw_calc_itinerary.uf_redraw_on()
end subroutine

public function integer uf_get_speed (integer ai_type, ref s_speed astr_speed[], double ld_speed);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the index for speed (ld_speed) found in speedlist
 					(astr_speed[]) and for speedtype (ai_type).

 Arguments : ai_type as Integer, astr_speed[] as speedlist REF,
 				 ld_speed as double.	

 Returns   : Index for speed, or - index for first speed entry.  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_max, li_count, li_row

// Loop through the speedlist and search for the speed/speedtype.
// Also, remember first speed that is found of the given type, this will be
// returned if nothing else is found.
li_max = UpperBound(astr_speed[])
For li_count = 1 To li_max
	If (astr_speed[li_count].d_speed = ld_speed) And (astr_speed[li_count].d_speed > 0) & 
					And (astr_speed[li_count].i_type = ai_type) Then
		li_row = li_count
		Exit
	Elseif astr_speed[li_count].i_type = ai_type Then
		li_row = - li_count  // Set as first, if original speed is not found
	End if
Next

Return(li_row)

end function

public subroutine uf_row_set_null (integer ai_row_no);/************************************************************************************
	RMO Data
	Date       : 2005
 	Description : Sets a itinerary row (ai_row_no) to default values.
 	Arguments : ai_row_no as integer
 	Returns   : None  
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

decimal ld_null

setnull(ld_null)

if (ai_row_no > 0) And (ai_row_no <= dw_itinerary.rowcount()) then
	if ai_row_no = dw_itinerary.rowcount() then
		dw_itinerary.setitem(ai_row_no, "cal_cons_id", ld_null)
		dw_itinerary.setitem(ai_row_no, "speed", ld_null)
	end if
	
	dw_itinerary.setitem(ai_row_no, "distance", ld_null)	
	dw_itinerary.setitem(ai_row_no, "eca_distance", ld_null)	
	dw_itinerary.setitem(ai_row_no, "sec_seconds", ld_null)
	dw_itinerary.setitem(ai_row_no, "eca_seconds", ld_null)	
	dw_itinerary.setitem(ai_row_no, "calc_hsfo", ld_null)	
	dw_itinerary.setitem(ai_row_no, "calc_lsgo", ld_null)	
	dw_itinerary.setitem(ai_row_no, "calc_hsgo", ld_null)	
	dw_itinerary.setitem(ai_row_no, "calc_lsfo", ld_null)	
end if

end subroutine

public subroutine uf_retrieve ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    : Martin Israelsen
 Date       : 
 Description : Retrieves data from load and disch-datawindows, to be shown in the
			 		itinerary window. The retrieve happens whenever the Itinerary window 
					is selected and there's no data in the itinerary datawindow.
 Arguments : None
 Returns   : None  
*************************************************************************************
Development Log 
DATE           CR-Ref      NAME        DESCRIPTION
--------       -------     -----       -------------------------------------
20/03/13       CR2658      LHG008      initialize speed(sailing_cons_id) dorpdown.
21/01/15       CR3921      LHG008      Fix the bug when colunm locked but the backcolor is not changed
23/12/15       CR3248      LHG008      ECA zone implementation
14/03/16       CR4292      LHG008      Add function to change bunch speed
************************************************************************************/
//
// This is how Itinerary works:
//
// Upon entering the Itinerary module, this code retrieves port information from the
// load/disch datawindows. If the user edits speed or drag/drop ininerary, the information
// is stored back to the relevant datawindows upon exitting the itinerary window.
//
// To increase performance, data is cached in the Itinerary window. That is, whenever
// the user edits information (ports etc) in load/disch windows, they clear the 
// itinerary cache, thereby signalling that data needs to be retrieved upon entering
// the Itinerary again. If nothing is changed, the Itinerary window will not re-retrieve
// data.

Integer li_count, li_max, li_status, li_old_cargo, li_locked
u_atobviac_calc_cargos luo_calc_cargos

/* advanced port validator variables */
integer li_action =0
integer li_output=0
n_portvalidator lnv_validator

// Let luo_calc_cargos point to uo_calc_cargos object 
luo_calc_cargos = iuo_calc_nvo.iuo_calc_cargos

this.uf_redraw_off()
luo_calc_cargos.uf_redraw_off()

of_datasync("in")

// If any of the calculation is fixture or estimated, mark all rows as locked.
li_status = iuo_calc_nvo.iuo_calculation.uf_get_status(0)
if li_status = c#calculationstatus.il_FIXTURE or li_status = c#calculationstatus.il_ESTIMATED then
	li_max = dw_itinerary.rowcount()
	for li_count = 1 to li_max
		dw_itinerary.setitem(li_count, "proceeding_locked", 1)
		if li_status = c#calculationstatus.il_FIXTURE then dw_itinerary.setitem(li_count, "locked", 1)
	next
end if

of_setdwapplyspeedvisibility()

/* port validator - start */
lnv_validator = create n_portvalidator
lnv_validator.of_registeractivedw(tab_itinerary.tp_itinerary.dw_itinerary_route)
if lnv_validator.of_start( "CALCITIN", iuo_calc_nvo.iuo_calc_summary.dw_calc_summary, iuo_calc_nvo.iuo_calculation.of_getcheckdata(), li_output, ib_unlocked, li_action ) = c#return.Failure then
	choose case li_action
		case 0
			/* do nothing */
		case 1
			tab_itinerary.tp_routecontrol.uo_enginecontrol.enabled = false
		case 2
			/* estimated */
			tab_itinerary.tp_routecontrol.uo_enginecontrol.enabled = true
		case else
			/* also do nothing */			
	end choose
end if
destroy lnv_validator
/* port validator - end */

// Select the old cargo, turn redraw on again and exit
luo_calc_cargos.uf_select_cargo(li_old_cargo)

//Handle PB focus issue when all fields in a datawindow is locked
dw_itinerary.setrow(dw_itinerary.rowcount())
dw_itinerary.setrow(1)

this.uf_redraw_on()
luo_calc_cargos.uf_redraw_on()

end subroutine

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : deactivates the itinerary windows, by saving modifications back
 					to the cargo window
 Arguments : None

 Returns   : Integer. 1 = ok

*************************************************************************************
Development Log 
DATE     VERSION     NAME           DESCRIPTION
-------- ------- 		------         -------------------------------------
29/12/15	CR3248		LHG008			ECA zone implementation
************************************************************************************/

// If the itinerary window is active, then save information and set active to false
If ib_active or not ib_display_data_cached then
	of_datasync('out')
	ib_active = false
End if

Return(1)
end function

public function boolean uf_point_distance (ref string as_lastpoint, string as_nextpoint, ref integer ai_distance, ref string as_errortext);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 9-8-96

 Description : Calculates distance between as_lastpoint and as_nextpoint, if 
 					as_lastpoint or as_nextpoint is null, no distance is given. 
					 
					This rutine automaticly sets as_lastpoint to as_nextpoint when
					distance is calculated

 Arguments : as_lastpoint as REF string, as_nextpoint as string, 
 				 ad_distance as reference

 Returns   : True if distance is found

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
9-8-96		3			MI		Initial version  
************************************************************************************/

Double li_dist
String ls_tmp

// Set last or nextpoint to null if it's an empty string
If as_lastpoint = "" Then SetNull(as_lastpoint)
If as_nextpoint = "" Then SetNull(as_nextpoint)

// If lastpoint is NULL, then set lastpoint to nextpoint and return
If IsNull(as_lastpoint) Then
	as_lastpoint = as_nextpoint

ElseIf Not(isnull(as_nextpoint)) Then
	// if neither lastpoint or nextpoint is null then calculate distance, 
	// and set lastpoint = nextpoint

	// If same port, return zero as distance
	If as_lastpoint = as_nextpoint Then Return(true) 
	
	// Get the distance from the uo_calcutil_nvo
	li_dist = iuo_calc_nvo.uf_distance(as_lastpoint,as_nextpoint)

	// If the distance is less than zero, it's some kind of errorcode
	// process the error by showing a messagebox or adding the error to
	// the global calculation result string, and set the distance to 0
	If li_dist < 0 Then
		ls_tmp = "Cannot calculate distance between~r~n~r~n "+as_lastpoint+" and "+as_nextpoint+"~r~n~r~n"+iuo_calc_nvo.uf_distance_error()

		If iuo_calc_nvo.iuo_calculation.ib_show_messages Then
			MessageBox("Distance error", ls_tmp)
		Else 
			iuo_calc_nvo.iuo_calculation.is_message += ls_tmp + "~r~n~r~n"
		End if

		li_dist=0
		as_errortext = ls_tmp
	End if

	// Add next distance to ai_distance and set as_lastpoint equal to as_nextpoint
	ai_distance += li_dist
	as_lastpoint = as_nextpoint

	Return(true)
End if

// Lastpoint or nextpoint was null
Return(false)
	


end function

public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_text);string ls_title

ls_title = "Warning"
uf_warning(astr_parm, ls_title, as_text)

end subroutine

public subroutine uf_port_changed ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Notifies the rest of the calculation system that a port has changed

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

public subroutine uf_clear_cache ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    : MIS
 Date       : 3-3-97
 Description : Clears the itinerary cache. The itinerary cache contains already
 					calculated information about distances, fuel consumption etc.,
					but HAS to be cleared when something "outside" the itinerary
					(or inside, but the itinerary module clears itself) changes.
					If the cache is not cleared, it will still return old result values
					during calculation.
					
					The itinerary cache is seperated in two parts; the calculation
					cache and a cache to the visual presentation (the itinerary window).
					uf_clear_cache always clears the calculation cache, while clearing
					the visual cache is optional and controlled by the 
					ab_clear_itinerary flag.
					
 Returns   : None  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE        VERSION     NAME     DESCRIPTION
----------  -------     ------   ----------------------------------
14/01/2015  CR3248      LHG008   ECA zone implementation
************************************************************************************/

// Clear the calculation data cache
ib_process_data_cached = false
ib_display_data_cached = false
id_canal_expenses = 0
id_miles_ballasted = 0
id_miles_loaded = 0
id_minutes_ballasted = 0
id_minutes_loaded = 0
id_fo_units = 0
id_do_units = 0
id_mgo_units = 0
id_lsfo_units = 0
is_warning = ""

end subroutine

public subroutine uf_unlock ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-5-97

 Description : Unlocks the itinerary, so that it's legal to change itinerary order

 Arguments : none

 Returns   : none

*************************************************************************************
Development Log 
DATE     VERSION     NAME           DESCRIPTION
-------- ------- 		------         -------------------------------------
5-5-97   4.05        MI             Initial version  
29/12/15 CR3248      LHG008         ECA zone implementation
************************************************************************************/

long ll_rows, ll_row

this.uf_redraw_off()

// Unlock the itinerary by setting the ib_unlocked to true, clear the cache
// (so that the itinerary system re-retrieves upon calling retrieve) and 
// retrieve the data

tab_itinerary.tp_routecontrol.uo_enginecontrol.enabled = true
ll_rows = tab_itinerary.tp_itinerary.dw_itinerary_route.rowCount()
for ll_row = 1 to ll_rows
	tab_itinerary.tp_itinerary.dw_itinerary_route.object.locked[ll_row] = 0
next

ll_rows = dw_itinerary.rowcount()
for ll_row = 1 to ll_rows
	dw_itinerary.object.locked[ll_row] = 0
	dw_itinerary.object.proceeding_locked[ll_row] = 0
next

ib_unlocked = true
uf_clear_cache()
uf_retrieve()
ib_display_data_cached = true

this.uf_redraw_on()
end subroutine

public subroutine uf_update_itinerary_order ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 13-6-97

 Description : Updates the itinerary order

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

This.uf_retrieve()
of_datasync('out')

ib_display_data_cached = false
end subroutine

public subroutine uf_delete ();// Clear the calculation cache, so that data will be re-calculated.
uf_clear_cache()
end subroutine

public subroutine uf_activate ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    : MIS
 Date       : 1996
 Description : Handles the Activation of the itinerary window. This procedure retrieves
 					data (if data isn't already cached) and brings the window on top

 Arguments : None
 Returns   : None  
*************************************************************************************
Development Log 
DATE     VERSION     NAME           DESCRIPTION
-------- ------- 		------         -------------------------------------
29/12/15	CR3248		LHG008			ECA zone implementation 
************************************************************************************/

// Retrieve data to the itinerary window, if no data exists, or data isn't
// cached
long llrows

llrows = dw_itinerary.rowcount()
if (dw_itinerary.rowcount() = 0) or (not ib_display_data_cached) then
	this.uf_retrieve()
	ib_display_data_cached = true
end if
ib_active = true

// The following code is due to a PB bug/feature. If we lock the current row, it's
// still possible to modify it, therefore we need to switch current row, before the
// locking becomes effective.
if dw_itinerary.rowcount() > 0 then
	of_refreshspeed()
end if

this.bringtotop = true

end subroutine

public function boolean uf_process (ref s_calculation_parm astr_parm, ref mt_u_datawindow adw_load, ref mt_u_datawindow adw_disch);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
Object     : u_calc_itinerary
Function  : uf_process( /*ref s_calculation_parm astr_parm*/, /*ref datawindow adw_load*/, /*ref datawindow adw_disch */)
Event	 : 
Scope     : 
************************************************************************************
 Author    : Teit Aunt
 Date       : 23-7-96
 Description : Validate that the distances to be used in the calculation is in the 
 					distance table. Also there is check to see if the vessel sails with 
					 over load or negative load.

 Description : This function performs three tasks, depending on [function code].
			Code: 1; validates cargos for save
			Code: 2; (validates) and performs calculation
			Code: 3; validates fixture and performs calculation			

			This function processes distances, distance consumption, 
			itinerary order and intake above maximum.

 Arguments : astr_parm as s_calculation_parm REF, adw_load as load datawindow REF,
 				 adw_disch as disch datawindow REF.	

 Returns   : True if ok
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
5-8-96		1.1			TA		Setting up the distance part
23-7-96		1.0			TA		Initial version
8-8-96		?.?			MI		Removed parent uf_calculation_valid
4-10-96		2.0			MI		New version with ballast calculation
7-3-97		3.0			MI		Added cache on itinerary calculation and data retrievel 
									in order to speed things up
									NB: Call uf_clear_cache whenever data changes, 
									to update display/calculation valid data
01-03-05		14.0		RM	Ændret en del i forbindelse med implementering af 
									ny distancetabel (AtoBviaC)
11-16-12		CR2967		LHC010	Fix the bug when open two calculations(A,B),change route of A.
                        			However the intinerary distance of B will be changed after clicking 'calculate',
											but route of B is unchanged.
27-03-13		CR2658		WWG004	Save the contype id for every port.					
10/02/2014	CR2658UAT	LHG008	Fix UAT bug.
28/08/2013  CR3622      LHG008   Handle speed of user selected.
16/12/2015  CR3248      LHG008   ECA zone implementation
14/03/2016  CR4292      LHG008   Add function to change bunch speed
17/03/2016  CR2362      LHG008   Remove hard-coded days in Canal
22/03/2016  CR4157      LHG008   Default Speed extended
08/12/2016  CR4050      LHG008   Change additionals Laden and Ballasted logic
22/08/2017	CR4221		HHX010  Check the first and last port
************************************************************************************/

string	ls_purpose, ls_portname, ls_abcportsequence[] //AtoBviaC portcode sequence
string	ls_filterexpr, ls_findexpr, ls_tmp, ls_typelist, ls_errtext
decimal	ld_speed, ld_time, ld_intake, ld_null
decimal	ld_distance, ld_eca_distance, ld_combine_distance, ld_combine_sec_seconds
boolean	lb_modified, lb_combinedata, lb_is_eca, lb_foundspeed, lb_showzonemessage, lb_zoneignored
long		ll_cons_id, ll_conscount, ll_find, ll_row, ll_loop, ll_portcount, ll_prev_itn_prot = 1
integer	li_speedtype, li_itinerary, li_port_type, li_interim_port

mt_n_datastore		lds_cal_cons

dw_itinerary.accepttext()

//If calculation data has been cached (ib_process_data_cached = true)
// then update astr_parm with cached data and return.
If ib_process_data_cached Then
	astr_parm.result.d_canal_expenses += id_canal_expenses
	astr_parm.d_miles_ballasted += id_miles_ballasted
	astr_parm.d_miles_loaded += id_miles_loaded
	astr_parm.d_minutes_ballasted += id_minutes_ballasted
	astr_parm.d_minutes_loaded += id_minutes_loaded
	
	astr_parm.result.d_fo_units += id_fo_units
	astr_parm.result.d_do_units += id_do_units
	astr_parm.result.d_mgo_units += id_mgo_units
	astr_parm.result.d_lsfo_units += id_lsfo_units

	If (is_warning<>"") And (iuo_calc_nvo.iuo_calculation.ib_show_messages) Then MessageBox("Warning", is_warning)
	
	Return true
End if

//Exit if we're just checking for save (i_function_code = 1)
If astr_parm.i_function_code = 1 Then Return(True)  

//Send current route into 'n_atobviac' before calculating the distance. 
tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_primary_rp.event ue_itemchanged( )

of_defzoneindicating(false, 0)

//Clear the errortext
astr_parm.result.s_errortext = ""
of_refreshspeed()

of_datasync("in")

//Get AtoBviaC port sequence
of_getabcportsequence(dw_itinerary, ls_abcportsequence)

tab_itinerary.tp_routecontrol.uo_engineControl.of_setportsequence(ls_abcportsequence)
tab_itinerary.tp_routecontrol.uo_engineControl.of_refreshRoute()

of_mapitinerary()

setnull(ld_null)

lds_cal_cons = create mt_n_datastore
lds_cal_cons.dataobject = iuo_calc_nvo.ids_cal_cons.dataobject //d_sq_gr_cal_cons

ll_conscount = iuo_calc_nvo.ids_cal_cons.rowcount()
iuo_calc_nvo.ids_cal_cons.rowscopy(1, ll_conscount, Primary!, lds_cal_cons, 1, Primary!)

lds_cal_cons.setsort(is_CONSDDDWSORTEXPR)
lds_cal_cons.sort()

if of_showcombinedata() then
	lb_combinedata = true
end if

ll_portcount = dw_itinerary.rowcount()

for ll_loop = 1 to ll_portcount
	lds_cal_cons.setfilter("")
	lds_cal_cons.filter()
	ll_conscount = lds_cal_cons.rowcount()
	
	ll_cons_id = dw_itinerary.getitemnumber(ll_loop, "cal_cons_id")
	ld_intake = dw_itinerary.getitemnumber(ll_loop, "intake") //This is used to find out whether to use laden
	li_itinerary = dw_itinerary.getitemnumber(ll_loop, "itinerary_no")
	li_port_type = dw_itinerary.getitemnumber(ll_loop, "port_type")
	
	if isnull(li_itinerary) then li_itinerary = 0
	
	if ll_loop < ll_portcount then
		lb_foundspeed = false
		
		if lb_combinedata and ll_loop > 1 and li_itinerary = 0 then
			ll_cons_id = dw_itinerary.getitemnumber(ll_loop - 1, "cal_cons_id")
			ld_speed = dw_itinerary.getitemnumber(ll_loop - 1, "speed")
			
			dw_itinerary.setitem(ll_loop, "cal_cons_id", ll_cons_id)
			dw_itinerary.setitem(ll_loop, "speed", ld_speed)
			lb_foundspeed = true
		else
			//If current intake is zero, then we use the ballasted speeds.
			if ld_intake = 0 then
				li_speedtype = c#consumptiontype.il_SAILING_BALLAST
				ls_typelist = is_BALLAST_SPEEDLIST
			else
				li_speedtype = c#consumptiontype.il_SAILING_LADEN
				ls_typelist = is_LADEN_SPEEDLIST
			end if
			
			//Get current selected speed from the datawindow. This speed might or might
			// not be valid, so we need to validate it ourselves!.
			
			//If not refresh and already have speed then try to find it.
			if not isnull(ll_cons_id) then
				//Make sure the speed type is correct.
				ls_findexpr = "cal_cons_id = " + string(ll_cons_id) + " and cal_cons_type in(" + ls_typelist + ")"
				ll_find = lds_cal_cons.find(ls_findexpr, 1, ll_conscount)
				if ll_find > 0 then
					if lds_cal_cons.getitemnumber(ll_find, "cal_cons_active") = 1 then
						ld_speed = lds_cal_cons.getitemnumber(ll_find, "cal_cons_speed")
						dw_itinerary.setitem(ll_loop, "speed", ld_speed)
						lb_foundspeed = true
					else//Cons id is inactive
						ls_purpose = dw_itinerary.getitemstring(ll_loop, 'purpose_code')
						ls_portname = dw_itinerary.getitemstring(ll_loop, 'routing_point')
						if len(ls_purpose) > 0 then
							ls_tmp = ls_portname + " (" + ls_purpose + ") "
						else
							ls_tmp = ls_portname
						end if
						
						astr_parm.result.s_errortext = "You have used an inactive speed value in Itinerary - Port " + ls_tmp + '. Select an active value to continue.'
						destroy lds_cal_cons
						return false
					end if
				end if
			end if
		end if
		
		if not lb_foundspeed then
			if uo_global.ib_usedefaultspeed then
				ld_speed = uo_global.id_calcdefaultspeed
			elseif uo_global.ib_full_speed then
				ld_speed = 99999.99
			else
				ld_speed = -99999.99
			end if
			
			lb_is_eca = (dw_itinerary.getitemnumber(ll_loop, "eca_point") > 0)
			ll_cons_id = of_getappropriatespeed(lds_cal_cons, li_speedtype, lb_is_eca, ld_speed, lb_zoneignored)
			
			if isnull(ll_cons_id) or ll_cons_id <= 0 then
				if ld_intake = 0 then ls_tmp = "ballasted" else ls_tmp = "loaded"
				astr_parm.result.s_errortext = "No " + ls_tmp + " consumption defined for this vessel"
				destroy lds_cal_cons
				return false
			end if
			
			dw_itinerary.setitem(ll_loop, "cal_cons_id", ll_cons_id)
			dw_itinerary.setitem(ll_loop, "speed", ld_speed)
			ib_display_data_cached = false
			
			//The consumption zones is not Default consumption.
			if lb_zoneignored then
				lb_showzonemessage = true
				of_defzoneindicating(true, ll_loop)
			end if
		end if
	else	//ll_loop = ll_portcount
		//Clear the last row
		uf_row_set_null(ll_loop)
	end if
	
	//Start distance, days and fuel consumption calculation
	ld_distance = dw_itinerary.getitemnumber(ll_loop, "distance")
	ld_eca_distance = dw_itinerary.getitemnumber(ll_loop, "eca_distance")
	
	//The combine data will save back to table CAL_CAIO, CAL_BALL
	if li_itinerary < 2 then
		ld_combine_distance += ld_distance
	else
		dw_itinerary.setitem(ll_prev_itn_prot, "combine_distance", ld_combine_distance)
		
		ld_speed = dw_itinerary.getitemnumber(ll_prev_itn_prot, "speed")
		ld_combine_sec_seconds = (ld_combine_distance / ld_speed * 60)
		dw_itinerary.setitem(ll_prev_itn_prot, "combine_sec_seconds", ld_combine_sec_seconds)
	end if
	
	if lb_combinedata then
		if li_itinerary < 2 then
			uf_row_set_null(ll_loop)
		else
			dw_itinerary.setitem(ll_prev_itn_prot, "distance", ld_combine_distance)
			if _calcdayscons(ll_prev_itn_prot, astr_parm, astr_parm.result.s_errortext) = c#return.Failure then
				destroy lds_cal_cons
				return false
			end if
			
			dw_itinerary.setitem(ll_prev_itn_prot, "sec_seconds", ld_combine_sec_seconds)
		end if
	elseif ll_loop <> ll_portcount then	//The last port will be set to null
		if _calcdayscons(ll_loop, astr_parm, astr_parm.result.s_errortext) = c#return.Failure then
			destroy lds_cal_cons
			return false
		end if
		
		ld_time = dw_itinerary.getitemnumber(ll_loop, "sec_seconds")
		if ld_eca_distance > 0 then //SECA enabled
			dw_itinerary.setitem(ll_loop, "eca_seconds", ld_time)
		else
			dw_itinerary.setitem(ll_loop, "eca_seconds", ld_null)
		end if
	end if
	
	if li_itinerary > 1 then
		ll_prev_itn_prot = ll_loop
		ld_combine_distance = ld_distance
	end if
next

destroy lds_cal_cons

if lb_showzonemessage then
	uf_warning(astr_parm, "Consumption zones not available", is_DEFZONEIGNOREDMSG)
end if

//Update the intake_peak, which is used to determine if intake > deatweight
ld_intake = double(dw_itinerary.describe("evaluate('max(intake for all)', 1)"))
if ld_intake > astr_parm.result.d_intake_peak then astr_parm.result.d_intake_peak = ld_intake

//Check if intake was larger than deadweight
if isnull(astr_parm.d_deadweight) then
	uf_warning(astr_parm, "Unable to determine if intake is below maximum, SDWT not specified for this vessel")
elseif astr_parm.d_deadweight < astr_parm.result.d_intake_peak then
	uf_warning(astr_parm, "Intake is above SDWT for this vessel~r~n~r~nIntake: " + string(astr_parm.result.d_intake_peak) + &
				" SDWT: " + string(astr_parm.d_deadweight))
end if

id_canal_expenses = dw_itinerary.getitemnumber(1, "sum_expenses")

//Store result values from the itinerary cache to astr_parm.
is_warning = astr_parm.result.s_warningtext

ll_find = pos(is_warning, is_DEFZONEIGNOREDMSG)
if ll_find > 0 then is_warning = replace(is_warning, ll_find - len("~r~n"), len(is_DEFZONEIGNOREDMSG) + len("~r~n"), '')

astr_parm.result.d_canal_expenses += id_canal_expenses
astr_parm.d_miles_ballasted += id_miles_ballasted
astr_parm.d_miles_loaded += id_miles_loaded
astr_parm.d_minutes_ballasted += id_minutes_ballasted
astr_parm.d_minutes_loaded += id_minutes_loaded

astr_parm.result.d_fo_units += id_fo_units
astr_parm.result.d_do_units += id_do_units
astr_parm.result.d_mgo_units += id_mgo_units
astr_parm.result.d_lsfo_units += id_lsfo_units

of_datasync("out")
ib_process_data_cached = true
if lb_modified then parent.triggerevent("ue_childmodified")

Return(true)
end function

public function integer uf_saveroute (long al_calc_id, long al_est_id);/* This function stores the route to the database. 
If al_est_id <> 0 then also estimated route has to be updated  */
long ll_rows, ll_row

if of_generate_route() <> c#return.Success then return -1

DELETE CAL_ROUTE
 WHERE CAL_CALC_ID = :al_calc_id;

if sqlca.sqlcode <> 0 then
	MessageBox("Delete Error", "Failed to delete itinerary route")
	return -1
end if

ll_rows = tab_itinerary.tp_itinerary.dw_itinerary_route.RowCount()
for ll_row = 1 to ll_rows
	tab_itinerary.tp_itinerary.dw_itinerary_route.setItem(ll_row, "cal_route_cal_calc_id", al_calc_id)
	tab_itinerary.tp_itinerary.dw_itinerary_route.setItemStatus(ll_row, 0, Primary!, NewModified!)
next

if tab_itinerary.tp_itinerary.dw_itinerary_route.Update() <> 1 then
	MessageBox("Update Error", "Failed to update itinerary route")
	return -1
end if

if al_est_id <> 0 then /* also update estimated calculation */
	DELETE CAL_ROUTE
	 WHERE CAL_CALC_ID = :al_est_id;
	
	if sqlca.sqlcode <> 0 then
		MessageBox("Delete Error", "Failed to delete estimated itinerary route")
		return -1
	end if
	
	ll_rows = tab_itinerary.tp_itinerary.dw_itinerary_route.RowCount()
	for ll_row = 1 to ll_rows
		tab_itinerary.tp_itinerary.dw_itinerary_route.setItem(ll_row, "cal_route_cal_calc_id", al_est_id)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setItemStatus(ll_row, 0, Primary!, NewModified!)
	next
	
	if tab_itinerary.tp_itinerary.dw_itinerary_route.Update() <> 1 then
		MessageBox("Update Error", "Failed to update estimated itinerary route")
		return -1
	end if
end if

return 1
end function

public subroutine of_childmodified ();
// Clear the data cache, so that data will be refreshed upon next calculation
uf_clear_cache()
parent.TriggerEvent( "ue_childmodified")
end subroutine

private subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    		Author        	Comments
  20/12/10	2187  		JSU042      	set port expenses for routing points
  07/01/11  2242  		JSU042      	via points in the cargo are not locked
  09/05/11	2265			RMO003			added accepttext to dw_itinerary_route in uf_process
  06/12/11	D-CALC		AGL027			refactor
  19/06/12	CR#2831		AGL027			removed obsolete code 
  20/03/13	CR2658		LHG008			Use new GUI for speed dorpdown.
  28/10/13	CR2658		WWG004			Fix UAT test bug.
  28/10/13	CR2658UAT	ZSW001			Changed columns for sorting
  12/12/13	CR2658UAT	ZSW001			Add function of_refreshspeed()
  26/01/14	CR2658UAT	LHG008			Filter 'Speed' column base on cargo quantity and fix UAT bug.
  26/08/14  CR3622      LHG008			Fix drag&drop issue in itinerary.
  12/09/14	CR3773		XSZ004			Change icon absolute path to reference path
  25/12/14  CR3925      LHG008			Made improvements in function of_refreshspeed().
  21/01/15  CR3921      LHG008			Fix the bug when colunm locked but the backcolor is not changed
  15/04/15	CR3835		LHG008			Fix the usability issue of data displayed format and data transfer between normal view and compact view when the column loses focus
  30/09/15	CR4048      KSH092	      Add active status to consumption dropdown list
  29/10/15	CR3250		CCY018			Add LSFO fuel in calculation module.
  23/12/15	CR3248		LHG008			ECA zone implementation
  14/03/16	CR4292		LHG008			Add function to change bunch speed
  17/03/16	CR2362		LHG008			Remove hard-coded days in Canal
  22/03/16	CR4157		LHG008			Default Speed extended
  31/03/16	CR3787		CCY018			Add atobviac map
  25/05/16	CR3248		CCY018	  		Fixed a bug
  13/10/16	CR4531		LHG008	  		Call procedure to merge itinerary
  08/12/16	CR4050		LHG008			Change additionals Laden and Ballasted logic
  28/02/17	CR4354		LHG008	  		Change the sorting of speed selection to make it more user friendly
  23/03/17	CR4414		CCY018			Add voyage alert
  22/08/17	CR4221		HHX010			Add interim port
********************************************************************/

end subroutine

public subroutine of_refreshspeed ();/********************************************************************
   of_refreshspeed
   <DESC>	Refresh the speed when changing vessel	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the uf_activate() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	12/12/2013   CR2658UAT    ZSW001       First Version
   	26/08/2014   CR3622       LHG008       Clear speed if cons_type changed.
   	25/12/2014   CR3925       LHG008       Made improvements.
   	23/12/2015   CR3248       LHG008       ECA zone implementation
   	14/03/2016   CR4292       LHG008       Reset zone indicating if vessel changed
   </HISTORY>
********************************************************************/

long    ll_row, ll_loop, ll_portcount, ll_conscount, ll_found
long    ll_cons_id, ll_cons_type, ll_zone_id
decimal ld_speed, ld_intake, ld_null
string  ls_typelist, ls_findexpr
boolean lb_vesselchanged

setnull(ld_null)
ll_row = dw_itinerary.getrow()
ll_conscount = iuo_calc_nvo.ids_cal_cons.rowcount()

dw_itinerary.uf_redraw_off()
ll_portcount = dw_itinerary.rowcount()
for ll_loop = 1 to ll_portcount
	if ll_loop = ll_portcount then
		//Clear the last row
		uf_row_set_null(ll_loop)
	else
		ll_cons_id = dw_itinerary.getitemnumber(ll_loop, "cal_cons_id")
		ld_intake = dw_itinerary.getitemnumber(ll_loop, "intake")
		
		if ld_intake = 0 then
			ls_typelist = is_BALLAST_SPEEDLIST
		else
			ls_typelist = is_LADEN_SPEEDLIST
		end if
		
		ls_findexpr = "cal_cons_id = " + string(ll_cons_id) + " and cal_cons_type in(" + ls_typelist + ")"
		ll_found = iuo_calc_nvo.ids_cal_cons.find(ls_findexpr, 1, ll_conscount)
		if ll_found <= 0 then
			if lb_vesselchanged = false then lb_vesselchanged = true
			
			//If the vessel changed we need find the same speed
			SELECT CAL_CONS_TYPE, ZONE_ID, CAST(ISNULL(CAL_CONS_SPEED, 0) as decimal(7, 2)) 
			  INTO :ll_cons_type, :ll_zone_id, :ld_speed 
			  FROM CAL_CONS 
			  WHERE CAL_CONS_ID = :ll_cons_id;
			
			ls_findexpr = "cal_cons_type = " + string(ll_cons_type) + " and cal_cons_type in(" + ls_typelist + ") and zone_id = " &
								+ string(ll_zone_id) + " and cal_cons_speed = " + string(ld_speed) + " and cal_cons_active = 1"
			ll_found = iuo_calc_nvo.ids_cal_cons.find(ls_findexpr, 1, ll_conscount)
			if ll_found <= 0 then
				setnull(ll_cons_id)
				dw_itinerary.setitem(ll_loop, "speed", ld_null)
				dw_itinerary.setitem(ll_loop, "sec_seconds", ld_null)
				dw_itinerary.setitem(ll_loop, "eca_seconds", ld_null)
			else
				ll_cons_id = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_found, "cal_cons_id")
			end if
			
			dw_itinerary.setitem(ll_loop, "cal_cons_id", ll_cons_id)
			
			//Clear the fuel consumption
			dw_itinerary.setitem(ll_loop, "calc_hsfo", ld_null)
			dw_itinerary.setitem(ll_loop, "calc_lsgo", ld_null)
			dw_itinerary.setitem(ll_loop, "calc_hsgo", ld_null)
			dw_itinerary.setitem(ll_loop, "calc_lsfo", ld_null)
			
			of_childmodified()
		end if
	end if
next

//Reset the zone indicating
if lb_vesselchanged then of_defzoneindicating(false, 0)

if ll_row > 0 then
	dw_itinerary.scrolltorow(ll_row)
	dw_itinerary.setrow(ll_row)
end if

dw_itinerary.uf_redraw_on()

end subroutine

public subroutine of_getinactivespeed ();/********************************************************************
   of_getinactivespeed()
   <DESC>		</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	u_atobviac_calculstion.uf_process() <USAGE>
   <HISTORY>
		Date     CR-Ref       Author   Comments
		01/09/15	CR4048       KSH092   First Version
		30/12/15	CR3248       LHG008   ECA zone implementation
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_consid
int li_row, li_active

ll_rowcount = dw_itinerary.RowCount()
if ll_rowcount > 0 then
	for li_row = 1 to ll_rowcount
		ll_consid = dw_itinerary.getitemnumber(li_row,'cal_cons_id')
		SELECT CAL_CONS_ACTIVE
		INTO :li_active
		FROM CAL_CONS
		WHERE CAL_CONS_ID = :ll_consid;
		if li_active = 0 then
			if dw_itinerary.getrow() <> li_row then
				dw_itinerary.setrow(li_row)
				dw_itinerary.scrolltorow(li_row)
			end if
			
			dw_itinerary.setcolumn('cal_cons_id')
			dw_itinerary.setfocus()
			exit
		end if
	next
		
end if
end subroutine

public subroutine of_retrieve (long al_calcid);dw_itinerary.retrieve(al_calcid)
of_datasync("init")
end subroutine

public subroutine of_datasync (string as_type, integer al_rowid, string as_purpose);/********************************************************************
   of_datasync
   <DESC>	Data Synchronization between Cargo/Ballast and Itinerary.
	as_type: 1. "init" - reset the dw_itinerary.row_id column. the row id will get from
					dw_loadports, dw_dischports, dw_calc_ballast.
				2. "in" - according to row id, synchronize dw_loadports, dw_dischports, dw_calc_ballast data to dw_itinerary.
					If the port is not found in dw_itinerary, insert it into dw_itinerary.
				3. "out" - according to row id, synchronize dw_itinerary data to dw_loadports, dw_dischports, dw_calc_ballast
				4. "delete" - used before port deletion in dw_loadports, dw_dischports. Delete port in dw_itinerary according to row id
				
	The ordering in dw_itinerary is based on port_sequence and itinerary_no. The port_sequence for new added port (not ballast port) is 999, 
	It will be the last port but before Ballast To port. The port_sequence is 0 for Ballast From port so that it will be the first row. 
	For Ballast To port, the port_sequence is set to 999, and also the itinerary_no is set to 999, so that it will be the last row.
	The final port order will be sorted, then the value of itinerary_no and port_sequence will be reset to correct order.
	
	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type: "init", "in", "out", "delete"
		al_rowid
		as_purpose
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		16/12/15 CR3248        LHG008   First Version
		23/03/17	CR4414		 CCY018		Add voyage alert
		22/08/17 CR4221		HHX010		Add Interim Port
   </HISTORY>
********************************************************************/

long		ll_itncount, ll_row, ll_cargocount, ll_deletecount, ll_portcount
string	ls_type, ls_port, ls_orig_port, ls_purpose_code, ls_findexpr
long		ll_find, ll_rowid, ll_cargrow, ll_cargo_id
integer	li_port_type, li_loop, li_tmp, li_old_cargo, li_itinerary, li_voyage_alert, li_cal_caio_interim_port
boolean	lb_ballastfrom, lb_ballastto, lb_newrow, lb_delete, lb_modified

u_datawindow_sqlca ldw_cargo
u_atobviac_calc_cargos luo_calc_cargos

luo_calc_cargos = iuo_calc_nvo.iuo_calc_cargos

this.uf_redraw_off()
luo_calc_cargos.uf_redraw_off()

ls_type = lower(as_type)

dw_itinerary.accepttext()

ll_portcount = w_share.dw_calc_port_dddw.rowcount()
ll_itncount = dw_itinerary.rowcount()

//Check if Ballast port exist
if ll_itncount > 0 then
	if dw_itinerary.getitemstring(1, "purpose_code") = 'B' then lb_ballastfrom = true
	if dw_itinerary.getitemstring(ll_itncount, "purpose_code") = 'B' then lb_ballastto = true
end if

choose case ls_type
	case "init", "in"
		if ls_type = 'init' then
			of_setspeedvisible()
			
			for ll_row = 1 to dw_itinerary.rowcount()
				dw_itinerary.setitem(ll_row, "row_id", 0)
			next
		end if
		
		//Load, Discharge
		//Set up local pointer to iuo_calc_cargoes, and select all cargos.
		li_old_cargo = luo_calc_cargos.uf_select_cargo(-1)
		
		ldw_cargo = luo_calc_cargos.dw_loadports
		for li_loop = 1 to 2 //loop for Load, Discharge
			ll_cargocount = ldw_cargo.rowcount()
			for ll_cargrow = 1 to ll_cargocount
				ll_row = 0
				lb_newrow = false
				ll_rowid = ldw_cargo.getrowidfromrow(ll_cargrow)
				ls_port = ldw_cargo.getitemstring(ll_cargrow, "port_code")
				ls_purpose_code = ldw_cargo.getitemstring(ll_cargrow, "purpose_code")
				li_cal_caio_interim_port =  ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_interim_port")
				
				if ll_itncount = 0 then
					lb_newrow = true
				else
					if ls_type = 'init' then
						//Init rowid for data which has been saved
						ls_findexpr = "port_code = '" + ls_port + "' and purpose_code = '" + ls_purpose_code + "' and row_id = 0"
					else
						//Since row_id can be the same in different DW, the port in dw_itinerary need to be found out by purpose_code and row_id.
						if ls_purpose_code = 'D' then
							ls_findexpr = "purpose_code = 'D'" + " and row_id = " + string(ll_rowid)
						else
							ls_findexpr = "purpose_code not in('D', 'B') and row_id = " + string(ll_rowid)
						end if
					end if
					
					ll_find = dw_itinerary.find(ls_findexpr, 1, ll_itncount)
					if ll_find > 0 then
						ll_row = ll_find
					elseif ll_find = 0 then
						lb_newrow = true
					end if
				end if
				
				if lb_newrow then
					if lb_ballastto then
						ll_row = dw_itinerary.insertrow(dw_itinerary.rowcount())
					else
						ll_row = dw_itinerary.insertrow(0)
					end if
				else
					//Check if port changed then clear distance and eca_distance for the port and previous prot
					ls_orig_port = dw_itinerary.getitemstring(ll_row, "port_code")
					if ls_orig_port <> ls_port then
						if ll_row > 1 then
							uf_row_set_null(ll_row - 1)
						end if
						uf_row_set_null(ll_row)
					end if
				end if
				
				if ll_row > 0 then
					dw_itinerary.setitem(ll_row, "row_id", ll_rowid)
					dw_itinerary.setitem(ll_row, "port_code", ls_port)
					dw_itinerary.setitem(ll_row, "routing_point", iuo_calc_nvo.uf_portcode_to_name(ls_port))
					dw_itinerary.setitem(ll_row, "purpose_code", ls_purpose_code)
					dw_itinerary.setitem(ll_row, "cal_caio_interim_port", li_cal_caio_interim_port)
					dw_itinerary.setitem(ll_row, "units", ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_number_of_units"))
					li_itinerary = ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_itinerary_number")
					dw_itinerary.setitem(ll_row, "itinerary_no", li_itinerary)
					
					dw_itinerary.setitem(ll_row, "port_expenses", ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_total_port_expenses"))
					
					if ldw_cargo.getitemnumber(ll_cargrow, "edit_locked") <> 0 then li_tmp = 1 else li_tmp = 0
					dw_itinerary.setitem(ll_row, "proceeding_locked", li_tmp)
					
					//Initial value for combine_distance, combine_sec_seconds is 0. It is from Cargo.
					if ls_type = 'init' then
						dw_itinerary.setitem(ll_row, "combine_distance", ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_distance_to_previous"))
						dw_itinerary.setitem(ll_row, "combine_sec_seconds", ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_days_at_sea"))
					end if
					
					//0:PORT, 1:VIA PORT, 2:CANAL, -1:ECA
					ll_find = w_share.dw_calc_port_dddw.find("port_code='" + ls_port + "'", 1, ll_portcount)
					if ll_find > 0 then
						li_port_type = w_share.dw_calc_port_dddw.getitemnumber(ll_find, "via_point")
						dw_itinerary.setitem(ll_row, "port_type", li_port_type)
					end if
					
					if lb_newrow then
						dw_itinerary.setitem(ll_row, "port_sequence", 999)
					end if
					
					//Find charterer from dw_cargo_summary
					ll_cargo_id = ldw_cargo.getitemnumber(ll_cargrow, "cal_carg_id")
					if ll_cargo_id < 0 then
						ll_find = abs(ll_cargo_id)
					else
						ls_findexpr = "cal_carg_id = " + string(ll_cargo_id)
						ll_find = luo_calc_cargos.dw_cargo_summary.find(ls_findexpr, 1, luo_calc_cargos.dw_cargo_summary.rowcount())
					end if
					
					if ll_find > 0 then
						dw_itinerary.setitem(ll_row, "charterer", luo_calc_cargos.dw_cargo_summary.getitemstring(ll_find, "compute_0046"))
					end if
				end if
			next
			ldw_cargo = luo_calc_cargos.dw_dischports
		next
		luo_calc_cargos.uf_select_cargo(li_old_cargo)
		
		//Get port info from the Ballast datawindow.
		ldw_cargo = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
		ll_cargocount = ldw_cargo.rowcount()
		for ll_cargrow = 1 to ll_cargocount
			ll_row = 0
			lb_newrow = false
			ll_rowid = ldw_cargo.getrowidfromrow(ll_cargrow)
			ls_port = ldw_cargo.getitemstring(ll_cargrow, "port_code")
			
			//Find out the port to be deleted in dw_itinerary
			if isnull(ls_port) or len(trim(ls_port)) < 1 then
				if ll_cargrow = 1 and lb_ballastfrom then
					ll_row = 1
				elseif ll_cargrow = 2 and lb_ballastto then
					ll_row = dw_itinerary.rowcount()
				end if
				
				dw_itinerary.rowsdiscard(ll_row, ll_row, Primary!)
				continue
			end if
			
			if ll_cargrow = 1 then
				if lb_ballastfrom then
					ll_row = 1
				else
					ll_row = dw_itinerary.insertrow(1)
					lb_newrow = true
					dw_itinerary.setitem(ll_row, "port_sequence", 0)
				end if
				li_itinerary = 0
			elseif ll_cargrow = 2 then
				if lb_ballastto then
					ll_row = dw_itinerary.rowcount()
				else
					ll_row = dw_itinerary.insertrow(0)
					lb_newrow = true
				end if
				
				dw_itinerary.setitem(ll_row, "port_sequence", 999)
				li_itinerary = 999
			end if
			
			//Check if port changed then clear distance and eca_distance for the port/previous prot
			if not lb_newrow then
				ls_orig_port = dw_itinerary.getitemstring(ll_row, "port_code")
				if ls_orig_port <> ls_port then
					if ll_row > 1 then
						uf_row_set_null(ll_row - 1)
					else
						uf_row_set_null(ll_row)
					end if
				end if
			end if
			
			if ll_row > 0 then
				dw_itinerary.setitem(ll_row, "row_id", ll_rowid)
				dw_itinerary.setitem(ll_row, "port_code", ls_port)
				dw_itinerary.setitem(ll_row, "routing_point", iuo_calc_nvo.uf_portcode_to_name(ls_port))
				dw_itinerary.setitem(ll_row, "itinerary_no", li_itinerary)
				dw_itinerary.setitem(ll_row, "proceeding_locked", 1)
				
				if ls_type = 'init' then
					dw_itinerary.setitem(ll_row, "combine_distance", ldw_cargo.getitemnumber(ll_cargrow, "cal_ball_distance_to_previous"))
					dw_itinerary.setitem(ll_row, "combine_sec_seconds", ldw_cargo.getitemnumber(ll_cargrow, "cal_ball_days_at_sea"))
				end if
				
				//0:PORT, 1:VIA PORT, 2:CANAL, -1:ECA
				ll_find = w_share.dw_calc_port_dddw.find("port_code='" + ls_port + "'", 1, ll_portcount)
				if ll_find > 0 then
					li_port_type = w_share.dw_calc_port_dddw.getitemnumber(ll_find, "via_point")
					dw_itinerary.setitem(ll_row, "port_type", li_port_type)
				end if
				
				if lb_newrow then
					dw_itinerary.setitem(ll_row, "purpose_code", 'B')
					dw_itinerary.setitem(ll_row, "units", 0)
				end if
			end if
		next
		
	case "out"
		//Set up local pointer to iuo_calc_cargoes, and select all cargos.
		li_old_cargo = luo_calc_cargos.uf_select_cargo(-1)
		
		//Update the distance, days_at_sea and speed field in either the CAL_CAIO or CAL_BALL table.
		for ll_row = 1 to ll_itncount
			ls_purpose_code = dw_itinerary.getitemstring(ll_row, "purpose_code")
			if ls_purpose_code = 'B' then
				ldw_cargo = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
				if ll_row = 1 then
					ll_cargrow = 1
				else
					ll_cargrow = 2
				end if
				
				//If calculated then update the distance and days_at_sea
				ldw_cargo.setitem(ll_cargrow, "cal_ball_distance_to_previous", dw_itinerary.getitemnumber(ll_row, "combine_distance"))
				ldw_cargo.setitem(ll_cargrow, "cal_ball_days_at_sea", dw_itinerary.getitemnumber(ll_row, "combine_sec_seconds"))
				ldw_cargo.setitem(ll_cargrow, "cal_ball_leg_speed", dw_itinerary.getitemnumber(ll_row, "speed"))
				ldw_cargo.setitem(ll_cargrow, "cal_cons_id", dw_itinerary.getitemnumber(ll_row, "cal_cons_id"))
				continue
			elseif ls_purpose_code = 'D' then
				ldw_cargo = luo_calc_cargos.dw_dischports
			else
				ldw_cargo = luo_calc_cargos.dw_loadports
			end if
			
			ll_rowid = dw_itinerary.getitemnumber(ll_row, "row_id")
			ll_cargrow = ldw_cargo.getrowfromrowid(ll_rowid)
			if ll_cargrow > 0 then
				li_itinerary = dw_itinerary.getitemnumber(ll_row, "itinerary_no")
				
				if lb_ballastfrom then li_itinerary --
				if li_itinerary <> ldw_cargo.getitemnumber(ll_cargrow, "cal_caio_itinerary_number") then lb_modified = true
				
				ldw_cargo.setitem(ll_cargrow, "cal_caio_itinerary_number", li_itinerary)
				
				//If calculated then update the distance and days_at_sea
				ldw_cargo.setitem(ll_cargrow, "cal_caio_distance_to_previous", dw_itinerary.getitemnumber(ll_row, "combine_distance"))
				ldw_cargo.setitem(ll_cargrow, "cal_caio_days_at_sea", dw_itinerary.getitemnumber(ll_row, "combine_sec_seconds"))
				ldw_cargo.setitem(ll_cargrow, "cal_caio_leg_speed", dw_itinerary.getitemnumber(ll_row, "speed"))
				ldw_cargo.setitem(ll_cargrow, "sailing_cons_id", dw_itinerary.getitemnumber(ll_row, "cal_cons_id"))
			end if
		next
		
		luo_calc_cargos.uf_select_cargo(li_old_cargo)
		
		luo_calc_cargos.dw_loadports.Sort()
		luo_calc_cargos.dw_dischports.Sort()
		
		this.uf_redraw_on()
		luo_calc_cargos.uf_redraw_on()
		return
	case "add"
		//
	case "delete"
		if as_purpose = 'D' or as_purpose = 'B' then
			ls_findexpr = "purpose_code = '" + as_purpose + "' and row_id = " + string(al_rowid)
		else
			ls_findexpr = "purpose_code not in('D', 'B') and row_id = " + string(al_rowid)
		end if
		
		ll_find = dw_itinerary.find(ls_findexpr, 1, ll_itncount)
		if ll_find > 0 then
			dw_itinerary.rowsdiscard(ll_find, ll_find, Primary!)
			if ll_find > 1 then uf_row_set_null(ll_find - 1)
		end if
end choose

dw_itinerary.sort()
dw_itinerary.groupcalc()

//Reset itinerary_no and port_sequence
li_itinerary = 0
li_old_cargo = luo_calc_cargos.uf_select_cargo(-1)
for ll_row = 1 to dw_itinerary.rowcount()
	ls_purpose_code = dw_itinerary.getitemstring(ll_row, "purpose_code")
	ls_port = dw_itinerary.getitemstring(ll_row, "port_code")
	li_voyage_alert = of_get_voyage_alert_status(ls_port)
	
	if len(trim(ls_purpose_code)) > 0 then
		//Check and delete prot scraps in itinerary
		ll_rowid = dw_itinerary.getitemnumber(ll_row, "row_id")
		if isnull(ll_rowid) then ll_rowid = 0
		
		if ls_purpose_code = 'D' then
			ldw_cargo = luo_calc_cargos.dw_dischports
		elseif ls_purpose_code = 'B' then
			ldw_cargo = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
		else
			ldw_cargo = luo_calc_cargos.dw_loadports
		end if
		
		ll_cargrow = ldw_cargo.getrowfromrowid(ll_rowid)
		if ll_cargrow > 0 then //Reset itinerary_no
			li_itinerary ++
			dw_itinerary.setitem(ll_row, "itinerary_no", li_itinerary)
		else
			dw_itinerary.rowsdiscard(ll_row, ll_row, Primary!)
			lb_modified = true
		end if
	end if
	
	//Reset port_sequence
	dw_itinerary.setitem(ll_row, "port_sequence", ll_row)
	
	dw_itinerary.setitem(ll_row, "voyage_alert", li_voyage_alert)
	dw_itinerary.setitemstatus(ll_row, "voyage_alert", primary!, notmodified!)
next
luo_calc_cargos.uf_select_cargo(li_old_cargo)

if lb_modified then of_childmodified()

dw_itinerary.event ue_filterconsdddw(dw_itinerary.getrow(), true)

this.uf_redraw_on()
luo_calc_cargos.uf_redraw_on()

end subroutine

public subroutine of_datasync (string as_type);
of_datasync(as_type, 0, '')


end subroutine

public function integer of_checkportorder (mt_u_datawindow adw_itinerary, integer ai_from, integer ai_to);/********************************************************************
   of_checkportorder
   <DESC>validate the L port or D port order when dropping ports</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS></ACCESS>
   <ARGS>
		adw_itinerary
		ai_from
		ai_to
   </ARGS>
   <USAGE>Called by ue_rowdragged </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/01/16		CR3933		CCY018		First Version.
	22/08/17		CR4221		HHX010		Check Interim Port	
   </HISTORY>
********************************************************************/

integer li_row, li_rows, li_find, li_step, li_currow, li_interim_port
string ls_purposecode
mt_n_datastore lds_itinerary
string ls_errtext 

ls_errtext = "You cannot use an interim port as first or last port in the Itinerary."

li_rows = adw_itinerary.rowcount()
lds_itinerary = create mt_n_datastore
lds_itinerary.dataobject = adw_itinerary.dataobject
adw_itinerary.rowscopy( 1, li_rows, primary!, lds_itinerary, 1, primary!)

//sort itinerary after draged
If ai_from > ai_to Then
	For li_row = ai_to To li_rows
		lds_itinerary.SetItem(li_row, "port_sequence", li_row + 1 )
	Next
Else
	For li_row = 1 To ai_to
		lds_itinerary.SetItem(li_row, "port_sequence", li_row -1 )
	Next
End if

lds_itinerary.setitem(ai_from, "port_sequence", ai_to)

lds_itinerary.sort( )

//from top to bottom or down to top to validated
if ai_from < ai_to then
	li_step = -1
else
	li_step = 1
end if


li_currow = ai_to
for li_row = min(ai_from, ai_to) to max(ai_from, ai_to) 
	ls_purposecode = lds_itinerary.getitemstring(li_currow, "purpose_code")
	if isnull(ls_purposecode) then ls_purposecode = ""
	li_interim_port = lds_itinerary.object.cal_caio_interim_port[li_currow]
	if isnull(li_interim_port) then li_interim_port = 0
	
	if ls_purposecode = "L" or ls_purposecode = "D" then
		li_find = 0

		if ls_purposecode = "L" then
			if li_currow < li_rows then li_find = lds_itinerary.find("purpose_code='D'", li_currow + 1, li_rows)
			if li_currow = li_rows or li_find = 0 then
				messagebox("Notice", "You cannot set a load port after the last discharge port.")
				return c#return.Failure
			end if
		end if
		
		if ls_purposecode = "D" then
			if li_currow > 1 then li_find = lds_itinerary.find("purpose_code='L'", 1, li_currow - 1)
			if li_currow = 1 or li_find = 0 then
				messagebox("Notice", "You cannot set a discharge port before the first load port.")
				return c#return.Failure
			end if
		end if
		
	end if
	
	li_currow = li_currow + li_step
next

li_currow = ai_to
for li_row = min(ai_from, ai_to) to max(ai_from, ai_to) 
	ls_purposecode = lds_itinerary.getitemstring(li_currow, "purpose_code")
	if isnull(ls_purposecode) then ls_purposecode = ""
	li_interim_port = lds_itinerary.object.cal_caio_interim_port[li_currow]
	if isnull(li_interim_port) then li_interim_port = 0
	
	if li_interim_port = 1 then
		if ls_purposecode = "L" then		
			if li_currow > 1 then li_find = lds_itinerary.find("purpose_code='L' and cal_caio_interim_port = 0", 1, li_currow - 1)
			if li_currow = 1 or li_find = 0 then
				inv_msgbox.of_messagebox(inv_msgbox.is_TYPE_GENERAL_ERROR, ls_errtext, this)
				return c#return.Failure
			end if
		end if
		
		if ls_purposecode = "D" then
			if li_currow < li_rows then li_find = lds_itinerary.find("purpose_code='D' and cal_caio_interim_port = 0", li_currow , li_rows)
			if li_currow = li_rows or li_find = 0 then
				inv_msgbox.of_messagebox(inv_msgbox.is_TYPE_GENERAL_ERROR, ls_errtext, this)
				return c#return.Failure
			end if	
		end if
	end if
		
	li_currow = li_currow + li_step
next


destroy lds_itinerary

return c#return.Success
end function

public function integer of_getabcportsequence (u_datawindow_sqlca adw_itinerary, ref string as_abcportsequence[]);/********************************************************************
   of_getabcportsequence
   <DESC>	Get AtoBviaC port sequence	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_itinerary
		as_abcportsequence[]
   </ARGS>
   <USAGE>	Call by uf_process()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		16/12/15 CR3248        LHG008   First Version
		25/05/16	CR3248		 CCY018	  Fixed a bug
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount, ll_portcount, ll_portindex, ll_abcportindex, ll_found
string ls_portsequence[]
mt_n_datastore lds_itinerary

ll_rowcount = adw_itinerary.rowcount()
lds_itinerary = create mt_n_datastore
lds_itinerary.dataobject = adw_itinerary.dataobject
adw_itinerary.rowscopy(1, ll_rowcount, primary!, lds_itinerary, 1, primary!)

lds_itinerary.setfilter("itinerary_no > 0")
lds_itinerary.filter()

as_abcportsequence = ls_portsequence

ll_portcount = w_share.dw_calc_port_dddw.rowcount()
ll_rowcount = lds_itinerary.rowcount()
for ll_row = 1 to ll_rowcount
	ll_portindex ++
	ls_portsequence[ll_portindex] = lds_itinerary.getitemstring(ll_row, "port_code")
	
	if isnull(ls_portsequence[ll_portindex]) or trim(ls_portsequence[ll_portindex], true) = "" then continue
	
	ll_found = w_share.dw_calc_port_dddw.find("port_code='" + ls_portsequence[ll_portindex] + "'", 1, ll_portcount)
	if ll_found > 0 then
		ll_abcportindex ++
		as_abcportsequence[ll_abcportindex] = w_share.dw_calc_port_dddw.getItemString(ll_found, "abc_port_portcode")
	end if
next

destroy lds_itinerary
return ll_abcportindex
end function

public subroutine of_mapitinerary ();/********************************************************************
   of_mapitinerary
   <DESC>This function runs through the engine route and generates the Itinerary route</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS></ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16/12/15		CR3248		CCY018		First Version.
	23/03/17		CCY018		CCY018		Add voyage alert
   </HISTORY>
********************************************************************/

blob lbl_data
mt_n_datastore lds_engineroute
long ll_routerows, ll_routerow
long ll_itineraryrows, ll_itineraryrow, ll_itinstartrow , ll_itinnextrow, ll_itineraryrouterow=0
long ll_found, ll_finditin, ll_itinerary_no, ll_prefound, ll_newrow
integer li_eca, li_preeca, li_ecaleg, li_porttype, li_voyage_alert
string ls_abcpc, ls_portcode, ls_portname, ls_abcportcode, ls_routeportname
boolean lb_update
decimal{2} ld_distance, ld_ecadistance, ld_sumdistance, ld_sumecadistance, ld_null

setnull(ld_null)

/* Build new Itinerary Route */
/* Get Route from Control to local variable */
lds_engineroute = create mt_n_datastore
lbl_data = tab_itinerary.tp_routecontrol.uo_enginecontrol.of_getengineroute( )
lds_engineroute.setfullstate( lbl_data )

ll_itineraryrows = dw_itinerary.rowcount()
ll_routerows = lds_engineroute.rowcount( )

ll_itinstartrow = dw_itinerary.find("itinerary_no = 1", 1, ll_itineraryrows)
ll_itinnextrow = dw_itinerary.find("itinerary_no = 2", ll_itinstartrow, ll_itineraryrows)
if ll_itinstartrow <=0 or ll_itinnextrow <= 0 then 
	destroy lds_engineroute
	return
end if

//if have a distance < 0, then not generate the vp point
if not of_checkportdist() then
	of_setportdist()
	destroy lds_engineroute
	return
end if

//initialize the port sequence and abc_portcode
for ll_itineraryrow = 1 to ll_itineraryrows
	dw_itinerary.setitem(ll_itineraryrow, "port_sequence", 0)
	ls_portcode = dw_itinerary.getitemstring(ll_itineraryrow, "port_code")
	
	if not isnull(ls_portcode) and ls_portcode <> "" then
		ll_found = w_share.dw_calc_port_dddw.find("port_code = '" +  ls_portcode  + "'", 1, 999999)
		if ll_found > 0 then
			ls_abcpc = w_share.dw_calc_port_dddw.getitemstring(ll_found, "abc_port_portcode")
			dw_itinerary.setitem(ll_itineraryrow, "abc_portcode", ls_abcpc)
		end if
	end if
next

li_ecaleg = 0 //the eca leg, for group by
li_preeca = 0
ll_prefound = 0
for ll_routerow = 1 to ll_routerows
	if ll_itinnextrow = 0 then exit
	ls_abcpc = lds_engineroute.getitemstring(ll_routerow, "portcode")
	ls_routeportname = lds_engineroute.getitemstring(ll_routerow, "portname")
	
	//get the distance, eca_dist and eca state.
	if ll_routerow < ll_routerows then
		ld_distance = lds_engineroute.getitemnumber(ll_routerow + 1, "distance")
		ld_ecadistance = lds_engineroute.getitemnumber(ll_routerow + 1, "eca_distance")
		li_eca = lds_engineroute.getitemnumber(ll_routerow + 1, "eca")
		
		if isnull(ld_distance) then ld_distance = 0
		if isnull(ld_ecadistance) then ld_ecadistance = 0
		if isnull(li_eca) then li_eca = 0
		if li_preeca = 0 and li_eca = 1 then li_ecaleg ++
		
		if li_preeca = 1 and li_eca = 1 and pos(lower(ls_abcpc), "secascanner - exit", 1) > 0 then
			if pos(lower(ls_abcpc), "enter ", len("secascanner - exit") + 1) > 0 then li_ecaleg ++
		end if
	end if
	
	//Find out if port is a really port form itinerary
	lb_update = false
	ll_found = w_share.dw_calc_port_dddw.find("abc_port_portcode = '" + ls_abcpc + "'", 1, 999999)
	if ll_found > 0 then
		ll_finditin = dw_itinerary.find("abc_portcode = '" + ls_abcpc + "' and port_sequence = 0 and itinerary_no > 0", ll_itinstartrow, ll_itinnextrow)
		if ll_finditin = 0 then
			ll_finditin = dw_itinerary.find("abc_portcode = '" + ls_abcpc + "' and port_sequence = 0", ll_itinstartrow, ll_itinnextrow)
		end if
		if ll_finditin > 0 then //Itinerary port
			ls_portcode = dw_itinerary.getitemstring(ll_finditin, "port_code")
			ls_portname = dw_itinerary.getitemstring(ll_finditin, "routing_point")
			li_porttype = dw_itinerary.getItemNumber(ll_finditin, "port_type")
		else // Viapoint Canal from port table
			ls_portcode = w_share.dw_calc_port_dddw.getitemstring(ll_found, "port_code")
			ls_portname = w_share.dw_calc_port_dddw.getitemstring(ll_found, "port_n")
			li_porttype = w_share.dw_calc_port_dddw .getItemNumber(ll_found, "via_point")
		end if
		lb_update = true
	else
		if pos(lower(ls_abcpc), "secascanner", 1) > 0 then //(s)eca point
			ls_portcode = ""
			ls_portname = ls_routeportname
			li_porttype = -1
			lb_update = true
		end if
	end if
	
	//if the port not exist in itinerary, then insert a new row, else keep the row as is
	if lb_update then
		if ls_portcode <> "" then
			ll_found = dw_itinerary.find("abc_portcode = '" + ls_abcpc + "' and port_sequence = 0 and itinerary_no > 0", ll_itinstartrow, ll_itinnextrow)
			if ll_found = 0 then
				ll_found = dw_itinerary.find("abc_portcode = '" + ls_abcpc + "' and port_sequence = 0", ll_itinstartrow, ll_itinnextrow)
			end if
		else
			ll_found = dw_itinerary.find("routing_point = '" + ls_routeportname + "' and port_sequence = 0", ll_itinstartrow, ll_itinnextrow)
		end if
		
		if ll_found > 0 then 
			ll_newrow = ll_found
		else
			ll_newrow = dw_itinerary.insertrow(ll_itinnextrow)
			ll_itinnextrow ++
		end if
		
		ll_itineraryRouteRow ++
		dw_itinerary.setitem(ll_newrow, "port_code", ls_portcode)
		dw_itinerary.setitem(ll_newrow, "port_sequence", ll_itineraryRouteRow )
		dw_itinerary.setitem(ll_newrow, "distance", ld_null)
		dw_itinerary.setitem(ll_newrow, "eca_distance", ld_null)
		dw_itinerary.setitem(ll_newrow, "routing_point", ls_portname)
		dw_itinerary.setitem(ll_newrow, "port_type", li_porttype)
		if li_eca = 1 then
			dw_itinerary.setitem(ll_newrow, "eca_point", li_ecaleg )
		else
			dw_itinerary.setitem(ll_newrow, "eca_point", 0 )
		end if
		
		li_voyage_alert = of_get_voyage_alert_status(ls_portcode)
		dw_itinerary.setitem(ll_newrow, "voyage_alert", li_voyage_alert)
		dw_itinerary.setitemstatus(ll_newrow, "voyage_alert", primary!, notmodified!)
		
		//if itinerary_no >0, continue to find next leg
		ll_itinerary_no = dw_itinerary.getitemnumber(ll_newrow, "itinerary_no")
		if isnull(ll_itinerary_no) then ll_itinerary_no = 0
		if ll_itinerary_no > 0 then 
			ll_itinstartrow = ll_newrow
			ll_itinnextrow = dw_itinerary.find("itinerary_no = " + string(ll_itinerary_no + 1), ll_itinstartrow, dw_itinerary.rowcount())
		end if
		
		//set port distance for the itinerary port 
		if ll_prefound > 0 then
			dw_itinerary.setitem(ll_prefound, "distance", ld_sumdistance)
			if dw_itinerary.getitemnumber(ll_prefound, "eca_point") <> 0 then
				dw_itinerary.setitem(ll_prefound, "eca_distance", ld_sumecadistance)
			end if
			ld_sumdistance = 0
			ld_sumecadistance = 0
		end if
		
		ll_prefound = ll_newrow
	end if
	
	li_preeca = li_eca
	ld_sumdistance += ld_distance
	ld_sumecadistance += ld_ecadistance
next

/* Discard rows in Itinerary Route rows that not have to be mapped to proceeding */
ll_itineraryrows = dw_itinerary.rowcount()
for ll_itineraryrow = ll_itineraryrows to 1 step -1
	if dw_itinerary.getitemnumber(ll_itineraryrow, "port_sequence") = 0 then dw_itinerary.rowsdiscard(ll_itineraryrow, ll_itineraryrow, primary!)
next

dw_itinerary.sort()
dw_itinerary.groupcalc()

destroy lds_engineroute
return 

end subroutine

public function boolean of_showcombinedata ();/********************************************************************
   of_showcombinedata
   <DESC>	Check whether we need combine data to row which have itinerary no.
				For now we only combine data when seca is not enabled	</DESC>
   <RETURN>	boolean:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/01/16 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

return not iuo_calc_nvo.iuo_calculation.of_isecaenabled()
end function

public subroutine of_setspeedvisible ();/********************************************************************
   of_setspeedvisible
   <DESC>	Set speed column visible or invisible. if of_showcombinedata() = true, 
				then only visible speed for the row which have itinerary (itinerary_no>0)	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/01/16 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

if of_showcombinedata() then
	dw_itinerary.modify("datawindow.processing = '0' cal_cons_id.visible = '1~tif(itinerary_no > 0, if(getrow() = rowcount(), 0, if(getrow() = currentrow(), 1, 0)), 0)' datawindow.processing = '1'")
	dw_itinerary.modify("datawindow.processing = '0' speed.visible = '1~tif(itinerary_no > 0, if(getrow() = rowcount(), 0, if(getrow() = currentrow(), 0, 1)), 0)' datawindow.processing = '1'")
else
	dw_itinerary.modify("datawindow.processing = '0' cal_cons_id.visible = '1~tif(getrow() = rowcount(), 0, if(getrow() = currentrow(), 1, 0))' datawindow.processing = '1'")
	dw_itinerary.modify("datawindow.processing = '0' speed.visible = '1~tif(getrow() = rowcount(), 0, if(getrow() = currentrow(), 0, 1))' datawindow.processing = '1'")
end if

end subroutine

public function boolean of_saveitinerary (long al_calc_id, long al_est_id);/********************************************************************
   of_saveitinerary
   <DESC>	Stores the itinerary and route to the database. 	</DESC>
   <RETURN>	integer:
            <LI> true: 1, ok
            <LI> false: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_calc_id
		al_est_id
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		24/12/15 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

long ll_row

DELETE FROM CAL_ITINERARY WHERE CAL_CALC_ID = :al_calc_id;

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("Delete Error", "Failed to delete itinerary")
	return false
end if

dw_itinerary.resetupdate()

for ll_row = 1 to dw_itinerary.rowcount()
	dw_itinerary.setItem(ll_row, "cal_calc_id", al_calc_id)
	dw_itinerary.setitemstatus(ll_row, 0, Primary!, NewModified!)
next

if dw_itinerary.update() <> 1 then
	rollback;
	messagebox("Update Error", "Failed to update itinerary")
	return false
end if

if al_est_id <> 0 then /* also update estimated calculation */
	DELETE FROM CAL_ITINERARY WHERE CAL_CALC_ID = :al_est_id;
	
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("Delete Error", "Failed to delete estimated itinerary")
		return false
	end if
	
	for ll_row = 1 to dw_itinerary.rowcount()
		dw_itinerary.setItem(ll_row, "cal_calc_id", al_est_id)
		dw_itinerary.setitemstatus(ll_row, 0, Primary!, NewModified!)
	next
	
	if dw_itinerary.update() <> 1 then
		rollback;
		messagebox("Update Error", "Failed to update estimated itinerary")
		return false
	end if
end if

if uf_saveroute(al_calc_id, al_est_id) <> 1 then return false

return true
end function

public function integer of_generate_route ();/********************************************************************
   of_generate_route
   <DESC>	Generate the itinerary route	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by uf_saveroute()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		30/12/15 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

long    ll_calc_id, ll_cons_id, lal_cons_id[]
integer li_row, li_rowcount, li_routerow, li_port_type
string  ls_purpose, ls_prev_purpose, ls_port_code, ls_prev_port_code
decimal ld_expenses, ld_prev_expenses

tab_itinerary.tp_itinerary.dw_itinerary_route.reset()

li_rowcount = dw_itinerary.rowcount()
for li_row = 1 to li_rowcount
	li_port_type = dw_itinerary.getitemnumber(li_row, "port_type")
	
	//If is ECA then continue
	if li_port_type < 0 then continue
	
	ll_calc_id = dw_itinerary.getitemnumber(li_row, "cal_calc_id")
	ls_port_code = dw_itinerary.getitemstring(li_row, "port_code")
	ls_purpose = dw_itinerary.getitemstring(li_row, "purpose_code")
	ll_cons_id = dw_itinerary.getitemnumber(li_row, "cal_cons_id")
	ld_expenses = dw_itinerary.getitemnumber(li_row, "rp_expenses")
	
	if isnull(ls_purpose) then ls_purpose = ''
	if li_row > 1 then
		if ls_port_code = ls_prev_port_code then
			
			//Merge port, if it has the same purpose. And use the last speed (cal_cons_id)
			if ls_purpose = ls_prev_purpose then
				tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_cons_id", ll_cons_id)
				if li_port_type = ii_VIA_PORT then
					ld_prev_expenses = tab_itinerary.tp_itinerary.dw_itinerary_route.getitemnumber(li_routerow, "cal_route_rp_expenses")
					if isnull(ld_prev_expenses) then ld_prev_expenses = 0
					if ld_expenses > 0 then
						ld_expenses += ld_prev_expenses
						tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_route_rp_expenses", ld_expenses)
					end if
				end if
				continue
			elseif ((ls_prev_purpose = 'L' and ls_purpose = 'D') or (ls_prev_purpose = 'D' and ls_purpose = 'L')) then
				//Merge 'L/D' prot
				ls_purpose = 'L/D'
				
				tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_cons_id", ll_cons_id)
				tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "purpose_code", ls_purpose)
				continue
			end if
		end if
	end if
	
	li_routerow = tab_itinerary.tp_itinerary.dw_itinerary_route.insertrow(0)
	if li_routerow > 0 then
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_route_cal_calc_id", ll_calc_id)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_route_port_sequence", li_routerow)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "port_code", ls_port_code)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_route_rp_expenses", ld_expenses)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "purpose_code", ls_purpose)
		tab_itinerary.tp_itinerary.dw_itinerary_route.setitem(li_routerow, "cal_cons_id", ll_cons_id)
	else
		messagebox("Error", "Failed to generate itinerary route")
		return c#return.Failure
	end if
	
	ls_prev_port_code = ls_port_code
	ls_prev_purpose = ls_purpose
next

//Adjust leave speed to arrival speed
if li_routerow > 1 then
	lal_cons_id = tab_itinerary.tp_itinerary.dw_itinerary_route.object.cal_cons_id.Primary[1, li_routerow - 1]
	tab_itinerary.tp_itinerary.dw_itinerary_route.object.cal_cons_id.Primary[2, li_routerow] = lal_cons_id
end if

return c#return.Success
end function

public function boolean of_checkportdist ();/********************************************************************
   of_checkportdist
   <DESC>calculated the distance between two ports on this leg.
	if distance < 0 return false, else return true
	</DESC>
   <RETURN>	boolean</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/12/15		CR3248		CCY018		First Version.
   </HISTORY>
********************************************************************/

long ll_row
integer li_distance
string ls_portcode, ls_nextportcode, ls_errtext
boolean lb_return
mt_n_datastore lds_itinerary

lds_itinerary = create mt_n_datastore
lds_itinerary.dataobject = dw_itinerary.dataobject
dw_itinerary.rowscopy( 1, dw_itinerary.rowcount(), primary!, lds_itinerary, 1, primary!)

lds_itinerary.setfilter("itinerary_no > 0")
lds_itinerary.filter()

lb_return = true

for ll_row = 1 to lds_itinerary.rowcount()
	if ll_row < lds_itinerary.rowcount() then
		ls_portcode = lds_itinerary.getitemstring( ll_row, "port_code")
		ls_nextportcode = lds_itinerary.getitemstring( ll_row + 1, "port_code")
		ls_errtext = ""
		if not uf_point_distance(ls_portcode, ls_nextportcode, li_distance, ls_errtext) then 
			lb_return = false
		end if
			
		if ls_errtext <> "" then 
			lb_return = false
		end if
	end if
next

destroy lds_itinerary

return lb_return
end function

public subroutine of_setportdist ();/********************************************************************
   of_setportdist
   <DESC>set the itinerary port distance, call the iuo_calc_nvo.uf_distance function</DESC>
   <RETURN></RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	called by of_mapitinerary</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/12/15		CR3248		CCY018		First Version.
   </HISTORY>
********************************************************************/

integer li_itinerary_no, li_porttype
long ll_row, ll_distance, ll_sequence, ll_find, ll_findport, ll_itineraryrows
string ls_portcode, ls_nextportcode
decimal{2} ld_null

setnull(ld_null)

for ll_row = 1 to dw_itinerary.rowcount()
	li_itinerary_no = dw_itinerary.getitemnumber(ll_row, "itinerary_no")
	if li_itinerary_no > 0 then 
		dw_itinerary.setitem(ll_row, "port_sequence", li_itinerary_no )
	else
		dw_itinerary.setitem(ll_row, "port_sequence", 0 )
	end if
next

for ll_row = 1 to dw_itinerary.rowcount() - 1	
	li_itinerary_no = dw_itinerary.getitemnumber(ll_row, "itinerary_no")
	if li_itinerary_no > 0 then
		ls_portcode = dw_itinerary.getitemstring( ll_row, "port_code")
		ll_find = dw_itinerary.find("itinerary_no > 0", ll_row + 1, dw_itinerary.rowcount())
		if ll_find  > 0 then
			ls_nextportcode = dw_itinerary.getitemstring( ll_find, "port_code")
			ll_distance = iuo_calc_nvo.uf_distance(ls_portcode, ls_nextportcode)
			if ll_distance < 0 then ll_distance = 0
			li_porttype = 0
			ll_findport = w_share.dw_calc_port_dddw.find("port_code = '" + ls_portcode + "'", 1, 999999)
			if ll_findport > 0 then li_porttype = w_share.dw_calc_port_dddw.getitemnumber(ll_findport, "via_point")
			dw_itinerary.setitem(ll_row, "distance", ll_distance)
			dw_itinerary.setitem(ll_row, "eca_distance", ld_null)
			dw_itinerary.setitem(ll_row, "port_type", li_porttype)
			dw_itinerary.setitem(ll_row, "eca_point", 0 )
		end if
	end if
next

ll_itineraryrows = dw_itinerary.rowcount()
for ll_row = ll_itineraryrows to 1 step -1
	if dw_itinerary.getitemnumber(ll_row, "port_sequence") = 0 then dw_itinerary.rowsdiscard(ll_row, ll_row, primary!)
next

ll_row = dw_itinerary.rowcount()
if ll_row > 0 then
	ls_portcode = dw_itinerary.getitemstring( ll_row, "port_code")
	li_porttype = 0
	ll_findport = w_share.dw_calc_port_dddw.find("port_code = '" + ls_portcode + "'", 1, 999999)
	if ll_findport > 0 then li_porttype = w_share.dw_calc_port_dddw.getitemnumber(ll_findport, "via_point")
	dw_itinerary.setitem(ll_row, "distance", ld_null)
	dw_itinerary.setitem(ll_row, "eca_distance", ld_null)
	dw_itinerary.setitem(ll_row, "port_type", li_porttype)
	dw_itinerary.setitem(ll_row, "eca_point", 0 )
end if
end subroutine

public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_title, string as_text);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-3-97

 Description : Displays calculation warning or adds warning to 
 					astr_parm.result.s_warningtext if astr_parm.b_silent_calculation 
					is true. If astr_parm.b_silent_calculation is false a MessageBox is
					shown instead.

 Arguments : astr_parm as s_calculation_parm, as_text as string

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Add carriage return/Line feed to text, if there's already some text in the
// astr_parm.result.s_warningtext
If Len(astr_parm.result.s_warningtext) >0 Then astr_parm.result.s_warningtext += "~r~n"
astr_parm.result.s_warningtext += as_text

If not astr_parm.b_silent_calculation Then
	MessageBox(as_title, as_text, Exclamation!)
End if

end subroutine

private function integer _calcdayscons (long al_row, ref s_calculation_parm astr_parm, ref string as_errmsg);/********************************************************************
   _calcdayscons
   <DESC>	Calculate time and fuel consumption units	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		al_row
		astr_parm
		as_errmsg
   </ARGS>
   <USAGE>	call by uf_process()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/01/16 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

decimal ld_calc_fo, ld_calc_do, ld_calc_mgo, ld_calc_lsfo
decimal ld_distance, ld_speed, ld_intake, ld_time
long    ll_cons_id, ll_find

//Calculate time
ld_distance = dw_itinerary.getitemnumber(al_row, "distance")
ld_speed = dw_itinerary.getitemnumber(al_row, "speed")
ld_intake = dw_itinerary.getitemnumber(al_row, "intake")

ld_time = (ld_distance / ld_speed * 60)
if ld_intake = 0 then
	id_miles_ballasted += ld_distance
	id_minutes_ballasted += ld_time
else
	id_miles_loaded += ld_distance
	id_minutes_loaded += ld_time
end if

dw_itinerary.setitem(al_row, "sec_seconds", ld_time)

ll_cons_id = dw_itinerary.getitemnumber(al_row, "cal_cons_id")
ll_find = iuo_calc_nvo.ids_cal_cons.find("cal_cons_id = " + string(ll_cons_id), 1, iuo_calc_nvo.ids_cal_cons.rowcount())
if ll_find > 0 then
	ld_calc_fo = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_find, iuo_calc_nvo.is_COL_CAL_CONS_HFO)
	ld_calc_do = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_find, iuo_calc_nvo.is_COL_CAL_CONS_DO)
	ld_calc_mgo = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_find, iuo_calc_nvo.is_COL_CAL_CONS_GO)
	ld_calc_lsfo = iuo_calc_nvo.ids_cal_cons.getitemnumber(ll_find, iuo_calc_nvo.is_COL_CAL_CONS_LSFO)
else
	as_errmsg = "Internal error~r~n~r~nError when getting consumption"
	return c#return.Failure
end if

//Calculate fuel consumption units
ld_calc_fo = (ld_calc_fo * ld_time) / 1440
ld_calc_do = (ld_calc_do * ld_time) / 1440
ld_calc_mgo = (ld_calc_mgo * ld_time) / 1440
ld_calc_lsfo = (ld_calc_lsfo * ld_time) / 1440

dw_itinerary.setitem(al_row, "calc_hsfo", ld_calc_fo)
dw_itinerary.setitem(al_row, "calc_lsgo", ld_calc_do)
dw_itinerary.setitem(al_row, "calc_hsgo", ld_calc_mgo)
dw_itinerary.setitem(al_row, "calc_lsfo", ld_calc_lsfo)

id_fo_units += ld_calc_fo
id_do_units += ld_calc_do
id_mgo_units += ld_calc_mgo
id_lsfo_units += ld_calc_lsfo

if ld_intake = 0 then
	astr_parm.d_fo_ballasted_atsea += ld_calc_fo
	astr_parm.d_do_ballasted_atsea += ld_calc_do
	astr_parm.d_mgo_ballasted_atsea += ld_calc_mgo
	astr_parm.d_lsfo_ballasted_atsea += ld_calc_lsfo
else
	astr_parm.d_fo_laden_atsea += ld_calc_fo
	astr_parm.d_do_laden_atsea += ld_calc_do
	astr_parm.d_mgo_laden_atsea += ld_calc_mgo
	astr_parm.d_lsfo_laden_atsea += ld_calc_lsfo
end if

return c#return.Success
end function

public subroutine of_clearnonportspeed ();/********************************************************************
   of_claernonportspeed
   <DESC>	Clear speed, days and fuel consumption when calculating
				old working/template calculation
	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by u_atobviac_calculation.of_set_seca()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/02/16 CR3248        LHG008   First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
decimal ld_null

setnull(ld_null)

if iuo_calc_nvo.iuo_calculation.of_isecaenabled() then return

ll_rowcount = dw_itinerary.rowcount()
for ll_row =  1 to ll_rowcount - 1
	if dw_itinerary.getitemnumber(ll_row, "itinerary_no") > 0 then continue
	dw_itinerary.setitem(ll_row, "cal_cons_id", ld_null)
	dw_itinerary.setitem(ll_row, "speed", ld_null)
	dw_itinerary.setitem(ll_row, "sec_seconds", ld_null)
	dw_itinerary.setitem(ll_row, "eca_seconds", ld_null)	
	dw_itinerary.setitem(ll_row, "calc_hsfo", ld_null)	
	dw_itinerary.setitem(ll_row, "calc_lsgo", ld_null)	
	dw_itinerary.setitem(ll_row, "calc_hsgo", ld_null)	
	dw_itinerary.setitem(ll_row, "calc_lsfo", ld_null)	
next

end subroutine

public function integer of_applyspeed (decimal ad_speed, integer ai_applyto);/********************************************************************
   of_applyspeed
   <DESC>	Apply the speed to itinerary	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ad_speed
		ai_applyto
   </ARGS>
   <USAGE>	Call by dw_applyspeed.clicked()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		10/03/16 CR4292        LHG008   First Version
   </HISTORY>
********************************************************************/

long    ll_conscount, ll_loop, ll_cons_id, ll_portcount
integer li_speedtype
decimal ld_speed, ld_intake, ld_null
boolean lb_isineca, lb_zoneignored, lb_showzonemessage = true

mt_n_datastore		lds_cal_cons

setnull(ld_null)

//Need specify the "Applyto" 
if ai_applyto = ii_APPLYTOALL or ai_applyto = ii_APPLYTOBALLAST or ai_applyto = ii_APPLYTOLADEN then
	//continue
else
	return c#return.Failure
end if

of_defzoneindicating(false, 0)

lds_cal_cons = create mt_n_datastore
lds_cal_cons.dataobject = iuo_calc_nvo.ids_cal_cons.dataobject //d_sq_gr_cal_cons

ll_conscount = iuo_calc_nvo.ids_cal_cons.rowcount()
iuo_calc_nvo.ids_cal_cons.rowscopy(1, ll_conscount, Primary!, lds_cal_cons, 1, Primary!)

lds_cal_cons.setsort(is_CONSDDDWSORTEXPR)
lds_cal_cons.sort()

ll_portcount = dw_itinerary.rowcount()
for ll_loop = 1 to ll_portcount - 1
	//Reset speed
	ld_speed = ad_speed
	
	//If current intake is zero, then we use the ballasted speeds.
	ld_intake = dw_itinerary.getitemnumber(ll_loop, "intake")
	if ld_intake = 0 then
		li_speedtype = c#consumptiontype.il_SAILING_BALLAST
	else
		li_speedtype = c#consumptiontype.il_SAILING_LADEN
	end if
	
	if (ld_intake > 0 and ai_applyto = ii_APPLYTOBALLAST) or (ld_intake = 0 and ai_applyto = ii_APPLYTOLADEN) then continue
	
	lb_isineca = (dw_itinerary.getitemnumber(ll_loop, "eca_point") > 0)
	ll_cons_id = of_getappropriatespeed(lds_cal_cons, li_speedtype, lb_isineca, ld_speed, lb_zoneignored)
	
	if ll_cons_id <= 0 then
		setnull(ll_cons_id)
		setnull(ld_speed)
	end if
	
	//The consumption zones is not Default consumption.
	if lb_zoneignored then
		if lb_showzonemessage then
			messagebox("Consumption zones not available", is_DEFZONEIGNOREDMSG, Exclamation!)
			lb_showzonemessage = false
		end if
		
		of_defzoneindicating(true, ll_loop)
	end if
	
	dw_itinerary.setitem(ll_loop, "cal_cons_id", ll_cons_id)
	dw_itinerary.setitem(ll_loop, "speed", ld_speed)
	
	dw_itinerary.setitem(ll_loop, "sec_seconds", ld_null)
	dw_itinerary.setitem(ll_loop, "eca_seconds", ld_null)
	dw_itinerary.setitem(ll_loop, "calc_hsfo", ld_null)
	dw_itinerary.setitem(ll_loop, "calc_lsgo", ld_null)
	dw_itinerary.setitem(ll_loop, "calc_hsgo", ld_null)
	dw_itinerary.setitem(ll_loop, "calc_lsfo", ld_null)
next

destroy lds_cal_cons
return c#return.Success
end function

public subroutine of_defzoneindicating (boolean ab_isdefzone, integer ai_row);/********************************************************************
   of_defzoneindicating
   <DESC>	Use to 1: indicate whether the apply speed is default zone or not;
						 2. Clear the indicating.
						 
				if ab_isdefzone = false, then reset the indicating
	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_isdefzone
		ai_row
   </ARGS>
   <USAGE>	Call by uf_process(), of_refreshspeed(), of_applyspeed(), dw_itinerary.itemchanged()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/03/16 CR4292        LHG008   First Version
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_loop, ll_isdefzone

if ab_isdefzone then
	ll_isdefzone = 1
else
	ll_isdefzone = 0
end if

if ai_row > 0 then
	dw_itinerary.setitem(ai_row, "non_defzone", ll_isdefzone)
elseif ai_row = 0 then
	ll_rowcount = dw_itinerary.rowcount()
	for ll_loop = 1 to ll_rowcount
		dw_itinerary.setitem(ll_loop, "non_defzone", ll_isdefzone)
	next
end if
end subroutine

public function long of_getappropriatespeed (mt_n_datastore ads_cal_cons, integer ai_speedtype, boolean ab_isineca, ref decimal ad_speed, ref boolean ab_zoneignored);/********************************************************************
   of_getappropriatespeed
   <DESC>	Get appropriate speed.
	logic: 1. find the same speed of user default zone.
			 2. find the next higher speed of user default zone.
			 3. find the next lower speed of user default zone.
			 4. find next higher speed and disregarding consumption zones.
			 5. find next lower speed and disregarding consumption zones.
	</DESC>
   <RETURN>	long:
            <LI> >0, cal_cons_id
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_cal_cons
		ai_speedtype
		ab_isineca
		ad_speed
		ab_zoneignored
   </ARGS>
   <USAGE>	Ref: of_applyspeed()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		14/03/16 CR4292        LHG008   First Version
		21/03/17 CR4354        LHG008   Change the sorting of speed selection to make it more user friendly
   </HISTORY>
********************************************************************/

string ls_findexpr, ls_zoneexpr, ls_speedexpr, ls_originalsort
long   ll_conscount, ll_find, ll_cons_id

if isnull(ai_speedtype) or ai_speedtype = 0 then return c#return.Failure

ab_zoneignored = false

ll_conscount = ads_cal_cons.rowcount()

ls_originalsort = ads_cal_cons.describe("datawindow.table.sort")
if not len(ls_originalsort) > 1 then ls_originalsort = ''

ads_cal_cons.setsort("cons_type A, cal_cons_speed A, zone_order A, cal_cons_fo A, cal_cons_do A, cal_cons_mgo A, cal_cons_lsfo A")
ads_cal_cons.sort()

//Frist find speed for selected ECA/non-ECA default consumption zone, if not default then disregarding any consumption zones
ls_findexpr = "cal_cons_type = " + string(ai_speedtype) + " and cal_cons_active = 1"
if ab_isineca then
	if not isnull(uo_global.ii_eca_zone) then ls_zoneexpr = " and zone_id = " + string(uo_global.ii_eca_zone)
else
	if not isnull(uo_global.ii_non_eca_zone) then ls_zoneexpr = " and zone_id = " + string(uo_global.ii_non_eca_zone)
end if

//Find the speed or next higher speed for the consumption zones
ls_speedexpr = " and cal_cons_speed >= " + string(ad_speed)
ll_find = ads_cal_cons.find(ls_findexpr + ls_zoneexpr + ls_speedexpr, 1, ll_conscount)

//If not found then find next lower speed for the consumption zones
if ll_find <= 0 then
	ls_speedexpr = " and cal_cons_speed < " + string(ad_speed)
	ll_find = ads_cal_cons.find(ls_findexpr + ls_zoneexpr + ls_speedexpr, ll_conscount, 1)
	
	//Find the Frist record for the speed
	if ll_find > 0 then
		ad_speed = ads_cal_cons.getitemnumber(ll_find, "cal_cons_speed")
		ls_speedexpr = " and cal_cons_speed = " + string(ad_speed)
		ll_find = ads_cal_cons.find(ls_findexpr + ls_zoneexpr + ls_speedexpr, 1, ll_conscount)
	end if
end if

//If there is no speed for the consumption zones then find next higher speed and disregarding consumption zones
if ll_find <= 0 then
	ab_zoneignored = true
	ls_speedexpr = " and cal_cons_speed >= " + string(ad_speed)
	ll_find = ads_cal_cons.find(ls_findexpr + ls_speedexpr, 1, ll_conscount)
end if

//If not found then find next lower speed and disregarding consumption zones
if ll_find <= 0 then
	ab_zoneignored = true
	ls_speedexpr = " and cal_cons_speed < " + string(ad_speed)
	ll_find = ads_cal_cons.find(ls_findexpr + ls_speedexpr, ll_conscount, 1)
	
	//Find the Frist record for the speed
	if ll_find > 0 then
		ad_speed = ads_cal_cons.getitemnumber(ll_find, "cal_cons_speed")
		ls_speedexpr = " and cal_cons_speed = " + string(ad_speed)
		ll_find = ads_cal_cons.find(ls_findexpr + ls_speedexpr, 1, ll_conscount)
	end if
end if

//If not found then return failer
if isnull(ll_find) or ll_find <= 0 then
	ab_zoneignored = false
	ads_cal_cons.setsort(ls_originalsort)
	ads_cal_cons.sort()
	return c#return.Failure
end if

ad_speed = ads_cal_cons.getitemnumber(ll_find, "cal_cons_speed")
ll_cons_id = ads_cal_cons.getitemnumber(ll_find, "cal_cons_id")

ads_cal_cons.setsort(ls_originalsort)
ads_cal_cons.sort()

return ll_cons_id
end function

public subroutine of_setdwapplyspeedvisibility ();/********************************************************************
   of_setdwapplyspeedvisibility
   <DESC>	Set dw_applyspeed visible or invisible </DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by uf_retrieve(), tab_ininerary.selectionchanged()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		14/03/16 CR4292        LHG008   First Version
   </HISTORY>
********************************************************************/

integer li_status

dw_applyspeed.visible = false

if tab_itinerary.control[tab_itinerary.selectedtab] = tab_itinerary.tp_itinerary and dw_itinerary.rowcount() > 0 then
	li_status = iuo_calc_nvo.iuo_calculation.uf_get_status(0)
	
	if li_status <> c#calculationstatus.il_FIXTURE then
		dw_applyspeed.visible = true
	end if
end if
end subroutine

public subroutine of_createmap (string as_abcportsequence[]);tab_itinerary.tp_map.uo_map.of_setportsequence( as_abcportsequence )
tab_itinerary.tp_map.uo_map.of_createmap()
end subroutine

public function integer of_mergeitinerary (long al_calc_id);/********************************************************************
   of_mergeitinerary
   <DESC>	Call procedure to merge itinerary, the data can be use to match with POC.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_calc_id
   </ARGS>
   <USAGE>	call by uf_saveroute	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		13/10/16 CR4531        LHG008   First Version
   </HISTORY>
********************************************************************/

string ls_deverrmsg
boolean lb_autocommit

lb_autocommit = sqlca.autocommit
sqlca.autocommit = true

DECLARE SP_MERGE_ITINERARY PROCEDURE FOR
	SP_MERGE_ITINERARY	@cal_calc_id = :al_calc_id;
	
EXECUTE SP_MERGE_ITINERARY;

if sqlca.sqlcode = -1 then
	ls_deverrmsg = sqlca.sqlerrtext
	ROLLBACK;
	CLOSE SP_MERGE_ITINERARY;
	_addmessage(this.classdefinition, "of_mergeitinerary()", "Failed to execute procedure SP_MERGE_ITINERARY.", ls_deverrmsg)
	return c#return.Failure
end if

CLOSE SP_MERGE_ITINERARY;

sqlca.autocommit = lb_autocommit

return c#return.Success
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

public subroutine of_show_voyage_alert (string as_port_code, integer xpos, integer ypos);/********************************************************************
   of_show_voyage_alert
   <DESC>	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
		as_port_code
		xpos
		ypos
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowheight, ll_dwheight, ll_maxheight
long ll_xpos, ll_ypos, ll_tabheight, ll_tabwidth, ll_boxw, ll_boxh
u_popupdw dw_voyage_alert

dw_voyage_alert = tab_itinerary.tp_itinerary.dw_voyage_alert
dw_voyage_alert.reset()
if dw_voyage_alert.retrieve(as_port_code) < 1 then
	dw_voyage_alert.visible = false
	return
end if

ll_dwheight = 84
ll_tabheight = tab_itinerary.tp_itinerary.height
ll_tabwidth = tab_itinerary.tp_itinerary.width

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
ll_xpos = PixelsToUnits(xpos, XPixelsToUnits!)
ll_ypos = PixelsToUnits(ypos, YPixelsToUnits!)

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

public function boolean of_firstlast_interim (ref s_calculation_parm astr_parm);/********************************************************************
   of_firstlast_interim
   <DESC></DESC>
   <RETURN> boolean
   <ACCESS> </ACCESS>
   <ARGS>
		astr_parm
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/09/17 CR4221          HHX010        First Version
   </HISTORY>
********************************************************************/
long ll_portcount, ll_loop, li_interim_port
string ls_purpose, ls_errtext
 
ls_errtext = "You cannot use an interim port as first or last port in the Itinerary."
ll_portcount = dw_itinerary.rowcount()
for  ll_loop = 1 to ll_portcount
	ls_purpose = dw_itinerary.object.purpose_code[ll_loop]
	li_interim_port = dw_itinerary.object.cal_caio_interim_port[ll_loop]
	if ls_purpose = 'L' then
		if li_interim_port = 1 then 
			astr_parm.result.s_errortext = ls_errtext
			return false
		else
			exit
		end if
	end if
next 

for  ll_loop = ll_portcount to 1 step -1
	ls_purpose = dw_itinerary.object.purpose_code[ll_loop]
	li_interim_port = dw_itinerary.object.cal_caio_interim_port[ll_loop]
	if ls_purpose = 'D' then
		if li_interim_port = 1 then 
			astr_parm.result.s_errortext = ls_errtext
			return false
		else
			exit
		end if
	end if
next 

return true
end function

event constructor;call super::constructor;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    : MIS
 Date       : 1996
 Description : Sets up the drag-object for the itinerary
 Arguments : None
 Returns   : None  
*************************************************************************************
Development Log 
DATE     VERSION     NAME     DESCRIPTION
-------- -------     ------   ------------------------------------
30/12/15	CR3248      LHG008   ECA zone implementation
14/03/16	CR4292      LHG008   Add function to change bunch speed
************************************************************************************/

tab_itinerary.tp_routecontrol.uo_enginecontrol.of_registeritinerary( this )

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")

lnv_style.of_dwlistformater(tab_itinerary.tp_itinerary.dw_itinerary_route,false)
tab_itinerary.tp_itinerary.dw_itinerary_route.Object.DataWindow.Color=RGB(236,236,236)
tab_itinerary.tp_itinerary.dw_itinerary_route.Object.DataWindow.Detail.Color=RGB(236,236,236) 

dw_itinerary = tab_itinerary.tp_itinerary.dw_itinerary
dw_itinerary.uf_set_dragobject("itinerary_no")
lnv_style.of_registercolumn("speed", true, false)
lnv_style.of_registercolumn("cal_cons_id", true, false)
lnv_style.of_dwlistformater(dw_itinerary, false)
dw_itinerary.object.datawindow.color = c#color.MT_FORM_BG
dw_itinerary.object.datawindow.detail.color =c#color.MT_FORMDETAIL_BG

lnv_style.of_dwformformater(dw_applyspeed)
dw_applyspeed.insertrow(0)
end event

on u_atobviac_calc_itinerary.create
int iCurrent
call super::create
this.dw_applyspeed=create dw_applyspeed
this.tab_itinerary=create tab_itinerary
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_applyspeed
this.Control[iCurrent+2]=this.tab_itinerary
end on

on u_atobviac_calc_itinerary.destroy
call super::destroy
destroy(this.dw_applyspeed)
destroy(this.tab_itinerary)
end on

type dw_applyspeed from u_datawindow_sqlca within u_atobviac_calc_itinerary
integer x = 2793
integer width = 1202
integer height = 104
integer taborder = 10
string dataobject = "d_ex_ff_applyspeed"
boolean border = false
boolean ib_autoaccept = true
end type

event clicked;decimal ld_speed
integer li_applytoballast, li_applytoladen, li_applyto

if isvalid(dwo) then
	if dwo.name = "speed" then
		this.selecttext(1, len(this.gettext()))
	end if
	
	if dwo.name = "b_apply" then
		this.accepttext()
		
		ld_speed = this.getitemnumber(row, "speed")
		li_applytoballast = this.getitemnumber(row, "applytoballast")
		li_applytoladen = this.getitemnumber(row, "applytoladen")
		
		if li_applytoballast = 1 and li_applytoladen = 1 then
			li_applyto = ii_APPLYTOALL
		elseif li_applytoballast = 1 then
			li_applyto = ii_APPLYTOBALLAST
		elseif li_applytoladen = 1 then
			li_applyto = ii_APPLYTOLADEN
		end if
		
		of_applyspeed(ld_speed, li_applyto)
	end if
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if this.getcolumnname() = 'speed' then
	this.selecttext(1, len(this.gettext()))
end if
end event

event itemchanged;call super::itemchanged;integer li_applytoballast, li_applytoladen

if isvalid(dwo) then
	if dwo.name = "applytoballast" or dwo.name = "applytoladen" then
		if dwo.name = "applytoballast" then
			li_applytoballast = integer(data)
			li_applytoladen = this.getitemnumber(row, "applytoladen")
		else
			li_applytoballast = this.getitemnumber(row, "applytoballast")
			li_applytoladen = integer(data)
		end if
		
		if li_applytoballast + li_applytoladen > 0 then
			this.object.b_apply.enabled = true
		else
			this.object.b_apply.enabled = false
		end if
	end if
end if
end event

type tab_itinerary from tab within u_atobviac_calc_itinerary
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 4576
integer height = 2252
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_itinerary tp_itinerary
tp_routecontrol tp_routecontrol
tp_map tp_map
end type

on tab_itinerary.create
this.tp_itinerary=create tp_itinerary
this.tp_routecontrol=create tp_routecontrol
this.tp_map=create tp_map
this.Control[]={this.tp_itinerary,&
this.tp_routecontrol,&
this.tp_map}
end on

on tab_itinerary.destroy
destroy(this.tp_itinerary)
destroy(this.tp_routecontrol)
destroy(this.tp_map)
end on

event selectionchanged;/********************************************************************
   selectionchanged
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
		oldindex
		newindex
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/01/16		CR3248		CCY018       By default, no row should be preselected/highlighted in the route.
   </HISTORY>
********************************************************************/

if newindex = 2 then
	tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_route.selectrow(0, false)
end if

of_setdwapplyspeedvisibility()
end event

type tp_itinerary from userobject within tab_itinerary
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4539
integer height = 2132
long backcolor = 32304364
string text = "Itinerary"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
dw_voyage_alert dw_voyage_alert
dw_itinerary_route dw_itinerary_route
dw_itinerary dw_itinerary
end type

on tp_itinerary.create
this.dw_voyage_alert=create dw_voyage_alert
this.dw_itinerary_route=create dw_itinerary_route
this.dw_itinerary=create dw_itinerary
this.Control[]={this.dw_voyage_alert,&
this.dw_itinerary_route,&
this.dw_itinerary}
end on

on tp_itinerary.destroy
destroy(this.dw_voyage_alert)
destroy(this.dw_itinerary_route)
destroy(this.dw_itinerary)
end on

type dw_voyage_alert from u_popupdw within tp_itinerary
integer x = 1111
integer y = 292
integer width = 2322
integer taborder = 60
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

type dw_itinerary_route from u_datawindow_sqlca within tp_itinerary
event ue_hscroll pbm_hscroll
boolean visible = false
integer x = 2505
integer y = 840
integer width = 1902
integer height = 1280
integer taborder = 40
boolean titlebar = true
string dataobject = "d_sq_tb_route"
boolean vscrollbar = true
boolean border = false
boolean ib_autoaccept = true
end type

event ue_hscroll;return 1

end event

event constructor;call super::constructor;setTransobject( sqlca )
end event

event itemchanged;call super::itemchanged;// Clear the data cache, so that data will be refreshed upon next calculation
of_childmodified()


end event

type dw_itinerary from u_datawindow_dragdrop within tp_itinerary
event ue_filterconsdddw ( long al_row,  boolean ab_reset )
event ue_clicked ( integer xpos,  integer ypos,  long row,  dwobject dwo )
integer x = 18
integer y = 24
integer width = 4480
integer height = 2052
integer taborder = 50
string dragicon = "images\DRAG.ICO"
string dataobject = "d_sq_gr_itinerary"
boolean minbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_auto = true
boolean ib_autoaccept = true
end type

event ue_filterconsdddw(long al_row, boolean ab_reset);/********************************************************************
   ue_filterconsdddw
   <DESC>	filter consumptions(speed) dorpdown	</DESC>
   <RETURN>	
		long:
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row:
		ab_reset:
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date     	CR-Ref		Author	Comments
		04-10-2013	CR2658		LHG008	First Version
		26/01/2014	CR2658UAT	LHG008	Filter 'Speed' column base on cargo quantity
		28/08/2013  CR3622      LHG008   Use Instance Variables for speed type list
   </HISTORY>
********************************************************************/

string  ls_typelist
decimal ld_intake
datawindowchild ldwc_child

if al_row <= 0 or isnull(al_row) then return

/*If the vessel is having Cargo during the Sailing, only Laden or Heating or Idle values are selectable. 
Otherwise, only Ballast or Idle values are selectable. */
ld_intake = this.getitemnumber(al_row, "intake")
if ld_intake > 0 then
	ls_typelist = is_LADEN_SPEEDLIST //Sailing - Laden/Sailing - Idle/Sailing - Heating
else
	ls_typelist = is_BALLAST_SPEEDLIST //Sailing - Ballast/Sailing - Idle
end if

//Get consumption data into drop-down
iuo_calc_nvo.of_getconsdropdown(this, "cal_cons_id", ls_typelist, ab_reset, true, al_row)

if this.getchild("cal_cons_id", ldwc_child) = 1 then
	ldwc_child.setsort(is_CONSDDDWSORTEXPR)
	ldwc_child.sort()
end if
end event

event ue_clicked(integer xpos, integer ypos, long row, dwobject dwo);/********************************************************************
   ue_clicked
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		xpos
		ypos
		row
		dwo
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date        CR-Ref       Author       Comments
   	06/01/16    CR3248       CCY018       Sets the current row to the clicked row.
   </HISTORY>
********************************************************************/

if ib_auto then
	if (row > 0) and (row <>  getrow()) then
		this.setredraw(false)
		this.setrow(row)
		this.scrolltorow(row)
		if this.getcolumnname() = "speed" then this.setcolumn("cal_cons_id")
		this.setredraw(true)
	end if
end if

end event

event constructor;call super::constructor;/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF

dw_itinerary.modify("cal_cons_id.protect = '0~tIf (locked=1,1,0)' cal_cons_id.background.color = '31775128~tif(locked=1, " + string(c#color.MT_FORMDETAIL_BG) + ',' + string(c#color.MT_MAERSK) + ")'")
dw_itinerary.modify("speed.protect = '0~tIf (locked=1,1,0)' speed.background.color = '31775128~tif(locked=1, " + string(c#color.MT_FORMDETAIL_BG) + ',' + string(c#color.MT_MAERSK) + ")'")
dw_itinerary.modify("speed.width = '0~tlong(describe(~"cal_cons_id.width~"))' speed.x = '0~tlong(describe(~"cal_cons_id.x~"))'")

of_setspeedvisible()
end event

event rowfocuschanged;event ue_filterconsdddw(currentrow, false)

end event

event mousedown;
il_dragrow = uf_get_dragrow()

If il_dragrow < 1 Then return

// check that we're not moving a locked port
if (this.getitemnumber(il_dragrow, "proceeding_locked") = 1) then
	this.drag(cancel!)
	return
end if
 
this.drag(begin!)

end event

event ue_rowdragged;call super::ue_rowdragged;
Long ll_dragfrom, ll_dragto, ll_count,  ll_rows, ll_find, ll_vscrollposition
integer li_itinerary_no, li_itinerary_seq, li_to_seq
string ls_purposecode

ll_dragfrom = Message.WordParm
ll_dragto = Message.Longparm

if ll_dragfrom < 1 or ll_dragto < 1 then return

// Check that we're not moving a locked port
if (dw_itinerary.getitemnumber(ll_dragfrom, "proceeding_locked") = 1) or dw_itinerary.getitemstring(ll_dragto, "purpose_code") = "B" then
	return
end if

ll_rows = dw_itinerary.rowcount()

if of_checkportorder(this, ll_dragfrom, ll_dragto) = c#return.Failure then return

tab_itinerary.tp_itinerary.setredraw(false) //if set dw_itinerary redraw(false), cannot get compute column data  after drag(e.g. "intake" )

li_to_seq = this.getitemnumber(ll_dragto, "port_sequence")

// Ok, drag operation is legal, now fixup the itinerary count 
if ll_dragfrom > ll_dragto then
	for ll_count = ll_dragto to ll_rows
		dw_itinerary.setitem(ll_count, "port_sequence", ll_count + 1 )
	next
else
	for ll_count = 1 to ll_dragto
		dw_itinerary.setitem(ll_count, "port_sequence", ll_count -1 )
	next
end if

//reset the days, distance, bunker
uf_row_set_null(ll_dragfrom)
uf_row_set_null(ll_dragfrom - 1)
if ll_dragfrom > ll_dragto then
	uf_row_set_null(ll_dragto - 1)
else
	uf_row_set_null(ll_dragto)
end if

// Update the itinerary for the dragged row
dw_itinerary.setitem(ll_dragfrom, "port_sequence", li_to_seq)

// Sort the itinerary
ll_vscrollposition = long(dw_itinerary.object.datawindow.verticalscrollposition)
dw_itinerary.sort()
dw_itinerary.groupcalc()
dw_itinerary.object.datawindow.verticalscrollposition = ll_vscrollposition

// And update the Itinerary count
li_itinerary_seq = 1
for ll_count = 1 to ll_rows
	dw_itinerary.setitem(ll_count, "port_sequence", ll_count  )
	li_itinerary_no = dw_itinerary.getitemnumber( ll_count, "itinerary_no")
	if isnull(li_itinerary_no) then li_itinerary_no = 0
	if li_itinerary_no > 0 then 
		dw_itinerary.setitem(ll_count, "itinerary_no", li_itinerary_seq  )
		li_itinerary_seq ++
	end if
next

// Tell the rest of the calculation system that something has been modified,
// and clear the datacache, so that data will be reloaded upon next calculation
of_childmodified()

dw_itinerary.setrow(ll_dragto)
tab_itinerary.tp_itinerary.setredraw(true)

of_refreshspeed()
end event

event dragwithin;call super::dragwithin;
long		ll_count, ll_row, ll_min, ll_max, ll_rowpos, ll_tabpos, ll_firstrowonpage, ll_currow
string ls_modify, ls_band, ls_purposecode
integer li_detailheight, li_headerheight, li_itinerary_no

li_detailheight = long(this.describe("datawindow.detail.height"))
li_headerheight = long(this.describe("datawindow.header.height"))

ll_count = this.rowcount()

ll_min = 1
ll_max = ll_count
ll_row = row	
ll_currow = row

il_draggedto = 0

if ll_row  < il_dragrow  then
	ll_row --
end if	

if row <= 0 then
	ls_band = this.getbandatpointer()
	if left(ls_band, 6) = "footer" or left(ls_band, 6) = "detail" or left(ls_band, 10) = "foreground" then
		ll_row = long(this.describe("DataWindow.LastRowOnPage"))
		ll_currow = ll_row
	end if
	
	ll_firstrowonpage = long(this.describe("DataWindow.FirstRowOnPage"))
	if left(ls_band, 6) = "header" then
		ll_row = ll_firstrowonpage - 1
		ll_currow = ll_firstrowonpage
	end if
	
	if left(ls_band, 10) = "foreground" then
		ll_tabpos = pos(ls_band, "~t")
		if integer(right(ls_band, len(ls_band) - ll_tabpos)) = ll_firstrowonpage then
			ll_row = ll_firstrowonpage - 1
			ll_currow = ll_firstrowonpage
		end if
	end if
end if

ll_rowpos = ll_row * li_detailheight - long(this.describe("datawindow.verticalscrollposition"))

if ll_rowpos >= 0 then
	if (ll_min <= ll_row and ll_row <= ll_max and ll_row > 0 or ll_min - ll_row = 1) then 
		il_draggedto = ll_row
		if il_dragrow > il_draggedto then il_draggedto += 1
		
		if ll_currow > 0 then ls_purposecode = this.getitemstring(ll_currow, "purpose_code")
		
		if ls_purposecode = "B" then
			ls_modify += "r_position.brush.color = 10789024 "
			il_draggedto = 0
		else
			ls_modify += "r_position.brush.color = 134217856 "
		end if
	else
		ls_modify += "r_position.brush.color = 10789024 "
	end if
	if il_dragrow = row then
		ls_modify += "r_position.visible = 0 r_position.y = " + string(li_headerheight + ll_rowpos)
	else
		ls_modify += "r_position.visible = 1 r_position.y = " + string(li_headerheight + ll_rowpos)
	end if
	this.modify(ls_modify)
end if

end event

event mouseup;// Stop draggin. If valid dragfrom and valid dragto row, then trigger a ue_rowdragged event

This.Drag(cancel!)

Long ll_newrow

If il_dragrow > 0 Then
	ll_newrow = il_draggedto

	If (ll_newrow >=0) And (ll_newrow <> il_dragrow) Then &
		TriggerEvent("ue_rowdragged", il_dragrow, ll_newrow)
	
	this.modify("r_position.visible = 0")
	il_dragrow = 0
	il_draggedto = 0
End if
end event

event clicked;datawindowchild ldwc_child

event ue_clicked(xpos, ypos, row, dwo)

choose case dwo.name 
	case "cal_cons_id"
		if this.getchild("cal_cons_id", ldwc_child) = 1 then
			if ldwc_child.rowcount() = 0 then
				messagebox("Speed selection", "Tramos cannot find the consumption type you want. Please update the Speed & Consumption master data in the Vessels system table.")
				
			end if
		end if
	case else
		
end choose
end event

event itemchanged;call super::itemchanged;string ls_columnname
long ll_return
decimal ld_null

setnull(ld_null)

ls_columnname = this.getcolumnname()
choose case ls_columnname
	case "cal_cons_id"
		ll_return = iuo_calc_nvo.of_return_consactive(dwo.name, 'speed', this, data)
		if ll_return = C#Return.Failure then
			this.Post setcolumn("cal_cons_id")
			return 2
		end if
		iuo_calc_nvo.of_setconsdata(this, ls_columnname, iuo_calc_nvo.is_COL_CAL_CONS_SPEED, "speed")
		
		dw_itinerary.setitem(row, "sec_seconds", ld_null)
		dw_itinerary.setitem(row, "eca_seconds", ld_null)
		dw_itinerary.setitem(row, "calc_hsfo", ld_null)
		dw_itinerary.setitem(row, "calc_lsgo", ld_null)
		dw_itinerary.setitem(row, "calc_hsgo", ld_null)
		dw_itinerary.setitem(row, "calc_lsfo", ld_null)
		
		of_defzoneindicating(false, row)
	case else
		
end choose

of_childmodified()
end event

event ue_dwkeypress;call super::ue_dwkeypress;/********************************************************************
   ue_dwkeypress
   <DESC>	</DESC>
   <RETURN>	long</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		key:
		keyflags: 
   </ARGS>
   <USAGE>	
		Tab:  scroll to next row
		Shift + Tab : scroll to prior row
   </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19/02/16		CR3248		CCY018		Fix the tab order bug.
   </HISTORY>
********************************************************************/

long ll_currow, ll_prerow, ll_nextrow
long ll_curtype, ll_nexttype
long ll_curitinno, ll_preitinno
string ls_colname

if key <> KeyTab! then return

ll_currow = this.getrow()
ll_prerow = ll_currow - 1
ll_nextrow = ll_currow + 1

if ll_currow < 1 then return

ll_curtype = this.getitemnumber(ll_currow, "port_type")
ll_curitinno = this.getitemnumber(ll_currow, "itinerary_no")
if ll_prerow > 0 then ll_preitinno = this.getitemnumber(ll_prerow, "itinerary_no")
if ll_nextrow <= this.rowcount() then ll_nexttype = this.getitemnumber(ll_nextrow, "port_type")
ls_colname = this.getcolumnname()

if isnull(ll_curitinno) then ll_curitinno = 0
if isnull(ll_preitinno) then ll_preitinno = 0

this.setredraw( false)

if keyflags = 1 then
	if ll_currow > 1 then
		if of_showcombinedata() then
			if ls_colname = "rp_expenses" or (ll_curtype <> 1 and ll_curtype <> 2 and ls_colname = "cal_cons_id") then
				this.post setrow(ll_prerow)
				this.post scrolltorow(ll_prerow)
				if ll_preitinno > 0 then
					this.post setcolumn("cal_cons_id")
				else
					this.post setcolumn("rp_expenses")
				end if
			end if
		else
			if ls_colname = "rp_expenses" or (ll_curtype  <> 1 and ll_curtype  <> 2 and ls_colname = "cal_cons_id")  then
				this.post setrow(ll_prerow)
				this.post scrolltorow(ll_prerow)
				this.post setcolumn("cal_cons_id")
			end if
		end if
	end if
else
	if ll_currow < this.rowcount( ) then
		if of_showcombinedata() then
			if ls_colname = "cal_cons_id" or (ls_colname = "rp_expenses" and  ll_curitinno = 0) then
				this.post setrow(ll_nextrow)
				this.post scrolltorow(ll_nextrow)
				
				if (ll_nexttype = 1 or ll_nexttype = 2) then
					this.post setcolumn("rp_expenses")
				else
					this.post setcolumn("cal_cons_id")
				end if
			end if
		else
			if ls_colname = "cal_cons_id"  then
				this.post setrow(ll_nextrow)
				this.post scrolltorow(ll_nextrow)
				if (ll_nexttype = 1 or ll_nexttype = 2) then
					this.post setcolumn("rp_expenses")
				else
					this.post setcolumn("cal_cons_id")
				end if
			end if
		end if
	end if
end if

this.post setredraw(true)
end event

event rbuttondown;call super::rbuttondown;string ls_port_code

if isnull(row) or row < 1 then return

if dwo.name = "p_voyagealert" then
	ls_port_code = this.getitemstring(row, "port_code")
	if isnull(ls_port_code) then ls_port_code = ""
	if trim(ls_port_code, true) = "" then return
	
	of_show_voyage_alert(ls_port_code, xpos, ypos)
end if
end event

type tp_routecontrol from userobject within tab_itinerary
integer x = 18
integer y = 104
integer width = 4539
integer height = 2132
long backcolor = 32304364
string text = "Route Control"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
uo_enginecontrol uo_enginecontrol
end type

on tp_routecontrol.create
this.uo_enginecontrol=create uo_enginecontrol
this.Control[]={this.uo_enginecontrol}
end on

on tp_routecontrol.destroy
destroy(this.uo_enginecontrol)
end on

type uo_enginecontrol from c_engine_controlpanel within tp_routecontrol
integer width = 4549
integer height = 2192
integer taborder = 40
string text = ""
long tabtextcolor = 0
long tabbackcolor = 67108864
long picturemaskcolor = 0
end type

on uo_enginecontrol.destroy
call c_engine_controlpanel::destroy
end on

type tp_map from userobject within tab_itinerary
integer x = 18
integer y = 104
integer width = 4539
integer height = 2132
long backcolor = 32304364
string text = "Map"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
uo_map uo_map
end type

on tp_map.create
this.uo_map=create uo_map
this.Control[]={this.uo_map}
end on

on tp_map.destroy
destroy(this.uo_map)
end on

type uo_map from u_atobviac_map within tp_map
integer x = 37
integer y = 32
integer taborder = 60
end type

on uo_map.destroy
call u_atobviac_map::destroy
end on

