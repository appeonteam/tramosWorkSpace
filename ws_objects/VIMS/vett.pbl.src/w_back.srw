$PBExportHeader$w_back.srw
forward
global type w_back from window
end type
type st_3 from statictext within w_back
end type
type st_2 from statictext within w_back
end type
type st_count from statictext within w_back
end type
type st_5 from statictext within w_back
end type
type st_4 from statictext within w_back
end type
type dw_office from datawindow within w_back
end type
type st_wait3 from statictext within w_back
end type
type st_wait2 from statictext within w_back
end type
type dw_trend from datawindow within w_back
end type
type st_trend from statictext within w_back
end type
type st_top10 from statictext within w_back
end type
type rr_2 from roundrectangle within w_back
end type
type rr_1 from roundrectangle within w_back
end type
type st_overall from statictext within w_back
end type
type st_sin from statictext within w_back
end type
type st_got from statictext within w_back
end type
type st_cph from statictext within w_back
end type
type st_apms from statictext within w_back
end type
type dw_top10 from datawindow within w_back
end type
type st_mt from statictext within w_back
end type
type st_user from statictext within w_back
end type
type st_db from statictext within w_back
end type
type st_built from statictext within w_back
end type
type st_ver from statictext within w_back
end type
type st_1 from statictext within w_back
end type
type ln_1 from line within w_back
end type
type ln_3 from line within w_back
end type
type ln_6 from line within w_back
end type
type ln_7 from line within w_back
end type
type ln_8 from line within w_back
end type
type rr_3 from roundrectangle within w_back
end type
type rr_4 from roundrectangle within w_back
end type
type st_wait1 from statictext within w_back
end type
end forward

global type w_back from window
integer width = 3575
integer height = 2536
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 12639424
string icon = "AppIcon!"
st_3 st_3
st_2 st_2
st_count st_count
st_5 st_5
st_4 st_4
dw_office dw_office
st_wait3 st_wait3
st_wait2 st_wait2
dw_trend dw_trend
st_trend st_trend
st_top10 st_top10
rr_2 rr_2
rr_1 rr_1
st_overall st_overall
st_sin st_sin
st_got st_got
st_cph st_cph
st_apms st_apms
dw_top10 dw_top10
st_mt st_mt
st_user st_user
st_db st_db
st_built st_built
st_ver st_ver
st_1 st_1
ln_1 ln_1
ln_3 ln_3
ln_6 ln_6
ln_7 ln_7
ln_8 ln_8
rr_3 rr_3
rr_4 rr_4
st_wait1 st_wait1
end type
global w_back w_back

type variables

Long il_SireCol = 16761024, il_PSCCol = 16761087, il_SIREValid = 16711024

end variables

forward prototypes
public subroutine wf_calc (integer li_year)
private subroutine wf_siretrend (ref datawindow adw_graph, integer li_year)
public subroutine wf_addbars (string as_whereclause, integer ai_year, integer ai_cat)
private function integer wf_getinspcount (string as_shortname, string as_string, integer ai_year, integer ai_cat)
public function integer wf_getobscount (string as_shortname, string as_ids, integer ai_def, integer ai_year, integer ai_cat)
end prototypes

public subroutine wf_calc (integer li_year);// Clear DW and show updating msg
dw_office.Reset()
dw_top10.Reset()
dw_Trend.Visible = False
dw_Trend.DataObject = ""
st_Wait1.Text = "Updating..."
st_Wait2.Text = st_Wait1.Text 
st_Wait3.Text = st_Wait1.Text 
st_Wait1.Visible = True
st_Wait2.Visible = True
st_Wait3.Visible = True

This.SetRedraw(False)

// Populate Avg obs graph by ID  ( each number must have underscore preceeding & following it)
wf_AddBars("_8_9_10_11_", li_Year, 0)  // MTTO Performance
wf_AddBars("_8_", li_Year, 0)      // Technical Fleet Group Copenhagen
wf_AddBars("_9_", li_Year, 0)      // Technical Fleet Group Singapore (LR2/VLCC)
wf_AddBars("_10_", li_Year, 0)      // Technical Fleet Group Singapore (Brostrom)
wf_AddBars("_11_", li_Year, 0)      // Technical Fleet Group Paris
wf_AddBars("_1_", li_Year, 1)      // Marine Standards Copenhagen
wf_AddBars("_3_", li_Year, 1)      // Marine Standards Singapore
wf_AddBars("_18_", li_Year, 2)     // T/C Type Vessels
wf_AddBars("_20_", li_Year, 2)     // 3P Vessels
st_Wait1.Visible = False
st_Overall.Text = " Average Observations per Inspection YTD " + String(li_Year)
This.SetRedraw(True)
This.SetRedraw(False)

