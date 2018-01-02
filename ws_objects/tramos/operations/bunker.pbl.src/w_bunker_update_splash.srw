$PBExportHeader$w_bunker_update_splash.srw
$PBExportComments$Splash window
forward
global type w_bunker_update_splash from window
end type
type st_application from u_st within w_bunker_update_splash
end type
end forward

global type w_bunker_update_splash from window
integer x = 741
integer y = 780
integer width = 2021
integer height = 392
boolean enabled = false
windowtype windowtype = popup!
long backcolor = 16777215
boolean center = true
st_application st_application
end type
global w_bunker_update_splash w_bunker_update_splash

type variables
end variables

on w_bunker_update_splash.create
this.st_application=create st_application
this.Control[]={this.st_application}
end on

on w_bunker_update_splash.destroy
destroy(this.st_application)
end on

type st_application from u_st within w_bunker_update_splash
integer x = 69
integer y = 120
integer width = 1897
integer height = 140
integer textsize = -16
fontcharset fontcharset = ansi!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Updating bunker and CODA transactions..."
alignment alignment = Center!
end type

