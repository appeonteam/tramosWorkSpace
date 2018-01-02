$PBExportHeader$w_password.srw
forward
global type w_password from window
end type
type cb_cancel from commandbutton within w_password
end type
type cb_ok from commandbutton within w_password
end type
type sle_new2 from singlelineedit within w_password
end type
type sle_new1 from singlelineedit within w_password
end type
type st_3 from statictext within w_password
end type
type st_2 from statictext within w_password
end type
type sle_cur from singlelineedit within w_password
end type
type st_1 from statictext within w_password
end type
type gb_1 from groupbox within w_password
end type
end forward

global type w_password from window
integer width = 1568
integer height = 796
boolean titlebar = true
string title = "Change Password"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Key.ico"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
sle_new2 sle_new2
sle_new1 sle_new1
st_3 st_3
st_2 st_2
sle_cur sle_cur
st_1 st_1
gb_1 gb_1
end type
global w_password w_password

type variables

String is_CurPW

end variables

on w_password.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_new2=create sle_new2
this.sle_new1=create sle_new1
this.st_3=create st_3
this.st_2=create st_2
this.sle_cur=create sle_cur
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.sle_new2,&
this.sle_new1,&
this.st_3,&
this.st_2,&
this.sle_cur,&
this.st_1,&
this.gb_1}
end on

on w_password.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_new2)
destroy(this.sle_new1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_cur)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
f_Write2Log("w_Password Open")

If f_Config("VLPW", is_CurPW, 0) = -1 then
	Messagebox("DB Error", "Could not retrieve current password!", Exclamation!)
	f_Write2Log("w_Password Retrieve Failed()")
	Close(This)
	Return
End If

If g_Obj.paramstring = "XX" then 
	sle_cur.Text = "start"  //  changing password at login
	sle_new1.SetFocus()
Else
	sle_cur.SetFocus( )
End If
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2800)
end event

type cb_cancel from commandbutton within w_password
integer x = 859
integer y = 576
integer width = 549
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.Paramstring = ""
f_Write2Log("w_Password Cancel")

Close(Parent)

end event

type cb_ok from commandbutton within w_password
integer x = 146
integer y = 576
integer width = 549
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Change Password"
boolean default = true
end type

event clicked;Boolean lbool_pwerror

If sle_cur.Text <> is_CurPW then
	Messagebox("Incorrect Password", "The current password entered is not correct. Please try again.", Exclamation!)
	sle_Cur.Text = ""
	sle_Cur.SetFocus( )
	Return
End If

If (sle_new1.Text = "") or (sle_new2.Text = "") then
	Messagebox("New Password", "Please specify the new password in both boxes!", Exclamation!)
	sle_new1.SetFocus( )	
	Return
End If

If sle_New1.Text <> sle_New2.Text then
	Messagebox("New Password", "The new passwords do not match. Please check and try again.")
	sle_new1.SetFocus( )
	Return
End If

If sle_New1.Text = is_CurPW then 
	Messagebox("New Password", "The new password cannot be the same as the current password.")
	sle_new1.Text = ""
	sle_new2.Text = ""
	sle_new1.SetFocus( )
	Return	
End If

lbool_pwerror = False

If Len(sle_new1.Text) < 8 then lbool_pwerror = True  // Less than 8 characters
If Not Match(sle_new1.Text, "[A-Z]") then lbool_pwerror = True  // Has no uppercase alphabets
If Not Match(sle_new1.Text, "[a-z]") then lbool_pwerror = True  // Has no lowercase alphabets
If Not Match(sle_new1.Text, "[0-9]") then lbool_pwerror = True  // Has no numerals

If lbool_pwerror then
	Messagebox("New Password", "The new password does not meet the minimum complexity requirements.~n~nThe new password must be at least 8 characters in length, must contain both upper and lower case alphabets and must contain at least one number.")
	sle_new1.Text = ""
	sle_new2.Text = ""
	sle_new1.SetFocus( )
	Return
End If

is_CurPW = sle_new1.Text

If f_Config("VLPW", is_CurPW, 1) = 0 then
	is_CurPW = String(Year(Today()))
	f_Config("PWYR", is_CurPW, 1)
	Messagebox("Password changed", "The password was changed successfully. Please use the new password at next login.~n~nPlease note that the new password will be valid for the current year only and will require to be changed every year.")
	f_Write2Log("w_Password > Password changed")
	Close(Parent)	
Else
	MessageBox("DB Error", "Unable to save new password!", Exclamation!)
	f_Write2Log("w_Password > Password Change Failed()")
End If
end event

type sle_new2 from singlelineedit within w_password
integer x = 823
integer y = 408
integer width = 658
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type sle_new1 from singlelineedit within w_password
integer x = 823
integer y = 304
integer width = 658
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_password
integer x = 91
integer y = 432
integer width = 645
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Confirm New Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_password
integer x = 91
integer y = 328
integer width = 576
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter New Password:"
boolean focusrectangle = false
end type

type sle_cur from singlelineedit within w_password
integer x = 823
integer y = 112
integer width = 658
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_password
integer x = 91
integer y = 128
integer width = 658
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter Current Password:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_password
integer x = 18
integer y = 16
integer width = 1518
integer height = 528
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

