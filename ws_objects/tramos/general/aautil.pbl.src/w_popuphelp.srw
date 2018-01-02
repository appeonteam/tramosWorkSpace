$PBExportHeader$w_popuphelp.srw
$PBExportComments$Used in connection with n_comment to maintain comments marked as "comments" in datawindows
forward
global type w_popuphelp from window
end type
type mle_message from multilineedit within w_popuphelp
end type
end forward

global type w_popuphelp from window
integer width = 910
integer height = 524
windowtype windowtype = popup!
long backcolor = 79741120
boolean center = true
mle_message mle_message
end type
global w_popuphelp w_popuphelp

type variables
n_comment in_comment
end variables

on w_popuphelp.create
this.mle_message=create mle_message
this.Control[]={this.mle_message}
end on

on w_popuphelp.destroy
destroy(this.mle_message)
end on

event open;in_comment = Message.PowerObjectParm

mle_message.text = in_comment.getComment()

//Position this window in the middle of the parent window
window parentW

parentW = this.ParentWindow()

//Position this window below event

this.x = in_comment.getX() 
this.y = in_comment.getY()

//Make the window close automatically after 5 seconds
Timer(5)



end event

event timer;Timer(0)
Close(This)
end event

type mle_message from multilineedit within w_popuphelp
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
boolean border = false
boolean displayonly = true
end type

