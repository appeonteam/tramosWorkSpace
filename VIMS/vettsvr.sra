HA$PBExportHeader$vettsvr.sra
$PBExportComments$Generated Application Object
forward
global type vettsvr from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

ustruct_obj g_Obj
uo_Global guo_Global

Integer ii_LogMode = 2
String gs_Incoming, gs_ImportPath, gs_ImportSuccess, gs_ImportReject
end variables

global type vettsvr from application
string appname = "vettsvr"
end type
global vettsvr vettsvr

type prototypes

Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"

Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"

Private Subroutine GetSystemTime(Ref ustruct_systime lpsystemtime) LIBRARY "KERNEL32.DLL";

end prototypes

type variables

String is_ExportPath

Long il_LockFile

Boolean ib_InterfaceActive
end variables

forward prototypes
private function integer f_createxml (long al_inspid)
public subroutine f_deleteitem (long al_itemid)
public subroutine f_exportinsp ()
private subroutine f_expcap ()
public subroutine f_checksirecaps ()
public subroutine f_checkreminders ()
end prototypes

private function integer f_createxml (long al_inspid);// Function to create XML export file for a single inspection
// Returns number CAPs exported, -1 for error and 0 if nothing exported

// Get inspection items to be exported
Datastore lds_CAP
ustruct_systime lstruct_UTC
DateTime ldt_Date
Integer li_Loop = 0
Long ll_TimeStamp, ll_ItemID

// Set inspection CAP status  (10=Exported)
Update VETT_INSP Set CAPEXPFLAG = 10 Where INSP_ID = :al_InspID;

If SQLCA.SQLCode < 0 then 
	If ii_LogMode>0 Then f_Log("CAP_Gen/CAPExpFlag update failed. Error - " + SQLCA.SQLErrText)
	Rollback;
End If

Commit;

// Retrieve data to export
lds_CAP = Create Datastore
lds_CAP.DataObject = "d_sq_tb_itemcapxml"
lds_CAP.SetTransObject(SQLCA)

If lds_CAP.Retrieve(al_InspID) < 0 then Return -1  // Error in retrieve
If lds_CAP.RowCount() = 0 then Return 0  // Nothing to export

Commit;

// Form XML filename (without extension)
String ls_FileName
ls_FileName = "Vims" + String(al_inspid) + "_" + String(Now(), "HHmmss")

// Populate Vessel comments for each row
String ls_VslComm
For li_Loop = 1 to lds_CAP.RowCount()
	ll_ItemID = lds_CAP.GetItemNumber(li_Loop, "Item_ID")
	Select Top 1 DATA Into :ls_VslComm From VETT_ITEMHIST Where ITEM_ID = :ll_ItemID Order By UTC Asc;
	If SQLCA.SQLCode = 0 then
		lds_CAP.SetItem(li_Loop, "VslComm", ls_VslComm)
	ElseIf SQLCA.SQLCode < 0 then
		If ii_LogMode>0 Then f_Log("Select for VslComm failed. Item_ID: " + String(ll_ItemID) + ", Error - " + SQLCA.SQLErrText)
	End If		
	Commit;
Next

//  Export XML
If lds_CAP.SaveAs(is_ExportPath + ls_FileName + ".xml", XML!, True) < 0 then Return -1

// Increment CAP count for appropriate CAPs (if exporting first time CAP_GEN is not incremented until confirmation is received)
Integer ai_CAPExpFlag
Select CAPEXPFLAG Into :ai_CAPExpFlag from VETT_INSP Where INSP_ID = :al_inspid;
Update VETT_ITEM Set CAP_GEN = (Case When IsNull(CAP_GEN, 0) = 0 Then 0 Else CAP_GEN + 1 End) 
Where (VETT_ITEM.INSP_ID = :al_InspID) and (IS_CAP = 1) and ((IsNull(CAP_GEN,0) = 0) Or (:ai_CAPExpFlag=1) Or (:ai_CAPExpFlag=11));

// Get UTC Time and Timestamp
GetSystemTime(lstruct_UTC)
ldt_Date = DateTime(Date(lstruct_UTC.wyear, lstruct_UTC.wmonth, lstruct_UTC.wday), Time(lstruct_UTC.whour, lstruct_UTC.wMinute, 0))	
ll_TimeStamp = f_GetTimeStamp()
	
// Add 'export' to each item's history
For li_Loop = 1 to lds_CAP.RowCount()
	ll_ItemID = lds_CAP.GetItemNumber(li_Loop, "Item_ID")
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :ll_ItemID, 0, 0, :ldt_Date, 'System', 'CAP exported to ShipNet');
Next

