$PBExportHeader$w_inspdetail.srw
forward
global type w_inspdetail from window
end type
type cb_sr from commandbutton within w_inspdetail
end type
type cbx_newcomm from checkbox within w_inspdetail
end type
type cb_mgmt from commandbutton within w_inspdetail
end type
type cb_expcap from commandbutton within w_inspdetail
end type
type cb_super from commandbutton within w_inspdetail
end type
type cb_copycomm from commandbutton within w_inspdetail
end type
type ddlb_officers from dropdownlistbox within w_inspdetail
end type
type cbx_no from checkbox within w_inspdetail
end type
type cb_matrix from commandbutton within w_inspdetail
end type
type cb_summ from commandbutton within w_inspdetail
end type
type cb_viewatt from commandbutton within w_inspdetail
end type
type cb_itematt from commandbutton within w_inspdetail
end type
type cb_att from commandbutton within w_inspdetail
end type
type cbx_open from checkbox within w_inspdetail
end type
type cb_del from commandbutton within w_inspdetail
end type
type cb_edit from commandbutton within w_inspdetail
end type
type cb_new from commandbutton within w_inspdetail
end type
type dw_items from datawindow within w_inspdetail
end type
type cb_close from commandbutton within w_inspdetail
end type
type cb_editinsp from commandbutton within w_inspdetail
end type
type dw_insp from datawindow within w_inspdetail
end type
type gb_1 from groupbox within w_inspdetail
end type
type gb_2 from groupbox within w_inspdetail
end type
end forward

global type w_inspdetail from window
integer width = 3351
integer height = 2768
boolean titlebar = true
string title = "Inspection Details"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_sr cb_sr
cbx_newcomm cbx_newcomm
cb_mgmt cb_mgmt
cb_expcap cb_expcap
cb_super cb_super
cb_copycomm cb_copycomm
ddlb_officers ddlb_officers
cbx_no cbx_no
cb_matrix cb_matrix
cb_summ cb_summ
cb_viewatt cb_viewatt
cb_itematt cb_itematt
cb_att cb_att
cbx_open cbx_open
cb_del cb_del
cb_edit cb_edit
cb_new cb_new
dw_items dw_items
cb_close cb_close
cb_editinsp cb_editinsp
dw_insp dw_insp
gb_1 gb_1
gb_2 gb_2
end type
global w_inspdetail w_inspdetail

type variables

Boolean ib_ReadOnly, ib_Modified
 
Integer ii_Off = 0      // Officer selection

Datastore ids_Item  // Used to update a single item
end variables

forward prototypes
public subroutine wf_calcinsprating ()
private subroutine wf_filteritems ()
public subroutine wf_exportcaps ()
public subroutine wf_sendmail2tech (long al_inspid)
end prototypes

public subroutine wf_calcinsprating ();Integer li_High, li_Med, li_Loop, li_Score

Long ll_VslPart, ll_EPart, ll_Max, ll_InspID

Decimal{2} ldec_Percent, ldec_VslPer, ldec_Final

String ls_Rating

li_Med = 0
li_High = 0

// Get weightage of risks as per responsibility
For li_Loop = 1 to dw_items.Rowcount( )
	If dw_items.GetItemNumber(li_Loop, "Def") = 1 then
		ls_Rating = dw_items.GetItemString(li_Loop, "Resptext")
		Choose Case dw_Items.GetItemNumber(li_Loop, "Risk")
			Case 0
				If ls_Rating = "Vessel" then ll_VslPart += 15 else ll_EPart += 15
			Case 1
				If ls_Rating = "Vessel" then ll_VslPart += 30 else ll_EPart += 30
				li_Med++
			Case 2
				If ls_Rating = "Vessel" then ll_VslPart += 50 else ll_EPart += 50
				li_High++
		End Choose
	End If
Next

// Get maxscore and Inspection ID
ll_Max = dw_Insp.GetItemNumber(1, "Maxscore")
ll_InspID = dw_Insp.GetItemNumber(1, "Insp_ID")

// If maxscore is invalid
If ll_Max < 1000 then Return

// calculate score
ldec_Percent = 100 - ((ll_VslPart + ll_EPart) / ll_Max * 5000)

// Calc rating
li_Score = Round(ldec_Percent,0)
ls_Rating = "F"
If li_Score >=30 then ls_Rating = "E"
If li_Score >=45 then ls_Rating = "D"
If li_Score >=60 then ls_Rating = "C"
If li_Score >=75 then ls_Rating = "B"
If li_Score >=90 then ls_Rating = "A"

If li_High > 0 then   // If high risk present
	ls_Rating += "-" 
ElseIf (li_Med = 0) then   // If no high or medium risk
	ls_Rating += "+"
End If

ldec_VslPer = 100 - (ll_VslPart / ll_Max * 5000)
ll_VslPart += (ll_EPart / 4)

If ll_VslPart  + ll_EPart > 0 then
	ldec_Final = ldec_VslPer  - ( ll_VslPart  / ( ll_VslPart  + ll_EPart ) *  ( ldec_VslPer - ldec_Percent))
	If ldec_Final < 0 then ldec_Final = 0.0
Else
	ldec_Final = 100.0	
End If

// Save rating and score
Update VETT_INSP Set RATING = :ls_Rating, VSLSCORE = :ldec_Final Where INSP_ID = :ll_InspID;

If SQLCA.SQLCode = 0 then 
	Commit;
