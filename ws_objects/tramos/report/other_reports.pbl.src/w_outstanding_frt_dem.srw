$PBExportHeader$w_outstanding_frt_dem.srw
$PBExportComments$Outstanding freight, demurrage and Misc.Claim report
forward
global type w_outstanding_frt_dem from mt_w_sheet
end type
type sle_days from singlelineedit within w_outstanding_frt_dem
end type
type st_1 from statictext within w_outstanding_frt_dem
end type
type dw_groupexport from datawindow within w_outstanding_frt_dem
end type
type cb_saveasgroup from commandbutton within w_outstanding_frt_dem
end type
type rb_misc from radiobutton within w_outstanding_frt_dem
end type
type rb_freight from radiobutton within w_outstanding_frt_dem
end type
type rb_demurrage from radiobutton within w_outstanding_frt_dem
end type
type dw_discharge_date from datawindow within w_outstanding_frt_dem
end type
type st_3 from statictext within w_outstanding_frt_dem
end type
type st_91 from statictext within w_outstanding_frt_dem
end type
type cbx_include_profitcenter from checkbox within w_outstanding_frt_dem
end type
type sle_profitcenters from singlelineedit within w_outstanding_frt_dem
end type
type cb_sel_profitcenter from commandbutton within w_outstanding_frt_dem
end type
type cb_close from commandbutton within w_outstanding_frt_dem
end type
type cb_saveas from commandbutton within w_outstanding_frt_dem
end type
type cb_print from commandbutton within w_outstanding_frt_dem
end type
type cb_sel_office from commandbutton within w_outstanding_frt_dem
end type
type sle_offices from singlelineedit within w_outstanding_frt_dem
end type
type cbx_include_office from checkbox within w_outstanding_frt_dem
end type
type st_9 from statictext within w_outstanding_frt_dem
end type
type cbx_charterer from checkbox within w_outstanding_frt_dem
end type
type cbx_voyagedetail from checkbox within w_outstanding_frt_dem
end type
type cb_retrieve from commandbutton within w_outstanding_frt_dem
end type
type dw_overview from datawindow within w_outstanding_frt_dem
end type
type dw_detail from datawindow within w_outstanding_frt_dem
end type
type gb_1 from groupbox within w_outstanding_frt_dem
end type
type gb_2 from groupbox within w_outstanding_frt_dem
end type
type gb_3 from groupbox within w_outstanding_frt_dem
end type
type gb_4 from groupbox within w_outstanding_frt_dem
end type
end forward

global type w_outstanding_frt_dem from mt_w_sheet
boolean visible = false
integer width = 4622
integer height = 2620
string title = "Outstanding Freight/Demurrage/Miscellaneous"
sle_days sle_days
st_1 st_1
dw_groupexport dw_groupexport
cb_saveasgroup cb_saveasgroup
rb_misc rb_misc
rb_freight rb_freight
rb_demurrage rb_demurrage
dw_discharge_date dw_discharge_date
st_3 st_3
st_91 st_91
cbx_include_profitcenter cbx_include_profitcenter
sle_profitcenters sle_profitcenters
cb_sel_profitcenter cb_sel_profitcenter
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
cb_sel_office cb_sel_office
sle_offices sle_offices
cbx_include_office cbx_include_office
st_9 st_9
cbx_charterer cbx_charterer
cbx_voyagedetail cbx_voyagedetail
cb_retrieve cb_retrieve
dw_overview dw_overview
dw_detail dw_detail
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_outstanding_frt_dem w_outstanding_frt_dem

type variables
s_demurrage_stat_selection 	istr_parm
datawindow							idw_current
end variables

forward prototypes
public subroutine of_filter ()
public subroutine documentation ()
end prototypes

public subroutine of_filter ();long 			ll_row, ll_rows
string 		ls_filter
datetime 	ldt_discharge

