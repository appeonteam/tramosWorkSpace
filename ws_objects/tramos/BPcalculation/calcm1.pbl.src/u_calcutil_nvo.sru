$PBExportHeader$u_calcutil_nvo.sru
$PBExportComments$Wrapper NVO, this is loaded together w. a calculation
forward
global type u_calcutil_nvo from mt_n_nonvisualobject
end type
type s_viapoint from structure within u_calcutil_nvo
end type
type s_calc_est_link from structure within u_calcutil_nvo
end type
end forward

type s_viapoint from structure
    string s_long
    string s_short
end type

type s_calc_est_link from structure
    string s_portcode
    long l_calc_id
    long l_est_id
    integer i_itinerary_number
end type

global type u_calcutil_nvo from mt_n_nonvisualobject
end type
global u_calcutil_nvo u_calcutil_nvo

type prototypes

end prototypes

type variables
String is_error
s_speed istr_speedlist[]
u_calc_cargos iuo_calc_cargos
u_calc_summary iuo_calc_summary
u_calc_itinerary iuo_calc_itinerary
u_calculation iuo_calculation
Private String is_from, is_to
Private Integer ii_errorcode
s_calc_vessel_data istr_calc_vessel_data
Private boolean ib_bproute_ok
Public u_log iuo_log
//Public s_calc_est_link istr_calc_est_links[]  ** ændret ved konvertering til PB10 **
Private s_calc_est_link istr_calc_est_links[]
end variables

forward prototypes
public function string uf_portcode_to_name (string as_portcode)
public function integer uf_distance (string as_from, string as_to)
public function boolean uf_port_to_unctad (ref string as_port)
public function string uf_distance_error ()
public function boolean uf_get_vessel_data (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id)
public subroutine uf_get_viapoints (ref string as_viapoints[])
public function boolean uf_create_calc_est_links (long al_calc_id)
public function string uf_getroute (boolean ab_return_as_code)
end prototypes

public function string uf_portcode_to_name (string as_portcode);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 01-10-96

 Description : Converts portcode to portname, by looking in the dw_calc_port_dddw in 
 					the w_share window (datastore).

					** Average searchspeed using dw_calc_port_dddw is approx. the same 
					as embedded SQL, but does not perform any network traffic.

 Arguments : AS_PORTCODE as string

 Returns   : Portname as string (if found), otherwise the portcode

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-10-96		1.0			MI		Initial version
  
************************************************************************************/

Long ll_tmp

// Look the portcode up in the shared port datawindow. If the row is found, then
// return the portname from that row. Otherwise return the portcode

ll_tmp = w_share.dw_calc_port_dddw.Find("port_code = '"+as_portcode+"'", 1, 999999)
If ll_tmp > 0 Then 
	Return(w_share.dw_calc_port_dddw.GetItemString(ll_tmp, "port_n")) 
Else 
	Return(as_portcode)
End if

end function

public function integer uf_distance (string as_from, string as_to);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 01-10-96

 Description : Returns the distance between two points. Checks first the TRAMOS 
 					distance table, and if not found here the BP table is searched

 Arguments : AS_FROM, AS_TO as string

 Returns   : Distance as integer, or errorcode if <0

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_dist

ib_bproute_ok = false

// If from = to then just return zero as distance
If as_from = as_to  Then Return(0) 

// Remember the from and to port in the IS_FROM and IS_TO instance variables
// since these are used by some of the other U_CALCUTIL_NVO functions
is_from = as_from
is_to = as_to

// Check first if the distance is found in our own (TRAMOS) distancetable
SELECT CAL_DIST_DISTANCE
INTO :li_dist
FROM CALC_DIST
WHERE (((CAL_DIST_FROM = :as_from) AND 
		(CAL_DIST_TO = :as_to)) OR
		((CAL_DIST_FROM = :as_to) AND
		(CAL_DIST_TO = :as_from)))  ;

If SQLCA.SQLCode = 100 Then
	// The distance was not found in TRAMOS' distancetable, now check
	// the BP distance table. Convert the portnames to UNCTAD codes before
	// calling the BP distancetable

	If not uf_port_to_UNCTAD(as_from) Then
		li_dist = -10 // Return that FROM port didn't have an UNCTAD entry
	Else
	 	If not uf_port_to_UNCTAD(as_to) Then
			li_dist = -11 // Return that TO port didn't have an UNCTAD entry
		Else
			li_dist = guo_bpdistance.uf_distance(as_from,as_to)
			ib_bproute_ok = true
		End if
	End if
