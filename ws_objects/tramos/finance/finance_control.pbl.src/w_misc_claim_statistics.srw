$PBExportHeader$w_misc_claim_statistics.srw
$PBExportComments$Used by demurrage section
forward
global type w_misc_claim_statistics from mt_w_sheet
end type
type dw_save from mt_u_datawindow within w_misc_claim_statistics
end type
type st_forwarding_date from mt_u_statictext within w_misc_claim_statistics
end type
type st_voyage_year from mt_u_statictext within w_misc_claim_statistics
end type
type rb_days_less from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_days_greater from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_greater from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_equal from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_less from mt_u_radiobutton within w_misc_claim_statistics
end type
type st_year from mt_u_statictext within w_misc_claim_statistics
end type
type em_year from mt_u_editmask within w_misc_claim_statistics
end type
type cbx_sepline from mt_u_checkbox within w_misc_claim_statistics
end type
type st_types from mt_u_statictext within w_misc_claim_statistics
end type
type cbx_include_claimtype from mt_u_checkbox within w_misc_claim_statistics
end type
type sle_claimtypes from mt_u_singlelineedit within w_misc_claim_statistics
end type
type cb_sel_claimtype from mt_u_commandbutton within w_misc_claim_statistics
end type
type em_lines from mt_u_editmask within w_misc_claim_statistics
end type
type st_printlines from mt_u_statictext within w_misc_claim_statistics
end type
type cb_sel_office from mt_u_commandbutton within w_misc_claim_statistics
end type
type sle_offices from mt_u_singlelineedit within w_misc_claim_statistics
end type
type cbx_include_office from mt_u_checkbox within w_misc_claim_statistics
end type
type st_offices from mt_u_statictext within w_misc_claim_statistics
end type
type cb_sel_broker from mt_u_commandbutton within w_misc_claim_statistics
end type
type sle_brokers from mt_u_singlelineedit within w_misc_claim_statistics
end type
type cbx_include_broker from mt_u_checkbox within w_misc_claim_statistics
end type
type st_brokers from mt_u_statictext within w_misc_claim_statistics
end type
type cb_sel_chart from mt_u_commandbutton within w_misc_claim_statistics
end type
type sle_charterers from mt_u_singlelineedit within w_misc_claim_statistics
end type
type cbx_include_chart from mt_u_checkbox within w_misc_claim_statistics
end type
type st_charterers from mt_u_statictext within w_misc_claim_statistics
end type
type cb_sel_vessel from mt_u_commandbutton within w_misc_claim_statistics
end type
type cbx_include_vessel from mt_u_checkbox within w_misc_claim_statistics
end type
type cb_saveas from mt_u_commandbutton within w_misc_claim_statistics
end type
type sle_vessels from mt_u_singlelineedit within w_misc_claim_statistics
end type
type st_vessels from mt_u_statictext within w_misc_claim_statistics
end type
type st_days from mt_u_statictext within w_misc_claim_statistics
end type
type em_days from mt_u_editmask within w_misc_claim_statistics
end type
type cb_retrieve from mt_u_commandbutton within w_misc_claim_statistics
end type
type cb_print from mt_u_commandbutton within w_misc_claim_statistics
end type
type cb_print_totals from mt_u_commandbutton within w_misc_claim_statistics
end type
type rb_all from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_swnf from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_sm from mt_u_radiobutton within w_misc_claim_statistics
end type
type rb_em from mt_u_radiobutton within w_misc_claim_statistics
end type
type dw_outst_detail from u_datagrid within w_misc_claim_statistics
end type
type dw_profit_center from u_datagrid within w_misc_claim_statistics
end type
type dw_stat_totals from mt_u_datawindow within w_misc_claim_statistics
end type
type dw_stat_detail from u_datagrid within w_misc_claim_statistics
end type
type gb_mismatch from mt_u_groupbox within w_misc_claim_statistics
end type
type gb_voyage_year from mt_u_groupbox within w_misc_claim_statistics
end type
type gb_forwarding_date from mt_u_groupbox within w_misc_claim_statistics
end type
type gb_pc from mt_u_groupbox within w_misc_claim_statistics
end type
type gb_summary from mt_u_groupbox within w_misc_claim_statistics
end type
type gb_filter from mt_u_groupbox within w_misc_claim_statistics
end type
type st_topbar from u_topbar_background within w_misc_claim_statistics
end type
type st_1 from statictext within w_misc_claim_statistics
end type
type uo_claim_analyst from u_claims_analyst within w_misc_claim_statistics
end type
type cbx_select from checkbox within w_misc_claim_statistics
end type
end forward

