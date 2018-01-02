$PBExportHeader$w_oldbp_distance_finder.srw
$PBExportComments$Distance finder (ny version)
forward
global type w_oldbp_distance_finder from mt_w_response_calc
end type
type st_2 from statictext within w_oldbp_distance_finder
end type
type st_1 from statictext within w_oldbp_distance_finder
end type
type cb_close from commandbutton within w_oldbp_distance_finder
end type
type dw_calc_distance_finder from u_datawindow_sqlca within w_oldbp_distance_finder
end type
type dw_calc_via_dddw from u_datawindow_sqlca within w_oldbp_distance_finder
end type
type st_error from statictext within w_oldbp_distance_finder
end type
end forward

global type w_oldbp_distance_finder from mt_w_response_calc
integer width = 2779
integer height = 1556
string title = "BP Distance Finder"
string icon = "images\PASSER.ICO"
st_2 st_2
st_1 st_1
cb_close cb_close
dw_calc_distance_finder dw_calc_distance_finder
dw_calc_via_dddw dw_calc_via_dddw
st_error st_error
end type
global w_oldbp_distance_finder w_oldbp_distance_finder

type variables
u_dddw_search iuo_dddw_search_from
u_dddw_search iuo_dddw_search_to
u_calcutil_nvo iuo_calc_nvo 


end variables

forward prototypes
public function boolean uf_get_distance (ref string as_lastpoint, string as_nextpoint, ref long al_distance, ref string as_errortext)
public subroutine documentation ()
end prototypes

public function boolean uf_get_distance (ref string as_lastpoint, string as_nextpoint, ref long al_distance, ref string as_errortext);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculates the distance between AS_LASTPOINT and AS_NEXTPOINT, adds 
 					the found distance to AL_DISTANCE or returns errortext in 
					AS_ERRORTEXT. Finally it sets AS_LASTPOINT = AS_NEXTPOINT

 Arguments : AS_LASTPOINT as string REF
 				 AS_NEXTPOINT as string
				 AL_DISTANCE as Long REF
				 AS_ERRORTEXT as string REF

 Returns   : True if distance was found an no errors happend 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Long ll_dist

// If AS_LASTPOINT is null then set AS_LASTPOINT = AS_NEXTPOINT and exit
If IsNull(as_lastpoint) Then
	as_lastpoint = as_nextpoint
	Return(false)

Elseif Not IsNull(as_nextpoint) Then
	// Neither AS_LASTPOINT or AS_NEXTPOINT is null, check if they're the same
	If as_lastpoint = as_nextpoint then return(false)

	// if not calculate the distance, and set AS_LASTPOINT = AS_NEXTPOINT
	ll_dist = iuo_calc_nvo.uf_distance(as_lastpoint, as_nextpoint)
	as_lastpoint = as_nextpoint

	// If LL_DIST is lesser than zero, some error occured, and we'll set the
	// errortext in AS_ERRORTEXT and return false
	If ll_dist < 0 Then
		as_errortext = iuo_calc_nvo.uf_distance_error()
		Return(true)
	End if

	// Otherwise update the distance given in AL_DISTANCE and return true
	al_distance += ll_dist
	return true
End if

// AS_NEXTPOINT was null, return false
Return false


end function

public subroutine documentation ();/********************************************************************
   w_oldbp_distance_finder
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
	<HISTORY>
		Date    		Ref   	Author		Comments
		07/08/14		CR3708   AGL027		F1 help application coverage - corrected ancestor
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
*****************************************************************/
end subroutine

event close;call super::close;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Destroys the IUO_CALC_NVO that was used for getting the distance

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DESTROY iuo_calc_nvo


end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Creates the U_CALCUTIL_NVO that is used for calculating the distance

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Create the U_CALCUTIL_NVO
iuo_calc_nvo = CREATE u_calcutil_nvo

// and retrieve data
PostEvent("ue_retrieve")


end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves the VIA ports into the hidden DW_CALC_VIA_DDDW datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_via_dddw.Retrieve()


end event

