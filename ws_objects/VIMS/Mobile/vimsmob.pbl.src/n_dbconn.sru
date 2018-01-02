$PBExportHeader$n_dbconn.sru
forward
global type n_dbconn from nonvisualobject
end type
end forward

global type n_dbconn from nonvisualobject autoinstantiate
end type

type prototypes

end prototypes

type variables

String is_Server, is_Database, is_User, is_Pwd
String is_Import, is_Export

end variables

forward prototypes
public function integer connect2db ()
public function integer connect2server ()
public function integer getidentification ()
public function integer createdb (string as_path)
public function integer getdbver ()
public subroutine checkvessel (long al_imo, string as_name)
public subroutine initializesettings ()
public function integer savesettings ()
end prototypes

public function integer connect2db ();
// This routine attempts to switch to the VIMSDB database

SQLCA.DBMS = "OLE DB"
SQLCA.LogId = is_User
SQLCA.LogPass = is_Pwd
SQLCA.AutoCommit = False
SQLCA.DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + is_server + "',PROVIDERSTRING='Database=" + is_Database + "',Identity='SCOPE_IDENTITY()'"

Connect Using SQLCA;

If SQLCA.SQLCode < 0 then f_Write2Log("Connect2DB() Fail: " + SQLCA.SQLErrText)

Return SQLCA.SQLCode

end function

public function integer connect2server ();// This routine attempts to estabilish a connection to the Server

SQLCA.DBMS = "OLE DB"
SQLCA.AutoCommit = True
SQLCA.LogPass = is_Pwd
SQLCA.LogId = is_User
SQLCA.DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + is_server + "',Identity='SCOPE_IDENTITY()'"

// Try connecting
Connect Using SQLCA;
If SQLCA.SQLCode < 0 then 
	If SQLCA.SQLCode < 0 then f_Write2Log("Connect2Server() Fail: " + SQLCA.SQLErrText)
End If

Return SQLCA.SQLCode

end function

public function integer getidentification ();
String ls_Temp

If f_config("INST", ls_Temp, 0) < 0 then Return -1

If ls_Temp = "X" then 
	f_Write2Log("Installation not defined!")	
	Return -1
End If

If ls_Temp = "0" then   // Vessel Installation
	g_Obj.Install = 0
	If f_config("VIMO", ls_Temp, 0) < 0 then Return -1
	g_Obj.VesselIMO = Long(ls_Temp)
	If f_config("VLNM", ls_Temp, 0) < 0 then Return -1	
	g_Obj.VesselName = ls_Temp
	If f_config("VLNR", ls_Temp, 0) < 0 then Return -1	
	g_Obj.vesselNumber = ls_Temp	
	f_Write2Log("InstallType: " + string(g_Obj.Install) + "; IMO: " + string(g_Obj.VesselIMO) + "; Vessel: " + g_Obj.VesselNumber + " - " + g_Obj.VesselName)	
Else
	g_Obj.Install = 1     // Inspector Installation
	If f_config("INID", ls_Temp, 0) < 0 then Return -1
	g_Obj.Userid = ls_Temp
	If f_config("INFN", ls_Temp, 0) < 0 then Return -1	
	g_Obj.InspFirstname = ls_Temp
	If f_config("INLN", ls_Temp, 0) < 0 then Return -1	
	g_Obj.InspLastname = ls_Temp	
	f_Write2Log("InstallType: " + string(g_Obj.Install) + "; ID: " + g_Obj.UserID + "; Name: " + g_Obj.InspFirstName + " " + g_Obj.InspLastName)		
End If

Return 0
end function

public function integer createdb (string as_path);Integer li_Temp, li_Count, li_Err
String ls_SQL, ls_Create
Datastore lds_ddl
n_filepackage lnvo_pack

SetPointer(HourGlass!)

// Unpack DDL instructions
li_Temp = lnvo_pack.unpackfiles(g_Obj.AppFolder + 'vims_sq.vpkg', g_Obj.TempFolder)
If li_Temp < 0 then 
	Messagebox("File Error", "DDL instructions could not be unpacked.", Exclamation!)
	f_Write2Log("lnvo_pack.unpackfiles() Fail: " + String(li_Temp))
	Return li_Temp
