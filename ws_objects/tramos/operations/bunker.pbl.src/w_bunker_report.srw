$PBExportHeader$w_bunker_report.srw
$PBExportComments$Window for bunker report. Let the user enter informations, retrieves the report and print it.
forward
global type w_bunker_report from window
end type
type cbx_exclude from checkbox within w_bunker_report
end type
type st_status from statictext within w_bunker_report
end type
type hpb_1 from hprogressbar within w_bunker_report
end type
type dw_finresp from datawindow within w_bunker_report
end type
type rb_finresp from radiobutton within w_bunker_report
end type
type rb_vessel from radiobutton within w_bunker_report
end type
type em_vessel from editmask within w_bunker_report
end type
type cb_vessel from commandbutton within w_bunker_report
end type
type cb_saveas from commandbutton within w_bunker_report
end type
type st_1 from statictext within w_bunker_report
end type
type dw_date from datawindow within w_bunker_report
end type
type st_2 from statictext within w_bunker_report
end type
type sle_rate from singlelineedit within w_bunker_report
end type
type cb_print from commandbutton within w_bunker_report
end type
type dw_report from datawindow within w_bunker_report
end type
type cb_retrieve from commandbutton within w_bunker_report
end type
type gb_1 from groupbox within w_bunker_report
end type
type gb_vessel from groupbox within w_bunker_report
end type
type gb_finresp from groupbox within w_bunker_report
end type
end forward

global type w_bunker_report from window
integer x = 1074
integer y = 484
integer width = 4613
integer height = 2640
boolean titlebar = true
string title = "Bunker Report"
boolean controlmenu = true
long backcolor = 81324524
boolean center = true
cbx_exclude cbx_exclude
st_status st_status
hpb_1 hpb_1
dw_finresp dw_finresp
rb_finresp rb_finresp
rb_vessel rb_vessel
em_vessel em_vessel
cb_vessel cb_vessel
cb_saveas cb_saveas
st_1 st_1
dw_date dw_date
st_2 st_2
sle_rate sle_rate
cb_print cb_print
dw_report dw_report
cb_retrieve cb_retrieve
gb_1 gb_1
gb_vessel gb_vessel
gb_finresp gb_finresp
end type
global w_bunker_report w_bunker_report

type variables

end variables

forward prototypes
private subroutine wf_filter ()
private subroutine wf_tcdeliveryports (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, long al_row)
end prototypes

private subroutine wf_filter ();string ls_filter

if cbx_exclude.checked then
	ls_filter = "NOT (dept_hfo=0 and dept_go=0 and dept_do=0 and dept_lshfo=0)"
else
	ls_filter = ""
end if

dw_report.setFilter(ls_filter)
dw_report.filter()
end subroutine

private subroutine wf_tcdeliveryports (integer ai_vessel, string as_voyage, string as_portcode, integer ai_pcn, long al_row);/*	Get the arrival bunker value if the bunker is not sold */
decimal {4} 	ld_exrate, ld_USD_value, ld_DKK_value
decimal {4}  ld_arr_hfo, ld_arr_do, ld_arr_go, ld_arr_lshfo
long			ll_counter

n_port_arrival_bunker_value	lnv_bunker
lnv_bunker = create n_port_arrival_bunker_value

ld_exrate = dec(sle_rate.text) 

SELECT count(*)
	INTO :ll_counter
	FROM BP_DETAILS
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn
	AND BUY_SELL = 1;
commit;
/* If the bunker is sold, ignore this portcall */
if ll_counter > 0 then return

SELECT ARR_HFO, ARR_DO, ARR_GO, ARR_LSHFO
	INTO :ld_arr_hfo, :ld_arr_do, :ld_arr_go, :ld_arr_lshfo
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn;
commit;

