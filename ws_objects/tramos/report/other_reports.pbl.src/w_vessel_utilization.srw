$PBExportHeader$w_vessel_utilization.srw
$PBExportComments$Shown vessel utilization for all vessels, profitcenter or pool
forward
global type w_vessel_utilization from window
end type
type cbx_selectall from checkbox within w_vessel_utilization
end type
type cbx_vesselgrp from checkbox within w_vessel_utilization
end type
type st_4 from statictext within w_vessel_utilization
end type
type dw_vessellist from datawindow within w_vessel_utilization
end type
type cbx_position from checkbox within w_vessel_utilization
end type
type dw_utilgraph from datawindow within w_vessel_utilization
end type
type dw_vesselutil from datawindow within w_vessel_utilization
end type
type cbx_tcout from checkbox within w_vessel_utilization
end type
type cbx_spot from checkbox within w_vessel_utilization
end type
type cbx_cvs_marketrate from checkbox within w_vessel_utilization
end type
type cbx_cvs_fixedrate from checkbox within w_vessel_utilization
end type
type cbx_coa_marketrate from checkbox within w_vessel_utilization
end type
type cbx_coa_fixedrate from checkbox within w_vessel_utilization
end type
type cbx_showdetail from checkbox within w_vessel_utilization
end type
type st_3 from statictext within w_vessel_utilization
end type
type cb_close from commandbutton within w_vessel_utilization
end type
type cb_saveas from commandbutton within w_vessel_utilization
end type
type cb_print from commandbutton within w_vessel_utilization
end type
type dw_pcutil from datawindow within w_vessel_utilization
end type
type cb_create from commandbutton within w_vessel_utilization
end type
type dw_profitcenter from datawindow within w_vessel_utilization
end type
type st_2 from statictext within w_vessel_utilization
end type
type st_1 from statictext within w_vessel_utilization
end type
type dw_enddate from datawindow within w_vessel_utilization
end type
type dw_startdate from datawindow within w_vessel_utilization
end type
type gb_1 from groupbox within w_vessel_utilization
end type
end forward

global type w_vessel_utilization from window
integer width = 3758
integer height = 2652
boolean titlebar = true
string title = "Vessel Utilisation Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
cbx_selectall cbx_selectall
cbx_vesselgrp cbx_vesselgrp
st_4 st_4
dw_vessellist dw_vessellist
cbx_position cbx_position
dw_utilgraph dw_utilgraph
dw_vesselutil dw_vesselutil
cbx_tcout cbx_tcout
cbx_spot cbx_spot
cbx_cvs_marketrate cbx_cvs_marketrate
cbx_cvs_fixedrate cbx_cvs_fixedrate
cbx_coa_marketrate cbx_coa_marketrate
cbx_coa_fixedrate cbx_coa_fixedrate
cbx_showdetail cbx_showdetail
st_3 st_3
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
dw_pcutil dw_pcutil
cb_create cb_create
dw_profitcenter dw_profitcenter
st_2 st_2
st_1 st_1
dw_enddate dw_enddate
dw_startdate dw_startdate
gb_1 gb_1
end type
global w_vessel_utilization w_vessel_utilization

type variables
long il_all_pcnr[]
long il_pcnr[1]
datetime idt_start, idt_end


end variables

forward prototypes
private subroutine of_filter ()
public subroutine documentation ()
private subroutine wf_refreshvessellist ()
end prototypes

private subroutine of_filter ();string 	ls_cont_filter, ls_vsl_filter, ls_filter
long		ll_vessel[], ll_row

// set contract filter
ls_cont_filter = ""
if cbx_spot.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 1"
	else 
		ls_cont_filter = "1"
	end if
end if
if cbx_coa_fixedrate.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 2"
	else 
		ls_cont_filter = "2"
	end if
end if
if cbx_coa_marketrate.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 7"
	else 
		ls_cont_filter = "7"
	end if
