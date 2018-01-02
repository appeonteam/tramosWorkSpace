$PBExportHeader$w_target_detail.srw
$PBExportComments$This window lets the user enter details on a target.
forward
global type w_target_detail from w_sale_base
end type
type cb_new_support from commandbutton within w_target_detail
end type
type cb_delete_support from commandbutton within w_target_detail
end type
type cb_modify_support from commandbutton within w_target_detail
end type
type cb_expand_description from commandbutton within w_target_detail
end type
type cb_expand_completed from commandbutton within w_target_detail
end type
type dw_target_detail from u_datawindow_sqlca within w_target_detail
end type
type r_5 from rectangle within w_target_detail
end type
type st_1 from statictext within w_target_detail
end type
type st_2 from statictext within w_target_detail
end type
type st_3 from statictext within w_target_detail
end type
type cb_new_action from commandbutton within w_target_detail
end type
type cb_modify_action from commandbutton within w_target_detail
end type
type cb_delete_action from commandbutton within w_target_detail
end type
type cb_modify_charterer_list from commandbutton within w_target_detail
end type
type cb_modify_keycode_list from commandbutton within w_target_detail
end type
type cb_refresh from commandbutton within w_target_detail
end type
type cb_update from commandbutton within w_target_detail
end type
type cb_close from commandbutton within w_target_detail
end type
type st_4 from statictext within w_target_detail
end type
type r_1 from rectangle within w_target_detail
end type
type dw_support from u_datawindow_sqlca within w_target_detail
end type
type dw_actions from u_datawindow_sqlca within w_target_detail
end type
type dw_charterers from u_datawindow_sqlca within w_target_detail
end type
type dw_keycodes from u_datawindow_sqlca within w_target_detail
end type
end forward

global type w_target_detail from w_sale_base
int X=1
int Y=1
int Width=2926
int Height=1661
boolean TitleBar=true
string Title="Target detail"
boolean MaxBox=false
boolean Resizable=false
cb_new_support cb_new_support
cb_delete_support cb_delete_support
cb_modify_support cb_modify_support
cb_expand_description cb_expand_description
cb_expand_completed cb_expand_completed
dw_target_detail dw_target_detail
r_5 r_5
st_1 st_1
st_2 st_2
st_3 st_3
cb_new_action cb_new_action
cb_modify_action cb_modify_action
cb_delete_action cb_delete_action
cb_modify_charterer_list cb_modify_charterer_list
cb_modify_keycode_list cb_modify_keycode_list
cb_refresh cb_refresh
cb_update cb_update
cb_close cb_close
st_4 st_4
r_1 r_1
dw_support dw_support
dw_actions dw_actions
dw_charterers dw_charterers
dw_keycodes dw_keycodes
end type
global w_target_detail w_target_detail

type variables
s_target istr_parm
long il_parametre
long il_selectedrow
long il_supportRow = 0
long il_actionrow = 0
long il_chartererrow = 0
long il_keycoderow = 0

end variables

forward prototypes
public function integer wf_save ()
public subroutine wf_retrieve_support ()
public subroutine wf_enable_disable_functions (datawindow a_dw)
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 26-08-96

 Description : Checks all required fields before updating a target

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/

/* Check all required fields are entered in target */

dw_target_detail.AcceptText()

IF IsNull(dw_target_detail.GetItemString(1,"userid")) THEN
	MessageBox("Update Error","Please enter a contactperson",Stopsign!)
	Return 0
ELSEIF IsNull(dw_target_detail.GetItemDateTime(1,"ccs_targ_from_d")) THEN
	MessageBox("Update Error","Please enter a target from-date",Stopsign!)
	Return 0
ELSEIF IsNull(dw_target_detail.GetItemDateTime(1,"ccs_targ_to_d")) THEN
	MessageBox("Update Error","Please enter a target to-date",Stopsign!)
	Return 0
ELSE
	f_update(dw_target_detail,w_tramos_main)
	Return 1
END IF

end function

public subroutine wf_retrieve_support ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : wf_retrieve_support
  
 Event	 : 

 Scope     :Public 

 ************************************************************************************

 Author    : Jeannette Holland/Kim Husson Kasperek
   
 Date       : 08-08-96

 Description :Retrieves and calculates support for the charterer

 Arguments : none

 Returns   : none

 Variables : il_parametre must contain the charterer key

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-08-96		1.0 			JH		Initial version	
26-08-96		2.0			KHK		Initial version modified for use with "target_detail"
************************************************************************************/
u_compute_support uo_com_sup
Long ll_count,ll_row, ll_result_act,ll_result_est
String ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr, ls_formula, ls_act,ls_est

