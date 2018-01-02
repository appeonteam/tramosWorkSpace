$PBExportHeader$w_inbox.srw
forward
global type w_inbox from window
end type
type cbx_act from checkbox within w_inbox
end type
type cb_clearall from commandbutton within w_inbox
end type
type cb_selectall from commandbutton within w_inbox
end type
type cb_savefilter from commandbutton within w_inbox
end type
type cb_print from commandbutton within w_inbox
end type
type cb_exp from commandbutton within w_inbox
end type
type st_7 from statictext within w_inbox
end type
type st_6 from statictext within w_inbox
end type
type cb_office from commandbutton within w_inbox
end type
type ddlb_period from dropdownlistbox within w_inbox
end type
type dw_office from datawindow within w_inbox
end type
type cb_type from commandbutton within w_inbox
end type
type dw_type from datawindow within w_inbox
end type
type st_5 from statictext within w_inbox
end type
type cbx_new from checkbox within w_inbox
end type
type cb_key from commandbutton within w_inbox
end type
type cb_resp from commandbutton within w_inbox
end type
type st_and from statictext within w_inbox
end type
type dw_vett from datawindow within w_inbox
end type
type cb_menu from commandbutton within w_inbox
end type
type st_3 from statictext within w_inbox
end type
type st_2 from statictext within w_inbox
end type
type dp_to from datepicker within w_inbox
end type
type dp_from from datepicker within w_inbox
end type
type dw_im from datawindow within w_inbox
end type
type st_1 from statictext within w_inbox
end type
type cb_filter from commandbutton within w_inbox
end type
type st_4 from statictext within w_inbox
end type
type cbx_open from checkbox within w_inbox
end type
type cbx_lock from checkbox within w_inbox
end type
type cbx_comp from checkbox within w_inbox
end type
type cb_reply from commandbutton within w_inbox
end type
type cb_report from commandbutton within w_inbox
end type
type cb_hist from commandbutton within w_inbox
end type
type cb_edit from commandbutton within w_inbox
end type
type dw_insp from datawindow within w_inbox
end type
type gb_1 from groupbox within w_inbox
end type
end forward

global type w_inbox from window
integer width = 4882
integer height = 2548
boolean titlebar = true
string title = "Inspection Inbox"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Inbox.ico"
boolean center = true
event ue_contextmenuclick ( integer ai_menu )
cbx_act cbx_act
cb_clearall cb_clearall
cb_selectall cb_selectall
cb_savefilter cb_savefilter
cb_print cb_print
cb_exp cb_exp
st_7 st_7
st_6 st_6
cb_office cb_office
ddlb_period ddlb_period
dw_office dw_office
cb_type cb_type
dw_type dw_type
st_5 st_5
cbx_new cbx_new
cb_key cb_key
cb_resp cb_resp
st_and st_and
dw_vett dw_vett
cb_menu cb_menu
st_3 st_3
st_2 st_2
dp_to dp_to
dp_from dp_from
dw_im dw_im
st_1 st_1
cb_filter cb_filter
st_4 st_4
cbx_open cbx_open
cbx_lock cbx_lock
cbx_comp cbx_comp
cb_reply cb_reply
cb_report cb_report
cb_hist cb_hist
cb_edit cb_edit
dw_insp dw_insp
gb_1 gb_1
end type
global w_inbox w_inbox

type prototypes


end prototypes

type variables

m_selection_im im_Select
m_selection_user im_Resp
m_selection_type im_Type
m_selection im_office

Integer ii_MenuSel, ii_Period = 1
String is_Setting="vett.pbl>w_inbox"
end variables

forward prototypes
public subroutine wf_refreshrow ()
public subroutine wf_retrieve ()
public subroutine wf_openatt ()
private subroutine wf_openreport (long al_attid, string as_filename)
public subroutine wf_loadfilters ()
private subroutine wf_selectdw (ref datawindow adw_box, integer ai_select)
end prototypes

event ue_contextmenuclick(integer ai_menu);
Integer li_Count

If ii_MenuSel = 0 then 
	dw_im.SetRedraw(False)
	Choose Case ai_Menu
		Case 10	
			For li_Count = 1 to dw_im.RowCount()
				dw_im.SetItem(li_Count, "Sel", 1)
			Next
		Case 20
			For li_Count = 1 to dw_im.RowCount()
				dw_im.SetItem(li_Count, "Sel", 0)
			Next
		Case 30
			For li_Count = 1 to dw_im.RowCount()
				dw_im.SetItem(li_Count, "Sel", 1 - dw_im.GetItemNumber(li_Count, "Sel"))
			Next
		Case 100 // All SIRE
			For li_Count = 1 to dw_im.RowCount()
				If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "SIRE" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
			Next
		Case 110 // All CDI
			For li_Count = 1 to dw_im.RowCount()
				If Left(dw_im.GetItemString(li_Count, "imname"), 3) = "CDI" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
			Next				
		Case 120 // All MIRE
			For li_Count = 1 to dw_im.RowCount()
				If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "MIRE" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
			Next
		Case 130 // All PSC
			For li_Count = 1 to dw_im.RowCount()
				If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "Port" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
			Next
		Case 140 // All Terminal Safety
			For li_Count = 1 to dw_im.RowCount()
				If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "Term" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
			Next
	End Choose
	dw_im.SetRedraw(True)	
ElseIf ii_MenuSel = 1 Then
	dw_Vett.SetRedraw(False)
	Choose Case ai_Menu
		Case 10
			For li_Count = 1 to dw_Vett.RowCount()
				dw_Vett.SetItem(li_Count, "Sel", 1)
			Next
		Case 20
			For li_Count = 1 to dw_Vett.RowCount()
				dw_Vett.SetItem(li_Count, "Sel", 0)
			Next
		Case 30
			For li_Count = 1 to dw_Vett.RowCount()
				dw_Vett.SetItem(li_Count, "Sel", 1 - dw_Vett.GetItemNumber(li_Count, "Sel"))
			Next
		Case 100
			li_Count = dw_vett.Find("userid = '" + g_Obj.UserID + "'", 1, dw_Vett.RowCount())		
			If li_Count > 0 then
				Integer li_Loop
				For li_Loop =1 to dw_Vett.RowCount()
					dw_Vett.SetItem(li_Loop, "Sel", 0)
				Next		
				dw_Vett.SetItem(li_Count, "Sel", 1)
				dw_Vett.ScrollToRow(li_Count)
			Else
				Messagebox("User ID not found", "Your name could not be found in the list!", Exclamation!)
			End If
	End Choose
	dw_Vett.SetRedraw(True)
