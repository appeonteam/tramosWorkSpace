$PBExportHeader$w_comment.srw
$PBExportComments$Used in connection with n_comment to maintain comments marked as "comments" in datawindows
forward
global type w_comment from mt_w_response
end type
type cb_cancel from commandbutton within w_comment
end type
type cb_ok from commandbutton within w_comment
end type
type mle_comment from multilineedit within w_comment
end type
end forward

global type w_comment from mt_w_response
integer width = 928
integer height = 620
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean clientedge = true
cb_cancel cb_cancel
cb_ok cb_ok
mle_comment mle_comment
end type
global w_comment w_comment

type variables
n_comment in_comment

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_comment
	
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

event open;in_comment = Message.PowerObjectParm

mle_comment.text = in_comment.getComment()

//Position this window in the middle of the parent window
window parentW

parentW = this.ParentWindow()

this.x = (parentW.width - this.width) / 2 + parentW.x
this.y = (parentW.height - this.height) / 2 + parentW.y

mle_comment.limit = 255



end event

on w_comment.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.mle_comment=create mle_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.mle_comment
end on

on w_comment.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.mle_comment)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_comment
end type

type cb_cancel from commandbutton within w_comment
integer x = 466
integer y = 528
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;in_comment.setReturnCode(0)
CloseWithReturn(parent, in_comment)
//close(parent)
end event

type cb_ok from commandbutton within w_comment
integer x = 27
integer y = 528
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;in_comment.setComment(mle_comment.text)
in_comment.setReturnCode(1)
CloseWithReturn(parent, in_comment)


end event

type mle_comment from multilineedit within w_comment
integer width = 896
integer height = 512
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12639424
string text = "none"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

