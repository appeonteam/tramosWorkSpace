$PBExportHeader$u_tramos_nvo.sru
$PBExportComments$Non-Visual Object for tramos module
forward
global type u_tramos_nvo from nonvisualobject
end type
end forward

global type u_tramos_nvo from nonvisualobject
end type
global u_tramos_nvo u_tramos_nvo

type variables
long il_calc_id = -1  /* only used on CR2413 when need to dynamicaly set calculation ID  */
end variables

forward prototypes
public function string uf_get_disb_portcode (string as_portcode)
public function string uf_get_port_status (long calc_id, ref s_get_cargo_status ports[])
public function boolean uf_cargo_on_port (ref s_get_cargo_status caioid[])
public function string uf_check_proceed_itenerary (integer ai_vessel, string as_voyage, boolean showmessage)
public subroutine of_setcalculationid (long al_calc_id)
end prototypes

public function string uf_get_disb_portcode (string as_portcode);string ls_port_code

SELECT DISB_PORT_CODE
	INTO :ls_port_code
	FROM PORTS
WHERE PORT_CODE = :as_portcode ;

If IsNull(ls_port_code) OR ls_port_code = "" THEN ls_port_code = "No Code"

return ls_port_code
end function

public function string uf_get_port_status (long calc_id, ref s_get_cargo_status ports[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : N/A
  
 Object     : uf_get_port_status
  
 Event	 : calling of function

 Scope     : Public

 ************************************************************************************

 Author    : Leith Noval
 Date       : 15-05-97

!!!! THIS FUNCTION IS ONLY USED BY 'OLD' CALCULATIONS !!!!! (before AtoBviaC distance table)
 Description : This function gets an array of ports
			and must for each port return if it has been used yet. It
			returns this information by placing a locked bit and a port arrival date
			in the array.

 Arguments : structure ports which holds an array of s_get_cargo_status :
						port_code
						grade_name (not used here )
						grade_group (not used here )
						load
						locked
						arrival_dt

 Returns   : string : NULL if function performed correctly, else message

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-05 97		5.0			LN
************************************************************************************/
// New function code by Leith, lockes port if proceed.

String ls_port, lsa_ports[], ls_return
Integer li_nr= 1, li_c_counter, li_p_counter, li_upper_c, li_next, li_bit
Boolean lb_reversible_dem, lb_down = FALSE, lb_next=TRUE

SetNull(ls_return)

SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM
INTO :li_bit
FROM CAL_CERP , CAL_CARG 
WHERE CAL_CARG.CAL_CALC_ID = :calc_id AND CAL_CARG .CAL_CERP_ID = CAL_CERP.CAL_CERP_ID;
COMMIT;

IF li_bit = 1 THEN 
	lb_reversible_dem = TRUE
ELSE
	lb_reversible_dem = FALSE
END IF

DECLARE port_cur CURSOR FOR  
SELECT PORT_CODE
FROM PROCEED,VOYAGES
WHERE 	( PROCEED.VESSEL_NR = VOYAGES.VESSEL_NR ) and  
       		( PROCEED.VOYAGE_NR = VOYAGES.VOYAGE_NR ) and  
		( PROCEED.CANCEL = 0 ) and  
       		( VOYAGES.CAL_CALC_ID = :calc_id ) 
ORDER BY PROCEED.PROC_DATE ASC  ;

OPEN port_cur;

FETCH port_cur INTO :ls_port;

DO WHILE SQLCA.SQLCode = 0
	lsa_ports[li_nr] = ls_port	
	li_nr++
	FETCH port_cur INTO :ls_port;
LOOP
CLOSE port_cur;

li_c_counter = 1
li_nr --
li_upper_c = UpperBound(ports)

FOR li_p_counter = 1 TO li_nr
	IF ports[li_c_counter].port_code = lsa_ports[li_p_counter] THEN
		ports[li_c_counter].locked = TRUE
		IF lb_reversible_dem THEN
			li_next = li_c_counter
			li_next++
			IF li_next <= li_upper_c THEN
				DO WHILE ports[li_next].port_code = lsa_ports[li_p_counter] AND lb_next 
				  	 ports[li_next].locked = TRUE
					  lb_down = TRUE
					  li_c_counter++
					  IF li_next < li_upper_c THEN 
							li_next++
					  ELSE 
							lb_next = FALSE
					  END IF
				LOOP
			END IF
			IF lb_down THEN 
//				li_c_counter --
				lb_down = FALSE
			END IF
		END IF
	ELSE
		ls_return = "Proceeding and Itinerary don't match. Please correct."
		EXIT	
	END IF
	li_c_counter++
	IF li_c_counter > li_upper_c THEN EXIT
NEXT

Return ls_return
end function

public function boolean uf_cargo_on_port (ref s_get_cargo_status caioid[]);Integer li_upper,li_counter
Long ll_calcaioid

li_upper = UpperBound(caioid)

For li_counter = 1 To li_upper

	SELECT CAL_CAIO_ID
	INTO :ll_calcaioid
	FROM CD
	WHERE CAL_CAIO_ID = :caioid[li_counter].caioid;

	IF SQLCA.SQLCode = 100 THEN
		 caioid[li_counter].locked = FALSE
	ELSEIF  SQLCA.SQLCode = 0 THEN
		 caioid[li_counter].locked = TRUE
	ELSE
		COMMIT USING SQLCA;
		Return FALSE
	END IF

	COMMIT USING SQLCA;
NEXT

RETURN TRUE
end function

public function string uf_check_proceed_itenerary (integer ai_vessel, string as_voyage, boolean showmessage);// Variables
string ls_itenerary[], ls_proceed[],ls_new_itenerary[]
string ls_port_code, ls_via1, ls_via2, ls_via3,ls_old_via1,ls_old_via2,ls_old_via3
string ls_i_message, ls_p_message
long ll_calc_id,ll_via_count = 0
long ll_itenerary_pointer = 1, ll_proceed_pointer = 1
long ll_upper_itenerary, ll_upper_proceed,ll_new_upper_itenerary
long xx,yy
s_viap_tracking lstr_viap_temp, lstr_viap_temp2, lstr_viap_temp3
boolean lb_reversible, lb_error = FALSE

// Cursors

DECLARE itenerary_cur CURSOR FOR  
	SELECT CAL_CAIO.PORT_CODE,
	   		CAL_CAIO.CAL_CAIO_VIA_POINT_1,
   			CAL_CAIO.CAL_CAIO_VIA_POINT_2,
   			CAL_CAIO.CAL_CAIO_VIA_POINT_3
	FROM CAL_CAIO,   
       			CAL_CALC,   
         		CAL_CARG  
   	WHERE ( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         		( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
		        ( ( CAL_CALC.CAL_CALC_ID = :ll_calc_id ) )   
	ORDER BY CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER ASC   ;

DECLARE proceed_cur CURSOR FOR  
	SELECT PORT_CODE
	FROM PROCEED,VOYAGES
	WHERE 	( PROCEED.VESSEL_NR = VOYAGES.VESSEL_NR ) and  
       			( PROCEED.VOYAGE_NR = VOYAGES.VOYAGE_NR ) and  
			( PROCEED.CANCEL = 0 ) and  
       			( VOYAGES.CAL_CALC_ID = :ll_calc_id ) 
	ORDER BY PROCEED.PROC_DATE ASC ;


// Get CAL_CALC_ID from voyages

SELECT VOYAGES.CAL_CALC_ID 
	INTO :ll_calc_id
 	FROM VOYAGES 
	WHERE VOYAGES.VESSEL_NR = :ai_vessel 
	AND VOYAGES.VOYAGE_NR = :as_voyage ; 
COMMIT;

/* only used on CR2413 when need to dynamicaly set calculation ID  */
if il_calc_id > 0 then 
	ll_calc_id = il_calc_id
end if

IF IsNull(ll_calc_id) OR ll_calc_id < 2 THEN
	IF IsValid(w_proceeding_list) THEN
		w_proceeding_list.istr_viap.port[1] = "NOCALC"
		w_proceeding_list.istr_viap.viap[1] = 9	
		Return "0"
	END IF
END IF

//Check om reversible dem.
SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM
	INTO :lb_reversible
	FROM CAL_CERP , 
		    CAL_CARG 
	WHERE CAL_CARG.CAL_CALC_ID = :ll_calc_id 
	AND CAL_CARG .CAL_CERP_ID = CAL_CERP.CAL_CERP_ID;
COMMIT;

/* ******START****** Fill Itenerary Array ****************** */

// Get Ballast Via Pionts

SELECT CAL_BALL.CAL_BALL_VIA_POINT_1,   
         	CAL_BALL.CAL_BALL_VIA_POINT_2,   
         	CAL_BALL.CAL_BALL_VIA_POINT_3  
    	INTO :ls_via1,   
         	:ls_via2,   
         	:ls_via3  
    	FROM CAL_BALL  
   	WHERE CAL_BALL.CAL_CALC_ID = :ll_calc_id   
		ORDER BY CAL_BALL.CAL_BALL_ID;

IF Not IsNull(ls_via1) THEN
	ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via1)

	// Build array for tracking viapoints. This is done for all ports and itenerary. 
	// Save port_code and 0 if port, 1 if viap
	
	lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
	lstr_viap_temp.viap[ll_itenerary_pointer] = 1

	ll_itenerary_pointer ++
	IF Not IsNull(ls_via2) THEN
		ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via2)
		lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
		lstr_viap_temp.viap[ll_itenerary_pointer] = 1
		ll_itenerary_pointer ++
		IF Not IsNull(ls_via3) THEN
			ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via3)
			lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
			lstr_viap_temp.viap[ll_itenerary_pointer] = 1
			ll_itenerary_pointer ++
		END IF
	END IF
END IF


// Itenerary PORT CODES

OPEN itenerary_cur;
FETCH itenerary_cur INTO :ls_port_code, :ls_via1, :ls_via2, :ls_via3;
IF SQLCA.SQLCode <> 0 THEN
	CLOSE itenerary_cur;
	return "0"
END IF

// First port from itenerary
ls_itenerary[ll_itenerary_pointer] = ls_port_code
lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
lstr_viap_temp.viap[ll_itenerary_pointer] = 0
ll_itenerary_pointer ++
IF Not IsNull(ls_via1) THEN
	ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via1)
	lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
	lstr_viap_temp.viap[ll_itenerary_pointer] = 1
	ll_itenerary_pointer ++
	IF Not IsNull(ls_via2) THEN
		ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via2)
		lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
		lstr_viap_temp.viap[ll_itenerary_pointer] = 1
		ll_itenerary_pointer ++
		IF Not IsNull(ls_via3) THEN
			ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via3)
			lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
			lstr_viap_temp.viap[ll_itenerary_pointer] = 1
			ll_itenerary_pointer ++
		END IF
	END IF
