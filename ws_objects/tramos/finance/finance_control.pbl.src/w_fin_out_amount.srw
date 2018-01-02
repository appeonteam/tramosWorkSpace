$PBExportHeader$w_fin_out_amount.srw
forward
global type w_fin_out_amount from mt_w_sheet
end type
type sle_type from singlelineedit within w_fin_out_amount
end type
type st_10 from statictext within w_fin_out_amount
end type
type cb_saveas from commandbutton within w_fin_out_amount
end type
type sle_vsl_nr from singlelineedit within w_fin_out_amount
end type
type st_9 from statictext within w_fin_out_amount
end type
type sle_days from singlelineedit within w_fin_out_amount
end type
type cb_retrieve from commandbutton within w_fin_out_amount
end type
type st_8 from statictext within w_fin_out_amount
end type
type st_7 from statictext within w_fin_out_amount
end type
type sle_profit from singlelineedit within w_fin_out_amount
end type
type cb_print from commandbutton within w_fin_out_amount
end type
type cb_1 from commandbutton within w_fin_out_amount
end type
type sle_broker from singlelineedit within w_fin_out_amount
end type
type st_6 from statictext within w_fin_out_amount
end type
type sle_chart from singlelineedit within w_fin_out_amount
end type
type st_5 from statictext within w_fin_out_amount
end type
type sle_vsl_name from singlelineedit within w_fin_out_amount
end type
type st_4 from statictext within w_fin_out_amount
end type
type st_3 from statictext within w_fin_out_amount
end type
type em_pct from editmask within w_fin_out_amount
end type
type em_amount from editmask within w_fin_out_amount
end type
type cb_search from commandbutton within w_fin_out_amount
end type
type st_2 from statictext within w_fin_out_amount
end type
type st_1 from statictext within w_fin_out_amount
end type
type st_row from statictext within w_fin_out_amount
end type
type dw_fin_out_amount from datawindow within w_fin_out_amount
end type
type gb_1 from groupbox within w_fin_out_amount
end type
end forward

global type w_fin_out_amount from mt_w_sheet
integer width = 4571
integer height = 2632
string title = "Outstanding Amounts"
boolean maxbox = false
boolean resizable = false
boolean center = false
sle_type sle_type
st_10 st_10
cb_saveas cb_saveas
sle_vsl_nr sle_vsl_nr
st_9 st_9
sle_days sle_days
cb_retrieve cb_retrieve
st_8 st_8
st_7 st_7
sle_profit sle_profit
cb_print cb_print
cb_1 cb_1
sle_broker sle_broker
st_6 st_6
sle_chart sle_chart
st_5 st_5
sle_vsl_name sle_vsl_name
st_4 st_4
st_3 st_3
em_pct em_pct
em_amount em_amount
cb_search cb_search
st_2 st_2
st_1 st_1
st_row st_row
dw_fin_out_amount dw_fin_out_amount
gb_1 gb_1
end type
global w_fin_out_amount w_fin_out_amount

type variables
u_jump_claims iuo_jump_claims
u_jump_actions_trans iuo_jump_actions_trans
n_jump_specialclaims ino_jump_specialclaims
end variables

forward prototypes
public function string of_build_filter ()
public subroutine wf_gotoclaims ()
public subroutine documentation ()
public subroutine wf_gotospecialclaims ()
end prototypes

public function string of_build_filter ();string ls_filter
decimal{2} ld_amount_start, ld_amount_end

// Filter for amount
if dec(em_amount.text) > 0 then
	if dec(em_pct.text) > 0 then
		ld_amount_start = dec(em_amount.text) * (1 - (dec(em_pct.text)/100))
		ld_amount_end = dec(em_amount.text) * (1 + (dec(em_pct.text)/100))
		ls_filter = "out_amount > " + string(ld_amount_start) + " and out_amount < " + string(ld_amount_end)
	else
		ls_filter = "out_amount = " + em_amount.text
	end if
else
	ls_filter = ""
end if

// Vessel number



//	dw_fin_out_amount.setfilter(ls_filter)
//	dw_fin_out_amount.filter()
//	st_row.text = "Rows: " + string(dw_fin_out_amount.rowcount())



















return ls_filter
end function

public subroutine wf_gotoclaims ();string ls_voyage_nr, ls_claim_type
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr

li_vessel_nr 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "claims_vessel_nr")
ls_voyage_nr 	= dw_fin_out_amount.getitemstring(dw_fin_out_amount.getrow(), "claims_voyage_nr")
ll_chart_nr	 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "chart_opponent_no")
ll_claim_nr	 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "claims_claim_nr")
ls_claim_type	= dw_fin_out_amount.getitemstring(dw_fin_out_amount.getrow(), "claims_claim_type")

