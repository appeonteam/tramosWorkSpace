$PBExportHeader$n_safeportmemo.sru
forward
global type n_safeportmemo from nonvisualobject
end type
end forward

global type n_safeportmemo from nonvisualobject
end type
global n_safeportmemo n_safeportmemo

type variables
private	transaction	itr_source, itr_target	
private	n_ds			ids_error
private	integer		ii_logFileHandle
private	string			is_mailUser



end variables

forward prototypes
private function integer of_cleanup ()
private function integer of_openlogfile ()
private function integer of_readinifile ()
public subroutine of_writelog (string as_message)
public function integer of_controlsequence ()
private function integer of_replacespecialchar (ref string as_string)
private function integer of_correcterrors (ref string as_errormessage)
end prototypes

private function integer of_cleanup ();/* Destroy disconnect fron database and destroy objects */ 

if isValid( itr_source ) then
	rollback using itr_source;
	disconnect using itr_source;
	destroy itr_source
end if

if isValid( itr_target ) then
	rollback using itr_target;
	disconnect using itr_target;
	destroy itr_target
end if

destroy ids_error

FileWrite(ii_logFileHandle, string(today(), "dd. mmm-yyyy hh:mm")+" ***** Import of SafeMemo ended *****")
return FileClose(ii_logFileHandle)
end function

private function integer of_openlogfile ();/* Open the logfile and write start message */


ii_logFileHandle = FileOpen ( "safeportmemo.log", LineMode!, Write!, LockWrite!, Replace! )
if ii_logFileHandle > 0 then
	FileWrite(ii_logFileHandle, string(today(), "dd. mmm-yyyy hh:mm")+ " ***** Import of safememo started *****")
	return 1
else
	return -1
end if

end function

private function integer of_readinifile ();/* read inifile and set transaction and import filename variables */

/* Source dataset */
itr_source.DBMS = ProfileString ( "safeportmemo.ini", "sourcedatabase", "dbms", "failed" )
if itr_source.DBMS = "failed" then 
	of_writeLog("Read of source database.DBMS from INI-file failed!")
	return -1
end if
itr_source.servername = ProfileString ( "safeportmemo.ini", "sourcedatabase", "servername", "failed" )
if itr_source.servername = "failed" then 
	of_writeLog("Read of source database.Servername from INI-file failed!")
	return -1
end if
itr_source.LogID = ProfileString ( "safeportmemo.ini", "sourcedatabase", "userid", "failed" )
if itr_source.LogID = "failed" then 
	of_writeLog("Read of source database.Logid from INI-file failed!")
	return -1
end if
itr_source.LogPass = ProfileString ( "safeportmemo.ini", "sourcedatabase", "password", "failed" )
if itr_source.LogPass = "failed" then 
	of_writeLog("Read of source database.Password from INI-file failed!")
	return -1
end if
itr_source.AutoCommit = False
itr_source.DBParm = "Database='"+ProfileString ( "safeportmemo.ini", "sourcedatabase", "database", "failed" )+"'"
if itr_source.DBParm = "Database='failed'" then 
	of_writeLog("Read of source database.Database from INI-file failed!")
	return -1
end if
connect using itr_source;
if itr_source.SQLCode <> 0 then
	of_writeLog("Connecting to the Source database failed! --> " + itr_source.sqlerrtext)
	return -1
end if

/* Target dataset */
itr_target.DBMS = ProfileString ( "safeportmemo.ini", "targetdatabase", "dbms", "failed" )
if itr_target.DBMS = "failed" then 
	of_writeLog("Read of target database.DBMS from INI-file failed!")
	return -1
end if
itr_target.Database = ProfileString ( "safeportmemo.ini", "targetdatabase", "database", "failed" )
if itr_target.database = "failed" then 
	of_writeLog("Read of target database.Database from INI-file failed!")
	return -1
end if

itr_target.servername = ProfileString ( "safeportmemo.ini", "targetdatabase", "servername", "failed" )
if itr_target.servername = "failed" then 
	of_writeLog("Read of target database.Servername from INI-file failed!")
	return -1
end if
itr_target.LogID = ProfileString ( "safeportmemo.ini", "targetdatabase", "userid", "failed" )
if itr_target.LogID = "failed" then 
	of_writeLog("Read of target database.Logid from INI-file failed!")
	return -1
end if
itr_target.LogPass = ProfileString ( "safeportmemo.ini", "targetdatabase", "password", "failed" )
if itr_target.LogPass = "failed" then 
	of_writeLog("Read of target database.Password from INI-file failed!")
	return -1
end if
itr_target.AutoCommit = False
itr_target.DBParm = "Release='15', UTF8=1, appname='server_safeportmemo', host='server_safeportmemo'"

connect using itr_target;
if itr_target.SQLCode <> 0 then
	of_writeLog("Connecting to the target database failed!")
	return -1
end if

/* Get Tramos Mail User */
is_mailUser = ProfileString ( "safeportmemo.ini", "tramosmail", "mailaddress", "tramosmt@maersk.com" )

return 1
end function

public subroutine of_writelog (string as_message);FileWrite(ii_logFileHandle, as_message)
return
end subroutine

public function integer of_controlsequence ();/* This function is called from 'the outside' and controls the 
	sequence in which the functions are called
*/
string	ls_message, ls_errorMessage
long ll_rc
mt_n_outgoingmail	lnv_mail
pipeline	lpipe_safememo

itr_source = create transaction
itr_target = create transaction
ids_error = create n_ds

if of_openLogFile() = -1 then return -1

