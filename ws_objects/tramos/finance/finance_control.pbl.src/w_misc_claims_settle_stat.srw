$PBExportHeader$w_misc_claims_settle_stat.srw
$PBExportComments$This window is used by demurrage section. Receivable statistics
forward
global type w_misc_claims_settle_stat from mt_w_sheet
end type
type cbx_select from mt_u_checkbox within w_misc_claims_settle_stat
end type
type st_5 from mt_u_statictext within w_misc_claims_settle_stat
end type
type st_3 from mt_u_statictext within w_misc_claims_settle_stat
end type
type uo_claims_analyst from u_claims_analyst within w_misc_claims_settle_stat
end type
type st_1 from mt_u_statictext within w_misc_claims_settle_stat
end type
type em_days from editmask within w_misc_claims_settle_stat
end type
type st_10 from statictext within w_misc_claims_settle_stat
end type
type rb_days_greater from radiobutton within w_misc_claims_settle_stat
end type
type rb_days_less from radiobutton within w_misc_claims_settle_stat
end type
type em_year from editmask within w_misc_claims_settle_stat
end type
type st_4 from statictext within w_misc_claims_settle_stat
end type
type cb_sel_claimtype from commandbutton within w_misc_claims_settle_stat
end type
type sle_claimtypes from singlelineedit within w_misc_claims_settle_stat
end type
type cbx_include_claimtype from checkbox within w_misc_claims_settle_stat
end type
type st_11 from statictext within w_misc_claims_settle_stat
end type
type cb_saveas from commandbutton within w_misc_claims_settle_stat
end type
type cb_sel_office from commandbutton within w_misc_claims_settle_stat
end type
type cb_sel_broker from commandbutton within w_misc_claims_settle_stat
end type
type cb_sel_chart from commandbutton within w_misc_claims_settle_stat
end type
type cbx_include_office from checkbox within w_misc_claims_settle_stat
end type
type sle_offices from singlelineedit within w_misc_claims_settle_stat
end type
type st_9 from statictext within w_misc_claims_settle_stat
end type
type st_8 from statictext within w_misc_claims_settle_stat
end type
type sle_brokers from singlelineedit within w_misc_claims_settle_stat
end type
type cbx_include_broker from checkbox within w_misc_claims_settle_stat
end type
type cb_sel_vessel from commandbutton within w_misc_claims_settle_stat
end type
type cbx_include_chart from checkbox within w_misc_claims_settle_stat
end type
type cbx_include_vessel from checkbox within w_misc_claims_settle_stat
end type
type sle_charterers from singlelineedit within w_misc_claims_settle_stat
end type
type st_7 from statictext within w_misc_claims_settle_stat
end type
type sle_vessels from singlelineedit within w_misc_claims_settle_stat
end type
type st_6 from statictext within w_misc_claims_settle_stat
end type
type cb_retrieve from commandbutton within w_misc_claims_settle_stat
end type
type cb_print from commandbutton within w_misc_claims_settle_stat
end type
type dw_profit_center from u_datagrid within w_misc_claims_settle_stat
end type
type dw_claims_settled from mt_u_datawindow within w_misc_claims_settle_stat
end type
type gb_2 from groupbox within w_misc_claims_settle_stat
end type
type gb_1 from mt_u_groupbox within w_misc_claims_settle_stat
end type
type gb_4 from mt_u_groupbox within w_misc_claims_settle_stat
end type
type rb_less from radiobutton within w_misc_claims_settle_stat
end type
type rb_equal from radiobutton within w_misc_claims_settle_stat
end type
type rb_greater from radiobutton within w_misc_claims_settle_stat
end type
type gb_3 from groupbox within w_misc_claims_settle_stat
end type
type st_2 from u_topbar_background within w_misc_claims_settle_stat
end type
end forward

