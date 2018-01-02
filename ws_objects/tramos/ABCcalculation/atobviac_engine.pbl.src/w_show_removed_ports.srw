$PBExportHeader$w_show_removed_ports.srw
$PBExportComments$Utility window. Shows removed ports when receiving new distance table.
forward
global type w_show_removed_ports from mt_w_response
end type
type cb_delete from commandbutton within w_show_removed_ports
end type
type cb_print from commandbutton within w_show_removed_ports
end type
type cb_ok from commandbutton within w_show_removed_ports
end type
type dw_ports from datawindow within w_show_removed_ports
end type
end forward

global type w_show_removed_ports from mt_w_response
integer width = 3099
integer height = 1732
string title = "Removed Ports..."
boolean controlmenu = false
cb_delete cb_delete
cb_print cb_print
cb_ok cb_ok
dw_ports dw_ports
end type
global w_show_removed_ports w_show_removed_ports

type variables
datastore	ids_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_show_removed_ports
	
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

on w_show_removed_ports.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_ports=create dw_ports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_ports
end on

on w_show_removed_ports.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_ports)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_removed_ports
end type

type cb_delete from commandbutton within w_show_removed_ports
integer x = 32
integer y = 1524
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;long ll_rows, ll_row, ll_portID
integer li_count

if messageBox("Verify delete...", "Are you sure you will delete all ports listed that are not linked to TRAMOS?", Question!, YesNo!,2) = 2 then return

ll_rows = dw_ports.rowcount( )

for ll_row = ll_rows to 1 step -1
	if isNull(dw_ports.getItemString(ll_row, "port_code")) then 
		ll_portID = dw_ports.getItemNumber( ll_row, "abc_portid" )
		SELECT COUNT(*)
			INTO :li_count
			FROM LOCAL_ATOBVIAC_DISTANCE
			WHERE FROM_PORTID = :ll_portID
			OR TO_PORTID = :ll_portID ;
		if li_count > 0 then
			MessageBox("Information", "Port: "+ dw_ports.getItemString(ll_row, "abc_portcode")+" "+ dw_ports.getItemString(ll_row, "abc_portname")+" can't be deleted as it is used in local distances") 
		else
			dw_ports.deleterow(ll_row) 
		end if
	end if
next

if dw_ports.update( ) = 1 then
	commit;
else
	rollback;
	MessageBox("Delete Error", "Port delete failed! Please try again or contact system administartor")
end if
end event

type cb_print from commandbutton within w_show_removed_ports
integer x = 1637
integer y = 1524
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

type cb_ok from commandbutton within w_show_removed_ports
integer x = 1179
integer y = 1524
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

type dw_ports from datawindow within w_show_removed_ports
integer x = 32
integer y = 28
integer width = 3035
integer height = 1468
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_removed_portcodes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

