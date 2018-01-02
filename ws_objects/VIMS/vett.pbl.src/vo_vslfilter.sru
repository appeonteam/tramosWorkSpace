$PBExportHeader$vo_vslfilter.sru
forward
global type vo_vslfilter from userobject
end type
type st_fgfilter from statictext within vo_vslfilter
end type
type cb_fgmenu from commandbutton within vo_vslfilter
end type
type cb_clearall from commandbutton within vo_vslfilter
end type
type dw_fg from datawindow within vo_vslfilter
end type
type st_vslfilter from statictext within vo_vslfilter
end type
type cb_vslmenu from commandbutton within vo_vslfilter
end type
type cb_savefilter from commandbutton within vo_vslfilter
end type
type pb_filter from picturebutton within vo_vslfilter
end type
type cb_typemenu from commandbutton within vo_vslfilter
end type
type st_typefilter from statictext within vo_vslfilter
end type
type dw_type from datawindow within vo_vslfilter
end type
type cb_officemenu from commandbutton within vo_vslfilter
end type
type st_officefilter from statictext within vo_vslfilter
end type
type dw_office from datawindow within vo_vslfilter
end type
type cb_pcmenu from commandbutton within vo_vslfilter
end type
type st_pcfilter from statictext within vo_vslfilter
end type
type dw_pc from datawindow within vo_vslfilter
end type
type cb_respmenu from commandbutton within vo_vslfilter
end type
type st_respfilter from statictext within vo_vslfilter
end type
type dw_resp from datawindow within vo_vslfilter
end type
type cb_selectall from commandbutton within vo_vslfilter
end type
type st_fhead from statictext within vo_vslfilter
end type
type rr_filter from roundrectangle within vo_vslfilter
end type
type dw_vessel from datawindow within vo_vslfilter
end type
end forward

global type vo_vslfilter from userobject
integer width = 4805
integer height = 428
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_contextmenuclick ( integer ai_menuitem )
event filterexpand ( ) External
event filtercollapse ( ) External
event filterchange ( )
st_fgfilter st_fgfilter
cb_fgmenu cb_fgmenu
cb_clearall cb_clearall
dw_fg dw_fg
st_vslfilter st_vslfilter
cb_vslmenu cb_vslmenu
cb_savefilter cb_savefilter
pb_filter pb_filter
cb_typemenu cb_typemenu
st_typefilter st_typefilter
dw_type dw_type
cb_officemenu cb_officemenu
st_officefilter st_officefilter
dw_office dw_office
cb_pcmenu cb_pcmenu
st_pcfilter st_pcfilter
dw_pc dw_pc
cb_respmenu cb_respmenu
st_respfilter st_respfilter
dw_resp dw_resp
cb_selectall cb_selectall
st_fhead st_fhead
rr_filter rr_filter
dw_vessel dw_vessel
end type
global vo_vslfilter vo_vslfilter

type variables

Integer ii_MenuSel

m_selection im_sel
m_selection_user im_resp
m_selection_type im_type

Boolean ibool_Show

String is_Setting = "", is_UserID = ""
String is_Resp, is_PC, is_Type, is_Office, is_Vsl, is_FG

Datawindow idw_Main
Window iw_Parent
end variables

forward prototypes
public subroutine of_showfilter (boolean abool_show)
public function integer resize (integer w, integer h)
public subroutine of_loadfilters ()
public subroutine of_initfilters (ref window aw_parent, ref datawindow adw_main, string as_setting, string as_userid)
public function string of_getfilter (integer ai_dwindex)
public subroutine of_setfilters (integer ai_select)
end prototypes

event ue_contextmenuclick(integer ai_menuitem);// Fired from context menus

Datawindow ldw_DW
Integer li_Count

// Get reference to correct DW
Choose Case ii_MenuSel
	Case 0
		ldw_DW = dw_Resp
	Case 1
		ldw_DW = dw_PC
	Case 2
		ldw_DW = dw_Office
	Case 3
		ldw_DW = dw_Type
	Case 4
		ldw_DW = dw_Vessel
	Case 5
		ldw_DW = dw_FG
End Choose

ldw_DW.SetRedraw(False)

