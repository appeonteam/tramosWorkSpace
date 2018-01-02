$PBExportHeader$w_apm_pool_commission_control.srw
$PBExportComments$This window is used to control if APM Pool Commission is entered correctly or not entered at all
forward
global type w_apm_pool_commission_control from window
end type
type st_10 from statictext within w_apm_pool_commission_control
end type
type st_9 from statictext within w_apm_pool_commission_control
end type
type em_pct from editmask within w_apm_pool_commission_control
end type
type st_6 from statictext within w_apm_pool_commission_control
end type
type cb_filter from commandbutton within w_apm_pool_commission_control
end type
type hpb_filter from hprogressbar within w_apm_pool_commission_control
end type
type st_5 from statictext within w_apm_pool_commission_control
end type
type rb_tcout from radiobutton within w_apm_pool_commission_control
end type
type rb_tccomm from radiobutton within w_apm_pool_commission_control
end type
type rb_tc_pct from radiobutton within w_apm_pool_commission_control
end type
type rb_cp_pct from radiobutton within w_apm_pool_commission_control
end type
type rb_claims from radiobutton within w_apm_pool_commission_control
end type
type rb_cp from radiobutton within w_apm_pool_commission_control
end type
type st_4 from statictext within w_apm_pool_commission_control
end type
type cb_broker from commandbutton within w_apm_pool_commission_control
end type
type dw_profit_center from datawindow within w_apm_pool_commission_control
end type
type st_1 from statictext within w_apm_pool_commission_control
end type
type sle_voyages from singlelineedit within w_apm_pool_commission_control
end type
type sle_brokers from singlelineedit within w_apm_pool_commission_control
end type
type st_8 from statictext within w_apm_pool_commission_control
end type
type st_7 from statictext within w_apm_pool_commission_control
end type
type cb_saveas from commandbutton within w_apm_pool_commission_control
end type
type em_year from editmask within w_apm_pool_commission_control
end type
type cb_retrieve from commandbutton within w_apm_pool_commission_control
end type
type cb_print from commandbutton within w_apm_pool_commission_control
end type
type cb_close from commandbutton within w_apm_pool_commission_control
end type
type st_3 from statictext within w_apm_pool_commission_control
end type
type st_2 from statictext within w_apm_pool_commission_control
end type
type dw_report from datawindow within w_apm_pool_commission_control
end type
type gb_1 from groupbox within w_apm_pool_commission_control
end type
type gb_claimfilter from groupbox within w_apm_pool_commission_control
end type
end forward

global type w_apm_pool_commission_control from window
integer width = 3497
integer height = 2708
boolean titlebar = true
string title = "Pool Management Control (Missing Broker)"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_10 st_10
st_9 st_9
em_pct em_pct
st_6 st_6
cb_filter cb_filter
hpb_filter hpb_filter
st_5 st_5
rb_tcout rb_tcout
rb_tccomm rb_tccomm
rb_tc_pct rb_tc_pct
rb_cp_pct rb_cp_pct
rb_claims rb_claims
rb_cp rb_cp
st_4 st_4
cb_broker cb_broker
dw_profit_center dw_profit_center
st_1 st_1
sle_voyages sle_voyages
sle_brokers sle_brokers
st_8 st_8
st_7 st_7
cb_saveas cb_saveas
em_year em_year
cb_retrieve cb_retrieve
cb_print cb_print
cb_close cb_close
st_3 st_3
st_2 st_2
dw_report dw_report
gb_1 gb_1
gb_claimfilter gb_claimfilter
end type
global w_apm_pool_commission_control w_apm_pool_commission_control

type variables
integer ii_profitcenter[], ii_broker 
string is_voyages[]

end variables

forward prototypes
public function integer of_voyages ()
public subroutine documentation ()
end prototypes

public function integer of_voyages ();integer li_voucher
long	ll_comma, ll_hyphen
long 	ll_from, ll_to, ll_teller
string ls_voyages, ls_work
string ls_empty[]

is_voyages = ls_empty

ls_voyages = sle_voyages.text
do while len(ls_voyages) > 0
	/* get string to first comma */
	ll_comma = pos(ls_voyages, ",")
	if ll_comma > 0 then
		ls_work = left(ls_voyages, ll_comma -1)
		ls_voyages = right(ls_voyages, len(ls_voyages) - ll_comma)
	else
		ls_work = ls_voyages
		ls_voyages = ""
	end if
	/* find evt. bindestreg (hyphen) */
	ll_hyphen = pos(ls_work, "-")
	if ll_hyphen > 0 then
		ll_from 	= long(left(ls_work, ll_hyphen -1))
		ll_to		= long(right(ls_work, len(ls_work) - ll_hyphen))
		for ll_teller = ll_from to ll_to
			is_voyages[upperbound(is_voyages) +1] = string(ll_teller, "000")
		next
	else
		is_voyages[upperbound(is_voyages) +1] = string(ll_teller, "000")
	end if	
