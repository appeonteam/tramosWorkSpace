$PBExportHeader$u_googlemap_activex.sru
forward
global type u_googlemap_activex from olecustomcontrol
end type
end forward

global type u_googlemap_activex from olecustomcontrol
integer width = 4498
integer height = 1800
boolean focusrectangle = false
string binarykey = "u_googlemap_activex.udo"
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
event setphishingfilterstatus ( long phishingfilterstatus )
end type
global u_googlemap_activex u_googlemap_activex

type variables

OleObject iole_GMap

Integer ii_MarkerCount
end variables

forward prototypes
public subroutine of_clearmap ()
public subroutine of_closeinfowindow (integer ai_index)
public function string of_comma2dot (decimal ad_num)
public function string of_long2hex (long al_long)
public subroutine of_moveto (double ad_lat, double ad_long)
public subroutine of_removemarker (integer ai_marker)
public subroutine of_openinfowindow (integer ai_index)
public subroutine of_zoomto (integer ai_zoom)
public subroutine documentation ()
public subroutine of_addcircle (double adb_lat, double adb_long, integer ai_radius)
public function integer of_addmarker (double adb_lat, double adb_long, string as_title, string as_info, long al_color)
end prototypes

event navigatecomplete2(oleobject pdisp, any url);
String ls_url
Integer li_Pos

ls_url = url

// Check if url contains vsl/voy info
li_Pos = Pos(ls_url, "#")
If li_Pos > 0 then
	ls_url = Right(ls_url, Len(ls_url) - li_Pos)
	li_Pos = Pos(ls_url, ";")
	If li_Pos < 2 then Return
	
	u_jump_poc luo_POC
	luo_POC = Create u_jump_poc
	luo_POC.of_open_poc(Integer(Left(ls_url, li_Pos - 1)), Right(ls_url, Len(ls_url) - li_Pos))
	Destroy luo_Poc
End If
end event

event documentcomplete(oleobject pdisp, any url);
iole_GMap = This.Object.Document
end event

public subroutine of_clearmap ();// This function clears the map of all overlays (all markers and circles)

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript("deleteOverlays();", "javascript")

ii_MarkerCount = 0
end subroutine

public subroutine of_closeinfowindow (integer ai_index);// This function closes a Infowindow

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript('infoArray[' + String(ai_Index) + '].close();', 'javascript')


end subroutine

public function string of_comma2dot (decimal ad_num);// This function converts a number into a string and replaces
// commas (if any) with dots (for converting danish numbers)

String ls_Num
Integer li_Pos

ls_Num = String(ad_Num)

li_Pos = Pos(ls_Num,",")
If li_Pos > 0 then ls_Num = Replace(ls_Num, li_Pos, 1, ".")

Return ls_Num
end function

public function string of_long2hex (long al_long);// This function converts a long color value into hexadecimal color (for web use)

Integer ai_Rem
String ls_Hex

Do
	ai_Rem = mod(al_Long, 16)
	If ai_Rem < 10 then
		ls_Hex = String(ai_Rem) + ls_Hex
	Else
		ls_Hex = CharA(ai_Rem + 55) + ls_Hex
	End If
	al_Long = al_Long / 16
Loop Until al_Long = 0

Do While Len(ls_Hex) < 6
	ls_Hex = "0" + ls_Hex
Loop

// Reverse order for web hexadecimal colors
ls_Hex = Right(ls_Hex, 2) + Mid(ls_Hex, 3, 2) + Left(ls_Hex, 2)

Return ls_Hex
end function

public subroutine of_moveto (double ad_lat, double ad_long);// This function moves the map to a new lat/lng location

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript("map.panTo(new google.maps.LatLng(" + of_Comma2Dot(ad_Lat) + ", " + of_Comma2Dot(ad_Long) + "));", "javascript")

end subroutine

public subroutine of_removemarker (integer ai_marker);// This function removes a marker at the specified index

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript('markersArray[' + String(ai_Marker) + '].setMap(null);markersArray[' + String(ai_Marker) + ']=null;infoArray[' + String(ai_Marker) + '].close();infoArray[' + String(ai_Marker) + ']=null;', 'javascript')

end subroutine

public subroutine of_openinfowindow (integer ai_index);// This function opens a Infowindow

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript('infoArray[' + String(ai_Index) + '].open(map, markersArray[' + String(ai_Index) + ']);if(lastInfo){lastInfo.close()};lastInfo=infoArray[' + String(ai_Index) + '];', 'javascript')


end subroutine

public subroutine of_zoomto (integer ai_zoom);// This function zooms to the specified level (1 to 7)

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript("map.setZoom(" + String(ai_Zoom) + ");", "javascript")
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_googlemap_activex
	
   <OBJECT>
		This object is basically a MS-browser control running on the Internet Explorer
		engine used from loading GMap.htm. Once Google maps is loaded, you can use
		the various functions.
	</OBJECT>
	
   <USAGE>
	
		Use the provided functions to add/remover markers, info boxes and circles.
		
	</USAGE>

<HISTORY> 
   Date	   CR-Ref	 Author	Comments
   20-06-10	1517	   CONASW	First Version
</HISTORY>    
********************************************************************/
end subroutine

public subroutine of_addcircle (double adb_lat, double adb_long, integer ai_radius);// This function adds a circle at the specified lat/lng position
// with the specified radius (in nautical miles)

If Not IsValid(iole_GMap) then Return

iole_GMap.ParentWindow.ExecScript('createCircle(new google.maps.LatLng(' + of_Comma2Dot(adb_lat) + ', ' + of_Comma2Dot(adb_long) + '),' + String(ai_Radius * 1852) + ');', 'javascript')

end subroutine

public function integer of_addmarker (double adb_lat, double adb_long, string as_title, string as_info, long al_color);/********************************************************************
   of_addmarker
   <DESC>	This function adds a single marker on a map along with the info box</DESC>
   <RETURN>	None	</RETURN>
   <ACCESS>	Public </ACCESS>
   <ARGS>	adb_lat: Latitude
            adb_long: Longitude
				as_title: The tooltip for the marker
				as_info: The information shown in the pop-up infobox (you can use HTML to format)
				al_color: The color of the icon (not currently in use)
	</ARGS>
   <USAGE>	
		This function adds a marker with a infobox to google maps. Use it 
		to display any marker on the map which can be clicked to open the infobox
		
	</USAGE>
********************************************************************/


If Not IsValid(iole_GMap) then Return 0

// Create url string for icon  (to be used for colored icons)
//String ls_Icon = "http://chart.apis.google.com/chart?chst=d_bubble_text_small_withshadow&chld="
//ls_Icon += "bb|1WQ|" + Long2Hex(al_Color) + "|000000"

// Add marker
iole_GMap.ParentWindow.ExecScript('createMarkerWithInfoWindow(new google.maps.LatLng(' + of_Comma2Dot(adb_lat) + ', ' + of_Comma2Dot(adb_long) + '),"' + as_Title + '","' + as_Info + '");', 'javascript')

// Increment marker count
ii_MarkerCount ++

// Return marker index
Return ii_MarkerCount - 1
end function

on u_googlemap_activex.create
end on

on u_googlemap_activex.destroy
end on


Start of PowerBuilder Binary Data Section : Do NOT Edit
09u_googlemap_activex.bin 
2700000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000e4f09b5001cb1cf500000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f00000000e4f09b5001cb1cf5e4f09b5001cb1cf5000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c000065b300002e820000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c000065b300002e820000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19u_googlemap_activex.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