global type w_misc_claim_statistics from mt_w_sheet
integer width = 4608
integer height = 2584
string title = "Miscellaneous Claims"
boolean maxbox = false
boolean resizable = false
boolean center = false
dw_save dw_save
st_forwarding_date st_forwarding_date
st_voyage_year st_voyage_year
rb_days_less rb_days_less
rb_days_greater rb_days_greater
rb_greater rb_greater
rb_equal rb_equal
rb_less rb_less
st_year st_year
em_year em_year
cbx_sepline cbx_sepline
st_types st_types
cbx_include_claimtype cbx_include_claimtype
sle_claimtypes sle_claimtypes
cb_sel_claimtype cb_sel_claimtype
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
sle_charterers sle_charterers
cbx_include_chart cbx_include_chart
st_charterers st_charterers
cb_sel_vessel cb_sel_vessel
cbx_include_vessel cbx_include_vessel
cb_saveas cb_saveas
sle_vessels sle_vessels
st_vessels st_vessels
st_days st_days
em_days em_days
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
dw_stat_detail dw_stat_detail
gb_mismatch gb_mismatch
gb_voyage_year gb_voyage_year
gb_forwarding_date gb_forwarding_date
gb_pc gb_pc
gb_summary gb_summary
gb_filter gb_filter
st_topbar st_topbar
st_1 st_1
uo_claim_analyst uo_claim_analyst
cbx_select cbx_select
end type
global w_misc_claim_statistics w_misc_claim_statistics

type variables
s_demurrage_stat_selection istr_parm
string is_filter
string is_vessel_filter

end variables

forward prototypes
public subroutine of_open_actions_trans (u_datagrid dwo)
public subroutine documentation ()
public subroutine wf_open_specialclaims (u_datagrid adw_dw)
public subroutine wf_get_pcnr (boolean ab_analysechanged)
public subroutine wf_retrieve ()
end prototypes

public subroutine of_open_actions_trans (u_datagrid dwo);u_jump_actions_trans luo_jump_actions_trans
string ls_voyage_nr, ls_claim_type
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr

luo_jump_actions_trans = create u_jump_actions_trans

li_vessel_nr 	= dwo.getitemnumber(dwo.getrow(), "claims_vessel_nr")
ls_voyage_nr 	= dwo.getitemstring(dwo.getrow(), "claims_voyage_nr")
ll_chart_nr	 	= dwo.getitemnumber(dwo.getrow(), "chart_opponent_no")
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
		Date    		CR-Ref		Author		Comments
		29/08/14		CR3781		CCY018		The window title match with the text of a menu item
		10/12/14		CR3796		LHG008		1.Add Claim Comment from Actions/Transactions to reports.
   	                              		2.Use the latest exchange rate for Amount calculation.
		07-02-17		CR2679UAT2	XSZ004		Add retrive button and remove auto function.														
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_open_specialclaims (u_datagrid adw_dw);/********************************************************************
   wf_open_specialclaims
   <DESC>	Description	</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_dw
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03/06/16		CR4034            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_special_claim_id, ll_row
n_jump_specialclaims lno_jump_specialclaims

lno_jump_specialclaims = create n_jump_specialclaims

ll_row = adw_dw.getrow()
if ll_row > 0 then
	ll_special_claim_id	 = adw_dw.getitemnumber(ll_row, "claims_claim_nr")
	lno_jump_specialclaims.of_open_specialclaims(ll_special_claim_id)
end if

destroy lno_jump_specialclaims
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
		08/12/16		CR2679		XSZ004		First version
   </HISTORY>
********************************************************************/

int li_findrow, li_selectrow, li_rowcount, li_index, li_empty[]

li_index    = 1
li_rowcount = dw_profit_center.rowcount()

istr_parm.profitcenter = li_empty

li_selectrow = dw_profit_center.getselectedrow(0)

if li_selectrow < 1 then
	if ab_analysechanged then
		
		cbx_select.checked = true
		cbx_select.text = "Deselect all"
		cbx_select.textcolor = c#color.White
		
		dw_profit_center.selectrow(0, true)
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

public subroutine wf_retrieve ();long   ll_row, ll_rows
string ls_operator, ls_pc, ls_analyst 

is_filter = ""

dw_stat_detail.setredraw(false)
dw_stat_totals.setredraw(false)
dw_outst_detail.setredraw(false)

setPointer(hourglass!)

dw_stat_detail.reset()
dw_stat_detail.retrieve(istr_parm.profitcenter)