global type w_misc_claims_settle_stat from mt_w_sheet
integer width = 4608
integer height = 2568
string title = "Miscellaneous Claims Settle Stat"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
cbx_select cbx_select
st_5 st_5
st_3 st_3
uo_claims_analyst uo_claims_analyst
st_1 st_1
em_days em_days
st_10 st_10
rb_days_greater rb_days_greater
rb_days_less rb_days_less
em_year em_year
st_4 st_4
cb_sel_claimtype cb_sel_claimtype
sle_claimtypes sle_claimtypes
cbx_include_claimtype cbx_include_claimtype
st_11 st_11
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
sle_charterers sle_charterers
st_7 st_7
sle_vessels sle_vessels
st_6 st_6
cb_retrieve cb_retrieve
cb_print cb_print
dw_profit_center dw_profit_center
dw_claims_settled dw_claims_settled
gb_2 gb_2
gb_1 gb_1
gb_4 gb_4
rb_less rb_less
rb_equal rb_equal
rb_greater rb_greater
gb_3 gb_3
st_2 st_2
end type
global w_misc_claims_settle_stat w_misc_claims_settle_stat

type variables
s_demurrage_stat_selection		istr_parm
string	is_vessel_filter
end variables

forward prototypes
public subroutine of_open_actions_trans (datawindow dwo)
public subroutine wf_open_specialclaims ()
public subroutine wf_get_pcnr (boolean ab_analysechanged)
public subroutine wf_retrieve ()
public subroutine documentation ()
end prototypes

public subroutine of_open_actions_trans (datawindow dwo);u_jump_actions_trans luo_jump_actions_trans
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

public subroutine wf_open_specialclaims ();/********************************************************************
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
   	13/06/16		CR4034            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_special_claim_id, ll_row
n_jump_specialclaims lno_jump_specialclaims

lno_jump_specialclaims = create n_jump_specialclaims

ll_row = dw_claims_settled.getrow()
if ll_row > 0 then
	ll_special_claim_id	 = dw_claims_settled.getitemnumber(ll_row, "claims_claim_nr")
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

public subroutine wf_retrieve ();string ls_filter, ls_operator, ls_analyst

dw_claims_settled.setredraw(false)
dw_claims_settled.reset()
dw_claims_settled.retrieve(istr_parm.profitcenter)

/* Year - Voyage Number */
if (len(em_year.text) > 0) then
	if rb_less.checked = true then
		ls_operator = "<="
	elseif rb_equal.checked = true then
		ls_operator = "="
	else
		ls_operator = ">="
	end if
	
	if (len(ls_filter)=0) then
		ls_filter += "left(compute_voyage_sort , 4 ) " + ls_operator + " '" + string(em_year.text) +"'"
	else
		ls_filter += " and "
		ls_filter += " left(compute_voyage_sort , 4 ) " + ls_operator +  " '" + string(em_year.text) +"'"
	end if
end if

/* Outstanding Days */
if (len(em_days.text) > 0) then
	if rb_days_greater.checked = true then
		ls_operator = ">="
	else
		ls_operator = "<"
	end if

	if (len(ls_filter)=0) then
		ls_filter += " outstanding_days " + ls_operator + string(em_days.text) 
	else 
		ls_filter += " and "
		ls_filter += " outstanding_days " + ls_operator + string(em_days.text)
	end if
end if

