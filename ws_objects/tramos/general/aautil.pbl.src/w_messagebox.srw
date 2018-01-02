$PBExportHeader$w_messagebox.srw
forward
global type w_messagebox from mt_w_response
end type
type cb_copy from mt_u_commandbutton within w_messagebox
end type
type cb_2 from mt_u_commandbutton within w_messagebox
end type
type mle_comment from multilineedit within w_messagebox
end type
end forward

global type w_messagebox from mt_w_response
integer width = 2770
integer height = 2276
string title = ""
boolean ib_setdefaultbackgroundcolor = true
cb_copy cb_copy
cb_2 cb_2
mle_comment mle_comment
end type
global w_messagebox w_messagebox

on w_messagebox.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.cb_2=create cb_2
this.mle_comment=create mle_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.mle_comment
end on

on w_messagebox.destroy
call super::destroy
destroy(this.cb_copy)
destroy(this.cb_2)
destroy(this.mle_comment)
end on

event open;call super::open;mle_comment.text = message.stringParm
end event

type cb_copy from mt_u_commandbutton within w_messagebox
integer x = 14
integer y = 2068
integer width = 471
integer taborder = 20
string text = "&Copy to Clipboard"
end type

event clicked;call super::clicked;
clipboard(mle_comment.text)
end event

type cb_2 from mt_u_commandbutton within w_messagebox
integer x = 2400
integer y = 2076
integer taborder = 30
string text = "&OK"
end type

event clicked;call super::clicked;close(parent)
end event

type mle_comment from multilineedit within w_messagebox
integer x = 9
integer width = 2734
integer height = 2052
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

