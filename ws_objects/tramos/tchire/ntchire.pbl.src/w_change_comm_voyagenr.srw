$PBExportHeader$w_change_comm_voyagenr.srw
$PBExportComments$Change NTC Commissions voyage number
forward
global type w_change_comm_voyagenr from mt_w_response
end type
type st_4 from statictext within w_change_comm_voyagenr
end type
type voyage_nr from editmask within w_change_comm_voyagenr
end type
type cb_cancel from commandbutton within w_change_comm_voyagenr
end type
type cb_ok from commandbutton within w_change_comm_voyagenr
end type
type st_3 from statictext within w_change_comm_voyagenr
end type
end forward

global type w_change_comm_voyagenr from mt_w_response
integer x = 672
integer y = 264
integer width = 1477
integer height = 612
string title = "Enter Voyage....."
boolean controlmenu = false
long backcolor = 80269524
st_4 st_4
voyage_nr voyage_nr
cb_cancel cb_cancel
cb_ok cb_ok
st_3 st_3
end type
global w_change_comm_voyagenr w_change_comm_voyagenr

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_change_comm_voyagenr
	
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

on w_change_comm_voyagenr.create
int iCurrent
call super::create
this.st_4=create st_4
this.voyage_nr=create voyage_nr
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.voyage_nr
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_3
end on

on w_change_comm_voyagenr.destroy
call super::destroy
destroy(this.st_4)
destroy(this.voyage_nr)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_3)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_change_comm_voyagenr
end type

type st_4 from statictext within w_change_comm_voyagenr
integer x = 32
integer y = 188
integer width = 997
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Voyage nr must be 5 digits number or ~"REV~"."
boolean focusrectangle = false
end type

type voyage_nr from editmask within w_change_comm_voyagenr
integer x = 1070
integer y = 176
integer width = 306
integer height = 92
integer taborder = 10
integer textsize = -8
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

type cb_cancel from commandbutton within w_change_comm_voyagenr
integer x = 754
integer y = 372
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;
CloseWithReturn(parent,"0")

end event

type cb_ok from commandbutton within w_change_comm_voyagenr
integer x = 302
integer y = 372
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;String ls_voyage

ls_voyage = voyage_nr.text

IF LEN(ls_voyage) <> 5 and ls_voyage <> "REV" THEN
	MessageBox("Error","Voyage nr is not valid. Must be 5 digits number or equal to 'REV'.")
	voyage_nr.SetFocus()
	Return
END IF

CloseWithReturn(parent, ls_voyage)

end event

type st_3 from statictext within w_change_comm_voyagenr
integer x = 32
integer y = 8
integer width = 1440
integer height = 180
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "When changing the Voyage number, please remember to transfer the amount manually in CODA!"
boolean focusrectangle = false
end type

