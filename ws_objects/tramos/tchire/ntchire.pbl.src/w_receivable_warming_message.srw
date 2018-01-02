$PBExportHeader$w_receivable_warming_message.srw
$PBExportComments$Message shown when estimated due date differs more than 30 days from entered receive date.
forward
global type w_receivable_warming_message from mt_w_response
end type
type cb_ok from commandbutton within w_receivable_warming_message
end type
type st_2 from statictext within w_receivable_warming_message
end type
type st_1 from statictext within w_receivable_warming_message
end type
end forward

global type w_receivable_warming_message from mt_w_response
integer width = 1449
integer height = 1156
string title = "Warning"
cb_ok cb_ok
st_2 st_2
st_1 st_1
end type
global w_receivable_warming_message w_receivable_warming_message

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_receivable_warming_message
	
	<OBJECT>
	</OBJECT>
	<DESC>
	Sure this was meant to be called w_receivable_warNing_message
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
		Date			CR-Ref		Author 		Comments
     	11/08/2014	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_receivable_warming_message.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
end on

on w_receivable_warming_message.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_2)
destroy(this.st_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_receivable_warming_message
end type

type cb_ok from commandbutton within w_receivable_warming_message
integer x = 553
integer y = 948
integer width = 338
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;close(parent)
end event

type st_2 from statictext within w_receivable_warming_message
integer x = 59
integer y = 572
integer width = 1326
integer height = 228
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Please cancel proces in next step if this is not correct."
boolean focusrectangle = false
end type

type st_1 from statictext within w_receivable_warming_message
integer x = 59
integer y = 60
integer width = 1326
integer height = 304
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Datetime received differs from estimated due date with more than 30 days."
boolean focusrectangle = false
end type

