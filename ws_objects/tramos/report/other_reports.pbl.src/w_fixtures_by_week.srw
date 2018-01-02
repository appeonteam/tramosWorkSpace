$PBExportHeader$w_fixtures_by_week.srw
$PBExportComments$This report is initiated from Smalltankers, can by used by all profitcenters. Can show fixtures for one week or year to week.
forward
global type w_fixtures_by_week from mt_w_main
end type
type dw_report from mt_u_datawindow within w_fixtures_by_week
end type
type st_3 from statictext within w_fixtures_by_week
end type
type st_2 from statictext within w_fixtures_by_week
end type
type em_year from editmask within w_fixtures_by_week
end type
type cb_print from commandbutton within w_fixtures_by_week
end type
type cb_retrieve from commandbutton within w_fixtures_by_week
end type
type cb_saveas from commandbutton within w_fixtures_by_week
end type
type dw_profit_center from mt_u_datawindow within w_fixtures_by_week
end type
type st_1 from statictext within w_fixtures_by_week
end type
type em_week from editmask within w_fixtures_by_week
end type
type rb_oneweek from radiobutton within w_fixtures_by_week
end type
type rb_yeartoweek from radiobutton within w_fixtures_by_week
end type
type cbx_spot from checkbox within w_fixtures_by_week
end type
type cbx_coa_fixedrate from checkbox within w_fixtures_by_week
end type
type cbx_coa_marketrate from checkbox within w_fixtures_by_week
end type
type cbx_cvs_fixedrate from checkbox within w_fixtures_by_week
end type
type cbx_cvs_marketrate from checkbox within w_fixtures_by_week
end type
type cbx_tcout from checkbox within w_fixtures_by_week
end type
type rb_profit_center from mt_u_radiobutton within w_fixtures_by_week
end type
type rb_shiptype from mt_u_radiobutton within w_fixtures_by_week
end type
type gb_1 from groupbox within w_fixtures_by_week
end type
type gb_grouplist from mt_u_groupbox within w_fixtures_by_week
end type
type gb_2 from mt_u_groupbox within w_fixtures_by_week
end type
type gb_3 from mt_u_groupbox within w_fixtures_by_week
end type
type st_4 from u_topbar_background within w_fixtures_by_week
end type
end forward

global type w_fixtures_by_week from mt_w_main
integer width = 3186
integer height = 2560
string title = "Weekly Fixtures by Profit Center/Week"
boolean maxbox = false
boolean resizable = false
boolean center = false
dw_report dw_report
st_3 st_3
st_2 st_2
em_year em_year
cb_print cb_print
cb_retrieve cb_retrieve
cb_saveas cb_saveas
dw_profit_center dw_profit_center
st_1 st_1
em_week em_week
rb_oneweek rb_oneweek
rb_yeartoweek rb_yeartoweek
cbx_spot cbx_spot
cbx_coa_fixedrate cbx_coa_fixedrate
cbx_coa_marketrate cbx_coa_marketrate
cbx_cvs_fixedrate cbx_cvs_fixedrate
cbx_cvs_marketrate cbx_cvs_marketrate
cbx_tcout cbx_tcout
rb_profit_center rb_profit_center
rb_shiptype rb_shiptype
gb_1 gb_1
gb_grouplist gb_grouplist
gb_2 gb_2
gb_3 gb_3
st_4 st_4
end type
global w_fixtures_by_week w_fixtures_by_week

type variables
integer	ii_profitcenter[]

end variables

forward prototypes
public subroutine wf_filter ()
public subroutine documentation ()
end prototypes

public subroutine wf_filter ();string ls_filter

if cbx_spot.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "1"
end if

if cbx_coa_fixedrate.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "2"
end if

if  cbx_coa_marketrate.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "7"
end if

if cbx_cvs_fixedrate.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "3"
end if

if cbx_cvs_marketrate.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "8"
end if

if cbx_tcout.checked then
	if len(ls_filter) > 0 then ls_filter += ", "
	ls_filter += "5"
end if

if len(ls_filter) = 0 then
	ls_filter = "cal_cerp_cal_cerp_contract_type = 99999999999"  //equals no contract shown
else
	ls_filter = "cal_cerp_cal_cerp_contract_type in (" + ls_filter + ")"
end if

dw_report.setfilter(ls_filter)
dw_report.filter()

return 
end subroutine

public subroutine documentation ();/******************************************************************************
Date   		Ref   	Author         Comments
27/07/11 	CR2338	WWG004			Add a new feature that users can change the 
												grouping display of the report.
01/09/14		CR3781	CCY018			The window title match with the text of a menu item										  
******************************************************************************/
end subroutine

