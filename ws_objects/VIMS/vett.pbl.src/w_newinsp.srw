$PBExportHeader$w_newinsp.srw
forward
global type w_newinsp from window
end type
type cbx_det from checkbox within w_newinsp
end type
type sle_ocimf from singlelineedit within w_newinsp
end type
type cbx_tech from checkbox within w_newinsp
end type
type cb_setdate from commandbutton within w_newinsp
end type
type cbx_active from checkbox within w_newinsp
end type
type ddlb_pur from dropdownlistbox within w_newinsp
end type
type ddlb_status from dropdownlistbox within w_newinsp
end type
type st_20 from statictext within w_newinsp
end type
type st_19 from statictext within w_newinsp
end type
type st_18 from statictext within w_newinsp
end type
type sle_ce from singlelineedit within w_newinsp
end type
type sle_capt from singlelineedit within w_newinsp
end type
type st_17 from statictext within w_newinsp
end type
type st_16 from statictext within w_newinsp
end type
type sle_cost from singlelineedit within w_newinsp
end type
type st_15 from statictext within w_newinsp
end type
type dp_exp from datepicker within w_newinsp
end type
type st_14 from statictext within w_newinsp
end type
type mle_remarks from multilineedit within w_newinsp
end type
type st_13 from statictext within w_newinsp
end type
type st_12 from statictext within w_newinsp
end type
type sle_user from singlelineedit within w_newinsp
end type
type st_11 from statictext within w_newinsp
end type
type st_label from statictext within w_newinsp
end type
type cb_save from commandbutton within w_newinsp
end type
type sle_last from singlelineedit within w_newinsp
end type
type sle_first from singlelineedit within w_newinsp
end type
type st_8 from statictext within w_newinsp
end type
type st_7 from statictext within w_newinsp
end type
type st_6 from statictext within w_newinsp
end type
type dw_comp from datawindow within w_newinsp
end type
type st_5 from statictext within w_newinsp
end type
type cb_cancel from commandbutton within w_newinsp
end type
type cb_find from commandbutton within w_newinsp
end type
type sle_port from singlelineedit within w_newinsp
end type
type dw_port from datawindow within w_newinsp
end type
type st_4 from statictext within w_newinsp
end type
type dw_model from datawindow within w_newinsp
end type
type st_3 from statictext within w_newinsp
end type
type sle_tag from singlelineedit within w_newinsp
end type
type st_2 from statictext within w_newinsp
end type
type dp_insp from datepicker within w_newinsp
end type
type st_1 from statictext within w_newinsp
end type
type rr_1 from roundrectangle within w_newinsp
end type
type ln_1 from line within w_newinsp
end type
end forward

global type w_newinsp from window
integer width = 2327
integer height = 2220
boolean titlebar = true
string title = "New Inspection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_setexpirydate ( integer ai_months )
cbx_det cbx_det
sle_ocimf sle_ocimf
cbx_tech cbx_tech
cb_setdate cb_setdate
cbx_active cbx_active
ddlb_pur ddlb_pur
ddlb_status ddlb_status
st_20 st_20
st_19 st_19
st_18 st_18
sle_ce sle_ce
sle_capt sle_capt
st_17 st_17
st_16 st_16
sle_cost sle_cost
st_15 st_15
dp_exp dp_exp
st_14 st_14
mle_remarks mle_remarks
st_13 st_13
st_12 st_12
sle_user sle_user
st_11 st_11
st_label st_label
cb_save cb_save
sle_last sle_last
sle_first sle_first
st_8 st_8
st_7 st_7
st_6 st_6
dw_comp dw_comp
st_5 st_5
cb_cancel cb_cancel
cb_find cb_find
sle_port sle_port
dw_port dw_port
st_4 st_4
dw_model dw_model
st_3 st_3
sle_tag sle_tag
st_2 st_2
dp_insp dp_insp
st_1 st_1
rr_1 rr_1
ln_1 ln_1
end type
global w_newinsp w_newinsp

type variables

Integer ii_ModelID, ii_Status, ii_StatusOriginal, ii_TechReview, ii_VBIS
Long il_OriginalCost
String is_Port, is_Purpose, is_Group, is_Grade, is_Resp
DataStore ids_Inspectors, ids_purpose
m_setexpiry im_Date
Boolean ib_NoReview = False
end variables

forward prototypes
public function string wf_gettotalopenobs (long al_inspid, ref integer ai_openobs)
public subroutine wf_checkvbis ()
public function string wf_getallblankrespcause (long al_inspid)
end prototypes

event ue_setexpirydate(integer ai_months);dp_exp.Value = DateTime(f_AddMonths(dp_insp.Value, ai_months))
end event

public function string wf_gettotalopenobs (long al_inspid, ref integer ai_openobs);String ls_Temp
Integer li_Count


Select Count(*) Into :li_Count From VETT_ITEM
Where INSP_ID = :al_InspID And DEF=1 And ANS=1;

If SQLCA.SQLCode <> 0 then 
	Rollback;
	Return "?/?"
End If

ls_Temp = "Valid Obs: " + String(li_Count) + "   "

Select Count(*) Into :li_Count From VETT_ITEM
Where INSP_ID = :al_InspID And CLOSED=0 And DEF=1 And ANS=1;

If SQLCA.SQLCode <> 0 then 
	Rollback;
	Return "?/?"
End If

ls_Temp += "Open Obs: " + String(li_Count)
ai_OpenObs = li_Count

Commit;

Return ls_Temp
end function

public subroutine wf_checkvbis ();// This function checks if a SIRE inspection is applicable for 
// the Vetting Bonus Incentive Scheme Prize (VBIS)

// Change log
// 25 Mar 2014: CR 3578. Changed exclusion questions to 9.23 only


