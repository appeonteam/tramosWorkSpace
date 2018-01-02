$PBExportHeader$w_atobviac_distance_finder.srw
$PBExportComments$Advanced Distance Finder
forward
global type w_atobviac_distance_finder from w_sheet
end type
type tab_atobiviac from tab within w_atobviac_distance_finder
end type
type tp_routecontrol from userobject within tab_atobiviac
end type
type rb_abc_ports from radiobutton within tp_routecontrol
end type
type rb_tramos_ports from radiobutton within tp_routecontrol
end type
type gb_1 from groupbox within tp_routecontrol
end type
type uo_engine_controlpanel from c_engine_controlpanel within tp_routecontrol
end type
type tp_routecontrol from userobject within tab_atobiviac
rb_abc_ports rb_abc_ports
rb_tramos_ports rb_tramos_ports
gb_1 gb_1
uo_engine_controlpanel uo_engine_controlpanel
end type
type tp_map from userobject within tab_atobiviac
end type
type uo_map from u_atobviac_map within tp_map
end type
type tp_map from userobject within tab_atobiviac
uo_map uo_map
end type
type tab_atobiviac from tab within w_atobviac_distance_finder
tp_routecontrol tp_routecontrol
tp_map tp_map
end type
type st_3 from statictext within w_atobviac_distance_finder
end type
type dw_shareport from u_dw within w_atobviac_distance_finder
end type
type cb_calculate from commandbutton within w_atobviac_distance_finder
end type
type st_1 from statictext within w_atobviac_distance_finder
end type
type sle_speed from singlelineedit within w_atobviac_distance_finder
end type
type dw_port4 from u_dw within w_atobviac_distance_finder
end type
type dw_port3 from u_dw within w_atobviac_distance_finder
end type
type dw_port2 from u_dw within w_atobviac_distance_finder
end type
type dw_port1 from u_dw within w_atobviac_distance_finder
end type
type cb_clear from commandbutton within w_atobviac_distance_finder
end type
type st_background from u_topbar_background within w_atobviac_distance_finder
end type
end forward

global type w_atobviac_distance_finder from w_sheet
integer width = 4608
integer height = 2568
string title = "Advanced Distance Finder"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\passer2.ico"
boolean center = true
event ue_calculate ( )
tab_atobiviac tab_atobiviac
st_3 st_3
dw_shareport dw_shareport
cb_calculate cb_calculate
st_1 st_1
sle_speed sle_speed
dw_port4 dw_port4
dw_port3 dw_port3
dw_port2 dw_port2
dw_port1 dw_port1
cb_clear cb_clear
st_background st_background
end type
global w_atobviac_distance_finder w_atobviac_distance_finder

type variables
Long il_find_row
Long il_found_row

n_cst_dwsrv_dropdownsearch inv_dropDownSearch

end variables

forward prototypes
public subroutine of_calculatedays ()
public function string of_getportcode (string as_portcode)
public subroutine of_settable (string as_table)
public subroutine of_addcolumndays ()
public subroutine of_speedmodified ()
public function boolean of_portcodeexists (string as_portcode)
public subroutine documentation ()
public subroutine of_changedataobject ()
public subroutine of_createmap (string as_portsequence[])
end prototypes

event ue_calculate();long ll_index
string ls_portSequence[]
string ls_portcode

dw_port1.acceptText()
ls_portcode = dw_port1.getItemString(1, "portcode")
if isNull(ls_portcode) or len(ls_portcode) = 0 or Not (of_PortCodeExists(ls_PortCode)) then
	MessageBox("Error", "Please enter a valid port for Port 1")
	return
else
	ll_index += 1
	ls_portSequence[ll_index] = of_getPortCode(ls_portcode)
end if

dw_port2.acceptText()
ls_portcode = dw_port2.getItemString(1, "portcode")
if isNull(ls_portcode) or len(ls_portcode) = 0 or Not (of_PortCodeExists(ls_PortCode)) then
	dw_port2.SetItem(1,"portcode","")