on w_fixtures_by_week.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.st_3=create st_3
this.st_2=create st_2
this.em_year=create em_year
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.dw_profit_center=create dw_profit_center
this.st_1=create st_1
this.em_week=create em_week
this.rb_oneweek=create rb_oneweek
this.rb_yeartoweek=create rb_yeartoweek
this.cbx_spot=create cbx_spot
this.cbx_coa_fixedrate=create cbx_coa_fixedrate
this.cbx_coa_marketrate=create cbx_coa_marketrate
this.cbx_cvs_fixedrate=create cbx_cvs_fixedrate
this.cbx_cvs_marketrate=create cbx_cvs_marketrate
this.cbx_tcout=create cbx_tcout
this.rb_profit_center=create rb_profit_center
this.rb_shiptype=create rb_shiptype
this.gb_1=create gb_1
this.gb_grouplist=create gb_grouplist
this.gb_2=create gb_2
this.gb_3=create gb_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_retrieve
this.Control[iCurrent+7]=this.cb_saveas
this.Control[iCurrent+8]=this.dw_profit_center
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.em_week
this.Control[iCurrent+11]=this.rb_oneweek
this.Control[iCurrent+12]=this.rb_yeartoweek
this.Control[iCurrent+13]=this.cbx_spot
this.Control[iCurrent+14]=this.cbx_coa_fixedrate
this.Control[iCurrent+15]=this.cbx_coa_marketrate
this.Control[iCurrent+16]=this.cbx_cvs_fixedrate
this.Control[iCurrent+17]=this.cbx_cvs_marketrate
this.Control[iCurrent+18]=this.cbx_tcout
this.Control[iCurrent+19]=this.rb_profit_center
this.Control[iCurrent+20]=this.rb_shiptype
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_grouplist
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.st_4
end on

on w_fixtures_by_week.destroy
call super::destroy
destroy(this.dw_report)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.dw_profit_center)
destroy(this.st_1)
destroy(this.em_week)
destroy(this.rb_oneweek)
destroy(this.rb_yeartoweek)
destroy(this.cbx_spot)
destroy(this.cbx_coa_fixedrate)
destroy(this.cbx_coa_marketrate)
destroy(this.cbx_cvs_fixedrate)
destroy(this.cbx_cvs_marketrate)
destroy(this.cbx_tcout)
destroy(this.rb_profit_center)
destroy(this.rb_shiptype)
destroy(this.gb_1)
destroy(this.gb_grouplist)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.st_4)
end on

event open;integer 	li_weeknumber

//CR2338 begin added by WWG004 on 27/07/2011. 
//Change window background color and two editmask backcolor from blank to blue.
n_service_manager		lnv_manager
n_gui_style_service	lnv_guistyle

lnv_manager.of_loadservice(lnv_guistyle, "n_gui_style_service")
lnv_guistyle.of_setdefaultbackgroundcolor(this)

em_year.backcolor = c#color.MT_MAERSK
em_week.backcolor = c#color.MT_MAERSK
//CR2338 end added by WWG004 on 27/07/2011. 

move(0,0)

em_year.text = string(year(today()))

SELECT DATEPART(CWK, GETDATE())
  INTO :li_weeknumber
  FROM POC;
em_week.text = string(li_weeknumber)	

dw_report.settransobject(SQLCA)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_fixtures_by_week
end type

type dw_report from mt_u_datawindow within w_fixtures_by_week
integer x = 37
integer y = 624
integer width = 3104
integer height = 1696
integer taborder = 140
string dataobject = "d_fixtures_by_week"
boolean vscrollbar = true
boolean border = false
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
	
	//CR2338 added by WWG004 on 05/08/2011.
	//Recalculate group.
	this.groupcalc()
end if


end event

type st_3 from statictext within w_fixtures_by_week
integer x = 1376
integer y = 80
integer width = 165
integer height = 56
boolean bringtotop = true
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

type st_2 from statictext within w_fixtures_by_week
integer x = 933
integer y = 80
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Voyage year selection"
boolean focusrectangle = false
end type

type em_year from editmask within w_fixtures_by_week
integer x = 1234
integer y = 80
integer width = 137
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
double increment = 1
string minmax = "1995~~2020"
end type

type cb_print from commandbutton within w_fixtures_by_week
integer x = 2807
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 170
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

type cb_retrieve from commandbutton within w_fixtures_by_week
integer x = 2112
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;long	 		ll_year, ll_week
decimal{2}	ld_pct
string 		ls_filter_condition

/* validate and retrieve */
/* Profitcenter or Shiptype*/
if upperbound(ii_profitcenter) = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter")
	dw_profit_center.post setFocus()
	return
end if

/* Year */
if isNull(em_year.text) then
	MessageBox("Validation Error", "Please enter a Year")
	em_year.post setFocus()
	return
end if
ll_year = long(em_year.text)

/* Week */
if isNull(em_week.text) then
	MessageBox("Validation Error", "Please enter a Week")
	em_year.post setFocus()
	return
end if
ll_week = long(em_week.text)

if not cbx_spot.checked and not cbx_coa_fixedrate.checked and not cbx_coa_marketrate.checked and not cbx_cvs_fixedrate.checked and not cbx_cvs_marketrate.checked and not cbx_tcout.checked then
	MessageBox("Validation Error", "Please enter a Contract Type")
	cbx_spot.setfocus()
	return
end if

wf_filter()

if rb_oneweek.checked then
	dw_report.retrieve(ll_year, ll_week, ll_week, ii_profitcenter)
else
	dw_report.retrieve(ll_year, 1, ll_week, ii_profitcenter)
end if	

commit;
end event