// Retrieve top 10 SIRE
dw_top10.SetTransObject(SQLCA)
dw_top10.Retrieve(li_Year)
st_Wait3.Visible = False
st_Top10.Text = " Top 10 MTTO SIRE Observations YTD " + String(li_Year)
This.SetRedraw(True)
This.SetRedraw(False)

// SIRE Trend graph
wf_SireTrend(dw_Trend, li_Year)
dw_Trend.Visible = True
st_Wait2.Visible = False
st_Trend.Text = " MTTO SIRE Trend " + String(li_Year)

This.SetRedraw(True)

end subroutine

private subroutine wf_siretrend (ref datawindow adw_graph, integer li_year);// This function generates the trend analysis graph and draws it on adw_graph
Datastore lds_Data
String ls_SQL

ls_SQL = "Select Count(Distinct VETT_INSP.INSP_ID) as INSPCOUNT,"&
 + "Sum(Case When RISK = 0 Then 1 Else 0 End) as LOW,"&
 + "Sum(Case When RISK = 1 Then 1 Else 0 End) as MED,"&
 + "Sum(Case When RISK = 2 Then 1 Else 0 End) as HIGH,"&
 + "Count(VETT_ITEM.ANS) as OBS, Left(Convert(varChar, INSPDATE, 112), 6) as CURMONTH "&
 + "FROM VETT_INSP Inner Join VETT_ITEM On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID Inner Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID "&
 + "Inner Join VESSELS On VESSELIMO = IMO_NUMBER and VESSEL_ACTIVE=1 and VETT_TYPE < 7 "& 
 + "Where COMPLETED=1 and (DEF=1 or DEF is Null) and NAME like 'SIRE%' and Year(INSPDATE) = " + String(li_Year) + " and VETT_OFFICEID in (1,2,3,4,5,29) "&
 + "GROUP BY Left(Convert(varChar, INSPDATE, 112), 6) "&
 + "ORDER BY Left(Convert(varChar, INSPDATE, 112), 6)" 

lds_Data = Create DataStore
lds_Data.DataObject = "d_sq_tb_trend"
lds_Data.SetSQLSelect(ls_SQL)
lds_Data.SetTransObject(SQLCA)

adw_graph.Dataobject = "d_ext_siretrend"

If lds_Data.Retrieve( ) <= 0 then Return
		
uo_dwdraw l_Draw

Integer li_Loop, li_Height, li_Width, li_X, li_Y, li_MaxObsFactor = 1, li_NumMonths
Decimal ldec_Temp, ldec_Wid, ldec_Hgt
String ls_Temp

// Set sizes. Remember to change if you change X or Y axis position in DW.
li_Width = 690
li_Height = 130
li_X = 37
li_Y = 140

adw_Graph.SetRedraw(False)  // Disable redraw of DW

l_Draw = Create uo_dwdraw

// Set number of months to 12
li_NumMonths = 12

// Calc scale factor for Y Axis
li_MaxObsFactor = Int(lds_Data.GetitemNumber(1, "MaxAvgObs") / 10)
If li_MaxObsFactor = 0 then li_MaxObsFactor = 1
			
// Draw Y Axis ticks, lines and write numbers
For li_Loop =  2 to 10 Step 2
	ldec_Temp = li_Y - li_Loop * (li_Height / 10)
	l_Draw.DrawOnDW(adw_Graph, li_X - 5, ldec_Temp, 5, 0, 0, 1, 8421504)
	l_Draw.WriteOnDW(adw_Graph, li_X - 20, ldec_Temp - 8, 13, 16, String(li_Loop * li_MaxObsFactor), 8421504, 1)
Next 

// Determine width of each month
ldec_Wid = (li_Width / li_NumMonths) // Calc width of each month

