$PBExportHeader$w_report_spot_contracts.srw
$PBExportComments$TC/Day for a given profitcenter and period
forward
global type w_report_spot_contracts from mt_w_main
end type
type hpb_vessels from hprogressbar within w_report_spot_contracts
end type
type st_pcdata from statictext within w_report_spot_contracts
end type
type cbx_selectall from checkbox within w_report_spot_contracts
end type
type sle_tcout_days from singlelineedit within w_report_spot_contracts
end type
type st_6 from statictext within w_report_spot_contracts
end type
type cbx_tcout_lower from checkbox within w_report_spot_contracts
end type
type cbx_tcout_bigger from checkbox within w_report_spot_contracts
end type
type gb_3 from groupbox within w_report_spot_contracts
end type
type rb_beforedrc from radiobutton within w_report_spot_contracts
end type
type rb_gross from radiobutton within w_report_spot_contracts
end type
type gb_2 from groupbox within w_report_spot_contracts
end type
type cbx_tcout from checkbox within w_report_spot_contracts
end type
type cbx_spot from checkbox within w_report_spot_contracts
end type
type cbx_cvs_marketrate from checkbox within w_report_spot_contracts
end type
type cbx_cvs_fixedrate from checkbox within w_report_spot_contracts
end type
type cbx_coa_marketrate from checkbox within w_report_spot_contracts
end type
type cbx_coa_fixedrate from checkbox within w_report_spot_contracts
end type
type dw_vas_report from mt_u_datawindow within w_report_spot_contracts
end type
type cbx_showdetail from checkbox within w_report_spot_contracts
end type
type dw_vessellist from mt_u_datawindow within w_report_spot_contracts
end type
type cb_saveas from commandbutton within w_report_spot_contracts
end type
type cb_print from commandbutton within w_report_spot_contracts
end type
type dw_tce_report from mt_u_datawindow within w_report_spot_contracts
end type
type cb_retrieve from commandbutton within w_report_spot_contracts
end type
type dw_profitcenter from mt_u_datawindow within w_report_spot_contracts
end type
type st_2 from statictext within w_report_spot_contracts
end type
type dw_enddate from mt_u_datawindow within w_report_spot_contracts
end type
type dw_startdate from mt_u_datawindow within w_report_spot_contracts
end type
type rb_act from radiobutton within w_report_spot_contracts
end type
type rb_estact from radiobutton within w_report_spot_contracts
end type
type st_1 from statictext within w_report_spot_contracts
end type
type gb_pc from groupbox within w_report_spot_contracts
end type
type gb_ships from groupbox within w_report_spot_contracts
end type
type gb_contracttype from groupbox within w_report_spot_contracts
end type
type gb_daterange from groupbox within w_report_spot_contracts
end type
type st_bk from u_topbar_background within w_report_spot_contracts
end type
end forward

global type w_report_spot_contracts from mt_w_main
integer width = 4215
integer height = 2560
string title = "Spot/Contract Vessel Earning Report"
boolean maxbox = false
boolean resizable = false
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
hpb_vessels hpb_vessels
st_pcdata st_pcdata
cbx_selectall cbx_selectall
sle_tcout_days sle_tcout_days
st_6 st_6
cbx_tcout_lower cbx_tcout_lower
cbx_tcout_bigger cbx_tcout_bigger
gb_3 gb_3
rb_beforedrc rb_beforedrc
rb_gross rb_gross
gb_2 gb_2
cbx_tcout cbx_tcout
cbx_spot cbx_spot
cbx_cvs_marketrate cbx_cvs_marketrate
cbx_cvs_fixedrate cbx_cvs_fixedrate
cbx_coa_marketrate cbx_coa_marketrate
cbx_coa_fixedrate cbx_coa_fixedrate
dw_vas_report dw_vas_report
cbx_showdetail cbx_showdetail
dw_vessellist dw_vessellist
cb_saveas cb_saveas
cb_print cb_print
dw_tce_report dw_tce_report
cb_retrieve cb_retrieve
dw_profitcenter dw_profitcenter
st_2 st_2
dw_enddate dw_enddate
dw_startdate dw_startdate
rb_act rb_act
rb_estact rb_estact
st_1 st_1
gb_pc gb_pc
gb_ships gb_ships
gb_contracttype gb_contracttype
gb_daterange gb_daterange
st_bk st_bk
end type
global w_report_spot_contracts w_report_spot_contracts

