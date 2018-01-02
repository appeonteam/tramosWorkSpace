$PBExportHeader$w_mobilever.srw
forward
global type w_mobilever from window
end type
type cb_cancel from commandbutton within w_mobilever
end type
type cb_ok from commandbutton within w_mobilever
end type
type hsb_db from hscrollbar within w_mobilever
end type
type cb_cleardb from commandbutton within w_mobilever
end type
type cb_clearver from commandbutton within w_mobilever
end type
type st_db from statictext within w_mobilever
end type
type st_2 from statictext within w_mobilever
end type
type sle_ver from singlelineedit within w_mobilever
end type
type st_1 from statictext within w_mobilever
end type
type st_id from statictext within w_mobilever
end type
type st_name from statictext within w_mobilever
end type
type gb_1 from groupbox within w_mobilever
end type
end forward

global type w_mobilever from window
integer width = 1431
integer height = 720
boolean titlebar = true
string title = "VIMS Mobile / Database Version"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
hsb_db hsb_db
cb_cleardb cb_cleardb
cb_clearver cb_clearver
st_db st_db
st_2 st_2
sle_ver sle_ver
st_1 st_1
st_id st_id
st_name st_name
gb_1 gb_1
end type
global w_mobilever w_mobilever

type variables

Integer ii_DBVer
String is_Mobile
end variables

on w_mobilever.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.hsb_db=create hsb_db
this.cb_cleardb=create cb_cleardb
this.cb_clearver=create cb_clearver
this.st_db=create st_db
this.st_2=create st_2
this.sle_ver=create sle_ver
this.st_1=create st_1
this.st_id=create st_id
this.st_name=create st_name
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.hsb_db,&
this.cb_cleardb,&
this.cb_clearver,&
this.st_db,&
this.st_2,&
this.sle_ver,&
this.st_1,&
this.st_id,&
this.st_name,&
this.gb_1}
end on

on w_mobilever.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.hsb_db)
destroy(this.cb_cleardb)
destroy(this.cb_clearver)
destroy(this.st_db)
destroy(this.st_2)
destroy(this.sle_ver)
destroy(this.st_1)
destroy(this.st_id)
destroy(this.st_name)
destroy(this.gb_1)
end on

event open;
If g_obj.Level = 0 then
	st_name.Text = "Vessel IMO:"
	st_ID.Text = String(g_Obj.VesselIMO)
Else
	st_name.Text = "User ID:"
	st_ID.Text = g_Obj.ObjParent
End If

sle_ver.Text = g_obj.Sql
st_db.Text = String(g_Obj.ObjID)
end event

type cb_cancel from commandbutton within w_mobilever
integer x = 805
integer y = 512
integer width = 402
integer height = 96
integer taborder = 60
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
g_obj.Objid = -1

Close(Parent)
end event

type cb_ok from commandbutton within w_mobilever
integer x = 201
integer y = 512
integer width = 402
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
boolean default = true
end type

event clicked;
g_obj.sql = Trim(sle_ver.Text,True)

If st_DB.Text = "" then SetNull(g_obj.ObjID) Else g_Obj.ObjID = Integer(st_DB.Text)

Close(Parent)

end event

type hsb_db from hscrollbar within w_mobilever
integer x = 859
integer y = 352
integer width = 110
integer height = 80
end type

event lineleft;Integer li_DB

li_DB = Integer(st_DB.Text)

if li_DB > 0 then li_DB --

If IsNull(li_DB) then li_DB = 0

st_DB.Text = String(li_DB)
end event

event lineright;Integer li_DB

li_DB = Integer(st_DB.Text)

If li_DB < 99 then li_DB ++

If IsNull(li_DB) then li_DB = 0

st_DB.Text = String(li_DB)
end event

type cb_cleardb from commandbutton within w_mobilever
integer x = 1006
integer y = 352
integer width = 183
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;
st_db.Text = ""
end event

type cb_clearver from commandbutton within w_mobilever
integer x = 1006
integer y = 240
integer width = 183
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;
sle_ver.Text = ""
end event

type st_db from statictext within w_mobilever
integer x = 731
integer y = 352
integer width = 128
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_mobilever
integer x = 73
integer y = 368
integer width = 512
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database Issue:"
boolean focusrectangle = false
end type

type sle_ver from singlelineedit within w_mobilever
integer x = 731
integer y = 240
integer width = 274
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "0.0.0"
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_mobilever
integer x = 73
integer y = 256
integer width = 640
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VIMS Mobile Version:"
boolean focusrectangle = false
end type

type st_id from statictext within w_mobilever
integer x = 731
integer y = 80
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_name from statictext within w_mobilever
integer x = 73
integer y = 80
integer width = 366
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel IMO:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_mobilever
integer x = 18
integer width = 1390
integer height = 480
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

