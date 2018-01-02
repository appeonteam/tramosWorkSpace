$PBExportHeader$w_targets_chart_select.srw
$PBExportComments$Associate targets to a charterer.
forward
global type w_targets_chart_select from w_sale_base
end type
type uo_cross_select from u_cross_select within w_targets_chart_select
end type
end forward

global type w_targets_chart_select from w_sale_base
int X=65
int Y=293
int Width=2766
int Height=1317
boolean MaxBox=false
boolean Resizable=false
uo_cross_select uo_cross_select
end type
global w_targets_chart_select w_targets_chart_select

type variables
LONG il_chart_pk
end variables

forward prototypes
public subroutine wf_sole_enable (commandbutton a_cb)
public subroutine wf_enable_all_buttons ()
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

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_chart_target_select
  
 Object     : 
  
 Event	 : Open

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 27-08-96

 Description : Activate the userobject holding targets related to the actual charterer

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-09-96		1.0	 		KHK		Initial version

************************************************************************************/
Pointer lp_old_pointer


//////////////////////////// Get actual Keycode-key from "Message.DoubleParm"
il_chart_pk = Message.DoubleParm

lp_old_pointer = SetPointer(HourGlass!)
/////////////////////////// Find the Keycode-description
//  SELECT CHART.CHART_SN  
//    INTO :ls_chart_sn  
//    FROM CHART 
//  WHERE CHART.CHART_SN = :il_keycode_pk   ;
//
//////////////////////// Use the found Keycode-description in the window-title
This.Title = "Targets for Charterer" 	//+ ls_keycode_desc

/////////////////////// Conctruct and run the UserObject
uo_cross_select.TriggerEvent(constructor!)
uo_cross_select.SetFocus()

Setpointer(lp_old_pointer)
end on

on w_targets_chart_select.create
int iCurrent
call w_sale_base::create
this.uo_cross_select=create uo_cross_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=uo_cross_select
end on

on w_targets_chart_select.destroy
call w_sale_base::destroy
destroy(this.uo_cross_select)
end on

type uo_cross_select from u_cross_select within w_targets_chart_select
int X=1
int Y=1
int Width=2762
int TabOrder=1
boolean Border=false
end type

on constructor;call u_cross_select::constructor;/////////////////////////////// Initialize the UserObject via the structure "lstr_list"
s_cross_select_list lstr_list

lstr_list.dwin_list = "d_ccs_target_list"
lstr_list.dwin_selects = "d_chart_targets"
lstr_list.select_key = il_chart_pk
lstr_list.column_names[1] = "userid" 
lstr_list.column_names[2] = "ccs_targ_desc"
lstr_list.column_headers[1] = "Sales Person" 
lstr_list.column_headers[2] = "Description" 
lstr_list.list_key_column_name = "ccs_targ__pk"
lstr_list.selects_key_column_name =  "charterers_targets_ccs_targ__pk"
lstr_list.selects_key2_column_name = "charterers_targets_chart_nr"
THIS.uf_construct (lstr_list)

end on

on destructor;call u_cross_select::destructor;/* Close the window following click on update and close buttons */
Close(Parent)
end on

on uo_cross_select.destroy
call u_cross_select::destroy
end on

