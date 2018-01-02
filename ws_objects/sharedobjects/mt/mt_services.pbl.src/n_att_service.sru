$PBExportHeader$n_att_service.sru
forward
global type n_att_service from mt_n_baseservice
end type
end forward

shared variables
n_fileattach_trans iuo_fdbtranset
end variables

global type n_att_service from mt_n_baseservice
end type
global n_att_service n_att_service

type variables
public:
boolean ib_PostponeMessageBox = false

end variables

forward prototypes
public function integer _appendmessage (string as_methodname, string as_message, string as_devmessage)
public function string of_getfiledbname ()
public function string of_getfiledbname (long al_file_id)
public function boolean of_isfiledbreadonly (string as_dbname)
public function mt_n_transaction of_connectfiledb (string as_dbname)
public function mt_n_transaction of_connectfiledb ()
public function integer of_writeattach (long al_fileid, ref blob abl_filecontent, long al_filesize, mt_n_transaction atr_object)
protected function integer of_setfiledbname (long al_file_id, string as_dbname, ref string as_errmsg)
public function integer of_convertblob (long al_fileid, ref blob abl_filecontent, ref olecontrol aole_container, string as_filenamepath, ref longlong all_filesize)
public function integer of_readattach (long al_fileid, ref blob abl_filecontent, ref longlong all_filesize)
public function integer of_deleteattach (long al_file_id, mt_n_transaction atr_object)
end prototypes

public function integer _appendmessage (string as_methodname, string as_message, string as_devmessage);return _addmessage(this.classdefinition, as_methodname, as_message, as_devmessage, not ib_PostponeMessageBox)
end function

public function string of_getfiledbname ();/********************************************************************
   of_getfiledbname
   <DESC>	Get the current file database name	</DESC>
   <RETURN>	string:
            <LI> the name of database if succeed
            <LI> null if failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Called when read or write a file to/from the file database	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   File database archiving
   </HISTORY>
********************************************************************/

string ls_dbname
string ls_deverrmsg
constant string METHOD = "of_getfiledbname()"
constant string ERRMSG = "Cannot get the current file database name."

// Execute procedure:
// SP_GET_CURRENT_FILEDB

// Declare a procedure.
DECLARE SP_GET_CURRENT_FILEDB PROCEDURE FOR
	SP_GET_CURRENT_FILEDB @DB_NAME = :ls_dbname /*OUTPUT*/
USING SQLCA;

// Execute the procedure
EXECUTE SP_GET_CURRENT_FILEDB;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	SetNull(ls_dbname)
	CLOSE SP_GET_CURRENT_FILEDB;
	_appendmessage(METHOD, ERRMSG, ls_deverrmsg)
	return ls_dbname
end if

// Get the result
FETCH SP_GET_CURRENT_FILEDB INTO :ls_dbname;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	SetNull(ls_dbname)
	CLOSE SP_GET_CURRENT_FILEDB;
	_appendmessage(METHOD, ERRMSG, ls_deverrmsg)
	return ls_dbname
end if

// Close the procedure
CLOSE SP_GET_CURRENT_FILEDB;
return ls_dbname

end function

public function string of_getfiledbname (long al_file_id);/********************************************************************
   of_getfiledbname
   <DESC>	Get the file database name from the table in Tramos	</DESC>
   <RETURN>	string:
            <LI> file database name if succeeded
            <LI> null if failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_file_id   : file id
   </ARGS>
   <USAGE>	Called when reading a file	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014    First Version
   </HISTORY>
********************************************************************/

string ls_dbname
string ls_deverrmsg
constant string METHOD = "of_getfiledbname()"
constant string ERRMSG = "Cannot get the file database name."

SELECT DB_NAME INTO :ls_dbname
FROM ATTACHMENTS
WHERE FILE_ID = :al_file_id;

if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	SetNull(ls_dbname)
	_appendmessage(METHOD, ERRMSG, ls_deverrmsg)
	return ls_dbname
end if

return ls_dbname

end function

public function boolean of_isfiledbreadonly (string as_dbname);/********************************************************************
   of_isfiledbreadonly
   <DESC>	Check if the file database is read-only	</DESC>
   <RETURN>	boolean:
            <LI> true, read-only
            <LI> false, updateable	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_dbname
   </ARGS>
   <USAGE>	Called when deleting or writing a file	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   File database archiving
   </HISTORY>
********************************************************************/

long ll_rc
string ls_deverrmsg
boolean lb_autocommit
constant string METHOD = "of_isfiledbreadonly()"
string ls_errmsg

// Execute procedure:
// SP_IS_FILEDB_READONLY

