$PBExportHeader$w_cargo_dischage.srw
forward
global type w_cargo_dischage from mt_w_response
end type
type cb_discharge from mt_u_commandbutton within w_cargo_dischage
end type
type cb_cancel from mt_u_commandbutton within w_cargo_dischage
end type
type dw_cargo from u_datagrid within w_cargo_dischage
end type
type cbx_selectall from checkbox within w_cargo_dischage
end type
end forward

global type w_cargo_dischage from mt_w_response
integer width = 4238
integer height = 1408
string title = "Cargo Discharge"
cb_discharge cb_discharge
cb_cancel cb_cancel
dw_cargo dw_cargo
cbx_selectall cbx_selectall
end type
global w_cargo_dischage w_cargo_dischage

type variables
long il_agent
boolean ib_accepttext

s_cargo_discharge ist_cargo
n_messagebox inv_messagebox
private u_dddw_search inv_dddw_search_agent

end variables

forward prototypes
public subroutine wf_set_cargo_detail_id (mt_n_datastore ads_cargo, mt_n_datastore ads_bol)
public subroutine wf_jump_claims (mt_n_datastore ads_bol)
public subroutine documentation ()
end prototypes

public subroutine wf_set_cargo_detail_id (mt_n_datastore ads_cargo, mt_n_datastore ads_bol);
long ll_row, ll_index, ll_dummy_cd_id, ll_cargo_detail_id

for ll_row = 1 to ads_cargo.rowcount()
	ll_dummy_cd_id = ads_cargo.getitemnumber(ll_row, "dummy_cd_id")
	ll_cargo_detail_id = ads_cargo.getitemnumber(ll_row, "cargo_detail_id")
	if isnull(ll_dummy_cd_id) or ll_dummy_cd_id <= 0 then continue
	
	ads_bol.setfilter("dummy_cd_id = " + string(ll_dummy_cd_id))
	ads_bol.filter()
	
	for ll_index = 1 to ads_bol.rowcount()
		ads_bol.setitem(ll_index, "cargo_detail_id", ll_cargo_detail_id)
	next
next

ads_bol.setfilter("")
ads_bol.filter()
end subroutine

public subroutine wf_jump_claims (mt_n_datastore ads_bol);/********************************************************************
   wf_jump_claims
   <DESC>	This function is used to check the load temperature against the discharge 
	temperature if the product is 'Dirty' and the profitcenter is setup to do this check.
	Only do the chsck if there is not a Heating claim already registred.</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_bol
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_chartnr, li_dirty_product, li_validate_cargo_temp
long ll_row, ll_cerpid, ll_counter
dec ld_min_loadtemperature, ld_max_dischargetemperature, ld_temp_difference
string ls_gradename
u_jump_claims luo_jump_claims

SELECT VALIDATE_CARGO_TEMP, NOTIFY_ON_TEMP_DIFF
INTO :li_validate_cargo_temp, :ld_temp_difference
FROM PROFIT_C, VESSELS
WHERE PROFIT_C.PC_NR = VESSELS.PC_NR
AND VESSELS.VESSEL_NR = :ist_cargo.vessel_nr;

if li_validate_cargo_temp = 0 then return

for ll_row = 1 to ads_bol.rowcount()
	li_dirty_product = ads_bol.getitemnumber(ll_row, "dirty_product")
	ls_gradename = ads_bol.getitemstring(ll_row, "grade_name")
	ll_cerpid = ads_bol.getitemnumber(ll_row, "cal_cerp_id")
	li_chartnr = ads_bol.getitemnumber(ll_row, "chart_nr")
	
	if li_dirty_product <> 1 then continue
	
	SELECT count(*)
	INTO :ll_counter
	FROM CLAIMS
	WHERE VESSEL_NR = :ist_cargo.vessel_nr
	AND VOYAGE_NR = :ist_cargo.voyage_nr
	AND CHART_NR = :li_chartnr
	AND CLAIM_TYPE = "HEA";
	
	if ll_counter > 0 then continue
	
	SELECT min(CARGO_TEMP) 
	INTO :ld_min_loadtemperature
	FROM BOL 
	WHERE VESSEL_NR = :ist_cargo.vessel_nr
	AND VOYAGE_NR = :ist_cargo.voyage_nr
	AND GRADE_NAME = :ls_gradename
	AND CAL_CERP_ID = :ll_cerpid 
	AND L_D = 1;
	
	SELECT max(CARGO_TEMP) 
	INTO :ld_max_dischargetemperature
	FROM BOL
	WHERE VESSEL_NR = :ist_cargo.vessel_nr
	AND VOYAGE_NR = :ist_cargo.voyage_nr
	AND GRADE_NAME = :ls_gradename
	AND CAL_CERP_ID = :ll_cerpid 
	AND L_D = 0;
	
	if isnull(ld_min_loadtemperature) or isnull(ld_max_dischargetemperature) then
		// Do nothing !
	else
		if ld_max_dischargetemperature - ld_min_loadtemperature >= ld_temp_difference then
			ist_cargo.jump_chartnr = li_chartnr
			ist_cargo.max_temp = ld_max_dischargetemperature
			ist_cargo.min_temp = ld_min_loadtemperature
			ist_cargo.diff_temp = ld_temp_difference
			return
		end if
	end if
next

end subroutine

public subroutine documentation ();/********************************************************************
   w_cargo_dischage
   <OBJECT></OBJECT>
   <USAGE>	</USAGE>
   <ALSO>
	</ALSO>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		Apply latest standard for dddw column
	</HISTORY>
********************************************************************/
end subroutine

