$PBExportHeader$w_browser.srw
forward
global type w_browser from window
end type
type hpb_prg from hprogressbar within w_browser
end type
type cb_inv from commandbutton within w_browser
end type
type cb_none from commandbutton within w_browser
end type
type cb_all from commandbutton within w_browser
end type
type st_select from statictext within w_browser
end type
type dw_expraw from datawindow within w_browser
end type
type cbx_multi from checkbox within w_browser
end type
type dw_expexcel from datawindow within w_browser
end type
type cb_voy from commandbutton within w_browser
end type
type cb_vsl from commandbutton within w_browser
end type
type dw_voyages from datawindow within w_browser
end type
type dw_vsl from datawindow within w_browser
end type
end forward

global type w_browser from window
integer x = 101
integer y = 100
integer width = 4891
integer height = 2168
boolean titlebar = true
string title = "Voyage Browser"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "DataWindow5!"
boolean toolbarvisible = false
boolean clientedge = true
boolean center = true
event ue_vslmenuclick ( integer ai_menusel )
event ue_voymenuclick ( integer ai_menusel )
hpb_prg hpb_prg
cb_inv cb_inv
cb_none cb_none
cb_all cb_all
st_select st_select
dw_expraw dw_expraw
cbx_multi cbx_multi
dw_expexcel dw_expexcel
cb_voy cb_voy
cb_vsl cb_vsl
dw_voyages dw_voyages
dw_vsl dw_vsl
end type
global w_browser w_browser

type variables
m_Vslmenu VslMenu
m_Voymenu VoyMenu

string is_vslfilter, is_pc

long il_VoyID, il_VslID, il_Last_Row_Clicked

window iw_windowlist[]
Integer ii_wincount

boolean ibool_multiselect

end variables

forward prototypes
public function window wf_openwindow (byte ab_wintype, long al_id)
public function long wf_getcurrentvesselid ()
private subroutine wf_recalculate ()
public subroutine wf_getbunkerprices ()
end prototypes

event ue_vslmenuclick(integer ai_menusel);string ls_filter
decimal ld_auxcon

choose case ai_menusel
	case 0
		g_parameters.Vesselid = il_vslid
		g_parameters.selection = 1  // Vessel selection
		opensheet(w_summary, w_main, 0, Original!)
	case 1	
		g_parameters.Vesselid = il_vslid
		open(w_wrr)
	case 2
		If g_userinfo.Access = 1 then 
			Messagebox("Access Denied", "You do not have access to create a vessel identification code.", Exclamation!)
			Return
		End If
		SELECT TPERF_AUXCON INTO :ld_AuxCon FROM VESSELS WHERE VESSEL_ID = :il_VslID;
		If SQLCA.SQLcode <> 0 then
			MessageBox ("DB Error", SQLCA.Sqlerrtext)
			Return
		End if
		Commit;
		If ld_AuxCon = 0 then
			MessageBox ("Warranted Setting Incomplete", "The warranted table for the vessel must be filled in before a vessel ID code can be issued.", Exclamation!)		
			Return
		End If
		g_parameters.Vesselid = il_vslid
		open(w_vslcode)
//	case 3      **** Not used ****
//	case 4      **** not used ****
	case 5
		vslmenu.m_activeinactivevessels.checked=false
		vslmenu.m_activevesselsonly.checked=true
	case 6
		vslmenu.m_activeinactivevessels.checked=true		
		vslmenu.m_activevesselsonly.checked=false
	case 7
		vslmenu.m_tperfonly.checked = not vslmenu.m_tperfonly.checked
	case 8
		dw_vsl.retrieve( )
	case 10
		g_parameters.selection = 0
		Open(w_ConsReport)
	case 11
		g_parameters.selection = 1
		Open(w_ConsReport)		
	case 12  // active alerts report
		g_parameters.Vesselid = il_vslid
		Open(w_VslActiveAlerts)
	case 13  // Transfer voyages
		If g_userinfo.Access = 1 then 
			Messagebox("Access Denied", "You do not have access to transfer voyage legs.", Exclamation!)
			Return
		End If
		g_parameters.Vesselid = il_vslid
		Open(w_Transfer)
		If g_Parameters.vesselid > 0 then dw_Voyages.Retrieve(g_Parameters.VesselID)