dw_stat_detail.ShareData(dw_stat_totals)
dw_stat_detail.ShareData(dw_outst_detail)	

setPointer(arrow!)

if (rb_em.checked) then
	if (len(is_filter)=0) then
		is_filter += " claims_forwarding_date >= disch_date "
	else
		is_filter += " and "
		is_filter += " claims_forwarding_date >= disch_date "
	end if
elseif (rb_sm.checked) then
	if (len(is_filter)=0) then
		is_filter += " claims_forwarding_date < disch_date "
	else
		is_filter += " and "
		is_filter += " claims_forwarding_date < disch_date "
	end if
elseif (rb_swnf.checked) then
	if (len(is_filter)=0) then
		is_filter += " isnull (claims_forwarding_date) "
	else
		is_filter += " and "
		is_filter += " isnull (claims_forwarding_date) "
	end if
elseif (rb_all.checked) then
end if

if (len(em_year.text) > 0) then
	if rb_less.checked = true then
		ls_operator = "<="
	elseif rb_equal.checked = true then
		ls_operator = "="
	else
		ls_operator = ">="
	end if
	
	if (len(is_filter)=0) then
		is_filter += "left(compute_voyage_sort , 4 ) " + ls_operator + " '" + string(em_year.text) +"'"
	else
		is_filter += " and "
		is_filter += " left(compute_voyage_sort , 4 ) " + ls_operator +  " '" + string(em_year.text) +"'"
	end if
end if

if (len(em_days.text) > 0) then
	if rb_days_greater.checked = true then
		ls_operator = ">="
	else
		ls_operator = "<"
	end if

	if (len(is_filter)=0) then
		is_filter += " daysafter(claims_forwarding_date , today() ) " + ls_operator + string(em_days.text) 
	else 
		is_filter += " and "
		is_filter += " daysafter(claims_forwarding_date , today() ) " + ls_operator + string(em_days.text)
	end if
end if

/* Vessel Number */
if (len(sle_vessels.text) > 0) then
	if cbx_include_vessel.checked then
		if (len(is_filter)=0) then
			is_filter += " claims_vessel_nr in ( " + string(is_vessel_filter) + " )"
		else 
			is_filter += " and "
			is_filter += " claims_vessel_nr in ( " + string(is_vessel_filter) + " )"
		end if
	else
		if (len(is_filter)=0) then
			is_filter += " claims_vessel_nr not in ( " + string(is_vessel_filter) + " )"
		else 
			is_filter += " and "
			is_filter += " claims_vessel_nr not in ( " + string(is_vessel_filter) + " )"
		end if
	end if
end if

/* Charterer Number */
if (len(sle_charterers.text) > 0) then
	if cbx_include_chart.checked then
		if (len(is_filter)=0) then
			is_filter += " chart_opponent_no in ( " + string(sle_charterers.text) + " )"
		else 
			is_filter += " and "
			is_filter += " chart_opponent_no in ( " + string(sle_charterers.text) + " )"
		end if
	else
		if (len(is_filter)=0) then
			is_filter += " chart_opponent_no not in ( " + string(sle_charterers.text) + " )"
		else 
			is_filter += " and "
			is_filter += " chart_opponent_no not in ( " + string(sle_charterers.text) + " )"
		end if
	end if		
end if

/* Broker Number */
if (len(sle_brokers.text) > 0) then
	if cbx_include_broker.checked then
		if (len(is_filter)=0) then
			is_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
		else 
			is_filter += " and "
			is_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
		end if
	else
		if (len(is_filter)=0) then
			is_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
		else 
			is_filter += " and "
			is_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
		end if
	end if		
end if

/* Office Number */
if (len(sle_offices.text) > 0) then
	if cbx_include_office.checked then
		if (len(is_filter)=0) then
			is_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		else 
			is_filter += " and "
			is_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		end if
	else
		if (len(is_filter)=0) then
			is_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		else 
			is_filter += " and "
			is_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		end if
	end if		
end if

/* Claim Type */
if (len(sle_claimtypes.text) > 0) then
	if cbx_include_claimtype.checked then
		if (len(is_filter)=0) then
			is_filter += " claims_claim_type in ( " + sle_claimtypes.text + " )"
		else 
			is_filter += " and "
			is_filter += " claims_claim_type in ( " + sle_claimtypes.text + " )"
		end if
	else
		if (len(is_filter)=0) then
			is_filter += " claims_claim_type not in ( " + sle_claimtypes.text + " )"
		else 
			is_filter += " and "
			is_filter += " claims_claim_type not in ( " + sle_claimtypes.text + " )"
		end if
	end if		
