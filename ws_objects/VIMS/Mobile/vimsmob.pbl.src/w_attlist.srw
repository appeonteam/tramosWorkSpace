$PBExportHeader$w_attlist.srw
forward
global type w_attlist from window
end type
type cb_ren from commandbutton within w_attlist
end type
type cb_view from commandbutton within w_attlist
end type
type cb_add from commandbutton within w_attlist
end type
type cb_del from commandbutton within w_attlist
end type
type cb_save from commandbutton within w_attlist
end type
type dw_att from datawindow within w_attlist
end type
end forward

global type w_attlist from window
integer width = 1623
integer height = 1204
boolean titlebar = true
string title = "Attachment List"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_ren cb_ren
cb_view cb_view
cb_add cb_add
cb_del cb_del
cb_save cb_save
dw_att dw_att
end type
global w_attlist w_attlist

type prototypes

end prototypes

type variables

Integer il_last_row_clicked
end variables

on w_attlist.create
this.cb_ren=create cb_ren
this.cb_view=create cb_view
this.cb_add=create cb_add
this.cb_del=create cb_del
this.cb_save=create cb_save
this.dw_att=create dw_att
this.Control[]={this.cb_ren,&
this.cb_view,&
this.cb_add,&
this.cb_del,&
this.cb_save,&
this.dw_att}
end on

on w_attlist.destroy
destroy(this.cb_ren)
destroy(this.cb_view)
destroy(this.cb_add)
destroy(this.cb_del)
destroy(this.cb_save)
destroy(this.dw_att)
end on

event open;
f_Write2Log("w_AttList Open")

dw_att.SetTransObject(SQLCA)
dw_att.Retrieve(g_Obj.InspID)

Choose Case g_Obj.Level
	Case 0
		This.Title = "Attachments for Item"
		dw_att.SetFilter( "Item_ID = " + String(g_Obj.ItemID))
	Case 1
		This.Title = "Attachments for Inspection"
		dw_att.SetFilter( "IsNull(Item_ID) and IsNull(sm_ID)")
	Case 2
		This.Title = "Attachments for Summary"
		dw_att.SetFilter( "sm_id = " + String(g_Obj.ItemID))		
End Choose

dw_att.Filter( )

If (dw_att.Rowcount() > 0) and (g_Obj.Login > 0) And (g_Obj.ParamInt > 1) then 
	cb_Del.Enabled = True
	cb_Ren.Enabled = True
End If

If dw_att.Rowcount() = 0 then 
	cb_save.Enabled = False
	cb_view.Enabled = False
Else
	dw_att.SelectRow(0, False)
	dw_att.SelectRow(dw_Att.GetRow(), True)
End If

If (g_Obj.login > 0) And (g_Obj.ParamInt > 1) then cb_add.Enabled = True

Commit;
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1000)
end event

event close;
g_Obj.ParamLong = dw_att.Rowcount( )  // Pass back number of attachments

f_Write2Log("w_AttList Close; Att Count = " + String(g_Obj.ParamLong))
end event

type cb_ren from commandbutton within w_attlist
integer x = 1097
integer y = 1024
integer width = 238
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Re&name"
end type

event clicked;String ls_OldName
Long ll_AttID

g_Obj.ParamString = dw_Att.GetItemString(dw_Att.GetRow(), "filename")
ll_AttID = dw_Att.GetItemNumber(dw_Att.GetRow(), "Att_ID")

ls_OldName = g_Obj.ParamString

Open(w_attrename)

If g_Obj.ParamString > "" then
	
	// Check if file name doesn't already exist
	If dw_Att.Find("(Upper(filename) = '" + Upper(g_Obj.ParamString) + "') And (Att_ID <> " + String(ll_AttID) + ")", 1, dw_Att.RowCount( )) > 0 then
		Messagebox("Duplicate File", "A file with specified name already exists.", Exclamation!)
		Return
	End If

	// Rename file
	dw_Att.SetItem(dw_att.GetRow(), "filename", g_Obj.ParamString)
	If dw_Att.Update() <> 1 then 
		Messagebox("Update Error", "Could not update the file name in the database.", Exclamation!)
		dw_Att.Reselectrow(dw_att.GetRow())
		f_Write2Log("cb_ren > Rename failed")
		Return
	Else
		f_Write2Log("cb_ren > Rename Success; Name: " + g_Obj.ParamString)
	End If
End If

end event

type cb_view from commandbutton within w_attlist
integer x = 347
integer y = 1024
integer width = 329
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&View"
end type

event clicked;ustruct_Att AttStr
Integer li_Loop

