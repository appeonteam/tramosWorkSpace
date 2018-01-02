$PBExportHeader$w_fin_report_tcperiode.srw
$PBExportComments$This window shows tc-periods
forward
global type w_fin_report_tcperiode from window
end type
type cb_retrieve from commandbutton within w_fin_report_tcperiode
end type
type cbx_ratezero from checkbox within w_fin_report_tcperiode
end type
type st_4 from statictext within w_fin_report_tcperiode
end type
type st_3 from statictext within w_fin_report_tcperiode
end type
type rb_tcout from radiobutton within w_fin_report_tcperiode
end type
type rb_tcin from radiobutton within w_fin_report_tcperiode
end type
type rb_tcinout from radiobutton within w_fin_report_tcperiode
end type
type dw_enddate from datawindow within w_fin_report_tcperiode
end type
type cb_saveas from commandbutton within w_fin_report_tcperiode
end type
type st_2 from statictext within w_fin_report_tcperiode
end type
type dw_startdate from datawindow within w_fin_report_tcperiode
end type
type dw_profit_center from datawindow within w_fin_report_tcperiode
end type
type cb_2 from commandbutton within w_fin_report_tcperiode
end type
type cb_1 from commandbutton within w_fin_report_tcperiode
end type
type dw_tcperiode from datawindow within w_fin_report_tcperiode
end type
type gb_1 from groupbox within w_fin_report_tcperiode
end type
type gb_2 from groupbox within w_fin_report_tcperiode
end type
end forward

global type w_fin_report_tcperiode from window
integer width = 4165
integer height = 2528
boolean titlebar = true
string title = "T/C Hire Periods"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_retrieve cb_retrieve
cbx_ratezero cbx_ratezero
st_4 st_4
st_3 st_3
rb_tcout rb_tcout
rb_tcin rb_tcin
rb_tcinout rb_tcinout
dw_enddate dw_enddate
cb_saveas cb_saveas
st_2 st_2
dw_startdate dw_startdate
dw_profit_center dw_profit_center
cb_2 cb_2
cb_1 cb_1
dw_tcperiode dw_tcperiode
gb_1 gb_1
gb_2 gb_2
end type
global w_fin_report_tcperiode w_fin_report_tcperiode

forward prototypes
private subroutine wf_filter ()
end prototypes

private subroutine wf_filter ();string ls_filter

/* Filter Contract type... */
if rb_tcin.checked then
	ls_filter = "ntc_tc_contract_tc_hire_in=1"
elseif rb_tcout.checked then
	ls_filter = "ntc_tc_contract_tc_hire_in=0"
else
	ls_filter=""
end if

/* Filter out periods with rate 0 (zero) */
if cbx_ratezero.checked then
	if len(ls_filter) > 0 then
		ls_filter += " and ntc_tc_period_rate <> 0"
	else
		ls_filter += "ntc_tc_period_rate <> 0"
	end if
end if

/* set filter.... */
dw_tcperiode.setFilter(ls_filter)
dw_tcperiode.filter()
end subroutine

event open;this.move(0,0)
dw_tcperiode.settransobject(SQLCA)
dw_tcperiode.SetRowFocusIndicator(FocusRect!)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.SetRowFocusIndicator(FocusRect!)

dw_profit_center.post retrieve( uo_global.is_userid )
dw_startdate.InsertRow(0)
dw_startdate.setItem(1, "date_value", date(year(today()),1,1))
dw_enddate.InsertRow(0)
dw_enddate.setItem(1, "date_value", date(year(today()) +1,1,1))
dw_startdate.POST setfocus()
end event

on w_fin_report_tcperiode.create
this.cb_retrieve=create cb_retrieve
this.cbx_ratezero=create cbx_ratezero
this.st_4=create st_4
this.st_3=create st_3
this.rb_tcout=create rb_tcout
this.rb_tcin=create rb_tcin
this.rb_tcinout=create rb_tcinout
this.dw_enddate=create dw_enddate
this.cb_saveas=create cb_saveas
this.st_2=create st_2
this.dw_startdate=create dw_startdate
this.dw_profit_center=create dw_profit_center
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_tcperiode=create dw_tcperiode
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_retrieve,&
this.cbx_ratezero,&
this.st_4,&
this.st_3,&
this.rb_tcout,&
this.rb_tcin,&
this.rb_tcinout,&
this.dw_enddate,&
this.cb_saveas,&
this.st_2,&
this.dw_startdate,&
this.dw_profit_center,&
this.cb_2,&
this.cb_1,&
this.dw_tcperiode,&
this.gb_1,&
this.gb_2}
end on

on w_fin_report_tcperiode.destroy
destroy(this.cb_retrieve)
destroy(this.cbx_ratezero)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.rb_tcout)
destroy(this.rb_tcin)
destroy(this.rb_tcinout)
destroy(this.dw_enddate)
destroy(this.cb_saveas)
destroy(this.st_2)
destroy(this.dw_startdate)
destroy(this.dw_profit_center)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_tcperiode)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type cb_retrieve from commandbutton within w_fin_report_tcperiode
integer x = 2624
integer y = 2276
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;integer li_pcnr[], li_index
long ll_row, ll_rows
datetime ldt_startdate, ldt_enddate

