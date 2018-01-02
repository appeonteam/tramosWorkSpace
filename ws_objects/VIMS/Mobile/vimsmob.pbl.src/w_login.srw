$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type st_ver from statictext within w_login
end type
type cbx_rem from checkbox within w_login
end type
type cb_cancel from commandbutton within w_login
end type
type cb_login from commandbutton within w_login
end type
type sle_id from singlelineedit within w_login
end type
type st_id from statictext within w_login
end type
type st_user from statictext within w_login
end type
type st_pw from statictext within w_login
end type
type sle_pass from singlelineedit within w_login
end type
type rb_insp from radiobutton within w_login
end type
type rb_vsl from radiobutton within w_login
end type
type rb_gen from radiobutton within w_login
end type
type st_2 from statictext within w_login
end type
type st_1 from statictext within w_login
end type
type p_1 from picture within w_login
end type
type gb_1 from groupbox within w_login
end type
end forward

global type w_login from window
integer width = 1829
integer height = 1424
boolean titlebar = true
string title = "Login"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = fadeanimation!
st_ver st_ver
cbx_rem cbx_rem
cb_cancel cb_cancel
cb_login cb_login
sle_id sle_id
st_id st_id
st_user st_user
st_pw st_pw
sle_pass sle_pass
rb_insp rb_insp
rb_vsl rb_vsl
rb_gen rb_gen
st_2 st_2
st_1 st_1
p_1 p_1
gb_1 gb_1
end type
global w_login w_login

type variables

String is_PW
end variables

forward prototypes
public function boolean wf_checkinspectorpw (string as_userid, string as_pw)
end prototypes

public function boolean wf_checkinspectorpw (string as_userid, string as_pw);Long ll_Value, ll_Year
Integer li_Loop
String ls_PW

ll_Year = Year(Today())   

ll_Year *= ll_Year  // Square Year

ll_Value = Mod(1073741824, ll_Year)    // Get remainder when 2^30 is divided by value

For li_Loop = 1 to Len(as_userid)  // Add cube of ASCII of each character in userid
	ll_Value += AscA(Mid(as_UserID, li_Loop, 1)) * AscA(Mid(as_UserID, li_Loop, 1)) * AscA(Mid(as_UserID, li_Loop, 1))
Next 

ls_PW = String(ll_Value)      // Convert to string

Do While Len(ls_PW) < 6       // If less than 6 digits, add zeros to beginning
	ls_PW = '0' + ls_PW
Loop

li_Loop = Integer(Left(ls_PW, 1)) * 2   // Get value of first char and multiply by 2

ls_PW = CharA(66 + li_Loop) + Right(ls_PW, Len(ls_PW) - 1)   // Convert first char into alphabet

IF ls_PW = as_PW Then Return True Else Return False
end function

on w_login.create
this.st_ver=create st_ver
this.cbx_rem=create cbx_rem
this.cb_cancel=create cb_cancel
this.cb_login=create cb_login
this.sle_id=create sle_id
this.st_id=create st_id
this.st_user=create st_user
this.st_pw=create st_pw
this.sle_pass=create sle_pass
this.rb_insp=create rb_insp
this.rb_vsl=create rb_vsl
this.rb_gen=create rb_gen
this.st_2=create st_2
this.st_1=create st_1
this.p_1=create p_1
this.gb_1=create gb_1
this.Control[]={this.st_ver,&
this.cbx_rem,&
this.cb_cancel,&
this.cb_login,&
this.sle_id,&
this.st_id,&
this.st_user,&
this.st_pw,&
this.sle_pass,&
this.rb_insp,&
this.rb_vsl,&
this.rb_gen,&
this.st_2,&
this.st_1,&
this.p_1,&
this.gb_1}
end on

on w_login.destroy
destroy(this.st_ver)
destroy(this.cbx_rem)
destroy(this.cb_cancel)
destroy(this.cb_login)
destroy(this.sle_id)
destroy(this.st_id)
destroy(this.st_user)
destroy(this.st_pw)
destroy(this.sle_pass)
destroy(this.rb_insp)
destroy(this.rb_vsl)
destroy(this.rb_gen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.gb_1)
end on

event open;String ls_Default

f_Write2Log("w_Login Open")

