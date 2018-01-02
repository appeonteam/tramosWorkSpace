$PBExportHeader$w_login_changepassword.srw
$PBExportComments$Window to change current users password when expired
forward
global type w_login_changepassword from mt_w_response
end type
type st_2 from statictext within w_login_changepassword
end type
type sle_oldpassword from singlelineedit within w_login_changepassword
end type
type st_1 from statictext within w_login_changepassword
end type
type cb_help from commandbutton within w_login_changepassword
end type
type sle_password_retyped from singlelineedit within w_login_changepassword
end type
type sle_password from singlelineedit within w_login_changepassword
end type
type cb_cancel from commandbutton within w_login_changepassword
end type
type cb_changepassword from commandbutton within w_login_changepassword
end type
type st_password from statictext within w_login_changepassword
end type
type st_userid from statictext within w_login_changepassword
end type
type gb_1 from groupbox within w_login_changepassword
end type
end forward

global type w_login_changepassword from mt_w_response
integer x = 773
integer y = 648
integer width = 1339
integer height = 700
string title = "Change password"
boolean controlmenu = false
long backcolor = 81324524
st_2 st_2
sle_oldpassword sle_oldpassword
st_1 st_1
cb_help cb_help
sle_password_retyped sle_password_retyped
sle_password sle_password
cb_cancel cb_cancel
cb_changepassword cb_changepassword
st_password st_password
st_userid st_userid
gb_1 gb_1
end type
global w_login_changepassword w_login_changepassword

type variables
string is_userid
end variables

event open;string ls_parm

ls_parm = message.StringParm  /* Consists of userid and password separated by "," (comma) */

is_userid = mid(ls_parm,1, pos(ls_parm, ",",1) -1)
sle_oldpassword.text = mid(ls_parm, pos(ls_parm, ",",1) +1, len(ls_parm))

Setfocus(sle_password)
end event

on w_login_changepassword.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_oldpassword=create sle_oldpassword
this.st_1=create st_1
this.cb_help=create cb_help
this.sle_password_retyped=create sle_password_retyped
this.sle_password=create sle_password
this.cb_cancel=create cb_cancel
this.cb_changepassword=create cb_changepassword
this.st_password=create st_password
this.st_userid=create st_userid
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_oldpassword
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_help
this.Control[iCurrent+5]=this.sle_password_retyped
this.Control[iCurrent+6]=this.sle_password
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.cb_changepassword
this.Control[iCurrent+9]=this.st_password
this.Control[iCurrent+10]=this.st_userid
this.Control[iCurrent+11]=this.gb_1
end on

on w_login_changepassword.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_oldpassword)
destroy(this.st_1)
destroy(this.cb_help)
destroy(this.sle_password_retyped)
destroy(this.sle_password)
destroy(this.cb_cancel)
destroy(this.cb_changepassword)
destroy(this.st_password)
destroy(this.st_userid)
destroy(this.gb_1)
end on

type st_2 from statictext within w_login_changepassword
integer x = 14
integer y = 36
integer width = 1303
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Your password has expired, and must be changed."
boolean focusrectangle = false
end type

type sle_oldpassword from singlelineedit within w_login_changepassword
event key pbm_keydown
integer x = 736
integer y = 164
integer width = 457
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
boolean autohscroll = false
boolean password = true
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

on key;IF KeyDown(KeyDownArrow!) THEN
	SetFocus(sle_password)
END IF
end on

type st_1 from statictext within w_login_changepassword
integer x = 114
integer y = 172
integer width = 539
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Current password:"
boolean focusrectangle = false
end type

type cb_help from commandbutton within w_login_changepassword
event key pbm_keydown
integer x = 165
integer y = 496
integer width = 219
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Help"
end type

on key;IF KeyDown(KeyEnter!) THEN
	TriggerEvent(this, "clicked")	
END IF
end on

on clicked;ShowHelp("CACAS.HLP", keyword!, "Change password")
end on

type sle_password_retyped from singlelineedit within w_login_changepassword
event key pbm_keydown
integer x = 736
integer y = 356
integer width = 457
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
boolean password = true
integer limit = 35
borderstyle borderstyle = stylelowered!
end type

on key;IF KeyDown(KeyUpArrow!) THEN
	SetFocus(sle_password)
END IF

IF KeyDown(KeyDownArrow!) THEN
	SetFocus(cb_changepassword)
END IF

IF KeyDown(KeyEnter!) THEN
	SetFocus(cb_changepassword)
	TriggerEvent(cb_changepassword, "clicked")	
END IF


end on

type sle_password from singlelineedit within w_login_changepassword
event key pbm_keydown
integer x = 736
integer y = 260
integer width = 457
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
boolean password = true
integer limit = 35
borderstyle borderstyle = stylelowered!
end type

