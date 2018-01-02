$PBExportHeader$w_action_detail.srw
$PBExportComments$Edit window for an action.
forward
global type w_action_detail from w_sale_base
end type
type dw_action from u_datawindow_sqlca within w_action_detail
end type
type dw_status from u_datawindow_sqlca within w_action_detail
end type
type cb_cancel from uo_cb_base within w_action_detail
end type
type cb_add_target from uo_cb_base within w_action_detail
end type
type cb_expand from uo_cb_base within w_action_detail
end type
type cb_mod_list_keys from uo_cb_base within w_action_detail
end type
type gb_2 from uo_gb_base within w_action_detail
end type
type gb_1 from uo_gb_base within w_action_detail
end type
type dw_keycodes from u_datawindow_sqlca within w_action_detail
end type
type dw_target from u_datawindow_sqlca within w_action_detail
end type
type gb_4 from uo_gb_base within w_action_detail
end type
type cb_close from uo_cb_base within w_action_detail
end type
type cb_update from uo_cb_base within w_action_detail
end type
type gb_3 from uo_gb_base within w_action_detail
end type
type uo_keycodes from u_cross_select within w_action_detail
end type
end forward

global type w_action_detail from w_sale_base
integer x = 0
integer y = 124
integer width = 2926
integer height = 1680
dw_action dw_action
dw_status dw_status
cb_cancel cb_cancel
cb_add_target cb_add_target
cb_expand cb_expand
cb_mod_list_keys cb_mod_list_keys
gb_2 gb_2
gb_1 gb_1
dw_keycodes dw_keycodes
dw_target dw_target
gb_4 gb_4
cb_close cb_close
cb_update cb_update
gb_3 gb_3
uo_keycodes uo_keycodes
end type
global w_action_detail w_action_detail

type variables
s_action istr_parm
Boolean ib_mod1,ib_mod2
end variables

forward prototypes
public function integer wf_save ()
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :22-08-96

 Description : Checks all required fields before updating an action

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
07-08-96		1.0 			JH		Initial version
  
************************************************************************************/
String ls_type,ls_shd_adh,ls_desc
Long ll_target

/* Do not update before required (blue) fields have been entered*/

dw_action.AcceptText()



/* Check if date planned is entered */
IF IsNull(dw_action.GetItemDateTime(1,"ccs_acts_plan_d")) THEN
	MessageBox("Update Error","Please enter Action Date Planned!")
	dw_action.SetFocus()
	Return 0
END IF
	
/* Check Action type has been entered */
ls_type = dw_action.GetItemString(1,"ccs_acts_type")
IF IsNull(ls_type) OR ls_type = "" THEN
	MessageBox("Update Error","Please enter Action Type!")
	dw_action.SetColumn("ccs_acts_type")
	dw_action.SetFocus()
	Return 0
END IF

/* Check Sheduled/Adhoc has been choosen*/
ls_shd_adh =  dw_action.GetItemString(1,"ccs_acts_schd_adh") 
IF IsNull(ls_shd_adh) OR ls_shd_adh = "" THEN
	MessageBox("Update Error","Please choose Sheduled or Adhoc!")
	dw_action.SetColumn("ccs_acts_schd_adh")
	dw_action.SetFocus()
	Return 0
END IF

/* Check if Action description has been entered*/
ls_desc =  dw_action.GetItemString(1,"ccs_acts_desc")
IF IsNull(ls_desc) OR ls_desc = "" THEN
	MessageBox("Update Error","Please enter Action Description")
	dw_action.SetColumn("ccs_acts_desc")
	dw_action.SetFocus()
	Return 0
END IF


/* Check target has been Selected*/
ll_target =  dw_action.GetItemNumber(1,"ccs_targ__pk")
IF IsNull(ll_target) OR ll_target = 0  THEN
		MessageBox("Update Error","Please Associate Action to a Target!")
		cb_add_target.SetFocus()
		Return 0		
