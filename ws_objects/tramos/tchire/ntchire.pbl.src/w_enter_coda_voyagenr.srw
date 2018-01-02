$PBExportHeader$w_enter_coda_voyagenr.srw
$PBExportComments$Receive Hire. Used as user input for TC  voyage number when generating CODA Receivables
forward
global type w_enter_coda_voyagenr from mt_w_response
end type
type st_year from statictext within w_enter_coda_voyagenr
end type
type st_4 from statictext within w_enter_coda_voyagenr
end type
type voyage_nr from editmask within w_enter_coda_voyagenr
end type
type cb_2 from commandbutton within w_enter_coda_voyagenr
end type
type cb_1 from commandbutton within w_enter_coda_voyagenr
end type
type st_3 from statictext within w_enter_coda_voyagenr
end type
end forward

global type w_enter_coda_voyagenr from mt_w_response
integer x = 672
integer y = 264
integer width = 997
integer height = 712
string title = "Enter Voyage....."
boolean controlmenu = false
long backcolor = 80269524
st_year st_year
st_4 st_4
voyage_nr voyage_nr
cb_2 cb_2
cb_1 cb_1
st_3 st_3
end type
global w_enter_coda_voyagenr w_enter_coda_voyagenr

type variables
s_disbursement lstr_disb
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_enter_coda_voyagenr
	
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

on w_enter_coda_voyagenr.create
int iCurrent
call super::create
this.st_year=create st_year
this.st_4=create st_4
this.voyage_nr=create voyage_nr
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_year
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.voyage_nr
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_3
end on

on w_enter_coda_voyagenr.destroy
call super::destroy
destroy(this.st_year)
destroy(this.st_4)
destroy(this.voyage_nr)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_3)
end on

event open;long ll_year

st_year.text = String(Message.DoubleParm + 1999)





end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_enter_coda_voyagenr
end type

type st_year from statictext within w_enter_coda_voyagenr
integer x = 261
integer y = 92
integer width = 201
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
string text = "XXXX"
boolean focusrectangle = false
end type

type st_4 from statictext within w_enter_coda_voyagenr
integer x = 32
integer y = 188
integer width = 919
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Voyage nr must be 5 digits long."
boolean focusrectangle = false
end type

type voyage_nr from editmask within w_enter_coda_voyagenr
integer x = 302
integer y = 300
integer width = 375
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxx"
string displaydata = "~b"
end type

type cb_2 from commandbutton within w_enter_coda_voyagenr
integer x = 544
integer y = 464
integer width = 343
integer height = 100
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

type cb_1 from commandbutton within w_enter_coda_voyagenr
integer x = 91
integer y = 464
integer width = 343
integer height = 100
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

if mid(st_year.text,3,4) <> mid(ls_voyage,1,2) then
	MessageBox("Error","Voyage number must match year. (2003 -> 03xxx)")
	voyage_nr.SetFocus()
	Return
END IF
	
CloseWithReturn(parent, ls_voyage)

end event

type st_3 from statictext within w_enter_coda_voyagenr
integer x = 32
integer y = 24
integer width = 887
integer height = 132
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Please enter the voyage number for year:"
boolean focusrectangle = false
end type