// If SIRE and Review completed, then check for VBIS Bonus
If ii_Status = 2 and ii_StatusOriginal < 2 and dw_Model.GetItemString(dw_Model.GetRow(), "ShortName") = "SIRE" And ii_VBIS=0 Then
	
	// Get Items
	DataStore lds_Items 
	Integer li_Obs
	Integer li_Amount=500
	lds_Items = Create DataStore
	lds_Items.DataObject = "d_sq_tb_items"
	lds_Items.SetTransObject( SQLCA )
	li_Obs = lds_Items.Retrieve(g_Obj.InspID)
	If li_Obs<0 then Return  // Exit if error
	
	// Filter to 'No' answers
	lds_Items.SetFilter("Ans=1")
	lds_Items.Filter()
	li_Obs = lds_Items.RowCount()

	// Exit if any high-risk item (No VBIS for high risk)
	If lds_Items.Find("risk=2 and Lower(resptext)='vessel'", 1, lds_Items.RowCount())>0 then Return

	// Remove non-scoring items (9.26, 13.13 & 13.14). CR 3578: Change to 9.23 only
	If lds_Items.Find("fullnum='9.23'", 1, lds_Items.RowCount())>0 then li_Obs -= 1
	//If lds_Items.Find("fullnum='13.13'", 1, lds_Items.RowCount())>0 then li_Obs -= 1
 	//If lds_Items.Find("fullnum='13.14'", 1, lds_Items.RowCount())>0 then li_Obs -= 1
	
	If li_Obs<4 Then  // Hooray !!
		String ls_Err
		If li_Obs = 0 Then li_Amount = 1000
		ls_Err = guo_Global.of_SendVBISMail(g_Obj.InspID, li_Amount)
		If ls_Err > "" Then
			Messagebox("DB Error", "Unable to send VBIS Mail. " + ls_Err, Exclamation!)
		Else
			Messagebox("VBIS Prize", "This inspection qualifies for the VBIS prize. An automatic email notification has been sent from VIMS to vessel and IOMFIN. IOMFIN will authorise Master to draw USD " + String(li_Amount) + " for the vessel welfare fund.")
		End If
	End If	
End If

end subroutine

public function string wf_getallblankrespcause (long al_inspid);// Returns all valid 'No' observations that have any empty Responsible or Cause field.

Datastore lds_Items
String ls_Obs = ""
Integer li_Obs

lds_Items = Create DataStore
lds_Items.DataObject = "d_sq_tb_items"
lds_Items.SetTransObject(SQLCA)

If lds_Items.Retrieve( g_Obj.InspID)>=0 Then
	lds_Items.SetFilter("ans=1 and def=1 and (isnull(resptext) or isnull(causetext))")
	lds_Items.Filter()

	For li_Obs = 1 to lds_Items.RowCount()
		If li_Obs > 1 Then ls_Obs += ", "
		ls_Obs += lds_Items.GetItemString(li_Obs, "fullnum")
	Next
Else
	ls_Obs = "[Error Occurred]"
End If

Commit;
	
Return ls_Obs
end function

on w_newinsp.create
this.cbx_det=create cbx_det
this.sle_ocimf=create sle_ocimf
this.cbx_tech=create cbx_tech
this.cb_setdate=create cb_setdate
this.cbx_active=create cbx_active
this.ddlb_pur=create ddlb_pur
this.ddlb_status=create ddlb_status
this.st_20=create st_20
this.st_19=create st_19
this.st_18=create st_18
this.sle_ce=create sle_ce
this.sle_capt=create sle_capt
this.st_17=create st_17
this.st_16=create st_16
this.sle_cost=create sle_cost
this.st_15=create st_15
this.dp_exp=create dp_exp
this.st_14=create st_14
this.mle_remarks=create mle_remarks
this.st_13=create st_13
this.st_12=create st_12
this.sle_user=create sle_user
this.st_11=create st_11
this.st_label=create st_label
this.cb_save=create cb_save
this.sle_last=create sle_last
this.sle_first=create sle_first
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.dw_comp=create dw_comp
this.st_5=create st_5
this.cb_cancel=create cb_cancel
this.cb_find=create cb_find
this.sle_port=create sle_port
this.dw_port=create dw_port
this.st_4=create st_4
this.dw_model=create dw_model
this.st_3=create st_3
this.sle_tag=create sle_tag
this.st_2=create st_2
this.dp_insp=create dp_insp
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.Control[]={this.cbx_det,&
this.sle_ocimf,&
this.cbx_tech,&
this.cb_setdate,&
this.cbx_active,&
this.ddlb_pur,&
this.ddlb_status,&
this.st_20,&
this.st_19,&
this.st_18,&
this.sle_ce,&
this.sle_capt,&
this.st_17,&
this.st_16,&
this.sle_cost,&
this.st_15,&
this.dp_exp,&
this.st_14,&
this.mle_remarks,&
this.st_13,&
this.st_12,&
this.sle_user,&
this.st_11,&
this.st_label,&
this.cb_save,&
this.sle_last,&
this.sle_first,&
this.st_8,&
this.st_7,&
this.st_6,&
this.dw_comp,&
this.st_5,&
this.cb_cancel,&
this.cb_find,&
this.sle_port,&
this.dw_port,&
this.st_4,&
this.dw_model,&
this.st_3,&
this.sle_tag,&
this.st_2,&
this.dp_insp,&
this.st_1,&
this.rr_1,&
this.ln_1}
end on

on w_newinsp.destroy
destroy(this.cbx_det)
destroy(this.sle_ocimf)
destroy(this.cbx_tech)
destroy(this.cb_setdate)
destroy(this.cbx_active)
destroy(this.ddlb_pur)
destroy(this.ddlb_status)
destroy(this.st_20)
destroy(this.st_19)
destroy(this.st_18)
destroy(this.sle_ce)
destroy(this.sle_capt)
destroy(this.st_17)
destroy(this.st_16)
destroy(this.sle_cost)
destroy(this.st_15)
destroy(this.dp_exp)
destroy(this.st_14)
destroy(this.mle_remarks)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.sle_user)
destroy(this.st_11)
destroy(this.st_label)
destroy(this.cb_save)
destroy(this.sle_last)
destroy(this.sle_first)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.dw_comp)
destroy(this.st_5)
destroy(this.cb_cancel)
destroy(this.cb_find)
destroy(this.sle_port)
destroy(this.dw_port)
destroy(this.st_4)
destroy(this.dw_model)
destroy(this.st_3)
destroy(this.sle_tag)
destroy(this.st_2)
destroy(this.dp_insp)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_1)
end on

