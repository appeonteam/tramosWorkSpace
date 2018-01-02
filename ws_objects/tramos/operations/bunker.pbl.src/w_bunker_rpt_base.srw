$PBExportHeader$w_bunker_rpt_base.srw
$PBExportComments$Window for bunker report. Let the user enter informations, retrieves the report and print it.
forward
global type w_bunker_rpt_base from mt_w_main
end type
type cbx_excludetcout from checkbox within w_bunker_rpt_base
end type
type cbx_exclude from checkbox within w_bunker_rpt_base
end type
type st_status from statictext within w_bunker_rpt_base
end type
type hpb_1 from hprogressbar within w_bunker_rpt_base
end type
type cb_saveas from commandbutton within w_bunker_rpt_base
end type
type st_1 from statictext within w_bunker_rpt_base
end type
type dw_date from mt_u_datawindow within w_bunker_rpt_base
end type
type cb_print from commandbutton within w_bunker_rpt_base
end type
type cb_retrieve from commandbutton within w_bunker_rpt_base
end type
type dw_finresp from mt_u_datawindow within w_bunker_rpt_base
end type
type dw_saveas from u_datagrid within w_bunker_rpt_base
end type
type dw_imolist from u_popupdw within w_bunker_rpt_base
end type
type cbx_selectall_pc from mt_u_checkbox within w_bunker_rpt_base
end type
type gb_profitcenter from mt_u_groupbox within w_bunker_rpt_base
end type
type dw_pc from u_datagrid within w_bunker_rpt_base
end type
type gb_criteria from groupbox within w_bunker_rpt_base
end type
type st_3 from u_topbar_background within w_bunker_rpt_base
end type
type rb_finresp from mt_u_radiobutton within w_bunker_rpt_base
end type
type rb_vessel from mt_u_radiobutton within w_bunker_rpt_base
end type
type sle_vessels from mt_u_singlelineedit within w_bunker_rpt_base
end type
type cb_sel_vessel from mt_u_commandbutton within w_bunker_rpt_base
end type
type dw_info from u_datagrid within w_bunker_rpt_base
end type
type dw_report from mt_u_datawindow within w_bunker_rpt_base
end type
end forward

global type w_bunker_rpt_base from mt_w_main
integer x = 1074
integer y = 484
integer width = 4608
integer height = 2568
string title = "Bunker Report"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
cbx_excludetcout cbx_excludetcout
cbx_exclude cbx_exclude
st_status st_status
hpb_1 hpb_1
cb_saveas cb_saveas
st_1 st_1
dw_date dw_date
cb_print cb_print
cb_retrieve cb_retrieve
dw_finresp dw_finresp
dw_saveas dw_saveas
dw_imolist dw_imolist
cbx_selectall_pc cbx_selectall_pc
gb_profitcenter gb_profitcenter
dw_pc dw_pc
gb_criteria gb_criteria
st_3 st_3
rb_finresp rb_finresp
rb_vessel rb_vessel
sle_vessels sle_vessels
cb_sel_vessel cb_sel_vessel
dw_info dw_info
dw_report dw_report
end type
global w_bunker_rpt_base w_bunker_rpt_base

type variables
string is_vessel_filter
boolean ib_accepttext, ib_dw_has_focus
u_dddw_search inv_dddw_search_user
n_messagebox inv_messagebox
s_demurrage_stat_selection 	istr_parm
end variables

forward prototypes
public subroutine wf_filter ()
public subroutine wf_tcdeliveryports (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, long al_row)
public subroutine documentation ()
public subroutine wf_retrieve (string as_from)
public subroutine wf_show_imotext (integer ai_type, string as_data)
public function integer wf_check_imo (integer ai_type, integer aai_vessel_nr[], string as_fin_resp)
public subroutine wf_open_imolistwin (integer xpos, integer ypos)
public function string wf_getcurrentpc (ref string as_pcname_str)
public subroutine wf_settitle (integer ai_type, string as_text)
end prototypes

