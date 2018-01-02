$PBExportHeader$u_datawindow_dragdrop.sru
$PBExportComments$Base datawindow with drag-and-drop capabilities
forward
global type u_datawindow_dragdrop from u_datawindow_sqlca
end type
end forward

global type u_datawindow_dragdrop from u_datawindow_sqlca
event mousedown pbm_lbuttondown
event mouseup pbm_lbuttonup
event mousemove pbm_mousemove
event ue_rowdragged pbm_custom67
end type
global u_datawindow_dragdrop u_datawindow_dragdrop

type variables
Public Long il_dragrow = 0
Private String is_objectname
end variables

forward prototypes
public subroutine uf_set_dragobject (string as_dragname)
protected function integer uf_get_dragrow ()
end prototypes

on mousedown;call u_datawindow_sqlca::mousedown;// Start draggin if positioned over a valid row (determined by uf_get_dragrow)
// Store rownumber in il_dragrow

il_dragrow = uf_get_dragrow()
If il_dragrow > 0 Then This.Drag(Begin!)


end on

on mouseup;call u_datawindow_sqlca::mouseup;// Stop draggin. If valid dragfrom and valid dragto row, then trigger a ue_rowdragged event

This.Drag(cancel!)

Long ll_newrow

If il_dragrow > 0 Then
	ll_newrow = uf_get_dragrow()

	If (ll_newrow >0) And (ll_newrow <> il_dragrow) Then &
		TriggerEvent("ue_rowdragged", il_dragrow, ll_newrow)
	
	il_dragrow = 0
End if
end on

public subroutine uf_set_dragobject (string as_dragname);is_objectname = lower(as_dragname)
end subroutine

protected function integer uf_get_dragrow ();String ls_tmp
Long ll_tmp

ls_tmp = This.GetObjectAtPointer()
ll_tmp = Pos(ls_tmp,"~t")

If (ll_tmp > 0) Then 
	If (is_objectname="") Or ((is_objectname<>"") And (is_objectname = Left(ls_tmp,ll_tmp - 1))) Then &
		Return(integer(Right(ls_tmp, Len(ls_tmp) - ll_tmp )))
End if

Return(0)

end function

on constructor;call u_datawindow_sqlca::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_datawindow_dragdrop
  
 Event	 : 

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 27-7-96

 Description : Enables row-drag-and-drop inside a datawindow.
			Call uf_set_dragobject("name"), where name is a name of a control, otherwise the
			drag-drop rutines will work on any objects inside the datawindow. 

			NB: Drag-and-drop will only work on objects (eventually use a dummy object as layer)

			A ue_dragrow event is triggede upon valid drag. Word parm will contain from-row,
			and longparm will contain to-row

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-7-96					MI		Itinal version  
************************************************************************************/

end on

