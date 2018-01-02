$PBExportHeader$w_guidenotes.srw
forward
global type w_guidenotes from window
end type
type cb_detail from commandbutton within w_guidenotes
end type
type cb_edit from commandbutton within w_guidenotes
end type
type st_2 from statictext within w_guidenotes
end type
type cb_modify from commandbutton within w_guidenotes
end type
type cb_del from commandbutton within w_guidenotes
end type
type cb_cancel from commandbutton within w_guidenotes
end type
type cb_ok from commandbutton within w_guidenotes
end type
type cb_add from commandbutton within w_guidenotes
end type
type cb_clear from commandbutton within w_guidenotes
end type
type cb_find from commandbutton within w_guidenotes
end type
type mle_note from multilineedit within w_guidenotes
end type
type dw_notes from datawindow within w_guidenotes
end type
type st_1 from statictext within w_guidenotes
end type
type gb_1 from groupbox within w_guidenotes
end type
end forward

global type w_guidenotes from window
integer width = 3113
integer height = 2200
boolean titlebar = true
string title = "Guidance Notes"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_detail cb_detail
cb_edit cb_edit
st_2 st_2
cb_modify cb_modify
cb_del cb_del
cb_cancel cb_cancel
cb_ok cb_ok
cb_add cb_add
cb_clear cb_clear
cb_find cb_find
mle_note mle_note
dw_notes dw_notes
st_1 st_1
gb_1 gb_1
end type
global w_guidenotes w_guidenotes

on w_guidenotes.create
this.cb_detail=create cb_detail
this.cb_edit=create cb_edit
this.st_2=create st_2
this.cb_modify=create cb_modify
this.cb_del=create cb_del
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_add=create cb_add
this.cb_clear=create cb_clear
this.cb_find=create cb_find
this.mle_note=create mle_note
this.dw_notes=create dw_notes
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_detail,&
this.cb_edit,&
this.st_2,&
this.cb_modify,&
this.cb_del,&
this.cb_cancel,&
this.cb_ok,&
this.cb_add,&
this.cb_clear,&
this.cb_find,&
this.mle_note,&
this.dw_notes,&
this.st_1,&
this.gb_1}
end on

on w_guidenotes.destroy
destroy(this.cb_detail)
destroy(this.cb_edit)
destroy(this.st_2)
destroy(this.cb_modify)
destroy(this.cb_del)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_add)
destroy(this.cb_clear)
destroy(this.cb_find)
destroy(this.mle_note)
destroy(this.dw_notes)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Integer ll_Sel

dw_notes.SetTransObject(SQLCA)
dw_notes.Retrieve(g_obj.ObjType)

If g_obj.objtype = 2 then This.Title = "User Notes"
If g_obj.objtype = 3 then 
	This.Title = "Standard Replies"
	st_1.Text = "Standard Reply List"
End If

ll_Sel = dw_Notes.Find( "Notes_ID = " + String(g_Obj.NoteID) , 1, dw_Notes.RowCount())

If ll_Sel > 0 then
	dw_Notes.SetRow(ll_Sel)
	dw_Notes.ScrollTorow(ll_Sel)
End If
end event

type cb_detail from commandbutton within w_guidenotes
integer x = 2085
integer y = 1120
integer width = 475
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Note Details"
end type

event clicked;
If g_Obj.ObjType > 1 then 
	Messagebox("Invalid Type", "Note Details valid only for Guidance Notes")
	Return 
End If

g_Obj.Noteid = dw_Notes.GetItemNumber(dw_Notes.GetRow(), "Notes_ID")
g_Obj.ObjString = dw_Notes.GetItemString(dw_Notes.GetRow(), "Note_Text")

Open(w_NoteDetail)
end event

type cb_edit from commandbutton within w_guidenotes
integer x = 73
integer y = 1120
integer width = 480
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Edit Selection"
end type

event clicked;If dw_notes.GetRow() <= 0 then
	MessageBox("Error", "Nothing to edit!", Exclamation!)
	Return
End If

mle_note.Text = dw_notes.GetItemString(dw_notes.GetRow(), "NOTE_TEXT")

end event

type st_2 from statictext within w_guidenotes
integer x = 73
integer y = 1280
integer width = 1079
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Text Content:"
boolean focusrectangle = false
end type

type cb_modify from commandbutton within w_guidenotes
integer x = 549
integer y = 1120
integer width = 475
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Modify Selection"
end type

event clicked;
If dw_notes.GetRow() <= 0 then 
	MessageBox("Error", "Nothing to modify!", Exclamation!)
	Return
End If

If MessageBox("Confirm Modify", "Any modification will affect all entities from all Inspection Models that refer to this text.~n~nAre you sure you want to continue?", Question!, YesNo!) = 2 then Return