event open;datastore lds_insp
Integer li_Row, li_Loop
Long ll_IMO

SetPointer(HourGlass!)

// Init DWs and retrieve
dw_model.SetTransObject(SQLCA)
dw_port.SetTransObject(SQLCA)
dw_comp.SetTransObject(SQLCA)
dw_model.Retrieve()
dw_port.Retrieve()
dw_comp.Retrieve()

// Set dates to today
dp_insp.Value = DateTime(Today())
dp_exp.Value = DateTime(Today())

// Init DS for inspector's names
ids_Inspectors = Create DataStore
ids_Inspectors.DataObject = "d_sq_tb_rep_inspname"
ids_Inspectors.SetTransObject(SQLCA)
ids_Inspectors.Retrieve( )

// Init DS for Purpose codes
ids_Purpose = Create DataStore
ids_Purpose.DataObject = "d_sq_tb_purpose"
ids_Purpose.SetTransObject(SQLCA)
li_Row = ids_Purpose.Retrieve( )

Commit; 

// Fill up Purpose DDLB
For li_Loop = 1 to li_Row
	ddlb_Pur.Additem(ids_Purpose.GetItemString(li_Loop, "desc"))
Next

If g_obj.ObjString = "EditInsp" then  // If user is editing header
	// Get header info
	lds_insp = create datastore
	lds_insp.Dataobject = "d_sq_ff_inspheader"
	lds_insp.SetTransobject(SQLCA)
	li_row = lds_insp.Retrieve(g_obj.InspID)
	Commit;
	If lds_insp.RowCount( ) = 0 then
		Destroy lds_insp
		MessageBox("DW Error", "Could not retrieve inspection header.", Exclamation!)
		cb_Save.Enabled = False
		Return
	End If
	This.Title = "Edit Inspection Header"
	
	// Set controls
	dp_insp.Value = lds_insp.GetItemDateTime(1, "InspDate")
	dp_exp.Value = lds_insp.GetItemDateTime(1, "Expires")
	sle_tag.Text = lds_insp.GetItemString(1, "Tag")
  If lds_insp.GetItemNumber(1, "VslDet") = 1 Then	cbx_Det.Checked = true Else cbx_Det.Checked = false
	ii_TechReview = lds_insp.GetItemNumber(1, "Tech_Review")
	ii_VBIS = lds_insp.GetItemNumber(1,"VBIS")

	If lds_insp.GetItemNumber(1,"NoTechReview")=1 then ib_NoReview = True
	If IsNull(ii_TechReview) then ii_TechReview = 0
	cbx_Tech.Checked = (ii_TechReview = 1)
	li_Row = dw_model.Find("IM_ID = " + String(lds_insp.GetItemNumber(1, "ImID")), 1, dw_model.RowCount() )
	if li_Row > 0 then
		dw_Model.SetRow(li_Row)
		dw_Model.ScrollToRow(li_Row)
	Else
		MessageBox("DW Error", "Unable to set Inspection Model Type.",Exclamation!)
		cb_Save.Enabled = False
	End If
	dw_model.Enabled = False
	cbx_Active.Visible = False
	dw_model.Modify("DataWindow.Color='12632256'")
	li_Row = dw_comp.Find("Comp_ID = " + String(lds_insp.GetItemNumber(1, "CompID")), 1, dw_comp.RowCount() )
	if li_Row > 0 then
		dw_Comp.SetRow(li_Row)
		dw_Comp.ScrollToRow(li_Row)
	Else	
		MessageBox("DW Error", "Unable to set Inspection Company.",Exclamation!)
	End If
	li_Row = dw_Port.Find("Port_Code = '" + lds_insp.GetItemString(1, "Port") + "'", 1, dw_Port.RowCount() )
	if li_Row > 0 then
		dw_Port.SetRow(li_Row)
		dw_Port.ScrollToRow(li_Row)
	Else	
		MessageBox("DW Error", "Unable to set Port of Inspection.",Exclamation!)
	End If
	
	// Set all textboxes
	sle_first.Text = lds_insp.GetItemString(1, "vett_insp_insp_fname")
	sle_last.Text = lds_insp.GetItemString(1, "vett_insp_insp_lname")
	sle_capt.Text = lds_insp.GetItemString(1, "master")
	sle_CE.Text = lds_insp.GetItemString(1, "cheng")
	sle_OCIMF.Text = lds_insp.GetItemString(1, "ocimf")
	sle_cost.Text = String(lds_insp.GetItemDecimal(1, "expense"),"0")
	If sle_cost.Text = "" then SetNull(il_OriginalCost) Else il_OriginalCost = Long(sle_Cost.Text)
	sle_user.Text = lds_insp.GetItemString(1, "Resp")
	is_Resp = sle_user.Text
	mle_remarks.Text = lds_insp.GetItemString(1, "Remarks")
	
	// Calc status and set
	If lds_insp.GetItemNumber(1, "Locked") = 1 then 
		ii_Status = 3
	Else
		If lds_insp.GetItemNumber(1, "Completed") = 1 then ii_Status = 2 Else ii_Status = 1
	End If
	ddlb_Status.SelectItem(ii_Status)
	ii_StatusOriginal = ii_Status  // Remember status
	
	// Get the purpose code and set
	li_Row = ddlb_Pur.Finditem(lds_Insp.GetItemString(1, "purpose_purpose_desc"), 0)
	If li_Row > 0 then 
		ddlb_Pur.SelectItem(li_Row)
		is_Purpose = ids_Purpose.GetItemString(li_Row, "code")
	End If

	// If not superuser or RW, restrict access to reviewed/closed-out
	If g_obj.Access < 2 then ddlb_Status.Enabled = False
	
	// If inspection is closed out or user is non-vetting, disable all controls except cbx_Tech
	If ii_Status = 3 or g_Obj.DeptID > 1 then  
		sle_first.Enabled = False
		sle_last.Enabled = False
		sle_capt.Enabled = False
		sle_CE.Enabled = False
		sle_OCIMF.Enabled = False
		sle_cost.Enabled = False
		sle_user.Enabled = False
		sle_port.Enabled = False
		mle_remarks.Enabled = False
		dw_Port.enabled = False
		ddlb_pur.Enabled = False
		ddlb_status.Enabled = False
		dw_comp.Enabled = False
		dw_Model.Enabled = False
		dp_exp.Enabled = False
		dp_insp.Enabled = False
		cb_setdate.Visible = False
		sle_tag.Enabled = false
		cb_find.enabled = false
		cbx_Det.enabled = false
		cbx_active.enabled = false
		cb_Save.Visible = False
		cb_Cancel.Text = "Close"
		cb_Cancel.X = (This.Workspacewidth( ) - cb_cancel.Width)/2
		dw_comp.Modify("DataWindow.Color='12632256'")
		dw_port.Modify("DataWindow.Color='12632256'")
		If ii_Status < 3 and g_Obj.Access > 1 and Not ib_NoReview then cbx_Tech.Enabled = True  // If non-vetting R/W user and insp unlocked
	Else
		// If Superuser and T.O. reviewed and review possible, grant access to 'Reviewed by Tech Super'
		If g_Obj.Access = 3 and ii_TechReview = 1 and Not ib_NoReview then cbx_Tech.Enabled = True		
	End If
	
	Destroy lds_insp
