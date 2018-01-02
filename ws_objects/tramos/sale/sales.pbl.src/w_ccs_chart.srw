$PBExportHeader$w_ccs_chart.srw
$PBExportComments$This window lists the detail of a choosen charterer for the salessystem.
forward
global type w_ccs_chart from w_sale_base
end type
type cb_text from uo_cb_base within w_ccs_chart
end type
type cb_meetings from uo_cb_base within w_ccs_chart
end type
type cb_articles from uo_cb_base within w_ccs_chart
end type
type cb_close from uo_cb_base within w_ccs_chart
end type
type uo_keycodes from u_cross_select within w_ccs_chart
end type
type cb_keycodes from uo_cb_base within w_ccs_chart
end type
type dw_targets from u_datawindow_sqlca within w_ccs_chart
end type
type cb_target_modify from uo_cb_base within w_ccs_chart
end type
type cb_refresh_support from uo_cb_base within w_ccs_chart
end type
type cb_refresh_targets from uo_cb_base within w_ccs_chart
end type
type gb_1 from uo_gb_base within w_ccs_chart
end type
type cb_contacts from uo_cb_base within w_ccs_chart
end type
type cb_update from uo_cb_base within w_ccs_chart
end type
type dw_support from u_datawindow_sqlca within w_ccs_chart
end type
type cb_sup_new from uo_cb_base within w_ccs_chart
end type
type cb_sup_modify from uo_cb_base within w_ccs_chart
end type
type cb_sup_delete from uo_cb_base within w_ccs_chart
end type
type gb_2 from uo_gb_base within w_ccs_chart
end type
type cb_refresh from uo_cb_base within w_ccs_chart
end type
type dw_ccs_chart from u_datawindow_sqlca within w_ccs_chart
end type
end forward

global type w_ccs_chart from w_sale_base
integer x = 0
integer y = 124
integer width = 2926
integer height = 1680
string title = "CCS Charterer Modify"
cb_text cb_text
cb_meetings cb_meetings
cb_articles cb_articles
cb_close cb_close
uo_keycodes uo_keycodes
cb_keycodes cb_keycodes
dw_targets dw_targets
cb_target_modify cb_target_modify
cb_refresh_support cb_refresh_support
cb_refresh_targets cb_refresh_targets
gb_1 gb_1
cb_contacts cb_contacts
cb_update cb_update
dw_support dw_support
cb_sup_new cb_sup_new
cb_sup_modify cb_sup_modify
cb_sup_delete cb_sup_delete
gb_2 gb_2
cb_refresh cb_refresh
dw_ccs_chart dw_ccs_chart
end type
global w_ccs_chart w_ccs_chart

type variables
private Long il_parametre

Private Long il_supportRow = 0

Private Long il_targetRow
end variables

forward prototypes
public subroutine wf_enable_all_buttons ()
public subroutine wf_sole_enable (commandbutton a_cb)
public subroutine wf_dw_buttons (datawindow a_dw)
public subroutine wf_retrieve_support ()
end prototypes

public subroutine wf_enable_all_buttons ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : wf_enable_all_buttons
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :29-07-96

 Description : Enables all buttons in the windows buttum line

 Arguments :none

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-07-96		1.0	 		JH		Initial version
  
************************************************************************************/

cb_update.enabled = TRUE
cb_text.enabled = TRUE
cb_meetings.enabled = TRUE
cb_keycodes.enabled = TRUE
cb_refresh.enabled = TRUE
cb_contacts.enabled = TRUE
cb_close.enabled = TRUE
cb_articles.enabled = TRUE
end subroutine

public subroutine wf_sole_enable (commandbutton a_cb);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : wf_sole_enable(as_button)
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 24-07-96

 Description : Disables all other buttons than the one specified by as_button. 

 Arguments : String as_button is the name of the button to be the only one enabled.

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
24-07-96		1.0	 		JH		Initial version
  
************************************************************************************/

