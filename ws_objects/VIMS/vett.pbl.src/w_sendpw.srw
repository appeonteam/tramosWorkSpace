$PBExportHeader$w_sendpw.srw
forward
global type w_sendpw from window
end type
type st_4 from statictext within w_sendpw
end type
type cb_cancel from commandbutton within w_sendpw
end type
type cb_send from commandbutton within w_sendpw
end type
type rb_sel from radiobutton within w_sendpw
end type
type rb_all from radiobutton within w_sendpw
end type
type st_1 from statictext within w_sendpw
end type
type hsb_year from hscrollbar within w_sendpw
end type
type st_year from statictext within w_sendpw
end type
type st_2 from statictext within w_sendpw
end type
type gb_1 from groupbox within w_sendpw
end type
end forward

global type w_sendpw from window
integer width = 1847
integer height = 1000
boolean titlebar = true
string title = "Email VM Passwords"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
cb_cancel cb_cancel
cb_send cb_send
rb_sel rb_sel
rb_all rb_all
st_1 st_1
hsb_year hsb_year
st_year st_year
st_2 st_2
gb_1 gb_1
end type
global w_sendpw w_sendpw

type variables

uo_vmpassword i_Pass
end variables

forward prototypes
public function boolean w_mailvmpassword (string as_userid, integer ai_year)
end prototypes

public function boolean w_mailvmpassword (string as_userid, integer ai_year);// This function emails a user's VM password to the user.

// Parameters: as_UserID, ai_Year

// Returns True for success and False for error.

mt_n_outgoingmail lnvo_Mail
String ls_Temp, ls_Body

lnvo_Mail = Create mt_n_outgoingmail

ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/>Your VIMS Mobile password for the year " + String(ai_Year) + " is: <b>" + i_Pass.of_CreateVMPassword(as_UserID, ai_Year)
ls_Body += "</b><br/><br/>This password will be valid for the said year only. Please ignore this message if you do not have VIMS Mobile installed.<br/><br/>Contact maropsmt@maersk.com for any further assistance."
ls_Body += "<br/><br/>Best Regards,<br/><br/>VIMS Admin"
ls_Body += "<br/><br/><br/><br/><hr/><small>" + guo_Global.is_Emailfooter + "</small></body></html>"

If lnvo_Mail.of_createmail( "tramosmt@maersk.com", as_UserID + "@maersk.com", "VIMS Mobile Password for " + String(ai_Year), ls_Body, ls_Temp) < 1 then Return False

Return (lnvo_Mail.of_SendMail(ls_Temp) = 1)
end function

on w_sendpw.create
this.st_4=create st_4
this.cb_cancel=create cb_cancel
this.cb_send=create cb_send
this.rb_sel=create rb_sel
this.rb_all=create rb_all
this.st_1=create st_1
this.hsb_year=create hsb_year
this.st_year=create st_year
this.st_2=create st_2
this.gb_1=create gb_1
this.Control[]={this.st_4,&
this.cb_cancel,&
this.cb_send,&
this.rb_sel,&
this.rb_all,&
this.st_1,&
this.hsb_year,&
this.st_year,&
this.st_2,&
this.gb_1}
end on

on w_sendpw.destroy
destroy(this.st_4)
destroy(this.cb_cancel)
destroy(this.cb_send)
destroy(this.rb_sel)
destroy(this.rb_all)
destroy(this.st_1)
destroy(this.hsb_year)
destroy(this.st_year)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;
// Select Year
If Month(Today()) = 12 then st_Year.Text = String(Year(Today()) + 1) Else st_Year.Text = String(Year(Today()))

// Show UserID
rb_Sel.Text += " (" + g_Obj.ObjParent + ")"
end event

type st_4 from statictext within w_sendpw
integer x = 73
integer y = 64
integer width = 1701
integer height = 192
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The VIMS Mobile password for the selected year will be emailed directly to the user~'s PA Inbox."
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_sendpw
integer x = 1134
integer y = 800
integer width = 343
integer height = 92
integer taborder = 30
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
Close(Parent)
end event

type cb_send from commandbutton within w_sendpw
integer x = 384
integer y = 800
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
boolean default = true
end type

event clicked;Datawindow ldw_Users

If rb_all.Checked then
	ldw_Users = w_Admin.tab_Admin.tp4.dw_UserVer
	Integer li_Loop, li_Sent = 0, li_Fail = 0
	SetPointer(HourGlass!)
	For li_Loop = 1 to ldw_Users.RowCount()		
		If w_MailVMPassword(ldw_Users.GetItemString(li_Loop, "UserID"), Integer(st_Year.Text)) then li_Sent += 1 Else li_Fail += 1
	Next
	If li_Fail > 0 then
		MessageBox("Email Error", "One or more emails failed.~n~nEmails Successful:~t~t" + String(li_Sent) + "~nEmails Failed:~t~t" + String(li_Fail), Exclamation!)
	Else
		MessageBox("Emails Sent", String(li_Sent) + " emails were sent successfully!")
	End If
Else
   If	w_MailVMPassword(g_Obj.ObjParent, Integer(st_Year.Text)) then MessageBox("Email Sent", "The email was sent successfully!") Else MessageBox("Email Error", "The email could not be sent successfully.", Exclamation!)
End If

Close(Parent)
end event

type rb_sel from radiobutton within w_sendpw
integer x = 238
integer y = 528
integer width = 1481
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send to selected inspector only"
boolean checked = true
end type

type rb_all from radiobutton within w_sendpw
integer x = 238
integer y = 624
integer width = 1353
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send to all inspectors with VM Installations"
end type

type st_1 from statictext within w_sendpw
integer x = 73
integer y = 432
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Users:"
boolean focusrectangle = false
end type

type hsb_year from hscrollbar within w_sendpw
integer x = 713
integer y = 320
integer width = 128
integer height = 68
end type

event lineleft;
If st_Year.Text > "2000" then	st_Year.Text = String(Integer(st_Year.Text) - 1)	

//sle_pw.Text = i_Pass.of_CreateVMPassword(st_id.Text, Integer(st_Year.Text))


end event

event lineright;
If st_Year.Text < "2999" then	st_Year.Text = String(Integer(st_Year.Text) + 1)	

//sle_pw.Text = i_Pass.of_CreateVMPassword(st_id.Text, Integer(st_Year.Text))

end event

type st_year from statictext within w_sendpw
integer x = 512
integer y = 320
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

type st_2 from statictext within w_sendpw
integer x = 73
integer y = 320
integer width = 334
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Year:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sendpw
integer x = 18
integer width = 1792
integer height = 768
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

