$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type rb_preprod from radiobutton within w_login
end type
type rb_standby from radiobutton within w_login
end type
type rb_dev from radiobutton within w_login
end type
type st_ver from statictext within w_login
end type
type rb_test from radiobutton within w_login
end type
type rb_prod from radiobutton within w_login
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
type rr_1 from roundrectangle within w_login
end type
end forward

global type w_login from window
integer width = 1989
integer height = 1376
boolean titlebar = true
string title = "VIMS Login"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Key.ico"
boolean center = true
rb_preprod rb_preprod
rb_standby rb_standby
rb_dev rb_dev
st_ver st_ver
rb_test rb_test
rb_prod rb_prod
st_4 st_4
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

type prototypes
function boolean GetUserNameA(ref string lpBuffer, ref int nSize) library "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
end prototypes

forward prototypes
public function integer wf_login (ref string as_userid, ref string as_password)
end prototypes

public function integer wf_login (ref string as_userid, ref string as_password);/* Function to connect to database */

SQLCA.LogID = as_UserID
SQLCA.UserID = as_UserID
SQLCA.LogPass = as_Password

Connect using SQLCA;

Return SQLCA.SQLCode
end function

on w_login.create
this.rb_preprod=create rb_preprod
this.rb_standby=create rb_standby
this.rb_dev=create rb_dev
this.st_ver=create st_ver
this.rb_test=create rb_test
this.rb_prod=create rb_prod
this.st_4=create st_4
this.cb_exit=create cb_exit
this.cb_login=create cb_login
this.sle_pwd=create sle_pwd
this.sle_userid=create sle_userid
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.rr_1=create rr_1
this.Control[]={this.rb_preprod,&
this.rb_standby,&
this.rb_dev,&
this.st_ver,&
this.rb_test,&
this.rb_prod,&
this.st_4,&
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
destroy(this.rb_preprod)
destroy(this.rb_standby)
destroy(this.rb_dev)
destroy(this.st_ver)
destroy(this.rb_test)
destroy(this.rb_prod)
destroy(this.st_4)
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
		
SQLCA.DBMS = "ASE Adaptive Server Enterprise"
SQLCA.DBParm = "Release='15',Host='VIMS',UTF8=1"
SQLCA.Lock	= ""
SQLCA.AutoCommit = false

st_Ver.Text = "Ver: " + g_Obj.AppVersion + "; Built: " + g_Obj.AppBuild

// If running from G:, disable production access
If Left(g_Obj.Appfolder, 2) = "G:" then
	rb_Test.Checked = True
	rb_Prod.Enabled = False
End If

// Populate UserID from System
int li_Size = 255
boolean	lb_rc
string ls_Name
ls_Name = space(li_Size)
lb_rc = GetUserNameA(ls_Name, li_size)
If lb_rc Then sle_userid.Text = Upper(Trim(ls_Name))

// Check commandline to see if username and password were passed from Tramos
ls_CmdLine = Trim(CommandParm())

If Len(ls_CmdLine) > 4 then
	
	If Pos(ls_CmdLine, ";") > 0 Then // If this is a regular login
		li_Temp = 1
		Do
			li_Temp ++
		Loop Until (Mid(ls_CmdLine, li_Temp, 1) = ";") or li_Temp = Len(ls_CmdLine)
		
		If li_Temp < Len(ls_CmdLine) then
			sle_userid.Text = Left(ls_CmdLine, li_Temp - 1)
			sle_pwd.Text = Right(ls_CmdLine, Len(ls_CmdLine) - li_Temp)
		End If
	Else  // Single-signon
		SQLCA.DBParm += ",Sec_Cred_Timeout=100,Sec_Network_Auth=1,Sec_Server_Principal='" + ls_CmdLine + "'"
				// Messagebox("Command Line", ls_CmdLine)  // For debugging only
	End If	
	
	If sle_userid.text>"" Then		
		sle_userid.enabled = false
		sle_pwd.enabled = false
		cb_login.Event Clicked()
	End If
		
Else
	If FileExists("c:\developer.ini") Then
		rb_Test.Checked = True
		sle_UserID.text = ProfileString("c:\developer.ini","login","loginid", "")
		sle_Pwd.text = ProfileString("c:\developer.ini","login","password", "")		
		
		/* If the user holds the shift-key down, the application willl not login automatically */
		If Not KeyDown(keyShift!) then cb_Login.PostEvent(clicked!)
	End If
End If




end event

type rb_preprod from radiobutton within w_login
integer x = 896
integer y = 624
integer width = 466
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pre-Production"
end type

type rb_standby from radiobutton within w_login
integer x = 896
integer y = 704
integer width = 439
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Standby"
end type

type rb_dev from radiobutton within w_login
integer x = 896
integer y = 864
integer width = 603
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Developer Database"
end type

type st_ver from statictext within w_login
integer x = 55
integer y = 1040
integer width = 1865
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Ver"
alignment alignment = center!
boolean focusrectangle = false
end type

event doubleclicked;
//open(w_callws)
end event

type rb_test from radiobutton within w_login
integer x = 896
integer y = 784
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
string text = "Test Database"
end type

type rb_prod from radiobutton within w_login
integer x = 896
integer y = 544
integer width = 439
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
integer x = 274
integer y = 544
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
string text = "Database:"
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_login
integer x = 1170
integer y = 1136
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
close(parent)
end event

type cb_login from commandbutton within w_login
integer x = 311
integer y = 1136
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

// Call function to login to database

SetPointer (HourGlass!)

If rb_Prod.Checked then 
	SQLCA.Database = guo_Global.is_ProductionDB
	SQLCA.Servername = guo_Global.is_ProductionServer
	
	If sle_userid.enabled Then
			Messagebox("Access Denied", "VIMS cannot log into the production database directly. Please start VIMS via Tramos.",Exclamation!)
			Return
	End If	
End If

If rb_standby.Checked then 
	SQLCA.Database = "PROD_TRAMOS"
	SQLCA.Servername = "ASESTANDBY"
End If
If rb_PreProd.Checked then 
	SQLCA.Database = "PRE_TRAMOS"
	SQLCA.Servername = "ASETEST"
End If
If rb_Test.Checked then 
	SQLCA.Database = "TEST_TRAMOS"
	SQLCA.Servername = "ASETEST"
End If
If rb_Dev.Checked then
	SQLCA.Database = "DEV_CPH"
	SQLCA.Servername = "ASETEST"
End If

li_login = wf_login(sle_UserId.Text, sle_Pwd.Text)

If li_login<>0 then
	MessageBox ("VIMS Database Connect Error", "Could not connect to the database.~n~n" + SQLCA.SQLErrText + "~n~nPlease check your User ID and password.", StopSign!)
	sle_userid.enabled = true
	sle_pwd.enabled = true
   sle_userid.setfocus( )
Else
	g_Obj.UserID = SQLCA.LogId
	
	// Retrieve user info
	SELECT LAST_NAME + ", " + FIRST_NAME, VETT_ACCESS, VETT_DEPT, DEPTNAME INTO :gs_FullName, :g_obj.Access, :g_obj.DeptID, :g_obj.Dept FROM USERS, VETT_DEPT where (USERID =:SQLCA.LogID) and (VETT_DEPT.DEPT_ID =* USERS.VETT_DEPT);
	
	If SQLCA.SQLCode < 0 then 
		MessageBox("DB Error", SQLCA.SQLErrtext)
		Rollback;
		Return
	Else
		Commit;
	End If
	
//	g_Obj.Access = 3   // FOR TEST ONLY
//	g_Obj.DeptID = 2
//	g_Obj.Dept = "asdfg"
//	If g_Obj.UserID = "sa" then    // sa to have super-user access with vetting dept
//		g_obj.Access = 3   
//		g_obj.Deptid = 1
//		g_obj.Dept = "Vetting"
//	End If
	
	If g_obj.Access = 0 then 
		Messagebox("Access Denied", "You do not have access to the VIMS. Please contact the Maersk Tankers Vetting department.", Exclamation!)
		g_Obj.UserID = ""	
	End If
	
	// Check latest version
	Select Top 1 VIMS_CURRENT_VERSION into :ls_Ver From TRAMOS_VERSION;

	If (SQLCA.SQLCode <> 0) and (g_Obj.UserID > "") then
		Messagebox("DB Error", "Unable to verify latest version of VIMS.", Exclamation!)
		g_Obj.UserID = ""
	End If
	
	Commit;
	
	If (ls_Ver > g_Obj.AppVersion) and (g_Obj.UserID > "") and (ls_Ver <> "All") then
		Messagebox("New Version", "A newer version of VIMS has been released. Please contact the IT department to update VIMS.", Exclamation!)
		g_Obj.UserID = ""
	End If
	
	Close(Parent)
End if	



end event

type sle_pwd from singlelineedit within w_login
integer x = 896
integer y = 432
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
integer y = 320
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
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;
if sle_userid.text <> "sa" then sle_userid.text=upper(sle_userid.text)
end event

event getfocus;
this.selecttext( 1, Len(this.text))

end event

event losefocus;
this.text = Trim(this.text, true)
end event

type st_3 from statictext within w_login
integer x = 274
integer y = 432
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
string text = "Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_login
integer x = 274
integer y = 320
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
integer x = 55
integer y = 80
integer width = 1806
integer height = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter your User ID and Password to login to the Vetting and Inspection Management System"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_login
long linecolor = 8421504
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 1938
integer height = 1088
integer cornerheight = 40
integer cornerwidth = 46
end type