End if

COMMIT;

// LI_DIST is used to return errorcodes (if negative) or distance (if positive).
// If an error happend, then set the ii_errorcode variable to the LI_DIST value
If li_dist < 0 Then ii_errorcode = li_dist else ii_errorcode = 0

// and return the distance (or errorcode)
Return(li_dist)



end function

public function boolean uf_port_to_unctad (ref string as_port);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 30-9-96

 Description : Converts the port code given in AS_PORT to UNCTAD code. The UNCTAD
 					code is also returned in AS_PORT

 Arguments : AS_PORT as string REF

 Returns   : True if ok  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
28-2-97		4.0			MI		Changed rutine to work on shared dddw  
************************************************************************************/

String ls_tmp
Long ll_tmp

// Find the portcode AS_PORT in the shared port window. If found, then take
// the UNCTAD code from the returned row number
ll_tmp = w_share.dw_calc_port_dddw.Find("PORT_CODE='"+as_port+"'",1,999999)
If ll_tmp > 0 Then &
	ls_tmp = w_share.dw_calc_port_dddw.GetItemString(ll_tmp, "PORT_UNCTAD")

If Not(IsNull(ls_tmp)) Then as_port = ls_tmp

// Return true if the UNCTAD code is 5 char's long (rather then the initial
// portcode in AS_PORT, that's only 3 char's long
Return(Len(as_port)=5)

end function

public function string uf_distance_error ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the string for the last distance error

 Arguments : None

 Returns   : Errortext as string  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

CHOOSE CASE ii_errorcode
	CASE -1
		Return "UNCTAD codes are iilegal"
	CASE -2
		Return "Ports are the same"
	CASE -3
		Return "BPSDISTS.DAT has not been opened"
	CASE -4
		Return "FROM port ("+uf_portcode_to_name(is_from)+") not found in distancetable"
	CASE -5
		Return "TO port ("+uf_portcode_to_name(is_to)+") not found in distancetable"
	CASE -6
		Return "Distance NVO not correctly loaded"
	CASE -10
		Return "No UNCTAD code defined for port "+uf_portcode_to_name(is_from)
	CASE -11
		Return "No UNCTAD code defined for port "+uf_portcode_to_name(is_to)
	CASE ELSE
		Return "Errorcode "+String(ii_errorcode)
END CHOOSE

end function

