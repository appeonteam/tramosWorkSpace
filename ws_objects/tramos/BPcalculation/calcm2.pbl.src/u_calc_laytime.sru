$PBExportHeader$u_calc_laytime.sru
$PBExportComments$Use in the check module to check the demurrage amount to be paid.
forward
global type u_calc_laytime from mt_n_nonvisualobject
end type
end forward

global type u_calc_laytime from mt_n_nonvisualobject
end type
global u_calc_laytime u_calc_laytime

type variables
Public s_calc_data istr_calc_data 
Private Boolean ib_prepared = false // True if the istr_calc_data structure is prepared




end variables

forward prototypes
private function double uf_rate_to_minutes (integer ai_ratetype, double ad_units, double ad_value)
private subroutine uf_prepare ()
public subroutine uf_calculate_laytime (integer ai_cargo_number)
public subroutine uf_clear ()
public function boolean uf_load_calc (long al_calc_id, ref transaction atsql)
public function double uf_calculate_rate (ref s_calc_cargo_data astr_cargo, integer ai_portno, double ad_units, ref double ad_estimated_minutes, ref double ad_calculated_minutes)
end prototypes

private function double uf_rate_to_minutes (integer ai_ratetype, double ad_units, double ad_value);/***********************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1998

 Description : Calculate time in minutes, given the ratetype in AI_RATETYPE,
 					units in AD_UNITS and additional value in AD_VALUE (hour, days)

 Arguments : AI_RATETYPE as integer, AD_UNITS, AD_VALUE as double.

 Returns   : Minutes as double

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	----- -------------------------------------
12-1-98	5			MI		Moved this function from uf_calculator 
24-04-13	CR2658	WWG004	Add a judgement for ad_value
************************************************************************************/

Double ld_min

if ad_value = 0 then 
	ld_min = 0
else
	CHOOSE CASE ai_ratetype
		CASE 0  // hours
			ld_min = (ad_value * 60) 
		CASE 1,2,3  // MTS/hour, Cubitmeters/Hour, Cubic feet/hour
			ld_min = (ad_units / ad_value) * 60
		CASE 4  //  Days
			ld_min = (ad_value * 1440) 
		CASE 5,6,7  // MTS/day, Cubitmeters/Day, Cubicfeet/Day
			ld_min = ((ad_units * 1440) / ad_value) 
		CASE ELSE
			ld_min = 0
	END CHOOSE
end if

Return(ld_min)
end function

private subroutine uf_prepare ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Prepares the istr_calc_data structure, by setting up default values:
 					Number of cargoes, number of ports in each cargo, total number of
					units.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
20/07/16		CR4219	LHG008	Fix bug
************************************************************************************/

If ib_prepared then Return // Return if already prepared

Integer li_count, li_unit_count
Double ld_total_units

istr_calc_data.i_number_of_cargoes = Upperbound(istr_calc_data.str_cargo)

For li_count = 1 To istr_calc_data.i_number_of_cargoes
	
	ld_total_units = 0
	
	// Set number of ports
	istr_calc_data.str_cargo[li_count].i_number_of_ports = & 
		Upperbound(istr_calc_data.str_cargo[li_count].str_port)
		
	// Calculate number of units
	For li_unit_count = 1 To istr_calc_data.str_cargo[li_count].i_number_of_ports
		If istr_calc_data.str_cargo[li_count].str_port[li_unit_count].d_units > 0 Then
			ld_total_units +=	istr_calc_data.str_cargo[li_count].str_port[li_unit_count].d_units
		End if
	Next
	
	istr_calc_data.str_cargo[li_count].d_total_units = ld_total_units
Next

ib_prepared = true

end subroutine

public subroutine uf_calculate_laytime (integer ai_cargo_number);/************************************************************************************
 uf_calculate_laytime (integer ai_cargo_number)
 
 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : August 1996

 Description : Calculates estimated/calculated time in ports, and demurrage/despatch 
 					where applicable. IMPORTANT: When calculating a reversible cargo,
					this routine automatically includes other cargos that is reversible
					with the cargo given in AI_CARGO_NUMBER, so this function is called for 
					each cargo, except for reversible cargoes, where this function only 
					should be called for the FIRST cargo on each C/P. 
					
					Set AI_CARGO_NUMBER to zero to calculate all cargoes
					
					AB_REVERSIBLE should be true if reversible.
					
 Arguments : ASTR_INOUTS[] as S_CALCULATION_CARGO_INOUT REF, 
 				 ASTR_PARM as S_CALCULATION_PARM REF, 
				 AB_REVERSIBLE as boolean, 
				 AI_CARGO_NUMBER as integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
13/03/13		CR2658	WWG004	Remove the EU port and it affect the consumption.
13/07/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
************************************************************************************/

