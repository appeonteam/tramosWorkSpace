$PBExportHeader$w_export.srw
forward
global type w_export from window
end type
type st_zeroatt from statictext within w_export
end type
type st_6 from statictext within w_export
end type
type st_size from statictext within w_export
end type
type st_count from statictext within w_export
end type
type st_3 from statictext within w_export
end type
type st_2 from statictext within w_export
end type
type cbx_replace from checkbox within w_export
end type
type ddlb_att from dropdownlistbox within w_export
end type
type st_1 from statictext within w_export
end type
type st_email from statictext within w_export
end type
type cb_cancel from commandbutton within w_export
end type
type cb_ok from commandbutton within w_export
end type
type rb_disk from radiobutton within w_export
end type
type rb_vsl from radiobutton within w_export
end type
type gb_1 from groupbox within w_export
end type
type gb_2 from groupbox within w_export
end type
end forward

global type w_export from window
integer width = 1874
integer height = 1324
boolean titlebar = true
string title = "Inspection Export"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_zeroatt st_zeroatt
st_6 st_6
st_size st_size
st_count st_count
st_3 st_3
st_2 st_2
cbx_replace cbx_replace
ddlb_att ddlb_att
st_1 st_1
st_email st_email
cb_cancel cb_cancel
cb_ok cb_ok
rb_disk rb_disk
rb_vsl rb_vsl
gb_1 gb_1
gb_2 gb_2
end type
global w_export w_export

type variables

n_InspIO invo_InspExp
Integer ii_Option
end variables

forward prototypes
public subroutine wf_calcatt (boolean ab_modif, integer ai_option)
end prototypes

public subroutine wf_calcatt (boolean ab_modif, integer ai_option);/* This function populates the Attachment size and count
Parameters:

ab_modif - If only modified/new inspections should be counted
ai_option - 0=No att, 1=Header Att only, 2=All Att

*/

If ai_Option = 0 then
	st_Count.Text = "0"
	st_Size.Text = "0.0"
	st_ZeroAtt.Visible = True
	Return	
End If

st_Count.Text = String(invo_InspExp.of_GetAttCount(g_Obj.InspID, ab_Modif, ai_Option = 1))
st_Size.Text = String(invo_InspExp.of_GetTotalAttSize(g_Obj.InspID, ab_Modif, ai_Option = 1)/1024, "#,##0.0")

st_ZeroAtt.Visible = (st_Count.Text = "0")
end subroutine

on w_export.create
this.st_zeroatt=create st_zeroatt
this.st_6=create st_6
this.st_size=create st_size
this.st_count=create st_count
this.st_3=create st_3
this.st_2=create st_2
this.cbx_replace=create cbx_replace
this.ddlb_att=create ddlb_att
this.st_1=create st_1
this.st_email=create st_email
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.rb_disk=create rb_disk
this.rb_vsl=create rb_vsl
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_zeroatt,&
this.st_6,&
this.st_size,&
this.st_count,&
this.st_3,&
this.st_2,&
this.cbx_replace,&
this.ddlb_att,&
this.st_1,&
this.st_email,&
this.cb_cancel,&
this.cb_ok,&
this.rb_disk,&
this.rb_vsl,&
this.gb_1,&
this.gb_2}
end on

on w_export.destroy
destroy(this.st_zeroatt)
destroy(this.st_6)
destroy(this.st_size)
destroy(this.st_count)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cbx_replace)
destroy(this.ddlb_att)
destroy(this.st_1)
destroy(this.st_email)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.rb_disk)
destroy(this.rb_vsl)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
// set vessel's email addr
st_Email.Text = "(" + g_Obj.ObjString + ")"

If g_Obj.Level = 0 then    // If user is not allowed to send direct to vessel
	rb_Disk.Checked = True
	rb_Vsl.Enabled = False
	cbx_replace.Enabled = False
	ddlb_Att.Enabled = True
	ddlb_Att.SelectItem(1)
	ddlb_att.event SelectionChanged(1)
Else
	g_Obj.Level = 0   // Reset variable for return	
End If

// Calc Att size
If rb_Vsl.Checked then wf_CalcAtt(True, 2) Else wf_CalcAtt(False, 0)

// Disable export button if export disabled by admin
String ls_Disable
If f_Config("EXDS", ls_Disable, 0) = 0 then
	If ls_Disable = "1" then
		cb_Ok.Enabled = False
		Post MessageBox("Export Disabled", "Inspection Export functionality has been temporarity disabled.", Information!)
	End If
End If
end event

type st_zeroatt from statictext within w_export
integer x = 165
integer y = 880
integer width = 1440
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "No attachments will be included in export as all attachments are either synchronized or not selected for export."
boolean focusrectangle = false
end type

type st_6 from statictext within w_export
integer x = 914
integer y = 976
integer width = 110
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "KB"
boolean focusrectangle = false
end type

type st_size from statictext within w_export
integer x = 457
integer y = 976
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "0.0"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_count from statictext within w_export
integer x = 658
integer y = 880
integer width = 233
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "0"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_export
integer x = 201
integer y = 976
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Total Size:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_export
integer x = 201
integer y = 880
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Number of Files:"
boolean focusrectangle = false
end type

type cbx_replace from checkbox within w_export
integer x = 274
integer y = 272
integer width = 494
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Replace Inspection"
end type

event clicked;

wf_CalcAtt(Not cbx_Replace.Checked, 2)
end event