public subroutine wf_filter ();string ls_filter=""

if cbx_exclude.checked then
	ls_filter += "(dept_hfo + dept_go + dept_do + dept_lshfo > 0) and "
end if
if cbx_excludetcout.checked then
	ls_filter += "(isnull(comment) or (comment <> 'TC-Out' and comment <> 'TC-Out Delivery' )  ) and "  //TC-Out, TC-Out Delivery
end if

ls_filter = mid(ls_filter, 1, len(ls_filter) - 4)

dw_report.setFilter(ls_filter)
dw_report.filter()
dw_report.groupcalc()

if dw_report.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
else
	cb_saveas.enabled = false
	cb_print.enabled = false
end if
end subroutine

public subroutine wf_tcdeliveryports (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, long al_row);/*	Get the arrival bunker value if the bunker is not sold */
decimal {4} 	ld_USD_value
decimal {4}  ld_arr_hfo, ld_arr_do, ld_arr_go, ld_arr_lshfo
long			ll_counter

n_port_arrival_bunker_value	lnv_bunker
lnv_bunker = create n_port_arrival_bunker_value

SELECT count(*)
	INTO :ll_counter
	FROM BP_DETAILS
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn
	AND BUY_SELL = 1;

/* If the bunker is sold, ignore this portcall */
if ll_counter > 0 then return

SELECT ARR_HFO, ARR_DO, ARR_GO, ARR_LSHFO
	INTO :ld_arr_hfo, :ld_arr_do, :ld_arr_go, :ld_arr_lshfo
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn;


/* HFO */
if ld_arr_hfo <> 0 then
	lnv_bunker.of_calculate( "HFO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_hfo", ld_usd_value)
	dw_report.setItem(al_row, "dept_hfo", ld_arr_hfo)
end if	
/* DO */
if ld_arr_do <> 0 then
	lnv_bunker.of_calculate( "DO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_do", ld_usd_value)
	dw_report.setItem(al_row, "dept_do", ld_arr_do)
end if	
/* GO */
if ld_arr_go <> 0 then
	lnv_bunker.of_calculate( "GO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_go", ld_usd_value)
	dw_report.setItem(al_row, "dept_go", ld_arr_go)
end if	
/* LSHFO */
if ld_arr_lshfo <> 0 then
	lnv_bunker.of_calculate( "LSHFO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_lshfo", ld_usd_value)
	dw_report.setItem(al_row, "dept_lshfo", ld_arr_lshfo)
end if	

destroy lnv_bunker
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_bunker_rpt_base
	
	<OBJECT>
		Ancestor object for report group Bunker Stock.  
	</OBJECT>
  	<DESC>
		Standard report concerned with Bunker Stock
	</DESC>
   	<USAGE>
		Pulled from menu item Reports>Bunker Report>Bunker Report
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		24/05/12 	cr#2777	AGL      		First Version, copy of w_bunker_report 
		20/12/16		CR2879	CCY018		Adjust UI
********************************************************************/
end subroutine

public subroutine wf_retrieve (string as_from);/********************************************************************
   wf_retrieve
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		as_from
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018        Adjust UI
   </HISTORY>
********************************************************************/

long			ll_rows, ll_row
integer		li_vessel, li_calc_vessel, li_calc_pcn, li_check
string		ls_finresp, ls_voyageyear, ls_header, ls_calc_voyage, ls_calc_portcode, ls_purpose, ls_vessel_ref_nr
string ls_vessel_str, ls_retreve_vessel, ls_pc_filter, ls_filter_str, ls_pcname_str
datetime		ldt_date
decimal{4}	ld_USD_value
n_port_departure_bunker_value	lnv_bunker
transaction	mytrans

if dw_date.accepttext() <> 1 then
	dw_date.setfocus()
	return
end if

if rb_vessel.checked then
	li_check = 0
