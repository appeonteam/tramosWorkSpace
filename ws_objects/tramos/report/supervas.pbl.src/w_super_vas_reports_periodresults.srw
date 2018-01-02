$PBExportHeader$w_super_vas_reports_periodresults.srw
$PBExportComments$Window for all  VAS (Vessel Accounting System ) reports generation
forward
global type w_super_vas_reports_periodresults from mt_w_sheet
end type
type dw_to from datawindow within w_super_vas_reports_periodresults
end type
type dw_from from datawindow within w_super_vas_reports_periodresults
end type
type st_2 from mt_u_statictext within w_super_vas_reports_periodresults
end type
type st_progress from mt_u_statictext within w_super_vas_reports_periodresults
end type
type vpb_progress_pcs from hprogressbar within w_super_vas_reports_periodresults
end type
type cbx_selectallshiptype from checkbox within w_super_vas_reports_periodresults
end type
type dw_shiptypelist from datawindow within w_super_vas_reports_periodresults
end type
type cbx_showdetail from mt_u_checkbox within w_super_vas_reports_periodresults
end type
type rb_year from mt_u_radiobutton within w_super_vas_reports_periodresults
end type
type cbx_selectallvessel from checkbox within w_super_vas_reports_periodresults
end type
type rb_quarter from mt_u_radiobutton within w_super_vas_reports_periodresults
end type
type rb_month from mt_u_radiobutton within w_super_vas_reports_periodresults
end type
type dw_vasdata_per_month from datawindow within w_super_vas_reports_periodresults
end type
type dw_vas_report from datawindow within w_super_vas_reports_periodresults
end type
type vpb_progress_voyages from hprogressbar within w_super_vas_reports_periodresults
end type
type rb_vasfile from mt_u_radiobutton within w_super_vas_reports_periodresults
end type
type rb_vasreport from mt_u_radiobutton within w_super_vas_reports_periodresults
end type
type st_4 from mt_u_statictext within w_super_vas_reports_periodresults
end type
type st_1 from mt_u_statictext within w_super_vas_reports_periodresults
end type
type dw_profitcenter from datawindow within w_super_vas_reports_periodresults
end type
type cb_print from mt_u_commandbutton within w_super_vas_reports_periodresults
end type
type cb_saveas from mt_u_commandbutton within w_super_vas_reports_periodresults
end type
type cb_retreive from mt_u_commandbutton within w_super_vas_reports_periodresults
end type
type st_to from mt_u_statictext within w_super_vas_reports_periodresults
end type
type st_from from mt_u_statictext within w_super_vas_reports_periodresults
end type
type r_1 from rectangle within w_super_vas_reports_periodresults
end type
type gb_profitcenter from groupbox within w_super_vas_reports_periodresults
end type
type gb_reporttype from groupbox within w_super_vas_reports_periodresults
end type
type dw_profit_report from datawindow within w_super_vas_reports_periodresults
end type
type dw_vessellist from datawindow within w_super_vas_reports_periodresults
end type
type gb_vessel from groupbox within w_super_vas_reports_periodresults
end type
type gb_1 from groupbox within w_super_vas_reports_periodresults
end type
end forward

global type w_super_vas_reports_periodresults from mt_w_sheet
integer width = 4626
integer height = 2592
string title = "VAS Report (Periodical Results)"
boolean maxbox = false
long backcolor = 32304364
dw_to dw_to
dw_from dw_from
st_2 st_2
st_progress st_progress
vpb_progress_pcs vpb_progress_pcs
cbx_selectallshiptype cbx_selectallshiptype
dw_shiptypelist dw_shiptypelist
cbx_showdetail cbx_showdetail
rb_year rb_year
cbx_selectallvessel cbx_selectallvessel
rb_quarter rb_quarter
rb_month rb_month
dw_vasdata_per_month dw_vasdata_per_month
dw_vas_report dw_vas_report
vpb_progress_voyages vpb_progress_voyages
rb_vasfile rb_vasfile
rb_vasreport rb_vasreport
st_4 st_4
st_1 st_1
dw_profitcenter dw_profitcenter
cb_print cb_print
cb_saveas cb_saveas
cb_retreive cb_retreive
st_to st_to
st_from st_from
r_1 r_1
gb_profitcenter gb_profitcenter
gb_reporttype gb_reporttype
dw_profit_report dw_profit_report
dw_vessellist dw_vessellist
gb_vessel gb_vessel
gb_1 gb_1
end type
global w_super_vas_reports_periodresults w_super_vas_reports_periodresults