Else
	sle_user.Text = g_obj.Sql    // User resp for vessel
	ddlb_status.SelectItem(1)
	ii_Status = 1
	ddlb_status.Enabled = False
	cbx_Active.Event clicked( )
End If

im_Date = Create m_setexpiry
end event

event close;
Destroy ids_Inspectors
Destroy ids_Purpose
Destroy im_date
end event

type cbx_det from checkbox within w_newinsp
integer x = 1207
integer y = 1488
integer width = 87
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type sle_ocimf from singlelineedit within w_newinsp
integer x = 1207
integer y = 1488
integer width = 544
integer height = 80
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type cbx_tech from checkbox within w_newinsp
integer x = 1207
integer y = 256
integer width = 1010
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
string text = "Reviewed by Technical Superintendent:"
boolean lefttext = true
end type

type cb_setdate from commandbutton within w_newinsp
integer x = 1006
integer y = 208
integer width = 91
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
im_Date.popmenu(Parent.pointerx(), Parent.pointery())
end event

type cbx_active from checkbox within w_newinsp
integer x = 805
integer y = 752
integer width = 329
integer height = 64
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active Only"
boolean checked = true
end type

event clicked;
If This.Checked then dw_Model.SetFilter("Active=1") Else dw_Model.SetFilter("")

dw_Model.Filter()
end event

type ddlb_pur from dropdownlistbox within w_newinsp
integer x = 1371
integer y = 416
integer width = 841
integer height = 768
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
is_Purpose = ids_Purpose.GetItemString(Index, "Code")
end event

type ddlb_status from dropdownlistbox within w_newinsp
integer x = 1207
integer y = 128
integer width = 530
integer height = 320
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Un-Reviewed","Reviewed","Closed-Out"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Status = Index
end event

type st_20 from statictext within w_newinsp
integer x = 1207
integer y = 352
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Purpose:"
boolean focusrectangle = false
end type

type st_19 from statictext within w_newinsp
integer x = 1207
integer y = 64
integer width = 411
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Status:"
boolean focusrectangle = false
end type

type st_18 from statictext within w_newinsp
integer x = 1847
integer y = 992
integer width = 366
integer height = 64
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 8421504
long backcolor = 67108864
string text = "(without prefix)"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ce from singlelineedit within w_newinsp
integer x = 1371
integer y = 1104
integer width = 841
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event modified;
f_ValidateName(This.Text, 0)
end event

type sle_capt from singlelineedit within w_newinsp
integer x = 1371
integer y = 912
integer width = 841
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 0)
end event

type st_17 from statictext within w_newinsp
integer x = 1207
integer y = 1040
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Chief Engineer:"
boolean focusrectangle = false
end type

type st_16 from statictext within w_newinsp
integer x = 1207
integer y = 848
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Master:"
boolean focusrectangle = false
end type

type sle_cost from singlelineedit within w_newinsp
integer x = 1207
integer y = 1296
integer width = 549
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 5
borderstyle borderstyle = stylelowered!
end type

type st_15 from statictext within w_newinsp
integer x = 622
integer y = 64
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Expires:"
boolean focusrectangle = false
end type

type dp_exp from datepicker within w_newinsp
string tag = "2538454"
integer x = 622
integer y = 128
integer width = 475
integer height = 80
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2007-05-31"), Time("13:15:39.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendartextsize = -8
integer calendarfontweight = 400
fontcharset calendarfontcharset = ansi!
fontpitch calendarfontpitch = variable!
fontfamily calendarfontfamily = swiss!
string calendarfontname = "Arial"
weekday firstdayofweek = monday!
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

type st_14 from statictext within w_newinsp
integer x = 1829
integer y = 1376
integer width = 384
integer height = 64
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 8421504
long backcolor = 67108864
string text = "(User ID only)"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_remarks from multilineedit within w_newinsp
integer x = 91
integer y = 1680
integer width = 2121
integer height = 240
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 500
borderstyle borderstyle = stylelowered!
end type

type st_13 from statictext within w_newinsp
integer x = 91
integer y = 1616
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remarks:"
boolean focusrectangle = false
end type

type st_12 from statictext within w_newinsp
integer x = 1207
integer y = 1232
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
string text = "Total Expense:"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_newinsp
integer x = 1829
integer y = 1296
integer width = 384
integer height = 80
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within w_newinsp
integer x = 1829
integer y = 1232
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
string text = "Responsible:"
boolean focusrectangle = false
end type