ls_errmsg = "Failed to check if the file database '" + as_dbname + "' is read-only."

// Declare a procedure
DECLARE SP_IS_FILEDB_READONLY PROCEDURE FOR
	SP_IS_FILEDB_READONLY @DB_NAME = :as_dbname
USING SQLCA;

// Execute the procedure
EXECUTE SP_IS_FILEDB_READONLY;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	CLOSE SP_IS_FILEDB_READONLY;
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg )
	return false
end if

// Get the result
FETCH SP_IS_FILEDB_READONLY INTO :ll_rc;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	CLOSE SP_IS_FILEDB_READONLY;
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg )
	return false
end if

// Close the procedure
CLOSE SP_IS_FILEDB_READONLY;
return (ll_rc = 1)

end function

public function mt_n_transaction of_connectfiledb (string as_dbname);/********************************************************************
   of_connectfiledb
   <DESC>	Connect to the file database	</DESC>
   <RETURN>	mt_n_transaction:
            <LI> a valid object of mt_n_transaction if succeeded
            <LI> an invalid object of mt_n_transaction if failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
		as_dbname : the file database name
   </ARGS>
   <USAGE>	Called when reading or writing a file from/to the file database
	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_rc
mt_n_transaction ltr_invalid, ltr_found
long ll_i

if isnull(as_dbname) or as_dbname='' then
	return ltr_invalid
end if

ltr_found = iuo_fdbtranset.of_get(as_dbname, true)
if isnull(ltr_found) or not isvalid(ltr_found) then
	return ltr_invalid
end if

ll_rc = 0
if not ltr_found.of_is_connected() then
	connect using ltr_found;
	if ltr_found.SQLCode <> 0 then
		ll_rc = -1
		_appendmessage("of_connectfiledb()", "Cannot connect file database '" + as_dbname + "'", &
			ltr_found.SQLErrText )
	end if
end if

if ll_rc <> 0 then
	return ltr_invalid
end if

return ltr_found
end function

public function mt_n_transaction of_connectfiledb ();/********************************************************************
   of_connectfiledb
   <DESC>	Connect to the current file database	</DESC>
   <RETURN>	mt_n_transaction:
            <LI> a valid object of mt_n_transaction if succeeded
            <LI> an invalid object of mt_n_transaction if failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Called when read, write	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR0937        SSX014   First Version
   </HISTORY>
********************************************************************/

return of_connectfiledb(of_getfiledbname())

end function

