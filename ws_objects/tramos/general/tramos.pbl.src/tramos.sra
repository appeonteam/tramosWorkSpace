$PBExportHeader$tramos.sra
$PBExportComments$This is the tramos application.
forward
global type tramos from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
uo_global_vars uo_global
integer gi_win_pos = 0
integer gi_redraw
string s_w_list_return
Boolean gb_tram_calc_is_interfaced = True
Integer gb_bpsdists_usage = -1
Boolean gb_external_apm = false
Boolean gb_tc_payment = false

n_cst_appmanager gnv_app
//long gl_starttime  /* Kun for test må godt slettes */
//long gl_time  /* Kun for test må godt slettes */
long gl_batch = 7000000

// BP Distancetable interface
u_bpdistance_base guo_bpdistance

// AtoBviaC Diatance table
n_AtoBviaC gnv_AtoBviaC
 
Boolean gb_developer // True if developer=1 in inifile

string gs_load_or_disch

mt_n_datastore ids_ports, ids_country, ids_area
datawindowchild	idwc_open


end variables

global type tramos from application
string appname = "tramos"
end type
global tramos tramos

type prototypes
Function Int GetKeyState(Int aKey) Library "user.exe"
Function Long GetKeyState32(Long aKey) Library "user32.dll" Alias for "GetKeyState"
Function Long SetWindowPos(Long whandle, Long topmost, long x, long y, long cx, long cy, long wFlag) Library "user32.dll" Alias for "SetWindowPos"
public FUNCTION unsignedlong FindWindow_NT( long ClassName, string WindowName ) LIBRARY "user32.dll"  ALIAS FOR "FindWindowW"
public Function int SetForegroundWindow_NT( unsignedlong hwnd ) LIBRARY "user32.dll" ALIAS FOR "SetForegroundWindow"
Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"
FUNCTION ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath )  LIBRARY "KERNEL32.DLL"  ALIAS FOR "GetModuleFileNameA;ansi" 
end prototypes

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   n_object_name: tramos application object
	
	<OBJECT>
		Accepts the arguments passed in from command line and prepares the application
	</OBJECT>
   <DESC>
		
	</DESC>
   <USAGE>
		The initial object that is called when Tramos is executed
	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
	01/01/1996	--			--					First version??		 
	05/09/2016 	CR3754	AGL027			Single Sign On modifications - support Become User feature
	
********************************************************************/
end subroutine

event open;string 				ls_dbname
string				ls_commandline
s_login 				ls_login
mt_n_stringfunctions		lnv_stringfunc

gnv_app = CREATE n_cst_appmanager
// gnv_app.of_splash( 2 )
gnv_app.Event pfc_Open(commandline)


ls_commandline = commandLine

/* FYI - uncomment below line if you want to use SSO in PowerBuilder IDE */
// ls_commandline = "/server:ASETEST /db:TEST_TRAMOS /secure:DCRBTANDKBAL311@CRB.APMOLLER.NET"


uo_global = create uo_global_vars
uo_global.SetVessel_Nr(0)

lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/client:", uo_global.is_clienttype, false)
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", uo_global.is_database, false)
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", uo_global.is_servername, false)
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/secure:", uo_global.is_sec_server_principal, false)


uo_global.of_setappstartedfrom( )

ls_login.program_name = uo_global.is_program_name
ls_login.database_name = "SYC Sybase System 10"

// Perform Regional settings check
String ls_Decimal
If RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sDecimal", ls_Decimal) = 1 then
	If ls_Decimal <> "." then 
		If Messagebox("Check Regional Settings", "Tramos has determined that the regional settings being used on this computer may cause errors in the Calculation module.~n~nIt is strongly recommended that you change your computer's regional setting to English (U.K.) and restart Tramos.~n~nDo you want to continue starting Tramos?", Question!, YesNo!) = 2 then 
			Halt Close;
		End If
	End If
End If

// Set Userid = Maersk ID as default
uo_global.setWindowsUserid( )
uo_global.is_userid = UPPER(uo_global.getWindowsUserid())

OpenWithParm(w_Login,ls_Login)
ls_Login = Message.PowerObjectParm
    
If Not isValid(ls_login)  then 
	Halt CLOSE;
End if

If ls_Login.return_Userid = "" Then 
	Halt CLOSE;
End if

uo_global.uf_load()

COMMIT;

openWithParm (w_tramos_main, ls_login.program_name )


end event

event close;If IsValid(guo_bpdistance) Then DESTROY guo_bpdistance

gnv_app.Event pfc_Close( )
DESTROY n_cst_appmanager

if isValid(gnv_AtoBviaC) then 
	gnv_atobviac.of_closetables( )
	destroy gnv_AtoBviaC
end if

destroy uo_global

DISCONNECT USING SQLCA;
DESTROY SQLCA

end event

event systemerror;Open(w_system_error)

//gnv_app.Event pfc_SystemError( )
end event

on tramos.create
appname="tramos"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on tramos.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