dw_overview.setredraw(false)
dw_detail.setredraw(false)
dw_overview.Object.office_filter.text = ""
dw_detail.Object.office_filter.text = ""
dw_overview.Object.profitcenter_filter.text = ""
dw_detail.Object.profitcenter_filter.text = ""

/* Office Number */
if (len(sle_offices.text) > 0) then
	if cbx_include_office.checked then
		if (len(ls_filter)=0) then
			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " office_nr in ( " + string(sle_offices.text) + " )"
		end if
		dw_overview.Object.office_filter.text = "Include Office: "+ sle_offices.text
		dw_detail.Object.office_filter.text = "Include Office: "+ sle_offices.text
	else
		if (len(ls_filter)=0) then
			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " office_nr not in ( " + string(sle_offices.text) + " )"
		end if
		dw_overview.Object.office_filter.text = "Exclude Office: "+ sle_offices.text
		dw_detail.Object.office_filter.text = "Exclude Office: "+ sle_offices.text
	end if		
end if

/* Profitcenter */
if (len(sle_profitcenters.text) > 0) then
	if cbx_include_profitcenter.checked then
		if (len(ls_filter)=0) then
			ls_filter += " pc_nr in ( " + string(sle_profitcenters.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " pc_nr in ( " + string(sle_profitcenters.text) + " )"
		end if
		dw_overview.Object.profitcenter_filter.text = "Include ProfitCenter: "+ sle_profitcenters.text
		dw_detail.Object.profitcenter_filter.text = "Include Profitcenter: "+ sle_profitcenters.text
	else
		if (len(ls_filter)=0) then
			ls_filter += " pc_nr not in ( " + string(sle_profitcenters.text) + " )"
		else 
			ls_filter += " and "
			ls_filter += " pc_nr not in ( " + string(sle_profitcenters.text) + " )"
		end if
		dw_overview.Object.profitcenter_filter.text = "Exclude ProfitCenter: "+ sle_profitcenters.text
		dw_detail.Object.profitcenter_filter.text = "EXclude Profitcenter: "+ sle_profitcenters.text
	end if		
end if

dw_overview.setfilter(ls_filter)
dw_overview.filter()
dw_overview.sort()

/* Discharge date - only detail datawindow */
if not isnull(dw_discharge_date.getItemdate(1, "date_value")) then
	ldt_discharge = datetime(dw_discharge_date.getItemdate(1, "date_value"))
	if (len(ls_filter)=0) then
		ls_filter += " discharge_date < datetime('"+string(ldt_discharge)+"')"
	else 
		ls_filter += " and "
		ls_filter += " discharge_date < datetime('"+string(ldt_discharge)+"')"
	end if
end if

dw_detail.setfilter(ls_filter)
dw_detail.filter()
dw_detail.sort()

dw_overview.setredraw(true)
dw_detail.setredraw(true)

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_outstanding_frt_dem
   <OBJECT> This report is showing a set of reports that are related to claims registred
	in the system. The upper part is showing the outstanding figures, and the lower
	part receivables</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
  Date   		Ref    Author        Comments
  2004 		?      	?     			First Version
  25/10-10	2050	RMO			Until now the credit days where calculated based on
  										total revenue pr. day the last 365 days. Now it is changed 
										to be based on what the user enters. Default is 120 days.  
  29/08/14	CR3781	CCY018	The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_outstanding_frt_dem.create
int iCurrent
call super::create
this.sle_days=create sle_days
this.st_1=create st_1
this.dw_groupexport=create dw_groupexport
this.cb_saveasgroup=create cb_saveasgroup
this.rb_misc=create rb_misc
this.rb_freight=create rb_freight
this.rb_demurrage=create rb_demurrage
this.dw_discharge_date=create dw_discharge_date
this.st_3=create st_3
this.st_91=create st_91
this.cbx_include_profitcenter=create cbx_include_profitcenter
this.sle_profitcenters=create sle_profitcenters
this.cb_sel_profitcenter=create cb_sel_profitcenter
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_sel_office=create cb_sel_office
this.sle_offices=create sle_offices
this.cbx_include_office=create cbx_include_office
this.st_9=create st_9
this.cbx_charterer=create cbx_charterer
this.cbx_voyagedetail=create cbx_voyagedetail
this.cb_retrieve=create cb_retrieve
this.dw_overview=create dw_overview
this.dw_detail=create dw_detail
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_days
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_groupexport
this.Control[iCurrent+4]=this.cb_saveasgroup
this.Control[iCurrent+5]=this.rb_misc
this.Control[iCurrent+6]=this.rb_freight
this.Control[iCurrent+7]=this.rb_demurrage
this.Control[iCurrent+8]=this.dw_discharge_date
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_91
this.Control[iCurrent+11]=this.cbx_include_profitcenter
this.Control[iCurrent+12]=this.sle_profitcenters
this.Control[iCurrent+13]=this.cb_sel_profitcenter
this.Control[iCurrent+14]=this.cb_close
this.Control[iCurrent+15]=this.cb_saveas
this.Control[iCurrent+16]=this.cb_print
this.Control[iCurrent+17]=this.cb_sel_office
this.Control[iCurrent+18]=this.sle_offices
this.Control[iCurrent+19]=this.cbx_include_office
this.Control[iCurrent+20]=this.st_9
this.Control[iCurrent+21]=this.cbx_charterer
this.Control[iCurrent+22]=this.cbx_voyagedetail
this.Control[iCurrent+23]=this.cb_retrieve
this.Control[iCurrent+24]=this.dw_overview
this.Control[iCurrent+25]=this.dw_detail
this.Control[iCurrent+26]=this.gb_1
this.Control[iCurrent+27]=this.gb_2
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
end on

on w_outstanding_frt_dem.destroy
call super::destroy
destroy(this.sle_days)
destroy(this.st_1)
destroy(this.dw_groupexport)
destroy(this.cb_saveasgroup)
destroy(this.rb_misc)
destroy(this.rb_freight)
destroy(this.rb_demurrage)
destroy(this.dw_discharge_date)
destroy(this.st_3)
destroy(this.st_91)
destroy(this.cbx_include_profitcenter)
destroy(this.sle_profitcenters)
destroy(this.cb_sel_profitcenter)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_sel_office)
destroy(this.sle_offices)
destroy(this.cbx_include_office)
destroy(this.st_9)
destroy(this.cbx_charterer)
destroy(this.cbx_voyagedetail)
destroy(this.cb_retrieve)
destroy(this.dw_overview)
destroy(this.dw_detail)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event open;datastore lds_data
long ll_rows, ll_row

