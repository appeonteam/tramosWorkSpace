$PBExportHeader$u_fileattach.sru
$PBExportComments$standard file attachment visual user obejct.  Dependency on services in mt_services.pbl.
forward
global type u_fileattach from mt_u_visualobject
end type
type dw_change from mt_u_datawindow within u_fileattach
end type
type pb_expandcollapse from picturebutton within u_fileattach
end type
type st_infobox from statictext within u_fileattach
end type
type lbx_tempfiles from listbox within u_fileattach
end type
type st_attachmentcounter from mt_u_statictext within u_fileattach
end type
type pb_update from picturebutton within u_fileattach
end type
type pb_new from picturebutton within u_fileattach
end type
type pb_cancel from picturebutton within u_fileattach
end type
type pb_delete from picturebutton within u_fileattach
end type
type ole_document from olecontrol within u_fileattach
end type
type dw_file_listing from u_datagrid within u_fileattach
end type
type shellexecuteinfo from structure within u_fileattach
end type
type oleobject_1 from oleobject within u_fileattach
end type
end forward

type shellexecuteinfo from structure
	long		cbsize
	long		fmask
	long		hwnd
	string		lpverb
	string		lpfile
	string		lpparameters
	string		lpdirectory
	long		nshow
	long		hinstapp
	long		lpidlist
	string		lpclass
	long		hkeyclass
	long		hicon
	long		hmonitor
	long		hprocess
end type

shared variables
long sl_handle
end variables

global type u_fileattach from mt_u_visualobject
integer width = 2469
integer height = 3144
long backcolor = 32304364
event ue_dropfiles pbm_dropfiles
event ue_dropmails pbm_custom01
event ue_mousemove pbm_mousemove
event ue_childmodified pbm_dwnitemchange
event ue_childclicked pbm_dwnlbuttonclk
event type long ue_retrievefilelist ( u_datagrid adw_file_listing )
event type long ue_preupdateattach ( u_datagrid adw_file_listing )
event ue_childdragdrop pbm_dwndragdrop
event ue_postupdateattach ( u_datagrid adw_file_listing,  integer ai_returncode,  string as_msg,  string as_msg_dev )
dw_change dw_change
pb_expandcollapse pb_expandcollapse
st_infobox st_infobox
lbx_tempfiles lbx_tempfiles
st_attachmentcounter st_attachmentcounter
pb_update pb_update
pb_new pb_new
pb_cancel pb_cancel
pb_delete pb_delete
ole_document ole_document
dw_file_listing dw_file_listing
oleobject_1 oleobject_1
end type
global u_fileattach u_fileattach

type prototypes
FUNCTION ulong RevokeDragDrop( ulong aul_Wnd ) LIBRARY "ole32.dll"
FUNCTION ulong RegisterDropTarget( ulong aul_Wnd ) LIBRARY "dddll.dll"

// Drag and Drop of Files
FUNCTION int DragQueryFile( ulong aul_Drop, int ai_File, ref string as_FileName, int ai_CB ) LIBRARY 'shell32' ALIAS FOR "DragQueryFileW"
SUBROUTINE DragAcceptFiles( ulong aul_Wnd, boolean ab_Accept ) LIBRARY 'shell32'

// File Stuff
Function long FindFirstFileW (string filename, ref str_findfiledata findfiledata) library "KERNEL32.DLL"
Function boolean FindNextFileW (long handle, ref str_findfiledata findfiledata) library "KERNEL32.DLL"
Function boolean FindClose (long handle) library "KERNEL32.DLL"

Function boolean ShellExecuteEx ( &
	Ref SHELLEXECUTEINFO lpExecInfo &
	) Library "shell32.dll" Alias For "ShellExecuteExW"
	
FUNCTION ulong GetTempPath(ulong nBufferLength, ref string lpBuffer) &
LIBRARY "kernel32" ALIAS FOR GetTempPathW	

end prototypes

type variables
string 						is_dataobjectname							/* dataobject name */
string							is_counterlabel						= "files:"
boolean 						ib_ole 								= false 	/* the method used on how the blob is generated.  New additions need to be set to FALSE only Shared Documents use has both set to true */
boolean 						ib_show_ole 						= false 
boolean 						ib_allow_dragdrop 				= false	/* allow dragdrop from explorer and outlook 2003 */
boolean 						ib_highlight_selectedrow 		= true		/* TODO: find out if this is used */
boolean						ib_allow_repeated_filenames 	= true		/* in certificates, business logic suggests we can not have files with the same name */
integer 						ii_ole_height 						= 0		/* if ib_show_ole is true, this controls the height of the control */
integer						ii_max_column_size				= 70		/* filename/description: this is the size of the database columns in table */
integer 						ii_buttonmode 						= 2		/* display option: 0 = non, 2 = picture buttons */
boolean 						ib_enable_update_button 		= false	/* display option: shows update button if required */	
boolean 						ib_enable_cancel_button 		= true		/* display option: shows cancel button if required */	
boolean 						ib_convert_process 				= false	/* identifies the converter window */
boolean						ib_showinfobox						= true		/* display status update message */
boolean						ib_allownonattachrecs			= false		/* display status update message */
boolean						ib_autosave							= false		/* previously only testing for treeview, needed to work for other dataobject types */
boolean                 ib_multitableupdate           = false
string                  is_modulename                 = ""

private n_attachment 		_inv_att[]											/* object array used to hold each attachment's info */
private long 					_il_arg											/* retreival argument placeholders for datawindows */
private long	 				_il_arg2
private integer 				_ii_arg
private string 				_is_arg

private string 				_is_tablename 						= ""
private string				_is_tempsubfolder 				= "tramos_temp\"     	/* subfolder in the designated temporary directory. must end in with '\'  */  
private string 				_is_groupname 					= ""
private integer				_ii_access_level					= 0
private long 					_il_file_id
private long					_ll_file_size
private long					_il_grouplevel						/* used in treeview, when default level maybe different to 1 */
long 								il_max_size_bytes					= 20972000	//in window w_document_publication adjust to 52428800

private long					_il_new_file_id
private long 					_il_movedRow
private long					_il_lastclickedrow		
private long					_il_lastfileid										/* used exclusively with the treeview */
private boolean				_ib_expanded						= false	/* used exclusively with the treeview */
private boolean 			_ib_dragdrop_order
private boolean 			_ib_first_run
private boolean				_ib_columnresizable 				= false
private integer				_ii_secret_counter				= 0		/* clicking 5 times on filecounter label opens conversion manager */
private str_multiupdate    _istr_multiupdate[]
private string             _is_updatesallowed            = "IUD"

constant integer 			ATTACH_RESERVED				= 1
constant integer 			ATTACH_SYSTEM				= 2

constant integer 			EXTERNAL_APM 					= -1		/* access rights for external users.  they should have read only access */

private boolean			_ib_openimage
boolean						ib_retrievedetail = true //improving performance, used in shared docs
boolean						ib_showfilteredcounter
end variables

forward prototypes
public subroutine documentation ()
public function integer of_init (long al_retreival_id)
private function integer _updaterows ()
private function integer _openimage (long al_row)
private function integer _initvisualcontrols ()
public function long of_getfileid ()
public function integer of_addnewimage ()
private function integer _replaceimage (integer al_row)
private function integer _appendtoimagearray (string as_method, blob abl_image, long al_fileid, long al_filesize)
public subroutine of_clearimages ()
private function integer _insertimage (string as_docpath, string as_docname)
public function integer of_deleteimage ()
private function integer _changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number)
public subroutine of_setfilecounter ()
public function integer of_updateattach ()
public subroutine of_cancelchanges ()
public function integer of_init (string as_arg, long al_arg)
private function integer _retrieveattach ()
public function integer of_setlongarg (long al_arg)
public subroutine of_setresizablecolumns (boolean ab_resize)
public function integer of_validatefilesize (string as_docname, long al_filesize)
private function long _appendtoimagearray (string as_method, long al_fileid, long al_filesize)
public function integer of_init ()
public function integer of_purgetempfiles ()
public function integer of_gettempfoldername (ref string as_tempdir)
private function integer _insertimage (string as_docpath, string as_docname, string as_fileinfo)
public function integer of_infoboxwrite (string as_message)
public function integer of_openattachment (long al_row)
public function integer _getcategory (ref long al_category)
public function integer _changecategory (long al_row, long al_categoryid)
public function integer _changeidstr (long al_row, string as_idstr)
public function boolean _istreeview ()
public function boolean _getattachrow ()
public function integer _expandtree (long al_fileid)
public function integer _expandtree (long al_fileid, boolean ab_highlightrow)
public function integer of_showole ()
public subroutine of_cancelchanges (boolean ab_emptyarray)
public function integer of_getattachment (ref n_attachment anv_attachment, long al_fileid, long al_newfileid)
public function integer of_setaccesslevel (integer ai_accesslevel)
public function boolean _updatefiles ()
private function integer _saveexpanded (ref long al_expanded[])
public function integer _restoreexpanded (long al_expanded[], long al_rowposition, long al_quantity)
public function integer of_init (string as_arg, long al_arg, long al_arg2, integer ai_arg)
private function integer _insertimage (string as_docpath, string as_docname, string as_fileinfo, long al_row)
public function integer of_setargs (string as_arg, long al_arg, long al_arg2, integer ai_arg)
public function integer of_sharedata (ref mt_n_datastore ads)
private function integer _openimage (long al_row, mt_u_datawindow adw)
public function integer of_openattachment (long al_row, mt_u_datawindow adw)
public function integer of_deleteimage (long al_deleterow, boolean ab_batch)
public function integer of_get_attachment_count ()
public function integer of_modified_count ()
protected function long _updatetables ()
public function integer of_addupdatetable (string as_tablename, string as_allcolumns, string as_keycolumns)
public function long of_addupdatetable (string as_tablename, string as_keycolumns)
private function long _setdefaultvalue ()
public function boolean _candeleteimage (long al_fileid, long al_row)
public function boolean _canreplaceimage (long al_fileid, long al_row)
protected function integer _resetidentity ()
end prototypes

event ue_dropfiles;/********************************************************************
event ue_dropfiles( /*long handle */)

<DESC>
	Called when Files are dropped
</DESC>
<RETURN> 
	Integer:
   	<LI> 1, X ok
     <LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>
</ARGS>
<USAGE>
	Used with Windows Explorer.  Multiple files can be dragged in,
	but no directories.
</USAGE>
********************************************************************/

string 		ls_MsgBox, ls_FileName, ls_docname="from explorer"
integer		li_Counter, li_Files, li_charpos, li_response = 1
boolean		lb_canfindrow = true
	
	if _ii_access_level <> EXTERNAL_APM then
		of_infoboxwrite("Attaching Files...")	
		lb_canfindrow =_getattachrow( )
		if lb_canfindrow then
			ls_filename = Space( 255 )
			li_files = DragQueryFile( handle, -1, ls_filename, 255 )
			if ib_allownonattachrecs and li_files > 1 and _il_lastclickedrow>0 then
				_addmessage(this.classdefinition, "ue_dropfiles()", "Error, it is not possible to drag multiple attachments into 1 record", "user warning")			
				return c#return.NoAction				
			end if
			if li_files > 10 then
				li_response = MessageBox("Multiple Files", "You are dragging " + string(li_files) + " files into Tramos.  Are you sure you want to continue with this action?", Exclamation!, OKCancel!, 2)
			end if	
			/* continue */
			if li_response = 1 then
				for li_Counter = 1 to li_Files
					ls_filename = Space( 255 )
					DragQueryFile( handle, li_Counter - 1, ls_filename, 255 )
					for li_charpos = len(ls_filename) to 1 step -1
						if mid(ls_filename,li_charpos,1)="\" then
							ls_docname = mid(ls_filename,li_charpos+1)	
							li_charpos=1
						end if
					next
					/* first parm is the real dir & filename, the second is the reformatted version */
					if ib_allownonattachrecs then
						_insertimage( ls_filename, ls_docname, "", _il_lastclickedrow )	
					else
						_insertimage( ls_filename, ls_docname, "(" + string(li_counter) + " of " + string(li_files) + ")" )
					end if
				next
				of_setfilecounter( )
			end if
		end if
		of_infoboxwrite("")
		if lb_canfindrow and  _istreeview() then
			dw_file_listing.setredraw(true)
		end if
	end if
return 1
end event

event ue_dropmails;/********************************************************************
event ue_dropmails( /*unsignedlong wparam*/, /*long lparam */)
	
<DESC>
	Called when Messages are dropped
</DESC>
<RETURN>
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
</ARGS>
<USAGE>
	To be used with outlook 2003, 2007 unknown??
</USAGE>
********************************************************************/
	
string			ls_message, ls_header, ls_filename, ls_tempfilename, ls_exttype
string			ls_Pre, ls_directory, ls_temp_name_segment, ls_temp_extension_segment
str_findfiledata	lstr_data
boolean		lb_email_body_included = false, lb_canfindrow = true
integer		li_charpos
long			ll_handle
char 			lc_dummy[]
pointer 		lpnt_old
constant string METHOD_NAME = "ue_dropmails"

