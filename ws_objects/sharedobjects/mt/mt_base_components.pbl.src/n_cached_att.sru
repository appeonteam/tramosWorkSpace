$PBExportHeader$n_cached_att.sru
forward
global type n_cached_att from mt_n_nonvisualobject
end type
type shellexecuteinfo from structure within n_cached_att
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

global type n_cached_att from mt_n_nonvisualobject autoinstantiate
end type

type prototypes
function boolean ShellExecuteEx (ref SHELLEXECUTEINFO lpExecInfo) Library "shell32.dll" alias for "ShellExecuteExW"
end prototypes

type variables
int ii_methodref   //1=Inserted 2=Opened 3=Outlook DD 4=Explorer DD 5=Deleted any others??
string 							is_cachedsubfolder 				= "cached_tramos_data\"
string 							is_tempdir	
private str_requested_att _istr_att_data[]

end variables

forward prototypes
public subroutine documentation ()
public function integer of_findload_requsted_att_cached (long al_file_id, string as_file_name, ref long al_cachedindex, ref str_requested_att astr_request)
public function string of_get_file_path (long al_index)
public function boolean of_is_matched (ref str_requested_att astr_att, long al_index)
public function integer of_setmethodref (long al_index, integer ai_methodref)
public function integer of_purge_cached_data ()
public function string of_get_temp_folder ()
public function integer of_get_data_from_db_to_cache (ref str_requested_att astr_att)
public function long of_insert_into_cache_array (str_requested_att astr_att)
public function integer of_open_file_from_cache (long al_index, long al_handle)
public function str_requested_att of_get_att_struct (long ll_index)
end prototypes

public subroutine documentation ();/********************************************************************
   n_object_name: n_cached_att
	
	<OBJECT>
		used by the application to reference current attachment items
	</OBJECT>
   <DESC>
		manages the cached files along with the array of structure objects
		referencing to them.
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	11/06/15 	CR      	AGL				First Version
********************************************************************/
end subroutine

public function integer of_findload_requsted_att_cached (long al_file_id, string as_file_name, ref long al_cachedindex, ref str_requested_att astr_request);long ll_cached_att_index
boolean lb_matched = false
string ls_att_file_path


	astr_request.l_file_id = al_file_id
	astr_request.s_file_name = as_file_name

	SELECT 
       ATTACHMENTS.UPDATED_BY,   
       ATTACHMENTS.UPDATED_DATE  
	INTO 
		:astr_request.s_modified_user_id,
		:astr_request.dtm_last_modified_date
	FROM 	
		ATTACHMENTS  
	WHERE
		ATTACHMENTS.FILE_ID = :astr_request.l_file_id
	USING sqlca;
	
	// check this validation works!
	if isnull(astr_request.dtm_last_modified_date) then
		// file is expected to be deleted
		return c#return.NoAction
	else
		for ll_cached_att_index = 1 to upperbound(_istr_att_data)
			lb_matched = of_is_matched(astr_request, ll_cached_att_index)	
			if lb_matched then
				al_cachedindex = ll_cached_att_index
				return c#return.Success
			end if
		next
	end if	
	
return c#return.Failure
end function

public function string of_get_file_path (long al_index);return _istr_att_data[al_index].s_file_path

end function

public function boolean of_is_matched (ref str_requested_att astr_att, long al_index);//TODO - limited solution regarding the date.  careful comparisions between db server & local date/time must be accounted for.
//Perhaps user match is enough?
if (astr_att.l_file_id = _istr_att_data[al_index].l_file_id and astr_att.s_modified_user_id = _istr_att_data[al_index].s_modified_user_id and astr_att.dtm_last_modified_date = _istr_att_data[al_index].dtm_last_modified_date) then
	return true
end if	
return false




end function

public function integer of_setmethodref (long al_index, integer ai_methodref);//1= open

_istr_att_data[al_index].i_methodref = ai_methodref
return c#return.Success


end function

