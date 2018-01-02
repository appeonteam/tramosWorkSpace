$PBExportHeader$u_poc_taskconfig.sru
forward
global type u_poc_taskconfig from mt_u_visualobject
end type
type pb_exclude from picturebutton within u_poc_taskconfig
end type
type pb_include from picturebutton within u_poc_taskconfig
end type
type dw_tasklist from mt_u_datawindow within u_poc_taskconfig
end type
type dw_included from mt_u_datawindow within u_poc_taskconfig
end type
type dw_purposelist from mt_u_datawindow within u_poc_taskconfig
end type
end forward

global type u_poc_taskconfig from mt_u_visualobject
integer width = 2396
integer height = 2044
long backcolor = 32304364
event ue_postconstructor ( )
pb_exclude pb_exclude
pb_include pb_include
dw_tasklist dw_tasklist
dw_included dw_included
dw_purposelist dw_purposelist
end type
global u_poc_taskconfig u_poc_taskconfig

type variables
private n_poc_taskconfig_interface  	_inv_taskconfig							// interface object
private integer 								_ii_xpos, _ii_ypos							// co-ordinates where user triggers lbuttondown
private integer								_ii_range							= 10		// pixels away from co-ordinates before enabling dragdrop
private boolean 							_ib_dragincludes 				= false 	// dragging from include list enabled
private boolean 							_ib_dragexcludes 				= false 	// dragging from exclude list enabled
private boolean 							_ib_dragincludesorder 		= false 	// dragging from sort order column in included list enabled 
private boolean 							_ib_editmode 					= false 	// stops dragging possibility when user is editing.
private boolean 							_ib_ignorelbuttonup 			= false 	// disables the new selection if drag fails 
private boolean 							_ib_cancelled					= false 	// controls if user wants to cancel changes
private boolean								_ib_readonly 					= false	// stores basic level user access rights received from parent window
private long 									_il_lastclickedrowincludes				// stores the last clicked row in included list
private long 									_il_lastclickedrowexcludes				// stores the last clicked row in excluded list
private constant string             _is_TASKLIST = "tasklist"            // use constant _is_TASKLIST replace string "tasklist"
private constant string 	         _is_INCLUDED = "included"            // use constant _is_INCUDED replace string "included"
end variables

forward prototypes
private function integer _changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number)
public function integer of_refresh (integer al_pc_nr)
public function integer of_newtask ()
public function integer of_updatetask (string as_method)
private function integer _filterexcluded ()
public subroutine documentation ()
public function integer _setbuttons ()
public function integer of_setreadonly (boolean ab_readonly)
public function integer of_updatespending ()
public function integer of_retreivepurposes ()
end prototypes

event ue_postconstructor();n_service_manager 		lnv_servicemgr
n_dw_style_service  	lnv_dwstyle
long ll_rows

_inv_taskconfig = create n_poc_taskconfig_interface
lnv_servicemgr.of_loadservice( lnv_dwstyle, "n_dw_style_service")


if _inv_taskconfig.of_share( "purposelist", this.dw_purposelist ) = c#return.failure then
	_addMessage( this.classdefinition, "constructor", "Error getting the data for the Base Claim information", "The interface manager of_share() function failed while sharing the 'claimbase'")	
	return
end if

if _inv_taskconfig.of_share( _is_INCLUDED, this.dw_included ) = c#return.failure then
	_addMessage( this.classdefinition, "constructor", "Error getting the data for the Base Claim information", "The interface manager of_share() function failed while sharing the 'claimbase'")	
	return
end if

if _inv_taskconfig.of_share( _is_TASKLIST, this.dw_tasklist ) = c#return.failure then
	_addMessage( this.classdefinition, "constructor", "Error getting the data for the Base Claim information", "The interface manager of_share() function failed while sharing the 'claimbase'")	
	return
end if

lnv_dwstyle.of_dwlistformater(dw_purposelist)
lnv_dwstyle.of_dwlistformater(dw_included)
lnv_dwstyle.of_dwlistformater(dw_tasklist)

ll_rows = _inv_taskconfig.of_retrieve()
_inv_taskconfig.of_retrieve(_is_TASKLIST)

if _ib_readonly then
	dw_tasklist.object.datawindow.readonly = "Yes"
	dw_included.object.datawindow.readonly = "Yes"
	pb_exclude.enabled = false
	pb_include.enabled = false
end if

//_setbuttons()


end event

private function integer _changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number);/********************************************************************
of_changeorder( /*integer ai_moved_row */,/*integer ai_row */,/*datawindow adw */,/*integer ai_number */)

