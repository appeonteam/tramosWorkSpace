$PBExportHeader$w_offset.srw
forward
global type w_offset from window
end type
type st_2 from statictext within w_offset
end type
type cb_save from commandbutton within w_offset
end type
type cb_close from commandbutton within w_offset
end type
type dw_off from datawindow within w_offset
end type
type st_3 from statictext within w_offset
end type
type cb_add from commandbutton within w_offset
end type
type st_id from statictext within w_offset
end type
type st_1 from statictext within w_offset
end type
type gb_1 from groupbox within w_offset
end type
end forward

global type w_offset from window
integer width = 2322
integer height = 1508
boolean titlebar = true
string title = "Offset Days"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
cb_save cb_save
cb_close cb_close
dw_off dw_off
st_3 st_3
cb_add cb_add
st_id st_id
st_1 st_1
gb_1 gb_1
end type
global w_offset w_offset

on w_offset.create
this.st_2=create st_2
this.cb_save=create cb_save
this.cb_close=create cb_close
this.dw_off=create dw_off
this.st_3=create st_3
this.cb_add=create cb_add
this.st_id=create st_id
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.cb_save,&
this.cb_close,&
this.dw_off,&
this.st_3,&
this.cb_add,&
this.st_id,&
this.st_1,&
this.gb_1}
end on

on w_offset.destroy
destroy(this.st_2)
destroy(this.cb_save)
destroy(this.cb_close)
destroy(this.dw_off)
destroy(this.st_3)
destroy(this.cb_add)
destroy(this.st_id)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
st_ID.text = g_Obj.ObjString

dw_Off.SetTransObject(SQLCA)

dw_Off.Retrieve(g_Obj.ObjString)
end event

event closequery;
If cb_Save.enabled Then
	If Messagebox("Changes Made", "You have made changes but not saved them.~n~nAre you sure you want to close the window and lose these changes?", Question!, YesNo!) = 2 Then Return 1 Else Return 0
End If
end event

type st_2 from statictext within w_offset
integer x = 91
integer y = 1104
integer width = 2107
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Offset days for any year must be less than 50. To remove an year, simply set the offset days to zero. Comments are mandatory."
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_offset
integer x = 1902
integer y = 992
integer width = 311
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Save"
end type

event clicked;
Integer li_row
String ls_Cmm

dw_Off.Accepttext( )

For li_row = dw_Off.Rowcount( ) to 1 Step -1
	If dw_Off.GetItemNumber(li_row, "TaskYear") < 2010 or dw_Off.GetItemNumber(li_row, "TaskYear") > Year(Today()) + 1 Then
		Messagebox("Invalid Year", "Year must be greater than 2010 and not after next year.", Exclamation!)
		Return
	End If
	If Abs(dw_Off.GetItemNumber(li_row, "OffsetDays")) > 50 then
		Messagebox("Invalid Value", "Offset days must be under 50.", Exclamation!)
		Return
	Else
		If dw_Off.GetItemNumber(li_row, "OffsetDays") = 0 then 
			dw_Off.DeleteRow(li_row)
		Else
			ls_Cmm = Trim(dw_Off.GetItemString(li_row, "Comments"), True)
			If ls_Cmm = "" Then
				Messagebox("Required Field", "Comments are mandatory. Please check comment fields.", Exclamation!)
				Return	
			End If
			dw_Off.SetItem(li_row, "Comments", ls_Cmm)
		End If
	End If
Next

If dw_Off.Update() < 1 then
	Rollback;
	Messagebox("Unable to Save", "Unable to save table. Please check values.", Exclamation!)
	Return
End If

Commit;
This.enabled = False


end event

type cb_close from commandbutton within w_offset
integer x = 951
integer y = 1280
integer width = 402
integer height = 112
integer taborder = 50
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
close(parent)
end event

type dw_off from datawindow within w_offset
integer x = 91
integer y = 256
integer width = 2121
integer height = 736
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_taskoffset"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
cb_Save.Enabled = True
end event

event editchanged;
cb_Save.Enabled = True
end event

type st_3 from statictext within w_offset
integer x = 91
integer y = 176
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
string text = "Offset Days:"
boolean focusrectangle = false
end type

type cb_add from commandbutton within w_offset
integer x = 91
integer y = 992
integer width = 311
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New Year"
end type

event clicked;
Integer li_row, li_Year = 0

For li_row = dw_Off.Rowcount( ) to 1 Step -1
	If dw_Off.GetItemNumber(li_row, "TaskYear") > li_Year Then li_Year = dw_Off.GetItemNumber(li_row, "TaskYear")
Next

li_Row = dw_Off.InsertRow(0)

If li_Year = 0 then li_Year = Year(Today()) else li_Year++
If li_Year < Year(Today()) Then li_Year = Year(Today())

dw_Off.SetItem(li_Row, "TaskYear", li_Year)
dw_Off.SetItem(li_Row, "OffsetDays", 0)
dw_Off.SetItem(li_Row, "UserID", g_Obj.ObjString)
dw_Off.SetItem(li_Row, "Comments", "")
dw_Off.SetRow(li_Row)
dw_Off.ScrollToRow(li_Row)
dw_Off.SetColumn("OffsetDays")

dw_Off.SetFocus( )

cb_Save.Enabled = True



end event

type st_id from statictext within w_offset
integer x = 439
integer y = 80
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_offset
integer x = 91
integer y = 80
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "User ID:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_offset
integer x = 37
integer y = 16
integer width = 2231
integer height = 1232
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

