$PBExportHeader$mt_n_smtp_send.sru
forward
global type mt_n_smtp_send from mt_n_nonvisualobject
end type
end forward

global type mt_n_smtp_send from mt_n_nonvisualobject
end type
global mt_n_smtp_send mt_n_smtp_send

type prototypes
FUNCTION boolean CreateDirectoryA(ref string path, long attr) LIBRARY "KERNEL32.DLL"
FUNCTION boolean RemoveDirectoryA(ref string path) LIBRARY "KERNEL32.DLL" 
end prototypes

type variables
private mt_n_smtp	inv_smtp         //Autoinstantiated
private mt_n_datastore		ids_mail, ids_receiver, ids_attachment

end variables

forward prototypes
public subroutine documentation ()
private function integer of_cleanup_old_mails (long al_cleanup_days)
public function integer of_send (string as_servername, long al_port, long al_cleanup, integer ai_mode, string as_prefix)
private subroutine of_cleanup (string as_temppath)
end prototypes

public subroutine documentation ();/********************************************************************
ObjectName: mt_n_smtp_send - Used to sending outgoing mails using SMTP

<OBJECT>
This object is used to send outgoing mails from TRAMOS database.
The reason is that we are not allowed to send email from a client application. The 
IP address sending the mail has to be relay permitted in the A.P.Moller network, and
that can't be done to all workstations. 
The outgoing mails are picked up from the SMTP mail table in TRAMOS and sent
</OBJECT>
	
<USAGE> 
AS-IS this object is instantiated in a window timer event, which calls the of_send function
This is done so that the application running acts as a service.
</USAGE>
<ALSO>
This object requires the mt_n_smtp and mt_n_winsock to work
</ALSO>

Date   Ref   	Author        			    	 Comments
05/03/09       	Regin Mortensen     	First Version
27/05/11          Arjun Khosla	 		Added support for HTML email
													If body starts with <html and ends with </html>
													the HTML flag is set to true. (Ref CR# 2008 and 2441)
29/03/12				Arjun Khosla			Removed check for ending </html> to handle truncated mails		
03/08/12	cr#2892	AGL027					Moved into MT framework, command line controlled & also included test option.
21/08/13  CR3312  ZSW001               Email engine stopped working.
14/10/16  CR4534  SSX014               Read large unitext
********************************************************************/

end subroutine

private function integer of_cleanup_old_mails (long al_cleanup_days);string ls_methodname = "of_cleanup_old_mails()"

DELETE SMTP_ATTACHMENT  
	FROM SMTP_MAIL, SMTP_ATTACHMENT  
	WHERE SMTP_MAIL.SMTP_MAIL_ID = SMTP_ATTACHMENT.SMTP_MAIL_ID 
	AND datediff(dd,SMTP_MAIL.MAIL_SENT,getdate() ) >= :al_cleanup_days;

if sqlca.sqlcode <> 0 then
	_addmessage( this.classdefinition, ls_methodname, "Error deleting attachments", "",true)
	_addmessage( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "",true)	
	rollback;
	return -1
end if

DELETE SMTP_RECEIVER  
	FROM SMTP_MAIL, SMTP_RECEIVER  
	WHERE SMTP_MAIL.SMTP_MAIL_ID = SMTP_RECEIVER.SMTP_MAIL_ID 
	AND datediff(dd,SMTP_MAIL.MAIL_SENT,getdate() ) >= :al_cleanup_days;

if sqlca.sqlcode <> 0 then
	_addmessage( this.classdefinition, ls_methodname, "Error deleting receivers", "",true)	
	_addmessage( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "",true)	
	rollback;
	return -1
end if

DELETE 	FROM SMTP_MAIL
	WHERE datediff(dd,SMTP_MAIL.MAIL_SENT,getdate() ) >= :al_cleanup_days;