lds_data=create datastore
lds_data.dataObject = "d_profit_center"
lds_data.setTransObject(SQLCA)
ll_rows = lds_data.retrieve(uo_global.is_userid)
for ll_row = 1 to ll_rows
	istr_parm.profitcenter[ll_row] = lds_data.getItemNumber(ll_row, "pc_nr")
next
destroy lds_data

dw_overview.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_discharge_date.insertRow(0)

idw_current = dw_overview
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_outstanding_frt_dem
end type

type sle_days from singlelineedit within w_outstanding_frt_dem
integer x = 4091
integer y = 1196
integer width = 343
integer height = 88
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "120"
borderstyle borderstyle = stylelowered!
end type

event modified;cb_retrieve.enabled = true
end event

type st_1 from statictext within w_outstanding_frt_dem
integer x = 4069
integer y = 908
integer width = 384
integer height = 280
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculation based on revenue for entered number of days"
boolean focusrectangle = false
end type

type dw_groupexport from datawindow within w_outstanding_frt_dem
boolean visible = false
integer x = 4078
integer y = 880
integer width = 402
integer height = 256
integer taborder = 130
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_saveasgroup from commandbutton within w_outstanding_frt_dem
integer x = 4091
integer y = 2228
integer width = 462
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As Group..."
end type

event clicked;string ls_profitcenter
int li_rownumber, li_rownumber_group, li_i

