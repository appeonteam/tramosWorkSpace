$PBExportHeader$w_marketassessment.srw
forward
global type w_marketassessment from window
end type
type cb_deactivate from mt_u_commandbutton within w_marketassessment
end type
type cb_marketchart from mt_u_commandbutton within w_marketassessment
end type
type cb_refresh from mt_u_commandbutton within w_marketassessment
end type
type st_7 from mt_u_statictext within w_marketassessment
end type
type cb_edit from mt_u_commandbutton within w_marketassessment
end type
type cb_activate from mt_u_commandbutton within w_marketassessment
end type
type cb_new from mt_u_commandbutton within w_marketassessment
end type
type cb_close from mt_u_commandbutton within w_marketassessment
end type
type dw_profit_center from mt_u_datawindow within w_marketassessment
end type
type dw_marketaccessment from datawindow within w_marketassessment
end type
type cbx_deactivated from mt_u_checkbox within w_marketassessment
end type
end forward

global type w_marketassessment from window
integer width = 4613
integer height = 1628
boolean titlebar = true
string title = "Fixture Market Assessment"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_refreshonerow ( integer al_marketassessmentid )
cb_deactivate cb_deactivate
cb_marketchart cb_marketchart
cb_refresh cb_refresh
st_7 st_7
cb_edit cb_edit
cb_activate cb_activate
cb_new cb_new
cb_close cb_close
dw_profit_center dw_profit_center
dw_marketaccessment dw_marketaccessment
cbx_deactivated cbx_deactivated
end type
global w_marketassessment w_marketassessment

type variables
integer ii_profitcenter
string	  is_filter
end variables

event ue_refreshonerow(integer al_marketassessmentid);long ll_found

setpointer(hourglass!)
dw_marketaccessment.setredraw( false )

dw_marketaccessment.settransobject( SQLCA)
dw_marketaccessment.retrieve(ii_profitcenter)

	
ll_found = dw_marketaccessment.find("marketassesmentid ="+string(al_marketassessmentid),1,999999)
if ll_found > 0 then
	dw_marketaccessment.selectrow(0, false)
	dw_marketaccessment.selectrow(ll_found,true)
	dw_marketaccessment.scrolltorow(ll_found)
end if

dw_marketaccessment.setredraw( true )
setpointer(Arrow!)
dw_marketaccessment.POST setfocus()
end event

on w_marketassessment.create
this.cb_deactivate=create cb_deactivate
this.cb_marketchart=create cb_marketchart
this.cb_refresh=create cb_refresh
this.st_7=create st_7
this.cb_edit=create cb_edit
this.cb_activate=create cb_activate
this.cb_new=create cb_new
this.cb_close=create cb_close
this.dw_profit_center=create dw_profit_center
this.dw_marketaccessment=create dw_marketaccessment
this.cbx_deactivated=create cbx_deactivated
this.Control[]={this.cb_deactivate,&
this.cb_marketchart,&
this.cb_refresh,&
this.st_7,&
this.cb_edit,&
this.cb_activate,&
this.cb_new,&
this.cb_close,&
this.dw_profit_center,&
this.dw_marketaccessment,&
this.cbx_deactivated}
end on

on w_marketassessment.destroy
destroy(this.cb_deactivate)
destroy(this.cb_marketchart)
destroy(this.cb_refresh)
destroy(this.st_7)
destroy(this.cb_edit)
destroy(this.cb_activate)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.dw_profit_center)
destroy(this.dw_marketaccessment)
destroy(this.cbx_deactivated)
end on

event open;dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

if (dw_profit_center.rowcount( ) > 0) then
		dw_profit_center.selectrow(1,true)
		ii_profitcenter = dw_profit_center.getItemNumber(1, "pc_nr")
		if ii_profitcenter <> 0 then
			if ii_profitcenter = 4 then
				dw_marketaccessment.dataobject = "d_marketaccessment_handy"
				dw_marketaccessment.width = 3794
				w_marketassessment.width = 4553
			else
				dw_marketaccessment.dataobject = "d_marketaccessment"
				dw_marketaccessment.width = 2260
				w_marketassessment.width = 3060
			end if
			dw_marketaccessment.settransobject(SQLCA)
			dw_marketaccessment.retrieve(ii_profitcenter)
		end if
		
		if SQLCA.SQLcode = 0 and dw_marketaccessment.rowcount( ) > 1 then
			cb_edit.enabled = true
			cb_activate.enabled = true
			cb_deactivate.enabled = true
			cb_refresh.enabled = true
		else 
			cb_edit.enabled = false
			cb_activate.enabled = false
			cb_deactivate.enabled = false
			cb_refresh.enabled = false
		end if
end if
end event

type cb_deactivate from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 1176
integer taborder = 70
string facename = "Arial"
boolean enabled = false
string text = "&Deactivate"
end type

event clicked;call super::clicked;long		ll_row
s_pf 		lstr_position
int 		li_pc_nr

ll_row = dw_marketaccessment.getRow()
if ll_row < 1 then return
dw_marketaccessment.setitem( ll_row, "activated", 0)
if MessageBox("Confirmation", "Are you sure you you want to deactivate the marketassessment?", question!, YesNo!,2) = 1 then 
	if dw_marketaccessment.update() = 1 then
		commit;
		dw_marketaccessment.retrieve(ii_profitcenter)
	else
		rollback;
		MessageBox("Update Error", "Error deactivating.")
		return -1
	end if
end if

end event

