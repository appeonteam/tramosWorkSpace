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
type cb_close from commandbutton within w_attlist
end type
type dw_att from datawindow within w_attlist
end type
type ln_1 from line within w_attlist
end type
end forward

global type w_attlist from window
integer width = 1774
integer height = 1596
boolean titlebar = true
string title = "Attachment List"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_ren cb_ren
cb_view cb_view
cb_add cb_add
cb_del cb_del
cb_save cb_save
cb_close cb_close
dw_att dw_att
ln_1 ln_1
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
this.cb_close=create cb_close
this.dw_att=create dw_att
this.ln_1=create ln_1
this.Control[]={this.cb_ren,&
this.cb_view,&
this.cb_add,&
this.cb_del,&
this.cb_save,&
this.cb_close,&
this.dw_att,&
this.ln_1}
end on

on w_attlist.destroy
destroy(this.cb_ren)
destroy(this.cb_view)
destroy(this.cb_add)
destroy(this.cb_del)
destroy(this.cb_save)
destroy(this.cb_close)
destroy(this.dw_att)
destroy(this.ln_1)
end on

event open;
dw_att.SetTransObject(SQLCA)
dw_att.Retrieve(g_obj.InspID)

Choose Case g_Obj.ObjType
	Case 0
		This.Title = "Attachments for Item"
		dw_att.SetFilter( "Item_ID = " + String(g_obj.ObjID))
	Case 1
		This.Title = "Attachments for Inspection"
		dw_att.SetFilter( "IsNull(Item_ID) and IsNull(sm_ID)")
	Case 2
		This.Title = "Attachments for Summary"
		dw_att.SetFilter( "sm_id = " + String(g_obj.ObjID))		
End Choose

dw_att.Filter( )

If (dw_att.Rowcount() > 0) and (g_obj.Access > 1) and (g_Obj.Level = 1) then 
	cb_Del.Enabled = True
	cb_Ren.Enabled = True
End If

If dw_att.Rowcount() = 0 then 
	cb_save.Enabled = False
	cb_view.Enabled = False
End If

If (g_obj.Access > 1) and (g_Obj.Level = 1) then cb_add.Enabled = True

If w_inspdetail.dw_insp.GetItemNumber(1, "Locked") = 1 then
	cb_add.Visible = False
	cb_del.Visible = False
	cb_ren.Visible = False
End If

Commit;
end event

type cb_ren from commandbutton within w_attlist
integer x = 1262
integer y = 1296
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
string text = "Rename"
end type

event clicked;String ls_OldName
Long ll_AttID

dw_Att.SetRedraw(False)
For ll_AttID = 1 to dw_Att.RowCount()
	dw_Att.SetItem(ll_AttID, "Sel", 0)
Next
dw_Att.SetRedraw(True)

g_obj.Objstring = dw_Att.GetItemString(dw_Att.GetRow(), "filename")
ll_AttID = dw_Att.GetItemNumber(dw_Att.GetRow(), "att_id")

ls_OldName = g_obj.Objstring

Open(w_attrename)

If g_obj.Objstring > "" then
	
	// Check if file name doesn't already exist
	If dw_Att.Find("(Upper(filename) = '" + Upper(g_Obj.ObjString) + "') And (Att_ID <> " + String(ll_AttID) + ")", 1, dw_Att.RowCount( )) > 0 then
		Messagebox("Duplicate File", "A file with the specified name already exists.", Exclamation!)
		Return
	End If
	
	// Change name
	dw_Att.SetItem(dw_att.GetRow(), "filename", g_Obj.ObjString)
	dw_Att.SetItem(dw_att.GetRow(), "imported", 1)
	If dw_Att.Update() <> 1 then 
		Messagebox("Update Error", "Could not update the file name in the database.", Exclamation!)
		dw_Att.ReselectRow(dw_att.GetRow())
		Return
	Else
		If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
	End If
	guo_Global.of_AddInspHist(g_obj.Inspid, 11, ls_OldName + " -> " + g_obj.Objstring) // Add to hist
	
End If

end event

type cb_view from commandbutton within w_attlist
integer x = 347
integer y = 1296
integer width = 329
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "View..."
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

type cb_add from commandbutton within w_attlist
integer x = 1024
integer y = 1296
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
string text = "Add..."
end type

event clicked;String ls_FPath, ls_FileName
Integer li_FileNum, li_MaxImageSize = 640, li_Loop
Blob lblob_File
Long ll_FSize, ll_AttID
n_VimsAtt ln_Att
nvo_Img lnvo_Pic

SetPointer(HourGlass!)

If GetFileOpenName("Add Attachment", ls_FPath, ls_FileName, "", "All Files (*.*),*.*", "", 16402) < 1 then Return

