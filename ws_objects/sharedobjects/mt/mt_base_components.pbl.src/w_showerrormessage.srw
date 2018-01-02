$PBExportHeader$w_showerrormessage.srw
forward
global type w_showerrormessage from mt_w_response
end type
type cb_save from mt_u_commandbutton within w_showerrormessage
end type
type cb_print from mt_u_commandbutton within w_showerrormessage
end type
type cb_ok from mt_u_commandbutton within w_showerrormessage
end type
type dw_message from mt_u_datawindow within w_showerrormessage
end type
end forward

global type w_showerrormessage from mt_w_response
integer width = 2921
cb_save cb_save
cb_print cb_print
cb_ok cb_ok
dw_message dw_message
end type
global w_showerrormessage w_showerrormessage

on w_showerrormessage.create
int iCurrent
call super::create
this.cb_save=create cb_save
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_message=create dw_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_message
end on

on w_showerrormessage.destroy
call super::destroy
destroy(this.cb_save)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_message)
end on

event open;call super::open;string		ls_message
ls_message = message.stringparm

dw_message.insertRow(0)

dw_message.setItem(1, "message", ls_message)
end event

type cb_save from mt_u_commandbutton within w_showerrormessage
integer x = 1577
integer y = 1144
integer taborder = 40
string text = "&Save"
end type

type cb_print from mt_u_commandbutton within w_showerrormessage
integer x = 1166
integer y = 1144
integer taborder = 30
string text = "&Print"
end type

type cb_ok from mt_u_commandbutton within w_showerrormessage
integer x = 754
integer y = 1144
integer taborder = 20
string text = "&OK"
end type

event clicked;call super::clicked;closewithreturn(parent, 1)
end event

type dw_message from mt_u_datawindow within w_showerrormessage
integer x = 27
integer y = 20
integer width = 2857
integer height = 1048
integer taborder = 10
string dataobject = "d_ex_ff_showerrormessage"
boolean vscrollbar = true
end type