if wparam = 111 then
	lb_canfindrow =_getattachrow( )
	ls_message = string( lparam, "address" )
	li_charpos = pos( ls_message, "~r~n" )
	if li_charpos > 0 then
		ls_header = mid( ls_message, li_charpos + 2 )
		ls_message = left( ls_message, li_charpos - 1 )
	end if
	ls_pre = left( ls_message, lastpos( ls_message, "." ) - 1)
	ls_directory = left( ls_message, lastpos( ls_message, "\" ) - 1)
	ll_handle = findfirstfilew(ls_pre + "*.*", lstr_data)
	if ll_handle <= 0 then return -1
	ls_filename = ""
	for li_charpos = 13 to 260
		ls_filename = ls_filename + lstr_data.ch_filename[li_charpos]
	next 
	ls_tempfilename=trim(ls_filename)
	ls_exttype = lower(right(ls_tempfilename,3))
	if  lb_canfindrow then
		if lower(right(ls_tempfilename,9)) <> "_body.txt" then
				if left(ls_tempfilename,1)="." then 
					ls_tempfilename="nosubject" + ls_tempfilename
				else
					/* try to exclude right side spaces in file name */
					ls_temp_name_segment = mid(ls_tempfilename,1,len(ls_tempfilename) - 4)	
					ls_temp_extension_segment = right(ls_tempfilename,4)					
					ls_tempfilename = trim(ls_temp_name_segment) + ls_temp_extension_segment
				end if
				/* first parm is the real dir & filename, the second is the reformatted version */
				if ib_allownonattachrecs then
					_insertimage( ls_directory + "\" + ls_filename, ls_tempfilename, "", _il_lastclickedrow )	
				else
					_insertimage( ls_directory + "\" + ls_filename, ls_tempfilename)
				end if
		end if
	end if 
	lstr_data.ch_filename = lc_dummy
	filedelete(ls_directory + "\" + ls_filename)
	findclose(ll_handle)
	of_setfilecounter()
	/* reset the datawindow draw if treeview */
	if lb_canfindrow and _istreeview() then
		dw_file_listing.setredraw(true)	
	end if
end if
end event

event ue_childmodified;/*
optional. used to send additional processes on event item changed (child datawindow modification) specific to window
*/
end event

event ue_childclicked;/*
optional. used to send additional processes on event clicked (single left mouse click, after standard code) specific to window
*/
end event

event type long ue_retrievefilelist(u_datagrid adw_file_listing);/********************************************************************
   ue_retrievefilelist
   <DESC>	Only use this event to retrieve file records	</DESC>
   <RETURN>	long:
            <LI> >= 0, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_file_listing
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_rows = -1

if not isnull(_il_arg) then
	if not isnull(_ii_arg) then
		if not isnull(_is_arg) then
			if not isnull(_il_arg2) then
				ll_rows = dw_file_listing.retrieve(_il_arg, _is_arg, _ii_arg, _il_arg2)
			else
				ll_rows = dw_file_listing.retrieve(_il_arg,_ii_arg, _is_arg)
			end if
		else
			ll_rows = dw_file_listing.retrieve(_il_arg,_ii_arg)
		end if
	else
		if not isnull(_is_arg) then
			ll_rows = dw_file_listing.retrieve(_il_arg, _is_arg)
		else
			if not isnull(_il_arg2) then
				/* TODO
				for claims - here we may need to add a retreive for 
				_il_arg, _il_arg2, _il_arg3 & _il_arg4 
				*/
				ll_rows = dw_file_listing.retrieve(_il_arg, _il_arg2)
			else	
				ll_rows = dw_file_listing.retrieve(_il_arg)
			end if
		end if
	end if
else
	if not isnull(_ii_arg) then
		if not isnull(_is_arg) then
			ll_rows = dw_file_listing.retrieve(_ii_arg, _is_arg)
		else
			ll_rows = dw_file_listing.retrieve(_ii_arg)
		end if
	else
		if not isnull(_is_arg) then
			ll_rows = dw_file_listing.retrieve(_is_arg)		
		else
			ll_rows = dw_file_listing.retrieve()
		end if
	end if
end if

return ll_rows
end event

event type long ue_preupdateattach(u_datagrid adw_file_listing);return c#return.Success
end event

event ue_childdragdrop;/*
optional. used to send additional processes on event dragdrop (child datawindow dw_file_listing drag&drop) specific to window
*/
end event

event ue_postupdateattach(u_datagrid adw_file_listing, integer ai_returncode, string as_msg, string as_msg_dev);if ai_returncode <> c#return.SUCCESS then
	if len(as_msg) > 0 and len(as_msg_dev) > 0 then
		_addmessage( this.classdefinition, "ue_postupdateattach", as_msg, as_msg_dev)
	end if
end if
return
end event

public subroutine documentation ();/********************************************************************
ObjectName: u_fileattach
	
<OBJECT>
	General purpose file attachment visual user object.
</OBJECT>
<DESC>
	A multi purpose visual user object containing functionality of attachment processing. Business Logic contained within.
	Built initially to work in the change request system, but is reusable.  
</DESC>
<USAGE>
	To be used only on existing windows.  Includes feature to dragdrop files from windows explorer and ms outlook 2003, 32bit
	& ms outlook 2010.  
	
	It is used in the following areas within Tramos:
	-------------------------------------------------------------------ole--------------------
	Change Request System		Modify Request										N
	Port Of Call					Voyage Documents									N
	Shared Documents				Document Publication								Y
	Cargo								Cargo Picture										(removed)
	CP									Charter Party Picture							N
	Vessels							Certificates										N
	Actions and Transactions	Actions												N
	Accruals							Accruals Control									N
	Voyage Nbr Change				Voyage Notepad										N
	------------------------------------------------------------------------------------------
</USAGE>
<ALSO>
	Date			Ref    	Author     	Comments
  	04/05/10 	CR???? 	AGL027    	Created Object
  	09/07/10 	CR1951 	AGL027  		Finalised shared document implementation
  	27/08/10 	CR1951 	AGL027  		Made improvements and included dragdrop outlook
  										  		overall.
  	08/10/10 	CR2159 	AGL027	  	Made improvements to the tranasction management between the
  										  		2 databases.
  	15/10/10 	CR2167 	AGL027		Fixed the problem with the insert_index
  												Solved issue with not opening certain mails (ib_ole)
  	18/10/10 	CR2169 	AGL027		Set attachments in emails to be only contained in message attachment
  												Issue with registering dragdroptarget when multiple instances are open
  	19/10/10 	CR2170 	AGL027		Add flag ib_allow_repeated_filenames= true In Vessel's certificates
  												this flag is set to false.
  	26/10/10 	CR2171	AGL027		Switch voyage and change request attachments to save directly into blob
  												not via olecontrol.  Also open attachments outside of Tramos and not inside
												olecontrol.  
	08/11/10		CR2178	AGL027		Enhance main view (used in Port of Call) to allow categories and add fileid
												referencing when opening files
	21/12/10		CR2215	AGL027		Created new property to assist w_actions_and_transactions window as here
												records can be added without an attachment.  Allow dragdrop when clicking on '+' 
												to laod into existing record.
												
	13/01/11 	CR2256	AGL027		Added functionality for when ib_allownonattachrecs is true: user adds new record '+'
												inside _replaceimage manage fileid.
	14/02/11		CR2295	AGL027		Small issue when using the '+' option through citrix, no truncation carried out or validation
												on filesize/file extension.  Issue discovered from Actions/Transactions.
	25/02/11		CR2294	AGL027		Along with this change added functionality to set the background colour through constructor.					
	09/05-11		CR2239	AGL027		Added removal of control characters not supported by current db setup.
	24/05-11		CR2434	AGL027		Changed maximum filesize from 10mb to 20mb
	13/02/13		CR3156	AGL027		Fix issues handling new default level on treeview object.
	01/07/13		CR3167	AGL027		Allow attachments to be added even when open elsewhere on file system
	06/12/13		CR2877	AGL027		Include possibility for batch deletion and also auto update in CP implementation
	02/01/14		CR3085	WWG004		Add function of_get_attachment_count and of_modified_count, return the attachment files count.
	21/08/14    CR3753   SSX014      File database archiving
	08/22/14    CR3584   SSX014      Changed the trigger of the secret entry to this attachment management window
	04/09/14    CR2420   LGH008      Added event ue_childdragdrop for dragdrop dw_file_listing, and fix bug for open file via ole object.
	10/09/14    CR3205   LGH008      For treeview if an attachment record does not have a description then it not possible to darg&drop new attachment.
	07/01/15    CR3950   LGH008      Change Instance variable _il_max_size_kb from private scope to public and rename to il_max_size_bytes.
	10/02/15    CR3570   KSH092      Description not allow empty
	06/10/16		CR3754	AGL027		Change logid references to userid to support SSO
</ALSO>
********************************************************************/

/* 
===========
Guidelines
===========

It is recommended to use a single id, but it is possible to use more if needed.
The dataobject itself MUST have columns named as following:

column name					sample database column name (CREQ)
----------------------------------------------------------
file_id						CREQ_ATT.FILE_ID
id  (retreival arg)		CREQ_ATT.REQUEST_D
file_name					CREQ_ATT.FILE_NAME
insert_index				0 <important to keep reference of new attachment in datawindow against the array>

See sample dataobject d_sq_tb_creq_file_listing inside changerequest.pbl.

===========
Usage
===========
Place visualuserobject on window, set properties, create dataobject

Object has various behaviours.  

1. The main concerning the id that is received by the 
		of_init( /*long al_retreival_id */) function.
	overrides may be used to retreive other data (Voyage Document implementation).
		of_init( /*string as_stringarg*/, /*long al_intarg */)
		of_init()

Files are added when accessed to an array of object n_attachment. 

method
-----------------------------------
new		If file is 'new' the file_id passed to n_attachment is a negative number as the database reference for file_id is unknown.  
upd		the attachment in the database needs to be replaced
del			delete attachment record in database
delnull	attachment has been created, but also deleted.  no action required against the database

2. There is 1 update function.

	Multiple file update. In the example for the change request this is request_id.
		of_updateattach()

	The shared documents installation uses its own window function wf_update() to process the attachments.

In the CHGREQ/CP the id is not known when user calls of_init() the first time.  When user updates main window, as soon as 
the id is received, pass this value to the function of_setlongarg() before accessing of_updateattach().  This will load all attachments into the files database.

3. Height and Width of object is dependent on the container's size

4. A facility to allow simple access on a file is available.  If the datawindow object
	has a column called 'filetype' particular behaviour can be made depending on the number.  
	eg. in the Voyage Documents implementation Values  >= 3	are user defined categories, the rest follow:
	
	 1 = System Generated Accrual PDF Summary Report
	 1 = System Generated Accrual Excel8 Summary Report
	 1 = System Generated Accrual Detail Report.
	 2 = System Generated Voyage Number amendment

===========
Properties 
===========

is_dataobjectname
	the dataobject that will be used to display the files available.
	prefix of 'd_sq_tb' then it is a datagrid dataobject
	prefix of 'd_sq_tv' means it is a treeview dataobject.  There are a lot of conditions for this style of dataobject!
	
_il_arg
	This private instance variable is used to store the long variable type id.

_is_arg
	This private instance variable is used to store the string variable type id.	
	
_ii_arg
	This private instance variable is used to store the integer variable type id.	
	
{nb: if more keys needed you can add easily.  Perhaps an override on of_init() 
is required and an update to the _retreiveattach() function.}	
	
ib_ole True/False 
	This is important.  By default when saving we are not going via the 
	ole container control to then save as a blob.
	
	For the change request module as this was the method used here, this
	property allows us to set this value like a property on the visual user object
	itself.
	
	Usually and for new developments we should not use this method.  This is open to
	future discussion.

ii_buttonmode
	
	0 = no additional controls on visualobject
	1 = normal command buttons
	2 = picture buttons

ib_enable_update_button
	
	Determine if update button is to be displayed.  (example of change request system
	has picture buttons but the update event is needed on the main window)

ib_enable_cancel_button
	
	Determine if cancel button is to be displayed.  

ib_allow_repeated_filenames True/False 
	
	By default it´s true and the program does not check if the file name is repeated.
	In the Vessels Certificates this flag is set to false and the file names should be unique.
	If the program identifies a repeated file name, the file name is changed by adding an id in the end.
	
ib_convert_process <TODO> change this to ib_attachment_manager

	Controls functionality contained in the _openimage() function.  Instead of opening, the process attempts
	to convert the attachment {file - olecontrol - blob}  directly to {file - blob}.  Used primarily in w_fileattach_converter.

ib_autoupdate True/False
	
	Used to update items automatically dragged into visual object and also added on add item button.  
	Should be the default implementation of new developments.


===========
Dependencies
===========

Opening files
----------------------------------
Tramos must be able to create files/folders in the local PC's temporary folder.  If it can not it will not work!


Drag and Drop from Outlook
----------------------------------
For the outlook dragdrop feature we use a DLL called DDDLL.DLL.  
	
http://www.catsoft.ch/en/asp/page.aspx?key=downloads
http://www.novista.ch/

email address: Arthur Hefti [arthur@catsoft.ch]

Drag and Drop Sample for PB

- Drag Files and Email Messages from Outlook and drop it on the window
- Files supported through Windows API (done by Novista.ch)
- DLL needed for Emails (Found one of 2001 in our archive and rebuilt it with VS 2008 with static binding to MFC)
- Attachments are extracted and saved as well

  -> when dropping the events gets a string in the lparam argument of the event. The string has the following format:
	1. Line: Location and the name of the dropped file
	2. Line: Subject of the message
	3. Line: Sender of the message
	4. Line: Date & Time received
	5. Line: Date & Time sent

Please Note: This version works with PB Ansi and Unicode. The message number to trap ansi is 112 instead of 111

Additional Functionality
- AS PB filters messages to its controls, the following function provides the possibility to add a message number and a target window
FUNCTION ulong RegisterDropTargetEx( ulong aul_Source, uint ui_Msg, ulong aul_Target ) LIBRARY "dddll.dll"


DATAOBJECTS
Best described by using POC voyage document example:

d_sq_tb_voyage_file_listing_converter (conditional)
	if this exists it allows admin user to manage all attachments in section
d_sq_tv_voyage_file_listing
	tree view for voyage attachments on port of call widow
d_sq_tb_voyage_file_listing_change (conditional)
	if exists, when in tree view and the dataobject contains column postfixed with 'openfile' user may
	right mouse click to open this dataobject.  here they can select item they wish to change. ie Voyage, Type etc.

USEROBJECTS
n_fileattachment
u_datagrid
n_error_service
n_dw_style_service
n_fileattach_service
n_service_manager

===========
Limitations
===========

It should have been developed in 2 parts using a visual object and an interface
non visual object for the business logic.  The Special claims pbl contains the same business logic
in its functions, but without this visual object. 

See specialclaims.pbl > n_specialclaims_interface
	_deleteAttachment(), _updateAttachments(), of_openAttachment(), of_validateAttachment()
	
Treeview only works with 1 of_init() override

TODO> treeview flag and auto update should work better together.  Clean up the relation between these
2 sto simplify code. 
		
	http://www.sybase.com/detail?id=42044 - multi selection
*/
end subroutine

public function integer of_init (long al_retreival_id);/********************************************************************
of_init( /*long al_retreival_id */)

<DESC>
	Initializes Object.
</DESC>
<RETURN> 
	Integer:
 	<LI> 1, success
	<LI> -1 failure</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>
	al_retreival_id: ID used to link attachment to relevant Tramos data.
	maybe either null (new record) or a number value (modify??)
</ARGS>
<USAGE>
	On open event of the containing window, call this method
</USAGE>
********************************************************************/

long ll_blobIndex, ll_file_size, ll_rows, ll_fileid
blob lbl_filecontent
pointer oldPointer
long li_savedrow

li_savedrow=dw_file_listing.getselectedrow(0)
_il_arg = al_retreival_id
 setnull(_il_arg2)
 setnull(_ii_arg)
 setnull(_is_arg)
 _il_new_file_id = 0

if dw_file_listing.dataobject<>is_dataobjectname  then
	/* store private instance in object */
	dw_file_listing.dataobject= is_dataobjectname
	dw_file_listing.settransobject( SQLCA )
	_initvisualcontrols( )
end if
this.event ue_retrievefilelist(dw_file_listing)
if dw_file_listing.rowcount( )>0 then
	if li_savedrow > 0 then
		dw_file_listing.selectRow(0,false)
		if li_savedrow > dw_file_listing.rowcount() then li_savedrow = dw_file_listing.rowcount()
		dw_file_listing.selectRow(li_savedrow,true)
		dw_file_listing.setrow(li_savedrow)
	else
		dw_file_listing.selectRow(1,true)
		dw_file_listing.setrow(1)
	end if
end if
of_setfilecounter()

return c#return.Success
end function

private function integer _updaterows ();/********************************************************************
_updaterows()

<DESC>   
	Updates the description column in the datawindow
</DESC>
<RETURN>
	integer Failure/Success
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	from the button cb_update/pb_update.
</USAGE>
********************************************************************/


long	ll_row, ll_dummy, ll_rowstatus
dwItemStatus ldws_status

pointer lpnt_old

setnull(ll_dummy)

constant string METHOD_NAME = "_updaterows"
dw_file_listing.accepttext( )
if dw_file_listing.modifiedCount()> 0 or dw_file_listing.deletedCount()> 0 then
	lpnt_old = setPointer(hourglass!)
	for ll_row = 1 to dw_file_listing.rowcount( )
		if not (ib_convert_process) then
			if dw_file_listing.getitemstring(ll_row, "description" ) = "" then
				_addmessage( this.classdefinition, METHOD_NAME, "Description field cannot be empty.", "n/a")
				dw_file_listing.selectRow(0,false)
				dw_file_listing.selectRow(ll_row,true)
				dw_file_listing.setrow( ll_row)
				dw_file_listing.scrolltorow(ll_row)
				dw_file_listing.post setcolumn( "description")
				dw_file_listing.post setfocus()
				return c#return.Failure
			end if
			if not _istreeview( ) then
				if dw_file_listing.Describe("filetype.type") <> "!" then 
					if isnull(dw_file_listing.getitemnumber(ll_row, "filetype" )) then		
						_addmessage( this.classdefinition, METHOD_NAME, "Category field cannot be empty.", "n/a")
						dw_file_listing.selectRow(0,false)
						dw_file_listing.selectRow(ll_row,true)
						dw_file_listing.setrow( ll_row)
						dw_file_listing.scrolltorow(ll_row)
						dw_file_listing.post setcolumn( "filetype")
						dw_file_listing.post setfocus()
						return c#return.Failure
					end if	
				end if
			end if
		end if
	next
	of_updateattach()
end if

return c#return.Success
end function

private function integer _openimage (long al_row);/********************************************************************
_openimage( /*long al_row */)

<DESC>
	Normally called when user clicks on the file icon in the datawindow 
	this loads the array and opens the attachment. It may be opened from the 
	rowfocuschanged event also
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X ok
      	<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	al_row: row in datawindow
</ARGS>
<USAGE>
	Called normally from the icon p_openimage.
</USAGE>
********************************************************************/

return _openimage( al_row, dw_file_listing)
end function

private function integer _initvisualcontrols ();/********************************************************************
_initvisualcontrols( )

<DESC>
	Important function.  Called only one time, it arranges the
	controls on the window and sets up some private variables
</DESC>
<RETURN> 
	Integer:
 		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	nil
</ARGS>
<USAGE>
	Called once from the of_init() function. 
</USAGE>
********************************************************************/

integer li_buttonypos, li_infobox_xpos, li_infobox_ypos
integer li_ole_height, li_button_height, li_button_width, li_spacer=4
boolean lb_treeview = false
	
	n_service_manager 		lnv_servicemgr
	n_dw_style_service   	lnv_style
	
	lb_treeview = _istreeview()
	if ib_show_ole then
		if ii_ole_height<100 then
			li_ole_height = 100
		else
			li_ole_height = ii_ole_height
		end if
	else
		li_ole_height = 0
	end if
	_is_tablename = dw_file_listing.Object.DataWindow.Table.UpdateTable + "_FILES"	
	/* setup datawindow formatter service */
	lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_file_listing, false)
	/* position controls */
	if ii_buttonmode = 2 then	/* icons */
		li_button_height = pb_new.height
		li_button_width = pb_new.width
		li_buttonYPos = this.height - li_ole_height - (li_button_height + 20)
		if _ii_access_level <> EXTERNAL_APM   then
			pb_new.visible = true
			pb_update.visible = ib_enable_update_button
			pb_delete.visible = true
			pb_cancel.visible = ib_enable_cancel_button
		else
			dw_file_listing.settaborder( "description", 0)
		end if
		pb_new.y = li_buttonYPos
		if ib_enable_update_button then pb_update.y = li_buttonYPos
		pb_delete.y = li_buttonYPos
		pb_cancel.y = li_buttonYPos	
		if ib_enable_cancel_button then
			pb_cancel.x = this.width - (li_button_width + 20)
			pb_delete.x = pb_cancel.x - (li_button_width + li_spacer)		
		else
			pb_delete.x = this.width - (li_button_width + 20)
		end if
		if ib_enable_update_button then
			pb_update.x = pb_delete.x - (li_button_width + li_spacer)	
			pb_new.x = pb_update.x - (li_button_width + li_spacer)	
		else
			pb_new.x = pb_delete.x - (li_button_width + li_spacer)	
		end if
		li_infobox_xpos = pb_new.x - (st_infobox.width + 25)  
		if lb_treeview then
			pb_expandcollapse.y = li_buttonYpos
			pb_expandcollapse.visible = true
 			st_attachmentcounter.x = pb_expandcollapse.x + pb_expandcollapse.width + 25
		end if
		
	else  /* no button controls */
		li_button_height = 0
		li_button_width = 0
		li_buttonYPos = ((this.height - 25  ) - li_ole_height) - st_attachmentcounter.height
		li_infobox_xpos =  ( this.width - (dw_file_listing.x + 20)) - (st_infobox.width)  
	end if
	
	/* resize userobject to fit into container on parent window */
	dw_file_listing.x = 0
	dw_file_listing.y = 0
	dw_file_listing.height = li_buttonYPos - (dw_file_listing.y + 25)
	dw_file_listing.width = this.width - (dw_file_listing.x + 20)
	if ib_show_ole then 
		ole_document.x = dw_file_listing.x
		ole_document.width = dw_file_listing.width
	end if
	st_attachmentcounter.y = li_buttonYPos - 10
	ole_document.y = li_buttonYPos + 70
	ole_document.height = li_ole_height
	st_infobox.x = li_infobox_xpos
	st_infobox.y = li_buttonYPos - 10
	
	if dw_file_listing.Describe("insert_index.type") = "!" then
		return c#return.failure
	end if
	
	if _ib_columnresizable then
		dw_file_listing.of_setallcolumnsresizable( true )
		if dw_file_listing.Describe("t_updatefile.type")<>"!" then &
			dw_file_listing.of_setcolumnresize( "t_updatefile", false)
		if dw_file_listing.Describe("compute_openfile.type")<>"!" then &
			dw_file_listing.of_setcolumnresize( "compute_openfile", false)
	end if
	
return c#return.Success
end function

public function long of_getfileid ();/* public access to private variable used to identify attachment */
return _il_file_id
end function

public function integer of_addnewimage ();/********************************************************************
of_addnewimage( )

<DESC>
	Opens file dialogue window prompting user to select file. 
	Calls function to insert data into array.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	Usually from a button inside the object.
</USAGE>
********************************************************************/

string 					ls_docpath, ls_docname
integer 					li_rtn 
long 						ll_category

	
	
	
	if _istreeview( ) then
		_il_lastclickedrow = dw_file_listing.getrow()
		if _il_lastclickedrow  = 0 then
			_addmessage( this.classdefinition, "of_addnewimage()", "No category selected", "n/a")
			return c#return.Failure
		end if	
	end if	
	
	/* get file details from diaologue control */
	li_rtn = GetFileOpenName("Select Document", ls_docpath, ls_docname)
	if li_rtn < 1 then return c#return.failure
	setPointer(HourGlass!)
	dw_file_listing.setredraw( false )
	if _insertimage( ls_docpath, ls_docname, "(1 of 1)") = c#return.Failure then
		dw_file_listing.setredraw( true )
		return c#return.Failure
	end if
	of_setfilecounter()
	dw_file_listing.setredraw( true )
	
return c#return.success
end function

private function integer _replaceimage (integer al_row);/********************************************************************
_replaceimage

<DESC>
	Used to replace the file content in array from the current position
</DESC>
<RETURN>
	n/a
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	al_row: the current row selected in the datawindow
</ARGS>
<USAGE>
	Always from an event in the datawindow itself. soon to be obsolete
</USAGE>
<HISTORY>
	Date     CR-Ref        Author   Comments
	?        ?             ?        First Version
	09/12/14 CR3753        SSX014   File database archiving
</HISTORY>
********************************************************************/

long		ll_fileid, li_rtn, ll_filehandle, ll_file_size, ll_temp_file_id
integer  li_blobrow=1, li_row_index=1, li_att_index
string 	ls_docname, ls_docpath, ls_tablename, ls_Temp, ls_extension
boolean  lb_found = false
blob		lbl_filecontent
//CR3753
n_service_manager 	lnv_servicemgr
n_fileattach_service	lnv_attservice
string ls_dbname

constant string METHOD_NAME = "_replaceimage()"

	lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")
	
	// CR3753 Check if the file database is read-only
	ll_fileid = dw_file_listing.getItemNumber(al_row, "file_id")
	if not _canreplaceimage(ll_fileid, al_row) then
		return c#return.Failure
	end if
	
	li_rtn = GetFileOpenName("Select Document", ls_docpath, ls_docname)
	if li_rtn < 1 then return c#return.NoAction

	if isnull(ll_fileid) then 
		/* in the case of users being able to add records without attachments, when they add using the '+'
		icon this needs to be covered. */
		if ib_allownonattachrecs then
			if isnull(dw_file_listing.getItemNumber(al_row, "insert_index")) then
				// newly inserted record.  set insert index
				_il_new_file_id --
				dw_file_listing.setItem(al_row, "insert_index", _il_new_file_id)
			end if	
		end if	
		ll_fileid = dw_file_listing.getItemNumber(al_row, "insert_index")
	end if	
	
	if ib_ole then
		/* save data via the ole into blob - shared documents */
		if ole_document.insertfile( ls_docpath) <> 0 then
			_addmessage( this.classdefinition, METHOD_NAME, "Error loading selected document!", "n/a")
			return c#return.failure
		end if
		lbl_filecontent = ole_document.objectData
		ll_file_size = FileLength64(ls_docpath)
	else
		/* save data directly in blob - all other cases */
		ll_filehandle = fileopen(ls_docpath, streammode!,Read!, Shared!)
		ll_file_size = filereadex(ll_filehandle,lbl_filecontent)
		if ll_file_size <= 0 then
			_addmessage( this.classdefinition, METHOD_NAME, "Error loading selected file: please check if the file is empty.", "n/a")
			return c#return.failure
		end if
		fileclose(ll_filehandle)
	end if
	
	/* validate file size */
	if of_validatefilesize( ls_docname, ll_file_size ) = c#return.Failure then
		return c#return.Failure
	end if
	/* check extension */
	ls_extension = mid(ls_docname,lastpos(ls_docname,"."))
	if ls_extension = ".exe" or ls_extension = ".cmd" or ls_extension = ".bat" then
		_addmessage( this.classdefinition, METHOD_NAME, "Error attaching file: the file " + ls_docname + &
		" is not allowed to be attached inside Tramos." ,&
		"This file is an executable/batch/command.")
		st_infobox.visible = false
		return c#return.Failure
	end if
	/* truncate file name if required */
	if len(ls_docname) > ii_max_column_size then 
		ls_docname = left(ls_docname,ii_max_column_size - len(ls_extension)) + ls_extension
	end if		
	
	/* update any optional columns used in dw */
	if dw_file_listing.Describe("file_name.type")<>"!" then &
		dw_file_listing.setitem(al_row,"file_name", ls_docname)
	if dw_file_listing.Describe("file_updated_date.type")<>"!" then &
		dw_file_listing.setitem(al_row,"file_updated_date", now())
	if dw_file_listing.Describe("userid.type")<>"!" then &	
		dw_file_listing.setitem(al_row,"userid",  sqlca.userid)
	if dw_file_listing.Describe("insert_index.type")<>"!" then &	
		dw_file_listing.setitem(al_row,"insert_index", ll_fileid)
	//CR3753 Set file database name
	if dw_file_listing.Describe("db_name.type") <> "!" then 
		ls_dbname = lnv_attservice.of_getfiledbname()
		dw_file_listing.setitem(al_row, "db_name", ls_dbname)
	end if

	/* search array if file already accessed */
	for li_att_index = 1 to upperbound(_inv_att)
		if _inv_att[li_att_index].of_get_file_id() = ll_fileid then
			_inv_att[li_att_index].ibl_image = lbl_filecontent
			_inv_att[li_att_index].il_file_id = ll_fileid
			_inv_att[li_att_index].is_method = "mod"			
			_inv_att[li_att_index].il_file_size = ll_file_size
			lbl_filecontent=_inv_att[li_att_index].ibl_image		
			lb_found=true
			li_att_index = upperbound(_inv_att)
		end if
	next
	/* append attachment to array if not found above */	
	if not lb_found then
		_appendtoimagearray("mod",lbl_filecontent,ll_fileid,ll_file_size)
	end if
	/* sometimes object can be found inside a tab control */
	if getparent().typeof() = Window! then
		window  lw_parent
		lw_parent = getparent( )
		lw_parent.dynamic event ue_amendedFile()
	end if
	
return c#return.success
end function

private function integer _appendtoimagearray (string as_method, blob abl_image, long al_fileid, long al_filesize);/********************************************************************
_appendtoimagearray( /*string as_method*/, /*blob abl_image*/, /*long al_fileid*/, /*long al_filesize */)

