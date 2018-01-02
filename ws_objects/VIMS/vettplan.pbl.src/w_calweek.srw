$PBExportHeader$w_calweek.srw
forward
global type w_calweek from window
end type
type uo_cal from vo_calweekdisp within w_calweek
end type
type cb_close from commandbutton within w_calweek
end type
end forward

global type w_calweek from window
integer width = 4782
integer height = 2716
boolean titlebar = true
string title = "Vessel Inspection Calender"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Cal.ico"
boolean center = true
uo_cal uo_cal
cb_close cb_close
end type
global w_calweek w_calweek

type variables

DateTime idt_FromCal, idt_ToCal


end variables

on w_calweek.create
this.uo_cal=create uo_cal
this.cb_close=create cb_close
this.Control[]={this.uo_cal,&
this.cb_close}
end on

on w_calweek.destroy
destroy(this.uo_cal)
destroy(this.cb_close)
end on

event resize;Integer li_x

uo_cal.width = newwidth - uo_cal.x * 2

li_x = newheight - uo_cal.x * 3 - cb_close.height
If li_x < 400 then li_x = 400
uo_cal.height = li_x

cb_close.y = uo_cal.height + uo_cal.y + uo_cal.x

li_x = (newwidth - cb_close.width ) / 2
If li_x < uo_cal.x then li_x = uo_cal.x
cb_close.x = li_x
end event

type uo_cal from vo_calweekdisp within w_calweek
event destroy ( )
integer x = 18
integer y = 16
integer width = 2670
integer height = 1584
integer taborder = 50
end type

on uo_cal.destroy
call vo_calweekdisp::destroy
end on

type cb_close from commandbutton within w_calweek
integer x = 1993
integer y = 2496
integer width = 512
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