public function integer of_writeattach (long al_fileid, ref blob abl_filecontent, long al_filesize, mt_n_transaction atr_object);/********************************************************************
   of_writeattach
   <DESC>	A new interface to write the blob directly into the file database
	</DESC>
   <RETURN>	integer:
      <LI> 1, X Success  : committed transaction
		<LI> -1, X Failed  : Transaction failed. Rollback made.
		<LI> 0, X NoAction : Ready for manual commit.
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
				al_fileid       : file id
				abl_filecontent : a blob contains the file content
				al_filesize     : the size of the file
				atr_object      : the transaction object
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

constant string METHOD = "of_writeattach()"

long		 		ll_fileid
string         ls_errmsg
string         ls_deverrmsg
long           ll_rc
mt_n_transaction lnv_trans
boolean        lb_selfmanagedtrans
string         ls_dbname

//connect to the current file database
if not isnull(atr_object) and isvalid(atr_object) then
	lnv_trans = atr_object
	lb_selfmanagedtrans = false
else
	lnv_trans = of_connectfiledb()
	if isnull(lnv_trans) or not isvalid(lnv_trans) then
		return c#return.Failure
	end if
	lb_selfmanagedtrans = true
end if

//check if existing
SetNull(ll_fileid)
SELECT FILE_ID INTO :ll_fileid
FROM ATTACHMENTS_FILES WHERE FILE_ID = :al_fileid
USING lnv_trans;
if lnv_trans.sqlcode = -1 THEN
	ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Select table failed~r~n~r~nsqlerrtext = " + lnv_trans.sqlerrtext
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg )
	return c#return.Failure
end if

//insert a new one if not existing
if isnull(ll_fileid) then
	INSERT INTO ATTACHMENTS_FILES(FILE_ID,FILE_SIZE)VALUES(:al_fileid,:al_filesize)
	USING lnv_trans;
	if lnv_trans.sqlcode <> 0 THEN
		ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
		ls_deverrmsg = "Insert table failed~r~n~r~nsqlerrtext = " + lnv_trans.sqlerrtext
		ROLLBACK USING lnv_trans;
		if lb_selfmanagedtrans then lnv_trans.of_disconnect()
		_appendmessage(METHOD, ls_errmsg, ls_deverrmsg )
		return c#return.Failure
	end if
end if

//put the file directly into the table
UPDATEBLOB ATTACHMENTS_FILES
SET FILE_CONTENT = :abl_filecontent
WHERE FILE_ID = :al_fileid
USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error attaching file.  Maybe the file selected is empty? It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Update table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//set the database name
ll_rc = of_setfiledbname(al_fileid, lnv_trans.database, ls_errmsg)
if ll_rc = c#return.Failure then
	ROLLBACK USING lnv_trans;
	ROLLBACK USING SQLCA;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, "Update DB_NAME failed.", "")
	RETURN c#return.Failure
end if

if lb_selfmanagedtrans then
	// Commit both
	COMMIT USING SQLCA;
	COMMIT USING lnv_trans;
	
	// Disconnect
	lnv_trans.of_disconnect();
	return c#return.Success
else
	// This case needs a commit to be made manually.
	return c#return.NoAction
end if

end function

protected function integer of_setfiledbname (long al_file_id, string as_dbname, ref string as_errmsg);/********************************************************************
   of_setfiledbname
   <DESC>	Update the DB_NAME field in Tramos	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
		al_file_id    : file id
		as_dbname     : database name
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_errmsg

UPDATE ATTACHMENTS SET DB_NAME = :as_dbname WHERE FILE_ID = :al_file_id;

if SQLCA.SQLCode = -1 then
	ls_errmsg = SQLCA.SQLErrText
	ROLLBACK USING SQLCA;
	as_errmsg = "of_setfiledbname()~r~n"+ls_errmsg
	return c#return.Failure
end if

// Be were that the transaction is not committed

return c#return.Success

end function

public function integer of_convertblob (long al_fileid, ref blob abl_filecontent, ref olecontrol aole_container, string as_filenamepath, ref longlong all_filesize);/********************************************************************
   of_convertblob()
   <DESC>
		This function is to read the file content into a blob variable
	</DESC>
   <RETURN> 
		Integer:	
			<LI> 0, X Success
			<LI> -1, X Failed						
	</RETURN>
   <ACCESS> 
		Public
	</ACCESS>
   <ARGS>   
		al_fileid			:
		abl_filecontent 	:<reference>file content need to be put into a blob
		aole_container	 	:<reference>ole container
		as_filenamepath	:
		all_filesize			:
	</ARGS>
   <USAGE>
		We need to use 3 methods when converting files saved through the ole control, determined
		by the extension/type
		
		1. Microsoft Applications Excel, Powerpoint, Access, Word (all versions)
			Just close the container down and click on close in the info message window
		
		2. Outlook 2003
			You must manually 'save as' within ole container. select type standard Outlook Mesasge *.msg.  
			Paste from clipboard the file and path we want to use.
			Close the container and click on close in the info message window
		
		3. All other file types including pdf, bmp, jpg, png etc.
			Manually 'save as' determined by application that opened your attachment. 
			Paste from clipboard the file and path reference.
			Close container and click close in the info message window.  
			
			All all cases Tramos will then replace the atatchment in the database.
	</USAGE>
	<HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR0937        SSX014   First Version
   </HISTORY>
********************************************************************/

constant string METHOD_NAME="of_convertblob()"
long ll_filehandle, ll_filesize
integer li_retval
string ls_microsoftapplist, ls_extension
w_fileattach_converter w_temp
mt_n_transaction lnv_invalid
string ls_errmsg
string ls_deverrmsg

ls_extension = mid(as_filenamepath,lastpos(as_filenamepath,".")) + "|"

ls_microsoftapplist = ".ppt|.doc|.xls|.mdb|"