public function integer of_purge_cached_data ();/********************************************************************
of_purge_cached_data
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

long ll_cached_att_index, ll_totalfiles, ll_deletedfiles, ll_files
mt_n_filefunctions lnv_filefunc
n_dirattrib lnv_files[], lnv_empty[]
string ls_searchpath
boolean lb_deleted, lb_cannotremovefolder

ll_deletedfiles = 0
populateerror(555,"dummy")

/* loop through all cached items in memory.  try and delete firstly the files contained within and then each subfolder */
for ll_cached_att_index = 1 to upperbound(_istr_att_data)
	if directoryexists(of_get_file_path(ll_cached_att_index)) then
		lb_cannotremovefolder = false
		ls_searchpath = of_get_file_path(ll_cached_att_index) + "*.*"
		lnv_filefunc.of_dirlist( ls_searchpath, 8224 , lnv_files[])
		for ll_files = 1 to upperbound(lnv_files)
			if left(lnv_files[ll_files].is_filename,1)<>"[" then
				lb_deleted = filedelete(of_get_file_path(ll_cached_att_index) + lnv_files[ll_files].is_filename)
				if not(lb_deleted) then
					lb_cannotremovefolder = true
					_addmessage( this.classdefinition, error.object + "::" + error.objectevent, "File in use, cannot delete", "purge failed due to file in use.  " + lnv_files[ll_files].is_filename + " inside " + of_get_file_path(ll_cached_att_index))
				else
					// currently unused.
					ll_deletedfiles ++
				end if
			end if
		next	
		if lb_cannotremovefolder = false then
			removedirectory(of_get_file_path(ll_cached_att_index))
		end if	
		lnv_files = lnv_empty
	end if
next

str_requested_att lstr_dummy[]
_istr_att_data = lstr_dummy
return c#return.Success
end function

public function string of_get_temp_folder ();return is_tempdir

end function

public function integer of_get_data_from_db_to_cache (ref str_requested_att astr_att);n_service_manager 		lnv_servicemgr
n_att_service				lnv_att_service
longlong						lll_filesize
blob 							lbl_data
long 							ll_filehandle, ll_new

astr_att.s_file_path = is_tempdir + string(now(), "yyyymmddhhmmssffff") + "\"	
		
ll_new = upperbound(_istr_att_data) + 1	
of_setmethodref( ll_new, 2) // write

populateerror(555,"dummy")	
lnv_servicemgr.of_loadservice( lnv_att_service, "n_att_service")

if lnv_att_service.of_readattach(astr_att.l_file_id, lbl_data, lll_filesize) = c#return.Failure then
	_addmessage(this.classdefinition , error.object + "::" + error.objectevent, "There is no file attached.", "n/a")
	return c#return.Failure
end if

createdirectory(astr_att.s_file_path)		

ll_filehandle = fileopen(astr_att.s_file_path + astr_att.s_file_name, streammode!, write!, lockwrite!, replace!)
filewriteex(ll_filehandle, lbl_data) 
fileclose(ll_filehandle)

return c#return.Success
end function

public function long of_insert_into_cache_array (str_requested_att astr_att);long ll_newindex 

ll_newindex = upperbound(_istr_att_data) + 1
_istr_att_data[ll_newindex] = astr_att

return ll_newindex
end function

public function integer of_open_file_from_cache (long al_index, long al_handle);SHELLEXECUTEINFO 		lstr_sei 		// structure located within this object

constant long 				SW_SHOWNORMAL					= 1
constant long 				SEE_MASK_NOCLOSEPROCESS 	= 64

lstr_sei.cbSize = 60
lstr_sei.fMask  = SEE_MASK_NOCLOSEPROCESS
lstr_sei.hWnd   = al_handle
lstr_sei.lpVerb = ""
lstr_sei.lpFile = _istr_att_data[al_index].s_file_path + _istr_att_data[al_index].s_file_name
lstr_sei.nShow  = SW_SHOWNORMAL
/* now open the attachment and let the OS decide what application to associate */				
if ShellExecuteEx(lstr_sei) then
	return c#return.Success
end if


return c#return.Failure


end function

public function str_requested_att of_get_att_struct (long ll_index);/* obtain a single element from array of cached attachment structure */
return _istr_att_data[ll_index]  
end function

on n_cached_att.create
call super::create
end on

on n_cached_att.destroy
call super::destroy
end on

event constructor;call super::constructor;mt_n_filefunctions lnv_filefunc
lnv_filefunc.of_gettempfolder(is_tempdir)

is_tempdir = is_tempdir + is_cachedsubfolder
if not(directoryExists(is_tempdir)) then
	createdirectory(is_tempdir)
end if	
end event

