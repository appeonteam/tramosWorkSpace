$PBExportHeader$n_datagrid.sru
$PBExportComments$Used by the u_fileattach object, this object is used as an array to hold blob data for any attachments that have been accessed.
forward
global type n_datagrid from mt_n_nonvisualobject
end type
end forward

global type n_datagrid from mt_n_nonvisualobject autoinstantiate
end type

type variables
private datawindow _idw_requestor
private n_dw_column_definition _inv_columndef[]
private boolean _ib_resizable = false
private boolean _ib_moveable = false
constant integer PROXIMITY_FACTOR = 16
end variables

forward prototypes
public function integer of_setcolumnorder ()
public function integer of_setcolumnresize (string as_column, boolean ab_resizable)
public function integer _registercolumns ()
public function integer of_stop_column_resize (unsignedlong aul_flags, integer ai_xpos, integer ai_ypos)
public function integer of_setallcolumnsresizable (boolean ab_enabled)
public function integer of_registerdatawindow (datawindow adw)
public function integer of_registerdatawindow (datawindow adw, boolean ab_resizable)
public subroutine documentation ()
end prototypes

public function integer of_setcolumnorder ();/********************************************************************
   of_setColumnOrder
   <DESC>   Resets the column positions and widths to the same as when
	_registercolumns( ) was last called.</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  Currently called from the user event ue_lbuttondown()
	if the resize was not allowed.  Should be linked to a different
	event, but we have not decided where yet...</USAGE>
********************************************************************/

/* TODO: where should this be run from???  */


integer li_max, li_loop, li_tab=0
string ls_expression_string

if upperbound(_inv_columndef)<1 then return c#return.NoAction

_idw_requestor.setRedraw(false)

/*
First make all columns invisible...
*/
li_max = upperbound(_inv_columndef)

for li_loop = 1 to li_max
	_idw_requestor.Modify(_inv_columndef[li_loop].is_column_name + ".Visible='0'")
next

/*
Next reset them according to saved array
*/
for li_loop = 1 to li_max
	ls_expression_string = '"' + string(_inv_columndef[li_loop].ii_visible_default) + '~t' + _inv_columndef[li_loop].is_visible_expression + '"'
	_idw_requestor.Modify(_inv_columndef[li_loop].is_column_name + ".Visible=" + ls_expression_string)
	_idw_requestor.Modify(_inv_columndef[li_loop].is_column_name + ".X=" + string(_inv_columndef[li_loop].ii_xpos))
	_idw_requestor.Modify(_inv_columndef[li_loop].is_column_name + ".Width=" + string(_inv_columndef[li_loop].ii_width))
	if Integer(_idw_requestor.Describe(_inv_columndef[li_loop].is_column_name + ".TabSequence")) > 0 THEN
		li_tab += 10
		_idw_requestor.Modify(_inv_columndef[li_loop].is_column_name + ".TabSequence='" + string(li_tab) + "'")
	end if
next
_idw_requestor.setRedraw(true)

return c#return.Success

end function

public function integer of_setcolumnresize (string as_column, boolean ab_resizable);/********************************************************************
   of_setColumnResize( /*string as_column*/, /*boolean ab_resizable */)
   <DESC>   Singularly set a behaviour on a column level</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_column: Column name
            as_resizable: Is column resizable or not</ARGS>
   <USAGE>  
		See main object documentation()
	</USAGE>
********************************************************************/



integer	li_newindex,	li_index

if isnull(_idw_requestor) or not isvalid(_idw_requestor)  then return c#return.Failure

// Check arguments.
if IsNull(as_column) or Len(Trim(as_column))=0 Then 
	return c#return.failure
end if


if upperbound(_inv_columndef)<1 then
	_registercolumns()
	_idw_requestor.Object.DataWindow.Grid.ColumnMove = "no"
	_idw_requestor.Modify("DataWindow.Selected.Mouse=No")
end if


as_column = Lower(Trim(as_column))
li_newindex = UpperBound(_inv_columndef) + 1

For li_index = 1 to li_newindex - 1
	If _inv_columndef[li_index].is_column_name = as_column Then
		_inv_columndef[li_index].ib_resizable = ab_resizable
		Return c#return.Success
	End If	
Next

Return c#return.NoAction
end function

public function integer _registercolumns ();/********************************************************************
   _registercolumns( )
   <DESC>   Loads all visible columns and their properties into object array</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  Used only in this object.  builds column structure</USAGE>
********************************************************************/

