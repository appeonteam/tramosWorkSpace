$PBExportHeader$w_pcselect.srw
forward
global type w_pcselect from window
end type
type cb_cancel from commandbutton within w_pcselect
end type
type cb_ok from commandbutton within w_pcselect
end type
type cb_inv from commandbutton within w_pcselect
end type
type cb_none from commandbutton within w_pcselect
end type
type cb_all from commandbutton within w_pcselect
end type
type dw_pc from datawindow within w_pcselect
end type
type st_1 from statictext within w_pcselect
end type
type ln_1 from line within w_pcselect
end type
end forward

global type w_pcselect from window
integer width = 1271
integer height = 1796
boolean titlebar = true
string title = "Select Profit Centers"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
cb_inv cb_inv
cb_none cb_none
cb_all cb_all
dw_pc dw_pc
st_1 st_1
ln_1 ln_1
end type
global w_pcselect w_pcselect

event open;
Integer li_Count

dw_pc.SetTransObject(SQLCA)
dw_pc.Retrieve()

dw_pc.SetFilter("pc_nr in (" + g_parameters.paramstring + ")")
dw_pc.Filter()

dw_pc.SelectRow(0, True)

dw_pc.SetFilter("")
dw_pc.Filter()

end event

on w_pcselect.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_inv=create cb_inv
this.cb_none=create cb_none
this.cb_all=create cb_all
this.dw_pc=create dw_pc
this.st_1=create st_1
this.ln_1=create ln_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.cb_inv,&
this.cb_none,&
this.cb_all,&
this.dw_pc,&
this.st_1,&
this.ln_1}
end on

on w_pcselect.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_inv)
destroy(this.cb_none)
destroy(this.cb_all)
destroy(this.dw_pc)
destroy(this.st_1)
destroy(this.ln_1)
end on

type cb_cancel from commandbutton within w_pcselect
integer x = 713
integer y = 1584
integer width = 384
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_parameters.paramstring = ''

Close(Parent)
end event

type cb_ok from commandbutton within w_pcselect
integer x = 183
integer y = 1584
integer width = 384
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
Integer li_Count
String ls_Selected

For li_Count = 1 to dw_pc.RowCount()
	If dw_pc.IsSelected(li_Count) then ls_Selected += String(dw_pc.GetItemNumber(li_Count, "pc_nr")) + ","
Next

If ls_Selected = '' then
	MessageBox("No Selection", "Please select at least one profit center!", Exclamation!)
	Return
End If

ls_Selected = Left(ls_Selected, Len(ls_Selected) - 1)   // Remove last comma

g_parameters.paramstring = ls_Selected

Close(Parent)


end event

type cb_inv from commandbutton within w_pcselect
integer x = 421
integer y = 1456
integer width = 201
integer height = 64
integer taborder = 40
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Invert"
end type

event clicked;Integer li_Count

For li_Count = 1 to dw_pc.RowCount()
	dw_pc.SelectRow(li_Count, Not dw_pc.IsSelected(li_Count))
Next
end event

type cb_none from commandbutton within w_pcselect
integer x = 219
integer y = 1456
integer width = 201
integer height = 64
integer taborder = 30
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "None"
end type

event clicked;
dw_pc.Selectrow(0, False)
end event

type cb_all from commandbutton within w_pcselect
integer x = 18
integer y = 1456
integer width = 201
integer height = 64
integer taborder = 20
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "All"
end type

event clicked;
dw_pc.Selectrow(0, True)
end event

type dw_pc from datawindow within w_pcselect
integer x = 18
integer y = 96
integer width = 1207
integer height = 1360
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_pcselect"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If row = 0 then return

This.SelectRow(row, Not This.IsSelected(row))
end event

type st_1 from statictext within w_pcselect
integer x = 18
integer y = 16
integer width = 933
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select one or more profit centers:"
boolean focusrectangle = false
end type

type ln_1 from line within w_pcselect
long linecolor = 33554432
integer linethickness = 4
integer beginx = 18
integer beginy = 1552
integer endx = 1225
integer endy = 1552
end type