end if

ls_analyst = uo_claim_analyst.of_get_analyst()

if ls_analyst <> "" then
	if len(is_filter) = 0 then
		is_filter += " claim_responsible = '" + ls_analyst + "'"
	else
		is_filter += " and claim_responsible = '" + ls_analyst + "'"
	end if
end if

dw_stat_detail.setfilter(is_filter)
dw_stat_detail.filter()

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

dw_stat_detail.setredraw(true)
dw_stat_totals.setredraw(true)
dw_outst_detail.setredraw(true)

end subroutine

on w_misc_claim_statistics.create
int iCurrent
call super::create
this.dw_save=create dw_save
this.st_forwarding_date=create st_forwarding_date
this.st_voyage_year=create st_voyage_year
this.rb_days_less=create rb_days_less
this.rb_days_greater=create rb_days_greater
this.rb_greater=create rb_greater
this.rb_equal=create rb_equal
this.rb_less=create rb_less
this.st_year=create st_year
this.em_year=create em_year
this.cbx_sepline=create cbx_sepline
this.st_types=create st_types
this.cbx_include_claimtype=create cbx_include_claimtype
this.sle_claimtypes=create sle_claimtypes
this.cb_sel_claimtype=create cb_sel_claimtype
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
this.sle_charterers=create sle_charterers
this.cbx_include_chart=create cbx_include_chart
this.st_charterers=create st_charterers
this.cb_sel_vessel=create cb_sel_vessel
this.cbx_include_vessel=create cbx_include_vessel
this.cb_saveas=create cb_saveas
this.sle_vessels=create sle_vessels
this.st_vessels=create st_vessels
this.st_days=create st_days
this.em_days=create em_days
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
this.dw_stat_detail=create dw_stat_detail
this.gb_mismatch=create gb_mismatch
this.gb_voyage_year=create gb_voyage_year
this.gb_forwarding_date=create gb_forwarding_date
this.gb_pc=create gb_pc
this.gb_summary=create gb_summary
this.gb_filter=create gb_filter
this.st_topbar=create st_topbar
this.st_1=create st_1
this.uo_claim_analyst=create uo_claim_analyst
this.cbx_select=create cbx_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_save
this.Control[iCurrent+2]=this.st_forwarding_date
this.Control[iCurrent+3]=this.st_voyage_year
this.Control[iCurrent+4]=this.rb_days_less
this.Control[iCurrent+5]=this.rb_days_greater
this.Control[iCurrent+6]=this.rb_greater
this.Control[iCurrent+7]=this.rb_equal
this.Control[iCurrent+8]=this.rb_less
this.Control[iCurrent+9]=this.st_year
this.Control[iCurrent+10]=this.em_year
this.Control[iCurrent+11]=this.cbx_sepline
this.Control[iCurrent+12]=this.st_types
this.Control[iCurrent+13]=this.cbx_include_claimtype
this.Control[iCurrent+14]=this.sle_claimtypes
this.Control[iCurrent+15]=this.cb_sel_claimtype
this.Control[iCurrent+16]=this.em_lines
this.Control[iCurrent+17]=this.st_printlines
this.Control[iCurrent+18]=this.cb_sel_office
this.Control[iCurrent+19]=this.sle_offices
this.Control[iCurrent+20]=this.cbx_include_office
this.Control[iCurrent+21]=this.st_offices
this.Control[iCurrent+22]=this.cb_sel_broker
this.Control[iCurrent+23]=this.sle_brokers
this.Control[iCurrent+24]=this.cbx_include_broker
this.Control[iCurrent+25]=this.st_brokers
this.Control[iCurrent+26]=this.cb_sel_chart
this.Control[iCurrent+27]=this.sle_charterers
this.Control[iCurrent+28]=this.cbx_include_chart
this.Control[iCurrent+29]=this.st_charterers
this.Control[iCurrent+30]=this.cb_sel_vessel
this.Control[iCurrent+31]=this.cbx_include_vessel
this.Control[iCurrent+32]=this.cb_saveas
this.Control[iCurrent+33]=this.sle_vessels
this.Control[iCurrent+34]=this.st_vessels
this.Control[iCurrent+35]=this.st_days
this.Control[iCurrent+36]=this.em_days
this.Control[iCurrent+37]=this.cb_retrieve
this.Control[iCurrent+38]=this.cb_print
this.Control[iCurrent+39]=this.cb_print_totals
this.Control[iCurrent+40]=this.rb_all
this.Control[iCurrent+41]=this.rb_swnf
this.Control[iCurrent+42]=this.rb_sm
this.Control[iCurrent+43]=this.rb_em
this.Control[iCurrent+44]=this.dw_outst_detail
this.Control[iCurrent+45]=this.dw_profit_center
this.Control[iCurrent+46]=this.dw_stat_totals
this.Control[iCurrent+47]=this.dw_stat_detail
this.Control[iCurrent+48]=this.gb_mismatch
this.Control[iCurrent+49]=this.gb_voyage_year
this.Control[iCurrent+50]=this.gb_forwarding_date
this.Control[iCurrent+51]=this.gb_pc
this.Control[iCurrent+52]=this.gb_summary
this.Control[iCurrent+53]=this.gb_filter
this.Control[iCurrent+54]=this.st_topbar
this.Control[iCurrent+55]=this.st_1
this.Control[iCurrent+56]=this.uo_claim_analyst
this.Control[iCurrent+57]=this.cbx_select
end on

