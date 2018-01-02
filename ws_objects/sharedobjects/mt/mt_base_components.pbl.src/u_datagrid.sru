$PBExportHeader$u_datagrid.sru
forward
global type u_datagrid from mt_u_datawindow
end type
end forward

global type u_datagrid from mt_u_datawindow
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_dwnlbuttonup
event ue_rowhighlight ( long al_row )
event ue_clicked ( integer xpos,  integer ypos,  long row,  dwobject dwo )
event ue_hscroll pbm_hscroll
end type
global u_datagrid u_datagrid

type variables
private n_dw_column_definition _inv_columndef[]
private boolean _ib_ignoreredraw = false
private boolean _ib_resizable = false
private boolean _ib_moveable = false
private boolean _ib_ignorelbuttonup = false
private boolean _ib_editmode = false
private integer _ii_editmode = 0
private long  _il_lastclickedrow = 0
boolean ib_enablesortindex=false
private long _il_movedsortindexrow = 0
boolean ib_multiselect = false
constant integer PROXIMITY_FACTOR = 16

boolean ib_multirow = false
n_dw_filter_multirow	inv_filter_multirow

end variables

forward prototypes
public function integer of_setcolumnorder ()
public function integer of_setcolumnresize (string as_column, boolean ab_resizable)
public function integer of_setallcolumnsresizable (boolean ab_enabled)
public subroutine documentation ()
public function integer of_setallcolumnsmoveable (boolean ib_moveable)
public function integer of_stopcolumnresize (unsignedlong aul_flags, integer ai_xpos, integer ai_ypos)
private function integer _registercolumns ()
public function integer of_seteditmode (string as_columnname, integer ai_taborder)
public function integer of_setignorebuttonup (boolean ab_ignore)
public function integer of_geteditmode ()
private function integer _changeorder (integer ai_moved_row, integer ai_row, integer ai_number)
public function integer of_ignoreredraw (boolean ab_ignore)
private function integer _setredraw (boolean ab_enabled)
public function integer of_getnumberofselectedrows ()
public function long of_getlastclickedrow ()
public function integer of_setlastclickedrow (long al_activerow)
end prototypes

event ue_lbuttondown;integer li_returned

li_returned = of_stopColumnResize(flags, xpos, ypos)

if li_returned = c#return.Success then of_setColumnOrder()
if li_returned = c#return.Success or li_returned = c#return.Failure then
	message.processed = true
	return 1
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
********************************************************************/

if ib_multiselect then
	_ii_editmode = 0
	if _ib_ignorelbuttonup then 
		_ib_ignorelbuttonup=false
		_ii_editmode = 4
		return
	end if
	if left(this.getbandatpointer( ),6)  = "header" then
		return
	end if
	if row = 0 then return
	if KeyDown ( KeyControl! ) then
		if this.GetSelectedRow ( row - 1 ) = row then
			this.SelectRow ( row, false )
		else
			this.SelectRow ( row, true ) 
		end if 
	elseif KeyDown ( KeyShift! ) then
		this.Event ue_rowhighlight ( row ) 
	else
		if row =  _il_lastclickedrow then 
			_ii_editmode = 2
		else
			_ii_editmode = 1
		end if
		this.Selectrow ( 0, false ) 
		this.Selectrow ( row, true ) 
	end if
	 _il_lastclickedrow = row 
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

_setredraw(false)
if _il_lastclickedrow = 0 then
    this.SelectRow ( al_row, true ) 
else    
	if  _il_lastclickedrow > al_row then
		for ll_index =  _il_lastclickedrow to al_row step -1
			this.selectrow ( ll_index, true ) 
		next
	else
		for ll_index =  _il_lastclickedrow to al_row
			this.selectrow ( ll_index, true ) 
		next 
	end if
end if
_setredraw(true) 
end event

event ue_clicked(integer xpos, integer ypos, long row, dwobject dwo);/* this userevent is when we want to maintain the 
additional functaionality in column size locking and the sort index */
end event