type variables
long il_pcs[]
string is_pcnames[]
datetime idt_start, idt_end

end variables

forward prototypes
public function decimal uf_get_idle_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
public function decimal uf_get_offhire_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end)
private subroutine wf_refreshvessellist ()
public subroutine documentation ()
end prototypes

public function decimal uf_get_idle_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end);Decimal ld_idle_days

DataStore lds_idle_vessel
lds_idle_vessel = Create datastore

lds_idle_vessel.dataObject = "d_tce_vessel_voyage_extra_idle"
lds_idle_vessel.setTransObject(SQLCA)
lds_idle_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)

IF lds_idle_vessel.Rowcount() > 0 THEN
	ld_idle_days = lds_idle_vessel.GetItemNumber(1,"sum_all")
ELSE
	ld_idle_days = 0
END IF

return ld_idle_days
end function

public function decimal uf_get_offhire_days (integer ai_vessel_nr, string as_voyage_nr, datetime adt_start, datetime adt_end);Decimal ld_offhire_days

DataStore lds_offhire_vessel
lds_offhire_vessel = Create datastore

lds_offhire_vessel.dataObject = "d_tce_vessel_voyage_extra_offhire"
lds_offhire_vessel.setTransObject(SQLCA)
lds_offhire_vessel.Retrieve(ai_vessel_nr, as_voyage_nr, adt_start, adt_end)

IF lds_offhire_vessel.Rowcount() > 0 THEN
	ld_offhire_days = lds_offhire_vessel.GetItemNumber(1,"sum_all")
ELSE
	ld_offhire_days = 0
END IF

return ld_offhire_days
end function

private subroutine wf_refreshvessellist ();long ll_selectedVessels[]
long ll_selected = 0, ll_rows, ll_found

if upperbound(il_pcs) < 1 then return
this.setRedraw(false)
ll_selected = dw_vessellist.getSelectedRow(0)

do while  ll_selected > 0
	ll_selectedVessels[upperBound(ll_selectedVessels) +1] = dw_vessellist.getItemNumber(ll_selected, "vessel_nr")
	ll_selected = dw_vessellist.getSelectedRow(ll_selected)
loop 

dw_enddate.accepttext()
idt_end = datetime(dw_enddate.getItemDate(1, "date"))

dw_startdate.acceptText()
idt_start = datetime(dw_startdate.getItemDate(1, "date"))
dw_vessellist.retrieve(il_pcs, idt_start, idt_end)

ll_rows = upperBound(ll_selectedVessels)

for ll_selected = 1 to ll_rows
	ll_found = dw_vessellist.find("vessel_nr="+string(ll_selectedVessels[ll_selected]),1,999999)
	if ll_found > 0 then dw_vessellist.selectRow(ll_found, true)
next 

this.setRedraw(true)

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_report_spot_contracts

   <OBJECT> Presents user with criteria (profit center, vessellist and date ranges) facility to retrieve data</OBJECT>
	
   <DESC>Uses a store procedure(SP_GETVOYAGELIST) in dataobject to generate voyage/vessel list conatined in 
			  date range and profit center array. Then loops through each voyage/vessel to obtain values needed 
			  from VAS report.</DESC>
	
   Date   	 Ref   	    Author        Comments
  2/08/11	2480         TTY004        initial version
  01/09/14			   CR3781	    CCY018		The window title match with the text of a menu item
********************************************************************/
end subroutine

