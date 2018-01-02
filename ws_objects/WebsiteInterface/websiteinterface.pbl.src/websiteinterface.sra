$PBExportHeader$websiteinterface.sra
$PBExportComments$Generated Application Object
forward
global type websiteinterface from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string 	gs_flag_update
string	gs_updatedate
boolean	gb_sendfleetlist


end variables

global type websiteinterface from application
string appname = "websiteinterface"
end type
global websiteinterface websiteinterface

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Web Site Interface - calls web services and sends positions and fleet
			(details, certificates, newbuildings) to the web sites

   <OBJECT>
		Configuration file - websiteinterface.ini
			[database]
				dbms
				servername
				database
			[login]
				uid 			- Tramos user
				pwd			- Password of Tramos user
				uidfiles 		- User of FILES database
				pwdfiles		- Password to access FILES database
			[web]
				update = 0/1 	- send all the certificate files (0) or send only the updated and new files (1)
				updatedate  		- last update date (in case update=1, then only the updated certificates are sent to the web site
			[logfile]
				append = 0/1
		
		Log File - websiteinterface.log
		
	</OBJECT>
   
	<USAGE> 
		The application runs as scheduled task on Tramos Server. It connects to the website
		(ex: http://maersktankerstst.apmoller.net/_vti_bin/MaerskTankers/TramosService.asmx/soap/?wsdl)
		and calls the services: updatePositions and updateFleet. The data is sent has XML file. 
	</USAGE>
   
	<ALSO>
		Detailed information is described on the object n_websiteinterface.
	</ALSO>

<HISTORY>
   Date	      CR-Ref	 Author	Comments
   00/03/10	   CR1722    JMC112
	08/04/2013  CR3178    ZSW001  Add global variable and update "updatedate" after certificate list is updated successfully.
</HISTORY>
********************************************************************/

end subroutine

on websiteinterface.create
appname="websiteinterface"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on websiteinterface.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_app, ls_version="", ls_monitor_id, ls_logname, ls_commandline, ls_method = "websiteinterface.open()"
integer li_retval

n_service_manager 		lnv_serviceManager
n_error_service			lnv_errService
n_versioninfo				lnv_versioninfo
mt_n_stringfunctions		lnv_stringfunc
ls_logname = "websiteinterface.log"
string ls_sql, ls_ErrText, ls_flagtext, ls_secure=""
n_websiteinterface	lnv_websiteinterface
datetime	ldt_start
s_updateflags				lstr_tasks


//ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /monitor_id:WEBSITE /logname:website_[YYYYMM].log /updatepos:0 /updatefleet:0 /updatecerts:0 /allcerts:0 /secure:DCRBTANDKBAL311@CRB.APMOLLER.NET"
ls_commandline = commandline

lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)
if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

/* non critical configuration options from command line */
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logname:", ls_logname, false)

lnv_serviceManager.of_loadservice( lnv_errservice , "n_error_service")
lnv_errService.of_setoutput( 2, getcurrentdirectory() +  "\" + ls_logname )

lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/monitor_id:", ls_monitor_id, false)
SQLCA.of_setmonitorid(ls_monitor_id)


lnv_errservice.of_addmsg( this.classdefinition, ls_method, "*************************", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, application started", "", 0, ls_monitor_id)
lnv_errservice.of_addmsg( this.classdefinition, ls_method, "info, version number=" + ls_version, "", 0, ls_monitor_id)

/* ini file validation */
if fileexists("websiteinterface.ini") = false then 
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error - file websiteinterface.ini doesn't exist!", "", 0, ls_monitor_id)
	return
end if 

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
		if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/secure:", ls_secure, true) = c#return.Failure then
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error - missing secure mechanism", "", 0, ls_monitor_id)
			lnv_errservice.of_showmessages( )
			return
		else
		
			if ls_monitor_id<>"" then 
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, monitor_id=" + upper(ls_monitor_id) , "", 0, ls_monitor_id)
			end if
				
				
			/* special parameter(s) for this application */
			lstr_tasks.b_update_positions = true
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/updatepos:", ls_flagtext, false)
			if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "update positions DISABLED", "info")
				lstr_tasks.b_update_positions = false
			end if	
			
			lstr_tasks.b_update_fleet_list = true
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/updatefleet:", ls_flagtext, false)
			if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "update fleet DISABLED", "info")			
				lstr_tasks.b_update_fleet_list = false
			end if
	
			lstr_tasks.b_update_certificates = true
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/updatecerts:", ls_flagtext, false)
			if upper(ls_flagtext)='NO' or ls_flagtext='0' or upper(ls_flagtext)='FALSE' then 
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "update certificates DISABLED", "info")
				lstr_tasks.b_update_certificates = false
				lstr_tasks.b_update_all_certificates = false
			else 
				lstr_tasks.b_update_all_certificates = false
				lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/allcerts:", ls_flagtext, false)
				if upper(ls_flagtext)='YES' or ls_flagtext='1' or upper(ls_flagtext)='TRUE' then 
					lnv_errservice.of_addmsg( this.classdefinition, ls_method, "update all certificates ENABLED", "info")
					lstr_tasks.b_update_all_certificates = true		
				end if			
			end if
			/* end of special parameter set */	
			
			SQLCA.DBMS 			= "ASE ADAPTIVE SERVER ENTERPRISE"
			SQLCA.AutoCommit 	= False
			SQLCA.DBParm 		= "Release='15',UTF8=1,appname='server_websiteinterface',Host='server_websiteinterface',Sec_Cred_Timeout=100,Sec_Network_Auth=1,Sec_Server_Principal='" + ls_secure + "'"
			
			connect using SQLCA;
			
			if SQLCA.SQLCode <> 0 then	
				lnv_errService.of_addmsg(this.classdefinition , "open", "Error, unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext, 0, ls_monitor_id)	
				lnv_errService.of_showmessages( )
				destroy lnv_errService
				return
			end if
	
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "OK", "", 0, ls_monitor_id)
			lnv_errservice.of_showmessages( )
			
			/* now the work block begins */
			lnv_errservice.of_addmsg( this.classdefinition, ls_method, "<Begin>", "", 0, ls_monitor_id)		
	
			/* still requires ini file */
			gs_flag_update = ProfileString ( "websiteinterface.ini", "web", "update", "1" )
			gb_sendfleetlist = true //means send fleet list //run one time
			gs_updatedate = ProfileString ( "websiteinterface.ini", "web", "updatedate", "01-04-2010" )

			SELECT TOP 1 getdate() INTO :ldt_start FROM VESSEL_CERT USING SQLCA;
			
			/* Start web services */
			lnv_websiteinterface = create n_websiteinterface
			/* if method below returns success all updates & certificates worked as expected */
			
			li_retval = lnv_websiteinterface.of_start(lstr_tasks)
			if li_retval = c#return.Success then
				setprofilestring("websiteinterface.ini", "web", "updatedate", string(ldt_start, "DD-MM-YYYY hh:mm"))
				lnv_errservice.of_addmsg(this.classdefinition , "open", "<Success - Closing application>", "", 0, ls_monitor_id)
			elseif li_retval = c#return.NoAction then
				setprofilestring("websiteinterface.ini", "web", "updatedate", string(ldt_start, "DD-MM-YYYY hh:mm"))
				lnv_errservice.of_addmsg(this.classdefinition , "open", "<Nothing to do - Closing application>", "", 0, ls_monitor_id)
			else	
				/* at least one problem occurred */
				lnv_errservice.of_addmsg(this.classdefinition , "open", "<Error - Closing application>", "", 0, ls_monitor_id)
				// no update to date, so this process will run again on any failed items.
			end if	
			lnv_errservice.of_showmessages( )
			
			destroy lnv_websiteinterface
			destroy lnv_errservice
			/* end of work block */

		end if
		
	end if	
end if


end event

event close;disconnect using SQLCA;

end event

