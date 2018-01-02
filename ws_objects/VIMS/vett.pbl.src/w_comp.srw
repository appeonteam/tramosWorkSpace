$PBExportHeader$w_comp.srw
forward
global type w_comp from window
end type
type st_db from statictext within w_comp
end type
type p_db from picture within w_comp
end type
type cb_reset from commandbutton within w_comp
end type
type cb_update from commandbutton within w_comp
end type
type cb_del from commandbutton within w_comp
end type
type cb_new from commandbutton within w_comp
end type
type dw_list from datawindow within w_comp
end type
type dw_details from datawindow within w_comp
end type
type gb_1 from groupbox within w_comp
end type
type gb_2 from groupbox within w_comp
end type
end forward

global type w_comp from window
integer width = 2825
integer height = 2560
boolean titlebar = true
string title = "Vetting / Inspection Companies"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Comp.ico"
boolean center = true
st_db st_db
p_db p_db
cb_reset cb_reset
cb_update cb_update
cb_del cb_del
cb_new cb_new
dw_list dw_list
dw_details dw_details
gb_1 gb_1
gb_2 gb_2
end type
global w_comp w_comp

type variables

Integer ii_ReadOnly

DateTime idt_DBIssue
end variables

on w_comp.create
this.st_db=create st_db
this.p_db=create p_db
this.cb_reset=create cb_reset
this.cb_update=create cb_update
this.cb_del=create cb_del
this.cb_new=create cb_new
this.dw_list=create dw_list
this.dw_details=create dw_details
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_db,&
this.p_db,&
this.cb_reset,&
this.cb_update,&
this.cb_del,&
this.cb_new,&
this.dw_list,&
this.dw_details,&
this.gb_1,&
this.gb_2}
end on

on w_comp.destroy
destroy(this.st_db)
destroy(this.p_db)
destroy(this.cb_reset)
destroy(this.cb_update)
destroy(this.cb_del)
destroy(this.cb_new)
destroy(this.dw_list)
destroy(this.dw_details)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;String ls_Value

ii_ReadOnly = 1  // read-only mode

dw_list.SetTransObject(SQLCA)
dw_details.SetTransObject(SQLCA)

If (g_obj.Access >= 2) and (g_Obj.DeptID = 1) then  // If RW or above and Vetting Dept
	cb_New.Enabled = True
	ii_Readonly = 0
End If

If f_Config("DBLI", ls_Value, 0) = 0 then idt_DBIssue = DateTime(ls_Value) else SetNull(idt_DBIssue)

dw_list.Retrieve(idt_DBIssue)
end event

event closequery;
If cb_update.Enabled then
	MessageBox ("Details Modified", "You have made changes to the selected company. Please Update or Reset before closing this window.", Exclamation!)
	Return 1
End If
end event

type st_db from statictext within w_comp
integer x = 1957
integer y = 1088
integer width = 805
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Company is new or name has been modified since last DB Issue"
boolean focusrectangle = false
end type

type p_db from picture within w_comp
integer x = 1865
integer y = 1088
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\Exclamation.gif"
boolean focusrectangle = false
end type

type cb_reset from commandbutton within w_comp
integer x = 2286
integer y = 1248
integer width = 311
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Reset"
end type

event clicked;
dw_details.Reselectrow( dw_Details.GetRow() )

cb_Update.Enabled = False
cb_Reset.Enabled = False

end event

type cb_update from commandbutton within w_comp
integer x = 1975
integer y = 1248
integer width = 311
integer height = 80
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Update"
end type

event clicked;String ls_Data
Boolean lb_Name = False

dw_details.Accepttext( )

If dw_details.GetItemStatus(1, "name", Primary!) = DataModified! then
	If Messagebox("Warning", "You have made changes to the name of the company. This will require you to issue a database update for VIMS Mobile.~n~nAre you sure you want to update?", Question!, YesNo!) = 2 then Return
	lb_Name = True   // Name of company has changed
End If

If dw_details.Update( ) = 1 then
	Commit;
	This.Enabled = False
	cb_Reset.Enabled = False
	Messagebox ("Updated", "Details were updated successfully.")
	dw_list.Reselectrow(dw_list.GetRow())
	If lb_Name Then		 // If name was changed
		If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
			ls_Data = "1"
			If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
		End If
		p_DB.Visible = True
		st_DB.Visible = True
		dw_list.SetItem(dw_list.GetRow(), "InDB", 0)
		dw_Details.SetItem(1, "NameModified", Today())
		dw_Details.SetItem(1, "NameModifiedBy", g_Obj.UserID)
	End If
Else
	Rollback;
	Messagebox ("Update Error", "Details could not be updated successfully.", Exclamation!)
End If
end event

type cb_del from commandbutton within w_comp
integer x = 366
integer y = 1104
integer width = 311
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;String ls_Data

If cb_update.Enabled then
	MessageBox ("Details Modified", "You have made changes to the selected company. Please Update or Reset before deleting this company.", Exclamation!)
	Return
End If

