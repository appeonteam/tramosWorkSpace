$PBExportHeader$w_sqlissue.srw
forward
global type w_sqlissue from window
end type
type cb_pack from commandbutton within w_sqlissue
end type
type cb_save from commandbutton within w_sqlissue
end type
type cb_issue from commandbutton within w_sqlissue
end type
type cb_unpack from commandbutton within w_sqlissue
end type
type cb_sqlpack from commandbutton within w_sqlissue
end type
type cb_close from commandbutton within w_sqlissue
end type
type cb_clear from commandbutton within w_sqlissue
end type
type cb_addrow from commandbutton within w_sqlissue
end type
type st_1 from statictext within w_sqlissue
end type
type dw_sql from datawindow within w_sqlissue
end type
type cb_import from commandbutton within w_sqlissue
end type
end forward

global type w_sqlissue from window
integer width = 3287
integer height = 1984
boolean titlebar = true
string title = "DDL Instructions"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_pack cb_pack
cb_save cb_save
cb_issue cb_issue
cb_unpack cb_unpack
cb_sqlpack cb_sqlpack
cb_close cb_close
cb_clear cb_clear
cb_addrow cb_addrow
st_1 st_1
dw_sql dw_sql
cb_import cb_import
end type
global w_sqlissue w_sqlissue

type variables

n_filepackage invo_ddl
end variables

on w_sqlissue.create
this.cb_pack=create cb_pack
this.cb_save=create cb_save
this.cb_issue=create cb_issue
this.cb_unpack=create cb_unpack
this.cb_sqlpack=create cb_sqlpack
this.cb_close=create cb_close
this.cb_clear=create cb_clear
this.cb_addrow=create cb_addrow
this.st_1=create st_1
this.dw_sql=create dw_sql
this.cb_import=create cb_import
this.Control[]={this.cb_pack,&
this.cb_save,&
this.cb_issue,&
this.cb_unpack,&
this.cb_sqlpack,&
this.cb_close,&
this.cb_clear,&
this.cb_addrow,&
this.st_1,&
this.dw_sql,&
this.cb_import}
end on

on w_sqlissue.destroy
destroy(this.cb_pack)
destroy(this.cb_save)
destroy(this.cb_issue)
destroy(this.cb_unpack)
destroy(this.cb_sqlpack)
destroy(this.cb_close)
destroy(this.cb_clear)
destroy(this.cb_addrow)
destroy(this.st_1)
destroy(this.dw_sql)
destroy(this.cb_import)
end on

event open;
dw_sql.SetTransobject(SQLCA)
If dw_sql.Retrieve( )<0 then Messagebox("SQL", "Retrieve failed")
end event

type cb_pack from commandbutton within w_sqlissue
integer x = 549
integer y = 1808
integer width = 530
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Pack Files"
end type

event clicked;n_filepackage lnvo_pk
String ls_File, ls_Path

If GetFolder("Select Folder to pack:", ls_Path) = 1 then
	
	If Right(ls_Path,1) <> "\" then ls_Path += "\"
	
	ChangeDirectory(g_Obj.Appfolder)
	
	If lnvo_pk.Packfiles("Packed", ls_Path, ls_Path) < 0 then Messagebox("Error", "PackFiles() returned an error.")

End If
end event

type cb_save from commandbutton within w_sqlissue
integer x = 823
integer y = 1632
integer width = 402
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;
If dw_sql.Update( ) = 1 then 
	Messagebox("SQL", "DDL Saved")
Else
	Messagebox("SQL", "Update failed")
End If
end event

type cb_issue from commandbutton within w_sqlissue
integer x = 1225
integer y = 1632
integer width = 402
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Issue DB DDL"
end type

event clicked;String ls_Path
Integer li_IDFile
Long ll_TotalRows
n_filepackage lnvo_fPack

If GetFolder("Select the folder where the DB update will be created:", ls_Path) < 1 then Return -1

If Right(ls_Path,1) <> "\" then ls_Path += "\"

SetPointer(HourGlass!)

// Export to XML
ll_TotalRows = dw_sql.SaveAs(ls_Path + 'SQL.vdbxp', XML!, False)

If ll_TotalRows <= 0 then
	Messagebox("No DDL", "No DDL found or an error occurred.")
	Return
End if

// Create identity file (to store DB information)
li_IDFile = FileOpen (ls_Path + 'DB_ID.vdbxp', LineMode!, Write!, LockReadWrite!, Replace!, EncodingUTF8!)
If (li_IDFile <= 0) then
	Messagebox("File Error", "Unable to create DB ID File. The update could not be created.", Exclamation!)
	Return
End If
FileWriteEx(li_IDFile, "DB Update ID File")   // Title
FileWriteEx(li_IDFile, "Issued: " + String(Today(), "dd mmm yyyy"))  // Date of issue
FileWriteEx(li_IDFile, "DBIssue: " + String(g_Obj.Level + 1))  // DB version
FileWriteEx(li_IDFile, "By: " + g_Obj.UserID)  // User
FileWriteEx(li_IDFile, "Rows: " + String(dw_sql.RowCount()))  // Total rows exported
If FileClose(li_IDFile) = -1 then
	Messagebox("File Error", "Unable to close DB ID File. The update could not be created.", Exclamation!)
	Return	