If dw_att.Find("Upper(filename) = '" + Upper(ls_Filename) + "'", 1, dw_Att.RowCount()) > 0 then
	Messagebox("Duplicate File", "A file with the same name already exists as an attachment.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

// Change back to app folder
ChangeDirectory(g_Obj.AppFolder)
lnvo_Pic = Create nvo_Img

//Try to check if file is a image. If so, scale it down
If lnvo_Pic.LoadImageFromFile(ls_FPath) = 0 then
	If (lnvo_Pic.GetHeight( ) > li_MaxImageSize) Or (lnvo_Pic.GetWidth( ) > li_MaxImageSize) then
		lnvo_Pic.Scaledown(li_MaxImageSize)
		ls_FPath += ".Resized"
		lnvo_Pic.SaveImageToFile(ls_FPath)
		If Not FileExists(ls_FPath) then	// If resize was unsuccessful
			MessageBox("Resize Error", "The image could not be scaled down successfully.", Exclamation!)
			Return
		End If
	End If
	lnvo_Pic.UnloadImage( )
End If

Destroy lnvo_Pic

// Open and read file
li_FileNum = Fileopen(ls_FPath, StreamMode!)
ll_FSize = FileReadEx(li_FileNum, lblob_File)

If li_FileNum <0 then 
	MessageBox ("File I/O Error", "Could not open the selected file. Please check that the file is accessible and not in use.",Exclamation!)
	Return
End If

If ll_FSize < 1 then
	FileClose(li_FileNum)
	MessageBox("File I/O Error", "Could not read the selected file.",Exclamation!)
	Return
End If

FileClose(li_FileNum)

String ls_DBName
n_FileAttach_Service lAttSrv

lAttSrv = create n_FileAttach_Service
ls_DBName = lAttSrv.of_GetFileDBName()

If Right(ls_FPath, 8) = ".Resized" then FileDelete(ls_FPath)

Choose Case g_Obj.ObjType  // Type of attachment
	Case 0  // Item
		Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, ITEM_ID, IMPORTED,DB_NAME) Values (:ls_FileName, :ll_FSize, :g_obj.InspID, :g_Obj.ObjID, 1, :ls_DBName);
	Case 1  // Inspection
		Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, IMPORTED,DB_NAME) Values (:ls_FileName, :ll_FSize, :g_obj.InspID, 1, :ls_DBName);
	Case 2  // Summary
		Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, SM_ID, IMPORTED,DB_NAME) Values (:ls_FileName, :ll_FSize, :g_obj.InspID, :g_Obj.ObjID, 1, :ls_DBName);
End Choose

If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not create new attachment in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Rollback;	
	Return
End If

Select Max(ATT_ID) into :ll_AttID from VETT_ATT where (INSP_ID = :g_Obj.InspID) and (FILESIZE = :ll_FSize) and (FILENAME = :ls_FileName);

If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not save file in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Rollback;	
	dw_att.Retrieve(g_obj.InspID)
	dw_att.SelectRow(0, False)
	dw_att.SelectRow(dw_Att.GetRow(), True)
	Return
End If

ln_Att = Create n_VimsAtt    // Object to save attachment in FILES database

If ln_Att.of_Connect("") < 1 then 
	Rollback;
	Destroy ln_Att
	Messagebox("DB Error", "Could not save file in database.", Exclamation!)
	dw_att.Retrieve(g_obj.InspID)
	dw_att.SelectRow(0, False)
	dw_att.SelectRow(dw_Att.GetRow(), True)	
	Return
End If

If ln_Att.of_AddAtt("VETT_ATT", ll_AttID, lblob_File, ll_FSize) < 0 then
	ln_Att.of_Commit(False)	
	Rollback;
	Destroy ln_Att
	dw_att.Retrieve(g_obj.InspID)
	dw_att.SelectRow(0, False)
	dw_att.SelectRow(dw_Att.GetRow(), True)
	Messagebox("DB Error", "Could not save file in database.", Exclamation!)
	Return
End If

ln_Att.of_Commit(True)
Commit;

Destroy ln_Att    // ln_Att closes connection (for FILES DB) when destroying itself


dw_att.Retrieve(g_obj.InspID)

Commit; 

Messagebox("File Attached", "The selected file was attached successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,##0") + " Bytes")

cb_Del.Enabled = True
cb_Ren.Enabled = True
cb_save.Enabled = True
cb_view.Enabled = True

If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True

guo_Global.of_AddInspHist(g_obj.Inspid, 5, ls_FileName) // Add to hist

guo_Global.of_UpdateLastEdit(g_Obj.InspID)   // Update LastEdit

