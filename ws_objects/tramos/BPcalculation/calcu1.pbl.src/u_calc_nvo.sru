$PBExportHeader$u_calc_nvo.sru
$PBExportComments$NVO for external calculation acces
forward
global type u_calc_nvo from mt_n_nonvisualobject
end type
type str_cargo from structure within u_calc_nvo
end type
type str_caio from structure within u_calc_nvo
end type
end forward

type str_cargo from structure
	long		l_carg_id
	boolean		b_reversible
	boolean		b_load_done
	boolean		b_disch_done
	double		d_total_units
end type

type str_caio from structure
	string		s_port_code
	double		d_no_units
	double		d_rate_estimated
	long		l_load_terms
	double		d_despatch
	double		d_demurrage
	long		l_raty_id
	long		l_caio_id
	integer		i_carg_index
	string		s_purpose
end type

global type u_calc_nvo from mt_n_nonvisualobject
end type
global u_calc_nvo u_calc_nvo

forward prototypes
public function boolean uf_vesselvoyage_to_calc (integer ai_vessel_nr, string as_voyage_nr, ref long al_calc_id)
public function boolean uf_is_port_on_calc (long al_calc_id, string as_portcode)
public subroutine uf_calc_rate (long al_rate_type, double ad_rate_estimated, ref decimal ad_laytime_allowed, ref decimal ad_hour_rate, ref decimal ad_daily_rate, long al_raty_id, ref string as_raty_description)
public function integer uf_dem_des_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_dem_des_data astr_dem_des_data[])
public function string uf_get_port_code_list_sql (long ai_calc_id)
public function string uf_get_port_name_list_sql (long ai_calc_id)
public function string uf_get_chart_list_sql (long al_calc_id, string as_port_code)
public function integer uf_calc_calc_minutes (integer ai_ratetype, double ad_units, double ad_value)
public function boolean uf_claim_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_claim_base_data astr_claim_base_data)
public function integer uf_frt_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_frt_data astr_frt_data[25])
public subroutine documentation ()
public function boolean uf_cargo_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_claim_base_data astr_claim_base_data)
end prototypes