type cb_marketchart from mt_u_commandbutton within w_marketassessment
integer x = 78
integer y = 1404
integer width = 590
integer taborder = 70
string facename = "Arial"
string text = "&Enter Market chart info"
end type

event clicked;call super::clicked;opensheet (w_marketchart, w_tramos_main, 3, Original!)
end event

type cb_refresh from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 848
integer taborder = 70
string facename = "Arial"
boolean enabled = false
string text = "&Refresh"
end type

event clicked;call super::clicked;dw_marketaccessment.retrieve(ii_profitcenter)
end event

type st_7 from mt_u_statictext within w_marketassessment
integer x = 9
integer width = 599
integer height = 56
integer weight = 700
string facename = "Arial"
string text = "Select Profit Center(s):"
end type

type cb_edit from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 960
integer taborder = 50
string facename = "Arial"
boolean enabled = false
string text = "&Save All"
end type

event clicked;call super::clicked;int			li_x
if  dw_marketaccessment.rowcount( ) <> 0 then
	dw_marketaccessment.acceptText()
	if dw_marketaccessment.update() = 1 then
		commit;
		dw_marketaccessment.retrieve(ii_profitcenter)
	else
		rollback;
		MessageBox("Update Error", "Error updating.")
		return -1
	end if
end if
end event

type cb_activate from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 1068
integer taborder = 60
string facename = "Arial"
boolean enabled = false
string text = "&Activate"
end type

event clicked;call super::clicked;long		ll_row
s_pf 		lstr_position
int 		li_pc_nr

ll_row = dw_marketaccessment.getRow()
if ll_row < 1 then return
dw_marketaccessment.setitem( ll_row, "activated", 1)
if MessageBox("Confirmation", "Are you sure you you want to activate the marketassessment?", question!, YesNo!,2) = 1 then 
	if dw_marketaccessment.update() = 1 then
		commit;
		dw_marketaccessment.retrieve(ii_profitcenter)
	else
		rollback;
		MessageBox("Update Error", "Error deactivating.")
		return -1
	end if
end if

end event

type cb_new from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 736
integer taborder = 40
string facename = "Arial"
string text = "&New"
end type

event clicked;call super::clicked;long		ll_null, ll_row
int			li_pc_nr
s_pf 		lstr_marketassessment
integer	tmp[]

setNull(ll_null)

/* Profitcenter */
if ii_profitcenter = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter.")
	dw_profit_center.post setFocus()
	return
else 
	ll_row = dw_profit_center.getselectedrow(0)
	if ll_row < 1 then return
	lstr_marketassessment.id = ll_null
	tmp[1] = ii_profitcenter
	lstr_marketassessment.pc_nr = tmp
//	openSheetWithParm(w_modify_position, lstr_marketassessment, "w_new_marketassessment", parent.parentwindow()) 
	return 1
end if


end event

type cb_close from mt_u_commandbutton within w_marketassessment
integer x = 192
integer y = 1288
integer taborder = 60
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_profit_center from mt_u_datawindow within w_marketassessment
integer x = 14
integer y = 64
integer width = 727
integer height = 588
integer taborder = 20
string dataobject = "d_profit_center"
boolean vscrollbar = true
end type

event clicked;if row > 0 then
	selectrow(0, false)
	selectrow(row, true)	
	ii_profitcenter = this.getItemNumber(row, "pc_nr")
end if

if ii_profitcenter <> 0 then
	if ii_profitcenter = 4 then
		dw_marketaccessment.dataobject = "d_marketaccessment_handy"
		dw_marketaccessment.width = 3794
		w_marketassessment.width = 4553
	else
		dw_marketaccessment.dataobject = "d_marketaccessment"
		dw_marketaccessment.width = 2260
		w_marketassessment.width = 3060
	end if
	dw_marketaccessment.settransobject(SQLCA)
	dw_marketaccessment.retrieve(ii_profitcenter)
end if

dw_marketaccessment.setredraw(false)

if cbx_deactivated.checked = true then
	is_filter = ""
	cbx_deactivated.text = "Hide deactivated"
else
	is_filter = "activated = 1"
	cbx_deactivated.text = "Show deactivated"
end if

dw_marketaccessment.setfilter(is_filter)
dw_marketaccessment.filter()
dw_marketaccessment.setredraw(true)

if SQLCA.SQLcode = 0 and dw_marketaccessment.rowcount( ) > 0 then
	cb_new.enabled = true
	cb_edit.enabled = true
	cb_deactivate.enabled = true
	cb_activate.enabled = true
	cb_refresh.enabled = true
else 
	cb_new.enabled = false
	cb_edit.enabled = false
	cb_deactivate.enabled = false
	cb_activate.enabled = false
	cb_refresh.enabled = false
end if





end event

type dw_marketaccessment from datawindow within w_marketassessment
integer x = 759
integer y = 24
integer width = 3794
integer height = 1468
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_marketaccessment"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	post event rowfocuschanged( row )
end if
end event

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

type cbx_deactivated from mt_u_checkbox within w_marketassessment
integer x = 105
integer y = 664
integer width = 544
integer textsize = -8
string facename = "Arial"
string text = "Show deactivated"
end type

event clicked;call super::clicked;dw_marketaccessment.setredraw(false)

if cbx_deactivated.checked = true then
	is_filter = ""
	cbx_deactivated.text = "Hide deactivated"
else
	is_filter = "activated = 1"
	cbx_deactivated.text = "Show deactivated"
end if

dw_marketaccessment.setfilter(is_filter)
dw_marketaccessment.filter()
dw_marketaccessment.setredraw(true)
end event

