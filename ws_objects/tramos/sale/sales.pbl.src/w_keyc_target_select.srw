$PBExportHeader$w_keyc_target_select.srw
$PBExportComments$Associate key codes to a target.
forward
global type w_keyc_target_select from w_sale_response
end type
type uo_cross_select from u_cross_select within w_keyc_target_select
end type
end forward

global type w_keyc_target_select from w_sale_response
integer x = 64
integer y = 292
integer width = 2766
integer height = 1316
uo_cross_select uo_cross_select
end type
global w_keyc_target_select w_keyc_target_select

type variables
LONG il_target_pk
end variables

forward prototypes
public subroutine wf_sole_enable (commandbutton a_cb)
public subroutine wf_enable_all_buttons ()
public subroutine documentation ()
end prototypes

public subroutine wf_sole_enable (commandbutton a_cb);///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : w_ccs_chart
//  
// Object     : wf_sole_enable(as_button)
//  
// Event	 : 
//
// Scope     : Public
//
// ************************************************************************************
//
// Author    : Jeannette Holland
//   
// Date       : 24-07-96
//
// Description : Disables all other buttons than the one specified by as_button. 
//
// Arguments : String as_button is the name of the button to be the only one enabled.
//
// Returns   : none  
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//24-07-96		1.0	 		JH		Initial version
//  
//************************************************************************************/
//
//CHOOSE CASE a_cb
//	CASE cb_update
//		cb_text.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_text
//		cb_update.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_meetings
//		cb_update.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_keycodes
//		cb_update.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_contacts
//		cb_update.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_close.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_close
//		cb_update.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_articles.enabled = FALSE
//	CASE cb_articles
//		cb_update.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_refresh.enabled = FALSE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//	CASE cb_refresh
//		cb_update.enabled = FALSE
//		cb_text.enabled = FALSE
//		cb_refresh.enabled = TRUE
//		cb_meetings.enabled = FALSE
//		cb_keycodes.enabled = FALSE
//		cb_contacts.enabled = FALSE
//		cb_close.enabled = FALSE
//END CHOOSE
//
end subroutine

public subroutine wf_enable_all_buttons ();///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : w_ccs_chart
//  
// Object     : wf_enable_all_buttons
//  
// Event	 : 
//
// Scope     : Public
//
// ************************************************************************************
//
// Author    : Jeannette Holland
//   
// Date       :29-07-96
//
// Description : Enables all buttons in the windows buttum line
//
// Arguments :none
//
// Returns   : none  
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//29-07-96		1.0	 		JH		Initial version
//  
//************************************************************************************/
//
//cb_update.enabled = TRUE
//cb_text.enabled = TRUE
//cb_meetings.enabled = TRUE
//cb_keycodes.enabled = TRUE
//cb_refresh.enabled = TRUE
//cb_contacts.enabled = TRUE
//cb_close.enabled = TRUE
//cb_articles.enabled = TRUE
end subroutine

public subroutine documentation ();/********************************************************************
	w_keyc_target_select
	
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

on open;call w_sale_response::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keyc_target_select
  
 Object     : 
  
 Event	 : Open!

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 27-08-96

 Description : Activate the userobject holding keycodes related to the actual target

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0	 		KHK		Initial version for use with targets
05-09-96					JH		Changed to responce window to be able to CloseWithReturn()  
************************************************************************************/

//String ls_keycode_desc
//
//////////////////////////// Get actual Keycode-key from "Message.DoubleParm"
il_target_pk = Message.DoubleParm

/////////////////////////// Find the Keycode-description
//  SELECT CCS_KEYC.CCS_KEYC_DESC  
//    INTO :ls_keycode_desc  
//    FROM CCS_KEYC  
//  WHERE CCS_KEYC.CCS_KEYC_PK = :il_keycode_pk   ;
//
//////////////////////// Use the found Keycode-description in the window-title
This.Title = "Keycodes for Target" 	//+ ls_keycode_desc

/////////////////////// Conctruct and run the UserObject
uo_cross_select.TriggerEvent(constructor!)
uo_cross_select.SetFocus()

end on

on w_keyc_target_select.create
int iCurrent
call super::create
this.uo_cross_select=create uo_cross_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cross_select
end on

on w_keyc_target_select.destroy
call super::destroy
destroy(this.uo_cross_select)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_keyc_target_select
end type

type uo_cross_select from u_cross_select within w_keyc_target_select
integer height = 1184
integer taborder = 1
end type

on destructor;call u_cross_select::destructor;/* Close the window following click on update and cancel buttons */
CloseWithReturn(Parent,1)
end on

on constructor;call u_cross_select::constructor;/////////////////////////////// Initialize the UserObject via the structure "lstr_list"
s_cross_select_list lstr_list

lstr_list.dwin_list = "d_keycode_list2"
lstr_list.dwin_selects = "d_keyc_target_list"
lstr_list.select_key = il_target_pk
lstr_list.column_names[1] = "ccs_keyc_code" 
lstr_list.column_names[2] = "ccs_keyc_desc"
lstr_list.column_headers[1] = "Keycode" 
lstr_list.column_headers[2] = "Description" 
lstr_list.list_key_column_name = "ccs_keyc_pk"
lstr_list.selects_key_column_name =  "target_keycodes_ccs_keyc_pk"
lstr_list.selects_key2_column_name = "target_keycodes_ccs_targ__pk"
THIS.uf_construct (lstr_list)
end on

on uo_cross_select.destroy
call u_cross_select::destroy
end on