if sqlca.sqlcode <> 0 then
	_addmessage( this.classdefinition, ls_methodname, "Error deleting mails", "",true)	
	_addmessage( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "",true)	
	rollback;
	return -1
end if

commit;

return 1
end function

public function integer of_send (string as_servername, long al_port, long al_cleanup, integer ai_mode, string as_prefix);long 	ll_mails, ll_mail_row, ll_receivers, ll_receiver_row, ll_attactments, ll_attach_row
long	ll_mailID, ll_attachmentID
blob	lblb_filecontent
string	ls_filename, ls_body, ls_methodname,ls_subjectprefix="", ls_temppath
long	ll_filesize, ll_filehandle
boolean lb_HTML
constant long READSIZE = 8000

ls_methodname = "of_send()"

/* Initialize the server */
inv_smtp.of_setServer(as_servername)
inv_smtp.of_setPort(al_port)
ll_mails = ids_mail.retrieve( )

/* If getting mails fail - return */
if ll_mails < 0 then 
	_addmessage( this.classdefinition, ls_methodname, "Reading mails from DB failed. (mt_n_smpt_send.of_send())", "", true)	
	return -1
end if

if ai_mode = 1 then		/* we are running in test mode so filter out the emails we do not want to send */
	ids_mail.setfilter("sender_name='*test*'")	
	ids_mail.filter()
	ll_mails = ids_mail.rowcount()
	if as_prefix="" then
		ls_subjectprefix = "(test email - please ignore) "
	else
		ls_subjectprefix = as_prefix
	end if
end if

/* If no mail to send, return */
if ll_mails = 0 then	
	_addmessage( this.classdefinition, ls_methodname, "No outgoing mails found. (mt_n_smpt_send.of_send())", "", true)	
	return 1
end if

/* Delete all mails that are sent before the cleanup period */
if of_cleanup_old_mails( al_cleanup ) = -1 then
	_addmessage( this.classdefinition, ls_methodname, "Deleting expired mails failed. (mt_n_smpt_send.of_send())", "", true)	
end if	

if not (DirectoryExists(".\temp")) then
	if CreateDirectory(".\temp") = -1 then
		_addmessage( this.classdefinition, ls_methodname, "CreateDirectory('.\temp') failed. (mt_n_smpt_send.of_send())", "", true)	
		return -1
	end if
end if

/* change the folder */
if changedirectory(".\temp") = -1 then
	_addmessage( this.classdefinition, ls_methodname, "ChangeDirectory('.\temp') failed. (mt_n_smpt_send.of_send())", "", true)		
	return -1
end if


