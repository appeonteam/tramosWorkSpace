$PBExportHeader$w_select_cp_broker.srw
forward
global type w_select_cp_broker from mt_w_response
end type
type cb_ok from mt_u_commandbutton within w_select_cp_broker
end type
type dw_broker from u_datagrid within w_select_cp_broker
end type
end forward

global type w_select_cp_broker from mt_w_response
integer width = 1664
integer height = 896
string title = "Select Broker"
boolean ib_setdefaultbackgroundcolor = true
cb_ok cb_ok
dw_broker dw_broker
end type
global w_select_cp_broker w_select_cp_broker

type variables
long il_broker_nr
boolean ib_ok
end variables

on w_select_cp_broker.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_broker=create dw_broker
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_broker
end on

on w_select_cp_broker.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_broker)
end on

event open;call super::open;//M5-6 Begin modified by ZSW001 on 28/02/2012
long		ll_cerpid, ll_broker_nr, ll_pos, ll_find
string	ls_parm

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_broker)

ls_parm = message.stringparm

ll_pos = pos(ls_parm, ",")
ll_cerpid = long(left(ls_parm, ll_pos - 1))
ll_broker_nr = long(mid(ls_parm, ll_pos + len(",")))

dw_broker.settransobject(sqlca)
dw_broker.retrieve(ll_cerpid)

ll_find = dw_broker.find("broker_nr = " + string(ll_broker_nr), 1, dw_broker.rowcount())
if ll_find > 0 then 
	dw_broker.scrolltorow(ll_find)
	dw_broker.selectrow(ll_find, true)
end if

dw_broker.setfocus()
//M5-6 End modified by ZSW001 on 28/02/2012

end event

event close;call super::close;long	ll_row, ll_null

setnull(ll_null)
ll_row = dw_broker.getselectedrow(0)
if ll_row > 0 then
	if not ib_ok then il_broker_nr = ll_null
	closewithreturn(this, il_broker_nr)
else
	if ib_ok then ll_null = il_broker_nr
	closewithreturn(this, ll_null)
end if

end event

type cb_ok from mt_u_commandbutton within w_select_cp_broker
integer x = 1275
integer y = 684
integer taborder = 20
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;long	ll_row

ib_ok = true

ll_row = dw_broker.getselectedrow(0)
if ll_row > 0 then 
	il_broker_nr = dw_broker.getitemnumber(ll_row, "broker_nr")
	closewithreturn(parent, il_broker_nr)		//M5-6 Modified by ZSW001 on 17/02/2012.
else
	il_broker_nr = 0
	closewithreturn(parent, il_broker_nr)		//CR2828
end if

end event

type dw_broker from u_datagrid within w_select_cp_broker
integer x = 37
integer y = 32
integer width = 1582
integer height = 640
integer taborder = 10
string title = ""
string dataobject = "d_sq_gr_select_cp_broker"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if row > 0 then
	if this.isselected(row) then
		this.selectrow(row, false)
	else
		if dw_broker.getitemnumber(row, "brokers_broker_pool_manager") = 0 then	
			this.selectrow(0, false)
			this.selectrow(row, true)
		end if
	end if
end if
end event

