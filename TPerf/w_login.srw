HA$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type rb_test from radiobutton within w_login
end type
type rb_prod from radiobutton within w_login
end type
type st_4 from statictext within w_login
end type
type p_1 from picture within w_login
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
type rr_1 from roundrectangle within w_login
end type
end forward

global type w_login from window
integer width = 1989
integer height = 1200
boolean titlebar = true
string title = "TPerf Login"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
rb_test rb_test
rb_prod rb_prod
st_4 st_4
p_1 p_1
cb_exit cb_exit
cb_login cb_login
sle_pwd sle_pwd
sle_userid sle_userid
st_3 st_3
st_2 st_2
st_1 st_1
rr_1 rr_1
end type
global w_login w_login

forward prototypes
public function integer wf_login (ref string as_userid, ref string as_password)
end prototypes

public function integer wf_login (ref string as_userid, ref string as_password);/* Function to connect to database */

SQLCA.LogID=as_UserID
SQLCA.LogPass=as_Password

Connect using SQLCA;

Return SQLCA.SQLCode
end function

on w_login.create
this.rb_test=create rb_test
this.rb_prod=create rb_prod
this.st_4=create st_4
this.p_1=create p_1
this.cb_exit=create cb_exit
this.cb_login=create cb_login
this.sle_pwd=create sle_pwd
this.sle_userid=create sle_userid
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.rr_1=create rr_1
this.Control[]={this.rb_test,&
this.rb_prod,&
this.st_4,&
this.p_1,&
this.cb_exit,&
this.cb_login,&
this.sle_pwd,&
this.sle_userid,&
this.st_3,&
this.st_2,&
this.st_1,&
this.rr_1}
end on

on w_login.destroy
destroy(this.rb_test)
destroy(this.rb_prod)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.cb_exit)
destroy(this.cb_login)
destroy(this.sle_pwd)
destroy(this.sle_userid)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;String ls_CmdLine
Integer li_Temp
		
SQLCA.DBMS = "SYC Adaptive Server Enterprise"
SQLCA.DBParm	= "Release='15',Host='TPerf',UTF8=1"
SQLCA.Lock	= ""
SQLCA.AutoCommit = false

ls_CmdLine = Trim(CommandParm())

This.Title = "T-Perf Login"

If Len(ls_CmdLine) > 4 then
	li_Temp = 1
	Do
		li_Temp ++
	Loop Until (Mid(ls_CmdLine, li_Temp, 1) = ";") or li_Temp = Len(ls_CmdLine)
	
	If li_Temp < Len(ls_CmdLine) then
		sle_userid.Text = Left(ls_CmdLine, li_Temp - 1)
		sle_pwd.Text = Right(ls_CmdLine, Len(ls_CmdLine) - li_Temp)				
		cb_login.Event Clicked()	
	End If
End If


end event

event key;If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type rb_test from radiobutton within w_login
integer x = 896
integer y = 608
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Test"
end type

type rb_prod from radiobutton within w_login
integer x = 896
integer y = 528
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Production"
boolean checked = true
end type

type st_4 from statictext within w_login
integer x = 512
integer y = 528
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database:"
boolean focusrectangle = false
end type

type p_1 from picture within w_login
integer x = 37
integer y = 48
integer width = 384
integer height = 848
boolean originalsize = true
string picturename = "H:\Tramos.Dev\Resource\TPerf\logo.gif"
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_login
integer x = 1152
integer y = 960
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

g_userinfo.userid=""
close(w_login)
end event

type cb_login from commandbutton within w_login
integer x = 311
integer y = 960
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
String ls_Ver

// call function to login to database

SetPointer (HourGlass!)

If rb_Prod.Checked then
	SQLCA.serverName = "SCRBTRADKCPH001"
	SQLCA.Database = "PROD_TRAMOS"	
Else
	SQLCA.ServerName = "SCRBTRADKCPH101"
	SQLCA.Database = "PRE_TRAMOS"	
End If

li_login=wf_login(sle_UserId.Text, sle_Pwd.Text)

If li_login<>0 then
	MessageBox ("Database Connect Error", SQLCA.SQLErrText, StopSign!)
Else
	g_userinfo.userid=SQLCA.LogId
	
	// Check version number
	Select Top 1 TPERF_CURRENT_VERSION into :ls_Ver From TRAMOS_VERSION;

	If (SQLCA.SQLCode <> 0) then
		Messagebox("DB Error", "Unable to verify latest version of T-Perf.", Exclamation!)
		g_userinfo.userid = ""
	End If
	
	Commit;
	
	If (ls_Ver > g_Parameters.AppVersion) and (ls_Ver <> "All") then
		Messagebox("TPerf - New Version", "This version of T-Perf (" + g_Parameters.AppVersion + ") is older than the latest version of T-Perf available (" + ls_Ver + ").~n~nPlease contact the IT department to update T-Perf.", Exclamation!)
		g_UserInfo.userid = ""
	End If
	
	// Retrieve Profit_C number and full name
	SELECT (Select PC_NR from USERS_PROFITCENTER Where USERID = :SQLCA.LogID and PRIMARY_PROFITCENTER = 1), FIRST_NAME, LAST_NAME, TPERF_ACCESS INTO :g_UserInfo.pc_num, :g_UserInfo.firstname, :g_UserInfo.lastname, :g_UserInfo.Access FROM USERS where USERID =:SQLCA.LogID;
	Commit;
		
	// Get Profit center logo
	Select STATEMENT_LOGO Into :g_UserInfo.PC_Logo from PROFIT_C Where PC_NR = :g_UserInfo.PC_Num
	Commit;
	
	// Check if user has no access to t-perf	
	If g_UserInfo.Access	= 0 then 
		MessageBox("Access Denied", "You do not have access to open the Tramper Performance System. Please contact Tramos Support to obtain access.", Exclamation!)
		g_UserInfo.UserID = ""
	End If
		
	// Retrive Profit_C Name
	SELECT PC_NAME INTO :g_UserInfo.pc_name FROM PROFIT_C where PC_NR =:g_UserInfo.pc_num;
	commit;
	
	// Update login info
	Update USERS Set LASTLOGINFROM = 2, LASTLOGIN=getdate() Where USERID = :g_UserInfo.UserID;
	
	If g_userinfo.userid = "sa" then g_userinfo.access = 2
	
	Close(parent)
End if	



end event

type sle_pwd from singlelineedit within w_login
integer x = 896
integer y = 416
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

event getfocus;
this.selecttext( 1, Len(this.text))
end event

type sle_userid from singlelineedit within w_login
integer x = 896
integer y = 304
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

event modified;
if sle_userid.text <> "sa" then sle_userid.text=upper(sle_userid.text)
end event

event getfocus;
this.selecttext( 1, Len(this.text))

end event

type st_3 from statictext within w_login
integer x = 512
integer y = 416
integer width = 366
integer height = 64
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

type st_2 from statictext within w_login
integer x = 512
integer y = 304
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "UserID:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 512
integer y = 80
integer width = 1376
integer height = 144
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter your User ID and Password to login to the Tramper Performance System"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_login
long linecolor = 8421504
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 1938
integer height = 912
integer cornerheight = 40
integer cornerwidth = 46
end type