// Check if items are to be deleted
For li_Loop = 1 to lds_CAP.RowCount()
	If lds_CAP.GetItemNumber(li_Loop, "CAP_Status") = 10 then 
		f_DeleteItem(lds_CAP.GetItemNumber(li_Loop, "Item_ID"))
		If ii_LogMode=2 Then f_Log("Obs Deleted - ItemID=" + String(lds_CAP.GetItemNumber(li_Loop, "Item_ID")))
	End If
Next

// Return CAPs exported
Return lds_CAP.RowCount()

end function

public subroutine f_deleteitem (long al_itemid);
// This function deletes an observation that was marked for deletion after export to ShipNet

Delete from VETT_ATT Where ITEM_ID = :al_ItemID;
If SQLCA.SQLCode < 0 then 
	Rollback;
	Return
End If

Delete from VETT_ITEMHIST Where ITEM_ID = :al_ItemID;
If SQLCA.SQLCode < 0 then 
	Rollback;
	Return
End If

Delete from VETT_ITEM Where ITEM_ID = :al_ItemID;
If SQLCA.SQLCode < 0 then 
	Rollback;
	Return
End If

Commit;

Return
end subroutine

public subroutine f_exportinsp ();String ls_Email
Datastore lds_Insp
lds_Insp = Create Datastore
lds_Insp.DataObject = "d_sq_tb_inspexport"
lds_Insp.SetTransObject(SQLCA)

// If no insp flagged for export
If lds_Insp.Retrieve()<=0 then 
	If ii_LogMode=2 Then f_Log("No Inspections for Export")
	Return
End If

Integer li_Export, li_Counter
Long ll_InspID
String ls_Return
n_InspIO lnvo_InspExp

// Loop thru all
For li_Counter=1 to lds_Insp.RowCount()
	ll_InspID = lds_Insp.GetItemNumber(li_Counter, "Insp_ID")
	li_Export = lds_Insp.GetItemNumber(li_Counter, "Export")
	ls_Return = lnvo_InspExp.of_ExportInspection(ll_InspID, 0, g_Obj.TempFolder, g_Obj.TempFolder, li_Export - 1, "System", 2)
	If Right(ls_Return,5) = ".vpkg" then   // If export to file successful

		// Get vessel's email
		Select Top 1 VESSEL_EMAIL Into :ls_Email From VESSELS
		Inner Join VETT_INSP On VESSELIMO=IMO_NUMBER and VETT_TYPE Is Not Null and VESSEL_ACTIVE=1
		Where INSP_ID=:ll_InspID;
		
		Commit;
		
		// If no email
		If IsNull(ls_Email) Then 
			ls_Email = ""
			If ii_LogMode>0 then f_Log("Vessel Email not found for InspID " + String(ll_InspID))
		End If
		
		// Send to vessel
		ls_Return = guo_Global.of_SendMail2Vessel(ls_Email, "VIMS Inspection", g_Obj.TempFolder + ls_Return)
		
		If ls_Return="" Then
			If ii_LogMode = 2 Then f_Log("Export Success. InspID: " + String(ll_InspID))
			Update VETT_INSP Set EXPORT=0 Where INSP_ID=:ll_InspID;
			Commit;			
		Else
			If ii_LogMode>0 Then f_Log("SendMail2Vessel Failed: " + ls_Return)
		End If
		
		// Delete file
		FileDelete(g_Obj.TempFolder + ls_Return)
	Else
		If ii_LogMode>0 Then f_Log("of_ExportInspection Failed: " + ls_Return)	
	End If
Next




end subroutine

private subroutine f_expcap ();// This function checks for all inspections to be exported and exports them

// Get list of inspections to be exported
Datastore lds_Insp
Integer li_Ret, li_Loop
lds_Insp = Create Datastore
lds_Insp.DataObject = "d_sq_tb_inspcapexp"
lds_Insp.SetTransObject(SQLCA)
li_Ret = lds_Insp.Retrieve()

If li_Ret < 0 then
	if ii_LogMode>0 Then f_Log("!!! Retrieve Error in f_expinsp() !!!")
	Return
End If

If ii_LogMode=2 Then f_Log("Inspections for Export: " + String(li_Ret))

// Delete any existing XML files in the export folder
If li_Ret > 0 then Run('cmd /q /c del "' + is_ExportPath + '"*.xml', Minimized!)
	
