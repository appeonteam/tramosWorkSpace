$PBExportHeader$n_fileattach_service.sru
forward
global type n_fileattach_service from mt_n_baseservice
end type
end forward

shared variables
n_fileattach_trans iuo_fdbtranset
end variables

global type n_fileattach_service from mt_n_baseservice
end type
global n_fileattach_service n_fileattach_service

type variables

transaction itr_tramos_file // OBSOLETE!!! Do not use
public:
constant string ATTACHMENTS_TABLE = "ATTACHMENTS_FILES"

// In previous version of this object, a message box pops up whenever an error occurs.
// This is not correct!
// For example, In u_fileattach the structure of the code is like below
//
// ...
// if dw_file_listing.update(true, false) = 1 then
//     ...
//     // It's dangerous to pop up a message box
//     lnv_attservice.of_deleteblob(...) or
//     lnv_attservice.of_writeblob(...)
//     ...
//     // check
//     if lb_files_trans_success then
//         // commit
//     else
//         // rollback
//         // That the message box goes here is correct
//     end if
// end if
////////////////////////

boolean ib_PostponeMessageBox = false

end variables

forward prototypes
public function integer of_read (string as_tablename, long al_fileid, ref blob abl_filecontent)
public function integer of_delete (string as_tablename, long al_fileid)
public function integer of_write (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize)
public function integer of_activate ()
public function integer of_deactivate ()
public function integer of_commit ()
public function integer of_rollback ()
public function integer of_readblob (string as_tablename, long al_fileid, ref blob abl_filecontent)
public function integer of_convertblob (string as_tablename, long al_fileid, ref blob abl_filecontent, ref olecontrol aole_container, string as_filenamepath, ref long al_filesize)
public function integer of_validatefileid (string as_tablename, long al_source_fileid)
public function mt_n_transaction of_connectfiledb ()
public function string of_getfiledbname (long al_file_id, string as_tablename)
protected function integer of_setfiledbname (long al_file_id, string as_tablename, string as_dbname, ref string as_errmsg)
public function integer of_deleteblob (string as_tablename, long al_fileid, mt_n_transaction atr_object)
protected function mt_n_transaction of_connectfiledb (string as_dbname)
public subroutine documentation ()
public function string of_getfiledbname ()
public function integer of_writeblob (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize, boolean ab_autocommit)
public function integer of_deleteblob (string as_tablename, long al_fileid, boolean ab_autocommit)
public function boolean of_isfiledbreadonly (string as_dbname)
public function boolean of_postponemessagebox (boolean ab_switch)
private function integer _appendmessage (string as_methodname, string as_message, string as_devmessage)
public function integer of_writeblob (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize, mt_n_transaction atr_object)
public function integer of_writeattach (long al_fileid, ref blob abl_filecontent, long al_filesize, mt_n_transaction atr_object)
public function integer of_readattach (string as_tablename, long al_fileid, ref blob abl_filecontent)
public function integer of_readblob (string as_tablename, long al_fileid, ref blob abl_filecontent, ref longlong abl_filesize)
public function longlong of_getfilesize (string as_tablename, long al_fileid)
public function longlong of_readfiles (string as_tablename, long al_fileid[], ref str_filecontent atr_content[])
end prototypes

public function integer of_read (string as_tablename, long al_fileid, ref blob abl_filecontent);
//OSOBLETE FUNCTION!!!
//Please use of_readblob() instead

long ll_rc

//keep compatible
ll_rc = of_readblob(as_tablename, al_fileid, abl_filecontent)
if ll_rc = c#return.Success then
	ll_rc = c#return.NoAction
end if

return ll_rc


end function

