$PBExportHeader$w_template.srw
$PBExportComments$This window lets the user create and edit text templates.
forward
global type w_template from w_sale_base
end type
type cb_close from uo_cb_base within w_template
end type
type cb_update from uo_cb_base within w_template
end type
type cb_cancel from uo_cb_base within w_template
end type
type dw_list_of_temp from u_datawindow_sqlca within w_template
end type
type cb_listtemp from uo_cb_base within w_template
end type
type dw_template from u_datawindow_sqlca within w_template
end type
type cb_delete from uo_cb_base within w_template
end type
end forward

global type w_template from w_sale_base
integer x = 69
integer y = 244
integer width = 2811
integer height = 1368
string title = "Text Templates"
cb_close cb_close
cb_update cb_update
cb_cancel cb_cancel
dw_list_of_temp dw_list_of_temp
cb_listtemp cb_listtemp
dw_template dw_template
cb_delete cb_delete
end type
global w_template w_template

forward prototypes
public function integer wf_save ()
public subroutine wf_buttons (boolean a_on)
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_template
  
 Object     : wf_save
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 28-08-96

 Description : Update the template

 Arguments : none

 Returns   : Update OK = 1; No update = 0

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-08-96		1.0	 		JH		Initial version
  
************************************************************************************/


/* Check if template has got name and text before updating */
dw_template.AcceptText()

IF IsNull(dw_template.GetItemString(dw_template.GetRow(),"ccs_tmpl_name")) THEN
	MessageBox("Update Error","Please enter a Template Name!")
	Return 0
END IF	

IF IsNull(dw_template.GetItemString(dw_template.GetRow(),"ccs_tmpl_txt")) THEN
	MessageBox("Update Error","Please enter a Template Text!")
	Return 0
END IF


IF f_update(dw_template,w_tramos_main) THEN
	Return 1	
ELSE
	Return 0
END IF



end function

public subroutine wf_buttons (boolean a_on);/* Enable or disable buttons in window */
CHOOSE CASE a_on
	CASE TRUE
		cb_cancel.Enabled = TRUE
		cb_close.Enabled = TRUE
		cb_update.Enabled = TRUE		
	CASE FALSE
		cb_cancel.Enabled = FALSE
		cb_close.Enabled = FALSE
		cb_update.Enabled = FALSE		
END CHOOSE

end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_template
  
 Object     : 
  
 Event	 : Open!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 28-08-96

 Description : Window lets the user create a new or edit an existing Text Template 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
Long ll_newrow

dw_list_of_temp.Retrieve()
COMMIT USING SQLCA;


ll_newrow = dw_template.InsertRow(0)
dw_template.ScrollToRow(ll_newrow)




end on

on closequery;call w_sale_base::closequery;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_template
  
 Object     : 
  
 Event	 : Closequery

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 28-08-96

 Description : Check if template has been edited before closing

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
Integer li_ans

dw_template.AcceptText()

IF dw_template.ModifiedCount() > 0 THEN
	li_ans = Messagebox("Warning","You have started making a Template. Do you want to save it before closing?",&
						Question!,YesNoCancel!)
	IF li_ans = 1 THEN
		IF wf_save() = 0 THEN Message.ReturnValue = 1
	ELSEIF li_ans = 3 THEN
		 Message.ReturnValue = 1
	END IF

END IF



end on

on w_template.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_list_of_temp=create dw_list_of_temp
this.cb_listtemp=create cb_listtemp
this.dw_template=create dw_template
this.cb_delete=create cb_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_list_of_temp
this.Control[iCurrent+5]=this.cb_listtemp
this.Control[iCurrent+6]=this.dw_template
this.Control[iCurrent+7]=this.cb_delete
end on

on w_template.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_list_of_temp)
destroy(this.cb_listtemp)
destroy(this.dw_template)
destroy(this.cb_delete)
end on