on w_report_spot_contracts.create
int iCurrent
call super::create
this.hpb_vessels=create hpb_vessels
this.st_pcdata=create st_pcdata
this.cbx_selectall=create cbx_selectall
this.sle_tcout_days=create sle_tcout_days
this.st_6=create st_6
this.cbx_tcout_lower=create cbx_tcout_lower
this.cbx_tcout_bigger=create cbx_tcout_bigger
this.gb_3=create gb_3
this.rb_beforedrc=create rb_beforedrc
this.rb_gross=create rb_gross
this.gb_2=create gb_2
this.cbx_tcout=create cbx_tcout
this.cbx_spot=create cbx_spot
this.cbx_cvs_marketrate=create cbx_cvs_marketrate
this.cbx_cvs_fixedrate=create cbx_cvs_fixedrate
this.cbx_coa_marketrate=create cbx_coa_marketrate
this.cbx_coa_fixedrate=create cbx_coa_fixedrate
this.dw_vas_report=create dw_vas_report
this.cbx_showdetail=create cbx_showdetail
this.dw_vessellist=create dw_vessellist
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.dw_tce_report=create dw_tce_report
this.cb_retrieve=create cb_retrieve
this.dw_profitcenter=create dw_profitcenter
this.st_2=create st_2
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.rb_act=create rb_act
this.rb_estact=create rb_estact
this.st_1=create st_1
this.gb_pc=create gb_pc
this.gb_ships=create gb_ships
this.gb_contracttype=create gb_contracttype
this.gb_daterange=create gb_daterange
this.st_bk=create st_bk
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_vessels
this.Control[iCurrent+2]=this.st_pcdata
this.Control[iCurrent+3]=this.cbx_selectall
this.Control[iCurrent+4]=this.sle_tcout_days
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.cbx_tcout_lower
this.Control[iCurrent+7]=this.cbx_tcout_bigger
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.rb_beforedrc
this.Control[iCurrent+10]=this.rb_gross
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.cbx_tcout
this.Control[iCurrent+13]=this.cbx_spot
this.Control[iCurrent+14]=this.cbx_cvs_marketrate
this.Control[iCurrent+15]=this.cbx_cvs_fixedrate
this.Control[iCurrent+16]=this.cbx_coa_marketrate
this.Control[iCurrent+17]=this.cbx_coa_fixedrate
this.Control[iCurrent+18]=this.dw_vas_report
this.Control[iCurrent+19]=this.cbx_showdetail
this.Control[iCurrent+20]=this.dw_vessellist
this.Control[iCurrent+21]=this.cb_saveas
this.Control[iCurrent+22]=this.cb_print
this.Control[iCurrent+23]=this.dw_tce_report
this.Control[iCurrent+24]=this.cb_retrieve
this.Control[iCurrent+25]=this.dw_profitcenter
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.dw_enddate
this.Control[iCurrent+28]=this.dw_startdate
this.Control[iCurrent+29]=this.rb_act
this.Control[iCurrent+30]=this.rb_estact
this.Control[iCurrent+31]=this.st_1
this.Control[iCurrent+32]=this.gb_pc
this.Control[iCurrent+33]=this.gb_ships
this.Control[iCurrent+34]=this.gb_contracttype
this.Control[iCurrent+35]=this.gb_daterange
this.Control[iCurrent+36]=this.st_bk
end on

