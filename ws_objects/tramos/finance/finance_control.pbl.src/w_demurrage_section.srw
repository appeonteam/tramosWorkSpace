$PBExportHeader$w_demurrage_section.srw
$PBExportComments$This window is used demurrage section in Product
forward
global type w_demurrage_section from mt_w_sheet
end type
type st_forwarding_date from mt_u_statictext within w_demurrage_section
end type
type st_voyageyear from mt_u_statictext within w_demurrage_section
end type
type st_demurrage_analyst from mt_u_statictext within w_demurrage_section
end type
type em_days from mt_u_editmask within w_demurrage_section
end type
type st_days from mt_u_statictext within w_demurrage_section
end type
type em_year from mt_u_editmask within w_demurrage_section
end type
type st_year from mt_u_statictext within w_demurrage_section
end type
type rb_equal from mt_u_radiobutton within w_demurrage_section
end type
type rb_greater from mt_u_radiobutton within w_demurrage_section
end type
type rb_days_greater from mt_u_radiobutton within w_demurrage_section
end type
type rb_days_less from mt_u_radiobutton within w_demurrage_section
end type
type cbx_sepline from mt_u_checkbox within w_demurrage_section
end type
type em_lines from mt_u_editmask within w_demurrage_section
end type
type st_printlines from mt_u_statictext within w_demurrage_section
end type
type cb_sel_office from mt_u_commandbutton within w_demurrage_section
end type
type sle_offices from mt_u_singlelineedit within w_demurrage_section
end type
type cbx_include_office from mt_u_checkbox within w_demurrage_section
end type
type st_offices from mt_u_statictext within w_demurrage_section
end type
type cb_sel_broker from mt_u_commandbutton within w_demurrage_section
end type
type sle_brokers from mt_u_singlelineedit within w_demurrage_section
end type
type cbx_include_broker from mt_u_checkbox within w_demurrage_section
end type
type st_brokers from mt_u_statictext within w_demurrage_section
end type
type cb_sel_chart from mt_u_commandbutton within w_demurrage_section
end type
type cbx_include_chart from mt_u_checkbox within w_demurrage_section
end type
type st_charterers from mt_u_statictext within w_demurrage_section
end type
type cb_sel_vessel from mt_u_commandbutton within w_demurrage_section
end type
type cbx_include_vessel from mt_u_checkbox within w_demurrage_section
end type
type cb_saveas from mt_u_commandbutton within w_demurrage_section
end type
type sle_vessels from mt_u_singlelineedit within w_demurrage_section
end type
type st_vessels from mt_u_statictext within w_demurrage_section
end type
type cb_retrieve from mt_u_commandbutton within w_demurrage_section
end type
type cb_print from mt_u_commandbutton within w_demurrage_section
end type
type cb_print_totals from mt_u_commandbutton within w_demurrage_section
end type
type rb_all from mt_u_radiobutton within w_demurrage_section
end type
type rb_swnf from mt_u_radiobutton within w_demurrage_section
end type
type rb_sm from mt_u_radiobutton within w_demurrage_section
end type
type rb_em from mt_u_radiobutton within w_demurrage_section
end type
type dw_outst_detail from u_datagrid within w_demurrage_section
end type
type dw_profit_center from u_datagrid within w_demurrage_section
end type
type dw_stat_totals from mt_u_datawindow within w_demurrage_section
end type
type gb_mismatch from mt_u_groupbox within w_demurrage_section
end type
type dw_stat_detail from u_datagrid within w_demurrage_section
end type
type gb_pc from mt_u_groupbox within w_demurrage_section
end type
type uo_demurrage_analyst from u_demurrage_analyst within w_demurrage_section
end type
type gb_filter from mt_u_groupbox within w_demurrage_section
end type
type gb_summary from mt_u_groupbox within w_demurrage_section
end type
type gb_forwardingdate from mt_u_groupbox within w_demurrage_section
end type
type dw_save from mt_u_datawindow within w_demurrage_section
end type
type cbx_select from mt_u_checkbox within w_demurrage_section
end type
type rb_less from mt_u_radiobutton within w_demurrage_section
end type
type gb_voyage_year from mt_u_groupbox within w_demurrage_section
end type
type st_topbar from u_topbar_background within w_demurrage_section
end type
type sle_charterers from multilineedit within w_demurrage_section
end type
end forward

