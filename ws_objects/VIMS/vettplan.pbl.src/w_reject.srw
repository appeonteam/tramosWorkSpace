$PBExportHeader$w_reject.srw
forward
global type w_reject from window
end type
type cbx_acc from checkbox within w_reject
end type
type cb_close from commandbutton within w_reject
end type
type cb_del from commandbutton within w_reject
end type
type cb_edit from commandbutton within w_reject
end type
type cb_new from commandbutton within w_reject
end type
type st_3 from statictext within w_reject
end type
type st_name from statictext within w_reject
end type
type st_imo from statictext within w_reject
end type
type st_2 from statictext within w_reject
end type
type st_1 from statictext within w_reject
end type
type gb_1 from groupbox within w_reject
end type
type dw_rej from datawindow within w_reject
end type
end forward

global type w_reject from window
integer width = 3511
integer height = 1900
boolean titlebar = true
string title = "Vessel Rejection History"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_acc cbx_acc
cb_close cb_close
cb_del cb_del
cb_edit cb_edit
cb_new cb_new
st_3 st_3
st_name st_name
st_imo st_imo
st_2 st_2
st_1 st_1
gb_1 gb_1
dw_rej dw_rej
end type
global w_reject w_reject

type variables

Boolean ibool_Modif = False
end variables

forward prototypes
public subroutine wf_setbuttons ()
end prototypes

public subroutine wf_setbuttons ();// Sets button enabled based on access and rows in DW


// Set user access for Vetting Dept RW users only
If g_obj.DeptID=1 and g_Obj.Access>1 then  
	cb_edit.Enabled = dw_Rej.RowCount()>0
	cb_New.Enabled = True
	If g_Obj.Access=3 Then cb_Del.Enabled = dw_Rej.RowCount()>0  // Delete for super user only
End If
end subroutine

on w_reject.create
this.cbx_acc=create cbx_acc
this.cb_close=create cb_close
this.cb_del=create cb_del
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.st_3=create st_3
this.st_name=create st_name
this.st_imo=create st_imo
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.dw_rej=create dw_rej
this.Control[]={this.cbx_acc,&
this.cb_close,&
this.cb_del,&
this.cb_edit,&
this.cb_new,&
this.st_3,&
this.st_name,&
this.st_imo,&
this.st_2,&
this.st_1,&
this.gb_1,&
this.dw_rej}
end on

on w_reject.destroy
destroy(this.cbx_acc)
destroy(this.cb_close)
destroy(this.cb_del)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.st_3)
destroy(this.st_name)
destroy(this.st_imo)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.dw_rej)
end on

event open;
String ls_VName

st_IMO.Text = String(g_Obj.ObjID)

Select TOP 1 (VESSEL_REF_NR + ' / ' + VESSEL_NAME) into :ls_Vname from VESSELS Where (VESSEL_ACTIVE = 1) and Not (VETT_TYPE is Null) and IMO_NUMBER = :g_Obj.ObjID;

If SQLCA.SQLCode <> 0 then
	st_name.Text = " <Error>"
	Rollback;
	cb_Edit.Enabled = False
	cb_New.Enabled = False
	cb_Del.Enabled = False
	Return
End If

Commit;

st_name.Text = ls_VName


dw_Rej.SetTransObject(SQLCA)
dw_Rej.Retrieve(g_Obj.ObjID)

dw_Rej.SetFilter("IsNull(AcceptDate)")
dw_Rej.Filter()

end event

event close;
If ibool_Modif then g_Obj.ObjID = 1 Else g_Obj.ObjID = 0
end event

type cbx_acc from checkbox within w_reject
integer x = 3017
integer y = 320
integer width = 421
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide Accepted"
boolean checked = true
end type

event clicked;
If This.Checked then dw_Rej.SetFilter("IsNull(AcceptDate)") Else dw_Rej.SetFilter("")

dw_Rej.Filter()

wf_SetButtons()
end event

type cb_close from commandbutton within w_reject
integer x = 1554
integer y = 1696
integer width = 384
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
Close(Parent)
end event

type cb_del from commandbutton within w_reject
integer x = 3163
integer y = 1552
integer width = 274
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

event clicked;
// Delete a rejection

If Messagebox("Confirm Delete", "Are you sure you want to delete the selected rejection?", Question!, YesNo!) = 2 then Return

dw_Rej.DeleteRow(dw_Rej.GetRow())

If dw_Rej.Update() < 1 then MessageBox("Deletion Failed", "Unable to delete the selected rejection", Exclamation!) Else ibool_Modif = True

Commit;

wf_SetButtons()
end event

type cb_edit from commandbutton within w_reject
integer x = 366
integer y = 1552
integer width = 274
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Edit..."
end type

event clicked;
g_Obj.NoteID = dw_Rej.GetItemNumber(dw_Rej.GetRow(), "RejectID")

Open(w_RejectEdit)

If g_Obj.NoteID > 0 then 
	dw_Rej.ReselectRow(dw_Rej.GetRow())
	ibool_Modif = True
	wf_SetButtons()
End If
end event

type cb_new from commandbutton within w_reject
integer x = 91
integer y = 1552
integer width = 274
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "New"
end type

event clicked;
g_Obj.NoteID = 0    // Creating new rejection

Open(w_RejectEdit)

If g_Obj.NoteID > 0 then    // If new rejection created
	dw_Rej.Retrieve(g_Obj.ObjID)    // Refresh DW
	ibool_Modif = True     // set modified flag
	guo_global.of_SendRejectionNotice(g_Obj.NoteID)	  //  Send email to management
End If
end event

type st_3 from statictext within w_reject
integer x = 91
integer y = 320
integer width = 480
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "List of Rejections:"
boolean focusrectangle = false
end type

type st_name from statictext within w_reject
integer x = 658
integer y = 160
integer width = 1774
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_imo from statictext within w_reject
integer x = 658
integer y = 80
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
string text = "none"
boolean focusrectangle = false
end type

type st_2 from statictext within w_reject
integer x = 91
integer y = 80
integer width = 384
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel IMO:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_reject
integer x = 91
integer y = 160
integer width = 549
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel No. / Name:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_reject
integer x = 37
integer width = 3438
integer height = 1664
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

type dw_rej from datawindow within w_reject
integer x = 91
integer y = 400
integer width = 3346
integer height = 1152
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_reject"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
Post wf_SetButtons()
end event

event clicked;
If dwo.name = "p_insp" then
	g_Obj.InspID = This.GetItemNumber(row, "Insp_ID")
	SetPointer(HourGlass!)
	
	If g_Obj.DeptID > 1 then // If not Vetting dept, check if inspection is reviewed
		Messagebox("Access Denied", "You do not have access to open this inspection.", Exclamation!)
		Return
	End If
	
	OpenSheet(w_preview, w_main, 0, Original!)
	
	w_preview.dw_rep.dataobject = "d_rep_insprep"
	
	w_preview.dw_rep.SetTransObject(SQLCA)
	
	w_preview.dw_rep.Retrieve(g_obj.InspID)    // Retrieve Master
	
	w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer
	
	w_preview.wf_ShowReport()
	
End If
end event

event doubleclicked;
If row > 0 and cb_Edit.Enabled then cb_Edit.event clicked( )
end event

