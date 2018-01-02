$PBExportHeader$w_calc_find_unctad.srw
$PBExportComments$Find UNCTAD code for a habor, or a near port
forward
global type w_calc_find_unctad from mt_w_sheet_calc
end type
type cb_close from commandbutton within w_calc_find_unctad
end type
type dw_calc_longlat from u_datawindow_sqlca within w_calc_find_unctad
end type
type dw_calc_longlat_search from uo_datawindow within w_calc_find_unctad
end type
type cb_clear from commandbutton within w_calc_find_unctad
end type
type cb_search_longlat from commandbutton within w_calc_find_unctad
end type
type st_norows from statictext within w_calc_find_unctad
end type
type dw_calc_unctad_search_name from uo_datawindow within w_calc_find_unctad
end type
type cb_search_name from commandbutton within w_calc_find_unctad
end type
type cbx_los_distance from uo_cbx_base within w_calc_find_unctad
end type
type gb_1 from uo_gb_base within w_calc_find_unctad
end type
type gb_3 from uo_gb_base within w_calc_find_unctad
end type
end forward

global type w_calc_find_unctad from mt_w_sheet_calc
integer width = 2825
integer height = 1560
string title = "Find UNCTAD"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
long backcolor = 32304364
cb_close cb_close
dw_calc_longlat dw_calc_longlat
dw_calc_longlat_search dw_calc_longlat_search
cb_clear cb_clear
cb_search_longlat cb_search_longlat
st_norows st_norows
dw_calc_unctad_search_name dw_calc_unctad_search_name
cb_search_name cb_search_name
cbx_los_distance cbx_los_distance
gb_1 gb_1
gb_3 gb_3
end type
global w_calc_find_unctad w_calc_find_unctad

type prototypes
function long AirDistance(long latt1,long long1,long latt2,long long2) library 'AIRDIST.dll'
function long AirDistance32(long latt1,long long1,long latt2,long long2) library 'AIRDIS32.dll' ALIAS FOR 'AirDistance'
end prototypes

type variables

end variables

forward prototypes
public function integer wf_air_distance (string ls_latitude1, string ls_longitude1, string ls_latitude2, string ls_longitude2)
public function boolean wf_split_coord (string as_coord, ref integer ai_degrees, ref integer ai_minutes, ref string as_direction, string as_valid_direction)
public subroutine documentation ()
end prototypes

public function integer wf_air_distance (string ls_latitude1, string ls_longitude1, string ls_latitude2, string ls_longitude2);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculates the distance between two coordinates given as strings,
 					ls_latitude1, ls_longitude1 and ls_latitude2, ls_longitude2.

 Arguments :   LS_LATITUDE1, LS_LONGITUDE1, LS_LATITUDE2, LS_LONGITUDE2 as string

 Returns   : Distance as integer value

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Integer li_degrees, li_minutes
String ls_direction
Long ll_latt1, ll_long1, ll_latt2, ll_long2

// Convert all longitude and latitude coordinates into the integer presentation
// used in the UNCTAD table.
If not wf_split_coord(ls_latitude1, li_degrees, li_minutes, ls_direction, "NS") Then Return -1
ll_latt1 = (li_degrees + (li_minutes / 60)) * 10000
if ls_direction = "S" Then ll_latt1 = -ll_latt1

If not wf_split_coord(ls_longitude1, li_degrees, li_minutes, ls_direction, "EW") Then Return -1
ll_long1 = (li_degrees + (li_minutes / 60)) * 10000
if ls_direction = "E" Then ll_long1 = -ll_long1

If not wf_split_coord(ls_latitude2, li_degrees, li_minutes, ls_direction, "NS") Then Return -1
ll_latt2 = (li_degrees + (li_minutes / 60)) * 10000
if ls_direction = "S" Then ll_latt2 = -ll_latt2

If not wf_split_coord(ls_longitude2, li_degrees, li_minutes, ls_direction, "EW") Then Return -1
ll_long2 = (li_degrees + (li_minutes / 60)) * 10000
if ls_direction = "E" Then ll_long2 = -ll_long2

// And get the distance by calling the AirDistance function in the Airdist dll.
Return airDistance32(ll_latt1, ll_long1, ll_latt2, ll_long2)

end function

public function boolean wf_split_coord (string as_coord, ref integer ai_degrees, ref integer ai_minutes, ref string as_direction, string as_valid_direction);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Converts a string logitude/latitude presented value given in 
 					AS_COORD into their integer presentation AI_DEGREES, AI_MINUTES and
					direction (N, S, E or W) in AS_DIRECTION.
					 
					AS_VALID_DIRECTION must contain the valid directions 

 Arguments : AS_COORD as string
 				 AI_DEGREES, AI_MINUTES as integer REF
				 AS_DIRECTION as string REF 
				 AS_VALID_DIRECTION as string
	
 Returns   : True if the given direction is valid  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ai_degrees = Integer(Mid(as_coord,1,3))
ai_minutes = Integer(Mid(as_coord,4,2))
as_direction = Upper(Right(as_coord,1))

