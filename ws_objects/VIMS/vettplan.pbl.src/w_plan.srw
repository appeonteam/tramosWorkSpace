$PBExportHeader$w_plan.srw
forward
global type w_plan from window
end type
type st_tip from statictext within w_plan
end type
type sle_search from singlelineedit within w_plan
end type
type dw_miretech from datawindow within w_plan
end type
type uo_filter from vo_vslfilter within w_plan
end type
type cb_overview from commandbutton within w_plan
end type
type cb_poc from commandbutton within w_plan
end type
type cb_find from commandbutton within w_plan
end type
type cb_cal from commandbutton within w_plan
end type
type cb_print from commandbutton within w_plan
end type
type cb_stat from commandbutton within w_plan
end type
type cb_edit from commandbutton within w_plan
end type
type cb_close from commandbutton within w_plan
end type
type dw_plan from datawindow within w_plan
end type
type gb_main from groupbox within w_plan
end type
end forward

global type w_plan from window
integer width = 4928
integer height = 2648
boolean titlebar = true
string title = "Inspection Planning"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Status.ico"
boolean center = true
event ue_contextmenuclick ( integer ai_menuitem )
event ue_print ( integer ai_select )
st_tip st_tip
sle_search sle_search
dw_miretech dw_miretech
uo_filter uo_filter
cb_overview cb_overview
cb_poc cb_poc
cb_find cb_find
cb_cal cb_cal
cb_print cb_print
cb_stat cb_stat
cb_edit cb_edit
cb_close cb_close
dw_plan dw_plan
gb_main gb_main
end type
global w_plan w_plan

type variables

w_Calender iw_WinCal
w_CalWeek iw_WinCalWeek

String is_Sort  // Stores the DW sort column so it can be applied to the print DW also

m_printplan im_Print

Integer ii_Margin = 18
end variables

forward prototypes
public function string wf_getrejections (long al_imo)
public subroutine wf_openreject (long al_imo)
public subroutine wf_loaddw ()
public subroutine wf_searchvsl ()
end prototypes

event ue_contextmenuclick(integer ai_menuitem);
// Call filter context menu

uo_Filter.Event ue_ContextMenuClick(ai_menuitem)
end event

event ue_print(integer ai_select);Integer li_Loop

SetPointer(HourGlass!)

// Open preview sheet
OpenSheet(w_preview, w_main, 0, Original!)

// Init DW
Choose Case ai_Select
	Case 0
		w_preview.dw_rep.dataobject = "d_sq_tb_planprint"
	Case 1
		w_preview.dw_rep.dataobject = "d_sq_tb_planprint_int"
	Case 2
		w_preview.dw_rep.dataobject = "d_sq_tb_planprint_ext"
End Choose
w_preview.dw_rep.SetTransObject(SQLCA)
w_preview.dw_rep.Modify("DataWindow.Print.Preview = True")

// Set filter
w_preview.dw_rep.SetFilter(uo_filter.of_Getfilter(0))
w_preview.dw_rep.Filter()

// Set sorting
w_preview.dw_rep.SetSort(is_Sort + ", #3 A")
w_preview.dw_rep.Sort()

// Retrieve report
w_preview.dw_rep.Retrieve()   

// Show report
w_preview.wf_ShowReport()

end event

public function string wf_getrejections (long al_imo);// Function to get list of active rejections for a vessel in a string

DataStore lds_Reject
String ls_Return
Integer li_Loop

// Init DS
lds_Reject = Create DataStore
lds_Reject.DataObject = "d_sq_tb_activerejects"
lds_Reject.SetTransObject(SQLCA)

// Check for error
If lds_Reject.Retrieve(al_IMO)<0 then Return "<Error>"

// Check for no return
If lds_Reject.RowCount() = 0 then Return "Nil"

// Join all in string
For li_Loop = 1 to lds_Reject.RowCount()
	ls_Return += lds_Reject.GetItemString(li_Loop, "comp_name") + ", "
Next

