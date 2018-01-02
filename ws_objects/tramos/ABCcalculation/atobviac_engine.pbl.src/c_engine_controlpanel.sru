$PBExportHeader$c_engine_controlpanel.sru
$PBExportComments$Visual encapsulation of the AtoBviaC engine - get port sequence and returns a route
forward
global type c_engine_controlpanel from mt_u_visualobject
end type
type cb_print from mt_u_commandbutton within c_engine_controlpanel
end type
type cb_saveas from mt_u_commandbutton within c_engine_controlpanel
end type
type cb_reset from commandbutton within c_engine_controlpanel
end type
type dw_route from mt_u_datawindow within c_engine_controlpanel
end type
type mle_route_information from multilineedit within c_engine_controlpanel
end type
type dw_constraints from mt_u_datawindow within c_engine_controlpanel
end type
type dw_advanced_rp from mt_u_datawindow within c_engine_controlpanel
end type
type dw_primary_rp from mt_u_datawindow within c_engine_controlpanel
end type
type gb_1 from groupbox within c_engine_controlpanel
end type
type gb_2 from groupbox within c_engine_controlpanel
end type
type gb_3 from groupbox within c_engine_controlpanel
end type
type gb_4 from groupbox within c_engine_controlpanel
end type
type gb_5 from groupbox within c_engine_controlpanel
end type
end forward

global type c_engine_controlpanel from mt_u_visualobject
integer width = 4599
integer height = 2488
long backcolor = 32304364
long tabbackcolor = 32304364
event ue_getenginestate ( )
cb_print cb_print
cb_saveas cb_saveas
cb_reset cb_reset
dw_route dw_route
mle_route_information mle_route_information
dw_constraints dw_constraints
dw_advanced_rp dw_advanced_rp
dw_primary_rp dw_primary_rp
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global c_engine_controlpanel c_engine_controlpanel

type variables
string is_portSequence[]
string is_EngineState, is_defaultenginestate=""
long	il_primaryrprow
w_sheet iw_distance_finder
u_atobviac_calc_itinerary iuo_itinerary
w_atobviac_distance_finder_simple iw_distance_finder_simple
end variables

forward prototypes
public function integer of_refreshroute ()
public function integer of_setportsequence (string as_portsequence[])
public function integer of_clearroute ()
public function integer of_registerdistancefinder (w_sheet aw_sheet)
public function integer of_registeritinerary (u_atobviac_calc_itinerary auo_itinerary)
public subroutine of_resetengine ()
public function blob of_getengineroute ()
public function string of_getenginestate ()
public function integer of_setenginestate (string as_enginestate)
public function string of_getdefaultenginestate ()
public function integer of_setdefaultenginestate (string as_enginestate)
public subroutine of_resetdefaultengine ()
public subroutine documentation ()
public subroutine of_modifyheadertextcolor (long al_color)
public function long of_getprofitcenter ()
public subroutine of_registerdistancesimple (w_atobviac_distance_finder_simple aw_window)
end prototypes

event ue_getenginestate();is_engineState = gnv_AtoBviaC.of_getEngineState()
end event

public function integer of_refreshroute ();/* No port sequence present, just return */
if upperBound( is_portSequence) < 1 then return 1

dw_route.setRedraw(false)
dw_route.reset()

if upperBound( is_portSequence) = 1 then
	/* eks. same load and discharge port (position voyage) */
	dw_route.insertRow(0)
	dw_route.setItem(1, "distance", 0)
	dw_route.setItem(1, "portcode", is_portsequence[1])
	//dw_route.setItem(1, "portname", ????????????????
	dw_route.setRedraw( true )
	return 1
end if

/* All states must be set before retrieving new route in case that several calculations or distance finders are active on the same machine */
gnv_AtoBviaC.of_setEngineState( is_engineState )
gnv_AtoBviaC.of_getRoute(is_portsequence , dw_route )
mle_route_information.text = gnv_AtoBviaC.of_GetRouteInformation( )
dw_route.selectrow(0, false) //CR3248 no row should be preselected/highlighted in the route
post event ue_getEngineState( )
/* recalculates days if button is registred */
if isValid( iw_distance_finder ) then 
	iw_distance_finder .DYNAMIC of_calculateDays()
	iw_distance_finder .DYNAMIC of_createmap(is_portSequence)
