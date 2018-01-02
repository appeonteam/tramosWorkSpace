$PBExportHeader$w_port_spend_management_stats.srw
$PBExportComments$Window for all  port owner matter reports generation
forward
global type w_port_spend_management_stats from mt_w_sheet
end type
type dw_reporttype from mt_u_datawindow within w_port_spend_management_stats
end type
type dw_vessellist from u_datagrid within w_port_spend_management_stats
end type
type dw_shiptypelist from u_datagrid within w_port_spend_management_stats
end type
type dw_profitcenter from u_datagrid within w_port_spend_management_stats
end type
type cbx_pc from checkbox within w_port_spend_management_stats
end type
type dw_to from mt_u_datawindow within w_port_spend_management_stats
end type
type dw_from from mt_u_datawindow within w_port_spend_management_stats
end type
type cbx_selectallshiptype from checkbox within w_port_spend_management_stats
end type
type cbx_selectallvessel from checkbox within w_port_spend_management_stats
end type
type st_4 from mt_u_statictext within w_port_spend_management_stats
end type
type st_1 from mt_u_statictext within w_port_spend_management_stats
end type
type cb_print from mt_u_commandbutton within w_port_spend_management_stats
end type
type cb_saveas from mt_u_commandbutton within w_port_spend_management_stats
end type
type cb_retreive from mt_u_commandbutton within w_port_spend_management_stats
end type
type st_to from mt_u_statictext within w_port_spend_management_stats
end type
type st_from from mt_u_statictext within w_port_spend_management_stats
end type
type r_1 from rectangle within w_port_spend_management_stats
end type
type gb_profitcenter from groupbox within w_port_spend_management_stats
end type
type gb_reporttype from groupbox within w_port_spend_management_stats
end type
type dw_owner_matter_report from mt_u_datawindow within w_port_spend_management_stats
end type
type gb_vessel from groupbox within w_port_spend_management_stats
end type
type gb_1 from groupbox within w_port_spend_management_stats
end type
type dw_portdata from mt_u_datawindow within w_port_spend_management_stats
end type
end forward

global type w_port_spend_management_stats from mt_w_sheet
integer width = 4599
integer height = 2588
string title = "Port Spend Management Stats"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve ( )
dw_reporttype dw_reporttype
dw_vessellist dw_vessellist
dw_shiptypelist dw_shiptypelist
dw_profitcenter dw_profitcenter
cbx_pc cbx_pc
dw_to dw_to
dw_from dw_from
cbx_selectallshiptype cbx_selectallshiptype
cbx_selectallvessel cbx_selectallvessel
st_4 st_4
st_1 st_1
cb_print cb_print
cb_saveas cb_saveas
cb_retreive cb_retreive
st_to st_to
st_from st_from
r_1 r_1
gb_profitcenter gb_profitcenter
gb_reporttype gb_reporttype
dw_owner_matter_report dw_owner_matter_report
gb_vessel gb_vessel
gb_1 gb_1
dw_portdata dw_portdata
end type
global w_port_spend_management_stats w_port_spend_management_stats

type variables
integer ii_profitcenter[], ii_vessel_nr[]


end variables

forward prototypes
private subroutine documentation ()
public subroutine wf_export_data ()
public subroutine wf_filter (u_datagrid adw_filter)
end prototypes

event ue_retrieve();/********************************************************************
	ue_retrieve
	<DESC>	Retrieve report data	</DESC>
	<RETURN>	(None) </RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>		
   	Date       		CR-Ref       Author        Comments
   	17/04/2014 		CR3085       XSZ004        First Version
   </HISTORY>
********************************************************************/

datetime	ldt_start, ldt_end

if upperbound(ii_vessel_nr) < 1 then return

dw_from.accepttext( )
dw_to.accepttext( )
ldt_start = datetime(dw_from.getitemdate(1, "date"))
ldt_end 	 = datetime(dw_to.getitemdate(1, "date"))

dw_owner_matter_report.settransobject(sqlca)
dw_owner_matter_report.retrieve(ldt_start, ldt_end, ii_vessel_nr)
dw_owner_matter_report.object.t_period.text = string(ldt_start, "dd-mm-yyyy") + " to " + string(ldt_end, "dd-mm-yyyy")
end event

