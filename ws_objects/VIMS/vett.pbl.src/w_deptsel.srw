$PBExportHeader$w_deptsel.srw
forward
global type w_deptsel from window
end type
type cb_ok from commandbutton within w_deptsel
end type
type cb_cancel from commandbutton within w_deptsel
end type
type st_1 from statictext within w_deptsel
end type
type dw_dept from datawindow within w_deptsel
end type
type gb_1 from groupbox within w_deptsel
end type
end forward

global type w_deptsel from window
integer width = 1061
integer height = 1232
boolean titlebar = true
string title = "Departments"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
dw_dept dw_dept
gb_1 gb_1
end type
global w_deptsel w_deptsel

on w_deptsel.create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.dw_dept=create dw_dept
this.gb_1=create gb_1
this.Control[]={this.cb_ok,&
this.cb_cancel,&
this.st_1,&
this.dw_dept,&
this.gb_1}
end on

on w_deptsel.destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.dw_dept)
destroy(this.gb_1)
end on

event open;
dw_dept.SetTransobject(SQLCA)

dw_dept.Retrieve( )

If g_obj.param = 0 then cb_ok.Text = "Send"    

end event

type cb_ok from commandbutton within w_deptsel
integer x = 146
integer y = 1040
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
boolean default = true
end type

event clicked;
g_obj.Noteid = dw_dept.GetItemNumber(dw_Dept.GetRow(), "dept_id")
g_obj.objstring = dw_dept.GetItemString(dw_Dept.GetRow(), "deptname")

Close(Parent)
end event

type cb_cancel from commandbutton within w_deptsel
integer x = 585
integer y = 1040
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.noteid = 0

Close(Parent)
end event

type st_1 from statictext within w_deptsel
integer x = 55
integer y = 80
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select a Department:"
boolean focusrectangle = false
end type

type dw_dept from datawindow within w_deptsel
integer x = 55
integer y = 144
integer width = 933
integer height = 848
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_deptsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
SetRedraw(False)
SetRedraw(True)
end event

type gb_1 from groupbox within w_deptsel
integer x = 18
integer y = 16
integer width = 1006
integer height = 1008
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