type st_label from statictext within w_newinsp
integer x = 1207
integer y = 1424
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "OCIMF Report Number:"
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_newinsp
integer x = 530
integer y = 2000
integer width = 398
integer height = 108
integer taborder = 190
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;String ls_Port, ls_Resp, ls_Super, ls_Short
Long ll_CompID, ll_Model, ll_Cost
DateTime ldt_Insp, ldt_Exp, ldt_Now
Integer li_Lock, li_Comp, li_Tech, li_VBIS, li_Det
Boolean lbool_TC3P

// Check expires date
If dp_exp.Value<=dp_insp.Value then
	MessageBox("Input Error", "The 'Expires' date must be later than the date of inspection.",Exclamation!)
	Return
End If

SetPointer(HourGlass!)

// Try to find responsible userid and check his access level and dept
sle_user.Text = Trim(sle_User.Text)
Select USERID, VETT_ACCESS, VETT_DEPT into :ls_Resp, :li_Lock, :li_Comp from USERS where USERID = :sle_user.Text;

If SQLCA.SQLCode <> 0 then
	MessageBox("DB Error", "Could not find responsible user. Please check the user ID of the responsible user.~n~n" + sqlca.sqlerrtext,Exclamation!)
	Rollback;
	sle_user.Setfocus( )
	Return
End If

Commit;

// If user doesn't have required access
If (li_Lock < 2) then	
	Messagebox("User Access", "The responsible user specified does not have the required access level to VIMS.",Exclamation!)
	sle_user.Setfocus( )
	Return
End If

// If user is not vetting department
If (li_Comp > 1) then	
	Messagebox("User Access", "The responsible user specified must belong to the Vetting department.",Exclamation!)
	sle_user.Setfocus( )
	Return
End If

// Get selected PortCode, CompanyID and ModelID
ls_Port = dw_Port.GetItemString(dw_Port.GetRow(), "PORT_CODE")
ll_CompID = dw_Comp.GetItemNumber(dw_Comp.GetRow(), "COMP_ID")
ll_Model = dw_Model.GetItemNumber(dw_Model.GetRow(), "IM_ID")

// Trim all text fields
sle_first.Text = Trim(sle_first.Text, True)
sle_Last.Text = Trim(sle_last.Text, True)
sle_Capt.Text = Trim(sle_Capt.Text, True)
sle_CE.Text = Trim(sle_CE.Text, True)
sle_tag.Text = Trim(sle_Tag.Text, True)
sle_cost.Text = Trim(sle_Cost.Text, True)
sle_OCIMF.Text = Trim(sle_OCIMF.Text, True)

// Inspector's name is required for external models
If dw_Model.GetItemNumber(dw_Model.GetRow(), "Extmodel") = 0 then
	If (sle_first.Text = "") or (sle_last.Text = "") then 
		MessageBox("Inspector Name", "Inspector's first and last name must be specified!", Exclamation!)
		Return
	End If
End If

// Check cost if given
If Not IsNumber(sle_cost.Text) and (Len(sle_Cost.Text) > 0) then
	MessageBox("Inspection Cost", "The Inspection Cost specified is invalid!", Exclamation!)
	Return
End If

// Determine if vessel is Third-party or T/C and get VBIS status (only when editing insp) ( CR 1997 - 13May2010)
If g_obj.ObjString = "EditInsp" then
	String ls_Type
	Select TYPE_NAME,VETT_VSLTYPE.VBIS,VETT_RESP Into :ls_Type,:li_VBIS,:ls_Super from VETT_VSLTYPE 
	Inner Join VESSELS On VESSELS.VETT_TYPE = VETT_VSLTYPE.TYPE_ID
	Inner Join VETT_INSP On VETT_INSP.VESSELIMO = VESSELS.IMO_NUMBER and VESSEL_ACTIVE=1 
	and VESSELS.VSLFLAG is not Null And VETT_INVIMS=1
	Where INSP_ID = :g_Obj.InspID ;
	Commit;
	If IsNull(ls_Type) then
		Messagebox("Invalid Vessel Type", "Unable to determine vessel type!", Exclamation!)
		Return
	End If
	If Pos(ls_Type, "3P")>0 or Pos(ls_Type, "T/C")>0 then lbool_TC3P = True	Else lbool_TC3P = False
	If lbool_TC3P then li_VBIS=0  // Additional safety check
End If

// Check if un-reviewing inspection and user is not superuser
If ii_Status = 1 and ii_StatusOriginal = 2 and (g_obj.Access < 3 or g_Obj.DeptID>1) Then
	Messagebox("Cannot Un-Review", "Only the Vetting Super-user has permission to un-review an inspection.", Exclamation!)
	Return
End If

// Check if reviewing inspection
If ii_Status = 2 and ii_StatusOriginal = 1 Then
	String ls_Temp
	ls_Temp = wf_GetAllBlankRespCause(g_Obj.InspID)
	If ls_Temp > "" Then  // If Responsibility & Cause has not been set for all items
		Messagebox("Cannot Review", 'The inspection status cannot be set as "Reviewed" as the following valid observations are missing the Responsibility or Cause fields:~n~n'+ls_Temp, Exclamation!)
		Return
	End If
	If ls_Super = g_Obj.UserID Then
		Select SHORTNAME Into :ls_Short 
				From VETT_INSP Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
				Where INSP_ID = :g_Obj.InspID;
		Commit;
		If ls_Short="SIRE" or ls_Short="CDI" then
			Messagebox("Cannot Review", 'Superintendent incharge of the vessel is not allowed to change the inspection status to "Reviewed"', Exclamation!)
			Return
		End If
	End If
End If

// Check if closing inspection without reviewing
If ii_Status = 3 and ii_StatusOriginal = 1 then 
	Messagebox("Inspection Not Reviewed", "The Inspection cannot be closed directly without being reviewed first.", Exclamation!)
	Return
End If

// Check if closing inspection not reviewed by Tech Super (except for T/C or 3P vessels)
If ii_Status = 3 and Not cbx_Tech.Checked and Not lbool_TC3P and Not ib_NoReview then
	Messagebox("Inspection Not Reviewed", "The Inspection cannot be closed without being reviewed by the Technical Superindent.", Exclamation!)
	Return
End If