// Run loop and export inspections
For li_Loop = 1 to lds_Insp.RowCount()
	li_Ret = f_CreateXML(lds_Insp.GetItemNumber(li_Loop, "Insp_ID"))
	If ii_LogMode=2 then f_Log("InspID " + String(lds_Insp.GetItemNumber(li_Loop, "Insp_ID")) + ", Exported " + String(li_Ret) + " CAP(s)")
Next

end subroutine

public subroutine f_checksirecaps ();// This function checks for SIRE Obs that are still open after three months and creates CAPS if they are.

Integer li_Obs, li_Loop
Long ll_InspID = 0, ll_ItemID, ll_TimeStamp
DateTime ldt_Date
ustruct_systime lstruct_UTC

Datastore lds_Obs
lds_Obs = Create Datastore

lds_Obs.DataObject="d_sq_tb_sirecaps"
lds_Obs.SetTransObject(SQLCA)

li_Obs = lds_Obs.Retrieve(90)   // 90 days (3 months)

If ii_LogMode>0 then f_Log("SIRE Obs Overdue found: " + String(li_Obs))

If li_Obs<1 then Return  // Nothing found or error

// Run loop to mark obs as CAPs and flag inspections for export
For li_Loop= 1 to li_Obs
	
	// Get UTC Time and Timestamp
	GetSystemTime(lstruct_UTC)
	ldt_Date = DateTime(Date(lstruct_UTC.wyear, lstruct_UTC.wmonth, lstruct_UTC.wday), Time(lstruct_UTC.whour, lstruct_UTC.wMinute, 0))	
	ll_TimeStamp = f_GetTimeStamp()
	
	// Set Obs as CAP
	ll_ItemID = lds_Obs.GetItemNumber(li_Loop, "Item_ID")
	Update VETT_ITEM Set IS_CAP=1 Where ITEM_ID=:ll_ItemID;
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA) Values(:ll_TimeStamp, :ll_ItemID, 0, 0, :ldt_Date, 'System', 'Observation flagged as CAP due to being open for 90 days.');
	Commit;
	
	// If InspID has changed, flag Insp for export
	If ll_InspID<>lds_Obs.GetItemNumber(li_Loop, "Insp_ID") Then
		ll_InspID = lds_Obs.GetItemNumber(li_Loop, "Insp_ID")
		
		// If inspection is not already flagged for export
		If lds_Obs.GetItemNumber(li_Loop, "CAPExpFlag")=0 or lds_Obs.GetItemNumber(li_Loop, "CAPExpFlag")=10 Then  
			Update VETT_INSP Set CAPEXPFLAG=CAPEXPFLAG+2 Where INSP_ID=:ll_InspID;
			Commit;
		End If
	End If
Next
end subroutine

public subroutine f_checkreminders ();// This function checks all inspection models that have reminders set
// and checks if any reminder emails need to be sent

Integer li_Rem
Datastore lds_Rem
lds_Rem = Create Datastore

lds_Rem.DataObject="d_sq_tb_reminders"
lds_Rem.SetTransObject(SQLCA)

li_Rem = lds_Rem.Retrieve()

If ii_LogMode>0 then f_Log("Upcoming Reminders: " + String(li_Rem))

lds_Rem.SetFilter("ToGo<=RemDays")
lds_Rem.Filter()
li_Rem = lds_Rem.RowCount()

If ii_LogMode>0 then f_Log("Reminders to Send: " + String(li_Rem))

uo_Global lGlobal

For li_Rem = 1 to lds_Rem.RowCount()
	lGlobal.of_SendInspReminder(lds_Rem.GetItemString(li_Rem,"VslName") , lds_Rem.GetItemString(li_Rem,"Vessel_Email"), lds_Rem.GetItemString(li_Rem,"DeptName"), lds_Rem.GetItemString(li_Rem,"DeptNote"), lds_Rem.GetItemString(li_Rem,"IMName"), Date(lds_Rem.GetItemDateTime(li_Rem,"LDate")), lds_Rem.GetItemNumber(li_Rem,"Interval"), lds_Rem.GetItemNumber(li_Rem,"ToGo"), lds_Rem.GetItemNumber(li_Rem,"Insp_ID"))
Next

Destroy lds_Rem
end subroutine

on vettsvr.create
appname="vettsvr"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on vettsvr.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;String ls_IniFile, ls_Temp

// Get app path and ini file
g_Obj.AppFolder = GetCurrentDirectory()
If Right(g_Obj.AppFolder, 1) <> "\" then g_Obj.AppFolder += "\"
ls_IniFile = GetCurrentDirectory()
If Right(ls_IniFile, 1) <> "\" then ls_IniFile += "\"
ls_IniFile += "vettsvr.ini"

