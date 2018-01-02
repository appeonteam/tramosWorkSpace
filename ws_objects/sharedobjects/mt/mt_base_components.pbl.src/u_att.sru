$PBExportHeader$u_att.sru
forward
global type u_att from mt_u_visualobject
end type
type st_statustext from mt_u_statictext within u_att
end type
type pb_cancel from picturebutton within u_att
end type
type pb_delete from picturebutton within u_att
end type
type pb_update from picturebutton within u_att
end type
type pb_new from picturebutton within u_att
end type
type dw_att from mt_u_dw_att within u_att
end type
end forward

shared variables
long sl_handle
end variables

global type u_att from mt_u_visualobject
integer width = 2002
integer height = 592
event type integer ue_preupdateattach ( u_datagrid adw_att )
event ue_drop_files pbm_dropfiles
event ue_drop_mails pbm_custom01
event ue_childclicked ( )
event ue_postupdateattach ( u_datagrid adw_att,  integer ai_returncode,  string as_msg,  string as_msg_dev )
st_statustext st_statustext
pb_cancel pb_cancel
pb_delete pb_delete
pb_update pb_update
pb_new pb_new
dw_att dw_att
end type
global u_att u_att

type prototypes
function ulong RevokeDragDrop( ulong aul_Wnd ) library "ole32.dll"
function ulong RegisterDropTarget( ulong aul_Wnd ) library "dddll.dll"
function ulong RegisterDropTargetEx2( ulong aul_Source, uint ui_Msg, ulong aul_Target, string sDestination ) library "dddll.dll" alias for "RegisterDropTargetEx2;Ansi"
/* drag+drop of files from file explorer, desktop etc */
function int DragQueryFile( ulong aul_Drop, int ai_File, ref string as_FileName, int ai_CB ) library 'shell32' alias for "DragQueryFileW"
SUBROUTINE DragAcceptFiles( ulong aul_Wnd, boolean ab_Accept ) library 'shell32'
end prototypes

type variables
string 							is_att_dataobject 				= "give me a proper value" /* dataobject used on main attachment listing */

boolean 							ib_att_show_update 				= true /* use the update picture button or not. */
boolean 							ib_att_show_cancel 				= true /* use the cancel picture button or not. */
boolean 							ib_att_show_delete 				= true /* use the delete picture button or not. */
boolean 							ib_att_show_new 					= true /* use the new picture button or not. */

boolean 							ib_showfilteredcounter 			= false
boolean							ib_autosave							= true
boolean							ib_dropout							= true
string 							is_counterlabel 					= "files:"
string 							is_defaultsortorder				= ""
long 								il_max_size_bytes					= 20972000	// 20.9 mb
n_cached_att					inv_cache_mgmt
string 							is_disallowedextensionslist[] = {'exe','cmd','bat'} 						
str_requested_att				istr_pending_atts[]		/* if ib_autosave is not enabled this maintains reference until updated&committed */

constant int ii_METHOD_WRITE = 1
constant int ii_METHOD_READ = 2
constant int ii_METHOD_DELETE = 3
end variables

forward prototypes
public subroutine documentation ()
protected function integer _write_to_status_text (string as_text)
protected function integer _arrange_controls ()
public function integer of_add_single_file_dialogue ()
protected function boolean _valid_file_size (ref str_requested_att astr_att)
public function integer of_init (any aa_args[], string as_argrefs[], boolean ab_autoretrieve)
public function integer of_db_commit_handler (str_requested_att astr_atts[])
public function integer of_get_blob (string as_file_name, ref blob abl_file_content, ref long al_file_size)
public function integer of_finish_pending_atts (boolean ab_commit)
public function integer of_reset_data (boolean ab_with_retreive)
public function integer of_delete_att ()
protected function long _init_struct_file (ref str_requested_att astr_att, string as_file_name, integer ai_methodref)
protected function long _init_struct_mail (ref str_requested_att astr_att, long al_param, integer ai_methodref)
protected function integer of_dropout ()
end prototypes

event type integer ue_preupdateattach(u_datagrid adw_att);/* u_att ancestor ue_preupdateattach */
n_service_manager lnv_svcmgr
n_dw_validation_service lnv_rules