Long		ll_time_difference // Difference between estimated and calculated
Integer	li_profit_center // Current profitcenter
Integer	li_count, li_cargo_count, li_freight_count
Integer	li_load_port  	 // Index to first loadport in the str_port_detail list, or current port if not reversible
Integer	li_disch_port 	 // Index to first dischport in the str_port_detail list, or current port if not reversible
Double	ld_units, ld_units_abs			 // Total number of units, is storen in the astr_port_detail	
Double	ld_eiu_time, ld_eiu_time_difference, ld_minutes, ld_estimated_minutes, ld_calculated_minutes
Boolean	lb_reversible, lb_continue
Integer	li_port_max, li_port_count, li_cho_port, li_firstcargo_cho
double	ld_notice_minutes
integer	li_port_no

s_calc_cargo_data lstr_cargo

// Prepare the datastructure, this will initialize the number of cargoes, ports etc.
If not ib_prepared then uf_prepare()

// Set reversible to true, if any of the cargoes is reversible
For li_cargo_count = 1 To istr_calc_data.i_number_of_cargoes
	If istr_calc_data.str_cargo[li_cargo_count].b_reversible_demurrage Then 
		lb_reversible = true
		exit
	End if
Next

// get the profit center no.
li_profit_center = uo_global.get_profitcenter_no( )

