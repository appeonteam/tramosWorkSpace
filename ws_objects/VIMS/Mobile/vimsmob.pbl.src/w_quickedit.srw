$PBExportHeader$w_quickedit.srw
forward
global type w_quickedit from window
end type
type pb_down from picturebutton within w_quickedit
end type
type pb_up from picturebutton within w_quickedit
end type
type st_4 from statictext within w_quickedit
end type
type rb_roviq from radiobutton within w_quickedit
end type
type rb_normal from radiobutton within w_quickedit
end type
type st_sort from statictext within w_quickedit
end type
type st_2 from statictext within w_quickedit
end type
type sle_num from singlelineedit within w_quickedit
end type
type cb_cancel from commandbutton within w_quickedit
end type
type cb_ok from commandbutton within w_quickedit
end type
type dw_items from datawindow within w_quickedit
end type
type st_1 from statictext within w_quickedit
end type
end forward

global type w_quickedit from window
integer width = 3799
integer height = 2864
boolean titlebar = true
string title = "Inspection Items - Quick Edit"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
pb_down pb_down
pb_up pb_up
st_4 st_4
rb_roviq rb_roviq
rb_normal rb_normal
st_sort st_sort
st_2 st_2
sle_num sle_num
cb_cancel cb_cancel
cb_ok cb_ok
dw_items dw_items
st_1 st_1
end type
global w_quickedit w_quickedit

forward prototypes
public subroutine wf_repositiondw ()
end prototypes

public subroutine wf_repositiondw ();
dw_items.Object.Datawindow.VerticalScrollPosition = String(Long(dw_items.Object.Datawindow.VerticalScrollPosition) + 600)
end subroutine

on w_quickedit.create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_4=create st_4
this.rb_roviq=create rb_roviq
this.rb_normal=create rb_normal
this.st_sort=create st_sort
this.st_2=create st_2
this.sle_num=create sle_num
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_items=create dw_items
this.st_1=create st_1
this.Control[]={this.pb_down,&
this.pb_up,&
this.st_4,&
this.rb_roviq,&
this.rb_normal,&
this.st_sort,&
this.st_2,&
this.sle_num,&
this.cb_cancel,&
this.cb_ok,&
this.dw_items,&
this.st_1}
end on

on w_quickedit.destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_4)
destroy(this.rb_roviq)
destroy(this.rb_normal)
destroy(this.st_sort)
destroy(this.st_2)
destroy(this.sle_num)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_items)
destroy(this.st_1)
end on

event open;
dw_Items.SetTransObject(SQLCA)

dw_Items.Object.DataWindow.Detail.Color = 16777184
dw_Items.Object.DataWindow.Color = 16777184

SetPointer(HourGlass!)

If g_Obj.Level = 0 then 
	st_Sort.Visible = False
	rb_Normal.Visible = False
	rb_Roviq.Visible = False
End If

dw_Items.Post Retrieve(g_Obj.InspID)

end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2900)
end event

type pb_down from picturebutton within w_quickedit
integer x = 3675
integer y = 16
integer width = 91
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "J:\TramosWS\VIMS\images\Vims\DownArrow.gif"
alignment htextalign = left!
end type

event clicked;
Integer li_Row

li_Row = dw_Items.GetRow()
If li_Row = dw_Items.RowCount() then Return

li_Row = dw_Items.Find("Ans = 1", li_Row + 1, dw_Items.RowCount() + 1)

If li_Row > 0 then
	dw_Items.SetRow(li_Row)
	dw_Items.ScrollToRow(li_Row)	
	If Integer(dw_items.Object.DataWindow.LastRowOnPage) = li_Row or Integer(dw_items.Object.DataWindow.LastRowOnPage) = li_Row - 1 then wf_RepositionDW( )
End If


end event

type pb_up from picturebutton within w_quickedit
integer x = 3584
integer y = 16
integer width = 91
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "J:\TramosWS\VIMS\images\Vims\UpArrow.gif"
alignment htextalign = left!
end type

event clicked;Integer li_Row

li_Row = dw_Items.GetRow()
If li_Row = 1 then Return

li_Row = dw_Items.Find("Ans = 1", li_Row - 1, 1)

If li_Row > 0 then
	dw_Items.SetRow(li_Row)
	dw_Items.ScrollToRow(li_Row)
	If Integer(dw_items.Object.DataWindow.LastRowOnPage) = li_Row or Integer(dw_items.Object.DataWindow.LastRowOnPage) = li_Row - 1 then dw_items.Object.Datawindow.VerticalScrollPosition = String(Long(dw_items.Object.Datawindow.VerticalScrollPosition) + 600)
End If
end event

type st_4 from statictext within w_quickedit
integer x = 3310
integer y = 32
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Quick Step:"
boolean focusrectangle = false
end type

type rb_roviq from radiobutton within w_quickedit
integer x = 2158
integer y = 32
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "ROVIQ"
end type

event clicked;
SetPointer(HourGlass!)

dw_items.SetSort("Roviq Asc, ObjNum Asc")
dw_items.SetFilter("Not IsNull(Roviq)")

dw_items.SetReDraw(False)

dw_items.Modify("DataWindow.Header.1.Height='0'")
dw_items.Filter( )

If dw_items.Sort()<1 then
	MessageBox("Sort Error", "Could not sort into ROVIQ order.", Exclamation!)
End If

dw_items.SetReDraw(True)
end event

type rb_normal from radiobutton within w_quickedit
integer x = 1902
integer y = 32
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Normal"
boolean checked = true
end type

event clicked;
SetPointer(HourGlass!)

