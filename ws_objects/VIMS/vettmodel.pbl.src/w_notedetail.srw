$PBExportHeader$w_notedetail.srw
forward
global type w_notedetail from window
end type
type cb_next from commandbutton within w_notedetail
end type
type cb_prev from commandbutton within w_notedetail
end type
type cb_get from commandbutton within w_notedetail
end type
type st_1 from statictext within w_notedetail
end type
type sle_noteid from singlelineedit within w_notedetail
end type
type dw_dup from datawindow within w_notedetail
end type
type dw_links from datawindow within w_notedetail
end type
type cb_close from commandbutton within w_notedetail
end type
type cb_del from commandbutton within w_notedetail
end type
type cb_switch from commandbutton within w_notedetail
end type
type mle_note from multilineedit within w_notedetail
end type
type gb_1 from groupbox within w_notedetail
end type
type gb_2 from groupbox within w_notedetail
end type
type gb_3 from groupbox within w_notedetail
end type
end forward

global type w_notedetail from window
integer width = 2994
integer height = 2136
boolean titlebar = true
string title = "Note Details"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_next cb_next
cb_prev cb_prev
cb_get cb_get
st_1 st_1
sle_noteid sle_noteid
dw_dup dw_dup
dw_links dw_links
cb_close cb_close
cb_del cb_del
cb_switch cb_switch
mle_note mle_note
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_notedetail w_notedetail

type variables

Long il_NoteID
end variables

forward prototypes
public subroutine wf_retrieve (string as_noteid)
end prototypes

public subroutine wf_retrieve (string as_noteid);String ls_SQL, ls_Text

il_NoteID = Long(as_NoteID)

Select NOTE_TEXT into :ls_Text from VETT_NOTES Where NOTES_ID = :il_NoteID;

If SQLCA.SQLCode<0 then Messagebox("SQL Error", SQLCA.SqlErrtext, Exclamation!)

If SQLCA.SQLCode<>0 then
	Rollback;
	mle_Note.Text = ""
	dw_dup.Reset( )
	dw_Links.Reset( )
	cb_switch.Enabled = False
	cb_del.Enabled = False	
	Return
End If

Commit; 

mle_Note.Text = ls_Text

dw_Links.Retrieve(il_NoteID)
dw_Dup.Retrieve(ls_Text, il_NoteID)
end subroutine

on w_notedetail.create
this.cb_next=create cb_next
this.cb_prev=create cb_prev
this.cb_get=create cb_get
this.st_1=create st_1
this.sle_noteid=create sle_noteid
this.dw_dup=create dw_dup
this.dw_links=create dw_links
this.cb_close=create cb_close
this.cb_del=create cb_del
this.cb_switch=create cb_switch
this.mle_note=create mle_note
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.cb_next,&
this.cb_prev,&
this.cb_get,&
this.st_1,&
this.sle_noteid,&
this.dw_dup,&
this.dw_links,&
this.cb_close,&
this.cb_del,&
this.cb_switch,&
this.mle_note,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_notedetail.destroy
destroy(this.cb_next)
destroy(this.cb_prev)
destroy(this.cb_get)
destroy(this.st_1)
destroy(this.sle_noteid)
destroy(this.dw_dup)
destroy(this.dw_links)
destroy(this.cb_close)
destroy(this.cb_del)
destroy(this.cb_switch)
destroy(this.mle_note)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;
dw_links.SetTransObject(SQLCA)
dw_Dup.SetTransObject(SQLCA)

sle_NoteID.Text = String(g_Obj.NoteID)

wf_Retrieve(sle_NoteID.Text)



end event

type cb_next from commandbutton within w_notedetail
integer x = 2834
integer width = 91
integer height = 64
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = ">"
end type

event clicked;
setpointer(HourGlass!)

il_noteid ++

sle_NoteID.Text = String(il_NoteID)

wf_Retrieve(String(il_NoteID))
end event

type cb_prev from commandbutton within w_notedetail
integer x = 2743
integer width = 91
integer height = 64
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "<"
end type

event clicked;
setpointer(HourGlass!)
If il_noteid>1 then il_noteid --

sle_NoteID.Text = String(il_NoteID)

wf_Retrieve(String(il_NoteID))
end event

type cb_get from commandbutton within w_notedetail
integer x = 2651
integer width = 91
integer height = 64
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "#"
end type

event clicked;
setpointer(HourGlass!)

sle_NoteID.Text = Trim(sle_NoteID.Text, True)

If IsNumber(sle_NoteID.Text) then
	wf_Retrieve(sle_NoteID.Text)
Else
	Messagebox("Invalid ID", "Not a number!", Exclamation!)
End If
end event

type st_1 from statictext within w_notedetail
integer x = 2377
integer width = 73
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "ID:"
boolean focusrectangle = false
end type

type sle_noteid from singlelineedit within w_notedetail
integer x = 2450
integer width = 201
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type dw_dup from datawindow within w_notedetail
integer x = 55
integer y = 1344
integer width = 2871
integer height = 464
integer taborder = 60
string title = "none"
string dataobject = "d_sq_tb_dupnotes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;

cb_Switch.enabled = (rowcount>0)
cb_del.Enabled = (rowcount>0)

end event

type dw_links from datawindow within w_notedetail
integer x = 55
integer y = 704
integer width = 2871
integer height = 528
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_objlinked"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_notedetail
integer x = 1262
integer y = 1936
integer width = 439
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type cb_del from commandbutton within w_notedetail
integer x = 2597
integer y = 1808
integer width = 329
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Eliminate"
end type

event clicked;
//If Messagebox("Confirm", "Are you sure you want to re-link objects and delete duplicate notes?",Question!,YesNo!)=2 then Return

SetPointer(HourGlass!)

Integer li_Count
Long li_OldNoteID

For li_Count = 1 to dw_Dup.RowCount()
	li_OldNoteID = dw_Dup.GetItemNumber(li_Count, "Notes_ID")
	
	Update VETT_OBJ Set OBJNOTE = :il_NoteID Where OBJNOTE = :li_OldNoteID;
	
	If SQLCA.SQLCode < 0 then
		Messagebox("SQL Error", SQLCA.SQLErrText, Exclamation!)
		Rollback;
		Return
	End If
	
	Delete from VETT_NOTES Where NOTES_ID = :li_OldNoteID;

	If SQLCA.SQLCode < 0 then
		Messagebox("SQL Error", SQLCA.SQLErrText, Exclamation!)
		Rollback;
		Return
	End If
Next

Commit;

wf_Retrieve(String(il_NoteID))
end event

type cb_switch from commandbutton within w_notedetail
integer x = 55
integer y = 1808
integer width = 329
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Switch"
end type

event clicked;
Long ll_NoteID

ll_NoteID = dw_Dup.GetItemNumber(dw_Dup.GetRow(), "Notes_ID")

sle_NoteID.Text = String(ll_NoteID)

wf_Retrieve(sle_NoteID.Text)

end event

type mle_note from multilineedit within w_notedetail
integer x = 55
integer y = 80
integer width = 2871
integer height = 448
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_notedetail
integer x = 18
integer width = 2944
integer height = 624
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note Text"
end type

type gb_2 from groupbox within w_notedetail
integer x = 18
integer y = 640
integer width = 2944
integer height = 624
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linked From"
end type

type gb_3 from groupbox within w_notedetail
integer x = 18
integer y = 1280
integer width = 2944
integer height = 624
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Duplicates"
end type