global type w_demurrage_section from mt_w_sheet
integer width = 4608
integer height = 2584
string title = "Demurrage"
boolean maxbox = false
boolean resizable = false
boolean center = false
event ue_userrespitemchanged ( string as_userid )
st_forwarding_date st_forwarding_date
st_voyageyear st_voyageyear
st_demurrage_analyst st_demurrage_analyst
em_days em_days
st_days st_days
em_year em_year
st_year st_year
rb_equal rb_equal
rb_greater rb_greater
rb_days_greater rb_days_greater
rb_days_less rb_days_less
cbx_sepline cbx_sepline
em_lines em_lines
st_printlines st_printlines
cb_sel_office cb_sel_office
sle_offices sle_offices
cbx_include_office cbx_include_office
st_offices st_offices
cb_sel_broker cb_sel_broker
sle_brokers sle_brokers
cbx_include_broker cbx_include_broker
st_brokers st_brokers
cb_sel_chart cb_sel_chart
cbx_include_chart cbx_include_chart
st_charterers st_charterers
cb_sel_vessel cb_sel_vessel
cbx_include_vessel cbx_include_vessel
cb_saveas cb_saveas
sle_vessels sle_vessels
st_vessels st_vessels
cb_retrieve cb_retrieve
cb_print cb_print
cb_print_totals cb_print_totals
rb_all rb_all
rb_swnf rb_swnf
rb_sm rb_sm
rb_em rb_em
dw_outst_detail dw_outst_detail
dw_profit_center dw_profit_center
dw_stat_totals dw_stat_totals
gb_mismatch gb_mismatch
dw_stat_detail dw_stat_detail
gb_pc gb_pc
uo_demurrage_analyst uo_demurrage_analyst
gb_filter gb_filter
gb_summary gb_summary
gb_forwardingdate gb_forwardingdate
dw_save dw_save
cbx_select cbx_select
rb_less rb_less
gb_voyage_year gb_voyage_year
st_topbar st_topbar
sle_charterers sle_charterers
end type
global w_demurrage_section w_demurrage_section

type variables
s_demurrage_stat_selection 	istr_parm
string is_filter, is_vessel_filter, is_chart_filter, is_broker_filter, is_office_filter

end variables

forward prototypes
public subroutine of_open_actions_trans (u_datagrid dwo)
public subroutine documentation ()
public subroutine wf_get_pcnr (boolean ab_analysechanged)
public subroutine wf_cbxselect_setcheck ()
public subroutine wf_retrieve ()
public subroutine wf_setbuttonstatus ()
public subroutine wf_setdatawindowredraw (boolean ab_setredraw)
public subroutine wf_filter ()
public subroutine wf_cbxselect_setcheck (boolean ab_checked)
public subroutine wf_cbxselect_setcheck (boolean ab_checked, boolean ab_click)
end prototypes

event ue_userrespitemchanged(string as_userid);/********************************************************************
   ue_userrespitemchanged( /*string as_userid */)
   <DESC>     This function is to call the of_itemchanged function in u_demurrage_analyst
				  in order to set values for filter.						
   </DESC>
   <RETURN> None																				</RETURN>
   <ACCESS> Public																				</ACCESS>
   <ARGS>    as_userid: selected demurrage analyst.										</ARGS>
   <USAGE>  Called from itemchanged event of u_demurrage_analyst.				</USAGE>
********************************************************************/


if cbx_select.checked then wf_cbxselect_setcheck(false,true)

is_vessel_filter = uo_demurrage_analyst.of_itemchanged( dw_profit_center, sle_vessels, sle_charterers, istr_parm, true )
if is_vessel_filter <> "-1" then
	wf_get_pcnr(false)
	setfocus(em_year)
end if


 
end event

public subroutine of_open_actions_trans (u_datagrid dwo);u_jump_actions_trans luo_jump_actions_trans
string ls_voyage_nr, ls_claim_type
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr

luo_jump_actions_trans = create u_jump_actions_trans

li_vessel_nr 	= dwo.getitemnumber(dwo.getrow(), "claims_vessel_nr")
ls_voyage_nr 	= dwo.getitemstring(dwo.getrow(), "claims_voyage_nr")
ll_chart_nr	 	= dwo.getitemnumber(dwo.getrow(), "claims_chart_nr")
ll_claim_nr	 	= dwo.getitemnumber(dwo.getrow(), "claims_claim_nr")

luo_jump_actions_trans.of_open_actions_trans(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)