/* HFO */
if ld_arr_hfo <> 0 then
	lnv_bunker.of_calculate( "HFO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_hfo", ld_usd_value)
	ld_DKK_value = ld_USD_value * ld_exrate / 100
	dw_report.setItem(al_row, "DKK_value_hfo", ld_dkk_value)
	dw_report.setItem(al_row, "dept_hfo", ld_arr_hfo)
end if	
/* DO */
if ld_arr_do <> 0 then
	lnv_bunker.of_calculate( "DO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_do", ld_usd_value)
	ld_DKK_value = ld_USD_value * ld_exrate / 100
	dw_report.setItem(al_row, "DKK_value_do", ld_dkk_value)
	dw_report.setItem(al_row, "dept_do", ld_arr_do)
end if	
/* GO */
if ld_arr_go <> 0 then
	lnv_bunker.of_calculate( "GO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_go", ld_usd_value)
	ld_DKK_value = ld_USD_value * ld_exrate / 100
	dw_report.setItem(al_row, "DKK_value_go", ld_dkk_value)
	dw_report.setItem(al_row, "dept_go", ld_arr_go)
end if	
/* LSHFO */
if ld_arr_lshfo <> 0 then
	lnv_bunker.of_calculate( "LSHFO", ai_vessel, as_voyage, as_portcode, ai_pcn, ld_USD_value )
	dw_report.setItem(al_row, "USD_value_lshfo", ld_usd_value)
	ld_DKK_value = ld_USD_value * ld_exrate / 100
	dw_report.setItem(al_row, "DKK_value_lshfo", ld_dkk_value)
	dw_report.setItem(al_row, "dept_lshfo", ld_arr_lshfo)
end if	

destroy lnv_bunker
end subroutine

on w_bunker_report.create
this.cbx_exclude=create cbx_exclude
this.st_status=create st_status
this.hpb_1=create hpb_1
this.dw_finresp=create dw_finresp
this.rb_finresp=create rb_finresp
this.rb_vessel=create rb_vessel
this.em_vessel=create em_vessel
this.cb_vessel=create cb_vessel
this.cb_saveas=create cb_saveas
this.st_1=create st_1
this.dw_date=create dw_date
this.st_2=create st_2
this.sle_rate=create sle_rate
this.cb_print=create cb_print
this.dw_report=create dw_report
this.cb_retrieve=create cb_retrieve
this.gb_1=create gb_1
this.gb_vessel=create gb_vessel
this.gb_finresp=create gb_finresp
this.Control[]={this.cbx_exclude,&
this.st_status,&
this.hpb_1,&
this.dw_finresp,&
this.rb_finresp,&
this.rb_vessel,&
this.em_vessel,&
this.cb_vessel,&
this.cb_saveas,&
this.st_1,&
this.dw_date,&
this.st_2,&
this.sle_rate,&
this.cb_print,&
this.dw_report,&
this.cb_retrieve,&
this.gb_1,&
this.gb_vessel,&
this.gb_finresp}
end on

on w_bunker_report.destroy
destroy(this.cbx_exclude)
destroy(this.st_status)
destroy(this.hpb_1)
destroy(this.dw_finresp)
destroy(this.rb_finresp)
destroy(this.rb_vessel)
destroy(this.em_vessel)
destroy(this.cb_vessel)
destroy(this.cb_saveas)
destroy(this.st_1)
destroy(this.dw_date)
destroy(this.st_2)
destroy(this.sle_rate)
destroy(this.cb_print)
destroy(this.dw_report)
destroy(this.cb_retrieve)
destroy(this.gb_1)
destroy(this.gb_vessel)
destroy(this.gb_finresp)
end on

event open;datawindowchild	dwc

dw_date.insertrow(0)

dw_finresp.insertRow(0)
dw_finresp.getchild( "userid", dwc)
dwc.setTransObject(sqlca)
dwc.retrieve()

dw_report.setTransObject(sqlca)

end event

type cbx_exclude from checkbox within w_bunker_report
integer x = 3287
integer y = 2324
integer width = 608
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Exclude stock = 0 (zero)"
end type

