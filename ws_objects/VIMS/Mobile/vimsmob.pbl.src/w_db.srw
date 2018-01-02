$PBExportHeader$w_db.srw
forward
global type w_db from window
end type
type st_msg from statictext within w_db
end type
type st_newdate from statictext within w_db
end type
type st_7 from statictext within w_db
end type
type st_new from statictext within w_db
end type
type st_5 from statictext within w_db
end type
type hpb_prg from hprogressbar within w_db
end type
type st_4 from statictext within w_db
end type
type st_olddate from statictext within w_db
end type
type st_issue from statictext within w_db
end type
type st_2 from statictext within w_db
end type
type st_1 from statictext within w_db
end type
type gb_1 from groupbox within w_db
end type
end forward

global type w_db from window
integer width = 2647
integer height = 776
boolean titlebar = true
string title = "Database Update"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "Database!"
boolean center = true
st_msg st_msg
st_newdate st_newdate
st_7 st_7
st_new st_new
st_5 st_5
hpb_prg hpb_prg
st_4 st_4
st_olddate st_olddate
st_issue st_issue
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_db w_db

type variables

n_filepackage invo_pkg
 
end variables

forward prototypes
public subroutine wf_updatedb ()
end prototypes

public subroutine wf_updatedb ();
Integer li_Temp, li_DBVer, li_DBCurrent
Long ll_Row, ll_Total
String ls_SQL, ls_DBDate
Boolean lbool_Error
Datastore lds_SQL

SetPointer(HourGlass!)
st_Msg.Text = "Unpacking files. Please wait..."
Yield()

li_Temp = invo_pkg.Unpackfiles(g_Obj.ParamString, g_Obj.TempFolder )

If li_Temp < 0 then
	Messagebox("Update Error", "Could not unpack update files. The update file may be missing or corrupt.", Exclamation!)
	Close(This)
	f_Write2Log("wf_UpdateDB > invo_pkg.UnPackFiles() Failed")
	Return
End If

Execute Immediate "Begin Tran";

If SQLCA.SQLCode < 0 then
	Messagebox("DB Update", "Could not start DB transaction. Unable to update the database.", Exclamation!)
	f_Write2Log("wf_UpdateDB > Begin Tran Failed")
	Close(This)
	Return
End If

lbool_Error = False
st_Msg.Text = "Checking DB Issue. Please wait..."
Yield()

// First, check for DB Issue version
If Fileexists(g_Obj.TempFolder + 'db_id.vdbxp') then
	li_Temp = FileOpen (g_Obj.TempFolder + 'DB_ID.vdbxp', LineMode!, Read!, LockReadWrite!, Replace!, EncodingUTF8!)
	If (li_Temp <= 0) then
		ls_SQL = "Could not open DB ID File"
		lbool_Error = True
	Else
		FileReadEx(li_Temp, ls_SQL)
		FileReadEx(li_Temp, ls_SQL)
		If Len(ls_SQL) <> 19 then
			ls_SQL = "Invalid DB Issue Date"
			st_newdate.Text = "<Invalid Date>"
			lbool_Error = True
		Else
			ls_DBDate = Right(ls_SQL, 11)	
			st_newdate.Text = ls_DBDate
		End If	
		FileReadEx(li_Temp, ls_SQL)
		li_DBVer = Integer(Right(ls_SQL, 2))	
		st_new.Text = String(li_DBVer, '00')
		FileReadEx(li_Temp, ls_SQL)
		FileReadEx(li_Temp, ls_SQL)
		ll_Total = Integer(Right(ls_SQL, Len(ls_SQL) - 6))
		f_Config('DBVR', ls_SQL, 0)
		li_DBCurrent = integer(ls_SQL)
		st_issue.Text = String(li_DBCurrent, '00')
		f_Config('DBDT', ls_SQL, 0)
		st_olddate.Text = ls_SQL
		If li_DBVer <= li_DBCurrent then
			lbool_Error = True
			ls_SQL = 'DB Issue ' + string(li_DBVer) + ' is already loaded or is an older issue.'
		End If
		If (li_DBVer > li_DBCurrent + 1) and (li_DBCurrent > 0) then
			lbool_Error = True
			ls_SQL = 'Cannot upgrade to DB Issue ' + string(li_DBVer) + ' from DB Issue ' + String(li_DBCurrent) + '. Updates must be applied in sequence.'
		End If
		FileClose(li_Temp)	
		Yield()		
		f_Write2Log("wf_UpdateDB > DB Issue: " + String(li_DBVer))
	End If
	FileDelete(g_Obj.TempFolder + 'db_id.vdbxp')
