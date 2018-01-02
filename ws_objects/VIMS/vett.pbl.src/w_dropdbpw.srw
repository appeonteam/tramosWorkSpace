$PBExportHeader$w_dropdbpw.srw
forward
global type w_dropdbpw from window
end type
type st_valid from statictext within w_dropdbpw
end type
type st_text from statictext within w_dropdbpw
end type
type cb_close from commandbutton within w_dropdbpw
end type
type cb_copy from commandbutton within w_dropdbpw
end type
type sle_pw from singlelineedit within w_dropdbpw
end type
type st_3 from statictext within w_dropdbpw
end type
type gb_1 from groupbox within w_dropdbpw
end type
end forward

global type w_dropdbpw from window
integer width = 1298
integer height = 736
boolean titlebar = true
string title = "VM DB Deletion"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_valid st_valid
st_text st_text
cb_close cb_close
cb_copy cb_copy
sle_pw sle_pw
st_3 st_3
gb_1 gb_1
end type
global w_dropdbpw w_dropdbpw

forward prototypes
public function string wf_createpassword ()
end prototypes

public function string wf_createpassword ();Long ll_Value
Integer li_Loop
String ls_PW, ls_Month

ll_Value = Year(Today())

ll_Value *= ll_Value + Month(Today())    // Square Year and add month

ll_Value = Mod(1073741824, ll_Value)    // Get remainder when 2^30 is divided by value

ls_Month = String(Today(), "mmm")

st_Valid.Text = 'Valid through ' + String(today(), "mmmm yyyy")

For li_Loop = 1 to 3  // Add cube of ASCII of each character in userid
	ll_Value += AscA(Mid(ls_Month, li_Loop, 1)) * AscA(Mid(ls_Month, li_Loop, 1)) * AscA(Mid(ls_Month, li_Loop, 1))
Next 

ls_PW = String(ll_Value)      // Convert to string

Do While Len(ls_PW) < 6       // If less than 6 digits, add zeros to beginning
	ls_PW = '0' + ls_PW
Loop

li_Loop = Integer(Left(ls_PW, 1)) * 2   // Get value of first char and multiply by 2

ls_PW = CharA(66 + li_Loop) + Right(ls_PW, Len(ls_PW) - 1)   // Convert first char into alphabet

Return ls_PW
end function

on w_dropdbpw.create
this.st_valid=create st_valid
this.st_text=create st_text
this.cb_close=create cb_close
this.cb_copy=create cb_copy
this.sle_pw=create sle_pw
this.st_3=create st_3
this.gb_1=create gb_1
this.Control[]={this.st_valid,&
this.st_text,&
this.cb_close,&
this.cb_copy,&
this.sle_pw,&
this.st_3,&
this.gb_1}
end on

on w_dropdbpw.destroy
destroy(this.st_valid)
destroy(this.st_text)
destroy(this.cb_close)
destroy(this.cb_copy)
destroy(this.sle_pw)
destroy(this.st_3)
destroy(this.gb_1)
end on

event open;
sle_pw.Text = wf_CreatePassword()
end event

type st_valid from statictext within w_dropdbpw
integer x = 73
integer y = 384
integer width = 1115
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_text from statictext within w_dropdbpw
integer x = 73
integer y = 256
integer width = 1051
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "The above password can be used to delete a VIMS Mobile database."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_dropdbpw
integer x = 421
integer y = 528
integer width = 439
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_copy from commandbutton within w_dropdbpw
integer x = 987
integer y = 144
integer width = 183
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
Clipboard(sle_pw.Text)

Messagebox("Password Copied", "The password was copied to the clipboard.")
end event

type sle_pw from singlelineedit within w_dropdbpw
integer x = 73
integer y = 144
integer width = 914
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_dropdbpw
integer x = 73
integer y = 64
integer width = 832
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database Deletion Password:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_dropdbpw
integer x = 18
integer width = 1243
integer height = 496
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
end type