if (ls_claim_type = 'FRT') then
	iuo_jump_claims.of_open_claims(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
else
	iuo_jump_actions_trans.of_open_actions_trans(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
end if
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14 CR3781     CCY018        	    Modified ancestor and the window title match with the text of a menu item
	13/06/16	 CR4034     CCY018        	Show special claims data
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_gotospecialclaims ();/********************************************************************
   wf_gotospecialclaims
   <DESC>open the special claim window</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13/06/16		CR4034            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_special_claim_id, ll_row

ll_row = dw_fin_out_amount.getrow()
if ll_row > 0 then
	ll_special_claim_id	 = dw_fin_out_amount.getitemnumber(ll_row, "claims_claim_nr")
	ino_jump_specialclaims.of_open_specialclaims(ll_special_claim_id)
end if
end subroutine

on w_fin_out_amount.create
int iCurrent
call super::create
this.sle_type=create sle_type
this.st_10=create st_10
this.cb_saveas=create cb_saveas
this.sle_vsl_nr=create sle_vsl_nr
this.st_9=create st_9
this.sle_days=create sle_days
this.cb_retrieve=create cb_retrieve
this.st_8=create st_8
this.st_7=create st_7
this.sle_profit=create sle_profit
this.cb_print=create cb_print
this.cb_1=create cb_1
this.sle_broker=create sle_broker
this.st_6=create st_6
this.sle_chart=create sle_chart
this.st_5=create st_5
this.sle_vsl_name=create sle_vsl_name
this.st_4=create st_4
this.st_3=create st_3
this.em_pct=create em_pct
this.em_amount=create em_amount
this.cb_search=create cb_search
this.st_2=create st_2
this.st_1=create st_1
this.st_row=create st_row
this.dw_fin_out_amount=create dw_fin_out_amount
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_type
this.Control[iCurrent+2]=this.st_10
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.sle_vsl_nr
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.sle_days
this.Control[iCurrent+7]=this.cb_retrieve
this.Control[iCurrent+8]=this.st_8
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.sle_profit
this.Control[iCurrent+11]=this.cb_print
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.sle_broker
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.sle_chart
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.sle_vsl_name
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.em_pct
this.Control[iCurrent+21]=this.em_amount
this.Control[iCurrent+22]=this.cb_search
this.Control[iCurrent+23]=this.st_2
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.st_row
this.Control[iCurrent+26]=this.dw_fin_out_amount
this.Control[iCurrent+27]=this.gb_1
end on

on w_fin_out_amount.destroy
call super::destroy
destroy(this.sle_type)
destroy(this.st_10)
destroy(this.cb_saveas)
destroy(this.sle_vsl_nr)
destroy(this.st_9)
destroy(this.sle_days)
destroy(this.cb_retrieve)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.sle_profit)
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.sle_broker)
destroy(this.st_6)
destroy(this.sle_chart)
destroy(this.st_5)
destroy(this.sle_vsl_name)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.em_pct)
destroy(this.em_amount)
destroy(this.cb_search)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_row)
destroy(this.dw_fin_out_amount)
destroy(this.gb_1)
end on

event open;call super::open;dw_fin_out_amount.settransobject(SQLCA)
dw_fin_out_amount.setrowfocusindicator(FOCUSRECT!)
cb_retrieve.POST Event Clicked()

iuo_jump_claims = CREATE u_jump_claims
iuo_jump_actions_trans = CREATE u_jump_actions_trans
ino_jump_specialclaims = create n_jump_specialclaims

end event

event close;destroy iuo_jump_claims
destroy iuo_jump_actions_trans
destroy ino_jump_specialclaims

end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_fin_out_amount
end type

type sle_type from singlelineedit within w_fin_out_amount
integer x = 2016
integer y = 2236
integer width = 320
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_fin_out_amount
integer x = 1874
integer y = 2264
integer width = 151
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type:"
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_fin_out_amount
integer x = 3785
integer y = 2424
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

event clicked;dw_fin_out_amount.saveas()
end event

type sle_vsl_nr from singlelineedit within w_fin_out_amount
integer x = 1047
integer y = 2236
integer width = 165
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
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_fin_out_amount
integer x = 1486
integer y = 2440
integer width = 137
integer height = 60
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

type sle_days from singlelineedit within w_fin_out_amount
integer x = 1330
integer y = 2432
integer width = 146
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type cb_retrieve from commandbutton within w_fin_out_amount
integer x = 1655
integer y = 2424
integer width = 343
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;integer	li_days

li_days = integer(sle_days.text)
dw_fin_out_amount.retrieve(datetime(relativedate(today(), li_days)))

st_row.text = "Rows: " + string(dw_fin_out_amount.rowcount())

end event

type st_8 from statictext within w_fin_out_amount
integer x = 46
integer y = 2444
integer width = 1358
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Includes outstanding TC payments with due date today + "
boolean focusrectangle = false
end type

type st_7 from statictext within w_fin_out_amount
integer x = 3739
integer y = 2264
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit center:"
boolean focusrectangle = false
end type

type sle_profit from singlelineedit within w_fin_out_amount
integer x = 4032
integer y = 2236
integer width = 466
integer height = 84
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_fin_out_amount
integer x = 3378
integer y = 2424
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_fin_out_amount.Object.DataWindow.Print.orientation = 1
dw_fin_out_amount.print()
end event

type cb_1 from commandbutton within w_fin_out_amount
integer x = 4192
integer y = 2424
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

type sle_broker from singlelineedit within w_fin_out_amount
integer x = 3250
integer y = 2236
integer width = 466
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_fin_out_amount
integer x = 3086
integer y = 2264
integer width = 183
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Broker:"
boolean focusrectangle = false
end type

type sle_chart from singlelineedit within w_fin_out_amount
integer x = 2597
integer y = 2236
integer width = 466
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_fin_out_amount
integer x = 2359
integer y = 2264
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charterer:"
boolean focusrectangle = false
end type

type sle_vsl_name from singlelineedit within w_fin_out_amount
integer x = 1390
integer y = 2236
integer width = 466
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_fin_out_amount
integer x = 1248
integer y = 2264
integer width = 169
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Name:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_fin_out_amount
integer x = 777
integer y = 2264
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel nr.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_pct from editmask within w_fin_out_amount
integer x = 471
integer y = 2236
integer width = 210
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "5.0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0.00"
end type

type em_amount from editmask within w_fin_out_amount
integer x = 87
integer y = 2236
integer width = 279
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,###,##0.00"
end type

type cb_search from commandbutton within w_fin_out_amount
integer x = 2926
integer y = 2424
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Filter"
end type

event clicked;string ls_filter = ""
decimal{2} ld_amount_start, ld_amount_end

// Add on to filter for amount

if dec(em_amount.text) > 0 then
	if dec(em_pct.text) > 0 then
		ld_amount_start = dec(em_amount.text) * (1 - (dec(em_pct.text)/100))
		ld_amount_end = dec(em_amount.text) * (1 + (dec(em_pct.text)/100))
		ls_filter = "out_amount_usd > " + string(ld_amount_start) + " and out_amount_usd < " + string(ld_amount_end)
	else
		ls_filter = "out_amount_usd = " + em_amount.text
	end if
else
	ls_filter = ""
end if

// VESSEL NUMBER
if (len(sle_vsl_nr.text) <> 0 and not isnull (sle_vsl_nr.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(vessel_ref_nr), lower('" + sle_vsl_nr.text+"'))"
end if

// VESSEL NAME
if (len(sle_vsl_name.text) <> 0 and not isnull (sle_vsl_name.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(vessels_vessel_name), lower('" + sle_vsl_name.text + "'))"
end if

// TYPE
if (len(sle_type.text) <> 0 and not isnull (sle_type.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(claims_claim_type), lower('" + sle_type.text + "'))"
end if

// CHARTERER NAME
if (len(sle_chart.text) <> 0 and not isnull (sle_chart.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(chart_opponent_name), lower('" + sle_chart.text + "'))"
end if

// BROKER NAME
if (len(sle_broker.text) <> 0 and not isnull (sle_broker.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(brokers_broker_name), lower('" + sle_broker.text + "'))"
end if

// PROFIT CENTER
if (len(sle_profit.text) <> 0 and not isnull (sle_profit.text))  then 
	if (len(ls_filter) > 0) then
		ls_filter += " and "
	end if
	ls_filter += "match(lower(profit_c_pc_name), lower('" + sle_profit.text + "'))"
end if

dw_fin_out_amount.setfilter(ls_filter)
dw_fin_out_amount.filter()
st_row.text = "Rows: " + string(dw_fin_out_amount.rowcount())


end event

type st_2 from statictext within w_fin_out_amount
integer x = 686
integer y = 2248
integer width = 78
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "%"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fin_out_amount
integer x = 379
integer y = 2248
integer width = 87
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "+/-"
boolean focusrectangle = false
end type

type st_row from statictext within w_fin_out_amount
integer x = 4078
integer y = 2104
integer width = 430
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_fin_out_amount from datawindow within w_fin_out_amount
integer x = 37
integer y = 28
integer width = 4475
integer height = 2060
integer taborder = 10
string title = "none"
string dataobject = "d_fin_out_amount"
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

event doubleclicked;string ls_type

if (row > 0) then
	ls_type = dw_fin_out_amount.getitemstring(row, "claims_claim_type")
	
	if ls_type <> "TC-OUT" and ls_type <> "SPEC" then
		wf_gotoclaims()
		
	elseif ls_type = "TC-OUT" then
		OpenSheetWithParm(w_tc_payments, dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(),&
							"contract_id"), w_tramos_main, 7, Original!)
	elseif ls_type = "SPEC" then
		wf_gotospecialclaims( )
	end if
end if
end event

type gb_1 from groupbox within w_fin_out_amount
integer x = 37
integer y = 2148
integer width = 4503
integer height = 232
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search"
end type

