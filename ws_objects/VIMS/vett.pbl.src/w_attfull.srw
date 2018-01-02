$PBExportHeader$w_attfull.srw
forward
global type w_attfull from window
end type
type cb_thumbs from commandbutton within w_attfull
end type
type cb_open from commandbutton within w_attfull
end type
type cb_view from commandbutton within w_attfull
end type
type cb_save from commandbutton within w_attfull
end type
type cb_close from commandbutton within w_attfull
end type
type dw_att from datawindow within w_attfull
end type
type gb_1 from groupbox within w_attfull
end type
end forward

global type w_attfull from window
integer width = 2391
integer height = 1672
boolean titlebar = true
string title = "Attachment List"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_thumbs cb_thumbs
cb_open cb_open
cb_view cb_view
cb_save cb_save
cb_close cb_close
dw_att dw_att
gb_1 gb_1
end type
global w_attfull w_attfull

type prototypes

end prototypes

type variables
Integer il_last_row_clicked
end variables

on w_attfull.create
this.cb_thumbs=create cb_thumbs
this.cb_open=create cb_open
this.cb_view=create cb_view
this.cb_save=create cb_save
this.cb_close=create cb_close
this.dw_att=create dw_att
this.gb_1=create gb_1
this.Control[]={this.cb_thumbs,&
this.cb_open,&
this.cb_view,&
this.cb_save,&
this.cb_close,&
this.dw_att,&
this.gb_1}
end on

on w_attfull.destroy
destroy(this.cb_thumbs)
destroy(this.cb_open)
destroy(this.cb_view)
destroy(this.cb_save)
destroy(this.cb_close)
destroy(this.dw_att)
destroy(this.gb_1)
end on

event open;
SetPointer(HourGlass!)
Integer li_VM 

If g_Obj.Is_VM = True Then li_VM = 1 Else li_VM = 0

dw_att.SetTransObject(SQLCA)
dw_att.Retrieve(Long(Message.DoubleParm), li_VM)

If dw_att.Rowcount() = 0 then 
	cb_Save.Enabled = False
	cb_View.Enabled = False
	cb_Thumbs.Enabled = False
	cb_Open.Enabled = False
Else
	dw_att.SetItem(dw_att.GetRow(), "Sel", 1)
End If

Commit;
end event

type cb_thumbs from commandbutton within w_attfull
integer x = 1847
integer width = 457
integer height = 80
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Switch to Thumbs"
end type

event clicked;

CloseWithReturn(Parent, 2)




end event

type cb_open from commandbutton within w_attfull
integer x = 73
integer y = 1344
integer width = 366
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open"
end type

event clicked;Long ll_AttID, ll_Temp
String ls_FileName
n_vimsatt l_att

SetPointer(HourGlass!)

If g_Obj.TempFolder = "" Then
	Messagebox("Temp Folder Not Available", "Temporary folder for extraction is not available. Please save this report to disk and then open.", Exclamation!)
	Return
End If

// Remove selections
dw_Att.SetRedraw(False)
For ll_Temp = 1 to dw_Att.RowCount()
	dw_Att.SetItem(ll_Temp, "Sel", 0)
Next
dw_Att.SetItem(dw_Att.GetRow(), "Sel", 1)

dw_Att.SetRedraw(True)

ll_AttID = dw_Att.GetItemNumber(dw_Att.GetRow(), "Att_ID")
ls_FileName = "Temp_" + String(Rand(99999)) + "_" + dw_Att.GetItemString(dw_Att.GetRow(), "FileName")

l_att = create n_vimsatt
ll_Temp = l_att.of_SaveAttachment(ll_AttID, g_Obj.TempFolder + ls_FileName)
destroy l_att

If ll_Temp < 0 then Return

ShellExecute(Handle(Parent), "open", g_Obj.TempFolder + ls_FileName, "", "", 3)

end event

type cb_view from commandbutton within w_attfull
integer x = 1938
integer y = 1344
integer width = 366
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "View Photo"
end type

event clicked;Integer li_Loop
ustruct_Att AttStr

SetPointer(HourGlass!)

// Remove selections
dw_Att.SetRedraw(False)
For li_Loop = 1 to dw_Att.RowCount()
	dw_Att.SetItem(li_Loop, "Sel", 0)
Next
dw_Att.SetRedraw(True)

// Save info into struct
AttStr.Index = dw_Att.GetRow()
For li_Loop = 1 to dw_Att.RowCount()
	AttStr.IDList[li_Loop] = dw_Att.GetItemNumber(li_Loop, "Att_ID")
	AttStr.NameList[li_Loop] = dw_Att.GetItemString(li_Loop, "filename")