loop
return 1
end function

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
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_apm_pool_commission_control.create
this.st_10=create st_10
this.st_9=create st_9
this.em_pct=create em_pct
this.st_6=create st_6
this.cb_filter=create cb_filter
this.hpb_filter=create hpb_filter
this.st_5=create st_5
this.rb_tcout=create rb_tcout
this.rb_tccomm=create rb_tccomm
this.rb_tc_pct=create rb_tc_pct
this.rb_cp_pct=create rb_cp_pct
this.rb_claims=create rb_claims
this.rb_cp=create rb_cp
this.st_4=create st_4
this.cb_broker=create cb_broker
this.dw_profit_center=create dw_profit_center
this.st_1=create st_1
this.sle_voyages=create sle_voyages
this.sle_brokers=create sle_brokers
this.st_8=create st_8
this.st_7=create st_7
this.cb_saveas=create cb_saveas
this.em_year=create em_year
this.cb_retrieve=create cb_retrieve
this.cb_print=create cb_print
this.cb_close=create cb_close
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_claimfilter=create gb_claimfilter
this.Control[]={this.st_10,&
this.st_9,&
this.em_pct,&
this.st_6,&
this.cb_filter,&
this.hpb_filter,&
this.st_5,&
this.rb_tcout,&
this.rb_tccomm,&
this.rb_tc_pct,&
this.rb_cp_pct,&
this.rb_claims,&
this.rb_cp,&
this.st_4,&
this.cb_broker,&
this.dw_profit_center,&
this.st_1,&
this.sle_voyages,&
this.sle_brokers,&
this.st_8,&
this.st_7,&
this.cb_saveas,&
this.em_year,&
this.cb_retrieve,&
this.cb_print,&
this.cb_close,&
this.st_3,&
this.st_2,&
this.dw_report,&
this.gb_1,&
this.gb_claimfilter}
end on

on w_apm_pool_commission_control.destroy
destroy(this.st_10)
destroy(this.st_9)
destroy(this.em_pct)
destroy(this.st_6)
destroy(this.cb_filter)
destroy(this.hpb_filter)
destroy(this.st_5)
destroy(this.rb_tcout)
destroy(this.rb_tccomm)
destroy(this.rb_tc_pct)
destroy(this.rb_cp_pct)
destroy(this.rb_claims)
destroy(this.rb_cp)
destroy(this.st_4)
destroy(this.cb_broker)
destroy(this.dw_profit_center)
destroy(this.st_1)
destroy(this.sle_voyages)
destroy(this.sle_brokers)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.cb_saveas)
destroy(this.em_year)
destroy(this.cb_retrieve)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_claimfilter)
end on

event open;move(0,0)

em_year.text = string(year(today()))

dw_report.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve( uo_global.is_userid )



end event

type st_10 from statictext within w_apm_pool_commission_control
integer x = 2647
integer y = 432
integer width = 713
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter out all Claims where there is no Broker Commission at all registred in Commissions. "
boolean focusrectangle = false
end type

type st_9 from statictext within w_apm_pool_commission_control
integer x = 1577
integer y = 416
integer width = 64
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "%"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_pct from editmask within w_apm_pool_commission_control
integer x = 1394
integer y = 404
integer width = 183
integer height = 80
integer taborder = 210
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0.00"
end type

type st_6 from statictext within w_apm_pool_commission_control
integer x = 782
integer y = 416
integer width = 402
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Commission %:"
boolean focusrectangle = false
end type

type cb_filter from commandbutton within w_apm_pool_commission_control
integer x = 2848
integer y = 736
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Filter"
end type

event clicked;long		ll_rows, ll_row, ll_counter
integer	li_chart_nr, li_vessel_nr, li_claim_nr
string		ls_voyage_nr

ll_rows = dw_report.rowcount()

if ll_rows < 1 then return


hpb_filter.maxposition = ll_rows