dw_groupexport.dataobject = "d_ex_tb_outstandingexport" 

li_rownumber = dw_overview.rowcount( );

for li_i = 1 to li_rownumber
	//put data to dw_groupexport
	if dw_overview.getItemString(li_i, "profitcenter") <> ls_profitcenter then //insert the line when different profitcenter
		ls_profitcenter = dw_overview.getItemString(li_i, "profitcenter")
		li_rownumber_group = dw_groupexport.insertrow(0)
		dw_groupexport.setItem(li_rownumber_group, "profitcenter", dw_overview.getItemString(li_i, "profitcenter"))
		if rb_demurrage.checked or rb_misc.checked then 
			dw_groupexport.setItem(li_rownumber_group, "avglatency", dw_overview.getItemNumber(li_i, "avglatency"))
		end if
		dw_groupexport.setItem(li_rownumber_group, "avgoutst", dw_overview.getItemNumber(li_i, "avgoutst"))
		dw_groupexport.setItem(li_rownumber_group, "netamount", dw_overview.getItemNumber(li_i, "p_net_amount"))
		dw_groupexport.setItem(li_rownumber_group, "creditdays", dw_overview.getItemNumber(li_i, "creditdays"))
		dw_groupexport.setItem(li_rownumber_group, "outstbelow30", dw_overview.getItemNumber(li_i, "p_amount_less30"))
		dw_groupexport.setItem(li_rownumber_group, "outst31to60", dw_overview.getItemNumber(li_i, "p_amount_31to60"))
		dw_groupexport.setItem(li_rownumber_group, "outst61to90",  dw_overview.getItemNumber(li_i, "p_amount_61to90"))
		dw_groupexport.setItem(li_rownumber_group, "outstabove90",  dw_overview.getItemNumber(li_i, "p_amount_greater90"))
		dw_groupexport.setItem(li_rownumber_group, "pctbelow30", dw_overview.getItemNumber(li_i, "pct_less30"))
		dw_groupexport.setItem(li_rownumber_group, "pct31to60", dw_overview.getItemNumber(li_i, "pct_31to60"))
		dw_groupexport.setItem(li_rownumber_group, "pct61to90", dw_overview.getItemNumber(li_i, "pct_61to90"))
		dw_groupexport.setItem(li_rownumber_group, "pctabove90", dw_overview.getItemNumber(li_i, "pct_greater90"))
	end if
next

if dw_groupexport.rowcount() > 0 then
	dw_groupexport.saveAS()
else
	MessageBox("Information", "No data to save. Please retrieve data before saving")
end if


end event

type rb_misc from radiobutton within w_outstanding_frt_dem
integer x = 4091
integer y = 208
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Misc."
end type

event clicked;integer li_clean_array[]

dw_overview.dataObject = "d_misc_overview_report"
dw_overview.setTransObject(SQLCA)
dw_detail.dataObject = "d_misc_detail_report"
dw_detail.setTransObject(SQLCA)

istr_parm.chart_nr = li_clean_array  /* no profitc in structure */
sle_profitcenters.text = ""
istr_parm.office_nr = li_clean_array
sle_offices.text = ""

cbx_include_office.enabled = false
cb_sel_office.enabled = false
cbx_include_profitcenter.enabled = false
cb_sel_profitcenter.enabled = false
cbx_charterer.enabled = false
cbx_voyagedetail.enabled = false
dw_discharge_date.enabled = false
dw_discharge_date.reset()
dw_discharge_date.insertRow(0)

cb_retrieve.enabled = true

idw_current = dw_overview

end event

type rb_freight from radiobutton within w_outstanding_frt_dem
integer x = 4091
integer y = 140
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Freight"
end type

event clicked;integer li_clean_array[]

dw_overview.dataObject = "d_freight_overview_report"
dw_overview.setTransObject(SQLCA)
dw_detail.dataObject = "d_freight_detail_report"
dw_detail.setTransObject(SQLCA)