on w_oldbp_distance_finder.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.cb_close=create cb_close
this.dw_calc_distance_finder=create dw_calc_distance_finder
this.dw_calc_via_dddw=create dw_calc_via_dddw
this.st_error=create st_error
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.dw_calc_distance_finder
this.Control[iCurrent+5]=this.dw_calc_via_dddw
this.Control[iCurrent+6]=this.st_error
end on

on w_oldbp_distance_finder.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.dw_calc_distance_finder)
destroy(this.dw_calc_via_dddw)
destroy(this.st_error)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_oldbp_distance_finder
end type

type st_2 from statictext within w_oldbp_distance_finder
integer x = 302
integer y = 48
integer width = 1993
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Old BP distance finder"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_oldbp_distance_finder
integer x = 302
integer y = 148
integer width = 1993
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Please remember that this is NOT for commercial use!"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_oldbp_distance_finder
integer x = 2478
integer y = 1336
integer width = 247
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes this window

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type dw_calc_distance_finder from u_datawindow_sqlca within w_oldbp_distance_finder
event ue_keydown pbm_dwnkey
integer x = 18
integer y = 320
integer width = 2706
integer height = 880
integer taborder = 30
string dataobject = "d_oldbp_distance_finder"
end type

event ue_keydown;call super::ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles Deletion of viapoints, by delete the selected viapoint, and
 					copying all following viapoints one to the left

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
String ls_column, ls_null
Long ll_row 

// Get the column into a local variable
ls_column = This.GetColumnName()

// and check for Delete 
If Keydown( keyDelete!) Then
	
	// Get current row
	ll_row = This.GetRow()
	
	// Check which viapoint we're on. If we're on VIA1, then copy the contents
	// from VIA2 into VIA1. If we're on VIA1 or VIA2 then copy the contents
	// from VIA3 to VIA2, and if we're on any of the three viapoints the set the
	// last viapoint (3) to null
	If (ls_column="via_1") Then 
		dw_calc_distance_finder.SetItem(ll_row, "via_1", dw_calc_distance_finder.GetItemString(ll_row, "via_2"))
	End if
	If (ls_column="via_1") or (ls_column="via_2") Then 
		dw_calc_distance_finder.SetItem(ll_row, "via_2", dw_calc_distance_finder.GetItemString(ll_row, "via_3"))
	End if
	If (ls_column="via_1") or (ls_column="via_2") or (ls_column="via_3") Then 
		SetNull(ls_null)
		dw_calc_distance_finder.SetItem(ll_row, "via_3",ls_null)
	End if

	// Trigger a Itemchanged! event to perform a calculation
	This.TriggerEvent(ItemChanged!)
End if


end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculates the distance

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
String ls_strings[]
String ls_tmp, ls_fromport, ls_toport, ls_via[3]
String ls_lastpoint // Contains the last point we calculated from, this field is updated
						  // for each call to UF_GET_DISTANCE
String ls_errortext // Contains whatever error there might happen 
String ls_route // Is used building up the route
long ll_row, ll_distance
Integer li_count, li_max
String ls_old_lastpoint

// Get current columnname and row into local variables 
ls_tmp = This.GetColumnName()
ll_row = This.GetRow()

// Get the from and to port into local variables
ls_fromport = dw_calc_distance_finder.GetItemString(ll_row, "fromport")
ls_toport = dw_calc_distance_finder.GetItemString(ll_row, "toport")

// and so with the viapoint
For li_count = 1 To 3 
	ls_via[li_count] = dw_calc_distance_finder.GetItemString(ll_row, "via_"+String(li_count))
Next