END IF													


f_update(dw_action,w_tramos_main)
Return 1
	


end function

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : 
  
 Event	 : Open!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Opens window to let the user edit details for an action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : An instance structure of type s_action. Datafield 'action_key' must contain the key for an action to be
			 modified or 0 if creating new action. If a target is given, can this be parsed in 'target_key' 

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

Long ll_row

/* Set modicate flag to  stop itemChanged event in action/status detail datawindow indicating  changes in dw. */  
ib_mod1 = FALSE

istr_parm = Message.PowerObjectParm

IF istr_parm.action_key = 0 THEN
/*Create a new action*/
	ll_row = dw_action.InsertRow(0)
	dw_action.ShareData(dw_status)
	dw_action.ScrollToRow(ll_row)

	IF istr_parm.target_key > 0 THEN
	/* A target has been parsed */
		dw_action.SetItem(ll_row,"ccs_targ__pk",istr_parm.target_key)
		dw_target.Retrieve( istr_parm.target_key)
	END IF	

	this.title = "Action/Status Detail - NEW"
ELSE
/*Modify an action*/
	dw_action.Retrieve( istr_parm.action_key)
	dw_action.ShareData(dw_status)
	dw_keycodes.Retrieve( istr_parm.action_key)
	dw_target.Retrieve( istr_parm.target_key)

	this.title = "Action/Status Detail - MODIFY "+dw_action.GetItemString(1,"ccs_acts_desc")
	
END IF


/* Set modicate flag to idicate to itemChanged event i contact detail datawindow that modified flag can be set */  
ib_mod1 = TRUE	

dw_action.SetFocus()
end on

on w_action_detail.create
int iCurrent
call super::create
this.dw_action=create dw_action
this.dw_status=create dw_status
this.cb_cancel=create cb_cancel
this.cb_add_target=create cb_add_target
this.cb_expand=create cb_expand
this.cb_mod_list_keys=create cb_mod_list_keys
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_keycodes=create dw_keycodes
this.dw_target=create dw_target
this.gb_4=create gb_4
this.cb_close=create cb_close
this.cb_update=create cb_update
this.gb_3=create gb_3
this.uo_keycodes=create uo_keycodes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_action
this.Control[iCurrent+2]=this.dw_status
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_add_target
this.Control[iCurrent+5]=this.cb_expand
this.Control[iCurrent+6]=this.cb_mod_list_keys
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.dw_keycodes
this.Control[iCurrent+10]=this.dw_target
this.Control[iCurrent+11]=this.gb_4
this.Control[iCurrent+12]=this.cb_close
this.Control[iCurrent+13]=this.cb_update
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.uo_keycodes
end on

on w_action_detail.destroy
call super::destroy
destroy(this.dw_action)
destroy(this.dw_status)
destroy(this.cb_cancel)
destroy(this.cb_add_target)
destroy(this.cb_expand)
destroy(this.cb_mod_list_keys)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_keycodes)
destroy(this.dw_target)
destroy(this.gb_4)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.gb_3)
destroy(this.uo_keycodes)
end on

type dw_action from u_datawindow_sqlca within w_action_detail
integer x = 37
integer y = 64
integer width = 2816
integer height = 304
integer taborder = 10
string dataobject = "d_action_detail"
boolean border = false
end type

on itemchanged;call u_datawindow_sqlca::itemchanged;
IF ib_mod1 THEN
	/* Changes to the datawindow must be indicated */
	ib_mod2 = TRUE
END IF
end on

type dw_status from u_datawindow_sqlca within w_action_detail
integer x = 73
integer y = 784
integer width = 2469
integer height = 336
integer taborder = 30
string dataobject = "d_action_detail2"
boolean border = false
end type

on itemchanged;call u_datawindow_sqlca::itemchanged;IF ib_mod1 THEN
	/* Changes to the datawindow must be indicated */
	ib_mod2 = TRUE
END IF
end on