End If

// Init DS
lds_ddl = Create Datastore
lds_ddl.DataObject = "d_sq_tb_sqlissue"

// Import instructions and delete file
li_Temp = lds_ddl.ImportFile(XML!, g_Obj.TempFolder + "vimsdb.vdbxp")
FileDelete(g_Obj.TempFolder + "vimsdb.vdbxp")
If li_Temp < 0 then 
	f_Write2Log("lds_ddl.ImportFile() Fail: " + String(li_Temp))
	Return li_Temp
End If

// Change to Master
Execute Immediate "Use Master";
If SQLCA.SQLCode < 0 then 
	f_Write2Log("SQL Fail: Use Master")
	Return -1
End If

// Create database
If is_Server = "MAERSKSERVER" then 
	ls_Create = "Create Database VIMSDB on Primary (Name='VIMSDB_Primary',Filename='E:\SQLDB\vimsdb.mdf',Size=100MB,FileGrowth=10MB)"
Else
	ls_Create = "Create Database VIMSDB"
End If
Execute Immediate :ls_Create;
If SQLCA.SQLCode < 0 then 
	Messagebox("DB Error", SQLCA.SQLErrtext, Exclamation!)
	f_Write2Log("SQL Fail: " + ls_Create + "; " + SQLCA.SQLErrText)
	Return -1
End If

// Change to VIMSDB
Execute Immediate "Use VIMSDB";
If SQLCA.SQLCode < 0 then 
	f_Write2Log("SQL Fail: Use VIMSDB")
	Return -1
End If

// Execute all DDL
For li_Count = 1 to li_Temp
	ls_SQL = lds_ddl.GetItemString(li_Count, "value")
	If li_Err = 0 then
		Execute Immediate :ls_SQL;
		li_Err = SQLCA.SQLCode 
	End If
Next

// Check for errors
If li_Err < 0 then 
	Messagebox("DB Error", SQLCA.SQLErrtext, Exclamation!)
	f_Write2Log("SQL Fail: " + SQLCA.SQLErrText)
	Execute Immediate "Use Master";
	Execute Immediate "Drop Database VIMSDB";
	If SQLCA.SQLCode < 0 then MessageBox("DB Error", "Unable to rollback database.~n~n" + SQLCA.SQLErrText, StopSign!)	
	Return -1	
End If

// All success
Return 0
end function

public function integer getdbver ();// This function checks the database version number and returns it. It returns -1 if it fails

String ls_Ver
Integer li_Ver

li_Ver = -1

If f_Config("DBVR", ls_Ver, 0) = 0 then
	If IsNull(ls_Ver) or (ls_Ver = '') then li_Ver = -1 else li_Ver = Integer(ls_Ver)
End If

f_Write2Log("DB Issue: " + String(ls_Ver))

Return li_Ver
end function

public subroutine checkvessel (long al_imo, string as_name);// This function checks if a vessel exists in the vessel table.
// If not, it creates the vessel as a temp 

Integer li_Temp

Select Count(*) Into :li_Temp from VESSELS Where IMO_NUMBER = :al_IMO;

If li_Temp=0 Then 
	Commit;
	Insert Into VESSELS (IMO_NUMBER, VESSEL_NAME, VESSEL_REF_NR, VESSEL_ACTIVE)	Values (:al_IMO, :as_Name, 'N/A', 1);
End If

Commit;
end subroutine

public subroutine initializesettings ();String ls_Compname, ls_Server, ls_Domain
Long ll_Buf, ll_Read
Integer li_Major, li_Minor
n_netapi ln_net
String ls_IniFile

// First, get workstation info
ln_net.of_netwkstagetinfo(ls_Compname, ls_Domain, li_Major, li_Minor)
f_Write2Log("NetWkStaGetInfo: " + ls_Compname + ", " + ls_Domain + ", " + String(li_Major) + "." + String(li_Minor))

ls_IniFile = g_Obj.AppFolder + "config.ini"

