$PBExportHeader$vimsmob.sra
$PBExportComments$Generated Application Object
forward
global type vimsmob from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

struct_global g_Obj
n_DBConn g_DB
Boolean g_TestMode = False
end variables

global type vimsmob from application
string appname = "vimsmob"
end type
global vimsmob vimsmob

type prototypes
Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"

Private Function Long CreateMutex(long lpMutexAttributes, long bInitialOwner, String lpName) LIBRARY "Kernel32.dll" Alias For "CreateMutexA;ansi"

Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"


end prototypes

type variables

Long il_LockFile
end variables

on vimsmob.create
appname="vimsmob"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on vimsmob.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
// Init all app level parameters
g_Obj.AppVer = "01.07.02"
g_Obj.Appbuilt = "22nd Nov 2016"
g_Obj.MinDBVer = 18    // Minimum DB Issue required for this version of VM
g_Obj.Footer = "Maersk Tankers A/S – Vetting and Inspection Management System"
g_Obj.AppFolder = GetCurrentDirectory()
g_Obj.Is_VM = True
g_Obj.Logging = True
//Open(w_Log)   // Use only for debugging
If Right(g_Obj.AppFolder, 1) <> "\" then g_Obj.AppFolder += "\"
Randomize(0)

// Open lockfile (to prevent VM from running twice)
il_LockFile = FileOpen(g_Obj.AppFolder + "vmlock.dat", StreamMode!, Write!, LockReadWrite!, Replace!)
If il_LockFile < 0 then 
	Messagebox("VIMS Mobile", "VIMS Mobile is already running!")
	Return
End If

// Init Temp folder
g_Obj.TempFolder = g_Obj.AppFolder
If DirectoryExists(g_Obj.Appfolder + "Temp") then
	g_Obj.TempFolder += "Temp\"
Else
	If CreateDirectory(g_Obj.Appfolder + "Temp") = 1 then
		g_Obj.TempFolder += "Temp\"
	Else
		Messagebox("VIMS Mobile", "Unable to create a temporary folder.")
		f_Write2Log("Unable to create " + g_Obj.Appfolder + "Temp")
		Return
	End If
End If

// Empty Temp folder and clear app folder of any vdbxp files
Run('cmd /Q /C del "' + g_Obj.TempFolder + 't*.*"', Minimized!)
Run('cmd /Q /C del "' + g_Obj.TempFolder + '*.vbdxp"', Minimized!)
Run('cmd /Q /C del "' + g_Obj.AppFolder + '*.vbdxp"', Minimized!)

f_Write2Log("Application Started - " + g_Obj.Appver + "; " + String(Today(), "dd mmm yyyy"))
f_Write2Log("App Startup - " + g_Obj.AppFolder)
f_Write2Log("App Tempdir - " + g_Obj.TempFolder)

Open(w_splash)


end event

event close;Integer li_Day, li_Today

f_Write2Log("=========== Application Terminated ===========")	

Disconnect using SQLCA;

// Empty Temp folder
Run('cmd /Q /C del "' + g_Obj.TempFolder + 't*.*"', Minimized!)
Run('cmd /Q /C del "' + g_Obj.TempFolder + '*.vbdxp"', Minimized!)

// Delete logs more than 10 days old
li_Today = Day(Today()) 
li_Day = li_Today - 10
If li_Day < 1 then li_Day += 31

Do
	FileDelete("Logs\vm" + string(li_Day, "00") + ".log")
	li_Day --
	If li_Day = 0 then li_Day = 31
Loop Until li_Day = li_Today

FileClose(il_LockFile)

FileDelete(g_Obj.AppFolder + "vcnlock.dat")
end event

event systemerror;
f_Write2Log("!!!! System Error > " + Error.Text)

f_CreateCommPackage("ERRR" + String(g_Obj.VesselIMO), Error.Text)

Messagebox("System Error", "VIMS Mobile Client~n~nThe application has encountered a serious error and will be shut down.~n~nError: " + Error.Text, StopSign!)

Halt Close

Disconnect Using SQLCA;




end event

