$PBExportHeader$w_mobilepassword.srw
forward
global type w_mobilepassword from window
end type
type hsb_year from hscrollbar within w_mobilepassword
end type
type st_5 from statictext within w_mobilepassword
end type
type cb_close from commandbutton within w_mobilepassword
end type
type cb_copy from commandbutton within w_mobilepassword
end type
type sle_pw from singlelineedit within w_mobilepassword
end type
type st_year from statictext within w_mobilepassword
end type
type st_3 from statictext within w_mobilepassword
end type
type st_2 from statictext within w_mobilepassword
end type
type st_id from statictext within w_mobilepassword
end type
type st_1 from statictext within w_mobilepassword
end type
type gb_1 from groupbox within w_mobilepassword
end type
end forward

global type w_mobilepassword from window
integer width = 1627
integer height = 748
boolean titlebar = true
string title = "VIMS Mobile Password"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
hsb_year hsb_year
st_5 st_5
cb_close cb_close
cb_copy cb_copy
sle_pw sle_pw
st_year st_year
st_3 st_3
st_2 st_2
st_id st_id
st_1 st_1
gb_1 gb_1
end type
global w_mobilepassword w_mobilepassword

type variables

uo_vmpassword i_pass
end variables

on w_mobilepassword.create
this.hsb_year=create hsb_year
this.st_5=create st_5
this.cb_close=create cb_close
this.cb_copy=create cb_copy
this.sle_pw=create sle_pw
this.st_year=create st_year
this.st_3=create st_3
this.st_2=create st_2
this.st_id=create st_id
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.hsb_year,&
this.st_5,&
this.cb_close,&
this.cb_copy,&
this.sle_pw,&
this.st_year,&
this.st_3,&
this.st_2,&
this.st_id,&
this.st_1,&
this.gb_1}
end on

on w_mobilepassword.destroy
destroy(this.hsb_year)
destroy(this.st_5)
destroy(this.cb_close)
destroy(this.cb_copy)
destroy(this.sle_pw)
destroy(this.st_year)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_id)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
st_id.Text = g_obj.ObjParent

//st_id.Text = "rfaxxx"

st_Year.Text = String(Year(Today()))

sle_pw.Text = i_pass.of_CreateVMPassword(st_id.Text, Integer(st_Year.Text))

end event

type hsb_year from hscrollbar within w_mobilepassword
integer x = 640
integer y = 112
integer width = 128
integer height = 68
end type

event lineleft;
If st_Year.Text > "2000" then	st_Year.Text = String(Integer(st_Year.Text) - 1)	

sle_pw.Text = i_Pass.of_CreateVMPassword(st_id.Text, Integer(st_Year.Text))


end event

event lineright;
If st_Year.Text < "2999" then	st_Year.Text = String(Integer(st_Year.Text) + 1)	

sle_pw.Text = i_Pass.of_CreateVMPassword(st_id.Text, Integer(st_Year.Text))

end event

type st_5 from statictext within w_mobilepassword
integer x = 73
integer y = 384
integer width = 1472
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "The above password is based on the user ID and year and can be used by the user to login on VIMS Mobile vessel installations only."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_mobilepassword
integer x = 585
integer y = 544
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

type cb_copy from commandbutton within w_mobilepassword
integer x = 1353
integer y = 240
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

type sle_pw from singlelineedit within w_mobilepassword
integer x = 439
integer y = 240
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
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_year from statictext within w_mobilepassword
integer x = 439
integer y = 112
integer width = 183
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "0000"
boolean focusrectangle = false
end type

type st_3 from statictext within w_mobilepassword
integer x = 55
integer y = 256
integer width = 366
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_mobilepassword
integer x = 55
integer y = 112
integer width = 201
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year:"
boolean focusrectangle = false
end type

type st_id from statictext within w_mobilepassword
integer x = 439
integer y = 48
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "XXX"
boolean focusrectangle = false
end type

type st_1 from statictext within w_mobilepassword
integer x = 55
integer y = 48
integer width = 256
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "User ID:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_mobilepassword
integer x = 18
integer width = 1573
integer height = 512
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