<DESC>
	changes the order number when dragdrop of sort number			
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X Success
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
		adw.setitem(li_row,"task_sort",adw.getitemnumber(li_row, "task_sort") + ai_number)
	next
return c#return.Success
end function

public function integer of_refresh (integer al_pc_nr);/********************************************************************
of_refresh( /*integer al_pc_nr */)

<DESC>
	filters out purposes contained in selected profit center
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
		al_pc_nr : long variable containing the selected profit center number.
</ARGS>
<USAGE>
	Simple - called from parent window object when profit center
	or tab index are changed.
</USAGE>
********************************************************************/

integer li_pc, li_row

li_row =  dw_purposelist.getselectedrow(0) 
if li_row = 0 then return c#return.noaction

li_pc=dw_purposelist.getitemnumber(li_row,"pc")

if al_pc_nr<>li_pc then 
	_inv_taskconfig.of_setloaded(false)
	dw_purposelist.setfilter("pc=" + string(al_pc_nr))
	dw_purposelist.filter()
	dw_purposelist.sort()
end if	

return c#return.Success
end function

public function integer of_newtask ();/********************************************************************
of_newtask( )

<DESC>
	inserts a new row in the excluded dw.
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>    
</ARGS>
<USAGE>
	Simple - called from parent window object to add new
	task.
</USAGE>
********************************************************************/
long ll_dummy
setnull(ll_dummy)

if _ib_readonly then return c#return.NoAction

_inv_taskconfig.of_settask(dw_purposelist.getitemnumber(1,"pc"), ll_dummy, dw_purposelist.getitemstring(dw_purposelist.getselectedrow(0),"purpose_code"), "", "")  
_inv_taskconfig.of_insertrow(_is_TASKLIST)
dw_tasklist.setfocus()
dw_tasklist.setrow(dw_tasklist.rowcount())
dw_tasklist.selectrow( 0, false)
dw_tasklist.selectrow(dw_tasklist.rowcount() ,true)
dw_tasklist.scrolltorow(dw_tasklist.rowcount())
dw_tasklist.settaborder( "description", 10)
dw_tasklist.settaborder("task_mvv_name", 20)
dw_tasklist.setcolumn("description")

return c#return.Success
end function

public function integer of_updatetask (string as_method);/********************************************************************
of_updatetask( /*string as_method */)

<DESC>
	depending on parameter received performs required update
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
		as_method : string - either 'delete', 'save' or 'cancel'
</ARGS>
<USAGE>
	Called from parent window object normally from command
	buttons.  Performs any of the 3 actions accordingly
</USAGE>
06/09/11  CR2528    TTY004    if cancel update  refresh task list status
********************************************************************/
String METHOD_NAME="of_updatetask('delete')"
long 		ll_rows, ll_currentrow
integer	li_confirm
string	ls_purpose, ls_msg, ls_desc
long ll_taskid, ll_found_task, ll_includetask_count,ll_row
	if _ib_readonly then return c#return.NoAction

	if lower(as_method) = "delete" then
		if dw_tasklist.rowcount() <> 0 then
			ll_currentrow = dw_tasklist.getrow()
			if ll_currentrow > 0 then
				if dw_tasklist.getitemnumber(ll_currentrow, "flag") = 1 then
					_addmessage(this.classdefinition, METHOD_NAME , "Cannot delete this task as it is already in the included tasks", "user info")
				end if 
				_inv_taskconfig.of_deleterow(_is_TASKLIST, ll_currentrow)
			end if
		end if
	else	
		dw_tasklist.setredraw(false)
		dw_included.setredraw(false)
		ls_purpose = dw_purposelist.getitemstring(dw_purposelist.getrow(),"purpose_code")
		if lower(as_method) = "cancel" then 
			_ib_cancelled = true
			ll_rows = _inv_taskconfig.of_retrieve()
			_inv_taskconfig.of_retrieve( _is_TASKLIST)
			//Begin added by TTY004 on 06/09/11
			ll_includetask_count = dw_included.rowcount()
			for ll_row = 1 to ll_includetask_count 
				ll_taskid = dw_included.getitemnumber( ll_row, "task_id")
				ll_found_task = dw_tasklist.find("task_id = "+string(ll_taskid), 1, dw_tasklist.rowcount())
				if ll_found_task > 0 then 
					dw_tasklist.setitem(ll_found_task, "flag", 1)
					dw_tasklist.setitemstatus(ll_found_task, "flag", primary!, NotModified!)
				end if 
			next 
         //End added by TTY004 on 06/09/11
		elseif lower(as_method) = "save" then
			dw_tasklist.accepttext()
			dw_tasklist.settaborder( "description", 0)
			dw_tasklist.settaborder("task_mvv_name", 0)
			 _inv_taskconfig.of_update() 
				// do nothing
			//end if
		end if
		_ib_cancelled=false
		ll_currentrow = dw_purposelist.find("purpose_code='" + ls_purpose + "'", 1, dw_purposelist.rowcount())
		dw_purposelist.setrow(ll_currentrow)
		dw_tasklist.setredraw(true)
		dw_included.setredraw(true)
	end if