DESTROY luo_jump_actions_trans
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author         Comments
   	29/08/14   CR3781       CCY018         The window title match with the text of a menu item
   	10/12/14   CR3796       LHG008         1.Add Claim Comment from Actions/Transactions to reports.
   	                                       2.Use the latest exchange rate for Amount calculation.
	28/11/17   CR4651       EPE080         Add Profit Center Select all check box,remove refresh seach.
													
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_get_pcnr (boolean ab_analysechanged);/********************************************************************
   wf_get_pcnr
   <DESC></DESC>
   <RETURN> string </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		ab_analysechanged
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		20/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

int li_findrow, li_selectrow, li_rowcount, li_index, li_empty[]

li_index    = 1
li_rowcount = dw_profit_center.rowcount()

istr_parm.profitcenter = li_empty

li_selectrow = dw_profit_center.getselectedrow(0)

if li_selectrow < 1 then
	if ab_analysechanged then
		wf_cbxselect_setcheck(true,true)
	end if
end if

li_findrow = dw_profit_center.find("isSelected()", 1, li_rowcount)

do while li_findrow > 0
	istr_parm.profitcenter[li_index] = dw_profit_center.getitemnumber(li_findrow, "pc_nr")
	li_index ++
	li_findrow = dw_profit_center.find("isSelected()", li_findrow + 1, li_rowcount + 1)
loop

if upperbound(istr_parm.profitcenter) > 0 then
	cb_retrieve.enabled = true
else
	cb_retrieve.enabled = false
end if
end subroutine

public subroutine wf_cbxselect_setcheck ();
end subroutine

public subroutine wf_retrieve ();/********************************************************************
   wf_retrieve
   <DESC>retrieve data</DESC>
   <RETURN> none </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

long ll_row, ll_rows, i, ll_pc[], ll_year, ll_days
string	ls_operator, ls_mismatch, ls_yearop, ls_daysop, ls_pcnrstr
string ls_vessel, ls_vesselinclude, ls_chart, ls_chartinclude, ls_broker, ls_brokerinclude, ls_office, ls_officeinclude

wf_setdatawindowredraw(false)	
setPointer(hourglass!)

if upperbound(istr_parm.profitcenter) = 0 then 
	dw_stat_detail.reset()
	wf_setbuttonstatus()
	wf_setdatawindowredraw(true)
	setPointer(arrow!)
	return
end if
/* Profit Center */
ls_pcnrstr = ''
FOR ll_row=1 TO upperbound(istr_parm.profitcenter)
	if len(ls_pcnrstr)  > 0 then ls_pcnrstr = ls_pcnrstr + ', '
	ls_pcnrstr = ls_pcnrstr + string(istr_parm.profitcenter[ll_row])
NEXT

if (rb_em.checked) then
	ls_mismatch = 'em'
elseif (rb_sm.checked) then
	ls_mismatch = 'sm'	
elseif (rb_swnf.checked) then
	ls_mismatch = 'swnf'
elseif (rb_all.checked) then
	ls_mismatch = 'all'
end if

if (len(em_year.text) > 0) then
	ll_year = long(em_year.text)
else
	ll_year = 0
end if
if rb_less.checked = true then
	ls_yearop = 'less'
elseif rb_equal.checked = true then
	ls_yearop = 'equal'
else
	ls_yearop = "greater"
end if
	
if (len(em_days.text) > 0) then
	ll_days = long(em_days.text)
else
	ll_days = 0
end if
if rb_days_greater.checked = true then
	ls_daysop = 'greater'
else
	ls_daysop = 'less'
end if

dw_stat_detail.retrieve(istr_parm.profitcenter,ls_mismatch,ll_year, ls_yearop, ll_days, ls_daysop)
dw_stat_detail.ShareData(dw_stat_totals)
dw_stat_detail.ShareData(dw_outst_detail)	

wf_filter()

wf_setbuttonstatus()
wf_setdatawindowredraw(true)
setPointer(arrow!)



end subroutine

public subroutine wf_setbuttonstatus ();/********************************************************************
   wf_setbuttonstatus
   <DESC>set enabled status of buttons</DESC>
   <RETURN> none </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/


if dw_stat_detail.rowcount() > 0 then
	dw_stat_detail.selectrow(0, false)
	dw_stat_detail.selectrow(1, true)
	
	cb_print_totals.enabled = true
	cb_print.enabled  = true
	cb_saveas.enabled = true
else
	cb_print_totals.enabled = false
	cb_print.enabled  = false
	cb_saveas.enabled = false
end if
end subroutine

public subroutine wf_setdatawindowredraw (boolean ab_setredraw);
dw_stat_detail.setredraw(ab_setredraw)
dw_stat_totals.setredraw(ab_setredraw)
dw_outst_detail.setredraw(ab_setredraw)

end subroutine

public subroutine wf_filter ();/********************************************************************
   wf_filter
   <DESC>builde filter string and filter data</DESC>
   <RETURN> none </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		6/12/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

string ls_operator, ls_filter

ls_filter = ''

/* Vessel Number */
if (len(is_vessel_filter) > 0) then
	if cbx_include_vessel.checked then
		ls_operator = 'in'
	else
		ls_operator = 'not in'
	end if
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += " claims_vessel_nr " +ls_operator+ " ( " + string(is_vessel_filter) + " )"
end if		

/* Charterer Number */
if (len(is_chart_filter) > 0) then
	if cbx_include_chart.checked then
		ls_operator = 'in'
	else
		ls_operator = 'not in'
	end if
	
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += " claims_chart_nr " +ls_operator+ " ( " + string(is_chart_filter) + " )"		
end if

