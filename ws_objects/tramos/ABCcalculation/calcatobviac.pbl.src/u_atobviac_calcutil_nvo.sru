$PBExportHeader$u_atobviac_calcutil_nvo.sru
$PBExportComments$Wrapper NVO, this is loaded together w. a calculation.  After implementation of AtoBviaC distance table.
forward
global type u_atobviac_calcutil_nvo from mt_n_nonvisualobject
end type
type s_viapoint from structure within u_atobviac_calcutil_nvo
end type
type s_calc_est_link from structure within u_atobviac_calcutil_nvo
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

global type u_atobviac_calcutil_nvo from mt_n_nonvisualobject
end type
global u_atobviac_calcutil_nvo u_atobviac_calcutil_nvo

type prototypes

end prototypes

type variables
String is_error
s_speed istr_speedlist[]
u_atobviac_calc_cargos iuo_calc_cargos
u_atobviac_calc_summary iuo_calc_summary
u_atobviac_calc_itinerary iuo_calc_itinerary
u_atobviac_calc_compact iuo_calc_compact
u_atobviac_calculation iuo_calculation
mt_n_datastore ids_cal_cons
constant string is_COL_CAL_CONS_SPEED = "cal_cons_speed"
constant string is_COL_CAL_CONS_HFO = "cal_cons_fo"
constant string is_COL_CAL_CONS_DO = "cal_cons_do"
constant string is_COL_CAL_CONS_GO = "cal_cons_mgo"
constant string is_COL_CAL_CONS_LSFO = "cal_cons_lsfo"
Private String is_from, is_to
Private Integer ii_errorcode
s_calc_vessel_data istr_calc_vessel_data
s_calc_bunkerstockprice istr_calc_bunkerstockprice
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
public function boolean uf_create_calc_est_links (long al_calc_id)
public function integer of_setconsdata (datawindow adw_parent, string as_childcolname, string as_conscolname, string as_colname)
public function integer of_return_consactive (string as_columnname, string as_messagecontent, datawindow adw_parent, string as_data)
public subroutine documentation ()
public function integer of_getconsdropdown (datawindow adw_parent, string as_colname, string as_typelist, boolean ab_init, boolean ab_active, integer al_row)
public subroutine of_get_bunkerstockprice (integer al_vessel_id)
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
 Date       : 24-02-2005
 Description : Returns the distance between two points from AtoBviaC distancetable

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

// Now check
// the AtoBviaC(ABC) distance table. Convert the portnames to ABC codes before
// calling the ABC distancetable
If not uf_port_to_UNCTAD(as_from) Then
	li_dist = -10 // Return that FROM port didn't have an AtoBviaC entry
Else
	If not uf_port_to_UNCTAD(as_to) Then
		li_dist = -11 // Return that TO port didn't have an AtoBviaC entry
	Else
		li_dist = gnv_atobviac.of_getporttoportdistance( as_from, as_to)
		ib_bproute_ok = true
	End if
End if

COMMIT;

// LI_DIST is used to return errorcodes (if negative) or distance (if positive).
// If an error happend, then set the ii_errorcode variable to the LI_DIST value
If li_dist < 0 Then ii_errorcode = li_dist else ii_errorcode = 0

// and return the distance (or errorcode)
Return(li_dist)



end function

public function boolean uf_port_to_unctad (ref string as_port);/*
 Description : Converts the port code given in AS_PORT to AtoBviaC portcode. The AtoBviaC
 					code is also returned in AS_PORT

 Arguments : AS_PORT as string REF

 Returns   : True if ok  */

String ls_tmp
Long ll_tmp

// Find the portcode AS_PORT in the shared port window. If found, then take
// the AtoBviaC code from the returned row number
ll_tmp = w_share.dw_calc_port_dddw.Find("PORT_CODE='"+as_port+"'",1,999999)
If ll_tmp > 0 Then &
	ls_tmp = w_share.dw_calc_port_dddw.GetItemString(ll_tmp, "ABC_PORT_PORTCODE")

If Not(IsNull(ls_tmp)) Then as_port = ls_tmp

// Return true if the AtoBviaC portcode is greater than 3 char's long (rather then the initial
// portcode in AS_PORT, that's only 3 char's long
Return(Len(as_port)>3)

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
	CASE -10
		Return "No AtoBviaC code defined for port "+uf_portcode_to_name(is_from)
	CASE -11
		Return "No AtoBviaC code defined for port "+uf_portcode_to_name(is_to)
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

if not isnull(al_vessel_id) Then
// Select data from the VESSEL table into the ISTR_CALC_VESSEL_DATA structur
// if AL_VESSEL_ID is not null
	istr_calc_vessel_data.b_apmvessel = True

	SELECT CAL_VEST_TYPE_ID,
		VESSEL_NAME,
		CAL_DRC,
		CAL_OA,
		CAL_CAP,
		CAL_TC,
		CAL_SDWT,
		PC_NR,
		BUDGET_COMM
	INTO :ll_vessel_type_id,
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

