$PBExportHeader$w_vessels_heading_report.srw
$PBExportComments$Vessels on their way to...shows all vessels on heading a specific port or country. Select from POC and EST_POC
forward
global type w_vessels_heading_report from mt_w_main
end type
type dw_list from mt_u_datawindow within w_vessels_heading_report
end type
type st_2 from statictext within w_vessels_heading_report
end type
type cb_saveas from commandbutton within w_vessels_heading_report
end type
type cb_print from commandbutton within w_vessels_heading_report
end type
type cb_retrieve from commandbutton within w_vessels_heading_report
end type
type dw_report from mt_u_datawindow within w_vessels_heading_report
end type
type gb_1 from groupbox within w_vessels_heading_report
end type
type gb_4 from mt_u_groupbox within w_vessels_heading_report
end type
type st_3 from u_topbar_background within w_vessels_heading_report
end type
type dw_date from mt_u_datawindow within w_vessels_heading_report
end type
type cbx_selectall from mt_u_checkbox within w_vessels_heading_report
end type
type uo_search from u_creq_search within w_vessels_heading_report
end type
type rb_port from radiobutton within w_vessels_heading_report
end type
type rb_country from radiobutton within w_vessels_heading_report
end type
type rb_area from radiobutton within w_vessels_heading_report
end type
end forward

global type w_vessels_heading_report from mt_w_main
integer width = 3945
integer height = 2568
string title = "Vessels on Their Way To"
boolean maxbox = false
boolean resizable = false
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
dw_list dw_list
st_2 st_2
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
dw_report dw_report
gb_1 gb_1
gb_4 gb_4
st_3 st_3
dw_date dw_date
cbx_selectall cbx_selectall
uo_search uo_search
rb_port rb_port
rb_country rb_country
rb_area rb_area
end type
global w_vessels_heading_report w_vessels_heading_report

type variables
constant int ii_PORT = 1, ii_COUNTRY = 2, ii_AREA = 3
end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_selecttype (integer ai_type)
end prototypes

public subroutine documentation ();/********************************************************************
	ObjectName: w_vessels_heading_report
	<OBJECT> Report </OBJECT>
	<DESC> Event Description </DESC>
	<USAGE>
		Contains shared business logic that is used in both child objects
	</USAGE>
	<ALSO>
		otherobjs
	</ALSO>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		18/02/13		CR????		AGL027		Moved into MT framework & modified n_exportdata call
		01/09/14		CR3781		CCY018		The window title match with the text of a menu item
		05/09/16		CR3502		XSZ004		UI standard.
		09/11/16		CR3502UAT1	XSZ004		Fix bug.
	</HISTORY>
********************************************************************/
end subroutine

public subroutine wf_selecttype (integer ai_type);/********************************************************************
   wf_selecttype
   <DESC></DESC>
   <RETURN> </RETURN> 
   <ACCESS> </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		05/09/16		CR3502		XSZ004		First version.
   </HISTORY>
********************************************************************/

string ls_search_fields
int    li_reporttype

choose case ai_type
		
	case ii_PORT
		
		if dw_List.dataobject = "d_port_picklist" then return
		
		gb_1.text = "Port Selection"
		
		dw_List.DataObject = "d_port_picklist"
		dw_List.SetTransObject(SQLCA)
		
		dw_list.modify("DataWindow.Detail.Color = 16777215 DataWindow.Header.Color = 16777215")
		dw_list.modify("port_n.width = 936 port_code_t.font.weight = 700 port_n_t.font.weight = 700")
		
		dw_list.Retrieve(0, 9999)
		
		dw_Report.Modify("country_name.visible=0 areaname.visible=0")
		
		ls_search_fields = "port_code + ' ' + port_n"	
		
	case ii_COUNTRY
		
		if dw_List.dataobject = "d_sq_gr_countrylist" then return
		
		gb_1.text = "Country Selection"
			
		dw_List.DataObject = "d_sq_gr_countrylist"
		dw_List.SetTransObject(SQLCA)
		dw_List.Retrieve()
		
		dw_Report.Modify("areaname.visible=0 country_name.visible=1 country_name.x=0 country_name.y=4")
		
		ls_search_fields = "country_name + ' ' + country_sn3"	
	
	case ii_AREA
		
		if dw_List.dataobject = "d_sq_gr_arealist" then return
		
		gb_1.text = "Area Selection"
		
		dw_List.DataObject = "d_sq_gr_arealist"
		dw_List.SetTransObject(SQLCA)
		dw_List.Retrieve()
		
		dw_Report.Modify("country_name.visible=0 areaname.visible=1 areaname.x=0 areaname.y=4")
		
		ls_search_fields = "area_name + ' ' + area_sn"
	