on w_cargo_dischage.create
int iCurrent
call super::create
this.cb_discharge=create cb_discharge
this.cb_cancel=create cb_cancel
this.dw_cargo=create dw_cargo
this.cbx_selectall=create cbx_selectall
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_discharge
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.dw_cargo
this.Control[iCurrent+4]=this.cbx_selectall
end on

on w_cargo_dischage.destroy
call super::destroy
destroy(this.cb_discharge)
destroy(this.cb_cancel)
destroy(this.dw_cargo)
destroy(this.cbx_selectall)
end on

event open;call super::open;
long ll_agent_nr, ll_row, ll_default_agent_nr
dec{2} ld_max_amount, ld_null
s_cargo_discharge lst_cargo
n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style
datawindowchild ldwc_agent

ist_cargo = message.powerobjectparm

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_cargo, false)
lnv_style.of_autoadjustdddwwidth(dw_cargo, "disch_agent")
lnv_style.of_autoadjustdddwwidth(dw_cargo, "cd_grade_name")

dw_cargo.settransobject(sqlca)

dw_cargo.retrieve(ist_cargo.vessel_nr, ist_cargo.voyage_nr, ist_cargo.port_order, ist_cargo.cerp_id, ist_cargo.chart_nr)

if ist_cargo.agent_nr > 0 then
	ll_agent_nr = ist_cargo.agent_nr
end if

if isnull(ll_agent_nr) or ll_agent_nr <= 0 or not f_agent_active(ll_agent_nr) then
	ll_agent_nr = uo_global.ii_defaultagentnr
end if

if isnull(ll_agent_nr) or ll_agent_nr <= 0 or not f_agent_active(ll_agent_nr) then
	SELECT TOP 1 SUM(DISB_PAYMENTS.PAYMENT_AMOUNT), DISB_PAYMENTS.AGENT_NR
	INTO :ld_max_amount, :ll_agent_nr
	FROM DISB_PAYMENTS  , AGENTS
	WHERE ( DISB_PAYMENTS.VESSEL_NR = :ist_cargo.vessel_nr ) AND  
				( DISB_PAYMENTS.VOYAGE_NR = :ist_cargo.voyage_nr ) AND  
				( DISB_PAYMENTS.PORT_CODE = :ist_cargo.port_code) AND  
				( DISB_PAYMENTS.PCN = :ist_cargo.pcn)   
	GROUP BY DISB_PAYMENTS.VESSEL_NR, DISB_PAYMENTS.VOYAGE_NR, DISB_PAYMENTS.PORT_CODE, DISB_PAYMENTS.PCN, DISB_PAYMENTS.AGENT_NR
	ORDER BY SUM(DISB_PAYMENTS.PAYMENT_AMOUNT) DESC ;
