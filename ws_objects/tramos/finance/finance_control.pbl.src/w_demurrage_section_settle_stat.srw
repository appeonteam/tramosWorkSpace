$PBExportHeader$w_demurrage_section_settle_stat.srw
$PBExportComments$This window is used demurrage section in Product
forward
global type w_demurrage_section_settle_stat from mt_w_sheet
end type
type st_11 from statictext within w_demurrage_section_settle_stat
end type
type st_week from statictext within w_demurrage_section_settle_stat
end type
type st_2 from statictext within w_demurrage_section_settle_stat
end type
type st_1 from statictext within w_demurrage_section_settle_stat
end type
type em_week from editmask within w_demurrage_section_settle_stat
end type
type rb_oneweek from radiobutton within w_demurrage_section_settle_stat
end type
type rb_yeartoweek from radiobutton within w_demurrage_section_settle_stat
end type
type cbx_laytime_missing from checkbox within w_demurrage_section_settle_stat
end type
type cbx_negative_amounts from checkbox within w_demurrage_section_settle_stat
end type
type cbx_group_by_chart from checkbox within w_demurrage_section_settle_stat
end type
type uo_demurrage_analyst from u_demurrage_analyst within w_demurrage_section_settle_stat
end type
type rb_greater from radiobutton within w_demurrage_section_settle_stat
end type
type rb_equal from radiobutton within w_demurrage_section_settle_stat
end type
type rb_less from radiobutton within w_demurrage_section_settle_stat
end type
type st_4 from statictext within w_demurrage_section_settle_stat
end type
type em_year from editmask within w_demurrage_section_settle_stat
end type
type rb_days_less from radiobutton within w_demurrage_section_settle_stat
end type
type rb_days_greater from radiobutton within w_demurrage_section_settle_stat
end type
type st_10 from statictext within w_demurrage_section_settle_stat
end type
type em_days from editmask within w_demurrage_section_settle_stat
end type
type cb_saveas from commandbutton within w_demurrage_section_settle_stat
end type
type cb_sel_office from commandbutton within w_demurrage_section_settle_stat
end type
type cb_sel_broker from commandbutton within w_demurrage_section_settle_stat
end type
type cb_sel_chart from commandbutton within w_demurrage_section_settle_stat
end type
type cbx_include_office from checkbox within w_demurrage_section_settle_stat
end type
type sle_offices from singlelineedit within w_demurrage_section_settle_stat
end type
type st_9 from statictext within w_demurrage_section_settle_stat
end type
type st_8 from statictext within w_demurrage_section_settle_stat
end type
type sle_brokers from singlelineedit within w_demurrage_section_settle_stat
end type
type cbx_include_broker from checkbox within w_demurrage_section_settle_stat
end type
type cb_sel_vessel from commandbutton within w_demurrage_section_settle_stat
end type
type cbx_include_chart from checkbox within w_demurrage_section_settle_stat
end type
type cbx_include_vessel from checkbox within w_demurrage_section_settle_stat
end type
type st_7 from statictext within w_demurrage_section_settle_stat
end type
type sle_vessels from singlelineedit within w_demurrage_section_settle_stat
end type
type st_6 from statictext within w_demurrage_section_settle_stat
end type
type cb_retrieve from commandbutton within w_demurrage_section_settle_stat
end type
type cb_print from commandbutton within w_demurrage_section_settle_stat
end type
type dw_profit_center from u_datagrid within w_demurrage_section_settle_stat
end type
type dw_claims_settled from u_datagrid within w_demurrage_section_settle_stat
end type
type gb_3 from groupbox within w_demurrage_section_settle_stat
end type
type gb_2 from groupbox within w_demurrage_section_settle_stat
end type
type gb_1 from groupbox within w_demurrage_section_settle_stat
end type
type gb_4 from mt_u_groupbox within w_demurrage_section_settle_stat
end type
type gb_5 from groupbox within w_demurrage_section_settle_stat
end type
type st_3 from u_topbar_background within w_demurrage_section_settle_stat
end type
type cbx_select from mt_u_checkbox within w_demurrage_section_settle_stat
end type
type sle_charterers from multilineedit within w_demurrage_section_settle_stat
end type
end forward