ElseIf ii_MenuSel = 2 Then
	dw_Type.SetRedraw(False)
	Choose Case ai_Menu
		Case 10
			For li_Count = 1 to dw_Type.RowCount()
				dw_Type.SetItem(li_Count, "Sel", 1)
			Next
		Case 20
			For li_Count = 1 to dw_Type.RowCount()
				dw_Type.SetItem(li_Count, "Sel", 0)
			Next
		Case 30
			For li_Count = 1 to dw_Type.RowCount()
				dw_Type.SetItem(li_Count, "Sel", 1 - dw_Type.GetItemNumber(li_Count, "Sel"))
			Next
		Case 100  // T/C vessels
			For li_Count = 1 to dw_Type.RowCount()
				dw_Type.SetItem(li_Count, "Sel", 0)
				If Pos(dw_Type.GetItemString(li_Count, "Type_Name"), "T/C") > 0 then dw_Type.SetItem(li_Count, "Sel", 1)
			Next
		Case 110  // 3P vessels
			For li_Count = 1 to dw_Type.RowCount()
				dw_Type.SetItem(li_Count, "Sel", 0)
				If Pos(dw_Type.GetItemString(li_Count, "Type_Name"), "3P") > 0 then dw_Type.SetItem(li_Count, "Sel", 1)
			Next			
	End Choose
	dw_Type.SetRedraw(True)
Else 
	dw_Office.SetRedraw(False)
	Choose Case ai_Menu
		Case 10
			For li_Count = 1 to dw_Office.RowCount()
				dw_Office.SetItem(li_Count, "Sel", 1)
			Next
		Case 20
			For li_Count = 1 to dw_Office.RowCount()
				dw_Office.SetItem(li_Count, "Sel", 0)
			Next
		Case 30
			For li_Count = 1 to dw_Office.RowCount()
				dw_Office.SetItem(li_Count, "Sel", 1 - dw_Office.GetItemNumber(li_Count, "Sel"))
			Next		
	End Choose
	dw_Office.SetRedraw(True)
End If


end event

public subroutine wf_refreshrow ();Long ll_Row, ll_InspID, ll_Items, ll_Open, ll_Max, ll_Completed, ll_Locked, ll_Total
String ls_CName, ls_Port, ls_Rating, ls_Comments
DateTime ldt_InspDate
Integer li_PDF, li_New, li_Att, li_Flag, li_Review, li_NullStars, li_SumStars, li_ValidStars, li_Mgmt, li_VBIS, li_VslDet
Decimal ldec_Score

ll_Row = dw_insp.GetRow( )

ll_InspID = dw_insp.GetItemNumber(ll_Row, "Insp_ID")