Return(  (ai_degrees >= 0) and (ai_degrees < 180) and (ai_minutes >= 0) and (ai_minutes < 60) and (Pos(as_valid_direction, as_direction)>0))
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018	The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves data into the DW_CALC_LONGLAT datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_longlat.Retrieve()
end event

on w_calc_find_unctad.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_calc_longlat=create dw_calc_longlat
this.dw_calc_longlat_search=create dw_calc_longlat_search
this.cb_clear=create cb_clear
this.cb_search_longlat=create cb_search_longlat
this.st_norows=create st_norows
this.dw_calc_unctad_search_name=create dw_calc_unctad_search_name
this.cb_search_name=create cb_search_name
this.cbx_los_distance=create cbx_los_distance
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_calc_longlat
this.Control[iCurrent+3]=this.dw_calc_longlat_search
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.cb_search_longlat
this.Control[iCurrent+6]=this.st_norows
this.Control[iCurrent+7]=this.dw_calc_unctad_search_name
this.Control[iCurrent+8]=this.cb_search_name
this.Control[iCurrent+9]=this.cbx_los_distance
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_3
end on

on w_calc_find_unctad.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_calc_longlat)
destroy(this.dw_calc_longlat_search)
destroy(this.cb_clear)
destroy(this.cb_search_longlat)
destroy(this.st_norows)
destroy(this.dw_calc_unctad_search_name)
destroy(this.cb_search_name)
destroy(this.cbx_los_distance)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Posts a retrieve event for the DW_CALC_LONGLAT datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


PostEvent("ue_retrieve")


n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwformformater(dw_calc_longlat_search)
lnv_style.of_dwformformater(dw_calc_unctad_search_name)
lnv_style.of_dwlistformater(dw_calc_longlat,false)
end event

