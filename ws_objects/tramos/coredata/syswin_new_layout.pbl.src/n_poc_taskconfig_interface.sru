$PBExportHeader$n_poc_taskconfig_interface.sru
forward
global type n_poc_taskconfig_interface from mt_n_interface_master
end type
type str_poctask from structure within n_poc_taskconfig_interface
end type
end forward

type str_poctask from structure
	long		pc
	long		task_id
	string		purpose
	string		description
	boolean		loaded
	string		mvv
end type

global type n_poc_taskconfig_interface from mt_n_interface_master
end type
global n_poc_taskconfig_interface n_poc_taskconfig_interface

type variables
private long _il_pc, _il_taskid
string _is_purpose, _is_description
private str_poctask _istr_task
private constant string  _is_TASKLIST ="tasklist"
private constant string  _is_INCLUDED = "included"
private constant string  _is_PURPOSELIST ="purposelist"
end variables

forward prototypes
private subroutine documentation ()
protected subroutine _setup ()
public function long of_retrieve ()
public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row)
public function integer of_retrieve (readonly string as_dsname)
public function integer of_insertrow (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function integer of_update ()
public function integer of_update (readonly string as_dsname)
public function long of_gettask ()
public function boolean of_getloaded ()
public function integer of_setloaded (boolean ab_loaded)
public function integer of_resetflags ()
public function integer of_settask (long al_pc, long al_taskid, string as_purpose, string as_description, string as_mvv)
end prototypes

private subroutine documentation ();/********************************************************************
   ObjectName: n_tasklist_interface
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Interface for all things task related.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  10/11/10 AGL027             First Version
  6/9/11   CR2528  TTY004     Add MVV task configation
********************************************************************/

end subroutine

protected subroutine _setup ();constant string METHOD_NAME = "_setup"

_createdatastore( _is_PURPOSELIST, "d_sq_tb_poc_taskconfig_purposes", "")
_createdatastore( _is_INCLUDED, "d_sq_tb_poc_taskconfig_included", "")
_createdatastore( _is_TASKLIST, "d_sq_tb_poc_taskconfig_tasklist", "")

_setdetail( _is_PURPOSELIST, _is_INCLUDED, {"purpose_code","pc_nr"})


end subroutine

public function long of_retrieve ();return istr_datastore[1].ds_data.retrieve()

end function

public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row);long ll_pcnr, ll_tasks
string ls_purposecode
datastore lds_included, lds_tasklist
long ll_foundtask, ll_taskid, ll_includedtasks, ll_row

if al_row < 1 then return c#return.noaction
if as_master_dsname = _is_PURPOSELIST then
	if istr_datastore[1].ds_data.rowcount()=0 then
		of_retrieve(_is_PURPOSELIST)
	end if	
	ll_pcnr = istr_datastore[1].ds_data.getitemnumber(al_row, "pc")
	ls_purposecode = istr_datastore[1].ds_data.getitemstring(al_row, "purpose_code")
	istr_datastore[2].ds_data.retrieve(ll_pcnr,ls_purposecode)	
	istr_datastore[3].ds_data.reset()
	istr_datastore[3].ds_data.retrieve(ll_pcnr)
end if
//Begin added by TTY004 on 06/09/11
//find out the include task list and set task list the selected task's status
lds_included = istr_datastore[2].ds_data
lds_tasklist = istr_datastore[3].ds_data
ll_tasks = istr_datastore[3].ds_data.rowcount()
ll_includedtasks = istr_datastore[2].ds_data.rowcount()
for ll_row =1 to ll_includedtasks
	ll_taskid = lds_included.getitemnumber(ll_row, "task_id")
	ll_foundtask = lds_tasklist.find("task_id = "+string(ll_taskid), 1, ll_tasks)
	if ll_foundtask > 0 then 
		lds_tasklist.setitem(ll_foundtask, "flag", 1)
		lds_tasklist.setitemstatus(ll_foundtask, "flag", primary!, Notmodified!)
	end if 
next 
//End added by TTY004 on 06/09/11
return c#return.success
end function

public function integer of_retrieve (readonly string as_dsname);integer li_dsindex

for li_dsindex = 1 to upperbound(istr_datastore)
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		if as_dsname<> _is_TASKLIST then
			return istr_datastore[li_dsindex].ds_data.retrieve()
		else
			return istr_datastore[li_dsindex].ds_data.retrieve(_istr_task.pc)
		end if
	end if