end if
	
if not isnull(ll_agent_nr) and ll_agent_nr > 0 then
	if not f_agent_active(ll_agent_nr) then ll_agent_nr = 0
end if
	
if not isnull(ll_agent_nr) and ll_agent_nr > 0 then
	il_agent = ll_agent_nr
end if

setnull(ld_null)
for ll_row = 1 to dw_cargo.rowcount()
	if not isnull(ll_agent_nr) and ll_agent_nr > 0 then	dw_cargo.setitem(ll_row, "disch_agent", ll_agent_nr)
	
	dw_cargo.setitem(ll_row, "cargo_temp", ld_null)
next

if dw_cargo.rowcount() > 0 then cbx_selectall.enabled = true

if dw_cargo.getchild("disch_agent", ldwc_agent) = 1 then 
	ldwc_agent.setfilter("agent_active = 1")
	ldwc_agent.filter()
end if

end event

event closequery;call super::closequery;message.powerobjectparm = ist_cargo
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_cargo_dischage
end type

type cb_discharge from mt_u_commandbutton within w_cargo_dischage
integer x = 3502
integer y = 1196
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string text = "&Discharge"
end type

event clicked;call super::clicked;long ll_row, ll_agent_nr, ll_findrow, ll_newrow, ll_cerp_id, ll_caio_id, ll_cargo_detail_id, ll_cargo_detail_id_disch, ll_identity, ll_dummy_cd_id
integer li_sel, li_chart_nr, li_nor_from_poc, li_dirty_product, li_validate_cargo_temp
dec{4} ld_quantity, ld_cargo_temp
datetime ldt_boldate, ldt_arrival, ldt_departure, ldt_berthing
string ls_layout_bol
dwitemstatus ld_cargo_status
mt_n_datastore lds_chart, lds_cargo, lds_bol

ib_accepttext = true
if dw_cargo.accepttext( ) <> 1 then 
	ib_accepttext = false
	return
end if
ib_accepttext = false

ll_findrow = dw_cargo.find("select_flag = 1", 1, dw_cargo.rowcount())
if ll_findrow = 0 then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "Select cargo before update.", parent)
	return
end if

do while ll_findrow > 0
	ls_layout_bol = trim(dw_cargo.getitemstring(ll_findrow, "bol_layout_bl"))
	ll_agent_nr = dw_cargo.getitemnumber(ll_findrow, "disch_agent")
	ld_quantity = dw_cargo.getitemnumber(ll_findrow, "disch_quantity")
	ldt_boldate = dw_cargo.getitemdatetime(ll_findrow, "bl_date")
	li_dirty_product = dw_cargo.getitemnumber(ll_findrow, "dirty_product")
	li_validate_cargo_temp = dw_cargo.getitemnumber(ll_findrow, "validate_cargo_temp")
	ld_cargo_temp = dw_cargo.getitemnumber(ll_findrow, "cargo_temp")
	
	if isnull(ls_layout_bol) or ls_layout_bol = "" then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The data inside Layout cannot be empty.", parent)
		dw_cargo.setrow(ll_findrow)
		dw_cargo.scrolltorow(ll_findrow)
		dw_cargo.setcolumn("bol_layout_bl")
		dw_cargo.setfocus()
		return
	end if
	
	if isnull(ll_agent_nr) then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The Agent cannot be empty.", parent)
		dw_cargo.setrow(ll_findrow)
		dw_cargo.scrolltorow(ll_findrow)
		dw_cargo.setcolumn("disch_agent")
		dw_cargo.setfocus()
		return
	end if
	
	if not f_agent_active(ll_agent_nr) then 
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You have selected an inactive agent. Select an active agent to continue.", parent)
		dw_cargo.setrow(ll_findrow)
		dw_cargo.scrolltorow(ll_findrow)
		dw_cargo.setcolumn("disch_agent")
		dw_cargo.setfocus()
		return
	end if
	
	if isnull(ld_quantity) or ld_quantity = 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The Quantity cannot be empty.", parent)
		dw_cargo.setrow(ll_findrow)
		dw_cargo.scrolltorow(ll_findrow)
		dw_cargo.setcolumn("disch_quantity")
		dw_cargo.setfocus()
		return
	end if
	
	if li_dirty_product = 1 and li_validate_cargo_temp = 1 then
		if isnull(ld_cargo_temp)  then
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The Cargo Temperature cannot be empty.", parent)
			dw_cargo.setrow(ll_findrow)
			dw_cargo.scrolltorow(ll_findrow)
			dw_cargo.setcolumn("cargo_temp")
			dw_cargo.setfocus()
			return
		end if
	end if
	
	ll_findrow++
	if ll_findrow > dw_cargo.rowcount() then exit
	
	ll_findrow = dw_cargo.find("select_flag = 1", ll_findrow, dw_cargo.rowcount())
