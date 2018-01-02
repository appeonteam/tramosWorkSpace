$PBExportHeader$w_userdetail.srw
forward
global type w_userdetail from window
end type
type cb_cancel from commandbutton within w_userdetail
end type
type cb_ok from commandbutton within w_userdetail
end type
type dp_start from datepicker within w_userdetail
end type
type em_work from editmask within w_userdetail
end type
type st_name from statictext within w_userdetail
end type
type st_3 from statictext within w_userdetail
end type
type st_2 from statictext within w_userdetail
end type
type st_1 from statictext within w_userdetail
end type
type gb_1 from groupbox within w_userdetail
end type
end forward

global type w_userdetail from window
integer width = 1760
integer height = 768
boolean titlebar = true
string title = "User Details"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
dp_start dp_start
em_work em_work
st_name st_name
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_userdetail w_userdetail

on w_userdetail.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dp_start=create dp_start
this.em_work=create em_work
this.st_name=create st_name
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.dp_start,&
this.em_work,&
this.st_name,&
this.st_3,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_userdetail.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dp_start)
destroy(this.em_work)
destroy(this.st_name)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
st_Name.Text = g_obj.Objstring

If g_obj.noteid > 10 then em_work.Text = String(g_obj.noteid)

If g_obj.Sql > "" then 
	dp_start.Value = DateTime(Date(g_obj.sql))
Else
	dp_start.Value = DateTime(Today())
End If

end event

type cb_cancel from commandbutton within w_userdetail
integer x = 1006
integer y = 560
integer width = 402
integer height = 96
integer taborder = 50
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
g_obj.noteid = 0

Close(Parent)
end event

type cb_ok from commandbutton within w_userdetail
integer x = 311
integer y = 560
integer width = 402
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
boolean default = true
end type

event clicked;
g_obj.Noteid = Integer(em_work.Text)

If g_obj.Noteid < 10 or g_obj.Noteid > 300 then
	MessageBox("Invalid Value", "Number of working days must be between 10 and 300 days inclusive.", Exclamation!)
	em_work.SetFocus( )
	Return
End If

g_obj.sql = String(dp_start.Value, "yyyy-mm-dd")

Close(Parent)
end event

type dp_start from datepicker within w_userdetail
integer x = 585
integer y = 384
integer width = 494
integer height = 96
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2008-01-04"), Time("17:15:57.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
end type

type em_work from editmask within w_userdetail
integer x = 585
integer y = 256
integer width = 274
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "180"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean spin = true
string minmax = "100~~300"
end type

type st_name from statictext within w_userdetail
integer x = 585
integer y = 144
integer width = 1115
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_3 from statictext within w_userdetail
integer x = 73
integer y = 400
integer width = 347
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start Date:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_userdetail
integer x = 73
integer y = 272
integer width = 494
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "No. of Work Days:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_userdetail
integer x = 73
integer y = 144
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Full Name:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_userdetail
integer x = 18
integer y = 16
integer width = 1701
integer height = 512
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

