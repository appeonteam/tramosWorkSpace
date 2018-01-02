$PBExportHeader$w_extinfo.srw
forward
global type w_extinfo from window
end type
type cb_cancel from commandbutton within w_extinfo
end type
type cb_ok from commandbutton within w_extinfo
end type
type lb_officers from listbox within w_extinfo
end type
type rb_officer from radiobutton within w_extinfo
end type
type st_1 from statictext within w_extinfo
end type
type rb_roviq from radiobutton within w_extinfo
end type
type gb_1 from groupbox within w_extinfo
end type
end forward

global type w_extinfo from window
integer width = 1198
integer height = 1376
boolean titlebar = true
string title = "Select Extended Information"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
lb_officers lb_officers
rb_officer rb_officer
st_1 st_1
rb_roviq rb_roviq
gb_1 gb_1
end type
global w_extinfo w_extinfo

type variables

Long il_Old
end variables

on w_extinfo.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.lb_officers=create lb_officers
this.rb_officer=create rb_officer
this.st_1=create st_1
this.rb_roviq=create rb_roviq
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.lb_officers,&
this.rb_officer,&
this.st_1,&
this.rb_roviq,&
this.gb_1}
end on

on w_extinfo.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.lb_officers)
destroy(this.rb_officer)
destroy(this.st_1)
destroy(this.rb_roviq)
destroy(this.gb_1)
end on

event open;String ls_Num

lb_Officers.AddItem("Master")
lb_Officers.AddItem("Chief Officer")
lb_Officers.AddItem("2nd Officer")
lb_Officers.AddItem("3rd Officer")
lb_Officers.AddItem("Chief Engineer")
lb_Officers.AddItem("2nd Engineer")
lb_Officers.AddItem("3rd Engineer")
lb_Officers.AddItem("4th Engineer")
lb_Officers.AddItem("Maritime Officer")
lb_Officers.AddItem("Gas Engineer")
lb_Officers.AddItem("Electrical Engineer")
lb_Officers.AddItem("Deck Department")
lb_Officers.AddItem("Engine Department")

il_Old = g_Obj.NoteID

If g_Obj.NoteID < 0 then rb_Officer.Checked = True Else rb_roviq.Checked = True

lb_Officers.Enabled = rb_Officer.Checked

If il_Old<0 then
	ls_Num = String(-il_Old)
	Do
		Choose Case Left(ls_Num,2)
			Case "10"
				lb_Officers.SetState(1, True)
			Case "15"
				lb_Officers.SetState(2, True)
			Case "20"
				lb_Officers.SetState(3, True)
			Case "25"
				lb_Officers.SetState(4, True)
			Case "50"
				lb_Officers.SetState(5, True)
			Case "55"
				lb_Officers.SetState(6, True)
			Case "60"
				lb_Officers.SetState(7, True)
			Case "65"
				lb_Officers.SetState(8, True)
			Case "70"
				lb_Officers.SetState(9, True)
			Case "75"
				lb_Officers.SetState(10, True)
			Case "80"
				lb_Officers.SetState(11, True)
			Case "85"
				lb_Officers.SetState(12, True)
			Case "90"
				lb_Officers.SetState(13, True)				
		End Choose
		ls_Num = Right(ls_Num, Len(ls_Num)-2)
	Loop Until ls_Num=""	
End If
	
end event

type cb_cancel from commandbutton within w_extinfo
integer x = 677
integer y = 1168
integer width = 329
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
Close(Parent)
end event

type cb_ok from commandbutton within w_extinfo
integer x = 183
integer y = 1168
integer width = 329
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
end type

event clicked;String ls_Num
Integer li_Count

If rb_Roviq.Checked then
	If il_Old >0 then g_obj.NoteID = il_Old Else g_Obj.NoteID = 0
Else
	For li_Count = 1 to lb_officers.TotalItems( )
		If lb_officers.State(li_Count) = 1 then
			Choose Case li_Count
				Case 1
					ls_Num += "10"
				Case 2
					ls_Num += "15"
				Case 3
					ls_Num += "20"
				Case 4
					ls_Num += "25"
				Case 5
					ls_Num += "50"
				Case 6
					ls_Num += "55"
				Case 7
					ls_Num += "60"					
				Case 8
					ls_Num += "65"
				Case 9
					ls_Num += "70"
				Case 10
					ls_Num += "75"
				Case 11
					ls_Num += "80"
				Case 12
					ls_Num += "85"
				Case 13
					ls_Num += "90"
			End Choose
		End If
	Next
	If Len(ls_Num) > 6 then
		MessageBox("Selection", "A maximum of 3 selections can be assigned.", Exclamation!)
		Return
	End If	
	If Len(ls_Num) = 0 then 
		MessageBox("Selection", "At least one selection must be made.", Exclamation!)
		Return		
	End If
	g_obj.NoteId = -Long(ls_Num)
End If

Close(Parent)
end event

type lb_officers from listbox within w_extinfo
integer x = 274
integer y = 400
integer width = 658
integer height = 704
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

type rb_officer from radiobutton within w_extinfo
integer x = 146
integer y = 320
integer width = 859
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Officer(s) / Department Assigned"
end type

event clicked;
lb_Officers.Enabled = True
end event

type st_1 from statictext within w_extinfo
integer x = 73
integer y = 80
integer width = 594
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select type of information:"
boolean focusrectangle = false
end type

type rb_roviq from radiobutton within w_extinfo
integer x = 146
integer y = 192
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "ROVIQ Serial No."
end type

event clicked;
lb_Officers.Enabled = False
end event

type gb_1 from groupbox within w_extinfo
integer x = 18
integer y = 16
integer width = 1152
integer height = 1120
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

