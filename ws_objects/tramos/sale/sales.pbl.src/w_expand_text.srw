$PBExportHeader$w_expand_text.srw
$PBExportComments$This Responce window lets the user edit text parsed in s_expand_text.; Returns "!" if no changes were made; Else returns the modified string. s_expand_text.name will be placed in Windows title: "Text for: ###".
forward
global type w_expand_text from w_sale_response
end type
type cb_cancel from uo_cb_base within w_expand_text
end type
type cb_temp_cancel from uo_cb_base within w_expand_text
end type
type dw_templates from u_datawindow_sqlca within w_expand_text
end type
type cb_print from commandbutton within w_expand_text
end type
type cb_update from uo_cb_base within w_expand_text
end type
type cb_close from uo_cb_base within w_expand_text
end type
type dw_1 from datawindow within w_expand_text
end type
type cb_templates from uo_cb_base within w_expand_text
end type
type cb_temp_ok from uo_cb_base within w_expand_text
end type
end forward

global type w_expand_text from w_sale_response
integer y = 260
integer width = 2848
integer height = 1400
boolean controlmenu = false
cb_cancel cb_cancel
cb_temp_cancel cb_temp_cancel
dw_templates dw_templates
cb_print cb_print
cb_update cb_update
cb_close cb_close
dw_1 dw_1
cb_templates cb_templates
cb_temp_ok cb_temp_ok
end type
global w_expand_text w_expand_text

type variables
s_expand_text istr_parm
end variables

forward prototypes
public subroutine wf_updatebuttons (commandbutton a_cb)
public subroutine documentation ()
end prototypes

public subroutine wf_updatebuttons (commandbutton a_cb);CHOOSE CASE a_cb
	CASE cb_templates
				cb_update.Enabled = False
				cb_close.Enabled = False
				cb_cancel.Enabled = False
				dw_templates.visible = TRUE
				cb_templates.visible = FALSE
				cb_temp_cancel.visible = TRUE
				cb_temp_ok.visible = TRUE
		//dw_templates.visible = false
CASE cb_temp_cancel 
		cb_update.Enabled = TRUE
		cb_close.Enabled = TRUE
		cb_cancel.Enabled = TRUE
		dw_templates.visible = FALSE
		cb_temp_cancel.visible = FALSE
		cb_templates.visible = TRUE
		cb_temp_ok.visible = FALSE
	CASE cb_temp_ok
		cb_update.Enabled = TRUE
		cb_close.Enabled = TRUE
		cb_cancel.Enabled = TRUE
		dw_templates.visible = FALSE
		cb_temp_ok.visible = FALSE
		cb_templates.visible = TRUE
		cb_temp_cancel.visible = FALSE
		
END CHOOSE

end subroutine

public subroutine documentation ();/********************************************************************
	w_expand_text
	
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

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_exspand
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 08-08-96

 Description :Response Window expands text into a edit window

 Arguments : Must be opened with a structure s_expand_text, where string attribute 'text' is the text to be 
			edited, and string attribute 'name' is the name to be figured in titlebar 

 Returns   : Returns "!" if no changes were made to text, else returns the modified text as string  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-08-96				1.0	 	JH				Initial version
06-02-97				1.1		BHO			Replace the multiline edit with a datawindow.
													Insert a print-commandbutton					  
************************************************************************************/
long 		ll_row

dw_1.settransobject(sqlca)
dw_1.retrieve()

istr_parm = Message.PowerObjectParm

/* set text in edit field */
This.Title = "Text for: " + istr_parm.name
ll_row=Dw_1.insertrow(0)
dw_1.scrolltorow(ll_row)
dw_1.setitem(ll_row,"text",istr_parm.text)
dw_1.SetFocus()

/* Retrieve data for list of templates */
dw_templates.Retrieve()
COMMIT USING SQLCA;



end event

on w_expand_text.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_temp_cancel=create cb_temp_cancel
this.dw_templates=create dw_templates
this.cb_print=create cb_print
this.cb_update=create cb_update
this.cb_close=create cb_close
this.dw_1=create dw_1
this.cb_templates=create cb_templates
this.cb_temp_ok=create cb_temp_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_temp_cancel
this.Control[iCurrent+3]=this.dw_templates
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.cb_close
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.cb_templates
this.Control[iCurrent+9]=this.cb_temp_ok
end on

