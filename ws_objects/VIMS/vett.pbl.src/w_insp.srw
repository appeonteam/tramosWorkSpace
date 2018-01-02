$PBExportHeader$w_insp.srw
forward
global type w_insp from window
end type
type st_tip from statictext within w_insp
end type
type ddlb_im from dropdownlistbox within w_insp
end type
type uo_filter from vo_vslfilter within w_insp
end type
type st_insp from statictext within w_insp
end type
type st_count from statictext within w_insp
end type
type cb_exp from commandbutton within w_insp
end type
type cbx_18 from checkbox within w_insp
end type
type cb_key from commandbutton within w_insp
end type
type cb_hist from commandbutton within w_insp
end type
type cb_reply from commandbutton within w_insp
end type
type cb_rep from commandbutton within w_insp
end type
type cb_del from commandbutton within w_insp
end type
type cb_edit from commandbutton within w_insp
end type
type cb_new from commandbutton within w_insp
end type
type dw_vsl from datawindow within w_insp
end type
type gb_vsl from groupbox within w_insp
end type
type dw_insp from datawindow within w_insp
end type
type gb_insp from groupbox within w_insp
end type
type st_resize from statictext within w_insp
end type
type sle_search from singlelineedit within w_insp
end type
end forward

global type w_insp from window
integer width = 4946
integer height = 2584
boolean titlebar = true
string title = "Inspection Browser"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Browse.ico"
boolean center = true
event ue_contextmenuclick ( integer ai_menuitem )
st_tip st_tip
ddlb_im ddlb_im
uo_filter uo_filter
st_insp st_insp
st_count st_count
cb_exp cb_exp
cbx_18 cbx_18
cb_key cb_key
cb_hist cb_hist
cb_reply cb_reply
cb_rep cb_rep
cb_del cb_del
cb_edit cb_edit
cb_new cb_new
dw_vsl dw_vsl
gb_vsl gb_vsl
dw_insp dw_insp
gb_insp gb_insp
st_resize st_resize
sle_search sle_search
end type
global w_insp w_insp

type variables

Boolean ibool_SplitMove
Integer ii_YPos, ii_WinHeight
end variables

forward prototypes
public subroutine wf_setbuttons ()
public subroutine wf_filterinspections ()
public subroutine wf_updateexpflag (string as_globalid, integer ai_flag)
public subroutine wf_openattachment (long al_attid, string as_filename)
public subroutine wf_openatt ()
public subroutine wf_refreshrow ()
public subroutine wf_refreshvsl ()
public subroutine wf_searchvsl ()
end prototypes

event ue_contextmenuclick(integer ai_menuitem);
// Raise event for uo_Filter
uo_Filter.Event ue_ContextMenuClick(ai_MenuItem)
end event

public subroutine wf_setbuttons ();
If dw_insp.Rowcount() > 0 then
	If g_Obj.Access > 1 then  // If access level above 'Readonly'
		cb_Exp.Enabled = True
		If g_obj.DeptID = 1 then  // If vetting dept
			cb_Del.Enabled = True
			cb_Edit.Text = "Edit"
		End If
	End If
	cb_Edit.Enabled = True
	cb_Rep.Enabled = True
	cb_Reply.Enabled = True
	cb_Hist.Enabled = True
Else
	cb_Del.Enabled = False
	cb_Edit.Enabled = False
	cb_Rep.Enabled = False
	cb_Reply.Enabled = False
	cb_Hist.Enabled = False
	cb_Exp.Enabled = False
End If
end subroutine

public subroutine wf_filterinspections ();Integer li_RowCount
String ls_Filter
DateTime ldt_18m

If ddlb_IM.Text > "< All >" then	ls_Filter = "(shortname = '" + ddlb_IM.Text + "')"

If cbx_18.Checked then 
	ldt_18m = f_AddMonths(DateTime(Today()), -18)
	If ls_Filter > "" then ls_Filter += " And "
	ls_Filter += "(InspDate >= " + String(ldt_18m, "yyyy-mm-dd") + ")"
End If
	
dw_insp.SetFilter(ls_Filter)
dw_Insp.Filter()

li_RowCount = dw_Insp.RowCount()

st_Insp.Text = "( " + String(li_RowCount) + " inspection"
If li_RowCount = 1 then st_Insp.Text += " )" else st_Insp.Text += "s )"

wf_Setbuttons( )
end subroutine

public subroutine wf_updateexpflag (string as_globalid, integer ai_flag);// This function updates the displayed flag for the inspection with the globalID

Integer li_Loop 

For li_Loop = 1 to dw_insp.RowCount()
	If dw_insp.GetItemString(li_loop, "GlobalID") = as_GlobalID then dw_Insp.SetItem(li_Loop, "EXPFLAG", ai_Flag)
Next


end subroutine

public subroutine wf_openattachment (long al_attid, string as_filename);n_vimsatt ln_Att