For li_Cargo_count = 1 To istr_calc_data.i_number_of_cargoes
	If (li_cargo_count = ai_cargo_number) Or (ai_cargo_number = 0) Then

		lb_reversible = istr_calc_data.str_cargo[li_cargo_count].b_reversible_demurrage
	
		li_load_port = 0 
		li_disch_port = 0
		li_cho_port = 0
		
		ld_estimated_minutes = 0
		ld_calculated_minutes = 0
				
		//Calculate the Notice time
		for li_port_no = 1 to upperbound(istr_calc_data.str_cargo[li_cargo_count].str_port)
			//Calculate each ports notice time
			ld_notice_minutes = istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_no].d_notice_time * 60
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_no].d_notice_minutes += ld_notice_minutes
		next
		
		// Calculate first total quantity, and find first load port and first dischport. First
		// loadport and dischport numbers are used to get the terms information later when
		// needed. First loadport is stored in the LI_FIRST_LOAD variable, first dischport
		// is stored in the LI_FIRST_DISCH variable. LD_UNITS is the sum of units for this
		// cargo.
		//
		// NOTE: Loadports will ALWAYS be stored first in the ASTR_INOUTS array.

		if lb_reversible Then
			
			li_port_max = 1
			ld_units = istr_calc_data.str_cargo[li_cargo_count].d_total_units	

			for li_count = 1 to istr_calc_data.str_cargo[li_cargo_count].i_number_of_ports
				if istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_units > 0 then 
					if li_load_port = 0 then
						li_load_port = li_count
					else
						istr_calc_data.str_cargo[li_cargo_count].str_port[li_load_port].d_estimated &
								+= istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_estimated
								
						istr_calc_data.str_cargo[li_cargo_count].str_port[li_load_port].d_calculated &
								+= istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_calculated
					end if
				elseif istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_units < 0 then
					if li_disch_port = 0 then
						li_disch_port = li_count
					else
						istr_calc_data.str_cargo[li_cargo_count].str_port[li_disch_port].d_estimated &
								+= istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_estimated
								
						istr_calc_data.str_cargo[li_cargo_count].str_port[li_disch_port].d_calculated &
								+= istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_calculated
					end if
				elseif istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].s_purpose = "CHO" then
					if li_cho_port = 0 then
						li_firstcargo_cho = li_cargo_count
						li_cho_port = li_count
						lstr_cargo = istr_calc_data.str_cargo[li_cargo_count]
					else
						lstr_cargo.str_port[li_cho_port].d_estimated += istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_estimated
						lstr_cargo.str_port[li_cho_port].d_calculated += istr_calc_data.str_cargo[li_cargo_count].str_port[li_count].d_calculated
					end if
				end if
			next
		Else
			li_port_max = istr_calc_data.str_cargo[li_cargo_count].i_number_of_ports
		End if
		
		// If this cargo is reversible then check to see if we should include quantity
		// from other cargos in this calculation. All cargos that uses the same CP
		// should be included in this cargo. 
		If istr_calc_data.str_cargo[li_cargo_count].b_reversible_demurrage = true Then
		
			// Loop through all cargoes before this, and check if this cargo already
			// has been included in the calculation
		
			// Loop through all cargoes from the NEXT cargo (this + 1) and compare
			// the CP id. If the CP id is the same, then count the total quantity
			// for that cargo and add it to the total quantity in LD_UNITS.
			lb_continue = false
			
			For li_freight_count = 1 To istr_calc_data.i_number_of_cargoes

				If (li_freight_count <> li_cargo_count) And &
				   ((istr_calc_data.str_cargo[li_cargo_count].l_cerp_id = & 
					 istr_calc_data.str_cargo[li_freight_count].l_cerp_id)) Then
			
					If li_freight_count < li_cargo_count Then
						lb_continue = true
						Exit
					Else
						// Same CP, Include quantity for this. 
						ld_units += istr_calc_data.str_cargo[li_freight_count].d_total_units
						
						for li_count = 1 to istr_calc_data.str_cargo[li_freight_count].i_number_of_ports
							if istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_units > 0 then 
								
								istr_calc_data.str_cargo[li_cargo_count].str_port[li_load_port].d_estimated &
										+= istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_estimated
										
								istr_calc_data.str_cargo[li_cargo_count].str_port[li_load_port].d_calculated &
										+= istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_calculated
										
							elseif istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_units < 0 then
								
								istr_calc_data.str_cargo[li_cargo_count].str_port[li_disch_port].d_estimated &
										+= istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_estimated
										
								istr_calc_data.str_cargo[li_cargo_count].str_port[li_disch_port].d_calculated &
										+= istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_calculated
							elseif istr_calc_data.str_cargo[li_freight_count].str_port[li_count].s_purpose = "CHO" then
								if li_cho_port = 0 then
									li_firstcargo_cho = li_freight_count
									li_cho_port = li_count
									lstr_cargo = istr_calc_data.str_cargo[li_freight_count]
								else
									lstr_cargo.str_port[li_cho_port].d_estimated += istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_estimated
									lstr_cargo.str_port[li_cho_port].d_calculated += istr_calc_data.str_cargo[li_freight_count].str_port[li_count].d_calculated
								end if
							end if
						next
					End if
				End if
			Next
			
			If lb_continue then continue
		End if
		
		//Calculate each port's time
		For li_port_count = 1 To li_port_max 
			If not lb_reversible Then
				ld_units		 = istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_units
				ld_units_abs = abs(ld_units)
				
				ld_estimated_minutes = 0
				ld_calculated_minutes = 0
				
				ld_minutes = uf_calculate_rate(istr_calc_data.str_cargo[li_cargo_count], li_port_count, ld_units_abs, &
			 											 ld_estimated_minutes, ld_calculated_minutes)
				
				if ld_units > 0 then
					istr_calc_data.d_load_minutes += ld_minutes
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_minutes += ld_minutes
				elseif ld_units < 0 then
					istr_calc_data.d_disch_minutes += ld_minutes
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_minutes += ld_minutes
				elseif istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].s_purpose = "CHO" then
					istr_calc_data.d_cho_minutes += ld_minutes
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_minutes += ld_minutes
				end if
			else
				if li_load_port > 0 then
					ld_minutes = uf_calculate_rate(istr_calc_data.str_cargo[li_cargo_count], li_load_port, ld_units, &
															 ld_estimated_minutes, ld_calculated_minutes)
					
					istr_calc_data.d_load_minutes += ld_minutes
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_minutes += ld_minutes
				end if
				
				If li_disch_port > 0 Then
					ld_minutes = uf_calculate_rate(istr_calc_data.str_cargo[li_cargo_count], li_disch_port, ld_units, &
									ld_estimated_minutes, ld_calculated_minutes)
					
					istr_calc_data.d_disch_minutes += ld_minutes
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_minutes += ld_minutes
				End if
				
				If li_cho_port > 0 Then
					ld_minutes = uf_calculate_rate(lstr_cargo, li_cho_port, 0, &
									ld_estimated_minutes, ld_calculated_minutes)
					
					istr_calc_data.d_cho_minutes += ld_minutes
					istr_calc_data.str_cargo[li_firstcargo_cho].str_port[li_cho_port].d_minutes += ld_minutes
					istr_calc_data.str_cargo[li_firstcargo_cho].str_port[li_cho_port] = lstr_cargo.str_port[li_cho_port]
					istr_calc_data.str_cargo[li_firstcargo_cho].d_estimated_minutes = lstr_cargo.d_estimated_minutes
					istr_calc_data.str_cargo[li_firstcargo_cho].d_calculated_minutes = lstr_cargo.d_calculated_minutes
				End if
			End if
			
			If ld_calculated_minutes > 0 Then

				ll_time_difference = ld_calculated_minutes - ld_estimated_minutes
		
				// Calculate LL_TIME_DIF, Example:
				// Calculated:   Estimated:  LL_TIME_DIF:  Demurrage or Despatch:
				// 100           200         -100			 Despatch 
				// 200			  100         100           Demurage
				// 100			  100         0             None
				// Despatch is only calculated if the user is from a bulk profit center (3 or 5)
		
				If ll_time_difference > 0 Then // Estimated > Calculated, calculate	 demurrage
					istr_calc_data.str_cargo[li_cargo_count].d_demurrage += ll_time_difference * & 
					istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_demurrage
				Elseif ll_time_difference < 0 Then  // Estimated < Calculated, calculate despatch if Bulk profitcenter
					If (li_profit_center = 3) Or (li_profit_center = 5) Then  

						// Calculate despatch according to UU/EIU		
						If istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].i_usedtype <> 1 Then // UU
							istr_calc_data.str_cargo[li_cargo_count].d_despatch += ll_time_difference * &
							istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_despatch
						Else	//  Calculate despatch according to EIU rulez
							// This calculation follow a business rule defined by the BULK department.
							// Please check the helpfile for the explanation of this calculation.
							ld_eiu_time = (istr_calc_data.str_cargo[li_cargo_count].d_calculated_minutes / & 
												istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_ratefactor)

							ld_eiu_time_difference = (0 - (ld_estimated_minutes - ld_eiu_time))  // To change the sign (0 -) !!

							istr_calc_data.str_cargo[li_cargo_count].d_despatch += ld_eiu_time_difference  * & 
								istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_despatch
						End If
					End If
				End if
			End if
		Next 
		
		istr_calc_data.d_demurrage += istr_calc_data.str_cargo[li_cargo_count].d_demurrage
		istr_calc_data.d_despatch += istr_calc_data.str_cargo[li_cargo_count].d_despatch
	End if
