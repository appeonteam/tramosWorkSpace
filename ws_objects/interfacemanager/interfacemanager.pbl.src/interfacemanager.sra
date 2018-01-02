$PBExportHeader$interfacemanager.sra
$PBExportComments$Generated Application Object
forward
global type interfacemanager from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string gs_servername, gs_databasename, gs_shutdownonerror="on", gs_mqsuuwsfilename = "MQSUUWS.bat", gs_emailto="" , gs_bmvm_mailto="", gs_security="", gs_vendor_mailto=""
boolean gb_showwindow = false
long gl_unit = 60
integer gi_loglevel = 1
string gs_appid=""


end variables

global type interfacemanager from application
string appname = "interfacemanager"
end type
global interfacemanager interfacemanager

type prototypes




end prototypes

forward prototypes
public subroutine documemtation ()
end prototypes

public subroutine documemtation ();/********************************************************************
   interfacemanager: 
	
	<OBJECT>
		Application object for general purpose interface application
	</OBJECT>
   <DESC>
		Most important interface here is the one between Tramos and AX
	</DESC>
   	<USAGE>

	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	25/10/16		CR3320	AGL027			Voyage Master Transaction Handling + SSO
	16/03/17		CR4603	AGL027			Vendor data interface with AX - Phase I of II
********************************************************************/
end subroutine

on interfacemanager.create
appname="interfacemanager"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on interfacemanager.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;/********************************************************************
  event open( /*string commandline */)
   <DESC>  Application Object.</DESC>
   <RETURN></RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  commandline: standard parameter</ARGS>
   <USAGE></USAGE>
	<HISTORY>
	25/06/2015     SSX014      CR3783   Added the monitor_id parameter
	25/10/2016		AGL027		CR3320	Voyage Master Transaction Management with SSO
	</HISTORY>
********************************************************************/


n_service_manager lnv_serviceManager
n_error_service lnv_errService
string ls_unit, ls_loglevel, ls_logname = "interfacemanager.log"
integer li_pos=0
string ls_servername, ls_databasename, ls_showwindow, ls_method = "interfacemanager.open()"
string ls_app, ls_version=""
string ls_monitor_id
long li_severity = 1

n_versioninfo lnv_versioninfo
mt_n_stringfunctions	lnv_stringfunc

string ls_commandline
ls_commandline = commandline


/*
ls_commandline = "/server:scrbtandkbal311 /db:DEV_CPH /log:3 /unit:10 /shutdownonerror:on /emailto:AGL027 /showwindow:on " + &
"/appid:AX /monitor_id:TIMAX /logname:CR4603_[YYYYMMDD].log /bmvm_mailto:AGL027 /vendor_mailto:AGL027 /security:DCRBTANDKBAL311@CRB.APMOLLER.NET" 
*/

/* get version detail */
lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)

if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

populateerror(555,"dummy")
ls_method = error.object + "::" + error.objectevent

/* change ls_logoutputfilename and use 2 or 3 strings instead */
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logname:", ls_logname, false)
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/monitor_id:", ls_monitor_id, false)
SQLCA.of_setmonitorid(ls_monitor_id)

/* set the error/logging output to a log file instead of a window */
lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_setoutput( 2, ls_logname)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "*************************", "", li_severity, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, application started", "", li_severity, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, version number=" + ls_version, "", li_severity, ls_monitor_id)


if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", gs_servername, true) = c#return.Failure then
	gs_servername = "error"
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "error, missing server information", "", li_severity, ls_monitor_id)
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", gs_databasename, true) = c#return.Failure then
		gs_databasename = "error"	
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "error, missing database information", "", li_severity, ls_monitor_id)
	else
		if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/security:", gs_security, true) = c#return.Failure then
			lnv_errservice.of_addmsg(this.classdefinition, ls_method, "error, missing database security information", "", li_severity, ls_monitor_id )
		else
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/log:", ls_loglevel, false)
	
			ls_loglevel = lower(ls_loglevel)
			CHOOSE CASE ls_loglevel
				CASE "1", "min", "minimal"
					gi_loglevel = 1
				CASE "2", "med", "medium"
					gi_loglevel = 2				
				CASE "3", "max", "maximum"
					gi_loglevel = 3				
				CASE ELSE
					ls_loglevel = "minimal"
					gi_loglevel = 1				
			END CHOOSE		
	
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/unit:", ls_unit, false)
			if ls_unit<>"" then gl_unit =  long(ls_unit)
		
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/shutdownonerror:", gs_shutdownonerror, false)
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/emailto:", gs_emailto, false)
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/bmvm_mailto:", gs_bmvm_mailto, false)
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/vendor_mailto:", gs_vendor_mailto, false)
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/showwindow:", ls_showwindow, false)
			
			CHOOSE CASE lower(ls_showwindow)
				CASE "on", "true", "1"
					gb_showwindow = true
				CASE ELSE
					gb_showwindow = false
			END CHOOSE
			
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/appid:", gs_appid, false)
			gs_emailto = upper(gs_emailto)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> server                       :" + gs_servername, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> database                     :" + gs_databasename, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> log mode                     :" + ls_loglevel, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> log name                     :" + ls_logname, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> units                        :" + string(gl_unit), "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> shutdown on error            :" + gs_shutdownonerror, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> email warnings to            :" + gs_emailto, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> BMVM: notifications to       :" + gs_bmvm_mailto, "", li_severity, ls_monitor_id)
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> VENDOR: notifications to     :" + gs_vendor_mailto, "", li_severity, ls_monitor_id)			
			if gs_appid<>"" then
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "CONFIG-> AppId                        :" + upper(gs_appid) , "", li_severity, ls_monitor_id)				
			end if
		end if
	end if
end if	

lnv_errservice.of_showmessages( )
destroy lnv_errservice
/* open the window */
openwithparm(w_interfacemanagertimer, ls_monitor_id)
end event