event ue_hscroll;/*This event is when we want to stop using the horizontal scroll*/
end event

public function integer of_setcolumnorder ();/********************************************************************
   of_setColumnOrder
   <DESC>   Resets the column positions and widths to the same as when
	_registercolumns( ) was last called.</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  Currently called privately from the user event ue_lbuttondown()
	if the resize was not allowed.  Should be linked to a different
	event, but we have not decided where yet...</USAGE>
********************************************************************/

/* TODO: where should this be run from???  */


integer li_max, li_loop, li_tab=0
string ls_expression_string

/* operate only on grids */
if this.Describe("DataWindow.Processing") <> "1" then return c#return.NoAction
if _ib_resizable = false then return c#return.NoAction
if upperbound(_inv_columndef)<1 then _registercolumns()

_setredraw(false)

/*
First make all columns invisible...
*/
li_max = upperbound(_inv_columndef)

for li_loop = 1 to li_max
	this.Modify(_inv_columndef[li_loop].is_column_name + ".Visible='0'")
next

/*
Next reset them according to saved array
*/
for li_loop = 1 to li_max
	ls_expression_string = '"' + string(_inv_columndef[li_loop].ii_visible_default) + '~t' + _inv_columndef[li_loop].is_visible_expression + '"'
	this.Modify(_inv_columndef[li_loop].is_column_name + ".Visible=" + ls_expression_string)
	this.Modify(_inv_columndef[li_loop].is_column_name + ".X=" + string(_inv_columndef[li_loop].ii_xpos))
	this.Modify(_inv_columndef[li_loop].is_column_name + ".Width=" + string(_inv_columndef[li_loop].ii_width))
	if Integer(this.Describe(_inv_columndef[li_loop].is_column_name + ".TabSequence")) > 0 THEN
		li_tab += 10
		this.Modify(_inv_columndef[li_loop].is_column_name + ".TabSequence='" + string(li_tab) + "'")
	end if
next
_setredraw(true)

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

/* operate only on grids */
if this.Describe("DataWindow.Processing") <> "1" then return c#return.NoAction

integer	li_newindex,	li_index

// Check arguments.
if IsNull(as_column) or Len(Trim(as_column))=0 then 
	return c#return.Failure
end if

if upperbound(_inv_columndef) <1 then _registercolumns()

as_column = Lower(Trim(as_column))
li_newindex = UpperBound(_inv_columndef) + 1

for li_index = 1 to li_newindex - 1
	if _inv_columndef[li_index].is_column_name = as_column then
		_inv_columndef[li_index].ib_resizable = ab_resizable
		return c#return.Success
	end If	
next

return c#return.NoAction
end function

public function integer of_setallcolumnsresizable (boolean ab_enabled);_ib_resizable = ab_enabled

return c#return.Success
end function

public subroutine documentation ();/*

/********************************************************************
   ObjectName: datagrid datawindow container
   <OBJECT> Helpful supporting functions for controlling the datawindow that
	has grid formatting</OBJECT>
   <DESC>   </DESC>
   <USAGE>  To be used on new datawindows</USAGE>
   <ALSO>   Uses object n_dw_column definition in array.
	Similar to non visual object n_datagrid.</ALSO>
    Date   Ref    Author        Comments
  27/07/10 	   	AGL	     	First Version
  01/12/10 	    	AGL	   		Added multiselect functionality 	
  11/05/11		   AGL			Allow ancestor's sort functionality to work
  26/08/11		   LHC			Added multirow filter functionality
  07/10/11		   AGL			New function to get selected rows
  24/11/11		   AGL			Added facility to ignore internal setredraw calls
  02/02/13		   WWA048		Added function to allow fuzzy input
  12/07/13		   LHC010		Added event ue_hscroll
  23/10/13 CR2877 ZSW001      Move functions uf_redraw_on() and uf_redraw_off() to mt_u_datawindow
  03/09/14 CR2420 LHG008      For dragdrop event check if column 'mt_sortorder' existence.
********************************************************************/