st_Ver.Text = "Version: " + g_Obj.AppVer + "; Released: " + g_Obj.AppBuilt

If g_Obj.Install = 0 then  // Vessel Install
	// Hide all fields initially
	st_user.Text = ""
	sle_id.Visible = False
	sle_pass.Visible = False
	st_id.Visible = False
	st_pw.Visible = False
	cbx_rem.Visible = False
	If f_registry ("DefLogin", ls_Default, False) = 1 then  // Get last selected login
		Choose Case ls_Default
			Case "0"
				rb_Gen.Checked = True
				rb_Gen.event clicked( )
			Case "1"
				rb_Vsl.Checked = True
				rb_Vsl.event clicked( )
				sle_pass.SetFocus( )
			Case "2"
				rb_Insp.Checked = True
				rb_Insp.event clicked( )
				sle_id.SetFocus( )
		End Choose
	End If
Else   // Inspector Install
	rb_gen.Enabled = False
	rb_vsl.Enabled = False
	rb_Insp.Checked = True
	If g_Obj.UserID > "" then
		sle_id.Text = g_Obj.userid
		sle_id.Enabled = False
	End If
	st_2.Visible = False
	rb_gen.Visible = False
	rb_insp.Visible = False
	rb_vsl.Visible = False
	st_user.y = st_2.y
	sle_id.y -= 500
	st_id.y -= 500
	st_pw.y -= 500
	sle_pass.y -= 500
	cbx_rem.y -= 500
	gb_1.height -= 500
	cb_login.y -= 500
	cb_cancel.y -= 500
	This.Height -= 450
	f_Registry("PRem", ls_Default, False)
	If ls_Default = '1' then
		cbx_rem.Checked = True
		f_Registry("UserP", ls_Default, False)
		sle_pass.Text = ls_Default
		sle_pass.SelectText(Len(ls_Default) + 1, 0)
	End If
	sle_pass.SetFocus( )
End If

If f_config("VLPW", is_pw, 0) = -1 then
	Messagebox("DB Error", "Database access error. Password has been reset.", Exclamation!)
	is_pw = "start"
End If


end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2200)
end event

type st_ver from statictext within w_login
integer x = 293
integer y = 176
integer width = 1317
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type cbx_rem from checkbox within w_login
integer x = 1408
integer y = 1040
integer width = 329
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Remember"
end type

type cb_cancel from commandbutton within w_login
integer x = 1079
integer y = 1200
integer width = 457
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.Login = 255

f_Write2Log("w_Login Cancel")

Close(Parent)


end event

type cb_login from commandbutton within w_login
integer x = 329
integer y = 1200
integer width = 457
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Login"
boolean default = true
end type

event clicked;String ls_Default

If rb_gen.Checked then     // Readonly
	g_Obj.login = 0	
End If

If rb_Vsl.Checked then     // Vessel login

	If sle_pass.Text <> is_pw then  // Password mismatch

		// Check for reset code
	  If (sle_pass.Text = String(Today(), "mmdd") + String(Now(), "hhmm")) and (Upper(g_Obj.Compname) = "PCMASTER" or Upper(g_Obj.Compname) = "SERVER") then
			If Messagebox("Reset Password", "Are you sure you want to reset the password?", Question!, YesNo!) = 2 then Return
			is_pw = 'start'
			SetPointer(HourGlass!)
			If f_config("VLPW", is_pw, 1) = -1 then
				Messagebox("DB Error", "Password was reset but not saved.", Exclamation!)
				f_Write2Log("Password Reset Fail")
			Else
				Messagebox("Password Reset", "The password was reset successfully.")
				f_Write2Log("Password Reset")
			End If
			sle_Pass.Text = ""
			sle_Pass.SetFocus( )
			Return
		End If
		
		// Otherwise deny access
		Messagebox("Access Denied", "The password entered is incorrect. Please check and try again.", Exclamation!)		
		sle_pass.SetFocus( )
		Return
	End If
	
	g_Obj.login = 1
	If is_pw = "start" then  // If default password, ask to change
		g_Obj.paramstring = "XX"	
		Open(w_password)
	End If
End If