event clicked;post wf_filter()
end event

type st_status from statictext within w_bunker_report
integer x = 41
integer y = 2208
integer width = 4539
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_bunker_report
integer x = 41
integer y = 2132
integer width = 4539
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type dw_finresp from datawindow within w_bunker_report
integer x = 2254
integer y = 2404
integer width = 905
integer height = 84
integer taborder = 60
boolean enabled = false
string title = "none"
string dataobject = "d_bunker_userid"
boolean livescroll = true
end type

type rb_finresp from radiobutton within w_bunker_report
integer x = 1102
integer y = 2448
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
string text = "Finance Resp."
end type

event clicked;if this.checked then
	gb_vessel.enabled = false
	em_vessel.enabled = false
	cb_vessel.enabled = false
	gb_finresp.enabled = true
	dw_finresp.enabled = true
end if
end event

type rb_vessel from radiobutton within w_bunker_report
integer x = 1106
integer y = 2372
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
string text = "Vessel"
boolean checked = true
end type

event clicked;if this.checked then
	gb_vessel.enabled = true
	em_vessel.enabled = true
	cb_vessel.enabled = true
	gb_finresp.enabled = false
	dw_finresp.enabled = false
end if
end event

type em_vessel from editmask within w_bunker_report
integer x = 1751
integer y = 2404
integer width = 155
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
maskdatatype maskdatatype = stringmask!
string mask = "aaa"
string minmax = "~~"
end type

type cb_vessel from commandbutton within w_bunker_report
integer x = 1943
integer y = 2400
integer width = 82
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;open(w_vessel_selection)
em_vessel.text = Message.StringParm


end event

type cb_saveas from commandbutton within w_bunker_report
integer x = 4187
integer y = 2424
integer width = 389
integer height = 108
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&SaveAs..."
end type

event clicked;dw_report.SaveAs()
end event

type st_1 from statictext within w_bunker_report
integer x = 37
integer y = 2352
integer width = 466
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Last Departure Date:"
boolean focusrectangle = false
end type

type dw_date from datawindow within w_bunker_report
integer x = 649
integer y = 2344
integer width = 297
integer height = 84
integer taborder = 10
string dataobject = "d_date"
boolean livescroll = true
end type

type st_2 from statictext within w_bunker_report
integer x = 37
integer y = 2460
integer width = 613
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Exchange Rate (DKR/USD):"
boolean focusrectangle = false
end type

type sle_rate from singlelineedit within w_bunker_report
integer x = 649
integer y = 2452
integer width = 297
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
end type

type cb_print from commandbutton within w_bunker_report
integer x = 3735
integer y = 2424
integer width = 389
integer height = 108
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_report.print(true)
end event

type dw_report from datawindow within w_bunker_report
integer x = 41
integer y = 32
integer width = 4539
integer height = 2068
integer taborder = 100
string dataobject = "d_sp_tb_bunker_stock_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_retrieve from commandbutton within w_bunker_report
integer x = 3282
integer y = 2424
integer width = 389
integer height = 108
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;long			ll_rows, ll_row
integer		li_vessel, li_calc_vessel, li_calc_pcn
string		ls_finresp, ls_voyageyear, ls_header, ls_calc_voyage, ls_calc_portcode, ls_purpose
datetime		ldt_date
decimal{4}	ld_exrate, ld_USD_value, ld_DKK_value
n_port_departure_bunker_value	lnv_bunker
transaction	mytrans

dw_date.accepttext()
dw_finresp.accepttext( )

if isNull(dw_date.getItemDate(1, "date_value")) then 
	MessageBox("Validation error", "Please enter Last Departure Date.")
	dw_date.post setFocus()
	return
end if
//ldt_date =  datetime(dw_date.GetItemDate(1,"date_value"),time(23,59,59))
ldt_date =  datetime(dw_date.GetItemDate(1,"date_value"))
ls_voyageyear = string(dw_date.GetItemDate(1, "date_value"), "YY")