return c#return.Success		
end function

private function integer _filterexcluded ();/********************************************************************
_filterexcluded( )

<DESC>
	builds a filter string of task_id's contained in the 'included' dw.
	uses this to filter out of task list.
</DESC>
<RETURN>
	Integer:	
		<LI> 1, X Success
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>    
</ARGS>
<USAGE>
	Called in dragdrop event of both included & excluded dw's
</USAGE>
********************************************************************/
long ll_row
string ls_filtertext

	if dw_included.rowcount()>0 then 
		for ll_row = 1 to dw_included.rowcount()
			ls_filtertext += string(dw_included.getitemnumber(ll_row, "task_id")) + ","
		next
		ls_filtertext = "task_id not in (" + mid(ls_filtertext,1, len(ls_filtertext) - 1) + ")"
	end if
	dw_tasklist.setfilter( ls_filtertext)
	dw_tasklist.filter()
	dw_tasklist.groupcalc( )

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_poc_tasklist
	
   <OBJECT>user object containing task list configuration</OBJECT>
   <DESC>used in window object w_profitcenterlist, on the 4th tab page</DESC>
   <USAGE>	</USAGE>
   <ALSO>uses interface object n_poc_tasklist_interface where working
	directly with the database.</ALSO>
    Date   		Ref    		Author		Comments
  26/11/10 	cr2193	AGL027		First Version
  09/12/10				AGL027		Improvements in optimising retreivals, readonly 
  											access and duplicate search processing.
  16/12/10	cr2225	AGL027		added new public function of_retrievepurposes() 
  24/02/11	CR2264	JMC			Corrected error on of_refresh
  07/06/11	CR2408   ZSW001      Add confirmation while changing/deleting the Task name for Agent and LOI
  06/09/11  CR2528   TTY004      Add MVV task configation
********************************************************************/

end subroutine

public function integer _setbuttons ();if dw_included.getselectedrow(0)>0 then 
	pb_exclude.enabled = true
else
	pb_exclude.enabled = false
end if
if dw_tasklist.getselectedrow(0)>0 then 
	pb_include.enabled = true
else
	pb_include.enabled = false
end if
return c#return.Success
end function

public function integer of_setreadonly (boolean ab_readonly);_ib_readonly = ab_readonly


return c#return.Success
end function

public function integer of_updatespending ();/********************************************************************
   of_updatespending
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	                        				       First Version
	26/09/11     CR2528			TTY004             validation the the tasklist and mvv
   </HISTORY>
********************************************************************/
n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_actionrules
integer li_response
if _inv_taskconfig.of_updatespending() then  // if user pressed cancel skip messagebox
	if not _ib_cancelled then
		li_response = messagebox("Task Configuration - Pending Updates", "You have data that is not saved yet. Would you like to save this data before switching?", Question!,YesNo!, 1)
	end if
	if li_response = 1 then
		lnv_svcmgr.of_loadservice(lnv_actionrules, "n_dw_validation_service")
		lnv_actionrules.of_registerrulestring("description", true, "Task List", true)
		lnv_actionrules.of_registerrulestring("task_mvv_name", false, "MVV", true)
		if lnv_actionrules.of_validate(dw_tasklist, true) = c#return.Failure  then return c#return.Failure
		if _inv_taskconfig.of_update() = c#return.failure then
			_addmessage( this.classdefinition, "rowfocuschanged()", "Error when updating task record(s)", "user error message")
		end if
	else
		_inv_taskconfig.of_resetflags()
		_inv_taskconfig.of_retrieve( )
		_inv_taskconfig.of_retrieve(_is_TASKLIST)
		return c#return.Noaction
	end if
end if
return c#return.Success

end function

public function integer of_retreivepurposes ();_inv_taskconfig.of_retrieve( )
return c#return.Success
end function

on u_poc_taskconfig.create
int iCurrent
call super::create
this.pb_exclude=create pb_exclude
this.pb_include=create pb_include
this.dw_tasklist=create dw_tasklist
this.dw_included=create dw_included
this.dw_purposelist=create dw_purposelist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_exclude
this.Control[iCurrent+2]=this.pb_include
this.Control[iCurrent+3]=this.dw_tasklist
this.Control[iCurrent+4]=this.dw_included
this.Control[iCurrent+5]=this.dw_purposelist
end on