mle_note.Text = Trim(mle_note.Text)

If Len(mle_note.Text) < 3 then 
	MessageBox("Error", "Please enter valid text content to modify with.",Exclamation!)
	Return
End If

dw_notes.SetItem(dw_notes.GetRow(), "note_text", mle_note.Text)

If dw_notes.Update() = 1 then 
	Commit;
	MessageBox("Information", "The modification was saved successfully.")
Else
	Rollback;
	MessageBox("DB Error", "The modification could not be saved.", Exclamation!)
End If

end event

type cb_del from commandbutton within w_guidenotes
integer x = 2560
integer y = 1120
integer width = 480
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Note"
end type

event clicked;If dw_notes.GetRow() <= 0 then
	MessageBox("Error", "Nothing to delete!", Exclamation!)
	Return
End If

If MessageBox("Confirm Delete", "The selected note will be deleted and removed from all questions that refer to it.~n~nAre you sure you want to do this?",Question!,YesNo!)=2 then Return

SetPointer(HourGlass!)
dw_notes.DeleteRow( dw_Notes.GetRow())

If dw_notes.Update() = 1 then
	Commit;
	MessageBox ("Deleted", "The selected note was deleted.")
Else
	Rollback;
	MessageBox ("Delete Error", "The selected note could not be deleted.",Exclamation!)
End If
end event

type cb_cancel from commandbutton within w_guidenotes
integer x = 1920
integer y = 2000
integer width = 402
integer height = 96
integer taborder = 80
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
g_obj.Noteid = -1

Close(Parent)
end event

type cb_ok from commandbutton within w_guidenotes
integer x = 786
integer y = 2000
integer width = 402
integer height = 96
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
end type

event clicked;
if dw_notes.Rowcount( ) = 0 then
	MessageBox("No Selection", "Please select a guide note to attach.", Exclamation!)
	Return
End If

g_obj.ObjParent = dw_notes.GetItemString(dw_notes.GetRow(), "NOTE_TEXT")
g_obj.Noteid = dw_notes.GetItemNumber( dw_notes.GetRow(), "NOTES_ID")

Close(Parent)
end event

type cb_add from commandbutton within w_guidenotes
integer x = 73
integer y = 1872
integer width = 475
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add Note to List"
end type

event clicked;long ll_newrow

If MessageBox("Confirm Add", "Are you sure you want to add this note?",Question!,YesNo!) = 2 then Return

mle_note.Text = Trim(mle_note.Text)

if mle_Note.Text = "" then 
	MessageBox ("Add Error", "Please enter the note to add.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

dw_notes.SetFilter("")
dw_notes.Filter( )

ll_newrow = dw_Notes.Insertrow( 0)

dw_notes.SetItem(ll_newrow, "NOTE_TEXT", mle_note.Text)
dw_notes.SetItem(ll_newrow, "NOTETYPE", g_obj.objtype)

dw_notes.ScrollToRow(ll_newrow)
dw_notes.SetRow(ll_newrow)

ll_newrow = dw_notes.Update()

if ll_newrow<>1 then 
	Rollback;
	MessageBox("Update Error", "Could not update database.", Exclamation!)
	ll_newrow = dw_notes.Retrieve(g_obj.objtype)
	mle_note.Text = ""
	Return
Else
	Commit;
	mle_note.Text = ""
End If

end event

type cb_clear from commandbutton within w_guidenotes
integer x = 2560
integer y = 1872
integer width = 475
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear Search"
end type

event clicked;
mle_note.Text = ""
dw_notes.SetFilter("")
dw_notes.Filter()
end event

type cb_find from commandbutton within w_guidenotes
integer x = 2085
integer y = 1872
integer width = 475
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search in List"
end type

event clicked;SetPointer(HourGlass!)
mle_note.Text = Trim(mle_note.Text)

If mle_note.Text > "" then
	dw_notes.SetFilter( "upper(note_text) like '%" + upper(mle_note.Text) + "%'" )
	dw_notes.Filter( )
else
	dw_notes.SetFilter("")
	dw_notes.Filter()
End If
end event

type mle_note from multilineedit within w_guidenotes
integer x = 73
integer y = 1344
integer width = 2962
integer height = 528
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 5000
borderstyle borderstyle = stylelowered!
end type

type dw_notes from datawindow within w_guidenotes
integer x = 73
integer y = 144
integer width = 2962
integer height = 976
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_guidenotes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_guidenotes
integer x = 91
integer y = 80
integer width = 530
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Master Note List:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_guidenotes
integer x = 37
integer y = 32
integer width = 3035
integer height = 1952
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

