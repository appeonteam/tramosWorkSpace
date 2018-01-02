$PBExportHeader$n_atobviac.sru
$PBExportComments$This object encapsulates the AtoBviaC engine
forward
global type n_atobviac from mt_n_nonvisualobject
end type
end forward

global type n_atobviac from mt_n_nonvisualobject
end type
global n_atobviac n_atobviac

type prototypes
SUBROUTINE SetTableName(string aTableName) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetTableName;ansi"
FUNCTION long OpenTables() LIBRARY "BPSDistanceTables.dll"
FUNCTION long GetErrorCode() LIBRARY "BPSDistanceTables.dll" 
FUNCTION String GetErrorString() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetErrorString;ansi"
SUBROUTINE FromPort(string aPortCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "FromPort;ansi"
SUBROUTINE ToPort(string aPortCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "ToPort;ansi"
SUBROUTINE UseEnvironmentalRouting(boolean aBool)  LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseASLCompliance(boolean aBool)  LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseBahamaChannel(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseBonifacioStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseCapeHorn(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseCapeOfGoodHope(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseCorinthCanal(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseDoverStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseKielCanal(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseLombokStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseMagellanStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseMessinaStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UsePanamaCanal(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseSingaporeStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseSuezCanal(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseSundaStrait(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseThursdayIsland(boolean aBool) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseWOfTaiwan(boolean aBool) LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseBahamaChannel() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseBonifacioStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseCapeHorn() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseCapeOfGoodHope() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseCorinthCanal() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseDoverStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseKielCanal() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseLombokStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseMagellanStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseMessinaStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUsePanamaCanal() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseSingaporeStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseSuezCanal() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseSundaStrait() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseThursdayIsland() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseWOfTaiwan() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseEnvironmentalRouting() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseASLCompliance() LIBRARY "BPSDistanceTables.dll"
FUNCTION long Calculate() LIBRARY "BPSDistanceTables.dll"
FUNCTION Integer Distance() LIBRARY "BPSDistanceTables.dll"
FUNCTION Real GetExactDistance() LIBRARY "BPSDistanceTables.dll"
SUBROUTINE SetRouteDelimiter(char aDelimiter) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetRouteDelimiter;ansi"
FUNCTION Char GetRouteDelimiter() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRouteDelimiter;ansi"
FUNCTION String GetRoute() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRoute;ansi"
SUBROUTINE IncludeRouteDetail(boolean aBool)  LIBRARY "BPSDistanceTables.dll"
SUBROUTINE CodesInRoute(boolean aBool) LIBRARY "BPSDistanceTables.dll"
FUNCTION long GetNumberOfLegsInRout() LIBRARY "BPSDistanceTables.dll"
FUNCTION Real GetLegDistance(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetTableVersion() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetTableVersion;ansi" 
FUNCTION String GetTableDate() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetTableDate;ansi" 
FUNCTION long GetNumberOfPorts() LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetPortName(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortName;ansi"
FUNCTION String GetPortCode(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortCode;ansi"
FUNCTION String GetPortCountry(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortCountry;ansi"
FUNCTION String GetPortTables(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortTables;ansi"
FUNCTION Real GetPortLatitude(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetPortLatitudeAsAscii(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortLatitudeAsAscii;ansi"
FUNCTION Real GetPortLongitude(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetPortLongitudeAsAscii(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPortLongitudeAsAscii;ansi"
FUNCTION boolean GetIsAliasPort(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION long GetAliasForIndex(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION long CloseTables() LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetRouteInformation() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRouteInformation;ansi"
FUNCTION long GetNumberOfRoutingPoints() LIBRARY "BPSDistanceTables.dll"
FUNCTION String GetRoutingPointName(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRoutingPointName;ansi"
FUNCTION String GetRoutingPointCode(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRoutingPointCode;ansi"
FUNCTION String GetAdvancedRPState(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetAdvancedRPState;ansi"
FUNCTION String GetAdvancedRPStateByName(String aCpRpName) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetAdvancedRPStateByName;ansi"
FUNCTION boolean GetAdvancedRPAvailable(long anIndex) LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetAdvancedRPAvailableByName(string aName) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetAdvancedRPAvailableByName;ansi"
SUBROUTINE UseRoutingPoint(long anIndex, boolean aBool)  LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseRoutingPointByName(String aCpRpName, boolean aBool)  LIBRARY "BPSDistanceTables.dll" ALIAS FOR "UseRoutingPointByName;ansi"
SUBROUTINE ResetToDefaultState() LIBRARY "BPSDistanceTables.dll"
/*  Next two functions are changed and replaced by GetRoutingCode & SetRoutingCode */
//FUNCTION String GetRoutingCodeString() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRoutingCodeString;ansi"
//SUBROUTINE SetRoutingCodeString(string aRouteCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetRoutingCodeString;ansi"
// GetRoutingCode
//   Returns a string that represents the current Primary and Advanced Routing state
FUNCTION String GetRoutingCode() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetRoutingCode;ansi"

// SetRoutingCode
//   Called to set the Primary and Advanced routing points to the values in the string
SUBROUTINE SetRoutingCode(string aRouteCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetRoutingCode;ansi"

// GetNumPrimaryRoutingPoints
//   Returns the number of defined Primary Routing Points
FUNCTION long GetNumPrimaryRoutingPoints() LIBRARY "BPSDistanceTables.dll"

// GetPrimaryCode
//   Returns a string with the CODE from a Primary Routing point based in the index passed
FUNCTION String GetPrimaryCode(long anIndex) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetPrimaryCode;ansi"

// GetNumCpRpSpForPrimaryCode
//   Returns the number of CPXXXX,RPXXXX,SPXXXX Points controlled by the
//     Primary Routing point whose code was passed
FUNCTION long GetNumCpRpSpForPrimaryCode(string aCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetNumCpRpSpForPrimaryCode;ansi"

// GetCpRpSpForPrimaryCode
//   Returns a string containing the CPXXXX,RPXXXX,SPXXXX Points controlled by the
//     Primary Routing point whose code was passed
FUNCTION String GetCpRpSpForPrimaryCode(string aCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetCpRpSpForPrimaryCode;ansi"

/* atobviac 2013 implementation */
FUNCTION long GetAdvancedRPIndexByName(string aName) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetAdvancedRPIndexByName;ansi"
FUNCTION string GetCpRpSpForPrimaryShortCode(string aCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetCpRpSpForPrimaryShortCode;ansi"
FUNCTION long GetNumCpRpSpForShortCode(string aCode) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetNumCpRpSpForShortCode;ansi"
FUNCTION boolean GetUseAntiPiracy() LIBRARY "BPSDistanceTables.dll"
FUNCTION boolean GetUseRoutingPoint(long anIndex) LIBRARY "BPSDistanceTables.dll"
SUBROUTINE UseAntiPiracy(boolean aBool)  LIBRARY "BPSDistanceTables.dll"

/* CR3248 SECA scanner additional functions */
FUNCTION String GetSecaMileages() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetSecaMileages;ansi"
SUBROUTINE SetScanForSecaZones(boolean aBool) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetScanForSecaZones"
FUNCTION boolean GetScanForSecaZones() LIBRARY "BPSDistanceTables.dll"

//CR3787 Map functions
SUBROUTINE NewMap() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "NewMap;ansi"
SUBROUTINE PlotRouteToMap() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "PlotRouteToMap;ansi"
FUNCTION long GetMap() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetMap;ansi"
SUBROUTINE SetMapLevel(integer level) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetMapLevel;ansi"
FUNCTION long GetMapWidth() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetMapWidth;ansi"
FUNCTION long GetMapHeight() LIBRARY "BPSDistanceTables.dll" ALIAS FOR "GetMapHeight;ansi"
SUBROUTINE SetShowPiracyAreasOnMap(boolean aBool) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetShowPiracyAreasOnMap;ansi"
SUBROUTINE SetShowSecaZonesOnMap(boolean aBool) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "SetShowSecaZonesOnMap;ansi"
SUBROUTINE PlotPosition(decimal Latitude, decimal Longitude, string portname) LIBRARY "BPSDistanceTables.dll" ALIAS FOR "PlotPosition;ansi"

end prototypes

type variables
private datastore	ids_port
private boolean	ib_tableOpen=false

end variables

forward prototypes
public subroutine of_FromPort(string as_PortCode)
public subroutine of_ToPort(string as_PortCode)
public function long of_calculate ()
public function Integer of_Distance()
public function Real of_GetExactDistance()
public subroutine of_SetRouteDelimiter(char ac_Delimiter)
public function Char of_GetRouteDelimiter()
public subroutine of_IncludeRouteDetail(boolean ab_Bool)
public subroutine of_CodesInRoute(boolean ab_Bool)
public function Real of_GetLegDistance(long al_Index)
public function String of_GetTableVersion()
public function String of_GetTableDate()
public function long of_GetNumberOfPorts()
public function String of_GetPortName(long al_Index)
public function String of_GetPortCode(long al_Index) 
public function String of_GetPortCountry(long al_Index)
public function String of_GetPortTables(long al_Index)
public function Real of_GetPortLatitude(long al_Index) 
public function String of_GetPortLatitudeAsAscii(long al_Index)
public function Real of_GetPortLongitude(long al_Index)
public function String of_GetPortLongitudeAsAscii(long al_Index) 
public function boolean of_GetIsAliasPort(long al_Index) 
public function long of_GetAliasForIndex(long al_Index)
public function long of_CloseTables() 
public function String of_GetRouteInformation() 
public function long of_GetNumberOfRoutingPoints()
public function String of_GetRoutingPointName(long al_Index) 
public function String of_GetRoutingPointCode(long al_Index) 
public function String of_GetAdvancedRPStateByName(String as_CpRpName) 
public function boolean of_GetAdvancedRPAvailable(long al_Index)
public function boolean of_GetAdvancedRPAvailableByName(string as_Name) 
public subroutine of_UseRoutingPoint(long al_Index, boolean ab_Bool)  
public subroutine of_useroutingpointbyname (string as_cprpname, boolean ab_bool)
public subroutine of_geterror (ref long al_code, ref string as_message)
public function integer of_feeddbtables (ref hprogressbar ahpb_bar)
public function integer of_setprimaryrpstateall (ref mt_u_datawindow adw)
public function integer of_getporttoportdistance (string as_fromport, string as_toport)
public function integer of_setadvancedrpstateall (ref mt_u_datawindow adw)
public function boolean of_gettableopen ()
public function long of_opentable ()
public function long of_getnumberoflegsinroute ()
public subroutine of_resettodefaultstate ()
public function string of_getenginestate ()
public function integer of_setenginestate (string as_stringstate)
public function integer of_countlegcanals (string as_fromport, string as_toport)
public function integer of_findremovedportcode (ref hprogressbar ahpb_bar)
public function integer of_initadvancedrpindexes (mt_u_datawindow adw_advancedrp, string as_enginestate)
public function integer of_setprimaryconstraints (ref mt_u_datawindow adw_constraints, mt_u_datawindow adw_advancedrp)
public function integer of_getprimaryconstraints (ref mt_u_datawindow adw_constraints, mt_u_datawindow adw_advancedrp)
public subroutine documentation ()
public function integer of_lockadvancedrp (mt_u_datawindow adw_advancedrp, string as_shortcode, boolean ab_locked, ref string as_retmsg)
public function integer of_getuseroutingpoint (integer al_abcindex)
public function integer of_getroute (string as_portsequence[], ref mt_u_datawindow adw_route)
public function decimal of_getporttoportdistance (string as_fromport, ref string as_toport, string as_beginport, string as_endport)
public function integer of_getadvancedrpstateall (mt_u_datawindow adw_primaryrp, ref mt_u_datawindow adw_advancedrp, boolean ab_useengineforstate)
public function boolean of_is_asl_advancedrp (string as_routingpoint)
public function integer of_is_route_starting_inside_seca ()
public function decimal of_total_seca_distance_in_route ()
public function integer of_get_seca_state_for_row (string as_port_code, integer ai_previous_state, ref boolean ab_modified)
public subroutine of_set_seca (boolean ab_enabled)
public function boolean of_is_seca_enabled ()
public function string of_get_seca_mileages ()
public function long of_opentable (string as_abctablepath)
public subroutine of_newmap ()
public subroutine of_plotroutetomap ()
public function long of_getmap ()
public subroutine of_setmaplevel (integer ai_level)
public function long of_getmapwidth ()
public function long of_getmapheight ()
public subroutine of_setshowpiracyareasonmap (boolean ab_show)
public subroutine of_setshowsecazonesonmap (boolean ab_show)
public subroutine of_plotposition (decimal ad_latitude, decimal ad_longitude, string as_portname)
public function integer of_getprimaryrpstateall (ref mt_u_datawindow adw, boolean ab_useengineforstate)
public subroutine of_defaulrpfrompc (mt_u_datawindow adw_primaryroute, mt_u_datawindow adw_advancedroute, long al_pcnr)
public subroutine of_resettodefaultstate (long al_pcnr)
end prototypes

public subroutine of_FromPort(string as_PortCode)
// FromPort
//   Called to set the FROM port CODE
//     The code is obtained using GetPortCode
FromPort( as_PortCode ) 
end subroutine

public subroutine of_ToPort(string as_PortCode)
// ToPort
//   Called to set the TO port CODE
//     The code is obtained using GetPortCode
ToPort( as_PortCode )
end subroutine

public function long of_calculate ();// Calculate
//   Obtains the distance between the FROM and TO ports
//   Returns the distance as a 32 bit Integer or 0 if an ERROR occurred 
n_object_usage_log lnv_uselog
lnv_uselog.uf_log_object("atobviac_calculate")

return Calculate()
end function

public function Integer of_Distance()
// Distance
//   Returns the last distance calculated as a 32bit Integer
//   0 if an error occurred
return Distance()
end function

public function Real of_GetExactDistance()
// ExactDistance
//   Returns the last distance calculated as a 32bit Double
//   0 if an error occurred
return GetExactDistance()
end function

public subroutine of_SetRouteDelimiter(char ac_Delimiter)
// SetRouteDelimiter
//   Gets the current route delimiter character
SetRouteDelimiter(ac_Delimiter)
end subroutine

public function Char of_GetRouteDelimiter()
// GetRouteDelimiter
//   Gets the current route delimiter character
return GetRouteDelimiter()
end function

public subroutine of_IncludeRouteDetail(boolean ab_Bool)
// IncludeRouteDetai
//   Set to TRUE to include any additional information about the actual route
IncludeRouteDetail( ab_Bool)
end subroutine

public subroutine of_CodesInRoute(boolean ab_Bool)
// CodesInRoute
//   Set to TRUE to return a route with the codes for each waypoint instead of the names
CodesInRoute( ab_Bool)
end subroutine

public function Real of_GetLegDistance(long al_Index)
// GetLegDistance
// Retuns as a 32bit Double the exact distance for the Index passed
return GetLegDistance( al_Index)
end function

public function String of_GetTableVersion()
// Table Information
// GetTableVersion
//   Returns the version (as a string) of the table opened
return GetTableVersion()
end function

public function String of_GetTableDate()
// Table Information
// GetTableDate
//   Returns the Date (as a string) of the table opened
return GetTableDate()
end function

public function long of_GetNumberOfPorts()
// Port Information
// GetNumberOfPorts
//   Returns the number of Ports the current table contains
return GetNumberOfPorts()
end function

public function String of_GetPortName(long al_Index)
// GetPortName
//   Returns the name of the Port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortName(al_Index)
end function

public function String of_GetPortCode(long al_Index) 
// GetPortCode
//   Returns the code of the Port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortCode( al_Index) 
end function

public function String of_GetPortCountry(long al_Index)
// GetPortCountry
//   Returns the Country of the Port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortCountry( al_Index)
end function

public function String of_GetPortTables(long al_Index)
// GetPortTables
//   Returns the BP Tables that the port is in with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortTables( al_Index)
end function

public function Real of_GetPortLatitude(long al_Index) 
// GetPortLatitude
//   Returns a 32bit Double representing the Latitude of the port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortLatitude( al_Index) 
end function

public function String of_GetPortLatitudeAsAscii(long al_Index)
// GetPortLatitudeAsAscii
//   Returns  String representing the Latitude of the port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortLatitudeAsAscii( al_Index)
end function

public function Real of_GetPortLongitude(long al_Index)
// GetPortLongitude
//   Returns a 32bit Double representing the Longitude of the port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortLongitude( al_Index)
end function

public function String of_GetPortLongitudeAsAscii(long al_Index) 
// GetPortLongitudeAsAscii
//   Returns  String representing the Longitude of the port with the Index(1 based) passed.  If "" is returned then check
//   GetErroCode or GetErrorString for the error, probably Index is out of range
return GetPortLongitudeAsAscii( al_Index) 
end function

public function boolean of_GetIsAliasPort(long al_Index) 
// GetIsAliasPort
//   Returns TRUE if this port is an alias port for another
return GetIsAliasPort( al_Index) 
end function

public function long of_GetAliasForIndex(long al_Index)
// GetAliasFroIndex
//   Returns the Index of the port for which the port with the passed index is an alias
//   Thus the PortName that an Alias port represents can be obtained by the following:-
//     PortName(GetAliasFormIndex(xxx))
return GetAliasForIndex( al_Index)
end function

public function long of_CloseTables() 
// CloseTables
//   Called to close the table previously opened with OpenTables
//   Returns 0 if successful, 1 if not
return CloseTables() 
end function

public function String of_GetRouteInformation() 
// GetRouteInformation
//   Returns and pertinent routing information
return GetRouteInformation() 
end function

public function long of_GetNumberOfRoutingPoints()
// GetNumberOfRoutingPoints
//   Returns the number of Advanced outing points
return GetNumberOfRoutingPoints()
end function

public function String of_GetRoutingPointName(long al_Index) 
// GetRoutingPointName
//   Returns the Advanced routing point display name
return GetRoutingPointName( al_Index) 
end function

public function String of_GetRoutingPointCode(long al_Index) 
// GetRoutingPointCode
//   Returns the Advanced routing point code
return GetRoutingPointCode( al_Index) 
end function

public function String of_GetAdvancedRPStateByName(String as_CpRpName) 
// GetAdvancedRPStateByName
//   Returns a string indicating the current state of an advanced routing point
//   Values returned:-
//     "Disabled" = This way point is disabled because a Primary rotuing point is controlling it
//     "Open"     = This waypoint is available for use
//     "Closed"   = This waypoint is NOT available for use
return GetAdvancedRPStateByName( as_CpRpName) 
end function

public function boolean of_GetAdvancedRPAvailable(long al_Index)
// GetAdvancedRPAvailable
// Returns True or False indicating if the Advance routing point can have it's Open/Closed state changed
// using the UseRoutingPoint function call
return GetAdvancedRPAvailable( al_Index)
end function

public function boolean of_GetAdvancedRPAvailableByName(string as_Name) 
// GetAdvancedRPAvailableByName
// Returns True or False indicating if the Advance routing point can have it's Open/Closed state changed
// using the UseRoutingPoint or UseRoutingPointByName function call
return GetAdvancedRPAvailableByName( as_Name) 
end function

public subroutine of_UseRoutingPoint(long al_Index, boolean ab_Bool)  
// UseRoutingPoint
//   Call with index and Open/Closed to set 
UseRoutingPoint(al_Index, ab_Bool)  
end subroutine

public subroutine of_useroutingpointbyname (string as_cprpname, boolean ab_bool);// UseRoutingPointByName
//   Call with a SPRPCP PortCode and Open/Closed to set 
UseRoutingPointByName(as_CpRpName, ab_Bool)
end subroutine

public subroutine of_geterror (ref long al_code, ref string as_message);// GetErrorCode
//   Returns the last errorcode, 0 if no error
al_code =  GetErrorCode()
if al_code = 0 then return

// GetErrorString
//   Returns a description of the last error
as_message = GetErrorString() 

return
end subroutine

public function integer of_feeddbtables (ref hprogressbar ahpb_bar);integer li_ret
long    ll_NumPorts, ll_Index, ll_row, ll_new_row
string  ls_error

mt_n_datastore lds_port, lds_new

w_atobviac_controlpanel lw

lw = ahpb_bar.getParent()

ll_NumPorts = GetNumberOfPorts()	

lds_port = create mt_n_datastore
lds_port.dataObject = "d_sq_tb_port"
lds_port.setTransObject( sqlca )

lds_new = create mt_n_datastore
lds_new.dataObject = "d_ex_tb_new_ports"

choose case lds_port.retrieve()
	case 0 /* no rows - all new */
		ahpb_bar.maxposition = ll_NumPorts
		FOR ll_Index = 1 to ll_NumPorts
			ahpb_bar.position = ll_index 
			if isValid(lw) then lw.st_feed_status.text = "Reading Ports from Table..."
			/* if alias continue to next */
			if of_GetIsAliasPort(ll_index) then continue
			ll_row = lds_port.insertRow( 0 )
			
			lds_port.setItem(ll_row, "abc_portcode", of_GetPortCode( ll_index ))
			lds_port.setItem(ll_row, "abc_portname", of_GetPortName( ll_index ))
			lds_port.setItem(ll_row, "abc_portcountry", of_GetPortCountry( ll_index ))
			lds_port.setItem(ll_row, "abc_latitudeascii", of_GetPortLatitudeAsAscii( ll_index ))
			lds_port.setItem(ll_row, "abc_latitude", of_GetPortLatitude( ll_index ))
			lds_port.setItem(ll_row, "abc_longitudeascii", of_GetPortLongitudeAsAscii( ll_index ))
			lds_port.setItem(ll_row, "abc_longitude", of_GetPortLongitude( ll_index ))
			lds_port.setItem(ll_row, "abc_advanced_rp", 0)
		NEXT
	case else /* already ports - find and update */
		ahpb_bar.maxposition = ll_NumPorts
		FOR ll_Index = 1 to ll_NumPorts
			ahpb_bar.position = ll_index 
			if isValid(lw) then lw.st_feed_status.text = "Reading Ports from Table..."
			/* if alias continue to next */
			if of_GetIsAliasPort(ll_index) then continue
			ll_row = lds_port.find("abc_portcode='"+of_GetPortCode( ll_index )+"'",1,99999)
			if ll_row < 1 then 
				ll_row = lds_port.insertRow( 0 )
				lds_port.setItem(ll_row, "abc_portcode", of_GetPortCode( ll_index ))
				/* Add item to new port. Showing user added ports */
				ll_new_row = lds_new.insertRow( 0 )
				
				lds_new.setItem(ll_new_row, "portcode", of_GetPortCode( ll_index ))
				lds_new.setItem(ll_new_row, "portname", of_GetPortName( ll_index ))
				lds_new.setItem(ll_new_row, "country", of_GetPortCountry( ll_index ))
				lds_new.setItem(ll_new_row, "latitudeascii", of_GetPortLatitudeAsAscii( ll_index ))
				lds_new.setItem(ll_new_row, "longitudeascii", of_GetPortLongitudeAsAscii( ll_index ))
			end if
			lds_port.setItem(ll_row, "abc_portname", of_GetPortName( ll_index ))
			lds_port.setItem(ll_row, "abc_portcountry", of_GetPortCountry( ll_index ))
			lds_port.setItem(ll_row, "abc_latitudeascii", of_GetPortLatitudeAsAscii( ll_index ))
			lds_port.setItem(ll_row, "abc_latitude", of_GetPortLatitude( ll_index ))
			lds_port.setItem(ll_row, "abc_longitudeascii", of_GetPortLongitudeAsAscii( ll_index ))
			lds_port.setItem(ll_row, "abc_longitude", of_GetPortLongitude( ll_index ))
			lds_port.setItem(ll_row, "abc_advanced_rp", 0)
		NEXT
end choose		

ll_NumPorts = of_getNumberofroutingpoints( )
ahpb_bar.maxposition = ll_NumPorts
FOR ll_Index = 1 to ll_NumPorts
	ahpb_bar.position = ll_index 
	if isValid(lw) then lw.st_feed_status.text = "Reading Routing Points from Table..."
	ll_row = lds_port.find("abc_portcode='"+of_GetRoutingPointCode( ll_index )+"'",1,99999)
	if ll_row > 1 then 
		lds_port.setItem(ll_row, "abc_advanced_rp", 1)
	end if
NEXT
	
if isValid(lw) then lw.st_feed_status.text = "Saving Ports / Routing Points. Please wait ..."

li_ret = lds_port.Update()

if li_ret = c#return.success then
	
	commit;
	
	if isValid(lw) then lw.st_feed_status.text = "Update completed..."
	
	if lds_new.rowCount() > 0 then
		openWithParm(w_show_added_ports, lds_new)
	end if
else
	ls_error = sqlca.sqlerrtext
	rollback;
	MessageBox("","Update Port table failed. " + ls_error)
	if isValid(lw) then lw.st_feed_status.text = "Update failed..."
end if

destroy lds_port
destroy lds_new

return li_ret
end function

public function integer of_setprimaryrpstateall (ref mt_u_datawindow adw);long ll_rows, ll_row
boolean lb_active

ll_rows = adw.rowCount()

for ll_row = 1 to ll_rows
	if adw.getItemNumber(ll_row, "active") = 1  then
		lb_active = true
	else
		lb_active = false
	end if

	choose case adw.getItemString(ll_row, "PrimaryRPName")
		case "Kiel Canal"
			UseKielCanal(lb_active)
		case "Suez Canal"
			UseSuezCanal(lb_active)
		case "Panama Canal"
			UsePanamaCanal(lb_active)
		case "Corinth Canal"
			UseCorinthCanal(lb_active)
		case "Dover Strait"
			UseDoverStrait(lb_active)
		case "Singapore Strait"
			UseSingaporeStrait(lb_active)
		case "Sunda Strait"
			UseSundaStrait(lb_active)
		case "Lombok Strait"
			UseLombokStrait(lb_active)
		case "Magellan Strait"
			UseMagellanStrait(lb_active)
		case "Bonifacio Strait"
			UseBonifacioStrait(lb_active)
		case "Messina Strait"
			UseMessinaStrait(lb_active)
		case "Thursday Island"
			UseThursdayIsland(lb_active)
		case "Cape of Good Hope"
			UseCapeofGoodHope(lb_active)
		case "Cape Horn"
			UseCapeHorn(lb_active)
		case "Bahama Channel"
			UseBahamaChannel(lb_active)
		case "West of Taiwan"
			UseWofTaiwan(lb_active)
	end choose
next

return 1
end function

public function integer of_getporttoportdistance (string as_fromport, string as_toport);integer	li_distance
long ll_found, ll_from_portID, ll_to_portID
decimal {2} ld_distance 

n_object_usage_log lnv_uselog
lnv_uselog.uf_log_object("atobviac_distance(2)")

/* Returns the distance between two ports */
fromPort( as_fromPort)
toPort(as_toPort)
li_distance = calculate()

if li_distance <= 0 and geterrorcode( ) = 25 then
	/* If no direct distance se in local distances */
	ll_found = w_share.dw_sq_tb_cache_atobviacports.find("abc_portcode='"+as_fromPort+"'", 1, 999999)
	if ll_found > 0 then
		ll_from_portID =  w_share.dw_sq_tb_cache_atobviacports.getItemNumber(ll_found, "abc_portid")
	end if
	ll_found = w_share.dw_sq_tb_cache_atobviacports.find("abc_portcode='"+as_toPort+"'", 1, 999999)
	if ll_found > 0 then
		ll_to_portID =  w_share.dw_sq_tb_cache_atobviacports.getItemNumber(ll_found, "abc_portid")
	end if
	setNull(ld_distance)
	SELECT DISTANCE
		INTO :ld_distance
		FROM LOCAL_ATOBVIAC_DISTANCE
		WHERE (FROM_PORTID = :ll_from_portID AND TO_PORTID = :ll_to_portID )
				OR (TO_PORTID = :ll_from_portID AND FROM_PORTID = :ll_to_portID )
		ORDER BY FROM_PORTID;
	if isNull(ld_distance) or ld_distance = 0 then	
		li_distance = 0
	else
		li_distance = integer(ld_distance)
	end if
end if

return li_distance

end function

public function integer of_setadvancedrpstateall (ref mt_u_datawindow adw);/********************************************************************
of_setadvancedrpstateall( /*ref mt_u_datawindow adw*/) 

<DESC>
	Set advanced routing points. This function is called when several instances of calculations 
	or distance finder are active on the same machine.
	It also is called when user updates primary rp or advanced rp.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	adw - advanced RP's
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

long ll_rows, ll_row
boolean lb_active
string ls_routingpoint

ll_rows = adw.rowCount()

for ll_row = 1 to ll_rows
	ls_routingpoint = adw.getItemString(ll_row, "routingPointCode")
	if adw.getItemNumber(ll_row, "available") = 1 then
		lb_active = true
	elseif adw.getItemNumber(ll_row, "available") = 0 then
		lb_active = false
	else
		/* if disabled - controlled by primary rp */
		continue
	end if
	of_useroutingpointbyname(ls_routingpoint, lb_active )
next

return c#return.Success
end function

public function boolean of_gettableopen ();return ib_tableOpen
end function

public function long of_opentable ();string ls_path
long	ll_startPosition

ls_path = trim(uo_global.gs_atobviac_path)
if ls_path = "" then
	MessageBox("Error" , "Path for AtoBviaC distance table not given in system options. Please correct and try again")
	return -1
end if

if right(ls_path,1) <> "\" then ls_path += "\"
/* Replace %USERNAME% with users userid if in string */
ll_startPosition = pos(Upper(ls_path), upper("%USERNAME%"))
if ll_startPosition > 0 then ls_path = replace(ls_path, ll_startPosition, 10, uo_global.getWindowsuserid( ))
ls_path = ls_path+"BPSTables.bin"

/* Check if file exists */
if NOT fileExists(ls_path) then
	MessageBox("Error" , "Distance Table File not found! ~n~r~Given path: "+ls_path+"~n~r~n~rPath for AtoBviaC distance table not correct. Please correct in system options and try again")
	return -1
end if

// SetTableName
//   Called to set the table to open.
//   The tablename MUST be the fullpath to the table including the table name
SetTableName( ls_path) 
// OpenTables
//   Called to open the tables once the Table to open has been set with SetTableName
//   Returns 0 is successful, 1 if not
//   ****** PLEASE NOTE ******
//   The open function may take some seconds to call, the engine has lots of wrok to
//     do when opeing tables.
if OpenTables() = 0 then 
	ib_tableOpen = true
	Return 0
else
	Return 1
end if

end function

public function long of_getnumberoflegsinroute ();// GetNumberOfLegsInRoute
// Returns as a 32bit Integer, the number of legs used in the route
return GetNumberOfLegsInRout()
end function

public subroutine of_resettodefaultstate ();of_resettodefaultstate(0)

end subroutine

public function string of_getenginestate ();// GetRoutingCodeString
//   Returns a string that represents the current Primary and Advanced Routing state

//return GetRoutingCodeString()
return GetRoutingCode()

end function

public function integer of_setenginestate (string as_stringstate);// SetRoutingCodeString
//   Called to set the Primary and Advanced routing points to the values in the string

//SetRoutingCodeString( as_stringState ) 
if len(as_stringstate) < 5 then return 1

SetRoutingCode( as_stringState ) 

return 1
end function

public function integer of_countlegcanals (string as_fromport, string as_toport);/* This function counts number of TRAMOS canals passed in given leg 
	
	Returns the number of canals passed 										*/
datastore lds_legRoute
string 	ls_route, ls_search_code, ls_old_str, ls_new_str
integer	li_canal_count=0
long 		ll_row, ll_rows, ll_found, ll_start_pos
char 		lc_delimit

IncludeRouteDetail(false)
CodesInRoute(true)
lc_delimit = getroutedelimiter( )
if as_fromport ="" or isNull(as_fromport) then return 0
if as_toport ="" or isNull(as_toport) then return 0
FromPort(as_fromport)
ToPort(as_toport)
Calculate()
ls_Route = GetRoute()
/* replace all delimiter with ~r~n */
ll_start_pos=1
ls_old_str = lc_delimit
ls_new_str = "~r~n"
// Find the first occurrence of old_str.
ll_start_pos = Pos(ls_route, ls_old_str, ll_start_pos) 
// Only enter the loop if you find old_str.
DO WHILE ll_start_pos > 0
	 // Replace old_str with new_str.
	 ls_route = Replace(ls_route, ll_start_pos, Len(ls_old_str), ls_new_str)
	 // Find the next occurrence of old_str.
	 ll_start_pos = Pos(ls_route, ls_old_str, ll_start_pos+Len(ls_new_str))
LOOP

lds_legRoute = create datastore
lds_legRoute.dataObject = "d_ex_tb_route"
lds_legRoute.ImportString(ls_Route)

if not isvalid(w_share.dw_calc_port_dddw) then return 0

ll_rows = lds_legRoute.rowCount()
for ll_row = 1 to ll_rows
	ll_found = w_share.dw_calc_port_dddw.find("abc_port_portcode='"+lds_legRoute.getItemString(ll_row, "portcode")+"'",1,99999)
	if ll_found > 0 then
		if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "via_point") = 2 then
			li_canal_count++
		end if
	end if
next

return li_canal_count





end function

public function integer of_findremovedportcode (ref hprogressbar ahpb_bar);/*  This function is running through all local registered AtoBviaC portcodes to 
	see if there are codes removed from the engine.
	If so there is a list shown including the portcodes and if the portcode
	is linked to a port in tramos. 
	When all linked ports are changed, then the codes can be deleted from
	the AtoBviaC Portcode table
*/
long ll_rows, ll_row, ll_ec
n_ds lds_port, lds_deleted
string ls_ABCportcode, ls_em, ls_retrieveCodes[]
w_atobviac_controlpanel lw

lw = ahpb_bar.getParent()

lds_port = create n_ds
lds_port.dataObject = "d_sq_tb_port"
lds_port.setTransObject( sqlca )


//lds_new = create n_ds
//lds_new.dataObject = "d_ex_tb_new_ports"

ll_rows =  lds_port.retrieve()
ahpb_bar.maxposition = ll_rows 

FOR ll_row = 1 to ll_rows
	ahpb_bar.position = ll_row
	if isValid(lw) then lw.st_feed_status.text = "Running through the AtoBviaC ports..."
	ls_ABCportcode = lds_port.getItemString(ll_row, "abc_portcode")
	choose case ls_ABCportcode
		case "SP0030", "SP0040", "SP0050", "SP0060", "SP0070"
			// Ignore these as they are hard codes canal transit routing points
		case else
			if of_getPortToPortDistance( ls_ABCportcode, ls_ABCportcode ) = 0 then
				of_getError( ll_ec, ls_em )
				if ll_ec <> 5 then 
					ls_retrieveCodes[upperbound(ls_retrieveCodes) +1] = ls_ABCportcode
				end if
			end if
	end choose
NEXT

if upperBound(ls_retrieveCodes) > 0 then
	lds_deleted = create n_ds
	lds_deleted.dataObject = "d_sq_tb_removed_portcodes"
	lds_deleted.setTransObject(sqlca)
	lds_deleted.retrieve( ls_retrieveCodes )
	if lds_deleted.rowCount() > 0 then
		openWithParm(w_show_removed_ports, lds_deleted)
	end if
	if isValid(lds_deleted) then destroy lds_deleted
else
	MessageBox("Information", "No ports removed!")
end if

if isValid(lds_port) then destroy lds_port
return  1
end function

public function integer of_initadvancedrpindexes (mt_u_datawindow adw_advancedrp, string as_enginestate);/* atobviac 2013 */
long ll_row
integer li_activated
string ls_routingpoint

for ll_row = 1 to adw_advancedrp.rowcount()
	ls_routingpoint = adw_advancedrp.getitemstring(ll_row,"routingpointcode")
	/* both cases we load abc_index for each advanced RP */
	adw_advancedrp.setItem(ll_row, "abc_index", GetAdvancedRPIndexByName(ls_routingpoint))
	if as_enginestate="" then /* from distance finder and new calculation */
		adw_advancedrp.setItem(ll_row, "available", adw_advancedrp.getitemnumber(ll_row,"defaultvalue"))	
		adw_advancedrp.setItem(ll_row, "is_checked", adw_advancedrp.getitemnumber(ll_row,"defaultvalue"))	
	else /* when we have an existing calculation obtain state from engine */
		li_activated = of_getuseroutingpoint(adw_advancedrp.getitemnumber(ll_row,"abc_index"))
		if li_activated<>c#return.Failure then
			adw_advancedrp.setitem(ll_row,"is_checked",li_activated)
			if adw_advancedrp.getitemnumber(ll_row,"available") <> 2 then /* only update available if it is not locked */		
				adw_advancedrp.setitem(ll_row,"available",li_activated)
			end if		
		end if
	end if	
next 	
return c#return.Success
end function

public function integer of_setprimaryconstraints (ref mt_u_datawindow adw_constraints, mt_u_datawindow adw_advancedrp);/********************************************************************
of_setprimaryconstraints( /*ref mt_u_datawindow adw_constraints*/, /*mt_u_datawindow adw_advancedrp */) 

<DESC>
	sets the engine up to match the checkboxes inside the primary constaints.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	ASL requires a call to of_setadvancedrpstate() as the state of the checkbox
	impacts the advanced routing points directly.
	Constraint name is used explicitely to identify a constraint.  Any amendments to the text
	will need to be updated here also.
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

/* atobviac 2013 */
long ll_rows, ll_row
boolean lb_active
string ls_message

ll_rows = adw_constraints.rowCount()

for ll_row = 1 to ll_rows
	if adw_constraints.getItemNumber(ll_row, "active") = 1  then
		lb_active = true
	else
		lb_active = false
	end if
	choose case adw_constraints.getItemString(ll_row, "constraintName")
		case "Environmental / Navigational / Regulatory Routing"
			UseEnvironmentalRouting(lb_active)
		case "Archipelagic Sea Lanes(ASL) Compliant"
			UseASLCompliance(lb_active)
			of_lockadvancedrp(adw_advancedrp,"ASL", lb_active, ls_message)
			adw_advancedrp.ResetUpdate()
		case "Use Anti-Piracy routing"
			UseAntiPiracy(lb_active)
	end choose
next

return c#return.Success
end function

public function integer of_getprimaryconstraints (ref mt_u_datawindow adw_constraints, mt_u_datawindow adw_advancedrp);/* atobviac 2013 */
long ll_rows, ll_row
boolean lb_active
string ls_message

ll_rows = adw_constraints.rowCount()

for ll_row = 1 to ll_rows
	choose case adw_constraints.getItemString(ll_row, "constraintName")
		case "Environmental / Navigational / Regulatory Routing"
			lb_active = GetUseEnvironmentalRouting()
		case "Archipelagic Sea Lanes(ASL) Compliant"
			lb_active = GetUseASLCompliance()
			of_lockadvancedrp(adw_advancedrp,"ASL", lb_active, ls_message)
			adw_advancedrp.ResetUpdate()
		case "Use Anti-Piracy routing"
			lb_active = GetUseAntiPiracy()
	end choose
	if lb_active then
		adw_constraints.setItem(ll_row, "active", 1)
	else
		adw_constraints.setItem(ll_row, "active", 0)
	end if
next

return c#return.Success

end function

public subroutine documentation ();/********************************************************************
   nonvisualobject name: n_atobviac
	
	<OBJECT>
		used as interface to external atobviac distance engine dll.
		also contains business logic to handle results in correct way
	</OBJECT>
   <DESC>
		
	</DESC>
   <USAGE>

	</USAGE>
   <ALSO>
			
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	25/09/13		CR3316	AGL027			Integrate new atobviac engine
	22/10/13		CR3316	AGL027			Resolve issues found inside UAT delivery one for initial release 27.04.2
	27/11/13		CR3316	AGL027			Resolve issues found inside UAT delivery two for release 27.04.2
	19/02/14		CR2790	ZSW001			After using the new engine, the return value of distance between two ports is &
                                       less than zero if it is not possible to calculate.
	27/10/15		CR3248	AGL027			Interface to SECA functionality inside AtoBviaC. New SECA related methods created.
	26/11/15		CR3248	CCY018			Add ECA Areas in Route.
   08/02/16		CR4298	AGL027			Allow AXEstimate application to use its own path for atobviac tables
	22/02/16		CR3767	XSZ004			When a user opens Simple or Advanced Distance Finder or creates a new calculation or clicks Reset 
	        		      	      			Routing Points button, the default settings should be taken from the user's Primary Profit Center.
	30/06/16		CR4435	AGL027			Handle regional settings issue with starting SECA logic
	20/07/16		CR4449	AGL027			Log main calls to atobviac engine (distance + calculate)
********************************************************************/

end subroutine

public function integer of_lockadvancedrp (mt_u_datawindow adw_advancedrp, string as_shortcode, boolean ab_locked, ref string as_retmsg);/********************************************************************
of_lockadvancedrp( /*mt_u_datawindow adw_advancedrp*/, /*string as_shortcode*/, /*boolean ab_locked*/, /*ref string as_retmsg */)

<DESC>
	from short code passed into function locate advanced routing point 
	values from engine and update the checkbox values accordingly.
	This function also handles constraint 'ASL'.  This has its own set
	of disabled/enabled advanced routing points.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> 0, X No action
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	adw_advancedrp
	as_shortcode
	ab_locked
	as_retmsg (not used)
</ARGS>
<USAGE>
	Used against all primary routing points and also ASL constraint.  It determines
	the state of the advanced routing points.
</USAGE>
********************************************************************/

string ls_advrplist, ls_advrp
integer li_activated, li_ischecked, li_state
long ll_pos, ll_advrpid, ll_advrpsumforcode, ll_foundrow, ll_advrprows

ll_advrprows = adw_advancedrp.rowcount()
ll_advrpsumforcode = GetNumCpRpSpForShortCode(as_shortcode)

if ll_advrpsumforcode > 0 then
	ls_advrplist = GetCpRpSpForPrimaryShortCode(as_shortcode) /* ls_advroutings is fixed length string, potentially muliple elements */
	ll_pos = 1
	do 
		ls_advrp = trim(mid(ls_advrplist,ll_pos,6))
		ll_advrpid = GetAdvancedRPIndexByName(ls_advrp)
		ll_foundrow = adw_advancedrp.find('abc_index=' + string(ll_advrpid), 1, ll_advrprows) /* locate index in advanced RP listing */
		if ll_foundrow > 0 then
			/* locating the disabled advanced routing points ok */
			if ab_locked then
				adw_advancedrp.setItem(ll_foundrow, "available", 2)
			else
				/* ASL overrride */
				if of_is_asl_advancedrp(ls_advrp) then
					li_state = 1
				else
					li_state = adw_advancedrp.getitemnumber(ll_foundrow,"is_checked")
				end if
				adw_advancedrp.setItem(ll_foundrow, "available", li_state)
			end if
		else
			as_retmsg = "cannot locate advanced routings {" + ls_advrplist + "} for primary rp " + as_shortcode /* currently not used */
			return c#return.NoAction
		end if
		ll_pos += 6
	loop while ll_pos <= len(ls_advrplist)	
end if

return c#return.Success
end function

public function integer of_getuseroutingpoint (integer al_abcindex);/* atobviac 2013 */
boolean lb_extretval
integer li_retval=0

if al_abcindex=-1 then
	return c#return.Failure
end if	

lb_extretval = GetUseRoutingPoint(al_abcindex)

if lb_extretval then
	li_retval=1
end if

return li_retval
end function

public function integer of_getroute (string as_portsequence[], ref mt_u_datawindow adw_route);/********************************************************************
   of_getroute
	
   <DESC> Calculate the distance between two ports </DESC>
   <RETURN> integer:
            1, X ok
            -1, X failed </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	as_portsequence[] :string array
	apo 					:powerobject, either a datastore or a datawindow
	
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	??/??/???? 							        		First Version
	26/11/15		CR3248	CCY018				Add ECA Areas in Route.
   </HISTORY>
********************************************************************/
string 		ls_old_str, ls_new_str, ls_error,  ls_route, ls_search_code
long    		ll_distance, ll_start_pos, ll_portPointer, ll_NumberOfPorts
long 			ll_row, ll_rows, ll_oldrows, ll_found, ll_imported_rows
char 			lc_delimit
long	 		ll_from_portID, ll_to_portID
string			ls_from_portname, ls_to_portname
decimal {2} 	ld_distance
boolean		lb_first_leg, lb_state_modified, lb_firstsecastate
integer li_seca_zone_state, li_start_state, li_prestate, li_inside_seca_count
mt_n_outgoingmail     lnv_mail

IncludeRouteDetail(false)
CodesInRoute(true)
lc_delimit = getroutedelimiter( )
ll_NumberOfPorts = upperBound(as_portsequence)
if ll_NumberOfPorts < 2 then
	MessageBox("Error", "Error getting route information. Cannot get route when there are less than 2 ports.")
	Return -1
end if

li_inside_seca_count = 0
lb_firstsecastate = false
ll_portPointer = 2
DO UNTIL ll_PortPointer > ll_NumberOfPorts

	FromPort(as_portsequence[ll_portPointer - 1])
	ToPort(as_portsequence[ll_portPointer])
	ll_Distance = Calculate()
	
	IF ll_Distance = 0 THEN
		if GetErrorCode() = 5 then
			/* from and to ports the same */
			ls_Route = as_portsequence[ll_portPointer - 1] + lc_delimit + as_portsequence[ll_portPointer]
		elseif getErrorCode( ) = 25 then
			/* No direct distance available, look into local table for distance (see later leg distance) */
			ls_Route = as_portsequence[ll_portPointer - 1] + lc_delimit + as_portsequence[ll_portPointer]
		elseif getErrorCode( ) = 0 then
			/* distance between ports is less than 0.5 miles  Changerequest # 969 */
			ls_Route = as_portsequence[ll_portPointer - 1] + lc_delimit + as_portsequence[ll_portPointer]
		else
			MessageBox("AtoBviaC Engine Error (n_atobviac.of_getroute)","The distance table engine was not able to find a distance between:~n~r~n~r"+&
								"FromPort~t~t= "+as_portsequence[ll_portPointer - 1]+"~n~r"+&
								"ToPort~t~t= "+as_portsequence[ll_portPointer]+"~n~r~n~r"+&
								"Error Code~t= " + String(GetErrorCode()) + "~n~r"+&
								"Message~t~t= " + GetErrorString()+ "~n~r~n~r")
			return -1
		end if
	ELSE
		// GetRoute
		// Returns the route used as a single string with each priciple rouitng point delimited
		//   from the next by the chosed RouteDelimiter
		ls_Route = GetRoute()
	END IF
	
	//get start seca state
	if  of_is_seca_enabled() then
		if len(ls_Route) > 0 and (ll_Distance <> 0 or (ll_Distance = 0 and getErrorCode() = 0)) then
			li_start_state = of_is_route_starting_inside_seca()
			if not lb_firstsecastate and as_portsequence[ll_portPointer - 1] = as_portsequence[1] then
				if li_start_state =c#return.Success then
					li_seca_zone_state = 1
				else
					li_seca_zone_state = -1
				end if
				lb_firstsecastate = true
			end if
			
			if li_start_state <> c#return.NoAction then li_inside_seca_count ++
		end if
	end if
	
	/* replace all delimiter with ~r~n */
	ll_start_pos=1
	ls_old_str = lc_delimit
	ls_new_str = "~r~n"
	// Find the first occurrence of old_str.
	ll_start_pos = Pos(ls_route, ls_old_str, ll_start_pos) 
	// Only enter the loop if you find old_str.
	DO WHILE ll_start_pos > 0
		 // Replace old_str with new_str.
		 ls_route = Replace(ls_route, ll_start_pos, Len(ls_old_str), ls_new_str)
		 // Find the next occurrence of old_str.
		 ll_start_pos = Pos(ls_route, ls_old_str, ll_start_pos+Len(ls_new_str))
	LOOP

	ll_oldrows = adw_route.rowCount()
	ll_imported_rows = adw_route.ImportString(ls_Route)
	if ll_oldRows > 0  then
		adw_route.deleteRow( ll_oldRows +1 )
	end if

//	ll_rows = adw_route.rowCount()
	If ll_oldRows > 0 then 
		lb_first_leg = true
	Else 
		lb_first_leg = false
	End if
	For ll_row = 1 to ll_imported_rows
		if getErrorCode( ) = 5 then
			/* Same port distance = 0 */
			adw_route.setItem(ll_oldrows + ll_row, "distance", 0)
		ElseIf getErrorCode( ) = 25 then
			If lb_first_leg then
				/* No direct distance. Look into local table. If no distance there, give message and set distance to 0 */
				
				// Get 'From' Port ID & Name
				ll_found = w_share.dw_sq_tb_cache_atobviacports.find("abc_portcode='"+as_portsequence[ll_portPointer - 1]+"'", 1, 999999)
				If ll_found > 0 then
					ll_from_portID =  w_share.dw_sq_tb_cache_atobviacports.getItemNumber(ll_found, "abc_portid")
					ls_from_portname =  w_share.dw_sq_tb_cache_atobviacports.getItemString(ll_found, "abc_portname")
				End if
				
				// Get 'To' Port ID & Name				
				ll_found = w_share.dw_sq_tb_cache_atobviacports.find("abc_portcode='"+as_portsequence[ll_portPointer]+"'", 1, 999999)
				If ll_found > 0 then
					ll_to_portID =  w_share.dw_sq_tb_cache_atobviacports.getItemNumber(ll_found, "abc_portid")
					ls_to_portname =  w_share.dw_sq_tb_cache_atobviacports.getItemString(ll_found, "abc_portname")
				End if
				
				SetNull(ld_distance)
				
				SELECT DISTANCE
					INTO :ld_distance 
					FROM LOCAL_ATOBVIAC_DISTANCE
					WHERE (FROM_PORTID = :ll_from_portID AND TO_PORTID = :ll_to_portID )
							OR (TO_PORTID = :ll_from_portID AND FROM_PORTID = :ll_to_portID )
					ORDER BY FROM_PORTID;
					
				If IsNull(ld_distance) then	  //  If no distance found

					If Messagebox("Distance Not Available", "The distance between the following two ports is not available:~n~nFrom Port:~t"+as_portsequence[ll_portPointer - 1]+"  "+ls_from_portname+"~nTo Port:~t~t"+as_portsequence[ll_portPointer]+"  "+ls_to_portname+"~n~nDo you want to send an automatic request for this distance?", Question!, YesNo!) = 1 then
				
						// Send automatic email to AtoBviaC
						lnv_Mail = Create mt_n_outgoingmail
						ls_Error = "Fail"
						String ls_MailBody					
						ls_MailBody = "Hello,~r~n~r~nPlease advise the following distance and update it in next release of the distance table:~r~n~r~n"
						ls_MailBody += as_portsequence[ll_portPointer - 1] + "-" + ls_from_portname + "     to     " + as_portsequence[ll_portPointer] + "-" + ls_to_portname + "~r~n~r~n" + "Thank you very much in advance." + "~r~n~r~n"
						ls_MailBody += "Best Regards~r~nTramos Development~r~nMaersk Tankers~r~n~r~nA.P. Moller - Maersk A/S~r~nEsplanaden 50~r~n1098 Copenhagen~r~nDenmark~r~nReg. No: 22 75 62 14~r~nTelephone: +45 3363 4083~r~nwww.maersktankers.com"
						If lnv_Mail.of_CreateMail(C#EMAIL.TRAMOSSUPPORT, "distances@atobviac.com", "New Distance Request", ls_MailBody, ls_Error) = 1 then
							lnv_Mail.of_addReceiver(C#EMAIL.TRAMOSSUPPORT, ls_Error)							
							If lnv_Mail.of_SendMail(ls_Error) > 0 then
								
								// Insert requested ports into Local table with zero distance
								Insert Into LOCAL_ATOBVIAC_DISTANCE (FROM_PORTID, TO_PORTID, DISTANCE, USERID)
									Values( :ll_From_PortID, :ll_To_PortID, 0.0, :uo_global.is_UserID);
								
								If SQLCA.SQLCode<0 then
									Rollback;
									Messagebox("Local Distance Error", "Unable to add requested distance to local distance table.~n~nPlease contact the system administrator.")
								Else
									Commit;								
								End If
					
								ls_Error = ""
	
								Messagebox("Request Generated", "An automated request for the distance has been generated. You will be notified when the distance is available.")
							End If
							
						Else
							ls_Error = ""							
						End If
					End If
					
					If ls_Error > "" then
						MessageBox("AtoBviaC Engine Error (n_atobviac.of_getroute)","The distance table engine was not able to find a distance between:~n~r~n~r"+&
							"FromPort~t~t= "+as_portsequence[ll_portPointer - 1]+"  "+ls_from_portname+"~n~r"+&
							"ToPort~t~t= "+as_portsequence[ll_portPointer]+"  "+ls_to_portname+"~n~r~n~r"+&
							"Error Code~t= " + String(GetErrorCode()) + "~n~r"+&
							"Message~t~t= " + GetErrorString()+ "~n~r~n~r"+&
							"Automated mail request failed. Please ask system administrator to request for the distance.")
					End If
					
					Destroy lnv_mail
					
					adw_route.setItem(ll_oldrows + ll_row, "distance", 0)
					
				ElseIf ld_distance = 0.0 then   // Distance is zero. This means a mail was already sent out
					Messagebox("Distance Not Available", "The distance between the following two ports is not presently available:"+&
						"~n~nFrom Port:~t"+as_portsequence[ll_portPointer - 1]+"  "+ls_from_portname+"~n~r"+&
   					"To Port:~t~t"+as_portsequence[ll_portPointer]+"  "+ls_to_portname+"~n~r"+&
						"~n~nA request for the distance has already been sent out. You will be notified when the distance is available.")
				Else
					adw_route.setItem(ll_oldrows + ll_row, "distance", ld_distance)
				End if
			else
				adw_route.setItem(ll_oldrows + ll_row, "distance", 0)
				if ll_oldRows > 0 then
					lb_first_leg = false
				else
					lb_first_leg = true
				end if
			end if
		else	
			if ll_oldRows > 0 then
				adw_route.setItem(ll_oldrows + ll_row, "distance", of_getLegDistance(ll_row))
			else
				adw_route.setItem(ll_oldrows + ll_row, "distance", of_getLegDistance(ll_row -1))
			end if
		end if
	next
	ll_portPointer ++
LOOP

/* Now add port names to route */
ll_rows = adw_route.rowCount()

for ll_row = ll_rows to 1 step -1
	 ls_search_code = adw_route.getItemString(ll_row, "portcode")
	 ll_found = w_share.dw_sq_tb_cache_atobviacports.find("abc_portcode='"+ls_search_code+"'", 1, 999999)
	 if ll_found > 0 then
		adw_route.setItem(ll_row, "portname", w_share.dw_sq_tb_cache_atobviacports.getItemString(ll_found, "abc_portname"))
	end if
next

//Deal with SECA zone
if of_is_seca_enabled() then
	lb_state_modified = false
	
	if li_inside_seca_count > 0 then
		for ll_row = 1 to ll_rows
			ls_search_code = adw_route.getitemstring(ll_row, "portcode")
			
			li_seca_zone_state = of_get_seca_state_for_row(ls_search_code, li_seca_zone_state, lb_state_modified)
			
			if lb_state_modified then
				if pos(lower(ls_search_code), "secascanner", 1) > 0 then adw_route.setitem(ll_row, "portname", replace(ls_search_code, 1, 11, "ECA"))
			end if
				
			if (li_seca_zone_state = 1 and not lb_state_modified) or (li_seca_zone_state = -1 and lb_state_modified) &
			or (li_seca_zone_state = 1 and li_prestate = 1 and lb_state_modified) then
				ld_distance = adw_route.getitemnumber(ll_row, "distance")
				adw_route.setitem(ll_row, "eca", 1)
				adw_route.setitem(ll_row, "eca_distance", ld_distance)
			end if
			
			li_prestate = li_seca_zone_state
		next
	end if
end if

return 1

end function

public function decimal of_getporttoportdistance (string as_fromport, ref string as_toport, string as_beginport, string as_endport);/********************************************************************
   of_getporttoportdistance
   <DESC>  </DESC>
   <RETURN> decimal:
            The distance between two ports </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	24/09/2013 CR2790       WWA048        		First Version
		20/07/2016	CR4449		AGL027				Added logging of AtoBviaC requests to local engine
   </HISTORY>
********************************************************************/

long		ll_pos, ll_from_found, ll_to_found
long		ll_row, ll_loop, ll_count
string	ls_delimiter, ls_route, ls_port
decimal	ld_distance
boolean	lb_active

mt_n_datastore		lds_route

n_object_usage_log lnv_uselog
lnv_uselog.uf_log_object("atobviac_distance(1)")

if not of_gettableopen() then
	of_opentable()
	of_resettodefaultstate()
end if

//Active all the Primary Routing Points
lb_active = GetUseKielCanal()
if not lb_active then
	UseKielCanal(true)
	post UseKielCanal(false)
end if

lb_active = GetUseSuezCanal()
if not lb_active then
	UseSuezCanal(true)
	post UseSuezCanal(false)
end if

lb_active = GetUsePanamaCanal()
if not lb_active then
	UsePanamaCanal(true)
	post UsePanamaCanal(false)
end if

lb_active = GetUseCorinthCanal()
if not lb_active then
	UseCorinthCanal(true)
	post UseCorinthCanal(false)
end if

lb_active = GetUseDoverStrait()
if not lb_active then
	UseDoverStrait(true)
	post UseDoverStrait(false)
end if

lb_active = GetUseSingaporeStrait()
if not lb_active then
	UseSingaporeStrait(true)
	post UseSingaporeStrait(false)
end if

lb_active = GetUseSundaStrait()
if not lb_active then
	UseSundaStrait(true)
	post UseSundaStrait(false)
end if

lb_active = GetUseLombokStrait()
if not lb_active then
	UseLombokStrait(true)
	post UseLombokStrait(false)
end if

lb_active = GetUseMagellanStrait()
if not lb_active then
	UseMagellanStrait(true)
	post UseMagellanStrait(false)
end if

lb_active = GetUseBonifacioStrait()
if not lb_active then
	UseBonifacioStrait(true)
	post UseBonifacioStrait(false)
end if

lb_active = GetUseMessinaStrait()
if not lb_active then
	UseMessinaStrait(true)
	post UseMessinaStrait(false)
end if

lb_active = GetUseThursdayIsland()
if not lb_active then
	UseThursdayIsland(true)
	post UseThursdayIsland(false)
end if

lb_active = GetUseCapeofGoodHope()
if not lb_active then
	UseCapeofGoodHope(true)
	post UseCapeofGoodHope(false)
end if

lb_active = GetUseCapeHorn()
if not lb_active then
	UseCapeHorn(true)
	post UseCapeHorn(false)
end if

lb_active = GetUseBahamaChannel()
if not lb_active then
	UseBahamaChannel(true)
	post UseBahamaChannel(false)
end if

lb_active = GetUseWofTaiwan()
if not lb_active then
	UseWofTaiwan(true)
	post UseWofTaiwan(false)
end if

includeroutedetail(false)
codesinroute(true)

fromport(as_beginport)
toport(as_endport)

if calculate() > 0 then
	ls_delimiter = getroutedelimiter()
	ls_route = getroute() + ls_delimiter
	
	lds_route = create mt_n_datastore
	lds_route.dataobject = "d_ex_tb_route"
	
	ll_pos = pos(ls_route, ls_delimiter)
	do while ll_pos > 0
		ls_port = trim(left(ls_route, ll_pos - 1))
		ls_route = trim(mid(ls_route, ll_pos + len(ls_delimiter)))
		ll_pos = pos(ls_route, ls_delimiter)
		
		if ls_port <> "" then
			ll_row = lds_route.insertrow(0)
			lds_route.setitem(ll_row, "portcode", ls_port)
			lds_route.setitem(ll_row, "distance", of_getlegdistance(ll_row - 1))
		end if
	loop

	ll_count = lds_route.rowcount()
	ll_from_found = lds_route.find("portcode = '" + as_fromport + "'", 1, ll_count)
	ll_to_found = lds_route.find("portcode = '" + as_toport + "'", 1, ll_count)
	
	if ll_from_found > 0 and ll_to_found > 0 then
		for ll_loop = ll_from_found + 1 to ll_to_found
			ld_distance += lds_route.getitemdecimal(ll_loop, "distance")
		next
	end if
	
	destroy lds_route
end if

return ld_distance

end function

public function integer of_getadvancedrpstateall (mt_u_datawindow adw_primaryrp, ref mt_u_datawindow adw_advancedrp, boolean ab_useengineforstate);/* atobviac 2013 */
long ll_primaryrprows, ll_advancedrprows, ll_row
integer li_activated, li_checked
string ls_shortname, ls_message , ls_routingpoint
boolean lb_activated

/* reset all advanced RP checkboxes */
ll_advancedrprows = adw_advancedrp.rowcount()
for ll_row = 1 to ll_advancedrprows
	adw_advancedrp.setitem(ll_row,"available",1)
next

/* lastly disable any determined by primary RP */
ll_primaryrprows = adw_primaryrp.rowcount()
for ll_row = 1 to ll_primaryrprows
	ls_shortname = adw_primaryrp.getitemstring(ll_row,"primaryrpshortname")
	li_activated = adw_primaryrp.getitemnumber(ll_row,"active")
	// reverse 
	if li_activated = 1 then lb_activated = false else lb_activated = true 
	of_lockadvancedrp(adw_advancedrp,ls_shortname,lb_activated,ls_message)
next

/* next get the checked state from the engine for each enabled advanced RP */
for ll_row = 1 to ll_advancedrprows
	if adw_advancedrp.getitemnumber(ll_row, "available") = 2 then	
		li_activated = 2	
	else	
		if ab_useengineforstate then
			li_activated = of_getuseroutingpoint(adw_advancedrp.getitemnumber(ll_row, "abc_index"))
		else
			li_activated = adw_advancedrp.getitemnumber(ll_row, "defaultvalue")
		end if
	end if	

	if ab_useengineforstate then
		li_checked = of_getuseroutingpoint(adw_advancedrp.getitemnumber(ll_row, "abc_index"))
	else
		li_checked = adw_advancedrp.getitemnumber(ll_row, "defaultvalue")
	end if

	if li_activated<>c#return.Failure then
		adw_advancedrp.setitem(ll_row,"available",li_activated)
		adw_advancedrp.setitem(ll_row,"is_checked",li_checked)
		ls_routingpoint = adw_advancedrp.getitemstring(ll_row, "routingPointCode")
		gnv_AtoBviaC.of_UseRoutingPointByName(ls_routingpoint, li_activated=1 )
	end if	
next

adw_advancedrp.ResetUpdate()
return c#return.Success
end function

public function boolean of_is_asl_advancedrp (string as_routingpoint);/* ASL force checked state */
if as_routingpoint="RP9993" or as_routingpoint="RP9995" or as_routingpoint="RP9998" or as_routingpoint="SP0700" then
	return true
end if
return false
end function

public function integer of_is_route_starting_inside_seca ();/********************************************************************
of_is_route_starting_inside_seca()

<DESC>
	validates if route already commences inside a SECA zone or not
</DESC>
<RETURN> 
	Integer:
		<LI> 1, Yes route begins inside a SECA zone
		<LI> 0, Route does not include any SECA zones
		<LI> -1, No route does not begin inside a SECA zone, but route does include SECA zones
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
mt_n_stringfunctions 	lnv_str
string ls_seca_data[], ls_seca_delimited_string

ls_seca_delimited_string = of_get_seca_mileages()

/* 
CR4435 - handle unexpected regional settings  

seca_mileages string might contain thousand seperator which confuses, but the code is valid as it checks against 0#00 values 
 
so if result from atobvia c is: 									0,00|0,00|428,24|1.255,52|0,00|0,00|0,00|0,00|1.683,77
after of_replaceall() is called the result will be:		0.00|0.00|428.24|1.255.52|0.00|0.00|0.00|0.00|1.683.77
*/

ls_seca_delimited_string = lnv_str.of_replaceall(ls_seca_delimited_string, ",", ".", false)

lnv_str.of_parsetoarray(ls_seca_delimited_string, "|", ls_seca_data)

if ls_seca_data[1] = "0.00" then
	if ls_seca_data[upperbound(ls_seca_data)] = "0.00" then
		return c#return.NoAction
	else
		return c#return.Success
	end if	
else 
	return c#return.Failure
end if
end function

public function decimal of_total_seca_distance_in_route ();/********************************************************************
of_total_seca_distance_in_route()

<DESC>
	find total SECA distance
</DESC>
<RETURN> 
	Decimal:
		<LI> Total distance inside SECA
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	Currently not used.  
	Possible limitation - Keep in mind regional number formatting if intending to use this function.
</USAGE>
********************************************************************/
mt_n_stringfunctions 	lnv_str
string ls_seca_data[], ls_value
decimal{4} ld_distance

lnv_str.of_parsetoarray(of_get_seca_mileages(), "|", ls_seca_data)
ld_distance = dec(ls_seca_data[upperbound(ls_seca_data)])

return ld_distance
end function

public function integer of_get_seca_state_for_row (string as_port_code, integer ai_previous_state, ref boolean ab_modified);/********************************************************************
of_get_seca_state_for_row()

<DESC>
	designed to assist within code the processing of rows in order first to last in datastore/datawindow to
	obtain state (inside/outside SECA zone)
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X -1 inside SECA zone
		<LI> -1, X outside SECA zone
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_port_name - either an actual port name or SECA entry/exit
	ai_previous_state; 1 if last port was inside, -1 if last port was outside SECA
	ab_modified - boolean; if new state is different to previous state then return true else false
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

integer li_exit=0, li_enter=0, li_exit_enter

ab_modified = false
li_exit = pos(lower(as_port_code),"secascanner - exit",1)
li_enter = pos(lower(as_port_code),"secascanner - enter",1)

if li_exit=0 and li_enter=0 then
	/* no adjustment so return previous state as current */
	return ai_previous_state
else
	ab_modified = true
	if li_exit>0 then	
		/* exit active SECA zone */
		li_exit_enter = pos(lower(as_port_code),"enter ", len("secascanner - exit") + 1)
		if li_exit_enter > 0 then
			return 1
		else
			return -1
		end if
	else
		/* enter a new SECA zone */
		return 1
	end if
end if	
end function

public subroutine of_set_seca (boolean ab_enabled);/********************************************************************
of_set_seca() 

<DESC>
	Enables/Disables the scanning of seca zones when route is requested from atobviac engine
</DESC>
<RETURN> 
	n/ab_enabled
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	ab_enabled: turn off/on feature
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
SetScanForSecaZones(ab_enabled)
end subroutine

public function boolean of_is_seca_enabled ();/********************************************************************
of_is_seca_enabled() 

<DESC>
	Returns state of SECA scanning from atobviac engine
</DESC>
<RETURN> 
	boolean enabled/disabled
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
return GetScanForSecaZones()
end function

public function string of_get_seca_mileages ();/********************************************************************
of_get_seca_mileages() 

<DESC>
	obtain string of seca data for current route inside engine
</DESC>
<RETURN> 
	String:
		Pipe delimited text, ie: 0.00|0.00|428.24|1,255.52|0.00|0.00|0.00|0.00|1,683.77
		
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	Used by of_is_route_starting_inside_seca() and of_total_seca_distance_in_route()
</USAGE>
********************************************************************/

return GetSecaMileages()
end function

public function long of_opentable (string as_abctablepath);/********************************************************************
of_opentable( /*string as_abctablepath */) 

<DESC>
	created so that server applications do not have to be dependent upon
	same path constraints the Tramos client has.  
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_abctablepath: file path where BPSTables.bin resides
</ARGS>
<USAGE>
	Usage of this function
	can be found in AXEstimates.
</USAGE>
********************************************************************/
string ls_path
long	ll_startPosition

ls_path = as_abctablepath

_addmessage( this.classdefinition, "of_opentable()","Requesting Access to AtoBviaC engine and Distance Table located in folder '" + ls_path + "'" , "Request to AtoBviaC")

if ls_path = "" then
	_addmessage( this.classdefinition, "of_opentable()","Path for AtoBviaC distance table not given. Please correct and try again" , "Missing table")
	return -1
end if

if right(ls_path,1) <> "\" then ls_path += "\"

ls_path = ls_path + "BPSTables.bin"

/* Check if file exists */
if NOT fileExists(ls_path) then
	_addmessage( this.classdefinition, "of_opentable()","Distance Table File '" + ls_path + "' not found! Given path: "+ls_path+".  Path for AtoBviaC distance table not correct. Please correct in system options and try again" , "Missing table")
	return -1
end if

SetTableName( ls_path) 

if OpenTables() = 0 then 
	_addmessage( this.classdefinition, "of_opentable()","Request for Access to AtoBviaC engine granted." , "Request to AtoBviaC")
	ib_tableOpen = true
	Return 0
else
	_addmessage( this.classdefinition, "of_opentable()","Error Requesting Access to AtoBviaC engine." , "Request to AtoBviaC")
	Return 1
end if

end function

public subroutine of_newmap ();/********************************************************************
   of_newmap
   <DESC>Clears the current map inside the engine. </DESC>
   <RETURN>	(None):
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

NewMap()
end subroutine

public subroutine of_plotroutetomap ();/********************************************************************
   of_plotroutetomap
   <DESC>Will plot the current route on the map.  Should not be called until a distance has successfully been calculated.  
	</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

PlotRouteToMap()
end subroutine

public function long of_getmap ();/********************************************************************
   of_getmap
   <DESC>Returns a HANDLE to a Windows Bitmap representing the current map</DESC>
   <RETURN>
	 long: A HANDLE to a Windows Bitmap
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

return GetMap()
end function

public subroutine of_setmaplevel (integer ai_level);/********************************************************************
   of_setmaplevel
   <DESC>Used to Set the current MapLevel which determines the size of the map.</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_level: MapLevel
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

SetMapLevel(ai_level)
end subroutine

public function long of_getmapwidth ();/********************************************************************
   of_getmapwidth
   <DESC>Returns the width of the current Map in pixels</DESC>
   <RETURN>long</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version
   </HISTORY>
********************************************************************/

return GetMapWidth()
end function

public function long of_getmapheight ();/********************************************************************
   of_getmapheight
   <DESC>Returns the height of the current Map in pixels</DESC>
   <RETURN>	long</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

return GetMapHeight()
end function

public subroutine of_setshowpiracyareasonmap (boolean ab_show);/********************************************************************
   of_setshowpiracyareasonmap
   <DESC>Set true if the requested map is to include the Piracy Areas overlay</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_show
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

SetShowPiracyAreasOnMap(ab_show)
end subroutine

public subroutine of_setshowsecazonesonmap (boolean ab_show);/********************************************************************
   of_setshowsecazonesonmap
   <DESC>Set true if the requested map is to include the Piracy Areas overlay</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_show
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

SetShowSecaZonesOnMap(ab_show)
end subroutine

public subroutine of_plotposition (decimal ad_latitude, decimal ad_longitude, string as_portname);/********************************************************************
   of_plotposition
   <DESC>	Will plot the 'Name' on the current map at the Latitude and Longitude passed.	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ad_latitude
		ad_longitude
		as_portname
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05/04/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

PlotPosition(ad_latitude, ad_longitude, as_portname)
end subroutine

public function integer of_getprimaryrpstateall (ref mt_u_datawindow adw, boolean ab_useengineforstate);long ll_rows, ll_row
boolean lb_active

ll_rows = adw.rowCount()

if ab_useengineforstate then
	for ll_row = 1 to ll_rows
		choose case adw.getItemString(ll_row, "PrimaryRPName")
			case "Kiel Canal"
				lb_active = GetUseKielCanal()
			case "Suez Canal"
				lb_active = GetUseSuezCanal()
			case "Panama Canal"
				lb_active = GetUsePanamaCanal()
			case "Corinth Canal"
				lb_active = GetUseCorinthCanal()
			case "Dover Strait"
				lb_active = GetUseDoverStrait()
			case "Singapore Strait"
				lb_active = getusesingaporeStrait()
			case "Sunda Strait"
				lb_active = GetUseSundaStrait()
			case "Lombok Strait"
				lb_active = GetUseLombokStrait()
			case "Magellan Strait"
				lb_active = GetUseMagellanStrait()
			case "Bonifacio Strait"
				lb_active = GetUseBonifacioStrait()
			case "Messina Strait"
				lb_active = GetUseMessinaStrait()
			case "Thursday Island"
				lb_active = GetUseThursdayIsland()
			case "Cape of Good Hope"
				lb_active = GetUseCapeofGoodHope()
			case "Cape Horn"
				lb_active = GetUseCapeHorn()
			case "Bahama Channel"
				lb_active = GetUseBahamaChannel()
			case "West of Taiwan"
				lb_active = GetUseWofTaiwan()
		end choose
		if lb_active then
			adw.setItem(ll_row, "active", 1)
		else
			adw.setItem(ll_row, "active", 0)
		end if
	next
else
	for ll_row = 1 to ll_rows
		adw.setitem(ll_row, "active", adw.getitemnumber(ll_row, "defaultvalue"))
	next
	
	of_setprimaryrpstateall(adw)
end if
return 1
end function

public subroutine of_defaulrpfrompc (mt_u_datawindow adw_primaryroute, mt_u_datawindow adw_advancedroute, long al_pcnr);/********************************************************************
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
		11/04/16		CR3767		XSZ004		First Version
   </HISTORY>
********************************************************************/

int  li_cnt, li_defaultvalue, li_findrow
string abc_portcode
mt_n_datastore lds_route

adw_primaryroute.setredraw(false)
adw_advancedroute.setredraw(false)

if al_pcnr < 1 then
	for li_cnt = 1 to adw_primaryroute.rowcount()
		adw_primaryroute.setitem(li_cnt, "defaultvalue", 1)
	next	
	
	for li_cnt = 1 to adw_advancedroute.rowcount()
		adw_advancedroute.setitem(li_cnt, "defaultvalue", 1)
	next
else
	
	lds_route = create mt_n_datastore
	lds_route.dataobject = "d_sq_gr_primaryroute"
	lds_route.settransobject(sqlca)
	lds_route.retrieve(al_pcnr)
	
	for li_cnt = 1 to lds_route.rowcount()
		abc_portcode    = lds_route.getitemstring(li_cnt, "abc_portcode")
		li_defaultvalue = lds_route.getitemnumber(li_cnt, "rp_defaultvalue")
		
		li_findrow = adw_primaryroute.find("primaryrpname = '" + abc_portcode + "'", 1, adw_primaryroute.rowcount())
		
		if li_findrow > 0 then
			adw_primaryroute.setitem(li_findrow, "defaultvalue", li_defaultvalue)
		end if
		
	next	
	
	lds_route.dataobject = "d_sq_gr_pcroute"
	lds_route.settransobject(sqlca)
	lds_route.retrieve(al_pcnr)
	
	for li_cnt = 1 to lds_route.rowcount()
		abc_portcode    = lds_route.getitemstring(li_cnt, "pc_routing_defaults_abc_portcode")
		li_defaultvalue = lds_route.getitemnumber(li_cnt, "pc_routing_defaults_rp_defaultvalue")
		
		li_findrow = adw_advancedroute.find("routingpointcode = '" + abc_portcode + "'", 1, adw_advancedroute.rowcount())
		
		if li_findrow > 0 then
			adw_advancedroute.setitem(li_findrow, "defaultvalue", li_defaultvalue)
		end if
	next	

	destroy lds_route
end if

adw_primaryroute.setredraw(true)
adw_advancedroute.setredraw(true)
end subroutine

public subroutine of_resettodefaultstate (long al_pcnr);mt_n_datastore	lds_rp
long ll_rows, ll_row

/* Call to reset all Routing Options back to default  */
ResetToDefaultState()

/* Reset Advanced routing points controlled by user */
lds_rp = create mt_n_datastore
lds_rp.dataObject = "d_advanced_rp_default"
lds_rp.setTransObject(sqlca)

ll_rows = lds_rp.retrieve(al_pcnr)

for ll_row = 1 to ll_rows
	useRoutingPointByName( lds_rp.getItemString(ll_row, "abc_portcode"), false)
next

destroy lds_rp 
end subroutine

on n_atobviac.create
call super::create
end on

on n_atobviac.destroy
call super::destroy
end on