End Choose

If ai_menusel>2 and ai_menusel<8 then 
	
	SetPointer(HourGlass!)
	
	ls_Filter = ""
	If vslmenu.m_activevesselsonly.checked then ls_filter = "(VESSEL_ACTIVE = 1)"
	if vslmenu.m_tperfonly.checked then 
		If ls_Filter > "" then ls_filter += " AND "
		ls_Filter += "(NumVoy>0)" 
	End If
	
 	dw_vsl.SetFilter(ls_filter)
	dw_vsl.filter( )
	if dw_vsl.rowcount( ) = 0 then 
		vslmenu.m_vsldet.Enabled = false 
		vslmenu.m_vslid.Enabled = false
		vslmenu.m_warrantedsettings.Enabled = false
	else 
		vslmenu.m_vsldet.Enabled = true
		vslmenu.m_vslid.Enabled = true
		vslmenu.m_warrantedsettings.Enabled = true
		dw_vsl.selectrow( 0, False)
		dw_vsl.selectrow( dw_vsl.Getrow( ), True)
		dw_vsl.event rowfocuschanged( dw_vsl.GetRow())
	End If
End if
end event

event ue_voymenuclick(integer ai_menusel);Integer li_Ret
String ls_VoyID
Long ll_VoyID[]
struct_voylist lstruct_List

If cbx_Multi.Checked then
	li_Ret = dw_Voyages.GetSelectedRow(0)
	ls_VoyID = ""
	If li_Ret > 0 then
		Do 
			ll_VoyID[UpperBound(ll_VoyID)+1] = dw_Voyages.GetItemNumber(li_Ret, "Voy_ID")
			ls_VoyID += "#" + String(dw_Voyages.GetItemNumber(li_Ret, "Voy_ID")) + "#"
			li_Ret = dw_Voyages.GetSelectedRow(li_Ret)
		Loop Until li_Ret = 0
	Else
		MessageBox("No Selection", "Please select one or more voyages first!", Exclamation!)
		Return
	End If
Else
	ll_VoyID[1] = dw_Voyages.GetItemNumber(dw_Voyages.GetRow(), "Voy_ID")
End If

