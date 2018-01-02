$PBExportHeader$u_ntchire_grid_dw.sru
$PBExportComments$Datawindow Control ancestor
forward
global type u_ntchire_grid_dw from u_datagrid
end type
end forward

global type u_ntchire_grid_dw from u_datagrid
integer width = 411
integer height = 432
event type long ue_retrieve ( )
event ue_keydown pbm_dwnkey
event ue_insertrow ( )
event ue_deleterow ( )
event ue_update ( )
event ue_retrieve_vessel ( integer ai_vessel )
end type
global u_ntchire_grid_dw u_ntchire_grid_dw

type variables

end variables

forward prototypes
public function integer of_getparentwindow (ref window aw_parent)
public subroutine documentation ()
end prototypes

public function integer of_getparentwindow (ref window aw_parent);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_GetParentWindow
//	Arguments:		aw_parent   The Parent window for this object (passed by reference).
//	   								If a parent window is not found, aw_parent is NULL
//	Returns:			Integer - 1 if it succeeds and -1 if an error occurs
//	Description:	Calculates the parent window of a window object
//////////////////////////////////////////////////////////////////////////////
powerobject	lpo_parent

lpo_parent = this.GetParent()

// Loop getting the parent of the object until it is of type window!
do while IsValid (lpo_parent) 
	if lpo_parent.TypeOf() <> window! then
		lpo_parent = lpo_parent.GetParent()
	else
		exit
	end if
loop

if IsNull(lpo_parent) or not IsValid (lpo_parent) then
	setnull(aw_parent)	
	return -1
end if

aw_parent = lpo_parent

return 1
end function

public subroutine documentation ();/********************************************************************
   u_ntchire_dw
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-08-2011 ?            LHC010        		Change the inheritance from the datawindow to u_datagrid 
   </HISTORY>
********************************************************************/

end subroutine

on u_ntchire_grid_dw.create
call super::create
end on

on u_ntchire_grid_dw.destroy
call super::destroy
end on

event getfocus;//////////////////////////////////////////////////////////////////////////////
//	Event:  			getfocus
//	Arguments:		None
//	Returns:  		None
//	Description:	Notify the parent window that this control got focus.
//////////////////////////////////////////////////////////////////////////////
window 	lw_parent

of_GetParentWindow(lw_parent)
if IsValid(lw_parent) then
	// Dynamic call to the parent window.
	lw_parent.dynamic event ue_dwGotFocus (this)
end if
end event

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

