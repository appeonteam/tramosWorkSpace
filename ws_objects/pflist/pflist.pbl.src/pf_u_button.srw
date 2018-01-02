$PBExportHeader$pf_u_button.srw
forward
global type pf_u_button from window
end type
type cb_2 from mt_u_commandbutton within pf_u_button
end type
type cb_1 from mt_u_commandbutton within pf_u_button
end type
end forward

global type pf_u_button from window
integer width = 1129
integer height = 564
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
end type
global pf_u_button pf_u_button

on pf_u_button.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cb_2,&
this.cb_1}
end on

on pf_u_button.destroy
destroy(this.cb_2)
destroy(this.cb_1)
end on

type cb_2 from mt_u_commandbutton within pf_u_button
integer x = 32
integer y = 120
integer taborder = 10
string text = "&Save as"
end type

type cb_1 from mt_u_commandbutton within pf_u_button
integer x = 32
integer y = 4
integer taborder = 10
string text = "&Retrieve"
end type