Choose case ai_menusel
	case 1  // View Voyage Summary
		If cbx_Multi.Checked then
			g_parameters.VesselID = il_vslid
			g_parameters.ParamString = ls_VoyID
			g_parameters.Selection = 3  // Multi-Voy selection
			opensheet(w_summary, w_main, 0, Original!)
		Else
			g_parameters.VesselID = il_vslid
			g_parameters.VoyageID = il_voyid
			g_parameters.Selection = 2  // Voy selection
			opensheet(w_summary, w_main, 0, Original!)			
		End If
	case 2  // View Full Details
		g_parameters.VoyageID = il_voyid
		opensheet(w_voydetail, w_main, 0, Original!)
	case 3  // Excel Export
			dw_expexcel.SetTransObject(SQLCA)
			li_Ret = dw_expexcel.Retrieve(ll_VoyID)
			If li_Ret = 0 then
				Messagebox("Export Error", "No rows to export!", Exclamation!)
				Return
			End If
			dw_expexcel.SaveAs("", Excel8!, True)			
	case 4  // Edit Voyage		
		g_parameters.VoyageID = il_voyid
		open(w_voyedit)
		If g_parameters.Voyageid >= 0 then  // Voyage Edited
			dw_voyages.Retrieve( il_vslid)
			dw_voyages.Selectrow(0, False)
			li_Ret = dw_voyages.find ("Voy_ID = " + string(g_parameters.VoyageID), dw_voyages.rowcount( ), 0 )
			If li_Ret > 0 then 
				dw_voyages.selectrow( li_Ret, True)
				dw_Voyages.ScrollToRow(li_Ret)
			else 
				MessageBox ("Unexpected Error", "Voyage ID not found. Please report this error.", Exclamation!)
			End If
			il_voyid = g_parameters.VoyageID
		End if
	case 5  // Delete Voyage
		If g_userinfo.access = 1 then 
			Messagebox("Access Denied", "You do not have access to delete a voyage.", Exclamation!)
			Return
		End If
		
		If MessageBox("Confirm Delete", "The selected voyage will be deleted PERMANENTLY!  Are you absolutely sure?", Question!, YesNo!, 2) = 2 then Return
		
		n_Voyage ln_Voy
		ln_Voy = Create n_Voyage
		
		If ln_Voy.of_DeleteVoyage(il_VoyID) Then
			dw_Voyages.retrieve(il_vslid)
			if dw_Voyages.RowCount( )>0 then
				dw_Voyages.SelectRow( 0, False)
				dw_Voyages.SelectRow( dw_Voyages.RowCount(), True)
				dw_Voyages.ScrollToRow(dw_Voyages.RowCount())
				il_Voyid = dw_Voyages.GetItemNumber(dw_Voyages.RowCount(), "voy_id")
			Else
				cb_Voy.enabled=false
			End if
			MessageBox ("Deleted", "The selected voyage was deleted.", Information!)
			w_back.PostEvent(Timer!)
		Else
			MessageBox ("Delete Failed", "The selected voyage could not be deleted.", Exclamation!)	
		End If
		
		Destroy ln_Voy
		
	Case 6    // Custom export
		lstruct_List.VoyList = ll_VoyID
		OpenWithParm(w_export, lstruct_List)
	Case 7     // Recalculate voyages
		wf_Recalculate()
	Case 8
		wf_GetBunkerPrices()
	Case 9    // Raw export		
		dw_expraw.SetTransObject(SQLCA)
		li_Ret = dw_expraw.Retrieve(ll_VoyID)
		If li_Ret = 0 then
			Messagebox("Export Error", "No rows to export!", Exclamation!)
			Return
		End If
		dw_expraw.SaveAs("", Excel8!, True)	
End Choose

end event

public function window wf_openwindow (byte ab_wintype, long al_id);
Choose Case ab_wintype
	Case 0
		//  Code here to open vessel window
	Case 1
		//  Code here to open voyage window
End Choose		

return this

end function

public function long wf_getcurrentvesselid ();
Return il_VslID
end function

private subroutine wf_recalculate ();// This function recalculates the selected voyages

Integer li_Row = 0, li_Total = 0, li_Fail
n_Wrr l_WrrTable

gnv_Voyage = Create n_Voyage
l_WrrTable = Create n_Wrr

// Get total number of selected rows
Do 
	li_Row = dw_voyages.GetSelectedRow(li_Row)
	If li_Row > 0 then li_Total += 1
Loop Until li_Row = 0

// If more than 5, then show progress bar
If li_Total>5 then
	hpb_prg.Visible = True
	cb_all.Visible = False
	cb_None.Visible = False
	cb_Inv.Visible = False
	cbx_multi.Visible = False	
	hpb_prg.MaxPosition = li_Total
	li_Total = 0
End If

Try
	Do
		li_Row = dw_voyages.GetSelectedRow(li_Row)
		If li_Row > 0 then		
			gnv_Voyage.of_RetrieveVoyage(dw_Voyages.GetItemNumber(li_Row, "voy_id" ), False)
			gnv_Voyage.of_RecalcVoyage(l_WrrTable)	
			If gnv_Voyage.of_UpdateVoyage() = 0 then li_Total += 1 Else li_Fail += 1
		End If
		hpb_Prg.StepIt()
	Loop Until li_Row = 0
