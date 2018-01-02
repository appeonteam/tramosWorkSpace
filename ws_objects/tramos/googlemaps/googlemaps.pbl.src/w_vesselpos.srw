$PBExportHeader$w_vesselpos.srw
forward
global type w_vesselpos from w_tramos_container
end type
type tab_main from tab within w_vesselpos
end type
type tabpage_1 from userobject within tab_main
end type
type cb_clear from commandbutton within tabpage_1
end type
type cb_all from commandbutton within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type dw_vsl from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_main
cb_clear cb_clear
cb_all cb_all
st_1 st_1
dw_vsl dw_vsl
end type
type tabpage_2 from userobject within tab_main
end type
type cb_clearpos from commandbutton within tabpage_2
end type
type cb_allpos from commandbutton within tabpage_2
end type
type st_5 from statictext within tabpage_2
end type
type dw_pos from datawindow within tabpage_2
end type
type st_4 from statictext within tabpage_2
end type
type st_3 from statictext within tabpage_2
end type
type dw_onevsl from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_main
cb_clearpos cb_clearpos
cb_allpos cb_allpos
st_5 st_5
dw_pos dw_pos
st_4 st_4
st_3 st_3
dw_onevsl dw_onevsl
end type
type tabpage_3 from userobject within tab_main
end type
type cbx_circle from checkbox within tabpage_3
end type
type cb_clearports from commandbutton within tabpage_3
end type
type cb_area from commandbutton within tabpage_3
end type
type cbx_dest from checkbox within tabpage_3
end type
type st_result from statictext within tabpage_3
end type
type dw_vslnear from datawindow within tabpage_3
end type
type st_10 from statictext within tabpage_3
end type
type st_9 from statictext within tabpage_3
end type
type st_6 from statictext within tabpage_3
end type
type st_7 from statictext within tabpage_3
end type
type st_8 from statictext within tabpage_3
end type
type cb_find from commandbutton within tabpage_3
end type
type uo_search from u_searchbox within tabpage_3
end type
type ddlb_age from dropdownlistbox within tabpage_3
end type
type sle_dist from singlelineedit within tabpage_3
end type
type dw_ports from datawindow within tabpage_3
end type
type ln_1 from line within tabpage_3
end type
type tabpage_3 from userobject within tab_main
cbx_circle cbx_circle
cb_clearports cb_clearports
cb_area cb_area
cbx_dest cbx_dest
st_result st_result
dw_vslnear dw_vslnear
st_10 st_10
st_9 st_9
st_6 st_6
st_7 st_7
st_8 st_8
cb_find cb_find
uo_search uo_search
ddlb_age ddlb_age
sle_dist sle_dist
dw_ports dw_ports
ln_1 ln_1
end type
type tab_main from tab within w_vesselpos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_vesselpos from w_tramos_container
integer width = 4686
integer height = 2844
string title = "Vessel Position Map"
string icon = "images\GMapPos.ico"
tab_main tab_main
end type
global w_vesselpos w_vesselpos

type prototypes


end prototypes

type variables

u_googlemap_activex iu_GMap

Integer ii_width, ii_height

Boolean ib_MapCleared = True
end variables

forward prototypes
public subroutine wf_setheightwidth (dragobject ad_object)
public function long wf_getagecolor (integer ai_age)
public subroutine wf_resizemap ()
private subroutine wf_initmap ()
private function string wf_getvesselinfo (ref datawindow adw_pos, integer ai_row, boolean abool_includename)
public subroutine wf_addhistposition (ref datawindow adw_pos, integer ai_row)
public subroutine documentation ()
public subroutine wf_centerposition (decimal ad_lat, decimal ad_long, integer ai_zoom)
end prototypes

public subroutine wf_setheightwidth (dragobject ad_object);
ii_width = UnitsToPixels(ad_object.Width, XUnitsToPixels!)
ii_height = UnitsToPixels(ad_object.Height, YUnitsToPixels!) 
end subroutine

public function long wf_getagecolor (integer ai_age);// This function returns a color based on the age of the position
// 0 = Green color
// li_Max or greater = Red color
// li_Max/2  = Yellow color

// Colors are interpolated

Integer li_Max = 8    // Set this value to the max age after which all are red
Integer li_Red, li_Green

If ai_Age > li_Max then ai_Age = li_Max

If ai_Age <= li_Max/2 then
	li_Green = 255
	li_Red = ai_Age / li_Max * 2 * 255
Else
	li_Red = 255
	li_Green = (li_Max - ai_Age) / li_Max * 2 * 255	
End If
	
Return RGB(li_Red, li_Green, 0)

end function

public subroutine wf_resizemap ();// This function resizes the map

iu_GMap.Width = This.WorkspaceWidth( ) - Tab_Main.X - Tab_Main.Width
iu_GMap.Height = This.WorkspaceHeight( ) 
This.wf_SetHeightWidth(iu_GMap)
end subroutine