global type w_demurrage_section_settle_stat from mt_w_sheet
integer width = 4599
integer height = 2560
string title = "Demurrage Settle Stat"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
event ue_userrespitemchanged ( string as_userid )
st_11 st_11
st_week st_week
st_2 st_2
st_1 st_1
em_week em_week
rb_oneweek rb_oneweek
rb_yeartoweek rb_yeartoweek
cbx_laytime_missing cbx_laytime_missing
cbx_negative_amounts cbx_negative_amounts
cbx_group_by_chart cbx_group_by_chart
uo_demurrage_analyst uo_demurrage_analyst
rb_greater rb_greater
rb_equal rb_equal
rb_less rb_less
st_4 st_4
em_year em_year
rb_days_less rb_days_less
rb_days_greater rb_days_greater
st_10 st_10
em_days em_days
cb_saveas cb_saveas
cb_sel_office cb_sel_office
cb_sel_broker cb_sel_broker
cb_sel_chart cb_sel_chart
cbx_include_office cbx_include_office
sle_offices sle_offices
st_9 st_9
st_8 st_8
sle_brokers sle_brokers
cbx_include_broker cbx_include_broker
cb_sel_vessel cb_sel_vessel
cbx_include_chart cbx_include_chart
cbx_include_vessel cbx_include_vessel
st_7 st_7
sle_vessels sle_vessels
st_6 st_6
cb_retrieve cb_retrieve
cb_print cb_print
dw_profit_center dw_profit_center
dw_claims_settled dw_claims_settled
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
st_3 st_3
cbx_select cbx_select
sle_charterers sle_charterers
end type
global w_demurrage_section_settle_stat w_demurrage_section_settle_stat

type variables
s_demurrage_stat_selection		istr_parm
string	is_vessel_filter, is_sort
string is_chart_filter, is_broker_filter, is_office_filter


end variables

forward prototypes
public subroutine of_open_actions_trans (datawindow dwo)
public subroutine wf_retrieve ()
public subroutine wf_open_laytime (datawindow adw_claims)
public subroutine wf_enabledweek ()
public subroutine documentation ()
public subroutine wf_get_pcnr (boolean ab_analysechanged)
public subroutine wf_cbxselect_setcheck (boolean ab_checked)
public subroutine wf_cbxselect_setcheck (boolean ab_checked, boolean ab_click)
public subroutine wf_setbuttonstatus ()
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
	wf_get_pcnr(true)
	setfocus(em_year)
end if
end event

public subroutine of_open_actions_trans (datawindow dwo);u_jump_actions_trans luo_jump_actions_trans
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

long		ll_row, ll_rows, ll_year, ll_week
string	ls_filter, ls_operator
string ls_pcnrstr, ls_vesselstr, ls_vesselinclude, ls_chartstr, ls_chartinclude, ls_brokerstr, ls_brokerinclude
string ls_officestr, ls_officeinclude, ls_yearop, ls_weekop, ls_daysop
int li_negativeamounts, li_laytimemissing, li_yearnum, li_weeknum, li_daysnum 


dw_claims_settled.setredraw(false)
setPointer(hourglass!)

if upperbound(istr_parm.profitcenter) = 0 then 
	dw_claims_settled.reset()
	dw_claims_settled.setredraw(true)
	return
end if

/* Profit Center */
ls_pcnrstr = ''
FOR ll_row=1 TO upperbound(istr_parm.profitcenter)
	if len(ls_pcnrstr)  > 0 then ls_pcnrstr = ls_pcnrstr + ', '
	ls_pcnrstr = ls_pcnrstr + string(istr_parm.profitcenter[ll_row])
NEXT

/* Year - Voyage Number */
if (len(em_year.text) > 0) then
	li_yearnum = integer(em_year.text)
else
	li_yearnum = 0
end if
if rb_less.checked = true then
	ls_yearop = 'less'
elseif rb_equal.checked = true then
	ls_yearop = 'equal'
else
	ls_yearop = 'greater'
end if

if len(em_week.text) > 0 then
	li_weeknum = integer(em_week.text)
else
	li_weeknum = 0
end if
if rb_oneweek.checked then
	ls_weekop = 'oneweek'
else
	ls_weekop = 'yearweek'
end if
/* Outstanding Days */
if (len(em_days.text) > 0) then
	li_daysnum = integer(em_days.text)
else
	li_daysnum = 0
end if
if rb_days_greater.checked = true then
		ls_daysop = "greater"
else
	ls_daysop = "less"
end if
/* show laytime missing voyages */
if cbx_laytime_missing.checked then
	li_laytimemissing = 1
else
	li_laytimemissing = 0