on u_poc_taskconfig.destroy
call super::destroy
destroy(this.pb_exclude)
destroy(this.pb_include)
destroy(this.dw_tasklist)
destroy(this.dw_included)
destroy(this.dw_purposelist)
end on

event constructor;call super::constructor;/* act like a ue_postopen event in a window */
post event ue_postconstructor()

end event

type pb_exclude from picturebutton within u_poc_taskconfig
integer x = 1650
integer y = 960
integer width = 91
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "images\DownArrow.gif"
alignment htextalign = left!
string powertiptext = "Exclude Selected Tasks"
end type

event clicked;long		ll_row
integer	li_confirm
long ll_taskid, ll_found_task

ll_row = dw_included.getselectedrow(0)
if ll_row = 0 then return c#return.noaction
ll_taskid = dw_included.getitemnumber(ll_row, "task_id")
ll_found_task = dw_tasklist.find("task_id = "+string(ll_taskid), 1, dw_tasklist.rowcount())
if ll_found_task > 0 then dw_tasklist.setitem(ll_found_task, "flag", 0)
dw_tasklist.selectrow(0, false)
dw_tasklist.selectrow(ll_found_task, true)
_inv_taskconfig.of_deleterow(_is_INCLUDED, ll_row)
dw_tasklist.sort()
if dw_included.Describe("task_sort.type") <> "!" then	
	for ll_row = 1 to dw_included.rowcount()
		dw_included.setitem( ll_row , "task_sort",ll_row)
	next	
end if
dw_tasklist.scrolltorow(ll_found_task)
dw_tasklist.setrow(1)
_il_lastclickedrowincludes = 0
end event

type pb_include from picturebutton within u_poc_taskconfig
integer x = 1527
integer y = 960
integer width = 91
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "images\UpArrow.gif"
alignment htextalign = left!
string powertiptext = "Include Selected Task(s)"
end type

event clicked;/********************************************************************
   clicked
   <DESC>	Description	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
																First Version		
   	26/09/11  CR2528        TTY004            validation before dragging
   </HISTORY>
********************************************************************/
long ll_row, ll_taskorder, ll_mod_row
long ll_taskid, ll_found_task

ll_row = dw_tasklist.getselectedrow(0)
if ll_row = 0 then return c#return.noaction
if dw_tasklist.getitemnumber(ll_row, "flag") = 1 then return c#return.noaction
if dw_tasklist.getitemstatus(ll_row, "description", primary!) = datamodified! or &
	dw_tasklist.getitemstatus(ll_row, "task_mvv_name", primary!) = datamodified! then 
	messagebox("Task Configuration - Drag prepared", "Task data modified, but not saved. Please update data first.")
	return c#return.noaction
end if 
_inv_taskconfig.of_settask(dw_purposelist.getitemnumber(1,"pc"), dw_tasklist.getitemnumber(ll_row,"task_id"),&
dw_purposelist.getitemstring(dw_purposelist.getselectedrow(0),"purpose_code"),dw_tasklist.getitemstring(ll_row,"description"),&
dw_tasklist.getitemstring(ll_row, "task_mvv_name")) 
if _inv_taskconfig.of_insertrow(_is_INCLUDED) = 0 then return c#return.noaction
dw_tasklist.setitem(ll_row, "flag", 1)
ll_taskid = dw_tasklist.getitemnumber(ll_row, "task_id")
if dw_included.Describe("task_sort.type")<>"!" then	
	if dw_included.rowcount() = 1 then
		ll_taskorder = 1
	else
		ll_taskorder = dw_included.getitemnumber( dw_included.rowcount(), "maxsort") + 1
	end if
	dw_included.setitem( dw_included.rowcount(), "task_sort", ll_taskorder)
end if	
ll_found_task = dw_included.find("task_id = " + string(ll_taskid), 1, dw_included.rowcount())
if ll_found_task > 0 then 
	dw_included.selectrow(0, false)
	dw_included.selectrow(ll_found_task, true)
	dw_included.scrolltorow(ll_found_task)
end if 
dw_included.setrow(1)
_il_lastclickedrowexcludes = 0
end event

type dw_tasklist from mt_u_datawindow within u_poc_taskconfig
event ue_mousemove pbm_dwnmousemove
event ue_lbuttonup pbm_dwnlbuttonup
event ue_rowhighlight ( long al_row )
integer x = 965
integer y = 1048
integer width = 1408
integer height = 908
integer taborder = 10
string dragicon = "images\DRAG.ICO"
boolean vscrollbar = true
boolean border = false
end type

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>Allows user to enter drag mode if mousepointer moves 10px either way and the left mouse button
	is still pressed (controlled by _ib_dragincludes variable)</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> standard powerbuilder datawindow event</ARGS>
   <USAGE>begins the drag and resets the xpos/ypos variables
	</USAGE>