private subroutine wf_initmap ();//get Google Maps API Key from web.config

String ls_Path

OpenUserObject(iu_GMap, Tab_Main.X + Tab_Main.Width, 0)
wf_ResizeMap()
iu_GMap.Object.Silent = True

ls_Path = Trim(uo_global.gs_Wizard_Path)
If Right(ls_Path, 1) <> "\" then ls_Path += "\"

// Load map
iu_GMap.object.Navigate(ls_Path + "Gmap.htm")
iu_GMap.SetFocus()

end subroutine

private function string wf_getvesselinfo (ref datawindow adw_pos, integer ai_row, boolean abool_includename);// This function returns html formatted vessel information for displaying on
// the popup box on the map

String ls_Info
Decimal ldec_Lat, ldec_Long

ldec_Lat = adw_Pos.GetItemNumber(ai_Row, "Lat")
ldec_Long = adw_Pos.GetItemNumber(ai_Row, "Lng")

// Set basic info
ls_Info = "<b>" + adw_Pos.GetItemString(ai_Row, "Vessel_Ref_Nr") + " - " + adw_Pos.GetItemString(ai_Row, "Vessel_Name") + "</b>"

// Append Report info
ls_Info += "<br/><br/><table cellpadding='0' cellspacing='0' style='font-size:8pt'>"
ls_Info += "<tr><td>Voyage Number:&nbsp;&nbsp;</td><td><a href='#" + String(adw_Pos.GetItemNumber(ai_Row, "Vessel_Nr")) + ";" + adw_Pos.GetItemString(ai_Row, "VoyNr") + "'>" + adw_Pos.GetItemString(ai_Row, "FullVoyNr") + "</a></td></tr>"
ls_Info += "<tr><td>Report Type:</td><td>"
Choose Case adw_Pos.GetItemNumber(ai_Row, "Type")
	Case 0 
		ls_Info += "Departure"
	Case 1
		ls_Info += "Noon"
	Case 2
		ls_Info += "Arrival"
End Choose
ls_Info += "<tr><td>UTC:</td><td>" + String(adw_Pos.GetItemDateTime(ai_Row, "UTC"), "HH:mmZ, dd MMM yy") + "</td></tr>"
ls_Info += "<tr><td>Position:</td><td>" + String(abs(int(ldec_Lat)), "00") + "°" + String(mod(abs(ldec_Lat*60), 60), "00.0") + "' "
If ldec_Lat >= 0 then ls_Info += "N" Else ls_Info += "S"
ls_Info += "  " + String( abs(int(ldec_Long)), "000") + "°" + string(mod(abs(ldec_Long*60), 60), "00.0") + "' "
If ldec_Long >= 0 then ls_Info += "E" Else ls_Info += "W"
ls_Info += "</td></tr>"
If adw_Pos.GetItemNumber(ai_Row, "Type") = 0 then
	ls_Info += "<tr><td>Dep. Port:</td><td>"
Else
	ls_Info += "<tr><td>Destination:</td><td>"
End If
ls_Info += adw_Pos.GetItemString(ai_Row, "Port_N")
If adw_Pos.GetItemNumber(ai_Row, "Type") > 0 then
	ls_Info += "<tr><td>ETA (LT):</td><td>" + String(adw_Pos.GetItemDateTime(ai_Row, "ETA"), "HH:mm, dd MMM yy")
End If
ls_Info += "</td></tr></table>"

// Set font
ls_Info = "<span style='font-family:Arial;font-size:10pt'>" + ls_Info + "</span>"

Return ls_Info
end function

public subroutine wf_addhistposition (ref datawindow adw_pos, integer ai_row);/********************************************************************
   wf_addhistposition
   <DESC>	This function adds a single marker on a map along with the info box</DESC>
   <RETURN>	None	</RETURN>
   <ACCESS>	Public </ACCESS>
   <ARGS>	adw_pos: Datawindow that holds the positions and info
            ai_row: Which row to use in datawindow	</ARGS>
   <USAGE>	
		You must pass a datawindow that has the "d_sq_tb_reporthistory" object
		assigned and the row to display.
		
		The function collects all information into a HTML formatted string and passes
		it to the GMap object to add the marker.
		
	</USAGE>
********************************************************************/


String ls_Info
Decimal ldec_Lat, ldec_Long
String ls_Vsl
ldec_Lat = adw_Pos.GetItemNumber(ai_Row, "Lat")
ldec_Long = adw_Pos.GetItemNumber(ai_Row, "Lng")

// Set basic info
ls_Vsl = Tab_Main.tabpage_2.dw_OneVsl.GetItemString(Tab_Main.tabpage_2.dw_OneVsl.GetSelectedRow(0), "Vessel_Ref_Nr") + " - " + Tab_Main.tabpage_2.dw_OneVsl.GetItemString(Tab_Main.tabpage_2.dw_OneVsl.GetSelectedRow(0), "Vessel_Name")
ls_Info = "<b>" + ls_Vsl  + "</b>"

