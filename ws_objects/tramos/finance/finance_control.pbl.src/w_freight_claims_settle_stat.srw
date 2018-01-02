$PBExportHeader$w_freight_claims_settle_stat.srw
$PBExportComments$Shows freight receivables statistics
forward
global type w_freight_claims_settle_stat from window
end type
type st_2 from statictext within w_freight_claims_settle_stat
end type
type em_days from editmask within w_freight_claims_settle_stat
end type
type st_10 from statictext within w_freight_claims_settle_stat
end type
type rb_days_greater from radiobutton within w_freight_claims_settle_stat
end type
type rb_days_less from radiobutton within w_freight_claims_settle_stat
end type
type em_year from editmask within w_freight_claims_settle_stat
end type
type st_4 from statictext within w_freight_claims_settle_stat
end type
type rb_less from radiobutton within w_freight_claims_settle_stat
end type
type rb_equal from radiobutton within w_freight_claims_settle_stat
end type
type rb_greater from radiobutton within w_freight_claims_settle_stat
end type
type cb_saveas from commandbutton within w_freight_claims_settle_stat
end type
type cb_sel_office from commandbutton within w_freight_claims_settle_stat
end type
type cb_sel_broker from commandbutton within w_freight_claims_settle_stat
end type
type cb_sel_chart from commandbutton within w_freight_claims_settle_stat
end type
type cbx_include_office from checkbox within w_freight_claims_settle_stat
end type
type sle_offices from singlelineedit within w_freight_claims_settle_stat
end type
type st_9 from statictext within w_freight_claims_settle_stat
end type
type st_8 from statictext within w_freight_claims_settle_stat
end type
type sle_brokers from singlelineedit within w_freight_claims_settle_stat
end type
type cbx_include_broker from checkbox within w_freight_claims_settle_stat
end type
type cb_sel_vessel from commandbutton within w_freight_claims_settle_stat
end type
type cbx_include_chart from checkbox within w_freight_claims_settle_stat
end type
type cbx_include_vessel from checkbox within w_freight_claims_settle_stat
end type
type sle_charterers from singlelineedit within w_freight_claims_settle_stat
end type
type st_7 from statictext within w_freight_claims_settle_stat
end type
type sle_vessels from singlelineedit within w_freight_claims_settle_stat
end type
type st_6 from statictext within w_freight_claims_settle_stat
end type
type cb_refresh from commandbutton within w_freight_claims_settle_stat
end type
type cb_print from commandbutton within w_freight_claims_settle_stat
end type
type cb_close from commandbutton within w_freight_claims_settle_stat
end type
type st_1 from statictext within w_freight_claims_settle_stat
end type
type dw_profit_center from datawindow within w_freight_claims_settle_stat
end type
type dw_claims_settled from datawindow within w_freight_claims_settle_stat
end type
type gb_3 from groupbox within w_freight_claims_settle_stat
end type
type gb_2 from groupbox within w_freight_claims_settle_stat
end type
type ln_1 from line within w_freight_claims_settle_stat
end type
type ln_2 from line within w_freight_claims_settle_stat
end type
type ln_3 from line within w_freight_claims_settle_stat
end type
type ln_4 from line within w_freight_claims_settle_stat
end type
end forward

global type w_freight_claims_settle_stat from window
integer width = 4681
integer height = 2416
boolean titlebar = true
string title = "Freight Settle Stat"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_2 st_2
em_days em_days
st_10 st_10
rb_days_greater rb_days_greater
rb_days_less rb_days_less
em_year em_year
st_4 st_4
rb_less rb_less
rb_equal rb_equal
rb_greater rb_greater
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
cb_refresh cb_refresh
cb_print cb_print
cb_close cb_close
st_1 st_1
dw_profit_center dw_profit_center
dw_claims_settled dw_claims_settled
gb_3 gb_3
gb_2 gb_2
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_freight_claims_settle_stat w_freight_claims_settle_stat

