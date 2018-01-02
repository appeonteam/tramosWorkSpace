$PBExportHeader$w_enter_transfer_comment.srw
forward
global type w_enter_transfer_comment from mt_w_response
end type
type cb_1 from commandbutton within w_enter_transfer_comment
end type
type dw_comment from datawindow within w_enter_transfer_comment
end type
type st_1 from statictext within w_enter_transfer_comment
end type
type cb_ok from commandbutton within w_enter_transfer_comment
end type
end forward

global type w_enter_transfer_comment from mt_w_response
integer width = 1504
integer height = 848
string title = "Transfer Comment"
boolean controlmenu = false
cb_1 cb_1
dw_comment dw_comment
st_1 st_1
cb_ok cb_ok
end type
global w_enter_transfer_comment w_enter_transfer_comment

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_enter_transfer_comment
	
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
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_enter_transfer_comment.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_comment=create dw_comment
this.st_1=create st_1
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_comment
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_ok
end on

on w_enter_transfer_comment.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_comment)
destroy(this.st_1)
destroy(this.cb_ok)
end on

event open;string ls_comment
ls_comment = message.stringparm

//f_center_window(this)
this.move(w_tramos_main.x +1000, w_tramos_main.y +1000)

dw_comment.insertRow(0)
dw_comment.setItem(1, "comment", ls_comment)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_enter_transfer_comment
end type

type cb_1 from commandbutton within w_enter_transfer_comment
integer x = 768
integer y = 612
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;string ls_null; setNull(ls_null)
closewithreturn(parent, ls_null )

end event

type dw_comment from datawindow within w_enter_transfer_comment
integer x = 27
integer y = 172
integer width = 1431
integer height = 384
integer taborder = 10
string title = "none"
string dataobject = "d_enter_transfer_comment"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_enter_transfer_comment
integer x = 133
integer y = 24
integer width = 1216
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "You have selected to transfer an amount to the next payment. Please enter an explanation"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_enter_transfer_comment
integer x = 375
integer y = 612
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;dw_comment.acceptText()
if len(dw_comment.getItemString(1, "comment")) < 2 or isNull(dw_comment.getItemString(1, "comment")) then 
	MessageBox("Validation Error","Please insert a comment!")
	dw_comment.POST setFocus()
	return
end if
closewithreturn(parent, dw_comment.getItemString(1, "comment"))

end event