next
end function

public function integer of_insertrow (readonly string as_dsname);/********************************************************************
   of_insertRow
   <DESC> Inserts a row into the requsted dataset, and sets the initial values if any.
	When a new claim is created, the detail datasets are reset./DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_dsName: name of dataset where row has to be inserted</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_insertrow"
long		ll_row, li_dsindex
string		ls_docpath, ls_docname
long 		ll_filehandle, ll_file_size, ll_file_row
blob		lbl_filedata

choose case as_dsName
	case _is_INCLUDED
		for li_dsindex = 1 to upperbound(istr_datastore)
			if as_dsname = istr_datastore[li_dsindex].ds_name then
				if isnull(_istr_task.task_id) then
					_addmessage( this.classdefinition, "of_insertrow()", "Error, can not drag, you must save item before dragging", "n/a")
					return c#return.NoAction
				end if	
				ll_row = 	istr_datastore[li_dsindex].ds_data.insertrow(0)	
				istr_datastore[li_dsindex].ds_data.setitem(ll_row,"pc", _istr_task.pc)
				istr_datastore[li_dsindex].ds_data.setitem(ll_row,"purpose_code",_istr_task.purpose)				
				istr_datastore[li_dsindex].ds_data.setitem(ll_row,"task_id", _istr_task.task_id )
				istr_datastore[li_dsindex].ds_data.setitem(ll_row,"description", _istr_task.description)
				istr_datastore[li_dsindex].ds_data.setitem(ll_row, "task_mvv_name", _istr_task.mvv)//Added by TTY004 on 06/09/11. Change desc:
				return c#return.Success
			end if
		next
	case _is_TASKLIST
		for li_dsindex = 1 to upperbound(istr_datastore)
			if as_dsname = istr_datastore[li_dsindex].ds_name then
				ll_row = 	istr_datastore[li_dsindex].ds_data.insertrow(0)
				istr_datastore[li_dsindex].ds_data.setitem(ll_row,"pc",_istr_task.pc)
				istr_datastore[li_dsindex].ds_data.setitemstatus(ll_row, 0, primary!, notmodified!)
			end if
		next
end choose

return ll_row
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
   of_insertRow
   <DESC> Inserts a row into the requsted dataset, and sets the initial values if any.
	When a new claim is created, the detail datasets are reset./DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_dsName: name of dataset where row has to be inserted</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_deleterow"
long		ll_row, ll_taskid, ll_used
integer 	li_dsindex
string		ls_docpath, ls_docname
long 		ll_filehandle, ll_file_size, ll_file_row
blob		lbl_filedata


for li_dsindex = 1 to upperbound(istr_datastore)
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		if as_dsname = _is_TASKLIST then
			ll_taskid = istr_datastore[li_dsindex].ds_data.getitemnumber(al_row,"task_id")
			/* check the port of call tasks to see if it is in use */
			SELECT count(TASK_ID)
			INTO :ll_used
			FROM POC_TASK_LIST
			WHERE TASK_ID = :ll_taskid ;
			COMMIT USING SQLCA;
			if ll_used>0 then
				_addmessage(this.classdefinition, METHOD_NAME , "Can not delete this task as it is already used in the port of call window.", "user info")	
				return c#return.NoAction
			end if	
			/* next check the profit center in the configuration to see if it is in use */
			SELECT count(TASK_ID)
			INTO :ll_used
			FROM POC_TASKS_CONFIG_PC
			WHERE TASK_ID = :ll_taskid ;
			COMMIT USING SQLCA;
			if ll_used>0 then
				_addmessage(this.classdefinition, METHOD_NAME , "Can not delete this task as it is currently used in another purpose.", "user info")	
				return c#return.NoAction
			end if	
		end if
		return istr_datastore[li_dsindex].ds_data.deleterow(al_row)
	end if
next	
return 0


end function

public function integer of_update ();constant string METHOD_NAME = "of_update()"
long ll_row, ll_rows,ll_found, ll_foundduplicate=1
integer li_dsindex, li_dsinc
string ls_description, ls_findexpression, ls_found=""