end if

if isValid( iuo_itinerary ) then 
	iuo_itinerary.triggerevent( "ue_childmodified" )
	iuo_itinerary.DYNAMIC of_createmap(is_portSequence)
end if

dw_route.setRedraw(true)

return 1
end function

public function integer of_setportsequence (string as_portsequence[]);is_portSequence = as_portSequence

return 1
end function

public function integer of_clearroute ();return dw_route.reset()
end function

public function integer of_registerdistancefinder (w_sheet aw_sheet);/* 	This function register the window for calculating days in distance finder.
	This is a way to implement cross object references backwards */

iw_distance_finder = aw_sheet
return 1
end function

public function integer of_registeritinerary (u_atobviac_calc_itinerary auo_itinerary);/* 	This function register the itinerary user object.
	This is a way to implement cross object references backwards */

iuo_itinerary = auo_itinerary
return 1
end function

public subroutine of_resetengine ();gnv_AtoBviaC.of_defaulrpfrompc(dw_primary_rp, dw_advanced_rp, of_getprofitcenter())
gnv_atobviac.POST of_resettodefaultstate(of_getprofitcenter())
gnv_AtoBviaC.POST of_getprimaryrpstateall(dw_primary_rp, false)
gnv_AtoBviaC.of_initadvancedrpindexes( dw_advanced_rp, "" ) 	/* atobviac 2013 */
gnv_AtoBviaC.POST of_getadvancedrpstateall(dw_primary_rp, dw_advanced_rp, false ) /* atobviac 2013 */
gnv_AtoBviaC.POST of_getprimaryconstraints( dw_constraints, dw_advanced_rp ) /* atobviac 2013 */
POST event ue_getenginestate( )
if isValid( iuo_itinerary ) then 
	iuo_itinerary.POST uf_clear_cache()
end if
POST of_refreshroute( )
return
end subroutine

public function blob of_getengineroute ();/* This function returns the route so that it can be used in tghe calculation to generate Itinerary route */

blob lbl_data
dw_route.getFullstate( lbl_data )
return lbl_data
end function

public function string of_getenginestate ();//return is_enginestate
return gnv_AtoBviaC.of_getEngineState()
end function

public function integer of_setenginestate (string as_enginestate);if isNull(as_engineState) or as_enginestate = "" then return 1

gnv_AtoBviaC.of_setenginestate( as_enginestate )

gnv_AtoBviaC.of_defaulrpfrompc(dw_primary_rp, dw_advanced_rp, of_getprofitcenter())

gnv_AtoBviaC.of_getprimaryrpstateall(dw_primary_rp, of_getdefaultenginestate( )<>"")
gnv_AtoBviaC.of_getadvancedrpstateall(dw_primary_rp, dw_advanced_rp, of_getdefaultenginestate( )<>"" ) /* atobviac 2013 */
gnv_AtoBviaC.of_getprimaryconstraints( dw_constraints, dw_advanced_rp ) /* atobviac 2013 */
return 1
end function

public function string of_getdefaultenginestate ();return is_defaultenginestate
end function

public function integer of_setdefaultenginestate (string as_enginestate);/* called only when there is a saved route string */
is_defaultenginestate = as_enginestate
gnv_atobviac.of_initadvancedrpindexes( dw_advanced_rp, as_enginestate ) 	/* atobviac 2013 */

return c#return.Success

end function

public subroutine of_resetdefaultengine ();if is_defaultenginestate <> "" then	/* from a saved calculation */
	gnv_AtoBviaC.POST of_setenginestate(is_defaultenginestate)
else /* distance finder */
	gnv_atobviac.POST of_resettodefaultstate(of_getprofitcenter())
end if

gnv_AtoBviaC.POST of_getprimaryrpstateall(dw_primary_rp, of_getdefaultenginestate( )<>"")
gnv_AtoBviaC.POST of_getadvancedrpstateall(dw_primary_rp, dw_advanced_rp, of_getdefaultenginestate( )<>"" ) /* atobviac 2013 */
gnv_AtoBviaC.POST of_getprimaryconstraints( dw_constraints, dw_advanced_rp ) /* atobviac 2013 */
POST event ue_getenginestate( )
if isValid( iuo_itinerary ) then 
	iuo_itinerary.POST uf_clear_cache()
