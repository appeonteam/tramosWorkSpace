$PBExportHeader$w_flatrate_new.srw
forward
global type w_flatrate_new from mt_w_response
end type
type cb_1 from mt_u_commandbutton within w_flatrate_new
end type
type st_1 from mt_u_statictext within w_flatrate_new
end type
type sle_year from mt_u_singlelineedit within w_flatrate_new
end type
end forward

global type w_flatrate_new from mt_w_response
integer width = 1733
integer height = 196
cb_1 cb_1
st_1 st_1
sle_year sle_year
end type
global w_flatrate_new w_flatrate_new

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_flatrate_new
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_flatrate_new.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_year=create sle_year
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_year
end on

on w_flatrate_new.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_year)
end on

event close;closewithreturn(this,integer(sle_year.text))
end event

type cb_1 from mt_u_commandbutton within w_flatrate_new
integer x = 1486
integer width = 219
integer taborder = 20
string text = "Ok"
end type

event clicked;call super::clicked;closewithreturn(parent,integer(sle_year.text))
end event

type st_1 from mt_u_statictext within w_flatrate_new
integer x = 14
integer y = 16
integer width = 1239
integer weight = 700
string text = "Please enter the new year for the flatrate here:"
end type

type sle_year from mt_u_singlelineedit within w_flatrate_new
integer x = 1248
integer width = 219
integer taborder = 10
boolean bringtotop = true
string text = ""
end type

