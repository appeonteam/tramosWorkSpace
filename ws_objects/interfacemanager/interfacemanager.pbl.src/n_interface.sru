$PBExportHeader$n_interface.sru
$PBExportComments$main ancestor of user objects in interface manager application
forward
global type n_interface from mt_n_nonvisualobject
end type
end forward

global type n_interface from mt_n_nonvisualobject
end type
global n_interface n_interface

type variables
string is_emailtext=""
constant integer ii_LOG_IMPORTANT = 1
constant integer ii_LOG_NORMAL = 2
constant integer ii_LOG_DEBUG = 3
string is_monitor_id = ""
end variables

forward prototypes
public function integer of_writetolog (string as_text, integer ai_loglevel)
public subroutine documentation ()
public function integer of_setmonitorid (string as_monitor_id)
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, integer ai_severity, boolean ab_showmessage)
public function integer of_sendmail (string as_sender, string as_recipient, string as_subjecttext, string as_bodytext, ref string as_statusmessage)
end prototypes

public function integer of_writetolog (string as_text, integer ai_loglevel);string ls_subject, ls_errormessage

if ai_loglevel <= gi_loglevel then
	_addmessage( this.classdefinition, "of_writetolog()", as_text, "")

	if isvalid(w_interfacemanagertimer) then
		if w_interfacemanagertimer.visible = true then
			if pos(as_text,"info, ")>0 then
				w_interfacemanagertimer.st_loginfo.text = string(now(), "hh:mm:ss - " ) + as_text
			elseif pos(as_text,"processed, ")>0 then
				w_interfacemanagertimer.st_logprocessed.text = string(now(), "hh:mm:ss - " ) + as_text
			elseif pos(as_text,"warning, ")>0 then	
				w_interfacemanagertimer.st_logwarning.text = string(now(), "hh:mm:ss - " ) + as_text
			elseif pos(as_text,"critical error, ")>0 then	
				w_interfacemanagertimer.st_logcritical.text = string(now(), "hh:mm:ss - " ) + as_text
			elseif pos(as_text,"error, ")>0 then		
				w_interfacemanagertimer.st_logerror.text = string(now(), "hh:mm:ss - " ) + as_text
			end if	
			
		end if
	end if	

	/* 
	logic based on content of as_text 
	if as_text contains 'critical' then we send 1 mail message
	otherwise if as_text conatins 'error' we then save the text appending to instance string variable
	*/

	if gs_emailto<>"" then
		if pos(as_text,"critical")>0 then	
			/* email processing here 1 time! */
			ls_subject = "interface manager:" + as_text
			is_emailtext = "<html><body>There has been a problem with the interfacemanager process, error messages which lead up to the critical error follow:~r~n~r~n" + is_emailtext + "~r~n~r~nIt is recommended you resolve the problem and restart the server application 'interfacemanager' at your earliest convienience.</body></html>"
			
			if of_sendmail(C#EMAIL.TRAMOSSUPPORT, gs_emailto, ls_subject, is_emailtext, ls_errormessage) = c#return.Success then
				_addmessage(this.classdefinition, "of_writelog()", "info, email message sent to user " + gs_emailto, "")		
			else
				_addmessage(this.classdefinition, "of_writelog()", "error can not send notification email, error detail:" + ls_errorMessage, "")		
				return c#return.Failure
			end if		
			gs_emailto = ""

		elseif pos(as_text,"error")>0 then
			is_emailtext += as_text + "~r~n"
		end if
	end if	
end if

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interface
	
	<OBJECT>
		Ancestor user object.  all data transfer interface manager objects inherit from
		this object.
	</OBJECT>
  	<DESC>
		Event Description
	</DESC>
   <USAGE>
		Used only as an ancestor
	</USAGE>
	<ALSO>
		
		*n_interface*
		|	+  n_interfacelogic
		|	|	+	n_interfacelogicvm
		|	|	+ 	n_interfacelogicax
		|	+  n_interfaceprocess
		
	
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		05/01/12 	M5-1      	AGL			First Version
		24/10/13		CR2690	LGX001			1. Replaced @maersk.com with C#email.domain
														2. Replaced TRAMOS_DONT_REPLY@maersk.com with c#email.tramossupport
		07/03/16		CR4316	AGL027			Swapped domain constant for the email adress from AD saved in DB
		12/10/16		CR3320	AGL027			Voyage Master Transaction Handling
********************************************************************/
end subroutine

public function integer of_setmonitorid (string as_monitor_id);if not isnull(is_monitor_id) then
	is_monitor_id = as_monitor_id
end if
return c#return.Success
end function

protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, integer ai_severity, boolean ab_showmessage);n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage, ai_severity, is_monitor_id )
if ab_showmessage then lnv_errService.of_showmessages( )
return c#return.success
end function