********************************************************************/

//CR2408 Added by ZSW001 on 09-06-2011
if row =0 then return
if not keydown(keyleftbutton!) then return

if _ib_dragexcludes and not(_ib_editmode) then
	if (xpos > _ii_xpos + _ii_range or &
		xpos < _ii_xpos - _ii_range or &
		ypos > _ii_ypos + _ii_range or &
		ypos < _ii_ypos - _ii_range) then
		this.drag(begin!)
		_ii_xpos=0
		_ii_ypos=0
	end if
end if

end event

event ue_lbuttonup;/********************************************************************
   event ue_lbuttonup( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>when user releases left mouse button, handles explorer like actions.
	editing the description and the control behind is included in this event.</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> standard powerbuilder datawindow event</ARGS>
   <USAGE> designed to be used together with following events: clicked(), dragdrop(), ue_mousemove().
	does much of what a normal clicked event would contain.	queued after dragdrop() event if dragging.
	</USAGE>
	06/09/11    CR2528   TTY004    set new column(MVV) taborder status
********************************************************************/
if _ib_readonly then return	
_ib_dragexcludes = false
this.drag(end!)

if _ib_ignorelbuttonup then 
	_ib_ignorelbuttonup=false
	return
end if

if left(this.getbandatpointer( ),6)  = "header" then
	return
end if

if row = 0 then return

if KeyDown ( KeyControl! ) then
	this.settaborder( "description", 0)
	this.settaborder("task_mvv_name", 0)
	if this.GetSelectedRow ( row - 1 ) = row then
		this.SelectRow ( row, false )
	else
		this.SelectRow ( row, true ) 
	end if 
elseif KeyDown ( KeyShift! ) then
	this.settaborder( "description", 0)
	this.settaborder("task_mvv_name", 0)
	 this.Event ue_rowhighlight ( row ) 
else
	
	if row =  _il_lastclickedrowexcludes then 
			this.settaborder( "description", 10)
			this.settaborder("task_mvv_name", 20)
			if lower(dwo.name) = 'description' then
				this.setcolumn('description')
			end if 
			if lower(dwo.name) = 'task_mvv_name' then
				this.setcolumn('task_mvv_name')
				this.selecttext(1, len(this.gettext()) + 1)
			end if 
			_ib_editmode = true
	else
		this.settaborder( "description", 0)
		this.settaborder("task_mvv_name", 0)
		_ib_editmode = false
	end if
	
	this.Selectrow ( 0, false ) 
	this.Selectrow ( row, true ) 
end if
 _il_lastclickedrowexcludes = row 
end event

event ue_rowhighlight(long al_row);/********************************************************************
   event ue_rowhighlight( /*long al_row */)
	
   <DESC>Allows user to enter drag mode if mousepointer moves 10px either way and the left mouse button
	is still pressed (controlled by _ib_dragincludes variable)</DESC>
   <RETURN> basic user event, not mapped to a powerbuilder standard</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> al_row : reference to the current row</ARGS>
   <USAGE>handles the multi-highlighting of rows when user keeps shift button pressed.
	</USAGE>
********************************************************************/
long ll_index

this.setredraw (false ) 
if _il_lastclickedrowexcludes = 0 then
    this.SelectRow ( al_row, true ) 
else    
	if  _il_lastclickedrowexcludes > al_row then
		 for ll_index =  _il_lastclickedrowexcludes to al_row step -1
				this.selectrow ( ll_index, true ) 
		next
	else
		 for ll_index =  _il_lastclickedrowexcludes to al_row
				this.selectrow ( ll_index, true ) 
		next 
	end if
end if
this.setredraw (true) 
end event

event dragdrop;call super::dragdrop;/********************************************************************
   event dragdrop( /*dragobject source*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>queued before lbuttonup() event, when user releases dragdrop</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   standard powerbuilder datawindow event</ARGS>
   <USAGE>  designed to be used together with following events: clicked(), ue_lbuttonup(), ue_mousemove().
	this handles dragged items from dw_included.
	</USAGE>
	06/09/11  CR2528    TTY004    if remove task from includetask then refresh tasklist status
********************************************************************/
mt_u_datawindow ldw_source
long ll_row
integer	li_confirm
long ll_taskid, ll_task_count, ll_found_taskid 