/* Initialize the user object used to calculate actual and estimated support figures */
uo_com_sup = CREATE u_compute_support

/* Retrieve Support definitions */
ll_count = dw_support.Retrieve(il_parametre)
COMMIT USING SQLCA;

IF ll_count > 0 THEN
/* For each row calculate actual and estimated support figures */ 
	FOR ll_row = 1 TO ll_count
		/* Get all details of the support definition */
		ls_type = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_con_type")
		IF ls_type = "0" THEN ls_type = ""
		ls_cerpid = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_cal_cerp_id_list")
		ls_chartnr = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_chart_nr_list")
		ls_chgp = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_chgp_list")
		ls_cerpdate = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_cerp_date_list")
		ls_vv_nr =  dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_vv_no_list")
		ls_formula = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_form_list")
		/* Make the actual and estimated formulars */
		ls_act = uo_com_sup.uf_compute_support(ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr,ls_formula,"ACTUAL")
		ls_est = uo_com_sup.uf_compute_support(ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr,ls_formula,"ESTIMATE")
		/* Calculate the formular */
		ll_result_act = Long(dw_support.Describe("evaluate('"+ls_act+"', " + String(ll_row) + ")"))
		ll_result_est = Long(dw_support.Describe("evaluate('"+ls_est+"', " + String(ll_row) + ")"))
		/* Show the actual and estimated figures */
		dw_support.SetItem(ll_row,"compute_0016",ll_result_act)
		dw_support.SetItem(ll_row,"compute_0017",ll_result_est)
	NEXT
END IF

DESTROY uo_com_sup
end subroutine

public subroutine wf_enable_disable_functions (datawindow a_dw);//////////////////////// Enable/disable buttons according to data in the windows

CHOOSE CASE a_dw 
	CASE dw_target_detail
		//no enable/disable to be made
	CASE dw_support
		cb_new_support.enabled = istr_parm.target_pk > 0
		cb_modify_support.enabled = (il_supportrow > 0) AND (istr_parm.target_pk > 0)
		cb_delete_support.enabled = (il_supportrow > 0) AND (istr_parm.target_pk > 0)
	CASE dw_actions
		cb_new_action.enabled = istr_parm.target_pk > 0
		cb_modify_action.enabled = (il_actionrow > 0) AND (istr_parm.target_pk > 0)
		cb_delete_action.enabled = (il_actionrow > 0) AND (istr_parm.target_pk > 0)
	CASE dw_charterers
		cb_modify_charterer_list.enabled = istr_parm.target_pk > 0
	CASE dw_keycodes
		cb_modify_keycode_list.enabled = istr_parm.target_pk > 0
END CHOOSE

end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 26-08-96

 Description : Create, modify or delete targets

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables :{description/none}  

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
26-08-96		1.0 			KHK		Initial version
29-08-96					JH		Added hourglass pointer in open event
  
************************************************************************************/

Long ll_cur_row
Pointer lp_old_pointer

istr_parm = Message.PowerObjectParm
lp_old_pointer = SetPointer(HourGlass!)

IF istr_parm.target_pk = 0 THEN
	/*Create a new target*/
	ll_cur_row = dw_target_detail.InsertRow(0)
	dw_target_detail.ScrollToRow(ll_cur_row)

	il_parametre = 0
	this.title = "Target Detail - NEW"
ELSE
	//*Modify a target*/
	dw_target_detail.Retrieve(istr_parm.target_pk)
	COMMIT USING SQLCA;
	il_parametre = istr_parm.target_pk
	ll_cur_row = dw_target_detail.GetRow()
	dw_actions.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	dw_charterers.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	dw_keycodes.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	wf_retrieve_support()	/* Retrieve and calculate Support */

	this.title = "Target Detail - MODIFY "
END IF

dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_chartererrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

dw_target_detail.SetFocus()

SetPointer(lp_old_pointer)

end on