end if

/* show negative amount */
if not cbx_negative_amounts.checked then
	li_negativeamounts = 1
else
	li_negativeamounts = 0
end if

if cbx_include_vessel.checked then
	ls_vesselinclude = "yes"
else
	ls_vesselinclude = "no"
end if

if cbx_include_chart.checked then
	ls_chartinclude = "yes"
else
	ls_chartinclude = "no"
end if		

if cbx_include_broker.checked then
	ls_brokerinclude = "yes"
else
	ls_brokerinclude = "no"
end if		

if cbx_include_office.checked then
	ls_officeinclude = "yes"
else
	ls_officeinclude = "no"
end if		


SQLCA.autocommit = true
dw_claims_settled.retrieve(ls_pcnrstr, li_negativeamounts, li_laytimemissing, li_yearnum, ls_yearop, li_weeknum, ls_weekop, li_daysnum, ls_daysop,is_vessel_filter, ls_vesselinclude, is_chart_filter, ls_chartinclude, is_broker_filter, ls_brokerinclude, is_office_filter, ls_officeinclude)
SQLCA.autocommit = false	

dw_claims_settled.setredraw(true)
setPointer(arrow!)
wf_setbuttonstatus()

end subroutine

public subroutine wf_open_laytime (datawindow adw_claims);/********************************************************************
   wf_open_laytime
   <DESC> Open laytime window </DESC>
   <RETURN>	(None):
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_claims
   </ARGS>
   <USAGE> Open the laytime window when double-clicking dw_claims_settled datawindow </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	03/08/2011   2411         ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_voyage_nr
long		ll_vessel_nr, ll_row, ll_chart_nr, ll_claim_nr

u_jump_laytime		lnv_jump_laytime

ll_row = adw_claims.getrow()
if ll_row <= 0 then return

ll_vessel_nr = adw_claims.getitemnumber(ll_row, "claims_vessel_nr")
ls_voyage_nr = adw_claims.getitemstring(ll_row, "claims_voyage_nr")
ll_chart_nr  = adw_claims.getitemnumber(ll_row, "claims_chart_nr")
ll_claim_nr  = adw_claims.getitemnumber(ll_row, "claims_claim_nr")

lnv_jump_laytime.of_open_laytime(ll_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)				//Jump to the laytime window

end subroutine

public subroutine wf_enabledweek ();/********************************************************************
   wf_enabledweek
   <DESC> Enabled or disabled the Select Week group box </DESC>
   <RETURN>	(None):
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> Enabled or disabled the Select Week group box when changing the criteria of the voyage year selection </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	04/08/2011   2411         ZSW001       First Version
   </HISTORY>
********************************************************************/

st_week.enabled       = rb_equal.checked
rb_oneweek.enabled    = rb_equal.checked
rb_yeartoweek.enabled = rb_equal.checked
em_week.enabled       = rb_equal.checked

end subroutine

public subroutine documentation ();/********************************************************************
   w_demurrage_section_settle_stat
   <OBJECT>	Demurrage Settle Stat window	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date   		Ref    	Author   		Comments
		05/08/11  	CR2411	ZSW001			Add wf_open_laytime function
		06/08/11  	CR2411	ZSW001			Move part of the code in the wf_open_laytime function to the u_jump_laytime object
		07/08/11    CR2411   LGX001         Function & UI Changes
		29/08/14		CR3781	CCY018			The window title match with the text of a menu item
		01/08/16		CR4111	XSZ004			Add validation for laytime missing.
		13/10/16		CR4533	XSZ004			Change logic for laytime missed checkbox.
		14/10/16		CR4531	XSZ004			Optimizes performance this report.
		24/11/17		CR4651	EPE080			Add profit center select all/deselect all checbox,remove refresh seach.
   </HISTORY>
********************************************************************/

end subroutine

public subroutine wf_get_pcnr (boolean ab_analysechanged);/********************************************************************
   wf_get_pcnr
   <DESC></DESC>
   <RETURN>  </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		ab_analysechanged
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
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

public subroutine wf_setbuttonstatus ();/********************************************************************
   wf_setbuttonstatus
   <DESC>set enabled status of buttons</DESC>
   <RETURN> string </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		ab_analysechanged
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		25/11/17		CR4651		EPE080		First version
   </HISTORY>
********************************************************************/

if dw_claims_settled.rowcount() > 0 then
	cb_print.enabled  = true
	cb_saveas.enabled = true
