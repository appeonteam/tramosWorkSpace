$PBExportHeader$w_rep.srw
forward
global type w_rep from window
end type
type cb_port from commandbutton within w_rep
end type
type cb_type from commandbutton within w_rep
end type
type gb_3 from groupbox within w_rep
end type
type cb_rawhelp from commandbutton within w_rep
end type
type cbx_excel from checkbox within w_rep
end type
type cbx_rejstatus from checkbox within w_rep
end type
type st_insptip from statictext within w_rep
end type
type sle_insp from singlelineedit within w_rep
end type
type cbx_reason from checkbox within w_rep
end type
type dw_reason from datawindow within w_rep
end type
type cbx_na from checkbox within w_rep
end type
type cbx_ns from checkbox within w_rep
end type
type cbx_no from checkbox within w_rep
end type
type cbx_yes from checkbox within w_rep
end type
type st_11 from statictext within w_rep
end type
type cbx_sql from checkbox within w_rep
end type
type cb_reset from commandbutton within w_rep
end type
type em_sub from editmask within w_rep
end type
type st_10 from statictext within w_rep
end type
type cbx_incomp from checkbox within w_rep
end type
type sle_desc from singlelineedit within w_rep
end type
type st_9 from statictext within w_rep
end type
type sle_title from singlelineedit within w_rep
end type
type st_8 from statictext within w_rep
end type
type cbx_hidefilter from checkbox within w_rep
end type
type dw_insp from datawindow within w_rep
end type
type cbx_insp from checkbox within w_rep
end type
type cbx_rep from checkbox within w_rep
end type
type ddlb_def from dropdownlistbox within w_rep
end type
type st_7 from statictext within w_rep
end type
type ddlb_close from dropdownlistbox within w_rep
end type
type st_6 from statictext within w_rep
end type
type dw_risk from datawindow within w_rep
end type
type dw_cause from datawindow within w_rep
end type
type dw_resp from datawindow within w_rep
end type
type cbx_det from checkbox within w_rep
end type
type cbx_port from checkbox within w_rep
end type
type dw_comp from datawindow within w_rep
end type
type dw_im from datawindow within w_rep
end type
type dw_yard from datawindow within w_rep
end type
type dw_flag from datawindow within w_rep
end type
type dw_vtype from datawindow within w_rep
end type
type dw_pc from datawindow within w_rep
end type
type dw_vslname from datawindow within w_rep
end type
type st_5 from statictext within w_rep
end type
type rb_bet from radiobutton within w_rep
end type
type dp_2 from datepicker within w_rep
end type
type cbx_yard from checkbox within w_rep
end type
type sle_insptype from singlelineedit within w_rep
end type
type st_4 from statictext within w_rep
end type
type cbx_cause from checkbox within w_rep
end type
type cbx_resp from checkbox within w_rep
end type
type cbx_risk from checkbox within w_rep
end type
type st_3 from statictext within w_rep
end type
type cbx_comp from checkbox within w_rep
end type
type dp_1 from datepicker within w_rep
end type
type rb_bef from radiobutton within w_rep
end type
type rb_aft from radiobutton within w_rep
end type
type cbx_date from checkbox within w_rep
end type
type cbx_im from checkbox within w_rep
end type
type st_2 from statictext within w_rep
end type
type cbx_flag from checkbox within w_rep
end type
type cbx_type from checkbox within w_rep
end type
type cbx_pc from checkbox within w_rep
end type
type cbx_vname from checkbox within w_rep
end type
type st_1 from statictext within w_rep
end type
type cb_close from commandbutton within w_rep
end type
type cb_gen from commandbutton within w_rep
end type
type gb_1 from groupbox within w_rep
end type
type gb_2 from groupbox within w_rep
end type
type lb_rep from listbox within w_rep
end type
type st_imtip from statictext within w_rep
end type
type ddlb_rej from dropdownlistbox within w_rep
end type
type st_hideitems from statictext within w_rep
end type
type dw_port from datawindow within w_rep
end type
type st_tiphead from statictext within w_rep
end type
type st_tip from statictext within w_rep
end type
end forward

global type w_rep from window
integer width = 3858
integer height = 2328
boolean titlebar = true
string title = "Report Generator"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Rep.ico"
boolean center = true
event ue_retrieve ( )
event ue_contextmenu ( integer ai_menusel )
cb_port cb_port
cb_type cb_type
gb_3 gb_3
cb_rawhelp cb_rawhelp
cbx_excel cbx_excel
cbx_rejstatus cbx_rejstatus
st_insptip st_insptip
sle_insp sle_insp
cbx_reason cbx_reason
dw_reason dw_reason
cbx_na cbx_na
cbx_ns cbx_ns
cbx_no cbx_no
cbx_yes cbx_yes
st_11 st_11
cbx_sql cbx_sql
cb_reset cb_reset
em_sub em_sub
st_10 st_10
cbx_incomp cbx_incomp
sle_desc sle_desc
st_9 st_9
sle_title sle_title
st_8 st_8
cbx_hidefilter cbx_hidefilter
dw_insp dw_insp
cbx_insp cbx_insp
cbx_rep cbx_rep
ddlb_def ddlb_def
st_7 st_7
ddlb_close ddlb_close
st_6 st_6
dw_risk dw_risk
dw_cause dw_cause
dw_resp dw_resp
cbx_det cbx_det
cbx_port cbx_port
dw_comp dw_comp
dw_im dw_im
dw_yard dw_yard
dw_flag dw_flag
dw_vtype dw_vtype
dw_pc dw_pc
dw_vslname dw_vslname
st_5 st_5
rb_bet rb_bet
dp_2 dp_2
cbx_yard cbx_yard
sle_insptype sle_insptype
st_4 st_4
cbx_cause cbx_cause
cbx_resp cbx_resp
cbx_risk cbx_risk
st_3 st_3
cbx_comp cbx_comp
dp_1 dp_1
rb_bef rb_bef
rb_aft rb_aft
cbx_date cbx_date
cbx_im cbx_im
st_2 st_2
cbx_flag cbx_flag
cbx_type cbx_type
cbx_pc cbx_pc
cbx_vname cbx_vname
st_1 st_1
cb_close cb_close
cb_gen cb_gen
gb_1 gb_1
gb_2 gb_2
lb_rep lb_rep
st_imtip st_imtip
ddlb_rej ddlb_rej
st_hideitems st_hideitems
dw_port dw_port
st_tiphead st_tiphead
st_tip st_tip
end type
global w_rep w_rep

type prototypes
//Private Function Long RMC_CreateChart(Long nParentHndl, Long nCtrlId, Long nX, Long nY, Long nWidth, Long nHeight, Long nBackColor, Long nCtrlStyle, Long nExportOnly, Ref String sBgImage, Ref String sFontName, Long nToolTipWidth, Long nBitmapBKColor) Library "RMChart.dll"

Private Function Long GetTempPath(Long nBufferLength, ref String lpBuffer) Library "Kernel32.dll" Alias For "GetTempPathA;ansi"

Private Function Long GetLongPathName(ref String ShortPath, ref String LongPath, Long BufferSize) Library "Kernel32.dll" Alias For "GetLongPathNameA;ansi"
end prototypes

type variables

Long il_White, il_Gray
String is_Where

Integer ii_Def, ii_Close, ii_RepNum, ii_TypeSel=0, ii_Country=0

Boolean ibool_TipVisible

m_repgen im_rep

end variables

forward prototypes
public subroutine wf_populatefilter (ref datawindowchild adwc_filter)
public subroutine wf_setsubtype (integer ai_max)
public subroutine wf_generatetrendgraph (datawindow adw_graph, datastore ads_data, string as_title, string as_desc)
public subroutine wf_processdw (ref checkbox acbx_box, ref datawindow adw_arg, string as_id, string as_dbid, integer ai_idtype, string as_table, boolean abool_includenull)
public subroutine wf_setportfilters (boolean ab_byport)
public subroutine wf_settypefilter (byte ai_table)
end prototypes

event ue_retrieve();
dw_vslname.SetTransObject(SQLCA)
dw_pc.SetTransObject(SQLCA)
dw_vtype.SetTransObject(SQLCA)
dw_flag.SetTransObject(SQLCA)
dw_yard.SetTransObject(SQLCA)
dw_im.settransobject(SQLCA)
dw_comp.SetTransObject(SQLCA)
dw_port.SetTransObject(SQLCA)
dw_insp.SetTransObject(SQLCA)
dw_resp.SetTransObject(SQLCA)
dw_Cause.SetTransObject(SQLCA)
dw_Reason.SetTransObject(SQLCA)

dw_vslname.Retrieve( )
dw_pc.Retrieve( )
dw_vtype.Retrieve( )
dw_flag.Retrieve( )
dw_Yard.Retrieve( )
dw_IM.Retrieve( )
dw_Comp.Retrieve( )
dw_Port.Retrieve( )
dw_Insp.Retrieve( )
dw_Resp.Retrieve( )
dw_Cause.Retrieve( )
dw_Reason.Retrieve( )

il_gray = 15790320
il_White = 16777215

ddlb_close.Selectitem(1)
ddlb_def.SelectItem(3)
ddlb_Rej.SelectItem(1)

dp_1.Value = DateTime(Today())
dp_2.Value = DateTime(Today())

ii_Repnum = 0
ii_Def = 3

If (g_Obj.DeptID = 1) and (g_obj.Access > 1) then cbx_InComp.Enabled = True

If g_obj.Deptid > 1 then cbx_hidefilter.Enabled = False
end event

event ue_contextmenu(integer ai_menusel);
Choose Case ai_MenuSel
	Case 0 // Vessel Type
		wf_SetTypeFilter(0)
		im_rep.m_byvesseltype.checked=true
		im_rep.m_byvettingoffice.checked=false
		im_rep.m_byfleetgroup.checked=false
	Case 1 // Vetting Office
		wf_SetTypeFilter(1)
		im_rep.m_byvettingoffice.checked=true
		im_rep.m_byfleetgroup.checked=false
      im_rep.m_byvesseltype.checked=false
	Case 2 // Fleet Group
		wf_SetTypeFilter(2)
		im_rep.m_byfleetgroup.checked=true
		im_rep.m_byvesseltype.checked=false
		im_rep.m_byvettingoffice.checked=false
	Case 10  // Port
		wf_SetPortFilters(True)
		im_rep.m_byport.checked=true
		im_rep.m_bycountry.checked=false
	Case 11  // Country
		wf_SetPortFilters(False)
		im_rep.m_bycountry.checked=true
		im_rep.m_byport.checked=false
End Choose
end event

public subroutine wf_populatefilter (ref datawindowchild adwc_filter);String ls_Sel
Integer li_Count

adwc_filter.Reset( )

If cbx_vname.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_vslname.RowCount()
		If dw_vslname.IsSelected(li_Count) then ls_Sel += dw_vslname.GetItemString(li_Count, "Vessel_name") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Vessels:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_pc.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_pc.RowCount()
		ls_Sel += dw_pc.GetItemString(li_Count, "Pc_name") + ", "		
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Profit Center:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_type.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_vtype.RowCount()
		If dw_vtype.IsSelected(li_Count) then 
			Choose Case ii_TypeSel
				Case 0  // By Vessel Type
 					ls_Sel += dw_vtype.GetItemString(li_Count, "Type_Name") + ", "
				Case 1  // By Vetting Office
					 ls_Sel += dw_vtype.GetItemString(li_Count, "OfficeName") + ", "
				Case 2  // By Fleetgroup
					 ls_Sel += dw_vtype.GetItemString(li_Count, "FGName") + ", "
			End Choose
		End If
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	Choose Case ii_TypeSel
		Case 0
			adwc_filter.SetItem(li_Count, "fType", "Vessel Type:")
		Case 1
			adwc_filter.SetItem(li_Count, "fType", "Vetting Office:")
		Case 2
			adwc_filter.SetItem(li_Count, "fType", "Fleet Group:")
	End Choose
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_flag.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_flag.RowCount()
		If dw_flag.IsSelected(li_Count) then ls_Sel += dw_flag.GetItemString(li_Count, "Country") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Flag:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Yard.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Yard.RowCount()
		If dw_Yard.IsSelected(li_Count) then ls_Sel += dw_Yard.GetItemString(li_Count, "Yardname") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Yard:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If ii_Repnum = 9 then Return

