$PBExportHeader$w_blueboardpost.srw
forward
global type w_blueboardpost from mt_w_response
end type
type cb_paste from commandbutton within w_blueboardpost
end type
type cb_cancel from commandbutton within w_blueboardpost
end type
type cb_post from commandbutton within w_blueboardpost
end type
type mle_msg from multilineedit within w_blueboardpost
end type
type st_1 from statictext within w_blueboardpost
end type
end forward

global type w_blueboardpost from mt_w_response
integer width = 2921
integer height = 1364
string title = "Create New Post"
long backcolor = 32304364
cb_paste cb_paste
cb_cancel cb_cancel
cb_post cb_post
mle_msg mle_msg
st_1 st_1
end type
global w_blueboardpost w_blueboardpost

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_blueboardpost
	
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
		20/06/2010	CR1821	   CONASW		First Version
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_blueboardpost.create
int iCurrent
call super::create
this.cb_paste=create cb_paste
this.cb_cancel=create cb_cancel
this.cb_post=create cb_post
this.mle_msg=create mle_msg
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_paste
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_post
this.Control[iCurrent+4]=this.mle_msg
this.Control[iCurrent+5]=this.st_1
end on

on w_blueboardpost.destroy
call super::destroy
destroy(this.cb_paste)
destroy(this.cb_cancel)
destroy(this.cb_post)
destroy(this.mle_msg)
destroy(this.st_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_blueboardpost
end type

type cb_paste from commandbutton within w_blueboardpost
integer x = 2331
integer y = 16
integer width = 544
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste &From Clipboard"
end type

event clicked;
String ls_Code 

ls_Code = Clipboard()

If Len(Trim(ls_Code, True)) > 0 then 
	mle_Msg.Text = Trim(ls_Code, True)
Else
	Messagebox("Paste Error", "The clipboard does not contain any text!", Exclamation!)
End If
end event

type cb_cancel from commandbutton within w_blueboardpost
integer x = 2533
integer y = 1148
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
boolean cancel = true
end type

event clicked;
CloseWithReturn(w_blueboardpost, "")
end event

type cb_post from commandbutton within w_blueboardpost
integer x = 2144
integer y = 1148
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Post"
end type

event clicked;
mle_Msg.Text = Trim(mle_Msg.Text, True)

// Check if box is empty
If mle_Msg.Text = "" then 
	Messagebox("Empty Post", "Cannot create an empty post!")
	Return
End If

// Return post
CloseWithReturn(w_blueboardpost, mle_Msg.Text)
end event

type mle_msg from multilineedit within w_blueboardpost
integer x = 37
integer y = 108
integer width = 2839
integer height = 1008
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean vscrollbar = true
integer limit = 800
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_blueboardpost
integer x = 37
integer y = 32
integer width = 338
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Enter Message"
boolean focusrectangle = false
end type