lnv_svcmgr.of_loadservice( lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerrulestring("description", true, "description")
if lnv_rules.of_validate(dw_att, true) = c#return.Failure then return c#return.Failure

return c#return.Success

end event

event ue_drop_files;/********************************************************************
event u_att ancestor > ue_drop_files

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

string 					ls_msgbox, ls_file_name
integer					li_charpos, li_response = 1, li_total_files, li_file_index, li_arg_index
long 						ll_new_cached_index, ll_insertedrow, ll_att_index, ll_row, ll_file_id, ll_file_size
str_requested_att		lstr_att, lstr_dummy
mt_n_filefunctions 	lnv_filefunc
mt_n_stringfunctions	lnv_stringfunctions

	li_total_files = DragQueryFile( handle, -1, ls_file_name, 255 )
	_write_to_status_text("Attaching " + string(li_total_files) + " file(s)...")
	if li_total_files > 10 then
		li_response = MessageBox("Multiple Files", "You are dragging " + string(li_total_files) + " files into Tramos.  Are you sure you want to continue with this action?", Exclamation!, OKCancel!, 2)
	end if	
	/* continue */
	if li_response = 1 then
		for li_file_index = 1 to li_total_files
			ls_file_name = Space( 255 )
			DragQueryFile( handle, li_file_index - 1, ls_file_name, 255 )
			/* validate the extension list */
			if lnv_filefunc.of_isvalidextension( ls_file_name, is_disallowedextensionslist, "Error attaching file: the file " + ls_file_name + " is not allowed to be attached inside Tramos.") = false then
				continue
			end if
			/*  we use file location directly when loading into db. NB: no need to create cached copy if user purpose is only to share. */
			_init_struct_file(lstr_att,ls_file_name, ii_METHOD_WRITE)
			/* now check the size of the file meets the allowed */		
			if _valid_file_size(lstr_att)= false then
				continue
			end if
			dw_att.of_setlastclickedrow(dw_att.of_insertrow(lstr_att))
			istr_pending_atts[upperbound(istr_pending_atts)+1] = lstr_att
			lstr_att = lstr_dummy
		next
		/* all things well we can attempt to set as a candidate to be sent & saved in database. */
		if ib_autosave then
			of_db_commit_handler(istr_pending_atts[])
		else
			dw_att.setrow(dw_att.of_getlastclickedrow())			
			dw_att.scrolltorow(dw_att.of_getlastclickedrow())
			dw_att.selectrow(0,false)
			dw_att.selectrow(dw_att.of_getlastclickedrow(),true)			
		end if
	end if
	_write_to_status_text("COUNTER")	

return 1
end event

event ue_drop_mails;/********************************************************************
event ue_drop_mails( /*unsignedlong wparam*/, /*long lparam */)
	
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
	Tested with Outlook 2003, 2007 & 2013
</USAGE>
********************************************************************/

/* u_att ancestor ue_drop_mails */

string					ls_message, ls_header, ls_filename, ls_temp_file_name, ls_exttype
string					ls_Pre, ls_directory, ls_temp_name_segment, ls_temp_extension_segment
boolean					lb_email_body_included = false
integer					li_charpos
long						ll_filehandle, ll_new_att_index, ll_row_id
char 						lc_dummy[]

pointer 					lpnt_old
str_requested_att 	lstr_atts[] 
mt_n_filefunctions	lnv_filefunc


if wparam = 111 then
	ll_new_att_index = upperbound(istr_pending_atts[]) + 1
	
	_write_to_status_text("Attaching mail(s)...")	
	_init_struct_mail(istr_pending_atts[ll_new_att_index], lparam, ii_METHOD_WRITE)
	if lower(right(istr_pending_atts[ll_new_att_index].s_file_name,9)) <> "_body.txt" then
		if left(istr_pending_atts[ll_new_att_index].s_file_name,1)="." then 
			ls_temp_file_name="nosubject" + istr_pending_atts[ll_new_att_index].s_file_name
		else
			ls_temp_name_segment = mid(istr_pending_atts[ll_new_att_index].s_file_name,1,len(istr_pending_atts[ll_new_att_index].s_file_name) - 4)	
			ls_temp_extension_segment = right(istr_pending_atts[ll_new_att_index].s_file_name,4)					
			ls_temp_file_name = trim(ls_temp_name_segment) + ls_temp_extension_segment
		end if
		if lnv_filefunc.of_isvalidextension( istr_pending_atts[ll_new_att_index].s_file_name, is_disallowedextensionslist, "Error attaching file: the file " + istr_pending_atts[ll_new_att_index].s_file_name + " is not allowed to be attached inside Tramos.") = false then
			return
		end if
		/* now check the size of the file meets the allowed */		
		if _valid_file_size(istr_pending_atts[ll_new_att_index]) = false then
			return
		end if
		dw_att.of_setlastclickedrow(dw_att.of_insertrow(istr_pending_atts[ll_new_att_index]))
		ll_row_id = dw_att.getrowidfromrow(dw_att.of_getlastclickedrow())
		if ib_autosave then
			of_db_commit_handler(istr_pending_atts[])
		else
			dw_att.setrow(dw_att.getrowfromrowid(ll_row_id))			
			dw_att.scrolltorow(dw_att.getrowfromrowid(ll_row_id))
			dw_att.selectrow(0,false)
			dw_att.selectrow(dw_att.getrowfromrowid(ll_row_id),true)		
		end if	
	end if
	_write_to_status_text("COUNTER")		
