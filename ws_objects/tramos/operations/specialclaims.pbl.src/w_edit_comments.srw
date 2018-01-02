$PBExportHeader$w_edit_comments.srw
$PBExportComments$Edit comments in a response window
forward
global type w_edit_comments from mt_w_response
end type
type cb_cancel from commandbutton within w_edit_comments
end type
type cb_ok from commandbutton within w_edit_comments
end type
type mle_comment from multilineedit within w_edit_comments
end type
end forward

global type w_edit_comments from mt_w_response
integer width = 2720
integer height = 2332
string title = "Edit Description"
long backcolor = 32304364
cb_cancel cb_cancel
cb_ok cb_ok
mle_comment mle_comment
end type
global w_edit_comments w_edit_comments

event open;call super::open;mle_comment.text = message.stringParm
end event

on w_edit_comments.create
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

on w_edit_comments.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.mle_comment)
end on

type cb_cancel from commandbutton within w_edit_comments
integer x = 2331
integer y = 2124
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;string ls_null;setNull(ls_null)

closewithreturn( parent, ls_null )
end event

type cb_ok from commandbutton within w_edit_comments
integer x = 1975
integer y = 2124
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;closewithreturn( parent, mle_comment.text )
end event

type mle_comment from multilineedit within w_edit_comments
integer x = 41
integer y = 36
integer width = 2633
integer height = 2052
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

