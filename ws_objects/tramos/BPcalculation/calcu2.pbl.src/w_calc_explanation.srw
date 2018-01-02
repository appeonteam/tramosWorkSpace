$PBExportHeader$w_calc_explanation.srw
$PBExportComments$Will show all calculation part results in a calculation. Not fully implemented
forward
global type w_calc_explanation from mt_w_response_calc
end type
type cb_close from commandbutton within w_calc_explanation
end type
type mle_text from multilineedit within w_calc_explanation
end type
end forward

global type w_calc_explanation from mt_w_response_calc
integer width = 2226
integer height = 1476
string title = "Calculation Explanation"
long backcolor = 32304364
cb_close cb_close
mle_text mle_text
end type
global w_calc_explanation w_calc_explanation

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_explanation
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

on open;call mt_w_response_calc::open;mle_text.text = Message.StringParm
end on

on w_calc_explanation.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.mle_text=create mle_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.mle_text
end on

on w_calc_explanation.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.mle_text)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_explanation
end type

type cb_close from commandbutton within w_calc_explanation
integer x = 1847
integer y = 1264
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;Close(Parent)
end on

type mle_text from multilineedit within w_calc_explanation
integer x = 27
integer y = 32
integer width = 2158
integer height = 1200
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean hscrollbar = true
boolean vscrollbar = true
end type

