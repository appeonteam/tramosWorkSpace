$PBExportHeader$w_tc_port_exp_match.srw
$PBExportComments$Window for matching Port Expenses - accessed from w_tc_contract window
forward
global type w_tc_port_exp_match from mt_w_response
end type
type st_howto from statictext within w_tc_port_exp_match
end type
type cb_cancel from commandbutton within w_tc_port_exp_match
end type
type cb_ok from commandbutton within w_tc_port_exp_match
end type
type dw_port_exp_match from datawindow within w_tc_port_exp_match
end type
end forward

global type w_tc_port_exp_match from mt_w_response
integer width = 3095
integer height = 768
string title = "Match Port Expenses"
boolean ib_setdefaultbackgroundcolor = true
st_howto st_howto
cb_cancel cb_cancel
cb_ok cb_ok
dw_port_exp_match dw_port_exp_match
end type
global w_tc_port_exp_match w_tc_port_exp_match

type variables
s_port_exp_match istr_parameters
n_service_manager inv_servicemgr
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_tc_port_exp_match
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
		Date    		CR-Ref		Author 		Comments
		11/08/14		CR3708   	AGL027		F1 help application coverage - corrected ancestor.
		09/04/15		CR3854		XSZ004		Change the error message when no match port expenses.   
	</HISTORY>
********************************************************************/
end subroutine

on w_tc_port_exp_match.create
int iCurrent
call super::create
this.st_howto=create st_howto
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_port_exp_match=create dw_port_exp_match
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_howto
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_port_exp_match
end on

on w_tc_port_exp_match.destroy
call super::destroy
destroy(this.st_howto)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_port_exp_match)
end on

event open;call super::open;long	ll_retrieve[]
n_dw_style_service   lnv_style

this.visible = false

f_center_window(this)

istr_parameters = Message.PowerObjectParm

dw_port_exp_match.settransobject(SQLCA)
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_port_exp_match, false)

dw_port_exp_match.retrieve(istr_parameters.curr_code,istr_parameters.contract_id,istr_parameters.amount,istr_parameters.port_exp_id)

If dw_port_exp_match.rowcount() = 0 THEN
	messagebox("Validation Error", "You cannot match the port expenses, because no other port expenses with the same amount and included in a hire statement in status New or Draft can be found.")
	cb_cancel.triggerevent("clicked")
else
	this.visible = true
END IF
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_tc_port_exp_match
end type

type st_howto from statictext within w_tc_port_exp_match
integer x = 18
integer y = 8
integer width = 1239
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Select a port expense from the list to match:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_tc_port_exp_match
integer x = 2729
integer y = 560
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_ok from commandbutton within w_tc_port_exp_match
integer x = 2382
integer y = 560
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;IF dw_port_exp_match.getselectedrow(0) > 0 THEN
	closewithreturn(Parent, dw_port_exp_match.getitemnumber&
		(dw_port_exp_match.getselectedrow(0), "port_exp_id"))
ELSE
	Closewithreturn(Parent,0)
END IF
end event

type dw_port_exp_match from datawindow within w_tc_port_exp_match
integer x = 18
integer y = 80
integer width = 3054
integer height = 464
integer taborder = 10
string title = "none"
string dataobject = "d_tc_port_exp_match"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row > 0 then
	this.selectrow(0,false)
	this.selectrow(row,true)
end if
end event