// If the FUEL price is NULL then set it to zero instead
If IsNull(istr_calc_vessel_data.d_fo_price) Then istr_calc_vessel_data.d_fo_price = 0
If IsNull(istr_calc_vessel_data.d_do_price) Then istr_calc_vessel_data.d_do_price = 0
If IsNull(istr_calc_vessel_data.d_mgo_price) Then istr_calc_vessel_data.d_mgo_price = 0
if isnull(istr_calc_vessel_data.d_lsfo_price) then istr_calc_vessel_data.d_lsfo_price = 0

// Return the result
Return(lb_result)
end function

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
DATE			VERSION		 	NAME			DESCRIPTION
-------- 	------- 			----- 		-------------------------------------
31/10/16		CR4531			LHG008		Fix bug
************************************************************************************/

Integer li_count, li_itinerary_number, li_loop
Long ll_id, ll_search_id
String ls_portcode
boolean	lb_return = true

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
		 WHERE CAL_CARG_ID in
				 (SELECT CAL_CARG_ID FROM CAL_CARG 
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
							
							lb_return = false
							exit
						End if		

						istr_calc_est_links[li_count].l_est_id = ll_id
				END CHOOSE
			End if
		LOOP
		
		CLOSE link_cursor;
		if lb_return = false then return false
		
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

public function integer of_setconsdata (datawindow adw_parent, string as_childcolname, string as_conscolname, string as_colname);/********************************************************************
   of_setconsdata
   <DESC>	Find and set data accroding to cal_cons_id	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		adw_parent:
		as_childcolname:
		as_conscolname:
		as_colname:
   </ARGS>
   <USAGE>	When cal_cons_id changed
		ref:u_atobviac_calc_cargos.itemchanged()
	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		03-22-2013	CR2658	LHG008	First Version
   </HISTORY>
********************************************************************/
string	ls_constypeid
long		ll_row, ll_find
decimal	ld_data
datawindowchild ldwc_cal_cons

if not isvalid(adw_parent) &
	or isnull(as_conscolname) or trim(as_conscolname) = '' &
	or isnull(as_colname) or trim(as_colname) = '' &
then return c#return.Failure

//check the colunm name is correct or not
if lower(as_conscolname) <> is_COL_CAL_CONS_SPEED and lower(as_conscolname) <> is_COL_CAL_CONS_HFO &
	and lower(as_conscolname) <> is_COL_CAL_CONS_DO and lower(as_conscolname) <> is_COL_CAL_CONS_GO &
	and lower(as_conscolname) <> is_COL_CAL_CONS_LSFO then return c#return.Failure

ls_constypeid = adw_parent.gettext()
if isnull(ls_constypeid) or trim(ls_constypeid) = '' then return c#return.Failure

ll_row = adw_parent.getrow()
if ll_row <= 0 then return c#return.Failure

//find and set data accroding to cal_cons_id
if adw_parent.getchild(as_childcolname, ldwc_cal_cons) = 1 then
	ll_find = ldwc_cal_cons.find("cal_cons_id = " + ls_constypeid, 1, ldwc_cal_cons.rowcount())
	if ll_find > 0 then
		ld_data = ldwc_cal_cons.getitemnumber(ll_find, as_conscolname)
	end if
	
	adw_parent.setitem(ll_row, as_colname, ld_data)
	
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_return_consactive (string as_columnname, string as_messagecontent, datawindow adw_parent, string as_data);/********************************************************************
   of_return_activestatus()
   <DESC>		</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	dw_cargo_summary.itemchanged();dw_loadports.itemchanged();dw_dischports.itemchanged() <USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		01/09/15	CR4048       KSH092   First Version
   </HISTORY>
********************************************************************/
datawindowchild ldwc_dddw
long ll_row, ll_active

adw_parent.getchild(as_columnname,ldwc_dddw)
ll_row = ldwc_dddw.find("cal_cons_id = " + as_data, 1, ldwc_dddw.rowcount())
if ll_row > 0 then
	ll_active = ldwc_dddw.getitemnumber(ll_row,'cal_cons_active')
	if ll_active = 1 then
		return C#Return.Success
	else
		if as_messagecontent = 'speed' then
			messagebox('Validation','Selected speed is marked as Inactive. Please select another speed.')

		else
			messagebox('Validation','Selected consumption is marked as Inactive. Please select another consumption.')
		end if
		Return C#return.Failure
	end if
else
	return C#Return.Failure
end if

return C#return.Success
end function

public subroutine documentation ();/********************************************************************
   u_atobviac_calcutil_nvo
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date     CR-Ref      	 Author             Comments
   29/10/15		CR3250			CCY018		Add LSFO fuel in calculation module.
	19/01/16		CR3381			CCY018		Remove Ship type and Competitor.
	31/10/16		CR4531			LHG008		Fix bug
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_getconsdropdown (datawindow adw_parent, string as_colname, string as_typelist, boolean ab_init, boolean ab_active, integer al_row);/********************************************************************
   of_getconsdropdown
   <DESC>	Get consumption data into drop-down list	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_parent:	parent datawindow for the dorp-down
		as_colname:	child conlum name
		as_typelist:type list for the consumption, the delimiter is ','
		ab_init:		true:init the drop-down; false:just filter;
   </ARGS>
   <USAGE>	ref:u_atobviac_calc_itinerary.ue_dddw_open()
					 u_atobviac_calc_cargos.ue_dddw_open()
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		22-03-2013	CR2658		LHG008	First Version
		28-11-2013  CR2658UAT	ZSW001	Do not need to refresh the zone_id
		31-08-2015  CR4048      KSH092   Filter inaitive consdropdown data when ab_active is true
		
   </HISTORY>
********************************************************************/

datawindowchild ldwc_cal_cons,  ldwc_zone
string ls_filter
dec ldc_cons_id

if adw_parent.getchild(as_colname, ldwc_cal_cons) = 1 then
	if ab_init then
		ldwc_cal_cons.reset()
		ids_cal_cons.rowscopy(1, ids_cal_cons.rowcount(), Primary!, ldwc_cal_cons, 1, Primary!)
	end if
	if ab_active = true then
		if al_row > 0 then
			ldc_cons_id = adw_parent.getitemnumber(al_row,as_colname)
		else
			ldc_cons_id = 0
		end if
		if isnull(ldc_cons_id) or ldc_cons_id = 0 then
			ls_filter = "cal_cons_type in(" + as_typelist + ") and " +"cal_cons_active = 1"
		else
			ls_filter = "cal_cons_type in(" + as_typelist + ") and " +"(cal_cons_active = 1 or " + "cal_cons_id = " + string(ldc_cons_id) +')'
		end if
	else
		ls_filter = "cal_cons_type in(" + as_typelist + ")"
	end if
	ldwc_cal_cons.setfilter(ls_filter)
	ldwc_cal_cons.filter()
	adw_parent.setrow(adw_parent.getrow())
	
	return c#return.Success
else
	return c#return.Failure
end if
end function

public subroutine of_get_bunkerstockprice (integer al_vessel_id);/********************************************************************
   of_get_bunkerstockprice
   <DESC>	Get vessel bunker stock price	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_id
   </ARGS>
   <USAGE>	ref:u_atobviac_calc_compact.dw_calc_summary.click event
	                   u_atobviac_calc_summary.cb_refresh_bunker.click event
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		17/03/16     CR3146       KSH092   Get vessel bunker stock price
		
   </HISTORY>
********************************************************************/

mt_n_datastore lds_bunkerstock
datastore lds_data
string ls_voyage, ls_portcode
integer li_vessel, li_pcn
n_port_departure_bunker_value			inv_bunker
decimal{4}			ld_value, ld_hfo_ton, ld_do_ton, ld_go_ton, ld_lshfo_ton
long					ll_bunkerID[], ll_empty[]
long					ll_rows, ll_row
datawindowchild	ldwc_hfo, ldwc_do, ldwc_go, ldwc_lshfo


SELECT TOP 1 POC.VESSEL_NR,
		 POC.VOYAGE_NR,
		 POC.PORT_CODE,
		 POC.PCN
 INTO :li_vessel,
		:ls_voyage,
		:ls_portcode,
		:li_pcn
 FROM POC
WHERE POC.VESSEL_NR = :al_vessel_id
  AND (ISNULL(POC.DEPT_HFO, 0) > 0 OR ISNULL(POC.DEPT_DO, 0) > 0 OR ISNULL(POC.DEPT_GO, 0) > 0 OR ISNULL(POC.DEPT_LSHFO, 0) > 0)
ORDER BY POC.PORT_ARR_DT DESC ;

inv_bunker = create n_port_departure_bunker_value	

lds_bunkerstock = create mt_n_datastore
lds_bunkerstock.dataobject = 'd_sq_cm_bunker_dept_value'


lds_data = create mt_n_datastore

select isnull(DEPT_HFO,0), isnull(DEPT_DO,0), isnull(DEPT_GO,0), isnull(DEPT_LSHFO,0) 
	INTO :ld_hfo_ton, :ld_do_ton, :ld_go_ton, :ld_lshfo_ton 
	FROM POC 
	WHERE VESSEL_NR = :li_vessel 
	AND VOYAGE_NR= :ls_voyage 
	AND PORT_CODE= :ls_portcode 
	AND PCN= :li_pcn ;
commit;

lds_bunkerstock.insertRow(0)

/* HFO */
if ld_hfo_ton <> 0 then
	inv_bunker.of_calculate( "HFO", li_vessel, ls_voyage, ls_portcode, li_pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	lds_bunkerstock.getChild( "dw_hfo", ldwc_hfo )
	ldwc_hfo.setTransObject(sqlca)
	ldwc_hfo.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_hfo.rowCount()
	for ll_row = 1 to ll_rows
		if ld_hfo_ton >= ldwc_hfo.getItemDecimal(ll_row, "lifted") then
			ld_hfo_ton -=ldwc_hfo.getItemDecimal(ll_row, "lifted")
			ldwc_hfo.setItem(ll_row, "rest_ton",ldwc_hfo.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_hfo.setItem(ll_row, "rest_ton", ld_hfo_ton)
		end if
	next
	istr_calc_bunkerstockprice.d_fo_price = ldwc_hfo.getitemdecimal(1,'compute_2')
else
	istr_calc_bunkerstockprice.d_fo_price = 0
end if

/* DO */
ll_bunkerID = ll_empty
if ld_do_ton <> 0 then
	inv_bunker.of_calculate( "DO", li_vessel, ls_voyage, ls_portcode, li_pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	lds_bunkerstock.getChild( "dw_do", ldwc_do )
	ldwc_do.setTransObject(sqlca)
	ldwc_do.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_do.rowCount()
	for ll_row = 1 to ll_rows
		if ld_do_ton >= ldwc_do.getItemDecimal(ll_row, "lifted") then
			ld_do_ton -=ldwc_do.getItemDecimal(ll_row, "lifted")
			ldwc_do.setItem(ll_row, "rest_ton",ldwc_do.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_do.setItem(ll_row, "rest_ton", ld_do_ton)
		end if
	next
	istr_calc_bunkerstockprice.d_do_price = ldwc_do.getitemdecimal(1,'compute_2')
else
	istr_calc_bunkerstockprice.d_do_price = 0
end if

/* GO */
ll_bunkerID = ll_empty
if ld_go_ton <> 0 then
	inv_bunker.of_calculate( "GO", li_vessel, ls_voyage, ls_portcode, li_pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	lds_bunkerstock.getChild( "dw_go", ldwc_go )
	ldwc_go.setTransObject(sqlca)
	ldwc_go.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_go.rowCount()
	for ll_row = 1 to ll_rows
		if ld_go_ton >= ldwc_go.getItemDecimal(ll_row, "lifted") then
			ld_go_ton -=ldwc_go.getItemDecimal(ll_row, "lifted")
			ldwc_go.setItem(ll_row, "rest_ton",ldwc_go.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_go.setItem(ll_row, "rest_ton", ld_go_ton)
		end if
	next
	istr_calc_bunkerstockprice.d_mgo_price = ldwc_go.getitemdecimal(1,'compute_2')
else
	istr_calc_bunkerstockprice.d_mgo_price = 0
end if

/* LSHFO */
ll_bunkerID = ll_empty
if ld_lshfo_ton <> 0 then
	inv_bunker.of_calculate( "LSHFO", li_vessel, ls_voyage, ls_portcode, li_pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	lds_bunkerstock.getChild( "dw_lshfo", ldwc_lshfo )
	ldwc_lshfo.setTransObject(sqlca)
	ldwc_lshfo.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_lshfo.rowCount()
	for ll_row = 1 to ll_rows
		if ld_lshfo_ton >= ldwc_lshfo.getItemDecimal(ll_row, "lifted") then
			ld_lshfo_ton -=ldwc_lshfo.getItemDecimal(ll_row, "lifted")
			ldwc_lshfo.setItem(ll_row, "rest_ton",ldwc_lshfo.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_lshfo.setItem(ll_row, "rest_ton", ld_lshfo_ton)
		end if
		
	next
	istr_calc_bunkerstockprice.d_lsfo_price = ldwc_lshfo.getitemdecimal(1,'compute_2')
else
	istr_calc_bunkerstockprice.d_lsfo_price = 0
end if
destroy  lds_bunkerstock
destroy lds_data
end subroutine

on u_atobviac_calcutil_nvo.create
call super::create
end on

on u_atobviac_calcutil_nvo.destroy
call super::destroy
end on

event destructor;call super::destructor;if isvalid(ids_cal_cons) then destroy ids_cal_cons
end event

event constructor;call super::constructor;ids_cal_cons = create mt_n_datastore
ids_cal_cons.dataobject = 'd_sq_gr_cal_cons'
ids_cal_cons.settransobject(sqlca)
end event