// Check which column that was changed
CHOOSE CASE Left(ls_tmp, 3) 
	CASE "fro" 

		// Check if the user typed "=" and isn't on the first port row. If so, we should 
		// copy all data from the row above
		If (This.GetText()="=") And (ll_row > 0) Then
			// The user typed "=" copy data from the row above
			
			ls_fromport = dw_calc_distance_finder.GetItemString(ll_row - 1, "fromport")	
			This.Settext(ls_fromport)
			This.SetItem(ll_row, "fromport", ls_fromport)

			For li_count = 1 To 3 
				dw_calc_distance_finder.SetItem(ll_row, "via_"+String(li_Count), dw_calc_distance_finder.GetItemString(ll_row -1, "via_"+String(li_count)))
			Next

			dw_calc_distance_finder.SetItem(ll_row, "toport", dw_calc_distance_finder.GetItemString(ll_row -1, "toport"))
			dw_calc_distance_finder.SetItem(ll_row, "speed", dw_calc_distance_finder.GetItemNumber(ll_row -1, "speed"))

			Return 2 // Return 2 (SetActionCode 2) to prevent furter action
		Else
			// If it wasn't a "=", call UF_ITEMCHANGED to let the search-as-you-type
			// object to process data
			iuo_dddw_search_from.uf_itemchanged()
			
			// Next, get the data from the buffer, since data isn't in the GetItem at this time
			ls_fromport = This.GetText()
		End if

	CASE "top" 

		// Check if the user typed "=" and isn't on the first port row. If so, we should 
		// copy the port from the row above
		If (This.GetText()="=") And (ll_row > 0) Then
			ls_toport = dw_calc_distance_finder.GetItemString(ll_row - 1, "toport")	
			This.Settext(ls_toport)
			This.SetItem(ll_row, "toport", ls_toport)

			dw_calc_distance_finder.SetItem(ll_row, "speed", dw_calc_distance_finder.GetItemNumber(ll_row -1, "speed"))

			Return 2 // Return 2 (SetActionCode 2) to prevent furter action
		Else
			// If it wasn't a "=", call UF_ITEMCHANGED to let the search-as-you-type
			// object to process data
			iuo_dddw_search_to.uf_itemchanged()

			// and get the data from the buffer, since data isn't in the GetItem at this time
			ls_toport = This.GetText()
		End if
		
	CASE "via"
		// Update the local VIA point array
		ls_via[Integer(Mid(ls_tmp, 5, 1))] = This.GetText()
	CASE ELSE
		// If none of the fields (fromport, toport, viapoints) was changed, then
		// exit as there's nothing to calculate
		Return 
END CHOOSE

// If no speed is given, and not on the first row, then insert the speed
// from the row above.
If IsNull(dw_calc_distance_finder.GetItemNumber(ll_row , "speed")) And ll_row > 1 Then
	dw_calc_distance_finder.SetItem(ll_row, "speed", dw_calc_distance_finder.GetItemNumber(ll_row - 1 , "speed"))
End if

// Set distance to zero and clear the error-variable
ll_distance = 0

// Set all empty viapoints to NULL
For li_count = 1 To 3 
	If ls_via[li_count] = "" Then SetNull(ls_via[li_count])
Next
	
// and stop calculation if from or toport isn't given
If IsNull(ls_fromport) or isnull(ls_toport) Then Return

// Set LS_LASTPOINT to the LS_FROMPORT. This is because LS_LASTPOINT through the
// rest of the calculation is used to calculation where to sail from.
ls_lastpoint = ls_fromport

// If no viapoints is given (LS_VIA[1] is NULL) then get the route from the
// BP distance table, and insert any VIA points found
If Isnull(ls_via[1]) Then

	// Check to see if we can get the distance - and if so if we can get the route
	If iuo_calc_nvo.uf_distance(ls_fromport, ls_toport) > 0 Then
		iuo_calc_nvo.uf_get_viapoints(ls_strings)
		
		// Get the number of viapoints in the LS_STRINGS array, that now contains 0-n
		// viapoints.
		li_max = UpperBound(ls_strings)
		
		// Set max. number of viapoints to 3
		If li_max > 3 Then
			li_max = 3
		End if

		// Loop through all found viapoints, and insert them into the datawindow
		For li_count = 1 To li_max
			ls_via[li_count] = ls_strings[li_count]
			dw_calc_distance_finder.SetItem(ll_row, "via_"+String(li_Count), ls_strings[li_count])
		Next
		
	End if
End if

// Clear the route string, this will be used for building up the final route information
ls_route = ""