CHOOSE CASE a_cb
	CASE cb_update
		cb_text.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_text
		cb_update.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_meetings
		cb_update.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_text.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_keycodes
		cb_update.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_text.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_contacts
		cb_update.enabled = FALSE
		cb_text.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_close.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_close
		cb_update.enabled = FALSE
		cb_text.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_articles.enabled = FALSE
	CASE cb_articles
		cb_update.enabled = FALSE
		cb_text.enabled = FALSE
		cb_refresh.enabled = FALSE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
	CASE cb_refresh
		cb_update.enabled = FALSE
		cb_text.enabled = FALSE
		cb_refresh.enabled = TRUE
		cb_meetings.enabled = FALSE
		cb_keycodes.enabled = FALSE
		cb_contacts.enabled = FALSE
		cb_close.enabled = FALSE
END CHOOSE

end subroutine

public subroutine wf_dw_buttons (datawindow a_dw);

//CHOOSE CASE a_dw 
//	CASE dw_support

		cb_sup_delete.enabled =il_supportrow > 0
		cb_sup_modify.enabled = cb_sup_delete.enabled


//	CASE dw_targets
//		cb_target_modify.enabled = il_targetrow > 0
//END CHOOSE

end subroutine

public subroutine wf_retrieve_support ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : wf_retrieve_support
  
 Event	 : 

 Scope     :Public 

 ************************************************************************************

 Author    : Jeannette Holland
   
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

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : 
  
 Event	 : Open

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 17-07-96

 Description :Charterer details to be retrieved and shown in datawindow

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
17-07-96				1.0 		JH				Initial version	
07-08-96							JH & KHK		Added code to compute support
08-08-96							JH				Added wf_retrieve_support
23-08-96							JH				Added check on cb_close clicked event + 
													added cb_refresh_support and cb_refresh_targets
03-03-97							BHO			Make the fields credit_rating_type and 
													credit_rating_date readonly if the user has user-status
************************************************************************************/
Pointer lp_old_pointer

lp_old_pointer =  SetPointer(HourGlass!)

il_parametre  = Message.DoubleParm
dw_ccs_chart.Retrieve(il_parametre)
COMMIT USING SQLCA;

/* Modify the taborder to include the extended attributes for the sales system*/

dw_ccs_chart.SetTabOrder("chart_sn", 0)
dw_ccs_chart.SetTabOrder("chart_chart_competitor", 140)
dw_ccs_chart.SetTabOrder("chart_ccs_chgp_pk", 150)
dw_ccs_chart.SetTabOrder("chart_chart_cp_type", 160)

/* If user´s status is user the fields credit_rating_type 
	and credit_rating_date is set to readonly*/ 
if uo_global.ii_access_level < 2 then
	dw_ccs_chart.SetTabOrder("chart_chart_cr_rate_type",0)
	dw_ccs_chart.SetTabOrder("chart_chart_cr_rate_d", 0)
else
	dw_ccs_chart.SetTabOrder("chart_chart_cr_rate_type", 170)
	dw_ccs_chart.SetTabOrder("chart_chart_cr_rate_d", 180)
end if

dw_ccs_chart.SetTabOrder("chart_chart_credit_info_d", 190)
dw_ccs_chart.SetTabOrder("chart_chart_br_d", 200)
dw_ccs_chart.SetTabOrder("chart_chart_an_rp_d", 210)
dw_ccs_chart.SetTabOrder("chart_chart_bank_info_d", 220)
dw_ccs_chart.SetTabOrder("chart_chart_sp_rp_d", 230)

dw_targets.Retrieve(il_parametre)
COMMIT USING SQLCA;

/* Retrieve and calculate Support */
wf_retrieve_support()


uo_keycodes.visible = FALSE

This.Title = "Modify Charterer: "+dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_sn")

dw_ccs_chart.SetFocus()

SetPointer(lp_old_pointer)
end on

on close;call w_sale_base::close;this.windowState = Normal!
end on

