$PBExportHeader$w_plansetting.srw
forward
global type w_plansetting from window
end type
type st_7 from statictext within w_plansetting
end type
type st_6 from statictext within w_plansetting
end type
type sle_super from singlelineedit within w_plansetting
end type
type sle_req from singlelineedit within w_plansetting
end type
type mle_req from multilineedit within w_plansetting
end type
type st_9 from statictext within w_plansetting
end type
type st_8 from statictext within w_plansetting
end type
type dw_color from datawindow within w_plansetting
end type
type st_5 from statictext within w_plansetting
end type
type st_4 from statictext within w_plansetting
end type
type sle_user from singlelineedit within w_plansetting
end type
type cb_cancel from commandbutton within w_plansetting
end type
type cb_save from commandbutton within w_plansetting
end type
type sle_issues from singlelineedit within w_plansetting
end type
type st_3 from statictext within w_plansetting
end type
type st_2 from statictext within w_plansetting
end type
type sle_notes from singlelineedit within w_plansetting
end type
type st_1 from statictext within w_plansetting
end type
type gb_1 from groupbox within w_plansetting
end type
end forward

global type w_plansetting from window
integer width = 2455
integer height = 1688
boolean titlebar = true
string title = "Vessel Settings"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_7 st_7
st_6 st_6
sle_super sle_super
sle_req sle_req
mle_req mle_req
st_9 st_9
st_8 st_8
dw_color dw_color
st_5 st_5
st_4 st_4
sle_user sle_user
cb_cancel cb_cancel
cb_save cb_save
sle_issues sle_issues
st_3 st_3
st_2 st_2
sle_notes sle_notes
st_1 st_1
gb_1 gb_1
end type
global w_plansetting w_plansetting

type variables

String is_Resp
end variables

on w_plansetting.create
this.st_7=create st_7
this.st_6=create st_6
this.sle_super=create sle_super
this.sle_req=create sle_req
this.mle_req=create mle_req
this.st_9=create st_9
this.st_8=create st_8
this.dw_color=create dw_color
this.st_5=create st_5
this.st_4=create st_4
this.sle_user=create sle_user
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.sle_issues=create sle_issues
this.st_3=create st_3
this.st_2=create st_2
this.sle_notes=create sle_notes
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_7,&
this.st_6,&
this.sle_super,&
this.sle_req,&
this.mle_req,&
this.st_9,&
this.st_8,&
this.dw_color,&
this.st_5,&
this.st_4,&
this.sle_user,&
this.cb_cancel,&
this.cb_save,&
this.sle_issues,&
this.st_3,&
this.st_2,&
this.sle_notes,&
this.st_1,&
this.gb_1}
end on

on w_plansetting.destroy
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_super)
destroy(this.sle_req)
destroy(this.mle_req)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.dw_color)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_user)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.sle_issues)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_notes)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Long ll_Row

ll_Row = w_plan.dw_plan.GetRow()

sle_user.Text = w_plan.dw_plan.GetItemString(ll_Row, "resp")
sle_Super.Text = w_plan.dw_plan.GetItemString(ll_Row, "Super")
sle_notes.Text = w_plan.dw_plan.GetItemString(ll_Row, "notes")
sle_issues.Text = w_plan.dw_plan.GetItemString(ll_Row, "issues")
sle_Req.Text = w_plan.dw_plan.GetItemString(ll_Row, "req")
mle_Req.Text = w_plan.dw_plan.GetItemString(ll_Row, "reqnote")

is_Resp = sle_user.Text   // Store Resp user to compare later when saving

// T/C Vessel
If Pos(w_plan.dw_plan.GetItemString(ll_Row, "type_name") , "T/C") > 0 then 
	sle_super.enabled = False
	sle_Issues.Enabled = False
End If

This.Title = "Vessel Settings - " + w_plan.dw_plan.GetItemString(ll_Row, "vessel_name")

ll_Row = dw_color.Find("Color = " + String(w_plan.dw_plan.GetItemNumber(ll_Row, "Color")), 1, dw_color.RowCount())
If ll_Row > 0 then
	dw_Color.SetRow(ll_Row)
	dw_Color.ScrollTorow(ll_Row)
End If

If g_Obj.DeptID > 1 then  // If non-vetting user
	sle_User.Enabled = False
	sle_Super.Enabled = False
	dw_Color.Enabled = False
	dw_Color.Object.Datawindow.Color = "12632256"
	sle_Notes.Enabled = False
	sle_Req.Enabled = False
	mle_Req.Enabled = False
End If
end event

type st_7 from statictext within w_plansetting
integer x = 73
integer y = 224
integer width = 581
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Technical Superintendent:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_plansetting
integer x = 1061
integer y = 224
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
long backcolor = 67108864
string text = "(User ID only)"
boolean focusrectangle = false
end type

type sle_super from singlelineedit within w_plansetting
integer x = 695
integer y = 208
integer width = 347
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type sle_req from singlelineedit within w_plansetting
integer x = 695
integer y = 880
integer width = 1664
integer height = 80
integer taborder = 70
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

type mle_req from multilineedit within w_plansetting
integer x = 695
integer y = 992
integer width = 1664
integer height = 416
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_plansetting
integer x = 73
integer y = 1008
integer width = 448
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requirement Notes:"
boolean focusrectangle = false
end type

type st_8 from statictext within w_plansetting
integer x = 73
integer y = 896
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requirements:"
boolean focusrectangle = false
end type