loop

lds_chart = create mt_n_datastore
lds_cargo = create mt_n_datastore
lds_bol = create mt_n_datastore

lds_chart.dataobject = "dw_cargo_list"
lds_cargo.dataobject = "dw_cargo_detail_list"
lds_bol.dataobject = "d_sq_gr_bol"

lds_chart.settransobject(sqlca)
lds_cargo.settransobject(sqlca)
lds_bol.settransobject(sqlca)

lds_chart.retrieve(ist_cargo.vessel_nr, ist_cargo.voyage_nr, ist_cargo.port_code, ist_cargo.pcn)
lds_cargo.retrieve(ist_cargo.vessel_nr, ist_cargo.voyage_nr, ist_cargo.port_code, ist_cargo.pcn)
//lds_bol.retrieve(ist_cargo.vessel_nr, ist_cargo.voyage_nr, ist_cargo.port_code, ist_cargo.pcn)

SELECT PROFIT_C.BOL_NOR_DATE_FROM_POC
INTO :li_nor_from_poc
FROM VESSELS, PROFIT_C
WHERE VESSELS.PC_NR = PROFIT_C.PC_NR
AND VESSELS.VESSEL_NR = :ist_cargo.vessel_nr;

SELECT PORT_ARR_DT, PORT_BERTHING_TIME, PORT_DEPT_DT INTO :ldt_arrival, :ldt_berthing, :ldt_departure
FROM POC
WHERE VESSEL_NR = :ist_cargo.vessel_nr
AND VOYAGE_NR = :ist_cargo.voyage_nr
AND PORT_CODE = :ist_cargo.port_code
AND PCN = :ist_cargo.pcn;