If dw_Att.GetRow()<1 then 
	this.Enabled = False
	Return
End If

SetPointer(HourGlass!)

g_Obj.ParamLong = dw_att.GetItemNumber( dw_Att.GetRow(), "Att_ID")
g_Obj.ParamString = dw_att.GetItemString(dw_Att.GetRow(), "Filename")
g_Obj.Level = dw_att.GetRow()
g_Obj.ParamInt = dw_att.Rowcount( )

// Save info into struct
AttStr.Index = dw_Att.GetRow()
For li_Loop = 1 to dw_Att.RowCount()
	AttStr.IDList[li_Loop] = dw_Att.GetItemNumber(li_Loop, "Att_ID")
	AttStr.NameList[li_Loop] = dw_Att.GetItemString(li_Loop, "filename")
Next

OpenWithParm(w_Attview, AttStr)



end event

type cb_add from commandbutton within w_attlist
integer x = 859
integer y = 1024
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Add..."
end type

event clicked;String ls_FPath, ls_FileName[]
Integer li_FileNum, li_Loop, li_AttCount, li_Temp, li_NumFiles, li_MaxImageSize
Blob lblob_File
Long ll_FSize, ll_AttID
Boolean lbool_Resized
nvo_Img lnvo_Pic

// Get the files
If GetFileOpenName("Select one or more files to attach:", ls_FPath, ls_FileName, "", "All Files (*.*),*.*", "", 16402) < 1 then Return

ChangeDirectory(g_Obj.AppFolder)

// Check for max limit selected
li_NumFiles = UpperBound(ls_FileName)
If li_NumFiles > 20 then
	Messagebox("File Attachment Limit", "You can only select up to 20 files at a time to attach. If you wish to attach more files, please select them in groups of 20 or less.")
	Return
End If

SetPointer(HourGlass!)

// Set max image size
li_MaxImageSize = 640

// If only 1 file selected, strip file from path
If li_NumFiles = 1 then	ls_FPath = Left(ls_FPath, Len(ls_FPath) - Len(ls_FileName[1]))

// Check last character of path
If Right(ls_FPath, 1) <> "\" then ls_FPath += "\"

// Instanstiate Image library
lnvo_Pic = Create nvo_Img