// Check if closing inspection that still has open obs
If ii_Status = 3 and ii_StatusOriginal < 3 Then
	Select Count(*) Into :li_Lock From VETT_ITEM Where INSP_ID = :g_Obj.InspID And CLOSED=0 And ANS=1 And DEF = 1;
	Commit;
	If li_Lock > 0 Then
		Messagebox("Open Observations", "The Inspection cannot be closed if there are one or more open and valid observations.", Exclamation!)
		Return
	End If
End If

// Check OCIMF number format
If Len(sle_Ocimf.Text)>0 then
	If Len(sle_Ocimf.Text)<19 then
		Messagebox("SIRE OCIMF Report", "The OCIMF Report number specified is invalid.~n~nThe number must be of the format XXXX-XXXX-XXXX-XXXX.", Exclamation!)
		Return
	End If
	If Mid(sle_Ocimf.Text,5,1)<>"-" Or Mid(sle_Ocimf.Text,10,1)<>"-" Or Mid(sle_Ocimf.Text,15,1)<>"-" Then
		Messagebox("SIRE OCIMF Report", "The OCIMF Report number specified is invalid.~n~nThe number must be of the format XXXX-XXXX-XXXX-XXXX.", Exclamation!)
		Return
	End If
End If

// Store values into local variables
ldt_Insp = dp_Insp.Value
ldt_Exp = dp_Exp.Value
ll_Cost = Long(sle_cost.Text)
If cbx_Det.Visible and cbx_Det.Checked Then li_Det = 1 Else li_Det = 0
If sle_cost.Text = "" then SetNull(ll_Cost)
li_Tech = ii_TechReview    // Possible values: 0 = Not reviewed, 1 = Reviewed, 10 = Not reviewed but notification sent
If cbx_Tech.Checked then
	li_Tech = 1
Else
	If ii_TechReview = 1 then li_Tech = 0  // Set to "not-reviewed" only if previously was reviewed
End If
ldt_Now = DateTime(Today(), Now())

// Set Completed/Locked flags
If ii_Status > 1 then li_Comp = 1 else li_Comp = 0
If ii_Status = 3 then li_Lock = 1 else li_Lock = 0

// If no selected purpose, use null
If is_Purpose = "" then SetNull(is_Purpose)

// If editing inspection, then Update else Insert
If g_obj.ObjString = "EditInsp" then
	Update VETT_INSP Set PORT = :ls_Port, COMP_ID = :ll_CompID, INSPDATE = :ldt_Insp, COMMENCED = :ldt_Insp, EXPENSE = :ll_Cost, EXPIRES = :ldt_Exp, INSP_FNAME = :sle_first.Text, INSP_LNAME = :sle_last.Text, MASTER = :sle_capt.Text, CHENG = :sle_CE.Text, MODIFIED = :g_Obj.UserID, TAG = :sle_tag.Text, REMARKS = :mle_remarks.Text, OCIMF = :sle_OCIMF.Text, PIN = Null, RESP = :ls_Resp, LOCKED = :li_Lock, COMPLETED = :li_Comp, LASTEDIT = :ldt_Now, OPTYPE = :is_Purpose, GRADE_GROUP = :is_group, GRADE_NAME = :is_grade, TECH_REVIEW = :li_Tech, VSLDET=:li_Det where INSP_ID = :g_obj.Inspid;
Else
	Insert into VETT_INSP (VESSELIMO, PORT, COMP_ID, INSPDATE, COMMENCED, EXPENSE, EXPIRES, INSP_FNAME, INSP_LNAME, MASTER, CHENG, IM_ID, CREATED, MODIFIED, TAG, REMARKS, VSLFLAG, OCIMF, PIN, RESP, LASTEDIT, CURDEPT, COMPLETED, RATING, VSLSCORE, OPTYPE, GRADE_GROUP, GRADE_NAME, LASTEXPORT, TECH_REVIEW, VSLDET) Values ( :g_obj.vesselimo, :ls_Port, :ll_CompID, :ldt_Insp, :ldt_Insp, :ll_Cost, :ldt_Exp, :sle_first.Text, :sle_last.Text, :sle_capt.Text, :sle_ce.Text, :ll_Model, :g_Obj.UserID, :g_Obj.UserID, :sle_tag.Text, :mle_remarks.Text, :g_obj.Country , :sle_OCIMF.Text, Null, :ls_Resp, :ldt_Now, :g_Obj.DeptID, 0, 'A+', 100, :is_Purpose, :is_group, :is_grade, 'O', 0, :li_Det);
End If

If SQLCA.SQlcode <> 0 then
	MessageBox ("DB Error", "Unable to add/edit new inspection.~n~n" + Sqlca.Sqlerrtext,Exclamation!)
	Rollback;	
	Return
End If

Commit;

