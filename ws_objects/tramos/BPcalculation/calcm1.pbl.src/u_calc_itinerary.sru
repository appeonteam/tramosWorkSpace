$PBExportHeader$u_calc_itinerary.sru
$PBExportComments$itinerary's subobject - used by u_calculation
forward
global type u_calc_itinerary from u_calc_base_sqlca
end type
type dw_calc_itinerary from u_datawindow_dragdrop within u_calc_itinerary
end type
type cbx_show_expenses from uo_cbx_base within u_calc_itinerary
end type
type s_charterer_name from structure within u_calc_itinerary
end type
type s_cargolist from structure within u_calc_itinerary
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

global type u_calc_itinerary from u_calc_base_sqlca
integer width = 4603
integer height = 2404
dw_calc_itinerary dw_calc_itinerary
cbx_show_expenses cbx_show_expenses
end type
global u_calc_itinerary u_calc_itinerary

type variables
public s_port_codes port_code
Private boolean ib_active, ib_unlocked


// Cached data
Private Boolean ib_process_data_cached, ib_display_data_cached
Double id_canal_expenses, id_miles_ballasted, id_miles_loaded
Double id_minutes_ballasted, id_minutes_loaded
Double id_fo_units, id_do_units, id_mgo_units
String is_warning
Boolean ib_reset_itinerary
Private Boolean ib_first_port_is_ballast

end variables

forward prototypes
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public function integer uf_get_speed (integer ai_type, ref s_speed astr_speed[], double ld_speed)
public subroutine uf_row_set_null (integer ai_row_no)
public subroutine uf_load_speedlist (ref s_speed astr_speedlist[])
public subroutine uf_retrieve ()
public function integer uf_deactivate ()
public function boolean uf_point_distance (ref string as_lastpoint, string as_nextpoint, ref integer ai_distance, ref string as_errortext)
public function boolean uf_retrieveballast (integer ai_rowno, ref datawindow adw_calc_ballast)
public function boolean uf_saveballast (integer ai_rowno, integer ai_ball_rowno, ref datawindow adw_calc_ballast)
public function boolean uf_is_canal (string as_portcode)
public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_text)
public subroutine uf_port_changed ()
public subroutine uf_clear_cache (boolean ab_clear_itinerary)
public subroutine uf_unlock ()
private subroutine uf_retrieveport (ref datawindow adw_port, string as_type, ref s_cargolist astr_cargolist[])
public subroutine uf_update_itinerary_order ()
private subroutine uf_save (boolean ab_force_save)
private subroutine uf_check_editlocked ()
public subroutine uf_delete ()
public subroutine uf_lock_via_expenses ()
public subroutine uf_activate ()
public function boolean uf_process (ref s_calculation_parm astr_parm, ref datawindow adw_load, ref datawindow adw_disch)
private subroutine documentation ()
end prototypes

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

dw_calc_itinerary.uf_redraw_off()
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

dw_calc_itinerary.uf_redraw_on()
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

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets a itinerary row (ai_row_no) to default values.

 Arguments : ai_row_no as integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_null
Double ld_null

SetNull(ls_null)
SetNull(ld_null)

If (ai_row_no > 0) And (ai_row_no <= dw_calc_itinerary.RowCount()) Then
	dw_calc_itinerary.SetItem(ai_row_no, "via_1", ls_null)
	dw_calc_itinerary.SetItem(ai_row_no, "via_2", ls_null)
	dw_calc_itinerary.SetItem(ai_row_no, "via_3", ls_null)	
	dw_calc_itinerary.SetItem(ai_row_no, "via_1_expenses", ld_null)
	dw_calc_itinerary.SetItem(ai_row_no, "via_2_expenses", ld_null)
	dw_calc_itinerary.SetItem(ai_row_no, "via_3_expenses", ld_null)
	dw_calc_itinerary.SetItem(ai_row_no, "distance", 0)	
	dw_calc_itinerary.SetItem(ai_row_no, "time", 0)	
End if

end subroutine