else
	li_check = 1
end if

if li_check = 1 then
	if dw_finresp.event ue_accepttext() <> 1 then
		dw_finresp.setfocus()
		return
	end if
end if

if isnull(dw_date.getitemdate(1, "date_value")) then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Last Departure Date.", this)
	dw_date.setfocus()
	return
end if

ldt_date =  datetime(dw_date.getitemdate(1,"date_value"))
ls_voyageyear = string(dw_date.getitemdate(1, "date_value"), "YY")

ls_pc_filter = wf_getcurrentpc(ls_pcname_str)
ls_retreve_vessel = is_vessel_filter

ls_finresp = dw_finresp.getitemstring(1, "userid")
ls_vessel_str = trim(sle_vessels.text)
if isnull(ls_vessel_str) then ls_vessel_str = ""

if li_check = 0 then
	setnull(ls_finresp)
else
	if isnull(ls_finresp) or len(ls_finresp) = 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Finance Responsible.", this)
		dw_finresp.setfocus()
		dw_finresp.setcolumn("userid")
		return
	end if

	 ls_retreve_vessel = ""
end if

if as_from = "w_bunker_rpt_base" or as_from = "w_bunker_rpt_sm" then
	ls_header = "Bunker Stock at departure, Finished voyages until "
else
	ls_header = "Bunker Stock (PoC), voyages until "
end if

ls_header += string(ldt_date, "dd/mm-yy hh:mm") 

dw_report.Object.t_header.Text = ls_header
if as_from = "w_bunker_rpt_sm" or as_from = "w_bunker_rpt_sm_poc" then
	wf_settitle(1, "Sharemembers " +ls_header)
end if

hpb_1.position = 0
st_status.text = "Retrieving data, please be patient..."

/* workaround PB bugfix when retrieving from temp table via stored procedure*/
mytrans = create transaction
mytrans.DBMS 		= SQLCA.DBMS
mytrans.Database 	= SQLCA.Database
mytrans.LogPAss 	= SQLCA.LogPass
mytrans.ServerName= SQLCA.ServerName
mytrans.LogId		= SQLCA.LogId
mytrans.AutoCommit= true
mytrans.DBParm		= SQLCA.DBParm
connect using mytrans;
dw_report.setTransObject(mytrans)
ll_rows = dw_report.retrieve(ls_pc_filter, ls_retreve_vessel, ls_finresp, ldt_date, ls_voyageyear )
disconnect using mytrans;
destroy mytrans;
ll_rows = dw_report.rowCount() 
st_status.text = string(ll_rows) + " rows retrieved..."

if ll_rows < 1 then 
	return 
end if

/* Calculate */
lnv_bunker = create n_port_departure_bunker_value
if as_from = "w_bunker_rpt_poc" or as_from = "w_bunker_rpt_sm_poc" then
	lnv_bunker.of_setreporttype(2)
end if

if as_from = "w_bunker_rpt_base" or as_from = "w_bunker_rpt_poc" then
	hpb_1.maxposition = ll_rows
else
	hpb_1.maxposition = ll_rows * 2
end if

