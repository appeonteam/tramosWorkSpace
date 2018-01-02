$PBExportHeader$w_vslselect.srw
forward
global type w_vslselect from window
end type
type cb_cancel from commandbutton within w_vslselect
end type
type cb_select from commandbutton within w_vslselect
end type
type dw_vsl from datawindow within w_vslselect
end type
type st_1 from statictext within w_vslselect
end type
end forward

global type w_vslselect from window
integer width = 901
integer height = 1236
boolean titlebar = true
string title = "Vessel Selection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_select cb_select
dw_vsl dw_vsl
st_1 st_1
end type
global w_vslselect w_vslselect

on w_vslselect.create
this.cb_cancel=create cb_cancel
this.cb_select=create cb_select
this.dw_vsl=create dw_vsl
this.st_1=create st_1
this.Control[]={this.cb_cancel,&
this.cb_select,&
this.dw_vsl,&
this.st_1}
end on

on w_vslselect.destroy
destroy(this.cb_cancel)
destroy(this.cb_select)
destroy(this.dw_vsl)
destroy(this.st_1)
end on

event open;Integer li_found, li_Rows

dw_vsl.SetTransObject(SQLCA)

li_Rows = dw_vsl.Retrieve(g_obj.sql)

If li_Rows > 0 then
	li_found = dw_vsl.Find("imonumber = " + String(g_obj.vesselimo), 1, li_Rows)
	if li_found > 0 then
		dw_vsl.SelectRow(0, False)
		dw_vsl.SelectRow(li_found, True)
		dw_vsl.SetRow(li_found)
		dw_vsl.ScrollTorow(li_found)
	End If
End If


end event

type cb_cancel from commandbutton within w_vslselect
integer x = 494
integer y = 1056
integer width = 293
integer height = 80
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
g_obj.vesselimo = 0

Close(Parent)
end event

type cb_select from commandbutton within w_vslselect
integer x = 91
integer y = 1056
integer width = 293
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;
g_obj.vesselimo = dw_vsl.GetItemNumber( dw_vsl.GetRow(), "imonumber")
g_obj.sql = dw_vsl.GetItemString( dw_vsl.GetRow(), "name")

Close(Parent)
end event

type dw_vsl from datawindow within w_vslselect
integer x = 18
integer y = 112
integer width = 841
integer height = 928
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vslselect"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)
end event

event retrieveend;
If rowcount = 0 then cb_select.Enabled = False
end event

event doubleclicked;
If row>0 then cb_Select.event clicked( )
end event

type st_1 from statictext within w_vslselect
integer x = 37
integer y = 32
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select a Vessel:"
boolean focusrectangle = false
end type