<DESC>
	Adds new element to n_attachment array.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>   
	as_method: How was the attachment accessed by the user? 'new', 'del', 'delnull', 'open' or 'mod'
	abl_image: Blob content of file
	al_fileid: reference to the file id.
	al_filesize: contains size of file
</ARGS>
<USAGE>
	Call when we need to append a new item to array
</USAGE>
********************************************************************/

integer li_index 

	li_index = upperbound(_inv_att)+1
	
	_inv_att[li_index].ibl_image = abl_image
	_inv_att[li_index].il_file_id = al_fileid
	_inv_att[li_index].is_method = as_method
	_inv_att[li_index].il_file_size = al_filesize
return 1
end function

public subroutine of_clearimages ();/* empty the attachment array */
n_attachment lnvo_dummy[]
_inv_att = lnvo_dummy


end subroutine

private function integer _insertimage (string as_docpath, string as_docname);/********************************************************************
_insertimage( /*string as_docpath*/, /*string as_docname */)

<DESC>
	see override
</DESC>
********************************************************************/

return _insertimage( as_docpath, as_docname, "")
end function

public function integer of_deleteimage ();/********************************************************************
of_deleteimage( )

<DESC>
	Deletes blob content from array and deleterow from file 
	listing datawindow. It does not apply an update.
</DESC>
<RETURN> 
		Integer:
			<LI> 1, success
			<LI> -1, failure
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	From a button located on object, this function is used to support existing
	implementation of deleting an attachment record one at a time.
</USAGE>
********************************************************************/
return of_deleteimage(dw_file_listing.getselectedrow(0),false)

end function

private function integer _changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number);/********************************************************************
of_changeorder( /*integer ai_moved_row */,/*integer ai_row */,/*datawindow adw */,/*integer ai_number */)

<DESC>
	This function is change the order number when drag and drop			
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X ok
		<LI> -1, X failed										
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>    
	ai_moved_row: start row 
	ai_row:end row
	adw:datawindow you apply the dragdrop event
	ai_number:number you want to chagne the order with
</ARGS>
<USAGE>
	Called in dragdrop event of the adw
</USAGE>
********************************************************************/
integer li_row

	for li_row = ai_moved_row to ai_row 
		adw.setitem(li_row,"mt_sortorder",adw.getitemnumber(li_row, "mt_sortorder") + ai_number)
	next
return 1
end function

public subroutine of_setfilecounter ();/* Used to set file total in bottom left corner of object */
long ll_filtered_rows, ll_row_count, ll_exclude_count
string ls_retval 
boolean lb_treeview

lb_treeview=_istreeview( )

ls_retval = is_counterlabel

if lb_treeview  then
	if dw_file_listing.Describe("sum_of_attachments.type")<>"!" then 
		ls_retval += string(dw_file_listing.getitemnumber(1,"sum_of_attachments"))	
	else
		ls_retval += string(dw_file_listing.rowcount())
	end if
else
	ls_retval += string(dw_file_listing.rowcount())
	
	if ib_showfilteredcounter then
		ll_filtered_rows = dw_file_listing.filteredcount( )
		if ll_filtered_rows > 0 then
			ls_retval += "/" + string(ll_filtered_rows)
		end if
	end if
end if
this.st_attachmentcounter.text = ls_retval
end subroutine

public function integer of_updateattach ();/********************************************************************
of_updateattach()

<DESC>   
	Most commonly used update method.  If attachments have been 
	made, this function goes through the elements of the blob array that 
	has been built and writes them to the database.
</DESC>
<RETURN> 
	Integer:
    	<LI> 1, Success - commit on transaction made
	<LI> 0, NoAction - commit already processed
     <LI> -1, Failure - rollback completed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	checks the instance vars that are populated in the of_init
</ARGS>
<USAGE>
	For example, on an Update button in the main window that has 
	newly generated an id.  
</USAGE>
<HISTORY>
	Date     CR-Ref        Author   Comments
	?        ?             ?        First Version
	21/08/14 CR3753        SSX014   File database archiving
</HISTORY>
********************************************************************/

string					ls_tablename, ls_validatearg, ls_desc
long						li_amendments_index, ll_row, ll_file_row, ll_filehandle, ll_file_size, ll_fileid
integer 					li_row_index, li_blobrow = 1, li_file_trans_activated = 0, li_nbrofattachments
boolean 					lb_files_trans_success = true
n_service_manager 	lnv_servicemgr
n_fileattach_service	lnv_attservice
mt_n_transaction     lnv_fdbtrans
string               ls_errmsg
string               ls_errtitle
boolean              lb_postponemsgbox

constant string 		METHOD = "of_updateattach()"