// Draw X Axis ticks, and write months
For li_Loop = 1 to li_NumMonths	
	ls_Temp = String(Date(li_Year, li_Loop, 1), "mmm")
	l_Draw.DrawOnDW(adw_Graph, li_X + li_Loop * ldec_Wid, li_Y, 0, 5, 0, 1, 8421504)
	l_Draw.WriteOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid, li_Y + 2, ldec_Wid, 16, ls_Temp, 8421504, 2)
Next

// Draw Risk Boxes
For li_Loop = 1 to li_NumMonths
	ldec_Hgt = lds_Data.GetItemNumber(li_Loop, "highavg") / li_MaxObsFactor / 10 * li_Height  // Height of high risk
	ldec_Temp = li_Y - ldec_Hgt   // Y of high risk
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_hgt, 8421631)
	ldec_Hgt = lds_Data.GetItemNumber(li_Loop, "medavg") / li_MaxObsFactor / 10 * li_Height  // Height of medium risk
	ldec_Temp -= ldec_Hgt  // Y of medium risk
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_Hgt, 8454143)
	ldec_Hgt = lds_Data.GetItemNumber(li_Loop, "lowavg") / li_MaxObsFactor / 10 * li_Height  // Height of low risk
	ldec_Temp -= ldec_Hgt  // Y of low risk	
	If ldec_Hgt>0.0 then l_Draw.BoxOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid + ((ldec_Wid - 30)/2), ldec_Temp, 30, ldec_Hgt, 8454016)
Next

// Draw Trend Line and avg figures
For li_Loop = 1 to li_NumMonths - 1	
	ldec_Temp = li_Y - lds_Data.GetItemNumber(li_Loop, "obsavg") / li_MaxObsFactor / 10 * li_Height  // Y of trend line
	ldec_Hgt = li_Y - lds_Data.GetItemNumber(li_Loop + 1, "obsavg") / li_MaxObsFactor / 10 * li_Height - ldec_Temp  // Height of line segment
	l_Draw.DrawOnDW(adw_Graph, li_X + li_Loop * ldec_Wid - ldec_Wid / 2, ldec_Temp, ldec_Wid, ldec_Hgt, 0, 2, 16761024)
	l_Draw.WriteOnDW(adw_Graph, li_X + (li_Loop - 1) * ldec_Wid, ldec_Temp - 15, ldec_Wid, 15, String(lds_Data.GetItemNumber(li_Loop, "obsavg"), "0.0"), 8421504, 2)
Next
ldec_Temp = li_Y - lds_Data.GetItemNumber(li_NumMonths, "obsavg") / li_MaxObsFactor / 10 * li_Height  // Y of trend line
l_Draw.WriteOnDW(adw_Graph, li_X + (li_NumMonths - 1) * ldec_Wid, ldec_Temp - 15, ldec_Wid, 15, String(lds_Data.GetItemNumber(li_Loop, "obsavg"), "0.0"), 8421504, 2)

Destroy l_Draw
Destroy lds_Data

adw_Graph.SetRedraw(True)   // Refresh DW
end subroutine

public subroutine wf_addbars (string as_whereclause, integer ai_year, integer ai_cat);Integer li_SireInsp, li_PSCInsp
Decimal ldec_SireObs, ldec_SireValid, ldec_PSC

// Handle SIRE inspections
li_SireInsp = wf_GetInspCount("SIRE", as_WhereClause, ai_Year, ai_Cat)
If li_SireInsp = -1 then
	SetNull(li_SireInsp)
Else	
	If li_SireInsp > 0 then
		ldec_SireObs = wf_GetObsCount("SIRE", as_WhereClause, 0, ai_Year, ai_Cat)
		If ldec_SireObs = -1 then SetNull(ldec_SireObs) Else ldec_SireObs = ldec_SireObs / li_SireInsp
		ldec_SireValid = wf_GetObsCount("SIRE", as_WhereClause, 1, ai_Year, ai_Cat)
		If ldec_SireValid = -1 then SetNull(ldec_SireValid) Else	ldec_SireValid = ldec_SireValid / li_SireInsp
	Else
		SetNull(ldec_SireObs)
		SetNull(ldec_SireValid)
	End If
End If

// Handle PSC
li_PSCInsp = wf_GetInspCount("PSC", as_WhereClause, ai_Year, ai_Cat)
If li_PSCInsp = -1 then
	SetNull(li_PSCInsp)
