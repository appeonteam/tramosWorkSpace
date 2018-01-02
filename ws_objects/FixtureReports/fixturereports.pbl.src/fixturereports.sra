$PBExportHeader$fixturereports.sra
$PBExportComments$Generated Application Object
forward
global type fixturereports from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type fixturereports from application
string appname = "fixturereports"
end type
global fixturereports fixturereports

type prototypes
Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"
end prototypes

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   n_object_name: fixturereports
	
	<OBJECT>

	</OBJECT>
   <DESC>
		daily scheduled task that generates PDF snapshot report of calculation fixture data
		from the fixture/position list
	</DESC>
  	<USAGE>
		
	</USAGE>
   <ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	10/02/16		CR4298	AGL027			Standardize server app.  
********************************************************************/
end subroutine

on fixturereports.create
appname="fixturereports"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on fixturereports.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_app, ls_version="", ls_monitor_id, ls_logname
integer li_daynumber

n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService
n_versioninfo			lnv_versioninfo
mt_n_stringfunctions	lnv_stringfunc
n_fixturereport 		lnv_fix
ls_logname = 			"fixturereports.log"

string ls_commandline, ls_pdfdriver, ls_method = "fixturereports.open()"

//ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /monitor_id:FIXRPT /logoutput:fixturereports.log /pdfdriver:CutePDF Writer"
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
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing server information", "", 0, ls_monitor_id)
	lnv_errservice.of_showmessages( )
	return
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", SQLCA.Database, true) = c#return.Failure then
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing database information", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		return
	else
		lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/pdfdriver:", ls_pdfdriver, true)
		
		if ls_monitor_id<>"" then 
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, monitor_id=" + upper(ls_monitor_id) , "", 0, ls_monitor_id)
		end if
				
		SQLCA.DBMS 			= "SYC Sybase System 10"
		SQLCA.LogPass 		= "LKJHGFdsa!##"
		SQLCA.LogId 			= "adminServerApp"
		SQLCA.AutoCommit 	= False
		SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_fixturereports' , Host='server_fixturereports'"
		
		connect using SQLCA;
		
		if SQLCA.SQLCode <> 0 then	
			lnv_errService.of_addmsg(this.classdefinition , "open", "Error, unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext, 0, ls_monitor_id)	
			lnv_errService.of_showmessages( )
			destroy lnv_errService
			return
		end if

		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "OK", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		/* now do the work! */
		
		li_daynumber = DayNumber(Today())
		
		If li_daynumber= 1 then
			lnv_fix = create n_fixturereport
			// If Sunday, then create weekly reports
			lnv_fix.of_create_weekly_report(ls_pdfdriver)
		else
			// Everyday except Saturday and Sunday, then create daily reports
			If li_daynumber <> 7 then 
				lnv_fix = create n_fixturereport
				lnv_fix.of_create_daily_report(ls_pdfdriver)
			end if	
		end if
		lnv_errservice.of_addmsg(this.classdefinition , "open", "Success.  Closing application", "", 0, ls_monitor_id)
		lnv_errservice.of_showmessages( )
		destroy lnv_errservice
		destroy lnv_fix
	
	end if	
end if


end event

event close;Disconnect using SQLCA;
Destroy SQLCA;

end event

