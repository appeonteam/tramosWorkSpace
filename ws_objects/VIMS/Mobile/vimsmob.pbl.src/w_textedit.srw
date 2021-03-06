﻿$PBExportHeader$w_textedit.srw
forward
global type w_textedit from window
end type
type cb_cancel from commandbutton within w_textedit
end type
type cb_ok from commandbutton within w_textedit
end type
type mle_text from multilineedit within w_textedit
end type
end forward

global type w_textedit from window
integer width = 2574
integer height = 1780
boolean titlebar = true
string title = "Text Editor"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
mle_text mle_text
end type
global w_textedit w_textedit

on w_textedit.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.mle_text=create mle_text
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.mle_text}
end on

on w_textedit.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.mle_text)
end on

event open;
f_Write2Log("w_TextEdit Open; Mode: " + String(g_Obj.Level))

mle_text.Text = Trim(g_Obj.ParamString, True)

mle_text.Selecttext(Len(mle_text.Text)+1, 0)

If g_Obj.Level = 0 then 
	mle_text.Displayonly = True
	cb_ok.Visible = False
	cb_cancel.Text = "Close"
	cb_cancel.x = 1045
	This.Title = "Text View"
	mle_text.Backcolor = 67108864
End If
end event

type cb_cancel from commandbutton within w_textedit
integer x = 1499
integer y = 1584
integer width = 475
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
SetNull(g_Obj.ParamString)

f_Write2Log("w_TextEdit Cancel")

Close(Parent)
end event

type cb_ok from commandbutton within w_textedit
integer x = 530
integer y = 1584
integer width = 475
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Accept"
end type

event clicked;
g_Obj.ParamString = Trim(mle_text.text, True)
f_Write2Log("w_TextEdit Accept")
Close(Parent)
end event

type mle_text from multilineedit within w_textedit
integer x = 18
integer y = 16
integer width = 2523
integer height = 1552
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