If cbx_im.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_im.RowCount()
		If dw_im.IsSelected(li_Count) then ls_Sel += dw_im.GetItemString(li_Count, "imname") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Type:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Comp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Comp.RowCount()
		If dw_Comp.IsSelected(li_Count) then ls_Sel += dw_Comp.GetItemString(li_Count, "Comp_name") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Company:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Port.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Port.RowCount()
		If dw_Port.IsSelected(li_Count) then 
			If ii_Country=0 then	ls_Sel += dw_Port.GetItemString(li_Count, "Port_n") + ", " Else ls_Sel += dw_Port.GetItemString(li_Count, "CName") + ", "
		End If
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	If ii_Country=0 then	adwc_filter.SetItem(li_Count, "fType", "Insp. Port:") Else adwc_filter.SetItem(li_Count, "fType", "Insp. Country:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_insp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_insp.RowCount()
		If dw_insp.IsSelected(li_Count) then ls_Sel += dw_insp.GetItemString(li_Count, "fname") + "; "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Inspectors:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_date.Checked then
	If rb_aft.Checked then ls_Sel = "After "
	If rb_bef.Checked then ls_Sel = "Before "
	If rb_bet.Checked then ls_Sel = "Between "
	ls_Sel += String(dp_1.Value, "dd mmm yyyy")
	if rb_bet.checked then ls_Sel += " and " + String(dp_2.Value, "dd mmm yyyy")
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Date:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Det.Checked then
	ls_Sel = "Vessel Detention"
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Vsl Detention:")
	adwc_filter.SetItem(li_Count, "fSelect", "Yes")
End If

If cbx_RejStatus.Checked then
	ls_Sel = ddlb_Rej.Text + " Rejections Only"
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Status:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If
	
If cbx_Risk.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Risk.RowCount()
		If dw_Risk.IsSelected(li_Count) then ls_Sel += dw_Risk.GetItemString(li_Count, "risktext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Item Risk:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Resp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Resp.RowCount()
		If dw_Resp.IsSelected(li_Count) then ls_Sel += dw_Resp.GetItemString(li_Count, "resptext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Item Resp:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Cause.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Cause.RowCount()
		If dw_Cause.IsSelected(li_Count) then ls_Sel += dw_Cause.GetItemString(li_Count, "causetext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Cause:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If ii_close > 1 then 
	If ii_close = 2 then ls_Sel = "Open Items Only" else ls_Sel = "Closed Items Only" 
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Status:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If ii_def = 1 then ls_Sel = "Valid Obs Only"
If ii_def = 2 then ls_Sel = "Non-Valid Obs Only" 
If ii_def = 3 then ls_Sel = "Valid and Non-Valid Obs" 
li_Count = adwc_filter.Insertrow(0)
adwc_filter.SetItem(li_Count, "fType", "Valid/Non-Valid:")
adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)

end subroutine

public subroutine wf_setsubtype (integer ai_max);
// Set the sub-type of report

st_10.TextColor = 0   // Set label color to 'enabled'
em_sub.Enabled = True  // Enabled control
em_sub.Text = '1'  // Set value
em_sub.Minmax = '1 ~~ ' + String(ai_Max) // Set minmax values

end subroutine

public subroutine wf_generatetrendgraph (datawindow adw_graph, datastore ads_data, string as_title, string as_desc);// This function generates the entire trend analysis graph

uo_dwdraw l_Draw

Integer li_Loop, li_Height, li_Width, li_X, li_Y, li_MaxObsFactor = 1, li_NumMonths
Decimal ldec_Temp, ldec_Wid, ldec_Hgt
String ls_Temp

// Get sizes. Remember to change if you change X or Y axis position in DW.
li_Width = 980
li_Height = 510
li_X = 40
li_Y = 570

adw_graph.Dataobject = "d_rep_trend"
adw_graph.Modify("Datawindow.Print.Preview='Yes'")
adw_graph.Modify("t_5.text='" + as_Title + "'")
adw_graph.Modify("t_6.text='" + as_Desc + "'")

adw_Graph.SetRedraw(False)  // Disable redraw of DW

l_Draw = Create uo_dwdraw

// Get number of months and restrict to 2 years
li_NumMonths = ads_data.RowCount()
If li_NumMonths > 24 then li_NumMonths = 24

// Calc scale factor for Y Axis
li_MaxObsFactor = Int(ads_data.GetitemNumber(1, "MaxAvgObs") / 10)
If li_MaxObsFactor = 0 then li_MaxObsFactor = 1
			
// Draw Y Axis ticks, lines and write numbers
For li_Loop =  1 to 10
	ldec_Temp = li_Y - li_Loop * (li_Height / 10)
	l_Draw.DrawOnDW(adw_Graph, li_X - 5, ldec_Temp, 5, 0, 0, 1, 0)
	l_Draw.DrawOnDW(adw_Graph, li_X + 1, ldec_Temp, li_Width, 0, 2, 1, 14737632)
	l_Draw.WriteOnDW(adw_Graph, li_X - 20, ldec_Temp - 8, 13, 16, String(li_Loop * li_MaxObsFactor), 0, 1)
Next 

// Determine width of each month
ldec_Wid = (li_Width / li_NumMonths) // Calc width of each month
If ldec_Wid > 100 then ldec_Wid = 100  // Limit size of month to 100 pixels

// Draw X Axis ticks, and write months
For li_Loop = 1 to li_NumMonths	
	ls_Temp = ads_Data.GetItemString(li_Loop, "curmonth")
	ls_Temp = String(Date(Integer(Left(ls_Temp, 4)), Integer(Right(ls_Temp, 2)), 1), "mmm yy")
	l_Draw.DrawOnDW(adw_Graph, li_X + li_Loop * ldec_Wid, li_Y, 0, 5, 0, 1, 0)
	l_Draw.WriteOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid, li_Y + 2, ldec_Wid, 16, ls_Temp, 0, 2)
Next

// Draw Risk Boxes
For li_Loop = 1 to li_NumMonths
	ldec_Hgt = ads_Data.GetItemNumber(li_Loop, "highavg") / li_MaxObsFactor / 10 * li_Height  // Height of high risk
	ldec_Temp = li_Y - ldec_Hgt   // Y of high risk
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_hgt, 8421631)
	ldec_Hgt = ads_Data.GetItemNumber(li_Loop, "medavg") / li_MaxObsFactor / 10 * li_Height  // Height of medium risk
	ldec_Temp -= ldec_Hgt  // Y of medium risk
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_Hgt, 8454143)
	ldec_Hgt = ads_Data.GetItemNumber(li_Loop, "lowavg") / li_MaxObsFactor / 10 * li_Height  // Height of low risk
	ldec_Temp -= ldec_Hgt  // Y of low risk	
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_Hgt, 8454016)
Next

// Draw Trend Line and avg figures
For li_Loop = 1 to li_NumMonths - 1	
	ldec_Temp = li_Y - ads_Data.GetItemNumber(li_Loop, "obsavg") / li_MaxObsFactor / 10 * li_Height  // Y of trend line
	ldec_Hgt = li_Y - ads_Data.GetItemNumber(li_Loop + 1, "obsavg") / li_MaxObsFactor / 10 * li_Height - ldec_Temp  // Height of line segment
	l_Draw.DrawOnDW(adw_Graph, li_X + li_Loop * ldec_Wid - ldec_Wid / 2, ldec_Temp, ldec_Wid, ldec_Hgt, 0, 2, 16761024)
	l_Draw.WriteOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid, ldec_Temp - 15, ldec_Wid, 15, String(ads_Data.GetItemNumber(li_Loop, "obsavg"), "0.0"), 0, 2)
Next
ldec_Temp = li_Y - ads_Data.GetItemNumber(li_NumMonths, "obsavg") / li_MaxObsFactor / 10 * li_Height  // Y of trend line
l_Draw.WriteOnDW(adw_Graph, li_X + (li_NumMonths - 1) * ldec_Wid, ldec_Temp - 15, ldec_Wid, 15, String(ads_Data.GetItemNumber(li_Loop, "obsavg"), "0.0"), 0, 2)

Destroy l_Draw

adw_Graph.SetRedraw(True)   // Refresh DW
end subroutine

public subroutine wf_processdw (ref checkbox acbx_box, ref datawindow adw_arg, string as_id, string as_dbid, integer ai_idtype, string as_table, boolean abool_includenull);Integer li_Count, li_Sel
String ls_Clause

If not acbx_box.Checked then Return

ls_Clause = ""
li_Sel = 0

If as_Table > "" then as_dbid = as_Table + "." + as_dbid  // Add prefix if reqd

If ai_idtype = 1 then   // String ID
	// Join all string IDs in a string separated by commas
	For li_Count = 1 to adw_arg.RowCount()
		If adw_arg.IsSelected(li_Count) then 
			li_Sel++
			ls_Clause += "'" + adw_arg.GetItemString(li_Count, as_id) + "', "
		End If
	Next	
Else
	// Join all ID numbers in a string separated by commas
	For li_Count = 1 to adw_arg.RowCount()
		If adw_arg.IsSelected(li_Count) then 
			li_Sel++
			ls_Clause += String(adw_arg.GetItemNumber(li_Count, as_id)) + ", "
		End If
	Next
End If

// If nothing selected or all selected, de-select the checkbox and return
If (li_Sel = adw_arg.RowCount()) or (li_Sel = 0) then 
	acbx_box.Checked = False
	acbx_box.Event Clicked()
	Return
End If

ls_Clause = left(ls_Clause, Len(ls_Clause) - 2)  // remove last comma

If is_where > "" then is_Where += " and (" else is_Where = "("   // Check if where clause already exists

If abool_IncludeNull then is_Where += "("

If li_Sel = 1 then is_Where += as_dbid + " = " + ls_Clause + ")" else is_Where += as_dbid + " in (" + ls_Clause + "))"

If abool_IncludeNull then is_Where += " or (" + as_dbid + " is Null))"
	
end subroutine

public subroutine wf_setportfilters (boolean ab_byport);
If ab_ByPort then	
	dw_Port.DataObject = "d_sq_tb_rep_port" 
	cbx_Port.Text = "By Port:"
	ii_Country = 0
Else	
	dw_Port.DataObject = "d_sq_tb_rep_country"
	cbx_Port.Text = "By Country:"
	ii_Country = 1
End If

cbx_Port.Checked = False
cbx_Port.event clicked( )

dw_Port.SetTransobject(SQLCA)
dw_Port.Retrieve( )
end subroutine

public subroutine wf_settypefilter (byte ai_table);
Choose Case ai_Table
	Case 0
		dw_vType.DataObject = "d_sq_tb_rep_vtypelist" 
		cbx_Type.Text = "By Vessel Type:"
	Case 1
		dw_vType.DataObject = "d_sq_tb_rep_office" 
		cbx_Type.Text = "By Vetting Office:"
	Case 2
		dw_vType.DataObject = "d_sq_tb_rep_fg"
		cbx_Type.Text = "By Fleet Group:"
End Choose

ii_TypeSel = ai_Table

cbx_Type.Checked = False
cbx_Type.event clicked( )

dw_vType.SetTransobject(SQLCA)
dw_vType.Retrieve( )
end subroutine