Next // Cargo loop

end subroutine

public subroutine uf_clear ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-3-1998

 Description : Clears the instance data structures

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_data lstr_calc_data
istr_calc_data = lstr_calc_data

end subroutine

public function boolean uf_load_calc (long al_calc_id, ref transaction atsql);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 5-3-1998

 Description : Loads default calc data into the istr data structure

 Arguments : al_calc_id as long , atSQL transactionobject

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
19/03/13		CR2658	WWG004	Remove the EU port and add at port cousumption.  
************************************************************************************/

Boolean lb_ballast_voyage, lb_reversible_demurrage, lb_reversible_freight
Integer li_count, li_no_of_cargoes, li_cargo_count, li_port_count, li_ratetype, li_usedtype, li_contype
Long lstr_carg_id[], ll_cerp_id
String ls_description
Double ld_units, ld_ratefactor, ld_despatch, ld_demurrage, ld_estimated, ld_calculated

// Clear internal dataarrays
uf_clear();

// Get ballast voyage into lb_ballast_voyage
SELECT CAL_CALC_BALLAST_VOYAGE 
INTO :lb_ballast_voyage
FROM CAL_CALC
USING atSQL;
COMMIT;

// We cannot calculate anything on ballast voyages
If lb_ballast_voyage Then Return false

// Declare cursor for fetching all cargo information, and fetch into
// out data array
DECLARE CAL_CARG_CURSOR CURSOR FOR
SELECT CAL_CARG_DESCRIPTION,
	CAL_CARG_REV_CERP,
	CAL_CARG_REV_FREIGHT,
	CAL_CERP_ID,
	CAL_CARG_ID
FROM CAL_CARG
WHERE CAL_CARG.CAL_CALC_ID = :al_calc_id 
USING atSQL;

OPEN CAL_CARG_CURSOR;

li_count = 0

Do While atSQL.SQLCode = 0 

	li_count ++

	FETCH CAL_CARG_CURSOR INTO
		:ls_description,
		:lb_reversible_demurrage,
		:lb_reversible_freight,
		:ll_cerp_id,
		:lstr_carg_id[li_count];
		
	// Clear top cargo entry if we passed end of data
	If atSQL.SQLCode = 0 Then 
		
		istr_calc_data.str_cargo[li_count].s_description = ls_description
		istr_calc_data.str_cargo[li_count].b_reversible_demurrage = lb_reversible_demurrage
		istr_calc_data.str_cargo[li_count].b_reversible_freight = lb_reversible_freight
		istr_calc_data.str_cargo[li_count].l_cerp_id = ll_cerp_id
	End if		
Loop