Catch (Exception ex)
	Messagebox("Error", "An error occurred while re-calculating.", Exclamation!)
	Destroy l_WrrTable
	Destroy gnv_Voyage
	If li_Fail = 0 then li_Fail = 1
End Try

// If progress bar shown, then hide
If li_Total>5 then
	hpb_prg.Visible = False
	cb_all.Visible = True
	cb_None.Visible = True
	cb_Inv.Visible = True
	cbx_multi.Visible = True
	hpb_prg.MaxPosition = 0
	li_Total = 0
End If

If li_Fail = 0 then
	Post Messagebox("Re-Calculate Success", "The selected voyages were re-calculated successfully!", Information!)
Else
	Post Messagebox("Re-Calculate Update Error", "One or more voyages could not be updated.~n~nTotal Selected: " + String(li_Total) + "   Update Failed: " + String(li_Fail), Exclamation!)	
End If

Destroy l_WrrTable
Destroy gnv_Voyage

end subroutine

public subroutine wf_getbunkerprices ();// This function obtains the bunker prices from Tramos for each voyage leg and updates the prices

Integer li_Row = 0, li_Total, li_Fail

gnv_Voyage = Create n_Voyage

// Get total number of selected rows
Do 
	li_Row = dw_voyages.GetSelectedRow(li_Row)
	If li_Row > 0 then li_Total += 1
Loop Until li_Row = 0

// If more than 5, then show progress bar
If li_Total>5 then
	hpb_prg.Visible = True
	cb_all.Visible = False
	cb_None.Visible = False
	cb_Inv.Visible = False
	cbx_multi.Visible = False	
	hpb_prg.MaxPosition = li_Total
	li_Total = 0
End If

// Run main loop
Try
	Do
		li_Row = dw_voyages.GetSelectedRow(li_Row)
		If li_Row > 0 then		
			gnv_Voyage.of_RetrieveVoyage(dw_Voyages.GetItemNumber(li_Row, "voy_id" ), False)
			If gnv_Voyage.of_GetBunkerPrices() = 1 then
				If gnv_Voyage.of_UpdateVoyage() = 0 then li_Total += 1 Else li_Fail += 1
			Else
				li_Fail += 1
			End If
		End If
		hpb_prg.Stepit( )
	Loop Until li_Row = 0
Catch (Exception ex)
	Messagebox("Error", "An error occurred while obtaining bunker prices.", Exclamation!)
	Destroy gnv_Voyage
	If li_Fail = 0 then li_Fail = 1
End Try

// If progress bar shown, then hide
If li_Total>5 then
	hpb_prg.Visible = False
	cb_all.Visible = True
	cb_None.Visible = True
	cb_Inv.Visible = True
	cbx_multi.Visible = True
	hpb_prg.MaxPosition = 0
	li_Total = 0
End If

If li_Fail = 0 then
	Post Messagebox("Update Success", "The selected voyage legs were updated successfully!", Information!)
Else
	Post Messagebox("Update Error", "The bunker price of one or more voyage legs could not be updated.~n~nTotal Selected: " + String(li_Total) + "   Update Failed: " + String(li_Fail), Exclamation!)
End If

Destroy gnv_Voyage
end subroutine

on w_browser.create
this.hpb_prg=create hpb_prg
this.cb_inv=create cb_inv
this.cb_none=create cb_none
this.cb_all=create cb_all
this.st_select=create st_select
this.dw_expraw=create dw_expraw
this.cbx_multi=create cbx_multi
this.dw_expexcel=create dw_expexcel
this.cb_voy=create cb_voy
this.cb_vsl=create cb_vsl
this.dw_voyages=create dw_voyages
this.dw_vsl=create dw_vsl
this.Control[]={this.hpb_prg,&
this.cb_inv,&
this.cb_none,&
this.cb_all,&
this.st_select,&
this.dw_expraw,&
this.cbx_multi,&
this.dw_expexcel,&
this.cb_voy,&
this.cb_vsl,&
this.dw_voyages,&
this.dw_vsl}
end on