if _ib_readonly then return
ll_task_count = this.rowcount()
if source.typeof() = DataWindow! then
	ldw_source = source
	if ldw_source.is_dsname   = _is_INCLUDED then
		ll_row = ldw_source.getselectedrow(0)
		if ll_row = 0 then return c#return.noaction
		ll_taskid = ldw_source.getitemnumber(ll_row, "task_id")
		_inv_taskconfig.of_deleterow(_is_INCLUDED, ll_row)
		ll_found_taskid = this.find("task_id = " + string(ll_taskid), 1, ll_task_count) 
		if ll_found_taskid > 0 then
		   this.setitem(ll_found_taskid, "flag", 0)
			this.setitemstatus(ll_found_taskid, "flag", primary!, NotModified!)
			this.selectrow(0, false)
			this.selectrow(ll_found_taskid, true)
		end if   
		ll_row --
		this.sort()
		if ldw_source.Describe("task_sort.type") <> "!" then	
			for ll_row = 1 to ldw_source.rowcount()
				ldw_source.setitem( ll_row , "task_sort",ll_row)
			next	
		end if
		_ib_dragincludes = false
		_ii_xpos = 0
		_ii_ypos = 0
		this.setrow(1)
		this.scrolltorow(ll_found_taskid)
		ldw_source.setfocus()
	end if
	_ib_ignorelbuttonup = true
end if

end event

event clicked;call super::clicked;/********************************************************************
   event clicked( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>   handle logic when ctrl/shift are not pressed.  also check if user selected order column and
	initialiate dragging variables</DESC>
   <RETURN> standard powerbuilder event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   standard powerbuilder event</ARGS>
   <USAGE>  designed to be used together with following events: dragdrop(), ue_lbuttonup(), ue_mousemove().</USAGE>
********************************************************************/
if _ib_readonly then return	

if left(this.getbandatpointer( ),6)  = "header" then
	return 1
end if

if row = 0 then 
	_ib_ignorelbuttonup=true
	return 1
else
	if not (keydown(KeyControl! ) or keydown(KeyShift!))  then
			if not isselected(row) then
				this.selectrow ( 0, false ) 
				this.selectrow ( row, true ) 
				this.setrow(row)
				this.settaborder('description', 0)
				this.settaborder('task_mvv_name', 0)
			end if
	end if
	_ii_xpos = xpos
	_ii_ypos = ypos
	_ib_dragexcludes = true
end if
this.setrow(row)
end event

event losefocus;call super::losefocus;_ib_editmode = false
this.accepttext()

end event

event constructor;call super::constructor;/*
this datawindow lists all tasks that are excluded from the current purpose.
the data is controlled by filtering out what is contained in the dw_included datawindow.
special functionality here includes the possibility to add/delete/modify the task.
*/
end event

event getfocus;call super::getfocus;this.border = true
dw_included.border = false

end event

event editchanged;call super::editchanged;/********************************************************************
   editchanged
   <DESC>	Description	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		row
		dwo
		data
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/09/11   2528         TTY004        First Version
   </HISTORY>
********************************************************************/
string ls_null
if row = 0 then return
if dwo.name = "task_mvv_name" then 
	if data ='' then
		setnull(ls_null)
		this.post setitem(row, "task_mvv_name", ls_null)
	else
	   this.setitem(row, "task_mvv_name", upper(data))
	   this.selecttext(len(data) + 1,len(data))
	end if 
end if 
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return 
this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type dw_included from mt_u_datawindow within u_poc_taskconfig
event ue_lbuttonup pbm_dwnlbuttonup
event ue_mousemove pbm_dwnmousemove
event ue_rowhighlight ( long al_row )
integer x = 965
integer y = 24
integer width = 1408
integer height = 928
integer taborder = 20
string dragicon = "images\DRAG.ICO"
boolean vscrollbar = true
boolean border = false
end type

event ue_lbuttonup;/********************************************************************
   event ue_lbuttonup( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>when user releases left mouse button, handles explorer like actions</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> standard powerbuilder datawindow event</ARGS>
   <USAGE> designed to be used together with following events: clicked(), dragdrop(), ue_mousemove().
	does much of what a normal clicked event would contain.	queued after dragdrop() event if dragging.
	</USAGE>
********************************************************************/
if _ib_readonly then return	

_ib_dragincludes = false
this.drag(end!)

if _ib_ignorelbuttonup then
	_ib_ignorelbuttonup = false
	return 
end if

if left(this.getbandatpointer( ),6)  = "header" then
	return
end if

if row=0 then return

if KeyDown ( KeyControl! ) then
	if this.GetSelectedRow ( row - 1 ) = row then
		this.SelectRow ( row, false )
	else
		this.SelectRow ( row, true ) 
	end if 
elseif KeyDown ( KeyShift! ) then
	this.Event ue_rowhighlight ( row ) 