else
	ll_index += 1
	ls_portSequence[ll_index] = of_getPortCode(ls_portcode)
end if

dw_port3.acceptText()
ls_portcode = dw_port3.getItemString(1, "portcode")
if isNull(ls_portcode) or len(ls_portcode) = 0 or Not (of_PortCodeExists(ls_PortCode)) then
	dw_port3.SetItem(1,"portcode","")
else
	ll_index += 1
	ls_portSequence[ll_index] = of_getPortCode(ls_portcode)
end if

dw_port4.acceptText()
ls_portcode = dw_port4.getItemString(1, "portcode")
if isNull(ls_portcode) or len(ls_portcode) = 0 or Not (of_PortCodeExists(ls_PortCode)) then
	dw_port4.SetItem(1,"portcode","")
else
	ll_index += 1
	ls_portSequence[ll_index] = of_getPortCode(ls_portcode)
end if

If ll_index > 1 then
	if not gnv_AtoBviaC.of_is_seca_enabled() then
		gnv_AtoBviaC.of_set_seca(true)
	end if
	tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.of_setportsequence(ls_portsequence)
	tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.of_refreshroute( )
	//of_calculateDays()
Else
	MessageBox("Error", "To calculate a route/distance please enter more than one port")
End if

end event

public subroutine of_calculatedays ();
end subroutine

public function string of_getportcode (string as_portcode);/* If TRAMOS ports are used, the ABC portcode has to be found */
long ll_found

if tab_atobiviac.tp_routecontrol.rb_abc_ports.checked then return as_portcode

ll_found = dw_shareport.find("port_code='"+as_portcode+"'", 1, 999999)
if ll_found > 0 then
	return dw_shareport.getItemString(ll_found, "abc_portcode")
else
	return as_portcode
end if


end function

public subroutine of_settable (string as_table);/* 	this function is to set which port table to use in distance finder
	default will be tramos table */
datawindowchild 	ldwc

if upper( as_table)  = "TRAMOS" then 
	dw_port1.dataObject="d_sq_tb_portselection_tramos"
	dw_port2.dataObject="d_sq_tb_portselection_tramos"
	dw_port3.dataObject="d_sq_tb_portselection_tramos"
	dw_port4.dataObject="d_sq_tb_portselection_tramos"
	dw_shareport.dataObject="d_dddw_tramos_port"
else
	dw_port1.dataObject="d_sq_tb_portselection_atobviac"
	dw_port2.dataObject="d_sq_tb_portselection_atobviac"
	dw_port3.dataObject="d_sq_tb_portselection_atobviac"
	dw_port4.dataObject="d_sq_tb_portselection_atobviac"
	dw_shareport.dataObject="d_dddw_atobviac_port"
end if	

dw_shareport.of_setTransObject(SQLCA)
dw_shareport.of_setUpdateable(false)
dw_shareport.of_Retrieve()

dw_port1.of_setUpdateable( false )
dw_port1.of_SetDropDownSearch( false )
dw_port1.of_SetDropDownSearch( true )
dw_port1.inv_dropdownsearch.of_Register()

dw_port2.of_setUpdateable( false )
dw_port2.of_SetDropDownSearch( false )
dw_port2.of_SetDropDownSearch( true )
dw_port2.inv_dropdownsearch.of_Register()

dw_port3.of_setUpdateable( false )
dw_port3.of_SetDropDownSearch( false )
dw_port3.of_SetDropDownSearch( true )
dw_port3.inv_dropdownsearch.of_Register()

dw_port4.of_setUpdateable( false )
dw_port4.of_SetDropDownSearch( false )
dw_port4.of_SetDropDownSearch( true )
dw_port4.inv_dropdownsearch.of_Register()

dw_port1.getchild( "portcode", ldwc)
dw_shareport.sharedata(ldwc)
dw_port1.InsertRow(0)