/* Vessel Number */
if (len(sle_vessels.text) > 0) then
	if cbx_include_vessel.checked then
		if (len(ls_filter)=0) then
			ls_filter += " claims_vessel_nr in ( " + string(is_vessel_filter) + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_vessel_nr in ( " + string(is_vessel_filter) + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " claims_vessel_nr not in ( " + string(is_vessel_filter) + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_vessel_nr not in ( " + string(is_vessel_filter) + " )"
		end if
	end if
end if

/* Charterer Number */
if (len(sle_charterers.text) > 0) then
	if cbx_include_chart.checked then
		if (len(ls_filter)=0) then
			ls_filter += " chart_opponent_no in ( " + string(sle_charterers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " chart_opponent_no in ( " + string(sle_charterers.text) + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " chart_opponent_no not in ( " + string(sle_charterers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " chart_opponent_no not in ( " + string(sle_charterers.text) + " )"
		end if
	end if		
end if

/* Broker Number */
if (len(sle_brokers.text) > 0) then
	if cbx_include_broker.checked then
		if (len(ls_filter)=0) then
			ls_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
		end if
	end if		
end if

/* Office Number */
if (len(sle_offices.text) > 0) then
	if cbx_include_office.checked then
		if (len(ls_filter)=0) then
			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		end if
	end if		
end if

/* Claim Type */
if (len(sle_claimtypes.text) > 0) then
	if cbx_include_claimtype.checked then
		if (len(ls_filter)=0) then
			ls_filter += " claims_claim_type in ( " + sle_claimtypes.text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_claim_type in ( " + sle_claimtypes.text + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " claims_claim_type not in ( " + sle_claimtypes.text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_claim_type not in ( " + sle_claimtypes.text + " )"
		end if
	end if		
end if

ls_analyst = uo_claims_analyst.of_get_analyst()

if ls_analyst <> "" then
	if len(ls_filter) = 0 then
		ls_filter += " claims_claim_responsible = '" + ls_analyst + "'"
	else
		ls_filter += " and claims_claim_responsible = '" + ls_analyst + "'"
	end if	
end if

dw_claims_settled.setfilter(ls_filter)
dw_claims_settled.filter()

if dw_claims_settled.getselectedrow(0) < 1 then 
	dw_claims_settled.selectrow(0, false)
	dw_claims_settled.selectrow(1, true)
end if

if dw_claims_settled.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled  = true
else
	cb_saveas.enabled = false
	cb_print.enabled  = false	
end if

dw_claims_settled.setredraw(true)

end subroutine

public subroutine documentation ();/********************************************************************
   w_misc_claims_settle_stat
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author         Comments
   	07-02-17	  CR2679UAT2   XSZ004			Add retrive button and remove auto function.
   </HISTORY>
********************************************************************/
end subroutine

on w_misc_claims_settle_stat.create
int iCurrent
call super::create
this.cbx_select=create cbx_select
this.st_5=create st_5
this.st_3=create st_3
this.uo_claims_analyst=create uo_claims_analyst
this.st_1=create st_1
this.em_days=create em_days
this.st_10=create st_10
this.rb_days_greater=create rb_days_greater
this.rb_days_less=create rb_days_less
this.em_year=create em_year
this.st_4=create st_4
this.cb_sel_claimtype=create cb_sel_claimtype
this.sle_claimtypes=create sle_claimtypes
this.cbx_include_claimtype=create cbx_include_claimtype
this.st_11=create st_11
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
this.sle_charterers=create sle_charterers
this.st_7=create st_7
this.sle_vessels=create sle_vessels
this.st_6=create st_6
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.dw_profit_center=create dw_profit_center
this.dw_claims_settled=create dw_claims_settled
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
this.rb_less=create rb_less
this.rb_equal=create rb_equal
this.rb_greater=create rb_greater
this.gb_3=create gb_3
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_select
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_claims_analyst
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_days
this.Control[iCurrent+7]=this.st_10
this.Control[iCurrent+8]=this.rb_days_greater
this.Control[iCurrent+9]=this.rb_days_less
this.Control[iCurrent+10]=this.em_year
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.cb_sel_claimtype
this.Control[iCurrent+13]=this.sle_claimtypes
this.Control[iCurrent+14]=this.cbx_include_claimtype
this.Control[iCurrent+15]=this.st_11
this.Control[iCurrent+16]=this.cb_saveas
this.Control[iCurrent+17]=this.cb_sel_office
this.Control[iCurrent+18]=this.cb_sel_broker
this.Control[iCurrent+19]=this.cb_sel_chart
this.Control[iCurrent+20]=this.cbx_include_office
this.Control[iCurrent+21]=this.sle_offices
this.Control[iCurrent+22]=this.st_9
this.Control[iCurrent+23]=this.st_8
this.Control[iCurrent+24]=this.sle_brokers
this.Control[iCurrent+25]=this.cbx_include_broker
this.Control[iCurrent+26]=this.cb_sel_vessel
this.Control[iCurrent+27]=this.cbx_include_chart
this.Control[iCurrent+28]=this.cbx_include_vessel
this.Control[iCurrent+29]=this.sle_charterers
this.Control[iCurrent+30]=this.st_7
this.Control[iCurrent+31]=this.sle_vessels
this.Control[iCurrent+32]=this.st_6
this.Control[iCurrent+33]=this.cb_retrieve
this.Control[iCurrent+34]=this.cb_print
this.Control[iCurrent+35]=this.dw_profit_center
this.Control[iCurrent+36]=this.dw_claims_settled
this.Control[iCurrent+37]=this.gb_2
this.Control[iCurrent+38]=this.gb_1
this.Control[iCurrent+39]=this.gb_4
this.Control[iCurrent+40]=this.rb_less
this.Control[iCurrent+41]=this.rb_equal
this.Control[iCurrent+42]=this.rb_greater
this.Control[iCurrent+43]=this.gb_3
this.Control[iCurrent+44]=this.st_2
end on

on w_misc_claims_settle_stat.destroy
call super::destroy
destroy(this.cbx_select)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.uo_claims_analyst)
destroy(this.st_1)
destroy(this.em_days)
destroy(this.st_10)
destroy(this.rb_days_greater)
destroy(this.rb_days_less)
destroy(this.em_year)
destroy(this.st_4)
destroy(this.cb_sel_claimtype)
destroy(this.sle_claimtypes)
destroy(this.cbx_include_claimtype)
destroy(this.st_11)
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
destroy(this.sle_charterers)
destroy(this.st_7)
destroy(this.sle_vessels)
destroy(this.st_6)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.dw_profit_center)
destroy(this.dw_claims_settled)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.rb_less)
destroy(this.rb_equal)
destroy(this.rb_greater)
destroy(this.gb_3)
destroy(this.st_2)
end on

event open;move(0,0)

n_service_manager  ln_serviceMgr
n_dw_style_service ln_style

ln_serviceMgr.of_loadservice( ln_style, "n_dw_style_service")
ln_style.of_dwlistformater(dw_claims_settled, false)

dw_claims_settled.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve( uo_global.is_userid )

dw_profit_center.setrowfocusindicator(FocusRect!)
dw_claims_settled.setrowfocusindicator(FOCUSRECT!)

em_year.text = string(year(today()))


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_misc_claims_settle_stat
integer y = 8
integer width = 631
integer height = 68
end type

type cbx_select from mt_u_checkbox within w_misc_claims_settle_stat
integer x = 617
integer y = 8
integer width = 315
integer height = 72
integer taborder = 10
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;if this.checked then
	this.text = "Deselect all"
	dw_profit_center.selectrow(0, true)
else
	this.text = "Select all"
	dw_profit_center.selectrow(0, false)
end if

this.textcolor = c#color.White

wf_get_pcnr(false)
end event

type st_5 from mt_u_statictext within w_misc_claims_settle_stat
integer x = 1001
integer y = 240
integer width = 544
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Settle - Forwarding date"
end type

type st_3 from mt_u_statictext within w_misc_claims_settle_stat
integer x = 997
integer y = 136
integer width = 288
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Voyage Year"
end type

type uo_claims_analyst from u_claims_analyst within w_misc_claims_settle_stat
integer x = 1335
integer y = 44
integer taborder = 30
end type

on uo_claims_analyst.destroy
call u_claims_analyst::destroy
end on

event ue_itemchanged;call super::ue_itemchanged;wf_get_pcnr(true)
end event

type st_1 from mt_u_statictext within w_misc_claims_settle_stat
integer x = 997
integer y = 52
integer width = 343
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Claims Analyst"
end type

type em_days from editmask within w_misc_claims_settle_stat
integer x = 1870
integer y = 244
integer width = 183
integer height = 56
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "45"
boolean border = false
alignment alignment = right!
string mask = "####"
string minmax = "0~~9999"
end type

event getfocus;this.post selecttext(1, len(this.text))
end event

type st_10 from statictext within w_misc_claims_settle_stat
integer x = 2071
integer y = 240
integer width = 119
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

type rb_days_greater from radiobutton within w_misc_claims_settle_stat
integer x = 1573
integer y = 236
integer width = 146
integer height = 68
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

type rb_days_less from radiobutton within w_misc_claims_settle_stat
integer x = 1728
integer y = 236
integer width = 142
integer height = 68
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

type em_year from editmask within w_misc_claims_settle_stat
integer x = 1760
integer y = 140
integer width = 261
integer height = 56
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
alignment alignment = right!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1995~~2050"
end type

event getfocus;this.post selecttext(1, len(this.text))


end event

type st_4 from statictext within w_misc_claims_settle_stat
integer x = 2025
integer y = 136
integer width = 151
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

type cb_sel_claimtype from commandbutton within w_misc_claims_settle_stat
integer x = 4453
integer y = 396
integer width = 73
integer height = 64
integer taborder = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type sle_claimtypes from singlelineedit within w_misc_claims_settle_stat
integer x = 2752
integer y = 400
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
end type

type cbx_include_claimtype from checkbox within w_misc_claims_settle_stat
integer x = 2505
integer y = 396
integer width = 242
integer height = 64
integer taborder = 170
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

type st_11 from statictext within w_misc_claims_settle_stat
integer x = 2222
integer y = 396
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Types"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_misc_claims_settle_stat
integer x = 3886
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 210
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

lnv_exp.of_export(dw_claims_settled)

end event

type cb_sel_office from commandbutton within w_misc_claims_settle_stat
integer x = 4453
integer y = 316
integer width = 73
integer height = 64
integer taborder = 160
integer textsize = -10
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_offices.text = string(istr_parm.office_nr[li_x])
	else
		sle_offices.text += ", " + string(istr_parm.office_nr[li_x])
	end if
Next
end event

type cb_sel_broker from commandbutton within w_misc_claims_settle_stat
integer x = 4453
integer y = 236
integer width = 73
integer height = 64
integer taborder = 140
integer textsize = -10
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_brokers.text = string(istr_parm.broker_nr[li_x])
	else
		sle_brokers.text += ", " + string(istr_parm.broker_nr[li_x])
	end if
Next
end event

type cb_sel_chart from commandbutton within w_misc_claims_settle_stat
integer x = 4453
integer y = 156
integer width = 73
integer height = 64
integer taborder = 110
integer textsize = -10
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_charterers.text = string(istr_parm.chart_nr[li_x])
	else
		sle_charterers.text += ", " + string(istr_parm.chart_nr[li_x])
	end if
Next
end event

type cbx_include_office from checkbox within w_misc_claims_settle_stat
integer x = 2505
integer y = 316
integer width = 242
integer height = 64
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

type sle_offices from singlelineedit within w_misc_claims_settle_stat
integer x = 2752
integer y = 320
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
end type

type st_9 from statictext within w_misc_claims_settle_stat
integer x = 2222
integer y = 320
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Offices"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_misc_claims_settle_stat
integer x = 2222
integer y = 240
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Brokers"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_brokers from singlelineedit within w_misc_claims_settle_stat
integer x = 2752
integer y = 240
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
end type

type cbx_include_broker from checkbox within w_misc_claims_settle_stat
integer x = 2505
integer y = 236
integer width = 242
integer height = 64
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

type cb_sel_vessel from commandbutton within w_misc_claims_settle_stat
integer x = 4453
integer y = 76
integer width = 73
integer height = 64
integer taborder = 90
integer textsize = -10
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

type cbx_include_chart from checkbox within w_misc_claims_settle_stat
integer x = 2505
integer y = 156
integer width = 242
integer height = 64
integer taborder = 100
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

type cbx_include_vessel from checkbox within w_misc_claims_settle_stat
integer x = 2505
integer y = 76
integer width = 242
integer height = 64
integer taborder = 80
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

type sle_charterers from singlelineedit within w_misc_claims_settle_stat
integer x = 2752
integer y = 160
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
end type

type st_7 from statictext within w_misc_claims_settle_stat
integer x = 2222
integer y = 160
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Charterers"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_vessels from singlelineedit within w_misc_claims_settle_stat
integer x = 2752
integer y = 80
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
end type

type st_6 from statictext within w_misc_claims_settle_stat
integer x = 2226
integer y = 76
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Vessels"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_retrieve from commandbutton within w_misc_claims_settle_stat
integer x = 3543
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Retrieve"
end type

event clicked;wf_retrieve()

end event

type cb_print from commandbutton within w_misc_claims_settle_stat
integer x = 4229
integer y = 2376
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
string text = "&Print"
end type

event clicked;n_dataprint lnv_print
blob lblb_data

mt_n_datastore lds_claims_settled

lds_claims_settled = create mt_n_datastore

dw_claims_settled.getfullstate(lblb_data)
lds_claims_settled.setfullstate(lblb_data)


lds_claims_settled.modify("datawindow.summary.height = 64 t_7.y=4 compute_3.y=4 " + &
"sum_claim_amount.y=4 sum_claim_rec.y=4 sum_adrcomm.y=4 rec_pct_total.y=4 "+ &
"t_9.visible = 0 t_15.visible = 0 t_16.visible = 0 t_4.visible = 0 t_13.visible = 0 " + &
"t_14.visible = 0 t_8.visible = 0 t_2.visible = 0 t_12.visible = 0 t_11.visible = 0 t_5.visible = 0 t_6.visible = 0 " + &
"t_1.visible = 0 t_10.visible = 0 t_3.visible = 0 t_19.visible = 0 t_17.visible = 0 t_18.visible = 0")

lnv_print.of_print(lds_claims_settled)

destroy lds_claims_settled

end event

type dw_profit_center from u_datagrid within w_misc_claims_settle_stat
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

event ue_lbuttonup;call super::ue_lbuttonup;if dwo.type = "column" or dwo.type = "datawindow" then
	wf_get_pcnr(false)
end if
end event

event clicked;call super::clicked;if keydown(KeySpaceBar!) and row > 0 then
	this.event ue_lbuttonup(xpos, ypos, row, dwo)
end if
end event

type dw_claims_settled from mt_u_datawindow within w_misc_claims_settle_stat
integer x = 37
integer y = 624
integer width = 4526
integer height = 1736
integer taborder = 190
string dataobject = "d_misc_claims_settled"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
end type

event doubleclicked;string ls_type

if row <= 0 then Return

ls_type = this.getitemstring(row, "claims_claim_type")
if ls_type = "SPEC" THEN
	wf_open_specialclaims()
else
	of_open_actions_trans(dw_claims_settled)
end if


end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

type gb_2 from groupbox within w_misc_claims_settle_stat
integer x = 1294
integer y = 104
integer width = 453
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
end type

type gb_1 from mt_u_groupbox within w_misc_claims_settle_stat
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

type gb_4 from mt_u_groupbox within w_misc_claims_settle_stat
integer x = 2203
integer y = 16
integer width = 2359
integer height = 480
integer weight = 400
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type rb_less from radiobutton within w_misc_claims_settle_stat
integer x = 1312
integer y = 136
integer width = 151
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "<="
end type

type rb_equal from radiobutton within w_misc_claims_settle_stat
integer x = 1467
integer y = 132
integer width = 114
integer height = 68
boolean bringtotop = true
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

type rb_greater from radiobutton within w_misc_claims_settle_stat
integer x = 1586
integer y = 132
integer width = 151
integer height = 68
boolean bringtotop = true
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

type gb_3 from groupbox within w_misc_claims_settle_stat
integer x = 1550
integer y = 208
integer width = 306
integer height = 104
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
end type

type st_2 from u_topbar_background within w_misc_claims_settle_stat
integer height = 592
end type