Else
	lbool_Error = True
	ls_SQL = "DB ID File not found in package"
	f_Write2Log("wf_UpdateDB > DB ID File not found")
End If

hpb_prg.MaxPosition = ll_Total

// Check for any SQL DDL
If FileExists(g_Obj.TempFolder + 'sql.vdbxp') and Not lbool_Error then
	st_Msg.Text = "Running DDL. Please wait..."
	Yield()	
	lds_SQL = Create Datastore
	lds_SQL.DataObject = "d_sq_tb_sqlissue"
	lds_SQL.SetTransObject(SQLCA)
	If lds_SQL.Importfile(XML!, g_Obj.TempFolder + 'sql.vdbxp') > 0 then
		For li_Temp = 1 to lds_SQL.RowCount( )
			ls_SQL = lds_SQL.GetItemString(li_Temp, 'value')
			Execute Immediate :ls_SQL;
			If SQLCA.SQLCode < 0 then 
				lbool_Error = True
				ls_SQL = 'Error in sql.vdbxp. Row ' + String(li_Temp) + '.'
				f_Write2Log("wf_UpdateDB > Error in sql.vdbxp; Row: " + String(li_Temp))
				Exit
			End If
			hpb_prg.StepIt( )
		Next
	End If
	Destroy lds_SQL
End If
FileDelete(g_Obj.TempFolder + 'sql.vdbxp')

If not lbool_Error then 
	st_Msg.Text = "Updating database tables. Please wait..."
	Yield()
End If

// Update Vessels
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Vessels.vdbxp', 'd_sq_tb_io_vessel', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in vessels.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Vessels.vdbxp')

// Update Countries
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Country.vdbxp', 'd_sq_tb_io_country', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in country.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Country.vdbxp')

// Update Ports
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Ports.vdbxp', 'd_sq_tb_io_ports', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in ports.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Ports.vdbxp')

// Update Insp Models
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'InspModel.vdbxp', 'd_sq_tb_io_inspmodel', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in inspmodel.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'InspModel.vdbxp')

// Update Notes
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Notes.vdbxp', 'd_sq_tb_io_notes', hpb_prg, 'note_text')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in notes.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Notes.vdbxp')

// Update Text
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Text.vdbxp', 'd_sq_tb_io_text', hpb_prg, 'textdata')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in Text.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Text.vdbxp')

// Update Obj
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Obj.vdbxp', 'd_sq_tb_io_Obj', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in Obj.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Obj.vdbxp')

// Update Insp SmTypes
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'SmTypes.vdbxp', 'd_sq_tb_io_summarytypes', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in SmTypes.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'SmTypes.vdbxp')

// Update Insp Comp
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Comp.vdbxp', 'd_sq_tb_io_comp', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in Comp.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Comp.vdbxp')

// Update Cause
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Cause.vdbxp', 'd_sq_tb_io_cause', hpb_prg, '') 
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in Cause.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Cause.vdbxp')

// Update Resp
li_Temp = 0
If Not lbool_Error then li_Temp = invo_pkg.updatetable(g_Obj.TempFolder + 'Resp.vdbxp', 'd_sq_tb_io_resp', hpb_prg, '')
If li_Temp < 0 then 
	lbool_Error = True
	ls_SQL = 'Error in Resp.vdbxp'
