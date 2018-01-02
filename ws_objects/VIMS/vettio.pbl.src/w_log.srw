$PBExportHeader$w_log.srw
forward
global type w_log from window
end type
type mle_log from multilineedit within w_log
end type
end forward

global type w_log from window
integer width = 3141
integer height = 1856
boolean titlebar = true
string title = "Developer Spy Log"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
mle_log mle_log
end type
global w_log w_log

on w_log.create
this.mle_log=create mle_log
this.Control[]={this.mle_log}
end on

on w_log.destroy
destroy(this.mle_log)
end on

type mle_log from multilineedit within w_log
integer x = 18
integer y = 16
integer width = 3090
integer height = 1744
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

