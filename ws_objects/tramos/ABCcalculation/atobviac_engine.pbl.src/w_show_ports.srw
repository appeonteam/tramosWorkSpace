$PBExportHeader$w_show_ports.srw
forward
global type w_show_ports from mt_w_response
end type
type cb_saveas from commandbutton within w_show_ports
end type
type cb_print from commandbutton within w_show_ports
end type
type cb_ok from commandbutton within w_show_ports
end type
type dw_showport from u_dw within w_show_ports
end type
end forward

global type w_show_ports from mt_w_response
integer width = 2405
integer height = 2264
cb_saveas cb_saveas
cb_print cb_print
cb_ok cb_ok
dw_showport dw_showport
end type
global w_show_ports w_show_ports

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - corrected ancestor.
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;dw_showport.Object.DataWindow.Table.Select=message.stringparm
dw_showport.setTransObject(sqlca)
dw_showport.retrieve()
dw_showport.POST setrowfocusindicator( focusrect!)
dw_showport.POST setFocus()
end event

on w_show_ports.create
int iCurrent
call super::create
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_showport=create dw_showport
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saveas
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_showport
end on

on w_show_ports.destroy
call super::destroy
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_showport)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_ports
end type

type cb_saveas from commandbutton within w_show_ports
integer x = 1536
integer y = 2048
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_showport.saveas()
end event

type cb_print from commandbutton within w_show_ports
integer x = 1079
integer y = 2048
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

event clicked;dw_showport.print()
end event

type cb_ok from commandbutton within w_show_ports
integer x = 622
integer y = 2048
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

event clicked;close(parent)
end event

type dw_showport from u_dw within w_show_ports
integer width = 2386
integer height = 2008
integer taborder = 10
string dataobject = "d_sq_tb_show_ports"
boolean minbox = true
boolean ib_isupdateable = false
boolean ib_rmbmenu = false
end type

event constructor;call super::constructor;of_setSort(true)
if isValid(inv_sort) then inv_sort.of_setColumnheader( true )

end event

