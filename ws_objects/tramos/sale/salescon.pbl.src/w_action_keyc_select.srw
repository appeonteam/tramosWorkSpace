$PBExportHeader$w_action_keyc_select.srw
$PBExportComments$Many-to-many selection of actions to keycodes.
forward
global type w_action_keyc_select from w_sale_response
end type
type uo_cross_select from u_cross_select within w_action_keyc_select
end type
end forward

global type w_action_keyc_select from w_sale_response
integer width = 2793
integer height = 1340
uo_cross_select uo_cross_select
end type
global w_action_keyc_select w_action_keyc_select

type variables
LONG il_keycode_pk
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_action_keyc_select
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/

end subroutine

on close;call w_sale_response::close;CloseWithReturn(This,1)
end on

on open;call w_sale_response::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_keyc_select
  
 Object     : 
  
 Event	 : Open

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Activate the userobject holding actions related to the actual keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0	 		KHK		Initial version
23-08-96					JH		Added code to user object's destructor event. This will course the window to close
								after update and close buttons have been clicked.  
05-09-96					JH		Changed window to be responce window    
************************************************************************************/

String ls_keycode_desc

////////////////////////// Get actual Keycode-key from "Message.DoubleParm"
il_keycode_pk = Message.DoubleParm

///////////////////////// Find the Keycode-description
  SELECT CCS_KEYC.CCS_KEYC_DESC  
    INTO :ls_keycode_desc  
    FROM CCS_KEYC  
  WHERE CCS_KEYC.CCS_KEYC_PK = :il_keycode_pk   ;

//////////////////////// Use the found Keycode-description in the window-title
This.Title = "Actions for Keycode: " + ls_keycode_desc

/////////////////////// Conctruct and run the UserObject
uo_cross_select.TriggerEvent(constructor!)
uo_cross_select.SetFocus()


end on

on w_action_keyc_select.create
int iCurrent
call super::create
this.uo_cross_select=create uo_cross_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cross_select
end on

on w_action_keyc_select.destroy
call super::destroy
destroy(this.uo_cross_select)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_action_keyc_select
end type

type uo_cross_select from u_cross_select within w_action_keyc_select
integer width = 2798
integer height = 1184
integer taborder = 1
end type

on destructor;call u_cross_select::destructor;//CloseWithReturn(Parent,1)
Parent.TriggerEvent(Close!)
end on

on constructor;call u_cross_select::constructor;/////////////////////////////// Initialize the UserObject via the structure "lstr_list"
s_cross_select_list lstr_list

lstr_list.dwin_list = "d_ccs_action_list"
lstr_list.dwin_selects = "d_actions_list"
lstr_list.select_key = il_keycode_pk
lstr_list.column_names[1] = "ccs_acts_plan_d" 
lstr_list.column_names[2] = "ccs_acts_desc"
lstr_list.column_headers[1] = "Date Planned" 
lstr_list.column_headers[2] = "Description" 
lstr_list.list_key_column_name = "ccs_acts_pk"
lstr_list.selects_key_column_name =  "action_keycodes_ccs_acts_pk"
lstr_list.selects_key2_column_name = "action_keycodes_ccs_keyc_pk"
THIS.uf_construct (lstr_list)
end on

on uo_cross_select.destroy
call u_cross_select::destroy
end on