If g_obj.ObjString = "EditInsp" then  // If insp was edited

	// Log any changes to the Expense
	If IsNull(il_OriginalCost) and Not IsNull(ll_Cost) then
		guo_Global.of_AddInspHist(g_Obj.InspID, 17, "Amount: $" + String(ll_Cost,"#,##0"))
	ElseIf Not IsNull(il_OriginalCost) and IsNull(ll_Cost) then
		guo_Global.of_AddInspHist(g_Obj.InspID, 18, "Original: $" + String(il_OriginalCost,"#,##0") + "   New: Empty")
	ElseIf Not IsNull(il_OriginalCost) then
		If il_OriginalCost <> ll_Cost then guo_Global.of_AddInspHist(g_Obj.InspID, 18, "Original: $" + String(il_OriginalCost,"#,##0") + "   New: $" + String(ll_Cost,"#,##0"))
	End If

	// If responsible user changed, then log it
	If ls_Resp <> is_Resp then guo_Global.of_AddInspHist(g_Obj.InspID, 8, 'Responsible: ' + ls_Resp)
	
	// If status changed, then log it
	If ii_Status <> ii_StatusOriginal then		
		Integer li_OpenObs
		If ii_StatusOriginal = 1 then  // If originally open			
			guo_Global.of_AddInspHist(g_Obj.InspID, 3, wf_GetTotalOpenObs(g_Obj.InspID, li_OpenObs))  // log reviewed
			Update VETT_INSP Set OPEN_AT_REVIEW = :li_OpenObs Where INSP_ID = :g_Obj.InspID;
			Commit;
		Else  // if originally reviewed
			If ii_Status = 1 then 
				guo_Global.of_AddInspHist(g_Obj.InspID, 4, '') // log unreviewed
			Else 
				guo_Global.of_AddInspHist(g_Obj.InspID, 9, '')  // log locking
				Select OPEN_AT_REVIEW, SHORTNAME Into :li_OpenObs, :ls_Short 
				From VETT_INSP Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
				Where INSP_ID = :g_Obj.InspID;
				Commit;
				If li_OpenObs > 0 and ls_Short="SIRE" Then // Provide warning if some obs were open at time of SIRE review
					Messagebox("SIRE Comments Upload", "Please remember to upload 'Further Operator Comments' on the OCIMF SIRE website as there were observations open (Total " + String(li_OpenObs) + ") at the time the inspection was reviewed.", Information!)
				End If
			End If
		End If
	End If
	
	// If TechReview completed or uncompleted, then log it
	If cbx_Tech.Checked and Mod(ii_TechReview,10) = 0 then guo_Global.of_AddInspHist(g_Obj.InspID, 13, '')  // log tech reviewed
	If not cbx_Tech.Checked and ii_TechReview = 1 then guo_Global.of_AddInspHist(g_Obj.InspID, 14, '')  // log tech un-reviewed
	
	w_inspdetail.ib_Modified = True  // Set Insp modified flag
	
	If li_VBIS = 1 Then wf_CheckVBIS()  // Check VBIS if vessel type has VBIS
		
Else   // If new insp was added

	// Get Inspection ID
	Select Max(INSP_ID) into :g_Obj.InspID from VETT_INSP;
	
	If SQLCA.SQLCode = 0 then
		Commit;
		guo_Global.of_AddInspHist(g_Obj.InspID, 0, 'Responsible: ' + ls_Resp)  // Log 'Inspection Created'

		// Add ghost item for inspection with all Nulls
		SetNull(ll_Cost)
		Insert Into VETT_ITEM (INSP_ID, ANS, DEF, REPORT, RISK, CLOSED) Values (:g_obj.inspid, :ll_Cost, :ll_Cost, :ll_Cost, :ll_Cost, :ll_Cost);
		If SQLCA.SQLCode <> 0 then
			Messagebox("DB Error", "Could not insert ghost item for new inspection.~n~n" + sqlca.Sqlerrtext, Exclamation!)
			Rollback;
		Else
			Commit;
		End If
	Else
		Rollback;
	End If
End If

Close(Parent)

end event

type sle_last from singlelineedit within w_newinsp
event ue_keyup pbm_keyup
integer x = 1371
integer y = 720
integer width = 841
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;Integer li_Row, li_Key
String ls_Name, ls_Found

li_Key = Message.WordParm
If li_Key < 64 then Return

ls_Name = Upper(This.Text)

li_Row = ids_Inspectors.Find("Upper(insp_lname) like '" + ls_Name + "%'", 1, ids_inspectors.RowCount())

If li_Row > 0 then
	ls_Found = ids_Inspectors.GetItemString(li_Row, "insp_lname")
	li_Row = Len(ls_Found) - Len(ls_Name)
	ls_Found = Right(ls_Found, li_Row)
	This.Text = WordCap(This.Text + ls_Found)
	This.SelectText(Len(ls_Name) + 1, li_Row)
End If
end event

event losefocus;
f_ValidateName(This.Text, 2)
end event

type sle_first from singlelineedit within w_newinsp
event ue_keyup pbm_keyup
integer x = 1371
integer y = 624
integer width = 841
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;Integer li_Row, li_Key
String ls_Name, ls_Found

li_Key = Message.WordParm
If li_Key < 64 then Return

ls_Name = Upper(This.Text)

li_Row = ids_Inspectors.Find("Upper(insp_fname) like '" + ls_Name + "%'", 1, ids_inspectors.RowCount())

If li_Row > 0 then
	ls_Found = ids_Inspectors.GetItemString(li_Row, "insp_fname")
	li_Row = Len(ls_Found) - Len(ls_Name)
	ls_Found = Right(ls_Found, li_Row)
	This.Text = WordCap(This.Text + ls_Found)
	This.SelectText(Len(ls_Name) + 1, li_Row)
End If
end event

event losefocus;
f_ValidateName(This.Text, 1)

end event

type st_8 from statictext within w_newinsp
integer x = 1243
integer y = 736
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Last:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_newinsp
integer x = 1243
integer y = 640
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "First:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_newinsp
integer x = 1207
integer y = 544
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspector~'s Name:"
boolean focusrectangle = false
end type

type dw_comp from datawindow within w_newinsp
integer x = 91
integer y = 320
integer width = 1006
integer height = 384
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_compsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then cb_Save.Enabled = False
end event

type st_5 from statictext within w_newinsp
integer x = 91
integer y = 256
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
string text = "Inspection Company:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_newinsp
integer x = 1390
integer y = 2000
integer width = 384
integer height = 112
integer taborder = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
// If non-Vetting R/W user changes 'Tech Reviewed' status
If cbx_Tech.Enabled and Not cb_Save.Visible then
	If (cbx_Tech.Checked and (ii_TechReview = 0 or ii_TechReview=10)) or (Not cbx_Tech.Checked and ii_TechReview = 1) then
		If ii_TechReview = 0 or ii_TechReview = 10 then ii_TechReview = 1 else ii_TechReview = 0
		Update VETT_INSP Set TECH_REVIEW = :ii_TechReview, LASTEDIT = getdate() where INSP_ID = :g_obj.Inspid;
		If SQLCA.SQLCode<>0 then
			Messagebox("Update Error","Unable to update review status~n~n" + SQLCA.SQLErrText)
		Else
			If ii_TechReview = 1 then guo_Global.of_AddInspHist(g_Obj.InspID, 13, '') Else guo_Global.of_AddInspHist(g_Obj.InspID, 14, '')
			g_Obj.Level = 1  // Return flag that insp was modified
			Commit;		
		End If
	End If