on w_browser.destroy
destroy(this.hpb_prg)
destroy(this.cb_inv)
destroy(this.cb_none)
destroy(this.cb_all)
destroy(this.st_select)
destroy(this.dw_expraw)
destroy(this.cbx_multi)
destroy(this.dw_expexcel)
destroy(this.cb_voy)
destroy(this.cb_vsl)
destroy(this.dw_voyages)
destroy(this.dw_vsl)
end on

event open;
dw_vsl.settransobject( SQLCA)
dw_voyages.settransobject( SQLCA)

dw_vsl.retrieve(g_userinfo.userid )

VslMenu = CREATE m_Vslmenu
VoyMenu = CREATE m_Voymenu
	
event ue_vslmenuclick(4)   // Only used to refresh the filter

If dw_vsl.rowcount( )>0 then il_vslid = dw_vsl.GetItemNumber(1, "vessel_id")


end event

event resize;
dw_vsl.height=newheight - dw_vsl.x - dw_vsl.y
dw_voyages.height=dw_vsl.height
dw_voyages.width=newwidth - dw_voyages.x - dw_vsl.x

hpb_prg.Width = dw_voyages.Width - hpb_prg.x + dw_voyages.x
end event

event key;
If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type hpb_prg from hprogressbar within w_browser
boolean visible = false
integer x = 1865
integer y = 32
integer width = 2359
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type cb_inv from commandbutton within w_browser
boolean visible = false
integer x = 3401
integer y = 24
integer width = 160
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Inv"
end type

event clicked;
Integer li_rows

For li_rows = 1 to dw_Voyages.Rowcount( )
	dw_Voyages.SelectRow(li_rows, Not dw_Voyages.IsSelected(li_rows))
Next

end event

type cb_none from commandbutton within w_browser
boolean visible = false
integer x = 3237
integer y = 24
integer width = 160
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "None"
end type

event clicked;
dw_Voyages.SelectRow(0, False)
end event

type cb_all from commandbutton within w_browser
boolean visible = false
integer x = 3090
integer y = 24
integer width = 146
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "All"
end type

event clicked;
dw_Voyages.SelectRow(0, True)
end event

type st_select from statictext within w_browser
boolean visible = false
integer x = 2926
integer y = 40
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select:"
boolean focusrectangle = false
end type

type dw_expraw from datawindow within w_browser
boolean visible = false
integer x = 1115
integer y = 1008
integer width = 686
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_voyexportraw"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_multi from checkbox within w_browser
integer x = 1902
integer y = 16
integer width = 859
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Multiple Selections"
end type

event clicked;
If This.Checked then
	m_VoyMenu.m_viewfulldetails.Visible = False
	m_VoyMenu.m_deletevoyage.Visible = False
	m_VoyMenu.m_EditVoyage.Visible = False
	m_VoyMenu.m_l1.Visible = False
	st_Select.Visible = True
	cb_All.Visible = True
	cb_None.Visible = True
	cb_Inv.Visible = True
Else
	dw_voyages.SelectRow(0, False)
	dw_voyages.SelectRow(dw_Voyages.GetRow(), True)
	m_VoyMenu.m_viewfulldetails.Visible = True	
	m_VoyMenu.m_EditVoyage.Visible = True
	m_VoyMenu.m_deletevoyage.Visible = True
	m_VoyMenu.m_l1.Visible = True
	st_Select.Visible = False
	cb_All.Visible = False
	cb_None.Visible = False
	cb_Inv.Visible = False
End If
end event

type dw_expexcel from datawindow within w_browser
boolean visible = false
integer x = 402
integer y = 1008
integer width = 686
integer height = 400
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_voydetailexport"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_voy from commandbutton within w_browser
integer x = 951
integer y = 16
integer width = 914
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "          Voyage Options      >>>"
end type

event clicked;
voymenu.popmenu(w_browser.x+w_browser.pointerx(),w_browser.y+ w_browser.pointery())
end event