for ll_row = 1 to ll_rows
	hpb_1.position = ll_row
	li_calc_vessel = dw_report.getItemNumber(ll_row, "vessel")
	ls_calc_voyage = dw_report.getItemString(ll_row, "voyage")
	ls_calc_portcode = dw_report.getItemString(ll_row, "portcode")
	li_calc_pcn = dw_report.getItemNumber(ll_row, "pcn")
	setNull(ls_purpose)
	
	if dw_report.getItemNumber(ll_row, "voyage_type") = 2 then
		dw_report.setItem(ll_row, "comment", "TC-Out")

		SELECT PURPOSE_CODE
		INTO :ls_purpose
		FROM POC
		WHERE VESSEL_NR = :li_calc_vessel
		AND VOYAGE_NR = :ls_calc_voyage
		AND PORT_CODE = :ls_calc_portcode
		AND PCN = :li_calc_pcn;
	end if

	if  dw_report.getItemNumber(ll_row, "voyage_type") = 2 and ls_purpose = "DEL" then
		/* TC Out Delivery */
		dw_report.setItem(ll_row, "comment", "TC-Out Delivery")
		wf_TCdeliveryPorts( li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ll_row )
	else
		/* Single voyages and
			TC Out Redelivery */
		if  dw_report.getItemNumber(ll_row, "voyage_type") = 2 and ls_purpose = "RED" then
			dw_report.setItem(ll_row, "comment", "TC-Out Redelivery")
		end if

		/* HFO */
		if dw_report.getItemNumber(ll_row, "dept_hfo") <> 0 then
			lnv_bunker.of_calculate( "HFO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_hfo", ld_usd_value)
		end if	
		/* DO */
		if dw_report.getItemNumber(ll_row, "dept_do") <> 0 then
			lnv_bunker.of_calculate( "DO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_do", ld_usd_value)
		end if	
		/* GO */
		if dw_report.getItemNumber(ll_row, "dept_go") <> 0 then
			lnv_bunker.of_calculate( "GO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_go", ld_usd_value)
		end if	
		/* LSHFO */
		if dw_report.getItemNumber(ll_row, "dept_lshfo") <> 0 then
			lnv_bunker.of_calculate( "LSHFO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_lshfo", ld_usd_value)
		end if	
	end if
next
destroy lnv_bunker

end subroutine

