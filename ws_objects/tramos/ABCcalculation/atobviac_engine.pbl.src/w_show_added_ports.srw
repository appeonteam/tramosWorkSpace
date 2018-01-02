$PBExportHeader$w_show_added_ports.srw
$PBExportComments$Utility window. Shows added ports when feeding distance table.
forward
global type w_show_added_ports from mt_w_response
end type
type cb_print from commandbutton within w_show_added_ports
end type
type cb_ok from commandbutton within w_show_added_ports
end type
type dw_ports from datawindow within w_show_added_ports
end type
end forward

global type w_show_added_ports from mt_w_response
integer width = 3442
integer height = 1852
string title = "Added Ports..."
boolean controlmenu = false
cb_print cb_print
cb_ok cb_ok
dw_ports dw_ports
end type
global w_show_added_ports w_show_added_ports

type variables
datastore	ids_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_show_added_ports
	
	<OBJECT>

	</OBJECT>
  	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

event open;ids_data = CREATE datastore
ids_data = message.PowerObjectParm

dw_ports.dataObject = ids_data.dataObject
ids_data.shareData(dw_ports)


end event

on w_show_added_ports.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_ports=create dw_ports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_ports
end on

on w_show_added_ports.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_ports)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_added_ports
end type

type cb_print from commandbutton within w_show_added_ports
integer x = 1774
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_ports.print()
end event

type cb_ok from commandbutton within w_show_added_ports
integer x = 1317
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;dw_ports.shareDataOff()
closewithreturn ( parent, 0 )
end event

type dw_ports from datawindow within w_show_added_ports
integer x = 32
integer y = 124
integer width = 3365
integer height = 1468
integer taborder = 10
string title = "none"
string dataobject = "d_ex_tb_new_ports"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

