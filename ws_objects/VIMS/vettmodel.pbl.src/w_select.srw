$PBExportHeader$w_select.srw
forward
global type w_select from window
end type
type cb_cancel from commandbutton within w_select
end type
type cb_ok from commandbutton within w_select
end type
type lb_officers from listbox within w_select
end type
type rb_officers from radiobutton within w_select
end type
type rb_all from radiobutton within w_select
end type
type st_1 from statictext within w_select
end type
type gb_1 from groupbox within w_select
end type
end forward

global type w_select from window
integer width = 1682
integer height = 1280
boolean titlebar = true
string title = "Officer Selection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
lb_officers lb_officers
rb_officers rb_officers
rb_all rb_all
st_1 st_1
gb_1 gb_1
end type
global w_select w_select

on w_select.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.lb_officers=create lb_officers
this.rb_officers=create rb_officers
this.rb_all=create rb_all
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.lb_officers,&
this.rb_officers,&
this.rb_all,&
this.st_1,&
this.gb_1}
end on

on w_select.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.lb_officers)
destroy(this.rb_officers)
destroy(this.rb_all)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
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
end event

type cb_cancel from commandbutton within w_select
integer x = 1006
integer y = 1056
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event clicked;
g_Obj.Level = 250
Close(Parent)
end event

type cb_ok from commandbutton within w_select
integer x = 256
integer y = 1056
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
end type

event clicked;Integer li_Count
String ls_Num

If rb_All.Checked then
	g_Obj.Level = 0
Else
  li_Count = lb_Officers.Selectedindex( )
	Choose Case li_Count
		Case 1
			g_Obj.Level = 10
		Case 2
			g_Obj.Level = 15
		Case 3
			g_Obj.Level = 20
		Case 4
			g_Obj.Level = 25
		Case 5
			g_Obj.Level = 50
		Case 6
			g_Obj.Level = 55
		Case 7
			g_Obj.Level = 60
		Case 8
			g_Obj.Level = 65
		Case 9
			g_Obj.Level = 70
		Case 10
			g_Obj.Level = 75
		Case 11
			g_Obj.Level = 80
		Case 12
			g_Obj.Level = 85
		Case 13
			g_Obj.Level = 90			
		Case Else
		MessageBox("Officer Selection", "Please select an officer.", Exclamation!)
		Return			
	End Choose
End If

Close(Parent)
end event

type lb_officers from listbox within w_select
integer x = 329
integer y = 448
integer width = 1024
integer height = 528
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type rb_officers from radiobutton within w_select
integer x = 219
integer y = 352
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
string text = "Show questions for:"
end type

event clicked;
lb_Officers.Enabled = True
end event

type rb_all from radiobutton within w_select
integer x = 219
integer y = 256
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
string text = "Show all questions"
boolean checked = true
end type

event clicked;
lb_Officers.Enabled = False
end event

type st_1 from statictext within w_select
integer x = 91
integer y = 80
integer width = 1518
integer height = 176
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The selected model can be filtered by assigned officers. Please select an option:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_select
integer x = 37
integer width = 1591
integer height = 1024
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