/* Change data element and validation */
if rb_vessel.checked then
	if isnull(em_vessel.text) or len(em_vessel.text) = 0 then
		setNull(li_vessel)
		setNull(ls_finresp)
	else
		SELECT VESSEL_NR INTO :li_vessel FROM VESSELS WHERE VESSEL_REF_NR = :em_vessel.text commit;
		setNull(ls_finresp)
	end if	
else
	if isNull(dw_finresp.getItemString(1, "userid")) then 
		MessageBox("Validation error", "Please enter Finance Responsible.")
		dw_finresp.post setFocus()
		return
	end if
	 ls_finresp = dw_finresp.getItemString(1, "userid")
	 setNull(li_vessel)
end if

dw_report.reset()
/* Build header */
ls_header = "Bunker Stock at departure, Finished voyages until "+ string(ldt_date, "dd/mm-yy hh:mm") 
if isNull(li_vessel) and isnull(ls_finresp) then
	ls_header += " (All)"
elseif isNull(li_vessel) then
	ls_header += " (Fin.Resp. "+ls_finresp+")"
elseif isNull(ls_finresp) then
	ls_header += " ( Vessel "+em_vessel.text+")"
end if	
dw_report.Object.t_header.Text = ls_header
dw_report.Object.t_exrate.Text = "Exchange Rate: "+sle_rate.text
ld_exrate = dec(sle_rate.text) 

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
ll_rows = dw_report.retrieve(li_vessel, ls_finresp, ldt_date, ls_voyageyear )
disconnect using mytrans;
destroy mytrans;
ll_rows = dw_report.rowCount() 
st_status.text = string(ll_rows) + " rows retrieved..."

if ll_rows < 1 then return 

/* Calculate */
lnv_bunker = create n_port_departure_bunker_value
hpb_1.maxposition = ll_rows
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
		commit;
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
			ld_DKK_value = ld_USD_value * ld_exrate / 100
			dw_report.setItem(ll_row, "DKK_value_hfo", ld_dkk_value)
		end if	
		/* DO */
		if dw_report.getItemNumber(ll_row, "dept_do") <> 0 then
			lnv_bunker.of_calculate( "DO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_do", ld_usd_value)
			ld_DKK_value = ld_USD_value * ld_exrate / 100
			dw_report.setItem(ll_row, "DKK_value_do", ld_dkk_value)
		end if	
		/* GO */
		if dw_report.getItemNumber(ll_row, "dept_go") <> 0 then
			lnv_bunker.of_calculate( "GO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_go", ld_usd_value)
			ld_DKK_value = ld_USD_value * ld_exrate / 100
			dw_report.setItem(ll_row, "DKK_value_go", ld_dkk_value)
		end if	
		/* LSHFO */
		if dw_report.getItemNumber(ll_row, "dept_lshfo") <> 0 then
			lnv_bunker.of_calculate( "LSHFO", li_calc_vessel, ls_calc_voyage, ls_calc_portcode, li_calc_pcn, ld_USD_value )
			dw_report.setItem(ll_row, "USD_value_lshfo", ld_usd_value)
			ld_DKK_value = ld_USD_value * ld_exrate / 100
			dw_report.setItem(ll_row, "DKK_value_lshfo", ld_dkk_value)
		end if	
	end if
next
destroy lnv_bunker

post wf_filter()

st_status.text = "Report generated..."

end event

type gb_1 from groupbox within w_bunker_report
integer x = 1065
integer y = 2312
integer width = 489
integer height = 228
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Criteria"
end type

type gb_vessel from groupbox within w_bunker_report
integer x = 1646
integer y = 2312
integer width = 489
integer height = 228
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Number"
end type

type gb_finresp from groupbox within w_bunker_report
integer x = 2222
integer y = 2312
integer width = 974
integer height = 228
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Finance Responsible"
end type