else
	this.Selectrow ( 0, false ) 
	this.Selectrow ( row, true ) 
end if

_il_lastclickedrowincludes = row 




end event

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>Allows user to enter drag mode if mousepointer moves 10px either way and the left mouse button
	is still pressed (controlled by _ib_dragincludes variable)</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> standard powerbuilder datawindow event</ARGS>
   <USAGE>begins the drag and resets the xpos/ypos variables
	</USAGE>
********************************************************************/

if _ib_dragincludes then
	if (xpos > _ii_xpos + _ii_range or &
		xpos < _ii_xpos - _ii_range or &
		ypos > _ii_ypos + _ii_range or &
		ypos < _ii_ypos - _ii_range) then
		this.drag(begin!)
		_ii_xpos=0
		_ii_ypos=0
	end if
end if


end event

event ue_rowhighlight(long al_row);/********************************************************************
   event ue_rowhighlight( /*long al_row */)
	
   <DESC>Allows user to enter drag mode if mousepointer moves 10px either way and the left mouse button
	is still pressed (controlled by _ib_dragincludes variable)</DESC>
   <RETURN> basic user event, not mapped to a powerbuilder standard</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> al_row : reference to the current row</ARGS>
   <USAGE>handles the multi-highlighting of rows when user keeps shift button pressed.
	</USAGE>
********************************************************************/

long ll_index

this.setredraw (false ) 
if _il_lastclickedrowincludes = 0 then
    this.SelectRow ( al_row, true ) 
else    
	if  _il_lastclickedrowincludes > al_row then
		for ll_index =  _il_lastclickedrowincludes to al_row step -1
			this.selectrow ( ll_index, true ) 
		next
	else
		for ll_index =  _il_lastclickedrowincludes to al_row
			this.selectrow ( ll_index, true ) 
		next 
	end if
end if
this.setredraw (true) 
end event

event dragdrop;call super::dragdrop;/********************************************************************
   event dragdrop( /*dragobject source*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>queued before lbuttonup() event, when user releases dragdrop</DESC>
   <RETURN> standard powerbuilder datawindow event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   standard powerbuilder datawindow event</ARGS>
   <USAGE>  designed to be used together with following events: clicked(), ue_lbuttonup(), ue_mousemove().
	this handles not only dragged items from dw_excluded, but also sort order changes within same window.
	</USAGE>
	06/09/11   CR2528   TTY004        refresh the task list status if it was draged into includedtask
********************************************************************/
mt_u_datawindow ldw_source
long ll_taskorder, ll_selectedcount = 0
long ll_rowstart, ll_rowend, ll_row		
long ll_includetask_count, ll_taskid
if _ib_readonly then return	
ll_includetask_count = this.rowcount()
if source.typeof() = DataWindow! then
	ldw_source = source
	/* dragged sort order item  */		
	if ldw_source.is_dsname = this.is_dsname and _ib_dragincludesorder then
		if _il_lastclickedrowincludes <> row and row > 0 then
			ll_rowend = this.getitemnumber(row, "task_sort")
			ll_rowstart = this.getitemnumber(_il_lastclickedrowincludes, "task_sort")
			if ll_rowstart < ll_rowend then
				if _il_lastclickedrowincludes < row then
					_changeorder( _il_lastclickedrowincludes, row, dw_included  , -1 )
				else
					_changeorder( row, _il_lastclickedrowincludes ,dw_included , -1 )
				end if
			else
				if _il_lastclickedrowincludes < row then
					_changeorder( _il_lastclickedrowincludes, row,dw_included , 1 )
				else
					_changeorder( row, _il_lastclickedrowincludes ,dw_included , 1 )
				end if		
			end if
			this.setitem(_il_lastclickedrowincludes,"task_sort",ll_rowend)
			this.sort( )
		end if
		_ib_dragincludesorder = false
		_ib_ignorelbuttonup = true
	elseif ldw_source.is_dsname = this.is_dsname then
		_ib_ignorelbuttonup = true
	elseif ldw_source.is_dsname   = _is_TASKLIST then
		ll_row = dw_tasklist.getselectedrow(0)
		if ll_row = 0 then return c#return.noaction
		if dw_tasklist.getitemstatus(ll_row, "description", primary!) = datamodified! or &
		   dw_tasklist.getitemstatus(ll_row, "task_mvv_name", primary!) = datamodified! then 
			 messagebox("Task Configuration - Drag prepared", "Task data modified, but not saved. Please update data first.")
			return c#return.noaction
		end if
		ll_taskid = ldw_source.getitemnumber(ll_row, "task_id")
		if this.find("task_id = " + string(ll_taskid), 1, ll_includetask_count) > 0 then return c#return.NoAction
		_inv_taskconfig.of_settask(dw_purposelist.getitemnumber(1,"pc"), ldw_source.getitemnumber(ll_row,"task_id"),&
		dw_purposelist.getitemstring(dw_purposelist.getselectedrow(0),"purpose_code"),ldw_source.getitemstring(ll_row,"description"),&
		ldw_source.getitemstring(ll_row, 'task_mvv_name')) 
		if _inv_taskconfig.of_insertrow(_is_INCLUDED) = 0 then return c#return.noaction
		ldw_source.setitem(ll_row, "flag", 1)
		ldw_source.setitemstatus(ll_row, "flag", primary!, notmodified!)	
		if this.Describe("task_sort.type")<>"!" then	
			if this.rowcount() = 1 then
				ll_taskorder = 1
			else
				ll_taskorder = this.getitemnumber( this.rowcount(), "maxsort") + 1
			end if
			this.setitem( this.rowcount()  , "task_sort", ll_taskorder)
		end if				
		_ib_dragexcludes = false
		_ii_xpos = 0
		_ii_ypos = 0
		ll_row = this.find("task_id = "+string(ll_taskid), 1, this.rowcount())
		if ll_row > 0 then 
			this.selectrow(0, false)
			this.selectrow(ll_row, true)
			this.scrolltorow(ll_row)
		end if
		this.setrow(1)
		ldw_source.setfocus()
	end if
