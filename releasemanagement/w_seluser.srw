HA$PBExportHeader$w_seluser.srw
forward
global type w_seluser from window
end type
type cb_add from commandbutton within w_seluser
end type
type sle_search from u_sle within w_seluser
end type
type dw_user from datawindow within w_seluser
end type
end forward

global type w_seluser from window
integer width = 1143
integer height = 1968
boolean titlebar = true
string title = "Select User"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
cb_add cb_add
sle_search sle_search
dw_user dw_user
end type
global w_seluser w_seluser

type variables
private:
window iw_owner_window

end variables

forward prototypes
protected function integer of_autoposition (window aw_owner)
public function integer of_adduser (string as_userid, string as_firstname, string as_lastname)
end prototypes

protected function integer of_autoposition (window aw_owner);
long ll_ScreenWidth

Environment envobj

GetEnvironment ( envobj )
ll_ScreenWidth = PixelsToUnits(envobj.ScreenWidth, XPixelsToUnits! )

if ll_ScreenWidth > aw_owner.x + aw_owner.width + this.width then
	this.x = aw_owner.x + aw_owner.width
else
	this.x = aw_owner.x - this.width
end if

this.y = aw_owner.y

return 1
end function

public function integer of_adduser (string as_userid, string as_firstname, string as_lastname);
long ll_row

ll_row = dw_user.insertrow(0)

if ll_row > 0 then
	dw_user.setitem(ll_row, "userid", as_userid)
	dw_user.setitem(ll_row, "first_name", as_firstname)
	dw_user.setitem(ll_row, "last_name", as_lastname)
	dw_user.setitem(ll_row, "fullname", as_firstname + ", " + as_lastname)
	dw_user.setrow(ll_row)
	dw_user.scrolltorow(ll_row)
	return 1
end if

return -1
end function

on w_seluser.create
this.cb_add=create cb_add
this.sle_search=create sle_search
this.dw_user=create dw_user
this.Control[]={this.cb_add,&
this.sle_search,&
this.dw_user}
end on

on w_seluser.destroy
destroy(this.cb_add)
destroy(this.sle_search)
destroy(this.dw_user)
end on

event open;
stru_seluparm s_seluinfo

this.backcolor = g_app.MT_FORMDETAIL_BG

if isvalid(message.powerobjectparm) then
	if message.powerobjectparm.classname() = 'stru_seluparm' then
		s_seluinfo = message.powerobjectparm
		
		if isvalid(s_seluinfo.owner_window) then
			if s_seluinfo.owner_window.classname() = 'w_main' then
				of_autoposition(s_seluinfo.owner_window)
				
				iw_owner_window = s_seluinfo.owner_window
			end if
		end if
	end if
end if

dw_user.settransobject(SQLCA)
dw_user.retrieve(s_seluinfo.selected[])

end event

type cb_add from commandbutton within w_seluser
integer x = 750
integer y = 1752
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add"
end type

event clicked;
string ls_firstname
string ls_lastname
string ls_userid
long ll_row
long ll_rc

ll_row = dw_user.getrow()
if ll_row <= 0 then return

ls_firstname = dw_user.getitemstring(ll_row, "first_name")
ls_lastname = dw_user.getitemstring(ll_row, "last_name")
ls_userid = dw_user.getitemstring(ll_row, "userid")

try
	ll_rc = iw_owner_window.dynamic of_adduser(ls_userid, ls_firstname, ls_lastname)
catch (throwable e)
	// do nothing
	ll_rc = -1
end try
if ll_rc = 1 then
	dw_user.deleterow(ll_row)
	ll_row = dw_user.getrow()
	if ll_row > 0 then
		dw_user.selectrow(0,false)
		dw_user.selectrow(ll_row, true)
	end if
end if


end event

type sle_search from u_sle within w_seluser
integer x = 37
integer y = 32
integer width = 1061
integer height = 72
integer taborder = 10
integer textsize = -8
long textcolor = 8421504
string text = ""
borderstyle borderstyle = stylebox!
string prompttext = "<Enter user ID or name>"
boolean prompt = true
end type

event ue_changed;call super::ue_changed;
n_string ln_string
string ls_filterexpr
string ls_text
long ll_row

as_text = upper(as_text)

ls_text = ln_string.of_globalreplace(as_text, "~'", "~~~'")

if ls_text <> "" then
	ls_filterexpr = "(upper(userid) like '%" + ls_text + "%') or (upper(fullname) like '%" + ls_text + "%')"
else
	ls_filterexpr = ""
end if

dw_user.setfilter(ls_filterexpr)
dw_user.filter()

ll_row = dw_user.getrow()
if ll_row > 0 then
	dw_user.selectrow(0,false)
	dw_user.selectrow(ll_row, true)
else
	dw_user.selectrow(0,false)
end if


end event

type dw_user from datawindow within w_seluser
integer x = 37
integer y = 128
integer width = 1061
integer height = 1608
integer taborder = 10
string title = "none"
string dataobject = "d_seluser"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

event clicked;if row > 0 then
	this.setrow(row)
end if

end event

event doubleclicked;cb_add.event clicked()
end event