Return Left(ls_Return, Len(ls_Return) - 2)  // Remove last comma and return
end function

public subroutine wf_openreject (long al_imo);
g_Obj.ObjID = al_IMO

Open(w_Reject)

If g_Obj.ObjID > 0 then dw_Plan.SetItem(dw_Plan.GetRow(), "Reject", wf_GetRejections(al_IMO))

end subroutine

public subroutine wf_loaddw ();// Loads the main datawindow

Integer li_Loop
Integer li_MIREID[]

This.SetRedraw(False)

// Get main DW and set default sort
dw_plan.SetTransobject( SQLCA)
dw_plan.Retrieve( )
is_Sort = "#3 A"

// Initalize filter object and load filters
uo_Filter.of_Initfilters(w_plan, dw_plan, "vettplan.pbl>w_plan>uo_Filter", g_Obj.UserID)
uo_Filter.of_Loadfilters( )

// If Vetting user with R/W and higher access
If (g_obj.Access > 1) and (g_obj.Deptid = 1) then cb_edit.Enabled = True

// Populate Reject column for each vessel
For li_Loop = 1 to dw_plan.RowCount()
	dw_plan.SetItem(li_Loop, "Reject", wf_GetRejections(dw_plan.GetItemNumber(li_Loop, "IMO_Number")))
Next

This.SetRedraw(True)
end subroutine

public subroutine wf_searchvsl ();// Searches for vessel and selects it

Integer li_Row
String ls_S

SetPointer(HourGlass!)

ls_S = Upper(Trim(sle_Search.Text, True))

li_Row = dw_Plan.Find("(Upper(vessels_vessel_ref_nr) like '%" + ls_S + "%') or (Upper(vessel_name) like '%" + ls_S + "%')", 0, dw_Plan.RowCount())

If li_Row > 0 then 
	dw_Plan.SetRedraw(False)
	dw_Plan.Event RowFocusChanged(li_Row)
	dw_Plan.ScrollToRow(li_Row)
	sle_Search.BackColor = 14745568
Else
	sle_Search.BackColor = 14737663
End If

end subroutine

event open;
Integer li_Count, li_Wid, li_Hgt
String ls_Temp

// Get last window height and width from registry
f_Registry("w_plan_w", ls_Temp, False)
li_Wid = Integer(ls_Temp)
f_Registry("w_plan_h", ls_Temp, False)
li_Hgt = Integer(ls_Temp)

If (li_wid > 500) and (li_Hgt > 500) then // Check size, resize and center the window
	If li_Wid > This.Parentwindow( ).WorkspaceWidth( ) then li_Wid = This.Parentwindow( ).WorkspaceWidth( )
	If li_Hgt > This.Parentwindow( ).WorkspaceHeight( ) then li_Hgt = This.Parentwindow( ).WorkspaceHeight( )
	This.Width = li_Wid
	This.Height = li_Hgt
	This.X = (this.parentwindow( ).workspaceWidth( ) - li_Wid) / 2
	This.Y = (this.parentwindow( ).workspaceHeight( ) - li_Hgt) / 2
End If

// Load datawindow
Post wf_LoadDW()

im_Print = Create m_PrintPlan
end event

on w_plan.create
this.st_tip=create st_tip
this.sle_search=create sle_search
this.dw_miretech=create dw_miretech
this.uo_filter=create uo_filter
this.cb_overview=create cb_overview
this.cb_poc=create cb_poc
this.cb_find=create cb_find
this.cb_cal=create cb_cal
this.cb_print=create cb_print
this.cb_stat=create cb_stat
this.cb_edit=create cb_edit
this.cb_close=create cb_close
this.dw_plan=create dw_plan
this.gb_main=create gb_main
this.Control[]={this.st_tip,&
this.sle_search,&
this.dw_miretech,&
this.uo_filter,&
this.cb_overview,&
this.cb_poc,&
this.cb_find,&
this.cb_cal,&
this.cb_print,&
this.cb_stat,&
this.cb_edit,&
this.cb_close,&
this.dw_plan,&
this.gb_main}
end on

