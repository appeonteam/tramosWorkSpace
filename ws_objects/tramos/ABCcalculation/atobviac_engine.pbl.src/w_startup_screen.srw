$PBExportHeader$w_startup_screen.srw
$PBExportComments$This screen is shown when Distance table is loaded. Takes 5-10 sec. (only first time used)
forward
global type w_startup_screen from window
end type
type st_1 from statictext within w_startup_screen
end type
end forward

global type w_startup_screen from window
integer width = 1701
integer height = 372
windowtype windowtype = popup!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
end type
global w_startup_screen w_startup_screen

on w_startup_screen.create
this.st_1=create st_1
this.Control[]={this.st_1}
end on

on w_startup_screen.destroy
destroy(this.st_1)
end on

type st_1 from statictext within w_startup_screen
integer x = 69
integer y = 120
integer width = 1577
integer height = 120
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Loading AtoBviaC Distance Table..."
alignment alignment = center!
borderstyle borderstyle = StyleRaised!
boolean focusrectangle = false
end type