If MessageBox("Confirm Delete", "Deleting a company may have a serious impact on the VIMS Mobile database if it contains inspections performed by the company. This step cannot be undone.~n~nAre you absolutely sure you want the delete this company?", Question!, YesNo!)= 2 then Return

dw_list.DeleteRow(dw_list.GetRow())

If dw_list.Update() = 1 then
	Commit;
	MessageBox("Deleted", "The company was deleted successfully.")
	if dw_list.Rowcount( ) > 0 then
		dw_details.Retrieve( dw_list.GetItemNumber(dw_list.GetRow(), "Comp_ID"), 0)
	else
		dw_details.Retrieve(0, 0)
		This.Enabled = False
	End If
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If
Else
	Rollback;
	MessageBox("Delete Error", "The company could not be deleted successfully.",Exclamation!)
	dw_list.Retrieve(idt_DBIssue)
End IF
end event

type cb_new from commandbutton within w_comp
integer x = 55
integer y = 1104
integer width = 311
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "New"
end type

event clicked;
Integer li_row
String ls_Data

If cb_update.Enabled then
	MessageBox ("Details Modified", "You have made changes to the selected company. Please Update or Reset before creating a new company.", Exclamation!)
	Return
End If

If Messagebox("Warning", "Any changes to this table will require a database update to be issued for VIMS Mobile. ~n~nAre you sure you want to create a new company?", Question!, YesNo!) = 2 then Return

SetPointer(HourGlass!)

li_row = dw_list.InsertRow(0)

If li_row > 0 then
	dw_list.SetItem(li_row, "Name", "New Company")
	dw_list.SetItem(li_row, "NameModifiedBy", g_Obj.UserID)
	dw_list.SetItem(li_row, "NameModified", DateTime(Today(), Now()))
	dw_list.ScrollTorow(li_row)
Else
	MessageBox ("Error", "Could not add new company.",Exclamation!)
	Return
End If

If dw_list.Update( ) = 1 then
	Commit;
	dw_list.SetRow(li_row)
	dw_details.Retrieve(dw_list.GetItemNumber( li_row, "COMP_ID"), 0)
	cb_del.Enabled = True 
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If
	p_DB.Visible = True
	st_DB.Visible = True
Else
	Rollback;
	Messagebox ("DB Error", "Could not update DB", Exclamation!)
	dw_list.Retrieve(idt_DBIssue)
End If
end event

type dw_list from datawindow within w_comp
integer x = 55
integer y = 96
integer width = 2688
integer height = 992
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_comp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
If Currentrow > 0 then 
	dw_details.Retrieve(This.GetItemNumber(currentrow, "Comp_ID"), ii_ReadOnly)
	If dw_list.GetItemNumber(currentrow, "InDB")=0 then
		p_DB.Visible = True
		st_DB.Visible = True
	Else
		p_DB.Visible = False
		st_DB.Visible = False		
	End If
End If

This.Setredraw(False)
This.Setredraw(True)

end event

event rowfocuschanging;
If cb_update.Enabled then
	MessageBox ("Details Modified", "You have made changes to the selected company. Please Update or Reset before selecting another company.", Exclamation!)
	Return 1
End If
end event

event retrieveend;
If (rowcount > 0) and (ii_ReadOnly = 0) then cb_del.Enabled = True   
end event

type dw_details from datawindow within w_comp
integer x = 37
integer y = 1344
integer width = 2706
integer height = 1072
integer taborder = 80
string title = "none"
string dataobject = "d_sq_ff_comp"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;
If ii_Readonly = 0 then
	cb_update.Enabled = True
	cb_Reset.Enabled = True
End If
end event

event buttonclicked;Integer li_CompID
String ls_FPath, ls_FileName
Integer li_FileNum
Blob lblob_File
Long ll_FSize
n_VimsAtt ln_Att

If (dwo.name = "b_att") or (dwo.name = "b_rem") then
	If cb_update.Enabled then
		Messagebox("Save Changes", "Please udpdate or reset all other changes before attaching or removing a document.", Exclamation!)
		Return
	End If
End If

li_CompID = This.GetItemNumber(1, "Comp_ID")

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 1 then
	Destroy ln_Att
	Messagebox("DB Error", "Unable to connect to attachment database!", Exclamation!)
	Return
End If

If dwo.name = "b_att" then //  Attach item
	SetPointer(HourGlass!)	
	
	// Get filename
	If GetFileOpenName("Add Attachment", ls_FPath, ls_FileName, "", "All Files (*.*),*.*", "", 16402) < 1 then 
		Destroy ln_Att
		Return
	End If
	
	// Open file
	li_FileNum = Fileopen( ls_FPath, StreamMode!)
	
	If li_FileNum <0 then 
		MessageBox ("File I/O Error", "Could not open the selected file. Please check that the file is accessible and not in use.",Exclamation!)
		Destroy ln_Att
		Return
	End If
	
	// Read file into blob
	ll_FSize = FileReadEx(li_FileNum, lblob_File)
	
	If ll_FSize < 1 then
		FileClose(li_FileNum)
		MessageBox("File I/O Error", "Could not read the selected file.",Exclamation!)
		Destroy ln_Att
		Return
	End If
	
	FileClose(li_FileNum)
	
	// Save file name
	Update VETT_COMP Set ATTNAME = :ls_FileName Where COMP_ID = :li_CompID ;
	
	If SQLCA.Sqlcode <> 0 then
		Messagebox("DB Error", "Could save file name in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
		Rollback;
		Destroy ln_Att
		Return
	End If
		
	// Save file		
    If ln_Att.of_AddAtt("VETT_COMP", li_CompID, lblob_File, ll_FSize) < 0 then
		ln_Att.of_Commit(False)
		Rollback;
		Destroy ln_Att
		Messagebox("DB Error", "Could not save file in database.", Exclamation!)
		Return
	End If

	ln_Att.of_Commit(True)
	Commit;
	
	dw_details.Retrieve(li_CompID, ii_ReadOnly )
	
	Commit; 
	
	Messagebox("File Attached", "The selected file was attached successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,##0") + " Bytes")