// Perform action
Choose Case ai_MenuItem
	Case 10
		For li_Count = 1 to ldw_DW.RowCount()
			ldw_DW.SetItem(li_Count, "Sel", 1)
		Next
	Case 20
		For li_Count = 1 to ldw_DW.RowCount()
			ldw_DW.SetItem(li_Count, "Sel", 0)
		Next
	Case 30
		For li_Count = 1 to ldw_DW.RowCount()
			ldw_DW.SetItem(li_Count, "Sel", 1 - ldw_DW.GetItemNumber(li_Count, "Sel"))
		Next
	Case 100  // Fired for dw_Resp & dw_Type
		For li_Count = 1 to ldw_DW.RowCount()
			ldw_DW.SetItem(li_Count, "Sel", 0)
			If ii_MenuSel = 3 then  // Vsl Type filter
				If Pos(ldw_DW.GetItemString(li_Count, "Type_Name"), "T/C") > 0 then ldw_DW.SetItem(li_Count, "Sel", 1)
			End If
		Next
		If ii_MenuSel = 0 then  // Responsible filter
			li_Count = dw_Resp.Find("userid = '" + is_UserID + "'", 1, dw_Resp.RowCount())		
			If li_Count > 0 then	
				dw_Resp.SetItem(li_Count, "Sel", 1)
				dw_Resp.ScrollToRow(li_Count)
			Else
				Messagebox("User not found", "Your name could not be found in the list!", Exclamation!)
			End If
		End If
	Case 110  // Fired only for dw_Type
		For li_Count = 1 to ldw_DW.RowCount()
			ldw_DW.SetItem(li_Count, "Sel", 0)
			If ii_MenuSel = 3 then
				If Pos(ldw_DW.GetItemString(li_Count, "Type_Name"), "3P") > 0 then ldw_DW.SetItem(li_Count, "Sel", 1)
			End If
		Next				
End Choose

ldw_DW.SetRedraw(True)

Event filterchange()
end event

event filterexpand();
// Runs when filter is expanded
end event

event filtercollapse();
// Runs when filter is collapsed
end event

event filterchange();Integer li_Loop, li_Sel, li_Total
String ls_Filter
Boolean lbool_All = True
Long ll_FilterBackColor

// Set Resp filter
is_Resp = ""
li_Sel = 0
li_Total = dw_Resp.RowCount()
For li_Loop = 1 to li_Total
	If dw_Resp.GetItemNumber(li_Loop, "Sel") = 1 then
		is_Resp += "'" + dw_Resp.GetItemString(li_Loop, "UserID") + "',"
		li_Sel ++
	End If
Next
is_Resp += "'XXX'"   // Dummy user id required
is_Resp = "(Resp in (" + is_Resp + ") or IsNull(Resp))"
st_RespFilter.Text = "Marine Super (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then 
	lbool_All = False	
	If li_Sel = 0 then st_RespFilter.TextColor = 192 else st_RespFilter.TextColor = 16711680
	ls_Filter = is_Resp
Else
	st_RespFilter.TextColor = 0
End If

// Set PC filter
is_PC = ""
li_Sel = 0
li_Total = dw_PC.RowCount()
For li_Loop = 1 to dw_PC.RowCount()
	If dw_PC.GetItemNumber(li_Loop, "Sel") = 1 then
		is_PC += String(dw_PC.GetItemNumber(li_Loop, "PC_Nr")) + ","
		li_Sel ++
	End If
Next
is_PC += "0"
is_PC = "PC_Nr in (" + is_PC + ")"
st_PCFilter.Text = "Profit Center (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then 
	lbool_All = False
	If li_Sel = 0 then st_PCFilter.TextColor = 192 else st_PCFilter.TextColor = 16711680	
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += is_PC
Else
	st_PCFilter.TextColor = 0
End If

// Set Office filter
is_Office = ""
li_Sel = 0
li_Total = dw_Office.RowCount()
For li_Loop = 1 to dw_Office.RowCount()
	If dw_Office.GetItemNumber(li_Loop, "Sel") = 1 then
		is_Office += String(dw_Office.GetItemNumber(li_Loop, "Vett_OfficeID")) + ","
		li_Sel ++
	End If
