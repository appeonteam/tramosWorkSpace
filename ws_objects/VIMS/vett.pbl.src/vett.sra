$PBExportHeader$vett.sra
$PBExportComments$Generated Application Object
forward
global type vett from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

String gs_fullname, gs_tag

ustruct_obj g_obj

uo_Global guo_Global
end variables

global type vett from application
string appname = "vett"
string displayname = "Vetting and Inspection Management System"
end type
global vett vett

type prototypes

Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"

Private Function Long CreateMutex(long lpMutexAttributes, long bInitialOwner, String lpName) LIBRARY "Kernel32.dll" Alias For "CreateMutexA;ansi"

Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"

Private Subroutine GetSystemTime(Ref ustruct_systime lpsystemtime) LIBRARY "KERNEL32.DLL";
end prototypes

forward prototypes
public function integer settempfolder (string as_path)
end prototypes

public function integer settempfolder (string as_path);// Checks if as_Path can be used as a Temp folder
// Returns 1 for success and -1 for failuer

If Right(as_Path, 1) <> "\" then as_Path += "\"

f_Write2Log("Testing " + as_Path + " as temp folder")

// Check if folder exists, if not create it
If Not DirectoryExists(as_Path) then
	If CreateDirectory(as_Path) < 1 then // if temp directory fails
		f_Write2Log("CreateDirectory on " + as_Path + " failed.")
		Return -1
	End If		
End If

// Try to write a temp file
Long il_TestFile
il_TestFile = FileOpen(as_Path + "test.dat", StreamMode!, Write!, LockReadWrite!, Replace!)
If il_TestFile = -1 then
	f_Write2Log("FileOpen on " + as_Path + " failed.")
	Return -1
End If

FileClose(il_TestFile)
FileDelete(as_Path + "test.dat")

g_Obj.TempFolder = as_Path

Return 1
end function

on vett.create
appname="vett"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on vett.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;String ls_Ver

g_Obj.AppVersion = "03.12.01"    // Always use double digits to store version number
g_Obj.AppBuild = "6th Jun 2017"
g_Obj.Is_VM = False    // This is NOT VIMS Mobile
g_Obj.Logging = False   // Disable logging by default

Randomize(0)

// Check if VIMS is already running
If CreateMutex(0,0,"VIMS_Mutex")<0 then 
	Messagebox("VIMS Startup", "VIMS is already running on this computer!",Exclamation!)
	Return
End If

// Init app folders
g_Obj.AppFolder = GetCurrentDirectory()
If Right(g_Obj.AppFolder, 1) <> "\" then g_Obj.AppFolder += "\"

Open(w_login)

If g_Obj.UserID = "" then Return   // Exit if no login

// Check if logging is enabled
f_Config("VLOG", ls_Ver, 0)
If ls_Ver = "1" Then g_Obj.Logging = True

// If user is developer, then set variable
If g_Obj.UserID = "CONASW" or g_Obj.UserID = "AGL027" then g_Obj.Developer = True
If g_Obj.Developer then Open(w_Log)

// Success on login
f_Write2Log("----- Login Successful -----")
f_Write2Log("App Folder: " + g_Obj.AppFolder)

// Check and set Temp folders
String ls_Drive
Integer li_Set
ls_Drive = Upper(Left(g_Obj.AppFolder,1))
Choose Case ls_Drive
	Case "C"  // Running from C: drive
		li_Set = SetTempFolder(g_Obj.AppFolder + "Temp" + String(Rand(9999)))
		If li_Set = -1 Then li_Set = SetTempFolder("J:\VIMS_Temp" + String(Rand(99999)))
		If li_Set = -1 Then li_Set = SetTempFolder("\\shdofildkbal810\Vol1\Tramos\TempTramos\" + g_Obj.UserID)
	Case "G", "P", "J"
		li_Set = SetTempFolder("J:\VIMS_Temp" + String(Rand(99999)))
		If li_Set = -1 Then li_Set = SetTempFolder("P:\Tramos\TempTramos\" + g_Obj.UserID)
	Case "T"
		li_Set = SetTempFolder("J:\VIMS_Temp" + String(Rand(99999)))
		If li_Set = -1 Then li_Set = SetTempFolder("T:\TempTramos\" + g_Obj.UserID)
End Choose

If li_Set = -1 Then 
	f_Write2Log("No Temp Folder!")
	Messagebox("Temp Folder Error", "VIMS could not create a temporary working folder. Certain features will be disabled.", Exclamation!)
	g_Obj.TempFolder = ""
Else
	f_Write2Log("Temp Folder: " + g_Obj.TempFolder)	
End If

// Load Insp due date intervals
f_Config("IDRD", ls_Ver, 0)
If ls_Ver = "" then ls_Ver = "0"
g_Obj.DueRed = Integer(ls_Ver)
f_Config("IDYL", ls_Ver, 0)
If ls_Ver = "" then ls_Ver = "-1"
g_Obj.DueYellow = Integer(ls_Ver)

Open(w_Main)


end event

event systemerror;
guo_Global.of_AddSysMsg(6, g_Obj.UserID, g_Obj.AppVersion, "!!! System Error: " + Error.Text, 0, "")

Messagebox("System Error", "A critical system error occurred and has been logged.~n~nError: " + Error.Text, StopSign!)
end event

event close;
// Delete acknowledged system messages older than a year
Delete from VETT_SYSMSG Where (dateadd(mm, 12, MSGTIME) < getdate()) and ACK=1;
Commit;

// Delete temp folder and all files in it
If g_Obj.TempFolder> "" and g_Obj.Tempfolder <> g_Obj.AppFolder then Run('cmd /Q /C rmdir /S /Q "' + g_Obj.Tempfolder + '"', Minimized!)

f_Write2Log("----- Application Terminated -----")
end event