ll_rows = dw_profit_center.rowcount()
if ll_rows < 1 then 
	dw_tcperiode.reset()
	return
end if

dw_startdate.accepttext()
ldt_startdate = datetime(dw_startdate.getItemDate(1, "date_value"))
dw_enddate.accepttext()
ldt_enddate = datetime(dw_enddate.getItemDate(1, "date_value"))

if isnull(ldt_startdate) or isnull(ldt_enddate) then /* No date entered */
	dw_tcperiode.reset()
	return
end if

li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_profit_center.isselected(ll_row)) then
 		li_pcnr[li_index] = dw_profit_center.getitemnumber(ll_row, "pc_nr")
		li_index ++
	end if
NEXT

if li_index = 1 then /* No selection made in Profitcenter */
	dw_tcperiode.reset()
	return
end if

dw_tcperiode.post retrieve(ldt_startdate, ldt_enddate, li_pcnr)
post wf_filter()
end event

type cbx_ratezero from checkbox within w_fin_report_tcperiode
integer x = 1609
integer y = 2300
integer width = 581
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Exclude rate 0 (zero)"
end type

event clicked;post wf_filter()
end event

type st_4 from statictext within w_fin_report_tcperiode
integer x = 96
integer y = 2136
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
string text = "End:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_fin_report_tcperiode
integer x = 96
integer y = 2012
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
string text = "Start:"
boolean focusrectangle = false
end type

type rb_tcout from radiobutton within w_fin_report_tcperiode
integer x = 1659
integer y = 2148
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC OUT"
end type

event clicked;post wf_filter()
end event

type rb_tcin from radiobutton within w_fin_report_tcperiode
integer x = 1659
integer y = 2060
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC IN"
end type

event clicked;post wf_filter()
end event

type rb_tcinout from radiobutton within w_fin_report_tcperiode
integer x = 1659
integer y = 1976
integer width = 361
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC IN / OUT"
boolean checked = true
end type

event clicked;post wf_filter()
end event

type dw_enddate from datawindow within w_fin_report_tcperiode
integer x = 261
integer y = 2124
integer width = 311
integer height = 84
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;cb_retrieve.postevent( clicked!)
end event

type cb_saveas from commandbutton within w_fin_report_tcperiode
integer x = 3378
integer y = 2272
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_tcperiode.saveAs()
end event

type st_2 from statictext within w_fin_report_tcperiode
integer x = 2629
integer y = 1920
integer width = 1454
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This report shows all TC Periods within ~'Selection Dates~'."
boolean focusrectangle = false
end type

type dw_startdate from datawindow within w_fin_report_tcperiode
integer x = 261
integer y = 2000
integer width = 306
integer height = 84
integer taborder = 10
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;cb_retrieve.postevent( clicked!)
end event

type dw_profit_center from datawindow within w_fin_report_tcperiode
integer x = 727
integer y = 1916
integer width = 773
integer height = 456
integer taborder = 30
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row > 0) then
	this.selectrow(row, NOT this.isselected(row))
	cb_retrieve.PostEvent( Clicked!)
end if

end event

type cb_2 from commandbutton within w_fin_report_tcperiode
integer x = 2999
integer y = 2272
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_tcperiode.Object.DataWindow.Footer.Height='68'
dw_tcperiode.print()
dw_tcperiode.Object.DataWindow.Footer.Height='0'

end event

type cb_1 from commandbutton within w_fin_report_tcperiode
integer x = 3753
integer y = 2272
integer width = 343
integer height = 100
integer taborder = 100
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

type dw_tcperiode from datawindow within w_fin_report_tcperiode
event ue_retrieve pbm_custom01
integer x = 14
integer y = 12
integer width = 4087
integer height = 1868
integer taborder = 70
string title = "none"
string dataobject = "d_fin_report_tcperiode"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	//	if right(ls_sort,1) = "A" then 
	//		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	//	else
	//		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	//	end if
	//	dwo.Tag = ls_sort
	//ls_type = dwo.type+" / "+dwo.name
	//MessageBox("Type + navn",ls_type)
	//MessageBox("getClickedCloumn",this.getClickedColumn())
end if

end event

event doubleclicked;integer li_vessel
double ld_contract_id
u_jump_tchire luo_jump

if row > 0 then
	luo_jump = CREATE u_jump_tchire
	li_vessel = this.getItemNumber(row, "vessel_nr")
	ld_contract_id = this.getItemNumber( row, "ntc_tc_contract_contract_id")
	luo_jump.of_open_tchire( li_vessel, ld_contract_id)
	DESTROY luo_jump
end if
end event

type gb_1 from groupbox within w_fin_report_tcperiode
integer x = 1609
integer y = 1896
integer width = 462
integer height = 360
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type Selection"
end type

type gb_2 from groupbox within w_fin_report_tcperiode
integer x = 46
integer y = 1900
integer width = 571
integer height = 380
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Selection"
end type