Next
is_Office += "0"
is_Office = "Office_ID in (" + is_Office + ")"
st_OfficeFilter.Text = "Vetting Office (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then
	lbool_All = False
	If li_Sel = 0 then st_OfficeFilter.TextColor = 192 else st_OfficeFilter.TextColor = 16711680
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += is_Office
Else
	st_OfficeFilter.TextColor = 0	
End If

// Set Type filter
is_Type = ""
li_Sel = 0
li_Total = dw_Type.RowCount()
For li_Loop = 1 to dw_Type.RowCount()
	If dw_Type.GetItemNumber(li_Loop, "Sel") = 1 then
		is_Type += String(dw_Type.GetItemNumber(li_Loop, "Type_ID")) + ","
		li_Sel ++
	End If
Next
is_Type += "0"
is_Type = "Type_ID in (" + is_Type + ")"
st_TypeFilter.Text = "Vessel Type (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then
	lbool_All = False
	If li_Sel = 0 then st_TypeFilter.TextColor = 192 else st_TypeFilter.TextColor = 16711680
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += is_Type
Else	
	st_TypeFilter.TextColor = 0
End If

// Set FleetGroup filter
is_FG = ""
li_Sel = 0
li_Total = dw_FG.RowCount()
For li_Loop = 1 to dw_FG.RowCount()
	If dw_FG.GetItemNumber(li_Loop, "Sel") = 1 then
		is_FG += String(dw_FG.GetItemNumber(li_Loop, "FGID")) + ","
		li_Sel ++
	End If
Next
is_FG += "0"
is_FG = "FGID in (" + is_FG + ")"
st_FGFilter.Text = "Fleet Group (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then
	lbool_All = False
	If li_Sel = 0 then st_FGFilter.TextColor = 192 else st_FGFilter.TextColor = 16711680
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += is_FG
Else
	st_FGFilter.TextColor = 0	
End If

// Set Vessel filter
is_Vsl = ""
li_Sel = 0
li_Total = dw_Vessel.RowCount()
For li_Loop = 1 to dw_Vessel.RowCount()
	If dw_Vessel.GetItemNumber(li_Loop, "Sel") = 1 then
		is_Vsl += String(dw_Vessel.GetItemNumber(li_Loop, "Vessel_ID")) + ","
		li_Sel ++
	End If
Next
is_Vsl += "0"
is_Vsl = "Vessel_ID in (" + is_Vsl + ")"
st_VslFilter.Text = "Vessels (" + String(li_Sel) + "/" + String(li_Total) + ")"
If li_Sel < li_Total then
	lbool_All = False
	If li_Sel = 0 then st_VslFilter.TextColor = 192 else st_VslFilter.TextColor = 16711680
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += is_Vsl
Else	
	st_VslFilter.TextColor = 0
End If

// Combine filters and apply
clipboard(ls_Filter)
idw_Main.SetFilter(ls_Filter)
idw_Main.Filter()

// Set filter back color
If lbool_All then ll_FilterBackColor = 14745568 Else ll_FilterBackColor = 16769248
If idw_Main.RowCount()=0 then ll_FilterBackColor = 14737663

// Apply filter back color to all
rr_Filter.Fillcolor = ll_FilterBackColor
st_FHead.BackColor = ll_FilterBackColor
st_PCFilter.BackColor = ll_FilterBackColor
st_RespFilter.BackColor = ll_FilterBackColor
st_OfficeFilter.BackColor = ll_FilterBackColor
st_TypeFilter.BackColor = ll_FilterBackColor
st_VslFilter.BackColor = ll_FilterBackColor
st_FGfilter.BackColor = ll_FilterBackColor

end event

public subroutine of_showfilter (boolean abool_show);
// Shows/Hides the filter

If abool_Show then pb_Filter.PictureName = "J:\TramosWS\VIMS\images\Vims\collapse.png" else pb_Filter.PictureName = "J:\TramosWS\VIMS\images\Vims\expand.png"

This.SetRedraw(False)

dw_Resp.Visible = abool_Show
dw_PC.Visible = abool_Show
dw_Office.Visible = abool_Show
dw_Type.Visible = abool_Show
dw_Vessel.Visible = abool_Show
dw_FG.Visible = abool_Show
cb_SelectAll.Visible = abool_Show
cb_ClearAll.Visible = abool_Show
cb_SaveFilter.Visible = abool_Show
	