on key;IF KeyDown(KeyDownArrow!) THEN
	SetFocus(sle_password_retyped)
END IF

IF KeyDown(KeyUpArrow!) THEN
	SetFocus(sle_oldpassword)
END IF

end on

type cb_cancel from commandbutton within w_login_changepassword
event key pbm_keydown
integer x = 421
integer y = 496
integer width = 219
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

on key;IF KeyDown(KeyEnter!) THEN
	TriggerEvent(this, "clicked")	
END IF
end on

event clicked;// cb_cancel.clicked! Close window and exit

CloseWithReturn(parent, "NULL")
end event

type cb_changepassword from commandbutton within w_login_changepassword
event key pbm_keydown
integer x = 677
integer y = 496
integer width = 489
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Change &password"
boolean default = true
end type

event clicked;// Check that all fields is filed out, and that newpassword and newpassword repeated is equal
STRING 	ls_sql
long		ll_chars, ll_char
boolean	lb_pwOK=false

IF (Len(sle_oldpassword.text) = 0) THEN
	Messagebox("Current password is not entered", "The current password is required in order to change the password.~r~rEnter the current password and re-try.", Information!, OK!)
	POST Setfocus(sle_oldpassword)
	return
END IF

IF (Len(sle_password.text) = 0) THEN
	Messagebox("New password is not entered", "The new password is required in order to change the password.~r~rEnter the new password and re-try.", Information!, OK!)
	POST Setfocus(sle_password)
	return
END IF

IF (Len(sle_password_retyped.text) = 0)  THEN
	Messagebox("New password is not re-typed", "The new password is required to re-type in order to change the password.~r~rRe-type the new password and re-try.", Information!, OK!)
	POST Setfocus(sle_password_retyped)
	return
END IF

IF (sle_password.text = upper(sle_password.text)) or ( sle_password.text = lower(sle_password.text)) then
	Messagebox("Password missing small or capital letters", "The new password need to have small and capital letters, numbers or special characters,~r"+&
					"and have to be at least 8 characters long~r~rEnter the new password and re-try.", Information!, OK!)
	POST Setfocus(sle_password)
	return
END IF

/* Password need to have text and number or special characters */
ll_chars = len(sle_password.text)
for ll_char = 1 to ll_chars
	choose case asc(mid(sle_password.text,ll_char,1))
		case 33 to 64, 91 to 93, 123 to 126
			lb_pwOK = true
			exit 
	end choose
next
IF not lb_pwOK THEN
	Messagebox("Password missing number", "The new password need to have small and capital letters, numbers or special characters,~r"+&
					"and have to be at least 8 characters long~r~rEnter the new password and re-try.", Information!, OK!)
	POST Setfocus(sle_password)
	return
END IF

IF (sle_password.text <> sle_password_retyped.text) THEN
	Messagebox("Password and retyped password does not match","The password and the retyped password must be identical.~r~rRe-type password and the retyped password and try again.",Information!, OK!)
	POST Setfocus(sle_password)
	return
END IF

IF len(sle_password.text) < 8 THEN
	Messagebox("Password to short","The password entered is less than 8 characters.~r~rRe-type password and the retyped password and try again.",Information!, OK!)
	POST Setfocus(sle_password)
	return
END IF

// If new password has been entered - try changing password in SQL-server
// Check if password is used before
if f_check_pw (uo_global.is_userid, sle_password.text) = -1 then
	MessageBox("Wrong Password", "This password is used before. Please try again!")
	POST SetFocus(sle_password)
	return
end if

// Enable auto Commit, needed for sp_xx procedures 
SQLCA.AutoCommit = TRUE
ls_sql = 'sp_password "'+sle_oldpassword.text+'", "'+sle_password.text+'"'
EXECUTE IMMEDIATE :ls_sql USING SQLCA;
IF SQLCA.SqlCode = 0 THEN
	SQLCA.LogPass = sle_password.text
	Messagebox("Password changed", "Password was successfully changed.")
	// Disable auto Commit, needed for sp_xx procedures 
	SQLCA.AutoCommit = FALSE
	uo_global.is_password = sle_password.text
	CloseWithReturn(Parent, sle_password.text)
ELSE // if failure display messagebox
	Messagebox("Password not changed", "Password was not changed.~r~rRe-try the operation.~r~rReason:~r" + SQLCA.SqlErrText)
END IF

// Disable auto Commit, needed for sp_xx procedures 
SQLCA.AutoCommit = FALSE

end event

type st_password from statictext within w_login_changepassword
integer x = 114
integer y = 368
integer width = 622
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Confirm new password:"
boolean focusrectangle = false
end type

type st_userid from statictext within w_login_changepassword
integer x = 114
integer y = 272
integer width = 453
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "New password:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_login_changepassword
integer x = 78
integer y = 100
integer width = 1170
integer height = 368
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
end type