type ddlb_att from dropdownlistbox within w_export
integer x = 274
integer y = 560
integer width = 768
integer height = 400
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
string item[] = {"With No Attachments","With Header Attachments Only","With All Attachments"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Option = index

wf_CalcAtt(False, ii_Option - 1)
end event

type st_1 from statictext within w_export
integer x = 786
integer y = 292
integer width = 969
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "( Inspection will be deleted before import )"
boolean focusrectangle = false
end type

type st_email from statictext within w_export
integer x = 274
integer y = 208
integer width = 1170
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "( No email available )"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_export
integer x = 1134
integer y = 1120
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_ok from commandbutton within w_export
integer x = 347
integer y = 1120
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export"
boolean default = true
end type

event clicked;String ls_Save, ls_Temp
Integer li_Temp

// Check and set the GlobalID of the Inspection if required
If Not invo_InspExp.of_CreateGlobalID(g_Obj.InspID) then
	Messagebox("Global ID", "Failed to create a GlobalID for the inspection.", Exclamation!)
	Return
End If

// If saving to disk, get folder to save to
If rb_Disk.Checked then
	li_Temp = GetFolder("Select the folder to export to:", ls_Save)
	ChangeDirectory(g_Obj.AppFolder)
	If li_Temp < 1 then
		If li_Temp < 0 then Messagebox("Folder Error", "Could not access the selected folder.", Exclamation!)
		Return
	End If
	If Right(ls_Save, 1) <> "\" then ls_Save += "\"	
	If g_Obj.TempFolder>"" then ls_Temp = g_Obj.TempFolder Else ls_Temp = ls_Save
Else
	If cbx_Replace.Checked then 
		If Messagebox("Confirm Replace Inspection", "You have chosen to replace the inspection on the vessel. The existing inspection on the vessel (including any un-exported comments) will be deleted and replaced with this exported inspection. This must be done only if the inspection on the vessel is not synchronized even after regular exports.~n~nAre you sure absolutely you want to do this?", Question!, YesNo!) = 2 then Return
	End If
End If

// Post any pending comments
If invo_InspExp.of_PostComments(g_Obj.InspID, g_Obj.Dept + " - " + gs_fullname) < 0 then 
	MessageBox("Item Comments", "One or more comments could not be posted. The inspection cannot be exported.", Exclamation!)
	Return
End If

this.Enabled = False
cb_Cancel.Enabled = False

Yield()
SetPointer(HourGlass!)

// Set export options
Byte lb_Option, lb_Att
String ls_Return
If rb_Vsl.Checked then   // If exporting to vessel
	lb_Att = 2
	If cbx_Replace.Checked then lb_Option = 2 Else lb_Option = 1
	Update VETT_INSP Set EXPORT=:lb_Option Where INSP_ID=:g_Obj.InspID;
	If SQLCA.SQLcode=0 Then
		Commit;
		guo_Global.of_AddInspHist(g_Obj.InspID, 12, "Sent by email")
		// Set export flags to blue
		Update VETT_INSP Set EXPFLAG = 2 Where INSP_ID = :g_Obj.InspID;
		Update VETT_ATT Set IMPORTED = 2 Where INSP_ID = :g_Obj.InspID and IMPORTED<2;
		Update VETT_ITEMHIST Set HIST_TYPE=0 From VETT_ITEMHIST
		  Inner Join VETT_ITEM On VETT_ITEMHIST.ITEM_ID=VETT_ITEM.ITEM_ID Where INSP_ID=:g_Obj.InspID;
		Commit;  // No need to check for error		
	Else
		Messagebox("Unable to Export", "An error occurred while exporting: " + SQLCA.SQLErrText, Exclamation!)
		Rollback;
		this.Enabled = True
		cb_Cancel.Enabled = True
		Return
	End If	
Else
	ls_Return = invo_InspExp.of_ExportInspection(g_Obj.InspID, 0, ls_Temp, ls_Save, ii_Option - 1, g_Obj.UserID, 2)
	If Right(ls_Return, 5) = ".vpkg" then
		Messagebox("Export Successful", "The inspection was exported successfully to " + ls_Return)
		guo_Global.of_AddInspHist(g_Obj.InspID, 12, "Exported to disk")	
	Else
		Messagebox("Export Error", "An error occurred while exporting the inspection. The export was unsuccessful.~n~nError Message: " + ls_Return, Exclamation!)
		this.Enabled = True
		cb_Cancel.Enabled = True
		Return
	End If
End If	

Close(Parent)

end event

type rb_disk from radiobutton within w_export
integer x = 183
integer y = 448
integer width = 987
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Save inspection package to disk"
end type

event clicked;
ddlb_Att.Enabled = True
ddlb_Att.SelectItem(1)

ii_Option = 1

wf_CalcAtt(False, 0)
end event

type rb_vsl from radiobutton within w_export
integer x = 183
integer y = 128
integer width = 1426
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Email inspection package to vessel"
boolean checked = true
end type

event clicked;
ddlb_Att.Enabled = False

wf_CalcAtt(Not cbx_Replace.Checked, 2)
end event

type gb_1 from groupbox within w_export
integer x = 37
integer y = 16
integer width = 1774
integer height = 704
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Export Options"
end type

type gb_2 from groupbox within w_export
integer x = 37
integer y = 768
integer width = 1774
integer height = 320
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Estimated Attachment Export Size"
end type