end choose

dw_Report.Reset()

cb_print.Enabled  = False
cb_saveas.Enabled = False

cbx_selectall.checked = false
cbx_selectall.text    = "Select all"
cbx_selectall.textcolor = rgb(255, 255, 255)

uo_search.sle_search.text = ""
uo_search.of_initialize(dw_list, ls_search_fields)
uo_search.of_setoriginalfilter("compute_selected = 1")

dw_list.setrowfocusindicator(FocusRect!)
end subroutine

on w_vessels_heading_report.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.st_2=create st_2
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_4=create gb_4
this.st_3=create st_3
this.dw_date=create dw_date
this.cbx_selectall=create cbx_selectall
this.uo_search=create uo_search
this.rb_port=create rb_port
this.rb_country=create rb_country
this.rb_area=create rb_area
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_retrieve
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_4
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.dw_date
this.Control[iCurrent+11]=this.cbx_selectall
this.Control[iCurrent+12]=this.uo_search
this.Control[iCurrent+13]=this.rb_port
this.Control[iCurrent+14]=this.rb_country
this.Control[iCurrent+15]=this.rb_area
end on

on w_vessels_heading_report.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.st_3)
destroy(this.dw_date)
destroy(this.cbx_selectall)
destroy(this.uo_search)
destroy(this.rb_port)
destroy(this.rb_country)
destroy(this.rb_area)
end on

event open;this.move(0, 0)

dw_report.setTransObject(SQLCA)
dw_report.setrowfocusindicator(FocusRect!)

dw_date.modify("datawindow.detail.height = 64 date.EditMask.Mask = 'dd-mm-yy' date.Alignment = 2 date.y = 4 date.width = 300 date.height  = 56")
dw_date.modify("date.EditMask.DDCalendar = true")
dw_date.insertrow(0)
dw_date.setitem(1, "date", today())

wf_selecttype(ii_PORT)
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_vessels_heading_report
integer x = 0
integer y = 0
end type

type dw_list from mt_u_datawindow within w_vessels_heading_report
integer x = 1481
integer y = 80
integer width = 1207
integer height = 456
integer taborder = 40
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
end type

event retrieveend;
This.SelectRow(0, False)
end event

event clicked;call super::clicked;if row < 1 then return

this.selectrow(row, not this.isselected(row))
end event

type st_2 from statictext within w_vessels_heading_report
integer x = 2747
integer y = 80
integer width = 279
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Start Date"
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_vessels_heading_report
integer x = 3205
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;n_dataexport lnv_exp

lnv_exp.of_export(dw_report)

end event

type cb_print from commandbutton within w_vessels_heading_report
integer x = 3552
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;n_dataprint lnv_print

lnv_print.of_print(dw_report)



end event

type cb_retrieve from commandbutton within w_vessels_heading_report
integer x = 2857
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;String   ls_Port[], ls_ID = "", ls_columnname, ls_sort
Integer  li_Row = 0, li_reporttype
datetime ldt_start

mt_n_Datastore lds_Ports

dw_date.accepttext()
dw_Report.Reset()

li_Row = dw_List.GetSelectedRow(0)

if li_Row < 1 then
	Messagebox("Nothing Selected", "You must select at least one item from the list!", Exclamation!)
	return	
end if

if rb_port.checked then
	
	do while li_row > 0
		ls_Port[UpperBound(ls_Port) + 1] = dw_List.GetItemString(li_Row, "port_code")
		li_Row = dw_List.GetSelectedRow(li_Row)
	loop
	
	ls_sort = "port_name A, profit_center A, vessel_nr A, voyage_number A"