dw_file_listing.accepttext()
if dw_file_listing.modifiedcount() > 0 or dw_file_listing.deletedcount() > 0 then
	if dw_file_listing.Describe("insert_index.type") = "!" then
		ls_errtitle = "Critical Error! Please contact " + C#EMAIL.TRAMOSSUPPORT + ",because this is missing an important column in datawindow"
		ls_errmsg = "Error! You must have a column called 'insert_index' in the dataobject you are using!"
		_addmessage(this.classdefinition, METHOD, ls_errtitle, ls_errmsg)
		return c#return.failure
	end if
	/* pre-populate key columns in datawindow */
	for li_row_index = 1 to dw_file_listing.rowcount()
		if dw_file_listing.GetItemStatus(li_row_index, 0, Primary!) <> NotModified! then
			if not isnull(_il_arg) then 
				if dw_file_listing.Describe("id.type") <> "!" then dw_file_listing.setitem(li_row_index, "id", _il_arg)
			end if
			
			if not isnull(_il_arg2) then 
				if dw_file_listing.Describe("id2.type") <> "!" then
					if left(dw_file_listing.Describe("id2.coltype"), len("char")) = "char" then
						dw_file_listing.setitem(li_row_index, "id2", string(_il_arg2))
					else
						dw_file_listing.setitem(li_row_index, "id2", _il_arg2)
					end if
				end if
			end if
			
			if not isnull(_is_arg) then 
				/* additional validation here as user can change the string argument (voyage number) themselves using the change popup window */
				if dw_file_listing.Describe("id_str.type") <> "!" then 
					ls_validatearg = dw_file_listing.getitemstring(li_row_index, "id_str")
					if isnull(ls_validatearg)  then
						dw_file_listing.setitem(li_row_index, "id_str", _is_arg)
					end if
				end if	
			end if

			if not isnull(_ii_arg) then 
				if dw_file_listing.Describe("id_int.type") <> "!" then dw_file_listing.setitem(li_row_index, "id_int", _ii_arg)
			end if

		end if
	next
	// Give the client of this class an opportunity to assign values for key columns
	if this.event ue_preupdateattach(dw_file_listing) = c#return.Failure then
		this.event ue_postupdateattach(dw_file_listing, c#return.failure, "", "")
		return c#return.Failure
	end if
	/* the update is made here so we can obtain the file_id */
	if _updatetables() = c#return.Success then
		li_nbrofattachments = upperbound(_inv_att)
		lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")
		if li_nbrofattachments > 0 then
			lb_postponemsgbox = lnv_attservice.of_postponemessagebox(true)
			lnv_fdbtrans = lnv_attservice.of_connectfiledb()
			if not isnull(lnv_fdbtrans) and isvalid(lnv_fdbtrans) then
				/* update files database for each element in object array*/
				for li_amendments_index = 1 to li_nbrofattachments
					
					ll_fileid = _inv_att[li_amendments_index].il_file_id	
					/* check method */
					CHOOSE CASE _inv_att[li_amendments_index].is_method
						CASE "new", "mod"
							of_infoboxwrite("Updating Attachment(s)...")
							li_row_index = dw_file_listing.find("insert_index=" + string(ll_fileid),1,dw_file_listing.rowcount())
							if li_row_index <= 0 then
								ls_errtitle = "Error attaching file(s)."
								ls_errmsg = "can not find file_id in datawindow.  complete transaction rolled back!"
								lb_files_trans_success = false
								exit
							end if
							ll_fileid = dw_file_listing.getitemnumber(li_row_index, "file_id")
							/* write to files database  */	
							if lnv_attservice.of_writeblob(_is_tablename, &
																	  ll_fileid, &
																	  _inv_att[li_amendments_index].ibl_image, &
																	  _inv_att[li_amendments_index].il_file_size, &
																	  lnv_fdbtrans ) = c#return.Failure then
								ls_errtitle = "Error adding new attached file. All attachments included will need to be applied again!"
								ls_errmsg = "complete transaction rolled back!"			
								lb_files_trans_success = false
								exit
							end if
						CASE "del"
							/* delete from files database */
							of_infoboxwrite("Deleting Attachment(s)..." )
							if lnv_attservice.of_deleteblob(_is_tablename,ll_fileid, lnv_fdbtrans) = c#return.Failure then
								ls_errtitle = "Error deleting the attached file. All attachments included will need to be applied again!"
								ls_errmsg = "complete transaction rolled back!"
								lb_files_trans_success = false
								exit
							end if
	
						CASE "open", "delnull"
							/* do nothing with db */
							
					END CHOOSE
				next
			else
				// failure in connecting the file database
				ls_errtitle = "Cannot connect to the current file database."
				ls_errmsg = "complete transaction rolled back!"
				lb_files_trans_success = false
			end if
		end if /* li_nbrofattachments > 0 */

		/* manage transaction objects accordingly */
		if lb_files_trans_success then
			/* success in both transaction objects. commit both! */
			commit using sqlca;
			if isvalid(lnv_fdbtrans) and not isnull(lnv_fdbtrans) then
				lnv_fdbtrans.of_commit()
				lnv_fdbtrans.of_disconnect()
			end if
			dw_file_listing.resetupdate()
			if isvalid(lnv_attservice) then
				lnv_attservice.of_postponemessagebox(lb_postponemsgbox)
			end if
			of_clearimages()
		else
			/* failure in files transaction processing */
			rollback using sqlca;
			if isvalid(lnv_fdbtrans) and not isnull(lnv_fdbtrans) then
				lnv_fdbtrans.of_rollback()
				lnv_fdbtrans.of_disconnect()
			end if
			of_infoboxwrite("")
			if isvalid(lnv_attservice) then
				lnv_attservice.of_postponemessagebox(lb_postponemsgbox)
			end if
			this.event ue_postupdateattach(dw_file_listing, c#return.failure, ls_errtitle, ls_errmsg)
			return c#return.failure
		end if
	else
		/* failure in commit of datawindow */
		rollback using sqlca;
		ls_errtitle = "Error updating data. All attachments included in requested change will need to be added again!"
		ls_errmsg = "datawindow dw_file_listing update failed. Complete rollback on both transaction objects made"
		of_infoboxwrite("")
		this.event ue_postupdateattach(dw_file_listing, c#return.failure, ls_errtitle, ls_errmsg)
		return c#return.failure
	end if
	this.event ue_postupdateattach(dw_file_listing, c#return.success, ls_errtitle, ls_errmsg)
end if
of_infoboxwrite("")
_il_lastfileid = ll_fileid
return c#return.success

end function

public subroutine of_cancelchanges ();/********************************************************************
of_addnewimage( )

<DESC>
	Resets the datawindow back and forces a new retreival 
</DESC>
<RETURN> 
	nil
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	nil
</ARGS>
<USAGE>
	called from a cancel button.  
	works only with the standard implementation (not shared documents)
</USAGE>
********************************************************************/
of_cancelchanges(true)
end subroutine

public function integer of_init (string as_arg, long al_arg);/********************************************************************
of_init( /*string as_stringarg*/, /*integer ai_intarg */)

<DESC>
	Initializes Object.  Only used inside Shared Documents
</DESC>
<RETURN> 
	Integer:
		<LI> 1, success
		<LI> -1 failure</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>   
	as_stringarg	: general string argument to help dataobject retreival
	ai_intarg		: general integer argument to help dataobject retreival
</ARGS>
<USAGE>  
	On open event of the containing window, call this method.  It maybe
	called from other events like after a deletion/addition too.
	Only of_init() override working with treeview datawindow type
</USAGE>
********************************************************************/
long li_buttonYPos 
long li_savedrow
integer li_rtncode
boolean lb_changed = false
DataWindowChild dwc_type

/* store private instance in object */
if _il_arg <> al_arg then
	_il_arg = al_arg
	lb_changed = true
end if
setnull(_il_arg2)
setnull(_ii_arg)
if _is_arg <> as_arg then
	_is_arg = as_arg
	lb_changed = true	
end if	

_il_new_file_id = 0
if lb_changed = false then return c#return.NoAction


// li_savedrow=dw_file_listing.getrow()
if li_savedrow=0 then li_savedrow = 1

if dw_file_listing.dataobject <> is_dataobjectname then
	dw_file_listing.dataobject = is_dataobjectname
	dw_file_listing.settransobject( SQLCA )
	_initvisualcontrols( )
end if
this.event ue_retrievefilelist(dw_file_listing)

if not _istreeview() then
	/* _il_arg in the proven case has an association to the pc_nr  */
	if dw_file_listing.Describe("filetype.type")<>"!" then 
		dw_file_listing.GetChild('filetype', dwc_type)
		dwc_type.SetTransObject(sqlca)
		dwc_type.Retrieve(_il_arg)
	end if
else
	/*  update the treeview as the source has changed */
	if lb_changed then
		dw_change.dataobject = "d_sq_tv" + mid(dw_file_listing.dataobject,8) + "_change"
		dw_change.settransobject(sqlca)
		dw_change.retrieve(_il_arg)	
	end if
	_il_grouplevel = long(dw_file_listing.Object.DataWindow.Tree.DefaultExpandToLevel)
end if

if dw_file_listing.rowcount( ) > 0 then
	if li_savedrow > 0 then
		dw_file_listing.selectRow(0,false)
		if li_savedrow > dw_file_listing.rowcount() then li_savedrow = dw_file_listing.rowcount()
		dw_file_listing.selectRow(li_savedrow,true)
		dw_file_listing.setrow(li_savedrow)
	else
		dw_file_listing.selectRow(1,true)
		dw_file_listing.setrow(1)
	end if
end if
_il_lastfileid = 0
of_setfilecounter( )
return c#return.Success
end function

private function integer _retrieveattach ();/********************************************************************
_retrieveattach( )

<DESC>
	datawindow retreival control.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>
	Uses _il_arg (long), _ii_arg (integer), _is_arg (string) and il_arg2(long)
</ARGS>
<USAGE>
	Using the values of the instance _arg variables determining
	what type of retreivals the dw_file_listing dataobject needs
</USAGE>
********************************************************************/

this.event ue_retrievefilelist(dw_file_listing)

if _istreeview( ) then
	if dw_file_listing.rowcount() > 0 then
		dw_file_listing.selectRow(0,false)
		dw_file_listing.selectRow(1,true)
		dw_file_listing.setrow(1)
	end if
end if

return c#return.success

end function

public function integer of_setlongarg (long al_arg);/* public access to set long retrieval argument value */
_il_arg = al_arg
return c#return.Success
end function

public subroutine of_setresizablecolumns (boolean ab_resize);/* 
flag used to determine if column resize in datawindow grid is switched on.
used in conjuction with datawindow style service.
*/
_ib_columnresizable = ab_resize


end subroutine

public function integer of_validatefilesize (string as_docname, long al_filesize);/********************************************************************
  of_validatefilesize( /*string as_docname*/, /*long al_filesize */)
  
<DESC>
	checks the attachment to see if the size is within the limit set
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
	as_docname: the attachment filename
	al_filesize: the current size of the file
</ARGS>
<USAGE>
	simple usage
</USAGE>
********************************************************************/

decimal{2}	ld_file_mb, ld_max_mb
constant string METHOD = "of_validatefilesize()"
	
	/* validate the size of the attachment */
	if al_filesize > il_max_size_bytes then
		ld_max_mb = il_max_size_bytes / 1048576
		ld_file_mb	= al_filesize / 1048576
		_addmessage( this.classdefinition, METHOD, "Error attaching selected file: the file " + as_docname + &
		" is too large. Tramos has a maximum of " + string(ld_max_mb) + "mb for each file stored." ,&
		"This file's size is " + string(ld_file_mb) + "mb which is " + string(ld_file_mb - ld_max_mb) + "mb too large." )
		return c#return.Failure
	elseif al_filesize < 0 then
		_addmessage( this.classdefinition, METHOD, "Error loading selected file: please check if the file is empty.", "n/a")
		return c#return.Failure	
	end if

return c#return.Success
end function

private function long _appendtoimagearray (string as_method, long al_fileid, long al_filesize);/********************************************************************
_appendtoimagearray( /*string as_method*/, /*blob abl_image*/, /*long al_fileid*/, /*long al_filesize */)

<DESC>
	Adds new element to n_attachment array.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>   
	as_method: How was the attachment accessed by the user? 'new', 'del', 'delnull', 'open' or 'mod'
	abl_image: Blob content of file
	al_fileid: reference to the file id.
	al_filesize: contains size of file</ARGS>
<USAGE>
	Call when we need to append a new item to array
</USAGE>
********************************************************************/
long ll_index 
	
	ll_index = upperbound(_inv_att)+1

	_inv_att[ll_index].il_file_id = al_fileid
	_inv_att[ll_index].is_method = as_method
	_inv_att[ll_index].il_file_size = al_filesize
return ll_index
end function

public function integer of_init ();/********************************************************************
of_init()

<DESC>   
	Initializes Object.
</DESC>
	<RETURN> Integer:
		<LI> 1, success
		<LI> -1 failure</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>  
</ARGS>
<USAGE>
	On open event of the containing window, call this method.  This is used primarily for the
	conversion process
</USAGE>
********************************************************************/

long ll_blobIndex, ll_file_size, ll_rows, ll_fileid
blob lbl_filecontent
pointer oldPointer
long li_savedrow

	li_savedrow=dw_file_listing.getselectedrow(0)
	setnull(_il_arg)
	setnull(_il_arg2)
	setnull(_ii_arg)
	setnull(_is_arg)
	_il_new_file_id = 0
	if dw_file_listing.dataobject<>is_dataobjectname  then
		/* store private instance in object */
		dw_file_listing.dataobject= is_dataobjectname
		dw_file_listing.settransobject( SQLCA )
		_initvisualcontrols( )
	end if
	this.event ue_retrievefilelist(dw_file_listing)
	if dw_file_listing.rowcount( )>0 then
		if li_savedrow > 0 then
			dw_file_listing.selectRow(0,false)
			if li_savedrow > dw_file_listing.rowcount() then li_savedrow = dw_file_listing.rowcount()
			dw_file_listing.selectRow(li_savedrow,true)
			dw_file_listing.setrow(li_savedrow)
		else
			dw_file_listing.selectRow(1,true)
			dw_file_listing.setrow(1)
		end if
	end if
	of_setfilecounter()

return c#return.Success
end function

public function integer of_purgetempfiles ();/********************************************************************
of_purgetempfiles

<DESC>
	Deletes all files possible in temp folder.  Uses listbox control
	function to find files in suggested folder
</DESC>
<RETURN> Integer:
	<LI> 1, X Success
	<LI> -1, X Failed</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>
</ARGS>
<USAGE>
	As little as possible, but when there has been some activity
</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_purgetempfiles()" 
string ls_backupdir, ls_tempdir, ls_wildcard
integer li_filenum
long ll_rows

	of_gettempfoldername(ls_tempdir)
	ls_wildcard = ls_tempdir + "*.*"
	lbx_tempfiles.dirlist(ls_wildcard, 0)
	for ll_rows = 1 to lbx_tempfiles.totalitems() 
		if ib_convert_process then	
			ls_backupdir = "c:\backupattach\"
			if directoryexists(ls_backupdir) then
				li_filenum =  filecopy(ls_tempdir + lbx_tempfiles.text(ll_rows), ls_backupdir + lbx_tempfiles.text(ll_rows), true)
			end if	
		end if
		if filedelete(ls_tempdir + lbx_tempfiles.text(ll_rows)) = false then
			/* 
			nothing to do - file is still open!
			*/
		end if
	next
return c#return.Success
end function

public function integer of_gettempfoldername (ref string as_tempdir);/********************************************************************
of_gettempfoldername( /*ref string as_tempdir */)

<DESC>
	Standard public function to get the full temp folder name
</DESC>
<RETURN> 
	Integer
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_tempdir: reference to string varibable
</ARGS>
<USAGE>  
</USAGE>
********************************************************************/

long ll_bufferlength= 256

constant string METHOD_NAME = "of_gettempfoldername()"
as_tempDir = SPACE(ll_bufferLength)
if GetTempPath(ll_bufferLength, as_tempdir) = 0 then
	 _addmessage( this.classdefinition, METHOD_NAME, "There is no temp path defined.  Unable to use attachment functions", "can not locate temp/tmp environment variables on this PC.")
	 return c#return.Failure