on w_misc_claim_statistics.destroy
call super::destroy
destroy(this.dw_save)
destroy(this.st_forwarding_date)
destroy(this.st_voyage_year)
destroy(this.rb_days_less)
destroy(this.rb_days_greater)
destroy(this.rb_greater)
destroy(this.rb_equal)
destroy(this.rb_less)
destroy(this.st_year)
destroy(this.em_year)
destroy(this.cbx_sepline)
destroy(this.st_types)
destroy(this.cbx_include_claimtype)
destroy(this.sle_claimtypes)
destroy(this.cb_sel_claimtype)
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
destroy(this.sle_charterers)
destroy(this.cbx_include_chart)
destroy(this.st_charterers)
destroy(this.cb_sel_vessel)
destroy(this.cbx_include_vessel)
destroy(this.cb_saveas)
destroy(this.sle_vessels)
destroy(this.st_vessels)
destroy(this.st_days)
destroy(this.em_days)
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
destroy(this.dw_stat_detail)
destroy(this.gb_mismatch)
destroy(this.gb_voyage_year)
destroy(this.gb_forwarding_date)
destroy(this.gb_pc)
destroy(this.gb_summary)
destroy(this.gb_filter)
destroy(this.st_topbar)
destroy(this.st_1)
destroy(this.uo_claim_analyst)
destroy(this.cbx_select)
end on

event open;call super::open;n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style

dw_profit_center.settransobject(sqlca)
dw_profit_center.retrieve(uo_global.is_userid)

em_year.text = string(year(today()))

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_stat_detail, false)
lnv_style.of_dwlistformater(dw_outst_detail, false)

dw_profit_center.setrowfocusindicator(FocusRect!)


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_misc_claim_statistics
integer x = 0
integer y = 0
integer width = 553
end type

type dw_save from mt_u_datawindow within w_misc_claim_statistics
boolean visible = false
integer x = 3237
integer y = 2048
integer width = 329
integer height = 160
boolean bringtotop = true
string dataobject = "d_claim_outstanding_header"
boolean border = false
end type

type st_forwarding_date from mt_u_statictext within w_misc_claim_statistics
integer x = 997
integer y = 244
integer width = 553
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Today - Forwarding Date"
end type

type st_voyage_year from mt_u_statictext within w_misc_claim_statistics
integer x = 997
integer y = 136
integer width = 297
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Voyage Year"
end type

type rb_days_less from mt_u_radiobutton within w_misc_claim_statistics
integer x = 1733
integer y = 236
integer width = 110
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "<"
end type

type rb_days_greater from mt_u_radiobutton within w_misc_claim_statistics
integer x = 1577
integer y = 236
integer width = 160
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
boolean checked = true
end type

type rb_greater from mt_u_radiobutton within w_misc_claim_statistics
integer x = 1605
integer y = 132
integer width = 151
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
end type

type rb_equal from mt_u_radiobutton within w_misc_claim_statistics
integer x = 1481
integer y = 132
integer width = 119
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "="
boolean checked = true
end type

type rb_less from mt_u_radiobutton within w_misc_claim_statistics
integer x = 1312
integer y = 132
integer width = 146
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "<="
end type

type st_year from mt_u_statictext within w_misc_claim_statistics
integer x = 2025
integer y = 136
integer width = 155
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "(yyyy)"
end type

