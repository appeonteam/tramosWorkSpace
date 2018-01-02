$PBExportHeader$w_enter_nonportexp_voyagenr.srw
$PBExportComments$Receive Hire. Used as user input for TC  voyage number when generating CODA Receivables and activity periode and voyagenr don't match
forward
global type w_enter_nonportexp_voyagenr from mt_w_response
end type
type dw_portcalls from datawindow within w_enter_nonportexp_voyagenr
end type
type st_1 from statictext within w_enter_nonportexp_voyagenr
end type
type st_year from statictext within w_enter_nonportexp_voyagenr
end type
type st_4 from statictext within w_enter_nonportexp_voyagenr
end type
type voyage_nr from editmask within w_enter_nonportexp_voyagenr
end type
type cb_2 from commandbutton within w_enter_nonportexp_voyagenr
end type
type cb_1 from commandbutton within w_enter_nonportexp_voyagenr
end type
type st_3 from statictext within w_enter_nonportexp_voyagenr
end type
end forward

global type w_enter_nonportexp_voyagenr from mt_w_response
integer x = 672
integer y = 264
integer width = 3054
integer height = 932
string title = "Enter Voyage....."
boolean controlmenu = false
long backcolor = 80269524
dw_portcalls dw_portcalls
st_1 st_1
st_year st_year
st_4 st_4
voyage_nr voyage_nr
cb_2 cb_2
cb_1 cb_1
st_3 st_3
end type
global w_enter_nonportexp_voyagenr w_enter_nonportexp_voyagenr

type variables
s_enter_nonportexp_voyagenr_parm	istr_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_enter_nonportexp_voyagenr
	
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
      13/05/2015  CR3896      SSX014      removed the validation of activity period against voyage numbers
	</HISTORY>
********************************************************************/
end subroutine

on w_enter_nonportexp_voyagenr.create
int iCurrent
call super::create
this.dw_portcalls=create dw_portcalls
this.st_1=create st_1
this.st_year=create st_year
this.st_4=create st_4
this.voyage_nr=create voyage_nr
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_portcalls
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_year
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.voyage_nr
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.st_3
end on

on w_enter_nonportexp_voyagenr.destroy
call super::destroy
destroy(this.dw_portcalls)
destroy(this.st_1)
destroy(this.st_year)
destroy(this.st_4)
destroy(this.voyage_nr)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_3)
end on

event open;istr_parm = Message.powerObjectParm

st_year.text = string(istr_parm.activity_period, "MM-YYYY")

dw_portcalls.setTransObject(sqlca)
dw_portcalls.post retrieve(istr_parm.vessel_nr, istr_parm.activity_period)






end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_enter_nonportexp_voyagenr
end type

type dw_portcalls from datawindow within w_enter_nonportexp_voyagenr
integer x = 1179
integer y = 40
integer width = 1842
integer height = 788
integer taborder = 10
string title = "none"
string dataobject = "d_sq_nonportexp_activity_period_portcalls"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_enter_nonportexp_voyagenr
integer x = 27
integer y = 24
integer width = 1097
integer height = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
string text = "TC Period voyage number and non-port expense activity period don~'t match."
boolean focusrectangle = false
end type

type st_year from statictext within w_enter_nonportexp_voyagenr
integer x = 421
integer y = 284
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
string text = "XX-XXXX"
boolean focusrectangle = false
end type

type st_4 from statictext within w_enter_nonportexp_voyagenr
integer x = 32
integer y = 396
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

type voyage_nr from editmask within w_enter_nonportexp_voyagenr
integer x = 361
integer y = 508
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

type cb_2 from commandbutton within w_enter_nonportexp_voyagenr
integer x = 576
integer y = 672
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;


IF MessageBox("W A R N I N G","If you cancel input of voyage number, the settling is  " &
										+ "is cleared !!! Are you sure you want to Cancel ?",Exclamation!,YesNo!) = 1 THEN 
	CloseWithReturn(parent,"0")
ELSE
	Return
END IF

end event

type cb_1 from commandbutton within w_enter_nonportexp_voyagenr
integer x = 123
integer y = 672
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;String ls_voyage

ls_voyage = voyage_nr.text

IF NOT(LEN(ls_voyage)) = 5 THEN
	MessageBox("Error","Voyage nr is not valid. Must be 5 digits long.")
	voyage_nr.SetFocus()
	Return
END IF

CloseWithReturn(parent, ls_voyage)

end event

type st_3 from statictext within w_enter_nonportexp_voyagenr
integer x = 27
integer y = 216
integer width = 978
integer height = 132
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Please enter the voyage number for activity period:"
boolean focusrectangle = false
end type

