$PBExportHeader$w_splash.srw
forward
global type w_splash from window
end type
type cb_config from commandbutton within w_splash
end type
type cb_try from commandbutton within w_splash
end type
type cb_x from commandbutton within w_splash
end type
type mle_log from multilineedit within w_splash
end type
type st_1 from statictext within w_splash
end type
type st_2 from statictext within w_splash
end type
type st_ver from statictext within w_splash
end type
type p_1 from picture within w_splash
end type
type ln_1 from line within w_splash
end type
end forward

global type w_splash from window
integer width = 2295
integer height = 1872
windowtype windowtype = popup!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = fadeanimation!
windowanimationstyle closeanimation = fadeanimation!
integer animationtime = 500
cb_config cb_config
cb_try cb_try
cb_x cb_x
mle_log mle_log
st_1 st_1
st_2 st_2
st_ver st_ver
p_1 p_1
ln_1 ln_1
end type
global w_splash w_splash

type variables

end variables

forward prototypes
public function integer wf_connect ()
public subroutine wf_log (string as_msg, boolean ab_err)
public subroutine wf_enablebuttons (boolean ab_enb)
end prototypes

public function integer wf_connect ();// Main routine to connect to VIMSDB
Integer li_Temp

// Try to connect to server
wf_Log("Connecting to server " + g_DB.is_server, false)
li_Temp = g_DB.Connect2Server()
If li_Temp < 0 then 
	wf_Log("Unable to connect to server. " + SQLCA.SQLErrText, true)
	Return 0
End If

// Try to connect to VIMSDB
wf_Log("Connecting to VIMS Database", false)
Disconnect Using SQLCA;
li_Temp = g_DB.Connect2db( )

If li_Temp < 0 then  // Could not connect to DB
	wf_Log("Unable to find database. " + SQLCA.SQLErrText, true)
	If Messagebox("VIMS Mobile Database", "VIMS Mobile will now connect to the server to create the VIMS Mobile database.~n~nIf this is not a new installation, please click 'No' and contact tramosmt@maersk.com.~n~nDo you want connect to the server and proceed with the installation?", Question!, YesNo!) = 2 then Return 0
		
  // Connect to server again
	li_Temp = g_DB.Connect2Server()
	If li_Temp < 0 then 
		wf_Log("Unable to connect to server. " + SQLCA.SQLErrText, true)
		Return 0
	End If
	
	If MessageBox("Server Connected", "The connection to the database server was successful.~n~nCreate new database for VIMS Mobile?", Question!, YesNo!) = 2 then 
		Disconnect Using SQLCA;
		Return 0
	End If
	
	wf_Log("Creating VIMS database", false)
	If g_DB.CreateDB('vims_sq.vpkg') < 0 then   // Creation failed
		Messagebox("DB Creation Failed", "The database could not be created due to an internal error.", Exclamation!)
		f_Write2Log("DB Creation Failed")
		wf_Log("DB Creation Failed", true)
		Disconnect Using SQLCA;
		Return 0
	Else
		wf_Log("VIMS database ready", false)
		Messagebox("DB Creation Successful", "The VIMS Mobile database was created successfully.")
		f_Write2Log("VIMSDB created successfully")
	End If
End If	

Return 1


end function

public subroutine wf_log (string as_msg, boolean ab_err);
If mle_Log.Text > "" Then
	If ab_Err Then mle_Log.Text += " [Failed]~r~n" else mle_Log.Text += " [Done]~r~n"
End If
mle_Log.Text = mle_Log.Text + as_Msg
if ab_Err=false then mle_Log.Text += "..."
mle_Log.SelectText( Len(mle_Log.Text) + 1, 0)
end subroutine

public subroutine wf_enablebuttons (boolean ab_enb);
cb_Config.Visible = ab_Enb
cb_X.Visible = ab_Enb
cb_Try.Visible = ab_Enb
end subroutine

on w_splash.create
this.cb_config=create cb_config
this.cb_try=create cb_try
this.cb_x=create cb_x
this.mle_log=create mle_log
this.st_1=create st_1
this.st_2=create st_2
this.st_ver=create st_ver
this.p_1=create p_1
this.ln_1=create ln_1
this.Control[]={this.cb_config,&
this.cb_try,&
this.cb_x,&
this.mle_log,&
this.st_1,&
this.st_2,&
this.st_ver,&
this.p_1,&
this.ln_1}
end on

on w_splash.destroy
destroy(this.cb_config)
destroy(this.cb_try)
destroy(this.cb_x)
destroy(this.mle_log)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_ver)
destroy(this.p_1)
destroy(this.ln_1)
end on

event close;
f_Write2Log("w_Splash Close")
If IsValid(W_Main) then w_Main.SetFocus()
end event

event open;f_Write2Log("w_Splash Open")
st_Ver.Text = "Version: " + String(Integer(Left(g_Obj.Appver,2))) + "." + String(Integer(Mid(g_Obj.Appver,4,2))) + "." + String(Integer(Right(g_Obj.Appver,2)))
Yield()

// Connect to database
cb_try.postevent(Clicked!)

end event

type cb_config from commandbutton within w_splash
boolean visible = false
integer x = 18
integer y = 1536
integer width = 585
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "System Configuration"
boolean cancel = true
end type

event clicked;
Open(w_Config)
end event

type cb_try from commandbutton within w_splash
boolean visible = false
integer x = 1664
integer y = 1536
integer width = 293
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Try Again"
boolean cancel = true
end type

event clicked;String ls_Temp
Integer li_Temp

wf_EnableButtons(false)
mle_Log.Text = ""

SetPointer(HourGlass!)

// Initialize server name
wf_Log("Loading Settings", false)
g_DB.InitializeSettings( )