end if
if cbx_cvs_fixedrate.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 3"
	else 
		ls_cont_filter = "3"
	end if
end if
if cbx_cvs_marketrate.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 8"
	else 
		ls_cont_filter = "8"
	end if
end if
if cbx_tcout.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 5"
	else 
		ls_cont_filter = "5"
	end if
end if
if cbx_position.checked then 
	if len(ls_cont_filter) > 0 then
		ls_cont_filter += ", 99"
	else 
		ls_cont_filter = "99"
	end if
end if

if len(ls_cont_filter) > 0 then
	ls_cont_filter = "contract_type in (" + ls_cont_filter + ")"
end if

// set excluded vessels filter
do 
	ll_row = dw_vessellist.getselectedRow(ll_row)
	if ll_row > 0 then
		if len(ls_vsl_filter) > 0 then
			ls_vsl_filter += ", '"+string(dw_vessellist.getItemString(ll_row, "vessel_ref_nr"))+"'"
		else
			ls_vsl_filter = "'"+string(dw_vessellist.getItemString(ll_row, "vessel_ref_nr"))+"'"
		end if
	end if
loop until ll_row < 1	

if len(ls_vsl_filter) > 0 then
	ls_vsl_filter = "vessel_ref_nr not in (" + ls_vsl_filter + ")"
end if

// set filter in DW
if len(ls_cont_filter) > 0 and len(ls_vsl_filter) > 0 then
	ls_filter = ls_cont_filter + " and " + ls_vsl_filter
elseif len(ls_cont_filter) > 0 then
	ls_filter = ls_cont_filter 
elseif len(ls_vsl_filter) > 0 then
	ls_filter = ls_vsl_filter
else
	ls_filter = ""
end if

dw_pcutil.setFilter(ls_filter)
dw_pcutil.filter()

dw_pcutil.groupcalc()

end subroutine

public subroutine documentation ();/*
This report is based on Change Request 1052 and a lot of conversation 
with Jakob Tørring

The report data is pulled from the database by calling the Spored Procedure
sp_vsl_utilization_report with following arguments 
@profitcenter, 
@poolid, 
@reportstart, 
@reportend 
(poolid shall always be 0 as we have agreed with Jakob that this is not needed 
in first version)

The profitcenter shall be 0(zero) or a profitcenter number. If 0 then data 
for all profitcenters are retrieved.

Start and end dates are the period we are looking into/at.

The report is showing vessel utilization saying Laden time within Voyage

Laden time = NOR (Notice of readiness) first loadport to departure last discharge port
					(NOR is taken from Laytime)
Voyage Time = voyage start to voyage end

Only voyages that are finished are taken into consideration.
From both voyage and laden time are subtracted off services that are within 
periode start/end.

Following modifications are made to data

- if a voyage starts before report date it is set to start at report date
- if the laden time starts before report date it is set to start at report date
- if a voyage ends after report date it is set to end at report date
- if the laden time ends after report date it is set to end at report date
(we are only looking at exactly the period the user requests for)
- if the voyage is a TC-OUT voyage the startdate is set to previous voyage
	enddate. (When a vessel is on TC-OUT its utilization is 100% saying
	that voyage period = laden period)

*/
end subroutine

private subroutine wf_refreshvessellist ();long ll_selectedVessels[]
long ll_selected = 0, ll_rows, ll_found, ll_PCrow

this.setRedraw(false)

ll_selected = dw_vessellist.getSelectedRow(0)

do while  ll_selected > 0
	ll_selectedVessels[upperBound(ll_selectedVessels) +1] = dw_vessellist.getItemNumber(ll_selected, "vessel_nr")
	ll_selected = dw_vessellist.getSelectedRow(ll_selected)
loop 

dw_enddate.acceptText()
idt_end = datetime(dw_enddate.getItemDate(1, "date_value"))

dw_startdate.acceptText()
idt_start = datetime(dw_startdate.getItemDate(1, "date_value"))

