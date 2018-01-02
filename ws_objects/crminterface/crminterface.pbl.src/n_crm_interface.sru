$PBExportHeader$n_crm_interface.sru
forward
global type n_crm_interface from mt_n_nonvisualobject
end type
end forward

global type n_crm_interface from mt_n_nonvisualobject
end type
global n_crm_interface n_crm_interface

type variables
mt_n_stringfunctions	inv_stringfunctions	//Commend line parameters resolving object
n_error_service		inv_error_service		//Log file service
n_service_manager		inv_service_manager	//Service manager

constant string	is_format_date = "yyyy-mm-dd"						//Date format
constant string	is_format_date_time = "yyyy-mm-dd hh:mm:ss" //Date time fromat

//Log on a new excution phase
constant string	is_LOG_INTERFACE_START 		  = "----------------------CRM interface started----------------------"
constant string	is_LOG_INTERFACE_END	 		  = "----------------------CRM interface ended------------------------"

constant string	is_LOG_SENDER				= "Email sender option is found: ${SENDER}"
constant string	is_LOG_SENDER_NO			= "Email sender option is not found: ${SENDER}"
constant string	is_LOG_RECEIVER			= "Email receiver option is found: ${RECEIVER}"
constant string	is_LOG_RECEIVER_NO		= "Email receiver option is not found: ${RECEIVER}"
constant string 	is_LOG_DB_CONN_SUCCESS	= "Database connection succeeded"
constant string 	is_LOG_DATA_SUCCESS		= "Data retrieving succeeded"
constant string 	is_LOG_CSV_SUCCESS		= "Saving data as CSV format succeeded"


constant string	is_LOG_FOLDER 		= "Log folder option is found: ${FOLDER}"
constant string	is_LOG_FOLDER_NO 	= "Log folder is not found, log folder changed to application location"
constant string	is_LOG_MODE 		= "Running mode option is found: ${MODE}"
constant string	is_LOG_MODE_NO		= "Running mode option is not found: ${MODE}"
constant string	is_LOG_LEVEL		= "Log level is found: ${LEVEL}"
constant string	is_LOG_LEVEL_NO	= "Log level is not found, it would be set to be 'low' by default"
constant string	is_LOG_FILE_EXIST = "The CSV file exists, it would be deleted"

constant string	is_LOG_SERVER 				= "Server name is found: ${SERVER}"
constant string	is_LOG_SERVER_NO			= "Server name is not found: ${SERVER}"
constant string	is_LOG_DATABASE 			= "Database name found: ${DB}"
constant string	is_LOG_DATABASE_NO		= "Database name is not found: ${DB}"
constant string	is_LOG_EXPORT 				= "Export name for finance or recent spot fixuture is found: ${EXPORT}"
constant string	is_LOG_EXPORT_NO			= "Export name for finance or recent spot fixuture is not found: ${EXPORT}"
constant string	is_LOG_FOLDER_FILE 		= "Exported data file folder is found: ${FOLDER}"
constant string	is_LOG_FOLDER_FILE_NO 	= "Exported data file folder is not found"
constant string 	is_LOG_DB_CONN_FAILED	= "Database connection failed"
constant string 	is_LOG_DATA_FAILED		= "Data retrieving failed"
constant string	is_LOG_FOLDER_CREATION 	= "Folder creation error occured ${FOLDER}, file folder is changed to application location"
constant string 	is_LOG_CSV_FAILED			= "Saving data as CSV format failed"
constant string	is_LOG_FILE_DELETE		= "The CSV file exists, failed to be deleted"

end variables

forward prototypes
public function integer of_set_database (s_command_line astr_command_line)
public function integer of_connect_database ()
public function string of_get_application_location ()
public function integer of_write_log (string as_log_content)
public function integer of_set_log_dir (string as_log_dir)
public function integer of_get_parameters (ref s_command_line astr_command_line, string as_commandline)
public function integer of_write_log (string as_content, string as_log_level, string as_log_level_content)
public subroutine documentation ()
end prototypes

public function integer of_set_database (s_command_line astr_command_line);/********************************************************************
   of_set_database
   <DESC>	Set database parameters	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_command_line: Command line data structrure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09-08-2012 CRM           JMY014        First Version
   </HISTORY>
********************************************************************/
SQLCA.DBMS 			= "SYC Sybase System 10"
SQLCA.Database 	= astr_command_line.as_database
SQLCA.ServerName 	= astr_command_line.as_server
SQLCA.LogId 		= "adminServerApp"
SQLCA.LogPass 		= "LKJHGFdsa!##"
SQLCA.AutoCommit 	= False
SQLCA.Dbparm 		= "OJSyntax='PB', release = '15'"

