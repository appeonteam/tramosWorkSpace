$PBExportHeader$w_vcn.srw
forward
global type w_vcn from window
end type
type st_exit from statictext within w_vcn
end type
type st_4 from statictext within w_vcn
end type
type st_msg from statictext within w_vcn
end type
type st_1hour from statictext within w_vcn
end type
type st_launch from statictext within w_vcn
end type
type st_2 from statictext within w_vcn
end type
type st_1 from statictext within w_vcn
end type
type lb_files from listbox within w_vcn
end type
type gb_1 from groupbox within w_vcn
end type
end forward

global type w_vcn from window
boolean visible = false
integer width = 1632
integer height = 872
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = centeranimation!
integer animationtime = 300
st_exit st_exit
st_4 st_4
st_msg st_msg
st_1hour st_1hour
st_launch st_launch
st_2 st_2
st_1 st_1
lb_files lb_files
gb_1 gb_1
end type
global w_vcn w_vcn

type prototypes

Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"
Private Function UnSignedLong FindWindow_NT(long ClassName, string WindowName ) LIBRARY "user32.dll"  ALIAS FOR "FindWindowW"

Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"


end prototypes

type variables


Integer ii_Mode, ii_LastHour, ii_Counter, ii_RandMin

// ii_Mode:  0 - Sleeping, 1 - Window active


end variables

forward prototypes
public function string wf_getprogramfilesfolder ()
private subroutine wf_respond2ping ()
end prototypes

public function string wf_getprogramfilesfolder ();
String ls_Path
Long ll_Ret

ls_Path = Space(260)
ll_Ret = SHGetSpecialFolderPath(Handle(This), ls_Path, 38, False)

ls_Path = Trim(ls_Path)

If Right(ls_Path,1) <> "\" then ls_Path += "\"

Return Trim(ls_Path)
end function

private subroutine wf_respond2ping ();// Function to respond to a ping from VIMS

String ls_Path = "E:\Automail\VIMS\Out\"
String ls_Server = "MAERSKSERVER", ls_Temp
Long ll_Buf 

SQLCA.DBMS = "OLE DB"
SQLCA.LogId = "sa"
SQLCA.LogPass = "gl8vf3rk"

If g_Compname = "SERVER" then   // If on Brostrom vessel
	ls_Path = "G:\Automail\VIMS\Out\"
	ls_Server = "SERVER"
	SQLCA.LogPass = "sapassword"
End If

SQLCA.AutoCommit = False

If g_TestMode then    // Only for Dev/Debug
	SQLCA.LogPass = "sqlserver"
	ls_Server = g_CompName
End If

// Check if server over-ride file is present
If FileExists(g_Appfolder + "VM_Server.txt") then
	ll_Buf = FileOpen(g_AppFolder + "VM_Server.txt")
	If ll_Buf > 0 then 
		If FileReadEx(ll_Buf, ls_Temp)>0 then ls_Server = Trim(ls_Temp, True)
		FileClose(ll_Buf)
	End If
End If

// Check if password over-ride file is present
If FileExists(g_Appfolder + "sapw.txt") then
	ll_Buf = FileOpen(g_AppFolder + "sapw.txt")
	If ll_Buf > 0 then 
		If FileReadEx(ll_Buf, ls_Temp)>0 then SQLCA.LogPass = Trim(ls_Temp, True)
		FileClose(ll_Buf)
	End If
End If

SQLCA.DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + ls_Server + "',PROVIDERSTRING='Database=VIMSDB',Identity='SCOPE_IDENTITY()'"

Connect Using SQLCA;

If SQLCA.SQLCode < 0 then 
	If g_TestMode then Messagebox("Ping Response Fail", "Server: " + ls_Server + "  Password: " + sqlca.logid)
	Return    // return if can't connect to database
End If

String ls_Data = "", ls_IMO
Integer li_File, li_Loop, li_Check

Select VALUE into :ls_IMO from VETT_CONFIG Where C_ID = 'VIMO';   // Get IMO Number

If SQLCA.SQLCode = 0 then
	Commit;
	ls_Data = "PING" + ls_IMO + ";"
Else
	Rollback;
	Return
End If

Select VALUE into :ls_Temp from VETT_CONFIG Where C_ID = 'VMVR';   // Get VM Version

If SQLCA.SQLCode = 0 then
	Commit;
	ls_Data += ls_Temp + ";"
Else
	Rollback;
	Return
End If

Select VALUE into :ls_Temp from VETT_CONFIG Where C_ID = 'DBVR';  // Get DB Issue

If SQLCA.SQLCode = 0 then
	Commit;
	ls_Data += String(Integer(ls_Temp)) + ";"  
Else
	Rollback;
	Return
End If

Disconnect Using SQLCA;   // disconnect from DB

// Open file
li_File = FileOpen(ls_Path + "pingresp" + ls_IMO + ".vpkg", TextMode!, Write!, LockReadWrite!, Replace!, EncodingUTF8!)
If (li_File <= 0) then 
	If g_TestMode then Messagebox("Ping Response Fail", "FileOpen failed")	
	Return
End If

li_Check = 1046  // Init checksum & write header
For li_Loop = 1 to 4
	FileWriteEx(li_File, CharA(255))
Next
li_Loop = FileWriteEx(li_File, CharA(26))

For li_Loop = 1 to Len(ls_data)  // Write data
	FileWriteEx(li_File, CharA(255 - AscA(Mid(ls_data,li_Loop,1))))
	li_Check += 255 - AscA(Mid(ls_data,li_Loop,1))