else
	as_tempdir += _is_tempsubfolder
	return c#return.Success
end if

end function

private function integer _insertimage (string as_docpath, string as_docname, string as_fileinfo);/********************************************************************
_insertimage( /*string as_docpath*/, /*string as_docname */, /*string as_fileinfo */)

<DESC>
	Adds the file passed in to the array
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_docpath: file path and name
	as_docname: file name
	as_fileinfo: used with userinfo statictext control
</ARGS>
<USAGE>
	Called when user adds an attachment.  This may be from a
	command button, or the dragover event.
</USAGE>
********************************************************************/
return _insertimage( as_docpath, as_docname, as_fileinfo, 0)
end function

public function integer of_infoboxwrite (string as_message);/* update message in statictext control */
if ib_showinfobox then
	st_infobox.setredraw( false )
	st_infobox.text=as_message
	st_infobox.setredraw( true )
	return c#return.Success
end if
end function

public function integer of_openattachment (long al_row);/* public access to private function */
return _openimage( al_row )
end function

public function integer _getcategory (ref long al_category);/********************************************************************
_getcategory( /*ref long al_category */)

<DESC>   
	Loads the category into a computed column, useful when there are
	no attachments in voyage.
</DESC>
<RETURN> Integer:
	<LI> 1, X Success
	<LI> 0, X NoAction
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	al_category: Description
</ARGS>
 <USAGE>  
 	Used to identfy the category. This function could 
	control the default values also 
</USAGE>
********************************************************************/


if _il_lastclickedrow>0 then
	if _istreeview( ) then
		/* need to use column lookup as user can dump file over a section header */
		al_category = dw_file_listing.getitemnumber(_il_lastclickedrow,"lookup_filetype")
	else	
		al_category = dw_file_listing.getitemnumber(_il_lastclickedrow,"filetype")
	end if
	return c#return.Success
else
	return c#return.NoAction
end if
end function

public function integer _changecategory (long al_row, long al_categoryid);/********************************************************************
   _changecategory( /*long al_row*/, /*long al_categoryid */)
	
   <DESC>   When the user changes the category this function moves the attachment and expands
	both categories highlighting the attachment in its new location.</DESC>
   <RETURN> Integer:
            <LI> 1, Success
	</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_row: row from
            al_category: the new category requiring move</ARGS>
   <USAGE>  called from the click event of the change datawindow.</USAGE>
********************************************************************/
long ll_fileid, ll_oldcategory, ll_expandrow

	ll_fileid = dw_file_listing.getitemnumber( al_row, "file_id") 	
	ll_oldcategory = dw_file_listing.getitemnumber(_il_lastclickedrow, "filetype")
	dw_file_listing.setitem(al_row,"filetype",al_categoryid) 
	_updaterows( )
	of_cancelchanges( )
	_expandtree(ll_fileid)
	ll_expandrow = dw_file_listing.find("filetype=" + string(ll_oldcategory),1, dw_file_listing.rowcount())
	dw_file_listing.Expand( ll_expandrow,_il_grouplevel)

return c#return.Success
end function

public function integer _changeidstr (long al_row, string as_idstr);/********************************************************************
   _changeidstr( /*long al_row*/, /*string as_idstr */)
   <DESC>  changes the string argument and refreshes datawindow</DESC>
   <RETURN> Integer:
            <LI> 1, Success
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_row: row reference
            as_idstr: the string argument.  for example its the voyage number</ARGS>
   <USAGE>  currently called from the 'change' window in the voyage documents.
	if the user selects to change the voyage number</USAGE>
********************************************************************/
dw_file_listing.setitem(al_row,"id_str",as_idstr)
_updaterows( )
/* refresh */
of_cancelchanges( )
		
return c#return.Success
end function

public function boolean _istreeview ();/* basic test against the dataobject */
if left(is_dataobjectname,7) = "d_sq_tv" then
	return true
else
	return false
end if
end function

public function boolean _getattachrow ();/********************************************************************
   _getattachrow( )
   <DESC>   Get the row number even if clicking in header/title</DESC>
   <RETURN> Boolean:
            <LI> true, Success
            <LI> false Failure</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>Currently only applicable for treeview datawindow.  When dragging onto the 
	section header it is not possible to obtain the row without this function.</USAGE>
********************************************************************/


boolean lb_continue = true
string ls_obj, ls_name
string ls_band



	if _istreeview() or ib_allownonattachrecs  then
		ls_band = dw_file_listing.GetBandAtPointer()
		if Left( ls_band, Pos( ls_band, "~t") - 1 ) <>"header" then
			ls_obj = dw_file_listing.GetObjectAtPointer()
			ls_name = Left( ls_obj, Pos( ls_obj, "~t") - 1 ) 
			_il_lastclickedrow = Long( Right( ls_obj, Len( ls_obj ) - Pos( ls_obj, "~t") ) ) 	
		end if
		if _il_lastclickedrow > 0 and _istreeview() then
			dw_file_listing.setredraw(false)
		elseif ib_allownonattachrecs then
			if pos(ls_obj,"updatefile")=0 then
				_il_lastclickedrow=0
			end if
		elseif not (ib_allownonattachrecs)  then
			_addmessage( this.classdefinition , "_getattachrow()", "Warning, Please try again, unable to identify where you want to drop file!", "No section defined. row number is 0")			
			lb_continue = false
		end if	
	end if
return lb_continue
end function

public function integer _expandtree (long al_fileid);return  _expandtree(al_fileid, true)
end function

public function integer _expandtree (long al_fileid, boolean ab_highlightrow);/********************************************************************
  _expandtree
   <DESC>   closes all branches and expands the tree where selected
	row is found.</DESC>
   <RETURN> Integer:
            <LI> 1, Success
	</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_fileid: the fileid that needs to be located
            ab_highlightrow: if we want to highlight row, default true</ARGS>
   <USAGE>  When we add/delete/move attachments.</USAGE>
********************************************************************/


long ll_row_selected

	if al_fileid>0 then
		if ab_highlightrow then
			ll_row_selected =  dw_file_listing.find("file_id=" + string(al_fileid), 1,  dw_file_listing.rowcount())
		else
			ll_row_selected = _il_lastclickedrow
		end if
		dw_file_listing.selecttreenode(0,2,false)
		dw_file_listing.selecttreenode(0,1,false)		
		dw_file_listing.Expand(ll_row_selected,_il_grouplevel)
		if ab_highlightrow then
			dw_file_listing.SelectRow (0,false)
			dw_file_listing.SelectRow (ll_row_selected,true)
			dw_file_listing.ScrollToRow(ll_row_selected)
		end if
		dw_file_listing.setfocus( )
	else
		ll_row_selected = dw_file_listing.getselectedrow(0)
		dw_file_listing.SelectRow (0,false)
		dw_file_listing.SelectRow (ll_row_selected,true)
		dw_file_listing.setrow( ll_row_selected)
	end if

return c#return.Success
end function

public function integer of_showole ();/* force a rowfocuschanged event */
if ib_show_ole then
	dw_file_listing.event rowfocuschanged(dw_file_listing.getrow() )	
end if
return c#return.Success
end function

public subroutine of_cancelchanges (boolean ab_emptyarray);/********************************************************************
of_addnewimage( )

<DESC>
	Resets the datawindow back and forces a new retreival 
</DESC>
<RETURN> 
	nil
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	nil
</ARGS>
<USAGE>
	called from a cancel button.  
	works only with the standard implementation (not shared documents)
</USAGE>
********************************************************************/

dw_file_listing.accepttext()
dw_file_listing.resetupdate()
of_infoboxwrite( "" )
_retrieveattach()
if ab_emptyarray then of_clearimages()
of_setfilecounter()
end subroutine

public function integer of_getattachment (ref n_attachment anv_attachment, long al_fileid, long al_newfileid);
/********************************************************************
 of_getattachment( /*ref n_attachment anv_attachment*/, /*long al_fileid*/, /*long al_newfileid */)

   <DESC>   This is a public access function that gets the file data when passed the al_fileid value.
	It also resets this value if al_newfileid is different.  Automatically resetting the fileid in the array.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   anv_attachment - Used to load found array element into
            al_fileid: current id to search for
		al_newfileid: file id to replace for if array element is newGS>
   <USAGE>  Used only from shared documents right now.</USAGE>
********************************************************************/

long li_index

if upperbound(_inv_att)>0 then
for li_index = 1 to upperbound(_inv_att)
	if _inv_att[li_index].il_file_id = al_fileid then
		if al_fileid<> al_newfileid then _inv_att[li_index].il_file_id = al_newfileid
		anv_attachment = _inv_att[li_index]
		exit
	end if
next
else
	return c#return.NoAction
end if

return c#return.Success
end function

public function integer of_setaccesslevel (integer ai_accesslevel);/* conditional control of user access. */
_ii_access_level = ai_accesslevel

if ai_accesslevel = EXTERNAL_APM then
	ib_allow_dragdrop = false
	RevokeDragDrop( Handle(Parent) )
end if

return c#return.success
end function

public function boolean _updatefiles ();/* not used */
boolean lb_update = false
integer li_index

for li_index = 1 to upperbound(_inv_att)
	if _inv_att[li_index].is_method = "new" or _inv_att[li_index].is_method = "mod" or _inv_att[li_index].is_method = "del" then
		lb_update = true
	end if
next	

return lb_update
end function

private function integer _saveexpanded (ref long al_expanded[]);/********************************************************************
  _saveexpanded( /*ref long al_expanded[] */)
  
   <DESC>   Passing in a numeric array check rows in dw whether they are expanded or not. </DESC>
   <RETURN> Integer:
            <LI> 1, Success
</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_expanded: reference to numeric Array
	</ARGS>
   <USAGE>  save the current expanded nodes.  Once actions have been commited call _restoreexpanded()
				grouplevel may also be configured.
	</USAGE>
********************************************************************/
long ll_row, ll_category

if _istreeview( ) then
	for ll_row = 1 to dw_file_listing.rowcount()
		if dw_file_listing.getitemnumber(ll_row,"filetype") <> ll_category then						
			ll_category = dw_file_listing.getitemnumber(ll_row,"filetype")
			if dw_file_listing.isexpanded( ll_row, _il_grouplevel) then
				al_expanded[upperbound(al_expanded) + 1]	 = ll_row
			end if	
		end if
	next
end if

return c#return.Success
end function

public function integer _restoreexpanded (long al_expanded[], long al_rowposition, long al_quantity);/********************************************************************
  _restoreexpanded( /* long al_expanded[] */)
  
   <DESC>   Passing in a previously saved numeric array, expand tree nodes where possible. </DESC>
   <RETURN> Integer:
            <LI> 1, Success
</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_expanded: numeric Array
	</ARGS>
   <USAGE>  use _saveexpanded() function to store the expanded nodes.  Call this
	function after processes to regenerate the expanded branches.
	
	Improvements: Needs to work when user adds/deletes attachments too.
	we need to pass 2 numeric values.  
	1- original row position (maybe obtained anyway)
	2- number of additonal/deleted rows.  eg -1, 1, -5 etc.  default 0
	Grouplevel may be set from parent object.
	</USAGE>
********************************************************************/
long ll_category

if _istreeview( ) then
	if upperbound(al_expanded)>0 then
		for ll_category = 1 to upperbound(al_expanded)
			dw_file_listing.expand(al_expanded[ll_category],_il_grouplevel)
		next
	end if
end if
return c#return.Success
end function

public function integer of_init (string as_arg, long al_arg, long al_arg2, integer ai_arg);/********************************************************************
of_init()

<DESC>   
	Initializes Object.
</DESC>
	<RETURN> Integer:
		<LI> 1, success
		<LI> -1 failure</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>  
</ARGS>
<USAGE>
	On open event of the containing window, call this method.  This is used primarily for the
	conversion process
</USAGE>
********************************************************************/

long ll_blobIndex, ll_file_size, ll_rows, ll_fileid
boolean lb_changed
blob lbl_filecontent
pointer oldPointer
long li_savedrow

	li_savedrow=dw_file_listing.getselectedrow(0)
	if _il_arg <> al_arg then
		_il_arg = al_arg
		lb_changed = true
	end if
	if _il_arg2 <> al_arg2 then
		_il_arg2 = al_arg2
		lb_changed = true
	end if
	if _is_arg <> as_arg then
		_is_arg = as_arg
		lb_changed = true	
	end if		
	if _ii_arg <> ai_arg then
		_ii_arg = ai_arg
		lb_changed = true	
	end if		
	_il_new_file_id = 0
	if dw_file_listing.dataobject<>is_dataobjectname  then
		/* store private instance in object */
		dw_file_listing.dataobject= is_dataobjectname
		dw_file_listing.settransobject( SQLCA )
		_initvisualcontrols( )
	end if
	this.event ue_retrievefilelist(dw_file_listing)
	if dw_file_listing.rowcount( )>0 then
		if li_savedrow > 0 then
			dw_file_listing.selectRow(0,false)
			if li_savedrow > dw_file_listing.rowcount() then li_savedrow = dw_file_listing.rowcount()
			dw_file_listing.selectRow(li_savedrow,true)
			dw_file_listing.setrow(li_savedrow)
		else
			dw_file_listing.selectRow(1,true)
			dw_file_listing.setrow(1)
		end if
	end if
	of_setfilecounter()

return c#return.Success
end function

private function integer _insertimage (string as_docpath, string as_docname, string as_fileinfo, long al_row);/********************************************************************
_insertimage( /*string as_docpath*/, /*string as_docname */, /*string as_fileinfo */)

<DESC>
	Adds the file passed in to the array
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_docpath: file path and name
	as_docname: file name
	as_fileinfo: used with userinfo statictext control
</ARGS>
<USAGE>
	Called when user adds an attachment.  This may be from a
	command button, or the dragover event.
</USAGE>
<HISTORY>
	Date     CR-Ref        Author   Comments
	?        ?             ?        First Version
	09/12/14 CR3753        SSX014   File database archiving
</HISTORY>
********************************************************************/

blob lbl_filecontent
long ll_filehandle, ll_file_size, ll_file_row,ll_order, ll_rows, ll_i, ll_categoryid,ll_row_selected, ll_fileid
string ls_extension, ls_filename, ls_i, ls_exttype
decimal{2}	ld_file_mb, ld_max_mb
boolean lb_stop, lb_treeview=false
mt_n_stringfunctions		lnv_stringfunctions
constant string METHOD_NAME = "_insertimage"
pointer lpnt_old