return c#return.Success
end function

public function integer of_connect_database ();/********************************************************************
   of_connect_database
   <DESC>	Connect to database	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09-08-2012 CRM           JMY014        First Version
		29-04-2012 CR3221			LHC010			add log
   </HISTORY>
********************************************************************/
if sqlca.dbhandle() = 0 then 
	connect using sqlca;
	if sqlca.sqlcode <> 0 then 
		_addmessage( this.classdefinition, "of_connect_database", "database error, cannot initalise application, check the server and database parameters" , "cannot connect to db transaction!")
		rollback;
		disconnect using sqlca;		
		return c#return.Failure
	end if
end if

return c#return.Success
end function

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

public function integer of_write_log (string as_log_content);/********************************************************************
   of_write_log
   <DESC>	Write log to file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_log_dir: Log file directory
		as_log_content: Log content
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09-08-2012 CRM          JMY014        First Version
   </HISTORY>
********************************************************************/
inv_error_service.of_addmsg(this.classdefinition, "", as_log_content, "", 2)
inv_error_service.of_showmessages()

return c#return.Success
end function

public function integer of_set_log_dir (string as_log_dir);/********************************************************************
   
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
   	15-08-2012 CRM           JMY014        First Version
   </HISTORY>
********************************************************************/
string ls_filename

if right(as_log_dir, 1) <> "\" then as_log_dir += "\"

ls_filename = as_log_dir + string(today(), is_format_date) + ".log"


inv_error_service.of_setoutput(2, ls_filename)

return c#return.Success
end function

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
   	09-08-2012 CRM           JMY014        First Version
		30-04-2012 CR3221			LHC010			Add parameter 'emailto' to commandline.
   </HISTORY>
********************************************************************/

string	ls_log_level
string	ls_emailto

//Get the log level
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/log:", astr_command_line.as_log_level, true) = c#return.Failure then
	ls_log_level = is_LOG_LEVEL_NO
	astr_command_line.as_log_level = "low"
else
	ls_log_level = inv_stringfunctions.of_replace(is_LOG_LEVEL, "${LEVEL}", astr_command_line.as_log_level)