public function integer of_delete (string as_tablename, long al_fileid);/********************************************************************
   of_delete
   <DESC>	This function is to delete the file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename  : table name
		al_fileid     : file id
   </ARGS>
   <USAGE>	Called when need to delete the file	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First Version
		21/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

mt_n_transaction lnv_trans

return of_deleteblob( as_tablename, al_fileid, lnv_trans )


end function

public function integer of_write (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize);/********************************************************************
   of_write
   <DESC>	This function is to write the file content into database	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename: table name
		al_fileid: file id
		abl_filecontent: a blob contains the file content
		al_filesize: the size of the file
   </ARGS>
   <USAGE>	Called when need to write the file content into database	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First version
		20/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

long ll_rc
mt_n_transaction lnv_invalid

//OSOBLETE!!!
//Please use of_writeblob() instead

ll_rc = of_writeblob(as_tablename, al_fileid, abl_filecontent, al_filesize, lnv_invalid)

//keep compatible with the old meaning
if ll_rc = c#return.Success then
	ll_rc = c#return.NoAction
end if

return ll_rc

end function

public function integer of_activate ();
// OBSOLETE FUNCTION !!!
// This function is obsolete, because a set of transaction is created.
// Whenever you read or write a file from the database you should first
// connect or reconnect to the database. So use of_connectfiledb() instead.

mt_n_transaction lnv_trans

lnv_trans = of_connectfiledb()
if isnull(lnv_trans) or not isvalid(lnv_trans) then
	return c#return.Failure
end if

return c#return.Success

end function

public function integer of_deactivate ();
// OBSOLETE FUNCTION !!!
// This function is obsolete

if isvalid(itr_tramos_file) then
	Disconnect Using itr_tramos_file;
	return c#return.Success
end if

return c#return.Failure

end function

public function integer of_commit ();
// OBSOLETE FUNCTION !!!
// This function is obsolete

if isvalid (itr_tramos_file) then
	COMMIT USING itr_tramos_file;
	return c#return.Success
end if

return c#return.Failure

end function

public function integer of_rollback ();
// OBSOLETE FUNCTION !!!
// This function is obsolete

if isvalid(itr_tramos_file) then
	ROLLBACK USING itr_tramos_file;
	return c#return.Success
end if

return c#return.Failure

end function

public function integer of_readblob (string as_tablename, long al_fileid, ref blob abl_filecontent);/********************************************************************
   of_readblob
   <DESC>	This function is to read the file content into a blob variable	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename    : table name
		al_fileid       : file id
		abl_filecontent : file content need to be put into a blob
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        ?
		21/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/
longlong lll_filesize = 0

// Don't care the size of a file
// setnull(lll_filesize)

return of_readblob(as_tablename, al_fileid, abl_filecontent, lll_filesize)

end function

public function integer of_convertblob (string as_tablename, long al_fileid, ref blob abl_filecontent, ref olecontrol aole_container, string as_filenamepath, ref long al_filesize);/********************************************************************
of_convertblob( /*long as_tablename */,/*long al_fileid */,/*blob abl_filecontent*/)
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
		as_tablename		:
		al_fileid			:
		abl_filecontent 	:<reference>file content need to be put into a blob
		aole_document	 	:<reference>ole container
		as_filenamepath	:
		ll_filesize			:
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
	al_filesize = filereadex( ll_filehandle, abl_filecontent )
	fileclose(ll_filehandle)
	If al_filesize > 0 then filedelete(as_filenamepath)
	
	if of_writeblob(as_tablename, al_fileid, abl_filecontent, Len(abl_filecontent), lnv_invalid) = c#return.Failure then 
		return c#return.Failure
	end if
	
CATCH ( Throwable ex )
	return c#return.NoAction
FINALLY  
	/* nothing to do */
END TRY

return c#return.Success








end function