Else
	MessageBox("DB Error", "Could not update inspection rating & vessel score.~n~n" + SQLCA.Sqlerrtext,Exclamation!)
	Rollback;
End If

end subroutine

private subroutine wf_filteritems ();
String ls_Filter

ls_Filter = ""

If cbx_Open.Checked then ls_Filter = "(closed = 0)"

If cbx_No.Checked then 
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(Ans = 1)"
End If

If cbx_NewComm.Checked then 
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(NewItem = 0)"
End If

If ii_Off>0 then
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "((Int(-ModelExt/10000)=" + String(ii_Off) + ")"
    ls_Filter += " or (Int(Mod(-ModelExt/100, 100))=" + String(ii_Off) + ")"
	ls_Filter += " or (Mod(-ModelExt,100)=" + String(ii_Off) + "))"	
End If

dw_items.SetFilter(ls_Filter)

dw_items.Filter( )

If dw_items.RowCount() = 0 then
	cb_del.Enabled = False
	cb_edit.Enabled = False
	cb_itematt.Enabled = False
Else
	If (g_Obj.Access > 1) and (g_Obj.DeptID = 1) and not ib_ReadOnly then cb_del.Enabled = True
	cb_edit.Enabled = True
	cb_ItemAtt.Enabled = True
End If
end subroutine

public subroutine wf_exportcaps ();// This function checks and exports any new CAPs created.

Integer li_Exp, li_NewCAP

// Check if any new CAPs to be exported
Select Count(*) Into :li_NewCAP From VETT_ITEM 
Where INSP_ID=:g_Obj.InspID And IS_CAP=1 And (CAP_GEN=0 or CAP_GEN is null);
Commit;

If li_NewCAP=0 then Return

// Get current Insp CAP export status
Select CAPEXPFLAG into :li_Exp from VETT_INSP Where INSP_ID = :g_Obj.InspID;
Commit;

/* Check current flag value

0 = Never exported
1 = Export all CAPS
2 = Export all new CAPS   (not in use after CR 2854)
10 = Export completed
11 = Re-Export all CAPS   (not in use after CR 2854)
12 = Re-Export all new CAPs

*/

guo_Global.of_AddInspHist(g_Obj.InspID, 15, "New CAPs Flagged: " + String(li_NewCAP))

// Update flag (or return if already set)
If li_Exp=0 or li_Exp=10 then li_Exp += 2 Else Return

Update VETT_INSP Set CAPEXPFLAG = :li_Exp Where INSP_ID = :g_Obj.InspID;

// If SQL error
If SQLCA.SQLCode <> 0 then
	Rollback;
	Messagebox("DB Error", "Unable to update inspection export status~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

Commit;



end subroutine

public subroutine wf_sendmail2tech (long al_inspid);// This function send a notification email to the technical responsible for an inspection

mt_n_outgoingmail lnvo_Mail
String ls_Body, ls_Email, ls_Err, ls_Vessel, ls_Model, ls_Comp, ls_Sub
Integer li_Review
DateTime ldt_Date

// Get vessel name/number and tech super
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME,IsNull(USERS.EMAIL,TECH_SUPER+'@maersk.com'),TECH_REVIEW
Into :ls_Vessel, :ls_Email, :li_Review
From VESSELS Inner Join VETT_INSP On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO
Left Join USERS On VESSELS.TECH_SUPER=USERS.USERID
Where VESSELS.VESSEL_ACTIVE=1 and VETT_OFFICEID is not Null and VETT_TYPE is not null and INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then	
	Rollback;
	Messagebox("Database Error","Unable to retrieve vessel information.", Exclamation!)
	Return
End If

Commit;

// Check if email already sent today
Select TECHEMAILSENT into :ldt_Date from VETT_INSP Where INSP_ID = :al_InspID;
Commit;
If Not IsNull(ldt_Date) Then
	If Date(ldt_Date) = Today() then
		Messagebox("Email Sent", "A notification email has already been sent today. Please wait until tomorrow to re-send another notification.", Exclamation!)
		Return		
	End If
End If

If IsNull(ldt_Date) then ls_Body = "Do you want to send " Else ls_Body = "The last notification email was sent on " + String(ldt_Date, "dd mmm yyyy") + ".~n~nDo you want to re-send "
If Messagebox("Confirm Email Notification", ls_Body + "a notification email for this inspection to the superintendent responsible (" + ls_Email +  ") for the vessel?", Question!, YesNo!) = 2 then Return

// Check if no super assigned
If IsNull(ls_Email) then
	Messagebox("No Superintendent", "No superintendent has been assigned to the vessel. Please assign a technical superintendent to the vessel.", Exclamation!)
	Return
End If

// Get Insp Data
Select VETT_INSPMODEL.NAME, INSPDATE, VETT_COMP.NAME Into :ls_Model, :ldt_Date, :ls_Comp From VETT_INSP
Inner Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_INSP.COMP_ID
Where VETT_INSP.INSP_ID = :al_InspID;

// Subject
ls_Sub = "Notification for Inspection Review (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Greetings,<br/><br/>This is a notification email from VIMS for the review of following inspection.<br/><br/>"
ls_Body += "CAPs have been raised for observations where applicable. For other observations and the Inspection Summary (incl. photo attachments) you are kindly requested to provide your additional comments for the appropriate observations in VIMS.<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;'><tr><td>Vessel Number/Name</td><td> : " + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Inspection Type</td><td> : " + ls_Model + "</td></tr>"
ls_Body += "<tr><td>Inspection Date</td><td> : " + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Conducted By</td><td> : " + ls_Comp + "</td></tr></table><br/><br/>"
ls_Body += "Best Regards,<br/>VIMS System Admin<br/><br/><hr/><small>"
ls_Body += guo_Global.is_Emailfooter + "</small></body></html>"

// Create and send email
lnvo_Mail = Create mt_n_outgoingmail
If lnvo_Mail.of_createmail( "tramosmt@maersk.com", ls_Email, ls_Sub, ls_Body, ls_Err) < 1 then
	Messagebox("Email Error", "The notification email could not be created.~n~n" + ls_Err, Exclamation!)	
	Return
End If
lnvo_Mail.of_SetCreator("JAU010", ls_Err)
If lnvo_Mail.of_SendMail(ls_Err) < 1 then
	Messagebox("Email Error", "The notification email could not be sent.~n~n" + ls_Err, Exclamation!)
	Return
End If

guo_Global.of_LogEmail(ls_Email,ls_Sub, ls_Body)

Messagebox("Notification Sent", "The email notification to the superintendent was sent successfully!", Information!)

If li_Review = 0 then // If previously not reviewed, then set status as 'Notification Sent'
	Update VETT_INSP Set TECH_REVIEW = 10 Where INSP_ID = :al_InspID;	
	Commit;
End If

// Update date last sent date
Update VETT_INSP Set TECHEMAILSENT = GetDate() Where INSP_ID = :al_InspID;
Commit;



end subroutine

on w_inspdetail.create
this.cb_sr=create cb_sr
this.cbx_newcomm=create cbx_newcomm
this.cb_mgmt=create cb_mgmt
this.cb_expcap=create cb_expcap
this.cb_super=create cb_super
this.cb_copycomm=create cb_copycomm
this.ddlb_officers=create ddlb_officers
this.cbx_no=create cbx_no
this.cb_matrix=create cb_matrix
this.cb_summ=create cb_summ
this.cb_viewatt=create cb_viewatt
this.cb_itematt=create cb_itematt
this.cb_att=create cb_att
this.cbx_open=create cbx_open
this.cb_del=create cb_del
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.dw_items=create dw_items
this.cb_close=create cb_close
this.cb_editinsp=create cb_editinsp
this.dw_insp=create dw_insp
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_sr,&
this.cbx_newcomm,&
this.cb_mgmt,&
this.cb_expcap,&
this.cb_super,&
this.cb_copycomm,&
this.ddlb_officers,&
this.cbx_no,&
this.cb_matrix,&
this.cb_summ,&
this.cb_viewatt,&
this.cb_itematt,&
this.cb_att,&
this.cbx_open,&
this.cb_del,&
this.cb_edit,&
this.cb_new,&
this.dw_items,&
this.cb_close,&
this.cb_editinsp,&
this.dw_insp,&
this.gb_1,&
this.gb_2}
end on

