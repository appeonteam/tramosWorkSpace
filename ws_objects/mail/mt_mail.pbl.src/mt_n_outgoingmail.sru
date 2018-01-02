$PBExportHeader$mt_n_outgoingmail.sru
$PBExportComments$Component for creating outgoing mails
forward
global type mt_n_outgoingmail from nonvisualobject
end type
end forward

global type mt_n_outgoingmail from nonvisualobject
end type
global mt_n_outgoingmail mt_n_outgoingmail

type variables
private mt_n_datastore 		ids_mail
private mt_n_datastore 		ids_receiver
private mt_n_datastore 		ids_attachment
private blob								iblb_filecontent[] 		
end variables

forward prototypes
public function integer of_createmail (string as_senderemail, string as_sendername, string as_receiveremail, string as_receivername, string as_subject, string as_body, ref string as_message)
public function integer of_createmail (ref string as_message)
public subroutine of_reset ()
public function integer of_addreceiver (string as_receiveremail, string as_receivername, ref string as_message)
public function integer of_addreceiver (string as_receiveremail, ref string as_message)
public function integer of_createmail (string as_senderemail, string as_receiveremail, string as_subject, string as_body, ref string as_message)
public function integer of_setsender (string as_senderemail, string as_sendername, ref string as_message)
public function integer of_setsender (string as_senderemail, ref string as_message)
public function integer of_sendmail (ref string as_message)
public function integer of_addattachment (string as_filepath, ref string as_message)
public subroutine documentation ()
public function integer of_setcreator (string as_userid, ref string as_message)
public function integer of_verifyreceiveraddress (string as_receiver, ref string as_message)
public function integer of_addattachment (ref blob ablob_file, string as_filename, long al_bytes, ref string as_message)
private subroutine _reducefilename (ref string as_filename, integer ai_sequence)
public function integer of_setsubject (string as_subject, string as_message)
public function integer of_setbody (string as_body, string as_message)
end prototypes

public function integer of_createmail (string as_senderemail, string as_sendername, string as_receiveremail, string as_receivername, string as_subject, string as_body, ref string as_message);if ids_mail.rowCount( ) <> 0 then
	as_message = "There is already an outgoing mail created that is not sent yet"
	return -1
end if

if isNull(as_senderEmail) or as_senderEmail = "" then
	as_message = "Please enter a sender (mail from)"
	return -1
end if
	
if isNull(as_receiverEmail) or as_receiverEmail = "" then
	as_message = "Please enter a receiver (mail to)"
	return -1
end if

if isNull(as_subject) or as_subject = "" then
	as_message = "Please enter a mail subject"
	return -1
end if

if isNull(as_body) or as_body= "" then
	as_message = "Please enter a mail body text"
	return -1
end if

if ids_mail.InsertRow(0) <> 1 then
	as_message = "Mail creation failed!"
	return -1
end if

/* Create mail */
ids_mail.object.sender_email[1] = as_senderEmail
ids_mail.object.sender_name[1] = as_senderName
ids_mail.object.subject[1] = as_subject
ids_mail.object.mail_body_text[1] = as_body

/* Add receiver */
ids_receiver.reset()
if ids_receiver.InsertRow(0) <> 1 then
	as_message = "Receiver creation failed!"
	return -1
end if

ids_receiver.object.receiver_email[1] = as_receiverEmail
ids_receiver.object.receiver_name[1] = as_receiverName

return 1
end function

public function integer of_createmail (ref string as_message);if ids_mail.rowCount( ) <> 0 then
	as_message = "There is already an outgoing mail created that is not sent yet"
	return -1
end if

if ids_mail.InsertRow(0) <> 1 then
	as_message = "Mail creation failed!"
	return -1
end if

return 1
end function

public subroutine of_reset ();blob	lblb_empty[]
ids_mail.reset()
ids_receiver.reset()
ids_attachment.reset()
iblb_filecontent = lblb_empty

end subroutine

public function integer of_addreceiver (string as_receiveremail, string as_receivername, ref string as_message);long ll_row

if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before entering a receiver (mail to)"
	return -1
end if