on w_ccs_chart.create
int iCurrent
call super::create
this.cb_text=create cb_text
this.cb_meetings=create cb_meetings
this.cb_articles=create cb_articles
this.cb_close=create cb_close
this.uo_keycodes=create uo_keycodes
this.cb_keycodes=create cb_keycodes
this.dw_targets=create dw_targets
this.cb_target_modify=create cb_target_modify
this.cb_refresh_support=create cb_refresh_support
this.cb_refresh_targets=create cb_refresh_targets
this.gb_1=create gb_1
this.cb_contacts=create cb_contacts
this.cb_update=create cb_update
this.dw_support=create dw_support
this.cb_sup_new=create cb_sup_new
this.cb_sup_modify=create cb_sup_modify
this.cb_sup_delete=create cb_sup_delete
this.gb_2=create gb_2
this.cb_refresh=create cb_refresh
this.dw_ccs_chart=create dw_ccs_chart
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_text
this.Control[iCurrent+2]=this.cb_meetings
this.Control[iCurrent+3]=this.cb_articles
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.uo_keycodes
this.Control[iCurrent+6]=this.cb_keycodes
this.Control[iCurrent+7]=this.dw_targets
this.Control[iCurrent+8]=this.cb_target_modify
this.Control[iCurrent+9]=this.cb_refresh_support
this.Control[iCurrent+10]=this.cb_refresh_targets
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.cb_contacts
this.Control[iCurrent+13]=this.cb_update
this.Control[iCurrent+14]=this.dw_support
this.Control[iCurrent+15]=this.cb_sup_new
this.Control[iCurrent+16]=this.cb_sup_modify
this.Control[iCurrent+17]=this.cb_sup_delete
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.cb_refresh
this.Control[iCurrent+20]=this.dw_ccs_chart
end on

on w_ccs_chart.destroy
call super::destroy
destroy(this.cb_text)
destroy(this.cb_meetings)
destroy(this.cb_articles)
destroy(this.cb_close)
destroy(this.uo_keycodes)
destroy(this.cb_keycodes)
destroy(this.dw_targets)
destroy(this.cb_target_modify)
destroy(this.cb_refresh_support)
destroy(this.cb_refresh_targets)
destroy(this.gb_1)
destroy(this.cb_contacts)
destroy(this.cb_update)
destroy(this.dw_support)
destroy(this.cb_sup_new)
destroy(this.cb_sup_modify)
destroy(this.cb_sup_delete)
destroy(this.gb_2)
destroy(this.cb_refresh)
destroy(this.dw_ccs_chart)
end on

type cb_text from uo_cb_base within w_ccs_chart
integer x = 1335
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 140
string text = "&Text"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_text
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description :Expands text field in a responce window; so the user can edit this 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/


s_expand_text lstr_parm
String ls_rtn

dw_ccs_chart.AcceptText()
lstr_parm.text =dw_ccs_chart.GetItemString(1,"chart_chart_sales_desc")  
lstr_parm.name = dw_ccs_chart.GetItemString(1,"chart_sn")


/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)

ls_rtn = Message.StringParm
/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_ccs_chart.SetItem(1,"chart_chart_sales_desc",ls_rtn)
END IF




end on

type cb_meetings from uo_cb_base within w_ccs_chart
integer x = 1006
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 130
string text = "&Meetings"
end type

on clicked;call uo_cb_base::clicked;/* Open list of meeting reports and action status descriptions for this charterer */

s_chart lstr_parm

lstr_parm.chart_nr = dw_ccs_chart.GetItemNumber(dw_ccs_chart.GetRow(),"chart_nr")
lstr_parm.chart_sn = dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_sn")

OpenSheetWithParm(w_mreports,lstr_parm,w_tramos_main,7,Original!)
end on

type cb_articles from uo_cb_base within w_ccs_chart
integer x = 347
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 110
string text = "&Articles"
end type

event clicked;call super::clicked;s_chart lstr_parm

lstr_parm.chart_nr = dw_ccs_chart.GetItemNumber(dw_ccs_chart.GetRow(),"chart_nr")
lstr_parm.chart_sn = dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_sn")

OpenSheetWithParm(w_articles,lstr_parm,w_tramos_main,7,Original!)
end event

type cb_close from uo_cb_base within w_ccs_chart
integer x = 2523
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 170
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


dw_ccs_chart.AcceptText()

