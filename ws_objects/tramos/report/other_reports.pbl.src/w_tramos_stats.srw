$PBExportHeader$w_tramos_stats.srw
forward
global type w_tramos_stats from mt_w_sheet
end type
type em_year from editmask within w_tramos_stats
end type
type st_1 from statictext within w_tramos_stats
end type
type dw_stats_report from datawindow within w_tramos_stats
end type
type cbx_selectallshiptype from checkbox within w_tramos_stats
end type
type dw_shiptypelist from datawindow within w_tramos_stats
end type
type cbx_selectallvessel from checkbox within w_tramos_stats
end type
type dw_profitcenter from datawindow within w_tramos_stats
end type
type cb_print from mt_u_commandbutton within w_tramos_stats
end type
type cb_saveas from mt_u_commandbutton within w_tramos_stats
end type
type cb_retreive from mt_u_commandbutton within w_tramos_stats
end type
type st_to from mt_u_statictext within w_tramos_stats
end type
type st_from from mt_u_statictext within w_tramos_stats
end type
type r_1 from rectangle within w_tramos_stats
end type
type gb_profitcenter from groupbox within w_tramos_stats
end type
type dw_vessellist from datawindow within w_tramos_stats
end type
type gb_vessel from groupbox within w_tramos_stats
end type
type gb_1 from groupbox within w_tramos_stats
end type
end forward

global type w_tramos_stats from mt_w_sheet
integer width = 3543
integer height = 2568
string title = "Tramos Stats"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
em_year em_year
st_1 st_1
dw_stats_report dw_stats_report
cbx_selectallshiptype cbx_selectallshiptype
dw_shiptypelist dw_shiptypelist
cbx_selectallvessel cbx_selectallvessel
dw_profitcenter dw_profitcenter
cb_print cb_print
cb_saveas cb_saveas
cb_retreive cb_retreive
st_to st_to
st_from st_from
r_1 r_1
gb_profitcenter gb_profitcenter
dw_vessellist dw_vessellist
gb_vessel gb_vessel
gb_1 gb_1
end type
global w_tramos_stats w_tramos_stats

type variables
integer		ii_profitcenter[], 	ii_shiptype[]
end variables

forward prototypes
private subroutine documentation ()
private subroutine _vasdatasort (ref datawindow adw)
private subroutine _setprofitcenters (datawindow adw)
end prototypes

private subroutine documentation ();/********************************************************************
   ObjectName: w_tramos_stats

   <OBJECT> Presents user with criteria (profit center, shiptype, vessel list and year) facility to retrieve data</OBJECT>
	
   <DESC></DESC>
			  
   <USAGE>Called from m_tramosmain</USAGE>
	
   Date   	     Ref   	    Author        Comments
  20/01/11		2395     	CONASW	     Initial version
********************************************************************/
end subroutine

private subroutine _vasdatasort (ref datawindow adw);
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

on w_tramos_stats.create
int iCurrent
call super::create
this.em_year=create em_year
this.st_1=create st_1
this.dw_stats_report=create dw_stats_report
this.cbx_selectallshiptype=create cbx_selectallshiptype
this.dw_shiptypelist=create dw_shiptypelist
this.cbx_selectallvessel=create cbx_selectallvessel
this.dw_profitcenter=create dw_profitcenter
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_retreive=create cb_retreive
this.st_to=create st_to
this.st_from=create st_from
this.r_1=create r_1
this.gb_profitcenter=create gb_profitcenter
this.dw_vessellist=create dw_vessellist
this.gb_vessel=create gb_vessel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_stats_report
this.Control[iCurrent+4]=this.cbx_selectallshiptype
this.Control[iCurrent+5]=this.dw_shiptypelist
this.Control[iCurrent+6]=this.cbx_selectallvessel
this.Control[iCurrent+7]=this.dw_profitcenter
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.cb_saveas
this.Control[iCurrent+10]=this.cb_retreive
this.Control[iCurrent+11]=this.st_to
this.Control[iCurrent+12]=this.st_from
this.Control[iCurrent+13]=this.r_1
this.Control[iCurrent+14]=this.gb_profitcenter
this.Control[iCurrent+15]=this.dw_vessellist
this.Control[iCurrent+16]=this.gb_vessel
this.Control[iCurrent+17]=this.gb_1
end on