type cb_cancel from uo_cb_base within w_action_detail
integer x = 1810
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 60
string text = "&Cancel"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : cb_cancel
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Cancel all changes made in window.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_newrow



IF istr_parm.action_key > 0 THEN
// Get original data
	dw_action.Retrieve( istr_parm.action_key)
	dw_action.ShareData(dw_status)
	dw_keycodes.Retrieve( istr_parm.action_key)
	dw_target.Retrieve( istr_parm.target_key)
ELSE
// Insert new blank row
	dw_action.DeleteRow(1)
	ll_newrow = dw_action.InsertRow(0)
	dw_action.ScrollToRow(ll_newrow)
	dw_action.ShareData(dw_status)
	
	IF istr_parm.target_key > 0 THEN
	/* A target has been parsed */
		dw_action.SetItem(ll_newrow,"ccs_targ__pk",istr_parm.target_key)
		dw_target.Retrieve( istr_parm.target_key)
	END IF	

END IF
dw_action.SetFocus()





end on

type cb_add_target from uo_cb_base within w_action_detail
integer x = 2542
integer y = 1216
integer width = 311
integer height = 80
integer taborder = 50
string text = "&Associate"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : cb_expand
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description :Open window to let user select target to be associated with action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : 

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/


s_action  lstr_parm
Long ll_rtn

dw_action.AcceptText()
lstr_parm.Action_description =dw_action.GetItemString(1,"ccs_acts_desc")  
lstr_parm.Target_key = dw_action.GetItemNumber(1,"ccs_targ__pk")

cb_cancel.Enabled = FALSE
cb_close.Enabled = FALSE
cb_update.Enabled = FALSE

/* Open the responce window and wait for return */	
OpenWithParm(w_target_relate,lstr_parm)
ll_rtn = Message.DoubleParm

/* Test if target was choosen */
IF ll_rtn > 0 THEN
	/* Insert Target  */
	dw_action.SetItem(1,"ccs_targ__pk",ll_rtn)
	dw_target.Retrieve(ll_rtn)
END IF

cb_cancel.Enabled = TRUE
cb_close.Enabled = TRUE
cb_update.Enabled = TRUE	



end on

type cb_expand from uo_cb_base within w_action_detail
integer x = 2542
integer y = 880
integer width = 311
integer height = 80
integer taborder = 40
string text = "&Expand"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : cb_expand
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description :Expands text field in a responce window; so the user can edit this 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/
s_expand_text lstr_parm
String ls_rtn

dw_status.AcceptText()
lstr_parm.text =dw_status.GetItemString(1,"ccs_acts_sts_desc")  
lstr_parm.name = dw_status.GetItemString(1,"ccs_acts_desc")

cb_cancel.Enabled = FALSE
cb_close.Enabled = FALSE
cb_update.Enabled = FALSE

/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)
ls_rtn = Message.StringParm

/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_status.SetItem(1,"ccs_acts_sts_desc",ls_rtn)
END IF

cb_cancel.Enabled = TRUE
cb_close.Enabled = TRUE
cb_update.Enabled = TRUE	



end event

type cb_mod_list_keys from uo_cb_base within w_action_detail
integer x = 2542
integer y = 448
integer width = 315
integer height = 80
integer taborder = 20
string text = "&Modify List"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : cb_mod_list_keys
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 23-08-96

 Description : Activate the userobject holding keycodes 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
25-07-96		1.0	 		JH		Initial version
  
************************************************************************************/

IF istr_parm.action_key < 1 THEN
	MessageBox("Infomation","Please update new action first and reenter to asign asign keycodes!")
ELSE
// "Build" the user object
uo_keycodes.TriggerEvent(constructor!)
uo_keycodes.SetFocus()
END IF


end on

type gb_2 from uo_gb_base within w_action_detail
integer y = 736
integer width = 2889
integer height = 400
integer taborder = 0
string text = "Status:"
end type

