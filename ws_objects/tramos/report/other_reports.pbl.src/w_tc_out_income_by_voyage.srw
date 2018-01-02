$PBExportHeader$w_tc_out_income_by_voyage.srw
forward
global type w_tc_out_income_by_voyage from window
end type
type st_1 from statictext within w_tc_out_income_by_voyage
end type
type st_4 from statictext within w_tc_out_income_by_voyage
end type
type cbx_showdetail from checkbox within w_tc_out_income_by_voyage
end type
type dw_enddate from datawindow within w_tc_out_income_by_voyage
end type
type dw_startdate from datawindow within w_tc_out_income_by_voyage
end type
type st_2 from statictext within w_tc_out_income_by_voyage
end type
type dw_profitcenter from datawindow within w_tc_out_income_by_voyage
end type
type st_3 from statictext within w_tc_out_income_by_voyage
end type
type cb_2 from commandbutton within w_tc_out_income_by_voyage
end type
type cb_1 from commandbutton within w_tc_out_income_by_voyage
end type
type cb_report from commandbutton within w_tc_out_income_by_voyage
end type
type dw_1 from datawindow within w_tc_out_income_by_voyage
end type
type gb_1 from groupbox within w_tc_out_income_by_voyage
end type
end forward

global type w_tc_out_income_by_voyage from window
integer width = 4206
integer height = 2988
boolean titlebar = true
string title = "T/C-Out Income by Voyage"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
st_4 st_4
cbx_showdetail cbx_showdetail
dw_enddate dw_enddate
dw_startdate dw_startdate
st_2 st_2
dw_profitcenter dw_profitcenter
st_3 st_3
cb_2 cb_2
cb_1 cb_1
cb_report cb_report
dw_1 dw_1
gb_1 gb_1
end type
global w_tc_out_income_by_voyage w_tc_out_income_by_voyage

type variables
integer	ii_profitcenter[]
end variables

forward prototypes
public subroutine documentation ()
end prototypes

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
   	01/09/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_tc_out_income_by_voyage.create
this.st_1=create st_1
this.st_4=create st_4
this.cbx_showdetail=create cbx_showdetail
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.st_2=create st_2
this.dw_profitcenter=create dw_profitcenter
this.st_3=create st_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_report=create cb_report
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.st_4,&
this.cbx_showdetail,&
this.dw_enddate,&
this.dw_startdate,&
this.st_2,&
this.dw_profitcenter,&
this.st_3,&
this.cb_2,&
this.cb_1,&
this.cb_report,&
this.dw_1,&
this.gb_1}
end on

on w_tc_out_income_by_voyage.destroy
destroy(this.st_1)
destroy(this.st_4)
destroy(this.cbx_showdetail)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.st_2)
destroy(this.dw_profitcenter)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_report)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;integer	li_month, li_year
date		ldt_calc_date
this.move(0,0)

dw_profitcenter.setTransObject(SQLCA)
dw_profitcenter.retrieve(uo_global.is_userid)
dw_profitcenter.setRowFocusindicator( focusrect!)
dw_profitcenter.POST setFocus()


dw_startdate.insertRow(0)
dw_enddate.insertRow(0)

/* Set default start and end dates */
li_month = month(today())
li_year = year(today())

ldt_calc_date = date(li_year, li_month,1)
dw_enddate.setItem(1, "date_value", ldt_calc_date)
if li_month = 1 then
	li_month = 12
	li_year --
else
	li_month --
end if
ldt_calc_date = date(li_year, li_month,1)
dw_startdate.setItem(1, "date_value", ldt_calc_date)



end event

type st_1 from statictext within w_tc_out_income_by_voyage
integer x = 101
integer y = 1008
integer width = 142
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From"
boolean focusrectangle = false
end type

type st_4 from statictext within w_tc_out_income_by_voyage
integer x = 101
integer y = 916
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage End:"
boolean focusrectangle = false
end type

type cbx_showdetail from checkbox within w_tc_out_income_by_voyage
integer x = 105
integer y = 1236
integer width = 462
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show detail lines"
end type

event clicked;if this.checked then
	dw_1.Object.DataWindow.Detail.Height='64'
	dw_1.Object.DataWindow.Header.Height='156'
else
	dw_1.Object.DataWindow.Detail.Height='0'
	dw_1.Object.DataWindow.Header.Height='80'
end if	
end event