else
	cb_print.enabled  = false
	cb_saveas.enabled = false
end if
end subroutine

on w_demurrage_section_settle_stat.create
int iCurrent
call super::create
this.st_11=create st_11
this.st_week=create st_week
this.st_2=create st_2
this.st_1=create st_1
this.em_week=create em_week
this.rb_oneweek=create rb_oneweek
this.rb_yeartoweek=create rb_yeartoweek
this.cbx_laytime_missing=create cbx_laytime_missing
this.cbx_negative_amounts=create cbx_negative_amounts
this.cbx_group_by_chart=create cbx_group_by_chart
this.uo_demurrage_analyst=create uo_demurrage_analyst
this.rb_greater=create rb_greater
this.rb_equal=create rb_equal
this.rb_less=create rb_less
this.st_4=create st_4
this.em_year=create em_year
this.rb_days_less=create rb_days_less
this.rb_days_greater=create rb_days_greater
this.st_10=create st_10
this.em_days=create em_days
this.cb_saveas=create cb_saveas
this.cb_sel_office=create cb_sel_office
this.cb_sel_broker=create cb_sel_broker
this.cb_sel_chart=create cb_sel_chart
this.cbx_include_office=create cbx_include_office
this.sle_offices=create sle_offices
this.st_9=create st_9
this.st_8=create st_8
this.sle_brokers=create sle_brokers
this.cbx_include_broker=create cbx_include_broker
this.cb_sel_vessel=create cb_sel_vessel
this.cbx_include_chart=create cbx_include_chart
this.cbx_include_vessel=create cbx_include_vessel
this.st_7=create st_7
this.sle_vessels=create sle_vessels
this.st_6=create st_6
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.dw_profit_center=create dw_profit_center
this.dw_claims_settled=create dw_claims_settled
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
this.st_3=create st_3
this.cbx_select=create cbx_select
this.sle_charterers=create sle_charterers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_11
this.Control[iCurrent+2]=this.st_week
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_week
this.Control[iCurrent+6]=this.rb_oneweek
this.Control[iCurrent+7]=this.rb_yeartoweek
this.Control[iCurrent+8]=this.cbx_laytime_missing
this.Control[iCurrent+9]=this.cbx_negative_amounts
this.Control[iCurrent+10]=this.cbx_group_by_chart
this.Control[iCurrent+11]=this.uo_demurrage_analyst
this.Control[iCurrent+12]=this.rb_greater
this.Control[iCurrent+13]=this.rb_equal
this.Control[iCurrent+14]=this.rb_less
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.em_year
this.Control[iCurrent+17]=this.rb_days_less
this.Control[iCurrent+18]=this.rb_days_greater
this.Control[iCurrent+19]=this.st_10
this.Control[iCurrent+20]=this.em_days
this.Control[iCurrent+21]=this.cb_saveas
this.Control[iCurrent+22]=this.cb_sel_office
this.Control[iCurrent+23]=this.cb_sel_broker
this.Control[iCurrent+24]=this.cb_sel_chart
this.Control[iCurrent+25]=this.cbx_include_office
this.Control[iCurrent+26]=this.sle_offices
this.Control[iCurrent+27]=this.st_9
this.Control[iCurrent+28]=this.st_8
this.Control[iCurrent+29]=this.sle_brokers
this.Control[iCurrent+30]=this.cbx_include_broker
this.Control[iCurrent+31]=this.cb_sel_vessel
this.Control[iCurrent+32]=this.cbx_include_chart
this.Control[iCurrent+33]=this.cbx_include_vessel
this.Control[iCurrent+34]=this.st_7
this.Control[iCurrent+35]=this.sle_vessels
this.Control[iCurrent+36]=this.st_6
this.Control[iCurrent+37]=this.cb_retrieve
this.Control[iCurrent+38]=this.cb_print
this.Control[iCurrent+39]=this.dw_profit_center
this.Control[iCurrent+40]=this.dw_claims_settled
this.Control[iCurrent+41]=this.gb_3
this.Control[iCurrent+42]=this.gb_2
this.Control[iCurrent+43]=this.gb_1
this.Control[iCurrent+44]=this.gb_4
this.Control[iCurrent+45]=this.gb_5
this.Control[iCurrent+46]=this.st_3
this.Control[iCurrent+47]=this.cbx_select
this.Control[iCurrent+48]=this.sle_charterers
end on

