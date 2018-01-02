$PBExportHeader$w_browser.srw
forward
global type w_browser from window
end type
type st_msg from statictext within w_browser
end type
type cb_clear from commandbutton within w_browser
end type
type cb_go from commandbutton within w_browser
end type
type sle_filter from singlelineedit within w_browser
end type
type st_1 from statictext within w_browser
end type
type cb_imp from commandbutton within w_browser
end type
type cb_new from commandbutton within w_browser
end type
type cb_export from commandbutton within w_browser
end type
type cb_del from commandbutton within w_browser
end type
type cb_rep from commandbutton within w_browser
end type
type cb_edit from commandbutton within w_browser
end type
type dw_insp from datawindow within w_browser
end type
type gb_2 from groupbox within w_browser
end type
end forward

global type w_browser from window
integer width = 4352
integer height = 2196
boolean titlebar = true
string title = "Inspection Browser"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Browse.ico"
boolean center = true
st_msg st_msg
cb_clear cb_clear
cb_go cb_go
sle_filter sle_filter
st_1 st_1
cb_imp cb_imp
cb_new cb_new
cb_export cb_export
cb_del cb_del
cb_rep cb_rep
cb_edit cb_edit
dw_insp dw_insp
gb_2 gb_2
end type
global w_browser w_browser

forward prototypes
public subroutine wf_setbuttons ()
public subroutine wf_extractatt (long al_attid)
public subroutine wf_refreshrow ()
public subroutine wf_openatt ()
end prototypes

public subroutine wf_setbuttons ();
If dw_insp.Rowcount() > 0 then
	If (g_Obj.Login > 0) then 
		cb_del.Enabled = True
		cb_Edit.Enabled = True
		cb_Export.Enabled = True
	End If
    cb_Rep.Enabled = True
Else
	cb_Del.Enabled = False
	cb_Edit.Enabled = False
	cb_Rep.Enabled = False
	cb_Export.Enabled = False
End If

end subroutine

public subroutine wf_extractatt (long al_attid);String ls_FPath, ls_FileName
Integer li_FileNum
Blob lblob_File
Long ll_FSize

ls_FPath = g_Obj.TempFolder + "Report.pdf"

SetPointer(HourGlass!)

li_FileNum = Fileopen(ls_FPath, StreamMode!, Write!, LockReadWrite!, Replace!)

If li_FileNum <0 then 
	MessageBox ("File I/O Error", "Could not create a file handle. Please check if you have permission to create this file at the specified location.",Exclamation!)
	Return
End If

Selectblob ATTDATA into :lblob_File from VETT_ATT where ATT_ID = :al_AttID;

If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not retrieve file from database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Return
End If

Commit;

ll_FSize = FileWriteEx(li_FileNum, lblob_File)

If ll_FSize < 1 then
	FileClose(li_FileNum)
	MessageBox("File I/O Error", "Could not write to the file.",Exclamation!)
	Return
End If

FileClose(li_FileNum)

//If Messagebox("Report Saved", "The report was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize/1024, "#,##0") + " KB~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return

ShellExecute( Handle(This), "open", ls_FPath, "", "", 3)

end subroutine

public subroutine wf_refreshrow ();// This function retrieves info for a single inspection and refreshes it (so no need for a complete retrieve)

Long ll_Row, ll_InspID, ll_Total, ll_IMO, ll_Open, ll_Valid
String ls_Port, ls_VName
Integer li_Status, li_New, li_Comm, li_Att, li_NullStars, li_SumStars, li_ValidStars
DateTime ld_InspDate

ll_Row = dw_insp.GetRow( )

ll_InspID = dw_insp.GetItemNumber(ll_Row, "Insp_ID")

