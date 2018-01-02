$PBExportHeader$u_dw_multiselect_dragdrop.sru
$PBExportComments$Multiselection DW with drag-and-drop
forward
global type u_dw_multiselect_dragdrop from uo_datawindow_multiselect
end type
end forward

global type u_dw_multiselect_dragdrop from uo_datawindow_multiselect
string DragIcon="images\DRAG.ICO"
string Icon="images\DRAG.ICO"
event mousedown pbm_lbuttondown
event mouseup pbm_lbuttonup
event mousemove pbm_mousemove
end type
global u_dw_multiselect_dragdrop u_dw_multiselect_dragdrop

type variables
Private Boolean ib_mousedown,  ib_allowmove
Boolean ib_dragging
Private Integer ii_mouse_x, ii_mouse_y

end variables

forward prototypes
public function long uf_get_row ()
end prototypes

on mousedown;call uo_datawindow_multiselect::mousedown;// Check if this row is selected
Long ll_row 
ll_row = uf_get_row()

ib_allowmove = true
ii_mouse_x = PointerX()
ii_mouse_y = PointerY()

If This.IsSelected(ll_row) Then
	// This row is allready selected, dont do anything yet

	ib_mousedown = true
	Message.Processed = True
End if


end on

on mouseup;call uo_datawindow_multiselect::mouseup;// Check if this row is selected
Long ll_row

If (ib_mousedown) and  (Not ib_dragging)  Then
	// Mouse was actually down, simulate a clicked event 

	If  ib_multiallowed Then
		ll_row = uf_get_row()
		If ll_row > 0 Then uf_processrow(ll_row)
	End if

	Message.Processed = True
End if

if ib_dragging Then
	This.Drag(Cancel!)
	ib_dragging = false
End if

ib_mousedown = false
ib_allowmove = false

end on

on mousemove;call uo_datawindow_multiselect::mousemove;Integer li_diff_x, li_diff_y

If ib_allowmove Then
	// Check to see whether mouse is moved to much for click

	li_diff_x = PointerX() - ii_mouse_x
	li_diff_y = PointerY() - ii_mouse_y 	

	If (li_diff_x > 20) Or (li_diff_x < -20) Or (li_diff_y > 20) Or (li_diff_y < -20) Then
		// This is a drag boy

		this.Drag(Begin!)
		ib_dragging = true
	End if
End if


end on

public function long uf_get_row ();String ls_tmp
Long ll_tmp, ll_result

ls_tmp = This.GetObjectAtPointer()
ll_tmp = Pos(ls_tmp,"~t")

If (ll_tmp > 0) Then ll_result = integer(Right(ls_tmp, Len(ls_tmp) - ll_tmp ))

Return(ll_result)

end function

on constructor;call uo_datawindow_multiselect::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_dw_multiselect_dragdrop
  
 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : MIS + PBT
   
 Date       : 8-10-96

 Description : Multiselection w/ drag and drop - Filemanager go home !

 Arguments : None

 Returns   : None

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
8-10-96		3.0			MI+PBT	Yeah right  
************************************************************************************/

end on