for li_dsindex = 1 to upperbound(istr_datastore)
	if istr_datastore[li_dsindex].ds_name = _is_INCLUDED then li_dsinc = li_dsindex
	if istr_datastore[li_dsindex].ds_data.modifiedcount() > 0 or istr_datastore[li_dsindex].ds_data.deletedcount() > 0 then
		if istr_datastore[li_dsindex].ds_name = _is_TASKLIST then
			istr_datastore[li_dsindex].ds_data.setfilter("")
			istr_datastore[li_dsindex].ds_data.filter()
			ll_rows =  istr_datastore[li_dsindex].ds_data.rowcount()
			/* 
			Business Logic
			Task description can not be empty or may not be duplicated.  
			when duplicated if a new record, delete it otherwise revert the changes made
			*/
			// for ll_row =  ll_rows to 1 step -1 
			for ll_row =  1 to ll_rows
				if istr_datastore[li_dsindex].ds_data.getitemstatus(ll_row,0,Primary!) <> NotModified! then
					ls_description = istr_datastore[li_dsindex].ds_data.getitemstring( ll_row, "description")
					if trim(ls_description) = "" or isnull(ls_description) then
						_addMessage( this.classdefinition, METHOD_NAME, "Task description is mandatory!", "")
						return  c#return.failure
					end if
					ls_findexpression = "description = '" + ls_description + "' and getRow() <> " + string( ll_row )
					ll_foundduplicate = istr_datastore[li_dsindex].ds_data.find(ls_findexpression, ll_foundduplicate, ll_rows) 	
					if ll_foundduplicate > 0 then
						ls_found += ls_description + ", "
						if istr_datastore[li_dsindex].ds_data.getitemstatus(ll_row,0,Primary!) = NewModified! then
							/* delete new duplicated task */
							istr_datastore[li_dsindex].ds_data.deleterow(ll_row)
							ll_row --
							ll_rows --
						else
							/* restore duplicated task */
							istr_datastore[li_dsindex].ds_data.setitem(ll_row,"description",istr_datastore[li_dsindex].ds_data.getitemstring( ll_row, "description", Primary!,true)	)					
						end if
					end if	
				end if
			next
			if ls_found<>"" then
				ls_found = mid(ls_found,1,len(ls_found)-2)
				_addMessage( this.classdefinition, METHOD_NAME, "Error, duplicate task descriptions are not allowed. Modified task(s) " + ls_found + "'  have been reverted.", "user warning")					
			end if	
		end if	
		if istr_datastore[li_dsindex].ds_data.update() = 1 then
			commit;	
		else
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME, "Update of task configuration failed!", "N/A")
			return c#return.failure
		end if						
	end if
next
ll_rows = of_retrieve()
return c#return.success
end function

public function integer of_update (readonly string as_dsname);constant string METHOD_NAME = "of_update"
long ll_row, ll_rows
integer li_dsindex

for li_dsindex = 1 to upperbound(istr_datastore)
	
	
	
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		ll_rows =  istr_datastore[li_dsindex].ds_data.rowcount()
		for ll_row = 1 to ll_rows
			if trim( istr_datastore[li_dsindex].ds_data.getitemstring( ll_row, "description")) = "" or &
				isnull( istr_datastore[li_dsindex].ds_data.getitemstring( ll_row, "description")) then
				_addMessage( this.classdefinition, METHOD_NAME, "Task description is mandatory!", "")
				return  c#return.failure
			end if
		next
		
		if istr_datastore[li_dsindex].ds_data.update() = 1 then
			commit;	
		else
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME, "Update Type List failed!", "N/A")
			return c#return.failure
		end if
	end if
next
return c#return.success
end function

public function long of_gettask ();return _il_taskid
end function

public function boolean of_getloaded ();return _istr_task.loaded
end function

public function integer of_setloaded (boolean ab_loaded);_istr_task.loaded = ab_loaded
return c#return.Success
end function

public function integer of_resetflags ();integer li_dsindex

for li_dsindex = 1 to upperbound(istr_datastore)
	istr_datastore[li_dsindex].ds_data.resetupdate()
next
return c#return.Success
end function

public function integer of_settask (long al_pc, long al_taskid, string as_purpose, string as_description, string as_mvv);if al_pc<>0 then _istr_task.pc = al_pc
_istr_task.task_id = al_taskid
if as_purpose<>"" then  _istr_task.purpose = as_purpose
if as_description<>"" then _istr_task.description = as_description
 _istr_task.mvv = as_mvv //Added by TTY004 on 06/09/11. Change desc:
return c#return.Success
end function

on n_poc_taskconfig_interface.create
call super::create
end on

on n_poc_taskconfig_interface.destroy
call super::destroy
end on