Next

// Open preview window
OpenWithParm(w_attview, AttStr)




end event

type cb_save from commandbutton within w_attfull
integer x = 439
integer y = 1344
integer width = 366
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save As..."
end type

event clicked;String ls_FPath, ls_FileName
Long ll_FSize, ll_AttID, ll_NumFiles
Integer li_Count
n_vimsatt l_att

// Count number of files to be saved
ll_NumFiles = 0
For li_Count=1 to dw_Att.Rowcount( )  
	If dw_Att.GetItemNumber(li_Count, "Sel")>0 or li_Count = dw_Att.GetRow() then 
		ll_NumFiles ++
		ll_FSize = li_Count  // hold row number in case of single file
	End If
Next
  
If ll_NumFiles = 1 then   // If only 1 file to be saved
	ls_FPath = dw_Att.GetItemString(ll_FSize, "FileName")
	ls_FileName = ""
	If GetFileSaveName("Select location to save", ls_FPath, ls_FileName) < 1 then Return
	If FileExists(ls_FPath) then
		If Messagebox("Confirm Overwrite", "The file " + ls_FPath + " already exists.~n~nDo you want to overwrite this file?", Question!, YesNo!) = 2 then Return
	End If
	l_att = create n_vimsatt
	ll_AttID = dw_att.GetItemNumber(ll_FSize, "Att_ID")
	ll_FSize = l_att.of_SaveAttachment(ll_AttID, ls_FPath)
	Destroy l_att
	If ll_FSize < 0 then 
		MessageBox("Attachment Error", "Unable to save attachment.")		
		Return
	End If
	If Messagebox("Attachment Saved", "The attachment was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,###,##0") + " Bytes~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return
	ShellExecute( Handle(Parent), "open", ls_FPath, "", "", 3)
Else  // multiple files
	ll_NumFiles = 0
	If GetFolder("Select location to save", ls_FPath) = 1 then  // get folder to save
		If Right(ls_FPath,1) <> "\" then ls_FPath += "\"
		ChangeDirectory(g_Obj.AppFolder)
		l_att = create n_vimsatt
		For li_Count=1 to dw_Att.Rowcount( )			
			If dw_Att.GetItemNumber(li_Count, "Sel")>0 or li_Count = dw_Att.GetRow() then
				ls_FileName = dw_Att.GetItemString(li_Count, "FileName")
				ll_AttID = dw_att.GetItemNumber(li_Count, "Att_ID")
				If FileExists(ls_FPath + ls_FileName) then
					If Messagebox("Confirm Overwrite", "The file " + ls_FPath + ls_FileName + " already exists.~n~nDo you want to overwrite this file?", Question!, YesNo!) = 1 then
						ll_FSize = l_att.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
						If ll_FSize>0 then ll_NumFiles ++
					End If			
				Else
					ll_FSize = l_att.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
					If ll_FSize>0 then ll_NumFiles ++					
				End If				
			End If
		Next		
		Destroy n_vimsatt
		Messagebox("Attachment Saved", "Number of attachments extracted successfully : " + String(ll_NumFiles))
	End If
	ChangeDirectory(g_Obj.AppFolder)
End If


end event

type cb_close from commandbutton within w_attfull
integer x = 933
integer y = 1472
integer width = 567
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
CloseWithReturn(Parent, 0)
end event

type dw_att from datawindow within w_attfull
integer x = 73
integer y = 80
integer width = 2231
integer height = 1264
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_attfull"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_sort, ls_KeyDownType
Integer	li_cnt
 	
If row>0 then 
	SetRedraw(False)
	If KeyDown(KeyShift!) then
		For li_cnt =  1 to This.RowCount()
			This.SetItem(li_cnt, "Sel", 0)
		Next
		If il_last_row_clicked > row Then
			// Loop back through rows and highlight them
			For li_cnt = il_last_row_clicked to row Step -1
				This.SetItem(li_cnt, "Sel", 1)
			Next
		Else
			// Loop forward through rows and highlight them
			For li_cnt = il_last_row_clicked to row
				This.SetItem(li_cnt, "Sel", 1)
			Next
		End If
	ElseIf KeyDown(KeyControl!) then
		il_last_row_clicked = row
		This.SetItem(row, "Sel", 1)
	Else
		For li_cnt =  1 to This.RowCount()
			This.SetItem(li_cnt, "Sel", 0)
		Next
		il_last_row_clicked = row
		This.SetItem(row, "Sel", 1)
	End If
	SetRedraw(True)
End if
end event

type gb_1 from groupbox within w_attfull
integer x = 37
integer width = 2304
integer height = 1440
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