dw_port2.getchild( "portcode", ldwc)
dw_shareport.sharedata(ldwc)
dw_port2.InsertRow(0)

dw_port3.getchild( "portcode", ldwc)
dw_shareport.sharedata(ldwc)
dw_port3.InsertRow(0)

dw_port4.getchild( "portcode", ldwc)
dw_shareport.sharedata(ldwc)
dw_port4.InsertRow(0)

dw_port1.post setFocus()

end subroutine

public subroutine of_addcolumndays ();tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify("portcode_t.Width='1033'")
tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify("portname.Width='750'")

tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify( "create text(band=Header"  +  &
" name=calcdaysheader alignment='2' border='0' background.color='22628899' color='16777215'"  +  &
" font.face='Tahoma' font.height='-8' font.weight='700' x='1351' y='8' height='56' width='151' text='"+sle_speed.text+"' ")

tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify( &
"create compute(band=Detail"  +  &
" alignment='1' color='0'" + &
" x='1321' y='4' height='56' width='151' format='#,##0.00'" +&
" name=calcdays expression='cumulativeSum(  distance  for all )/"+sle_speed.text+"/24' " +&
" font.face='Arial' font.height='-8' font.weight='400' background.color='536870912'")



end subroutine

public subroutine of_speedmodified ();long ll_row, ll_rows
integer li_eca
decimal{2} ld_calcecadays, ld_sumecadays

tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify( "calcdays.expression='round(distance /" + sle_speed.text + "/24, 2)' " + &
													  " calcecadays.expression='round(eca_distance /" + sle_speed.text + "/24, 2)' ")
tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.Modify( " sum_days.expression='sum(  round(calcdays, 2)  for all )' " + &
													  " sum_ecadays.expression='sum(  round(calcecadays, 2)  for all )' ")
end subroutine

public function boolean of_portcodeexists (string as_portcode);// This function check is the port exists in Tramos port codes

If dw_SharePort.DataObject = "d_dddw_tramos_port" then 
	Return dw_SharePort.Find("port_code='"+as_portcode+"'", 1, 999999) > 0
Else
	Return dw_SharePort.Find("portcode='"+as_portcode+"'", 1, 999999) > 0
End If
end function

public subroutine documentation ();/********************************************************************
   w_atobviac_distance_finder
	
	<OBJECT>

	</OBJECT>
   <DESC>
		window outside charterering module that can be usewd to get distances
	</DESC>
  	<USAGE>
	
	</USAGE>
   <ALSO>
		object must be moved to MT	framework and lose PFC dependencies.  Assigned job for
		CR3361
	</ALSO>
		Date    		Ref   	Author		Comments
		01/06/05		?     	???   		First Version
		01/01/13		CR3316	AGL027		atobviac 2013 implementation
		17/12/13		CR3475	AGL027		fix state of engine
		28/08/14		CR3781	CCY018		The window title match with the text of a menu item
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
		01/12/15		CR3248	CCY018		Add ECA Areas in Route.
		31/03/16		CR3787	CCY018		Add atobviac map.
		22/02/16		CR3767	XSZ004		When a user opens Simple or Advanced Distance Finder or creates a new calculation or clicks Reset 
	        		      	      			Routing Points button, the default settings should be taken from the user's Primary Profit Center.
		14/06/16		CR4411	CCY018		Change the tab title backcolor
********************************************************************/
end subroutine

public subroutine of_changedataobject ();/********************************************************************
   of_changedataobject
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/12/15		CR3248		CCY018		First Version
   </HISTORY>
********************************************************************/

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route.dataobject = "d_ex_tb_route_advanced"
lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_route, false)
end subroutine