on w_report_spot_contracts.destroy
call super::destroy
destroy(this.hpb_vessels)
destroy(this.st_pcdata)
destroy(this.cbx_selectall)
destroy(this.sle_tcout_days)
destroy(this.st_6)
destroy(this.cbx_tcout_lower)
destroy(this.cbx_tcout_bigger)
destroy(this.gb_3)
destroy(this.rb_beforedrc)
destroy(this.rb_gross)
destroy(this.gb_2)
destroy(this.cbx_tcout)
destroy(this.cbx_spot)
destroy(this.cbx_cvs_marketrate)
destroy(this.cbx_cvs_fixedrate)
destroy(this.cbx_coa_marketrate)
destroy(this.cbx_coa_fixedrate)
destroy(this.dw_vas_report)
destroy(this.cbx_showdetail)
destroy(this.dw_vessellist)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.dw_tce_report)
destroy(this.cb_retrieve)
destroy(this.dw_profitcenter)
destroy(this.st_2)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.rb_act)
destroy(this.rb_estact)
destroy(this.st_1)
destroy(this.gb_pc)
destroy(this.gb_ships)
destroy(this.gb_contracttype)
destroy(this.gb_daterange)
destroy(this.st_bk)
end on

event open;call super::open;integer	li_month, li_year
date		ldt_calc_date

this.move(0,0)

dw_profitcenter.setTransObject(SQLCA)
dw_vessellist.setTransObject(SQLCA)
dw_profitcenter.setRowFocusindicator( focusrect!)
dw_vessellist.setRowFocusindicator( focusrect!)

dw_profitcenter.retrieve(uo_global.is_userid)

dw_startdate.insertRow(0)
dw_enddate.insertRow(0)

/* Set default start and end dates */
li_month = month(today())
li_year = year(today())

ldt_calc_date = date(li_year, li_month,1)
dw_enddate.setItem(1, "date", ldt_calc_date)
if li_month = 1 then
	li_month = 12
	li_year --
else
	li_month --
end if

ldt_calc_date = date(li_year, li_month,1)
dw_startdate.setItem(1, "date", ldt_calc_date)

end event

event close;if isValid(w_messagebox_capture) then close(w_messagebox_capture)
end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredcolor(cbx_selectall.backcolor)

end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_report_spot_contracts
end type

type hpb_vessels from hprogressbar within w_report_spot_contracts
integer x = 1170
integer y = 2272
integer width = 2999
integer height = 56
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_pcdata from statictext within w_report_spot_contracts
integer x = 37
integer y = 2272
integer width = 1134
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cbx_selectall from checkbox within w_report_spot_contracts
integer x = 1609
integer y = 16
integer width = 334
integer height = 56
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;
if this.checked then
	dw_vessellist.selectRow(0, TRUE)
	this.text = "Deselect all"
else
	dw_vessellist.selectRow(0, FALSE)
	this.text = "Select all"
end if
this.textcolor = c#color.White
end event

type sle_tcout_days from singlelineedit within w_report_spot_contracts
integer x = 3675
integer y = 352
integer width = 110
integer height = 56
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "180"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_report_spot_contracts
integer x = 3803
integer y = 352
integer width = 114
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

type cbx_tcout_lower from checkbox within w_report_spot_contracts
integer x = 3511
integer y = 384
integer width = 183
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
string text = "<="
end type

type cbx_tcout_bigger from checkbox within w_report_spot_contracts
integer x = 3511
integer y = 320
integer width = 183
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
string text = " >"
end type

type gb_3 from groupbox within w_report_spot_contracts
integer x = 2011
integer y = 272
integer width = 640
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Figure"
end type

type rb_beforedrc from radiobutton within w_report_spot_contracts
integer x = 2048
integer y = 416
integer width = 567
integer height = 56
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Result before DRC/TC"
boolean checked = true
end type

type rb_gross from radiobutton within w_report_spot_contracts
integer x = 2048
integer y = 336
integer width = 567
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Gross income"
end type

type gb_2 from groupbox within w_report_spot_contracts
integer x = 2688
integer y = 16
integer width = 475
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Column"
end type

type cbx_tcout from checkbox within w_report_spot_contracts
integer x = 3237
integer y = 320
integer width = 274
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
string text = "T/C Out"
end type

type cbx_spot from checkbox within w_report_spot_contracts
integer x = 3237
integer y = 80
integer width = 457
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

type cbx_cvs_marketrate from checkbox within w_report_spot_contracts
integer x = 3694
integer y = 80
integer width = 439
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
string text = "CVS Market rate"
boolean checked = true
end type