//CR3753 Set file database name
n_service_manager 	lnv_servicemgr
n_fileattach_service	lnv_attservice
string ls_dbname

	lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")
	
	// CR3753 Check if the file database is read-only
	ls_dbname = lnv_attservice.of_getfiledbname()
	if lnv_attservice.of_isfiledbreadonly(ls_dbname) then
		_addmessage(this.classdefinition, METHOD_NAME, &
			"Cannot insert a file because the file database '" + ls_dbname + "' is read-only", &
			"")
		return c#return.Failure
	end if
	
	if al_row=0 then 
		_il_new_file_id --
		ll_fileid = _il_new_file_id
	else
		ll_fileid = dw_file_listing.getitemnumber(al_row,"file_id")
		if isnull(ll_fileid) then
			_il_new_file_id --
			ll_fileid = _il_new_file_id
		end if	
	end if	
		
	/* validate file size */
	ll_file_size = FileLength64(as_docpath)
	if of_validatefilesize( as_docname, ll_file_size ) = c#return.Failure then
		return c#return.Failure
	end if

	/* validate file extension */
	ls_exttype = mid(as_docname,lastpos(as_docname,".") + 1)
	if ls_exttype = "exe" or ls_exttype = "cmd" or ls_exttype = "bat" then
		_addmessage( this.classdefinition, METHOD_NAME, "Error attaching file: the file " + as_docname + &
		" is not allowed to be attached inside Tramos." ,&
		"This file is an executable/batch/command.")
		st_infobox.visible = false
		return c#return.Failure
	end if
	
	st_infobox.text="Loading Attachment... " + as_fileinfo
	if ib_ole then
		/* save data via the ole_document into blob - used only in shared docs */
		if ole_document.insertfile( as_docpath) <> 0 then
			_addmessage( this.classdefinition, METHOD_NAME, "Error loading selected document!", "n/a")
			st_infobox.visible = false
			return c#return.failure
		end if
		lbl_filecontent = ole_document.objectData
	else
		/* save data directly into blob - all other cases */
		ll_filehandle = fileopen(as_docpath, streammode!,Read!, Shared!)
		ll_file_size = filereadex(ll_filehandle,lbl_filecontent)
		fileclose(ll_filehandle)
	end if
	
	/* check if we need to insert a new row or use the current row */
	if al_row=0 then
		ll_file_row = dw_file_listing.insertrow(0)
	else
		ll_file_row = al_row
	end if

	/* remove ctrl characters if needed description */
	//Activate UTF8 comment line in the future
	lnv_stringfunctions.of_replacectrlchars(as_docname)
	
	/* truncate file name if required */
	if len(as_docname) > ii_max_column_size then 
		ls_extension = mid(as_docname,lastpos(as_docname,"."))
		ls_filename = left(as_docname,ii_max_column_size - len(ls_extension)) + ls_extension
	else
		ls_filename = as_docname		
	end if		
	
	if ib_allow_repeated_filenames = false then
		/* if file name is repeated then add a number in the end of the file name */
		lb_stop = false
		ll_i = 1
		ll_rows = dw_file_listing.rowcount( )
		do while lb_stop = false
			if dw_file_listing.find("file_name = '" + ls_filename+"'", 1, ll_rows) = 0 then
				lb_stop = true
			else
				ls_i = string(ll_i)
				ls_extension = mid(as_docname,lastpos(as_docname,"."))
				if len(as_docname) + len(ls_i) > ii_max_column_size then 
					ls_filename = left(as_docname ,ii_max_column_size - len(ls_extension)-len(ls_i)) + ls_i + ls_extension
				else
					ls_filename = left(as_docname , len(as_docname) - len(ls_extension)) + ls_i + ls_extension
				end if
				ll_i = ll_i+1
			end if
		loop
	end if
		
	/* important setting must be available whenever there is editable rights */
	if dw_file_listing.Describe("insert_index.type")<>"!" then &
		dw_file_listing.setitem(ll_file_row,"insert_index", ll_fileid)

	/* optional settings that may be found in the datawindow object  depending on case */
	if dw_file_listing.Describe("mt_sortorder.type")<>"!" then	
		if ll_file_row = 1 then
			ll_order = 1
		else
			ll_order = dw_file_listing.getitemnumber( ll_file_row , "mt_maxsortorder") + 1
		end if
		dw_file_listing.setitem( ll_file_row , "mt_sortorder",ll_order)
	end if	

	if dw_file_listing.Describe("file_updated_date.type")<>"!" then &
		dw_file_listing.setitem(ll_file_row,"file_updated_date", now())

	if dw_file_listing.Describe("userid.type")<>"!" then &	
		dw_file_listing.setitem(ll_file_row,"userid", sqlca.userid)
	
	if dw_file_listing.Describe("userid2.type")<>"!" then &	
		dw_file_listing.setitem(ll_file_row,"userid2", sqlca.userid)
		
	if dw_file_listing.Describe("userid3.type")<>"!" then &	
		dw_file_listing.setitem(ll_file_row,"userid3", sqlca.userid)
	
	if dw_file_listing.Describe("description.type")<>"!" then 
		if not(ib_allownonattachrecs and _il_lastclickedrow<>0)  then
			dw_file_listing.setitem(ll_file_row, "description", as_docname)
		end if
	end if
	if dw_file_listing.Describe("file_name.type")<>"!" then &			
		dw_file_listing.setitem(ll_file_row, "file_name", ls_filename)

	//CR3753 Set file database name
	if dw_file_listing.Describe("db_name.type") <> "!" then 
		dw_file_listing.setitem(ll_file_row, "db_name", ls_dbname)
	end if
	/* end of optional settings in dw */
	
	_appendtoimagearray( "new", lbl_filecontent, ll_fileid, ll_file_size)
	
	/* load category if possible */
	if dw_file_listing.Describe("filetype.type")<>"!" then
		if _getcategory(ll_categoryid) = c#return.Success then
			dw_file_listing.setitem(ll_file_row,"filetype", ll_categoryid)
		end if
	end if
	if _istreeview() then
		_updaterows()
		of_cancelchanges( )
		_expandtree(_il_lastfileid)
	elseif ib_autosave then
		_updaterows()
		of_cancelchanges( )
		dw_file_listing.selectrow( 0, false)
		dw_file_listing.selectrow( ll_file_row, true)
		dw_file_listing.scrolltorow(ll_file_row)
	else	
		dw_file_listing.ScrollToRow(ll_file_row)
		st_infobox.text=""
	end if	
	
return c#return.success
end function

public function integer of_setargs (string as_arg, long al_arg, long al_arg2, integer ai_arg);/* public access to set long retrieval argument value */
_is_arg =  as_arg
_il_arg = al_arg
_il_arg2 = al_arg2
_ii_arg = ai_arg

return c#return.Success
end function

public function integer of_sharedata (ref mt_n_datastore ads);return ads.sharedata(this.dw_file_listing)
end function

private function integer _openimage (long al_row, mt_u_datawindow adw);/********************************************************************
_openimage( /*long al_row */)

<DESC>
	Normally called when user clicks on the file icon in the datawindow 
	this loads the array and opens the attachment. It may be opened from the 
	rowfocuschanged event also
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X ok
      	<LI> -1, X failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	al_row: row in datawindow
</ARGS>
<USAGE>
	Called normally from the icon p_openimage.
</USAGE>
<HISTORY>
	Date     CR-Ref        Author   Comments
	?        ?             ?        First Version
	21/08/14 CR3753        SSX014   File database archiving
	04/09/14 CR2420        LHG008   Fix bug for open file via ole object
</HISTORY>
********************************************************************/

long 							ll_fileid, ll_filehandle, ll_filesize = 9999
string 						ls_filename, ls_tablename, ls_tempdir
string						ls_extensionsegment,ls_filenamesegment, ls_fileidsegment
blob							lbl_filecontent
integer						li_blobrow = 1, li_dwrow = 1, li_att_index, li_convertretval
boolean						lb_found=false, lb_oleload = true
n_olefilecontent			lnv_olefilecontent
n_service_manager 		lnv_servicemgr
n_fileattach_service		lnv_attservice
pointer 						oldpointer

SHELLEXECUTEINFO 		lstr_sei 		// structure located within this object

constant long 				SW_SHOWNORMAL					= 1
constant long 				SEE_MASK_NOCLOSEPROCESS 	= 64
constant string 			METHOD_NAME 						= "_openimage()"


/* general initialisation */
st_infobox.setredraw( false )
of_infoboxwrite("Opening Attachment...")
st_infobox.setredraw( true )
ll_fileid = adw.getItemNumber(al_row, "file_id")
ls_filename = adw.getItemString(al_row, "file_name")
if adw.Describe("tablename.type") <> "!" then 
	ls_tablename = upper(adw.getItemString(al_row,"tablename")) + "_FILES"
else
	ls_tablename = _is_tablename
end if
if isnull(ll_fileid) then
	ll_fileid = adw.getItemNumber(al_row, "insert_index")
end if
/* determine if attachment has been opened already */
for li_att_index = 1 to upperbound(_inv_att)
	if _inv_att[li_att_index].of_get_file_id() = ll_fileid then
		lbl_filecontent = _inv_att[li_att_index].ibl_image		
		lb_found=true
		li_att_index = upperbound(_inv_att)
	end if
next
/* if not accessed already we locate from database */
of_gettempfoldername(ls_tempdir)
if not lb_found then
	lnv_servicemgr.of_loadservice( lnv_attservice, "n_fileattach_service")
	if lnv_attservice.of_readblob(ls_tablename,ll_fileid, lbl_filecontent) = c#return.Failure then
		_addmessage( this.classdefinition, METHOD_NAME, "There is no file attached.", "n/a")
	end if
	_appendtoimagearray( "open", lbl_filecontent , ll_fileid , 9999)
end if
if ib_ole then
	ole_document.objectData = lbl_filecontent
	if ib_show_ole = false or _ib_openimage then
		if ole_document.classlongname = "Package" then
			ole_document.activate(inplace!)
		else
			ole_document.post activate(offsite!)
		end if
	end if
	of_infoboxwrite("")
	return c#return.Success
else
	if not DirectoryExists(ls_tempdir) then   
		CreateDirectory(ls_tempdir) 
	end if
	if DirectoryExists(ls_tempdir) then
		/* now we open blob into file */
		ls_extensionsegment = mid(ls_filename,lastpos(ls_filename,"."))
		ls_filenamesegment = mid(ls_filename,1,lastpos(ls_filename,".") - 1) + "_"
		ls_fileidsegment = string(abs(ll_fileid),"000000")
		if not isnull(lbl_filecontent) then
			ls_filename = ls_filenamesegment + ls_fileidsegment + ls_extensionsegment
			ll_filehandle = fileopen(ls_tempDir + ls_filename, streammode!, write!, lockwrite!, replace!)
			filewriteex(ll_filehandle, lbl_filecontent) 
			fileclose(ll_filehandle)
			lstr_sei.cbSize = 60
			lstr_sei.fMask  = SEE_MASK_NOCLOSEPROCESS
			lstr_sei.hWnd   = Handle(this)
			lstr_sei.lpVerb = ""
			lstr_sei.lpFile = ls_tempdir + ls_filename
			lstr_sei.nShow  = SW_SHOWNORMAL
			/* now open the attachment and let the OS decide what application to associate */				
			If ShellExecuteEx(lstr_sei) then
				of_infoboxwrite("")
				return c#return.Success
			else
				_addmessage( this.classdefinition, METHOD_NAME, "Error, Unable to open attachment.", ls_tempDir + ls_filename)
			end if
		end if				
	else	
		_addmessage( this.classdefinition, METHOD_NAME, "Error, Unable to create/access temporary tramos folder.",  ls_tempDir)
	end if
end if
of_infoboxwrite("")

return c#return.Failure
end function

public function integer of_openattachment (long al_row, mt_u_datawindow adw);/* public access to private function */
if _is_tablename="" then
	_is_tablename = adw.Object.DataWindow.Table.UpdateTable + "_FILES"	
end if	
return _openimage( al_row, adw )
end function

public function integer of_deleteimage (long al_deleterow, boolean ab_batch);/********************************************************************
of_deleteimage( )

<DESC>
	Deletes blob content from array and deleterow from file 
	listing datawindow. It does not apply an update.
</DESC>
<RETURN> 
		Integer:
			<LI> 1, success
			<LI> -1, failure
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	al_deleterow (long)		:single row to delete
	ab_batch	 (boolean)		:if batch messagebox should be hidden when transations are made
</ARGS>
<USAGE>
	Usually from a button located on object
</USAGE>
<HISTORY>
	Date     CR-Ref        Author   Comments
	?        ?             ?        First Version
	09/15/14 CR3753        SSX014   File database archiving
	01/22/15 CR3570        SSX014   Change double '??' to single '?'
</HISTORY>
********************************************************************/

long 			ll_deleterow, ll_fileid, ll_row, ll_deletedfileid, ll_categorydeletedfrom, ll_nextrow, ll_newrowcategory

integer 		li_blobrow = 1, li_dwrow = 1, li_att_index
blob			lbl_dummy
string		ls_filename, ls_description
boolean 		lb_found

constant string METHOD_NAME = "of_deleteimage()"
	
	if al_deleterow=0 then return c#return.NoAction
	if _istreeview( ) then
		_getcategory( ll_categorydeletedfrom)
		if isnull(dw_file_listing.getitemnumber(al_deleterow, "filetype")) and not ab_batch then
			_addmessage( this.classdefinition, METHOD_NAME, "Can not delete. This is already empty!", "n/a")
			return c#return.NoAction
		else
			dw_file_listing.setredraw( false )
		end if	
	end if

	/* validate deleted row */
	ll_fileid = dw_file_listing.getitemnumber( al_deleterow , "file_id")
	if isnull(ll_fileid) then
		ll_fileid = dw_file_listing.getitemnumber( al_deleterow , "insert_index")
	end if
	ls_filename = dw_file_listing.getitemstring(al_deleterow,"file_name")
	ls_description = dw_file_listing.getitemstring(al_deleterow,"description")
	if isnull(ls_filename) then ls_filename="*unknown*"
	if al_deleterow = 0 and not ab_batch then
		messagebox("Info","Please select a file.")
		dw_file_listing.setredraw( true )
		return c#return.NoAction
	end if
	
	// CR3753 Check if the file database is read-only
	if not _candeleteimage(ll_fileid, al_deleterow) then
		return c#return.Failure
	end if
	if not ab_batch then
		if MessageBox("Delete", "You are about to delete the file~r~n~r~nFile Name: " + ls_filename + "~r~n~r~nFile Description: " + ls_description +"~r~n~r~nAre you sure you want to DELETE this?",Question!,YesNo!,1)=2 then
			dw_file_listing.setredraw( true )
			return c#return.NoAction
		end if
	end if
	dw_file_listing.deleterow(al_deleterow)
	/* search arrary if attachment has been accessed before */
	for li_att_index = 1 to upperbound(_inv_att)
		if _inv_att[li_att_index].of_get_file_id() = ll_fileid then
			_inv_att[li_att_index].ibl_image = lbl_dummy
			_inv_att[li_att_index].il_file_id = ll_fileid
			if _inv_att[li_att_index].is_method = "new" then
				_inv_att[li_att_index].is_method = "delnull"
			else
				_inv_att[li_att_index].is_method = "del"			
			end if	
			_inv_att[li_att_index].il_file_size = 0
			lb_found=true
			li_att_index = upperbound(_inv_att)
		end if
	next
	/* if attachment not found in array create new */
	if not lb_found then
		_appendtoimagearray("del",lbl_dummy,ll_fileid,0)
	end if
	/* if sequencing available, rearrange numbers */
	if dw_file_listing.Describe("mt_sortorder.type") <> "!" then	
		for ll_row = 1 to dw_file_listing.rowcount()
			dw_file_listing.setitem( ll_row , "mt_sortorder",ll_row)
		next	
	end if
	
	if _istreeview( )  then
				
		_updaterows()
		of_cancelchanges( )
		if dw_file_listing.rowcount()>0 then
			ll_newrowcategory = dw_file_listing.getitemnumber(al_deleterow,"lookup_filetype")
			if ll_newrowcategory = ll_categorydeletedfrom then
				ll_nextrow = al_deleterow
			else
				ll_newrowcategory = dw_file_listing.getitemnumber(al_deleterow - 1,"lookup_filetype")
				if ll_newrowcategory = ll_categorydeletedfrom then
					ll_nextrow = al_deleterow - 1
				else
					ll_nextrow = al_deleterow
				end if
			end if
		end if
		
		dw_file_listing.selecttreenode(0,2,false)
		dw_file_listing.selecttreenode(0,1,false)		
		dw_file_listing.Expand(ll_nextrow,_il_grouplevel)
		dw_file_listing.SelectRow (0,false)
		dw_file_listing.SelectRow (ll_nextrow,true)
		dw_file_listing.ScrollToRow(ll_nextrow)
		dw_file_listing.setredraw(true)		
	elseif ib_autosave then
		_updaterows()
		of_cancelchanges( )
		if al_deleterow > dw_file_listing.rowcount() then
			ll_nextrow = dw_file_listing.rowcount()
		else
			ll_nextrow = al_deleterow
		end if
		/* only reselect row if not batch deletion and next row is valid */
		if not ab_batch and ll_nextrow > 0 then
			dw_file_listing.SelectRow (0,false)
			dw_file_listing.SelectRow (ll_nextrow,true)
			dw_file_listing.ScrollToRow(ll_nextrow)
		end if	
	end if	
	of_setfilecounter()

return c#return.success
end function