type em_year from mt_u_editmask within w_misc_claim_statistics
integer x = 1792
integer y = 140
integer width = 219
integer height = 56
integer taborder = 50
long textcolor = 0
long backcolor = 16777215
string text = ""
boolean border = false
alignment alignment = right!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1995~~2050"
end type

event getfocus;call super::getfocus;this.post selecttext(1, len(this.text))
end event

type cbx_sepline from mt_u_checkbox within w_misc_claim_statistics
integer x = 3895
integer y = 512
integer width = 672
integer height = 56
integer taborder = 190
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

type st_types from mt_u_statictext within w_misc_claim_statistics
integer x = 3077
integer y = 384
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Types"
alignment alignment = right!
end type

type cbx_include_claimtype from mt_u_checkbox within w_misc_claim_statistics
integer x = 3346
integer y = 384
integer width = 242
integer height = 56
integer taborder = 170
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

type sle_claimtypes from mt_u_singlelineedit within w_misc_claim_statistics
integer x = 3598
integer y = 384
integer width = 850
integer height = 56
long textcolor = 0
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cb_sel_claimtype from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4466
integer y = 380
integer width = 73
integer height = 64
integer taborder = 180
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

istr_parm.called_from = "claimtype"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.claimtype)

sle_claimtypes.text = ""

For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_claimtypes.text = "'"+istr_parm.claimtype[li_x]+"'"
	else
		sle_claimtypes.text += ", '" + istr_parm.claimtype[li_x]+"'"
	end if
Next
end event

type em_lines from mt_u_editmask within w_misc_claim_statistics
integer x = 4334
integer y = 2288
integer width = 224
integer height = 72
integer taborder = 230
long textcolor = 0
long backcolor = 16777215
string text = "0"
alignment alignment = right!
string mask = "###0"
end type

type st_printlines from mt_u_statictext within w_misc_claim_statistics
integer x = 3017
integer y = 2304
integer width = 1317
boolean enabled = false
string text = "Number of lines to Print / Save As. If 0 all lines are printed."
end type

type cb_sel_office from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4466
integer y = 300
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

sle_offices.text = ""

li_UpperBound = UpperBound(istr_parm.office_nr)

For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_offices.text = string(istr_parm.office_nr[li_x])
	else
		sle_offices.text += ", " + string(istr_parm.office_nr[li_x])
	end if
Next
end event

type sle_offices from mt_u_singlelineedit within w_misc_claim_statistics
integer x = 3598
integer y = 304
integer width = 850
integer height = 56
long textcolor = 0
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cbx_include_office from mt_u_checkbox within w_misc_claim_statistics
integer x = 3346
integer y = 304
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

type st_offices from mt_u_statictext within w_misc_claim_statistics
integer x = 3077
integer y = 304
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Offices"
alignment alignment = right!
end type

type cb_sel_broker from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4466
integer y = 220
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

sle_brokers.text = ""

li_UpperBound = UpperBound(istr_parm.broker_nr)

For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_brokers.text = string(istr_parm.broker_nr[li_x])
	else
		sle_brokers.text += ", " + string(istr_parm.broker_nr[li_x])
	end if
Next
end event

type sle_brokers from mt_u_singlelineedit within w_misc_claim_statistics
integer x = 3598
integer y = 224
integer width = 850
integer height = 56
long textcolor = 0
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cbx_include_broker from mt_u_checkbox within w_misc_claim_statistics
integer x = 3346
integer y = 224
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

type st_brokers from mt_u_statictext within w_misc_claim_statistics
integer x = 3077
integer y = 224
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Brokers"
alignment alignment = right!
end type

type cb_sel_chart from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4466
integer y = 140
integer width = 73
integer height = 64
integer taborder = 120
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "chart"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

sle_charterers.text = ""

li_UpperBound = UpperBound(istr_parm.chart_nr)

For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_charterers.text = string(istr_parm.chart_nr[li_x])
	else
		sle_charterers.text += ", " + string(istr_parm.chart_nr[li_x])
	end if
Next
end event

type sle_charterers from mt_u_singlelineedit within w_misc_claim_statistics
integer x = 3598
integer y = 144
integer width = 850
integer height = 56
long textcolor = 0
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type cbx_include_chart from mt_u_checkbox within w_misc_claim_statistics
integer x = 3346
integer y = 144
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

type st_charterers from mt_u_statictext within w_misc_claim_statistics
integer x = 3077
integer y = 144
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Charterers"
alignment alignment = right!
end type