type cbx_cvs_fixedrate from checkbox within w_report_spot_contracts
integer x = 3694
integer y = 160
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
string text = "CVS Fixed rate"
end type

type cbx_coa_marketrate from checkbox within w_report_spot_contracts
integer x = 3237
integer y = 240
integer width = 457
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

type cbx_coa_fixedrate from checkbox within w_report_spot_contracts
integer x = 3237
integer y = 160
integer width = 457
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
end type

type dw_vas_report from mt_u_datawindow within w_report_spot_contracts
boolean visible = false
integer x = 3397
integer y = 84
integer width = 283
string dataobject = "d_vas_report_a4"
end type

type cbx_showdetail from checkbox within w_report_spot_contracts
integer x = 3712
integer y = 496
integer width = 457
integer height = 56
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Show detail lines"
boolean lefttext = true
end type

event clicked;/********************************************************************
   clicked
   <DESC>	Description	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
		                                           First Version
   	10/08/11   2480         TTY004             Fix an existing bug (print blank pages when not checking the "show detail lines" option)
   </HISTORY>                                 
********************************************************************/
long ll_x
string ls_modstring
blob lb_dwstatus
//modify dataobjects move the correct location (x position) and visible and band height
if this.checked then	
	ls_modstring = 'datawindow.detail.height=64 datawindow.header.height=480 t_3.x=4170 t_3.visible=1 t_5.x=4522 t_5.visible=1 t_6.x=4883 t_6.visible=1 '+&
	               't_16.x=5080 t_16.visible=1 t_8.x=5322 t_8.visible=1 t_9.x=6424 t_9.visible=1 t_14.x=7315 t_14.visible=1 '+&
						't_13.x=8097 t_13.visible=1 tcday_excl_offservice.x=4170 tcday_excl_offservice.visible=1 period_result.x=4522 ' +&
						'period_result.visible=1 period_days.x=4883 period_days.visible=1 charterersuser.x=5080 charterersuser.visible=1 '+&
						'grade_group.x=5332 grade_group.visible=1 grade_name.x=5880 grade_name.visible=1 load_area.x=6424 load_area.visible=1 '+&
						'discharge_area.x=7315 discharge_area.visible=1 charterers.x=8097 charterers.visible=1'
else
  ls_modstring = 'datawindow.detail.height=0 datawindow.header.height=408 t_3.x=0 t_3.visible=0 t_5.x=0 t_5.visible=0 t_6.x=0 t_6.visible=0 t_16.x=0 '+&
                 't_16.visible=0 t_8.x=0 t_8.visible=0 t_9.x=0 t_9.visible=0 t_14.x=0 t_14.visible=0 t_13.x=0 t_13.visible=0 '+&
					  'period_result.x=0 period_result.visible=0 tcday_excl_offservice.x=0 tcday_excl_offservice.visible=0 period_days.x=0 '+&
					  'period_days.visible=0 charterersuser.x=0 charterersuser.visible=0 grade_group.x=0 grade_group.visible=0 grade_name.x=0 '+&
					  'grade_name.visible=0 load_area.x=0 load_area.visible=0 discharge_area.x=0 discharge_area.visible=0 charterers.x=0 charterers.visible=0'
end if	
dw_tce_report.modify(ls_modstring)
// reset dw Hscrollbar width for not printing blank pages
if not checked then 
	dw_tce_report.getfullstate(lb_dwstatus)
	dw_tce_report.dataobject=dw_tce_report.dataobject
	dw_tce_report.setfullstate(lb_dwstatus)
end if 
return c#return.Success
end event

type dw_vessellist from mt_u_datawindow within w_report_spot_contracts
integer x = 841
integer y = 80
integer width = 1097
integer height = 448
string dataobject = "d_sq_tb_vessel_given_profitcenter"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if
end event