End If
FileDelete(g_Obj.TempFolder + 'Resp.vdbxp')

// Update Config
If Not lbool_Error then
	ls_SQL = String(li_DBVer, "00")
	li_Temp = f_Config("DBVR", ls_SQL, 1)
	If li_Temp < 0 then 
		lbool_Error = True
		ls_SQL = 'DB Config Update Error'
	Else
		f_Config("DBDT", ls_DBDate, 1)
	End If	
End If

If lbool_Error then
	Execute Immediate "Rollback Tran;";
   f_Write2Log("wf_UpdateDB > " + ls_SQL)
	st_Msg.Text = "Database update error"
	f_CreateCommPackage("DBST" + String(g_Obj.VesselIMO), "DB Update Failed: " + ls_SQL)
	Messagebox("Update Failed", "The database update failed.~n~n" + ls_SQL + "~n~nA failure code has been created.", Exclamation!)
Else
	Execute Immediate "Commit Tran;";
	g_Obj.DBVer = li_DBVer
  f_Write2Log("wf_UpdateDB > Update Successful")
	st_Msg.Text = "Database update completed"
	f_CreateCommPackage("DBST" + String(g_Obj.VesselIMO), "DB Update Success (Issue " + String(li_DBVer) + ")")
	Messagebox("Update Successful", "The database was updated successfully.")
End If

FileDelete(g_Obj.TempFolder + 'Pkg.vtmp')

w_Back.wf_Calc()

Close(This)
end subroutine

on w_db.create
this.st_msg=create st_msg
this.st_newdate=create st_newdate
this.st_7=create st_7
this.st_new=create st_new
this.st_5=create st_5
this.hpb_prg=create hpb_prg
this.st_4=create st_4
this.st_olddate=create st_olddate
this.st_issue=create st_issue
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_msg,&
this.st_newdate,&
this.st_7,&
this.st_new,&
this.st_5,&
this.hpb_prg,&
this.st_4,&
this.st_olddate,&
this.st_issue,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_db.destroy
destroy(this.st_msg)
destroy(this.st_newdate)
destroy(this.st_7)
destroy(this.st_new)
destroy(this.st_5)
destroy(this.hpb_prg)
destroy(this.st_4)
destroy(this.st_olddate)
destroy(this.st_issue)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
f_Write2Log("w_DB Open")

Post wf_UpdateDB()
end event

type st_msg from statictext within w_db
integer x = 55
integer y = 336
integer width = 2523
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388736
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_newdate from statictext within w_db
integer x = 1298
integer y = 192
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "-"
boolean focusrectangle = false
end type

type st_7 from statictext within w_db
integer x = 1079
integer y = 192
integer width = 219
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dated:"
boolean focusrectangle = false
end type

type st_new from statictext within w_db
integer x = 786
integer y = 192
integer width = 110
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "-"
boolean focusrectangle = false
end type

type st_5 from statictext within w_db
integer x = 91
integer y = 192
integer width = 585
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Database Issue:"
boolean focusrectangle = false
end type

type hpb_prg from hprogressbar within w_db
integer x = 91
integer y = 560
integer width = 2450
integer height = 64
unsignedinteger maxposition = 1000
integer setstep = 1
boolean smoothscroll = true
end type

type st_4 from statictext within w_db
integer x = 91
integer y = 480
integer width = 768
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update Progress:"
boolean focusrectangle = false
end type

type st_olddate from statictext within w_db
integer x = 1298
integer y = 96
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "-"
boolean focusrectangle = false
end type

type st_issue from statictext within w_db
integer x = 786
integer y = 96
integer width = 110
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "-"
boolean focusrectangle = false
end type

type st_2 from statictext within w_db
integer x = 1079
integer y = 96
integer width = 256
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dated:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_db
integer x = 91
integer y = 96
integer width = 677
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Database Issue:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_db
integer x = 18
integer width = 2597
integer height = 672
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

