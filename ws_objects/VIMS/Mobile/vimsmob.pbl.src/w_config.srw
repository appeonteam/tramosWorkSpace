$PBExportHeader$w_config.srw
forward
global type w_config from window
end type
type cb_server from commandbutton within w_config
end type
type cb_testimport from commandbutton within w_config
end type
type cb_testexport from commandbutton within w_config
end type
type sle_out from singlelineedit within w_config
end type
type st_7 from statictext within w_config
end type
type sle_in from singlelineedit within w_config
end type
type st_6 from statictext within w_config
end type
type cb_db from commandbutton within w_config
end type
type st_2 from statictext within w_config
end type
type sle_pw from singlelineedit within w_config
end type
type st_4 from statictext within w_config
end type
type sle_user from singlelineedit within w_config
end type
type st_3 from statictext within w_config
end type
type sle_db from singlelineedit within w_config
end type
type sle_server from singlelineedit within w_config
end type
type st_1 from statictext within w_config
end type
type cb_cancel from commandbutton within w_config
end type
type cb_save from commandbutton within w_config
end type
type gb_1 from groupbox within w_config
end type
type gb_2 from groupbox within w_config
end type
end forward

global type w_config from window
integer width = 2784
integer height = 1224
boolean titlebar = true
string title = "System Configuration"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "Function!"
boolean center = true
cb_server cb_server
cb_testimport cb_testimport
cb_testexport cb_testexport
sle_out sle_out
st_7 st_7
sle_in sle_in
st_6 st_6
cb_db cb_db
st_2 st_2
sle_pw sle_pw
st_4 st_4
sle_user sle_user
st_3 st_3
sle_db sle_db
sle_server sle_server
st_1 st_1
cb_cancel cb_cancel
cb_save cb_save
gb_1 gb_1
gb_2 gb_2
end type
global w_config w_config

forward prototypes
public function boolean wf_validatedb ()
public subroutine wf_testfolder (string as_folder)
end prototypes

public function boolean wf_validatedb ();sle_Server.Text = Trim(sle_Server.Text, true)
sle_User.Text = Trim(sle_User.Text, true)
sle_DB.Text = Trim(sle_DB.Text, true)
sle_Pw.Text = Trim(sle_Pw.Text, true)

If sle_Server.Text = "" Then Return False
If sle_DB.Text = "" Then Return False
If sle_User.Text = "" Then Return False
If sle_Pw.Text = "" Then Return False

Return True
end function

public subroutine wf_testfolder (string as_folder);// Function checks if folder exists and writes to folder as well.

If as_Folder="" Then 
	Messagebox("Folder Missing", "Please specify a folder to check!", Exclamation!)
	Return
End If

If DirectoryExists(as_Folder) Then
	Messagebox("Folder Found", "Folder " + as_Folder + " was found!", Information!)	
Else
	Messagebox("Folder Not Found", "Folder " + as_Folder + " was not found!", Exclamation!)
End If
end subroutine

on w_config.create
this.cb_server=create cb_server
this.cb_testimport=create cb_testimport
this.cb_testexport=create cb_testexport
this.sle_out=create sle_out
this.st_7=create st_7
this.sle_in=create sle_in
this.st_6=create st_6
this.cb_db=create cb_db
this.st_2=create st_2
this.sle_pw=create sle_pw
this.st_4=create st_4
this.sle_user=create sle_user
this.st_3=create st_3
this.sle_db=create sle_db
this.sle_server=create sle_server
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_server,&
this.cb_testimport,&
this.cb_testexport,&
this.sle_out,&
this.st_7,&
this.sle_in,&
this.st_6,&
this.cb_db,&
this.st_2,&
this.sle_pw,&
this.st_4,&
this.sle_user,&
this.st_3,&
this.sle_db,&
this.sle_server,&
this.st_1,&
this.cb_cancel,&
this.cb_save,&
this.gb_1,&
this.gb_2}
end on

on w_config.destroy
destroy(this.cb_server)
destroy(this.cb_testimport)
destroy(this.cb_testexport)
destroy(this.sle_out)
destroy(this.st_7)
destroy(this.sle_in)
destroy(this.st_6)
destroy(this.cb_db)
destroy(this.st_2)
destroy(this.sle_pw)
destroy(this.st_4)
destroy(this.sle_user)
destroy(this.st_3)
destroy(this.sle_db)
destroy(this.sle_server)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
// Read settings
sle_Server.Text = g_DB.is_Server
sle_DB.Text = g_DB.is_Database
sle_User.Text = g_DB.is_User
sle_Pw.Text = g_DB.is_Pwd
sle_In.Text = g_DB.is_Import
sle_Out.Text = g_DB.is_Export
end event

type cb_server from commandbutton within w_config
integer x = 695
integer y = 512
integer width = 603
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Test Server Connection"
end type

event clicked;SetPointer(HourGlass!)
Parent.Enabled = False

If wf_ValidateDB() = false Then 
	Messagebox("Database Connection", "One or more settings are empty!" ,Exclamation!)
	Return
End If

Transaction lTrans
lTrans = create Transaction