public function integer of_validatefileid (string as_tablename, long al_source_fileid);/********************************************************************
   of_validatefileid
   <DESC>	This function is to validate the file
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename     : table name
		al_source_fileid : file id
   </ARGS>
   <USAGE>	Called when need to write the file content into database	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        ?
		21/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

long		  ll_file_size
string     ls_sql_select, ls_sql_insert, ls_sql_updateblob
datastore  lds_tmp
string     error_syntaxfromSQL
mt_n_transaction       lnv_trans

lnv_trans = of_connectfiledb(of_getfiledbname(al_source_fileid, as_tablename))
if isnull(lnv_trans) or not isvalid(lnv_trans) then
	return c#return.Failure
end if

//check if existing
ls_sql_select = "SELECT FILE_ID FROM "+as_tablename+" WHERE FILE_ID = "+STRING(al_source_fileid)
ls_sql_select =  lnv_trans.SyntaxFromSQL(ls_sql_select, 'Style(Type=Form)', error_syntaxfromSQL)
lds_tmp = CREATE datastore
lds_tmp.CREATE(ls_sql_select)
lds_tmp.setTransObject(lnv_trans)

if lds_tmp.retrieve( ) = 0 then
	//not found
	destroy lds_tmp
	lnv_trans.of_disconnect()
	return c#return.Failure
else
	destroy lds_tmp
	lnv_trans.of_disconnect()
	return c#return.Success
end if

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
		20/08/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

mt_n_transaction itr_return

itr_return = of_connectfiledb(of_getfiledbname())

//Keep campatible
itr_tramos_file = itr_return
return itr_return

end function

public function string of_getfiledbname (long al_file_id, string as_tablename);/********************************************************************
   of_getfiledbname
   <DESC>	Get the file database name from the table in Tramos	</DESC>
   <RETURN>	string:
            <LI> file database name if succeeded
            <LI> null if failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_file_id   : file id
		as_tablename : table name in the file database
   </ARGS>
   <USAGE>	Called when reading a file	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		20/08/14 CR3753        SSX014    First Version
   </HISTORY>
********************************************************************/

string ls_dbname
string ls_deverrmsg
constant string METHOD = "of_getfiledbname()"
constant string ERRMSG = "Cannot get the file database name."

// Execute procedure:
// SP_GET_FILEDB

DECLARE SP_GET_FILEDB PROCEDURE FOR
	SP_GET_FILEDB @FILE_ID = :al_file_id, 
	              @TABLENAME = :as_tablename, 
					  @DB_NAME = :ls_dbname /*OUTPUT*/
USING SQLCA;

EXECUTE SP_GET_FILEDB;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	SetNull(ls_dbname)
	CLOSE SP_GET_FILEDB;
	_appendmessage(METHOD, ERRMSG, ls_deverrmsg)
	return ls_dbname
end if

FETCH SP_GET_FILEDB INTO :ls_dbname;
if SQLCA.SQLCode <> 0 then
	ls_deverrmsg = SQLCA.SQLErrText
	SetNull(ls_dbname)
	CLOSE SP_GET_FILEDB;
	_appendmessage(METHOD, ERRMSG, ls_deverrmsg)
	return ls_dbname
end if

CLOSE SP_GET_FILEDB;
return ls_dbname
end function