public function boolean uf_get_vessel_data (long al_vessel_type_id, long al_vessel_id, long al_clarkson_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns various data about the vessel given in either
 					AL_VESSEL_TYPE_ID, AL_VESSEL_ID or AL_CLARKSON_ID. Only one
					of the vessel_ID's must be valid. Returned data is stored
					ISTR_CALC_VESSEL_DATA. 
 					
 Arguments : AL_VESSEL_TYPE_ID, AL_VESSEL_ID, AL_CLARKSON_ID as long

 Returns   : True if ok.  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_vessel_type_id
Boolean lb_result, lb_get_type_data

SetNull(ll_vessel_type_id)

// The LB_GET_TYPE_DATA is a boolean, which is set to true when retrieving
// CLARKSON or VESSEL data (not VESSEL_TYPE data). If it's true all NULL fields
// which can be "inherited" from the VESSEL_TYPE table, will be re-retrieved
// from the VESSEL_TYPE table.
lb_get_type_data = false

// Select data from the CLARKSON table into the ISTR_CALC_VESSEL_DATA structur
// if AL_CLARKSON_ID is not null
If Not(isnull(al_clarkson_id)) Then
	SELECT CAL_FO_PRICE,
		CAL_DO_PRICE,
		CAL_MGO_PRICE,
		CAL_VEST_TYPE_ID,
		CAL_CLRK_NAME,
		CAL_DRC,
		CAL_OA,
		CAL_CAP,
		CAL_TC,
		CAL_CLRK_DWT,
		CAL_CLRK_BUDGET_COMM
	INTO :istr_calc_vessel_data.d_fo_price ,
		:istr_calc_vessel_data.d_do_price ,
		:istr_calc_vessel_data.d_mgo_price ,
		:ll_vessel_type_id,
		:istr_calc_vessel_data.s_name,
		:istr_calc_vessel_data.d_drc,
		:istr_calc_vessel_data.d_oa,
		:istr_calc_vessel_data.d_cap,
		:istr_calc_vessel_data.d_tc,
		:istr_calc_vessel_data.d_sdwt,
		:istr_calc_vessel_data.d_budgetcomm
	FROM CAL_CLAR
	WHERE CAL_CLRK_ID = :al_clarkson_id;

	lb_get_type_data = true		

	// Set the result depending on the SQLCode
	lb_result = SQLCA.SQLCode = 0
Elseif not (isnull(al_vessel_type_id)) Then
// Select data from the VESSEL_TYPE table into the ISTR_CALC_VESSEL_DATA structur
// if AL_VESSEL_TYPE_ID is not null

	SELECT CAL_FO_PRICE,
		CAL_DO_PRICE,
		CAL_MGO_PRICE,
		CAL_VEST_TYPE_NAME,
		CAL_DRC,
		CAL_OA,
		CAL_CAP,
		CAL_TC,
		CAL_SDWT,
		CAL_VEST_BUDGET_COMM
	INTO :istr_calc_vessel_data.d_fo_price ,
		:istr_calc_vessel_data.d_do_price ,
		:istr_calc_vessel_data.d_mgo_price ,
		:istr_calc_vessel_data.s_name,
		:istr_calc_vessel_data.d_drc,
		:istr_calc_vessel_data.d_oa,
		:istr_calc_vessel_data.d_cap,
		:istr_calc_vessel_data.d_tc,
		:istr_calc_vessel_data.d_sdwt,
		:istr_calc_vessel_data.d_budgetcomm
	FROM CAL_VEST
	WHERE CAL_VEST_TYPE_ID = :al_vessel_type_id;

	// Set the result depending on the SQLCode
	lb_result = SQLCA.SQLCode = 0

Elseif not isnull(al_vessel_id) Then
// Select data from the VESSEL table into the ISTR_CALC_VESSEL_DATA structur
// if AL_VESSEL_ID is not null
	istr_calc_vessel_data.b_apmvessel = True

	SELECT CAL_FO_PRICE,
		CAL_DO_PRICE,
		CAL_MGO_PRICE,
		CAL_VEST_TYPE_ID,
		VESSEL_NAME,
		CAL_DRC,
		CAL_OA,
		CAL_CAP,
		CAL_TC,
		CAL_SDWT,
		PC_NR,
		BUDGET_COMM
	INTO :istr_calc_vessel_data.d_fo_price ,
		:istr_calc_vessel_data.d_do_price ,
		:istr_calc_vessel_data.d_mgo_price ,
		:ll_vessel_type_id,
		:istr_calc_vessel_data.s_name,
		:istr_calc_vessel_data.d_drc,
		:istr_calc_vessel_data.d_oa,
		:istr_calc_vessel_data.d_cap,
		:istr_calc_vessel_data.d_tc,
		:istr_calc_vessel_data.d_sdwt,
		:istr_calc_vessel_data.i_pcnr,
		:istr_calc_vessel_data.d_budgetcomm
	FROM VESSELS
	WHERE VESSEL_NR = :al_vessel_id;

	lb_get_type_data = True		// Get data from vessel type table

	// Set the result depending on the SQLCode
	lb_result = SQLCA.SQLCode = 0
End if

// If LB_GET_TYPE_DATA, and one of the "inherited" fields is NULL, then retrieve
// the value from the CAL_VEST (vessel type) table.
If lb_get_type_data Then
	If not IsNull(ll_vessel_type_id) Then
		If IsNull(istr_calc_vessel_data.d_fo_price) or (istr_calc_vessel_data.d_fo_price = 0) Then 
			SELECT CAL_FO_PRICE				
			INTO :istr_calc_vessel_data.d_fo_price
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_do_price) Then 
			SELECT CAL_DO_PRICE				
			INTO :istr_calc_vessel_data.d_do_price
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_mgo_price) Then 
			SELECT CAL_MGO_PRICE				
			INTO :istr_calc_vessel_data.d_mgo_price
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_drc) Then 
			SELECT CAL_DRC
			INTO :istr_calc_vessel_data.d_drc
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_oa) Then 
			SELECT CAL_OA
			INTO :istr_calc_vessel_data.d_oa
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_cap) Then 
			SELECT CAL_CAP
			INTO :istr_calc_vessel_data.d_cap
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_tc) Then 
			SELECT CAL_TC
			INTO :istr_calc_vessel_data.d_tc
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_sdwt) Then 
			SELECT CAL_SDWT
			INTO :istr_calc_vessel_data.d_sdwt
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

		If IsNull(istr_calc_vessel_data.d_budgetcomm) Then 
			SELECT CAL_VEST_BUDGET_COMM
			INTO :istr_calc_vessel_data.d_budgetcomm
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_vessel_type_id;
		End if

	End if