if isNull(as_receiverEmail) or as_receiverEmail = "" then
	as_message = "Please enter a receiver (mail to)"
	return -1
end if

/* Add receiver */
ll_row = ids_receiver.InsertRow(0) 

if  ll_row < 1 then
	as_message = "Receiver creation failed!"
	return -1
end if

ids_receiver.object.receiver_email[ll_row] = as_receiverEmail
ids_receiver.object.receiver_name[ll_row] = as_receiverName

return 1
end function

public function integer of_addreceiver (string as_receiveremail, ref string as_message);return of_addreceiver( as_receiverEmail, "", as_message )
end function

public function integer of_createmail (string as_senderemail, string as_receiveremail, string as_subject, string as_body, ref string as_message);if ids_mail.rowCount( ) <> 0 then
	as_message = "There is already an outgoing mail created that is not sent yet"
	return -1
end if

if isNull(as_senderEmail) or as_senderEmail = "" then
	as_message = "Please enter a sender (mail from)"
	return -1
end if
	
if isNull(as_receiverEmail) or as_receiverEmail = "" then
	as_message = "Please enter a receiver (mail to)"
	return -1
end if

if isNull(as_subject) or as_subject = "" then
	as_message = "Please enter a mail subject"
	return -1
end if

if isNull(as_body) or as_body= "" then
	as_message = "Please enter a mail body text"
	return -1
end if

if ids_mail.InsertRow(0) <> 1 then
	as_message = "Mail creation failed!"
	return -1
end if

/* Create mail */
ids_mail.setItem(1, "sender_email", as_senderEmail ) 
//ids_mail.object.sender_email[1] = as_senderEmail
ids_mail.object.subject[1] = as_subject
ids_mail.object.mail_body_text[1] = as_body

/* Add receiver */
ids_receiver.reset()
if ids_receiver.InsertRow(0) <> 1 then
	as_message = "Receiver creation failed!"
	return -1
end if

ids_receiver.object.receiver_email[1] = as_receiverEmail

return 1
end function

public function integer of_setsender (string as_senderemail, string as_sendername, ref string as_message);if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before entering a sender (mail from)"
	return -1
end if

if isNull(as_senderEmail) or as_senderEmail = "" then
	as_message = "Please enter a sender (mail from)"
	return -1
end if

ids_mail.object.sender_email[1] = as_senderEmail
ids_mail.object.sender_name[1] = as_senderName

return 1

end function

public function integer of_setsender (string as_senderemail, ref string as_message);return of_setsender( as_senderemail, "", as_message )
end function

public function integer of_sendmail (ref string as_message);/*    
Validate all datastores
Update all datastores + blob + distribute key
remember all i one transaction
start with a commit to be sure that a new transaction starts
when finished clear all datastores by calling of_reset
*/
long	ll_mailID, ll_attachmentID
long 	ll_rc
long	ll_rows, ll_row 

if ids_mail.rowCount() <> 1 then
	as_message = "No mail created - cant send mail"
	return -1
end if

if ids_receiver.rowCount() < 1 then
	as_message = "No mail receiver created - cant send mail"
	return -1
end if

COMMIT;  //starts new transaction 
ll_rc =  ids_mail.update(true, false)  //update mail
if ll_rc = 1 then
	ll_mailID = ids_mail.object.SMTP_Mail_ID[1]
	ll_rows = ids_receiver.rowCount()
	for ll_row = 1 to ll_rows
		ids_receiver.object.SMTP_Mail_ID[ll_row] = ll_mailID
	next
	ll_rc = ids_receiver.Update(true, false)  //update receiver
	if ll_rc = 1 then
		ll_rows = ids_attachment.rowcount( )
		for ll_row = 1 to ll_rows
			ids_attachment.object.SMTP_Mail_ID[ll_row] = ll_mailID
		next
		ll_rc = ids_attachment.Update(true, false)  //update attachment
		if ll_rc = 1 then
			ll_rows = ids_attachment.rowcount( )
			for ll_row = 1 to ll_rows
				ll_attachmentID = ids_attachment.object.SMTP_Attachment_ID[ll_row]
				UPDATEBLOB SMTP_ATTACHMENT 
					SET FILE_CONTENT = :iblb_filecontent[ll_row] 
					WHERE SMTP_ATTACHMENT_ID = :ll_attachmentID ;
				if SQLCA.SQLCode <> 0 then
					ROLLBACK;
					as_message = "Updateint attachment failed!"
					return -1
				end if
			next
			ids_mail.resetUpdate()
			ids_receiver.resetUpdate()
			ids_attachment.resetUpdate()
			COMMIT;   // Commit them
		else
			ROLLBACK;
			as_message = "Updateint attachment failed!"
			return -1
		end if
	else
		ROLLBACK; 
		as_message = "Updateint receiver failed!"
		return -1
	end if
