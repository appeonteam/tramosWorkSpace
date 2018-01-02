$PBExportHeader$w_gererate_loadload_splash_window.srw
$PBExportComments$This window shows a splash window when LoadLoad VAs is generated
forward
global type w_gererate_loadload_splash_window from window
end type
type hpb_1 from hprogressbar within w_gererate_loadload_splash_window
end type
type st_1 from statictext within w_gererate_loadload_splash_window
end type
end forward

global type w_gererate_loadload_splash_window from window
integer width = 1970
integer height = 568
boolean titlebar = true
string title = "Generate LoadLoad VAS..."
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
hpb_1 hpb_1
st_1 st_1
end type
global w_gererate_loadload_splash_window w_gererate_loadload_splash_window

on w_gererate_loadload_splash_window.create
this.hpb_1=create hpb_1
this.st_1=create st_1
this.Control[]={this.hpb_1,&
this.st_1}
end on

on w_gererate_loadload_splash_window.destroy
destroy(this.hpb_1)
destroy(this.st_1)
end on

type hpb_1 from hprogressbar within w_gererate_loadload_splash_window
integer x = 50
integer y = 240
integer width = 1842
integer height = 112
unsignedinteger maxposition = 100
integer setstep = 10
end type

type st_1 from statictext within w_gererate_loadload_splash_window
integer x = 389
integer y = 100
integer width = 1120
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generating LoadLoad VAS Report..."
alignment alignment = center!
boolean focusrectangle = false
end type

