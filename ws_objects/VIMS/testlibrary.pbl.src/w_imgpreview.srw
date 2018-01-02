$PBExportHeader$w_imgpreview.srw
forward
global type w_imgpreview from window
end type
type cb_cancel from commandbutton within w_imgpreview
end type
type cb_ok from commandbutton within w_imgpreview
end type
type vsb_img from vscrollbar within w_imgpreview
end type
type st_img from statictext within w_imgpreview
end type
end forward

global type w_imgpreview from window
integer width = 4133
integer height = 1900
boolean titlebar = true
string title = "Image Attachment Preview"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
vsb_img vsb_img
st_img st_img
end type
global w_imgpreview w_imgpreview

event open;Integer li_ExtraY, li_ExtraX

li_ExtraY = This.Height - This.WorkspaceHeight()
li_ExtraX = This.Width - This.WorkspaceWidth()

st_Img.Width = PixelsToUnits(804, XPixelsToUnits!)
st_Img.X = vsb_Img.Width / 2
st_Img.Y = st_Img.X
st_Img.Height = PixelsToUnits(604, YPixelsToUnits!)

This.Width = st_Img.X * 2 + st_Img.Width + vsb_Img.Width + li_ExtraX

vsb_Img.X = st_Img.X + st_Img.Width
vsb_Img.Height = st_Img.Height

cb_ok.y = st_Img.y + st_Img.Height + st_Img.y
cb_Cancel.y = cb_ok.y

This.Height = st_Img.Height + cb_ok.height + li_ExtraY + st_Img.y * 3 
end event

on w_imgpreview.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.vsb_img=create vsb_img
this.st_img=create st_img
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.vsb_img,&
this.st_img}
end on

on w_imgpreview.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.vsb_img)
destroy(this.st_img)
end on

type cb_cancel from commandbutton within w_imgpreview
integer x = 859
integer y = 1552
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

type cb_ok from commandbutton within w_imgpreview
integer x = 219
integer y = 1552
integer width = 603
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Attach Image"
boolean default = true
end type

type vsb_img from vscrollbar within w_imgpreview
integer x = 3328
integer y = 16
integer width = 73
integer height = 1024
end type

type st_img from statictext within w_imgpreview
integer x = 18
integer y = 16
integer width = 3310
integer height = 1344
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