ll_PCrow = dw_profitcenter.getselectedrow(0) 
if ll_PCrow > 0 then
	il_pcnr[1] = dw_profitcenter.getItemNumber(ll_PCrow, "pc_nr")
	dw_vessellist.retrieve(il_pcnr, idt_start, idt_end)
else 
	dw_vessellist.post retrieve(il_all_pcnr, idt_start, idt_end)
end if

ll_rows = upperBound(ll_selectedVessels)

for ll_selected = 1 to ll_rows
	ll_found = dw_vessellist.find("vessel_nr="+string(ll_selectedVessels[ll_selected]),1,999999)
	if ll_found > 0 then dw_vessellist.selectRow(ll_found, true)
next 

this.setRedraw(true)

end subroutine

on w_vessel_utilization.create
this.cbx_selectall=create cbx_selectall
this.cbx_vesselgrp=create cbx_vesselgrp
this.st_4=create st_4
this.dw_vessellist=create dw_vessellist
this.cbx_position=create cbx_position
this.dw_utilgraph=create dw_utilgraph
this.dw_vesselutil=create dw_vesselutil
this.cbx_tcout=create cbx_tcout
this.cbx_spot=create cbx_spot
this.cbx_cvs_marketrate=create cbx_cvs_marketrate
this.cbx_cvs_fixedrate=create cbx_cvs_fixedrate
this.cbx_coa_marketrate=create cbx_coa_marketrate
this.cbx_coa_fixedrate=create cbx_coa_fixedrate
this.cbx_showdetail=create cbx_showdetail
this.st_3=create st_3
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.dw_pcutil=create dw_pcutil
this.cb_create=create cb_create
this.dw_profitcenter=create dw_profitcenter
this.st_2=create st_2
this.st_1=create st_1
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.gb_1=create gb_1
this.Control[]={this.cbx_selectall,&
this.cbx_vesselgrp,&
this.st_4,&
this.dw_vessellist,&
this.cbx_position,&
this.dw_utilgraph,&
this.dw_vesselutil,&
this.cbx_tcout,&
this.cbx_spot,&
this.cbx_cvs_marketrate,&
this.cbx_cvs_fixedrate,&
this.cbx_coa_marketrate,&
this.cbx_coa_fixedrate,&
this.cbx_showdetail,&
this.st_3,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.dw_pcutil,&
this.cb_create,&
this.dw_profitcenter,&
this.st_2,&
this.st_1,&
this.dw_enddate,&
this.dw_startdate,&
this.gb_1}
end on

on w_vessel_utilization.destroy
destroy(this.cbx_selectall)
destroy(this.cbx_vesselgrp)
destroy(this.st_4)
destroy(this.dw_vessellist)
destroy(this.cbx_position)
destroy(this.dw_utilgraph)
destroy(this.dw_vesselutil)
destroy(this.cbx_tcout)
destroy(this.cbx_spot)
destroy(this.cbx_cvs_marketrate)
destroy(this.cbx_cvs_fixedrate)
destroy(this.cbx_coa_marketrate)
destroy(this.cbx_coa_fixedrate)
destroy(this.cbx_showdetail)
destroy(this.st_3)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.dw_pcutil)
destroy(this.cb_create)
destroy(this.dw_profitcenter)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.gb_1)
end on

event open;integer	li_month, li_year
date		ldt_calc_date
long		ll_rows, ll_row
this.move(0,0)

dw_profitcenter.setTransObject(SQLCA)
dw_profitcenter.setRowFocusindicator( focusrect!)
dw_vessellist.setTransObject(SQLCA)
dw_vessellist.setRowFocusindicator( focusrect!)
dw_pcutil.SetTransObject (sqlca)

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

ll_rows = dw_profitcenter.retrieve(uo_global.is_userid)
for ll_row = 1 to ll_rows
	il_all_pcnr[ll_row] = dw_profitcenter.getItemNumber(ll_row, "pc_nr")
next

