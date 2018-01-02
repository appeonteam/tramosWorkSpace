$PBExportHeader$w_atobviac_distance_finder_simple.srw
$PBExportComments$Simple Distance Finder
forward
global type w_atobviac_distance_finder_simple from w_sheet
end type
type dw_shareport from u_dw within w_atobviac_distance_finder_simple
end type
type tab_distance_finder from tab within w_atobviac_distance_finder_simple
end type
type tp_ports from userobject within tab_distance_finder
end type
type cb_oldbp_distance from commandbutton within tp_ports
end type
type st_route from statictext within tp_ports
end type
type dw_fromtoports from u_dw within tp_ports
end type
type gb_1 from groupbox within tp_ports
end type
type gb_2 from groupbox within tp_ports
end type
type tp_ports from userobject within tab_distance_finder
cb_oldbp_distance cb_oldbp_distance
st_route st_route
dw_fromtoports dw_fromtoports
gb_1 gb_1
gb_2 gb_2
end type
type tp_routecontrol from userobject within tab_distance_finder
end type
type uo_engine_controlpanel from c_engine_controlpanel within tp_routecontrol
end type
type tp_routecontrol from userobject within tab_distance_finder
uo_engine_controlpanel uo_engine_controlpanel
end type
type tp_map from userobject within tab_distance_finder
end type
type uo_map from u_atobviac_map within tp_map
end type
type tp_map from userobject within tab_distance_finder
uo_map uo_map
end type
type tab_distance_finder from tab within w_atobviac_distance_finder_simple
tp_ports tp_ports
tp_routecontrol tp_routecontrol
tp_map tp_map
end type
end forward

global type w_atobviac_distance_finder_simple from w_sheet
integer width = 4608
integer height = 2456
string title = "Simple Distance Finder"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\passer.ico"
boolean center = true
event ue_calculate ( )
dw_shareport dw_shareport
tab_distance_finder tab_distance_finder
end type
global w_atobviac_distance_finder_simple w_atobviac_distance_finder_simple

type variables
Long il_find_row
Long il_found_row

n_cst_dwsrv_dropdownsearch inv_dropDownSearch

end variables

forward prototypes
public function string of_getportcode (string as_portcode)
public function boolean of_portexists (string as_portcode)
public subroutine documentation ()
public subroutine of_createmap (string as_portsequence[])
public subroutine wf_calculate (integer ai_pageindex)
end prototypes

event ue_calculate();wf_calculate(0)
end event

public function string of_getportcode (string as_portcode);/* If TRAMOS ports are used, the ABC portcode has to be found */
long ll_found

ll_found = dw_shareport.find("port_code='"+as_portcode+"'", 1, 999999)
if ll_found > 0 then
	return dw_shareport.getItemString(ll_found, "abc_portcode")
else
	return as_portcode
end if


end function

public function boolean of_portexists (string as_portcode);
Return dw_SharePort.Find("port_code='" + as_PortCode + "'", 1, 999999) > 0

end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
		12/09/14		CR3773		XSZ004		Change icon absolute path to reference path
		01/12/15		CR3248		CCY018		Add ECA Areas in Route.
		17/03/16		CR2362		LHG008		Remove hard-coded days in Canal
		22/02/16		CR3767		XSZ004		When a user opens Simple or Advanced Distance Finder or creates a new calculation or clicks Reset 
	        		      	      				Routing Points button, the default settings should be taken from the user's Primary Profit Center.
		03/05/16		CR3787		CCY018		Add atobviac map.
		24/05/15		CR3767		XSZ004		Fix a bug.
   </HISTORY>
********************************************************************/
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
   	02/05/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

tab_distance_finder.tp_map.uo_map.of_setportsequence(as_portsequence )
tab_distance_finder.tp_map.uo_map.of_createmap()
end subroutine

public subroutine wf_calculate (integer ai_pageindex);/********************************************************************
   of_defaulrpfrompc
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		24/05/16		CR3767UAT1	XSZ004		Fix a bug.
   </HISTORY>
********************************************************************/

long ll_index, ll_currentrow, ll_row, ll_rows, ll_found, ll_rowcount, ll_portrow, ll_startrow
string ls_portSequence[]
string ls_portcode, ls_route
constant int LI_PORTS_PAGE = 1, LI_MAP_PAGE = 3

tab_distance_finder.tp_ports.dw_fromtoports.acceptText()

if ai_pageindex = LI_PORTS_PAGE then
	ll_rowcount = tab_distance_finder.tp_ports.dw_fromtoports.rowcount()
	ll_startrow = 1
