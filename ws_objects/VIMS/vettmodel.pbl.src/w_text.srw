$PBExportHeader$w_text.srw
forward
global type w_text from window
end type
type st_title from statictext within w_text
end type
type st_2 from statictext within w_text
end type
type cb_refresh from commandbutton within w_text
end type
type sle_tag from singlelineedit within w_text
end type
type sle_text from singlelineedit within w_text
end type
type cb_imp from commandbutton within w_text
end type
type cb_1 from commandbutton within w_text
end type
type cb_cancel from commandbutton within w_text
end type
type cb_ok from commandbutton within w_text
end type
type cb_add from commandbutton within w_text
end type
type cb_clear from commandbutton within w_text
end type
type cb_find from commandbutton within w_text
end type
type dw_text from datawindow within w_text
end type
type st_1 from statictext within w_text
end type
type gb_1 from groupbox within w_text
end type
end forward

global type w_text from window
integer width = 3113
integer height = 1864
boolean titlebar = true
string title = "Text Linker"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_title st_title
st_2 st_2
cb_refresh cb_refresh
sle_tag sle_tag
sle_text sle_text
cb_imp cb_imp
cb_1 cb_1
cb_cancel cb_cancel
cb_ok cb_ok
cb_add cb_add
cb_clear cb_clear
cb_find cb_find
dw_text dw_text
st_1 st_1
gb_1 gb_1
end type
global w_text w_text

type variables

end variables

on w_text.create
this.st_title=create st_title
this.st_2=create st_2
this.cb_refresh=create cb_refresh
this.sle_tag=create sle_tag
this.sle_text=create sle_text
this.cb_imp=create cb_imp
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_add=create cb_add
this.cb_clear=create cb_clear
this.cb_find=create cb_find
this.dw_text=create dw_text
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_title,&
this.st_2,&
this.cb_refresh,&
this.sle_tag,&
this.sle_text,&
this.cb_imp,&
this.cb_1,&
this.cb_cancel,&
this.cb_ok,&
this.cb_add,&
this.cb_clear,&
this.cb_find,&
this.dw_text,&
this.st_1,&
this.gb_1}
end on

on w_text.destroy
destroy(this.st_title)
destroy(this.st_2)
destroy(this.cb_refresh)
destroy(this.sle_tag)
destroy(this.sle_text)
destroy(this.cb_imp)
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_add)
destroy(this.cb_clear)
destroy(this.cb_find)
destroy(this.dw_text)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Long ll_Sel

SetPointer(HourGlass!)
dw_text.SetTransObject(SQLCA)
dw_text.Retrieve(g_obj.ObjType)

sle_tag.Text = gs_tag

Choose Case g_obj.ObjType
	Case 1
		St_Title.Text = "Chapter"		
	Case 2
		St_Title.Text = "Section"
	Case 3
		St_Title.Text = "Question"
	Case 4
		St_Title.Text = "Sub-Question"
End Choose
		
ll_Sel = dw_text.Find( "Text_ID = " + String(g_Obj.noteid) , 1, dw_Text.RowCount())

If ll_Sel > 0 then
	dw_text.SetRow(ll_Sel)
	dw_text.ScrollTorow(ll_Sel)
End If
end event

event close;
gs_tag = trim(sle_tag.Text)
end event

type st_title from statictext within w_text
integer x = 457
integer y = 112
integer width = 1189
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Chapter"
boolean focusrectangle = false
end type

type st_2 from statictext within w_text
integer x = 2231
integer y = 128
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tag:"
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_text
integer x = 2688
integer y = 112
integer width = 311
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Filter"
end type

event clicked;
sle_Tag.Text = Trim(sle_Tag.Text)

If sle_Tag.Text > "" then
	dw_text.SetFilter( "Tag like '" + sle_Tag.Text + "%'")
else
	dw_text.SetFilter("")
End If

dw_text.Filter()
end event

type sle_tag from singlelineedit within w_text
integer x = 2377
integer y = 112
integer width = 293
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 5
borderstyle borderstyle = stylelowered!
end type

type sle_text from singlelineedit within w_text
integer x = 73
integer y = 1424
integer width = 2944
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_imp from commandbutton within w_text
integer x = 2176
integer y = 1248
integer width = 603
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Import from List"
end type

event clicked;integer li_imp, li_level

Messagebox ("Information", "Note: All imported text will get the specfied tag.")

SetPointer(HourGlass!)
li_imp = dw_text.ImportFile(Text!,"")