type cb_saveas from commandbutton within w_report_spot_contracts
integer x = 3479
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As"
end type

event clicked;dw_tce_report.saveas()
end event

type cb_print from commandbutton within w_report_spot_contracts
integer x = 3826
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_tce_report.print()
end event

type dw_tce_report from mt_u_datawindow within w_report_spot_contracts
integer x = 37
integer y = 624
integer width = 4133
integer height = 1616
string dataobject = "d_ex_tb_spot_voyages_result"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type cb_retrieve from commandbutton within w_report_spot_contracts
integer x = 3131
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;/********************************************************************
   clicked
  	<DESC>Uses a store procedure(SP_GETVOYAGELIST) in dataobject to generate voyage/vessel list conatined in 
			  date range and profit center array. Then loops through each voyage/vessel to obtain values needed 
			  from VAS report.</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <USAGE>	Called from m_tramosmain. Used by Finance</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
		                                           (1)initial version
   	02/08/11   2480         TTY004             (2)generate report when multiple PCs are selected
   </HISTORY>
********************************************************************/
/* Declare local Variables */
integer		li_pcnr, li_vessels[], li_empty[], li_contracttype[]
long			ll_row, ll_rows, ll_voyages, ll_tcout_days ,ll_pc_counts	
integer		li_tcout_index, li_pc_row, li_pc_upper
string		ls_hline2, ls_header_contype
datetime		ldt_start, ldt_end
n_report_spot_contracts		lnv_report

li_pc_upper = upperbound(il_pcs)
if li_pc_upper < 1 then 
	messagebox("Information", "Please select one or more profit centers.")
	return c#return.Failure
end if
dw_startdate.accepttext()
dw_enddate.accepttext()
if isnull(dw_startdate.getItemDate(1, "date")) or &
	isNull(dw_enddate.getItemDate(1, "date")) then 
	MessageBox("Information", "Please enter both start- and enddate")
	return c#return.Failure
end if
if dw_startdate.getItemDate(1, "date") >= &
	dw_enddate.getItemDate(1, "date") then 
	MessageBox("Information", "Startdate must be before enddate")
	return c#return.Failure
end if
/* Find out if there are any contracts selected */
ls_header_contype = "( "
if cbx_spot.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 1
	ls_header_contype += "SPOT, "
end if
if cbx_coa_fixedrate.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 2
	ls_header_contype += "COA Fixed rate, "
end if
if cbx_coa_marketrate.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 7
	ls_header_contype += "COA Market rate, "
end if
if cbx_cvs_fixedrate.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 3
	ls_header_contype += "CVS Fixed rate, "
end if
if cbx_cvs_marketrate.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 8
	ls_header_contype += "CVS Market rate, "
end if
if right(ls_header_contype, 2) = ", " then ls_header_contype = left(ls_header_contype, len(ls_header_contype) - 2)
if cbx_tcout.checked or cbx_tcout_bigger.checked or cbx_tcout_lower.checked  then 
	li_contracttype[upperbound(li_contracttype) +1] = 5
	li_contracttype[upperbound(li_contracttype) +1] = 99
	ls_header_contype += "T/C Out "
	ll_tcout_days=integer(sle_tcout_days.text )
	li_tcout_index = 0
	if  cbx_tcout_bigger.checked then
		ls_header_contype += "( > " + string(ll_tcout_days) + " days)"
		li_tcout_index += 10
	end if
	if  cbx_tcout_lower.checked then
		ls_header_contype += "(SPOT)"   
		li_tcout_index += 1
	end if
end if
ls_header_contype += ")"
if upperbound(li_contracttype) < 1 then
	MessageBox("Information", "Please select Contract Type")
	return c#return.Failure
end if
ls_hline2 = ""
ll_pc_counts = dw_profitcenter.rowcount()
// loop il_pcs ,get pc_name string for make header detail
for li_pc_row = 1 to li_pc_upper
	li_pcnr = il_pcs[li_pc_row]
	ls_hline2 += is_pcnames[li_pc_row] + ","