ls_Info += "<br/><small>"
ls_Info += "<br/><table cellpadding='0' cellspacing='0' style='font-size:8pt'>"
ls_Info += "<tr><td>Voyage Number:&nbsp;&nbsp;</td><td>" + adw_Pos.GetItemString(ai_Row, "FullVoyNr") + "</td></tr>"
ls_Info += "<tr><td>Report Type:</td><td>"
Choose Case adw_Pos.GetItemNumber(ai_Row, "Type")
	Case 0 
		ls_Info += "Departure"
	Case 1
		ls_Info += "Noon"
	Case 2
		ls_Info += "Arrival"
End Choose
ls_Info += "<tr><td>UTC:</td><td>" + String(adw_Pos.GetItemDateTime(ai_Row, "UTC"), "HH:mmZ, dd MMM yy") + "</td></tr>"
ls_Info += "<tr><td>Position:</td><td>" + String(abs(int(ldec_Lat)), "00") + "°" + String(mod(abs(ldec_Lat*60), 60), "00.0") + "' "
If ldec_Lat >= 0 then ls_Info += "N" Else ls_Info += "S"
ls_Info += "  " + String( abs(int(ldec_Long)), "000") + "°" + string(mod(abs(ldec_Long*60), 60), "00.0") + "' "
If ldec_Long >= 0 then ls_Info += "E" Else ls_Info += "W"
ls_Info += "</td></tr>"
If adw_Pos.GetItemNumber(ai_Row, "Type") = 0 then
	ls_Info += "<tr><td>Dep. Port:</td><td>"
Else
	ls_Info += "<tr><td>Destination:</td><td>"
End If
ls_Info += adw_Pos.GetItemString(ai_Row, "Port_N")
If adw_Pos.GetItemNumber(ai_Row, "Type") > 0 then
	ls_Info += "<tr><td>ETA (LT):</td><td>" + String(adw_Pos.GetItemDateTime(ai_Row, "ETA"), "HH:mm, dd MMM yy")
End If	
ls_Info += "</td></tr></table>"

// Set font
ls_Info = "<span style='font-family:Arial;font-size:10pt'>" + ls_Info + "</span>"

// Add position and store marker
adw_Pos.SetItem(ai_row, "Marker", iu_GMap.of_AddMarker(adw_Pos.GetItemNumber(ai_row, "lat"),adw_Pos.GetItemNumber(ai_row, "lng"),ls_Vsl, ls_Info, wf_GetAgeColor(adw_Pos.GetItemNumber(ai_row, "posage"))))
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_vesselpos
	
   <OBJECT>
		This is the main window for the Vessel Position / Google maps functionality
		
	</OBJECT>
	
   <USAGE>
	
		The window uses the u_googlemap_activex control to display google maps.
		Three tabs are contain the sections used to control and display the vessels
		on the maps.
		
	</USAGE>

<HISTORY> 
   Date	   	CR-Ref	Author	Comments
   20-06-2010 	CR1517	CONASW	First Version
	05-08-2014 	CR3708	AGL027	F1 help application coverage - change of ancestor
	28/08/14		CR3781	CCY018	The window title match with the text of a menu item
</HISTORY>    
********************************************************************/
end subroutine

public subroutine wf_centerposition (decimal ad_lat, decimal ad_long, integer ai_zoom);
// This function centers the map on a position and applies zoom if specified

If ai_Zoom > 0 then iu_GMap.of_ZoomTo(ai_Zoom)
iu_GMap.of_Moveto(ad_Lat, ad_Long)
		
	


end subroutine

on w_vesselpos.create
int iCurrent
call super::create
this.tab_main=create tab_main
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_main
end on

on w_vesselpos.destroy
call super::destroy
destroy(this.tab_main)
end on

event open;call super::open;// Init all DW and controls
Tab_Main.tabpage_1.dw_Vsl.SetTransObject(SQLCA)
Tab_Main.tabpage_1.dw_Vsl.ShareData(Tab_Main.tabpage_2.dw_OneVsl)
Tab_Main.tabpage_2.dw_Pos.SetTransObject(SQLCA)
Tab_Main.tabpage_3.dw_Ports.SetTransObject(SQLCA)
Tab_Main.tabpage_3.uo_Search.st_Search.Text = "Select Ports:"
Tab_Main.tabpage_3.uo_Search.st_Search.Weight = 400
Tab_Main.tabpage_3.ddlb_age.SelectItem(3)
Tab_Main.tabpage_3.uo_Search.of_Initialize(Tab_Main.tabpage_3.dw_Ports, "port_code+'#'+port_n+'#'+area_area_name")
Tab_Main.tabpage_3.dw_VslNear.SetTransObject(SQLCA)