ll_findrow = dw_cargo.find("select_flag = 1", 1, dw_cargo.rowcount())
do while ll_findrow > 0
	li_chart_nr = dw_cargo.getitemnumber(ll_findrow, "cd_chart_nr") 
	ll_agent_nr = dw_cargo.getitemnumber(ll_findrow, "disch_agent") 
	ll_cerp_id = dw_cargo.getitemnumber(ll_findrow, "cd_cal_cerp_id") 
	ll_cargo_detail_id = dw_cargo.getitemnumber(ll_findrow, "cd_cargo_detail_id") 
	li_dirty_product = dw_cargo.getitemnumber(ll_findrow, "dirty_product")
	
	ll_row = lds_chart.find("chart_nr=" + string(li_chart_nr) + " and agent_nr=" + string(ll_agent_nr) + " and cargo_cal_cerp_id=" + string(ll_cerp_id), 1, lds_chart.rowcount())
	if ll_row = 0 then
		ll_newrow = lds_chart.insertrow(0)
		lds_chart.setitem(ll_newrow, "vessel_nr", ist_cargo.vessel_nr)
		lds_chart.setitem(ll_newrow, "voyage_nr", ist_cargo.voyage_nr)
		lds_chart.setitem(ll_newrow, "port_code", ist_cargo.port_code)
		lds_chart.setitem(ll_newrow, "pcn", ist_cargo.pcn)
		lds_chart.setitem(ll_newrow, "chart_nr", li_chart_nr)
		lds_chart.setitem(ll_newrow, "agent_nr", ll_agent_nr)
		lds_chart.setitem(ll_newrow, "cargo_cal_cerp_id", ll_cerp_id)
	end if
	
	ll_row = lds_cargo.find("load_cargo_detail_id = " + string(ll_cargo_detail_id) + " and agent_nr=" + string(ll_agent_nr), 1, lds_cargo.rowcount())
	if ll_row = 0 then
		ll_newrow = lds_cargo.insertrow(0)
		ll_identity++
		ll_cargo_detail_id_disch = 0
		ll_dummy_cd_id = ll_identity
		
		lds_cargo.setitem(ll_newrow, "dummy_cd_id", ll_dummy_cd_id)
		lds_cargo.setitemstatus(ll_newrow, "dummy_cd_id", primary!, notmodified!)
		
		lds_cargo.setitem(ll_newrow, "l_d", "D")
		lds_cargo.setitem(ll_newrow, "vessel_nr", ist_cargo.vessel_nr)
		lds_cargo.setitem(ll_newrow, "voyage_nr", ist_cargo.voyage_nr)
		lds_cargo.setitem(ll_newrow, "port_code", ist_cargo.port_code)
		lds_cargo.setitem(ll_newrow, "pcn", ist_cargo.pcn)
		lds_cargo.setitem(ll_newrow, "cd_cal_cerp_id", ll_cerp_id)
		lds_cargo.setitem(ll_newrow, "agent_nr", ll_agent_nr)
		lds_cargo.setitem(ll_newrow, "chart_nr", li_chart_nr)
		lds_cargo.setitem(ll_newrow, "cd_cal_caio_id", dw_cargo.getitemnumber(ll_findrow, "cd_cal_caio_id"))
		lds_cargo.setitem(ll_newrow, "ships_fig", dw_cargo.getitemnumber(ll_findrow, "cd_ships_fig"))
		lds_cargo.setitem(ll_newrow, "layout", dw_cargo.getitemstring(ll_findrow, "cd_layout"))
		lds_cargo.setitem(ll_newrow, "grade_name", dw_cargo.getitemstring(ll_findrow, "cd_grade_name"))
		lds_cargo.setitem(ll_newrow, "grade_group", dw_cargo.getitemstring(ll_findrow, "cd_grade_group"))
		lds_cargo.setitem(ll_newrow, "load_cargo_detail_id", ll_cargo_detail_id)
		lds_cargo.setitem(ll_newrow, "surveyor_fig", dw_cargo.getitemnumber(ll_findrow, "cd_surveyor_fig"))
	else 
		ld_cargo_status = lds_cargo.getitemstatus(ll_row, 0, primary!)
		if ld_cargo_status = new! or ld_cargo_status = newmodified! then
			ll_cargo_detail_id_disch = 0
			ll_dummy_cd_id = lds_cargo.getitemnumber(ll_row, "dummy_cd_id")
		else
			ll_cargo_detail_id_disch = lds_cargo.getitemnumber(ll_row, "cargo_detail_id")
			ll_dummy_cd_id = 0
		end if
	end if
	
	ll_newrow = lds_bol.insertrow(0)
	if ll_dummy_cd_id > 0 then
		lds_bol.setitem(ll_newrow, "dummy_cd_id", ll_dummy_cd_id)
		lds_bol.setitemstatus(ll_newrow, "dummy_cd_id", primary!, notmodified!)
	end if
	
	lds_bol.setitem(ll_newrow, "vessel_nr", ist_cargo.vessel_nr)
	lds_bol.setitem(ll_newrow, "voyage_nr", ist_cargo.voyage_nr)
	lds_bol.setitem(ll_newrow, "port_code", ist_cargo.port_code)
	lds_bol.setitem(ll_newrow, "pcn", ist_cargo.pcn)
	lds_bol.setitem(ll_newrow, "agent_nr", ll_agent_nr)
	lds_bol.setitem(ll_newrow, "chart_nr", li_chart_nr)
	lds_bol.setitem(ll_newrow, "cal_cerp_id", ll_cerp_id)
	lds_bol.setitem(ll_newrow, "layout", dw_cargo.getitemstring(ll_findrow, "cd_layout"))
	lds_bol.setitem(ll_newrow, "layout_bl", dw_cargo.getitemstring(ll_findrow, "bol_layout_bl"))
	lds_bol.setitem(ll_newrow, "grade_name", dw_cargo.getitemstring(ll_findrow, "cd_grade_name"))
	lds_bol.setitem(ll_newrow, "grade_group", dw_cargo.getitemstring(ll_findrow, "cd_grade_group"))
	lds_bol.setitem(ll_newrow, "cargo_detail_id", ll_cargo_detail_id_disch)
	lds_bol.setitem(ll_newrow, "l_d", 0)
	lds_bol.setitem(ll_newrow, "bol_nr", dw_cargo.getitemnumber(ll_findrow, "bol_bol_nr"))
	lds_bol.setitem(ll_newrow, "bol_quantity", dw_cargo.getitemnumber(ll_findrow, "disch_quantity"))
	lds_bol.setitem(ll_newrow, "recieved", dw_cargo.getitemdatetime(ll_findrow, "bl_date") )
	lds_bol.setitem(ll_newrow, "all_fast_dt", ldt_berthing)
	lds_bol.setitem(ll_newrow, "departure_dt", ldt_departure)
	lds_bol.setitem(ll_newrow, "rate_type", 0)
	lds_bol.setitem(ll_newrow, "gear", 0)
	lds_bol.setitem(ll_newrow, "temp_type", dw_cargo.getitemnumber(ll_findrow, "temp_type"))
	lds_bol.setitem(ll_newrow, "cargo_temp", dw_cargo.getitemnumber(ll_findrow, "cargo_temp"))
	lds_bol.setitem(ll_newrow, "dirty_product", li_dirty_product)
	lds_bol.setitemstatus(ll_newrow, "dirty_product", primary!, notmodified!)
	if li_nor_from_poc=1 then
		lds_bol.setitem(ll_newrow, "nor_dt", ldt_arrival )
	end if	

	ll_findrow++
	if ll_findrow > dw_cargo.rowcount() then exit
	
	ll_findrow = dw_cargo.find("select_flag = 1", ll_findrow, dw_cargo.rowcount())