type variables
integer		ii_profitcenter[], 	ii_shiptype[]
end variables

forward prototypes
private subroutine documentation ()
private subroutine _vasdatasort (ref datawindow adw)
private subroutine _setprofitcenters (datawindow adw)
end prototypes

private subroutine documentation ();/********************************************************************
   ObjectName: w_super_vas_reports_periodresults

   <OBJECT> Presents user with criteria (profit center, vessellist and date ranges) facility to retrieve data</OBJECT>
	
   <DESC>Uses a store procedure(SP_GETVOYAGELIST) in dataobject to generate voyage/vessel list conatined in 
			  date range and profit center array. Then loops through each voyage/vessel to obtain values needed 
			  from VAS report.</DESC>
			  
   <USAGE>  Called from m_tramosmain. Used by Finance</USAGE>
	
   Date   	     Ref   	    Author        Comments
  20/01/11		  2318       JSU042        initial version
  22/08/11		  2501       JSU042        UI update
  29/08/14		  CR3781	  CCY018		   The window title match with the text of a menu item
********************************************************************/
end subroutine

private subroutine _vasdatasort (ref datawindow adw);string	ls_filter

if rb_vasreport.checked then ls_filter = ""

if rb_vasfile.checked then ls_filter = "profit_center, vessel, voyage, year, month"

if rb_month.checked or rb_quarter.checked  or rb_year.checked then ls_filter = "profit_center, year, month"

adw.setsort(ls_filter)
adw.sort()
end subroutine

private subroutine _setprofitcenters (datawindow adw);integer		li_row

//set profitcenters
for li_row = 1 to adw.rowcount()
	if li_row = 1 then
		adw.setitem(1,"profitcenters", adw.getitemstring(1,"profit_center"))
	else
		if adw.getitemstring(li_row,"profit_center") <> adw.getitemstring(li_row - 1,"profit_center") then
			adw.setitem(1,"profitcenters", adw.getitemstring(1,"profitcenters") + ", " + adw.getitemstring(li_row,"profit_center"))
		end if
	end if
next
end subroutine

on w_super_vas_reports_periodresults.create
int iCurrent
call super::create
this.dw_to=create dw_to
this.dw_from=create dw_from
this.st_2=create st_2
this.st_progress=create st_progress
this.vpb_progress_pcs=create vpb_progress_pcs
this.cbx_selectallshiptype=create cbx_selectallshiptype
this.dw_shiptypelist=create dw_shiptypelist
this.cbx_showdetail=create cbx_showdetail
this.rb_year=create rb_year
this.cbx_selectallvessel=create cbx_selectallvessel
this.rb_quarter=create rb_quarter
this.rb_month=create rb_month
this.dw_vasdata_per_month=create dw_vasdata_per_month
this.dw_vas_report=create dw_vas_report
this.vpb_progress_voyages=create vpb_progress_voyages
this.rb_vasfile=create rb_vasfile
this.rb_vasreport=create rb_vasreport
this.st_4=create st_4
this.st_1=create st_1
this.dw_profitcenter=create dw_profitcenter
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_retreive=create cb_retreive
this.st_to=create st_to
this.st_from=create st_from
this.r_1=create r_1
this.gb_profitcenter=create gb_profitcenter
this.gb_reporttype=create gb_reporttype
this.dw_profit_report=create dw_profit_report
this.dw_vessellist=create dw_vessellist
this.gb_vessel=create gb_vessel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_to
this.Control[iCurrent+2]=this.dw_from
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_progress
this.Control[iCurrent+5]=this.vpb_progress_pcs
this.Control[iCurrent+6]=this.cbx_selectallshiptype
this.Control[iCurrent+7]=this.dw_shiptypelist
this.Control[iCurrent+8]=this.cbx_showdetail
this.Control[iCurrent+9]=this.rb_year
this.Control[iCurrent+10]=this.cbx_selectallvessel
this.Control[iCurrent+11]=this.rb_quarter
this.Control[iCurrent+12]=this.rb_month
this.Control[iCurrent+13]=this.dw_vasdata_per_month
this.Control[iCurrent+14]=this.dw_vas_report
this.Control[iCurrent+15]=this.vpb_progress_voyages
this.Control[iCurrent+16]=this.rb_vasfile
this.Control[iCurrent+17]=this.rb_vasreport
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.dw_profitcenter
this.Control[iCurrent+21]=this.cb_print
this.Control[iCurrent+22]=this.cb_saveas
this.Control[iCurrent+23]=this.cb_retreive
this.Control[iCurrent+24]=this.st_to
this.Control[iCurrent+25]=this.st_from
this.Control[iCurrent+26]=this.r_1
this.Control[iCurrent+27]=this.gb_profitcenter
this.Control[iCurrent+28]=this.gb_reporttype
this.Control[iCurrent+29]=this.dw_profit_report
this.Control[iCurrent+30]=this.dw_vessellist
this.Control[iCurrent+31]=this.gb_vessel
this.Control[iCurrent+32]=this.gb_1
end on