on w_target_detail.create
int iCurrent
call w_sale_base::create
this.cb_new_support=create cb_new_support
this.cb_delete_support=create cb_delete_support
this.cb_modify_support=create cb_modify_support
this.cb_expand_description=create cb_expand_description
this.cb_expand_completed=create cb_expand_completed
this.dw_target_detail=create dw_target_detail
this.r_5=create r_5
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.cb_new_action=create cb_new_action
this.cb_modify_action=create cb_modify_action
this.cb_delete_action=create cb_delete_action
this.cb_modify_charterer_list=create cb_modify_charterer_list
this.cb_modify_keycode_list=create cb_modify_keycode_list
this.cb_refresh=create cb_refresh
this.cb_update=create cb_update
this.cb_close=create cb_close
this.st_4=create st_4
this.r_1=create r_1
this.dw_support=create dw_support
this.dw_actions=create dw_actions
this.dw_charterers=create dw_charterers
this.dw_keycodes=create dw_keycodes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_new_support
this.Control[iCurrent+2]=cb_delete_support
this.Control[iCurrent+3]=cb_modify_support
this.Control[iCurrent+4]=cb_expand_description
this.Control[iCurrent+5]=cb_expand_completed
this.Control[iCurrent+6]=dw_target_detail
this.Control[iCurrent+7]=r_5
this.Control[iCurrent+8]=st_1
this.Control[iCurrent+9]=st_2
this.Control[iCurrent+10]=st_3
this.Control[iCurrent+11]=cb_new_action
this.Control[iCurrent+12]=cb_modify_action
this.Control[iCurrent+13]=cb_delete_action
this.Control[iCurrent+14]=cb_modify_charterer_list
this.Control[iCurrent+15]=cb_modify_keycode_list
this.Control[iCurrent+16]=cb_refresh
this.Control[iCurrent+17]=cb_update
this.Control[iCurrent+18]=cb_close
this.Control[iCurrent+19]=st_4
this.Control[iCurrent+20]=r_1
this.Control[iCurrent+21]=dw_support
this.Control[iCurrent+22]=dw_actions
this.Control[iCurrent+23]=dw_charterers
this.Control[iCurrent+24]=dw_keycodes
end on

on w_target_detail.destroy
call w_sale_base::destroy
destroy(this.cb_new_support)
destroy(this.cb_delete_support)
destroy(this.cb_modify_support)
destroy(this.cb_expand_description)
destroy(this.cb_expand_completed)
destroy(this.dw_target_detail)
destroy(this.r_5)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_new_action)
destroy(this.cb_modify_action)
destroy(this.cb_delete_action)
destroy(this.cb_modify_charterer_list)
destroy(this.cb_modify_keycode_list)
destroy(this.cb_refresh)
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.st_4)
destroy(this.r_1)
destroy(this.dw_support)
destroy(this.dw_actions)
destroy(this.dw_charterers)
destroy(this.dw_keycodes)
end on

type cb_new_support from commandbutton within w_target_detail
int X=2506
int Y=705
int Width=275
int Height=81
int TabOrder=70
string Text="New"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : w_ccs_chart
//  
// Object     : cb_new_support
//  
// Event	 : Clicked!
//
// Scope     : 
//
// ************************************************************************************
//
// Author    : Jeannette Holland
//   
// Date       : 02-08-96
//
// Description : Create a new support definition
//
// Arguments : {description/none}
//
// Returns   : {description/none}  
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//02-08-96		1.0	 		JH		Initial version
//26-08-96		1.0			KHK		Now used in connection with Targets
//  
//************************************************************************************/
S_support lstr_parm
w_supdef lw_def


/* Init the structure for a new support definiton*/
lstr_parm.sdef_pk = 0
/* The support definition belongs to a charterer*/
lstr_parm.sdef_chart = FALSE
/* Charterer key*/
lstr_parm.sdef_ownerid = dw_target_detail.GetItemNumber(dw_target_detail.GetRow(),"ccs_targ__pk")

OpenSheetWithParm(lw_def,lstr_parm,w_tramos_main,7,Original!)

wf_enable_disable_functions(dw_support)



end on

type cb_delete_support from commandbutton within w_target_detail
int X=2506
int Y=897
int Width=275
int Height=81
int TabOrder=90
string Text="Delete"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_delete_support
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 02-08-96

 Description : Delete a support definition

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0	 		JH		Initial version
26-08-96		1.0			KHK		Now used in connection with Targets (names on ClickButtons modified)
  
************************************************************************************/