protected function integer of_setfiledbname (long al_file_id, string as_tablename, string as_dbname, ref string as_errmsg);/********************************************************************
   of_setfiledbname
   <DESC>	Update the DB_NAME field in Tramos	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
		al_file_id    : file id
		as_tablename  : table name in the file database
		as_dbname     : database name
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		20/08/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_errmsg

// Execute procedure:
// SP_SET_FILEDB

DECLARE SP_SET_FILEDB PROCEDURE FOR
	SP_SET_FILEDB @FILE_ID = :al_file_id, 
	              @TABLENAME = :as_tablename, 
					  @DB_NAME = :as_dbname
USING SQLCA;

EXECUTE SP_SET_FILEDB;
ls_errmsg = SQLCA.SQLErrText
if SQLCA.SQLCode = -1 then
	CLOSE SP_SET_FILEDB;
	ROLLBACK USING SQLCA;
	as_errmsg = "of_setfiledbname()~r~n"+ls_errmsg
	return c#return.Failure
end if

CLOSE SP_SET_FILEDB;

// Be were that the transaction is not committed

return c#return.Success

end function

public function integer of_deleteblob (string as_tablename, long al_fileid, mt_n_transaction atr_object);/********************************************************************
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
		20/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

STRING		ls_sql_delete
constant    string METHOD = "of_deleteblob()"
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
ls_sql_delete = "DELETE FROM "+as_tablename+" WHERE FILE_ID = "+STRING(al_fileid)
EXECUTE IMMEDIATE :ls_sql_delete USING lnv_trans;

if lnv_trans.sqlcode = -1 then
	ls_errmsg = "Error deleting file. It was not possible to delete the file referenced #" + string(al_fileid)
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

protected function mt_n_transaction of_connectfiledb (string as_dbname);/********************************************************************
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
		20/08/14 CR3753        SSX014   First Version
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

public subroutine documentation ();/*********************************************************************
ObjectName: u_fileattach
	
<OBJECT>
	File attachment service
</OBJECT>
<DESC>
	Read or write file content to the file database
	OBSOLETE FUNCTIONS:
	of_activate()
	of_commit()
	of_deactivate()
	of_deleteblob(string,long,boolean)
	of_read()
	of_rollback()
	of_writeblob(string,long,blob,boolean)
</DESC>
<USAGE>
</USAGE>
<ALSO>
	Date			Ref    	Author     	Comments
   ?           ?        ?           ? 
	21/08/14    CR3753   SSX014      File database archiving
	12/08/15    CR4116   SSX014      Add functions to get the size for the files
</ALSO>
********************************************************************/

end subroutine

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
		20/08/14 CR3753        Shawn    File database archiving
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

public function integer of_writeblob (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize, boolean ab_autocommit);
//OBSOLETE FUNCTION!!!
//This function is obsolete

//Keep compatible
mt_n_transaction  ltr_fdb
if ab_autocommit then
	return of_writeblob(as_tablename, al_fileid, abl_filecontent, al_filesize, ltr_fdb)
else
	ltr_fdb = of_connectfiledb()
	if isvalid(ltr_fdb) then
		return of_writeblob(as_tablename, al_fileid, abl_filecontent, al_filesize, ltr_fdb)
	end if
end if

return c#return.Failure


end function

public function integer of_deleteblob (string as_tablename, long al_fileid, boolean ab_autocommit);
//OBSOLETE FUNCTION !!!
//This function is obsolete

mt_n_transaction ltr_fdb

//Keep compatible
if ab_autocommit then
	return of_deleteblob(as_tablename, al_fileid, ltr_fdb)
else
	ltr_fdb = of_connectfiledb()
	if isvalid(ltr_fdb) then
		return of_deleteblob(as_tablename, al_fileid, ltr_fdb)
	end if
end if

return c#return.Failure

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
		21/08/14 CR3753        SSX014   File database archiving
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