istr_parm.chart_nr = li_clean_array  /* no profitc in structure */
sle_profitcenters.text = ""
istr_parm.office_nr = li_clean_array
sle_offices.text = ""

cbx_include_office.enabled = false
cb_sel_office.enabled = false
cbx_include_profitcenter.enabled = false
cb_sel_profitcenter.enabled = false
cbx_charterer.enabled = false
cbx_voyagedetail.enabled = false
dw_discharge_date.enabled = false
dw_discharge_date.reset()
dw_discharge_date.insertRow(0)

cb_retrieve.enabled = true

idw_current = dw_overview


end event

type rb_demurrage from radiobutton within w_outstanding_frt_dem
integer x = 4091
integer y = 72
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Demurrage"
boolean checked = true
end type

event clicked;integer li_clean_array[]

dw_overview.dataObject = "d_demurrage_overview_report"
dw_overview.setTransObject(SQLCA)
dw_detail.dataObject = "d_demurrage_detail_report"
dw_detail.setTransObject(SQLCA)

istr_parm.chart_nr = li_clean_array  /* no profitc in structure */
sle_profitcenters.text = ""
istr_parm.office_nr = li_clean_array
sle_offices.text = ""

cbx_include_office.enabled = false
cb_sel_office.enabled = false
cbx_include_profitcenter.enabled = false
cb_sel_profitcenter.enabled = false
cbx_charterer.enabled = false
cbx_voyagedetail.enabled = false
dw_discharge_date.enabled = false
dw_discharge_date.reset()
dw_discharge_date.insertRow(0)

cb_retrieve.enabled = true

idw_current = dw_overview


end event

type dw_discharge_date from datawindow within w_outstanding_frt_dem
integer x = 4069
integer y = 1620
integer width = 334
integer height = 88
integer taborder = 110
boolean enabled = false
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;this.accepttext()
of_filter()
end event

type st_3 from statictext within w_outstanding_frt_dem
integer x = 4069
integer y = 1496
integer width = 366
integer height = 108
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Discharge date less than"
boolean focusrectangle = false
end type

type st_91 from statictext within w_outstanding_frt_dem
integer x = 37
integer y = 48
integer width = 974
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following profitcenters:"
boolean focusrectangle = false
end type

type cbx_include_profitcenter from checkbox within w_outstanding_frt_dem
integer x = 1038
integer y = 32
integer width = 297
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
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

type sle_profitcenters from singlelineedit within w_outstanding_frt_dem
integer x = 1353
integer y = 32
integer width = 2185
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_sel_profitcenter from commandbutton within w_outstanding_frt_dem
integer x = 3547
integer y = 32
integer width = 101
integer height = 72
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

istr_parm.called_from = "profitcenter"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm

li_UpperBound = UpperBound(istr_parm.chart_nr) /* only because pcnumber not in struct */
sle_profitcenters.text = ""
For li_x = 1 to li_UpperBound
	if li_x = 1 then
		sle_profitcenters.text = string(istr_parm.chart_nr[li_x])
	else
		sle_profitcenters.text += ", " + string(istr_parm.chart_nr[li_x])
	end if
Next

of_filter()
end event

type cb_close from commandbutton within w_outstanding_frt_dem
integer x = 4091
integer y = 2384
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_saveas from commandbutton within w_outstanding_frt_dem
integer x = 4091
integer y = 2072
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;if idw_current.rowcount() > 0 then
	idw_current.saveAS()
else
	MessageBox("Information", "No data to save. Please retrieve data before saving")
end if
end event

type cb_print from commandbutton within w_outstanding_frt_dem
integer x = 4091
integer y = 1920
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;if idw_current.rowcount() > 0 then
	idw_current.print()
else
	MessageBox("Information", "No data to print. Please retrieve data before printing")
end if
end event

type cb_sel_office from commandbutton within w_outstanding_frt_dem
integer x = 3547
integer y = 152
integer width = 101
integer height = 72
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "?"
end type

event clicked;long li_UpperBound
long li_x

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