on w_expand_text.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_temp_cancel)
destroy(this.dw_templates)
destroy(this.cb_print)
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.dw_1)
destroy(this.cb_templates)
destroy(this.cb_temp_ok)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_expand_text
end type

type cb_cancel from uo_cb_base within w_expand_text
integer x = 1618
integer y = 1180
integer width = 366
integer height = 80
integer taborder = 50
string text = "Cancel"
end type

event clicked;call super::clicked;long ll_row

ll_row = dw_1.getrow()
dw_1.setitem(ll_row,"text",istr_parm.text)
dw_1.SetFocus()
end event

type cb_temp_cancel from uo_cb_base within w_expand_text
boolean visible = false
integer x = 439
integer y = 1184
integer width = 366
integer height = 80
integer taborder = 10
string text = "Cancel"
end type

on clicked;call uo_cb_base::clicked;//mle_text.SetFocus()
//wf_updatebuttons(This)

dw_1.SetFocus()
wf_updatebuttons(This)
end on

type dw_templates from u_datawindow_sqlca within w_expand_text
boolean visible = false
integer x = 55
integer y = 48
integer width = 859
integer height = 1088
integer taborder = 30
string dataobject = "d_template_list"
boolean vscrollbar = true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;Long ll_row

This.SelectRow(0,FALSE)
ll_row = This.SelectRow(This.GetRow(),TRUE)
end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_temp_ok.TriggerEvent(Clicked!)
end on

event clicked;call super::clicked;Long ll_row

This.SelectRow(0,FALSE)
/* ll_row = This.SelectRow(This.GetClickedRow(),TRUE) */
ll_row = This.SelectRow(row,TRUE)
This.SetRow(ll_row)
end event

type cb_print from commandbutton within w_expand_text
integer x = 1230
integer y = 1180
integer width = 366
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

on clicked;dw_1.accepttext()
dw_1.print(true)
end on

type cb_update from uo_cb_base within w_expand_text
integer x = 2007
integer y = 1180
integer width = 366
integer height = 80
integer taborder = 70
string text = "OK"
boolean cancel = true
end type

event clicked;call super::clicked;string 	ls_text
long 		ll_row

ll_row=dw_1.getrow()
dw_1.accepttext()
ls_text=dw_1.Getitemstring(ll_row,"text")
if isnull(ls_text) then ls_text=''

CloseWithReturn(parent,ls_text)
end event

type cb_close from uo_cb_base within w_expand_text
integer x = 2391
integer y = 1180
integer width = 366
integer height = 80
integer taborder = 80
string text = "Close"
end type

on clicked;call uo_cb_base::clicked;CloseWithReturn(parent,"!")

end on

type dw_1 from datawindow within w_expand_text
integer x = 215
integer y = 92
integer width = 2409
integer height = 972
integer taborder = 31
boolean bringtotop = true
string dataobject = "d_text_dataobject"
boolean hscrollbar = true
boolean livescroll = true
end type

type cb_templates from uo_cb_base within w_expand_text
integer x = 59
integer y = 1180
integer width = 366
integer height = 80
integer taborder = 20
boolean bringtotop = true
string text = "Template"
end type

event clicked;call super::clicked;wf_updatebuttons(This)

end event

type cb_temp_ok from uo_cb_base within w_expand_text
boolean visible = false
integer x = 55
integer y = 1184
integer width = 366
integer height = 80
integer taborder = 60
string text = "OK"
end type

event clicked;call super::clicked;// Code for copying the template
Long ll_selectedRow

ll_selectedRow = dw_templates.GetRow()

IF ll_selectedRow > 0 THEN
/* Copy selected template text */
//	mle_text.text = dw_templates.GetItemString(ll_selectedRow,"ccs_tmpl_txt")	
dw_1.setitem(1,"text",dw_templates.getitemstring(ll_selectedrow,"ccs_tmpl_txt"))
END IF

dw_1.SetFocus()
wf_updatebuttons(This)
end event