Else
	If li_PSCInsp > 0 then
		ldec_PSC = wf_GetObsCount("PSC", as_WhereClause, 0, ai_Year, ai_Cat)
		If ldec_PSC = -1 then SetNull(ldec_PSC) Else	ldec_PSC = ldec_PSC / li_PSCInsp
	Else
		SetNull(ldec_PSC)
	End If	
End If

// Add row to datawindow
Integer li_NewRow
li_NewRow = dw_Office.InsertRow(0)

If li_NewRow <=0 then Return

dw_Office.SetItem(li_NewRow, "SireInsp", li_SireInsp)
dw_Office.SetItem(li_NewRow, "PscInsp", li_PscInsp)
dw_Office.SetItem(li_NewRow, "SireObs", Round(ldec_SireObs, 1))
dw_Office.SetItem(li_NewRow, "SireValid", Round(ldec_SireValid, 1))
dw_Office.SetItem(li_NewRow, "PscObs", Round(ldec_PSC, 1))
end subroutine

private function integer wf_getinspcount (string as_shortname, string as_string, integer ai_year, integer ai_cat);// Gets total number of inspections for model and vetting office

Long ll_Insp

Choose Case ai_Cat
	Case 0  // By Fleet Group
		Select Count(INSP_ID) Into :ll_Insp 
		From VETT_INSP inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and	COMPLETED = 1 and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_FLEETGROUPID))+'_', :as_String) > 0;
			
	Case 1  // By Vetting Office
		Select Count(INSP_ID) Into :ll_Insp 
		From VETT_INSP inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and	COMPLETED = 1 and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_OFFICEID))+'_', :as_String) > 0;
				
	Case 2  // By Vetting Type
		Select Count(INSP_ID) Into :ll_Insp 
		From VETT_INSP inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and	COMPLETED = 1 and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_TYPE))+'_', :as_String) > 0;
						
End Choose

If SQLCA.SQLCode = 0 then
	Commit;	
Else
	Rollback;
	Return -1
End If

Return ll_Insp

end function

public function integer wf_getobscount (string as_shortname, string as_ids, integer ai_def, integer ai_year, integer ai_cat);// Returns total number of observations for model and office

Long ll_Item

Choose Case ai_Cat
	Case 0   // By Fleetgroup
		Select Count(ITEM_ID) Into :ll_Item 
		From VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID
		Inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Inner Join VETT_OFFICE On VESSELS.VETT_OFFICEID = VETT_OFFICE.VETT_OFFICEID
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and COMPLETED = 1 and
		ANS = 1 and DEF >= :ai_Def and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_FLEETGROUPID))+'_', :as_IDs) > 0;

	Case 1	// By Vetting Office
		Select Count(ITEM_ID) Into :ll_Item 
		From VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID
		Inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Inner Join VETT_OFFICE On VESSELS.VETT_OFFICEID = VETT_OFFICE.VETT_OFFICEID
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and COMPLETED = 1 and
		ANS = 1 and DEF >= :ai_Def and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_OFFICEID))+'_', :as_IDs) > 0;

	Case 2	// By Vetting Type
		Select Count(ITEM_ID) Into :ll_Item 
		From VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID
		Inner Join VETT_INSPMODEL on VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Inner Join VESSELS On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO and VESSELS.VESSEL_ACTIVE = 1 and VESSELS.VETT_TYPE is not Null
		Inner Join VETT_OFFICE On VESSELS.VETT_OFFICEID = VETT_OFFICE.VETT_OFFICEID
		Where SHORTNAME = :as_ShortName and Year(INSPDATE) = :ai_Year and COMPLETED = 1 and
		ANS = 1 and DEF >= :ai_Def and
		CharIndex('_'+Ltrim(Str(VESSELS.VETT_TYPE))+'_', :as_IDs) > 0;
	
End Choose

If SQLCA.SQLCode = 0 then
	Commit;	
Else
	Rollback;
	Return -1
End If

Return ll_Item


end function