private subroutine documentation ();
/********************************************************************
   documentation
   <DESC> The main window of creating the owner matter port repaorts	</DESC>
   <RETURN>	(none) </RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date      	CR-Ref   	Author		Comments
		10/01/2014	CR3085   	LGX001		First Version
		20/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report. 
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_export_data ();/********************************************************************
   wf_export_data
   <DESC>	Export report data	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>		
		Date       		CR-Ref      Author      Comments
		17/04/2014 		CR3085      XSZ004      First Version
		20/06/2014		CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report. 
   </HISTORY>
********************************************************************/

string ls_titles[], ls_title, ls_syntax, ls_error, ls_sql, ls_column_name, ls_column_type
int    li_cnt, li_row, li_column_count, li_reporttype
mt_n_stringfunctions lnv_stringfunctions

if dw_owner_matter_report.rowcount() < 1 then return

li_reporttype = dw_reporttype.getitemnumber(1, "report_type")
if li_reporttype = 3 then
	dw_owner_matter_report.modify("DataWindow.Crosstab.StaticMode = yes")
	
	//Get the alterable column's data in cross report
	ls_title = dw_owner_matter_report.describe("datawindow.Table.Crosstabdata")
	lnv_stringfunctions.of_parsetoarray(ls_title, "~t", ls_titles)
	
	li_column_count = integer(dw_owner_matter_report.describe("datawindow.column.count"))
	ls_sql 			 = "SELECT "
	li_row 			 = li_column_count - upperbound(ls_titles) + 1
	
	//Restructure sql statement for cross report
	for li_cnt = 1 to li_column_count
		if li_cnt >= li_row then
			ls_column_name = '"' + ls_titles[upperbound(ls_titles) - (li_column_count - li_cnt)] + '", '
		else
			ls_column_name = '"' + dw_owner_matter_report.describe("#" + string(li_cnt) + ".name") + '", '
		end if
		
		if li_cnt = li_column_count then ls_column_name = left(ls_column_name, len(trim(ls_column_name)) - 1)
		
		ls_column_type = dw_owner_matter_report.describe("#" + string(li_cnt) + ".coltype")
		choose case left(ls_column_type, 3)
			case 'dat'
				ls_sql = ls_sql + "GETDATE()" + " AS " + upper(ls_column_name)
			case 'num'
				ls_sql = ls_sql + "1" + " AS " + upper(ls_column_name) 
			case 'cha'
				ls_sql = ls_sql + "''" + " AS " + upper(ls_column_name)
			case else
				//nothing to do
		end choose
	next
	
	ls_sql 	 = ls_sql + " FROM OWNER_MATTERS_DEPARTMENT "
	ls_syntax = sqlca.syntaxfromsql(ls_sql, "", ls_error)
	if ls_error <> "" then return
	
	dw_portdata.create(ls_syntax, ls_error)
	if ls_error <> "" then return
	
	dw_portdata.object.data = dw_owner_matter_report.object.data
	dw_portdata.modify("destroy column vessel_nr")
	dw_portdata.modify("destroy column pc_nr")
	dw_portdata.saveas("", Excel8!, true)
else
	dw_owner_matter_report.saveas("", Excel8!, true)
end if


end subroutine

public subroutine wf_filter (u_datagrid adw_filter);/********************************************************************
   wf_filter
   <DESC>
		Filter the data of dw_shiptypelist or dw_vessellist datawindow	
	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter	
	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       		CR-Ref       Author        Comments
   	17/04/2014 		CR3085       XSZ004        First Version
   </HISTORY>
********************************************************************/

string 	ls_filter, ls_temp_filter, ls_classname
int	 	li_nr[]
datetime ldt_start, ldt_end
mt_n_stringfunctions lnv_str_func

ldt_start 		= datetime("01/01/1900")
ldt_end 	 		= datetime("01/01/2200")
ls_temp_filter = adw_filter.inv_filter_multirow.of_getfilter()
ls_filter	   = f_get_token(ls_temp_filter, "(")
ls_filter 		= f_get_token(ls_temp_filter, ")")

adw_filter.setredraw(false)