end if
//Get log folder
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/logfolder:", astr_command_line.as_folder_log, true) = c#return.Failure then
	//Write log to the current application location
	astr_command_line.as_folder_log = of_get_application_location()
	of_set_log_dir(astr_command_line.as_folder_log)
	of_write_log( is_LOG_INTERFACE_START, astr_command_line.as_log_level, c#log_level.is_LOW)
	of_write_log( ls_log_level, astr_command_line.as_log_level, c#log_level.is_LOW)
	of_write_log( is_LOG_FOLDER_NO, astr_command_line.as_log_level,c#log_level.is_HIGH)
else
	if not fileexists(astr_command_line.as_folder_log) then 
		if createdirectory (astr_command_line.as_folder_log) = -1 then
			astr_command_line.as_folder_log = of_get_application_location()
			//When log folder creation error, write log to the current application location
			of_set_log_dir(astr_command_line.as_folder_log)
			of_write_log( is_LOG_INTERFACE_START, astr_command_line.as_log_level, c#log_level.is_LOW)
			of_write_log( ls_log_level, astr_command_line.as_log_level, c#log_level.is_LOW)
			of_write_log( inv_stringfunctions.of_replace(is_LOG_FOLDER_CREATION, "${FOLDER}", astr_command_line.as_folder_log), astr_command_line.as_log_level, c#log_level.is_HIGH)
		end if
	else
		of_set_log_dir(astr_command_line.as_folder_log)
		of_write_log( is_LOG_INTERFACE_START, astr_command_line.as_log_level, c#log_level.is_LOW)
		of_write_log( ls_log_level, astr_command_line.as_log_level, c#log_level.is_LOW)
		of_write_log( inv_stringfunctions.of_replace(is_LOG_FOLDER, "${FOLDER}", astr_command_line.as_folder_log), astr_command_line.as_log_level, c#log_level.is_HIGH)
	end if
end if
//Get exported CSV data file folder
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/filefolder:", astr_command_line.as_folder_file, true) = c#return.Failure then
	of_write_log( is_LOG_FOLDER_FILE_NO, astr_command_line.as_log_level, c#log_level.is_HIGH)
	return c#return.Failure
else
	if not fileexists(astr_command_line.as_folder_file) then 
		if createdirectory (astr_command_line.as_folder_log) = -1 then
			astr_command_line.as_folder_log = of_get_application_location()
			//When log folder creation error, write log to the current application location
			of_write_log( inv_stringfunctions.of_replace(is_LOG_FOLDER_CREATION, "${FOLDER}", astr_command_line.as_folder_file), astr_command_line.as_log_level, c#log_level.is_MEDIUM)
		end if
	end if
	of_write_log( inv_stringfunctions.of_replace(is_LOG_FOLDER_FILE, "${FOLDER}", astr_command_line.as_folder_file), astr_command_line.as_log_level, c#log_level.is_MEDIUM)
end if

//Get server name, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/server:", astr_command_line.as_server, true) = c#return.Failure then
	of_write_log( inv_stringfunctions.of_replace(is_LOG_SERVER_NO, "${SERVER}", astr_command_line.as_server), astr_command_line.as_log_level, c#log_level.is_HIGH)
	return c#return.Failure
else
	of_write_log( inv_stringfunctions.of_replace(is_LOG_SERVER, "${SERVER}", astr_command_line.as_server), astr_command_line.as_log_level, c#log_level.is_LOW)
end if
//Get database name, this is a mandatary option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/db:", astr_command_line.as_database, true) = c#return.Failure then
	of_write_log( is_LOG_DATABASE_NO, astr_command_line.as_log_level, c#log_level.is_HIGH)
	return c#return.Failure
else
	of_write_log( inv_stringfunctions.of_replace(is_LOG_DATABASE, "${DB}", astr_command_line.as_database), astr_command_line.as_log_level, c#log_level.is_LOW)
end if

//Get application running mode
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/mode:", astr_command_line.as_mode, true) = c#return.Failure then
	//Set default running mode to "hidewindow"
	of_write_log( inv_stringfunctions.of_replace(is_LOG_MODE_NO, "${MODE}", astr_command_line.as_mode), astr_command_line.as_log_level, c#log_level.is_MEDIUM)
	return c#return.Failure
else
	of_write_log( inv_stringfunctions.of_replace(is_LOG_MODE, "${MODE}", astr_command_line.as_mode), astr_command_line.as_log_level, c#log_level.is_LOW)
end if

//Get export data option
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/export:", astr_command_line.as_export, true) = c#return.Failure then
	of_write_log( inv_stringfunctions.of_replace(is_LOG_EXPORT_NO, "${EXPORT}", astr_command_line.as_export), astr_command_line.as_log_level, c#log_level.is_HIGH)
	return c#return.Failure
else
	of_write_log( inv_stringfunctions.of_replace(is_LOG_EXPORT, "${EXPORT}", astr_command_line.as_export), astr_command_line.as_log_level, c#log_level.is_LOW)
end if

//Send mail to receiver when a database error occurs
if inv_stringfunctions.of_getcommandlineparm(as_commandline, "/emailto:", ls_emailto, true) = c#return.Failure then
	of_write_log( inv_stringfunctions.of_replace(is_LOG_RECEIVER_NO, "${RECEIVER}", ls_emailto), astr_command_line.as_log_level, c#log_level.is_HIGH)
	return c#return.Failure
else
	of_write_log( inv_stringfunctions.of_replace(is_LOG_RECEIVER, "${RECEIVER}", ls_emailto), astr_command_line.as_log_level, c#log_level.is_LOW)
end if

inv_stringfunctions.of_split(astr_command_line.as_emailto, ls_emailto, ";")

return c#return.Success
end function

public function integer of_write_log (string as_content, string as_log_level, string as_log_level_content);/********************************************************************
   of_write_log
   <DESC>	According to the log level from command line parameter,
				write the log content to log file.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_content: Log content
		as_log_level: Log level from command line
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10-08-2012 CRM           JMY014        First Version
   </HISTORY>
********************************************************************/
choose case lower(as_log_level)
	//Write low/medium/high level log
	case c#log_level.is_LOW
		of_write_log(as_content)
	//Write medium/high level log
	case c#log_level.is_MEDIUM
		if as_log_level_content = c#log_level.is_MEDIUM or as_log_level_content = c#log_level.is_HIGH then
			of_write_log(as_content)
		end if
	//Write high level log only
	case c#log_level.is_HIGH
		if as_log_level_content = c#log_level.is_HIGH then
			of_write_log(as_content)
		end if
	case else
		return c#return.Failure
end choose

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-04-2013 CR3221       LHC010        Sent mail to administrator when a critical error occurs
   </HISTORY>
********************************************************************/
end subroutine

on n_crm_interface.create
call super::create
end on

on n_crm_interface.destroy
call super::destroy
end on

event constructor;call super::constructor;//Register the log file service
inv_service_manager.of_loadservice(inv_error_service, "n_error_service")
end event