type cb_saveas from commandbutton within w_fixtures_by_week
integer x = 2459
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 160
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

type dw_profit_center from mt_u_datawindow within w_fixtures_by_week
integer x = 73
integer y = 80
integer width = 786
integer height = 448
integer taborder = 10
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
end type

event clicked;integer li_empty[]
integer li_x, li_count

if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row, false)
	else
		this.selectrow(row, true)
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

type st_1 from statictext within w_fixtures_by_week
integer x = 969
integer y = 224
integer width = 219
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

type em_week from editmask within w_fixtures_by_week
integer x = 1170
integer y = 224
integer width = 101
integer height = 56
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
double increment = 1
string minmax = "1~~53"
end type

type rb_oneweek from radiobutton within w_fixtures_by_week
integer x = 969
integer y = 304
integer width = 329
integer height = 56
integer taborder = 40
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

type rb_yeartoweek from radiobutton within w_fixtures_by_week
integer x = 969
integer y = 384
integer width = 402
integer height = 56
integer taborder = 50
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

type cbx_spot from checkbox within w_fixtures_by_week
integer x = 1975
integer y = 80
integer width = 453
integer height = 56
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "SPOT"
boolean checked = true
end type

event clicked;wf_filter()
end event

type cbx_coa_fixedrate from checkbox within w_fixtures_by_week
integer x = 1975
integer y = 160
integer width = 453
integer height = 56
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "COA Fixed rate"
boolean checked = true
end type

event clicked;wf_filter()
end event

type cbx_coa_marketrate from checkbox within w_fixtures_by_week
integer x = 1975
integer y = 240
integer width = 453
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
string text = "COA Market rate"
boolean checked = true
end type

event clicked;wf_filter()
end event

type cbx_cvs_fixedrate from checkbox within w_fixtures_by_week
integer x = 2450
integer y = 160
integer width = 453
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
string text = "CVS Fixed rate"
boolean checked = true
end type

event clicked;wf_filter()
end event

type cbx_cvs_marketrate from checkbox within w_fixtures_by_week
integer x = 2450
integer y = 80
integer width = 453
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
string text = "CVS Market rate"
boolean checked = true
end type

event clicked;wf_filter()
end event

type cbx_tcout from checkbox within w_fixtures_by_week
integer x = 1975
integer y = 320
integer width = 453
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
string text = "T/C Out"
boolean checked = true
end type

event clicked;wf_filter()
end event

type rb_profit_center from mt_u_radiobutton within w_fixtures_by_week
integer x = 1445
integer y = 224
integer width = 457
integer height = 56
integer taborder = 60
long textcolor = 16777215
long backcolor = 553648127
string text = "by Profit Center"
boolean checked = true
end type

event clicked;call super::clicked;//CR2338 added by WWG004 on 27/07/2011. 
//Change group condition as profit center, and change the visible and invible columns.
if this.checked then
	dw_report.object.vessels_vessel_name_t.text = "Profit Center / Vessel"
	dw_report.object.profit_c_pc_nr.visible = true
	dw_report.object.profit_c_pc_name.visible = true
	dw_report.object.cal_vest_type_id.visible = false
	dw_report.object.cal_vest_type_name.visible = false
	
	dw_report.setsort("profit_c_pc_nr ASC, week ASC")
	dw_report.sort()
	
	dw_report.modify("groupby.expression = 'profit_c_pc_nr'")
	dw_report.groupcalc()
end if
end event

type rb_shiptype from mt_u_radiobutton within w_fixtures_by_week
integer x = 1445
integer y = 304
integer width = 407
integer height = 56
integer taborder = 70
long textcolor = 16777215
long backcolor = 553648127
string text = "by Ship Type"
end type

event clicked;call super::clicked;//CR2338 added by WWG004 on 27/07/2011. 
////Change group condition as ship type, and change the visible and invible columns.
if this.checked then
	dw_report.object.vessels_vessel_name_t.text = "Ship Type / Vessel"
	dw_report.object.profit_c_pc_nr.visible = false
	dw_report.object.profit_c_pc_name.visible = false
	dw_report.object.cal_vest_type_id.visible = true
	dw_report.object.cal_vest_type_name.visible = true
	
	dw_report.setsort("cal_vest_type_id ASC, week ASC")
	dw_report.sort()
	
	dw_report.modify("groupby.expression = 'cal_vest_type_id'")
	dw_report.groupcalc()
end if
end event

type gb_1 from groupbox within w_fixtures_by_week
integer x = 933
integer y = 160
integer width = 439
integer height = 304
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Week"
end type

type gb_grouplist from mt_u_groupbox within w_fixtures_by_week
integer x = 1408
integer y = 160
integer width = 494
integer height = 224
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Group List"
end type

type gb_2 from mt_u_groupbox within w_fixtures_by_week
integer x = 37
integer y = 16
integer width = 859
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type gb_3 from mt_u_groupbox within w_fixtures_by_week
integer x = 1938
integer y = 16
integer width = 969
integer height = 384
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Contract Type(s)"
end type

type st_4 from u_topbar_background within w_fixtures_by_week
integer width = 3177
integer height = 592
end type