public subroutine wf_show_imotext (integer ai_type, string as_data);/********************************************************************
   wf_show_imotext
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_type
		as_data
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_vessel_arr[]
string ls_finresp
mt_n_stringfunctions ln_strfun

if ai_type = 0 then
	ln_strfun.of_parsetoarray(as_data, ",", li_vessel_arr)
else
	ls_finresp = as_data
	li_vessel_arr[1] = -1
end if

if wf_check_imo(ai_type, li_vessel_arr, ls_finresp) > 0 then
	dw_info.visible = true
else
	dw_info.visible = false
end if

dw_imolist.visible = false
end subroutine

public function integer wf_check_imo (integer ai_type, integer aai_vessel_nr[], string as_fin_resp);/********************************************************************
   wf_check_imo
   <DESC></DESC>
   <RETURN>	integer</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_type
		aai_vessel_nr[]
		as_fin_resp
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_count, li_have_vessel, li_have_pc, li_pc_arr[]
string ls_fin_resp, ls_pcname_str
mt_n_datastore lds_imo

wf_getcurrentpc(ls_pcname_str)
li_pc_arr = istr_parm.profitcenter

if ai_type = 0 and upperbound(li_pc_arr)=0 and upperbound(aai_vessel_nr) = 0 then return 0
if ai_type = 1 and (isnull(as_fin_resp) or as_fin_resp = "") then return 0

if upperbound(aai_vessel_nr) = 0 then 
	li_have_vessel = 0
	aai_vessel_nr[1] = -1
else
	li_have_vessel = 1
end if

if upperbound(li_pc_arr)=0 then 
	li_have_pc = 0
	li_pc_arr[1] = -1
else
	li_have_pc = 1
end if

lds_imo = create mt_n_datastore
lds_imo.dataobject = "d_sq_gr_bunker_rpt_imolist"
lds_imo.settransobject(sqlca)

li_count = lds_imo.retrieve(ai_type, aai_vessel_nr, as_fin_resp, li_pc_arr, li_have_vessel, li_have_pc)

destroy lds_imo
return li_count
end function

public subroutine wf_open_imolistwin (integer xpos, integer ypos);/********************************************************************
   wf_open_imolistwin
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		xpos
		ypos
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_type, li_have_vessel, li_have_pc, li_vessel_nr_arr[], li_pcnr_arr[]
long ll_height, ll_count
string ls_fin_resp, ls_pcname_str
mt_n_stringfunctions ln_strfun

dw_imolist.visible = false

if dw_finresp.event ue_accepttext() <> 1 then
	dw_finresp.setfocus()
	return
end if

if rb_vessel.checked then
	li_type = 0
else
	li_type = 1
end if

wf_getcurrentpc(ls_pcname_str)
li_pcnr_arr = istr_parm.profitcenter

ls_fin_resp = dw_finresp.getitemstring(1, "userid")

if li_type = 0 then
	if len(is_vessel_filter) = 0 and upperbound(li_pcnr_arr) = 0 then return
	ln_strfun.of_parsetoarray(is_vessel_filter, ",", li_vessel_nr_arr)
	if upperbound(li_vessel_nr_arr) = 0 then 
		li_have_vessel = 0
		li_vessel_nr_arr[1] = -1
	else
		li_have_vessel = 1
	end if
else
	if isnull(ls_fin_resp) or ls_fin_resp = "" then return
	li_vessel_nr_arr[1] = -1
end if

if upperbound(li_pcnr_arr) = 0 then 
	li_have_pc = 0
	li_pcnr_arr[1] = -1
else
	li_have_pc = 1
end if

ll_count = dw_imolist.retrieve(li_type, li_vessel_nr_arr, ls_fin_resp, li_pcnr_arr, li_have_vessel, li_have_pc)
if ll_count > 0 then 
	if ll_count > 10 then ll_count = 10
	ll_height = long(dw_imolist.object.datawindow.detail.height) * ll_count 
	ll_height +=long(dw_imolist.object.datawindow.header.height)
	dw_imolist.height = ll_height + 16
	dw_imolist.x = xpos
	dw_imolist.y = dw_info.y - dw_imolist.height
	dw_imolist.visible = true
end if

end subroutine

public function string wf_getcurrentpc (ref string as_pcname_str);/********************************************************************
   wf_getcurrentpc
   <DESC></DESC>
   <RETURN>	string</RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		as_pcname_str
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_x, ll_empty[]
integer li_pc
string ls_pc_filter, ls_pc_name

istr_parm.profitcenter = ll_empty
ls_pc_filter = ""
as_pcname_str = ""

for ll_x = 1 to dw_pc.rowCount()
	if dw_pc.isselected(ll_x) then
		li_pc = dw_pc.getitemnumber(ll_x, "pc_nr")
		ls_pc_name = dw_pc.getitemstring(ll_x, "pc_name")
		istr_parm.profitcenter[upperbound(istr_parm.profitcenter) + 1] = li_pc
		if ls_pc_filter = "" then
			ls_pc_filter = string(li_pc)
			as_pcname_str = ls_pc_name
		else
			ls_pc_filter += ", " + string(li_pc)
			as_pcname_str += ", " + ls_pc_name
		end if
	end if
next

return ls_pc_filter
end function

public subroutine wf_settitle (integer ai_type, string as_text);
end subroutine

on w_bunker_rpt_base.create
int iCurrent
call super::create
this.cbx_excludetcout=create cbx_excludetcout
this.cbx_exclude=create cbx_exclude
this.st_status=create st_status
this.hpb_1=create hpb_1
this.cb_saveas=create cb_saveas
this.st_1=create st_1
this.dw_date=create dw_date
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_finresp=create dw_finresp
this.dw_saveas=create dw_saveas
this.dw_imolist=create dw_imolist
this.cbx_selectall_pc=create cbx_selectall_pc
this.gb_profitcenter=create gb_profitcenter
this.dw_pc=create dw_pc
this.gb_criteria=create gb_criteria
this.st_3=create st_3
this.rb_finresp=create rb_finresp
this.rb_vessel=create rb_vessel
this.sle_vessels=create sle_vessels
this.cb_sel_vessel=create cb_sel_vessel
this.dw_info=create dw_info
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_excludetcout
this.Control[iCurrent+2]=this.cbx_exclude
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.cb_saveas
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_date
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.cb_retrieve
this.Control[iCurrent+10]=this.dw_finresp
this.Control[iCurrent+11]=this.dw_saveas
this.Control[iCurrent+12]=this.dw_imolist
this.Control[iCurrent+13]=this.cbx_selectall_pc
this.Control[iCurrent+14]=this.gb_profitcenter
this.Control[iCurrent+15]=this.dw_pc
this.Control[iCurrent+16]=this.gb_criteria
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.rb_finresp
this.Control[iCurrent+19]=this.rb_vessel
this.Control[iCurrent+20]=this.sle_vessels
this.Control[iCurrent+21]=this.cb_sel_vessel
this.Control[iCurrent+22]=this.dw_info
this.Control[iCurrent+23]=this.dw_report
end on

on w_bunker_rpt_base.destroy
call super::destroy
destroy(this.cbx_excludetcout)
destroy(this.cbx_exclude)
destroy(this.st_status)
destroy(this.hpb_1)
destroy(this.cb_saveas)
destroy(this.st_1)
destroy(this.dw_date)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_finresp)
destroy(this.dw_saveas)
destroy(this.dw_imolist)
destroy(this.cbx_selectall_pc)
destroy(this.gb_profitcenter)
destroy(this.dw_pc)
destroy(this.gb_criteria)
destroy(this.st_3)
destroy(this.rb_finresp)
destroy(this.rb_vessel)
destroy(this.sle_vessels)
destroy(this.cb_sel_vessel)
destroy(this.dw_info)
destroy(this.dw_report)
end on

event open;datawindowchild	ldwc_vessel, ldwc_finresp
n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

this.move(0, 0)

dw_date.insertrow(0)
dw_finresp.insertRow(0)

dw_finresp.getchild( "userid", ldwc_finresp)
ldwc_finresp.settransobject(sqlca)
ldwc_finresp.retrieve()

dw_report.settransobject(sqlca)
dw_imolist.settransobject(sqlca)
dw_pc.settransobject(sqlca)

dw_pc.retrieve(uo_global.is_userid)
dw_info.insertrow(0)

inv_dddw_search_user = CREATE u_dddw_search
inv_dddw_search_user.of_register(dw_finresp, "userid", "username", true, true)
lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_autoadjustdddwwidth(dw_finresp)

dw_pc.setrowfocusindicator(FocusRect!)





end event

event close;call super::close;destroy inv_dddw_search_user
end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredobject(cbx_selectall_pc)
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_bunker_rpt_base
integer x = 0
integer y = 520
end type

type cbx_excludetcout from checkbox within w_bunker_rpt_base
integer x = 1856
integer y = 384
integer width = 997
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Exclude TC-Out and TC-Out Delivery"
end type

event clicked;post wf_filter()
end event

type cbx_exclude from checkbox within w_bunker_rpt_base
integer x = 1856
integer y = 304
integer width = 640
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Exclude stock = 0 (zero)"
end type

event clicked;post wf_filter()
end event

type st_status from statictext within w_bunker_rpt_base
integer x = 37
integer y = 2376
integer width = 919
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_bunker_rpt_base
integer x = 2299
integer y = 2376
integer width = 1189
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_saveas from commandbutton within w_bunker_rpt_base
integer x = 3872
integer y = 2356
integer width = 343
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;n_dataexport lnv_exp
	
if dw_report.rowcount() > 0 then
	dw_saveas.object.data.primary = dw_report.object.data.primary
	lnv_exp.of_export(dw_saveas)
	dw_saveas.reset()
end if
end event

type st_1 from statictext within w_bunker_rpt_base
integer x = 41
integer y = 32
integer width = 466
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
boolean enabled = false
string text = "Last Departure Date"
boolean focusrectangle = false
end type

type dw_date from mt_u_datawindow within w_bunker_rpt_base
integer x = 512
integer y = 32
integer width = 343
integer height = 64
integer taborder = 10
string dataobject = "d_ex_tb_bunker_rpt_date"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;call super::itemerror;this.selecttext(1, 10)
end event

type cb_print from commandbutton within w_bunker_rpt_base
integer x = 4219
integer y = 2356
integer width = 343
integer height = 100
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;dw_report.print(true)
end event

type cb_retrieve from commandbutton within w_bunker_rpt_base
integer x = 3525
integer y = 2356
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;dw_imolist.visible = false
setpointer(HourGlass!)
dw_report.reset()
wf_retrieve(parent.classname())

if dw_report.rowcount() > 0 then
	wf_filter()
	st_status.text = "Report generated..."
else
	cb_saveas.enabled = false
	cb_print.enabled = false
end if

setpointer(Arrow!)




end event

type dw_finresp from mt_u_datawindow within w_bunker_rpt_base
event type integer ue_accepttext ( )
event ue_setcolumn ( )
integer x = 2272
integer y = 176
integer width = 887
integer height = 84
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_ex_tb_bunker_rpt_criteria"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event type integer ue_accepttext();integer li_rtn

ib_accepttext = true
li_rtn = this.accepttext()
ib_accepttext = false

return li_rtn
end event

event ue_setcolumn();if not ib_dw_has_focus then
	this.setcolumn(this.getcolumn())
end if

end event

event editchanged;call super::editchanged;choose case dwo.name
	case "userid"
		inv_dddw_search_user.uf_editchanged()
end choose
end event

event itemfocuschanged;call super::itemfocuschanged;this.selecttext(1, 50)
end event

event itemerror;call super::itemerror;string ls_message

this.selecttext(1, 50)

//if ib_accepttext then
//	ls_message = "You cannot enter " + data + " because it does not exist in the list."
//	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, ls_message, parent)
//end if

return 1
end event

event itemchanged;call super::itemchanged;integer li_type, li_vessel_nr
string ls_fin_resp, ls_data

if isnull(row) or row < 1 then return

choose case dwo.name
	case "userid"
		if inv_dddw_search_user.uf_itemchanged() = 1 then return 2
		
		wf_show_imotext(1, data)
end choose
end event

event getfocus;call super::getfocus;this.selecttext(1, 50)
ib_dw_has_focus = true

end event

event losefocus;call super::losefocus;ib_dw_has_focus = false
this.event post ue_setcolumn()

end event

type dw_saveas from u_datagrid within w_bunker_rpt_base
boolean visible = false
integer x = 3483
integer y = 596
boolean bringtotop = true
string dataobject = "d_sp_tb_bunker_stock_report_saveas"
end type

type dw_imolist from u_popupdw within w_bunker_rpt_base
integer x = 1755
integer y = 1588
integer width = 1353
integer height = 708
boolean bringtotop = true
string dataobject = "d_sq_gr_bunker_rpt_imolist"
boolean resizable = false
borderstyle borderstyle = stylebox!
boolean ib_autoclose = false
end type

event clicked;this.visible = false	
return 1
end event

type cbx_selectall_pc from mt_u_checkbox within w_bunker_rpt_base
integer x = 1454
integer y = 16
integer width = 329
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;string ls_fin_resp

if this.checked then
	dw_pc.selectrow(0, true)
	this.text = "Deselect all"
	this.textcolor = c#color.WHITE
else
	dw_pc.selectrow(0, false)
	this.text = "Select all"
	this.textcolor = c#color.WHITE
end if

if rb_vessel.checked then
	wf_show_imotext(0, is_vessel_filter)
else
	ls_fin_resp = dw_finresp.getitemstring(1, "userid")
	wf_show_imotext(1, ls_fin_resp)
end if

end event

type gb_profitcenter from mt_u_groupbox within w_bunker_rpt_base
integer x = 887
integer y = 16
integer width = 933
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type dw_pc from u_datagrid within w_bunker_rpt_base
integer x = 923
integer y = 80
integer width = 859
integer height = 448
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_multiselect = true
end type

event ue_lbuttonup;call super::ue_lbuttonup;
string ls_fin_resp

if rb_vessel.checked then
	wf_show_imotext(0, is_vessel_filter)
else
	ls_fin_resp = dw_finresp.getitemstring(1, "userid")
	wf_show_imotext(1, ls_fin_resp)
end if


end event

type gb_criteria from groupbox within w_bunker_rpt_base
integer x = 1856
integer y = 16
integer width = 2706
integer height = 256
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Criteria"
end type

type st_3 from u_topbar_background within w_bunker_rpt_base
integer height = 592
end type

type rb_finresp from mt_u_radiobutton within w_bunker_rpt_base
integer x = 1893
integer y = 176
integer width = 379
integer height = 64
integer taborder = 60
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 22628899
string text = "Finance Resp"
end type

event clicked;call super::clicked;if this.checked then
	cb_sel_vessel.enabled = false
	sle_vessels.enabled = false
	
	dw_finresp.setitem(1, "select_flag", 1)
	dw_finresp.modify("userid.protect='0'")
	
	wf_show_imotext(1, dw_finresp.getitemstring(1, "userid"))
end if
end event

type rb_vessel from mt_u_radiobutton within w_bunker_rpt_base
integer x = 1893
integer y = 80
integer height = 64
integer taborder = 40
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessels"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	cb_sel_vessel.enabled = true
	sle_vessels.enabled = true
	
	dw_finresp.setitem(1, "select_flag", 0)
	dw_finresp.modify("userid.protect='1'")
	
	wf_show_imotext(0, is_vessel_filter)
end if
end event

type sle_vessels from mt_u_singlelineedit within w_bunker_rpt_base
integer x = 2281
integer y = 80
integer width = 2153
integer height = 56
boolean bringtotop = true
long backcolor = 16777215
string text = ""
boolean border = false
boolean displayonly = true
end type

type cb_sel_vessel from mt_u_commandbutton within w_bunker_rpt_base
integer x = 4453
integer y = 76
integer width = 73
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;call super::clicked;long ll_upperbound
long ll_x
string ls_pcname_str
s_demurrage_stat_selection 	lstr_parm

dw_imolist.visible = false
if not isvalid(istr_parm) then istr_parm = lstr_parm

wf_getcurrentpc(ls_pcname_str)

if upperbound(istr_parm.profitcenter)=0 then return 

openwithparm(w_vessel_select_for_rpt, istr_parm)
istr_parm = message.PowerObjectParm
if not isvalid(istr_parm) then return

ll_upperbound = UpperBound(istr_parm.vessel_nr)
sle_vessels.text = ""
is_vessel_filter = ""
for ll_x = 1 to ll_upperbound
	if ll_x = 1 then
		sle_vessels.text = istr_parm.vessel_ref_nr[ll_x]
		is_vessel_filter = string(istr_parm.vessel_nr[ll_x])
	else
		sle_vessels.text += ", " + istr_parm.vessel_ref_nr[ll_x]
		is_vessel_filter += "," + string(istr_parm.vessel_nr[ll_x])
	end if
next

wf_show_imotext(0, is_vessel_filter)
end event

type dw_info from u_datagrid within w_bunker_rpt_base
boolean visible = false
integer x = 974
integer y = 2364
integer width = 1312
integer height = 108
string dataobject = "d_tb_ex_bunker_rpt_info"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;wf_open_imolistwin(parent.pointerx(), parent.pointery())


end event

type dw_report from mt_u_datawindow within w_bunker_rpt_base
integer x = 37
integer y = 636
integer width = 4526
integer height = 1704
integer taborder = 100
string dataobject = "d_sp_tb_bunker_stock_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