public function integer of_get_attachment_count ();/********************************************************************
   of_get_attachment_count
   <OBJECT>		Get files count	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author			Comments
   	02/01/2014	CR3085		WWG004			First Version
   </HISTORY>
********************************************************************/

long	ll_files_count

ll_files_count = dw_file_listing.rowcount()

return ll_files_count
end function

public function integer of_modified_count ();/********************************************************************
   of_modified_count
   <OBJECT>		return changed attachment files	</OBJECT>
   <USAGE>		check the files changed			</USAGE>
   <ALSO>		none			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	02/01/2014	CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

long	ll_modified_count

ll_modified_count = dw_file_listing.deletedcount() + dw_file_listing.modifiedcount()

return ll_modified_count
end function

protected function long _updatetables ();/********************************************************************
   _updatetables
   <DESC>	Update file tables	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Called in the funciton of_updateattach()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index, ll_idxkey, ll_idxall, ll_col
long ll_upperbound, ll_upperkeycol, ll_upperallcol, ll_colcount
string ls_modify, ls_tblname, ls_colname, ls_dbname
mt_n_stringfunctions lnv_string

if not ib_multitableupdate then
	_is_updatesallowed = 'IUD'
	_setdefaultvalue()
	return dw_file_listing.update(true, false)
end if

ll_upperbound = upperbound(_istr_multiupdate[])
// Don't forget to call of_addupdatetable() functions before calling this function
if ll_upperbound <= 0 then
	return c#return.Failure
end if

// Begin to update tables

// First:
// Delete the records that have references to the table of ATTACHEMENTS
// so that the related records of the table ATTACHMENTS can be deleted 
// as well

for ll_index = ll_upperbound to 1 step -1
	// Cleaning up
	ll_colcount = long (dw_file_listing.Object.DataWindow.Column.Count)
	for ll_col = 1 to ll_colcount
		ls_colname = "#" + string(ll_col)
		ls_modify = dw_file_listing.modify(ls_colname + ".update='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = dw_file_listing.modify(ls_colname + ".identity='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = dw_file_listing.modify(ls_colname + ".key='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next
	
	// Get the table name
	ls_tblname = _istr_multiupdate[ll_index].tablename

	// ignore the table of ATTACHMENTS
	if ls_tblname = "ATTACHMENTS" then
		continue
	end if
	
	// Set the table to update	
	ls_tblname = lnv_string.of_replaceall(ls_tblname, "'", "~~'", false)
	ls_modify = dw_file_listing.modify("DataWindow.Table.UpdateTable='" + ls_tblname + "'" )
	if ls_modify <> "" then
		return c#return.Failure
	end if
	
	// Set update properties for all columns
	ll_upperallcol = upperbound( _istr_multiupdate[ll_index].allcolumns[] )
	for ll_idxall = 1 to ll_upperallcol
		// Set the update property
		ls_colname = _istr_multiupdate[ll_index].allcolumns[ll_idxall]
		ls_modify = dw_file_listing.modify(ls_colname + ".update='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the dbname property
		ls_dbname = _istr_multiupdate[ll_index].alldbcolumns[ll_idxall]
		ls_dbname = lnv_string.of_replaceall(ls_dbname, "'", "~~'", false)
		ls_modify = dw_file_listing.modify(ls_colname + ".dbname='" + ls_dbname + "'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Set the key properties for the key columns
	ll_upperkeycol = upperbound( _istr_multiupdate[ll_index].keycolumns[] )
	for ll_idxkey = 1 to ll_upperkeycol 
		ls_colname = _istr_multiupdate[ll_index].keycolumns[ll_idxkey]
		ls_modify = dw_file_listing.modify(ls_colname + ".key='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next
	
	// Send SQLs to the database
	_is_updatesallowed = 'D'
	if dw_file_listing.update(true, false) = -1 then
		return c#return.Failure
	end if
next

// Second:
// Update the table of ATTACHMENTS first and then insert and update the other tables
//

for ll_index = 1 to ll_upperbound
	// Cleaning up
	ll_colcount = long (dw_file_listing.Object.DataWindow.Column.Count)
	for ll_col = 1 to ll_colcount
		ls_colname = "#" + string(ll_col)
		ls_modify = dw_file_listing.modify(ls_colname + ".update='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = dw_file_listing.modify(ls_colname + ".identity='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = dw_file_listing.modify(ls_colname + ".key='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Get the table name
	ls_tblname = _istr_multiupdate[ll_index].tablename
	
	// Set the table to update
	ls_tblname = lnv_string.of_replaceall(ls_tblname, "'", "~~'", false)
	ls_modify = dw_file_listing.modify("DataWindow.Table.UpdateTable='" + ls_tblname + "'" )
	if ls_modify <> "" then
		return c#return.Failure
	end if
	
	// Set the update properties for all columns
	ll_upperallcol = upperbound( _istr_multiupdate[ll_index].allcolumns[] )
	for ll_idxall = 1 to ll_upperallcol
		// Set the update property
		ls_colname = _istr_multiupdate[ll_index].allcolumns[ll_idxall]
		ls_modify = dw_file_listing.modify(ls_colname + ".update='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the dbname property
		ls_dbname = _istr_multiupdate[ll_index].alldbcolumns[ll_idxall]
		ls_dbname = lnv_string.of_replaceall(ls_dbname, "'", "~~'", false)
		ls_modify = dw_file_listing.modify(ls_colname + ".dbname='" + ls_dbname + "'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the identity property
		if ls_dbname = "ATTACHMENTS.FILE_ID" then
			ls_modify = dw_file_listing.modify(ls_colname + ".identity='yes'")
		else
			ls_modify = dw_file_listing.modify(ls_colname + ".identity='no'")
		end if
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Set the key properties for the key columns
	ll_upperkeycol = upperbound( _istr_multiupdate[ll_index].keycolumns[] )
	for ll_idxkey = 1 to ll_upperkeycol 
		ls_colname = _istr_multiupdate[ll_index].keycolumns[ll_idxkey]
		ls_modify = dw_file_listing.modify(ls_colname + ".key='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Send SQLs to the database
	if ls_tblname = "ATTACHMENTS" then 
		_is_updatesallowed = 'IUD'
		_setdefaultvalue()
		_resetidentity()
	else
		_is_updatesallowed = 'IU'
	end if
	if dw_file_listing.update(true, false) = -1 then
		return c#return.Failure
	end if
next

return c#return.Success
end function

public function integer of_addupdatetable (string as_tablename, string as_allcolumns, string as_keycolumns);/********************************************************************
   of_addupdatetable
   <DESC>	Add a table to be updated	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename
		as_allcolumns
		as_keycolumns
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index, ll_index2
long ll_upperbound, ll_upperbound2
string ls_allcolumns[]
string ls_keycolumns[]
string ls_alldbcolumns[]
mt_n_stringfunctions lnv_string
string ls_type, ls_dbname
long ll_tblpos

// Validate parameters
if IsNull(as_tablename) or IsNull(as_allcolumns) or IsNull(as_keycolumns) then
	return c#return.Failure
end if
if as_tablename = "" or as_allcolumns = "" or as_keycolumns = "" then
	return c#return.Failure
end if

// Check if the table has already been in the array
ll_upperbound = upperbound(_istr_multiupdate[])
for ll_index = 1 to ll_upperbound
	if _istr_multiupdate[ll_index].tablename = as_tablename then
		return -1
	end if
next

lnv_string.of_parsetoArray(as_keycolumns,",",ls_keycolumns[])
lnv_string.of_parsetoArray(as_allcolumns,",",ls_allcolumns[])

// Ignore the head and tail space characters
ll_upperbound = upperbound (ls_keycolumns[])
for ll_index = 1 to ll_upperbound
	ls_keycolumns[ll_index] = trim(ls_keycolumns[ll_index])
next
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_allcolumns[ll_index] = trim(ls_allcolumns[ll_index])
next

// Check if the key columns are valid
ll_upperbound = upperbound (ls_keycolumns[])
for ll_index = 1 to ll_upperbound
	ll_upperbound2 = upperbound (ls_allcolumns[])
	for ll_index2 = 1 to ll_upperbound2
		if ls_keycolumns[ll_index] = ls_allcolumns[ll_index2] then
			exit
		end if
	next
	if ll_index2 > ll_upperbound2 then
		return c#return.Failure
	end if
next

// Check if they all are columns
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_type = dw_file_listing.describe( ls_allcolumns[ll_index] + ".type" )
	if not (ls_type = "column") then
		return c#return.Failure
	end if
next

// Find all database column names
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_dbname = dw_file_listing.describe( ls_allcolumns[ll_index] + ".dbname" )
	if ls_dbname = "?" or ls_dbname="!" or ls_dbname = "" then
		return c#return.Failure
	end if
	ll_tblpos = pos(ls_dbname, ".")
	if ll_tblpos > 0 then
		ls_dbname = as_tablename + right(ls_dbname, len(ls_dbname) - ll_tblpos + 1)
	else
		ls_dbname = as_tablename + "." + ls_dbname
	end if
	ls_alldbcolumns[ll_index] = ls_dbname
next

// Add to the array
ll_upperbound = upperbound(_istr_multiupdate[]) + 1
_istr_multiupdate[ll_upperbound].tablename = as_tablename
_istr_multiupdate[ll_upperbound].keycolumns[] = ls_keycolumns[]
_istr_multiupdate[ll_upperbound].allcolumns[] = ls_allcolumns[]
_istr_multiupdate[ll_upperbound].alldbcolumns[] = ls_alldbcolumns[]

return c#return.Success

end function

public function long of_addupdatetable (string as_tablename, string as_keycolumns);/********************************************************************
   of_addupdatetable
   <DESC>	Add an update table	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename
		as_keycolumns : a string delimited by commas
   </ARGS>
   <USAGE>	Called after of_init()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index
long ll_columncount
string ls_dbname
string ls_colname, ls_colid, ls_allcolumns
long ll_tablepos
string ls_tablename

ll_columncount = long (dw_file_listing.Object.DataWindow.Column.Count)
for ll_index = 1 to ll_columncount
	ls_colid = "#" + string(ll_index)
	ls_dbname = dw_file_listing.describe( ls_colid + ".dbname")
	ls_colname = dw_file_listing.describe( ls_colid + ".name")
	ll_tablepos = pos(ls_dbname, ".")
	if ll_tablepos > 0 then
		ls_tablename = left(ls_dbname, ll_tablepos - 1)
	else
		ls_tablename = ""
	end if
	if ls_tablename = as_tablename then
		if  ls_allcolumns  = "" then
			ls_allcolumns = ls_colname
		else
			ls_allcolumns += "," + ls_colname
		end if
	end if
next

return of_addupdatetable(as_tablename, ls_allcolumns, as_keycolumns)


end function

private function long _setdefaultvalue ();/********************************************************************
   _setdefaultvalue
   <DESC>	Set the default values	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
DWItemStatus le_rowstatus
long ll_col, ll_colcount
string ls_dbname

ll_colcount = long(dw_file_listing.Object.DataWindow.Column.Count)

// Primary buffer
ll_rowcount = dw_file_listing.rowcount()
for ll_row = 1 to ll_rowcount
	le_rowstatus = dw_file_listing.getitemstatus(ll_row, 0, primary!)
	if le_rowstatus = DataModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = dw_file_listing.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				dw_file_listing.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				dw_file_listing.setitem(ll_row, ll_col, datetime(today(),now()))
			elseif ls_dbname = "ATTACHMENTS.MODULE_NAME" then
				dw_file_listing.setitem(ll_row, ll_col, is_modulename)
			end if
		next
		
	elseif le_rowstatus = NewModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = dw_file_listing.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.CREATED_BY" then
				dw_file_listing.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.CREATED_DATE" then
				dw_file_listing.setitem(ll_row, ll_col, datetime(today(),now()))
			elseif ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				dw_file_listing.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				dw_file_listing.setitem(ll_row, ll_col, datetime(today(),now()))
			elseif ls_dbname = "ATTACHMENTS.MODULE_NAME" then
				dw_file_listing.setitem(ll_row, ll_col, is_modulename)
			end if
		next
	end if
next

// Filter Buffer
ll_rowcount = dw_file_listing.filteredcount()
for ll_row = 1 to ll_rowcount
	le_rowstatus = dw_file_listing.getitemstatus(ll_row, 0, filter!)
	if le_rowstatus = DataModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = dw_file_listing.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] =datetime(today(),now())
			elseif ls_dbname = "ATTACHMENTS.MODULE_NAME" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = is_modulename
			end if
		next
	elseif le_rowstatus = NewModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = dw_file_listing.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.CREATED_BY" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.CREATED_DATE" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = datetime(today(),now())
			elseif ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = datetime(today(),now())
			elseif ls_dbname = "ATTACHMENTS.MODULE_NAME" then
				dw_file_listing.Object.Data.Filter.Current[ll_row, ll_col] = is_modulename
			end if
		next
	end if
next

return c#return.Success

end function

public function boolean _candeleteimage (long al_fileid, long al_row);/********************************************************************
   _candeleteimage
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> false
            <LI> true	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_fileid
		al_row
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		15/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_dbname
n_service_manager lnv_servicemgr
n_fileattach_service	lnv_attservice
constant string METHOD = "_candeleteimage()"

lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")

//CR3753 Get the file database name
if dw_file_listing.Describe("db_name.type") <> "!" then 
	ls_dbname = dw_file_listing.getitemstring(al_row, "db_name")
else
	ls_dbname = lnv_attservice.of_getfiledbname(al_fileid, _is_tablename)
end if

if lnv_attservice.of_isfiledbreadonly(ls_dbname) then
	_addmessage(this.classdefinition, METHOD, &
		"Cannot delete the selected file because the file database '" + ls_dbname + "' is read-only", &
		"")
	return false
end if

return true
end function

public function boolean _canreplaceimage (long al_fileid, long al_row);/********************************************************************
   _canreplaceimage
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> false
            <LI> true	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_fileid
		al_row
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		15/09/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_dbname
n_service_manager 	lnv_servicemgr
n_fileattach_service	lnv_attservice
constant string METHOD = "_canreplaceimage()"

lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")

//CR3753 Get the file database name
if isnull(al_fileid) then
	ls_dbname = lnv_attservice.of_getfiledbname()
else
	if dw_file_listing.Describe("db_name.type") <> "!" then 
		ls_dbname = dw_file_listing.getitemstring(al_row, "db_name")
	else
		ls_dbname = lnv_attservice.of_getfiledbname(al_fileid, _is_tablename)
	end if
end if

if lnv_attservice.of_isfiledbreadonly(ls_dbname) then
	_addmessage(this.classdefinition, METHOD, &
		"Cannot replace the selected file because the file database '" + ls_dbname + "' is read-only", &
		"")
	return false
end if

return true
end function

protected function integer _resetidentity ();/********************************************************************
   _resetidentity
   <DESC>	Make PB refetch the identity after the failure of the last update	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.NoAction: 0, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/12/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
long ll_col, ll_colcnt
string ls_identity
string ls_colname
dwitemstatus le_status
long ll_null

ll_colcnt = long (dw_file_listing.Object.DataWindow.Column.Count)

for ll_col = 1 to ll_colcnt
	ls_colname = "#" + string(ll_col)
	ls_identity = dw_file_listing.describe(ls_colname + ".identity")
	if ls_identity = "yes" then
		exit
	end if
next

if ll_col > ll_colcnt then
	return c#return.NoAction
end if

setnull(ll_null)

ll_rowcount = dw_file_listing.rowcount()
for ll_row = 1 to ll_rowcount
	le_status = dw_file_listing.getitemstatus(ll_row,0,primary!)
	if le_status = newmodified! then
		dw_file_listing.setitem(ll_row, ll_col, ll_null)
		dw_file_listing.setitemstatus(ll_row, ll_col, primary!, notmodified!)
	end if
next

return c#return.Success

end function

on u_fileattach.create
int iCurrent
call super::create
this.dw_change=create dw_change
this.pb_expandcollapse=create pb_expandcollapse
this.st_infobox=create st_infobox
this.lbx_tempfiles=create lbx_tempfiles
this.st_attachmentcounter=create st_attachmentcounter
this.pb_update=create pb_update
this.pb_new=create pb_new
this.pb_cancel=create pb_cancel
this.pb_delete=create pb_delete
this.ole_document=create ole_document
this.dw_file_listing=create dw_file_listing
this.oleobject_1=create oleobject_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_change
this.Control[iCurrent+2]=this.pb_expandcollapse
this.Control[iCurrent+3]=this.st_infobox
this.Control[iCurrent+4]=this.lbx_tempfiles
this.Control[iCurrent+5]=this.st_attachmentcounter
this.Control[iCurrent+6]=this.pb_update
this.Control[iCurrent+7]=this.pb_new
this.Control[iCurrent+8]=this.pb_cancel
this.Control[iCurrent+9]=this.pb_delete
this.Control[iCurrent+10]=this.ole_document
this.Control[iCurrent+11]=this.dw_file_listing
end on

on u_fileattach.destroy
call super::destroy
destroy(this.dw_change)
destroy(this.pb_expandcollapse)
destroy(this.st_infobox)
destroy(this.lbx_tempfiles)
destroy(this.st_attachmentcounter)
destroy(this.pb_update)
destroy(this.pb_new)
destroy(this.pb_cancel)
destroy(this.pb_delete)
destroy(this.ole_document)
destroy(this.dw_file_listing)
destroy(this.oleobject_1)
end on

event constructor;userobject luo_parent
powerobject  lpo_parent
window lw_parent
long ll_backcolor
tab ltab_parent
boolean lb_ignore = false

st_infobox.text = ""
_ib_dragdrop_order=true	

if ib_allow_dragdrop then 
	POST DragAcceptFiles( Handle( This ), TRUE ) 
	if sl_handle = 0  then
		sl_handle = Handle(Parent)
		POST RegisterDropTarget( sl_handle )
	end if
end if

/* setup the bckground colours of labels etc. */
lpo_parent = this.getparent( )