idt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
idt_end = datetime(dw_enddate.getItemDate(1, "date_value"))

dw_vessellist.post retrieve( il_all_pcnr, idt_start, idt_end )


end event

type cbx_selectall from checkbox within w_vessel_utilization
integer x = 1463
integer y = 48
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select all"
end type

event clicked;if this.checked then
	dw_vessellist.selectRow(0, TRUE)
	this.text = "Deselect all"
else
	dw_vessellist.selectRow(0, FALSE)
	this.text = "Select all"
end if
end event

type cbx_vesselgrp from checkbox within w_vessel_utilization
integer x = 3173
integer y = 604
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel &Graph"
end type

event clicked;if cbx_vesselgrp.checked then
	dw_utilgraph.Object.gr_1.Category='vessel_name'
	dw_utilgraph.Object.gr_1.Category.Label='Vessel'
	dw_utilgraph.Object.gr_1.values='compute_2 * 100'
else
	dw_utilgraph.Object.gr_1.Category='pc_name'
	dw_utilgraph.Object.gr_1.Category.Label='Profitcenter'
	dw_utilgraph.Object.gr_1.values='compute_3 * 100'
end if	
end event

type st_4 from statictext within w_vessel_utilization
integer x = 773
integer y = 56
integer width = 635
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select vessel to exclude:"
boolean focusrectangle = false
end type

type dw_vessellist from datawindow within w_vessel_utilization
integer x = 763
integer y = 116
integer width = 1088
integer height = 508
integer taborder = 100
string title = "none"
string dataobject = "d_sq_tb_vessel_given_profitcenter"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
	of_filter()
end if
end event

type cbx_position from checkbox within w_vessel_utilization
integer x = 2464
integer y = 508
integer width = 471
integer height = 72
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Position"
boolean checked = true
end type

event clicked;of_filter()
end event

type dw_utilgraph from datawindow within w_vessel_utilization
integer x = 37
integer y = 1364
integer width = 3675
integer height = 1172
integer taborder = 180
string title = "none"
string dataobject = "d_sp_gp_pc_utilization_graph"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;if this.height < 1500 then
	dw_vesselutil.visible = false
	dw_pcutil.visible = false
	this.height = 1877
	this.y = 664
	this.object.gr_1.height = 1870
else
	this.height = 1172
	this.y = 1364
	this.object.gr_1.height = 1176
	dw_vesselutil.visible = true
	dw_pcutil.visible = true
end if
end event

type dw_vesselutil from datawindow within w_vessel_utilization
integer x = 1408
integer y = 664
integer width = 1440
integer height = 680
integer taborder = 170
string title = "none"
string dataobject = "d_sp_gp_vessel_vessel_utilization"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isselected(row))
end if
end event

type cbx_tcout from checkbox within w_vessel_utilization
integer x = 2464
integer y = 440
integer width = 471
integer height = 72
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "T/C Out"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_spot from checkbox within w_vessel_utilization
integer x = 2464
integer y = 100
integer width = 471
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SPOT"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_cvs_marketrate from checkbox within w_vessel_utilization
integer x = 2464
integer y = 372
integer width = 471
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CVS Market rate"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_cvs_fixedrate from checkbox within w_vessel_utilization
integer x = 2464
integer y = 304
integer width = 471
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CVS Fixed rate"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_coa_marketrate from checkbox within w_vessel_utilization
integer x = 2464
integer y = 236
integer width = 471
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "COA Market rate"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_coa_fixedrate from checkbox within w_vessel_utilization
integer x = 2464
integer y = 168
integer width = 471
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "COA Fixed rate"
boolean checked = true
end type

event clicked;of_filter()
end event

type cbx_showdetail from checkbox within w_vessel_utilization
integer x = 3173
integer y = 524
integer width = 498
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show &Detail Lines"
end type

event clicked;if this.checked then
	dw_vesselutil.visible = false
	dw_utilgraph.visible = false
	dw_pcutil.height = 1877
	dw_pcutil.width = 3675
	dw_pcutil.Object.DataWindow.Detail.Height='80'