End if

COMMIT;

// If the FUEL price is NULL then set it to zero instead
If IsNull(istr_calc_vessel_data.d_fo_price) Then istr_calc_vessel_data.d_fo_price = 0
If IsNull(istr_calc_vessel_data.d_do_price) Then istr_calc_vessel_data.d_do_price = 0
If IsNull(istr_calc_vessel_data.d_mgo_price) Then istr_calc_vessel_data.d_mgo_price = 0

// Return the result
Return(lb_result)
end function

public subroutine uf_get_viapoints (ref string as_viapoints[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the viapoints for a given route in the AS_VIAPOINTS array.
 					UF_DISTANCE must be	called prior to calling this function

 Arguments : AS_VIAPOINTS[] as REF Stringarray

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Char lstr_route[256]
String ls_portcode
Integer li_max, li_count, li_resultcount
Long ll_row

// If route hasn't been calculated (by calling UF_DISTANCE) then return
If not ib_bproute_ok Then Return

// Call the UF_GETROUTE from the BP DISTANCE table. This will return an 
// string consisting of viapoint code values (see the BP distance documentation
// and the "Tramos Developer's Tips" document for further details on these codes).
lstr_route = guo_bpdistance.uf_getroute(true)

// Loop through all the viapoint codes
li_max = Len(lstr_route)
For li_count = 1 To li_max

	// Convert each viapoint code to a full viapoint name using UF_VIAPOINT_LONG and
	// try to look it up in the shared port datawindow
	ll_row = w_share.dw_calc_port_dddw.Find("PORT_N='"+guo_bpdistance.uf_viapoint_long(Asc(lstr_route[li_count]) )+"'",1,999999)
	If ll_row > 0 Then 
		// If it was found, then get the TRAMOS 2-letter code for that port
		ls_portcode = w_share.dw_calc_port_dddw.GetItemString(ll_row, "PORT_CODE")

		// And check to see if it's in our "positive list" over viapoints that
		// should be included. If it is, then add it to the AS_VIAPOINTS array.
		If Pos("GH/SS/PC/SU/GI/BR/CH/CL/GB/KC/MA/SC/SK/TO", ls_portcode)>0 Then
			li_resultcount ++
			as_viapoints[li_resultcount] = ls_portcode 
		End if
	End if

Next


end subroutine

public function boolean uf_create_calc_est_links (long al_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date        5-5-97 

 Description : Creates a list with the following data: calculated id, estimated id, 
 					portcode and itinerary number. This list is to be used whenever 
					estimated and calculated ports needs to be matched. Pass the ID for
					the calculated calculation in AL_CALC_ID

 Arguments : AL_CALC_ID as long

 Returns   : False if error in list

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count, li_itinerary_number, li_loop
Long ll_id, ll_search_id
String ls_portcode

ll_search_id = al_calc_id
if ll_search_id<>0 Then

	// This is how the routine works: 
	// The main loop is looped through twice. 
	//
	// First time we'll fetch the CAL_CAIO_ID, CAL_CAIO_ITINERARY_NUMBER 
	// and PORT_CODE from the CAL_CAIO table, where the parent's (CAL_CARG) 
	// CAL_CALC_ID equals LL_SEARCH_ID.  
	//
	// After the first loop, the LL_SEARCH_ID is replaced with the ID for
	// the estimated calculation, and the FETCH is repeated. The second
	// time only the estimated ID is fecthed in to the array, effectively
	// establishing the link between calculated and estimated. To ensure
	// integrity during the fecth, PORTCODE and ITINERARY NUMBER between the
	// estimated and calculated fecth is checked.
	
	FOR li_loop = 1 TO 2 

		// Declare the cursor for getting the CAL_CAIO_ID, 
		// CAL_CAIO_ITINERARY_NUMBER and PORT_CODE, using the
		// LL_SEARCH_ID (which is a calculation ID) as the
		// WHERE clause
		DECLARE link_cursor CURSOR FOR
		SELECT CAL_CAIO_ID, CAL_CAIO_ITINERARY_NUMBER, PORT_CODE
		FROM CAL_CAIO 
		WHERE CAL_CARG_ID =
		(SELECT CAL_CARG_ID 
		FROM CAL_CARG
		WHERE CAL_CALC_ID = :ll_search_id)
		ORDER BY CAL_CAIO_ITINERARY_NUMBER;

		OPEN link_cursor;

		li_count = 0

		// Loop through the result set, fetching into LL_ID, LI_ITINERARY_NUMBER
		// and LS_PORTCODE
		DO WHILE SQLCA.SQLCode = 0 
			FETCH link_cursor 
			INTO :ll_id, :li_itinerary_number, :ls_portcode;

			If SQLCA.SQLCode = 0 Then
				li_count ++

				// If FECTH went ok (SQLCode = 0), then put the values into the
				// ISTR_CALC_EST_LINKS array. First time we loop, we put the values
				// into the L_CALC_ID, I_ITINERARY_NUMBER and S_PORTCODE. Second time
				// the itinerary and portcode values are compared and only the L_EST_ID
				// is inserted into the array (if order is OK).
				CHOOSE CASE li_loop 
					CASE 1
						istr_calc_est_links[li_count].l_calc_id = ll_id
						istr_calc_est_links[li_count].i_itinerary_number = li_itinerary_number
						istr_calc_est_links[li_count].s_portcode = ls_portcode
					CASE 2
						If istr_calc_est_links[li_count].i_itinerary_number <> li_itinerary_number or &
							istr_calc_est_links[li_count].s_portcode <> ls_portcode then
					
							Return false
						End if		

						istr_calc_est_links[li_count].l_est_id = ll_id
				END CHOOSE
			End if
		LOOP

		CLOSE link_cursor;

		If li_loop = 1 Then
			// If this is the first time through the loop, then change the
			// LL_SEARCH_ID to point to the estimated (status = 5) calculation
			// and get the CALC_ID for that calculation. Now, when the loop is 
			// executed the second time, it'll fetch data from the estimated
			// calculation rather then the (initially) calculated calculation
		
			SELECT CAL_CALC_ID 
			INTO :ll_search_id
			FROM CAL_CALC
			WHERE CAL_CALC_STATUS = 6 AND 
				CAL_CALC_FIX_ID = 
			(SELECT CAL_CALC_FIX_ID
			FROM CAL_CALC 
			WHERE CAL_CALC_ID = :ll_search_id);
		End if
	Next	
End if

Return true
end function

public function string uf_getroute (boolean ab_return_as_code);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the route for distance already returned by uf_getdistance. If
 					ab_return_as_code is true then the route will be returned as Viapoint-
					codes, while false will return the viapoints as plaintext

 Arguments : AB_RETURN_AS_CODE as boolean

 Returns   : String  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(guo_bpdistance.uf_getroute(ab_return_as_code))
end function

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes the U_CALCUTIL_NVO by instantiating the BP_DISTANCE
 					object (if not already created)

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Check if the global U_BP_DISTANCE object has been instatiated. If not we'll 
// create it. 
If not isvalid(guo_bpdistance) Then
	
	// The global BP_DISTANCE object was not created. Now instantiate it either as
	guo_bpdistance = CREATE u_bpdistance_win32
	
	// Set the path to the distancetable and open it.
	guo_bpdistance.uf_setpath(uo_global.gs_bp_path)

	if not guo_bpdistance.uf_openbps() Then
		MessageBox("System error", "Error opening bpdistance from "+uo_global.gs_bp_path+"~r~n~r~nerror: "+guo_bpdistance.uf_errortext())
	End if
End if

end event

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Destroys the U_CALCUTIL_NVO. The global BP_DISTANCE object is NOT
 					destroyed here, since it's kept alive for the rest of TRAMOS'
					lifetime for quicker loadtimes. If for some reason this functionality
					isn't wanted, place the cleanup code here.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

end event

on u_calcutil_nvo.create
call super::create
end on

on u_calcutil_nvo.destroy
call super::destroy
end on