type gb_1 from uo_gb_base within w_action_detail
integer y = 16
integer width = 2889
integer height = 384
integer taborder = 0
string text = "Action:"
end type

type dw_keycodes from u_datawindow_sqlca within w_action_detail
integer x = 421
integer y = 448
integer width = 2103
integer height = 272
integer taborder = 0
string dataobject = "d_acts_keys"
boolean vscrollbar = true
end type

type dw_target from u_datawindow_sqlca within w_action_detail
integer x = 55
integer y = 1216
integer width = 2469
integer height = 208
integer taborder = 0
string dataobject = "d_target_on_action"
boolean border = false
end type

type gb_4 from uo_gb_base within w_action_detail
integer y = 1136
integer width = 2889
integer height = 320
integer taborder = 0
string text = "Target:"
end type

type cb_close from uo_cb_base within w_action_detail
integer x = 2542
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 80
string text = "Close"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_closed
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 09-08-96

 Description : Close the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
09-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_ans


dw_action.AcceptText()
dw_status.AcceptText()

/* test if any changes were made */
IF ib_mod2 OR dw_status.ModifiedCount() > 0  THEN
	li_ans = MessageBox("Warning","You have modified the Action! Do you wish to save "&
						+"before closing?",Question!,YesNOCancel!)
END IF

IF li_ans = 1 THEN
	/* save changes before closing*/
	cb_update.TriggerEvent(Clicked!)
ELSEIF li_ans = 3 THEN
	/* Cancel close */
	Return
ELSE
	Close(Parent)
END IF

end on

type cb_update from uo_cb_base within w_action_detail
integer x = 2176
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 70
string text = "&Update"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : cb_update
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Update Action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/

IF wf_save() = 1 THEN
	Close(Parent)
END IF


end on

type gb_3 from uo_gb_base within w_action_detail
integer y = 400
integer width = 2889
integer height = 336
integer taborder = 0
string text = "Key Codes:"
end type

type uo_keycodes from u_cross_select within w_action_detail
boolean visible = false
integer y = 368
integer width = 2889
integer height = 1184
integer taborder = 90
end type

on constructor;call u_cross_select::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_action_detail
  
 Object     : uo_keycodes 
  
 Event	 : Constructor!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 23-08-96

 Description : Initializes th userobject to handle the list of this actions keycodes.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-08-96		1.0 			JH		Initial version
  
************************************************************************************/

s_cross_select_list lstr_list

IF istr_parm.action_key > 0 THEN
// Can only initialize user object if an action already is created in the database
	THIS.visible = True
//	The list of all keycodes
	lstr_list.dwin_list = "d_keycode_list"
// 	The list of keycodes for this action
	lstr_list.dwin_selects = "d_acts_keys"
//	The key for this action
	lstr_list.select_key = dw_action.GetItemNumber(1,"ccs_acts_pk")
//  	Column 1 in the list of all keycodes
	lstr_list.column_names[1] = "ccs_keyc_code" 
// 	Column 2 in the list of all keycodes
	lstr_list.column_names[2] = "ccs_keyc_desc"

	lstr_list.column_headers[1] = "Key Code" 
	lstr_list.column_headers[2] = "Description" 
// 	The name of the key column in the list of all keycodes
	lstr_list.list_key_column_name = "ccs_keyc_pk"
//      The name of the keycode-key-column in the m:n table(action_keycodes) to be updated
	lstr_list.selects_key_column_name =  "action_keycodes_ccs_keyc_pk"
//      The name of the action-key-column in the m:n table(action_keycodes) to be updated
	lstr_list.selects_key2_column_name = "action_keycodes_ccs_acts_pk"

	THIS.uf_construct (lstr_list)

END IF



end on

on destructor;call u_cross_select::destructor;This.visible = False
// Update the keycodelist in the window
dw_keycodes.Retrieve(istr_parm.action_key)
end on

on uo_keycodes.destroy
call u_cross_select::destroy
end on

