$PBExportHeader$w_note.srw
forward
global type w_note from window
end type
type cb_copy from commandbutton within w_note
end type
type cb_close from commandbutton within w_note
end type
type mle_note from multilineedit within w_note
end type
end forward

global type w_note from window
integer width = 2825
integer height = 1556
boolean titlebar = true
string title = "Guide Note"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_copy cb_copy
cb_close cb_close
mle_note mle_note
end type
global w_note w_note

on w_note.create
this.cb_copy=create cb_copy
this.cb_close=create cb_close
this.mle_note=create mle_note
this.Control[]={this.cb_copy,&
this.cb_close,&
this.mle_note}
end on

on w_note.destroy
destroy(this.cb_copy)
destroy(this.cb_close)
destroy(this.mle_note)
end on

event open;string ls_Note
Integer li_Type

Select NOTETYPE, NOTE_TEXT into :li_Type, :ls_Note from VETT_NOTES where NOTES_ID = :g_obj.Noteid;

If SQLCA.Sqlcode<>0 then 
	MessageBox("DB Error", "Could not retrive text from Database.~n~n" + Sqlca.Sqlerrtext,Exclamation!)
	Rollback;
Else
	Commit;
	Choose Case li_Type
		Case 1
			This.Title = "Guide Note"
		Case 2
			This.Title = "User Note"
	End Choose
	mle_note.Text = ls_Note
End If

end event

type cb_copy from commandbutton within w_note
integer x = 18
integer y = 1344
integer width = 201
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
mle_note.SelectText(1, Len(mle_note.Text))
mle_note.Copy( )
end event

type cb_close from commandbutton within w_note
integer x = 1170
integer y = 1360
integer width = 439
integer height = 96
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

type mle_note from multilineedit within w_note
integer x = 18
integer y = 16
integer width = 2761
integer height = 1328
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer tabstop[] = {0}
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