public subroutine of_createmap (string as_portsequence[]);/********************************************************************
   of_createmap
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_portsequence[]
   </ARGS>
   <USAGE>	called by c_engine_controlpanel</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

tab_atobiviac.tp_map.uo_map.of_setportsequence(as_portsequence )
tab_atobiviac.tp_map.uo_map.of_createmap()
end subroutine

event open;this.move(0,0)

this.setredraw(false)
of_settable( "TRAMOS" )
sle_speed.text = string(uo_global.gd_finder_speed)
of_changedataobject()
/* Register calculate button in engine */
tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.of_RegisterDistanceFinder( this )
/* atobviac 2013 - fix to correct state */
tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.dw_primary_rp.post event ue_itemchanged()

this.setredraw(true)

end event

on w_atobviac_distance_finder.create
int iCurrent
call super::create
this.tab_atobiviac=create tab_atobiviac
this.st_3=create st_3
this.dw_shareport=create dw_shareport
this.cb_calculate=create cb_calculate
this.st_1=create st_1
this.sle_speed=create sle_speed
this.dw_port4=create dw_port4
this.dw_port3=create dw_port3
this.dw_port2=create dw_port2
this.dw_port1=create dw_port1
this.cb_clear=create cb_clear
this.st_background=create st_background
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_atobiviac
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.dw_shareport
this.Control[iCurrent+4]=this.cb_calculate
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_speed
this.Control[iCurrent+7]=this.dw_port4
this.Control[iCurrent+8]=this.dw_port3
this.Control[iCurrent+9]=this.dw_port2
this.Control[iCurrent+10]=this.dw_port1
this.Control[iCurrent+11]=this.cb_clear
this.Control[iCurrent+12]=this.st_background
end on

on w_atobviac_distance_finder.destroy
call super::destroy
destroy(this.tab_atobiviac)
destroy(this.st_3)
destroy(this.dw_shareport)
destroy(this.cb_calculate)
destroy(this.st_1)
destroy(this.sle_speed)
destroy(this.dw_port4)
destroy(this.dw_port3)
destroy(this.dw_port2)
destroy(this.dw_port1)
destroy(this.cb_clear)
destroy(this.st_background)
end on

event activate;call super::activate;
end event

type tab_atobiviac from tab within w_atobviac_distance_finder
event create ( )
event destroy ( )
integer x = 18
integer y = 240
integer width = 4576
integer height = 2248
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_routecontrol tp_routecontrol
tp_map tp_map
end type

on tab_atobiviac.create
this.tp_routecontrol=create tp_routecontrol
this.tp_map=create tp_map
this.Control[]={this.tp_routecontrol,&
this.tp_map}
end on

on tab_atobiviac.destroy
destroy(this.tp_routecontrol)
destroy(this.tp_map)
end on

type tp_routecontrol from userobject within tab_atobiviac
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4539
integer height = 2128
long backcolor = 32304364
string text = "Route Control"
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
rb_abc_ports rb_abc_ports
rb_tramos_ports rb_tramos_ports
gb_1 gb_1
uo_engine_controlpanel uo_engine_controlpanel
end type

on tp_routecontrol.create
this.rb_abc_ports=create rb_abc_ports
this.rb_tramos_ports=create rb_tramos_ports
this.gb_1=create gb_1
this.uo_engine_controlpanel=create uo_engine_controlpanel
this.Control[]={this.rb_abc_ports,&
this.rb_tramos_ports,&
this.gb_1,&
this.uo_engine_controlpanel}
end on

on tp_routecontrol.destroy
destroy(this.rb_abc_ports)
destroy(this.rb_tramos_ports)
destroy(this.gb_1)
destroy(this.uo_engine_controlpanel)
end on

type rb_abc_ports from radiobutton within tp_routecontrol
integer x = 736
integer y = 2060
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "AtoBviaC Ports"
end type

event clicked;of_setTable( "AtoBviaC" )
end event

type rb_tramos_ports from radiobutton within tp_routecontrol
integer x = 736
integer y = 2000
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "TRAMOS Ports"
boolean checked = true
end type

