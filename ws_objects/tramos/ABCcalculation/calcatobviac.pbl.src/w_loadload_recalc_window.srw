$PBExportHeader$w_loadload_recalc_window.srw
$PBExportComments$Not visible
forward
global type w_loadload_recalc_window from window
end type
type cb_5 from commandbutton within w_loadload_recalc_window
end type
type cb_4 from commandbutton within w_loadload_recalc_window
end type
type cb_3 from commandbutton within w_loadload_recalc_window
end type
type cb_2 from commandbutton within w_loadload_recalc_window
end type
type cb_1 from commandbutton within w_loadload_recalc_window
end type
type st_1 from statictext within w_loadload_recalc_window
end type
type uo_recalc from u_atobviac_calculation within w_loadload_recalc_window
end type
end forward

global type w_loadload_recalc_window from window
boolean visible = false
integer width = 3543
integer height = 1896
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
st_1 st_1
uo_recalc uo_recalc
end type
global w_loadload_recalc_window w_loadload_recalc_window

on w_loadload_recalc_window.create
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.uo_recalc=create uo_recalc
this.Control[]={this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.st_1,&
this.uo_recalc}
end on

on w_loadload_recalc_window.destroy
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.uo_recalc)
end on

type cb_5 from commandbutton within w_loadload_recalc_window
integer x = 2510
integer y = 148
integer width = 517
integer height = 132
integer taborder = 40
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "calculate"
end type

event clicked;uo_recalc.uf_calculate()
end event

type cb_4 from commandbutton within w_loadload_recalc_window
integer x = 1865
integer y = 148
integer width = 517
integer height = 132
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "result"
end type

event clicked;uo_recalc.uf_select_page( 4)
end event

type cb_3 from commandbutton within w_loadload_recalc_window
integer x = 1266
integer y = 148
integer width = 517
integer height = 132
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "route"
end type

event clicked;uo_recalc.uf_select_page( 2)
end event

type cb_2 from commandbutton within w_loadload_recalc_window
integer x = 672
integer y = 148
integer width = 517
integer height = 132
integer taborder = 50
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "cargo"
end type

event clicked;uo_recalc.uf_select_cargo( -1)
end event

type cb_1 from commandbutton within w_loadload_recalc_window
integer x = 46
integer y = 148
integer width = 517
integer height = 132
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Summary"
end type

event clicked;uo_recalc.uf_select_page( 1)
end event

type st_1 from statictext within w_loadload_recalc_window
integer x = 133
integer y = 52
integer width = 2030
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This window is only used to recalc LoadLoad calculations"
boolean focusrectangle = false
end type

type uo_recalc from u_atobviac_calculation within w_loadload_recalc_window
integer x = 59
integer y = 320
integer width = 2999
integer height = 1412
integer taborder = 40
end type

on uo_recalc.destroy
call u_atobviac_calculation::destroy
end on