on w_rep.create
this.cb_port=create cb_port
this.cb_type=create cb_type
this.gb_3=create gb_3
this.cb_rawhelp=create cb_rawhelp
this.cbx_excel=create cbx_excel
this.cbx_rejstatus=create cbx_rejstatus
this.st_insptip=create st_insptip
this.sle_insp=create sle_insp
this.cbx_reason=create cbx_reason
this.dw_reason=create dw_reason
this.cbx_na=create cbx_na
this.cbx_ns=create cbx_ns
this.cbx_no=create cbx_no
this.cbx_yes=create cbx_yes
this.st_11=create st_11
this.cbx_sql=create cbx_sql
this.cb_reset=create cb_reset
this.em_sub=create em_sub
this.st_10=create st_10
this.cbx_incomp=create cbx_incomp
this.sle_desc=create sle_desc
this.st_9=create st_9
this.sle_title=create sle_title
this.st_8=create st_8
this.cbx_hidefilter=create cbx_hidefilter
this.dw_insp=create dw_insp
this.cbx_insp=create cbx_insp
this.cbx_rep=create cbx_rep
this.ddlb_def=create ddlb_def
this.st_7=create st_7
this.ddlb_close=create ddlb_close
this.st_6=create st_6
this.dw_risk=create dw_risk
this.dw_cause=create dw_cause
this.dw_resp=create dw_resp
this.cbx_det=create cbx_det
this.cbx_port=create cbx_port
this.dw_comp=create dw_comp
this.dw_im=create dw_im
this.dw_yard=create dw_yard
this.dw_flag=create dw_flag
this.dw_vtype=create dw_vtype
this.dw_pc=create dw_pc
this.dw_vslname=create dw_vslname
this.st_5=create st_5
this.rb_bet=create rb_bet
this.dp_2=create dp_2
this.cbx_yard=create cbx_yard
this.sle_insptype=create sle_insptype
this.st_4=create st_4
this.cbx_cause=create cbx_cause
this.cbx_resp=create cbx_resp
this.cbx_risk=create cbx_risk
this.st_3=create st_3
this.cbx_comp=create cbx_comp
this.dp_1=create dp_1
this.rb_bef=create rb_bef
this.rb_aft=create rb_aft
this.cbx_date=create cbx_date
this.cbx_im=create cbx_im
this.st_2=create st_2
this.cbx_flag=create cbx_flag
this.cbx_type=create cbx_type
this.cbx_pc=create cbx_pc
this.cbx_vname=create cbx_vname
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_gen=create cb_gen
this.gb_1=create gb_1
this.gb_2=create gb_2
this.lb_rep=create lb_rep
this.st_imtip=create st_imtip
this.ddlb_rej=create ddlb_rej
this.st_hideitems=create st_hideitems
this.dw_port=create dw_port
this.st_tiphead=create st_tiphead
this.st_tip=create st_tip
this.Control[]={this.cb_port,&
this.cb_type,&
this.gb_3,&
this.cb_rawhelp,&
this.cbx_excel,&
this.cbx_rejstatus,&
this.st_insptip,&
this.sle_insp,&
this.cbx_reason,&
this.dw_reason,&
this.cbx_na,&
this.cbx_ns,&
this.cbx_no,&
this.cbx_yes,&
this.st_11,&
this.cbx_sql,&
this.cb_reset,&
this.em_sub,&
this.st_10,&
this.cbx_incomp,&
this.sle_desc,&
this.st_9,&
this.sle_title,&
this.st_8,&
this.cbx_hidefilter,&
this.dw_insp,&
this.cbx_insp,&
this.cbx_rep,&
this.ddlb_def,&
this.st_7,&
this.ddlb_close,&
this.st_6,&
this.dw_risk,&
this.dw_cause,&
this.dw_resp,&
this.cbx_det,&
this.cbx_port,&
this.dw_comp,&
this.dw_im,&
this.dw_yard,&
this.dw_flag,&
this.dw_vtype,&
this.dw_pc,&
this.dw_vslname,&
this.st_5,&
this.rb_bet,&
this.dp_2,&
this.cbx_yard,&
this.sle_insptype,&
this.st_4,&
this.cbx_cause,&
this.cbx_resp,&
this.cbx_risk,&
this.st_3,&
this.cbx_comp,&
this.dp_1,&
this.rb_bef,&
this.rb_aft,&
this.cbx_date,&
this.cbx_im,&
this.st_2,&
this.cbx_flag,&
this.cbx_type,&
this.cbx_pc,&
this.cbx_vname,&
this.st_1,&
this.cb_close,&
this.cb_gen,&
this.gb_1,&
this.gb_2,&
this.lb_rep,&
this.st_imtip,&
this.ddlb_rej,&
this.st_hideitems,&
this.dw_port,&
this.st_tiphead,&
this.st_tip}
end on

on w_rep.destroy
destroy(this.cb_port)
destroy(this.cb_type)
destroy(this.gb_3)
destroy(this.cb_rawhelp)
destroy(this.cbx_excel)
destroy(this.cbx_rejstatus)
destroy(this.st_insptip)
destroy(this.sle_insp)
destroy(this.cbx_reason)
destroy(this.dw_reason)
destroy(this.cbx_na)
destroy(this.cbx_ns)
destroy(this.cbx_no)
destroy(this.cbx_yes)
destroy(this.st_11)
destroy(this.cbx_sql)
destroy(this.cb_reset)
destroy(this.em_sub)
destroy(this.st_10)
destroy(this.cbx_incomp)
destroy(this.sle_desc)
destroy(this.st_9)
destroy(this.sle_title)
destroy(this.st_8)
destroy(this.cbx_hidefilter)
destroy(this.dw_insp)
destroy(this.cbx_insp)
destroy(this.cbx_rep)
destroy(this.ddlb_def)
destroy(this.st_7)
destroy(this.ddlb_close)
destroy(this.st_6)
destroy(this.dw_risk)
destroy(this.dw_cause)
destroy(this.dw_resp)
destroy(this.cbx_det)
destroy(this.cbx_port)
destroy(this.dw_comp)
destroy(this.dw_im)
destroy(this.dw_yard)
destroy(this.dw_flag)
destroy(this.dw_vtype)
destroy(this.dw_pc)
destroy(this.dw_vslname)
destroy(this.st_5)
destroy(this.rb_bet)
destroy(this.dp_2)
destroy(this.cbx_yard)
destroy(this.sle_insptype)
destroy(this.st_4)
destroy(this.cbx_cause)
destroy(this.cbx_resp)
destroy(this.cbx_risk)
destroy(this.st_3)
destroy(this.cbx_comp)
destroy(this.dp_1)
destroy(this.rb_bef)
destroy(this.rb_aft)
destroy(this.cbx_date)
destroy(this.cbx_im)
destroy(this.st_2)
destroy(this.cbx_flag)
destroy(this.cbx_type)
destroy(this.cbx_pc)
destroy(this.cbx_vname)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_gen)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.lb_rep)
destroy(this.st_imtip)
destroy(this.ddlb_rej)
destroy(this.st_hideitems)
destroy(this.dw_port)
destroy(this.st_tiphead)
destroy(this.st_tip)
end on

event open;
cbx_Sql.Visible = g_obj.Developer  // Only for dev purposes

im_Rep = Create m_repgen
im_Rep.m_byvesseltype.checked = True
im_Rep.m_byport.checked = True

This.Postevent("ue_retrieve")
end event

event close;
Destroy im_rep
end event

type cb_port from commandbutton within w_rep
integer x = 2542
integer y = 848
integer width = 73
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
im_Rep.m_byport.visible=True
im_Rep.m_bycountry.visible=True
im_Rep.m_byfleetgroup.visible=False
im_Rep.m_byvettingoffice.visible=False
im_Rep.m_byvesseltype.visible=False

im_Rep.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type cb_type from commandbutton within w_rep
integer x = 2542
integer y = 208
integer width = 73
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
im_Rep.m_byport.visible=False
im_Rep.m_bycountry.visible=False
im_Rep.m_byfleetgroup.visible=True
im_Rep.m_byvettingoffice.visible=True
im_Rep.m_byvesseltype.visible=True

im_Rep.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type gb_3 from groupbox within w_rep
boolean visible = false
integer x = 2066
integer y = 1344
integer width = 567
integer height = 112
integer taborder = 170
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type cb_rawhelp from commandbutton within w_rep
integer x = 695
integer y = 1968
integer width = 73
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;
Messagebox("Raw Excel Dump", "If this option is selected, the underlying unprocessed (raw) data used to generate the report will be exported directly to an Excel sheet and opened. In some cases, more than one sheet may be opened.~n~nThis option may not be available for complex reports.", Information!)
end event

type cbx_excel from checkbox within w_rep
integer x = 73
integer y = 1968
integer width = 475
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Raw Excel dump"
end type

type cbx_rejstatus from checkbox within w_rep
boolean visible = false
integer x = 3273
integer y = 1200
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Status"
end type

event clicked;
ddlb_Rej.Enabled = This.Checked
end event

type st_insptip from statictext within w_rep
boolean visible = false
integer x = 2670
integer y = 1456
integer width = 997
integer height = 192
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15793151
string text = "Type a few characters from the Inspector~'s name and press ~'Enter~'. The first name containing the characters will be selected."
boolean border = true
boolean focusrectangle = false
end type

type sle_insp from singlelineedit within w_rep
event ue_keydown pbm_keydown
integer x = 2670
integer y = 1360
integer width = 530
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If Key = KeyEnter! then This.event Modified( )
end event

event getfocus;
st_InspTip.Visible = (ii_RepNum <> 9)
end event

event losefocus;
st_InspTip.Visible = False
end event

event modified;
Integer li_Sel

li_Sel = dw_Insp.Find("Lower(fname) like '%" + Lower(Trim(This.text, True)) + "%'", 1, dw_Insp.RowCount())

dw_Insp.SelectRow(0, False)

If li_Sel = 0 Then
	cbx_Insp.Checked = False
Else
	dw_Insp.SelectRow(li_Sel, True)
	dw_Insp.ScrollToRow(li_Sel)
	cbx_Insp.Checked = True
End If
end event

type cbx_reason from checkbox within w_rep
boolean visible = false
integer x = 2670
integer y = 848
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Reason:"
end type

type dw_reason from datawindow within w_rep
boolean visible = false
integer x = 2670
integer y = 912
integer width = 530
integer height = 528
integer taborder = 150
string dataobject = "d_sq_tb_rep_reason"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_Reason.Checked then cbx_Reason.Checked = True

If (li_Sel = 0) and cbx_Reason.Checked then cbx_Reason.Checked = False
end event

type cbx_na from checkbox within w_rep
integer x = 3456
integer y = 1888
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "NA"
end type

type cbx_ns from checkbox within w_rep
integer x = 3200
integer y = 1888
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "NS"
end type

type cbx_no from checkbox within w_rep
integer x = 3456
integer y = 1824
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

type cbx_yes from checkbox within w_rep
integer x = 3200
integer y = 1824
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
end type

type st_11 from statictext within w_rep
integer x = 2725
integer y = 1824
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item Answer:"
boolean focusrectangle = false
end type

type cbx_sql from checkbox within w_rep
boolean visible = false
integer x = 73
integer y = 2128
integer width = 658
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Copy SQL to clipboard"
end type

type cb_reset from commandbutton within w_rep
integer x = 3365
integer y = 32
integer width = 439
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset All Filters"
end type

event clicked;cbx_vname.Checked = False
cbx_vname.event clicked( )

cbx_pc.Checked = False
cbx_pc.event clicked( )

cbx_Type.Checked = False
cbx_Type.event clicked( )

cbx_Flag.Checked = False
cbx_Flag.event clicked( )

cbx_Yard.Checked = False
cbx_Yard.event clicked( )

cbx_Im.Checked = False
cbx_Im.event clicked( )
sle_insptype.Text = ""

cbx_comp.Checked = False
cbx_Comp.event clicked( )

cbx_Port.Checked = False
cbx_Port.event clicked( )

cbx_Insp.Checked = False
cbx_Insp.event clicked( )
sle_Insp.Visible = True
sle_Insp.Text = ""

cbx_Date.Checked = False
cbx_Date.event clicked( )

cbx_Det.Enabled = True
cbx_Det.Checked = False

cbx_Risk.Checked = False
cbx_Risk.event clicked( )

cbx_Resp.Checked = False
cbx_Resp.event clicked( )

cbx_Cause.Checked = False
cbx_Cause.event clicked( )

ddlb_close.Selectitem(1)
ii_Close = 1

ddlb_def.SelectItem(1)
ii_Def = 1

st_HideItems.Visible = False

If cbx_Rep.Enabled then cbx_Rep.Checked = False

cbx_incomp.Checked = False

lb_rep.selectitem(0)
sle_title.Text = ""
sle_desc.Text = ""
ii_RepNum = 0

cbx_no.Checked = True
cbx_Yes.Checked = False
cbx_NS.Checked = False
cbx_NA.Checked = False
end event

type em_sub from editmask within w_rep
integer x = 329
integer y = 1360
integer width = 183
integer height = 80
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#0"
boolean spin = true
double increment = 1
string minmax = "1~~4"
end type

type st_10 from statictext within w_rep
integer x = 73
integer y = 1376
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 67108864
string text = "Sub Type:"
boolean focusrectangle = false
end type

type cbx_incomp from checkbox within w_rep
integer x = 3273
integer y = 1376
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Under Review"
end type

type sle_desc from singlelineedit within w_rep
integer x = 73
integer y = 1728
integer width = 695
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 300
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_rep
integer x = 73
integer y = 1664
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descriptive Text:"
boolean focusrectangle = false
end type

type sle_title from singlelineedit within w_rep
integer x = 73
integer y = 1552
integer width = 695
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_8 from statictext within w_rep
integer x = 73
integer y = 1488
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Title:"
boolean focusrectangle = false
end type

type cbx_hidefilter from checkbox within w_rep
integer x = 73
integer y = 1856
integer width = 567
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide filters in report"
end type

type dw_insp from datawindow within w_rep
integer x = 2670
integer y = 912
integer width = 530
integer height = 448
integer taborder = 160
string dataobject = "d_sq_tb_rep_inspname"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_insp.Checked then cbx_insp.Checked = True

If (li_Sel = 0) and cbx_insp.Checked then cbx_insp.Checked = False
end event

type cbx_insp from checkbox within w_rep
integer x = 2670
integer y = 848
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Inspector:"
end type

event clicked;
If not This.Checked then dw_Insp.SelectRow(0, False)


end event

type cbx_rep from checkbox within w_rep
integer x = 2725
integer y = 2000
integer width = 818
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Knowledge Sharing Items Only"
end type