end if
end event

event ue_childclicked();/* u_att ancestor ue_childclicked */
end event

event ue_postupdateattach(u_datagrid adw_att, integer ai_returncode, string as_msg, string as_msg_dev);if ai_returncode <> c#return.SUCCESS then
	if len(as_msg) > 0 and len(as_msg_dev) > 0 then
		_addmessage( this.classdefinition, "ue_postupdateattach", as_msg, as_msg_dev)
	end if
else
	
	
	
	

end if
return
end event

public subroutine documentation ();/********************************************************************
   u_att:
	
	<OBJECT>

	</OBJECT>
   <DESC>
		Visual object placed on window/tab/visual container surface.  	
	</DESC>
  	<USAGE>
	  Directly: 
		mt_u_dw_att
		n_cached_att
	</USAGE>
  	<ALSO>

any la_args[10]

la_args[1] = "AGLOPS"
la_args[2] = "PRE_TRAMOS_FILES"
la_args[3] = "&LL"

uo_attachments.of_init( la_args, true)
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	10/06/15 	?      	AGL027			First Version
	01/01/13
	



TODO List
=========
- control the physical file data
- setup cached processes
- manage selectedrow!
- allow multiple rows to be selected - complexities can be: selecting single row again.



Questions
=========
- the code to insert image data needs to be agreed where and when 

Nice to have items
==================

- DragOut functionality (use .net DLL)
- Icons to symbolize type of attachment (MS Office/Text/PDF) - use of Office 2013 icons
- Predefined sorting

Helpful links
=============

http://www.tutorialsto.com/software/power-builder/operate-in-powerbuilder-skills-blob-data.html


********************************************************************/
end subroutine

protected function integer _write_to_status_text (string as_text);/* function containing the setredraw logic & management of alignment of status text */

long ll_filtered_rows

st_statustext.setredraw( false )
if as_text = "COUNTER" then
	st_statustext.alignment=LEFT!
	st_statustext.text = is_counterlabel
	st_statustext.text += string(dw_att.rowcount())
	if ib_showfilteredcounter then
		ll_filtered_rows = dw_att.filteredcount( )
		if ll_filtered_rows > 0 then
			st_statustext.text += "/" + string(ll_filtered_rows)
		end if
	end if
else
	st_statustext.alignment=CENTER!
	st_statustext.text=as_text
end if
st_statustext.setredraw( true )
return c#return.Success

end function

protected function integer _arrange_controls ();/********************************************************************
_arrange_controls( ) 

<DESC>
	as its title, moves the controls according to properties on implemenation
	also looks after the background colours to match that of the container object
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
</RETURN>
<ACCESS>
	Protected
</ACCESS>
<ARGS>
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

int li_statustext_top_padding = 5
userobject luo_parent
powerobject  lpo_parent
window lw_parent
long ll_backcolor, ll_spacer, ll_multiplier
tab ltab_parent
boolean lb_ignore = false

n_service_manager 		lnv_servicemgr
n_dw_style_service   	lnv_style

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_att, false)

/* resize datawindow attachment list container first and then other controls adjust their positions too */
dw_att.width = this.width


if ib_att_show_update or ib_att_show_cancel or ib_att_show_delete or	ib_att_show_new then
	dw_att.height = this.height - pb_new.height
	/* order of buttons is pb_new / pb_update / pb_delete / pb_cancel */
	ll_spacer = pb_cancel.width
	ll_multiplier = 1
	if ib_att_show_cancel then
		pb_cancel.x = dw_att.width - (ll_spacer*ll_multiplier)
		ll_multiplier ++
		pb_cancel.visible = true
	end if	
	if ib_att_show_delete then
		pb_delete.x = dw_att.width - (ll_spacer*ll_multiplier)
		ll_multiplier ++
		pb_delete.visible = true
	end if	
	if ib_att_show_update then
		pb_update.x = dw_att.width - (ll_spacer*ll_multiplier)
		ll_multiplier ++
		pb_update.visible = true
	end if	
	if ib_att_show_new then
		pb_new.x = dw_att.width - (ll_spacer*ll_multiplier)
		ll_multiplier ++
		pb_new.visible = true
	end if	
	pb_cancel.y = dw_att.height
	pb_delete.y = dw_att.height
	pb_update.y = dw_att.height
	pb_new.y = dw_att.height
	st_statustext.width = pb_new.x