If rb_insp.Checked then   // Inspector login
	sle_id.Text = Trim(sle_id.Text)
	If (Len(sle_id.Text) < 6) and (sle_id.Enabled) then  // If userid box is enabled (on vsl installation)
		Messagebox("User ID", "Please enter your unique APMM User ID.", Exclamation!)		
		sle_id.SetFocus()
		sle_id.Selecttext(1, Len(sle_id.Text))
		Return
	End If
	If sle_pass.Text = "" then  // PW not entered
		Messagebox("Mobile Password", "Please enter your VIMS Mobile password.", Exclamation!)
		sle_pass.SetFocus( )
		Return
	End If
	If Not wf_CheckInspectorPW(sle_id.Text, sle_pass.Text) then  // incorrect
		Messagebox("Access Denied", "The User ID or Password is incorrect. Please check and try again.", Exclamation!)
		sle_pass.Setfocus( )
		cbx_rem.Checked = False
		ls_Default = ''
		f_Registry("UserP", ls_Default, True)	
		ls_Default = '0'
		f_Registry("PRem", ls_Default, True)			
		Return
	End If
	g_Obj.Login = 2
	g_Obj.Userid = sle_id.Text 
End If

// After successful login, save login type
ls_Default = String(g_Obj.Login)
f_registry ("DefLogin", ls_Default, True)

f_Write2Log("w_Login Success: " + ls_Default)

If cbx_rem.Checked then   // If remember password
	ls_Default = sle_pass.Text
	f_Registry("UserP", ls_Default, True)
	ls_Default = '1'
	f_Registry("PRem", ls_Default, True)
Else  // otherwise clear
	ls_Default = ''
	f_Registry("UserP", ls_Default, True)	
	ls_Default = '0'
	f_Registry("PRem", ls_Default, True)	
End If

Close(Parent)
end event

type sle_id from singlelineedit within w_login
integer x = 695
integer y = 952
integer width = 695
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_id from statictext within w_login
integer x = 146
integer y = 956
integer width = 466
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "APMM Unique ID:"
boolean focusrectangle = false
end type

type st_user from statictext within w_login
integer x = 73
integer y = 832
integer width = 1042
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Enter your password:"
boolean focusrectangle = false
end type

type st_pw from statictext within w_login
integer x = 146
integer y = 1056
integer width = 530
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Mobile Password:"
boolean focusrectangle = false
end type

type sle_pass from singlelineedit within w_login
integer x = 695
integer y = 1040
integer width = 695
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

type rb_insp from radiobutton within w_login
integer x = 238
integer y = 544
integer width = 512
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Inspector Login"
end type

event clicked;
st_User.Text = "Enter the User ID and Password:"
st_ID.Visible = True
sle_id.Visible = True
st_PW.Text = "Mobile Password:"
st_PW.Visible = True
sle_pass.Visible = True
st_PW.y = 1056
sle_pass.y = 1040
sle_pass.text = ""
sle_id.SetFocus()
end event

type rb_vsl from radiobutton within w_login
integer x = 238
integer y = 432
integer width = 914
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Vessel Management Login"
end type

event clicked;
st_User.Text = "Enter the Password:"
st_ID.Visible = False
sle_id.Visible = False
st_PW.Text = "Vessel Password:"
st_PW.Visible = True
sle_pass.Visible = True
st_PW.y = st_ID.y
sle_pass.y = st_PW.y
sle_pass.text = ""
sle_pass.SetFocus()
end event

type rb_gen from radiobutton within w_login
integer x = 238
integer y = 656
integer width = 969
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "General Login ( Read Only)"
end type

event clicked;
st_User.Text = ""
st_ID.Visible = False
sle_id.Visible = False
st_PW.Visible = False
sle_Pass.Visible = False
end event

type st_2 from statictext within w_login
integer x = 73
integer y = 320
integer width = 1061
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Please choose the type of login:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 293
integer y = 64
integer width = 1134
integer height = 112
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 8421376
long backcolor = 67108864
string text = "VIMS Mobile Login"
boolean focusrectangle = false
end type

type p_1 from picture within w_login
integer x = 37
integer y = 32
integer width = 219
integer height = 192
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\Vims\Key.gif"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_login
integer x = 18
integer y = 256
integer width = 1774
integer height = 912
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
end type

