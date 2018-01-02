$PBExportHeader$n_msps_interface.sru
forward
global type n_msps_interface from mt_n_nonvisualobject
end type
end forward

global type n_msps_interface from mt_n_nonvisualobject
event documents ( )
end type
global n_msps_interface n_msps_interface

type variables
mt_n_stringfunctions	inv_stringfunctions	//Commend line parameters resolving object
n_error_service		inv_error_service		//Log file service
n_service_manager		inv_service_manager	//Service manager


constant string	is_format_date = "yyyy-mm-dd"		//Date format
constant string	is_format_date_time = "yyyy-mm-dd hh:mm:ss" //Date time
constant string   is_crlf="~r~n"

constant string	is_FILE_SHARE_READING = "The file ${FILE} was shared by other process, file reading failed."
end variables

forward prototypes
public function string of_get_application_location ()
public function string of_get_filename (string as_filefullpathname)
public subroutine documentation ()
public function integer of_get_parameters (ref s_command_line astr_command_line, string as_commandline)
public function integer of_send_email (ref s_mspsdata astr_mspsdata, string as_mail_package, s_command_line astr_command_line)
public function integer of_check_file (s_command_line astr_command_line, string as_file)
public function integer of_setup_log (string as_log_dir)
public function integer of_write_log (string as_log_content)
end prototypes

public function string of_get_application_location ();/********************************************************************
   of_get_application_location
   <DESC>	Get the current application path.	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	11-01-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

CONSTANT long ll_namemaxlen = 255
string     ls_appfilepath, ls_appfilelocation	//

ls_appfilepath = space(ll_namemaxlen)
getmodulefilename(0, ls_appfilepath, ll_namemaxlen)	
ls_appfilelocation = left(ls_appfilepath, lastpos(ls_appfilepath, "\") + Len("\") - 1)
return ls_appfilelocation
end function

public function string of_get_filename (string as_filefullpathname);/********************************************************************
   of_get_filename
   <DESC>	Get file name from file full path name	</DESC>
   <RETURN>	string:File name	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_fullpathname: File full path name
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-01-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
String	ls_filename

if pos(as_filefullpathname, "\") > 0 then
	ls_filename = mid(as_filefullpathname, lastpos(as_filefullpathname, "\") + 1)
else
	ls_filename = as_filefullpathname
end if

return ls_filename
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	MSPS interface component	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-01-2012 20           JMY014        First Version
		24-10-2013 2690			LGX001		Replaced tramos_dont_reply@maersk.com with C#EMAIL.TRAMOSSUPPORT
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_get_parameters (ref s_command_line astr_command_line, string as_commandline);/********************************************************************
   of_get_parameters
   <DESC>	Get parameters to structure from command line	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_command_line:Saving command line parameters struecture
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10-01-2012 20           JMY014        First Version
		10-05-2012 20				JMY014			Added file folder feature for file list query.
   </HISTORY>
********************************************************************/

//Get log folder
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/logfolder:", astr_command_line.as_folder_log, true) = c#return.Failure then
	//Write log to the current application location
	astr_command_line.as_folder_log = of_get_application_location()
	of_setup_log(astr_command_line.as_folder_log)
	of_write_log("Log folder is not found, log folder changed to application location")
else
	if not fileexists(astr_command_line.as_folder_log) then 
		if createdirectory (astr_command_line.as_folder_log) = -1 then
			astr_command_line.as_folder_log = of_get_application_location()
			of_setup_log(astr_command_line.as_folder_log)
			//When log folder creation error, write log to the current application location
			of_write_log("Log folder creation error occured, log folder is changed to application location")
		end if
	else
		of_setup_log(astr_command_line.as_folder_log)
	end if
end if
//Get server name, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/server:", astr_command_line.as_server, true) = c#return.Failure then
	of_write_log("Server name is not found")
	return c#return.Failure
end if
//Get database name, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/db:", astr_command_line.as_database, true) = c#return.Failure then
	of_write_log("Database is not found")
	return c#return.Failure
end if
//Get application running mode
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/mode:", astr_command_line.as_mode, true) = c#return.Failure then
	//Set default running mode to "hidewindow"
	of_write_log("Applicaton running mode is not found")
	return c#return.Failure