type cb_sel_vessel from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4466
integer y = 60
integer width = 73
integer height = 64
integer taborder = 100
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "vessel"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.vessel_nr)
sle_vessels.text = ""
is_vessel_filter = ""
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_vessels.text = istr_parm.vessel_ref_nr[li_x]
		is_vessel_filter = string(istr_parm.vessel_nr[li_x])
	else
		sle_vessels.text += ", " + istr_parm.vessel_ref_nr[li_x]
		is_vessel_filter += ", " + string(istr_parm.vessel_nr[li_x])
	end if
Next

end event

type cbx_include_vessel from mt_u_checkbox within w_misc_claim_statistics
integer x = 3346
integer y = 64
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

type cb_saveas from mt_u_commandbutton within w_misc_claim_statistics
integer x = 3877
integer y = 2384
integer taborder = 250
boolean enabled = false
string text = "&Save As..."
end type

event clicked;string	ls_temp_filter
integer	li_lines

li_lines = integer(em_lines.text)
if li_lines > 0 then
	if len(is_filter) > 0 then
		ls_temp_filter = is_filter + " and getrow() <= "+string(li_lines)
	else
		ls_temp_filter = "getrow() <= "+string(li_lines)
	end if
else
	ls_temp_filter = is_filter
end if

dw_save.dataobject = dw_stat_detail.dataobject
dw_save.object.data.primary = dw_stat_detail.object.data.primary

dw_save.setfilter(ls_temp_filter)
dw_save.filter()

dw_save.modify("destroy column claims_vessel_nr")
dw_save.saveas("", Excel8!, true)
dw_save.reset()
end event

type sle_vessels from mt_u_singlelineedit within w_misc_claim_statistics
integer x = 3598
integer y = 64
integer width = 850
integer height = 56
long textcolor = 0
long backcolor = 32304364
string text = ""
boolean border = false
boolean displayonly = true
end type

type st_vessels from mt_u_statictext within w_misc_claim_statistics
integer x = 3077
integer y = 64
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Vessels"
alignment alignment = right!
end type

type st_days from mt_u_statictext within w_misc_claim_statistics
integer x = 2062
integer y = 240
integer width = 128
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "days"
end type

type em_days from mt_u_editmask within w_misc_claim_statistics
integer x = 1879
integer y = 244
integer width = 169
integer height = 56
integer taborder = 70
long textcolor = 0
long backcolor = 16777215
string text = "45"
boolean border = false
alignment alignment = right!
string mask = "####"
string minmax = "0~~9999"
end type

event getfocus;call super::getfocus;this.post selecttext(1, len(this.text))
end event

type cb_retrieve from mt_u_commandbutton within w_misc_claim_statistics
integer x = 3529
integer y = 2384
integer taborder = 240
boolean enabled = false
string text = "&Retrieve"
end type

event clicked;wf_retrieve()


end event

type cb_print from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4224
integer y = 2384
integer taborder = 260
boolean enabled = false
string text = "&Print"
end type

event clicked;string	ls_temp_filter
integer	li_lines
mt_n_datastore lds_dw_dem_print

lds_dw_dem_print = create mt_n_datastore

li_lines = integer(em_lines.text)
if li_lines > 0 then
	if len(is_filter) > 0 then
		ls_temp_filter = is_filter + " and getrow() <= "+string(li_lines)
	else
		ls_temp_filter = "getrow() <= "+string(li_lines)
	end if
else
	ls_temp_filter = is_filter
end if

dw_stat_detail.setRedraw( false )
dw_outst_detail.setRedraw( false )
dw_stat_detail.setFilter(ls_temp_filter)
dw_stat_detail.Filter()

lds_dw_dem_print.dataobject = "d_claim_outstanding_print"
dw_stat_detail.ShareData(lds_dw_dem_print)	

lds_dw_dem_print.Object.DataWindow.Print.orientation = 1

if cbx_sepline.checked then
	lds_dw_dem_print.Modify("l_vessel_sep.visible='0~tif ( claims_vessel_nr [0] <>  claims_vessel_nr [-1], 1,0)'")
else
	lds_dw_dem_print.object.l_vessel_sep.visible="0"
end if	

lds_dw_dem_print.print()

dw_stat_detail.setFilter(is_filter)
dw_stat_detail.Filter()
dw_outst_detail.setRedraw( true )
dw_stat_detail.setRedraw(true)
end event

type cb_print_totals from mt_u_commandbutton within w_misc_claim_statistics
integer x = 4224
integer y = 2000
integer taborder = 220
boolean enabled = false
string text = "Pri&nt"
end type

event clicked;dw_stat_totals.print()
end event

