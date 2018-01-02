$PBExportHeader$w_about.srw
forward
global type w_about from window
end type
type st_11 from statictext within w_about
end type
type st_8 from statictext within w_about
end type
type st_7 from statictext within w_about
end type
type st_dbissue from statictext within w_about
end type
type st_4 from statictext within w_about
end type
type st_compiled from statictext within w_about
end type
type st_3 from statictext within w_about
end type
type st_1 from statictext within w_about
end type
type st_2 from statictext within w_about
end type
type st_ver from statictext within w_about
end type
type p_1 from picture within w_about
end type
type st_9 from statictext within w_about
end type
type cb_email from commandbutton within w_about
end type
type st_install from statictext within w_about
end type
type st_6 from statictext within w_about
end type
type st_5 from statictext within w_about
end type
type st_dbupdate from statictext within w_about
end type
type ln_1 from line within w_about
end type
type ln_2 from line within w_about
end type
end forward

global type w_about from window
integer width = 2295
integer height = 1600
windowtype windowtype = popup!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
integer animationtime = 300
st_11 st_11
st_8 st_8
st_7 st_7
st_dbissue st_dbissue
st_4 st_4
st_compiled st_compiled
st_3 st_3
st_1 st_1
st_2 st_2
st_ver st_ver
p_1 p_1
st_9 st_9
cb_email cb_email
st_install st_install
st_6 st_6
st_5 st_5
st_dbupdate st_dbupdate
ln_1 ln_1
ln_2 ln_2
end type
global w_about w_about

on w_about.create
this.st_11=create st_11
this.st_8=create st_8
this.st_7=create st_7
this.st_dbissue=create st_dbissue
this.st_4=create st_4
this.st_compiled=create st_compiled
this.st_3=create st_3
this.st_1=create st_1
this.st_2=create st_2
this.st_ver=create st_ver
this.p_1=create p_1
this.st_9=create st_9
this.cb_email=create cb_email
this.st_install=create st_install
this.st_6=create st_6
this.st_5=create st_5
this.st_dbupdate=create st_dbupdate
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.st_11,&
this.st_8,&
this.st_7,&
this.st_dbissue,&
this.st_4,&
this.st_compiled,&
this.st_3,&
this.st_1,&
this.st_2,&
this.st_ver,&
this.p_1,&
this.st_9,&
this.cb_email,&
this.st_install,&
this.st_6,&
this.st_5,&
this.st_dbupdate,&
this.ln_1,&
this.ln_2}
end on

on w_about.destroy
destroy(this.st_11)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_dbissue)
destroy(this.st_4)
destroy(this.st_compiled)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_ver)
destroy(this.p_1)
destroy(this.st_9)
destroy(this.cb_email)
destroy(this.st_install)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_dbupdate)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event close;
f_Write2Log("w_About Close")

If IsValid(W_Main) then w_Main.SetFocus()
end event

event open;String ls_Temp

f_Write2Log("w_About Open")

st_ver.Text = String(Integer(Left(g_Obj.Appver,2))) + "." + String(Integer(Mid(g_Obj.Appver,4,2))) + "." + String(Integer(Right(g_Obj.Appver,2)))

st_Compiled.Text = g_Obj.Appbuilt

f_Config("DBVR", ls_Temp, 0)
st_DBIssue.Text = ls_Temp

f_Config("DBDT", ls_Temp, 0)
st_DBUpdate.Text = ls_Temp

If g_Obj.Install = 0 then
	st_Install.Text = "Vessel / " + String(g_Obj.Vesselimo)
Else
	st_Install.Text = "Inspector / " + g_Obj.Userid
End If
end event

event clicked;
Close(This)
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2700)
end event

type st_11 from statictext within w_about
integer x = 567
integer y = 800
integer width = 1134
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type st_8 from statictext within w_about
integer x = 55
integer y = 1520
integer width = 2176
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 16777215
boolean enabled = false
string text = "Developed and maintained by Bitmetric Technologies Pvt. Ltd."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_about
integer x = 18
integer y = 1456
integer width = 2249
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Copyright, Maersk Tankers A/S"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_dbissue from statictext within w_about
integer x = 823
integer y = 752
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "- - -"
boolean focusrectangle = false
end type

type st_4 from statictext within w_about
integer x = 73
integer y = 752
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Database Issue:"
boolean focusrectangle = false
end type

type st_compiled from statictext within w_about
integer x = 823
integer y = 672
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "- - -"
boolean focusrectangle = false
end type

type st_3 from statictext within w_about
integer x = 73
integer y = 672
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Compile Date:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_about
integer x = 73
integer y = 592
integer width = 640
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Application Version:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_about
integer x = 73
integer y = 1312
integer width = 2112
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
boolean enabled = false
string text = "This program is protected by copyright law. It is forbidden to copy, duplicate or distribute this software or any part of it without the prior consent of Maersk Tankers."
boolean focusrectangle = false
end type

type st_ver from statictext within w_about
integer x = 823
integer y = 592
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "- - -"
boolean focusrectangle = false
end type

type p_1 from picture within w_about
integer width = 2286
integer height = 464
boolean enabled = false
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\Vims\vimsplash.bmp"
boolean focusrectangle = false
end type

type st_9 from statictext within w_about
integer x = 73
integer y = 1088
integer width = 1207
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "For any technical support, assistance or help, contact"
boolean focusrectangle = false
end type

type cb_email from commandbutton within w_about
integer x = 1298
integer y = 1056
integer width = 841
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
string text = "VesselITSupportMT@maersk.com"
end type

event clicked;
f_Write2Log("Email to: " + cb_email.Text)

ShellExecute(Handle(Parent), "open", "mailto:" + cb_email.text + "?subject=VIMS Mobile Support Request", "", "", 0) 
end event

type st_install from statictext within w_about
integer x = 823
integer y = 912
integer width = 786
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "- - -"
boolean focusrectangle = false
end type

type st_6 from statictext within w_about
integer x = 73
integer y = 912
integer width = 695
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Installation Type && ID:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_about
integer x = 73
integer y = 832
integer width = 585
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "Database Issued On:"
boolean focusrectangle = false
end type

type st_dbupdate from statictext within w_about
integer x = 823
integer y = 832
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
string text = "- - -"
boolean focusrectangle = false
end type

type ln_1 from line within w_about
long linecolor = 8421504
integer linethickness = 4
integer beginx = 55
integer beginy = 496
integer endx = 2231
integer endy = 496
end type

type ln_2 from line within w_about
long linecolor = 8421504
integer linethickness = 4
integer beginx = 55
integer beginy = 1440
integer endx = 2231
integer endy = 1440
end type