SELECT VETT_COMP.NAME AS CNAME,
         PORT_N,
         INSPDATE,  
         SUM(Case When ANS = 1 Then 1 Else 0 End) as TOTAL,
			SUM(IsNull(DEF,0)) AS ITEMS,     
			SUM(Case When (CLOSED=0) and (DEF=1) then 1 Else 0 End) as OPENITEMS,
			COMPLETED,LOCKED,VSLSCORE,RATING,EXPFLAG,TECH_REVIEW,
			Max(Cast(VSLCOMM as VarChar)) as COMMENTS,
			(Select Sum(Case When STARS is Null Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as NULLSTARS,
   	   (Select Sum(STARS) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as SUMSTARS,
   	  	(Select Sum(Case When STARS > 0 Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as VALIDSTARS,		
        (Select Count(*) from VETT_ATT Where (VETT_ATT.INSP_ID = VETT_INSP.INSP_ID) and (Upper(VETT_ATT.FILENAME)= 'REPORT.PDF') and (VETT_ATT.ITEM_ID is Null) and (VETT_ATT.SM_ID is Null)),
				 (Select Count(*) from VETT_ATT Where VETT_ATT.INSP_ID = VETT_INSP.INSP_ID),
		  (Select Count(TIME_ID) from VETT_ITEMHIST Inner Join VETT_ITEM on VETT_ITEMHIST.ITEM_ID = VETT_ITEM.ITEM_ID Where (VETT_ITEMHIST.STATUS = 0) and (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID)),
		  MGMT_REVIEW, VETT_INSP.VBIS, VETT_INSP.VSLDET
	INTO
		 : ls_CName,
		 : ls_Port,
		 : ldt_InspDate,
		 : ll_Total,
		 : ll_Items,
		 : ll_Open,
		 : ll_Completed,
		 : ll_Locked,
		 : ldec_Score,
		 : ls_Rating,
		 : li_Flag,
		 : li_Review,
		 : ls_Comments,
		 : li_NullStars,
		 : li_SumStars,
		 : li_ValidStars,
		 : li_PDF,
		 : li_Att,
		 : li_New,
		 : li_Mgmt,
		 : li_VBIS,
		 : li_VslDet
    FROM (((VETT_INSP INNER JOIN VETT_COMP ON VETT_INSP.COMP_ID = VETT_COMP.COMP_ID) 
          INNER JOIN PORTS ON VETT_INSP.PORT = PORTS.PORT_CODE) 
          INNER JOIN VETT_INSPMODEL ON VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID) 
          LEFT OUTER JOIN VETT_ITEM ON VETT_INSP.INSP_ID = VETT_ITEM.INSP_ID
WHERE VETT_INSP.INSP_ID = :ll_InspID
GROUP BY VETT_INSP.INSP_ID, VETT_COMP.NAME, PORTS.PORT_CODE, VETT_INSPMODEL.IM_ID;
	
If SQLCA.Sqlcode <> 0 then
	MessageBox("DB Error", "Could not refresh row to reflect changes. Please close and re-open window.~n~n" + SQLCA.Sqlerrtext)
	Rollback;
	Return
Else
	Commit;
End If

dw_insp.SetItem( ll_Row, "Total", ll_Total)
dw_insp.SetItem( ll_Row, "OpenItems", ll_Open)
dw_insp.SetItem( ll_Row, "Items", ll_Items)
dw_insp.SetItem( ll_Row, "InspDate", ldt_InspDate)
dw_insp.SetItem( ll_Row, "Port_N", ls_Port)
dw_insp.SetItem( ll_Row, "CName", ls_CName)
dw_insp.SetItem( ll_Row, "Completed", ll_Completed)
dw_insp.SetItem( ll_Row, "Locked", ll_Locked)
dw_insp.SetItem( ll_Row, "Rating", ls_Rating)
dw_insp.SetItem( ll_Row, "VslScore", ldec_Score)
dw_insp.SetItem( ll_Row, "pdf", li_PDF)
dw_insp.SetItem( ll_Row, "att", li_Att)
dw_insp.SetItem( ll_Row, "newcomments", li_new)
dw_insp.SetItem( ll_Row, "ExpFlag", li_Flag)
dw_insp.SetItem( ll_Row, "Tech_Review", li_Review)
dw_insp.SetItem( ll_Row, "Comments", ls_Comments)
dw_insp.SetItem( ll_Row, "NullStars", li_NullStars)
dw_insp.SetItem( ll_Row, "ValidStars", li_ValidStars)
dw_insp.SetItem( ll_Row, "SumStars", li_SumStars)
dw_insp.SetItem( ll_Row, "Mgmt_Review", li_Mgmt)
dw_insp.SetItem( ll_Row, "VBIS", li_VBIS)
dw_insp.SetItem( ll_Row, "VslDet", li_VslDet)

end subroutine

public subroutine wf_retrieve ();
Integer li_Count, li_Sel
String ls_SQL, ls_Where, ls_Clause

dw_Insp.SetRedraw(False)
dw_Insp.Reset( )   // Clear DW

ls_Where = "WHERE VESSELS.VETT_TYPE is not Null and VETT_OFFICEID is not null and VETT_FLEETGROUPID is not null "

If cbx_Act.Checked then ls_Where += " and VESSEL_ACTIVE=1 and VETT_INVIMS=1"

If cbx_open.Checked then     // If Open
	If cbx_comp.Checked then   //  If Completed
		If cbx_lock.Checked then   //  If Locked
			ls_Where += ""       // Do nothing
		Else  //  If Unlocked
			ls_Where += " and (LOCKED = 0)"
		End If
	Else  // If Incomplete
		If cbx_lock.Checked then  // If Locked
			ls_Where += " and ((LOCKED = 1) or (COMPLETED = 0))"
		Else  //  If Unlocked
			ls_Where += " and (COMPLETED = 0)"
		End If		
	End If
Else  // Closed
	If cbx_comp.Checked then
		If cbx_lock.Checked then
			ls_Where += " and (COMPLETED = 1)"
		Else
			ls_Where += " and (COMPLETED = 1) and (LOCKED = 0)"
		End If
	Else
		If cbx_lock.Checked then
			ls_Where += " and (LOCKED = 1)"
		Else
			Return  // Exit if nothing selected
		End If		
	End If
End If

// Inspection Models
ls_Clause = ""
li_Sel = 0
For li_Count = 1 to dw_im.RowCount( )  // Loop and find all selected models
	If dw_im.GetItemNumber(li_Count, "Sel")>0 then 
		ls_Clause += String(dw_im.GetItemNumber(li_Count, "im_id")) + ","
		li_Sel ++
	End If
Next	
If (li_Sel = 0) and (g_Obj.DeptId = 1) then Return  // If nothing selected
If li_Sel < dw_im.RowCount() then  // If some models are deselected, then add to sql
	ls_Clause = Left(ls_Clause, Len(ls_Clause) - 1)
	If li_Sel = 1 then ls_Clause = "(VETT_INSP.IM_ID = " + ls_Clause + ")" Else ls_Clause = "(VETT_INSP.IM_ID in (" + ls_Clause + "))"	
	ls_Where += " and " + ls_Clause
End If

// Vessel Types
ls_Clause = ""
li_Sel = 0
For li_Count = 1 to dw_type.RowCount( )  // Loop and find all selected types
	If dw_type.GetItemNumber(li_Count, "Sel")>0 then 
		ls_Clause += String(dw_type.GetItemNumber(li_Count, "type_id")) + ","
		li_Sel ++
	End If
Next	
If (li_Sel = 0) and (g_Obj.DeptId = 1) then Return  // If nothing selected	
If li_Sel < dw_type.RowCount() then  // If some types are deselected, then add to sql
	ls_Clause = Left(ls_Clause, Len(ls_Clause) - 1)
	If li_Sel = 1 then ls_Clause = "(VETT_VSLTYPE.TYPE_ID = " + ls_Clause + ")" Else ls_Clause = "(VETT_VSLTYPE.TYPE_ID in (" + ls_Clause + "))"	
	ls_Where += " and " + ls_Clause
End If

// Responsible user
ls_Clause = ""
li_Sel = 0
For li_Count = 1 to dw_vett.RowCount( )
	If dw_vett.GetItemNumber(li_Count, "Sel")>0 then 
		ls_Clause += "'" + String(dw_vett.GetItemString(li_Count, "userid")) + "'," 
		li_Sel ++
	End If
Next	
If (li_Sel = 0) and (g_Obj.DeptId = 1) then Return
If li_Sel < dw_vett.RowCount() then
	ls_Clause = Left(ls_Clause, Len(ls_Clause) - 1)
	If li_Sel = 1 then ls_Clause = "(RESP = " + ls_Clause + ")" Else ls_Clause = "(RESP in (" + ls_Clause + "))"	
	ls_Where += " and " + ls_Clause
End If

// Vetting Office
ls_Clause = ""
li_Sel = 0
For li_Count = 1 to dw_Office.RowCount( )
	If dw_Office.GetItemNumber(li_Count, "Sel")>0 then 
		ls_Clause += String(dw_Office.GetItemNumber(li_Count, "vett_officeid")) + "," 
		li_Sel ++
	End If
Next	
If (li_Sel = 0) and (g_Obj.DeptId = 1) then Return
If li_Sel < dw_Office.RowCount() then
	ls_Clause = Left(ls_Clause, Len(ls_Clause) - 1)
	If li_Sel = 1 then ls_Clause = "(VETT_OFFICEID = " + ls_Clause + ")" Else ls_Clause = "(VETT_OFFICEID in (" + ls_Clause + "))"	
	ls_Where += " and " + ls_Clause
End If

// Create clause for period
ls_Clause = ""
Choose Case ii_Period
	Case 2  // Before
		ls_Clause = "(INSPDATE < '" + String(dp_from.Value, "yyyy-MM-dd") + "')"
	Case 3  // After
		ls_Clause = "(INSPDATE > '" + String(dp_from.Value, "yyyy-MM-dd") + "')"
	Case 4  // Between
		ls_Clause = "(INSPDATE >= '" + String(dp_from.Value, "yyyy-MM-dd") + "') and (INSPDATE <= '" + String(dp_To.Value, "yyyy-MM-dd") + "')"			
End Choose

If ls_Clause > "" then ls_Where += " and " + ls_Clause

ls_SQL = "SELECT VETT_INSP.INSP_ID, VESSELIMO, VETT_INSP.IM_ID, VESSEL_NAME, TYPE_NAME, VETT_COMP.NAME AS CNAME, PORT_N,"&
        + "INSPDATE, VETT_INSPMODEL.NAME AS MNAME, EDITION,	SUM(Case When ANS=1 Then 1 Else 0 End) as TOTAL, SUM(IsNull(DEF,0)) AS ITEMS,"&
		  + "SUM(Case When (CLOSED=0) and (DEF=1) then 1 Else 0 End) as OPENITEMS, RESP,"&
		  + "COMPLETED, LOCKED, RATING, VSLSCORE, GLOBALID,EXPFLAG,TECH_REVIEW,VETT_INVIMS,VESSEL_ACTIVE,Max(Cast(VSLCOMM as VarChar)) as COMMENTS,"&
		  + "(Select Count(*) from VETT_ATT Where (VETT_ATT.INSP_ID = VETT_INSP.INSP_ID) and (Upper(VETT_ATT.FILENAME)= 'REPORT.PDF') and (VETT_ATT.ITEM_ID is Null) and (VETT_ATT.SM_ID is Null)) as PDF, "&
			+ "(Select Count(*) from VETT_ATT Where VETT_ATT.INSP_ID = VETT_INSP.INSP_ID) as ATT, "&
		  + "(Select Count(TIME_ID) from VETT_ITEMHIST Inner Join VETT_ITEM on VETT_ITEMHIST.ITEM_ID = VETT_ITEM.ITEM_ID Where (VETT_ITEMHIST.STATUS = 0) and (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID)) as NEWCOMMENTS, HASRATING, "&
		  + "(Select Sum(Case When STARS is Null Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as NULLSTARS,"&
   	  + "(Select Sum(STARS) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as SUMSTARS,"&
   	  + "(Select Sum(Case When STARS > 0 Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as VALIDSTARS,"&
		  + "SHORTNAME,VESSEL_EMAIL, MGMT_REVIEW, VETT_INSP.VBIS,VETT_INSP.VSLDET "&
		  + "FROM (((((VETT_INSP INNER JOIN VETT_COMP ON VETT_INSP.COMP_ID = VETT_COMP.COMP_ID) "&
		  + "INNER JOIN PORTS ON VETT_INSP.PORT = PORTS.PORT_CODE) "&
		  + "INNER JOIN VETT_INSPMODEL ON VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID) "&
		  + "INNER JOIN VESSELS ON VETT_INSP.VESSELIMO = VESSELS.IMO_NUMBER) "&
		  + "INNER JOIN VETT_VSLTYPE ON VETT_VSLTYPE.TYPE_ID = VESSELS.VETT_TYPE) "&
		  + "LEFT OUTER JOIN VETT_ITEM ON VETT_INSP.INSP_ID = VETT_ITEM.INSP_ID " + ls_Where&
		  + " GROUP BY VETT_INSP.INSP_ID,VESSELIMO,VETT_INSP.IM_ID,VESSEL_NAME,TYPE_NAME,VETT_COMP.NAME ,PORT_N,INSPDATE,VETT_INSPMODEL.NAME ,EDITION,RESP,COMPLETED,LOCKED,"&
		  + " RATING,VSLSCORE, GLOBALID,EXPFLAG,TECH_REVIEW,HASRATING,SHORTNAME, VESSEL_EMAIL, MGMT_REVIEW "
	  
dw_Insp.SetSQLSelect(ls_SQL)

f_Write2Log("Inbox Where Clause: " + ls_Where)

If cbx_new.Checked then	dw_insp.SetFilter("Newcomments > 0") Else	dw_Insp.SetFilter("")

dw_Insp.Filter( )

dw_Insp.Retrieve(g_Obj.DeptID)

dw_Insp.SetRedraw(True)


end subroutine

public subroutine wf_openatt ();
OpenWithParm(w_AttFull, g_Obj.InspID)

Do While Message.DoubleParm > 0
	If Message.Doubleparm = 1 then OpenWithParm(w_AttFull, g_Obj.InspID) Else OpenWithParm(w_Thumbs, g_Obj.InspID)
Loop
end subroutine

private subroutine wf_openreport (long al_attid, string as_filename);
If g_Obj.TempFolder = "" then
	Messagebox("Temp Folder Not Available", "Temporary folder for extraction is not available. Please save this report to disk and then open.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

as_FileName = "Temp_" + String(Rand(99999)) + "_" + as_FileName

n_vimsatt l_att
l_att = create n_vimsatt
al_AttID = l_att.of_SaveAttachment(al_AttID, g_Obj.TempFolder + as_FileName)
Destroy l_att

If al_AttID < 0 then Return

ShellExecute(Handle(This), "open", g_Obj.TempFolder + as_FileName, "", "", 3)

end subroutine

public subroutine wf_loadfilters ();// This function loads filters from the database and selects the items in the datawindows

uo_UserSetting ln_Sett
uo_DWSelection ln_DW
String ls_Temp

// Vessel Type
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Type", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Type, "Type_ID", False, ls_Temp)

// Inspection Type
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-IM", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_IM, "IM_ID", False, ls_Temp)

// Responsible
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Resp", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Vett, "UserID", True, ls_Temp)

// Office
ln_Sett.of_Getsetting(g_Obj.UserID, is_Setting + "-Office", ls_Temp, "U;")
ln_DW.of_RestoreSelection(dw_Office, "Vett_OfficeID", False, ls_Temp)

// Period
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-Period", ls_Temp, "")
If IsNumber(ls_Temp) then
	ii_Period=Integer(ls_Temp)
	ddlb_Period.SelectItem(ii_Period)
	ddlb_Period.event selectionchanged(ii_Period)
	ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-D1", ls_Temp, "")
	If isDate(ls_Temp) Then dp_From.Value = DateTime(ls_Temp)
	ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-D2", ls_Temp, "")
	If isDate(ls_Temp) Then dp_To.Value = DateTime(ls_Temp)
End If

// Active
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-Active", ls_Temp, "")
If ls_Temp="0" Then cbx_Act.Checked = False

// Open
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-Open", ls_Temp, "")
If ls_Temp="1" Then cbx_Open.Checked = True

// Reviewd
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-Reviewed", ls_Temp, "")
If ls_Temp="1" Then cbx_Comp.Checked = True

// Closedout
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-Closed", ls_Temp, "")
If ls_Temp="1" Then cbx_Lock.Checked = True

// New Only
ln_Sett.of_GetSetting(g_Obj.UserID, is_Setting + "-New", ls_Temp, "")
If ls_Temp="1" Then cbx_New.Checked = True

end subroutine

private subroutine wf_selectdw (ref datawindow adw_box, integer ai_select);Integer li_Loop

For li_Loop = 1 to adw_Box.RowCount()
	adw_Box.SetItem(li_Loop, "Sel", ai_Select)
Next
adw_Box.SetRedraw(True)

end subroutine

on w_inbox.create
this.cbx_act=create cbx_act
this.cb_clearall=create cb_clearall
this.cb_selectall=create cb_selectall
this.cb_savefilter=create cb_savefilter
this.cb_print=create cb_print
this.cb_exp=create cb_exp
this.st_7=create st_7
this.st_6=create st_6
this.cb_office=create cb_office
this.ddlb_period=create ddlb_period
this.dw_office=create dw_office
this.cb_type=create cb_type
this.dw_type=create dw_type
this.st_5=create st_5
this.cbx_new=create cbx_new
this.cb_key=create cb_key
this.cb_resp=create cb_resp
this.st_and=create st_and
this.dw_vett=create dw_vett
this.cb_menu=create cb_menu
this.st_3=create st_3
this.st_2=create st_2
this.dp_to=create dp_to
this.dp_from=create dp_from
this.dw_im=create dw_im
this.st_1=create st_1
this.cb_filter=create cb_filter
this.st_4=create st_4
this.cbx_open=create cbx_open
this.cbx_lock=create cbx_lock
this.cbx_comp=create cbx_comp
this.cb_reply=create cb_reply
this.cb_report=create cb_report
this.cb_hist=create cb_hist
this.cb_edit=create cb_edit
this.dw_insp=create dw_insp
this.gb_1=create gb_1
this.Control[]={this.cbx_act,&
this.cb_clearall,&
this.cb_selectall,&
this.cb_savefilter,&
this.cb_print,&
this.cb_exp,&
this.st_7,&
this.st_6,&
this.cb_office,&
this.ddlb_period,&
this.dw_office,&
this.cb_type,&
this.dw_type,&
this.st_5,&
this.cbx_new,&
this.cb_key,&
this.cb_resp,&
this.st_and,&
this.dw_vett,&
this.cb_menu,&
this.st_3,&
this.st_2,&
this.dp_to,&
this.dp_from,&
this.dw_im,&
this.st_1,&
this.cb_filter,&
this.st_4,&
this.cbx_open,&
this.cbx_lock,&
this.cbx_comp,&
this.cb_reply,&
this.cb_report,&
this.cb_hist,&
this.cb_edit,&
this.dw_insp,&
this.gb_1}
end on

on w_inbox.destroy
destroy(this.cbx_act)
destroy(this.cb_clearall)
destroy(this.cb_selectall)
destroy(this.cb_savefilter)
destroy(this.cb_print)
destroy(this.cb_exp)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.cb_office)
destroy(this.ddlb_period)
destroy(this.dw_office)
destroy(this.cb_type)
destroy(this.dw_type)
destroy(this.st_5)
destroy(this.cbx_new)
destroy(this.cb_key)
destroy(this.cb_resp)
destroy(this.st_and)
destroy(this.dw_vett)
destroy(this.cb_menu)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.dw_im)
destroy(this.st_1)
destroy(this.cb_filter)
destroy(this.st_4)
destroy(this.cbx_open)
destroy(this.cbx_lock)
destroy(this.cbx_comp)
destroy(this.cb_reply)
destroy(this.cb_report)
destroy(this.cb_hist)
destroy(this.cb_edit)
destroy(this.dw_insp)
destroy(this.gb_1)
end on

event open;Integer li_Row

// Init all DW
dw_Insp.SetTransobject(SQLCA)
dw_Im.SetTransObject(SQLCA)
dw_Vett.SetTransObject(SQLCA)
dw_Type.SetTransObject(SQLCA)
dw_Office.SetTransObject(SQLCA)

// Set title
This.Title = 'Inspection Inbox - ' + g_obj.Dept

// Set rating colors
dw_Insp.Modify("rating.color = '0 ~t If( Left(Rating,1) <= ~"" + g_obj.InspGreen + "~", 32768, If(Left(Rating,1) <=~"" + g_obj.InspYellow + "~", 49344, 192))'")

dw_im.Retrieve( )
For li_Row = 1 to dw_im.RowCount( )
	dw_im.SetItem(li_Row, "Sel", 1)
Next
dw_Vett.Retrieve()
For li_Row = 1 to dw_Vett.RowCount( )
	dw_Vett.SetItem(li_Row, "Sel", 1)
Next	
dw_Type.Retrieve()
For li_Row = 1 to dw_Type.RowCount( )
	dw_Type.SetItem(li_Row, "Sel", 1)
Next		
dw_Office.Retrieve()
For li_Row = 1 to dw_Office.RowCount()
	dw_Office.SetItem(li_Row, "Sel", 1)
Next

// Create menus
im_Select = Create m_selection_im
im_Resp = Create m_selection_user
im_Type = Create m_selection_type
im_office = Create m_selection

ddlb_Period.SelectItem(1)

Post wf_LoadFilters()
end event

event resize;
If newwidth < 4800 then This.Width = 4800
If newheight < 2000 then This.Height = 2000

dw_Insp.Width = This.WorkspaceWidth( ) - dw_Insp.x * 2
dw_Insp.Height = This.WorkSpaceHeight() - dw_Insp.y - cb_Edit.Height - dw_Insp.x

cb_Edit.y = dw_Insp.y + dw_Insp.height
cb_Report.y = cb_Edit.y
cb_Reply.y = cb_Edit.y
cb_Hist.y = cb_Edit.y
cb_Exp.y = cb_Edit.y
cb_Key.y = cb_Edit.y
cb_Print.y = cb_Edit.y

Integer li_X
cb_Key.X = dw_Insp.X + dw_Insp.Width - cb_Key.Width

cb_Filter.X = dw_Insp.X + dw_Insp.Width - cb_Filter.Width


end event

event close;
If g_Obj.DeptID = 1 then
	Destroy im_Select
	Destroy im_Resp
	Destroy im_Type
	Destroy im_Office
End If
end event

type cbx_act from checkbox within w_inbox
integer x = 3072
integer y = 496
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active Vessels Only"
boolean checked = true
end type

type cb_clearall from commandbutton within w_inbox
integer x = 4005
integer y = 80
integer width = 279
integer height = 68
integer taborder = 110
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Clear All"
end type

event clicked;
cbx_open.Checked = False
cbx_lock.Checked = False
cbx_new.Checked = False
cbx_comp.Checked = False
cbx_Act.Checked = False
ddlb_Period.Selectitem(1)
ddlb_Period.event SelectionChanged(1)

wf_SelectDW(dw_IM, 0)
wf_SelectDW(dw_Insp, 0)
wf_SelectDW(dw_Office, 0)
wf_SelectDW(dw_Type, 0)
wf_SelectDW(dw_Vett, 0)

end event

type cb_selectall from commandbutton within w_inbox
integer x = 4005
integer y = 16
integer width = 279
integer height = 68
integer taborder = 100
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Select All"
end type

event clicked;
cbx_open.Checked = True
cbx_lock.Checked = True
cbx_new.Checked = True
cbx_comp.Checked = True
cbx_Act.Checked = True
ddlb_Period.Selectitem(1)
ddlb_Period.event SelectionChanged(1)

wf_SelectDW(dw_IM, 1)
wf_SelectDW(dw_Insp, 1)
wf_SelectDW(dw_Office, 1)
wf_SelectDW(dw_Type, 1)
wf_SelectDW(dw_Vett, 1)

end event

type cb_savefilter from commandbutton within w_inbox
integer x = 4005
integer y = 176
integer width = 279
integer height = 68
integer taborder = 80
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Save Filters"
end type

event clicked;
uo_DWSelection ln_Save
uo_UserSetting ln_User
String ls_Data
Boolean lbool_Err = False

// Save Type
If ln_Save.of_SaveSelection(dw_Type, "Type_ID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Type") 
	Else
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Type", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Insp Type
If ln_Save.of_SaveSelection(dw_IM, "IM_ID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-IM") 
	Else
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-IM", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Resp
If ln_Save.of_SaveSelection(dw_Vett, "userid", True, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Resp") 
	Else
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Resp", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Save Office
If ln_Save.of_SaveSelection(dw_Office, "Vett_OfficeID", False, ls_Data) = 1 then
	If ls_Data = "U;" then 
		ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Office") 
	Else
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Office", ls_Data) <0 then lbool_Err = True
	End If
Else
	lbool_Err = True
End If

// Period
If Not lbool_Err Then
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Period")
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-D1")
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-D2")

	If ii_Period>1 Then		
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Period", String(ii_Period)) <0 then lbool_Err = True
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-D1", dp_From.Text ) <0 then lbool_Err = True
	End If
	If ii_Period=4 Then
		If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-D2", dp_To.Text ) <0 then lbool_Err = True
	End If
End If

// Open
If cbx_Open.Checked Then 
	If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Open", "1")<0 Then lbool_Err = True
Else 
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Open")
End If

// Reviewed
If cbx_Comp.Checked Then 
	If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Reviewed", "1")<0 Then lbool_Err = True
Else 
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Reviewed")
End If

// Closedout
If cbx_Lock.Checked Then 
	If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Closed", "1")<0 Then lbool_Err = True
Else 
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Closed")
End If

// New Only
If cbx_New.Checked Then 
	If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-New", "1")<0 Then lbool_Err = True
Else 
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-New")
End If

// Active Only
If cbx_Act.Checked Then 
	ln_User.of_DeleteSetting(g_Obj.UserID, is_Setting + "-Active")
Else 
	If ln_User.of_Savesetting(g_Obj.UserID, is_Setting + "-Active", "0")<0 Then lbool_Err = True
End If

If lbool_Err then
	Messagebox("Error Saving Filters", "One or more filters were not saved successfully. Please check filters when opening window next.", Exclamation!)
Else
	Messagebox("Filters Saved", "The filter settings were saved successfully.")
End If
end event

type cb_print from commandbutton within w_inbox
integer x = 1847
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Print..."
end type

event clicked;
//dw_insp.SaveAs("", PDF!, True)
dw_insp.Print(true,true)
end event

type cb_exp from commandbutton within w_inbox
integer x = 1481
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Export..."
end type

event clicked;
// If user is not Vetting dept, check if inspection is not yet reviewed
If g_Obj.DeptID > 1 then 
	If dw_insp.GetItemNumber(dw_insp.GetRow(), "Completed") = 0 then
		Messagebox("Inspection Under Review", "The selected inspection is currently under review. The inspection can be exported only after the inspection has been reviewed.", Information!)
		Return
	End If
End If

// Get the Insp ID
g_Obj.InspID = dw_Insp.GetItemNumber(dw_Insp.GetRow(), "Insp_ID")

// Get vessel's email address
g_Obj.ObjString = Trim(dw_Insp.GetItemString(dw_Insp.GetRow(), "Vessel_Email"), True)
If IsNull(g_Obj.ObjString) then g_Obj.ObjString = ""

// If Vetting dept RW/SU and Email valid then enable sending to vessel direct
If (g_Obj.DeptID = 1) and (g_Obj.Access > 1) and (g_Obj.ObjString>"") then g_Obj.Level = 1 else g_Obj.Level = 0

// Open the Export window
Open(w_Export)

// If export is successful, refresh row and update flag
If g_Obj.InspID > 0 then 
	wf_RefreshRow()
	If (dw_insp.GetItemNumber(dw_Insp.GetRow(), "ExpFlag") < 2) then  // Update flag only if required
		Update VETT_INSP Set EXPFLAG = 2 Where INSP_ID = :g_Obj.InspID;
		Commit;  // No need to check for error
	End If
End If
end event

type st_7 from statictext within w_inbox
integer x = 18
integer y = 608
integer width = 402
integer height = 64
integer textsize = -10
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

type st_6 from statictext within w_inbox
integer x = 2304
integer y = 48
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Office:"
boolean focusrectangle = false
end type

type cb_office from commandbutton within w_inbox
integer x = 2926
integer y = 112
integer width = 73
integer height = 64
integer taborder = 100
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

im_Office.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type ddlb_period from dropdownlistbox within w_inbox
integer x = 3072
integer y = 112
integer width = 421
integer height = 320
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"All","Before","After","Between"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Choose Case index
	Case 1
		dp_from.Visible = False
		dp_To.Visible = False
		st_And.Visible = False
	Case 2, 3
		dp_from.Visible = True
		dp_To.Visible = False
		st_And.Visible = False
	Case 4
		dp_from.Visible = True
		dp_To.Visible = True
		st_And.Visible = True
End Choose

ii_Period = index
end event

type dw_office from datawindow within w_inbox
integer x = 2304
integer y = 112
integer width = 622
integer height = 448
integer taborder = 90
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
end event

type cb_type from commandbutton within w_inbox
integer x = 658
integer y = 112
integer width = 73
integer height = 64
integer taborder = 70
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

im_Type.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type dw_type from datawindow within w_inbox
integer x = 55
integer y = 112
integer width = 603
integer height = 448
integer taborder = 90
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

end event

type st_5 from statictext within w_inbox
integer x = 55
integer y = 48
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Type:"
boolean focusrectangle = false
end type

type cbx_new from checkbox within w_inbox
integer x = 3602
integer y = 352
integer width = 352
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Only"
end type

type cb_key from commandbutton within w_inbox
integer x = 4443
integer y = 2320
integer width = 338
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Rating?"
end type

event clicked;Integer li_Nulls

Messagebox("Inspection Rating", "The inspection is rated as per the total score calculated:~n~n>= 90  :  A~n>= 75  :  B~n>= 60  :  C~n>= 45  :  D~n>= 30  :  E~n <   30  :  F~n~n'+' is appended if the inspection contains only low risk items.~n~n'-' is appended if the inspection contains any high risk items.")


end event

type cb_resp from commandbutton within w_inbox
integer x = 2158
integer y = 112
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
ii_MenuSel = 1

im_Resp.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type st_and from statictext within w_inbox
boolean visible = false
integer x = 3072
integer y = 304
integer width = 421
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "and"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_vett from datawindow within w_inbox
integer x = 1554
integer y = 112
integer width = 603
integer height = 448
integer taborder = 80
string title = "none"
string dataobject = "d_sq_tb_vettusers"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

end event

type cb_menu from commandbutton within w_inbox
integer x = 1408
integer y = 112
integer width = 73
integer height = 64
integer taborder = 40
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

im_Select.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type st_3 from statictext within w_inbox
integer x = 1554
integer y = 48
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Responsible:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_inbox
integer x = 3584
integer y = 48
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Status:"
boolean focusrectangle = false
end type

type dp_to from datepicker within w_inbox
boolean visible = false
integer x = 3072
integer y = 368
integer width = 421
integer height = 80
integer taborder = 80
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2017-04-11"), Time("23:34:33.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dp_from from datepicker within w_inbox
boolean visible = false
integer x = 3072
integer y = 208
integer width = 421
integer height = 80
integer taborder = 70
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2017-04-11"), Time("23:34:33.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dw_im from datawindow within w_inbox
integer x = 805
integer y = 112
integer width = 603
integer height = 448
integer taborder = 60
string title = "none"
string dataobject = "d_sq_tb_rep_im"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.SetRedraw(False)
If Row > 0 then This.SetItem(row, "Sel", 1 - This.GetItemNumber(row, "Sel"))
This.SetRedraw(True)

end event

type st_1 from statictext within w_inbox
integer x = 805
integer y = 48
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Type:"
boolean focusrectangle = false
end type

type cb_filter from commandbutton within w_inbox
integer x = 4005
integer y = 480
integer width = 750
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve Inspections"
end type

event clicked;

This.Enabled = False
cb_SaveFilter.Enabled = False
This.Text = "Retrieving..."
SetPointer(HourGlass!)

wf_Retrieve( )

This.Enabled = True
This.Text = "Retrieve Inspections"
cb_SaveFilter.Enabled = True

end event

type st_4 from statictext within w_inbox
integer x = 3072
integer y = 48
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Period:"
boolean focusrectangle = false
end type

type cbx_open from checkbox within w_inbox
integer x = 3602
integer y = 112
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open"
end type

type cbx_lock from checkbox within w_inbox
integer x = 3602
integer y = 272
integer width = 352
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Closed-Out"
end type

type cbx_comp from checkbox within w_inbox
integer x = 3602
integer y = 192
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reviewed"
end type

type cb_reply from commandbutton within w_inbox
integer x = 750
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Insp Reply"
end type

event clicked;
SetPointer(HourGlass!)

If dw_insp.GetItemNumber( dw_insp.GetRow(), "Completed") = 0 and g_Obj.DeptID > 1 then // If review not completed and user is not Vetting
	Messagebox("Inspection Under Review", "The selected inspection is currently under review. Please note that the operator's comments provided may not be complete.", Information!)
End If

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_inspreply"

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve( g_obj.InspID)    // Retrieve Master

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

w_preview.wf_ShowReport()
end event

type cb_report from commandbutton within w_inbox
integer x = 384
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Insp Report"
end type

event clicked;
SetPointer(HourGlass!)

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

If dw_insp.GetItemNumber( dw_insp.GetRow(), "Completed") = 0 and g_Obj.DeptID > 1 then // If review not completed and user is not Vetting
	Messagebox("Inspection Under Review", "The selected inspection is currently under review. The inspection report can only be opened after the inspection has been reviewed.", Information!)
	Return
End If

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_insprep"
	
If Left(dw_insp.GetItemString(dw_insp.GetRow(), "mname"), 4) = "MIRE" then 
	If MessageBox("Report Type", "You have selected a MIRE Inspection.~n~nWould you like to open the MIRE report format instead of the standard VIMS Inspection Report?", Question!, YesNo!) = 1 then w_preview.dw_rep.dataobject = "d_rep_insprep_mire" 
End If

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve( g_obj.InspID)    // Retrieve Master

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

w_preview.wf_ShowReport()
end event

type cb_hist from commandbutton within w_inbox
integer x = 1115
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Show History"
end type

event clicked;SetPointer(HourGlass!)

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_hist, w_Main, 0, Original!)
end event

type cb_edit from commandbutton within w_inbox
integer x = 18
integer y = 2336
integer width = 366
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Open"
end type

event clicked;String ls_UserLock

SetPointer(HourGlass!)

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

Select USER_LOCK into :ls_UserLock from VETT_INSP Where INSP_ID = :g_obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_UserLock) then
		If g_Obj.DeptID = 1 Then MessageBox("Inspection Locked", "The selected inspection is being edited by the user " + ls_UserLock + ".~n~nYou cannot make any changes to the inspection.")
		g_Obj.Level = 0
	Else
		If g_Obj.Access > 1 and g_Obj.deptID = 1 then  // If user is vetting and has R/W rights, then lock insp for editing
			Update VETT_INSP Set USER_LOCK = :g_Obj.UserID Where INSP_ID = :g_obj.Inspid;
			If SQLCA.SQLCode <> 0 then
				MessageBox("DB Error", "Unable to lock inspection for editing.~n~n" + SQLCA.SQLErrtext, Exclamation!)
				Rollback;
				Return
			End If
			Commit;
			g_Obj.Level = 1
		Else
			g_Obj.Level = 0
		End If
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
End If

g_obj.ObjString = dw_insp.GetItemString( dw_insp.GetRow(), "Vessel_Name")

Open(w_inspdetail)
SetPointer(HourGlass!)
wf_refreshrow( )




end event

type dw_insp from datawindow within w_inbox
integer x = 18
integer y = 688
integer width = 4718
integer height = 1552
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_inspinbox"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If Rowcount > 0 then
	cb_Edit.Enabled = True
	cb_Hist.Enabled = True
	dw_Insp.SetRow(RowCount)
	dw_Insp.ScrollToRow(RowCount)
	cb_Report.Enabled = True
	cb_Reply.Enabled = True		
	cb_Exp.Enabled = True
	cb_Print.Enabled = True
Else
	cb_Edit.Enabled = False
	cb_Hist.Enabled = False
	cb_Report.Enabled = False
	cb_Reply.Enabled = False
	cb_Exp.Enabled = False
	cb_Print.Enabled = False
End If
end event

event clicked;String ls_sort
Long ll_AttID

If (dwo.type = "text") then
	ls_Sort = trim(dwo.Tag)
	If Len(ls_Sort) > 1 then
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

If dwo.name = "p_up" then MessageBox("Current Dept", "This inspection is presently with the " + This.GetItemString(row, "DeptName") + " department.")
If dwo.name = "p_mgmt" then post Messagebox("Management Notification", "Management has been notified about this inspection.")
If dwo.name = "p_vbis" then post Messagebox("VBIS Prize", "This inspection qualified for the VBIS Payout of USD " + String(this.GetItemNumber(row,"VBIS") * 500)+ ". An email was sent to the vessel.")
If dwo.name = "t_det" then post Messagebox("Vessel Detention", "The inspection resulted in the vessel being detained.")

If dwo.name = "p_rep" then
	g_obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	If This.GetItemNumber(row, "pdf") > 1 then
		MessageBox("Report Ambiguity", "This inspection has more than 1 attachment with the name Report.pdf. Please open the inspection and check the attachments.", Exclamation!)
	Else

		Select Top 1 ATT_ID, FILENAME into :ll_AttID, :ls_Sort From VETT_ATT Where (INSP_ID = :g_obj.InspID) and (Upper(FILENAME)= 'REPORT.PDF') and (ITEM_ID is Null) and (SM_ID is Null);
		
		If SQLCA.SQLCode = 0 then
			Commit;
			Post wf_OpenReport(ll_AttID, ls_Sort)
		Else
			Messagebox("DB Error", "Attachment ID could not be retrieved.~n~nError: " + SQLCA.SqlErrtext, Exclamation!)
			Rollback;			
		End If
	End If
End If

If dwo.name = "t_new" then
	ll_AttID = This.GetItemNumber(row, "newcomments")
	If ll_AttID = 1 then
		ls_sort = "There is " + String(ll_AttID) + " new comment in this inspection."
	Else
		ls_sort = "There are " + String(ll_AttID) + " new comments in this inspection."
	End If
	Post Messagebox("New Comments", ls_Sort, Information!)
End If

If dwo.name = "att" or dwo.name = "p_att" then
	g_Obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	Post wf_OpenAtt()
End If
end event

event doubleclicked;
If (row > 0) and cb_edit.Enabled then cb_Edit.event clicked( )
end event

event rowfocuschanged;
// PB Bug - Detail background colour does not refresh when using arrow keys to select rows
// Workaround: This must be done to refresh the row colors when using arrow keys to navigate
This.SetRedraw(False)
This.SetRedraw(True)

end event

type gb_1 from groupbox within w_inbox
integer x = 18
integer width = 3950
integer height = 592
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
end type