on w_inspdetail.destroy
destroy(this.cb_sr)
destroy(this.cbx_newcomm)
destroy(this.cb_mgmt)
destroy(this.cb_expcap)
destroy(this.cb_super)
destroy(this.cb_copycomm)
destroy(this.ddlb_officers)
destroy(this.cbx_no)
destroy(this.cb_matrix)
destroy(this.cb_summ)
destroy(this.cb_viewatt)
destroy(this.cb_itematt)
destroy(this.cb_att)
destroy(this.cbx_open)
destroy(this.cb_del)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.dw_items)
destroy(this.cb_close)
destroy(this.cb_editinsp)
destroy(this.dw_insp)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;Integer li_Comp
n_miredefault lnvo_mire
n_inspio lnvo_insp

// If inspection is locked or not.  g_Obj.Level=0 indicates insp is locked for editing
If (g_Obj.Level = 0) or (g_Obj.Access = 1) or IsNull(g_Obj.InspID) then ib_ReadOnly = True Else ib_ReadOnly = False

dw_Insp.SetTransobject(SQLCA)
dw_Items.SetTransobject(SQLCA)

dw_Insp.Retrieve(g_Obj.InspID)
dw_Items.Retrieve(g_Obj.InspID)

// ids_Item is used to retrieve a single item and update the same in dw_items
ids_Item = Create Datastore
ids_Item.DataObject = "d_sq_tb_itemsingle"
ids_Item.SetTransObject(SQLCA)

Commit; 

// If Insp Model supports assignment to officers, show filter for officers
If dw_Insp.GetItemNumber(1, "MinExtNum") < 0 then 
	ddlb_Officers.AddItem("All Questions")
	ddlb_Officers.AddItem("Master")
	ddlb_Officers.AddItem("Chief Officer")
	ddlb_Officers.AddItem("2nd Officer")
	ddlb_Officers.AddItem("3rd Officer")
	ddlb_Officers.AddItem("Chief Engineer")
	ddlb_Officers.AddItem("2nd Engineer")
	ddlb_Officers.AddItem("3rd Engineer")
	ddlb_Officers.AddItem("4th Engineer")
	ddlb_Officers.AddItem("Maritime Officer")
	ddlb_Officers.AddItem("Gas Engineer")
	ddlb_Officers.AddItem("Electrical Engineer")
	ddlb_Officers.AddItem("Deck Department")
	ddlb_Officers.AddItem("Engine Department")
	ddlb_Officers.SelectItem(1)
	ddlb_Officers.Visible=True
End If

