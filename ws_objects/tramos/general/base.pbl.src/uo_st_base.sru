$PBExportHeader$uo_st_base.sru
$PBExportComments$The Base object for StaticText
forward
global type uo_st_base from statictext
end type
end forward

global type uo_st_base from statictext
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type
global uo_st_base uo_st_base

on uo_st_base.create
end on

on uo_st_base.destroy
end on

