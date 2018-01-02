$PBExportHeader$w_smtp_timer.srw
forward
global type w_smtp_timer from mt_w_main
end type
type st_info from statictext within w_smtp_timer
end type
end forward

global type w_smtp_timer from mt_w_main
integer width = 2107
integer height = 1188
string title = "w_smtp_timer"
boolean clientedge = true
integer transparency = 50
event ue_settimer ( long al_timer )
st_info st_info
end type
global w_smtp_timer w_smtp_timer

type variables
integer ii_mode=0
constant integer ii_DEFAULTMODE = 0
constant integer ii_TESTMODE = 1
string is_testsubjectprefix=""
s_settings	istr_settings
n_service_manager 		inv_serviceManager
n_error_service 			inv_errService
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_settimer(long al_timer);timer( al_timer )
end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_smtp_timer
	
	<OBJECT>
		Window with timer control for server application that remains open
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   <USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    	Author   		Comments
  	03/08/12 	CR2892  AGL027    		Moved into MT framework
	25/10/16		CR4534  AGL027				Apply more framework features and include SSO
********************************************************************/
end subroutine

event timer;string ls_mailserver
long	ll_port, ll_timer, ll_cleanup, ll_stop_service, ll_rc 
mt_n_smtp_send	lnv_smtpsend
string ls_methodname="w_smtp_timer.timer()"

if istr_settings.i_mode = ii_TESTMODE then
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "TEST MODE - checking....", "", 0, istr_settings.s_monitorid )	
end if

connect using sqlca;

SELECT MAILSERVER,
	PORT,
	TIMER,
	CLEANUP,
	STOP_SERVICE
INTO :ls_mailserver,
	:ll_port,
	:ll_timer,
	:ll_cleanup,
	:ll_stop_service
FROM SMTP_SERVICE_CONTROL;

if sqlca.sqlcode <> 0 then
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "error, select from SMTP_SERVICE_CONTROL DB failed!", "", 0, istr_settings.s_monitorid )	
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "", 0, istr_settings.s_monitorid )	
	inv_errservice.of_showmessages( )
	return
end if
COMMIT;

/* if stop service set to true - we end the application. it has to be manually restarted */
if ll_stop_service > 0 then 
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname,"Remote system shutdown issued and performed", "", 0, istr_settings.s_monitorid)	
	inv_errservice.of_showmessages( )
	disconnect using sqlca;
	HALT close
end if

/* the main call that checks the data for messages and sends onto the SMTP relay server */
lnv_smtpsend = create mt_n_smtp_send	
ll_rc = lnv_smtpsend.of_send( ls_mailserver , ll_port , ll_cleanup, istr_settings.i_mode, istr_settings.s_subjectprefix)
destroy lnv_smtpsend

/* check the return code from the SMTP mail send object */
if ll_rc = -1 then
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname,"error, mt_n_smtp_send.of_send() function failed!", "", 0, istr_settings.s_monitorid)	
end if

/* the following updates the database table, so we can see when it last ran */
UPDATE  SMTP_SERVICE_CONTROL
SET LAST_RUN = getdate();

if sqlca.sqlcode <> 0 then
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname,"error, updating SMTP_SERVICE_CONTROL failed!", "", 0, istr_settings.s_monitorid)	
	inv_errservice.of_addmsg( this.classdefinition, ls_methodname,"SQLErrorText: "+ sqlca.sqlerrtext, "", 0, istr_settings.s_monitorid)	
	rollback;
end if
commit;

/* write to log all text/info that might be queued up */
inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "info, polled SMTP message data", "", 0, istr_settings.s_monitorid )			
inv_errservice.of_showmessages( )

disconnect using sqlca;
garbageCollect()

post event ue_settimer(ll_timer)
end event

event open;string ls_commandline, ls_mode, ls_log, ls_version, ls_app, ls_methodname
boolean lb_deleteexistinglog = true
ls_commandline = message.stringparm

mt_n_stringfunctions		lnv_stringfunc
n_versioninfo				lnv_versioninfo

ls_methodname = "w_smtp_timer.open()"


/* get version detail */
lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)
if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/appendlog:", ls_log, false)
if lower(ls_log)='true' or ls_log='1' or lower(ls_log)='yes' then
	istr_settings.b_log_append=true
else
	istr_settings.b_log_append=false
end if
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logname:", istr_settings.s_logname, false)
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/monitor_id:", istr_settings.s_monitorid, false)
SQLCA.of_setmonitorid(istr_settings.s_monitorid)
inv_servicemanager.of_loadservice( inv_errservice , "n_error_service")

/* use full pathname with log file name so we do not have problems if application changes the current folder */

inv_errservice.of_setoutput( 2,  getcurrentdirectory() +  "\" + istr_settings.s_logname, istr_settings.b_log_append)
inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "*************************", "", 0, istr_settings.s_monitorid)
inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "info, application started", "", 0, istr_settings.s_monitorid)
inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "info, version number = " + ls_version, "", 0, istr_settings.s_monitorid)

if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", SQLCA.ServerName, true) = c#return.Failure then
	inv_errservice.of_addmsg(this.classdefinition, ls_methodname, "error, missing server information", "", 0, istr_settings.s_monitorid )	
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", SQLCA.Database, true) = c#return.Failure then
		inv_errservice.of_addmsg(this.classdefinition, ls_methodname, "error, missing database information", "", 0, istr_settings.s_monitorid )			
	else
		if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/security:", istr_settings.s_security, true) = c#return.Failure then
			inv_errservice.of_addmsg(this.classdefinition, ls_methodname, "error, missing database security information", "", 0, istr_settings.s_monitorid )			
		else
			/* set test mode if activated through command line parm */
			lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/mode:", ls_mode, false)
			if ls_mode = "test" then
				istr_settings.i_mode = ii_TESTMODE
				lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/subjectprefix:", istr_settings.s_subjectprefix, false) 
			end if
						
			/* Set DB profile. */
			SQLCA.DBMS 			= "ASE ADAPTIVE SERVER ENTERPRISE"
			SQLCA.AutoCommit 	= False
			SQLCA.DBParm 		= "Release='15',UTF8=1,appname='server_email',Host='server_email',Sec_Cred_Timeout=100,Sec_Network_Auth=1,Sec_Server_Principal='" + istr_settings.s_security + "'"
	
			/* write out active settings to log */
			inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "configuation > server        :" + SQLCA.ServerName, "", 0, istr_settings.s_monitorid)
			inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "               db            :" + SQLCA.Database, "", 0, istr_settings.s_monitorid)						
			inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "               security      :" + istr_settings.s_security , "", 0, istr_settings.s_monitorid)
			if istr_settings.i_mode = 1 then  // test mode enabled
				inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "               mode          :" + ls_mode, "", 0, istr_settings.s_monitorid)
				inv_errservice.of_addmsg( this.classdefinition, ls_methodname, "               subjectprefix :" + istr_settings.s_subjectprefix, "", 0, istr_settings.s_monitorid)
			end if
			/* First time start timer after 5 seconds */
			timer( 5 )
		end if
	end if
end if
inv_errservice.of_showmessages( )
end event

on w_smtp_timer.create
int iCurrent
call super::create
this.st_info=create st_info
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_info
end on

on w_smtp_timer.destroy
call super::destroy
destroy(this.st_info)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_smtp_timer
end type

type st_info from statictext within w_smtp_timer
integer x = 229
integer y = 184
integer width = 1536
integer height = 648
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This window will never be shown, only there because the timer event needs a Window"
boolean focusrectangle = false
end type