type st_hidemenubar from mt_w_sheet_calc`st_hidemenubar within w_calc_find_unctad
end type

type cb_close from commandbutton within w_calc_find_unctad
integer x = 2437
integer y = 1336
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_calc_longlat from u_datawindow_sqlca within w_calc_find_unctad
integer x = 32
integer y = 20
integer width = 2743
integer height = 832
integer taborder = 70
string dataobject = "d_calc_unctad"
boolean vscrollbar = true
end type

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the IB_AUTO (auto handle mouse-clicks) to true

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ib_auto = true
end event

event retrieveend;call super::retrieveend;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Update the number of rows displayed

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

St_norows.text = String(This.RowCount())+" row(s)"
end event

type dw_calc_longlat_search from uo_datawindow within w_calc_find_unctad
integer x = 50
integer y = 1008
integer width = 1678
integer height = 84
integer taborder = 10
string dataobject = "d_calc_unctad_search"
boolean border = false
end type

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the Search longitude/latitude button to be default

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


cb_search_longlat.Default = true
end event

type cb_clear from commandbutton within w_calc_find_unctad
integer x = 2437
integer y = 1212
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refresh"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Display all rows in the long/lat datawindow, by clearing the filter

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_longlat.SetFilter("")
dw_calc_longlat.Filter()
dw_calc_longlat.Sort()

// Post a retrieve event to get the rowcount updated
dw_calc_longlat.PostEvent(RetrieveEnd!)
end event

type cb_search_longlat from commandbutton within w_calc_find_unctad
integer x = 1751
integer y = 1104
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Searches for the ports within the given Latitude/Longitude/Time
 					radius. 

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
String ls_longitude, ls_latitude, ls_direction, ls_filter, ls_within, ls_tmplat, ls_tmplong
Integer li_degrees, li_minutes, li_longitude, li_latitude, li_max, li_count

// Call accepttext to update the search datawindow with data from the buffer
dw_calc_longlat_search.Accepttext()

// Get longitude, latitude and time into local variables
ls_longitude = dw_calc_longlat_search.GetItemString(1, "longitude")
ls_latitude = dw_calc_longlat_search.GetItemString(1, "latitude")
ls_within = String(dw_calc_longlat_search.GetItemNumber(1, "within"))

// If longitude or latitude is null, then set it to "" empty string
if IsNull(ls_longitude) Then ls_longitude = ""
if IsNull(ls_latitude) Then ls_latitude = ""

// Split longitude into degrees and minutes. Show error if invalid direction
If not wf_split_coord(ls_longitude, li_degrees, li_minutes, ls_direction, "EW") Then
	MessageBox("Error","Error in longitude coordinates")
	Return
End if

// Convert longitude into the integer presentation used in the UNCTAD table
li_longitude = (li_degrees*60) + li_minutes
If ls_direction = "E" Then li_longitude = 10800 - li_longitude Else li_longitude = 10800 + li_longitude

// Split latitude into degrees and minutes. Show error if invalid direction
If not wf_split_coord(ls_latitude, li_degrees, li_minutes, ls_direction, "NS") Then
	MessageBox("Error","Error in latitude coordinates")
	Return
End if

// Convert latitude into the integer presentation used in the UNCTAD table
li_latitude = (li_degrees*60) + li_minutes
If ls_direction = "N" Then li_latitude = 5400 - li_latitude Else li_latitude = 5400 + li_latitude


// Create the filter used to filter in the DW_CALC_LONGLAT datawindow
ls_filter = "Abs(cal_unct_latitude-"+String(li_latitude)+")<"+ls_within+" And Abs(cal_unct_longitude-"+String(li_longitude)+")<"+ls_within

// Set the filter, and sort
dw_calc_longlat.SetFilter(ls_filter)
dw_calc_longlat.Filter()
dw_calc_longlat.Sort()	

// If at least one row was found, then set focus to the DW_CALC_LONGLAT datawindow
If dw_calc_longlat.RowCount()>0 Then
	dw_calc_longlat.SetFocus()
	This.Default = false

	// Check if the user wants the distance showed
	If cbx_los_distance.Checked then
		Setpointer(Hourglass!)

		// The distance between the original coordinates and each port must be
		// calculated. Loop through all rows in the datawindow, and calculate
		// the distance for each entry
		li_max = dw_calc_longlat.Rowcount()
		For li_count = 1 To li_max
			
			// Get the longitude and latitude for this row
			ls_tmplong = dw_calc_longlat.GetItemString(li_count, "cal_unct_ascii_longitude")
			ls_tmplat = dw_calc_longlat.GetItemString(li_count, "cal_unct_ascii_latitude")

			// Convert ls_tmplong and lat to valid strings (pad with zero's)
			Do While Len(ls_tmplong) < 8 
				ls_tmpLong = "0" + ls_tmplong
			Loop

			Do While Len(ls_tmplat) < 8 
				ls_tmplat = "0" + ls_tmplat
			Loop

			// Remove minute/second degree symbol from the strings
			ls_tmplong = Mid(ls_tmplong,1,3) + Mid(ls_tmplong,5,2) + Mid(ls_tmplong,8,1)
			ls_tmplat = Mid(ls_tmplat,1,3) + Mid(ls_tmplat,5,2) + Mid(ls_tmplat,8,1)
			
			// And get the distance into the datawindow from the WF_AIR_DISTANCE function
			dw_calc_longlat.SetItem(li_count, "distance", &
			wf_air_distance(ls_latitude, ls_longitude, ls_tmplat, ls_tmplong))
		Next

		SetPointer(Arrow!)
	end if

Else
	// No rows was found, put focus to the search datawindow
	dw_calc_longlat_search.SetFocus()
End if

end event

type st_norows from statictext within w_calc_find_unctad
integer x = 2322
integer y = 864
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_calc_unctad_search_name from uo_datawindow within w_calc_find_unctad
integer x = 59
integer y = 1316
integer width = 1499
integer height = 96
integer taborder = 30
string dataobject = "d_calc_unctad_search_name"
boolean border = false
end type

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the search name button to be the default

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_search_name.Default = true
end event

type cb_search_name from commandbutton within w_calc_find_unctad
integer x = 1751
integer y = 1316
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "S&earch"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Searches for partial port or country name

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_country, ls_portname, ls_search_str

// Acceptext on datawindow
dw_calc_unctad_search_name.Accepttext()

// Get country and portname into local variables
ls_country = dw_calc_unctad_search_name.GetItemString(1, "country")
ls_portname = dw_calc_unctad_search_name.GetItemString(1, "portname")

// Build LS_SEARCH_STR for partial string match
If ls_country<>"" Then ls_search_str = "Mid(Upper(cal_unct_country),1,"+String(Len(ls_country))+")='"+ls_country+"'"
If ls_portname <>"" Then
	if ls_search_str <> "" Then ls_search_str += " AND "
	ls_search_str += "Mid(Upper(cal_unct_port_name),1,"+String(Len(ls_portname))+")='"+ls_portname+"'"
End if

// Set the filter on the datawindow
dw_calc_longlat.SetFilter(ls_Search_Str)
dw_calc_longlat.Filter()
dw_calc_longlat.Sort()

// And set the focus to the datawindow if any rows was found, otherwise just set
// focus back the search window
If dw_calc_longlat.RowCount()>0 Then
	dw_calc_longlat.SetFocus()
	This.Default = false
Else
	dw_calc_unctad_search_name.SetFocus()
End if

end event

type cbx_los_distance from uo_cbx_base within w_calc_find_unctad
integer x = 69
integer y = 1120
integer width = 1810
integer height = 64
long backcolor = 32304364
string text = "Show air (line-of-sight) distance "
end type

type gb_1 from uo_gb_base within w_calc_find_unctad
integer x = 32
integer y = 928
integer width = 2085
integer height = 304
integer taborder = 0
integer weight = 700
long backcolor = 32304364
string text = "Search Longitude/Latitude"
end type

type gb_3 from uo_gb_base within w_calc_find_unctad
integer x = 32
integer y = 1236
integer width = 2085
integer height = 208
integer taborder = 0
integer weight = 700
long backcolor = 32304364
string text = "Search Name/Country"
end type