on w_tramos_stats.destroy
call super::destroy
destroy(this.em_year)
destroy(this.st_1)
destroy(this.dw_stats_report)
destroy(this.cbx_selectallshiptype)
destroy(this.dw_shiptypelist)
destroy(this.cbx_selectallvessel)
destroy(this.dw_profitcenter)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_retreive)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.r_1)
destroy(this.gb_profitcenter)
destroy(this.dw_vessellist)
destroy(this.gb_vessel)
destroy(this.gb_1)
end on

event open;Integer li_empty[], li_year

w_tramos_stats.Move(0,0)

//set profitcenter by userid and select the first row
dw_profitcenter.setTransObject(SQLCA)
dw_profitcenter.setRowFocusindicator( focusrect!)
dw_profitcenter.retrieve(uo_global.is_userid)
setfocus(dw_profitcenter)
if dw_profitcenter.rowcount() > 0 then dw_profitcenter.SelectRow(1, true)

dw_vessellist.setTransObject(SQLCA)
dw_shiptypelist.setTransObject(SQLCA)

//set the profitcenter array
ii_profitcenter = li_empty
ii_profitcenter[1] = dw_profitcenter.getitemnumber(1,"pc_nr")

//retrieve vessel list
if upperbound(ii_profitcenter) > 0 then
	dw_shiptypelist.retrieve(ii_profitcenter)
end if

//Fill year box
em_year.text = string(year(today()))

// set report transobject
dw_stats_report.SetTransObject(SQLCA)
end event

type em_year from editmask within w_tramos_stats
integer x = 3255
integer y = 64
integer width = 233
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0000"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
string minmax = "2000~~2999"
end type

type st_1 from statictext within w_tramos_stats
integer x = 3109
integer y = 80
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Year"
boolean focusrectangle = false
end type

type dw_stats_report from datawindow within w_tramos_stats
integer x = 18
integer y = 608
integer width = 3474
integer height = 1744
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_tramos_stats"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cbx_selectallshiptype from checkbox within w_tramos_stats
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

type dw_shiptypelist from datawindow within w_tramos_stats
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


end event

type cbx_selectallvessel from checkbox within w_tramos_stats
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

type dw_profitcenter from datawindow within w_tramos_stats
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
dw_stats_report.reset()
end event

type cb_print from mt_u_commandbutton within w_tramos_stats
integer x = 3150
integer y = 2372
integer taborder = 50
string text = "&Print"
end type

event clicked;call super::clicked;
dw_stats_report.print(false,true)
end event

type cb_saveas from mt_u_commandbutton within w_tramos_stats
integer x = 2793
integer y = 2372
integer taborder = 40
string text = "&Save As..."
end type

event clicked;call super::clicked;	
dw_stats_report.saveas()

end event

type cb_retreive from mt_u_commandbutton within w_tramos_stats
integer x = 2437
integer y = 2372
integer taborder = 30
string text = "&Retrieve"
end type

event clicked;call super::clicked;Integer li_vessel, li_Count = 0
Long ll_vessels[]

/* validate profitcenters */
If upperbound(ii_profitcenter) <= 0 then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one profitcenter.", "User warning.")
	return c#return.Failure
End if

/* validate shiptypes */
If upperbound(ii_shiptype) <= 0 then
	_addmessage(this.classdefinition , "cb_retreive.click()", "Please select at least one shiptype.", "User warning.")
	return c#return.Failure
End if	

/* validate vessels */
For li_vessel = 1 to dw_vessellist.rowcount()
	If dw_vessellist.isSelected(li_vessel) then 
		li_Count += 1
		ll_vessels[li_Count] = dw_vessellist.getitemnumber(li_vessel,"vessel_nr")	
	End If
Next

If li_Count=0 Then
	Messagebox("No Vessel Selected","Please select at least one vessel!", Exclamation!)
	Return
End If

/* reset & retrieve dw*/
If dw_Stats_Report.Retrieve(Right(em_year.text,2), ll_Vessels)<0 then Messagebox("Error","An error occurred")









end event

type st_to from mt_u_statictext within w_tramos_stats
integer x = 279
integer y = 216
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_from from mt_u_statictext within w_tramos_stats
integer x = 279
integer y = 104
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type r_1 from rectangle within w_tramos_stats
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4608
integer height = 592
end type

type gb_profitcenter from groupbox within w_tramos_stats
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

type dw_vessellist from datawindow within w_tramos_stats
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
dw_stats_report.reset()
end event

type gb_vessel from groupbox within w_tramos_stats
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

type gb_1 from groupbox within w_tramos_stats
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