else		
	if rb_country.checked then
		ls_columnname = "country_id"
		ls_sort       = "country_name A, port_name A, profit_center A, vessel_nr A, voyage_number A"
	else
		ls_columnname = "area_pk"
		ls_sort       = "areaname A, port_name A, profit_center A, vessel_nr A, voyage_number A"
	end if
	
	do while li_row > 0
		ls_ID += String(dw_List.GetItemNumber(li_Row, ls_columnname)) + ","
		li_Row = dw_List.GetSelectedRow(li_Row)
	loop
	
	lds_Ports = create mt_n_Datastore
	lds_Ports.DataObject = "d_sq_tb_portbygroup"	
	
	ls_ID = Left(ls_ID, Len(ls_ID) - 1)
	
	if rb_area.checked then
		lds_Ports.SetSQLSelect("SELECT PORT_CODE from AREA_PORTS Where AREA_PK In (" + ls_ID + ")")
	else
		lds_Ports.SetSQLSelect("SELECT PORT_CODE from PORTS Where COUNTRY_ID In (" + ls_ID + ")")
	end If
	
	lds_Ports.SetTransObject(SQLCA)	
	lds_Ports.Retrieve()
	
	for li_Row = 1 to lds_Ports.RowCount()
		ls_Port[li_Row] = lds_Ports.GetItemString(li_Row, "PORT_CODE")
	next
	
	destroy lds_Ports
end if

ldt_start = datetime(dw_date.getitemdate(1, "date"))

if upperbound(ls_Port) > 0 then
	dw_report.modify("datawindow.table.sort = '" + ls_sort + "'")
	dw_Report.Retrieve(ldt_start, ls_Port, uo_global.is_userid)
else
	Messagebox("Nothing Found", "No vessels were found for the current selection.", Information!)
end if

cb_Print.Enabled = (dw_Report.RowCount() > 0)
cb_SaveAs.Enabled = (dw_Report.RowCount() > 0)
end event

type dw_report from mt_u_datawindow within w_vessels_heading_report
integer x = 37
integer y = 624
integer width = 3854
integer height = 1736
integer taborder = 60
string dataobject = "d_sq_tb_heading_to"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
end type

event retrieveend;

If rowcount = 0 then Messagebox("Nothing Found", "No vessels were found for the current selection.", Information!)
	
end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

type gb_1 from groupbox within w_vessels_heading_report
integer x = 462
integer y = 16
integer width = 2263
integer height = 556
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Port Selection"
end type

type gb_4 from mt_u_groupbox within w_vessels_heading_report
integer x = 37
integer y = 16
integer width = 398
integer height = 316
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Type"
end type

type st_3 from u_topbar_background within w_vessels_heading_report
integer height = 592
end type

type dw_date from mt_u_datawindow within w_vessels_heading_report
integer x = 2994
integer y = 80
integer width = 311
integer height = 64
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_datepicker"
boolean border = false
end type

type cbx_selectall from mt_u_checkbox within w_vessels_heading_report
integer x = 2368
integer y = 4
integer width = 320
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;if this.checked then
	dw_list.selectrow(0, this.checked)
	this.text = "Deselect all"
else
	dw_list.selectrow(0, this.checked)
	this.text = "Select all"
end if

this.textcolor = rgb(255, 255, 255)

end event

type uo_search from u_creq_search within w_vessels_heading_report
integer x = 503
integer y = 80
integer taborder = 20
boolean bringtotop = true
boolean ib_standard_ui_topbar = true
boolean ib_scrolltocurrentrow = true
end type

on uo_search.destroy
call u_creq_search::destroy
end on

event ue_prekeypress;call super::ue_prekeypress;if key = keyenter! or key = keytab! then return c#return.failure
end event

type rb_port from radiobutton within w_vessels_heading_report
integer x = 69
integer y = 76
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "By Port"
boolean checked = true
end type

event clicked;wf_selecttype(ii_PORT)
end event

type rb_country from radiobutton within w_vessels_heading_report
integer x = 69
integer y = 156
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "By Country"
end type

event clicked;wf_selecttype(ii_COUNTRY)
end event

type rb_area from radiobutton within w_vessels_heading_report
integer x = 69
integer y = 236
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "By Area"
end type

event clicked;wf_selecttype(ii_AREA)
end event