lnv_str_func.of_parsetoarray(ls_filter, ",", li_nr)
choose case adw_filter.classname()
	case "dw_profitcenter"	//Retrieve dw_shiptypelist
		cbx_selectallshiptype.text 	= "Select all"
		cbx_selectallshiptype.checked = false
		cbx_selectallvessel.text 		= "Select all"
		cbx_selectallvessel.checked   = false
		ii_profitcenter 					= li_nr
		
		dw_vessellist.reset()	
		dw_shiptypelist.retrieve(li_nr)
	case "dw_shiptypelist"	//Retrieve dw_vessellist
		cbx_selectallvessel.text 	 = "Select all"
		cbx_selectallvessel.checked = false
		
		dw_vessellist.reset()
		dw_vessellist.retrieve(ii_profitcenter, ldt_start, ldt_end, li_nr)	
	case "dw_vessellist"		//Get vessel list
		ii_vessel_nr = li_nr
	case else
		//do nothing
end choose

adw_filter.setredraw(true)

end subroutine

on w_port_spend_management_stats.create
int iCurrent
call super::create
this.dw_reporttype=create dw_reporttype
this.dw_vessellist=create dw_vessellist
this.dw_shiptypelist=create dw_shiptypelist
this.dw_profitcenter=create dw_profitcenter
this.cbx_pc=create cbx_pc
this.dw_to=create dw_to
this.dw_from=create dw_from
this.cbx_selectallshiptype=create cbx_selectallshiptype
this.cbx_selectallvessel=create cbx_selectallvessel
this.st_4=create st_4
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_retreive=create cb_retreive
this.st_to=create st_to
this.st_from=create st_from
this.r_1=create r_1
this.gb_profitcenter=create gb_profitcenter
this.gb_reporttype=create gb_reporttype
this.dw_owner_matter_report=create dw_owner_matter_report
this.gb_vessel=create gb_vessel
this.gb_1=create gb_1
this.dw_portdata=create dw_portdata
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reporttype
this.Control[iCurrent+2]=this.dw_vessellist
this.Control[iCurrent+3]=this.dw_shiptypelist
this.Control[iCurrent+4]=this.dw_profitcenter
this.Control[iCurrent+5]=this.cbx_pc
this.Control[iCurrent+6]=this.dw_to
this.Control[iCurrent+7]=this.dw_from
this.Control[iCurrent+8]=this.cbx_selectallshiptype
this.Control[iCurrent+9]=this.cbx_selectallvessel
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_print
this.Control[iCurrent+13]=this.cb_saveas
this.Control[iCurrent+14]=this.cb_retreive
this.Control[iCurrent+15]=this.st_to
this.Control[iCurrent+16]=this.st_from
this.Control[iCurrent+17]=this.r_1
this.Control[iCurrent+18]=this.gb_profitcenter
this.Control[iCurrent+19]=this.gb_reporttype
this.Control[iCurrent+20]=this.dw_owner_matter_report
this.Control[iCurrent+21]=this.gb_vessel
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.dw_portdata
end on

on w_port_spend_management_stats.destroy
call super::destroy
destroy(this.dw_reporttype)
destroy(this.dw_vessellist)
destroy(this.dw_shiptypelist)
destroy(this.dw_profitcenter)
destroy(this.cbx_pc)
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.cbx_selectallshiptype)
destroy(this.cbx_selectallvessel)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_retreive)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.r_1)
destroy(this.gb_profitcenter)
destroy(this.gb_reporttype)
destroy(this.dw_owner_matter_report)
destroy(this.gb_vessel)
destroy(this.gb_1)
destroy(this.dw_portdata)
end on

event open;integer   li_empty[]

//set dates datawindow
dw_from.settransobject(sqlca)
dw_from.insertrow(0)
dw_from.setitem(1, "date", today())

dw_to.settransobject(sqlca)
dw_to.insertrow(0)
dw_to.setitem(1, "date", today())

if dw_profitcenter.rowcount() > 0 then dw_profitcenter.selectrow(1, true)

dw_profitcenter.inv_filter_multirow.of_dofilter()
dw_shiptypelist.inv_filter_multirow.of_dofilter()
dw_vessellist.inv_filter_multirow.of_dofilter()

wf_filter(dw_profitcenter)
end event

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
end if
end event

type dw_reporttype from mt_u_datawindow within w_port_spend_management_stats
integer x = 3712
integer y = 64
integer width = 457
integer height = 240
integer taborder = 50
string dataobject = "d_ex_ff_owner_matter_reporttype"
boolean border = false
end type

