$PBExportHeader$w_sysmsg.srw
forward
global type w_sysmsg from window
end type
type cb_filter from commandbutton within w_sysmsg
end type
type cb_clear from commandbutton within w_sysmsg
end type
type sle_header from singlelineedit within w_sysmsg
end type
type sle_from from singlelineedit within w_sysmsg
end type
type st_1 from statictext within w_sysmsg
end type
type cb_ackall from commandbutton within w_sysmsg
end type
type cbx_resp from checkbox within w_sysmsg
end type
type cb_insp from commandbutton within w_sysmsg
end type
type cb_del from commandbutton within w_sysmsg
end type
type cb_unack from commandbutton within w_sysmsg
end type
type cb_ack from commandbutton within w_sysmsg
end type
type dw_msg from datawindow within w_sysmsg
end type
type gb_1 from groupbox within w_sysmsg
end type
end forward

global type w_sysmsg from window
integer width = 4393
integer height = 1944
boolean titlebar = true
string title = "System Messages"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Msg.ico"
boolean center = true
cb_filter cb_filter
cb_clear cb_clear
sle_header sle_header
sle_from sle_from
st_1 st_1
cb_ackall cb_ackall
cbx_resp cbx_resp
cb_insp cb_insp
cb_del cb_del
cb_unack cb_unack
cb_ack cb_ack
dw_msg dw_msg
gb_1 gb_1
end type
global w_sysmsg w_sysmsg

forward prototypes
private subroutine wf_filter ()
end prototypes

private subroutine wf_filter ();// Filters the datawindow based on selection

String ls_Header, ls_From, ls_Filter = ""

ls_Header = Upper(Trim(sle_Header.Text, True))
ls_From = Upper(Trim(sle_From.Text, True))

If ls_Header > "" then ls_Filter = "(Upper(LookupDisplay(msgtype)) like '%" + ls_Header + "%')"

If ls_From > "" then
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(Upper(sender) like '%" + ls_From + "%')"
End If

// Filter as per responsibility
If cbx_resp.Checked then
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(resp = '" + String(g_Obj.UserID) + "' or resp = '< All >')"
End If

dw_Msg.SetFilter(ls_Filter)
dw_Msg.Filter( )
end subroutine

on w_sysmsg.create
this.cb_filter=create cb_filter
this.cb_clear=create cb_clear
this.sle_header=create sle_header
this.sle_from=create sle_from
this.st_1=create st_1
this.cb_ackall=create cb_ackall
this.cbx_resp=create cbx_resp
this.cb_insp=create cb_insp
this.cb_del=create cb_del
this.cb_unack=create cb_unack
this.cb_ack=create cb_ack
this.dw_msg=create dw_msg
this.gb_1=create gb_1
this.Control[]={this.cb_filter,&
this.cb_clear,&
this.sle_header,&
this.sle_from,&
this.st_1,&
this.cb_ackall,&
this.cbx_resp,&
this.cb_insp,&
this.cb_del,&
this.cb_unack,&
this.cb_ack,&
this.dw_msg,&
this.gb_1}
end on

on w_sysmsg.destroy
destroy(this.cb_filter)
destroy(this.cb_clear)
destroy(this.sle_header)
destroy(this.sle_from)
destroy(this.st_1)
destroy(this.cb_ackall)
destroy(this.cbx_resp)
destroy(this.cb_insp)
destroy(this.cb_del)
destroy(this.cb_unack)
destroy(this.cb_ack)
destroy(this.dw_msg)
destroy(this.gb_1)
end on

event open;
dw_msg.SetTransObject(SQLCA)
dw_msg.SetRedraw(false)

If dw_msg.Retrieve( ) > 0 then
	dw_Msg.SetRow(0)
Else
	cb_ack.Enabled = False
	cb_unack.Enabled = False
	cb_Del.Enabled = False
	cb_Insp.Enabled = False
End If

Commit;

cbx_resp.event clicked( )

dw_msg.SetRedraw(true)

w_main.Post f_CheckSysMsg()
end event

type cb_filter from commandbutton within w_sysmsg
integer x = 1975
integer y = 80
integer width = 219
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Filter"
end type

event clicked;
wf_Filter()
end event

type cb_clear from commandbutton within w_sysmsg
integer x = 2194
integer y = 80
integer width = 219
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;
sle_from.Text = ""
sle_Header.Text = ""
wf_Filter()
end event

type sle_header from singlelineedit within w_sysmsg
integer x = 841
integer y = 80
integer width = 567
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_from from singlelineedit within w_sysmsg
integer x = 1426
integer y = 80
integer width = 530
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sysmsg
integer x = 640
integer y = 96
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filters:"
boolean focusrectangle = false
end type

type cb_ackall from commandbutton within w_sysmsg
integer x = 1426
integer y = 1728
integer width = 457
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "My Resp - Ack All"
end type

event clicked;
If Messagebox("Confirm Acknowledge All", "Are you sure you want to acknowledge all your alerts?", Question!, YesNo!) = 2 then Return

Integer li_Loop

For li_Loop = 1 to dw_Msg.RowCount()
	If dw_Msg.GetItemString(li_Loop, "resp") = g_Obj.UserID and dw_Msg.GetItemNumber(li_Loop, "ack") = 0 then dw_Msg.SetItem(li_Loop, "ack", 1)