type ddlb_def from dropdownlistbox within w_rep
integer x = 3200
integer y = 1712
integer width = 549
integer height = 320
integer taborder = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Valid Only","Non-Valid only","All Obs"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Def = index
end event

type st_7 from statictext within w_rep
integer x = 2725
integer y = 1728
integer width = 466
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Obs Validity:"
boolean focusrectangle = false
end type

type ddlb_close from dropdownlistbox within w_rep
integer x = 3200
integer y = 1616
integer width = 549
integer height = 320
integer taborder = 230
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"All Items","Open Only","Closed Only"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Close = index

end event

type st_6 from statictext within w_rep
integer x = 2725
integer y = 1632
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Close-Out Status:"
boolean focusrectangle = false
end type

type dw_risk from datawindow within w_rep
integer x = 914
integer y = 1616
integer width = 530
integer height = 448
integer taborder = 200
string dataobject = "d_ext_rep_risk"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_risk.Checked then cbx_risk.Checked = True

If (li_Sel = 0) and cbx_risk.Checked then cbx_risk.Checked = False
end event

type dw_cause from datawindow within w_rep
integer x = 2085
integer y = 1616
integer width = 530
integer height = 448
integer taborder = 220
string dataobject = "d_sq_tb_rep_cause"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_cause.Checked then cbx_cause.Checked = True

If (li_Sel = 0) and cbx_cause.Checked then cbx_cause.Checked = False
end event

type dw_resp from datawindow within w_rep
integer x = 1499
integer y = 1616
integer width = 530
integer height = 448
integer taborder = 210
string dataobject = "d_sq_tb_rep_resp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_resp.Checked then cbx_resp.Checked = True

If (li_Sel = 0) and cbx_resp.Checked then cbx_resp.Checked = False
end event

type cbx_det from checkbox within w_rep
integer x = 3273
integer y = 1200
integer width = 434
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Detention"
end type

type cbx_port from checkbox within w_rep
integer x = 2085
integer y = 848
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Port:"
end type

event clicked;
If not This.Checked then dw_port.SelectRow(0, False)


end event

type dw_comp from datawindow within w_rep
integer x = 1499
integer y = 912
integer width = 530
integer height = 528
integer taborder = 120
string dataobject = "d_sq_tb_rep_comp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_comp.Checked then cbx_comp.Checked = True

If (li_Sel = 0) and cbx_comp.Checked then cbx_comp.Checked = False
end event

type dw_im from datawindow within w_rep
integer x = 914
integer y = 912
integer width = 530
integer height = 448
integer taborder = 110
string dataobject = "d_sq_tb_rep_im"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_im.Checked then cbx_im.Checked = True

If (li_Sel = 0) and cbx_im.Checked then cbx_im.Checked = False
end event

type dw_yard from datawindow within w_rep
integer x = 3255
integer y = 272
integer width = 530
integer height = 464
integer taborder = 100
string dataobject = "d_sq_tb_rep_yard"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_yard.Checked then cbx_yard.Checked = True

If (li_Sel = 0) and cbx_yard.Checked then cbx_yard.Checked = False
end event

type dw_flag from datawindow within w_rep
integer x = 2670
integer y = 272
integer width = 530
integer height = 464
integer taborder = 90
string dataobject = "d_sq_tb_rep_flag"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_flag.Checked then cbx_flag.Checked = True

If (li_Sel = 0) and cbx_flag.Checked then cbx_flag.Checked = False
end event

type dw_vtype from datawindow within w_rep
integer x = 2085
integer y = 272
integer width = 530
integer height = 464
integer taborder = 80
string dataobject = "d_sq_tb_rep_vtypelist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_type.Checked then cbx_type.Checked = True

If (li_Sel = 0) and cbx_type.Checked then cbx_type.Checked = False
end event

type dw_pc from datawindow within w_rep
integer x = 1499
integer y = 272
integer width = 530
integer height = 464
integer taborder = 60
string dataobject = "d_sq_tb_rep_pclist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_pc.Checked then cbx_pc.Checked = True

If (li_Sel = 0) and cbx_pc.Checked then cbx_pc.Checked = False
end event

type dw_vslname from datawindow within w_rep
integer x = 914
integer y = 272
integer width = 530
integer height = 464
integer taborder = 50
string dataobject = "d_sq_tb_rep_vsllist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_vname.Checked then cbx_vname.Checked = True

If (li_Sel = 0) and cbx_vname.Checked then cbx_vname.Checked = False
end event

type st_5 from statictext within w_rep
integer x = 3237
integer y = 1104
integer width = 91
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 67108864
boolean enabled = false
string text = "and"
boolean focusrectangle = false
end type

type rb_bet from radiobutton within w_rep
integer x = 3639
integer y = 928
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Bet"
boolean checked = true
end type

event clicked;
st_5.Visible = True
dp_2.Visible = True
end event

type dp_2 from datepicker within w_rep
integer x = 3346
integer y = 1088
integer width = 402
integer height = 80
integer taborder = 130
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2007-07-09"), Time("00:00:00.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dp_1.Value > dp_2.Value then dp_1.Value = dp_2.Value
end event

type cbx_yard from checkbox within w_rep
integer x = 3255
integer y = 208
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Yard:"
end type

event clicked;
If not This.Checked then dw_Yard.SelectRow(0, False)
end event

type sle_insptype from singlelineedit within w_rep
event ue_keydown pbm_keydown
integer x = 914
integer y = 1360
integer width = 530
integer height = 80
integer taborder = 150
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If Key = KeyEnter! then 
	This.event modified( )
	st_IMTip.Visible = False
End If
end event

event modified;
Integer li_Count, li_Sel
String ls_IM, ls_Search

ls_Search = Trim(sle_insptype.Text)

if ls_Search = "" then Return

li_Sel = 0

For li_Count = 1 to dw_im.Rowcount( )
	ls_IM = Upper(dw_im.GetItemString(li_Count, "IMNAME"))
	If Pos(ls_IM, ls_Search) > 0 then
		dw_im.SelectRow(li_Count, True) 
		li_Sel++
	Else 
		dw_im.SelectRow(li_Count, False)
	End If
Next

If li_Sel = 0 then cbx_Im.Checked = False else cbx_Im.Checked = True
end event

event getfocus;
st_IMTip.Visible = (ii_RepNum <> 9)
end event

event losefocus;
st_IMTip.Visible = False
end event

type st_4 from statictext within w_rep
integer x = 2670
integer y = 1552
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Options:"
boolean focusrectangle = false
end type

type cbx_cause from checkbox within w_rep
integer x = 2085
integer y = 1552
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Cause:"
end type

event clicked;
If not This.Checked then dw_cause.SelectRow(0, False)
end event

type cbx_resp from checkbox within w_rep
integer x = 1499
integer y = 1552
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Responsibility:"
end type

event clicked;
If not This.Checked then dw_resp.SelectRow(0, False)
end event

type cbx_risk from checkbox within w_rep
integer x = 914
integer y = 1552
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Risk:"
end type

event clicked;
If not This.Checked then dw_risk.SelectRow(0, False)
end event

type st_3 from statictext within w_rep
integer x = 859
integer y = 1472
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Items:"
boolean focusrectangle = false
end type

type cbx_comp from checkbox within w_rep
integer x = 1499
integer y = 848
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Company:"
end type

event clicked;
If not This.Checked then dw_Comp.SelectRow(0, False)


end event

type dp_1 from datepicker within w_rep
integer x = 3346
integer y = 1008
integer width = 402
integer height = 80
integer taborder = 170
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2007-07-09"), Time("00:00:00.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dp_1.Value > dp_2.Value then dp_2.Value = dp_1.Value
end event

type rb_bef from radiobutton within w_rep
integer x = 3291
integer y = 928
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Bef"
end type

event clicked;
st_5.Visible = False
dp_2.Visible = False
end event

type rb_aft from radiobutton within w_rep
integer x = 3474
integer y = 928
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Aft"
end type

event clicked;
st_5.Visible = False
dp_2.Visible = False
end event

type cbx_date from checkbox within w_rep
integer x = 3255
integer y = 848
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Date"
end type

event clicked;

rb_Bef.Enabled = This.Checked
rb_Aft.Enabled = This.Checked
rb_Bet.Enabled = This.Checked
dp_1.Enabled = This.Checked
dp_2.Enabled = This.Checked

If This.Checked then st_5.TextColor = 33554432 else st_5.TextColor = 134217745

end event

type cbx_im from checkbox within w_rep
integer x = 914
integer y = 848
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Type:"
end type

event clicked;
If not This.Checked then
	dw_IM.SelectRow(0, False)
	sle_insptype.Text = ""
End If

end event

type st_2 from statictext within w_rep
integer x = 859
integer y = 768
integer width = 503
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspections:"
boolean focusrectangle = false
end type

type cbx_flag from checkbox within w_rep
integer x = 2670
integer y = 208
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Flag:"
end type

event clicked;
If not This.Checked then dw_flag.SelectRow(0, False)

end event

type cbx_type from checkbox within w_rep
integer x = 2085
integer y = 208
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Vessel Type:"
end type

event clicked;
If not This.Checked then dw_vtype.SelectRow(0, False)
end event

type cbx_pc from checkbox within w_rep
integer x = 1499
integer y = 208
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Profit Center:"
end type

event clicked;
If not This.Checked then dw_pc.SelectRow(0, False)
end event

type cbx_vname from checkbox within w_rep
integer x = 914
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Name:"
end type

event clicked;
If not This.Checked then dw_vslname.SelectRow(0, False)
end event

type st_1 from statictext within w_rep
integer x = 859
integer y = 128
integer width = 503
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Selection:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_rep
integer x = 2377
integer y = 2128
integer width = 457
integer height = 96
integer taborder = 260
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)

end event

type cb_gen from commandbutton within w_rep
integer x = 987
integer y = 2128
integer width = 512
integer height = 96
integer taborder = 250
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generate"
end type

event clicked;
Integer li_Sub, li_Val[], li_Count
String ls_Clause, ls_dw, ls_dwc, ls_SQL, ls_Rep, ls_Data, ls_FinalSQL, ls_TempPath, ls_Prefix
DatawindowChild ldwc_child
DataStore lds_gr

If ii_RepNum = 0 then   // Nothing selected
	MessageBox("Report Selection", "Please select a report type!", Exclamation!)
	Return
End If

sle_title.Text = Trim(sle_title.Text, True)  // Trim down textboxes
sle_Desc.Text = Trim(sle_Desc.Text, True)

If sle_Title.Text = "" then   // Check report title
	MessageBox("Title Required", "The report requires a title. Please specify a title and description (optional) for the report.")
	sle_Title.Setfocus( )
	Return
End If

li_Sub = Integer(em_sub.Text)    // Get report subtype
ls_Prefix = "VETT_MASTER"

Choose Case ii_RepNum  // Choose on report type
	Case 1
		if mod(li_Sub,2) = 1 then ls_dw = "d_rep_chapstatrisk" else ls_dw = "d_rep_chapstatim"
		If (li_Sub < 1) or (li_Sub > 4) then li_Sub = 999
	Case 2
		ls_dw = "d_rep_general"
		If (li_Sub < 1) or (li_Sub > 8) then li_Sub = 999
	Case 3
		ls_dw = "d_rep_pie"
	Case 4
		ls_dw = "d_rep_vettstat"
	Case 5
		ls_dw = "d_rep_approval"
		If (li_Sub < 1) or (li_Sub > 2) then li_Sub = 999
	Case 6
		If li_Sub = 1 then ls_dw = "d_rep_exp1" else ls_dw = "d_rep_exp2"
		If (li_Sub < 1) or (li_Sub > 2) then li_Sub = 999
	Case 7
		ls_dw = "d_rep_itemstat"
		If (li_Sub < 1) or (li_Sub > 4) then li_Sub = 999
	Case 8
		ls_dw = "d_rep_monthly"
	Case 9
		ls_dw = "d_rep_benchmark"		
	Case 10
		ls_dw = "d_rep_trend"
		ls_Data = Upper(Left(g_Obj.AppFolder, 3))
	Case 11
		ls_dw = "d_rep_comparison"
	Case 12
		ls_dw = "d_rep_reject1"
		If (li_Sub < 1) or (li_Sub > 2) then li_Sub = 999		
		ls_Prefix = "VESSELS"
		cbx_Risk.Checked = False
		cbx_Resp.Checked = False
		cbx_Cause.Checked = False
		cbx_Port.Checked = False
		cbx_Insp.Checked = False
End Choose

If li_Sub = 999 then   // Invalid subtype
	MessageBox("Report Sub-Type", "An invalid report sub-type is selected. Please choose a valid sub-type")
	Return
End If

