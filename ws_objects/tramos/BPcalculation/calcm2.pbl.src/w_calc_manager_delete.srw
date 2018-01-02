$PBExportHeader$w_calc_manager_delete.srw
$PBExportComments$Window for deleting calculation/cargo
forward
global type w_calc_manager_delete from mt_w_sheet
end type
type rb_delete_calc from uo_rb_base within w_calc_manager_delete
end type
type rb_delete_cargo from uo_rb_base within w_calc_manager_delete
end type
type sle_calculation from uo_sle_base within w_calc_manager_delete
end type
type sle_cargo from uo_sle_base within w_calc_manager_delete
end type
type cb_close from commandbutton within w_calc_manager_delete
end type
type cb_delete from commandbutton within w_calc_manager_delete
end type
type gb_1 from uo_gb_base within w_calc_manager_delete
end type
end forward

global type w_calc_manager_delete from mt_w_sheet
integer width = 1367
integer height = 796
string title = "Delete"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 32304364
boolean center = true
rb_delete_calc rb_delete_calc
rb_delete_cargo rb_delete_cargo
sle_calculation sle_calculation
sle_cargo sle_cargo
cb_close cb_close
cb_delete cb_delete
gb_1 gb_1
end type
global w_calc_manager_delete w_calc_manager_delete

type variables
s_calc_manager_delete_parm istr_parm
end variables

event open;call super::open;/************************************************************************************

 Author    : MIS
   
 Date       : 22-5-97

 Description : This window enables the user to delete either a cargo or the whole	
 					calculation. Information about current cargo is passed in the
					S_CALC_MANAGER_DELETE_PARM as message object argument 

 Arguments : S_CALC_MANAGER_DELETE_PARM as Message object parm

 Returns   : None, does the deletion itself

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

istr_parm = Message.PowerObjectParm

// If there's only one cargo on the specified calculation, the enable only the
// delete calculation posibility
If istr_parm.i_no_cargoes = 1 Then
	rb_delete_calc.checked = true
	rb_delete_cargo.enabled = false
End if

// Set the calculation description and cargo text into the corrosponding fields
sle_calculation.text = istr_parm.s_calc_description
sle_cargo.text = istr_parm.s_cargo_description
end event

on w_calc_manager_delete.create
int iCurrent
call super::create
this.rb_delete_calc=create rb_delete_calc
this.rb_delete_cargo=create rb_delete_cargo
this.sle_calculation=create sle_calculation
this.sle_cargo=create sle_cargo
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_delete_calc
this.Control[iCurrent+2]=this.rb_delete_cargo
this.Control[iCurrent+3]=this.sle_calculation
this.Control[iCurrent+4]=this.sle_cargo
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.gb_1
end on

on w_calc_manager_delete.destroy
call super::destroy
destroy(this.rb_delete_calc)
destroy(this.rb_delete_cargo)
destroy(this.sle_calculation)
destroy(this.sle_cargo)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.gb_1)
end on

type rb_delete_calc from uo_rb_base within w_calc_manager_delete
integer x = 78
integer y = 96
integer width = 512
integer height = 64
long backcolor = 32304364
string text = "Delete calculation:"
end type

type rb_delete_cargo from uo_rb_base within w_calc_manager_delete
integer x = 78
integer y = 308
integer width = 567
integer height = 64
long backcolor = 32304364
string text = "Delete single cargo:"
boolean checked = true
end type

type sle_calculation from uo_sle_base within w_calc_manager_delete
integer x = 64
integer y = 192
integer width = 1207
integer height = 80
integer taborder = 50
long backcolor = 32304364
boolean displayonly = true
end type

type sle_cargo from uo_sle_base within w_calc_manager_delete
integer x = 64
integer y = 412
integer width = 1207
integer height = 80
integer taborder = 10
long backcolor = 32304364
boolean displayonly = true
end type

type cb_close from commandbutton within w_calc_manager_delete
integer x = 983
integer y = 580
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the delete window, returning 0 (no action) to the 
 					calling window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

CloseWithReturn(Parent,0)
Return
end event

type cb_delete from commandbutton within w_calc_manager_delete
integer x = 613
integer y = 580
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects DELETE.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Display warning dialog. If the user accepts, then close & return code for
// either deletion of the cargo (=1) or the whole calculation (=2)

If rb_delete_calc.checked Then
	If MessageBox("Warning", "You are about to delete calculation <" + istr_parm.s_calc_description+">~r~n~r~nContinue ?", StopSign!, YesNo!, 2) = 1 Then
		CloseWithReturn(Parent,2)
		Return
	End if
Elseif rb_delete_cargo.checked then
	If MessageBox("Warning", "You are about to delete cargo ~"" + istr_parm.s_cargo_description+"~"~r~n~r~nContinue ?", StopSign!, YesNo!, 2) = 1 Then
		CloseWithReturn(Parent,1)
		Return
	End if
End if

end event

type gb_1 from uo_gb_base within w_calc_manager_delete
integer x = 23
integer y = 16
integer width = 1298
integer height = 528
integer taborder = 40
integer weight = 700
long backcolor = 32304364
string text = "Select what to delete"
end type

