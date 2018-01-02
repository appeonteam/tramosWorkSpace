$PBExportHeader$w_supdef.srw
$PBExportComments$This window shows the details of a support definition.
forward
global type w_supdef from w_sale_base
end type
type cb_close from uo_cb_base within w_supdef
end type
type cb_showlist from uo_cb_base within w_supdef
end type
type dw_sdef_list from u_datawindow_sqlca within w_supdef
end type
type cb_cancel from uo_cb_base within w_supdef
end type
type cb_update from uo_cb_base within w_supdef
end type
type dw_supdef from u_datawindow_sqlca within w_supdef
end type
type cb_list_ok from uo_cb_base within w_supdef
end type
type cb_list_cancel from uo_cb_base within w_supdef
end type
end forward

global type w_supdef from w_sale_base
integer x = 64
integer y = 140
integer width = 2789
integer height = 1552
cb_close cb_close
cb_showlist cb_showlist
dw_sdef_list dw_sdef_list
cb_cancel cb_cancel
cb_update cb_update
dw_supdef dw_supdef
cb_list_ok cb_list_ok
cb_list_cancel cb_list_cancel
end type
global w_supdef w_supdef

type variables
S_support istr_parm
end variables

forward prototypes
public function integer wf_parse (string as_text)
public subroutine wf_updatebuttons (commandbutton a_cb)
public subroutine wf_retrieve ()
public subroutine documentation ()
end prototypes

public function integer wf_parse (string as_text);Return 0
end function

public subroutine wf_updatebuttons (commandbutton a_cb);CHOOSE CASE a_cb
	CASE cb_showlist
		cb_update.Enabled = False
		cb_close.Enabled = False
		cb_cancel.Enabled = False
		dw_sdef_list.visible = TRUE
		cb_showlist.visible = FALSE
		cb_list_cancel.visible = TRUE
		cb_list_ok.visible = TRUE
	CASE cb_list_cancel 
		cb_update.Enabled = TRUE
		cb_close.Enabled = TRUE
		cb_cancel.Enabled = TRUE
		dw_sdef_list.visible = FALSE
		cb_list_cancel.visible = FALSE
		cb_showlist.visible = TRUE
		cb_list_ok.visible = FALSE
	CASE cb_list_ok
		cb_update.Enabled = TRUE
		cb_close.Enabled = TRUE
		cb_cancel.Enabled = TRUE
		dw_sdef_list.visible = FALSE
		cb_list_ok.visible = FALSE
		cb_showlist.visible = TRUE
		cb_list_cancel.visible = FALSE
		
END CHOOSE

end subroutine

public subroutine wf_retrieve ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_supdef
  
 Object     : wf_retrieve
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :29-08-96

 Description : Retrieves data for detail and list datawindow

 Arguments : none

 Returns   : none  

 Variables : 

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-08-96		1.0	 		JH		Initial version

************************************************************************************/


Long ll_newrow 


dw_supdef.SetRedraw(FALSE)
IF istr_parm.sdef_pk > 0 THEN
/* Edit a existing Support definition */
	This.Title = "Modify Support Definition: "+istr_parm.sdef_desc
	dw_supdef.Retrieve(istr_parm.sdef_pk)
	COMMIT USING SQLCA;
	dw_supdef.SetFocus()	
ELSE
/*  or Create a new Support definition */
	This.Title = "Create New Support Definition"
	ll_newrow = dw_supdef.InsertRow(0)
	dw_supdef.ScrollToRow(ll_newrow)
	dw_supdef.SetFocus()	

	IF istr_parm.sdef_chart THEN
	/* The support definition is for a charterer */
		dw_supdef.SetItem(ll_newrow,"chart_nr",istr_parm.sdef_ownerid)
	ELSE
	/* Or for a target */ 
		dw_supdef.SetItem(ll_newrow,"ccs_targ_pk",istr_parm.sdef_ownerid)
	END IF
	cb_showlist.visible = TRUE
	
END IF

dw_sdef_list.Retrieve()
COMMIT USING SQLCA;
dw_supdef.SetRedraw(TRUE)
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/08/14 CR3708            CCY018        modified event ue_getwidowname
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_supdef
  
 Object     : 
  
 Event	 : Open

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :30-07-96

 Description : Opens the window for editing a selected or creating a new support definition

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A s_support to receive  Message.PowerObjectParm

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		1.0	 		JH		Initial version
01-08-96					JH		Modification to Structure
12-08-96					KHK		Vessel_nr and Voyage_nr added
								to the retrieve criterias  
29-08-96					JH		Added wf_retrieve()
************************************************************************************/