type dw_enddate from datawindow within w_tc_out_income_by_voyage
integer x = 242
integer y = 1112
integer width = 306
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_startdate from datawindow within w_tc_out_income_by_voyage
integer x = 242
integer y = 1000
integer width = 306
integer height = 88
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_tc_out_income_by_voyage
integer x = 101
integer y = 1124
integer width = 142
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To"
boolean focusrectangle = false
end type

type dw_profitcenter from datawindow within w_tc_out_income_by_voyage
integer x = 87
integer y = 144
integer width = 658
integer height = 740
integer taborder = 20
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

type st_3 from statictext within w_tc_out_income_by_voyage
integer x = 101
integer y = 84
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profitcenter:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_tc_out_income_by_voyage
integer x = 50
integer y = 1684
integer width = 709
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "SaveAs..."
end type

event clicked;dw_1.saveas()
end event

type cb_1 from commandbutton within w_tc_out_income_by_voyage
integer x = 50
integer y = 1580
integer width = 709
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;dw_1.print()
end event

type cb_report from commandbutton within w_tc_out_income_by_voyage
integer x = 50
integer y = 1396
integer width = 709
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Report"
end type

event clicked;long ll_rows, ll_row
long ll_payments, ll_payment, ll_contractid
string ls_voyageid, ls_previousvoyage
mt_n_datastore lds_tchire
decimal ld_rate, ld_quantity, ld_totalamount
datetime	ldt_periodstart, ldt_periodend, ldt_voyagestart, ldt_voyageend
boolean lb_monthy
integer li_empty[]

dw_1.settransobject(SQLCA)

if ii_profitcenter = li_empty then return -1

ll_rows = dw_1.retrieve(ii_profitcenter, dw_startdate.getitemdate(1,1), dw_enddate.getitemdate(1,1))

if ll_rows < 1 then return

lds_tchire = CREATE mt_n_datastore
lds_tchire.dataobject = "d_sq_tb_tcout_out_income_by_voyage_pay"
lds_tchire.setTransObject( sqlca )

ls_previousvoyage=""

for ll_row = 1 to ll_rows
	ls_voyageid = dw_1.getItemstring(ll_row, "voyage_nr")
	if ls_previousvoyage <> ls_voyageid then
		 ls_previousvoyage = ls_voyageid
		 	ld_totalamount = 0
	ldt_voyagestart = dw_1.getItemDatetime(ll_row, "voyage_start")
	ldt_voyageend =  dw_1.getItemDatetime(ll_row, "voyage_end")
	ll_payments = lds_tchire.retrieve(dw_1.getItemNumber(ll_row, "vessel_nr" ),ldt_voyagestart, ldt_voyageend) 
	if ll_payments < 1 then continue
	for ll_payment = 1 to ll_payments
		ll_contractid = lds_tchire.getItemnumber(ll_payment, "ntc_tc_contract_contract_id")		
		ldt_periodstart = lds_tchire.getItemDatetime(ll_payment, "periode_start")		
		ldt_periodend = lds_tchire.getItemDatetime(ll_payment, "periode_end")		
		ld_quantity = lds_tchire.getItemdecimal(ll_payment, "quantity")
		ld_rate = lds_tchire.getItemdecimal(ll_payment, "rate")
		lb_monthy = lds_tchire.getItemNumber(ll_payment, "monthly_rate") > 0
		if lb_monthy then
			ld_quantity = (f_datetime2long(ldt_periodend) - f_datetime2long(ldt_periodstart))/ 86400
			ld_rate = ld_rate / ld_quantity
	     end if
		if ll_payment =1 then
			ld_quantity = (f_datetime2long(ldt_periodend) - f_datetime2long(ldt_voyagestart))/  86400
		elseif ll_payment = ll_payments then
			ld_quantity = (f_datetime2long(ldt_voyageend) - f_datetime2long(ldt_periodstart))/  86400
		end if
			ld_totalamount += ld_quantity * ld_rate
	next
end if
	dw_1.setItem(ll_row, "amount", ld_totalamount)
	dw_1.setItem(ll_row, "contract_id", ll_contractid)

next
	




end event

type dw_1 from datawindow within w_tc_out_income_by_voyage
integer x = 805
integer y = 32
integer width = 3323
integer height = 2804
integer taborder = 10
string title = "TC OUT Income by Voyage"
string dataobject = "d_sq_tb_tcout_out_income_by_voyage"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_tc_out_income_by_voyage
integer x = 64
integer y = 4
integer width = 704
integer height = 1340
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selection Criteria..."
end type