//	dw_pcutil.Object.DataWindow.Header.1.Height='160'
//	dw_pcutil.Object.DataWindow.Header.2.Height='160'
	dw_pcutil.Modify("DataWindow.Header.1.Height='160'")	
	dw_pcutil.Modify("DataWindow.Header.2.Height='160'")	
else
	dw_vesselutil.visible = true
	dw_utilgraph.visible = true
	dw_pcutil.height = 672
	dw_pcutil.width = 1266
	dw_pcutil.Object.DataWindow.Detail.Height='0'
//	dw_pcutil.Object.DataWindow.Header.1.Height='80'
//	dw_pcutil.Object.DataWindow.Header.2.Height='0'
	dw_pcutil.Modify("DataWindow.Header.1.Height='80'")	
	dw_pcutil.Modify("DataWindow.Header.2.Height='0'")	
end if	



end event

type st_3 from statictext within w_vessel_utilization
integer x = 37
integer y = 52
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

type cb_close from commandbutton within w_vessel_utilization
integer x = 3200
integer y = 396
integer width = 343
integer height = 100
integer taborder = 150
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

type cb_saveas from commandbutton within w_vessel_utilization
integer x = 3200
integer y = 276
integer width = 343
integer height = 100
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_pcutil.saveas()
end event

type cb_print from commandbutton within w_vessel_utilization
integer x = 3200
integer y = 164
integer width = 343
integer height = 92
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_pcutil.print()
end event

type dw_pcutil from datawindow within w_vessel_utilization
integer x = 37
integer y = 664
integer width = 1266
integer height = 672
integer taborder = 160
string title = "none"
string dataobject = "d_sp_gp_vessel_pc_utilization"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_create from commandbutton within w_vessel_utilization
integer x = 3200
integer y = 44
integer width = 343
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&reate..."
end type

event clicked;/* Declare local Variables */
integer		li_pcnr, li_vessels[], li_empty[], li_contracttype[]
long			ll_row, ll_rows, ll_voyages
string		ls_hline2, ls_header_contype
datetime		ldt_start, ldt_end
n_report_spot_contracts		lnv_report
transaction	mytrans


/* First find out if there is selected a profit center */
ll_row = dw_profitcenter.getSelectedrow( 0 )
if ll_row < 1 then
	li_pcnr = 0
else
	li_pcnr = dw_profitcenter.getItemNumber(ll_row, "pc_nr")
end if

/* Find out if any vessels excluded */
li_vessels = li_empty
ll_rows = dw_vessellist.rowCount()
for ll_row = 1 to ll_rows
	if dw_vessellist.isSelected(ll_row) then
		li_vessels[upperBound(li_vessels) +1]=dw_vessellist.getItemNumber(ll_row, "vessel_nr")
		ls_hline2 += " "+string(dw_vessellist.getItemNumber(ll_row, "vessel_nr"), "000")+ ","
	end if
next
ls_hline2  += ")"

/* Validate dates */
dw_startdate.accepttext()
dw_enddate.accepttext()
if isnull(dw_startdate.getItemDate(1, "date_value")) or &
	isNull(dw_enddate.getItemDate(1, "date_value")) then 
	MessageBox("Information", "Please enter both start- and enddate")
	return
end if
if dw_startdate.getItemDate(1, "date_value") >= &
	dw_enddate.getItemDate(1, "date_value") then 
	MessageBox("Information", "Startdate must be before enddate")
	return
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
if cbx_tcout.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 5
	ls_header_contype += "T/C Out "
end if
if cbx_position.checked then 
	li_contracttype[upperbound(li_contracttype) +1] = 99
	ls_header_contype += "Position "
end if
ls_header_contype += ")"

if upperbound(li_contracttype) < 1 then
	MessageBox("Information", "Please select Contract Type")
	return
end if