else
	ll_currentrow = tab_distance_finder.tp_ports.dw_fromtoports.getRow()
	if ll_currentRow < 1 then return
	
	ll_startrow = ll_currentrow
	ll_rowcount = ll_currentrow
end if

for ll_portrow =  ll_startrow to ll_rowcount
	
	ls_route      = ""
	ll_index      = 0
	ll_currentrow = ll_portrow
	
	ls_portcode = tab_distance_finder.tp_ports.dw_fromtoports.getItemString(ll_currentrow, "fromport")
	if isNull(ls_portcode) or len(ls_portcode) = 0 or (Not of_PortExists(ls_portcode)) then
		tab_distance_finder.tp_ports.dw_fromtoports.SetItem(ll_currentrow, "fromport", "")
		Return
	else
		ll_index += 1
		ls_portSequence[ll_index] = of_getPortcode(ls_portcode)
	end if
	
	ls_portcode = tab_distance_finder.tp_ports.dw_fromtoports.getItemString(ll_currentrow, "toport")
	if isNull(ls_portcode) or len(ls_portcode) = 0 or (Not of_PortExists(ls_portcode)) then
		tab_distance_finder.tp_ports.dw_fromtoports.SetItem(ll_currentrow, "toport", "")
		Return
	else
		ll_index += 1
		ls_portSequence[ll_index] = of_getPortcode(ls_portcode)
	end if
	
	if ll_index <  2 then
	//	MessageBox("Error", "To calculate a route/distance please enter more than one port")
		return
	end if
	
	if not gnv_AtoBviaC.of_is_seca_enabled() then
		gnv_AtoBviaC.of_set_seca(true)
	end if
	tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.of_setportsequence(ls_portsequence)
	tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.of_refreshroute( )
	tab_distance_finder.tp_ports.dw_fromtoports.setItem(ll_currentrow, "distance", tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.dw_route.getItemNumber(1, "sum_distance"))
	
	tab_distance_finder.tp_ports.dw_fromtoports.setItem(ll_currentrow, "canaldays", 0)			
	ll_rows = tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.dw_route.rowCount()
	for ll_row = 1 to ll_rows
		/* Build route */
		if len(ls_route) > 1 then
			ls_route += " → "+tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.dw_route.getItemString(ll_row, "portname")
		else
			ls_route += tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.dw_route.getItemString(ll_row, "portname")
		end if
	next
	
	tab_distance_finder.tp_ports.dw_fromtoports.setItem(ll_currentrow, "route", ls_route)
	
	if ll_currentrow =  tab_distance_finder.tp_ports.dw_fromtoports.getRow() then
		tab_distance_finder.tp_ports.st_route.text = ls_route
	elseif ll_currentrow = 1 then
		tab_distance_finder.tp_ports.st_route.text = ls_route
	end if
	
	tab_distance_finder.tp_ports.dw_fromtoports.setItem(ll_currentrow, "enginestate",tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.of_getenginestate( ))
next	

if ai_pageindex = LI_MAP_PAGE then
	of_createmap(ls_portSequence)
end if
end subroutine

event open;datawindowchild 	ldwc
long ll_row

this.move(0,0)
this.setredraw(false)

dw_shareport.of_setTransObject(SQLCA)
dw_shareport.of_setUpdateable(false)
dw_shareport.of_Retrieve()

tab_distance_finder.tp_ports.dw_fromtoports.of_setUpdateable( false )
tab_distance_finder.tp_ports.dw_fromtoports.of_SetDropDownSearch( true )
tab_distance_finder.tp_ports.dw_fromtoports.inv_dropdownsearch.of_Register()

tab_distance_finder.tp_ports.dw_fromtoports.getchild( "fromport", ldwc)
dw_shareport.sharedata(ldwc)

tab_distance_finder.tp_ports.dw_fromtoports.getchild( "toport", ldwc)
dw_shareport.sharedata(ldwc)

tab_distance_finder.tp_ports.dw_fromtoports.post setRow( 1 )
tab_distance_finder.tp_ports.dw_fromtoports.post setFocus()

for ll_row = 1 to 15
	tab_distance_finder.tp_ports.dw_fromtoports.insertRow(1)
	tab_distance_finder.tp_ports.dw_fromtoports.setItem(1, "canaldays", 0)
next

this.setredraw(true)

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(tab_distance_finder.tp_ports.dw_fromtoports,false)

tab_distance_finder.tp_routecontrol.uo_engine_controlpanel.of_registerdistancesimple(this)
tab_distance_finder.tp_map.uo_map.of_setheight( )

end event

