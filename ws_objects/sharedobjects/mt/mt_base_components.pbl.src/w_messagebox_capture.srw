$PBExportHeader$w_messagebox_capture.srw
$PBExportComments$This window can be used to capture messages when running through a loop, and show them to the user when the loop is finished, instead of showing messageboxes
forward
global type w_messagebox_capture from window
end type
type cb_print from mt_u_commandbutton within w_messagebox_capture
end type
type cb_ok from mt_u_commandbutton within w_messagebox_capture
end type
type dw_messages from mt_u_datawindow within w_messagebox_capture
end type
end forward

global type w_messagebox_capture from window
boolean visible = false
integer width = 2464
integer height = 1516
boolean titlebar = true
string title = "Messages Captured During Report Generation"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_print cb_print
cb_ok cb_ok
dw_messages dw_messages
end type
global w_messagebox_capture w_messagebox_capture

forward prototypes
public function integer wf_addmessage (string as_title, string as_message)
end prototypes

public function integer wf_addmessage (string as_title, string as_message);long	ll_row

ll_row = dw_messages.insertRow(0)
if ll_row > 0 then
	dw_messages.setItem(ll_row, "message_title", as_title )
	dw_messages.setItem(ll_row, "message_body", as_message )
end if

return 1
	

end function

on w_messagebox_capture.create
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_messages=create dw_messages
this.Control[]={this.cb_print,&
this.cb_ok,&
this.dw_messages}
end on

on w_messagebox_capture.destroy
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_messages)
end on

type cb_print from mt_u_commandbutton within w_messagebox_capture
integer x = 1312
integer y = 1260
integer taborder = 30
string text = "&Print"
end type

event clicked;call super::clicked;dw_messages.print()
end event

type cb_ok from mt_u_commandbutton within w_messagebox_capture
integer x = 896
integer y = 1264
integer taborder = 20
string text = "&OK"
end type

event clicked;call super::clicked;close(parent)
end event

type dw_messages from mt_u_datawindow within w_messagebox_capture
integer x = 37
integer y = 28
integer width = 2350
integer height = 1176
integer taborder = 10
string dataobject = "d_ex_ff_messagebox_capture"
boolean hscrollbar = true
boolean vscrollbar = true
end type