If g_Obj.Access > 1 then  // If RW or Superuser
	If g_obj.DeptID = 1 then  // If Vetting dept then show SIRE PIN
		If ib_ReadOnly then 
			cb_New.Enabled = False			
			cb_Super.Enabled = False
			cb_Mgmt.Enabled = False
			cb_ExpCap.Enabled = False
			cb_Del.Enabled = False
			cb_SR.Enabled = False
		Else
			cb_EditInsp.Enabled = True 
		End If
		If dw_Insp.GetItemNumber(1, "Mgmt_Review") = 1 then cb_Mgmt.Enabled = False
	Else
		cb_New.Enabled = False
		cb_EditInsp.Enabled = True
		cb_Mgmt.Visible = False
		cb_Super.Visible = False		
		cb_SR.Enabled = False
	End If
Else  // Readonly user
	cb_New.Enabled = False   
	cb_EditInsp.Enabled = False
	cb_Expcap.Enabled = False
	cb_Super.Visible = False
	cb_Mgmt.Visible = False
	cb_SR.Enabled = False
End If

// If this is a AutoFill insp, disable new and delete buttons and fill items if required
If dw_insp.GetItemNumber(1, "Autofill") = 1 then 
	cb_New.Enabled = False
	cb_Del.Enabled = False
	cb_New.Visible = False
	cb_Del.Visible = False
	cb_ExpCap.x = cb_Del.x
	If cb_Edit.x > cb_New.X then cb_ItemAtt.X = cb_Edit.X
	cb_Edit.X = cb_New.X

	If (dw_items.RowCount( ) + dw_items.FilteredCount() = 0) then		// If no items
		// If this is a MIRE 
		If (Left(dw_Insp.GetItemString(1, "modelname"), 4) = "MIRE") then
			lnvo_mire = Create n_miredefault
			If lnvo_mire.of_AddDefaultItems(g_Obj.InspId, dw_insp.GetItemNumber(1, "imid"), g_Obj.ObjString, String(dw_insp.GetItemNumber(1, "VesselIMO")), String(dw_insp.GetItemDateTime(1, "InspDate"), "dd mmm yyyy"), dw_insp.GetItemString(1, "Ports_Port_n"), dw_insp.GetItemString(1, "InspName")) < 0 then MessageBox("DB Error", "Unable to add MIRE items to inspection.", Exclamation!)
			Destroy lnvo_mire
		Else  // Non-MIRE
			If lnvo_insp.of_AutoFillInsp(g_Obj.InspId, dw_insp.GetItemNumber(1, "imid"))<0 then MessageBox("DB Error", "Unable to add default items to inspection.", Exclamation!)	
  	End If	
		dw_Items.Retrieve(g_Obj.InspID)
	End If
End If

// Hide matrix and summary buttons for non-MIRE
If Left(dw_insp.GetItemString(1, "modelname"), 4) <> "MIRE" Then
	cb_Matrix.Visible = False
	cb_Summ.Visible = False
End If

// If SIRE, then show 'Get Report' button
If Left(dw_insp.GetItemString(1, "modelname"), 4) = "SIRE" Then cb_SR.Visible = True
If dw_Insp.GetItemNumber(1, "Locked")=1 or ib_ReadOnly then cb_SR.Enabled = False

This.Title = "Inspection Details - " + g_obj.Objstring   // Vsl name on title


end event

event close;
Destroy ids_Item

If Not ib_ReadOnly then 

	If cbx_open.Checked or cbx_No.Checked Then  // Must remove filters to calculate rating and score correctly
		dw_Items.SetRedraw(False)
		dw_Items.SetFilter("")
		dw_Items.Filter( )
	End If
	
	g_obj.InspID = dw_insp.GetItemNumber(1, "Insp_ID")	
	
	wf_calcinsprating( ) // Update rating
	
	wf_exportcaps()  // Export any new CAPs
	
	If ib_Modified then   // If inspection has been modified, set flag to 'yellow'
		Update VETT_INSP Set EXPFLAG = 1 Where INSP_ID = :g_obj.Inspid;
		If SQLCA.SQLcode <> 0 then 
			Messagebox("DB Error", "Could not update inspection flag.~n~n" + SQLCA.SQLErrtext,Exclamation!)
			Rollback;
		Else
			Commit;
		End If		
	End If
	
	// Release lock
	Update VETT_INSP Set USER_LOCK = Null Where INSP_ID = :g_obj.Inspid;
	
	If SQLCA.SQLcode <> 0 then 
		Messagebox("DB Error", "Could not release inspection lock.~n~n" + SQLCA.SQLErrtext,Exclamation!)
		Rollback;
	Else
		Commit;
	End If
	
End If

end event

type cb_sr from commandbutton within w_inspdetail
boolean visible = false
integer x = 750
integer y = 560
integer width = 590
integer height = 76
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "SIRE Web Services..."
end type

event clicked;
// Open the SIRE Web Services window and get report or observations from web services
// First check if OCIMF number is present

String ls_Ocimf

ls_Ocimf = dw_insp.GetItemString(1,"Ocimf")
if Len(ls_Ocimf)=0 then
	Messagebox("OCIMF Report Number", "The OCIMF Report number is required to access SIRE Web Services.",Exclamation!)
	Return
End If

g_Obj.InspID = dw_insp.GetItemNumber(1, "Insp_ID")
g_Obj.InspModel = dw_insp.GetItemNumber(1, "IMID")

Open(w_callws)

If g_Obj.Level=1 then  // If items were added/updated
	dw_Items.Retrieve(g_Obj.InspID)
	wf_FilterItems( )
End If
	