if li_imp < 0 then 
	MessageBox("Error", "Nothing imported. Error: " + String(li_imp))
	Return
Else
	If li_imp = 0 then
		MessageBox("No Text", "Zero rows were imported.")
		Return
	Else
		For li_imp = 1 to dw_Text.RowCount()
			If isnull(dw_Text.GetItemNumber(li_imp, "texttype")) then 
				dw_Text.SetItem(li_imp, "texttype", g_obj.objtype)
				dw_Text.SetItem(li_imp, "Tag", Trim(sle_Tag.Text))
			End If
		Next
		li_imp = dw_Text.Update( )
		if li_imp <> 1 then
			Rollback;
			MessageBox("Error","Update failed.")
			dw_text.Retrieve(g_obj.objtype)
		Else
			Commit;
		End If
	End If
End If
end event

type cb_1 from commandbutton within w_text
integer x = 2779
integer y = 1248
integer width = 233
integer height = 96
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
If MessageBox("Confirm Delete", "The selected text will be deleted. Are you sure you want to do this?",Question!,YesNo!)=2 then Return

SetPointer(HourGlass!)
dw_text.DeleteRow( dw_text.GetRow())

If dw_text.Update() = 1 then
	MessageBox ("Deleted", "The selected text was deleted.")
	Commit;
Else
	MessageBox ("Delete Error", "The selected note could not be deleted.",Exclamation!)
	Rollback;
End If
end event

type cb_cancel from commandbutton within w_text
integer x = 2030
integer y = 1664
integer width = 402
integer height = 96
integer taborder = 90
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

type cb_ok from commandbutton within w_text
integer x = 805
integer y = 1664
integer width = 402
integer height = 96
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
end type

event clicked;
if dw_text.Rowcount( ) = 0 then
	MessageBox("No Selection", "Please import or add text and then select the text", Exclamation!)
	Return
End If

SetPointer(HourGlass!)
g_obj.ObjParent = dw_text.GetItemString(dw_text.GetRow(), "TEXTDATA")
g_obj.noteid = dw_text.GetItemNumber( dw_text.GetRow(), "TEXT_ID")

Close(Parent)
end event

type cb_add from commandbutton within w_text
integer x = 2578
integer y = 1504
integer width = 439
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add to List"
end type

event clicked;long ll_newrow

sle_text.Text = Trim(sle_text.Text)

if sle_text.Text = "" then 
	MessageBox ("Add Error", "Please enter the text to add.", Exclamation!)
	Return
End If

If MessageBox("Confirm Add", "Are you sure you want to add this text (with specified tag)?",Question!,YesNo!) = 2 then Return

SetPointer(HourGlass!)
ll_newrow = dw_text.Insertrow(0)

dw_text.SetItem(ll_newrow, "TEXTDATA", sle_text.Text)
dw_text.SetItem(ll_newrow, "TEXTTYPE", g_obj.objtype)
dw_text.SetItem(ll_newrow, "TAG", Trim(sle_Tag.Text))

dw_text.SetRow(ll_newrow)
dw_text.ScrollToRow(ll_newrow)

ll_newrow = dw_text.Update()

If ll_newrow<>1 then 
	Rollback;
	MessageBox("Update Error", "Could not update database.", Exclamation!)
	Return
Else
	Commit;
	sle_text.Text = ""
End If

end event

type cb_clear from commandbutton within w_text
integer x = 567
integer y = 1504
integer width = 457
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
sle_text.Text = ""


end event

type cb_find from commandbutton within w_text
integer x = 73
integer y = 1504
integer width = 494
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

event clicked;Integer li_Found

sle_text.Text = Trim(sle_text.Text)

li_Found = dw_text.Find("textdata like '%" + sle_text.Text + "%'", 1, dw_text.RowCount())

If li_Found = 0 then 
	MessageBox ("Nothing Found", "No text could be found matching the criteria")
	Return
End If

If li_Found < 0 then
	MessageBox ("Error", "Search Error: " + String(li_Found))
End If

dw_text.SetRow( li_Found)
dw_text.ScrollTorow( li_Found)
end event

type dw_text from datawindow within w_text
integer x = 73
integer y = 192
integer width = 2944
integer height = 1056
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_textlist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_text
integer x = 73
integer y = 112
integer width = 384
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type of Text:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_text
integer x = 37
integer y = 32
integer width = 3035
integer height = 1600
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

