$PBExportHeader$mt_u_datepicker.sru
forward
global type mt_u_datepicker from datepicker
end type
end forward

global type mt_u_datepicker from datepicker
integer width = 567
integer height = 100
boolean border = true
borderstyle borderstyle = stylelowered!
string customformat = "dd/mm-yy hh:mm"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean todaysection = true
boolean todaycircle = true
end type
global mt_u_datepicker mt_u_datepicker

on mt_u_datepicker.create
end on

on mt_u_datepicker.destroy
end on