public function boolean of_postponemessagebox (boolean ab_switch);/********************************************************************
   of_postponemessagebox
   <DESC>	set whether a message box pops up when an error occurs
	</DESC>
   <RETURN>	boolean: 
            <LI> the previous value
            <LI> null if any parameters is null	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_switch : on/off
   </ARGS>
   <USAGE>	Called prior to calling any other functions of this object
	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/08/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

boolean lb_return

if isnull(ib_PostponeMessageBox) then
	setnull(lb_return)
end if

lb_return = ib_PostponeMessageBox
ib_PostponeMessageBox = ab_switch

return lb_return

end function

private function integer _appendmessage (string as_methodname, string as_message, string as_devmessage);return _addmessage(this.classdefinition, as_methodname, as_message, as_devmessage, not ib_PostponeMessageBox)

end function

public function integer of_writeblob (string as_tablename, long al_fileid, ref blob abl_filecontent, long al_filesize, mt_n_transaction atr_object);/********************************************************************
   of_writeblob
   <DESC>	This function is to write the file content into database
	</DESC>
   <RETURN>	integer:
      <LI> 1, X Success  : committed transaction
		<LI> -1, X Failed  : Transaction failed. Rollback made.
		<LI> 0, X NoAction : Ready for manual commit.	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   as_tablename    : table name
				al_fileid       : file id
				abl_filecontent : a blob contains the file content
				al_filesize     : the size of the file
				atr_object      : the transaction object
   </ARGS>
   <USAGE>	Called when need to write the file content into database
	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        First Version
		08/20/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

constant string METHOD = "of_writeblob()"

long		 		ll_file_size
string	 		ls_sql_select, ls_sql_insert, ls_sql_updateblob
mt_n_datastore lds_tmp
string         ls_errmsg
string         ls_deverrmsg
long           ll_rc
mt_n_transaction           lnv_trans
boolean        lb_selfmanagedtrans
string         ls_dbname

//TODO: File size is not adjusted when replacing file.

//put the file directly into the file database
if as_tablename = ATTACHMENTS_TABLE then
	return of_writeattach(al_fileid, abl_filecontent, al_filesize, atr_object)
end if

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
string error_syntaxfromSQL
ls_sql_select = "SELECT FILE_ID FROM "+as_tablename+" WHERE FILE_ID = "+STRING(al_fileid)
ls_sql_select =  lnv_trans.SyntaxFromSQL(ls_sql_select, 'Style(Type=Form)', error_syntaxfromSQL)
lds_tmp = create mt_n_datastore
lds_tmp.create(ls_sql_select)
lds_tmp.settransobject(lnv_trans)

//if not existing then insert a new row
if lds_tmp.retrieve( ) = 0 THEN//not found
	ls_sql_insert = "INSERT INTO "+as_tablename+" (FILE_ID,FILE_SIZE) VALUES ("+STRING(al_fileid)+", "+STRING(al_filesize)+")"
	EXECUTE IMMEDIATE :ls_sql_insert USING lnv_trans;
	if lnv_trans.sqlcode <> 0 THEN
		ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
		ls_deverrmsg = "Insert table failed~r~n~r~nsqlerrtext = " + lnv_trans.sqlerrtext
		ROLLBACK USING lnv_trans;
		if lb_selfmanagedtrans then lnv_trans.of_disconnect()
		_appendmessage(METHOD, ls_errmsg, ls_deverrmsg )
		return c#return.Failure
	end if
end if
destroy lds_tmp

//insert file
//create a tmp table to store the file
EXECUTE IMMEDIATE "CREATE TABLE #TMP_FILE ( FILE_ID integer, FILE_SIZE integer, FILE_CONTENT image NULL)" USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Create table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//insert a entry in the tmp table
ls_sql_insert = "INSERT INTO #TMP_FILE (FILE_ID, FILE_SIZE) VALUES ( "+STRING(al_fileid)+","+STRING(al_filesize)+" )"
EXECUTE IMMEDIATE :ls_sql_insert USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Insert table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//put the file into the tmp table
UPDATEBLOB #TMP_FILE
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

//update the destination table with the file content
ls_sql_updateblob = "UPDATE " +as_tablename+" SET A.FILE_CONTENT = B.FILE_CONTENT, A.FILE_SIZE = B.FILE_SIZE FROM " +as_tablename+" A, #TMP_FILE B WHERE  A.FILE_ID = "+STRING(al_fileid)+" AND B.FILE_ID = "+STRING(al_fileid )
EXECUTE IMMEDIATE :ls_sql_updateblob USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Update table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//drop the tmp table 											
EXECUTE IMMEDIATE "DROP TABLE #TMP_FILE" USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error attaching file.  It was not possible to include the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Drop table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	if lb_selfmanagedtrans then lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//set the database name
ll_rc = of_setfiledbname(al_fileid, as_tablename, lnv_trans.database, ls_errmsg)
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
		03/09/14 CR3753        SSX014   First Version
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
ll_rc = of_setfiledbname(al_fileid, "ATTACHMENTS_FILES", lnv_trans.database, ls_errmsg)
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

public function integer of_readattach (string as_tablename, long al_fileid, ref blob abl_filecontent);/********************************************************************
   of_readattach
   <DESC>	A new interface to read the blob directly from the file database
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename    : table name
		al_fileid       : file id
		abl_filecontent : file content need to be put into a blob
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		09/03/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

constant string METHOD = "of_readattach()"

mt_n_transaction     lnv_trans
string   ls_deverrmsg
string   ls_errmsg

//connect to the file database
lnv_trans = of_connectfiledb(of_getfiledbname(al_fileid, as_tablename))
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

/* Sucessfully obtained blob from FILES database! */
lnv_trans.of_disconnect()
return c#return.Success