/* Broker Number */
if (len(is_broker_filter) > 0) then
	if cbx_include_broker.checked then
		ls_operator = 'in'
	else
		ls_operator = 'not in'
	end if
	
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += " broker_nr " +ls_operator+ " ( " + string(is_broker_filter) + " )"
end if

/* Office Number */
if (len(is_office_filter) > 0) then
	if cbx_include_office.checked then
		ls_operator = 'in'
	else
		ls_operator = 'not in'
	end if
	
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += " office_nr " +ls_filter+ " ( " + string(is_office_filter) + " )"
end if

if ls_filter <> is_filter then
	dw_stat_detail.setfilter(is_filter)
	dw_stat_detail.filter()
	is_filter = ls_filter
end if
end subroutine

public subroutine wf_cbxselect_setcheck (boolean ab_checked);/********************************************************************
   wf_cbxselect_setcheck
   <DESC>check/uncheck 'Select all/Deselect all' check box</DESC>
   <RETURN> none </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		ab_checked
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

if ab_checked then
	cbx_select.checked = true
	cbx_select.text = "Deselect all"
	cbx_select.width = 320
else
	cbx_select.checked = false
	cbx_select.text = "Select all"
	cbx_select.width = 265
end if

cbx_select.textcolor = c#color.White
end subroutine

public subroutine wf_cbxselect_setcheck (boolean ab_checked, boolean ab_click);/********************************************************************
   wf_cbxselect_setcheck
   <DESC>check/uncheck 'Select all/Deselect all' check box</DESC>
   <RETURN> none </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		ab_checked
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

if ab_click then
	if ab_checked then
		dw_profit_center.selectrow(0, true)
	else
		dw_profit_center.selectrow(0, false)
	end if
end if

wf_cbxselect_setcheck(ab_checked)

end subroutine

on w_demurrage_section.create
int iCurrent
call super::create
this.st_forwarding_date=create st_forwarding_date
this.st_voyageyear=create st_voyageyear
this.st_demurrage_analyst=create st_demurrage_analyst
this.em_days=create em_days
this.st_days=create st_days
this.em_year=create em_year
this.st_year=create st_year
this.rb_equal=create rb_equal
this.rb_greater=create rb_greater
this.rb_days_greater=create rb_days_greater
this.rb_days_less=create rb_days_less
this.cbx_sepline=create cbx_sepline
this.em_lines=create em_lines
this.st_printlines=create st_printlines
this.cb_sel_office=create cb_sel_office
this.sle_offices=create sle_offices
this.cbx_include_office=create cbx_include_office
this.st_offices=create st_offices
this.cb_sel_broker=create cb_sel_broker
this.sle_brokers=create sle_brokers
this.cbx_include_broker=create cbx_include_broker
this.st_brokers=create st_brokers
this.cb_sel_chart=create cb_sel_chart
this.cbx_include_chart=create cbx_include_chart
this.st_charterers=create st_charterers
this.cb_sel_vessel=create cb_sel_vessel
this.cbx_include_vessel=create cbx_include_vessel
this.cb_saveas=create cb_saveas
this.sle_vessels=create sle_vessels
this.st_vessels=create st_vessels
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.cb_print_totals=create cb_print_totals
this.rb_all=create rb_all
this.rb_swnf=create rb_swnf
this.rb_sm=create rb_sm
this.rb_em=create rb_em
this.dw_outst_detail=create dw_outst_detail
this.dw_profit_center=create dw_profit_center
this.dw_stat_totals=create dw_stat_totals
this.gb_mismatch=create gb_mismatch
this.dw_stat_detail=create dw_stat_detail
this.gb_pc=create gb_pc
this.uo_demurrage_analyst=create uo_demurrage_analyst
this.gb_filter=create gb_filter
this.gb_summary=create gb_summary
this.gb_forwardingdate=create gb_forwardingdate
this.dw_save=create dw_save
this.cbx_select=create cbx_select
this.rb_less=create rb_less
this.gb_voyage_year=create gb_voyage_year
this.st_topbar=create st_topbar
this.sle_charterers=create sle_charterers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_forwarding_date
this.Control[iCurrent+2]=this.st_voyageyear
this.Control[iCurrent+3]=this.st_demurrage_analyst
this.Control[iCurrent+4]=this.em_days
this.Control[iCurrent+5]=this.st_days
this.Control[iCurrent+6]=this.em_year
this.Control[iCurrent+7]=this.st_year
this.Control[iCurrent+8]=this.rb_equal
this.Control[iCurrent+9]=this.rb_greater
this.Control[iCurrent+10]=this.rb_days_greater
this.Control[iCurrent+11]=this.rb_days_less
this.Control[iCurrent+12]=this.cbx_sepline
this.Control[iCurrent+13]=this.em_lines
this.Control[iCurrent+14]=this.st_printlines
this.Control[iCurrent+15]=this.cb_sel_office
this.Control[iCurrent+16]=this.sle_offices
this.Control[iCurrent+17]=this.cbx_include_office
this.Control[iCurrent+18]=this.st_offices
this.Control[iCurrent+19]=this.cb_sel_broker
this.Control[iCurrent+20]=this.sle_brokers
this.Control[iCurrent+21]=this.cbx_include_broker
this.Control[iCurrent+22]=this.st_brokers
this.Control[iCurrent+23]=this.cb_sel_chart
this.Control[iCurrent+24]=this.cbx_include_chart
this.Control[iCurrent+25]=this.st_charterers
this.Control[iCurrent+26]=this.cb_sel_vessel
this.Control[iCurrent+27]=this.cbx_include_vessel
this.Control[iCurrent+28]=this.cb_saveas
this.Control[iCurrent+29]=this.sle_vessels
this.Control[iCurrent+30]=this.st_vessels
this.Control[iCurrent+31]=this.cb_retrieve
this.Control[iCurrent+32]=this.cb_print
this.Control[iCurrent+33]=this.cb_print_totals
this.Control[iCurrent+34]=this.rb_all
this.Control[iCurrent+35]=this.rb_swnf
this.Control[iCurrent+36]=this.rb_sm
this.Control[iCurrent+37]=this.rb_em
this.Control[iCurrent+38]=this.dw_outst_detail
this.Control[iCurrent+39]=this.dw_profit_center
this.Control[iCurrent+40]=this.dw_stat_totals
this.Control[iCurrent+41]=this.gb_mismatch
this.Control[iCurrent+42]=this.dw_stat_detail
this.Control[iCurrent+43]=this.gb_pc
this.Control[iCurrent+44]=this.uo_demurrage_analyst
this.Control[iCurrent+45]=this.gb_filter
this.Control[iCurrent+46]=this.gb_summary
this.Control[iCurrent+47]=this.gb_forwardingdate
this.Control[iCurrent+48]=this.dw_save
this.Control[iCurrent+49]=this.cbx_select
this.Control[iCurrent+50]=this.rb_less
this.Control[iCurrent+51]=this.gb_voyage_year
this.Control[iCurrent+52]=this.st_topbar
this.Control[iCurrent+53]=this.sle_charterers
end on

on w_demurrage_section.destroy
call super::destroy
destroy(this.st_forwarding_date)
destroy(this.st_voyageyear)
destroy(this.st_demurrage_analyst)
destroy(this.em_days)
destroy(this.st_days)
destroy(this.em_year)
destroy(this.st_year)
destroy(this.rb_equal)
destroy(this.rb_greater)
destroy(this.rb_days_greater)
destroy(this.rb_days_less)
destroy(this.cbx_sepline)
destroy(this.em_lines)
destroy(this.st_printlines)
destroy(this.cb_sel_office)
destroy(this.sle_offices)
destroy(this.cbx_include_office)
destroy(this.st_offices)
destroy(this.cb_sel_broker)
destroy(this.sle_brokers)
destroy(this.cbx_include_broker)
destroy(this.st_brokers)
destroy(this.cb_sel_chart)
destroy(this.cbx_include_chart)
destroy(this.st_charterers)
destroy(this.cb_sel_vessel)
destroy(this.cbx_include_vessel)
destroy(this.cb_saveas)
destroy(this.sle_vessels)
destroy(this.st_vessels)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.cb_print_totals)
destroy(this.rb_all)
destroy(this.rb_swnf)
destroy(this.rb_sm)
destroy(this.rb_em)
destroy(this.dw_outst_detail)
destroy(this.dw_profit_center)
destroy(this.dw_stat_totals)
destroy(this.gb_mismatch)
destroy(this.dw_stat_detail)
destroy(this.gb_pc)
destroy(this.uo_demurrage_analyst)
destroy(this.gb_filter)
destroy(this.gb_summary)
destroy(this.gb_forwardingdate)
destroy(this.dw_save)
destroy(this.cbx_select)
destroy(this.rb_less)
destroy(this.gb_voyage_year)
destroy(this.st_topbar)
destroy(this.sle_charterers)
end on

event open;call super::open;n_service_manager		lnv_servicemgr
n_dw_style_service   lnv_style

dw_profit_center.settransobject(sqlca)
dw_profit_center.retrieve(uo_global.is_userid)

em_year.text = string(year(today()))

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_stat_detail, false)
lnv_style.of_dwlistformater(dw_outst_detail, false)


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_demurrage_section
end type

type st_forwarding_date from mt_u_statictext within w_demurrage_section
integer x = 1006
integer y = 264
integer width = 567
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Today - Forwarding Date"
end type

type st_voyageyear from mt_u_statictext within w_demurrage_section
integer x = 1006
integer y = 152
integer width = 311
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Voyage Year"
end type

type st_demurrage_analyst from mt_u_statictext within w_demurrage_section
integer x = 1006
integer y = 48
integer width = 439
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Demurrage Analyst"
end type

type em_days from mt_u_editmask within w_demurrage_section
integer x = 1952
integer y = 264
integer width = 169
integer height = 56
integer taborder = 70
long backcolor = 16777215
string text = "45"
boolean border = false
alignment alignment = right!
string mask = "####"
string minmax = "0~~9999"
end type

type st_days from mt_u_statictext within w_demurrage_section
integer x = 2135
integer y = 264
integer width = 128
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "days"
end type

type em_year from mt_u_editmask within w_demurrage_section
integer x = 1865
integer y = 152
integer width = 219
integer height = 56
integer taborder = 50
long backcolor = 16777215
string text = ""
boolean border = false
alignment alignment = right!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1995~~2050"
end type

type st_year from mt_u_statictext within w_demurrage_section
integer x = 2098
integer y = 152
integer width = 155
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "(yyyy)"
alignment alignment = right!
end type

type rb_equal from mt_u_radiobutton within w_demurrage_section
integer x = 1536
integer y = 144
integer width = 119
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "="
boolean checked = true
end type

type rb_greater from mt_u_radiobutton within w_demurrage_section
integer x = 1678
integer y = 144
integer width = 151
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
end type

type rb_days_greater from mt_u_radiobutton within w_demurrage_section
integer x = 1614
integer y = 256
integer width = 160
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
boolean checked = true
end type

type rb_days_less from mt_u_radiobutton within w_demurrage_section
integer x = 1787
integer y = 256
integer width = 110
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "<"
end type

type cbx_sepline from mt_u_checkbox within w_demurrage_section
integer x = 3877
integer y = 504
integer width = 695
integer height = 56
integer taborder = 170
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show vessel separation line"
boolean lefttext = true
end type

event clicked;if this.checked then
	dw_stat_detail.Modify("l_vessel_sep.visible='0~tif ( claims_vessel_nr [0] <>  claims_vessel_nr [-1], 1,0)'")
	dw_outst_detail.Modify("l_vessel_sep.visible='0~tif ( claims_vessel_nr [0] <>  claims_vessel_nr [-1], 1,0)'")
else
	dw_stat_detail.Modify("l_vessel_sep.visible='0'")
	dw_outst_detail.Modify("l_vessel_sep.visible='0'")
end if	
end event

type em_lines from mt_u_editmask within w_demurrage_section
integer x = 4329
integer y = 2288
integer width = 238
integer height = 72
integer taborder = 210
long backcolor = 16777215
string text = "0"
alignment alignment = right!
string mask = "###0"
end type

type st_printlines from mt_u_statictext within w_demurrage_section
integer x = 3031
integer y = 2304
integer width = 1303
integer height = 56
long backcolor = 553648127
boolean enabled = false
string text = "Number of lines to Print / Save As. If 0 all lines are printed."
end type

type cb_sel_office from mt_u_commandbutton within w_demurrage_section
integer x = 4471
integer y = 316
integer width = 73
integer height = 64
integer taborder = 160
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "office"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.office_nr)
sle_offices.text = ""
is_office_filter = ''
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		is_office_filter = string(istr_parm.office_nr[li_x])
	else
		is_office_filter += ", " + string(istr_parm.office_nr[li_x])
	end if
Next

sle_offices.text = is_office_filter
end event

type sle_offices from mt_u_singlelineedit within w_demurrage_section
integer x = 3721
integer y = 320
integer width = 727
integer height = 56
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cbx_include_office from mt_u_checkbox within w_demurrage_section
integer x = 3465
integer y = 320
integer width = 242
integer height = 56
integer taborder = 150
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if
this.textcolor = c#color.white

end event

type st_offices from mt_u_statictext within w_demurrage_section
integer x = 3191
integer y = 320
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Offices"
end type

type cb_sel_broker from mt_u_commandbutton within w_demurrage_section
integer x = 4471
integer y = 236
integer width = 73
integer height = 64
integer taborder = 140
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "broker"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.broker_nr)
sle_brokers.text = ""
is_broker_filter = ''
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		is_broker_filter= string(istr_parm.broker_nr[li_x])
	else
		is_broker_filter += ", " + string(istr_parm.broker_nr[li_x])
	end if
Next

sle_brokers.text = is_broker_filter

end event

type sle_brokers from mt_u_singlelineedit within w_demurrage_section
integer x = 3721
integer y = 240
integer width = 727
integer height = 56
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cbx_include_broker from mt_u_checkbox within w_demurrage_section
integer x = 3465
integer y = 240
integer width = 242
integer height = 56
integer taborder = 130
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if
this.textcolor = c#color.white

end event

type st_brokers from mt_u_statictext within w_demurrage_section
integer x = 3191
integer y = 240
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Brokers"
end type

type cb_sel_chart from mt_u_commandbutton within w_demurrage_section
integer x = 4471
integer y = 156
integer width = 73
integer height = 64
integer taborder = 120
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x
string ls_chart

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "chart"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.chart_nr)
sle_charterers.text = ""
is_chart_filter = ''
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		is_chart_filter = string(istr_parm.chart_nr[li_x])
	else
		is_chart_filter += ", " + string(istr_parm.chart_nr[li_x])
	end if
Next

sle_charterers.text = is_chart_filter


end event

type cbx_include_chart from mt_u_checkbox within w_demurrage_section
integer x = 3465
integer y = 160
integer width = 242
integer height = 56
integer taborder = 110
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if
this.textcolor = c#color.white

end event

type st_charterers from mt_u_statictext within w_demurrage_section
integer x = 3191
integer y = 160
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Charterers"
end type

type cb_sel_vessel from mt_u_commandbutton within w_demurrage_section
integer x = 4471
integer y = 76
integer width = 73
integer height = 64
integer taborder = 100
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x
string ls_vessel_ref_nr

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "vessel"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.vessel_nr)
sle_vessels.text = ""
is_vessel_filter = ""
ls_vessel_ref_nr = ""
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		is_vessel_filter = string(istr_parm.vessel_nr[li_x])
		ls_vessel_ref_nr = string(istr_parm.vessel_ref_nr[li_x])
	else
		is_vessel_filter += ", " + string(istr_parm.vessel_nr[li_x])
		ls_vessel_ref_nr += ", " + string(istr_parm.vessel_ref_nr[li_x])
	end if
Next

sle_vessels.text = ls_vessel_ref_nr

if is_vessel_filter = "" then
	uo_demurrage_analyst.of_reset( )
end if

end event

type cbx_include_vessel from mt_u_checkbox within w_demurrage_section
integer x = 3465
integer y = 80
integer width = 242
integer height = 56
integer taborder = 90
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if
this.textcolor = c#color.white

end event

type cb_saveas from mt_u_commandbutton within w_demurrage_section
integer x = 3881
integer y = 2384
integer taborder = 230
boolean enabled = false
string text = "&Save As..."
end type

event clicked;string	ls_temp_filter
integer  li_lines

if dw_stat_detail.rowcount() < 1 then return

dw_save.dataobject = dw_stat_detail.dataobject
dw_save.object.data.primary = dw_stat_detail.object.data.primary

li_lines = integer(em_lines.text)
if li_lines > 0 then
	ls_temp_filter = "getrow() <= "+string(li_lines)
	dw_save.setfilter(ls_temp_filter)
	dw_save.filter()
end if

dw_save.modify("destroy column claims_vessel_nr")
dw_save.saveas("", Excel8!, true)
dw_save.reset()




end event

type sle_vessels from mt_u_singlelineedit within w_demurrage_section
integer x = 3721
integer y = 80
integer width = 727
integer height = 56
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

event modified;
end event

type st_vessels from mt_u_statictext within w_demurrage_section
integer x = 3191
integer y = 80
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Vessels"
end type

type cb_retrieve from mt_u_commandbutton within w_demurrage_section
integer x = 3534
integer y = 2384
integer taborder = 220
boolean enabled = false
string text = "&Retrieve"
end type

event clicked;
wf_retrieve()


end event

type cb_print from mt_u_commandbutton within w_demurrage_section
integer x = 4229
integer y = 2384
integer taborder = 240
boolean enabled = false
string text = "&Print"
end type

event clicked;string	ls_temp_filter
integer	li_lines
mt_n_datastore lds_dw_dem_print

lds_dw_dem_print = create mt_n_datastore

lds_dw_dem_print.dataobject = "d_dem_outstanding_print"
lds_dw_dem_print.object.data.primary = dw_stat_detail.object.data.primary

li_lines = integer(em_lines.text)
if li_lines > 0 then
	ls_temp_filter = "getrow() <= "+string(li_lines)
	lds_dw_dem_print.setFilter(ls_temp_filter)
	lds_dw_dem_print.Filter()
else
	ls_temp_filter = is_filter
end if

lds_dw_dem_print.Object.DataWindow.Print.orientation = 1

if cbx_sepline.checked then
	lds_dw_dem_print.Modify("l_vessel_sep.visible='0~tif ( vessel_nr [0] <>  vessel_nr [-1], 1,0)'")
else
	lds_dw_dem_print.object.l_vessel_sep.visible="0"
end if	
lds_dw_dem_print.print()

end event

type cb_print_totals from mt_u_commandbutton within w_demurrage_section
integer x = 4229
integer y = 2000
integer taborder = 200
boolean enabled = false
string text = "Pri&nt"
end type

event clicked;dw_stat_totals.print()
end event

type rb_all from mt_u_radiobutton within w_demurrage_section
integer x = 2331
integer y = 320
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "All claims"
boolean checked = true
end type

event clicked;
end event

type rb_swnf from mt_u_radiobutton within w_demurrage_section
integer x = 2331
integer y = 240
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Claims with no forwarding date"
end type

event clicked;
end event

type rb_sm from mt_u_radiobutton within w_demurrage_section
integer x = 2331
integer y = 160
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Claims mismatch"
end type

event clicked;
end event

type rb_em from mt_u_radiobutton within w_demurrage_section
integer x = 2331
integer y = 80
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Exclude claims with mismatch"
end type

event clicked;
end event

type dw_outst_detail from u_datagrid within w_demurrage_section
integer x = 37
integer y = 1536
integer width = 2889
integer height = 944
integer taborder = 190
string dataobject = "d_dem_outstanding_detail"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event doubleclicked;if row <= 0 then Return

of_open_actions_trans(dw_outst_detail)
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then 
	selectrow(0, false)
	selectrow(currentrow, true)
end if
end event

type dw_profit_center from u_datagrid within w_demurrage_section
integer x = 73
integer y = 80
integer width = 859
integer height = 448
integer taborder = 20
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_multiselect = true
end type

event clicked;call super::clicked;wf_cbxselect_setcheck(false)
wf_get_pcnr(false)

end event

type dw_stat_totals from mt_u_datawindow within w_demurrage_section
integer x = 2999
integer y = 1584
integer width = 1536
integer height = 368
string dataobject = "d_dem_outstanding_stat"
boolean border = false
boolean livescroll = false
end type

type gb_mismatch from mt_u_groupbox within w_demurrage_section
integer x = 2295
integer y = 16
integer width = 823
integer taborder = 80
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Mismatch"
end type

type dw_stat_detail from u_datagrid within w_demurrage_section
integer x = 37
integer y = 624
integer width = 4535
integer height = 880
integer taborder = 180
string dataobject = "d_dem_outstanding_header"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event doubleclicked;if row <= 0 then Return

of_open_actions_trans(dw_stat_detail)


end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then 
	selectrow(0, false)
	selectrow(currentrow, true)
end if
end event

type gb_pc from mt_u_groupbox within w_demurrage_section
integer x = 37
integer y = 16
integer width = 933
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type uo_demurrage_analyst from u_demurrage_analyst within w_demurrage_section
integer x = 1435
integer y = 48
integer height = 56
integer taborder = 30
boolean bringtotop = true
end type

on uo_demurrage_analyst.destroy
call u_demurrage_analyst::destroy
end on

type gb_filter from mt_u_groupbox within w_demurrage_section
integer x = 3154
integer y = 16
integer width = 1417
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type gb_summary from mt_u_groupbox within w_demurrage_section
integer x = 2962
integer y = 1520
integer width = 1609
integer height = 464
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Summary"
end type

type gb_forwardingdate from mt_u_groupbox within w_demurrage_section
integer x = 1577
integer y = 224
integer width = 343
integer height = 112
integer taborder = 60
integer weight = 400
string facename = "Tahoma"
long textcolor = 255
long backcolor = 553648127
string text = ""
end type

type dw_save from mt_u_datawindow within w_demurrage_section
boolean visible = false
integer x = 3163
integer y = 2064
integer width = 329
integer height = 160
boolean bringtotop = true
string dataobject = "d_dem_outstanding_header"
boolean border = false
end type

type cbx_select from mt_u_checkbox within w_demurrage_section
integer x = 622
integer y = 8
integer width = 261
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22497827
string text = "Select all"
end type

event clicked;call super::clicked;
wf_cbxselect_setcheck(this.checked,true)

wf_get_pcnr(false)
end event

type rb_less from mt_u_radiobutton within w_demurrage_section
integer x = 1349
integer y = 144
integer width = 146
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "<="
end type

type gb_voyage_year from mt_u_groupbox within w_demurrage_section
integer x = 1326
integer y = 112
integer width = 507
integer height = 112
integer taborder = 40
integer weight = 400
string facename = "Tahoma"
long textcolor = 255
long backcolor = 553648127
string text = ""
end type

type st_topbar from u_topbar_background within w_demurrage_section
integer width = 5851
integer height = 592
end type

type sle_charterers from multilineedit within w_demurrage_section
integer x = 3721
integer y = 160
integer width = 727
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
boolean border = false
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