type cb_vsl from commandbutton within w_browser
integer x = 18
integer y = 16
integer width = 914
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "           Vessel Options      >>>"
end type

event clicked;
vslmenu.popmenu(w_browser.x + w_browser.pointerx(), w_browser.y + w_browser.pointery())

end event

type dw_voyages from datawindow within w_browser
event mousedown pbm_mousemove
integer x = 951
integer y = 112
integer width = 3529
integer height = 832
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_voylist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_sort, ls_KeyDownType
Integer	li_cnt
 	
If row>0 then 
	If Not cbx_multi.Checked then 
		This.selectRow( 0 , false )
		This.selectRow(row , True)
		il_VoyID = this.GetItemNumber(row, "voy_id")
	Else
		SetRedraw(False)
		If KeyDown(KeyShift!) then
			SelectRow(0, False)
			If il_last_row_clicked > row Then
				// Loop back through rows and highlight them
				For li_cnt = il_last_row_clicked to row Step -1
					SelectRow(li_cnt, True)	
				Next
			Else
				// Loop forward through rows and highlight them
				For li_cnt = il_last_row_clicked to row
					SelectRow(li_cnt, True)	
				Next
			End If
		ElseIf KeyDown(KeyControl!) then
			il_last_row_clicked = row
			SelectRow(row, Not IsSelected(row))			
		Else
			il_last_row_clicked = row
			SelectRow(0, False)			
			SelectRow(row, True)
		End If
		SetRedraw(True)
	End If
	Return
End if

If (dwo.type = "text") then
	If (dwo.tag>"") then
		ls_sort = dwo.Tag
		this.setSort(ls_sort)
		this.Sort()
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		dwo.Tag = ls_sort
	End If
End if


//IF Keydown(KeyShift!) THEN

//ELSEIF Keydown(KeyControl!) THEN
//	// Keep other rows highlighted and select/deselect a new row

//ELSEIF IsSelected(al_row) THEN
//	il_last_row_clicked = al_row
//
//	ib_action_on_lbuttonup = TRUE
//ELSE
//	il_last_row_clicked = al_row
//
//	SelectRow(0,FALSE)
//	SelectRow(al_row,TRUE)
//END IF
//
end event

event doubleclicked;
If Row>0 then post event ue_voymenuclick(1)

end event

event resize;
If this.getrow( ) > 0 then this.scrolltorow( this.getrow() )
end event

type dw_vsl from datawindow within w_browser
integer x = 18
integer y = 112
integer width = 914
integer height = 832
integer taborder = 10
string dataobject = "d_sq_tb_vsllist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow = 0 then return

long ll_rows

dw_voyages.SetRedraw(false)

il_vslid = this.GetItemNumber(currentrow, "vessel_id")

ll_rows = dw_voyages.retrieve(il_vslid)

if ll_rows >0 then
	dw_voyages.SelectRow( 0, False)
	dw_voyages.SelectRow( ll_rows , true)
	dw_voyages.ScrollToRow( ll_rows)
	il_Last_Row_Clicked = ll_rows
	cb_voy.enabled = True
	il_voyid = dw_voyages.GetItemnumber( ll_rows, "Voy_ID")
else
  cb_voy.enabled=false
end if

dw_voyages.SetRedraw(true)	

this.selectRow( 0 , false )
this.selectRow( currentrow , true )
end event

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if

if row>0 then
	this.selectRow( 0 , false )
	this.selectRow( row , true )
end if
end event

event rbuttondown;
//m_vslmenu.popmenu(this.x + this.pointerx(), this.y + this.pointery())

vslmenu.popmenu(w_browser.x + w_browser.pointerx(), w_browser.y + w_browser.pointery())
end event

event retrieveend;
If rowcount = 0 then 
	cb_vsl.enabled = false 
	cb_voy.enabled = false
Else 
	cb_vsl.enabled = true
End If
end event

event resize;
If this.getrow( ) > 0 then this.scrolltorow( this.getrow() )
end event