event clicked;of_setTable( "TRAMOS" )
end event

type gb_1 from groupbox within tp_routecontrol
integer x = 672
integer y = 1952
integer width = 704
integer height = 180
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Port Table..."
end type

type uo_engine_controlpanel from c_engine_controlpanel within tp_routecontrol
event destroy ( )
integer width = 4539
integer height = 2148
integer taborder = 10
end type

on uo_engine_controlpanel.destroy
call c_engine_controlpanel::destroy
end on

event constructor;call super::constructor;
this.of_resetengine( )
end event

type tp_map from userobject within tab_atobiviac
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4539
integer height = 2128
long backcolor = 32304364
string text = "Map"
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
uo_map uo_map
end type

on tp_map.create
this.uo_map=create uo_map
this.Control[]={this.uo_map}
end on

on tp_map.destroy
destroy(this.uo_map)
end on

type uo_map from u_atobviac_map within tp_map
event destroy ( )
integer x = 37
integer y = 32
integer taborder = 110
end type

on uo_map.destroy
call u_atobviac_map::destroy
end on

type st_3 from statictext within w_atobviac_distance_finder
integer x = 82
integer y = 36
integer width = 457
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "From / To Ports..."
boolean focusrectangle = false
end type

type dw_shareport from u_dw within w_atobviac_distance_finder
boolean visible = false
integer x = 1792
integer y = 600
integer width = 923
integer height = 468
integer taborder = 90
string dataobject = "d_dddw_tramos_port"
end type

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

type cb_calculate from commandbutton within w_atobviac_distance_finder
integer x = 4119
integer y = 84
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Calculate"
boolean default = true
end type

event clicked;parent.event ue_calculate()
of_speedmodified()
end event

type st_1 from statictext within w_atobviac_distance_finder
integer x = 3529
integer y = 40
integer width = 197
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Speed"
boolean focusrectangle = false
end type

type sle_speed from singlelineedit within w_atobviac_distance_finder
integer x = 3529
integer y = 96
integer width = 206
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "14.5"
borderstyle borderstyle = stylelowered!
end type

event modified;of_speedmodified( )
of_calculateDays()
end event

type dw_port4 from u_dw within w_atobviac_distance_finder
integer x = 2647
integer y = 96
integer width = 841
integer height = 88
integer taborder = 40
string dataobject = "d_sq_tb_portselection_tramos"
boolean vscrollbar = false
end type

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

type dw_port3 from u_dw within w_atobviac_distance_finder
integer x = 1792
integer y = 96
integer width = 841
integer height = 88
integer taborder = 30
string dataobject = "d_sq_tb_portselection_tramos"
boolean vscrollbar = false
end type

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

type dw_port2 from u_dw within w_atobviac_distance_finder
integer x = 937
integer y = 96
integer width = 841
integer height = 88
integer taborder = 20
string dataobject = "d_sq_tb_portselection_tramos"
boolean vscrollbar = false
end type

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

type dw_port1 from u_dw within w_atobviac_distance_finder
integer x = 82
integer y = 96
integer width = 841
integer height = 84
integer taborder = 10
string dataobject = "d_sq_tb_portselection_tramos"
boolean vscrollbar = false
end type

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

type cb_clear from commandbutton within w_atobviac_distance_finder
integer x = 3771
integer y = 84
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&lear All..."
end type

event clicked;string ls_null

setNull(ls_null)
dw_port1.setItem(1, "portcode", ls_null)
dw_port2.setItem(1, "portcode", ls_null)
dw_port3.setItem(1, "portcode", ls_null)
dw_port4.setItem(1, "portcode", ls_null)
tab_atobiviac.tp_routecontrol.uo_engine_controlpanel.of_clearroute( )
tab_atobiviac.tp_map.uo_map.of_clearmap( )

dw_port1.POST setFocus()

end event

type st_background from u_topbar_background within w_atobviac_distance_finder
end type