public function integer of_sendmail (string as_sender, string as_recipient, string as_subjecttext, string as_bodytext, ref string as_statusmessage);/********************************************************************
of_sendmail( /*string as_sender*/, /*string as_recipient*/, /*string as_subjecttext*/, /*string as_bodytext*/, /*ref string as_statusmessage */)

<DESC>
	standard email method that uses TRAMOS MAIL to send pre-prepared content
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
as_sender:				Usually the TramosMT support full mail address.
as_recipient:			Full email
as_subjecttext:		Pre-Prepared subject text
as_bodytext:			Pre-prepared body that will be sent inside the mail.
as_statusmessage:		Contains any error message that might be returned from the SMTP mail object.
</ARGS>
<USAGE>
limitations - no file attachments are included in this standard call
</USAGE>
********************************************************************/

boolean lb_sendemail = false
long ll_recipient
string ls_recipients[]
string ls_errormessage, ls_subject, ls_body, ls_recipient_fullemail[], ls_sender_fullemail, ls_ax_message
mt_n_outgoingmail lnv_mail
mt_n_activedirectoryfunctions lnv_adfunc
mt_n_stringfunctions lnv_stringfunc


/* recipient can be delimited list of maersk id's */
if pos(as_recipient,";")>0 then
	lnv_stringfunc.of_parsetoarray( as_recipient,";",ls_recipients[])
else 
	ls_recipients[1] = as_recipient
end if

/* obtain the real email address for recipient(s) */
for ll_recipient = 1 to upperbound(ls_recipients)
	if len(ls_recipients[ll_recipient]) = 6 then // typical maersk id - simple validation.
		ls_recipient_fullemail[ll_recipient] = lnv_adfunc.of_get_email_by_userid_from_db(ls_recipients[ll_recipient])
		if ls_recipient_fullemail[ll_recipient]="" then ls_recipient_fullemail[ll_recipient] = ls_recipients[ll_recipient] + C#EMAIL.DOMAIN
	else 
		ls_recipient_fullemail[ll_recipient] = ls_recipients[ll_recipient]
	end if
next 

/* obtain real email address for sender */
if len(as_sender)=6 then // typical maersk id - simple validation.
	ls_sender_fullemail = lnv_adfunc.of_get_email_by_userid_from_db(as_sender)
	if ls_sender_fullemail="" then ls_sender_fullemail = as_sender + C#EMAIL.DOMAIN
else 
	ls_sender_fullemail = as_sender
end if

lnv_mail = create mt_n_outgoingmail
/* firstly create the mail instance with the first recipient */
if lnv_mail.of_createmail(ls_sender_fullemail, ls_recipient_fullemail[1], as_subjecttext, as_bodytext, as_statusmessage) = -1 then
	of_writetolog("error, could not create smtp mail record. error desription:" + ls_errormessage,ii_LOG_NORMAL)
	destroy lnv_mail
	return c#return.failure
else
	/* if there are any more recipients add them to the receivers array inside SMTP object */
	if upperbound(ls_recipient_fullemail)>1 then
		for ll_recipient = 2 to upperbound(ls_recipient_fullemail)
			if lnv_mail.of_addreceiver( ls_recipient_fullemail[ll_recipient], as_statusmessage) = -1 then
				of_writetolog("error, could not add recipients to smtp mail record. error desription:" + ls_errormessage,ii_LOG_NORMAL)
				destroy lnv_mail
				return c#return.failure				
			end if	
		next
	end if
	if lnv_mail.of_setcreator( ls_sender_fullemail, as_statusmessage) = -1 then
		of_writetolog("error, could not set creator when attempting to smtp mail, error detail:" + ls_errormessage,ii_LOG_NORMAL)
		destroy lnv_mail
		return c#return.failure
	end if
	if lnv_mail.of_sendmail( as_statusmessage ) = -1 then
		of_writetolog("error can not send notification email, error detail:" + ls_errorMessage,ii_LOG_NORMAL)
		destroy lnv_mail
		return c#return.failure
	end if
end if	
lnv_mail.of_reset()
destroy lnv_mail		


return c#return.Success
end function

on n_interface.create
call super::create
end on

on n_interface.destroy
call super::destroy
end on