if of_readIniFile() = -1 then 
	of_cleanUp()
	return -1
end if
of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+" INI-file read ")

ls_message = ""
lpipe_safememo = create pipeline
lpipe_safememo.DataObject = "pipe_safeportmemo"
ll_rc = lpipe_safememo.Start(itr_source, itr_target, ids_error )
choose case ll_rc
	case  -1   
		ls_message="Pipe open failed"
	case -2   
		ls_message="Too many columns"
	case -3   
		ls_message="Table already exists"
	case -4   
		ls_message="Table does not exist"
	case -5   
		ls_message="Missing connection"
	case -6   
		ls_message="Wrong arguments"
	case -7   
		ls_message="Column mismatch"
	case -8   
		ls_message="Fatal SQL error in source"
	case -9   
		ls_message="Fatal SQL error in destination"
	case -10  
		ls_message="Maximum number of errors exceeded"
	case -12  
		ls_message="Bad table syntax"
	case -13  
		ls_message="Key required but not supplied"
	case -15  
		ls_message="Pipe already in progress"
	case -16  
		ls_message="Error in source database"
	case -17  
		ls_message="Error in destination database"
	case -18  
		ls_message="Destination database is read-only"
end choose

if ll_rc < 0 then
	of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+"Import of safememo failed. See message below")
	of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+ls_message)
	lnv_mail = create mt_n_outgoingmail
	if lnv_mail.of_createmail( "tramosmt@maersk.com", is_mailuser , "Import of safememo failed.", ls_message, ls_errorMessage) = -1 then
		of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+ " Create mail failed!")
	else
		lnv_mail.of_setCreator("HHE024", ls_errorMessage )  //set mail creator as this application is not running using tramos id
		if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
			of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+ " Send mail failed!")
		end if
	end if	
	destroy lnv_mail
	of_cleanup( )
	return -1
end if

if ids_error.rowcount() > 0 then
	if of_correcterrors( ls_errorMessage ) = -1 then 
		of_writelog(string(today(), "dd. mmm-yyyy hh:mm")+ ls_errorMessage )
		lnv_mail = create mt_n_outgoingmail
		if lnv_mail.of_createmail( "tramosmt@maersk.com", is_mailuser , "Import of REPAIRED safememoes failed.", ls_errorMessage, ls_errorMessage) = -1 then
			of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+ " Create mail failed!")
		else
			lnv_mail.of_setCreator("HHE024", ls_errorMessage )  //set mail creator as this application is not running using tramos id
			if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
				of_writeLog(string(today(), "dd. mmm-yyyy hh:mm")+ " Send mail failed!")
			end if
		end if	
		destroy lnv_mail
		of_cleanup( )
		return -1
	end if
end if

of_cleanUp()
return 1
end function

private function integer of_replacespecialchar (ref string as_string);integer ll_length, ll_start

ll_length = len(as_string)

FOR ll_start=1  TO ll_length
	if (asc(Mid(as_string,ll_start)) < 12) then
		 as_string = replace(as_string, ll_start, 1, "#")
	end if
	if (asc(Mid(as_string,ll_start)) = 34) then
		 as_string = replace(as_string, ll_start, 1, "#")
	end if
	if (asc(Mid(as_string,ll_start)) = 39) then
		 as_string = replace(as_string, ll_start, 1, "#")
	end if
	if (asc(Mid(as_string,ll_start)) > 256) then
		 as_string = replace(as_string, ll_start, 1, "#")
	end if
NEXT

return 1

end function

private function integer of_correcterrors (ref string as_errormessage);long ll_rows, ll_row
string ls_temptext
n_ds  lds_repair
long ll_newrow

lds_repair = create n_ds

lds_repair.dataObject = "d_safememo_repair"
lds_repair.setTransObject(itr_target)

ll_rows = ids_error.rowCount()
//Error Handling
for ll_row = 1 to ll_rows
	ll_newrow = lds_repair.insertRow(0)

	lds_repair.setItem(ll_newrow, 1, ids_error.getItemString(ll_row, 2))
	lds_repair.setItem(ll_newrow, 2, ids_error.getItemString(ll_row, 3))
	lds_repair.setItem(ll_newrow, 3, ids_error.getItemString(ll_row, 4))
	lds_repair.setItem(ll_newrow, 4, ids_error.getItemString(ll_row, 5))

	/* Short Description */
	ls_temptext = ids_error.getItemString(ll_row, 6)
	of_replaceSpecialChar(ls_temptext)
	lds_repair.setItem(ll_newrow, 5, ls_temptext)
	
	lds_repair.setItem(ll_newrow, 6, ids_error.getItemString(ll_row, 7))
	lds_repair.setItem(ll_newrow, 7, datetime(ids_error.getItemString(ll_row, 8)))

	/* Detail */
	ls_temptext = ids_error.getItemString(ll_row, 9)
	of_replaceSpecialChar(ls_temptext)
	lds_repair.setItem(ll_newrow, 8, ls_temptext)
	
	/* Security Detail */
	ls_temptext = ids_error.getItemString(ll_row, 10)
	of_replaceSpecialChar(ls_temptext)
	lds_repair.setItem(ll_newrow, 9, ls_temptext)
next

if lds_repair.update() = 1 then
	Commit USING itr_target ;
else
	rollback USING itr_target;
	as_errormessage="Error updating repaired safeportmemoes"
	destroy lds_repair
	return -1
end if

destroy lds_repair
return 1
end function

on n_safeportmemo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_safeportmemo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