End If

If dwo.name = "b_rem" then  // Remove attachment

	If MessageBox("Remove Attachment", "Are you sure you want to remove this attachment?", Question!, YesNo!) = 2 then Return

	SetPointer(HourGlass!)
		
	Update VETT_COMP Set ATTNAME = Null, ATTACH = Null Where COMP_ID = :li_CompID;
	
	If SQLCA.Sqlcode <> 0 then		
		Rollback;
		Destroy ln_Att
		Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
		Return
	End If
	
	If ln_Att.of_DeleteAtt("VETT_COMP", li_CompID)<0 then 
		ln_Att.of_Commit(False)
		Rollback;
		Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
		Return		
	End If
	
	ln_Att.of_Commit(True)
	Commit;
	
	dw_details.Retrieve(li_CompID, ii_ReadOnly )
	
	Commit;
	
	MessageBox("Deleted", "The attachment was successfully deleted.")	
	
End If

If dwo.name = "b_ext" then  // Extract attachment

	SetPointer(HourGlass!)
	
	If ln_Att.of_GetAtt("VETT_COMP", li_CompID, lblob_File) < 1 then
		Messagebox("DB Error", "Could not retrieve file from database.", Exclamation!)
		Destroy ln_Att
		Return
	End If
		
	ls_FileName = dw_Details.GetItemString(1, "AttName")
	ls_FPath = ""
	
	If GetFolder("Select the folder where you wish to save this attachment:", ls_FPath) < 1 then Return
	
	If Right(ls_FPath,1) <> "\" then ls_FPath += "\"
	ls_FPath +=ls_FileName
	
	li_FileNum = Fileopen( ls_FPath, StreamMode!, Write!, LockReadWrite!, Replace!)
	
	If li_FileNum <0 then 
		MessageBox ("File I/O Error", "Could not create a file handle. Please check if you have permission to create this file at the specified location.",Exclamation!)
		Destroy ln_Att
		Return
	End If
	
	ll_FSize = FileWriteEx(li_FileNum, lblob_File)
	
	If ll_FSize < 1 then
		FileClose(li_FileNum)
		Destroy ln_Att
		MessageBox("File I/O Error", "Could not write to the file.",Exclamation!)
		Return
	End If
	
	FileClose(li_FileNum)
	
	If Messagebox("Attachment Saved", "The attachment was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize/1024, "#,##0") + " KB~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return
	
	ShellExecute( Handle(Parent), "open", ls_FPath, "", "", 3)
	
End If

Destroy ln_Att
	
end event

event doubleclicked;
If dwo.Type <> "column" then Return

If dwo.Tag <> "TX" then Return

If ii_ReadOnly = 1 then Return

Yield()

This.Accepttext( )
g_obj.ObjString = This.GetItemString(1, String(dwo.name))
Open(w_textedit)
If Not IsNull(g_obj.ObjString) then 
	This.SetItem(1, String(dwo.name), g_obj.ObjString)
	This.event editchanged(1, dwo, g_obj.ObjString)
End If
end event

event itemchanged;
If ii_Readonly = 0 then
	cb_update.Enabled = True
	cb_Reset.Enabled = True
End If
end event

event clicked;
If dwo.name = "p_att" then	This.event buttonclicked(1, 0, This.Object.b_Ext)

end event

event retrieveend;
If ii_ReadOnly=1 and rowcount=1 Then
	this.object.name.edit.displayonly='Yes'
	this.object.addr.edit.displayonly='Yes'
	this.object.contact.edit.displayonly='Yes'
	this.object.phone.edit.displayonly='Yes'
	this.object.email.edit.displayonly='Yes'
	this.object.website.edit.displayonly='Yes'
	this.object.coverage.edit.displayonly='Yes'
	this.object.cost.edit.displayonly='Yes'
	this.object.matrix.edit.displayonly='Yes'
	this.object.req.edit.displayonly='Yes'
End If
end event

type gb_1 from groupbox within w_comp
integer x = 18
integer y = 16
integer width = 2761
integer height = 1216
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Company List"
end type

type gb_2 from groupbox within w_comp
integer x = 18
integer y = 1248
integer width = 2761
integer height = 1200
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Details"
end type

