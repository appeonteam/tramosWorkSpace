HA$PBExportHeader$u_expiredcertificates.sru
$PBExportComments$Send notices by email about expired vessel certificates
forward
global type u_expiredcertificates from nonvisualobject
end type
end forward

global type u_expiredcertificates from nonvisualobject
end type
global u_expiredcertificates u_expiredcertificates

forward prototypes
public function integer of_writelog (string as_message)
public subroutine documentation ()
public function integer of_sendemail (ref mt_n_outgoingmail anv_mail, string as_receiver, string as_mail_subject, string as_mail_message)
public function integer of_start ()
end prototypes

public function integer of_writelog (string as_message);FileWrite(gl_logHandle, as_message)
return 1
end function

public subroutine documentation ();/********************************************************************
ObjectName: u_expiredcertificates - used for sending a notification to the users about
											expired vessels certificates (scheduled task)				
   <OBJECT> 
	This object is used for sending an email with a list of expired certificates.
	Steps:
	1) Selects all the expired certificates that follow these conditions:
		- it includes all the profit centers with option "Notify Expired certificates" ON
		- includes only active vessels
	2) Sends an email to:
		- chartering email queue if an office is selected "Notify office" is ON
		- vessel if option "Notify vessel" is ON
	
	</OBJECT>
	
   <USAGE> 
	The deployment results into an exe file, that is scheduled in the tramos server and runs
	one time per day.
	</USAGE>

   <ALSO> 
	Uses an INI-file (expiredcertificates.ini) 
	The ini file looks like below:
	[database]
	dbms=SYC Sybase System 10
	database=PROD_TRAMOS
	servername=SCRBTRADKCPH001
	[login]
	uid=xx
	pwd=xxxxxxxxx
	[logfile]
	append=[0 or 1]
	[criteria]
	expireddays = for example:
	    = 0 only expired certificates (until today())
		 =7 includes the certificates that will expire on the next 7 days

	Writes all messages to expiredcertificates.log
	</ALSO>

Date   Ref   	Author		CR			Comments
02/02/10      JMC112			     	First Version
04/10/11		JMC112					Add Jik Boom to email list
30/12/11		JMC112		2674		Remove Jik Boom from email list
24/10/13		LGX001		2690		Replaced TRAMOS_DONT_REPLY@maersk.com with c#email.tramossupport(tramosMT@maersk.com) 
********************************************************************/

end subroutine

public function integer of_sendemail (ref mt_n_outgoingmail anv_mail, string as_receiver, string as_mail_subject, string as_mail_message);string	ls_errorMessage, ls_user_id
string 	as_msgreceivers //for control
string	ls_receiver2

as_msgreceivers = as_receiver

if gs_testemailaddress<>"" then as_receiver =gs_testemailaddress

if anv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, as_receiver , as_mail_subject , as_mail_message, ls_errorMessage) = -1 then	
		of_writelog( string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when creating the notification email " +char(13)+char(10)+"Reason: "+ls_errorMessage)
else
	ls_user_id="JMC112"
	if anv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when creating the notification email Reason: "+ls_errorMessage)
	else
		//Hardcoded for Handytankers - requested by Julija
		if upper(as_msgreceivers)= "CHACPH@HANDYTANKERS.COM"  then
			ls_receiver2 = "CPH.ADM@handytankers.com"
			if gs_testemailaddress2<>"" then ls_receiver2 =gs_testemailaddress2
		  	anv_mail.of_addreceiver(ls_receiver2, as_mail_message )
		  	as_msgreceivers = as_msgreceivers + ", CPH.ADM@handytankers.com"
//		else
//			ls_receiver2 = "JBO108@maersk.com"
//			if gs_testemailaddress2<>"" then ls_receiver2 =gs_testemailaddress2
//		  	anv_mail.of_addreceiver(ls_receiver2, as_mail_message )
//		  	as_msgreceivers = as_msgreceivers + ", JBO108@maersk.com"
		end if
		
		if anv_mail.of_sendmail( ls_errorMessage ) = -1 then
			of_writelog( string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when sending the email. "+char(13)+char(10)+"Reason: "+ls_errorMessage)
		end if
	end if
end if	
of_writelog( string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " A notification email with is sent to  " + as_msgreceivers )
anv_mail.of_reset( )

return 1
end function

public function integer of_start ();datastore	lds_expired_certificates, ds_office_email
date			ldt_expireddate
mt_n_outgoingmail	lnv_mail
string	ls_mail_subject, ls_mail_message, ls_receiver, ls_vesselemail, ls_pc, ls_curr_pc
string	ls_curr_receiver, ls_vesselrefnr, ls_curr_vesselrefnr, ls_tmp_receiver, ls_user_id, ls_errorMessage
integer	li_row
long		ll_totalrows		

ldt_expireddate = RelativeDate ( today(), gi_expireddays )

lds_expired_certificates = create datastore
lds_expired_certificates.dataobject = "d_expired_certificates"
lds_expired_certificates.setTransObject(SQLCA)
lds_expired_certificates.retrieve(ldt_expireddate)

ll_totalrows =  lds_expired_certificates.rowcount( )
if  ll_totalrows> 0 then
	 ls_receiver = lds_expired_certificates.getitemstring( 1, "offices_email_adr_charterer")
end if

lnv_mail = create mt_n_outgoingmail

ls_mail_subject = "TRAMOS Alert: Expired Vessels Certificates"

for li_row = 1 to ll_totalrows
	ls_curr_receiver = lds_expired_certificates.getitemstring( li_row, "offices_email_adr_charterer")
	ls_curr_vesselrefnr = lds_expired_certificates.getitemstring(li_row, "vessels_vessel_ref_nr")
	ls_curr_pc =  lds_expired_certificates.getitemstring(li_row, "profit_c_pc_name")
	ls_vesselemail = lds_expired_certificates.getitemstring( li_row, "vessels_vessel_email")
	if isnull(ls_vesselemail) then
		ls_vesselemail=""
	else
		ls_vesselemail = " (" + ls_vesselemail + ")"
	end if
	
	if ls_curr_receiver <> ls_receiver then
		//Send email
		of_sendemail( lnv_mail, ls_receiver, ls_mail_subject, ls_mail_message)

		ls_receiver = ls_curr_receiver
		ls_mail_message=""
	
	end if
	
	if ls_curr_vesselrefnr<> ls_vesselrefnr then
		if ls_curr_pc <> ls_pc then
			ls_mail_message = ls_mail_message + char(10)+ char(13) + ls_curr_pc + ":"
			ls_pc = ls_curr_pc
		end if
		ls_mail_message = ls_mail_message + char(10)+ char(13) +  ls_curr_vesselrefnr + " " +  lds_expired_certificates.getitemstring( li_row, "vessels_vessel_name") +  ls_vesselemail  + char(13) 
		ls_vesselrefnr = ls_curr_vesselrefnr
	end if
	
	ls_mail_message =  ls_mail_message + "  - " + lds_expired_certificates.getitemstring( li_row,"vessel_cert_description") + " (" +  lds_expired_certificates.getitemstring( li_row, "vessel_cert_file_name") + ")" + " " +  lds_expired_certificates.getitemstring( li_row, "vessel_cert_expired_date") + char(13)

next

if ls_mail_message<>"" then
	//Send email
	of_sendemail( lnv_mail, ls_receiver, ls_mail_subject, ls_mail_message)
end if
	
destroy lds_expired_certificates

of_writelog( string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Successful!")
return 1
end function

event constructor;//ddd
end event

on u_expiredcertificates.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_expiredcertificates.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