type variables
s_demurrage_stat_selection		istr_parm
string	is_vessel_filter
end variables

forward prototypes
public subroutine of_open_actions_trans (datawindow dwo)
public subroutine of_filter ()
public subroutine documentation ()
end prototypes

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

public subroutine of_filter ();long ll_row, ll_rows
string ls_filter, ls_operator

dw_claims_settled.setredraw(false)

if upperbound(istr_parm.profitcenter) = 0 then 
	dw_claims_settled.reset()
	dw_claims_settled.setredraw(true)
	return
end if

if (dw_claims_settled.FilteredCount() = 0 and dw_claims_settled.rowcount() = 0) then
	setPointer(hourglass!)
	dw_claims_settled.retrieve()
	setPointer(arrow!)
end if

/* Profit Center */
ll_rows = dw_profit_center.rowcount()
FOR ll_row=1 TO ll_rows
	if (dw_profit_center.isselected(ll_row)) then
		if (len(ls_filter)=0) then
			ls_filter += " vessels_pc_nr = " + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
		else
			ls_filter += " or "
			ls_filter += " vessels_pc_nr = " + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
		end if
	else
		if (len(ls_filter) = 0) and ll_row = ll_rows then ls_filter += " vessels_pc_nr = 9999 "
	end if
NEXT

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
			ls_filter += " claims_chart_nr in ( " + string(sle_charterers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_chart_nr in ( " + string(sle_charterers.text) + " )"
		end if
	else
		if (len(ls_filter)=0) then
			ls_filter += " claims_chart_nr not in ( " + string(sle_charterers.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_chart_nr not in ( " + string(sle_charterers.text) + " )"
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


dw_claims_settled.setfilter(ls_filter)
dw_claims_settled.filter()

dw_claims_settled.setredraw(true)

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
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781	CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_freight_claims_settle_stat.create
this.st_2=create st_2
this.em_days=create em_days
this.st_10=create st_10
this.rb_days_greater=create rb_days_greater
this.rb_days_less=create rb_days_less
this.em_year=create em_year
this.st_4=create st_4
this.rb_less=create rb_less
this.rb_equal=create rb_equal
this.rb_greater=create rb_greater
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
this.cb_refresh=create cb_refresh
this.cb_print=create cb_print
this.cb_close=create cb_close
this.st_1=create st_1
this.dw_profit_center=create dw_profit_center
this.dw_claims_settled=create dw_claims_settled
this.gb_3=create gb_3
this.gb_2=create gb_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.Control[]={this.st_2,&
this.em_days,&
this.st_10,&
this.rb_days_greater,&
this.rb_days_less,&
this.em_year,&
this.st_4,&
this.rb_less,&
this.rb_equal,&
this.rb_greater,&
this.cb_saveas,&
this.cb_sel_office,&
this.cb_sel_broker,&
this.cb_sel_chart,&
this.cbx_include_office,&
this.sle_offices,&
this.st_9,&
this.st_8,&
this.sle_brokers,&
this.cbx_include_broker,&
this.cb_sel_vessel,&
this.cbx_include_chart,&
this.cbx_include_vessel,&
this.sle_charterers,&
this.st_7,&
this.sle_vessels,&
this.st_6,&
this.cb_refresh,&
this.cb_print,&
this.cb_close,&
this.st_1,&
this.dw_profit_center,&
this.dw_claims_settled,&
this.gb_3,&
this.gb_2,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.ln_4}
end on

on w_freight_claims_settle_stat.destroy
destroy(this.st_2)
destroy(this.em_days)
destroy(this.st_10)
destroy(this.rb_days_greater)
destroy(this.rb_days_less)
destroy(this.em_year)
destroy(this.st_4)
destroy(this.rb_less)
destroy(this.rb_equal)
destroy(this.rb_greater)
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
destroy(this.cb_refresh)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.dw_profit_center)
destroy(this.dw_claims_settled)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event open;move(0,0)

dw_claims_settled.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve( uo_global.is_userid )

dw_claims_settled.setrowfocusindicator(FOCUSRECT!)

end event

type st_2 from statictext within w_freight_claims_settle_stat
integer x = 2702
integer y = 92
integer width = 1330
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Freight Amounts are Exclusive Address Commision!"
boolean focusrectangle = false
end type

type em_days from editmask within w_freight_claims_settle_stat
integer x = 2190
integer y = 88
integer width = 155
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "7"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
string minmax = "0~~9999"
end type

event modified;of_filter()
end event

type st_10 from statictext within w_freight_claims_settle_stat
integer x = 2405
integer y = 100
integer width = 142
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "days"
boolean focusrectangle = false
end type

type rb_days_greater from radiobutton within w_freight_claims_settle_stat
integer x = 1970
integer y = 56
integer width = 183
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = ">="
boolean checked = true
end type

event clicked;of_filter( )
end event

type rb_days_less from radiobutton within w_freight_claims_settle_stat
integer x = 1970
integer y = 120
integer width = 178
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "<"
end type

event clicked;of_filter( )
end event

type em_year from editmask within w_freight_claims_settle_stat
integer x = 1074
integer y = 92
integer width = 261
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1995~~2010"
end type

event modified;of_filter()
end event

type st_4 from statictext within w_freight_claims_settle_stat
integer x = 1106
integer y = 172
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(yyyy)"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_less from radiobutton within w_freight_claims_settle_stat
integer x = 1426
integer y = 48
integer width = 215
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "<="
end type

event clicked;of_filter( )

end event

type rb_equal from radiobutton within w_freight_claims_settle_stat
integer x = 1426
integer y = 108
integer width = 215
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "="
boolean checked = true
end type

event clicked;of_filter( )

end event

type rb_greater from radiobutton within w_freight_claims_settle_stat
integer x = 1426
integer y = 168
integer width = 215
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = ">="
end type

event clicked;of_filter( )

end event

type cb_saveas from commandbutton within w_freight_claims_settle_stat
integer x = 3506
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_claims_settled.SaveAs("",XML!,true)
end event

type cb_sel_office from commandbutton within w_freight_claims_settle_stat
integer x = 4256
integer y = 604
integer width = 101
integer height = 88
integer taborder = 70
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_offices.text = string(istr_parm.office_nr[li_x])
	else
		sle_offices.text += ", " + string(istr_parm.office_nr[li_x])
	end if
Next

of_filter()
end event

type cb_sel_broker from commandbutton within w_freight_claims_settle_stat
integer x = 4256
integer y = 488
integer width = 101
integer height = 88
integer taborder = 80
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_brokers.text = string(istr_parm.broker_nr[li_x])
	else
		sle_brokers.text += ", " + string(istr_parm.broker_nr[li_x])
	end if
Next

of_filter()
end event

type cb_sel_chart from commandbutton within w_freight_claims_settle_stat
integer x = 4256
integer y = 376
integer width = 101
integer height = 88
integer taborder = 50
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
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_charterers.text = string(istr_parm.chart_nr[li_x])
	else
		sle_charterers.text += ", " + string(istr_parm.chart_nr[li_x])
	end if
Next

of_filter()
end event

type cbx_include_office from checkbox within w_freight_claims_settle_stat
integer x = 1719
integer y = 612
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

of_filter()
end event

type sle_offices from singlelineedit within w_freight_claims_settle_stat
integer x = 2043
integer y = 604
integer width = 2185
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_freight_claims_settle_stat
integer x = 777
integer y = 620
integer width = 910
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following offices:"
boolean focusrectangle = false
end type

type st_8 from statictext within w_freight_claims_settle_stat
integer x = 777
integer y = 504
integer width = 910
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following brokers:"
boolean focusrectangle = false
end type

type sle_brokers from singlelineedit within w_freight_claims_settle_stat
integer x = 2043
integer y = 488
integer width = 2185
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_include_broker from checkbox within w_freight_claims_settle_stat
integer x = 1719
integer y = 496
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

of_filter()
end event

type cb_sel_vessel from commandbutton within w_freight_claims_settle_stat
integer x = 4256
integer y = 264
integer width = 101
integer height = 88
integer taborder = 40
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

of_filter()
end event

type cbx_include_chart from checkbox within w_freight_claims_settle_stat
integer x = 1719
integer y = 384
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

of_filter()
end event

type cbx_include_vessel from checkbox within w_freight_claims_settle_stat
integer x = 1719
integer y = 272
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include"
boolean checked = true
end type

event clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

of_filter()
end event

type sle_charterers from singlelineedit within w_freight_claims_settle_stat
integer x = 2043
integer y = 376
integer width = 2185
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event modified;of_filter()
end event

type st_7 from statictext within w_freight_claims_settle_stat
integer x = 777
integer y = 392
integer width = 910
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following charterers:"
boolean focusrectangle = false
end type

type sle_vessels from singlelineedit within w_freight_claims_settle_stat
integer x = 2043
integer y = 268
integer width = 2185
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event modified;of_filter()
end event

type st_6 from statictext within w_freight_claims_settle_stat
integer x = 777
integer y = 280
integer width = 841
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following vessels:"
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_freight_claims_settle_stat
integer x = 3131
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;dw_claims_settled.setredraw(false)

dw_claims_settled.retrieve()

of_filter()

dw_claims_settled.setredraw(true)

end event

type cb_print from commandbutton within w_freight_claims_settle_stat
integer x = 3881
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_claims_settled.Object.DataWindow.Print.orientation = 1
dw_claims_settled.print()
end event

type cb_close from commandbutton within w_freight_claims_settle_stat
integer x = 4256
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_freight_claims_settle_stat
integer x = 46
integer y = 32
integer width = 635
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit Center Selection"
boolean focusrectangle = false
end type

type dw_profit_center from datawindow within w_freight_claims_settle_stat
integer x = 37
integer y = 96
integer width = 699
integer height = 588
integer taborder = 10
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_empty[]
integer li_x, li_count

if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	istr_parm.profitcenter = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			istr_parm.profitcenter[li_count] = this.getItemNumber(li_x, "pc_nr")
		end if
	next
	of_filter()
end if


end event

type dw_claims_settled from datawindow within w_freight_claims_settle_stat
integer x = 37
integer y = 708
integer width = 4594
integer height = 1440
integer taborder = 60
string title = "none"
string dataobject = "d_freight_claims_settled"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort

If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
	SelectRow(0,false)
	SetRow(row)
	SelectRow(row,True)
End if

if dwo.type = "text" then
	ls_sort = dwo.Tag

	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
	
end if
end event

event doubleclicked;if row <= 0 then Return

of_open_actions_trans(dw_claims_settled)


end event

type gb_3 from groupbox within w_freight_claims_settle_stat
integer x = 1906
integer width = 658
integer height = 204
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Settle - Discharge Date"
end type

type gb_2 from groupbox within w_freight_claims_settle_stat
integer x = 1038
integer width = 677
integer height = 244
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Year Selection"
end type

type ln_1 from line within w_freight_claims_settle_stat
integer linethickness = 1
integer beginx = 777
integer beginy = 256
integer endx = 4224
integer endy = 256
end type

type ln_2 from line within w_freight_claims_settle_stat
integer linethickness = 1
integer beginx = 777
integer beginy = 364
integer endx = 4224
integer endy = 364
end type

type ln_3 from line within w_freight_claims_settle_stat
integer linethickness = 1
integer beginx = 777
integer beginy = 472
integer endx = 4224
integer endy = 472
end type

type ln_4 from line within w_freight_claims_settle_stat
integer linethickness = 1
integer beginx = 777
integer beginy = 588
integer endx = 4224
integer endy = 588
end type

