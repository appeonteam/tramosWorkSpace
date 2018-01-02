HA$PBExportHeader$w_xmlimport.srw
forward
global type w_xmlimport from window
end type
type lb_files from listbox within w_xmlimport
end type
end forward

global type w_xmlimport from window
boolean visible = false
integer width = 745
integer height = 648
boolean titlebar = true
string title = "Import"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
lb_files lb_files
end type
global w_xmlimport w_xmlimport

type variables


Integer ii_TimeStampOffset = 0
end variables

forward prototypes
public function integer wf_importxml (string as_filename)
public subroutine wf_importinspections ()
public subroutine wf_main ()
protected function integer wf_importcap (long al_itemid, long al_recordid, string as_action, datetime adt_expdate, string as_expby, string as_closed, integer ai_risk, string as_comments)
end prototypes

public function integer wf_importxml (string as_filename);// This function imports CAP updates from an XML file
// Returns number of CAPS imported or -1 for error

If ii_LogMode=2 Then f_Log("Importing " + as_FileName)

// Setup datastore
Datastore lds_Import
lds_Import = Create DataStore
lds_Import.DataObject = "d_ext_tb_capimport"

Integer li_Ret, li_Loop, li_Temp, li_Risk
Long ll_ItemID

// Import from XML file
li_Ret = lds_Import.Importfile(XML!, gs_importPath + as_FileName)
If li_Ret<0 then
	If ii_LogMode > 0 Then f_Log("ImportFile() returned " + String(li_Ret))
	If gs_importReject > "" Then FileMove(gs_importPath + as_FileName, gs_importReject + as_FileName) Else FileDelete(gs_importPath + as_FileName)
	Return -1
End If

// If no rows
If li_Ret = 0 then
	If ii_LogMode > 0 Then f_Log("Rows Imported: " + String(li_Ret))
	If gs_ImportReject > "" Then FileMove(gs_importPath + as_FileName, gs_importReject + as_FileName) Else FileDelete(gs_importPath + as_FileName)	
	Return 0
End If

// Restore CR/LF (bug in PB)
f_Restore_CR_After_XML_Import(lds_Import, "Comments")

// Loop thru and update each row
For li_Loop = 1 to li_Ret
	SetNull(li_Risk)
	ll_ItemID = lds_Import.GetItemNumber(li_Loop, "CAPID")
	Select Count(ITEM_ID) Into :li_Temp from VETT_ITEM Where ITEM_ID = :ll_ItemID;  // Check if ItemID exists
	Commit;
	If li_Temp = 1 then
		Choose Case Upper(lds_Import.GetItemString(li_Loop, "Risk"))
			Case "LOW"
				li_Risk = 0
			Case "MEDIUM"
				li_Risk = 1
			Case "HIGH"
				li_Risk = 2
		End Choose
	    li_Temp = wf_ImportCAP(ll_ItemID, lds_Import.GetItemNumber(li_Loop, "RecordID"), lds_Import.GetItemString(li_Loop, "Action"), lds_Import.GetItemDateTime(li_Loop, "CreatedDate"), lds_Import.GetItemString(li_Loop, "ExpBy"), Upper(lds_Import.GetItemString(li_Loop, "Closed")),li_Risk,lds_Import.GetItemString(li_Loop, "Comments"))
        If ii_LogMode = 2 Then f_Log("CAP #" + String(li_Loop) + ": ItemID " + String(ll_ItemID) + ", wf_ImportCAP() returned " + String(li_Temp))
	Else
		If ii_LogMode > 0 Then f_Log("CAP #" + String(li_Loop) + ": ItemID " + String(ll_ItemID) + " not found")
	End If
Next

If gs_ImportSuccess > "" Then FileMove(gs_importPath + as_FileName, gs_ImportSuccess + as_FileName) Else FileDelete(gs_importPath + as_FileName)

Return li_Ret
end function

public subroutine wf_importinspections ();n_inspio lnvo_insp
Integer li_Total, li_Count, li_MsgType
Long ll_InspID
String ls_id, ls_Ver, ls_Info
Boolean lbool_New

li_Total = lb_Files.TotalItems()   // total number of incoming files

If ii_LogMode=2 Then f_Log("Incoming Files: " + String(li_Total))

If li_Total = 0 then Return

For li_Count = 1 to li_Total  // loop thru files
	If ii_LogMode=2 Then f_Log("Processing " + lb_Files.Text(li_Count))
    // Check for communication package or ping response	
	If (Upper(Left(lb_Files.Text(li_Count),7)) = "COMMPKG") or (Upper(Left(lb_Files.Text(li_Count),8)) = "PINGRESP") then
		guo_Global.of_ProcessCommPackage(gs_Incoming + lb_Files.Text(li_Count))
	ElseIf Lower(Right(lb_Files.Text(li_Count),5))=".vpkg" Then		  // otherwise handle inspection
		ll_InspID = lnvo_insp.of_ImportIntoOffice(gs_Incoming, lb_Files.Text(li_Count), g_Obj.TempFolder, li_MsgType, ls_ID, ls_Ver, ls_Info, lbool_New)
		If ii_LogMode=2 Then f_Log("InspID: " + String(ll_InspID))
		If ll_InspID > 0 then  // If import successful
			guo_Global.of_AddInspHist(ll_InspID, 1, "")
			guo_Global.of_AddSysMsg(li_MsgType, ls_ID, ls_Ver, ls_Info, ll_InspID, "")
			If ii_LogMode=2 Then f_Log("IsNew: " + String(lbool_New))
			If lbool_New then  // If new inspection being imported
				guo_Global.of_SendMail2Tech(ll_InspID)
				guo_Global.of_NotifyManagement(ll_InspID, 0, ls_Info)
				guo_Global.of_CheckMIREObs(ll_InspID)
			End If
		Else
			guo_Global.of_AddSysMsg(1, ls_ID, ls_Ver, ls_Info, 0, "")
			If ii_LogMode > 0 Then f_Log("Import Failed: " + ls_Info)
		End If
	Else
		If ii_LogMode>0 Then f_Log("Invalid Package: " + lb_Files.Text(li_Count))
	End If
	If ii_LogMode=2 Then f_Log("Completed")