integer li_loop, li_max, li_columns
string ls_column_name, ls_exp, ls_visible_exp, ls_eval, ls_syntax
long ll_pos, ll_pos1, ll_pos2, ll_count
long ll_width, ll_xpos, ll_visible_default
boolean lb_swapped
n_dw_column_definition lnv_dummy[]

	if isnull(_idw_requestor) or not isvalid(_idw_requestor)  then return c#return.Failure

	ls_syntax = _idw_requestor.object.datawindow.syntax
	
	li_max = Integer(_idw_requestor.Object.DataWindow.Column.Count)
	li_columns = 0
	
	for li_loop = 1 to li_max 
		ls_visible_exp = _idw_requestor.Describe("#" + String(li_loop) + ".Visible")
		ls_exp = Right(ls_visible_exp, Len(ls_visible_exp) - Pos(ls_visible_exp, "~t"))
		if isnumber(ls_visible_exp) then 
			ll_visible_default=integer(ls_visible_exp) 
		else
			ll_visible_default=integer(mid(ls_visible_exp,2,1))
		end if
		if ll_visible_default=1 or ls_exp<>ls_visible_exp then
			ls_column_name = _idw_requestor.Describe("#" + String(li_loop) + ".Name")
			if ls_column_name = '' then CONTINUE
			ll_count = upperbound(_inv_columndef) + 1
			_inv_columndef[ll_count].is_column_name = ls_column_name
			_inv_columndef[ll_count].ii_width = Integer(_idw_requestor.Describe(ls_column_name + ".Width"))
			_inv_columndef[ll_count].ii_xpos = Integer(_idw_requestor.Describe(ls_column_name + ".X"))
			_inv_columndef[ll_count].ii_visible_default = ll_visible_default
			_inv_columndef[ll_count].is_visible_expression = ls_exp
			_inv_columndef[ll_count].ib_resizable = _ib_resizable
		end if	
	next
	
	/*
	visible computed columns
	*/
	ll_pos = 1
	do while ll_pos > 0
		ll_pos = Pos(ls_syntax, "compute(",ll_pos)
		if ll_pos > 0 then
			ll_pos1 = Pos(ls_syntax, "name=", ll_pos +1)
			if ll_pos1 > 1 then
				ll_pos2 = Pos(ls_syntax, " ", ll_pos1)
				ls_column_name = Mid(ls_syntax, ll_pos1+5,(ll_pos2 - ll_pos1 -5))
				ls_visible_exp = _idw_requestor.Describe(ls_column_name + ".Visible")
				ls_exp = Right(ls_visible_exp, Len(ls_visible_exp) - Pos(ls_visible_exp, "~t"))
				if isnumber(ls_visible_exp) then 
					ll_visible_default=integer(ls_visible_exp) 
				else
					ll_visible_default=integer(mid(ls_visible_exp,2,1))
				end if
				if ll_visible_default=1 then
					ll_count = upperbound(_inv_columndef)+1
					_inv_columndef[ll_count].is_column_name = Mid(ls_syntax, ll_pos1+5,(ll_pos2 - ll_pos1 -5))
					_inv_columndef[ll_count].ii_width = Integer(_idw_requestor.Describe(ls_column_name + ".Width"))
					_inv_columndef[ll_count].ii_xpos = Integer(_idw_requestor.Describe(ls_column_name + ".X"))
					_inv_columndef[ll_count].ii_visible_default = ll_visible_default
					_inv_columndef[ll_count].is_visible_expression = ls_exp
					_inv_columndef[ll_count].ib_resizable = _ib_resizable
				end if	
				ll_pos = ll_pos2
			end if
		end if
	loop
	
	/*
	bubble sort array in ascending order
	*/
	li_max = upperbound(_inv_columndef) - 1
	do 
		lb_swapped = false
		for li_loop = 1 to li_max
			 if _inv_columndef[li_loop].ii_xpos > _inv_columndef[li_loop + 1].ii_xpos then
				/* 
				copy row li_loop to temp array, copy row li_loop + 1 to li_loop then copy saved row to li_loop + 1
				*/
				lnv_dummy[1] = _inv_columndef[li_loop]
				_inv_columndef[li_loop] = _inv_columndef[li_loop+1]			
				_inv_columndef[li_loop+1] = lnv_dummy[1]
				lb_swapped = true
			 end if
		next
		li_max --
	loop until not(lb_swapped)

return c#return.Success

end function

public function integer of_stop_column_resize (unsignedlong aul_flags, integer ai_xpos, integer ai_ypos);/********************************************************************
   of_column_resize()

   <DESC>   When datawindow is a GRID, this function tests all columns
	against the position of current x ypos.  if column registered as a
	non resizable column stop user from resizing.</DESC>
	
	<RETURN> Integer:
            <LI> 1, X success
				<LI> 0, X no action
            <LI> -1, X failed
				</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   aul_flags: not used here
				ai_xpos: current xpos of mouse pointer
            ai_ypos: current ypos of mouse pointer</ARGS>
   <USAGE>  See object main description.</USAGE>
********************************************************************/

if isnull(_idw_requestor) or not isvalid(_idw_requestor)  then return c#return.Failure

/* operate only on grids */
if _idw_requestor.Describe("DataWindow.Processing") <> "1" then return c#return.NoAction

integer li_index, li_max_index, li_width, li_xpos
boolean lb_near
string ls_obj

ls_obj = _idw_requestor.getbandatpointer( )
if pos(ls_obj, "header", 1) <> 1 then return c#return.NoAction
if _ib_resizable=false then return c#return.Success

