$PBExportHeader$w_rejectedit.srw
forward
global type w_rejectedit from window
end type
type st_mgmt from statictext within w_rejectedit
end type
type cb_cancel from commandbutton within w_rejectedit
end type
type cb_save from commandbutton within w_rejectedit
end type
type dw_rej from datawindow within w_rejectedit
end type
type gb_1 from groupbox within w_rejectedit
end type
end forward

global type w_rejectedit from window
integer width = 2254
integer height = 1484
boolean titlebar = true
string title = "New Rejection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_mgmt st_mgmt
cb_cancel cb_cancel
cb_save cb_save
dw_rej dw_rej
gb_1 gb_1
end type
global w_rejectedit w_rejectedit

on w_rejectedit.create
this.st_mgmt=create st_mgmt
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.dw_rej=create dw_rej
this.gb_1=create gb_1
this.Control[]={this.st_mgmt,&
this.cb_cancel,&
this.cb_save,&
this.dw_rej,&
this.gb_1}
end on

on w_rejectedit.destroy
destroy(this.st_mgmt)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.dw_rej)
destroy(this.gb_1)
end on

event open;
dw_Rej.SetTransObject(SQLCA)

// If new item
If g_Obj.NoteID = 0 then 
	dw_Rej.InsertRow(0)
	dw_Rej.SetItem(1, "VesselIMO", g_Obj.ObjID)
	dw_Rej.SetItem(1, "RejectDate", DateTime(Today()))
	st_Mgmt.Visible = True
Else  // else retrieve
	dw_Rej.Retrieve(g_Obj.NoteID)
	If dw_Rej.RowCount() <> 1 then 
		MessageBox("DB Error", "Unable to load rejection")
		cb_save.Enabled = False
		Return
	End If
	If IsNull(dw_Rej.GetItemNumber(1, "insp_id")) then dw_Rej.SetItem(1, "insptext", " < No inspection linked >")
End If
end event

type st_mgmt from statictext within w_rejectedit
boolean visible = false
integer x = 73
integer y = 1168
integer width = 2121
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 67108864
string text = "Management notification emails will be sent automatically"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_rejectedit
integer x = 1371
integer y = 1280
integer width = 402
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.NoteID = 0
Close(Parent)
end event

type cb_save from commandbutton within w_rejectedit
integer x = 512
integer y = 1280
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;dw_Rej.Accepttext( )

If IsNull(dw_Rej.GetItemNumber(1, "Comp_ID")) then
	MessageBox("Data Required", "Please select the 'Rejected By' company.", Exclamation!)
	Return
End If

If IsNull(dw_Rej.GetItemDateTime(1, "RejectDate")) then
	MessageBox("Data Required", "Please select a date for the rejection.", Exclamation!)
	Return
End If

If IsNull(dw_Rej.GetItemNumber(1, "RsnID")) then
	MessageBox("Data Required", "Please select a reason for the rejection.", Exclamation!)
	Return
End If

If Not (IsNull(dw_Rej.GetItemDateTime(1, "RejectDate")) or IsNull(dw_Rej.GetItemDateTime(1, "AcceptDate"))) then
	If dw_Rej.GetItemDateTime(1, "RejectDate") > dw_Rej.GetItemDateTime(1, "AcceptDate")	then
		MessageBox("Data Error", "Acceptance date must be same as or later than the Rejection date", Exclamation!)
		Return		
	End If		
End If

dw_Rej.SetItem(1, "Details", Trim(dw_Rej.GetItemString(1, "Details"), True))
If IsNull(dw_Rej.GetItemString(1, "Details")) Or dw_Rej.GetItemString(1, "Details")="" then
	MessageBox("Details Required", "Please enter details for the rejection.", Exclamation!)
	Return
End If

dw_Rej.SetItem(1, "UserID", g_Obj.UserID)

If dw_Rej.Update()<1 then
	Messagebox("Save Error", "Unable to save data.", Exclamation!)
	Return
End If

Commit;

If g_Obj.NoteID = 0 then g_Obj.NoteID = dw_Rej.GetItemNumber(1, "RejectID")

Close(Parent)
end event

type dw_rej from datawindow within w_rejectedit
integer x = 55
integer y = 48
integer width = 2139
integer height = 1072
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_rejectedit"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
If dwo.name = "b_cleardate" then
	DateTime ldt_Null	
	SetNull(ldt_Null)	
	This.SetItem(1, "AcceptDate", ldt_Null)	
End If

If dwo.name = "b_clearinsp" then
	Long ll_InspID
	SetNull(ll_InspID)
   This.SetItem(1, "insptext", " < No inspection linked >")
	This.SetItem(1, "insp_id", ll_InspID)
End If

If dwo.name = "b_link" then
	Open(w_inspselect)
	If g_Obj.InspID > 0 then 
		This.SetItem(1, "insptext", g_Obj.ObjParent)
		This.SetItem(1, "insp_id", g_Obj.InspID)
	End If
End If
end event

type gb_1 from groupbox within w_rejectedit
integer x = 37
integer width = 2176
integer height = 1248
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

