$PBExportHeader$w_voucher_report.srw
forward
global type w_voucher_report from w_sheet
end type
type st_3 from statictext within w_voucher_report
end type
type st_2 from statictext within w_voucher_report
end type
type sle_voucher_filter from singlelineedit within w_voucher_report
end type
type st_1 from statictext within w_voucher_report
end type
type cb_filter from commandbutton within w_voucher_report
end type
type sle_voucher_nr from singlelineedit within w_voucher_report
end type
type cb_print from commandbutton within w_voucher_report
end type
type cb_saveas from commandbutton within w_voucher_report
end type
type cb_close from commandbutton within w_voucher_report
end type
type dw_report from u_dw within w_voucher_report
end type
end forward

global type w_voucher_report from w_sheet
integer width = 3520
integer height = 2536
string title = "Voucher Report"
boolean maxbox = false
boolean resizable = false
st_3 st_3
st_2 st_2
sle_voucher_filter sle_voucher_filter
st_1 st_1
cb_filter cb_filter
sle_voucher_nr sle_voucher_nr
cb_print cb_print
cb_saveas cb_saveas
cb_close cb_close
dw_report dw_report
end type
global w_voucher_report w_voucher_report

forward prototypes
public subroutine of_filter ()
end prototypes

public subroutine of_filter ();//long ll_row, ll_rows
//string ls_filter
//
//dw_stat_detail.setredraw(false)
//dw_stat_totals.setredraw(false)
//dw_outst_detail.setredraw(false)
//
//if upperbound(istr_parm.profitcenter) = 0 then 
//	dw_stat_detail.reset()
//	dw_stat_detail.setredraw(true)
//	dw_stat_totals.setredraw(true)
//	dw_outst_detail.setredraw(true)
//	return
//end if
//
//if (dw_stat_detail.FilteredCount() = 0 and dw_stat_detail.rowcount() = 0) then
//	dw_stat_detail.retrieve()
//	dw_stat_detail.ShareData(dw_stat_totals)
//	dw_stat_detail.ShareData(dw_outst_detail)	
//end if
//
//ll_rows = dw_profit_center.rowcount()
//
//FOR ll_row=1 TO ll_rows
//	if (dw_profit_center.isselected(ll_row)) then
//		if (len(ls_filter)=0) then
//			ls_filter += " vessels_pc_nr = " + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
//		else
//			ls_filter += " or "
//			ls_filter += " vessels_pc_nr = " + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
//		end if
//	else
//		if (len(ls_filter) = 0) and ll_row = ll_rows then ls_filter += " vessels_pc_nr = 9999 "
//	end if
//NEXT
//
//if (rb_em.checked) then
//	if (len(ls_filter)=0) then
//		ls_filter += " claims_forwarding_date >= disch_date "
//	else
//		ls_filter += " and "
//		ls_filter += " claims_forwarding_date >= disch_date "
//	end if
//elseif (rb_sm.checked) then
//	if (len(ls_filter)=0) then
//		ls_filter += " claims_forwarding_date < disch_date "
//	else
//		ls_filter += " and "
//		ls_filter += " claims_forwarding_date < disch_date "
//	end if
//elseif (rb_swnf.checked) then
//	if (len(ls_filter)=0) then
//		ls_filter += " isnull (claims_forwarding_date) "
//	else
//		ls_filter += " and "
//		ls_filter += " isnull (claims_forwarding_date) "
//	end if
//elseif (rb_all.checked) then
//end if
//
//
//if (len(em_year.text) > 0) then
//		if (len(ls_filter)=0) then
//			ls_filter += "left(compute_voyage_sort , 4 ) = " + "'" + string(em_year.text) +"'"
//		else
//			ls_filter += " and "
//			ls_filter += " left(compute_voyage_sort , 4 ) = " + "'" + string(em_year.text) +"'"
//		end if
//end if
//
//if (len(em_days.text) > 0) then
//		if (len(ls_filter)=0) then
//			ls_filter += " daysafter(claims_forwarding_date , today() ) >= " + string(em_days.text) 
//		else 
//			ls_filter += " and "
//			ls_filter += " daysafter(claims_forwarding_date , today() ) >= " + string(em_days.text)
//		end if
//end if
//
///* Vessel Number */
//if (len(sle_vessels.text) > 0) then
//	if cbx_include_vessel.checked then
//		if (len(ls_filter)=0) then
//			ls_filter += " claims_vessel_nr in ( " + string(sle_vessels.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " claims_vessel_nr in ( " + string(sle_vessels.text) + " )"
//		end if
//	else
//		if (len(ls_filter)=0) then
//			ls_filter += " claims_vessel_nr not in ( " + string(sle_vessels.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " claims_vessel_nr not in ( " + string(sle_vessels.text) + " )"
//		end if
//	end if
//end if
//
///* Charterer Number */
//if (len(sle_charterers.text) > 0) then
//	if cbx_include_chart.checked then
//		if (len(ls_filter)=0) then
//			ls_filter += " claims_chart_nr in ( " + string(sle_charterers.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " claims_chart_nr in ( " + string(sle_charterers.text) + " )"
//		end if
//	else
//		if (len(ls_filter)=0) then
//			ls_filter += " claims_chart_nr not in ( " + string(sle_charterers.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " claims_chart_nr not in ( " + string(sle_charterers.text) + " )"
//		end if
//	end if		
//end if
//
///* Broker Number */
//if (len(sle_brokers.text) > 0) then
//	if cbx_include_broker.checked then
//		if (len(ls_filter)=0) then
//			ls_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " broker_nr in ( " + string(sle_brokers.text) + " )"
//		end if
//	else
//		if (len(ls_filter)=0) then
//			ls_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " broker_nr not in ( " + string(sle_brokers.text) + " )"
//		end if
//	end if		
//end if
//
///* Office Number */
//if (len(sle_offices.text) > 0) then
//	if cbx_include_office.checked then
//		if (len(ls_filter)=0) then
//			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
//		end if
//	else
//		if (len(ls_filter)=0) then
//			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
//		else 
//			ls_filter += " and "
//			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
//		end if
//	end if		
//end if
//
//
//dw_stat_detail.setfilter(ls_filter)
//dw_stat_detail.filter()
//
//dw_stat_detail.setredraw(true)
//dw_stat_totals.setredraw(true)
//dw_outst_detail.setredraw(true)
//
end subroutine

