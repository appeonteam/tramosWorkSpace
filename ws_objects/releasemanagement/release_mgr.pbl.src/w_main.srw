$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_public_report from commandbutton within w_main
end type
type cb_deluser from commandbutton within w_main
end type
type cb_add from commandbutton within w_main
end type
type dw_test from datawindow within w_main
end type
type cb_cancel from commandbutton within w_main
end type
type cb_update from commandbutton within w_main
end type
type cb_delete from commandbutton within w_main
end type
type cb_new from commandbutton within w_main
end type
type dw_form from datawindow within w_main
end type
type dw_list from datawindow within w_main
end type
type gb_testusers from groupbox within w_main
end type
end forward

global type w_main from window
integer width = 1874
integer height = 1968
boolean titlebar = true
string title = "Release Management Tool"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_public_report cb_public_report
cb_deluser cb_deluser
cb_add cb_add
dw_test dw_test
cb_cancel cb_cancel
cb_update cb_update
cb_delete cb_delete
cb_new cb_new
dw_form dw_form
dw_list dw_list
gb_testusers gb_testusers
end type
global w_main w_main

type variables
private:
boolean ib_refreshing = false
boolean ib_deleting = false
boolean ib_rowchanging = false

end variables

forward prototypes
public function long of_refresh_testuser ()
public function long of_update ()
public function boolean of_isupdatepending ()
public function long of_refresh ()
public function long of_adduser (string as_userid, string as_firstname, string as_lastname)
public function integer of_setkeyvalues ()
public function integer of_validate ()
end prototypes

public function long of_refresh_testuser ();
long ll_row
long ll_releaseid
long ll_rc

ll_row = dw_list.getrow()
if ll_row > 0 then
	ll_releaseid = dw_list.getitemnumber(ll_row, "release_id")
	ll_rc = dw_test.retrieve(ll_releaseid)
	ll_row = dw_test.getrow()
	if ll_row > 0 then
		dw_test.selectrow(0,false)
		dw_test.selectrow(ll_row, true)
	end if
else
	dw_test.reset()
	ll_rc = 0
end if

if isvalid(w_seluser) then
	close(w_seluser)
end if

return ll_rc
end function

public function long of_update ();
string ls_errmsg
long ll_startrelease
long ll_finishrelease
long ll_row, ll_rowcount
dwitemstatus le_itemstatus

if of_validate() = -1 then
	return -1
end if

ll_rowcount = dw_form.rowcount()
for ll_row = 1 to ll_rowcount
	ll_startrelease = dw_form.getitemnumber(ll_row, "start_release")
	le_itemstatus = dw_form.getitemstatus(ll_row, "start_release", primary!)
	if ll_startrelease = 1 and &
		(le_itemstatus = datamodified! or le_itemstatus = newmodified!) then
		dw_form.setitem(ll_row,"start_date",f_getdate())
	end if
	
	ll_finishrelease = dw_form.getitemnumber(ll_row, "finish_release")
	le_itemstatus = dw_form.getitemstatus(ll_row, "finish_release", primary!)
	if ll_finishrelease = 1 and &
		(le_itemstatus = datamodified! or le_itemstatus = newmodified!) then
		dw_form.setitem(ll_row,"finish_date",f_getdate())
	end if
next

if dw_list.update(true, false) = 1 then
	if of_setkeyvalues() = -1 then
		return -1
	end if
	if dw_test.update(true, false) = 1 then
		commit;
		dw_list.resetupdate()
		dw_test.resetupdate()
		return 1
	end if
end if

ls_errmsg = SQLCA.SQLErrText
rollback;

if len(ls_errmsg) > 0 then
	messagebox( "Error", ls_errmsg)
end if
return -1

end function

public function boolean of_isupdatepending ();
return dw_list.modifiedcount() > 0 or dw_list.deletedcount() > 0 or &
	dw_test.modifiedcount() > 0 or dw_test.deletedcount() > 0


end function

public function long of_refresh ();
long ll_rowcount
long ll_row

ib_refreshing = true
ll_rowcount = dw_list.retrieve()
if ll_rowcount = 0 then
	cb_new.event clicked()
else
	of_refresh_testuser()
end if

ll_row = dw_list.getrow()
if ll_row > 0 then
	dw_list.selectrow(0,false)
	dw_list.selectrow(ll_row,true)
	dw_form.event ue_gotorow(ll_row)
end if
ib_refreshing = false

return ll_rowcount

end function