CLOSE CAL_CARG_CURSOR;
COMMIT;

li_no_of_cargoes = Upperbound(istr_calc_data.str_cargo)

For li_cargo_count = 1 To li_no_of_cargoes
	DECLARE CAL_CAIO_CURSOR CURSOR FOR
	SELECT CAL_CAIO_NUMBER_OF_UNITS,	
		CAL_CAIO_LOAD_TERMS,
		CAL_RATY_MTDH,
		CAL_RATY_FACTOR,
		CAL_CAIO_DESPATCH,
		CAL_CAIO_DEMURRAGE,
		CAL_CAIO_RATE_ESTIMATED,
		CAL_CAIO_RATE_CALCULATED,
		PORT_CONS_ID
	FROM CAL_CAIO, CAL_RATY
	WHERE CAL_CARG_ID = :lstr_carg_id[li_cargo_count] AND
			CAL_RATY.CAL_RATY_ID = CAL_CAIO.CAL_RATY_ID
	ORDER BY CAL_CAIO_NUMBER_OF_UNITS DESC
	USING atSQL;
	
	OPEN CAL_CAIO_CURSOR;
	
	li_port_count = 0
	
	Do while atSQL.SQLcode = 0 

		li_port_count ++

		FETCH CAL_CAIO_CURSOR INTO
			:ld_units,
			:li_ratetype,
			:li_usedtype,
			:ld_ratefactor,
			:ld_despatch,
			:ld_demurrage,
			:ld_estimated,
			:ld_calculated,
			:li_contype;
			
		If atSQL.SQLCode = 0 Then 

			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_units = ld_units
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].i_ratetype = li_ratetype
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].i_usedtype = li_usedtype
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_ratefactor = ld_ratefactor
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_despatch = ld_despatch
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_demurrage = ld_demurrage
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_estimated = ld_estimated
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].d_calculated = ld_calculated
			istr_calc_data.str_cargo[li_cargo_count].str_port[li_port_count].l_contype_id = li_contype
		End if
	Loop
	
	CLOSE CAL_CAIO_CURSOR;
	COMMIT;
		
Next


Return true
end function

public function double uf_calculate_rate (ref s_calc_cargo_data astr_cargo, integer ai_portno, double ad_units, ref double ad_estimated_minutes, ref double ad_calculated_minutes);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS + TA
   
 Date       : 1998

 Description : Calculates the number of minutes used in each port. Takes the number
 					of units in AD_UNITS and the ports in ASTR_CARGO_DETAIL. Minutes 
					used is returned in the two fields D_ESTIMATED_MINUTES & 
					D_CALCULATED_MINUTES.

 Arguments : ASTR_PORT_DETAIL as S_CALCULATION_PORT_DETAIL

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// If the estimated time for this port is given, then call UF_CAL_RATE to calculate
// the rate for this port. Add the result to the AD_ESTIMATED_MINUTES.
If astr_cargo.str_port[ai_portno].d_estimated > 0 Then
	astr_cargo.str_port[ai_portno].d_estimated_minutes = &
		uf_rate_to_minutes(astr_cargo.str_port[ai_portno].i_ratetype, ad_units, astr_cargo.str_port[ai_portno].d_estimated) &
			* astr_cargo.str_port[ai_portno].d_ratefactor	

	ad_estimated_minutes += astr_cargo.str_port[ai_portno].d_estimated_minutes
End if

// If the calculated time for this port is given, then call UF_CAL_RATE to calculate
// the rate for this port. Add the result to the AD_CALCULATED_MINUTES.
If astr_cargo.str_port[ai_portno].d_calculated > 0 Then
	astr_cargo.str_port[ai_portno].d_calculated_minutes = & 
		uf_rate_to_minutes(astr_cargo.str_port[ai_portno].i_ratetype, ad_units, astr_cargo.str_port[ai_portno].d_calculated) &
			* astr_cargo.str_port[ai_portno].d_ratefactor	

	ad_calculated_minutes += astr_cargo.str_port[ai_portno].d_calculated_minutes
End if

astr_cargo.d_estimated_minutes	+= astr_cargo.str_port[ai_portno].d_estimated_minutes
astr_cargo.d_calculated_minutes	+= astr_cargo.str_port[ai_portno].d_calculated_minutes

If astr_cargo.str_port[ai_portno].d_calculated > 0 Then
	Return astr_cargo.str_port[ai_portno].d_calculated_minutes
Else
	Return astr_cargo.str_port[ai_portno].d_estimated_minutes
End if


end function

on u_calc_laytime.create
call super::create
end on

on u_calc_laytime.destroy
call super::destroy
end on