on w_voucher_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.sle_voucher_filter=create sle_voucher_filter
this.st_1=create st_1
this.cb_filter=create cb_filter
this.sle_voucher_nr=create sle_voucher_nr
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_close=create cb_close
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_voucher_filter
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_filter
this.Control[iCurrent+6]=this.sle_voucher_nr
this.Control[iCurrent+7]=this.cb_print
this.Control[iCurrent+8]=this.cb_saveas
this.Control[iCurrent+9]=this.cb_close
this.Control[iCurrent+10]=this.dw_report
end on

on w_voucher_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_voucher_filter)
destroy(this.st_1)
destroy(this.cb_filter)
destroy(this.sle_voucher_nr)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_close)
destroy(this.dw_report)
end on

event pfc_postopen;call super::pfc_postopen;dw_report.retrieve()
end event

type st_3 from statictext within w_voucher_report
integer x = 352
integer y = 2364
integer width = 960
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "entered as fx 1, 4, 10-25, 56, 100-132, 150"
boolean focusrectangle = false
end type

type st_2 from statictext within w_voucher_report
integer x = 14
integer y = 2296
integer width = 311
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "and in"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_voucher_filter from singlelineedit within w_voucher_report
integer x = 347
integer y = 2288
integer width = 1449
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "50-83, 101-300"
borderstyle borderstyle = stylelowered!
end type

event modified;of_filter()
end event

type st_1 from statictext within w_voucher_report
integer x = 14
integer y = 2204
integer width = 325
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voucher # >"
boolean focusrectangle = false
end type

type cb_filter from commandbutton within w_voucher_report
integer x = 1893
integer y = 2264
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Filter"
end type

event clicked;integer li_voucher
long	ll_comma, ll_hyphen
long 	ll_from, ll_to, ll_teller
string ls_filter, ls_filter1, ls_filter2
string ls_vouchers, ls_work

li_voucher = integer(sle_voucher_nr.text)

ls_filter1 = "voucher_nr >"+string(li_voucher)

ls_vouchers = sle_voucher_filter.text
do while len(ls_vouchers) > 0
	/* get string to first comma */
	ll_comma = pos(ls_vouchers, ",")
	if ll_comma > 0 then
		ls_work = left(ls_vouchers, ll_comma -1)
		ls_vouchers = right(ls_vouchers, len(ls_vouchers) - ll_comma)
	else
		ls_work = ls_vouchers
		ls_vouchers = ""
	end if
	/* find evt. bindestreg (hyphen) */
	ll_hyphen = pos(ls_work, "-")
	if ll_hyphen > 0 then
		ll_from 	= long(left(ls_work, ll_hyphen -1))
		ll_to		= long(right(ls_work, len(ls_work) - ll_hyphen))
		for ll_teller = ll_from to ll_to
			if len(ls_filter2) > 0 then
				ls_filter2 += ", "+string(ll_teller)
			else
				ls_filter2 = string(ll_teller)
			end if
		next
	else
		if len(ls_filter2) > 0 then
			ls_filter2 += ", "+string(long(ls_work))
		else
			ls_filter2 = string(long(ls_work))
		end if
	end if	
loop

if len(ls_filter1) > 0 and not isNull(ls_filter1) then
	ls_filter = ls_filter1
	if len(ls_filter2) > 0 and not isNull(ls_filter2) then
		ls_filter += " and voucher_nr in ("+ls_filter2+")"
	end if
else
	if len(ls_filter2) > 0 and not isNull(ls_filter2) then
		ls_filter = "voucher_nr in ("+ls_filter2+")"
	end if
end if	

dw_report.setFilter(ls_filter)
dw_report.filter()

end event

type sle_voucher_nr from singlelineedit within w_voucher_report
integer x = 347
integer y = 2204
integer width = 146
integer height = 68
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_voucher_report
integer x = 2304
integer y = 2264
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_report.print()
end event

type cb_saveas from commandbutton within w_voucher_report
integer x = 2715
integer y = 2264
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_report.saveas()
end event

type cb_close from commandbutton within w_voucher_report
integer x = 3127
integer y = 2264
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_report from u_dw within w_voucher_report
integer width = 3479
integer height = 2176
integer taborder = 10
string dataobject = "d_sq_gp_voucher_report"
end type

event constructor;call super::constructor;this.of_settransobject( sqlca)
end event