// Load DW styles
n_service_manager 	ln_serviceMgr
n_dw_style_service   ln_style
ln_serviceMgr.of_loadservice( ln_style, "n_dw_style_service")
ln_style.of_dwlistformater(Tab_Main.tabpage_1.dw_Vsl, true)
ln_style.of_dwlistformater(Tab_Main.tabpage_2.dw_OneVsl, true)
ln_style.of_dwlistformater(Tab_Main.tabpage_2.dw_Pos, true)
ln_style.of_dwlistformater(Tab_Main.tabpage_3.dw_Ports, true)
ln_style.of_dwlistformater(Tab_Main.tabpage_3.dw_VslNear, true)

// Do retrieves
If Tab_Main.tabpage_1.dw_Vsl.Retrieve(uo_Global.GetUserID()) <= 0 Then
	Post Messagebox("No Vessels", "There are no vessels with last reported positions less than 30 days old!")
Else
	Tab_Main.tabpage_3.dw_VslNear.Object.Data = Tab_Main.tabpage_1.dw_Vsl.Object.Data	
End If
Tab_Main.tabpage_3.dw_Ports.post Retrieve()
Tab_Main.tabpage_3.dw_VslNear.Post SetFilter("InRange=1")
Tab_Main.tabpage_3.dw_VslNear.Post Filter()
Post wf_InitMap()

// Log usage
n_object_usage_log ln_use_log
ln_use_log.uf_log_object("Vessel Positions")


/* IMPORTANT NOTE  !!!!

This window must find GMap.htm to work properly. It must be present in the "wizard" folder

*/
end event

event resize;// This handles the resizing of the controls

// First check minimum width and height of the window
If newheight < 2740 then height = 2740
If newwidth < 3000 then width = 3000

// Resize map
If IsValid(iu_GMap) then wf_ResizeMap()

// Resize tab control
tab_main.Height = This.WorkspaceHeight() - tab_Main.Y * 2

// Resize controls on first tab
tab_main.tabpage_1.dw_vsl.Height = tab_main.tabpage_1.Height - tab_main.tabpage_1.dw_Vsl.Y - tab_main.tabpage_1.cb_all.height - tab_main.y
tab_main.tabpage_1.cb_all.y = tab_main.tabpage_1.dw_vsl.y + tab_main.tabpage_1.dw_vsl.height
tab_main.tabpage_1.cb_clear.y = tab_main.tabpage_1.cb_all.y

// Resize controls on second tab
tab_main.tabpage_2.dw_pos.Height = tab_main.tabpage_2.Height - tab_main.tabpage_2.dw_pos.Y - tab_main.tabpage_2.cb_allpos.height - tab_main.y
tab_main.tabpage_2.cb_allpos.y = tab_main.tabpage_2.dw_pos.y + tab_main.tabpage_2.dw_pos.height
tab_main.tabpage_2.cb_clearpos.y = tab_main.tabpage_2.cb_allpos.y

// Resize controls on third tab
tab_main.tabpage_3.dw_vslnear.Height = tab_main.tabpage_3.Height - tab_main.tabpage_3.dw_VslNear.Y - tab_main.y

end event