on w_back.create
this.st_3=create st_3
this.st_2=create st_2
this.st_count=create st_count
this.st_5=create st_5
this.st_4=create st_4
this.dw_office=create dw_office
this.st_wait3=create st_wait3
this.st_wait2=create st_wait2
this.dw_trend=create dw_trend
this.st_trend=create st_trend
this.st_top10=create st_top10
this.rr_2=create rr_2
this.rr_1=create rr_1
this.st_overall=create st_overall
this.st_sin=create st_sin
this.st_got=create st_got
this.st_cph=create st_cph
this.st_apms=create st_apms
this.dw_top10=create dw_top10
this.st_mt=create st_mt
this.st_user=create st_user
this.st_db=create st_db
this.st_built=create st_built
this.st_ver=create st_ver
this.st_1=create st_1
this.ln_1=create ln_1
this.ln_3=create ln_3
this.ln_6=create ln_6
this.ln_7=create ln_7
this.ln_8=create ln_8
this.rr_3=create rr_3
this.rr_4=create rr_4
this.st_wait1=create st_wait1
this.Control[]={this.st_3,&
this.st_2,&
this.st_count,&
this.st_5,&
this.st_4,&
this.dw_office,&
this.st_wait3,&
this.st_wait2,&
this.dw_trend,&
this.st_trend,&
this.st_top10,&
this.rr_2,&
this.rr_1,&
this.st_overall,&
this.st_sin,&
this.st_got,&
this.st_cph,&
this.st_apms,&
this.dw_top10,&
this.st_mt,&
this.st_user,&
this.st_db,&
this.st_built,&
this.st_ver,&
this.st_1,&
this.ln_1,&
this.ln_3,&
this.ln_6,&
this.ln_7,&
this.ln_8,&
this.rr_3,&
this.rr_4,&
this.st_wait1}
end on

on w_back.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_count)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.dw_office)
destroy(this.st_wait3)
destroy(this.st_wait2)
destroy(this.dw_trend)
destroy(this.st_trend)
destroy(this.st_top10)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.st_overall)
destroy(this.st_sin)
destroy(this.st_got)
destroy(this.st_cph)
destroy(this.st_apms)
destroy(this.dw_top10)
destroy(this.st_mt)
destroy(this.st_user)
destroy(this.st_db)
destroy(this.st_built)
destroy(this.st_ver)
destroy(this.st_1)
destroy(this.ln_1)
destroy(this.ln_3)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.ln_8)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.st_wait1)
end on

event open;
// Set DB
st_DB.text = SQLCA.Database

// Set version and build date  (remove leading zeros from version number)
st_Ver.Text = 'Ver: ' + String(Integer(Mid(g_Obj.AppVersion, 1, 2))) + '.' + String(Integer(Mid(g_Obj.AppVersion, 4, 2))) + '.' + String(Integer(Mid(g_Obj.AppVersion, 7, 2)))
st_built.Text = 'Built: ' + g_Obj.AppBuild
st_User.Text = g_Obj.UserID

// Disp number of inspections
Long li_Count 
Select Count(*) Into :li_Count From VETT_INSP;
Commit;
st_Count.Text="Insp Count: " + String(li_Count)

If g_Obj.Developer then
	st_wait1.Text = "Skipped"
	st_wait2.Text = st_wait1.Text
	st_wait3.Text = st_wait1.Text
Else
	// Calc background figures
	Post wf_Calc(Year(Today()))	
End If

end event

type st_3 from statictext within w_back
integer x = 146
integer y = 848
integer width = 759
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "SINFLEETD"
boolean focusrectangle = false
end type

type st_2 from statictext within w_back
integer x = 146
integer y = 720
integer width = 759
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "SINFLEETC"
boolean focusrectangle = false
end type

type st_count from statictext within w_back
integer x = 1993
integer y = 96
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Insp Count: 0"
boolean focusrectangle = false
end type

type st_5 from statictext within w_back
integer x = 91
integer y = 1352
integer width = 626
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "3P Operated Vessels"
boolean focusrectangle = false
end type

type st_4 from statictext within w_back
integer x = 91
integer y = 1232
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "T/C-In Vessels"
boolean focusrectangle = false
end type

type dw_office from datawindow within w_back
integer x = 841
integer y = 240
integer width = 1353
integer height = 1488
integer taborder = 40
string title = "none"
string dataobject = "d_ext_bars"
boolean border = false
boolean livescroll = true
end type

type st_wait3 from statictext within w_back
integer x = 2578
integer y = 944
integer width = 608
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 12639424
string text = "Updating..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_wait2 from statictext within w_back
integer x = 1481
integer y = 2064
integer width = 608
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 12639424
string text = "Updating..."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_trend from datawindow within w_back
integer x = 73
integer y = 1808
integer width = 3401
integer height = 624
integer taborder = 40
string title = "none"
string dataobject = "d_ext_siretrend"
boolean border = false
boolean livescroll = true
end type

