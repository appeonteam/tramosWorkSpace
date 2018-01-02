$PBExportHeader$w_area_ports.srw
$PBExportComments$Shows all Ports in a given Area
forward
global type w_area_ports from mt_w_sheet
end type
type dw_1 from datawindow within w_area_ports
end type
end forward

global type w_area_ports from mt_w_sheet
integer width = 1390
integer height = 1816
string title = "Other Ports in Area"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
dw_1 dw_1
end type
global w_area_ports w_area_ports

type variables
long 	il_area

n_service_manager inv_servicemgr

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_area_ports
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_area_ports.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_area_ports.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;n_dw_style_service   lnv_style
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")

il_area = message.doubleParm

lnv_style.of_dwlistformater( dw_1, false)
dw_1.setTransObject(SQLCA)
dw_1.post retrieve(il_area)

if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_area_ports
integer x = 384
integer y = 0
end type

type dw_1 from datawindow within w_area_ports
integer x = 32
integer y = 32
integer width = 1317
integer height = 1670
integer taborder = 10
string title = "none"
string dataobject = "d_area_ports"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row <= 0 then return

this.selectrow( 0, false)
this.selectrow( row, true)
end event

event rowfocuschanged;if currentrow <= 0 then return

this.selectrow( 0, false)
this.selectrow( currentrow, true)
end event