If abool_Show then 
	rr_Filter.Height = 352 
	This.Height = 352	
   Post Event filterexpand()
Else 
	rr_Filter.Height = 80
	This.Height = 80
	Post Event filtercollapse()
End If

This.SetRedraw(True)
end subroutine

public function integer resize (integer w, integer h);
This.Width = w

If w < dw_Vessel.X + dw_Vessel.Width + pb_Filter.width + 32 Then w = dw_Vessel.X + dw_Vessel.Width + pb_Filter.width + 32

pb_Filter.X = w - pb_Filter.Width
rr_Filter.Width = pb_Filter.X

Return 1

end function

public subroutine of_loadfilters ();// This function loads filters from the database and selects the items in the datawindows

If is_Setting = "" then
	Messagebox("User Settings", "Setting Name not specified. Cannot load filter settings!", Exclamation!)
	Return
End If

uo_UserSetting ln_Sett
uo_DWSelection ln_DW
String ls_Temp

ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Resp", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Resp, "UserID", True, ls_Temp)
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-PC", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_PC, "PC_Nr", False, ls_Temp)
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Office", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Office, "Vett_OfficeID", False, ls_Temp)
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Type", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Type, "Type_ID", False, ls_Temp)
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-FG", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_FG, "FGID", False, ls_Temp)
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Vessel", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Vessel, "Vessel_ID", False, ls_Temp)

// Raise event
Post Event FilterChange()
end subroutine

public subroutine of_initfilters (ref window aw_parent, ref datawindow adw_main, string as_setting, string as_userid);// This function sets the parent window,
// the main datawindow to be filtered,
// the setting name used to save and load filters from the database
// and the UserID

iw_Parent = aw_Parent

idw_Main = adw_Main

is_Setting = Trim(as_Setting, True)

is_UserID = as_UserID

end subroutine

public function string of_getfilter (integer ai_dwindex);
Choose Case ai_DWIndex
	Case 0
		Return is_Resp + " And " + is_PC + " And " + is_Office + " And " + is_Type + " And " + is_Vsl + " And " + is_FG
	Case 1
		Return is_Resp
	Case 2
		Return is_PC
	Case 3
		Return is_Office
	Case 4
		Return is_Type
	Case 5
		Return is_Vsl
	Case 6
		Return is_FG
	Case Else
		Return ""
End Choose
end function

public subroutine of_setfilters (integer ai_select);Integer li_Loop

For li_Loop = 1 to dw_Resp.RowCount()
	dw_Resp.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_Resp.SetRedraw(True)

For li_Loop = 1 to dw_Type.RowCount()
	dw_Type.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_Type.SetRedraw(True)

For li_Loop = 1 to dw_Office.RowCount()
	dw_Office.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_Office.SetRedraw(True)

For li_Loop = 1 to dw_PC.RowCount()
	dw_PC.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_PC.SetRedraw(True)

For li_Loop = 1 to dw_FG.RowCount()
	dw_FG.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_FG.SetRedraw(True)

For li_Loop = 1 to dw_Vessel.RowCount()
	dw_Vessel.SetItem(li_Loop, "Sel", ai_Select)
Next
dw_Vessel.SetRedraw(True)

Event FilterChange()

end subroutine

on vo_vslfilter.create
this.st_fgfilter=create st_fgfilter
this.cb_fgmenu=create cb_fgmenu
this.cb_clearall=create cb_clearall
this.dw_fg=create dw_fg
this.st_vslfilter=create st_vslfilter
this.cb_vslmenu=create cb_vslmenu
this.cb_savefilter=create cb_savefilter
this.pb_filter=create pb_filter
this.cb_typemenu=create cb_typemenu
this.st_typefilter=create st_typefilter
this.dw_type=create dw_type
this.cb_officemenu=create cb_officemenu
this.st_officefilter=create st_officefilter
this.dw_office=create dw_office
this.cb_pcmenu=create cb_pcmenu
this.st_pcfilter=create st_pcfilter
this.dw_pc=create dw_pc
this.cb_respmenu=create cb_respmenu
this.st_respfilter=create st_respfilter
this.dw_resp=create dw_resp
this.cb_selectall=create cb_selectall
this.st_fhead=create st_fhead
this.rr_filter=create rr_filter
this.dw_vessel=create dw_vessel
this.Control[]={this.st_fgfilter,&
this.cb_fgmenu,&
this.cb_clearall,&
this.dw_fg,&
this.st_vslfilter,&
this.cb_vslmenu,&
this.cb_savefilter,&
this.pb_filter,&
this.cb_typemenu,&
this.st_typefilter,&
this.dw_type,&
this.cb_officemenu,&
this.st_officefilter,&
this.dw_office,&
this.cb_pcmenu,&
this.st_pcfilter,&
this.dw_pc,&
this.cb_respmenu,&
this.st_respfilter,&
this.dw_resp,&
this.cb_selectall,&
this.st_fhead,&
this.rr_filter,&
this.dw_vessel}
end on