If FileExists(ls_IniFile) Then
  	f_Write2Log("Found " + ls_IniFile)
		is_Server = ProfileString(ls_IniFile,"DB","Server", "")
		is_Database = ProfileString(ls_IniFile,"DB","Database", "")
		is_User = ProfileString(ls_IniFile,"DB","User", "")
		is_Pwd = ProfileString(ls_IniFile,"DB","Password", "")
		is_Import = ProfileString(ls_iniFile,"Path","Import","")
		is_Export = ProfileString(ls_iniFile,"Path","Export","")
		Return
End If

f_Write2Log("Configuration File " + ls_IniFile + " not found.")
	
/* 
Settings not found. Reset to default and try to determine settings.
This function determines the server name based on the
computer name and also returns the compname 
*/

// Use computer as default server (for inspectors)
is_Server = ls_CompName
is_User = "sa"
is_Pwd = "gl8fvrk"
is_Database = "VimsDB"

// Determine if Maersk vessel
If Left(ls_Compname, 2) = "PC" then	is_Server = "MAERSKSERVER"

// Determine if Brostrom vessel
If Upper(ls_Domain) = "VESSEL" then	is_Server = "SERVER"

// Write info to log
f_Write2Log("Workstation: " + ls_Compname + ", Using Server: " + is_server)

// Check if server over-ride file present
If FileExists(g_Obj.Appfolder + "VM_Server.txt") then
	ll_Buf = FileOpen(g_Obj.AppFolder + "VM_Server.txt")
	If ll_Buf > 0 then
		If FileReadEx(ll_Buf, ls_Server)>0 then
			is_Server = Trim(ls_Server, True)
			f_Write2Log("VM_Server.txt found. Now using Server: " + is_Server)
		Else
			f_Write2Log("VM_Server.txt found. Could not read server name.")
		End If
		FileClose(ll_Buf)
	Else
		f_Write2Log("VM_Server.txt found. FileOpen() failed.")	
	End If
End If

// Choose correct password and comm folder
If is_Server = "MAERSKSERVER" then 
	is_Pwd = "gl8vf3rk"
	is_Import = "E:\Automail\VIMS\In\"
	is_Export = "E:\Automail\VIMS\Out\"
ElseIf is_Server = "SERVER" then 
	is_Pwd = "sapassword"
	is_Import = "G:\Automail\"
	is_Export = "G:\Automail\VIMS\Out\"
Else 
	is_Pwd = "sqlserver"
	is_Import = ""
	is_Export = ""
End If

// Check if password over-ride file present
String ls_PW
If FileExists(g_Obj.Appfolder + "sapw.txt") then
	ll_Buf = FileOpen(g_Obj.AppFolder + "sapw.txt")
	If ll_Buf > 0 then
		If FileReadEx(ll_Buf, ls_PW)>0 then
			is_Pwd = Trim(ls_PW)
			f_Write2Log("sapw.txt found. Using alternate password...")
		Else
			f_Write2Log("sapw.txt found. Could not read password!")
		End If
		FileClose(ll_Buf)
	Else
		f_Write2Log("sapw.txt found. FileOpen() failed.")	
	End If
End If

Return


end subroutine

public function integer savesettings ();string ls_ini = "config.ini"
int li_Temp

if Not FileExists(g_Obj.AppFolder + ls_ini) Then
	li_Temp = FileOpen(ls_ini, LineMode!, write!)
	If li_Temp < 0 Then Return -1
	FileClose(li_Temp)
End If

li_Temp = SetProfileString(ls_ini, "DB", "Server", is_Server)
If li_Temp < 0 Then Return li_Temp
li_Temp = SetProfileString(ls_ini, "DB", "Database", is_Database)
If li_Temp < 0 Then Return li_Temp
li_Temp = SetProfileString(ls_ini, "DB", "User", is_User) 
If li_Temp < 0 Then Return li_Temp
li_Temp = SetProfileString(ls_ini, "DB", "Password", is_Pwd) 
If li_Temp < 0 Then Return li_Temp
li_Temp = SetProfileString(ls_ini, "Path", "Import", is_Import) 
If li_Temp < 0 Then Return li_Temp
li_Temp = SetProfileString(ls_ini, "Path", "Export", is_Export) 
If li_Temp < 0 Then Return li_Temp

Return 1

end function

on n_dbconn.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dbconn.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

