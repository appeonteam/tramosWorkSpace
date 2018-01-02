$PBExportHeader$mt_w_main.srw
forward
global type mt_w_main from mt_w_master
end type
type st_hidemenubar from statictext within mt_w_main
end type
end forward

global type mt_w_main from mt_w_master
st_hidemenubar st_hidemenubar
end type
global mt_w_main mt_w_main

type variables
boolean ib_enablef1help = true
end variables

on mt_w_main.create
int iCurrent
call super::create
this.st_hidemenubar=create st_hidemenubar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_hidemenubar
end on

on mt_w_main.destroy
call super::destroy
destroy(this.st_hidemenubar)
end on

type st_hidemenubar from statictext within mt_w_main
boolean visible = false
integer x = 9
integer y = 16
integer width = 827
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
string text = "hidden constructor code inside event"
boolean focusrectangle = false
end type

event constructor;n_service_manager		lnv_servicemgr
n_menu_service   lnv_menu

if ib_enablef1help then
	lnv_serviceMgr.of_loadservice( lnv_menu, "n_menu_service")	
	lnv_menu.of_addhelpmenu( parent, { "F1"})
end if
end event