// Loop through the whole route (LS_LASTPOINT -> VIA1 -> VIA2 -> VIA3) to get the route
// and the distance
For li_count = 1 To 3
	If uf_get_distance(ls_lastpoint, ls_via[li_count], ll_distance, ls_errortext) Then
		ls_tmp = iuo_calc_nvo.uf_getroute(false)

		If ls_tmp <>"" Then
			If ls_route <>"" Then ls_route += " - "
			ls_route += ls_tmp
		End if
	End if
Next

// Rememeber the last viapoint (either viapoint or fromport)
ls_old_lastpoint = ls_lastpoint

// Get the final route and distance from last point (either viapoint or fromport) to
// the to-port
If uf_get_distance(ls_lastpoint, ls_toport, ll_distance, ls_errortext) Then
	ls_tmp = iuo_calc_nvo.uf_getroute(false)

	If ls_tmp <>"" Then
		If ls_route <>"" Then ls_route += " - "
		ls_route += ls_tmp
	End if
End if

// If LS_ERRORTEXT is <> "", then some error happend, set the distanse to zero, and
// put the errortext in the ROUTE field of the datawindow
If ls_errortext <>"" Then
	ll_distance = 0
	dw_calc_distance_finder.SetItem(ll_row, "route", ls_errortext)
Else
	// Ok, no error happend, if no route was found, then insert the text "No route information"
	If ls_route = "" Then ls_route = "No route information"
	// and update the route field in the datawindow
	dw_calc_distance_finder.SetItem(ll_row, "route", ls_route)
End if	

// Set the distance in the datawindow
dw_calc_distance_finder.SetItem(ll_row, "distance", ll_distance)

// And trigger a RowFocusChanged, to get the routeinformation show in the window
This.TriggerEvent(RowFocusChanged!)

end event

event rowfocuschanged;call super::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Copies the routeinformation (hidden field of the datawindow) to the
 					ST_ERROR textbox on the window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

st_error.text = dw_calc_distance_finder.GetItemString(dw_calc_distance_finder.GetRow(), "route")
end event

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls the UF_EDITCHANGED in the from or to-port search object

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


CHOOSE CASE Left(This.GetColumnName(), 4) 
	CASE "from" // Fromport
		iuo_dddw_search_from.uf_editchanged()
	CASE "topo" // To port
		iuo_dddw_search_to.uf_editchanged()
END CHOOSE
end event

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Creates the various search objects needed and shares datawindows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
DataWindowChild dwc_tmp
Integer li_count

// Create the searchobject needed for the search-as-you-type from and toport lists
iuo_dddw_search_from = CREATE u_dddw_search
iuo_dddw_search_from.uf_setup(dw_calc_distance_finder, "fromport", "port_n",true)
	
iuo_dddw_search_to = CREATE u_dddw_search
iuo_dddw_search_to.uf_setup(dw_calc_distance_finder, "toport", "port_n",true)

// Share the from and port ports to the hidden W_SHARE
dw_calc_distance_finder.GetChild("fromport",dwc_tmp)
uf_sharechild("dw_calc_port_dddw", dwc_tmp)

dw_calc_distance_finder.GetChild("toport",dwc_tmp)
uf_sharechild("dw_calc_port_dddw", dwc_tmp)

// Share the data for the VIA-list to the DW_CALC_VIA_DDDW
dw_calc_distance_finder.GetChild("via",dwc_tmp)
dw_calc_via_dddw.ShareData(dwc_tmp)

// Insert 8 rows that the user can use to enter information into
For li_count = 1 To 8 
	This.InsertRow(0)
Next

end event

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Destroy the searchobjects used for the search-as-you-type 
 					functionality

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DESTROY iuo_dddw_search_from
DESTROY iuo_dddw_search_to

end event

type dw_calc_via_dddw from u_datawindow_sqlca within w_oldbp_distance_finder
boolean visible = false
integer x = 2203
integer y = 1120
integer width = 402
integer height = 160
integer taborder = 10
string dataobject = "d_calc_via_dddw"
end type

type st_error from statictext within w_oldbp_distance_finder
integer x = 23
integer y = 1220
integer width = 2267
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