type sle_offices from singlelineedit within w_outstanding_frt_dem
integer x = 1353
integer y = 152
integer width = 2185
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_include_office from checkbox within w_outstanding_frt_dem
integer x = 1038
integer y = 152
integer width = 297
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
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

type st_9 from statictext within w_outstanding_frt_dem
integer x = 37
integer y = 168
integer width = 841
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only the following offices:"
boolean focusrectangle = false
end type

type cbx_charterer from checkbox within w_outstanding_frt_dem
integer x = 4069
integer y = 420
integer width = 343
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
boolean enabled = false
string text = "&Charterer"
boolean checked = true
end type

event clicked;if this.checked then
	dw_overview.modify("datawindow.trailer.2.height = '76'")
	dw_overview.modify("datawindow.header.1.height = '76'")
	dw_overview.object.l_2.visible = true
else
	dw_overview.modify("datawindow.trailer.2.height = '0'")
	dw_overview.modify("datawindow.header.1.height = '0'")
	dw_overview.object.l_2.visible = false
end if	
end event

type cbx_voyagedetail from checkbox within w_outstanding_frt_dem
integer x = 4069
integer y = 520
integer width = 370
integer height = 72
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "&Voyage detail"
end type

event clicked;if this.checked then
	dw_overview.object.datawindow.header.height = 316
	dw_overview.object.datawindow.detail.height = 76
else
	dw_overview.object.datawindow.header.height = 232
	dw_overview.object.datawindow.detail.height = 0
end if	
end event

type cb_retrieve from commandbutton within w_outstanding_frt_dem
integer x = 4091
integer y = 1768
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve..."
boolean default = true
end type

event clicked;datastore 		lds_data
long				ll_rows, ll_row, ll_revenue_days
decimal {2} 		ld_pc_revenue[]
decimal {2}		ld_work_amount
integer 			li_clean_array[]
str_progress 	lstr_parm
w_progress		lw_progress
transaction		mytrans

SetPointer(HourGlass!)

/* Reset checkmarks */
cbx_charterer.checked = true
dw_overview.modify("datawindow.trailer.2.height = '76'")
dw_overview.modify("datawindow.header.1.height = '76'")
dw_overview.object.l_2.visible = true
cbx_voyagedetail.checked = false
dw_overview.object.datawindow.header.height = 232
dw_overview.object.datawindow.detail.height = 0
//istr_parm.chart_nr = li_clean_array  /* no profitc in structure */
//sle_profitcenters.text = ""
//istr_parm.office_nr = li_clean_array
//sle_offices.text = ""
//dw_discharge_date.reset()
//dw_discharge_date.insertRow(0)

/* Open Progress Window */
lstr_parm.cancel_window = w_tramos_main
lstr_parm.cancel_event = ""
lstr_parm.title = "Retrieve Claims..."
openwithparm(lw_progress, lstr_parm, "w_progress_no_cancel")

/* Progress bar */
if isValid(lw_progress) then
	lw_progress.wf_progress(5/100, "Get revenue for last 365 days...")
end if

// retrieve total revenue last nn days by profitcenter
ll_revenue_days = long(sle_days.text)
if ll_revenue_days < 1 then
	MessageBox("Validation", "Please enter number of revenue days.")
	sle_days.post setFocus()
	return 
end if
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_revenue_pr_day_last_nn_days"
lds_data.setTransObject(SQLCA)
ll_rows = lds_data.retrieve( ll_revenue_days)
commit;

// opsummer demurrage, freight og TC hire pr. profitcenter
if ll_rows > 0 then
	ld_pc_revenue[lds_data.getItemNumber(1, "max_pc_nr")] = 0
	for ll_row = 1 to ll_rows
		ld_pc_revenue[lds_data.getItemNumber(ll_row, "pc_nr")] += lds_data.getItemDecimal(ll_row, "row_amount")
		//ld_total_revenue += lds_data.getItemDecimal(ll_row, "row_amount")
	next
end if