End If

If lnvo_fpack.PackFiles('db_' + String(g_Obj.Level + 1), ls_Path, ls_Path) = 0 then
	MessageBox("DB Update Created", "A new Database Update was created successfully in the selected folder.~n~nThis file must be sent to all VIMS Mobile installations.")	
Else
	MessageBox("File Error", "A new Database Update could not be issued. Please check the network/path selected.")	
	Return
End If

ls_Path = String(g_Obj.Level + 1)

If f_Config("DBVR", ls_Path, 1) = 0 then  // If version incremented successfully
	w_admin.tab_admin.tp4.st_dbver.Text = ls_Path
	ls_Path = String(Today(), "dd mmm yyyy")
	f_Config("DBLI", ls_Path, 1)
	w_admin.tab_admin.tp4.st_dblast.Text = ls_Path
	ls_Path = "0"
	f_Config("DBST", ls_Path, 1)
	w_admin.w_setdbstatus(0)
End If


end event

type cb_unpack from commandbutton within w_sqlissue
integer x = 18
integer y = 1808
integer width = 530
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Unpack Package"
end type

event clicked;
n_filepackage lnvo_pk
String ls_File, ls_Path

If GetFileOpenName("Select file to unpack:", ls_Path, ls_File) < 1 then Return

ChangeDirectory(g_Obj.AppFolder)

If lnvo_pk.Unpackfiles(ls_Path, Left(ls_Path, Len(ls_Path) - Len(ls_File))) < 0 then
	Messagebox("Error", "UnpackFiles() returned an error.")
End If
end event

type cb_sqlpack from commandbutton within w_sqlissue
integer x = 2688
integer y = 1632
integer width = 567
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Create Package"
end type

event clicked;String ls_Path

If dw_sql.RowCount( )> 99 then 
	Messagebox("SQL Limit", "Cannot pack more than 99 rows of SQL", Exclamation!)
	Return
End If

If GetFolder("Select folder to create package in:", ls_Path) < 1 then Return

If Right(ls_Path, 1) <> "\" then ls_Path += "\"

ChangeDirectory(g_Obj.AppFolder)

SetPointer(HourGlass!)

dw_sql.SaveAs(ls_Path + 'vimsdb.vdbxp', XML!, False)

If invo_ddl.PackFiles('sq', ls_Path, ls_Path) = 0 then
	MessageBox("DB DDL Created", "The DDL was packaged successfully.")	
Else
	MessageBox("File Error", "Packaging Error")	
End If
end event

type cb_close from commandbutton within w_sqlissue
integer x = 2688
integer y = 1776
integer width = 567
integer height = 112
integer taborder = 60
integer textsize = -10
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

type cb_clear from commandbutton within w_sqlissue
integer x = 421
integer y = 1632
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete All"
end type

event clicked;
If Messagebox("Confirm Delete", "Delete all rows?", Question!, YesNo!) = 1 then 
	Do While dw_SQL.RowCount() > 0
		dw_SQL.DeleteRow(1)
	Loop
End If

end event

type cb_addrow from commandbutton within w_sqlissue
integer x = 18
integer y = 1632
integer width = 402
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add New"
end type

event clicked;Integer li_Row

li_Row = dw_sql.RowCount()

If li_Row = 100 then 
	Messagebox("SQL Limit", "A maximum of 99 SQL statements can be issued at one time!", Exclamation!)
	Return
End If

li_Row = dw_Sql.InsertRow(0)

If li_Row < 0 then 
	Messagebox("DW Error", "Could not add row!", Exclamation!)
	Return
End If

dw_Sql.SetItem(li_Row, "C_ID", "SQ" + String(li_Row, '00'))
end event

type st_1 from statictext within w_sqlissue
integer x = 18
integer y = 16
integer width = 581
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "DDL Instructions:"
boolean focusrectangle = false
end type

type dw_sql from datawindow within w_sqlissue
integer x = 18
integer y = 80
integer width = 3237
integer height = 1552
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_sqlissue"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_import from commandbutton within w_sqlissue
integer x = 2121
integer y = 1632
integer width = 567
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Import vimsdb.xml"
end type

event clicked;String ls_File, ls_Path
Integer li_Row

If GetFileOpenName("Select xml file to import:", ls_File, ls_Path, "xml", "XML Files,*.xml") < 1 then Return

ChangeDirectory(g_Obj.AppFolder)

dw_sql.Reset( )

If dw_sql.ImportFile(XML!, ls_File) > 0 then
	cb_addrow.Enabled = False
	cb_SQLPack.Enabled = True
	For li_Row = 1 to dw_sql.RowCount()
		dw_sql.SetItem(li_Row, "C_ID", String(li_Row, "00"))
	Next
End If

end event