type st_trend from statictext within w_back
integer x = 91
integer y = 1760
integer width = 631
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 12639424
string text = " MTTO SIRE Trend 20xx"
boolean focusrectangle = false
end type

type st_top10 from statictext within w_back
integer x = 2267
integer y = 192
integer width = 1120
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 12639424
string text = " Top 10 MTTO SIRE Observations YTD 20xx"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_back
long linecolor = 8421504
integer linethickness = 4
long fillcolor = 12639424
integer width = 3547
integer height = 2512
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_1 from roundrectangle within w_back
long linecolor = 8421376
integer linethickness = 4
long fillcolor = 12639424
integer x = 55
integer y = 224
integer width = 2158
integer height = 1520
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_overall from statictext within w_back
integer x = 91
integer y = 192
integer width = 1248
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 12639424
string text = " Average Observations per Inspection YTD 20xx"
boolean focusrectangle = false
end type

type st_sin from statictext within w_back
integer x = 146
integer y = 592
integer width = 759
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "CPHFLEETB"
boolean focusrectangle = false
end type

type st_got from statictext within w_back
integer x = 146
integer y = 464
integer width = 699
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "CPHFLEETA"
boolean focusrectangle = false
end type

type st_cph from statictext within w_back
integer x = 91
integer y = 1104
integer width = 786
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "Marine Standards SIN"
boolean focusrectangle = false
end type

type st_apms from statictext within w_back
integer x = 91
integer y = 976
integer width = 722
integer height = 52
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "Marine Standards CPH"
boolean focusrectangle = false
end type

type dw_top10 from datawindow within w_back
integer x = 2249
integer y = 256
integer width = 1225
integer height = 1472
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_top10sire"
boolean border = false
boolean livescroll = true
end type

type st_mt from statictext within w_back
integer x = 91
integer y = 336
integer width = 571
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12639424
string text = "MTTO Performance"
boolean focusrectangle = false
end type

type st_user from statictext within w_back
integer x = 3035
integer y = 16
integer width = 494
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "User"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_db from statictext within w_back
integer x = 18
integer y = 16
integer width = 805
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "DB"
boolean focusrectangle = false
end type

type st_built from statictext within w_back
integer x = 1463
integer y = 96
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Built: XXX"
boolean focusrectangle = false
end type

type st_ver from statictext within w_back
integer x = 1115
integer y = 96
integer width = 274
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Ver: 0.0.00"
boolean focusrectangle = false
end type

type st_1 from statictext within w_back
integer x = 896
integer y = 16
integer width = 1682
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 8421504
long backcolor = 12639424
string text = "Vetting and Inspection Management System"
alignment alignment = center!
boolean focusrectangle = false
end type

type ln_1 from line within w_back
long linecolor = 8421504
integer linethickness = 4
integer beginx = 110
integer beginy = 400
integer endx = 110
integer endy = 880
end type

type ln_3 from line within w_back
long linecolor = 8421504
integer linethickness = 4
integer beginx = 110
integer beginy = 496
integer endx = 128
integer endy = 496
end type

type ln_6 from line within w_back
long linecolor = 8421504
integer linethickness = 4
integer beginx = 110
integer beginy = 624
integer endx = 128
integer endy = 624
end type

type ln_7 from line within w_back
long linecolor = 8421504
integer linethickness = 4
integer beginx = 110
integer beginy = 752
integer endx = 128
integer endy = 752
end type

type ln_8 from line within w_back
long linecolor = 8421504
integer linethickness = 4
integer beginx = 110
integer beginy = 880
integer endx = 128
integer endy = 880
end type

type rr_3 from roundrectangle within w_back
long linecolor = 8421376
integer linethickness = 4
long fillcolor = 12639424
integer x = 2231
integer y = 224
integer width = 1262
integer height = 1520
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_back
long linecolor = 8421376
integer linethickness = 4
long fillcolor = 12639424
integer x = 55
integer y = 1792
integer width = 3438
integer height = 672
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_wait1 from statictext within w_back
integer x = 859
integer y = 944
integer width = 608
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 12639424
string text = "Updating..."
alignment alignment = center!
boolean focusrectangle = false
end type