on w_plan.destroy
destroy(this.st_tip)
destroy(this.sle_search)
destroy(this.dw_miretech)
destroy(this.uo_filter)
destroy(this.cb_overview)
destroy(this.cb_poc)
destroy(this.cb_find)
destroy(this.cb_cal)
destroy(this.cb_print)
destroy(this.cb_stat)
destroy(this.cb_edit)
destroy(this.cb_close)
destroy(this.dw_plan)
destroy(this.gb_main)
end on

event resize;Integer li_x

This.SetRedraw(False)

// Calculate width of group box, main DW and filter
gb_Main.width = newwidth - ii_Margin * 2
dw_plan.width = gb_Main.width - dw_plan.x - ii_Margin * 2
uo_Filter.Resize(gb_Main.width - uo_Filter.x - ii_Margin * 2, 0)  // filter resize doesn't use height

// Set Y location of DW
dw_Plan.y = ii_Margin * 2 + uo_Filter.Height + uo_Filter.y

// Calculate Heights
li_x = newheight - ii_Margin * 2
if li_x < 600 then li_x = 600  // Min height
gb_Main.Height = li_x
dw_plan.Height = li_x - dw_plan.y - cb_Close.Height - ii_Margin * 3

// Set buttons Y location
cb_edit.y = dw_plan.y + dw_plan.Height + ii_Margin * 2
cb_close.y = cb_edit.y
cb_stat.y = cb_edit.y
cb_print.y = cb_edit.y
cb_Cal.y = cb_Edit.y
cb_Overview.y = cb_Edit.y
cb_Poc.y = cb_Edit.y
cb_Find.y = cb_Edit.y

// Set X location of Close button
li_x = newwidth - cb_close.Width - dw_plan.x
If li_x < cb_Print.x + cb_Print.width then li_x = cb_Print.x + cb_Print.Width
cb_close.x = li_x

This.SetRedraw(True)
end event

event close;String ls_Temp

If This.windowstate = Normal! then   // if not maximized or minimized, remember window size
	ls_Temp = String(This.Width)
	f_Registry("w_plan_w", ls_Temp, True)
	ls_Temp = String(This.Height)
	f_Registry("w_plan_h", ls_Temp, True)
End If

// Destroy menu
Destroy im_Print
end event

type st_tip from statictext within w_plan
boolean visible = false
integer x = 823
integer y = 16
integer width = 1129
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 134217752
string text = "Type in a partial name or number and press Enter"
boolean border = true
boolean focusrectangle = false
end type

type sle_search from singlelineedit within w_plan
event ue_keyup pbm_keyup
integer x = 402
integer y = 16
integer width = 402
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
string text = "Search"
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;
This.backcolor = 16777215   // White

If key = KeyEnter! then	
	wf_SearchVsl()
	st_Tip.Visible=False
End If
end event

event getfocus;
this.text=""
this.textcolor=0
st_Tip.Visible = True
end event

event losefocus;
this.text="Search"
this.textcolor=13027014
this.backcolor=16777215
st_Tip.Visible = False
end event

event modified;
This.backcolor = 16777215   // White
end event

type dw_miretech from datawindow within w_plan
boolean visible = false
integer x = 311
integer y = 1936
integer width = 686
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_miretech"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_filter from vo_vslfilter within w_plan
integer x = 73
integer y = 96
integer width = 3913
integer height = 80
integer taborder = 90
end type

on uo_filter.destroy
call vo_vslfilter::destroy
end on

event filterexpand;call super::filterexpand;
Integer li_Y

Parent.SetRedraw(False)

dw_Plan.y = uo_Filter.y + uo_Filter.Height + ii_Margin

li_Y = Parent.WorkSpaceHeight() - ii_Margin * 5 - cb_close.Height - dw_plan.y
if li_Y < 400 then li_Y = 400

dw_plan.Height = li_Y

Parent.SetRedraw(True)
end event

event filtercollapse;call super::filtercollapse;Integer li_Y