If g_Obj.TempFolder = "" and cbx_Excel.Checked Then
	MessageBox("Raw Excel Dump", "A temporary folder is not available. Raw excel dump cannot be performed.")
	cbx_Excel.Checked = False
End If

SetPointer(HourGlass!)

ls_Rep = ""
is_Where = ""

// Process all DW

wf_processdw(cbx_vname, dw_vslname, "Vessel_ID", "VESSEL_ID", 0, ls_Prefix, False)
wf_processdw(cbx_pc, dw_pc, "pc_nr", "PC_NR", 0, ls_Prefix, False)
Choose case ii_TypeSel
	Case 0
		wf_processdw(cbx_type, dw_vtype, "type_id", "VETT_TYPE", 0, ls_Prefix, False)	
	Case 1
		wf_processdw(cbx_type, dw_vtype, "Vett_officeid", "VETT_OFFICEID", 0, ls_Prefix, False)	
	Case 2
		wf_processdw(cbx_type, dw_vtype, "fgid", "VETT_FLEETGROUPID", 0, ls_Prefix, False)
End Choose
wf_processdw(cbx_flag, dw_flag, "country_id", "VSLFLAG", 0, ls_Prefix, False)
wf_processdw(cbx_yard, dw_yard, "yard_id", "YARD_ID", 0, ls_Prefix, False)

If is_Where > "" then is_Where += " and "
is_Where += "(" + ls_Prefix + ".VETT_TYPE is not null)"

If ii_Repnum <> 9 then  // Ignore the following for benchmark report

	If ii_Repnum = 12 then ls_Prefix = "VETT_INSP"  // Special case for Rejection report	
	wf_processdw(cbx_im, dw_im, "im_id", "IM_ID", 0, ls_Prefix, False)
	If ii_Repnum = 12 then ls_Prefix = "VETT_COMP"  // Special case for Rejection report	
	wf_processdw(cbx_comp, dw_comp, "comp_id", "COMP_ID", 0, ls_Prefix, False)

	If ii_Country=0 Then	wf_processdw(cbx_port, dw_port, "port_code", "PORT", 1, "", True) Else wf_processdw(cbx_port, dw_port, "country_id", "VETT_MASTER.COUNTRY_ID", 0, "", True)
	wf_processdw(cbx_risk, dw_risk, "riskid", "RISK", 0, "", True)
	wf_processdw(cbx_resp, dw_resp, "resp_id", "RESP_ID", 0, "", True)
	wf_processdw(cbx_cause, dw_cause, "cause_id", "CAUSE_ID", 0, "", True)
	if ii_RepNum = 12 then wf_processdw(cbx_reason, dw_reason, "rsnid", "RSNID", 0, "VETT_REJECT", True) Else wf_processdw(cbx_insp, dw_insp, "fullnameid", "(INSP_FNAME+INSP_LNAME)", 1, "", True)

	If ii_RepNum <> 12 then
		If is_Where > "" then is_Where += " and "
		is_Where += "((REQTYPE > 0) or (REQTYPE is Null))" // Exclude all information items
	End If

	If cbx_date.Checked then
		If ii_RepNum = 12 then ls_Clause = "REJECTDATE" Else ls_Clause = "INSPDATE"  // For Rejection report
		If rb_aft.Checked then ls_Clause = "("+ls_Clause+" > '" + String(dp_1.Value, "dd mmm yyyy") + "')"
		If rb_bef.Checked then ls_Clause = "("+ls_Clause+" < '" + String(dp_1.Value, "dd mmm yyyy") + "')"
		If rb_bet.Checked then ls_Clause = "("+ls_Clause+" >= '" + String(dp_1.Value, "dd mmm yyyy") + "' and "+ls_Clause+" <= '" + String(dp_2.Value, "dd mmm yyyy") + "')"			
		is_Where += " and " + ls_Clause
	End If

	If cbx_Det.Checked then
		ls_Clause = "(VSLDET=1)"
		is_Where += " and " + ls_Clause
	End If
	
	If cbx_RejStatus.Checked And ii_RepNum=12 Then   // Only for rejection report
		is_Where += " and (ACCEPTDATE is "
		If Left(ddlb_Rej.Text, 8) = "Accepted" Then is_Where += "Not "
		is_Where += "Null)"
	End If

	If ii_Close > 1 then
		If ii_Close = 2 then ls_Clause = "((CLOSED = 0) or (CLOSED is Null))"
		If ii_Close = 3 then ls_Clause = "((CLOSED = 1) or (CLOSED is Null))"
		If ii_RepNum <> 12 then is_Where += " and " + ls_Clause
	End If
	
	If ii_Def < 3 then
		If ii_Def = 1 then ls_Clause = "((DEF = 1) or (DEF is Null))"
		If ii_Def = 2 then ls_Clause = "((DEF = 0) or (DEF is Null))"
		If ii_RepNum <> 12 then is_Where += " and " + ls_Clause
	End If
	
	If Not cbx_incomp.Checked then 
		ls_Clause = "(COMPLETED = 1)"
		If ii_RepNum <> 12 then is_Where += " and " + ls_Clause	
	End If
	
	If cbx_Rep.Checked then ls_Rep = " and (REPORT = 1)" else ls_Rep = ""
		
	ls_Clause = "((ANS is Null)"
	If cbx_No.Checked then ls_Clause += " or (ANS = 1)"
	If cbx_Yes.Checked then ls_Clause += " or (ANS = 0)"
	If cbx_NS.Checked then ls_Clause += " or (ANS = 2)"
	If cbx_NA.Checked then ls_Clause += " or (ANS = 3)"
	ls_Clause += ")"
	
	If Len(ls_Clause) = 15 then   // Nothing selected for answer
		MessageBox("Answer Selection", "At least one item answer must be selected!", Exclamation!)
		Return
	End If

	// If not all answers selected, add to where clause and is not Rejection report 
	If Not (cbx_No.Checked and cbx_Yes.Checked and cbx_NS.Checked and cbx_NA.Checked) and ii_RepNum<>12 then	is_Where += " and " + ls_Clause
End If

If (cbx_incomp.Enabled) and (not cbx_incomp.Checked) and (ii_Repnum <> 9) then   // Reminder
	If MessageBox("Reminder", "The checkbox 'Inspections - Under Review' is not selected. Are you sure you want to continue?", Question!, YesNo!) = 2 then Return
End If

// Point of no return  !!!!

// By now, is_Where contains the where clause for the filters with no leading 'and'
// Messagebox("is_Where", is_Where)

ls_FinalSQL = ""  // to hold all SQL (for debug purposes only)

OpenSheet(w_preview, w_main, 0, Original!)  // Open Report Preview
w_preview.dw_rep.DataObject = ls_dw   //  Set the master DW
w_preview.dw_rep.SetTransObject(SQLCA)   
w_preview.dw_rep.Retrieve(sle_Title.Text, sle_Desc.Text) // Retrieve master DW (does not retrieve child DWs)

If not cbx_HideFilter.Checked then  // Get filter child (if it exists) and populate it
	If w_preview.dw_rep.GetChild("dw_filter", ldwc_child) = 1 then wf_PopulateFilter(ldwc_child)
End If