on w_super_vas_reports_periodresults.destroy
call super::destroy
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.st_2)
destroy(this.st_progress)
destroy(this.vpb_progress_pcs)
destroy(this.cbx_selectallshiptype)
destroy(this.dw_shiptypelist)
destroy(this.cbx_showdetail)
destroy(this.rb_year)
destroy(this.cbx_selectallvessel)
destroy(this.rb_quarter)
destroy(this.rb_month)
destroy(this.dw_vasdata_per_month)
destroy(this.dw_vas_report)
destroy(this.vpb_progress_voyages)
destroy(this.rb_vasfile)
destroy(this.rb_vasreport)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.dw_profitcenter)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_retreive)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.r_1)
destroy(this.gb_profitcenter)
destroy(this.gb_reporttype)
destroy(this.dw_profit_report)
destroy(this.dw_vessellist)
destroy(this.gb_vessel)
destroy(this.gb_1)
end on

event open;integer   li_empty[]
datetime ldt_start, ldt_end

//set dates datawindow
dw_from.settransobject(sqlca)
dw_from.insertrow(0)
dw_from.setitem(1,"date",today())
dw_to.settransobject(sqlca)
dw_to.insertrow(0)
dw_to.setitem(1,"date",today())

//set profitcenter by userid and select the first row
dw_profitcenter.setTransObject(SQLCA)
dw_profitcenter.setRowFocusindicator( focusrect!)
dw_profitcenter.retrieve(uo_global.is_userid)
setfocus(dw_profitcenter)
if dw_profitcenter.rowcount() > 0 then dw_profitcenter.SelectRow(1, true)

dw_profit_report.settransobject(sqlca)
dw_vessellist.setTransObject(SQLCA)
dw_shiptypelist.setTransObject(SQLCA)

//set the default dates
ldt_start=datetime("01/01/1900")
ldt_end=datetime("01/01/2200")

//set the profitcenter array
ii_profitcenter = li_empty
ii_profitcenter[1] = dw_profitcenter.getitemnumber(1,"pc_nr")

//retrieve vessel list
if upperbound(ii_profitcenter) > 0 then
	dw_shiptypelist.retrieve(ii_profitcenter)
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_super_vas_reports_periodresults
end type

type dw_to from datawindow within w_super_vas_reports_periodresults
integer x = 3232
integer y = 144
integer width = 343
integer height = 56
integer taborder = 40
string title = "none"
string dataobject = "d_datepicker"
boolean border = false
boolean livescroll = true
end type

type dw_from from datawindow within w_super_vas_reports_periodresults
integer x = 3232
integer y = 60
integer width = 343
integer height = 56
integer taborder = 50
string title = "none"
string dataobject = "d_datepicker"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 32
integer y = 2284
integer width = 343
long backcolor = 32304364
string text = "Profitcenter(s):"
end type

type st_progress from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 32
integer y = 2388
integer width = 1367
long backcolor = 32304364
string text = ""
end type

type vpb_progress_pcs from hprogressbar within w_super_vas_reports_periodresults
integer x = 375
integer y = 2284
integer width = 4174
integer height = 64
unsignedinteger maxposition = 100
unsignedinteger position = 1
end type

type cbx_selectallshiptype from checkbox within w_super_vas_reports_periodresults
integer x = 1486
integer y = 20
integer width = 334
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;integer	li_empty[]
integer   li_x, li_count
datetime ldt_start, ldt_end

//set the default dates
ldt_start=datetime("01/01/1900")
ldt_end=datetime("01/01/2200")

ii_shiptype = li_empty