type rb_all from mt_u_radiobutton within w_misc_claim_statistics
integer x = 2240
integer y = 320
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "All claims"
boolean checked = true
end type

type rb_swnf from mt_u_radiobutton within w_misc_claim_statistics
integer x = 2240
integer y = 240
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Claims with no forwarding date"
end type

type rb_sm from mt_u_radiobutton within w_misc_claim_statistics
integer x = 2240
integer y = 160
integer width = 763
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Claims mismatch"
end type

type rb_em from mt_u_radiobutton within w_misc_claim_statistics
integer x = 2240
integer y = 80
integer width = 768
integer height = 72
long textcolor = 16777215
long backcolor = 553648127
string text = "Exclude claims with mismatch"
end type

type dw_outst_detail from u_datagrid within w_misc_claim_statistics
integer x = 37
integer y = 1536
integer width = 2889
integer height = 936
integer taborder = 210
string dataobject = "d_claim_outstanding_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event doubleclicked;string ls_type

if row <= 0 then Return

ls_type = this.getitemstring(row, "claims_claim_type")
if ls_type = "SPEC" then
	wf_open_specialclaims(this)
else
	of_open_actions_trans(dw_outst_detail)
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then 
	selectrow(0, false)
	selectrow(currentrow, true)
end if
end event

type dw_profit_center from u_datagrid within w_misc_claim_statistics
integer x = 73
integer y = 80
integer width = 859
integer height = 448
integer taborder = 20
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_multiselect = true
end type

event ue_lbuttonup;call super::ue_lbuttonup;if dwo.type = "column" or dwo.type = "datawindow" then
	wf_get_pcnr(false)
end if
end event

event clicked;call super::clicked;if keydown(KeySpaceBar!) and row > 0 then
	this.event ue_lbuttonup(xpos, ypos, row, dwo)
end if
end event

type dw_stat_totals from mt_u_datawindow within w_misc_claim_statistics
integer x = 2999
integer y = 1584
integer width = 1541
integer height = 372
string dataobject = "d_claim_outstanding_stat"
boolean vscrollbar = true
boolean border = false
end type

type dw_stat_detail from u_datagrid within w_misc_claim_statistics
integer x = 37
integer y = 624
integer width = 4535
integer height = 880
integer taborder = 200
string dataobject = "d_claim_outstanding_header"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event doubleclicked;string ls_type

if row <= 0 then Return

ls_type = this.getitemstring(row, "claims_claim_type")
if ls_type = "SPEC" THEN
	wf_open_specialclaims(this)
else
	of_open_actions_trans(dw_stat_detail)
end if


end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then 
	selectrow(0, false)
	selectrow(currentrow, true)
end if
end event

type gb_mismatch from mt_u_groupbox within w_misc_claim_statistics
integer x = 2203
integer y = 16
integer width = 814
integer height = 396
integer taborder = 80
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Mismatch"
end type

type gb_voyage_year from mt_u_groupbox within w_misc_claim_statistics
integer x = 1289
integer y = 104
integer width = 489
integer height = 104
integer taborder = 40
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type gb_forwarding_date from mt_u_groupbox within w_misc_claim_statistics
integer x = 1559
integer y = 208
integer width = 306
integer height = 104
integer taborder = 60
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type gb_pc from mt_u_groupbox within w_misc_claim_statistics
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

type gb_summary from mt_u_groupbox within w_misc_claim_statistics
integer x = 2962
integer y = 1520
integer width = 1609
integer height = 464
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Summary"
end type

type gb_filter from mt_u_groupbox within w_misc_claim_statistics
integer x = 3045
integer y = 16
integer width = 1531
integer height = 460
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type st_topbar from u_topbar_background within w_misc_claim_statistics
integer width = 5851
integer height = 592
end type

type st_1 from statictext within w_misc_claim_statistics
integer x = 997
integer y = 44
integer width = 325
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Claims Analyst"
boolean focusrectangle = false
end type

type uo_claim_analyst from u_claims_analyst within w_misc_claim_statistics
integer x = 1330
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

on uo_claim_analyst.destroy
call u_claims_analyst::destroy
end on

event ue_itemchanged;call super::ue_itemchanged;wf_get_pcnr(true)
end event

type cbx_select from checkbox within w_misc_claim_statistics
integer x = 622
integer y = 8
integer width = 315
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;if this.checked then
	this.text = "Deselect all"
	dw_profit_center.selectrow(0, true)
else
	this.text = "Select all"
	dw_profit_center.selectrow(0, false)
end if

this.textcolor = c#color.White

wf_get_pcnr(false)

end event