Next

li_Loop = FileWriteEx(li_File, CharA(Mod(li_Check, 256)))   // Write checksum

li_Loop = FileClose(li_File)   // Close file


end subroutine

on w_vcn.create
this.st_exit=create st_exit
this.st_4=create st_4
this.st_msg=create st_msg
this.st_1hour=create st_1hour
this.st_launch=create st_launch
this.st_2=create st_2
this.st_1=create st_1
this.lb_files=create lb_files
this.gb_1=create gb_1
this.Control[]={this.st_exit,&
this.st_4,&
this.st_msg,&
this.st_1hour,&
this.st_launch,&
this.st_2,&
this.st_1,&
this.lb_files,&
this.gb_1}
end on

on w_vcn.destroy
destroy(this.st_exit)
destroy(this.st_4)
destroy(this.st_msg)
destroy(this.st_1hour)
destroy(this.st_launch)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.lb_files)
destroy(this.gb_1)
end on

event timer;
String ls_Folder

If ii_mode = 0 then // If sleeping

	If g_TestMode then st_msg.Text = "Sleeping (" + String(Now(), "HH:mm:ss") + ")"

	If (Hour(Now()) <> ii_Lasthour) and (Minute(Now()) = ii_RandMin) or g_TestMode then	
		
		// Check if VIMS Mobile is already running
		If FindWindow_NT(0, "VIMS Mobile") > 0 then 
			ii_LastHour = Hour(Now())
			ii_RandMin = Rand(31) - 1
			Return	
		End If
		
		// Set automail folder		
		If g_compname = "SERVER" then ls_Folder = "G:\Automail\" Else ls_Folder = "E:\Automail\VIMS\In\"
		
		// Check for any pings from VIMS and respond
		If FileExists(ls_Folder + "vping.vpkg") then
			FileDelete(ls_Folder + "vping.vpkg")
			FileDelete(ls_Folder + "vping(1).vpkg")
			FileDelete(ls_Folder + "vping(2).vpkg")
			FileDelete(ls_Folder + "vping(3).vpkg")
			wf_Respond2Ping()
		End If
		
		// Check for any other files
		lb_Files.DirList(ls_Folder + "*.vpkg", 0)
		
		// Change folder back (otherwise automail folder will be current)
		ChangeDirectory(g_AppFolder)
		
		// If incoming found, pop open		
		If lb_Files.TotalItems()>0 then 
			If g_TestMode Then This.Transparency = 0 Else This.Visible = True
			st_msg.Text = "This window will close in 2.0 minutes"
			ii_Mode = 1
			ii_Counter = 20			
		End If
		
		ii_LastHour = Hour(Now())  // Completed for this hour

	End If
	
Else   // if popup is displaying
	
	ii_Counter --  // decrement counter
	st_msg.Text = "This window will close in " + String(ii_Counter/10, "0.0") + " minutes"
	If ii_Counter = 0 then
		ii_Mode = 0
		If g_TestMode then This.Transparency = 80 Else This.Visible = False
		st_msg.Text = "Sleeping"
		ii_RandMin = Rand(31) - 1
	End If
End If


end event

event open;
ii_RandMin = Rand(31)-1

If g_TestMode then  // only for DEV environment
	This.Transparency = 80 
	This.Visible = True
End If

Timer(6)

end event

type st_exit from statictext within w_vcn
integer x = 146
integer y = 656
integer width = 914
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "Close this reminder utility"
boolean focusrectangle = false
end type

event clicked;
If MessageBox("Confirm Close", "If you close this utility, you will not get any notification when VIMS Mobile receives an inspection package.~n~nAre you sure you want to close?", Question!, YesNo!) = 2 then Return

Close(Parent)
end event

type st_4 from statictext within w_vcn
integer x = 366
integer width = 914
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "VIMS Communication Notifier"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_msg from statictext within w_vcn
integer x = 73
integer y = 768
integer width = 1463
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Sleeping..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1hour from statictext within w_vcn
integer x = 146
integer y = 544
integer width = 1061
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "Remind me again after a one hour"
boolean focusrectangle = false
end type

event clicked;
ii_Mode = 0
st_msg.Text = "Sleeping"

If g_TestMode then Parent.Transparency = 80 Else Parent.Visible = False

end event

type st_launch from statictext within w_vcn
integer x = 146
integer y = 432
integer width = 622
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "Launch VIMS Mobile"
boolean focusrectangle = false
end type

event clicked;
String ls_Path

ls_Path = wf_GetProgramFilesFolder( )

SetPointer(HourGlass!)

ChangeDirectory(g_AppFolder)

If ls_Path > "" then
	If Run(ls_Path + "VIMSMo~~1\vmlaunch.cmd") = 1 then
		ii_Mode = 0
      If g_TestMode then Parent.Transparency = 80 Else Parent.Visible = False
	Else
		Messagebox("Launch Fail", "Could not launch VIMS Mobile.")
	End If
	Return
End If

Messagebox("Folder Not Found", "Could not locate VIMS Mobile.", Exclamation!)

end event

type st_2 from statictext within w_vcn
integer x = 73
integer y = 304
integer width = 677
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please select an option:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vcn
integer x = 73
integer y = 112
integer width = 1495
integer height = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "There are one or more inspection packages or database updates available for VIMS Mobile."
boolean focusrectangle = false
end type

type lb_files from listbox within w_vcn
boolean visible = false
integer x = 1317
integer y = 448
integer width = 219
integer height = 256
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_vcn
integer x = 18
integer width = 1573
integer height = 832
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