if this.checked then
	dw_shiptypelist.selectRow(0, TRUE)
	this.text = "Deselect all"
	this.textcolor = rgb(255,255,255)
	for li_x = 1 to dw_shiptypelist.rowCount()
		li_count ++
		ii_shiptype[li_count] = dw_shiptypelist.getItemNumber(li_x, "cal_vest_type_id")
	next
	dw_vessellist.retrieve(ii_profitcenter,ldt_start, ldt_end, ii_shiptype)
else
	dw_shiptypelist.selectRow(0, FALSE)
	this.text = "Select all"
	this.textcolor = rgb(255,255,255)
	dw_vessellist.reset()
end if

//reset select all
cbx_selectallvessel.text = "Select all"
cbx_selectallvessel.checked = false


end event

type dw_shiptypelist from datawindow within w_super_vas_reports_periodresults
integer x = 823
integer y = 80
integer width = 969
integer height = 432
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_shiptypes_profitcenter"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer	li_empty[]
integer   li_x, li_count
datetime ldt_start, ldt_end

//set the default dates
ldt_start=datetime("01/01/1900")
ldt_end=datetime("01/01/2200")

//set the shiptype array
if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	if this.rowCount() <= 0 then 
		_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one shiptype.", "User warning.")
		return c#return.Failure
	end if
	ii_shiptype = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			ii_shiptype[li_count] = this.getItemNumber(li_x, "cal_vest_type_id")
		end if
	next
end if

//retrieve vessel list
if upperbound(ii_shiptype) > 0 then
	dw_vessellist.retrieve(ii_profitcenter,ldt_start, ldt_end, ii_shiptype)
else
	dw_vessellist.reset()
end if

//reset select all
cbx_selectallvessel.text = "Select all"
cbx_selectallvessel.checked = false

//reset report dw
dw_profit_report.reset()
end event

type cbx_showdetail from mt_u_checkbox within w_super_vas_reports_periodresults
boolean visible = false
integer x = 4224
integer y = 500
integer width = 338
integer height = 56
integer textsize = -8
long textcolor = 33554431
long backcolor = 22628899
string text = "Show detail"
boolean lefttext = true
end type

event clicked;call super::clicked;if cbx_showdetail.checked then
	dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = Yes")
else
	dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")
end if

end event

type rb_year from mt_u_radiobutton within w_super_vas_reports_periodresults
integer x = 3694
integer y = 384
integer width = 567
integer height = 64
long textcolor = 16777215
long backcolor = 22628899
string text = "Show results by year"
end type

event clicked;call super::clicked;//Set dataobject
dw_profit_report.DataObject = "d_vas_file_periodresult_year"

// sharedata between  dw_vasdata_per_month and dw_profit_report
_vasdatasort( dw_vasdata_per_month )
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)

cbx_showdetail.visible = false
cbx_showdetail.checked = false
dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")

end event

type cbx_selectallvessel from checkbox within w_super_vas_reports_periodresults
integer x = 2720
integer y = 20
integer width = 334
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;if this.checked then
	dw_vessellist.selectRow(0, TRUE)
	this.text = "Deselect all"
	this.textcolor = rgb(255,255,255)
else
	dw_vessellist.selectRow(0, FALSE)
	this.text = "Select all"
	this.textcolor = rgb(255,255,255)
end if
end event

type rb_quarter from mt_u_radiobutton within w_super_vas_reports_periodresults
integer x = 3694
integer y = 304
integer width = 603
integer height = 64
long textcolor = 16777215
long backcolor = 22628899
string text = "Show results by quarter"
end type

event clicked;call super::clicked;//Set dataobject
dw_profit_report.DataObject = "d_vas_file_periodresult_quarter"

// sharedata between  dw_vasdata_per_month and dw_profit_report
_vasdatasort( dw_vasdata_per_month )
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)

cbx_showdetail.visible = false
cbx_showdetail.checked = false
dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")
end event

type rb_month from mt_u_radiobutton within w_super_vas_reports_periodresults
integer x = 3694
integer y = 224
integer width = 603
integer height = 64
long textcolor = 16777215
long backcolor = 22628899
string text = "Show results by month"
end type

event clicked;call super::clicked;//Set dataobject
dw_profit_report.DataObject = "d_vas_file_periodresult_month"

// sharedata between  dw_vasdata_per_month and dw_profit_report
_vasdatasort( dw_vasdata_per_month )
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)

