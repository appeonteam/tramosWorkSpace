$PBExportHeader$w_setting.srw
forward
global type w_setting from window
end type
type st_3 from statictext within w_setting
end type
type cb_cancel from commandbutton within w_setting
end type
type cb_save from commandbutton within w_setting
end type
type sle_ce from singlelineedit within w_setting
end type
type sle_master from singlelineedit within w_setting
end type
type st_2 from statictext within w_setting
end type
type st_1 from statictext within w_setting
end type
type gb_1 from groupbox within w_setting
end type
end forward

global type w_setting from window
integer width = 2318
integer height = 808
boolean titlebar = true
string title = "Default Settings"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Admin.ico"
boolean center = true
st_3 st_3
cb_cancel cb_cancel
cb_save cb_save
sle_ce sle_ce
sle_master sle_master
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_setting w_setting

on w_setting.create
this.st_3=create st_3
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.sle_ce=create sle_ce
this.sle_master=create sle_master
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_3,&
this.cb_cancel,&
this.cb_save,&
this.sle_ce,&
this.sle_master,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_setting.destroy
destroy(this.st_3)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.sle_ce)
destroy(this.sle_master)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;String ls_Name

f_Write2Log("w_Setting Open")
If f_Config("CAPT", ls_Name, 0) = 0 then sle_master.Text = ls_Name
If f_Config("CENG", ls_Name, 0) = 0 then sle_ce.Text = ls_Name


end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1400)
end event

type st_3 from statictext within w_setting
integer x = 658
integer y = 480
integer width = 1042
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Do not use any prefixes before the names"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_setting
integer x = 1353
integer y = 592
integer width = 530
integer height = 112
integer taborder = 40
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
f_Write2Log("w_Setting Cancel")
Close(Parent)
end event

type cb_save from commandbutton within w_setting
integer x = 421
integer y = 592
integer width = 530
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save Settings"
boolean default = true
end type

event clicked;String ls_Name

ls_Name = sle_Master.Text
If f_CheckInvalid(ls_Name) then
	MessageBox("Invalid Characters", "The Master's name contains one or more invalid characters.")
	sle_Master.SetFocus( )
	Return
End If

ls_Name = sle_CE.Text
If f_CheckInvalid(ls_Name) then
	MessageBox("Invalid Characters", "The Chief Engineer's name contains one or more invalid characters.")
	sle_CE.Setfocus( )
	Return
End If

ls_Name = Trim(sle_master.Text, True)

If ls_Name = "" then
	MessageBox("Name Required", "Please specify the Master's name.")
	sle_Master.SetFocus()
	Return
End If

If f_Config("CAPT", ls_Name, 1) < 0 then
	Messagebox("DB Error", "The Master's name could not be saved. Please check the name entered.", Exclamation!)
	f_Write2Log("w_Setting > cb_Save: f_Config('CAPT', '" + ls_Name + "') Failed")	
	Return
End If

ls_Name = Trim(sle_ce.Text, True)

If ls_Name = "" then SetNull(ls_Name)

If f_Config("CENG", ls_Name, 1) < 0 then
	Messagebox("DB Error", "The Chief Engineer's could not be saved. Please check the names entered.", Exclamation!)
	f_Write2Log("w_Setting > cb_Save: f_Config('CENG', '" + ls_Name + "') Failed")
	Return
End If

f_Write2Log("w_Setting Save Success")
Close(Parent)
end event

type sle_ce from singlelineedit within w_setting
integer x = 896
integer y = 256
integer width = 1280
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 0)
end event

type sle_master from singlelineedit within w_setting
integer x = 896
integer y = 128
integer width = 1280
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 0)


end event

type st_2 from statictext within w_setting
integer x = 146
integer y = 272
integer width = 695
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Chief Engineer~'s Name:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_setting
integer x = 146
integer y = 144
integer width = 494
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Master~'s Name:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_setting
integer x = 18
integer y = 16
integer width = 2267
integer height = 544
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "General Settings"
end type

