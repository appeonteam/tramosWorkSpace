$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer width = 3273
integer height = 2536
boolean titlebar = true
string title = "VIMS - Vetting and Inspection Management System"
string menuname = "m_vett"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
windowtype windowtype = mdi!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\VIMS.ico"
boolean center = true
mdi_1 mdi_1
end type
global w_main w_main

type variables

Integer ii_AlertCol, ii_Counter, ii_Mode = 0
end variables

forward prototypes
public subroutine f_checksysmsg ()
end prototypes

public subroutine f_checksysmsg ();Long ll_Msg
Datastore lds_temp
String ls_IMOList[]

If g_obj.Deptid = 1 then   //  Activate flash only if Vetting Dept

	// Get vessels assigned to user
	lds_temp = Create Datastore
	lds_temp.DataObject = "d_sq_tb_vsllist"
	lds_temp.SetTransObject(SQLCA)
	lds_temp.Retrieve(g_Obj.UserID) 	
	
	// Put all vessels into array
	For ll_Msg = 1 to lds_temp.Rowcount()
		ls_IMOList[ll_Msg] = String(lds_temp.GetItemNumber(ll_Msg, "imo"))
	Next
	
	// If no vessels assigned, add dummy vessel IMO
	If lds_temp.rowcount( ) = 0 then ls_IMOList[1]= "9999999"
	
	// Get number of alerts for user
	lds_temp.DataObject = "d_sq_tb_useralerts"
	lds_temp.SetTransObject(SQLCA)
	If lds_temp.Retrieve(ls_IMOList) <=0 then Return
	ll_Msg = lds_temp.GetItemNumber(1, "activecount")
	
	Commit;
	
	// Activate/deactivate flashign
	If ll_Msg > 0 then 
		ii_Mode = 1
		Timer(1, This)    // Start timer
	Else 
		ii_Mode = 0
		Timer(300, This)    // Change mode and reset icon
		m_vett.m_vims.m_systemmessages.toolbaritemname = "J:\TramosWS\VIMS\images\Vims\Msg.ico"
	End If	
	
	Destroy lds_temp
End If

end subroutine

on w_main.create
if this.MenuName = "m_vett" then this.MenuID = create m_vett
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event close;
Update VETT_INSP Set USER_LOCK = Null Where USER_LOCK = :g_Obj.UserID;

If SQLCA.SQLCode >= 0 then 
	Commit;
Else 
	RollBack;
End If

If IsValid(w_Log) then Close(w_Log)

Disconnect using SQLCA;
end event

event open;String ls_Value
Long ll_Msg

// Update login info
Update USERS Set LASTLOGINFROM = 1, LASTLOGIN=getdate() Where USERID = :g_Obj.UserID;
Commit;

f_CalcScore()

If f_Config("FOOT", g_Obj.Footer, 0) < 0 then g_Obj.Footer = "Maersk Tankers - A.P. Moller Group"

If f_Config("VSGR", ls_Value, 0) = 0 then g_Obj.scoregreen = Integer(ls_Value) else g_Obj.scoregreen = 80

If f_Config("VSYL", ls_Value, 0) = 0 then g_Obj.scoreyellow = Integer(ls_Value) else g_Obj.scoreyellow = 50

If f_Config("INGR", ls_Value, 0) = 0 then g_Obj.inspgreen = ls_Value else g_Obj.inspgreen = "B"

If f_Config("INYL", ls_Value, 0) = 0 then g_Obj.inspyellow = ls_Value else g_Obj.inspyellow = "D"

If f_Config("DBST", ls_Value, 0) = 0 then 
	g_obj.DBmodif = Integer(ls_Value)
Else
	Messagebox("DB Status", "Could not retrieve the database status setting. Please contact the system administrator with this message!")
End If

OpenSheet(w_Back, This, 0, Original!)

If g_obj.DeptID > 1 then 
	
	// Hide "check incoming" menu 
	m_vett.m_vims.m_l4.Visible = False
	m_vett.m_vims.m_CheckIncoming.Visible = False
	m_vett.m_vims.m_l4.ToolbarItemVisible = False
	m_vett.m_vims.m_CheckIncoming.ToolbarItemVisible = False	
End If

f_CheckSysMsg( )  // Check if any active system messages

//Messagebox("Pixels", UnitsToPixels(4500, XUnitsToPixels! ))

end event

event resize;
If isvalid(w_back) then
	w_back.x=(newwidth - w_back.width)/2
	w_back.y=(newheight - w_back.height)/2
end if
end event

event closequery;
//If MessageBox("Confirm Exit", "Do you really want to exit VIMS?", Question!, YesNo!) = 2 then Return 1

//Above removed by request from Vetting
end event

event timer;
If ii_Mode = 1 then   // If flashing
	If ii_AlertCol = 0  then
		m_vett.m_vims.m_systemmessages.toolbaritemname = "J:\TramosWS\VIMS\images\Vims\Msg.ico"
	Else
		m_vett.m_vims.m_systemmessages.toolbaritemname = "J:\TramosWS\VIMS\images\Vims\MsgY.ico"
	End if
	
	ii_AlertCol = 1 - ii_AlertCol
	
	ii_Counter ++
	
	If ii_Counter >= 180 then   // every three minutes check if someone has ack
		ii_Counter = 0
		f_checksysmsg( )
	End If
	
Else   // If not flashing, check msgs every 5 min
	
	f_checksysmsg( )
	
End If

end event

event key;
//If Key = KeyF1! then guo_Global.of_LaunchWiki("VIMS.aspx")
end event

type mdi_1 from mdiclient within w_main
long BackColor=12639424
end type

