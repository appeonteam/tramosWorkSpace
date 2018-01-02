$PBExportHeader$w_userselect.srw
forward
global type w_userselect from window
end type
type cbx_hide from checkbox within w_userselect
end type
type cb_cancel from commandbutton within w_userselect
end type
type cb_select from commandbutton within w_userselect
end type
type dw_users from datawindow within w_userselect
end type
type st_1 from statictext within w_userselect
end type
end forward

global type w_userselect from window
integer width = 1024
integer height = 1572
boolean titlebar = true
string title = "User Selection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_hide cbx_hide
cb_cancel cb_cancel
cb_select cb_select
dw_users dw_users
st_1 st_1
end type
global w_userselect w_userselect

on w_userselect.create
this.cbx_hide=create cbx_hide
this.cb_cancel=create cb_cancel
this.cb_select=create cb_select
this.dw_users=create dw_users
this.st_1=create st_1
this.Control[]={this.cbx_hide,&
this.cb_cancel,&
this.cb_select,&
this.dw_users,&
this.st_1}
end on

on w_userselect.destroy
destroy(this.cbx_hide)
destroy(this.cb_cancel)
destroy(this.cb_select)
destroy(this.dw_users)
destroy(this.st_1)
end on

event open;Integer li_found, li_Rows

dw_users.SetTransObject(SQLCA)

li_Rows = dw_Users.Retrieve()

dw_Users.SetFilter("Users_Vett_Access>0")
dw_Users.Filter()

If li_Rows > 0 then
	li_found = dw_users.Find("userid = '" + String(g_obj.objstring) + "'", 1, li_Rows)
	if li_found > 0 then
		dw_users.SelectRow(0, False)
		dw_users.SelectRow(li_found, True)
		dw_users.SetRow(li_found)
		dw_users.ScrollTorow(li_found)
	End If
End If


end event

type cbx_hide from checkbox within w_userselect
integer x = 640
integer y = 32
integer width = 389
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Only"
boolean checked = true
end type

event clicked;
If cbx_Hide.Checked then dw_Users.SetFilter("Users_Vett_Access>0") Else dw_Users.SetFilter("")

dw_Users.Filter()

end event

type cb_cancel from commandbutton within w_userselect
integer x = 567
integer y = 1376
integer width = 311
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_obj.Objstring = ""

Close(Parent)
end event

type cb_select from commandbutton within w_userselect
integer x = 110
integer y = 1376
integer width = 311
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;
g_obj.objstring = dw_users.GetItemString( dw_users.GetRow(), "userid")
g_obj.sql = dw_users.GetItemString( dw_users.GetRow(), "fullname")

Close(Parent)
end event

type dw_users from datawindow within w_userselect
integer x = 18
integer y = 112
integer width = 969
integer height = 1232
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_userselect"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;// PB Bug - Detail background colour does not refresh when using arrow keys to select rows
// Workaround: This must be done to refresh the row colors when using arrow keys to navigate
This.SetRedraw(False)
This.SetRedraw(True)

end event

event retrieveend;
If rowcount = 0 then cb_select.Enabled = False
end event

event doubleclicked;
If row>0 then cb_Select.event clicked( )
end event

type st_1 from statictext within w_userselect
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
string text = "Select a User:"
boolean focusrectangle = false
end type