on vo_vslfilter.destroy
destroy(this.st_fgfilter)
destroy(this.cb_fgmenu)
destroy(this.cb_clearall)
destroy(this.dw_fg)
destroy(this.st_vslfilter)
destroy(this.cb_vslmenu)
destroy(this.cb_savefilter)
destroy(this.pb_filter)
destroy(this.cb_typemenu)
destroy(this.st_typefilter)
destroy(this.dw_type)
destroy(this.cb_officemenu)
destroy(this.st_officefilter)
destroy(this.dw_office)
destroy(this.cb_pcmenu)
destroy(this.st_pcfilter)
destroy(this.dw_pc)
destroy(this.cb_respmenu)
destroy(this.st_respfilter)
destroy(this.dw_resp)
destroy(this.cb_selectall)
destroy(this.st_fhead)
destroy(this.rr_filter)
destroy(this.dw_vessel)
end on

event constructor;uo_UserSetting ln_Sett
uo_DWSelection ln_DW
String ls_Temp

// Init filter datawindows
dw_resp.SetTransObject(SQLCA)
dw_pc.SetTransObject(SQLCA)
dw_office.SetTransObject(SQLCA)
dw_type.SetTransObject(SQLCA)
dw_Vessel.SetTransObject(SQLCA)
dw_FG.SetTransObject(SQLCA)
dw_resp.Retrieve( )
dw_pc.Retrieve( )
dw_office.Retrieve( )
dw_type.Retrieve( )
dw_Vessel.Retrieve( )
dw_FG.Retrieve( )

// Init menus
im_Resp = Create m_Selection_User
im_Sel = Create m_Selection
im_Type = Create m_Selection_Type

// Force redraw
Post of_ShowFilter(False)


end event

event destructor;
// Destroy menus
Destroy im_Resp
Destroy im_Sel
Destroy im_Type
end event

type st_fgfilter from statictext within vo_vslfilter
integer x = 3310
integer y = 12
integer width = 512
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Fleet Group:"
boolean focusrectangle = false
end type

type cb_fgmenu from commandbutton within vo_vslfilter
integer x = 3218
integer y = 12
integer width = 78
integer height = 56
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 5

im_Sel.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type cb_clearall from commandbutton within vo_vslfilter
boolean visible = false
integer x = 37
integer y = 160
integer width = 279
integer height = 68
integer taborder = 20
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Clear All"
end type

event clicked;
of_SetFilters(0)
end event

type dw_fg from datawindow within vo_vslfilter
boolean visible = false
integer x = 3218
integer y = 64
integer width = 603
integer height = 264
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_rep_fg"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()
end event

type st_vslfilter from statictext within vo_vslfilter
integer x = 4005
integer y = 16
integer width = 512
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Vessels:"
boolean focusrectangle = false
end type

type cb_vslmenu from commandbutton within vo_vslfilter
integer x = 3913
integer y = 16
integer width = 78
integer height = 56
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 4

im_Sel.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type cb_savefilter from commandbutton within vo_vslfilter
boolean visible = false
integer x = 37
integer y = 256
integer width = 279
integer height = 68
integer taborder = 20
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Save Filters"
end type

event clicked;
If is_Setting = "" then
	Messagebox("User Settings", "Setting Name not specified. Cannot save settings!", Exclamation!)
	Return
End If

uo_DWSelection ln_Save
uo_UserSetting ln_User
String ls_Data
Boolean lbool_Err = False