loop

if lds_chart.update() = 1 then
	if lds_cargo.update() = 1 then
		wf_set_cargo_detail_id(lds_cargo, lds_bol)
		
		if lds_bol.update() = 1 then
			commit;
			ist_cargo.return_flag = 1
			wf_jump_claims(lds_bol)
			
			destroy lds_chart
			destroy lds_cargo
			destroy lds_bol
			close(parent)
			return
		else
			rollback;
		end if
	else
		rollback;
	end if
else
	rollback;
end if

destroy lds_chart
destroy lds_cargo
destroy lds_bol

end event

type cb_cancel from mt_u_commandbutton within w_cargo_dischage
integer x = 3849
integer y = 1196
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "&Cancel"
end type

event clicked;call super::clicked;long ll_row
decimal ld_null

dw_cargo.retrieve(ist_cargo.vessel_nr, ist_cargo.voyage_nr, ist_cargo.port_order, ist_cargo.cerp_id, ist_cargo.chart_nr)

setnull(ld_null)
for ll_row = 1 to dw_cargo.rowcount()
	if not isnull(il_agent) and il_agent > 0 then dw_cargo.setitem(ll_row, "disch_agent", il_agent)
	
	dw_cargo.setitem(ll_row, "cargo_temp", ld_null)
next


cb_discharge.enabled = false
cb_cancel.enabled = false
cbx_selectall.checked = false
cbx_selectall.text = "Select all"
end event