/* test if any changes were made */
IF dw_ccs_chart.ModifiedCount() > 0  THEN
	li_ans = MessageBox("Warning","You have modified the Charterer! Do you wish to save "&
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

type uo_keycodes from u_cross_select within w_ccs_chart
boolean visible = false
integer x = 18
integer y = 224
integer width = 2816
integer height = 1232
integer taborder = 180
end type

on constructor;call u_cross_select::constructor;THIS.visible = True
s_cross_select_list lstr_list
lstr_list.dwin_list = "d_keycode_list"
lstr_list.dwin_selects = "d_chart_keys"
lstr_list.select_key = il_parametre
lstr_list.column_names[1] = "ccs_keyc_code" 
lstr_list.column_names[2] = "ccs_keyc_desc"
lstr_list.column_headers[1] = "Key Code" 
lstr_list.column_headers[2] = "Description" 
lstr_list.list_key_column_name = "ccs_keyc_pk"
lstr_list.selects_key_column_name =  "charterer_keycodes_ccs_keyc_pk"
lstr_list.selects_key2_column_name = "charterer_keycodes_chart_nr"
THIS.uf_construct (lstr_list)
end on

on destructor;call u_cross_select::destructor;
wf_enable_all_buttons()
This.visible = False
end on

on uo_keycodes.destroy
call u_cross_select::destroy
end on

type cb_keycodes from uo_cb_base within w_ccs_chart
integer x = 18
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 100
string text = "&Key Codes"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_keycodes
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 25-07-96

 Description : Activate the userobject holding keycodes (uo_1)

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
// Disable all other control buttons 
wf_sole_enable(cb_keycodes)

// "Build" the user object
uo_keycodes.TriggerEvent(constructor!)
uo_keycodes.SetFocus()

this.enabled = FALSE



end on

type dw_targets from u_datawindow_sqlca within w_ccs_chart
integer x = 1335
integer y = 992
integer width = 1499
integer height = 352
integer taborder = 70
string dataobject = "d_chart_targets"
boolean hscrollbar = true
boolean vscrollbar = true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : dw_targets
  
 Event	 : RowFocusChanged

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :30-07-96

 Description :Take use of ancestors script

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		1.0	 		JH		Initial version
  
************************************************************************************/
ib_auto =TRUE

il_targetrow = GetSelectedRow(0)


end on

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : dw_Target
  
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
-------- ------- 	----- -------------------------------------
30-07-96	1.0	 	JH		Initial version
10/9-97	1.0		BO		Remove obsolete functions in PB 5.0  
************************************************************************************/
//Long ll_row

	/*il_targetrow = GetClickedRow () */
	il_targetrow = row
	
	if il_targetrow = 0 Then il_targetrow = GetSelectedRow(0)

	If (il_targetrow > 0) And (il_targetrow <> GetSelectedRow(il_targetrow - 1)) Then 
		SelectRow(0,false)
		scrollToRow(il_targetrow)
		SelectRow(il_targetrow,True)
		wf_dw_buttons(This)
	End if
end event

on getfocus;call u_datawindow_sqlca::getfocus;Long ll_row

ll_row = GetRow()

IF ll_row > 0 AND ll_row <> GetSelectedRow(0) THEN
	SelectRow(0,FALSE)
	ScrollToRow(ll_row)
	SelectRow(ll_row,TRUE)
	il_targetrow = GetSelectedRow(0)
	wf_dw_buttons(This)
	
END IF
end on

type cb_target_modify from uo_cb_base within w_ccs_chart
integer x = 2194
integer y = 1360
integer width = 311
integer height = 80
integer taborder = 80
string text = "Modify List"
end type

event clicked;call super::clicked;Long ll_cur_row

// Call the window with UserObject "w_chart_target_select" with the actual target as parameter
ll_cur_row = dw_ccs_chart.GetRow()
OpenSheetWithParm(w_targets_chart_select,dw_ccs_chart.GetItemNumber(ll_cur_row,"chart_nr"),w_tramos_main,7,Original!)
end event

type cb_refresh_support from uo_cb_base within w_ccs_chart
integer x = 1006
integer y = 1360
integer width = 293
integer height = 80
integer taborder = 60
string text = "Refresh"
end type

on clicked;call uo_cb_base::clicked;wf_retrieve_support()

dw_support.SetFocus()

end on

type cb_refresh_targets from uo_cb_base within w_ccs_chart
integer x = 2523
integer y = 1360
integer width = 311
integer height = 80
integer taborder = 90
string text = "Refresh"
end type

on clicked;call uo_cb_base::clicked;dw_targets.Retrieve(il_parametre)
dw_targets.SetFocus()

end on

type gb_1 from uo_gb_base within w_ccs_chart
integer x = 1317
integer y = 928
integer width = 1536
integer height = 528
integer taborder = 0
integer weight = 700
string text = "Targets"
end type

type cb_contacts from uo_cb_base within w_ccs_chart
integer x = 677
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 120
string text = "&Contacts"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_contacts
  
 Event	 : clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 29-07-96

 Description : Opens a list of  the charterers contact persons.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-07-96		1.0	 		JH		Initial version
  
************************************************************************************/
// Structure to send in ObjectPowerParm
s_contact lstr_param

// Put charterer number in the parameter structure
lstr_param.owner_id = il_parametre
lstr_param.owner_short_name = dw_ccs_chart.GetItemString(1,"chart_sn")
// Indicate that it is a charterers contacts
lstr_param.chart_or_broker = "C"

OpenSheetWithParm(w_contacts,lstr_param,w_tramos_main,7,Original!)

end on

type cb_update from uo_cb_base within w_ccs_chart
integer x = 2194
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 160
string text = "Update"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_update
  
 Event	 : Clicled

 Scope     : Local

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 16-07-96

 Description :Updates a charterer from the salessystem

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
 16-07-96		1.0			JH		Initial version
 18-07-96					JH		Added code to control update of blue fields
 26-07-96					JH		Added f_update() 
************************************************************************************/


// Do not update before required (blue) fields have been entered

dw_ccs_chart.AcceptText()
IF IsNull(dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_sn")) OR dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_sn") = "" THEN
	MessageBox("Update Error","Please enter a Charterer Short Name!")
	Return
END IF	
IF IsNull(dw_ccs_chart.GetItemstring(dw_ccs_chart.GetRow(),"chart_n_1")) OR dw_ccs_chart.GetItemstring(dw_ccs_chart.GetRow(),"chart_n_1") = ""  THEN
	MessageBox("Update Error","Please enter a Charterer Full Name (Blue Line)!")
	Return
END IF
IF IsNull(dw_ccs_chart.GetItemString(dw_ccs_chart.GetRow(),"chart_nom_acc_nr")) THEN
	MessageBox("Update Error","Please enter a Charterer Nominal account nr.!")
	Return
END IF	
IF IsNull(dw_ccs_chart.GetItemNumber(dw_ccs_chart.GetRow(),"chart_ccs_chgp_pk")) THEN
	MessageBox("Update Error","Please choose a Charterer Group!")
	Return
END IF	

// All Required (blue) fields are entered

f_update(dw_ccs_chart,w_tramos_main)
Close(parent)
end event

type dw_support from u_datawindow_sqlca within w_ccs_chart
integer x = 37
integer y = 992
integer width = 1262
integer height = 352
integer taborder = 20
string dataobject = "d_support_chart"
boolean hscrollbar = true
boolean vscrollbar = true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : dw_support
  
 Event	 : RowFocusChanged

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :30-07-96

 Description : Take us of ancestors script

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		1.0	 		JH		Initial version
  
************************************************************************************/
ib_auto = TRUE



il_supportrow = GetSelectedRow(0)

wf_dw_buttons(This)
end on

on getfocus;call u_datawindow_sqlca::getfocus;Long ll_row

ll_row = GetRow()

IF ll_row > 0 AND ll_row <> GetSelectedRow(0) THEN
	SelectRow(0,FALSE)
	ScrollToRow(ll_row)
	SelectRow(ll_row,TRUE)
	il_supportrow = GetSelectedRow(0)
	wf_dw_buttons(This)
	
END IF

end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_sup_modify.TriggerEvent(Clicked!)
end on

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
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
-------- ------- 	----- -------------------------------------
30-07-96	1.0	 	JH		Initial version
10/9-97	1.0		BO		Remove obsolete functions in PB 5.0 
11-12-97	2.0		JEH	Inserted check to stop processing if data window is empty
************************************************************************************/

	/* il_supportrow = GetClickedRow ()*/
	il_supportrow = row
	
	
	/* Stop processing if there isn't any support rows */
	if RowCount() = 0 Then Return 
	
	if il_supportrow = 0 Then
		il_supportrow = GetSelectedRow(0)
	ElseIf (il_supportrow > 0) And (il_supportrow <> GetSelectedRow(il_supportrow - 1)) Then 
		SelectRow(0,false)
		scrollToRow(il_supportrow)
		SelectRow(il_supportrow,True)
		wf_dw_buttons(This)
	End if
end event

type cb_sup_new from uo_cb_base within w_ccs_chart
integer x = 18
integer y = 1360
integer width = 311
integer height = 80
integer taborder = 30
string text = "New"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_sup_new
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 02-08-96

 Description : Create a new support definition

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
S_support lstr_parm
w_supdef lw_def


/* Init the structure for a new support definiton*/
lstr_parm.sdef_pk = 0
/* The support definition belongs to a charterer*/
lstr_parm.sdef_chart = TRUE
/* Charterer key*/
lstr_parm.sdef_ownerid = dw_ccs_chart.GetItemNumber(dw_ccs_chart.GetRow(),"chart_nr")

OpenSheetWithParm(lw_def,lstr_parm,w_tramos_main,7,Original!)




end on

type cb_sup_modify from uo_cb_base within w_ccs_chart
integer x = 347
integer y = 1360
integer width = 311
integer height = 80
integer taborder = 40
boolean enabled = false
string text = "Modify"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_sup_modify
  
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
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96			1.0	 		JH				Initial version
11-12-97			2.0			JEH			Inserted check to stop processing if data window is empty  
************************************************************************************/

Long ll_row
s_support lstr_parm
w_supdef lw_def

/* stop processing if there is no rows with support */
If dw_support.RowCount() = 0 Then Return

ll_row = dw_support.GetRow()
// Get the selected support definitions key
lstr_parm.sdef_pk = dw_support.GetItemNumber(ll_row,"ccs_sdef_ccs_sdef_pk")
// Get the selected support definition description
lstr_parm.sdef_desc = dw_support.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc") 


IF lstr_parm.sdef_pk > 0 THEN
	OpenSheetWithParm(lw_def,lstr_parm,w_tramos_main,7,Original!)
END IF



end event

type cb_sup_delete from uo_cb_base within w_ccs_chart
integer x = 677
integer y = 1360
integer width = 311
integer height = 80
integer taborder = 50
boolean enabled = false
string text = "Delete"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_sup_delete
  
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
  
************************************************************************************/

Long ll_row

ll_row = dw_support.GetRow()



IF  ll_row <> 0 THEN
	IF MessageBox("Delete","You are about to DELETE !~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 &
                                            THEN return
	
	dw_support.DeleteRow(ll_row)
	dw_support.Update()
			IF SQLCA.SQLCode = 0 THEN
				COMMIT;
			ELSE
				ROLLBACK;
			END IF
	cb_sup_modify.Enabled = FALSE
	cb_sup_delete.Enabled = FALSE
END IF	




end on

type gb_2 from uo_gb_base within w_ccs_chart
integer y = 928
integer width = 1317
integer height = 528
integer taborder = 0
integer weight = 700
string text = "Support"
end type

type cb_refresh from uo_cb_base within w_ccs_chart
integer x = 1865
integer y = 1472
integer width = 311
integer height = 80
integer taborder = 150
string text = "Cancel"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_ccs_chart
  
 Object     : cb_refresh
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :29-07-96

 Description : Enables all buttons in the windows buttum line

 Arguments :none

 Returns   : none  

 Variables : Refreshes the datawindows in the window.

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-07-96		1.0	 		JH		Initial version
30-07-96					JH		Added refresh dw_support and dw_targets
  
************************************************************************************/


dw_ccs_chart.Retrieve(il_parametre)






end on

type dw_ccs_chart from u_datawindow_sqlca within w_ccs_chart
integer x = 18
integer y = 16
integer width = 2834
integer height = 896
integer taborder = 10
string dataobject = "dw_charterer"
borderstyle borderstyle = stylelowered!
end type