SELECT VESSELIMO,
			(Select Top 1 VESSEL_NAME from VESSELS Where IMO_NUMBER = VESSELIMO and VESSEL_ACTIVE <> 0) as VNAME, 
         IsNull(PORT_N, '< ' + VETT_INSP.PORT + ' >') PORT_N,
         INSPDATE,  
				 STATUS,
			(Select Count(ANS) from VETT_ITEM Where (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID) and ANS = 1) As TOTAL,
			(Select Count(ANS) from VETT_ITEM Where (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID) and (ANS = 1) and (DEF = 1)) As VALID,
	 		(Select Count(ANS) from VETT_ITEM Where (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID) and (CLOSED = 0) AND (ANS=1)) As TOTAL,
         (Select Count(*) from VETT_ITEM Where VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID and VSLCOMM Is Not Null) as MVSLCOMM,
			(Select Count(*) from VETT_ATT Where VETT_ATT.INSP_ID = VETT_INSP.INSP_ID) as ATT,
         (Select Count(TIME_ID) from VETT_ITEMHIST Inner Join VETT_ITEM on VETT_ITEMHIST.ITEM_ID = VETT_ITEM.ITEM_ID Where (VETT_ITEMHIST.STATUS = 0) and (VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID)) as NEWCOMMENTS,
         (Select Sum(Case When STARS is Null Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as NULLSTARS,
   		(Select Sum(STARS) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as SUMSTARS,
   		(Select Sum(Case When STARS > 0 Then 1 Else 0 End) from VETT_INSPSM Where VETT_INSPSM.INSP_ID = VETT_INSP.INSP_ID) as VALIDSTARS
	INTO
		 : ll_IMO,
		 : ls_VName,
		 : ls_Port,
		 : ld_InspDate,
		 : li_Status,
		 : ll_Total,
		 : ll_Valid,
		 : ll_Open,
		 : li_Comm,
		 : li_Att,
		 : li_New,
		 : li_NullStars,
		 : li_SumStars,
		 : li_ValidStars
    FROM VETT_INSP LEFT OUTER JOIN PORTS ON VETT_INSP.PORT = PORTS.PORT_CODE Where INSP_ID = :ll_InspID;
		
If SQLCA.Sqlcode <> 0 then
	MessageBox("DB Error", "Could not refresh row to reflect changes. Please close and re-open window.~n~n" + SQLCA.Sqlerrtext)
	Rollback;
	Return
Else
	Commit;
End If

dw_insp.SetItem( ll_Row, "Total", ll_Total)
dw_insp.SetItem( ll_Row, "Items", ll_Valid)
dw_insp.SetItem( ll_Row, "OpenItems", ll_Open)
dw_insp.SetItem( ll_Row, "InspDate", ld_InspDate)
dw_insp.SetItem( ll_Row, "Port_N", ls_Port)
dw_insp.SetItem( ll_Row, "Status", li_Status)
dw_insp.SetItem( ll_Row, "mvslcomm", li_Comm)
dw_insp.SetItem( ll_Row, "vname", ls_VName)
dw_insp.SetItem( ll_Row, "vesselimo", ll_IMO)
dw_insp.SetItem( ll_Row, "att", li_Att)
dw_insp.SetItem( ll_Row, "newcomments", li_New)
dw_insp.SetItem( ll_Row, "nullstars", li_NullStars)
dw_insp.SetItem( ll_Row, "sumstars", li_SumStars)
dw_insp.SetItem( ll_Row, "validstars", li_ValidStars)
end subroutine

public subroutine wf_openatt ();
OpenWithParm(w_AttFull, g_Obj.InspID)

Do While Message.DoubleParm > 0
	If Message.Doubleparm = 1 then OpenWithParm(w_AttFull, g_Obj.InspID) Else OpenWithParm(w_Thumbs, g_Obj.InspID)
Loop


end subroutine

on w_browser.create
this.st_msg=create st_msg
this.cb_clear=create cb_clear
this.cb_go=create cb_go
this.sle_filter=create sle_filter
this.st_1=create st_1
this.cb_imp=create cb_imp
this.cb_new=create cb_new
this.cb_export=create cb_export
this.cb_del=create cb_del
this.cb_rep=create cb_rep
this.cb_edit=create cb_edit
this.dw_insp=create dw_insp
this.gb_2=create gb_2
this.Control[]={this.st_msg,&
this.cb_clear,&
this.cb_go,&
this.sle_filter,&
this.st_1,&
this.cb_imp,&
this.cb_new,&
this.cb_export,&
this.cb_del,&
this.cb_rep,&
this.cb_edit,&
this.dw_insp,&
this.gb_2}
end on

on w_browser.destroy
destroy(this.st_msg)
destroy(this.cb_clear)
destroy(this.cb_go)
destroy(this.sle_filter)
destroy(this.st_1)
destroy(this.cb_imp)
destroy(this.cb_new)
destroy(this.cb_export)
destroy(this.cb_del)
destroy(this.cb_rep)
destroy(this.cb_edit)
destroy(this.dw_insp)
destroy(this.gb_2)
end on

event open;
f_Write2Log("w_browser Open")

// Choose correct datawindow based on login
If g_Obj.Install = 0 then dw_insp.DataObject = "d_sq_tb_insp_vessel" else dw_insp.DataObject = "d_sq_tb_insp_inspector"
dw_insp.SetTransObject(SQLCA)
dw_insp.Retrieve( )

If g_Obj.Login = 0 then  //Readonly
	cb_Export.Visible = False 
	cb_Imp.Visible = False
	cb_Edit.Visible = False
	cb_New.Visible = False
	cb_Del.Visible = False
	cb_Imp.Visible = False
	cb_Rep.X = cb_New.X
End If

// If inspector, change popup msg
If g_Obj.Login = 2 then st_Msg.Text = "Enter a few characters of the Inspection Model, Edition, Port or Vessel and click Go."
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1200)
end event

event close;
f_Write2Log("w_browser Close")
end event

type st_msg from statictext within w_browser
boolean visible = false
integer x = 3237
integer y = 96
integer width = 1070
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15793151
string text = "Enter a few characters of the Inspection Model, Edition, Port or Company and click Go."
boolean border = true
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_browser
integer x = 4078
integer y = 16
integer width = 197
integer height = 76
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;
sle_Filter.Text = ""
cb_Go.event clicked( )
end event

type cb_go from commandbutton within w_browser
integer x = 3877
integer y = 16
integer width = 197
integer height = 76
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Go"
end type

event clicked;
sle_Filter.Text = Trim(sle_Filter.Text, True)
sle_Filter.SelectText(Len(sle_Filter.Text) + 1, 0)
String ls_F

If sle_Filter.Text > "" Then
	ls_F = " like '" + Upper(sle_Filter.Text) + "%'"
	If dw_Insp.DataObject = "d_sq_tb_insp_vessel" then 
		ls_F = "(Upper(cname)" + ls_F + ") or (Upper(port_n)" + ls_F + ") or (Upper(mname)" + ls_F + ") or (Upper(vett_inspmodel_edition)" + ls_F + ")"		
	Else
		ls_F = "(Upper(vname)" + ls_F + ") or (Upper(port_n)" + ls_F + ") or (Upper(mname)" + ls_F + ") or (Upper(vett_inspmodel_edition)" + ls_F + ")"
	End If
	dw_Insp.SetFilter(ls_F)
Else
	dw_Insp.SetFilter("")
End If

dw_Insp.Filter()
end event

type sle_filter from singlelineedit within w_browser
event ue_keydown pbm_keydown
integer x = 3237
integer y = 16
integer width = 631
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If key=KeyEnter! then cb_Go.event clicked( )
	
end event

event getfocus;
st_Msg.Visible = True
end event

event losefocus;
st_Msg.Visible = False
end event

type st_1 from statictext within w_browser
integer x = 3072
integer y = 24
integer width = 233
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = " Filter:"
boolean focusrectangle = false
end type

type cb_imp from commandbutton within w_browser
integer x = 2322
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Import Inspection..."
end type

event clicked;
String ls_Folder, ls_FileName
Integer li_Count 

Select Count(*) into :li_Count from VETT_INSPMODEL;

If SQLCA.SQLCode <0 then
	Rollback;
	Messagebox("Import Error", "Could not determine DB Issue status.")
	Return
End If

If li_Count = 0 then
	Messagebox("Import Error", "No inspections can be imported until the VIMS Mobile database is updated.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

If GetFileOpenName("Import Inspection Package", ls_Folder, ls_FileName, "vpkg", "VIMS Inspection Packages (*.vpkg),*.vpkg") < 1 then Return

ChangeDirectory(g_Obj.AppFolder)

g_Obj.ParamString = ls_Folder

Open(w_Import)

If g_Obj.Level = 0 then 
	Messagebox("Import Inspection", "Inspection package could not be imported.")
Else 
	dw_Insp.SetFilter("")
	dw_Insp.Filter()
	sle_Filter.Text = ""
	dw_Insp.Retrieve()
End If

end event

type cb_new from commandbutton within w_browser
integer x = 55
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Inspection..."
end type

event clicked;
g_Obj.ParamString = "New"

Open(w_newInsp)

If g_Obj.ParamString > "" then 
	dw_Insp.SetFilter("")
	dw_Insp.Filter()
	sle_Filter.Text=""
	dw_Insp.Retrieve()
	Integer li_Row
	li_Row = dw_Insp.Find("Insp_ID = " + String(g_Obj.InspID), 1, dw_Insp.RowCount())
	If li_Row>0 then dw_Insp.SetRow(li_Row)
	Open(w_InspDetail)
	Yield()
	SetPointer(HourGlass!)
	wf_RefreshRow( )
End If
end event

type cb_export from commandbutton within w_browser
integer x = 1755
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Export Inspection"
end type

event clicked;
If (g_Obj.Install = 0) and (g_Obj.Login = 2) then
	Messagebox("Access Denied", "Inspections can be exported by the Vessel Management only.",Exclamation!)
	Return
End If

If dw_insp.GetItemNumber(dw_insp.GetRow( ), "Locked") = 1 then
	Messagebox("Inspection Locked", "The selected inspection is locked and cannot be exported.",Exclamation!)
	Return	
End If

If dw_insp.GetItemNumber(dw_insp.GetRow( ), "NewComments") > 0 then
	Messagebox("New Comments", "The selection inspection has one or more new comments. Please read and acknowledge these comments before exporting the inspection.",Exclamation!)
	Return		
End If

//Get ID & status
g_Obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")
g_Obj.Level = dw_insp.GetItemNumber( dw_insp.GetRow(), "Status")

Open(w_Export)

If g_Obj.InspID>0 then wf_refreshrow( )
end event

type cb_del from commandbutton within w_browser
integer x = 3712
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete Inspection"
end type

event clicked;Integer li_Row, li_Status
String ls_Temp

If (g_Obj.Install = 0) and (g_Obj.Login = 2) then
	Messagebox("Access Denied", "Inspections can be deleted by the Vessel Management only.",Exclamation!)
	Return
End If

SetPointer(HourGlass!)

li_Row = dw_Insp.GetRow()

// Get Inspection ID
g_Obj.InspID = dw_insp.GetItemNumber(li_Row, "Insp_ID")

// Get Lock status and GlobalID for inspection
Select USER_LOCK, STATUS into :ls_Temp, :li_Status from VETT_INSP Where INSP_ID = :g_Obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_Temp) then
		MessageBox("Inspection Locked", "The selected inspection is currently open on another workstation. Please try again later.")
		Return
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
	Return
End If

If li_Status>0 then
	If MessageBox("Confirm Delete", "This inspection has been imported or exported. Are you sure you want to delete this inspection?",Question!, YesNo!)=2 then Return
Else
	If MessageBox("Confirm Delete", "Are you sure you want to delete this inspection?",Question!, YesNo!)=2 then Return
End If

If MessageBox("Re-Confirm Delete", "All observations, data and attachments related to this inspection will be deleted. This deletion cannot be un-done.~n~nAre you absolutely sure you want to do this?",Question!, YesNo!)=2 then Return

n_inspio lnv_insp

ls_Temp = lnv_insp.of_DeleteVMInspection(g_Obj.InspID)

If ls_Temp = "" then
	dw_Insp.DeleteRow(li_Row)
	If dw_insp.Rowcount( ) = 0 then wf_Setbuttons( )
	w_Back.wf_Calc()
Else
	MessageBox("DB Error", "The inspection could not be deleted.~n~n" + ls_Temp, Exclamation!)
End If
end event

type cb_rep from commandbutton within w_browser
integer x = 1189
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Inspection &Report"
end type

event clicked;Boolean lb_Photos = True

SetPointer(HourGlass!)

g_Obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_insprep"
	
If Left(dw_insp.GetItemString(dw_insp.GetRow(), "mname"), 4) = "MIRE" then 
	If MessageBox("Report Type", "You have selected a MIRE Inspection.~n~nWould you like to open the MIRE report format instead of the standard VIMS Inspection Report?", Question!, YesNo!) = 1 then 
		w_preview.dw_rep.dataobject = "d_rep_insprep_mire"
		If MessageBox("Complete Report", "Do you want to exclude the complete list of questions from the report?", Question!, YesNo!) = 1 then	
			w_preview.dw_rep.Modify("destroy dw_detail")
			w_preview.dw_rep.Modify("destroy t_detail")
		End If
		If MessageBox("Photographs", "Do you want to include photographs in the report?", Question!, YesNo!) = 2 Then
			w_preview.dw_rep.Modify("destroy dw_photos")
			lb_Photos = False
		End If
	End If
End If

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve(g_Obj.InspID)    // Retrieve Master

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer + " - Inspection Report"  //  Set the report footer

If lb_Photos = True Then  // If photos are to be included
	nvo_Img lnImg
	DatawindowChild ldwc_Photos
	lnImg = Create nvo_Img
	
	If w_Preview.dw_Rep.GetChild("dw_photos", ldwc_Photos) = 1 Then	lnImg.CreatePhotoReport(g_obj.InspID, ldwc_Photos)
	
	Destroy lnImg
		
End If

w_preview.wf_ShowReport()
end event

type cb_edit from commandbutton within w_browser
integer x = 622
integer y = 1968
integer width = 567
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Open Inspection"
end type

event clicked;String ls_UserLock
Integer li_Lock

SetPointer(HourGlass!)

//Get ID 
g_Obj.InspID = dw_insp.GetItemNumber( dw_insp.GetRow(), "Insp_ID")


// Get Lock status for inspection
Select USER_LOCK into :ls_UserLock from VETT_INSP Where INSP_ID = :g_Obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_UserLock) then
		MessageBox("Inspection Locked", "The selected inspection is currently open on the workstation " + ls_UserLock + ". Please try again later.")		
		Return
	Else
		Update VETT_INSP Set USER_LOCK = :g_Obj.CompName Where INSP_ID = :g_Obj.Inspid;  // Lock Inspection
		If SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", "Unable to lock inspection for editing.~n~n" + SQLCA.SQLErrtext, Exclamation!)
			Rollback;
			Return
		End If
		Commit;
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
End If

Open(w_inspdetail)

// Get lock status of inspection
li_Lock = dw_insp.GetItemNumber(dw_insp.GetRow(), "Locked")

// If not locked
If li_Lock < 3 then
	SetPointer(HourGlass!)
	wf_refreshrow( )
End If
end event

type dw_insp from datawindow within w_browser
integer x = 55
integer y = 112
integer width = 4224
integer height = 1840
integer taborder = 10
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort
Long ll_AttID

If (dwo.type = "text") and (dwo.name <> "t_ur") then
	If (dwo.tag>"") then
		ls_sort = dwo.Tag
		this.setSort(ls_sort)
		this.Sort()
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		dwo.Tag = ls_sort
	End If
	Return
End if

If dwo.name = "p_rep" then
	g_Obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	If This.GetItemNumber(row, "pdf") > 1 then
		Post MessageBox("Report Ambiguity", "This inspection has more than 1 attachment with the name Report.pdf. Please open the inspection and extract the required attachment.", Exclamation!)
	Else

		Select Top 1 ATT_ID into :ll_AttID From VETT_ATT Where (INSP_ID = :g_Obj.InspID) and (Upper(FILENAME)= 'REPORT.PDF') and (ITEM_ID is Null) and (SM_ID is Null);
		
		If SQLCA.SQLCode = 0 then
			Commit;
			post wf_extractatt(ll_AttID)
		Else
			Post Messagebox("DB Error", "Attachment ID could not be retrieved.~n~nError: " + SQLCA.SqlErrtext, Exclamation!)
			Rollback;			
		End If
	End If
End If

If (dwo.name = "p_star") or (dwo.name = "newcomments") then
	ll_AttID = This.GetItemNumber(row, "newcomments")
	If ll_AttID = 1 then
		ls_sort = "There is " + String(ll_AttID) + " new comment in this inspection."
	Else
		ls_sort = "There are " + String(ll_AttID) + " new comments in this inspection."
	End If
	Post Messagebox("New Comments", ls_Sort, Information!)
End If

If dwo.name = "p_lock" then
	Post Messagebox("Inspection Closed", "This inspection has been closed. No further changes are possible until the inspection is re-opened.")
End If

If dwo.name = "p_excl" then
	Post Messagebox("Comments Posted", "This inspection contains vessel comments that have not been exported. Please re-export this inspection when possible.")
End If

If dwo.name = "p_new" then
	Post Messagebox("New Inspection", "This is a new inspection that has not yet been exported.")
End If

If dwo.name = "p_review" then
	Post Messagebox("Inspection Under Review", "This inspection has been exported and is presently under review. Vessel's comments to observations can be added as required.")
End If

If dwo.name = "p_imp" then
	If g_Obj.Install = 0 then
		Post Messagebox("Inspector", "This inspection has been created by (or imported from) an Inspector. Vessel's comments to observations can be added as required.")
	Else
		Post Messagebox("Inspector", "This inspection has been created by (or imported from) an Inspector")
	End If
End If

If dwo.name = "p_comp" then
	Post Messagebox("Inspection Reviewed", "This inspection has been reviewed. Vessel's comments to observations can be added as required.")
End If

If dwo.name = "att" or dwo.name = "p_att" then
	g_Obj.InspID = dw_insp.GetItemNumber(row, "Insp_ID")
	Post wf_OpenAtt()
End If
end event

event doubleclicked;
If (row > 0) and cb_Edit.Enabled then cb_Edit.event clicked( )
end event

event retrieveend;
wf_SetButtons()

If rowcount > 0 then
	This.SetRow(rowcount)
	This.ScrollToRow(rowcount)
End If
end event

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)

end event

type gb_2 from groupbox within w_browser
integer x = 18
integer y = 16
integer width = 4297
integer height = 2080
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Inspections"
end type