Parent.SetRedraw(False)

dw_Plan.y = uo_Filter.y + uo_Filter.Height + ii_Margin

li_Y = Parent.WorkSpaceHeight() - ii_Margin * 5 - cb_close.Height - dw_plan.y
if li_Y < 400 then li_Y = 400

dw_plan.Height = li_Y

Parent.SetRedraw(True)
end event

event filterchange;call super::filterchange;
If dw_plan.RowCount( ) = 0 then 
	cb_edit.Enabled = False
	cb_cal.Enabled = False
	cb_poc.Enabled = False
	cb_find.Enabled = False
	cb_overview.Enabled = False
Else
	cb_cal.Enabled = True
	cb_poc.Enabled = True
	cb_find.Enabled = True	
	cb_overview.Enabled = True
	If (g_obj.Access > 1) and (g_Obj.deptid = 1) then cb_edit.Enabled = True
End If

end event

type cb_overview from commandbutton within w_plan
integer x = 695
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Overview"
end type

event clicked;Date ld_Start

OpenSheet(iw_WinCalWeek, w_Main, 0, Original!)

ld_Start = RelativeDate(Today(), -42)  // Jump six weeks back
ld_Start = f_GetLastMonday(ld_Start)     // Get last monday

iw_WinCalWeek.uo_Cal.of_SetFilter(uo_filter.of_GetFilter(0))
iw_WinCalWeek.uo_Cal.of_SetWeek(ld_Start)

end event

type cb_poc from commandbutton within w_plan
integer x = 1006
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Schedule"
end type

event clicked;
SetPointer(HourGlass!)

g_obj.Objid = dw_plan.GetItemNumber(dw_Plan.GetRow(), "Vessels_Vessel_nr")

Open(w_VslSchedule)
end event

type cb_find from commandbutton within w_plan
integer x = 1317
integer y = 1712
integer width = 439
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Find Inspectors"
end type

event clicked;
g_obj.Objstring = dw_plan.GetItemString(dw_plan.GetRow(), "type_name")
g_obj.ObjID = dw_plan.GetItemNumber(dw_plan.GetRow(), "type_id")
g_obj.VesselIMO = dw_plan.GetItemNumber(dw_Plan.GetRow(), "imo_number")
g_obj.sql = dw_plan.GetItemString(dw_plan.GetRow(), "Vessel_name")

If IsValid(w_FindInspectors) then Close(w_FindInspectors)

OpenSheet(w_FindInspectors, w_Main, 0, Original!)


end event

type cb_cal from commandbutton within w_plan
integer x = 384
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Calender"
end type

event clicked;Integer li_Tasks, li_Status, li_NewRow
Long ll_StatColor
Date ld_Start
DataStore lds_CalData, lds_VslInsp
Blob lb_blob
String ls_VslName, ls_ModelName, ls_Flag

lds_CalData = Create DataStore
lds_VslInsp = Create DataStore

lds_CalData.DataObject = "d_ext_tb_caldata"
lds_VslInsp.DataObject = "d_sq_tb_vsltasks"
lds_VslInsp.SetTransObject(SQLCA)

ls_VslName = dw_Plan.GetItemString(dw_Plan.GetRow(), "Vessel_Name")
ls_Flag = WordCap(dw_Plan.GetItemString(dw_Plan.GetRow(), "country_name"))

lds_VslInsp.Retrieve(dw_Plan.GetItemNumber(dw_Plan.GetRow(), "IMO_Number"))