for ll_row = ll_rows to 1 step -1
	hpb_filter.position = ll_rows - ll_row
	li_chart_nr = dw_report.getItemNumber(ll_row, "chart_nr")
	li_vessel_nr = dw_report.getItemNumber(ll_row, "vessel_nr")
	ls_voyage_nr = dw_report.getItemString(ll_row, "voyage_nr")
	li_claim_nr = dw_report.getItemNumber(ll_row, "claim_nr")
	
	SELECT count(*)  
		INTO :ll_counter  
		FROM COMMISSIONS  
		WHERE COMMISSIONS.CHART_NR = :li_chart_nr  AND  
			COMMISSIONS.VESSEL_NR = :li_vessel_nr  AND  
			COMMISSIONS.VOYAGE_NR = :ls_voyage_nr  AND  
			COMMISSIONS.CLAIM_NR = :li_claim_nr   AND
			COMMISSIONS.BROKER_NR <> :ii_broker ;
	COMMIT;
	if ll_counter = 0 then
		dw_report.deleterow( ll_row )
	end if
next
end event

type hpb_filter from hprogressbar within w_apm_pool_commission_control
integer x = 2633
integer y = 640
integer width = 727
integer height = 68
unsignedinteger maxposition = 100
unsignedinteger position = 1
integer setstep = 10
end type

type st_5 from statictext within w_apm_pool_commission_control
integer x = 27
integer y = 892
integer width = 1417
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "<DoubleClick> on a row below for jump to Finance Controlpanel."
boolean focusrectangle = false
end type

type rb_tcout from radiobutton within w_apm_pool_commission_control
integer x = 1422
integer y = 584
integer width = 553
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC Contract (TC-OUT)"
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_tcout"
dw_report.setTransObject(sqlca)

em_pct.enabled = false
cb_filter.enabled = false
gb_claimfilter.enabled = false


end event

type rb_tccomm from radiobutton within w_apm_pool_commission_control
integer x = 1422
integer y = 664
integer width = 626
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC Commission (TC-OUT)"
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_tccomm"
dw_report.setTransObject(sqlca)

em_pct.enabled = false
cb_filter.enabled = false
gb_claimfilter.enabled = false

end event

type rb_tc_pct from radiobutton within w_apm_pool_commission_control
integer x = 1422
integer y = 744
integer width = 498
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Wrong % (TC-OUT)"
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_tc_percent"
dw_report.setTransObject(sqlca)

em_pct.enabled = true
cb_filter.enabled = false
gb_claimfilter.enabled = false

end event

type rb_cp_pct from radiobutton within w_apm_pool_commission_control
integer x = 878
integer y = 744
integer width = 567
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Wrong % (C/P)"
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_cp_percent"
dw_report.setTransObject(sqlca)

em_pct.enabled = true
cb_filter.enabled = false
gb_claimfilter.enabled = false

end event

type rb_claims from radiobutton within w_apm_pool_commission_control
integer x = 878
integer y = 664
integer width = 485
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Claims Commission"
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_claims"
dw_report.setTransObject(sqlca)
em_pct.enabled = false

cb_filter.enabled = true
gb_claimfilter.enabled = true


end event

type rb_cp from radiobutton within w_apm_pool_commission_control
integer x = 878
integer y = 584
integer width = 457
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculation (C/P)"
boolean checked = true
end type

event clicked;dw_report.dataObject = "d_apm_pool_comm_control_cp"
dw_report.setTransObject(sqlca)
em_pct.enabled = false
cb_filter.enabled = false
gb_claimfilter.enabled = false


end event

type st_4 from statictext within w_apm_pool_commission_control
integer x = 782
integer y = 276
integer width = 402
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter voyages:"
boolean focusrectangle = false
end type

type cb_broker from commandbutton within w_apm_pool_commission_control
integer x = 1253
integer y = 168
integer width = 82
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;string ls_broker

ii_broker = integer(f_select_from_list("dw_broker_list",2,"Shortname",3,"Fullname",1,"Select Broker",false))
IF NOT IsNull(ii_broker) THEN
	SELECT BROKER_NAME INTO :ls_broker FROM BROKERS WHERE BROKER_NR = :ii_broker;
	sle_brokers.text = "("+ string(ii_broker)+ ")  "+ls_broker
END IF



end event

type dw_profit_center from datawindow within w_apm_pool_commission_control
integer x = 9
integer y = 64
integer width = 699
integer height = 776
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
	ii_profitcenter = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			ii_profitcenter[li_count] = this.getItemNumber(li_x, "pc_nr")
		end if
	next
end if


end event

type st_1 from statictext within w_apm_pool_commission_control
integer x = 1403
integer y = 344
integer width = 960
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "entered as fx 1, 4, 10-25, 50-999"
boolean focusrectangle = false
end type