public function long of_adduser (string as_userid, string as_firstname, string as_lastname);
long ll_row

ll_row = dw_test.insertrow(0)

if ll_row > 0 then
	dw_test.setitem(ll_row, "user_id", as_userid )
	dw_test.setitem(ll_row, "first_name", as_firstname)
	dw_test.setitem(ll_row, "last_name", as_lastname)
	
	dw_test.setrow(ll_row)
	dw_test.scrolltorow(ll_row)
	return 1
end if

return -1
end function

public function integer of_setkeyvalues ();
long ll_releaseid, ll_oldreleaseid
long ll_row, ll_rowcount

ll_row = dw_list.getrow()
if ll_row <= 0 then
	return -1
end if

ll_releaseid = dw_list.getitemnumber(ll_row, "release_id")

ll_row = dw_test.getnextmodified(0, primary!)

do while ( ll_row > 0)
	ll_oldreleaseid = dw_test.getitemnumber(ll_row, "release_id")
	if isnull(ll_oldreleaseid) then
		dw_test.setitem(ll_row, "release_id", ll_releaseid)
	elseif ll_releaseid <> ll_oldreleaseid then
		dw_test.setitem(ll_row, "release_id", ll_releaseid)
	end if
	ll_row = dw_test.getnextmodified(ll_row, primary!)
loop

return 1

end function

public function integer of_validate ();
datetime ldt1, ldt2
long ll_row

if dw_list.accepttext() <> 1 then
	return -1
end if

if dw_form.accepttext() <> 1 then
	return -1
end if

if dw_test.accepttext() <> 1 then
	return -1
end if

ll_row = dw_form.getrow()
if ll_row > 0 then
	ldt1 = dw_form.getitemdatetime(ll_row, "release_stdate")
	ldt2 = dw_form.getitemdatetime(ll_row, "release_endate")
	if not isnull(ldt1) and not isnull(ldt2) then
		if ldt1 >= ldt2 then
			messagebox("Validation", "The start time should be earlier than the end time")
			dw_form.setcolumn("release_stdate")
			dw_form.setfocus()
			return -1
		end if
	end if
end if

return 1


end function

on w_main.create
this.cb_public_report=create cb_public_report
this.cb_deluser=create cb_deluser
this.cb_add=create cb_add
this.dw_test=create dw_test
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_form=create dw_form
this.dw_list=create dw_list
this.gb_testusers=create gb_testusers
this.Control[]={this.cb_public_report,&
this.cb_deluser,&
this.cb_add,&
this.dw_test,&
this.cb_cancel,&
this.cb_update,&
this.cb_delete,&
this.cb_new,&
this.dw_form,&
this.dw_list,&
this.gb_testusers}
end on

on w_main.destroy
destroy(this.cb_public_report)
destroy(this.cb_deluser)
destroy(this.cb_add)
destroy(this.dw_test)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_form)
destroy(this.dw_list)
destroy(this.gb_testusers)
end on

event open;
this.backcolor = g_app.MT_FORMDETAIL_BG
gb_testusers.backcolor = g_app.MT_FORMDETAIL_BG

dw_list.settransobject(SQLCA)
dw_list.ShareData(dw_form)
dw_test.settransobject(SQLCA)

of_refresh()

this.title += ' [' + SQLCA.ServerName + ", " + SQLCA.Database + ']'

end event

type cb_public_report from commandbutton within w_main
integer x = 18
integer y = 1744
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Public Reprot"
end type

event clicked;open(w_public_report)
end event

type cb_deluser from commandbutton within w_main
integer x = 1536
integer y = 1584
integer width = 256
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Remove"
end type

event clicked;
long ll_row
string ls_userid, ls_firstname, ls_lastname

ll_row = dw_test.getrow()
if ll_row > 0 then
	ls_userid = dw_test.getitemstring(ll_row, "user_id")
	ls_firstname = dw_test.getitemstring(ll_row, "first_name")
	ls_lastname = dw_test.getitemstring(ll_row, "last_name")
	
	dw_test.deleterow(ll_row)
	ll_row = dw_test.getrow()
	if ll_row > 0 then
		dw_test.selectrow(0,false)
		dw_test.selectrow(ll_row, true)
	end if
	
	if isvalid(w_seluser) then
		w_seluser.of_adduser(ls_userid, ls_firstname, ls_lastname)
	end if
	
end if

end event

type cb_add from commandbutton within w_main
integer x = 1262
integer y = 1584
integer width = 256
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add"
end type

