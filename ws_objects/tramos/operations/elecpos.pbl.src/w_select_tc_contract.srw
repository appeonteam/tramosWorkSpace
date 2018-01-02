$PBExportHeader$w_select_tc_contract.srw
$PBExportComments$Window for selecting TC Contract
forward
global type w_select_tc_contract from mt_w_response
end type
type cb_ok from mt_u_commandbutton within w_select_tc_contract
end type
type cb_cancel from mt_u_commandbutton within w_select_tc_contract
end type
type dw_contract from datawindow within w_select_tc_contract
end type
end forward

global type w_select_tc_contract from mt_w_response
integer width = 3035
integer height = 1128
string title = "Select TC Contract"
long backcolor = 32304364
cb_ok cb_ok
cb_cancel cb_cancel
dw_contract dw_contract
end type
global w_select_tc_contract w_select_tc_contract

on w_select_tc_contract.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_contract=create dw_contract
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.dw_contract
end on

on w_select_tc_contract.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_contract)
end on

event open;s_select_tc_contract  lstr_parm

lstr_parm = message.powerobjectparm

dw_contract.setTransObject(sqlca)
if dw_contract.retrieve(lstr_parm.vessel_nr, lstr_parm.tc_hire_in, lstr_parm.purpose) < 1 then cb_ok.enabled = false
COMMIT;

dw_contract.SetRowFocusIndicator(Hand!)
end event

type cb_ok from mt_u_commandbutton within w_select_tc_contract
integer x = 2313
integer y = 924
integer taborder = 30
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;long ll_row

ll_row = dw_contract.getRow( )
if ll_row < 1 then return

closeWithReturn(parent, dw_contract.getItemNumber(ll_row, "contract_id"))

end event

type cb_cancel from mt_u_commandbutton within w_select_tc_contract
integer x = 2665
integer y = 924
integer taborder = 20
string text = "&Cancel"
end type

event clicked;call super::clicked;long  ll_null; setNull(ll_null)

CloseWithReturn(parent, ll_null)
end event

type dw_contract from datawindow within w_select_tc_contract
integer x = 32
integer y = 24
integer width = 2962
integer height = 876
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_tc_contracts"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;// this.selectRow(0, false)
//
// if currentrow > 0 then this.selectRow(currentrow, true)
end event