for ll_mail_row = 1 to ll_mails
	ll_mailID = ids_mail.getItemNumber(ll_mail_row, "SMTP_mail_id")
	
	inv_smtp.of_reset( )
	
	_addmessage( this.classdefinition, ls_methodname, "Sending Mail with ID='" + string(ll_mailID) + "' (mt_n_smpt_send.of_send())", "", true)
	
	/* Set From */
	if isNull(ids_mail.getItemString(ll_mail_row, "sender_name")) then
		inv_smtp.of_setFrom( ids_mail.getItemString(ll_mail_row, "sender_email"))
	else
		inv_smtp.of_setFrom( ids_mail.getItemString(ll_mail_row, "sender_email"), ids_mail.getItemString(ll_mail_row, "sender_name"))
	end if
	
	/* Set Subject */
	inv_smtp.of_setSubject( ls_subjectprefix + ids_mail.getItemString(ll_mail_row, "subject"))

	/* Set Body */ // If body starts with <html and ends with </html>, set HTML flag to true
	ls_Body = Trim(ids_mail.getItemString(ll_mail_row, "mail_body_text"), True)
	if len(ls_Body) >= READSIZE then
		if f_read_mail_body(ll_mailID, ls_Body, READSIZE) = 1 then
			ls_Body = Trim(ls_Body)
		end if
	end if
	If lower(left(ls_Body,5))="<html" Then lb_HTML = True Else lb_HTML = False
	inv_smtp.of_setbody(ls_Body, lb_HTML)

	/* Set To (Receiver) */
	ll_receivers = ids_receiver.retrieve(ll_mailID)
	for ll_receiver_row = 1 to ll_receivers					
		if isNull(ids_receiver.getItemString(ll_receiver_row, "receiver_name")) then
			inv_smtp.of_addTo( ids_receiver.getItemString(ll_receiver_row, "receiver_email"))
		else
			inv_smtp.of_addTo( ids_receiver.getItemString(ll_receiver_row, "receiver_email"), ids_receiver.getItemString(ll_receiver_row, "receiver_name"))
		end if
	next

	/* Set File Attachments */
	ll_attactments = ids_attachment.retrieve(ll_mailID)
	for ll_attach_row = 1 to ll_attactments
		

		
		ll_attachmentID = ids_attachment.getItemNumber(ll_attach_row, "SMTP_attachment_id")
		ls_filename = ids_attachment.getItemString(ll_attach_row, "filename")
		ll_filesize = ids_attachment.getItemNumber(ll_attach_row, "filesize")
		
		selectblob FILE_CONTENT
			INTO :lblb_filecontent
			FROM SMTP_ATTACHMENT
			WHERE SMTP_ATTACHMENT_ID = :ll_attachmentID;
		if sqlca.sqlcode <> 0 then
			_addmessage( this.classdefinition, ls_methodname, "Selectblob from mail attachment failed!", "", true)					
			_addmessage( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "", true)					
			return -1
		end if
		commit;
		ll_filehandle = fileOpen( ls_filename , StreamMode!, Write!, LockWrite!, Replace!)
		fileWriteEX(ll_filehandle, lblb_filecontent, ll_filesize)
		fileClose (ll_filehandle)
		inv_smtp.of_addFile(ls_filename)
	next
	
	if inv_smtp.of_sendmail( ) then
		ids_mail.setItem(ll_mail_row, "mail_sent", datetime(today(), now()))
		if ids_mail.update() = 1 then
			commit;
		else
			_addmessage( this.classdefinition, ls_methodname, "Update of mail table failed!", "", true)					
			_addmessage( this.classdefinition, ls_methodname, "SQLErrorText: "+ sqlca.sqlerrtext, "", true)								
			rollback;
		end if
	else
		_addmessage( this.classdefinition, ls_methodname, "Mail with ID='"+string(ll_mailID)+"' failed to send. (mt_n_smpt_send.of_send())", "", true)							
	end if
next

of_cleanup(ls_temppath)

return 1
end function

private subroutine of_cleanup (string as_temppath);/* Deletes the files in the temporary folder used for attachments and resets the filtered data source */
string ls_methodname = "of_cleanup()"
string ls_cmd


if changedirectory("..") = -1 then
	_addmessage( this.classdefinition, ls_methodname, "ChangeDirectory('..') failed. (mt_n_smpt_send.of_cleanup())", "", true)	
end if

ls_cmd = "cmd /q /c del .\temp\*.* /q"
run(ls_cmd)

ls_cmd = "cmd /q /c rmdir .\temp /s /q"
run(ls_cmd)


end subroutine

on mt_n_smtp_send.create
call super::create
end on

on mt_n_smtp_send.destroy
call super::destroy
end on

event constructor;ids_mail = create mt_n_datastore
ids_mail.dataObject = "d_sq_tb_outgoing_mails"
ids_mail.setTransObject(sqlca)

ids_receiver = create mt_n_datastore
ids_receiver.dataObject = "d_sq_tb_outgoing_receivers"
ids_receiver.setTransObject(sqlca)

ids_attachment = create mt_n_datastore
ids_attachment.dataObject = "d_sq_tb_outgoing_attachments"
ids_attachment.setTransObject(sqlca)
end event

event destructor;destroy ids_attachment
destroy ids_receiver
destroy ids_mail
end event