end event

type cbx_newcomm from checkbox within w_inspdetail
integer x = 1957
integer y = 2464
integer width = 343
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "New! Only"
end type

event clicked;
wf_FilterItems()
end event

type cb_mgmt from commandbutton within w_inspdetail
integer x = 1865
integer y = 560
integer width = 347
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Notify Mgmt"
end type

event clicked;Integer li_Result
String ls_Users

// If already notified
If dw_Insp.GetItemNumber(1, "Mgmt_Review") > 0 then
	If Messagebox("Confirm Email Notification", "The management has already been notified of this inspection. Do you want to re-send notifications?", Question!, YesNo!) = 2 then Return
	li_Result = 2  // Force
Else
	li_Result = guo_Global.of_NotifyManagement(dw_insp.GetItemNumber(1, "Insp_ID"), 1, ls_Users)  // check criteria
	If li_Result = 0 then  // If Insp does not meet criteria
		If Messagebox("Confirm Email Notification", "This inspection does not meet the criteria for Management Notification.~n~nDo you still want to send notifications to the management for this inspection?", Question!, YesNo!) = 2 then Return
		li_Result = 2
	Else
		If Messagebox("Confirm Email Notification", "Are you sure you want to send notifications to the management for this inspection?", Question!, YesNo!) = 2 then Return
		li_Result = 0		
	End If
End If

li_Result = guo_Global.of_NotifyManagement(dw_insp.GetItemNumber(1, "Insp_ID"), li_Result, ls_Users)  // Send emails

If li_Result < 0 then Messagebox("Error", "And error occurred while creating management notification emails", Exclamation!)

If li_Result = 0 then
	Messagebox("No emails sent", "There were no recipients to send emails to.")
Else
	dw_Insp.SetItem(1, "Mgmt_Review", 1)
	Messagebox("Management Notified", "Management notification was successful. Notification emails were sent to the following users:~n~n" + ls_Users)
	This.Enabled = False
End If
end event

type cb_expcap from commandbutton within w_inspdetail
boolean visible = false
integer x = 2578
integer y = 2464
integer width = 347
integer height = 80
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export CAPs"
end type

event clicked;
Integer li_Exp

Select CAPEXPFLAG into :li_Exp from VETT_INSP Where INSP_ID = :g_Obj.InspID;