This is the visual user object version of the datagrid datawindow container.

When it is not possible to inherit from this object, used n_datagrid instead.

Objects ancestor is mt_u_datawindow.  

It is to be used when the datawindow is a grid.  It contains functions and events
that aid processing the datagrid.  It provides facility to lock columns so they are
not movaeable and also stop resiazing columns on the whole datawindow or on a column level.

Usage
=====
when placing visual dw container on window/object inherit this userobject.
if you want to allow resize on all columns just call the following method

-   dw_1.of_setAllColumnsResizable(true)

If you want to lock a single column call this method too

-   dw_1.of_setColumnResize("column1", false)

NB: There maybe a chance that a lot of the code is redundant here.  If we decide that a 
datawindow grid has only 2 states [locked] or [unlocked].  Right now it may be set at a 
column level.

Functions
=========
_registercolumns() 
	Only called if:
		1. of_setColumnOrder() or of_setColumnResize() are called.  
		2. if resize is not enabled and sorting is enabled on the ancestor mt_u_datawindow 

Checks all visible columns and computed fields and constructs detail in the 
object array n_dw_columnDefinition.
of_setAllColumnsResizable() - enable resizing for all columns
of_setColumnOrder() - currently only called from the ue_lbuttondown event when a 
column header is clicked and the column has been set to non resizable.  Only run if
array of columns exist
of_setColumnResize() - On a single column level, lock the resizable functionality
of_stopColumnResize() - Called from the ue_lbuttondown event, tests at a datawindow level as well
as a column level if it is resizable or not.  returns true if the resizability is to be locked.

Events
======
ue_lbuttondown - left mouse button down:calls the function to test the datawindow/column
ue_clicked - to be used in the descendent if event clicked() requires code.  Using this then doesn't
overwrite this ancestors click event.
*/
end subroutine

public function integer of_setallcolumnsmoveable (boolean ib_moveable);/* operate only on grids */
if this.Describe("DataWindow.Processing") <> "1" then return c#return.NoAction

this.Modify("DataWindow.Selected.Mouse=No")

if ib_moveable then
	this.Object.DataWindow.Grid.ColumnMove = "yes"
else
	this.Object.DataWindow.Grid.ColumnMove = "no"
end if
return c#return.Success
end function

public function integer of_stopcolumnresize (unsignedlong aul_flags, integer ai_xpos, integer ai_ypos);/********************************************************************
   of_stopColumnResize( /*unsignedlong aul_flags*/, /*integer ai_xpos*/, /*integer ai_ypos */)

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

/* operate only on grids */
if this.Describe("DataWindow.Processing") <> "1" then return c#return.NoAction

integer li_index, li_max_index, li_width, li_xpos
boolean lb_near
string ls_obj

ls_obj = this.getbandatpointer( )
if pos(ls_obj, "header", 1) <> 1 then return c#return.NoAction

if _ib_resizable=false then  
	/* property from ancestor.  Only register columns if sorting is defined*/
	if ib_columntitlesort then 
		_registercolumns()
	else
		return c#return.Success
	end if
end if

li_max_index = UpperBound(_inv_columndef) 
if li_max_index < 1 then return c#return.NoAction

for li_index = 1 to li_max_index
	if _inv_columndef[li_index].ib_resizable = false then
		lb_near = false
		li_xpos = Integer(this.Describe(_inv_columndef[li_index].is_column_name + ".x"))
		li_width = Integer(this.Describe(_inv_columndef[li_index].is_column_name + ".width"))
		lb_near = (ai_xpos > li_xpos + li_width - PROXIMITY_FACTOR and ai_xpos <= li_xpos + li_width)
		if not lb_near then lb_near = (ai_xpos >= li_xpos + li_width and ai_xpos < li_xpos + li_width + PROXIMITY_FACTOR)
		if lb_near then return c#return.Success
	end if
