HA$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type dw_tphc from datawindow within w_main
end type
type st_msg from statictext within w_main
end type
end forward

global type w_main from window
integer width = 2117
integer height = 544
boolean titlebar = true
string title = "T-Perf Report Processor"
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_tphc dw_tphc
st_msg st_msg
end type
global w_main w_main

type variables

n_reportprocessor inv_repproc
String is_inifile
end variables

forward prototypes
public subroutine wf_processreports ()
public function integer wf_createtphc ()
end prototypes

public subroutine wf_processreports ();String ls_RepPath, ls_DataPath

ls_RepPath = ProfileString(is_inifile, "Path", "Incoming", "")
ls_DataPath = ProfileString(is_inifile, "Path", "Archive", "")

If ls_RepPath="" or ls_DataPath="" then  
	f_Write2Log("Incoming or Archive path not specfied")
	Close(This)
	Return
End If

If Right(ls_RepPath, 1) <> "\" then ls_RepPath += "\"
If Right(ls_DataPath, 1) <> "\" then ls_DataPath += "\"

SetPointer(HourGlass!)

Connect using SQLCA;

If SQLCA.SQLCode<>0 then
	f_Write2Log("Database connection failed: " + SQLCA.SQLErrText)
	Close(This)	
	Return
End If

inv_RepProc = Create n_reportprocessor

inv_RepProc.of_ProcessReports(ls_RepPath, ls_DataPath)

Destroy inv_RepProc

Close(This)
end subroutine

public function integer wf_createtphc ();OLEObject PortObj
Long Counter 
String PCode, PName, ls_FPath

ls_FPath = ProfileString(is_inifile, "Path", "tphcPath", "")

If ls_FPath = "" then
	f_Write2Log("TPHC Path path not specfied")
	Close(This)
	Return -1
End If

dw_tphc.SetTransObject( SQLCA)
dw_tphc.Retrieve( )

PortObj=CREATE OLEObject
Counter = PortObj.ConnectToNewObject("TPerf.PortDB")
If Counter < 0 Then
	Destroy PortObj
	f_Write2Log("OLE Error: Could not create PortDB Object. Error: " + String(Counter))	
	Return -1
End If

PortObj.ClearPorts

For Counter = 1 to dw_tphc.RowCount( )
	PCode = dw_tphc.getitemstring( Counter, "PORT_CODE")
   PName = dw_tphc.getitemstring( Counter, "PORT_N")
	PortObj.AddPort(PCode, PName)
Next

Counter = PortObj.WritePortFile(ls_FPath)

Destroy PortObj

If Counter>1000 then 
	f_Write2Log(String(Counter) + " ports written to tphc.dat")
Else
	f_Write2Log("Error: Could not create file. OLE Object returned error.")
	Return -1
End If

Return 1
end function

on w_main.create
this.dw_tphc=create dw_tphc
this.st_msg=create st_msg
this.Control[]={this.dw_tphc,&
this.st_msg}
end on

on w_main.destroy
destroy(this.dw_tphc)
destroy(this.st_msg)
end on

event open;
// Get ini file
is_inifile = GetCurrentDirectory()
If Right(is_inifile, 1) <> "\" then is_inifile += "\"
is_inifile += "tprp.ini"

// Connect to database
SQLCA.DBMS = "SYC Adaptive Server Enterprise"
SQLCA.Database = ProfileString(is_inifile, "Database", "Database", "")
SQLCA.LogID = ProfileString(is_inifile, "Login", "UserID", "")
SQLCA.LogPass = ProfileString(is_inifile, "Login", "Password", "")
SQLCA.Servername = ProfileString(is_inifile, "Database", "Servername", "")
SQLCA.DBParm = ProfileString(is_inifile, "Database", "DBParm", "Release='15',UTF8=1")
SQLCA.Lock = ""
SQLCA.AutoCommit = false

st_Msg.Text = "Connecting to " + sqlca.Servername

Post wf_ProcessReports( )



end event

event close;
st_Msg.Text = "Disconnecting..."

Disconnect using SQLCA;

end event

type dw_tphc from datawindow within w_main
boolean visible = false
integer x = 32
integer y = 44
integer width = 686
integer height = 400
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_portlist"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_msg from statictext within w_main
integer x = 18
integer y = 176
integer width = 2066
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "Connecting..."
alignment alignment = center!
boolean focusrectangle = false
end type