w_inspdetail.dw_insp.Retrieve(g_Obj.InspID)  // Retrieve header
end event

type cb_del from commandbutton within w_attlist
integer x = 1499
integer y = 1296
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
string text = "Delete"
end type

event clicked;Long ll_AttID
String ls_FileName
n_VimsAtt ln_Att

If MessageBox("Delete Attachment", "Are you sure you want to delete the selected attachment?", Question!, YesNo!) = 2 then Return

SetPointer(HourGlass!)

ll_AttID = dw_Att.GetItemNumber(dw_Att.GetRow(), "Att_ID")
ls_FileName = dw_Att.GetItemString(dw_Att.GetRow(), "FileName")

Delete from VETT_ATT where ATT_ID = :ll_AttID;

If SQLCA.Sqlcode <> 0 then
	Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
Else
	If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
End If

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 1 then 
	Rollback;
	Destroy ln_Att
	Messagebox ("DB Error", "Unable to connect to the attachment database.", Exclamation!)
	Return
End If

If ln_Att.of_Deleteatt( "VETT_ATT", ll_AttID) < 0 then 
	ln_Att.of_Commit(False)
	Rollback;
	Messagebox ("DB Error", "Unable to delete the attachment.", Exclamation!)
	Destroy ln_Att
	Return	
End If

ln_Att.of_Commit(True)

Commit;

Destroy ln_Att

dw_att.Retrieve(g_obj.InspID)

Commit;



MessageBox("Deleted", "The attachment was successfully deleted.")

If dw_att.Rowcount( ) = 0 then 
	cb_Del.Enabled = False
	cb_Ren.Enabled = False
	cb_Save.Enabled = False
	cb_view.Enabled = False
End If

guo_Global.of_AddInspHist(g_obj.Inspid, 6, ls_FileName) // Add to hist

guo_Global.of_UpdateLastEdit(g_obj.InspID)   // Update LastEdit

w_inspdetail.dw_insp.Retrieve(g_obj.InspID)  // Retrieve header
end event

type cb_save from commandbutton within w_attlist
integer x = 18
integer y = 1296
integer width = 329
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Extract..."
end type

event clicked;String ls_FPath, ls_FileName
Long ll_FSize, ll_AttID, ll_NumFiles
Integer li_Count
n_vimsatt ln_att

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
	ln_att = create n_vimsatt
	ll_AttID = dw_att.GetItemNumber(ll_FSize, "Att_ID")
	ll_FSize = ln_att.of_SaveAttachment(ll_AttID, ls_FPath)
	Destroy ln_att
	If ll_FSize < 0 then 
		MessageBox("Attachment Error", "Unable to save attachment.")		
		Return
	End If
	If Messagebox("Attachment Saved", "The attachment was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,###,##0") + " Bytes~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return
	ShellExecute( Handle(Parent), "open", ls_FPath, "", "", 3)
Else
	ll_NumFiles = 0
	If GetFolder("Select location to save", ls_FPath) = 1 then  // get folder to save
	  ln_att = create n_vimsatt
		If Right(ls_FPath,1) <> "\" then ls_FPath += "\"
		For li_Count=1 to dw_Att.Rowcount( )
			If dw_Att.GetItemNumber(li_Count, "Sel")>0 or li_Count = dw_Att.GetRow() then 
				ls_FileName = dw_Att.GetItemString(li_Count, "FileName")
				ll_AttID = dw_att.GetItemNumber(li_Count, "Att_ID")
				If FileExists(ls_FPath + ls_FileName) then
					If Messagebox("Confirm Overwrite", "The file " + ls_FPath + ls_FileName + " already exists.~n~nDo you want to overwrite this file?", Question!, YesNo!) = 1 then
						ll_FSize = ln_att.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
						If ll_FSize>0 then ll_NumFiles ++
					End If			
				Else
					ll_FSize = ln_att.of_saveattachment(ll_AttID, ls_FPath + ls_FileName)
					If ll_FSize>0 then ll_NumFiles ++
				End If			
			End If
		Next	
		Destroy n_vimsatt
		Messagebox("Attachment Saved", "Number of attachments extracted successfully : " + String(ll_NumFiles))
	End If
End If


end event

type cb_close from commandbutton within w_attlist
integer x = 677
integer y = 1408
integer width = 402
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
g_obj.Noteid = dw_att.Rowcount( )  // Pass back number of attachments

Close(Parent)
end event

type dw_att from datawindow within w_attlist
integer x = 18
integer y = 16
integer width = 1719
integer height = 1264
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_attlist"
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

type ln_1 from line within w_attlist
long linecolor = 33554432
integer linethickness = 4
integer beginx = 18
integer beginy = 1392
integer endx = 1847
integer endy = 1392
end type

