$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type st_4 from statictext within w_login
end type
type cb_exit from commandbutton within w_login
end type
type cb_login from commandbutton within w_login
end type
type sle_pwd from singlelineedit within w_login
end type
type sle_userid from singlelineedit within w_login
end type
type st_3 from statictext within w_login
end type
type st_2 from statictext within w_login
end type
type st_1 from statictext within w_login
end type
type gb_1 from groupbox within w_login
end type
end forward

global type w_login from window
integer width = 2862
integer height = 1748
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "C:\Vetting DB\Graphics\Key.ico"
boolean center = true
st_4 st_4
cb_exit cb_exit
cb_login cb_login
sle_pwd sle_pwd
sle_userid sle_userid
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_login w_login

on w_login.create
this.st_4=create st_4
this.cb_exit=create cb_exit
this.cb_login=create cb_login
this.sle_pwd=create sle_pwd
this.sle_userid=create sle_userid
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_4,&
this.cb_exit,&
this.cb_login,&
this.sle_pwd,&
this.sle_userid,&
this.st_3,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_login.destroy
destroy(this.st_4)
destroy(this.cb_exit)
destroy(this.cb_login)
destroy(this.sle_pwd)
destroy(this.sle_userid)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;		
//SQLCA.DBMS = 'ASE Adaptive Server Enterprise'
//SQLCA.Database = "LAPTOPTRAMOS"
//SQLCA.ServerName = "THIS_LAPTOP"
//SQLCA.DBParm = "Release='15'"
//SQLCA.AutoCommit = false
//

// Profile ESP003 - TestDB
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = False
SQLCA.DBParm = "ConnectString='DSN=scrbtradkesp003;UID=sa;PWD=heitmann'"

end event

type st_4 from statictext within w_login
integer x = 439
integer y = 256
integer width = 1938
integer height = 144
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388736
long backcolor = 16777215
string text = "VIMS Inspection Planning - Logon"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_login
integer x = 1554
integer y = 1168
integer width = 512
integer height = 128
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Exit"
boolean cancel = true
end type

event clicked;
// If user exits, then clear g_userinfo and close the window

//g_userinfo.userid=""

gs_userid = ''
close(w_login)
//Halt Close
end event

type cb_login from commandbutton within w_login
integer x = 731
integer y = 1168
integer width = 512
integer height = 128
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Login"
boolean default = true
end type

event clicked;Integer li_Login

// Call function to login to database

SetPointer (HourGlass!)

SQLCA.DBParm = "ConnectString='DSN=scrbtradkesp003;UID=" + sle_userid.text + ";PWD=" + sle_pwd.text + "'"
//SQLCA.LogID=sle_userid.Text
//SQLCA.LogPass=sle_pwd.Text

Connect using SQLCA;

If SQLCA.SQLCode<>0 then
	MessageBox ("Database Connect Error", SQLCA.SQLErrText + "~n~nPlease check your User ID and password.", StopSign!)
	sle_userid.setfocus( )
	Return
Else
	gs_userid = SQLCA.LogId
End If

Close(Parent)
Open(w_planbak)



end event

type sle_pwd from singlelineedit within w_login
integer x = 1317
integer y = 880
integer width = 805
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
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

type sle_userid from singlelineedit within w_login
integer x = 1317
integer y = 768
integer width = 805
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_login
integer x = 695
integer y = 880
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_login
integer x = 695
integer y = 768
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Tramos UserID:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 494
integer y = 528
integer width = 1806
integer height = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Please enter your User ID and Password to login to the Vetting and Inspection Management System"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_login
integer x = 18
integer y = 16
integer width = 2779
integer height = 1600
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
end type