li_max_index = UpperBound(_inv_columndef) 

if li_max_index < 1 then return c#return.NoAction

for li_index = 1 to li_max_index
	if _inv_columndef[li_index].ib_resizable = false then
		lb_near = false
		li_xpos = Integer(_idw_requestor.Describe(_inv_columndef[li_index].is_column_name + ".x"))
		li_width = Integer(_idw_requestor.Describe(_inv_columndef[li_index].is_column_name + ".width"))
		lb_near = (ai_xpos > li_xpos + li_width - PROXIMITY_FACTOR and ai_xpos <= li_xpos + li_width)
		if not lb_near then lb_near = (ai_xpos >= li_xpos + li_width and ai_xpos < li_xpos + li_width + PROXIMITY_FACTOR)
		if lb_near then return c#return.Success
	end if
next



return c#return.NoAction

end function

public function integer of_setallcolumnsresizable (boolean ab_enabled);_ib_resizable = ab_enabled

return c#return.Success
end function

public function integer of_registerdatawindow (datawindow adw);/********************************************************************
   of_registerdatawindow( /*datawindow adw */)
   <DESC>   Loads the subject datawindow into an instance variable</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: subject datawindow
	</ARGS>
   <USAGE>  After this object is created call this to setup the datawindow
	we need to work against.</USAGE>
********************************************************************/

return of_registerdatawindow( adw, false)
end function

public function integer of_registerdatawindow (datawindow adw, boolean ab_resizable);/********************************************************************
   of_registerdatawindow( /*datawindow adw */, /*ad_resizable*/)
   <DESC>   Loads the subject datawindow into an instance variable</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: subject datawindow
				ab_resizable: here we can set the option if the whole datawindow
				disallows resizing of the columns or not
	</ARGS>
   <USAGE>  After this object is created call this to setup the datawindow
	we need to work against.</USAGE>
********************************************************************/

if isnull(adw) or not isvalid(adw) then return c#return.NoAction

_ib_resizable = ab_resizable

_idw_requestor = adw
if _ib_resizable then _registercolumns()
_idw_requestor.Object.DataWindow.Grid.ColumnMove = "no"
_idw_requestor.Modify("DataWindow.Selected.Mouse=No")

return c#return.Success
end function

public subroutine documentation ();/*

/********************************************************************
   ObjectName: datagrid helper functions
   <OBJECT> Supporting functions for controlling the datawindow that
	has grid formatting</OBJECT>
   <DESC>   </DESC>
   <USAGE>  It is to be used when it is not possible to 
	inherit from u_datagrid > mt_u_datawindow. </USAGE>
   <ALSO>   Uses object n_dw_column definition in array.
	Similar to visual object u_datagrid.</ALSO>
    Date   Ref    Author        Comments
  27/07/10 AGL027      AGL027     First Version
********************************************************************/


This is the nonvisualobject version of the visual user object datagrid.

Objects ancestor is mt_u_datawindow.  

It is to be used when the datawindow is a grid.  It contains functions and events
that aid processing the datagrid.  It provides facility to lock columns so they are
not movaeable and also stop resiazing columns on the whole datawindow or on a column level.

Usage
=====
when using an existing dw container initialise this object.

if you want to allow resize on all columns just call the following method

-   dw_1.of_setAllColumnsResizable(true)

If you want to lock a single column call this method too

-   dw_1.of_setColumnResize("column1", false)

NB: There maybe a chance that a lot of the code is redundant here.  If we decide that a 
datawindow grid has only 2 states [locked] or [unlocked].  Right now it may be set at a 
column level.

Functions
=========
of_registerdatawindow() - always required.  as well as sending the datawindow, it also
	is possible to apply the flag to control the resizable columns : of_setAllColumnsResizable()
_registercolumns() - only called if of_setColumnOrder() or of_setColumnResize()
	are called.  Checks all visible columns and computed fields and constructs detail in the 
	object array n_dw_columnDefinition.
of_setAllColumnsResizable() - disable resizing for all columns
of_setColumnOrder() - currently only called from the ue_lbuttondown event when a 
	column header is clicked and the column has been set to non resizable.
of_setColumnResize() - On a single column level, lock the resizable functionality
of_stopColumnResize() - Called from the ue_lbuttondown event, tests if the column is
	resizable or not.  returns true if the resizability is to be locked.

Events
======
ue_lbuttondown - left mouse button down:calls the function to test the column


Limitations
===========
Images are tough to keep track on.  It would be good when columns are moved or resized that
the images moved accordingly.  this implementation works well as long as any columns to the left
side of an image are fixed. 

If the user clicks on a header that is a locked column where other columns have been resized/moved
the event resets the datawindow to its original order.  Not sure exactly where this event should occur.


Improvements
============
If the user wants to disable all resizing, no need to build the object column array.

*/
end subroutine

on n_datagrid.create
call super::create
end on

on n_datagrid.destroy
call super::destroy
end on