on w_demurrage_section_settle_stat.destroy
call super::destroy
destroy(this.st_11)
destroy(this.st_week)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_week)
destroy(this.rb_oneweek)
destroy(this.rb_yeartoweek)
destroy(this.cbx_laytime_missing)
destroy(this.cbx_negative_amounts)
destroy(this.cbx_group_by_chart)
destroy(this.uo_demurrage_analyst)
destroy(this.rb_greater)
destroy(this.rb_equal)
destroy(this.rb_less)
destroy(this.st_4)
destroy(this.em_year)
destroy(this.rb_days_less)
destroy(this.rb_days_greater)
destroy(this.st_10)
destroy(this.em_days)
destroy(this.cb_saveas)
destroy(this.cb_sel_office)
destroy(this.cb_sel_broker)
destroy(this.cb_sel_chart)
destroy(this.cbx_include_office)
destroy(this.sle_offices)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.sle_brokers)
destroy(this.cbx_include_broker)
destroy(this.cb_sel_vessel)
destroy(this.cbx_include_chart)
destroy(this.cbx_include_vessel)
destroy(this.st_7)
destroy(this.sle_vessels)
destroy(this.st_6)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.dw_profit_center)
destroy(this.dw_claims_settled)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.st_3)
destroy(this.cbx_select)
destroy(this.sle_charterers)
end on

event open;call super::open;long		ll_week
datetime ld_date
cbx_select.backcolor = 22497827

//CR2411 Begin added by ZSW001 on 04/08/2011
em_year.text = string(year(today()))

SELECT TOP 1 DATEPART(CWK, GETDATE()) INTO :ll_week FROM POC;
em_week.text = string(ll_week)
//CR2411 End added by ZSW001 on 04/08/2011

dw_claims_settled.settransobject(SQLCA)

dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve( uo_global.is_userid )

dw_claims_settled.setrowfocusindicator(FOCUSRECT!)


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_demurrage_section_settle_stat
end type

type st_11 from statictext within w_demurrage_section_settle_stat
integer x = 1006
integer y = 320
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Settle - Forwarding Date"
boolean focusrectangle = false
end type

type st_week from statictext within w_demurrage_section_settle_stat
integer x = 1006
integer y = 240
integer width = 174
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Week #"
boolean focusrectangle = false
end type

type st_2 from statictext within w_demurrage_section_settle_stat
integer x = 1006
integer y = 160
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Voyage Year"
boolean focusrectangle = false
end type

type st_1 from statictext within w_demurrage_section_settle_stat
integer x = 1006
integer y = 80
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Demurrage Analyst"
boolean focusrectangle = false
end type

type em_week from editmask within w_demurrage_section_settle_stat
integer x = 1211
integer y = 240
integer width = 183
integer height = 56
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean border = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
double increment = 1
string minmax = "1~~53"
end type

type rb_oneweek from radiobutton within w_demurrage_section_settle_stat
integer x = 1504
integer y = 240
integer width = 311
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "One Week"
boolean checked = true
end type

type rb_yeartoweek from radiobutton within w_demurrage_section_settle_stat
integer x = 1883
integer y = 240
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Year to Week"
end type

type cbx_laytime_missing from checkbox within w_demurrage_section_settle_stat
integer x = 2167
integer y = 452
integer width = 439
integer height = 56
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Laytime Missing"
end type

type cbx_negative_amounts from checkbox within w_demurrage_section_settle_stat
integer x = 1531
integer y = 452
integer width = 622
integer height = 56
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Show Negative Amounts"
end type

type cbx_group_by_chart from checkbox within w_demurrage_section_settle_stat
integer x = 1006
integer y = 452
integer width = 530
integer height = 56
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Group by Charterer"
end type

event clicked;//CR2411 Begin added by ZSW001 on 03/08/2011

if this.checked then
	dw_claims_settled.setredraw(false)
	
	dw_claims_settled.modify("chart.x = '9' chart_chart_n_1.x = '9' t_2.x = '750' vessels_vessel_ref_nr.x = '750' claims_vessel_nr.x = '750' claims_vessel_nr_t.x = '855' vessels_vessel_name.x = '855' claims_voyage_nr_t.x = '1573' claims_voyage_nr.x = '1573'")
	dw_claims_settled.modify("chart_chart_n_1.visible = '1~tif(chart_chart_n_1 = chart_chart_n_1[-1], 0, 1)'")
	
	dw_claims_settled.setsort("chart_chart_n_1 A, vessels_vessel_ref_nr A, compute_voyage_sort A")		//Order by chart_chart_n_1, vessels_vessel_ref_nr and compute_voyage_sort
	dw_claims_settled.sort()
	
	is_sort = "chart_chart_n_1 D"
	dw_claims_settled.modify("chart.tag = '" + is_sort + "'")
	
	dw_claims_settled.setredraw(true)