type st_hidemenubar from w_tramos_container`st_hidemenubar within w_vesselpos
end type

type tab_main from tab within w_vesselpos
integer x = 18
integer y = 16
integer width = 1079
integer height = 2592
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_main.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_main.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;
If Not IsValid(iu_GMap) Then Return

Choose Case newindex
	Case 1
		tab_main.tabpage_1.cb_Clear.event clicked( )
	Case 2
		tab_main.tabpage_2.cb_ClearPos.event clicked( )
	Case 3
		tab_main.tabpage_3.uo_Search.sle_Search.SetFocus()
		tab_main.tabpage_3.uo_Search.cb_Clear.event clicked( )
		tab_main.tabpage_3.st_Result.Text = ""
		tab_main.tabpage_3.dw_VslNear.SetFilter("InRange=-1")		
		tab_main.tabpage_3.dw_VslNear.Filter()
End Choose
end event

type tabpage_1 from userobject within tab_main
integer x = 18
integer y = 104
integer width = 1042
integer height = 2472
long backcolor = 67108864
string text = "All Vessels"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_clear cb_clear
cb_all cb_all
st_1 st_1
dw_vsl dw_vsl
end type

on tabpage_1.create
this.cb_clear=create cb_clear
this.cb_all=create cb_all
this.st_1=create st_1
this.dw_vsl=create dw_vsl
this.Control[]={this.cb_clear,&
this.cb_all,&
this.st_1,&
this.dw_vsl}
end on

on tabpage_1.destroy
destroy(this.cb_clear)
destroy(this.cb_all)
destroy(this.st_1)
destroy(this.dw_vsl)
end on

type cb_clear from commandbutton within tabpage_1
integer x = 311
integer y = 2184
integer width = 288
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;
iu_GMap.of_ClearMap()

dw_Vsl.SelectRow(0, False)
end event

type cb_all from commandbutton within tabpage_1
integer x = 18
integer y = 2184
integer width = 288
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
If dw_Vsl.RowCount() > 20 then
	If MessageBox("Confirm Select All", "Selecting all will cause a large number of vessels to displayed in the map~n~nAre you sure you want to do this?", Question!, YesNo!) = 2 then Return
End If

Integer li_Loop
String ls_Info

SetPointer(HourGlass!)

dw_Vsl.SelectRow(0, True)

// Add all positions on map	
For li_Loop = dw_Vsl.RowCount() to 1 Step -1
	iu_GMap.of_AddMarker(dw_Vsl.GetItemNumber(li_Loop, "Lat"),dw_Vsl.GetItemNumber(li_Loop, "Lng"), dw_Vsl.GetItemString(li_Loop, "Vessel_Ref_Nr") + " - " + dw_Vsl.GetItemString(li_Loop, "Vessel_Name") , wf_GetVesselInfo(dw_vsl, li_Loop, True), wf_GetAgeColor(0))
Next

ib_MapCleared = False
end event

type st_1 from statictext within tabpage_1
integer x = 18
integer y = 24
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Vessels:"
boolean focusrectangle = false
end type

type dw_vsl from datawindow within tabpage_1
integer x = 18
integer y = 88
integer width = 1006
integer height = 2096
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_selectvsl"
richtexttoolbaractivation richtexttoolbaractivation = richtexttoolbaractivationnever!
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
// Check if sorting
If row=0 and dwo.type = "text" then
	If dwo.tag>"" then
		String ls_Sort
		ls_sort = dwo.Tag
		This.SetSort(ls_sort)
		This.Sort()
		This.GroupCalc( )
		If Right(ls_sort,1) = "A" Then 
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "D")
		Else
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "A")
		End if
		dwo.Tag = ls_sort
	End If
	Return
End if

If row = 0 then Return

If Not This.IsSelected(row) then 

	This.SelectRow(row, True)
	
	// Add position on map
	This.SetItem(row, "Marker", iu_GMap.of_AddMarker(This.GetItemNumber(row, "Lat"),This.GetItemNumber(row, "Lng"),This.GetItemString(row, "Vessel_Ref_Nr") + " - " + This.GetItemString(row, "Vessel_Name") , wf_GetVesselInfo(dw_vsl, row, True), wf_GetAgeColor(This.GetItemNumber(row, "PosAge"))))
	iu_GMap.of_Zoomto(4)
	iu_GMap.of_MoveTo(This.GetItemNumber(row, "Lat"), This.GetItemNumber(row, "Lng"))
	ib_MapCleared = False
Else
	// Remove position from map
	This.SelectRow(row, False)
	iu_GMap.of_RemoveMarker(This.GetItemNumber(row, "Marker"))
End If

end event

event doubleclicked;//
//If row = 0 then Return
//
//cb_clear.event clicked( )
//
//tab_main.selecttab(2)
//
//tab_main.tabpage_2.dw_OneVsl.SelectRow(0, False)
//tab_main.tabpage_2.dw_OneVsl.SelectRow(row, True)
//tab_main.tabpage_2.dw_OneVsl.ScrollToRow(row)
//
//If Not ibool_MapCleared then
//	GMapControl_ax.of_ClearMap()
//	ibool_MapCleared = True
//End If
//
//tab_main.tabpage_2.dw_Pos.Retrieve(This.GetItemNumber(row, "Vessel_ID"))
end event

type tabpage_2 from userobject within tab_main
integer x = 18
integer y = 104
integer width = 1042
integer height = 2472
long backcolor = 67108864
string text = "Vessel History"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_clearpos cb_clearpos
cb_allpos cb_allpos
st_5 st_5
dw_pos dw_pos
st_4 st_4
st_3 st_3
dw_onevsl dw_onevsl
end type

on tabpage_2.create
this.cb_clearpos=create cb_clearpos
this.cb_allpos=create cb_allpos
this.st_5=create st_5
this.dw_pos=create dw_pos
this.st_4=create st_4
this.st_3=create st_3
this.dw_onevsl=create dw_onevsl
this.Control[]={this.cb_clearpos,&
this.cb_allpos,&
this.st_5,&
this.dw_pos,&
this.st_4,&
this.st_3,&
this.dw_onevsl}
end on

on tabpage_2.destroy
destroy(this.cb_clearpos)
destroy(this.cb_allpos)
destroy(this.st_5)
destroy(this.dw_pos)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_onevsl)
end on

type cb_clearpos from commandbutton within tabpage_2
integer x = 311
integer y = 2104
integer width = 288
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;
iu_GMap.of_ClearMap()

dw_Pos.SelectRow(0, False)
end event

type cb_allpos from commandbutton within tabpage_2
integer x = 18
integer y = 2104
integer width = 288
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
If dw_Pos.RowCount() > 20 then
	If MessageBox("Confirm Select All", "Selecting all will cause a large number of positions to displayed in the map~n~nAre you sure you want to do this?", Question!, YesNo!) = 2 then Return
End If

Integer li_Loop
String ls_Info

SetPointer(HourGlass!)

// Add positions on map
For li_Loop = 1 to dw_Pos.RowCount()
	dw_Pos.SelectRow(li_Loop, True)
	wf_AddHistPosition(dw_Pos, li_Loop)
Next

If dw_Pos.RowCount() > 0 then wf_CenterPosition(dw_Pos.GetItemNumber(1, "Lat"),dw_Pos.GetItemNumber(1, "Lng"), 0)

ib_MapCleared = False
end event

type st_5 from statictext within tabpage_2
integer x = 549
integer y = 936
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "(Last one month)"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_pos from datawindow within tabpage_2
integer x = 18
integer y = 1000
integer width = 1006
integer height = 1104
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_reporthistory"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If row <= 0 then return

If Not This.IsSelected(row) then 
	wf_AddHistPosition(dw_Pos, row)
	iu_GMap.of_MoveTo(This.GetItemNumber(row, "lat"),This.GetItemNumber(row, "lng"))	
	ib_MapCleared = False
	This.SelectRow(row, True)
Else
	// remove marker
	iu_GMap.of_RemoveMarker(This.GetItemNumber(row, "Marker"))	
	This.SelectRow(row, False)
End If



end event

event retrieveend;If rowcount <= 0 then Return

wf_AddHistPosition(dw_Pos, 1)
iu_GMap.of_MoveTo(This.GetItemNumber(1, "lat"),This.GetItemNumber(1, "lng"))	
ib_MapCleared = False
This.SelectRow(1, True)
	
	
end event

type st_4 from statictext within tabpage_2
integer x = 18
integer y = 936
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Position History:"
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_2
integer x = 18
integer y = 24
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Vessel:"
boolean focusrectangle = false
end type

type dw_onevsl from datawindow within tabpage_2
integer x = 18
integer y = 88
integer width = 1006
integer height = 800
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_selectvsl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
// Check if sorting
If row=0 and dwo.type = "text" then
	If dwo.tag>"" then
		String ls_Sort
		ls_sort = dwo.Tag
		This.SetSort(ls_sort)
		This.Sort()
		This.GroupCalc( )
		If Right(ls_sort,1) = "A" Then 
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "D")
		Else
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "A")
		End if
		dwo.Tag = ls_sort
	End If
	Return
End if

If row = 0 then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

iu_GMap.of_ClearMap()

dw_Pos.Retrieve(This.GetItemNumber(row, "Vessel_ID"))
end event

type tabpage_3 from userobject within tab_main
integer x = 18
integer y = 104
integer width = 1042
integer height = 2472
long backcolor = 67108864
string text = "Near Port"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cbx_circle cbx_circle
cb_clearports cb_clearports
cb_area cb_area
cbx_dest cbx_dest
st_result st_result
dw_vslnear dw_vslnear
st_10 st_10
st_9 st_9
st_6 st_6
st_7 st_7
st_8 st_8
cb_find cb_find
uo_search uo_search
ddlb_age ddlb_age
sle_dist sle_dist
dw_ports dw_ports
ln_1 ln_1
end type

on tabpage_3.create
this.cbx_circle=create cbx_circle
this.cb_clearports=create cb_clearports
this.cb_area=create cb_area
this.cbx_dest=create cbx_dest
this.st_result=create st_result
this.dw_vslnear=create dw_vslnear
this.st_10=create st_10
this.st_9=create st_9
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.cb_find=create cb_find
this.uo_search=create uo_search
this.ddlb_age=create ddlb_age
this.sle_dist=create sle_dist
this.dw_ports=create dw_ports
this.ln_1=create ln_1
this.Control[]={this.cbx_circle,&
this.cb_clearports,&
this.cb_area,&
this.cbx_dest,&
this.st_result,&
this.dw_vslnear,&
this.st_10,&
this.st_9,&
this.st_6,&
this.st_7,&
this.st_8,&
this.cb_find,&
this.uo_search,&
this.ddlb_age,&
this.sle_dist,&
this.dw_ports,&
this.ln_1}
end on

on tabpage_3.destroy
destroy(this.cbx_circle)
destroy(this.cb_clearports)
destroy(this.cb_area)
destroy(this.cbx_dest)
destroy(this.st_result)
destroy(this.dw_vslnear)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.cb_find)
destroy(this.uo_search)
destroy(this.ddlb_age)
destroy(this.sle_dist)
destroy(this.dw_ports)
destroy(this.ln_1)
end on

type cbx_circle from checkbox within tabpage_3
integer x = 18
integer y = 1560
integer width = 663
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display Distance Circle:"
boolean checked = true
boolean lefttext = true
end type

type cb_clearports from commandbutton within tabpage_3
integer x = 695
integer y = 1168
integer width = 329
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;
dw_Ports.SelectRow(0, False)

dw_VslNear.SetFilter("InRange=-1")
dw_VslNear.Filter()
st_Result.Text = ""

iu_GMap.of_ClearMap()

end event

type cb_area from commandbutton within tabpage_3
integer x = 366
integer y = 1168
integer width = 329
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
Integer li_Loop
For li_Loop = 1 to dw_Ports.RowCount()
	dw_Ports.SelectRow(li_Loop, True)
Next

end event

type cbx_dest from checkbox within tabpage_3
integer x = 18
integer y = 1480
integer width = 663
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "On The Way To:"
boolean lefttext = true
end type

type st_result from statictext within tabpage_3
integer x = 384
integer y = 1816
integer width = 640
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_vslnear from datawindow within tabpage_3
integer x = 18
integer y = 1880
integer width = 1006
integer height = 432
integer taborder = 70
string title = "none"
string dataobject = "d_sq_tb_selectvsl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_OldRow

If row=0 then Return

// If previous selection then hide infowindow
li_OldRow = This.GetSelectedrow(0)
If li_OldRow > 0 then 	
	iu_GMap.of_CloseInfoWindow(li_OldRow - 1)
End If

// Select row
This.SelectRow(li_OldRow, False)
This.SelectRow(row, True)

// Show info window
iu_GMap.of_OpenInfoWindow(row - 1)

// Center position on map
iu_GMap.of_ZoomTo(5)
iu_GMap.of_MoveTo(This.GetItemNumber(row, "lat"),This.GetItemNumber(row, "lng"))

end event

type st_10 from statictext within tabpage_3
integer x = 18
integer y = 1816
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Search Results:"
boolean focusrectangle = false
end type

type st_9 from statictext within tabpage_3
integer x = 896
integer y = 1400
integer width = 142
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "Days"
boolean focusrectangle = false
end type

type st_6 from statictext within tabpage_3
integer x = 896
integer y = 1304
integer width = 91
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "nm"
boolean focusrectangle = false
end type

type st_7 from statictext within tabpage_3
integer x = 18
integer y = 1304
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Distance from Port:"
boolean focusrectangle = false
end type

type st_8 from statictext within tabpage_3
integer x = 18
integer y = 1400
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Max Position Age:"
boolean focusrectangle = false
end type

type cb_find from commandbutton within tabpage_3
integer x = 183
integer y = 1672
integer width = 695
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find Vessels"
end type

event clicked;Integer li_PortRow, li_Loop
Decimal ldec_Dist
String ls_Dest

// Count number of ports selected and warn
li_Loop = 0
li_PortRow = 0
Do
	li_PortRow = tab_main.tabpage_3.dw_Ports.GetSelectedRow(li_PortRow)
	If li_PortRow > 0 then li_Loop ++
Loop Until li_PortRow = 0
// Nothing selected
If li_Loop = 0 then 
	Messagebox("No Selection", "Please select a port!", Exclamation!)
	Return
End If
If li_Loop > 20 then // Too many
	Messagebox("Too Many Ports", "You can select a maximum of 20 ports only!", Exclamation!)
	Return
End If
If li_Loop > 10 then // Warn if more than 10
	If Messagebox("Many Ports", "You have selected more than 10 ports. This may take a while. Are you sure you want to continue?", Question!, YesNo!) = 2 then Return
End If

// Check distance
sle_Dist.Text = Trim(sle_Dist.Text, True)
If Not IsNumber(sle_Dist.Text) then
	Messagebox("Invalid Distance", "The distance to the port must be numeric!", Exclamation!)
	Return
End If
ldec_Dist = Dec(sle_dist.Text)
If ldec_Dist<5 or ldec_Dist>6000 then 
	Messagebox("Invalid Distance", "The distance from the port must be between 5 miles and 6,000 miles.", Exclamation!)
	Return
End If

// Get first port
li_PortRow = tab_main.tabpage_3.dw_Ports.GetSelectedRow(0)

Double ldb_Lat, ldb_Long

SetPointer(HourGlass!)

// Clear result box and map
dw_VslNear.SetFilter("InRange=-1")
dw_VslNear.Filter()	
iu_GMap.of_ClearMap()

// Init distance calculator
n_Distance ln_Dist
ln_Dist = Create n_Distance

// Get All vessels
dw_VslNear.SetRedraw(False)
dw_VslNear.SetFilter("")
dw_VslNear.Filter()

// Clear flags
For li_Loop = 1 to dw_VslNear.RowCount()
	dw_VslNear.SetItem(li_Loop, "InRange", 0)
Next 

// Loop thru all selected ports
Do While li_PortRow > 0 
	
	// Get port position
	ldb_Lat = dw_Ports.GetItemNumber(li_PortRow,"Latitude")
	ldb_Long = dw_Ports.GetItemNumber(li_PortRow,"Longitude")

	// Draw circle around port
	If cbx_Circle.Checked then iu_GMap.of_AddCircle(ldb_Lat, ldb_Long, ldec_Dist)

	// Get Port Code
   If cbx_Dest.Checked then ls_Dest = dw_Ports.GetItemString(li_PortRow,"Port_Code") Else ls_Dest = "X"

	// Loop thru DW to find vessels that match criteria
	For li_Loop = 1 to dw_VslNear.RowCount()
		If dw_VslNear.GetItemNumber(li_Loop, "PosAge") <= Integer(ddlb_Age.Text) Then
			If ls_Dest = "X" or (dw_Ports.GetItemString(li_PortRow,"Port_Code") = dw_VslNear.GetItemString(li_Loop, "Port") and dw_VslNear.GetItemNumber(li_Loop, "Type")>0) Then
				If ln_Dist.of_Getdistance(ldb_Lat, ldb_Long, dw_VslNear.GetItemNumber(li_Loop, "Lat") , dw_VslNear.GetItemNumber(li_Loop, "Lng")) <= ldec_Dist Then dw_VslNear.SetItem(li_Loop, "InRange", 1)
			End If
		End If
	Next
	
	// Find next port
	li_PortRow = dw_Ports.GetSelectedRow(li_PortRow)
	
Loop

dw_VslNear.SetFilter("InRange=1")
dw_VslNear.Filter()
dw_VslNear.SetRedraw(True)

Destroy ln_Dist

li_Loop = tab_main.tabpage_3.dw_VslNear.RowCount()

If li_Loop = 0 then 
	st_Result.Text = "No vessels found"
	Messagebox("No Vessels Found", "No vessels were found matching the specified criteria. Try increasing the distance.")
Else 
	st_Result.Text = "Vessels Found - " + String(li_Loop)
	dw_VslNear.Sort()
	// Add positions on map	
	For li_Loop = 1 to tab_main.tabpage_3.dw_VslNear.RowCount()
		iu_GMap.of_Addmarker(dw_VslNear.GetItemNumber(li_Loop, "lat"),dw_VslNear.GetItemNumber(li_Loop, "lng"), dw_VslNear.GetItemString(li_Loop, "Vessel_Ref_Nr")+ " - " + dw_VslNear.GetItemString(li_Loop, "Vessel_Name"), wf_GetVesselInfo(dw_VslNear, li_Loop, True), wf_GetAgeColor(dw_VslNear.GetItemNumber(li_Loop, "PosAge")))
	Next
	ib_MapCleared = False
End If

	
end event

type uo_search from u_searchbox within tabpage_3
integer x = 18
integer y = 24
integer width = 1006
integer taborder = 30
end type

on uo_search.destroy
call u_searchbox::destroy
end on

event ue_keypress;call super::ue_keypress;
dw_Ports.GroupCalc()
end event

type ddlb_age from dropdownlistbox within tabpage_3
integer x = 622
integer y = 1384
integer width = 256
integer height = 624
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"1","2","3","5","10","20","30"}
borderstyle borderstyle = stylelowered!
end type

type sle_dist from singlelineedit within tabpage_3
integer x = 622
integer y = 1288
integer width = 256
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "600"
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type dw_ports from datawindow within tabpage_3
integer x = 18
integer y = 184
integer width = 1006
integer height = 984
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_abcports"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
// Check if sorting
If row=0 and dwo.type = "text" then
	If dwo.tag>"" then
		String ls_Sort
		ls_sort = dwo.Tag
		This.SetSort(ls_sort)
		This.Sort()
		This.GroupCalc()
		If Right(ls_sort,1) = "A" Then 
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "D")
		Else
			ls_sort = Replace(ls_sort, Len(ls_sort),1, "A")
		End if
		dwo.Tag = ls_sort
	End If
	Return
End if

If row = 0 then Return

If dwo.name = "p_locate" then
	iu_GMap.of_ZoomTo(5)
	iu_GMap.of_MoveTo(This.GetItemNumber(row, "Latitude"),This.GetItemNumber(row, "Longitude"))
	Return
End If

This.SelectRow(row, Not This.IsSelected(row))

If Not ib_MapCleared then
	dw_VslNear.SetFilter("InRange=-1")
	dw_VslNear.Filter()
	st_Result.Text = ""
	iu_GMap.of_ClearMap( )
	ib_MapCleared = True
End If

end event

type ln_1 from line within tabpage_3
integer linethickness = 4
integer beginx = 18
integer beginy = 1800
integer endx = 1024
integer endy = 1800
end type