cbx_showdetail.visible = false
cbx_showdetail.checked = false
dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")
end event

type dw_vasdata_per_month from datawindow within w_super_vas_reports_periodresults
boolean visible = false
integer x = 2450
integer y = 896
integer width = 1829
integer height = 944
integer taborder = 30
string title = "none"
string dataobject = "d_vas_report_periodresult_month"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_vas_report from datawindow within w_super_vas_reports_periodresults
boolean visible = false
integer x = 2450
integer y = 544
integer width = 1829
integer height = 320
integer taborder = 40
string title = "none"
string dataobject = "d_vas_report_a4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type vpb_progress_voyages from hprogressbar within w_super_vas_reports_periodresults
integer x = 1417
integer y = 2372
integer width = 2103
integer height = 64
unsignedinteger maxposition = 100
unsignedinteger position = 1
end type

type rb_vasfile from mt_u_radiobutton within w_super_vas_reports_periodresults
integer x = 3657
integer y = 144
integer width = 603
integer height = 64
long textcolor = 16777215
long backcolor = 22628899
string text = "Vas File (Detail Est/Act)"
end type

event clicked;call super::clicked;long		ll_row

//Set dataobject
dw_profit_report.DataObject = "d_vas_file_periodresult"

// sharedata between dw_vasdata_per_month and dw_profit_report
_vasdatasort( dw_vasdata_per_month )
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)


cbx_showdetail.visible = true
cbx_showdetail.checked = false
dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")



end event

type rb_vasreport from mt_u_radiobutton within w_super_vas_reports_periodresults
integer x = 3657
integer y = 64
integer width = 347
integer height = 64
long textcolor = 16777215
long backcolor = 22628899
string text = "Vas Report"
boolean checked = true
end type

event clicked;call super::clicked;//Set dataobject
dw_profit_report.DataObject = "d_vas_report_periodresult"

// sharedata between  dw_vasdata_per_month and dw_profit_report
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)

cbx_showdetail.visible = false
cbx_showdetail.checked = false
dw_profit_report.Modify("DataWindow.Detail.Height.AutoSize = No")



end event

type st_4 from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 3109
integer y = 144
integer width = 73
integer height = 56
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_1 from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 3109
integer y = 60
integer width = 128
integer height = 56
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type dw_profitcenter from datawindow within w_super_vas_reports_periodresults
integer x = 73
integer y = 80
integer width = 640
integer height = 432
integer taborder = 20
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;integer   li_empty[]
integer   li_x, li_count

//set the profitcenter array
if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	if this.rowCount() <= 0 then 
		_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one profitcenter.", "User warning.")
		return c#return.Failure
	end if
	ii_profitcenter = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			ii_profitcenter[li_count] = this.getItemNumber(li_x, "pc_nr")
		end if
	next
end if

//retrieve shiptype list
if upperbound(ii_profitcenter) > 0 then
	dw_shiptypelist.retrieve(ii_profitcenter)
else
	dw_shiptypelist.reset()
end if

//reset vessel list
dw_vessellist.reset()

//reset select all
cbx_selectallshiptype.text = "Select all"
cbx_selectallshiptype.checked = false
cbx_selectallvessel.text = "Select all"
cbx_selectallvessel.checked = false

//reset report dw
dw_profit_report.reset()
end event

type cb_print from mt_u_commandbutton within w_super_vas_reports_periodresults
integer x = 4210
integer y = 2372
integer taborder = 50
string text = "&Print"
end type

event clicked;call super::clicked;//if cbx_onlysummary.checked then
//	dw_summary.Print(false,true)
//else
//	dw_kpi.Print(false,true)
//end if
dw_profit_report.print(false,true)
end event

type cb_saveas from mt_u_commandbutton within w_super_vas_reports_periodresults
integer x = 3872
integer y = 2372
integer taborder = 40
string text = "&Save As..."
end type

event clicked;call super::clicked;string ls_folder_data, ls_path, ls_file 
integer li_rtn
	
if rb_vasfile.checked then
	dw_profit_report.saveas()
else
	li_rtn = GetFileSaveName ( "Select File", &
	ls_path, ls_file, "TXT", &
	"All Files (*.*),*.*" , "", &
	32770)
	
	if li_rtn < 1 then return c#return.Failure
	
	dw_profit_report.SaveAsAscii(ls_path,";","")
end if

end event