type dw_color from datawindow within w_plansetting
integer x = 695
integer y = 320
integer width = 713
integer height = 304
integer taborder = 30
string title = "none"
string dataobject = "d_ext_color"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_plansetting
integer x = 73
integer y = 336
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Color:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_plansetting
integer x = 1061
integer y = 112
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
long backcolor = 67108864
string text = "(User ID only)"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_plansetting
integer x = 695
integer y = 96
integer width = 347
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_plansetting
integer x = 1481
integer y = 1488
integer width = 343
integer height = 92
integer taborder = 100
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
Close(Parent)
end event

type cb_save from commandbutton within w_plansetting
integer x = 640
integer y = 1488
integer width = 343
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;Long ll_Row
String ls_User

ll_Row = w_plan.dw_plan.GetRow()

sle_user.Text = Trim(sle_User.Text, True)
sle_Super.Text = Trim(sle_Super.Text, True)

If (sle_user.Text = "") and (g_Obj.DeptID = 1) then
	MessageBox("Marine Superintendent Required", "You must specify a Marine Superintendent for the vessel.",Exclamation!)
	sle_User.SetFocus( )
	Return
End If

If sle_User.Text = sle_Super.Text then 
	MessageBox("Same User", "You cannot specify the same user for both Marine Superintendent and Technical Superintendent positions.", Exclamation!)
	Return
End If

If sle_User.Enabled then
	Select USERID into :ls_User from USERS Where USERID = :sle_User.Text and VETT_ACCESS > 0;
	Commit;
	
	If ls_User <> sle_User.Text then
		Messagebox("User Not found", "The user '" + sle_User.Text + "' is not a valid VIMS user.", Exclamation!)
		sle_User.SetFocus( )
		Return
	End If
End If

If sle_Super.Enabled and sle_Super.Text > "" then
	Select USERID into :ls_User from USERS Where USERID = :sle_Super.Text and VETT_ACCESS > 0;
	Commit;
	
	If ls_User <> sle_Super.Text then
		Messagebox("User Not found", "The user '" + sle_Super.Text + "' is not a valid VIMS user.", Exclamation!)
		sle_Super.SetFocus( )
		Return	
	End If
End If

w_plan.dw_plan.SetItem(ll_Row, "issues", Trim(sle_issues.Text))

If g_Obj.DeptID = 1 then
	sle_Notes.Text = Trim(sle_Notes.Text)
	sle_Req.Text = Trim(sle_Req.Text)
	mle_Req.Text = Trim(mle_Req.Text)
	SetNull(ls_User)
	w_plan.dw_plan.SetItem(ll_Row, "resp", sle_User.Text)
	If sle_Super.Text>"" then w_plan.dw_plan.SetItem(ll_Row, "Super", sle_Super.Text) Else w_plan.dw_plan.SetItem(ll_Row, "Super", ls_User)
	w_plan.dw_plan.SetItem(ll_Row, "notes", Trim(sle_notes.Text))
	w_plan.dw_plan.SetItem(ll_Row, "req", Trim(sle_req.Text))
	w_plan.dw_plan.SetItem(ll_Row, "reqnote", Trim(mle_req.Text))
	w_plan.dw_plan.SetItem(ll_Row, "Color", dw_color.GetItemNumber(dw_Color.GetRow(), "Color"))
End If

If w_plan.dw_plan.Update() <> 1 then
	MessageBox("Error", "Data could not be saved. Please check entries.")
	Rollback;
	Return
Else
	Commit;
End If

If sle_User.Text <> is_Resp then  // If responsible user has changed, change resp user for all open inspections
	If Messagebox("Confirm Superintendent Change", "You have changed the Marine Superintendent for this vessel.~n~nDo you want to assign the new superintendent to all open inspections for this vessel?", Question!, YesNo!) = 1 then
		is_Resp = sle_user.Text
		Long ll_IMO
		ll_IMO = w_plan.dw_plan.GetItemNumber(ll_Row, "imo_number")
		Update VETT_INSP Set RESP = :is_Resp Where VESSELIMO = :ll_IMO and LOCKED=0;
		If SQLCA.SQLCode < 0 then
			Rollback;
			Messagebox("Error", "Unable to change superintendent for all open inspections.")
		Else
			Commit;
			Messagebox("Marine Superintendent Changed", "Marine Superintendent for all open inspections changed to " + is_Resp + ".")				
			
			// Add to inspection history
			Insert Into VETT_INSPHIST (INSP_ID,	HDATE, HTYPE, USER_ID, DEPT_ID, INFO) Select INSP_ID, GetDate(), 8, :g_Obj.UserID, :g_Obj.DeptID, 'Responsible: ' + :is_Resp From VETT_INSP Where VESSELIMO = :ll_IMO and LOCKED=0;
			Commit;
			
		End If
	End If
End If

Close(Parent)
end event

type sle_issues from singlelineedit within w_plansetting
integer x = 695
integer y = 768
integer width = 1664
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 200
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_plansetting
integer x = 73
integer y = 784
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
string text = "Notes (Internal):"
boolean focusrectangle = false
end type

type st_2 from statictext within w_plansetting
integer x = 73
integer y = 672
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Notes (External):"
boolean focusrectangle = false
end type

type sle_notes from singlelineedit within w_plansetting
integer x = 695
integer y = 656
integer width = 1664
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 200
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_plansetting
integer x = 73
integer y = 112
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Marine Superintendent:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_plansetting
integer x = 18
integer width = 2395
integer height = 1456
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