Next
end subroutine

public subroutine wf_main ();Datastore lds_Rem


// Get XML files in Q import folder
lb_Files.DirList(gs_ImportPath + "*.xml", 0)
ChangeDirectory(g_Obj.AppFolder)

If ii_LogMode=2 Then f_Log("Incoming XML Files: " + String(lb_Files.TotalItems()))

// Process each file
Integer li_Loop
For li_Loop = 1 to lb_Files.TotalItems()
	wf_ImportXML(lb_Files.Text(li_Loop))
Next

// Get Incoming packages
lb_files.Reset()
lb_files.Dirlist(gs_Incoming + "*.vpkg", 0)
ChangeDirectory(g_obj.Appfolder)
wf_ImportInspections( )

// Send out reminder to tech supers for unreviewed inspections
lds_Rem = Create DataStore
lds_Rem.DataObject = "d_sq_tb_techreminder"
lds_Rem.SetTransObject(SQLCA)
If lds_Rem.Retrieve(7) > 0 then   // Get inspections with reminders sent more than 7 days ago
	If ii_LogMode=2 Then f_Log("Reminders to Supers: " + String(lds_Rem.RowCount()))
	For li_Loop = 1 to lds_Rem.RowCount()
		guo_Global.of_SendMail2Tech(lds_Rem.GetItemNumber(li_Loop, "Insp_ID"))
	Next
End If

Close(This)
end subroutine

protected function integer wf_importcap (long al_itemid, long al_recordid, string as_action, datetime adt_expdate, string as_expby, string as_closed, integer ai_risk, string as_comments);// This procedure imports a single CAP record into the Item History table.
// It also closes the CAP if required.  

// Return 1 for success, 0 for ignored (RecordID is older) and -1 for fail

// First get RecordID of Obs  
Long ll_RecordID = 0, ll_TimeStamp
Select CAP_RECORDID Into :ll_RecordID from VETT_ITEM Where ITEM_ID = :al_ItemID;
Commit;

// Record already processed. Ignore.
If ll_RecordID >= al_RecordID then Return 0  

// Set timestamp
ll_TimeStamp = f_GetTimeStamp() + ii_TimeStampOffset
ii_TimeStampOffset += 1

// Try to get the user's name
String ls_UserName
Select FIRST_NAME + ' ' + LAST_NAME Into :ls_UserName From USERS Where USERID = :as_ExpBy;
If SQLCA.SQLCode <> 0 then ls_UserName = as_ExpBy
ls_UserName += " (via ShipNet)"

// If CAP is being closed out
If Upper(Left(as_Comments, 9)) = "COMPLETED" then
	Update VETT_ITEM Set CLOSED = 1, CLOSEDATE = :adt_ExpDate Where ITEM_ID = :al_ItemID;
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :al_ItemID, 0, 0, :adt_ExpDate, :ls_UserName, 'CAP Closed Out on ShipNet.');
ElseIf Upper(as_Action) = "ACCEPTED" then  // If confirmation mail
	Update VETT_ITEM Set CAP_GEN = (Case When IsNull(CAP_GEN,0) = 0 Then 1 Else CAP_GEN End) Where ITEM_ID = :al_ItemID;
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :al_ItemID, 0, 0, :adt_ExpDate, 'System', 'ShipNet acknowledged CAP creation.');
ElseIf Upper(as_Action) = "REJECTED" then  // If rejection mail
	Update VETT_ITEM Set CAP_GEN = 0 Where ITEM_ID = :al_ItemID;
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :al_ItemID, 0, 0, :adt_ExpDate, 'System', 'ShipNet rejected CAP.');
Else  // Other type with regular comments
	// Update risk
	If Not IsNull(ai_Risk) then
		Update VETT_ITEM Set RISK = :ai_Risk Where ITEM_ID = :al_ItemID;
	End If
	If IsNull(as_Comments) then as_Comments = "< No comments received >"
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :al_ItemID, 0, 0, :adt_ExpDate, :ls_UserName, :as_Comments);
End If

If SQLCA.SQLCode = -1 then
	f_Log("wf_ImportCAP() SQL failed: " + SQLCA.SQLErrText)
	Rollback;
	Return -1
End If

Commit;		
	
Return 1
end function

on w_xmlimport.create
this.lb_files=create lb_files
this.Control[]={this.lb_files}
end on

on w_xmlimport.destroy
destroy(this.lb_files)
end on

event close;
If ii_LogMode=2 Then f_Log("Closing w_xmlimport")
end event

event open;
Post wf_Main()
end event

type lb_files from listbox within w_xmlimport
integer x = 37
integer y = 32
integer width = 658
integer height = 496
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