event clicked;call super::clicked;string ls_object_name

if row < 1 then return

ls_object_name = dwo.name
choose case ls_object_name
	case "t_frequency"
		this.setitem(1, "report_type", 1)
		dw_owner_matter_report.dataobject = "d_sq_tb_owner_matter_frequency"
	case "t_time"
		this.setitem(1, "report_type", 2)
		dw_owner_matter_report.dataobject = "d_sq_tb_owner_matter_time_frequency"
	case "t_department"
		this.setitem(1, "report_type", 3)	
		dw_owner_matter_report.dataobject = "d_sq_cr_owner_matter_department"
		dw_portdata.dataobject = "d_sq_gr_owner_matter_department_data"
		dw_owner_matter_report.modify("vessel_nr.width = 0")
		dw_owner_matter_report.modify("pc_nr.width = 0")
end choose
end event

event itemchanged;call super::itemchanged;int li_reporttype

choose case integer(data)
	case 1
		dw_owner_matter_report.dataobject = "d_sq_tb_owner_matter_frequency"
	case 2
		dw_owner_matter_report.dataobject = "d_sq_tb_owner_matter_time_frequency"
	case 3
		dw_owner_matter_report.dataobject = "d_sq_cr_owner_matter_department"
		dw_portdata.dataobject = "d_sq_gr_owner_matter_department_data"
		dw_owner_matter_report.modify("vessel_nr.width = 0")
		dw_owner_matter_report.modify("pc_nr.width = 0")
end choose
end event

type dw_vessellist from u_datagrid within w_port_spend_management_stats
integer x = 2011
integer y = 80
integer width = 1134
integer height = 448
integer taborder = 60
string dataobject = "d_sq_tb_vessel_given_profitcenter_shiptype"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

lstr_module.self_dw = dw_vessellist
lstr_module.self_column_name = 'vessel_nr'       // The column name is getitem column name.
lstr_module.report_column_name = 'vessel_nr'

this.inv_filter_multirow.of_register( lstr_module )
end event

event clicked;call super::clicked;wf_filter(this)
end event

event retrieveend;call super::retrieveend;int li_reporttype

li_reporttype = dw_reporttype.getitemnumber(1, "report_type")
if li_reporttype = 3 then
	cbx_selectallvessel.checked = true
	cbx_selectallvessel.event clicked()
end if
end event

type dw_shiptypelist from u_datagrid within w_port_spend_management_stats
integer x = 951
integer y = 80
integer width = 969
integer height = 448
integer taborder = 50
string dataobject = "d_sq_tb_shiptypes_profitcenter"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

lstr_module.self_dw = dw_shiptypelist
lstr_module.self_column_name = 'cal_vest_type_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'cal_vest_type_id'

this.inv_filter_multirow.of_register( lstr_module )
this.modify("DataWindow.Header.Height = 64")
end event

event clicked;call super::clicked;wf_filter(this)




end event

event retrieveend;call super::retrieveend;int li_reporttype

li_reporttype = dw_reporttype.getitemnumber(1, "report_type")
if li_reporttype = 3 then
	cbx_selectallshiptype.checked = true
	cbx_selectallshiptype.event clicked( )
end if
end event

type dw_profitcenter from u_datagrid within w_port_spend_management_stats
integer x = 73
integer y = 80
integer width = 786
integer height = 448
integer taborder = 40
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve(uo_global.is_userid)

lstr_module.self_dw = dw_profitcenter
lstr_module.self_column_name = 'pc_nr'       // The column name is getitem column name.
lstr_module.report_column_name = 'pc_nr'

this.inv_filter_multirow.of_register( lstr_module )
end event

event clicked;call super::clicked;wf_filter(this)



end event

type cbx_pc from checkbox within w_port_spend_management_stats
integer x = 530
integer y = 16
integer width = 329
integer height = 48
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

event clicked;if this.checked then
	dw_profitcenter.selectrow(0, this.checked)
	this.text = "Deselect all"
else
	dw_profitcenter.selectrow(0, this.checked)
	this.text = "Select all"
end if

dw_profitcenter.inv_filter_multirow.of_dofilter( )
wf_filter(dw_profitcenter)