type dw_cargo from u_datagrid within w_cargo_dischage
event ue_refreshdddw ( )
integer x = 37
integer y = 32
integer width = 4155
integer height = 1144
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_gr_cargo_discharge"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_editmaskselect = true
end type

event ue_refreshdddw();/********************************************************************
   ue_refreshdddw
   <DESC>	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_agent_nr, ll_row
string ls_filter
datawindowchild	ldwc_agent

ll_row = this.getrow()
if ll_row < 1 then return

if dw_cargo.getchild("disch_agent", ldwc_agent) <> 1 then return

ll_agent_nr = this.getitemnumber(ll_row, "disch_agent")
if isnull(ll_agent_nr) or ll_agent_nr = 0 then
	ls_filter = "agent_active = 1"
else
	ls_filter = "(agent_active = 1 or agent_nr = " + string(ll_agent_nr) + ")"
end if
	
ldwc_agent.setfilter(ls_filter)
ldwc_agent.filter()
end event

event editchanged;call super::editchanged;choose case dwo.name
	case "disch_agent"
		inv_dddw_search_agent.uf_editchanged()
end choose

cb_cancel.enabled = true
this.setfocus()
end event

event constructor;call super::constructor;
inv_dddw_search_agent = CREATE u_dddw_search
inv_dddw_search_agent.of_register(dw_cargo, "disch_agent", "agent_sn", true, true)
end event

event itemchanged;call super::itemchanged;long ll_row, ll_findrow
datawindowchild ldwc_agent

if row < 1 then return

if dwo.name = "disch_agent" then
	this.getchild("disch_agent", ldwc_agent)
	ll_row = ldwc_agent.find("agent_nr = " + data, 1, ldwc_agent.rowcount())
	if ll_row > 0 then
		
	else
		return 2
	end if	
end if

if dwo.name = "select_flag" then
	ll_findrow = dw_cargo.find( "select_flag = 1 and getrow() <> " + string(row), 1, dw_cargo.rowcount())
	if ll_findrow = 0 and data = "1" then ll_findrow = row
else
	ll_findrow = dw_cargo.find( "select_flag = 1", 1, dw_cargo.rowcount())
end if

cb_cancel.enabled = true
cb_discharge.enabled = ll_findrow > 0
end event

event destructor;call super::destructor;destroy inv_dddw_search_agent
end event

event rowfocuschanged;call super::rowfocuschanged;//this.event ue_refreshdddw()
//if currentrow > 0 then this.setcolumn("disch_agent")
end event

event ue_lbuttondown;//
end event

event itemerror;call super::itemerror;string ls_coltitle, ls_colname

this.selecttext(1, len(data))

ls_colname = dwo.name

if ls_colname = "disch_agent" then
	return 3
else
	return 0
end if
end event

event ue_set_column;call super::ue_set_column;if this.getcolumnname() = "disch_agent" then
	this.of_set_column()
end if

end event

type cbx_selectall from checkbox within w_cargo_dischage
integer x = 37
integer y = 1196
integer width = 393
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
string text = "Select all"
end type

event clicked;long ll_row

if this.checked then
	for ll_row = 1 to dw_cargo.rowcount()
		dw_cargo.setitem( ll_row, "select_flag", 1)
	next
	
	this.text = "Deselect all"
	cb_discharge.enabled = true
else
	for ll_row = 1 to dw_cargo.rowcount()
		dw_cargo.setitem( ll_row, "select_flag", 0)
	next
	
	this.text = "Select all"
	cb_discharge.enabled = false
end if

cb_cancel.enabled = true
end event