If g_Obj.TempFolder = "" then
	Messagebox("Temp Folder Not Available", "Temporary folder for extraction is not available. Please save this report to disk and then open.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

as_FileName = "Temp_" + String(Rand(99999)) + "_" + as_FileName

ln_att = create n_vimsatt
al_AttID = ln_att.of_SaveAttachment(al_AttID, g_Obj.TempFolder + as_FileName)
destroy ln_att

If al_AttID < 0 then
  Messagebox("Attachment Not Found", "The selected attachment could not be found.~n~nError Code: "+String(al_AttID), Exclamation!)
	Return
End If

ShellExecute(Handle(This), "open", g_Obj.TempFolder + as_FileName, "", "", 3)

end subroutine

public subroutine wf_openatt ();
OpenWithParm(w_AttFull, g_Obj.InspID)

Do While Message.DoubleParm > 0
	If Message.Doubleparm = 1 then OpenWithParm(w_AttFull, g_Obj.InspID) Else OpenWithParm(w_Thumbs, g_Obj.InspID)
Loop
end subroutine

public subroutine wf_refreshrow ();Long ll_Row, ll_InspID, ll_Items, ll_Open, ll_comp, ll_Locked, ll_Total
Integer li_PDF, li_NewComm, li_Att, li_Flag, li_NullStars, li_SumStars, li_ValidStars, li_Tech, li_Mgmt, li_VBIS, li_Det
String ls_CName, ls_Port, ls_Rating, ls_Comments
DateTime ldt_InspDate, ldt_Expires
Decimal ldec_Score

ll_Row = dw_insp.GetRow( )

ll_InspID = dw_insp.GetItemNumber(ll_Row, "Insp_ID")

SELECT VETT_COMP.NAME AS CNAME,
         PORT_N,
         INSPDATE,  
         EXPIRES,
			SUM(Case ANS When 1 Then 1 Else 0 End) as TOTAL,
			SUM(IsNull(DEF,0)) AS ITEMS,     
			SUM(Case When (CLOSED=0) and (DEF=1) then 1 Else 0 End) as OPENITEMS,
			RATING,
			COMPLETED,
			VSLSCORE,
			LOCKED,
			(Select Count(*) from VETT_ATT Where (VETT_ATT.INSP_ID = VETT_INSP.INSP_ID) and (Upper(VETT_ATT.FILENAME)= 'REPORT.PDF') and (VETT_ATT.ITEM_ID is Null) and (VETT_ATT.SM_ID is Null)),
			(Select Count(*) from VETT_ATT Where VETT_ATT.INSP_ID = VETT_INSP.INSP_ID),
      (Select Count(TIME_ID) from VETT_ITEMHIST Inner Join VETT_ITEM on VETT_ITEMHIST.ITEM_ID = VETT_ITEM.ITEM_ID Where (VETT_ITEMHIST.STATUS = 0) and (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID)),
			Max(Cast(VSLCOMM as VarChar)) as COMMENTS,
			EXPFLAG,VSLDET,
      (Select Sum(Case When STARS is Null Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as NULLSTARS,
   		(Select Sum(STARS) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as SUMSTARS,
   		(Select Sum(Case When STARS > 0 Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as VALIDSTARS,
			TECH_REVIEW, MGMT_REVIEW, VETT_INSP.VBIS
	INTO
		 : ls_CName,
		 : ls_Port,
		 : ldt_InspDate,
		 : ldt_Expires,
		 : ll_Total,
		 : ll_Items,
		 : ll_Open,
		 : ls_Rating,
		 : ll_comp,
		 : ldec_Score,
		 : ll_Locked,
		 : li_PDF,
		 : li_Att,
		 : li_NewComm,
		 : ls_Comments,
		 : li_Flag,
		 : li_Det,
		 : li_NullStars,
		 : li_SumStars,
		 : li_ValidStars,
		 : li_Tech,
		 : li_Mgmt,
		 : li_VBIS
    FROM ((((VETT_INSP INNER JOIN VETT_COMP ON VETT_INSP.COMP_ID = VETT_COMP.COMP_ID) 
          INNER JOIN PORTS ON VETT_INSP.PORT = PORTS.PORT_CODE) 
          INNER JOIN VETT_INSPMODEL ON VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID) 
          LEFT OUTER JOIN VETT_ITEM ON VETT_INSP.INSP_ID = VETT_ITEM.INSP_ID)
			 LEFT OUTER JOIN VETT_RESP ON VETT_RESP.RESP_ID = VETT_ITEM.RESP_ID
WHERE VETT_INSP.INSP_ID = :ll_InspID
GROUP BY VETT_INSP.INSP_ID, VETT_COMP.NAME, PORTS.PORT_CODE, VETT_INSPMODEL.IM_ID;
	
If SQLCA.Sqlcode <> 0 then
	MessageBox("DB Error", "Could not refresh row to reflect changes. Please close and re-open the Browser.~n~n" + SQLCA.Sqlerrtext)
	Rollback;
	Return
Else
	Commit;
End If

dw_insp.SetItem( ll_Row, "Total", ll_Total)
dw_insp.SetItem( ll_Row, "Items", ll_Items)
dw_insp.SetItem( ll_Row, "OpenItems", ll_Open)
dw_insp.SetItem( ll_Row, "Expires", ldt_Expires)
dw_insp.SetItem( ll_Row, "InspDate", ldt_InspDate)
dw_insp.SetItem( ll_Row, "Port_N", ls_Port)
dw_insp.SetItem( ll_Row, "CName", ls_CName)
dw_insp.SetItem( ll_Row, "Rating", ls_Rating)
dw_insp.SetItem( ll_Row, "Completed", ll_Comp)
dw_insp.SetItem( ll_Row, "vslscore", ldec_score)
dw_insp.SetItem( ll_Row, "Locked", ll_Locked)
dw_insp.SetItem( ll_Row, "NewComments", li_NewComm)
dw_insp.SetItem( ll_Row, "PDF", li_PDF)
dw_insp.SetItem( ll_Row, "Att", li_Att)
dw_insp.SetItem( ll_Row, "VslDet", li_Det)
dw_insp.SetItem( ll_Row, "Comments", ls_Comments)
dw_insp.SetItem( ll_Row, "ExpFlag", li_Flag)
dw_insp.SetItem( ll_Row, "SumStars", li_SumStars)
dw_insp.SetItem( ll_Row, "NullStars", li_NullStars)
dw_insp.SetItem( ll_Row, "ValidStars", li_ValidStars)
dw_insp.SetItem( ll_Row, "Tech_Review", li_Tech)
dw_insp.SetItem( ll_Row, "Mgmt_Review", li_Mgmt)
dw_insp.SetItem( ll_Row, "VBIS", li_VBIS)
end subroutine

public subroutine wf_refreshvsl ();Integer li_Row, li_Insp, li_Items, li_Open, li_Total
Long ll_IMO
Decimal ldec_Score
DateTime ldt_CutDate

ldt_CutDate = f_AddMonths(DateTime(Today()), -18) // Set cut date of 18 months

li_Row = dw_vsl.GetRow()  // Get the row

ll_IMO = dw_vsl.GetItemNumber(li_Row, "IMO")   // Get IMO

Select Count(INSP_ID) into :li_Insp from VETT_INSP where VESSELIMO = :ll_IMO;  // Get total inspections

If SQLCA.Sqlcode <> 0 then
	MessageBox("DB Error", "Unable to refresh vessel table to reflect changes.~n~n" + sqlca.sqlerrtext)
	Rollback;
	Return
End If

Commit;

dw_vsl.SetItem(li_Row, "InspCount", li_Insp)  // Set total inspections

Select Count(ITEM_ID), Sum(DEF), Sum(Case When (DEF = 1) and (CLOSED = 0) then 1 Else 0 End) into :li_Total, :li_Items, :li_Open from 
	VETT_INSP Inner Join VETT_ITEM On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID 
	Inner Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID 
	Where (VETT_INSPMODEL.NAME like 'SIRE%') and (INSPDATE >= :ldt_CutDate) 
		and (VETT_INSP.VESSELIMO = :ll_IMO) and (VETT_ITEM.ANS=1);

If SQLCA.Sqlcode <> 0 then
	MessageBox("DB Error", "Unable to refresh vessel table to reflect changes.~n~n" + sqlca.sqlerrtext )
	Rollback;
	Return
End If

Commit;

dw_vsl.SetItem(li_Row, "Total", li_Total)
dw_vsl.SetItem(li_Row, "Valid", li_Items)
dw_vsl.SetItem(li_Row, "ItemOpen", li_Open)

If g_obj.Access < 2 then Return   // If ReadOnly, then no need for Rating

If g_Obj.Developer then Return    // Exit if user is developer

// Get average score
Select Avg(VSLSCORE) Into :ldec_Score 
From VETT_INSP Inner Join VETT_INSPMODEL ON VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID 
Where (VETT_INSPMODEL.NAME like 'SIRE%') and (INSPDATE >= :ldt_CutDate) and (VESSELIMO = :ll_IMO) and (COMPLETED = 1);

If SQLCA.Sqlcode <> 0 then 
	Messagebox("DB Error", "Unable to calculate 18m SIRE score for vessel.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Rollback;
Else
	ldec_Score = Round(ldec_Score, 2)  // Round to 2 decimals
	
	Update VESSELS Set VETT_SCORE = :ldec_Score Where IMO_NUMBER = :ll_IMO;  // Save score

	If SQLCA.Sqlcode <> 0 then
		Messagebox("DB Error", "Unable to update 18m SIRE score for vessel IMO " + String(ll_IMO) + ".~n~n" + sqlca.sqlerrtext, Exclamation!)			
		Rollback;
	Else
		Commit;
		dw_vsl.SetItem(li_Row, "Score", ldec_Score)
	End If
End If




end subroutine

public subroutine wf_searchvsl ();// Searches for the vessel name/number in the textbox

Integer li_Row
String ls_S

SetPointer(HourGlass!)

ls_S = Upper(Trim(sle_Search.Text, True))

li_Row = dw_Vsl.Find("(Upper(nr) like '%" + ls_S + "%') or (Upper(name) like '%" + ls_S + "%')", 0, dw_Vsl.RowCount())

If li_Row > 0 then 
	dw_Vsl.SetRedraw(False)
	dw_Vsl.Event RowFocusChanged(li_Row)
	dw_Vsl.ScrollToRow(li_Row)
	sle_Search.BackColor = 14745568
Else
	sle_Search.BackColor = 14737663
End If

end subroutine

on w_insp.create
this.st_tip=create st_tip
this.ddlb_im=create ddlb_im
this.uo_filter=create uo_filter
this.st_insp=create st_insp
this.st_count=create st_count
this.cb_exp=create cb_exp
this.cbx_18=create cbx_18
this.cb_key=create cb_key
this.cb_hist=create cb_hist
this.cb_reply=create cb_reply
this.cb_rep=create cb_rep
this.cb_del=create cb_del
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.dw_vsl=create dw_vsl
this.gb_vsl=create gb_vsl
this.dw_insp=create dw_insp
this.gb_insp=create gb_insp
this.st_resize=create st_resize
this.sle_search=create sle_search
this.Control[]={this.st_tip,&
this.ddlb_im,&
this.uo_filter,&
this.st_insp,&
this.st_count,&
this.cb_exp,&
this.cbx_18,&
this.cb_key,&
this.cb_hist,&
this.cb_reply,&
this.cb_rep,&
this.cb_del,&
this.cb_edit,&
this.cb_new,&
this.dw_vsl,&
this.gb_vsl,&
this.dw_insp,&
this.gb_insp,&
this.st_resize,&
this.sle_search}
end on

on w_insp.destroy
destroy(this.st_tip)
destroy(this.ddlb_im)
destroy(this.uo_filter)
destroy(this.st_insp)
destroy(this.st_count)
destroy(this.cb_exp)
destroy(this.cbx_18)
destroy(this.cb_key)
destroy(this.cb_hist)
destroy(this.cb_reply)
destroy(this.cb_rep)
destroy(this.cb_del)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.dw_vsl)
destroy(this.gb_vsl)
destroy(this.dw_insp)
destroy(this.gb_insp)
destroy(this.st_resize)
destroy(this.sle_search)
end on

event open;DateTime ldt_SIRE18m 

// Initalize filter object and load filters
uo_Filter.of_Initfilters(w_insp, dw_vsl, "vett.pbl>w_insp>uo_Filter", g_Obj.UserID)
uo_Filter.of_Loadfilters( )

// Init datawindows
dw_vsl.SetTransobject(SQLCA)
dw_Insp.SetTransobject(SQLCA)

// Set rating colors as per settings
dw_vsl.Modify("p_1.Visible = '0 ~t If( score >= " + String(g_obj.ScoreGreen) + ", If (Access > 1, 1,0),0)'")
dw_vsl.Modify("p_2.Visible = '0 ~t If( score >= " + String(g_obj.ScoreYellow) + " and score < " + String(g_Obj.scoregreen) + ", If (Access > 1, 1,0),0)'")
dw_vsl.Modify("p_3.Visible = '0 ~t If( score < " + String(g_obj.ScoreYellow) + ", If (Access > 1, 1,0),0)'")
dw_Insp.Modify("rating.color = '0 ~t If( Left(Rating,1) <= ~"" + g_obj.InspGreen + "~", 32768, If(Left(Rating,1) <=~"" + g_obj.InspYellow + "~", 49344, 192))'")

// Calc date 18 months past and retrieve vessels
ldt_SIRE18m = f_AddMonths(DateTime(Today()), -18)
dw_vsl.Retrieve(g_obj.Access, ldt_SIRE18m)

// Get inspection model shortnames and populate DDLB
Datastore lds_IM
Integer li_Rows, li_Loop
lds_IM = Create Datastore
lds_IM.DataObject = "d_sq_tb_imshort"
lds_IM.SetTransObject(SQLCA)
li_Rows = lds_IM.Retrieve()
Commit;
ddlb_IM.AddItem("< All >")
For li_Loop = 1 to li_Rows
	ddlb_IM.AddItem(lds_IM.GetItemString(li_Loop, "shortname"))
Next
ddlb_IM.SelectItem(1)
Destroy lds_IM

This.Post wf_FilterInspections()

dw_vsl.setfilter("")
dw_vsl.filter()

end event

event resize;Integer li_x

If Not (SizeType = 0 Or SizeType = 2) then Return 0

If newheight < 1000 then newheight = 1000

// Group boxes
gb_Vsl.Width = newwidth - gb_Vsl.x * 2
gb_Insp.Width = gb_Vsl.Width

// Datawindow, filter and & splitter bar
dw_vsl.width = newwidth - dw_vsl.x * 2
dw_insp.Width = dw_vsl.Width
uo_Filter.Resize(dw_vsl.Width, 0)  // Height parameter 0 is not used
st_Resize.Width = This.WorkspaceWidth( )
//li_x = dw_vsl.x + dw_vsl.width - st_Count.Width
//if li_x < 1500 then li_x = 1500
//st_Count.x = li_x

// 18m Checkbox, IM DDLB
li_x = dw_vsl.x + dw_vsl.width - ddlb_IM.Width - cbx_18.Width
If li_x < st_insp.x + st_insp.width then li_x = st_insp.x + st_insp.width
cbx_18.x = li_x
ddlb_IM.x = li_x + cbx_18.width

// Inspection Groupbox
li_x = newheight - gb_Insp.y - gb_Insp.x
if li_x < 400 then li_x = 400
gb_Insp.Height = li_x
dw_insp.Height = gb_Insp.Height - gb_Insp.x * 7 - cb_New.Height

// Buttons
cb_New.y = dw_insp.y + dw_insp.height
cb_Edit.y = cb_New.y
cb_Del.y = cb_New.y
cb_Rep.y = cb_New.y
cb_Reply.y = cb_New.y
cb_Hist.y = cb_New.y
cb_Key.y = cb_New.y
cb_Exp.y = cb_New.y

li_x = dw_insp.width + dw_insp.x - cb_Del.width
If li_x < cb_Key.x + cb_Key.Width then li_x = cb_Key.x + cb_Key.Width
cb_Del.x = li_x
end event

type st_tip from statictext within w_insp
boolean visible = false
integer x = 1170
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

type ddlb_im from dropdownlistbox within w_insp
integer x = 2981
integer y = 960
integer width = 293
integer height = 784
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
wf_FilterInspections( )
end event

type uo_filter from vo_vslfilter within w_insp
integer x = 55
integer y = 96
integer width = 3913
integer height = 80
integer taborder = 90
end type

on uo_filter.destroy
call vo_vslfilter::destroy
end on

event filterchange;call super::filterchange;
If dw_vsl.Rowcount() = 0 then 
	dw_insp.Retrieve(-100, g_obj.deptid, 0)
	cb_new.Enabled = False
Else
	If g_obj.Access > 1 then cb_new.Enabled = True
	dw_vsl.event rowfocuschanged(1)
End If

st_Count.Text = "( " + String(dw_vsl.RowCount()) + " vessel"
If dw_vsl.RowCount() = 1 then st_Count.Text += " )" else st_Count.Text += "s )"
end event

event filtercollapse;call super::filtercollapse;
Parent.SetRedraw(False)
dw_vsl.y = uo_Filter.Height + uo_Filter.Y + 16
dw_vsl.Height = gb_vsl.Height - uo_Filter.Height - 124
Parent.SetRedraw(True)
end event

event filterexpand;call super::filterexpand;
Parent.SetRedraw(False)
dw_vsl.y = uo_Filter.Height + uo_Filter.Y + 16
dw_vsl.Height = gb_vsl.Height - uo_Filter.Height - 124
Parent.SetRedraw(True)
end event

type st_insp from statictext within w_insp
integer x = 384
integer y = 968
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "( 000 Inspections )"
boolean focusrectangle = false
end type

type st_count from statictext within w_insp
integer x = 366
integer y = 20
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "( 000 Vessels )"
boolean focusrectangle = false
end type

type cb_exp from commandbutton within w_insp
integer x = 2231
integer y = 1664
integer width = 530
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Export Inspection"
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
g_Obj.ObjString = Trim(dw_Vsl.GetItemString(dw_Vsl.GetRow(), "Vessel_Email"), True)
If IsNull(g_Obj.ObjString) then g_Obj.ObjString = ""

// If Vetting dept RW/SU and Email valid then enable sending to vessel direct
If (g_Obj.DeptID = 1) and (g_Obj.Access > 1) and (g_Obj.ObjString>"") then g_Obj.Level = 1 else g_Obj.Level = 0

// Open the Export window
Open(w_Export)

// If export is successful, reset comments
If g_Obj.InspID > 0 then wf_RefreshRow( )
end event

type cbx_18 from checkbox within w_insp
integer x = 2487
integer y = 960
integer width = 485
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "18m Only    Type:"
boolean checked = true
end type

event clicked;
wf_FilterInspections()
end event

type cb_key from commandbutton within w_insp
integer x = 3291
integer y = 1664
integer width = 238
integer height = 80
integer taborder = 110
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


// Following code is for adding Ghost Items to any inspection that doesn't have.
// To be used in Development Enviroment by a Developer Only. NOT to be released to Production!

//g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")
//
//Select Count(*) into :li_Nulls from VETT_ITEM Where (INSP_ID = :g_Obj.InspID) and (ANS is Null);
//
//Commit;
//
//If li_Nulls = 0 then     
//	If MessageBox("Nulls", "No Ghost Items found. Add ?" , Question!, YesNo!) = 2 then Return
//	SetNull(li_Nulls)
//	Insert Into VETT_ITEM (INSP_ID, ANS, DEF, REPORT, RISK, CLOSED) Values (:g_obj.Inspid, :li_Nulls, :li_Nulls, :li_Nulls, :li_Nulls, :li_Nulls);
//	If SQLCA.SQLCode <> 0 then
//		Messagebox("DB Error", "Could not insert ghost item for inspection.~n~n" + sqlca.Sqlerrtext, Exclamation!)
//		Rollback;
//	Else
//		Commit;
//		Messagebox("Done", "Ghost item added.")		
//	End If	
//Else
//	Messagebox("Nulls", "Ghosts Found: " + String(li_Nulls) )
//End If

end event

type cb_hist from commandbutton within w_insp
integer x = 1701
integer y = 1664
integer width = 530
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Show History"
end type

event clicked;
SetPointer(HourGlass!)

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_hist, w_Main, 0, Original!)
end event

type cb_reply from commandbutton within w_insp
integer x = 1170
integer y = 1664
integer width = 530
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Inspection Reply"
end type

event clicked;
If g_Obj.DeptID > 1 then // If not Vetting dept, check if inspection is not reviewed
	If dw_insp.GetItemNumber(dw_insp.GetRow(), "Completed") = 0 then Messagebox("Inspection Under Review", "The selected inspection is currently under review. Please note that the operator's comments provided may not be complete.")
End If

SetPointer(HourGlass!)

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_inspreply"

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve( g_obj.InspID)    // Retrieve Master

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

w_preview.wf_ShowReport()

end event

type cb_rep from commandbutton within w_insp
integer x = 640
integer y = 1664
integer width = 530
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Inspection Report"
end type

event clicked;Boolean lb_Photos = True

SetPointer(HourGlass!)

If g_Obj.DeptID > 1 then // If not Vetting dept, check if inspection is reviewed
	If dw_insp.GetItemNumber(dw_insp.GetRow(), "Completed") = 0 then
		Messagebox("Inspection Under Review", "The selected inspection is currently under review. The inspection report can only be opened after the inspection has been reviewed.", Information!)
		Return
	End If
End If

g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_insprep"
	
If Left(dw_insp.GetItemString(dw_insp.GetRow(), "mname"), 4) = "MIRE" then 
	If MessageBox("Report Type", "You have selected a MIRE Inspection.~n~nWould you like to open the MIRE report format instead of the standard VIMS Inspection Report?", Question!, YesNo!) = 1 then 
		w_preview.dw_rep.dataobject = "d_rep_insprep_mire"
		If MessageBox("Complete Report", "Do you want to exclude the complete list of questions from the report?", Question!, YesNo!) = 1 then	
			w_preview.dw_rep.Modify("destroy dw_detail")
			w_preview.dw_rep.Modify("destroy t_detail")
		End If
		If MessageBox("Photographs", "Do you want to include photographs in the report?", Question!, YesNo!) = 2 Then
			w_preview.dw_rep.Modify("destroy dw_photos")
			lb_Photos = False
		End If
	End If
End If

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve(g_obj.InspID)    // Retrieve Master

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

If lb_Photos = True Then  // If photos are to be included
	nvo_Img lnImg
	DatawindowChild ldwc_Photos
	lnImg = Create nvo_Img
	
	If w_Preview.dw_Rep.GetChild("dw_photos", ldwc_Photos) = 1 Then	lnImg.CreatePhotoReport(g_obj.InspID, ldwc_Photos)
	
	Destroy lnImg
		
End If

w_preview.wf_ShowReport()

end event

type cb_del from commandbutton within w_insp
integer x = 3145
integer y = 1664
integer width = 293
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;Integer li_sqlcode
String ls_UserLock

SetPointer(HourGlass!)

// Get ID and vessel name
g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")
g_obj.ObjString = dw_vsl.GetItemString( dw_vsl.GetRow(), "Name")

// Get Lock status for inspection
Select USER_LOCK into :ls_UserLock from VETT_INSP Where INSP_ID = :g_obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_UserLock) then
		MessageBox("Inspection Locked", "The selected inspection is being edited by the user " + ls_UserLock + ". Please try again later.")
		Return
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
	Return
End If


If MessageBox("Confirm Delete", "Are you sure you want to delete this inspection?",Question!, YesNo!)=2 then Return

If MessageBox("Re-Confirm Delete", "All observations, data, history and attachments related to this inspection will be deleted. This deletion cannot be un-done.~n~nARE YOU ABSOLUTELY SURE YOU WANT TO DO THIS?",Question!, YesNo!)=2 then Return


// Delete all attachments
Delete from VETT_ATT where INSP_ID = :g_obj.Inspid;
li_sqlcode = sqlca.sqlcode

// Delete all comment history
If li_sqlcode >= 0 then
	Delete from VETT_ITEMHIST where ITEM_ID in (Select ITEM_ID from VETT_ITEM Where INSP_ID = :g_obj.Inspid);
	li_sqlcode = sqlca.sqlcode
End If

// Delete all items
If li_sqlcode >= 0 then
	Delete from VETT_ITEM where INSP_ID = :g_obj.Inspid;
	li_sqlcode = sqlca.sqlcode
End If

// Delete all inspection history
If li_sqlcode >= 0 then
	Delete from VETT_INSPHIST where INSP_ID = :g_obj.Inspid;
	li_sqlcode = SQLCA.Sqlcode
End If	

// Delete all summaries
If li_sqlcode >= 0 then
	Delete from VETT_INSPSM where INSP_ID = :g_obj.Inspid;
	li_sqlcode = SQLCA.Sqlcode
End If

// Delete all matrix officers
If li_sqlcode >= 0 then
	Delete from VETT_MATRIX where INSP_ID = :g_obj.Inspid;
	li_sqlcode = SQLCA.Sqlcode
End If

// Delete all references from Sys Messages
If li_sqlcode >= 0 then
	Delete from VETT_SYSMSG where INSP_ID = :g_obj.Inspid;
	li_sqlcode = SQLCA.Sqlcode
End If

// Delete Inspection
If li_sqlcode >= 0 then
	Delete from VETT_INSP where INSP_ID = :g_obj.Inspid;
	li_sqlcode = SQLCA.sqlcode
End If

If li_sqlcode = 0 then
	Commit;
	MessageBox("Deleted", "The inspection was successfully deleted.")
	dw_insp.DeleteRow( dw_insp.GetRow())
	If dw_insp.Rowcount( ) = 0 then
		cb_Edit.Enabled = False
		cb_Del.Enabled = False
		cb_hist.Enabled = False
		cb_rep.Enabled = False
		cb_reply.Enabled = False
	End If
	wf_RefreshVsl( )
Else
	MessageBox("DB Error", "The inspection could not be deleted.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Rollback;
End If

end event

type cb_edit from commandbutton within w_insp
integer x = 347
integer y = 1664
integer width = 293
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

// Get ID and vessel name
g_obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")
g_obj.ObjString = dw_vsl.GetItemString( dw_vsl.GetRow(), "Name")

// Get Lock status for inspection
Select USER_LOCK into :ls_UserLock from VETT_INSP Where INSP_ID = :g_obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_UserLock) then  // If inspection is locked
		If g_Obj.Deptid = 1 then MessageBox("Inspection Locked", "The selected inspection is being edited by the user " + ls_UserLock + " and is locked.~n~nNo changes can be made to the inspection.")
		g_Obj.Level = 0
	Else   // If inspection is not locked, lock inspection if user is Vetting
		If g_Obj.DeptID = 1 then 
			Update VETT_INSP Set USER_LOCK = :g_Obj.UserID Where INSP_ID = :g_obj.Inspid;  
			If SQLCA.SQLCode <> 0 then
				MessageBox("DB Error", "Unable to lock inspection for editing. Inspection will be opened in Read-Only mode.", Exclamation!)
				Rollback;
				g_Obj.Level = 0
			Else
				Commit;
				g_Obj.Level = 1				
			End If
		End If
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status. Cannot open inspection.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
	Return
End If

Open(w_inspdetail)

SetPointer(HourGlass!)
wf_RefreshRow( )
wf_RefreshVsl( )

end event

type cb_new from commandbutton within w_insp
integer x = 55
integer y = 1664
integer width = 293
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "New"
end type

event clicked;Integer li_Row, li_Ext = 0

If g_obj.deptid > 1 then
	MessageBox("Access Denied", "Only users from the Vetting Dept can create new inspections.")
	Return
End If

SetPointer (HourGlass!)

li_Row = dw_Vsl.GetRow()

g_obj.Vesselimo = dw_vsl.GetItemNumber(li_Row, "IMO")
g_obj.Country = dw_vsl.GetItemNumber(li_Row, "Country_ID")
g_obj.ObjString = dw_vsl.GetItemString(li_Row, "Name")
g_obj.Sql = dw_vsl.GetItemString(li_Row, "Resp")

open(w_newinsp)

If g_obj.Vesselimo > 0 then 
	If Pos(dw_Vsl.GetItemString(dw_Vsl.GetRow(), "vType"), "T/C") > 0 then li_Ext = 1
	li_Row = dw_insp.Retrieve(g_obj.VesselIMO, li_Ext, g_Obj.DeptID)
	wf_RefreshVsl( )
	li_Row = dw_insp.Find("Insp_ID = " + String(g_Obj.Inspid), li_Row, 1)
	If li_Row > 0 then
		dw_insp.SetRow(li_Row)	
		dw_insp.ScrollToRow(li_Row)
	End If
End If

Commit;
end event

type dw_vsl from datawindow within w_insp
integer x = 55
integer y = 192
integer width = 3547
integer height = 704
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_vslsummary"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;Integer li_Ext = 0   // If external vessel (T/C or 3P)

SetPointer(HourGlass!)

If Currentrow > 0 then 
	If Pos(This.GetItemString(Currentrow, "vType"), "T/C") > 0 or Pos(This.GetItemString(Currentrow, "vType"), "3P") > 0 then li_Ext = 1
	dw_insp.Retrieve(This.GetItemNumber(This.GetRow(), "IMO"), li_Ext, g_Obj.DeptID)
	commit;
End If

// PB Bug - Detail background colour does not refresh when using arrow keys to select rows
// Workaround: This must be done to force refresh of row colors when using arrow keys to navigate
This.SetRedraw(True)

// If external vessel, hide export button
If li_Ext = 0 then
	cb_Exp.Visible = True
	cb_Key.X = cb_Exp.X + cb_Exp.Width
Else
	cb_Exp.Visible = False
	cb_Key.X = cb_Exp.X	
End If

end event

event clicked;string ls_sort

If (dwo.type = "text") then
	If (String(dwo.tag)>"") then
		ls_sort = dwo.Tag
		this.setSort(ls_sort + ", #3 A")
		this.Sort()
		If right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		Else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		End if
		dwo.Tag = ls_sort
		This.event rowfocuschanged(This.GetRow())
	End If
End if

end event

type gb_vsl from groupbox within w_insp
integer x = 18
integer y = 16
integer width = 3785
integer height = 912
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel List   "
end type

type dw_insp from datawindow within w_insp
integer x = 55
integer y = 1056
integer width = 4114
integer height = 608
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_insp"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
wf_SetButtons()

// Don't use parameter 'rowcount' here. There is a bug in PB where rowcount may
// return 1 when there are no rows. Use function RowCount() instead.

If This.Rowcount() > 0 then
	This.SetRow(1)
	This.ScrollToRow(1)	
	st_Insp.Text = "( " + String(This.Rowcount()) + " inspection"
	If This.Rowcount() = 1 then st_Insp.Text += " )" else st_Insp.Text += "s )"	
Else
	st_Insp.Text = "( 0 inspections )"
End If


end event

event clicked;string ls_sort
Long ll_AttID

If (dwo.type = "text") and (dwo.name <> "t_ur") then
	If String(dwo.tag)>"" then
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

If dwo.name = "p_rep" then
	g_obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	If This.GetItemNumber(row, "pdf") > 1 then
		MessageBox("Report Ambiguity", "This inspection has more than 1 attachment with the name Report.pdf. Please open the inspection and check the attachments.", Exclamation!)
	Else

		Select Top 1 ATT_ID, FILENAME into :ll_AttID, :ls_Sort From VETT_ATT Where (INSP_ID = :g_obj.InspID) and (Upper(FILENAME)= 'REPORT.PDF') and (ITEM_ID is Null) and (SM_ID is Null);
		
		If SQLCA.SQLCode = 0 then
			Commit;
			Post wf_OpenAttachment(ll_AttID, ls_Sort)
		Else
			Messagebox("DB Error", "Attachment ID could not be retrieved.~n~nError: " + SQLCA.SqlErrtext, Exclamation!)
			Rollback;			
		End If
	End If
End If

If dwo.name = "p_5" then post Messagebox("Comments", "This inspection contains comments that have not been exported. Please export this inspection when possible.")

If dwo.name = "p_tech" then post Messagebox("Reviewed by Technical", "This inspection has been reviewed by the technical superintendent for the vessel.")
If dwo.name = "p_notified" then post Messagebox("Pending Review", "A notification has been sent to the technical superintendent for the review of this inspection.")
If dwo.name = "p_mgmt" then post Messagebox("Management Notification", "Management has been notified about this inspection.")
If dwo.name = "p_vbis" or dwo.name="p_vbis1k" then	post Messagebox("VBIS Prize", "This inspection qualified for the VBIS Payout of USD " + String(this.GetItemNumber(row,"VBIS") * 500) + ". An email was sent to the vessel.")
If dwo.name = "t_det" then post Messagebox("Vessel Detention", "The inspection resulted in the vessel being detained.")

If dwo.name = "t_new" then
	ll_AttID = This.GetItemNumber(row, "newcomments")
	If ll_AttID = 1 then
		ls_sort = "There is " + String(ll_AttID) + " new comment in this inspection."
	Else
		ls_sort = "There are " + String(ll_AttID) + " new comments in this inspection."
	End If
	Post Messagebox("New Comments", ls_Sort, Information!)
End If

If (dwo.name = "att") or (dwo.name = "p_att") then
	g_obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	Post wf_OpenAtt()
End If

If dwo.name = "p_red" then post Messagebox("Export Status", "The inspection has not been exported (or status is unknown).")
If dwo.name = "p_yellow" then post Messagebox("Export Status", "The inspection has been modified since the last export.")
If dwo.name = "p_blue" then post Messagebox("Export Status", "The inspection has been exported but not acknowledged by recipient.")
If dwo.name = "p_green" then post Messagebox("Export Status", "The inspection is synchronized with the vessel.")
end event

event doubleclicked;
If (row > 0) and cb_Edit.Enabled then cb_Edit.event clicked( )
end event

event rowfocuschanged;
// PB Bug - Detail background colour does not refresh when using arrow keys to select rows
// Workaround: This must be done to refresh the row colors when using arrow keys to navigate
This.SetRedraw(False)
This.SetRedraw(True)
end event

type gb_insp from groupbox within w_insp
integer x = 18
integer y = 960
integer width = 4352
integer height = 832
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspections   "
end type

type st_resize from statictext within w_insp
event ue_mousemove pbm_mousemove
event ue_mouseup pbm_mbuttonup
event ue_buttonup pbm_lbuttonup
integer y = 928
integer width = 3438
integer height = 36
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "SizeNS!"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

event ue_mousemove;
// If left mouse button pressed and not resizing then start resize
If flags = 1 and Not ibool_SplitMove then
	ibool_SplitMove = True
	ii_YPos = This.Y
	Return
End If

// If resizing
If flags = 1 and ibool_SplitMove then
	ii_WinHeight = Parent.WorkSpaceHeight( )
	//If ii_WinHeight < 1000 then ii_WinHeight = 1000
	Integer li_NewYPos
	li_NewYPos =  ii_YPos + ypos
	If li_NewYPos < 600 then li_NewYPos = 600  // Min size for top group box
	
	If li_NewYPos >= ii_WinHeight - 292 then li_NewYPos = ii_WinHeight - 292
	
	gb_vsl.Height = li_NewYPos - gb_vsl.Y
	gb_insp.Y = li_NewYPos + 32
	gb_insp.Height = Parent.Workspaceheight( ) - gb_Insp.Y - gb_Insp.X
	cbx_18.Y = gb_insp.Y
	ddlb_IM.Y = gb_insp.Y
	st_insp.Y = gb_insp.Y + 8	
	dw_vsl.Height = gb_vsl.Height - uo_Filter.Height - 124
	dw_insp.Y = gb_insp.Y + 96
	dw_insp.Height = gb_insp.Height - 224
End If
end event

event ue_buttonup;
// Release mouse button

// If mouse button up while resizing then stop resize
If ibool_SplitMove then 
	ibool_SplitMove = False
	This.Y = gb_vsl.Y + gb_vsl.Height
	Return
End If
end event

type sle_search from singlelineedit within w_insp
event ue_keyup pbm_keyup
integer x = 750
integer y = 12
integer width = 402
integer height = 72
integer taborder = 100
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

event modified;
This.backcolor = 16777215   // White
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