end if
POST of_refreshroute( )
return
end subroutine

public subroutine documentation ();/********************************************************************
   visualobject name: c_engine_controlpanel 
	
	<OBJECT>
		Visual Object of atobviac distance finder.
	</OBJECT>
   <DESC>
		Visual representation of the controlled routing a user may apply to modify
		distances between ports in a route.  
	</DESC>
   <USAGE>
		Used in technically 2 places
			* inside calc itinerary tab
			* Advanced Distance Finder
		The advanced Distance Finder can be opened from Calc/Operations menubar items
	</USAGE>
   <ALSO>
		Requires AtoBviaC distance engine 2013
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	25/09/13		CR3316	AGL027			Integrate new atobviac engine
	22/10/13		CR3316	AGL027			Resolve issues found inside UAT delivery one for initial release 27.04.2
	27/11/13		CR3316	AGL027			Resolve issues found inside UAT delivery two for release 27.04.2
	16/01/15		CR3747	AGL027			Re-apply ASL routing in Advanced RP's
	26/11/15		CR3248	CCY018			Add ECA Areas in Route.
	22/02/16		CR3767	XSZ004			When a user opens Simple or Advanced Distance Finder or creates a new calculation or clicks Reset 
	        		      	      			Routing Points button, the default settings should be taken from the user's Primary Profit Center.
	31/03/16		CR3787	CCY018			Add aotbviac map.
********************************************************************/
end subroutine

public subroutine of_modifyheadertextcolor (long al_color);/********************************************************************
   of_modifyheadertextcolor
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS></ACCESS>
   <ARGS>
		al_color
   </ARGS>
   <USAGE>	called by cb_print.clicked</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13/01/16		CR3248		CCY018		Modify header text color.
   </HISTORY>
********************************************************************/

long ll_loop
string ls_type, ls_band, ls_modstring, ls_ObjectNames[]
mt_n_stringfunctions 	lnv_str


lnv_str.of_parsetoarray(string(dw_route.Describe("DataWindow.Objects")), Chara(9), ls_ObjectNames)
for ll_loop=1 to Upperbound(ls_ObjectNames)   
	ls_type = dw_route.Describe(ls_objectnames[ll_loop]+".type")
	ls_band = lower(dw_route.Describe(ls_objectnames[ll_loop]+".band"))	
	
	if lower(ls_type) = "text" and  lower(ls_band) = "header" then 
		ls_modstring = ls_objectnames[ll_loop] + ".Color=" + string(al_color)
		dw_route.modify(ls_modstring)
	end if
next
end subroutine

public function long of_getprofitcenter ();/********************************************************************
   of_getprofitcenter
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		11/04/16		CR3767		XSZ004		First Version
   </HISTORY>
********************************************************************/

long ll_pcnr

if isvalid(iuo_itinerary) then
	iuo_itinerary.dynamic event ue_getvesselpc(ll_pcnr)
else
	ll_pcnr = uo_global.get_profitcenter_no()
end if

if isnull(ll_pcnr) then ll_pcnr = 0

return ll_pcnr



end function

public subroutine of_registerdistancesimple (w_atobviac_distance_finder_simple aw_window);iw_distance_finder_simple = aw_window
end subroutine

on c_engine_controlpanel.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_reset=create cb_reset
this.dw_route=create dw_route
this.mle_route_information=create mle_route_information
this.dw_constraints=create dw_constraints
this.dw_advanced_rp=create dw_advanced_rp
this.dw_primary_rp=create dw_primary_rp
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_saveas
this.Control[iCurrent+3]=this.cb_reset
this.Control[iCurrent+4]=this.dw_route
this.Control[iCurrent+5]=this.mle_route_information
this.Control[iCurrent+6]=this.dw_constraints
this.Control[iCurrent+7]=this.dw_advanced_rp
this.Control[iCurrent+8]=this.dw_primary_rp
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
this.Control[iCurrent+12]=this.gb_4
this.Control[iCurrent+13]=this.gb_5
end on

on c_engine_controlpanel.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_reset)
destroy(this.dw_route)
destroy(this.mle_route_information)
destroy(this.dw_constraints)
destroy(this.dw_advanced_rp)
destroy(this.dw_primary_rp)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event constructor;/* If not already active create instance */
if NOT isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac

/* If not open open tables - can take several seconds */
if NOT gnv_atobviac.of_getTableOpen( ) then
	open(w_startup_screen)
	gnv_AtoBviaC.of_OpenTable()
	gnv_AtoBviaC.of_resetToDefaultState(of_getprofitcenter())
	close(w_startup_screen)
end if

if isValid(gnv_AtoBviaC) then
	dw_advanced_rp.setTransObject(sqlca)
	dw_advanced_rp.retrieve()
	gnv_AtoBviaC.of_defaulrpfrompc(dw_primary_rp, dw_advanced_rp, of_getprofitcenter())
	gnv_AtoBviaC.of_getprimaryrpstateall(dw_primary_rp, of_getdefaultenginestate( )<>"")
	gnv_AtoBviaC.of_initadvancedrpindexes( dw_advanced_rp, of_getdefaultenginestate() ) 	/* atobviac 2013 */
	gnv_AtoBviaC.of_getadvancedrpstateall(dw_primary_rp, dw_advanced_rp, of_getdefaultenginestate( )<>"" ) /* atobviac 2013 */
	gnv_AtoBviaC.of_getprimaryconstraints( dw_constraints, dw_advanced_rp ) /* atobviac 2013 */
else
	MessageBox("Error", "Global variable gnv_AtoBviaC (distance table) not available")
end if


n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_primary_rp,false)
lnv_style.of_dwlistformater(dw_constraints,false)
lnv_style.of_dwlistformater(dw_advanced_rp,false)
lnv_style.of_dwlistformater(dw_route,false)

	
end event

type cb_print from mt_u_commandbutton within c_engine_controlpanel
integer x = 4165
integer y = 1976
integer taborder = 130
string text = "&Print"
end type

event clicked;call super::clicked;long ll_color

dw_route.setredraw(false)
ll_color = long(dw_route.describe("portcode_t.color"))
of_modifyheadertextcolor(0)
dw_route.print()
of_modifyheadertextcolor(ll_color)
dw_route.setredraw(true)
end event

type cb_saveas from mt_u_commandbutton within c_engine_controlpanel
integer x = 3817
integer y = 1976
integer taborder = 120
string text = "&Save As…"
end type

event clicked;call super::clicked;n_dataexport lnv_export

lnv_export.of_export(dw_route)
end event

type cb_reset from commandbutton within c_engine_controlpanel
integer x = 14
integer y = 2012
integer width = 535
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Reset Routing Points"
end type

event clicked;/* set back to default engine state */
of_resetEngine( )


end event

event rbuttondown;/* set back to saved state - only works for saved calculation */
if of_getdefaultenginestate( )<>"" then
	of_resetdefaultEngine( )
else
	messagebox("Info","Feature only works for saved calcaulations")
end if


end event

type dw_route from mt_u_datawindow within c_engine_controlpanel
integer x = 2898
integer y = 80
integer width = 1614
integer height = 1864
integer taborder = 50
string dataobject = "d_ex_tb_route"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if row > 0 then
	setrow(row)
	if row <> getselectedrow(0) then 
		event rowfocuschanged(row)
	end if
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 and currentrow <> getselectedrow(0) then
	selectrow(0, false)
	selectrow(currentrow, true)
end if
end event

type mle_route_information from multilineedit within c_engine_controlpanel
event ue_lbuttondblclk pbm_lbuttondblclk
integer x = 50
integer y = 1676
integer width = 1280
integer height = 272
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event ue_lbuttondblclk;/* show/hide the route string if needed */
if keydown(KEYSHIFT!) then
	if this.textcolor = rgb(255,255,255) then
		this.textcolor = rgb(0,0,0)
	else	
		this.textcolor = rgb(255,255,255)
	end if
end if
end event

type dw_constraints from mt_u_datawindow within c_engine_controlpanel
integer x = 55
integer y = 1328
integer width = 1280
integer height = 220
integer taborder = 70
string dataobject = "d_ex_tb_primary_routing_constraints"
boolean border = false
end type

event itemchanged;dw_advanced_RP.setredraw(false)
dw_route.setRedraw(false)
dw_constraints.accepttext()

