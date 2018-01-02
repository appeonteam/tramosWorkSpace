$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer width = 3305
integer height = 1996
boolean titlebar = true
string title = "VIMS Mobile"
string menuname = "m_mobile"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
windowtype windowtype = mdi!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
integer animationtime = 100
mdi_1 mdi_1
end type
global w_main w_main

on w_main.create
if this.MenuName = "m_mobile" then this.MenuID = create m_mobile
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;String ls_Year

f_Write2Log("w_Main Open")

// If inspector on vessel installation or readonly, disable some menus
If ((g_Obj.Login = 2) and (g_Obj.Install = 0 )) or (g_Obj.Login = 0) Then  
	m_mobile.m_sys.m_password.Enabled = False
	m_mobile.m_sys.m_default.Enabled = False
	m_mobile.m_sys.m_updatevmic.Enabled = False
	m_mobile.m_sys.m_admin.m_deletedatabase.Enabled = False
	m_mobile.m_sys.m_admin.m_updatedatabase.Enabled = False
End If

// If on inspector installation
If g_Obj.Login = 2 then
	m_mobile.m_sys.m_password.Visible = False
	m_mobile.m_sys.m_password.ToolbarItemVisible = False
	m_mobile.m_sys.m_default.Visible = False
	m_mobile.m_sys.m_default.ToolbarItemVisible = False	
    m_mobile.m_sys.m_updatevmic.ToolbarItemVisible = False
End If

// If not min DB version reqd then disable some menus
If g_Obj.DBver < g_Obj.MinDBVer then
	Post Messagebox("Database Issue Outdated", "This version of VIMS Mobile requires DB Issue " + String(g_Obj.MinDBVer) + " or above. Functionality will be disabled.~n~nPlease update the database. Contact maropsmt@maersk.com for assistance.", Exclamation!)
	m_mobile.m_Inspections.m_Browser.Enabled = False
	m_mobile.m_Inspections.m_InspectionReports.Enabled = False
	m_mobile.m_Inspections.m_SearchInspections.Enabled = False
End If

// Open background window
OpenSheet(w_Back, This, 0, Original!)

// If Vessel management login, check if current password has expired
If g_Obj.Login = 1 then
	If 	f_Config("PWYR", ls_Year, 0) = 0 then
		If String(Year(Today())) > ls_Year then
			Post Messagebox("Password Expired", "The current password has expired and needs to be changed.")	
			Post Open(w_Password)
		End If
	End If
End If

end event

event resize;integer li_x, li_y

If IsValid(w_back) then
	li_x = (newwidth - w_back.width)/2
	li_y = (newheight - w_back.height)/2
	If li_x < 0 then li_x = 0
	If li_y < 0 then li_y = 0
	w_Back.Move(li_x, li_y)
end if
end event

event close;
Update VETT_INSP Set USER_LOCK = Null Where USER_LOCK = :g_Obj.CompName;
Commit;

Delete from VETT_ATT Where INSP_ID is Null;
Commit;

f_Write2Log("w_Main Close")	

If IsValid(w_Log) then Close(w_Log)

Disconnect using SQLCA;


end event

event toolbarmoved;
If This.ToolBarVisible then
	m_mobile.m_sys.m_showtoolbar.Checked = True
Else
	m_mobile.m_sys.m_showtoolbar.Checked = False
End If
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2700)
end event

type mdi_1 from mdiclient within w_main
long BackColor=12639424
end type

