$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type cbx_autologin from checkbox within w_login
end type
type cbx_rememberpass from checkbox within w_login
end type
type cb_cancel from commandbutton within w_login
end type
type cb_login from commandbutton within w_login
end type
type st_6 from statictext within w_login
end type
type st_5 from statictext within w_login
end type
type st_4 from statictext within w_login
end type
type st_3 from statictext within w_login
end type
type st_2 from statictext within w_login
end type
type st_1 from statictext within w_login
end type
type sle_password from singlelineedit within w_login
end type
type sle_userid from singlelineedit within w_login
end type
type sle_database from singlelineedit within w_login
end type
type sle_server from singlelineedit within w_login
end type
end forward

global type w_login from window
integer width = 2094
integer height = 1184
boolean titlebar = true
string title = "Login"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_autologin cbx_autologin
cbx_rememberpass cbx_rememberpass
cb_cancel cb_cancel
cb_login cb_login
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
sle_password sle_password
sle_userid sle_userid
sle_database sle_database
sle_server sle_server
end type
global w_login w_login

type variables
private:
long il_rcode = 0

end variables

forward prototypes
public function integer of_close (long al_code)
end prototypes

public function integer of_close (long al_code);
il_rcode = al_code
close(this)

return 1
end function

on w_login.create
this.cbx_autologin=create cbx_autologin
this.cbx_rememberpass=create cbx_rememberpass
this.cb_cancel=create cb_cancel
this.cb_login=create cb_login
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_password=create sle_password
this.sle_userid=create sle_userid
this.sle_database=create sle_database
this.sle_server=create sle_server
this.Control[]={this.cbx_autologin,&
this.cbx_rememberpass,&
this.cb_cancel,&
this.cb_login,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_password,&
this.sle_userid,&
this.sle_database,&
this.sle_server}
end on

on w_login.destroy
destroy(this.cbx_autologin)
destroy(this.cbx_rememberpass)
destroy(this.cb_cancel)
destroy(this.cb_login)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_password)
destroy(this.sle_userid)
destroy(this.sle_database)
destroy(this.sle_server)
end on

event open;
this.backcolor = g_app.MT_FORMDETAIL_BG
sle_server.backcolor = g_app.MT_MAERSK
sle_database.backcolor = g_app.MT_MAERSK
sle_userid.backcolor = g_app.MT_MAERSK
sle_password.backcolor = g_app.MT_MAERSK

stru_loginfo s_loginfo

if isvalid(message.powerobjectparm) then
	if message.powerobjectparm.classname() = "stru_loginfo" then
		s_loginfo = message.powerobjectparm
		
		sle_server.text = s_loginfo.s_authinfo.servername
		sle_database.text = s_loginfo.s_authinfo.database
		sle_userid.text = s_loginfo.s_authinfo.logid
		
		if s_loginfo.s_loginoption.rememberpass then
			sle_password.text = s_loginfo.s_authinfo.pass
		end if
		
		cbx_rememberpass.checked = s_loginfo.s_loginoption.rememberpass
		cbx_autologin.checked = s_loginfo.s_loginoption.autologin
	end if
end if

if len(sle_server.text) = 0 then
	sle_server.setfocus()
elseif len(sle_database.text) = 0 then
	sle_database.setfocus()
elseif len(sle_userid.text) = 0 then
	sle_userid.setfocus()
elseif len(sle_password.text) = 0 then
	sle_password.setfocus()
else
	sle_password.setfocus()
	sle_password.selecttext(1, len(sle_password.text))
end if

end event

event close;closewithreturn(this,il_rcode)
end event

type cbx_autologin from checkbox within w_login
integer x = 1079
integer y = 800
integer width = 384
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Auto login"
end type

event clicked;
if this.checked then
	cbx_rememberpass.checked = true
end if


end event

type cbx_rememberpass from checkbox within w_login
integer x = 457
integer y = 800
integer width = 585
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Remember password"
end type

event clicked;
if not this.checked then
	cbx_autologin.checked = false
end if

end event

type cb_cancel from commandbutton within w_login
integer x = 786
integer y = 928
integer width = 325
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
of_close(0)
end event

type cb_login from commandbutton within w_login
integer x = 457
integer y = 928
integer width = 325
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Login"
boolean default = true
end type

event clicked;
stru_loginfo s_loginfo
string ls_errmsg

s_loginfo.s_authinfo.servername = sle_server.text
s_loginfo.s_authinfo.database = sle_database.text
s_loginfo.s_authinfo.logid = sle_userid.text
s_loginfo.s_authinfo.pass = sle_password.text

if not g_app.of_login(s_loginfo.s_authinfo, ls_errmsg) then
	messagebox( "Error", ls_errmsg )
	return
end if

s_loginfo.s_loginoption.rememberpass = cbx_rememberpass.checked
s_loginfo.s_loginoption.autologin = cbx_autologin.checked

if not cbx_rememberpass.checked then
	s_loginfo.s_authinfo.pass = ''
end if

g_app.of_saveloginfo(s_loginfo)

of_close(1)

end event

type st_6 from statictext within w_login
integer x = 1024
integer y = 160
integer width = 859
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 553648127
string text = "Release Management Tool"
boolean focusrectangle = false
end type

type st_5 from statictext within w_login
integer x = 146
integer y = 672
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Password:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_login
integer x = 146
integer y = 576
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "User ID:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_login
integer x = 146
integer y = 480
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Database:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_login
integer x = 146
integer y = 384
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Server:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 128
integer y = 128
integer width = 841
integer height = 192
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 128
long backcolor = 553648127
string text = "TRAMOS"
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_login
integer x = 457
integer y = 672
integer width = 786
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
end type

type sle_userid from singlelineedit within w_login
integer x = 457
integer y = 576
integer width = 786
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type sle_database from singlelineedit within w_login
integer x = 457
integer y = 480
integer width = 786
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type sle_server from singlelineedit within w_login
integer x = 457
integer y = 384
integer width = 786
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

