$PBExportHeader$w_export.srw
forward
global type w_export from window
end type
type cb_cancel from commandbutton within w_export
end type
type cb_export from commandbutton within w_export
end type
type mle_notice from multilineedit within w_export
end type
type st_2 from statictext within w_export
end type
type gb_1 from groupbox within w_export
end type
end forward

global type w_export from window
integer width = 2039
integer height = 992
boolean titlebar = true
string title = "Export Inspection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_export cb_export
mle_notice mle_notice
st_2 st_2
gb_1 gb_1
end type
global w_export w_export

type variables

Boolean ib_Include = False
end variables

on w_export.create
this.cb_cancel=create cb_cancel
this.cb_export=create cb_export
this.mle_notice=create mle_notice
this.st_2=create st_2
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_export,&
this.mle_notice,&
this.st_2,&
this.gb_1}
end on

on w_export.destroy
destroy(this.cb_cancel)
destroy(this.cb_export)
destroy(this.mle_notice)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;
f_Write2Log("w_Export Open")
		
Choose Case g_Obj.Level
	Case 0   // New inspection
		If g_Obj.Login = 1 then  // Vessel login
			mle_notice.Text = "You are exporting a newly created inspection. After exporting, you will not be able to make any changes to the inspection except for posting new comments to observations. Please export this inspection only if all details of the inspection have been entered and completed."
		Else
			mle_notice.Text = "You are exporting a newly created inspection. After exporting, you will not be able to make any further changes to the inspection. Please export this inspection only if all details of this inspection have been entered and completed. The exported inspection must be sent to the vessel."	
		End If
	Case 1, 2  // Exported by Inspector, Vessel
		If g_Obj.Login = 1 then  // Vessel login
			mle_notice.Text = "You are exporting an inspection. Vessel's comments for all items will be transferred to the comment history for the item. The comment history cannot be modified or deleted."
		Else
			mle_notice.Text = "You are re-exporting an inspection. The exported inspection must be sent to a vessel."			
		End If	
	Case 3    // Imported from Office
		If g_Obj.Login = 1 then  // Vessel login
			mle_notice.Text = "You are re-exporting an inspection. Vessel's comments for all items will be transferred to the comment history for the item. The comment history cannot be modified or deleted."
		Else
			mle_notice.Text = "You are re-exporting an inspection. The exported inspection file can be sent to the vessel or the office."
		End If	
	Case Else
		mle_notice.Text = "Invalid Inspection Status: " + String(g_Obj.Level)
		cb_Export.Enabled = False	
End Choose

If g_Obj.Level < 3 then // If insp is not from office yet, force to include attachments
	ib_Include = True   
	mle_notice.Text += "~r~n~r~nALL Attachments will be included in the export."
Else
	mle_notice.Text += "~r~n~r~nNO Attachments will be included in the export."
End If

end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1600)
end event

type cb_cancel from commandbutton within w_export
integer x = 1097
integer y = 768
integer width = 695
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel Export"
boolean cancel = true
end type

event clicked;
f_Write2Log("w_Export Cancel")

g_Obj.InspID = 0

Close(Parent)
end event

type cb_export from commandbutton within w_export
integer x = 219
integer y = 768
integer width = 695
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export Inspection"
boolean default = true
end type

event clicked;String ls_Path, ls_Sender, ls_Ret
Integer li_Ret
n_inspio lnvo_insp

// Check if choice is enabled and attachments are included
//If (rb_Exclude.Enabled) and (rb_include.Checked) then
//	If Messagebox("Confirm Attachments", "You have chosen to include all attachments and photos that have already been exported earlier.~n~nAttachments and photos usually need to be exported once only.~n~nAre you sure you want to include them in this export?", Question!, YesNo!) = 2 then Return
//End If

ls_Path = ""

// Check for existence of export folder on vessel and set path
If g_Obj.Install = 0 then   // If vessel installation
  If Not DirectoryExists(g_DB.is_Export) then   
		li_Ret =	CreateDirectory(g_DB.is_Export)
		If li_Ret < 0 then
			f_Write2Log("w_Export > cb_Export: Unable to find/create export folder - " + g_DB.is_Export)
			Return -1
		End If
	End If
	ls_Path = g_DB.is_Export		
End If

If ls_Path = "" then
	If GetFolder("Select a folder to export the inspection package:", ls_Path) < 1 then Return
End If

ChangeDirectory(g_Obj.AppFolder)

If Right(ls_Path, 1) <> "\" then ls_Path += "\"

SetPointer(HourGlass!)

If Not lnvo_insp.of_CreateGlobalID(g_Obj.InspID) Then
	Messagebox("Export Error", "Unable to create Global ID for Inspection.", Exclamation!)
	f_Write2Log("w_Export > cb_Export: of_CreateGlobalID failed")
	Return
End If

If lnvo_insp.of_PostComments(g_Obj.InspID, "Vessel") < 0 Then
	Messagebox("Item Comments", "One or more comments could not be posted. The inspection cannot be exported.", Exclamation!)
	f_Write2Log("w_Export > cb_Export: of_PostComments failed")
	Return
End If

If g_Obj.Install = 0 then ls_Sender = String(g_Obj.VesselIMO) Else ls_Sender = g_Obj.UserID

Byte lb_Att = 0
If ib_Include then lb_Att = 2   // Include all attachments

ls_Ret = lnvo_insp.of_ExportInspection(g_Obj.InspID, g_Obj.Install + 1, g_Obj.TempFolder, ls_Path, lb_Att, ls_Sender, 2)

If Right(ls_Ret, 5) = ".vpkg" then  // Success
	If g_Obj.Install = 0 then li_Ret = 2 Else li_Ret = 1   // Check new status
	If li_Ret < g_Obj.Level then li_Ret = g_Obj.Level   //  Check if status needs to be updated
	lnvo_insp.of_ChangeInspectionStatus(g_Obj.InspID, li_Ret)
	Messagebox("Export Complete", "The inspection was exported successfully to " + ls_Path + ls_Ret)
	f_Write2Log("w_Export > cb_Export: Export Successful")
	Close(Parent)
Else
	Messagebox("Export Failed", "The inspection could not be exported successfully.~n~nError Message: " + ls_Ret, Exclamation!)
	f_Write2Log("w_Export > cb_Export: Export Failed")
End If


end event

type mle_notice from multilineedit within w_export
integer x = 73
integer y = 176
integer width = 1865
integer height = 512
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_export
integer x = 73
integer y = 112
integer width = 731
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 67108864
string text = "Important Information:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_export
integer x = 18
integer width = 1975
integer height = 736
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Export"
end type