dw_support.DeleteRow(dw_support.GetRow())
dw_support.Update()

wf_enable_disable_functions(dw_support)

end on

type cb_modify_support from commandbutton within w_target_detail
int X=2506
int Y=801
int Width=275
int Height=81
int TabOrder=80
string Text="Modify"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_modify_support
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 30-07-96

 Description : Opens window to edit details of chosen support definition

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		1.0	 		JH		Initial version
26-08-96		1.0			KHK		Now used in connection with Targets
  
************************************************************************************/

Long ll_row
s_support lstr_parm
w_supdef lw_def

ll_row = dw_support.GetRow()
// Get the selected support definitions key
lstr_parm.sdef_pk = dw_support.GetItemNumber(ll_row,"ccs_sdef_ccs_sdef_pk")
// Get the selected support definition description
lstr_parm.sdef_desc = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc") 


IF lstr_parm.sdef_pk > 0 THEN
	OpenSheetWithParm(lw_def,lstr_parm,w_tramos_main,7,Original!)
END IF

wf_enable_disable_functions(dw_support)


end on

type cb_expand_description from commandbutton within w_target_detail
int X=2506
int Y=161
int Width=275
int Height=81
int TabOrder=50
string Text="Expand"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_expand_description
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 03-08-96

 Description :Expands text field in a responce window; so the user can edit this 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
03-08-96		1.0 			JH		Initial version
26-08-96		1.0 			KHK		Now also used in Targets
  
************************************************************************************/


s_expand_text lstr_parm
String ls_rtn

dw_target_detail.AcceptText()
lstr_parm.text =dw_target_detail.GetItemString(1,"ccs_targ_desc")  
lstr_parm.name = "Target description" //dw_target_detail.GetItemString(1,"ccs_cont_name")

cb_refresh.Enabled = FALSE
cb_close.Enabled = FALSE
cb_update.Enabled = FALSE
/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)

ls_rtn = Message.StringParm
/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_target_detail.SetItem(1,"ccs_targ_desc",ls_rtn)
END IF
cb_refresh.Enabled = TRUE
cb_close.Enabled = TRUE
cb_update.Enabled = TRUE	



end on

type cb_expand_completed from commandbutton within w_target_detail
int X=2506
int Y=465
int Width=275
int Height=81
int TabOrder=60
string Text="Expand"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_expand_completed
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 03-08-96

 Description :Expands text field in a responce window; so the user can edit this 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
03-08-96		1.0 			JH		Initial version
26-08-96		1.0 			KHK		Now also used in Targets
  
************************************************************************************/


s_expand_text lstr_parm
String ls_rtn

dw_target_detail.AcceptText()
lstr_parm.text =dw_target_detail.GetItemString(1,"ccs_targ_comp_desc")  
lstr_parm.name = "Target completed description" //dw_target_detail.GetItemString(1,"ccs_cont_name")

cb_refresh.Enabled = FALSE
cb_close.Enabled = FALSE
cb_update.Enabled = FALSE
/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)

ls_rtn = Message.StringParm
/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_target_detail.SetItem(1,"ccs_targ_comp_desc",ls_rtn)
END IF
cb_refresh.Enabled = TRUE
cb_close.Enabled = TRUE
cb_update.Enabled = TRUE	



end on

type dw_target_detail from u_datawindow_sqlca within w_target_detail
int X=37
int Y=1
int Width=2798
int Height=657
int TabOrder=30
string DataObject="d_target_detail"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on getfocus;call u_datawindow_sqlca::getfocus;dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_chartererrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

end on

on itemchanged;call u_datawindow_sqlca::itemchanged;//
//IF ib_mod1 THEN
//	/* Changes to the datawindow must be indicated */
//	ib_mod2 = TRUE
//END IF
//
end on

type r_5 from rectangle within w_target_detail
int X=74
int Y=1009
int Width=2762
int Height=449
boolean Enabled=false
int LineThickness=5
long FillColor=12632256
end type

type st_1 from statictext within w_target_detail
int X=110
int Y=1025
int Width=238
int Height=49
boolean Enabled=false
string Text="Actions:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_target_detail
int X=1043
int Y=1025
int Width=257
int Height=49
boolean Enabled=false
string Text="Charterers:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_target_detail
int X=1957
int Y=1025
int Width=266
int Height=49
boolean Enabled=false
string Text="Key Codes:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_new_action from commandbutton within w_target_detail
int X=129
int Y=1361
int Width=275
int Height=81
int TabOrder=110
string Text="New"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_new
  
 Event	 : Clisked!, override ancestor script 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-07-96

 Description :  Open detail window to make new action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Override ancestor script to send action structure in PowerObjectParm

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

