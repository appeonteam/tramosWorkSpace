$PBExportHeader$smtp_mail_service.sra
$PBExportComments$Generated Application Object
forward
global type smtp_mail_service from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type smtp_mail_service from application
string appname = "smtp_mail_service"
end type
global smtp_mail_service smtp_mail_service

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   smtp_mail_service: 
	
	<OBJECT>
		This is the application object for our SMTP mail service that handles
		outgoing emails from Tramos.
	</OBJECT>
   <DESC>
		Accepts command line parameters and sends them onto window object that 
		is main controller for application.
	</DESC>
  	<USAGE>
		Can be set to run in production or test. Test mode allows test users to
		select outgoing emails
	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	25/10/16		CR4534	SSX014			Resolve issue with character limitation on body text
	25/10/16		CR4534	AGL027			Apply server monitor; log file name and SSO
********************************************************************/
end subroutine

on smtp_mail_service.create
appname="smtp_mail_service"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on smtp_mail_service.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;mt_n_stringfunctions		lnv_stringfunc
n_versioninfo 				lnv_versioninfo

string ls_commandline, ls_version, ls_method
ls_method = "smtp_mail_service.open()"


ls_commandline = commandline

//ls_commandline = "/server:scrbtandkbal311 /db:DEV_CPH /mode:test /monitor_id:SMTPAPP /logname:SMTP_[YYYYMMDD].log /appendlog:yes /subjectprefix:(CR4534) /security:DCRBTANDKBAL311@CRB.APMOLLER.NET"


openwithparm(w_smtp_timer,ls_commandline)


if isValid(w_smtp_timer) then w_smtp_timer.hide()


end event

