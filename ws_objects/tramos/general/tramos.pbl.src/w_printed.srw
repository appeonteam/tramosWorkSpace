$PBExportHeader$w_printed.srw
$PBExportComments$Printed signal window
forward
global type w_printed from mt_w_response
end type
type st_1 from statictext within w_printed
end type
end forward

global type w_printed from mt_w_response
integer x = 672
integer y = 264
integer width = 667
integer height = 136
boolean border = false
long backcolor = 16777215
boolean ib_enablef1help = false
event ue_delay pbm_custom08
st_1 st_1
end type
global w_printed w_printed

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_printed
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor + disabled f1 help
	</HISTORY>
********************************************************************/
end subroutine

event timer;Close(w_printed)
end event

on open;move(1550,550)
timer(0.2)
end on

on w_printed.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_printed.destroy
call super::destroy
destroy(this.st_1)
end on

type st_1 from statictext within w_printed
integer x = 18
integer y = 16
integer width = 622
integer height = 112
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "PRINTED"
alignment alignment = center!
boolean focusrectangle = false
end type