gnv_AtoBviaC.POST of_setprimaryconstraints(dw_constraints, dw_advanced_rp)
post event ue_getenginestate()
dw_advanced_RP.setredraw(true)
if isValid( iuo_itinerary ) then 
	iuo_itinerary.POST uf_clear_cache()
end if
POST of_refreshroute( )
dw_route.setredraw(true)
end event

type dw_advanced_rp from mt_u_datawindow within c_engine_controlpanel
integer x = 1463
integer y = 80
integer width = 1353
integer height = 1996
integer taborder = 30
string dataobject = "d_sq_gp_advanced_routing_point"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;boolean lb_active
string ls_routingpoint

if row < 1 then return

if this.getItemNumber(row, "available") = 2 then 
	return 2
else 
	ls_routingpoint = this.getItemString(row, "routingPointCode")	
	if this.getItemNumber(row, "available") = 0 then 
		this.POST setItem(row, "available", 1)
		this.POST setItem(row, "is_checked", 1)
	else
		this.POST setItem(row, "available", 0)
		this.POST setItem(row, "is_checked", 0)
	end if
end if 


dw_route.setredraw(false)

/* specific order: update all primary and then advanced rp's */
gnv_AtoBviaC.of_setprimaryrpstateall(dw_primary_rp)
gnv_atobviac.of_setadvancedrpstateall(dw_advanced_rp)

this.accepttext()
if data = "0" then
	lb_active = false
else
	lb_active = true 
end if

gnv_AtoBviaC.of_useroutingpointbyname(ls_routingpoint, lb_active )

is_engineState = gnv_AtoBviaC.of_getEngineState()
event ue_getenginestate()
if isValid( iuo_itinerary ) then 
	iuo_itinerary.uf_clear_cache()
end if
of_refreshroute( )
dw_route.setredraw(true)
end event

type dw_primary_rp from mt_u_datawindow within c_engine_controlpanel
event ue_getenginestate ( )
event ue_itemchanged ( )
integer x = 55
integer y = 80
integer width = 1280
integer height = 1120
integer taborder = 10
string dataobject = "d_ex_tb_primary_routing_point"
boolean border = false
end type

event ue_getenginestate();is_engineState = gnv_AtoBviaC.of_getEngineState()



end event

event ue_itemchanged();string ls_retmsg
boolean lb_active=false

dw_advanced_RP.setredraw(false)
dw_route.setredraw(false)
dw_primary_RP.accepttext()
gnv_AtoBviaC.of_setprimaryrpstateall(dw_primary_RP)
/* atobviac 2013 implementation */
if il_primaryrprow > 0 then // only update advanced RP if user has updated column
	if this.getitemnumber(il_primaryrprow,"active") = 1 then
		lb_active=true
	end if
	/* we disable the related advanced RP's */
	gnv_atobviac.of_lockadvancedrp( dw_advanced_rp, this.getitemstring(il_primaryrprow,"primaryrpshortname"), not(lb_active), ls_retmsg )
end if
/* need to update all the advanced routings even if no primary row available */
gnv_atobviac.of_setadvancedrpstateall(dw_advanced_rp)
is_engineState = gnv_AtoBviaC.of_getEngineState()
this.event ue_getEngineState()
dw_advanced_RP.setredraw(true)
if isValid( iuo_itinerary ) then 
	iuo_itinerary.uf_clear_cache()
end if
of_refreshroute( )
dw_route.setredraw(true)
end event

event itemchanged;il_primaryrprow = row
post event ue_itemchanged( )
end event

type gb_1 from groupbox within c_engine_controlpanel
integer x = 14
integer y = 8
integer width = 1362
integer height = 1228
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Primary Routing Points"
end type

type gb_2 from groupbox within c_engine_controlpanel
integer x = 1413
integer y = 8
integer width = 1431
integer height = 2100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Advanced Routing Points"
end type

type gb_3 from groupbox within c_engine_controlpanel
integer x = 14
integer y = 1252
integer width = 1362
integer height = 320
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Primary Routing Constraints"
end type

type gb_4 from groupbox within c_engine_controlpanel
integer x = 14
integer y = 1608
integer width = 1362
integer height = 376
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Route Information"
end type

type gb_5 from groupbox within c_engine_controlpanel
integer x = 2875
integer y = 8
integer width = 1659
integer height = 2104
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Route"
end type