END IF

FETCH itenerary_cur INTO :ls_port_code, :ls_via1, :ls_via2, :ls_via3;

DO WHILE SQLCA.SQLCODE = 0
	IF lb_reversible  THEN
		IF ls_port_code <> ls_itenerary[ll_itenerary_pointer - 1] THEN
			ls_itenerary[ll_itenerary_pointer] = ls_port_code
			lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
			lstr_viap_temp.viap[ll_itenerary_pointer] = 0
			ll_itenerary_pointer ++
			IF Not IsNull(ls_via1) THEN
				ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via1)
				lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
				lstr_viap_temp.viap[ll_itenerary_pointer] = 1
				ll_itenerary_pointer ++
				IF Not IsNull(ls_via2) THEN
					ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via2)
					lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
					lstr_viap_temp.viap[ll_itenerary_pointer] = 1
					ll_itenerary_pointer ++
					IF Not IsNull(ls_via3) THEN
						ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via3)
						lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
						lstr_viap_temp.viap[ll_itenerary_pointer] = 1
						ll_itenerary_pointer ++
					END IF
				END IF
			END IF
		ELSE
			IF Not IsNull(ls_via1) THEN
				ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via1)
				lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
				lstr_viap_temp.viap[ll_itenerary_pointer] = 1
				ll_itenerary_pointer ++
				IF Not IsNull(ls_via2) THEN
					ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via2)
					lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
					lstr_viap_temp.viap[ll_itenerary_pointer] = 1
					ll_itenerary_pointer ++
					IF Not IsNull(ls_via3) THEN
						ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via3)
						lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
						lstr_viap_temp.viap[ll_itenerary_pointer] = 1
						ll_itenerary_pointer ++
					END IF
				END IF
			END IF
		END IF
	ELSE  // Non-reversible
		ls_itenerary[ll_itenerary_pointer] = ls_port_code
		lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
		lstr_viap_temp.viap[ll_itenerary_pointer] = 0
		ll_itenerary_pointer ++
		IF Not IsNull(ls_via1) THEN
			ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via1)
			lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
			lstr_viap_temp.viap[ll_itenerary_pointer] = 1
			ll_itenerary_pointer ++
			IF Not IsNull(ls_via2) THEN
				ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via2)
				lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
				lstr_viap_temp.viap[ll_itenerary_pointer] = 1
				ll_itenerary_pointer ++
				IF Not IsNull(ls_via3) THEN
					ls_itenerary[ll_itenerary_pointer] = uf_get_disb_portcode(ls_via3)
					lstr_viap_temp.port[ll_itenerary_pointer] = ls_itenerary[ll_itenerary_pointer]
					lstr_viap_temp.viap[ll_itenerary_pointer] = 1
					ll_itenerary_pointer ++
				END IF
			END IF
		END IF
	END IF
	ls_old_via1 = ls_via1
	ls_old_via2 = ls_via2
	ls_old_via3 = ls_via3