else
	dw_att.height = this.height - st_statustext.height
	/* order of buttons is pb_new / pb_update / pb_delete / pb_cancel */
	pb_cancel.visible = false
	pb_delete.visible = false
	pb_update.visible = false
	pb_new.visible = false
	st_statustext.width = dw_att.width
end if	
st_statustext.y = dw_att.height + li_statustext_top_padding
/* setup the background colours of labels etc. */
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
	st_statustext.backcolor = ll_backcolor
end if

/* one time set default sort ordering of attachment list */
if is_defaultsortorder <> "" then
	dw_att.setsort(is_defaultsortorder)
	dw_att.sort()
	dw_att.groupcalc()
end if	

return c#return.Success
end function

public function integer of_add_single_file_dialogue ();/* similar to the ue_dropmails, we must handle one at a time */

integer li_rtn
long ll_new_att_index
string ls_file_path, ls_file_name
str_requested_att lstr_atts[]
mt_n_filefunctions lnv_filefunc

li_rtn = GetFileOpenName("Select File to Attach", ls_file_path, ls_file_name)
if li_rtn < 1 then return c#return.failure
_write_to_status_text("Attaching file...")
if lnv_filefunc.of_isvalidextension( ls_file_name, is_disallowedextensionslist, "Error attaching file: the file " + ls_file_name + " is not allowed to be attached inside Tramos.") = false then
	return c#return.NoAction
end if

ll_new_att_index = upperbound(istr_pending_atts[]) + 1

/*  we use file location directly when loading into db. NB: no need to create cached copy if user purpose is only to share. */
_init_struct_file(istr_pending_atts[ll_new_att_index],ls_file_path, ii_METHOD_WRITE)
/* now check the size of the file meets the allowed */		
if _valid_file_size(istr_pending_atts[ll_new_att_index])= false then
	return c#return.NoAction
end if
dw_att.of_insertrow(istr_pending_atts[ll_new_att_index])
/* all things well we can attempt to set as a candidate to be sent & saved in database. */
if ib_autosave then
	of_db_commit_handler(istr_pending_atts[])
end if
_write_to_status_text("COUNTER")	
	
return c#return.Success
end function

protected function boolean _valid_file_size (ref str_requested_att astr_att);/********************************************************************
  _validatefilesize( /*string as_docname*/, /*long al_filesize */)
  
<DESC>
	checks the attachment to see if the size is within the limit set
</DESC>
<RETURN> 
	Boolean:
		<LI> True
		<LI> False
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>
	validates size of file against max size allowed.  whichever, it returns file
	size inside structure passed.
</ARGS>
<USAGE>
	simple usage
</USAGE>
********************************************************************/

decimal{2}	ld_file_mb, ld_max_mb

	astr_att.l_file_size = filelength64(astr_att.s_file_path + astr_att.s_file_name)
	
	/* validate the size of the attachment */
	if astr_att.l_file_size > il_max_size_bytes then
		ld_max_mb = il_max_size_bytes / 1048576
		ld_file_mb	= astr_att.l_file_size / 1048576
		populateerror(555,"dummy")	
		_addmessage( this.classdefinition, error.object + "::" + error.objectevent, "Error attaching selected file: the file " + astr_att.s_file_name + &
		" is too large. Tramos has a maximum of " + string(ld_max_mb) + "mb for each file stored." ,&
		"This file's size is " + string(ld_file_mb) + "mb which is " + string(ld_file_mb - ld_max_mb) + "mb too large." )
		return false
	elseif astr_att.l_file_size < 0 then
		populateerror(555,"dummy")	
		_addmessage( this.classdefinition, error.object + "::" + error.objectevent, "Error loading selected file: please check if the file is empty.", "n/a")
		return false
	end if

return true
end function

public function integer of_init (any aa_args[], string as_argrefs[], boolean ab_autoretrieve);/********************************************************************
of_init( /*any aa_args[]*/, /*string as_argrefs[]*/, /*boolean ab_autoretrieve */)

<DESC>
	Refactored simplified function from original with no overrides
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
		<LI> -1, c#return.Failure
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	aa_args[] - expected 18 elements of 'any' type
	as_argrefs[] - expected 18 elements of 'string' type
	ab_autoretrieve - retrieves the data here if true
</ARGS>
<USAGE>
	Expected call in every implementation
</USAGE>
********************************************************************/

/* ancestor u_att; of_init() */

long li_index

of_reset_data(false)