end for
ls_hline2 = left(ls_hline2, len(ls_hline2) - 1) + " excluded vessels ("
li_vessels = li_empty
ll_rows = dw_vessellist.rowCount()
// loop vessellist ,get exclude vessel_nr string for make header detail
for ll_row = 1 to ll_rows
	if dw_vessellist.isSelected(ll_row) then
		li_vessels[upperBound(li_vessels) +1]=dw_vessellist.getItemNumber(ll_row, "vessel_nr")
		ls_hline2 += " "+string(dw_vessellist.getItemNumber(ll_row, "vessel_nr"), "000")+ ","
	end if
next
if right(ls_hline2, 1) = "," then ls_hline2 = left(ls_hline2 ,len(ls_hline2) - 1)
ls_hline2  += ")"
/* Retrieve vessels and assign to array for input to getting vessel and voyages */
ldt_start = datetime(dw_startdate.getItemDate(1, "date"))
ldt_end = datetime(dw_enddate.getItemDate(1, "date"))
/* Set Header text line 2 */
dw_tce_report.reset()
if len(ls_hline2) > 265 then ls_hline2 = left(ls_hline2, 265) + '...'
dw_tce_report.Object.t_header_line2.Text = "Profitcenter: " + ls_hline2
dw_tce_report.Object.t_header_line1.Text = "Contract Type Result for period: "+string(ldt_start, "dd/mm-yyyy") +" - " +string(ldt_end, "dd/mm-yyyy")+ " = "+string(((f_datetime2long( ldt_end ) - f_datetime2long( ldt_start ))/86400), "#,##0") +" days"
dw_tce_report.Object.t_header_contype.Text = ls_header_contype

/* Open Message Capture window */
open (w_messagebox_capture )

/* Create the report itself */
dw_tce_report.setredraw( false )
lnv_report = create n_report_spot_contracts
for li_pc_row = 1 to li_pc_upper
	hpb_vessels.position = 0
	li_pcnr = il_pcs[li_pc_row]
   ll_voyages = lnv_report.of_getvoyages(li_pcnr , dw_vessellist , ldt_start , ldt_end, li_contracttype )
if ll_voyages > 0 then
	hpb_vessels.maxposition = ll_voyages
	st_pcdata.text = "Retrieving data for " + is_pcnames[li_pc_row] + " profitcenter, please wait."
	lnv_report.of_create_report(dw_tce_report, dw_vas_report, hpb_vessels, rb_estact.checked, rb_gross.checked, li_tcout_index, ll_tcout_days)
	st_pcdata.text = "Retrieving data successfully."
end if
next
dw_tce_report.setredraw( true )
dw_tce_report.Sort()
dw_tce_report.GroupCalc()
if isValid(w_messagebox_capture) then 
	if w_messageBox_capture.dw_messages.rowCount() > 0 then 
		w_messageBox_capture.show()
	end if
end if
DESTROY lnv_report
return c#return.Success



end event

type dw_profitcenter from mt_u_datawindow within w_report_spot_contracts
integer x = 73
integer y = 80
integer width = 658
integer height = 448
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event clicked;/********************************************************************
   clicked
   <DESC>	Criteria Profitcenters can selected	by clicked and refresh the display controls status</DESC>
   <RETURN>	<NONE>
   <ACCESS> public </ACCESS>
   <ARGS>
		xpos
		ypos
		row
		dwo
   </ARGS>
   <USAGE>	clicked in dw_profitcenter	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
																 (1)initial version
   	02/08/11   2480         TTY004             (2)add a feature to allow multi-PCs selection
   </HISTORY>
********************************************************************/
integer   li_empty[]
integer   li_x, li_count, li_found
string    ls_empty[]
if row > 0 then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	il_pcs = li_empty
	is_pcnames = ls_empty
	li_found = this.getselectedrow(0)
   do while li_found > 0
       li_count ++
       il_pcs[li_count] = this.getitemnumber(li_found, "pc_nr")
		 is_pcnames[li_count] = this.getitemstring(li_found ,"pc_name")
       li_found = dw_profitcenter.getselectedrow(li_found)
   loop
	idt_start = datetime(dw_startdate.getItemDate(1, "date"))
	idt_end = datetime(dw_enddate.getItemDate(1, "date")) 