next

return c#return.NoAction

end function

private function integer _registercolumns ();/********************************************************************
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

	ls_syntax = this.object.datawindow.syntax
	li_max = Integer(this.Object.DataWindow.Column.Count)
	li_columns = 0
	
	for li_loop = 1 to li_max 
		ls_visible_exp = this.Describe("#" + String(li_loop) + ".Visible")
		ls_exp = Right(ls_visible_exp, Len(ls_visible_exp) - Pos(ls_visible_exp, "~t"))
		if isnumber(ls_visible_exp) then 
			ll_visible_default=integer(ls_visible_exp) 
		else
			ll_visible_default=integer(mid(ls_visible_exp,2,1))
		end if
		if ll_visible_default=1 or ls_exp<>ls_visible_exp then
			ls_column_name = this.Describe("#" + String(li_loop) + ".Name")
			if ls_column_name = '' then CONTINUE
			ll_count = upperbound(_inv_columndef) + 1
			_inv_columndef[ll_count].is_column_name = ls_column_name
			_inv_columndef[ll_count].ii_width = Integer(this.Describe(ls_column_name + ".Width"))
			_inv_columndef[ll_count].ii_xpos = Integer(this.Describe(ls_column_name + ".X"))
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
				ls_visible_exp = this.Describe(ls_column_name + ".Visible")
				ls_exp = Right(ls_visible_exp, Len(ls_visible_exp) - Pos(ls_visible_exp, "~t"))
				if isnumber(ls_visible_exp) then 
					ll_visible_default=integer(ls_visible_exp) 
				else
					ll_visible_default=integer(mid(ls_visible_exp,2,1))
				end if
				if ll_visible_default=1 then
					ll_count = upperbound(_inv_columndef)+1
					_inv_columndef[ll_count].is_column_name = Mid(ls_syntax, ll_pos1+5,(ll_pos2 - ll_pos1 -5))
					_inv_columndef[ll_count].ii_width = Integer(this.Describe(ls_column_name + ".Width"))
					_inv_columndef[ll_count].ii_xpos = Integer(this.Describe(ls_column_name + ".X"))
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

public function integer of_seteditmode (string as_columnname, integer ai_taborder);if _ii_editmode=2  then
	settaborder( as_columnname, ai_taborder)
elseif _ii_editmode = 4 then
	_ii_editmode = 2
	settaborder( as_columnname, 0)
else
	settaborder( as_columnname, 0)
end if
return c#return.Success
end function

public function integer of_setignorebuttonup (boolean ab_ignore);_ib_ignorelbuttonup = ab_ignore
return c#return.Success
end function

public function integer of_geteditmode ();//return _ib_editmode
return _ii_editmode
end function

private function integer _changeorder (integer ai_moved_row, integer ai_row, integer ai_number);/********************************************************************
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
	this.setitem(li_row,"mt_sortorder",this.getitemnumber(li_row, "mt_sortorder") + ai_number)
next

return 1
end function

public function integer of_ignoreredraw (boolean ab_ignore);/********************************************************************
of_ignoreredraw()

<DESC>   
	Allow the control of the redraw to be made in the calling process instead of inside here
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ab_ignore: 	So when a redraw is requested through the supporting function _setredraw() it will
					test to see if it is requested.  When false it will process the redraw, when  True 
					it will ignore the request.
</ARGS>
<USAGE>
	Set before calling either ue_rowheight() or of_setcolumnorder() and when the datawindow container
	is already blocked (this.setredraw(false))
</USAGE>
********************************************************************/
_ib_ignoreredraw = ab_ignore
return c#return.Success
end function