/* validate array argument using mt_u_dw_att */
if dw_att.of_typematch(aa_args) = false then
	populateerror(555,"dummy")	
	_addmessage( this.classdefinition, error.object + "::" + error.objectevent, "Error! Cannot retrieve attachment data", "Array argument received by function is not of expected size/type")
	return c#return.Failure
end if	

dw_att.of_setargrefs(as_argrefs)

if ab_autoretrieve then
	/* this should call method inside datawindow container ancestor 'mt_u_dw_att'*/
	dw_att.of_retrieve(aa_args)
	_write_to_status_text("COUNTER")
end if

return c#return.Success
end function

public function integer of_db_commit_handler (str_requested_att astr_atts[]);/********************************************************************
of_db_commit_handler( /*str_requested_att astr_atts[] */) 

<DESC>
	transaction management for attachments; handles the commits or the rollbacks 
	required
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
		<LI> -1, c#return.Failure
		<LI> 0, c#return.NoAction
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	astr_atts[] array of pending attachment info (most often just 1 element, but user can 
	drag more than 1 email at a time into Tramos) 
</ARGS>
<USAGE>
	right now only accepts updates from events ue_dropfiles, ue_dropmails & the single dialogue file addition
	expected to handle more scenarios as this is built up.
</USAGE>
********************************************************************/

string 					ls_file_name, ls_errtitle, ls_errmsg
long 						ll_att_index, ll_row, ll_file_id, ll_file_size
blob 						lbl_file_content
boolean 					lb_failedupdate = false
n_service_manager 	lnv_servicemgr
n_att_service			lnv_att_service
mt_n_transaction     lnv_att_trans	

if upperbound(istr_pending_atts[]) = 0 then return c#return.NoAction

