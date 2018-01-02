$PBExportHeader$emailnotificationservice.sra
$PBExportComments$Generated Application Object
forward
global type emailnotificationservice from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type emailnotificationservice from application
string appname = "emailnotificationservice"
end type
global emailnotificationservice emailnotificationservice

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   emailnotificationservice: 
	
	<OBJECT>
		application
	</OBJECT>
   <DESC>
	EMAIL NOTIFICATION SERVICE
	Application object for automated email notifications.  Concerned with following items:
	 * Claim Actions
	 * Expired Certificates
	 * Task Duedate
	 * Timebar		
	</DESC>
   <USAGE>
		Server application, executed daily.
	</USAGE>
   <ALSO>
   Date   		Ref    	Author   		Comments
  	??/??/?? 	?      	RMO				First Version
	29/09/15		CR4145	XSZ004			Actions - Send email notifications only one time per user
	15/10/15		CR4145	AGL027			Standardize server application; remove ini file usage.
--------------------------------------------------------------------
	11/02/16		CR4298	AGL027			New app target called emailnotificationservice. Consolidate related apps 
	13/03/17		CR4365	KSH092			tchirecontract email move to this application
	</ALSO>
********************************************************************/
end subroutine

on emailnotificationservice.create
appname="emailnotificationservice"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on emailnotificationservice.destroy
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
n_emailnotifications lnv_notifications
ls_logname = "emailnotificationservice.log"
string ls_commandline, ls_method = "emailnotificationservice.open()", ls_flagtext
s_emailnotificationsettings	lstr_settings

//ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /monitor_id:SCNOTIF /actions:true /taskdue:true /timebar:true /expcert:true /expcertdays:3 /logoutput:emailnotifications_[YYYY].log"
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
SQLCA.of_setmonitorid(ls_monitor_id)

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
		lstr_settings.b_claim_actions_enabled = true
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/actions:", ls_flagtext, false)
		if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "mails: claim actions DISABLED", "info")
			lstr_settings.b_claim_actions_enabled = false
		end if	
		
		lstr_settings.b_expired_certs_enabled = true
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/expcert:", ls_flagtext, false)
		if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "mails: expired certificates DISABLED", "info")	
			lstr_settings.b_expired_certs_enabled = false
		else 
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/expcertdays:", ls_flagtext, false)
			if isnumber(ls_flagtext) then
				lstr_settings.l_expired_certs_days = long(ls_flagtext)
			else
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error - emailnotificationservice command line parameter expcertdays has to be a number", "--")
				return
			end if
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/expcerttest:", lstr_settings.s_expired_certs_testemail1, false)
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/expcerttest:", lstr_settings.s_expired_certs_testemail2, false)
		end if	

		lstr_settings.b_task_duedate_enabled = true
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/taskdue:", ls_flagtext, false)
		if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "mails: task due DISABLED", "info")
			lstr_settings.b_task_duedate_enabled = false
		end if	

		lstr_settings.b_timebar_enabled = true
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/timebar:", ls_flagtext, false)
		if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "update positions DISABLED", "info")
			lstr_settings.b_timebar_enabled = false
		end if	
		
		lstr_settings.b_tccontract_expired_enabled = true
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/tchire:", ls_flagtext, false)
		if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "mails: expired tchire DISABLED", "info")
			lstr_settings.b_tccontract_expired_enabled = false
		end if	
		
		/* end of special parameter set */	
		
		SQLCA.DBMS 			= "SYC Sybase System 10"
		SQLCA.LogPass 		= "LKJHGFdsa!##"
		SQLCA.LogId 			= "adminServerApp"
		SQLCA.AutoCommit 	= False
		SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_specialclaimsmonitor' , Host='server_specialclaimsmonitor'"
		

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
		lnv_notifications = create n_emailnotifications
		/* Time Bar */
		if lstr_settings.b_timebar_enabled then 
			if lnv_notifications.of_timebar_monitor( ) <> c#return.Failure then
				// no output needed
			else 	
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Failure, TimeBar monitor process failed", "", 0, ls_monitor_id)
			end if
			lnv_errservice.of_showmessages( )
		end if

		/* Task Duedate */
		if lstr_settings.b_task_duedate_enabled then 
			if lnv_notifications.of_task_duedate_monitor( ) <> c#return.Failure then
				// no output needed
			else
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Failure - Task Due Date process failed", "", 0, ls_monitor_id)
			end if
			lnv_errservice.of_showmessages( )
		end if

		/* Claim Actions */
		if lstr_settings.b_claim_actions_enabled then 
			if lnv_notifications.of_claims_actions( ) <> c#return.Failure then
				// no output needed
			else
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Failure - Claim Actions process failed", "", 0, ls_monitor_id)
			end if
			lnv_errservice.of_showmessages( )
		end if
		
		/* Expired Certificates */		
		if lstr_settings.b_expired_certs_enabled then 
			if lnv_notifications.of_expired_certificates(lstr_settings) <> c#return.Failure then
				// no output needed
			else
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Failure - Expired Cerificates process failed", "", 0, ls_monitor_id)
			end if	
			lnv_errservice.of_showmessages( )
		end if 
		
		/* TC Hire Expired */
		if lstr_settings.b_tccontract_expired_enabled then 
			if lnv_notifications.of_tccontract_expired( ) <> c#return.Failure then
				// no output needed
			else
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Failure - TC Hire Expired process failed", "", 0, ls_monitor_id)
			end if
			lnv_errservice.of_showmessages( )
		end if
		
		lnv_errservice.of_addmsg(this.classdefinition , ls_method, "Closing application", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		destroy lnv_errservice
		destroy lnv_notifications		
	
	end if	
end if


end event

event close;disconnect using SQLCA;
garbagecollect()
end event

