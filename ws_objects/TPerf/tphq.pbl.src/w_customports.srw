$PBExportHeader$w_customports.srw
forward
global type w_customports from window
end type
type cb_auto from commandbutton within w_customports
end type
type sle_port from singlelineedit within w_customports
end type
type cb_match from commandbutton within w_customports
end type
type cb_find from commandbutton within w_customports
end type
type st_2 from statictext within w_customports
end type
type st_1 from statictext within w_customports
end type
type dw_ports from datawindow within w_customports
end type
type dw_cust from datawindow within w_customports
end type
end forward

global type w_customports from window
integer width = 2633
integer height = 2140
boolean titlebar = true
string title = "Match Custom Ports"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_auto cb_auto
sle_port sle_port
cb_match cb_match
cb_find cb_find
st_2 st_2
st_1 st_1
dw_ports dw_ports
dw_cust dw_cust
end type
global w_customports w_customports

on w_customports.create
this.cb_auto=create cb_auto
this.sle_port=create sle_port
this.cb_match=create cb_match
this.cb_find=create cb_find
this.st_2=create st_2
this.st_1=create st_1
this.dw_ports=create dw_ports
this.dw_cust=create dw_cust
this.Control[]={this.cb_auto,&
this.sle_port,&
this.cb_match,&
this.cb_find,&
this.st_2,&
this.st_1,&
this.dw_ports,&
this.dw_cust}
end on

on w_customports.destroy
destroy(this.cb_auto)
destroy(this.sle_port)
destroy(this.cb_match)
destroy(this.cb_find)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_ports)
destroy(this.dw_cust)
end on

event open;
dw_Cust.SetTransObject(SQLCA)
dw_Cust.Retrieve()

dw_Ports.SetTransObject(SQLCA)
dw_Ports.Retrieve()
dw_Ports.SetSort("port_n")
dW_Ports.Sort()
end event

type cb_auto from commandbutton within w_customports
integer x = 841
integer y = 1936
integer width = 677
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Auto Match"
end type

event clicked;
Integer li_Loop
Integer li_Found, li_Changed
String ls_Port, ls_PortCode, ls_Custom

For li_Loop = 1 to dw_Cust.Rowcount( )
	ls_Port = dw_Cust.GetItemString(li_Loop, "port")
	ls_Custom = Trim(Lower(Right(ls_Port, Len(ls_Port)-2)))
	dw_Cust.SetRow(li_Loop)
	dw_Cust.ScrollToRow(li_Loop)
	
	If Pos(ls_Custom,"'") = 0 then 
	
		li_Found = dw_Ports.Find("lower(port_n) like '" + ls_Custom + "'", 0, dw_Ports.RowCount())
		If li_Found > 0 Then
			
			ls_PortCode = dw_Ports.GetItemString(li_Found, "Port_Code")
			
			Update TPERF_REPORTS Set PORT = :ls_PortCode Where PORT = :ls_Port;
	
			If SQLCA.SQLCode < 0 then
				Messagebox("DB Error", SQLCA.SQLErrText)
				Rollback;
				Return
			End If
			
			li_Changed += SQLCA.SQLNRows
			
			Update TPERF_HRBR Set PORT = :ls_PortCode Where PORT = :ls_Port;
			
			If SQLCA.SQLCode < 0 then
				Messagebox("DB Error", SQLCA.SQLErrText)
				Rollback;
				Return
			End If
			
			li_Changed += SQLCA.SQLNRows
	
			Commit;
	
		End If
	End If
Next

dw_Cust.Retrieve( )

Messagebox("Finished", "Total ports changed: " + String(li_Changed))

end event

type sle_port from singlelineedit within w_customports
integer x = 841
integer y = 208
integer width = 677
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_match from commandbutton within w_customports
integer x = 841
integer y = 576
integer width = 677
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Match!"
end type

event clicked;
String ls_CustPort, ls_PortCode
Integer li_Rows

ls_CustPort = dw_Cust.GetItemString(dw_Cust.GetRow(), "port")
ls_PortCode = dw_Ports.GetItemString(dw_Ports.GetRow(), "Port_Code")

If Len(ls_PortCode)<>3 then 
	Messagebox("Wrong Code", ls_PortCode + " is not a valid code")
	Return
End If

Update TPERF_REPORTS Set PORT = :ls_PortCode Where PORT = :ls_CustPort;

If SQLCA.SQLCode < 0 then
	Messagebox("DB Error", SQLCA.SQLErrText)
	Rollback;
	Return
End If

li_Rows = SQLCA.SQLNRows

Update TPERF_HRBR Set PORT = :ls_PortCode Where PORT = :ls_CustPort;

If SQLCA.SQLCode < 0 then
	Messagebox("DB Error", SQLCA.SQLErrText)
	Rollback;
	Return
End If

li_Rows += SQLCA.SQLNRows

Commit;

dw_Cust.DeleteRow(dw_Cust.GetRow())

If dw_Cust.GetRow()>0 then sle_Port.Text = dw_Cust.GetItemString(dw_Cust.GetRow(), "cusport")

cb_Match.Enabled = False

Messagebox("Rows Changed", "Custom Port:~t" + ls_CustPort + "~nNew Port:~t" + ls_PortCode + "~n~n" + String(li_Rows) + " rows changed")
end event

type cb_find from commandbutton within w_customports
integer x = 841
integer y = 320
integer width = 677
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "> Find Port >"
end type

event clicked;
String ls_Custom
Integer li_Found

ls_Custom = Trim(Lower(sle_Port.Text),True)

li_Found = dw_Ports.Find("lower(port_n) like '%" + ls_Custom + "%'", 0, dw_Ports.RowCount())

If li_Found > 0 then 
	dw_Ports.SetRow(li_Found)
	dw_Ports.ScrollToRow(li_Found)
	cb_Match.Enabled = True
Else
	Messagebox("Not Found", "Could not match port " + ls_Custom)
End If



end event

type st_2 from statictext within w_customports
integer x = 1554
integer y = 16
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tramos Ports"
boolean focusrectangle = false
end type

type st_1 from statictext within w_customports
integer x = 18
integer y = 16
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Custom Ports"
boolean focusrectangle = false
end type

type dw_ports from datawindow within w_customports
integer x = 1554
integer y = 80
integer width = 1042
integer height = 1952
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_portlist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
cb_Match.Enabled = True
end event

type dw_cust from datawindow within w_customports
integer x = 18
integer y = 80
integer width = 786
integer height = 1952
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_customports"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
sle_Port.Text = dw_Cust.GetItemString(dw_Cust.GetRow(), "cusport")

cb_Match.Enabled = False
end event