s_action lstr_parm

lstr_parm.action_key  = 0
lstr_parm.target_key = il_parametre
OpenSheetWithParm(w_action_detail,  lstr_parm, w_tramos_main, 7, original!)

end on

on getfocus;dw_support.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_chartererrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

end on

type cb_modify_action from commandbutton within w_target_detail
int X=421
int Y=1361
int Width=275
int Height=81
int TabOrder=170
string Text="Modify"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_actions
  
 Object     : cb_modify_action
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 28-08-96

 Description : Opens window to edit details of chosen action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		1.0	 		JH		Initial version
26-08-96		1.0			KHK		Now used in connection with Targets
  
************************************************************************************/

Long ll_row
s_action lstr_parm

ll_row = dw_actions.GetRow()
// Get the selected action key
lstr_parm.action_key = dw_actions.GetItemNumber(ll_row,"ccs_acts_pk")
lstr_parm.target_key = il_parametre

IF lstr_parm.action_key > 0 THEN
	OpenSheetWithParm(w_action_detail,lstr_parm,w_tramos_main,7,Original!)
END IF

wf_enable_disable_functions(dw_support)


end on

type cb_delete_action from commandbutton within w_target_detail
int X=714
int Y=1361
int Width=275
int Height=81
int TabOrder=150
string Text="Delete"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_actions
  
 Object     : cb_delete_action
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 28-08-96

 Description : Delete an action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0	 		JH		Initial version
28-08-96		1.0			KHK		Now used in connection with Targets (names on ClickButtons modified)
  
************************************************************************************/

long ll_tmp_pk