/* Retrieve vessels and assign to array for input to getting vessel and voyages */
ldt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end = datetime(dw_enddate.getItemDate(1, "date_value"))

/* Set Header text line 2 */
//dw_tce_report.reset()
//dw_tce_report.Object.t_header_line2.Text = "Profitcenter: "+ls_hline2
//dw_tce_report.Object.t_header_line1.Text = "Contract Type Result for period: "+string(ldt_start, "dd/mm-yyyy") +" - " +string(ldt_end, "dd/mm-yyyy")+ " = "+string(((f_datetime2long( ldt_end ) - f_datetime2long( ldt_start ))/86400), "#,##0") +" days"
//dw_tce_report.Object.t_header_contype.Text = ls_header_contype

/* Retrieve report itself */
setpointer(hourglass!)
/* workaround PB bugfix */
mytrans = create transaction
mytrans.DBMS 		= SQLCA.DBMS
mytrans.Database 	= SQLCA.Database
mytrans.LogPAss 	= SQLCA.LogPass
mytrans.ServerName= SQLCA.ServerName
mytrans.LogId		= SQLCA.LogId
mytrans.AutoCommit= true
mytrans.DBParm		= SQLCA.DBParm
connect using mytrans;
dw_pcutil.setTransObject(mytrans)
dw_pcutil.retrieve (li_pcnr, 0, ldt_start, ldt_end)
disconnect using mytrans;
destroy mytrans;

of_filter()

dw_pcutil.GroupCalc()
dw_pcutil.setredraw( true )

dw_pcutil.sharedata(dw_vesselutil)
dw_pcutil.sharedata(dw_utilgraph)
dw_utilgraph.Object.gr_1.Title="Vessel Utilization "+string(ldt_start, "dd/mm-yy")+ " - " +string(ldt_end, "dd/mm-yy")
setpointer(Arrow!)

end event

type dw_profitcenter from datawindow within w_vessel_utilization
integer x = 37
integer y = 112
integer width = 658
integer height = 508
integer taborder = 10
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
if row > 0 then
	if this.getSelectedRow(0) > 0 and this.getSelectedRow(0) <> row then this.selectRow(0, false)
	this.selectrow(row, not this.isselected(row))
	dw_pcutil.reset()
	dw_vesselutil.reset()
	dw_utilgraph.reset()
	dw_vessellist.selectRow(0, FALSE)
	cbx_selectall.text = "Select all"
	cbx_selectall.checked = false
end if

idt_start = datetime(dw_startdate.getItemDate(1, "date_value"))
idt_end = datetime(dw_enddate.getItemDate(1, "date_value"))

if this.getselectedrow(0) > 0 then
	il_pcnr[1] = this.getItemNumber(row, "pc_nr")
	dw_vessellist.retrieve(il_pcnr, idt_start, idt_end)
else 
	dw_vessellist.post retrieve(il_all_pcnr, idt_start, idt_end)
end if

	
end event

type st_2 from statictext within w_vessel_utilization
integer x = 1879
integer y = 220
integer width = 224
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enddate:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vessel_utilization
integer x = 1879
integer y = 120
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Startdate:"
boolean focusrectangle = false
end type

type dw_enddate from datawindow within w_vessel_utilization
integer x = 2121
integer y = 208
integer width = 306
integer height = 88
integer taborder = 50
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;wf_refreshvessellist( )
end event

event losefocus;this.accepttext()
cb_create.enabled = True
end event

event editchanged;cb_create.enabled = false
end event

type dw_startdate from datawindow within w_vessel_utilization
integer x = 2121
integer y = 104
integer width = 306
integer height = 88
integer taborder = 40
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;wf_refreshvessellist( )
end event

event losefocus;this.accepttext()
cb_create.enabled = True
end event

event editchanged;cb_create.enabled = false
end event

type gb_1 from groupbox within w_vessel_utilization
integer y = 8
integer width = 2976
integer height = 636
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

