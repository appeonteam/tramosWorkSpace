$PBExportHeader$w_overdue.srw
forward
global type w_overdue from window
end type
type cbx_pc from checkbox within w_overdue
end type
type cb_close from commandbutton within w_overdue
end type
type st_1 from statictext within w_overdue
end type
type dw_overdue from datawindow within w_overdue
end type
end forward

global type w_overdue from window
integer width = 1467
integer height = 1652
boolean titlebar = true
string title = "Vessels Overdue"
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_pc cbx_pc
cb_close cb_close
st_1 st_1
dw_overdue dw_overdue
end type
global w_overdue w_overdue

type variables
n_registry Reg
end variables

event open;Integer li_PCSel

li_PCSel = Integer(Reg.GetSetting("OverduePC", "0"))

If li_PCSel = 0 then 
	li_PCSel = -1 
Else 
	li_PCSel = 0
	cbx_pc.Checked = True
End If

dw_overdue.SetTransObject(SQLCA)

dw_overdue.Retrieve(g_UserInfo.userid, li_PCSel) 

Commit;

If dw_overdue.RowCount() = 0 then Close(This)

end event

on w_overdue.create
this.cbx_pc=create cbx_pc
this.cb_close=create cb_close
this.st_1=create st_1
this.dw_overdue=create dw_overdue
this.Control[]={this.cbx_pc,&
this.cb_close,&
this.st_1,&
this.dw_overdue}
end on

on w_overdue.destroy
destroy(this.cbx_pc)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.dw_overdue)
end on

event close;
If cbx_PC.Checked then
	Reg.SaveSetting("OverduePC", "1" )
Else
	Reg.SaveSetting("OverduePC", "0" )
End If

end event

type cbx_pc from checkbox within w_overdue
integer x = 55
integer y = 1344
integer width = 1170
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display vessels from primary profit center only"
end type

event clicked;
If This.Checked then
	dw_overdue.Retrieve(g_UserInfo.userid, 0)
Else
	dw_overdue.Retrieve(g_UserInfo.userid, -1)
End If
end event

type cb_close from commandbutton within w_overdue
integer x = 512
integer y = 1456
integer width = 421
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
boolean default = true
end type

event clicked;

Close(Parent)

end event

type st_1 from statictext within w_overdue
integer x = 55
integer y = 64
integer width = 1344
integer height = 144
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "The following vessels have not reported for more than one week:"
boolean focusrectangle = false
end type

type dw_overdue from datawindow within w_overdue
integer x = 55
integer y = 224
integer width = 1353
integer height = 1120
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_overdue"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