FETCH itenerary_cur INTO :ls_port_code, :ls_via1, :ls_via2, :ls_via3;

LOOP

CLOSE itenerary_cur;

ll_upper_itenerary = UpperBound(ls_itenerary[])

// Check if there are viap between last port and ballast port
IF Not IsNull(ls_old_via1) THEN
	ll_via_count ++
	IF Not IsNull(ls_old_via2) THEN
		ll_via_count ++
		IF Not IsNull(ls_old_via3) THEN
			ll_via_count ++
		END IF
	END IF
END IF

// Make array with no viapoint to ballast port.
FOR xx = 1 TO (ll_upper_itenerary - ll_via_count)
	ls_new_itenerary[xx] = ls_itenerary[xx]	
NEXT

// Make viap array with no viapoint to ballast port.
FOR xx = 1 TO (ll_upper_itenerary - ll_via_count)
	lstr_viap_temp2.port[xx] = lstr_viap_temp.port[xx]
	lstr_viap_temp2.viap[xx] = lstr_viap_temp.viap[xx]
NEXT

ll_new_upper_itenerary = UpperBound(ls_new_itenerary[])


/* ******END****** Fill Itenerary Array ****************** */

/* ******START****** Fill proceed Array ****************** */

OPEN proceed_cur;

FETCH proceed_cur INTO :ls_port_code;