event clicked;
long ll_row, ll_rowcount
string ls_null

stru_seluparm s_seluinfo

if isvalid(w_seluser) then
	w_seluser.bringtotop = true
	return
end if

s_seluinfo.owner_window = parent
s_seluinfo.selectok = false

ll_rowcount = dw_test.rowcount()
if ll_rowcount <= 0 then
	setnull(ls_null)
	s_seluinfo.selected[1] = ls_null
else
	for ll_row = 1 to ll_rowcount
		s_seluinfo.selected[ll_row] = dw_test.getitemstring(ll_row, "user_id")
	next
end if

OpenWithParm (w_seluser, s_seluinfo, parent)

end event

type dw_test from datawindow within w_main
integer x = 768
integer y = 1104
integer width = 1019
integer height = 464
integer taborder = 30
string title = "none"
string dataobject = "d_testusers"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow, true)

end event

event clicked;if row > 0 then
	this.setrow(row)
end if

end event

type cb_cancel from commandbutton within w_main
integer x = 1509
integer y = 1744
integer width = 325
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event clicked;
parent.of_refresh()
end event

type cb_update from commandbutton within w_main
integer x = 1179
integer y = 1744
integer width = 325
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;
parent.of_update()
end event

type cb_delete from commandbutton within w_main
integer x = 850
integer y = 1744
integer width = 325
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;
long ll_row

ll_row = dw_list.getrow()
if ll_row > 0 then
	ib_deleting = true
	dw_list.DeleteRow(ll_row)
	ib_deleting = false
	ll_row = dw_list.getrow()
	if ll_row > 0 then
		dw_list.selectrow(0,false)
		dw_list.selectrow(ll_row,true)
		dw_form.event ue_gotorow(ll_row)
	end if
	
	of_refresh_testuser()
end if

end event

type cb_new from commandbutton within w_main
integer x = 521
integer y = 1744
integer width = 325
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New"
end type

event clicked;long ll_new

ll_new = dw_list.InsertRow(0)
if ll_new > 0 then
	dw_list.setrow(ll_new)
	dw_form.setfocus()
end if

end event

type dw_form from datawindow within w_main
event ue_vscroll pbm_vscroll
event ue_keydown pbm_keydown
event ue_gotorow ( long al_row )
integer x = 731
integer y = 16
integer width = 1262
integer height = 1008
integer taborder = 20
string dataobject = "d_release_form"
boolean border = false
end type

event ue_vscroll;return 1
end event

event ue_gotorow(long al_row);
if al_row > 1 and al_row <= this.rowcount() then
	ib_rowchanging = true
	this.scrolltorow(al_row)
	this.setrow(al_row)
	ib_rowchanging = false
end if


end event

event itemchanged;
choose case dwo.name
	case "release_stdate"
		setitem(row, "downtime", f_hoursafter( &
			datetime(blob(data)), &
			getitemdatetime(row, "release_endate")))
	case "release_endate"
		setitem(row, "downtime", f_hoursafter( &
			getitemdatetime(row, "release_stdate"), &
			datetime(blob(data))))
	case "isactive"
		if long(data) = 0 then
			setitem(row, "start_release", 0)
			setitem(row, "finish_release", 0)
		end if
	case "start_release"
		if long(data) = 0 then
			setitem(row, "finish_release", 0)
		end if
end choose

end event

event rowfocuschanging;if ib_refreshing then return
if ib_rowchanging then return
if ib_deleting then return
return 1
end event

type dw_list from datawindow within w_main
integer x = 37
integer y = 32
integer width = 658
integer height = 1680
integer taborder = 10
string title = "none"
string dataobject = "d_release_list"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)

if currentrow > 0 then
	
	of_refresh_testuser()
	
	dw_form.event ue_gotorow(currentrow)
end if

end event

event rowfocuschanging;
long ll_answer

if ib_refreshing then return
if ib_deleting then return

if of_validate() = -1 then return 1

if dw_test.modifiedcount()> 0 or dw_test.deletedcount() > 0 then
	ll_answer = messagebox("Confirm", "Save changed data?", Question!, yesnocancel!)
	if ll_answer = 1 then
		if of_update() = -1 then
			return 1
		end if
	elseif ll_answer = 3 then
		return 1
	end if
end if

end event

type gb_testusers from groupbox within w_main
integer x = 731
integer y = 1024
integer width = 1097
integer height = 688
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Test Users"
end type

