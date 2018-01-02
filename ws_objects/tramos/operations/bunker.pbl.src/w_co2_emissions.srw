$PBExportHeader$w_co2_emissions.srw
forward
global type w_co2_emissions from mt_w_sheet
end type
type cb_saveas from mt_u_commandbutton within w_co2_emissions
end type
type dw_co2 from mt_u_datawindow within w_co2_emissions
end type
type cb_retreive from mt_u_commandbutton within w_co2_emissions
end type
type dp_year from mt_u_datepicker within w_co2_emissions
end type
type cbx_quarter from mt_u_checkbox within w_co2_emissions
end type
type ddlb_quarter from mt_u_dropdownlistbox within w_co2_emissions
end type
type st_1 from statictext within w_co2_emissions
end type
type gb_1 from groupbox within w_co2_emissions
end type
end forward

global type w_co2_emissions from mt_w_sheet
integer width = 2519
integer height = 2340
string title = "CO² Emissions"
boolean resizable = false
cb_saveas cb_saveas
dw_co2 dw_co2
cb_retreive cb_retreive
dp_year dp_year
cbx_quarter cbx_quarter
ddlb_quarter ddlb_quarter
st_1 st_1
gb_1 gb_1
end type
global w_co2_emissions w_co2_emissions

type variables
transaction isql_trans
string is_filterstr
end variables

forward prototypes
private function integer wf_setfilter ()
public subroutine documentation ()
end prototypes

private function integer wf_setfilter ();
is_filterstr=""

if ddlb_quarter.text <> "0" then is_filterstr="quarter=" + string(ddlb_quarter.text)

dw_co2.setfilter( is_filterstr)
dw_co2.filter()
dw_co2.setsort("pc_nr A vessel_nr A quarter A")
dw_co2.sort()
dw_co2.groupcalc( )
return 1
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_co2_emissions.create
int iCurrent
call super::create
this.cb_saveas=create cb_saveas
this.dw_co2=create dw_co2
this.cb_retreive=create cb_retreive
this.dp_year=create dp_year
this.cbx_quarter=create cbx_quarter
this.ddlb_quarter=create ddlb_quarter
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saveas
this.Control[iCurrent+2]=this.dw_co2
this.Control[iCurrent+3]=this.cb_retreive
this.Control[iCurrent+4]=this.dp_year
this.Control[iCurrent+5]=this.cbx_quarter
this.Control[iCurrent+6]=this.ddlb_quarter
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_co2_emissions.destroy
call super::destroy
destroy(this.cb_saveas)
destroy(this.dw_co2)
destroy(this.cb_retreive)
destroy(this.dp_year)
destroy(this.cbx_quarter)
destroy(this.ddlb_quarter)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;isql_trans = create transaction
// Profile Tramos TEST

isql_trans.DBMS = SQLCA.dbms
isql_trans.Database = SQLCA.Database
isql_trans.LogPass = SQLCA.LogPass
isql_trans.ServerName = SQLCA.ServerName
isql_trans.LogId = SQLCA.LogId
isql_trans.AutoCommit = True
isql_trans.DBParm = SQLCA.DBParm

connect using isql_trans;
dw_co2.setTransObject(isql_trans)

dw_co2.modify("datawindow.trailer.2.height = '0'")

is_filterstr="quarter=1"
end event

event close;call super::close;disconnect using isql_trans;
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_co2_emissions
end type

type cb_saveas from mt_u_commandbutton within w_co2_emissions
integer x = 1682
integer y = 144
integer width = 352
integer height = 96
integer taborder = 30
string text = "&Save As"
end type

event clicked;call super::clicked;dw_co2.SaveAs("",XML!,True)
end event

type dw_co2 from mt_u_datawindow within w_co2_emissions
integer x = 37
integer y = 368
integer width = 2432
integer height = 1856
integer taborder = 30
string dataobject = "d_sp_tb_co2"
boolean vscrollbar = true
end type

type cb_retreive from mt_u_commandbutton within w_co2_emissions
integer x = 2066
integer y = 144
integer width = 352
integer height = 96
integer taborder = 40
string text = "&Retrieve"
end type

event clicked;call super::clicked;string ls_year, ls_userid

ls_year=right(string(year(date(dp_year.value))),2)
ls_userid=upper(uo_global.is_userid)

dw_co2.retrieve(ls_userid,ls_year)	

// wf_setfilter()

end event

type dp_year from mt_u_datepicker within w_co2_emissions
integer x = 530
integer y = 144
integer width = 256
integer height = 96
integer taborder = 20
boolean showupdown = true
datetimeformat format = dtfcustom!
string customformat = "yyyy"
datetime value = DateTime(Date("2014-08-29"), Time("16:57:49.000000"))
integer calendarfontweight = 400
end type

type cbx_quarter from mt_u_checkbox within w_co2_emissions
integer x = 951
integer y = 152
integer width = 293
integer textsize = -8
string text = "quarterly"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	ddlb_quarter.visible=true
	dw_co2.modify("datawindow.trailer.2.height = '0'")
	dw_co2.modify("datawindow.trailer.3.height = '76'")
	wf_setfilter()
else
	ddlb_quarter.visible=false
	dw_co2.modify("datawindow.trailer.2.height = '76'")
	dw_co2.modify("datawindow.trailer.3.height = '0'")
	dw_co2.setfilter("")
	dw_co2.filter()
	dw_co2.setsort("pc_nr A vessel_nr A quarter A")
	dw_co2.sort()
	dw_co2.groupcalc( )
end if

end event

type ddlb_quarter from mt_u_dropdownlistbox within w_co2_emissions
integer x = 1243
integer y = 152
integer width = 256
integer taborder = 30
string text = "0"
boolean allowedit = true
string item[] = {"0","1","2","3","4"}
end type

event selectionchanged;call super::selectionchanged;wf_setfilter()
end event

type st_1 from statictext within w_co2_emissions
integer x = 366
integer y = 160
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_co2_emissions
integer x = 37
integer y = 48
integer width = 2432
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Period"
end type