// Get logging mode
ls_Temp = Trim(ProfileString(ls_IniFile, "Login", "LogMode", ""), True)
If IsNumber(ls_Temp) Then ii_LogMode = Mod(Integer(ls_Temp),4)
If ii_LogMode=2 then f_Log("----- App Started -----")

// Create/open lockfile (to prevent from running twice)
il_LockFile = FileOpen(g_Obj.AppFolder + "lock.dat", StreamMode!, Write!, LockReadWrite!, Replace!)
If il_LockFile < 0 then 
	If ii_LogMode>0 Then f_Log("Lock file failed. Cannot continue.")
	Return
End If

// Get paths from ini file
is_ExportPath = Trim(ProfileString(ls_IniFile, "Paths", "QExport", ""), True)
gs_ImportPath = Trim(ProfileString(ls_IniFile, "Paths", "QImport", ""), True)
gs_Incoming = Trim(ProfileString(ls_IniFile, "Paths", "Incoming", ""), True)
gs_ImportSuccess = Trim(ProfileString(ls_IniFile, "Paths", "QImportOk", ""), True)
gs_ImportReject = Trim(ProfileString(ls_IniFile, "Paths", "QImportErr", ""), True)

g_Obj.TempFolder = Trim(ProfileString(ls_IniFile, "Paths", "Temp", ""), True)
If is_ExportPath = "" or gs_ImportPath = "" or gs_Incoming = "" or g_Obj.TempFolder ="" then
	If ii_LogMode>0 then f_Log("One or more paths missing. Cannot continue.")
	Return
End If
If Right(is_ExportPath, 1) <> "\" then is_ExportPath += "\"
If Right(gs_ImportPath, 1) <> "\" then gs_ImportPath += "\"
If Right(gs_Incoming, 1) <> "\" then gs_Incoming += "\"
If Right(g_Obj.TempFolder, 1) <> "\" then g_Obj.TempFolder += "\"

// Clear temp folder
Run('cmd /Q /C del "' + g_Obj.TempFolder + '*.vpkg"', Minimized!)

// Get DB info and connect to database
SQLCA.DBMS = "SYC Adaptive Server Enterprise"
SQLCA.Database = ProfileString(ls_IniFile, "Database", "Database", "")
SQLCA.LogID = ProfileString(ls_IniFile, "Login", "UserID", "")
SQLCA.LogPass = ProfileString(ls_IniFile, "Login", "Password", "")
SQLCA.Servername = ProfileString(ls_IniFile, "Database", "Servername", "")
SQLCA.DBParm = ProfileString(ls_IniFile, "Database", "DBParm", "Release='15',UTF8=1")
SQLCA.Lock = ""
SQLCA.AutoCommit = false

Connect using SQLCA;

If SQLCA.SQLCode<>0 then
	If ii_LogMode>0 then f_Log("Database connection failed - " + SQLCA.SQLErrText)	
	Return
End If

SetNull(g_Obj.UserID)
SetNull(g_Obj.DeptID)

// Get status of interface
If f_Config("VSIF", ls_Temp, 0) = 0 then 
	If ls_Temp = "1" then ib_InterfaceActive = True
End If

If ib_InterfaceActive Then // If VIMS-ShipNet interface is active

	// Call CAP and Inspection import window
	Open(w_XmlImport)
	
	// Call CAP export function
	f_ExpCap()
End If

// Call Inspection Export function
f_ExportInsp( )

// Check SIRE overdue obs (only once a day at 4 am)
If Hour(Now())= 4 And Minute(Now())<15 then f_CheckSireCaps( )

// Check Inspection reminders to be sent (only once a day at 5 am)
If Hour(Now())= 5 And Minute(Now())<15 then f_CheckReminders( )

// Check SIRE overdue notifications
If Hour(Now())= 6 And Minute(Now())<15 Then guo_global.of_CheckSireDue()

// Check weekly on monday morning about red flag port reminders
If DayNumber(Today())=2 And Hour(Now())= 6 And Minute(Now())<15 Then guo_global.of_SendRedFlagPortsEmail( )

end event

event close;Integer li_Day

Disconnect using SQLCA;

// Close lock file
FileClose(il_LockFile)

// Delete log of 6 days ago
li_Day = DayNumber(Today()) + 1
If li_Day = 8 then li_Day = 1

FileDelete(g_Obj.AppFolder + "Logs\VettSvr" + String(li_Day) + ".log")

If ii_LogMode=2 Then f_Log("^^^^^ App Closed ^^^^^")

end event