else
	ROLLBACK;
	as_message = "Updateint mail failed!"
	return -1
end if

return 1
end function

public function integer of_addattachment (string as_filepath, ref string as_message);long ll_row, ll_bytes, ll_filenr, ll_pos, ll_prev_pos
string ls_filename

/* Filepath includes both filepath and filename */

if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before attacting files"
	return -1
end if

if isNull(as_filepath) or as_filepath = "" then
	as_message = "You must enter a filepath in order to attach a file"
	return -1
end if

if NOT fileExists(as_filepath) then
	as_message = "You must enter a correct filepath in order to attach a file"
	return -1
end if

/* Extract filename from path */
ll_pos = pos ( as_filepath, "\", 1 )
do while ll_pos <> 0
	ll_prev_pos = ll_pos
	ll_pos = pos (as_filepath, "\", ll_pos +1)
loop 
ll_prev_pos ++
ls_filename = mid(as_filepath, ll_prev_pos, len(as_filepath) -1)

ll_row = ids_attachment.insertRow(0)

if len(ls_filename)>50 then
	_reducefilename(ls_filename, ll_row)
end if

ll_filenr = fileOpen(as_filepath , StreamMode!, Read!, LockRead!)

ll_bytes = fileReadEx(ll_filenr, iblb_filecontent[ll_row] )

fileClose(ll_filenr)

if ll_bytes < 1 then
	as_message = "Something went wrong when reading the file"
	return -1
end if

ids_attachment.object.filename[ll_row] = ls_filename
ids_attachment.object.filesize[ll_row] = ll_bytes
	
return 1
end function

public subroutine documentation ();/********************************************************************
ObjectName: mt_n_outgoingmail - used for creation of the outgoing mails that have to 
											be sent from the TRAMOS server
<OBJECT>
This object is used to help storing the outgoing mails from TRAMOS in the database.
The reason is that we are not allowed to send email from a client application. The 
IP address sending the mail has to be relay permitted in the A.P.Moller network, and
that can't be done to all workstations. 
We append the mails and attachments to a set of tables, which then are emptied by
a service running on a 'relay permitted' server.
</OBJECT>
	
<USAGE> 
This object is very easy to use. Instantiate it and call the functions shown below:
of_createMail() - has a lot of overloaded functions with different parameters
of_addReiceiver() - if the receiver was not given in the createMail, or if you need 
						several receivers
of_addattachment( ) - to add attachments if any
of_sendmail( ) - to save the mail to the outgoing mail tables
of_reset( ) - to cleanup all variables - ready to create a new mail
the only public function. 
All functions returns a 1 if ok and a -1 if not. 
If -1 then there will be a message in the message parameter by reference
</USAGE>
<ALSO> 
</ALSO>

Date       Ref        Author              Comments
02/03/09   ?          Regin Mortensen     First Version
08/06/15   CR4041     LHG008              Add function of_setsubject()
28/07/15   CR4116     LHG008              Add function of_setbody()
********************************************************************/

end subroutine

public function integer of_setcreator (string as_userid, ref string as_message);/* This finction should only be called if the DB user creating the 
	mail is not a TRAMOS user.
	
	Only valid when password reset requests are entered */

if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before entering a Creator"
	return -1
end if

ids_mail.object.created_by[1] = as_userid

return 1

end function

public function integer of_verifyreceiveraddress (string as_receiver, ref string as_message);/*  This function verifies the receiver mail address.
	
	- The mail address must not include spaces
	- The mail address has to include '@'
	- The '@' character must not be the first or last character  
	
	returns 	1  - ok
				-1 - failed and a message in as_message ref. variable
*/
long 	ll_atcounter, ll_chars, ll_char

as_receiver = righttrim(as_receiver)
ll_chars = len(as_receiver)
for ll_char = 1 to ll_chars
	choose case mid(as_receiver, ll_char, 1)
		case "@"  
			ll_atcounter ++
			if (ll_char = 1) or (ll_char = ll_chars) then
				as_message = "Receiver Mail Address must not have '@' as the first or last character"
				return -1
			end if
		case " "   //space
			as_message = "Receiver Mail Address includes spaces - not allowed"
			return -1
	end choose
next

if ll_atcounter < 1 then
	as_message = "Receiver Mail Address must include an '@'"
	return -1
end if

if ll_atcounter > 1 then
	as_message = "Receiver Mail Address must include only one '@'"
	return -1
end if

return 1
end function

public function integer of_addattachment (ref blob ablob_file, string as_filename, long al_bytes, ref string as_message);long ll_row, ll_bytes, ll_filenr, ll_pos, ll_prev_pos
string ls_filename

/* Filepath includes both filepath and filename */

if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before attacting files"
	return -1
end if

ll_row = ids_attachment.insertRow(0)

iblb_filecontent[ll_row]  = ablob_file

if len(as_filename)>50 then
	 _reducefilename(as_filename, ll_row)
end if

ids_attachment.object.filename[ll_row] = as_filename
ids_attachment.object.filesize[ll_row] = al_bytes
	
return 1

end function

private subroutine _reducefilename (ref string as_filename, integer ai_sequence);
/********************************************************************
   _reducefilename 
   <DESC> Reduces the file name to 50 characters </DESC>
   <RETURN> 
	string: File name with 50 characters
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
	as_original_name: file name
	ai_sequence: file sequence (to avoid of having files with the same name)
   </ARGS>
   <USAGE>	Use this function to reduce the file name string
	</USAGE>
********************************************************************/

string ls_tmp, ls_ext
integer	li_i
char	lc_char
boolean	lb_found_extension = false

//Get file extension
for li_i= len(as_filename) to 1 step -1
	lc_char = mid(as_filename,li_i,1)
	if lc_char = "." then
		lb_found_extension = true
	else
		ls_ext =lc_char + ls_ext
	end if
 	if lb_found_extension = true then
   		exit
	end if
next

if lb_found_extension = false then
	//if file does not have an extension
	as_filename =  mid(as_filename,1,50)
else
	li_i=50 - len(ls_ext) - len(string(ai_sequence)) - 3
	as_filename =  mid(as_filename,1,li_i) + ".." + string(ai_sequence) + "." + ls_ext
end if

end subroutine

public function integer of_setsubject (string as_subject, string as_message);
if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before entering a Creator"
	return -1
end if

if isNull(as_subject) or as_subject = "" then
	as_message = "Please enter a mail subject"
	return -1
end if

ids_mail.object.subject[1] = as_subject

return 1
end function

public function integer of_setbody (string as_body, string as_message);
if ids_mail.rowCount() = 0 then
	as_message = "Please create a mail before entering a Creator"
	return -1
end if

if isNull(as_body) or as_body= "" then
	as_message = "Please enter a mail body text"
	return -1
end if

ids_mail.object.mail_body_text[1] = as_body

return 1
end function

on mt_n_outgoingmail.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_outgoingmail.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_mail = create mt_n_datastore
ids_mail.dataObject = "d_sq_tb_smtp_mail_table"
ids_mail.setTransObject(sqlca)

ids_receiver = create mt_n_datastore
ids_receiver.dataObject = "d_sq_tb_smtp_mail_receiver_table"
ids_receiver.setTransObject(sqlca)

ids_attachment = create mt_n_datastore
ids_attachment.dataObject = "d_sq_tb_smtp_mail_attachment_table"
ids_attachment.setTransObject(sqlca)

end event

event destructor;destroy ids_mail
destroy ids_receiver 
destroy ids_attachment 
end event