IF MessageBox("Delete","You are about to DELETE !~r~n" + &
					  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return

ll_tmp_pk = dw_actions.GetItemNumber(dw_actions.GetRow(),"ccs_acts_pk")

DELETE FROM ACTION_KEYCODES  
   WHERE ACTION_KEYCODES.CCS_ACTS_PK = :ll_tmp_pk;

dw_actions.DeleteRow(dw_actions.GetRow())
dw_actions.Update()

wf_enable_disable_functions(dw_actions)

end on

type cb_modify_charterer_list from commandbutton within w_target_detail
int X=1628
int Y=1361
int Width=284
int Height=81
int TabOrder=180
string Text="Modify List"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_modify_charterers_list
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek

 Date       : 27-08-96

 Description : Activate the userobject holding charterers related to the actual target

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0	 		KHK		Initial version
05-09-96					JH		Disable buttons while window with user object is open
  
************************************************************************************/

LONG	ll_cur_row

//////////////////////////////// Call the UserObject "w_chart_target_select" with the actual target as parameter
ll_cur_row = dw_target_detail.GetRow()

/* Disable buttons in buttom of window*/
cb_close.Enabled = FALSE
cb_refresh.Enabled = FALSE
cb_update.Enabled = FALSE

IF OpenWithParm(w_chart_target_select,dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk")) = 1THEN
	dw_charterers.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	cb_close.Enabled = TRUE
	cb_refresh.Enabled = TRUE
	cb_update.Enabled = TRUE
END IF
	
end on

on getfocus;dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_keycodes)

end on

type cb_modify_keycode_list from commandbutton within w_target_detail
int X=2524
int Y=1361
int Width=284
int Height=81
int TabOrder=160
string Text="Modify List"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : cb_modify_keycodes_list
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek

 Date       : 29-08-96

 Description : Activate the userobject holding keycodes related to the actual target

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-08-96		1.0	 		KHK		Initial version
05-09-96					JH		Disable buttom buttons while responce window with user object  is open
  
************************************************************************************/

LONG	ll_cur_row

//////////////////////////////// Call the UserObject "w_keyc_target_select" with the actual target as parameter
ll_cur_row = dw_target_detail.GetRow()


/* Disable buttons in buttom of window*/
cb_close.Enabled = FALSE
cb_refresh.Enabled = FALSE
cb_update.Enabled = FALSE

IF OpenWithParm(w_keyc_target_select,dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk")) = 1THEN
	dw_keycodes.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	cb_close.Enabled = TRUE
	cb_refresh.Enabled = TRUE
	cb_update.Enabled = TRUE
END IF
end on

on getfocus;dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_chartererrow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)

end on

type cb_refresh from commandbutton within w_target_detail
int X=897
int Y=1473
int Width=348
int Height=81
int TabOrder=120
string Text="Refresh"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;long ll_cur_row

IF istr_parm.target_pk = 0 THEN
	/*New target; Blank*/
	ll_cur_row = dw_target_detail.InsertRow(0)
	dw_target_detail.ScrollToRow(ll_cur_row)

ELSE
	//*Modify a target; Bring original data */

	dw_target_detail.Retrieve(istr_parm.target_pk)
	ll_cur_row = dw_target_detail.GetRow()
	dw_actions.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	dw_charterers.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	dw_keycodes.Retrieve(dw_target_detail.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
	wf_retrieve_support()	/* Retrieve and calculate Support */

	dw_support.SelectRow(0,FALSE)
	dw_actions.SelectRow(0,FALSE)
	dw_charterers.SelectRow(0,FALSE)
	dw_keycodes.SelectRow(0,FALSE)

	il_supportRow = 0
	il_actionrow = 0
	il_chartererrow = 0
	il_keycoderow = 0
END IF

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

dw_target_detail.SetFocus()

end on

type cb_update from commandbutton within w_target_detail
int X=1281
int Y=1473
int Width=348
int Height=81
int TabOrder=140
string Text="Update"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;////////////////////////////// Call the local save-function

///////  This is done to update correct when to salespersons with same last name Leith /////////////
DatawindowChild dwc
String ls_userid

dw_target_detail.GetChild("userid", dwc)
ls_userid = dwc.GetItemString(dwc.GetRow(),"userid")
dw_target_detail.SetItem(1,"targetuserid",ls_userid)
//////  Correct end ////////////////////////////////////////////////////////////////////////////////

IF wf_save() = 1 THEN
	Close(Parent)
	Return
END IF



//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

end event

type cb_close from commandbutton within w_target_detail
int X=1665
int Y=1473
int Width=348
int Height=81
int TabOrder=130
string Text="Close"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_close
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 26-08-96

 Description : Close the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
26-08-96		1.0 			KHK		Initial version
  
************************************************************************************/
integer li_answer

dw_target_detail.AcceptText()

IF dw_target_detail.ModifiedCount() > 0 THEN
	li_answer = MessageBox("Warning","You have modified the target!! Do you wish to update before closing?",Question!,YesNOCancel!)
	IF li_answer = 1 THEN
		/* save changes before closing*/
// 	Next 2 lines emengency fix untill database has been changed and column ccs_targ_type has been dropped. See 
//	script for cb_update clicked. When corrected use wf_save() instead of next 2 lines.
		cb_update.TriggerEvent(Clicked!)
		Return

	ELSEIF li_answer = 3 THEN
		Return
	END IF
END IF

Close(parent)

end on

type st_4 from statictext within w_target_detail
int X=92
int Y=673
int Width=220
int Height=65
boolean Enabled=false
string Text="Support:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type r_1 from rectangle within w_target_detail
int X=74
int Y=657
int Width=2762
int Height=337
boolean Enabled=false
int LineThickness=5
long FillColor=12632256
end type

type dw_support from u_datawindow_sqlca within w_target_detail
int X=92
int Y=737
int Width=2341
int Height=241
int TabOrder=40
string DataObject="d_support_list"
boolean VScrollBar=true
end type

on getfocus;call u_datawindow_sqlca::getfocus;dw_actions.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_actionrow = 0
il_chartererrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

end on

on itemchanged;call u_datawindow_sqlca::itemchanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : dw_support
  
 Event	 :Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :30-07-96

 Description :Overide ancestor script

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	-----	-------------------------------------
30-07-96	1.0		JH		Initial version
26-08-96	1.0		JH		Now used in connection with Targets
10/9-97	1.0		BO		Remove obsolete functions in PB 5.0
************************************************************************************/

il_supportrow = row

if il_supportrow = 0 Then il_supportrow = GetSelectedRow(0)

If (il_supportrow > 0) And (il_supportrow <> GetSelectedRow(il_supportrow - 1)) Then 
	SelectRow(0,false)
	scrollToRow(il_supportrow)
	SelectRow(il_supportrow,True)
	wf_enable_disable_functions(This)
End if

//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end event

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_modify_support.TriggerEvent(Clicked!)
end on

type dw_actions from u_datawindow_sqlca within w_target_detail
int X=110
int Y=1073
int Width=897
int Height=273
int TabOrder=10
string DataObject="d_ccs_actions_pr_target"
boolean VScrollBar=true
end type

on getfocus;call u_datawindow_sqlca::getfocus;dw_support.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_chartererrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_charterers)
wf_enable_disable_functions(dw_keycodes)

end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_modify_action.TriggerEvent(Clicked!)
end on

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_action
  
 Object     : 
  
 Event	 :Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       :27-08-96

 Description :{description/none}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- -------	----- -------------------------------------
30-07-96	1.0	 	JH		Initial version
27-08-96	1.0	 	KHK	Now used in connection with Targets
10-09-97	1.0		BO		Remove the obsolete functions in PB 5.0
************************************************************************************/


il_actionrow = row

if il_actionrow = 0 Then il_actionrow = GetSelectedRow(0)

If (il_actionrow > 0) And (il_actionrow <> GetSelectedRow(il_actionrow - 1)) Then 
	SelectRow(0,false)
	scrollToRow(il_actionrow)
	SelectRow(il_actionrow,True)
	wf_enable_disable_functions(This)
End if

//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end event

on itemchanged;call u_datawindow_sqlca::itemchanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

type dw_charterers from u_datawindow_sqlca within w_target_detail
int X=1025
int Y=1073
int Width=897
int Height=273
int TabOrder=100
string DataObject="d_ccs_chart_pr_target"
boolean VScrollBar=true
end type

on getfocus;call u_datawindow_sqlca::getfocus;dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_keycodes.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_keycoderow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_keycodes)