// Save Resp
If ln_Save.of_SaveSelection(dw_Resp, "userid", True, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-Resp") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-Resp", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Profit Center
If ln_Save.of_SaveSelection(dw_PC, "PC_Nr", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-PC") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-PC", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Office
If ln_Save.of_SaveSelection(dw_Office, "Vett_OfficeID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-Office") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-Office", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Type
If ln_Save.of_SaveSelection(dw_Type, "Type_ID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-Type") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-Type", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Fleet Group
If ln_Save.of_SaveSelection(dw_FG, "FGID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-FG") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-FG", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Vessels
If ln_Save.of_SaveSelection(dw_Vessel, "Vessel_ID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(is_UserID, is_Setting + "-Vessel") 
	Else
		If ln_User.of_Savesetting(is_UserID, is_Setting + "-Vessel", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

If lbool_Err then
	Messagebox("Error Saving Filters", "One or more filters were not saved successfully.", Exclamation!)
Else
	Messagebox("Filters Saved", "The filter settings were saved successfully.")
End If
end event

type pb_filter from picturebutton within vo_vslfilter
integer x = 3986
integer width = 91
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\expand.png"
alignment htextalign = left!
long backcolor = 67108864
end type

event clicked;
of_ShowFilter(Not dw_Resp.Visible)

end event

type cb_typemenu from commandbutton within vo_vslfilter
integer x = 2505
integer y = 12
integer width = 78
integer height = 56
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 3

im_Type.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type st_typefilter from statictext within vo_vslfilter
integer x = 2597
integer y = 12
integer width = 512
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Vessel Type:"
boolean focusrectangle = false
end type

type dw_type from datawindow within vo_vslfilter
boolean visible = false
integer x = 2505
integer y = 64
integer width = 603
integer height = 264
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_rep_vtypelist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()
end event

type cb_officemenu from commandbutton within vo_vslfilter
integer x = 1792
integer y = 12
integer width = 78
integer height = 56
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 2

im_Sel.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type st_officefilter from statictext within vo_vslfilter
integer x = 1883
integer y = 12
integer width = 530
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Vetting Office:"
boolean focusrectangle = false
end type

type dw_office from datawindow within vo_vslfilter
boolean visible = false
integer x = 1792
integer y = 64
integer width = 603
integer height = 264
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_rep_office"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()
end event

type cb_pcmenu from commandbutton within vo_vslfilter
integer x = 1079
integer y = 12
integer width = 78
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 1

im_Sel.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type st_pcfilter from statictext within vo_vslfilter
integer x = 1170
integer y = 12
integer width = 530
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Profit Center:"
boolean focusrectangle = false
end type

type dw_pc from datawindow within vo_vslfilter
boolean visible = false
integer x = 1079
integer y = 64
integer width = 603
integer height = 264
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_rep_pclist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()
end event

type cb_respmenu from commandbutton within vo_vslfilter
integer x = 366
integer y = 12
integer width = 78
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
ii_MenuSel = 0

im_Resp.popmenu(iw_Parent.x + iw_Parent.pointerx(), iw_Parent.y + iw_Parent.pointery())
end event

type st_respfilter from statictext within vo_vslfilter
integer x = 457
integer y = 12
integer width = 530
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Marine Super:"
boolean focusrectangle = false
end type

type dw_resp from datawindow within vo_vslfilter
boolean visible = false
integer x = 366
integer y = 64
integer width = 603
integer height = 264
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_tb_vettusers"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()

end event

type cb_selectall from commandbutton within vo_vslfilter
boolean visible = false
integer x = 37
integer y = 96
integer width = 279
integer height = 68
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Select All"
end type

event clicked;
of_SetFilters(1)
end event

type st_fhead from statictext within vo_vslfilter
integer x = 18
integer y = 16
integer width = 201
integer height = 48
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "Filters:"
boolean focusrectangle = false
end type

type rr_filter from roundrectangle within vo_vslfilter
integer linethickness = 4
long fillcolor = 15780518
integer width = 3950
integer height = 80
integer cornerheight = 30
integer cornerwidth = 30
end type

type dw_vessel from datawindow within vo_vslfilter
boolean visible = false
integer x = 3913
integer y = 64
integer width = 603
integer height = 264
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_rep_vsllist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

Parent.Event filterchange()
end event