For li_Loop = 1 to li_NumFiles

	li_Temp = 0    // Hold status of attachment
	
	// Check for duplicate files
	If dw_Att.Find("Upper(filename) = '" + Upper(ls_FileName[li_Loop]) + "'", 1, dw_Att.RowCount()) > 0 then
		Messagebox("Duplicate File", "A file with the same name (" + ls_FileName[li_Loop] + ") already exists.",Exclamation!)
		li_Temp = 1
		If li_NumFiles = 1 then Return
	End If
	
	//Try to check if file is a image. If so, scale it down
	If lnvo_Pic.LoadImageFromFile(ls_FPath + ls_FileName[li_Loop]) = 0 then	
		If (lnvo_Pic.GetHeight( ) > li_MaxImageSize) Or (lnvo_Pic.GetWidth( ) > li_MaxImageSize) then
			lnvo_Pic.Scaledown(li_MaxImageSize)
			ls_FileName[li_Loop] = "ResizedImage-" + ls_FileName[li_Loop]
			lnvo_Pic.SaveImageToFile(ls_FPath + ls_FileName[li_Loop])
			If FileExists(ls_FPath + ls_FileName[li_Loop]) then	// If resize was successful
				lbool_Resized = True 
			Else 
				li_Temp = 1
				MessageBox("Resize Error", "The image " + ls_FileName[li_Loop] + " could not be scaled down successfully.", Exclamation!)
				If li_NumFiles = 1 then Return
			End If
		End If
		lnvo_Pic.UnloadImage( )
	End If
	
	// Try to open file
	If li_Temp = 0 then 
		li_FileNum = Fileopen(ls_FPath + ls_FileName[li_Loop], StreamMode!)	
		If li_FileNum <0 then 
			If li_NumFiles = 1 then  // If only 1 file, then just give error msg and return
				MessageBox ("File I/O Error", "Could not open the selected file. Please check that the file is accessible and not in use.",Exclamation!)
				f_Write2Log("cb_Add > FileOpen() Fail: " + ls_FileName[li_Loop])
				Return
			End If		
			MessageBox ("File I/O Error", "Could not open the file " + ls_FileName[li_Loop] + " to attach. The file will be skipped.")
			li_Temp = 1
		End If
	End If

	If li_Temp = 0 then	ll_FSize = FileReadEx(li_FileNum, lblob_File)
	
	If (ll_FSize < 1) and (li_Temp = 0) then
		FileClose(li_FileNum)
		f_Write2Log("cb_Add > FileReadEx() Fail: " + ls_FileName[li_Loop])
		MessageBox("File I/O Error", "Could not read the file " + ls_FileName[li_Loop] + ". The file will be skipped.")
		li_Temp = 1
	End If
	
	FileClose(li_FileNum)
	
	If Left(ls_FileName[li_Loop], 13) = "ResizedImage-" then 
		FileDelete(ls_FPath + ls_FileName[li_Loop])
		ls_FileName[li_Loop] = Right(ls_FileName[li_Loop], Len(ls_FileName[li_Loop]) - 13)
	End If
	
	If li_Temp = 0 then
		Choose Case g_Obj.Level  // Type of attachment
			Case 0  // Item
				Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, ITEM_ID) Values (:ls_FileName[li_Loop], :ll_FSize, :g_Obj.InspID, :g_Obj.ItemID);
			Case 1  // Inspection
				Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID) Values (:ls_FileName[li_Loop], :ll_FSize, :g_Obj.InspID);
			Case 2  // Summary
				Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, SM_ID) Values (:ls_FileName[li_Loop], :ll_FSize, :g_Obj.InspID, :g_Obj.ItemID);
		End Choose
		
		If SQLCA.Sqlcode <> 0 then
			Messagebox("DB Error", "Could not create new attachment in database for file " + ls_FileName[li_Loop] + "The file will be skipped.~n~n" + sqlca.sqlerrtext, Exclamation!)
			f_Write2Log("cb_Add > SQL to insert attachment failed")
			Rollback;	
			li_Temp = 1
		End If
	End If

	If li_Temp = 0 then
		Select Max(ATT_ID) into :ll_AttID from VETT_ATT where (INSP_ID = :g_Obj.InspID) and (FILESIZE = :ll_FSize) and (FILENAME = :ls_FileName[li_Loop]);
		
		If SQLCA.Sqlcode <> 0 then
			Messagebox("DB Error", "Could not save file in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
			Rollback;	
			f_Write2Log("cb_Add > Retrieve of ATT_ID failed: " + ls_FileName[li_Loop])
  		li_Temp = 1
		End If
	End If

	If li_Temp = 0 then
		Updateblob VETT_ATT Set ATTDATA = :lblob_File where ATT_ID = :ll_AttID;
		If SQLCA.Sqlcode <> 0 then
			Messagebox("DB Error", "Could not save file " + ls_FileName[li_Loop] + " in database. The file will be skipped.~n~n" + sqlca.sqlerrtext, Exclamation!)
			Rollback;
			f_Write2Log("cb_Add > UpdateBlob failed")
			li_Temp = 1
		End If
	End If
	
	If li_Temp = 0 then 
		Commit;
		li_AttCount ++
		f_Write2Log("cb_Add > Attach Successful; Name: " + ls_FileName[li_Loop] + "; Size: " + String(ll_FSize))	
	End If
Next

Destroy lnvo_Pic

dw_att.Retrieve(g_Obj.InspID)
dw_att.SelectRow(0, False)
dw_att.SelectRow(dw_Att.GetRow(), True)

Commit;

If lbool_Resized then Messagebox("Images resized", "One or more images were scaled down before being attached to the inspection. The original images have not been modified.")

If li_NumFiles = 1 then
	MessageBox("File Attached", "The selected file was attached successfully.")
Else
	If li_AttCount = 1 then	ls_FPath = "1 file was" Else ls_FPath = String(li_AttCount) + " files were"
	MessageBox("Files Attached", ls_FPath + " attached successfully from a total of " + String(li_NumFiles) + " selected files.")
End If

If li_AttCount > 0 then
	cb_Del.Enabled = True
	cb_Ren.Enabled = True
	cb_save.Enabled = True
	cb_view.Enabled = True
End If

f_UpdateLastEdit(g_Obj.InspID)   // Update LastEdit

w_inspdetail.dw_insp.Retrieve(g_Obj.InspID)  // Retrieve header
end event

type cb_del from commandbutton within w_attlist
integer x = 1335
integer y = 1024
integer width = 238
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

event clicked;Long ll_AttID
String ls_FileName

If MessageBox("Delete Attachment", "Are you sure you want to delete the selected attachment?", Question!, YesNo!) = 2 then Return

SetPointer(HourGlass!)

ll_AttID = dw_Att.GetItemNumber(dw_Att.GetRow(), "Att_ID")
ls_FileName = dw_Att.GetItemString(dw_Att.GetRow(), "FileName")

Delete from VETT_ATT where ATT_ID = :ll_AttID;

If SQLCA.Sqlcode <> 0 then
	Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	f_Write2Log("cb_del > Delete Failed")
	Rollback;
	Return
End If

Commit;

dw_att.DeleteRow(dw_Att.GetRow())

f_Write2Log("cb_del > Attachment Deleted: " + ls_FileName)

If dw_att.Rowcount( ) = 0 then 
	cb_Del.Enabled = False
	cb_Ren.Enabled = False
	cb_Save.Enabled = False
	cb_view.Enabled = False
Else
	dw_att.SelectRow(0, False)
	dw_att.SelectRow(dw_att.GetRow(), True)
End If

f_UpdateLastEdit(g_Obj.InspID)   // Update LastEdit

w_inspdetail.dw_insp.Retrieve(g_Obj.InspID)  // Retrieve header
end event

type cb_save from commandbutton within w_attlist
integer x = 18
integer y = 1024
integer width = 329
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "E&xtract..."
end type

event clicked;String ls_FPath, ls_FileName
Long ll_FSize, ll_AttID, ll_NumFiles
Integer li_Count
n_inspio lnvo_inspio

// Count number of files to be saved
ll_NumFiles = 0
For li_Count=1 to dw_Att.Rowcount( )  
	If dw_Att.IsSelected(li_Count) then 
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
	ChangeDirectory(g_Obj.AppFolder)
	ll_AttID = dw_att.GetItemNumber(ll_FSize, "Att_ID")
	ll_FSize = lnvo_inspio.of_SaveAttachment(ll_AttID, ls_FPath)
	If ll_FSize < 0 then 
		MessageBox("Attachment Error", "Unable to save attachment.")		
		Return
	End If
	f_Write2Log("Att Extract: " + ls_FileName + "; Size: " + String(ll_FSize))
	If Messagebox("Attachment Saved", "The attachment was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,###,##0") + " Bytes~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return
	ShellExecute( Handle(Parent), "open", ls_FPath, "", "", 3)
Else
	ll_NumFiles = 0
	If GetFolder("Select location to save", ls_FPath) = 1 then  // get folder to save
		If Right(ls_FPath,1) <> "\" then ls_FPath += "\"
		ChangeDirectory(g_Obj.AppFolder)
		For li_Count=1 to dw_Att.Rowcount( )
			If dw_Att.IsSelected(li_Count) then
				ls_FileName = dw_Att.GetItemString(li_Count, "FileName")
				ll_AttID = dw_att.GetItemNumber(li_Count, "Att_ID")
				If FileExists(ls_FPath + ls_FileName) then
					If Messagebox("Confirm Overwrite", "The file " + ls_FPath + ls_FileName + " already exists.~n~nDo you want to overwrite this file?", Question!, YesNo!) = 1 then
						ll_FSize = lnvo_inspio.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
						If ll_FSize>0 then 
							ll_NumFiles ++
							f_Write2Log("Att Extract: " + ls_FileName + "; Size: " + String(ll_FSize))
						End If						
					End If			
				Else
					ll_FSize = lnvo_inspio.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
					If ll_FSize>0 then 
						ll_NumFiles ++
						f_Write2Log("Att Extract: " + ls_FileName + "; Size: " + String(ll_FSize))
					End If										
				End If			
			End If
		Next		
		Messagebox("Attachment Saved", "Number of attachments extracted successfully : " + String(ll_NumFiles))
	End If
	ChangeDirectory(g_Obj.AppFolder)
End If


end event

type dw_att from datawindow within w_attlist
integer x = 18
integer y = 16
integer width = 1554
integer height = 992
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_attlist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
String ls_sort, ls_KeyDownType
Integer	li_cnt
 	
If row>0 then 
	SetRedraw(False)
	If KeyDown(KeyShift!) then
		SelectRow(0, False)
		If il_last_row_clicked > row Then
			// Loop back through rows and highlight them
			For li_cnt = il_last_row_clicked to row Step -1
				SelectRow(li_cnt, True)	
			Next
		Else
			// Loop forward through rows and highlight them
			For li_cnt = il_last_row_clicked to row
				SelectRow(li_cnt, True)	
			Next
		End If
	ElseIf KeyDown(KeyControl!) then
		il_last_row_clicked = row
		SelectRow(row, Not IsSelected(row))			
	Else
		il_last_row_clicked = row
		SelectRow(0, False)			
		SelectRow(row, True)
	End If
	SetRedraw(True)
End if
end event