end if
//Get input file option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/inputfile:", astr_command_line.as_inputfile, true) = c#return.Failure then
	of_write_log("Input file option is not found")
	//Get input file folder option
	if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/inputfolder:", astr_command_line.as_inputfolder, true) = c#return.Failure then
		of_write_log("Input file folder option is not found")
		return c#return.Failure
	else
		if not fileexists(astr_command_line.as_inputfolder) then
			of_write_log("Input file folder does not exist")
			return c#return.Failure
		else
			//Cancel the input file option
			astr_command_line.as_inputfile = ""
		end if
	end if
else
	if not fileexists(astr_command_line.as_inputfile) then 
		of_write_log("Input file does not exist")
		return c#return.Failure
	end if
end if
//Get the failed folder, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/failedfolder:", astr_command_line.as_folder_failed, true) = c#return.Failure then
	of_write_log("Failed folder is not found")
	return c#return.Failure
else
	if not fileexists(astr_command_line.as_folder_failed) then
		if createdirectory (astr_command_line.as_folder_failed) = -1 then 
			of_write_log("Failed folder creation error occured")
			return c#return.Failure
		end if
	end if
end if
//Get the rejected folder, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/rejectedfolder:", astr_command_line.as_folder_rejected, true) = c#return.Failure then
	of_write_log("Rejected folder is not found")
	return c#return.Failure
else
	if not fileexists(astr_command_line.as_folder_rejected) then
		if createdirectory (astr_command_line.as_folder_rejected) = -1 then 
			of_write_log("Rejected folder creation error occured")
			return c#return.Failure
		end if
	end if
end if
//Get the expired folder, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/expiredfolder:", astr_command_line.as_folder_expired, true) = c#return.Failure then
	of_write_log("Expired folder is not found")
	return c#return.Failure
else
	if not fileexists(astr_command_line.as_folder_expired) then
		if createdirectory (astr_command_line.as_folder_expired) = -1 then 
			of_write_log("Expired folder creation error occured")
			return c#return.Failure
		end if
	end if
end if

//Get the succeeded folder, this is not a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/succeededfolder:", astr_command_line.as_folder_succeeded, true) = c#return.Failure then
	astr_command_line.as_folder_succeeded = ""
	of_write_log("Succeeded folder is not found, running on default mode")
else
	if not fileexists(astr_command_line.as_folder_succeeded) then
		if createdirectory (astr_command_line.as_folder_succeeded) = -1 then 
			of_write_log("Succeeded folder creation error occured")
			return c#return.Failure
		end if
	end if
end if

