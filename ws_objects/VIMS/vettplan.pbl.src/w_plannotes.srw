$PBExportHeader$w_plannotes.srw
forward
global type w_plannotes from window
end type
type st_text from statictext within w_plannotes
end type
type cb_close from commandbutton within w_plannotes
end type
type st_title from statictext within w_plannotes
end type
type st_lbl2 from statictext within w_plannotes
end type
type st_lbl1 from statictext within w_plannotes
end type
type gb_1 from groupbox within w_plannotes
end type
end forward

global type w_plannotes from window
integer width = 2126
integer height = 1340
boolean titlebar = true
string title = "Notes"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_text st_text
cb_close cb_close
st_title st_title
st_lbl2 st_lbl2
st_lbl1 st_lbl1
gb_1 gb_1
end type
global w_plannotes w_plannotes

on w_plannotes.create
this.st_text=create st_text
this.cb_close=create cb_close
this.st_title=create st_title
this.st_lbl2=create st_lbl2
this.st_lbl1=create st_lbl1
this.gb_1=create gb_1
this.Control[]={this.st_text,&
this.cb_close,&
this.st_title,&
this.st_lbl2,&
this.st_lbl1,&
this.gb_1}
end on

on w_plannotes.destroy
destroy(this.st_text)
destroy(this.cb_close)
destroy(this.st_title)
destroy(this.st_lbl2)
destroy(this.st_lbl1)
destroy(this.gb_1)
end on

event open;
If g_Obj.Level = 0 then
	This.Title = "Rejection Details"
	st_Title.TextColor = 255   //Red color
Else
	This.Title = "Requirement Details"
	st_Lbl1.Text = "Requirements:"
End If

st_Title.Text = g_Obj.ObjString
st_Text.Text = g_Obj.SQL
end event

type st_text from statictext within w_plannotes
integer x = 55
integer y = 240
integer width = 1993
integer height = 816
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = true
borderstyle borderstyle = StyleLowered!
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_plannotes
integer x = 841
integer y = 1120
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type st_title from statictext within w_plannotes
integer x = 475
integer y = 64
integer width = 1591
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_lbl2 from statictext within w_plannotes
integer x = 55
integer y = 160
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Details:"
boolean focusrectangle = false
end type

type st_lbl1 from statictext within w_plannotes
integer x = 55
integer y = 64
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rejected by: "
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_plannotes
integer x = 18
integer width = 2066
integer height = 1088
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
end type