on w_atobviac_distance_finder_simple.create
int iCurrent
call super::create
this.dw_shareport=create dw_shareport
this.tab_distance_finder=create tab_distance_finder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_shareport
this.Control[iCurrent+2]=this.tab_distance_finder
end on

on w_atobviac_distance_finder_simple.destroy
call super::destroy
destroy(this.dw_shareport)
destroy(this.tab_distance_finder)
end on

event activate;call super::activate;
end event

type dw_shareport from u_dw within w_atobviac_distance_finder_simple
boolean visible = false
integer x = 2487
integer y = 20
integer width = 923
integer height = 152
integer taborder = 50
string dataobject = "d_dddw_tramos_port"
end type

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

type tab_distance_finder from tab within w_atobviac_distance_finder_simple
event create ( )
event destroy ( )
integer width = 4581
integer height = 2348
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_ports tp_ports
tp_routecontrol tp_routecontrol
tp_map tp_map
end type

on tab_distance_finder.create
this.tp_ports=create tp_ports
this.tp_routecontrol=create tp_routecontrol
this.tp_map=create tp_map
this.Control[]={this.tp_ports,&
this.tp_routecontrol,&
this.tp_map}
end on

on tab_distance_finder.destroy
destroy(this.tp_ports)
destroy(this.tp_routecontrol)
destroy(this.tp_map)
end on

event selectionchanged;wf_calculate(newindex)

end event

type tp_ports from userobject within tab_distance_finder
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4544
integer height = 2232
long backcolor = 32304364
string text = "Ports"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_oldbp_distance cb_oldbp_distance
st_route st_route
dw_fromtoports dw_fromtoports
gb_1 gb_1
gb_2 gb_2
end type

on tp_ports.create
this.cb_oldbp_distance=create cb_oldbp_distance
this.st_route=create st_route
this.dw_fromtoports=create dw_fromtoports
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_oldbp_distance,&
this.st_route,&
this.dw_fromtoports,&
this.gb_1,&
this.gb_2}
end on

on tp_ports.destroy
destroy(this.cb_oldbp_distance)
destroy(this.st_route)
destroy(this.dw_fromtoports)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type cb_oldbp_distance from commandbutton within tp_ports
boolean visible = false
integer x = 3566
integer y = 324
integer width = 581
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Old BP Distance finder..."
end type

event clicked;open(w_oldbp_distance_finder)
end event

type st_route from statictext within tp_ports
integer x = 37
integer y = 1672
integer width = 2880
integer height = 500
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_fromtoports from u_dw within tp_ports
integer x = 46
integer y = 108
integer width = 2862
integer height = 1412
integer taborder = 50
string dataobject = "d_calc_distance_finder"
end type

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event itemchanged;call super::itemchanged;window lw

if isnull(this.getItemNumber(row, "speed")) and row > 1 then
	this.setItem(row, "speed", this.getItemNumber(row -1, "speed"))
elseif isnull(this.getItemNumber(row, "speed")) then
	this.setItem(row, "speed", uo_global.gd_finder_speed )
end if
	
lw = getactivesheet( )
lw.postevent("ue_calculate")
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_firstport

if currentrow < 1 then return

st_route.text = this.getItemString(currentRow, "route")

end event

type gb_1 from groupbox within tp_ports
integer y = 16
integer width = 2953
integer height = 1560
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "From / To Ports..."
end type

type gb_2 from groupbox within tp_ports
integer y = 1608
integer width = 2953
integer height = 596
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Route"
end type

type tp_routecontrol from userobject within tab_distance_finder
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4544
integer height = 2232
long backcolor = 67108864
string text = "Route Control"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_engine_controlpanel uo_engine_controlpanel
end type

on tp_routecontrol.create
this.uo_engine_controlpanel=create uo_engine_controlpanel
this.Control[]={this.uo_engine_controlpanel}
end on

on tp_routecontrol.destroy
destroy(this.uo_engine_controlpanel)
end on

type uo_engine_controlpanel from c_engine_controlpanel within tp_routecontrol
event destroy ( )
integer width = 4544
integer height = 2228
integer taborder = 70
end type

on uo_engine_controlpanel.destroy
call c_engine_controlpanel::destroy
end on

event constructor;call super::constructor;
this.of_resetengine( )
end event

type tp_map from userobject within tab_distance_finder
integer x = 18
integer y = 100
integer width = 4544
integer height = 2232
long backcolor = 32304364
string text = "Map"
long tabtextcolor = 33554432
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
integer x = 37
integer y = 32
integer height = 2192
integer taborder = 60
end type

on uo_map.destroy
call u_atobviac_map::destroy
end on

