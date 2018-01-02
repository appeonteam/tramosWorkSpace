$PBExportHeader$poolcommissionposting.sra
$PBExportComments$Generated Application Object
forward
global type poolcommissionposting from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

uo_global_vars uo_global

// AtoBviaC Diatance table
n_AtoBviaC gnv_AtoBviaC

n_cst_appmanager gnv_app

n_service_manager 	inv_servicemanager
n_error_service 		inv_errservice

integer gi_win_pos = 0
integer gi_redraw
string s_w_list_return
Boolean gb_tram_calc_is_interfaced = True
Integer gb_bpsdists_usage = -1
Boolean gb_external_apm = false
Boolean gb_tc_payment = false


//long gl_starttime  /* Kun for test må godt slettes */
//long gl_time  /* Kun for test må godt slettes */
long gl_batch = 7000000

// BP Distancetable interface
u_bpdistance_base guo_bpdistance

 
Boolean gb_developer // True if developer=1 in inifile

string gs_load_or_disch

mt_n_datastore ids_ports, ids_country, ids_area
datawindowchild	idwc_open

end variables

global type poolcommissionposting from application
string appname = "poolcommissionposting"
event documentation ( )
end type
global poolcommissionposting poolcommissionposting

type prototypes
Function Int GetKeyState(Int aKey) Library "user.exe"
Function Long GetKeyState32(Long aKey) Library "user32.dll" Alias for "GetKeyState"
Function Long SetWindowPos(Long whandle, Long topmost, long x, long y, long cx, long cy, long wFlag) Library "user32.dll" Alias for "SetWindowPos"
public FUNCTION unsignedlong FindWindow_NT( long ClassName, string WindowName ) LIBRARY "user32.dll"  ALIAS FOR "FindWindowW"
public Function int SetForegroundWindow_NT( unsignedlong hwnd ) LIBRARY "user32.dll" ALIAS FOR "SetForegroundWindow"
Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"
FUNCTION ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath )  LIBRARY "KERNEL32.DLL"  ALIAS FOR "GetModuleFileNameA;ansi" 
end prototypes

forward prototypes
private function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage)
private function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, readonly boolean ab_showmessage)
end prototypes

event documentation();/********************************************************************
   poolcommissionposting: 
	
	<OBJECT>
		
	</OBJECT>
   <DESC>
		
	</DESC>
   	<USAGE>

	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	08/02/16		CR4298	AGL027			Add connection details into the code	
********************************************************************/
end event

private function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage);return _addMessage(apo_classdef , as_methodname, as_message, as_devmessage, TRUE )

end function

private function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, readonly boolean ab_showmessage);n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")

lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage )

if ab_showmessage then lnv_errService.of_showmessages( )

return c#return.success
end function

on poolcommissionposting.create
appname="poolcommissionposting"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on poolcommissionposting.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_app, ls_version="", ls_monitor_id, ls_logname

n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService
n_versioninfo			lnv_versioninfo
mt_n_stringfunctions	lnv_stringfunc
ls_logname = "emailnotificationservice.log"
string ls_commandline, ls_method = "poolcommissionposting.open()", ls_flagtext, ls_tempstr
long	ll_maxbalance

//ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /monitor_id:POOL /maxbalance:25 /logoutput:pool_[MMYYYY].log"
ls_commandline = commandline

lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)
if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

/* non critical configuration options from command line */
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logoutput:", ls_logname, false)

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_setoutput( 2, ls_logname )

lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/monitor_id:", ls_monitor_id, false)
//SQLCA.of_setmonitorid(ls_monitor_id)

lnv_errservice.of_addmsg( this.classdefinition, ls_method, "*************************", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, application started", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, version number=" + ls_version, "", 0, ls_monitor_id)

/* critical configuration options from command line which may prevent us from execution */
if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", SQLCA.ServerName, true) = c#return.Failure then
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error - missing server information", "", 0, ls_monitor_id)
	lnv_errservice.of_showmessages( )
	return
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", SQLCA.Database, true) = c#return.Failure then
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error - missing database information", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		return
	else
		if ls_monitor_id<>"" then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, monitor_id=" + upper(ls_monitor_id) , "", 0, ls_monitor_id)
		end if
		
		/* special parameter(s) for this application */
		string ls_maxbalance 
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/maxbalance:", ls_maxbalance, false)
		ll_maxbalance = long(ls_maxbalance)
		/* end of special parameter set */	
		
		SQLCA.DBMS 			= "SYC Sybase System 10"
		SQLCA.LogPass 		= "LKJHGFdsa!##"
		SQLCA.LogId 			= "adminServerApp"
		SQLCA.AutoCommit 	= False
		SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_poolcommissionposting' , Host='server_poolcommissionposting'"
		
		connect using SQLCA;
		
		if SQLCA.SQLCode <> 0 then	
			lnv_errService.of_addmsg(this.classdefinition , ls_method, "Error - unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext, 0, ls_monitor_id)	
			lnv_errService.of_showmessages( )
			destroy lnv_errService
			return
		end if

		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "OK", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )

		/* now do the work! */
		gnv_app = create n_cst_appmanager
		gnv_app.event pfc_Open(commandline)
		uo_global = create uo_global_vars
		uo_global.setwindowsuserid()
		uo_global.setuserid(sqlca.logid)
		// Create report object
		n_poolcommission lnv_poolcommission
		lnv_poolcommission = Create n_poolcommission
		lnv_poolcommission.of_run(ll_maxbalance)
		/* work ended */

		lnv_errservice.of_addmsg(this.classdefinition , ls_method, "Closing application", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		destroy lnv_poolcommission
	
	end if	
end if
end event

event close;disconnect using sqlca;
end event