this.textcolor = rgb(255, 255, 255)
end event

type dw_to from mt_u_datawindow within w_port_spend_management_stats
integer x = 3323
integer y = 160
integer width = 343
integer height = 56
integer taborder = 40
string dataobject = "d_datepicker"
boolean border = false
end type

type dw_from from mt_u_datawindow within w_port_spend_management_stats
integer x = 3323
integer y = 80
integer width = 343
integer height = 56
integer taborder = 50
string dataobject = "d_datepicker"
boolean border = false
end type

type cbx_selectallshiptype from checkbox within w_port_spend_management_stats
integer x = 1591
integer y = 20
integer width = 329
integer height = 56
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

event clicked;if this.checked then
	dw_shiptypelist.selectrow(0, this.checked)
	this.text = "Deselect all"
else
	dw_shiptypelist.selectrow(0, this.checked)
	this.text = "Select all"
end if

dw_shiptypelist.inv_filter_multirow.of_dofilter( )
post wf_filter(dw_shiptypelist)

this.textcolor = rgb(255, 255, 255)


end event

type cbx_selectallvessel from checkbox within w_port_spend_management_stats
integer x = 2816
integer y = 20
integer width = 329
integer height = 56
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

event clicked;if this.checked then
	dw_vessellist.selectrow(0, TRUE)
	this.text = "Deselect all"
else
	dw_vessellist.selectrow(0, FALSE)
	this.text = "Select all"
end if

dw_vessellist.inv_filter_multirow.of_dofilter( )
wf_filter(dw_vessellist)

this.textcolor = rgb(255, 255, 255)
end event

type st_4 from mt_u_statictext within w_port_spend_management_stats
integer x = 3200
integer y = 160
integer width = 73
integer height = 56
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_1 from mt_u_statictext within w_port_spend_management_stats
integer x = 3200
integer y = 76
integer width = 128
integer height = 56
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type cb_print from mt_u_commandbutton within w_port_spend_management_stats
integer x = 4210
integer y = 2388
integer taborder = 50
string text = "&Print"
end type

event clicked;call super::clicked;dw_owner_matter_report.print(false, true)
end event

type cb_saveas from mt_u_commandbutton within w_port_spend_management_stats
integer x = 3863
integer y = 2388
integer taborder = 40
string text = "&Save As..."
end type

event clicked;call super::clicked;wf_export_data()

end event

type cb_retreive from mt_u_commandbutton within w_port_spend_management_stats
integer x = 3515
integer y = 2388
integer taborder = 30
string text = "&Retrieve"
end type

event clicked;call super::clicked;parent.event ue_retrieve()
end event

type st_to from mt_u_statictext within w_port_spend_management_stats
integer x = 279
integer y = 216
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "To"
end type

type st_from from mt_u_statictext within w_port_spend_management_stats
integer x = 279
integer y = 104
integer width = 274
long textcolor = 16777215
long backcolor = 22628899
string text = "From"
end type

type r_1 from rectangle within w_port_spend_management_stats
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer x = -73
integer width = 4736
integer height = 592
end type

type gb_profitcenter from groupbox within w_port_spend_management_stats
integer x = 37
integer y = 16
integer width = 859
integer height = 544
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profitcenter(s)"
end type

type gb_reporttype from groupbox within w_port_spend_management_stats
integer x = 3694
integer y = 16
integer width = 494
integer height = 312
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

type dw_owner_matter_report from mt_u_datawindow within w_port_spend_management_stats
integer x = 37
integer y = 624
integer width = 4517
integer height = 1744
integer taborder = 30
string dataobject = "d_sq_tb_owner_matter_frequency"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type gb_vessel from groupbox within w_port_spend_management_stats
integer x = 1975
integer y = 16
integer width = 1207
integer height = 544
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessel(s) to include"
end type

type gb_1 from groupbox within w_port_spend_management_stats
integer x = 914
integer y = 16
integer width = 1042
integer height = 544
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Shiptype(s) to include"
end type

type dw_portdata from mt_u_datawindow within w_port_spend_management_stats
boolean visible = false
integer x = 439
integer y = 1296
integer width = 2578
integer height = 800
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_tb_owner_matter_frequency"
boolean hscrollbar = true
boolean vscrollbar = true
end type

