$PBExportHeader$w_planhelp.srw
forward
global type w_planhelp from window
end type
type st_21 from statictext within w_planhelp
end type
type st_yellow from statictext within w_planhelp
end type
type st_red from statictext within w_planhelp
end type
type st_19 from statictext within w_planhelp
end type
type st_18 from statictext within w_planhelp
end type
type st_17 from statictext within w_planhelp
end type
type st_16 from statictext within w_planhelp
end type
type st_10 from statictext within w_planhelp
end type
type st_9 from statictext within w_planhelp
end type
type st_15 from statictext within w_planhelp
end type
type st_14 from statictext within w_planhelp
end type
type st_13 from statictext within w_planhelp
end type
type cb_close from commandbutton within w_planhelp
end type
type st_12 from statictext within w_planhelp
end type
type st_11 from statictext within w_planhelp
end type
type st_8 from statictext within w_planhelp
end type
type st_7 from statictext within w_planhelp
end type
type st_6 from statictext within w_planhelp
end type
type st_5 from statictext within w_planhelp
end type
type st_4 from statictext within w_planhelp
end type
type st_3 from statictext within w_planhelp
end type
type st_2 from statictext within w_planhelp
end type
type st_1 from statictext within w_planhelp
end type
end forward

global type w_planhelp from window
integer width = 2359
integer height = 1300
boolean titlebar = true
string title = "Inspection Due Dates"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_21 st_21
st_yellow st_yellow
st_red st_red
st_19 st_19
st_18 st_18
st_17 st_17
st_16 st_16
st_10 st_10
st_9 st_9
st_15 st_15
st_14 st_14
st_13 st_13
cb_close cb_close
st_12 st_12
st_11 st_11
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_planhelp w_planhelp

on w_planhelp.create
this.st_21=create st_21
this.st_yellow=create st_yellow
this.st_red=create st_red
this.st_19=create st_19
this.st_18=create st_18
this.st_17=create st_17
this.st_16=create st_16
this.st_10=create st_10
this.st_9=create st_9
this.st_15=create st_15
this.st_14=create st_14
this.st_13=create st_13
this.cb_close=create cb_close
this.st_12=create st_12
this.st_11=create st_11
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.st_21,&
this.st_yellow,&
this.st_red,&
this.st_19,&
this.st_18,&
this.st_17,&
this.st_16,&
this.st_10,&
this.st_9,&
this.st_15,&
this.st_14,&
this.st_13,&
this.cb_close,&
this.st_12,&
this.st_11,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_planhelp.destroy
destroy(this.st_21)
destroy(this.st_yellow)
destroy(this.st_red)
destroy(this.st_19)
destroy(this.st_18)
destroy(this.st_17)
destroy(this.st_16)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_15)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.cb_close)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;
st_Red.Backcolor = 8421631
st_Yellow.Backcolor = 65535
end event

type st_21 from statictext within w_planhelp
integer x = 1719
integer y = 304
integer width = 293
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "No Color"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_yellow from statictext within w_planhelp
integer x = 1115
integer y = 304
integer width = 293
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Yellow"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_red from statictext within w_planhelp
integer x = 530
integer y = 304
integer width = 293
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Red"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_19 from statictext within w_planhelp
integer x = 1664
integer y = 920
integer width = 439
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Not due for more than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_18 from statictext within w_planhelp
integer x = 1079
integer y = 920
integer width = 411
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_17 from statictext within w_planhelp
integer x = 494
integer y = 920
integer width = 407
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 1 month"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_16 from statictext within w_planhelp
integer x = 1664
integer y = 752
integer width = 439
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Not due for more than 3 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_10 from statictext within w_planhelp
integer x = 494
integer y = 752
integer width = 402
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_9 from statictext within w_planhelp
integer x = 1079
integer y = 752
integer width = 411
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 3 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_15 from statictext within w_planhelp
integer x = 1664
integer y = 592
integer width = 457
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Not due for more than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_14 from statictext within w_planhelp
integer x = 1079
integer y = 592
integer width = 421
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_13 from statictext within w_planhelp
integer x = 494
integer y = 592
integer width = 402
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 1 month"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_planhelp
integer x = 951
integer y = 1104
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
boolean default = true
end type

event clicked;
Close(Parent)
end event

type st_12 from statictext within w_planhelp
integer x = 1079
integer y = 432
integer width = 421
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_11 from statictext within w_planhelp
integer x = 1664
integer y = 432
integer width = 457
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Not due for more than 2 months"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_8 from statictext within w_planhelp
integer x = 494
integer y = 432
integer width = 402
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Next due in less than 1 month"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_7 from statictext within w_planhelp
integer x = 640
integer y = 176
integer width = 1317
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
string text = "Inspection Due Date Color"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_6 from statictext within w_planhelp
integer x = 110
integer y = 912
integer width = 329
integer height = 144
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "ISM Audit (Internal)"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_planhelp
integer x = 110
integer y = 784
integer width = 366
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "CDI"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_planhelp
integer x = 110
integer y = 448
integer width = 366
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "SIRE"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_planhelp
integer x = 110
integer y = 624
integer width = 366
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "MIRE"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_planhelp
integer x = 37
integer y = 128
integer width = 2267
integer height = 960
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_planhelp
integer x = 55
integer y = 48
integer width = 1499
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The Inspection due date colors denote the following:"
boolean focusrectangle = false
end type

