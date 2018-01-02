$PBExportHeader$uo_datawindow_multiselect.sru
$PBExportComments$Userobject with multiselect - just like a listbox
forward
global type uo_datawindow_multiselect from uo_datawindow
end type
end forward

global type uo_datawindow_multiselect from uo_datawindow
end type
global uo_datawindow_multiselect uo_datawindow_multiselect

type variables
Boolean ib_simpleSelect
Boolean ib_multiallowed
Long il_last_selected = 0
end variables

forward prototypes
public function boolean getselected (ref long pl_row)
public subroutine uf_processrow (long al_row)
end prototypes

public function boolean getselected (ref long pl_row);// retrieves selected rows
//
// Parameters:
//
// Function GetSelected(Var pl_Row: Long): Boolean
//
// Returns TRUE and Row. no in pl_Row as long as there is selected rows. At first call, 
// ll_Row should be set to zero.
//
// Example:
//
// ll_Row = 0
// Do While GetSelected( ll_Row ) 
//   ..
// Loop
//

pl_Row = GetSelectedRow ( pl_row )

Return pl_row <> 0

end function

public subroutine uf_processrow (long al_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Processes clicked events

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Integer li_count

If al_Row > 0 Then
	If ib_simpleSelect Then
		SelectRow ( al_row, Not GetSelectedRow(al_row - 1) = al_row )
	Else // if simple select
		If KeyDown ( KeyControl! ) Then

			if isselected(al_row) then
				SelectRow ( al_row, FALSE )
			else
				SelectRow ( al_row, True )
			end if
		ElseIf KeyDown ( KeyShift! ) Then

			if il_last_selected = 0 then
				SelectRow ( al_row, True )
			else
				if il_last_selected > al_row then
					SelectRow ( 0,False )
					FOR li_count=al_row TO il_last_selected
						SelectRow ( li_count, True )
					NEXT
				else
					SelectRow ( 0,False )
					FOR li_count= il_last_selected TO al_row
						SelectRow ( li_count, True )
					NEXT
				end if
			end if
		else
  			SelectRow ( 0, False )
   			SelectRow ( al_row, True )
			il_last_selected = al_row
		End if
	End if // simple select
End if // if al_row > 0

end subroutine

on constructor;call uo_datawindow::constructor;///////////////////////////////////////////////////////////////////////
//
//
//   Arthur Andersen PowerBuilder Development
//
//
//  Function  : uo_datawindow_multiselect
//
//  Purpose   : Gives listbox-mulitselect functionality to datawindows
//                    ib_simpleselect (default false) controls wether the user
//		      needs to press shift while selecting more than one line.
//
//  Author    : Martin Israelsen
//   
//  Date      : 19-10-95
//
//  Scope     : Global 
//
//  Arguments :   none
//
//  Returns   :    none
//
//  Development Log 
//
//  DATE     VERSION NAME  DESCRIPTION
//  -------- ------- ----- -------------------------------------------
//  19-10-95 1.0         MI  Initial version
//
//
//
////////////////////////////////////////////////////////////////////////


ib_simpleSelect = False
ib_multiallowed = true
ib_auto = false 
end on

event clicked;If ib_multiallowed then
	uf_processrow(row)
Else // else multi_allowed
	Call uo_datawindow::clicked
End if // if_multi_allowed

end event