lTrans.DBMS = "OLE DB"
lTrans.LogId = sle_User.Text
lTrans.LogPass = sle_Pw.Text
lTrans.AutoCommit = False
lTrans.DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + sle_Server.Text + "'"

Connect Using lTrans;

If lTrans.SQLCode < 0 Then
	Messagebox("Connection Error","Unable to connect to server.~n~n" + lTrans.SQLErrText ,Exclamation!)
Else
	Messagebox("Connection Successful","Connection to server was successful!", Information!)
	Disconnect Using lTrans;
End If

Parent.Enabled = True

Destroy lTrans
end event

type cb_testimport from commandbutton within w_config
integer x = 2176
integer y = 320
integer width = 475
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Test Folder"
end type

event clicked;
wf_TestFolder(sle_In.Text)
end event

type cb_testexport from commandbutton within w_config
integer x = 2176
integer y = 624
integer width = 475
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Test Folder"
end type

event clicked;
wf_TestFolder(sle_Out.Text)
end event

type sle_out from singlelineedit within w_config
integer x = 1463
integer y = 512
integer width = 1189
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event losefocus;
this.Text = Trim(this.Text, true)

If this.Text > "" and Right(this.Text,1) <> "\" then this.Text += "\"
end event

type st_7 from statictext within w_config
integer x = 1463
integer y = 448
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export Folder:"
boolean focusrectangle = false
end type

type sle_in from singlelineedit within w_config
integer x = 1463
integer y = 208
integer width = 1189
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event losefocus;
this.Text = Trim(this.Text, true)

If this.Text > "" and Right(this.Text,1) <> "\" then this.Text += "\"
end event

type st_6 from statictext within w_config
integer x = 1463
integer y = 144
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
string text = "Import Folder:"
boolean focusrectangle = false
end type

type cb_db from commandbutton within w_config
integer x = 695
integer y = 816
integer width = 608
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Test DB Connection"
end type

event clicked;SetPointer(HourGlass!)
Parent.Enabled = False

If wf_ValidateDB() = false Then 
	Messagebox("Database Connection", "One or more settings are empty!" ,Exclamation!)
	Return
End If

Transaction lTrans
lTrans = create Transaction

lTrans.DBMS = "OLE DB"
lTrans.LogId = sle_User.Text
lTrans.LogPass = sle_Pw.Text
lTrans.AutoCommit = False
lTrans.DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + sle_Server.Text + "',PROVIDERSTRING='Database=" + sle_DB.Text + "',Identity='SCOPE_IDENTITY()'"

Connect Using lTrans;

If lTrans.SQLCode < 0 Then
	Messagebox("Connection Error","Unable to connect to database.~n~n" + lTrans.SQLErrText ,Exclamation!)
Else
	Messagebox("Connection Successful","Connection to database was successful!", Information!)
	Disconnect Using lTrans;
End If

Parent.Enabled = True

Destroy lTrans
end event

type st_2 from statictext within w_config
integer x = 750
integer y = 144
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

type sle_pw from singlelineedit within w_config
integer x = 750
integer y = 208
integer width = 549
integer height = 96
integer taborder = 50
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

type st_4 from statictext within w_config
integer x = 110
integer y = 144
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
string text = "User Name:"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_config
integer x = 110
integer y = 208
integer width = 567
integer height = 96
integer taborder = 40
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

type st_3 from statictext within w_config
integer x = 110
integer y = 640
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database Name:"
boolean focusrectangle = false
end type

type sle_db from singlelineedit within w_config
integer x = 110
integer y = 704
integer width = 1189
integer height = 96
integer taborder = 30
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

type sle_server from singlelineedit within w_config
integer x = 110
integer y = 400
integer width = 1189
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_config
integer x = 110
integer y = 336
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
string text = "Server Name:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_config
integer x = 1682
integer y = 992
integer width = 475
integer height = 112
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

type cb_save from commandbutton within w_config
integer x = 603
integer y = 992
integer width = 475
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
boolean default = true
end type

event clicked;
If wf_ValidateDB() = false Then 
	Messagebox("Database Connection", "One or more settings are empty!" ,Exclamation!)
	Return
End If

sle_In.Text = Trim(sle_In.Text, true)
sle_Out.Text = Trim(sle_Out.Text, true)

g_DB.is_Server = sle_Server.Text
g_DB.is_Database = sle_DB.Text
g_DB.is_User = sle_User.Text
g_DB.is_Pwd = sle_Pw.Text
g_DB.is_Import = sle_In.Text
g_DB.is_Export = sle_Out.Text

Integer li_Save 
li_Save = g_DB.SaveSettings()

If li_Save < 0 Then
	Messagebox("Save Error", "Could not save one or more settings!", Exclamation!)
	Return
End If

Messagebox("Configuration Saved", "Settings were saved successfully!", Information!)
Close(Parent)
end event

type gb_1 from groupbox within w_config
integer x = 37
integer y = 16
integer width = 1335
integer height = 944
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database Connection"
end type

type gb_2 from groupbox within w_config
integer x = 1408
integer y = 16
integer width = 1317
integer height = 944
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Import/Export Folders"
end type

