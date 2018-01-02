$PBExportHeader$w_error_box.srw
$PBExportComments$Non Modal Messagebox
forward
global type w_error_box from mt_w_response
end type
type mle_msg from multilineedit within w_error_box
end type
type cb_ok from uo_cb_base within w_error_box
end type
type cb_print from uo_cb_base within w_error_box
end type
end forward

global type w_error_box from mt_w_response
integer width = 1929
integer height = 1068
mle_msg mle_msg
cb_ok cb_ok
cb_print cb_print
end type
global w_error_box w_error_box

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_error_box
	
	<OBJECT>

	</OBJECT>
   	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

on open;call mt_w_response::open;s_error_msg lstr_error_msg

lstr_error_msg = Message.PowerObjectParm
This.Title = "Error ("+lstr_error_msg.s_Title+")"
mle_msg.text = lstr_error_msg.s_msg

Beep(1)
end on

on w_error_box.create
int iCurrent
call super::create
this.mle_msg=create mle_msg
this.cb_ok=create cb_ok
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_msg
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_print
end on

on w_error_box.destroy
call super::destroy
destroy(this.mle_msg)
destroy(this.cb_ok)
destroy(this.cb_print)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_error_box
end type

type mle_msg from multilineedit within w_error_box
integer x = 18
integer y = 16
integer width = 1883
integer height = 784
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_ok from uo_cb_base within w_error_box
integer x = 658
integer y = 832
integer taborder = 30
string text = "&OK"
boolean default = true
end type

on clicked;call uo_cb_base::clicked;Close(Parent)
end on

type cb_print from uo_cb_base within w_error_box
integer x = 951
integer y = 832
integer taborder = 10
string text = "&Print"
end type

event clicked;call super::clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_error_box.cb_print
//
// Purpose:  Print error message displayed in the multi line edit.
// 		
// Log:
// 
// DATE		NAME			REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation INITIAL VERSION
//
/////////////////////////////////////////////////////////////////////////

long ll_job

ll_job = printopen()

setpointer ( hourglass! )

print(ll_job, mle_msg.text)
printclose(ll_job)
end event