end function

public function integer of_readblob (string as_tablename, long al_fileid, ref blob abl_filecontent, ref longlong abl_filesize);/********************************************************************
   of_readblob
   <DESC>	This function is to read the file content into a blob variable	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename    : table name
		al_fileid       : file id
		abl_filecontent : file content need to be put into a blob
		abl_filesize    : the file size that will be returned to the calling if the passed value is not null
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		?        ?             ?        ?
		21/08/14 CR3753        SSX014   File database archiving
   </HISTORY>
********************************************************************/

constant string METHOD = "of_readblob()"

string	ls_sql_update, ls_sql_insert
mt_n_transaction     lnv_trans
string   ls_deverrmsg
string   ls_errmsg

//Get the file content directly from the file database
if as_tablename = ATTACHMENTS_TABLE then
	return of_readattach(as_tablename, al_fileid, abl_filecontent)
end if

//connect to the file database
lnv_trans = of_connectfiledb(of_getfiledbname(al_fileid, as_tablename))
if isnull(lnv_trans) or not isvalid(lnv_trans) then
	return c#return.Failure
end if

//create a tmp table
EXECUTE IMMEDIATE "CREATE TABLE #TMP_FILE ( FILE_ID integer, FILE_CONTENT image NULL)" USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Create temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//insert a entry in the tmp table 
ls_sql_insert = "INSERT INTO #TMP_FILE (FILE_ID) VALUES ( "+STRING(al_fileid)+" )"
EXECUTE IMMEDIATE :ls_sql_insert USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Insert into temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//put the file content in the tmp table
ls_sql_update = "UPDATE #TMP_FILE SET B.FILE_CONTENT = A.FILE_CONTENT FROM " +as_tablename+" A, #TMP_FILE B WHERE  A.FILE_ID = "+STRING(al_fileid)+" AND B.FILE_ID = "+STRING(al_fileid )
EXECUTE IMMEDIATE :ls_sql_update USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Update temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

/* select the file content from the tmp table into the blob */
SELECTBLOB FILE_CONTENT
INTO :abl_filecontent
FROM #TMP_FILE
WHERE FILE_ID = : al_fileid
USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:SelectBlob into temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

if not isnull(abl_filesize) then
	SELECT DATALENGTH(FILE_CONTENT)
	INTO :abl_filesize
	FROM #TMP_FILE
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

/* drop the tmp table */
EXECUTE IMMEDIATE "DROP TABLE #TMP_FILE" USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Drop temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

/* Sucessfully obtained blob from FILES database! */
lnv_trans.of_disconnect()
return c#return.Success

end function

public function longlong of_getfilesize (string as_tablename, long al_fileid);/********************************************************************
   of_readblob
   <DESC>	This function is to read the file size.</DESC>
   <RETURN>	integer:
            <LI> greater than or equal to zero, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename    : table name
		al_fileid       : file id
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/08/15 CR4116        SSX014   Initial Version
   </HISTORY>
********************************************************************/

