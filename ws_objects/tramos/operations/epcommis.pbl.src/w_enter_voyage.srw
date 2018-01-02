$PBExportHeader$w_enter_voyage.srw
$PBExportComments$Used as user input for TC commissions voyage number
forward
global type w_enter_voyage from mt_w_response
end type
type st_vessel from statictext within w_enter_voyage
end type
type st_4 from statictext within w_enter_voyage
end type
type st_1 from statictext within w_enter_voyage
end type
type voyage_nr from editmask within w_enter_voyage
end type
type cb_2 from commandbutton within w_enter_voyage
end type
type cb_1 from commandbutton within w_enter_voyage
end type
type st_disb_1 from statictext within w_enter_voyage
end type
type st_3 from statictext within w_enter_voyage
end type
end forward

global type w_enter_voyage from mt_w_response
integer x = 672
integer y = 264
integer width = 1088
integer height = 776
string title = "Voyage Exchange Rate"
boolean controlmenu = false
long backcolor = 81324524
st_vessel st_vessel
st_4 st_4
st_1 st_1
voyage_nr voyage_nr
cb_2 cb_2
cb_1 cb_1
st_disb_1 st_disb_1
st_3 st_3
end type
global w_enter_voyage w_enter_voyage

type variables
s_disbursement lstr_disb
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_enter_voyage
	
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

on w_enter_voyage.create
int iCurrent
call super::create
this.st_vessel=create st_vessel
this.st_4=create st_4
this.st_1=create st_1
this.voyage_nr=create voyage_nr
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_disb_1=create st_disb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_vessel
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.voyage_nr
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_disb_1
this.Control[iCurrent+8]=this.st_3
end on

on w_enter_voyage.destroy
call super::destroy
destroy(this.st_vessel)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.voyage_nr)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_disb_1)
destroy(this.st_3)
end on

event open;SELECT VESSEL_REF_NR
INTO :st_vessel.text
FROM VESSELS
WHERE VESSEL_NR = :Message.DoubleParm;

//st_vessel.text = String(Message.DoubleParm)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_enter_voyage
end type

type st_vessel from statictext within w_enter_voyage
integer x = 210
integer y = 16
integer width = 197
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_enter_voyage
integer x = 59
integer y = 208
integer width = 960
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Voyage nr must be 5 digits long."
boolean focusrectangle = false
end type

type st_1 from statictext within w_enter_voyage
integer x = 411
integer y = 20
integer width = 457
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = " is a TC vessel. "
alignment alignment = right!
boolean focusrectangle = false
end type

type voyage_nr from editmask within w_enter_voyage
integer x = 357
integer y = 412
integer width = 375
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxx"
string displaydata = "~b"
end type

type cb_2 from commandbutton within w_enter_voyage
integer x = 603
integer y = 544
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;


IF MessageBox("W A R N I N G","If you cancel input of voyage number, the settling is  " &
										+ "is cleared !!! Are you sure you want to Cancel ?",Exclamation!,YesNo!) = 1 THEN 
	CloseWithReturn(parent,"0")
ELSE
	Return
END IF

end event

type cb_1 from commandbutton within w_enter_voyage
integer x = 224
integer y = 548
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;String ls_voyage

ls_voyage = voyage_nr.text

IF NOT(LEN(ls_voyage)) = 5 THEN
	MessageBox("Error","Voyage nr is not valid. Must be 5 digits long.")
	voyage_nr.SetFocus()
	Return
END IF

CloseWithReturn(parent,ls_voyage)

end event

type st_disb_1 from statictext within w_enter_voyage
integer x = 23
integer y = 312
integer width = 974
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "This  will be used for  CMS/Print."
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_enter_voyage
integer x = 46
integer y = 108
integer width = 1006
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Please enter the voyage number."
boolean focusrectangle = false
end type