//Get the email sender, this is not a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/sender:", astr_command_line.as_sender, true) = c#return.Failure then
	of_write_log("Email sender is not found")
	astr_command_line.as_sender = C#EMAIL.TRAMOSSUPPORT
	of_write_log("Email sender is set to default:" + C#EMAIL.TRAMOSSUPPORT)
end if

//Get the email receiver, this is not a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/receiver:", astr_command_line.as_receiver, true) = c#return.Failure then
	of_write_log("Email receiver is not found")
	return c#return.Failure
end if

return c#return.Success
end function

public function integer of_send_email (ref s_mspsdata astr_mspsdata, string as_mail_package, s_command_line astr_command_line);/********************************************************************
   wf_send_email
   <desc>	Send email	</desc>
   <return>	integer:
            <li> c#return.success, x ok
            <li> c#return.failure, x failed	</return>
   <access> public </access>
   <args>
		as_mail_package
   </args>
   <usage></usage> 
   <history>
   	date       cr-ref       	author             comments
   	2011-12-30 cr20            rjh022        		first version
		2011-12-30	20					JMY014				Migrated from window, added the command line structure as parameter
   </history>
********************************************************************/
string ls_emailfrom,ls_subject,ls_errormessage,ls_message
string ls_filename,ls_splitstring

blob lbl_filecontent 
long ll_bytes

string ls_currentdate
mt_n_outgoingmail	lnv_mail
ls_splitstring ="~~"
 
lnv_mail = create mt_n_outgoingmail

ls_currentdate = string(today(),'yyyymmdd') + '-' + string(now(),'hhmmss')
ls_filename ='tm' +ls_splitstring + astr_mspsdata.as_vessel_imo + '-' +ls_currentdate + ".dat"

lbl_filecontent = blob(as_mail_package, EncodingANSI!)
ll_bytes = Len(lbl_filecontent)
ls_subject = "Tramos receive"

ls_message = "The XML data has been received." + is_crlf + &
					 "Vessel IMO: " +astr_mspsdata.as_vessel_imo + is_crlf + &
					 "Report No: " + astr_mspsdata.as_report_no  + is_crlf + &
					 "Revision No: " +astr_mspsdata.as_revision_no   + is_crlf + &
					 "Report Type: "  +astr_mspsdata.as_report_type 
					 

//create email
if lnv_mail.of_createmail(astr_command_line.as_sender, astr_command_line.as_receiver, ls_subject, ls_message, ls_errormessage) = -1 then	
	messagebox("Error", "Error occured when creating the email. reason: "+ls_errormessage)
	destroy (lnv_mail)
	return c#return.failure
end if
 
lnv_mail.of_addattachment(lbl_filecontent, ls_filename, ll_bytes, ls_errorMessage)
 

if lnv_mail.of_setcreator(sqlca.logid ,  ls_errormessage) = -1 then
	messagebox("Error", "Error occured when creating the email in set creator. reason: "+ls_errormessage)
	destroy (lnv_mail)
	return c#return.failure
end if

if lnv_mail.of_sendmail( ls_errormessage ) = -1 then
	messagebox("Error", "Error occured when sending the email. reason: "+ls_errormessage)
	destroy (lnv_mail)
	return c#return.failure
end if
	
destroy (lnv_mail)
return c#return.success
end function

public function integer of_check_file (s_command_line astr_command_line, string as_file);/********************************************************************
   of_check_file
   <DESC>	Check if some other thread is writing the current file.	
				Check if the checksum is right.
				NB:The XML data file format has been set up as UTF-8,
					for checksum gerneration, must convert the BLOB data
					into UTF-8 string, or not checksum would not be correct.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_file: File full path name
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
integer	li_filenum, li_pos
string	ls_file_content, ls_checksum
blob		lb_file_content

mt_n_stringfunctions	lnv_stringfunctions

n_checksum lnv_checksum

lnv_checksum = create n_checksum

if not fileexists(as_file) then return c#return.Failure
li_filenum = fileopen(as_file, StreamMode!)

//Check the file share reading.
if filereadex(li_filenum, lb_file_content) = -1 then 
	fileclose(li_filenum)
	of_write_log(lnv_stringfunctions.of_replace(is_FILE_SHARE_READING, "${FILE}", as_file))
	return c#return.Failure
else
	ls_file_content = string(lb_file_content, EncodingUTF8!)
	//Deal with the file content, delete the checksum info:<CHECKSUM="B8D89F5C">
	if len(ls_file_content) > 0 then
		//Checksum No.
		ls_checksum = mid(ls_file_content, 1, pos(ls_file_content, "<REPORT>") - 1)
		li_pos = pos(ls_checksum, '"')
		ls_checksum = mid(ls_checksum, li_pos + 1, lastpos(ls_checksum, '"') - li_pos - 1)
		//Data content
		ls_file_content = mid(ls_file_content, pos(ls_file_content, "<REPORT>"), len(ls_file_content))
	end if
end if
fileclose(li_filenum)

//Check checksum
return lnv_checksum.of_validate_checksum(ls_file_content, ls_checksum)
end function

public function integer of_setup_log (string as_log_dir);/********************************************************************
   
   <DESC>	Set log directory	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-08-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
string ls_filename

if right(as_log_dir, 1) <> "\" then as_log_dir += "\"

ls_filename = as_log_dir + string(today(), is_format_date) + ".log"


inv_error_service.of_setoutput(2, ls_filename)

return c#return.Success
end function

public function integer of_write_log (string as_log_content);/********************************************************************
   of_write_log
   <DESC>	Write log to file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_log_content: Log content
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	11-01-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
inv_error_service.of_addmsg(this.classdefinition, "", as_log_content, "", 2)
inv_error_service.of_showmessages()

return c#return.Success
end function

on n_msps_interface.create
call super::create
end on

on n_msps_interface.destroy
call super::destroy
end on

event constructor;call super::constructor;//Register the log file service
inv_service_manager.of_loadservice(inv_error_service, "n_error_service")
end event