type sle_voyages from singlelineedit within w_apm_pool_commission_control
integer x = 1394
integer y = 268
integer width = 1760
integer height = 72
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "50-999"
borderstyle borderstyle = stylelowered!
end type

type sle_brokers from singlelineedit within w_apm_pool_commission_control
integer x = 1394
integer y = 168
integer width = 1760
integer height = 72
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

type st_8 from statictext within w_apm_pool_commission_control
integer x = 782
integer y = 176
integer width = 393
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Broker:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_apm_pool_commission_control
integer x = 9
integer width = 599
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Profit Center(s):"
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_apm_pool_commission_control
integer x = 2185
integer y = 520
integer width = 343
integer height = 100
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_report.saveas()

end event

type em_year from editmask within w_apm_pool_commission_control
integer x = 1394
integer y = 64
integer width = 183
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
double increment = 1
string minmax = "1995~~2020"
end type

type cb_retrieve from commandbutton within w_apm_pool_commission_control
integer x = 2185
integer y = 400
integer width = 343
integer height = 100
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;string 		ls_year
decimal{2}	ld_pct
integer		li_pool_manager

/* validate and retrieve */

/* Profitcenter */
if upperBound(ii_profitcenter) = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter")
	dw_profit_center.post setFocus()
	return
end if

/* Year */
if isNull(em_year.text) then
	MessageBox("Validation Error", "Please entert a Year")
	em_year.post setFocus()
	return
end if
ls_year = mid(em_year.text,3,2)

/* Broker */
if ii_broker<= 0 then
	MessageBox("Validation Error", "Please select a Broker")
	cb_broker.post setFocus()
	return
else
	SELECT BROKER_POOL_MANAGER
	INTO :li_pool_manager
	FROM BROKERS
	WHERE BROKER_NR = :ii_broker
	;
	COMMIT;
	if li_pool_manager = 0 then
		MessageBox("Validation Error", "Please select a pool manager Broker")
		cb_broker.post setFocus()
		return
	end if
end if

/* Voyages */
if len(sle_voyages.text ) = 0 then
	MessageBox("Validation Error", "Please enter Voyages")
	sle_voyages.post setFocus()
	return
end if

of_voyages( )

/* Retrieve */
if rb_cp_pct.checked or rb_tc_pct.checked then
	ld_pct = dec(em_pct.text)
	if ld_pct = 0 then
		MessageBox("Validation Error", "Please enter percent")
		em_pct.post setFocus()
		return
	end if
	dw_report.retrieve(ls_year, ii_profitcenter, ii_broker, is_voyages, ld_pct)
else
	dw_report.retrieve(ls_year, ii_profitcenter, ii_broker, is_voyages)
end if	
commit;
end event

type cb_print from commandbutton within w_apm_pool_commission_control
integer x = 2185
integer y = 640
integer width = 343
integer height = 100
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_report.print()

end event

type cb_close from commandbutton within w_apm_pool_commission_control
integer x = 2185
integer y = 760
integer width = 343
integer height = 100
integer taborder = 200
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

type st_3 from statictext within w_apm_pool_commission_control
integer x = 1591
integer y = 72
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

type st_2 from statictext within w_apm_pool_commission_control
integer x = 782
integer y = 76
integer width = 585
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage year selection:"
boolean focusrectangle = false
end type

type dw_report from datawindow within w_apm_pool_commission_control
integer x = 14
integer y = 964
integer width = 3383
integer height = 1616
integer taborder = 140
string title = "none"
string dataobject = "d_apm_pool_comm_control_cp"
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

event doubleclicked;integer 	li_vessel
string 	ls_voyage
u_jump_finance_control luo_jump_fin

if row < 1 then return

li_vessel = this.getItemNumber(row, "vessel_nr")
if dw_report.dataObject = "d_apm_pool_comm_control_tccomm"  &
or dw_report.dataObject = "d_apm_pool_comm_control_tc_percent" then
	ls_voyage = ""
else
	ls_voyage = this.getItemString(row, "voyage_nr")
end if
luo_jump_fin = CREATE u_jump_finance_control
luo_jump_fin.of_open_control(li_vessel, ls_voyage)
DESTROY luo_jump_fin
end event

type gb_1 from groupbox within w_apm_pool_commission_control
integer x = 786
integer y = 508
integer width = 1289
integer height = 336
integer taborder = 210
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Report"
end type

type gb_claimfilter from groupbox within w_apm_pool_commission_control
integer x = 2606
integer y = 360
integer width = 786
integer height = 504
integer taborder = 220
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Claim Filter"
end type