DO WHILE SQLCA.SQLCode = 0
	ls_proceed[ll_proceed_pointer] = ls_port_code	
	ll_proceed_pointer ++
	FETCH proceed_cur INTO :ls_port_code;
LOOP

CLOSE proceed_cur;

ll_upper_proceed = UpperBound(ls_proceed[])

/* ******END****** Fill proceed Array ****************** */

/* ******START****** CHECK ****************** */

IF ll_upper_proceed > ll_new_upper_itenerary THEN
	lb_error = TRUE
ELSEIF ll_upper_proceed = ll_new_upper_itenerary THEN
	IF ls_new_itenerary = ls_proceed THEN
		IF IsValid(w_proceeding_list) THEN
			w_proceeding_list.istr_viap = lstr_viap_temp2
			// Indicate stop point (probably not necessary).
			w_proceeding_list.istr_viap.port[ll_upper_proceed + 1] = "STOP"
			w_proceeding_list.istr_viap.viap[ll_upper_proceed + 1] = 9	
		END IF
		Return "1"
	ELSE
		lb_error = TRUE
	END IF
ELSE  
	FOR xx = 1 TO ll_upper_proceed
		IF ls_new_itenerary[xx] <> ls_proceed[xx] THEN
			lb_error = TRUE
			EXIT
		END IF
	NEXT
	IF xx >= ll_upper_proceed AND Not lb_error THEN
		// Make viap array with next port for new proceed.
		FOR yy = 1 TO xx
			lstr_viap_temp3.port[yy] = lstr_viap_temp2.port[yy]
			lstr_viap_temp3.viap[yy] = lstr_viap_temp2.viap[yy]
		NEXT
		IF IsValid(w_proceeding_list) THEN
			// IF there is a next port mark it with 2 for port or 3 for viap.
			// 2 and 3 is because later it is possible to see that it is a proceed not yet 
			// updateted. The figur will be used for setting pcn =0 (dw_proceeding) if viap.
			IF lstr_viap_temp3.viap[xx] = 0 THEN
				lstr_viap_temp3.viap[xx] = 2
			ELSE
				lstr_viap_temp3.viap[xx] = 3
			END IF
			lstr_viap_temp3.port[xx + 1] = "STOP"
			lstr_viap_temp3.viap[xx + 1] = 9	
			w_proceeding_list.istr_viap = lstr_viap_temp3
		END IF
		Return ls_new_itenerary[xx]
	END IF
END IF 	

IF lb_error THEN
	IF IsValid(w_proceeding_list) THEN
		// Indicate that there is no valid information in viap structure.
		w_proceeding_list.istr_viap.port[1] = "ERROR"
		w_proceeding_list.istr_viap.viap[1] = 9	
	END IF
	IF showmessage THEN
		FOR xx = 1 to ll_new_upper_itenerary
			ls_i_message += ls_new_itenerary[xx]+"," 
		NEXT
		FOR xx = 1 to ll_upper_proceed
			ls_p_message += ls_proceed[xx]+","
		NEXT
		MessageBox("Error","Itinerary and proceeding don't match.~r~n~r~nItinerary: " + ls_i_message +"~r~nProceeding: " + ls_p_message)  
		return "-1"
	ELSE
		return "-1"
	END IF
END IF

/* ******END****** CHECK ****************** */

end function

public subroutine of_setcalculationid (long al_calc_id);/* only used on CR2413 when need to dynamicaly set calculation ID  */
il_calc_id = al_calc_id
end subroutine

on u_tramos_nvo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tramos_nvo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