If SQLCA.SQLCode <> 0 then
	Rollback;
	Messagebox("DB Error", "Unable to retrieve inspection export status~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

Commit;

/* Check current flag value

0 = Never exported
1 = Export all CAPS
2 = Export all new CAPS
10 = Export completed
11 = Re-Export all CAPS
12 = Re-Export all new CAPs

*/

Choose Case li_Exp
	Case 0
		OpenWithParm(w_CAPExport, g_Obj.InspID)
	Case 1, 2, 11, 12
		If Messagebox("Confirm Export Cancel", "This inspection as already been flagged for export. Do you want to cancel this export?", Question!, YesNo!) = 2 then Return
		If li_Exp > 10 then li_Exp = 10 Else li_Exp = 0
		Update VETT_INSP Set CAPEXPFLAG = :li_Exp Where INSP_ID = :g_Obj.InspID;
		guo_Global.of_AddInspHist(g_Obj.InspID, 16, "")
	Case 10		
		If Messagebox("Confirm Re-Export", "This inspection as already been exported. Do you want to re-export?", Question!, YesNo!) = 2 then Return
		OpenWithParm(w_CAPExport, g_Obj.InspID)		
	Case Else
		Messagebox("DB Error", "Invalid CAP export status found in inspection.", Exclamation!)
		Return
End Choose

// If SQL error
If SQLCA.SQLCode <> 0 then
	Rollback;
	Messagebox("DB Error", "Unable to change inspection export status~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

Commit;	
end event

type cb_super from commandbutton within w_inspdetail
integer x = 2213
integer y = 560
integer width = 343
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Notify Tech"
end type

event clicked;
If dw_Insp.GetItemNumber(1,"NoTechReview")=1 then
	If Messagebox("Technical Review Not Required","This inspection does not require a review by the Technical Organisation.~n~nDo you still want to send a notification email to the technical superintendent?", Question!, YesNo!) = 2 then Return
End If

wf_SendMail2Tech(g_Obj.InspID)

end event

type cb_copycomm from commandbutton within w_inspdetail
boolean visible = false
integer x = 2743
integer y = 2464
integer width = 183
integer height = 80
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
// Used to copy DW text to clipboard because copying from DW event doesn't work

Clipboard(dw_Items.GetItemString(dw_Items.GetRow(), "owncomm"))

Post Messagebox("Copied", "Comments copied to clipboard.", Information!)
end event

type ddlb_officers from dropdownlistbox within w_inspdetail
boolean visible = false
integer x = 2725
integer y = 672
integer width = 549
integer height = 832
integer taborder = 90
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Choose Case index
	Case 1
		ii_Off = 0
	Case 2 to 5
		ii_Off = index * 5
	Case 6 to 14
		ii_Off = index * 5 + 20
End Choose

wf_FilterItems( )


end event

type cbx_no from checkbox within w_inspdetail
integer x = 1573
integer y = 2464
integer width = 293
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "~'No~' Only"
end type

event clicked;
wf_filteritems( )
end event

type cb_matrix from commandbutton within w_inspdetail
integer x = 1097
integer y = 560
integer width = 347
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Matrix"
end type

event clicked;
g_obj.InspID = dw_insp.GetItemNumber(1, "Insp_ID")
g_obj.ObjString = String(dw_insp.GetItemDateTime(1, "Inspdate"), "yyyyMMdd")  // To verify date on matrix sheet

If ib_ReadOnly or (g_Obj.DeptID > 1) then g_Obj.Level = 0 Else g_Obj.Level = 1

Open(w_Matrix)
end event

type cb_summ from commandbutton within w_inspdetail
integer x = 750
integer y = 560
integer width = 347
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Summary"
end type

event clicked;
g_Obj.Level = 1 

If dw_insp.GetItemNumber(1, "Locked") = 1 then g_Obj.Level = 0

If (ib_ReadOnly) or (g_Obj.DeptID > 1) then g_Obj.Level = 0   // If readonly mode

g_obj.InspID = dw_Insp.GetItemNumber(1, "Insp_ID")

Open(w_Summary)
end event

type cb_viewatt from commandbutton within w_inspdetail
integer x = 2560
integer y = 560
integer width = 713
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "View All Attachments"
end type

event clicked;
g_obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")

OpenWithParm(w_AttFull, g_obj.InspID)

Do While Message.DoubleParm > 0
	If Message.Doubleparm = 1 then OpenWithParm(w_AttFull, g_Obj.InspID) Else OpenWithParm(w_Thumbs, g_Obj.InspID)
Loop

end event

type cb_itematt from commandbutton within w_inspdetail
integer x = 750
integer y = 2464
integer width = 347
integer height = 80
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Item Att."
end type

event clicked;
g_obj.InspID = dw_Insp.GetItemNumber(1, "Insp_ID")
g_obj.ObjID  = dw_Items.GetItemNumber( dw_items.GetRow(), "Item_ID")
g_obj.objtype = 0

If ib_ReadOnly then g_Obj.Level = 0 Else g_Obj.Level = 1

Open(w_attlist)

dw_items.SetItem( dw_Items.GetRow(), "attcount", g_obj.Noteid)   // Set num of att

end event

type cb_att from commandbutton within w_inspdetail
integer x = 402
integer y = 560
integer width = 347
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Header Att."
end type

event clicked;
g_Obj.InspID = dw_insp.GetItemNumber(1, "Insp_ID")
SetNull(g_obj.Objid)
g_Obj.Objtype = 1
If ib_ReadOnly or (g_Obj.DeptID > 1) then g_Obj.Level = 0 Else g_Obj.Level = 1

Open(w_AttList)


end event

type cbx_open from checkbox within w_inspdetail
integer x = 1170
integer y = 2464
integer width = 366
integer height = 80
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open Only"
end type

event clicked;
wf_filteritems( )
end event

type cb_del from commandbutton within w_inspdetail
integer x = 2926
integer y = 2464
integer width = 347
integer height = 80
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;Integer li_Comp

If g_obj.DeptID > 1 then   // Check if user is not from Vetting Dept
	MessageBox("Access Denied", "Your department does not have access to delete an item.", Exclamation!)
	Return
End If

li_Comp = dw_insp.GetItemNumber(1, "Locked")

If (li_Comp = 1) then   //  Check if insp is closed out
	Messagebox("Access Denied", "The inspection has been closed-out. No further modifications are possible until the inspection is re-opened.",Exclamation!)
	Return
End If

If dw_items.GetItemNumber(dw_Items.GetRow(), "Attcount")>0 then 
	MessageBox("Attachments", "The selected item has attachments. Please remove the attachments before deleting this item.", Exclamation!)
	Return
End If
	
If MessageBox("Confirm Delete", "Are you sure you want to delete the selected item?", Question!, YesNo!) = 2 then Return

g_obj.Objid = dw_items.GetItemNumber( dw_Items.GetRow(), "Item_ID")

// If this is not a ShipNet CAP
If dw_items.GetItemNumber(dw_Items.GetRow(), "CAP_Gen") = 0 or IsNull(dw_items.GetItemNumber(dw_Items.GetRow(), "CAP_Gen")) then

	Delete from VETT_ITEMHIST where ITEM_ID = :g_obj.Objid;

	If SQLCA.SQlcode >= 0 then 
		Delete from VETT_ATT where ITEM_ID = :g_obj.ObjID;
	End If
	
	If SQLCA.SQlcode >= 0 then 
		Delete from VETT_ITEM where ITEM_ID = :g_obj.ObjID;
	End If
	
	If SQLCA.Sqlcode <> 0 then
		Messagebox("DB Error", "Could not delete the item.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
		Rollback;
	Else
		Messagebox("Deleted", "The selected item was deleted.")
		ib_Modified = True
		Commit;
	End If
Else
	// Mark for deletion (Once ShipNet is informed, it will be deleted)
	Update VETT_ITEM Set CAP_STATUS = 10 Where ITEM_ID = :g_obj.Objid;
	Commit;
End If

dw_items.DeleteRow(dw_items.GetRow())
dw_Items.Resetupdate( )

g_obj.Inspid = dw_insp.GetItemNumber( 1, "Insp_ID")

guo_Global.of_UpdateLastEdit(g_obj.InspID)
dw_insp.Retrieve(g_obj.InspID)

If dw_items.Rowcount( ) = 0 then 
	cb_del.Enabled = False
	cb_edit.Enabled = False
	cb_itematt.Enabled = False
End If

end event

type cb_edit from commandbutton within w_inspdetail
integer x = 402
integer y = 2464
integer width = 347
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open"
end type

event clicked;Integer li_CurRow

SetPointer(HourGlass!)

// Remember current row
li_CurRow = dw_Items.GetRow()

// Get all info to pass to w_ItemDetail
g_obj.ObjID = dw_items.GetItemNumber( li_CurRow, "Item_ID")
g_obj.InspModel = dw_insp.GetItemNumber(1, "ImID")
g_obj.InspID = dw_insp.GetItemNumber(1, "Insp_ID")
g_obj.ObjString = "EditItem"
g_obj.Param = dw_insp.GetItemNumber(1, "ExtModel")
g_obj.ReqType = dw_insp.GetItemNumber(1, "Locked")
If ib_ReadOnly then g_Obj.ObjType = 1 Else g_Obj.ObjType = 0

//  Set navigation buttons in w_itemdetail
g_obj.level = 0
If li_CurRow > 1 then g_obj.Level += 1
If li_CurRow < dw_items.RowCount( ) then g_obj.Level += 2

Open(w_Itemdetail)

// If Item was modified
If g_Obj.ObjID > 0 then
	guo_Global.of_UpdateLastEdit(g_obj.InspID)
	If ids_Item.Retrieve(g_Obj.ObjID) <> 1 then 
		Messagebox("DB Error", "Could not refresh the item in this list.", Exclamation!)
	Else
		dw_Items.SetItem(li_CurRow, "TextData", ids_Item.GetItemString(1, "TextData"))
		dw_Items.SetItem(li_CurRow, "InspComm", ids_Item.GetItemString(1, "InspComm"))
		dw_Items.SetItem(li_CurRow, "OwnComm", ids_Item.GetItemString(1, "OwnComm"))
		dw_Items.SetItem(li_CurRow, "VslComm", ids_Item.GetItemString(1, "VslComm"))
		dw_Items.SetItem(li_CurRow, "TextData", ids_Item.GetItemString(1, "TextData"))		
		dw_Items.SetItem(li_CurRow, "Guide", ids_Item.GetItemNumber(1, "Guide"))
		dw_Items.SetItem(li_CurRow, "Closed", ids_Item.GetItemNumber(1, "Closed"))
		dw_Items.SetItem(li_CurRow, "Closedate", ids_Item.GetItemDateTime(1, "Closedate"))
		dw_Items.SetItem(li_CurRow, "Ans", ids_Item.GetItemNumber(1, "Ans"))
		dw_Items.SetItem(li_CurRow, "Report", ids_Item.GetItemNumber(1, "Report"))
		dw_Items.SetItem(li_CurRow, "Is_CAP", ids_Item.GetItemNumber(1, "Is_CAP"))
		dw_Items.SetItem(li_CurRow, "Risk", ids_Item.GetItemNumber(1, "Risk"))
		dw_Items.SetItem(li_CurRow, "ExtNum", ids_Item.GetItemNumber(1, "ExtNum"))
		dw_Items.SetItem(li_CurRow, "RiskRating", ids_Item.GetItemNumber(1, "RiskRating"))
		dw_Items.SetItem(li_CurRow, "ObjNum", ids_Item.GetItemNumber(1, "ObjNum"))
		dw_Items.SetItem(li_CurRow, "P1Num", ids_Item.GetItemNumber(1, "P1Num"))
		dw_Items.SetItem(li_CurRow, "P1Type", ids_Item.GetItemNumber(1, "P1Type"))
		dw_Items.SetItem(li_CurRow, "P2Num", ids_Item.GetItemNumber(1, "P2Num"))
		dw_Items.SetItem(li_CurRow, "P2Type", ids_Item.GetItemNumber(1, "P2Type"))
		dw_Items.SetItem(li_CurRow, "P3Num", ids_Item.GetItemNumber(1, "P3Num"))
		dw_Items.SetItem(li_CurRow, "P3Type", ids_Item.GetItemNumber(1, "P3Type"))
		dw_Items.SetItem(li_CurRow, "CauseText", ids_Item.GetItemString(1, "CauseText"))
		dw_Items.SetItem(li_CurRow, "RespText", ids_Item.GetItemString(1, "RespText"))		
	End If
End If

Commit;

// If navigation buttons were pressed in w_itemdetail
If g_obj.Level = 1 then	li_CurRow --
If g_obj.Level = 2 then	li_CurRow ++
If g_obj.Level > 0 then
	dw_items.SetRow(li_CurRow) 
	dw_items.ScrollToRow(li_CurRow)
	This.PostEvent(Clicked!)
End If

end event

type cb_new from commandbutton within w_inspdetail
integer x = 55
integer y = 2464
integer width = 347
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New..."
end type

event clicked;Integer li_Comp
n_miredefault lnvo_mire

If g_obj.DeptID > 1 then   // Check if user is not from Vetting Dept
	MessageBox("Access Denied", "Your department does not have access to create a new item.", Exclamation!)
	Return
End If

li_Comp = dw_Insp.GetItemNumber(1, "Locked")

If li_Comp = 1 then   //  Check if report is closedout
	Messagebox("Access Denied", "The inspection has been closed-out. No further modifications are possible until the inspection is re-opened.",Exclamation!)
	Return
End If

SetPointer(HourGlass!)
g_obj.ObjString = ""
g_obj.ObjID = 0
g_obj.InspModel = dw_Insp.GetItemNumber(1, "ImID")
g_obj.InspId = dw_Insp.GetItemNumber(1, "Insp_ID")
g_obj.Param = dw_Insp.GetItemNumber(1, "ExtModel")
g_obj.Level = 10  //  Disable navigation buttons in w_itemdetail

Open(w_itemdetail)

If g_obj.ObjID > 0 then  // If new item was created
	dw_Items.Retrieve(g_obj.InspID)
	dw_Items.SetRow( dw_Items.GetRow())
	dw_Items.ScrollToRow( dw_Items.GetRow())
	cb_Edit.Enabled = True
	cb_Del.Enabled = True
	cb_ItemAtt.Enabled = True
	guo_Global.of_UpdateLastEdit(g_obj.InspID)
	dw_Insp.Retrieve(g_obj.InspID)
	ib_Modified = True
	// Find and select the new item
	li_Comp = dw_items.Find( "Item_ID = " + String(g_Obj.ObjID), 0, dw_Items.RowCount())
	g_obj.Level = 0  // To avoid scroll events
	If li_Comp > 0 then
		dw_Items.SetRow(li_Comp)
		dw_Items.ScrollTorow(li_Comp)
	End If	
End If

//Commit;

end event

type dw_items from datawindow within w_inspdetail
integer x = 55
integer y = 752
integer width = 3218
integer height = 1712
integer taborder = 110
string title = "none"
string dataobject = "d_sq_tb_items"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If (rowcount > 0) and (g_Obj.Access > 1) and (g_Obj.DeptID = 1) and Not ib_ReadOnly then
	cb_del.Enabled = True
	cb_Expcap.Enabled = True
Else
	cb_del.Enabled = False
	cb_Expcap.Enabled = False
End If	

If (rowcount > 0) then 
	cb_itematt.Enabled = True 
Else 
	cb_itematt.Enabled = False
	cb_Edit.Enabled = False
End If
end event

event buttonclicked;
If dwo.Tag = "G" then g_obj.Noteid = This.GetItemNumber( row, "guide") else g_obj.Noteid = This.GetItemNumber( row, "unote")

Open(w_note)
end event

event scrollvertical;
If g_obj.Level = 0 then This.SetRow(Integer(This.Object.Datawindow.FirstRowOnPage))

// Set row only if not auto-navigating
end event

event doubleclicked;

If (row > 0) and cb_edit.enabled then cb_edit.event clicked( )
end event

event clicked;
If dwo.name = "p_copyowncomm" then
	Clipboard(dw_Items.GetItemString(dw_Items.GetRow(), "owncomm"))
	cb_CopyComm.PostEvent(Clicked!)	
End If
end event

type cb_close from commandbutton within w_inspdetail
integer x = 1472
integer y = 2576
integer width = 402
integer height = 96
integer taborder = 190
integer textsize = -10
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

type cb_editinsp from commandbutton within w_inspdetail
integer x = 55
integer y = 560
integer width = 347
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Modify"
end type

event clicked;Integer li_Comp

li_Comp = dw_insp.GetItemNumber(1, "Locked")

If (li_Comp = 1) and (g_obj.Access < 2) then   //  Check if report is closed-out
	Messagebox("Access Denied", "This inspection report has been closed out. No further modifications are possible until it is re-opened.",Exclamation!)
	Return
End If

If li_Comp = 1 and g_obj.DeptId = 1 and g_Obj.Access > 1 then  //  If locked and user is Vetting RW/SU, confirm re-opening
	If Messagebox("Inspection Closed-Out", "This inspection report has been closed out. Do you want to re-open this inspection?",Question!, YesNo!) = 1 then
		
		Update VETT_INSP Set LOCKED = 0 Where INSP_ID = :g_Obj.InspID;		
		
		If SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", "Could not re-open inspection.~n~n" + SQLCA.SQLerrtext, Exclamation!)
			Rollback;
			Return
		Else
			Commit;
			dw_Insp.SetItem(1, "Locked", 0)
			guo_Global.of_AddInspHist(g_Obj.InspID, 10, '')
			guo_Global.of_UpdateLastEdit( g_Obj.InspID)
			If cb_SR.Visible Then cb_SR.Enabled = True
		End If	
	End If
End If

li_Comp = dw_insp.GetItemNumber(1, "Completed")

SetPointer (HourGlass!)

g_obj.objstring = "EditInsp"
g_obj.vesselimo = dw_insp.GetItemNumber(1, "Vesselimo")

open(w_newinsp)

If g_obj.vesselimo > 0 then dw_insp.Retrieve(g_obj.InspID)

g_obj.objstring = ""

Commit;
end event

type dw_insp from datawindow within w_inspdetail
integer x = 55
integer y = 96
integer width = 3218
integer height = 464
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_inspheader"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount > 0 then 
	cb_ViewAtt.Text = "View All Attachments (" + String(dw_insp.GetItemNumber(1, "AttCount")) + ")"
	cb_Super.Enabled = Not (dw_insp.GetItemNumber(1, "tech_review") = 1)
	
//	If Left(dw_insp.GetItemString(1, "modelname"), 4) <> "MIRE" then cb_Summ.Visible = False
// Above line restricts the use of Summary button only to MIRE inspections. Removed because of request from Vetting Dept.

End If

end event

event doubleclicked;
If (row>0) and cb_editinsp.Enabled then cb_editinsp.event clicked( )
end event

type gb_1 from groupbox within w_inspdetail
integer x = 18
integer y = 16
integer width = 3291
integer height = 640
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Header"
end type

type gb_2 from groupbox within w_inspdetail
integer x = 18
integer y = 672
integer width = 3291
integer height = 1888
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Items"
end type