public function boolean uf_vesselvoyage_to_calc (integer ai_vessel_nr, string as_voyage_nr, ref long al_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 30-7-96

 Description : Finds the corrosponding calc id from vessel/voyage

 Arguments : AI_VESSEL_NR as Integer, AS_VOYAGE_NR as String, AL_CALC_ID as Long REF

 Returns   : True if calc found, otherwise false

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// The code has been moved to n_claimcurrencyadjust
n_claimcurrencyadjust lnv_claimcurrencyadjust
Return lnv_claimcurrencyadjust.uf_vesselvoyage_to_calc(ai_vessel_nr, as_voyage_nr, al_calc_id)

end function

public function boolean uf_is_port_on_calc (long al_calc_id, string as_portcode);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
 Object     : uf_calc_nvo
 Function : uf_is_port_on_calc
 Event	 : 
 Scope     : 
 ************************************************************************************
 Author    : PBT
 Date       : 30-7-96
 Description : Checks whether a given port is used in the calc. 
 Arguments : calc_id as Long, portcode as string.
 Returns   : True if port in use
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96		3.0		PBT		System 3  
24-03-97		5.00		pbt		Changed to handle via points
14-03-05		14.0		RMO		Implementing AtoBviaC distance table
************************************************************************************/
/* Local variables */
int li_temp_result

/* Select if port is in route */
  SELECT count(*)  
    INTO :li_temp_result  
    FROM CAL_ROUTE   
   WHERE CAL_CALC_ID = :al_calc_id  AND  
          PORT_CODE = :as_portcode   ;
COMMIT;
/* if there are ports with this port code on calc set ret value TRue, else set ret value FALSE */
if li_temp_result > 0 then RETURN TRUE

/* select how many ports with this code on calculation */
  SELECT count(*)  
    INTO :li_temp_result  
    FROM CAL_CAIO,   
         CAL_CALC,   
         CAL_CARG  
   WHERE ( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
         ( ( CAL_CALC.CAL_CALC_ID = :al_calc_id ) AND  
         ( CAL_CAIO.PORT_CODE = :as_portcode ) )   ;
COMMIT;
/* if there are ports with this port code on calc set ret value TRue, else set ret value FALSE */
if li_temp_result > 0 then RETURN TRUE


SELECT count(*)  
INTO :li_temp_result  
FROM 	CAL_CAIO,   		CAL_CALC,            CAL_CARG , PORTS
WHERE 	PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_1 AND
		( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         	( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
         	( ( CAL_CALC.CAL_CALC_ID = :al_calc_id ) AND  
         	( PORTS.DISB_PORT_CODE = :as_portcode ) )   ;
COMMIT;
/* if there are ports with this port code on calc set ret value TRue, else set ret value FALSE */
if li_temp_result > 0 then RETURN TRUE
SELECT count(*)  
INTO :li_temp_result  
FROM 	CAL_CAIO,   		CAL_CALC,            CAL_CARG , PORTS
WHERE 	PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_2 AND
		( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         	( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
         	( ( CAL_CALC.CAL_CALC_ID = :al_calc_id ) AND  
         	( PORTS.DISB_PORT_CODE = :as_portcode ) )   ;
COMMIT;
/* if there are ports with this port code on calc set ret value TRue, else set ret value FALSE */
if li_temp_result > 0 then RETURN TRUE
SELECT count(*)  
INTO :li_temp_result  
FROM 	CAL_CAIO,   		CAL_CALC,            CAL_CARG , PORTS
WHERE 	PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_3 AND
		( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  
         	( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  
         	( ( CAL_CALC.CAL_CALC_ID = :al_calc_id ) AND  
         	( PORTS.DISB_PORT_CODE = :as_portcode ) )   ;
COMMIT;
/* if there are ports with this port code on calc set ret value TRue, else set ret value FALSE */
if li_temp_result > 0 then RETURN TRUE

/* check to see if port is on ballast as via point or canal */
select count(*)
INTO :li_temp_result  
from CAL_BALL, PORTS
where 	PORTS.PORT_CODE = CAL_BALL.CAL_BALL_VIA_POINT_1 AND
		CAL_BALL.CAL_CALC_ID = :al_calc_id and
		PORTS.DISB_PORT_CODE = :as_portcode ;
if li_temp_result > 0 then RETURN TRUE
select count(*)
INTO :li_temp_result  
from CAL_BALL, PORTS
where 	PORTS.PORT_CODE = CAL_BALL.CAL_BALL_VIA_POINT_2 AND
		CAL_BALL.CAL_CALC_ID = :al_calc_id and
		PORTS.DISB_PORT_CODE = :as_portcode ;
if li_temp_result > 0 then RETURN TRUE
select count(*)
INTO :li_temp_result  
from CAL_BALL, PORTS
where 	PORTS.PORT_CODE = CAL_BALL.CAL_BALL_VIA_POINT_3 AND
		CAL_BALL.CAL_CALC_ID = :al_calc_id and
		PORTS.DISB_PORT_CODE = :as_portcode ;
if li_temp_result > 0 then RETURN TRUE

/* Return FALSE IF NOT FOUND YET */
Return FALSE
end function

public subroutine uf_calc_rate (long al_rate_type, double ad_rate_estimated, ref decimal ad_laytime_allowed, ref decimal ad_hour_rate, ref decimal ad_daily_rate, long al_raty_id, ref string as_raty_description);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculates the allowed laytime or load/disch rate depending on the
 					AL_RATE_TYPE argument, where
					 
					1 = Hours, 2 = MTS/Hours, 3=MTS/Days, 4 = Days				
					
					Result is returned in AD_LAYTIME_ALLOWED, AD_HOUR_RATE or 
					AD_DAILY_RATE depending on AL_RATE_TYPE. Furthermore rate description
					is returned in AS_RATY_DESCRIPTION
					
 Arguments : AD_RATE_ESTIMATED as double, 
 				 AD_LAYTIME_ALLOWED, AD_HOUR_RATE, AD_DAILY_RATE as Decimal REF
				 AL_RATY_ID as Long,
				 AS_RATY_DESCRIPTION as string REF

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Transaction SQLTMP

// Setup and connect the transactionobject SQLTMP, which will be used in this 
// function to avoid interference with the SQLCA transactionobject
uo_global.DefaultTransActionObject(SQLTMP)

CONNECT USING SQLTMP;

// Get the description for the passed rate-ID AL_RATY_ID
SELECT CAL_RATY.CAL_RATY_DESCRIPTION
INTO :as_raty_description
FROM CAL_RATY  
WHERE CAL_RATY.CAL_RATY_ID = :al_raty_id
USING SQLTMP;
COMMIT;

// Destroy the transactionsobject SQLTMP
DISCONNECT USING SQLTMP;
DESTROY SQLTMP;

// Return the allowed time or rate depending on AL_RATE_TYPE
CHOOSE CASE al_rate_type
	CASE 0 // Hours
		ad_laytime_allowed = ad_rate_estimated
	CASE 1,2,3 // MTS/Hours, CBM/hour, CBF/horu
		ad_hour_rate = ad_rate_estimated
	CASE 5,6,7 // MTS/Days, CBM/Day, CBF/Day
		ad_daily_rate = ad_rate_estimated
	CASE 4 // Days
		ad_laytime_allowed = ad_rate_estimated * 24
END CHOOSE


end subroutine

public function integer uf_dem_des_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_dem_des_data astr_dem_des_data[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MI + LN
   
 Date       : 29-7-96

 Description : Retrieves data for dem/des, given the vessel nr., voyage nr., 
 					charterer nr. and C/P ID as arguments. Returns data in the 
					ASTR_DEM_DES_DATA structure.
					 
 Arguments : AI_VESSEL_NR as integer, AS_VOYAGE_NR as string, 
 				 AI_CHART_NR as integer, AL_CERP_ID as long 
				 ASTR_DEM_DES_DATA as S_DEM_DES_DATA
 
 Returns   : -1: Error 0 = nothing found, 1 = one set covers all, 
 				  1+ if theres is data for each port (code = no. ports)

*************************************************************************************
Development Log 
DATE    		VERSION	NAME  	DESCRIPTION
--------		-------	------	------------------------------------
20/04/16		CR2428	SSX014   Change demurrage currency
03/08/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111).
20/09/17		CR4221	HHX010	Filter Interim Port
************************************************************************************/

// Variable declaration
Long ll_calc_id
String ls_tmp
Double ld_minutes
str_cargo lstr_cargoes[] 
str_caio lstr_caio[]
Boolean lb_reversible, lb_different_terms
Integer li_load_default, li_disch_default, li_count, li_caio_count, li_tmp, li_no_cargoes

SetNull(lb_reversible)

// Try to find to CALC_ID from AI_VESSEL_NR and AS_VOYAGE_NR. UF_VESSELVOYAGE_TO_CALC
// will return true and the CALC_ID in LL_CALC_ID
If uf_vesselvoyage_to_calc(ai_vessel_nr, as_voyage_nr, ll_calc_id) Then

	// Calc ID Found. Now we need to get all the CARG_ID's for linked
	// cargoes, as well as the reversible status. 
	DECLARE cal_get_cargo CURSOR FOR
	SELECT CAL_CARG.CAL_CARG_ID,
		CAL_CARG.CAL_CARG_REVERSIBLE
	FROM CAL_CARG
	WHERE ( CAL_CARG.CAL_CALC_ID = :ll_calc_id ) And
		( CAL_CARG.CAL_CERP_ID = :al_cerp_id)
	USING SQLCA;
		
	// Check errors
	OPEN cal_get_cargo;
	uf_check_sqlcode()
	li_no_cargoes = 0

	// And fetch all entries found into the LSTR_CARGOES array
	DO WHILE SQLCA.SQLCode = 0
		FETCH cal_get_cargo
		INTO :lstr_cargoes[li_no_cargoes + 1].l_carg_id,
			:lstr_cargoes[li_no_cargoes  + 1].b_reversible;

		IF SQLCA.SQLCode = 0 Then 
			li_no_cargoes ++

			// The LB_REVERSIBLE is set to the cargo's reversible flag after each 
			// iteration. If this is not the first iteration (LB_REVERSIBLE <> NUL), 
			// then check if it's different from the last reversible flag. If it's
			// different, then return -1 (error, different reversible cannot be
			// handled by the operations module). 
			If not isNull(lb_reversible) Then 
				if lb_reversible<>lstr_cargoes[li_no_cargoes].b_reversible Then
					// Reversible for this cargo IS different from the last cargo,
					// return an error
					
					CLOSE cal_get_cargo;
					COMMIT;

					Return(-1)
				End if
			End if

			// Set the LB_REVERSIBLE equal to this cargo's reversible, so it
			// can be checked in the next iteration
			lb_reversible = lstr_cargoes[li_no_cargoes].b_reversible
		End if
	LOOP

	// Close the cursor 
	CLOSE cal_get_cargo;
	COMMIT;

	// Return error if no cargoes was found
	If li_no_cargoes < 1 Then
		Return(-1) 
	End if

	li_caio_count = 0

	// Now loop through all cargos in the LSTR_CARGOES array. For each cargo,
	// fetch all cargo ports (cargo in/out), and number of units, 
	// estimated rate and terms.
	FOR li_count =1 TO li_no_cargoes
			
		DECLARE cal_get_port CURSOR FOR  
		SELECT CAL_CAIO.PORT_CODE,   
      	 	CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS,   
		CAL_CAIO.CAL_CAIO_RATE_ESTIMATED,   
      	 	CAL_CAIO.CAL_CAIO_LOAD_TERMS,   
      	 	CAL_CAIO.CAL_CAIO_DESPATCH_DEM_CURR,   
       		CAL_CAIO.CAL_CAIO_DEMURRAGE_DEM_CURR,
    		CAL_CAIO.CAL_RATY_ID,
		CAL_CAIO.CAL_CAIO_ID,
		CAL_CAIO.PURPOSE_CODE
		FROM CAL_CAIO  
		WHERE CAL_CAIO.CAL_CARG_ID = :lstr_cargoes[li_count].l_carg_id
		AND CAL_CAIO.CAL_CAIO_INTERIM_PORT = 0
		AND (CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS <> 0 OR CAL_CAIO.CAL_CAIO_RATE_ESTIMATED > 0);
	
		// Open the cursor and check the SQL status
		OPEN cal_get_port;
		uf_check_sqlcode()

		// Fecth all data into the LSTR_CAIO array
		DO WHILE SQLCA.SQLCode = 0
			li_caio_count ++			

			FETCH cal_get_port
			INTO :lstr_caio[li_caio_count].s_port_code,
			:lstr_caio[li_caio_count].d_no_units, 
			:lstr_caio[li_caio_count].d_rate_estimated,
			:lstr_caio[li_caio_count].l_load_terms,
			:lstr_caio[li_caio_count].d_despatch,
			:lstr_caio[li_caio_count].d_demurrage,
			:lstr_caio[li_caio_count].l_raty_id,
			:lstr_caio[li_caio_count].l_caio_id,
			:lstr_caio[li_caio_count].s_purpose;

			// Insert link between the cargo number and the CAIO information
			// in the I_CARG_INDEX variable.
			lstr_caio[li_caio_count].i_carg_index = li_count 
			
			// If we got an error, the decrement the CAIO count, since it's 
			// one to high.
			IF SQLCA.SQLCode <> 0 Then li_caio_count --
		LOOP

		// Close the cursor
		CLOSE cal_get_port;
		COMMIT;
	Next
		
	// If the cargo(s) is reversible, then loop through all ports, and check that
	// the terms are the same for all loadports and the same for all dischports.
	If lb_reversible Then
		astr_dem_des_data[1].d_other_allowed = 0
		
		For li_count = 1 To li_caio_count 			
			
			If (lstr_caio[li_count].d_no_units > 0) And (li_load_default = 0) Then 

				// Get default type load load ( default = first ) 
				li_load_default = li_count 

			Elseif (lstr_caio[li_count].d_no_units < 0 ) And (li_disch_default = 0) Then

				// Get default type disch( default = first ) 
				li_disch_default = li_count

			Elseif (lstr_caio[li_count].d_no_units <> 0) Then

				// Check to see wether this one equals others
				If lstr_caio[li_count].d_no_units > 0 Then 
					li_tmp = li_load_default 				
				Else
					li_tmp = li_disch_default
				End if

				If (lstr_caio[li_count].l_load_terms <> lstr_caio[li_tmp].l_load_terms) Or &
				(lstr_caio[li_count].d_despatch <> lstr_caio[li_tmp].d_despatch) Or &
				(lstr_caio[li_count].d_demurrage <> lstr_caio[li_tmp].d_demurrage) Or &
				(lstr_caio[li_count].l_raty_id <> lstr_caio[li_tmp].l_raty_id) Then
					// Ports differs, set lb_different_terms to true and exit loop
					lb_different_terms = true
					Exit
				End if
				lstr_caio[li_tmp].d_rate_estimated += lstr_caio[li_count].d_rate_estimated
				
			Elseif lstr_caio[li_count].d_rate_estimated > 0 then
				astr_dem_des_data[1].d_other_allowed += lstr_caio[li_count].d_rate_estimated
			End if
		Next	
	End if

	If (lb_different_terms) Then
		// This code is for different terms, but is not yet legal. Therefore we
		// return an error.
		Return(-1)

		// Loop through first load & Disch ports for each cargo, and calculate total load and disch time
		For li_count = 1 To li_caio_count 		

			If ((lstr_caio[li_count].d_no_units>0) And (not lstr_cargoes[lstr_caio[li_count].i_carg_index].b_load_done)) Or &
				((lstr_caio[li_count].d_no_units<0) And (not lstr_cargoes[lstr_caio[li_count].i_carg_index].b_disch_done)) Then

				ld_minutes = uf_calc_calc_minutes(lstr_caio[li_count].l_load_terms, Abs(lstr_caio[li_count].d_no_units), lstr_caio[li_count].d_rate_estimated)

				If lstr_caio[li_count].d_no_units > 0 Then
					// Calculate allowed for load	

					astr_dem_des_data[1].laytime_allowed += ld_minutes
					
					If astr_dem_des_data[1].dem_rate = 0 Then
						astr_dem_des_data[1].des_rate = lstr_caio[li_count].d_despatch
						astr_dem_des_data[1].dem_rate = lstr_caio[li_count].d_demurrage
					End if
			
					lstr_cargoes[lstr_caio[li_count].i_carg_index].b_load_done = True
				Else
					// Calculate allowed for disch
					astr_dem_des_data[1].disch_allowed += ld_minutes

					lstr_cargoes[lstr_caio[li_count].i_carg_index].b_disch_done = True
				End if
			End if
				
			// Calculate and add to load or disch
		Next

		astr_dem_des_data[1].laytime_allowed = astr_dem_des_data[1].laytime_allowed / 60 // Convert from minutes to hours
		astr_dem_des_data[1].disch_allowed = astr_dem_des_data[1].disch_allowed / 60 // Convert from minutes to hours
		astr_dem_des_data[1].purpose = "L"

		Return(1)		

	Elseif not lb_reversible Then
		// Ok, it's not reversible, now loop through all cargo ports, and calculate
		// the time/allowance for each port.
		For li_count = 1 To li_caio_count 
			// Copy data to the ASTR_DEM_DES_DATA structure
			astr_dem_des_data[li_count].ports = lstr_caio[li_count].s_port_code
			astr_dem_des_data[li_count].des_rate = lstr_caio[li_count].d_despatch
			astr_dem_des_data[li_count].dem_rate = lstr_caio[li_count].d_demurrage
			astr_dem_des_data[li_count].calcaioid = lstr_caio[li_count].l_caio_id

			// and calculate the rate/allowance
			uf_calc_rate(lstr_caio[li_count].l_load_terms, lstr_caio[li_count].d_rate_estimated, &
				astr_dem_des_data[li_count].laytime_allowed, astr_dem_des_data[li_count].hour_rate, &
				astr_dem_des_data[li_count].daily_rate, lstr_caio[li_count].l_raty_id, astr_dem_des_data[li_count].terms)		
			
			// MI: Not sure why the line below is here..
			astr_dem_des_data[li_count].hours = 0 

			// Update the Load/disch flag
			if lstr_caio[li_count].d_no_units > 0 Then
				astr_dem_des_data[li_count].purpose = "L"
			elseif lstr_caio[li_count].d_no_units <0 Then 
				astr_dem_des_data[li_count].purpose = "D"
			else
				astr_dem_des_data[li_count].purpose = lstr_caio[li_count].s_purpose
			end if
		Next

		// Return the number of cargo ports.
		Return(li_caio_count)  
	Else
		// It's reversible. Generate only one entry in the ASTR_DEM_DES_DATA 
		// structure, and calculate the allowance for load and disch and put
		// the result in that entry.
		
		//astr_dem_des_data[1].ports = lstr_caio[li_load_default].s_port_code
		astr_dem_des_data[1].des_rate = lstr_caio[li_load_default].d_despatch
		astr_dem_des_data[1].dem_rate = lstr_caio[li_load_default].d_demurrage
		astr_dem_des_data[1].calcaioid = lstr_caio[li_load_default].l_caio_id
		astr_dem_des_data[1].purpose = "L"

		// Calculate the allowance for loadports.
		uf_calc_rate(lstr_caio[li_load_default].l_load_terms, lstr_caio[li_load_default].d_rate_estimated, &
			astr_dem_des_data[1].laytime_allowed, astr_dem_des_data[1].hour_rate, &
			astr_dem_des_data[1].daily_rate, lstr_caio[li_load_default].l_raty_id, astr_dem_des_data[1].terms)		
			
		// MI: Not sure why the line below is here..
		astr_dem_des_data[li_load_default].hours = 0

		// Add time for dischcharing
		//astr_dem_des_data[2].ports = lstr_caio[li_disch_default].s_port_code
		//astr_dem_des_data[2].des_rate = lstr_caio[li_disch_default].d_despatch
		//astr_dem_des_data[2].dem_rate = lstr_caio[li_disch_default].d_demurrage
		//astr_dem_des_data[2].calcaioid = lstr_caio[li_disch_default].l_caio_id
		//astr_dem_des_data[2].purpose = "L"

		// and calculate the allowance for dischports
		uf_calc_rate(lstr_caio[li_disch_default].l_load_terms, lstr_caio[li_disch_default].d_rate_estimated, &
			astr_dem_des_data[1].disch_allowed, astr_dem_des_data[1].disch_hour_rate, &
			astr_dem_des_data[1].disch_daily_rate, lstr_caio[li_disch_default].l_raty_id, ls_tmp)		
			
		// Return 1 entry
		Return(1)
	End if	

Else
	// Return 0 (no data found)
	Return(0)
End if




end function

public function string uf_get_port_code_list_sql (long ai_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : uo_calcule
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 30-07-96

 Description : creates a sql string to return port codes for a given calc id

 Arguments : ai_calc_id  calc id to place in string

 Returns   : sql string

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96 		3.0			PBT		system 3
24-03-97		5.00			PBT		Changed to show ports and via points
************************************************************************************/

/* Local variables */
string ls_ret_sql_string

// 				'	ORDER BY PORTS.PORT_CODE ASC,    PORTS.PORT_N ASC   ' + & 
ls_ret_sql_string = '  	SELECT DISTINCT PORTS.PORT_CODE PC,   PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.PORT_CODE ) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' 	UNION ' + & 
				'	SELECT DISTINCT CAL_CAIO.CAL_CAIO_VIA_POINT_1 PC,   PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_1) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' 	UNION ' + & 
				'	SELECT DISTINCT CAL_CAIO.CAL_CAIO_VIA_POINT_2 PC,   PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_2) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' 	UNION ' + & 
				'	SELECT DISTINCT CAL_CAIO.CAL_CAIO_VIA_POINT_3 PC,   PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_3) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) '  + &
				'	ORDER BY PC '
return(ls_ret_sql_string)


end function

public function string uf_get_port_name_list_sql (long ai_calc_id);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : uo_calcule
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 30-07-96

 Description : creates a sql string to return port names for a given calc id

 Arguments : ai_calc_id  calc id to place in string

 Returns   : sql string

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96 		3.0			PBT		system 3
24-03-97		5.00			pbt		Changed to show via points
************************************************************************************/

/* Local variables */
string ls_ret_sql_string

ls_ret_sql_string = 	'  	SELECT DISTINCT  PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.PORT_CODE ) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' UNION ' + &
				'  	SELECT DISTINCT  PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_1 ) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' UNION ' + &
				'  	SELECT DISTINCT  PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_2 ) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' + &
				' UNION '+ &
				'  	SELECT DISTINCT  PORTS.PORT_N  ' + &
  				'	FROM CAL_CAIO,   CAL_CALC,   CAL_CARG,   PORTS  ' + &
				'	WHERE 	( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and  ' + &
         			'			( PORTS.PORT_CODE = CAL_CAIO.CAL_CAIO_VIA_POINT_3 ) and  ' + &
        			'			( CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID ) and  ' + &
         			'			( ( CAL_CALC.CAL_CALC_ID = ' + string(ai_calc_id) + ' ) ) ' 



return(ls_ret_sql_string)


end function

public function string uf_get_chart_list_sql (long al_calc_id, string as_port_code);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : uf_get_chart_list_sql
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 30-07-96

 Description : creates a sql string to return charterers for a given calc id

 Arguments : ai_calc_id  calc id to place in string

 Returns   : sql string

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
31-07-96 		3.0			PBT		system 3
************************************************************************************/

/* Local variables */
string ls_ret_sql_string

ls_ret_sql_string = '     SELECT DISTINCT CHART.CHART_SN,      ' + &
'         CHART.CHART_N_1,      ' + &
'         CAL_CERP.CAL_CERP_DESCRIPTION,      ' + &
'         CHART.CHART_NR,      ' + &
'         CAL_CERP.CAL_CERP_ID     ' + &
'    FROM CAL_CALC,      ' + &
'         CAL_CARG,      ' + &
'         CAL_CERP,      ' + &
'         CHART,      ' + &
'         CAL_CAIO     ' + &
'   WHERE ( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and     ' + &
'         ( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and     ' + &
'         ( CHART.CHART_NR = CAL_CERP.CHART_NR ) and     ' + &
'         ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and     ' + &
'         ( ( CAL_CALC.CAL_CALC_ID = ' + string(al_calc_id) + '         ) ) AND     ' + &
'         CAL_CAIO.PORT_CODE = "' + as_port_code   +   '" ' + &
'ORDER BY CHART.CHART_SN ASC      ' 


//ls_ret_sql_string = '    SELECT DISTINCT CHART.CHART_SN,    CHART.CHART_N_1,   ' + &
//				'		CAL_CERP.CAL_CERP_DESCRIPTION,    CHART.CHART_NR,    ' + &
//				'	         CAL_CERP.CAL_CERP_ID   ' + &
//				'	    FROM CAL_CALC,   CAL_CARG,   CAL_CERP,   CHART   ' + &
//				'	   WHERE ( CAL_CALC.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID ) and   ' + &
//				'	         ( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and   ' + &
//				'	         ( CHART.CHART_NR = CAL_CERP.CHART_NR ) and   ' + &
//				'	         ( ( CAL_CALC.CAL_CALC_ID = + string(ai_calc_id) + " " ) )    ' + &
//				'		ORDER BY CHART.CHART_SN ASC   '



return(ls_ret_sql_string)


end function

public function integer uf_calc_calc_minutes (integer ai_ratetype, double ad_units, double ad_value);/***********************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculate time in minutes, given the ratetype in AI_RATETYPE,
 					units in AD_UNITS and additional value in AD_VALUE (hour, days)

 Arguments : AI_RATETYPE as integer, AD_UNITS, AD_VALUE as double.

 Returns   : Minutes as double

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Double ld_min

CHOOSE CASE ai_ratetype
	CASE 0  // hours
		ld_min = (ad_value *60) 
	CASE 1  // MTS/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 2  // Cubicmeters/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 3 // Cubic feet/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 4  //  Days
		ld_min = (ad_value *1440) 
	CASE 5  // MTS/day
		ld_min = ((ad_units * 1440) / ad_value) 
	CASE 6  // Cubicmeters/Day
		ld_min = ((ad_units *1440) / ad_value) 
	CASE 7 //  Cubicfeet/Day
		ld_min = ((ad_units *1440) / ad_value) 
	CASE ELSE
		MessageBox("Error", "Unknown ratetype: "+String(ai_ratetype))
END CHOOSE

Return(ld_min)
end function

public function boolean uf_claim_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_claim_base_data astr_claim_base_data);/********************************************************************
	uf_claim_base_data
	<DESC> 
		Retrieves data for claims, given the vessel nr, voyage nr, charterer nr
		and C/P ID as arguments. Returns data in the ASTR_CLAIM_BASE_DATA structure.
	</DESC>
	<RETURN> true if data found </RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		AI_VESSEL_NR as integer
		AS_VOYAGE_NR as string
		AI_CHART_NR  as integer
		AL_CERP_ID   as long 
		ASTR_CLAIM_BASE_DATA as S_CLAIM_BASE REF
	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date      	CR-Ref		Author		Comments
		29/07/1996	1     		MI+LN    	First Version.
		14/03/2011  CR1549   	JSU         get FIXED_EXRATE_ENABLED, FIXED_EXRATE, CLAIM_CURR from Calculation to Operation, to handle special cases 
														for singapore users when using multi currencies calculation.
		19/08/2014	CR3717		XSZ004		Copy the 1st "normal broker" from CP window when creating claim
		06/06/2016  CR4307      SSX014      refactor to support currency hedge
	</HISTORY>
********************************************************************/

If uf_cargo_base_data(ai_vessel_nr, as_voyage_nr, ai_chart_nr, al_cerp_id, astr_claim_base_data) Then

	// Select appropriate data into the ASTR_CLAIM_BASE_DATA structure
	SELECT CAL_CERP_TIMEBAR_DAYS,
	       CAL_CERP_NOTICEBAR_DAYS,
	       CAL_CERP_ADD_COMM,
	       CAL_CERP_DATE,
	       CAL_CERP_DESCRIPTION,
	       CAL_CERP_OFFICE_NR
	  INTO :astr_claim_base_data.timebar_days,
	       :astr_claim_base_data.noticebar_days,
	       :astr_claim_base_data.address_com,
	       :astr_claim_base_data.cp_date,
	       :astr_claim_base_data.cp_text,
	       :astr_claim_base_data.office_nr
	  FROM CAL_CERP
	 WHERE CAL_CERP_ID = :al_cerp_id
	 USING SQLCA;

	// If ok, then get select the broker nr, and % from the CAL_COMM table. 
	If SQLCA.SQLCode = 0 Then
      SELECT TOP 1 CAL_COMM.BROKER_NR, CAL_COMM.CAL_COMM_PERCENT
        INTO :astr_claim_base_data.broker_nr, :astr_claim_base_data.broker_com
        FROM CAL_COMM, BROKERS
       WHERE CAL_CERP_ID = :al_cerp_id AND BROKERS.BROKER_NR = CAL_COMM.BROKER_NR
         AND BROKERS.BROKER_POOL_MANAGER <> 1 AND CAL_COMM.CAL_COMM_PERCENT > 0
       USING SQLCA;

		// Set the values to NULL if a database error happend during the select
		If SQLCA.SQLCode <> 0 Then 
			SetNull(astr_claim_base_data.broker_nr)
			SetNull(astr_claim_base_data.broker_com)
		End if

		Return(true)
	Else
		// We got some sort of SQLCA error, return false
		Return(false)
	End if
Else
	// Calc_id not found, show errorbox and return false
	MessageBox("System error", "Info: CALC ID not found")

	Return(false)
End if




end function

public function integer uf_frt_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_frt_data astr_frt_data[25]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MI + LN
   
 Date       : 30-7-96

 Description : Retrieves freight data, given the vessel nr., voyage nr., 
 					charterer nr. and C/P ID as arguments. Returns data in the 
					ASTR_FRT_DATA structure.
					 
 Arguments : AI_VESSEL_NR as integer, AS_VOYAGE_NR as string, 
 				 AI_CHART_NR as integer, AL_CERP_ID as long 
				 ASTR_FRT_DATA as S_FRT_DATA
				 
 Returns   : 0 = not found, 1 = reversible, >1 no. of data on cargo level

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-01-97		3.03			RM		Tilføjet CAL_CARG.CAL_CARG_FREIGHT_TYPE til group by under declare cursor  
23-01-09		17.02			RMO003	Added Bunker Escalation
************************************************************************************/
Long ll_calc_id, ll_no_cargos
Boolean lb_reversible
integer  li_add_lump, li_x

// Try to find to CALC_ID from AI_VESSEL_NR and AS_VOYAGE_NR. UF_VESSELVOYAGE_TO_CALC
// will return true and the CALC_ID in LL_CALC_ID
If uf_vesselvoyage_to_calc(ai_vessel_nr, as_voyage_nr, ll_calc_id) Then

	// Get the reversible freight status from the CP connected to this cargo
	SELECT CAL_CERP_REV_FREIGHT
	INTO :lb_reversible
	FROM CAL_CERP
	WHERE CAL_CERP_ID = :al_cerp_id
	USING SQLCA;
	COMMIT;

	// Declare the cursor for retrieving all freight data
	DECLARE cal_frt_cursor CURSOR FOR  
	SELECT CAL_CARG.CAL_CARG_ID,  
		CAL_CARG.CAL_CARG_WS_RATE,
		CAL_CARG.CAL_CARG_FLATRATE,
		CAL_CARG.CAL_CARG_FREIGHT_RATE_LOCAL_CURR,
		CAL_CARG.CAL_CARG_BUNKER_ESCALATION_LOCAL_CURR, 
		CAL_CARG.CAL_CARG_LUMPSUM_LOCAL_CURR,
		CAL_CARG.CAL_CARG_FREIGHT_TYPE,
		CAL_CARG.CAL_CARG_MIN_1,
		CAL_CARG.CAL_CARG_MIN_2,
		CAL_CARG.CAL_CARG_OVERAGE_1,
		CAL_CARG.CAL_CARG_OVERAGE_2,
		MIN(CAL_CAIO.CAL_CAIO_ID)
    	FROM CAL_CARG, CAL_CAIO  
 	WHERE (CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID) AND  
			( CAL_CALC_ID = :ll_calc_id ) AND  
         		( CAL_CERP_ID = :al_cerp_id) 
	GROUP BY CAL_CARG.CAL_CARG_ID,  
		CAL_CARG.CAL_CARG_WS_RATE,
		CAL_CARG.CAL_CARG_FLATRATE,
		CAL_CARG.CAL_CARG_FREIGHT_RATE_LOCAL_CURR,
		CAL_CARG.CAL_CARG_BUNKER_ESCALATION_LOCAL_CURR, 
		CAL_CARG.CAL_CARG_LUMPSUM_LOCAL_CURR,
		CAL_CARG.CAL_CARG_FREIGHT_TYPE, 
		CAL_CARG.CAL_CARG_MIN_1,
		CAL_CARG.CAL_CARG_MIN_2,
		CAL_CARG.CAL_CARG_OVERAGE_1,
		CAL_CARG.CAL_CARG_OVERAGE_2	
	ORDER BY CAL_CARG.CAL_CARG_ID 
	USING SQLCA ;

	// Open the cursor
	OPEN cal_frt_cursor;

	ll_no_cargos = 0

	// and fetch all data into the astr_frt_data structure
	DO UNTIL SQLCA.SQLCode <> 0
		ll_no_cargos ++

		FETCH cal_frt_cursor 
		INTO :astr_frt_data[ll_no_cargos].cargoid, 
			 :astr_frt_data[ll_no_cargos].ws_pct,
			 :astr_frt_data[ll_no_cargos].ws_rate,		
			 :astr_frt_data[ll_no_cargos].mts,
			 :astr_frt_data[ll_no_cargos].bunker_escalation,
			 :astr_frt_data[ll_no_cargos].lumpsum,
			 :astr_frt_data[ll_no_cargos].freight_type,
			 :astr_frt_data[ll_no_cargos].min_1,
			 :astr_frt_data[ll_no_cargos].min_2,
			 :astr_frt_data[ll_no_cargos].over_1,
			 :astr_frt_data[ll_no_cargos].over_2,
			 :astr_frt_data[ll_no_cargos].calcaioid;
			 
		IF SQLCA.SQLCode = 0 Then

			// Blank non-selected freight type
			CHOOSE CASE astr_frt_data[ll_no_cargos].freight_type
				CASE 1 // $ pr. ton
					astr_frt_data[ll_no_cargos].ws_pct = 0
					astr_frt_data[ll_no_cargos].ws_rate = 0
					astr_frt_data[ll_no_cargos].lumpsum = 0
				CASE 2 // $ pr. cbm
					astr_frt_data[ll_no_cargos].ws_pct = 0
					astr_frt_data[ll_no_cargos].ws_rate = 0
					astr_frt_data[ll_no_cargos].lumpsum = 0
					astr_frt_data[ll_no_cargos].bunker_escalation = 0
				CASE 3 // Lumpsum
					astr_frt_data[ll_no_cargos].ws_pct = 0
					astr_frt_data[ll_no_cargos].ws_rate = 0
					astr_frt_data[ll_no_cargos].mts = 0
					astr_frt_data[ll_no_cargos].bunker_escalation = 0
				CASE 4 // Worldscale
					astr_frt_data[ll_no_cargos].mts = 0
					astr_frt_data[ll_no_cargos].lumpsum = 0
					astr_frt_data[ll_no_cargos].bunker_escalation = 0
			END CHOOSE
			
			// If reversible freight, the return only the first dataset.
			If lb_reversible Then
				// Declare the cursor for retrieving all addtional lumpsums data
				DECLARE cal_lumpsum_cursor_reversible CURSOR FOR  
				SELECT CAL_LUMP_ADD_LUMPSUM_LOCAL_CURR,
					CAL_LUMP_ADR_COMM,
					CAL_LUMP_BRO_COMM,
					CAL_LUMP_COMMENT
				FROM CAL_LUMP
				WHERE CAL_CARG_ID = :astr_frt_data[ll_no_cargos].cargoid
				USING SQLCA
				;
				// Open the cursor
				OPEN cal_lumpsum_cursor_reversible;
					li_add_lump = 0
				// and fetch all data into the astr_frt_data structure
				DO UNTIL SQLCA.SQLCode <> 0 
					li_add_lump ++ 
					FETCH cal_lumpsum_cursor_reversible 
					INTO :astr_frt_data[ll_no_cargos].addit_lump[li_add_lump],
							:astr_frt_data[ll_no_cargos].adr_com_lump[li_add_lump],
							:astr_frt_data[ll_no_cargos].bro_com_lump[li_add_lump],
							:astr_frt_data[ll_no_cargos].add_lump_comment[li_add_lump]
							;
				LOOP
				CLOSE cal_lumpsum_cursor_reversible;
				COMMIT;
				CLOSE cal_frt_cursor;
				Return(1)
			End if

			// Check that MIN and OVERAGE are legal
			If astr_frt_data[ll_no_cargos].min_1 = 0 And astr_frt_data[ll_no_cargos].over_1= 0 Then 
				SetNull(astr_frt_data[ll_no_cargos].min_1)
				SetNull(astr_frt_data[ll_no_cargos].over_1)
			End if

			If astr_frt_data[ll_no_cargos].min_2 = 0 And astr_frt_data[ll_no_cargos].over_2= 0 Then 
				SetNull(astr_frt_data[ll_no_cargos].min_2)
				SetNull(astr_frt_data[ll_no_cargos].over_2)
			End if
		End if
		
	LOOP

	CLOSE cal_frt_cursor;
	COMMIT;

for li_x = 1 to ll_no_cargos
	// Declare the cursor for retrieving all addtional lumpsums data
	DECLARE cal_lumpsum_cursor CURSOR FOR  
	SELECT CAL_LUMP_ADD_LUMPSUM_LOCAL_CURR,
		CAL_LUMP_ADR_COMM,
		CAL_LUMP_BRO_COMM,
		CAL_LUMP_COMMENT
	FROM CAL_LUMP
	WHERE CAL_CARG_ID = :astr_frt_data[li_x].cargoid
	USING SQLCA
	;
	// Open the cursor
	OPEN cal_lumpsum_cursor;
		li_add_lump = 0
	// and fetch all data into the astr_frt_data structure
	DO UNTIL SQLCA.SQLCode <> 0 
		li_add_lump ++ 
		FETCH cal_lumpsum_cursor 
		INTO :astr_frt_data[li_x].addit_lump[li_add_lump],
				:astr_frt_data[li_x].adr_com_lump[li_add_lump],
				:astr_frt_data[li_x].bro_com_lump[li_add_lump],
				:astr_frt_data[li_x].add_lump_comment[li_add_lump]
				;
	LOOP
	CLOSE cal_lumpsum_cursor;
	COMMIT;
next
	// Return the number of entries found
	Return(ll_no_cargos - 1)
Else
	// Return 0 - no data found
	Return(0)
End if
end function

public subroutine documentation ();/********************************************************************
	ObjectName: u_calc_nvo
	<OBJECT> Object Description </OBJECT>
	<USAGE>  Object Usage	</USAGE>
	<ALSO>   Other Objects	</ALSO>
	<HISTORY>
		Date      	CR-Ref	Author	Comments
		14/03/2011	CR1549	JSU   	Multi currencies
		19/08/2014	CR3717	XSZ004	Copy the 1st "normal broker" from CP window when creating claim
		20/04/16    CR2428   SSX014   Change demurrage currency
		06/06/16    CR4307   SSX014   To support currency hedge
		03/08/16    CR4219   LHG008   Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111)
	</HISTORY>    
********************************************************************/

end subroutine

public function boolean uf_cargo_base_data (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, long al_cerp_id, ref s_claim_base_data astr_claim_base_data);Long ll_calc_id
Integer ll_set_ex_rate = 0
n_claimcurrencyadjust lnv_claimcurrencyadjust
s_cargo_base_data lstr_cargo_base_data

// The code has been moved to n_claimcurrencyadjust
if lnv_claimcurrencyadjust.uf_cargo_base_data(ai_vessel_nr, as_voyage_nr, ai_chart_nr, al_cerp_id, lstr_cargo_base_data) then

	astr_claim_base_data.laycan_start = lstr_cargo_base_data.laycan_start
	astr_claim_base_data.laycan_end = lstr_cargo_base_data.laycan_end
	astr_claim_base_data.frt_curr_code = lstr_cargo_base_data.frt_curr_code
	astr_claim_base_data.fixed_exrate_enabled = lstr_cargo_base_data.fixed_exrate_enabled
	astr_claim_base_data.fixed_exrate = lstr_cargo_base_data.fixed_exrate
	astr_claim_base_data.claim_curr = lstr_cargo_base_data.claim_curr
	astr_claim_base_data.dem_curr_code = lstr_cargo_base_data.dem_curr_code
	astr_claim_base_data.dem_exrate = lstr_cargo_base_data.dem_exrate
	astr_claim_base_data.frt_exrate = lstr_cargo_base_data.frt_exrate
	astr_claim_base_data.set_ex_rate = lstr_cargo_base_data.set_ex_rate
	
	return true
end if

return false


end function

on u_calc_nvo.create
call super::create
end on

on u_calc_nvo.destroy
call super::destroy
end on