/* give container object opportunity to also control logic */
if this.event ue_preupdateattach(dw_att) = c#return.Failure then
	of_reset_data(true)
	this.event ue_postupdateattach(dw_att, c#return.failure, "", "")
	return c#return.Failure
end if

/* all saved or nothing policy */
if dw_att.of_updatetables() = c#return.Success then

	populateerror(555,"dummy")	
	lnv_servicemgr.of_loadservice( lnv_att_service, "n_att_service")
	
	lnv_att_trans = lnv_att_service.of_connectfiledb()
	
	for ll_att_index = 1 to upperbound(istr_pending_atts)
		
		ll_row = dw_att.getrowfromrowid(istr_pending_atts[ll_att_index].l_row_id)
		
		if istr_pending_atts[ll_att_index].i_methodref = ii_METHOD_WRITE then
			ls_file_name = istr_pending_atts[ll_att_index].s_file_path + istr_pending_atts[ll_att_index].s_file_name
			ll_file_id = dw_att.getitemnumber( ll_row, "file_id" )
			
			of_get_blob(ls_file_name, lbl_file_content, ll_file_size)
			
			if lnv_att_service.of_writeattach( ll_file_id, lbl_file_content, ll_file_size, lnv_att_trans)   = c#return.Failure then
				_addmessage(this.classdefinition , error.object + "::" + error.objectevent, "There is no file attached.", "n/a")
				lb_failedupdate = true
			end if
			
		elseif istr_pending_atts[ll_att_index].i_methodref = ii_METHOD_DELETE then 		
			if not isnull(istr_pending_atts[ll_att_index].l_file_id) then
				
				if lnv_att_service.of_deleteattach(istr_pending_atts[ll_att_index].l_file_id, lnv_att_trans) = c#return.Failure then
					ls_errtitle = "Error deleting the attached file. All attachments included will need to be applied again!"
					ls_errmsg = "complete transaction rolled back!"
					lb_failedupdate = true
					exit
				end if
				
			end if
		end if	

	next	

	if not lb_failedupdate then
		commit using sqlca;	
		lnv_att_trans.of_commit()
		lnv_att_trans.of_disconnect()
		this.event ue_postupdateattach(dw_att, c#return.Success, ls_errtitle, ls_errmsg)
		of_reset_data(true)	
		return c#return.Success
	else
		rollback using sqlca;
		lnv_att_trans.of_rollback()
		lnv_att_trans.of_disconnect()
		ls_errtitle = "Cannot connect to the current file database."
		ls_errmsg = "complete transaction rolled back!"
		this.event ue_postupdateattach(dw_att, c#return.Failure, ls_errtitle, ls_errmsg)
		of_reset_data(true)		
		return c#return.Failure
	end if
else
	rollback using sqlca;
	ls_errtitle = "Error updating data. All attachments included in requested change will need to be added again!"
	ls_errmsg = "datawindow dw_att update failed. Complete rollback on both transactions made"
	this.event ue_postupdateattach(dw_att, c#return.Failure, ls_errtitle, ls_errmsg)
	of_reset_data(true)	
	return c#return.Failure
end if
		
return c#return.Success		
end function

public function integer of_get_blob (string as_file_name, ref blob abl_file_content, ref long al_file_size);/* simple method to obtain blob & file size of reqested file.  as_file_name includes full path detail as well as name of file */

long ll_file_handle, ll_file_size

ll_file_handle = fileopen(as_file_name, streammode!,Read!, Shared!)
al_file_size = filereadex(ll_file_handle,abl_file_content)
fileclose(ll_file_handle)

return c#return.Success
end function

public function integer of_finish_pending_atts (boolean ab_commit);if ab_commit then
	return of_db_commit_handler(istr_pending_atts[])
else
	of_reset_data(true)
end if
return c#return.Success
end function

public function integer of_reset_data (boolean ab_with_retreive);str_requested_att			lstr_atts_dummy[]
long ll_lastclicked, ll_row_id,ll_row

ll_lastclicked = dw_att.of_getlastclickedrow( )
ll_row_id = dw_att.getrowidfromrow(ll_lastclicked)

dw_att.accepttext()
istr_pending_atts[] = lstr_atts_dummy[]
dw_att.resetupdate()
if ab_with_retreive then
	dw_att.setredraw(false)
	dw_att.of_retrieve( )
	_write_to_status_text("COUNTER")
	ll_row = dw_att.getrowfromrowid(ll_row_id)
	if ll_row > 0 then
		dw_att.selectrow( 0, false)
		if dw_att.rowcount() = 0 then
			/* do nothing, as datawindow is empty */
		elseif dw_att.rowcount() >= ll_row then
			dw_att.selectrow( ll_row, true)
			dw_att.scrolltorow(ll_row)
		else
			dw_att.selectrow( dw_att.rowcount(), true)
			dw_att.scrolltorow(dw_att.rowcount())
		end if
	end if
	if ll_lastclicked<>ll_row then
		dw_att.of_setlastclickedrow(ll_row)
	end if
	dw_att.setredraw(true)	
end if

return c#return.Success
end function

public function integer of_delete_att ();long ll_selected=0
integer ll_userresp
str_requested_att lstr_deleted_att, lstr_dummy

ll_selected = long(dw_att.describe("evaluate('sum( if(isselected(), 1, 0) for all)',1)"))
if ll_selected = 0 then return c#return.NoAction

ll_userresp = messagebox("Notice","Delete " + string(ll_selected) + " attachment(s).", Question!, YesNo!, 1)
if ll_userresp = 1 then
	ll_selected = dw_att.getselectedrow(0)
	do while ll_selected > 0
		lstr_deleted_att = lstr_dummy
		/* process deletion process */
		/* if inserted item has also been opened we can delete the reference from the cached copy */
		//inv_cache_mgmt.of_delete_att_struct_with_row_id(ll_row_id)
		lstr_deleted_att.l_file_id = dw_att.getitemnumber( ll_selected , "file_id")
		lstr_deleted_att.l_row_id = dw_att.getrowidfromrow( ll_selected )
		lstr_deleted_att.i_methodref = ii_METHOD_DELETE
		istr_pending_atts[upperbound(istr_pending_atts) + 1] = lstr_deleted_att
		dw_att.deleterow(ll_selected)
		
		ll_selected = dw_att.getselectedrow(ll_selected - 1)
	loop
	
	if ib_autosave then
		of_db_commit_handler(istr_pending_atts[])		
	end if
	return c#return.Success
else
	return c#return.NoAction
end if

end function

protected function long _init_struct_file (ref str_requested_att astr_att, string as_file_name, integer ai_methodref);/* load what we can into the attachment structure */

integer li_charpos
	
	for li_charpos = len(as_file_name) to 1 step -1
		if mid(as_file_name,li_charpos,1)="\" then
			astr_att.s_file_name = mid(as_file_name,li_charpos+1)
			astr_att.s_file_path = mid(as_file_name,1,li_charpos)
			exit
		end if
	next
	astr_att.s_modified_user_id = sqlca.userid
	
	//TODO this date should be held until after the database update!
	astr_att.dtm_last_modified_date = datetime(today(),now())
	astr_att.i_methodref = ai_methodref

return c#return.Success
end function

protected function long _init_struct_mail (ref str_requested_att astr_att, long al_param, integer ai_methodref);string					ls_message, ls_pre, ls_searchpath
int						li_charpos
str_findfiledata		lstr_data
mt_n_filefunctions 	lnv_filefunc
n_dirattrib 			lnv_files[]


	//TODO missing string manipulations?
	
	ls_message = string( al_param, "address" )
	li_charpos = pos( ls_message, "~r~n" )
	if li_charpos > 0 then
		ls_message = left( ls_message, li_charpos - 1 )
	end if
	ls_pre = left( ls_message, lastpos( ls_message, "." ) - 1)
	astr_att.s_file_path = left( ls_message, lastpos( ls_message, "\" ))
	ls_searchpath = ls_pre + "*.*"
	lnv_filefunc.of_dirlist( ls_searchpath, 8224 , lnv_files)
	astr_att.s_file_name = trim( lnv_files[upperbound(lnv_files)].is_filename )
	astr_att.s_modified_user_id = sqlca.userid
	astr_att.i_methodref = ai_methodref
	
	//TODO this date should be held until after the database update!
	astr_att.dtm_last_modified_date = datetime(today(),now())

return c#return.Success
end function

protected function integer of_dropout ();/********************************************************************
of_dropout( )

<DESC>
	Handles multiple selected attachments that are inside Tramos and allows user to drop
	them in file explorer or outlook.
	This function is called when a user initiates the dropout feature.  make sure property ib_dropout is enabled.
</DESC>
<RETURN> 
	Integer:
		<LI> n/a
</RETURN>
<ACCESS>
	Protected
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
		Must have c#.net mtdotnet.dll installed (.net 4.0).  (create registry file and import into system registry)
		Instructions to create on developer workstation. Inside command window:
			* C:\windows\microsoft.net\framework64\v4.0.30319\regasm mtdotnet.dll /regfile:mtdotnet.reg
		
		To register on client:
			* REG import mtdotnet.reg
			
		Registration of DLL on user myVDI clients should be managed by the tramoslocal.cmd file or such like.
		
		.net class mtdotnet.dropout has foillowing methods:
			1. addDropOut(string fileName) returns long -> number of attachments in batch
			2. doDropOut(bool showDebugMessage) returns int -> 1=Success; 0=Nothing to do
			3. getAttachmentCount() returns long -> number of atachments
		
			
</USAGE>
********************************************************************/

integer li_retvalue, li_rc
long ll_cached_index, ll_row, ll_dropped_count
str_requested_att lstr_att
string ls_file	
oleobject ole_dropout

	
populateerror(555,"dummy")		

//PROG ID = {FA2798A5-7C80-4F42-A648-23B5FF3F5FA5}	
for ll_row = 1 to dw_att.rowcount()

	if dw_att.isselected(ll_row) then		
		if ll_dropped_count = 0 then
			ole_dropout = create oleobject
			li_rc = ole_dropout.connecttonewobject ( "mtdotnet.dropout" )
		end if	

		li_retvalue = inv_cache_mgmt.of_findload_requsted_att_cached( dw_att.getitemnumber(ll_row,"file_id"), dw_att.getitemstring(ll_row,"file_name"), &
			ll_cached_index, lstr_att) 
		if li_retvalue=c#return.Success then
			lstr_att = inv_cache_mgmt.of_get_att_struct(ll_cached_index)
		elseif li_retvalue=c#return.NoAction then 
			_addmessage(this.classdefinition , error.object + "::" + error.objectevent, "file attachment has since been deleted by another user.  Please refresh your view","refresh issue with user")
			_write_to_status_text("COUNTER")
		else
			inv_cache_mgmt.of_get_data_from_db_to_cache(lstr_att)
			ll_cached_index = inv_cache_mgmt.of_insert_into_cache_array(lstr_att)
		end if

		ls_file = lstr_att.s_file_path + lstr_att.s_file_name
		/* append to files array inside ole_dropout object */
		ll_dropped_count = ole_dropout.addDropOut(ls_file)		
	end if
next

/* boolean flag determines if messagebox inside .net method is shown */
if ll_dropped_count > 0 then
	ole_dropout.doDropOut(false)
end if

ole_dropout.DisconnectObject()
destroy ole_dropout
	
return c#return.Success


end function

on u_att.create
int iCurrent
call super::create
this.st_statustext=create st_statustext
this.pb_cancel=create pb_cancel
this.pb_delete=create pb_delete
this.pb_update=create pb_update
this.pb_new=create pb_new
this.dw_att=create dw_att
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_statustext
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.pb_delete
this.Control[iCurrent+4]=this.pb_update
this.Control[iCurrent+5]=this.pb_new
this.Control[iCurrent+6]=this.dw_att
end on

on u_att.destroy
call super::destroy
destroy(this.st_statustext)
destroy(this.pb_cancel)
destroy(this.pb_delete)
destroy(this.pb_update)
destroy(this.pb_new)
destroy(this.dw_att)
end on

event constructor;call super::constructor;dw_att.dataobject = is_att_dataobject
dw_att.settransobject(sqlca)

POST DragAcceptFiles( Handle( this ), true ) 
if sl_handle = 0  then
	sl_handle = Handle(parent)
	POST RegisterDropTargetEx2( sl_handle, 1024, sl_handle, inv_cache_mgmt.of_get_temp_folder())
end if
_arrange_controls()

end event

event destructor;call super::destructor;/********************************************************************
event ancestor destructor
<DESC>
	deletes all the files used within this session & removes the array of attachments
</DESC>
<RETURN> 
	n/a
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	TODO: split out the main delete process and apply general purge method when user opens tramos
</USAGE>
********************************************************************/

RevokeDragDrop(handle(parent))
inv_cache_mgmt.of_purge_cached_data()
end event

type st_statustext from mt_u_statictext within u_att
integer y = 508
integer width = 1550
integer height = 72
string text = "The quick brown fox jumped over the lazy dog"
alignment alignment = center!
end type

type pb_cancel from picturebutton within u_att
boolean visible = false
integer x = 1902
integer y = 504
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

event clicked;/* revert changes */

of_finish_pending_atts( false )
end event

type pb_delete from picturebutton within u_att
boolean visible = false
integer x = 1792
integer y = 504
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

event clicked;/* delete selected item */
of_delete_att()
end event

type pb_update from picturebutton within u_att
boolean visible = false
integer x = 1682
integer y = 504
integer width = 110
integer height = 96
integer taborder = 30
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

event clicked;/* commit pending changes */

of_finish_pending_atts(true)
end event

type pb_new from picturebutton within u_att
boolean visible = false
integer x = 1573
integer y = 504
integer width = 110
integer height = 96
integer taborder = 20
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

event clicked;of_add_single_file_dialogue( )
end event

type dw_att from mt_u_dw_att within u_att
event ue_mousemove pbm_dwnmousemove
integer width = 2002
integer height = 500
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
boolean __ib_rowselection = true
boolean ib_multitableupdate = true
end type

event ue_mousemove;if handle(Parent) <> sl_handle then
	sl_handle = handle(Parent)
	POST RegisterDropTargetEx2( sl_handle, 1024, sl_handle, inv_cache_mgmt.of_get_temp_folder())
end if
end event

event ue_clicked;call super::ue_clicked;string ls_folderdatetimestamp, ls_cached_folder
mt_n_filefunctions lnv_filefunc
str_requested_att lstr_att
int li_retvalue
blob lbl_data
long ll_new_cached_index, ll_cached_index, ll_found

/* test if dwo object is valid */
if xpos = 0 and ypos = 0 then
	_write_to_status_text("COUNTER")
	return
end if

if (keydown(KeyShift!) or keydown(KeyControl!)) and row > 0 then
	this.settaborder("description",0)
else
	this.settaborder("description",10)
end if	


if right(dwo.name,10) = "p_openfile" then
	
	populateerror(555,"dummy")	
	li_retvalue = inv_cache_mgmt.of_findload_requsted_att_cached( dw_att.getitemnumber(row,"file_id"), dw_att.getitemstring(row,"file_name"), &
		ll_cached_index, lstr_att) 
	
	if li_retvalue=c#return.Success then
		/* great! already opened and cached file, with no update elsewhere.  Lets open that file */
		inv_cache_mgmt.of_setmethodref(ll_cached_index, 1)
		inv_cache_mgmt.of_open_file_from_cache(ll_cached_index, handle(this))	
		
	elseif li_retvalue=c#return.NoAction then 
		// TODO - delete element and shuffle array as item has been deleted in the meantime
		_addmessage(this.classdefinition , error.object + "::" + error.objectevent, "file attachment has since been deleted by another user.  Please refresh your view","refresh issue with user")
		_write_to_status_text("COUNTER")
	else
		inv_cache_mgmt.of_get_data_from_db_to_cache(lstr_att)
		ll_cached_index = inv_cache_mgmt.of_insert_into_cache_array(lstr_att)
		inv_cache_mgmt.of_open_file_from_cache(ll_cached_index, handle(this))
	end if	
	
elseif right(dwo.name,15) = "compute_replace" then
	// TODO
	//_replaceimage(row)	
end if



end event

event itemchanged;call super::itemchanged;if dwo.name= "description" then
	if trim(data) = "" then
		return 2
	end if
end if
if ib_autosave then
	if dwo.name= "description" then
		if dw_att.of_updatetables() = c#return.Success  then
			commit using sqlca;
			this.post resetupdate()
		end if
	end if
else
	// to do!
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;/* triggered drop out feature, is property enabled? */
if ib_dropout then 
	if keydown(keyAlt!) then
		of_dropout()
	end if
end if

end event