Next

If dw_Msg.Update() = 1 then	
	cb_Ack.Enabled = (dw_Msg.GetItemNumber(dw_Msg.GetRow(), "ack") = 0)
	cb_Unack.Enabled = Not cb_Ack.Enabled
   w_Main.f_CheckSysMsg( )
Else
	Messagebox("DW Error", "Messages could not be acknowledged!", Exclamation!)
End If

Commit;
end event

type cbx_resp from checkbox within w_sysmsg
integer x = 3931
integer y = 16
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "My Resp Only"
boolean checked = true
end type

event clicked;
wf_Filter()


end event

type cb_insp from commandbutton within w_sysmsg
integer x = 969
integer y = 1728
integer width = 457
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open Inspection"
end type

event clicked;String ls_UserLock

SetPointer(HourGlass!)

// Get ID and vessel name
g_obj.InspID = dw_Msg.GetItemNumber(dw_Msg.GetRow(), "Insp_ID")
g_obj.ObjString = ""   //dw_vsl.GetItemString(dw_vsl.GetRow(), "Name")

// Get Lock status for inspection
Select USER_LOCK into :ls_UserLock from VETT_INSP Where INSP_ID = :g_obj.Inspid;

If SQLCA.SQLCode = 0 then
	Commit;
	If Not IsNull(ls_UserLock) then  // If inspection is locked
		MessageBox("Inspection Locked", "The selected inspection is being edited by the user " + ls_UserLock + " and is locked.~n~nNo changes can be made to the inspection.")
		g_Obj.Level = 0
	Else   // If inspection is not locked
		If (g_Obj.DeptID = 1) and (g_Obj.Access > 1) then  // If user is vetting and has access
			Update VETT_INSP Set USER_LOCK = :g_Obj.UserID Where INSP_ID = :g_obj.Inspid;  // Lock Inspection
			If SQLCA.SQLCode <> 0 then
				MessageBox("DB Error", "Unable to lock inspection for editing. Inspection will be opened in Read-Only mode.", Exclamation!)
				Rollback;
				g_Obj.Level = 0
			Else
				Commit;
				g_Obj.Level = 1				
			End If
		End If
	End If
Else
	MessageBox("DB Error", "Could not retrieve inspection lock status. Cannot open inspection.~n~n" + SQLCA.SQLErrtext,Exclamation!)	
	Rollback;
	Return
End If

Open(w_inspdetail)

If g_Obj.Level = 1 then		
	If IsValid(w_insp) then
		SetPointer(HourGlass!)
		w_Insp.wf_refreshrow()
		w_Insp.wf_refreshvsl()
	End If
End If
end event

type cb_del from commandbutton within w_sysmsg
integer x = 3858
integer y = 1728
integer width = 457
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;
dw_msg.DeleteRow(dw_Msg.GetRow())

If dw_msg.Update() = 1 then
	If dw_msg.RowCount() = 0 then
		This.Enabled = False
		cb_ack.Enabled = False
		cb_Unack.Enabled = False		
	End If
	w_main.f_CheckSysMsg()
Else
	Messagebox("DB Error", "Could not delete message.", Exclamation!)
	dw_msg.Retrieve()
End If
end event

type cb_unack from commandbutton within w_sysmsg
integer x = 512
integer y = 1728
integer width = 457
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Un-Acknowledge"
end type

event clicked;
dw_Msg.SetItem(dw_Msg.GetRow(), "ack", 0)

If dw_Msg.Update() = 1 then
	cb_UnAck.Enabled = False
	cb_Ack.Enabled = True
	w_Main.f_CheckSysMsg( )
Else
	Messagebox("DW Error", "Message could not be un-acknowledged!", Exclamation!)
End If

Commit;
end event

type cb_ack from commandbutton within w_sysmsg
integer x = 55
integer y = 1728
integer width = 457
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Acknowledge"
end type

event clicked;
dw_Msg.SetItem(dw_Msg.GetRow(), "ack", 1)

If dw_Msg.Update() = 1 then
	cb_Ack.Enabled = False
	cb_Unack.Enabled = True
   w_Main.f_CheckSysMsg( )
Else
	Messagebox("DW Error", "Message could not be acknowledged!", Exclamation!)
End If

Commit;
end event

type dw_msg from datawindow within w_sysmsg
integer x = 55
integer y = 160
integer width = 4261
integer height = 1568
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_sysmsg"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)

If This.GetRow() = 0 then 
	cb_Ack.Enabled = False
	cb_Unack.Enabled = False
	cb_Insp.Enabled = False
	Return
End If

If dw_msg.GetItemNumber(This.GetRow(), "ack") = 1 then
	cb_ack.Enabled = False
	cb_Unack.Enabled = True
Else
	cb_Unack.Enabled = False
	cb_Ack.Enabled = True	
End If

cb_Insp.Enabled = Not IsNull(dw_msg.GetItemNumber(This.GetRow(), "insp_id")) 


end event

type gb_1 from groupbox within w_sysmsg
integer x = 18
integer y = 16
integer width = 4334
integer height = 1824
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VIMS System Messages"
end type

