$PBExportHeader$uo_ddlb_base.sru
$PBExportComments$The Base object for DropDownListBox
forward
global type uo_ddlb_base from dropdownlistbox
end type
end forward

global type uo_ddlb_base from dropdownlistbox
integer width = 247
integer height = 216
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
end type
global uo_ddlb_base uo_ddlb_base

type variables
Private Integer ii_selected = -1
end variables

forward prototypes
public function integer selectitem (integer ai_row)
public function integer getselected ()
end prototypes

public function integer selectitem (integer ai_row);Integer li_result

li_result = Super::selectItem(ai_row) 

if li_result > 0 Then 	ii_selected = ai_row

Return(li_result)
end function

public function integer getselected ();Return(ii_selected)
end function

on constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_ddlb_base
  
 Event	 : Constructor

 Scope     : 

 ************************************************************************************

 Author    : JH
   
 Date       : 9-10-96

 Description : Dropdown standard listbox.
	9-10-96: Added GetSelected function to this object, since the "normal" dropdown listbox, dosn't have
			capabilities to tell the selected row

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-7-96		1.0			JH		Initial version
9-10-96					MI		Added GetSelected function to return current selected row 
************************************************************************************/

end on

event selectionchanged;ii_selected = Index

end event

on uo_ddlb_base.create
end on

on uo_ddlb_base.destroy
end on