For li_Tasks = 1 to lds_VslInsp.RowCount()
	li_Status = lds_VslInsp.GetItemNumber(li_Tasks, "Status")
	Choose Case li_Status
		Case 0 
			ll_StatColor = rgb(255, 255, 0)
		Case 1, 2
			 ll_StatColor = rgb(0, 255, 0)
		Case 3
			 ll_StatColor = rgb(128, 128, 128)
	End Choose

	If (DaysAfter(Date(lds_VslInsp.GetItemDateTime(li_Tasks, "FromDate")), Today()) > 7) and (li_Status < 3) then ll_StatColor = 255
		
	li_NewRow = lds_CalData.InsertRow(0)	
	lds_CalData.SetItem(li_NewRow, "Taskname", lds_VslInsp.GetItemString(li_Tasks, "TaskName"))
	lds_CalData.SetItem(li_NewRow, "Shortname", lds_VslInsp.GetItemString(li_Tasks, "ShortName"))
	lds_CalData.SetItem(li_NewRow, "Color", lds_VslInsp.GetItemNumber(li_Tasks, "Color"))
	lds_CalData.SetItem(li_NewRow, "StatColor", ll_StatColor)
	lds_CalData.SetItem(li_NewRow, "FromDate", Date(lds_VslInsp.GetItemDateTime(li_Tasks, "FromDate")))
	lds_CalData.SetItem(li_NewRow, "ToDate", Date(lds_VslInsp.GetItemDateTime(li_Tasks, "ToDate")))
	lds_CalData.SetItem(li_NewRow, "IsDue", 0)
	lds_CalData.SetItem(li_NewRow, "UserName", lds_VslInsp.GetItemString(li_Tasks, "FullName"))
	lds_CalData.SetItem(li_NewRow, "Vslname", ls_VslName)
	lds_CalData.SetItem(li_NewRow, "StatusVal", lds_VslInsp.GetItemNumber(li_Tasks, "Status"))
	lds_CalData.SetItem(li_NewRow, "Interval", 0)
Next

lds_VslInsp.Reset( )
lds_VslInsp.DataObject = "d_sq_tb_vslinspcal"
lds_VslInsp.SetTransObject(SQLCA)
lds_VslInsp.Retrieve(dw_Plan.GetItemNumber(dw_Plan.GetRow(), "IMO_Number"))

For li_Tasks = 1 to lds_VslInsp.RowCount()
	li_NewRow = lds_CalData.InsertRow(0)	
	ls_ModelName = lds_VslInsp.GetItemString(li_Tasks, "Modelname")
	lds_CalData.SetItem(li_NewRow, "Taskname", ls_ModelName)
	lds_CalData.SetItem(li_NewRow, "Shortname", lds_VslInsp.GetItemString(li_Tasks, "Shortname"))
	lds_CalData.SetItem(li_NewRow, "Color", rgb(192,192,192))
	lds_CalData.SetItem(li_NewRow, "StatColor", rgb(128,128,128))
	lds_CalData.SetItem(li_NewRow, "FromDate", lds_VslInsp.GetItemDateTime(li_Tasks, "InspDate"))
	lds_CalData.SetItem(li_NewRow, "ToDate", lds_VslInsp.GetItemDateTime(li_Tasks, "InspDate"))
	lds_CalData.SetItem(li_NewRow, "IsDue", 0)
	lds_CalData.SetItem(li_NewRow, "UserName", lds_VslInsp.GetItemString(li_Tasks, "FullName"))
	lds_CalData.SetItem(li_NewRow, "Vslname", ls_VslName)
	lds_CalData.SetItem(li_NewRow, "StatusVal", 3)
	li_NewRow = lds_VslInsp.GetItemNumber(li_Tasks, "Interval")
	If Not IsNull(li_NewRow) then
		If lds_VslInsp.Find("Modelname = '" + ls_ModelName + "'", li_Tasks + 1, lds_VslInsp.RowCount() + 1) = 0 then  // This is the latest insp of the type
			ld_Start = Date(f_AddMonths(lds_VslInsp.GetItemDateTime(li_Tasks, "InspDate"), li_NewRow))
			ls_ModelName += " - Due"			
			ld_Start = RelativeDate(ld_Start, -1)
			li_NewRow = lds_CalData.InsertRow(0)	
			lds_CalData.SetItem(li_NewRow, "Taskname", ls_ModelName)
			lds_CalData.SetItem(li_NewRow, "Shortname", lds_VslInsp.GetItemString(li_Tasks, "Shortname") + ' - Due')
			lds_CalData.SetItem(li_NewRow, "Color", rgb(255,192,192))
			lds_CalData.SetItem(li_NewRow, "StatColor", 16777215)
			lds_CalData.SetItem(li_NewRow, "FromDate", ld_Start)
			lds_CalData.SetItem(li_NewRow, "ToDate", RelativeDate(ld_Start, 2))
			lds_CalData.SetItem(li_NewRow, "IsDue", 1)
			lds_CalData.SetItem(li_NewRow, "UserName", "")
			lds_CalData.SetItem(li_NewRow, "Vslname", ls_VslName)
			lds_CalData.SetItem(li_NewRow, "StatusVal", 0)		
		End If
	End If
