$PBExportHeader$w_confirm_unsettle.srw
forward
global type w_confirm_unsettle from mt_w_response
end type
type cb_cancel from commandbutton within w_confirm_unsettle
end type
type cb_codacms from commandbutton within w_confirm_unsettle
end type
type cb_coda from commandbutton within w_confirm_unsettle
end type
type st_2 from statictext within w_confirm_unsettle
end type
type st_1 from statictext within w_confirm_unsettle
end type
end forward

global type w_confirm_unsettle from mt_w_response
integer width = 1728
integer height = 692
string title = "Confirm Un-Settle"
boolean controlmenu = false
cb_cancel cb_cancel
cb_codacms cb_codacms
cb_coda cb_coda
st_2 st_2
st_1 st_1
end type
global w_confirm_unsettle w_confirm_unsettle

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_confirm_unsettle
	
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

on w_confirm_unsettle.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_codacms=create cb_codacms
this.cb_coda=create cb_coda
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_codacms
this.Control[iCurrent+3]=this.cb_coda
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
end on

on w_confirm_unsettle.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_codacms)
destroy(this.cb_coda)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;this.move(w_tramos_main.x +1000, w_tramos_main.y +1000)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_confirm_unsettle
end type

type cb_cancel from commandbutton within w_confirm_unsettle
integer x = 1138
integer y = 428
integer width = 393
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean default = true
end type

event clicked;closewithreturn(parent, 3)
end event

type cb_codacms from commandbutton within w_confirm_unsettle
integer x = 663
integer y = 428
integer width = 393
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CODA + C&MS"
end type

event clicked;closewithreturn(parent, 1)
end event

type cb_coda from commandbutton within w_confirm_unsettle
integer x = 187
integer y = 428
integer width = 393
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&CODA"
end type

event clicked;closewithreturn(parent, 2)
end event

type st_2 from statictext within w_confirm_unsettle
integer x = 50
integer y = 244
integer width = 1573
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Would you like to un-settle both CODA and CMS or CODA only?"
boolean focusrectangle = false
end type

type st_1 from statictext within w_confirm_unsettle
integer x = 50
integer y = 44
integer width = 1641
integer height = 148
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "When un-settling payments you can select between un-settling both CODA and CMS, or only CODA transactions."
boolean focusrectangle = false
end type

