$PBExportHeader$w_delme_convert_password.srw
$PBExportComments$delete after conversion is finished
forward
global type w_delme_convert_password from mt_w_response
end type
type cb_cancel from commandbutton within w_delme_convert_password
end type
type cb_ok from commandbutton within w_delme_convert_password
end type
type sle_password from singlelineedit within w_delme_convert_password
end type
type st_1 from statictext within w_delme_convert_password
end type
end forward

global type w_delme_convert_password from mt_w_response
integer x = 672
integer y = 264
integer width = 1262
integer height = 380
string title = "Enter SA password"
cb_cancel cb_cancel
cb_ok cb_ok
sle_password sle_password
st_1 st_1
end type
global w_delme_convert_password w_delme_convert_password

type variables
string is_password
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_delme_convert_password
	
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

on w_delme_convert_password.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_password=create sle_password
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.sle_password
this.Control[iCurrent+4]=this.st_1
end on

on w_delme_convert_password.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_password)
destroy(this.st_1)
end on

event open;is_password = message.StringParm
end event

type cb_cancel from commandbutton within w_delme_convert_password
integer x = 933
integer y = 144
integer width = 219
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

on clicked;// cb_cancel - close window

Close(Parent)
end on

type cb_ok from commandbutton within w_delme_convert_password
integer x = 677
integer y = 144
integer width = 219
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;if is_password = "" then is_password = "rmortensen"

if trim(sle_password.text) <> is_password then
	MessageBox("Logon", "Password not correct.")
	closewithreturn(parent, -1)
else
	closewithreturn(parent, 1)
end if
	
end event

type sle_password from singlelineedit within w_delme_convert_password
integer x = 73
integer y = 144
integer width = 549
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
boolean autohscroll = false
boolean password = true
end type

type st_1 from statictext within w_delme_convert_password
integer x = 55
integer y = 48
integer width = 1115
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Please enter the system converters password:"
boolean focusrectangle = false
end type

