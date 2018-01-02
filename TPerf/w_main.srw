HA$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer x = 101
integer y = 100
integer width = 3237
integer height = 2088
boolean titlebar = true
string title = "Tramper Performance System 2"
string menuname = "m_tperf"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
windowtype windowtype = mdi!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "H:\Tramos.Dev\Resource\TPerf\Globe.ico"
boolean center = true
mdi_1 mdi_1
end type
global w_main w_main

type variables

Boolean ibool_Alert

Integer ii_AlertCol

end variables

on w_main.create
if this.MenuName = "m_tperf" then this.MenuID = create m_tperf
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event close;disconnect using SQLCA;

If SQLCA.SQLCode <> 0 Then
	MessageBox ("Cannot Disconnect from Database", SQLCA.SQLErrText )
End If

end event

event open;
opensheet(w_back, this, 0 ,Original!)

Post Opensheet(w_overdue, w_main, 0, Original!)
end event

event resize;
If isvalid(w_back) then
	w_back.x=(newwidth - w_back.width)/2
	w_back.y=(newheight - w_back.height)/2
end if

If isvalid(w_overdue) then
	w_overdue.x=(newwidth - w_overdue.width)/2
	w_overdue.y=(newheight - w_overdue.height)/2
end if
end event

event timer;
If ii_AlertCol = 0  then
	m_tperf.m_tramperperformance.m_alerts.toolbaritemname = "H:\Tramos.Dev\Resource\TPerf\red_exclm.gif"
Else
	m_tperf.m_tramperperformance.m_alerts.toolbaritemname = "H:\Tramos.Dev\Resource\TPerf\exclm.gif"
End if

ii_AlertCol = 1 - ii_AlertCol

end event

event key;
If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type mdi_1 from mdiclient within w_main
long BackColor=12639424
end type