Choose Case ii_RepNum    //  Set Select clauses for child reports and retrieve
	Case 1 // Chapter Statistics
		is_where = " and " + is_where
		If mod(li_Sub,2) = 1 then  // If by Risk
		  ls_SQL = "Select CHAPNUM, Sum(Case when (RISK = 0) then 1 else 0 end) as LOW,"&
        + "Sum(Case when (RISK = 1) then 1 else 0 end) as MED, Sum(Case when (RISK = 2) then 1 else 0 end) as HIGH"
		Else  // If by Insp Model
		  ls_SQL = "Select CHAPNUM, Sum(Case when (CharIndex('Pet', IMNAME)>0) then 1 else 0 end) as LOW,"&
        + "Sum(Case when (CharIndex('Gas', IMNAME)>0) then 1 else 0 end) as MED, Sum(Case when (CharIndex('Chem', IMNAME)>0) then 1 else 0 end) as HIGH"
		End If
		ls_SQL += " From VETT_MASTER Where (IMNAME like ('"
		If li_Sub < 3 then ls_SQL += "SIRE" else ls_SQL += "CDI"
		ls_SQL += "%')) and (CHAPNUM is not Null)" + is_where + " Group By CHAPNUM Order By CHAPNUM"
		w_preview.dw_rep.GetChild("dw_chap", ldwc_child)  // Get main child
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject		
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		If li_Sub > 2 then ldwc_child.Retrieve("CDI") else ldwc_child.Retrieve("SIRE")  // Retrieve child
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "ChapterStats.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "ChapterStats.xls", "", "", 3)
		End If
		w_preview.dw_rep.GetChild("dw_key", ldwc_child)  // Get other child
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		If li_Sub > 2 then ldwc_child.Retrieve("CDI") else ldwc_child.Retrieve("SIRE")  // Retrieve child
				
	Case 2 // General Report
		is_where = " and " + is_where
		If li_Sub < 8 then
			ls_SQL = "Select VETT_MASTER.CHAP, VETT_MASTER.CHAPNUM, VETT_MASTER.SECT,"& 
			 + "VETT_MASTER.SECTNUM, VETT_MASTER.QPAR1, VETT_MASTER.QPARNUM1,"&
			 + "VETT_MASTER.QPAR2, VETT_MASTER.QNAME,"&
			 + "VETT_MASTER.QNUM, VETT_MASTER.INSPCOMM, VETT_MASTER.OWNCOMM,"&
			 + "VETT_MASTER.FOLLOWUP,VETT_MASTER.DEF,"&
			 + "VETT_MASTER.RESPTEXT, VETT_MASTER.RISK, VETT_MASTER.CLOSED,"&
			 + "VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE, VETT_MASTER.IMNAME,"&   
			 + "VETT_MASTER.EDITION, VETT_MASTER.QPARNUM2, VETT_MASTER.QPAR3,"&
			 + "VETT_MASTER.QPARNUM3, INSPDATE, VETT_VSLTYPE.TYPE_NAME, EXTNUM,VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE FROM VETT_MASTER, VETT_VSLTYPE, VESSELS "&
			 + "Where (VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID) and (VESSELS.VESSEL_ID=VETT_MASTER.VESSEL_ID) and (ANS is not Null)"			
		Else
			ls_SQL = "SELECT CHAPNUM,SECTNUM,QPARNUM1,QPARNUM2,INSPCOMM,QPARNUM3,QNUM,EXTNUM,IMNAME,REQTYPE,VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE "&
          + "FROM VETT_MASTER JOIN VESSELS ON VESSELS.VESSEL_ID=VETT_MASTER.VESSEL_ID WHERE (ANS is not Null) and (VESSELS.VESSEL_ACTIVE=1)"
		End If
		ls_SQL += is_Where + ls_Rep
		If li_Sub < 4 then w_preview.dw_rep.object.dw_insp.dataobject = "d_sq_tb_inspgen2"	// Switch report
		If (li_Sub > 3) and (li_Sub < 8) then li_Sub -= 3  // To obtain correct retrieval argument
		If li_Sub = 8 then w_preview.dw_rep.object.dw_insp.dataobject = "d_sq_tb_inspectorcomm"  // Switch report
		w_preview.dw_rep.GetChild("dw_insp", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve(li_Sub) // Retrieve child
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "GeneralReport.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "GeneralReport.xls", "", "", 3)
		End If	
	Case 3 // Graphical report
		is_where = " and " + is_where
		
		ls_SQL = "Select Count(Distinct INSP_ID) as NUMINSP, Count(ANS) as NUMITEM,"&
		 + "Sum(Case RISK When 0 then 1 Else 0 End) as LOW,"&
		 + "Sum(Case RISK When 1 then 1 Else 0 End) as MED,"&
		 + "Sum(Case RISK When 2 then 1 Else 0 End) as HI,"&
		 + "VETT_VSLTYPE.TYPE_NAME as CATNAME FROM VETT_MASTER,"&
		 + "VETT_VSLTYPE Where (VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID) and (VESSEL_ACTIVE=1)"&
		 + is_where + " Group By VETT_VSLTYPE.TYPE_ID Order By VETT_VSLTYPE.TYPE_NAME"
		w_preview.dw_rep.GetChild("dw_type", ldwc_child)  // Get 1st child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		   		

		ls_SQL = "Select Count(Distinct INSP_ID) as NUMINSP, Count(ANS) as NUMITEM,"&
		 + "Sum(Case RISK When 0 then 1 Else 0 End) as LOW,"&
		 + "Sum(Case RISK When 1 then 1 Else 0 End) as MED,"&
		 + "Sum(Case RISK When 2 then 1 Else 0 End) as HI,"&		
		 + "COUNTRY_NAME as CATNAME FROM VETT_MASTER,"&
		 + "COUNTRY Where (VETT_MASTER.VSLFLAG = COUNTRY.COUNTRY_ID) and (VESSEL_ACTIVE=1)"&
		 + is_where + " Group By COUNTRY_NAME Order By COUNTRY_NAME"
		w_preview.dw_rep.GetChild("dw_flag", ldwc_child)  // Get 2nd child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		
		
		ls_SQL = "Select Count(ANS), VETT_COMP.NAME FROM VETT_MASTER,"&
		 + "VETT_COMP Where (VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID) and (VESSEL_ACTIVE=1)"&
		 + is_where + " Group By VETT_COMP.NAME Order By VETT_COMP.NAME ASC"
		w_preview.dw_rep.GetChild("dw_comp", ldwc_child)  // Get 3rd child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child	
					
		ls_SQL = "Select Count(ANS), (Case RISK When 0 Then 'Low' When 1 Then 'Medium' When 2 Then 'High' End) as RISK "&
		 + "From VETT_MASTER Where (ANS is not null) and (VESSEL_ACTIVE=1)" + is_where + " Group By RISK"
		w_preview.dw_rep.GetChild("dw_risk", ldwc_child)  // Get 4th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		
		
		ls_SQL = "Select Count(ANS), RESPTEXT "&
		 + "From VETT_MASTER Where (ANS is not null) and (VESSEL_ACTIVE=1)" + is_where + " Group By RESPTEXT Order By RESPTEXT"
		w_preview.dw_rep.GetChild("dw_resp", ldwc_child)  // Get 5th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		
  
		ls_SQL = "Select Count(ANS), CLOSED as ITEMSTATUS "&
		 + "From VETT_MASTER Where (ANS is not null) and (VESSEL_ACTIVE=1)" + is_where + " Group By CLOSED"
		w_preview.dw_rep.GetChild("dw_status", ldwc_child)  // Get 6th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child	

	Case 4 // Vetting Statistics
		is_where = " and " + is_where
		ls_SQL = "Select VESSELS.VESSEL_ID as VSLID, INSP_ID,"&   
       + "Count(ANS) as ITEMTOTAL,"&
       + "Sum(Case When (RISK=0) Then 1 Else 0 End) as LOWRISK,"&
       + "Sum(Case When (RISK=1) Then 1 Else 0 End) as MEDRISK,"&   
       + "Sum(Case When (RISK=2) Then 1 Else 0 End) as HIRISK,"&   
       + "Sum(Case When (RISK=0) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as LOWVSL,"&
       + "Sum(Case When (RISK=1) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as MEDVSL,"& 
       + "Sum(Case When (RISK=2) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as HIVSL,"&
       + "INSPDATE,IMNAME,VESSELS.VESSEL_NAME, VESSELS.VETT_SCORE,TYPE_NAME,LASTSIRE,LASTVSLSCORE,VSLDET FROM VETT_MASTER, VESSELS, VETT_VSLTYPE "&
       + "Where (VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID) and (VETT_VSLTYPE.TYPE_ID = VETT_MASTER.VETT_TYPE)" + is_where&
		 + " Group By VESSELS.VESSEL_ID,INSP_ID,INSPDATE,IMNAME,VESSEL_NAME,VETT_SCORE,TYPE_NAME,LASTSIRE,LASTVSLSCORE,VSLDET"
		w_preview.dw_rep.GetChild("dw_vstat", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ls_FinalSQL = ls_SQL
		ldwc_child.Retrieve( )  // Retrieve child	
		ldwc_child.Modify("lastvslscore.Color = '0 ~t If( lastvslscore >= " + String(g_obj.ScoreGreen) + ", 49152, If( lastvslscore >= " + String(g_obj.ScoreYellow ) + ", 49344, 255))'")
		ldwc_child.Modify("vett_score.Color = '0 ~t If( vett_score >= " + String(g_obj.ScoreGreen) + ", 49152, If( vett_score >= " + String(g_obj.ScoreYellow ) + ", 49344, 255))'")		
		ldwc_child.Modify("lastsire.color = '0 ~t If( Left(lastsire,1) <= ~"" + g_obj.InspGreen + "~", 49152, If(Left(lastsire,1) <=~"" + g_obj.InspYellow + "~", 49344, 192))'")
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "VettingStats.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "VettingStats.xls", "", "", 3)
		End If
			
	Case 5 // Inspection Summary
		ls_SQL = "Select TYPE_NAME, VESSEL_NAME, INSPDATE, EXPIRES,"&   
       + "IMNAME,EDITION,VETT_COMP.NAME,PORT_N,RATING,HASRATING,CREATED,TECH,"&
			 + "(Select PURPOSE_DESC from PURPOSE Where PURPOSE_CODE = VETT_MASTER.OPTYPE) as PURPOSE_DESC,"&
			 + "IsNull((Select Sum(Case When ANS = 1 Then 1 Else 0 End) from VETT_ITEM Where VETT_ITEM.INSP_ID = VETT_MASTER.INSP_ID),0) as OBS "&
       + "FROM VETT_MASTER Inner Join VESSELS On VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID "&
			 + "Inner Join VETT_VSLTYPE On VETT_VSLTYPE.TYPE_ID = VESSELS.VETT_TYPE "&
			 + "Inner Join VETT_COMP On VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID "&	
			 + "Left Outer Join USERS On CREATED=USERID "&
			 + "Left Outer Join VETT_DEPT On DEPT_ID=VETT_DEPT "&
       + "Where " + is_where&
		 + " Group By TYPE_NAME, VESSEL_NAME, INSPDATE, EXPIRES, IMNAME, EDITION, VETT_COMP.NAME, PORT_N, RATING, HASRATING, OPTYPE, INSP_ID,CREATED,TECH"&
		 + " Order By VETT_VSLTYPE.TYPE_NAME ASC,VESSELS.VESSEL_NAME ASC,INSPDATE ASC" 		 
		If li_Sub = 2 then w_preview.dw_rep.object.dw_appr.dataobject = "d_sq_tb_inspsummary"		 
		
		w_preview.dw_rep.GetChild("dw_appr", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child			
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "InspectionSummary.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "InspectionSummary.xls", "", "", 3)
		End If		
	Case 6  // Expense Reports
   	is_where = " and " + is_where	
		If li_Sub = 1 then
			ls_SQL = "Select VETT_COMP.NAME,INSP_ID,(Case When EXPENSE=0 Then Null Else EXPENSE End) EXPENSE,"& 
			 + "Sum(Case When ANS=1 Then 1 Else 0 End) as TOTALOBS,"&
			 + "Sum(Case When ANS=1 and DEF=1 Then 1 Else 0 End) as TOTALVALID "&
			 + "FROM VETT_COMP Inner Join VETT_MASTER On VETT_COMP.COMP_ID = VETT_MASTER.COMP_ID "&
			 + "Where (IMNAME not like 'Port%')" + is_where&
			 + " Group By VETT_COMP.NAME, INSP_ID, EXPENSE, SIRE, CDI"&
			 + " Order By SIRE DESC, CDI DESC, VETT_COMP.NAME"
			w_preview.dw_rep.GetChild("dw_expsum", ldwc_child)  // Get main child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ls_FinalSQL = ls_SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ldwc_child.Retrieve( )  // Retrieve child
			If cbx_Excel.checked Then
				ldwc_child.SaveAs(g_Obj.TempFolder + "ExpenseData1.xls", Excel8!, True)
				ShellExecute(Handle(This), "open", g_Obj.TempFolder + "ExpenseData1.xls", "", "", 3)
			End If
			
			ls_SQL = "Select VETT_COMP.NAME,PORT_N,Case When EXPENSE=0 Then Null Else EXPENSE End EXPENSE,"&  
	  		 + "Sum(Case When ANS=1 Then 1 Else 0 End) as TOTALOBS,"&
 			 + "Sum(Case When ANS=1 and DEF=1 Then 1 Else 0 End) as TOTALVALID,Count(Distinct INSP_ID) INSPCOUNT "&
			 + "FROM VETT_MASTER Inner Join VETT_COMP On VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID "&			 
			 + "Where (IM_ID <> 30)" + is_where&
			 + " Group By VETT_COMP.NAME, PORT_N, EXPENSE"&
			 + " Order By VETT_COMP.NAME, PORT_N" 		 		
			w_preview.dw_rep.GetChild("dw_exp", ldwc_child)  // Get main child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ls_FinalSQL += "~r~n~r~n" + ls_SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ldwc_child.Retrieve( )  // Retrieve child						 
			If cbx_Excel.checked Then
				ldwc_child.SaveAs(g_Obj.TempFolder + "ExpenseData2.xls", Excel8!, True)
				ShellExecute(Handle(This), "open", g_Obj.TempFolder + "ExpenseData2.xls", "", "", 3)
			End If
		Else
			ls_SQL = "Select TYPE_NAME,VESSEL_NAME,VETT_COMP.NAME,EXPENSE,INSPDATE,IMNAME,EDITION "&   
			 + "FROM VETT_MASTER, VETT_VSLTYPE, VESSELS, VETT_COMP "&
			 + "Where (VETT_COMP.COMP_ID = VETT_MASTER.COMP_ID) and "& 
			 + "( VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID ) and "&
			 + "( VETT_VSLTYPE.TYPE_ID = VETT_MASTER.VETT_TYPE ) and (IM_ID <> 30)" + is_where&
			 + " Group By TYPE_NAME,VESSEL_NAME,VETT_COMP.NAME,EXPENSE,INSPDATE,IMNAME,EDITION"&
			 + " Order By TYPE_NAME, VESSEL_NAME, INSPDATE" 		 				
			w_preview.dw_rep.GetChild("dw_exp", ldwc_child)  // Get main child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ls_FinalSQL = ls_SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ldwc_child.Retrieve( )  // Retrieve child		
			If cbx_Excel.checked Then
				ldwc_child.SaveAs(g_Obj.TempFolder + "ExpenseData.xls", Excel8!, True)
				ShellExecute(Handle(This), "open", g_Obj.TempFolder + "ExpenseData.xls", "", "", 3)
			End If
		End If
		
	Case 7 // Item Statistics
		is_where = " and " + is_where
		ls_SQL = "Select IMNAME, EDITION, CHAP, CHAPNUM, SECT, SECTNUM,QPAR1,QPARNUM1,"&   
       + "QPAR2,QPARNUM2,QPARNUM3,QPAR3,QNAME,QNUM "&
       + "FROM VETT_MASTER Where (QNUM is not null) " + is_where&
		 + " Order By CHAPNUM,SECTNUM,QPARNUM1,QPARNUM2,QPARNUM3,QNUM" 		 
		w_preview.dw_rep.GetChild("dw_istat", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		Choose Case li_Sub
			Case 1; ldwc_child.SetFilter( "")
			Case 2; ldwc_child.SetFilter( "repc>1")
			Case 3; ldwc_child.SetFilter( "repc>4")
			Case 4; ldwc_child.SetFilter( "repc>9")
		End Choose
		ldwc_child.Filter( )
		ldwc_child.Retrieve( )  // Retrieve child		
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "ItemStats.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "ItemStats.xls", "", "", 3)
		End If
	Case 8  // Monthly Report
		is_where = " and " + is_Where
		ls_SQL = "Select TYPE_NAME,VETT_MASTER.INSP_ID,"&   
       + "Sum(Case When RISK = 0 Then 1 Else 0 End) as LOW,"&
		 + "Sum(Case When RISK = 1 Then 1 Else 0 End) as MED,"&
		 + "Sum(Case When RISK = 2 Then 1 Else 0 End) as HIGH,"&
		 + "VETT_MASTER.INSPDATE, Count(VETT_MASTER.ANS) as ANS,"&
		 + "Sum(Case When RESPTEXT = 'Vessel' Then 1 Else 0 End) as VSLRESP "&
       + "FROM VETT_MASTER, VETT_VSLTYPE Where (VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID) And (VESSEL_ACTIVE=1)" + is_where&
		 + " Group By TYPE_NAME, INSP_ID, INSPDATE Order By TYPE_NAME" 		 
		w_preview.dw_rep.GetChild("dw_type", ldwc_child)  // Get first child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child					
		ls_SQL = "Select COUNTRY_NAME,VETT_MASTER.INSP_ID,"&   
       + "Sum(Case When RISK = 0 Then 1 Else 0 End) as LOW,"&
		 + "Sum(Case When RISK = 1 Then 1 Else 0 End) as MED,"&
		 + "Sum(Case When RISK = 2 Then 1 Else 0 End) as HIGH,"&
		 + "VETT_MASTER.INSPDATE, Count(VETT_MASTER.ANS) as ANS,"&
		 + "Sum(Case When RESPTEXT = 'Vessel' Then 1 Else 0 End) as VSLRESP "&
       + "FROM VETT_MASTER, COUNTRY Where (VETT_MASTER.VSLFLAG = COUNTRY.COUNTRY_ID) And (VESSEL_ACTIVE = 1) " + is_where&
		 + " Group By COUNTRY_NAME, INSP_ID, INSPDATE Order By COUNTRY_NAME" 		 
		w_preview.dw_rep.GetChild("dw_flag", ldwc_child)  // Get 2nd child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child			

		ls_Data = ldwc_child.GetItemString(1, "maxdate")
		
		If ls_Data > "" then
		
			ls_SQL = "Select INSP_ID, Max(INSPDATE) as IDATE,"&
			 + "Sum(Case When (RISK=0) Then 1 Else 0 End) as LOWRISK,"&
			 + "Sum(Case When (RISK=1) Then 1 Else 0 End) as MEDRISK,"&
			 + "Sum(Case When (RISK=2) Then 1 Else 0 End) as HIRISK,"&
			 + "Sum(Case When (RISK=0) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as LOWVSL,"&
			 + "Sum(Case When (RISK=1) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as MEDVSL,"&
			 + "Sum(Case When (RISK=2) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as HIVSL "&
			 + "From VETT_MASTER Where (VESSEL_ACTIVE=1) And (Month(INSPDATE)= " + Right(ls_Data,2) + ") and (Year(INSPDATE)=" + Left(ls_Data,4) + ")" + is_where + " Group By INSP_ID"
			w_preview.dw_rep.GetChild("dw_stat", ldwc_child)  // Get 3rd child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ls_FinalSQL += "~r~n~r~n" + ls_SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ldwc_child.Retrieve( )  // Retrieve child		
					
			ls_SQL = "Select Sum( Case When RISK=0 Then 1 Else 0 End) as LOWRISK,"&
			 + "Sum( Case When RISK=1 Then 1 Else 0 End) as MEDRISK,"&
			 + "Sum( Case When RISK=2 Then 1 Else 0 End) as HIGHRISK FROM VETT_MASTER Where (VESSEL_ACTIVE=1) And (Month(INSPDATE)= "&
			 + Right(ls_Data,2) + ") and (Year(INSPDATE)=" + Left(ls_Data,4) + ")" + is_where
			w_preview.dw_rep.GetChild("dw_risk", ldwc_child)  // Get 4th child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ls_FinalSQL += "~r~n~r~n" + ls_SQL
			ldwc_child.Retrieve( )  // Retrieve child						
					
			ls_SQL = "Select Count(ANS) as OBS, VETT_RESP.RESPTEXT "&
			 + "FROM VETT_MASTER, VETT_RESP Where (VESSEL_ACTIVE = 1) And (VETT_MASTER.RESP_ID =* VETT_RESP.RESP_ID) and (Month(INSPDATE)= "&
			 + Right(ls_Data,2) + ") and (Year(INSPDATE)=" + Left(ls_Data,4) + ")" + is_where + " Group By VETT_RESP.RESPTEXT"
			w_preview.dw_rep.GetChild("dw_resp", ldwc_child)  // Get 5th child
			ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
			ls_FinalSQL += "~r~n~r~n" + ls_SQL
			ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
			ldwc_child.Retrieve( )  // Retrieve child										
				
		End If		

	Case 9  // Benchmark
		If is_Where > "" then is_where = " and " + is_Where
		ls_SQL = "Select VESSEL_NAME,VETT_VSLTYPE.TYPE_NAME,"&
		 + "COUNTRY.COUNTRY_NAME,VETT_SCORE,"&
		 + "(Select Avg(VETT_SCORE) from VESSELS VSL Where VSL.VETT_TYPE = VETT_VSLTYPE.TYPE_ID) as TYPEAVG "&
       + "FROM VESSELS VETT_MASTER, COUNTRY, VETT_VSLTYPE Where (VETT_TYPE = VETT_VSLTYPE.TYPE_ID) "&
		 + "  and (VSLFLAG = COUNTRY.COUNTRY_ID ) And (VESSEL_ACTIVE = 1)" + is_where
		w_preview.dw_rep.GetChild("dw_bench", ldwc_child)  // Get first child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child					
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "Benchmark.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "Benchmark.xls", "", "", 3)
		End If
	Case 10  // Trend
		is_where = " Where " + is_Where
		ls_SQL = "Select Count(Distinct INSP_ID) as INSPCOUNT,"&
		 + "Sum(Case When RISK = 0 Then 1 Else 0 End) as LOW,"&
		 + "Sum(Case When RISK = 1 Then 1 Else 0 End) as MED,"&
		 + "Sum(Case When RISK = 2 Then 1 Else 0 End) as HIGH,"&
		 + "Count(VETT_MASTER.ANS) as OBS, Left(Convert(varChar, INSPDATE, 112), 6) as CURMONTH "&
       + "FROM VETT_MASTER " + is_where + " GROUP BY Left(Convert(varChar, INSPDATE, 112), 6) "&
	    + "ORDER BY Left(Convert(varChar, INSPDATE, 112), 6)" 
 
		lds_gr = Create DataStore
		lds_gr.DataObject = "d_sq_tb_trend"
 		li_Sub = lds_gr.SetSQLSelect(ls_SQL)
		ls_FinalSQL += ls_SQL
		li_Sub = lds_gr.SetTransObject(SQLCA)
		li_Sub = lds_gr.Retrieve( )
		

		If li_Sub > 0 then		 	
			If cbx_Excel.checked Then
				lds_gr.SaveAs(g_Obj.TempFolder + "TrendData.xls", Excel8!, True)
				ShellExecute(Handle(This), "open", g_Obj.TempFolder + "TrendData.xls", "", "", 3)
			End If
			wf_GenerateTrendGraph(w_preview.dw_Rep, lds_gr, sle_title.Text, sle_Desc.Text)
		Else
			w_preview.wf_ShowReport()
			Close(w_Preview)
			If cbx_Sql.Checked then Clipboard(ls_FinalSQL)
			Messagebox("Data Error", "No data was found based on selected filters. Cannot display the Trend graph.", Exclamation!)
			Return
		End If
   		
		Destroy lds_gr
		
	Case 11  // SIRE-MIRE comparison
		ls_SQL = "SELECT VETT_VSLTYPE.TYPE_NAME,VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE,VETT_MASTER.IMNAME,VETT_MASTER.EDITION,"&
		 + "VETT_COMP.NAME,VETT_MASTER.INSP_FNAME,VETT_MASTER.INSP_LNAME,(Count(ANS)) as OBS,"&
		 + "(Sum(Case When (RISK = 0) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VLOWRISK,"&
		 + "(Sum(Case When (RISK = 1) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VMEDRISK,"&
		 + "(Sum(Case When (RISK = 2) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VHIRISK,"&
		 + "(Sum(Case RISK When 0 Then 1 Else 0 End)) AS LOWRISK,(Sum(Case RISK When 1 Then 1 Else 0 End)) AS MEDRISK,(Sum(Case RISK When 2 Then 1 Else 0 End)) AS HIRISK,"&
		 + "VETT_MASTER.RATING,VETT_MASTER.VSLSCORE,VETT_MASTER.VESSEL_ID "&
       + "FROM VETT_MASTER, VETT_VSLTYPE, VESSELS, VETT_COMP Where ( VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID ) and "&
		 + " ( VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID ) and ( VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID ) and (VETT_MASTER.VESSEL_ACTIVE = 1) and " + is_where + " GROUP BY "&
		 + "VETT_VSLTYPE.TYPE_NAME,VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE,VETT_MASTER.IMNAME,VETT_MASTER.EDITION,VETT_COMP.NAME,VETT_MASTER.INSP_FNAME,VETT_MASTER.INSP_LNAME,"&
		 + "VETT_MASTER.RATING,VETT_MASTER.VSLSCORE,VETT_MASTER.VESSEL_ID "&
		 + "ORDER BY VETT_VSLTYPE.TYPE_NAME,VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE"
		w_preview.dw_rep.GetChild("dw_comparison", ldwc_child)  // Get first child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
		ldwc_child.Modify("vslscore.Color = '0 ~t If( vslscore >= " + String(g_obj.ScoreGreen) + ", 49152, If( vslscore >= " + String(g_obj.ScoreYellow ) + ", 49344, 255))'")
		ldwc_child.Modify("rating.color = '0 ~t If( Left(rating,1) <= ~"" + g_obj.InspGreen + "~", 49152, If(Left(rating,1) <=~"" + g_obj.InspYellow + "~", 49344, 192))'")
	
		w_preview.dw_rep.GetChild("dw_anomalies", ldwc_child)  // Get 2nd child
		ls_SQL = "SELECT VESSELS.VESSEL_NAME, VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME,Count(ANS) as ITEMCOUNT "&
		+ "FROM VETT_MASTER INNER JOIN VESSELS ON VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID WHERE (VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE = 1) and " + is_Where + " GROUP BY "&
		+ "VESSELS.VESSEL_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME "&
		+ "HAVING Count(ANS) > 1 ORDER BY VESSELS.VESSEL_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM"
		ldwc_child.SetSQLSelect(ls_SQL)   //  Set SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
         
		w_preview.dw_rep.GetChild("dw_highrisk", ldwc_child)  // Get 3rd child
		ls_SQL = "SELECT VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4) as IM_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME,Count(ANS) as ITEMCOUNT "&
		+ "FROM VETT_MASTER INNER JOIN VESSELS ON VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID WHERE (VETT_MASTER.QNUM is not Null) and (RISK = 2) and (VETT_MASTER.VESSEL_ACTIVE = 1) and " + is_Where + " GROUP BY "&
		+ "VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4),VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME "&
		+ "ORDER BY VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4),VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM"
		ldwc_child.SetSQLSelect(ls_SQL)   //  Set SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
		
		Case 12  // Rejection report
		
		If li_Sub = 1 Then			
			ls_SQL ="SELECT VETT_VSLTYPE.TYPE_NAME,VESSELS.VESSEL_NAME,VETT_COMP.NAME,VETT_REJREASON.REASON, VETT_REJECT.REJECTDATE, VETT_REJECT.ACCEPTDATE,VETT_INSPMODEL.NAME,VETT_REJECT.DETAILS,VETT_REJREASON.VETT_USED "&
			+ "FROM VETT_REJECT Inner Join VETT_REJREASON On VETT_REJREASON.RSNID = VETT_REJECT.RSNID "&
			+ "Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_REJECT.COMP_ID "&
			+ "Inner Join VESSELS on VETT_REJECT.VESSELIMO = VESSELS.IMO_NUMBER and VESSELS.VETT_TYPE is not Null "&
			+ "Inner Join VETT_VSLTYPE On VESSELS.VETT_TYPE = VETT_VSLTYPE.TYPE_ID "&
			+ "Left Outer Join VETT_INSP On VETT_INSP.INSP_ID = VETT_REJECT.INSP_ID "&
			+ "Left Outer Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID "&
			+ "Where " + is_Where + " ORDER BY VETT_VSLTYPE.TYPE_NAME ASC, VESSELS.VESSEL_NAME ASC"
		Else
			ls_SQL = "SELECT VESSELS.VESSEL_NAME, VETT_COMP.NAME, VETT_REJREASON.REASON, VETT_REJECT.REJECTDATE, VETT_REJECT.ACCEPTDATE, VETT_INSPMODEL.NAME , Month(REJECTDATE) RMONTH, Year(REJECTDATE) RYEAR,VETT_REJECT.DETAILS,VETT_REJREASON.VETT_USED "&
			+ "FROM VETT_REJECT Inner Join VETT_REJREASON On VETT_REJREASON.RSNID = VETT_REJECT.RSNID Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_REJECT.COMP_ID "&
         + "Inner Join VESSELS on VETT_REJECT.VESSELIMO = VESSELS.IMO_NUMBER and VESSELS.VETT_TYPE is not Null "&
	      + "Left Outer Join VETT_INSP On VETT_INSP.INSP_ID = VETT_REJECT.INSP_ID Left Outer Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID "&
			+ "Where " + is_Where + " ORDER BY VETT_REJECT.REJECTDATE ASC"
			w_preview.dw_rep.object.dw_reject.dataobject = "d_sq_tb_rejmonth" 
		End If
		
		w_preview.dw_rep.GetChild("dw_reject", ldwc_child)  // Get child		
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child						
		If cbx_Excel.checked Then
			ldwc_child.SaveAs(g_Obj.TempFolder + "Rejection.xls", Excel8!, True)
			ShellExecute(Handle(This), "open", g_Obj.TempFolder + "Rejection.xls", "", "", 3)
		End If
End Choose

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

w_preview.wf_ShowReport()

If cbx_Sql.Checked then Clipboard(ls_FinalSQL)
Clipboard(ls_FinalSQL)
end event

type gb_1 from groupbox within w_rep
event ue_mousemove pbm_mousemove
integer x = 37
integer y = 32
integer width = 768
integer height = 2064
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Type"
end type

event ue_mousemove;
If ibool_TipVisible then
	st_Tip.Visible = False
	st_TipHead.Visible = False
	ibool_TipVisible = False
End If
end event

type gb_2 from groupbox within w_rep
event ue_mousemove pbm_mousemove
integer x = 823
integer y = 32
integer width = 2999
integer height = 2064
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Filters"
end type

event ue_mousemove;If ibool_TipVisible then
	st_Tip.Visible = False
	st_TipHead.Visible = False
	ibool_TipVisible = False
End If
end event

type lb_rep from listbox within w_rep
integer x = 73
integer y = 128
integer width = 695
integer height = 1200
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"Chapter Statistics","General Report","Graphical Report","Vetting Statistics","Inspection Summary","Expense Report","Item Statistics","Monthly Report","Fleet Benchmark","Trend Analysis","SIRE/MIRE Comparison","Rejections"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_text
Integer li_TipHeight

ls_text = lb_rep.Selecteditem( )  // By default, set report title
st_HideItems.Visible = False
sle_title.Text = ls_Text
cbx_Rep.Enabled = False   //  Include non-report items
cbx_Rep.Checked = True 
st_10.Textcolor = 12632256  // Sub-Type label to be disabled
em_Sub.Enabled = False	 // Sub-Type selection disabled
em_sub.Text = "1"       // Sub-Type selected as 1
cbx_im.Enabled = True   // Inspection model checkbox to be enabled
dw_im.Enabled = True    // Inspection model DW to be enabled
dw_im.Modify("DataWindow.Color='16777215'" )  // Inspection Model DW back color to be white
sle_insptype.Enabled = True   // enable text box for model selection
sle_insptype.Text = ""        // empty text box
cbx_risk.Enabled = True       // Enable risk checkbox
If g_obj.Access = 3 then cbx_incomp.Enabled = True  // If superuser then allow to select un-reviewed inspection
cbx_incomp.Checked = False  // Don't include incomplete insp by default
ddlb_def.SelectItem(3)  // Valid-Obs only by default
ii_Def = 3
ddlb_Rej.visible = False
cbx_RejStatus.Visible = False
cbx_RejStatus.Checked = False
cbx_Det.Visible = True
ddlb_def.Enabled = True     // Enable Valid/non-valid selection
cbx_Det.Enabled = True
dw_Insp.Visible = True
cbx_Insp.Visible = True
sle_Insp.Visible = True
cbx_Reason.Visible = False
dw_Reason.Visible = False
cbx_Excel.Enabled = True
cbx_Excel.Checked = False

Choose Case ls_text
	Case "Chapter Statistics"
		ii_RepNum = 1
		cbx_im.Checked = False  // No inspection model selection
		cbx_im.event clicked( ) // Call event to de-select all rows in DW
		cbx_im.Enabled = False  // Disable checkbox
		dw_im.Enabled = False  // Disable DW
		dw_im.Modify("DataWindow.Color='14737632'")  // Change DW backcolor to gray
		sle_insptype.Enabled = False  // Disable model selection textbox
		wf_SetSubType(4)     // Set subreports
	Case "General Report"
		ii_RepNum = 2
		sle_title.Text = ""      // Remove report title
		cbx_Rep.Enabled = True   // Enable option to include non-report items
		cbx_Rep.Checked = False  // By default, do not include non-report items
		wf_SetSubType(8)          // Set subreports		
	Case "Graphical Report"
		ii_RepNum = 3
		sle_title.Text = ""      // Remove report title
		cbx_Excel.Enabled = False   // Disable Excel export (too many child DW)
	Case "Vetting Statistics"
		ii_Repnum = 4
		cbx_risk.Checked = False  // Remove risk selection by default
		cbx_risk.event Clicked( )	 // Call event to de-select all rows in DW
	Case "Inspection Summary"
		ii_Repnum = 5
		cbx_incomp.Checked = True		// Include incompete inspections by default
		ddlb_def.SelectItem(3)        // Include all observations
		ii_Def = 3
		wf_SetSubType(2)                // Set subreports
	Case "Expense Report"
		ii_Repnum = 6
		wf_SetSubType(2)                  // Set subreports
		cbx_incomp.Enabled = False        // Disable incomplete report selection
		cbx_incomp.Checked = True         // Include incomplete reports
		ddlb_def.SelectItem(3)				// Include all obs by default
		ii_def = 3
	Case "Item Statistics"
		ii_Repnum = 7
		wf_SetSubType(4)                // Set subreports
		cbx_incomp.Enabled = False      // Disable incomplete report selection
		cbx_incomp.Checked = True		  // Include incomplete reports		
	Case "Monthly Report"
		ii_RepNum = 8
		ddlb_def.SelectItem(1)     // Select Valid obs only
		ii_Def = 1
		ddlb_def.Enabled = False     // Disable the valid/non-valid selection ddlb
		sle_Insptype.Text = "SIRE"      // Select SIRE inspection
		sle_Insptype.event modified( )  // Call event to select in DW
		cbx_Excel.Enabled = False   // Disable Excel export (too many child DW)
	Case "Fleet Benchmark"
		ii_RepNum = 9
		st_HideItems.Y = 768
		st_HideItems.Height = 1312
		st_HideItems.Visible = True
	Case "Trend Analysis"
		ii_RepNum = 10		
		cbx_incomp.Checked = True      // Include incomplete reports by default
	Case "SIRE/MIRE Comparison"
		ii_RepNum = 11
		ddlb_def.SelectItem(1)       // Valid obs only
		ii_Def = 1
		ddlb_def.Enabled = False     // Disable valid/nonvalid selection
		sle_Insptype.Text = "IRE"       // Select SIRE and MIRE
		sle_Insptype.event modified( )  // Call event to select in DW
		sle_Insptype.Text = ""      // Empty textbox
		cbx_Excel.Enabled = False   // Disable Excel export (too many child DW)
	Case "Rejections"
		ii_RepNum = 12		
		wf_SetSubType(2)
		cbx_incomp.Enabled = False      // Disable incomplete report selection
		cbx_incomp.Checked = True		  // Include incomplete reports	
		st_HideItems.Y = 1472
		st_HideItems.Height = 608	
		st_HideItems.Visible = True
		cbx_Reason.Visible = True
		dw_Reason.Visible = True
		dw_Insp.Visible = False
		cbx_Insp.Visible = False
		sle_Insp.Visible = False
		ddlb_Rej.visible = True
		cbx_RejStatus.Visible = True
		cbx_Det.Visible = False
		ddlb_Rej.Enabled = False
		ddlb_Rej.SelectItem(1)
End Choose

st_TipHead.Text = lb_rep.Selecteditem( )

Choose Case ii_repnum
	Case 1  
		st_Tip.Text = "A Bar-graph report of total observations grouped by chapters and stacked as per below.~n~nType 1: SIRE Inspections - Stacked by Risk~n~nType 2: SIRE Inspections - Stacked by Type~n~nType 3: CDI Inspections - Stacked by Risk~n~nType 4: CDI Inspections - Stacked by Type"
		li_TipHeight = 700	
	Case 2
		st_Tip.Text = "A listing of all observations grouped by Risk, Inspection Model, Chapter and Section. Seven report sub-types are available. The fields included are as follows:~n~n"&
		+ "Type 1: Valid Obs, Vessel Type, Risk, Closed Status, Responsibility, Inspection Date, Inspector's Comments, Initial and Further Operator Comments. (For internal circulation only)~n~n"&
		+ "Type 2: Same as Type 1 but without the 'Closed' field. (For distribution to fleet)~n~n"&
		+ "Type 3: Same as Type 2 but without Initial or Further Operator Comments. (For distribution to fleet)~n~n"&		
		+ "Type 4: Same as Type 1, but without grouping by Risk.~n~n"&
		+ "Type 5: Same as Type 2, but without grouping by Risk.~n~n"&
		+ "Type 6: Same as Type 3, but without grouping by Risk.~n~n"&
		+ "Type 7: Same as Type 1, but without grouping by Risk and without any headers. (For external customers)~n~n"&
		+ "Type 8: A list of inspector's comments grouped by only by Inspection Model"
		li_TipHeight = 1300			
	Case 3
		st_Tip.Text = "A report of various graphs categorized by following criteria: Vessel Type, Flag, Company, Risk, Responsibility and Item Status."
		li_TipHeight = 300		
	Case 4
		st_Tip.Text = "A listing of vessels (grouped by Vessel Type) along with Vetting Statistics: Inspection Count, number and average of observations as per risk, last SIRE grade, the vessel score and a summary."
		li_TipHeight = 400		
	Case 5
		st_Tip.Text = "The Inspection Summary is list with the following columns: Vessel Type/Name, Inspection Dates, Inspection Company, Port of Inspection, Type of Inspection, Date of Expiry and Inspection Rating.~n~nType 1: Grouped by Vessel Type and Vessel Name~n~nType 2: No grouping and sorted by Inspection date"
		li_TipHeight = 600
	Case 6
		st_Tip.Text = "Expense Reports for various inspections.~n~nType 1: A summary of Inspection companies with number of inspections, avergar total and valid obs, lowest, average and highest cost per inspection followed by detailed breakdown as per inspection port.~n~nType 2: Expenses for each inspection grouped by Vessel Type and Vessel Name as well as the summary for each Vessel Type."
		li_TipHeight = 600		
	Case 7
		st_Tip.Text = "A listing of all questions (grouped by Chapter and Section) and the number of times the question is repeated.~n~nType 1: All questions~n~nType 2: All questions repeated more than once.~n~nType 3: All questions repeated 5 or more times.~n~nType 4: All questions repeated 10 or more times."
		li_TipHeight = 700		
	Case 8
		st_Tip.Text = "A Bar-graph reports of the average number of deficiencies (split by risk) for the current month compared against the entire period and grouped by Vessel Type and Flag."
		li_TipHeight = 400		
	Case 9
		st_Tip.Text = "A listing of all vessels sorted by their calculated benchmark score based on the vessel's actual score compared against its vessel type average."
		li_TipHeight = 300
	Case 10
		st_Tip.Text = "A graph displaying average deficiencies per inspection (split by risk) each month over a time period."
		li_TipHeight = 300
	Case 11
		st_Tip.Text = "A list of inspections (only SIRE & MIRE by default) grouped by Vessel Type and Vessel. Total observations are displayed as well as number of observation by risk for Vessel and Overall. Consistent anomalies and high risk items in SIRE and MIRE are displayed."
		li_TipHeight = 400
	Case 12
		st_Tip.Text = "Reports of rejection statistics of vessels.~n~nType 1: A summary of all rejections grouped by Vessel Type and Vessel alphabetically.~n~nType 2: A summary of all rejections grouped by month/year and listed chronologically."
		li_TipHeight = 600
End Choose

st_TipHead.Height = li_TipHeight
st_Tip.Height = li_TipHeight - st_Tip.y + st_TipHead.y - 20
st_TipHead.Visible = True
st_Tip.Visible = True

ibool_TipVisible = True 
end event

type st_imtip from statictext within w_rep
boolean visible = false
integer x = 1463
integer y = 1280
integer width = 933
integer height = 224
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15793151
string text = "Type a few characters from the Inspection Model name and press ~'Enter~'. All model names that contain these characters will be selected."
boolean border = true
boolean focusrectangle = false
end type

type ddlb_rej from dropdownlistbox within w_rep
boolean visible = false
integer x = 3346
integer y = 1264
integer width = 411
integer height = 548
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
string item[] = {"Active","Accepted"}
borderstyle borderstyle = stylelowered!
end type

type st_hideitems from statictext within w_rep
boolean visible = false
integer x = 859
integer y = 1664
integer width = 2926
integer height = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type dw_port from datawindow within w_rep
integer x = 2085
integer y = 912
integer width = 530
integer height = 528
integer taborder = 140
boolean bringtotop = true
string dataobject = "d_sq_tb_rep_port"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_port.Checked then cbx_port.Checked = True
If (li_Sel = 0) and cbx_port.Checked then cbx_port.Checked = False
end event

type st_tiphead from statictext within w_rep
boolean visible = false
integer x = 786
integer y = 128
integer width = 1865
integer height = 864
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 134217752
boolean enabled = false
string text = "Chapter Statistics"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_tip from statictext within w_rep
boolean visible = false
integer x = 823
integer y = 256
integer width = 1792
integer height = 720
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 134217752
boolean enabled = false
string text = "This is Help text"
boolean focusrectangle = false
end type