end if
if upperbound(il_pcs) > 0 then 
	dw_vessellist.retrieve(il_pcs, idt_start, idt_end)
else 
	dw_vessellist.reset()
end if
cbx_selectall.text = 'Select all'
cbx_selectall.checked = false
dw_tce_report.reset()
end event

type st_2 from statictext within w_report_spot_contracts
integer x = 2048
integer y = 160
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Enddate"
boolean focusrectangle = false
end type

type dw_enddate from mt_u_datawindow within w_report_spot_contracts
integer x = 2267
integer y = 160
integer width = 343
integer height = 56
integer taborder = 30
string dataobject = "d_datepicker"
boolean border = false
end type

event editchanged;cb_retrieve.enabled = false
end event

event losefocus;this.accepttext()
cb_retrieve.enabled = True
end event

event itemchanged;//Added by TTY004 on 29/08/11. Change desc:validate the input date 
date ldt_end_date, ldt_start_date
ldt_end_date = date('01/01/2200')
ldt_start_date = date('01/01/1900')
if date(data) < ldt_start_date or date(data) >ldt_end_date then
   ldt_end_date = date(year(today()), month(today()),1)
   dw_enddate.setItem(1, "date", ldt_end_date)
return 2
end if 
end event

type dw_startdate from mt_u_datawindow within w_report_spot_contracts
integer x = 2267
integer y = 80
integer width = 343
integer height = 56
integer taborder = 20
string dataobject = "d_datepicker"
boolean border = false
end type

event editchanged;cb_retrieve.enabled = false
end event

event losefocus;this.accepttext()
cb_retrieve.enabled = True
end event

event itemchanged;//Added by TTY004 on 29/08/11. Change desc:validate the input date 
date ldt_end_date, ldt_start_date
ldt_end_date = date('01/01/2200')
ldt_start_date = date('01/01/1900')
if date(data) < ldt_start_date or date(data) >ldt_end_date then
   if month(today()) = 1 then 
		ldt_start_date = date(year(today()) - 1, 12, 1)
	else 
		ldt_start_date = date(year(today()), month(today()) - 1, 1)
	end if 
	dw_startdate.setitem(1, "date", ldt_start_date)
return 2
end if 
wf_refreshvessellist( )

end event

type rb_act from radiobutton within w_report_spot_contracts
integer x = 2725
integer y = 160
integer width = 402
integer height = 56
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Actual"
end type

type rb_estact from radiobutton within w_report_spot_contracts
integer x = 2725
integer y = 80
integer width = 402
integer height = 56
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Estimat/Actual"
boolean checked = true
end type

type st_1 from statictext within w_report_spot_contracts
integer x = 2048
integer y = 80
integer width = 219
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Startdate"
boolean focusrectangle = false
end type

type gb_pc from groupbox within w_report_spot_contracts
integer x = 37
integer y = 16
integer width = 731
integer height = 544
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type gb_ships from groupbox within w_report_spot_contracts
integer x = 805
integer y = 16
integer width = 1170
integer height = 544
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Vessel(s) to exclude"
end type

type gb_contracttype from groupbox within w_report_spot_contracts
integer x = 3200
integer y = 16
integer width = 969
integer height = 448
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Contract Type(s)"
end type

type gb_daterange from groupbox within w_report_spot_contracts
integer x = 2011
integer y = 16
integer width = 640
integer height = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Date Range"
end type

type st_bk from u_topbar_background within w_report_spot_contracts
integer width = 4462
integer height = 592
end type

