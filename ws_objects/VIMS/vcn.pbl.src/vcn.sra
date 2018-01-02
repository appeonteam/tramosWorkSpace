$PBExportHeader$vcn.sra
$PBExportComments$Generated Application Object
forward
global type vcn from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

String g_Compname, g_Appfolder
Boolean g_TestMode = false  // Change to True when testing in Dev environment

Long il_LockFile

end variables

global type vcn from application
string appname = "vcn"
end type
global vcn vcn

type prototypes

Private Function boolean GetComputerNameA(ref string cname,ref long nbuf) LIBRARY "Kernel32.dll" Alias For "GetComputerNameA;ansi"

end prototypes

on vcn.create
appname="vcn"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on vcn.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
Long ll_Buf, ll_Read

g_AppFolder = GetCurrentDirectory()
If Right(g_AppFolder, 1) <> "\" then g_AppFolder += "\"

// Open lockfile
il_LockFile = FileOpen(g_AppFolder + "vcnlock.dat", StreamMode!, Write!, LockReadWrite!, Replace!)

If il_LockFile < 0 then Return

// Determine computer name
ll_Buf = 50
g_compname = Space(ll_Buf)
GetComputerNameA(g_compname, ll_Buf)
g_Compname = Upper(Trim(g_Compname))

// Show startup details for test mode
If g_TestMode then Messagebox("VCN Startup - Test Mode", "Workstation Name: " + g_compname + "~n~nCreate LockFile: " + String(il_LockFile) + "~n~nStartup Folder: " + g_AppFolder )

Randomize(0)

// If maersk vessel computer or Brostrom server or test mode, then start vcn
If (Left(g_Compname, 2) = "PC") or (g_Compname = "SERVER") or (Pos(g_CompName,"RDS")>0) or (g_TestMode) then Open(w_vcn)


end event

event close;
FileClose(il_LockFile)

FileDelete(g_AppFolder + "vcnlock.dat")
end event

event systemerror;
FileClose(il_LockFile)

FileDelete(g_AppFolder + "vcnlock.dat")
end event