else
	dw_claims_settled.modify("t_2.x = '9' vessels_vessel_ref_nr.x = '5' claims_vessel_nr.x = '5' claims_vessel_nr_t.x = '114' vessels_vessel_name.x = '119' claims_voyage_nr_t.x = '832' claims_voyage_nr.x = '832' chart.x = '987' chart_chart_n_1.x = '987'")
	dw_claims_settled.modify("chart_chart_n_1.visible = '1'")
end if

//CR2411 End added by ZSW001 on 03/08/2011

end event

type uo_demurrage_analyst from u_demurrage_analyst within w_demurrage_section_settle_stat
integer x = 1445
integer y = 80
integer height = 56
integer taborder = 30
end type

on uo_demurrage_analyst.destroy
call u_demurrage_analyst::destroy
end on

type rb_greater from radiobutton within w_demurrage_section_settle_stat
integer x = 1646
integer y = 160
integer width = 146
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
end type

event clicked;wf_enabledweek()


end event

type rb_equal from radiobutton within w_demurrage_section_settle_stat
integer x = 1504
integer y = 160
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "="
boolean checked = true
end type

event clicked;wf_enabledweek()



end event

type rb_less from radiobutton within w_demurrage_section_settle_stat
integer x = 1321
integer y = 160
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "<="
end type

event clicked;wf_enabledweek()


end event

type st_4 from statictext within w_demurrage_section_settle_stat
integer x = 2112
integer y = 160
integer width = 155
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "(yyyy)"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_demurrage_section_settle_stat
integer x = 1865
integer y = 160
integer width = 238
integer height = 56
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean border = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1995~~2050"
end type

type rb_days_less from radiobutton within w_demurrage_section_settle_stat
integer x = 1778
integer y = 320
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "<"
end type

type rb_days_greater from radiobutton within w_demurrage_section_settle_stat
integer x = 1591
integer y = 320
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ">="
boolean checked = true
end type

type st_10 from statictext within w_demurrage_section_settle_stat
integer x = 2149
integer y = 320
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "days"
boolean focusrectangle = false
end type

type em_days from editmask within w_demurrage_section_settle_stat
integer x = 1975
integer y = 320
integer width = 146
integer height = 56
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "45"
boolean border = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
string minmax = "0~~9999"
end type

type cb_saveas from commandbutton within w_demurrage_section_settle_stat
integer x = 3863
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 230
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;dw_claims_settled.saveas("", XML!, true)

end event

type cb_sel_office from commandbutton within w_demurrage_section_settle_stat
integer x = 4453
integer y = 312
integer width = 73
integer height = 64
integer taborder = 200
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

sle_offices.text= is_office_filter

end event

type cb_sel_broker from commandbutton within w_demurrage_section_settle_stat
integer x = 4453
integer y = 232
integer width = 73
integer height = 64
integer taborder = 190
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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
		is_broker_filter = string(istr_parm.broker_nr[li_x])
	else
		is_broker_filter += ", " + string(istr_parm.broker_nr[li_x])
	end if
Next
sle_brokers.text = is_broker_filter


end event

type cb_sel_chart from commandbutton within w_demurrage_section_settle_stat
integer x = 4453
integer y = 152
integer width = 73
integer height = 64
integer taborder = 180
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

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

type cbx_include_office from checkbox within w_demurrage_section_settle_stat
integer x = 2606
integer y = 320
integer width = 238
integer height = 56
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type sle_offices from singlelineedit within w_demurrage_section_settle_stat
integer x = 2862
integer y = 320
integer width = 1573
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_demurrage_section_settle_stat
integer x = 2331
integer y = 320
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Offices"
boolean focusrectangle = false
end type

type st_8 from statictext within w_demurrage_section_settle_stat
integer x = 2331
integer y = 240
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Brokers"
boolean focusrectangle = false
end type