end on

on itemchanged;call u_datawindow_sqlca::itemchanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_charterer
  
 Object     : 
  
 Event	 :Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       :27-08-96

 Description :{description/none}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	----- -------------------------------------
30-07-96	1.0	 	JH		Initial version
27-08-96	1.0	 	KHK	Now used in connection with Targets
10-09-97	1.0		BO		Remove the obsolete functions in PB 5.0
************************************************************************************/

il_chartererrow = row

if il_chartererrow = 0 Then il_chartererrow = GetSelectedRow(0)

If (il_chartererrow > 0) And (il_chartererrow <> GetSelectedRow(il_chartererrow - 1)) Then 
	SelectRow(0,false)
	scrollToRow(il_chartererrow)
	SelectRow(il_chartererrow,True)
	wf_enable_disable_functions(This)
End if

//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end event

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_modify_charterer_list.TriggerEvent(Clicked!)
end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

type dw_keycodes from u_datawindow_sqlca within w_target_detail
int X=1939
int Y=1073
int Width=897
int Height=273
int TabOrder=20
string DataObject="d_keycodes_pr_target"
boolean VScrollBar=true
end type

on getfocus;call u_datawindow_sqlca::getfocus;dw_support.SelectRow(0,FALSE)
dw_actions.SelectRow(0,FALSE)
dw_charterers.SelectRow(0,FALSE)

il_supportRow = 0
il_actionrow = 0
il_chartererrow = 0

wf_enable_disable_functions(dw_target_detail)
wf_enable_disable_functions(dw_support)
wf_enable_disable_functions(dw_actions)
wf_enable_disable_functions(dw_charterers)

end on

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_keycodes
  
 Object     : 
  
 Event	 :Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       :27-08-96

 Description :{description/none}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	----- -------------------------------------
30-07-96	1.0	 	JH		Initial version
27-08-96	1.0	 	KHK	Now used in connection with Targets
10-09-97	1.0		BO		Remove the obsolete functions in PB 5.0
************************************************************************************/

il_keycoderow = row

if il_keycoderow = 0 Then il_keycoderow = GetSelectedRow(0)

If (il_keycoderow > 0) And (il_keycoderow <> GetSelectedRow(il_keycoderow - 1)) Then 
	SelectRow(0,false)
	scrollToRow(il_keycoderow)
	SelectRow(il_keycoderow,True)
	wf_enable_disable_functions(This)
End if

//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end event

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_modify_keycode_list.TriggerEvent(Clicked!)
end on

on itemchanged;call u_datawindow_sqlca::itemchanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