li_Temp = wf_connect()

If li_Temp < 1 then
	wf_EnableButtons(true)
	Return
End If

wf_Log("Checking Database Integrity", false)
li_Temp = g_DB.GetDBVer()

If li_Temp < 0 then
	If Messagebox("Database Check", "The application was unable to determine the database version number. The database may be in an inconsistent state or not accessible.~n~nDo you want to try and delete and recreate the database?", Question!, YesNo!) = 2 then 
		wf_EnableButtons(true)
		Return
	End If
	
	wf_Log("Deleting VIMS Mobile Database", false)
	If Messagebox("Confirm DB Creation", "ALL DATA ON THE EXISTING DATABASE WILL BE LOST.~n~nThis step may be taken ONLY on permission from the Maersk Tankers IT Dept (tramosmt@maersk.com).~n~nAre you sure you want to delete the VIMS Mobile Database?", Question!, YesNo!) = 2 then
		wf_EnableButtons(true)
		Return		
	End If
	
	f_Write2Log("Dropping Database...")
	Execute Immediate "Commit Transaction";
	Execute Immediate "Use Master";
	If SQLCA.SQLCode<0 then Messagebox("DB Error", "Unable to use the Master DB.~n~n" + SQLCA.SQLErrText, StopSign!)
	Execute Immediate "Drop Database VIMSDB";
	
	If SQLCA.SQLCode<0 then 
		Messagebox("DB Error", "Critical Error: Unable to drop database.~n~n" + SQLCA.SQLErrText, StopSign!)
		f_Write2Log("Drop Failed: " + SQLCA.SQLErrText)
		wf_Log("Database Deletion Failed", true)
	Else
		Messagebox("Application Restart", "The database was deleted. Please restart the application to create the database again.")
		f_Write2Log("Database Dropped")
		wf_Log("Database Deleted. Please click 'Try Again'", false)
	End If
	
	wf_EnableButtons(true)
	Return
End If

g_Obj.DBVer = li_Temp  // save DB ver

wf_Log("Checking Application Version", false)

f_Config("VMVR", ls_Temp, 0)
If ls_Temp="" or ls_Temp < g_Obj.AppVer then    // If no version or lower version, save new version
	f_Config("VMVR", g_Obj.AppVer, 1)
Else
	If left(ls_Temp, 5) > Left(g_Obj.AppVer,5) then   // If Major.Minor version is higher
		wf_Log("Version mismatch. Please upgrade VIMS Mobile", true)
		Messagebox("Application Version", "A newer version of VIMS Mobile (" + String(Integer(Left(ls_Temp,2))) + "." + String(Integer(Mid(ls_Temp,4,2))) + "." + String(Integer(Right(ls_Temp,2))) + ") has been installed on one or more workstations.~n~nThis installation of VIMS Mobile must be upgraded to the latest version.", StopSign!)
		wf_EnableButtons(true)
		Return
	End If
	// Otherwise, if Revision is higher
	If ls_Temp > g_Obj.AppVer then Messagebox("Application Version", "A newer revision of VIMS Mobile (" + String(Integer(Left(ls_Temp,2))) + "." + String(Integer(Mid(ls_Temp,4,2))) + "." + String(Integer(Right(ls_Temp,2))) + ") has been installed on one or more workstations.~n~nPlease upgrade this installation of VIMS Mobile.", Information!)
End if

wf_Log("Checking Installation Identity", false)

Do
	li_Temp = g_DB.GetIdentification( )   // Get installation identity
	If li_Temp < 0 then    // If not found, get VMIC
		g_Obj.Install = 255
		g_Obj.paramstring = ""
		Open(w_VMIC)	
	End If
Loop Until (li_Temp = 0) or (g_Obj.Paramstring = "Exit")  // Loop until ID is set or user exits

If li_Temp<0 then
	wf_Log("No identification information found", true)
	Disconnect using SQLCA;
	wf_EnableButtons(true)
	Return
End If

// If vessel installation, check if vessel exists in table
If g_Obj.Install = 0 Then	g_DB.CheckVessel( g_Obj.VesselIMO , g_Obj.VesselName)

wf_Log("User Login", false)

Open(w_Login)

If g_Obj.Login < 3 then 
	wf_Log("Starting Application", false)
	Open(w_Main)  // Login successful
	Close(w_Splash)
Else
	Disconnect using SQLCA;
	wf_EnableButtons(true)
	wf_Log("Login failed. Please try again", true)
End If


end event

type cb_x from commandbutton within w_splash
boolean visible = false
integer x = 1957
integer y = 1536
integer width = 293
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Exit"
boolean cancel = true
end type

event clicked;
If IsValid(w_Log) then Close(w_Log) else Close(Parent)
end event

type mle_log from multilineedit within w_splash
integer x = 18
integer y = 480
integer width = 2231
integer height = 1040
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_splash
integer x = 37
integer y = 1792
integer width = 2231
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Copyright, Maersk Tankers A/S"
boolean focusrectangle = false
end type

type st_2 from statictext within w_splash
integer x = 37
integer y = 1664
integer width = 2085
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "This program is protected by Copyright law. It is forbidden to copy, duplicate or distribute this software or any part of it without the prior consent of Maersk Tankers."
boolean focusrectangle = false
end type

type st_ver from statictext within w_splash
integer x = 1755
integer y = 272
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "- - -"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_1 from picture within w_splash
integer width = 2286
integer height = 464
string picturename = "J:\TramosWS\VIMS\images\Vims\vimsplash.bmp"
boolean focusrectangle = false
end type

type ln_1 from line within w_splash
long linecolor = 10789024
integer linethickness = 4
integer beginx = 37
integer beginy = 1632
integer endx = 2249
integer endy = 1632
end type