This.Move(15,105)

istr_parm = Message.PowerObjectParm

wf_retrieve()
end event

on w_supdef.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_showlist=create cb_showlist
this.dw_sdef_list=create dw_sdef_list
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_supdef=create dw_supdef
this.cb_list_ok=create cb_list_ok
this.cb_list_cancel=create cb_list_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_showlist
this.Control[iCurrent+3]=this.dw_sdef_list
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.dw_supdef
this.Control[iCurrent+7]=this.cb_list_ok
this.Control[iCurrent+8]=this.cb_list_cancel
end on

on w_supdef.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_showlist)
destroy(this.dw_sdef_list)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_supdef)
destroy(this.cb_list_ok)
destroy(this.cb_list_cancel)
end on

event ue_getwindowname;call super::ue_getwindowname;if istr_parm.sdef_chart then
	as_windowname = this.classname() + "_chart"
else
	as_windowname = this.classname() + "_target"
end if
end event

type st_hidemenubar from w_sale_base`st_hidemenubar within w_supdef
end type

type cb_close from uo_cb_base within w_supdef
integer x = 2304
integer y = 1344
integer width = 421
integer height = 80
integer taborder = 60
string text = "Close"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;Close(Parent)
end on

type cb_showlist from uo_cb_base within w_supdef
boolean visible = false
integer x = 37
integer y = 1344
integer width = 421
integer height = 80
integer taborder = 50
string text = "Show List"
end type

on clicked;call uo_cb_base::clicked;wf_updatebuttons(This)
end on

type dw_sdef_list from u_datawindow_sqlca within w_supdef
boolean visible = false
integer x = 37
integer y = 208
integer width = 1079
integer height = 1120
integer taborder = 40
string dataobject = "d_sdef_list"
boolean hscrollbar = true
boolean vscrollbar = true
end type

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_list_ok.TriggerEvent(Clicked!)
end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;Long ll_row

This.SelectRow(0,FALSE)
ll_row = This.SelectRow(This.GetRow(),TRUE)

end on

event clicked;call super::clicked;Long ll_row

This.SelectRow(0,FALSE)
ll_row = This.SelectRow(row,TRUE)
This.SetRow(ll_row)
end event

type cb_cancel from uo_cb_base within w_supdef
integer x = 1426
integer y = 1344
integer width = 421
integer height = 80
integer taborder = 10
string text = "Cancel"
end type

on clicked;call uo_cb_base::clicked;
wf_retrieve()
end on

type cb_update from uo_cb_base within w_supdef
integer x = 1865
integer y = 1344
integer width = 421
integer height = 80
integer taborder = 80
string text = "Update"
boolean default = true
end type

on clicked;call uo_cb_base::clicked;Boolean lb_OK, lb_tmp_OK
Long ll_row
String ls_form, ls_tmp,ls_tmp2

ll_row = dw_supdef.GetRow()
lb_OK =FALSE
lb_tmp_OK = FALSE
ls_form = ""

dw_supdef.AcceptText()

ls_tmp = dw_supdef.GetItemString(ll_row,"ccs_sdef_cal_cerp_id_list")+dw_supdef.GetItemString(ll_row,"ccs_sdef_chart_nr_list")+&
		dw_supdef.GetItemString(ll_row,"ccs_sdef_chgp_list")+dw_supdef.GetItemString(ll_row,"ccs_sdef_cerp_date_list")+&
		dw_supdef.GetItemString(ll_row,"ccs_sdef_vv_no_list")

ls_tmp2 = dw_supdef.GetItemString(ll_row,"ccs_sdef_form_list")
String aa
aa =  dw_supdef.GetItemString(ll_row,"ccs_sdef_con_type")
IF dw_supdef.GetItemString(ll_row,"ccs_sdef_con_type") = "0" AND (ls_tmp < "   " OR IsNull(ls_tmp))&
			  AND  (ls_tmp2  < "   " OR IsNull(ls_tmp2)) THEN
//Not OK to save
	MessageBox("Error","Must specify a Retrieve Criteria~r~n when Contract Type is 'All'",StopSign!)
	Return
END IF
	
lb_tmp_OK = f_check_syntax_num(dw_supdef.GetItemString(ll_row,"ccs_sdef_cal_cerp_id_list"),"0123456789")
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Certeparti Id List",StopSign!)
lb_OK = lb_tmp_OK

lb_tmp_OK = f_check_syntax_num(dw_supdef.GetItemString(ll_row,"ccs_sdef_chart_nr_list"),"ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ0123456789 .")
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Charterer List",StopSign!)
lb_OK = lb_OK AND lb_tmp_OK

lb_tmp_OK = f_check_syntax_str(dw_supdef.GetItemString(ll_row,"ccs_sdef_chgp_list"),"ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ0123456789 .")
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Charterer Group List",StopSign!)
lb_OK = lb_OK AND lb_tmp_OK

lb_tmp_OK = f_check_syntax_date(dw_supdef.GetItemString(ll_row,"ccs_sdef_cerp_date_list"),"0123456789")
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Certeparti Date List",StopSign!)
lb_OK = lb_OK AND lb_tmp_OK

lb_tmp_OK = f_check_syntax_vessel_voyage(dw_supdef.GetItemString(ll_row,"ccs_sdef_vv_no_list"))
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Vessel/Voyage List",StopSign!)
lb_OK = lb_OK AND lb_tmp_OK

lb_tmp_OK = f_check_values(dw_supdef.GetItemString(ll_row,"ccs_sdef_form_list"),"0123456789","@1@2@3@4@5@6@7@8@9@10@11@12@13@14@15@")
IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","References out of borders",StopSign!)
lb_OK = lb_OK AND lb_tmp_OK

ls_form = dw_supdef.GetItemString(1,"ccs_sdef_form_list")
lb_tmp_OK =  NOT (dw_supdef.Describe("evaluate('"+ls_form+"',1)") = "!")
//IF NOT lb_tmp_OK THEN Messagebox("Syntax Error","Invalid syntax in Formula",StopSign!) - We use the errormessage of the PB system
lb_OK = lb_OK AND lb_tmp_OK

IF lb_OK THEN
	f_update(dw_supdef,w_tramos_main)
	Close(Parent)
END IF


end on

type dw_supdef from u_datawindow_sqlca within w_supdef
integer x = 18
integer y = 16
integer width = 2706
integer height = 1312
integer taborder = 70
string dataobject = "d_sdef_detail"
end type

on getfocus;call u_datawindow_sqlca::getfocus;SetColumn("ccs_sdef_desc")
end on

type cb_list_ok from uo_cb_base within w_supdef
boolean visible = false
integer x = 37
integer y = 1344
integer width = 293
integer height = 80
integer taborder = 30
string text = "OK"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_supdef
  
 Object     : cb_list_ok
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :01-08-96

 Description : Copies the selected support definition from list af all(dw_sdef_list) to the one 
			show in the edit window(dw_supdef)

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : istr_parm

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0			JH		Initial Version
15-08-96		1.0			KHK		Copy of columns changed to absolute refrences, instead
								of relative references by a column-counter (which gave 
								problems when new columns were added in the table CCS_SDEF.
************************************************************************************/


Long ll_selectedRow
ll_selectedRow = dw_sdef_list.GetRow()

/* Insert  string  as description*/
dw_supdef.SetItem(1,"ccs_sdef_desc","copy")

/* Copy columns */
dw_supdef.SetItem(1,"ccs_sdef_target_fig",dw_sdef_list.GetItemNumber(ll_selectedRow,"ccs_sdef_target_fig"))
dw_supdef.SetItem(1,"ccs_sdef_con_type",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_con_type"))
dw_supdef.SetItem(1,"ccs_sdef_cal_cerp_id_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_cal_cerp_id_list"))
dw_supdef.SetItem(1,"ccs_sdef_chart_nr_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_chart_nr_list"))
dw_supdef.SetItem(1,"ccs_sdef_chgp_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_chgp_list"))
dw_supdef.SetItem(1,"ccs_sdef_cerp_date_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_cerp_date_list"))
dw_supdef.SetItem(1,"ccs_sdef_vv_no_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_vv_no_list"))
dw_supdef.SetItem(1,"ccs_sdef_form_list",dw_sdef_list.GetItemString(ll_selectedRow,"ccs_sdef_form_list"))

/* Insert Charterer key or Target key */
	IF istr_parm.sdef_chart THEN
	/* The support definition is for a charterer */
		dw_supdef.SetItem(1,"chart_nr",istr_parm.sdef_ownerid)
	ELSE
	/* Or for a target */ 
		dw_supdef.SetItem(1,"ccs_targ_pk",istr_parm.sdef_ownerid)
	END IF

dw_supdef.ScrollToRow(1)
dw_supdef.SetFocus()

/* Update other buttons visible and enabled attributes */
wf_updatebuttons(This)

end event

type cb_list_cancel from uo_cb_base within w_supdef
boolean visible = false
integer x = 347
integer y = 1344
integer width = 293
integer height = 80
integer taborder = 20
string text = "Cancel"
end type

on clicked;call uo_cb_base::clicked;wf_updatebuttons(This)
end on

