$PBExportHeader$w_sysadmin_changepassword.srw
$PBExportComments$Window to change current users password
forward
global type w_sysadmin_changepassword from mt_w_response
end type
type sle_oldpassword from singlelineedit within w_sysadmin_changepassword
end type
type st_1 from statictext within w_sysadmin_changepassword
end type
type sle_password_retyped from singlelineedit within w_sysadmin_changepassword
end type
type sle_password from singlelineedit within w_sysadmin_changepassword
end type
type cb_cancel from commandbutton within w_sysadmin_changepassword
end type
type cb_changepassword from commandbutton within w_sysadmin_changepassword
end type
type st_password from statictext within w_sysadmin_changepassword
end type
type st_userid from statictext within w_sysadmin_changepassword
end type
type gb_1 from groupbox within w_sysadmin_changepassword
end type
end forward

global type w_sysadmin_changepassword from mt_w_response
integer x = 773
integer y = 648
integer width = 1262
integer height = 604
string title = "Change Password"
long backcolor = 81324524
sle_oldpassword sle_oldpassword
st_1 st_1
sle_password_retyped sle_password_retyped
sle_password sle_password
cb_cancel cb_cancel
cb_changepassword cb_changepassword
st_password st_password
st_userid st_userid
gb_1 gb_1
end type
global w_sysadmin_changepassword w_sysadmin_changepassword

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_sysadmin_changepassword
	
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

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_sysadmin_changepassword
  
 Object     : 
  
 Event	:  Open

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Change of userpassword

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
25-8-96		3.0			MI		Changed to CTL3DV2 look  
************************************************************************************/

Setfocus(sle_oldpassword)
end event

on w_sysadmin_changepassword.create
int iCurrent
call super::create
this.sle_oldpassword=create sle_oldpassword
this.st_1=create st_1
this.sle_password_retyped=create sle_password_retyped
this.sle_password=create sle_password
this.cb_cancel=create cb_cancel
this.cb_changepassword=create cb_changepassword
this.st_password=create st_password
this.st_userid=create st_userid
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_oldpassword
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_password_retyped
this.Control[iCurrent+4]=this.sle_password
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_changepassword
this.Control[iCurrent+7]=this.st_password
this.Control[iCurrent+8]=this.st_userid
this.Control[iCurrent+9]=this.gb_1
end on

on w_sysadmin_changepassword.destroy
call super::destroy
destroy(this.sle_oldpassword)
destroy(this.st_1)
destroy(this.sle_password_retyped)
destroy(this.sle_password)
destroy(this.cb_cancel)
destroy(this.cb_changepassword)
destroy(this.st_password)
destroy(this.st_userid)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_sysadmin_changepassword
end type

type sle_oldpassword from singlelineedit within w_sysadmin_changepassword
event key pbm_keydown
integer x = 695
integer y = 64
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
end type

on key;IF KeyDown(KeyDownArrow!) THEN
	SetFocus(sle_password)
END IF
end on

type st_1 from statictext within w_sysadmin_changepassword
integer x = 73
integer y = 68
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
string text = "C&urrent Password:"
boolean focusrectangle = false
end type

type sle_password_retyped from singlelineedit within w_sysadmin_changepassword
event key pbm_keydown
integer x = 695
integer y = 256
integer width = 457
integer height = 80
integer taborder = 30
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

type sle_password from singlelineedit within w_sysadmin_changepassword
event key pbm_keydown
integer x = 695
integer y = 160
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
end type

on key;IF KeyDown(KeyDownArrow!) THEN
	SetFocus(sle_password_retyped)
END IF

IF KeyDown(KeyUpArrow!) THEN
	SetFocus(sle_oldpassword)
END IF

end on

type cb_cancel from commandbutton within w_sysadmin_changepassword
event key pbm_keydown
integer x = 882
integer y = 400
integer width = 343
integer height = 92
integer taborder = 50
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

on clicked;// cb_cancel.clicked! Close window and exit

CLOSE(parent)
end on

type cb_changepassword from commandbutton within w_sysadmin_changepassword
event key pbm_keydown
integer x = 352
integer y = 400
integer width = 512
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Change &Password"
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
	Messagebox("Password changed", "Password was successfully changed.")
	// Disable auto Commit, needed for sp_xx procedures 
	SQLCA.AutoCommit = FALSE
	uo_global.is_password = sle_password.text
	Close(Parent)
ELSE // if failure display messagebox
	Messagebox("Password not changed", "Password was not changed.~r~rRe-try the operation.~r~rReason:~r" + SQLCA.SqlErrText)
	POST SetFocus(sle_password)
END IF

// Disable auto Commit, needed for sp_xx procedures 
SQLCA.AutoCommit = FALSE

end event

type st_password from statictext within w_sysadmin_changepassword
integer x = 73
integer y = 264
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
string text = "Con&firm New Password:"
boolean focusrectangle = false
end type

type st_userid from statictext within w_sysadmin_changepassword
integer x = 73
integer y = 164
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
string text = "&New Password:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sysadmin_changepassword
integer x = 37
integer width = 1179
integer height = 368
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
end type

