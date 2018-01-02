$PBExportHeader$w_ports_without_area.srw
$PBExportComments$Shows ports that do not have an area assigned
forward
global type w_ports_without_area from mt_w_main
end type
type cb_print from commandbutton within w_ports_without_area
end type
type cb_saveas from commandbutton within w_ports_without_area
end type
type cb_close from commandbutton within w_ports_without_area
end type
type dw_ports from u_datagrid within w_ports_without_area
end type
end forward

global type w_ports_without_area from mt_w_main
integer width = 1929
integer height = 1932
string title = "Ports without Area"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
cb_print cb_print
cb_saveas cb_saveas
cb_close cb_close
dw_ports dw_ports
end type
global w_ports_without_area w_ports_without_area

type variables
n_service_manager inv_servicemgr

end variables

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
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on w_ports_without_area.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_close=create cb_close
this.dw_ports=create dw_ports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_saveas
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.dw_ports
end on

on w_ports_without_area.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_close)
destroy(this.dw_ports)
end on

event open;n_dw_style_service   lnv_style
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_ports, false)

dw_ports.setTransObject(sqlca)
dw_ports.post retrieve()

if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_ports_without_area
integer x = 165
integer y = 128
end type

type cb_print from commandbutton within w_ports_without_area
integer x = 1207
integer y = 1720
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_ports.print()
end event

type cb_saveas from commandbutton within w_ports_without_area
integer x = 1554
integer y = 1720
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_ports.saveas()
end event

type cb_close from commandbutton within w_ports_without_area
boolean visible = false
integer x = 2414
integer y = 1600
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_ports from u_datagrid within w_ports_without_area
integer x = 32
integer y = 32
integer width = 1856
integer height = 1672
integer taborder = 20
string dataobject = "d_sq_tb_ports_without_area"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;if row <= 0 then return

this.selectrow( 0, false)
this.selectrow( row, true)
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return

this.selectrow( 0, false)
this.selectrow( currentrow, true)
end event