private function integer _setredraw (boolean ab_enabled);/********************************************************************
_setredraw()

<DESC>   
	Used internally & called from ue_rowheight() or of_setcolumnorder().  Basically ignores setredraw
	command if container has disabled it elsewhere.
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> 0, NoAction
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	ab_enabled: 	Requested setredraw action.  False - turns off redraw, true enables it.
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

if _ib_ignoreredraw then
	return c#return.NoAction
else
	this.setredraw(ab_enabled)
end if
return c#return.Success
end function

public function integer of_getnumberofselectedrows ();long ll_row, ll_rowcount, ll_selected

ll_rowcount = this.rowcount( )

if ll_rowcount = 0 then return c#return.NoAction
for ll_row = 1 to ll_rowcount
	if this.isselected(ll_row) then
		ll_selected++
	end if	
next
return ll_selected
end function

public function long of_getlastclickedrow ();return _il_lastclickedrow
end function

public function integer of_setlastclickedrow (long al_activerow);_il_lastclickedrow = al_activerow
return c#return.Success
end function

on u_datagrid.create
call super::create
end on

on u_datagrid.destroy
call super::destroy
end on

event constructor;call super::constructor;this.SetTransObject(SQLCA)
if ib_enablesortindex and ib_columntitlesort then
	ib_enablesortindex=false
end if

if ib_multirow then
	inv_filter_multirow = create n_dw_filter_multirow
end if



end event

event clicked;call super::clicked;/********************************************************************
   event u_datagrid.clicked()
<DESC>   
	Control for the multi row selection and the sortindex functionality
</DESC>
<RETURN>
	Long standard return variable for windows event handler
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	xpos: standard dw click event parameter
	ypos: standard dw click event parameter
	row: standard dw click event parameter
	dwo: standard dw click event parameter
</ARGS>
<USAGE>
	This function works through multi row selection and sort index things.
	For these to be maintained in the decendent object use the userevent
	ue_clicked() called from here instead of the standard click() event. 
</USAGE>
********************************************************************/
if ib_multiselect then
	//_ib_editmode = false
	// _ii_editmode = 0
	if row = 0 then 
		_ib_ignorelbuttonup=true
		return 1
	else
		if not (keydown(KeyControl! ) or keydown(KeyShift!))  then
			if not isselected(row) then
				this.selectrow ( 0, false ) 
				this.selectrow ( row, true ) 
				this.setrow(row)
				//_ib_editmode = true
				_ii_editmode = 1
				//of_seteditmode( "description", 10)
			end if
		end if
	end if
end if

/*
Fix an issue by CKT012: when dwo is not valid object, there will be an error. 
For example: clicked event is called in u_jump_poc, u_jump_claims...
*/
try
	if ib_enablesortindex then
		if (dwo.name = "mt_sortorder") then
			_il_movedsortindexrow = row
			this.drag(begin!)
		end if
	end if
catch(Throwable type1)
end try

//do filter
if ib_multirow and isvalid(inv_filter_multirow) then
	if row > 0 then
		this.selectrow( row, not this.isselected(row))
		inv_filter_multirow.of_dofilter( )
	end if
end if

/* push the userevent */
post event ue_clicked( xpos, ypos, row, dwo )
end event

event dragdrop;call super::dragdrop;long 		ll_rowstart, ll_rowend			

if this.describe("mt_sortorder.type") <> '!' then
	if _il_movedsortindexrow <> row and row <> 0 then
		ll_rowend = this.getitemnumber(row, "mt_sortorder")
		ll_rowstart = this.getitemnumber(_il_movedsortindexrow, "mt_sortorder")
		if ll_rowstart < ll_rowend then
			if _il_movedsortindexrow < row then
				_changeorder( _il_movedsortindexrow, row, -1 )
			else
				_changeorder( row, _il_movedsortindexrow, -1 )
			end if
		else
			if _il_movedsortindexrow < row then
				_changeorder( _il_movedsortindexrow, row, 1 )
			else
				_changeorder( row, _il_movedsortindexrow, 1 )
			end if		
		end if
		this.setitem(_il_movedsortindexrow,"mt_sortorder",ll_rowend)
		this.sort( )
	end if
end if
end event

