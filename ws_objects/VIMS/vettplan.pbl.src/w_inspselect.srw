$PBExportHeader$w_inspselect.srw
forward
global type w_inspselect from window
end type
type cb_save from commandbutton within w_inspselect
end type
type cb_cancel from commandbutton within w_inspselect
end type
type st_1 from statictext within w_inspselect
end type
type dw_insp from datawindow within w_inspselect
end type
type gb_1 from groupbox within w_inspselect
end type
end forward

global type w_inspselect from window
integer width = 1879
integer height = 952
boolean titlebar = true
string title = "Select Inspection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_save cb_save
cb_cancel cb_cancel
st_1 st_1
dw_insp dw_insp
gb_1 gb_1
end type
global w_inspselect w_inspselect

on w_inspselect.create
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.dw_insp=create dw_insp
this.gb_1=create gb_1
this.Control[]={this.cb_save,&
this.cb_cancel,&
this.st_1,&
this.dw_insp,&
this.gb_1}
end on

on w_inspselect.destroy
destroy(this.cb_save)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.dw_insp)
destroy(this.gb_1)
end on

event open;
dw_Insp.SetTransObject(SQLCA)

dw_Insp.Retrieve(g_Obj.ObjID)
end event

type cb_save from commandbutton within w_inspselect
integer x = 366
integer y = 752
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
end type

event clicked;

g_Obj.InspID = dw_Insp.GetItemNumber(dw_Insp.GetRow(), "insp_id")
g_Obj.ObjParent = String(dw_Insp.GetItemDateTime(dw_Insp.GetRow(), "inspdate"), "dd MMM yyyy") + " - " + dw_Insp.GetItemString(dw_Insp.GetRow(), "name")
Close(Parent)
end event

type cb_cancel from commandbutton within w_inspselect
integer x = 1152
integer y = 752
integer width = 402
integer height = 96
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
g_Obj.InspID = 0
Close(Parent)
end event

type st_1 from statictext within w_inspselect
integer x = 55
integer y = 48
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Inspection:"
boolean focusrectangle = false
end type

type dw_insp from datawindow within w_inspselect
integer x = 55
integer y = 112
integer width = 1755
integer height = 560
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_inspsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then cb_Save.Enabled = False
end event

type gb_1 from groupbox within w_inspselect
integer x = 18
integer width = 1829
integer height = 720
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