type st_hidemenubar from w_sale_base`st_hidemenubar within w_template
end type

type cb_close from uo_cb_base within w_template
integer x = 2414
integer y = 1152
integer width = 329
integer height = 80
integer taborder = 60
string text = "Close"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;Close(Parent)
end on

type cb_update from uo_cb_base within w_template
integer x = 2048
integer y = 1152
integer width = 329
integer height = 80
integer taborder = 50
string text = "&Update"
end type

on clicked;call uo_cb_base::clicked;IF wf_save() = 1 THEN
	Close(Parent)
END IF

end on

type cb_cancel from uo_cb_base within w_template
integer x = 1682
integer y = 1152
integer width = 329
integer height = 80
integer taborder = 40
string text = "&Cancel"
end type

on clicked;call uo_cb_base::clicked;dw_template.SetRedraw(FALSE)
Parent.TriggerEvent(Open!)
dw_template.SetRedraw(TRUE)
dw_template.SetFocus()
end on

type dw_list_of_temp from u_datawindow_sqlca within w_template
event ue_keydown pbm_dwnkey
boolean visible = false
integer x = 219
integer y = 112
integer width = 1115
integer height = 672
integer taborder = 70
string dataobject = "d_template_list"
boolean vscrollbar = true
end type

on ue_keydown;call u_datawindow_sqlca::ue_keydown;IF KeyDown(KeyEnter!) THEN
	TriggerEvent(DoubleClicked!)
END IF

end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;Long ll_row,ll_key

ll_row = GetRow()

IF ll_row > 0 THEN
	ll_key = GetItemNumber(ll_row,"ccs_tmpl_pk")
	dw_template.Retrieve(ll_key)
END IF

THIS.Visible = FALSE
cb_delete.Text = "&Delete"

dw_template.SetFocus()
end on

on getfocus;call u_datawindow_sqlca::getfocus;wf_buttons(FALSE)		
end on

on clicked;call u_datawindow_sqlca::clicked;/* Use ancestors script */
ib_auto = TRUE

ScrollToRow(GetRow())
end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/* Use ancestors script */
ib_auto = TRUE
end on

on losefocus;call u_datawindow_sqlca::losefocus;wf_buttons(TRUE)		
end on

type cb_listtemp from uo_cb_base within w_template
integer x = 1225
integer y = 32
integer width = 110
integer height = 80
integer taborder = 20
string text = "?"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_template
  
 Object     : cb_listtemp
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 28-08-96

 Description : Open list of all templates to let user select an existing template to edit

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-08-96		1.0	 		JH		Initial version
  
************************************************************************************/


Integer li_ans

dw_template.AcceptText()

/* Check if any template has been made */
IF dw_template.ModifiedCount() > 0 THEN
	/*Template has been started on. Save first?*/
	li_ans = Messagebox("Warning","You have started making a Template. Do you want to save it first?",&
						Question!,YesNoCancel!)
	IF li_ans = 1 THEN
		/* Process Yes to save */	
		IF wf_save() = 1 THEN
			// Update ok 
			/* Open list of templates */
			dw_list_of_temp.Retrieve()
			dw_list_of_temp.Visible = TRUE
			dw_list_of_temp.SetFocus()
			cb_delete.Text = "Close &List"		
		ELSE
			// No Update
			Return
		END IF		
	ELSEIF li_ans = 2 THEN
		/* Process No to save */
		dw_list_of_temp.Visible = TRUE
		dw_list_of_temp.SetFocus()
		cb_delete.Text = "Close &List"		
	ELSE
		/* Process Cancel */
		Return
	END IF
ELSE
	/* Open list of templates */
	dw_list_of_temp.Visible = TRUE
	dw_list_of_temp.SetFocus()
	cb_delete.Text = "Close &List"						
END IF



end on

type dw_template from u_datawindow_sqlca within w_template
integer x = 18
integer y = 16
integer width = 2725
integer height = 1104
integer taborder = 10
string dataobject = "d_template_edit"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_delete from uo_cb_base within w_template
integer x = 37
integer y = 1152
integer width = 329
integer height = 80
integer taborder = 30
string text = "&Delete"
end type

event clicked;call super::clicked;Long ll_row,ll_newrow

CHOOSE CASE This.Text
	CASE "&Delete"
		
	ll_row = dw_template.GetRow()

	IF  ll_row <> 0 THEN
		IF MessageBox("Delete","You are about to DELETE !~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 THEN	return

		dw_template.DeleteRow(ll_row)

		IF dw_template.Update() = 1 THEN
		// Update ok
			COMMIT;
			dw_list_of_temp.Retrieve()
			ll_newrow = dw_template.InsertRow(0)
			dw_template.ScrollToRow(ll_newrow)
			dw_template.SetFocus()
		
		ELSE
		// Update failed
			MessageBox("DB Error","Database did not delete template ! ~r~nPlease try again later.",StopSign!)
			ROLLBACK;
		END IF
	END IF

CASE "Close &List"
	dw_list_of_temp.Visible = FALSE
	THIS.Text = "&Delete"


END CHOOSE

end event