Next

OpenSheet(iw_WinCal, w_Main, 0, Original!)

lds_CalData.GetFullState(lb_blob)

iw_WinCal.uo_Cal.of_SetSourceData(lb_blob)

ld_Start = Date(f_AddMonths(DateTime(Today()), -3))

iw_WinCal.uo_Cal.of_SetStartDate(Month(ld_Start), Year(ld_Start))

iw_WinCal.uo_Cal.of_SetTitle("Vessel", ls_VslName, "Flag", ls_Flag)

iw_WinCal.uo_Cal.of_DrawCalender()

end event

type cb_print from commandbutton within w_plan
integer x = 1755
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print  >"
end type

event clicked;
im_Print.PopMenu(Parent.x + Parent.Pointerx(), Parent.y + Parent.Pointery())
end event

type cb_stat from commandbutton within w_plan
boolean visible = false
integer x = 2889
integer y = 1760
integer width = 311
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Due ?"
end type

event clicked;
OpenSheet(w_planhelp, w_Main, 0, Original!)
end event

type cb_edit from commandbutton within w_plan
integer x = 73
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Edit..."
end type

event clicked;
Open(w_PlanSetting)
end event

type cb_close from commandbutton within w_plan
integer x = 2377
integer y = 1712
integer width = 311
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type dw_plan from datawindow within w_plan
event ue_mousemove pbm_dwnmousemove
integer x = 73
integer y = 192
integer width = 3163
integer height = 1344
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_plan"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If (dwo.type = "text") then
	If (Left(dwo.tag, 1) <> "#") then Return
	is_sort = dwo.Tag
	if right(is_sort,1) = "A" then 
		is_sort = replace(is_sort, len(is_sort),1, "D")
	else
		is_sort = replace(is_sort, len(is_sort),1, "A")
	end if
	dwo.Tag = is_sort 
	this.SetSort(is_sort + ", #3 A")
	this.Sort()	
End if

If dwo.type = "column" and row>0 then
	
	If dwo.tag = "Reject" then Post wf_OpenReject(This.GetItemNumber(row, "IMO_Number"))
		
	If dwo.tag = "ReqNote" then
		g_Obj.Level = 1
		g_Obj.ObjString = This.GetItemString(row, "Req")
		g_Obj.SQL = This.GetItemString(row, "ReqNote")
		Post Open(w_PlanNotes)
	End If
End If

end event

event doubleclicked;
If row = 0 then Return

If cb_edit.Enabled then cb_Edit.event Clicked( )
end event

event retrieveend;
If rowcount = 0 then
	cb_cal.Enabled = False
	cb_poc.Enabled = False
	cb_find.Enabled = False
	cb_edit.Enabled = False
Else
	cb_cal.Enabled = True
	cb_poc.Enabled = True
	cb_find.Enabled = True
	If g_Obj.Access >= 2 then cb_Edit.Enabled = True  // Read/Write or higher
End If
end event

event rowfocuschanged;
// PB Bug - Detail background colour does not refresh when using arrow keys to select rows

// Workaround: This must be done to refresh the row colors when using arrow keys to navigate

This.SetRedraw(False)
This.SetRedraw(True)
end event

type gb_main from groupbox within w_plan
integer x = 18
integer y = 16
integer width = 3346
integer height = 1888
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel List"
end type