dw_items.SetSort("SortField Asc")
dw_items.SetFilter("")

dw_items.SetReDraw(False)
dw_items.Modify("DataWindow.Header.1.Height='90'")
dw_items.Filter( )

If dw_items.Sort()<1 then
	MessageBox("Sort Error", "Could not sort into Normal order.", Exclamation!)
End If

dw_items.SetReDraw(True)
end event

type st_sort from statictext within w_quickedit
integer x = 1591
integer y = 32
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sort Order:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_quickedit
integer x = 18
integer y = 32
integer width = 677
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspector~'s Comments:"
boolean focusrectangle = false
end type

type sle_num from singlelineedit within w_quickedit
event ue_keypress pbm_keyup
integer x = 2798
integer y = 16
integer width = 329
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_keypress;
String ls_Search
Integer li_Row

If Message.WordParm < 32 then Return

ls_Search = This.Text

li_Row = dw_Items.Find("FullNum Like '" + ls_Search + "%'", 1, dw_Items.RowCount())

If li_Row > 0 then
	dw_Items.SetRow(li_Row)
	dw_Items.ScrollToRow(li_Row)
End If
end event

event getfocus;
This.SelectText(1, Len(This.Text))
end event

type cb_cancel from commandbutton within w_quickedit
integer x = 2263
integer y = 2656
integer width = 603
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event clicked;

If dw_items.ModifiedCount() > 0 then
	If Messagebox("Items Modified", "You have made changes to one or more items. Are you sure you want to LOOSE all changes?", Question!, YesNo!) = 2 then Return
End If

g_Obj.Level = 0

Close(Parent)
end event

type cb_ok from commandbutton within w_quickedit
integer x = 933
integer y = 2656
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save Changes"
end type

event clicked;Integer li_Items, li_Invalid
String ls_Comm

dw_Items.AcceptText()

// Run thru all items
For li_Items = 1 to dw_Items.RowCount( )
	
	If dw_Items.GetItemNumber(li_Items, "Ans") <> 1 then  // If item ans is not 'No'
		dw_Items.SetItem(li_Items, "Def", 0)
		dw_Items.SetItem(li_Items, "Is_CAP", 0)
		dw_Items.SetItem(li_Items, "Closed", 1)
		dw_Items.SetItem(li_Items, "Report", 0)
	Else   // If item ans is 'No'
		dw_Items.SetItem(li_Items, "Closed", 0)
		dw_Items.SetItem(li_Items, "Report", 1)
		dw_Items.SetItem(li_Items, "Def", 1)
	End If
	ls_Comm = dw_Items.GetItemString(li_Items, "InspComm")  // Get comments
	If Not IsNull(ls_Comm) then  // if not null, trim comments
		If ls_Comm <> Trim(ls_Comm, True) then 
			ls_Comm = Trim(ls_Comm, True)
			If ls_Comm = "" then SetNull(ls_Comm)
			dw_Items.SetItem(li_Items, "InspComm", ls_Comm)
		End If
	End If	
	If f_CheckInvalid(ls_Comm) then   // Check for invalid characters
		dw_Items.SetItem(li_Items, "InspComm", ls_Comm)
		dw_Items.SetRow(li_Items)
		dw_Items.ScrollToRow(li_Items)
		Messagebox("Invalid Characters", "The selected comment contained one or more invalid characters that have been replaced by underscores.~n~nPlease check and replace all underscores as appropriate.")
		dw_Items.SetFocus()
		Return
	End If
	If IsNull(ls_Comm) and dw_Items.GetItemNumber(li_Items, "Ans")=1 then  // Check for blank InspComm where Ans is 'No'
		dw_Items.SetRow(li_Items)
		dw_Items.ScrollToRow(li_Items)
		Messagebox("Comments Required", "The selected observation is marked with a 'No' and requires the inspector's comments.")
		dw_Items.SetFocus()
		Return		
	End If
Next

If dw_Items.Update() < 1 then
	If Messagebox("Update Failed", "An error occurred while saving the data. Do you want to close this window?", Question!, YesNo!) = 2 Then Return
End If

g_Obj.Level = 1

Close(Parent)


end event

type dw_items from datawindow within w_quickedit
integer x = 18
integer y = 112
integer width = 3749
integer height = 2528
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_itemquickedit"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
If dwo.Tag = "G" then 
	g_Obj.ParamLong = This.GetItemNumber( row, "guide")
	Open(w_note)
End If
end event

event doubleclicked;
If dwo.Type <> "column" then Return

Yield()

// ii_Lock contains following values
// 0 = No Access, 1 = Only comments open, 2 = All except comments, 3 = All except risk

If dwo.tag = "TX" then
	This.Accepttext( )
	g_Obj.ParamString = This.GetItemString(row, String(dwo.name))
	g_Obj.Level = 1  // Enable Edit
	Open(w_textedit)
	If Not IsNull(g_Obj.ParamString) and (g_Obj.Level = 1) Then This.SetItem(row, String(dwo.name), g_Obj.ParamString)
	g_Obj.Level = 0
End If
end event

event itemchanged;
If dwo.name = "ans" then
	If (Data <> "1") then	This.SetItem(Row, "Is_CAP", 0)
End If
end event

event rowfocuschanged;
If Integer(dw_items.Object.DataWindow.LastRowOnPage) = currentrow or Integer(dw_items.Object.DataWindow.LastRowOnPage) = currentrow - 1 then Post wf_RepositionDW( )



end event

type st_1 from statictext within w_quickedit
integer x = 2578
integer y = 32
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search:"
boolean focusrectangle = false
end type