type cb_retreive from mt_u_commandbutton within w_super_vas_reports_periodresults
integer x = 3534
integer y = 2372
integer taborder = 30
string text = "&Retrieve"
end type

event clicked;call super::clicked;datetime									ldt_start_date, ldt_end_date
long										ll_count
n_vas_data_periodresult				ln_vas_data_periodresult
integer									li_vessel
string										ls_vessel_filter

/* validate profitcenters */
if upperbound(ii_profitcenter) <= 0 then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one profitcenter.", "User warning.")
	return c#return.Failure
end if

/* validate shiptypes */
if upperbound(ii_shiptype) <= 0 then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one shiptype.", "User warning.")
	return c#return.Failure
end if	

/* validate vessels */
for li_vessel = 1 to dw_vessellist.rowcount()
	if dw_vessellist.isSelected(li_vessel) then
		if ls_vessel_filter = "" then
			ls_vessel_filter = string(dw_vessellist.getitemnumber(li_vessel,"vessel_nr"))
		else
			ls_vessel_filter = ls_vessel_filter + ", " +string(dw_vessellist.getitemnumber(li_vessel,"vessel_nr"))
		end if
	end if
next
if  ls_vessel_filter = "" then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one vessel.", "User warning.")
	return c#return.Failure
end if

/* validate date range */
dw_from.accepttext()
dw_to.accepttext()
ldt_start_date = datetime(dw_from.getitemdate(1, "date"))
ldt_end_date = datetime(dw_to.getitemdate(1, "date"))
if isnull(ldt_start_date) then
	_addmessage(this.classdefinition , "cb_retreive.click()", "From date is empty. Please enter again.", "User warning.")
	dw_from.setfocus()
	return c#return.Failure
end if
if  isnull(ldt_end_date) then
	_addmessage(this.classdefinition , "cb_retreive.click()", "End date is empty. Please enter again.", "User warning.")
	dw_to.setfocus()
	return c#return.Failure
end if
if (ldt_end_date < ldt_start_date) then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Your end date comes before your start date. Please enter again.", "User warning.")
	return c#return.Failure
end if

/* validate report type */
if not rb_vasreport.checked and not rb_vasfile.checked and not rb_month.checked and not rb_quarter.checked and not rb_year.checked then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select the report type.", "User warning.")
	return c#return.Failure
end if

/* reset dw*/
dw_profit_report.reset()
dw_vasdata_per_month.reset()

/* get the breaked down VAS detail per month, and store in dw_vasdata_per_month */
ln_vas_data_periodresult.of_getvasdatapermonth(ii_profitcenter, ldt_start_date, ldt_end_date, dw_vasdata_per_month, vpb_progress_voyages, dw_vas_report, ls_vessel_filter, vpb_progress_pcs)

/* sharedata between dw_vasdata_per_month and dw_profit_report */
_vasdatasort( dw_vasdata_per_month )
dw_vasdata_per_month.sharedata(dw_profit_report)
_setprofitcenters(dw_profit_report)





end event

type st_to from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 279
integer y = 216
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_from from mt_u_statictext within w_super_vas_reports_periodresults
integer x = 279
integer y = 104
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type r_1 from rectangle within w_super_vas_reports_periodresults
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4608
integer height = 592
end type

type gb_profitcenter from groupbox within w_super_vas_reports_periodresults
integer x = 37
integer y = 16
integer width = 713
integer height = 528
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profitcenter(s)"
end type

type gb_reporttype from groupbox within w_super_vas_reports_periodresults
integer x = 3621
integer y = 16
integer width = 695
integer height = 464
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Report Type"
end type

type dw_profit_report from datawindow within w_super_vas_reports_periodresults
integer x = 37
integer y = 624
integer width = 4517
integer height = 1632
integer taborder = 30
string title = "none"
string dataobject = "d_vas_report_periodresult"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_vessellist from datawindow within w_super_vas_reports_periodresults
integer x = 1902
integer y = 80
integer width = 1134
integer height = 432
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_vessel_given_profitcenter_shiptype"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if


//reset report dw
dw_profit_report.reset()
end event

type gb_vessel from groupbox within w_super_vas_reports_periodresults
integer x = 1865
integer y = 16
integer width = 1207
integer height = 528
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessel(s) to include"
end type

type gb_1 from groupbox within w_super_vas_reports_periodresults
integer x = 786
integer y = 16
integer width = 1042
integer height = 528
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Shiptype(s) to include"
end type