end if
end event

event clicked;call super::clicked;/********************************************************************
   event clicked( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
	
   <DESC>   handle logic when ctrl/shift are not pressed.  also check if user selected order column and
	initialiate dragging variables</DESC>
   <RETURN> standard powerbuilder event</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   standard powerbuilder event</ARGS>
   <USAGE>  designed to be used together with following events: dragdrop(), ue_lbuttonup(), ue_mousemove().</USAGE>
********************************************************************/

if _ib_readonly then return	

if left(this.getbandatpointer( ),6)  = "header" then
	return 1
end if
if	row = 0 then 
	_ib_ignorelbuttonup = true
	return 1
else
	if not (KeyDown ( KeyControl! ) or KeyDown ( KeyShift! ))  then
		if not isselected(row) then
			this.Selectrow ( 0, false ) 
			this.Selectrow ( row, true ) 
		end if
	end if
	
	if dwo.name = "task_sort" then
		this.drag(begin!)
		_ib_dragincludesorder = true
		_il_lastclickedrowincludes = row
	else
		_ii_xpos = xpos
		_ii_ypos = ypos
		_ib_dragincludes = true
	end if
end if
this.setrow(row)
end event

event constructor;call super::constructor;/*
this datawindow lists all tasks that are available on the current purpose on the selected
profit center.
the data is controlled within the interface non-visual user object n_poc_tasklist_interface and
has the dw_purposelist as its master.
special functionality here is the possibility for the user to drag and change the column order.
*/
end event

event getfocus;call super::getfocus;//this.borderstyle = StyleLowered!
//dw_tasklist.borderstyle = StyleBox! 
this.border = true
dw_tasklist.border = false

end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type dw_purposelist from mt_u_datawindow within u_poc_taskconfig
integer x = 41
integer y = 24
integer width = 891
integer height = 1936
integer taborder = 30
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;/* force rowfocuschanged event */
if row=0 then this.event rowfocuschanged(1)
this.setrow(row)

end event

event rowfocuschanged;call super::rowfocuschanged;/********************************************************************
  event rowfocuschanged( /*long currentrow */)
   <DESC>   Important event. This forces all data dependent on Purpose to be retreived</DESC>
   <RETURN> </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   standard powerbuilder set </ARGS>
   <USAGE>  trigger anywhere we require an update.  eg. when Profit center is changed</USAGE>
********************************************************************/

integer li_response = 2  //default
long ll_dummy
setnull(ll_dummy)

dw_tasklist.accepttext()

if of_updatespending() = -1 then return 

this.selectrow(0,false)
this.selectrow(currentrow,true)

_inv_taskconfig.of_settask(this.getitemnumber(currentrow,"pc"), ll_dummy, "", "","")
_inv_taskconfig.of_rowfocuschanged( this.is_dsName, currentrow )

dw_tasklist.selectrow( 0, false)
_il_lastclickedrowexcludes=0
dw_tasklist.border = false



end event

event constructor;call super::constructor;/*
this datawindow object is the master of dw_includes.  when the row is changed it triggers
the other datawindows to be refreshed too. the data here itself is a filtered list.  Although purposes
are not set on a profit center level, the data behind acts in this way.  for each profit center the 
purposes are listed along with a counter of how many tasks are set.
*/
end event