choose case lpo_parent.typeof( )

	case Window!
		lw_parent = lpo_parent
		ll_backcolor = lw_parent.backcolor
		
	case Tab!	
		ltab_parent = lpo_parent
		ll_backcolor = ltab_parent.backcolor
	
	case UserObject!
		luo_parent = lpo_parent
		ll_backcolor = luo_parent.backcolor

	case else
		// do nothing
		lb_ignore = true	

end choose
		
if not( lb_ignore) then
	this.backcolor = ll_backcolor
	st_infobox.backcolor = ll_backcolor
	st_attachmentcounter.backcolor = ll_backcolor
end if
end event

event destructor;call super::destructor;of_purgetempfiles()
end event

type dw_change from mt_u_datawindow within u_fileattach
event ue_mousemove pbm_dwnmousemove
event ue_keypress pbm_dwnkey
boolean visible = false
integer x = 1070
integer y = 8
integer width = 727
integer height = 404
integer taborder = 40
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = stylebox!
end type

event ue_keypress;/*
allow user selection on enter keypress
to do needs to work with voyages too

*/
if key = keyEnter! then 
	long ll_categoryid
	ll_categoryid = this.getitemnumber(getrow(),"doc_type")
	_changecategory(_il_lastclickedrow, ll_categoryid)
	this.visible=false
elseif key = keyTab! then 
	this.visible=false
end if
end event

event clicked;call super::clicked;/*
on being selected change category
*/
long ll_categoryid
string ls_voyage
this.selectrow(row,true)

if row<>0 then
	ll_categoryid = this.getitemnumber(row,"type_id")
	if ll_categoryid = 0 then
		ls_voyage = this.getitemstring(row,"description")
		_changeidstr(_il_lastclickedrow, ls_voyage)
	else
		_changecategory(_il_lastclickedrow, ll_categoryid)
	end if
	this.visible=false
end if	
end event

event resize;call super::resize;if dw_file_listing.height<100 or dw_file_listing.width<100 then
	return
end if

if height + 100 > dw_file_listing.height  then
	height = (dw_file_listing.height) - 100
elseif height<200 then 
	height = 200
end if
if width + 100 > dw_file_listing.width then
	width = (dw_file_listing.width) - 100
elseif width<200 then 
	width = 200
end if	
	
end event

type pb_expandcollapse from picturebutton within u_fileattach
boolean visible = false
integer y = 208
integer width = 110
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "TreeView!"
string disabledname = "images\att_tree.bmp"
alignment htextalign = left!
string powertiptext = "Expand/Collapse All"
end type

event clicked;_ib_expanded = not(_ib_expanded)
if _ib_expanded then
	dw_file_listing.expandall( )
else
	dw_file_listing.collapseall( )
end if
end event

type st_infobox from statictext within u_fileattach
integer width = 974
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 22628899
long backcolor = 32304364
string text = "<info>"
alignment alignment = right!
boolean border = true
long bordercolor = 32304364
boolean focusrectangle = false
end type

type lbx_tempfiles from listbox within u_fileattach
boolean visible = false
integer x = 329
integer width = 649
integer height = 176
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_attachmentcounter from mt_u_statictext within u_fileattach
event ue_rbuttondblclk pbm_rbuttondblclk
integer y = 220
integer width = 425
long textcolor = 22628899
long backcolor = 32304364
end type

event ue_rbuttondblclk;// secret
if keydown(keyAlt!) and keydown(keyShift!) and keydown(keyZ!) then
	_ii_secret_counter++
	if _ii_secret_counter = 10 and ib_convert_process = false then
		w_fileattach_converter  w_temp
		open(w_temp)
		w_temp.sle_1.text = parent.is_dataobjectname + "_converter"
		_ii_secret_counter = 0
	end if
end if

end event

type pb_update from picturebutton within u_fileattach
boolean visible = false
integer x = 718
integer y = 208
integer width = 110
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Save!"
string disabledname = "images\att_save.bmp"
alignment htextalign = left!
string powertiptext = "Update Attachment(s)"
end type

event clicked;_updateRows()
end event

type pb_new from picturebutton within u_fileattach
boolean visible = false
integer x = 608
integer y = 208
integer width = 110
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Insert!"
string disabledname = "images\att_insert.bmp"
alignment htextalign = left!
string powertiptext = "New Attachment"
end type

event clicked;of_addnewimage( )
end event

type pb_cancel from picturebutton within u_fileattach
boolean visible = false
integer x = 937
integer y = 208
integer width = 110
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Undo!"
string disabledname = "images\att_refresh.bmp"
alignment htextalign = left!
string powertiptext = "Cancel Actions"
end type

event clicked;of_cancelchanges()

end event

type pb_delete from picturebutton within u_fileattach
boolean visible = false
integer x = 827
integer y = 208
integer width = 110
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom094!"
string disabledname = "images\att_delete.bmp"
alignment htextalign = left!
string powertiptext = "Delete Selected Attachment"
end type

event clicked;of_deleteimage( )
end event

type ole_document from olecontrol within u_fileattach
integer x = 9
integer y = 316
integer width = 1033
integer height = 48
integer taborder = 30
boolean bringtotop = true
boolean border = false
long backcolor = 16777215
boolean focusrectangle = false
string binarykey = "u_fileattach.udo"
omdisplaytype displaytype = displayascontent!
omcontentsallowed contentsallowed = containsany!
sizemode sizemode = clip!
end type

event doubleclicked;if this.classlongname = "Package" then
	this.activate(inplace!)
else
	this.activate(offsite!)
end if
end event

type dw_file_listing from u_datagrid within u_fileattach
event ue_mousemove pbm_dwnmousemove
event ue_rbuttondown pbm_dwnrbuttondown
integer width = 1042
integer height = 212
integer taborder = 10
string dragicon = "images\DRAG.ICO"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_enablesortindex = true
end type

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
   <DESC>   
		Important event to register the objects datawindow so it can accept 
		dragged messages from Outlook
	</DESC>
   <RETURN> 
		Long
	</RETURN>
   <ACCESS> 
		Public
	</ACCESS>
   <ARGS>   
		xpos: x coordinate of the mouse pointer
      ypos: y coordinate
		row:  current row in datawindow
		dwo:	dw_file_listing datawindow object
	</ARGS>
   <USAGE>  
		Requires a shared variable to test all instances of this
		object that may be in use.  If the current handle for the parent
		object (u_fileatatch) is different to the one contained in the share
		this event replaces the value and registers the object so it can
		accept messages from outlook.
	</USAGE>
********************************************************************/

long ll_category, ll_row
string ls_obj, ls_name

if ib_allow_dragdrop then
	if Handle(Parent) <> sl_handle then
		sl_handle = Handle(Parent)
		POST RegisterDropTarget( sl_handle )
	end if
end if
/* 
user has possibility to change category with a popup dw 
when mousepointer goes outside range, hide the datawindow.
*/
if dw_change.visible then
	if xpos < dw_change.x - this.x then dw_change.visible = false
	if ypos < dw_change.y - this.y then dw_change.visible = false
end if
end event

event ue_rbuttondown;/*
if icon is openfile and we are in treeview allow user to change category 
by providing a dropdown dw to select.
*/
if _ii_access_level <> EXTERNAL_APM   then	
	if right(dwo.name,8)= "openfile" and _istreeview() then
		_il_lastclickedrow = row
		dw_change.x = Parent.PointerX() 
		if (PointerY() + dw_change.height) > Parent.height then
			dw_change.y = Parent.height - dw_change.height
		else
			dw_change.y = Parent.PointerY() 
		end if
		dw_change.selectrow(0,false)
		dw_change.visible = true
		dw_change.setfocus( )
	end if
end if

end event

event rowfocuschanged;call super::rowfocuschanged;long ll_fileId
pointer oldpointer
n_olefilecontent		lnv_olefilecontent
string ls_filename

if currentrow > 0 then
	this.scrolltorow(currentrow)
	this.selectRow(0,false)
	this.selectRow(currentrow,true)
	
	if ib_retrievedetail = false then return

	ll_fileId = dw_file_listing.getitemnumber(currentrow, "file_id")
	
	if not isnull(ll_fileId) then
		if ib_show_ole then
			_openimage( currentrow)
		end if
		
		window  lw_parent
		if parent.getparent( ).typeof() = Window! then
			lw_parent = parent.getparent( )
			lw_parent.dynamic event ue_attachmentChanged(currentrow)
		end if	
	end if
end if
end event

event destructor;/* tidy up */

n_attachment lnvo_dummy[]
_inv_att = lnvo_dummy

if ib_allow_dragdrop then
	RevokeDragDrop( Handle(Parent) )
end if
end event

event editchanged;call super::editchanged;if (_istreeview( ) or ib_autosave) and dwo.name = "description" then
	if dw_file_listing.Describe("file_updated_date.type")<>"!" then &
		dw_file_listing.setitem(row,"file_updated_date", now())
	if dw_file_listing.Describe("userid.type")<>"!" then &	
		dw_file_listing.setitem(row,"userid", sqlca.userid)
end if
parent.event ue_childmodified(row,dwo, data)
end event

event itemchanged;call super::itemchanged;/* autosave description column when in treeview */
if dwo.name= "description" then
	if trim(data) = "" then
		return 2
	end if
end if
if _istreeview() or ib_autosave then
	if dwo.name= "description" then
		
			if _updatetables() = 1 then
				commit using sqlca;
				this.post resetupdate()
			end if
			
	end if
else
	
	parent.event ue_childmodified(row,dwo, data)
end if

end event

event losefocus;call super::losefocus;accepttext( )
end event

event doubleclicked;call super::doubleclicked;long ll_row
string ls_band, ls_obj, ls_name

/* expand/collapse treenode when user double clicks the section header */
if dwo.name = "categoryname" then
	ls_band = dw_file_listing.GetBandAtPointer()
	if Left( ls_band, Pos( ls_band, "~t") - 1 ) <>"header" then
		ls_obj = dw_file_listing.GetObjectAtPointer()
		ls_name = Left( ls_obj, Pos( ls_obj, "~t") - 1 ) 
		ll_row = Long( Right( ls_obj, Len( ls_obj ) - Pos( ls_obj, "~t") ) ) 	
	end if
	if this.isexpanded( ll_row, _il_grouplevel) then
		this.collapse( ll_row, _il_grouplevel )
	else
		this.expand( ll_row, _il_grouplevel )
	end if
end if
end event

event ue_clicked;call super::ue_clicked;/********************************************************************
  clicked() event
   <DESC>   called when the user mouse clicks on the datawindow surface </DESC>
   <RETURN>n/a</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   Powerbuilder standard event</ARGS>
   <USAGE>  Firstly checks if there are any rows or not.
	Next checks if the headers have been clicked to then sort content
	Otherwise checks if user has clicked an icon to open/amend attachment
	Exceptions for treeview include saving categories that are open before sorting so they can
	be reapplied again.</USAGE>
********************************************************************/
string	ls_sort
string	ls_dwoname
integer 	li_filetype = 1
long ll_unsyncrow, ll_expanded[]

constant string METHOD_NAME = "clicked"
//messagebox("u_fileattach.dw_file_listing","clicked()")
if row < 0 then return
/* allow sort if Tag in dataobject set */
if row = 0 and not isnull(_il_arg) then
	if (String(dwo.type) = "text") then
		if (String(dwo.tag)>"" and String(dwo.tag) <> '?' and String(dwo.tag) <> '!') then
			this.setredraw( false )
			_saveexpanded(ll_expanded)
			ls_sort = dwo.Tag
			this.SetSort(ls_sort)
			this.Sort()
			if right(ls_sort,1) = "A" then 
				ls_sort = Replace(ls_sort, len(ls_sort),1, "D")
			else
				ls_sort = Replace(ls_sort, len(ls_sort),1, "A")
			end if
			this.groupCalc()
			dwo.Tag = ls_sort	
			/* expand rows again */
			_restoreexpanded( ll_expanded,0,0)
			this.setredraw( true )			
		End If
	End if
	return 
else
	if row>0 then _il_lastfileid = this.getitemnumber( row, "file_id")
End If

/* test if dwo object is valid */
if xpos=0 and ypos=0 then
	of_setfilecounter()
	return
end if

if right(dwo.name,8) = "openfile" then
	_ib_openimage = true
	_openimage(row)
	_ib_openimage = false
elseif right(dwo.name,10) = "updatefile" then
	_replaceimage(row)	
end if

if _istreeview( ) then dw_file_listing.setredraw( false )

if row>0 then
	this.selectRow(0,false)
	this.selectRow(row,true)
	if row <> this.getrow() then setrow(row)
	_il_lastclickedrow = row
end if

/* on occasion the row does not follow the selected row. */
if _istreeview( ) then
	ll_unsyncrow = getrow()
	if ll_unsyncrow<>row then
		dw_file_listing.collapse(ll_unsyncrow,_il_grouplevel) 
		dw_file_listing.collapse(row,_il_grouplevel)
		setrow(row)
		dw_file_listing.expand(row,_il_grouplevel)
		dw_file_listing.expand(ll_unsyncrow,_il_grouplevel) 
	end if	
	dw_file_listing.setredraw( true )
end if

parent.event ue_childclicked(0,0,row,dwo)

end event

event sqlpreview;call super::sqlpreview;
// Only perform the requested SQL statements
if  (sqltype = PreviewSelect!) or &
	((sqltype = PreviewInsert!) and pos(_is_updatesallowed,"I") > 0) or &
	((sqltype = PreviewUpdate!) and pos(_is_updatesallowed,"U") > 0) or &
	((sqltype = PreviewDelete!) and pos(_is_updatesallowed,"D") > 0) then
	// Do nothing
	// Allow continuing to execute the SQL statements
else
	return 2
end if

end event

event dragdrop;call super::dragdrop;parent.event ue_childdragdrop(source, row, dwo)
end event

type oleobject_1 from oleobject within u_fileattach descriptor "pb_nvo" = "true" 
end type

on oleobject_1.create
call super::create
TriggerEvent( this, "constructor" )
end on

on oleobject_1.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


Start of PowerBuilder Binary Data Section : Do NOT Edit
00u_fileattach.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10u_fileattach.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