/* Progress bar */
if isValid(lw_progress) then
	lw_progress.wf_progress(30/40, "Get claims for outstanding report...")
end if

/* workaround PB bugfix */
mytrans = create transaction
mytrans.DBMS 			= SQLCA.DBMS
mytrans.Database 		= SQLCA.Database
mytrans.LogPAss 		= SQLCA.LogPass
mytrans.ServerName	= SQLCA.ServerName
mytrans.LogId			= SQLCA.LogId
mytrans.AutoCommit	= true
mytrans.DBParm		= SQLCA.DBParm
connect using mytrans;
dw_overview.setTransObject(mytrans)
dw_overview.retrieve( uo_global.is_userid )
disconnect using mytrans;
destroy mytrans;

commit;
SetPointer(HourGlass!)

/* Progress bar */
if isValid(lw_progress) then
	lw_progress.wf_progress(35/40, "Get claims for receivable report...")
end if

dw_detail.retrieve( uo_global.is_userid )
commit;
SetPointer(HourGlass!)

dw_overview.setredraw(false)

ll_rows =upperbound(ld_pc_revenue)
for ll_row=1 to ll_rows
 if isValid(lw_progress) then
		lw_progress.wf_progress(ll_row/ll_rows, "Calculate credit days...")
	end if

	dw_overview.setfilter("pc_nr=" + string(ll_row))
	dw_overview.filter()
	if dw_overview.rowcount( ) > 0 then
		dw_overview.setitem(1, "revenue_365_days", ld_pc_revenue[ll_row]*365)   //as revenue in pc array is average revenue pr. day 
	end if
	
next
dw_overview.setfilter("")
dw_overview.filter()

dw_overview.groupcalc()
dw_overview.setredraw(true)

destroy lds_data

cbx_include_office.enabled = true
cb_sel_office.enabled = true
cbx_include_profitcenter.enabled = true
cb_sel_profitcenter.enabled = true
cbx_charterer.enabled = true
cbx_voyagedetail.enabled = true
dw_discharge_date.enabled = true

/* Closes progress window */
if isValid(lw_progress) then close(lw_progress)

this.enabled = false
of_filter()
SetPointer(Arrow!)
end event

type dw_overview from datawindow within w_outstanding_frt_dem
integer x = 32
integer y = 256
integer width = 4005
integer height = 1104
integer taborder = 90
string title = "none"
string dataobject = "d_demurrage_overview_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;if this.height <> 2220 then
	dw_detail.visible = false
	this.height = 2220
	dw_discharge_date.enabled = false
else
	this.height = 1104
	dw_detail.visible = true
	dw_discharge_date.enabled = true
end if
end event

event getfocus;idw_current = this
end event

type dw_detail from datawindow within w_outstanding_frt_dem
integer x = 32
integer y = 1380
integer width = 4005
integer height = 1104
integer taborder = 100
string title = "none"
string dataobject = "d_demurrage_detail_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;if this.height <> 2220 then
	dw_overview.visible = false
	this.y = 256
	this.height = 2220
	cbx_charterer.enabled = false
	cbx_voyagedetail.enabled = false
else
	this.y = 1380
	this.height = 1104
	dw_overview.visible = true
	cbx_charterer.enabled = true
	cbx_voyagedetail.enabled = true
end if
end event

event getfocus;idw_current = this
end event

type gb_1 from groupbox within w_outstanding_frt_dem
integer x = 4055
integer y = 12
integer width = 416
integer height = 284
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Report type..."
end type

type gb_2 from groupbox within w_outstanding_frt_dem
integer x = 4055
integer y = 344
integer width = 416
integer height = 284
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Filter"
end type

type gb_3 from groupbox within w_outstanding_frt_dem
integer x = 4055
integer y = 1436
integer width = 416
integer height = 300
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Filter"
end type

type gb_4 from groupbox within w_outstanding_frt_dem
integer x = 4055
integer y = 852
integer width = 416
integer height = 456
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Credit days"
end type

