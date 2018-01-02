$PBExportHeader$w_atobviac_find_portcode_response.srw
$PBExportComments$Find AtoBviaC portcode for a port, or a port near by; response window style
forward
global type w_atobviac_find_portcode_response from mt_w_response
end type
type cb_close from commandbutton within w_atobviac_find_portcode_response
end type
type uo_find_portcode from u_atobviac_find_portcode within w_atobviac_find_portcode_response
end type
end forward

global type w_atobviac_find_portcode_response from mt_w_response
integer width = 3250
integer height = 2080
string title = "Find AtoBviaC portcode"
long backcolor = 32304364
cb_close cb_close
uo_find_portcode uo_find_portcode
end type
global w_atobviac_find_portcode_response w_atobviac_find_portcode_response

type prototypes
end prototypes

type variables
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_atobviac_find_portcode_response
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	06/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor, new visual control so shared with other window
*****************************************************************/
end subroutine

on w_atobviac_find_portcode_response.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.uo_find_portcode=create uo_find_portcode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.uo_find_portcode
end on

on w_atobviac_find_portcode_response.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.uo_find_portcode)
end on

event open;call super::open;
n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwformformater(uo_find_portcode.dw_calc_longlat_search)
lnv_style.of_dwformformater(uo_find_portcode.dw_calc_unctad_search_name)
lnv_style.of_dwlistformater(uo_find_portcode.dw_port_list,false)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_atobviac_find_portcode_response
end type

type cb_close from commandbutton within w_atobviac_find_portcode_response
integer x = 2706
integer y = 1868
integer width = 485
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close with PortCode"
end type

event clicked;decimal ld_abc_portid
long ll_row

ll_row = uo_find_portcode.dw_port_list.GetSelectedRow(0)
if ll_row < 1 then
	ld_abc_portid = 0
else
	ld_abc_portid = uo_find_portcode.dw_port_list.GetItemNumber(ll_row,"abc_portid")
end if	
CloseWithReturn(Parent,ld_abc_portid)
end event

type uo_find_portcode from u_atobviac_find_portcode within w_atobviac_find_portcode_response
event destroy ( )
integer taborder = 10
end type

on uo_find_portcode.destroy
call u_atobviac_find_portcode::destroy
end on

