$PBExportHeader$w_fixture_note.srw
$PBExportComments$Shows TC Fixture Note saved i DB when Contract was fixtured
forward
global type w_fixture_note from mt_w_response
end type
type cb_ok from commandbutton within w_fixture_note
end type
type cb_print from commandbutton within w_fixture_note
end type
type mle_fixnote from multilineedit within w_fixture_note
end type
end forward

global type w_fixture_note from mt_w_response
integer width = 4457
integer height = 2300
string title = "Show Fixture Note"
cb_ok cb_ok
cb_print cb_print
mle_fixnote mle_fixnote
end type
global w_fixture_note w_fixture_note

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_fixture_note
	
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
		01/09/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

on w_fixture_note.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_print=create cb_print
this.mle_fixnote=create mle_fixnote
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.mle_fixnote
end on

on w_fixture_note.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_print)
destroy(this.mle_fixnote)
end on

event open;mle_fixnote.text = message.StringParm
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_fixture_note
end type

type cb_ok from commandbutton within w_fixture_note
integer x = 1797
integer y = 2068
integer width = 379
integer height = 92
integer taborder = 30
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

type cb_print from commandbutton within w_fixture_note
integer x = 2249
integer y = 2068
integer width = 379
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;long Job

Job = PrintOpen( )

Print(Job, mle_fixnote.text)

PrintClose(Job)
end event

type mle_fixnote from multilineedit within w_fixture_note
integer x = 87
integer y = 144
integer width = 4251
integer height = 1856
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