constant string METHOD = "of_getfilesize()"

string	ls_sql_update, ls_sql_insert
mt_n_transaction     lnv_trans
string   ls_deverrmsg
string   ls_errmsg
longlong lll_filesize

//connect to the file database
lnv_trans = of_connectfiledb(of_getfiledbname(al_fileid, as_tablename))
if isnull(lnv_trans) or not isvalid(lnv_trans) then
	return c#return.Failure
end if

//create a tmp table
EXECUTE IMMEDIATE "CREATE TABLE #TMP_FILE ( FILE_ID integer, FILE_SIZE bigint)" USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Create temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//insert a entry in the tmp table 
ls_sql_insert = "INSERT INTO #TMP_FILE (FILE_ID, FILE_SIZE) VALUES ( "+STRING(al_fileid)+", -1 )"
EXECUTE IMMEDIATE :ls_sql_insert USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Insert into temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

//put the file content in the tmp table
ls_sql_update = "UPDATE #TMP_FILE SET B.FILE_SIZE = DATALENGTH(A.FILE_CONTENT) FROM " +as_tablename+" A, #TMP_FILE B WHERE  A.FILE_ID = "+STRING(al_fileid)+" AND B.FILE_ID = "+STRING(al_fileid )
EXECUTE IMMEDIATE :ls_sql_update USING lnv_trans;
if lnv_trans.sqlcode <> 0 then
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Update temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

SELECT FILE_SIZE
	INTO :lll_filesize
FROM #TMP_FILE
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

/* drop the tmp table */
EXECUTE IMMEDIATE "DROP TABLE #TMP_FILE" USING lnv_trans;
if lnv_trans.sqlcode <> 0 THEN
	ls_errmsg = "Error opening file.  It was not possible to open the file referenced #" + string(al_fileid)
	ls_deverrmsg = "Open Attachment:Drop temp table failed~r~n~r~nsqlerrtext = "+lnv_trans.sqlerrtext
	ROLLBACK USING lnv_trans;
	lnv_trans.of_disconnect()
	_appendmessage(METHOD, ls_errmsg, ls_deverrmsg)
	return c#return.Failure
end if

/* Sucessfully obtained blob from FILES database! */
lnv_trans.of_disconnect()
return lll_filesize

end function

public function longlong of_readfiles (string as_tablename, long al_fileid[], ref str_filecontent atr_content[]);/********************************************************************
   of_readblob
   <DESC>	This function is to read a group of files into an array	</DESC>
   <RETURN>	integer:
            <LI> greater or equal zero, the total size of the files
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename    : table name
		al_fileid[]      : file id array
		atr_content[]    : file content need to be put into a blob
   </ARGS>
   <USAGE>	Called when need to read the file content.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/08/15 CR4116        SSX014   Initial Version
   </HISTORY>
********************************************************************/

constant string METHOD = "of_readfiles()"

long ll_i, ll_upper
blob lbl_filecontent
longlong lll_filesize
longlong lll_total = 0
integer ll_rc

ll_upper = upperbound(al_fileid[])
for ll_i = 1 to ll_upper
	ll_rc = of_readblob(as_tablename, al_fileid[ll_i], lbl_filecontent, lll_filesize)
	if ll_rc <> c#return.Success or lll_filesize < 0 then
		return c#return.Failure
	end if
	atr_content[ll_i].il_fileid = al_fileid[ll_i]
	atr_content[ll_i].ibl_filecontent = lbl_filecontent
	lll_total += lll_filesize
next

return lll_total

end function

on n_fileattach_service.create
call super::create
end on

on n_fileattach_service.destroy
call super::destroy
end on

event constructor;call super::constructor;
//Keep campatible
itr_tramos_file = iuo_fdbtranset.of_get(of_getfiledbname(), true)
end event