/* and we also need to test the way it was saved previously */
TRY

	aole_container.objectdata = abl_filecontent
	aole_container.Activate(OffSite!)

	if pos(ls_microsoftapplist,ls_extension) > 0 then
		aole_container.SaveAs(as_filenamepath)
		ls_errmsg = "(option1) Microsoft attachment -  close the olecontainer and then this infobox. Attachment will be saved into database"
		ls_deverrmsg = "Manual User Step"
		_appendmessage( METHOD_NAME, ls_errmsg, ls_deverrmsg)
	else
		::Clipboard(as_filenamepath)
		if ls_extension=".msg|" then
			ls_errmsg = "(option2) Outlook Message - Manually 'Save As' the olecontainer and then close it.  Next close this info window and Tramos will save converted file into the database."
			ls_deverrmsg = "this is an instruction to the user!"
			_appendmessage( METHOD_NAME, ls_errmsg, ls_deverrmsg)
		else
			ls_errmsg = "(option3) File needs converting - 'Save As' the olecontainer and close it.  Next close this info window and Tramos will save converted file into the database."
			ls_deverrmsg = "this is an instruction to the user!"
			_appendmessage( METHOD_NAME, ls_errmsg, ls_deverrmsg)
		end if
	end if
	aole_container.Clear()
	setnull(abl_filecontent)

	ll_filehandle = fileopen(as_filenamepath, StreamMode!, Read!, LockRead!)
	all_filesize = filereadex( ll_filehandle, abl_filecontent )
	fileclose(ll_filehandle)
	If all_filesize > 0 then filedelete(as_filenamepath)

	if of_writeattach( al_fileid, abl_filecontent, Len(abl_filecontent), lnv_invalid) = c#return.Failure then 
		return c#return.Failure
	end if

CATCH ( Throwable ex )
	return c#return.NoAction
FINALLY  
	/* nothing to do */
END TRY

return c#return.Success

end function

public function integer of_readattach (long al_fileid, ref blob abl_filecontent, ref longlong all_filesize);/********************************************************************
   of_readattach
   <DESC>	A new interface to read the blob directly from the file database
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_fileid       : file id
		abl_filecontent : file content need to be put into a blob
		all_filesize    : the file size that will be returned to the calling if the passed value is not null
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/07/15 CR3907        SSX014   File database archiving
   </HISTORY>
********************************************************************/

constant string METHOD = "of_readattach()"

mt_n_transaction     lnv_trans
string   ls_deverrmsg
string   ls_errmsg

//connect to the file database
lnv_trans = of_connectfiledb(of_getfiledbname(al_fileid))
if isnull(lnv_trans) or not isvalid(lnv_trans) then
	return c#return.Failure
end if

/* select the file content from the table into the blob */
SELECTBLOB FILE_CONTENT
INTO :abl_filecontent
FROM ATTACHMENTS_FILES
WHERE FILE_ID = : al_fileid
USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:SelectBlob from the table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

if not isnull(all_filesize) then
	SELECT DATALENGTH(FILE_CONTENT)
	INTO :all_filesize
	FROM ATTACHMENTS_FILES
	WHERE FILE_ID = : al_fileid
	USING lnv_trans;
	if lnv_trans.sqlcode <> 0 then
		ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
		ls_deverrmsg = "Open Attachment:Getting the size of the file from the temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
		ROLLBACK USING lnv_trans;
		lnv_trans.of_disconnect()
		_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
		return c#return.Failure
	end if
end if

/* Sucessfully obtained blob from FILES database! */
lnv_trans.of_disconnect()
return c#return.Success

end function

public function integer of_deleteattach (long al_file_id, mt_n_transaction atr_object);/********************************************************************
   of_deleteblob
   <DESC>	This function is to delete the file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed
				<LI> c#return.NoAction: 0, ok
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename : table name
		al_fileid    : file id
		atr_object   : an object of mt_n_transaction
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First Version
		18/09/15 CR3907        SSX014   File database archiving
   </HISTORY>
********************************************************************/

STRING		ls_sql_delete
constant    string METHOD = "of_deleteattach()"
boolean     lb_selfmanagedtrans
mt_n_transaction        lnv_trans
string      ls_deverrmsg
string      ls_errmsg
string      ls_dbname

//connect to the file database
if isnull(atr_object) or not isvalid(atr_object) then
	lnv_trans = of_connectfiledb()
	if isnull(lnv_trans) or not isvalid(lnv_trans) then
		return c#return.Failure
	end if
	lb_selfmanagedtrans = true
else
	lnv_trans = atr_object
	lb_selfmanagedtrans = false
end if

//delete the record
ls_sql_delete = "DELETE FROM ATTACHMENTS_FILES WHERE FILE_ID = "+STRING(al_file_id)
EXECUTE IMMEDIATE :ls_sql_delete USING lnv_trans;

if lnv_trans.sqlcode = -1 then
	ls_errmsg = "Error deleting file. It was not possible to delete the file referenced #" + string(al_file_id)
	ls_deverrmsg = "Delete table failed~r~n~r~nsqlerrtext = " + lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
else
	if lb_selfmanagedtrans then
		COMMIT USING lnv_trans;
		lnv_trans.of_disconnect()
		return c#return.NoAction
	end if	
	return c#return.Success
end if

end function

on n_att_service.create
call super::create
end on

on n_att_service.destroy
call super::destroy
end on