type sle_brokers from singlelineedit within w_demurrage_section_settle_stat
integer x = 2862
integer y = 240
integer width = 1573
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_include_broker from checkbox within w_demurrage_section_settle_stat
integer x = 2606
integer y = 240
integer width = 238
integer height = 56
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type cb_sel_vessel from commandbutton within w_demurrage_section_settle_stat
integer x = 4453
integer y = 72
integer width = 73
integer height = 64
integer taborder = 170
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type cbx_include_chart from checkbox within w_demurrage_section_settle_stat
integer x = 2606
integer y = 160
integer width = 238
integer height = 56
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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
this.textcolor =  c#color.white

end event

type cbx_include_vessel from checkbox within w_demurrage_section_settle_stat
integer x = 2606
integer y = 80
integer width = 242
integer height = 56
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type st_7 from statictext within w_demurrage_section_settle_stat
integer x = 2331
integer y = 160
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Charterers"
boolean focusrectangle = false
end type

type sle_vessels from singlelineedit within w_demurrage_section_settle_stat
integer x = 2862
integer y = 80
integer width = 1573
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_demurrage_section_settle_stat
integer x = 2331
integer y = 80
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Vessels"
boolean focusrectangle = false
end type

type cb_retrieve from commandbutton within w_demurrage_section_settle_stat
integer x = 3515
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 220
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Retrieve"
end type

event clicked;
wf_retrieve()



end event

type cb_print from commandbutton within w_demurrage_section_settle_stat
integer x = 4210
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;dw_claims_settled.setredraw(false)
dw_claims_settled.Object.DataWindow.Print.orientation = 1
dw_claims_settled.Modify("DataWindow.Zoom = 91")
dw_claims_settled.print()
dw_claims_settled.Modify("DataWindow.Zoom = 100")
dw_claims_settled.setredraw(true)

end event

type dw_profit_center from u_datagrid within w_demurrage_section_settle_stat
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
boolean ib_multiselect = true
end type

event clicked;call super::clicked;wf_cbxselect_setcheck(false)
wf_get_pcnr(false)

end event

type dw_claims_settled from u_datagrid within w_demurrage_section_settle_stat
integer x = 37
integer y = 624
integer width = 4517
integer height = 1696
integer taborder = 210
string dataobject = "d_dem_claims_settled"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;string ls_sort

if (Row > 0) And (row <> GetSelectedRow(row - 1)) then
	selectrow(0, false)
	setrow(row)
	selectrow(row, true)
end if

if dwo.type = "text" then
	ls_sort = dwo.Tag
	if len(ls_sort) > 1 then
		//CR2411 Begin added by ZSW001 on 03/08/2011
		if cbx_group_by_chart.checked then
			choose case ls_sort
				case "chart_chart_n_1 A", "chart_chart_n_1 D"
					is_sort = ls_sort
					this.setsort(is_sort)
				case else
					this.setsort(is_sort + "," + ls_sort)
			end choose
		else
			this.setsort(ls_sort)
		end if
		//CR2411 End added by ZSW001 on 03/08/2011
		
		this.sort()
		
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		
		dwo.Tag = ls_sort
	end if
end if

end event

event doubleclicked;if row <= 0 then return

//CR2411 Begin added by ZSW001 on 03/08/2011
if cbx_laytime_missing.checked then
	wf_open_laytime(dw_claims_settled)
else
	of_open_actions_trans(dw_claims_settled)
end if
//CR2411 End added by ZSW001 on 03/08/2011

end event

type gb_3 from groupbox within w_demurrage_section_settle_stat
boolean visible = false
integer x = 1559
integer y = 288
integer width = 366
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
end type

type gb_2 from groupbox within w_demurrage_section_settle_stat
boolean visible = false
integer x = 1298
integer y = 128
integer width = 530
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
end type

type gb_1 from groupbox within w_demurrage_section_settle_stat
boolean visible = false
integer x = 1426
integer y = 208
integer width = 841
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
end type

type gb_4 from mt_u_groupbox within w_demurrage_section_settle_stat
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

type gb_5 from groupbox within w_demurrage_section_settle_stat
integer x = 2295
integer y = 16
integer width = 2258
integer height = 400
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
end type

type st_3 from u_topbar_background within w_demurrage_section_settle_stat
integer width = 5851
integer height = 592
end type

type cbx_select from mt_u_checkbox within w_demurrage_section_settle_stat
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

type sle_charterers from multilineedit within w_demurrage_section_settle_stat
integer x = 2862
integer y = 160
integer width = 1573
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
end type

