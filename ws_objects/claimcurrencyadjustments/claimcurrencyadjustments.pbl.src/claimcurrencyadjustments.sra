$PBExportHeader$claimcurrencyadjustments.sra
$PBExportComments$Generated Application Object
forward
global type claimcurrencyadjustments from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type claimcurrencyadjustments from application
string appname = "claimcurrencyadjustments"
end type
global claimcurrencyadjustments claimcurrencyadjustments

on claimcurrencyadjustments.create
appname="claimcurrencyadjustments"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on claimcurrencyadjustments.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;/********************************************************************
claimcurrencyadjuments.open ( /*string commandline*/ ) 

<DESC>
	CLAIM CURRENCY ADJUSTMENTS
	- Application object for claimcurrencyadjustments application.
	This application is necessary as multi-currency possibilities within Tramos
	were only supported when Brostrom was integratted inside MT.  As MT report in USD
	but local currency is used throughout the system otherwise we must adjust USD currency 
	rates on open claims.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	String commandline: DB parameters & some config settings are passed in from the command line.
</ARGS>
<USAGE>
	Server application, executed daily.
</USAGE>
<ALSO>
    	Date   	Ref    	Author   		Comments
  	??/??/?? 	?      	AGL027			First Version
	29/09/15		CR3778	CCY018			
	15/10/15		CR3778	AGL027			Standardize server application; remove ini file usage.
</ALSO>
********************************************************************/

string ls_app, ls_version="", ls_monitor_id, ls_logname, ls_debug
boolean lb_debug = false


n_service_manager 	lnv_servicemanager
n_error_service		lnv_errService
n_versioninfo			lnv_versioninfo
mt_n_stringfunctions	lnv_stringfunc
n_adjustgenerator		lnv_adjust
ls_logname = "claimcurrencyadjustments.log"
string ls_commandline, ls_method = "claimcurrencyadjustments.open()"

//ls_commandline = "/server:scrbtradkcph101 /db:DEV_CPH /monitor_id:CCADJ /logoutput:CR3778_[MM].log /d_e_b_u_g:enabled"
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

lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/d_e_b_u_g:", ls_debug, false)
if ls_debug="1" or lower(ls_debug)="enabled" or lower(ls_debug)="true" then
	lb_debug = true
end if

lnv_errservice.of_addmsg( this.classdefinition, ls_method, "*************************", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, application started", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, version number=" + ls_version, "", 0, ls_monitor_id)

/* critical configuration options from command line which may prevent us from execution */
if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", SQLCA.ServerName, true) = c#return.Failure then
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing server information", "", 0, ls_monitor_id)
	lnv_errservice.of_showmessages( )
	return
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", SQLCA.Database, true) = c#return.Failure then
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing database information", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		return
	else
		if ls_monitor_id<>"" then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, monitor_id=" + upper(ls_monitor_id) , "", 0, ls_monitor_id)
		end if
				
		SQLCA.DBMS 			= "SYC Sybase System 10"
		SQLCA.LogPass 		= "LKJHGFdsa!##"
		SQLCA.LogId 			= "adminServerApp"
		SQLCA.AutoCommit 	= False
		SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_specialclaimsmonitor' , Host='server_specialclaimsmonitor'"
		
		connect using SQLCA;
		
		if SQLCA.SQLCode <> 0 then	
			lnv_errService.of_addmsg(this.classdefinition , "open", "Error, unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext, 0, ls_monitor_id)	
			lnv_errService.of_showmessages( )
			destroy lnv_errService
			return
		end if
		if lb_debug then
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, d_e_b_u_g=enabled","")
		end if
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "OK", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )

		/* now do the work! */
		lnv_adjust = create n_adjustgenerator
		lnv_adjust.of_setdebugmode(lb_debug)
		lnv_adjust.of_main()
		/* close this window and application */
		lnv_errservice.of_addmsg(this.classdefinition , "open", "Success.  Closing application", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		destroy lnv_adjust
		destroy lnv_errservice
	
	end if	
end if


end event

event close;disconnect using sqlca;
garbagecollect()
end event