Else
	g_obj.VesselIMO = 0
End If

Close(Parent)
end event

type cb_find from commandbutton within w_newinsp
integer x = 951
integer y = 1504
integer width = 146
integer height = 68
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find"
end type

event clicked;
Integer li_Found

sle_port.Text = Trim(sle_Port.Text)

If sle_Port.Text > "" then
	li_Found = dw_port.Find("Upper(Port_n) like Upper('" + sle_port.Text + "%')", 1, dw_Port.RowCount())
	If li_Found > 0 then
		dw_Port.SetRow(li_Found)
		dw_Port.ScrollToRow(li_Found)
	Else
		MessageBox("Not Found", "The port was not found in the list.")
	End If
Else
	MessageBox("No Text", "Please specify a few characters of the port name to find.",Exclamation!)
End If
end event

type sle_port from singlelineedit within w_newinsp
event ue_keydown pbm_keydown
integer x = 91
integer y = 1504
integer width = 859
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If (key = KeyEnter!) then cb_Find.event clicked( )

end event

type dw_port from datawindow within w_newinsp
integer x = 91
integer y = 1216
integer width = 1006
integer height = 288
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_portsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_newinsp
integer x = 91
integer y = 1152
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

type dw_model from datawindow within w_newinsp
integer x = 91
integer y = 816
integer width = 1006
integer height = 288
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_modelsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;

If rowcount = 0 then cb_Save.Enabled = False

end event

event rowfocuschanged;
// Check which model is selected

String ls_ShortName

ls_ShortName = dw_Model.GetItemString(currentrow, "ShortName")

If ls_ShortName = "SIRE" Then
	st_label.text = "OCIMF Report Number:"
	sle_ocimf.visible = true
	cbx_Det.visible = false
ElseIf ls_ShortName = "PSC" Then
	st_label.text = "Vessel Detention:"	
	sle_ocimf.visible = false
	cbx_Det.visible = true
Else
	st_label.text = ""
	sle_ocimf.visible = false
	cbx_Det.visible = false
End If
end event

type st_3 from statictext within w_newinsp
integer x = 91
integer y = 752
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
string text = "Inspection Model:"
boolean focusrectangle = false
end type

type sle_tag from singlelineedit within w_newinsp
integer x = 1847
integer y = 128
integer width = 366
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_newinsp
integer x = 1847
integer y = 64
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
string text = "Inspection Tag:"
boolean focusrectangle = false
end type

type dp_insp from datepicker within w_newinsp
string tag = "2538454"
integer x = 91
integer y = 128
integer width = 475
integer height = 80
integer taborder = 10
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2007-11-28"), Time("08:25:02.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendartextsize = -8
integer calendarfontweight = 400
fontcharset calendarfontcharset = ansi!
fontpitch calendarfontpitch = variable!
fontfamily calendarfontfamily = swiss!
string calendarfontname = "Arial"
weekday firstdayofweek = monday!
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event losefocus;
Long ll_VslNr
String ls_VoyNo, ls_Port, ls_Pur
Integer li_PCN, li_Index
DateTime ldt_dep, ldt_arr

SetPointer(HourGlass!)

// Set cargo null
SetNull(is_Grade)
SetNull(is_Group)

// Set limits for port arrival & departure
ldt_arr = DateTime(Date(This.Value), Time("23:59:59.9"))
ldt_dep = DateTime(Date(This.Value), Time("00:00:00.0"))

// Get vessel number
Select TOP 1 VESSEL_NR into :ll_VslNr from VESSELS where (IMO_NUMBER = :g_Obj.VesselImo ) and (VESSEL_ACTIVE = 1);
If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If

Commit;

// Get purpose, voyage_nr, portcode, pcn
Select PURPOSE_CODE, VOYAGE_NR, PORT_CODE, PCN into :ls_Pur, :ls_VoyNo, :ls_Port, :li_PCN from POC Where (VESSEL_NR = :ll_VslNr) and (PORT_ARR_DT <= :ldt_arr) and (PORT_DEPT_DT >= :ldt_dep);
If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If

Commit;

If Not IsNull(ls_Pur) then  // If Tramos has purpose code
	// If purpose is not set, then set purpose
	If is_Purpose = "" then
		li_Index = ids_Purpose.Find("code = '" + ls_Pur + "'", 1, ids_Purpose.Rowcount( ))
		If li_Index > 0 then
			ddlb_Pur.SelectItem(li_Index)
			is_Purpose = ls_Pur
		End If
	Else // Check if same
		If is_Purpose <> 	ls_Pur then
			If Messagebox("Purpose Code", "The 'purpose' specified by the Tramos operator does not match the previously selected purpose.~n~nWould you like to update the Purpose field?", Question!, YesNo!) = 1 then
				li_Index = ids_Purpose.Find("code = '" + ls_Pur + "'", 1, ids_Purpose.Rowcount( ))
				If li_Index > 0 then
					ddlb_Pur.SelectItem(li_Index)
					is_Purpose = ls_Pur
				End If				
			End If
		End If
	End If
End If

// Find and select port in list
li_Index = dw_Port.Find( "Port_Code = '" + ls_Port + "'", 1, dw_Port.RowCount())
If li_Index > 0 then
	dw_Port.SetRow(li_Index)
	dw_Port.ScrollTorow(li_Index)
End If

// Get cargo
Select GRADE_GROUP, GRADE_NAME into :is_group, :is_grade from CD where (VESSEL_NR = :ll_VslNr) and (VOYAGE_NR = :ls_VoyNo ) and (PORT_CODE = :ls_Port) and (PCN = :li_PCN);
If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If
Commit;

end event

type st_1 from statictext within w_newinsp
integer x = 91
integer y = 64
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date of Inspection:"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_newinsp
long linecolor = 12632256
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 2249
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_newinsp
long linecolor = 12632256
integer linethickness = 4
integer beginx = 1152
integer beginy = 64
integer endx = 1152
integer endy = 1584
end type