public subroutine uf_load_speedlist (ref s_speed astr_speedlist[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Loads the speedlist given as argument into the itinerary 
 					drop-down speedlist

 Arguments : astr_speedlist[] 

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DataWindowChild dwc_tmp
Long ll_max, ll_count, ll_row

// Get the child for the speedlist drop-down window
dw_calc_itinerary.GetChild("speed", dwc_tmp)

// Reset the current entries from the drop-down speedlist
dwc_tmp.Reset()

// And copy all type 2 entries from the astr_speedlist into the drop-down speedlist
ll_max = UpperBound(astr_speedlist[])
For ll_count = 1 To ll_max
	If astr_speedlist[ll_count].i_type = 2 Then
		ll_row = dwc_tmp.InsertRow(0)
		dwc_tmp.SetItem(ll_row, "speed", Round(astr_speedlist[ll_count].d_speed,4))
	End if			
Next

end subroutine

public subroutine uf_retrieve ();
/************************************************************************************

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
//
// This is how Itinerary works:
//
// The Itinerary windows is only a "copy" of the data from load and dischports. Upon 
// entering the Itinerary module, this code retrieves information from the load/disch
// datawindows. If the user edits anything, this information is stored back to the
// relevant datawindows upon exitting the itinerary window.
//
// To increase performance, data is cached in the Itinerary window. That is, whenever
// the user edits information (ports etc) in load/disch windows, they clear the 
// itinerary cache, thereby signalling that data needs to be retrieved upon entering
// the Itinerary again. If nothing is changed, the Itinerary window will not re-retrieve
// data.

Integer li_count, li_max, li_tmp, li_old_cargo, li_rowcount
s_cargolist lstr_cargolist[]
u_calc_cargos luo_calc_cargos
Long ll_max, ll_count
u_tramos_nvo uo_tramos_nvo
Boolean lb_ballast_locked

// Let luo_calc_cargos point to uo_calc_cargos object 
luo_calc_cargos = iuo_calc_nvo.iuo_calc_cargos

this.uf_redraw_off()
luo_calc_cargos.uf_redraw_off()

// Reset our datawindow
dw_calc_itinerary.Reset()

// Build list of cargo_id's and Shortnames. This is used later for adding
// in the charterer shortname on each row in the itinerary datawindow
li_rowCount = luo_calc_cargos.dw_cargo_summary.RowCount()
For li_count = 1 To li_rowCount
	lstr_cargolist[li_count].l_carg_id = luo_calc_cargos.dw_cargo_summary.GetitemNumber(li_count, "cal_carg_id")
	lstr_cargolist[li_count].s_name = luo_calc_cargos.dw_cargo_summary.GetItemString(li_count, "compute_0046")
Next	

// Retrieve all ports into our itinerary datawindow
li_old_cargo = luo_calc_cargos.uf_select_cargo(-1)
uf_retrieveport(luo_calc_cargos.dw_loadports, "L", lstr_cargolist)
uf_retrieveport(luo_calc_cargos.dw_dischports,"D", lstr_cargolist)

// Set sort order to Itinerary number and sort
dw_calc_itinerary.SetSort("itinerary A")
dw_calc_itinerary.Sort()

// Set the ballast locked status
if not ib_unlocked then
	If (iuo_calc_nvo.iuo_calculation.uf_get_status(0) = 5) Then
//		lb_ballast_locked = dw_calc_itinerary.GetItemNumber(1,"editlocked") <> 0 
	Else
		lb_ballast_locked = true
	End if
Else
	lb_ballast_locked = false
End if

ll_max = dw_calc_itinerary.RowCount()

// Retrieve first and last ballast ports. Update the instance flag 
// ib_first_port_is_ballast and the ll_max counter
If uf_retrieveballast(0, iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast) Then
	ib_first_port_is_ballast = true
	ll_max ++
	If lb_ballast_locked Then dw_calc_Itinerary.SetItem(1,"locked", 1)
Else
	ib_first_port_is_ballast = false
End if

If uf_retrieveballast(ll_max +1, iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast) Then
	ll_max ++
	If lb_ballast_locked Then dw_calc_itinerary.SetItem(ll_max, "locked", 1)
End if

// Update to correct itinerary number order
For ll_count = 1 To ll_max
	dw_calc_itinerary.SetItem(ll_count, "Itinerary", ll_count  )
Next

// Check to see if any of the calculation is fixture or estimated. In this
// case mark all rows as locked.
li_max = iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary.RowCount()
For li_count = 1 to li_max 
	li_tmp = iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary.GetItemNumber(li_count, "cal_carg_status")
	
	If li_tmp = 4 or li_tmp = 6 Then 
		// Ok, fixture or calculated found - now mark all itinerary 
		// entries as locked.
		
		li_max = dw_calc_itinerary.RowCount()

		For li_count = 1 To li_max 			
			dw_calc_itinerary.SetItem(li_count, "locked", 1)
		Next
	
		Exit // Stop if this is fixture or estimated 
	End if
Next

// Clear updateflags and do a new GroupCalc
dw_calc_itinerary.ResetUpdate()
dw_calc_itinerary.Resetupdate()
dw_calc_itinerary.GroupCalc()

// Update lock flags
uf_check_editlocked()

// Select the old cargo, turn redraw on again and exit
luo_calc_cargos.uf_select_cargo(li_old_cargo)

this.uf_redraw_on()
luo_calc_cargos.uf_redraw_on()

end subroutine

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : deactivates the itinerary windows, by saving modifications back
 					to the cargo window and resets the itinerary datawindow if 
					requested by the ib_reset_itinerary flag.

 Arguments : None

 Returns   : Integer. 1 = ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// If the itinerary window is active, then save information and set active to false
If ib_active then
	uf_save(false)
	ib_active = false
End if

// If the ib_reset_itinerary flag is set, then reset the itinerary, so that
// data will be retrieved next time the itinerary is activated.
If ib_reset_itinerary then
	dw_calc_itinerary.Reset()
	ib_reset_itinerary = false
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
	End if

	// Add next distance to ai_distance and set as_lastpoint equal to as_nextpoint
	ai_distance += li_dist
	as_lastpoint = as_nextpoint

	Return(true)
End if

// Lastpoint or nextpoint was null
Return(false)
	


end function

public function boolean uf_retrieveballast (integer ai_rowno, ref datawindow adw_calc_ballast);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date      : 1997

 Description : Retrieves ballast-ports from datawindow adw_calc_ballast
 					into the itinerary window. ai_rowno must be the row where
					we want the ballast port inserted. 

 Arguments : ai_rowno as integer, adw_calc_ballast as datawindow

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_tmp
String ls_port

If ai_rowno = 0 Then 
	li_tmp = 1
	ai_rowno = 1 
else 
	li_tmp = ai_rowno
	ai_rowno = 2
End if

// Get portname from the ballast datawindow. Exit if it's not valid
// (Is Null or Trim < 1) 
ls_port = adw_calc_ballast.GetItemString(ai_rowno, "port_code")

If IsNull(ls_port) Then Return(False)
If Len(Trim(ls_port))<1 Then Return(false)

// Ok, insert the row in the itinerary datawindow, and copy the itinerary
// information from the ballast datawindows to the itinerary datawindow.
li_tmp = dw_calc_itinerary.InsertRow(li_tmp)
dw_calc_itinerary.SetItem(li_tmp, "itinerary", li_tmp)
dw_calc_itinerary.SetItem(li_tmp,"port_code", ls_port)
dw_calc_itinerary.SetItem(li_tmp,"port_n", iuo_calc_nvo.uf_portcode_to_name(ls_port))
dw_calc_itinerary.SetItem(li_tmp, "locked", 1)

dw_calc_itinerary.SetItem(li_tmp,"units", 0)
dw_calc_itinerary.SetItem(li_tmp,"type", "B")
dw_calc_itinerary.SetItem(li_tmp,"via_1", adw_calc_ballast.GetItemString(ai_rowno, "cal_ball_via_point_1"))
dw_calc_itinerary.SetItem(li_tmp,"via_2", adw_calc_ballast.GetItemString(ai_rowno, "cal_ball_via_point_2"))
dw_calc_itinerary.SetItem(li_tmp,"via_3", adw_calc_ballast.GetItemString(ai_rowno, "cal_ball_via_point_3"))
dw_calc_itinerary.SetItem(li_tmp,"via_1_expenses", adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_via_expenses_1"))
dw_calc_itinerary.SetItem(li_tmp,"via_2_expenses", adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_via_expenses_2"))
dw_calc_itinerary.SetItem(li_tmp,"via_3_expenses", adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_via_expenses_3"))
dw_calc_itinerary.SetItem(li_tmp, "distance", adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_distance_to_previous"))
dw_calc_itinerary.SetItem(li_tmp, "time", adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_days_at_sea"))
dw_calc_itinerary.SetItem(li_tmp,"speed", Round(adw_calc_ballast.GetItemNumber(ai_rowno, "cal_ball_leg_speed"),2))

Return(True)
end function

public function boolean uf_saveballast (integer ai_rowno, integer ai_ball_rowno, ref datawindow adw_calc_ballast);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Saves the itinerary entry in row (ai_rowno) to the ballast row
 					(ai_ball_rowno) in ballast datawindow (adw_calc_ballast). Checks
					before saving if the row actually is a ballast row. 

 Arguments : ai_rowno as integer, ai_ball_rowno as integer, adw_calc_ballast
 				 as REF datawindow

 Returns   : True if ok.  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Boolean lb_result

// Check to see if the row given in ai_rowno actually is a 
// ballast row. If so, store it to the given ballast window & rowno
If dw_calc_itinerary.GetItemString(ai_rowno,"type")="B" Then

	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_point_1", dw_calc_itinerary.GetItemString(ai_rowno, "via_1"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_point_2", dw_calc_itinerary.GetItemString(ai_rowno, "via_2"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_point_3", dw_calc_itinerary.GetItemString(ai_rowno, "via_3"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_expenses_1", dw_calc_itinerary.GetItemNumber(ai_rowno, "via_1_expenses"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_expenses_2", dw_calc_itinerary.GetItemNumber(ai_rowno, "via_2_expenses"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_via_expenses_3", dw_calc_itinerary.GetItemNumber(ai_rowno, "via_3_expenses"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_distance_to_previous", dw_calc_itinerary.GetItemNumber(ai_rowno, "distance"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_leg_speed", dw_calc_itinerary.GetItemNumber(ai_rowno, "speed"))
	adw_calc_ballast.SetItem(ai_ball_rowno, "cal_ball_days_at_sea", dw_calc_itinerary.GetItemNumber(ai_rowno, "Time"))

	lb_result = true
End if

Return(lb_result)


end function

public function boolean uf_is_canal (string as_portcode);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Checks if port given in as_portcode is a canal. 

 Arguments : as_portcode as string

 Returns   : True if the portcode identifies a canal

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row
String ls_tmp

// Check to see if we can find the portcode in the port-cache in the w_share window.
// If returned rownumber is less than 1, then we didn't find anything. If we did find
// it, then return the true if the via_point field = 2 (equals canal).
ll_row = w_share.dw_calc_port_dddw.Find("port_code='"+as_portcode+"'", 1, w_share.dw_calc_port_dddw.RowCount())
If ll_row< 1 Then
	
	ls_tmp = "Cannot find "+as_portcode+" in w_share"
	If iuo_calc_nvo.iuo_calculation.ib_show_messages Then
		MessageBox("Error", ls_tmp)
	Else
		iuo_calc_nvo.iuo_calculation.is_message += ls_tmp + "~r~n~r~n"
	End if

	Return(false)
Else
	Return(w_share.dw_calc_port_dddw.GetItemNumber(ll_row, "via_point") = 2)
End if

end function

public subroutine uf_warning (ref s_calculation_parm astr_parm, string as_text);/************************************************************************************

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
	MessageBox("Warning", as_text, Exclamation!)
End if

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

public subroutine uf_clear_cache (boolean ab_clear_itinerary);/************************************************************************************

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
					
 Arguments : ab_clear_itinerary as boolean

 Returns   : None  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
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
is_warning = ""

// If we were asked to clear the itinerary then reset the datawindow.
If ab_clear_itinerary Then dw_calc_itinerary.reset() Else ib_reset_itinerary = true

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
5-5-97		4.05			MI		Initial version  
************************************************************************************/

this.uf_redraw_off()

// Unlock the itinerary by setting the ib_unlocked to true, clear the cache
// (so that the itinerary system re-retrieves upon calling retrieve) and 
// retrieve the data

ib_unlocked = true
uf_clear_cache(true)
uf_retrieve()
ib_display_data_cached = true
dw_calc_itinerary.uf_select_row(1)

this.uf_redraw_on()
end subroutine

private subroutine uf_retrieveport (ref datawindow adw_port, string as_type, ref s_cargolist astr_cargolist[]);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Retrieves all data from adw_port datawindow (load or disch) into the 
 					itinerary datawindow. New rows will have the type of as_type, and will
				 	take the charterer information from the astr_cargolist[]

 Arguments : adw_port as datawindow REF, as_type as string, astr_cargolist[]
 				 as s_cargolist REF.

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Long ll_rowCount, ll_count, ll_insrow, ll_cargo_id
Integer li_charterer_count, li_charterrow, li_max, li_tmp
Double ld_tmp
String ls_port

// Loop through all rows in the (Load or disch) datawindow.  For each row in 
// the datawindow pull out the relevant information, and store it to the 
// itinerary datawindows. The original rownumber must be stored, since it 
// is used to save changes back to the original datawindow and row.

ll_rowCount = adw_port.RowCount()
For ll_count = 1 To ll_RowCount 
	ll_insrow = dw_calc_itinerary.InsertRow(0)
	
	// Get data from datawindow to itinerary, including original row number
	dw_calc_itinerary.SetItem(ll_insrow,"original_row", ll_count)
	dw_calc_itinerary.SetItem(ll_insrow,"itinerary",adw_port.GetItemNumber(ll_count,"cal_caio_itinerary_number"))

	ls_port = adw_port.GetItemString(ll_count, "port_code")
	dw_calc_itinerary.SetItem(ll_insrow,"port_code", ls_port)
	dw_calc_itinerary.SetItem(ll_insrow,"port_n", iuo_calc_nvo.uf_portcode_to_name( ls_port ))
	dw_calc_itinerary.SetItem(ll_insrow,"units",adw_port.GetItemNumber(ll_count,"cal_caio_number_of_units"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_1",adw_port.GetItemString(ll_count,"cal_caio_via_point_1"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_1_expenses",adw_port.GetItemNumber(ll_count,"cal_caio_via_expenses_1"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_2",adw_port.GetItemString(ll_count,"cal_caio_via_point_2"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_2_expenses",adw_port.GetItemNumber(ll_count,"cal_caio_via_expenses_2"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_3",adw_port.GetItemString(ll_count,"cal_caio_via_point_3"))
	dw_calc_itinerary.SetItem(ll_insrow,"via_3_expenses",adw_port.GetItemNumber(ll_count,"cal_caio_via_expenses_3"))
	dw_calc_itinerary.SetItem(ll_insrow,"speed", Round(adw_port.GetItemNumber(ll_count,"cal_caio_leg_speed"),2))
	dw_calc_itinerary.SetItem(ll_insrow,"l_caio_id", adw_port.GetItemNumber(ll_count, "cal_caio_id"))
	dw_calc_itinerary.SetItem(ll_insrow,"port_expenses", adw_port.GetItemNumber(ll_count, "cal_caio_total_port_expenses"))
	If adw_port.GetItemNumber(ll_count,"edit_locked") <> 0 Then li_tmp = 1 Else li_tmp = 0
	dw_calc_itinerary.SetItem(ll_insrow, "locked", li_tmp)
	If adw_port.GetItemNumber(ll_count,"proceed_locked") = 1 Then li_tmp = 1 Else li_tmp = 0
	dw_calc_itinerary.SetItem(ll_insrow, "proceeding_locked", li_tmp)

	// If number of units = 0, then get the purpose_code from the datawindow and display
	// this one rather than the as_type string value.
	If adw_port.GetItemNumber(ll_count,"cal_caio_number_of_units")=0 Then 
		dw_calc_itinerary.SetItem(ll_insrow, "type", adw_port.GetItemString(ll_count,"purpose_code"))
	Else
		dw_calc_itinerary.SetItem(ll_insrow,"type", as_type)
	End if

	dw_calc_itinerary.SetItem(ll_insrow, "time", adw_port.GetItemNumber(ll_count, "cal_caio_days_at_sea"))
	
	// Get the calc_carg_id. If it's valid we use it for a look-up
	// into the table of charter names (that is passed from uf_retrieve).
	ll_cargo_id = adw_port.GetItemNumber(ll_count, "cal_carg_id")
	If ll_cargo_id < 0 Then
		li_charterrow = Abs(ll_cargo_id)
	Else
		li_max = UpperBound(astr_cargolist)

		For li_charterer_count = 1 To li_max
			If ll_cargo_id = astr_cargolist[li_charterer_count].l_carg_id Then
				li_charterrow = li_charterer_count
				Exit
			End if
		Next
	End if

	dw_calc_itinerary.SetItem(ll_insrow, "charterer", astr_cargolist[li_charterrow].s_name)

	// Set distance to zero if null
	ld_tmp = adw_port.GetItemNumber(ll_count,"cal_caio_distance_to_previous")
	If IsNull(ld_tmp) Then ld_tmp = 0
	dw_calc_itinerary.SetItem(ll_insrow,"distance",ld_tmp)
Next


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
This.uf_save(true)

ib_reset_itinerary = true
ib_display_data_cached = false
end subroutine

private subroutine uf_save (boolean ab_force_save);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Saves itinerary data back to load/disch datawindows, if anything is
				 	changed, or the ab_force_save flag is set.

 Arguments : ab_force_save as boolean

 Returns   : True  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_rows, ll_count, ll_rowno, ll_current_cargo
String ls_tmp
DataWindow ldw_tmp

// Misc. initialization - turn redraw off and do the accepttext stuff.
This.uf_redraw_off()
iuo_calc_nvo.iuo_calc_cargos.uf_redraw_off()
dw_calc_itinerary.accepttext()

// The save processes uses the original rownumber for each port row, that
// was originally saved in the itinerary datawindow. Depending on the "type"
// field, the row will be saved to either the dischports (if "type" = "D")
// or the loadports (for any other types).
// Ballastports are saved seperately by calling the uf_saveballast routine.

If (dw_calc_itinerary.ModifiedCount()>0) Or (ab_force_save) Then
	ll_current_cargo = iuo_calc_nvo.iuo_calc_cargos.uf_select_cargo(-1)

	// First save the two ballast ports (if any)
	if uf_saveballast(1,1,iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast) Then dw_calc_itinerary.DeleteRow(1)
	ll_rowno = dw_calc_itinerary.RowCount()
	If uf_saveballast(ll_rowno, 2, iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast) Then dw_calc_itinerary.DeleteRow(ll_rowno)

	ll_rows = dw_calc_itinerary.RowCount()

	// Save all port-rows
	For ll_count = 1 To ll_rows 
		ls_tmp = dw_calc_itinerary.GetItemString(ll_count,"type")
		If (ls_tmp = "D") Then &
			ldw_tmp = iuo_calc_nvo.iuo_calc_cargos.dw_dischports else ldw_tmp = iuo_calc_nvo.iuo_calc_cargos.dw_loadports 

		ll_rowno = dw_calc_itinerary.GetItemNumber(ll_count,"original_row")
		ldw_tmp.SetItem(ll_rowno,"cal_caio_itinerary_number",ll_count)
		ldw_tmp.SetItem(ll_rowno, "cal_caio_distance_to_previous", dw_calc_itinerary.GetItemNumber(ll_count, "distance"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_days_at_sea", dw_calc_itinerary.GetItemNumber(ll_count, "Time"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_point_1", dw_calc_itinerary.GetItemString(ll_count, "via_1"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_expenses_1", dw_calc_itinerary.GetItemNumber(ll_count, "via_1_expenses"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_point_2", dw_calc_itinerary.GetItemString(ll_count, "via_2"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_expenses_2", dw_calc_itinerary.GetItemNumber(ll_count, "via_2_expenses"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_point_3", dw_calc_itinerary.GetItemString(ll_count, "via_3"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_via_expenses_3", dw_calc_itinerary.GetItemNumber(ll_count, "via_3_expenses"))
		ldw_tmp.SetItem(ll_rowno, "cal_caio_leg_speed", dw_calc_itinerary.GetItemNumber(ll_count, "speed"))
	Next

	// Update the sort-order on the load and disch ports
	iuo_calc_nvo.iuo_calc_cargos.uf_select_cargo(ll_current_cargo)
	iuo_calc_nvo.iuo_calc_cargos.dw_loadports.Sort()
	iuo_calc_nvo.iuo_calc_cargos.dw_dischports.Sort()

	// And mark data as invalid, so that data will be reloaded.
	uf_clear_cache(true) 
End if

// Finally turn redraw back on
This.uf_redraw_on()
iuo_calc_nvo.iuo_calc_cargos.uf_redraw_on()
end subroutine

private subroutine uf_check_editlocked ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 11-6-97

 Description : Checks the itinerary for locking, by calling the tramos nvo.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration

u_tramos_nvo uo_tramos_nvo
s_get_cargo_status lstr_status[]
Integer li_index, li_max, li_count, li_viacount, li_tmp, li_status, li_index_max
String ls_tmp
Long ll_fix_id, ll_calc_id

// Get status for calculation. If it's <4 or the global ib_unlocked flag
// is set, then exit.
li_status = iuo_calc_nvo.iuo_calculation.uf_get_status(0)
If (li_status < 4) Or (ib_unlocked) Then Return

// Status >=4 so we have to check each port individually. Create the
// tramos nvo that we'll use to get the locked information from Proceeding.
uo_tramos_nvo = CREATE u_tramos_nvo

// Build the lstr_status array (that is passed to the tramos nvo), containing
// all viapoints and ports. Ballast ports is not to be included in that array.
li_max = dw_calc_itinerary.RowCount()

For li_count = 1 To li_max
	// Add the port, if it's not a ballast port
	If Not (li_count = 1 And ib_first_port_is_ballast) Then
		li_index ++
		lstr_status[li_index].port_code = dw_calc_itinerary.GetItemString(li_count, "port_code")
		lstr_status[li_index].load = dw_calc_itinerary.GetItemString(li_count, "type") = "L"
	End if
			
	// and add the viapoints for this port
	For li_viacount = 1 To 3 
		ls_tmp = dw_calc_itinerary.GetItemString(li_count, "via_"+String(li_viacount))
		If not isnull(ls_tmp) Then
			li_index ++
			// Operations use other codes for viapoints than Itinerary
			lstr_status[li_index].port_code = uo_tramos_nvo.uf_get_disb_portcode(ls_tmp)
			lstr_status[li_index].viapoint = true
		End if
	Next
Next

li_index_max = Upperbound(lstr_status)

// Modified code: Ask only for locked-status if calculation status = 5 (estimated).
// Fixture and calculated will always be locked. Calculated calculation is opened
// after the port has been visited, so the itinerary can't be changed.

If (li_status = 5)  Then
	// Ok, it's an estimated calculation. The the calculation ID, and pass this
	// along with the lstr_status to the tramos nvo.

	ll_fix_id = iuo_calc_nvo.iuo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1,"cal_calc_fix_id")
	
	SELECT CAL_CALC_ID
	INTO :ll_calc_id
	FROM CAL_CALC
	WHERE (CAL_CALC_FIX_ID = :ll_fix_id AND
			CAL_CALC_STATUS = 6);
	COMMIT;

	// Probably not used for anything
	ls_tmp = uo_tramos_nvo.uf_get_port_status(ll_calc_id, lstr_status)

Elseif li_status >= 4 Then// 4 or 6
	// Mark all as locked

	For li_count = 1 To li_index_max
		lstr_status[li_count].locked = true
	Next
End if

// By now the lstr_status array has been updated with the locked information. Now
// store this information to the itinerary datawindow.

li_index = 0

For li_count = 1 To li_max
	
	// This loop just skips the ports. If this voyage has a ballast-from 
	// then do not skip the first port, since it's actually a via_point
	If Not (li_count = 1 And ib_first_port_is_ballast) Then
		li_index ++
	End if

	// Set the itinerary locked status according to the status from the
	// lstr_status table.
	For li_viacount = 1 To 3 
		ls_tmp = dw_calc_itinerary.GetItemString(li_count, "via_"+String(li_viacount))
		li_tmp = 0

		If not isnull(ls_tmp) Then
			li_index ++

			If lstr_status[li_index].locked Then li_tmp = 1 
		Elseif li_index < li_index_max Then
			If lstr_status[li_index + 1].locked Then li_tmp = 1
		End if

		dw_calc_itinerary.SetItem(li_count, "via_"+String(li_viacount)+"_locked", li_tmp)
	Next
Next

DESTROY uo_tramos_nvo

end subroutine

public subroutine uf_delete ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Deletes a viapoint. This routine is called when the user hits
 					the Delete button or clicks delete from the menu, while in 
					one of the viapoints.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variabel declaration
String ls_column, ls_null
Long ll_row
Double ld_null

SetNull(ls_null)
SetNull(ld_null)

// Get current columnname and row number.
ls_column = dw_calc_itinerary.GetColumnName()
ll_row = dw_calc_itinerary.GetRow()

// If it's a valid rownumber, then delete the viapoint, and "drag" the other
// viapoints one step forward. Eg. if the user deletes viapoint 1, then 
// viapoint 2 + 3 is moved into viapoint 1 + 2, and the last via_point is set to null.
If ll_row > 0 Then
	If (ls_column="via_1") Then 
		dw_calc_itinerary.SetItem(ll_row, "via_1", dw_calc_itinerary.GetItemString(ll_row, "via_2"))
		dw_calc_itinerary.SetItem(ll_row, "via_1_expenses", dw_calc_itinerary.GetItemNumber(ll_row, "via_2_expenses"))
	End if
	If (ls_column="via_1") or (ls_column="via_2") Then 
		dw_calc_itinerary.SetItem(ll_row, "via_2", dw_calc_itinerary.GetItemString(ll_row, "via_3"))
		dw_calc_itinerary.SetItem(ll_row, "via_2_expenses", dw_calc_itinerary.GetItemNumber(ll_row, "via_3_expenses"))
	End if
	If (ls_column="via_1") or (ls_column="via_2") or (ls_column="via_3") Then 
		dw_calc_itinerary.SetItem(ll_row, "via_3" , ls_null)
		dw_calc_itinerary.SetItem(ll_row, "via_3_expenses", ld_null)
	End if
End if

// Clear the calculation cache, so that data will be re-calculated.
uf_clear_cache(false)
end subroutine

public subroutine uf_lock_via_expenses ();/************************************************************************************
 Arthur Andersen PowerBuilder Development

 Author  : Teit Aunt 
   
 Date    : 4-2-98

 Description : Locks the viaexpenses according to the calculation status:
 						status = 4 means all via expenses is locked
						status = 5 means all locked viapoints has locked viapoint expenses
						status = 6 means all locked viapoints has open viapoin expenses
 
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
4-2-98	1.0		TA		Initial version
************************************************************************************/

// Variables
Integer li_status, li_index, li_via_locked, li_finished, li_proceed_locked &
			,li_proceed_locked_one, li_proceed_locked_two
long ll_count, ll_calc_id

// Determins whether the via expens columns should be locked
li_status = iuo_calc_nvo.iuo_calculation.uf_get_status(0)
ll_count = dw_calc_itinerary.RowCount()

// Calculations with status fixtured (4)
If li_status = 4 Then
	FOR li_index = 1 TO ll_count
		dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",1)
		dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",1)
		dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",1)
	Next
End if

// Calculations with status calculated (5)
If li_status = 5 Then
	FOR li_index = 1 TO ll_count - 1
		li_proceed_locked_one = dw_calc_itinerary.GetItemNumber(li_index,"proceeding_locked")
		li_proceed_locked_two = dw_calc_itinerary.GetItemNumber(li_index + 1,"proceeding_locked")
		li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_1_locked")

		If li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 1 Then 
			dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",1)
			
		Elseif li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 0 then
			dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",0)
		End if				
	
		li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_2_locked")
		If li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 1 Then 
			dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",1)
			
		Elseif li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 0 then
			dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",0)
		End if				
	
		li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_3_locked")
		If li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 1  Then 
			dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",1)
			
		Elseif li_via_locked = 1 and li_proceed_locked_one = 1 and li_proceed_locked_two = 0 then
			dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",0)
		End if				
	Next
End if

If li_status = 6 Then
	// Investigate if the voyage is marked as finished
	ll_calc_id = iuo_calc_nvo.iuo_calculation.uf_get_calc_id()
	
	SELECT VOYAGE_FINISHED
	INTO :li_finished
	FROM VOYAGES
	WHERE CAL_CALC_ID = :ll_calc_id;
	COMMIT;

	If li_finished = 0 Then
		FOR li_index = 1 TO ll_count - 1
			li_proceed_locked = dw_calc_itinerary.GetItemNumber(li_index + 1,"proceeding_locked")
			li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_1_locked")
			If li_via_locked = 1 and li_proceed_locked = 0 Then 
				dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",1)
				
			Elseif li_via_locked = 1 and li_proceed_locked = 1 then
				dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",0)
			End if				
	
			li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_2_locked")
			If li_via_locked = 1 and li_proceed_locked = 0 Then 
				dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",1)
				
			Elseif li_via_locked = 1 and li_proceed_locked = 1 Then 
				dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",0)
			End if				
	
			li_via_locked = dw_calc_itinerary.GetItemNumber(li_index,"via_3_locked")
			If li_via_locked = 1 and li_proceed_locked = 0 Then 
				dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",1)
				
			Elseif li_via_locked = 1 and li_proceed_locked = 1 Then 
				dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",0)
			End if				
		NEXT
	Elseif li_finished = 1 then
		FOR li_index = 1 TO ll_count
			dw_calc_itinerary.SetItem(li_index,"via_1_exp_locked",1)
			dw_calc_itinerary.SetItem(li_index,"via_2_exp_locked",1)
			dw_calc_itinerary.SetItem(li_index,"via_3_exp_locked",1)
		NEXT
	End if
End if


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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


// Retrieve data to the itinerary window, if no data exists, or data isn't
// cached
If (dw_calc_itinerary.RowCount()=0) or (not ib_display_data_cached) Then
	This.uf_retrieve() 
	ib_display_data_cached = true
End if

ib_active = true

// The following code is due to a PB bug/feature. If we lock the current row, it's
// still possible to modify it, therefore we need to switch current row, before the
// locking becomes effective.
If dw_calc_itinerary.RowCount() > 0 Then
	If dw_calc_itinerary.GetItemNumber(1, "locked") > 0 Then
		dw_calc_itinerary.Setrow(2)
		dw_calc_itinerary.Setrow(1)
	End if

	dw_calc_itinerary.uf_select_row(1)
End if

This.BringToTop = True


end subroutine

public function boolean uf_process (ref s_calculation_parm astr_parm, ref datawindow adw_load, ref datawindow adw_disch); /************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_calc_itinerary
  
Function  : uf_process

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

 Other : {other comments}

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
************************************************************************************/

Integer li_count, li_distance, li_count2
Integer li_speed_max, li_speed_count, li_speedtype, li_speedrow, li_max
String ls_lastpoint, ls_tmp, ls_port1, ls_port2, ls_via, ls_viapoint1, ls_null
String ls_strings[], ls_stringszero[]
Boolean lb_ballasted, lb_modified
Double ld_speed, ld_alt_speed, ld_tmp, ld_time, ld_intake
Integer li_index_list[0 to 1000]
Integer li_old_cargo, li_no_rows, li_current_row, li_next_row, li_start_row
String ls_table_prefix
u_calc_cargos luo_calc_cargos 
Datawindow ldw_current_dw, ldw_next_dw

Setnull(ls_null)

// Exit if we're just checking for save (i_function_code = 1)
If astr_parm.i_function_code = 1 Then Return(True)  

// If calculation data has been cached (ib_process_data_cached = true)
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

	If (is_warning<>"") And (iuo_calc_nvo.iuo_calculation.ib_show_messages) Then MessageBox("Warning", is_warning)
	
	Return true
End if		

// Ok, start the distance calculation. The code for how to do this was modified
// due to optimization reasons. Before we just moved data from the load and 
// dischports into the itinerary datawindow, and did the calculation based on this
// datawindow. To speed things up a little bit, data is no longer moved to the
// itinerary datawindow. Instead the calculation is done directly on the load and
// dischport datawindows. This is faster but somewhat more complicated.
//
// To get the ports in the correct itinerary order, we build an index list
// LI_INDEX_LIST that points to the load and dischports. To distinguise between
// load and disch, load port indexes are positive, while dischports indexes
// are negative. Ballastports are stored as 0. e.g.:
//
// LI_INDEX_LIST:
// [0] = 0		 // Read as ballast-from port (since this is the first entry in the LI_INDEX_LIST)
// [1] = 2      // Read as loadport row #2
// [2] = 1      // Read as loadport row #1
// [3] = -1     // Read as dischport row #1
// [4] = -2     // Read as dischport row #2
// [5] = 0		 // Read as ballast-to port (since this is the last entry in the LI_INDEX_LIST)
//
// If no ballast port is given, the entry will not be added to the LI_INDEX_LIST,
// eg. if no ballast-from port exists, the table will start from 1 rather than 0.
//
// LI_NO_ROWS contains the number of entries in the LI_INDEX_LIST

// Set up local pointer to iuo_calc_cargoes, and select all cargos.
luo_calc_cargos = iuo_calc_nvo.iuo_calc_cargos
li_old_cargo = luo_calc_cargos.uf_select_cargo(-1)

// Ok, now put the load and dischports into the LI_INDEX_LIST according to 
// the comments given before.
li_max = luo_calc_cargos.dw_loadports.RowCount()
li_no_rows = li_max + luo_calc_cargos.dw_dischports.RowCount()

li_index_list[li_no_rows]=0

For li_count = 1 To li_max
	li_index_list[luo_calc_cargos.dw_loadports.GetItemNumber(li_count, "cal_caio_itinerary_number")]= li_count
Next

li_max = luo_calc_cargos.dw_dischports.RowCount()
For li_count = 1 To li_max
	li_index_list[luo_calc_cargos.dw_dischports.GetItemNumber(li_count, "cal_caio_itinerary_number")] = -li_count
Next

// Check if we need to add the ballast-from port (must not be NULL or empty). 
// Remember this has to be stored in LI_INDEX_LIST[0], and must point to 0.
ls_tmp = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast.GetItemString(1, "port_code")
If not isNull(ls_tmp) and (ls_tmp <> "")  Then
	li_start_row = 0
Else
	li_start_row = 1
End if

// Do the same thing for the ballast-to, except that it has to be store as the
// last entry in the LI_INDEX_LIST.
ls_tmp = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast.GetItemString(2, "port_code")
If not isNull(ls_tmp) and (ls_tmp <>"") Then
	li_no_rows ++
	li_index_list[li_no_rows] = 0
End if

// Clear the errortext and get the no. of entries in the speedlist.
astr_parm.result.s_errortext = ""
li_speed_max = UpperBound(iuo_calc_nvo.istr_speedlist)

// Loop through all entries -1 in the LI_INDEX_LIST. For each loop pick out
// the current port and next port from the load or disch datawindows, and
// calculated distance. Viapoints between "current" and "next" is also calculated
// and/or updated.
//
// ldw_current_dw/ldw_next_dw points to current and next datawindow (load/disch)
// li_current_row/li_next_row points to port rows in current and next datawindow
// ls_table_prefix is used to determine where to get the viapoints from -
// This can be "CAL_CAIO" or "CAL_BALL".

For li_count = li_start_row To li_no_rows -1

	// Setup distance to 0, and table prefix to CAL_CAIO
	li_distance = 0	
	ls_table_prefix = "cal_caio"

	// Find ldw_current_dw, li_current_row
	If li_index_list[li_count]>0 Then
		ldw_current_dw = luo_calc_cargos.dw_loadports
		li_current_row = li_index_list[li_count]
	Elseif li_index_list[li_count]<0 Then
		ldw_current_dw = luo_calc_cargos.dw_dischports
		li_current_row = Abs(li_index_list[li_count])
	Else
		ldw_current_dw = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
		ls_table_prefix = "cal_ball"
		li_current_row = 1
	End if

	// and find ldw_next_dw and li_next_row
	If li_index_list[li_count+1]>0 Then
		ldw_next_dw = luo_calc_cargos.dw_loadports
		li_next_row = li_index_list[li_count +1]
	Elseif li_index_list[li_count+1]<0 Then
		ldw_next_dw = luo_calc_cargos.dw_dischports
		li_next_row = Abs(li_index_list[li_count +1])
	Else
		ldw_next_dw = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
		li_next_row = 2
	End if

	// Check that current and next row indicators are valid.
	If (li_current_row = 0) Or (li_next_row = 0) Then
		astr_parm.result.s_errortext = "Internal error~r~n~r~nError in itinerary sequence"
		Return(false)
	End if

	// Get information about the current distance into local variables.
	ls_viapoint1 = ldw_current_dw.GetItemString(li_current_row, ls_table_prefix+"_via_point_1")
	If ls_viapoint1 = "" Then SetNull(ls_viapoint1)
	ls_port1 = ldw_current_dw.GetItemString(li_current_row, "port_code")
	ls_port2 = ldw_next_dw.GetItemString(li_next_row, "port_code")

	// SAFETY: If the two ports are the same, then FORCE all viapoints to nothing.
	If (ls_port1 = ls_port2) And (not isnull(ls_viapoint1)) Then
		SetNull(ls_tmp)
		For li_count2 = 1 To 3 
			ldw_current_dw.SetItem(li_current_row, ls_table_prefix+"_via_point_"+String(li_count2), ls_tmp)
		Next

		lb_modified = true
		ib_display_data_cached = False

		SetNull(ls_viapoint1)
	End if

	// Else, if first viapoint is NULL, then check if we need to find the route,
	// and add the (perhaps) found viapoints into the calculation.
	// Call uf_distance, and if the distance is greater than zero, call uf_get_viapoints.
	// this will return a array of strings containing all the viapoints. If more than
	// 3 found, then limit to 3, and add the viapoints to the calculation.
	
	If IsNull(ls_viapoint1) Then
		If iuo_calc_nvo.uf_distance(ls_port1, ls_port2) > 0 Then
			ls_strings = ls_stringszero
			iuo_calc_nvo.uf_get_viapoints(ls_strings)

			li_max = UpperBound(ls_strings) 
			If li_max > 3 Then
				li_max = 3
				uf_warning(astr_parm,"Cannot include all viapoints for this distance "+ls_port1+" to "+ls_port2)
			End if

			For li_count2 = 1 To li_max 
				ldw_current_dw.SetItem(li_current_row, ls_table_prefix+"_via_point_"+String(li_count2), ls_strings[li_count2])
				
				// Set ls_viapoint1 if we're updating viapoint 1 (this is because ls_viapoint1
				// already contains - or should contain - the first viapoint.
				If li_count2 = 1 Then ls_viapoint1 = ls_strings[li_count2]
				
				// Request the itinerary to update the display next time.
				ib_display_data_cached = false
			Next
		End if
	End if


	// Calculate distance from first port to next viapoint. uf_point_distance will 
	// automaticly check for NULL, and therefore exit if viapoint isn't given. 
	//
	// If a distance can be calculated, then uf_point_distance sets ls_lastpoint equals
	// to next point - in this case ls_viapoint 1. Furthermore expenses are added together.
	
	ls_lastpoint = ls_port1
	ls_via = ls_viapoint1

	If uf_point_distance(ls_lastpoint, ls_via, li_distance, astr_parm.result.s_errortext) Then
		ld_tmp = ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix+"_via_expenses_1")
		If isNull(ld_tmp) Then ld_tmp = 0	

		If uf_is_canal(ls_via) Then
			If ld_tmp = 0 Then uf_warning(astr_parm,"No via expenses defined for viapoint 1 ("+ls_via+")")
		End if	
	
		id_canal_expenses += ld_tmp
	End if

	If astr_parm.result.s_errortext <> "" Then Return(false)	

	// Do the same thing between lastport and viapoint 2
	ls_via = ldw_current_dw.GetItemString(li_current_row, ls_table_prefix+"_via_point_2")
	If uf_point_distance(ls_lastpoint, ls_via, li_distance, astr_parm.result.s_errortext) Then
		ld_tmp = ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix +"_via_expenses_2")
		If isNull(ld_tmp) Then ld_tmp = 0

		If uf_is_canal(ls_via) Then
			If ld_tmp = 0 Then uf_warning(astr_parm,"No via expenses defined for viapoint 2 ("+ls_via+")")
		End if	
		
		id_canal_expenses += ld_tmp
	End if

	If astr_parm.result.s_errortext <> "" Then Return(false)	

	// Do the same thing between lastport and viapoint 3
	ls_via = ldw_current_dw.GetItemString(li_current_row, ls_table_prefix+"_via_point_3")
	If uf_point_distance(ls_lastpoint, ls_via, li_distance, astr_parm.result.s_errortext) Then
		ld_tmp = ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix+"_via_expenses_3")
		If isNull(ld_tmp) Then ld_tmp = 0

		If uf_is_canal(ls_via) Then
			If ld_tmp = 0 Then uf_warning(astr_parm,"No via expenses defined for viapoint 3 ("+ls_via+")")
		End if	
	
		id_canal_expenses += ld_tmp
	End if

	If astr_parm.result.s_errortext <> "" Then Return(false)	

	// And calculated the distance between lastpoint and last port on this leg.
	uf_point_distance(ls_lastpoint, ls_port2 , li_distance, astr_parm.result.s_errortext)
	If astr_parm.result.s_errortext <> "" Then Return(false)	

	// Update distance to the datawindow and clear the cache flags
	ld_tmp = ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix + "_distance_to_previous")
	If (IsNull(ld_tmp)) Or (li_distance<>ld_tmp) Then
		ldw_current_dw.SetItem(li_current_row, ls_table_prefix+ "_distance_to_previous", li_distance)
		ib_display_data_cached = false
		lb_modified = true
	End if

	// Add up sum of intake - this is used to find out whether to use laden
	// or ballasted speeds.
	If li_index_list[li_count]<>0 Then 
		ld_intake += ldw_current_dw.GetItemNumber(li_current_row, "cal_caio_number_of_units")
	End if

	// If current intake is zero, then we use the ballasted speeds.
	lb_ballasted = ld_intake = 0 

	If lb_ballasted Then
		id_miles_ballasted += li_distance
		li_speedtype = 1
	Else
		id_miles_loaded += li_distance
		li_speedtype = 2
	End if

	// Get current selected speed from the datawindow. This speed might or might
	// not be valid, so we need to validate it ourselves!.
	ld_speed = Round(ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix+"_leg_speed"),4)

	li_speedrow = 0
	if uo_global.ib_full_speed then 
		ld_alt_speed = 0
	else
		ld_alt_speed = 9999
	end if

	// Loop through speedlist and check if we can find the selected speed.
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
	
		ldw_current_dw.SetItem(li_current_row, ls_table_prefix + "_leg_speed", ld_speed)
		lb_modified = true
		ib_display_data_cached = False
	End if	

	// If li_distance is greater than zero, we also need to calculate how long time
	// we are laden/ballasted and the consumption,
	If li_distance>0 Then
		// If no speed was found (li_speedrow = 0) then return with an error.
		If li_speedrow=0 Then
			If lb_ballasted Then ls_tmp = "ballasted" else ls_tmp = "loaded"
			astr_parm.result.s_errortext = "No " + ls_tmp+" consumption defined for this vessel"
			Return(false)
		End if

		// Calculate time 
		ld_time = 	(li_distance / iuo_calc_nvo.istr_speedlist[li_speedrow].d_speed) * 60
		If lb_ballasted Then
			id_minutes_ballasted += ld_time
		Else
			id_minutes_loaded += ld_time
		End if		

		// and update the days_at_sea field in either the CAL_CAIO or CAL_BALL table.
		ld_tmp = ldw_current_dw.GetItemNumber(li_current_row, ls_table_prefix + "_days_at_sea") 
		If (ld_time <> ld_tmp) Or IsNull(ld_tmp) Then
			ldw_current_dw.SetItem(li_current_row, ls_table_prefix + "_days_at_sea", ld_time)
			ib_display_data_cached = false
		End if

		// Calculate fuel consumption units.
		id_fo_units += (iuo_calc_nvo.istr_speedlist[li_speedrow].d_fo * ld_time) / 1440
		id_do_units += (iuo_calc_nvo.istr_speedlist[li_speedrow].d_do * ld_time) / 1440
		id_mgo_units += (iuo_calc_nvo.istr_speedlist[li_speedrow].d_mgo * ld_time) / 1440
	Else
		ldw_current_dw.SetItem(li_current_row, ls_table_prefix + "_days_at_sea", 0)
	End if

	// Update the intake_peak, which is used to determine if intake > deatweight
	If ld_intake > astr_parm.result.d_intake_peak Then astr_parm.result.d_intake_peak = ld_intake
Next

// Clear last port row. This row can either be the last dischport or a
// ballast to port. Set the days_at_sea, distance, viapoints and via-
// expenses to 0.
ls_table_prefix = "cal_caio"
If li_index_list[li_no_rows]>0 Then
	ldw_current_dw = luo_calc_cargos.dw_loadports
	li_current_row = li_index_list[li_no_rows]
Elseif li_index_list[li_no_rows]<0 Then
	ldw_current_dw = luo_calc_cargos.dw_dischports
	li_current_row = Abs(li_index_list[li_no_rows])
Else
	ldw_current_dw = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
	ls_table_prefix = "cal_ball"
	li_current_row = 2
End if

ldw_current_dw.SetItem(li_current_row, ls_table_prefix + "_days_at_sea", 0)
ldw_current_dw.SetItem(li_current_row, ls_table_prefix+ "_distance_to_previous", 0)

For li_count = 1 To 3 
	ldw_current_dw.SetItem(li_current_row, ls_table_prefix+"_via_point_"+String(li_count), ls_null)
	ldw_current_dw.SetItem(li_current_row, ls_table_prefix+"_via_expenses_"+String(li_count), 0)
Next

// Check if intake was larger than deadweight
If IsNull(astr_parm.d_deadweight) Then
	uf_warning(astr_parm,"Unable to determine if intake is below maximum, SDWT not specified for this vessel")
Elseif astr_parm.d_deadweight<astr_parm.result.d_intake_peak Then
	uf_warning(astr_parm,"Intake is above SDWT for this vessel~r~n~r~nIntake: "+String(astr_parm.result.d_intake_peak) + &
	" SDWT: "+String(astr_parm.d_deadweight))
End if

// store result values from the itinerary cache to astr_parm.
is_warning = astr_parm.result.s_warningtext
astr_parm.result.d_canal_expenses += id_canal_expenses
astr_parm.d_miles_ballasted += id_miles_ballasted
astr_parm.d_miles_loaded += id_miles_loaded
astr_parm.d_minutes_ballasted += id_minutes_ballasted
astr_parm.d_minutes_loaded += id_minutes_loaded
astr_parm.result.d_fo_units += id_fo_units
astr_parm.result.d_do_units += id_do_units
astr_parm.result.d_mgo_units += id_mgo_units

ib_process_data_cached = true
If lb_modified Then Parent.TriggerEvent("ue_childmodified")

Return(true)
end function

private subroutine documentation ();/********************************************************************
   ObjectName: cargo object
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY>
	Date    		CR-Ref		Author		Comments
	09/02/11		CR1549		JSU042		BP calculations are in read only since multi currency calculation
	12/09/14		CR3773		XSZ004		Change icon absolute path to reference path
	17/03/16		CR2362		LHG008		Remove hard-coded days in Canal
</HISTORY>    
********************************************************************/
end subroutine

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets up the drag-object for the itinerary

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


dw_calc_itinerary.uf_set_dragobject("itinerary")

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc_itinerary,false)
dw_calc_itinerary.Object.DataWindow.Color=RGB(236,236,236)
dw_calc_itinerary.Object.DataWindow.Detail.Color=RGB(236,236,236)

/* set the datawindow readonly, since it is the old calculation with BP Distance Table */
dw_calc_itinerary.Modify("DataWindow.ReadOnly=Yes")
end event

on u_calc_itinerary.create
int iCurrent
call super::create
this.dw_calc_itinerary=create dw_calc_itinerary
this.cbx_show_expenses=create cbx_show_expenses
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calc_itinerary
this.Control[iCurrent+2]=this.cbx_show_expenses
end on

on u_calc_itinerary.destroy
call super::destroy
destroy(this.dw_calc_itinerary)
destroy(this.cbx_show_expenses)
end on

type dw_calc_itinerary from u_datawindow_dragdrop within u_calc_itinerary
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 24
integer width = 2816
integer height = 1248
string dragicon = "images\DRAG.ICO"
string dataobject = "d_calc_itinerary"
boolean vscrollbar = true
end type

event ue_keydown;call super::ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles keydown events for the itinerary datawindow

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Pass delete events on to the uf_delete function
If Keydown( keyDelete!) then 
	uf_delete()
End if
end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles itemchanged events for the itinerary datawindow:
 					- Clears via expenses upon viapoint change

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_columnname

// If the viapoint is changed, then remove the expense
ls_columnname = dw_calc_itinerary.GetColumnName()
If (left(ls_columnname,3) = "via") And (len(ls_columnname) = 5) Then
	dw_calc_itinerary.SetItem(dw_calc_itinerary.GetRow(), ls_columnname + "_expenses", 0)
End if

// Clear the data cache, so that data will be refreshed upon next calculation
uf_clear_cache(false)

end event

event mousedown;call super::mousedown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles mouse down events

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Start draggin if positioned over a valid row (determined by uf_get_dragrow)

il_dragrow = uf_get_dragrow()
If il_dragrow > 0 Then This.Drag(Begin!)



end event

event ue_rowdragged;call super::ue_rowdragged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles ue_rowdragged event for the itinerary datawindow

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_dragfrom, ll_dragto, ll_count,  ll_rows

// Dragfrom row # and Dragto row # is passed in the message object. Validate
// that the dragfrom and dragto rows are valid.
ll_dragfrom = Message.WordParm
ll_dragto = Message.Longparm

ll_rows = dw_calc_itinerary.RowCount()

// Check that we're not setting a loadport as the last port
If (ll_dragto = ll_rows) And (dw_calc_itinerary.GetItemNumber(ll_dragfrom, "units") > 0) Then
	MessageBox("Notice", "You cannot set a loadports as the last port")
	Return
End if

// Check that we're not moving a locked port
If (dw_calc_itinerary.GetItemNumber(ll_dragfrom, "locked") = 1) Or &
	(dw_calc_itinerary.GetItemNumber(ll_dragto, "locked") = 1) Then
	MessageBox("Notice", "You cannot move a locked port")
	Return
End if

// Ok, drag operation is legal, now fixup the itinerary count
If ll_dragfrom > ll_dragto Then
	For ll_count = ll_dragto To ll_rows
		dw_calc_itinerary.SetItem(ll_count, "Itinerary", ll_count + 1 )
	Next
Else
	For ll_count = 1 To ll_dragto
		dw_calc_itinerary.SetItem(ll_count, "Itinerary", ll_count -1 )
	Next
End if

// And reset the viapoints and expenses on the dragged and neighboring rows
uf_row_set_null(ll_dragfrom - 1)
uf_row_set_null(ll_dragfrom)
uf_row_set_null(ll_dragto - 1)
uf_row_set_null(ll_dragto)

// Update the itinerary for the dragged row
dw_calc_itinerary.SetItem(ll_dragfrom, "Itinerary", ll_dragto)

// Sort the itinerary
dw_calc_itinerary.Sort()

// And update the Itinerary count
For ll_count = 1 To ll_rows
	dw_calc_itinerary.SetItem(ll_count, "Itinerary", ll_count  )
Next

// Tell the rest of the calculation system that something has been modified,
// and clear the datacache, so that data will be reloaded upon next calculation
Parent.TriggerEvent("ue_childmodified")
uf_clear_cache(false)


end event

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets up the transaction object

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


ib_auto = true
This.SetTransObject(SQLCA)

/* If external user - readOnly */
IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF


/* set the datawindow readonly, since it is the old calculation with BP Distance Table */
dw_calc_itinerary.Modify("DataWindow.ReadOnly=Yes")
end event

event itemfocuschanged;call super::itemfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles itemfocuschanged events in the itinerary window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DataWindowChild dwc_tmp
Integer li_type
Long ll_row, ll_max, ll_count

// Load correct speedtable, depending on column name - eg. Ballast speeds
// for ballast and loaded speeds for loaded.

If This.GetColumnName()="speed" Then 

	// Get current speedtype from datawindow - if units = 0 or intake = 0 then
	// we want the ballast speeds, otherwise we want the laden speed.
	// Intake is the sum of all loaded and (-)discharged cargo on previouse ports,
	// and indicate wether the vessel is loaded or ballsted on this leg (row)

	ll_row = dw_calc_itinerary.GetRow()
//	If (dw_calc_itinerary.GetItemNumber(ll_row,"units")=0) OR (dw_calc_itinerary.GetitemNumber(ll_row, "intake")=0)  Then 
// Changed by REM 19-08-2002 to below
	If (dw_calc_itinerary.GetitemNumber(ll_row, "intake")=0)  Then 
		li_type = 1 
	Else 
		li_type = 2
	End if

	// Get speed drop-down listbox into the dwc_tmp variable and copy 
	// all entries from the istr_speedlist into the datawindow child,
	// if speedtype equals column speedtype
	dw_calc_itinerary.GetChild("speed", dwc_tmp)
	dwc_tmp.Reset()
	ll_max = UpperBound(iuo_calc_nvo.istr_speedlist[])
	For ll_count = 1 To ll_max
		
		If iuo_calc_nvo.istr_speedlist[ll_count].i_type = li_type Then
			ll_row = dwc_tmp.InsertRow(0)
			dwc_tmp.SetItem(ll_row, "speed", iuo_calc_nvo.istr_speedlist[ll_count].d_speed)
			dwc_tmp.SetItem(ll_row, "name", iuo_calc_nvo.istr_speedlist[ll_count].s_name)
		End if			
	Next
End if
end event

type cbx_show_expenses from uo_cbx_base within u_calc_itinerary
integer x = 2144
integer y = 1324
integer width = 699
integer height = 64
long backcolor = 81324524
string text = "Show port/canal e&xpenses"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : cbx_show_expenses
  
 Event	 : Clicked!

 Scope     : Local

 ************************************************************************************

 Author    : MIS
   
 Date       : 24-8-96

 Description : Toggles between viapoints and expenses.Determins which viapoint
 					expenses fields is locked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
4-2-98	2.0		TA		Modified to handle locking of viapoint expenses fields
************************************************************************************/

String ls_columnname

If dw_calc_itinerary.Accepttext()<> 1 Then Return

dw_calc_itinerary.uf_redraw_off()
ls_columnname = dw_calc_itinerary.GetColumnName()

If this.checked Then
	dw_calc_itinerary.Modify("via_1.visible = 0 via_2.visible = 0 via_3.visible=0")
	dw_calc_itinerary.Modify("via_1_expenses.visible='1~tIf ( getrow() = rowcount(), 0, 1)' via_2_expenses.visible='1~tIf ( getrow() = rowcount(), 0, 1)' via_3_expenses.visible='1~tIf ( getrow() = rowcount(), 0, 1)'")
	If left(ls_columnname,3) = "via" Then dw_calc_itinerary.SetColumn(ls_columnname + "_expenses")

	dw_calc_itinerary.uf_redraw_off()
	uf_lock_via_expenses()
	dw_calc_itinerary.uf_redraw_on()
Else
	dw_calc_itinerary.Modify("via_1_expenses.visible = 0 via_2_expenses.visible = 0 via_3_expenses.visible=0")
	dw_calc_itinerary.Modify("via_1.visible='1~tIf ( getrow() = rowcount(), 0, 1)' via_2.visible='1~tIf ( getrow() = rowcount(), 0, 1)' via_3.visible='1~tIf ( getrow() = rowcount(), 0, 1)'")
	If left(ls_columnname,3) = "via" Then dw_calc_itinerary.SetColumn(left(ls_columnname,5))
End if

dw_calc_itinerary.uf_select_row(dw_calc_itinerary.GetSelectedRow(0))
dw_calc_itinerary.uf_redraw_on()
dw_calc_itinerary.SetFocus()

end event

